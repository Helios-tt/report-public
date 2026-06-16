# RCA Run Report — bsc 0x93ae5f0a…de1081


## Case overview

- **Chain**: bsc (chain_id=56)
- **Tx hash**: `0x93ae5f0a121d5e1aadae052c36bc5ecf2d406d35222f4c6a5d63fef1d6de1081`
- **Block**: 34506417
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 480.52s (480522 ms)
- **Finding**: TransitSwapRouterV5 trusted an attacker-supplied V3 pool as an intermediate hop and used its forged output to fund a real pool swap from router balances


## Reproduction quality

- **PoC status**: `verified`
- **Forge fmt**: `pass`
- **Forge build**: `pass`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`
- **RCA status**: `complete` / `complete`
- **RCA confidence**: `high`

## Economic reproduction

- **Basis**: holder net position delta usd
- **Verdict**: position_delta_close
- **Incident net loss**: $36122.68
- **PoC net reproduced**: $43903.32
- **USD ratio**: 1.215x

## Attack narrative

_No standalone `attack_flow.md` was available; this section is assembled from RCA report fields._

### RCA-derived flow

TransitSwapRouterV5/UniswapV3Router._executeV3Swap accepts user-supplied pool identifiers in the multi-hop path and calls _verifyPool/_swap on address(uint160(pool)) before proving that address is a canonical pool from an allowlisted factory. _verifyPool trusts token0/token1/fee responses from the supplied address, and _executeV3Swap then uses the returned amountOut as the next hop actualAmountIn. The attacker supplied its own contract as the first pool, forged an intermediate output, and caused the second real PancakeV3Pool callback to pull USDT from the router while output WBNB was sent onward.

**Violated invariant**: Every V3 pool in a routed swap must be authenticated as a canonical allowlisted-factory pool before its metadata or swap return can determine the next hop amount.

| Field | Value |
|---|---|
| Entry function | exactInputV3Swap((address,address,address,address,uint256,uint256,uint256,uint256,uint256[],bytes,string)) / selector 0xb9b5149b |
| Funding source | attacker EOA supplied 0.01 BNB msg.value |
| Attacker callbacks | attacker contract implemented token0(), token1(), fee(), and swap(address,bool,int256,uint160,bytes) as spoofed V3 pool surfaces |
| Callback is root cause | false |

### Observed impact

| Token | Amount | Token address |
|---|---:|---|
| `unknown` | 0 | `unknown` |

### Evidence Summary

- **poc_verification** (`evidence summary`): Economic PoC gate passes with forge build/test and zero hard product static validation blockers.
- **evidence** (`evidence summary`): The transaction has direct asset loss and accounting anomaly; the router entry step precedes real pool swap/callback and transfer effects.
- **attack_path** (`evidence summary`): PoC sends exactInputV3Swap calldata with attacker-controlled and real pool hops, and implements spoofed V3 pool callback surfaces.
- **attack_path** (`execution summary`): Closed-world execution summary confirms router queries attacker token0/token1/fee and calls attacker swap before the downstream pool activity.
- **source** (`evidence summary`): The multi-hop branch trusts pool metadata and swap return before authenticating pool provenance; callback verification happens only when a pool calls back.
- **source** (`evidence summary`): The real pool enforces callback payment, making it a downstream consumer; the vulnerable router satisfied the payment with its USDT balance.
- **balance_impact** (`evidence summary`): TransitSwapRouterV5 lost all observed USDT, PancakeV3Pool gained USDT and lost WBNB, and PancakePair received WBNB.
- **negative_evidence** (`evidence summary`): ERC20/WBNB transfer steps and PancakePair sync are downstream effects; PancakeV3Pool payment gate was inspected and is not the primary defect.

## Multi-leg reconciliation

_Top incident drain/loss legs are shown first; gain and mechanical legs remain available in `report/run_summary.json`._

| Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| loss | `0x36696169c63e42cd08ce11f5deebbcebae652050` | `storage_contract` | `WBNB` | -143.095188438054991319 | -$36122.68 |
| loss | `0x00000047bb99ea4d791bb749d970de71ee0b1a34` | `storage_contract` | `USDT` | -43841.867959016089190183 | N/A |

## Root cause analysis

- **Title**: TransitSwapRouterV5 trusted an attacker-supplied V3 pool as an intermediate hop and used its forged output to fund a real pool swap from router balances
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: Every V3 pool in a routed swap must be authenticated as a canonical allowlisted-factory pool before its metadata or swap return can determine the next hop amount.

### Final root cause

TransitSwapRouterV5/UniswapV3Router._executeV3Swap accepts user-supplied pool identifiers in the multi-hop path and calls _verifyPool/_swap on address(uint160(pool)) before proving that address is a canonical pool from an allowlisted factory. _verifyPool trusts token0/token1/fee responses from the supplied address, and _executeV3Swap then uses the returned amountOut as the next hop actualAmountIn. The attacker supplied its own contract as the first pool, forged an intermediate output, and caused the second real PancakeV3Pool callback to pull USDT from the router while output WBNB was sent onward.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x00000047bb99ea4d791bb749d970de71ee0b1a34` | `TransitSwapRouterV5 / UniswapV3Router` | `primary vulnerable contract` | `—` |
| `0x36696169c63e42cd08ce11f5deebbcebae652050` | `PancakeV3Pool` | `downstream real pool enforcing callback payment` | `—` |

### Recommended fixes

- Authenticate every address(uint160(pool)) in UniswapV3Router._verifyPool against the configured factory/initCodeHash before reading token0/token1/fee or calling swap.
- Reject multi-hop routes containing non-canonical pools and never use an unauthenticated pool's swap return as the next hop actualAmountIn.
- Consider deriving pool addresses from token pair, fee, and allowlisted factory instead of accepting raw user-supplied pool addresses.

### Limitations

- internal evidence was absent from the manifest, so PoC flow citations use PoC.t.sol and execution summary.txt instead.
- The exact source line numbers are not embedded in report.json because source excerpts were read as bounded files/snippets; function-level source evidence is present and patchable.
