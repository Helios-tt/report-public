# RCA Run Report — bsc 0x2d9c1a00…8e5a99


## Case overview

- **Chain**: bsc (chain_id=56)
- **Tx hash**: `0x2d9c1a00cf3d2fda268d0d11794ad2956774b156355e16441d6edb9a448e5a99`
- **Block**: 52974382
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 868.92s (868925 ms)
- **Finding**: RANT transfer-to-token hook lets ordinary holders burn LP-held RANT and sync corrupted pair reserves


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
- **Verdict**: exact — PoC reproduces 99–101% of incident net loss.
- **Incident net loss**: $204293.45
- **PoC net reproduced**: $204043.51
- **USD ratio**: 0.999x

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

- Transaction: `0x2d9c1a00cf3d2fda268d0d11794ad2956774b156355e16441d6edb9a448e5a99`
- Block: `52974382`
- Root call type: `CREATE`
- Target/tx.to: `unknown`
- Attacker: `0xad2cb8f48e74065a0b884af9c5a4ecbba101be23`

## Multi-leg reconciliation

- Status: `pass`
- Basis: `incident_drain`
- Source: `economic_reproduction`
- Selected rows: 2

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| incident_drain | loss | `0x42a93c3af7cb1bbc757dd2ec4977fd6d7916ba1d` | `storage_contract` | `WBNB` | -311.85880447462436384 | $-204293.45 |
| incident_drain | loss | `0x42a93c3af7cb1bbc757dd2ec4977fd6d7916ba1d` | `storage_contract` | `RANT` | -102509423.181903444010952438 | N/A |


## Root cause analysis

- **Title**: RANT transfer-to-token hook lets ordinary holders burn LP-held RANT and sync corrupted pair reserves
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: A user token transfer must not mutate an AMM pair's token balance/reserves unless the caller is explicitly authorized for LP reserve management or the pair itself is executing a valid liquidity operation.

### Final root cause

RANTToken._transfer treats an ordinary non-pair transfer to the token contract as authority to call _sellBurnLiquidityPairTokens(amount). That helper removes 90%/10% of the user-supplied amount from the AMM pair to 0xdead/rant_node and immediately calls pair.sync(), without checking that the sender is authorized to manage LP reserves or owns the LP balance being changed. The attacker triggers this after obtaining RANT via a pair swap, corrupting the RANT/WBNB pair reserves used by Pancake swap pricing and draining WBNB into BNB profit.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0xc321ac21a07b3d593b269acdace69c3762ca2dd0` | `RANTToken` | `primary vulnerable contract` | `—` |
| `0x42a93c3af7cb1bbc757dd2ec4977fd6d7916ba1d` | `PancakePair` | `RANT/WBNB AMM pair whose reserves were mutated and drained` | `—` |

### Recommended fixes

- Remove the _sellBurnLiquidityPairTokens side effect from ordinary RANT transfers to address(this), or gate it with an explicit authorized LP-management role and ensure it cannot spend uniswapPair balances based only on a user's transfer amount.
- Do not call pair.sync() from user transfer flow after moving tokens out of the pair; reserve synchronization should follow valid pair liquidity operations only.
- If sell-burn behavior is required, burn only the sender's transferred tokens or separately owned protocol inventory, never tokens held by the AMM pair.

### Limitations

- The rant_center implementation source is not present under source bundle; its downstream sell_rant internals are not used as the selected root cause because the patchable LP reserve mutation is source-visible in RANTToken.
