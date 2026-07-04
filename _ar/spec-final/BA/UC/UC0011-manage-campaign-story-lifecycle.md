---
doc_id: UC0011
title: Manage Campaign / Story Lifecycle
canonical_layer: UC
spec_type: use-case
status: canonical
modules: []
---

# UC0011 — Řízení životního cyklu kampaně / příběhu

## Záhlaví

| Pole | Hodnota |
|---|---|
| ID UC | UC0011 |
| Název | Řízení životního cyklu kampaně / příběhu |
| Ohraničený kontext | C3 |
| Primární aktér(y) | Admin, Scheduler, System |
| Typ spouštění | UI/Cron |

## Aktéři a odpovědnosti

- **Admin** — posuzuje kandidátskou kampaň (Příběh, EN0004) a spouští publikaci ("nastavit aktivní"); tím implicitně povoluje, aby se navázaná žádost (EN0001) zveřejnila.
- **Scheduler** — spouští opakovanou kontrolu životního cyklu, která bez lidského zásahu vyhledává aktivní kampaně po termínu a nedostatečně financované.
- **System** — před publikací vynucuje pravidla připravenosti, přepočítává celkovou vybranou částku, udržuje stav kampaně a jí příslušející žádosti v souladu a vyvolává vedlejší efekty (reindexace vyhledávání, notifikace) plynoucí ze změny stavu.

## Účel

Provést kampaň (příběh) jejím veřejným fundraisingovým životním cyklem — od přípravy k publikaci přes aktivní/veřejný stav až po konečný výsledek (splněno/dokončeno nebo vypršelo/nesplněno) — a přitom udržovat synchronizovaný stav navázané žádosti a informovat navazující systémy (vyhledávací index, notifikace) o každém přechodu.

## Předpoklady

- Existuje kampaň (EN0004) napojená v poměru 1:1 na žádost (EN0001) prostřednictvím reference `campaign` u žádosti.
- Kampaň nese veřejný profil patrona (EN0005), cílovou částku, termín (deadline) a požadovanou obrazovou dokumentaci, jak je evidováno entitou kampaně.
- Konající Admin má oprávnění měnit stav kampaně.

## Hlavní tok

### UC0011.1 — Admin publikuje / nastaví kampaň jako aktivní

1. Admin: požaduje publikaci kandidátské kampaně ("nastavit aktivní").
2. System: načte kampaň a zjistí její navázanou žádost; pokud navázaná žádost neexistuje, přeruší operaci s chybou.
3. System: ověří, že kampaň je připravena k aktivaci — je nastaven veřejný profil patrona, cílová částka je kladná hodnota, termín (deadline) je platný a leží v budoucnosti a jsou přítomny požadované fotografie; pokud kterákoli kontrola selže, přeruší operaci s validační chybou.
4. System: označí kampaň jako aktivní a při první aktivaci zaznamená časové razítko publikace a publikujícího Admina.
5. System: při aktivaci validuje data kampaně, včetně pravidla pro termín specifického pro trh Rumunska (viz AF1); při selhání přeruší operaci s validační chybou.
6. System: přepočítá vybranou částku kampaně a procento naplnění z potvrzených (uhrazených) příspěvků.
7. System: pokud přepočítaná vybraná částka již dosahuje cílové částky nebo ji překračuje, přejde kampaň jako vedlejší efekt tohoto uložení přímo do dokončeného výsledného stavu (viz logika dokončení v UC0011.2).
8. System: pokud se veřejný název kampaně od načtení změnil, archivuje předchozí veřejný identifikátor (slug) před vygenerováním nového.
9. System: zařadí kampaň do fronty pro reindexaci vyhledávání.
10. System: nastaví stav navázané žádosti na aktivní a zaznamená přechod do historie stavů žádosti.
11. System: uloží žádost, čímž ji zařadí do fronty pro reindexaci vyhledávání a vyvolá notifikaci o změně stavu žádosti (viz UC0011.3).
12. System: potvrdí Adminovi úspěch a obnoví cachovaný obsah tak, aby byla publikovaná kampaň okamžitě viditelná.

### UC0011.2 — Plánované přechody životního cyklu (vypršení termínu / automatické dokončení)

1. Scheduler: spustí opakovanou kontrolu životního cyklu kampaně.
2. System: identifikuje všechny aktivní kampaně, jejichž termín (deadline) již uplynul a jejichž vybraná částka je stále nižší než cílová částka.
3. System: u každé identifikované kampaně nastaví stav navázané žádosti na "campaign uncompleted" a zaznamená přechod (přiřazený automatizovanému aktérovi) do historie stavů žádosti.
4. System: uloží žádost, čímž ji zařadí do fronty pro reindexaci vyhledávání a vyvolá notifikaci o změně stavu žádosti (viz UC0011.3).
5. System: promítne změnu stavu žádosti do navázané kampaně, nastaví její stav na "campaign uncompleted" a zaznamená časové razítko nesplnění.
6. System: v rámci tohoto uložení přepočítá vybranou částku kampaně a zařadí kampaň do fronty pro reindexaci vyhledávání.
7. System: odešle notifikaci "uncompleted campaign" relevantním podporovatelům a administrátorům (viz UC0011.3).

Poznámka — Confirmed, ale automatické dokončení (kampaň dosahující nebo překračující cílovou částku) není touto plánovanou kontrolou řízeno; vyhodnocuje se při každém uložení kampaně (viz UC0011.1 krok 7) a nejčastěji je spouštěno zaznamenáním platby/příspěvku, nikoli schedulerem. Je to zde zaznamenáno proto, že dossier připravenosti pro FLW0022 výslovně opravuje počáteční hypotézu, která umísťovala automatické dokončení do plánované úlohy.

