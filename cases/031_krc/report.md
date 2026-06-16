# RCA Run Report — bsc 0x78f242de…848daf


## Case overview

- **Chain**: bsc (chain_id=56)
- **Tx hash**: `0x78f242dee5b8e15a43d23d76bce827f39eb3ac54b44edcd327c5d63de3848daf`
- **Block**: 49875424
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 946.42s (946423 ms)
- **Finding**: KRC transfer-to-pair branch synchronizes AMM reserves after burning from the pair but before crediting incoming KRC


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
- **Incident net loss**: $7196.85
- **PoC net reproduced**: $7146.90
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

- Transaction: `0x78f242dee5b8e15a43d23d76bce827f39eb3ac54b44edcd327c5d63de3848daf`
- Block: `49875424`
- Root call type: `CALL`
- Target/tx.to: `0xd995edcab2efe3283514ff111cedc9aaff0349c8`
- Attacker: `0x9943f26831f9b468a7fe5ac531c352baab8af655`

## Multi-leg reconciliation

- Status: `pass`
- Basis: `incident_drain`
- Source: `economic_reproduction`
- Selected rows: 2

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| incident_drain | loss | `0xdbead75d3610209a093af1d46d5296bbeffd53f5` | `storage_contract` | `KRC` | -952.786269477665760591 | N/A |
| incident_drain | loss | `0xdbead75d3610209a093af1d46d5296bbeffd53f5` | `storage_contract` | `USDT` | -7204.807872520012958697 | $-7196.85 |


## Root cause analysis

- **Title**: KRC transfer-to-pair branch synchronizes AMM reserves after burning from the pair but before crediting incoming KRC
- **Severity**: `high`
- **Confidence**: `high`
- **Violated invariant**: For transfers into an AMM pair, token logic must not debit the pair's existing balance or call pair.sync() before the incoming transfer is fully credited, because reserves must reflect final pair balances rather than a transient intermediate balance.

### Final root cause

KRC's overridden _transfer branch for recipient == swap debits the PancakePair balance itself, calls sync(), and only then credits the sender's net transfer to the pair. This violates the AMM accounting invariant that a transfer into the pair must not reduce the pair's pre-existing token balance or synchronize reserves against a transient post-burn/pre-credit balance. The attacker repeatedly transfers KRC into the pair, skims the excess created after premature sync, then swaps out USDT from the distorted Pair state.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x1814a8443f37ddd7930a9d8bc4b48353fe589b58` | `KB/KRC` | `primary vulnerable contract` | `—` |
| `0xdbead75d3610209a093af1d46d5296bbeffd53f5` | `PancakePair` | `affected liquidity pool` | `—` |

### Recommended fixes

- Remove the `super._transfer(swap, destroy, ...)` debit from the transfer-into-pair path; fees for transfers into the pair should be deducted from the sender or excluded for the pair.
- Do not call `IUniswap(swap).sync()` inside token transfer before all balance mutations for that transfer are complete.
- Add an invariant test around transfers to the LP pair: after any transfer-to-pair path, pair reserves must not be synchronized to a transient balance and `balance(pair) - reserve` must not become attacker-skimmable because of token-internal ordering.
