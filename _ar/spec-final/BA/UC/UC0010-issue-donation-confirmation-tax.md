---
doc_id: UC0010
title: Issue Donation Confirmation (Tax)
layer: UC
spec_type: use-case
status: imported
modules: []
---

# UC0010 — Vystavení potvrzení o daru (daňové)

## Header

| Field | Value |
|---|---|
| UC ID | UC0010 |
| Name | Issue Donation Confirmation (Tax) |
| Bounded Context | C6 |
| Primary Actor(s) | Customer, System, Integration(Mautic) |
| Trigger Type | UI/API |

## Aktéři a odpovědnosti

- **Zákazník** — žádá o daňově uznatelné potvrzení o daru za minulý rok, a to buď jako přihlášený dárce, nebo jako anonymní žadatel, který uvede identifikační údaje a e-mailovou adresu.
- **Systém** — validuje požadavek, vypočítá součet uhrazených darů dárce za požadovaný rok, uloží snímek záznamu potvrzení o daru (EN0014), vyrenderuje jej do PDF a odešle e-mailem, přičemž odeslání archivuje.
- **Admin** — do samotného procesu vystavení potvrzení není přímo zapojen; má v administraci přehled o vystavených potvrzeních a archivovaných e-mailech (v evidenci tohoto flow nebyla pozorována žádná vyhrazená akce admina).
- **Integrace (Mautic)** — přenáší e-mail s potvrzením a jako vedlejší efekt odeslání založí/aktualizuje příjemce jako marketingový kontakt.

## Záměr

Umožnit dárci (nebo osobě žádající jménem dárce prostřednictvím e-mailu) získat oficiální dokument potvrzení o daru za daný rok, vypočtený z jeho skutečně uhrazených darů, doručený e-mailem ve formátu PDF.

## Předpoklady

- K požadavku lze přiřadit uživatele (EN0008) — buď aktuálně přihlášeného uživatele, nebo uživatele nalezeného podle zadané e-mailové adresy (anonymní cesta).
- Zadaná e-mailová adresa je syntakticky platná (pouze u cesty přes webový formulář).
- U cesty přes API musí být v požadavku uveden buď identifikátor kampaně, nebo rok potvrzení.
- Součet uhrazených transakcí (EN0009) přiřazeného uživatele za požadovaný rok (volitelně omezený na konkrétní kampaň) je větší než nula; jinak požadavek není vyřízen.

## Hlavní tok

### UC0010.1 — Vyžádání a validace potvrzení o daru (CZ)
1. Zákazník: Odešle požadavek na potvrzení o daru prostřednictvím veřejného webového formuláře, přičemž uvede typ žadatele (fyzická nebo právnická osoba), identifikační údaje a cílový rok.
2. Systém: Validuje identifikační pole specifická pro daný typ žadatele (fyzická osoba: jméno a příjmení a rodné číslo; právnická osoba: název a IČO) a požadovaný rok.
3. Systém: Přiřadí cílového uživatele (EN0008) — u anonymního požadavku podle zadaného e-mailu, nebo jako aktuálně přihlášeného uživatele.
4. Systém: Vypočítá celkovou částku uhrazených darů uživatele a datum posledního daru za požadovaný rok (volitelně omezené na konkrétní kampaň), na základě uhrazených transakcí (EN0009).
5. Systém: Pokud je vypočtený součet darů nulový, požadavek přeruší bez vystavení potvrzení.

### UC0010.2 — Vygenerování a vystavení dokumentu potvrzení (CZ)
1. Systém: Vytvoří a uloží snímek záznamu potvrzení o daru (EN0014) zachycující jméno a adresu žadatele, identifikační číslo, vypočtený součet darů, částku slovy a rok potvrzení.
2. Systém: Vyrenderuje snímek potvrzení do PDF dokumentu daňového potvrzení pomocí CZ šablony potvrzení.
3. Integrace (Mautic): Doručí vyrenderované PDF potvrzení jako přílohu e-mailu na adresu žadatele.
4. Systém: Uloží záznam EmailArchive (EN0022) o odeslaném e-mailu bez ohledu na výsledek doručení.

### UC0010.3 — Požadavek přes API (kanál SPA)
1. Zákazník: Odešle požadavek na potvrzení o daru prostřednictvím API kanálu, přičemž uvede identifikátor kampaně nebo rok potvrzení a identifikační údaje.
2. Systém: Přiřadí cílového uživatele (EN0008) z autentizované relace, nebo podle identifikátoru uvedeného v požadavku.
3. Systém: Provede stejný výpočet součtu, uložení potvrzení, generování PDF a odeslání e-mailu jako v UC0010.1–UC0010.2.

## Alternativní toky

### AF1 — Nulový součet darů za požadovaný rok
1. Systém: Vypočítá nulový součet pro přiřazeného uživatele a požadovaný rok.
2. Systém: Nevytvoří záznam DonationConfirmation (EN0014) a neodešle e-mail.

