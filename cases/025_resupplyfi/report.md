# RCA Run Report — ethereum 0xffbbd492…a872d3


## Case overview

- **Chain**: ethereum (chain_id=1)
- **Tx hash**: `0xffbbd492e0605a8bb6d490c3cd879e87ff60862b0684160d08fd5711e7a872d3`
- **Block**: 22785461
- **Final quality**: `partial`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC, but RCA is partial.
- **Elapsed**: 1092.02s (1092015 ms)
- **Finding**: ResupplyPair borrow accepted freshly bootstrapped cvcrvUSD collateral at an oracle-derived value and minted 10M reUSD


## Reproduction quality

- **PoC status**: `verified`
- **Forge fmt**: `pass`
- **Forge build**: `pass`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`
- **RCA status**: `partial` / `partial`
- **RCA confidence**: `medium`

## Economic reproduction

- **Basis**: incident profit oracle usd
- **Verdict**: exact — PoC reproduces 99–101% of incident net loss.
- **Incident net loss**: unknown
- **PoC net reproduced**: $5588710.12
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

- Transaction: `0xffbbd492e0605a8bb6d490c3cd879e87ff60862b0684160d08fd5711e7a872d3`
- Block: `22785461`
- Root call type: `CREATE`
- Target/tx.to: `unknown`
- Attacker: `0x6d9f6e900ac2ce6770fd9f04f98b7b0fc355e2ea`

## Multi-leg reconciliation

- Status: `pass`
- Basis: `poc_selected_direct_attacker_gain`
- Source: `economic_reproduction`
- Selected rows: 2
- Note: Verified selected gain-family rows are primary for this economic proof; incident drain/loss legs remain available in the incident context.

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| poc_selected_direct_attacker_gain | gain | `0x6d9f6e900ac2ce6770fd9f04f98b7b0fc355e2ea` | `tx_from_eoa` | `ETH` | 803.850010949342901324 | $1972917.08 |
| poc_selected_direct_attacker_gain | gain | `0x6d9f6e900ac2ce6770fd9f04f98b7b0fc355e2ea` | `tx_from_eoa` | `USDC` | 0.000003616156705369 | $3615793.04 |


## Root cause analysis

- **Title**: ResupplyPair borrow accepted freshly bootstrapped cvcrvUSD collateral at an oracle-derived value and minted 10M reUSD
- **Severity**: `critical`
- **Confidence**: `medium`
- **Violated invariant**: A registered pair may mint reUSD debt only when the borrower's collateral value is reliable and manipulation-resistant; one freshly minted cvcrvUSD share must not collateralize a 10,000,000 reUSD borrow without independent liquidity, supply-maturity, or price-sanity bounds.

### Final root cause

ResupplyPair.borrow is the source-visible entitlement branch: after a one-share cvcrvUSD collateral setup, it updates an oracle-derived exchange rate, passes the post-action solvency check, and mints 10,000,000 reUSD through the registry. The broken invariant is that reUSD debt must be bounded by reliable collateral value; one freshly minted ERC4626 collateral share must not satisfy solvency for a giant mint solely through an unresolved oracle/share-price read. The exact oracle implementation and return formula are not present in the available evidence, so this is a partial RCA rather than a complete branch-level oracle formula claim.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x6e90c85a495d54c6d7e1f3400fef1f6e59f86bd6` | `ResupplyPair` | `primary vulnerable contract` | `—` |

### Recommended fixes

- In ResupplyPairCore.borrow/_updateExchangeRate/_isSolvent, require manipulation-resistant collateral valuation with liquidity, TWAP, mature-supply, or minimum-share-supply bounds before minting reUSD debt against ERC4626-style collateral.
- Cap borrowable value for freshly bootstrapped cvcrvUSD collateral and reject one-share collateral states unless the oracle can prove independent, non-manipulated asset value.

### Limitations

- missing_assumption: the oracle implementation at 0xcb7e25fbbd8afe4ce73d7dac647dbc3d847f3c82 and the exact getPrices(address) return formula are absent from the available evidence.
- The exact selector semantics for the oracle child call 0x07a2d13a are not decoded in the supplied selector database, so the RCA does not claim a complete entry-branch-to-oracle-solver arithmetic dataflow.
- Because the price/oracle branch that gates solvency is source-gapped, analysis_status is partial rather than complete.
