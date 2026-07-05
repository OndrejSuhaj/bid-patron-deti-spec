---
doc_id: WIRE0006
title: Application Contact Consent Gate
layer: WIRE
spec_type: wireframe
modules: []
screen_id: S007
realizes_uc: [UC0001]
status: imported
references:
  - UC0001
  - EN0001
  - EN0006
  - EN0008
  - IA-patronus (S006, S007, S008a)
---

# WIRE0006 – Kontaktní a souhlasová brána žádosti

## Účel

S007 je vstupní krok role fundraisera v rámci self-registračního flow žádosti (Žádost) na
`/zadost/zadatel`. Zachycuje minimální identifikační kontaktní údaje (e-mail + telefon) a
GDPR/marketingový souhlas požadovaný před tím, než může Customer pokročit do víceskokového
formuláře žádosti (S008a). Realizuje sub-flow "Customer self-registration" v rámci `UC0001`
(UC0001.1, kroky 1–3: otevření vstupního bodu registrace, zobrazení minimálního registračního
formuláře a odeslání e-mailu/telefonu/souhlasu). Aktér: anonymní návštěvník vystupující jako
potenciální fundraiser (`UC0001` "Customer"). Vstupní kontext: obrazovka je dosažitelná z karty
role fundraisera na landing obrazovce s výběrem role (S006); odkaz "Zpět na výběr" se na ni vrací.
**Confirmed** — screenshot `screencapture-patrondeti-cz-zadost-zadatel-2026-07-04-13_18_12.png`.

