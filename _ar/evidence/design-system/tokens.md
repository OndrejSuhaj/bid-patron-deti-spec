# Evidence — Design token system of the `bid-patron-deti` rebuild

> **Scope & authority.** This is a READ-ONLY catalogue of the **canonical design-token system of the
> `bid-patron-deti` REBUILD project** (the future/target storefront), NOT of the current Patronus
> Drupal system. It is extracted so the reconstructed UX documentation of Patronus can, where useful,
> be made to respect the rebuild's design language. Per the project constitution, `it-zadani` /
> target-state material is **not** current-state truth — treat this catalogue the same way.
>
> **Extracted from:** `/Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/` — package
> `@patron/tokens` (`packages/tokens/`). Every value below is quoted from the cited source file.
> Nothing here is invented; ambiguities are flagged as **Open Question**.
>
> **Not committed** (evidence working note).

---

## 0. Version & package identity

| Fact | Value | Source |
|---|---|---|
| Package name | `@patron/tokens` | `packages/tokens/package.json` |
| `package.json` version field | `0.0.0` (private, workspace-internal) | `packages/tokens/package.json` |
| "tokens v0.2" (the version the task references) | git commit subject `54e4465 design: detail příběhu povýšen do kánonu — tokens v0.2, katalog, screen` | git log |
| Module type | ESM (`"type": "module"`), TS source consumed directly (`main`/`types` → `./src/index.ts`) | `packages/tokens/package.json` |
| Two consumption entries | `.` → `src/index.ts` (JS theme objects, read by web **and** native); `./tokens.css` → `dist/tokens.css` (generated CSS custom properties, read by web) | `packages/tokens/package.json`, ADR0003 |

**Open Question — version number.** The token package's `package.json` is pinned at `0.0.0`; there is
no semantic version tag in the repo. "v0.2" exists only as a **git commit message / doc-changelog
milestone**, not as a machine-readable package version. The token-model doc
(`docs/design/tokens.md § 7`) defines a patch/minor/breaking policy but explicitly leaves enforcement
to manual discipline (`E0001 brief`: "nástrojové vynucení token-verzí je vědomě mimo scope dema").
So "the current token version" is best described as **doc/model revision as of 2026-07-04**, not a
package version.

### Architecture principle (how the system is layered)

Source of truth is split three ways — this is the load-bearing rule of the whole system
(`docs/design/tokens.md § 1`, ADR0003):

```
docs/design/tokens.md   → INTENT: which slots exist, their meaning, axes, naming   (the "contract")
packages/tokens/src     → VALUES: hex, px, font families                            (the numbers)
        ↓ build (tsx build.ts)
   dist/tokens.css (web: CSS custom properties)  +  JS theme object (native: direct import)
        ↓
   Storybook "Foundations" = LIVE visualization of the values, read from code
```

- **Two conceptual layers** (`tokens.md § 2`): **primitives** (raw brand colors, neutral scale — never
  touched by components directly) and **semantic slots** (roles components reference:
  `color.brand`, `color.surface`, …). A component **never writes a hex, only a slot.** Re-skinning a
  tenant = remapping slots, not editing components.
- **DTCG-shaped naming** (`color.brand`, `radius.card`, `space.md`) as an interop hedge, but the DTCG
  *toolchain* (Style Dictionary / Terrazzo, `$value`/`$type`) is deliberately NOT adopted (ADR0003).
- **Asymmetric fan-out** (ADR0003): web needs a build step (TS → `dist/tokens.css`); native needs no
  build (imports `themes[name]` as a JS object). Platform-shaped tokens (font stacks, alpha mixing)
  are handled by a thin per-platform adapter, not by two definitions.

---

## 1. Token structure — what exists, and what is tenant-bound

Two TypeScript interfaces in `packages/tokens/src/themes.ts` define the entire token surface:

