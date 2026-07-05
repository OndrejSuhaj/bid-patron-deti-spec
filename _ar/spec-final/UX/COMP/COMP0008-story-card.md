---
doc_id: COMP0008
title: StoryCard
canonical_layer: COMP
spec_type: component
modules: []
status: canonical
references:
  - WIRE0001
  - WIRE0019
  - WIRE0020
  - EN0004
  - EN0021
  - UC0023
  - DESIGN-component-index
  - DESIGN-tokens
  - COMP0016
  - COMP0017
  - COMP0018
---

# COMP0008 – StoryCard

*(rekonstruováno jako Story Card; kanonická komponenta @patron/ui: StoryCard)*

---

## Current-state (observed)

> Níže uvedená sekce (až po "Evidence") dokumentuje **současný stav UI Patronusu tak, jak byl
> pozorován na screenshotech živého webu**. Jde o nezměněný rekonstrukční obsah — pouze název
> nadpisu dokumentu výše byl přejmenován tak, aby odpovídal kanonickému názvu komponenty. Nic v
> této sekci nečtěte jako popis cílového design systému pro rebuild; kontrakt `@patron/ui`
> `StoryCard` viz "Design-system alignment (target)" níže.

## Purpose

Karta shrnující jeden Campaign/Story (`EN0004`): fotka dítěte, ribbon s odpočtem do deadline,
titulek, údaje o cílové vs. vybrané částce a primární CTA. Jde o hlavní opakující se jednotku
katalogu, přímo pozorovanou s konzistentním základním tvarem jak v mřížce katalogu na homepage
(`WIRE0001`, ×6 na záložku), tak v mřížce splněných příběhů na obrazovce "Výsledky" (`WIRE0019`,
×6), s další složenou variantou odkazovanou pouze analogicky v mockupu dashboardu účtu ve stavu
Evidence-Pending/Hypothesis (`WIRE0020`). Znovupoužití napříč dvěma obrazovkami s nezávislým
screenshotovým důkazem je Confirmed pro základní kartu; varianty pro dokončený stav a dashboard
jsou zaznamenány jako odlišné, méně jisté sesterské varianty, nikoli tiše slučovány do jednoho
tvrzení "stejná komponenta".

## Props / Inputs

| Name | Type | Required | Default | Description |
|---|---|---|---|---|
| `photo` | `image` | yes | — | Fotka dítěte/příběhu. |
| `title` | `string` | yes | — | Titulek příběhu, např. "Balík školních potřeb pro Miriam"; COPY-owned per instance. |
| `targetAmount` | `number (Kč)` | yes | — | "Cílová částka" — cílová částka sbírky; váže se na `EN0004`. |
| `collectedAmount` | `number (Kč)` | conditional | — | "Vybráno" / "Chybí {amount} Kč" — dosud vybraná částka; váže se na `EN0004` (odvozené pole, viz WIRE0001/WIRE0002 Data Bindings). |
| `deadlineBadge` | `string` | no | — | Text ribbonu s odpočtem; pozorované hodnoty se liší: "ZBÝVÁ MĚSÍC" / "ZBÝVÁ DEN" / "ZBÝVÁ 4 DNY" / "ZBÝVÁ 16 DNÍ" / "ZBÝVÁ 24 DNÍ". |
| `isCollectionAccount` | `boolean` | no | `false` | Vykresluje variantu skupinového/rodičovského Campaign "SBÍRKOVÝ ÚČET" pozorovanou jednou na `WIRE0001` ("Necháte výběr dítěte, kterému chcete pomoct na nás?"), navazující na skupinový/rodičovský mechanismus `EN0004` (Partial dle `UC0023` Traceability). |
| `ctaLabel` | `string` | yes | — | Text primárního CTA, např. "Podpořím Miriam", "Nechám to na vás", "Detail příběhu". |
| `completedBadges` | `string[]` | no | `[]` | Odznaky pro dokončený stav pozorované pouze u varianty na `WIRE0019`: status ribbon "SPLNĚNO" + pill "ZPĚTNÁ VAZBA" + chip s ikonou ruky. Na základní kartě `WIRE0001` nejsou přítomny. |

## Variants

