---
doc_id: QUERY0010
title: Costs / Targets & Report Snapshot
layer: QUERY
spec_type: query-spec
status: imported
modules: []
query_type: summary
references:
  - EN0031
  - EN0032
  - EN0004
  - UC0017
  - FN0020
  - ARCH0012
---

# QUERY0010 – Náklady / cíle a snímek reportu

## Účel

Dva související back-office read-modely pro plánování a trendový reporting:

1. **Náklady / cíle** ("Naklady") — ručně i cronem udržovaný měsíční záznam nákladů,
   cílů, počtu/hodnoty publikovaných příběhů, cílové hodnoty darů a čísel "Obědy školákům",
   zobrazovaný manažerům.
2. **Snímek reportu** — periodické časové snímky reportovacích metrik (`report_id`,
   `field_name`, `field_value`, `created`) umožňující historické/trendové srovnání dashboardů.

Evidence: `config/views.view.naklady.yml` (base `costs_entity`),
`web/modules/custom/reports/src/Entity/CostsEntity.php`,
`web/modules/custom/reports/src/Entity/SnapshotEntity.php`.

## Konzumenti

- administrator, manager (výpis naklady; oprávnění k zobrazení/editaci costs entity).
- Reportovací dashboardy, které čtou historii snímků (QUERY0009).

## Zdrojové entity

- EN0031 – CostsSnapshot (entita `costs_entity`; pole vč. `year`, `month`, `cost`, `costs_target`, `campaigns_target`, `campaigns_target_value`, `donations_target_value`, `published_campaign_count`, `published_campaign_price`, `obedyskolakum_students`, `obedyskolakum_amount`)
- EN0032 – ReportSnapshot (entita `snapshot_entity`; `report_id`, `field_name`, `field_value`, `created`, `user_id`)
- EN0004 – Campaign (vstupy počtu/ceny publikovaných příběhů)

## Filtry a seskupení

| Filtr / seskupení | Význam | Poznámky |
|---|---|---|
| naklady: žádný (celý výpis) | Všechny řádky nákladů | Výpis podmíněný rolí, 200/stránka. Confirmed. |
| vyhledání snímku: `report_id` + `created BETWEEN begin,end` | Získání hodnot metriky za den/rozsah | Entity query v `SnapshotEntity::...`. Confirmed. |

## Odvozené výstupy

| Výstup | Význam | Poznámky |
|---|---|---|
| sloupce nákladů / cílů | Měsíční náklady vs. cíle, publikované příběhy (počet a hodnota), cílová hodnota darů | Vlastní EN0031. Confirmed. |
| čísla Obědy školákům | Počet žáků a uhrazená částka pro školní obědy | Vlastní EN0031. Confirmed. |
| hodnota snímku | Jedna zaznamenaná hodnota reportovací metriky v daném čase | Vlastní EN0032. Confirmed. |

## Tvar výsledku

- naklady: stránkovaná back-office tabulka s operacemi na řádcích.
- snapshot: klíčované vyhledání vracející uložené hodnoty metrik pro trendové grafy.

## Odkazy

- UC: UC0017 (Export Reporting Data)
- FN: FN0020 (Reporting Read-Model & CSV Export)
- EN: EN0031, EN0032, EN0004
- ARCH: ARCH0012 (Platform, Search & Operations)

## Otevřené body

- Zda jsou řádky nákladů zcela manuální, částečně dopočítávané cronem (publikované počty/hodnoty),
  nebo obojí, není z výpisu samotného plně evidováno; ověřit vůči formuláři nákladů / cron writeru. Partial.
- Kadence zaznamenávání snímků (která úloha snímky zapisuje a kdy) je záležitost vrstvy JOB, zde se
  neopakuje; ověřit křížovým odkazem během closure.
