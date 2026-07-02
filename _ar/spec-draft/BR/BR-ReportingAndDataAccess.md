---
doc_id: BR-ReportingAndDataAccess
title: Reporting & Data Access
canonical_layer: BR
spec_type: business-rule
status: draft
affects:
  - EN0031
  - EN0032
  - EN0009
  - EN0001
  - EN0006
  - SYSTEM
references:
  - EN0031
  - EN0032
  - EN0009
  - EN0001
  - EN0006
  - EN0004
  - EN0011
  - UC0017
---

# BR – Reporting & Data Access

## Purpose

Governs reporting exports as a read-only capability and records the current-state PII-at-rest,
coarse-permission, and retention gaps that apply to reporting data access.

## Read-only and permission-gated

- Reporting SHALL be read-only — no case (`EN0001`), party (`EN0006`), money (`EN0009`), Campaign
  (`EN0004`), or contract (`EN0011`) record SHALL be created, updated, or transitioned by the
  reporting capability.
- An on-demand export SHALL be served only after the requesting category permission check passes.
- At most one scheduled export batch SHALL run per calendar day, caching one file per export type;
  a failed batch window SHALL NOT be retried until the next window.

## Sensitive-data handling (current-state)

- Current-state: exported files SHALL be treated as containing raw personal data (identification
  numbers, names, addresses, emails, phones, contract numbers) with no protection on the file beyond
  the request-time permission check.
- Current-state: temporary export files are never cleaned up and SHALL be treated as accumulating
  unencrypted personal data at rest.
- Current-state: permission granularity SHALL NOT be assumed proportionate to sensitivity — some
  exports containing identification numbers and risk verdicts are gated only by the general
  reporting permission.

## Non-Goals

- This rule does not define country/tenant scoping of exports — the absence of country scoping on
  exports is owned by `BR-MultiTenantCountryScoping`, referenced here, not restated.
- This rule does not describe the reporting dashboard's data retrieval or rendering mechanics — the
  reporting dashboard read-model (`EN0031`, `EN0032`) is Partial evidence and is stated here at
  capability level only.
- This rule does not prescribe target-state fixes (file encryption, retention/cleanup jobs,
  sensitivity-proportionate permissions); it records current-state behaviour only.
