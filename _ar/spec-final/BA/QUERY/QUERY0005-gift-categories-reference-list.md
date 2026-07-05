---
doc_id: QUERY0005
title: Gift Categories Reference List
layer: QUERY
spec_type: query-spec
status: imported
modules: []
query_type: list
references:
  - EN0033
  - UC0023
  - FN0026
  - ARCH0005
---

# QUERY0005 – Referenční seznam kategorií darů

## Účel

Referenční read-model zobrazující taxonomii kategorií darů, která se používá pro kategorizaci
příběhů a pro pohon facetu kategorie v katalogu příběhů. Poskytuje vybíratelnou množinu publikovaných
podřízených (nekořenových) kategorií.

Evidence: `config/views.view.gift_categories.yml` (základ `taxonomy_term_field_data`, slovník
`category`; dále `entity_reference` display používaný jako zdroj pro výběr referencí).

## Konzumenti

- Facet kategorie v katalogu příběhů (viz QUERY0003).
- Widgety pro výběr entity-reference, které vybírají kategorii daru.

## Zdrojové entity

- EN0033 – GiftCategory (taxonomy term ve slovníku `category`)

## Filtry a seskupení

| Filtr / seskupení | Význam | Poznámky |
|---|---|---|
| `vid = category` | Pouze slovník kategorií darů | Confirmed. |
| `parent_target_id > 0` | Pouze podřízené termy (vylučuje kořenovou/nejvyšší úroveň) | Confirmed. |
| `status = 1` | Pouze publikované termy | Confirmed. |
| access: `access content` | Veřejné čtení | Confirmed. |

## Odvozené výstupy

| Výstup | Význam | Poznámky |
|---|---|---|
| `name` | Zobrazovaný název kategorie | Confirmed. |
| entity-reference match | Id termu + název pro zobrazení při výběru referencí | `entity_reference` display. Confirmed. |

## Tvar výsledku

- Malý stránkovaný seznam (10/stránka) názvů kategorií; entity-reference display vrací dvojice id/name.

## Odkazy

- UC: UC0023 (Browse / Filter Story Catalogue)
- FN: FN0026 (Reference Data Lookup)
- EN: EN0033
- ARCH: ARCH0005 (Campaign & Story Domain)

## Otevřené otázky

- Lokalizace/rozsah slovníku kategorií podle země není v tomto view evidován; předpokládá se
  obsah slovníku specifický pro daný web (per-site). Partial.
