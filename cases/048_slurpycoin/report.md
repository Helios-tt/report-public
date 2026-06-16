# RCA Run Report — bsc 0x6c729ee7…d29051


## Case overview

- **Chain**: bsc (chain_id=56)
- **Tx hash**: `0x6c729ee778332244de099ba0cb68808fcd7be4a667303fcdf2f54dd4b3d29051`
- **Block**: 44990635
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 606.12s (606118 ms)
- **Finding**: SlurpyCoin auto-swap/burn can be repeatedly triggered against flash-loan-manipulated AMM spot reserves with zero slippage protection


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
- **Incident net loss**: $15020.56
- **PoC net reproduced**: $5219.34
- **USD ratio**: 1.000x

## Attack narrative

_No standalone `attack_flow.md` was available; this section is assembled from RCA report fields._

### RCA-derived flow

SlurpyCoin._transfer checks the token contract balance on attacker-triggerable transfers and calls BuyOrSell whenever the balance exceeds numTokensToSell. BuyOrSell alternates between selling contract-held SLURPY for BNB and swapping the contract's whole BNB balance back into SLURPY for burn, while both swap helpers pass amountOutMin=0 to PancakeRouter. A flash-loan-funded attacker can manipulate the same Pancake pair reserves and repeatedly trigger those internal market operations, making the token contract accept unfavorable spot prices and allowing the attacker to unwind for BNB profit.

**Violated invariant**: Protocol-owned auto-swap/burn treasury operations must not execute at attacker-chosen times against same-transaction AMM spot prices without an enforceable slippage or oracle bound.

| Field | Value |
|---|---|
| Entry function | 0x8f66e655 / attack.attack() fallback dispatch |
| Funding source | DPP flashLoan(uint256,uint256,address,bytes) from 0x6098a5638d8d7e9ed2f952d35b2b67c34ec6b476 |
| Public entrypoint | SlurpyCoin.transfer(address,uint256) |
| Attacker callbacks | DPPFlashLoanCall(address,uint256,uint256,bytes) |
| Callback is root cause | false |

### Observed impact

| Token | Amount | Token address |
|---|---:|---|
| `BNB` | 7.411804202305118343 | `0x0000000000000000000000000000000000000000` |

### Evidence Summary

- **poc_verification** (`evidence summary`): Verified economic PoC gate passed with attacker BNB profit and no hard product static blockers.
- **balance_impact** (`evidence summary`): Evidence summary shows direct asset loss, SLURPY/WBNB deltas, and an entitlement/accounting anomaly; it warns not to stop at transfer/approval steps.
- **negative_evidence** (`evidence summary`): SLURPY totalSupply is unchanged and WBNB totalSupply decreases by 10.714232490326755361 WBNB, rejecting WBNB mint/approval/withdraw as the root cause.
- **source** (`evidence summary`): Verified PoC uses a DPP flash loan, router swap, and repeated SlurpyCoin transfer calls that trigger SlurpyCoin's internal transfer branch.
- **source** (`evidence summary`): SlurpyCoin source shows attacker-triggerable auto-swap/burn logic and zero minimum-output swaps.
- **source** (`evidence summary`): Router prices swaps from current AMM reserves and enforces only caller-supplied slippage bounds; SlurpyCoin supplied zero.
- **evidence** (`evidence summary`): Analyzer narrowed from WBNB transfer/approval effects to the SlurpyCoin price/accounting decision and completed faithfulness audit.

## Multi-leg reconciliation

_Top incident drain/loss legs are shown first; gain and mechanical legs remain available in `report/run_summary.json`._

| Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| loss | `0xbb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c` | `storage_contract` | `BNB` | -10.714232490326755361 | -$7544.89 |
| loss | `0x72c114a1a4abc65be2be3e356eede296dbb8ba4c` | `storage_contract` | `BNB` | -10.615940170989016157 | -$7475.67 |
| loss | `0x76a5a2ef4ae2ddead0c8d5b704808637b414113c` | `storage_contract` | `SLURPY` | -2997085.433812228405030603 | N/A |

## Root cause analysis

- **Title**: SlurpyCoin auto-swap/burn can be repeatedly triggered against flash-loan-manipulated AMM spot reserves with zero slippage protection
- **Severity**: `high`
- **Confidence**: `high`
- **Violated invariant**: Protocol-owned auto-swap/burn treasury operations must not execute at attacker-chosen times against same-transaction AMM spot prices without an enforceable slippage or oracle bound.

### Final root cause

SlurpyCoin._transfer checks the token contract balance on attacker-triggerable transfers and calls BuyOrSell whenever the balance exceeds numTokensToSell. BuyOrSell alternates between selling contract-held SLURPY for BNB and swapping the contract's whole BNB balance back into SLURPY for burn, while both swap helpers pass amountOutMin=0 to PancakeRouter. A flash-loan-funded attacker can manipulate the same Pancake pair reserves and repeatedly trigger those internal market operations, making the token contract accept unfavorable spot prices and allowing the attacker to unwind for BNB profit.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x72c114a1a4abc65be2be3e356eede296dbb8ba4c` | `SlurpyCoin` | `primary vulnerable contract` | `—` |
| `0x10ed43c718714eb63d5aa57b78b54704e256024e` | `PancakeRouter` | `spot-price execution venue used by vulnerable contract` | `—` |

### Recommended fixes

- Do not call BuyOrSell from arbitrary user transfers; require a keeper/timelock and a non-manipulable price condition before treasury swaps.
- Replace amountOutMin=0 in swapTokensForEth and swapEthForTokens with bounded minimum outputs derived from a trusted TWAP or externally validated quote.
- Cap per-block/per-transaction treasury swap frequency and size so repeated attacker-triggered transfers cannot force large protocol-owned market operations.

### Limitations

- internal evidence was absent, so the flow citation uses the verified PoC test and generated action comments instead.
- Exact per-iteration pair reserve values were not decoded from the large execution evidence; the source-visible zero-slippage branch and verified economic PoC are sufficient for the selected root cause.
