---
doc_id: EN0014
title: DonationConfirmation
layer: EN
spec_type: entity
status: imported
modules: []
references:
  - BR-DonationConfirmationAndTax
  - BR-MultiTenantCountryScoping
  - EN0004
  - EN0008
  - EN0009
  - EN0015
  - EN0022
  - UC0010
---

# EN0014 — Potvrzení o daru

## Účel

Český daňový doklad o daru ("Potvrzení o daru"): neměnný, jednorázově vytvořený snímek
identifikačních údajů dárce a potvrzené celkové výše daru za daný daňový rok, vydávaný jako podklad
pro daňový odpočet. Snímek zachycuje identitu dárce, potvrzenou celkovou výši daru a souhlas GDPR
jako hodnoty platné k danému okamžiku, nikoli jako živé odkazy na dárce nebo na podkladové
transakce (EN0009).

Dostupnost podle země, skutečnost, že potvrzená celková částka je počítána serverem, a
současná absence pojistky proti duplicitě (idempotence) se řídí pravidly `BR-DonationConfirmationAndTax`
a `BR-MultiTenantCountryScoping`.

---

## Životní cyklus

Vydáno — jediný pozorovaný stav. Potvrzení o daru je vytvořeno již jako kompletní a
publikované; po vytvoření není pozorována žádná další změna stavu (viz Invarianty).

---

## Přechody stavů

(žádný) → Vydáno
trigger: UC0010 — Vystavení potvrzení o daru (daň)

Žádné další přechody nejsou pozorovány; viz Invarianty (jednorázově vytvořený neměnný snímek).

---

## Atributy

### Systémem spravované atributy

- donation_total (integer; povinné; potvrzená výše daru za rok potvrzení; počítáno serverem — viz Invarianty)
- donation_in_words (string, max 250; povinné; potvrzená celková částka vyjádřená slovy)
- number_of_requests (integer; volitelné; počet zaznamenaných žádostí o potvrzení pro daného dárce)
- ip_address (string, max 20; systémem zachyceno v okamžiku žádosti)
- user_agent (string, max 250; systémem zachyceno v okamžiku žádosti)
- published (boolean; výchozí true; pro tuto entitu není definován žádný další slovník stavů)

### Uživatelem zadávané atributy

- name (string, max 50; povinné; jméno dárce nebo žadatele; slouží jako popisek entity)
- email (string, max 200; povinné; e-mailová adresa žadatele)
- address (string, max 250; povinné; adresa dárce nebo žadatele)
- rodne_cislo (string, max 20; volitelné; české rodné číslo)
- confirmation_year (integer; povinné; daňový rok, kterého se potvrzení týká)
- campaign (volitelné; odkaz na EN0004 — Kampaň, ke které je potvrzená výše daru vztažena, pokud je žádost specifická pro danou kampaň)
- agreement_truthfulness (boolean; povinné; výchozí true; souhlas GDPR/pravdivosti údajů zachycený v okamžiku žádosti)
- agreement_personal_data (boolean; povinné; výchozí true; souhlas GDPR se zpracováním osobních údajů zachycený v okamžiku žádosti)

---

## Invarianty

- Potvrzená hodnota `donation_total` je počítána serverem, nikoli zadávána uživatelem — viz `BR-DonationConfirmationAndTax`.
- Identifikační údaje dárce a potvrzená celková částka jsou zachyceny jako neměnný, jednorázově vytvořený snímek — viz `BR-DonationConfirmationAndTax`.
- Dostupné pouze pro zemi CZ; pro RO ani MD není vytvářen žádný ekvivalentní záznam Potvrzení o daru — viz `BR-DonationConfirmationAndTax`, `BR-MultiTenantCountryScoping`.
- Není chráněno pojistkou proti duplicitě (idempotence): opakované žádosti pro stejného dárce a rok nezávisle na sobě vytvoří vždy samostatné Potvrzení o daru — viz `BR-DonationConfirmationAndTax`.

---

## Vztahy

- EN0004 — Kampaň (volitelné; celková výše daru může být vztažena ke kampani)
- EN0008 — Uživatel (dárce/žadatel, jehož dary jsou potvrzovány)
- EN0009 — Transakce (zdroj potvrzené celkové částky pouze pro čtení; po vytvoření snímku již není odkazováno živě)
- EN0015 — Daňový poplatník (RO protějšková entita pro obdobný RO mechanismus přesměrování daně; nejde o stejný životní cyklus — viz Otevřené otázky)
- EN0022 — EmailArchive (archivní záznam odeslaného dokumentu/e-mailu s potvrzením)

---

## Otevřené otázky

1. Vykreslení/odeslání dokumentu potvrzení (generování PDF, doručení e-mailem) — je toto
   součástí vlastního životního cyklu entity, nebo zcela navazujícím efektem mimo entitu,
   vyvolaným UC0010? Současný návrh považuje samotný záznam Potvrzení o daru za kompletní již
   při vytvoření, přičemž vykreslení/odeslání je vedlejším efektem na úrovni use case (viz UC0010
   AF2 pro případ částečného odeslání).
2. Zda by měl být RO mechanismus Daňového poplatníka (EN0015) modelován jako varianta životního
   cyklu této entity, nebo jako zcela samostatná entita, zůstává nevyřešeno — současné důkazy je
   považují za paralelní, zemi specifické mechanismy, nikoli za sdílené stavy životního cyklu.
