# RCA Run Report — ethereum 0x585d8be6…f271f8


## Case overview

- **Chain**: ethereum (chain_id=1)
- **Tx hash**: `0x585d8be6a0b07ca2f94cfa1d7542f1a62b0d3af5fab7823cbcf69fb243f271f8`
- **Block**: 22575930
- **Final quality**: `partial`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC, but RCA is partial.
- **Elapsed**: 1068.86s (1068860 ms)
- **Finding**: VaultRouter exposed its privileged USD0++ capped unwrap path to caller-controlled deposit swap calldata


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
- **Incident net loss**: $1895185.10
- **PoC net reproduced**: $43000.99
- **USD ratio**: 1.002x

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

- Transaction: `0x585d8be6a0b07ca2f94cfa1d7542f1a62b0d3af5fab7823cbcf69fb243f271f8`
- Block: `22575930`
- Root call type: `CREATE`
- Target/tx.to: `unknown`
- Attacker: `0x2ae2f691642bb18cd8deb13a378a0f95a9fee933`

## Multi-leg reconciliation

- Status: `pass`
- Basis: `poc_selected_direct_attacker_gain`
- Source: `economic_reproduction`
- Selected rows: 3
- Note: Verified selected gain-family rows are primary for this economic proof; incident drain/loss legs remain available in the incident context.

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| poc_selected_direct_attacker_gain | gain | `0x2ae2f691642bb18cd8deb13a378a0f95a9fee933` | `tx_from_eoa` | `ETH` | 15.925452345403740016 | $43000.99 |
| poc_selected_direct_attacker_gain | gain | `0xfb45bcd7239774cdbc5018fd47faf1a2fc219d1f` | `dynamic_instantiation` | `usUSDS++` | 0.000000000000000005 | N/A |
| poc_selected_direct_attacker_gain | gain | `0xfb45bcd7239774cdbc5018fd47faf1a2fc219d1f` | `dynamic_instantiation` | `UNI-V3-POS` | 0.000000000000000001 | N/A |


## Root cause analysis

- **Title**: VaultRouter exposed its privileged USD0++ capped unwrap path to caller-controlled deposit swap calldata
- **Severity**: `critical`
- **Confidence**: `medium`
- **Violated invariant**: A router holding USD0++ capped unwrap authority must not use that authority for arbitrary public deposit callers unless route, output token, recipient accounting, and minimum output are constrained to the intended vault asset and amount.

### Final root cause

VaultRouter deposit execution steps accepted an arbitrary caller-provided swapper/proof and used the router's pre-existing USD0++ capped unwrap authority through USD0++ unwrapWithCap(uint256) execution steps for the caller-supplied amount. USD0++ source shows unwrapWithCap requires role and cap, burns USD0++ from msg.sender, and transfers USD0 to msg.sender, so the current evidence supports consumed router authority rather than a skipped USD0++ check. The attacker paired that deposit call with a thin pre-created USD0/sUSDS Uniswap V3 route and min-output-like values of 1, enabling downstream Curve/Uniswap settlement and ETH profit. The exact VaultRouter source branch is not present, so this RCA is partial.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0xe033cb1bb400c0983fa60ce62f8ecdf6a16fce09` | `VaultRouter` | `primary vulnerable contract` | `—` |
| `0x35d8949372d46b7a3d5a56006ae77b215fc69bc0` | `USD0++ TransparentUpgradeableProxy` | `privileged unwrap token consumed by router` | `0xe025d17562a62159e6731298c5a51ad444529354` |

### Recommended fixes

- In VaultRouter deposit, reject arbitrary swapper and calldata, allowlist routes and output tokens, and enforce recipient accounting plus a minimum output tied to the input amount before any privileged USD0++ unwrap is used.
- Do not let a public router call USD0++ unwrapWithCap on behalf of arbitrary users; bind USD0++ capped unwrap use to trusted internal flows and revoke or segment the router cap if public deposit paths cannot be constrained.
- Add source-visible route, oracle, and slippage checks so deposits cannot use attacker-created pools or min-output values such as 1 for large input amounts.

### Limitations

- source_gap_vaultrouter_deposit_branch
- prior_state_provenance_gap
- missing_assumption
- No verified source for 0xe033cb1bb400c0983fa60ce62f8ecdf6a16fce09 is present, so the exact vulnerable VaultRouter branch and missing guard line cannot be cited.
- The available evidence prove VaultRouter consumed USD0++ role/cap pre-state, but not the prior writer, grant path, or intended trust boundary for that cap.
- No source-backed VaultRouter oracle, price, solvency, exchange-rate, or slippage branch is available for inspection.
