# RCA Run Report — bsc 0xc291d70f…1f64c6


## Case overview

- **Chain**: bsc (chain_id=56)
- **Tx hash**: `0xc291d70f281dbb6976820fbc4dbb3cfcf56be7bf360f2e823f339af4161f64c6`
- **Block**: 63856735
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 860.47s (860467 ms)
- **Finding**: BorrowerOperationsV6 sell lets attackers route trusted borrower-router authority into arbitrary TokenHolder privilegedLoan calldata


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
- **Incident net loss**: $25772.07
- **PoC net reproduced**: $24741.19
- **USD ratio**: 0.960x

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

- Transaction: `0xc291d70f281dbb6976820fbc4dbb3cfcf56be7bf360f2e823f339af4161f64c6`
- Block: `63856735`
- Root call type: `CALL`
- Target/tx.to: `0xe82fc275b0e3573115eadca465f85c4f96a6c631`
- Attacker: `0x3fee6d8aaea76d06cf1ebeaf6b186af215f14088`

## PoC Surfaces

| Role | Surface | Selector | Address | Steps |
|---|---|---|---|---|
| attacker_callback | repayLoan(uint256,bool) | `0x83936b24` | `0xe82fc275b0e3573115eadca465f85c4f96a6c631` | `14` |
| attacker_callback | privilegedLoan(address,uint256) | `0x99270154` | `0xe82fc275b0e3573115eadca465f85c4f96a6c631` | `5` |
| attacker_callback | loans(uint256) | `0xe1ec3c68` | `0xe82fc275b0e3573115eadca465f85c4f96a6c631` | `4` |
| attacker_entry | unknown | `0xe4c61b84` | `0xe82fc275b0e3573115eadca465f85c4f96a6c631` | `1` |

## Economic Effect

- Reconciliation basis: `incident_drain`
- Verdict: `close`
- Comparison basis: `holder_net_usd_loss`

| Source | Direction | Holder | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| incident_drain | loss | `0x2eed3dc9c5134c056825b12388ee9be04e522173` | `WBNB` | -20 | $-25772.07 |


## Multi-leg reconciliation

- Status: `pass`
- Basis: `incident_drain`
- Source: `economic_reproduction`
- Selected rows: 1

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| incident_drain | loss | `0x2eed3dc9c5134c056825b12388ee9be04e522173` | `storage_contract` | `WBNB` | -20 | $-25772.07 |


## Root cause analysis

- **Title**: BorrowerOperationsV6 sell lets attackers route trusted borrower-router authority into arbitrary TokenHolder privilegedLoan calldata
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: A borrower router must not let untrusted callers choose the TokenHolder identity, loan record source, privileged-call target, or calldata that exercises TokenHolder borrower-router authority.

### Final root cause

BorrowerOperationsV6.sell accepts caller-controlled tokenHolder, inchRouter, and sellingCode, reads loan data from the supplied tokenHolder, and then performs inchRouter.call(sellingCode) while the router is trusted by TokenHolder. The attacker supplied a fake tokenHolder for loans/repay callbacks and set inchRouter to the real TokenHolder proxy with calldata for privilegedLoan(WBNB,20e18). TokenHolder's role gate saw the authorized BorrowerOperations proxy as msg.sender and transferred 20 WBNB, after which sell distributed 19.2 WBNB to the attacker and 0.8 WBNB as fee.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x616b36265759517af14300ba1dd20762241a3828` | `BorrowerOperationsV6 proxy` | `primary vulnerable contract` | `0x8c7f34436c0037742aecf047e06fd4b27ad01117` |
| `0x2eed3dc9c5134c056825b12388ee9be04e522173` | `TokenHolder proxy` | `privileged asset holder drained through router authority` | `0x3403f2ba8aa448c208c2d1a41f2089c5a6f924e4` |

### Recommended fixes

- In BorrowerOperationsV6.sell, require the supplied tokenHolder and loanId to match a loan record owned by msg.sender and require the returned borrower to equal msg.sender before any privilegedLoan, approve, external call, repay, or payout.
- Replace arbitrary inchRouter.call(sellingCode) with calls only to allowlisted swap routers and reject TokenHolder/protocol privileged targets; re-enable router/token/amount whitelist checks before external calls.
- Limit approvals to exact verified amounts and perform post-action accounting against the authenticated loan, not against balances created by arbitrary external calls.
