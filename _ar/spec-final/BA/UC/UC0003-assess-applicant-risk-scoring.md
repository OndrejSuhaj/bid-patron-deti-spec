---
doc_id: UC0003
title: Assess Applicant Risk (Scoring)
layer: UC
spec_type: use-case
status: imported
modules: []
---

# UC0003 — Posouzení rizika žadatele (scoring)

## Hlavička

| Pole | Hodnota |
|---|---|
| UC ID | UC0003 |
| Název | Assess Applicant Risk (Scoring) |
| Bounded Context | C2 |
| Primární aktér(y) | Admin, System |
| Typ spouštění | UI/Event |

## Aktéři a odpovědnosti

- **Admin** (back-office risikový posuzovatel / koordinátor) — otevírá formulář ručního scoringu pro žádost (EN0001), zadává posouzení rizika, rozhoduje o klasifikaci fundraisera/patrona na blacklistu a schvaluje nebo neschvaluje pokračování žádosti.
- **System** — automaticky přepočítává low-risk skóre vždy, když žádost přejde do mezistavu review, bez lidského zásahu; ukládá výsledky scoringu; uplatňuje bránu schválení stavu; propaguje klasifikaci blacklistu do kontaktu (EN0006).
- **External(MVCR)** — ověřuje platnost dokladu totožnosti (občanského průkazu) pro strany uvedené na žádosti, a to v okamžiku zobrazení scoringového formuláře.
- **External(ARES)** — ověřuje registrová data firmy/IČO dostupná z obrazovky scoringu (samostatná, na straně klienta spouštěná cesta vyhledávání; není volána zpracováním vlastního odeslání formuláře).

## Záměr

Posoudit a zaznamenat riziko žádosti (EN0001) — pokrývající fundraisera, patrona a požadovaný dar — buď prostřednictvím ručního formuláře scoringu ověřovaného člověkem, nebo prostřednictvím automatického přepočtu low-risk skóre, tak aby k plnění mohly postoupit pouze žádosti s dostatečně nízkým rizikem nebo výslovně schválené, a aby se rizikové klasifikace promítly do záznamů blacklistu (EN0016) a kontaktu (EN0006).

## Předpoklady

- Žádost (EN0001) existuje a je adresovatelná podle svého identifikátoru.
- Pro dílčí tok ručního scoringu: Admin má oprávnění zobrazit/používat obrazovku scoringu pro danou žádost.
- Pro dílčí tok ručního scoringu: očekává se, že profil(y) žádosti fundraisera a/nebo patrona (EN0002) přidružené k žádosti (ApplicationProfile) jsou přítomny pro úplné předvyplnění polí, i když to formulář nevynucuje jako tvrdou blokující podmínku.
- Pro dílčí tok automatického low-risk scoringu: žádost byla právě uložena a její stav se změnil (nebo byla žádost nově vytvořena).

## Hlavní tok

### UC0003.1 — Ruční scoring rizika (posouzený adminem)
1. Admin: Otevře obrazovku scoringu pro konkrétní žádost (EN0001).
2. System: Načte aktuální snímek scoringu žádosti společně s identitou a profilovými daty fundraisera a patrona (EN0002) pro předvyplnění scoringového formuláře.
3. External(MVCR): Zkontroluje platnost čísel dokladů totožnosti zadaných pro fundraisera, patrona a další jmenované strany a vrátí indikátor prošel/neprošel pro každý doklad.
4. Admin: Zkontroluje předvyplněná a ověřená pole týkající se fundraisera, patrona, daru a informací o dítěti.
5. Admin: Zadá nebo upraví pole posouzení rizika, včetně klasifikace blacklistu pro fundraisera a/nebo patrona.
6. Admin: V případě potřeby přiloží podpůrné dokumenty scoringu.
7. Admin: Nastaví rozhodnutí o schválení (např. schváleno, neschváleno, nebo mezivýsledek) a formulář odešle.
8. System: Uloží veškeré nově přiložené dokumenty scoringu jako trvalé záznamy.
9. System: Uloží kompletní sadu odeslaných polí scoringu jako aktuální snímek scoringu žádosti.
10. System: Pokud byl stav žádosti v okamžiku odeslání "scoring" a rozhodnutí o schválení je "schváleno", posune stav žádosti na "scoring approved" (scoring_ok); jinak ponechá stav beze změny.
11. System: Zaznamená položku historie stavů pro žádost vždy, když se její stav změní.
12. System: Uplatní odeslanou klasifikaci blacklistu na záznam(y) kontaktu (EN0006) odpovídající e-mailové adrese fundraisera a/nebo patrona.
13. System: Spustí standardní rozeslání stavové události žádosti (notifikace a navazující zpracování) jako součást uložení žádosti — k tomu dochází při každém uložení scoringu, bez ohledu na to, zda se stav skutečně změnil.

