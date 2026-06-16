# RCA Run Report — bsc 0xee4eae6f…66fb12


## Case overview

- **Chain**: bsc (chain_id=56)
- **Tx hash**: `0xee4eae6f70a6894c09fda645fb24ab841e9847a788b1b2e8cb9cc50c1866fb12`
- **Block**: 58615055
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 548.33s (548333 ms)
- **Finding**: Public global reward-time offset lets attackers instantly mature ABCCApp rewards


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
- **PoC net reproduced**: $10057.19
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

- Transaction: `0xee4eae6f70a6894c09fda645fb24ab841e9847a788b1b2e8cb9cc50c1866fb12`
- Block: `58615055`
- Root call type: `CALL`
- Target/tx.to: `0x90e076ef0fed49a0b63938987f2cad6b4cd97a24`
- Attacker: `0x53feee33527819bb793b72bd67dbf0f8466f7d2c`

## PoC Surfaces

| Role | Surface | Selector | Address | Steps |
|---|---|---|---|---|
| attacker_callback | onMoolahFlashLoan(uint256,bytes) | `0x13a1a562` | `0x90e076ef0fed49a0b63938987f2cad6b4cd97a24` | `5` |
| attacker_entry | unknown | `0xb99082d3` | `0x90e076ef0fed49a0b63938987f2cad6b4cd97a24` | `1` |

## Economic Effect

- Reconciliation basis: `poc_selected_direct_attacker_gain`
- Verdict: `exact`
- Comparison basis: `incident_profit_oracle_usd`

| Source | Direction | Holder | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| poc_selected_direct_attacker_gain | gain | `0x53feee33527819bb793b72bd67dbf0f8466f7d2c` | `USDT` | 10062.258375072914282796 | $10057.19 |


## Multi-leg reconciliation

- Status: `pass`
- Basis: `poc_selected_direct_attacker_gain`
- Source: `economic_reproduction`
- Selected rows: 1
- Note: Verified selected gain-family rows are primary for this economic proof; incident drain/loss legs remain available in the incident context.

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| poc_selected_direct_attacker_gain | gain | `0x53feee33527819bb793b72bd67dbf0f8466f7d2c` | `tx_from_eoa` | `USDT` | 10062.258375072914282796 | $10057.19 |


## Root cause analysis

- **Title**: Public global reward-time offset lets attackers instantly mature ABCCApp rewards
- **Severity**: `high`
- **Confidence**: `high`
- **Violated invariant**: Only authorized protocol control should be able to change reward-time offsets, and claim maturity must be bounded by real elapsed time rather than an attacker-controlled global offset.

### Final root cause

ABCCApp exposes addFixedDay(uint256) as an unguarded public global time-offset setter. After a fresh deposit establishes remainingUSDT and dailyUSDT, an attacker can set fixedDay to 1000000000 so getCanClaimUSDT treats the deposit as fully matured and claimDDDD transfers DDDD for an invalid reward entitlement. The later DDDD swap and USDT transfer only monetize that invalid entitlement.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x1bc016c00f8d603c41a582d5da745905b9d034e5` | `ABCCApp` | `primary vulnerable contract` | `—` |

### Recommended fixes

- Restrict ABCCApp.addFixedDay(uint256) to an owner/operator-only path or remove it from production, and enforce a maximum offset that cannot mature rewards beyond real elapsed time.
- Add claim-side validation in getCanClaimUSDT/claimDDDD so staticUSDT is derived from real block time and bounded by protocol-defined accrual intervals independent of mutable global test offsets.
