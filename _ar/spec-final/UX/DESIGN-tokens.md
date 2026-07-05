# DESIGN — Token Reference (TARGET design system)

> **Status: TARGET, NOT current-state.** Tento dokument je kanonickou destilací systému
> designových tokenů (`@patron/tokens`, balíček `packages/tokens/`) pro **REBUILD `bid-patron-deti`**.
> Popisuje **budoucí/cílový** design jazyk, nikoliv současný stav UI Patronus/Drupal. Podle projektové
> konstituce se jedná o materiál třídy `it-zadani` (cílový stav) — nesmí být citován jako důkaz
> současného chování ani prezentace Patronus a nesmí být zaměňován s rekonstruovaným current-state UX.
> Existuje proto, aby vrstva UX (`IA/WIRE/COMP/COPY`) mohla citovat jednu autoritativní, stabilní
> sadu názvů a hodnot tokenů při popisu cílových obrazovek nebo při zaznamenávání odchylek
> current-state UI od cílového systému.
>
> **Úplná extrakce / pracovní poznámky:** `_ar/evidence/design-system/tokens.md` (nezačleněno do
> repozitáře) — tento dokument je stručnou, citovatelnou destilací daného katalogu. Kde se tento
> dokument a evidenční katalog rozchází, je evidenční katalog podrobnější a měl by být znovu
> ověřen.
>
> **Zdroj pravdy (rebuild repozitář):** `/Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/`,
> balíček `@patron/tokens` — viz §7 Index zdrojů níže pro přesné soubory.

---

## 1. Architektura — trojité rozdělení

```
docs/design/tokens.md   → INTENT: which slots exist, their meaning, axes, naming   (the "contract")
packages/tokens/src     → VALUES: hex, px, font families                            (the numbers)
        ↓ build (tsx build.ts)
   dist/tokens.css (web: CSS custom properties)  +  JS theme object (native: direct import)
        ↓
   Storybook "Foundations" = LIVE visualization of the values, read from code
```

- **Dvě konceptuální vrstvy:** **primitiva** (základní brandové barvy, neutrální škála — nikdy
  odkazovány komponentami přímo) a **sémantické sloty** (role, na které se komponenty odkazují:
  `color.brand`, `color.surface`, …). Komponenta nikdy nezapisuje hex hodnotu — pouze slot.
  Přeznačkování tenanta znamená remapování slotů, nikoliv úpravu komponent.
- **Pojmenování je ve tvaru DTCG** (`color.brand`, `radius.card`, `space.md`) jako pojistka pro
  interoperabilitu, ale samotný DTCG *toolchain* (Style Dictionary / Terrazzo) záměrně není
  přijat.
- Web potřebuje build krok (TS → `dist/tokens.css`); native nepotřebuje žádný (importuje objekt
  theme přímo). Platformově specifické záležitosti (font stacky, míchání alfa kanálu) řeší tenký
  per-platform adaptér, nikoliv dvě definice tokenů.

## 2. Povrch tokenů — vázaný na tenanta vs. sdílený

Dvě TypeScript rozhraní v `packages/tokens/src/themes.ts` definují celý povrch:

| Rozměr | Vázaný na tenanta? | Vlastnící objekt | Emitováno pod |
|---|---|---|---|
| barva (základní role + status + kategorie příběhů) | **ano** | `ThemeTokens.color` | `[data-theme="…"]` |
| rodiny písem & display vlastnosti | **ano** | `ThemeTokens.font` | `[data-theme="…"]` |
| typová škála (`size.*`) | ne (sdílené) | `SharedTokens.size` | `:root` |
| radius | **ano** | `ThemeTokens.radius` | `[data-theme="…"]` |
| stín / elevace | **ano** | `ThemeTokens.shadow` | `[data-theme="…"]` |
| odsazení (`space.*`) | ne (sdílené) | `SharedTokens.space` | `:root` |
| layout / kontejner | ne (sdílené) | `SharedTokens.layout` | `:root` |

