# RCA Run Report — ethereum 0x725f0d65…177940


## Case overview

- **Chain**: ethereum (chain_id=1)
- **Tx hash**: `0x725f0d65340c859e0f64e72ca8260220c526c3e0ccde530004160809f6177940`
- **Block**: 20836584
- **Final quality**: `partial`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC, but RCA is partial.
- **Elapsed**: 740.08s (740076 ms)
- **Finding**: Bedrock uniBTC payable mint path created unbacked uniBTC entitlement from ETH


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
- **PoC net reproduced**: $123255.92
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

- Transaction: `0x725f0d65340c859e0f64e72ca8260220c526c3e0ccde530004160809f6177940`
- Block: `20836584`
- Root call type: `CREATE`
- Target/tx.to: `unknown`
- Attacker: `0x2bfb373017349820dda2da8230e6b66739be9f96`

## PoC Surfaces

| Role | Surface | Selector | Address | Steps |
|---|---|---|---|---|
| attacker_entry | unknown | `entry` | `0x0c8da4f8b823be

_… truncated in final report; see source excerpt for full text._


## Multi-leg reconciliation

- Status: `pass`
- Basis: `poc_selected_transient_helper_gain`
- Source: `economic_reproduction`
- Selected rows: 1
- Note: Verified selected gain-family rows are primary for this economic proof; incident drain/loss legs remain available in the incident context.

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| poc_selected_transient_helper_gain | gain | `0x1e1d02d663228e5d47f1de64030b39632a3b787d` | `dynamic_instantiation` | `uniBTC` | 0.000000000198579569 | $123255.92 |


## Root cause analysis

- **Title**: Bedrock uniBTC payable mint path created unbacked uniBTC entitlement from ETH
- **Severity**: `critical`
- **Confidence**: `medium`
- **Violated invariant**: uniBTC must only be minted after accepted BTC collateral and its conversion/reserve/price bounds are validated in the same mint entitlement path.

### Final root cause

The proven causal step is the Bedrock uniBTC minter proxy mint() call: the attacker callback sent 30.8 ETH to selector 0x1249c58b on 0x047d41..., which delegatecalled incident implementation 0x702696... and then called uniBTC mint(address,uint256) for 3,080,000,000 raw uniBTC to the attacker helper. That entitlement was swapped through WBTC/WETH and later deposited to Aave, producing the observed profit/custody effects. The current implementation source/execution summary is missing, so the exact branch and guard failure inside mint() cannot be responsibly pinpointed.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x047d41f2544b7f63a8e991af2068a363d210d6da` | `TransparentUpgradeableProxy / Bedrock uniBTC minter` | `primary vulnerable contract` | `0x702696b2aa47fd1d4feaaf03ce273009dc47d901` |
| `0x004e9c3ef86bc1ca1f0bb5c7662861ee93350568` | `uniBTC` | `mint target token` | `0x51a7f889480c57cbeea81614f7d0be2b70db6c5e` |

### Recommended fixes

- Disable the incident payable mint() path or require source-visible validation that the caller supplies accepted BTC collateral, correct conversion, reserve/oracle freshness, cap checks, and recipient entitlement before calling uniBTC mint(address,uint256).
- Publish/verify the active minter implementation source and add tests asserting that ETH/WETH-native value alone cannot mint uniBTC unless explicitly backed by a validated BTC asset path.

### Limitations

- source_branch_gap: victim source for incident implementation 0x702696b2aa47fd1d4feaaf03ce273009dc47d901 is missing under internal evidence
- missing_assumption: reserve, oracle, price, collateral, cap, or post-action validation branches inside the current mint() implementation could not be inspected.
- The available VaultWithoutNative source under 0x01e9161d1621466eb086651fd514d3efb8c3752e is not the implementation resolved by bounded RPC for the incident block and is not used as complete branch evidence.
