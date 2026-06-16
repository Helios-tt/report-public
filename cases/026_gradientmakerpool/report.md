# RCA Run Report — ethereum 0xb5cfa3f8…4b1f67


## Case overview

- **Chain**: ethereum (chain_id=1)
- **Tx hash**: `0xb5cfa3f86ce9506e2364475dc43c44de444b079d4752edbffcdad7d1654b1f67`
- **Block**: 22765114
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 683.81s (683806 ms)
- **Finding**: GradientMarketMakerPool mints inflated LP shares from a decoupled totalLiquidity denominator


## Reproduction quality

- **PoC status**: `verified`
- **Forge fmt**: `pass`
- **Forge build**: `pass`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`
- **RCA status**: `complete` / `complete`
- **RCA confidence**: `high`

## Economic reproduction

- **Basis**: incident profit oracle usd
- **Verdict**: exact — PoC reproduces 99–101% of incident net loss.
- **Incident net loss**: unknown
- **PoC net reproduced**: $6661.22
- **USD ratio**: 1.000x

## Attack narrative

# Attack Flow

Generated from a verified Solidity reproduction and economic proof.

## Verification Gate

- Status: `pass`
- Execution status: `pass`
- Economic status: `pass`
- Proof kind: `economic_proof`
- Forge build: `pass`
- Forge test: `pass`

## Replay Target

- Transaction: `0xb5cfa3f86ce9506e2364475dc43c44de444b079d4752edbffcdad7d1654b1f67`
- Block: `22765114`
- Root call type: `CREATE`
- Target/tx.to: `unknown`
- Attacker: `0x1234567a98230550894bf93e2346a8bc5c3b36e3`

## PoC Surfaces

| Role | Surface | Selector | Address | Steps |
|---|---|---|---|---|
| attacker_entry | unknown | `entry` | `0x58117e82fa6522703493878f27c85c1702fedcca` |

_… truncated in final report; see source excerpt for full text._


## Multi-leg reconciliation

- Status: `pass`
- Basis: `poc_selected_direct_attacker_gain`
- Source: `economic_reproduction`
- Selected rows: 2
- Note: Verified selected gain-family rows are primary for this economic proof; incident drain/loss legs remain available in the incident context.

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| poc_selected_direct_attacker_gain | gain | `0x1234567a98230550894bf93e2346a8bc5c3b36e3` | `tx_from_eoa` | `WETH` | 2.346098333159028268 | $5257.19 |
| poc_selected_direct_attacker_gain | gain | `0xcb4059bb021f4cf9d90267b7961125210cedb792` | `dynamic_instantiation` | `GRAY` | 946.989100868295372906 | $1404.03 |


## Root cause analysis

- **Title**: GradientMarketMakerPool mints inflated LP shares from a decoupled totalLiquidity denominator
- **Severity**: `high`
- **Confidence**: `high`
- **Violated invariant**: LP shares must be minted only from a value-consistent denominator that represents the same pool asset base as outstanding LP shares and must not allow totalLiquidity to be far below totalLPShares without rejecting new mints.

### Final root cause

GradientMarketMakerPool.provideLiquidity uses the nonzero totalLPShares branch and computes lpSharesToMint as (tokenAmount + msg.value) * pool.totalLPShares / pool.totalLiquidity. In execution steps the attacker supplied 950 GRAY and 0.632090074270700494 ETH while the pool had totalLiquidity far below totalLPShares, so the formula minted 707569102721011712333070 LP shares. withdrawLiquidity(GRAY, 10000) then redeemed the inflated entitlement for pool ETH and GRAY.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x37ea5f691bce8459c66ffceeb9cf34ffa32fdadc` | `GradientMarketMakerPool` | `primary vulnerable contract` | `—` |

### Recommended fixes

- Replace GradientMarketMakerPool.sol lines 158-161 with a value-consistent LP mint formula based on the pool's own ETH/token reserves or invariant value, and reject mints when pool.totalLiquidity, pool.totalLPShares, pool.totalEth, and pool.totalToken are inconsistent.
- Ensure orderbook transfer/receive paths that change pool.totalEth, pool.totalToken, or pool.totalLiquidity also preserve LP share price invariants or separately account for orderbook inventory without changing the LP share denominator.

### Limitations

- The available evidence do not identify the prior transaction or actor that first produced the skew between pool.totalLiquidity and pool.totalLPShares; the selected patchable root cause is still complete because execution steps consumes that source-layout-backed state in the in-transaction mint formula.
