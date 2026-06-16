# RCA Run Report — arbitrum 0x1ce7e9a9…4c7c9b


## Case overview

- **Chain**: arbitrum (chain_id=42161)
- **Tx hash**: `0x1ce7e9a9e3b6dd3293c9067221ac3260858ce119ecb7ca860eac28b2474c7c9b`
- **Block**: 166405687
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 680.74s (680737 ms)
- **Finding**: Flash-loan premium accrual over dust aToken supply inflated collateral and enabled over-borrowing


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
- **Verdict**: unpriced — raw PoC proof passed, but USD comparison is incomplete.
- **Incident net loss**: unknown
- **PoC net reproduced**: unknown
- **USD ratio**: unknown

## Attack narrative

_No standalone `attack_flow.md` was available; this section is assembled from RCA report fields._

### RCA-derived flow

Radiant's LendingPool `flashLoan` `mode == NONE` settlement branch distributes flash-loan premium by passing current aToken `totalSupply` into `ReserveLogic.cumulateToLiquidityIndex`. The attacker used deposit/withdraw/direct-transfer sequencing around rUSDCn to make that denominator economically dust-like, causing `liquidityIndex` to jump. `AToken.balanceOf` then reported inflated collateral, so borrow validation accepted a WETH borrow that was unwrapped into ETH profit.

**Violated invariant**: Flash-loan fee accrual must not allow an attacker-compressible dust aToken supply denominator to materially reprice collateral or create unsupported borrow capacity.

| Field | Value |
|---|---|
| Entry function | attack() / selector 0x34ad3fac leading to Radiant deposit, withdraw, flashLoan, and borrow calls |
| Funding source | flash loans |
| Public entrypoint | deposit(address,uint256,address,uint16), withdraw(address,uint256,address), flashLoan(address,address[],uint256[],uint256[],address,bytes,uint16), borrow(address,uint256,uint256,uint16,address) |
| Attacker callbacks | IFlashLoanReceiver.executeOperation |
| Callback is root cause | false |

### Observed impact

| Token | Amount | Token address |
|---|---:|---|
| `ETH` | 90.053539750088189263 | `0x0000000000000000000000000000000000000000` |

### Evidence Summary

- **poc_verification** (`evidence summary`): Verified economic PoC passes with direct attacker ETH profit and no hard product static blockers.
- **balance_impact** (`evidence summary`): Evidence summary records attacker EOA native ETH gain of 90053539750088189263 wei.
- **evidence** (`evidence summary`): Evidence summary highlights Radiant deposit, flashLoan, ERC20 transfer, and withdraw steps; downstream ERC20 movement is demoted rather than selected as cause.
- **attack_path** (`evidence summary`): Verified Foundry PoC executes Radiant deposit/withdraw/flashLoan sequencing, borrow path, WETH unwrap, and direct ETH profit.
- **proxy_metadata** (`evidence summary`): RPC observations map the LendingPool proxy to implementation 0xd1b589c00c940c4c3f7b25e53c8d921c44ef9140 and show relevant implementation code existed pre/post.
- **source** (`evidence summary`): Flash-loan settlement calls `cumulateToLiquidityIndex` using current aToken `totalSupply`; later borrow execution relies on validation before transferring borrowed liquidity.
- **source** (`evidence summary`): Premium distribution formula divides premium by `totalLiquidity` and multiplies the ratio into `reserve.liquidityIndex` without an economic lower bound on the denominator.
- **source** (`evidence summary`): AToken balances and supply are reported as scaled balances multiplied by normalized income, so inflated liquidity index inflates collateral accounting.

## Multi-leg reconciliation

_No priced incident drain/loss legs were available; verified PoC attacker-gain legs are shown instead._

| Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| gain | `0x826d5f4d8084980366f975e10db6c4cf1f9dde6d` | `tx_from_eoa` | `ETH` | 90.055430124388189263 | N/A |

## Root cause analysis

- **Title**: Flash-loan premium accrual over dust aToken supply inflated collateral and enabled over-borrowing
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: Flash-loan fee accrual must not allow an attacker-compressible dust aToken supply denominator to materially reprice collateral or create unsupported borrow capacity.

### Final root cause

Radiant's LendingPool `flashLoan` `mode == NONE` settlement branch distributes flash-loan premium by passing current aToken `totalSupply` into `ReserveLogic.cumulateToLiquidityIndex`. The attacker used deposit/withdraw/direct-transfer sequencing around rUSDCn to make that denominator economically dust-like, causing `liquidityIndex` to jump. `AToken.balanceOf` then reported inflated collateral, so borrow validation accepted a WETH borrow that was unwrapped into ETH profit.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0xf4b1486dd74d07706052a33d31d7c0aafd0659e1` | `InitializableImmutableAdminUpgradeabilityProxy / LendingPool` | `primary vulnerable contract` | `0xd1b589c00c940c4c3f7b25e53c8d921c44ef9140` |
| `0x3a2d44e354f2d88ef6da7a5a4646fd70182a7f55` | `rUSDCn aToken proxy` | `collateral accounting token` | `0xc0249d743a17ed44b4f9ee611b51d26ab2e26444` |

### Recommended fixes

- Change `LendingPool.flashLoan` and `ReserveLogic.cumulateToLiquidityIndex` so flash-loan premiums are not divided across attacker-compressible current aToken supply; use robust real reserve liquidity or enforce a minimum denominator and index-growth cap before updating `liquidityIndex`.
- Add invariant tests for flash-loan premium accrual with near-zero aToken supply, direct underlying transfers, repeated deposit/withdraw cycles, and same-transaction borrow-capacity checks.
- Consider making collateral valuation ignore or dampen transient liquidity-index jumps created inside the same flash-loan/borrow transaction.

### Limitations

- `internal evidence` was not present in the public bundle, so the executable Foundry PoC and source excerpts were used for attack-flow evidence.
- RCA evidence did not contain reliable holder net victim-loss pricing; impact is established through verified direct attacker ETH profit.
