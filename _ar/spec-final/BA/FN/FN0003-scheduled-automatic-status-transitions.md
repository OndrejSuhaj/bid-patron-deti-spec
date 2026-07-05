---
doc_id: FN0003
title: Scheduled / Automatic Status Transitions
layer: FN
spec_type: functional-capability
status: imported
modules: []
references:
  - UC0002
  - EN0001
  - EN0027
---

# FN0003 – Plánované / automatické přechody stavů

## Účel

Přesunout žádosti (EN0001), které příliš dlouho setrvaly ve zdrojovém stavu, do nakonfigurovaného cílového stavu
bez lidského aktéra, a to podle časově řízených pravidel (ApplicationAction, EN0027). Jde o automatickou, cronem
řízenou větev stavové páteře (UC0002.3) — odlišnou od změny řízené člověkem a od rozeslání reakcí (FN0002).

## Odpovědnosti

- Načíst aktivní pravidla automatického přechodu, jejichž spouštěč je nakonfigurován jako plánovaný/cron.
- Vybrat žádosti aktuálně nacházející se ve zdrojovém stavu daného pravidla, jejichž doba setrvání překračuje
  prahovou hodnotu stáří definovanou pravidlem.
- Změnit stav každé vybrané žádosti na cílový stav daného pravidla, přičemž změna je přisouzena systémovému
  servisnímu účtu a znovu vstupuje do orchestračního rozhraní pro stavy (FN0002).
- Provést jakoukoli další akci specifikovanou pravidlem nad žádostí (např. akci odebrání patrona).

## Související případy užití

UC0002 (dílčí tok UC0002.3).

## Související entity

EN0001 (předmět), EN0027 (konfigurace pravidla automatického přechodu).

## Integrace

Žádné. Tato funkcionalita působí pouze na agregát žádosti (EN0001) a veškeré navazující účinky na stav
deleguje na sdílené orchestrační rozhraní (FN0002); sama nevolá žádný externí systém přímo.

## Omezení

- Partial / záměrně ponecháno obecně: samotný cron tok nebyl analyzován (mined); chování je podloženo pouze
  konfigurací pravidla EN0027, takže přesná perioda spouštění a ošetření chyb jsou odvozeny, nikoli potvrzeny.
- Ze všech možných akcí pravidla je jako implementovaná doložena pouze akce odebrání patrona.
- Přechody znovu využívají nezajištěné rozhraní pro stavy (FN0002), takže platí stejná omezení
  netransakčnosti / absence kontroly legality.
