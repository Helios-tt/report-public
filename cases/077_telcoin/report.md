# RCA Run Report — polygon 0x35f50851…1d902d


## Case overview

- **Chain**: polygon (chain_id=137)
- **Tx hash**: `0x35f50851c3b754b4565dc3e69af8f9bdb6555edecc84cf0badf8c1e8141d902d`
- **Block**: 51546496
- **Final quality**: `partial`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC, but RCA is partial.
- **Elapsed**: 490.07s (490069 ms)
- **Finding**: Unprotected delegate-storage proxy initialization allowed attacker-controlled callback execution and TEL drainage


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
- **PoC net reproduced**: $338288.86
- **USD ratio**: 1.000x

## Attack narrative

_No standalone `attack_flow.md` was available; this section is assembled from RCA report fields._

### RCA-derived flow

The supported root cause is an uninitialized proxy/delegate-storage initialization path at code address 0x10d0e9755c67ab37089acb4f51e8b4ee407fe853. The attacker called initialize(address,bytes) with attacker-controlled parameters, including 0x10e5c8d3537856f141272e1c39befdab4dd8bde0 and callback selector bytes a8b89898, across token-holding delegate-storage contexts. execution steps proves one such initialize call mutated slot 0 from zero to a large nonzero value on 0x191c6ca4429860c9d029230c4d7538cd7d643734; repeated callbacks then transferred TEL balances to the attacker. Exact source branch and storage layout for initialize are absent, so this is partial rather than a line-level complete RCA.

**Violated invariant**: A token-holding proxy/delegate-storage context must not accept public initialization to attacker-controlled implementation/callback authority after deployment or without trusted authorization.

| Field | Value |
|---|---|
| Entry function | 0x3bb145b1 on 0x10e5c8d3537856f141272e1c39befdab4dd8bde0 |
| Public entrypoint | initialize(address,bytes) |
| Attacker callbacks | 0xa8b89898 |
| Callback is root cause | false |

### Observed impact

| Token | Amount | Token address |
|---|---:|---|
| `TEL` | 141755751.88 | `0xdf7837de1f2fa4631d716cf2502f8b230f1dcc32` |

### Evidence Summary

- **poc_verification** (`evidence summary`): Verified economic PoC gate passed and reproduced attacker profit.
- **balance_impact** (`evidence summary`): Attacker EOA gained native MATIC and TEL in the incident transaction.
- **evidence** (`evidence summary`): execution steps executes initialize(address,bytes) through DELEGATECALL and writes slot 0 of 0x191c6c... from zero to nonzero.
- **evidence** (`evidence summary`): TEL transfer steps are repeated ERC20 transfer/settlement steps and are demoted to downstream effect rather than root cause.
- **proxy_metadata** (`evidence summary`): Initialize logic and step-591 proxy/context code existed pre/post; EIP-1967 slots were zero, leaving storage semantics unresolved.
- **source** (`execution summary`): Attacker entry repeatedly calls delegate_storage_context.initialize(0x10e5..., hex a8b89898).
- **attack_path** (`evidence summary`): PoC implements repeated initialization/callback flow and callback-based TEL transfers to the attacker EOA.
- **source** (`evidence summary`): TEL transfer path is ordinary ERC20 SafeMath balance movement, supporting classification as downstream asset movement.

## Multi-leg reconciliation

_No priced incident drain/loss legs were available; verified PoC attacker-gain legs are shown instead._

| Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| gain | `0xdb4b84f0e601e40a02b54497f26e03ef33f3a5b7` | `tx_from_eoa` | `TEL` | 141755751.88 | $334501.32 |
| gain | `0xdb4b84f0e601e40a02b54497f26e03ef33f3a5b7` | `tx_from_eoa` | `MATIC` | 4249.98000076 | $3787.54 |

## Root cause analysis

- **Title**: Unprotected delegate-storage proxy initialization allowed attacker-controlled callback execution and TEL drainage
- **Severity**: `critical`
- **Confidence**: `medium`
- **Violated invariant**: A token-holding proxy/delegate-storage context must not accept public initialization to attacker-controlled implementation/callback authority after deployment or without trusted authorization.

### Final root cause

The supported root cause is an uninitialized proxy/delegate-storage initialization path at code address 0x10d0e9755c67ab37089acb4f51e8b4ee407fe853. The attacker called initialize(address,bytes) with attacker-controlled parameters, including 0x10e5c8d3537856f141272e1c39befdab4dd8bde0 and callback selector bytes a8b89898, across token-holding delegate-storage contexts. execution steps proves one such initialize call mutated slot 0 from zero to a large nonzero value on 0x191c6ca4429860c9d029230c4d7538cd7d643734; repeated callbacks then transferred TEL balances to the attacker. Exact source branch and storage layout for initialize are absent, so this is partial rather than a line-level complete RCA.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x191c6ca4429860c9d029230c4d7538cd7d643734` | `delegate_storage_context_or_minimal_proxy` | `primary vulnerable proxy/context instance evidenced by execution steps` | `0x10d0e9755c67ab37089acb4f51e8b4ee407fe853` |
| `0x10d0e9755c67ab37089acb4f51e8b4ee407fe853` | `unknown_initialize_logic` | `shared initialize/delegatecall logic used by proxy contexts` | `—` |
| `0xdf7837de1f2fa4631d716cf2502f8b230f1dcc32` | `UChildERC20Proxy / TEL` | `drained token; transfer path is downstream effect` | `0x805b70339183f9a98cc7fcb35fcbeb5ac10713ea` |

### Recommended fixes

- Add an initializer guard to the initialize(address,bytes) implementation at code address 0x10d0e9755c67ab37089acb4f51e8b4ee407fe853 so each proxy/context can be initialized only once.
- Restrict initialize(address,bytes) caller and implementation/callback parameters to trusted governance or factory-controlled values.
- Reject arbitrary callback payload bytes such as attacker-supplied selector 0xa8b89898 for token-holding contexts.
- Review all minimal-proxy/delegate-storage contexts listed in the transaction input for prior unauthorized initialization and migrate or revoke token balances where possible.

### Limitations

- source_branch_gap: source for code address 0x10d0e9755c67ab37089acb4f51e8b4ee407fe853 is not present under internal evidence, so the exact vulnerable source line and branch cannot be cited
- storage_layout_gap: execution steps slot 0 is treated only as a zero-to-nonzero state mutation; its exact semantic field is not decoded without source/layout evidence
- attack_flow_md_absent: internal evidence was not present in the evidence manifest; PoC.t.sol and execution summary were used instead
- missing_assumption: completion would require source-backed initialize branch/access-control evidence for 0x10d0...
