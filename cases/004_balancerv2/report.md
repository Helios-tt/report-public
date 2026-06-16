# RCA Run Report — ethereum 0x6ed07db1…bc9742


## Case overview

- **Chain**: ethereum (chain_id=1)
- **Tx hash**: `0x6ed07db1a9fe5c0794d44cd36081d6a6df103fab868cdd75d581e3bd23bc9742`
- **Block**: 23717397
- **Final quality**: `partial`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC, but RCA is partial.
- **Elapsed**: 1000.34s (1000335 ms)
- **Finding**: ComposableStablePool BPT batch-swap accounting allows inflated settled entitlement


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
- **PoC net reproduced**: $70554791.40
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

- Transaction: `0x6ed07db1a9fe5c0794d44cd36081d6a6df103fab868cdd75d581e3bd23bc9742`
- Block: `23717397`
- Root call type: `CREATE`
- Target/tx.to: `unknown`
- Attacker: `0x506d1f9efe24f0d47853adca907eb8d89ae03207`

## PoC Surfaces

| Role | Surface | Selector | Address | Steps |
|---|---|---|---|---|
| attacker_entry | unknown | `entry` | `0x54b53503c0e2173df29f8da735fbd45ee8aba30d` | `1` |
| dynamic_inst

_… truncated in final report; see source excerpt for full text._


## Multi-leg reconciliation

- Status: `pass`
- Basis: `poc_selected_direct_attacker_gain`
- Source: `economic_reproduction`
- Selected rows: 5
- Note: Verified selected gain-family rows are primary for this economic proof; incident drain/loss legs remain available in the incident context.

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| poc_selected_direct_attacker_gain | gain | `0x54b53503c0e2173df29f8da735fbd45ee8aba30d` | `attacker_entry` | `wstETH` | 4259.843451780587743322 | $19253598.07 |
| poc_selected_direct_attacker_gain | gain | `0x54b53503c0e2173df29f8da735fbd45ee8aba30d` | `attacker_entry` | `wstETH-WETH-BPT` | 20.413668455251157822 | N/A |
| poc_selected_direct_attacker_gain | gain | `0x54b53503c0e2173df29f8da735fbd45ee8aba30d` | `attacker_entry` | `WETH` | 6587.440315017497938362 | $24440902.53 |
| poc_selected_direct_attacker_gain | gain | `0x54b53503c0e2173df29f8da735fbd45ee8aba30d` | `attacker_entry` | `osETH/wETH-BPT` | 44.154666355785411629 | N/A |
| poc_selected_direct_attacker_gain | gain | `0x54b53503c0e2173df29f8da735fbd45ee8aba30d` | `attacker_entry` | `osETH` | 6851.122954235076557965 | $26860290.80 |


## Root cause analysis

- **Title**: ComposableStablePool BPT batch-swap accounting allows inflated settled entitlement
- **Severity**: `critical`
- **Confidence**: `medium`
- **Violated invariant**: A pool's own BPT supply and withdrawal entitlement must not increase from unsettled intra-batch BPT deltas; exact BPT out must be bounded by settled token payment and current-balance invariant checks.

### Final root cause

Balancer V2 ComposableStablePool treats the pool's own BPT as a swap asset inside Vault batchSwap and routes exact-out BPT swaps through join/exit accounting while the Vault settles only net deltas after the full batch. The exact-BPT-out branch accepts caller-specified BPT output, computes token input through StableMath, and updates virtual supply before proving that BPT entitlement was backed by settled, bounded token payment. This allowed long GIVEN_OUT batch sequences to create profitable Balancer internal-balance entitlement in WETH, osETH, wstETH, and pool BPT.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0xdacf5fa19b1f720111609043ac67a9818262850c` | `ComposableStablePool` | `primary vulnerable contract for osETH/wETH-BPT pool` | `—` |
| `0x93d199263632a4ef4bb438f1feb99e57b4b5f0bd` | `ComposableStablePool` | `primary vulnerable contract for wstETH/WETH-BPT pool` | `—` |
| `0xba12222222228d8ba445958a75a0704d566bf2c8` | `Vault` | `batchSwap execution and deferred net-settlement surface` | `—` |

### Recommended fixes

- Disable or tightly limit ComposableStablePool swaps where the pool's own BPT appears as a Vault batchSwap asset.
- Before ComposableStablePool._joinSwapExactBptOutForTokenIn updates postJoinExitSupply, require settled token payment and enforce a maximum BPT-out/supply-growth bound under current balances and cached rates.
- Treat rate-cache-dependent joins/exits as invalid when pool/Vault BPT balances are in an unsettled batch context.

### Limitations

- missing_assumption: the available evidence do not include exact numeric per-swap operands proving the full rounding or arithmetic accumulation across all repeated GIVEN_OUT steps.
- No source-visible single unchecked underflow, overflow, or unsafe arithmetic operation was proven as the sole arithmetic fault for the giant supply/accounting expansion shape.
- Attacker gains are represented as Balancer internal-balance protocol event deltas; direct ERC20 wallet balanceOf observations for the attacker are zero in rpc_observations.