**Není tokenizováno** (ověřeně chybí): z-index, motion/duration/easing, breakpointy, šířka
okraje, opacity, letter-spacing po jednotlivých krocích, line-height. Tyto záležitosti se řeší
ad hoc v CSS komponent / Storybook viewport presetech, nikoliv přes tokeny — nevymýšlejte pro ně
názvy tokenů ve vrstvě UX.

## 3. Barevné tokeny — 19 slotů (vázané na tenanta)

Tenanti: **cz** = patrondeti.cz (teplý, ostřejší, naléhavý); **ro** = kidshero.ro (chladnější,
měkčí, důvěryhodný).

### 3.1 Základní role slotů (12)

| Slot | Role | CZ | RO |
|---|---|---|---|
| `color.brand` | primární brandová barva — akcent loga, aktivní stav, výplň progresu | `#EC4B34` | `#0FB5AE` |
| `color.brandStrong` | silný tmavý odstín brandu — zvýraznění, "100 % pro dítě" | `#B3311D` | `#0A7E79` |
| `color.action` | CTA / akční prvky (tlačítko "Přispět") | `#EC4B34` | `#16235A` |
| `color.accent` | sekundární zvýraznění (odznaky, highlighty); také focus ring | `#6D4AFF` | `#FF7A2F` |
| `color.bg` | plátno stránky (pozadí `body`) | `#FFF6F2` | `#EFF9F9` |
| `color.surface` | plochy nad plátnem (karty, panely) | `#FFFFFF` | `#FFFFFF` |
| `color.surfaceTint` | lehce tónovaná plocha (výplň chipu, základ meru) | `#FBECE6` | `#E1F3F2` |
| `color.text` | primární text | `#2A1A15` | `#132247` |
| `color.muted` | sekundární / ztlumený text | `#7C665E` | `#586A8C` |
| `color.border` | obrysy a dělící čáry | `#EEDDD5` | `#D6E7E6` |
| `color.onBrand` | text/ikony na brandových a akčních plochách | `#FFF6F2` | `#EFF9F9` |
| `color.track` | dráha progresu (nevyplněná část) | `#FBECE6` | `#E1F3F2` |

### 3.2 Statusová rodina (4) — vlastní tokeny, NEODVOZENÉ z brandu

| Slot | Role | CZ | RO |
|---|---|---|---|
| `color.urgent` | naléhavost (pill s časem, odznak "Naléhavé") | `#D92D20` | `#D92D20` |
| `color.onUrgent` | text/ikony na naléhavé ploše | `#FFFFFF` | `#FFFFFF` |
| `color.success` | úspěch/důvěra (chip "Vybráno", pečeť patrona) | `#149E6E` | `#0FB5AE` |
| `color.onSuccess` | text/ikony na ploše úspěchu | `#FFFFFF` | `#FFFFFF` |

`warning` a `info` jsou zdokumentovaným směrem, nikoliv ještě vyztuženy — nepředpokládejte jejich
existenci.

### 3.3 Barvy kategorií příběhu (3) — `color.category.*`

Stejná oblast příběhu = stejná barva všude (chip, wash/monogram karty, akcenty detailu). Per-tenant
remapovatelné.

| Slot | CZ | RO | Doménová oblast |
|---|---|---|---|
| `color.category.development` | `#149E6E` | `#0FB5AE` | rozvoj a vzdělání |
| `color.category.health` | `#6D4AFF` | `#2F7DBF` | zdraví |
| `color.category.subsistence` | `#C2740A` | `#FF7A2F` | existenční potřeby |

**Celkem: 19 barevných slotů** (12 základních + 4 statusové + 3 kategorie).

**Nejsou sloty:** washe/tinty se počítají pomocí CSS `color-mix()`, nikoliv jako samostatné tokeny.
Focus ring nemá vlastní slot — čte `color.accent`.

## 4. Tokeny typografie

### 4.1 Rodiny písem & display vlastnosti (vázané na tenanta, 4 sloty)

