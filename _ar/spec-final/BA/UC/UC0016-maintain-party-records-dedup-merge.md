---
doc_id: UC0016
title: Maintain Party Records (Dedup / Merge)
layer: UC
spec_type: use-case
status: imported
modules: []
---

# UC0016 — Správa záznamů subjektů (Dedup / Sloučení)

## Header

| Field | Value |
|---|---|
| UC ID | UC0016 |
| Name | Maintain Party Records (Dedup / Merge) |
| Bounded Context | C7 |
| Primary Actor(s) | Admin |
| Trigger Type | UI |

## Aktéři a odpovědnosti

- **Admin** — prochází kandidátní skupiny duplicit (kontakty, organizace, leady), vybírá záznam, který má být zachován, a v back office potvrzuje akci sloučení.
- **System** — detekuje kandidáty na duplicity, přeřazuje závislé záznamy na zvolený zachovaný záznam, maže nebo nuluje záznam(y), které jsou nahrazovány, a spouští navazující efekty v podobě reindexace a stavových vedlejších účinků.
- **Scheduler** — (pouze dílčí flow organizací) spouští denní synchronizační úlohu, která odesílá aktuální registr organizací do externího vyhledávacího indexu.
- **Integration(Elasticsearch)** — externí vyhledávací index, který prostřednictvím plánované synchronizace přijímá záznamy organizací.

## Záměr

Udržovat registry subjektů (Kontakt/EN0006, Organizace/EN0018) a sloučení leadů v rámci Leadu/Žádosti (EN0001) bez duplicit tak, že administrátor identifikuje duplicitní záznamy a konsoliduje je do jednoho zachovaného záznamu, aby navazující procesy (žádosti, scoring, notifikace, vyhledávání) pracovaly s jediným kanonickým subjektem.

## Předpoklady

- Admin má oprávnění spojené s editací typu subjektu, který je slučován (oprávnění k editaci kontaktu pro dedup kontaktů; oprávnění k editaci profilu žádosti pro dedup organizací; vyhrazené oprávnění pro sloučení leadů).
- Pro dedup kontaktů: existuje alespoň jedna skupina Kontaktů (EN0006) sdílejících stejné rodné číslo, telefon nebo e-mail a tato skupina je Adminovi zobrazena.
- Pro dedup organizací: existují alespoň dva záznamy Organizace (EN0018), u kterých je předpoklad, že představují stejnou entitu.
- Pro sloučení leadů: existují dva záznamy Žádosti (EN0001) — zachovaný lead a duplicitní lead vzniklý z podnětu patrona, který nese propojený Profil žádosti.

## Hlavní tok

### UC0016.1 — Deduplikace kontaktů (sloučení)

1. Admin: Otevře obrazovku pro kontrolu duplicitních kontaktů.
2. System: Seskupí existující záznamy Kontakt (EN0006) do kandidátů na duplicitu podle shody rodného čísla, telefonu nebo e-mailu, přičemž vynechá skupiny, které se Admin dříve rozhodl přeskočit.
3. System: Transitivně rozšíří první kandidátní skupinu (na základě dalších překryvů telefonu/e-mailu/rodného čísla) a zobrazí ji jako jednu skupinu duplicit ke kontrole.
4. Admin: Zkontroluje zobrazenou skupinu a označí jeden Kontakt jako zachovaný záznam ("hlavní účet").
5. Admin: Potvrdí sloučení pro vybraný zachovaný záznam.
6. System: U každého dalšího Kontaktu ve skupině přeřadí reference Žádosti (EN0001) (kontakt leadu, dítě a — pokud je duplicita propojena s rolí fundraisera nebo patrona — odpovídající referenci subjektu) tak, aby ukazovaly na zachovaný záznam.
7. System: Přeřadí reference Profilu žádosti (role fundraiser, patron, dítě) z každého duplicitního Kontaktu na zachovaný záznam.
8. System: Přeřadí každý účet Uživatele (EN0008), jehož vlastnící Kontakt je duplicitní, tak, aby jeho reference na úrovni žádosti pro fundraisera/patrona ukazovaly na zachovaný záznam.
9. System: Smaže účet Uživatele (EN0008), který vlastnil každý duplicitní Kontakt.
10. System: Smaže každý duplicitní záznam Kontaktu, včetně jeho historie změn.
11. System: Zařadí každou přeřazenou Žádost do fronty pro reindexaci vyhledávání (SearchIndex-Processor) jako vedlejší efekt jejího uložení.
12. System: Zobrazí potvrzení o úspěchu se seznamem dotčených žádostí.

### UC0016.2 — Deduplikace organizací a správa pracovníků

