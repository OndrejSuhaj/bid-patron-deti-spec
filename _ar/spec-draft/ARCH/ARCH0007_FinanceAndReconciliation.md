---
doc_id: ARCH0007
title: Finance & Reconciliation Domain
canonical_layer: ARCH
spec_type: architecture
status: draft
references:
  - ARCH0001
  - ARCH0002
  - EN0029
  - EN0030
  - EN0031
  - EN0032
  - UC0008
  - UC0017
  - FN0012
  - FN0020
  - ES0004
  - ES0005
  - BR-BankReconciliationAndMatching
  - BR-ReportingAndDataAccess
  - BR-MultiTenantCountryScoping
---

# ARCH0007 – Finance & Reconciliation Domain

> Domain navigation document for bounded context **C5 Finance & Reconciliation** (ARCH0001 §4).
> Navigation layer only — links deeper artifacts by `doc_id`, does not restate them. Current-state.

## Purpose

Explains the architectural perspective of the **back-office money reconciliation and reporting** side:
how bank and gateway credits are matched against transactions and booked, and how the reporting
read-model and CSV exports are produced. It is the batch/back-office counterpart to the request-driven
money hub (C4).

---

## System Overview

C5 runs cron/CLI-driven reconciliation from three CZ sources (bank AISP poll, bank-notification email
import, and gateway settlement sync), each of which can create or mark transactions PAID that then
re-enter the C4 money hub ([ARCH0001](../ARCH0001_ApplicationOverview.md) §5, §7; ARCH0002 §(b)). It
also owns the reporting read-model and the daily CSV export batch. The context is **CZ-only** (it does
not run RO/MD), and each reconciliation leg is fragile in a distinct way (silent skipped day, drift on
a fixed HTML parse, row-capped settlement matching — ARCH0001 §5). The CSV export writes unencrypted
PII to local temp files with no country scoping (ARCH0001 §8 Risk 4).

---

## Structural Components

- **Bank-Reconciliation + Reconciliation-Processor** (Domain service + Async processor) — matching and
  booking across the three CZ sources. Capability:
  [FN0012](../FN/FN0012_BankGatewayReconciliation.md).
- **Reporting-ReadModel + CSV-Export-Processor** (Domain service + Async processor) — dashboards and
  the daily CSV batch. Capability: [FN0020](../FN/FN0020_ReportingCsvExport.md).
- **Reconciliation-source adapters** (Integration adapters) — the bank AISP feed, the bank-notification
  inbox, and the gateway settlement sync (the third is the settlement mode of the CZ gateway ES).
- **Resident aggregates / read-models** — AG12 BankTransactionMail
  ([EN0029](../EN/EN0029_BankTransactionMail.md), aviz import audit), AG13 ComgateBankReconciliation
  ([EN0030](../EN/EN0030_ComgateBankReconciliation.md), settlement record); read-models CostsSnapshot
  ([EN0031](../EN/EN0031_CostsSnapshot.md)) and ReportSnapshot ([EN0032](../EN/EN0032_ReportSnapshot.md)).

---

## Interaction Model

Per [ARCH0002](../ARCH0002_ContextInteractionMap.md) §(b):

- Cron/CLI pulls from external CZ sources: the bank AISP feed ([ES0004](../ES/ES0004_Moneta.md)) and
  the client bank-notification inbox ([ES0005](../ES/ES0005_ImapBankNotificationInbox.md)); the third
  source is the settlement mode of the CZ gateway ES (ES0001) — all feeding
  [UC0008](../UC/UC0008_ReconcileBankTransactions.md).
- Reconciliation-produced paid records flow into **C4** (money hub) and thereby into **C3** campaign
  completion — the same PAID cascade (ARCH0002 chain A).
- Reporting reads across many domains' entities (transactions, applications, profiles, contacts,
  campaigns, contracts) to build the CSV batch ([UC0017](../UC/UC0017_ExportReportingData.md)); it is
  read-only and mutates no domain state.
- The CSV export sink is the local filesystem, not an external system.

---

## Cross-links

- **relatedEN:** EN0029, EN0030, EN0031, EN0032
- **relatedUC:** UC0008, UC0017
- **relatedFN:** FN0012, FN0020
- **relatedES:** ES0004 (Moneta), ES0005 (IMAP bank-notification inbox); the gateway settlement mode is ES0001 (owned by C4)
- **relatedMSG:** (none — reconciliation-produced PAID reuses C4's donation messages)
- **relatedBR:** BR-BankReconciliationAndMatching
  ([../BR/BR-BankReconciliationAndMatching.md](../BR/BR-BankReconciliationAndMatching.md)),
  BR-ReportingAndDataAccess ([../BR/BR-ReportingAndDataAccess.md](../BR/BR-ReportingAndDataAccess.md)),
  BR-MultiTenantCountryScoping ([../BR/BR-MultiTenantCountryScoping.md](../BR/BR-MultiTenantCountryScoping.md))