| Slot | CZ | RO |
|---|---|---|
| `font.display` | `'Bricolage Grotesque', system-ui, sans-serif` | `'Baloo 2', system-ui, sans-serif` |
| `font.body` | `'Hanken Grotesk', system-ui, sans-serif` | `'Hanken Grotesk', system-ui, sans-serif` |
| `font.displayWeight` | `800` | `700` |
| `font.displayTracking` | `-0.02em` | `0em` |

### 4.2 Typová škála (sdílená, 6 slotů) — px

| Slot | Hodnota |
|---|---|
| `size.sm` | 13 |
| `size.base` | 16 |
| `size.lg` | 20 |
| `size.xl` | 28 |
| `size.xxl` | 36 |
| `size.display` | 52 |

Line-height a letter-spacing po jednotlivých krocích **nejsou tokenizovány** (existuje pouze
jednotný `font.displayTracking`); jsou traktovány jako lokální detail komponenty.

## 5. Škála odsazení (sdílená, 5 slotů) — px

| Slot | Hodnota |
|---|---|
| `space.xs` | 4 |
| `space.sm` | 8 |
| `space.md` | 16 |
| `space.lg` | 24 |
| `space.xl` | 40 |

## 6. Tokeny radius (vázané na tenanta, 4 sloty)

CZ = ostřejší + kruhové ikonové dlaždice; RO = měkčí + squircle.

| Slot | Role | CZ | RO | CSS výstup |
|---|---|---|---|---|
| `radius.card` | karty & velké plochy | `16` | `26` | `${n}px` |
| `radius.control` | vstupy, presety, malé panely | `10` | `16` | `${n}px` |
| `radius.icon` | tvar ikonové dlaždice (kruh CZ / squircle RO) | `"50%"` | `"16px"` | raw string |
| `radius.pill` | plné zaoblení (pilulky, tlačítka, chipy) | `999` | `999` | `${n}px` |

`radius.icon` je v rozhraní řetězec (obsahuje `50%`); ostatní tři jsou čísla převedená na px
funkcí `css.ts`.

## 7. Stín / elevace (vázané na tenanta, 1 slot)

Barva stínu je tónovaná do inkoustové barvy tenanta, nikoliv obecně černá.

| Slot | CZ | RO |
|---|---|---|
| `shadow.card` | `0 1px 2px rgba(42, 26, 21, 0.06), 0 16px 34px -16px rgba(42, 26, 21, 0.22)` | `0 1px 2px rgba(19, 34, 71, 0.06), 0 16px 36px -16px rgba(19, 34, 71, 0.26)` |

## 8. Layout / kontejner (sdílený, 1 slot)

| Slot | Hodnota | Poznámka |
|---|---|---|
| `layout.container` | 1200 px | Jediný zdroj pravdy pro šířku kontejneru obsahu napříč stránkami a full-bleed pásy. |

## 9. Souhrn počtu tokenů

| Kategorie | Počet | Vázáno na tenanta |
|---|---|---|
| Barva | 19 (12 základních + 4 statusové + 3 kategorie) | ano |
| Písmo | 4 (2 rodiny + weight + tracking) | ano |
| Typová škála | 6 (sm 13 → display 52) | ne (sdílené) |
| Odsazení | 5 (xs 4 → xl 40) | ne (sdílené) |
| Radius | 4 (card/control/icon/pill) | ano |
| Stín | 1 (card) | ano |
| Layout/kontejner | 1 (1200) | ne (sdílené) |

## 10. Pojmenování CSS custom-property

**Jedno kanonické mapování**, v `packages/tokens/src/css.ts` (`toCssVars` pro tokeny tenanta,
`sharedCssVars` pro sdílené) — CSS generátor a komponenty používají identické názvy, žádný drift.

**Pravidlo pojmenování: `--` + rozměr s pomlčkami + role. ŽÁDNÝ vendor prefix** — je to
`--color-brand`, nikoliv `--pd-color-…`.