- **lifecycle:** active (základní karta katalogu, `WIRE0001` — ribbon s odpočtem + progress +
  CTA "Podpořím") | completed (`WIRE0019` — přidává ribbon "SPLNĚNO", pill "ZPĚTNÁ VAZBA", ikonu
  fajfky u vybrané celkové částky, CTA "Detail příběhu" místo CTA pro darování). Varianta completed
  je odlišná vizuální rodina potvrzená přímým porovnáním screenshotů, není předpokládána jako
  identická s variantou active — viz poznámka `WIRE0019` Components Used: "same card pattern
  family... but with the completed-state variant... not confirmed to be the identical component."
- **story-type:** jednotlivé dítě (výchozí) | sbírkový účet/skupina (`isCollectionAccount=true`,
  skupinový/rodičovský mechanismus `EN0004`, Partial evidence)

## States

### idle
Statické vykreslení karty tak, jak je popsáno v Props. Confirmed — varianta active:
`_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png` (mřížka katalogu);
varianta completed: `_ar/prtsc/screencapture-patrondeti-cz-vysledky-2026-07-04-13_16_50.png`.

### hover
`Uncertain — nelze pozorovat ze statických důkazů.`

### focused
`Uncertain — nelze pozorovat ze statických důkazů.`

### disabled
N/A — nebylo pozorováno žádné vykreslení disabled. (Nezaměňovat se stavem disabled u nulového
počtu aktivních Campaign regionů na komponentě mapy regionů jinde na `WIRE0001`, což je jiný
prvek.)

### loading
`Uncertain — pro mřížku katalogu nebyl zachycen žádný skeleton/loading-placeholder stav; Evidence
Pending dle WIRE0001 States.`

### error
N/A — nebyl pozorován žádný chybový stav na úrovni jednotlivé karty; stavy empty/error na úrovni
mřížky jsou zaznamenány na úrovni WIRE (`WIRE0001` States: "empty/loading/error: Evidence Pending"),
tato komponenta je nevlastní.

## Events

| Event | Payload | Trigger | Notes |
|---|---|---|---|
| `onCtaClick` | identifikátor příběhu | kliknutí na primární CTA tlačítko | Varianta active → vstup do darování (`UC0005`/`UC0011`, dle `WIRE0002`); varianta completed → čtecí zobrazení detailu příběhu (`UC0011`, dle `WIRE0019`). |
| `onCardClick` | identifikátor příběhu | `Uncertain` — zda je samotné tělo karty (fotka/titulek) nezávisle klikatelné, odděleně od CTA, nelze ze statických důkazů potvrdit. | |

## Accessibility

- **ARIA role:** `Uncertain` — Předpokládá se nativní sémantika `<article>`/`<li>` uvnitř
  mřížky/seznamu; nepotvrzeno.
- **Keyboard navigation:** `Uncertain`.
- **Focus management:** `Uncertain`.
- **Screen reader:** `Uncertain` — zda jsou hodnoty progresu ohlašovány s jednotkami/kontextem
  nelze ze screenshotů potvrdit.

## Usage Constraints

- Use when: vykreslení souhrnu Campaign/Story uvnitř procházecí mřížky (katalog, seznam splněných
  příběhů).
- Do not use when: vykreslení celé detailní stránky příběhu (→ vlastní dedikovaný layout
  `WIRE0002`, nikoli tato karta).
- Cardinality: opakuje se N-krát v mřížce (pozorováno: 6 na záložku na `WIRE0001`, 6 na `WIRE0019`).
- Placement: pouze uvnitř zóny mřížky/seznamu; nepoužívá se samostatně.

## Dependencies

- Other COMPs: žádné potvrzeny jako složené dílčí prvky (číselné údaje o progresu a CTA tlačítko
  jsou v důkazech vykreslovány inline uvnitř vlastního layoutu karty, nepotvrzeny jako nezávisle
  znovupoužitelná tlačítka identická s `COMP0001` — CTA v katalogu je menší/vázané na kartu a
  netvrdí se o něm, že je stejnou komponentou).
- Data entities: `EN0004` Campaign (cílová/vybraná částka, deadline, skupinový/rodičovský
  mechanismus); `EN0021` Feedback (vazba odznaku "ZPĚTNÁ VAZBA" u varianty completed je Uncertain
  dle `WIRE0019`, nepotvrzena jako přímé propojení s `EN0021`).