### UC0003.2 — Automatický low-risk scoring (řízený systémem)
1. System: Zjistí, že žádost (EN0001) byla právě uložena s novým stavem a že tímto novým stavem je mezistav review ("to_check").
2. System: Shromáždí fundraisera, patrona a jejich příslušné profily žádosti (ApplicationProfile, EN0002) potřebné k výpočtu skóre.
3. System: Pokud jsou fundraiser a patron tatáž osoba, zaznamená penalizaci rizika za sebe-patronát (self-patronage), která vynutí celkové skóre na nejnižší (blokující) hodnotu.
4. System: Vyhledá existující klasifikaci blacklistu (EN0016/EN0006) pro patrona podle e-mailu a přeloží ji na příspěvek do rizikového skóre.
5. System: Pokud příspěvek na straně patrona není kladný, vyhledá indikátor rizika na základě povolání a přičte jeho příspěvek.
6. System: Vyhledá existující klasifikaci blacklistu pro fundraisera podle e-mailu a přeloží ji na příspěvek do rizikového skóre.
7. System: Vyhodnotí rizikové pásmo požadovaného daru (low/medium/high, odvozené z kategorie daru a požadované částky) a přičte jeho příspěvek.
8. System: Vyhodnotí indikátor rizika typu platby požadovaného daru a přičte jeho příspěvek.
9. System: Zkombinuje všechny příspěvky do celkového low-risk skóre, přičemž jakýkoli jednotlivý blokující příspěvek vynutí celkovou hodnotu na nejnižší (blokující) hodnotu; zaznamená rozpad podle jednotlivých komponent spolu s celkovým součtem.
10. System: Pokud chybí jakákoli požadovaná data o aktérovi nebo profilu, zaznamená celkové skóre jako nedostupné spolu s poznámkou vysvětlující chybějící data, namísto blokování uložení.
11. System: Uloží celkové low-risk skóre a jeho rozpad na žádost (EN0001), aniž by vytvořil novou revizi žádosti nebo znovu spustil úplnou validaci žádosti.

## Alternativní toky

### AF1 — Kontrola platnosti dokladu přes MVCR nedostupná
1. External(MVCR): Služba MVCR pro ověření platnosti dokladu neodpovídá nebo vyprší časový limit během validace polí ručního scoringového formuláře.
2. System: Zaznamená kontrolu jako neprůkaznou a zobrazí adminovi zprávu.
3. Admin: Pokračuje ve vyplňování a odeslání scoringového formuláře; chybějící validace neblokuje odeslání.

Výsledek: Scoringový formulář je odeslán standardně (UC0003.1 pokračuje od bodu přerušení); dotčené pole dokladu totožnosti zůstane neověřené, namísto označení jako platné nebo neplatné.

### AF2 — Brána schválení nesplněna
1. Admin: Odešle ruční scoringový formulář s rozhodnutím o schválení jiným než "schváleno" (např. neschváleno, nebo mezivýsledek), nebo v okamžiku, kdy aktuální stav žádosti není "scoring".
2. System: Uloží snímek scoringu obvyklým způsobem, ale nepostupuje stav žádosti dál.

Výsledek: Žádost zůstává ve svém předchozím stavu; snímek scoringu a případné aktualizace klasifikace blacklistu jsou přesto uloženy.

