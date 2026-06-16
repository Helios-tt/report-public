# RCA Run Report — ethereum 0xe50ed602…6227f7


## Case overview

- **Chain**: ethereum (chain_id=1)
- **Tx hash**: `0xe50ed602bd916fc304d53c4fed236698b71691a95774ff0aeeb74b699c6227f7`
- **Block**: 14037237
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 456.27s (456267 ms)
- **Finding**: Anyswap router trusts attacker-supplied token metadata and pulls third-party WETH after a non-verifying permit call


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
- **Incident net loss**: $962249.82
- **PoC net reproduced**: $856402.34
- **USD ratio**: 0.890x

## Attack narrative

_No standalone `attack_flow.md` was available; this section is assembled from RCA report fields._

### RCA-derived flow

AnyswapV4Router.anySwapOutUnderlyingWithPermit accepts an untrusted token address, calls token.underlying(), and uses the returned address as the asset to permit and transfer from an arbitrary from address. When token is an attacker contract returning WETH, WETH's missing permit implementation falls through to deposit() and succeeds with zero value, so the router proceeds to transferFrom the victim's existing WETH allowance into the attacker-controlled token. The attacker then withdraws that WETH to ETH.

**Violated invariant**: The router must only pull a user's underlying asset into a verified canonical anyToken/vault after proving fresh valid authorization for that exact underlying asset and spender.

| Field | Value |
|---|---|
| Entry function | anySwapOutUnderlyingWithPermit(address,address,address,uint256,uint256,uint8,bytes32,bytes32,uint256) |
| Callback is root cause | false |

### Observed impact

| Token | Amount | Token address |
|---|---:|---|
| `ETH` | 274.673279555369329864 | `0x0000000000000000000000000000000000000000` |

### Evidence Summary

- **poc_verification** (`evidence summary`): Verified economic PoC passed with forge build/test and no hard static validation blocker.
- **balance_impact** (`evidence summary`): Victim holder 0x3ee505... lost 308636644758370382903 WETH while attacker-controlled holders gained ETH.
- **evidence** (`evidence summary`): execution steps is router anySwapOutUnderlyingWithPermit, with WETH permit/fallback and transferFrom child steps and later WETH withdraw/profit routing.
- **source** (`evidence summary`): The router trusts caller-supplied token.underlying(), calls permit on the returned underlying, then safeTransferFroms underlying from arbitrary from to token before depositVault/burn.
- **source** (`evidence summary`): WETH fallback deposits on unknown calldata, withdraw only converts caller-held WETH to ETH, and transferFrom enforces balance/allowance then moves balances normally.
- **source** (`evidence summary`): The PoC passes the attacker contract as token, drains the victim holder's WETH balance through the router call, then withdraws the WETH; attacker token stubs return WETH from underlying and benign values from depositVault/burn.
- **negative_evidence** (`evidence summary`): WETH totalSupply decreased and the victim holder balance fell to zero, ruling out a giant mint/supply-expansion root cause.
- **evidence** (`evidence summary`): Analyzer narrowed from transfer/withdraw effects to the router authorization/token-validation branch and completed a faithfulness audit.

## Multi-leg reconciliation

_Top incident drain/loss legs are shown first; gain and mechanical legs remain available in `report/run_summary.json`._

| Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| loss | `0x3ee505ba316879d246a8fd2b3d7ee63b51b44fab` | `transfer_counterparty` | `WETH` | -308.636644758370382903 | -$962249.82 |

## Root cause analysis

- **Title**: Anyswap router trusts attacker-supplied token metadata and pulls third-party WETH after a non-verifying permit call
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: The router must only pull a user's underlying asset into a verified canonical anyToken/vault after proving fresh valid authorization for that exact underlying asset and spender.

### Final root cause

AnyswapV4Router.anySwapOutUnderlyingWithPermit accepts an untrusted token address, calls token.underlying(), and uses the returned address as the asset to permit and transfer from an arbitrary from address. When token is an attacker contract returning WETH, WETH's missing permit implementation falls through to deposit() and succeeds with zero value, so the router proceeds to transferFrom the victim's existing WETH allowance into the attacker-controlled token. The attacker then withdraws that WETH to ETH.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x6b7a87899490ece95443e979ca9485cbe7e71522` | `AnyswapV4Router` | `primary vulnerable contract` | `—` |
| `0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2` | `WETH9` | `underlying asset contract used in exploit path` | `—` |

### Recommended fixes

- Require token to be a verified canonical Anyswap token/vault before trusting token.underlying() or calling depositVault/burn.
- Reject permit-based flows for underlyings that do not implement a verified permit interface, or require nonce/allowance changes attributable to the permit before transferFrom.
- Bind from, token, underlying, spender, and amount in an explicit authorization invariant before moving underlying assets.
