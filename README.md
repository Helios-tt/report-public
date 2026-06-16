# Public RCA Reports

This repository contains public exploit-analysis reports and Solidity PoC bundles generated through the RCA stage.

- Source commit: `555581b0312b492da5ea4a161b2ae63b78c96c9b`
- Scope: completed public RCA files from corpus cases `001`-`105`
- Included reports: `98`
- Included Solidity PoC bundles: `98`
- RCA complete: `66`
- RCA partial with documented limitations: `32`
- Not included because no completed local RCA file was available: `009, 041, 055, 068, 070, 081, 098`

## Disclosure Scope

This repository is a public research snapshot released before the transition to a real-time audit service. The published files are intentionally limited to high-level RCA reports and generated Solidity PoC material. More detailed exploit execution flows, internal reasoning notes, backend evidence, and operational analysis files remain unpublished.

## Mission

This work is aimed at real-time exploit intelligence for the EVM ecosystem. The system reconstructs the execution meaning of live exploit transactions within one hour, turning raw on-chain activity into actionable root-cause analysis for incident response, protocol teams, and ecosystem risk monitoring. The analysis stack supports the full EVM-compatible chain surface rather than a single network.

## Public Status Policy

Only cases with a verified economic PoC and an RCA report are included. `complete` means the RCA reached a high-confidence root cause from the available evidence. `partial` means the PoC and RCA completed, but the report retains explicit evidence limitations such as missing verified source, unresolved formula details, or bounded confidence.

## Layout

```text
README.md
manifest.csv
cases/
  <case>/
    report.md
    poc/
      PoC.t.sol
      Base.sol
```

## Preprocessing

The public projection intentionally excludes internal analysis notes, JSON evidence, logs, graph files, raw run summaries, internal execution details, and local absolute paths. Solidity PoC files are normalized to the public `Base.sol` support-file name.
