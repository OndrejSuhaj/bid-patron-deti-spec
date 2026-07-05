---
doc_id: UC0019
title: Import Invoices from OneDrive
layer: UC
spec_type: use-case
status: imported
modules: []
---

# UC0019 — Import faktur z OneDrive

## Header

| Field | Value |
|---|---|
| UC ID | UC0019 |
| Name | Import Invoices from OneDrive |
| Bounded Context | C6 |
| Primary Actor(s) | Scheduler, Integration(OneDrive) |
| Trigger Type | CLI |

## Aktéři a odpovědnosti

- **Scheduler** — spouští příkaz pro import faktur pravidelně nebo ad-hoc (ruční spuštění operátorem nebo externí plánovací mechanismus; napojení na interní cron není evidováno).
- **Integration(OneDrive)** — hostuje sdílenou složku s fakturami v cloudovém úložišti a zpřístupňuje její obsah (výpis souborů, stažení souboru) přes Microsoft Graph API.
- **System** — autentizuje se vůči integraci, vypisuje a filtruje příchozí soubory s fakturami, přiřazuje každý soubor ke kampani (EN0004), ukládá fakturu jako přílohu k související žádosti (EN0001) a spouští navazující zpracování stavu/vedlejších efektů.

## Záměr

Automaticky stahovat nově vložené faktury ze sdílené cloudové složky a připojovat každou fakturu ke správnému záznamu žádosti (EN0001) prostřednictvím přiřazené kampaně (EN0004), aby finanční/back-office pracovníci nemuseli soubory s fakturami stahovat a nahrávat ručně.

## Předpoklady

- Lze navázat platné spojení s Integration(OneDrive) (platné přihlašovací údaje/autorizace pro nakonfigurovaný účet úložiště).
- Cílová sdílená složka v Integration(OneDrive) je dostupná a obsahuje nula nebo více kandidátních souborů.
- Operátor/scheduler spouští import v režimu „persist" (na rozdíl od režimu dry-run/pouze výpis), aby se jakákoli příloha skutečně uložila.
- Název každého souboru s fakturou kóduje identifikátor kampaně (EN0004) podle implicitní konvence pojmenování.

## Hlavní tok

### UC0019.1 — Autentizace a výpis souborů s fakturami
1. Scheduler: zahájí naplánované nebo ruční spuštění importní úlohy faktur, volitelně omezené maximálním počtem položek.
2. System: vyžádá si přístupový token od poskytovatele identity jménem nakonfigurovaného servisního účtu.
3. Integration(OneDrive): vydá přístupový token pro nakonfigurovaný účet úložiště.
4. System: vyžádá si výpis položek v nakonfigurované sdílené složce s fakturami, až do nakonfigurovaného limitu počtu položek.
5. Integration(OneDrive): vrátí seznam položek ve složce (názvy souborů a metadata).

### UC0019.2 — Přiřazení a připojení každé faktury k žádosti
1. System: pro každou vrácenou položku ji zahodí, pokud její název souboru neindikuje fakturový dokument (jiný než PDF).
2. System: odvodí odkaz na kampaň (EN0004) z názvu souboru s fakturou podle konvence pojmenování.
3. System: vyhledá kampaň (EN0004) podle odvozeného odkazu.
4. System: přeskočí položku a zaznamená chybu, pokud není nalezena odpovídající kampaň (EN0004).
5. System: přeskočí uložení položky, pokud je běh v režimu pouze výpisu (dry-run).
6. Integration(OneDrive): poskytne obsah souboru s fakturou ke stažení.
7. System: stáhne obsah faktury a uloží jej jako nový soubor přílohy.
8. System: přiřadí žádost (EN0001) asociovanou s kampaní (EN0004).
9. System: připojí novou přílohu do kolekce fakturových příloh žádosti (EN0001).
10. System: uloží žádost (EN0001) bez vytvoření nové revize.
11. System: spustí zpracování stavu/vedlejších efektů žádosti popsané v UC0002 (Application-Status-Orchestrator) jako důsledek uložení žádosti (EN0001), i když se změnila pouze kolekce příloh.

## Alternativní toky

### AF1 — Selhání autentizace
1. Integration(OneDrive): odmítne požadavek na přístupový token (neplatné nebo vypršelé přihlašovací údaje servisního účtu).
2. System: přeruší celý průběh importu bez zpracování jakýchkoli souborů.

