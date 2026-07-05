# DESIGN — Token Reference (TARGET design system)

> **Status: TARGET, NOT current-state.** This document is the canonical distillation of the
> **`bid-patron-deti` REBUILD's** design-token system (`@patron/tokens`, package
> `packages/tokens/`). It describes the **future/target** design language, not Patronus/Drupal's
> current-state UI. Per the project constitution, this is `it-zadani`-class target material — it
> must not be cited as evidence of Patronus's current behavior or presentation, and must not be
> conflated with reconstructed current-state UX. It exists so the UX layer (`IA/WIRE/COMP/COPY`)
> can cite one authoritative, stable set of token names and values when describing target screens
> or when noting where current-state UI diverges from the target system.
>
> **Full extraction / working notes:** `_ar/evidence/design-system/tokens.md` (not committed) —
> this document is the concise, citable distillation of that catalogue. Where this document and the
> evidence catalogue disagree, the evidence catalogue is more detailed and should be re-checked.
>
> **Source of truth (rebuild repo):** `/Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/`,
> package `@patron/tokens` — see §7 Source index below for exact files.

---

## 1. Architecture — three-way split

```
docs/design/tokens.md   → INTENT: which slots exist, their meaning, axes, naming   (the "contract")
packages/tokens/src     → VALUES: hex, px, font families                            (the numbers)
        ↓ build (tsx build.ts)
   dist/tokens.css (web: CSS custom properties)  +  JS theme object (native: direct import)
        ↓
   Storybook "Foundations" = LIVE visualization of the values, read from code
```

- **Two conceptual layers:** **primitives** (raw brand colors, neutral scale — never referenced by
  components directly) and **semantic slots** (roles components reference: `color.brand`,
  `color.surface`, …). A component never writes a hex — only a slot. Re-skinning a tenant means
  remapping slots, not editing components.
- **Naming is DTCG-shaped** (`color.brand`, `radius.card`, `space.md`) as an interop hedge, but the
  DTCG *toolchain* (Style Dictionary / Terrazzo) is deliberately not adopted.
- Web needs a build step (TS → `dist/tokens.css`); native needs none (imports the theme object
  directly). Platform-shaped concerns (font stacks, alpha mixing) are handled by a thin
  per-platform adapter, not by two token definitions.

## 2. Token surface — tenant-bound vs. shared

Two TypeScript interfaces in `packages/tokens/src/themes.ts` define the entire surface:

| Dimension | Tenant-bound? | Owning object | Emitted under |
|---|---|---|---|
| color (base roles + status + story categories) | **yes** | `ThemeTokens.color` | `[data-theme="…"]` |
| font families & display traits | **yes** | `ThemeTokens.font` | `[data-theme="…"]` |
| type scale (`size.*`) | no (shared) | `SharedTokens.size` | `:root` |
| radius | **yes** | `ThemeTokens.radius` | `[data-theme="…"]` |
| shadow / elevation | **yes** | `ThemeTokens.shadow` | `[data-theme="…"]` |
| spacing (`space.*`) | no (shared) | `SharedTokens.space` | `:root` |
| layout / container | no (shared) | `SharedTokens.layout` | `:root` |

**Not tokenized** (verified absent): z-index, motion/duration/easing, breakpoints, border-width,
opacity, per-step letter-spacing, line-height. These are handled ad hoc in component CSS /
Storybook viewport presets, not via tokens — do not invent token names for them in the UX layer.

## 3. Color tokens — 19 slots (tenant-bound)

Tenants: **cz** = patrondeti.cz (warm, sharper, urgent); **ro** = kidshero.ro (cooler, softer,
trustworthy).

### 3.1 Base role slots (12)

