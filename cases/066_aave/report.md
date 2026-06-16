# RCA Run Report — ethereum 0xc27c3ec6…b0e9de


## Case overview

- **Chain**: ethereum (chain_id=1)
- **Tx hash**: `0xc27c3ec61c61309c9af35af062a834e0d6914f9352113617400577c0f2b0e9de`
- **Block**: 20624704
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 1319.32s (1319316 ms)
- **Finding**: Aave ParaSwap repay adapter accepts unbound arbitrary ParaSwap calldata as proof of a valid debt-repayment swap


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
- **Incident net loss**: $0.00
- **PoC net reproduced**: $32034.10
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

- Transaction: `0xc27c3ec61c61309c9af35af062a834e0d6914f9352113617400577c0f2b0e9de`
- Block: `20624704`
- Root call type: `CREATE`
- Target/tx.to: `unknown`
- Attacker: `0x6ea83f23795f55434c38ba67fcc428aec0c296dc`

## Multi-leg reconciliation

- Status: `pass`
- Basis: `poc_selected_direct_attacker_gain`
- Source: `economic_reproduction`
- Selected rows: 4
- Note: Verified selected gain-family rows are primary for this economic proof; incident drain/loss legs remain available in the incident context.

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| poc_selected_direct_attacker_gain | gain | `0x6ea83f23795f55434c38ba67fcc428aec0c296dc` | `tx_from_eoa` | `wstETH` | 0.425966524925658359 | $1241.87 |
| poc_selected_direct_attacker_gain | gain | `0x6ea83f23795f55434c38ba67fcc428aec0c296dc` | `tx_from_eoa` | `USDC` | 0.000000021426349775 | $21428.46 |
| poc_selected_direct_attacker_gain | gain | `0x6ea83f23795f55434c38ba67fcc428aec0c296dc` | `tx_from_eoa` | `WETH` | 1.682081696577984059 | $4166.80 |
| poc_selected_direct_attacker_gain | gain | `0x6ea83f23795f55434c38ba67fcc428aec0c296dc` | `tx_from_eoa` | `USDT` | 0.000000005195215319 | $5196.97 |


## Root cause analysis

- **Title**: Aave ParaSwap repay adapter accepts unbound arbitrary ParaSwap calldata as proof of a valid debt-repayment swap
- **Severity**: `high`
- **Confidence**: `high`
- **Violated invariant**: Adapter-held collateral may only be spent through ParaSwap calldata whose actual route source token, destination token, amount, funds, recipient/beneficiary, and balance-delta provenance match the declared collateral-to-debt repayment operation.

### Final root cause

ParaSwapRepayAdapter.swapAndRepay pulls the caller's aTokens and withdraws declared collateral, then passes caller-supplied paraswapData into BaseParaSwapBuyAdapter._buyOnParaSwap. That helper validates a registered Augustus address and oracle/slippage bounds over declared assets, but it does not bind the actual buyCalldata source token, destination token, amount, funds, recipient/beneficiary, or callback behavior to the declared repayment operation. The attacker supplied ParaSwap calldata whose route and callback behavior could satisfy the adapter's post-call balance-delta checks and debt repayment while extracting multi-token profit.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x02e7b8511831b1b02d9018215a0f8f500ea5c6b3` | `ParaSwapRepayAdapter` | `primary vulnerable contract` | `—` |
| `0x4d5f47fa6a74757f35c14fd3a6ef8e3c9bc514e8` | `aEthWETH` | `downstream aToken entitlement/accounting contract` | `0x7effd7b47bfd17e52fb7559d3f924201b9dbff3d` |
| `0xdef171fe48cf0115b1d80b88dc8eab59176fee57` | `AugustusSwapper` | `external swap executor whose flexible calldata was trusted by the adapter` | `0xdffd3c14bdd421b8b94c5e746bfcf021312cad9b` |

### Recommended fixes

- In BaseParaSwapBuyAdapter._buyOnParaSwap, decode and allowlist the accepted ParaSwap methods and require the actual route source token, destination token, amount, funds, recipient/beneficiary, and post-call balance provenance to match the declared collateral/debt repayment operation.
- Reject arbitrary callbacks or unrecognized Augustus calldata for repay adapters; if route semantics cannot be decoded and matched, do not approve tokenTransferProxy or execute the external call.
- Keep the oracle/slippage check, but treat it as a necessary bound over a validated route rather than proof that arbitrary buyCalldata performed the intended swap.

### Limitations

- No limitation affects the selected causal claim. The Aave Pool implementation source was not needed to identify the vulnerable adapter branch because the selected invariant break is source-visible in ParaSwapRepayAdapter and BaseParaSwapBuyAdapter; Pool/aToken steps are used only as downstream accounting evidence.
