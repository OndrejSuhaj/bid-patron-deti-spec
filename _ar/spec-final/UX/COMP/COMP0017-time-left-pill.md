---
doc_id: COMP0017
title: TimeLeftPill
canonical_layer: COMP
spec_type: component
modules: []
status: canonical
design_source: /Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/packages/ui/src/components/TimeLeftPill/
references:
  - WIRE0001
  - WIRE0002
  - EN0004
  - COMP0008
  - COMP0010
  - COMP0020
---

# COMP0017 – TimeLeftPill

## Účel

Tento dokument povyšuje **TimeLeftPill**, kanonický `@patron/ui` **Atom**, podle instrukce úlohy
("tato komponenta zůstala v rekonstrukci inline; nyní ji povyš"). Obsahuje **dva jasně oddělené
soubory faktů** podle projektové disciplíny current-vs-target:

- **Design-system alignment (target)** — autoritativní kanonický kontrakt pro TimeLeftPill tak, jak
  je vybudován v rebuild knihovně `bid-patron-deti` (`packages/ui/src/components/TimeLeftPill/`):
  pilulka zbývajícího času kampaně se dvěma stavy — calm (neutrální odstín) a urgent (plnohodnotný
  alert badge s mírným pulzováním).
- **Current-state (observed)** — co rekonstruovaný current-state UX Patronus
  (`WIRE0001_HomepageStoryCatalogue.md`, `WIRE0002_StoryDetailAndDonationModal.md`) skutečně
  zobrazuje jako ekvivalentní volný text "countdown ribbon"/deadline badge, který zůstal `inline`
  uvnitř kompozice `StoryCard` (v původní UX rekonstrukční fázi neexistovala žádná dedikovaná
  povýšená COMP), protože current-state evidence jej podporovala pouze jako prop `COMP0008`, nikoli
  jako samostatně rekonstruovaný znovupoužitelný atom.

Tyto dvě části popisují **různé systémy** (rebuild target vs. rekonstruovaný current Patronus)
a nesmí být slučovány do jednoho faktu. `COMP0008` (StoryCard) §"Composition (canonical)" toto
povýšení již anticipuje, když uvádí, že current-state "deadline countdown ribbon" odpovídá
v cílovém modelu složené podkomponentě `TimeLeftPill` (`COMP0017`) — tento dokument je tou
povýšenou komponentou.

Křížový odkaz: tento dokument je sesouhlasen s `DESIGN-component-index.md` řádek 6 a
`_ar/evidence/design-system/components.md` §1 "TimeLeftPill".

---

## Design-system alignment (target — `@patron/ui` + `@patron/tokens`)

> **STATE: TARGET.** Vše v této části popisuje kanonickou komponentu rebuildu
> (`packages/ui/src/components/TimeLeftPill/`), nikoli current-state chování Patronus. Autoritativní
> zdroj: `_ar/evidence/design-system/components.md` §1 "TimeLeftPill — `components/TimeLeftPill/`"
> a `DESIGN-component-index.md` řádek 6.

### Účel (target)

Pilulka zbývajícího času kampaně. Stav calm se vykresluje jako neutrální odstín (informativní,
neznepokojující); stav urgent se vykresluje jako plnohodnotný alert badge s mírnou pulzující
animací. Stav urgent čte dedikované stavové tokeny (`color.urgent` / `color.onUrgent`), záměrně
oddělené od brand palety, aby naléhavost působila konzistentně bez ohledu na brand barvu tenanta
(`_ar/evidence/design-system/components.md` §1, řádek 129-130).

### Props / Vstupy (target)

| Název | Typ | Povinný | Výchozí | Popis |
|---|---|---|---|---|
| `label` | `string` | ano | — | Zobrazitelný countdown text (např. "Zbývá měsíc", "Zbývá 16 dní"). Není formátován/překládán uvnitř komponenty — consumer dodává finální řetězec. |
| `urgent` | `boolean` | ne | `false` | Vybírá vykreslení urgent (alert badge, pulzující) namísto vykreslení calm (neutrální odstín). |

