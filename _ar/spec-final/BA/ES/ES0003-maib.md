---
doc_id: ES0003
title: MAIB
layer: ES
spec_type: external-system
status: imported
modules: []
references:
  - ARCH0001
  - ARCH0002
  - FN0007
  - FN0008
  - UC0005
  - UC0006
---

# ES0003 – MAIB

## Účel

MAIB je externí platební brána, která zajišťuje platby kartou za dary pro moldavský region.
Jde o MD protějšek hranice platební brány daného regionu popsané v Integration
Landscape (ARCH0001 §5, řádek 3).

---

## Přehled systému

MAIB je platební brána moldavské banky pro eCommerce platby kartou. Autorizuje a vypořádává
jednorázové platby daru iniciované platformou pro MD flow, komunikace probíhá přes kanál
s mutual-TLS zabezpečeným klientským certifikátem.

Neuplatňuje se zde žádné sloučení aliasů: MAIB je jediná, pouze MD integrace s jedním režimem
interakce, na rozdíl od vícerežimových sloučení ComGate (ES0001) a Facebook.

---

## Integrační model

Obousměrný:

- **Odchozí** — platforma volá MAIB pro zahájení MD platby daru a samostatně volá MAIB znovu pro
  opětovné dotázání na autoritativní stav dříve zahájené transakce (UC0005, UC0006).
- **Příchozí** — prohlížeč dárce je z MAIB přesměrován zpět na platformu s referencí transakce;
  platforma této prohlížečem předané referenci samotné nedůvěřuje a používá ji pouze k vyvolání
  server-to-server opětovného dotazu na stav vůči MAIB (UC0006).

Kanál je autentizován klientským TLS certifikátem spolu s heslovou frází (passphrase), nikoli
podpisem callbacku pomocí sdíleného tajemství.

To odpovídá řetězci A, bodu (a) v ARCH0002: synchronní externí výměně checkout/stav.

---

## Výměna dat

- Odchozí: zahájení MD transakce daru/checkoutu a opětovný dotaz na stav pro danou referenci
  transakce.
- Příchozí: přesměrování prohlížeče nesoucí referenci transakce (použité pouze k vyvolání
  opětovného dotazu, nepovažované za autoritativní) a odpověď opětovného dotazu, která hlásí
  autoritativní platební stav dané transakce.

Detail payloadu ani jednotlivých polí zde není definován — viz odpovídající kontrakt na úrovni API
(odkazovaný přes EN0009, entitu Transakce, kterou tato výměna aktualizuje).

---

## Omezení

- Integrace je pevně vázána na klientský TLS certifikát a heslovou frázi namísto schématu
  sdíleného tajemství / HMAC (ARCH0001 §5 řádek 3).
- Selhání opětovného dotazu na stav ponechá Transakci uvíznutou ve stavu PENDING, bez
  evidovaného opakování pokusu (ARCH0001 §5 řádek 3).
- Cesta přesměrování prohlížeče zobrazí dárci jakýkoli nezrušený výsledek — včetně stále
  nevyřízeného výsledku — jako úspěch (FN0008; UC0006).
- MAIB sdílí stejnou cestu aktualizace stavu jako ComGate, což představuje nedeterministickou
  kolizi při rozhodování, která aktualizace brány zvítězí (Hypothesis — not evidenced as a
  designed behavior) (FN0008).
- Pouze current-state; všechna omezení odrážejí systém tak, jak je implementován, nikoli cílový
  návrh.
