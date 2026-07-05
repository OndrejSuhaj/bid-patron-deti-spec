---
doc_id: ACL0006
title: Finance, Reconciliation & Reporting Access
canonical_layer: ACL
spec_type: access-control
status: draft
references:
  - EN0029
  - EN0030
  - EN0031
  - EN0032
  - UC0008
  - UC0017
  - FN0012
  - FN0020
  - BR-BankReconciliationAndMatching
  - BR-ReportingAndDataAccess
  - BR-MultiTenantCountryScoping
  - ARCH0007
---

# ACL0006 – Finance, Reconciliation & Reporting Access

## Purpose

Access to finance/reconciliation resources — BankTransactionMail (EN0029),
ComgateBankReconciliation / TransactionComgateToBank (EN0030), Costs snapshot (EN0031), Report
snapshot (EN0032) — plus the reporting dashboards and CSV export surface. Actor model owned by
ACL0001.

## Actor Model

- Reporting is gated by three permissions: `access reports`, `access accounting reports`,
  `access productivity reports`. Roles: `manager` (all three), `accountant` (accounting only),
  `marketing`/`risk_manager`/`senior_coordinator` (reports/productivity), `coordinator` (productivity),
  `content_admin` (none of the three).
- Bank reconciliation **forms** are gated by `edit campaign entities` (a loosely-matched permission —
  see Exceptions).
- All reporting/export scope is `global`; **no CZ/RO/MD filter** (ACL0001 G-03).

Evidence: `config/user.role.*.yml`; routing `reports/reports.routing.yml`,
`accounting/accounting.routing.yml`, `export_csv/export_csv.routing.yml`,
`bank_integration/bank_integration.routing.yml`; permission defs `reports/reports.permissions.yml`,
`accounting/accounting.permissions.yml`, `export_csv/export_csv.permissions.yml`.

## Resources

- Reports dashboards (`/admin/reports/*`) — payments, campaigns, leads, accounting, productivity, dashboard
- CSV exports (`/admin/export_csv/*`) — payments, leads, fundraisers, supporters, patrons, campaigns, vouchers, accounting, contracts, blacklist, low-risk, scoring-ko
- Accounting reconciliation forms (`/admin/accounting/*`) — ComGate→bank, bank form, bank synchronization
- TransactionComgateToBank / TransactionBank (EN0030) — CRUD + overview
- BankTransactionMail (EN0029) — CRUD (view published/unpublished)
- Costs snapshot (EN0031), Report snapshot (EN0032) — CRUD
- Bank integration config (account number)

## Matrix

| Actor / Role | Resource | Action | Scope | Notes |
|---|---|---|---|---|
| `manager` | Reports dashboards | access (reports, accounting, productivity) | global | `access reports` + `access accounting reports` + `access productivity reports`. |
| `manager` | Costs snapshot (EN0031) | add, edit, delete, view | global | `add/edit/delete costs entity entities`, `view published costs entity entities`. |
| `accountant` | Accounting reports | access | global | `access accounting reports` only. |
| `accountant` | Accounting export | download | global | `/admin/export_csv/export-accounting` requires `access accounting reports`. |
| `marketing` | Reports + productivity | access | global | `access reports` + `access productivity reports`. |
| `risk_manager` | Reports + productivity | access | global | `access reports` + `access productivity reports`. |
| `senior_coordinator` | Reports + productivity | access | global | `access reports` + `access productivity reports`. |
| `coordinator` | Productivity reports | access | global | `access productivity reports` only. |
| roles with `access reports` | CSV export (payments, campaigns, patrons, supporters, fundraisers, vouchers, contracts, blacklist, low-risk, scoring-ko, report-patroni) | download | global (**no country filter**) | Export routes gated only by `access reports` (ACL0001 G-03). Evidence: `export_csv/export_csv.routing.yml`. |
| roles with `export leads` (`coordinator`,`senior_coordinator`,`front`,`manager`,`marketing`) | CSV export leads | download | global (**no country filter**) | `/admin/export_csv/export-leads` requires `export leads`. |
| roles with `edit campaign entities` (`content_admin`,`front`,`manager`,`marketing`) | Bank reconciliation forms | run ComGate→bank / bank form / bank sync | global | Routes `accounting.*_form` require `edit campaign entities` (mismatched gate — see Exceptions). |
| roles with `access accounting reports` | Accounting reconciliation report | view | global | `/admin/accounting/report/*` requires `access accounting reports`. |
| roles with `administer site configuration` | Bank integration config | set account number | platform | `/admin/config/bank-integration/*` requires `administer site configuration` (only `administrator`). |
| `content_admin` | BankTransactionMail (EN0029) | view published/unpublished | global | `view (un)published transaction mails entities`. |

## Exceptions

- **Mismatched finance gate:** the bank-reconciliation forms `comgate_to_bank_form`, `bank_form`, and
  `bank_synchronization_form` require `edit campaign entities` rather than an accounting/finance
  permission. Any role that can edit campaigns (content_admin, front, manager, marketing) can run bank
  synchronization. Recorded as a current-state anomaly (`Confirmed`). Evidence:
  `accounting/accounting.routing.yml:7,16,24`.
- **No country/tenant scoping on any export or report** (ACL0001 G-03). Rule owned by
  BR-MultiTenantCountryScoping / BR-ReportingAndDataAccess.
- Bank reconciliation form submit paths use raw-SQL / direct DB access (`accounting/src/Form/*`,
  `accounting/src/Controller/bankToCrmController.php`); this is a data-write concern owned by
  BR-BankReconciliationAndMatching, noted here only as the authorization surface.

## References

- UC: UC0008 (reconcile bank transactions), UC0017 (export reporting data)
- FN: FN0012 (bank/gateway reconciliation), FN0020 (reporting CSV export)
- EN: EN0029 (BankTransactionMail), EN0030 (ComgateBankReconciliation), EN0031 (CostsSnapshot), EN0032 (ReportSnapshot)
- ES: ES0005 (IMAP bank notification inbox)
- BR: BR-BankReconciliationAndMatching, BR-ReportingAndDataAccess, BR-MultiTenantCountryScoping
- ARCH: ARCH0007 (Finance and Reconciliation)

## Open Items

- Whether the `edit campaign entities` gate on bank forms is intentional or legacy is not resolvable
  from source; recorded as anomaly for rebuild review.
