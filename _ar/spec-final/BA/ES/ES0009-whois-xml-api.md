---
doc_id: ES0009
title: WhoisXML API
layer: ES
spec_type: external-system
status: imported
modules: []
references:
  - ARCH0001
  - ARCH0002
  - FN0019
  - UC0012
---

# ES0009 – WhoisXML API

## Účel

WhoisXML API je integrováno za účelem kontroly platnosti/existence doménového jména objeveného na
cestě zasílání zpráv, což platformě dává možnost označit podezřelou nebo neexistující doménu příjemce
před nebo během odesílání transakční zprávy. Jde o jeden z odchozích cílů služeb uvedených v
Integration Landscape (`ARCH0001` §5, řádek 10).

---

## Přehled systému

WhoisXML API je služba třetí strany poskytující informace o doménách: na základě doménového jména
vrací zprávu o platnosti/existenci dané domény. Patronus ji využívá jako věštírnu pro kontrolu domén;
sama o sobě neuchovává žádná doménová data Patronu a nehraje žádnou jinou roli než odpovídání na tento
dotaz.

---

## Integrační model

Odchozí: platforma volá WhoisXML API během cesty zasílání zpráv / kontroly domény spojené s
odesíláním transakční zprávy (`FN0019`; `UC0012`), přičemž výsledky jsou cachovány, aby se omezily
opakované dotazy pro stejnou doménu (`ARCH0001` §5 řádek 10). `ARCH0002` umísťuje toto volání na úroveň
kompozice orchestrátoru zasílání zpráv, synchronně s požadavkem, který jej vyvolává.

**Úroveň evidence:** existence této odchozí hranice je potvrzena na úrovni architektury / kompozice
služeb (`ARCH0001` §5 řádek 10; `ARCH0002`), ale její konkrétní spouštěč, sled kroků a výsledek v rámci
odesílání zprávy jsou `Hypothesis — Not evidenced in current sources` — `UC0012` nezaznamenává žádný
důkaz v rámci flow odesílání o tom, že by kontrola platnosti domény skutečně proběhla (viz `UC0012`
Alternative Flows / Evidence Level). Tento ES popisuje integrační hranici tak, jak je pojmenována;
netvrdí, že je potvrzeno, že se kontrola skutečně provádí.

---

## Výměna dat

- **Odchozí:** doménové jméno k ověření.
- **Příchozí:** výsledek platnosti/existence dané domény.

Pouze koncepčně — zde není tvrzen žádný payload ani detail na úrovni polí. Úspěšné dotazy jsou na
straně Patronu cachovány, aby se předešlo opakování stejné kontroly (`ARCH0001` §5 řádek 10); samotný
mechanismus cachování není záležitostí vrstvy ES.

---

## Omezení

- **Dopad výpadku:** pokud je WhoisXML API nedostupné, kontrolu platnosti domény nelze provést, což
  zanechává mezeru ve validaci na cestě zasílání zpráv / kontroly domény; cachované výsledky z
  předchozích dotazů toto zmírňují pro dříve již viděné domény (`ARCH0001` §5 řádek 10).
- **Pouze role hranice:** tato integrace provádí pouze kontrolu platnosti domény — neúčastní se obsahu
  zprávy, řešení příjemce ani doručení, které zůstávají interní záležitostí schopnosti zasílání zpráv
  (`FN0019`) a její transportní integrace.
- **Pouze současný stav:** toto odráží integraci tak, jak je dnes doložena; není zde tvrzena žádná
  změna cílového stavu.
- **Úroveň evidence:** `Partial` — hranice je potvrzena na úrovni architektury / kompozice služeb, ale
  její role v rámci use case zasílání zpráv je nepotvrzená (`Hypothesis`) dle `UC0012`.
