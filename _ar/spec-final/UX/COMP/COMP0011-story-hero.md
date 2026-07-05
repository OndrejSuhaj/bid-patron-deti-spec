---
doc_id: COMP0011
title: StoryHero
layer: COMP
spec_type: component
modules: []
status: imported
design_source: /Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/packages/ui/src/components/StoryHero/
references:
  - WIRE0002
  - EN0004
  - COMP0018
---

# COMP0011 – StoryHero

## Účel

Tento dokument povyšuje **StoryHero**, kanonický `@patron/ui` **Block**, podle instrukce zadání
("tato komponenta zůstala v rekonstrukci inline; nyní ji povýšit"). Obsahuje **dvě jasně oddělené
skupiny faktů** podle projektové disciplíny current-vs-target:

- **Sladění s design systémem (target)** — autoritativní kanonický kontrakt pro StoryHero, jak je
  postaven v rebuild knihovně `bid-patron-deti` (`packages/ui/src/components/StoryHero/`): vizuál
  příběhu na detailní stránce — velká fotografie s kategorijním chipem v rohu, s fallbackem na
  záměrné zpracování monogram-on-wash (nikoli generický placeholder), pokud fotografie není
  k dispozici.
- **Current-state (observováno)** — co rekonstruovaný current-state UX Patronusu
  (`_ar/spec-draft/WIRE/WIRE0002_StoryDetailAndDonationModal.md`) skutečně zobrazuje v odpovídající
  zóně obrazovky ("Media zone"), která zůstala `inline` (nebyla povýšena na COMP), protože
  current-state evidence nepodporovala tvrzení o znovupoužitelné komponentě.

Tyto dvě části popisují **odlišné systémy** (rebuild target vs. rekonstruovaný current Patronus)
a nesmí být slučovány do jednoho faktu. Podle `DESIGN-component-index.md` §2 tento target kontrakt
komponenty sladí current-state otevřené otázky zaznamenané u `WIRE0002` (viz část Current-state
níže), avšak sladění je *poznámka*, nikoli přepis toho, co bylo observováno.

Křížová reference: tento dokument se sladí s `DESIGN-component-index.md` řádek 9 a
`_ar/evidence/design-system/components.md` §1 "StoryHero" / §2 mapovací řádek ("GAP→recon").

---

## Sladění s design systémem (target — `@patron/ui` + `@patron/tokens`)

> **STATE: TARGET.** Vše v této části popisuje kanonickou komponentu rebuildu
> (`packages/ui/src/components/StoryHero/`), nikoli current-state chování Patronusu. Autoritativní
> zdroj: `_ar/evidence/design-system/components.md` §1 "StoryHero" a `DESIGN-component-index.md`
> řádek 9.

### Účel (target)

Vizuál příběhu na detailní stránce: velká fotografie s `CategoryChip` (`COMP0018`) v rohu. Pokud
fotografie není dodána, vykreslí se záměrný fallback monogram-on-wash — uvážené designové
rozhodnutí zachovávající rozpoznatelnost, nikoli generický gradientový placeholder.

### Props / vstupy (target)

| Name | Typ | Povinné | Výchozí | Popis |
|---|---|---|---|---|
| `photoUrl` | `string` (URL) | ne | — | Fotografie příběhu/dítěte. Pokud chybí, vykreslí se místo ní varianta monogram-fallback. |
| `photoAlt` | `string` | ne | `""` (prázdný řetězec) | Alt text pro `<img>` fotografie. Výchozí hodnota je záměrně prázdná — viz Přístupnost. |
| `initial` | `string` | ano | — | Písmeno/písmena monogramu zobrazená ve fallback variantě (a použitá jako vizuální kotva, pokud `photoUrl` chybí). |
| `category` | `StoryCategory` (`"development" \| "health" \| "subsistence"`) | ano | — | Určuje barvu/ikonu složeného `CategoryChip` (`COMP0018`); váže se na atribut kategorie entity `EN0004`. |
| `categoryLabel` | `string` | ano | — | Zobrazitelný text popisku kategorie předávaný do složeného `CategoryChip`; není uvnitř StoryHero překládán/formátován. |

Exportovaný typ: `StoryHeroProps` (podle `components.md` §1).

### Varianty (target)

