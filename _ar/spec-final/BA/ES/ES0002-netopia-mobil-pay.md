---
doc_id: ES0002
title: Netopia / MobilPay
canonical_layer: ES
spec_type: external-system
status: canonical
modules: []
references:
  - ARCH0001
  - ARCH0002
  - FN0007
  - FN0008
  - FN0010
  - UC0005
  - UC0006
  - UC0007
---

# ES0002 – Netopia / MobilPay

## Účel

Netopia (MobilPay) je externí platební brána, která zpracovává platby kartou za dary — včetně
opakovaných plateb — pro frontend rumunského regionu. Jde o RO protějšek hranice s platební bránou
popsané v Integration Landscape (ARCH0001 §5, řádek 2).

---

## Přehled systému

Netopia (MobilPay) je rumunská platební brána pro platby kartou. Poskytuje dárci hostovaný checkout
pro platbu kartou a vrací platformě výsledek platby, a to jak u jednorázových darů, tak u opakovaných
plateb iniciovaných bránou. Sloučení aliasů stejného dodavatele: Netopia a MobilPay označují stejného
dodavatele/bránu a jsou vedeny jako jeden externí systém — nejsou pro ně zakládány samostatné ES
záznamy.

---

## Integrační model

Obousměrná integrace:

- **Odchozí** — platforma volá Netopia/MobilPay pro zahájení platby kartou za dar (UC0005) a
  samostatně pro zahájení plánované opakované platby (UC0007).
- **Příchozí** — Netopia/MobilPay vrací platformě výsledek platby prostřednictvím IPN
  (instant-payment-notification) redirectu/callbacku, který nese výsledek iniciované transakce
  (UC0006).

To odpovídá řetězci A v ARCH0002: (a) synchronní externí výměna checkout/IPN a (b) cron cesta pro
opakované platby, která rovněž volá tuto bránu.

Brána je dostupná přes koncové body přepínané podle prostředí (produkce vs. sandbox); volba koncového
bodu je záležitostí prostředí/konfigurace, nikoli hranicí obchodní logiky.

---

## Výměna dat

- Odchozí: zahájení RO platby/checkoutu za dar a zahájení plánované opakované platby vůči dříve
  založenému trvalému daru.
- Příchozí: výsledek/notifikace platby pro iniciovanou transakci, doručovaná přes IPN
  redirect/callback.

Detail payloadu ani jednotlivých polí zde není definován — viz odpovídající kontrakt na úrovni API
(odkazovaný přes EN0009/EN0010, entity Transaction a RecurringTransaction, které tato výměna
aktualizuje).

---

## Omezení

- Ze tří regionálních platebních bran nese tato integrace nejsilnější vendor lock-in (platforma je
  závislá na vendorované knihovně specifické pro danou bránu) (ARCH0001 §5 řádek 2).
- RO cron cesta pro opakované platby postrádá ochranu podle prostředí (environment guard); selhání na
  této cestě riskuje ztrátu zachycení platby nebo ztrátu uloženého tokenu pro opakovanou platbu
  (ARCH0001 §5 řádek 2; **HS11**).
- Opakované platby iniciované přes tuto bránu jsou zaznamenány jako PAID optimisticky, ještě před
  potvrzením výsledku bránou, což při pozdějším nesouladu výsledku vytváří riziko dvojího zúčtování
  (ARCH0002 hranice asynchronní fronty, cron cesta pro opakované platby; **HS04**).
- Platí pouze pro aktuální stav; tato omezení odrážejí systém tak, jak je implementován, nikoliv
  cílový návrh.