- ACL: nezdokumentováno.
- External libraries: nezdokumentováno.

## Composition

```
StoryCard (active variant)
  ├─ photo
  ├─ deadline countdown ribbon
  ├─ title
  ├─ progress block (target/collected figures — Uncertain whether this is COMP0008-internal only,
  │    or shares a component with the story-detail page's own progress block on WIRE0002; not
  │    confirmed identical, left as an open question rather than a second COMP)
  └─ CTA (card-scoped; not confirmed identical to COMP0001)

StoryCard (completed variant, WIRE0019)
  ├─ photo
  ├─ "SPLNĚNO" status ribbon + "ZPĚTNÁ VAZBA" pill + hand-icon chip
  ├─ title
  ├─ "Vybráno celkem" + amount + checkmark icon
  └─ "Detail příběhu" CTA
```

## Open Questions

- Zda jsou varianty active a completed skutečně tatáž podkladová komponenta (parametrizovaná
  stavem lifecycle), nebo dvě samostatně vytvořené šablony karty — `WIRE0019` sám tento fakt
  označuje jako "not confirmed to be the identical component"; zde je otázka přenesena dál, nikoli
  vyřešena.
- Zda progress blok na detailní stránce příběhu (`WIRE0002`) sdílí komponentu s číselnými údaji
  progresu na této kartě, nebo je implementován nezávisle.
- `WIRE0020` (mockup dashboardu účtu, Hypothesis/nepotvrzeno jako implementováno) ukazuje další
  sesterskou kartu typu "contribution banner overlay" ("Přispěli jste {amount}") — tato explicitně
  NENÍ zahrnuta do této COMP vzhledem k nepotvrzenému stavu implementace dané obrazovky; ponechána
  inline ve `WIRE0020` dle pravidla ≥2 obrazovek, které se vztahuje pouze na potvrzeně
  implementované obrazovky.

## Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Znovupoužití napříč ≥2 potvrzeně implementovanými obrazovkami | Confirmed | `WIRE0001` (×6 na záložku) a `WIRE0019` (×6); `WIRE-synthesis-report.md` §6 "Progress/funding-amount bar" a poznámka o vzoru karty ve `WIRE0019` |
| Vizuální stav varianty active | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png` |
| Vizuální stav varianty completed | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-vysledky-2026-07-04-13_16_50.png` |
| Identita active vs. completed jako "stejné" komponenty | Uncertain | zaznamenáno doslovně v `_ar/spec-draft/WIRE/WIRE0019_HowItWorksResults.md` Components Used |
| Sesterská karta z mockupu dashboardu (WIRE0020) | Uncertain/Hypothesis | samotná obrazovka nepotvrzena jako implementovaná; vyloučena z potvrzeného rozsahu této COMP |
| Accessibility | Uncertain | nejsou dostupné žádné DOM/nahrávkové důkazy |

---

## Design-system alignment (target)

> **STATE: TARGET — `@patron/ui` `StoryCard` (Block).** Tato sekce popisuje kanonický kontrakt
> komponenty **cílového design systému rebuildu**, dle `DESIGN-component-index.md` řádku 8 a
> `_ar/evidence/design-system/components.md` §1 "StoryCard". Nachází se na stejné úrovni autority
> jako `it-zadani` (budoucí/cílový stav), **nikoli** current-state truth, a nesmí být zpětně
> promítána do sekce "Current-state (observed)" výše. Dle reconciliation mapy
> (`components.md` §2) je vztah k této COMP **MATCH (name), contract differs** — viz odchylky
> níže.

### Canonical identity

- **Name:** `StoryCard` (komponenta na úrovni Block, `packages/ui/src/components/StoryCard/`).
- **Exported prop type:** `StoryCardProps`.
- **Storybook stories:** `Zdraví`, `Rozvoj`, `TéměřVybráno`, `BezFotky`.
- **Purpose:** hlavní opakující se jednotka storefrontu — příběh jednoho dítěte + progres sbírky
  uvnitř kontextů seznamu (mřížka katalogu, cross-sell rail "Další děti" na stránce StoryDetail).
  Klikatelná jednotka pro akvizici dárců → detail příběhu.

### Composition (canonical)

