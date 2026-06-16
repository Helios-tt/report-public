# RCA Run Report — ethereum 0x46567c73…3d8729


## Case overview

- **Chain**: ethereum (chain_id=1)
- **Tx hash**: `0x46567c731c4f4f7e27c4ce591f0aebdeb2d9ae1038237a0134de7b13e63d8729`
- **Block**: 20834658
- **Final quality**: `partial`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC, but RCA is partial.
- **Elapsed**: 850.47s (850465 ms)
- **Finding**: oETH redeemUnderlying floors the burn amount used for collateral checks, allowing repeated under-burn redemptions and over-borrowing.


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
- **Incident net loss**: $460617.90
- **PoC net reproduced**: $126510.68
- **USD ratio**: 1.003x

## Attack narrative

_No standalone `attack_flow.md` was available; this section is assembled from RCA report fields._

### RCA-derived flow

OEther/OToken redeemUnderlying reaches OToken.redeemFresh with redeemAmountIn > 0. That branch computes redeemTokens with divScalarByExpTruncate(redeemAmountIn, exchangeRate), passes the floored token amount into Comptroller.redeemAllowed, and then transfers the full redeemAmountIn. Repeating small redemptions near the exchange-rate rounding boundary can remove more underlying than the burned/collateral-accounted oTokens justify, preserving apparent collateral and enabling borrows from multiple markets.

**Violated invariant**: For redeemUnderlying, the oTokens burned and the Comptroller liquidity effect must conservatively cover the exact underlying amount transferred out.

| Field | Value |
|---|---|
| Entry function | 0xce30fb6a on 0xa57eda20be51ae07df3c8b92494c974a92cf8956 |
| Funding source | Balancer WETH flashLoan of 2000000000000000000000 WETH |
| Public entrypoint | OEther.redeemUnderlying(430454691) |
| Attacker callbacks | receiveFlashLoan / helper 0x95786b1c |
| Callback is root cause | false |

### Observed impact

| Token | Amount | Token address |
|---|---:|---|
| `ETH,VUSD,WBTC,DAI,XCN,USDT,oETH,WETH` | 126.51K USD reproduced by PoC; holder net losses 460.62K USD in RCA deltas | `multi_asset` |

### Evidence Summary

- **poc_verification** (`evidence summary`): Verified economic PoC passes and product static validation has no hard blockers.
- **balance_impact** (`evidence summary`): Evidence summary reports direct asset loss plus oETH giant mint/supply expansion and warns not to stop at drain steps.
- **evidence** (`evidence summary`): oETH totalSupply increased by 8985432546; attacker contract oETH balance increased by 8985432546; oETH code existed pre/post.
- **attack_path** (`execution summary`): Execution path performs flash loan, OEther mint, enterMarkets, borrows, and a 55-iteration exchangeRateStored/tiny ETH/redeemUnderlying loop.
- **source** (`evidence summary`): OEther mint path and cash accounting exclude current msg.value when reading cash prior and accept ETH via doTransferIn.
- **source** (`evidence summary`): Mint uses actualMintAmount/exchangeRate; redeemUnderlying branch floors redeemTokens from redeemAmountIn/exchangeRate before transferring full redeemAmountIn.
- **source** (`evidence summary`): Borrow and redeem gates use oracle price and liquidity checks; redeem effect is based on redeemTokens, so floored redeemTokens can understate collateral removal.
- **negative_evidence** (`evidence summary`): Raw Unitroller selector is unresolved; its exact semantics are a limitation preventing complete status.

## Multi-leg reconciliation

_Top incident drain/loss legs are shown first; gain and mechanical legs remain available in `report/run_summary.json`._

| Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| loss | `0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2` | `storage_contract` | `ETH` | -72.286437129531982439 | -$190121.95 |
| loss | `0x88ad8e1589b00ffcfe2f6fddbfc959377edd3a1c` | `storage_contract` | `WETH` | -71.914533051844719616 | -$189143.80 |
| loss | `0x2c6650126b6e0749f977d280c98415ed05894711` | `storage_contract` | `USDT` | -50780.121544 | -$50795.65 |
| loss | `0x7a89e16cc48432917c948437ac1441b78d133a16` | `storage_contract` | `WBTC` | -0.22990636 | -$14792.01 |
| loss | `0xbd20ae088dee315ace2c08add700775f461fea64` | `storage_contract` | `XCN` | -7350326.135730346092551099 | -$10617.49 |
| loss | `0xf3354d3e288ce599988e23f9ad814ec1b004d74a` | `storage_contract` | `DAI` | -5148.046590995580075613 | -$5147.00 |
| loss | `0xee894c051c402301bc19be46c231d2a8e38b0451` | `storage_contract` | `VUSD` | -4107530.423553 | N/A |

## Root cause analysis

- **Title**: oETH redeemUnderlying floors the burn amount used for collateral checks, allowing repeated under-burn redemptions and over-borrowing.
- **Severity**: `critical`
- **Confidence**: `medium`
- **Violated invariant**: For redeemUnderlying, the oTokens burned and the Comptroller liquidity effect must conservatively cover the exact underlying amount transferred out.

### Final root cause

OEther/OToken redeemUnderlying reaches OToken.redeemFresh with redeemAmountIn > 0. That branch computes redeemTokens with divScalarByExpTruncate(redeemAmountIn, exchangeRate), passes the floored token amount into Comptroller.redeemAllowed, and then transfers the full redeemAmountIn. Repeating small redemptions near the exchange-rate rounding boundary can remove more underlying than the burned/collateral-accounted oTokens justify, preserving apparent collateral and enabling borrows from multiple markets.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x2ccb7d00a9e10d0c3408b5eefb67011abfacb075` | `OEther / OToken` | `primary vulnerable contract` | `—` |
| `0x3047d790879714930e83b7a7d8e76c2bb64d87b9` | `Comptroller` | `liquidity gate that consumed floored redeemTokens` | `—` |

### Recommended fixes

- In OToken.redeemFresh, replace floor division for redeemAmountIn / exchangeRate with conservative ceil division or require redeemTokens * exchangeRate >= redeemAmountIn before transfer out.
- In Comptroller.redeemAllowed/getHypotheticalAccountLiquidityInternal, validate redeemUnderlying by exact underlying amount or a conservative token amount, not a floored burn estimate.
- Add invariant tests covering repeated small redeemUnderlying calls at high exchange rates and borrow-after-redeem collateral checks.

### Limitations

- missing_assumption: raw Unitroller selector 0xb0772d0b is unresolved and writes Comptroller storage before enterMarkets; exact semantics are not decoded from available evidence.
- contradiction: complete status would conflict with unresolved raw selector/proxy and numeric-state gaps, so analysis is partial.
- NFTLiquidationProxy source and implementation source are not present under internal evidence, although its execution evidence steps are visible after the borrow sequence.
- Exact numeric rounding threshold and all storage/layout values during the 55-iteration loop were not fully decoded from bounded evidence.
