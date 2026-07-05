---
doc_id: BR-MultiTenantCountryScoping
title: Multi-Tenant CZ/RO/MD Scoping
layer: BR
spec_type: business-rule
status: imported
modules: []
affects:
  - EN0001
  - EN0004
  - EN0009
  - SYSTEM
references:
  - EN0001
  - EN0004
  - EN0009
  - UC0008
  - FN0005
---

# BR – Multi-Tenant CZ/RO/MD Scoping

## Účel

Upravuje způsob, jakým jsou v současném stavu odděleny země CZ/RO/MD, a zaznamenává, že na klíčových
entitách neexistuje žádný sloupec tenant/country a že několik průřezových datových cest není
odděleno podle země.

## Model tenancy (současný stav)

- Současný stav: má se za to, že tři země jsou obsluhovány jednou sdílenou instancí, bez sloupce
  tenant/country na klíčových entitách žádosti, příběhu a peněz (EN0001, EN0004, EN0009) a bez
  doménově modelované multi-tenancy; chování odlišené podle země SE VYJADŘUJE pouze prostřednictvím
  runtime větvení podle země a konfigurace pro jednotlivé země.
- Současný stav: NENÍ MOŽNÉ předpokládat, že oddělení podle země na klíčových entitách žádosti,
  příběhu a peněz (EN0001, EN0004, EN0009) je vynucováno na úrovni dat.

## Odstupňování průřezových datových cest napříč tenanty (současný stav)

- Současný stav: NENÍ MOŽNÉ předpokládat, že reportingové exporty jsou odděleny podle země —
  standardní exporty SE POVAŽUJÍ za globální napříč CZ/RO/MD, nikoli za filtrované na jednu zemi.
- Současný stav: odstupňování deduplikace a slučovacích akcí podle země/role je upraveno pravidlem
  `BR-PartyIdentityAndDeduplication` (zde odkazováno pouze z pohledu napříč tenanty).
- Současný stav: subsystém doporučování, pokud by byl znovu aktivován, SE POVAŽUJE za subsystém bez
  jakéhokoli odstupňování podle tenanta.

## Zábrany zpracování podle jednotlivých zemí

- V současném stavu existují zábrany podle jednotlivých zemí pro párování plateb (spravováno
  pravidlem `BR-BankReconciliationAndMatching`), pro potvrzení o daru pro CZ (spravováno pravidlem
  `BR-DonationConfirmationAndTax`) a pro externí ověřování identity/registrů a běh opakovaného
  strhávání plateb pro RO (viz UC0008, FN0005). Toto pravidlo pouze zaznamenává, že takové zábrany
  existují a jsou vynucovány pomocí pevně zakódovaných kontrol, nikoli pomocí modelovaného atributu
  tenant/country, a že běhu opakovaného strhávání plateb pro RO chybí odpovídající ochrana
  prostředí.

## Co není cílem

- Toto pravidlo nedefinuje obsah ani mechaniku vydávání potvrzení o daru pouze pro CZ (spravováno
  pravidlem BR-DonationConfirmationAndTax) ani mechaniku párování při vypořádání pouze pro CZ
  (spravováno pravidlem BR-BankReconciliationAndMatching) — na tyto zábrany odkazuje pouze z pohledu
  jejich odstupňování podle země.
- Toto pravidlo nedefinuje mezeru v odstupňování podle země nebo role u deduplikačních/slučovacích
  akcí nad rámec samotné skutečnosti o tomto odstupňování (spravováno pravidlem
  BR-PartyIdentityAndDeduplication).
- Toto pravidlo nedefinuje nefiltrovaný obsah osobních údajů (PII) ani úroveň oprávnění reportingových
  exportů (spravováno business pravidlem pro reporting/přístup k datům, pokud existuje) — zaznamenává
  pouze absenci filtru podle země u těchto exportů.
- Toto pravidlo nepředepisuje cílový model tenanta ani návrh sloupce country pro cílový stav;
  zaznamenává pouze chování současného stavu.
