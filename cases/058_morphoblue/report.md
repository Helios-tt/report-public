# RCA Run Report — ethereum 0x256979ae…cb493b


## Case overview

- **Chain**: ethereum (chain_id=1)
- **Tx hash**: `0x256979ae169abb7fbbbbc14188742f4b9debf48b48ad5b5207cadcc99ccb493b`
- **Block**: 20956052
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 658.36s (658357 ms)
- **Finding**: Morpho borrow health check trusted stale Pyth adapter prices through Chainlink-style oracle wrappers


## Reproduction quality

- **PoC status**: `verified`
- **Forge fmt**: `pass`
- **Forge build**: `pass`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`
- **RCA status**: `complete` / `complete`
- **RCA confidence**: `high`

## Economic reproduction

- **Basis**: holder-net USD loss
- **Verdict**: exact — PoC reproduces 99–101% of incident net loss.
- **Incident net loss**: $229605.88
- **PoC net reproduced**: $229959.54
- **USD ratio**: 1.002x

## Attack narrative

_No standalone `attack_flow.md` was available; this section is assembled from RCA report fields._

### RCA-derived flow

Morpho's `borrow` path accepted the attacker's debt because `_isHealthy` valued PAXG collateral through `MorphoChainlinkOracleV2.price()`. That oracle called Chainlink-style Pyth aggregator adapters whose feed methods returned `pyth.getPriceUnsafe(priceId)` without validating recency, while `ChainlinkDataFeedLib` also ignored `updatedAt`/freshness. The violated invariant is that collateral prices used for lending health checks must be fresh and bounded before debt is issued.

**Violated invariant**: A borrow health check must only compare debt against collateral valued with fresh, bounded oracle prices; stale or unchecked prices must not authorize new debt.

| Field | Value |
|---|---|
| Entry function | multicall(bytes[]) / 0xac9650d8 on EthereumBundlerV2, leading to Morpho.borrow((address,address,address,address,uint256),uint256,uint256,address,address) |
| Attacker callbacks | true |
| Callback is root cause | false |

### Observed impact

| Token | Amount | Token address |
|---|---:|---|
| `USDC` | 230002.48667 | `0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48` |

### Evidence Summary

- **poc_verification** (`evidence summary`): Economic PoC is verified: all required pass statuses are present, proof_kind is economic_proof, and product static validation has zero hard blockers.
- **evidence** (`evidence summary`): Evidence summary identifies direct Morpho USDC loss, Morpho borrow as the top accounting/impact step, supplyCollateral as same-transaction collateral setup, oracle child execution steps as the health/price gate, and USDC transfer child as downstream asset movement.
- **balance_impact** (`evidence summary`): Morpho lost 230002486670 USDC and gained 132577813003136114 PAXG, while the attacker EOA gained 230002486670 USDC.
- **source** (`evidence summary`): PoC path supplies PAXG collateral for the attacker EOA, sets authorization, and calls Morpho.borrow for 230002486670 USDC to the attacker EOA.
- **source** (`evidence summary`): Morpho borrow updates debt then requires _isHealthy before transferring loanToken; _isHealthy computes maxBorrow from collateral, oracle price, and LLTV.
- **source** (`evidence summary`): Oracle price composes base and quote feed values into the collateral price consumed by Morpho's health check.
- **source** (`evidence summary`): Feed reader calls latestRoundData, checks only for non-negative answer, and explicitly does not check staleness or min/max bounds.
- **source** (`evidence summary`): Pyth Chainlink adapter returns values from pyth.getPriceUnsafe without recency validation.

## Multi-leg reconciliation

_Top incident drain/loss legs are shown first; gain and mechanical legs remain available in `report/run_summary.json`._

| Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| loss | `0xbbbbbbbbbb9cc5e90e3b3af64bdaf62c37eeffcb` | `storage_contract` | `USDC` | -230002.48667 | -$229959.54 |

## Root cause analysis

- **Title**: Morpho borrow health check trusted stale Pyth adapter prices through Chainlink-style oracle wrappers
- **Severity**: `high`
- **Confidence**: `high`
- **Violated invariant**: A borrow health check must only compare debt against collateral valued with fresh, bounded oracle prices; stale or unchecked prices must not authorize new debt.

### Final root cause

Morpho's `borrow` path accepted the attacker's debt because `_isHealthy` valued PAXG collateral through `MorphoChainlinkOracleV2.price()`. That oracle called Chainlink-style Pyth aggregator adapters whose feed methods returned `pyth.getPriceUnsafe(priceId)` without validating recency, while `ChainlinkDataFeedLib` also ignored `updatedAt`/freshness. The violated invariant is that collateral prices used for lending health checks must be fresh and bounded before debt is issued.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0xbbbbbbbbbb9cc5e90e3b3af64bdaf62c37eeffcb` | `Morpho` | `primary lending contract consuming unsafe oracle price in borrow health check` | `—` |
| `0xdd1778f71a4a1c6a0efebd8ae9f8848634ce1101` | `MorphoChainlinkOracleV2` | `oracle contract composing stale-unchecked feed values` | `—` |
| `0x7c4561bb0f2d6947beda10f667191f6026e7ac0c` | `PythAggregatorV3` | `base feed adapter using Pyth getPriceUnsafe` | `—` |
| `0xc5774412dbd3734a5925936f320ee91a2940488d` | `PythAggregatorV3` | `quote feed adapter using Pyth getPriceUnsafe` | `—` |

### Recommended fixes

- In the PythAggregatorV3 adapters, replace `pyth.getPriceUnsafe(priceId)` in feed methods with a recency-checked Pyth read such as `getPriceNoOlderThan(priceId, maxAge)` or enforce an equivalent `block.timestamp - publishTime <= maxAge` guard.
- In ChainlinkDataFeedLib.getPrice, validate Chainlink-compatible `updatedAt`/`answeredInRound` freshness before returning a feed answer to MorphoChainlinkOracleV2.price.
- Configure Morpho markets so borrow health checks only consume oracle contracts that reject stale or unsafe feed values.

### Limitations

- internal evidence was referenced by the evidence summary but not present/readable through the bounded evidence reader; PoC.t.sol, evidence summary steps, source, and asset deltas were sufficient for the selected causal claim.
- The exact stale feed publishTime/value was not available in bounded RPC observations; the patchable root cause is established from the source-visible absence of recency checks along the executed oracle path.
