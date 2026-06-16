# RCA Run Report — bsc 0xeab946cf…a6c1c4


## Case overview

- **Chain**: bsc (chain_id=56)
- **Tx hash**: `0xeab946cfea49b240284d3baef24a4071313d76c39de2ee9ab00d957896a6c1c4`
- **Block**: 57432056
- **Final quality**: `partial`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC, but RCA is partial.
- **Elapsed**: 639.80s (639803 ms)
- **Finding**: sellToken payout appears to use same-block Pancake spot quote after attacker-manipulated YULIAI/USDT price


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
- **Incident net loss**: $99958.07
- **PoC net reproduced**: $78900.52
- **USD ratio**: 1.000x

## Attack narrative

_No standalone `attack_flow.md` was available; this section is assembled from RCA report fields._

### RCA-derived flow

The likely vulnerable contract is 0x8262325bf1d8c3be83eb99f5a74b8458ebb96282, whose source is unavailable in the available evidence. Execution and PoC evidence show its sellToken(uint256) path is repeatedly invoked after an attacker-controlled Pancake V3 YULIAI/USDT price move, calls QuoterV2/Pancake pool quote/swap steps, and then transfers USDT to the attack contract. The apparent invariant failure is accepting a same-transaction manipulable AMM spot quote as payout authority for YULIAI sales.

**Violated invariant**: A sell-token payout must not be computed from a same-block attacker-manipulable AMM spot quote without independent TWAP/oracle, reserve-backed settlement, or deviation validation.

| Field | Value |
|---|---|
| Entry function | 0xdf791e50 / swap(address,address,uint256) |
| Funding source | flashLoan(address,uint256,bytes) from 0x8f73b65b4caaf64fba2af91cc5d4a2a1318e5d8c |
| Public entrypoint | sellToken(uint256) |
| Attacker callbacks | 0x13a1a562 / onMoolahFlashLoan(uint256,bytes) |
| Callback is root cause | false |

### Observed impact

| Token | Amount | Token address |
|---|---:|---|
| `USDT` | 78799.932076881681340252 | `0x55d398326f99059ff775485246999027b3197955` |

### Evidence Summary

- **poc_verification** (`evidence summary`): Economic PoC is verified: execution, build, forge test, and economic proof all pass with no hard product blockers.
- **balance_impact** (`evidence summary`): USDT decreases from 0x826232... and increases at the attacker EOA; YULIAI moves from the Pancake pool to 0x826232....
- **evidence** (`evidence summary`): Evidence summary demotes approval/transfer-only steps as downstream and identifies Pancake pool and 0x826232... steps connected to the asset impact; 0x826232... has no verified source.
- **attack_path** (`evidence summary`): Verified PoC performs flash loan, Pancake spot swap, repeated sellToken calls, reverse swap, flash-loan repayment, and final USDT profit transfer.
- **evidence** (`execution summary`): Each sellToken step calls QuoterV2 with YULIAI/USDT quote calldata, reaches Pancake pool swap, and is followed by USDT transfer to the attack contract.
- **source** (`evidence summary`): QuoterV2 interface states quote functions compute amounts without executing swaps and should not be called on-chain.
- **source** (`evidence summary`): QuoterV2 computes a live spot quote by invoking pool.swap and decoding the revert payload; execution evidence shows 0x826232... invokes this path.
- **source** (`evidence summary`): Router checks only user-supplied amountOutMinimum after exactInputInternal; PoC sets the floor to zero for the price-moving swap.

## Multi-leg reconciliation

_Top incident drain/loss legs are shown first; gain and mechanical legs remain available in `report/run_summary.json`._

| Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| loss | `0x8262325bf1d8c3be83eb99f5a74b8458ebb96282` | `storage_contract` | `USDT` | -99838.03470453148857948 | -$99965.48 |
| loss | `0xa687c7b3c2cf6adaef0c4edab234c55b88e01333` | `storage_contract` | `YULIAI` | -3347358.354974243185076585 | N/A |

## Root cause analysis

- **Title**: sellToken payout appears to use same-block Pancake spot quote after attacker-manipulated YULIAI/USDT price
- **Severity**: `critical`
- **Confidence**: `medium`
- **Violated invariant**: A sell-token payout must not be computed from a same-block attacker-manipulable AMM spot quote without independent TWAP/oracle, reserve-backed settlement, or deviation validation.

### Final root cause

The likely vulnerable contract is 0x8262325bf1d8c3be83eb99f5a74b8458ebb96282, whose source is unavailable in the available evidence. Execution and PoC evidence show its sellToken(uint256) path is repeatedly invoked after an attacker-controlled Pancake V3 YULIAI/USDT price move, calls QuoterV2/Pancake pool quote/swap steps, and then transfers USDT to the attack contract. The apparent invariant failure is accepting a same-transaction manipulable AMM spot quote as payout authority for YULIAI sales.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x8262325bf1d8c3be83eb99f5a74b8458ebb96282` | `unknown` | `primary vulnerable contract / USDT payout holder` | `—` |
| `0xb048bbc1ee6b733fffcfb9e9cef7375518e25997` | `QuoterV2` | `source-visible spot quote dependency` | `—` |
| `0xa687c7b3c2cf6adaef0c4edab234c55b88e01333` | `PancakeV3Pool` | `manipulated YULIAI/USDT pool / price source` | `—` |

### Recommended fixes

- In 0x826232...::sellToken(uint256), do not use QuoterV2/Pancake same-block spot quote as payout authority; use TWAP/oracle or reserve-backed settlement with deviation and observation-window checks.
- Cap USDT payout by independently verified received YULIAI value and perform state/accounting updates before external token transfers.
- Reject zero-slippage or flash-loan-manipulated price inputs when computing sell-token payouts.

### Limitations

- missing_assumption: source for 0x8262325bf1d8c3be83eb99f5a74b8458ebb96282 is absent, so the exact sellToken branch, formula, and guards are not visible.
- Cannot provide file:line patch for the primary payout contract from available evidence.
- No semantic meaning was assigned to undecoded storage slots in the source-gapped contract.