- **stav fotografie:** with-photo | monogram-fallback — určeno čistě přítomností/absencí `photoUrl`, nikoli samostatným propem.
- **kategorie:** by-category — barva/ikona rohového `CategoryChip` se řídí `category`; taxonomie kategorií je sdílena s `COMP0018`/`COMP0016`/`COMP0008` (kanonické target verze).

### Stavy (target)

#### idle
Výchozí vykreslení: velká fotografie (nebo monogram fallback) s `CategoryChip` umístěným v rohu.

#### hover
`Uncertain — není uveden jako samostatný interaktivní stav v kanonickém katalogu; StoryHero není dokumentován jako samostatně klikatelný (jde o vizuální blok uvnitř kompozice stránky StoryDetail, nikoli o vlastní odkaz).`

#### focused
`Uncertain — není uveden; žádný fokusovatelný element není dokumentován jako nativní součást StoryHero (složený CategoryChip je prezentační, podle COMP0018).`

#### disabled
N/A — vykreslení disabled není součástí kanonického kontraktu; StoryHero je zobrazovací blok, nikoli ovládací prvek.

#### loading
`Uncertain — není uveden v kanonickém katalogu (components.md / DESIGN-component-index.md nedokumentují loading/skeleton stav pro StoryHero).`

#### error
N/A — kanonický kontrakt řeší případ "bez fotografie" pomocí varianty monogram-fallback (navržený stav, nikoli chybový stav); žádné samostatné vykreslení chyby načtení obrázku není dokumentováno.

### Events (target)

Nevysílá žádné eventy — StoryHero je prezentační Block bez dokumentovaných callback propů
(`StoryHeroProps` podle `components.md` §1 uvádí pouze zobrazovací propy: `photoUrl`, `photoAlt`,
`initial`, `category`, `categoryLabel`).

### Přístupnost (target)

- **ARIA role:** pro kontejner samostatně nedokumentována; fotografie se vykresluje jako standardní
  `<img>`, pokud je `photoUrl` přítomen.
- **Výchozí `photoAlt` je `""`:** podle kanonického kontraktu má `photoAlt` výchozí hodnotu prázdný
  řetězec. Jde o záměrnou autorskou volbu ve zdrojovém katalogu (nikoli mezeru, kterou by
  rekonstrukce mohla tiše "opravit") — prázdnou výchozí hodnotu považujte za úmyslnou, pokud budoucí
  revize kontraktu neuvede jinak; `Uncertain — designové zdůvodnění výchozí prázdné hodnoty alt
  (např. pojímání hero fotografie jako dekorativní, pokud kontext popisku již nese význam) není
  uvedeno nad rámec samotné výchozí hodnoty propu.`
- **Navigace klávesnicí:** N/A — žádný fokusovatelný/interaktivní element není dokumentován jako
  nativní součást StoryHero.
- **Správa fokusu:** N/A ze stejného důvodu.
- **Čtečka obrazovky:** složený `CategoryChip` nese své vlastní chování přístupného názvu
  prostřednictvím propu `label` (dekorativní ikona + textový popisek, podle
  `COMP0018`/`DESIGN-component-index.md` řádek 5); žádné další chování pro čtečky obrazovky na
  úrovni StoryHero není dokumentováno.

### Chování podle tenantu (target — CZ/RO přes `data-theme`)

Komponenta neutrální vůči tématu: žádné CZ/RO-specifické propy. Vizuální přeskinování probíhá
výhradně přemapováním tokenů pod `data-theme="cz"|"ro"` — monogram fallback je konkrétně postaven
tak, aby četl brand tokeny a přeskinoval se automaticky podle tenantu (podle
`DESIGN-component-index.md` řádek 9 "Tenant notes"):

- `var(--radius-card)` — CZ `16px` / RO `26px` (ostřejší vs. squircle), podle `DESIGN-tokens.md` §6.
- `var(--shadow-card)` — elevace tónovaná podle tenantu (CZ ink-red-tinted / RO ink-navy-tinted),
  podle `DESIGN-tokens.md` §7.
- `var(--color-brand)` — CZ `#EC4B34` / RO `#0FB5AE`, použito v monogram-fallback wash, podle
  `DESIGN-tokens.md` §3.1.
- `var(--color-surface)`, `var(--color-surface-tint)` — plochy fallback wash, vázané na tenant podle
  `DESIGN-tokens.md` §3.1.