Výsledek: Potvrzení není vystaveno; zákazník nedostane žádný dokument za rok, ve kterém nemá žádné kvalifikující uhrazené dary.

### AF2 — Potvrzení je uloženo, ale doručení dokumentu selže
1. Systém: Uloží snímek DonationConfirmation (EN0014) ještě před pokusem o vyrenderování a odeslání dokumentu.
2. Systém: Narazí na chybu při renderování nebo přenosu PDF (například nedostupný vložený obrázek podpisu).

Výsledek: Existuje záznam DonationConfirmation (EN0014), aniž by byl odeslán odpovídající e-mail — z pohledu zákazníka jde o částečný, tiše neúplný výsledek.

### AF3 — Opakované požadavky pro téhož dárce/rok
1. Zákazník: Odešle stejný požadavek na potvrzení o daru (stejný dárce, stejný rok) vícekrát.
2. Systém: Zpracuje každý požadavek nezávisle a pokaždé vystaví samostatné DonationConfirmation (EN0014) a samostatný e-mail.

Výsledek: Pro téhož dárce/rok je vystaveno více dokumentů potvrzení a e-mailů; neexistuje žádná deduplikace ani pojistka idempotence.

### AF4 — RO deklarace přesměrování daně (přilehlá varianta pro danou zemi) — Partial evidence
1. Zákazník: Odešle deklaraci přesměrování daně ("2 %") prostřednictvím samostatného RO-specifického formuláře, namísto CZ požadavku na potvrzení.
2. Systém: Ze zadaných dat vytvoří záznam Contract a záznam deklarace TaxPayer.
3. Systém: Připojí zadaná data deklarace do konsolidovaného exportního souboru používaného pro pozdější podání.

Výsledek: Existuje podepsaná deklarace přesměrování daně a záznam TaxPayer; negeneruje se žádné PDF DonationConfirmation (EN0014) a nečte se žádný součet uhrazených transakcí — jde o odlišný mechanismus od výše popsané CZ cesty dokumentu potvrzení, nikoli o jeho lokalizovanou variantu. Označeno jako **Partial** — tento dílčí tok je doložen pouze jako odkaz na přilehlý flow v dossieru FLW0009 a nebyl samostatně vytěžen; entity Contract a TaxPayer jsou z hlavní Traceability tohoto UC záměrně vynechány a jsou zmíněny pouze zde.

## Postconditions (výsledný stav)

- Záznam DonationConfirmation (EN0014) existuje jako neměnný snímek identifikačních údajů žadatele a vypočteného součtu darů za daný rok, kdykoli byl součet darů větší než nula.
- Ze snímku byl vygenerován PDF dokument daňového potvrzení, pokud renderování dokumentu proběhlo úspěšně.
- Existuje záznam EmailArchive (EN0022) o pokusu o odeslání, bez ohledu na to, zda daný přenos zprávu skutečně doručil.
- V rámci tohoto use case nedochází k žádné změně žádného záznamu Transaction (EN0009); transakce jsou pouze čtené vstupy pro výpočet součtu.

## Traceability (trasovatelnost)

Cílové SRV:
- Document-Generation-&-Fulfilment
- Payment-Processing
- Transactional-Messaging-Orchestrator

Entity EN:
- EN0014 DonationConfirmation — vystavený snímek/dokumentový záznam, který toto UC produkuje
- EN0008 User — přiřazený dárce/žadatel, jehož dary jsou potvrzovány
- EN0009 Transaction — pouze čtený zdroj součtu uhrazených darů za daný rok
- EN0022 EmailArchive — archivní záznam odeslání e-mailu s potvrzením

Integrační hranice:
- Mautic (přenos e-mailu a založení/aktualizace marketingového kontaktu při odeslání)

Evidence Flow:
- FLW0009 (dokument daňového potvrzení o daru — CZ webový formulář + cesty API/SPA; přilehlost RO přesměrování daně uvedena jako Partial/nevytěženo v rámci téhož dossieru)

## Evidence Level

Confirmed — chování CZ požadavku na potvrzení, výpočtu součtu, uložení snímku, generování PDF a archivace e-mailu je vysledováno od začátku do konce ve FLW0009 vůči SRV Document-Generation-&-Fulfilment, Payment-Processing (čtení součtu darů) a Transactional-Messaging-Orchestrator, a je podloženo entitami EN0014/EN0008/EN0009/EN0022, včetně režimů AF2 (částečné doručení) a AF3 (duplicitní vystavení), obou potvrzených ve FLW0009; dílčí tok RO přesměrování daně (AF4) je označen jako Partial jako přilehlý, samostatně sledovaný mechanismus podle vlastní poznámky o rozsahu dossieru.
