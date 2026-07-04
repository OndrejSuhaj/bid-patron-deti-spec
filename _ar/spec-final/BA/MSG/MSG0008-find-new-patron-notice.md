---
doc_id: MSG0008
title: Find New Patron Notice
canonical_layer: MSG
spec_type: transactional-message
status: canonical
modules: []
trigger:
  - UC0002
references:
  - EN0001
  - EN0002
  - EN0005
  - EN0022
  - ES0006
---

# MSG0008 – Výzva k nalezení nového patrona

## Účel

Informovat Žadatele (Parent) o tom, že se stávající Patron v Žádosti (Application) nebude dále
angažovat — buď proto, že Patron nedokončil svou část po uplynutí obou urgencí, nebo proto, že Patron
nominaci aktivně odmítl — a že Žadatel musí pro pokračování případu nominovat náhradního Patrona. Ve
stejné události informovat původního Patrona o tom, že jeho zapojení do této Žádosti (EN0001) skončilo.
Pokud Žadatel včas nedodá náhradního Patrona, je požadavek Žadateli zopakován s eskalujícími
urgencemi.

Jde o samostatný, výše prioritizovaný typ zprávy vyčleněný z obecného stavově řízeného souhrnného typu
(MSG0005/MSG0006): událost změny patrona nese konkrétní výzvu k akci (nominovat náhradu) namísto
obecného oznámení „změnil se váš stav" a zároveň oslovuje dvě různé strany dvěma různými zprávami v
rámci jedné události.

---

## Spouštěč

UC0002 (Orchestrace změny stavu žádosti) — navazující reakční větvení (UC0002.2) spouštěné vstupem do
stavu `returned_new_patron`, k němuž dochází buď:

- automaticky, když Patron nedokončil svou část Žádosti v rámci nastaveného okna po uplynutí druhé
  urgence (cesta timeoutu při nedokončení ze strany Patrona), nebo
