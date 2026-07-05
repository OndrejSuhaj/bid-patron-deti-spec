---
doc_id: BR-OperationalAlerting
title: Operational Alerting & Audit Trail
layer: BR
spec_type: business-rule
status: imported
modules: []
affects:
  - SYSTEM
references:
  - EN0001
  - EN0004
  - UC0020
---

# BR – Provozní alerting a auditní stopa

## Účel

Upravuje provozní alerting a uchovávání auditní stopy jako podpůrný, průřezový vedlejší kanál typu
best-effort vyvolávaný jinými procesy a zaznamenává, že zjištěná desynchronizace mezi žádostí a
příběhem (Application↔Campaign) je pouze nahlášena formou alertu, nikoli opravena.

---

## Alerting

- Loggovatelná provozní podmínka nebo významná business událost vyvolaná jinde v systému MUSÍ být
  zformátována do alertu a rozeslána na nakonfigurovaný provozní alertovací kanál (kanály) s
  odpovídající závažností.
- Doručení alertu MUSÍ probíhat na bázi best-effort — selhání doručení alertu MUSÍ ovlivnit pouze
  samotný alert a NESMÍ změnit výsledek, stav ani výstup procesu, který jej vyvolal.

---

## Auditní stopa

- Záznamy o výsledku a záznamy požadavku/odpovědi MUSÍ být předány do trvalého úložiště pro audit a
  vyhledávání tak, aby zpracované záznamy zůstaly dohledatelné pro účely auditu a vyhledávání.

---

## Doručení pouze formou alertu konzistence

- Stav desynchronizace mezi žádostí a příběhem (Application↔Campaign) (politiku „pouze alert bez
  opravy" vlastní `BR-ApplicationStatusGovernance`) MUSÍ být směrován přes tento alertovací kanál
  stejně jako jakákoli jiná provozní podmínka — na bázi best-effort a bez ovlivnění výsledku procesu,
  který jej vyvolal.

---

## Co není cílem

- Toto pravidlo nedefinuje uživatelsky viditelnou transakční komunikaci (příjemce, kanály ani
  podmínky odeslání komunikace směrem k patronovi/žadateli) — viz BR-TransactionalMessaging.
- Toto pravidlo nedefinuje samotné pravidlo konzistence mezi žádostí a příběhem (kdy vzniká
  desynchronizace nebo jak jsou obě strany udržovány v souladu) — viz BR-ApplicationStatusGovernance;
  toto pravidlo upravuje pouze způsob doručení výsledného alertu.
- Toto pravidlo nedefinuje krok-za-krokem průběh zpracování alertu/auditu — viz UC0020.
- Toto pravidlo nevlastní žádnou doménovou entitu.
