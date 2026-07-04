---
doc_id: FN0025
title: Workflow / Transition-Legality Engine & Scheduled Publish
canonical_layer: FN
spec_type: functional-capability
status: canonical
modules: []
references:
  - UC0022
  - UC0011
  - EN0001
  - EN0004
---

# FN0025 – Workflow / mechanismus legality přechodů a plánovaná publikace

## Účel

Poskytnout celoplatformní bránu povolených přechodů / připravenosti, která má řídit, které změny
stavu žádosti (EN0001) a kampaně (EN0004) jsou legální a povolené podle role, a spouštět úlohu
plánované publikace, která má datumově podmíněný obsah protlačit touto bránou do publikovaného
stavu bez lidského aktéra. Toto je kanonické místo pro legality přechodů, na které odkazuje dopředná
reference z FN0002 (Application Status Orchestration & Reaction Fan-out), jež ze svého vlastního
rozsahu explicitně vylučuje serverové vynucování legality přechodů.

## Odpovědnosti

- Držet konfiguraci workflow/přechodů, která definuje povolené stavy a rolí podmíněné přechody pro
  rozsáhlý content-moderation workflow žádosti (EN0001).
- Vyhodnocovat bránu povolených přechodů / připravenosti, kterou procházejí lifecycle akce —
  publikace kampaně a časem podmíněné nesplnění kampaně (UC0011).
- Spouštět tik plánované publikace (`patron_base_cron`), který vybírá nepublikované CMS uzly
  `page`/`page_cz`, jejichž `publish_date` odpovídá dnešnímu dni, a povyšuje je na publikované, plus
  první-příznakovanou výměnu aliasu `/homepage` (UC0022; potvrzeno FLW0033). Tato cesta publikuje
  balíčky CMS uzlů přímo a neprochází bránou legality přechodů.

## Související případy užití

UC0022 (Run Platform Workflow Engine & Scheduled Publish — primární; vlastní dílčí tok plánované
publikace); UC0011 (Manage Campaign / Story Lifecycle — využívá bránu povolených přechodů/
připravenosti pro publikaci kampaně a časem podmíněné nesplnění).

## Související entity

EN0001 (Žádost — předmět konfigurace workflow/přechodů a jejích změn stavu); EN0004 (Kampaň —
kandidát na datumově podmíněný přechod plánované publikace, a předmět brány uplatňované při
publikaci/nesplnění).

## Integrace

Žádné.

## Omezení

- Tok plánované publikace je nyní vytěžen (FLW0033, dříve index toku FL057) — Confirmed. Korekce
  rozsahu: publikuje pouze balíčky CMS uzlů `page`/`page_cz` (nikoli kampaň/blog), pomocí striktního
  výběru na rovnost `publish_date = dnes`, plus volitelnou první-příznakovanou výměnu aliasu
  `/homepage`.
- Výběr na striktní rovnost představuje v současném stavu riziko korektnosti (FLW0033): zmeškaný den
  cronu nebo uzel s datem v minulosti se nikdy automaticky nepublikuje — uzel zůstává nepublikovaný,
  dokud není publikován ručně. Výměna aliasu homepage je neatomická (bez DB transakce) a jakákoliv
  výjimka je znovu vyhozena, čímž se přeruší zbytek běhu cronu `patron_base`.
- Cesta plánované publikace **neprochází** bránou legality přechodů — publikuje uzly přímo.
- Legality přechodů není v aktuálním stavu na živých formulářích pro změnu z velké části **vynucována**:
  změna stavu může dosáhnout kteréhokoliv ze stavů workflow bez jakékoliv serverové kontroly přechodu
  nebo role. Tato brána je tedy z velké části rekonstrukcí cílového tvaru spíše než potvrzeným
  současným chováním. Jde o mezeru v BR/chování v current-state, nikoli o mezeru v evidenci —
  FLW0033 dokládá tok plánované publikace, ale neuzavírá mezeru v nevynucené legalitě.
