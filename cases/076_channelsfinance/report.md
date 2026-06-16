# RCA Run Report — bsc 0x711cc4ce…2f8fb5


## Case overview

- **Chain**: bsc (chain_id=56)
- **Tx hash**: `0x711cc4ceb9701d317fe9aa47187425e16dae7d5a0113f1430e891018262f8fb5`
- **Block**: 34805972
- **Final quality**: `partial`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC, but RCA is partial.
- **Elapsed**: 836.12s (836116 ms)
- **Finding**: cCLP gulp accounting accepted same-transaction donated LP balance as liquidation collateral value


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

- Transaction: `0x711cc4ceb9701d317fe9aa47187425e16dae7d5a0113f1430e891018262f8fb5`
- Block: `34805972`
- Root call type: `CALL`
- Target/tx.to: `0x07e536f23a197f6fb76f42ad01ac2bcdc3bf738e`
- Attacker: `0x20395d8e8a11cfd2541b942afdb810b7dcc64681`

## PoC Surfaces

| Role | Surface | Selector | Address | Steps |
|---|---|---|---|---|
| attacker_entry | unknown | `0x74f353cd` | `0x07e536f23a197f6fb76f42ad01ac2bcdc3bf738e` | `1` |

## Economic Effect

- Reconciliation basis: `incident_drain`
- Verdict: `unpriced`
- Comparison basis: `holder_net_usd_loss`

| Source | Direction | Holder | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| incident_drain | loss | `0x28b57afffc9017b817972d27e3332f81a846cc61` | `cCLP_BTCB_BUSD` | -0.00622303 | N/A |
| incident_drain | loss | `0x73feaa1ee314f8c655e354234017be2193c9e24e` | `Cake-LP` | -0.000000001000000623 | N/A |
| incident_drain | loss | `0xe685417bfdda1c4ca01a430faf1a20668f672d82` | `cCLP_BTCB_BUSD` | -0.25571355 | N/A |


## Multi-leg reconciliation

- Status: `pass`
- Basis: `incident_drain`
- Source: `economic_reproduction`
- Selected rows: 3

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| incident_drain | loss | `0x28b57afffc9017b817972d27e3332f81a846cc61` | `transfer_counterparty` | `cCLP_BTCB_BUSD` | -0.00622303 | N/A |
| incident_drain | loss | `0x73feaa1ee314f8c655e354234017be2193c9e24e` | `storage_contract` | `Cake-LP` | -0.000000001000000623 | N/A |
| incident_drain | loss | `0xe685417bfdda1c4ca01a430faf1a20668f672d82` | `transfer_counterparty` | `cCLP_BTCB_BUSD` | -0.25571355 | N/A |


## Root cause analysis

- **Title**: cCLP gulp accounting accepted same-transaction donated LP balance as liquidation collateral value
- **Severity**: `high`
- **Confidence**: `medium`
- **Violated invariant**: Collateral exchange-rate and liquidation seize calculations must not be directly manipulable by same-transaction raw underlying-token donations that are not backed by corresponding share ownership or guarded by price/solvency validation.

### Final root cause

The cCLP_BTCB_BUSD market accepted an externally donated Cake-LP balance through `gulp()` before liquidation, making later cCLP collateral seizure and redemption valid to protocol code. The exact cCLP/comptroller source branch is unavailable in available evidence, so the RCA is partial rather than complete. The observed trigger is a raw Cake-LP transfer of 53410306284612 into cCLP followed by `gulp()`, and the effect is borrower cCLP seizure plus Cake-LP loss during redemption.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x93790c641d029d1cbd779d87b88f67704b6a8f4c` | `cCLP_BTCB_BUSD` | `primary vulnerable market` | `0xbeba905188a00b8c2fa2789e2550a3a3144b1c8f` |
| `0xfc518333f4bc56185bdd971a911fce03dee4fc8c` | `unknown comptroller` | `liquidation/seize calculation dependency` | `0x6d9fe7c99e12e3fe3fa862ebc14f5ab6ad920ef1` |

### Recommended fixes

- In cCLP `gulp()` and exchange-rate accounting, do not count arbitrary same-transaction underlying-token donations as collateral value unless they are tied to mint/redeem share accounting.
- In comptroller liquidation/seize calculations, validate collateral value through a manipulation-resistant price/solvency path and reject exchange-rate changes caused only by raw balance donations.

### Limitations

- missing_assumption: cCLP_BTCB_BUSD implementation source and comptroller implementation source are not present under source bundle, and compact execution summary does not include their formulas.
- source_formula_gap: the exact `gulp()`, exchange-rate, health-check, and seize-token source branches could not be inspected.
- Storage slot names for cCLP execution steps are not decoded; the report only relies on observed slot writes and their timing/value.
- USD impact is unpriced in the supplied PoC/economic evidence.
