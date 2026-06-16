# RCA Run Report — ethereum 0xb93506af…d3d8a4


## Case overview

- **Chain**: ethereum (chain_id=1)
- **Tx hash**: `0xb93506af8f1a39f6a31e2d34f5f6a262c2799fef6e338640f42ab8737ed3d8a4`
- **Block**: 24566937
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 959.95s (959950 ms)
- **Finding**: sDOLA counted externally credited savings balance as immediately redeemable ERC4626 assets


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
- **Verdict**: close — PoC reproduces the incident within the 80–110% net-loss band.
- **Incident net loss**: $343233.09
- **PoC net reproduced**: $285586.38
- **USD ratio**: 0.832x

## Attack narrative

_No standalone `attack_flow.md` was available; this section is assembled from RCA report fields._

### RCA-derived flow

sDOLA's `totalAssets()` uses `savings.balanceOf(address(this))` as redeemable vault assets minus only tracked weekly revenue buckets, while ERC4626 redemption prices shares from `totalAssets() / totalSupply`. The attacker directly staked DOLA into DolaSavings with sDOLA as recipient, increasing sDOLA's accounted assets without minting proportional shares or recording the increase as non-redeemable revenue. Existing sDOLA shares then redeemed for excess DOLA, and downstream Curve/LLAMMA/controller calls routed and amplified the value into attacker profit.

**Violated invariant**: DolaSavings balance credited to sDOLA must not become immediately redeemable by existing sDOLA shares unless the increase entered through sDOLA share minting or was tracked as intentionally redeemable revenue.

| Field | Value |
|---|---|
| Entry function | 0x8201355f |
| Attacker callbacks | onMorphoFlashLoan / helper callback path in PoC |
| Callback is root cause | false |

### Observed impact

| Token | Amount | Token address |
|---|---:|---|
| `DOLA` | 227325.565940517368498878 | `0x865377367054516e17014ccded1e7d814edc9ce4` |

### Evidence Summary

- **poc_verification** (`evidence summary`): Verified economic PoC passed with no hard product blockers.
- **balance_impact** (`evidence summary`): Evidence summary shows direct asset loss, attacker profit, and entitlement/accounting anomalies; it warns not to stop at approval/drain steps.
- **negative_evidence** (`evidence summary`): DOLA and crvUSD totalSupply did not expand, and sDOLA totalSupply decreased, rejecting unchecked mint or approval/transfer steps as standalone root cause.
- **attack_path** (`evidence summary`): PoC redeems sDOLA, directly stakes DOLA to DolaSavings for sDOLA, observes convertToAssets, and redeems sDOLA again.
- **source** (`evidence summary`): sDOLA stakes normal deposits, unstakes computed withdrawals, and counts savings.balanceOf(sDOLA) minus weeklyRevenue buckets as total assets.
- **source** (`evidence summary`): ERC4626 redemption entitlement is calculated as shares times totalAssets divided by totalSupply and then transferred to the receiver.
- **source** (`evidence summary`): Controller oracle, band, loan, and health branches were inspected and are secondary routing/solvency gates, not the branch creating the sDOLA redeem entitlement.
- **source** (`evidence summary`): LLAMMA oracle and dynamic-fee logic gates later swaps but does not create the sDOLA assets-per-share entitlement.

## Multi-leg reconciliation

_Top incident drain/loss legs are shown first; gain and mechanical legs remain available in `report/run_summary.json`._

| Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| loss | `0xe5f24791e273cb96a1f8e5b67bc2397f0ad9b8b4` | `storage_contract` | `DOLA` | -227325.565940517368498878 | -$226309.94 |
| loss | `0x76a962ba6770068bcf454d34dde17175611e6637` | `storage_contract` | `sDOLA` | -36243.680427226364830361 | -$42904.19 |
| loss | `0x460638e6f7605b866736e38045c0de8294d7d87f` | `storage_contract` | `alUSD` | -35150.131590310016241424 | -$34693.82 |
| loss | `0x460638e6f7605b866736e38045c0de8294d7d87f` | `storage_contract` | `sDOLA` | -19717.602377515533006991 | -$23341.11 |
| loss | `0xb30da2376f63de30b42dc055c93fa474f31330a5` | `storage_contract` | `crvFRAX` | -13921.274327861982608271 | -$14056.79 |
| loss | `0xdcef968d416a41cdac0ed8702fac8128a64241a2` | `storage_contract` | `USDC` | -13241.509653 | -$13241.45 |
| loss | `0xb4e16d0168e52d35cacd2c6185b44281ec28c9dc` | `storage_contract` | `WETH` | -6.736786843758250456 | -$13183.65 |
| loss | `0x76a962ba6770068bcf454d34dde17175611e6637` | `storage_contract` | `scrvUSD` | -2517.029742714566602229 | -$2742.58 |

## Root cause analysis

- **Title**: sDOLA counted externally credited savings balance as immediately redeemable ERC4626 assets
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: DolaSavings balance credited to sDOLA must not become immediately redeemable by existing sDOLA shares unless the increase entered through sDOLA share minting or was tracked as intentionally redeemable revenue.

### Final root cause

sDOLA's `totalAssets()` uses `savings.balanceOf(address(this))` as redeemable vault assets minus only tracked weekly revenue buckets, while ERC4626 redemption prices shares from `totalAssets() / totalSupply`. The attacker directly staked DOLA into DolaSavings with sDOLA as recipient, increasing sDOLA's accounted assets without minting proportional shares or recording the increase as non-redeemable revenue. Existing sDOLA shares then redeemed for excess DOLA, and downstream Curve/LLAMMA/controller calls routed and amplified the value into attacker profit.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0xb45ad160634c528cc3d2926d9807104fa3157305` | `sDola` | `primary vulnerable contract` | `—` |
| `0xe5f24791e273cb96a1f8e5b67bc2397f0ad9b8b4` | `DolaSavings or savings-like staking contract` | `underlying balance source credited to sDOLA` | `—` |

### Recommended fixes

- Track sDOLA-managed principal and revenue internally, and make `totalAssets()` exclude unsolicited DolaSavings balance increases until they are explicitly processed as proportional share minting or vested revenue.
- Prevent direct external staking to DolaSavings with sDOLA as recipient from changing same-transaction redeemable share price for existing shares.
- Add invariant tests that direct DolaSavings credits to sDOLA cannot increase `convertToAssets(1e18)` for existing shares in the same transaction.

### Limitations

- internal evidence was absent from the available public bundle, so PoC action evidence was taken from internal evidence
- Source for the underlying DolaSavings contract at 0xe5f24791e273cb96a1f8e5b67bc2397f0ad9b8b4 was not present under source bundle; the needed `stake(uint256,address)` call and sDOLA recipient are evidenced by the PoC, and the selected causal accounting branch is in sDOLA source.
