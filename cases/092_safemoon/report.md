# RCA Run Report — bsc 0x48e52a12…33a934


## Case overview

- **Chain**: bsc (chain_id=56)
- **Tx hash**: `0x48e52a12cb297354a2a1c54cbc897cf3772328e7e71f51c9889bb8c5e533a934`
- **Block**: 26864890
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 587.02s (587018 ms)
- **Finding**: Public SFM burn lets any caller debit arbitrary accounts and distort AMM reserves


## Reproduction quality

- **PoC status**: `verified`
- **Forge fmt**: `pass`
- **Forge build**: `pass`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`
- **RCA status**: `complete` / `complete`
- **RCA confidence**: `high`

## Economic reproduction

- **Basis**: incident profit oracle usd
- **Verdict**: exact — PoC reproduces 99–101% of incident net loss.
- **Incident net loss**: $17204161.01
- **PoC net reproduced**: $8581160.24
- **USD ratio**: 1.000x

## Attack narrative

_No standalone `attack_flow.md` was available; this section is assembled from RCA report fields._

### RCA-derived flow

The SFM implementation behind proxy 0x42981d0bfbaf196529376ee702f2a9eb9092fcb5 exposes public burn(address,uint256) without checking that msg.sender owns, is approved for, or is privileged to burn from the supplied from address. That function forwards attacker-controlled from into _tokenTransfer(from, bridgeBurnAddress, amount, 0, false), whose accounting branches debit the supplied from and credit the burn destination. The attacker used this in execution steps to burn SFM from LP/protocol addresses, then synced/swapped through the AMM path to extract WBNB/BNB profit.

**Violated invariant**: A burn or balance-debit from address must be authorized by that holder, an allowance spender, or an explicit privileged bridge/burn role.

| Field | Value |
|---|---|
| Entry function | burn(address,uint256) / selector 0x9dc29fac |
| Funding source | flash/liquidity path visible in PoC, but not root cause |
| Public entrypoint | burn(address,uint256) |
| Attacker callbacks | 0xa1fae685c8abf938eb706dedabbcffbff3b3d7da |
| Callback is root cause | false |

### Observed impact

| Token | Amount | Token address |
|---|---:|---|
| `BNB` | 27387.357095483374950933 | `0x0000000000000000000000000000000000000000` |

### Evidence Summary

- **poc_verification** (`evidence summary`): Verified economic PoC passed with hard_count 0 and reproduced attacker BNB/SFM gain.
- **evidence** (`evidence summary`): Attacker/helper-called SFM burn(address,uint256) steps wrote SFM proxy accounting state, emitted Transfer logs, and were connected to direct asset loss/profit.
- **proxy_metadata** (`evidence summary`): SFM proxy resolved to implementation 0xeb11a0a0bef1ac028b8c2d4cd64138dd5938ca7a pre/post and implementation code existed pre/post.
- **source** (`evidence summary`): Public burn lacks caller authorization and debits attacker-selected from via shared token transfer accounting; mint is comparatively whitelist-gated.
- **source** (`evidence summary`): The verified PoC calls SFM burn on LP/proxy addresses, then sync/swap/profit-routing actions.
- **negative_evidence** (`evidence summary`): Approval, transfer, swap, LP sync, WBNB withdrawal, profit routing, and AMM reserve-consumption steps were classified as downstream exploitation path rather than root cause; no competing oracle/health/solvency gate was found.
- **balance_impact** (`evidence summary`): Attacker EOA gained 27387357095483374950933 wei BNB and attacker callback gained 935969814143858147 raw SFM while LP/protocol holders lost WBNB/SFM.

## Multi-leg reconciliation

_Top incident drain/loss legs are shown first; gain and mechanical legs remain available in `report/run_summary.json`._

| Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| loss | `0x8e0301e3bde2397449fef72703e71284d0d149f1` | `storage_contract` | `WBNB` | -27457.783053089548067627 | -$8602835.08 |
| loss | `0xbb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c` | `storage_contract` | `BNB` | -27452.783053089548067627 | -$8601268.53 |
| loss | `0x8c561b2a7a54a79dab60adf62e576251c42e145c` | `storage_contract` | `BNB` | -0.183212523515225997 | -$57.40 |
| loss | `0x42981d0bfbaf196529376ee702f2a9eb9092fcb5` | `storage_contract` | `SFM` | -143871.950545837 | N/A |
| loss | `0x8e0301e3bde2397449fef72703e71284d0d149f1` | `storage_contract` | `SFM` | -32920587255.211238581 | N/A |
| loss | `0xce60b76055baad18cfaabc8f894fef7a15610867` | `transfer_counterparty` | `CHI` | -65 | N/A |

## Root cause analysis

- **Title**: Public SFM burn lets any caller debit arbitrary accounts and distort AMM reserves
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: A burn or balance-debit from address must be authorized by that holder, an allowance spender, or an explicit privileged bridge/burn role.

### Final root cause

The SFM implementation behind proxy 0x42981d0bfbaf196529376ee702f2a9eb9092fcb5 exposes public burn(address,uint256) without checking that msg.sender owns, is approved for, or is privileged to burn from the supplied from address. That function forwards attacker-controlled from into _tokenTransfer(from, bridgeBurnAddress, amount, 0, false), whose accounting branches debit the supplied from and credit the burn destination. The attacker used this in execution steps to burn SFM from LP/protocol addresses, then synced/swapped through the AMM path to extract WBNB/BNB profit.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x42981d0bfbaf196529376ee702f2a9eb9092fcb5` | `TransparentUpgradeableProxy/SFM` | `primary vulnerable token proxy` | `0xeb11a0a0bef1ac028b8c2d4cd64138dd5938ca7a` |
| `0xeb11a0a0bef1ac028b8c2d4cd64138dd5938ca7a` | `Safemoon` | `primary vulnerable implementation` | `—` |

### Recommended fixes

- Restrict burn(address,uint256) so only from, an allowance spender with allowance decrement, or an explicit privileged bridge/burn role can debit from.
- Align bridge burn access control with mint's whitelist model and add tests that arbitrary callers cannot burn from LP/pair/token contract addresses.
- Reject bridge burn operations that use an unset or invalid bridgeBurnAddress.