1. Admin: Otevře obrazovku pro kontrolu duplicitních organizací a volitelně filtruje seznam organizací podle názvu.
2. System: Zobrazí odpovídající záznamy Organizace (EN0018) k výběru.
3. Admin: Vybere jednu Organizaci jako hlavní (zachovaný) záznam a jednu nebo více dalších Organizací jako duplicity.
4. Admin: Potvrdí sloučení.
5. System: Přeřadí referenci zaměstnavatele u každé Žádosti (EN0001), která ukazuje na duplicitní Organizaci, tak, aby ukazovala na zachovanou Organizaci.
6. System: Smaže každý duplicitní záznam Organizace.
7. System: Zobrazí potvrzení o úspěchu.
8. Admin: Otevře obrazovku správy pracovníků pro Organizaci, aby přidal nebo upravil pracovníka.
9. Admin: Odešle údaje pracovníka (jméno, e-mail, telefon, příznak admina) pro nového nebo existujícího pracovníka.
10. System: Ověří, že jméno, e-mail a telefon jsou vyplněny a mají správný formát, a — v případě nového pracovníka — že s daným e-mailem ještě neexistuje žádný Uživatel.
11. System: Propojí pracovníka s existujícím Kontaktem (EN0006) nalezeným podle e-mailu, vytvoří nebo aktualizuje odpovídajícího Uživatele (EN0008) s rolí pracovníka organizace a připojí jej k seznamu pracovníků Organizace spolu s jeho příznakem admina.
12. System: Odešle zprávu o aktivaci účtu nově vytvořenému pracovníkovi, jehož účet ještě není aktivní.
13. System: Zařadí uloženou Organizaci do fronty pro reindexaci vyhledávání jako vedlejší efekt jejího uložení.

### UC0016.3 — Plánovaná synchronizace vyhledávání organizací

1. Scheduler: Spustí denní synchronizační úlohu organizací, jakmile uplyne nastavený interval.
2. System: Načte úplný aktuální seznam záznamů Organizace (EN0018).
3. Integration(Elasticsearch): Přijme upsert každého záznamu Organizace ({id, name}) do externího vyhledávacího indexu organizací.

### UC0016.4 — Sloučení leadů

