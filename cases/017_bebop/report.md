# RCA Run Report — arbitrum 0xe5f8fe69…b7619d


## Case overview

- **Chain**: arbitrum (chain_id=42161)
- **Tx hash**: `0xe5f8fe69b38613a855dbcb499a2c4ecffe318c620a4c4117bd0e298213b7619d`
- **Block**: 367586045
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 751.99s (751993 ms)
- **Finding**: JamSettlement settle allowed empty self-orders to execute arbitrary calls using settlement allowances


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
- **Incident net loss**: $1.00
- **PoC net reproduced**: $20065.64
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

- Transaction: `0xe5f8fe69b38613a855dbcb499a2c4ecffe318c620a4c4117bd0e298213b7619d`
- Block: `367586045`
- Root call type: `CALL`
- Target/tx.to: `unknown`
- Attacker: `0x59537353248d0b12c7fcca56a4e420ffec4abc91`

## PoC Surfaces

| Role | Surface | Selector | Address | Steps |
|---|---|---|---|---|
| dynamic_instantiation | run() | `0xc0406226` | `0x091101b0f31833c03dddd5b6411e62a212d05875` | `3` |
| dynamic_instantiation | unknown | `entry` | `0x091101b0f31833c03dddd5b6411e62a212d05875` | `2` |
| attacker_entry | unknown | `0x60806040` | `0x267acd62e4bc7c2edbb73f9698050e99833c64f6` | `1` |

## Economic Effect

- Reconciliation basis: `poc_selected_direct_attacker_gain`
- Verdict: `exact`
- Comparison basis: `incident_profit_oracle_usd`

| Source | Direction | Holder | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| poc_selected_direct_attacker_gain | gain | `0x59537353248d0b12c7fcca56a4e420ffec4abc91` | `USDC` | 0.000000020069560783 | $20065.64 |


## Multi-leg reconciliation

- Status: `pass`
- Basis: `poc_selected_direct_attacker_gain`
- Source: `economic_reproduction`
- Selected rows: 1
- Note: Verified selected gain-family rows are primary for this economic proof; incident drain/loss legs remain available in the incident context.

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| poc_selected_direct_attacker_gain | gain | `0x59537353248d0b12c7fcca56a4e420ffec4abc91` | `tx_from_eoa` | `USDC` | 0.000000020069560783 | $20065.64 |


## Root cause analysis

- **Title**: JamSettlement settle allowed empty self-orders to execute arbitrary calls using settlement allowances
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: Settlement interactions must not spend JamSettlement's external token authority unless the spend is explicitly authorized and reconciled by a nonempty validated order.

### Final root cause

JamSettlement.settle accepted a self-taker order with empty sell and buy arrays, then executed attacker-supplied interactions without binding the interaction targets or calldata to the order's declared assets. JamInteraction.runInteractions only blocks calls to the balanceManager, so the attacker could make JamSettlement call USDC.transferFrom against holders that had approved JamSettlement. The downstream USDC transfers were valid ERC20 allowance spends; the broken invariant is in JamSettlement's order/interactions validation.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0xbeb0b0623f66be8ce162ebdfa2ec543a522f4ea6` | `JamSettlement` | `primary vulnerable contract` | `—` |
| `0xaf88d065e77c8cc2239327c5edb3a432268e5831` | `USDC` | `downstream token whose allowance was consumed` | `0x86e721b43d4ecfa71119dd38c0f938a75fdb57b3` |

### Recommended fixes

- Reject zero-leg Jam orders in settle and require at least one signed nonzero sell/buy asset path before executing interactions.
- Restrict JamInteraction targets/calldata or validate post-interaction token deltas so arbitrary ERC20 transferFrom cannot spend JamSettlement allowances outside the order's signed limits.
- Move user token authority to the BalanceManager-only path and ensure settlement interactions cannot call tokens as JamSettlement for user-spending operations.

### Limitations

- The evidence do not identify who originally granted the consumed USDC allowances to JamSettlement; this does not affect the in-transaction patchable root cause.
