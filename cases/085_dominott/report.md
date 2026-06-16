# RCA Run Report — bsc 0x1ee617cd…c877a8


## Case overview

- **Chain**: bsc (chain_id=56)
- **Tx hash**: `0x1ee617cd739b1afcc673a180e60b9a32ad3ba856226a68e8748d58fcccc877a8`
- **Block**: 34141660
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 537.36s (537355 ms)
- **Finding**: ERC2771 forwarded multicall let attacker spoof _msgSender and burn PancakePair DominoTT tokens


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
- **Incident net loss**: $266.15
- **PoC net reproduced**: $266.15
- **USD ratio**: 1.000x

## Attack narrative

_No standalone `attack_flow.md` was available; this section is assembled from RCA report fields._

### RCA-derived flow

DominoTT's TokenERC20 combined ERC2771ContextUpgradeable with MulticallUpgradeable without preserving the original forwarded sender across delegatecalled inner calls. During a valid Forwarder.execute call, multicall delegatecalled attacker-controlled burn(uint256) calldata ending in the PancakePair address; because msg.sender remained the trusted forwarder, _msgSender() returned those trailing bytes and burn destroyed PancakePair's DominoTT. Syncing the Pair then accepted the corrupted token balance as reserves, enabling a later swap to extract WBNB.

**Violated invariant**: A burn must reduce only tokens owned by the true caller or by an account that has explicitly authorized the caller; attacker-controlled inner multicall calldata must not determine the ERC2771 sender used by burn.

| Field | Value |
|---|---|
| Entry function | Forwarder.execute(ForwardRequest,bytes) -> TokenERC20.multicall(bytes[]) -> burn(uint256) |
| Funding source | DPP flashLoan(uint256,uint256,address,bytes) |
| Attacker callbacks | DPPFlashLoanCall(address,uint256,uint256,bytes) |
| Callback is root cause | false |

### Observed impact

| Token | Amount | Token address |
|---|---:|---|
| `WBNB` | 1.152095510970497300 | `0xbb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c` |

### Evidence Summary

- **poc_verification** (`evidence summary`): Verified economic PoC gate passed with exact WBNB attacker profit reproduction and no hard product blockers.
- **balance_impact** (`evidence summary`): PancakePair lost 1999999999999999966445568 DominoTT and 1152095510970497300 WBNB; attacker EOA gained 1152095510970497300 WBNB.
- **evidence** (`evidence summary`): execution steps is the DominoTT accounting/supply mutation with burn-shaped calldata ending in the PancakePair address and committed storage writes reducing balances and total supply.
- **evidence** (`evidence summary`): RPC confirms DominoTT totalSupply and Pair DominoTT balance decreased by the same burn amount and confirms the matching WBNB Pair loss and attacker gain.
- **source** (`evidence summary`): burn(uint256) burns from _msgSender(), so spoofing _msgSender() changes the account whose balance is destroyed.
- **source** (`evidence summary`): When msg.sender is trusted, _msgSender() returns the last 20 bytes of the current calldata.
- **source** (`evidence summary`): multicall delegatecalls address(this) with each attacker-supplied bytes payload, creating attacker-controlled current calldata under the trusted-forwarder msg.sender.
- **source** (`evidence summary`): Forwarder.execute verifies the signed request and appends req.from only to the outer call, allowing the vulnerable token/multicall composition to mishandle forwarded context internally.

## Multi-leg reconciliation

_Top incident drain/loss legs are shown first; gain and mechanical legs remain available in `report/run_summary.json`._

| Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| loss | `0x4f34b914d687195a73318ccc58d56d242b4dccf6` | `storage_contract` | `WBNB` | -1.1520955109704973 | -$266.15 |
| loss | `0x4f34b914d687195a73318ccc58d56d242b4dccf6` | `storage_contract` | `DominoTT` | -1999999.999999999966445568 | N/A |

## Root cause analysis

- **Title**: ERC2771 forwarded multicall let attacker spoof _msgSender and burn PancakePair DominoTT tokens
- **Severity**: `high`
- **Confidence**: `high`
- **Violated invariant**: A burn must reduce only tokens owned by the true caller or by an account that has explicitly authorized the caller; attacker-controlled inner multicall calldata must not determine the ERC2771 sender used by burn.

### Final root cause

DominoTT's TokenERC20 combined ERC2771ContextUpgradeable with MulticallUpgradeable without preserving the original forwarded sender across delegatecalled inner calls. During a valid Forwarder.execute call, multicall delegatecalled attacker-controlled burn(uint256) calldata ending in the PancakePair address; because msg.sender remained the trusted forwarder, _msgSender() returned those trailing bytes and burn destroyed PancakePair's DominoTT. Syncing the Pair then accepted the corrupted token balance as reserves, enabling a later swap to extract WBNB.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x0dabdc92af35615443412a336344c591faed3f90` | `TokenERC20 / DominoTT proxy` | `primary vulnerable contract` | `0xae5be6d490c47c7417e91b7911d3a0ce3553438d` |
| `0x7c4717039b89d5859c4fbb85edb19a6e2ce61171` | `Forwarder` | `trusted forwarder used to trigger vulnerable path` | `—` |
| `0x4f34b914d687195a73318ccc58d56d242b4dccf6` | `PancakePair` | `victim liquidity pool whose token balance and reserves were corrupted` | `—` |

### Recommended fixes

- Patch TokenERC20's Multicall/ERC2771 integration so inner delegatecalls cannot derive _msgSender() from attacker-controlled trailing calldata; preserve the original forwarded sender for each inner call or reject multicall when msg.sender is a trusted forwarder.
- Add regression tests for Forwarder.execute -> multicall(bytes[]) -> burn(uint256) where inner calldata appends a third-party holder address and assert the burn reverts unless that holder explicitly authorized it.
- Consider disabling inherited ERC20Burnable burn/burnFrom for forwarded multicall contexts unless the original signer is the burned account or allowance owner.
