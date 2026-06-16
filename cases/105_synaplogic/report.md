# RCA Run Report — base 0xc54c0004…76c4b1


## Case overview

- **Chain**: base (chain_id=8453)
- **Tx hash**: `0xc54c00046364b6e889db18c73beee9b81df6b5ca822b6d262b3d30cdf376c4b1`
- **Block**: 41038634
- **Final quality**: `partial`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC, but RCA is partial.
- **Elapsed**: 841.00s (840995 ms)
- **Finding**: Unbacked SYP balance credits through relayer-controlled mint accounting branch


## Reproduction quality

- **PoC status**: `verified`
- **Forge fmt**: `pass`
- **Forge build**: `pass`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`
- **RCA status**: `partial` / `partial`
- **RCA confidence**: `medium`

## Economic reproduction

- **Basis**: holder-net USD loss
- **Verdict**: exact — PoC reproduces 99–101% of incident net loss.
- **Incident net loss**: $88150.93
- **PoC net reproduced**: $88128.88
- **USD ratio**: 1.000x

## Attack narrative

_No standalone `attack_flow.md` was available; this section is assembled from RCA report fields._

### RCA-derived flow

SynapLogicErc20 selector 0x1402dcf2, decoded from source as mint(uint256,address,uint256,uint256,bool), has an _ac == 3 and _set_mode == 2 branch that credits _exchange[_u] by caller-provided _am after only checking relayer111O[msg.sender]. The credited amount is included in balanceOf(_u), but the branch does not increase _totalSupply, debit a backing reserve, or bind _am to a legitimate entitlement calculation. In this transaction, caller 0x39f36e2e58f36f7e5c17784847fd07da1fee1a32 repeatedly credited attacker helper 0x3821f686384c231e2f71ea093fb6189de803f482 with 442345096000000000000000 SYP, which was then routed through downstream swap/WETH/ETH steps. The analysis is partial because the available evidence do not prove why the caller held or exposed the required relayer authority.

**Violated invariant**: A token balance-crediting branch must not create spendable balances unless it also mints supply under strict authorization or debits an equal backing/source balance, and the credited amount must be bounded by a legitimate entitlement calculation.

| Field | Value |
|---|---|
| Entry function | mint(uint256,address,uint256,uint256,bool) / selector 0x1402dcf2 on SynapLogicErc20 via caller 0x39f36e2e58f36f7e5c17784847fd07da1fee1a32 |
| Public entrypoint | 0x1402dcf2 on SynapLogicErc20 |
| Attacker callbacks | uniswapV3FlashCallback path observed in PoC monetization |
| Callback is root cause | false |

### Observed impact

| Token | Amount | Token address |
|---|---:|---|
| `ETH` | 27.639650363124921789 | `0x0000000000000000000000000000000000000000` |

### Evidence Summary

- **poc_verification** (`evidence summary`): Economic PoC gate passed with forge build/test pass, economic_status pass, proof_kind economic_proof, and product_static_validation.hard_count equal to 0.
- **balance_impact** (`evidence summary`): Evidence summary reports ETH loss from 0x39f36e... and attacker-controlled gains of SYP and ETH, with visible entitlement/accounting anomaly candidates.
- **evidence** (`evidence summary`): Repeated SYP selector 0x1402dcf2 calls write SYP storage and emit Transfer logs to attacker helper 0x3821f686384c231e2f71ea093fb6189de803f482, while WETH/routing steps were demoted as downstream effects.
- **source** (`evidence summary`): SYP totalSupply stayed constant while attacker helper balance increased by 442345096000000000000000 SYP, proving an unbacked holder-level accounting credit rather than ordinary supply expansion.
- **source** (`evidence summary`): Source shows balanceOf sums _vesting and _exchange, while the mint branch credits _exchange[_u] += _am after only relayer111O authorization and emits Transfer without changing _totalSupply or debiting backing.
- **attack_path** (`evidence summary`): Verified PoC expects the SYP and ETH gains and shows downstream WETH withdraw and swapExactTokensForETHSupportingFeeOnTransferTokens monetization, which are effects of the credited SYP entitlement.
- **negative_evidence** (`evidence summary`): Caller relayer provenance could not be proven from available evidence; transfer, WETH, flash callback, swap, and profit-routing steps were rejected as standalone causes; audit required partial status.

## Multi-leg reconciliation

_Top incident drain/loss legs are shown first; gain and mechanical legs remain available in `report/run_summary.json`._

| Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| loss | `0x39f36e2e58f36f7e5c17784847fd07da1fee1a32` | `storage_contract` | `ETH` | -27.6465685 | -$88150.93 |

## Root cause analysis

- **Title**: Unbacked SYP balance credits through relayer-controlled mint accounting branch
- **Severity**: `critical`
- **Confidence**: `medium`
- **Violated invariant**: A token balance-crediting branch must not create spendable balances unless it also mints supply under strict authorization or debits an equal backing/source balance, and the credited amount must be bounded by a legitimate entitlement calculation.

### Final root cause

SynapLogicErc20 selector 0x1402dcf2, decoded from source as mint(uint256,address,uint256,uint256,bool), has an _ac == 3 and _set_mode == 2 branch that credits _exchange[_u] by caller-provided _am after only checking relayer111O[msg.sender]. The credited amount is included in balanceOf(_u), but the branch does not increase _totalSupply, debit a backing reserve, or bind _am to a legitimate entitlement calculation. In this transaction, caller 0x39f36e2e58f36f7e5c17784847fd07da1fee1a32 repeatedly credited attacker helper 0x3821f686384c231e2f71ea093fb6189de803f482 with 442345096000000000000000 SYP, which was then routed through downstream swap/WETH/ETH steps. The analysis is partial because the available evidence do not prove why the caller held or exposed the required relayer authority.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x2bdd3602fc526aa5cc677cd708375dd2f7c4256f` | `SynapLogicErc20` | `primary vulnerable contract` | `—` |
| `0x39f36e2e58f36f7e5c17784847fd07da1fee1a32` | `unknown` | `relayer caller / unresolved parent execution contract` | `—` |

### Recommended fixes

- In SynapLogicErc20.mint, remove free balance credits: require owner-governed minting that updates _totalSupply or debit a real reserve/source balance before crediting _vesting or _exchange.
- Bind _am to a source-backed entitlement calculation or explicit reserve accounting before any _ac == 3 balance credit executes.
- Replace broad relayer-controlled role administration with explicit owner-controlled role administration and audit existing relayer assignments.

### Limitations

- partial because source for 0x39f36e2e58f36f7e5c17784847fd07da1fee1a32 is absent under internal evidence
- prior_state_provenance_gap: successful execution proves relayer111O[msg.sender] passed, but available evidence do not prove when or why the relayer role was granted
- internal evidence is referenced by the evidence summary input contract but absent from the available evidence manifest, so the report cites PoC result/test, evidence summary, RPC observations, source, and iterations instead
- missing_assumption: unresolved caller authority could be a deeper setup or exposure cause, so analysis_status remains partial
