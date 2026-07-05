---
doc_id: MSG0018
title: Voluntary Cancellation Notice
layer: MSG
spec_type: transactional-message
status: imported
modules: []
trigger:
  - UC0002
references:
  - EN0001
  - EN0022
  - ES0006
---

# MSG0018 – Oznámení o dobrovolném zrušení

## Účel

Potvrdit Žadateli (Parent), že jeho Žádost (EN0001) byla zrušena na vlastní žádost dané strany —
jde o dobrovolné zrušení provedené manuálně koordinátorem, na rozdíl od automatického zrušení
z důvodu timeoutu. Jde o zdvořilé potvrzení, že požadované zrušení bylo provedeno, odlišné od obecné
notifikace při změně stavu (MSG0005/MSG0006) tím, že uzavírá požadavek, který daná strana sama
iniciovala, namísto oznámení stavu, který jí byl vnucen.

---

## Spouštěč

UC0002 (Orchestrace změny stavu žádosti) — navazující reakční fan-out (UC0002.2) — se spustí ve
chvíli, kdy je Žádost (EN0001) uložena do stavu `canceled_by_user` ("Zrušeno žadatelem").

Doložená vstupní cesta (list Notification Matrix SC-7A, kroky 1–5): Žadatel nebo Patron zašle
koordinátorovi žádost o zrušení e-mailem (přímo, nebo přes obecnou kontaktní adresu); front-office
koordinátora žádost přijme a potvrdí její přijetí, poté ručně zruší Žádost v back-office systému;
Systém následně změní stav Žádosti na `canceled_by_user` a v rámci téže na stavu založené reakce
odešle tuto potvrzovací zprávu.

Podle aktualizované poznámky ke scénáři (SC-7A, "updated") může dobrovolné zrušení přímo iniciovat
pouze Žadatel; Patron sám tuto cestu spustit nemůže. Manuální akce koordinátora (SC-7A krok 3) leží
mimo kontrakt zprávy — je to precondition, která vyvolá uložení stavu, na něž tato zpráva reaguje.

Úroveň evidence: Confirmed pro spouštěcí stav, cestu manuální žádosti/akce koordinátora a pravidlo
iniciace pouze Žadatelem (SC-7A, SC-7A updated, řádky `canceled_by_user` v Notification Matrix).

---

## Příjemci

- **Žadatel (Parent)** — e-mail (přes ES0006, Mautic) **a** notifikace v zóně, obě označené `YES`
  pro stav `canceled_by_user` ve sloupcích Žadatele v Notification Matrix (popisek stavu
  "Zrušeno žadatelem"). Tato zpráva je e-mailová varianta; protějšek v zóně pro stejný stav/roli
  spravuje MSG0006.
- **Patron** — e-mail (přes ES0006, Mautic) označený `YES` pro stav `canceled_by_user` ve sloupci
  Patrona (popisek stavu "Příběh zrušen"); Notification Matrix označuje sloupec Patronovy notifikace
  v zóně ("user account notification") pro tento stav jako `NO`, takže Patron je pro tento stav
  zasahován pouze e-mailem, nikoli zprávou v zóně.

Pro tuto zprávu není doložena žádná obsahová odlišnost pro RO/MD nad rámec obecného rozlišení šablon
podle země, které je již zaznamenáno na úrovni capability (FN0019); zde citovaná evidence
z Notification Matrix je primárně za CZ.

---

## Obsah zprávy

Koncepčně každé odeslání této zprávy nese:

- Konstatování potvrzující, že Žádost (EN0001) — a ze strany Patrona i související případ/příběh
  dítěte — byla zrušena a že zrušení bylo provedeno na vlastní žádost dané strany (dobrovolné
  zrušení), nikoli z důvodu nespolupráce nebo timeoutu.
- Implicitní identifikaci předmětné Žádosti (EN0001), aby příjemce rozpoznal, který případ je
  potvrzován jako zrušený.
- Pro Žadatele: potvrzení, že jeho (nebo Patronem přeposlaná) žádost o zrušení byla vyřízena —
  zdvořilé potvrzení uzavírající smyčku požadavku přijatého koordinátorem.
- Pro Patrona: prosté oznámení, že příběh/případ, do něhož byl zapojen, byl zrušen, aniž by nutně
  bylo uvedeno, že o zrušení požádal Žadatel.

Zde není stanoven žádný pevný text předmětu, značkování těla zprávy ani struktura šablony — konkrétní
znění je instanční/konfigurační data podle role (řízená ApplicationReaction), nikoli kanonický obsah
zprávy (viz omezení v rules-MSG.md).

Každé odeslání e-mailu Žadateli i Patronovi je archivováno jako záznam EmailArchive (EN0022) bez
ohledu na to, zda bylo dané odeslání skutečně přeneseno, v souladu s obecným chováním platformy pro
archivaci e-mailů (viz MSG0005, kde je popsána sdílená výhrada k archivaci).

---

## Poznámky

- Vyčleněno z obecného e-mailu při změně stavu (MSG0005) — který mezi svými doloženými catch-all
  stavy rovněž uvádí `canceled_by_user` — protože tento stav nese odlišný, vysoce významný záměr
  (potvrzení stranou požadovaného zrušení zpět žadateli), a nikoli pouze prosté označení stavu; tento
  dokument je kanonickým, vyhrazeným zpracováním tohoto záměru, podle stejného vzoru vyčlenění
  z catch-all, jaký je použit u MSG0009 (Žádost vrácena k doplnění) a dalších zpráv s odlišným
  záměrem.
- Odlišeno od MSG0017 (automatické zrušení z důvodu timeoutu, `canceled_timeout`): MSG0018 je
  iniciováno stranou a manuálně provedeno koordinátorem; MSG0017 je řízeno systémem po
  nezodpovězených urgencích. Obě zprávy sdílejí stejný mechanismus fan-outu (UC0002.2), ale spouští
  se na různých stavech a nesou odlišný záměr.
- Notification Matrix eviduje řádky `canceled_by_user` jako `OK` (bez příznaku nejednoznačnosti
  parsování), na rozdíl od několika sousedních řádků pro zrušení (`canceled_application`,
  `canceled_lead`, `canceled_timeout`) označených `CHECK_PARSE`; popisek stavu této zprávy a vzorec
  Email/Notification YES/NO/YES/NO jsou použity tak, jak jsou doloženy, bez nejistoty vyplývající
  z jejich sladění.
- Úroveň evidence pro celkový mechanismus spouštěče/příjemců: Confirmed. Úroveň evidence pro to, zda
  je pravidlo iniciace pouze Žadatelem (SC-7A updated) v současném systému skutečně vynuceno, nebo
  jde pouze o deklarovaný záměr v akceptačním scénáři: Partial — skutečnou pojistkou je manuální krok
  koordinátora (SC-7A krok 3), nikoli systémem vynucovaná kontrola iniciátora doložená v evidenci
  této zprávy.
