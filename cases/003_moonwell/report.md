# RCA Run Report — base 0x190a491c…eb05ac


## Case overview

- **Chain**: base (chain_id=8453)
- **Tx hash**: `0x190a491c0ef095d5447d6d813dc8e2ec11a5710e189771c24527393a2beb05ac`
- **Block**: 37722882
- **Final quality**: `partial`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC, but RCA is partial.
- **Elapsed**: 2006.11s (2006114 ms)
- **Finding**: Moonwell borrow liquidity check accepted freshly minted mwrsETH collateral and allowed an undercollateralized wstETH borrow


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
- **Verdict**: exact — PoC reproduces 99–101% of incident net loss.
- **Incident net loss**: $88548.53
- **PoC net reproduced**: $87802.87
- **USD ratio**: 0.992x

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

- Transaction: `0x190a491c0ef095d5447d6d813dc8e2ec11a5710e189771c24527393a2beb05ac`
- Block: `37722882`
- Root call type: `CALL`
- Target/tx.to: `0x42ecd332d47c91cbc83b39bd7f53cebe5e9734bb`
- Attacker: `0x6997a8c804642ae2de16d7b8ff09565a5d5658ff`

## Multi-leg reconciliation

- Status: `pass`
- Basis: `incident_drain`
- Source: `economic_reproduction`
- Selected rows: 1

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| incident_drain | loss | `0x627fe393bc6edda28e99ae648fd6ff362514304b` | `storage_contract` | `wstETH` | -20.5920969349422768 | $-88548.53 |


## Root cause analysis

- **Title**: Moonwell borrow liquidity check accepted freshly minted mwrsETH collateral and allowed an undercollateralized wstETH borrow
- **Severity**: `high`
- **Confidence**: `medium`
- **Violated invariant**: A borrower must not be allowed to borrow wstETH unless collateral value is computed from source-verified, manipulation-resistant oracle inputs and remains greater than or equal to the requested borrow under the same transaction's fresh collateral state.

### Final root cause

The in-transaction loss passed through Moonwell's mToken borrow path. After minting 103747 mwrsETH from 20782357954960 wrsETH and entering that market, the borrow gate accepted a 20.5920969349422768 wstETH borrow because Comptroller liquidity was computed from mToken balance, exchange rate, collateral factor, and oracle.getUnderlyingPrice, then rejected only positive shortfall. The available evidence do not include the actual oracle price implementation or formula, so the exact overvaluation mechanism is unresolved; the proven cause step is the borrow-liquidity gate accepting this collateral state, not the later swaps/transfers.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0xdc649f4fa047a3c98e8705e85b8b1bafcbcfef0f` | `Comptroller` | `primary source-visible borrow liquidity gate` | `—` |
| `0x627fe393bc6edda28e99ae648fd6ff362514304b` | `mwstETH` | `borrowed mToken market that transferred wstETH out` | `0x1fad58a1310269f38d8c2c565fdc59ccbb61a2e4` |
| `0xfc41b49d064ac646015b459c522820db9472f4b5` | `mwrsETH` | `collateral mToken market used for the accepted borrow` | `0x1fad58a1310269f38d8c2c565fdc59ccbb61a2e4` |

### Recommended fixes

- Enforce the borrow invariant inside Comptroller.borrowAllowed/getHypotheticalAccountLiquidityInternal by requiring a source-auditable, manipulation-resistant collateral price path and rejecting unavailable, stale, or non-conservative oracle values.
- Add explicit validation for fresh collateral states before allowing large same-transaction borrows, or apply conservative collateral factors/TWAPs so flash-funded collateral cannot justify an otherwise undercollateralized borrow.

### Limitations

- oracle_price_source_gap: the supplied victim sources include only the PriceOracle interface, not the oracle implementation or exact getUnderlyingPrice formula.
- missing_assumption: a complete claim about the exact price/oracle manipulation would rely on an uninspected branch that can gate the same lending harm.
- The RCA therefore identifies the source-visible borrow-liquidity gate and impact path, but not the final patchable oracle/formula line.
