---
doc_id: FN0015
title: Marketing / CRM Synchronisation
layer: FN
spec_type: functional-capability
status: imported
modules: []
references:
  - UC0012
  - UC0013
  - UC0015
  - EN0006
  - EN0008
  - BR-MarketingAndAnalyticsRelay
  - BR-DataProtectionAndErasure
---

# FN0015 – Synchronizace marketing / CRM

## Účel

Udržovat externí marketingový CRM (Mautic) synchronizovaný se stranami platformy: vytvořit nebo
aktualizovat kontakt pro každou stranu při uložení a při odeslání transakční zprávy a (pokusit se)
odstranit CRM kontakt strany při GDPR výmazu. Mautic je zároveň de facto transportní vrstva, kam
schopnost zasílání zpráv (FN0019) předává odesílané zprávy.

## Odpovědnosti

- Zařazovat do fronty a zpracovávat frontu CRM synchronizace, která vytváří nebo aktualizuje
  (upsert) záznam kontaktu strany v Mauticu při uložení uživatele (User, EN0008) — pokrývá
  registraci, následné změny i GDPR anonymizaci.
- Vytvořit nebo aktualizovat příjemce jako kontakt v Mauticu jako vedlejší efekt každého
  transakčního odeslání směrovaného přes FN0019.
- Pokusit se o smazání kontaktu v Mauticu při GDPR anonymizaci v produkci — definovaná, ale prázdná
  schopnost, která neprovádí žádné skutečné odstranění.

## Související případy užití

UC0013 – Synchronizace marketingu a intake leadů (odchozí dílčí tok synchronizace Kontakt→Mautic)

UC0012 – Odeslání transakční zprávy (upsert kontaktu na straně odesílání)

UC0015 – Anonymizace osobních údajů (GDPR) (re-synchronizace CRM a pokus o výmaz po anonymizaci)

## Související entity

EN0006 – Kontakt

EN0008 – Uživatel

## Integrace

Mautic (marketingový CRM), uvedený v ARCH0002 (mapa kontextových interakcí) jako externí cíl fronty
CRM synchronizace a doručování transakčních zpráv.

## Omezení

- Riziko maření GDPR výmazu: fronta CRM synchronizace znovu vytvoří (upsert) anonymizovaného
  uživatele (User, EN0008), zatímco jeho pole jméno/příjmení jsou stále vyplněná — čímž po
  požadavku na výmaz marketingový kontakt v Mauticu znovu vytvoří, místo aby jej odstranila.
- Produkční schopnost mazání podle e-mailu volaná při GDPR anonymizaci je no-op — neprovádí žádné
  skutečné smazání v CRM.
- Odchozí dílčí tok upsertu Kontaktu, na kterém stojí marketingová synchronizace v UC0013, je
  doložen pouze na úrovni indexu toků (nezaminovaný), takže jeho spouštěcí podmínky nad rámec
  „kvalifikující se změny Kontaktu" jsou Partial.
