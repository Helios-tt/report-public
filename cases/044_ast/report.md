# RCA Run Report — bsc 0x80dd9362…793927


## Case overview

- **Chain**: bsc (chain_id=56)
- **Tx hash**: `0x80dd9362d211722b578af72d551f0a68e0dc1b1e077805353970b2f65e793927`
- **Block**: 45964640
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 637.78s (637778 ms)
- **Finding**: AST transfer liquidity-removal heuristic lets attackers burn pair inventory and poison AMM reserves


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
- **Incident net loss**: $80031.15
- **PoC net reproduced**: $64670.06
- **USD ratio**: 0.808x

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

- Transaction: `0x80dd9362d211722b578af72d551f0a68e0dc1b1e077805353970b2f65e793927`
- Block: `45964640`
- Root call type: `CALL`
- Target/tx.to: `0xaa0cee271f7c1a14cd0777283cb5741e46a2c732`
- Attacker: `0x56f77adc522bffebb3af0669564122933ab5ea4f`

## Multi-leg reconciliation

- Status: `pass`
- Basis: `incident_drain`
- Source: `economic_reproduction`
- Selected rows: 2

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| incident_drain | loss | `0x5ffec8523a42be78b1ad1244fa526f14b64ba47a` | `storage_contract` | `USDT` | -80145.197852789656133646 | $-80031.15 |
| incident_drain | loss | `0x5ffec8523a42be78b1ad1244fa526f14b64ba47a` | `storage_contract` | `AST` | -2503.767497907673292251 | N/A |


## Root cause analysis

- **Title**: AST transfer liquidity-removal heuristic lets attackers burn pair inventory and poison AMM reserves
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: A token transfer from an AMM pair must not burn pair inventory or classify liquidity removal unless an actual LP burn/removal operation by that recipient is occurring.

### Final root cause

ASTToken._transfer() classifies pair-originated transfers as liquidity removal using checkLiquidityRm(to), which only compares the recipient's current LP balance with lastBalance[to]. The attacker can first spoof lastBalance[attacker] through checkLiquidityAdd() by directly increasing the pair's USDT balance and transferring AST to the pair, without a real LP mint. A subsequent pair.skim(attacker) burns AST from the pair and delivers zero, then pair.sync() records the manipulated low AST balance as reserves, enabling a small AST input to drain USDT through the router.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0xc10e0319337c7f83342424df72e73a70a29579b2` | `AST` | `primary vulnerable contract` | `—` |
| `0x5ffec8523a42be78b1ad1244fa526f14b64ba47a` | `PancakePair` | `downstream drained AMM pair` | `—` |

### Recommended fixes

- Remove or redesign ASTToken's transfer-time liquidity add/remove inference so only authenticated pair mint/burn/remove-liquidity flows can update lastBalance and trigger pair-token burns.
- At minimum, prevent _transfer from burning tokens held by uniswapV2Pair based solely on checkLiquidityRm(to), and do not update lastBalance[from] from raw USDT balance increases without verifying an LP mint.