- **`ThemeTokens`** — everything **tenant-bound** (one value set per tenant): `color`, `font`,
  `radius`, `shadow`. Emitted under `[data-theme="…"]`.
- **`SharedTokens`** — everything **shared across tenants**: `space`, `size`, `layout`. Emitted on
  `:root`.

| Dimension | Category | Tenant-bound? | Owning object | Emitted under |
|---|---|---|---|---|
| color | base roles + status family + story categories | **yes** | `ThemeTokens.color` | `[data-theme="…"]` |
| typography — families & display traits | `font.display/body/displayWeight/displayTracking` | **yes** | `ThemeTokens.font` | `[data-theme="…"]` |
| typography — type scale | `size.*` | **no (shared)** | `SharedTokens.size` | `:root` |
| radius | `radius.card/control/icon/pill` | **yes** | `ThemeTokens.radius` | `[data-theme="…"]` |
| shadow / elevation | `shadow.card` | **yes** | `ThemeTokens.shadow` | `[data-theme="…"]` |
| spacing | `space.xs…xl` | **no (shared)** | `SharedTokens.space` | `:root` |
| layout / container | `layout.container` | **no (shared)** | `SharedTokens.layout` | `:root` |

**Categories NOT present as tokens** (verified absent in `packages/tokens/src`): there are **no**
tokens for `z-index`, `motion`/duration/easing, `breakpoints`, `border-width`, `opacity`, letter-spacing
(beyond the single display tracking), or line-height. See §9 (Absent categories) for where these live
instead.

---

## 2. Color tokens (tenant-bound) — actual values

Source of values: `packages/tokens/src/themes.ts` (`themes.cz`, `themes.ro`).
Source of role/meaning: `docs/design/tokens.md § 5` + `packages/tokens/src/docs.ts`.
Tenants: `cz` = **patrondeti.cz** (anchor Nadace Sirius; "warm, sharper, urgent"),
`ro` = **kidshero.ro** (anchor KidsHero / Premier Energy; "cooler, softer, trustworthy").

### 2.1 Base role slots

| Slot | Role (one-liner) | CZ value | RO value |
|---|---|---|---|
| `color.brand` | primary brand color — logo accent, active state, progress fill | `#EC4B34` | `#0FB5AE` |
| `color.brandStrong` | strong dark brand shade — emphasis text, full "promise" surfaces ("100 % to the child") | `#B3311D` | `#0A7E79` |
| `color.action` | CTA / action elements — "Přispět" button (CZ = brand, RO = navy) | `#EC4B34` | `#16235A` |
| `color.accent` | secondary emphasis — badges, highlights; also read by focus ring | `#6D4AFF` | `#FF7A2F` |
| `color.bg` | page canvas — `body` background (tuned, not pure white) | `#FFF6F2` | `#EFF9F9` |
| `color.surface` | surfaces above canvas — cards, panels (usually white) | `#FFFFFF` | `#FFFFFF` |
| `color.surfaceTint` | softly tinted surface — chip wash, secondary panels, meter base | `#FBECE6` | `#E1F3F2` |
| `color.text` | primary text — headings, body | `#2A1A15` | `#132247` |
| `color.muted` | secondary / muted text — captions, meta | `#7C665E` | `#586A8C` |
| `color.border` | outlines and dividers — card frames, rules | `#EEDDD5` | `#D6E7E6` |
| `color.onBrand` | text/icons on brand & action surfaces | `#FFF6F2` | `#EFF9F9` |
| `color.track` | progress track — unfilled part of a progress bar | `#FBECE6` | `#E1F3F2` |

### 2.2 Status family (own tokens, decoupled from brand — `tokens.md § 5.2`)

Status colors are **their own tokens, not derived from brand** (lesson from exploration: urgency
taken from the dark RO teal blended into the brand). A tenant *may* tune the shade; it must not be
*derived* from brand. Note RO `success` intentionally sits in the teal family and may coincide with
brand by value — but is not derived from it.

