# RCA Run Report — ethereum 0x26a83db7…7e4cf2


## Case overview

- **Chain**: ethereum (chain_id=1)
- **Tx hash**: `0x26a83db7e28838dd9fee6fb7314ae58dcc6aee9a20bf224c386ff5e80f7e4cf2`
- **Block**: 19118660
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 761.44s (761442 ms)
- **Finding**: CauldronV4 repayForAll skews totalBorrow rebase accounting and lets borrow pass solvency with understated debt


## Reproduction quality

- **PoC status**: `verified`
- **Forge fmt**: `pass`
- **Forge build**: `pass`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`
- **RCA status**: `complete` / `complete`
- **RCA confidence**: `high`

## Economic reproduction

- **Basis**: incident profit oracle usd
- **Verdict**: exact — PoC reproduces 99–101% of incident net loss.
- **Incident net loss**: $4103465.01
- **PoC net reproduced**: $4515372.47
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

- Transaction: `0x26a83db7e28838dd9fee6fb7314ae58dcc6aee9a20bf224c386ff5e80f7e4cf2`
- Block: `19118660`
- Root call type: `CREATE`
- Target/tx.to: `unknown`
- Attacker: `0x87f585809ce79ae39a5fa0c7c96d0d159eb678c9`

## PoC Surfaces

| Role | Surface | Selector | Address | Steps

_… truncated in final report; see source excerpt for full text._


## Multi-leg reconciliation

- Status: `pass`
- Basis: `poc_selected_direct_attacker_gain`
- Source: `economic_reproduction`
- Selected rows: 2
- Note: Verified selected gain-family rows are primary for this economic proof; incident drain/loss legs remain available in the incident context.

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| poc_selected_direct_attacker_gain | gain | `0x87f585809ce79ae39a5fa0c7c96d0d159eb678c9` | `tx_from_eoa` | `ETH` | 1807.677833228065417403 | $4167709.57 |
| poc_selected_direct_attacker_gain | gain | `0x87f585809ce79ae39a5fa0c7c96d0d159eb678c9` | `tx_from_eoa` | `MIM` | 349003.467479499865371154 | $347662.90 |


## Root cause analysis

- **Title**: CauldronV4 repayForAll skews totalBorrow rebase accounting and lets borrow pass solvency with understated debt
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: Any global repayment that reduces totalBorrow.elastic must preserve the totalBorrow elastic/base debt-per-part ratio by proportionally reducing totalBorrow.base and borrower debt parts, or must not be used by borrow/solvency accounting.

### Final root cause

CauldronV4 repayForAll(uint128,bool) accepts MIM already held by the Cauldron in the skim branch, deposits it into BentoBox, and subtracts the amount only from totalBorrow.elastic. It leaves totalBorrow.base and borrower userBorrowPart values unchanged, breaking the debt-per-part ratio later consumed by repay, borrow, and _isSolvent. The attacker pre-positions 240,000 MIM, calls repayForAll, performs repayment/debt-shaping calls, adds yvCurve collateral, and then borrow passes the source-visible solvency gate while allowing about 5.000047849758731262099149 million MIM to be drawn.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x7259e152103756e1616a77ae982353c3751a6a90` | `CauldronV4` | `primary vulnerable contract` | `—` |

### Recommended fixes

- At CauldronV4.sol:710, do not reduce only totalBorrow.elastic in repayForAll; remove or strictly gate the function, or update totalBorrow.base and borrower debt parts proportionally so the elastic/base debt-per-part invariant is preserved before borrow solvency checks.

### Limitations

- The top-level execution context set does not include a fully decoded Cauldron call step for every repayForAll/borrow step, so the final causal chain relies on source, execution summary, PoC execution order, evidence summary impact, and RPC balance/supply observations rather than decoded Cauldron storage slot semantics.