Jde o **Block**, který skládá tři kanonické **Atoms**, místo aby svůj countdown ribbon, indikátor
kategorie a progress bar vykresloval jako interní markup:

```
StoryCard (canonical, target)
  ├─ CategoryChip   (COMP0018) — indikátor kategorie příběhu (development | health | subsistence)
  ├─ ProgressBar    (COMP0016) — progress bar sbírky (brand→accent gradient reveal)
  └─ TimeLeftPill   (COMP0017) — countdown/urgency pill (calm | urgent)
```

Tato kompozice **přepojuje** current-state diagram Composition výše: to, co tato COMP zaznamenala
jako interní "deadline countdown ribbon" a interní "progress block", je v kanonickém modelu
skládáno ze sub-komponent `TimeLeftPill` (`COMP0017`) a `ProgressBar` (`COMP0016`) — tím se řeší
vlastní Open Question tohoto dokumentu ("zda progress blok na detailu sdílí komponentu s progresem
na kartě" → v cílovém systému ano: obě spotřebovávají stejný atom `ProgressBar`). Mechanismus barvy
kategorie (`CategoryChip`, `COMP0018`) nemá v této COMP **žádnou obdobu v current-state** — jde o
doplnění pouze v cílovém stavu, nepozorované na žádném current-state screenshotu.

### Props / Inputs (canonical)

Všechny props jsou **display-ready** (předformátované/předpřeložené stringy a čísla; žádné
formátování ani i18n uvnitř komponenty):

| Name | Type | Notes |
|---|---|---|
| `title` | `string` | Titulek příběhu. |
| `photoUrl` | `string` (optional) | URL fotky dítěte/příběhu. |
| `initial` | `string` | Iniciála pro monogram-fallback, použitá když `photoUrl` chybí. |
| `category` | `StoryCategory` (`development \| health \| subsistence`) | Určuje barvu `CategoryChip` + podbarvení karty přes `color.category.*`. |
| `categoryLabel` | `string` | Zobrazovaný label pro chip kategorie. |
| `progressPct` | `number` | Napájí složený `ProgressBar`. |
| `missingLabel` | `string` | Display-ready text "chybějící částka". |
| `goalLabel` | `string` | Display-ready text cílové částky. |

### Variants / states (canonical)

- **Variants:** pouze dle `category` (chip/podbarvení/monogram sdílejí `color.category.*`).
  Neexistuje **žádná kanonická osa lifecycle** — current-state rozdělení active/completed
  zaznamenané výše v Variants je pouze current-state pozorování bez ekvivalentu v cílovém systému
  (viz Divergence níže). Žádná osa velikosti není vyčleněna (fixní velikost karty dle
  `components.md`).
- **States:** `default` (first-cut, shipped); `hover`/`focus` na vlastnícím linku (explicitně
  **mimo first cut**, odloženo); `loading`/`empty`/`error` (explicitně **mimo rozsah first-cut**).

### Token slots (canonical)

`var(--color-surface)`, `var(--color-border)`, `var(--radius-card)`, `var(--shadow-card)`,
`var(--font-body)`, `var(--color-category-development)`, `var(--color-category-health)`,
`var(--color-category-subsistence)`, `var(--color-surface-tint)`, `var(--font-display)` (+
`var(--font-display-weight)`, `var(--font-display-tracking)`), `var(--color-text)`,
`var(--color-muted)`, `var(--space-md)`, `var(--space-sm)`. Dle `DESIGN-tokens.md` §10 jsou všechny
spotřebovávány přes `var(--…)` ve vlastním CSS modulu komponenty — žádné hex/px literály. Složené
sub-komponenty nesou vlastní další slots (`ProgressBar`: `--radius-pill`, `--color-track`,
`--color-brand`, `--color-accent`; `TimeLeftPill`: `--color-urgent`, `--color-on-urgent`;
`CategoryChip`: `--radius-pill`).

### Accessibility (canonical)

- Celá karta je **klikatelná jednotka pro akvizici dárců** směrující na stránku detailu příběhu —
  vzor vlastnícího linku, nikoli vzor spouštěný tlačítkem (v kontrastu s Uncertain rozdělením
  `onCtaClick`/`onCardClick` v current-state této COMP výše).
- Stavy hover/focus na vlastnícím linku jsou explicitně odloženy (mimo first-cut) — kontrakt
  focus-ringu pro samotnou kartu zatím nebyl definován.
- Složený `ProgressBar` nese vlastní `role="progressbar"` + `aria-valuemin/max/now`, explicitně
  **nefokusovatelný** (status role, nikoli control) — komponenta `StoryCard` jej dědí, nikoli
  znovu deklaruje.
- Pulsující animace `urgent` u složeného `TimeLeftPill` je vypnuta při `prefers-reduced-motion` —
  dědí ji jakýkoli `StoryCard` vykreslující urgentní pill.
- Pro samotný kontejner karty není definována žádná ARIA role nad rámec nativní sémantiky; v
  `components.md` není vyčleněna samostatně.

### Tenant (CZ/RO) behaviour

- `StoryCard` sám o sobě nepřijímá **žádné tenant-specifické props** — obsah (titulek, labely) je
  předáván již lokalizovaný konzumujícím kódem, což odpovídá current-state pozorování této COMP,
  že text titulku/CTA je COPY-owned per instance.
- Přeskinování napříč `data-theme="cz"|"ro"` je zcela řízeno tokeny (barvy, radius, stín, fonty se
  remapují pod `[data-theme]`) — žádné forky kódu komponenty.
- Styl ikonového glyfu složeného `CategoryChip` (linkový vs. vyplněný) se řídí konvencí tenantova
  atomu `Icon` (CZ = linkový, RO = vyplněný) přes `data-theme`, nikoli prop na úrovni `StoryCard`.
- Barevné odlišení urgentnosti u složeného `TimeLeftPill` používá tenant-neutrální status tokeny
  `color.urgent`/`color.onUrgent` (stejná hodnota na obou tenantech), odlišné od brand palety.

### Divergence from observed current-state (record, do not "correct")

- **Žádná varianta lifecycle/"completed".** Sekce Variants current-state této COMP zaznamenává
  odlišný lifecycle `completed` (`WIRE0019`: ribbon "SPLNĚNO", pill "ZPĚTNÁ VAZBA", fajfka, CTA
  "Detail příběhu" místo CTA pro darování). Kanonický kontrakt `StoryCard` **žádnou** osu lifecycle
  nemá — dle poznámky k mapování `components.md` §2, "rozdělení active/completed u COMP0008 je
  current-state pozorování, nikoli kanonická osa." Tato divergence je zaznamenána, nikoli tiše
  uzavřena; zda/jak bude rebuild reprezentovat pohled na katalog splněných příběhů, zůstává
  otevřenou otázkou rozsahu rebuildu, nerozhodnutou touto reconciliation.
- **Žádná prop `isCollectionAccount` / group-Campaign.** Current-state prop `isCollectionAccount`
  (skupinový/rodičovský mechanismus `EN0004`, Partial evidence) nemá žádný protějšek v kanonickém
  seznamu props výše — `components.md` nedokládá, že by byla přenesena do cílového kontraktu.
- **Žádné `ctaLabel`/explicitní CTA tlačítko.** Current-state zaznamenává CTA tlačítko vázané na
  kartu (`ctaLabel`, `onCtaClick`), nepotvrzené jako identické s `COMP0001`/kanonickým `Button`.
  Kanonický kontrakt naopak modeluje celou kartu jako link (viz Accessibility výše) bez
  samostatné prop pro CTA-label — current-state text CTA specifický pro danou kartu ("Podpořím
  Miriam", "Nechám to na vás") nemá žádné přímé mapování na kanonickou prop.
- **`completedBadges`, `deadlineBadge` jako volný text.** Current-state je zaznamenává jako ad hoc
  string props; kanonický model nahrazuje koncept deadline strukturovaným `TimeLeftPill`
  (`label` + boolean `urgent`) namísto volně textového odznaku.

### Source references

`DESIGN-component-index.md` řádek 8 (Index table) a §2 (přiřazení doc_id); plný katalogový záznam
`_ar/evidence/design-system/components.md` §1 "StoryCard" a mapovací řádek §2 "StoryCard"; složené
atomy dle `_ar/evidence/design-system/components.md` §1 "ProgressBar", "TimeLeftPill",
"CategoryChip" a `DESIGN-tokens.md` §3, §6, §10 pro hodnoty/názvy tokenů.