### AF3 — Koordinátorské přepsání low-risk skóre
1. Admin: Zkontroluje automaticky vypočtené low-risk skóre pro žádost v jednom z oprávněných mezistavů.
2. Admin: Pokud skóre splňuje kvalifikační práh, potvrdí rozhodnutí o low-risk a posune žádost směrem ke stavu "scoring approved" (scoring_ok).

Výsledek: Žádost postupuje cestou potvrzenou koordinátorem na základě low-risk, nikoli přes úplný ruční scoringový formulář. Evidence pro samotnou obrazovku potvrzení je Partial — je odkazována z evidence dílčího toku automatického low-risk scoringu, ale není jedním z dossierů přiřazených tomuto UC; je zde zaznamenána pouze jako protějškový bod rozhodnutí, který spotřebovává skóre vypočtené v UC0003.2.

### AF4 — Vyhledání v registru ARES (spouštěné klientem)
1. Admin: Spustí vyhledání firmy/IČO z obrazovky scoringu.
2. External(ARES): Vrátí registrová data pro dané identifikační číslo firmy.

Výsledek: Registrová data jsou zobrazena adminovi na obrazovce scoringu. Evidence je pro dossiery tohoto UC Partial: vyhledávání je dostupné z obrazovky scoringu, ale běží jako samostatná, klientem spouštěná cesta, nikoli jako součást vlastního zpracování odeslání formuláře popsaného v UC0003.1.

## Postpodmínky

- Aktuální snímek scoringu žádosti (EN0001) odráží naposledy odeslané ruční posouzení, včetně rozhodnutí o schválení.
- Stav žádosti postoupil na "scoring approved" (scoring_ok) tehdy a pouze tehdy, pokud byla splněna brána ručního schválení (stav byl "scoring" a rozhodnutí bylo "schváleno"), nebo pokud automatické low-risk skóre splnilo kvalifikační práh a bylo potvrzeno.
- Záznam(y) kontaktu (EN0006) pro fundraisera a/nebo patrona odrážejí nejnovější klasifikaci blacklistu.
- Existuje záznam blacklistu (EN0016) zaznamenávající rozhodnutí o klasifikaci učiněné během scoringu, propojený se žádostí.
- Low-risk skóre žádosti a rozpad podle komponent jsou aktuální vždy, když žádost prošla mezistavem review, bez ohledu na to, zda byl také odeslán ruční scoringový formulář.
- Pro žádost existuje položka historie stavů, pokud se v rámci tohoto případu užití změnil její stav.

## Sledovatelnost (Traceability)

Cílové SRV:
- Scoring-&-Risk
- MVCR-DocValidity-Adapter
- ARES-Registry-Adapter

EN entity:
- EN0017 ScoringRecord — snímek scoringu a low-risk skóre/rozpad produkovaný a aktualizovaný tímto UC
- EN0016 Blacklist — záznam rizikové klasifikace vytvořený pro fundraisera/patrona během ručního scoringu
- EN0001 Application — agregát, jehož stav, pole scoringu a low-risk pole toto UC čte a mění
- EN0002 ApplicationProfile — profilová data fundraisera/patrona spotřebovávaná pro předvyplnění a výpočet skóre
- EN0006 Contact — záznam strany, jehož klasifikace blacklistu je aktualizována jako vedlejší efekt

Integrační hranice:
- MVCR (vyhledání platnosti dokladu totožnosti, pouze pro čtení, v okamžiku zobrazení scoringového formuláře)
- ARES (vyhledání v registru firem/IČO, spouštěné klientem, oddělené od odeslání formuláře)

Evidence toků (Flow Evidence):
- FLW0016 (formulář ručního scoringu)
- FLW0017 (automatický low-risk scoring při změně stavu)

## Úroveň evidence

Confirmed — UC0003.1 a UC0003.2 jsou přímo doloženy prostřednictvím FLW0016 a FLW0017, oba hodnocené jako Confirmed, a jsou ukotveny v EN0001/EN0002/EN0006/EN0016/EN0017; AF3 (koordinátorské potvrzení low-risk) a AF4 (vyhledání ARES) jsou v rámci tohoto UC označeny jako Partial, jelikož jejich výchozí obrazovky/toky jsou odkazovány z přiřazených dossierů, ale nebyly samy přiřazeny k podrobnému mining.
