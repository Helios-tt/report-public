# RCA Run Report — bsc 0x63ac9bc4…3ff3a0


## Case overview

- **Chain**: bsc (chain_id=56)
- **Tx hash**: `0x63ac9bc4e53dbcfaac3a65cb90917531cfdb1c79c0a334dda3f06e42373ff3a0`
- **Block**: 44555338
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 682.30s (682296 ms)
- **Finding**: Public Pledge swap helper lets any caller sell contract-held MFT to an arbitrary recipient


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
- **Incident net loss**: $15007.45
- **PoC net reproduced**: $15007.45
- **USD ratio**: 1.000x

## Attack narrative

_No standalone `attack_flow.md` was available; this section is assembled from RCA report fields._

### RCA-derived flow

Pledge selector 0xadb1c581 / swapTokenU(uint256,address) is public and lacks owner/internal authorization while operating on Pledge-held MFT. The function approves the Pancake router for MAX MFT and swaps a caller-specified amount with amountOutMin set to zero to caller-specified _target. The attacker supplied nearly the full Pledge MFT balance and the attacker EOA as recipient, causing the Pancake MFT/USDT pair to send USDT to the attacker.

**Violated invariant**: Contract-held MFT may only be swapped by authorized protocol logic, for bounded amounts, to approved treasury/protocol recipients with a meaningful output constraint.

| Field | Value |
|---|---|
| Entry function | attacker helper 0x280d41a0 -> Pledge 0xadb1c581 / swapTokenU(uint256,address) |
| Callback is root cause | false |

### Observed impact

| Token | Amount | Token address |
|---|---:|---|
| `USDT` | 14994.304057732608091714 | `0x55d398326f99059ff775485246999027b3197955` |

### Evidence Summary

- **poc_verification** (`evidence summary`): Verified economic PoC passes and reproduces attacker USDT profit exactly, with no hard static validation blocker.
- **balance_impact** (`evidence summary`): Evidence summary shows direct asset loss: PancakePair loses USDT and attacker EOA gains the same USDT amount; entitlement/accounting anomaly requires not stopping at transfer steps.
- **evidence** (`evidence summary`): Evidence summary links Pledge selector 0xadb1c581 to MFT approval, router transferFrom, pair swap, and USDT transfer to attacker.
- **negative_evidence** (`evidence summary`): MFT totalSupply is unchanged, so the large MFT holder delta is not a mint; holder balance observations confirm MFT moved to the pair and USDT moved to the attacker.
- **attack_path** (`evidence summary`): PoC reproduces the closed-world call sequence: read Pledge MFT balance, then call Pledge selector 0xadb1c581 with large amount and attacker recipient.
- **source** (`evidence summary`): The function is public, approves router MAX, swaps MFT to USDT with amountOutMin=0, and sends output to caller-controlled _target without authorization.
- **source** (`evidence summary`): Router computes normal AMM output and enforces only amountOutMin; Pledge supplies amountOutMin=0, making router behavior downstream rather than root cause.
- **source** (`evidence summary`): Pair performs normal swap settlement after receiving MFT input; USDT transfer is the economic effect of the upstream Pledge authorization flaw.

## Multi-leg reconciliation

_Top incident drain/loss legs are shown first; gain and mechanical legs remain available in `report/run_summary.json`._

| Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| loss | `0x8b98e36dff7e5ad41b304fff2acf1d3d2368384a` | `storage_contract` | `USDT` | -14994.304057732608091714 | -$15007.45 |

## Root cause analysis

- **Title**: Public Pledge swap helper lets any caller sell contract-held MFT to an arbitrary recipient
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: Contract-held MFT may only be swapped by authorized protocol logic, for bounded amounts, to approved treasury/protocol recipients with a meaningful output constraint.

### Final root cause

Pledge selector 0xadb1c581 / swapTokenU(uint256,address) is public and lacks owner/internal authorization while operating on Pledge-held MFT. The function approves the Pancake router for MAX MFT and swaps a caller-specified amount with amountOutMin set to zero to caller-specified _target. The attacker supplied nearly the full Pledge MFT balance and the attacker EOA as recipient, causing the Pancake MFT/USDT pair to send USDT to the attacker.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x061944c0f3c2d7dabafb50813efb05c4e0c952e1` | `Pledge` | `primary vulnerable contract` | `—` |
| `0x8b98e36dff7e5ad41b304fff2acf1d3d2368384a` | `PancakePair` | `impacted liquidity pool / asset holder` | `—` |

### Recommended fixes

- Restrict Pledge.swapTokenU(uint256,address) with onlyOwner or a dedicated internal protocol role, and reject arbitrary external callers.
- Validate the swap recipient against approved treasury/protocol addresses instead of accepting arbitrary _target.
- Require a nonzero policy-derived amountOutMin or oracle/TWAP-bounded minimum output for any treasury token swap.
- Consider making swapTokenU internal/private if it is only intended as a helper for pledge flows.

### Limitations

- internal evidence was not present/readable through the bounded evidence reader, but PoC source, evidence summary, RPC, and victim source evidence were sufficient for the selected claim.
- selector evidence did not name selector 0xadb1c581; the source function identification is based on calldata shape and evidence summary child behavior matching Pledge.swapTokenU(uint256,address).
