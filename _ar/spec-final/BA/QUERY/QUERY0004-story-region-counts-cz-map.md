---
doc_id: QUERY0004
title: Story Region Counts (CZ Map)
canonical_layer: QUERY
spec_type: query-spec
status: canonical
modules: []
query_type: summary
references:
  - EN0004
  - UC0023
  - FN0006
  - ARCH0005
---

# QUERY0004 – Počty příběhů podle regionu (mapa ČR)

## Účel

Read-model za regionální mapou ČR / výběrem regionu na stránce s výpisem příběhů: počet
**aktivních** příběhů v každém regionu (kraji), použitý k popiskům na mapě a k deaktivaci
prázdných regionů.

Evidence: `web/modules/custom/campaign/src/Controller/RenderRegionsController.php`
(route `/campaign/regions/render`).

## Konzumenti

- Veřejné UI výpisu příběhů (mobilní výběr regionu `<select>` a desktopová SVG mapa).

## Zdrojové entity

- EN0004 – Campaign (seskupeno podle `kraj`; `campaign_status`)
- Reference: entita kraj (názvy regionů, načítané přes entity storage pro popisky)

## Filtry a seskupení

| Filtr / seskupení | Význam | Poznámky |
|---|---|---|
| `kraj IS NOT NULL` | Pouze příběhy přiřazené k regionu | Confirmed. |
| `campaign_status = 'active'` | Počítají se pouze aktivní příběhy | Hard-coded. Confirmed. |
| group by `kraj` | Jeden počet pro každý region | Raw SQL `COUNT(*) ... GROUP BY kraj`. Confirmed. |

## Odvozené výstupy

| Výstup | Význam | Poznámky |
|---|---|---|
| popisek regionu | `"<název regionu> (<počet>)"`, přípona "kraj" se doplní, pokud název končí na "ý" | Confirmed. |
| počet podle slugu | Počet aktivních příběhů podle slugu regionu (14 krajů ČR) | Mapa id regionu→slug je hard-coded (1..14). Confirmed. |
| příznak disabled | Volba regionu je deaktivována, pokud je počet 0 | Confirmed. |

## Tvar výsledku

- HTML fragment: `<select>` regionů + vykreslená mapa, počty jsou vloženy do popisků.

## Reference

- UC: UC0023 (Procházení / filtrování katalogu příběhů)
- FN: FN0006 (Životní cyklus kampaně / příběhu)
- EN: EN0004
- ARCH: ARCH0005 (Doména kampaní a příběhů)

## Otevřené otázky

- **Riziko (hard-coded, pouze CZ):** mapa id regionu→slug (1..14) a pravidlo popisku "ý"→" kraj"
  jsou specifické pro CZ a hard-coded; tento read-model není evidován pro tenanty RO/MD. Partial.
- Počet používá přímo `campaign_status = 'active'` a neshoduje se s filtrem stavu v katalogu
  (QUERY0003) — příběh viditelný v jiném stavu se do počtu nezapočítává. Observation.
