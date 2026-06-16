# RCA Run Report — ethereum 0x7e7f9548…bd21d1


## Case overview

- **Chain**: ethereum (chain_id=1)
- **Tx hash**: `0x7e7f9548f301d3dd863eac94e6190cb742ab6aa9d7730549ff743bf84cbd21d1`
- **Block**: 20671878
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 709.07s (709068 ms)
- **Finding**: Penpie accepted attacker-created Pendle markets as trusted receipt pools


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
- **Verdict**: unpriced — raw PoC proof passed, but USD comparison is incomplete.
- **Incident net loss**: unknown
- **PoC net reproduced**: unknown
- **USD ratio**: unknown

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

- Transaction: `0x7e7f9548f301d3dd863eac94e6190cb742ab6aa9d7730549ff743bf84cbd21d1`
- Block: `20671878`
- Root call type: `CALL`
- Target/tx.to: `0x4476b6ca46b28182944ed750e74e2bb1752f87ae`
- Attacker: `0x7a2f4d625fb21f5e51562ce8dc2e722e12a61d1b`

## Multi-leg reconciliation

- Status: `pass`
- Basis: `poc_profit_fallback`
- Source: `economic_reproduction`
- Selected rows: 2
- Note: Incident drain/loss legs were absent; verified PoC attacker-gain legs are recorded for reconciliation.

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| poc_profit | gain | `0x4476b6ca46b28182944ed750e74e2bb1752f87ae` | `attacker_callback` | `YT-What????-26DEC2024` | 10000000000 | N/A |
| poc_profit | gain | `0x4476b6ca46b28182944ed750e74e2bb1752f87ae` | `attacker_callback` | `PT-What????-26DEC2024-PRT` | 0.999999999999999 | N/A |


## Root cause analysis

- **Title**: Penpie accepted attacker-created Pendle markets as trusted receipt pools
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: Penpie receipt and reward pools must only be registered for governance-approved Pendle markets backed by trusted underlying assets, not for arbitrary factory-valid markets created from attacker-controlled SY contracts.

### Final root cause

Penpie's PendleMarketRegisterHelper.registerPenpiePool/_registerMarket branch treats Pendle factory isValidMarket as sufficient economic trust. An attacker can first create a Pendle PT/YT/market from an attacker-controlled SY whose balanceOf/exchangeRate callbacks fabricate backing, then register that market in Penpie and receive 1:1 receipt entitlement on deposit. The missing guard is a Penpie-side governance/allowlist/trusted-underlying check before registerPool creates a receipt/reward pool.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0xd20c245e1224fc2e8652a283a8f5cae1d83b353a` | `TransparentUpgradeableProxy/PendleMarketRegisterHelper` | `primary vulnerable contract` | `0x588f5e5d85c85cac5de4a1616352778ecd9110d3` |
| `0x6e799758cee75dae3d84e09d40dc416ecf713652` | `TransparentUpgradeableProxy/PendleStakingBaseUpg` | `receipt entitlement sink` | `0xff51c6b493c1e4df4e491865352353eadff0f9f8` |

### Recommended fixes

- Require owner/governance approval or a curated market/SY/PT allowlist in PendleMarketRegisterHelper before calling pendleStaking.registerPool.
- Treat Pendle factory isValidMarket as a structural check only; add Penpie-side validation that the market's SY and underlying assets are trusted before receipt or reward entitlement can be created.
- For already registered pools, add an emergency removal/quarantine path and verify receipt/reward state cannot be created for unapproved markets.

### Limitations

- The available evidence set contains no top negative asset delta, so this RCA classifies the transaction as loss-enabling entitlement creation rather than the final realized asset-loss transaction.
