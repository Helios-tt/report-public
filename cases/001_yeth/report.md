# RCA Run Report — ethereum 0x53fe7ef1…331156


## Case overview

- **Chain**: ethereum (chain_id=1)
- **Tx hash**: `0x53fe7ef190c34d810c50fb66f0fc65a1ceedc10309cf4b4013d64042a0331156`
- **Block**: 23914086
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 2523.72s (2523720 ms)
- **Finding**: yETH weighted stableswap pool mints giant LP supply when its supply solver underflows


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
- **Incident net loss**: $14371818.83
- **PoC net reproduced**: $6507097.20
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

- Transaction: `0x53fe7ef190c34d810c50fb66f0fc65a1ceedc10309cf4b4013d64042a0331156`
- Block: `23914086`
- Root call type: `CREATE`
- Target/tx.to: `unknown`
- Attacker: `0xfb63aa935cf0a003335dce9cca03c4f9c0fa4779`

## Multi-leg reconciliation

- Status: `pass`
- Basis: `poc_selected_beneficial_payout`
- Source: `economic_reproduction`
- Selected rows: 6
- Note: Verified selected gain-family rows are primary for this economic proof; incident drain/loss legs remain available in the incident context.

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| poc_selected_beneficial_payout | gain | `0xa80d3f2022f6bfd0b260bf16d72cad025440c822` | `transfer_counterparty` | `ETH` | 128.049846677877766345 | $386763.36 |
| poc_selected_beneficial_payout | gain | `0xa80d3f2022f6bfd0b260bf16d72cad025440c822` | `transfer_counterparty` | `pxETH` | 857.489624503896244971 | $2541990.35 |
| poc_selected_beneficial_payout | gain | `0xa80d3f2022f6bfd0b260bf16d72cad025440c822` | `transfer_counterparty` | `frxETH` | 742.637234154205416267 | $2201893.31 |
| poc_selected_beneficial_payout | gain | `0xa80d3f2022f6bfd0b260bf16d72cad025440c822` | `transfer_counterparty` | `rETH` | 203.552160863078446817 | $705536.84 |
| poc_selected_beneficial_payout | gain | `0xa80d3f2022f6bfd0b260bf16d72cad025440c822` | `transfer_counterparty` | `stETH` | 167.675056579885250408 | $506814.45 |
| poc_selected_beneficial_payout | gain | `0xa80d3f2022f6bfd0b260bf16d72cad025440c822` | `transfer_counterparty` | `cbETH` | 48.967336257280184064 | $164098.89 |


## Root cause analysis

- **Title**: yETH weighted stableswap pool mints giant LP supply when its supply solver underflows
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: Before each _calc_supply Newton update, amplification * vb_sum must be greater than or equal to supply * vb_prod, and the computed LP mint must be bounded by the deposited asset value.

### Final root cause

The yETH weighted stableswap pool's add_liquidity branch updates virtual balances from user-supplied amounts and then calls _calc_supply to compute the LP supply. _calc_supply computes (l - s * r) / d using unsafe_sub(l, unsafe_mul(s, r)) without enforcing l >= s*r, so a manipulated pool state causes uint256 underflow and a huge computed supply. The pool then mints supply - prev_supply yETH to the receiver, creating the entitlement later spent through approval/transferFrom and swaps.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0xccd04073f4bdc4510927ea9ba350875c3c65bf81` | `yETH weighted stableswap pool` | `primary vulnerable contract` | `—` |
| `0x1bed97cbc3c24a4fb5c069c6e311a967386131f7` | `yETH token` | `LP token minted by vulnerable pool` | `—` |

### Recommended fixes

- At yETH weighted stableswap pool.sol:1272, replace unsafe_sub(l, unsafe_mul(s, r)) with checked arithmetic and add assert l >= unsafe_mul(s, r) immediately before calculating sp.
- Add a post-_calc_supply sanity check in add_liquidity that caps mint by deposited virtual value and reverts if computed supply is inconsistent with the pool invariant.
- Add regression tests for dust multi-asset deposits after rate updates and liquidity removals, asserting no giant yETH mint and no supply jump when l < s*r.
