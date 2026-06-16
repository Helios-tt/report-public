# RCA Run Report — ethereum 0x9b9a6dd0…3f0814


## Case overview

- **Chain**: ethereum (chain_id=1)
- **Tx hash**: `0x9b9a6dd05526a8a4b40e5e1a74a25df6ecccae6ee7bf045911ad89a1dd3f0814`
- **Block**: 22146340
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 985.35s (985349 ms)
- **Finding**: SilicaPools truncates share accounting to uint128 while minting full uint256 ERC1155 shares


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
- **Incident net loss**: $96090.83
- **PoC net reproduced**: $95826.31
- **USD ratio**: 0.997x

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

- Transaction: `0x9b9a6dd05526a8a4b40e5e1a74a25df6ecccae6ee7bf045911ad89a1dd3f0814`
- Block: `22146340`
- Root call type: `CALL`
- Target/tx.to: `0x80bf7db69556d9521c03461978b8fc731dbbd4e4`
- Attacker: `0xfde0d1575ed8e06fbf36256bcdfa1f359281455a`

## PoC Surfaces

| Role | Surface | Selector |

_… truncated in final report; see source excerpt for full text._


## Multi-leg reconciliation

- Status: `pass`
- Basis: `incident_drain`
- Source: `economic_reproduction`
- Selected rows: 1

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| incident_drain | loss | `0xf3f84ce038442ae4c4dcb6a8ca8bacd7f28c9bde` | `storage_contract` | `WBTC` | -1.1401539 | $-96090.83 |


## Root cause analysis

- **Title**: SilicaPools truncates share accounting to uint128 while minting full uint256 ERC1155 shares
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: For each pool, pool-level sharesMinted must equal the total redeemable ERC1155 share units minted and used by long/short payout formulas.

### Final root cause

SilicaPools._collateralizedMint accepts attacker-controlled shares and records pool accounting with sState.sharesMinted += uint128(shares) while minting the full uint256 shares value as ERC1155 long and short tokens. With shares = 2^128 + 1, the pool denominator becomes 1 while ERC1155 balances are 2^128 + 1; after transferring away 2^128 - 1 shares, the attacker retained 2 redeemable short shares. redeemShort and PoolMaths.shortPayout then used shortSharesBalance = 2 over sharesMinted = 1 and overpaid WBTC from SilicaPools.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0xf3f84ce038442ae4c4dcb6a8ca8bacd7f28c9bde` | `SilicaPools` | `primary vulnerable contract` | `—` |

### Recommended fixes

- In SilicaPools.sol:_collateralizedMint, validate shares <= type(uint128).max before uint128(shares), or store/account/mint shares as uint256 consistently so sharesMinted equals the ERC1155 supply used by PoolMaths.longPayout and PoolMaths.shortPayout.

### Limitations

- Source for the supplied index/oracle contract is not present under internal evidence; oracle semantics are treated only as secondary execution evidence context and are not required for the selected share-accounting truncation claim.
