# RCA Run Report — bsc 0xef386a69…581877


## Case overview

- **Chain**: bsc (chain_id=56)
- **Tx hash**: `0xef386a69ca6a147c374258a1bf40221b0b6bd9bc449a7016dbe5240644581877`
- **Block**: 46843424
- **Final quality**: `partial`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC, but RCA is partial.
- **Elapsed**: 847.30s (847300 ms)
- **Finding**: Recursive referral claims drain BNB during RewardMarket callback flow


## Reproduction quality

- **PoC status**: `verified`
- **Forge fmt**: `pass`
- **Forge build**: `pass`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`
- **RCA status**: `partial` / `partial`
- **RCA confidence**: `medium`

## Economic reproduction

- **Basis**: holder-net USD loss
- **Verdict**: exact — PoC reproduces 99–101% of incident net loss.
- **Incident net loss**: $89971.96
- **PoC net reproduced**: $89906.76
- **USD ratio**: 0.999x

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

- Transaction: `0xef386a69ca6a147c374258a1bf40221b0b6bd9bc449a7016dbe5240644581877`
- Block: `46843424`
- Root call type: `CREATE`
- Target/tx.to: `unknown`
- Attacker: `0xfb1cc1548d039f14b02cff9ae86757edd2cdb8a5`

## Multi-leg reconciliation

- Status: `pass`
- Basis: `incident_drain`
- Source: `economic_reproduction`
- Selected rows: 1

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| incident_drain | loss | `0x9823e10a0bf6f64f59964be1a7f83090bf5728ab` | `storage_contract` | `BNB` | -138 | $-89971.96 |


## Root cause analysis

- **Title**: Recursive referral claims drain BNB during RewardMarket callback flow
- **Severity**: `critical`
- **Confidence**: `medium`
- **Violated invariant**: A referral payout entitlement must be consumed or locked before external callbacks/native transfers, and the same entitlement must not be claimable multiple times during one call chain.

### Final root cause

The transaction drains 0x9823e10a0bf6f64f59964be1a7f83090bf5728ab through a buyAsset and claimReferral sequence. execution steps calls buyAsset(uint256,uint256,address) with an attacker callback recipient, after which attacker callback/fallback code recursively calls claimReferral(address(0)); each visible claimReferral step pays 3 BNB back to attacker-controlled code. The likely failed invariant is that referral entitlement must be consumed or locked before any external/native transfer or callback can re-enter the payout path. Because verified source or branch-level execution summary for 0x9823 is missing, the exact payout formula, storage layout, and patch line are unresolved.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x9823e10a0bf6f64f59964be1a7f83090bf5728ab` | `unknown` | `primary vulnerable contract` | `—` |

### Recommended fixes

- In RewardMarket claimReferral/buyAsset referral accounting, consume or zero the claimable referral amount before any external callback or native transfer.
- Add a non-reentrant guard around claimReferral and buy/payout paths that can invoke recipient callbacks.
- Require each referral payout to be bounded by a source-visible unpaid entitlement and emit/update the consumed amount before transfer.

### Limitations

- Verified source or branch-level execution summary for 0x9823e10a0bf6f64f59964be1a7f83090bf5728ab is absent.
- Exact referral payout formula and claim-consumption storage semantics are unavailable.
- No source line can be named for the vulnerable RewardMarket branch, so analysis_status is partial.
