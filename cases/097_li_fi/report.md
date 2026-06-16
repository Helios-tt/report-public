# RCA Run Report — ethereum 0x4b4143cb…ac4e96


## Case overview

- **Chain**: ethereum (chain_id=1)
- **Tx hash**: `0x4b4143cbe7f5475029cf23d6dcbb56856366d91794426f2e33819b9b1aac4e96`
- **Block**: 14420687
- **Final quality**: `partial`
- **Product/PoC gate**: `pass`
- **Final-quality basis**: `poc_and_rca`
- **Final-quality reason**: Verified economic PoC, but RCA is partial.
- **Elapsed**: 992.73s (992727 ms)
- **Finding**: LiFi swap bridge entrypoint executed arbitrary token transferFrom calldata before bridging


## Reproduction quality

- **PoC status**: `verified`
- **Forge fmt**: `pass`
- **Forge build**: `pass`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`
- **RCA status**: `partial` / `partial`
- **RCA confidence**: `medium`

## Economic reproduction

- **Basis**: downstream position usd
- **Verdict**: downstream_position_exact
- **Incident net loss**: $587421.47
- **PoC net reproduced**: $0.00
- **USD ratio**: 1.000x

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

- Transaction: `0x4b4143cbe7f5475029cf23d6dcbb56856366d91794426f2e33819b9b1aac4e96`
- Block: `14420687`
- Root call type: `CALL`
- Target/tx.to: `0x5a9fd7c39a6c488e715437d7b1f3c823d5596ed1`
- Attacker: `0xc6f2bde06967e04caaf4bf4e43717c3342680d76`

## Multi-leg reconciliation

- Status: `pass`
- Basis: `incident_drain`
- Source: `economic_reproduction`
- Selected rows: 32

| Source | Direction | Holder | Role | Token | Delta | USD value |
|---|---|---|---|---|---:|---:|
| incident_drain | loss | `0x14b2af25e47f590a145aad5be781687ca20edd97` | `transfer_counterparty` | `USDC` | -1548.25 | $-1549.06 |
| incident_drain | loss | `0x15697225d98885a4b007381ccf0006270d851a35` | `transfer_counterparty` | `MVI` | -22.950860845096132852 | $-3131.65 |
| incident_drain | loss | `0x195b8b9598904b55e9770492bd697529492034a2` | `transfer_counterparty` | `USDC` | -1031.798257 | $-1032.34 |
| incident_drain | loss | `0x2182e4f2034bf5451f168d0643b2083150ab7931` | `transfer_counterparty` | `USDC` | -591.497564 | $-591.81 |
| incident_drain | loss | `0x26ab154c70aec017d78e6241da76949c37b171e2` | `transfer_counterparty` | `AAVE` | -8.989600608542871027 | $-1394.35 |
| incident_drain | loss | `0x2e70c44b708028a925a8021723ac92fb641292df` | `transfer_counterparty` | `USDC` | -625 | $-625.33 |
| incident_drain | loss | `0x3942ae3782fbd658cc19a8db602d937baf7cb57a` | `transfer_counterparty` | `USDC` | -4879.938172 | $-4882.50 |
| incident_drain | loss | `0x445c21166a3cb20b14fa84cfc5d122f6bd3ffa17` | `transfer_counterparty` | `MATIC` | -3037.410587818508608814 | N/A |
| incident_drain | loss | `0x45372cce828e185bfb008942cfe42a4c5cc76a75` | `transfer_counterparty` | `USDC` | -184.659875 | $-184.76 |
| incident_drain | loss | `0x45f3fc38441b1aa7b60f8aad8954582b17c9503c` | `transfer_counterparty` | `DAI` | -1358.968773152900467441 | $-1358.69 |
| incident_drain | loss | `0x461e76a4fe9f27605d4097a646837c32f1ccc31c` | `transfer_counterparty` | `DAI` | -592.959324599911663609 | $-592.84 |
| incident_drain | loss | `0x461e76a4fe9f27605d4097a646837c32f1ccc31c` | `transfer_counterparty` | `USDC` | -15303.033965 | $-15311.08 |
| incident_drain | loss | `0x574a782a00dd152d98ff85104f723575d870698e` | `transfer_counterparty` | `USDC` | -163171.445612 | $-163257.26 |
| incident_drain | loss | `0x5a7517b2a3a390aaec27d24b1621d0b9d7898dd4` | `transfer_counterparty` | `RPL` | -44.8608743 | N/A |
| incident_drain | loss | `0x5b7ab4b4b4768923cddef657084223528c807963` | `transfer_counterparty` | `USDC` | -774.404203 | $-774.81 |
| incident_drain | loss | `0x5b9e4d0dd21f4e071729a9eb522a2366abed149a` | `transfer_counterparty` | `USDT` | -383.88363 | $-384.09 |
| incident_drain | loss | `0x6e5c200a784ba062ab770e6d317637f2fc82e53d` | `transfer_counterparty` | `DAI` | -5359.458621755364862525 | $-5358.36 |
| incident_drain | loss | `0x7c89a5373312f9a02dd5c5834b4f2e3e6ce1cd96` | `transfer_counterparty` | `USDT` | -51859.434887 | $-51887.59 |
| incident_drain | loss | `0x80e7ed83354833aa7b87988f7e0426cffe238a83` | `transfer_counterparty` | `USDC` | -1000.537946 | $-1001.06 |
| incident_drain | loss | `0x899cc16c88173de60f3c830d004507f8da3f975f` | `transfer_counterparty` | `USDC` | -627.712497 | $-628.04 |
| incident_drain | loss | `0x8de133a0859b847623c282b4dc5e18de5dbfd7d1` | `transfer_counterparty` | `USDT` | -181399.79973 | $-181498.30 |
| incident_drain | loss | `0x9241f27daffd0bb1df4f2a022584dd6c77843e64` | `transfer_counterparty` | `GNO` | -0.944405031229340416 | $-301.79 |
| incident_drain | loss | `0x9241f27daffd0bb1df4f2a022584dd6c77843e64` | `transfer_counterparty` | `USDT` | -120625.535311 | $-120691.03 |
| incident_drain | loss | `0x9b36f2bc04cd5b8a38715664263a3b3b856bc1cf` | `transfer_counterparty` | `MATIC` | -107.476780372256517339 | N/A |
| incident_drain | loss | `0xacf65a171c67a7074ee671240967696ab5d1185f` | `transfer_counterparty` | `USDC` | -2380.792227 | $-2382.04 |
| incident_drain | loss | `0xb0d497a6cff14e0a0079d5feff0c51c929f5fc8d` | `transfer_counterparty` | `AUDIO` | -1202.371620631794480684 | $-1311.79 |
| incident_drain | loss | `0xcc77df7e9959c60e7ec427367e1ae6e2720d6735` | `transfer_counterparty` | `USDC` | -5085.75185 | $-5088.43 |
| incident_drain | loss | `0xd92b2a99da006e72b48a14e4c23

