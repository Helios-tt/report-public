# RCA Run Report — ethereum 0xde903046…f45983


## Case overview

- **Chain**: ethereum (chain_id=8453)
- **Tx hash**: `0xde903046b5cdf27a5391b771f41e645e9cc670b649f7b87b1524fc4076f45983`
- **Block**: 29437439
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 1087.73s (1087729 ms)
- **Finding**: ImpermaxV3 bad-debt restructuring lets a borrower haircut debt and redeem collateral in the same transaction


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
- **Incident net loss**: $62667.62
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

- Transaction: `0xde903046b5cdf27a5391b771f41e645e9cc670b649f7b87b1524fc4076f45983`
- Block: `29437439`
- Root call type: `CALL`
- Target/tx.to: `0x98e938899902217465f17cf0b76d12b3dca8ce1b`
- Attacker: `0xe3223f7e3343c2c8079f261d59ee1e513086c7c3`

## Multi-leg reconciliation

- Status: `pass`
- Basis: `incident_drain`
- Source: `economic_reproduction`
- Selected rows: 2

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| incident_drain | loss | `0x5d93f216f17c225a8b5ffa34e74b7133436281ee` | `storage_contract` | `WETH` | -34.6073950781167996 | $-62647.86 |
| incident_drain | loss | `0xd0b53d9277642d899df5c87a3966a349a798f224` | `storage_contract` | `USDC` | -19.760825 | $-19.76 |


## Root cause analysis

- **Title**: ImpermaxV3 bad-debt restructuring lets a borrower haircut debt and redeem collateral in the same transaction
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: A bad-debt haircut must not let the same borrower repay only reduced debt and immediately reclaim all collateral or withdraw borrowable liquidity.

### Final root cause

ImpermaxV3Collateral.restructureBadDebt(uint256) allows a caller to reduce both borrowable debts to the current post-liquidation collateral ratio when a position is underwater, without seizing or locking the collateral. The attacker used tokenId 255 to borrow WETH, triggered the bad-debt haircut, repaid only the reduced balance through Borrowable.borrow(..., amount=0), then passed the full collateral redeem branch's zero-borrow checks and redeemed imxB shares for WETH.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0xc1d49fa32d150b31c4a5bf1cbf23cf7ac99eaf7d` | `ImpermaxV3Collateral` | `primary vulnerable contract` | `—` |
| `0x5d93f216f17c225a8b5ffa34e74b7133436281ee` | `ImpermaxV3Borrowable` | `debt accounting and redeemed borrowable share contract` | `—` |

### Recommended fixes

- Change ImpermaxV3Collateral.restructureBadDebt so a debt haircut is coupled to collateral seizure or locking, and make redeem reject positions whose debt was just reduced unless the original pre-haircut borrow balance has been fully repaid.
