# RCA Run Report — bsc 0x2b6b411a…08d615


## Case overview

- **Chain**: bsc (chain_id=56)
- **Tx hash**: `0x2b6b411adf6c452825e48b97857375ff82b9487064b2f3d5bc2ca7a5ed08d615`
- **Block**: 54333338
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 470.38s (470384 ms)
- **Finding**: WETC misclassifies dusted pair transfers as liquidity additions, bypassing sell fees before AMM swap accounting.


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
- **Incident net loss**: $101345.15
- **PoC net reproduced**: unknown
- **USD ratio**: unknown

## Attack narrative

_No standalone `attack_flow.md` was available; this section is assembled from RCA report fields._

### RCA-derived flow

WETC._transfer calls _isLiquidity before the sell branch. _isLiquidity treats any transfer to the pair as add-liquidity when token0 balance exceeds reserve0, a condition any caller can create by dusting the pair with token0. The attacker dusted the pair with USDT, transferred WETC so transferSell was bypassed, then used PancakePair.swap to withdraw USDT against the full untaxed WETC balance.

**Violated invariant**: A token sell into the AMM pair must not bypass sell-fee logic unless an authenticated/proportional LP-add action is actually occurring.

| Field | Value |
|---|---|
| Entry function | 0xe3b872d3 attacker entry, then PancakeV3 flash callback 0xa1d48336 |
| Funding source | PancakeV3 flash from 0x92b7807bf19b7dddf89b706143896d05228f3121 |
| Attacker callbacks | pancakeV3FlashCallback |
| Callback is root cause | false |

### Observed impact

| Token | Amount | Token address |
|---|---:|---|
| `sdssd` | 99.999011300001196359 | `0x96928300ed3b68b8ed25c293e225c8d9c1a79e18` |

### Evidence Summary

- **poc_verification** (`evidence summary`): Verified economic PoC gate passed with hard_count 0 and attacker profit in sdssd.
- **evidence** (`evidence summary`): Evidence summary shows direct loss, USDT dust/WETC transfer/final swap steps, and resulting pair loss plus attacker profit.
- **source** (`evidence summary`): WETC classifies a transfer to the pair as add-liquidity solely when token0 balance exceeds reserves, causing _transfer to return before transferSell.
- **source** (`evidence summary`): PancakePair accepts balance-derived amountIn after WETC credits the full untaxed amount; K is a secondary AMM check, not the WETC classification cause.
- **balance_impact** (`evidence summary`): USDT, sdssd, and WETC totalSupply deltas are zero; pair USDT decreases and attacker sdssd increases, confirming transfer/accounting impact rather than minting.
- **attack_path** (`execution summary`): Execution summary records USDT dust, WETC transfer to pair, final pair swap, router conversion to sdssd, and flash repayment ordering.
- **negative_evidence** (`evidence summary`): Approval, transferFrom, flash loan, router swap, and profit routing were rejected as root cause; competing AMM K gate was inspected.

## Multi-leg reconciliation

_Top incident drain/loss legs are shown first; gain and mechanical legs remain available in `report/run_summary.json`._

| Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| loss | `0x8e2cc521b12deba9a20edea829c6493410dad0e3` | `storage_contract` | `USDT` | -101495.403570120114925199 | -$101345.15 |
| loss | `0x119d1777d617fc70f6b063990eedc2b9c87a7475` | `storage_contract` | `sdssd` | -99.999011300001196359 | N/A |
| loss | `0x8e2cc521b12deba9a20edea829c6493410dad0e3` | `storage_contract` | `WETC` | -6409151.513542464192544376 | N/A |

## Root cause analysis

- **Title**: WETC misclassifies dusted pair transfers as liquidity additions, bypassing sell fees before AMM swap accounting.
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: A token sell into the AMM pair must not bypass sell-fee logic unless an authenticated/proportional LP-add action is actually occurring.

### Final root cause

WETC._transfer calls _isLiquidity before the sell branch. _isLiquidity treats any transfer to the pair as add-liquidity when token0 balance exceeds reserve0, a condition any caller can create by dusting the pair with token0. The attacker dusted the pair with USDT, transferred WETC so transferSell was bypassed, then used PancakePair.swap to withdraw USDT against the full untaxed WETC balance.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0xe7f12b72bfd6e83c237318b89512b418e7f6d7a7` | `WETC` | `primary vulnerable contract` | `—` |
| `0x8e2cc521b12deba9a20edea829c6493410dad0e3` | `PancakePair` | `downstream AMM pair drained after WETC fee-bypass input` | `—` |

### Recommended fixes

- Replace WETC._isLiquidity's single-sided balance0 > reserve0 test with an authenticated/proportional LP-add check, or always execute transferSell for transfers to pairAddress unless the call is from a trusted liquidity mint path.
- Do not let arbitrary pre-transfer token0 dust in the AMM pair change fee classification for WETC transfers.

### Limitations

- internal evidence was absent/read failed, so execution summary.txt and PoC.t.sol were used for attack flow corroboration; this does not affect the source-backed WETC branch claim.
