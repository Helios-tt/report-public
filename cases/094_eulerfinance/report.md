# RCA Run Report — ethereum 0xc310a0af…6b111d


## Case overview

- **Chain**: ethereum (chain_id=1)
- **Tx hash**: `0xc310a0affe2169d1f6feec1c63dbc7f7c62a887fa48795d327d4d2da2d6b111d`
- **Block**: 16817996
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 878.90s (878896 ms)
- **Finding**: Euler EToken donation omitted the post-donation liquidity check


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
- **Incident net loss**: $8823124.51
- **PoC net reproduced**: $8796371.28
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

- Transaction: `0xc310a0affe2169d1f6feec1c63dbc7f7c62a887fa48795d327d4d2da2d6b111d`
- Block: `16817996`
- Root call type: `CALL`
- Target/tx.to: `0xebc29199c817dc47ba12e3f86102564d640cbf99`
- Attacker: `0x5f259d0b76665c337c6104145894f4d1d2758b8c`

## Multi-leg reconciliation

- Status: `pass`
- Basis: `incident_drain`
- Source: `economic_reproduction`
- Selected rows: 1

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| incident_drain | loss | `0x27182842e098f60e3d576794a5bffb0777e025d3` | `storage_contract` | `DAI` | -8904507.348306697267428294 | $-8823124.51 |


## Root cause analysis

- **Title**: Euler EToken donation omitted the post-donation liquidity check
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: Any action that reduces an account's collateral balance while the account can have outstanding debt must require the account to remain liquid after the state transition.

### Final root cause

The EToken donateToReserves(uint256,uint256) branch subtracts eToken balance from the caller and credits reserves without calling checkLiquidity(account). After the attacker self-minted large eDAI/dDAI exposure, this allowed the helper account to destroy collateral-like eDAI while keeping debt, making the account liquidatable. Later liquidation and withdrawal steps realized the DAI drain; they are downstream effects of the missing solvency gate.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0xbb0d4bb654a21054af95456a3b29c63e8d1f4c0a` | `EToken` | `primary vulnerable contract` | `—` |
| `0xe025e3ca2be02316033184551d4d3aa22024d9dc` | `eDAI proxy` | `user-facing eToken proxy that delegated into the vulnerable EToken module` | `0xbb0d4bb654a21054af95456a3b29c63e8d1f4c0a` |
| `0x27182842e098f60e3d576794a5bffb0777e025d3` | `Euler` | `Euler storage/dispatcher whose DAI balance was drained` | `0xec29b4c2cacae5df1a491f084e5ec7c62a7edab5` |

### Recommended fixes

- Add checkLiquidity(account) in EToken.donateToReserves immediately after the user balance/reserve accounting update and before logAssetStatus, so donations that make a borrower insolvent revert.

### Limitations

- The liquidation implementation source for execution steps was not present under source bundle; liquidation execution is still evidenced by evidence summary steps, PoC, and execution summary, and the selected root-cause branch is source-backed in EToken.
