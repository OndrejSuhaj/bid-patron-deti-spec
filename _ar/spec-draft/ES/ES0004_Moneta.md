---
doc_id: ES0004
title: Moneta
canonical_layer: ES
spec_type: external-system
status: draft
references:
  - ARCH0001
  - ARCH0002
  - FN0012
  - UC0008
---

# ES0004 – Moneta

## Purpose

Moneta provides the Czech bank account-information (AISP) feed that the platform polls to import
incoming bank credits for donation reconciliation. It is the CZ-market source of "money arrived at
the bank" evidence that the reconciliation capability (FN0012) matches against expected donations
(UC0008).

---

## System Overview

Moneta is a Czech bank exposing an account-information (AISP) API that returns account and
transaction data for accounts the platform is authorised to read. Within the platform's integration
landscape it is one of several bank/gateway sources feeding reconciliation, alongside the bank
notification inbox and the ComGate transfer/settlement sync (ARCH0001 §5). It is CZ-only: it has no
role in the RO or MD current-state flows.

---

## Integration Model

Inbound (poll). A daily reconciliation cron initiates an outbound, authenticated pull against
Moneta's AISP API, scoped to the single bank account configured for the platform; the platform then
matches the returned credits against expected donations (UC0008, sub-flow UC0008.1). There is no
inbound push/webhook from Moneta — all interaction is platform-initiated, once per day, per
ARCH0002's reconciliation cron/CLI chain (chain (b)).

---

## Data Exchange

- Outbound: an authenticated request resolving the configured bank account, followed by a
  transactions query scoped to the prior day ("yesterday"), paged.
- Inbound: incoming bank-credit transaction records for that account and window, used as
  reconciliation input against donation records (conceptual only — entity/attribute detail is owned
  by EN0009/EN0029, not restated here).

---

## Constraints

- CZ-only integration — does not run for RO or MD (ARCH0001 §5 row 4).
- The daily poll stamps its last-run marker before performing the fetch and always queries
  "yesterday"; a mid-run failure therefore permanently skips that day with no retry — a silent
  reconciliation gap (ARCH0001 §5 row 4, HS05; UC0008 AF1).
- A credit returned in a currency other than the expected one halts the remainder of that day's
  Moneta import (UC0008).
- Current-state only — describes the integration as implemented today, not a target design.