Výsledek: v rámci tohoto běhu nejsou importovány žádné faktury; selhání se v rámci běhu automaticky neopakuje.

### AF2 — Selhání výpisu složky nebo stažení souboru
1. Integration(OneDrive): nevrátí výpis složky, nebo nevrátí obsah souboru při stahování.
2. System: přeruší zpracování (u selhání výpisu se zastaví celý běh; u selhání stažení jednoho souboru se zastaví zpracování jen dané položky).

Výsledek: výsledky importu pro daný běh jsou částečné nebo žádné; položky již zpracované v rámci téhož běhu zůstávají uloženy.

### AF3 — Nepřiřaditelný odkaz na kampaň z názvu souboru
1. System: odvodí z názvu souboru odkaz na kampaň (EN0004), který neodpovídá žádné existující kampani (EN0004).
2. System: zaznamená chybu pro danou položku a pokračuje další položkou.

Výsledek: soubor s fakturou není importován; žádná žádost (EN0001) není u této položky změněna.

### AF4 — Kampaň bez přiřazené žádosti
1. System: úspěšně přiřadí kampaň (EN0004), avšak nenalezne k ní žádnou přiřazenou žádost (EN0001).
2. System: nedokončí krok připojení přílohy pro danou položku (evidence naznačuje, že tento případ není ošetřen a může přerušit zpracování dané položky).

Výsledek: soubor s fakturou není připojen; tento stav je evidován jako riziko defektu, nikoli jako navržený alternativní výsledek. Evidence Level: Partial.

### AF5 — Opakovaný import již importované faktury
1. Scheduler: znovu spustí importní úlohu nad složkou obsahující dříve importovaný soubor s fakturou.
2. System: opakuje kroky přiřazení a připojení pro tentýž soubor bez kontroly předchozího importu.
3. System: připojí duplicitní odkaz na přílohu do stejné kolekce fakturových příloh žádosti (EN0001).

Výsledek: žádost (EN0001) skončí s duplicitním záznamem přílohy; nebyla evidována žádná pojistka idempotence. Evidence Level: Partial.

## Postconditions (výsledný stav)

- Existuje nula nebo více nových souborů příloh, každý propojený s žádostí (EN0001), která byla přiřazena prostřednictvím kampaně (EN0004) pojmenované ve zdrojové složce.
- Každá úspěšně zpracovaná žádost (EN0001) má rozšířenou kolekci fakturových příloh a je uložena bez nové revize.
- Uložení každé úspěšně zpracované žádosti (EN0001) spouští standardní rozvětvení zpracování stavu/vedlejších efektů žádosti (dle UC0002), včetně navazujícího zpracování notifikací a přeindexování vyhledávání, i když se změnila pouze příloha.
- Položky, jejichž název souboru se nepodařilo přiřadit k existující kampani (EN0004), nebo jejichž kampaň (EN0004) nemá přiřazenou žádnou žádost (EN0001), zůstávají nezpracované a jsou zaznamenány jako chyby.
- Po zpracování není zaručeno žádné vyčištění dočasně staženého obsahu.

## Traceability (návaznost)

Cílové SRV:
- OneDrive-Graph-Adapter
- Application-Status-Orchestrator

EN entity:
- EN0001 Application — přijímá importovanou fakturu jako přílohu a je znovu uložena, čímž spouští zpracování stavu/vedlejších efektů
- EN0004 Campaign — přiřazena z názvu souboru s fakturou; použita k dohledání cílové žádosti

Integrační hranice:
- OneDrive (přes Microsoft Graph API) — výpis souborů a stahování obsahu

Flow Evidence (evidence toku):
- FLW0028 (OneDrive invoice import)

## Evidence Level (úroveň evidence)

Confirmed — podloženo FLW0028 (úroveň jistoty Confirmed) mapovaným na SRV0019/OneDrive-Graph-Adapter a SRV0002/Application-Status-Orchestrator dle UC-srv-traceability.md, řádek 76, přičemž chování entit je potvrzeno EN0001 (kolekce fakturových příloh, rozvětvení stavu spouštěné uložením) a EN0004 (vztah kampaně a žádosti); rizika chybějící idempotence a chybějícího ošetření neexistující žádosti jsou označena jako Partial dle vlastních anotací jistoty v podkladovém dossieru a jsou zde uvedena jako AF4/AF5, nikoli tvrzena jako navržené chování.