- okamžitě, když Patron aktivně odmítne nominaci (akce Patrona „Odmítnout").

Vstup do stavu `returned_new_patron` zároveň spouští související vedlejší efekt vymazání dat na
Žádosti (EN0001) popsaný v UC0002 AF3 (vymazání profilových a scoringových dat souvisejících s
patronem) — toto chování náleží UC0002/EN0001 a zde není znovu popisováno.

Pokud Žadatel nedodá kontaktní údaje náhradního Patrona, je stejný požadavek Žadateli zopakován při
dvou eskalujících urgencích: `returned_new_patron_reminder_1` a `returned_new_patron_reminder_2`.

Doloženo řádky Notification Matrix pro `returned_new_patron`, `returned_new_patron_reminder_1`,
`returned_new_patron_reminder_2` (`intake/test-scenarios/test-scenarios.md`, list „Notification
Matrix") a akceptačními scénáři SC-2C (nedokončení ze strany Patrona → změna patrona), SC-2D (Patron
odmítá), SC-6A (nalezen nový Patron a dokončí žádost) a SC-6C (Žadatel nikdy nedodá nového Patrona →
žádost zrušena).

---

## Příjemci

Dvě různé strany dostávají v rámci téže spouštěcí události dvě různé zprávy:

| Strana | Kanál(y) | Doklad v Notification Matrix |
|---|---|---|
| Žadatel / Parent | E-mail (ES0006 Mautic) + zóna (Zóna žadatele) | `returned_new_patron` → Žadatel: E-mail YES; notifikace v zóně: na počátečním řádku nedoloženo jako YES, avšak řádky urgencí (`returned_new_patron_reminder_1`, `returned_new_patron_reminder_2`) uvádějí pro Žadatele YES jak u e-mailu, tak u notifikace v zóně |
| Původní Patron | E-mail (ES0006 Mautic) + zóna (Zóna patrona) | `returned_new_patron` → Patron: E-mail YES, notifikace v zóně YES |

Varianty urgencí (`returned_new_patron_reminder_1`, `returned_new_patron_reminder_2`) cílí pouze na
Žadatele — žádný odpovídající řádek urgence neoslovuje původního Patrona, kterému již bylo při
počáteční události sděleno, že jeho zapojení skončilo.

CZ je doloženým primárním trhem pro tuto zprávu; žádná RO/MD specifická obsahová varianta není
doložena nad rámec obecného platformního rozlišování šablon podle země (FN0019).

---

## Obsah zprávy

Konceptuální informační prvky, které zpráva musí obsahovat (bez značení šablony, bez znění předmětu):

**Žadateli (počáteční i obě urgence):**

- Sdělení, že se stávající Patron v Žádosti (EN0001) nebude dále angažovat — ať už z důvodu
  nedokončení, nebo aktivního odmítnutí — aby Žadatel chápal, proč je nyní vyžadována akce.
- Výzva k akci: Žadatel musí poskytnout identifikační a kontaktní údaje nového Patrona (jméno a
  e-mail), aby Žádost mohla pokračovat.
- Odkaz na místo v Zóně žadatele, kam se mají tyto údaje o náhradním Patronovi zadat.
- Při urgencích totéž zopakování požadavku s narůstajícím naléhavým vyzněním, vázaným na blížící se
  termín, do kterého má Žadatel reagovat.

**Původnímu Patronovi (pouze při počáteční události):**

- Sdělení, že Žádost (EN0001) s ním nemůže pokračovat — tj. že jeho nominace byla vrácena/zamítnuta —
  aby chápal, že jeho zapojení do tohoto konkrétního případu skončilo.
- Žádná výzva k akci pro Patrona: jde o uzavírací oznámení, nikoli o žádost.

Každé odeslání e-mailové varianty kterékoli ze zpráv je archivováno jako záznam EmailArchive (EN0022)
bez ohledu na to, zda k odeslání skutečně došlo (FN0019).

---

## Poznámky / Nejistoty

- Stav `returned_new_patron` je spolu s oběma svými stavy urgencí (`returned_new_patron_reminder_1`,
  `returned_new_patron_reminder_2`) seskupen jako jeden typ zprávy s variantou požadavku/urgence
  určenou Žadateli a variantou uzavíracího oznámení určenou Patronovi, dle pokynu ke seskupování pro
  tento syntézní průchod — není rozepsán po jednotlivých řádcích Notification Matrix.
- Pokud Žadatel nominuje náhradního Patrona, tento nový Patron obdrží MSG0002 (Odkaz k dokončení
  žádosti) k dokončení své části Žádosti — jde o samostatnou zprávu odesílanou na základě akce
  nominace patrona, která není součástí obsahu této zprávy (viz MSG0002 Spouštěč, cesta změny
  patrona).
- Pokud Žadatel nikdy nedodá náhradního Patrona a všechny termíny urgencí uplynou, případ končí
  samostatným oznámením o zrušení (stav `canceled_timeout` v Notification Matrix / SC-6C) — mimo
  rozsah této MSG.
- Notification Matrix označuje počáteční řádek `returned_new_patron` → Žadatel u notifikace v zóně
  jako „NO", zatímco akceptační scénáře SC-2C/SC-2D a jejich řádky v matici (řádky ~134, 147) popisují,
  že Zóna žadatele při téže události zobrazuje stav vyžadující akci „Najít nového patrona" — jde o
  **Conflict — requires clarification**: zaznamenáno zde namísto tichého vyřešení. Oba řádky urgencí
  pro Žadatele uvádějí notifikaci v zóně = YES bez nejasností.
- Přesné doslovné znění předmětu/těla zprávy (např. „Najděte nového Patrona", „Zamítnutá žádost") je
  konfigurační/stavová slovníková data a v tomto kanonickém dokumentu není tvrzeno jako pevný text
  šablony (viz omezení v rules-MSG.md).