- **Barva:** `--color-brand`, `--color-brand-strong`, `--color-action`, `--color-accent`,
  `--color-bg`, `--color-surface`, `--color-surface-tint`, `--color-text`, `--color-muted`,
  `--color-border`, `--color-on-brand`, `--color-track`, `--color-urgent`, `--color-on-urgent`,
  `--color-success`, `--color-on-success`, `--color-category-development`,
  `--color-category-health`, `--color-category-subsistence`.
- **Písmo:** `--font-display`, `--font-body`, `--font-display-weight`, `--font-display-tracking`.
- **Radius:** `--radius-card`, `--radius-control`, `--radius-icon`, `--radius-pill` (všechny
  `${n}px` kromě `radius-icon`, který zůstává raw string, např. `50%`).
- **Stín:** `--shadow-card` (raw string).
- **Odsazení (sdílené, `:root`):** `--space-xs`, `--space-sm`, `--space-md`, `--space-lg`,
  `--space-xl` (všechny `${n}px`).
- **Velikost (sdílená, `:root`):** `--size-sm`, `--size-base`, `--size-lg`, `--size-xl`,
  `--size-xxl`, `--size-display` (všechny `${n}px`).
- **Layout (sdílený, `:root`):** `--layout-container` (`${n}px`).

**Generovaný tvar** (`packages/tokens/build.ts` → `dist/tokens.css`):

```css
:root { --space-xs: 4px; … --layout-container: 1200px; }
[data-theme="cz"] { --color-brand: #EC4B34; … --shadow-card: …; }
[data-theme="ro"] { --color-brand: #0FB5AE; … --shadow-card: …; }
```

Komponenty čtou tokeny **pouze** přes `var(--…)` v přiřazených `<Name>.module.css` — žádné
hex/px literály pro hodnoty vlastněné tokeny. Příklad (`Button.module.css`):
`background: var(--color-action); color: var(--color-on-brand); border-radius: var(--radius-pill);
font-family: var(--font-body); padding: var(--space-sm) var(--space-lg);
outline: 2px solid var(--color-accent)` (focus).

## 11. Model vícetenantového theming

**Jednoosý, na slotech založený vícetenantový model theme.** Jedna sada sémantických slotů, dvě
plné sady hodnot (`themes.cz`, `themes.ro`), vybírané v runtime čistě atributem
`data-theme="cz|ro"` na předku elementu — žádné změny kódu komponent, žádné forky.

- **Tenanti implementovaní dnes:** `ThemeName = "cz" | "ro"` — CZ = **patrondeti.cz** (kotva
  Nadace Sirius); RO = **kidshero.ro** (kotva KidsHero / Premier Energy).
- **MD (Moldavsko):** zmiňováno pouze jako *budoucí* možnost ("výhledově 3. země") — **není
  implementováno**. Jakékoliv hodnoty tokenů specifické pro MD považujte za chybějící/budoucí,
  nikoliv za současný cílový rozsah.
- **Theme-schopné (pod `[data-theme="…"]`):** celé `color.*`, `font.*`, `radius.*`, `shadow.*`.
- **Fixní/sdílené (na `:root`):** `space.*`, `size.*`, `layout.*`.
- **Sloty jsou role, nikoliv odstíny:** slot se může u obou tenantů shodovat v hodnotě (např.
  `urgent`) nebo se výrazně lišit (např. `action`: CZ = brandová červená, RO = námořnická modrá)
  — komponenty se o to nikdy nestarají.
- **Runtime (web):** Storybook decorator nastavuje `data-theme={tenant}` na kontejner story;
  toolbar dropdown to přepíná (`globalTypes.tenant`, hodnoty `cz`/`ro`, výchozí `cz`).
- **Runtime (native):** importuje `themes[name]` přímo jako typovaný JS objekt, bez build kroku.
- **Light/dark mód:** zdokumentovaná budoucí *druhá osa* (`data-mode`), záměrně nevyztužená —
  aktivní je dnes pouze tenant, jen light varianta.
