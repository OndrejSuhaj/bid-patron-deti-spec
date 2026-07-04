---
doc_id: FN0016
title: Conversion & Analytics Relay
canonical_layer: FN
spec_type: functional-capability
status: canonical
modules: []
references:
  - UC0013
  - EN0009
  - EN0006
  - BR-MarketingAndAnalyticsRelay
---

# FN0016 – Přenos konverzí a analytických dat

## Účel

Přenášet konverzní a analytické signály z Patronusu do externích nástrojů pro měření marketingové
výkonnosti — přenos darovací události na straně serveru do Facebook Conversions API a signály
klientských událostí do Google Tag Manager / Facebook Pixel — aby bylo možné dárcovské kampaně
atribuovat. Tato funkční oblast dále hostuje vstupní webhook rozhraní pro Facebook Lead Ads, které
dnes pouze odpovídá na ověřovací handshake odběru (subscription-verification); zamýšlená cesta pro
příjem leadů za ním není implementována.

---

## Odpovědnosti

Tato funkční oblast odpovídá za:

- Sestavení payloadu konverzní události z kvalifikující se transakce (`EN0009`) a jeho přenos do
  Facebook Conversions API za účelem atribuce dokončených darů marketingovým kampaním.
- Vysílání signálů klientských konverzí/událostí prostřednictvím Google Tag Manager / Facebook Pixel
  při vykreslení stránky, pro atribuci kampaní nezávisle na přenosu na straně serveru.
- Hostování ověřovacího handshake odběru (subscription-verification) na webhook endpointu pro
  Facebook Lead Ads: ověření příchozího ověřovacího tokenu proti nakonfigurované hodnotě a v případě
  shody odeslání zpět dodané výzvy (challenge).
- Příjem příchozích volání pro doručení leadů z Facebook Lead Ads na stejném webhook endpointu —
  funkčnost, která je definována na hranici integrace, ale neprovádí žádné ověření, žádné zpracování
  vstupních dat ani žádný doménový efekt (viz Omezení).

---

## Související případy užití

UC0013 – Synchronizace marketingových a příchozích leadů (dílčí tok přenosu konverzí Facebook CAPI,
dílčí tok analytiky GTM/Pixel a alternativní toky webhooku Lead Ads — pouze jako reference)

---

## Související entity

EN0009 – Transakce (zdrojový záznam pro odchozí přenos konverzní události)

EN0006 – Kontakt (entita, která by byla vytvořena příchozím zpracováním leadu, kdyby bylo
implementováno — dnes není vytvářena)

---

## Integrace

Facebook (Conversions API — odchozí přenos konverzí na straně serveru; Facebook Pixel — signál
klientské události; Lead Ads webhook — příchozí ověřovací handshake odběru a zamýšlené doručování
leadů) a Google Tag Manager (klientský analytický/událostní signál), uvedené jako hranice integrace
SRV0014 v SRV-target-list.md a SRV-architecture-map.md a referencované prostřednictvím hranic
integrace UC0013. Vrstva ES pro tento projekt zatím neexistuje; žádné `ESxxxx` id není přiřazeno.

---

## Omezení

- Pouze marketingový/analytický signál: tato funkční oblast nemá žádný doménový efekt — nevytváří,
  neaktualizuje ani nepřevádí záznamy Žádosti, Kontaktu ani Transakce; pouze čte Transakci za účelem
  sestavení odchozího payloadu.
- Příchozí cesta pro zpracování leadů z Facebook Lead Ads je potvrzenou mezerou v současném stavu:
  `Status: Planned / Not Implemented`. Každé příchozí volání pro doručení leadu je zodpovězeno
  odpovědí HTTP 200 ve tvaru úspěchu, zatímco odeslaná data leadu jsou tiše zahozena — nevzniká žádný
  Kontakt ani Žádost a Facebook není o selhání informován. Funguje pouze ověřovací handshake odběru
  (porovnání tokenu + odeslání výzvy zpět), jak bylo pozorováno.
- Webhook přijímá volání anonymně; ověřovací token, proti kterému kontroluje, je pevná, natvrdo
  zakódovaná konfigurační hodnota, nikoli otočitelný (rotable) přihlašovací údaj.
- Odchozí přenos konverzí Facebook CAPI je doložen pouze na úrovni indexu toků (nezpracováno do
  hloubky — un-mined) — jeho spouštěcí podmínky nad rámec „kvalifikující se transakční události" a
  obsah jeho payloadu jsou `Partial`, nejsou zpracovány do hloubky.
- Signál klientské události GTM/Pixel je seskupen s odchozím přenosem CAPI pod stejnou hranicí
  integrace, ale architektonicky je odlišný (vysílání na straně prohlížeče vs. na straně serveru);
  jeho vnitřní spouštěcí logika rovněž není zpracována do hloubky.
