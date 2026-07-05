---
doc_id: UC0017
title: Export Reporting Data (CSV)
layer: UC
spec_type: use-case
status: imported
modules: []
---

# UC0017 — Export reportovacích dat (CSV)

## Hlavička

| Pole | Hodnota |
|---|---|
| ID UC | UC0017 |
| Název | Export reportovacích dat (CSV) |
| Ohraničený kontext | C5 |
| Primární aktér(y) | Admin, Scheduler |
| Typ spouštění | UI/Cron |

## Aktéři a odpovědnosti

- **Admin** — autentizovaný uživatel back-office, který otevře seznam ke stažení a na vyžádání požádá o konkrétní reportovací export.
- **Scheduler** — denní automatizovaná úloha, která bez lidského zásahu vytváří standardní sadu reportovacích exportů.
- **Systém** — vyhodnocuje oprávnění, čte zdrojové záznamy, sestavuje obsah CSV a vrací/ukládá výsledný soubor.

## Záměr

Umožnit administrátorům přístup ke konsolidovaným, stažitelným CSV výstupům dat o darech, žádostech a smlouvách pro účely finančního, rizikového a kampaňového reportingu — buď automaticky obnovovaným jednou denně, nebo generovaným na vyžádání — bez úpravy jakéhokoli doménového záznamu.

## Předpoklady

- Aktér Admin je autentizován a má oprávnění vyžadované pro požadovanou kategorii exportu (obecný přístup k reportingu, přístup specifický pro leady nebo přístup specifický pro účetnictví, podle typu exportu).
- U naplánovaných běhů ještě denní export pro aktuální den neproběhl.
- Podkladová data (Application EN0001, ApplicationProfile EN0002, Contact EN0006, Transaction EN0009, Campaign EN0004, Contract EN0011) již existují z předchozích procesních toků (příjem žádosti, zpracování daru, uzavírání smlouvy).

## Hlavní tok

### UC0017.1 — Naplánovaná denní dávka exportu

1. Scheduler: v okně denního exportu ověří, zda dávka exportu pro dnešní den již proběhla.
2. Systém: pokud dnes ještě žádná dávka neproběhla, spustí denní dávku exportu pokrývající celou standardní sadu reportovacích exportů (platby, podporovatelé, dárkové poukazy, účetnictví, leady, kampaně, patroni, fundraiseři, úhrady darů, smlouvy, výsledky scoringu/rizika, položky blacklistu, souhrny za regiony).
3. Systém: pro každý standardní export v dávce zahodí jakýkoli dříve vygenerovaný soubor pro daný export z předchozího dne i z dnešního dne (pokud již existuje).
4. Systém: pro každý standardní export přečte relevantní záznamy — Application (EN0001), ApplicationProfile (EN0002), Contact (EN0006), Transaction (EN0009), Campaign (EN0004), Contract (EN0011) podle toho, co je pro daný export relevantní — a sestaví CSV soubor s pevnou hlavičkou sloupců a jedním řádkem na každý odpovídající záznam.
5. Systém: uloží sestavený CSV soubor, pojmenovaný podle typu exportu a aktuálního data, pro opětovné použití v rámci stejného dne.
6. Systém: zaznamená log dokončení pro každý export v dávce.
7. Systém: pokud jednotlivý export v dávce selže, zaloguje selhání a pokračuje se zbývajícími exporty v dávce.

Výsledek: až šestnáct standardních reportovacích CSV souborů je obnoveno jednou za kalendářní den, připraveno k poskytnutí administrátorům bez opětovného dotazování.

### UC0017.2 — Export na vyžádání

