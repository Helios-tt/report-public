# RCA Run Report — ethereum 0x62734ce8…a090d6


## Case overview

- **Chain**: ethereum (chain_id=1)
- **Tx hash**: `0x62734ce80311e64630a009dd101a967ea0a9c012fabbfce8eac90f0f4ca090d6`
- **Block**: 21982111
- **Final quality**: `partial`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC, but RCA is partial.
- **Elapsed**: 595.18s (595178 ms)
- **Finding**: Settlement finalize callback can invoke an interaction-specified resolver target not bound to the checked resolver


## Reproduction quality

- **PoC status**: `verified`
- **Forge fmt**: `pass`
- **Forge build**: `pass`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`
- **RCA status**: `partial` / `partial`
- **RCA confidence**: `medium`

## Economic reproduction

- **Basis**: victim loss usd
- **Verdict**: victim_loss_exact
- **Incident net loss**: $1999747.75
- **PoC net reproduced**: $1999747.75
- **USD ratio**: 1.000x

## Attack narrative

_No standalone `attack_flow.md` was available; this section is assembled from RCA report fields._

### RCA-derived flow

Settlement.settleOrders(bytes) accepts attacker-supplied settlement data and _settleOrder only checks order.checkResolver(resolver) for the resolver parameter. In fillOrderInteraction's finalize branch, the contract decodes address(bytes20(interaction)) as a callback target and calls IResolver(target).resolveOrders(...) without source-visible enforcement that target equals the authorized resolver or is otherwise bound to it. This permits a crafted nested settlement path to reach a resolver/loss-holder callback that moves 2,000,000,000,000 raw USDC, although the exact downstream victim callback branch is source-gapped.

**Violated invariant**: A finalized settlement interaction must only call a resolver target that is authorized for the order/resolver pair and must not derive payout authority solely from attacker-supplied interaction bytes.

| Field | Value |
|---|---|
| Entry function | settleOrders(bytes) via attacker settle(bytes) selector 0xd0322fbf |
| Public entrypoint | fillOrderTo / fillOrderInteraction callback path |
| Attacker callbacks | isValidSignature(bytes32,bytes) |
| Callback is root cause | false |

### Observed impact

| Token | Amount | Token address |
|---|---:|---|
| `USDC` | 0.000015 | `0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48` |

### Evidence Summary

- **poc_verification** (`evidence summary`): Economic PoC passes build, test, execution, and economic proof gates with hard static blockers equal to zero.
- **balance_impact** (`evidence summary`): USDC deltas show 2,000,000,000,000 raw USDC loss from 0xb02f39...77b5 and positive deltas to Settlement, 0xbbb587...22c0, and attacker contract.
- **evidence** (`evidence summary`): Evidence summary identifies direct asset loss, attacker-facing settleOrders(bytes) as the main source-backed entry, and downstream ERC20 approve/transferFrom steps as non-surface movement.
- **source** (`evidence summary`): Settlement checks resolver eligibility before fillOrderTo, then finalizes by calling IResolver(target).resolveOrders using target decoded from interaction bytes without a source-visible target-to-resolver binding check.
- **source** (`evidence summary`): Order execution validates signature/amounts/predicate, performs maker transfer, calls settlement interaction, and later performs taker transfer; contract signature validation explains observed attacker isValidSignature callbacks.
- **attack_path** (`execution summary`): Execution summary shows attacker entry selector 0xd0322fbf calling Settlement.settleOrders and six ERC1271 isValidSignature callbacks from the limit-order protocol to the attacker contract.
- **negative_evidence** (`evidence summary`): Analyzer records that missing 0xb02f39...77b5 source prevents proving the exact downstream victim callback branch; final RCA is downgraded to partial.

## Multi-leg reconciliation

_Top incident drain/loss legs are shown first; gain and mechanical legs remain available in `report/run_summary.json`._

| Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| loss | `0xb02f39e382c90160eb816de5e0e428ac771d77b5` | `storage_contract` | `USDC` | -2000000 | -$1999747.75 |

## Root cause analysis

- **Title**: Settlement finalize callback can invoke an interaction-specified resolver target not bound to the checked resolver
- **Severity**: `critical`
- **Confidence**: `medium`
- **Violated invariant**: A finalized settlement interaction must only call a resolver target that is authorized for the order/resolver pair and must not derive payout authority solely from attacker-supplied interaction bytes.

### Final root cause

Settlement.settleOrders(bytes) accepts attacker-supplied settlement data and _settleOrder only checks order.checkResolver(resolver) for the resolver parameter. In fillOrderInteraction's finalize branch, the contract decodes address(bytes20(interaction)) as a callback target and calls IResolver(target).resolveOrders(...) without source-visible enforcement that target equals the authorized resolver or is otherwise bound to it. This permits a crafted nested settlement path to reach a resolver/loss-holder callback that moves 2,000,000,000,000 raw USDC, although the exact downstream victim callback branch is source-gapped.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0xa88800cd213da5ae406ce248380802bd53b47647` | `Settlement` | `primary vulnerable contract` | `—` |
| `0x1111111254eeb25477b68fb85ed929f73a960582` | `AggregationRouterV5 / OrderMixin` | `limit order execution contract used by settlement` | `—` |
| `0xb02f39e382c90160eb816de5e0e428ac771d77b5` | `unknown` | `loss holder / downstream resolver target with missing source` | `—` |

### Recommended fixes

- In Settlement.sol fillOrderInteraction, require the finalize interaction target to equal the checked resolver or an explicit resolver whitelist before calling IResolver(target).resolveOrders(...).
- Bind order suffix resolver, interaction target, and allTokensAndAmounts authorization into one invariant and reject settlement calldata where these fields disagree.
- Add regression tests for crafted nested settlement payloads where address(bytes20(interaction)) differs from suffix.resolver and ensure they revert before any token approval or transferFrom side effect.

### Limitations

- victim_callback_source_gap: no victim source was supplied for 0xb02f39e382c90160eb816de5e0e428ac771d77b5, so the exact internal resolveOrders branch that transferred the 2M raw USDC cannot be proven.
- missing_assumption: the final downstream payout/transfer authority is inferred from execution evidence/fund-flow plus Settlement and limit-order source, not from source for the loss-holder contract itself.
- attack_flow.md was referenced by evidence summary metadata but is not present/readable in internal evidence; execution summary.txt and PoC.t.sol were used instead.
