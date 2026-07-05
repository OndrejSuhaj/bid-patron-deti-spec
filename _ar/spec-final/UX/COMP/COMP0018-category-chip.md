---
doc_id: COMP0018
title: CategoryChip
canonical_layer: COMP
spec_type: component
modules: []
status: canonical
design_source: /Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/packages/ui/src/components/CategoryChip/
references:
  - WIRE0001
  - WIRE0002
  - EN0004
  - COMP0008
  - COMP0011
  - DESIGN-component-index
  - DESIGN-tokens
---

# COMP0018 – CategoryChip

## Účel

Tento dokument povyšuje **CategoryChip**, kanonický `@patron/ui` **Atom**, na základě instrukce
zadání ("tato komponenta byla v rekonstrukci ponechána jako inline; nyní ji povyš"). Obsahuje
**dvě jasně oddělené množiny faktů** podle projektové disciplíny current-vs-target:

- **Zarovnání s design systémem (target)** — autoritativní kanonický kontrakt pro CategoryChip tak,
  jak je postaven v knihovně rebuildu `bid-patron-deti` (`packages/ui/src/components/CategoryChip/`):
  indikátor kategorie příběhu, jehož barva je jednotná na všech místech, kde se kategorie zobrazuje
  (samotný chip, podklad karty, rohový overlay na hero) — "stejná kategorie = stejná barva všude."
- **Current-state (observované)** — co rekonstruovaný current-state UX Patronusu
  (`WIRE0001_HomepageStoryCatalogue.md`, `WIRE0002_StoryDetailAndDonationModal.md`) skutečně
  zobrazuje jako ekvivalentní indikátor kategorie, který byl ponechán jako `inline` (bez povýšení na
  COMP), protože current-state evidence dříve nepodporovala tvrzení o izolovaném znovupoužitelném
  atomu.

Tyto dvě části popisují **odlišné systémy** (target rebuildu vs. rekonstruovaný current-state
Patronus) a nesmí být slučovány do jednoho faktu. Podle `DESIGN-component-index.md` řádek 5 je
kanonický kontrakt autoritativním targetem; current-state část níže zaznamenává pouze to, co bylo
přímo zjištěno na živém webu, s odchylkami vyznačenými, nikoli tiše vyřešenými.

Křížový odkaz: tento dokument je sesouladěn s `DESIGN-component-index.md` řádek 5 a
`_ar/evidence/design-system/components.md` §1 "CategoryChip — `components/CategoryChip/`". Je také
referencován jako komponovaná subkomponenta v `COMP0008` (StoryCard, target Composition) a
`COMP0011` (StoryHero, target Composition/Dependencies).

---

## Zarovnání s design systémem (target — `@patron/ui` + `@patron/tokens`)

> **STATE: TARGET.** Vše v této části popisuje kanonickou komponentu rebuildu
> (`packages/ui/src/components/CategoryChip/`), nikoli současné chování Patronusu. Autoritativní
> zdroj: `_ar/evidence/design-system/components.md` §1 "CategoryChip" a
> `DESIGN-component-index.md` řádek 5. Toto je **autoritativní kontrakt** pro CategoryChip; část
> "Current-state (observed)" níže je samostatný, čistě current-state popis a tento kontrakt
> nedoplňuje ani nemění.

### Účel (target)

Indikátor kategorie příběhu, jednotný napříč storefront UI: stejná kategorie se vždy zobrazuje ve
stejné barvě, ať je zobrazena jako samostatný chip, jako podkladová barva karty, nebo jako rohový
overlay na hero příběhu. Komponovaný v `StoryCard` (`COMP0008`) a `StoryHero` (`COMP0011`) jako
jejich mechanismus barvy kategorie.

### Props / vstupy (target)

| Name | Type | Required | Default | Description |
|---|---|---|---|---|
| `category` | `StoryCategory` (`"development" \| "health" \| "subsistence"`) | yes | — | Určuje, který token `--color-category-*` se v chipu použije, prostřednictvím interní custom property `--cat`. Váže se na atribut kategorie z `EN0004`. |
| `label` | `string` | yes | — | Zobrazovací text popisku kategorie (např. "Rozvoj a vzdělání", "Zdraví", "Existenční potřeby"); v komponentě se nepřekládá ani neformátuje. Nese také accessible name (viz Accessibility). |

