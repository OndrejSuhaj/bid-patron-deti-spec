---
doc_id: UC0002
title: Orchestrate Application Status Change
layer: UC
spec_type: use-case
status: imported
modules: []
---

# UC0002 — Orchestrace změny stavu žádosti

## Hlavička

| Pole | Hodnota |
|---|---|
| UC ID | UC0002 |
| Název | Orchestrace změny stavu žádosti |
| Bounded Context | C1 |
| Primární aktér(y) | Admin, Systém |
| Typ spouštění | UI / Event / Cron |

## Aktéři a odpovědnosti

- **Admin** — uživatel back-office, který přes formulář pro změnu stavu vybere a odešle nový stav žádosti (EN0001).
- **Systém** — uloží nový stav, připojí auditní záznam a při každém uložení bezpodmínečně vyvolá událost aktualizace stavu; navazujícím krokem Systém rovněž provede každou reakci (log, session, scoring, dokument, zasílání zpráv, indexace ve vyhledávání) vyvolanou touto událostí.
- **Scheduler** — periodicky spouští průchod automatických přechodů stavu (cron), který podle nakonfigurovaných pravidel přesouvá zestárlé žádosti z jednoho stavu do druhého.

## Záměr

Poskytnout jediné místo, kterým se mění stav žádosti (EN0001) — ať už na základě rozhodnutí člověka, automatického časového pravidla, nebo systémové logiky — a zaručit, že každá změna stavu konzistentně vyvolá správné navazující reakce (auditní logování, zasílání zpráv, rizikový scoring, vytvoření dokumentu/session, reindexace ve vyhledávání) bez ohledu na to, kterou cestou byla změna vyvolána.

## Předpoklady

- Žádost (EN0001) existuje a nachází se v nějakém aktuálním stavu.
- Pro člověkem řízený dílčí tok: Admin má oprávnění umožňující změnu stavu žádosti.
- Pro automatický dílčí tok: existuje pravidlo ApplicationAction (EN0027), je aktivní a je nakonfigurováno tak, že jeho spouštěč/iniciátor je typu naplánovaný (cron).

## Hlavní tok

### UC0002.1 — Admin změní stav žádosti

1. Admin: Otevře formulář pro změnu stavu cílové žádosti (EN0001).
2. Admin: Vybere novou hodnotu stavu a volitelně zadá poznámku.
3. Admin: Odešle formulář.
4. Systém: Nastaví stav žádosti (EN0001) na odeslanou hodnotu a zaznamená volitelnou poznámku.
5. Systém: Připojí auditní záznam historie stavu zachycující žádost, nový stav, jednajícího uživatele, poznámku a časové razítko.
6. Systém: Vytvoří novou revizi žádosti (EN0001) zaznamenávající poznámku a jednajícího uživatele.
7. Systém: Uloží žádost (EN0001), čímž bezpodmínečně vyvolá událost změny stavu — bez ohledu na to, zda se hodnota stavu skutečně změnila.
8. Systém: Pokračuje navazujícím rozvětvením reakcí popsaným v UC0002.2.

Poznámka (Evidence Level: Confirmed with caveat): role „orchestrátoru“ není samostatným voláním služby — je realizována jako vedlejší efekt uložení entity žádosti (EN0001). Každé uložení vyvolá stejné rozvětvení událostí bez ohledu na to, zda se stav skutečně změnil; jednotlivé navazující reakce jsou odpovědné za rozpoznání, zda ke skutečné změně stavu došlo.

### UC0002.2 — Navazující rozvětvení reakcí při změně stavu

