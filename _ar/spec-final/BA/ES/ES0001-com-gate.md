---
doc_id: ES0001
title: ComGate
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
  - FN0012
  - UC0005
  - UC0006
  - UC0007
  - UC0008
---

# ES0001 – ComGate

## Účel

ComGate je externí platební brána, která zachytává platby kartou a online platby darů pro český
region a zároveň poskytuje seznam převodů/vypořádání na straně brány, který platforma využívá k
párování toho, které zachycené platby byly skutečně vyplaceny na bankovní účet. Jde o CZ protějšek
hranice platební brány daného regionu popsané v Integration Landscape (ARCH0001 §5, řádky 1 a 6).

---

## Přehled systému

ComGate je česká služba platební brány, dostupná přes vlastní (jednoduchý/AGMO) protokol. Na hranici
integrace plní dvě odlišné role:

- autorizace a vypořádání jednorázových a trvalých plateb kartou/online plateb darů iniciovaných
  platformou (platební režim);
- poskytování služby seznamu převodů/vypořádání, která hlásí výplaty přijaté obchodníkem, nezávisle
  na jednotlivých platebních transakcích a s časovým odstupem po nich (režim vypořádání).

Sloučení aliasů stejného dodavatele: platební brána ComGate (checkout + status callback) a
synchronizace převodů/vypořádání ComGate jsou považovány za jeden externí systém, ComGate, se dvěma
režimy interakce — podle pravidla ES pro sloučení aliasů stejného dodavatele.

---

## Model integrace

Obousměrná, se dvěma režimy interakce:

- **Platební režim** — odchozí: platforma volá ComGate za účelem vytvoření checkout transakce pro
  dar a dotazu na stav transakce; příchozí: ComGate volá zpět platformu s výsledkem platby dané
  transakce (UC0005, UC0006).
- **Režim vypořádání** — pouze odchozí, v naplánovaném/CLI cyklu: platforma stahuje z ComGate seznam
  převodů/vypořádání pro účely párování plateb (UC0008).

To odpovídá řetězci A v ARCH0002: (a) synchronní externí výměna checkout/callback a (b) plánovaný
cron/CLI pull pro párování plateb.

---

## Výměna dat

- Platební režim, odchozí: iniciace transakce daru/checkoutu a dotaz na stav dané transakce.
- Platební režim, příchozí: výsledek/stav platby dané transakce, doručený formou callbacku.
- Režim vypořádání, odchozí: záznamy seznamu převodů/vypořádání použité k párování dříve zachycených
  plateb s odpovídajícími bankovními výplatami.

Detail na úrovni payloadu nebo jednotlivých polí zde není definován — viz odpovídající kontrakt na
úrovni API (odkazovaný přes EN0009, entitu Transakce, kterou tato výměna aktualizuje).

---

## Omezení

- Route pro callback s výsledkem platby je fakticky veřejná: nenese žádný HMAC podpis ani ochranu
  proti replay/idempotenci. Tiché nenalezení shody při zpracování callbacku způsobí, že uhrazená
  Transakce nikdy není označena jako PAID, což vede ke ztrátě párování plateb (ARCH0001 §5 řádek 1;
  **HS12**).
- Synchronizace vypořádání/převodů má omezený počet řádků (strop) a neobsahuje žádné zpracování
  chyb HTTP/JSON: přebytečné řádky rozdělených plateb zůstanou při překročení stropu tiše neoznačené
  (ARCH0001 §5 řádek 6; **HS05**).
- Platí pouze pro aktuální stav; obě omezení odrážejí systém tak, jak je implementován, nikoli
  cílový návrh.
