# RCA Run Report — ethereum 0x2f1c33ea…bd1626


## Case overview

- **Chain**: ethereum (chain_id=56)
- **Tx hash**: `0x2f1c33eaaaace728f6101ff527793387341021ef465a4a33f53a0037f5bd1626`
- **Block**: 89060337
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 817.17s (817167 ms)
- **Finding**: BNBDeposit credits LP value and EST claim caps from manipulable Pancake spot quotes


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
- **Incident net loss**: $95277.88
- **PoC net reproduced**: $92253.34
- **USD ratio**: 0.968x

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

- Transaction: `0x2f1c33eaaaace728f6101ff527793387341021ef465a4a33f53a0037f5bd1626`
- Block: `89060337`
- Root call type: `CALL`
- Target/tx.to: `0xcf300de6f177ec10db0d7f756ced3ae2d2203bfd`
- Attacker: `0xcf300de6f177ec10db0d7f756ced3ae2d2203bfd`

## Multi-leg reconciliation

- Status: `pass`
- Basis: `incident_drain`
- Source: `economic_reproduction`
- Selected rows: 3

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| incident_drain | loss | `0x74986cd86caf54961dd70eedcaf7cb3fe813c0b9` | `storage_contract` | `WBNB` | -154.571495162546593567 | $-94629.96 |
| incident_drain | loss | `0x74986cd86caf54961dd70eedcaf7cb3fe813c0b9` | `storage_contract` | `EST` | -1136216484.2394441990706753 | N/A |
| incident_drain | loss | `0xbb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c` | `storage_contract` | `BNB` | -1.058335617853738214 | $-647.92 |


## Root cause analysis

- **Title**: BNBDeposit credits LP value and EST claim caps from manipulable Pancake spot quotes
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: A user's credited LP value and token claim cap must be based on manipulation-resistant value, not same-block AMM spot reserves controlled by the depositor's transaction.

### Final root cause

BNBDeposit's public BNB receive/deposit path records depositor LP value through _getLPValueInUSDT(), which uses current PancakePair reserves and router.getAmountsOut spot quotes. That manipulated lpValueInUSDT becomes the 5x cap in _claimToken(), so same-transaction AMM reserve manipulation can create excessive EST payout authority. The attacker used flash-loaned WBNB, repeated deposits, EST seeding/skimming, and the token callback claim to obtain EST and swap it for WBNB.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0xe71547170c5ad5120992b85cf1288fab23d29a61` | `BNBDeposit` | `primary vulnerable contract` | `—` |
| `0xd4524be41cd452576ab9ff7b68a0b89af8498a91` | `ESTToken` | `claim callback token and transfer-effect participant` | `—` |
| `0x74986cd86caf54961dd70eedcaf7cb3fe813c0b9` | `PancakePair` | `manipulated spot-liquidity venue and downstream drain source` | `—` |

### Recommended fixes

- Replace BNBDeposit's Pancake spot-reserve and router.getAmountsOut valuation in _getLPValueInUSDT/_getTokenValueInUSDT with a manipulation-resistant TWAP or external oracle.
- Before incrementing userInfo[user].lpValueInUSDT in _deposit(), cap credited value against deposited BNB or defer claimability until a later block after valuation finalization.
- Keep _claimToken's cap independent of same-transaction AMM reserves and reject claims when valuation freshness or oracle confidence is unavailable.
