---
doc_id: UC0015
title: Anonymize Personal Data (GDPR)
canonical_layer: UC
spec_type: use-case
status: canonical
modules: []
---

# UC0015 — Anonymizace osobních údajů (GDPR)

## Hlavička

| Pole | Hodnota |
|---|---|
| UC ID | UC0015 |
| Název | Anonymizace osobních údajů (GDPR) |
| Bounded Context | C9 |
| Primární aktér(y) | Admin, Support, System |
| Typ spuštění | UI |

## Aktéři a odpovědnosti

- **Admin / Support** — operátor back office s přístupovými právy pro GDPR; zadává e-mailovou adresu strany (uživatel, EN0008), jejíž osobní údaje mají být vymazány.
- **System** — provádí vyhledání, upravuje identifikační pole uživatele, zařazuje navazující re-synchronizační práci do fronty a (pouze v produkčním prostředí) se pokouší odstranit stranu z marketingového CRM.
- **Scheduler** (na pozadí, mimo přímou spouštěcí cestu) — následně zpracovává frontu re-synchronizačních úloh vůči vyhledávacímu indexu a marketingovému CRM; viz alternativní tok AF2 a poznámka ke sledovatelnosti u Mautic-CRM-Adapter.

## Záměr

Umožnit oprávněnému uživateli back office na vyžádání vymazat osobně identifikovatelné přihlašovací údaje strany (e-mail a zobrazované jméno) ze záznamu uživatele (EN0008), aby bylo možné vyhovět žádosti o výkon práva na výmaz podle GDPR.

## Předpoklady

- Žádající uživatel Admin/Support disponuje přístupovým oprávněním pro GDPR anonymizaci.
- Existuje uživatel (EN0008), jehož e-mail odpovídá hodnotě zadané pro anonymizaci.
- Aktuální tok nevyžaduje žádné předchozí potvrzení, opětovnou autentizaci ani druhý schvalovací krok.

## Hlavní tok

### UC0015.1 — Odeslání a provedení požadavku na anonymizaci

1. Admin: Otevře formulář GDPR anonymizace v back office a zadá e-mailovou adresu strany, která má být anonymizována.
2. Admin: Odešle formulář s požadavkem na anonymizaci.
3. System: Vyhledá uživatele (EN0008), jehož e-mail odpovídá zadané hodnotě.
4. System: Pokud žádný odpovídající uživatel není nalezen, zobrazí zprávu "neexistuje" a tok se zastaví (viz AF1).
5. System: Vyprázdní pole e-mailu nalezeného uživatele a nahradí zobrazované jméno uživatele randomizovanou hodnotou.
6. System: Uloží aktualizovaný záznam uživatele.
7. System: Zobrazí potvrzovací zprávu, že strana byla anonymizována.
8. System: Zařadí anonymizovaného uživatele do fronty pro re-synchronizaci do vyhledávacího indexu (viz UC0018, Indexace entit pro vyhledávání).
9. System: Zařadí anonymizovaného uživatele do fronty pro re-synchronizaci do marketingového CRM (viz UC0015.2).
10. System: Pokud je aktuálním prostředím produkce, pokusí se požádat o odstranění kontaktního záznamu strany z marketingového CRM (viz UC0015.3).

### UC0015.2 — Navazující re-synchronizace marketingového CRM (asynchronní)

1. Scheduler: Při nejbližším naplánovaném běhu vyzvedne z fronty položku synchronizace marketingového CRM pro anonymizovaného uživatele.
2. System: Načte aktuální hodnoty jména a e-mailu uživatele pro payload CRM.
3. Integration(Mautic): Odešle požadavek na vytvoření nebo aktualizaci kontaktního záznamu strany, který obsahuje stále vyplněné jméno/příjmení uživatele spolu s nyní prázdným e-mailem.
4. System: Zaznamená kontakt CRM jako synchronizovaný, bez ohledu na skutečnost, že uživatel měl být vymazán.

### UC0015.3 — Pokus o výmaz z marketingového CRM (pouze produkce, synchronní)

1. System: V produkčním prostředí volá adaptér marketingového CRM s požadavkem na smazání kontaktu strany podle e-mailu, jako součást téhož požadavku na anonymizaci (UC0015.1, krok 10).
2. System: Funkce mazání adaptéru marketingového CRM neprovádí žádné skutečné odstranění v CRM — tento krok je doložen jako definovaná, ale prázdná funkce (Partial/Hypothesis: zamýšlené chování není implementováno; viz Evidence Level).