- `var(--font-display)` + `var(--font-display-weight)` + `var(--font-display-tracking)` — typografie
  glyfu monogramu, vázaná na tenant podle `DESIGN-tokens.md` §4.1 (CZ Bricolage Grotesque 800 / RO
  Baloo 2 700).
- Složený `CategoryChip` navíc čte `var(--color-category-development|health|subsistence)`, které jsou
  přemapovatelné podle tenantu dle `DESIGN-tokens.md` §3.3, a jeho sada glyfů `Icon` přepíná mezi
  line (CZ) a filled (RO) přes `data-theme`, podle `DESIGN-component-index.md` řádek 3.

### Omezení použití (target)

- Použít když: vykreslujete primární vizuál příběhu v kompozici stránky StoryDetail, bezprostředně
  pod H1/breadcrumb v hlavním sloupci (podle `DESIGN-component-index.md` řádek "StoryDetail (Page)",
  pořadí kompozice: `SiteHeader → breadcrumb → H1 → StoryHero → lede → PatronCard → prose`).
- Nepoužívat když: vykreslujete souhrn příběhu uvnitř procházitelného seznamu/mřížky — na to slouží
  `StoryCard` (target kontrakt `COMP0008`), jiný Block.
- Kardinalita: jeden na stránku StoryDetail.
- Umístění: hlavní sloupec, horní část těla stránky; nikoli samostatný/overlay element.

### Závislosti (target)

- Ostatní COMP (kompozice): `COMP0018` CategoryChip (rohový chip).
- Datové entity: `EN0004` Campaign (kategorie, popisek kategorie, obrazový materiál — current-state
  vazba atributu; viz část Current-state pro vlastní poznámku rekonstrukce k vazbě).
- ACL: žádné nedokumentováno.
- Externí knihovny: žádné nedokumentováno.

### Kompozice (target)

```
StoryHero
  └─ COMP0018 CategoryChip (corner; category + categoryLabel)
```

### Sloty tokenů (target — kanonické CSS proměnné, viz `DESIGN-tokens.md`)

| Token | Role zde |
|---|---|
| `var(--radius-card)` | Poloměr rohu kontejneru hero |
| `var(--shadow-card)` | Elevace kontejneru hero |
| `var(--color-brand)` | Akcent wash monogram-fallback |
| `var(--color-surface)` | Fallback pozadí plochy |
| `var(--color-surface-tint)` | Fallback tónovaná wash plocha |
| `var(--font-display)`, `var(--font-display-weight)`, `var(--font-display-tracking)` | Typografie glyfu monogramu |
| *(přes složený CategoryChip)* `var(--color-category-development\|health\|subsistence)` | Tón kategorie rohového chipu |

### Příklady (target)

```
<StoryHero photoUrl="/img/sofinka.jpg" photoAlt="" initial="S" category="development" categoryLabel="Rozvoj a vzdělání" />
<StoryHero initial="M" category="health" categoryLabel="Zdraví" />  {/* no photoUrl → monogram fallback */}
```

---

## Current-state (observováno — rekonstruovaný current-state UX Patronusu)

> **STATE: CURRENT.** Vše v této části popisuje, co bylo skutečně observováno na živém webu
> Patronus, ze statické screenshotové evidence obrazovky detailu příběhu
> (`WIRE0002_StoryDetailAndDonationModal.md`, obrazovka `S002`). **Nepopisuje** rebuild target výše.
> Podle `rules-COMP.md` se COMP vytváří pouze "když je znovupoužití pozorovatelné napříč dvěma nebo
> více WIRE obrazovkami/screenshoty" — tato podmínka **není splněna** pro hero fotografii v
> current-state evidenci (viz tabulka Evidence). Tato current-state část je proto záměrně evidenčně
> tenká; je zde zdokumentována **protože zadání instruuje povýšit kanonickou komponentu nyní**, ale
> podkladové current-state tvrzení o znovupoužití zůstává `Uncertain`, v souladu s tím, jak to samotný
> `WIRE0002` ponechal jako `inline`.

### Kde se to objevuje na živém webu dnes

- **`WIRE0002` — stránka detailu příběhu (`S002`), zóna "Media zone".** Záznam Layout Zones:
  *"Media zone — hero fotografie příběhu (dítě)."* (`WIRE0002` řádek 56). Umístěna přímo pod "Title
  band" (název příběhu) a nad "Patron comment card", v levém/hlavním sloupci, vedle sidebaru daru
  (`WIRE0002` ASCII layout, řádky 85–106).