| Slot | Role | CZ value | RO value |
|---|---|---|---|
| `color.urgent` | urgency, collection nearing its end — time pill, "Naléhavé" badge | `#D92D20` | `#D92D20` |
| `color.onUrgent` | text/icons on urgent surface | `#FFFFFF` | `#FFFFFF` |
| `color.success` | success, positive verification, trust — "Vybráno" chip, patron seal | `#149E6E` | `#0FB5AE` |
| `color.onSuccess` | text/icons on success surface | `#FFFFFF` | `#FFFFFF` |

`warning` and `info` are a **documented direction, not scaffolded** — will be added as a minor when a
component first needs them (`tokens.md § 5.2`).

### 2.3 Story category colors (`color.category.*` — `tokens.md § 5.3`)

Same story area = same color everywhere in the UI (chip, card wash/monogram, detail accents).
Per-tenant remappable. Keys are English (language-zone rule); Czech domain term in the last column.

| Slot | CZ value | RO value | Domain area (CZ term) |
|---|---|---|---|
| `color.category.development` | `#149E6E` | `#0FB5AE` | rozvoj a vzdělání (development & education) |
| `color.category.health` | `#6D4AFF` | `#2F7DBF` | zdraví (health) |
| `color.category.subsistence` | `#C2740A` | `#FF7A2F` | existenční potřeby (subsistence) |

**Open Question — category set is not final.** `tokens.md § 5.3` carries a `needs: @analyst` note:
the binding list of categories (and per-tenant mapping) must be confirmed by the spec; today's three
"cover the demo".

### 2.4 Colors that are NOT slots — computed in CSS

- **Washes / tints** (~12–16 % of brand into a surface, translucent monograms) are computed with CSS
  `color-mix()`, **not** separate slots — keeps the slot count low and tints re-color themselves with
  their source slot (`tokens.md § 5.1`). (18 `color-mix()` uses across `packages/ui/src`.)
- **Focus ring** has **no own slot**: outline reads `color.accent` (same for both tenants today). A
  dedicated `color.focus` will appear only when the roles diverge (`tokens.md § 5.1`).

---

## 3. Typography tokens

### 3.1 Font families & display traits (tenant-bound — `ThemeTokens.font`, `themes.ts`)

| Slot | Role | CZ value | RO value |
|---|---|---|---|
| `font.display` | title family — carrier of tenant character | `'Bricolage Grotesque', system-ui, sans-serif` | `'Baloo 2', system-ui, sans-serif` |
| `font.body` | body family — shared neutral grotesk | `'Hanken Grotesk', system-ui, sans-serif` | `'Hanken Grotesk', system-ui, sans-serif` |
| `font.displayWeight` | title weight (belongs to the family) | `800` | `700` |
| `font.displayTracking` | title letter-spacing (belongs to the family) | `-0.02em` | `0em` |

Rationale (`tokens.md § 3`): display traits belong to the family — swapping the family without them
would not carry the title character (Bricolage = 800 + negative tracking; Baloo = 700 + none).

**Font loading** is out of the token package — `tokens.css` only *references* the families. Webfonts
are loaded via Google Fonts `<link>` (`packages/ui/.storybook/preview-head.html`): Bricolage Grotesque
(600/700/800, optical size 12–96), Baloo 2 (500/600/700/800), Hanken Grotesk (400/500/600/700 + italic 400).
Per ADR0003 native uses a per-platform adapter (family name + separately bundled font).

### 3.2 Type scale (shared across tenants — `SharedTokens.size`, `themes.ts`)

The size scale is shared; only families/traits are tenant-bound. Emitted as `px`.

| Slot | Value (px) |
|---|---|
| `size.sm` | 13 |
| `size.base` | 16 |
| `size.lg` | 20 |
| `size.xl` | 28 |
| `size.xxl` | 36 |
| `size.display` | 52 |

