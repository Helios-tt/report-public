# RCA Run Report — bsc 0xfb14292a…2d3a58


## Case overview

- **Chain**: bsc (chain_id=56)
- **Tx hash**: `0xfb14292a531411f852993e5a3ba4e7eb63ed548220267b9b3f4aacc5572d3a58`
- **Block**: 34428628
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 1031.30s (1031296 ms)
- **Finding**: BOB market-to-market transfers double-credit balances and inflate LP accounting


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
- **PoC net reproduced**: $726.47
- **USD ratio**: 1.004x

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

- Transaction: `0xfb14292a531411f852993e5a3ba4e7eb63ed548220267b9b3f4aacc5572d3a58`
- Block: `34428628`
- Root call type: `CALL`
- Target/tx.to: `0x0fe1983b8972630c866fe77ad873a66ec598b685`
- Attacker: `0xcb733f075ae67a83a9c5f38a0864596e338a0106`

## Multi-leg reconciliation

- Status: `pass`
- Basis: `poc_selected_direct_attacker_gain`
- Source: `economic_reproduction`
- Selected rows: 2
- Note: Verified selected gain-family rows are primary for this economic proof; incident drain/loss legs remain available in the incident context.

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| poc_selected_direct_attacker_gain | gain | `0x0fe1983b8972630c866fe77ad873a66ec598b685` | `attacker_callback` | `Cake-LP` | 0.016543552003957242 | N/A |
| poc_selected_direct_attacker_gain | gain | `0xcb733f075ae67a83a9c5f38a0864596e338a0106` | `tx_from_eoa` | `BNB` | 3.014911194134545218 | $726.47 |


## Root cause analysis

- **Title**: BOB market-to-market transfers double-credit balances and inflate LP accounting
- **Severity**: `high`
- **Confidence**: `high`
- **Violated invariant**: For every non-mint/non-burn BOB transfer, total credited balances for recipient plus fee recipients must not exceed the amount debited from the sender.

### Final root cause

BOBO_BOY._transfer treats both the Pancake router and BOB/WBNB pair as markets, but the non-excluded branch uses two independent market checks. When the pair transfers BOB to the router, both checks execute using the same initial fromBalance, so the pair is debited once while the router is credited twice minus fee and the fee wallet is also credited. PancakePair mint/swap accounting then trusts the inflated BOB balances, producing inflated LP entitlement and WBNB extraction.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x700ee24c350739e323dcf6a50ae3e7a3329c86ae` | `BOBO_BOY` | `primary vulnerable contract` | `—` |
| `0x7cafdaaa0ba0f471c800dbaca94bdb943311939d` | `PancakePair` | `downstream affected BOB/WBNB LP` | `—` |

### Recommended fixes

- Change BOBO_BOY._transfer so market cases are mutually exclusive or explicitly handle market-to-market transfers, and enforce that recipient plus fee credits never exceed the sender debit.
- Add invariant tests for normal, buy, sell, and market-to-market transfers asserting sum-of-balances conservation except explicit mint/burn.
