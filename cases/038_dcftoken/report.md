# RCA Run Report — ethereum 0xb3759329…efd6fd


## Case overview

- **Chain**: ethereum (chain_id=56)
- **Tx hash**: `0xb375932951c271606360b6bf4287d080c5601f4f59452b0484ea6c856defd6fd`
- **Block**: 44290970
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 987.36s (987359 ms)
- **Finding**: DCF transfer hook syncs AMM reserves before completing the transfer, enabling reserve-accounting drain


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
- **Incident net loss**: $700289.51
- **PoC net reproduced**: $443075.81
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

- Transaction: `0xb375932951c271606360b6bf4287d080c5601f4f59452b0484ea6c856defd6fd`
- Block: `44290970`
- Root call type: `CALL`
- Target/tx.to: `0x77ab960503659711498a4c0bc99a84e8d0a47589`
- Attacker: `0x00c58434f247dfdca49b9ee82f3013bac96f60ff`

## Multi-leg reconciliation

- Status: `pass`
- Basis: `poc_selected_direct_attacker_gain`
- Source: `economic_reproduction`
- Selected rows: 2
- Note: Verified selected gain-family rows are primary for this economic proof; incident drain/loss legs remain available in the incident context.

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| poc_selected_direct_attacker_gain | gain | `0x77ab960503659711498a4c0bc99a84e8d0a47589` | `attacker_callback` | `USDT` | 442028.607465892649035455 | $443075.81 |
| poc_selected_direct_attacker_gain | gain | `0x77ab960503659711498a4c0bc99a84e8d0a47589` | `attacker_callback` | `DCF` | 0.985197002370912963 | N/A |


## Root cause analysis

- **Title**: DCF transfer hook syncs AMM reserves before completing the transfer, enabling reserve-accounting drain
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: A token transfer hook must not burn from its AMM pair or call pair.sync() before the transfer being priced by the AMM has completed.

### Final root cause

DCF._transfer's sell branch mutates its Pancake pair reserves before applying the user transfer. When `to == pairAddress && !swapping`, DCF swaps fees, calls the liquidity helper, then burns DCF from `pairAddress` and calls `sync()` before `super._transfer(from, to, amount)`. The attacker triggers that branch, then the downstream PancakePair swap computes input from the distorted balance/reserve state and releases USDT.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0xa7e92345ddf541aa5cf60fee2a0e721c50ca1adb` | `DCF` | `primary vulnerable contract` | `—` |
| `0x8487f846d59f8fb4f1285c64086b47e2626c01b6` | `PancakePair` | `downstream DCF/USDT AMM victim` | `—` |
| `0x5aac7375196e9ea76b1598ed4be19b41fa5ba651` | `PancakePair` | `secondary DCT/USDT LP mint and profit-routing pair` | `—` |
| `0x56f46bd073e9978eb6984c0c3e5c661407c3a447` | `DCT` | `secondary liquidity-classification/tax-routing contract` | `—` |

### Recommended fixes

- Remove `burnPair` and `sync()` from DCF's user-controlled transfer-to-pair branch, or defer any pair reserve mutation until after the transfer and AMM operation cannot be influenced by the same call.
- Do not burn tokens from an AMM pair address inside ERC20 `_transfer`; if burn mechanics are required, isolate them from AMM pair balances or use explicit owner/governance maintenance functions with slippage and reserve-safety checks.
- For DCT, do not classify liquidity operations solely from `balanceOf(pair) > reserve`; require router/pair context plus explicit LP mint/burn reconciliation before applying add/remove-liquidity tax paths.