**Not tokenized:** line-height and per-step letter-spacing (only the single `font.displayTracking`
exists). Line-heights and small internal clamps are declared as "local component detail, not tokens"
(`tokens.md § 3`). Typography is documented as *styles* in Storybook `Foundations/Typografie`, not as
Heading/Text atoms (`docs/design/README.md` changelog 2026-07-04).

---

## 4. Spacing scale (shared — `SharedTokens.space`, `themes.ts`)

Structural layout rhythm, shared across tenants. Emitted as `px`.

| Slot | Value (px) |
|---|---|
| `space.xs` | 4 |
| `space.sm` | 8 |
| `space.md` | 16 |
| `space.lg` | 24 |
| `space.xl` | 40 |

---

## 5. Radius tokens (tenant-bound — `ThemeTokens.radius`, `themes.ts`)

Radius is a strong carrier of brand feel: CZ sharper + circular icon tiles; RO softer + squircle.
Numeric slots emitted as `px`; `icon` is emitted as its raw string.

| Slot | Role | CZ value | RO value | CSS emit |
|---|---|---|---|---|
| `radius.card` | cards & large surfaces | `16` (→ `16px`) | `26` (→ `26px`) | `${n}px` |
| `radius.control` | controls — inputs, amount presets, small panels | `10` (→ `10px`) | `16` (→ `16px`) | `${n}px` |
| `radius.icon` | icon tile shape — circle (CZ) vs squircle (RO) | `"50%"` | `"16px"` | raw string |
| `radius.pill` | full round — pills, buttons, chips | `999` (→ `999px`) | `999` (→ `999px`) | `${n}px` |

Note: `radius.icon` is a `string` in the interface (so it can hold `50%`), whereas the others are
numbers converted to `px` by `css.ts`.

---

## 6. Shadow / elevation tokens (tenant-bound — `ThemeTokens.shadow`, `themes.ts`)

Elevation shadow tinted into the tenant's ink, not generic black (`tokens.md § 3`).

| Slot | CZ value | RO value |
|---|---|---|
| `shadow.card` | `0 1px 2px rgba(42, 26, 21, 0.06), 0 16px 34px -16px rgba(42, 26, 21, 0.22)` | `0 1px 2px rgba(19, 34, 71, 0.06), 0 16px 36px -16px rgba(19, 34, 71, 0.26)` |

---

## 7. Layout / container (shared — `SharedTokens.layout`, `themes.ts`)

Single source of truth for content-container width across pages and full-bleed bands (footer).

| Slot | Value (px) | Note |
|---|---|---|
| `layout.container` | 1200 | Widened from an earlier 1040 (changelog 2026-07-04, `tokens.md`). |

---

## 8. Naming convention & emitted CSS custom-property names

**Token path convention** (DTCG-shaped, `dimension.role`, `tokens.md § 6`, ADR0003):
`color.brand`, `color.category.development`, `radius.card`, `space.md`, `font.display`.

**Token → CSS variable mapping** lives in exactly **one place** — `packages/tokens/src/css.ts`
(`toCssVars` for tenant tokens, `sharedCssVars` for shared) — so the CSS generator and the components
use identical names (no drift). The prefix is **`--`** followed by dashed dimension+role.
**Note: there is NO vendor prefix** — it is `--color-brand`, **not** `--pd-color-…` as the task
guessed. Every emitted variable, verbatim from `css.ts`:

### Tenant-bound vars (emitted under `[data-theme="cz"]` / `[data-theme="ro"]`)

