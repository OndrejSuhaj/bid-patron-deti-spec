---
doc_id: FN0020
title: Reporting Read-Model & CSV Export
canonical_layer: FN
spec_type: functional-capability
status: draft
references:
  - UC0017
  - EN0001
  - EN0002
  - EN0004
  - EN0006
  - EN0009
  - EN0011
  - EN0031
  - EN0032
---

# FN0020 – Reporting Read-Model & CSV Export

## Purpose

Give administrators consolidated, downloadable CSV extracts of donation, application, contract,
scoring, and campaign data for finance/risk/campaign reporting — refreshed automatically once per
day or generated on demand — plus read-model dashboard figures, without altering any domain record.
Clusters the scheduled export batch, the on-demand export request path, and the reporting-dashboard
read model into one reporting capability, distinct from the transactional/domain-writing capabilities
that produce the underlying records.

---

## Responsibilities

The capability is responsible for:

- Running a daily batch that assembles up to sixteen standard reporting CSV files (payments,
  supporters, vouchers, accounting, leads, campaigns, patrons, fundraisers, gift payments, contracts,
  scoring/risk, blacklist, region summaries), caching one file per export type per calendar day and
  discarding the prior day's file for that type.
- Serving on-demand export requests after a per-category permission check (general reporting, leads,
  or accounting), reusing a same-day cached file when one already exists or assembling a fresh one
  when it does not, including two export types that exist only as on-demand requests and are never
  produced by the scheduled batch.
- Narrowing the assembled rows of payments-related exports to a single Campaign (EN0004) when the
  Admin supplies an optional campaign filter.
- Serving reporting dashboards from point-in-time read-model snapshots (CostsSnapshot EN0031,
  ReportSnapshot EN0032) filtered to a requested date range, independently of the CSV export files.
- Reading source records read-only across the reporting scope — no Application (EN0001),
  ApplicationProfile (EN0002), Contact (EN0006), Transaction (EN0009), Campaign (EN0004), or
  Contract (EN0011) record is created, updated, or transitioned by this capability.
- Recording a completion or failure log entry per export produced in a scheduled batch, continuing
  with the remaining exports in the batch when an individual export fails.
- Surfacing an error outcome to the Admin, instead of a file, when record retrieval or file assembly
  fails on an on-demand request.

---

## Related Use Cases

UC0017 – Export Reporting Data (CSV)

---

## Related Entities

EN0009 – Transaction
EN0001 – Application
EN0002 – ApplicationProfile
EN0006 – Contact
EN0004 – Campaign
EN0011 – Contract
EN0031 – CostsSnapshot
EN0032 – ReportSnapshot

---

## Integrations

None. The only boundary is the local filesystem export/storage sink used to persist and re-serve
CSV files for same-day reuse, named per ARCH0002_ContextInteractionMap's C5 (Finance & Reconciliation)
integration landscape; no ES-layer artifact exists yet for this boundary, and no external system is
involved.

---

## Constraints

- Exported CSV content carries raw personally identifiable information (identification numbers,
  names, addresses, emails, phone numbers, contract numbers); no protection beyond the permission
  check applied at request time is placed on the exported file itself, and the underlying temporary
  export files are never cleaned up, accumulating on the storage host over time.
- No tenant/country (CZ/RO/MD) scoping is applied to any export — all standard exports are global
  across tenants.
- Permission granularity is coarse relative to sensitivity: some exports containing identification
  numbers and risk/scoring verdicts are gated only by the general reporting permission rather than a
  dedicated sensitive-data permission.
- At most one scheduled export batch runs per calendar day; a failed or skipped batch window is not
  retried until the next day's window.
- The reporting-dashboard sub-flow (read-model access via CostsSnapshot EN0031 / ReportSnapshot
  EN0032) is Partial — evidenced only by an un-mined flow reference (FL034) and described here at
  capability level only.
