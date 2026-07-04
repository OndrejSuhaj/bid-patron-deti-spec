---
doc_id: FN0002
title: Application Status Orchestration & Reaction Fan-out
canonical_layer: FN
spec_type: functional-capability
status: canonical
modules: []
references:
  - UC0002
  - UC0004
  - UC0011
  - UC0019
  - EN0001
  - EN0025
  - EN0026
  - EN0003
  - EN0004
---

# FN0002 – Orchestrace stavů žádosti a distribuce reakcí (Reaction Fan-out)

## Účel

Poskytnout jednotné místo, přes které prochází každá změna stavu žádosti (Application, EN0001), a při každé
takové změně konzistentně spouštět nakonfigurované navazující reakce — auditní logování, notifikace v účtu/zóně,
životní cyklus session, přepočet rizika a vedlejší efekty na dokumenty/vyhledávání — bez ohledu na to, zda změna
vzešla od člověka, pravidla, nebo systémové logiky. Jedná se o orchestrační páteř životního cyklu případu popsaného
v UC0002.

## Odpovědnosti

- Aplikovat nový stav na žádost (Application, EN0001), zaznamenat záznam historie stavů / auditní záznam
  (ApplicationLog, EN0025) a vytvořit novou revizi.
- Porovnat nový stav (a roli) s nakonfigurovanými pravidly reakcí (ApplicationReaction, EN0026) a distribuovat
  výsledné záznamy do logu, vytváření session a spouštění notifikací.
- Vytvářet a hromadně deaktivovat session vázané na roli (ApplicationSession, EN0003) podle daného stavu.
- Spouštět transakční notifikace řízené stavem, generování dokumentů a přepočet rizika tam, kde to daný stav
  vyžaduje.
- Zařadit případ do fronty pro reindexaci ve vyhledávání a udržovat stav navázaného příběhu/kampaně v synchronizaci.

## Související případy užití

UC0002 (primární); využívají ho UC0004 (podpis smlouvy řídí stav), UC0011 (synchronizace stavu kampaně), UC0019
(uložení přílohy znovu vstupuje do orchestrace, přestože se změnila pouze příloha).

## Související entity

EN0001 (předmět), EN0025 (auditní záznamy), EN0026 (konfigurace reakcí), EN0003 (session), EN0004 (navázaný
příběh/kampaň udržovaný v synchronizaci stavu).

## Integrace

Žádné (navazující efekty na notifikace/vyhledávání/dokumenty se dostávají k externím systémům pouze
prostřednictvím vlastních capabilities).

## Omezení

- V současnosti realizováno jako vedlejší efekt uložení entity, nikoli jako plnohodnotná služba: každé uložení
  vyvolá událost a synchronně, v rámci téhož requestu, distribuuje reakce — bez kontroly na skutečnou změnu stavu
  a bez idempotence — i neměnné opětovné uložení znovu zaloguje a může znovu odeslat notifikaci.
- Distribuce reakcí není transakční: selhání uprostřed sekvence může ponechat případ ve stavu, kdy část reakcí
  proběhla a část ne.
- Součástí této capability není žádné serverové vynucení legality přechodu při samotné změně stavu.