| Token path | CSS variable | Value transform |
|---|---|---|
| `color.brand` | `--color-brand` | raw |
| `color.brandStrong` | `--color-brand-strong` | raw |
| `color.action` | `--color-action` | raw |
| `color.accent` | `--color-accent` | raw |
| `color.bg` | `--color-bg` | raw |
| `color.surface` | `--color-surface` | raw |
| `color.surfaceTint` | `--color-surface-tint` | raw |
| `color.text` | `--color-text` | raw |
| `color.muted` | `--color-muted` | raw |
| `color.border` | `--color-border` | raw |
| `color.onBrand` | `--color-on-brand` | raw |
| `color.track` | `--color-track` | raw |
| `color.urgent` | `--color-urgent` | raw |
| `color.onUrgent` | `--color-on-urgent` | raw |
| `color.success` | `--color-success` | raw |
| `color.onSuccess` | `--color-on-success` | raw |
| `color.category.development` | `--color-category-development` | raw |
| `color.category.health` | `--color-category-health` | raw |
| `color.category.subsistence` | `--color-category-subsistence` | raw |
| `font.display` | `--font-display` | raw string |
| `font.body` | `--font-body` | raw string |
| `font.displayWeight` | `--font-display-weight` | `String(n)` |
| `font.displayTracking` | `--font-display-tracking` | raw string |
| `radius.card` | `--radius-card` | `${n}px` |
| `radius.control` | `--radius-control` | `${n}px` |
| `radius.icon` | `--radius-icon` | raw string (e.g. `50%`) |
| `radius.pill` | `--radius-pill` | `${n}px` |
| `shadow.card` | `--shadow-card` | raw string |

### Shared vars (emitted on `:root`)

| Token path | CSS variable | Value transform |
|---|---|---|
| `space.xs…xl` | `--space-xs`, `--space-sm`, `--space-md`, `--space-lg`, `--space-xl` | `${n}px` |
| `size.sm…display` | `--size-sm`, `--size-base`, `--size-lg`, `--size-xl`, `--size-xxl`, `--size-display` | `${n}px` |
| `layout.container` | `--layout-container` | `${n}px` |

**Generated `dist/tokens.css` shape** (`packages/tokens/build.ts`):

```css
/* AUTO-GENEROVÁNO z packages/tokens/src — needituj ručně (ADR0003). */

:root { --space-xs: 4px; … --layout-container: 1200px; }

[data-theme="cz"] { --color-brand: #EC4B34; … --shadow-card: …; }

[data-theme="ro"] { --color-brand: #0FB5AE; … --shadow-card: …; }
```

**Role metadata** (one-line role of every slot) also lives in code, in
`packages/tokens/src/docs.ts` (`tokenDocs`, `sharedDocs`) — read by Storybook Foundations so the docs
render from code, not hand-copied text. A consistency audit (`tokens.md § 7`) requires each slot to
have a match in model + values + docs.

---

## 9. Absent token categories — where those concerns live instead

The task asked for z-index, motion/durations/easings, breakpoints, borders. **None are tokenized.**
Verified via `grep` over `packages/tokens/src` (no matches). Where the concern is handled:

| Concern | Status | Where it lives instead |
|---|---|---|
| **Breakpoints** | **not tokenized** | Media queries are hard-coded per component CSS. Observed values in `packages/ui/src`: `480px`, `560px`, `720px`, `860px`, `900px`. Responsive slices are also curated via Storybook `viewport` presets (`preview.tsx`): Mobil S 360, Mobil 390, Mobil L 430, Tablet 820, Tablet landscape 1180, Notebook 1280, Desktop 1440. |
| **Motion / duration / easing** | **not tokenized** | Transitions declared inline per component (e.g. `Button.module.css`: `transition: filter .15s ease, …`). `prefers-reduced-motion` handled ad hoc in the exploration HTML. |
| **z-index** | **not tokenized** | Not present in token source or component CSS (only the exploration HTML uses a raw `z-index:50`). |
| **Border width** | **not tokenized** | Only `color.border` (the color) is a token; widths (`1px`, `1.5px`) are literal in component CSS. |
| **Opacity** | **not tokenized** | Literal (`disabled { opacity: .5 }`). |
| **Global reset** | not a token | `packages/ui/src/global.css` — border-box reset + `body{margin:0}`, imported by Storybook and future `apps/*`. |

