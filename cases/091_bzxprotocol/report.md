# RCA Run Report — ethereum 0x0fc5c0d4…ce73b0


## Case overview

- **Chain**: ethereum (chain_id=1)
- **Tx hash**: `0x0fc5c0d41e5506fdb9434fab4815a4ff671afc834e47a533b3bed7182ece73b0`
- **Block**: 18695729
- **Final quality**: `partial`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC, but RCA is partial.
- **Elapsed**: 1209.28s (1209277 ms)
- **Finding**: iYFI raw-balance share price inflation let donated YFI overvalue collateral for bZx borrows


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
- **Incident net loss**: $88408.00
- **PoC net reproduced**: $87785.49
- **USD ratio**: 0.993x

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

- Transaction: `0x0fc5c0d41e5506fdb9434fab4815a4ff671afc834e47a533b3bed7182ece73b0`
- Block: `18695729`
- Root call type: `CALL`
- Target/tx.to: `0x03b7bb750a974e0bd34795013f66b669f4110e54`
- Attacker: `0x5a7c7eb8d13a53d42a15d2b1d1b694ccc5141ea5`

## PoC Surfaces

| Role |

_… truncated in final report; see source excerpt for full text._


## Multi-leg reconciliation

- Status: `pass`
- Basis: `incident_drain`
- Source: `economic_reproduction`
- Selected rows: 2

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| incident_drain | loss | `0x2ffa85f655752fb2acb210287c60b9ef335f5b6e` | `storage_contract` | `WBTC` | -0.22651422 | $-8767.36 |
| incident_drain | loss | `0xb983e01458529665007ff7e0cddecdb74b967eb6` | `storage_contract` | `WETH` | -38.089742649328258427 | $-79640.64 |


## Root cause analysis

- **Title**: iYFI raw-balance share price inflation let donated YFI overvalue collateral for bZx borrows
- **Severity**: `high`
- **Confidence**: `medium`
- **Violated invariant**: Unsolicited underlying-token transfers into an iToken contract must not increase collateral/share value unless matched by proportional share minting or excluded from accounted asset supply.

### Final root cause

iYFI's LoanTokenLogicStandard computes tokenPrice from _totalAssetSupply(), and _totalAssetSupply falls back to the iYFI contract's raw YFI balance plus borrows. The attacker minted a tiny iYFI position, transferred flash-borrowed YFI directly into the iYFI contract, and thereby increased the assetSupply operand used by _tokenPrice without proportional iYFI supply. The bZx borrow path then accepted 5 iYFI as collateral for WETH and WBTC borrows and later allowed the collateral to be withdrawn; the exact bZx margin/price-feed branch is source-gapped, so this is partial.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x7F3Fe9D492A9a60aEBb06d82cBa23c6F32CAd10b` | `iYFI LoanToken` | `primary vulnerable collateral/share-price contract` | `0xfb772316a54dcd439964b561fc2c173697aeeb5b` |
| `0xB983E01458529665007fF7E0CDdeCDB74B967Eb6` | `iETH LoanToken` | `WETH lending pool drained through borrow path` | `0x9e1341a201b1aecb1b0dd584989790a0232b4af5` |
| `0x2ffa85f655752fB2aCB210287c60b9ef335f5b6E` | `iWBTC LoanToken` | `WBTC lending pool drained through borrow path` | `0xfb772316a54dcd439964b561fc2c173697aeeb5b` |
| `0xD8Ee69652E4e4838f2531732a46d1f7F584F0b7f` | `bZxProtocol` | `borrow and collateral withdrawal consumer of inflated iYFI collateral value` | `0x0545c57f1862b6509e15a5b8a6f9aa713914f80a` |

### Recommended fixes

- Change LoanTokenLogicStandard so _totalAssetSupply/tokenPrice use internally accounted assets rather than raw underlying balanceOf(address(this)), or add a guard that prevents unsolicited underlying-token donations from increasing share/collateral price without proportional iToken minting.
- Add borrow-side validation that collateral valuation cannot be inflated by same-transaction underlying donations to the collateral token contract, and require price-feed/margin checks to use donation-resistant exchange rates.

### Limitations

- missing_assumption: the active bZx borrow/margin delegate implementation for borrowOrTradeFromPool is not present under source bundle, so the exact margin/health acceptance branch cannot be line-cited.
- price_feed_source_gap: price-feed calls for iYFI->WETH and iYFI->WBTC are evidence-visible, but the price-feed implementation source is not present, so the exact exchange-rate formula cannot be line-cited.
- delegate_source_gap: withdrawCollateral execution is evidence-visible, but the active delegate body for the collateral-withdrawal branch is not present under source bundle.
