# RCA Run Report — ethereum 0xac7292e7…6f3133


## Case overview

- **Chain**: ethereum (chain_id=1)
- **Tx hash**: `0xac7292e7d0ec8ebe1c94203d190874b2aab30592327b6cc875d00f18de6f3133`
- **Block**: 14090170
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 521.71s (521713 ms)
- **Finding**: QBridgeHandler accepts native-token deposits through the ERC20 transferFrom branch without receiving value


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
- **Verdict**: usd_pricing_unavailable — historical USD pricing was unavailable.
- **Incident net loss**: unknown
- **PoC net reproduced**: unknown
- **USD ratio**: unknown

## Attack narrative

_No standalone `attack_flow.md` was available; this section is assembled from RCA report fields._

### RCA-derived flow

QBridgeHandler.deposit(bytes32,address,bytes) resolves the resource token and, in the non-burn branch, treats tokenAddress == ETH/address(0) as an ERC20 token. The branch checks only whitelist/minimum amount and then accepts SafeToken.safeTransferFrom, whose low-level call to address zero can succeed with empty return data and no token movement. The attacker supplied a whitelisted native-token resource and arbitrary amount, creating a valid-looking bridge deposit/entitlement without transferring ETH or ERC20 tokens in this transaction.

**Violated invariant**: Every accepted deposit must prove an actual asset transfer equal to the recorded amount; native-token resources must require msg.value == amount and must not pass through ERC20 transferFrom to address(0).

| Field | Value |
|---|---|
| Entry function | deposit(bytes32,address,bytes) / selector 0xb07e54bb via bridge deposit(uint8,bytes32,bytes) payload |
| Callback is root cause | false |

### Observed impact

| Token | Amount | Token address |
|---|---:|---|
| `unknown` | 0 | `unknown` |

### Evidence Summary

- **poc_verification** (`evidence summary`): PoC gate passes with economic proof and no hard static-validation blocker.
- **evidence** (`evidence summary`): Evidence summary narrows to the proxy call and implementation delegatecall for deposit(bytes32,address,bytes) on the bridge handler.
- **proxy_metadata** (`evidence summary`): RPC observations show proxy and implementation code existed pre/post and the proxy implementation remained 0x80d1486ef600cc56d4df9ed33baf53c60d5a629b.
- **source** (`evidence summary`): deposit decodes amount from calldata, checks whitelist/minAmount, and uses ERC20 safeTransferFrom for the non-burn branch, while depositETH separately requires amount == msg.value.
- **source** (`evidence summary`): safeTransferFrom uses a low-level token.call and accepts success with empty return data without checking code existence.
- **source** (`execution summary`): Observed child call is transferFrom from depositer to handler for amount 0xa4cc799563c380000 with target address zero, returning success with empty data.
- **attack_path** (`evidence summary`): PoC reproduces the bridge deposit payload and handler call used in the transaction.
- **negative_evidence** (`evidence summary`): No direct token/native balance loss is visible in this transaction, supporting loss_enabling_state_change rather than direct_asset_loss_logic.

## Multi-leg reconciliation

_No asset legs were recorded._

## Root cause analysis

- **Title**: QBridgeHandler accepts native-token deposits through the ERC20 transferFrom branch without receiving value
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: Every accepted deposit must prove an actual asset transfer equal to the recorded amount; native-token resources must require msg.value == amount and must not pass through ERC20 transferFrom to address(0).

### Final root cause

QBridgeHandler.deposit(bytes32,address,bytes) resolves the resource token and, in the non-burn branch, treats tokenAddress == ETH/address(0) as an ERC20 token. The branch checks only whitelist/minimum amount and then accepts SafeToken.safeTransferFrom, whose low-level call to address zero can succeed with empty return data and no token movement. The attacker supplied a whitelisted native-token resource and arbitrary amount, creating a valid-looking bridge deposit/entitlement without transferring ETH or ERC20 tokens in this transaction.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x17b7163cf1dbd286e262ddc68b553d899b93f526` | `TransparentUpgradeableProxy` | `proxy for primary vulnerable bridge handler` | `0x80d1486ef600cc56d4df9ed33baf53c60d5a629b` |
| `0x80d1486ef600cc56d4df9ed33baf53c60d5a629b` | `QBridgeHandler` | `primary vulnerable contract implementation` | `—` |

### Recommended fixes

- In QBridgeHandler.deposit, reject tokenAddress == ETH/address(0) from the ERC20 non-burn branch or route it to depositETH-equivalent logic requiring amount == msg.value.
- In SafeToken.safeTransferFrom, require the token address to contain contract code before making the low-level ERC20 call and accepting empty return data.
- Ensure bridge deposit records/events are emitted only after the handler proves the asset transfer or native value receipt for the exact recorded amount.

### Limitations

- tx_scope_gap: the supplied transaction contains the loss-enabling forged deposit but no later destination-chain proposal execution or realized asset drain.
- The exact historical configuration transaction that mapped the resource ID to address(0) is not part of the available evidence; this does not affect the selected in-transaction branch because source and execution evidence show the zero-address transferFrom path was exercised.