**Light/dark mode** is a *documented future axis, deliberately not scaffolded* (`tokens.md § 4`): the
model reserves `[data-theme="cz"][data-mode="dark"]` as a **second axis**; only tenant (CZ/RO) is
active today, light-only.

---

## 10. Theming model (tenant / country) — how overrides work

**One-paragraph summary.** The system is a **single-axis, slot-based multi-tenant theme**: one set of
semantic slots, two full value sets (`themes.cz`, `themes.ro`) selected at runtime purely by a
`data-theme="cz|ro"` attribute on an ancestor element — no component code changes, no forks (the
demo's "pilíř 2"). Shared axes (`space`, `size`, `layout`) are emitted once on `:root`; everything
tenant-expressive (all colors, font families + display traits, all radii, the card shadow) is emitted
under `[data-theme="…"]`, so a tenant switch re-points every `var(--…)` a component already reads.
Components are language-mute and hex-mute — they only reference slots and receive display strings via
props; the tenant switch also swaps content fixtures (CZ/RO copy) in Storybook. The model is designed
so light/dark can later be added as an orthogonal second axis (`data-mode`) rather than a rewrite,
because background/text/surface are already isolated as semantic slots.

- **Tenants:** `ThemeName = "cz" | "ro"` (`themes.ts`); `themeNames = ["cz","ro"]`. A third country
  (MD/Moldova) is referenced as a *future* possibility in ADR0003 ("výhledově 3. země") but is **not**
  implemented — only CZ and RO exist in code.
- **What is themeable vs fixed:** themeable = all of `color.*`, `font.*`, `radius.*`, `shadow.*`
  (i.e. everything in `ThemeTokens`). Fixed/shared = `space.*`, `size.*`, `layout.*` (everything in
  `SharedTokens`).
- **Slots are roles, not shades** (`tokens.md § 5.1`): `action` may coincide with `brand` for one
  tenant and contrast for another (CZ action = brand `#EC4B34`; RO action = navy `#16235A`); `track`
  may coincide in value with `surfaceTint`; the component doesn't care.
- **Runtime mechanism (web):** Storybook decorator sets `data-theme={tenant}` on the story container
  and toggles a toolbar dropdown (`globalTypes.tenant`, values `cz`/`ro`, default `cz`) —
  `packages/ui/.storybook/preview.tsx`. The build emits the tenant blocks; CSS does the rest.
- **Runtime mechanism (native):** imports `themes[name]` directly as a JS object, no build (ADR0003).

### Brandmark / tenant-logo relationship

The tenant **logo is part of the theme, not a content prop** (`Brandmark.tsx`,
`Brandmark.contract.md`). Both tenants' logos are rendered into the DOM and CSS picks the active one
by `data-theme` — exactly like the icon set:

- **CZ:** an in-repo composition — the `give` icon (heart-in-hand) on a brand tile
  (`--radius-icon`, `--color-brand` background, `--color-on-brand` glyph) + the wordmark "patron dětí"
  in `--font-display` / `--font-display-weight` / `--font-display-tracking`, colored `--color-brand`.
- **RO:** the live KidsHero logo, **hotlinked** (`<img src="https://kidshero.ro/…/logo.svg"
  alt="KidsHero">`) — deliberately no binary assets in the repo.
- CSS switch (`Brandmark.module.css`): `[data-theme="ro"] .cz { display:none }` /
  `[data-theme="ro"] .ro { display:block }`. A `small` variant shrinks it for the footer.
- Switching the tenant swaps the logo with **zero change to the consumer** (SiteHeader/SiteFooter just
  drop in `<Brandmark/>`).

**Open Question — RO logo hotlink.** RO branding depends on a live external URL
(`kidshero.ro/themes/custom/patron_ro/images/logo.svg`); if that host changes, RO loses its logo. This
is an intentional demo decision (no binaries in repo) but is a fragility to note for the rebuild.

---

## 11. How tokens are consumed by components

- **Web components** read tokens **only** as CSS custom properties via `var(--…)` inside colocated
  `<Name>.module.css` — **no hex/px literals for token-owned values** (`docs/design/README.md § 2–3`,
  ADR0003; "Žádný Tailwind/NativeWind"). Example — `Button.module.css`: `background: var(--color-action)`,
  `color: var(--color-on-brand)`, `border-radius: var(--radius-pill)`, `font-family: var(--font-body)`,
  `padding: var(--space-sm) var(--space-lg)`, focus `outline: 2px solid var(--color-accent)`.
- **Import wiring:** the app/Storybook imports `@patron/tokens/tokens.css` once (→ `:root` + both
  `[data-theme]` blocks) plus `@patron/ui`'s `global.css` reset (`preview.tsx`). Components never
  import the token package directly for values — they just use `var(--…)`.
- **Native (future):** imports `themes[name]` from `@patron/tokens` as a typed JS object
  (`index.ts` re-exports `themes`, `themeNames`, `shared`, plus types `ThemeName`/`ThemeTokens`/
  `SharedTokens`, and `toCssVars`/`sharedCssVars`, `tokenDocs`/`sharedDocs`). Parity is enforced by
  component contracts (`.contract.md`), not shared code (ADR0002/ADR0003).
- **Storybook "Foundations"** renders live values + roles straight from `packages/tokens` (values) and
  `docs.ts` (roles) — `packages/ui/src/foundations/TokenGallery.tsx`.
- **UI component inventory** consuming these tokens (`packages/ui/src/components/`): Brandmark, Button,
  CategoryChip, DonationBox, Icon, Input, PatronCard, PledgeStrip, ProgressBar, RailCta, ShareRow,
  SiteFooter, SiteHeader, StoryCard, StoryHero, TimeLeftPill.

---

## 12. Source file index (for traceability)

All paths under `/Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/`:

| Concern | File |
|---|---|
| Public API / barrel | `packages/tokens/src/index.ts` |
| Token **values** + interfaces + theming | `packages/tokens/src/themes.ts` |
| Token → CSS-var mapping (naming) | `packages/tokens/src/css.ts` |
| Slot role metadata | `packages/tokens/src/docs.ts` |
| CSS build (`:root` + `[data-theme]`) | `packages/tokens/build.ts` |
| Package identity | `packages/tokens/package.json` |
| Token **model / intent** | `docs/design/tokens.md` |
| Design-layer methodology | `docs/design/README.md` |
| Pipeline ADR (build mechanics) | `docs/architecture/adr/ADR0003-pipeline-design-tokenu.md` |
| Tenant-theming exploration (non-canonical) | `docs/design/explorations/tenant-theming.html` |
| Storybook tenant decorator + viewports | `packages/ui/.storybook/preview.tsx` |
| Webfont loading | `packages/ui/.storybook/preview-head.html` |
| Global reset | `packages/ui/src/global.css` |
| Sample consumer (var usage) | `packages/ui/src/components/Button/Button.module.css` |
| Brandmark (tenant logo) | `packages/ui/src/components/Brandmark/{Brandmark.tsx,Brandmark.module.css,Brandmark.contract.md}` |

> **Note on the exploration HTML.** `tenant-theming.html` uses an *older, differently-named* CSS
> variable set (`--brand`, `--ink`, `--radius`, `--accent-2`, `--focus`, `--on-action`, …) and is
> explicitly **non-canonical** ("Není kanonický token set; slouží k diskuzi"). The canonical names are
> the `--color-*` / `--radius-*` / `--space-*` / `--size-*` set in `css.ts`. Do not treat the
> exploration's variable names as the token contract; its **values** (hexes, radii, fonts) were later
> distilled into `packages/tokens` and match the canonical values above.
