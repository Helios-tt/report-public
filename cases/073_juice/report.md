# RCA Run Report — ethereum 0xc9b2cbc1…0991e7


## Case overview

- **Chain**: ethereum (chain_id=1)
- **Tx hash**: `0xc9b2cbc1437bbcd8c328b6d7cdbdae33d7d2a9ef07eca18b4922aac0430991e7`
- **Block**: 19395644
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 841.13s (841128 ms)
- **Finding**: Unbounded staking duration bonus lets harvest drain the JUICE reward pool


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

- Transaction: `0xc9b2cbc1437bbcd8c328b6d7cdbdae33d7d2a9ef07eca18b4922aac0430991e7`
- Block: `19395644`
- Root call type: `CALL`
- Target/tx.to: `0xa8b45dee8306b520465f1f8da7e11cd8cfd1bbc4`
- Attacker: `0x3fa19214705bc82ce4b898205157472a79d026be`

## PoC Surfaces

| Role | Surface | Selector | Address | Steps |
|---|---|---|---|---|
| attacker_entry | unknown | `0x6d7fe2d8` | `0xa8b45dee8306b520465f1f8da7e11cd8cfd1bbc4` | `1` |

## Economic Effect

- Reconciliation basis: `incident_drain`
- Verdict: `unpriced`
- Comparison basis: `holder_net_usd_loss`

| Source | Direction | Holder | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| incident_drain | loss | `0x8584ddbd1e28bca4bc6fb96bafe39f850301940e` | `JUICE` | -894773.05584632658546613 | N/A |


## Multi-leg reconciliation

- Status: `pass`
- Basis: `incident_drain`
- Source: `economic_reproduction`
- Selected rows: 1

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| incident_drain | loss | `0x8584ddbd1e28bca4bc6fb96bafe39f850301940e` | `storage_contract` | `JUICE` | -894773.05584632658546613 | N/A |


## Root cause analysis

- **Title**: Unbounded staking duration bonus lets harvest drain the JUICE reward pool
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: A staking reward payout must be bounded by the configured maximum staking duration and the funded reward budget; user-supplied stakingWeek must not create unbounded bonus entitlement.

### Final root cause

JuiceStaking accepts an arbitrary stakeWeek in stake(uint256,uint256) and later uses that stored value as a linear bonus multiplier in pendingReward(address,uint256). harvest(uint256) transfers pending + bonus without bounding the bonus against the configured staking duration or funded reward budget, so a pre-existing stake with excessive stakingWeek can receive an inflated payout. In the incident transaction, harvest(0) paid 894773055846326585466130 JUICE to the attacker contract; the child JUICE transfer only settled that invalid entitlement.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x8584ddbd1e28bca4bc6fb96bafe39f850301940e` | `JuiceStaking` | `primary vulnerable contract` | `—` |

### Recommended fixes

- Add a maximum stake duration check in stake(uint256,uint256), for example require stakeWeek to fit inside the configured staking program duration before storing it.
- In pendingReward(address,uint256) and harvest(uint256), cap and account pending + bonus against the funded reward budget, including bonus already paid, before transferring JUICE.
- Add regression tests where a stake with an excessive stakeWeek cannot create a bonus payout larger than the configured reward budget.

### Limitations

- The prior transaction that populated the attack contract's stake record is outside the available evidence; the RCA relies on the source-visible public stake path and successful current harvest execution for that precondition.