Exportované typy: `CategoryChipProps`, `StoryCategory` (podle `components.md` §1).

### Varianty (target)

- **category:** `development` | `health` | `subsistence` — jedna varianta pro každou hodnotu
  kategorie, každá řídí odlišný token `--color-category-*` prostřednictvím custom property `--cat`.
  Neexistuje samostatná osa "variant" nad rámec samotného props `category` — vizuální varianta a
  hodnota dat jsou totéž.
- **size:** fixní — žádný prop/osa pro velikost není dokumentována (podle `components.md` §1:
  "Sizes: fixed").

### Stavy (target)

#### idle
Jediný dokumentovaný stav: kategorií tónované pozadí + text, vykreslované po celou dobu. Podle
`components.md` §1: "States: idle (category-tinted bg + text)."

#### hover
`Uncertain — not itemized in the canonical catalogue; CategoryChip is not documented as an
interactive element (no onClick/href prop in the exported CategoryChipProps).`

#### focused
`Uncertain — not itemized; consistent with hover, the component is presentational, not a control.`

#### disabled
N/A — žádné vykreslení disabled stavu není součástí kanonického kontraktu; CategoryChip je
zobrazovací atom, nikoli control.

#### loading
N/A — není v kanonickém katalogu uvedeno; `category` a `label` jsou povinné, synchronně dostupné
props.

#### error
N/A — žádný error-state není dokumentován (žádný validation/error prop v `CategoryChipProps`).

### Events (target)

Žádné vysílané eventy — `CategoryChipProps` (podle `components.md` §1) uvádí pouze zobrazovací
props (`category`, `label`); komponenta je prezentační Atom bez dokumentovaného callbacku.

### Accessibility (target)

- **ARIA role:** samostatně nedokumentována; vykresluje se jako běžný inline element nesoucí textový
  obsah (`label`), bez naznačené interaktivní/native-control role.
- **Komponovaná ikona je dekorativní:** interně komponovaná `Icon` (glyf odpovídající kategorii,
  velikost 15px) nemá vlastní accessible name — podle `DESIGN-component-index.md` řádek 5, poznámky
  A11y: "Composed `Icon` is category-matched (size 15) — decorative, label text carries the
  accessible name." Text v props `label` je tedy jediným zdrojem accessible name chipu.
- **Klávesová navigace:** N/A — žádný focusovatelný/interaktivní element není dokumentován jako
  nativní součást CategoryChip.
- **Správa fokusu:** N/A ze stejného důvodu.
- **Screen reader:** ohlašuje text `label`; komponovaná ikona se samostatně neohlašuje (dekorativní,
  viz výše).

### Chování podle tenanta (target — CZ/RO přes `data-theme`)

- CategoryChip sám nemá **žádné tenant-specifické props** — taxonomie kategorií se 3 hodnotami
  (`development`/`health`/`subsistence`) je sdílena mezi oběma tenanty; pouze *mapování barev* je
  vázané na tenanta, nikoli taxonomie nebo API komponenty. Podle `DESIGN-component-index.md` řádek
  5, poznámky Tenant: "Category taxonomy (3 values) is shared across tenants; color mapping is
  token-level, not tenant-switched."
- Přebarvení mezi `data-theme="cz"|"ro"` probíhá výhradně přemapováním tokenů:
  - `var(--color-category-development)` — CZ `#149E6E` / RO `#0FB5AE`, podle `DESIGN-tokens.md` §3.3.
  - `var(--color-category-health)` — CZ `#6D4AFF` / RO `#2F7DBF`, podle `DESIGN-tokens.md` §3.3.
  - `var(--color-category-subsistence)` — CZ `#C2740A` / RO `#FF7A2F`, podle `DESIGN-tokens.md` §3.3.
- **Styl** glyfu komponovaného atomu `Icon` (linkový vs. plný) sleduje konvenci tenanta — CZ =
  linkový, RO = plný — přepínaný přes `data-theme` na samotném atomu `Icon`, nikoli přes prop na
  úrovni CategoryChip (podle `DESIGN-component-index.md` řádek 3 "Icon", poznámky Tenant).