1. Systém: Vyhodnotí, zda se stav žádosti (EN0001) skutečně liší od předchozí hodnoty, jako podmínku pro reakce vyžadující skutečnou změnu.
2. Systém: Zařadí žádost (EN0001) do fronty pro reindexaci ve vyhledávání (SearchIndex-Processor), nezávisle na tom, zda se hodnota stavu změnila.
3. Systém: Vyhledá nakonfigurované záznamy ApplicationReaction (EN0026) odpovídající novému stavu žádosti a příslušné roli.
4. Systém: Pro každou odpovídající ApplicationReaction (EN0026) připojí záznam ApplicationLog (EN0025) zaznamenávající danou reakci.
5. Systém: Pro každou odpovídající ApplicationReaction (EN0026), která specifikuje session rozhraní, vytvoří ApplicationSession (EN0003) pro příslušnou roli.
6. Systém: Pro každou odpovídající ApplicationReaction (EN0026) s povolenou notifikací odešle stavem řízenou transakční zprávu (Transactional-Messaging-Orchestrator) vyřešenému příjemci.
7. Systém: Zkontroluje, zda je nový stav nakonfigurován tak, aby zneplatnil session; pokud ano, deaktivuje všechny záznamy ApplicationSession (EN0003) žádosti (EN0001) a připojí záznam ApplicationLog (EN0025) zaznamenávající zrušení session.
8. Systém: Pokud je nový stav stavem pro rizikové přezkoumání, přepočítá a uloží low-risk skóre žádosti (EN0001) (Scoring-&-Risk).
9. Systém: Pokud nový stav představuje vstup do stavu čekání na podpis nebo čekání na zpětnou vazbu (a příslušná funkce je povolena), vygeneruje dokument akceptačního protokolu (Document-Generation-&-Fulfilment) a vytvoří odpovídající ApplicationSession (EN0003) nesoucí podpisový nebo zpětnovazební formulář.
10. Systém: Pokud je k žádosti (EN0001) připojen příběh (Campaign, EN0004), synchronizuje stav/kategorii příběhu tak, aby zůstal konzistentní s novým stavem žádosti, a příběh znovu uloží.

Výsledek: všechny nakonfigurované reakce pro nový stav byly provedeny; žádost (EN0001), její session, její auditní log a (tam, kde je to relevantní) její navázaný příběh jsou konzistentní s novým stavem.

### UC0002.3 — Automatický přechod stavu řízený Schedulerem

1. Scheduler: Spustí periodický průchod automatických přechodů.
2. Systém: Načte aktivní pravidla ApplicationAction (EN0027), jejichž typ spouštění je nakonfigurován jako naplánovaný/cron.
3. Systém: Pro každé aktivní pravidlo vybere žádosti (EN0001), které se aktuálně nacházejí ve zdrojovém stavu pravidla a jejichž doba v tomto stavu překračuje nakonfigurovaný prahový věk pravidla.
4. Systém: Pro každou vybranou žádost (EN0001) změní její stav na cílový stav pravidla, přiřazený systémovému servisnímu účtu, což se vrací do hlavního toku na UC0002.1 krok 4 (nastavení stavu → audit → uložení → rozvětvení).
5. Systém: Pokud pravidlo specifikuje dodatečnou automatickou akci, provede tuto akci na žádosti (EN0001) (ApplicationAction-Processor).

Poznámka k evidenci: tento dílčí tok je podložen definicí entity ApplicationAction (EN0027) (pouze konfigurační evidence); samotný tok spouštěný cronem není součástí mined flow dossiers přiřazených k tomuto UC, a je proto **Partial** — chování je odvozeno z dokumentace entity EN0027, nikoli z flow dossier.

## Alternativní toky

### AF1 — Změna stavu odeslána bez skutečného rozdílu ve stavu

1. Admin: Odešle formulář pro změnu stavu se stejnou hodnotou, jakou má aktuální stav žádosti (EN0001).
2. Systém: I přesto připojí auditní záznam historie stavu a vyvolá událost změny stavu (v tomto bodě neexistuje žádná pojistka proti změně).
3. Systém: Spustí navazující rozvětvení reakcí (UC0002.2); reakce podmíněné skutečným rozdílem ve stavu neprovedou žádnou další akci, zatímco auditní záznam a záznam ve frontě reindexace vyhledávání se přesto vytvoří.

Výsledek: vznikne duplicitní záznam auditní stopy, i když se efektivní stav žádosti (EN0001) nezměnil; jde o známou mezeru v konzistenci, nikoli o zamýšlené obchodní chování.

### AF2 — Rozvětvení reakcí narazí uprostřed sekvence na chybu

1. Systém: Během provádění jedné z reakcí v UC0002.2 (např. generování dokumentu) narazí na chybu.
2. Systém: Chyba přeruší zbývající reakce ve stejném průchodu rozvětvení; již dokončené reakce (např. auditní log, předchozí notifikace) zůstávají uloženy.

