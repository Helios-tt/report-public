# RCA Run Report — ethereum 0x900891b4…b9710b


## Case overview

- **Chain**: ethereum (chain_id=1)
- **Tx hash**: `0x900891b4540cac8443d6802a08a7a0562b5320444aa6d8eed19705ea6fb9710b`
- **Block**: 21184778
- **Final quality**: `partial`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC, but RCA is partial.
- **Elapsed**: 738.36s (738362 ms)
- **Finding**: Quote-market pricing counted temporary virtual liquidity as redeemable backing


## Reproduction quality

- **PoC status**: `verified`
- **Forge fmt**: `pass`
- **Forge build**: `pass`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`
- **RCA status**: `partial` / `partial`
- **RCA confidence**: `medium`

## Economic reproduction

- **Basis**: holder-net USD loss
- **Verdict**: exact — PoC reproduces 99–101% of incident net loss.
- **Incident net loss**: $425195.30
- **PoC net reproduced**: $425195.30
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

- Transaction: `0x900891b4540cac8443d6802a08a7a0562b5320444aa6d8eed19705ea6fb9710b`
- Block: `21184778`
- Root call type: `CALL`
- Target/tx.to: `0x351d38733de3f1e73468d24401c59f63677000c9`
- Attacker: `0x713d2b652e5f2a86233c57af5341db42a5559dd1`

## PoC Surfaces

| Role | Surface | Selector | Address | Steps |
|---|---|---|---|---|
| attacker_entry | start(address,address,address,address,uint256) | `0x305e0d11` | `0x351d38733de3f1e73468d24401c59f63677000c9` | `1` |
| attacker_callback | receiveFlashLoan(address[],uint2

_… truncated in final report; see source excerpt for full text._


## Multi-leg reconciliation

- Status: `pass`
- Basis: `incident_drain`
- Source: `economic_reproduction`
- Selected rows: 1

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| incident_drain | loss | `0x280a8955a11fcd81d72ba1f99d265a48ce39ac2e` | `storage_contract` | `ETH` | -132.513467878004258374 | $-425195.30 |


## Root cause analysis

- **Title**: Quote-market pricing counted temporary virtual liquidity as redeemable backing
- **Severity**: `critical`
- **Confidence**: `medium`
- **Violated invariant**: Quote redemptions must be bounded by economically backed vETH/ETH and must not count temporary or loaned virtual liquidity as withdrawable value.

### Final root cause

The supported causal path is quote-market redemption mispricing. After buyQuote and addVirtualLiquidity created temporary vETH/BIF pair state, sellQuote accepted 6378941079150051291618297 BIF as authority to receive and cash out 32692717028774184611148 vETH, causing ETH loss from the vETH contract. The exact pricing helper and missing guard are not present in the supplied source/execution summary, so the RCA is partial rather than complete.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x19c5538df65075d53d6299904636bae68b6df441` | `unknown quote market` | `primary vulnerable contract` | `—` |
| `0x62f250cf7021e1cf76c765dec8ec623fe173a1b5` | `unknown virtual liquidity router` | `liquidity setup contract in exploit path` | `—` |
| `0x280a8955a11fcd81d72ba1f99d265a48ce39ac2e` | `VirtualToken` | `ETH-backed redemption contract drained by cashOut` | `—` |

### Recommended fixes

- In the quote-market sellQuote/buyQuote pricing code, exclude temporary/loaned virtual liquidity from redemption valuation or cap cashOutAmount by economically backed vETH before calling vETH cashOut.
- Add a post-pricing solvency assertion that the quote-market redemption amount cannot exceed real backing attributable to the sold BIF amount after fees and existing reserves.

### Limitations

- missing_assumption: source/execution summary for 0x19c5538df65075d53d6299904636bae68b6df441 sellQuote/buyQuote pricing formula is absent, so the exact arithmetic helper and guard cannot be cited.
- source_formula_gap: source/execution summary for 0x62f250cf7021e1cf76c765dec8ec623fe173a1b5 addVirtualLiquidity is absent, so the exact virtual-liquidity validation branch cannot be cited.
- No source-visible oracle/health/solvency branch was available beyond pair-state and vETH cashOut observations.