- **Tabulka Components Used** (`WIRE0002` řádek 133): `Media zone | inline | hero image | single
  photo, no gallery/carousel observed`. Current-state rekonstrukce toto explicitně zaznamenala jako
  `inline` — tedy během původní UX rekonstrukce to **nebylo** povýšeno na znovupoužitelný COMP, což
  je přesně mezera, kterou tento dokument nyní uzavírá na *target* straně (viz
  `DESIGN-component-index.md` §2 mapovací řádek: "StoryHero — GAP→recon — Kanonický hero = photo +
  rohový CategoryChip + monogram fallback. Rekonstrukce viděla holý 'hero image'.").
- **Screenshotová evidence:** celostránkový snímek obrazovky detailu příběhu,
  `_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_25_48.png`
  (podle `WIRE0002` tabulky Evidence, řádek 292), ukazující fotografii dítěte v media zóně vedle
  titulku, Patron karty, těla textu, sidebaru a trust banneru.

### Observované current-state propy/chování

- **Pouze jediná statická fotografie.** `WIRE0002` explicitně uvádí "single photo, no
  gallery/carousel observed" — žádný důkaz o vícesnímkovém carouselu, náhledech nebo lightboxu na
  živé obrazovce.
- **Na hero samotném nebyl observován rohový kategorijní chip.** V current-state snímku je tag
  kategorie ("Rozvoj a vzdělání" + ikona) vykreslen **uvnitř sidebaru daru**, nikoli jako overlay na
  hero fotografii (`WIRE0002` Layout Zones: "Donation sidebar... category tag ('Rozvoj a vzdělání')
  with icon", řádek 64) — strukturální rozdíl oproti target kontraktu StoryHero, kde je
  `CategoryChip` složen přímo do rohu hero. Jde o skutečnou divergenci current-vs-target v tom,
  *kde* indikátor kategorie žije, nikoli pouze o rozdíl v pojmenování — viz poznámka Divergence
  níže.
- **Vykreslení bez fotografie / fallback: `Uncertain`.** Žádná screenshotová evidence nezobrazuje
  stránku detailu příběhu bez hero fotografie; zda současný Patronus vykresluje jakýkoli fallback
  (monogram, placeholder obrázek nebo prázdné místo), pokud Campaign postrádá obrazový materiál,
  **není evidováno** v current sources. Nepředpokládejte, že monogram-fallback chování dokumentované
  na target straně existuje v current-state Patronusu.
- **Alt text: `Uncertain`.** Pro current-state hero obrázek není k dispozici žádná DOM/přístupnostní
  evidence; zda nese smysluplný `alt` text, není známo.

### Current-state varianty / stavy / eventy / přístupnost

Podle evidenční disciplíny `rules-COMP.md` jsou neobservované osy zaznamenány jako `Uncertain`,
nikoli vymyšlené:

- **Varianty:** `Uncertain — evidováno je pouze jedno vykreslení (jediná statická fotografie,
  kontext category=development); neexistuje druhý snímek detailu příběhu s jinou kategorií nebo
  případ bez fotografie, který by potvrdil kategorií řízenou vizuální variantu v current-state
  Patronusu.`
- **Stavy (hover/focused/disabled/loading):** `Uncertain — nelze pozorovat ze statické evidence.`
- **Error (fallback bez fotografie):** `Uncertain — viz výše; žádný důkaz o tom, co současný Patronus vykresluje, pokud obrazový materiál Campaign chybí.`
- **Eventy:** Nebyly observovány žádné eventy — current-state "Media zone" je zaznamenána jako statický obrázek, nikoli interaktivní element (`WIRE0002` řádek 133: "single photo, no gallery/carousel observed").
- **Přístupnost:** `Uncertain — žádná DOM/nahrávková evidence, v souladu s celkovým a11y postavením WIRE0002.`

### Divergence current-vs-target (zaznamenat, nikoli "opravovat")

Podle `_ar/evidence/design-system/components.md` §4 a `DESIGN-component-index.md` §3 jde o
zaznamenanou mezeru ke sladění, nikoli o defekt:

1. **Umístění indikátoru kategorie.** Current-state umísťuje tag kategorie do sidebaru daru
   (`WIRE0002` řádek 64); target StoryHero komponuje `CategoryChip` přímo do rohu hero. Zda
   current-state Patronus *také* má indikátor kategorie na samotném hero (nedetekováno, protože to
   nebylo v záznamu odlišeno od sidebar tagu), je `Uncertain` — nepředpokládejte, že sidebar tag je
   observovaný current-state StoryHero-rohový chip.
2. **Fallback chování nepotvrzeno.** Monogram-on-wash fallback target StoryHero je fakt platný
   pouze pro target; chování current-state Patronusu bez fotografie není evidováno (viz výše).
3. **Prahová hodnota znovupoužití v current-state evidenci nesplněna.** Existuje pouze jeden
   snímek obrazovky detailu příběhu (`S002`); `rules-COMP.md` požaduje znovupoužití napříč ≥2 WIRE
   obrazovkami/screenshoty před povýšením current-state COMP. Current-state "Media zone" tedy na
   základě svých vlastních evidenčních zásluh zůstává jednoinstančním inline elementem — current-state
   část tohoto dokumentu tento fakt zaznamenává, aniž by jej přepisovala bohatším tvarem target
   kontraktu.

### Závislosti (current-state)

- Ostatní COMP: žádné potvrzené jako složené — current-state "Media zone" byla zaznamenána jako
  `inline` bez struktury podkomponent (`WIRE0002` Components Used, řádek 133).
- Datové entity: `EN0004` Campaign — atribut obrazového materiálu, podle `WIRE0002` Data Bindings:
  `"Media zone | EN0004 | — | Campaign imagery (required-imagery attribute, per
  BR-CampaignStoryLifecycle)"` (`WIRE0002` řádek 237).
- ACL: žádné evidováno.
- Externí knihovny: žádné evidováno.

### Kompozice (current-state)

```
Media zone (WIRE0002, S002) — current-state, inline
  └─ hero photo (single static image; no sub-components confirmed)
```

### Evidence

| Oblast tvrzení | Jistota | Evidence |
|---|---|---|
| Existence zóny hero fotografie na detailu příběhu | Confirmed | `WIRE0002` Layout Zones "Media zone" (řádek 56); `_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_25_48.png` |
| Jediná statická fotografie, žádný carousel | Confirmed | `WIRE0002` Components Used, řádek "Media zone" (řádek 133) |
| Znovupoužití napříč ≥2 current-state obrazovkami (prahová hodnota pro povýšení na COMP) | Uncertain / nesplněno | zachycena pouze jedna obrazovka detailu příběhu (`S002`); pravidlo ≥2 obrazovek `rules-COMP.md` |
| Kategorijní chip složený do rohu hero (current-state) | Uncertain | tag kategorie observován pouze v sidebaru daru (`WIRE0002` řádek 64), na samotném hero nepotvrzen |
| Vykreslení bez fotografie / fallback (current-state) | Uncertain | žádný snímek stránky detailu příběhu bez fotografie |
| Alt text / přístupnost (current-state) | Uncertain | žádná DOM evidence, podle celkového a11y postavení `WIRE0002` |
| Kanonický target kontrakt (propy/varianty/stavy/tokeny/a11y) | Confirmed (jako target fakt) | `_ar/evidence/design-system/components.md` §1 "StoryHero"; `DESIGN-component-index.md` řádek 9; zdroj `packages/ui/src/components/StoryHero/{StoryHero.tsx, StoryHero.contract.md, StoryHero.module.css}` |

---

## Otevřené otázky

- Zda current-state Patronus vykresluje jakýkoli indikátor kategorie na samotné hero fotografii
  (odlišný od sidebar tagu kategorie) — nelze vyřešit ze stávajících snímků; k uzavření by byl
  potřeba nový current-state screenshotový průchod, nikoli target kontrakt.
- Zda current-state Patronus má jakýkoli fallback bez fotografie pro Campaigns postrádající obrazový
  materiál, a pokud ano, jak vypadá — `Uncertain`, žádná evidence v obou směrech.
- Zda current-state "Media zone" někdy podporuje více fotografií (galerie) na obrazovkách, které
  ještě nebyly zachyceny — `WIRE0002` potvrzuje pouze "no gallery/carousel observed" na jedné
  zachycené instanci, což je důkaz absence na *té* obrazovce, nikoli důkaz absence napříč všemi
  current-state vykresleními detailu příběhu.