1. Admin: otevře stránku se seznamem ke stažení zobrazující dostupné odkazy na reportovací exporty.
2. Systém: ověří, že Admin má oprávnění vyžadované pro kategorii exportu, která se zobrazuje (obecný reporting, leady nebo účetnictví).
3. Admin: vybere jeden konkrétní odkaz na export (např. platby, podporovatelé, leady, účetnictví, smlouvy, kampaně, patroni, fundraiseři, blacklist, výsledek scoringu, souhrn za region).
4. Systém: ověří, zda pro požadovaný export již existuje soubor z dnešního dne (vytvořený dříve naplánovanou dávkou nebo dřívějším požadavkem na vyžádání).
5. Systém: pokud soubor z dnešního dne existuje, poskytne tento soubor Adminovi ke stažení jako CSV bez opětovného čtení zdrojových záznamů.
6. Systém: pokud soubor z dnešního dne neexistuje, přečte relevantní záznamy pro požadovaný export — Application (EN0001), ApplicationProfile (EN0002), Contact (EN0006), Transaction (EN0009), Campaign (EN0004), Contract (EN0011) podle toho, co je relevantní — a sestaví nový CSV soubor.
7. Systém: u exportů souvisejících s platbami zúží sestavené řádky na Campaign (EN0004) určenou volitelným filtrem kampaně, pokud jej Admin zadal.
8. Systém: uloží nově sestavený soubor pro opětovné použití v rámci stejného dne a streamuje jej Adminovi ke stažení jako CSV.
9. Systém: pokud čtení záznamů nebo sestavení souboru selže, zobrazí Adminovi chybovou zprávu namísto stažení.

Výsledek: Admin obdrží CSV soubor pro požadovaný reportovací export, buď nově sestavený, nebo znovu použitý z cache aktuálního dne.

### UC0017.3 — Přístup k reportovacímu read-modelu (dashboardy)

1. Admin: otevře pohled reportovacího dashboardu.
2. Systém: přečte dříve zachycené reportovací hodnoty — měsíční záznamy nákladů/cílů (CostsSnapshot, EN0031) a pojmenované metriky k danému okamžiku (ReportSnapshot, EN0032) — filtrované na požadovaný datový rozsah.
3. Systém: vykreslí dashboard s použitím získaných hodnot.

Výsledek: Admin vidí agregované reportovací hodnoty nezávisle na CSV exportních souborech; tento dílčí tok je nyní doložen vytěženým dossier reportovacího read-modelu (FLW0031) a je popsán pouze na úrovni schopnosti (capability level).

## Alternativní toky

### AF1 — Zamítnutí oprávnění

1. Admin: pokusí se otevřít odkaz na export pro kategorii, kterou jeho přidělené oprávnění nepokrývá.
2. Systém: požadavek zamítne a soubor nevytvoří ani nevrátí.

Výsledek: žádný export není vygenerován; Admin vidí výsledek „přístup odepřen".

### AF2 — Podkladové úložiště nedostupné

1. Systém: pokusí se uložit nebo načíst sestavený obsah CSV a úložiště je nedostupné nebo nezapisovatelné.
2. Systém: zaloguje selhání.
3. Systém: vrátí chybu Adminovi (u exportu na vyžádání), nebo pro danou dávku ponechá standardní export chybějící (u naplánovaného exportu), aniž by to ovlivnilo jakýkoli doménový záznam.

Výsledek: export pro daný běh chybí nebo je neúplný; žádná doménová data se nemění.

### AF3 — Export plateb filtrovaný podle kampaně

1. Admin: požádá o export související s platbami se specifickým filtrem Campaign (EN0004).
2. Systém: sestaví export omezený na záznamy Transaction (EN0009) přiřazené k dané kampani.

Výsledek: Admin obdrží podmnožinu exportu plateb omezenou na danou kampaň místo úplné sady dat.

## Postconditions (výsledný stav)