Open Question — na stejné route byla zaznamenána druhá obrazovka
(`screencapture-patrondeti-cz-zadost-zadatel-2026-07-04-13_18_04.png`, "Co budete k vyplnění
žádosti potřebovat?" — mezikrok se seznamem dokumentů a vlastním CTA "Pokračovat"), která
**není** obrazovka citovaná evidencí IA/observed-areas pro S007. Zda se jedná o samostatnou
obrazovku v rámci téhož flow (předcházející tuto bránu), nebo o alternativní/AB stav
`/zadost/zadatel`, není vyřešeno — nejde o součást evidence S007 v IA Screen Map a je to mimo
rozsah tohoto WIRE; zaznamenáno, aby to nebylo tiše sloučeno do rekonstrukce S007. **Uncertain.**

---

## Layout zóny

- Header — globální navigace webu (logo "patron dětí", "Jak to funguje", "Blog", "O nás",
  CTA "Požádat o pomoc", odkaz "Můj účet") — sdílený chrome, zde nerekonstruováno (viz IA). **Confirmed.**
- Pás s ikonou / nadpisem — ikona lidí, H1 "Začneme tím, že nám sdělíte váš telefon a e-mail" a
  dva řádky podpůrného textu (ujištění o ochraně soukromí + připomenutí připravenosti dokumentů). **Confirmed.**
- Navigace zpět — odkaz "← Zpět na výběr" nad panelem formuláře, návrat na S006. **Confirmed.**
- Panel formuláře (karta) — světle šedý panel obsahující:
  - Nadpis panelu "Údaje o Vás"
  - Řádek se dvěma poli: vstup "E-mail", vstup "Telefon" s prefixem "+420"
  - Souhlasový checkbox s vloženým odkazem ("zpracováním osobních údajů") a nápovědným řádkem
    ("Souhlasy můžete upravit/zrušit zasláním e-mailu na souhlas@patrondeti.cz.")
  - Primární CTA "Pokračovat"
  **Confirmed.**
- Sekce FAQ — nadpis "Často kladené otázky" se dvěma sbalenými accordion položkami pod panelem
  formuláře. **Confirmed.**
- Footer — cookie banner, sloupce patičky webu (O nás/Blog/Pravidla/Naše desatero/Splněné
  příběhy/Výroční zprávy/…), kontaktní e-mail, odznaky platebních poskytovatelů, patičkové odkazy
  "Souhlas se zpracováním osobních údajů" / "Chci přihlásit příběh", copyright — sdílený chrome,
  zde nerekonstruováno (viz IA). **Confirmed.**

```
+--------------------------------------------------------+
| Header (logo, nav, Požádat o pomoc, Můj účet)           |
+--------------------------------------------------------+
|                    [icon]                               |
|      Začneme tím, že nám sdělíte váš telefon a e-mail    |
|          <privacy + document-readiness copy>            |
|  ← Zpět na výběr                                         |
+----------------------------------------------------------+
| Form panel                                                |
|   Údaje o Vás                                             |
|   [ E-mail            ] [ +420 | Telefon            ]     |
|   [ ] Souhlasím se zpracováním osobních údajů a...        |
|       Souhlasy můžete upravit/zrušit zasláním e-mailu...  |
|          [ Pokračovat ]                                   |
+----------------------------------------------------------+
|                Často kladené otázky                       |
|   > Proč musí mít každé dítě svou vlastní žádost o dar?    |
|   > Proč musí mít každý příběh svého Patrona?              |
+----------------------------------------------------------+
| Footer (cookie banner, link columns, contact, badges)      |
+----------------------------------------------------------+
```

---

## Použité komponenty

Opakující se prvky povýšené na COMP nástrojem **AR:COMPSynthesizer** (viz `COMP-inventory-map.md`);
ostatní položky zůstávají označené `inline` (bez evidence opakování na ≥2 obrazovkách).

| Zóna | COMP-id | Varianta/vlastnosti | Poznámky |
|---|---|---|---|
| Header | COMP0002 | context=public | viz `COMP0002` Global Site Header |
| Pás s ikonou / nadpisem | inline | ikona + H1 + 2 řádky textu | — |
| Navigace zpět | inline | textový odkaz s úvodním symbolem šipky | "← Zpět na výběr" |
| Panel formuláře — pole E-mail | inline | jednořádkový textový vstup, placeholder "E-mail" | nad polem není viditelný label; placeholder zastupuje label |
| Panel formuláře — pole Telefon | inline | fixní prefixový segment "+420" + jednořádkový textový vstup, placeholder "Telefon" | prefix se jeví jako needitovatelný (zaznamenáno pouze pro CZ); Uncertain, zda RO/MD lokalizace zobrazují jiný prefix (Patronus provozuje CZ/RO/MD dle kontextu projektu) — Open Question, pro neCZ lokalizaci této obrazovky nebyla zaznamenána žádná evidence |
| Panel formuláře — souhlasový checkbox | COMP0006 | count-per-form=single | ve výchozím stavu nezaškrtnuto; viz `COMP0006` Consent Checkbox |
| Panel formuláře — CTA | COMP0001 | — | popisek "Pokračovat"; viz `COMP0001` Primary Button |
| Sekce FAQ | inline | accordion, 2 sbalené položky | položky: "Proč musí mít každé dítě svou vlastní žádost o dar?", "Proč musí mít každý příběh svého Patrona?" — zaznamenán pouze sbalený stav, rozbalený obsah nebyl zachycen |
| Cookie banner | COMP0004 | — | viz `COMP0004` Cookie Consent Banner |
| Footer | COMP0003 | — | viz `COMP0003` Global Site Footer |

---

## Interakce

1. **Vstup** — navigace z karty role fundraisera na S006 na `/zadost/zadatel` → stav: `default`.
   **Confirmed** (tabulka vstupních bodů IA).
2. **Primární akce — "Pokračovat"** — Customer vyplní e-mail + telefon, zaškrtne souhlasový
   checkbox a odešle formulář → spustí `UC0001` (UC0001.1 kroky 3–11: validace, kontrola domény
   e-mailu, vytvoření User/Contact/Application, odeslání aktivačního e-mailu) → dále: přesměrování
   do formuláře žádosti (S008a) podle tabulky vstupních bodů IA (přesměrování `/zadost-formular` ze
   S007 po zadání kontaktu/souhlasu). **Confirmed** pro cíl přesměrování; mezikroky
   validace/vytvoření náleží `UC0001` a zde nejsou opakovány.
3. **Sekundární akce — "Zpět na výběr"** — návrat na obrazovku výběru role (S006). **Confirmed.**
4. **Sekundární akce — vložený odkaz na souhlas ("zpracováním osobních údajů")** — otevírá
   podmínky zpracování osobních údajů; cílový obsah patří do oblasti COPY/legal-content, zde
   nerekonstruováno. **Confirmed** (odkaz je přítomen) / **Uncertain** (cílový obsah/obrazovka).
5. **Sekundární akce — položky accordion FAQ** — rozbalení/sbalení; rozbalený obsah nebyl
   zachycen. **Assumed** (standardní chování accordion; rozbalený stav nebyl zaznamenán).
6. **Výstup** — úspěšné odeslání opouští tuto obrazovku prostřednictvím výše uvedené primární
   akce; žádná jiná zaznamenaná cesta ven kromě "Zpět na výběr". **Confirmed.**

---

## Stavy

### default
Prázdný formulář: obě pole prázdná, souhlasový checkbox nezaškrtnutý, "Pokračovat" povoleno/viditelné
(jeho stav disabled-until-valid nebyl zaznamenán — viz Validation Surfaces). **Confirmed** — screenshot
`screencapture-patrondeti-cz-zadost-zadatel-2026-07-04-13_18_12.png`; UOA §6 zaznamenává "initial/empty;
consent checkbox unchecked by default."

### empty
Pro tuto obrazovku se neliší od `default` — obrazovka neobsahuje žádnou listovací/kolekční zónu,
která by mohla být prázdná; prázdný výchozí stav formuláře JE stav default. `N/A — no data-collection
zone with a distinct empty condition; see default state`.

### loading
Nezaznamenáno. Primární akce spouští zpracování `UC0001` (validace e-mailu přes Integration,
vytvoření User/Contact/Application), které je pravděpodobně asynchronní, ale nebyl zaznamenán
žádný indikátor načítání, deaktivované tlačítko ani spinner. **Uncertain — Evidence Pending** (Open
Question, nikoli vymyšleno).

### error
Nezaznamenáno. Žádný screenshot nezachycuje vykreslení chyby validace nebo neúspěšného odeslání
(např. neplatný formát e-mailu, nezaškrtnutý povinný souhlas nebo selhání validace domény e-mailu
z `UC0001` AF3). **Uncertain — Evidence Pending** (Open Question, nikoli vymyšleno). Existenci
tohoto stavu selhání potvrzuje `UC0001` AF3 ("Email domain validation fails" → registrace
blokována), ale její zobrazení na obrazovce S007 není zdokumentováno.

---

## Validation Surfaces

| Pole/zóna | Spouštěč (BR-id) | Surface |
|---|---|---|
| E-mail | žádný nezjištěn | Uncertain — žádné BR nevlastní validaci formátu/povinnosti e-mailu pro tuto obrazovku; `UC0001` krok 4 ("System validates the email format and required consents") potvrzuje, že validace probíhá, ale jde o procedurální chování vlastněné UC, nikoli o BR; způsob zobrazení na obrazovce (inline vs. toast vs. blokující) není zdokumentován (Open Question, chybí screenshot chybového stavu) |
| Telefon | žádný nezjištěn | Uncertain — žádné BR neupravuje formát/povinnost telefonu na této obrazovce; ze samotného screenshotu není zdokumentováno, zda je povinný nebo nepovinný (chybí hvězdička či označení "povinné"); zobrazení na obrazovce není zdokumentováno |
| Souhlasový checkbox | žádný nezjištěn | Uncertain — `UC0001` krok 4 zahrnuje "required consents" do stejného validačního kroku jako e-mail, což naznačuje, že checkbox je pro pokračování povinný, avšak žádný dokument BR nevlastní pravidlo požadavku na souhlas a žádný screenshot chybového stavu nepotvrzuje vynucení ani jeho zobrazení |

**validationsWithoutBR:** E-mail (formát/povinnost), Telefon (formát/povinnost), Souhlasový checkbox
(povinnost pro pokračování) — všechny tři jsou otevřené otázky: `UC0001` stanovuje, že *systémová*
validace formátu e-mailu a požadovaných souhlasů probíhá, ale žádný dokument `BRxxxx` v současnosti
nevlastní konkrétní validační pravidlo (např. povolené formáty telefonu, zda je telefon nepovinný,
minimální rozsah souhlasu) a žádný chybový stav na obrazovce nebyl zaznamenán jako důkaz způsobu
zobrazení porušení.

---

## Data Bindings

| Zóna | EN-id | QUERY-id | Poznámky |
|---|---|---|---|
| Pole E-mail | `EN0006` (Contact.Email) / `EN0008` (User) | — | při odeslání naplní e-mail Contact/User podle `UC0001` kroky 6–7 (vyhledání existujícího User podle e-mailu, vytvoření Contact, pokud neexistuje) |
| Pole Telefon | `EN0006` (Contact.Phone) | — | naplní atribut telefonu Contact (EN0006 "Phone (text; optional; not unique)") |
| Souhlasový checkbox | — | — | v prověřených dokumentech entit nebyl identifikován žádný atribut EN pro uložený příznak/časovou značku souhlasu na Contact (EN0006) nebo User (EN0008) — Open Question: kde se stav souhlasu ukládá? Nezdokumentováno v seznamech atributů EN0006/EN0008 prověřených pro tento WIRE |
| Odeslání formuláře (jako celek) | `EN0001` (Application — vytvořena v počátečním stavu), `EN0006` (Contact — vytvořen/propojen), `EN0008` (User — vytvořen/propojen) | — | podle `UC0001` UC0001.1 kroky 6–11 |

---

## Conditional Visibility

| Komponenta/zóna | Podmínka (odkaz ACL nebo BR) | Chování při skrytí |
|---|---|---|
| Celá obrazovka | pouze pro anonymní uživatele podle předpokladu `UC0001` ("The visitor is anonymous... an already-authenticated Customer is routed directly into the Application without repeating identity capture", `UC0001` AF1) | autentizovaný Customer S007 zcela obchází a je směrován přímo do žádosti (S008a) — neexistuje dokument ACL, který by šlo citovat; zaznamenáno pouze z textu předpokladu/AF1 `UC0001` |
| Odkaz "Jste patron? Vaše žádost je ZDE" | zaznamenán pouze na sousedním screenshotu `13_18_04`, nikoli na screenshotu evidovaném pro S007 (`13_18_12`) | nevztahuje se na zdokumentovaný stav tohoto WIRE — viz Open Question v sekci Účel k oběma screenshotům |

Pro tuto rekonstrukční fázi ještě neexistuje vrstva ACL (podle cross-layer-discipline je ACL
samostatná kanonická vrstva, která ještě nebyla vytvořena); výše uvedené omezení podle role je
zaznamenáno pouze z textu `UC0001`.

---

## Accessibility Notes

- **Pořadí tabulace:** ze statického screenshotu nezdokumentováno; předpokládá se pořadí zleva
  doprava, shora dolů (E-mail → Telefon → souhlasový checkbox → Pokračovat) odpovídající vizuálnímu
  pořadí. **Assumed.**
- **Focus při vstupu:** nezdokumentováno. **Uncertain.**
- **Focus při přechodu stavu:** nezdokumentováno (nebyl zaznamenán žádný stav error/loading). **Uncertain.**
- **Landmarks:** ze screenshotu nezdokumentováno; předpokládá se standardní struktura landmarků
  header/main/footer odpovídající zbytku sdíleného chrome webu. **Assumed.**
- **Klávesové zkratky:** pro tento typ obrazovky nebyly zaznamenány ani se neočekávají.

---

## Evidence

| Oblast tvrzení | Jistota | Evidence |
|---|---|---|
| Layout / text nadpisu / pole formuláře / souhlasový checkbox / sekce FAQ | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-zadost-zadatel-2026-07-04-13_18_12.png`; `_ar/evidence/ui/ui-observed-areas.md` §6 |
| Navigace zpět na S006, přesměrování na formulář S008a | Confirmed | `_ar/spec-draft/IA/IA-patronus.md` §4 Entry Points; `_ar/spec-draft/IA-screen-map.md` řádek S007 |
| Realizovaný UC a kroky self-registračního flow | Confirmed | `_ar/spec-draft/UC/UC0001_SubmitApplication.md` (UC0001.1, AF1, AF3) |
| Data bindings na Contact/User/Application | Probable | `_ar/spec-draft/EN/EN0006_Contact.md`; `_ar/spec-draft/UC/UC0001_SubmitApplication.md` kroky 6–11 |
| Místo perzistence stavu souhlasu | Uncertain | nenalezeno v prověřených seznamech atributů EN0006/EN0008; Open Question |
| Stavy loading / error | Uncertain — Evidence Pending | chybí potvrzující screenshot; `UC0001` AF3 potvrzuje existenci stavu selhání, nikoli jeho zobrazení na obrazovce |
| Vlastnictví validačního pravidla (BR) | Uncertain | nebyl nalezen žádný dokument `BRxxxx` upravující validaci e-mailu/telefonu/souhlasu na této obrazovce; uvedeno v `validationsWithoutBR` |
| Vztah screenshotu se seznamem dokumentů `13_18_04` k S007 | Uncertain | `13_18_04` není citován v `_ar/spec-draft/IA-screen-map.md` řádek S007 ani v `ui-observed-areas.md` §6; zaznamenáno jako Open Question, nesloučeno do rekonstrukce této obrazovky |
