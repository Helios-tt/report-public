# RCA Run Report — ethereum 0x726459a4…7384d0


## Case overview

- **Chain**: ethereum (chain_id=1)
- **Tx hash**: `0x726459a46839c915ee2fb3d8de7f986e3c7391c605b7a622112161a84c7384d0`
- **Block**: 18802015
- **Final quality**: `partial`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC, but RCA is partial.
- **Elapsed**: 699.53s (699528 ms)
- **Finding**: Reserve accounting accepted attacker-routed cDAI balance changes as valid G$/G$X entitlement


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
- **Verdict**: unpriced — raw PoC proof passed, but USD comparison is incomplete.
- **Incident net loss**: $1250960.34
- **PoC net reproduced**: unknown
- **USD ratio**: unknown

## Attack narrative

_No standalone `attack_flow.md` was available; this section is assembled from RCA report fields._

### RCA-derived flow

GoodReserveCDai and GoodMarketMaker reserve accounting accepted balance-derived cDAI changes as valid mint/sell entitlement without source-visible provenance validation from the staking/deposit path. The attacker used flash-loan/Compound-funded cDAI and deposit calls to make the reserve/market-maker path mint and redeem G$/G$X as if the value were legitimate protocol yield, then sold through the normal reserve path to extract cDAI/DAI. The exact patchable branch is partial because the source for the 0x9a5c deposit contract is not present and runtime implementation mapping is not fully closed-world resolved.

**Violated invariant**: Only verified authorized staking yield may increase reserve interest/accounting used to mint G$/G$X or authorize reserve cDAI redemption; externally routed or transient cDAI balance deltas must not create entitlement.

| Field | Value |
|---|---|
| Entry function | attacker contract 0x2ebd2116; reserve calls buy(uint256,uint256,address), sell(uint256,uint256,address,address), and selector 0x1de778a5 |
| Funding source | Balancer flash loan and Compound borrow path visible in PoC/execution summary |
| Attacker callbacks | Balancer flash loan callback / receiveFlashLoan path |
| Callback is root cause | false |

### Observed impact

| Token | Amount | Token address |
|---|---:|---|
| `G$X` | 10213394244.25 | `0xa150a825d425b36329d8294eef8bd0fe68f8f6e0` |

### Evidence Summary

- **poc_verification** (`evidence summary`): Verified economic PoC: all required pass fields are present and hard static blockers are zero.
- **evidence** (`evidence summary`): Evidence summary shows direct loss, G$X giant mint/supply relevance, reserve buy/sell steps, and selector 0x1de778a5 parent accounting steps.
- **balance_impact** (`evidence summary`): G$X totalSupply and attacker G$X balance both increased by 1021339424425, proving supply expansion rather than transfer-only movement.
- **source** (`evidence summary`): GoodReserveCDai computes buy/sell entitlement through the market maker, mints G$/G$X, and derives interestInCdai from balance minus reserveSupply while ignoring startingCDAIBalance.
- **source** (`evidence summary`): Market-maker formulas trust reserveSupply/gdSupply/reserveRatio and provide the accounting path that turns accepted reserve deltas into mint/sell entitlement.
- **attack_path** (`evidence summary`): PoC executes cDAI mint/approval, G$X buy, deposit calls, G$X sell, and downstream cDAI/DAI redemption/transfer; these support exploit flow but are not alone the cause.
- **negative_evidence** (`evidence summary`): Approvals, transferFrom, flash loan, Compound redemption, and profit routing were rejected as root cause; no competing source-visible oracle/health gate was found on the reserve accounting path.

## Multi-leg reconciliation

_Top incident drain/loss legs are shown first; gain and mechanical legs remain available in `report/run_summary.json`._

| Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| loss | `0x5d3a536e4d6dbd6114cc1ead35777bab948e3643` | `storage_contract` | `DAI` | -625140.676705135213042766 | -$625498.76 |
| loss | `0xa150a825d425b36329d8294eef8bd0fe68f8f6e0` | `storage_contract` | `cDAI` | -27657376.67303848 | -$625460.60 |
| loss | `0xacada0c9795fdbb6921ae96c4d7db2f8b8c52fd0` | `storage_contract` | `ETH` | -0.00043773344075164 | -$0.98 |
| loss | `0x6c08f56ff2b15db7ddf2f123f5bffb68e308161b` | `transfer_counterparty` | `WETH` | -0.000000000050249695 | -$0.00 |

## Root cause analysis

- **Title**: Reserve accounting accepted attacker-routed cDAI balance changes as valid G$/G$X entitlement
- **Severity**: `critical`
- **Confidence**: `medium`
- **Violated invariant**: Only verified authorized staking yield may increase reserve interest/accounting used to mint G$/G$X or authorize reserve cDAI redemption; externally routed or transient cDAI balance deltas must not create entitlement.

### Final root cause

GoodReserveCDai and GoodMarketMaker reserve accounting accepted balance-derived cDAI changes as valid mint/sell entitlement without source-visible provenance validation from the staking/deposit path. The attacker used flash-loan/Compound-funded cDAI and deposit calls to make the reserve/market-maker path mint and redeem G$/G$X as if the value were legitimate protocol yield, then sold through the normal reserve path to extract cDAI/DAI. The exact patchable branch is partial because the source for the 0x9a5c deposit contract is not present and runtime implementation mapping is not fully closed-world resolved.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0xa150a825d425b36329d8294eef8bd0fe68f8f6e0` | `ERC1967Proxy / G$X reserve proxy` | `primary vulnerable reserve token proxy` | `0x18bcdf79a724648bf34eb06701be81bd072a2384` |
| `0x18bcdf79a724648bf34eb06701be81bd072a2384` | `GoodReserveCDai` | `source-backed reserve accounting implementation` | `—` |
| `0x9a5cd1145791b29ac4e68df3bf8e30d2167daa76` | `unknown staking/deposit adapter` | `source-gapped deposit path involved in entitlement setup` | `—` |

### Recommended fixes

- In GoodReserveCDai.mintUBI and its caller/deposit path, replace balance-delta-based interest trust with explicit accounting of authorized staking yield and require the collected interest amount to match verified active staking contract returns.
- Reject externally donated or transient cDAI balance deltas before calling GoodMarketMaker.mintInterest, mintExpansion, buy, or sellWithContribution.
- Add source-visible checks that G$X discount and reserve redemption entitlement cannot be created from same-transaction routed cDAI/G$ balances unless those balances pass an authorized provenance check.

### Limitations

- missing_assumption
- source_mapping_gap: execution evidence code_address 0x2793a5887f53b025f49f7a9249d66f4671bce29b is not present as a source bundle directory, while proxy metadata for 0xa150... maps to 0x18bc... source; this prevents complete source-to-runtime proof.
- prior_state_provenance_gap: storage slots and pre-existing accounting values are used only as precondition anchors; their semantic provenance is not decoded beyond source-backed variables.
- tx_scope_gap: source for the 0x9a5cd1145791b29ac4e68df3bf8e30d2167daa76 deposit contract/path is missing, so the exact vulnerable deposit validation branch cannot be pinpointed.
- attack_flow.md is absent from internal evidence, so PoC.t.sol and execution summary.txt were used for attack-flow evidence.