Exportovaný typ: `TimeLeftPillProps` (podle `components.md` §1).

### Varianty (target)

- **urgency:** calm | urgent — řízeno výhradně boolean propem `urgent`, nikoli samostatným enumem.
- **size:** fixed — žádná osa velikosti není dokumentována (`components.md` §1: "Variants: calm/urgent. Sizes: fixed.").

### Stavy (target)

#### idle
Dvě klidová vykreslení, vybíraná propem `urgent` (tato komponenta nemá žádné vlastní interaktivní
stavy — viz hover/focused/disabled níže):
- **calm:** odstín odvozený z `color.text` nad `color.surface`; text labelu v `color.muted`.
- **urgent:** pozadí `color.urgent`, text `color.onUrgent`; přehrává animaci `urgentpulse`.

#### hover
N/A — TimeLeftPill je neinteraktivní prezentační atom (stavový badge, nikoli control); žádný stav
hover není v kanonickém katalogu dokumentován.

#### focused
N/A — není fokusovatelný; pro TimeLeftPill není dokumentován žádný `tabindex`/interaktivní role.

#### disabled
N/A — vykreslení disabled není součástí kanonického kontraktu; na neinteraktivní stavové pilulce
není co zakazovat.

#### loading
`Uncertain — neuvedeno v kanonickém katalogu (components.md / DESIGN-component-index.md
nedokumentují stav loading/skeleton pro TimeLeftPill).`

#### error
N/A — žádné vykreslení error není dokumentováno; komponenta má přesně dva dokumentované stavy
(calm, urgent), oba platné/normální, nikoli chybové podmínky.

### Události (target)

Žádné události nejsou emitovány — `TimeLeftPillProps` (podle `components.md` §1) uvádí pouze
`label` a `urgent`; žádné callback propy nejsou dokumentovány.

### Přístupnost (target)