1. Admin: Otevře obrazovku sloučení leadů a zadá ID zachovaného hlavního leadu a ID duplicitního leadu vzniklého z podnětu patrona.
2. System: Ověří, že obě ID odpovídají existujícím záznamům Žádosti (EN0001) a že duplicitní lead nese propojený Profil žádosti.
3. Admin: Potvrdí sloučení.
4. System: Zkopíruje referenci na Profil žádosti — a pokud existuje, propojenou referenci Uživatele-patrona — z duplicitního leadu na hlavní lead, přičemž vlastní stav hlavního leadu ponechá beze změny, a uloží hlavní lead.
5. System: Pokud hlavní lead již referenci na Profil žádosti obsahuje, bezpodmínečně ji přepíše referencí z duplicitního leadu; předchozí reference není zachována a stává se přes hlavní lead nedosažitelnou (tichá ztráta dat na úspěšné cestě, nezávislá na jakémkoli selhání). Evidence: FLW0025 (Failure Mode #2, Confirmed).
6. System: Nastaví stav duplicitního leadu na "duplicate", vymaže jeho reference na Profil žádosti, profil fundraisera, fundraisera, patrona a dítě a uloží duplicitní lead.
7. System: Zaznamená položku historie stavů pro přechod duplicitního leadu do stavu "duplicate".
8. System: Zařadí obě uložené Žádosti do fronty pro reindexaci vyhledávání jako vedlejší efekt jejich uložení.
9. System: Zobrazí potvrzení, že leady byly úspěšně sloučeny.

## Alternativní toky

### AF1 — Admin se rozhodne přeskočit skupinu duplicitních kontaktů namísto sloučení

1. Admin: Označí zobrazené kritérium duplicity kontaktu (shodné rodné číslo, telefon nebo e-mail) k vyloučení z budoucí detekce duplicit.
2. System: Zaznamená vyloučení, takže odpovídající skupina již není nadále nabízena ke kontrole.

Výsledek: Kandidátní skupina je potlačena z budoucích obrazovek deduplikace; žádné záznamy Kontaktů nejsou změněny ani smazány.

### AF2 — Výběr zachovaného záznamu leží mimo aktuálně zobrazenou skupinu

1. Admin: Odešle ID zachovaného Kontaktu, které nepatří do aktuálně zobrazené skupiny duplicit.
2. System: Odmítne sloučení se zprávou o interní chybě a neprovede žádnou akci.

Výsledek: Žádný záznam Kontaktu, Žádosti, Profilu žádosti ani Uživatele není změněn; Admin musí znovu otevřít obrazovku kontroly, aby získal nově zobrazenou skupinu.

### AF3 — Validace sloučení leadů selže

1. Admin: Odešle ID duplicitního leadu, jehož Žádost nenese propojený Profil žádosti, nebo ID, které neodpovídá existující Žádosti.
2. System: Odmítne sloučení s validační zprávou a neprovede žádnou akci.

Výsledek: Žádná ze zúčastněných Žádostí není upravena; Admin musí opravit vstup a odeslat jej znovu.

### AF4 — Selhání uprostřed sloučení zanechá částečně konsolidovaný stav

1. System: Narazí na chybu poté, co přeřadil některé, ale ne všechny závislé reference během sloučení kontaktu, organizace nebo leadu (sekvence přeřazení a mazání není kryta žádnou zárukou typu vše-nebo-nic).
2. System: Zobrazí obecnou chybovou zprávu; dříve dokončená přeřazení nebo smazání v rámci téhož pokusu o sloučení nejsou vrácena zpět.

Výsledek: Status `Confirmed` — sekvence sloučení není v žádném ze tří dílčích toků doložena jako transakční; selhání uprostřed procesu může zanechat některé reference ukazující na zachovaný záznam a jiné stále ukazující na odstraněný nebo nahrazený záznam. Toto je zaznamenáno jako pozorované chování současného stavu, nikoli jako doporučení pro cílový stav.

Riziko rozsahu přeřazení (sloučení organizací, `Confirmed`): i při plně úspěšném sloučení organizací (UC0016.2) je na zachovaný záznam přeřazena pouze reference zaměstnavatele u Žádosti (EN0001); reference na duplicitní Organizaci (EN0018), které nesouvisejí se zaměstnavatelem — například odkazy na pracovníky vedené v seznamu pracovníků Organizace — nejsou nikdy přeřazeny a po smazání duplicitu zůstávají nedosažitelné (dangling). Evidence: FLW0024 (Failure Mode #2, Confirmed).

## Postconditions

- Zachovaný Kontakt, Organizace nebo hlavní Žádost drží konsolidovanou sadu referencí, dříve rozdělenou mezi duplicitní záznam(y).
- Duplicitní záznamy Kontaktů a jejich historie změn jsou trvale odstraněny; účet Uživatele, který vlastnil duplicitní Kontakt, je trvale odstraněn.
- Duplicitní záznamy Organizací jsou trvale odstraněny; zaručeně přeřazena na zachovaný záznam je pouze reference zaměstnavatele u Žádosti.
- Stav Žádosti duplicitního leadu je nastaven na "duplicate" a jeho reference na subjekty jsou vymazány; vlastní stav hlavního leadu zůstává beze změny.
- Každá Žádost nebo Organizace dotčená sloučením je zařazena do fronty pro reindexaci vyhledávání.
- Nově propojení nebo vytvoření pracovníci organizace existují jako záznamy Uživatele s rolí pracovníka organizace a jsou připojeni k seznamu pracovníků Organizace.
- Externí vyhledávací index organizací odráží úplný aktuální registr Organizací po každém plánovaném synchronizačním běhu.

## Traceability

Cílové SRV:
- Party-&-Contact-Management
- Application-Lifecycle
- Identity-&-Access
- SearchIndex-Processor

EN entity:
- EN0006 Contact — záznam subjektu deduplikovaný/slučovaný v UC0016.1; zdroj přeřazení rolí na Žádosti a Profily žádosti.
- EN0018 Organisation — záznam subjektu deduplikovaný/slučovaný a spravovaný z hlediska pracovníků v UC0016.2; externě synchronizovaný v UC0016.3.
- EN0001 Application — nese reference (kontakt leadu, dítě, zaměstnavatel, profil fundraiser/patron) přeřazované všemi třemi dílčími toky sloučení; cíl/předmět sloučení v UC0016.4.
- EN0008 User — účet přeřazovaný, mazaný nebo vytvářený jako důsledek sloučení kontaktů a správy pracovníků organizace.
- EN0002 ApplicationProfile — přeřazován v UC0016.1, referencován/kopírován/mazán v UC0016.4; přilehlý (dotčený, ale sám touto UC nededuplikovaný).

Integrační hranice:
- Integration(Elasticsearch) — externí vyhledávací index organizací (denní synchronizace UC0016.3); odlišný od obecné fronty reindexace SearchIndex-Processor používané v UC0016.1/.2/.4.

Evidence flow:
- FLW0023 (Deduplikace / sloučení kontaktů)
- FLW0024 (Deduplikace organizací + správa pracovníků)
- FLW0025 (Sloučení leadů)

## Evidence Level

Confirmed — všechny tři dílčí toky jsou podloženy dossiery toků s úrovní jistoty Confirmed (FLW0023, FLW0024, FLW0025) s pojmenovanými spouštěči, seřazenými kroky a evidencí datové stopy; sekce životního cyklu EN0006, EN0018, EN0001 a EN0008 nezávisle potvrzují přechody sloučení/přeřazení/smazání a vedlejší efekt SearchIndex-Processor, na který se zde odkazuje jako na Confirmed podle matice sledovatelnosti SRV (UC-srv-traceability.md).