> **Otevřený bod (nepovažovat za uzavřený):** `DESIGN-tokens.md` §9 upozorňuje, že "the three
> categories in §3.3 (development, health, subsistence) are asserted from the canonical
> prototype/design-system demo only. The binding category list (and per-tenant color mapping) for
> the rebuild must be confirmed by BA/analyst work before the UX layer treats `color.category.*` as
> a closed set." Toto se přímo vztahuje na union typ `category` v CategoryChip — jde o aktuální
> podobu kanonického prototypu, nikoli BA-potvrzenou finální taxonomii.

### Omezení použití (target)

- Použít když: je potřeba indikovat kategorii příběhu kdekoli ve storefront UI, kde by se měla
  konzistentně uplatnit konvence barvy podle kategorie (samostatný chip, komponovaný uvnitř
  `StoryCard`/`StoryHero`).
- Nepoužívat když: je potřeba kategorií tónovaný *podklad plochy* nebo *rohový overlay na hero* bez
  vlastního pill tvaru chipu — to jsou samostatné vykreslovací zpracování v komponujícím Blocku
  (`StoryCard`/`StoryHero`), které sdílejí stejný token `--color-category-*`, nikoli tato komponenta
  znovupoužitá bez úprav jako podklad.
- Kardinalita: typicky jeden na kontext příběhu (jeden chip na instanci `StoryCard`, jeden na
  instanci `StoryHero`); vícenásobné souběžné instance jsou očekávané napříč gridem/listem.
- Umístění: inline uvnitř komponujícího Blocku (`StoryCard`, `StoryHero`) nebo samostatně; není
  dokumentováno jako overlay/modální element.

### Závislosti (target)

- Ostatní COMP (composition): komponuje `Icon` (`DESIGN-component-index.md` řádek 3) — glyf
  odpovídající kategorii, velikost 15, dekorativní.
- Datové entity: `EN0004` Campaign — atribut kategorie (poznámka k current-state vazbě v části
  Current-state níže).
- ACL: nic dokumentováno.
- Externí knihovny: nic dokumentováno.

### Composition (target)

```
CategoryChip
  └─ Icon (category-matched glyph, size 15, decorative)
```

Komponováno **v** (konzumenti, nikoli subkomponenty CategoryChip):

```
StoryCard  (COMP0008, target) ──uses──▶ CategoryChip (COMP0018)
StoryHero  (COMP0011, target) ──uses──▶ CategoryChip (COMP0018)
```

### Token slots (target — kanonické CSS proměnné, viz `DESIGN-tokens.md`)

| Token | Role zde |
|---|---|
| `var(--color-category-development)` | Tón pozadí/textu chipu při `category="development"` |
| `var(--color-category-health)` | Tón pozadí/textu chipu při `category="health"` |
| `var(--color-category-subsistence)` | Tón pozadí/textu chipu při `category="subsistence"` |
| `var(--color-surface)` | Reference povrchu text/foreground chipu (podle seznamu tokenů `components.md` §1) |
| `var(--font-body)` | Typografie popisku chipu |
| `var(--radius-pill)` | Tvar chipu (plně zaoblený pill) |

