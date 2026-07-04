---
doc_id: MSG0001
title: Application Received Confirmation
canonical_layer: MSG
spec_type: transactional-message
status: canonical
modules: []
trigger:
  - UC0001
  - UC0002
references:
  - EN0001
  - EN0002
  - EN0022
  - ES0006
---

# MSG0001 – Potvrzení přijetí žádosti

## Účel

Potvrdit straně, která právě odeslala svou část Žádosti (Application), že byla přijata, a sdělit
výsledný stav čekání: buď že protistrana (Žadatel/Parent nebo Patron) musí ještě doplnit svou část,
nebo — jakmile jsou obě části doručeny — že případ přešel do revize koordinátorem. Zpráva ujišťuje
iniciující stranu, že odeslání proběhlo úspěšně, a orientuje ji v tom, co bude následovat, aniž by od
ní v tuto chvíli vyžadovala jakoukoli další akci.

---

## Spouštěč

- UC0001 – Odeslání žádosti (Žádost): sebeobslužná registrace/odeslání formuláře zákazníkem, které
  vytvoří nebo doplní jednu stranu Žádosti (EN0001).
- UC0002 – Orchestrace změny stavu žádosti (navazující fan-out reakcí, UC0002.2): uložení Žádosti
  (EN0001), které poprvé nastaví její stav na stav čekání na protistranu (`waiting_for_patron`,
  `waiting_for_fundraiser`), nebo — jakmile jsou přítomny obě části — na stav revize koordinátorem
  (`to_check`).

Podle Notification Matrix (`intake/test-scenarios/test-scenarios.md`) a akceptačních scénářů SC-1A
(kroky 8–11: Žadatel odešle jako první → stav `waiting_for_patron`), SC-1B (kroky 7–8: Patron odešle
jako první → stav `waiting_for_fundraiser`) a SC-4A (kroky 1–2: obě formuláře spojeny → stav
`to_check`) se tato zpráva spouští jednou na každou událost vstupu do stavu, nikoli jednou za každé
odeslané pole formuláře.

---

## Příjemci

Strana × kanál, určeno konfigurací role/reakce na vstup do stavu (ApplicationReaction, EN0026 —
citováno, nikoli opakováno) a odesíláno přes ES0006 (Mautic, e-mail) plus notifikaci v účtu/zóně:

| Stav (spouštěč) | Žadatel/Parent — e-mail | Žadatel/Parent — v zóně | Patron — e-mail | Patron — v zóně |
|---|---|---|---|---|
| `waiting_for_patron` (Žadatel odeslal jako první) | ANO | ANO | NE | ANO |
| `waiting_for_fundraiser` (Patron odeslal jako první) | NE | ANO | ANO | ANO |
| `to_check` (obě části spojeny, revize koordinátorem) | ANO | ANO | ANO | ANO |

- Strana, která právě odeslala svou část, obdrží variantu zprávy ve formě potvrzení; protistrana
  (je-li již známá, např. e-mail Patrona zadaný Žadatelem) obdrží variantu vyžadující akci, nesoucí
  odkaz k doplnění její části — tento obsah vyžadující akci je MSG0002, odlišná od této potvrzovací
  zprávy (viz poznámka k hranici vůči MSG0002 níže).
- CZ je primárně doloženým trhem; stejný stavem řízený spouštěč platí i v RO/MD prostřednictvím mapy
  šablon podle země na doručovací vrstvě (ES0006/FN0019) — znění specifické pro danou zemi je věcí
  doručovací šablony, nikoli součástí kontraktu této zprávy.

---

## Obsah zprávy

Konceptuální informační prvky, které zpráva musí nést (bez textu šablony, bez HTML, bez znění
předmětu):

- Které straně bylo přijato odeslání (část Žadatele/Parent, nebo část Patrona).
- Aktuální lidsky čitelný stav Žádosti (Application) — např. „čeká na protistranu" nebo „v revizi
  koordinátorem" — čerpaný ze stejného slovníku stavů jako zobrazení stavu v zóně (`intake/statuses/`),
  zde neopakovaný jako pevná množina řetězců.
- Potvrzení, že od příjemce se v tuto chvíli nevyžaduje žádná další akce (varianta potvrzení),
  odlišující tuto zprávu od odkazu vyžadujícího akci zaslaného protistraně (MSG0002).
