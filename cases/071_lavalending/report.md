# RCA Run Report — arbitrum 0xcb1a2f5e…e9e603


## Case overview

- **Chain**: arbitrum (chain_id=42161)
- **Tx hash**: `0xcb1a2f5eeb1a767ea5ccbc3665351fadc1af135d12a38c504f8f6eb997e9e603`
- **Block**: 195240643
- **Final quality**: `partial`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC, but RCA is partial.
- **Elapsed**: 1231.89s (1231889 ms)
- **Finding**: LendingPool borrow validation accepted manipulation-sensitive UniV3 LP collateral valuation


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

- Transaction: `0xcb1a2f5eeb1a767ea5ccbc3665351fadc1af135d12a38c504f8f6eb997e9e603`
- Block: `195240643`
- Root call type: `CALL`
- Target/tx.to: `0x3e52c217a902002ca296fe6769c22fedaee9fda1`
- Attacker: `0x851aa754c39bf23cdaac2025367514dfd7530418`

## Multi-leg reconciliation

- Status: `pass`
- Basis: `poc_profit_fallback`
- Source: `economic_reproduction`
- Selected rows: 1
- Note: Incident drain/loss legs were absent; verified PoC attacker-gain legs are recorded for reconciliation.

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| poc_profit | gain | `0x851aa754c39bf23cdaac2025367514dfd7530418` | `tx_from_eoa` | `ETH` | 20.33293523288800306 | N/A |


## Root cause analysis

- **Title**: LendingPool borrow validation accepted manipulation-sensitive UniV3 LP collateral valuation
- **Severity**: `critical`
- **Confidence**: `medium`
- **Violated invariant**: Borrow health-factor validation must value LP collateral with a manipulation-resistant oracle/TWAP and must not allow in-transaction Uniswap spot state to inflate collateral that backs debt.

### Final root cause

The source-backed borrow gate is LendingPool.borrow/_executeBorrow, which releases assets after ValidationLogic and GenericLogic value collateral through oracle.getAssetPrice. The attacker deposits WETH and USDC_USDC_LP collateral, then borrows and withdraws LP/reserve assets after the account appears sufficiently collateralized. The LP wrapper source exposes getAssets() through getCurrentPrice()/Uniswap V3 slot0, so the likely violated invariant is that LP collateral must be priced by a manipulation-resistant oracle/TWAP before debt is allowed. The available evidence do not prove the exact AaveOracle asset-source mapping for the LP reserve, so this is partial rather than complete.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x403049e886b13e42c149f15450ceb795216cddc6` | `InitializableImmutableAdminUpgradeabilityProxy / LendingPool` | `primary vulnerable borrow validation contract` | `0xdaf57db465298eb268a5dba1484cde20da65c4fd` |
| `0x10bda01ac4e644fd84a04dab01e15a5edcee46dd` | `ERC1967Proxy / UniV3Wrapper` | `LP collateral wrapper with source-visible spot-price valuation primitive` | `0xf6b3c18023c1e387a673b3101c73fc985290fbd9` |

### Recommended fixes

- Set LTV to zero or disable borrowing against USDC_USDC_LP until its price source is proven manipulation-resistant.
- Replace any oracle path that values 0x10bda01ac4e644fd84a04dab01e15a5edcee46dd through UniV3Wrapper.getAssets()/getCurrentPrice()/slot0 with a TWAP or external oracle source.
- Ensure the borrow validation path rejects excessive current-vs-TWAP deviation; guards must cover collateral valuation, not only public compound or state-change helpers.

### Limitations

- missing_assumption: supplied RPC observations do not include AaveOracle.getSourceOfAsset(0x10bda01ac4e644fd84a04dab01e15a5edcee46dd) or equivalent price-source state, so the exact source contract used by getAssetPrice is not proven.
- oracle_source_mapping_gap: the source-backed LP spot-price primitive and borrow-validation path are identified, but the exact oracle mapping between them is unresolved in the available evidence.
- The supplied impact evidence summary records attacker ETH profit but no detailed victim negative token deltas.