- Pro aktuální den existuje nula nebo více CSV exportních souborů, jeden na typ exportu, dostupných k opakovanému stažení v rámci téhož dne bez opětovného sestavování.
- Žádný záznam Application (EN0001), ApplicationProfile (EN0002), Contact (EN0006), Transaction (EN0009), Campaign (EN0004) ani Contract (EN0011) není tímto use case vytvořen, aktualizován ani převeden do jiného stavu — z hlediska doménových entit jde o čtení bez zápisu (read-only).
- Ke každému dokončenému nebo neúspěšnému exportu v naplánované dávce existuje záznam v logu.
- Exportovaný obsah CSV a nakládání s citlivými daty se řídí BR-ReportingAndDataAccess § Sensitive-data handling (current-state) (BR-ReportingAndDataAccess — export osobních údajů (PII) bez další ochrany).
- Rozsah exportu z hlediska tenantu/země se řídí BR-MultiTenantCountryScoping § Cross-tenant data-path scoping (current-state) (BR-MultiTenantCountryScoping — exporty jsou globální, bez filtrování podle země).

## Traceability (dohledatelnost)

Cílové SRV:
- Reporting-ReadModel
- CSV-Export-Processor

EN entity:
- EN0009 Transaction — exportované řádky plateb, podporovatelů, dárkových poukazů a účetnictví
- EN0001 Application — exportované řádky leadů, kampaní na žádost, patronů, fundraiserů, úhrad darů, smluv, scoringu, blacklistu a souhrnů za region
- EN0002 ApplicationProfile — pole profilu připojená do exportů daru/patrona/fundraisera
- EN0006 Contact — osobní údaje (PII) (jméno, identifikační číslo, telefon, e-mail, adresa) připojené do několika exportů
- EN0004 Campaign — atribuce kampaně a volitelný filtr pro exporty plateb
- EN0011 Contract — identifikátory smluv připojené do exportů souvisejících se smlouvami
- EN0031 CostsSnapshot — měsíční hodnoty nákladů/cílů z read-modelu za reportovacími dashboardy (UC0017.3)
- EN0032 ReportSnapshot — pojmenované metriky k danému okamžiku z read-modelu za reportovacími dashboardy (UC0017.3)

Integrační hranice:
- Žádné (žádná integrace na externí systém; jedinou hranicí je lokální úložiště pro export, které se používá k uložení a opětovnému poskytování CSV souborů).

Pravidla BR:
- BR-ReportingAndDataAccess — reporting pouze pro čtení, kontrola oprávnění v okamžiku požadavku a nakládání s citlivými údaji (PII) v exportovaných souborech.
- BR-MultiTenantCountryScoping — absence rozlišení podle země CZ/RO/MD u exportů (exporty jsou globální napříč tenanty).

Evidence toků:
- FLW0027 (vytěženo) — naplánovaná i na vyžádání spouštěná dávka CSV exportu, pokrývá UC0017.1, UC0017.2, AF1, AF2, AF3.
- FLW0031 (vytěženo; dříve flow-index FL034) — reportovací dashboardy / read-model za Reporting-ReadModel, pokrývá UC0017.3; strana čtení (`/admin/reports/*`) je nyní doložena jako řadiče pouze pro čtení typu SELECT-and-render (bez zápisů).

## Evidence Level (úroveň evidence)

Confirmed pro UC0017.1/.2 a AF1–AF3 (CSV-Export-Processor / exportní část SRV0010, FLW0027, EN0001/EN0002/EN0004/EN0006/EN0009/EN0011). Confirmed pro UC0017.3 (Reporting-ReadModel / čtecí část SRV0010, EN0031/EN0032), nyní, když je tok reportovacího read-modelu vytěžen (FLW0031). Poznámka: FLW0031 potvrzuje, že reportovací hodnoty se počítají při požadavku na stránku (bez materializace read-modelu / cronu) a že `snapshot_entity` ve skutečnosti nečte žádný řadič reportu — CostsSnapshot (EN0031) se čte přes `costs_entity`, ReportSnapshot (EN0032) je nezávislá CRUD entita bez volajícího reportu. Jde o korekci modelování současného stavu, nikoli o mezeru v evidenci.