| Slot | Role | CZ | RO |
|---|---|---|---|
| `color.brand` | primary brand — logo accent, active state, progress fill | `#EC4B34` | `#0FB5AE` |
| `color.brandStrong` | strong dark brand shade — emphasis, "100% to the child" | `#B3311D` | `#0A7E79` |
| `color.action` | CTA / action elements ("Přispět" button) | `#EC4B34` | `#16235A` |
| `color.accent` | secondary emphasis (badges, highlights); also the focus ring | `#6D4AFF` | `#FF7A2F` |
| `color.bg` | page canvas (`body` background) | `#FFF6F2` | `#EFF9F9` |
| `color.surface` | surfaces above canvas (cards, panels) | `#FFFFFF` | `#FFFFFF` |
| `color.surfaceTint` | softly tinted surface (chip wash, meter base) | `#FBECE6` | `#E1F3F2` |
| `color.text` | primary text | `#2A1A15` | `#132247` |
| `color.muted` | secondary / muted text | `#7C665E` | `#586A8C` |
| `color.border` | outlines and dividers | `#EEDDD5` | `#D6E7E6` |
| `color.onBrand` | text/icons on brand & action surfaces | `#FFF6F2` | `#EFF9F9` |
| `color.track` | progress track (unfilled part) | `#FBECE6` | `#E1F3F2` |

### 3.2 Status family (4) — own tokens, NOT derived from brand

| Slot | Role | CZ | RO |
|---|---|---|---|
| `color.urgent` | urgency (time pill, "Naléhavé" badge) | `#D92D20` | `#D92D20` |
| `color.onUrgent` | text/icons on urgent surface | `#FFFFFF` | `#FFFFFF` |
| `color.success` | success/trust ("Vybráno" chip, patron seal) | `#149E6E` | `#0FB5AE` |
| `color.onSuccess` | text/icons on success surface | `#FFFFFF` | `#FFFFFF` |

`warning` and `info` are a documented direction, not yet scaffolded — do not assume they exist.

### 3.3 Story category colors (3) — `color.category.*`

Same story area = same color everywhere (chip, card wash/monogram, detail accents). Per-tenant
remappable.

| Slot | CZ | RO | Domain area |
|---|---|---|---|
| `color.category.development` | `#149E6E` | `#0FB5AE` | rozvoj a vzdělání |
| `color.category.health` | `#6D4AFF` | `#2F7DBF` | zdraví |
| `color.category.subsistence` | `#C2740A` | `#FF7A2F` | existenční potřeby |

**Total: 19 color slots** (12 base + 4 status + 3 category).

**Not slots:** washes/tints are computed with CSS `color-mix()`, not separate tokens. The focus
ring has no own slot — it reads `color.accent`.

## 4. Typography tokens

### 4.1 Font families & display traits (tenant-bound, 4 slots)

| Slot | CZ | RO |
|---|---|---|
| `font.display` | `'Bricolage Grotesque', system-ui, sans-serif` | `'Baloo 2', system-ui, sans-serif` |
| `font.body` | `'Hanken Grotesk', system-ui, sans-serif` | `'Hanken Grotesk', system-ui, sans-serif` |
| `font.displayWeight` | `800` | `700` |
| `font.displayTracking` | `-0.02em` | `0em` |

### 4.2 Type scale (shared, 6 slots) — px

| Slot | Value |
|---|---|
| `size.sm` | 13 |
| `size.base` | 16 |
| `size.lg` | 20 |
| `size.xl` | 28 |
| `size.xxl` | 36 |
| `size.display` | 52 |

Line-height and per-step letter-spacing are **not tokenized** (only the single
`font.displayTracking` exists); treated as local component detail.

## 5. Spacing scale (shared, 5 slots) — px

| Slot | Value |
|---|---|
| `space.xs` | 4 |
| `space.sm` | 8 |
| `space.md` | 16 |
| `space.lg` | 24 |
| `space.xl` | 40 |

## 6. Radius tokens (tenant-bound, 4 slots)

CZ = sharper + circular icon tiles; RO = softer + squircle.

| Slot | Role | CZ | RO | CSS emit |
|---|---|---|---|---|
| `radius.card` | cards & large surfaces | `16` | `26` | `${n}px` |
| `radius.control` | inputs, presets, small panels | `10` | `16` | `${n}px` |
| `radius.icon` | icon tile shape (circle CZ / squircle RO) | `"50%"` | `"16px"` | raw string |
| `radius.pill` | full round (pills, buttons, chips) | `999` | `999` | `${n}px` |

