# RCA Run Report — ethereum 0x39328ea4…6d0c71


## Case overview

- **Chain**: ethereum (chain_id=1)
- **Tx hash**: `0x39328ea4377a8887d3f6ce91b2f4c6b19a851e2fc5163e2f83bbc2fc136d0c71`
- **Block**: 20794865
- **Final quality**: `partial`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC, but RCA is partial.
- **Elapsed**: 695.85s (695848 ms)
- **Finding**: Borrow credit was granted from borrower-forged collateral token supply


## Reproduction quality

- **PoC status**: `verified`
- **Forge fmt**: `pass`
- **Forge build**: `pass`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`
- **RCA status**: `partial` / `partial`
- **RCA confidence**: `medium`

## Economic reproduction

- **Basis**: holder-net USD loss
- **Verdict**: unpriced — raw PoC proof passed, but USD comparison is incomplete.
- **Incident net loss**: unknown
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

- Transaction: `0x39328ea4377a8887d3f6ce91b2f4c6b19a851e2fc5163e2f83bbc2fc136d0c71`
- Block: `20794865`
- Root call type: `CREATE`
- Target/tx.to: `unknown`
- Attacker: `0xa3a64255484ad65158af0f9d96b5577f79901a1d`

## PoC Surfaces

| Role | Surface | Selector | Address | Steps |
|---|---|---|---|---|
| attacker_entry | unknown | `entry` | `0xed4b3d468ded53a322a8b8280b6f35aae8bc499c` | `1` |

## Economic Effect

- Reconciliation basis: `poc_profit_fallback`
- Verdict: `unpriced`
- Comparison basis: `holder_net_usd_loss`

| Source | Direction | Holder | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| poc_profit | gain | `0xa3a64255484ad65158af0f9d96b5577f79901a1d` | `ShezUSD` | 98999168398.02 | N/A |


## Multi-leg reconciliation

- Status: `pass`
- Basis: `poc_profit_fallback`
- Source: `economic_reproduction`
- Selected rows: 1
- Note: Incident drain/loss legs were absent; verified PoC attacker-gain legs are recorded for reconciliation.

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| poc_profit | gain | `0xa3a64255484ad65158af0f9d96b5577f79901a1d` | `tx_from_eoa` | `ShezUSD` | 98999168398.02 | N/A |


## Root cause analysis

- **Title**: Borrow credit was granted from borrower-forged collateral token supply
- **Severity**: `critical`
- **Confidence**: `medium`
- **Violated invariant**: Borrow credit must only be granted for economically valid collateral that the borrower cannot permissionlessly mint or otherwise forge in the same transaction.

### Final root cause

The attacker called collateral token selector 0x40c10f19 to create 340282366920938463463374607431768211455 collateral units, then deposited that amount into the Shezmu lending proxy. ERC20Vault._addCollateral recorded the transferred amount as position.collateral, and AbstractAssetVault._borrow computed a credit limit from that collateral amount through the value provider before minting ShezUSD. The exact collateral-token mint branch is source-gapped, so the RCA is partial rather than complete.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x75a04a1fee9e6f26385ab1287b20ebdcbdabe478` | `TransparentUpgradeableProxy / ERC20Vault` | `primary lending market that accepted forged collateral as borrow credit` | `0xa35f69899796ddbc4a8904511d2f1f040b779cb7` |
| `0x641249db01d5c9a04d1a223765ffd15f95167924` | `collateral token labelled WBTC` | `collateral token whose 0x40c10f19 call expanded attacker supply` | `—` |
| `0xd60eea80c83779a8a5bfcdac1f3323548e6bb62d` | `ShezmuUSD` | `stablecoin minted after borrow entitlement passed` | `—` |

### Recommended fixes

- Remove or access-control the collateral token selector 0x40c10f19 / mint(address,uint256) so borrowers cannot mint collateral to themselves.
- In ERC20Vault, reject borrower-forgeable or administratively unsafe collateral tokens and cap/validate collateral credit before _borrow mints ShezUSD.
- Add an invariant test that minting or receiving collateral in the same transaction cannot increase credit beyond independently backed collateral value.

### Limitations

- collateral_token_source_gap: verified source for 0x641249db01d5c9a04d1a223765ffd15f95167924 is not present under internal evidence, so the exact source branch for selector 0x40c10f19 is not patch-line pinpointed.
- missing_assumption: the collateral token 0x40c10f19 behavior is proven by step/RPC totalSupply and balance deltas, but not by verified source or source-level execution summary.
- No historical setup transaction or configuration provenance for listing the collateral token is included in the supplied available evidence.