_… truncated in final report; see source excerpt for full text._


## Root cause analysis

- **Title**: LiFi swap bridge entrypoint executed arbitrary token transferFrom calldata before bridging
- **Severity**: `critical`
- **Confidence**: `medium`
- **Violated invariant**: A bridge-swap route must not execute arbitrary user-supplied callTo/callData capable of transferring third-party ERC20 balances; swap calls must be restricted to approved targets and transaction-owned funds.

### Final root cause

The LiFi contract at 0x5a9fd7c39a6c488e715437d7b1f3c823d5596ed1 exposed swapAndStartBridgeTokensViaCBridge selector 0x01c0a31a and accepted attacker-supplied swapCalls that directly targeted ERC20 token contracts with transferFrom calldata. The missing invariant was that swap execution must restrict call targets/selectors to approved swap integrations and only spend assets belonging to the current LiFi transaction context. Because verified LiFi implementation source is absent, the exact source branch is not pinned and the RCA remains partial.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x5a9fd7c39a6c488e715437d7b1f3c823d5596ed1` | `LiFi diamond or entry contract` | `primary vulnerable contract` | `0x73a499e043b03fc047189ab1ba72eb595ff1fc8e` |
| `0x5427fefa711eff984124bfbb1ab6fbf5e3da1820` | `Bridge` | `downstream bridge recipient` | `—` |

### Recommended fixes

- Before executing each LiFi swap call, enforce an allowlist of swap targets and permitted selectors, and reject ERC20 transferFrom or any token-call calldata that spends from addresses other than the LiFi contract or explicitly supplied sender context.
- Separate bridge execution from arbitrary swap execution so the bridge entrypoint can only bridge assets produced by validated swap adapters.

### Limitations

- source_branch_gap: verified source for LiFi implementation 0x73a499e043b03fc047189ab1ba72eb595ff1fc8e is absent under internal evidence, so the exact source file and line for the missing validation branch cannot be cited.
- The RCA relies on supplied execution summary for the LiFi entrypoint and verified source only for the downstream CBridge contract.
- Only bounded RPC observations supplied in internal evidence were used; no external reports or live web context were used.
