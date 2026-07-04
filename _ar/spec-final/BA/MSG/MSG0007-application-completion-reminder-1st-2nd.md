---
doc_id: MSG0007
title: Application Completion Reminder (1st / 2nd)
canonical_layer: MSG
spec_type: transactional-message
status: canonical
modules: []
trigger:
  - UC0002
references:
  - EN0001
  - EN0002
  - ES0006
---

# MSG0007 – Urgence na doplnění žádosti (1. / 2.)

## Účel

Upozornit tu stranu, která ještě nedokončila svou část Žádosti (EN0001) — Patrona nebo
Žadatele — aby ji dokončila, s eskalací od první urgence k druhé urgenci, jež zároveň upozorní
protistranu, než případ vyprší a je zrušen [UC0002].

---

## Spouštěč

UC0002 – Orchestrace změny stavu žádosti — konkrétně dílčí tok automatického přechodu stavu řízeného
schedulerem (UC0002.3), který posune Žádost (EN0001) ze stavu čekání do jednoho z urgenčních stavů po
uplynutí doby, přičemž tento přechod se poté znovu vrací do hlavního toku a spouští notifikační
distribuci řízenou stavem (UC0002.2 krok 6).

Spouštěcí stavy (slovník stavů, Confirmed vůči Notifikační matici):

- **1. urgence:** `reminder_1_patron`, `reminder_1_fundraiser`, `reminder_1`, `waiting_reminder_1`
  — dosažen po uplynutí nastavené doby (doloženo jako 2 dny) bez dokončení.
- **2. urgence:** `reminder_2_patron`, `reminder_2_fundraiser`, `reminder_2`, `waiting_reminder_2`
  — dosažen po další době (doloženo jako +5 dní po 1. urgenci) stále bez dokončení.

`reminder_1_fundraiser` / `reminder_2_fundraiser` se týkají strany Žadatele (ve slovníku stavů
označované jako „fundraiser“); `reminder_1_patron` / `reminder_2_patron` a obecné
`reminder_1` / `reminder_2` se týkají strany Patrona; `waiting_reminder_1` / `waiting_reminder_2`
pokrývají stejný eskalační vzor pro případ již vrácený k doplnění (chybějící údaje/dokumenty). Všechny
jsou řízeny stejnou konfigurací ApplicationReaction (EN0026) a mechanismem stárnutí přes cron popsaným
v UC0002.3 — tento dokument je pojímá jako jeden typ zprávy s variantami podle role a kroku, nikoli
jako samostatné zprávy.

Odlišné od dvojice urgencí „hledání nového Patrona“ (`returned_new_patron_reminder_1/2`, tímto
dokumentem nepokryté) a od dvojic urgencí k podpisu a zpětné vazbě (rovněž řízených stavem, ale
vázaných na stavy čekání na podpis smlouvy a na zpětnou vazbu po daru, nikoli na doplnění žádosti).

---

## Příjemci

- **1. urgence** — provinilá strana (ať už jde o roli Patrona nebo Žadatele, která dosud nedokončila
  svou část Žádosti (EN0001)) prostřednictvím e-mailu (ES0006 Mautic) a notifikace v zóně, dle
  Notifikační matice. Zacházení s protistranou **není jednotné** napříč variantami a je třeba jej
  posuzovat podle konkrétního spouštěcího stavu:
    - `reminder_1_patron` a `waiting_reminder_1` (Patron / vrácení k doplnění) — protistrana v tomto
      kroku nedostává nic (v matici má Parent u `reminder_1_patron` oba příznaky NE; Patron má u
      `waiting_reminder_1` oba příznaky NE).
    - `reminder_1_fundraiser` (strana Žadatele) — protistrana Patron **dostává** notifikaci v zóně o
      stavu (bez e-mailu): řádek matice `reminder_1_fundraiser` má u Patrona Email=NE,
      Notifikace=ANO.
- **2. urgence** — opět provinilá strana, **a** protistrana je také informována, že druhá strana stále
  nedokončila svou část (řádky Notifikační matice pro `reminder_2_patron`,
  `reminder_2_fundraiser`, `reminder_2`, `waiting_reminder_2` nastavují příznaky u Parent i Patron).
  Kanál: e-mail (přes ES0006 Mautic) a notifikace v zóně pro obě strany, v závislosti na kombinaci
  příznaků pro daný stav zaznamenané v Notifikační matici (některé řádky vynechávají příznak notifikace
  v zóně pro jednu ze stran — např. u `waiting_reminder_2` je Patron v matici pouze e-mailem).
