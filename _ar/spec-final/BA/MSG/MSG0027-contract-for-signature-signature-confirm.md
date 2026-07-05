---
doc_id: MSG0027
title: Contract for Signature & Signature Confirmation
layer: MSG
spec_type: transactional-message
status: imported
modules: []
trigger:
  - UC0004
references:
  - EN0011
  - EN0001
  - EN0022
  - ES0006
---

# MSG0027 – Smlouva k podpisu a potvrzení podpisu

## Účel

Doručit manažerem podepsanou smlouvu o daru (EN0011) rodiči / žadateli k podpisu, dále eskalovat
formou urgencí, dokud zůstává nepodepsaná, a — jakmile žadatel podepíše — potvrdit rodiči i patronovi,
že podepsaná smlouva byla přijata a nákup daru může pokračovat. Tato zpráva sdružuje celý životní
cyklus předání smlouvy k podpisu / eskalace / potvrzení jedné smlouvy do jedné rodiny typů zpráv,
odlišné od dřívějšího kroku manažerské kontroly (UC0004.2, bez rozeslání směrem k rodiči) a od
souvisejícího požadavku na protokol o převzetí (`waiting_for_protocol` — viz Poznámky).

---

## Spouštěč

UC0004 (Správa smlouvy a podpisu) — rozeslání řízené stavem žádosti (EN0001) se spouští při:

- Vstupu do stavu **`waiting_signature`** ("Nahrajte smlouvu" / patronovi zobrazeno jako "Smlouva k
  podpisu"), kdy je smlouva předána z manažerské kontroly fundraiserovi k podpisu (UC0004.2 kroky 4–7).
  V legacy (bez elektronického podpisu) postupu jde o okamžik, kdy je vyrenderované PDF smlouvy
  odesláno fundraiserovi notifikací (UC0004 AF1); v postupu s elektronickým podpisem jde o okamžik,
  kdy je otevřena podpisová relace v zóně ke kontrole (UC0004.3 krok 1). SC-8A kroky 7–9 dokládají
  tentýž vstup do stavu s doručením smlouvy a pokynů k podpisu rodiči.
- Eskalaci do stavů **`waiting_signature_reminder_1`** a **`waiting_signature_reminder_2`**, když
  rodič nedokončí podpis v termínu (SC-8B kroky 1–3: urgence po počátečním termínu podpisu, druhá
  urgence po další čekací lhůtě).
- Dokončení podpisu žadatelem, vstup do stavu **`contract_signed`** ("Podepsaná smlouva" / patronovi
  zobrazeno jako "Dar je na cestě"), kdy zákazník/fundraiser dokončí krok elektronického podpisu
  (UC0004.3 kroky 3–7) — potvrzující, že podepsaná smlouva byla přijata a nákup daru pokračuje
  (SC-8A kroky 10–12).

Úroveň evidence: Confirmed pro posloupnost `waiting_signature` → urgence → `contract_signed` a její
mapování na role/kanály (matice notifikací; SC-8A; SC-8B); Partial pro otázku, zda jsou obě
pojmenované urgenční stavy vždy dosaženy v posloupnosti, nebo zda mohou být někdy přeskočeny (evidence
ukazuje posloupnost, nikoli však každou možnou cestu skrz ni).

---

## Příjemci

- **Rodič / žadatel** — e-mail (přes ES0006, Mautic) **a** notifikace v zóně pro `waiting_signature`
  (E-mail = ANO, Notifikace = ANO). Pouze e-mail (bez zaznamenané notifikace v zóně) pro
  `waiting_signature_reminder_1`; e-mail i notifikace v zóně pro `waiting_signature_reminder_2`. Při
  `contract_signed` potvrzují přijetí podepsané smlouvy e-mail i notifikace v zóně (E-mail = ANO,
  Notifikace = ANO).
- **Patron** — rozeslání patronovi se liší podle eskalačního stavu, dohledatelné řádek po řádku v
  matici notifikací (viz také SC-8B):
  - `waiting_signature`: pouze notifikace v zóně, bez e-mailu (E-mail = NE, Notifikace = ANO) —
    pasivní stavový popisek v zóně ("Smlouva k podpisu").
  - `waiting_signature_reminder_1`: žádný z kanálů (E-mail = NE, Notifikace = NE) — při první urgenci
    podpisu není patronovi nic rozesíláno.
  - `waiting_signature_reminder_2`: pouze e-mail, bez notifikace v zóně (E-mail = ANO, Notifikace =
    NE) — druhá urgence podpisu patrona skutečně zasáhne e-mailem (řádek matice
    `waiting_signature_reminder_2 | Patron`; SC-8B krok 3).
  Při `contract_signed` dostává patron pouze notifikaci v zóně ("Dar je na cestě"; E-mail = NE,
  Notifikace = ANO) — v tomto kroku patronovi žádný e-mail nechodí.
- Pro tuto zprávu není doložena žádná obsahová odlišnost pro RO/MD nad rámec obecného přeřešení
  šablon podle země, které je již zaznamenáno na úrovni kapability (FN0019); citovaná matice notifikací
  a evidence SC-8A/SC-8B je primárně CZ.

---

## Obsah zprávy

Konceptuálně nese každé rozeslání v této rodině:

- **Rozeslání `waiting_signature` rodiči**: tvrzení, že smlouva o daru (EN0011) je připravena a
  vyžaduje podpis žadatele; samotnou smlouvu — buď jako přiložený/odkazovaný dokument ke kontrole a
  podpisu, nebo jako pokyn k otevření podpisové relace v zóně, v závislosti na tom, který postup
  podpisu se pro daného tenanta uplatňuje (UC0004 AF1 vs. UC0004.3); pokyny k podpisu popisující, jak a
  kde podpis dokončit a do jakého termínu.
- **Rozeslání urgencí k podpisu (`waiting_signature_reminder_1`, `waiting_signature_reminder_2`)**:
  opětovné konstatování, že smlouva stále čeká na podpis rodiče; stupňující se naléhavost formulovanou
  kolem blížícího se nebo zmeškaného termínu; opakovaný odkaz na to, kde/jak podepsat.
- **Upozornění `waiting_signature_reminder_2` patronovi** (pouze e-mail): sdělení, že žadatel do
  druhé urgence smlouvu stále nepodepsal — informuje patrona o zaseknutém podpisu, bez detailu o
  dokumentu smlouvy nebo úkonu podpisu, jelikož patron není smluvní stranou (řádek matice
  `waiting_signature_reminder_2 | Patron`, E-mail = ANO; SC-8B krok 3).
- **Potvrzení `contract_signed` rodiči**: potvrzení, že podpis žadatele byl přijat a podepsaná smlouva
  je založena; že případ nyní postupuje do dalšího kroku (objednávka/úhrada daru).
- **Upozornění `contract_signed` patronovi**: jednodušší sdělení, že se dar posouvá dále ("dar je na
  cestě") po podpisu žadatele — bez detailu o dokumentu nebo podpisu, jelikož patron není smluvní
  stranou.

Každé rozeslání je archivováno jako záznam EmailArchive (EN0022) bez ohledu na to, zda bylo podkladové
odeslání skutečně přeneseno, v souladu s obecným chováním platformy při archivaci e-mailů (viz sdílenou
poznámku k archivaci v MSG0005).

Zde není tvrzen žádný fixní text předmětu, značkování těla zprávy ani struktura šablony — konkrétní
znění, mechanika příloh a prezentace podpisové relace jsou detailem implementace/instance mimo rozsah
této zprávové smlouvy (viz omezení v rules-MSG.md).

---

## Poznámky

- Tato zpráva sdružuje tři body stavu do jednoho životního cyklu podpisu — počáteční doručení
  `waiting_signature`, jeho dvě urgence k podpisu a potvrzení `contract_signed` — protože jde o stejnou
  konceptuální zprávu (doručit smlouvu → eskalovat → potvrdit podpis) opakující se napříč
  podžádostí podpisu žádosti (UC0004.3; SC-8A; SC-8B), nikoli o čtyři nesouvisející typy zpráv.
- Mechanismus, kterým se smlouva dostane k rodiči/fundraiserovi, se liší podle konfigurace tenanta:
  postup s elektronickým podpisem otevírá podpisovou relaci v zóně ke kontrole a podpisu, zatímco
  legacy postup místo toho zasílá vyrenderovanou smlouvu notifikací bez relace v zóně (UC0004 AF1).
  Tato zprávová smlouva pokrývá oba případy; rozlišení mechanismu doručení patří do vrstvy UC/ES a zde
  se neopakuje.
- **`waiting_signature_uncooperative`** ("Potvrďte smlouvu pro {application:child:name}", pouze rodič
  v zóně dle matice notifikací) je terminální stav bez odpovědi, kterého je dosaženo poté, co druhá
  urgence k podpisu zůstane bez odezvy (SC-8B krok 4), a je zpracováván jako samostatné upozornění na
  uzavření eskalace, nikoli jako součást množiny rozeslání této zprávy, protože nese jiné rámování
  adresované dítěti a již nepožaduje rutinní úkon podpisu; předchází řešení na úrovni případu (pokus o
  kontakt, poté přerozdělení/zrušení — SC-8B kroky 5–10, mimo rozsah tohoto dokumentu).
- **`waiting_for_protocol`** ("Doplňte Protokol o daru", rodič e-mail+zóna; patron pouze zóna) je
  související požadavek na protokol o převzetí daru, který se týká potvrzení fyzického předání daru,
  nikoli podpisu smlouvy o daru — souvisejícím, ale odlišným dokumentem z rodiny smlouvy (viz glosář
  C039/C118) a je mimo rozsah této zprávy.
- Úroveň evidence pro celkový mechanismus spouštěče/příjemců/obsahu: Confirmed (řádky matice
  notifikací pro `waiting_signature`, `waiting_signature_reminder_1`, `waiting_signature_reminder_2`,
  `contract_signed`; SC-8A kroky 7–12; SC-8B kroky 1–3; UC0004). Úroveň evidence pro přesné rámování
  termínů urgencí u jednotlivých rozeslání: Partial — narativ SC-8B popisuje termíny (např. počet dnů
  mezi urgencemi), ale tato zprávová smlouva neopakuje pravidla časování patřící do vrstvy BR/FN, pouze
  konstatuje, že k eskalaci dochází.
