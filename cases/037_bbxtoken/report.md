# RCA Run Report — bsc 0x0dd48636…5ac581


## Case overview

- **Chain**: bsc (chain_id=56)
- **Tx hash**: `0x0dd486368444598610239b934dd9e8c6474a06d11380d1cfec4d91568b5ac581`
- **Block**: 47626727
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 853.24s (853243 ms)
- **Finding**: Repeatable BBX transfer-hook LP burn lets zero-value transfers collapse AMM reserves before swapping out USDT


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
- **Incident net loss**: $11896.56
- **PoC net reproduced**: $11896.56
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

- Transaction: `0x0dd486368444598610239b934dd9e8c6474a06d11380d1cfec4d91568b5ac581`
- Block: `47626727`
- Root call type: `CALL`
- Target/tx.to: `0x0489e8433e4e74fb1ba938df712c954ddea93898`
- Attacker: `0x8aea7516b3b6aabf474f8872c5e71c1a7907e69e`

## PoC Surfaces

| Role | Surface | Selector | Address | Steps |
|---|---|---|---|---|
| attacker_entry | unknown | `0x5f83db9b` | `0x0489e8433e4e74fb1ba938df712c954ddea93898` | `1` |

## Econ

_… truncated in final report; see source excerpt for full text._


## Multi-leg reconciliation

- Status: `pass`
- Basis: `incident_drain`
- Source: `economic_reproduction`
- Selected rows: 2

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| incident_drain | loss | `0x6051428b580f561b627247119eed4d0483b8d28e` | `storage_contract` | `USDT` | -11905.927933743202788913 | $-11896.56 |
| incident_drain | loss | `0x6051428b580f561b627247119eed4d0483b8d28e` | `storage_contract` | `BBX` | -9898.637004253056843826 | N/A |


## Root cause analysis

- **Title**: Repeatable BBX transfer-hook LP burn lets zero-value transfers collapse AMM reserves before swapping out USDT
- **Severity**: `high`
- **Confidence**: `high`
- **Violated invariant**: A timed LP-burn and reserve-sync side effect must execute at most once per configured interval and must not be repeatable through arbitrary zero-value ERC20 transfers.

### Final root cause

BBXToken._transfer executes a timed LP-burn branch before transfer amount handling: when block.timestamp is past lastBurnTime + lastBurnGapTime, it burns balanceOf(liquidityPool) * burnRate / 10000 from the Pancake pair and immediately calls sync(). The branch never updates lastBurnTime and does not require a nonzero/value-bearing transfer, so the attacker can repeat zero-value self-transfers to burn and sync the pair's BBX reserve down. The final Pancake supporting-fee swap then uses the distorted reserve in getAmountOut and drains USDT from the pair.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x67ca347e7b9387af4e81c36cca4eaf080dcb33e9` | `BBXToken` | `primary vulnerable contract` | `—` |
| `0x6051428b580f561b627247119eed4d0483b8d28e` | `PancakePair` | `victim liquidity pair whose reserves were manipulated` | `—` |

### Recommended fixes

- In BBXToken._transfer, update lastBurnTime immediately when the burn executes and prevent arbitrary zero-value transfers from triggering LP burn/sync.
- Move LP burn/sync out of public ERC20 transfer flow or restrict it to a bounded authorized maintenance function with one execution per interval.
- Add tests that repeated zero-value transfers after lastBurnGapTime cannot change liquidityPool balance or PancakePair reserves more than once.
