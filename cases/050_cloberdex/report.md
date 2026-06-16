# RCA Run Report — base 0x8fcdfcde…361c04


## Case overview

- **Chain**: base (chain_id=8453)
- **Tx hash**: `0x8fcdfcded45100437ff94801090355f2f689941dca75de9a702e01670f361c04`
- **Block**: 23514451
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 397.60s (397604 ms)
- **Finding**: Rebalancer burn hook reentrancy lets attacker withdraw against stale reserves


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
- **Verdict**: exact — PoC reproduces 99–101% of incident net loss.
- **Incident net loss**: $497024.83
- **PoC net reproduced**: $497024.83
- **USD ratio**: 1.000x

## Attack narrative

_No standalone `attack_flow.md` was available; this section is assembled from RCA report fields._

### RCA-derived flow

Rebalancer allows a caller-created pool to store an arbitrary strategy contract, then _burn calls pool.strategy.burnHook after burning LP supply but before reducing pool reserves and finalizing transfers. The attacker opens a pool with its own contract as strategy, mints LP, burns, and re-enters burn from burnHook; the nested burn observes reduced totalSupply with stale reserves and receives a duplicate withdrawal entitlement. This transaction directly caused Rebalancer's WETH loss.

**Violated invariant**: A burn must not invoke untrusted external hooks while pool reserves still include liquidity already assigned to the in-progress withdrawal, especially after LP supply has been reduced.

| Field | Value |
|---|---|
| Entry function | attack() / tx selector 0xba0bba40 on attack contract; Rebalancer.open, mint, burn, reentrant burn |
| Funding source | Morpho flashLoan(WETH) |
| Public entrypoint | burn(bytes32,uint256,uint256,uint256) |
| Attacker callbacks | strategy.burnHook via selector 0xdb7c74b6 |
| Callback is root cause | true |

### Observed impact

| Token | Amount | Token address |
|---|---:|---|
| `ETH` | 133.198885880133676669 | `0x0000000000000000000000000000000000000000` |

### Evidence Summary

- **poc_verification** (`evidence summary`): Economic proof, execution, forge build/test, and product static validation all pass; PoC reproduces attacker ETH profit.
- **balance_impact** (`evidence summary`): Rebalancer lost 133.7 WETH and attacker EOA gained about 133.198885880133676669 ETH.
- **evidence** (`evidence summary`): Evidence summary connects Rebalancer open, mint, burn, and nested burn steps to the WETH loss while marking ERC20 transfer/approval steps as downstream shapes.
- **attack_path** (`evidence summary`): PoC opens a pool with the attack contract as strategy, mints LP, burns, and re-enters burn from callback before unwrapping WETH to ETH profit.
- **source** (`evidence summary`): _open stores arbitrary strategy; mint invokes strategy hook after mint; _burn computes withdrawal, burns LP, calls burnHook before reserve updates and transfers.
- **source** (`evidence summary`): LP burn decreases totalSupply before Rebalancer's burnHook call, enabling nested burn to observe reduced supply with stale reserves.
- **evidence** (`execution summary`): Execution evidence shows burn, callback to attack contract selector 0xdb7c74b6, LP balance read, and reentrant burn before the outer burn returns.
- **negative_evidence** (`evidence summary`): Approval/transfer steps were rejected as root cause effects, and no source-visible oracle/price/health/solvency gate was found for the withdrawal decision.

## Multi-leg reconciliation

_Top incident drain/loss legs are shown first; gain and mechanical legs remain available in `report/run_summary.json`._

| Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| loss | `0x6a0b87d6b74f7d5c92722f6a11714dbeda9f3895` | `storage_contract` | `WETH` | -133.7 | -$497024.83 |

## Root cause analysis

- **Title**: Rebalancer burn hook reentrancy lets attacker withdraw against stale reserves
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: A burn must not invoke untrusted external hooks while pool reserves still include liquidity already assigned to the in-progress withdrawal, especially after LP supply has been reduced.

### Final root cause

Rebalancer allows a caller-created pool to store an arbitrary strategy contract, then _burn calls pool.strategy.burnHook after burning LP supply but before reducing pool reserves and finalizing transfers. The attacker opens a pool with its own contract as strategy, mints LP, burns, and re-enters burn from burnHook; the nested burn observes reduced totalSupply with stale reserves and receives a duplicate withdrawal entitlement. This transaction directly caused Rebalancer's WETH loss.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x6a0b87d6b74f7d5c92722f6a11714dbeda9f3895` | `Rebalancer` | `primary vulnerable contract` | `—` |

### Recommended fixes

- Move pool.strategy.burnHook after reserve accounting and withdrawal transfers are finalized, or remove external burn hooks from burn-critical accounting paths.
- Add a non-reentrant guard around mint, burn, and rebalance so strategy hooks cannot re-enter share/accounting operations.
- Restrict or whitelist strategy contracts if arbitrary untrusted hook execution is not intended for Rebalancer pools.
