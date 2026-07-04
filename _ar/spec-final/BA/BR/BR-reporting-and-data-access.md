---
doc_id: BR-ReportingAndDataAccess
title: Reporting & Data Access
canonical_layer: BR
spec_type: business-rule
status: canonical
modules: []
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

# BR – Reporting a přístup k datům

## Účel

Upravuje exporty reportů jako čistě čtecí (read-only) funkci a zaznamenává current-state mezery
v ochraně osobních údajů v klidovém stavu (PII-at-rest), v granularitě oprávnění a v retenci, které
se týkají přístupu k datům reportingu.

## Pouze pro čtení a podmíněno oprávněním

- Reporting SHALL být pouze pro čtení — funkcí reportingu SHALL NOT být vytvořen, aktualizován ani
  převeden do jiného stavu žádný záznam případu (`EN0001`), strany (`EN0006`), peněz (`EN0009`),
  příběhu (`EN0004`) ani smlouvy (`EN0011`).
- Export na vyžádání SHALL být poskytnut až poté, co projde kontrola oprávnění pro požadovanou
  kategorii.
- Nejvýše jedna naplánovaná dávka exportu SHALL proběhnout za kalendářní den, přičemž se pro každý
  typ exportu ukládá do mezipaměti jeden soubor; neúspěšné dávkové okno SHALL NOT být opakováno až
  do dalšího okna.

## Zacházení s citlivými daty (current-state)

- Current-state: exportované soubory SHALL být považovány za obsahující nezpracovaná osobní data
  (identifikační čísla, jména, adresy, e-maily, telefony, čísla smluv) bez jakékoli ochrany souboru
  nad rámec kontroly oprávnění provedené v okamžiku požadavku.
- Current-state: dočasné exportní soubory nejsou nikdy uklízeny a SHALL být považovány za
  hromadící se nešifrovaná osobní data v klidovém stavu.
- Current-state: granularita oprávnění SHALL NOT být považována za přiměřenou citlivosti dat —
  některé exporty obsahující identifikační čísla a verdikty risk hodnocení jsou chráněny pouze
  obecným oprávněním pro reporting.

## Co není cílem (Non-Goals)

- Toto pravidlo nedefinuje scoping exportů podle země/tenantu — absence scopingu podle země
  u exportů je v gesci pravidla `BR-MultiTenantCountryScoping`, na které je zde pouze odkazováno,
  nikoli opakováno.
- Toto pravidlo nepopisuje mechaniku načítání a vykreslování dat v reportingovém dashboardu —
  read-model reportingového dashboardu (`EN0031`, `EN0032`) je doložen jako Partial evidence a je
  zde uveden pouze na úrovni capability.
- Toto pravidlo nepředepisuje target-state opravy (šifrování souborů, retenční/úklidové úlohy,
  oprávnění přiměřená citlivosti dat); zaznamenává pouze current-state chování.
