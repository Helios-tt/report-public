# RCA Run Report — bsc 0xcf729a93…36afc5


## Case overview

- **Chain**: bsc (chain_id=56)
- **Tx hash**: `0xcf729a9392b0960cd315d7d49f53640f000ca6b8a0bd91866af5821fdf36afc5`
- **Block**: 34847596
- **Final quality**: `partial`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC, but RCA is partial.
- **Elapsed**: 791.87s (791871 ms)
- **Finding**: Dust-supply cCLP collateral was inflated by donated LP/Cake before borrowing USDC and BUSD


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
- **Verdict**: close — PoC reproduces the incident within the 80–110% net-loss band.
- **Incident net loss**: $1297.46
- **PoC net reproduced**: $1276.63
- **USD ratio**: 0.984x

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

- Transaction: `0xcf729a9392b0960cd315d7d49f53640f000ca6b8a0bd91866af5821fdf36afc5`
- Block: `34847596`
- Root call type: `CALL`
- Target/tx.to: `0xa47b9f87173eda364c821234158dda47b03ac217`
- Attacker: `0xd227dc77561b58c5a2d2644ac0173152a1a5dc3d`

## Multi-leg reconciliation

- Status: `pass`
- Basis: `incident_drain`
- Source: `economic_reproduction`
- Selected rows: 2

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| incident_drain | loss | `0x33e68c922d19d74ce845546a5c12a66ea31385c4` | `storage_contract` | `USDC` | -3150.153795938974454242 | N/A |
| incident_drain | loss | `0xca797539f004c0f9c206678338f820ac38466d4b` | `storage_contract` | `BUSD` | -1304.921512019249746678 | $-1297.46 |


## Root cause analysis

- **Title**: Dust-supply cCLP collateral was inflated by donated LP/Cake before borrowing USDC and BUSD
- **Severity**: `high`
- **Confidence**: `medium`
- **Violated invariant**: Externally donated underlying or reward/cash balances must not increase a dust-supply collateral token's borrowable value without a minimum-share/domain guard and bounded exchange-rate update.

### Final root cause

The attacker used a flash callback to donate Cake-LP and CAKE into cCLP_BTCB_BUSD, call accrueInterest(), enter the cCLP market, and then borrow available USDC and BUSD. RPC shows the attacker consumed one cCLP while totalSupply moved from 2 to 1, supporting an inflated collateral/exchange-rate path rather than a giant mint. The exact cToken exchange-rate/collateral formula and guard are not source-visible in the available evidence, so this is partial rather than complete.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x93790c641d029d1cbd779d87b88f67704b6a8f4c` | `cCLP_BTCB_BUSD` | `primary vulnerable collateral market` | `0xbeba905188a00b8c2fa2789e2550a3a3144b1c8f` |
| `0x33e68c922d19d74ce845546a5c12a66ea31385c4` | `cUSDC` | `borrowed loss market` | `—` |
| `0xca797539f004c0f9c206678338f820ac38466d4b` | `cBUSD` | `borrowed loss market` | `—` |

### Recommended fixes

- In the cCLP/cToken implementation, make collateral valuation ignore unsolicited underlying/reward token donations or enforce a minimum-share/domain guard and maximum exchange-rate jump before borrow liquidity is granted.
- Require cCLP exchange-rate/collateral updates used by borrow checks to be based on accounted mint/redeem state, not raw token balances that can be manipulated within a flash-loan callback.

### Limitations

- cToken_formula_source_gap
- source_or_layout_for_cCLP_missing
- prior_state_provenance_gap
- missing_assumption: exact exchange-rate, collateral-factor, borrow-allowed, and oracle/health-check formula bodies are not present in supplied source or execution summary
