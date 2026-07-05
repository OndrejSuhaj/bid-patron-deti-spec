---
doc_id: ES0008
title: Google Tag Manager
layer: ES
spec_type: external-system
status: imported
modules: []
references:
  - ARCH0001
  - FN0016
  - UC0013
---

# ES0008 – Google Tag Manager

## Účel

Google Tag Manager poskytuje klientskou analytiku a schopnost správy tagů (tag management), díky
nimž lze na veřejně přístupných frontendech Patronusu provozovat marketingové sledování a sledování
konverzí. Platformě to dává způsob, jak signalizovat aktivitu návštěvníků a konverze nástrojům pro
marketingové měření, aniž by tato signalizace byla součástí vlastního serverového zpracování
platformy.

---

## Přehled systému

Google Tag Manager je klientská služba pro správu tagů / analytiku. Načítá a spouští marketingové
a analytické tagy přímo v prohlížeči návštěvníka, nezávisle na backendu platformy. Jde o jednu ze
dvou hranic pro analytické/marketingové signály uvedených v integrační krajině (Integration
Landscape) (`ARCH0001` §5, řádek 9), kde je zařazen spolu s Facebook Pixel pod stejnou roli
klientské analytiky, ale jde o samostatnou hranici dodavatele odlišnou od integračních povrchů
Facebooku (`ES` pro Facebook — Conversions API / Pixel / Lead Ads webhook — je dokumentováno
samostatně).

---

## Integrační model

Pouze odchozí, a zcela na straně klienta: hranicí integrace je prohlížeč návštěvníka, nikoli server
Patronusu. Kód pro správu tagů / analytiku je vložen do stránky při jejím vykreslování na veřejném
frontendu; backend Patronusu neprovádí žádné serverové volání do Google Tag Manager (`ARCH0001` §5
řádek 9; `UC0013` — analytický dílčí tok, zařazený pod cílovou hranici Analytics-Adapter spolu
s Facebook Pixel). Tím se Google Tag Manager ocitá zcela mimo serverovou integrační krajinu
platformy — účastní se pouze prostřednictvím toho, co je vykresleno do stránky (`ARCH0001` §5
řádek 9; `FN0016`; `UC0013`). (Není uveden v `ARCH0002`, jehož řetězec C8 pokrývá pouze
Mautic/WhoisXML.)

---

## Výměna dat

Pouze odchozí: klientské analytické/konverzní signály ze stránek a interakcí, odesílané z prohlížeče
návštěvníka po vykreslení stránky (`UC0013`). Jde pouze o koncepční popis — není tvrzena žádná
podoba datové zprávy ani detail na úrovni polí; odpovědnost za sestavování vlastních
analytických/konverzních událostí platformy náleží `FN0016` a zde není opakována. Ze strany Google
Tag Manager zpět do Patronusu neproudí žádná data.

---

## Omezení

- **Dopad výpadku:** pouze ztráta analytických signálů; pokud tato integrace není dostupná, nemá to
  žádný dopad na doménové zpracování Žádosti, Kontaktu ani Transakce (`ARCH0001` §5 řádek 9).
- **Hranice:** běží zcela na straně klienta, mimo serverovou hranici platformy — Patronus nemůže
  po vykreslení kódu pro správu tagů do stránky pozorovat ani řídit jeho doručení.
- **Pouze současný stav:** toto odráží integraci tak, jak je dnes doložena; není zde tvrzena žádná
  změna do cílového stavu.
- **Úroveň evidence:** zařazeno pod stejnou integrační hranici jako odchozí analytický přenos
  popsaný v `FN0016`/`UC0013`; vnitřní spouštěcí logika toho, co přes tuto hranici prochází, není
  hloubkově zmapována (`Partial`).
