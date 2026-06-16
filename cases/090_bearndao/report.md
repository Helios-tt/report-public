# RCA Run Report — bsc 0x51913be3…1edd5f


## Case overview

- **Chain**: bsc (chain_id=56)
- **Tx hash**: `0x51913be3f31d5ddbfc77da789e5f9653ed6b219a52772309802226445a1edd5f`
- **Block**: 34099689
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 413.73s (413725 ms)
- **Finding**: Public zero-slippage dust conversion let an attacker force BvaultsStrategy to sell its BUSD at a manipulated Pancake spot price


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
- **Incident net loss**: $767869.61
- **PoC net reproduced**: $760477.97
- **USD ratio**: 0.990x

## Attack narrative

_No standalone `attack_flow.md` was available; this section is assembled from RCA report fields._

### RCA-derived flow

BvaultsStrategy.convertDustToEarned() is public and, when isAutoComp is true, swaps the contract's full wantAddress balance to earnedAddress if wantAddress != earnedAddress and the balance is nonzero. The branch approves the Pancake router and calls swapExactTokensForTokensSupportingFeeOnTransferTokens with amountOutMin=0, so it accepts a manipulable spot-reserve price with no authorization, dust cap, TWAP/oracle check, or slippage bound. The attacker manipulated the relevant Pancake market in the callback path, invoked this branch, forced the strategy to convert its BUSD into ALPACA at the bad spot price, and then routed the imbalance into BUSD profit.

**Violated invariant**: A strategy-owned want-token balance must not be publicly convertible through a spot AMM unless the caller is authorized and the output is bounded by a trusted price/slippage check.

| Field | Value |
|---|---|
| Entry function | attacker selector 0xd018db3e leading to BvaultsStrategy.convertDustToEarned() |
| Funding source | PancakePair flash-swap/callback path from execution steps |
| Public entrypoint | convertDustToEarned() |
| Attacker callbacks | true |
| Callback is root cause | false |

### Observed impact

| Token | Amount | Token address |
|---|---:|---|
| `BUSD` | 760889.017097225537647455 | `0xe9e7cea3dedca5984780bafc599bd69add087d56` |

### Evidence Summary

- **poc_verification** (`evidence summary`): Verified economic PoC gate passed with hard static blockers equal to zero.
- **balance_impact** (`evidence summary`): No relevant giant supply expansion; BvaultsStrategy lost all observed BUSD, gained ALPACA, and attacker EOA gained BUSD.
- **evidence** (`evidence summary`): execution steps is the attacker-contract call to BvaultsStrategy.convertDustToEarned() with direct relevance to BvaultsStrategy BUSD loss and ALPACA gain.
- **source** (`evidence summary`): Public branch spends the full strategy want balance via PancakeRouter with amountOutMin=0 and no caller authorization or independent price bound.
- **source** (`evidence summary`): Router prices swaps from current pair balances/reserves and enforces only caller-provided amountOutMin, which was zero in the vulnerable strategy call.
- **negative_evidence** (`evidence summary`): ERC20 approvals, transfers, transferFrom, callbacks, and profit routing were rejected as standalone root causes because they do not explain the strategy's invalid economic decision.
- **attack_path** (`evidence summary`): PoC executes initial pair swap/callback, invokes BvaultsStrategy.convertDustToEarned(), then swaps proceeds to attacker BUSD profit.

## Multi-leg reconciliation

_Top incident drain/loss legs are shown first; gain and mechanical legs remain available in `report/run_summary.json`._

| Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| loss | `0x21125d94cfe886e7179c8d2fe8c1ea8d57c73e0e` | `storage_contract` | `BUSD` | -768358.953227757555088466 | -$767943.87 |
| loss | `0x1b96b92314c44b159149f7e0303511fb2fc4774f` | `storage_contract` | `WBNB` | -26.159868689030299671 | -$6035.16 |
| loss | `0x1ccc8ee8ad0f70e0bb362d56035ff241755192b1` | `transfer_counterparty` | `WBNB` | -0.1 | -$23.07 |

## Root cause analysis

- **Title**: Public zero-slippage dust conversion let an attacker force BvaultsStrategy to sell its BUSD at a manipulated Pancake spot price
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: A strategy-owned want-token balance must not be publicly convertible through a spot AMM unless the caller is authorized and the output is bounded by a trusted price/slippage check.

### Final root cause

BvaultsStrategy.convertDustToEarned() is public and, when isAutoComp is true, swaps the contract's full wantAddress balance to earnedAddress if wantAddress != earnedAddress and the balance is nonzero. The branch approves the Pancake router and calls swapExactTokensForTokensSupportingFeeOnTransferTokens with amountOutMin=0, so it accepts a manipulable spot-reserve price with no authorization, dust cap, TWAP/oracle check, or slippage bound. The attacker manipulated the relevant Pancake market in the callback path, invoked this branch, forced the strategy to convert its BUSD into ALPACA at the bad spot price, and then routed the imbalance into BUSD profit.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x21125d94cfe886e7179c8d2fe8c1ea8d57c73e0e` | `BvaultsStrategy` | `primary vulnerable contract` | `—` |

### Recommended fixes

- Restrict convertDustToEarned() to operator/strategist or remove public access, matching the risk level of earn().
- Do not define dust as the entire wantAddress balance; cap conversion to a bounded residual amount or exclude core want liquidity.
- Replace amountOutMin=0 with a TWAP/oracle-backed minimum output and revert when the expected value deviates beyond configured slippage.
- Consider nonReentrant on rebalance/conversion entrypoints and pause affected strategies until path and slippage controls are deployed.

### Limitations

- internal evidence was not present in the manifest; the analysis used the verified PoC test and execution summary evidence for attack-flow ordering.
- Exact configured storage values for wantAddress, earnedAddress, and path were not separately decoded from storage; the selected causal claim is supported by source semantics plus execution steps and RPC balance deltas.
