---
doc_id: EN0025
title: ApplicationLog
layer: EN
spec_type: entity
status: imported
modules: []
references:
  - EN0001  # Application (logged aggregate)
  - EN0008  # User (author)
  - EN0026  # ApplicationReaction (reaction driving a log entry)
  - EN0003  # ApplicationSession (session-cancellation log entry)
  - UC0002  # Orchestrate Application Status Change (reaction/session-cancel log entries)
  - UC0004  # Manage Contract And Signature (contract activity log entries)
  - BR-ApplicationStatusGovernance  # status-change side effects incl. audit logging
---

# EN0025 — ApplicationLog

## Účel

Neměnný záznam aktivity/auditu vedený pro každou žádost, zobrazovaný administrátorům jako historie
aktivit dané žádosti. Každý záznam ApplicationLog zachycuje jednu diskrétní událost vztahující se
k žádosti (EN0001): zaznamenanou komunikaci (telefonát/e-mail/sms), systémem řízenou akci (např.
reakci vyvolanou změnou stavu nebo zrušení relace), nebo poznámku. Záznamy se v průběhu životního
cyklu žádosti hromadí a společně tvoří její stopu aktivit.

---

## Životní cyklus

Zaznamenáno — jediný stav. Záznam ApplicationLog je vytvořen jednou a následně již nikdy není měněn
ani odstraněn; po jeho vytvoření neexistuje žádný další životní cyklus.

---

## Přechody stavů

(žádný) → Zaznamenáno
spouštěč: UC0002 — Orchestrate Application Status Change (odpovídající ApplicationReaction, EN0026,
vytvoří záznam v logu; změna stavu, která invaliduje relaci, vytvoří záznam v logu zaznamenávající
zrušení relace)

(žádný) → Zaznamenáno
spouštěč: UC0004 — Manage Contract And Signature (kroky kontroly smlouvy a podpisu smlouvy každý
vytvoří záznam aktivity v logu žádosti)

Přechod ze stavu Zaznamenáno není evidován — záznamy jsou pouze pro přidávání (append-only).

---

## Atributy

### Systémem spravované atributy

- Žádost (odkaz na EN0001; povinné) — žádost, ke které je záznam evidován.
- Autor (odkaz na EN0008; povinné) — uživatel uvedený jako autor záznamu; výchozí hodnotou je
  aktuální uživatel, nebo systémový servisní účet pro systémem generované záznamy (viz
  BR-ApplicationStatusGovernance).
- Zaznamenáno v (časové razítko; povinné) — kdy byl záznam vytvořen.
- Naposledy dotčeno v (časové razítko; povinné) — administrativní/technické časové razítko vedle
  času zaznamenání; pro obsah záznamu není doložen žádný use case aktualizace.

### Uživatelem zadávané atributy

- Popisovač aktivity (text, do 50 znaků; povinné) — krátký štítek identifikující změněné pole nebo
  typ aktivity.
- Přidružená hodnota (text, do 255 znaků; volitelné) — hodnota přidružená k popisovači aktivity.
- Poznámka (dlouhý text; volitelné) — volný text poznámky ("Poznámka").

---

## Invarianty

- Záznam ApplicationLog je po zaznamenání neměnný — viz BR-ApplicationStatusGovernance (vedlejší
  účinky změny stavu a idempotence).
- Každá změna stavu, která odpovídá nakonfigurované ApplicationReaction (EN0026), a každá změna
  stavu, která invaliduje záznamy ApplicationSession (EN0003), vytvoří odpovídající záznam
  ApplicationLog — viz BR-ApplicationStatusGovernance.
- Na této entitě není definován žádný atribut stavu životního cyklu — Zaznamenáno je jediný stav
  entity, nikoli hodnota statusu vybíraná ze slovníku.

---

## Vztahy

- EN0001 — Application (evidovaný agregát; povinné, jedna žádost na záznam)
- EN0008 — User (autor záznamu)
- EN0026 — ApplicationReaction (konfigurace, která může způsobit vytvoření záznamu v logu)
- EN0003 — ApplicationSession (události zrušení relace evidované u žádosti)

---

## Otevřené otázky

1. Existuje řízený slovník typů aktivit (telefonát/e-mail/sms/systémová akce/změna pole) stojící za
   popisovačem aktivity a přidruženou hodnotou, nebo je obsah volný podle toho, kdo záznam pořizuje?
   V kanonických podkladech nedoloženo.
2. Conflict — requires clarification: dřívější podklady zaznamenaly dvě mapování atributů na úrovni
   scaffoldingu bez odpovídajícího podkladového pole, což naznačuje buď mrtvou konfiguraci, nebo
   ztracený/nikdy neimplementovaný atribut. Nevyřešeno; ponecháno jako otevřená otázka, nikoli jako
   kanonický fakt.
3. Uncertain: bylo zjištěno, že popisy polí této entity úzce odpovídají srovnatelné logovací entitě
   používané jinde v systému (logování aktivit na straně kampaně); není potvrzeno, zda jde o náhodnou
   shodu, nebo o sdílenou/zkopírovanou definici, a zda nedošlo k neúmyslnému přenesení sémantiky
   specifické pro Campaign.
