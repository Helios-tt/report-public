# RCA Run Report — polygon 0x554c9e40…296fde


## Case overview

- **Chain**: polygon (chain_id=137)
- **Tx hash**: `0x554c9e4067e3bc0201ba06fc2cfeeacd178d7dd9c69f9b211bc661bb11296fde`
- **Block**: 65560669
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 587.92s (587924 ms)
- **Finding**: Public Lock claim pays the released BTC24H amount to any caller


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
- **PoC net reproduced**: $81437.47
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

- Transaction: `0x554c9e4067e3bc0201ba06fc2cfeeacd178d7dd9c69f9b211bc661bb11296fde`
- Block: `65560669`
- Root call type: `CALL`
- Target/tx.to: `0x3cb2452c615007b9ef94d5814765eb48b71ae520`
- Attacker: `0xde0a99fb39e78efd3529e31d78434f7645601163`

## PoC Surfaces

| Role | Surface | Selector | Address | Steps |
|---|---|---|---|---|
| attacker_entry | unknown | `0x00000000` | `0x3cb2452c615007b9ef94d5814765eb48b71ae520` | `1` |

## Economic Effect

- Reconciliation basis: `poc_selected_direct_attacker_gain`
- Verdict: `exact`
- Comparison basis: `incident_profit_oracle_usd`

| Source | Direction | Holder | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| poc_selected_direct_attacker_gain | gain | `0xde0a99fb39e78efd3529e31d78434f7645601163` | `WBTC` | 0.000000000076433345 | $81437.47 |
| poc_selected_direct_attacker_gain | gain | `0xde0a99fb39e78efd3529e31d78434f7645601163` | `USDT` | 0.000000004953025389 | N/A |


## Multi-leg reconciliation

- Status: `pass`
- Basis: `poc_selected_direct_attacker_gain`
- Source: `economic_reproduction`
- Selected rows: 2
- Note: Verified selected gain-family rows are primary for this economic proof; incident drain/loss legs remain available in the incident context.

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| poc_selected_direct_attacker_gain | gain | `0xde0a99fb39e78efd3529e31d78434f7645601163` | `tx_from_eoa` | `WBTC` | 0.000000000076433345 | $81437.47 |
| poc_selected_direct_attacker_gain | gain | `0xde0a99fb39e78efd3529e31d78434f7645601163` | `tx_from_eoa` | `USDT` | 0.000000004953025389 | N/A |


## Root cause analysis

- **Title**: Public Lock claim pays the released BTC24H amount to any caller
- **Severity**: `high`
- **Confidence**: `high`
- **Violated invariant**: Only the intended owner or recorded claim beneficiary may receive claims.amount from the Lock after release.

### Final root cause

The Lock contract's claim() function only checks release time and whether the claim was already used. It then marks the claim as used and transfers claims.amount to msg.sender, without requiring msg.sender to be owner or a recorded beneficiary. An attacker-controlled contract called claim() after release, received the full 110000 BTC24H locked balance, and then swapped the BTC24H into WBTC and USDT.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x968e1c984a431f3d0299563f15d48c395f70f719` | `Lock` | `primary vulnerable contract` | `—` |

### Recommended fixes

- At Lock.sol:51-56, require msg.sender to be the intended owner or a recorded beneficiary before claiming, and transfer the released amount to that beneficiary instead of arbitrary msg.sender.
- Store per-deposit beneficiary/accounting data and bind claims.amount to that beneficiary so public callers cannot redirect matured claims.