Výsledek: žádost (EN0001) může skončit ve stavu, kdy byl stav změněn a některé reakce proběhly, ale pozdější reakce v sekvenci nikoliv — riziko částečného dokončení vlastní současnému synchronnímu, nezajištěnému návrhu.

### AF3 — Záznam žadatele vstoupí do stavu vrácená žádost (nový patron)

1. Admin: Změní stav žádosti (EN0001) na stav představující „vrácenou žádost (nový patron)“.
2. Systém: V rámci ukládání žádosti (EN0001) (hlavní tok, kroky 4-7) také vyčistí z žádosti profilová a scoringová data související s patronem.

Výsledek: žádost (EN0001) projde běžným rozvětvením (UC0002.2) s vymazanými daty patrona.

## Postconditions

- Stav žádosti (EN0001) odpovídá odeslané nebo automaticky určené nové hodnotě, se zaznamenanou novou revizí.
- Pro přechod existuje auditní záznam historie stavu (ApplicationLog EN0025 nebo ekvivalentní historický záznam).
- Každá nakonfigurovaná ApplicationReaction (EN0026) pro nový stav vytvořila své záznamy v logu, session a/nebo notifikace.
- Session (EN0003) byly deaktivovány, pokud je nový stav nakonfigurován tak, aby je zneplatnil.
- Low-risk skóre žádosti (EN0001) bylo přepočítáno, pokud je nový stav stavem pro rizikové přezkoumání.
- Existuje dokument akceptačního protokolu a session s podpisovým/zpětnovazebním formulářem, pokud nový stav vstoupil do stavu čekání na podpis nebo čekání na zpětnou vazbu.
- Navázaný příběh (Campaign, EN0004), pokud existuje, má svůj stav/kategorii synchronizovanou s novým stavem žádosti.
- Žádost (EN0001) byla zařazena do fronty pro reindexaci ve vyhledávání.

## Traceability

Cílové SRV:
- Application-Status-Orchestrator
- ApplicationAction-Processor
- Transactional-Messaging-Orchestrator
- Scoring-&-Risk
- Document-Generation-&-Fulfilment
- SearchIndex-Processor

Entity EN:
- EN0001 Application — agregát, jehož stav je měněn a orchestrován
- EN0025 ApplicationLog — řádky auditního/reakčního logu připojované rozvětvením
- EN0026 ApplicationReaction — konfigurace párovaná podle stavu/role, řídící výstup logu, session a notifikací
- EN0027 ApplicationAction — konfigurace řídící automatické přechody stavu založené na cronu (UC0002.3)
- EN0003 ApplicationSession — session vytvářené a deaktivované v rámci rozvětvení
- EN0004 Campaign (Story) — sousední entita, referencovaná kvůli vedlejšímu efektu synchronizace stavu; není součástí základní přiřazené sady tohoto UC.

Integration boundaries:
- Žádné (toto UC je interní orchestrace; navazující efekty zasílání zpráv/vyhledávání/dokumentů probíhají přes vlastní UC a SRV, žádné přímé volání externího systému v rámci tohoto UC samotného)

Flow Evidence:
- FLW0002 (workflow změny stavu žádosti — UC0002.1)
- FLW0001 (rozvětvení událostí stavu žádosti — UC0002.2)
- FL009 (automatické cronové přechody — UC0002.3, nezpracováno těžením, Partial; podloženo pouze EN0027)

## Evidence Level

Confirmed pro UC0002.1 a UC0002.2 (FLW0002 i FLW0001 jsou hodnoceny jako Confirmed a přímo dokládají sekvenci nastavení stavu/auditu/revize/uložení a rozvětvení reakcí se třemi odběrateli, křížově ověřeno vůči EN0001, EN0025, EN0026, EN0003). Partial pro UC0002.3: automatický cronový přechod je doložen pouze dokumentací entity ApplicationAction (EN0027), nikoli mined flow dossier (FL009 nebyl přiřazen/zpracován těžením), takže jeho přesná perioda spouštění a zpracování chyb nejsou nezávisle potvrzeny.
