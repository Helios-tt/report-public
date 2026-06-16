# RCA Run Report — ethereum 0x2c123d08…396827


## Case overview

- **Chain**: ethereum (chain_id=56)
- **Tx hash**: `0x2c123d08ca3d50c4b875c0b5de1b5c85d0bf9979dffbf87c48526e3a67396827`
- **Block**: 42131697
- **Final quality**: `partial`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC, but RCA is partial.
- **Elapsed**: 1091.37s (1091373 ms)
- **Finding**: CUT pair balance inflation lets PancakeRouter fee-on-transfer swap over-credit input and drain USDT


## Reproduction quality

- **PoC status**: `verified`
- **Forge fmt**: `pass`
- **Forge build**: `pass`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`
- **RCA status**: `partial` / `partial`
- **RCA confidence**: `medium`

## Economic reproduction

- **Basis**: position delta usd
- **Verdict**: position_delta_exact
- **Incident net loss**: unknown
- **PoC net reproduced**: $1276290.41
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

- Transaction: `0x2c123d08ca3d50c4b875c0b5de1b5c85d0bf9979dffbf87c48526e3a67396827`
- Block: `42131697`
- Root call type: `CALL`
- Target/tx.to: `0x87efb39a716860ecd2324a944cb40ec5128e56dd`
- Attacker: `0x560a77bc06dcc77eee687acb65d46b580a63eb45`

## PoC Surfaces

| Role | Surface | Selector | Address | Steps |
|---|---|---|---|---|
| attacker_entry | unknown | `0x7a50b2b8` | `0x87efb39a716860ecd2324a944cb40ec5128e56dd` | `1` |
| attacker_callback | unknown | `0x84800812` | `0x87efb39a716860ecd2324a944cb40ec5128e56dd` | `7` |

## Economic Effect

- Reconciliation basis: `poc_economic_fallback`
- Verdict: `position_delta_exact`
- Comparison basis: `position_delta_usd`

| Source | Direction | Holder | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| poc_economic | drain | `0x83681f67069a154815a0c6c2c97e2daca6ed3249` | `USDT` | -1271656.254481266714539224 | $1276290.41 |
| poc_economic | gain | `0x83681f67069a154815a0c6c2c97e2daca6ed3249` | `CUT` | 0.000005672272547205 | N/A |


## Multi-leg reconciliation

- Status: `pass`
- Basis: `poc_economic_fallback`
- Source: `economic_reproduction`
- Selected rows: 2
- Note: Incident drain/loss legs were absent; verified PoC attacker-gain legs are recorded for reconciliation.

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| poc_economic | drain | `0x83681f67069a154815a0c6c2c97e2daca6ed3249` | `storage_contract` | `USDT` | -1271656.254481266714539224 | $1276290.41 |
| poc_economic | gain | `0x83681f67069a154815a0c6c2c97e2daca6ed3249` | `storage_contract` | `CUT` | 0.000005672272547205 | N/A |


## Root cause analysis

- **Title**: CUT pair balance inflation lets PancakeRouter fee-on-transfer swap over-credit input and drain USDT
- **Severity**: `critical`
- **Confidence**: `medium`
- **Violated invariant**: The token balance delta used as AMM swap input must equal a real economically paid transfer amount and must not be inflated by token-side transfer/reflection/rebase/fee side effects during the swap.

### Final root cause

CUT transferFrom calls invoked by PancakeRouter's fee-on-transfer swap path made the CUT/USDT pair observe an inflated CUT balance delta while CUT totalSupply remained unchanged. PancakeRouter _swapSupportingFeeOnTransferTokens treated balanceOf(pair) - reserveInput as valid amountInput and fed it into getAmountOut, so PancakePair.swap accepted the post-balance state and released USDT. The exact vulnerable CUT transfer/accounting branch is not source-visible in the available evidence, so this is a partial RCA rather than a complete patchable file:line finding.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x7057f3b0f4d0649b428f0d8378a8a0e7d21d36a7` | `CUT` | `primary suspected vulnerable token/accounting contract` | `—` |
| `0x10ed43c718714eb63d5aa57b78b54704e256024e` | `PancakeRouter` | `source-visible balance-delta amount calculator` | `—` |
| `0x83681f67069a154815a0c6c2c97e2daca6ed3249` | `PancakePair` | `drained CUT/USDT pair that accepted reported balances` | `—` |

### Recommended fixes

- Fix CUT transfer/accounting so transfers to AMM pairs cannot inflate pair balance beyond the real debited transfer amount.
- Add invariant tests around CUT transfers through fee-on-transfer router paths asserting that balanceOf(pair) - reserveInput equals economically paid input.
- If integrating with AMM routers, disable fee/reflection/rebase side effects for pair transfers or force reserve synchronization and min-output checks that cannot rely on inflated token-side balance deltas.

### Limitations

- source_or_execution summary_for_CUT_transfer_logic_missing
- helper_selector_semantics_gap
- patchable_anchor_gap
