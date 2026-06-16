# RCA Run Report — ethereum 0xfab5912f…8e9fa2


## Case overview

- **Chain**: ethereum (chain_id=1)
- **Tx hash**: `0xfab5912f858b3768b7b7d312abcc02b64af7b1e1b62c4f29a2c1a2d1568e9fa2`
- **Block**: 21230768
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 577.83s (577830 ms)
- **Finding**: MainnetSettler BASIC action can be abused as an approved ERC20 spender through arbitrary pool calldata


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
- **Incident net loss**: $72272.14
- **PoC net reproduced**: $72272.14
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

- Transaction: `0xfab5912f858b3768b7b7d312abcc02b64af7b1e1b62c4f29a2c1a2d1568e9fa2`
- Block: `21230768`
- Root call type: `CREATE`
- Target/tx.to: `unknown`
- Attacker: `0x3a38877312d1125d2391663cba9f7190953bf2d9`

## PoC Surfaces

| Role | Surface | Selector | Address | Steps |
|---|---|---|---|---|
| attacker_entry | unknown | `entry` | `0x95b4fecf1f5b9c56ce51ebfedd582c5f40f2ef8c` | `1` |
| dynamic_instantiation | unknown | `entry` | `0x95b4fecf1f5b9c56ce51ebfedd582c5f40f2ef8c` | `2` |

## Economic Effect

- Reconciliation basis: `incident_drain`
- Verdict: `exact`
- Comparison basis: `holder_net_usd_loss`

| Source | Direction | Holder | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| incident_drain | loss | `0xa31d98b1aa71a99565ec2564b81f834e90b1097b` | `Hold` | -308453642.481581939556432141 | $-72272.14 |


## Multi-leg reconciliation

- Status: `pass`
- Basis: `incident_drain`
- Source: `economic_reproduction`
- Selected rows: 1

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| incident_drain | loss | `0xa31d98b1aa71a99565ec2564b81f834e90b1097b` | `transfer_counterparty` | `Hold` | -308453642.481581939556432141 | $-72272.14 |


## Root cause analysis

- **Title**: MainnetSettler BASIC action can be abused as an approved ERC20 spender through arbitrary pool calldata
- **Severity**: `high`
- **Confidence**: `high`
- **Violated invariant**: A public settlement action must not let arbitrary callers use the Settler's approved-spender identity to call arbitrary ERC20 transfer/approve calldata against third-party owners.

### Final root cause

MainnetSettler executes an attacker-supplied BASIC action through basicSellToPool with sellToken set to address(0). In that branch, the contract does not bind the external call to authenticated payer funds or a legitimate swap target, so it forwards arbitrary calldata to the caller-chosen pool. The attacker chose the Hold token as pool and encoded transferFrom from a holder that had approved MainnetSettler, causing Hold to treat MainnetSettler as the spender and transfer the holder's balance to the attacker.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x70bf6634ee8cb27d04478f184b9b8bb13e5f4710` | `MainnetSettler` | `primary vulnerable contract` | `—` |

### Recommended fixes

- In basicSellToPool, reject or tightly restrict BASIC calls with sellToken == address(0) and arbitrary pool/data, and block ERC20 transfer/transferFrom/approve calls to arbitrary token contracts unless the payer/owner is authenticated for that exact transfer.
- Constrain BASIC pool targets to verified swap/settlement contracts or require a protocol-specific adapter that proves the call consumes only Settler-owned or authenticated payer funds.
