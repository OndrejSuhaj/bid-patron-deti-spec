---
doc_id: QUERY0009
title: On-Screen Reporting Dashboards & Reports
layer: QUERY
spec_type: query-spec
status: imported
modules: []
query_type: dashboard
references:
  - EN0009
  - EN0001
  - EN0004
  - EN0025
  - EN0008
  - UC0017
  - FN0020
  - ARCH0006
  - ARCH0012
---

# QUERY0009 – Reportovací dashboardy a reporty na obrazovce

## Účel

Back-office reportovací obrazovky vykreslované jako HTML tabulky/grafy modulem `reports`: dashboard
darů, měsíční/roční souhrny transakcí, kampaňové reporty (podle koordinátora, podle dnů), report
žádostí/leadů, produktivitní reporty a účetní report (uhrazené kampaně). Jde o vypočítané read-modely,
nikoli o výpisy entit.

Evidence: `web/modules/custom/reports/src/Controller/` — `DashboardController`,
`TransactionsReportsController`, `CampaignsReportsController`, `ApplicationsReportsController`,
`ProductivityReportsController`, `CurrentProductivityReportsController`, `MonthlyReportController`,
`AccountingReportsController`; routy v `reports.routing.yml`.

## Konzumenti

- Zaměstnanci s oprávněním `access reports`; účetní report vyžaduje `access accounting reports`;
  produktivitní report vyžaduje `access productivity reports`.

## Zdrojové entity

- EN0009 – Transaction (součty darů, dashboard, měsíční report, kampaně, účetnictví)
- EN0001 – Application (počty žádostí/leadů, produktivita)
- EN0004 – Campaign (kampaňové reporty, produktivita, spojení s účetnictvím)
- EN0025 – ApplicationLog (produktivita: časování změn stavu)
- EN0008 – User (dimenze koordinátora)

## Filtry a seskupení

| Report (route) | Seskupení / filtr | Poznámky |
|---|---|---|
| Dashboard (`admin/reports/dashboard`) | Uhrazené transakce podle dne v týdnu; heatmapa den v týdnu × hodina; počty | `ext_status LIKE 'PAID'`. Confirmed. |
| Transactions/Payments (`admin/reports/payments`) | Uhrazené dary podle roku a roku×měsíce: počet, součet, průměr | `ext_status=PAID AND is_donation=1`, GROUP BY year(,month). Plus souhrnné skalární hodnoty. Confirmed. |
| Campaigns (`admin/reports/campaigns/{begin}/{end}`, `/{uid}`, campaigns-by-days) | Příběhy publikované v měsíčním rozsahu, volitelně podle koordinátora nebo podle dne | `published BETWEEN :begin AND :end`. Confirmed. |
| Applications/Leads (`admin/reports/leads`) | Počty žádostí podle roku/měsíce s vyloučením stavů `mistake`/`duplicate` | `state NOT LIKE 'mistake'/'duplicate'`. Confirmed. |
| Monthly (`admin/reports/monthly-report`) | Měsíční/roční součty žádostí + aktivních příběhů + darů | Rozlišuje zemi (viz Otevřené body). Confirmed. |
| Productivity (`admin/reports/productivity`, cord-applications) | Publikované příběhy, součty cílových částek a průchodnost žádostí po týdnech za jednotlivé koordinátory | Confirmed. |
| Accounting (`admin/reports/accounting`) | Uhrazená částka za příběh za bankovní měsíc | `ext_status=PAID`, GROUP BY campaign, bank_month. Confirmed. |

## Odvozené výstupy

| Výstup | Význam | Poznámky |
|---|---|---|
| součet / počet / průměr daru | Agregované metriky uhrazených darů | `SUM(price)`, `COUNT(*)`, `SUM/COUNT`. Confirmed. |
| souhrnné skalární hodnoty (report Transactions) | Podpořené příběhy, celkem darováno, dárci, unikátní dárci, „balance“ | Raw SQL s `transparent=1 AND test=0 AND ext_status=PAID`; „balance“ pevně odkazuje na `campaign = 3100`. Confirmed. |
| průchodnost příběhů/koordinátorů | Počty publikovaných příběhů, součty cílových částek za koordinátora/den/týden | Confirmed. |
| počty žádostí | Podle období, s vyloučením mistake/duplicate | Confirmed. |
| účetní řádky | `[campaign_id, paid_sum, bank_month]` | Confirmed. |

## Tvar výsledku

- Vykreslené HTML tabulky a data pro grafy (Twig `dashboard.html.twig` / `reports.html.twig`); u
  některých je k dispozici doprovodný CSV export (viz QUERY0011).

## Odkazy

- UC: UC0017 (Export Reporting Data — zobrazení na obrazovce + export společně)
- FN: FN0020 (Reporting Read-Model & CSV Export)
- EN: EN0009, EN0001, EN0004, EN0025, EN0008
- ARCH: ARCH0006 (Donations & Payments), ARCH0012 (Platform, Search & Operations)

## Otevřené body

- **Riziko (raw SQL, magické konstanty, bez filtru tenanta):** reporty jsou postaveny na ad-hoc
  řetězcích raw SQL (`$this->database->query("...")`); několik z nich pevně odkazuje na konkrétní id
  příběhu (`campaign = 3100` pro skalární hodnotu „balance“; `campaign <> 2200`/`id <> 2200` chráněné
  podmínkou `Settings::get('country') == 'cz'` v MonthlyReport). Čísla jsou globální — mimo tyto
  konstanty chybí filtr podle země/tenanta. Observation.
- **Riziko (LIKE pro porovnání stavu):** filtry stavů používají `LIKE`/`NOT LIKE` na řetězcích stavu
  (např. `state NOT LIKE 'mistake'`, `ext_status LIKE 'PAID'`), což je porovnání na podřetězec, nikoli
  přesná rovnost; stav, jehož název obsahuje jiný jako podřetězec, by mohl být chybně započítán.
  Zamýšlenou přesnost je třeba potvrdit. `Conflict — requires clarification.`
- Přesné vzorce metrik pro týdenní agregaci produktivity jsou rozsáhlé; zde je zachycen pouze jejich
  tvar — detailní aritmetiku jednotlivých metrik považovat za `Uncertain`, dokud nebude jednotlivě
  ověřena.
