# RCA Run Report — ethereum 0xc7477d6a…4067f8


## Case overview

- **Chain**: ethereum (chain_id=1)
- **Tx hash**: `0xc7477d6a5c63b04d37a39038a28b4cbaa06beb167e390d55ad4a421dbe4067f8`
- **Block**: 23145764
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 856.97s (856969 ms)
- **Finding**: LeverageUp generic swap route lets attackers execute arbitrary token calls with LeverageUp spender authority


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

- Transaction: `0xc7477d6a5c63b04d37a39038a28b4cbaa06beb167e390d55ad4a421dbe4067f8`
- Block: `23145764`
- Root call type: `CALL`
- Target/tx.to: `0xa6dc1fc33c03513a762cdf2810f163b9b0fd3a71`
- Attacker: `0xa7e9b982b0e19a399bc737ca5346ef0ef12046da`

## Multi-leg reconciliation

- Status: `pass`
- Basis: `incident_drain`
- Source: `economic_reproduction`
- Selected rows: 1

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| incident_drain | loss | `0x83eccb05386b2d10d05e1baea8ac89b5b7ea8290` | `transfer_counterparty` | `PT-wstUSR-25SEP2025` | -20000 | N/A |


## Root cause analysis

- **Title**: LeverageUp generic swap route lets attackers execute arbitrary token calls with LeverageUp spender authority
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: A leverage helper must only execute authenticated swap routes that spend its own route input balances and must not let user calldata use the helper's spender authority against third-party token allowances.

### Final root cause

LeverageUp.leverageUpWithSwap accepts the Size market and swap route from caller calldata, trusts data/risk/oracle values returned by that market, and then lets DexSwap._swapGenericRoute execute arbitrary caller-supplied low-level calldata. The attacker supplied its own contract as the Size market and encoded a GenericRoute call to PT.transferFrom(victim, attacker, 20,000e18). Because the low-level call was made by LeverageUp, the PT token treated LeverageUp as spender and consumed the victim's existing allowance.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0xf4a21ac7e51d17a0e1c8b59f7a98bb7a97806f14` | `LeverageUp` | `primary vulnerable contract` | `—` |
| `0x23e60d1488525bf4685f53b3aa8e676c30321066` | `PendlePrincipalToken` | `drained asset token enforcing allowance semantics` | `—` |

### Recommended fixes

- Require leverageUpWithSwap.size to be a trusted Size market from an authenticated factory or allowlist before using its data, riskConfig, or oracle values.
- Remove or strictly constrain GenericRoute so user calldata cannot choose arbitrary router/call data; allow only trusted swap router selectors and verify the route spends only LeverageUp's own input-token balance.
- Add a post-swap invariant that no third-party token allowance can be consumed by the helper and that token balance changes match the declared swap input/output assets.
