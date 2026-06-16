# RCA Run Report — ethereum 0xec752366…6b393d


## Case overview

- **Chain**: ethereum (chain_id=1)
- **Tx hash**: `0xec7523660f8b66d9e4a5931d97ad8b30acc679c973b20038ba4c15d4336b393d`
- **Block**: 18799488
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 520.91s (520914 ms)
- **Finding**: BatchSwap close settlement is cross-function reentrant through ERC721 receiver callbacks, allowing the accepted counterparty to be replaced before nftsTwo settlement.


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
- **Incident net loss**: $0.00
- **PoC net reproduced**: unknown
- **USD ratio**: unknown

## Attack narrative

_No standalone `attack_flow.md` was available; this section is assembled from RCA report fields._

### RCA-derived flow

BatchSwap.closeSwapIntent accepts msg.sender as addressTwo, updates swap status, and then performs external NFT transfers before all settlement reads of addressTwo are complete. The attacker-controlled ERC721 receiver reenters BatchSwap.editCounterPart, which lacks a status check and reentrancy guard, and rewrites addressTwo to the victim holder. When closeSwapIntent resumes, it reads the mutated addressTwo and transfers the victim's CloneX NFTs into the attacker-created swap.

**Violated invariant**: After closeSwapIntent accepts a counterparty for a swap, the counterparty used for every leg of settlement must remain immutable until settlement completes.

| Field | Value |
|---|---|
| Entry function | 0x64882c9f on attacker contract, invoking BatchSwap.createSwapIntent/closeSwapIntent/editCounterPart |
| Public entrypoint | closeSwapIntent(address,uint256) |
| Attacker callbacks | onERC721Received(bytes4 selector 0x150b7a02) |
| Callback is root cause | false |

### Observed impact

| Token | Amount | Token address |
|---|---:|---|
| `CloneX` | 5 | `0x49cf6f5d44e70224e2e23fdcdd2c053f30ada28b` |

### Evidence Summary

- **poc_verification** (`evidence summary`): Verified economic PoC passed and reproduced attacker-controlled gain of 5 CloneX.
- **balance_impact** (`evidence summary`): Victim holder lost 5 CloneX and attacker EOA gained 5 CloneX in the transaction.
- **evidence** (`evidence summary`): Create/close/edit BatchSwap steps precede and explain the downstream CloneX transfer steps.
- **source** (`evidence summary`): createSwapIntent records swap state and performs external NFT transfers after storing swap data.
- **source** (`evidence summary`): closeSwapIntent checks addressTwo == msg.sender, performs external calls, then later reads addressTwo again for nftsTwo settlement.
- **source** (`evidence summary`): editCounterPart lets the swap creator rewrite addressTwo without checking swap status or blocking reentry.
- **source** (`execution summary`): Attacker callbacks reenter BatchSwap and call editCounterPart to set addressTwo to the victim holder for swap IDs 10351-10355.
- **poc_verification** (`evidence summary`): Whitebox PoC executes callback editCounterPart calls and asserts attacker profit of 5 CloneX.

## Multi-leg reconciliation

_Top incident drain/loss legs are shown first; gain and mechanical legs remain available in `report/run_summary.json`._

| Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| loss | `0x23938954bc875bb8309aef15e2dead54884b73db` | `transfer_counterparty` | `CloneX` | -0.000000000000000005 | N/A |

## Root cause analysis

- **Title**: BatchSwap close settlement is cross-function reentrant through ERC721 receiver callbacks, allowing the accepted counterparty to be replaced before nftsTwo settlement.
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: After closeSwapIntent accepts a counterparty for a swap, the counterparty used for every leg of settlement must remain immutable until settlement completes.

### Final root cause

BatchSwap.closeSwapIntent accepts msg.sender as addressTwo, updates swap status, and then performs external NFT transfers before all settlement reads of addressTwo are complete. The attacker-controlled ERC721 receiver reenters BatchSwap.editCounterPart, which lacks a status check and reentrancy guard, and rewrites addressTwo to the victim holder. When closeSwapIntent resumes, it reads the mutated addressTwo and transfers the victim's CloneX NFTs into the attacker-created swap.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0xc310e760778ecbca4c65b6c559874757a4c4ece0` | `BatchSwap` | `primary vulnerable contract` | `—` |
| `0x49cf6f5d44e70224e2e23fdcdd2c053f30ada28b` | `CloneX` | `asset contract used in downstream transfer` | `—` |

### Recommended fixes

- Add a nonReentrant guard to closeSwapIntent and editCounterPart so ERC721 receiver callbacks cannot mutate active settlement state.
- Require editCounterPart to be callable only while the swap is Opened and before close execution begins.
- In closeSwapIntent, cache the accepted counterparty in a local variable immediately after authorization and use that immutable value for all settlement legs instead of rereading mutable storage after external calls.

### Limitations

- internal evidence was not present in the output root; the callback sequence was corroborated using rca_evidence summary.json, execution summary.txt, PoC.t.sol, source, and RPC observations instead.
