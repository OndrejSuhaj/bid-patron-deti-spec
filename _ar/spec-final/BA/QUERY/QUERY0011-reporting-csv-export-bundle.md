---
doc_id: QUERY0011
title: Reporting CSV Export Bundle
layer: QUERY
spec_type: query-spec
status: imported
modules: []
query_type: export
references:
  - EN0001
  - EN0002
  - EN0006
  - EN0004
  - EN0009
  - EN0013
  - EN0011
  - EN0016
  - EN0017
  - EN0005
  - EN0008
  - UC0017
  - FN0020
  - FN0021
  - ARCH0006
  - ARCH0012
---

# QUERY0011 – Sada CSV exportů pro reporting

## Účel

Rozhraní hromadných CSV exportů: ~20 endpointů, které vypisují business data (platby, leady,
fundraiseři, patroni, dárci, kampaně/příběhy, dárkové poukazy, smlouvy, účetnictví, blacklist,
low-risk, scoring-KO, report patroni) jako soubor CSV ke stažení. Sdruženo do jednoho kontraktu,
protože sdílí jeden controller, jeden mechanismus výstupu a jednu sadu systémových rizik.

Evidence: `web/modules/custom/export_csv/src/Controller/ExportCSVController.php` (metody dump*),
`export_csv.routing.yml`, `export_csv.permissions.yml`,
`web/modules/custom/export_csv/src/Controller/DownloadsController.php`,
`web/modules/custom/export_csv/src/ExportCsvCron.php`.

## Konzumenti

- Pracovníci s oprávněním `access reports` (většina exportů), `access accounting reports` (export
  účetnictví), `export leads` (pouze export leadů). Index stažení na `admin/downloads`.

## Zdrojové entity

- EN0001 Application, EN0002 ApplicationProfile, EN0006 Contact, EN0004 Campaign, EN0009 Transaction,
  EN0013 Voucher, EN0011 Contract, EN0016 Blacklist, EN0017 ScoringRecord, EN0005 Patron, EN0008 User.

## Filtry a seskupení

| Export (route) | Obsah / filtr | Poznámky |
|---|---|---|
| export-payments / -original-payments (`.../export-payments`) | Transakce; volitelný filtr `?campaign=`; original = `parent IS NULL` | `is_donation` zobrazeno jako Yes/No. Confirmed. |
| export-gift-payments / -ready-gift-payments | Žádosti ve stavu `gift_paid` / `gift_payment` | přes `application_states`. Confirmed. |
| export-leads (`.../export-leads`) | Úplné řádky lead/příběh vč. PII fundraisera + patrona | oprávnění `export leads`. Confirmed. |
| export-fundraisers / -fundraisers-fulls | Kontaktní řádky fundraiserů | Confirmed. |
| export-patrons / -unique-patrons | Řádky leadů patronů / distinct patroni s počty kampaní | `GROUP BY patron_profile`. Confirmed. |
| export-supporters | E-mail + jméno dárce + `SUM(price)` + `COUNT(*)` | `ext_status=PAID AND test=0`, GROUP BY mail. Confirmed. |
| export-campaigns | Řádky příběhů vč. PII fundraisera + patrona | `app.campaign IS NOT NULL`. Confirmed. |
| export-vouchers | Řádky dárkových poukazů/transakcí vč. e-mailu odesílatele/příjemce | Confirmed. |
| export-accounting | `[campaign_id, SUM(price), bank_month]` | `ext_status=PAID`, GROUP BY campaign, bank_month. Confirmed. |
| export-contracts | Žádosti se smlouvou | `app.contract IS NOT NULL`. Confirmed. |
| export-blacklist | Žádosti, kde scoring JSON obsahuje `fundraiser_blacklist='bl'` NEBO `patron_blacklist='bl'` | `JSON_EXTRACT`. Confirmed. |
| export-lowrisk / -scoring-ko | Žádosti v historii stavů `scoring_ko`/`scoring_ok` / detail scoring-KO | Confirmed. |
| report-patroni | Široká matice aktivity patronů: počty leadů/kampaní za rok a měsíc (2017..2022, hard-coded) | `COUNT(IF(YEAR(...)=YYYY ...))`. Confirmed. |

## Odvozené výstupy

| Výstup | Význam | Poznámky |
|---|---|---|
| PII sloupce | jméno, příjmení, `rc` (rodné číslo), telefon, e-mail, ulice, město, `psc`, zaměstnavatel, povolání, `child_handicapped` | exporty leads/patrons/campaigns/fundraisers. **Citlivé.** Confirmed. |
| agregace | `SUM(price)`, `COUNT(*)`, počty za rok/měsíc | supporters, accounting, patroni. Confirmed. |
| sloupce plateb/vypořádání | `ext_status`, bank_vs/date/month, ext_trans_id, ext_fee | exporty payments/vouchers. Confirmed. |

## Tvar výsledku

- Stažení CSV souboru (`Content-Disposition: attachment`), jeden soubor na endpoint.
- Řádek s hlavičkou je vygenerován jako literální `SELECT '...'` UNION ALL s daty (popisky sloupců
  v řádku 1).

## Reference

- UC: UC0017 (Export Reporting Data)
- FN: FN0020 (Reporting Read-Model & CSV Export), FN0021 (Personal-Data Anonymisation — GDPR context)
- EN: EN0001, EN0002, EN0006, EN0004, EN0009, EN0013, EN0011, EN0016, EN0017, EN0005, EN0008
- ARCH: ARCH0006, ARCH0012

## Otevřené body

- **Riziko (PII v klidu ve sdíleném /tmp):** každý export spouští raw SQL
  `... INTO OUTFILE '/tmp/<name>_<ts>.csv'` a následně jej znovu čte přes `LOAD_FILE`. Vygenerovaný
  soubor (obsahující `rc`/rodné číslo, e-maily, telefony, adresy, `child_handicapped`) se zapisuje do
  všem přístupné cesty `/tmp` na hostu databáze a jeho smazání není zaručeno; konstruktor navíc
  vydává i stejnodenní cachovaný soubor `/tmp/<name>_YYYY_MM_DD.csv`, pokud již existuje. Jde o
  vystavení dat v klidu relevantní z hlediska GDPR. Je třeba potvrdit retenci/úklid.
  `Conflict — requires clarification.`
- **Riziko (raw SQL, bez filtru tenantu):** každý výpis je ručně psaný SQL string s `INTO OUTFILE`;
  žádný neuplatňuje filtr země/tenantu, takže na sdílené databázi by export mohl obsáhnout všechny
  země.
- **Riziko (hard-coded časová okna):** report patroni vypisuje v kódu roky/měsíce 2017–2022; pozdější
  období tiše vynechává. Partial.
- **Riziko (interpolovaný parametr requestu):** `export-payments`/`-lowrisk` sestavují fragment
  `WHERE campaign = <id>` z requestu; hodnota je před konkatenací přetypována na `(int)` (zmíněná
  mitigace), ale tento vzor je fragilní — vyznačit pro rewrite.
- Tajemství/přihlašovací údaje: v těchto dotazech žádné vložené nejsou (`<redacted>` — nic k
  redakci).
