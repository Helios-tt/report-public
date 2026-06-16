# RCA Run Report — ethereum 0xa02b159f…7a0e3e


## Case overview

- **Chain**: ethereum (chain_id=1)
- **Tx hash**: `0xa02b159fb438c8f0fb2a8d90bc70d8b2273d06b55920b26f637cab072b7a0e3e`
- **Block**: 22957533
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 761.77s (761771 ms)
- **Finding**: Staking credits cUSDC deposits after unchecked failed transferFrom


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
- **Incident net loss**: $32197.48
- **PoC net reproduced**: $32197.48
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

- Transaction: `0xa02b159fb438c8f0fb2a8d90bc70d8b2273d06b55920b26f637cab072b7a0e3e`
- Block: `22957533`
- Root call type: `CREATE`
- Target/tx.to: `unknown`
- Attacker: `0x657a2b6fe37ced2f31fd7513095dbfb126a53601`

## PoC Surfaces

| Role | Surface | Selector | Address | Steps |
|---|---|---|---|---|
| attacker_entry | unknown | `entry` | `0x7f1f536223d6a84ad4897a675f04886ce1c3b7a1` | `1` |

## Economic Effect

- Reconciliation basis: `incident_drain`
- Verdict: `exact`
- Comparison basis: `holder_net_usd_loss`

| Source | Direction | Holder | Token | Delta | USD value |
|-

_… truncated in final report; see source excerpt for full text._


## Multi-leg reconciliation

- Status: `pass`
- Basis: `incident_drain`
- Source: `economic_reproduction`
- Selected rows: 1

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| incident_drain | loss | `0x245a551ee0f55005e510b239c917fa34b41b3461` | `storage_contract` | `cUSDC` | -1286577.59164064 | $-32197.48 |


## Root cause analysis

- **Title**: Staking credits cUSDC deposits after unchecked failed transferFrom
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: A user's withdrawable staking balance must increase only after the staking contract has actually received the same amount of the staked token.

### Final root cause

Staking.deposit treats cUSDC as a generic non-stable token and calls IERC20(tokenAddress).transferFrom(msg.sender, address(this), amount) without requiring the returned bool to be true. cUSDC transferFrom returns false rather than reverting when the helper lacks enough cUSDC, but Staking still credits balances[msg.sender][cUSDC] by amount. The helper then uses the credited balance through emergencyWithdraw(cUSDC) to transfer real cUSDC held by Staking.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x245a551ee0f55005e510b239c917fa34b41b3461` | `Staking` | `primary vulnerable contract` | `—` |
| `0x39aa39c021dfbae8fac545936693ac917d5e7563` | `CErc20` | `token whose false-return transferFrom exposed the unchecked-return bug` | `—` |

### Recommended fixes

- Require the non-stable token transferFrom return value to be true in Staking.deposit, preferably by replacing the raw IERC20 transferFrom at Staking.sol:129 with SafeERC20.safeTransferFrom before any balance, checkpoint, or pool-size credit.
- Restrict deposit tokenAddress to explicitly supported staking assets, or reject cTokens and other false-return/non-standard tokens unless the contract handles their return and accounting semantics safely.
- Keep the invariant that balances[msg.sender][tokenAddress], checkpoints, and poolSize are updated only after verified token receipt.