### UC0011.3 — Navazující vedlejší efekty změny stavu kampaně/žádosti

1. System: kdykoli je kampaň nebo její navázaná žádost uložena se změněným stavem, zařadí dotčenou entitu do fronty pro reindexaci vyhledávání.
2. System: kdykoli se změní stav žádosti, vyvolá notifikaci o změně stavu žádosti, kterou konzumují navazující odběratelé (messaging, scoring, další reakce).
3. System: konkrétně pro výsledný stav "campaign uncompleted" určí seznam příjemců notifikace (přispěvatelé kampaně, dohledový kontakt a pevně stanovený provozní příjemce) a odešle zprávu "uncompleted campaign" transakčním komunikačním kanálem.

## Alternativní toky

### AF1 — Validace termínu specifická pro Rumunsko blokuje aktivaci

1. System: během validace aktivace kampaně (UC0011.1 krok 5) zjistí, že nasazení je nakonfigurováno pro trh Rumunska a že termín (deadline) připadá na den vyžadující kontrolu státního svátku.
2. Integration(Nager.Date): vyžádá stav státního svátku pro datum termínu.
3. System: pokud je datum potvrzeno jako státní svátek, validace termínu selže a aktivace se přeruší s validační chybou.
4. System: pokud je samotné vyhledání svátku nedostupné nebo vyprší časový limit, den se považuje za nikoli svátek a validace pokračuje dál (fail-open).

Výsledek: Aktivace je blokována pouze tehdy, když je externí kontrola svátku dostupná a pozitivně potvrdí svátek; při selhání vyhledání se kampaň může přesto aktivovat, což je známá fail-open mezera.

### AF2 — Selhání kontrol podmiňujících aktivaci

1. Admin: požaduje publikaci kandidátské kampaně ("nastavit aktivní").
2. System: zjistí, že kampaň nemá navázanou žádost, nebo že selhala kontrola připravenosti (profil patrona, cílová částka, termín, požadované fotografie).
3. System: zobrazí Adminovi validační chybu a ponechá stav kampaně i žádosti beze změny.

Výsledek: Kampaň zůstává ve stavu před aktivací; nedochází k žádným navazujícím vedlejším efektům.

### AF3 — Částečné potvrzení (commit) mezi uložením kampaně a žádosti

1. System: dokončí uložení aktivace kampaně (UC0011.1 kroky 4–9), čímž se kampaň stane aktivní.
2. System: pokusí se uložit nový aktivní stav navázané žádosti (UC0011.1 kroky 10–11) a toto uložení selže.

Výsledek: Kampaň zůstává aktivní, zatímco její navázaná žádost nikoli — jde o známou mezeru v konzistenci, protože obě uložení nejsou zabalena do jedné transakce.

## Následné podmínky

- Při úspěšné publikaci: stav kampaně je aktivní, je zaznamenáno časové razítko publikace a publikující Admin (pouze při první aktivaci), její vybraná částka/procento naplnění jsou obnoveny a stav navázané žádosti je aktivní s odpovídajícím záznamem v historii stavů.
- Při plánovaném vypršení: stav kampaně je "campaign uncompleted" s nastaveným časovým razítkem nesplnění, její vybraná částka je obnovena a stav navázané žádosti je "campaign uncompleted" s odpovídajícím záznamem v historii stavů; byla odeslána notifikace "uncompleted campaign".
- Při dokončení financování (spuštěném z jakéhokoli uložení, včetně publikace): kampaň a její navázaná žádost dosahují dokončeného výsledného stavu (viz životní cyklus EN0004; úplné chování dokončení náleží do use case Dary/platby, nikoli do tohoto UC).
- Ve všech případech, kdy se stav změnil, je dotčená kampaň a/nebo žádost zařazena do fronty pro reindexaci vyhledávání.

## Sledovatelnost (Traceability)

Cílové SRV:
- Campaign-&-Story-Lifecycle
- Application-Status-Orchestrator
- Transactional-Messaging-Orchestrator
- SearchIndex-Processor

Entity EN:
- EN0004 Campaign — Příběh, jehož životní cyklus (rozpracováno → aktivní → dokončeno / campaign_uncompleted) tento UC řídí
- EN0001 Application — navázaný kořenový agregát, jehož `state` je udržován v souladu se stavem kampaně
- EN0005 Patron — veřejný profil patrona, jehož existence je předpokladem aktivace (v tomto UC pouze pro čtení)
- EN0028 CampaignLog — související auditní entita změn polí na úrovni jednotlivé kampaně; pro FLW0021/FLW0022 nebyl vytěžen žádný zapisující tok, proto není deklarována jako součást potvrzeného chování tohoto UC (pouze Hypothesis, dle EN0028)

Integrační hranice:
- Nager.Date (vyhledávání státních svátků, validace termínu pouze pro Rumunsko — AF1)

Důkazy z toků (Flow Evidence):
- FLW0021 (publikace kampaně / nastavení aktivní)
- FLW0022 (cron životního cyklu kampaně — vypršení termínu; automatické dokončení je křížově odkázáno, ale tímto tokem není vlastněno)

## Úroveň důkazu

Confirmed — podloženo dossiery FLW0021 a FLW0022 (oba s důvěryhodností Confirmed) vůči SRV0005 (Campaign-&-Story-Lifecycle) s průřezovými dotyky na Application-Status-Orchestrator, Transactional-Messaging-Orchestrator a SearchIndex-Processor, a v souladu s potvrzenými přechody životního cyklu zaznamenanými v EN0004 a EN0001; vazba na EN0028 CampaignLog je výslovně označena jako Hypothesis, protože ji žádný vytěžený tok nezapisuje.