`radius.icon` is a string in the interface (holds `50%`); the other three are numbers converted to
px by `css.ts`.

## 7. Shadow / elevation (tenant-bound, 1 slot)

Shadow color is tinted into the tenant's ink, not generic black.

| Slot | CZ | RO |
|---|---|---|
| `shadow.card` | `0 1px 2px rgba(42, 26, 21, 0.06), 0 16px 34px -16px rgba(42, 26, 21, 0.22)` | `0 1px 2px rgba(19, 34, 71, 0.06), 0 16px 36px -16px rgba(19, 34, 71, 0.26)` |

## 8. Layout / container (shared, 1 slot)

| Slot | Value | Note |
|---|---|---|
| `layout.container` | 1200 px | Single source of truth for content-container width across pages and full-bleed bands. |

## 9. Token count summary

| Category | Count | Tenant-bound |
|---|---|---|
| Color | 19 (12 base + 4 status + 3 category) | yes |
| Font | 4 (2 family + weight + tracking) | yes |
| Type scale | 6 (sm 13 → display 52) | no (shared) |
| Spacing | 5 (xs 4 → xl 40) | no (shared) |
| Radius | 4 (card/control/icon/pill) | yes |
| Shadow | 1 (card) | yes |
| Layout/container | 1 (1200) | no (shared) |

## 10. CSS custom-property naming

**One canonical mapping**, in `packages/tokens/src/css.ts` (`toCssVars` for tenant tokens,
`sharedCssVars` for shared) — CSS generator and components use identical names, no drift.

**Naming rule: `--` + dashed dimension + role. NO vendor prefix** — it is `--color-brand`, not
`--pd-color-…`.

- **Color:** `--color-brand`, `--color-brand-strong`, `--color-action`, `--color-accent`,
  `--color-bg`, `--color-surface`, `--color-surface-tint`, `--color-text`, `--color-muted`,
  `--color-border`, `--color-on-brand`, `--color-track`, `--color-urgent`, `--color-on-urgent`,
  `--color-success`, `--color-on-success`, `--color-category-development`,
  `--color-category-health`, `--color-category-subsistence`.
- **Font:** `--font-display`, `--font-body`, `--font-display-weight`, `--font-display-tracking`.
- **Radius:** `--radius-card`, `--radius-control`, `--radius-icon`, `--radius-pill` (all `${n}px`
  except `radius-icon`, which stays a raw string, e.g. `50%`).
- **Shadow:** `--shadow-card` (raw string).
- **Space (shared, `:root`):** `--space-xs`, `--space-sm`, `--space-md`, `--space-lg`,
  `--space-xl` (all `${n}px`).
- **Size (shared, `:root`):** `--size-sm`, `--size-base`, `--size-lg`, `--size-xl`, `--size-xxl`,
  `--size-display` (all `${n}px`).
- **Layout (shared, `:root`):** `--layout-container` (`${n}px`).

**Generated shape** (`packages/tokens/build.ts` → `dist/tokens.css`):

```css
:root { --space-xs: 4px; … --layout-container: 1200px; }
[data-theme="cz"] { --color-brand: #EC4B34; … --shadow-card: …; }
[data-theme="ro"] { --color-brand: #0FB5AE; … --shadow-card: …; }
```

Components read tokens **only** via `var(--…)` in colocated `<Name>.module.css` — no hex/px
literals for token-owned values. Example (`Button.module.css`):
`background: var(--color-action); color: var(--color-on-brand); border-radius: var(--radius-pill);
font-family: var(--font-body); padding: var(--space-sm) var(--space-lg);
outline: 2px solid var(--color-accent)` (focus).

## 11. Multi-tenant theming model

**Single-axis, slot-based multi-tenant theme.** One set of semantic slots, two full value sets
(`themes.cz`, `themes.ro`), selected at runtime purely by a `data-theme="cz|ro"` attribute on an
ancestor element — no component code changes, no forks.

- **Tenants implemented today:** `ThemeName = "cz" | "ro"` — CZ = **patrondeti.cz** (anchor Nadace
  Sirius); RO = **kidshero.ro** (anchor KidsHero / Premier Energy).
