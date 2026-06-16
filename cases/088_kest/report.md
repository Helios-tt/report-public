# RCA Run Report — ethereum 0x2fcee04e…0bfc16


## Case overview

- **Chain**: ethereum (chain_id=56)
- **Tx hash**: `0x2fcee04e64e54f3dd9c15db9ae44e4cbdd57ab4c6f01941a3acf470dc60bfc16`
- **Block**: 34402344
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 873.05s (873051 ms)
- **Finding**: KEST market self-transfer fee logic leaves false AMM input that drains WBNB from the Pancake pair


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
- **PoC net reproduced**: $2222.10
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

- Transaction: `0x2fcee04e64e54f3dd9c15db9ae44e4cbdd57ab4c6f01941a3acf470dc60bfc16`
- Block: `34402344`
- Root call type: `CALL`
- Target/tx.to: `0xc25979956d6f6acfc3702c68dff7a4d871eee4aa`
- Attacker: `0x90c4c1aa895a086215765ec9639431309633b198`

## Multi-leg reconciliation

- Status: `pass`
- Basis: `poc_selected_direct_attacker_gain`
- Source: `economic_reproduction`
- Selected rows: 3
- Note: Verified selected gain-family rows are primary for this economic proof; incident drain/loss legs remain available in the incident context.

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| poc_selected_direct_attacker_gain | gain | `0x90c4c1aa895a086215765ec9639431309633b198` | `tx_from_eoa` | `Cake-LP` | 2146.320284844256899722 | N/A |
| poc_selected_direct_attacker_gain | gain | `0x90c4c1aa895a086215765ec9639431309633b198` | `tx_from_eoa` | `WBNB` | 9.019657610212775442 | $2222.10 |
| poc_selected_direct_attacker_gain | gain | `0xc25979956d6f6acfc3702c68dff7a4d871eee4aa` | `attacker_callback` | `BNB` | 0.000000053281539038 | $0.00 |


## Root cause analysis

- **Title**: KEST market self-transfer fee logic leaves false AMM input that drains WBNB from the Pancake pair
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: A market-to-market or self-transfer must not leave AMM balanceOf(pair) above reserves as reusable economic input; the net pair balance change must equal the requested transfer amount or revert.

### Final root cause

KEKESANTA._transfer runs separate buy and sell fee branches when both from and to are market addresses. For PancakePair.skim(pair), from == to == the KEST/WBNB pair, so both branches recompute writes from the same original fromBalance and the pair balance is reduced only by fees rather than by the full skim amount. The remaining KEST balance above reserves is then accepted by PancakePair.swap as amountIn, allowing WBNB output and leaving the attacker with Cake-LP entitlement from the earlier mint.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x7dda132dd57b773a94e27c5caa97834a73510429` | `KEKESANTA` | `primary vulnerable contract` | `—` |
| `0x2d9ffa7ea5d1aaaba58e60168517b49f57e7f85b` | `PancakePair` | `impacted AMM accounting consumer` | `—` |

### Recommended fixes

- In KEKESANTA._transfer, make buy/sell fee logic mutually exclusive and handle from == to or market-to-market transfers by reverting or applying a single balance update whose net pair balance delta equals the requested transfer amount.
- Add invariant tests for pair-to-pair, router-to-pair, and pair-to-router transfers asserting that balanceOf(pair) cannot remain above reserves after skim(pair) except for deliberately unreconciled external deposits.
- Avoid emitting Transfer(amount) when the balance delta is not the emitted amount; if fee-on-transfer behavior is desired, emit fee and net transfer events consistently with the actual balance updates.
