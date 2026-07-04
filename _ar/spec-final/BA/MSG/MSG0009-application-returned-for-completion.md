---
doc_id: MSG0009
title: Application Returned for Completion
canonical_layer: MSG
spec_type: transactional-message
status: canonical
modules: []
trigger:
  - UC0002
references:
  - EN0001
  - EN0002
  - EN0022
  - ES0006
---

# MSG0009 – Žádost vrácena k doplnění

## Účel

Informovat Žadatele (Parent) o tom, že koordinátor — nebo nepřímo Risk jednající prostřednictvím
koordinátora — shledal Žádost (EN0001) neúplnou nebo nejasnou a že byla vrácena zpět Žadateli
k doplnění: jaké informace nebo dokumenty ještě chybí a že se případ nemůže posunout dál, dokud
Žadatel nezareaguje. Jde o akční zprávu typu „doplňte prosím svou žádost", odlišnou od obecné
notifikace o změně stavu (MSG0005/MSG0006), protože nese konkrétní, případ-specifický požadavek
sepsaný na míru, nikoli jen prostý stavový popisek.

---

## Spouštěč

UC0002 (Orchestrace změny stavu žádosti) — navazující reakční rozvětvení (UC0002.2) — se spustí,
když je Žádost (EN0001) uložena do stavu „čeká na doplnění" (`waiting` — „Doplňte informace do
žádosti") pro roli Žadatel. Evidované vstupní cesty do tohoto stavu:

- Koordinátor zkontroluje Žádost a zjistí chybějící informace nebo přílohy v části náležející
  Žadateli, poté vrátí Žádost Žadateli k doplnění (Notification Matrix, list SC-4B, kroky 3–4).
- Risk zjistí chybějící nebo nejasné informace během scoringu a vyžádá si je prostřednictvím
  koordinátora, který následně vrátí Žádost Žadateli, pokud má informace doplnit právě Žadatel
  (Notification Matrix, list SC-5D, kroky 1–4).

V obou cestách je samotné odeslání této zprávy Žadateli stejným stavem řízeným reakčním krokem
evidovaným v SC-4B krok 5 / SC-5D krok 5 („Systém odešle e-mail Žadateli s výzvou k doplnění/dodání
dalších dokumentů s podrobnostmi o tom, co chybí").

Úroveň evidence: Confirmed pro spouštěcí stav a obě zdokumentované vstupní cesty (řádky Notification
Matrix pro `waiting`, SC-4B, SC-5D); Partial pro to, zda i další, needokumentované vstupní cesty do
téhož stavu `waiting` rovněž vedou přes tuto zprávu — shoda stavu/role na ApplicationReaction (EN0026)
je obecný mechanismus (UC0002.2), takže se očekává, že jakékoli uložení do stavu `waiting` pro roli
Žadatel tuto zprávu spustí.

---

## Příjemci

- **Žadatel / Parent** — e-mail (přes ES0006, Mautic) **a** notifikace v zóně, obojí označeno `YES`
  pro stav `waiting` ve sloupcích Žadatele v Notification Matrix.
- **Patron** — pro tento stav není podle Notification Matrix evidován žádný e-mail ani vyhrazená
  notifikace (řádek `waiting` / Patron: Email = NO, Notification = NO); zóna Patrona místo toho
  zobrazuje pasivní, interní stavový popisek („Čekáme na informace od žadatele"), který odráží, že
  případ je pozastaven a čeká na Žadatele — jde o stavový popisek v zóně spravovaný zprávou MSG0006,
  nikoli o samostatné odeslání této zprávy.

Pro tuto zprávu není evidována žádná obsahová odlišnost pro RO/MD nad rámec obecného rozlišení šablon
podle země, které je již zaznamenáno na úrovni schopnosti (FN0019); zde citovaná evidence z
Notification Matrix je primárně za CZ.

---

## Obsah zprávy

Konceptuálně nese každé odeslání této zprávy:

- Konstatování, že Žádost (EN0001) byla vrácena Žadateli a vyžaduje doplnění, než může případ
  pokračovat.
- Popis toho, co chybí nebo je nejasné — konkrétní informační pole nebo přiložené dokumenty v části
  Žádosti/ApplicationProfile (EN0001/EN0002) náležející Žadateli, které koordinátor (nebo Risk,
  prostřednictvím koordinátora) označil za neúplné. Tento seznam je sepisován koordinátorem
  případ od případu v okamžiku, kdy je Žádost vrácena (Notification Matrix: „Odešle e-mail Žadateli
  s výzvou k doplnění s podrobnostmi o tom, co chybí" / „s výzvou k dodání dalších
  dokumentů/informací"); nejde o pevný, předem daný obsahový blok.
- Pokyn, jak a kde reagovat — že Žadatel musí přejít do své zóny a doplnit chybějící
  informace/dokumenty.
- Implicitní upozornění, že nečinnost má důsledky: pokud Žadatel nezareaguje, následují urgenční
  zprávy a Žádost může být nakonec automaticky zrušena kvůli timeoutu (podle stejných listů
  Notification Matrix — viz urgenční a zrušovací zprávy, které jsou mimo rozsah tohoto dokumentu).

V tomto dokumentu není tvrzen žádný pevný text předmětu, značkování těla zprávy ani struktura šablony
— konkrétní znění je instanční data a konkrétní seznam chybějících položek je sepisován koordinátorem
případ od případu, nikoli kanonický obsah zprávy (viz omezení v rules-MSG.md).

Každé odeslání je archivováno jako záznam EmailArchive (EN0022) bez ohledu na to, zda bylo samotné
odeslání skutečně přeneseno, v souladu s obecným chováním platformy pro archivaci e-mailů (viz MSG0005
pro sdílenou výhradu k archivaci).

---

## Poznámky

- Vyčleněno z obecného e-mailu o změně stavu (MSG0005), protože tento stav nese samostatný, akční,
  případ-specifický požadavek, nikoli jen prostý stavový popisek — Notification Matrix a oba scénáře
  SC (SC-4B, SC-5D) dokládají konkrétní záměr typu „co chybí" pro stav `waiting`, který obecný
  souhrnný mechanismus nezachycuje.
- Navazující urgenční zprávy pro tentýž nezodpovězený požadavek (`waiting_reminder_1`,
  `waiting_reminder_2` a související rodina `reminder_1`/`reminder_2`) představují samostatnou
  problematiku zpráv a nejsou pokryty tímto dokumentem (viz MSG0007 pro urgenční zprávu, pokud je v
  tomto konceptu specifikace přítomna).
- Notification Matrix označuje řádek `waiting` / Žadatel příznakem `CHECK_PARSE`, což znamená, že
  parsování zdrojového listu pro tento konkrétní řádek nese reziduální příznak nejednoznačnosti;
  samotný stavový popisek a hodnoty Email/Notification YES/YES jsou jinak jednoznačné a jsou zde
  použity tak, jak jsou doloženy.
- Úroveň evidence pro celkový mechanismus spouštěče/příjemců: Confirmed. Úroveň evidence pro úplný
  výčet toho, co se počítá jako „chybějící" obsah v jednotlivých případech: Partial/Not applicable —
  tento detail jsou případová data, nikoli pevný prvek smlouvy zprávy.
