---
doc_id: EN0018
title: Organisation
layer: EN
spec_type: entity
status: imported
modules: []
references:
  - EN0001  # Application — employer reference
  - EN0006  # Contact — organisation contact details
  - EN0008  # User — key account manager (owner) and workers
  - BR-PartyIdentityAndDeduplication  # merge/dedup legality and reparenting scope
  - BR-SearchIndexingConsistency      # search-index propagation guarantee
  - UC0016  # Maintain Party Records (Dedup / Merge) — merge, worker provisioning triggers
  - UC0018  # Index Entities for Search — indexing queue trigger
---

# EN0018 — Organizace

## Účel

Reprezentuje zaměstnavatelskou nebo partnerskou organizaci — firmu nebo instituci, která zaměstnává
patrony a může vystupovat jako zprostředkovatel darů. Organizace obsahuje registr pracovníků (uživatelé
personálu jednající jejím jménem, přičemž jeden z nich může být označen jako administrátor organizace)
a může být odlišena jako profesionální partnerská ("Profi") organizace. Záznamy organizací konsoliduje
administrátor, jakmile jsou identifikovány duplicity, a jsou vystaveny prostřednictvím externího
vyhledávacího indexu.

## Životní cyklus

- Aktivní (publikováno) — výchozí a normální stav; viditelný ve vyhledávání a volitelný jako
  zaměstnavatel/partner.
- Neaktivní (nepublikováno) — záznam je zachován, ale není publikován.
- Odstraněno — záznam již neexistuje, po sloučení do přežívající Organizace.

## Přechody stavů

(vytvořeno) → Aktivní
spouštěč: předpokládaný výchozí publikovaný stav při vytvoření — **Hypothesis, not evidenced**: žádný
zmapovaný krok vytváření Organizace nepotvrzuje výchozí hodnotu při vytvoření (dílčí tok ukládání
pracovníka UC0016.2 to nedokládá); viz Otevřené otázky.

Aktivní ⇄ Neaktivní
spouštěč: administrativní akce publikování/zrušení publikace (nedoloženo nad rámec příznaku
publikace; viz Otevřené otázky)

Aktivní → Odstraněno
spouštěč: UC0016.2 — Správa záznamů stran: deduplikace organizací a správa pracovníků (Organizace
vybraná jako duplicita je odstraněna poté, co byla její reference zaměstnavatele přeřazena na
přežívající Organizaci)

(jakýkoli stav) → (znovu indexováno v externím vyhledávání)
spouštěč: UC0018 — Indexace entit pro vyhledávání (Organizace zařazená do fronty při uložení je
periodicky odesílána do vyhledávacího indexu); nezávisle na tom UC0016.3 odesílá celý registr
Organizací do vyhrazeného vyhledávacího indexu organizací na denní bázi

## Atributy

### Systémem spravované atributy

- Stav publikace (boolean; povinné; ve výchozím stavu publikováno; určuje, zda je Organizace Aktivní
  nebo Neaktivní)
- Klíčový account manager (reference na EN0008 – Uživatel; volitelné; vlastnící/zodpovědný uživatel
  za tuto Organizaci)
- Časová razítka vytvoření / změny (datetime; povinné)

### Uživatelem zadávané atributy

- Název (string; povinné; štítek entity; identifikuje Organizaci)
- Pracovníci (reference na EN0008 – Uživatel; volitelné; více hodnot; každý záznam pracovníka nese
  příznak administrátora organizace, který indikuje zvýšené postavení v rámci Organizace)
- Kontaktní údaje (reference na EN0006 – Kontakt; volitelné; jeden)
- Logo (obrázek; volitelné; jeden)
- Je Profi organizace (boolean; volitelné; označuje Organizaci jako profesionálního partnera)

## Invarianty

- Jedinečnost názvu Organizace není vynucována na úrovni dat; viz BR-PartyIdentityAndDeduplication.
- Legalita sloučení Organizace, rozsah přeřazení referencí a netransakční chování v aktuálním stavu
  se řídí BR-PartyIdentityAndDeduplication (viz také INV18 v doménovém jádru).
- Propagace Organizace do vyhledávacího indexu a záruka opakování/eventual-consistency se řídí
  BR-SearchIndexingConsistency.

## Vztahy

- EN0001 – Žádost: Žádost odkazuje na Organizaci jako svého zaměstnavatele.
- EN0002 – ApplicationProfile: ApplicationProfile odkazuje na Organizaci jako zaměstnavatele.
- EN0006 – Kontakt: Organizace volitelně obsahuje jeden Kontakt pro své kontaktní údaje.
- EN0008 – Uživatel: Organizace volitelně má jednoho klíčového account managera (vlastníka) a libovolný
  počet pracovníků, každý s příznakem administrátora.

## Otevřené otázky

1. Název nemá na úrovni dat vynucenou jedinečnost, přesto se jinde v systému používá vyhledávání
   organizace podle přesného názvu — má být název Organizace zamýšlen jako jedinečný? Hypothesis —
   not evidenced.
2. Při sloučení Organizace je na přežívající Organizaci přeřazena pouze reference zaměstnavatele u
   Žádosti; odkazy pracovníků a další reference na odstraněnou Organizaci zůstávají nezavěšené (viz
   BR-PartyIdentityAndDeduplication, doménové jádro INV18) — potvrzené chování v aktuálním stavu,
   dosud nevyřešeno, zda je to přijatelné pro cílový přepis.
3. Synchronizace externího vyhledávacího indexu Organizací není doložena jako rozlišená podle země
   (CZ/RO/MD) — není jasné, zda se jedná o záměrný návrh jednotného registru, nebo o mezeru v
   aktuálním stavu.
4. Vliv příznaku administrátora organizace na schopnosti pracovníka není v této rekonstrukční fázi
   doložen — Chybějící evidence.
5. Přechod publikování/zrušení publikace (Aktivní ⇄ Neaktivní) nemá v aktuální sadě evidence
   potvrzený spouštěcí případ užití — Chybějící evidence.
