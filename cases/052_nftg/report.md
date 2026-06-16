# RCA Run Report — ethereum 0xbd330fd1…bd28f6


## Case overview

- **Chain**: ethereum (chain_id=56)
- **Tx hash**: `0xbd330fd17d0f825042474843a223547132a49abb0746a7e762a0b15cf4bd28f6`
- **Block**: 44348367
- **Final quality**: `partial`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC, but RCA is partial.
- **Elapsed**: 794.91s (794910 ms)
- **Finding**: PresaleWithUSDT overpays USDT relative to validated purchase amount


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
- **Incident net loss**: $10044.11
- **PoC net reproduced**: $10044.11
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

- Transaction: `0xbd330fd17d0f825042474843a223547132a49abb0746a7e762a0b15cf4bd28f6`
- Block: `44348367`
- Root call type: `CALL`
- Target/tx.to: `0x6def9e4a6bb9c3bfe0648a11d3fff14447079e78`
- Attacker: `0x5af00b07a55f55775e4d99249dc7d81f5bc14c22`

## PoC Surfaces

|

_… truncated in final report; see source excerpt for full text._


## Multi-leg reconciliation

- Status: `pass`
- Basis: `incident_drain`
- Source: `economic_reproduction`
- Selected rows: 1

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| incident_drain | loss | `0x5fbbb391d54f4fb1d1cf18310c93d400bc80042e` | `storage_contract` | `USDT` | -10044.490614704315622688 | $-10044.11 |


## Root cause analysis

- **Title**: PresaleWithUSDT overpays USDT relative to validated purchase amount
- **Severity**: `high`
- **Confidence**: `medium`
- **Violated invariant**: PresaleWithUSDT must not transfer more USDT from contract reserves than the caller's validated paid amount or priced entitlement permits.

### Final root cause

The in-transaction causal step is 0x5fbbb391d54f4fb1d1cf18310c93d400bc80042e selector 0x85d07203 / PresaleWithUSDT(uint256,address). Repeated calls with amount 76500000000000000000 caused the contract to pull 76.5 USDT from the attacker and then transfer 989635670427665056608 USDT back to the attacker contract, violating the invariant that presale payout must be bounded by paid value or a source-visible priced entitlement. The exact branch/formula/helper is not source-visible in the available evidence, so this is partial rather than complete.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x5fbbb391d54f4fb1d1cf18310c93d400bc80042e` | `unknown` | `primary vulnerable contract` | `—` |
| `0x55d398326f99059ff775485246999027b3197955` | `BEP20USDT` | `asset token moved by vulnerable contract` | `—` |

### Recommended fixes

- In 0x5fbbb... PresaleWithUSDT, locate the branch/formula that computes outbound USDT payout and enforce payout <= validated paid amount or priced entitlement before any USDT transfer.
- Add a caller-visible min/max bound or slippage check for the presale conversion and reject repeated same-transaction payouts that exceed configured sale reserves or per-buyer limits.
- Fetch or recover source/decompiled branch for selector 0x85d07203 before deploying a patch, because the exact arithmetic/helper is not present in the available evidence.

### Limitations

- source_formula_gap: verified source/body for 0x5fbbb391d54f4fb1d1cf18310c93d400bc80042e is absent under internal evidence, so the exact PresaleWithUSDT branch, helper, and patch line cannot be identified.
- missing_assumption: oracle reads are visible, but how 0x5fbbb... uses those answers in its payout formula is unavailable.
- overgeneralization: complete status would overstate the evidence because the amount-computing formula is missing.
