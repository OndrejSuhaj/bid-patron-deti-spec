---
doc_id: QUERY0007
title: Admin Story List
layer: QUERY
spec_type: query-spec
status: imported
modules: []
query_type: list
references:
  - EN0004
  - EN0001
  - EN0005
  - UC0011
  - FN0006
  - ARCH0005
---

# QUERY0007 – Administrátorský seznam příběhů

## Účel

Back-office seznam příběhů ("Seznam příběhů" / Stories) pro obsahové a koordinační pracovníky:
stav, kategorie, cena daru, vybraná částka, celková částka na bankovním účtu, termín, patron, region,
data dokončení. Jde o obdobu veřejného katalogu (QUERY0003) určenou pro správu příběhů.

Evidence: `config/views.view.view_campaign.yml` (základ `campaign`; stránka `admin/campaign`).

## Konzumenti

- content_admin, coordinator, manager, marketing (řízeno rolí zobrazení).

## Zdrojové entity

- EN0004 – Příběh (Campaign) (základní řádek; `campaign_status`, `gift_category`, `gift_price`, `campaign_raised`, `campaign_deadline`, `kraj`, `completed`, `published`, `uncompleted`)
- EN0001 – Žádost (Application) (odkaz na lead, datum vytvoření leadu)
- EN0005 – Patron (sloupec patron)

## Filtry a seskupování

| Filtr / seskupování | Význam | Poznámky |
|---|---|---|
| `campaign_status` (exposed) | Filtrování podle stavu příběhu | Slovník je vlastněn EN/STAT. Confirmed. |
| `id`, `application`, `status`, `name`, `kraj`, `lead_text` (exposed) | ID příběhu, propojená žádost, stav publikace, fulltextové vyhledávání v názvu, region, text leadu | Podle zobrazení. Confirmed. |
| access: sada rolí uvedená výše | Pouze back-office | Confirmed. |

## Odvozené výstupy

| Výstup | Význam | Poznámky |
|---|---|---|
| `campaign_raised` | Vybraná částka pro příběh | Persistované pole, udržované metodou `CampaignEntity::updateCampaignRaisedMoney()` (viz Otevřené otázky). Confirmed. |
| `bank_views_field` | Částka přijatá na bankovním účtu pro příběh | Vypočítané views pole (`getCampaignReceivedMoney`: `is_sent_to_bank=1 AND ext_status=PAID`). Confirmed. |
| views pole lead / patron / datum vytvoření leadu | Projekce z jiných entit | Vypočítaná views pole. Confirmed. |
| `gift_price`, `gift_category`, `kraj`, `campaign_deadline`, `completed`, `published`, `uncompleted` | Atributy příběhu | Vlastněno EN0004; zobrazeno jako sloupce. Confirmed. |
| operace | Řádkové akce (vč. set-active, doplacení zbývající částky) | Confirmed. |

## Tvar výsledku

- Stránkovaná back-office tabulka (25 na stránku), exposed filtry.

## Odkazy

- UC: UC0011 (Správa příběhu / Lifecycle příběhu)
- FN: FN0006 (Lifecycle příběhu)
- EN: EN0004, EN0001, EN0005
- ARCH: ARCH0005 (Doména příběhu)

## Otevřené otázky

- **Riziko (dvojí definice "vybraného"):** seznam čte persistované pole `campaign_raised`,
  zatímco jiné cesty čtení přepočítávají `SUM(price) WHERE ext_status=PAID` na vyžádání (QUERY0001,
  QUERY0003, QUERY0010). Persistovaná hodnota je aktuální pouze k poslednímu běhu
  `updateCampaignRaisedMoney()`; zastaralé řádky mohou zobrazovat jiný celkový součet než reporty.
  Poznatek pro vlastnictví v BR/FN0006.
- Větev výpočtu vybrané částky s příznakem covid19 sčítá dary přes všechny příznakem označené
  příběhy, nikoli jeden příběh — relevantní pouze pro tento speciální účet. Partial.