- Kromě obecného rozlišení šablon podle země, které se uplatňuje u všech transakčních zpráv [ES0006],
  není doložena žádná obsahová odlišnost pro CZ/RO/MD; popisky stavů jsou ve zdrojovém slovníku
  lokalizované (např. RO „reamintire“ pro „urgence“/reminder), jde ale o fakt pojmenování/překladu
  slovníku stavů, nikoli o samostatnou variantu zprávy.

---

## Obsah zprávy

Konceptuální informační prvky, které zpráva musí obsahovat:

- Konstatování, že příjemcova část Žádosti (EN0001) — nebo u varianty vrácení k doplnění požadované
  chybějící informace/dokumenty na Profilu žádosti (EN0002) — je stále nevyřízená.
- Funkční odkaz, který příjemci umožní pokračovat v dokončení své části žádosti; jde o opakované
  použití téhož odkazu k dokončení, který byl vydán při původní výzvě k doplnění, nikoli o nově
  vygenerovaný odkaz.
- Označení, o kterou urgenci se jedná (1. vs. 2.), aby příjemce chápal, v jaké fázi eskalace se
  nachází.
- Pouze u 2. urgence: sdělení protistraně, že druhá strana stále nedokončila svou část, aby byla
  informována o prodlení.
- Implicitní pocit naléhavosti: pokračující nedokončení po tomto cyklu urgencí vede ke zrušení Žádosti
  (EN0001), nebo na straně Patrona k zahájení žádosti o změnu patrona — samotná urgence nemusí uvádět
  přesný následující termín, ale jejím účelem je tomuto výsledku předejít.

Šablonový markup, znění předmětu ani styl zde nejsou specifikovány — jde o záležitosti šablony/doručení
v odpovědnosti odchozího transportu, nikoli tohoto kontraktu [ES0006].

---

## Nejistoty / Poznámky

- Ponecháno jako **jeden sdružený typ zprávy** pokrývající eskalaci 1./2. urgence napříč stranou
  Patrona (`reminder_1_patron`/`reminder_2_patron`, obecné `reminder_1`/`reminder_2`), stranou
  Žadatele (`reminder_1_fundraiser`/`reminder_2_fundraiser`) a variantou vrácení k doplnění
  (`waiting_reminder_1`/`waiting_reminder_2`), namísto rozpadu na samostatný dokument pro každý řádek
  stavu — důkazy (Notifikační matice + UC0002.3) podporují jednotný eskalační mechanismus urgence
  parametrizovaný rolí a krokem, nikoli odlišné návrhy zpráv.
  `Confirmed` pro existenci, tvar eskalace (1. → 2. s kopií protistraně) a kombinaci kanálů;
  `Partial` pro přesné prahy stárnutí (2 dny / +5 dní), které jsou doloženy pouze v akceptačních
  scénářích SC-* (test-scenarios.md) a nejsou nezávisle ověřeny proti minovanému toku dokládajícímu
  samotné pravidlo stárnutí přes cron (UC0002.3 je pro tento bod sám hodnocen jako Partial).
  `Hypothesis — Not evidenced in current sources` ohledně přesného znění následného termínu
  zrušení/změny patrona uvedeného (nebo neuvedeného) přímo v textu urgence; doložen je pouze výsledek
  (zrušení/změna patrona následuje po dalším nedokončení) z navazujících kroků scénářů, nikoli obsah
  samotné urgenční zprávy.
- **Conflict — requires clarification:** `reminder_1` / `reminder_2` (obecná dvojice) jsou ve
  statusovém modelu (intake/statuses/statuses.md) typovány jako stavy entity **Lead**, zatímco
  varianty `*_patron` / `*_fundraiser` / `waiting_*` zde sdružené jsou všechny typovány jako
  **Application**. Jejich zařazení do tohoto dokumentu jako urgencí na doplnění Žádosti EN0001 tak
  odporuje typování entit ve statusovém modelu a vyžaduje vyjasnění.
- Řádky stavů `waiting_signature_reminder_1/2` a `waiting_feedback_reminder_1/2` v Notifikační matici
  následují stejný eskalační vzor 1./2. urgence, ale týkají se podpisu smlouvy a zpětné vazby po daru,
  nikoli doplnění žádosti — jsou mimo rozsah tohoto dokumentu a patří k vlastnímu typu (typům) zprávy.