- **MD (Moldova):** referenced only as a *future* possibility ("výhledově 3. země") — **not
  implemented**. Treat any MD-specific token values as absent/future, not current target scope.
- **Themeable (under `[data-theme="…"]`):** all of `color.*`, `font.*`, `radius.*`, `shadow.*`.
- **Fixed/shared (on `:root`):** `space.*`, `size.*`, `layout.*`.
- **Slots are roles, not shades:** a slot may coincide in value between tenants (e.g. `urgent`) or
  diverge sharply (e.g. `action`: CZ = brand red, RO = navy) — components never care which.
- **Runtime (web):** Storybook decorator sets `data-theme={tenant}` on the story container; a
  toolbar dropdown toggles it (`globalTypes.tenant`, values `cz`/`ro`, default `cz`).
- **Runtime (native):** imports `themes[name]` directly as a typed JS object, no build step.
- **Light/dark mode:** documented future *second axis* (`data-mode`), deliberately not scaffolded —
  only tenant is active today, light-only.
- **Brandmark is part of the theme, not a content prop:** CZ renders an in-repo composition (icon
  tile + wordmark, using `--radius-icon`/`--color-brand`/`--font-display*`); RO renders the live
  KidsHero logo, hotlinked from an external URL (no binary assets in repo). CSS switches which is
  visible by `data-theme`.

## 12. Open Questions (carried from evidence catalogue — unresolved, do not silently close)

1. **No real semver.** `packages/tokens/package.json` is pinned at `0.0.0` (private,
   workspace-internal). "tokens v0.2" exists only as a git commit-message / changelog milestone,
   not a machine-readable package version. Treat any "token version" reference in specs as a
   doc/model revision marker, not a package version, until tooled enforcement exists.
2. **Story-category set is not final.** The three categories in §3.3 (development, health,
   subsistence) are explicitly flagged `needs: @analyst` in the token model doc — they "cover the
   demo" only. The binding category list (and per-tenant color mapping) for the rebuild must be
   confirmed by BA/analyst work before the UX layer treats `color.category.*` as a closed set.
3. **RO logo hotlink fragility.** RO branding depends on a live external URL
   (`kidshero.ro/themes/custom/patron_ro/images/logo.svg`). This is an intentional demo decision (no
   binaries in repo), but is a fragility to flag for the rebuild — if that host changes, RO loses
   its logo with no local fallback.

## 13. Source index (rebuild repo, for traceability)

All paths under `/Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/`:

| Concern | File |
|---|---|
| Public API / barrel | `packages/tokens/src/index.ts` |
| Token values + interfaces + theming | `packages/tokens/src/themes.ts` |
| Token → CSS-var mapping (naming) | `packages/tokens/src/css.ts` |
| Slot role metadata | `packages/tokens/src/docs.ts` |
| CSS build (`:root` + `[data-theme]`) | `packages/tokens/build.ts` |
| Package identity | `packages/tokens/package.json` |
| Token model / intent | `docs/design/tokens.md` |
| Design-layer methodology | `docs/design/README.md` |
| Pipeline ADR (build mechanics) | `docs/architecture/adr/ADR0003-pipeline-design-tokenu.md` |
| Storybook tenant decorator + viewports | `packages/ui/.storybook/preview.tsx` |
| Webfont loading | `packages/ui/.storybook/preview-head.html` |
| Global reset | `packages/ui/src/global.css` |
| Sample consumer (var usage) | `packages/ui/src/components/Button/Button.module.css` |
| Brandmark (tenant logo) | `packages/ui/src/components/Brandmark/{Brandmark.tsx,Brandmark.module.css,Brandmark.contract.md}` |

Full extraction with rationale, per-decision citations, and the non-canonical tenant-theming
exploration HTML caveat: `_ar/evidence/design-system/tokens.md`.

---

*This document is a draft-tier reference (`_ar/spec-draft/`). It is cited by, not restated in,
UX-layer documents (`IA`, `WIRE`, `COMP`, `COPY`) per cross-layer discipline — those layers should
reference token/slot names from here rather than re-quoting hex/px values.*