- **Brandmark je součástí theme, nikoliv content propem:** CZ vykresluje in-repo kompozici
  (ikonová dlaždice + wordmark, s použitím `--radius-icon`/`--color-brand`/`--font-display*`); RO
  vykresluje živé logo KidsHero, hotlinkované z externí URL (žádné binární assety v repozitáři).
  CSS přepíná, které je viditelné, podle `data-theme`.

## 12. Otevřené otázky (přenesené z evidenčního katalogu — nevyřešené, nezavírat tiše)

1. **Žádný skutečný semver.** `packages/tokens/package.json` je zapíchnutý na `0.0.0` (privátní,
   workspace-interní). "tokens v0.2" existuje pouze jako git commit-message / changelog milník,
   nikoliv jako strojově čitelná verze balíčku. Jakoukoliv referenci na "verzi tokenu" ve
   specifikacích považujte za značku revize dokumentu/modelu, nikoliv za verzi balíčku, dokud
   nebude existovat nástrojově vynucená kontrola.
2. **Sada kategorií příběhu není finální.** Tři kategorie v §3.3 (development, health,
   subsistence) jsou v modelovém dokumentu tokenů explicitně označeny `needs: @analyst` — "pokrývají
   pouze demo". Závaznou sadu kategorií (a mapování barev per tenant) pro rebuild musí potvrdit
   BA/analytická práce, než vrstva UX bude `color.category.*` považovat za uzavřenou sadu.
3. **Fragilita hotlinku loga RO.** Branding RO závisí na živé externí URL
   (`kidshero.ro/themes/custom/patron_ro/images/logo.svg`). Jde o záměrné demo rozhodnutí (žádné
   binárky v repozitáři), ale je to fragilita, kterou je třeba pro rebuild zaznamenat — pokud se
   tento host změní, RO ztratí své logo bez lokálního fallbacku.

## 13. Index zdrojů (rebuild repozitář, pro dohledatelnost)

Všechny cesty pod `/Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/`:

| Záležitost | Soubor |
|---|---|
| Veřejné API / barrel | `packages/tokens/src/index.ts` |
| Hodnoty tokenů + rozhraní + theming | `packages/tokens/src/themes.ts` |
| Mapování token → CSS-var (pojmenování) | `packages/tokens/src/css.ts` |
| Metadata role slotu | `packages/tokens/src/docs.ts` |
| CSS build (`:root` + `[data-theme]`) | `packages/tokens/build.ts` |
| Identita balíčku | `packages/tokens/package.json` |
| Model tokenu / intent | `docs/design/tokens.md` |
| Metodologie designové vrstvy | `docs/design/README.md` |
| ADR pipeline (mechanika buildu) | `docs/architecture/adr/ADR0003-pipeline-design-tokenu.md` |
| Storybook tenant decorator + viewporty | `packages/ui/.storybook/preview.tsx` |
| Načítání webfontů | `packages/ui/.storybook/preview-head.html` |
| Globální reset | `packages/ui/src/global.css` |
| Ukázkový spotřebitel (použití var) | `packages/ui/src/components/Button/Button.module.css` |
| Brandmark (logo tenanta) | `packages/ui/src/components/Brandmark/{Brandmark.tsx,Brandmark.module.css,Brandmark.contract.md}` |

Úplná extrakce s odůvodněním, citacemi jednotlivých rozhodnutí a nekanonickým upozorněním na
exploraci tenant-theming HTML: `_ar/evidence/design-system/tokens.md`.

---

*Tento dokument je referencí na úrovni draftu (`_ar/spec-draft/`). Je citován, nikoliv restatován,
dokumenty UX vrstvy (`IA`, `WIRE`, `COMP`, `COPY`) podle cross-layer discipline — tyto vrstvy by
měly odkazovat na názvy tokenů/slotů odtud, nikoliv znovu citovat hex/px hodnoty.*