- **ARIA role:** není samostatně dokumentována; složený `Icon` (name="clock") je ve výchozím stavu
  dekorativní podle vlastního kontraktu `Icon` (`DESIGN-component-index.md` řádek 3: "no intrinsic
  role/label — consuming component must supply `aria-label` where meaningful"). Zda TimeLeftPill
  takový `aria-label` pro svou clock ikonu dodává, je `Uncertain — not itemized beyond the Icon
  atom's general default behavior.`
- **Ovládání klávesnicí:** N/A — nejde o fokusovatelný/interaktivní prvek.
- **Správa focusu:** N/A ze stejného důvodu.
- **Pohyb / reduced-motion:** animace `urgentpulse` je **explicitně vypnuta pod
  `prefers-reduced-motion`** — konkrétní, evidované a11y rozhodnutí
  (`_ar/evidence/design-system/components.md` §1, řádek 134-135: "urgent (`color-urgent` bg,
  `color-on-urgent` text, `urgentpulse` animation, disabled under `prefers-reduced-motion`)"; také
  zaznamenáno přes `DESIGN-component-index.md` řádek 6 A11y notes: "`urgentpulse` animation
  explicitly disabled under `prefers-reduced-motion`").
- **Screen reader:** viditelný text `label` nese přístupný obsah (je to prostý textový obsah, nikoli
  obrázek); žádné další screen-reader-specifické chování není dokumentováno nad rámec výše
  uvedené poznámky k `Icon`.

### Chování napříč tenanty (target — CZ/RO přes `data-theme`)

Theme-neutrální komponenta: žádné CZ/RO-specifické propy. Podle `DESIGN-component-index.md`
řádek 6 "Tenant notes": *"Theme-neutral; urgent state uses dedicated `color.urgent`/`color.onUrgent`
tokens, distinct from brand palette per tenant."*

- `var(--color-urgent)` / `var(--color-on-urgent)` — **stejná hodnota u obou tenantů**: CZ `#D92D20`
  / RO `#D92D20` (a `#FFFFFF` / `#FFFFFF` pro on-urgent), podle `DESIGN-tokens.md` §3.2 "Status
  family (4) — own tokens, NOT derived from brand." Naléhavost tedy vizuálně vypadá identicky napříč
  CZ a RO, na rozdíl od brand-vázaných slotů.
- `var(--color-text)`, `var(--color-surface)`, `var(--color-muted)` — odstín stavu calm a barva
  labelu se remapují podle tenanta podle `DESIGN-tokens.md` §3.1 (CZ `#2A1A15`/`#FFFFFF`/`#7C665E`;
  RO `#132247`/`#FFFFFF`/`#586A8C`).
- Sada glyfů složeného `Icon` (name="clock") se přepíná mezi line (CZ) a filled (RO) přes
  `data-theme`, podle `DESIGN-component-index.md` řádek 3 — nejde o prop na úrovni TimeLeftPill.

### Omezení použití (target)

- Použít, když: signalizace zbývajícího času Kampaně na story-summary nebo story-detail ploše
  (např. složeno do `StoryCard` (`COMP0008`) a `DonationBox` (`COMP0010`)).
- Nepoužívat, když: zobrazuje se fixní/absolutní datum — kontrakt je countdown-styl zobrazovaného
  textu (`label`), nikoli komponenta pro formátování data.
- Kardinalita: typicky jedna na kartu/panel v kontextu Kampaně (jeden fakt o zbývajícím čase na
  příběh).
- Umístění: uvnitř composing Blocku (`StoryCard`, `DonationBox`); v kanonickém katalogu není
  dokumentován jako samostatný prvek úrovně stránky.

### Závislosti (target)

- Ostatní COMP (kompozice): `COMP0020` Icon (`name="clock"`, size 15).
- Datové entity: `EN0004` Campaign — atribut deadline/zbývající čas (current-state vazba; viz
  níže část Current-state pro poznámku k vlastní vazbě rekonstrukce).
- ACL: nic nedokumentováno.
- Externí knihovny: nic nedokumentováno.

### Kompozice (target)

```
TimeLeftPill
  └─ COMP0020 Icon (name="clock", size=15) — decorative countdown glyph
```

Používáno v (směr kompozice, podle `DESIGN-component-index.md` řádky 8 a 13):

```
StoryCard      (COMP0008)  ├─ TimeLeftPill (COMP0017)
DonationBox    (COMP0010)  ├─ TimeLeftPill (COMP0017)
```

### Token slots (target — kanonické CSS proměnné, viz `DESIGN-tokens.md`)

| Token | Role zde |
|---|---|
| `var(--font-body)` | Typografie labelu |
| `var(--radius-pill)` | Tvar pilulky (plně zaoblený) |
| `var(--color-text)` | Zdroj základního odstínu stavu calm |
| `var(--color-surface)` | Základ pozadí stavu calm |
| `var(--color-muted)` | Barva textu labelu stavu calm |
| `var(--color-urgent)` | Pozadí stavu urgent |
| `var(--color-on-urgent)` | Barva textu/ikony stavu urgent |

### Příklady (target)

```
<TimeLeftPill label="Zbývá měsíc" />
<TimeLeftPill label="Zbývá 3 dny" urgent />
```

Storybook příběhy: `Klid` (calm), `Naléhavé` (urgent) — podle
`_ar/evidence/design-system/components.md` §1 seznamu příběhů "TimeLeftPill".

---

## Current-state (observed — rekonstruovaný current-state UX Patronus)

> **STATE: CURRENT.** Vše v této části popisuje to, co bylo skutečně pozorováno na živém webu
> Patronus, ze statické screenshot evidence katalogu na homepage (`WIRE0001`, obrazovka `S001`)
> a lišty souvisejících příběhů na obrazovce detailu Příběhu (`WIRE0002`, obrazovka `S002`).
> **Nepopisuje** rebuild target uvedený výše. Podle `rules-COMP.md` se COMP vytváří pouze "when
> reuse is observable across two or more WIRE screens/screenshots" — tato podmínka je zde **splněna**:
> pilulka/badge deadline countdown je pozorována opakovaně jak na `WIRE0001` (katalogová mřížka,
> 6 karet × 4 screenshoty), tak na `WIRE0002` (lišta souvisejících příběhů, 3 karty). V *původní*
> current-state rekonstrukční fázi však byla zaznamenána jako **prop `COMP0008` StoryCard**
> (`deadlineBadge: string`), nikoli vyčleněna jako vlastní samostatně rekonstruovaná COMP — tento
> dokument nyní povyšuje koncept tohoto volně-textového badge tak, aby stál vedle výše uvedeného
> target kontraktu `TimeLeftPill`, podle instrukce úlohy. Níže uvedená current-state část je tedy
> **reconciliation pohledem na existující evidenci `COMP0008`/`WIRE0001`/`WIRE0002`**, nikoli
> novou rekonstrukční fází.

### Kde se dnes objevuje na živém webu

- **`WIRE0001` — Homepage/Story Catalogue (`S001`), katalogová mřížka.** Popis layoutu: *"category
  icon badge, photo, 'ZBÝVÁ \<n\> \<unit\>' countdown ribbon (or 'SBÍRKOVÝ ÚČET' \[...\])"*
  (`WIRE0001` řádek 90). Tabulka Components Used (`WIRE0001` řádek 135): `Story card | COMP0008 |
  lifecycle=active | repeated 6x per tab; countdown ribbon text varies ("ZBÝVÁ MĚSÍC" / "ZBÝVÁ DEN" /
  "ZBÝVÁ N DNÍ")`.
  - Pozorované konkrétní hodnoty textu napříč zachycenými snímky: "ZBÝVÁ MĚSÍC", "ZBÝVÁ DEN",
    "ZBÝVÁ 3 DNY" (×3), "ZBÝVÁ 5 DNY", "ZBÝVÁ 4 DNY", "ZBÝVÁ 16 DNÍ", "ZBÝVÁ 24 DNÍ" (podle
    `WIRE0001` řádek 165-166 a popisu propu `deadlineBadge` v `COMP0008`).
  - `WIRE0001` řádek 165-166 poznamenává, že mřížka se jeví jako **seřazená podle vzestupného
    deadline** ("confirmed: all 6 visible cards in `13_16_37` show short countdowns — 'ZBÝVÁ DEN',
    'ZBÝVÁ 3 DNY' x3, 'ZBÝVÁ 5 DNY' — consistent with an ascending-deadline sort"), což je chování
    na úrovni stránky/seznamu, nikoli vlastnost samotné komponenty pilulky.
- **`WIRE0002` — Stránka detailu Příběhu (`S002`), "lišta souvisejících příběhů".** *"3 cards (photo,
  countdown badge 'ZBÝVÁ MĚSÍC'/'ZBÝVÁ 16 DNÍ', 'Chybí N Kč' ribbon, name+wish, 'Cílová částka N Kč',
  'Podpořím \<jméno\>' CTA)"* (`WIRE0002` řádek 78-79) — stejný koncept badge znovupoužitý v
  kontextu cross-sell lišty, což potvrzuje reuse napříč ≥2 odlišnými obrazovkami.
  - Vlastní blok progresu v primárním donation sidebaru `WIRE0002` navíc zobrazuje **prózovou**
    frázi zbývajícího času, "Zbývá měsíc" (`WIRE0002` řádek 67), inline uvnitř textu bloku progresu
    sidebaru — v této konkrétní zóně nevykreslenou jako samostatný tvar pilulky/badge. Zda tato
    prózová instance a instance badge na kartě katalogu jsou *stejný* podkladový zdroj dat/textu
    vykreslený ve dvou různých vizuálních podobách, nebo dva nezávisle vytvořené řetězce, je
    `Uncertain — not confirmed by any capture; WIRE0002 itself flags the progress block as
    Uncertain whether it shares a component with COMP0008's internal progress figures.`
- **Screenshot evidence:** `_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png`,
  `13_16_09.png`, `13_16_21.png`, `13_16_37.png` (katalogová mřížka, podle tabulky Evidence
  `WIRE0001`, řádek 296); celostránkový capture detailu Příběhu odkazovaný `WIRE0002` (podle tabulky
  Evidence `WIRE0002`) pro lištu souvisejících příběhů.

### Pozorované current-state propy/chování

- **Volně-textový badge, nikoli strukturovaný kontrakt `{label, urgent}`.** Current-state zaznamenává
  countdown text jako jediný opaque řetězec (prop `deadlineBadge: string` komponenty `COMP0008`) —
  neexistuje pozorovaný/potvrzený boolean příznak naléhavosti odlišný od samotného textového obsahu.
  Zda "ZBÝVÁ DEN" (1 den) vykresluje jakékoli *vizuálně odlišné* alert stylování ve srovnání se
  "ZBÝVÁ MĚSÍC" (1 měsíc), je `Uncertain — no side-by-side capture confirms a color/style change
  tied to urgency; the only observed variation is the text string itself.` Toto je centrální
  divergence current-vs-target — viz níže.
- **Alternativní text "SBÍRKOVÝ ÚČET".** `WIRE0001` řádek 90 poznamenává, že slot badge může
  alternativně zobrazovat "SBÍRKOVÝ ÚČET" (collection-account) namísto countdown, pro skupinový/
  sbírkový typ příběhu — tj. v current-state je tento slot badge přetížen, aby nesl více než čistě
  fakt o zbývajícím čase. Tato alternativní hodnota nemá **žádný protějšek** v target kontraktu
  `TimeLeftPill` (který dokumentuje pouze `label`/`urgent`, oba časově orientované) — `Uncertain`,
  zda target model řeší případ sbírkového účtu jiným řetězcem `label` předaným do stejné komponenty,
  nebo úplně jiným mechanismem; není evidováno žádným způsobem.
- **Žádná ikona nepotvrzena.** Žádný detail screenshotu nepotvrzuje, zda current-state badge/ribbon
  obsahuje glyf ikony hodin (jako to dělá target kompozice `Icon`(name="clock")), nebo je pouze
  textový. `Uncertain — not itemized in WIRE0001/WIRE0002/COMP0008 beyond the text content itself.`
- **Vizuální tvar ("ribbon" vs "pill" vs "badge") je sám v rekonstrukci nepřesný.**
  `WIRE0001` a `WIRE0002` používají slova "ribbon"/"badge"/"countdown badge" pro tento prvek
  zaměnitelně; žádný z current-state dokumentů se nezavazuje ke konkrétnímu tvaru pill/rounded.
  Zda je živé vykreslení vizuálně zaoblená pilulka (odpovídající target `radius.pill`) nebo jiný tvar
  (banner/ribbon rohové zpracování), je `Uncertain — not confirmed by the wording used in the
  reconstruction, which predates this component's promotion.`

### Current-state Varianty / Stavy / Události / Přístupnost

Podle evidence disciplíny `rules-COMP.md` jsou nepozorované osy zaznamenány jako `Uncertain`,
nikoli vymyšlené:

- **Varianty:** pouze variace textové hodnoty ("ZBÝVÁ MĚSÍC" / "ZBÝVÁ DEN" / "ZBÝVÁ N DNY" / "ZBÝVÁ N
  DNÍ" / "SBÍRKOVÝ ÚČET") — `Confirmed` jako volně-textová variace; zda se toto mapuje na
  diskrétní vizuální variantu calm/urgent (jako v target), je `Uncertain` (viz výše).
- **Stavy (hover/focused/disabled/loading):** `Uncertain — not observable from static evidence;`
  prvek není potvrzen jako interaktivní v žádném z dokumentů WIRE.
- **Error:** N/A — žádné vykreslení error evidováno ani plausibilní pro pouze zobrazovací badge.
- **Události:** Žádné události pozorovány — badge je zaznamenán jako passivní zobrazovací prvek
  uvnitř current-state kompozice `COMP0008` StoryCard (sekce Composition current-state `COMP0008`),
  nikoli jako samostatně interaktivní prvek.
- **Přístupnost:** `Uncertain — no DOM/recording evidence, consistent with WIRE0001`'s and
  `WIRE0002`'s overall a11y posture (oba dokumenty zaznamenávají přístupnost jako nepozorovanou
  napříč celým dokumentem).

### Divergence current-vs-target (zaznamenat, nikoli "opravovat")

Podle vlastní sekce "Divergence from observed current-state" `COMP0008` (řádek 296-298) a
`_ar/evidence/design-system/components.md` §1 "TimeLeftPill" je toto zaznamenaná reconciliation
mezera, nikoli defekt:

1. **Volný text vs. strukturovaný kontrakt.** Current-state nese celý fakt countdown jako jeden
   opaque řetězec (`deadlineBadge`); target `TimeLeftPill` jej restrukturuje do dvou propů
   (zobrazovaný text `label` + boolean `urgent` řídící odlišné vizuální zpracování). `COMP0008`
   řádek 296-298 to explicitně zaznamenává: *"`completedBadges`, `deadlineBadge` as free text.
   Current-state records these as ad hoc string props; canonical replaces the deadline concept
   with the structured `TimeLeftPill` (`label` + `urgent` boolean) rather than a free-text badge."*
2. **Naléhavost jako vizuální stav je pouze target, nepotvrzeno v current-state.** Definující rys
   target kontraktu — odlišné vykreslení alert badge urgent s pulzující animací — nemá **žádný
   potvrzený current-state vizuální protějšek**. Current-state evidence ukazuje pouze, že se mění
   *text* ("ZBÝVÁ DEN" vs "ZBÝVÁ MĚSÍC"); zda živý web také mění barvu/styl/animaci pro krátké
   deadline, je `Uncertain`, nedoloženo, a nesmí se předpokládat jen proto, že to má target systém.
3. **Alternativní hodnota "SBÍRKOVÝ ÚČET" nemá protějšek v target.** Viz výše — nevyřešená mezera
   mezi přetíženým slotem badge v current-state a čistě časovým kontraktem `TimeLeftPill` v target.
4. **Přítomnost ikony nepotvrzena v current-state.** Target komponuje ikonu `clock`
   (`COMP0020`); current-state evidence nepotvrzuje ani nevyvrací glyf ikony v pozorovaném badge.
5. **Práh reuse: splněn, ale prostřednictvím jiného current-state artefaktu.** Na rozdíl od
   `COMP0011` StoryHero (kde current-state reuse *nebyl* splněn), podkladový volně-textový badge
   této komponenty *je* pozorován napříč ≥2 obrazovkami WIRE (`WIRE0001` katalogová mřížka,
   `WIRE0002` lišta souvisejících příběhů) — čímž splňuje práh reuse podle `rules-COMP.md`. *Původní*
   rekonstrukční fáze však toto reuse složila do propu `deadlineBadge` komponenty `COMP0008` místo
   vyčlenění dedikované current-state COMP; tento dokument toto rozhodnutí retroaktivně nepřepisuje,
   pouze k němu přidává povýšený target-side kontrakt.

### Závislosti (current-state)

- Ostatní COMP: složeno uvnitř current-state kompozice `COMP0008` StoryCard (jako prvek "deadline
  countdown ribbon"); objevuje se také uvnitř zóny "lišta souvisejících příběhů" `WIRE0002`,
  zaznamenáno tam jako součást opakovaného vzoru karty, nikoli samostatně komponentizováno.
- Datové entity: `EN0004` Campaign — odvozená hodnota deadline/zbývajícího času, podle poznámky
  Data Bindings `WIRE0002`: *"derived `campaign_raised` / `campaign_percentual_raised` vs.
  `gift_price` (target) and `campaign_deadline`, per `BR-CampaignStoryLifecycle`"* (`WIRE0002`
  řádek 241) — text badge/ribbon countdown je zobrazovací vykreslení faktu `campaign_deadline`,
  podle stejného business pravidla.
- ACL: nic nedoloženo.
- Externí knihovny: nic nedoloženo.

### Kompozice (current-state)

```
Story card (WIRE0001, S001) — current-state, deadlineBadge prop of COMP0008
  └─ countdown ribbon (free text: "ZBÝVÁ MĚSÍC" | "ZBÝVÁ DEN" | "ZBÝVÁ N DNY/DNÍ" | "SBÍRKOVÝ ÚČET")

Related stories rail card (WIRE0002, S002) — current-state, same badge concept reused
  └─ countdown badge (free text: "ZBÝVÁ MĚSÍC" | "ZBÝVÁ 16 DNÍ")
```

### Evidence

| Oblast tvrzení | Jistota | Evidence |
|---|---|---|
| Existence badge/ribbon deadline countdown na kartách katalogu | Confirmed | `WIRE0001` řádek 90, řádek 135, řádek 165-166; `_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png` + 3 další captures |
| Reuse napříč ≥2 current-state obrazovkami (práh pro povýšení na COMP) | Confirmed | `WIRE0001` katalogová mřížka (S001) + `WIRE0002` lišta souvisejících příběhů (S002) obě ukazují vzor badge |
| Pouze volně-textový kontrakt, žádná potvrzená vizuální varianta řízená naléhavostí | Uncertain (absence potvrzující evidence) | žádný capture neukazuje side-by-side rozdíl stylu/barvy vázaný na blízkost deadline; liší se pouze text |
| Alternativní hodnota "SBÍRKOVÝ ÚČET" bez protějšku v target | Confirmed (current-state fakt) / Uncertain (mapování na target) | `WIRE0001` řádek 90 |
| Přítomnost ikony/glyfu v current-state vykreslení | Uncertain | neuvedeno v `WIRE0001`/`WIRE0002`/`COMP0008` nad rámec textového obsahu |
| Přístupnost (current-state) | Uncertain | žádná DOM evidence, podle celkové a11y pozice `WIRE0001`/`WIRE0002` |
| Kanonický target kontrakt (props/varianty/stavy/tokeny/a11y) | Confirmed (jako target fakt) | `_ar/evidence/design-system/components.md` §1 "TimeLeftPill"; `DESIGN-component-index.md` řádek 6; zdroj `packages/ui/src/components/TimeLeftPill/{TimeLeftPill.tsx, TimeLeftPill.contract.md, TimeLeftPill.module.css}` |
| Předchozí anticipace tohoto povýšení komponentou `COMP0008` | Confirmed | `COMP0008` §"Composition (canonical)" řádek 205: "TimeLeftPill (COMP0017) — countdown/urgency pill (calm \| urgent)"; §"Divergence" řádek 296-298 |

---

## Otevřené otázky

- Zda živý web Patronus vizuálně rozlišuje badge blízkého deadline ("ZBÝVÁ DEN") od badge vzdáleného
  deadline ("ZBÝVÁ MĚSÍC") jinak než textem (barva, ikona, animace) — `Uncertain`, vyžadovalo by to
  novou close-up/DOM inspekční fázi k vyřešení, nelze odvodit z existujících celostránkových
  catalogue captures.
- Zda je hodnota badge "SBÍRKOVÝ ÚČET" (collection-account) vykreslována *stejnou* podkladovou
  komponentou/slotem jako countdown text, nebo strukturálně odlišným prvkem, který náhodou zaujímá
  stejnou vizuální pozici — `Uncertain`, nevyřešeno současnými zdroji.
- Zda current-state badge obsahuje glyf ikony hodin (nebo jakékoli ikony) — `Uncertain`, žádný
  detail capture to nepotvrzuje ani nevyvrací.
- Zda je inline sidebar fráze "Zbývá měsíc" v `WIRE0002` (próza, nikoli ve tvaru badge) generována
  ze stejného zdroje dat/textu jako badge na kartě katalogu, nebo autorována nezávisle — označeno
  jako `Uncertain` jak zde, tak v `WIRE0002` samotném.
- Zda bude boolean `TimeLeftPill.urgent` v rebuildu v praxi řízen stejnou logikou blízkosti
  `campaign_deadline`, která (podle current-state pozorování) zjevně řídí vzestupné seřazení podle
  deadline v katalogu — jde o otázku target implementace mimo autoritu této rekonstrukce
  (current-state dokumenty nespecifikují současnou logiku řazení/odvození naléhavosti nad rámec
  samotného pozorování "ascending-deadline").
