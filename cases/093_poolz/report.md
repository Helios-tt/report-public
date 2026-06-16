# RCA Run Report — bsc 0x39718b03…30c5d5


## Case overview

- **Chain**: bsc (chain_id=56)
- **Tx hash**: `0x39718b03ae346dfe0210b1057cf9f0c378d9ab943512264f06249ae14030c5d5`
- **Block**: 26475404
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 461.99s (461990 ms)
- **Finding**: Unchecked array-sum overflow lets attackers create underfunded LockedDeal pools and withdraw existing balances


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
- **Incident net loss**: $96.95
- **PoC net reproduced**: unknown
- **USD ratio**: unknown

## Attack narrative

_No standalone `attack_flow.md` was available; this section is assembled from RCA report fields._

### RCA-derived flow

LockedDeal.CreateMassPools transfers only getArraySum(_StartAmount) but records every supplied _StartAmount[i] as pool claimable Amount. In Solidity 0.6, getArraySum uses unchecked `sum = sum + _array[i]`, allowing an attacker to wrap the required deposit to a tiny value while recording a large per-pool entitlement. The attacker then calls WithdrawToken on the newly created unlocked pool, causing LockedDeal to transfer existing token balances to the attacker-controlled owner.

**Violated invariant**: For every mass pool creation, the aggregate token amount transferred into LockedDeal must be at least the aggregate Amount recorded across all created pools, with no arithmetic wraparound.

| Field | Value |
|---|---|
| Entry function | CreateMassPools(address,uint64[],uint256[],address[]) followed by WithdrawToken(uint256) |
| Public entrypoint | CreateMassPools(address,uint64[],uint256[],address[]) |
| Callback is root cause | false |

### Observed impact

| Token | Amount | Token address |
|---|---:|---|
| `WOD, ECIO, MNZ, SIP` | unpriced multi-token profit; holder-net priced BNB loss observed as 96.95270504101894 USD | `multiple` |

### Evidence Summary

- **poc_verification** (`evidence summary`): Economic PoC gate passes with build and test success, economic_status pass, proof_kind economic_proof, and no hard static validation blockers.
- **evidence** (`evidence summary`): Evidence summary identifies direct asset loss and repeated LockedDeal CreateMassPools accounting steps tied to top losses; giant_mint_tokens is empty.
- **source** (`evidence summary`): Source shows CreateMassPools transfers only the unchecked aggregate sum, records each original amount as pool entitlement, and WithdrawToken later pays the recorded amount.
- **attack_path** (`evidence summary`): PoC supplies near-uint256-max plus victim-balance amount arrays to CreateMassPools for MNZ, WOD, SIP, and ECIO, then withdraws the newly created pool IDs and transfers proceeds to the attacker EOA.
- **balance_impact** (`evidence summary`): RPC observations show no WOD/ECIO/MNZ/SIP totalSupply expansion and show LockedDeal token balances falling while the attacker EOA balances increase.
- **negative_evidence** (`evidence summary`): Reasoning rejects approval, transfer, router, and WithdrawToken payout steps as root cause, records the competing mechanism check, and records the faithfulness audit outcome.

## Multi-leg reconciliation

_Top incident drain/loss legs are shown first; gain and mechanical legs remain available in `report/run_summary.json`._

| Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| loss | `0xbb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c` | `storage_contract` | `BNB` | -0.311030089790696942 | -$96.95 |
| loss | `0x3c096f6c3ad08f36822e75a8b1cf34849fe623bd` | `storage_contract` | `WOD` | -76.570819828670803102 | N/A |
| loss | `0x58f876857a02d6762e0101bb5c46a8c1ed44dc16` | `storage_contract` | `BUSD` | -0.093090823803231418 | N/A |
| loss | `0x8bfaa473a899439d8e07bf86a8c6ce5de42fe54b` | `storage_contract` | `WOD` | -35975413.186725149349549999 | N/A |
| loss | `0x8bfaa473a899439d8e07bf86a8c6ce5de42fe54b` | `storage_contract` | `ECIO` | -252152268.734854541525399999 | N/A |
| loss | `0x8bfaa473a899439d8e07bf86a8c6ce5de42fe54b` | `storage_contract` | `MNZ` | -61856797.091635905326849999 | N/A |
| loss | `0x8bfaa473a899439d8e07bf86a8c6ce5de42fe54b` | `storage_contract` | `SIP` | -29032275.688743399999999999 | N/A |
| loss | `0xe157f7cea13f352624133372a85a9e32d437b4f4` | `storage_contract` | `MNZ` | -88.85609492059510774 | N/A |
| loss | `0xe948e8bc62ee35d06a015199954c6c2a99e157af` | `storage_contract` | `SIP` | -119.156690695905131281 | N/A |

## Root cause analysis

- **Title**: Unchecked array-sum overflow lets attackers create underfunded LockedDeal pools and withdraw existing balances
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: For every mass pool creation, the aggregate token amount transferred into LockedDeal must be at least the aggregate Amount recorded across all created pools, with no arithmetic wraparound.

### Final root cause

LockedDeal.CreateMassPools transfers only getArraySum(_StartAmount) but records every supplied _StartAmount[i] as pool claimable Amount. In Solidity 0.6, getArraySum uses unchecked `sum = sum + _array[i]`, allowing an attacker to wrap the required deposit to a tiny value while recording a large per-pool entitlement. The attacker then calls WithdrawToken on the newly created unlocked pool, causing LockedDeal to transfer existing token balances to the attacker-controlled owner.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x8bfaa473a899439d8e07bf86a8c6ce5de42fe54b` | `LockedDeal` | `primary vulnerable contract` | `—` |

### Recommended fixes

- Replace the unchecked addition in LockedDeal.getArraySum with SafeMath.add or an explicit overflow check before using the aggregate as the transfer-in requirement.
- Ensure CreateMassPools records pool Amount values only after verifying that the exact aggregate of all recorded amounts was transferred into the contract.
- Consider moving to Solidity 0.8+ checked arithmetic and adding regression tests for mass-pool amount arrays whose sum would overflow.

### Limitations

- internal evidence was not present in the public bundle, so the PoC test file and generated execution summary comments were used for attack-flow evidence.
- Profit is multi-token and partially unpriced in available evidence; raw token deltas and one priced holder-net BNB loss are reported.
