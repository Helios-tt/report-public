# RCA Run Report — bsc 0x3a9dd216…9f5937


## Case overview

- **Chain**: bsc (chain_id=56)
- **Tx hash**: `0x3a9dd216fb6314c013fa8c4f85bfbbe0ed0a73209f54c57c1aab02ba989f5937`
- **Block**: 52624701
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 574.21s (574205 ms)
- **Finding**: FPC transfer hook synchronizes AMM reserves during sell transfers, breaking the in-flight swap invariant


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
- **Incident net loss**: $4675043.60
- **PoC net reproduced**: unknown
- **USD ratio**: unknown

## Attack narrative

_No standalone `attack_flow.md` was available; this section is assembled from RCA report fields._

### RCA-derived flow

The FPC token contract treats pool transfers as sell/liquidity events inside Token._update and, on the sell branch, calls burnLpToken before completing the transfer. burnLpToken transfers FPC out of the USDT/FPC pair and calls IUniswapV2Pair(usdtPool).sync() from inside the ERC20 transfer path, so later PancakePair swap validation is checked against reserves rewritten during the same route rather than the pre-transfer pool state. The attacker used flash-loaned USDT and helper/router calls to trigger this hook and drain USDT/BNB/FPC value.

**Violated invariant**: An ERC20 transfer hook must not mutate or synchronize AMM pair reserves that are used to validate the same in-flight swap route.

| Field | Value |
|---|---|
| Entry function | 0x1921e20f |
| Funding source | flash(address,uint256,uint256,bytes) on 0x92b7807bf19b7dddf89b706143896d05228f3121 |
| Attacker callbacks | pancakeV3FlashCallback(uint256,uint256,bytes) and fallback selector 0x84800812 |
| Callback is root cause | false |

### Observed impact

| Token | Amount | Token address |
|---|---:|---|
| `FPC` | 542737.799722769701862543 | `0xb192d4a737430aa61cea4ce9bfb6432f7d42592f` |

### Evidence Summary

- **poc_verification** (`evidence summary`): Verified economic PoC gate passed with no hard product-static blockers.
- **balance_impact** (`evidence summary`): The transaction contains direct non-attacker asset loss and attacker/profit positives; the USDT/FPC pair lost USDT and FPC while attacker/profit holders gained value.
- **evidence** (`evidence summary`): The relevant path is helper/router approval and routing, FPC transferFrom execution steps, child pair sync execution steps, then later PancakePair swap execution steps.
- **evidence** (`execution summary`): The attacker flash-borrows USDT, calls the USDT/FPC pair swap, transfers FPC to a helper, invokes unresolved helper selector 0xc07a5a35, repays the flash loan, and routes profit.
- **source** (`evidence summary`): FPC sell transfers call burnLpToken before the final transfer; burnLpToken moves FPC from the pool to treasury/reward and calls pair sync from inside the ERC20 transfer path.
- **source** (`evidence summary`): PancakePair.swap validates adjusted balances against stored reserves, while sync overwrites reserves with current token balances.
- **negative_evidence** (`evidence summary`): FPC totalSupply did not change, ruling out a giant mint or supply-expansion root cause.
- **negative_evidence** (`evidence summary`): Pair swaps, approvals, transfers, flash loan, callbacks, and profit routing were rejected as standalone causes; the final faithfulness audit found no high-risk violation.

## Multi-leg reconciliation

_Top incident drain/loss legs are shown first; gain and mechanical legs remain available in `report/run_summary.json`._

| Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| loss | `0xa1e08e10eb09857a8c6f2ef6cca297c1a081ed6b` | `storage_contract` | `USDT` | -4673883.527140201011205321 | -$4675043.60 |
| loss | `0x16b9a82891338f9ba80e2d6970fdda79d1eb0dae` | `storage_contract` | `WBNB` | -736.219506142794922024 | -$484459.71 |
| loss | `0xa1e08e10eb09857a8c6f2ef6cca297c1a081ed6b` | `storage_contract` | `FPC` | -715946.619259251851600417 | N/A |

## Root cause analysis

- **Title**: FPC transfer hook synchronizes AMM reserves during sell transfers, breaking the in-flight swap invariant
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: An ERC20 transfer hook must not mutate or synchronize AMM pair reserves that are used to validate the same in-flight swap route.

### Final root cause

The FPC token contract treats pool transfers as sell/liquidity events inside Token._update and, on the sell branch, calls burnLpToken before completing the transfer. burnLpToken transfers FPC out of the USDT/FPC pair and calls IUniswapV2Pair(usdtPool).sync() from inside the ERC20 transfer path, so later PancakePair swap validation is checked against reserves rewritten during the same route rather than the pre-transfer pool state. The attacker used flash-loaned USDT and helper/router calls to trigger this hook and drain USDT/BNB/FPC value.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0xb192d4a737430aa61cea4ce9bfb6432f7d42592f` | `Token (FPC)` | `primary vulnerable contract` | `—` |
| `0xa1e08e10eb09857a8c6f2ef6cca297c1a081ed6b` | `PancakePair` | `impacted USDT/FPC AMM pair` | `—` |

### Recommended fixes

- Remove IUniswapV2Pair(usdtPool).sync() from burnLpToken during ERC20 transfer execution and perform LP burns/syncs only through a restricted, non-swap maintenance function.
- Do not transfer tokens out of the AMM pair from inside _update; if LP-burning is required, schedule it outside swap execution or guard it with pool/router and no-in-flight-swap restrictions.
- Keep AMM reserve synchronization under the pair/router flow, not token transfer hooks, so the K invariant is evaluated against the intended reserve boundary.

### Limitations

- Source for helper 0xc2a81942627f6929521397eef6173f271d1fb456 is unavailable and selector 0xc07a5a35 is unresolved; this affects full path decoding but not the source-backed FPC transfer-hook root cause.
