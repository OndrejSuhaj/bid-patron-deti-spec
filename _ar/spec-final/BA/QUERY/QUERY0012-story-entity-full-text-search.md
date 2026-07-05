---
doc_id: QUERY0012
title: Story / Entity Full-Text Search
layer: QUERY
spec_type: query-spec
status: imported
modules: []
query_type: search
references:
  - EN0004
  - EN0001
  - ES0014
  - UC0018
  - FN0022
  - ARCH0012
---

# QUERY0012 – Fulltextové vyhledávání příběhů / entit

## Účel

Read-model pro fulltextové vyhledávání. Indexovaný obsah (příběhy/žádosti a související záznamy) je
synchronizován do externího clusteru Elasticsearch a dotazován front-end vyhledávací aplikací; Drupal
pouze tuto aplikaci mountuje a udržuje index. Jde o read-povrch vyhledávání, odlišný od strukturovaných
katalogových filtrů (QUERY0003).

Evidence: `web/modules/custom/patron_search/src/Plugin/Block/SearchBlock.php` (mountuje externí
vyhledávací UI z `els1.patrondeti.cz` / staging / localhost, pouze pro administrátory),
`web/modules/custom/patron_search/src/Command/EsUploadCommand.php`,
`web/modules/custom/patron_search/src/Plugin/QueueWorker/EsUploadQueue.php`,
`web/modules/custom/patron_search/src/PatronSearchCron.php`.

## Konzumenti

- Back-office uživatelé provádějící vyhledávání (vyhledávací blok se vykresluje pouze pro
  administrátory podle kontroly `isAdmin()`).
- Indexační pipeline (cron a queue worker) jako zápisová strana tohoto read-modelu.

## Zdrojové entity

- EN0004 – Campaign (indexované dokumenty příběhů)
- EN0001 – Application (indexované dokumenty žádostí)
- ES0014 – Elasticsearch (externí indexační / dotazovací engine)

## Filtry a seskupení

| Filtr / seskupení | Význam | Poznámky |
|---|---|---|
| volný textový dotaz | Fulltextová shoda provedená externí ES aplikací | Sémantika dotazu žije v externí aplikaci, ne v Drupalu. Uncertain (mimo zdroje). |
| členství v indexu | Které entity jsou odesílány do ES | Řízeno uploadovacím příkazem / queue workerem (FN0022). Confirmed. |
| publikum | Vyhledávací UI se vykresluje pouze pro administrátory | Kontrola v `SearchBlock::build()`. Confirmed. |

## Odvozené výstupy

| Výstup | Význam | Poznámky |
|---|---|---|
| výsledky vyhledávání | Dokumenty vrácené ES pro daný dotaz | Tvar definovaný externí aplikací; nedoloženo ve zdrojích Patronus. Uncertain. |

## Tvar výsledku

- Interaktivní výsledky vyhledávání vykreslené vloženou externí JS aplikací; Drupal vrací pouze
  mount point a připojené script tagy.

## Odkazy

- UC: UC0018 (Index Entities for Search)
- FN: FN0022 (Search Indexing & Synchronisation)
- EN: EN0004, EN0001
- ES: ES0014 (Elasticsearch)
- ARCH: ARCH0012 (Platform, Search & Operations)

## Otevřené body

- **Sémantika dotazu je mimo analyzované zdroje:** skutečná vyhledávaná pole, řazení dle relevance
  a tvar výsledku jsou implementovány v externí vyhledávací aplikaci (`els1.patrondeti.cz`), která
  není součástí analyzovaného kódu Patronus. Označeno jako `Hypothesis — Not evidenced in current
  sources.` pro cokoliv nad rámec „fulltextového vyhledávání nad indexovanými příběhy/žádostmi".
- Potvrdit, zda je vyhledávací UI v produkci skutečně omezeno jen na administrátory, nebo zda
  existuje i veřejná varianta vyhledávání jinde. `Uncertain`.