## Alternativní toky

### AF1 — Nenalezena žádná odpovídající strana

1. System: Nenajde žádného uživatele (EN0008), jehož e-mail by odpovídal zadané hodnotě.
2. System: Zobrazí zprávu "neexistuje".

Výsledek: Neproběhne žádná anonymizace; nevytvoří se žádné položky ve frontě.

### AF2 — Nekaskádují se data souvisejících stran (pozorovaná mezera)

1. System: Anonymizuje pouze e-mail a zobrazované jméno uživatele.
2. System: Ponechá beze změny pole jména/příjmení uživatele a veškeré osobní údaje uložené na souvisejících záznamech žádosti (viz UC0001) a kontaktu (EN0006) — včetně rodného čísla, adresy a telefonních údajů vázaných na tutéž stranu.

Výsledek: Přihlašovací údaje strany jsou anonymizovány, ale osobní údaje uchovávané jinde pro tutéž stranu (kontakt, profily navázané na žádost) zůstávají neporušené; výmaz je částečný. Jde o potvrzenou mezeru v chování, nikoli o zdokumentovanou alternativní obchodní cestu.

### AF3 — Opakované odeslání pro již anonymizovanou stranu

1. Admin: Odešle znovu tutéž původní e-mailovou adresu po předchozí úspěšné anonymizaci.
2. System: Nenajde žádného uživatele odpovídajícího tomuto e-mailu (jeho e-mail byl již vyprázdněn při předchozím běhu).
3. System: Zobrazí zprávu "neexistuje" (stejně jako v AF1).

Výsledek: Opakované požadavky pro tentýž původní e-mail nemohou znovu zacílit tutéž stranu, jakmile již byla jednou anonymizována; každý samostatný úspěšný běh znovu randomizuje zobrazované jméno a znovu zařazuje navazující synchronizaci do fronty.

## Výstupní podmínky

- E-mail cílového uživatele (EN0008) je prázdný a jeho zobrazované jméno je randomizovaná hodnota; účet uživatele zůstává zachován a aktivní (v důsledku tohoto toku není smazán ani zablokován).
- Pro anonymizovaného uživatele je zařazena položka re-synchronizace vyhledávacího indexu do fronty (viz UC0018).
- Pro anonymizovaného uživatele je zařazena položka re-synchronizace marketingového CRM do fronty; při zpracování znovu vytvoří nebo aktualizuje kontaktní záznam strany v marketingovém CRM, namísto jeho odstranění (viz UC0015.2).
- V produkci je vydán požadavek na výmaz z marketingového CRM, ten ale v CRM neodstraní žádná data (viz UC0015.3).
- Osobní údaje uložené na záznamu kontaktu (EN0006) a jakákoli data profilu navázaného na žádost pro tutéž stranu nejsou tímto use case změněna (viz AF2).

## Sledovatelnost

Cílové SRV:
- Identity-&-Access
- Transactional-Messaging-Orchestrator
- Mautic-CRM-Adapter

EN entity:
- EN0008 Uživatel — záznam strany, jejíž e-mail a zobrazované jméno jsou anonymizovány; kotva tohoto use case.
- EN0006 Kontakt — držitel souvisejících dat strany, který NENÍ tímto use case kaskádově aktualizován (doložená mezera, viz AF2).

Integrační hranice:
- Mautic (marketingové CRM) — přijímá asynchronní re-synchronizaci (vytvoření/aktualizaci) anonymizované strany (UC0015.2) a v produkci synchronní požadavek na výmaz, který neprovádí žádné skutečné odstranění (UC0015.3).

Evidence toku:
- FLW0020 (GDPR anonymizace)

## Evidence Level

Confirmed pro základní mechaniku anonymizace a její neúplnost (mutace pouze pole uživatele, žádná kaskáda do osobních údajů EN0006/žádosti, žádný alternativní tok pro nenalezenou stranu) podle FLW0020 a poznámek k životnímu cyklu EN0008/EN0006. Partial/Hypothesis pro funkci výmazu z marketingového CRM (UC0015.3): FLW0020 ji dokládá jako definovanou, ale nefunkční (prázdnou) funkci, nikoli jako fungující chování, proto je zdokumentována jako pozorovaná mezera, nikoli jako navržená alternativa.
