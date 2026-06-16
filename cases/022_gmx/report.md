# RCA Run Report — arbitrum 0x0b8cd648…0a4712


## Case overview

- **Chain**: arbitrum (chain_id=42161)
- **Tx hash**: `0x0b8cd648fb585bc3d421fc02150013eab79e211ef8d1c68100f2820ce90a4712`
- **Block**: 355878385
- **Final quality**: `partial`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC, but RCA is partial.
- **Elapsed**: 612.05s (612048 ms)
- **Finding**: GMX OrderBook increase-order setup persists executable position parameters before the decisive execution branch visible in evidence


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
- **Incident net loss**: unknown
- **PoC net reproduced**: $265.80
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

- Transaction: `0x0b8cd648fb585bc3d421fc02150013eab79e211ef8d1c68100f2820ce90a4712`
- Block: `355878385`
- Root call type: `CALL`
- Target/tx.to: `0x7d3bd50336f64b7a473c51f54e7f0bd6771cc355`
- Attacker: `0xdf3340a436c27655ba62f8281565c9925c3a5221`

## PoC Surfaces

| Role | Surface | Selector | Address | Steps |
|---|---|---|---|---|
| attacker_entry | unknown | `0x601894bb` | `0x7d3bd50336f64b7a473c51f54e7f0bd6771cc355` | `1` |

## Economic Effect

- Reconciliation basis: `poc_selected_direct_attacker_gain`
- Verdict: `exact`
- Comparison basis: `incident_profit_oracle_usd`

| Source | Direction | Holder | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| poc_selected_direct_attacker_gain | gain | `0x7d3bd50336f64b7a473c51f54e7f0bd6771cc355` | `ETH` | 0.1 | $265.80 |


## Multi-leg reconciliation

- Status: `pass`
- Basis: `poc_selected_direct_attacker_gain`
- Source: `economic_reproduction`
- Selected rows: 1
- Note: Verified selected gain-family rows are primary for this economic proof; incident drain/loss legs remain available in the incident context.

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| poc_selected_direct_attacker_gain | gain | `0x7d3bd50336f64b7a473c51f54e7f0bd6771cc355` | `attacker_entry` | `ETH` | 0.1 | $265.80 |


## Root cause analysis

- **Title**: GMX OrderBook increase-order setup persists executable position parameters before the decisive execution branch visible in evidence
- **Severity**: `medium`
- **Confidence**: `medium`
- **Violated invariant**: An executable increase order should not be persisted unless its order parameters are proven admissible for the same economic position constraints that will protect vault execution.

### Final root cause

The current transaction calls OrderBook.createIncreaseOrder with a WETH-wrapped one-token path and stores attacker-controlled increase-order fields after fee, wrapped-value, and minimum collateral-value checks. This creates loss-enabling order state, but the supplied execution evidence does not include executeIncreaseOrder or Vault.increasePosition, where trigger, leverage, liquidation, and health checks would prove the actual failed invariant. WETH totalSupply expansion is explained by normal aeWETH.deposit minting of msg.value and is not itself the root cause.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x09f77e8a13de9a35a7231028187e9fd5db8a2acb` | `OrderBook` | `primary setup contract` | `—` |
| `0x489ee077994b6658eafa855c308275ead8097c4a` | `Vault` | `downstream execution and health-check contract` | `—` |
| `0x82af49447d8a07e3bd95bd0d56f35241523fbab1` | `WETH proxy` | `wrapped ETH accounting effect` | `0x8b194beae1d3e0788a1a35173978001acdfba668` |

### Recommended fixes

- If the missing execution transaction confirms the setup-to-loss path, enforce the same position health/leverage admissibility bound before OrderBook.createIncreaseOrder persists an executable increase order, or make order execution re-check and atomically reject any stale or invalid order parameters before collateral movement.

### Limitations

- tx_scope_gap: available evidence do not include executeIncreaseOrder, pluginIncreasePosition, Vault.increasePosition, or a realized protocol loss step.
- missing_assumption: a complete claim would require assuming how the stored order is later executed and which health, price, or leverage branch fails.
- The observed attacker gain is 0.1 ETH retained by the attack contract after the funded transaction, while the evidence show no holder net loss leg.
