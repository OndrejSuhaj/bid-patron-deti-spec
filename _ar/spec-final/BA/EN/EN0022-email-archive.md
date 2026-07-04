---
doc_id: EN0022
title: EmailArchive
canonical_layer: EN
spec_type: entity
status: canonical
modules: []
references:
  - EN0001  # Application — required reference on every archive record
  - EN0004  # Campaign — optional reference
  - EN0008  # User — author and resolved-recipient references
  - BR-TransactionalMessaging  # governs archiving / delivery-status policy
  - UC0012  # Dispatch Transactional Message — sole creation trigger
---

# EN0022 — EmailArchive

## Účel

EmailArchive je trvalý záznam odchozí transakční zprávy, veden samostatně pro každého příjemce.
Kdykoli messaging orchestrátor odešle zprávu vytvořenou ze šablony, zapíše se jeden záznam
EmailArchive pro každého příjemce, bez ohledu na to, zda byla zpráva skutečně odeslána. Zaznamenává,
co bylo odesláno (nebo o co se pokusil systém): rozpoznané adresy, předmět, vykreslené tělo zprávy,
použitou šablonu a argumenty dodané do této šablony, spolu s obchodním kontextem, ke kterému se zpráva
vztahuje (řídící Žádost a volitelně Campaign). EmailArchive slouží jako auditní stopa pro transakční
komunikaci, nikoli jako samostatný objekt obchodního workflow.

---

## Životní cyklus

- Vytvořeno (publikováno)

EmailArchive má po vytvoření jediný efektivní stav životního cyklu: existuje a je publikováno.
Nenese stav doručení (např. odesláno, selhalo, potlačeno) — viz Invarianty.

---

## Přechody stavů

(žádný) → Vytvořeno  
trigger: UC0012 (Dispatch Transactional Message) — jeden záznam EmailArchive se vytváří pro každého
příjemce během archivace (UC0012.2), pro každý pokus o odeslání, který prošel rozpoznáním šablony.

Po vytvoření nedochází k žádným dalším přechodům stavu: záznamy EmailArchive nejsou aktualizovány
o výsledek doručení (viz Invarianty).

---

## Atributy

### Systémem spravované atributy

- to (řetězec; povinné; rozpoznaná adresa příjemce)
- from (řetězec; povinné; rozpoznaná adresa odesílatele)
- body (text; volitelné; vykreslené tělo zprávy)
- template_name (řetězec; povinné; identifikuje použitou šablonu, rozpoznanou podle země)
- arguments (text; volitelné; hodnoty pro dosazení do šablony, zaznamenané tak, jak byly dodány)
- to_user (reference na EN0008 – Uživatel; volitelné; příjemce, automaticky rozpoznaný z adresy `to`)
- author (reference na EN0008 – Uživatel; volitelné; uživatelský kontext aktivní v okamžiku vytvoření)
- status (boolean; příznak publikováno; výchozí hodnota publikováno)

### Uživatelem zadávané atributy

- application (reference na EN0001 – Žádost; povinné; obchodní kontext, ke kterému se zpráva vztahuje)
- campaign (reference na EN0004 – Campaign; volitelné; kontext kampaně, ke kterému se zpráva vztahuje,
  je-li relevantní)

Poznámka: „uživatelem zadávané" zde znamená dodané volajícím obchodním kontextem, který požaduje
odeslání (dle předpokladů UC0012), nikoli zadané koncovým uživatelem prostřednictvím formuláře.

---

## Invarianty

- Pro každého příjemce a každý pokus o odeslání, který projde rozpoznáním šablony, se vytvoří právě
  jeden záznam EmailArchive; pokus o odeslání s nerozpoznatelným názvem šablony nevytvoří žádný
  (politiku archivace určuje BR-TransactionalMessaging; viz UC0012, AF1).
- Záznam EmailArchive po svém vytvoření nenese výsledek doručení — doručenou zprávu nelze odlišit od
  potlačené nebo neúspěšné (dle BR-TransactionalMessaging; viz UC0012 AF2, Postconditions).
- Záznam EmailArchive vždy odkazuje na Žádost (EN0001); žádný potvrzený případ platného záznamu
  EmailArchive bez tohoto odkazu není doložen.

---

## Vztahy

- EN0001 – Žádost (povinné; obchodní kontext zprávy)
- EN0004 – Campaign (volitelné)
- EN0008 – Uživatel (autor a samostatně rozpoznaný příjemce)

---

## Otevřené otázky

1. Datový model EmailArchive rezervuje pole pro výsledek doručení (odesláno/chyba), ale žádná
   potvrzená cesta je po vytvoření nikdy nenaplňuje — jde o plánovanou, ale nerealizovanou
   schopnost sledování stavu doručení, nebo je to u této entity záměrně mimo rozsah?
2. Atributy `to`/`from` jsou v současné implementaci ořezávány na pevnou délku u dlouhých adres —
   není jasné, zda jde o akceptované omezení, nebo o mezeru v integritě dat.
3. `application` je validací považováno za povinné, ale současné důkazy nepotvrzují, že je to
   vynucováno i na úrovni ukládání dat — je záznam EmailArchive bez odkazu na Žádost někdy platný?
4. EmailArchive nemá žádný mechanismus deduplikace ani idempotenční klíč — opakované vyvolání
   odeslání pro tutéž logickou zprávu vytvoří další archivní záznamy a tam, kde to brána pro
   odesílání umožňuje, i další přenosy. Uncertain — není doloženo, zda jde o akceptovanou vlastnost,
   nebo neřešenou mezeru.
