# RCA Run Report — ethereum 0xc2066e0d…4df8e1


## Case overview

- **Chain**: ethereum (chain_id=56)
- **Tx hash**: `0xc2066e0dff1a8a042057387d7356ad7ced76ab90904baa1e0b5ecbc2434df8e1`
- **Block**: 61515895
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 1023.92s (1023919 ms)
- **Finding**: NGP sell fee branch debits AMM pair reserves and syncs them as valid


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
- **Verdict**: close — PoC reproduces the priced beneficial payout against holder-net USD loss.
- **Incident net loss**: $2214177.85
- **PoC net reproduced**: $1996193.30
- **USD ratio**: 0.9016

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

- Transaction: `0xc2066e0dff1a8a042057387d7356ad7ced76ab90904baa1e0b5ecbc2434df8e1`
- Block: `61515895`
- Root call type: `CALL`
- Target/tx.to: `0x2d2a69bdafe4aad981da4e98721b3b81a0315363`
- Attacker: `0x0305ddd42887676ec593b39ace691b772eb3c876`

## Multi-leg reconciliation

- Status: `pass`
- Basis: `incident_drain`
- Source: `economic_reproduction`
- Selected rows: 5

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| incident_drain | loss | `0x20cab54946d070de7cc7228b62f213fccf3ffb1e` | `storage_contract` | `USDT` | -2212878.295009115991272037 | $-2214177.85 |
| incident_drain | loss | `0x20cab54946d070de7cc7228b62f213fccf3ffb1e` | `storage_contract` | `NGP` | -45225171.705939735119975297 | N/A |
| incident_drain | loss | `0x71a94b29bb59bd8a3bab04960e18f4dcdc2faf43` | `transfer_counterparty` | `NGP` | -426926.630852585941165 | N/A |
| incident_drain | loss | `0x76b1528feaae231c4e1edd837c741fcd03e98086` | `transfer_counterparty` | `NGP` | -226951.59436811299401739 | N/A |
| incident_drain | loss | `0x9ef16a6ea72ab6092369e0ec7be89b411942a311` | `transfer_counterparty` | `NGP` | -200719.703894179982595453 | N/A |


## Root cause analysis

- **Title**: NGP sell fee branch debits AMM pair reserves and syncs them as valid
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: A seller-triggered token transfer into an AMM pair must not debit treasury or reward fees from the AMM pair's existing reserves or force reserve synchronization after such debits.

### Final root cause

NGP Token.transferFrom enters Token._update's to == mainPair sell branch. The branch computes treasury and reward fees from the seller's transfer value, but debits those fees from mainPair and calls pair sync, violating the invariant that seller-triggered fees must not reduce AMM reserves. An attacker-controlled NGP sell therefore corrupts pair balances/reserves that later swaps accept, enabling USDT and BNB extraction.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0xd2f26200cd524db097cf4ab7cc2e5c38ab6ae5c9` | `Token` | `primary vulnerable contract` | `—` |
| `0x20cab54946d070de7cc7228b62f213fccf3ffb1e` | `PancakePair` | `affected AMM pair whose reserves were debited and synced` | `—` |

### Recommended fixes

- In Token._update's sell branch, remove mainPair debits for treasury/reward fees and the in-transfer sync call; charge all fees from the seller/incoming amount and enforce that seller-triggered fee logic cannot reduce pair reserves.

### Limitations

- prior_state_provenance_gap: the evidence show execution steps, and 7 consumed pre-existing holder allowances to acquire NGP, but do not prove how those allowances were created.
- The report selects the source-visible in-transaction NGP sell-branch accounting defect; it does not assign an unsupported cause to the prior holder allowance setup.