Podle `DESIGN-tokens.md` §10 jsou všechny konzumovány přes `var(--…)` v colokovaném CSS modulu
komponenty — žádné hex/px literály v kódu komponenty; mapování kategorie na barvu se řeší přes
nepřímou vazbu na custom property `--cat` (podle `components.md` §1: "drives `--cat` custom prop →
`--color-category-*`").

### Příklady (target)

```
<CategoryChip category="development" label="Rozvoj a vzdělání" />
<CategoryChip category="health" label="Zdraví" />
<CategoryChip category="subsistence" label="Existenční potřeby" />
```

Storybook stories (podle `components.md` §1): `Rozvoj`, `Zdraví`, `Existenční`.

---

## Current-state (observed — rekonstruovaný current-state UX Patronusu)

> **STATE: CURRENT.** Vše v této části popisuje to, co bylo skutečně zjištěno na živém webu
> Patronusu, ze statické screenshotové evidence homepage katalogu
> (`WIRE0001_HomepageStoryCatalogue.md`, obrazovka `S001`) a obrazovky detailu příběhu
> (`WIRE0002_StoryDetailAndDonationModal.md`, obrazovka `S002`). Nepopisuje **target** rebuildu
> uvedený výše. Podle `rules-COMP.md` se COMP vytváří pouze "when reuse is observable across two or
> more WIRE screens/screenshots" — konkrétně pro indikátor kategorie je znovupoužití napříč ≥2
> potvrzeně postavenými obrazovkami (`WIRE0001`, `WIRE0002`) **doloženo** (viz tabulka Evidence),
> a to je přesně důvod, proč se tento element nyní povyšuje, místo aby zůstal `inline`. Nicméně
> *samotná hranice komponenty* (je to izolovaný znovupoužitelný chip, nebo je vždy vykreslen jako
> součást větší kompozice, jako je pill ve stat-stripu nebo badge na kartě?) zůstává méně jistá než
> čistá hranice Atomu v target kontraktu — tato current-state část tuto zbytkovou nejistotu
> zaznamenává, nikoli řeší přejetím tvaru targetu.

### Kde se to na živém webu dnes objevuje

- **`WIRE0001` — Homepage katalog příběhů (`S001`), zóna "Stat strip".** Dvě **category pill
  CTA** se zobrazují vedle číselné statistiky "323 dětí čeká na pomoc": `WIRE0001` řádek 51 "Stat
  strip — '323 dětí čeká na pomoc' + 2 category pill CTAs"; řádek 86 je popisuje jako "two
  pill-shaped category ... map [links]". `WIRE0001` řádek 132 (Components Used) tyto explicitně
  označuje jako `inline` s otevřenou otázkou: "category pills' filter effect not confirmed as wired
  to the grid below (Uncertain — no visible active-state change captured)."
- **`WIRE0001` — badge na kartě v gridu katalogu.** Každá karta katalogu nese "category icon
  badge" podle `WIRE0001` řádek 90 (anatomie karty: "category icon badge, photo, 'ZBÝVÁ <n> <unit>'
  countdown ribbon..."). Toto je nejbližší current-state analogie k target `CategoryChip`
  komponovanému uvnitř `StoryCard` (`COMP0008`), ale vlastní current-state sekce Composition v
  `COMP0008` **ne**vypisuje category badge jako potvrzený subelement karty (viz Odchylka níže) —
  bylo to zachyceno pouze na úrovni WIRE, nikoli zapracováno do current-state Composition v
  `COMP0008`.
- **`WIRE0002` — Stránka detailu příběhu (`S002`), donation sidebar.** **Category tag** ("Rozvoj a
  vzdělání") s ikonou se objevuje uvnitř donation sidebaru: `WIRE0002` řádek 64 "Donation sidebar...
  category tag ('Rozvoj a vzdělání') with icon"; shrnuto rovněž v popisu zóny Media, řádek 31: "the
  fundraising case (child, category, ...)". Vlastní sekce Odchylka v `COMP0011` (StoryHero)
  zaznamenává, že tento tag v sidebaru **není** potvrzen jako komponovaný na rohu hero fotky v
  current-state — sídlí v sidebaru, nikoli přeložený přes media zónu.
- **Screenshotová evidence:**
  `_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png` (homepage katalog, stat-strip
  pills + badges na kartách) a
  `_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_25_48.png`
  (category tag v sidebaru detailu příběhu).

### Current-state pozorované props/chování

- **Zjištěný text popisku:** "Rozvoj a vzdělání" (`WIRE0002` řádek 64) a "Zdravotní pomoc" /
  "Rozvoj a vzdělání" jako dva popisky pillů ve stat-stripu (`WIRE0001` řádek 181: "Secondary
  action — category pill CTA ('Zdravotní pomoc' / 'Rozvoj a vzdělání')"). Dvě ze tří target hodnot
  kategorie (`development` a pill s popiskem zdraví) mají přímou current-state evidenci popisku;
  current-state vykreslení explicitně popsané pro target kategorii `subsistence` **není** v těchto
  dvou obrazovkách potvrzeno — `Uncertain`, zda současný Patronus na živých obrazovkách katalogu/
  detailu vystavuje třetí vizuálně odlišný tón kategorie, nebo jen dva.
- **Přítomnost ikony:** "category icon badge" na kartě katalogu (`WIRE0001` řádek 90) i category
  tag v sidebaru "with icon" (`WIRE0002` řádek 64) oba potvrzují, že v current-state doprovází
  popisek ikona, konzistentně s komponovanou `Icon` v targetu. Konkrétní mapování glyfu na
  kategorii **není** ze statických screenshotů potvrzeno — `Uncertain`.
- **Konzistence barvy podle kategorie: `Uncertain`.** Klíčové tvrzení target kontraktu ("stejná
  kategorie = stejná barva všude — chip, podklad karty, rohový overlay na hero") je designový
  princip na straně *target* (`components.md` §1: "unified across UI"). Zda current-state Patronus
  skutečně uplatňuje jednu konzistentní barvu na kategorii napříč pillem ve stat-stripu, badge na
  kartě a tagem v sidebaru, **nelze ověřit** z dostupných screenshotů (barvy nebyly systematicky
  porovnány napříč všemi třemi umístěními v zachycených WIRE) — zaznamenat jako `Uncertain`,
  nepředpokládat, že princip unifikace targetu už v current-state platí.
- **Interaktivita — pouze pilly ve stat-stripu.** Na rozdíl od target kontraktu (prezentační, bez
  eventů) jsou current-state pilly kategorie ve stat-stripu explicitně **CTA** — `WIRE0001` řádek
  181–182: "click → presumed filter/navigation to a category-scoped view; **Uncertain** — no
  before/after comparison [captured]." Toto je current-state-only interaktivní chování bez
  protějšku v target kontraktu `CategoryChip` (viz Odchylka níže).
- **CTA podpory kategorie na detailní stránce.** `WIRE0002` řádek 175–177 zaznamenává příbuzný, ale
  odlišný element: "Secondary action — category-support CTA — 'Chci podporovat rozvoj a vzdělání'
  doubles as a category-level support entry... same target as recurring CTA per evidence (no
  separate category-only flow observed) — Assumed." Toto je CTA tlačítko, které *odkazuje* na
  kategorii jménem ve svém popisku, nikoli samotný category tag/chip — zde ponecháno odděleně,
  nezapracováno do current-state popisu tohoto COMP.

### Current-state varianty / stavy / events / accessibility

Podle disciplíny evidence v `rules-COMP.md` jsou nepozorované osy zaznamenány jako `Uncertain`,
nikoli vymyšlené:

- **Varianty:** Dvě umístění jsou doložena s odlišným current-state chováním — (a) pill CTA ve
  stat-stripu (`WIRE0001`, klikatelný) a (b) informační tag v sidebaru/na kartě (`WIRE0002`, badge
  na kartě katalogu — žádné klikací chování potvrzeno). Zda jde o *stejnou* podkladovou current-
  state komponentu vykreslenou s volitelnou CTA afordancí, nebo o dva samostatně postavené
  elementy, které se pouze podobně vypadají, je `Uncertain` — touto rekonstrukční fází nevyřešeno.
- **Varianty hodnoty kategorie:** instance s popiskem `development` a se zdravotním popiskem jsou
  přímo doloženy; instance s popiskem odpovídajícím `subsistence` je `Uncertain — not captured in
  WIRE0001/WIRE0002`.
- **Stavy (hover/focused/disabled/loading/error):** `Uncertain — not observable from static
  evidence` pro všechna umístění, konzistentně s celkovým postojem a11y/interakce zaznamenaným v
  `WIRE0001`/`WIRE0002`.
- **Events:** pill CTA ve stat-stripu (`WIRE0001`) má předpokládaný, ale nepotvrzený efekt
  click→navigace (Uncertain, viz výše); tag v sidebaru (`WIRE0002`) a badge na kartě katalogu
  (`WIRE0001`) **nemají** žádný pozorovaný event — zaznamenáno jako statické/informační.
- **Accessibility:** `Uncertain — no DOM/recording evidence for any placement, consistent with
  WIRE0001`'s and `WIRE0002`'s overall a11y posture.`

### Odchylka current-state vs. target (zaznamenat, nikoli "opravovat")

1. **Current-state má interaktivní variantu CTA; target žádnou.** Pilly kategorie ve stat-stripu na
   `WIRE0001` se chovají jako klikatelné CTA (předpokládaný filter/navigace). Target kontrakt
   `CategoryChip` nedokumentuje žádné eventy/callback props (pouze prezentační Atom). Toto je
   skutečný behaviorální rozdíl current-vs-target, nikoli rozdíl v pojmenování — kanonický Atom
   rebuildu, jak je aktuálně specifikován, by potřeboval jiný komponující element (nebo doplnění
   props, které ještě není dokumentováno), aby reprodukoval current-state chování pill-CTA.
2. **Target unifikuje barvu napříč třemi umístěními; current-state unifikace je nepotvrzená.**
   Definující princip targetu — "stejná kategorie = stejná barva všude (chip, podklad karty, rohový
   overlay na hero)" — není verifikován oproti current-state evidenci (viz výše, "Konzistence
   barvy podle kategorie: Uncertain"). Tvrzení targetu o unifikaci nelze číst tak, že už dnes u
   Patronusu platí.
3. **Třetí hodnota kategorie v current-state nepotvrzena.** Target taxonomie má tři hodnoty
   (`development`/`health`/`subsistence`); current-state evidence přímo potvrzuje pouze dva odlišné
   popisky (zdravotně orientovaný, rozvojově orientovaný) napříč dvěma zachycenými obrazovkami. Zda
   má současný Patronus třetí tón/popisek odpovídající `subsistence`, je `Uncertain`.
4. **Hranice komponenty je v current-state méně čistá.** Target `CategoryChip` je samostatně
   stojící Atom komponovaný pod jménem do `StoryCard`/`StoryHero`. V current-state evidenci byl
   indikátor kategorie zachycen jako součást větších kompozitních popisů ("category icon badge"
   uvnitř seznamu anatomie karty katalogu, `WIRE0001` řádek 90; "category tag... with icon" uvnitř
   seznamu anatomie donation sidebaru, `WIRE0002` řádek 64), nikoli jako samostatně identifikovaný
   element v tabulce Components Used kteréhokoli z dokumentů WIRE. Jeho povýšení zde na COMP0018
   následuje instrukci zadání a prahovou hodnotu ≥2 obrazovek znovupoužití, ale podkladová
   current-state hranice elementu (chip vs. badge vs. tag — jedna a táž věc, nebo tři podobně
   vypadající věci) zůstává `Uncertain`.
5. **Žádná current-state analogie "podkladu karty" nebo "rohového overlaye na hero" nepotvrzena.**
   Ostatní dvě unifikovaná umístění targetu (kategorií tónovaný podklad pozadí karty; rohový overlay
   chipu na hero) nemají žádnou přímou current-state evidenci: current-state sekce Composition v
   `COMP0008` nezaznamenává kategorií tónovaný podklad na kartě katalogu a current-state část v
   `COMP0011` explicitně zaznamenává, že tag v sidebaru *není* potvrzen jako komponovaný na rohu
   hero fotky. Obojí zůstává pouze target-only fakt.

### Závislosti (current-state)

- Ostatní COMP: žádný nepotvrzen jako samostatně znovupoužitelný current-state subelement —
  indikátor kategorie byl zaznamenán jako `inline` v rámci vlastní anatomie layout-zóny v
  `WIRE0001` a `WIRE0002`, nikoli jako samostatná položka v tabulce Components Used kterékoli z
  obrazovek.
- Datové entity: `EN0004` Campaign — atribut kategorie, podle Data Bindings v `WIRE0002`:
  `"Category tag ('Rozvoj a vzdělání') | EN0004 | — | gift_category attribute"` (`WIRE0002` řádek
  238).
- ACL: nic doloženo.
- Externí knihovny: nic doloženo.

### Composition (current-state)

```
Stat strip (WIRE0001, S001) — current-state, inline
  └─ category pill CTA ×2 ("Zdravotní pomoc", "Rozvoj a vzdělání"; click behavior Uncertain)

Catalogue card (WIRE0001, S001) — current-state, inline within COMP0008's card anatomy
  └─ category icon badge (icon + implied category; not itemized as its own Components-Used row)

Donation sidebar (WIRE0002, S002) — current-state, inline
  └─ category tag ("Rozvoj a vzdělání" + icon; static, no confirmed click behavior)
```

### Evidence

| Oblast tvrzení | Jistota | Evidence |
|---|---|---|
| Znovupoužití napříč ≥2 potvrzeně postavenými obrazovkami (práh pro povýšení na COMP) | Confirmed | `WIRE0001` (pilly ve stat-stripu + badge na kartě) a `WIRE0002` (tag v sidebaru) oba zobrazují indikátor kategorie |
| Přítomnost pill CTA ve stat-stripu | Confirmed | `WIRE0001` řádky 51, 86, 181–182 |
| Klikací/filtrovací chování pillu ve stat-stripu | Uncertain | `WIRE0001` řádek 132: "not confirmed as wired to the grid below"; řádek 182: "no before/after comparison" |
| Category icon badge na kartě katalogu | Confirmed | `WIRE0001` řádek 90 (anatomie karty) |
| Category tag v donation sidebaru ("Rozvoj a vzdělání" + ikona) | Confirmed | `WIRE0002` řádek 64; screenshot `screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_25_48.png` |
| Datová vazba `gift_category` / `EN0004` | Confirmed | `WIRE0002` řádek 238 (Data Bindings) |
| Konzistence barvy podle kategorie napříč umístěními | Uncertain | nebylo systematicky porovnáno napříč zachyceními WIRE |
| Třetí (`subsistence`-ekvivalentní) hodnota kategorie v current-state | Uncertain | pouze dva odlišné popisky zachyceny napříč `WIRE0001`/`WIRE0002` |
| Hranice komponenty (jeden chip vs. odlišné elementy badge/tag/pill) | Uncertain | nevypsáno jako samostatná položka v tabulce Components Used kterékoli obrazovky |
| Accessibility (všechna umístění) | Uncertain | žádná DOM/nahrávková evidence k dispozici |
| Target kanonický kontrakt (props/varianty/stavy/tokeny/a11y) | Confirmed (jako target fakt) | `_ar/evidence/design-system/components.md` §1 "CategoryChip"; `DESIGN-component-index.md` řádek 5; zdroj `packages/ui/src/components/CategoryChip/{CategoryChip.tsx, CategoryChip.contract.md, CategoryChip.module.css}` |

---

## Open Questions

- Zda current-state Patronus uplatňuje jednu konzistentní barvu na kategorii napříč všemi třemi
  pozorovanými umístěními (pill ve stat-stripu, badge na kartě katalogu, tag v sidebaru) — nelze
  vyřešit z existujících zachycení bez vyhrazeného porovnávacího průchodu barev napříč screenshoty.
- Zda má current-state Patronus třetí hodnotu kategorie ekvivalentní k target hodnotě
  `subsistence` — `Uncertain`, žádná evidence ani jedním směrem v `WIRE0001`/`WIRE0002`.
- Zda jsou pill CTA ve stat-stripu (`WIRE0001`), badge na kartě katalogu a tag v sidebaru
  (`WIRE0002`) vykreslovány *stejnou* current-state šablonou/partialem, nebo jde o tři nezávisle
  postavené elementy, které se náhodou podobně vypadají — nelze vyřešit ze statických screenshotů;
  vyžadovalo by to DOM/zdrojovou inspekci `intake/current-solution/_source/patronus/` (mimo
  evidenční základ tohoto dokumentu), aby to bylo definitivně uzavřeno.
- Zda kliknutí na category pill ve stat-stripu current-state Patronusu skutečně filtruje/naviguje
  grid katalogu — vyznačeno jako Uncertain na úrovni WIRE (`WIRE0001` řádek 132, 182) a přeneseno
  sem nevyřešeno.
- Zda má target `CategoryChip` rebuildu (pouze prezentační, podle svého kanonického kontraktu) plně
  nahradit current-state interaktivní filtrovací pill ve stat-stripu, nebo zda se očekává, že toto
  filtrovací chování bude žít v jiné budoucí komponentě/kompozici — nerozhodnuto v
  `components.md`/`DESIGN-component-index.md`; jde o otázku rozsahu rebuildu, nikoli o
  sesouladění, které by tento dokument mohl vyřešit.
