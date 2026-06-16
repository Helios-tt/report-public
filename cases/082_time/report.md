# RCA Run Report — ethereum 0xecdd111a…d2f6b6


## Case overview

- **Chain**: ethereum (chain_id=1)
- **Tx hash**: `0xecdd111a60debfadc6533de30fb7f55dc5ceed01dfadd30e4a7ebdb416d2f6b6`
- **Block**: 18730463
- **Final quality**: `pass`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC and complete RCA.
- **Elapsed**: 582.49s (582491 ms)
- **Finding**: Trusted-forwarder multicall lets attacker spoof _msgSender and burn the pair's TIME balance


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
- **Incident net loss**: $410461.08
- **PoC net reproduced**: $188257.98
- **USD ratio**: 1.000x

## Attack narrative

_No standalone `attack_flow.md` was available; this section is assembled from RCA report fields._

### RCA-derived flow

The TIME token combines ERC2771ContextUpgradeable with MulticallUpgradeable. When called through the trusted Forwarder.execute path, multicall delegatecalls attacker-controlled inner calldata while msg.sender remains the trusted forwarder, so ERC2771ContextUpgradeable._msgSender() trusts the final 20 bytes of each inner payload instead of only the authenticated outer request signer. The attacker supplied the Uniswap pair address as that inner calldata suffix and invoked burn(uint256), causing ERC20BurnableUpgradeable.burn to burn the pair's TIME balance; sync and swaps then converted the corrupted pair accounting into WETH/ETH profit.

**Violated invariant**: A token holder's balance must not be burnable unless the holder itself, a valid allowance path, or an authorized role explicitly authorizes that burn; forwarded multicall inner calldata must not be able to redefine the authenticated sender.

| Field | Value |
|---|---|
| Entry function | yoink() / selector 0x9846cd9e |
| Attacker callbacks | true |
| Callback is root cause | false |

### Observed impact

| Token | Amount | Token address |
|---|---:|---|
| `ETH` | 84.590222144759262264 | `0x0000000000000000000000000000000000000000` |

### Evidence Summary

- **poc_verification** (`evidence summary`): Economic PoC is verified: pass statuses, economic_proof kind, and zero hard product blockers.
- **balance_impact** (`evidence summary`): The transaction has direct asset loss, including TIME and WETH losses from the pair/storage holder and ETH gain by the attacker; tx_role_assessment warns not to stop at approval/drain steps.
- **evidence** (`evidence summary`): execution steps is the token burn/accounting step reached through the forwarder/multicall path and records TIME storage writes reducing supply/balances plus calldata ending in the pair address.
- **evidence** (`execution summary`): Observed order places Forwarder.execute before pair sync and the later swap/withdraw/profit-routing steps.
- **source** (`evidence summary`): The forwarder authenticates req.from, increments the nonce, and forwards abi.encodePacked(req.data, req.from) to the token.
- **source** (`evidence summary`): The token executes each attacker-supplied inner calldata item using delegatecall to address(this).
- **source** (`evidence summary`): When msg.sender is trusted, _msgSender() reads the last 20 calldata bytes as the sender.
- **source** (`evidence summary`): burn(uint256) burns from _msgSender(), making sender spoofing directly authorize the pair balance burn.

## Multi-leg reconciliation

_Top incident drain/loss legs are shown first; gain and mechanical legs remain available in `report/run_summary.json`._

| Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---:|---:|
| loss | `0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2` | `storage_contract` | `ETH` | -94.91959550651688541 | -$211246.29 |
| loss | `0x760dc1e043d99394a10605b2fa08f123d60faf84` | `storage_contract` | `WETH` | -89.513462587046838316 | -$199214.79 |
| loss | `0x760dc1e043d99394a10605b2fa08f123d60faf84` | `storage_contract` | `TIME` | -62227259510 | N/A |

## Root cause analysis

- **Title**: Trusted-forwarder multicall lets attacker spoof _msgSender and burn the pair's TIME balance
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: A token holder's balance must not be burnable unless the holder itself, a valid allowance path, or an authorized role explicitly authorizes that burn; forwarded multicall inner calldata must not be able to redefine the authenticated sender.

### Final root cause

The TIME token combines ERC2771ContextUpgradeable with MulticallUpgradeable. When called through the trusted Forwarder.execute path, multicall delegatecalls attacker-controlled inner calldata while msg.sender remains the trusted forwarder, so ERC2771ContextUpgradeable._msgSender() trusts the final 20 bytes of each inner payload instead of only the authenticated outer request signer. The attacker supplied the Uniswap pair address as that inner calldata suffix and invoked burn(uint256), causing ERC20BurnableUpgradeable.burn to burn the pair's TIME balance; sync and swaps then converted the corrupted pair accounting into WETH/ETH profit.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x4b0e9a7da8bab813efae92a6651019b8bd6c0a29` | `TokenERC20/TIME` | `primary vulnerable contract` | `0x303a41300baeb37a1028af017b17b8a6edc3066a` |
| `0xc82bbe41f2cf04e3a8efa18f7032bdd7f6d98a81` | `Forwarder` | `trusted forwarder used to trigger the vulnerable context` | `—` |
| `0x760dc1e043d99394a10605b2fa08f123d60faf84` | `UniswapV2Pair` | `victim liquidity pair whose TIME balance was spoof-burned` | `—` |

### Recommended fixes

- Disable or override multicall when called through ERC2771 trusted forwarders, or make every inner delegatecall append/use the authenticated outer sender rather than attacker-controlled inner calldata.
- Reject multicall items that can alter the last 20 calldata bytes used by ERC2771ContextUpgradeable._msgSender(), especially for authority-sensitive functions such as burn, burnFrom, mint, approvals, and role-gated operations.
- Add tests that call the token via the trusted Forwarder.execute path with multicall containing burn(uint256) plus a spoofed suffix and assert it cannot burn a third party's balance.

### Limitations

- internal evidence was not present in the public bundle; execution order was taken from internal evidence and internal evidence instead.
