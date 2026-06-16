# RCA Run Report — ethereum 0x840b0dc6…46ec91


## Case overview

- **Chain**: ethereum (chain_id=56)
- **Tx hash**: `0x840b0dc64dbb91e8aba524f67189f639a0bc94ee9256c57d79083bb3fd46ec91`
- **Block**: 44222632
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 1066.21s (1066207 ms)
- **Finding**: Unbounded raw stake accounting created reward entitlement not backed by paid MATEZ value


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

- Transaction: `0x840b0dc64dbb91e8aba524f67189f639a0bc94ee9256c57d79083bb3fd46ec91`
- Block: `44222632`
- Root call type: `CALL`
- Target/tx.to: `0x0ad02ce1b8eb978fd8dc4abec5bf92dfa81ed705`
- Attacker: `0xd4f04374385341da7333b82b230cd223143c4d62`

## Multi-leg reconciliation

- Status: `pass`
- Basis: `incident_drain`
- Source: `economic_reproduction`
- Selected rows: 1

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| incident_drain | loss | `0x326fb70ef9e70f8f4c38cfbfaf39f960a5c252fa` | `storage_contract` | `MATEZ` | -944.014671015767332448 | N/A |


## Root cause analysis

- **Title**: Unbounded raw stake accounting created reward entitlement not backed by paid MATEZ value
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: Reward entitlement and referral/team accounting must be derived from verified paid deposit value and bounded package rules, not from an arbitrary caller-supplied nominal amount.

### Final root cause

MatezStakingProgram.stake(uint256) charges the caller with a one-second Uniswap quote of the supplied amount, but records the raw caller-supplied amnt as staking and referral entitlement. Tx-created helper accounts repeatedly staked an enormous unbounded amnt, inflating selfInvest, directInvest, teamInvest, and order accounting. The claim(typ == 3) reward branch then accepted those inflated counters and transferred MATEZ rewards to the helper accounts, which swept the tokens to the attacker.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x326fb70ef9e70f8f4c38cfbfaf39f960a5c252fa` | `MatezStakingProgram` | `primary vulnerable contract` | `—` |

### Recommended fixes

- In stake(uint256), accept only configured package amounts or derive credited stake value from verified paid MATEZ value, with explicit min/max package and slippage/oracle-window checks before updating selfInvest, directInvest, teamInvest, or orders.amount.
- In claim(typ == 3), require reward thresholds to be computed only from verified paid-deposit accounting and not from arbitrary caller-supplied nominal stake values.

### Limitations

- The analysis is closed-world and did not use external reports or prior transactions; no unresolved source or branch gap affects the selected in-transaction accounting RCA.