- Odkaz zpět do zóny příjemce pro sledování průběhu Žádosti.
- Identifikace Žádosti/případu, kterého se zpráva týká (odkaz na dítě/případ), čerpaná ze Žádosti
  (EN0001) a jejího ApplicationProfile (EN0002) — atributy vlastněné těmito entitami, zde neopakované.

---

## Poznámky k hranicím

- Odlišná od MSG0002 (zpráva vyžadující akci protistrany / doplnění vaší části), která je odesílána
  dosud čekající straně ve stejné události vstupu do stavu, ale nese akční odkaz k doplnění namísto
  potvrzení.
- Mechanika doručení (rozlišení šablony Mautic podle země, synchronní brána odeslání, archivace
  pokusu o odeslání) je vlastněna FN0019 (Transakční zprávy a šablonování) a entitou EmailArchive
  (EN0022) — zde citováno, nikoli opakováno.
- Samotná logika párování stavu na příjemce na kanál (které role/stavy spouští který kanál) je
  konfigurace vlastněná entitou ApplicationReaction (EN0026, odkazovaná přes UC0002) a evidencí
  Notification Matrix; tento dokument popisuje výsledný kontrakt zprávy, nikoli tento konfigurační
  mechanismus.
- **Vymezení vlastnictví vůči fan-outu stavů (MSG0005 e-mail / MSG0006 v zóně).** MSG0001 je
  vyhrazená zpráva s vyšší prioritou, která vyčleňuje tři stavy prvního vstupu (`to_check`,
  `waiting_for_patron`, `waiting_for_fundraiser`) ze skupinového e-mailového souhrnu MSG0005 pro
  stavy: e-mailová událost „žádost přijata" pro tyto stavy prvního vstupu je vlastněna **zde**
  (MSG0001), nikoli MSG0005. Varianta **v zóně** téže události prvního vstupu do stavu zde vlastněna
  není — jde o tutéž událost fan-outu stavů, kterou seskupuje MSG0006 (skupinová notifikace stavu v
  zóně). Vlastnictví je tedy následující: MSG0001 = e-mailové potvrzení při prvním vstupu do
  `to_check` / `waiting_for_patron` / `waiting_for_fundraiser`; MSG0006 = zpráva stavu v zóně pro
  tytéž vstupy do stavu; MSG0005 = e-mailový souhrn pro zbývající (nevyčleněné) řádky stavů. (Viz
  MSG0005 a MSG0006.)

---

## Úroveň evidence

Confirmed pro spouštěcí stavy a matici role×kanál (řádky Notification Matrix pro
`waiting_for_patron`, `waiting_for_fundraiser`, `to_check`; SC-1A kroky 8–11; SC-1B kroky 7–8;
SC-4A kroky 1–2).

**Conflict — requires clarification (e-mailový kanál pro `to_check`).** Pro událost „obě formuláře
spojeny / žádost přijata" SC-4A kroky 1–2 označují Email = NE jak pro Žadatele, tak pro Patrona,
zatímco řádek Notification Matrix pro `to_check` označuje Email = ANO pro oba. Oba zdroje evidence
se rozcházejí v tom, zda se potvrzovací e-mail spouští při prvním vstupu do `to_check`; tento rozpor
je zaznamenán, nikoli vyřešen ve prospěch jedné z hodnot (podle pravidla evidence platí, že kód/tok
má přednost pro současné chování, ale rozpor je uveden a oba zdroje jsou citovány:
`intake/test-scenarios/test-scenarios.md` — SC-4A kroky 1–2 a řádky Notification Matrix pro
`to_check`). Hodnotu ANO/ANO z Matrix nepovažujte za ustálenou pro tuto událost, dokud nebude
vyjasněna.

Partial ohledně přesného znění/rozlišení předmětu mezi variantou potvrzení a variantou vyžadující
akci pro tentýž stav, jelikož Notification Matrix zaznamenává výsledky kanál/stav, nikoli text
obsahu podle příjemce — výše uvedené prvky obsahu jsou rekonstruovány ze sdíleného slovníku stavů a
evidence toku UC0001/UC0002, nikoli ze zachyceného těla zprávy.
