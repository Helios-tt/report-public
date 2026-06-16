# RCA Run Report — bsc 0xed6fd61c…5c18db


## Case overview

- **Chain**: bsc (chain_id=56)
- **Tx hash**: `0xed6fd61c1eb2858a1594616ddebaa414ad3b732dcdb26ac7833b46803c5c18db`
- **Block**: 58269339
- **Final quality**: `partial`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC, but RCA is partial.
- **Elapsed**: 638.68s (638685 ms)
- **Finding**: Prior XERA allowance to public Multicall3 was consumed to move holder tokens into an AMM swap


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
- **PoC net reproduced**: $16910.41
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

- Transaction: `0xed6fd61c1eb2858a1594616ddebaa414ad3b732dcdb26ac7833b46803c5c18db`
- Block: `58269339`
- Root call type: `CALL`
- Target/tx.to: `0x90be00229fe8000000009e007743a485d400c3b7`
- Attacker: `0x00b700b9da0053009cb84400ed1e8fe251002af3`

## PoC Surfaces

| Role | Surface | Selector | Address | Steps |
|---|---|---|---|---|
| attacker_entry | unknown | `0x00dd0000` | `0x90be00229fe8000000009e007743a485d400c3b7` | `1` |
| attacker_callback | unknown | `entry` | `0x90be00229fe8000000009e007743a485d400c3b7` | `16` |

## Economic Effect

- Reconciliation basis: `poc_selected_direct_attacker_gain`
- Verdict: `exact`
- Comparison basis: `incident_profit_oracle_usd`

| Source | Direction | Holder | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| poc_selected_direct_attacker_gain | gain | `0x90be00229fe8000000009e007743a485d400c3b7` | `BNB` | 20.51744548925453784 | $16910.41 |


## Multi-leg reconciliation

- Status: `pass`
- Basis: `poc_selected_direct_attacker_gain`
- Source: `economic_reproduction`
- Selected rows: 1
- Note: Verified selected gain-family rows are primary for this economic proof; incident drain/loss legs remain available in the incident context.

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| poc_selected_direct_attacker_gain | gain | `0x90be00229fe8000000009e007743a485d400c3b7` | `attacker_callback` | `BNB` | 20.51744548925453784 | $16910.41 |


## Root cause analysis

- **Title**: Prior XERA allowance to public Multicall3 was consumed to move holder tokens into an AMM swap
- **Severity**: `high`
- **Confidence**: `medium`
- **Violated invariant**: An allowance to a public arbitrary-call executor must not confer transferable token-moving authority to unrelated third-party callers.

### Final root cause

Multicall3.aggregate3 publicly forwarded attacker-supplied calldata into XERA.transferFrom. XERA.transferFrom treated Multicall3 as the spender, so a prior allowance from 0x9a619a...c542 to the public executor let an unrelated caller move 27,900,000 XERA into the Pancake pair. The pair then treated that balance increase as valid swap input and released 41.034748173552867045 WBNB. The prior allowance writer/value is not present in the available evidence, so this is partial rather than complete.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0xca11bde05977b3631167028862be2a173976ca11` | `Multicall3` | `public arbitrary call executor used as XERA allowance spender` | `—` |
| `0x93e99ae6692b07a36e7693f4ae684c266633b67d` | `LUXERA / XERA` | `asset contract whose transferFrom consumed prior allowance` | `—` |
| `0x231075e4aa60d28681a2d6d4989f8f739bac15a0` | `PancakePair` | `downstream AMM that accepted transferred XERA as swap input` | `—` |

### Recommended fixes

- Revoke or avoid XERA allowances from holder addresses to Multicall3 or any public arbitrary-call forwarder.
- At integration or approval-policy boundaries, block approvals to public executor contracts or require owner-signed/caller-bound execution for forwarded transferFrom calldata.
- Do not patch PancakePair.swap or WBNB.withdraw for this incident unless additional evidence shows their own invariants were broken.

### Limitations

- prior_state_provenance_gap: the available evidence do not include the prior approval transaction, writer, or direct allowance value for 0x9a619ae8995a220e8f3a1df7478a5c8d2affc542 -> 0xca11bde05977b3631167028862be2a173976ca11.
- invalid_precondition: sufficient allowance is inferred from successful transferFrom plus XERA source semantics, not directly proven by an allowance RPC observation in the supplied files.
- The exact actor or transaction that created the allowance is outside the supplied current-transaction evidence scope.
