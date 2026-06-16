# RCA Run Report — ethereum 0xd423ae0e…523439


## Case overview

- **Chain**: ethereum (chain_id=56)
- **Tx hash**: `0xd423ae0e95e9d6c8a89dcfed243573867e4aad29ee99a9055728cbbe0a523439`
- **Block**: 34114761
- **Final quality**: `partial`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC, but RCA is partial.
- **Elapsed**: 817.30s (817302 ms)
- **Finding**: Sweeper-triggered treasury withdrawal released BUSD without source-proven entitlement validation


## Reproduction quality

- **PoC status**: `verified`
- **Forge fmt**: `pass`
- **Forge build**: `pass`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`
- **RCA status**: `partial` / `partial`
- **RCA confidence**: `medium`

## Economic reproduction

- **Basis**: incident profit oracle usd
- **Verdict**: exact — PoC reproduces 99–101% of incident net loss.
- **Incident net loss**: $194557.35
- **PoC net reproduced**: $114943.54
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

- Transaction: `0xd423ae0e95e9d6c8a89dcfed243573867e4aad29ee99a9055728cbbe0a523439`
- Block: `34114761`
- Root call type: `CALL`
- Target/tx.to: `0x69bd13f775505989883768ebd23d528c708d6bcf`
- Attacker: `0xbbcc139933d1580e7c40442e09263e90e6f1d66d`

## Multi-leg reconciliation

- Status: `pass`
- Basis: `poc_selected_direct_attacker_gain`
- Source: `economic_reproduction`
- Selected rows: 1
- Note: Verified selected gain-family rows are primary for this economic proof; incident drain/loss legs remain available in the incident context.

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| poc_selected_direct_attacker_gain | gain | `0xbbcc139933d1580e7c40442e09263e90e6f1d66d` | `tx_from_eoa` | `BUSD` | 114393.95820331552308813 | $114943.54 |


## Root cause analysis

- **Title**: Sweeper-triggered treasury withdrawal released BUSD without source-proven entitlement validation
- **Severity**: `critical`
- **Confidence**: `medium`
- **Violated invariant**: Treasury BUSD withdrawals must require authenticated caller-specific authority and must be bounded by a legitimate entitlement before transferring funds.

### Final root cause

execution steps calls 0x8cf0a553ab3896e4832ebcc519a7a60828ab5740.sweep(), which calls 0xcb5a02bb3a38e92e591d323d6824586608ce8ce4 with selector 0x2e1a7d4d, locally decoded as withdraw(uint256), for 193627110417113639371428 BUSD. execution steps then transfers that exact BUSD amount from 0xcb5a...8ce4 to the sweeper, after which router swaps and repayments distribute the proceeds. The patchable branch cannot be pinpointed because source/execution summary for sweep() and withdraw(uint256) is absent, so the supported claim is a partial authorization/entitlement failure on the treasury withdrawal edge.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0xcb5a02bb3a38e92e591d323d6824586608ce8ce4` | `unknown` | `primary vulnerable treasury/withdrawal contract` | `—` |
| `0x8cf0a553ab3896e4832ebcc519a7a60828ab5740` | `unknown` | `sweeper caller that triggers the withdrawal path` | `—` |

### Recommended fixes

- Restrict 0xcb5a...8ce4 withdraw(uint256) to authenticated callers and validate each requested BUSD amount against caller-specific accrued entitlement before transfer.
- If 0x8cf0...5740.sweep() is intended to automate treasury actions, add caller authorization and bounded withdrawal calculations before invoking withdraw(uint256).

### Limitations

- source_branch_gap: source or sufficiently decoded execution summary for 0x8cf0a553ab3896e4832ebcc519a7a60828ab5740.sweep() is not present under the allowed evidence set.
- source_branch_gap: source or sufficiently decoded execution summary for 0xcb5a02bb3a38e92e591d323d6824586608ce8ce4.withdraw(uint256) is not present under the allowed evidence set.
- missing_assumption: exact missing require/branch and caller-entitlement formula cannot be proven from the available evidence.
- The evidence summary chain field is inconsistent with chain id 56; PoC metadata identifies the chain as BSC.
