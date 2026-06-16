# RCA Run Report — ethereum 0xa17001eb…ef6d9d


## Case overview

- **Chain**: ethereum (chain_id=1)
- **Tx hash**: `0xa17001eb39f867b8bed850de9107018a2d2503f95f15e4dceb7d68fff5ef6d9d`
- **Block**: 24626979
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 1043.84s (1043836 ms)
- **Finding**: Alkemi self-liquidation aliases borrower and liquidator collateral accounting


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
- **PoC net reproduced**: $89399.20
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

- Transaction: `0xa17001eb39f867b8bed850de9107018a2d2503f95f15e4dceb7d68fff5ef6d9d`
- Block: `24626979`
- Root call type: `CALL`
- Target/tx.to: `0xe408b52aefb27a2fb4f1cd760a76daa4bf23794b`
- Attacker: `0x0ed1c01b8420a965d7bd2374db02896464c91cd7`

## PoC Surfaces

| Role | Surface | Selector | Address | Steps |
|---|---|---|---|---|
| attacker_entry | attack(uint256,uint256) | `0xe1fa7638` | `0xe408b52aefb27a2fb4f1cd760a76daa4bf23794b` | `1` |
| attacker_callback | receiveFlashLoan(address[],uint256[],uint256[],bytes) | `0xf04f2707` | `0xe408b52aefb27a2fb4f1cd760a76daa4bf23794b` | `6` |
| attacker_callback | unknown | `entry` | `0xe408b52aefb27a2fb4f1cd760a76daa4bf23794b` | `8,269,908` |

## Economic Effect

- Reconciliation basis: `poc_selected_direct_attacker_gain`
- Verdict: `exact`
- Comparison basis: `incident_profit_oracle_usd`

| Source | Direction | Holder | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| poc_

_… truncated in final report; see source excerpt for full text._


## Multi-leg reconciliation

- Status: `pass`
- Basis: `poc_selected_direct_attacker_gain`
- Source: `economic_reproduction`
- Selected rows: 1
- Note: Verified selected gain-family rows are primary for this economic proof; incident drain/loss legs remain available in the incident context.

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| poc_selected_direct_attacker_gain | gain | `0x0ed1c01b8420a965d7bd2374db02896464c91cd7` | `tx_from_eoa` | `ETH` | 43.45395 | $89399.20 |


## Root cause analysis

- **Title**: Alkemi self-liquidation aliases borrower and liquidator collateral accounting
- **Severity**: `high`
- **Confidence**: `high`
- **Violated invariant**: A liquidation must be bounded by the target account's actual shortfall and must debit the borrower's collateral exactly once; when targetAccount equals liquidator for the same collateral asset, the net withdrawable collateral must not increase.

### Final root cause

AlkemiEarnPublic liquidateBorrow allows a caller to liquidate its own WETH borrow using the same WETH market as collateral. The liquidation amount helper computes the target shortfall but ignores it, and the liquidation state update treats borrower collateral and liquidator collateral as separate balances even when they are the same storage record. The reduced borrower balance is overwritten by the increased liquidator balance, creating inflated withdrawable supply that is drained through withdraw(max).

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x4822d9172e5b76b9db37b75f5552f9988f98a888` | `AlkemiEarnPublic proxy` | `primary vulnerable contract` | `0x85a948fd70b2b415bda93324581fb5fff1293df7` |
| `0x8125afd067094cd573255f82795339b9fe2a40ab` | `AlkemiWETH` | `asset wrapper drained as downstream effect` | `—` |

### Recommended fixes

- In liquidateBorrow, reject self-liquidation where targetAccount == msg.sender, or net borrower/liquidator collateral through one balance update when the storage keys alias.
- In calculateDiscountedRepayToEvenAmount, replace the maxClose numerator with accountShortfall_TargetUser and add tests proving zero shortfall yields zero closeable repay-to-even amount.
- Add regression tests for targetAccount == liquidator and assetBorrow == assetCollateral so liquidation cannot increase withdrawable supply.
