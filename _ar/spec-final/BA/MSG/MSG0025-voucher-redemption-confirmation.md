---
doc_id: MSG0025
title: Voucher Redemption Confirmation
layer: MSG
spec_type: transactional-message
status: imported
modules: []
trigger:
  - UC0009
references:
  - EN0013
  - EN0009
  - EN0004
  - EN0022
  - ES0006
---

# MSG0025 – Potvrzení uplatnění poukazu

## Účel

Potvrzuje, že dárkový poukaz ("Dobrošek", EN0013) byl úspěšně uplatněn a přiřazen jako dar k příběhu
(kampani, EN0004) vybraného dítěte. Zpráva uzavírá krok uplatnění v rámci životního cyklu poukazu pro
toho, kdo jej vyvolal — samotná zpráva nenese detail platebního nástroje, pouze výsledek uplatnění.

## Spouštěč

UC0009 – Uplatnění / validace poukazu, subflow **UC0009.2 — Uplatnění (Redeem) poukazu**, v kroku
úspěšného výsledku (poukaz je navázán na cílovou kampaň a označen jako uplatněný). Podmínka spuštění:
poukaz byl nalezen jako zaplacený a dosud neuplatněný a operace uplatnění proběhla bez chyby. Neodesílá
se při pouhé validaci (UC0009.1) ani při neúspěšném uplatnění (AF2).

## Příjemci

**Conflict — requires clarification.** Dva zdroje evidence se neshodují na tom, kdo tuto zprávu dostává:

- **Čtení kódu/flow (FLW0018, UC0009.2 krok 8) — autoritativní pro současné chování:** jediným
  příjemcem je vždy e-mailová adresa zaznamenaná u transakce (EN0009) odpovídající původnímu nákupu
  poukazu, bez ohledu na to, kdo uplatnění provedl. Odeslání odvozuje adresáta z navázané transakce,
  takže obě varianty UC0009.2 — Option A (uplatní kupující) i Option B (uplatní obdarovaný příjemce) —
  posílají na stejný e-mail z nákupní transakce, nikoli tomu, kdo poukaz skutečně uplatnil.
- **Čtení Notification Matrix (intake test-scenarios, SC-10F řádky 6 a 9):** uvádí dva *odlišné*
  adresáty podle varianty — dárce (Donor) pro Option A (řádek 6) a příjemce (Recipient) pro Option B
  (řádek 9).

Podle výchozí důvěryhodnosti (kód/flow má přednost pro současné chování) posílá současný systém v obou
cestách na e-mail z nákupní transakce; rozdělení Donor vs. Recipient v Matrix **není** potvrzeno kódem
a je zde zaznamenáno jako rozpor k vyjasnění, nikoli tiše sloučeno. Zda Matrix popisuje zamýšlené
cílové chování, je mimo rozsah MSG (pouze současný stav).

- Doručováno e-mailem přes ES0006 (Mautic).
- Pro tuto zprávu není doložena varianta notifikace v účtu/zóně.
- Není doložena varianta RO/MD; nákup/uplatnění poukazu je doloženo jako specifické pro CZ (viz EN0013).

## Obsah zprávy

Konceptuální informační prvky, které zpráva musí nést:

- Potvrzení, že dárkový poukaz byl úspěšně uplatněn / přiřazen.
- Hodnota poukazu, která byla přiřazena jako dar (cena EN0013).
- Identifikace příběhu/kampaně (EN0004), ke které byl dar přiřazen, dostatečná k tomu, aby příjemce
  rozpoznal, které dítě nyní podporuje.
- Žádný další detail platebního nástroje, platební metody ani transakce zpráva nenese.

## Křížové odkazy

- Spouštěč: UC0009 (Uplatnění / validace poukazu).
- Dotčené entity: EN0013 (Poukaz — uplatněný nástroj), EN0009 (Transakce — zdroj e-mailu příjemce),
  EN0004 (Kampaň — cíl uplatnění / příběh).
- Doručovací kanál: ES0006 (Mautic, transportní kanál transakčních e-mailů).
- Záznam o doručení: EN0022 (EmailArchive) — pokud e-mailový archiv platformy toto odeslání zachycuje,
  je zaznamenáno tam; zde se neopakuje.
- Odlišuje se od zprávy potvrzující nákup poukazu (odesílané dříve v životním cyklu poukazu, v čase
  nákupu/PAID, kupujícímu) — tato zpráva pokrývá pouze pozdější krok uplatnění/přiřazení.
- Výhrady k integritě dat v rámci flow uplatnění (nejedinečný kód poukazu, chybějící ochrana proti
  souběžnému dvojímu uplatnění, chybějící ošetření null hodnoty, pokud poukaz nemá navázanou transakci)
  jsou záležitostí UC0009/FLW0018, zde se neopakují.

## Úroveň evidence

Partial (Conflict u příjemce) — spouštěč a *existence* této zprávy potvrzující uplatnění jsou
Confirmed, podloženy FLW0018 (úroveň jistoty Confirmed) a subflow Apply v UC0009 (kroky 7–8), a
potvrzeny řádky 6 a 9 Notification Matrix SC-10F (které potvrzují, že při uplatnění je odesíláno
potvrzení). **Identita příjemce je Conflict — requires clarification**: kód/flow (autoritativní pro
současné chování) uvádí, že jediným adresátem je vždy e-mail z nákupní transakce, zatímco Matrix
uvádí dárce (řádek 6) vs. příjemce (řádek 9) podle varianty — viz Příjemci. Rozsah obsahu (hodnota +
příběh, bez detailu nástroje) je Partial / Hypothesis — odvozeno z evidence entit/flow, jelikož text
šablony není v rozsahu MSG a není dochován jako evidence.
