# RCA Run Report — ethereum 0x26bcefc1…d6591f


## Case overview

- **Chain**: ethereum (chain_id=56)
- **Tx hash**: `0x26bcefc152d8cd49f4bb13a9f8a6846be887d7075bc81fa07aa8c0019bd6591f`
- **Block**: 57780985
- **Final quality**: `partial`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC, but RCA is partial.
- **Elapsed**: 1154.32s (1154322 ms)
- **Finding**: Source-gapped D3X proxy branch allowed helper-mediated movement of protocol-held assets


## Reproduction quality

- **PoC status**: `verified`
- **Forge fmt**: `pass`
- **Forge build**: `pass`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`
- **RCA status**: `partial` / `partial`
- **RCA confidence**: `medium`

## Economic reproduction

- **Basis**: incident profit oracle usd
- **Verdict**: exact — PoC reproduces 99–101% of incident net loss.
- **Incident net loss**: $239865.66
- **PoC net reproduced**: $158961.24
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

- Transaction: `0x26bcefc152d8cd49f4bb13a9f8a6846be887d7075bc81fa07aa8c0019bd6591f`
- Block: `57780985`
- Root call type: `CALL`
- Target/tx.to: `0x3b3e1edeb726b52d5de79cf8dd8b84995d9aa27c`
- Attacker: `0x4b63c0cf524f71847ea05b59f3077a224d922e8d`

## Multi-leg reconciliation

- Status: `pass`
- Basis: `poc_selected_direct_attacker_gain`
- Source: `economic_reproduction`
- Selected rows: 1
- Note: Verified selected gain-family rows are primary for this economic proof; incident drain/loss legs remain available in the incident context.

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| poc_selected_direct_attacker_gain | gain | `0x4b63c0cf524f71847ea05b59f3077a224d922e8d` | `tx_from_eoa` | `BNB` | 190.253117446131167874 | $158961.24 |


## Root cause analysis

- **Title**: Source-gapped D3X proxy branch allowed helper-mediated movement of protocol-held assets
- **Severity**: `high`
- **Confidence**: `medium`
- **Violated invariant**: Protocol-held assets must move only when caller, recipient, token pair, and amount are authorized by a source-visible entitlement or accounting check.

### Final root cause

The probable vulnerable surface is the implementation behind D3X proxy 0xb8ad82c4771daa852ddf00b70ba4be57d22edd99, reached through helper contracts using unresolved selectors 0xe09618e9, 0xacfca76f, and 0x82839fae during the flash callback. Available evidence show the proxy lost USDT and d3xat, while later PancakeRouter/PancakePair swaps converted acquired USDT into native BNB profit. The exact implementation function, branch, and patchable line cannot be identified because the implementation/helper source and decoded selector semantics are absent from the available evidence.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0xb8ad82c4771daa852ddf00b70ba4be57d22edd99` | `TransparentUpgradeableProxy` | `primary asset-holding proxy with source-gapped implementation` | `0x94ddcd7253ac864ec77a2ddc2be4b2418ed17c9d` |
| `0x94ddcd7253ac864ec77a2ddc2be4b2418ed17c9d` | `unknown` | `runtime implementation reported by EIP-1967 RPC observation` | `—` |

### Recommended fixes

- Recover verified source or decoded layout for implementation 0x94ddcd7253ac864ec77a2ddc2be4b2418ed17c9d and add or repair the authorization/entitlement guard in the helper-mediated asset-movement branch so caller, token pair, recipient, and amount are validated before transfer/swap effects.

### Limitations

- implementation_source_missing_for_0x94ddcd7253ac864ec77a2ddc2be4b2418ed17c9d
- helper_selector_semantics_missing_for_0xe09618e9_0xacfca76f_0x82839fae
- source_layout_required_for_semantics
- prior_state_provenance_gap
- missing_assumption
- unjustified_inference
- overgeneralization
