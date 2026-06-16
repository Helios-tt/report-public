
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";

abstract contract Base is Test {
    address constant NATIVE_ASSET = address(0);

    struct ProfitLeg {
        address holder;
        address alternateHolder;
        address asset;
        string symbol;
        uint256 expectedDeltaRaw;
        bool strict;
        uint8 repairPolicy;
        bool balancerInternalBalance;
    }

    event ProfitObservation(string symbol, uint256 expectedDeltaRaw, int256 actualDelta);

    uint8 constant PROFIT_REPAIR_OBSERVE_ONLY = 0;
    ProfitLeg[] internal profitLegs;
    uint256[] internal beforeBalances;
    uint256[] internal beforeAlternateBalances;

    function _expectProfit(address holder, address alternateHolder, address asset, string memory symbol, uint256 amount)
        internal
    {
        profitLegs.push(
            ProfitLeg(holder, alternateHolder, asset, symbol, amount, true, PROFIT_REPAIR_OBSERVE_ONLY, false)
        );
    }

    function _logBalances(string memory label) internal view {
        console2.log(label);
        for (uint256 i = 0; i < profitLegs.length; i++) {
            console2.log(profitLegs[i].symbol, profitLegs[i].holder);
            console2.log("balance", _legBalance(profitLegs[i]));
            if (profitLegs[i].alternateHolder != address(0)) {
                console2.log(profitLegs[i].symbol, profitLegs[i].alternateHolder);
                console2.log("balance", _altBalance(profitLegs[i]));
            }
        }
    }

    function _snapProfit() internal {
        delete beforeBalances;
        delete beforeAlternateBalances;
        for (uint256 i = 0; i < profitLegs.length; i++) {
            beforeBalances.push(_legBalance(profitLegs[i]));
            beforeAlternateBalances.push(_altBalance(profitLegs[i]));
        }
    }

    function _assertProfit() internal {
        if (profitLegs.length == 0) {
            console2.log("PoCWarning", "no profit/economic oracle generated", "execution reachability only");
            return;
        }
        _checkProfit();
    }

    function _checkProfit() internal {
        require(profitLegs.length > 0, "no profit oracle generated");
        bool anyPositive;
        bool anyCloseToExpected;
        bool hasStrictProfitLeg;
        uint256 aggregateExpected;
        uint256 aggregateActual;
        for (uint256 i = 0; i < profitLegs.length; i++) {
            uint256 afterBalance = _legBalance(profitLegs[i]);
            uint256 afterAlternateBalance = _altBalance(profitLegs[i]);
            int256 primaryDelta = _signed(afterBalance) - _signed(beforeBalances[i]);
            int256 alternateDelta = _signed(afterAlternateBalance) - _signed(beforeAlternateBalances[i]);
            int256 delta = primaryDelta >= alternateDelta ? primaryDelta : alternateDelta;
            emit ProfitObservation(profitLegs[i].symbol, profitLegs[i].expectedDeltaRaw, delta);
            console2.log("ProfitObservation", profitLegs[i].symbol, profitLegs[i].expectedDeltaRaw);
            console2.logInt(delta);
            if (profitLegs[i].strict) hasStrictProfitLeg = true;
            aggregateExpected += profitLegs[i].expectedDeltaRaw;
            if (delta > 0) {
                anyPositive = true;
                uint256 actual = uint256(delta);
                aggregateActual += actual;
                if (profitLegs[i].expectedDeltaRaw < 1000000) {
                    uint256 dustDiff = actual > profitLegs[i].expectedDeltaRaw
                        ? actual - profitLegs[i].expectedDeltaRaw
                        : profitLegs[i].expectedDeltaRaw - actual;
                    if (dustDiff <= 1000000) anyCloseToExpected = true;
                } else if (
                    actual * 100 >= profitLegs[i].expectedDeltaRaw * 50
                        && actual * 100 <= profitLegs[i].expectedDeltaRaw * 400
                ) {
                    anyCloseToExpected = true;
                }
            }
        }
        if (!anyCloseToExpected && aggregateExpected > 0 && aggregateActual > 0) {
            anyCloseToExpected =
                aggregateActual * 100 >= aggregateExpected * 50 && aggregateActual * 100 <= aggregateExpected * 400;
        }
        if (!hasStrictProfitLeg) return;
        require(anyPositive, "no positive actual profit leg");
        require(anyCloseToExpected, "actual profit delta outside expected band");
    }

    function _legBalance(ProfitLeg memory leg) internal view returns (uint256) {
        if (leg.balancerInternalBalance) return _balIntBal(leg.holder, leg.asset);
        if (leg.asset == NATIVE_ASSET) return leg.holder.balance;
        return _safeTokenBalance(leg.asset, leg.holder);
    }

    function _altBalance(ProfitLeg memory leg) internal view returns (uint256) {
        if (leg.alternateHolder == address(0)) return 0;
        if (leg.balancerInternalBalance) return _balIntBal(leg.alternateHolder, leg.asset);
        if (leg.asset == NATIVE_ASSET) return leg.alternateHolder.balance;
        return _safeTokenBalance(leg.asset, leg.alternateHolder);
    }

    function _balIntBal(address account, address token) internal view returns (uint256) {
        address[] memory tokens = new address[](1);
        tokens[0] = token;
        (bool ok, bytes memory data) = address(0xBA12222222228d8Ba445958a75a0704d566BF2C8)
            .staticcall(abi.encodeWithSignature("getInternalBalance(address,address[])", account, tokens));
        if (!ok || data.length < 32) return 0;
        uint256[] memory balances = abi.decode(data, (uint256[]));
        if (balances.length == 0) return 0;
        return balances[0];
    }

    function _safeTokenBalance(address token, address account) internal view returns (uint256) {
        if (token.code.length == 0) return 0;
        (bool ok, bytes memory data) = token.staticcall(abi.encodeWithSignature("balanceOf(address)", account));
        if (!ok || data.length < 32) return 0;
        return abi.decode(data, (uint256));
    }

    function _signed(uint256 value) internal pure returns (int256) {
        require(value <= uint256(type(int256).max), "balance too large");
        return int256(value);
    }

    function _prepareProfit(address attack, address attackChild) internal {
        _expectProfitLegs(attack, attackChild);
        _snapProfit();
    }

    function _expectProfitLegs(address attack, address attackChild) internal virtual {
        attack;
        attackChild;
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
