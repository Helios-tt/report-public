# RCA Run Report — ethereum 0x1e90cbff…d8237d


## Case overview

- **Chain**: ethereum (chain_id=56)
- **Tx hash**: `0x1e90cbff665c43f91d66a56b4aa9ba647486a5311bb0b4381de4d653a9d8237d`
- **Block**: 48472356
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 766.69s (766686 ms)
- **Finding**: BTNFT reward claim branch skips ERC721 authorization and pays msg.sender


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

- Transaction: `0x1e90cbff665c43f91d66a56b4aa9ba647486a5311bb0b4381de4d653a9d8237d`
- Block: `48472356`
- Root call type: `CALL`
- Target/tx.to: `0x7a4d144307d2dfa2885887368e4cd4678db3c27a`
- Attacker: `0xbda2a27cdb2ffd4258f3b1ed664ed0f28f9e0fc3`

## PoC Surfaces

| Role | Surface | Selector | Address | Steps |
|---|---|---|---|---|
| attacker_entry | test(address,address,uint256) | `0xfd9ba018` | `0x7a4d144307d2dfa2885887368e4cd4678db3c27a` | `1` |

## Economic Effect

- Reconciliation basis: `poc_profit_fallback`
- Verdict: `unpriced`
- Comparison bas

_… truncated in final report; see source excerpt for full text._


## Multi-leg reconciliation

- Status: `pass`
- Basis: `poc_profit_fallback`
- Source: `economic_reproduction`
- Selected rows: 1
- Note: Incident drain/loss legs were absent; verified PoC attacker-gain legs are recorded for reconciliation.

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| poc_profit | gain | `0x7a4d144307d2dfa2885887368e4cd4678db3c27a` | `attacker_entry` | `BTT` | 19158.433044140030441194 | N/A |


## Root cause analysis

- **Title**: BTNFT reward claim branch skips ERC721 authorization and pays msg.sender
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: Only the NFT owner or an approved operator may claim or redirect a token's vested BTT, and reward payout must go to the authorized owner or beneficiary rather than an arbitrary caller.

### Final root cause

BTNFT.transferFrom(address,address,uint256) reaches the BTNFT._update branch for to == address(this). That branch calls claimReward(tokenId) and returns before inherited super._update can run _checkAuthorized, while claimReward transfers the vested BTT amount to msg.sender. An attacker can supply the real owner as from, send the NFT to BTNFT, and receive the token's claimable BTT without being the owner or approved operator.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x0fc91b6fea2e7a827a8c99c91101ed36c638521b` | `BTNFT` | `primary vulnerable contract` | `—` |
| `0xdad4df3efdb945358a3ef77b939ba83dae401da8` | `BTTToken` | `downstream payout token` | `—` |

### Recommended fixes

- In BTNFT._update, run the inherited authorization path for to == address(this) before claiming, either by calling super._update(to, tokenId, auth) or by explicitly checking _checkAuthorized(previousOwner, auth, tokenId).
- Change claimReward payout semantics so the BTT recipient is the authorized token owner or recorded beneficiary, not arbitrary msg.sender.
- Add a regression test where an unapproved third party calls transferFrom(actualOwner, address(BTNFT), tokenId) and verify it reverts and does not change claimedAmount or transfer BTT.

### Limitations

- USD value is unavailable because the supplied reproduction could not price BTT.
- The PoC notes two execution summary-only storage writes, but the selected causal claim does not rely on them.
