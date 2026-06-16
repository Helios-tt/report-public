# RCA Run Report — ethereum 0x44037ffc…55b6ba


## Case overview

- **Chain**: ethereum (chain_id=1)
- **Tx hash**: `0x44037ffc0993327176975e08789b71c1058318f48ddeff25890a577d6555b6ba`
- **Block**: 21608070
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 812.34s (812337 ms)
- **Finding**: UnilendV2Pool rounded down collateral-share burns during redeemUnderlying, letting a borrower withdraw collateral while stETH debt remained solvent on paper


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
- **Incident net loss**: $1196784.20
- **PoC net reproduced**: $197032.35
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

- Transaction: `0x44037ffc0993327176975e08789b71c1058318f48ddeff25890a577d6555b6ba`
- Block: `21608070`
- Root call type: `CALL`
- Target/tx.to: `0x3f814e5fae74cd73a70a0ea38d85971dfa6fda21`
- Attacker: `0x55f5f8058816d5376df310770ca3a2e294089c33`

## Multi-leg reconciliation

- Status: `pass`
- Basis: `poc_selected_direct_attacker_gain`
- Source: `economic_reproduction`
- Selected rows: 2
- Note: Verified selected gain-family rows are primary for this economic proof; incident drain/loss legs remain available in the incident context.

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| poc_selected_direct_attacker_gain | gain | `0x3f814e5fae74cd73a70a0ea38d85971dfa6fda21` | `attacker_entry` | `stETH` | 0.000000000000000001 | $0.00 |
| poc_selected_direct_attacker_gain | gain | `0x55f5f8058816d5376df310770ca3a2e294089c33` | `tx_from_eoa` | `stETH` | 60.672854887643676586 | $197032.35 |


## Root cause analysis

- **Title**: UnilendV2Pool rounded down collateral-share burns during redeemUnderlying, letting a borrower withdraw collateral while stETH debt remained solvent on paper
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: A collateral redemption must burn at least the conservative round-up number of lending shares for the requested underlying and must leave the borrower's remaining collateral value sufficient for all outstanding opposite-token debt.

### Final root cause

UnilendV2Pool.redeemUnderlying(uint256,int256,address) computes the token0 lend shares to burn with getShareByValue, whose integer division rounds down. After a flash-sized USDC collateral deposit and stETH borrow, the attacker redeemed the USDC underlying; the rounded-down burn left enough recorded token0 lend shares for checkHealthFactorLtv1 to pass, so the branch transferred the underlying instead of rejecting the undercollateralized position. The stETH borrow remained as bad debt and the attacker exited with the borrowed stETH.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x4e34dd25dbd367b1bf82e1b5527dbbe799fad0d0` | `UnilendV2Pool` | `primary vulnerable contract` | `0xc86d2555f8c360d3c5e8e4364f42c1f2d169330e` |
| `0x7f2e24d2394f2bdabb464b888cb02eba6d15b958` | `UnilendV2Core` | `router into vulnerable pool accounting` | `—` |

### Recommended fixes

- In UnilendV2Pool.redeemUnderlying, compute shares to burn with rounding up for underlying redemptions, especially collateral withdrawals.
- Before transferring redeemed underlying, explicitly require that the remaining collateral value after the withdrawal covers all outstanding borrow shares for the opposite token.
- Add regression tests for flash-sized lend, borrow, redeemUnderlying, and repeated collateral withdrawal paths with divisibility/rounding edge cases.

### Limitations

- The RCA explains the Unilend stETH drain and reproduced stETH profit; the separate USDC balance delta on Morpho is recorded as impact context but is not needed for the selected Unilend root-cause claim.
