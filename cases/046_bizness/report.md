# RCA Run Report — base 0x984cb29c…488873


## Case overview

- **Chain**: base (chain_id=8453)
- **Tx hash**: `0x984cb29cdb4e92e5899e9c94768f8a34047d0e1074f9c4109364e3682e488873`
- **Block**: 24282214
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 386.58s (386584 ms)
- **Finding**: Locker splitLock makes an external refund before split accounting, allowing reentrant withdrawal and duplicated lock claims


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
- **Verdict**: close — PoC reproduces the incident within the 80–110% net-loss band.
- **Incident net loss**: $17373.44
- **PoC net reproduced**: $15707.55
- **USD ratio**: 0.904x

## Attack narrative

_No standalone `attack_flow.md` was available; this section is assembled from RCA report fields._

### RCA-derived flow

The ERC1967 proxy at 0x80b9c9c883e376c4aa43d72413ab1bd6a64a0654 delegates to Locker at 0xd6a7cfa86a41b8f40b8dfeb987582a479eb10693. In Locker.splitLock(uint256,uint256,uint256), the function calls _feeHandler before debiting the source lock and before creating the split lock; _feeHandler externally refunds ETH to msg.sender. The attacker contract re-entered withdrawLock during that refund window, withdrawing lock balances before splitLock finalized accounting, then splitLock resumed and created further withdrawable lock entitlement that was converted through the swap path.

**Violated invariant**: A lock being split must be debited and made non-reentrant before any external call, and a split must not create new withdrawable claims from a lock withdrawn during the split.

| Field | Value |
|---|---|
| Entry function | 0x735ac5b2 attacker entry; repeated Locker.splitLock(uint256,uint256,uint256) |
| Public entrypoint | splitLock(uint256,uint256,uint256) |
| Attacker callbacks | fallback/entry callback during Locker _feeHandler ETH refund |
| Callback is root cause | true |

### Observed impact

| Token | Amount | Token address |
|---|---:|---|
| `ETH` | 4.714399733262014704 | `0x0000000000000000000000000000000000000000` |

### Evidence Summary

- **poc_verification** (`evidence summary`): Verified economic PoC passed with no hard product blockers and reproduced direct attacker ETH profit.
- **balance_impact** (`evidence summary`): Locker proxy lost 220627279869879905706908225 BIZNESS; UniswapV3Pool lost 5214470174770264654 WETH; attacker EOA gained ETH.
- **evidence** (`evidence summary`): Evidence summary marks direct asset loss with entitlement/accounting anomaly and identifies repeated attacker-surface splitLock steps on ERC1967Proxy/Locker.
- **source** (`evidence summary`): splitLock validates the lock but calls _feeHandler before debiting the original lock amount and before creating the split lock.
- **source** (`evidence summary`): _feeHandler performs external ETH calls, including a refund to msg.sender, creating the callback/reentrancy point before splitLock effects.
- **source** (`evidence summary`): withdrawLock transfers the lock amount to the beneficiary; PoC/execution summary show callback-driven withdrawLock calls during the splitLock sequence.
- **negative_evidence** (`evidence summary`): BIZNESS totalSupply did not change; the loss was a transfer of existing BIZNESS out of the locker, and the ERC1967 implementation resolves to Locker.
- **negative_evidence** (`evidence summary`): Approval, transfer, swap, WETH withdraw, and pool steps were audited as downstream conversion rather than the invalid entitlement decision.

## Multi-leg reconciliation

_Top incident drain/loss legs are shown first; gain and mechanical legs remain available in `report/run_summary.json`._

| Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| loss | `0x599245fafc9a55e3d2f02176a65d9cd302023c61` | `storage_contract` | `WETH` | -5.214470174770264654 | -$17373.44 |
| loss | `0x80b9c9c883e376c4aa43d72413ab1bd6a64a0654` | `storage_contract` | `BIZNESS` | -220627279.869879905706908225 | N/A |

## Root cause analysis

- **Title**: Locker splitLock makes an external refund before split accounting, allowing reentrant withdrawal and duplicated lock claims
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: A lock being split must be debited and made non-reentrant before any external call, and a split must not create new withdrawable claims from a lock withdrawn during the split.

### Final root cause

The ERC1967 proxy at 0x80b9c9c883e376c4aa43d72413ab1bd6a64a0654 delegates to Locker at 0xd6a7cfa86a41b8f40b8dfeb987582a479eb10693. In Locker.splitLock(uint256,uint256,uint256), the function calls _feeHandler before debiting the source lock and before creating the split lock; _feeHandler externally refunds ETH to msg.sender. The attacker contract re-entered withdrawLock during that refund window, withdrawing lock balances before splitLock finalized accounting, then splitLock resumed and created further withdrawable lock entitlement that was converted through the swap path.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x80b9c9c883e376c4aa43d72413ab1bd6a64a0654` | `ERC1967Proxy` | `primary vulnerable proxy storing Locker state` | `0xd6a7cfa86a41b8f40b8dfeb987582a479eb10693` |
| `0xd6a7cfa86a41b8f40b8dfeb987582a479eb10693` | `Locker` | `primary vulnerable implementation` | `—` |

### Recommended fixes

- Move all splitLock state effects before _feeHandler, or add a shared nonReentrant guard covering splitLock and withdrawLock, and re-check that the source lock was not withdrawn before creating a split lock.
- Prefer pull-based fee refunds or refund after final accounting, and avoid arbitrary external calls from entitlement-mutating paths.
- Add regression tests where msg.sender/beneficiary re-enters withdrawLock from the splitLock fee refund callback.
