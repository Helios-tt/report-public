# RCA Run Report — ethereum 0x842aae91…a9e5e6


## Case overview

- **Chain**: ethereum (chain_id=1)
- **Tx hash**: `0x842aae91c89a9e5043e64af34f53dc66daf0f033ad8afbf35ef0c93f99a9e5e6`
- **Block**: 23504546
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 900.76s (900762 ms)
- **Finding**: Cauldron cook status reset lets a borrow batch skip the final solvency check


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
- **Incident net loss**: $3587228.28
- **PoC net reproduced**: $1772600.72
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

- Transaction: `0x842aae91c89a9e5043e64af34f53dc66daf0f033ad8afbf35ef0c93f99a9e5e6`
- Block: `23504546`
- Root call type: `CREATE`
- Target/tx.to: `unknown`
- Attacker: `0x1aaade3e9062d124b7deb0ed6ddc7055efa7354d`

## PoC Surfaces

| Role | Surface | Selector | Address | Steps |
|---|---|---|---|---|
| attacker_callback | unknown | `entry` | `0xb8e0a4758df2954063ca4ba3d094f2d6eda9b993` | `118` |
| attacker_entry | unknown | `entry` | `0xb8e0a4758df2954063ca4ba3d094f2d6eda9b993` | `1` |

_… truncated in final report; see source excerpt for full text._


## Multi-leg reconciliation

- Status: `pass`
- Basis: `poc_selected_direct_attacker_gain`
- Source: `economic_reproduction`
- Selected rows: 1
- Note: Verified selected gain-family rows are primary for this economic proof; incident drain/loss legs remain available in the incident context.

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| poc_selected_direct_attacker_gain | gain | `0x1aaade3e9062d124b7deb0ed6ddc7055efa7354d` | `tx_from_eoa` | `ETH` | 395.059753040555107478 | $1772600.72 |


## Root cause analysis

- **Title**: Cauldron cook status reset lets a borrow batch skip the final solvency check
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: Once any cook action creates debt or removes collateral, the batch must execute the final solvency check and no later unrecognized/custom action may clear that requirement.

### Final root cause

CauldronV4.cook marks a batch as requiring a final solvency check after ACTION_BORROW, but then lets an undefined action call the empty _additionalCookAction hook and overwrite the accumulated CookStatus with zero values. With actions [5, 0], the attacker borrows MIM and clears needsSolvencyCheck before the final updateExchangeRate/_isSolvent gate. The borrowed MIM shares are then withdrawn from DegenBox and routed through swaps into ETH.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x46f54d434063e5f1a2b2cc6d9aaa657b1b9ff82c` | `PrivilegedCheckpointCauldronV4 clone` | `primary vulnerable contract` | `0x5e70f7acb8ec0231c00220d11c74dc2b23187103` |
| `0x289424add4a1a503870eb475fd8bf1d586b134ed` | `PrivilegedCheckpointCauldronV4 clone` | `affected vulnerable contract` | `0x5e70f7acb8ec0231c00220d11c74dc2b23187103` |
| `0xce450a23378859fb5157f4c4cccaf48faa30865b` | `PrivilegedCauldronV4 clone` | `affected vulnerable contract` | `0xa9b386dcd598acf3ce53460631feefbba730cbf3` |
| `0x40d95c4b34127cf43438a963e7c066156c5b87a3` | `PrivilegedCauldronV4 clone` | `affected vulnerable contract` | `0xa9b386dcd598acf3ce53460631feefbba730cbf3` |
| `0x6bcd99d6009ac1666b58cb68fb4a50385945cda2` | `PrivilegedCauldronV4 clone` | `affected vulnerable contract` | `0xa9b386dcd598acf3ce53460631feefbba730cbf3` |
| `0xc6d3b82f9774db8f92095b5e4352a8bb8b0dc20d` | `PrivilegedCauldronV4 clone` | `affected vulnerable contract` | `0xa9b386dcd598acf3ce53460631feefbba730cbf3` |

### Recommended fixes

- In CauldronV4.sol, reject undefined cook actions or require custom actions to be action >= ACTION_CUSTOM_START_INDEX before calling _additionalCookAction.
- Change _additionalCookAction so the base implementation reverts or returns the incoming CookStatus, and add a regression test that cook([ACTION_BORROW, 0], ...) cannot bypass _isSolvent.
- When assigning returnStatus back to status, preserve status.needsSolvencyCheck with logical OR so a later custom action cannot weaken an earlier required solvency check.
