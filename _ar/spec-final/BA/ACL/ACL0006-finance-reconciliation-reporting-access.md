---
doc_id: ACL0006
title: Finance, Reconciliation & Reporting Access
layer: ACL
spec_type: access-control
status: imported
modules: []
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

# ACL0006 – Přístup k financím, párování plateb a reportingu

## Účel

Přístup k finančním zdrojům / zdrojům pro párování plateb — BankTransactionMail (EN0029),
ComgateBankReconciliation / TransactionComgateToBank (EN0030), Costs snapshot (EN0031), Report
snapshot (EN0032) — a k reportingovým dashboardům a exportnímu rozhraní CSV. Model aktérů je
vlastněn ACL0001.

## Model aktérů

- Reporting je podmíněn třemi oprávněními: `access reports`, `access accounting reports`,
  `access productivity reports`. Role: `manager` (všechna tři), `accountant` (pouze účetní),
  `marketing`/`risk_manager`/`senior_coordinator` (reports/productivity), `coordinator` (productivity),
  `content_admin` (žádné z těchto tří).
- **Formuláře** pro párování plateb jsou podmíněny oprávněním `edit campaign entities` (volně
  navázané oprávnění — viz Výjimky).
- Celý rozsah reportingu/exportu je `global`; **žádný filtr CZ/RO/MD** (ACL0001 G-03).

Evidence: `config/user.role.*.yml`; routing `reports/reports.routing.yml`,
`accounting/accounting.routing.yml`, `export_csv/export_csv.routing.yml`,
`bank_integration/bank_integration.routing.yml`; definice oprávnění `reports/reports.permissions.yml`,
`accounting/accounting.permissions.yml`, `export_csv/export_csv.permissions.yml`.

## Zdroje

- Reportingové dashboardy (`/admin/reports/*`) — platby, kampaně, leady, účetnictví, produktivita, dashboard
- CSV exporty (`/admin/export_csv/*`) — platby, leady, fundraiseři, dárci (supporters), patroni, kampaně, poukazy, účetnictví, smlouvy, blacklist, low-risk, scoring-ko
- Formuláře pro párování plateb v účetnictví (`/admin/accounting/*`) — ComGate→banka, bankovní formulář, bankovní synchronizace
- TransactionComgateToBank / TransactionBank (EN0030) — CRUD + přehled
- BankTransactionMail (EN0029) — CRUD (zobrazení publikovaných/nepublikovaných)
- Costs snapshot (EN0031), Report snapshot (EN0032) — CRUD
- Konfigurace bankovní integrace (číslo účtu)

## Matice

| Aktér / role | Zdroj | Akce | Rozsah | Poznámky |
|---|---|---|---|---|
| `manager` | Reportingové dashboardy | přístup (reports, accounting, productivity) | global | `access reports` + `access accounting reports` + `access productivity reports`. |
| `manager` | Costs snapshot (EN0031) | přidání, úprava, smazání, zobrazení | global | `add/edit/delete costs entity entities`, `view published costs entity entities`. |
| `accountant` | Účetní reporty | přístup | global | pouze `access accounting reports`. |
| `accountant` | Export účetnictví | stažení | global | `/admin/export_csv/export-accounting` vyžaduje `access accounting reports`. |
| `marketing` | Reporty + produktivita | přístup | global | `access reports` + `access productivity reports`. |
| `risk_manager` | Reporty + produktivita | přístup | global | `access reports` + `access productivity reports`. |
| `senior_coordinator` | Reporty + produktivita | přístup | global | `access reports` + `access productivity reports`. |
| `coordinator` | Reporty produktivity | přístup | global | pouze `access productivity reports`. |
| role s `access reports` | CSV export (platby, kampaně, patroni, dárci, fundraiseři, poukazy, smlouvy, blacklist, low-risk, scoring-ko, report-patroni) | stažení | global (**žádný filtr země**) | Exportní routy jsou podmíněny pouze `access reports` (ACL0001 G-03). Evidence: `export_csv/export_csv.routing.yml`. |
| role s `export leads` (`coordinator`,`senior_coordinator`,`front`,`manager`,`marketing`) | CSV export leadů | stažení | global (**žádný filtr země**) | `/admin/export_csv/export-leads` vyžaduje `export leads`. |
| role s `edit campaign entities` (`content_admin`,`front`,`manager`,`marketing`) | Formuláře pro párování plateb | spuštění ComGate→banka / bankovní formulář / bankovní sync | global | Routy `accounting.*_form` vyžadují `edit campaign entities` (nesouladné oprávnění — viz Výjimky). |
| role s `access accounting reports` | Report párování plateb v účetnictví | zobrazení | global | `/admin/accounting/report/*` vyžaduje `access accounting reports`. |
| role s `administer site configuration` | Konfigurace bankovní integrace | nastavení čísla účtu | platform | `/admin/config/bank-integration/*` vyžaduje `administer site configuration` (pouze `administrator`). |
| `content_admin` | BankTransactionMail (EN0029) | zobrazení publikovaných/nepublikovaných | global | `view (un)published transaction mails entities`. |

## Výjimky

- **Nesouladné oprávnění pro finance:** formuláře pro párování plateb `comgate_to_bank_form`,
  `bank_form` a `bank_synchronization_form` vyžadují `edit campaign entities` namísto
  účetního/finančního oprávnění. Jakákoli role, která může editovat kampaně (content_admin, front,
  manager, marketing), tak může spustit bankovní synchronizaci. Zaznamenáno jako anomálie současného
  stavu (`Confirmed`). Evidence: `accounting/accounting.routing.yml:7,16,24`.
- **Žádné omezení podle země/tenantu u žádného exportu ani reportu** (ACL0001 G-03). Pravidlo je
  vlastněno BR-MultiTenantCountryScoping / BR-ReportingAndDataAccess.
- Submit cesty formulářů pro párování plateb používají raw-SQL / přímý přístup do DB
  (`accounting/src/Form/*`, `accounting/src/Controller/bankToCrmController.php`); jde o záležitost
  zápisu dat vlastněnou BR-BankReconciliationAndMatching, zde je zaznamenána pouze jako autorizační
  rozhraní.

## Odkazy

- UC: UC0008 (párování bankovních transakcí), UC0017 (export reportingových dat)
- FN: FN0012 (párování banka/platební brána), FN0020 (reportingový CSV export)
- EN: EN0029 (BankTransactionMail), EN0030 (ComgateBankReconciliation), EN0031 (CostsSnapshot), EN0032 (ReportSnapshot)
- ES: ES0005 (IMAP inbox pro bankovní notifikace)
- BR: BR-BankReconciliationAndMatching, BR-ReportingAndDataAccess, BR-MultiTenantCountryScoping
- ARCH: ARCH0007 (Finance a párování plateb)

## Otevřené body

- Zda je oprávnění `edit campaign entities` u bankovních formulářů záměrné nebo jde o pozůstatek
  legacy řešení, nelze ze zdrojů ověřit; zaznamenáno jako anomálie pro review při rebuildu.
