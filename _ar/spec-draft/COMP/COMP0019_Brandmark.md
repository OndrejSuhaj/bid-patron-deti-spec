---
doc_id: COMP0019
title: Brandmark
canonical_layer: COMP
spec_type: component
modules: []
status: draft
design_source: /Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/packages/ui/src/components/Brandmark/
references:
  - COMP0002
  - COMP0003
  - COMP0020
  - COMP0001
  - WIRE0001
  - WIRE0002
  - WIRE0003
  - WIRE0006
  - WIRE0007
  - WIRE0009
  - WIRE0010
  - WIRE0012
  - WIRE0013
  - WIRE0014
  - WIRE0015
  - WIRE0019
  - WIRE0020
  - WIRE0021
  - WIRE0024
  - WIRE0025
---

# COMP0019 – Brandmark

> **Promotion note.** This component was left **inline** in the current-state reconstruction — the
> tenant logo was documented only as part of `COMP0002_GlobalHeader` / `COMP0003_GlobalFooter`
> chrome, never as its own reusable unit, because no second, independently-varying rendering was
> evidenced in static screenshots (per `rules-COMP.md` reuse-gate). It is promoted to a standalone
> COMP **now** because the rebuild's canonical `@patron/ui` library (`components/Brandmark/`) treats
> it as a first-class Atom, and `DESIGN-component-index.md` row 4 assigns it doc_id `COMP0019`. Per
> the project constitution's current-vs-target rule, this promotion is driven by the **target**
> canon, not by new current-state evidence — the "Current-state (observed)" part below is unchanged
> from what `COMP0002`/`COMP0003` already recorded; it is only now factored out into its own file.

## Purpose

Brandmark is the tenant/organisation logo used in global chrome (header, footer) to identify the
site and, where composed into a home link, act as the anchor for "return to homepage" navigation.
It is cross-module shared chrome, not scoped to any single feature module — every screen in the
Patronus current-state evidence set that shows the header or footer shows the logo.

- **Design-system alignment (target):** in `@patron/ui`, `Brandmark` is a canonical Atom
  (`packages/ui/src/components/Brandmark/`) explicitly modelled as **tenant-driven, not
  content-driven** — the logo identity itself is part of the active theme (`data-theme`), not a
  prop the consumer supplies. It is composed into `SiteHeader` (COMP0002 target alignment) and
  `SiteFooter` (COMP0003 target alignment) per `DESIGN-component-index.md` rows 4, 14, 15.
- **Current-state (observed):** in the live Patronus site, the logo is observed only as unstructured
  chrome content inside the header and footer — a wordmark reading "patron dětí" — never as an
  independently reused, separately-varying unit across two or more distinct non-header/footer
  contexts. This promotion does not add new current-state evidence beyond what `COMP0002`/`COMP0003`
  already captured; see the "Current-state (observed)" part below.

---

## Design-system alignment (target — @patron/ui + @patron/tokens)

> **STATE: TARGET.** Everything in this part describes the canonical `@patron/ui` **`Brandmark`**
> Atom (rebuild library, `packages/ui/src/components/Brandmark/`) per
> `_ar/spec-draft/DESIGN-component-index.md` row 4 and `_ar/evidence/design-system/components.md` §1
> "Brandmark — `components/Brandmark/`". This is the **authoritative contract** for the rebuild
> component. It is **not** current-state evidence and must not be read as a claim about how the
> observed Patronus logo behaves today — see "Current-state (observed)" below for that. Where the
> two disagree, the disagreement is recorded, not resolved.

### Contract summary

Tenant logo for header/footer. The **logo identity itself is theme-driven, not a prop**: both
tenant marks exist simultaneously in the DOM, and CSS (`[data-theme]`) picks which one renders.
CZ renders an in-repo composition — `Icon`(name="give") symbol + "patron dětí" wordmark; RO renders
the live KidsHero logo, hotlinked from an external `<img>` URL (no binary asset in repo). Logo/link
semantics (wrapping the mark in a home `<a>`) are owned by the **consumer** — `Brandmark` itself is
not a link (`_ar/evidence/design-system/components.md` §1; `DESIGN-component-index.md` row 4;
`DESIGN-tokens.md` §11).

### Props

| Name | Type | Required | Default | Description |
|---|---|---|---|---|
| `small` | `boolean` | no | `false` | Compact variant for footer placement (vs. default header size). |

Exported type: `BrandmarkProps`. No `className`/style-override prop is itemized in the extracted
catalogue for this component — `Uncertain` whether one exists beyond the documented `small` prop.

**No entity-typed props.** Brandmark carries no `ENxxxx`-referenced data — it is a pure
presentational/theme atom, not bound to a domain entity.

### Variants

- **size:** `default` (header) | `small` (footer, via `small` prop)
- **tenant mark:** `CZ` | `RO` — selected by `[data-theme]`, **not** a prop axis

Each value:
- `small=false` (default) — used in `SiteHeader` composition, full-size lockup.
- `small=true` — used in `SiteFooter` composition, compact lockup.
- CZ mark — in-repo composition: `Icon`(name="give") symbol + "patron dětí" wordmark, rendered with
  brand/typography tokens.
- RO mark — live KidsHero logo image, hotlinked from an external URL
  (`kidshero.ro/themes/custom/patron_ro/images/logo.svg` per `DESIGN-tokens.md` §11 Open Question 3);
  no local binary in the rebuild repo.

### States

#### idle
Default rendering — the active tenant's mark, at the size implied by the `small` prop. This is the
only state itemized in the extracted catalogue (`_ar/evidence/design-system/components.md` §1:
"**States:** default, tenant-switch.").

#### hover
`Uncertain — not itemized in the extracted canonical catalogue for Brandmark itself.` If a consumer
wraps `Brandmark` in a link (per `SiteHeader`'s home `<a>` composition), any hover treatment belongs
to that consumer link, not to `Brandmark`.

#### focused
`Uncertain — not itemized.` Same reasoning as hover: focus ring, if any, would be owned by the
consumer's wrapping `<a>` (which reads `color.accent` for focus rings elsewhere in the library per
`components.md` conventions), not by `Brandmark` itself.

#### disabled
`N/A` — Brandmark is a non-interactive presentational atom; it has no disabled state of its own.

#### loading
`N/A` — not itemized; the RO variant is an `<img>` hotlink, so a network-loading/broken-image state
is plausible but **not documented** in the canonical catalogue. Flag as an unresolved gap, not an
assumed behavior.

#### error
`N/A` in the canonical catalogue. See RO hotlink fragility note below (Open Question, not a
documented error state).

### Events

No events emitted. Brandmark is a leaf, non-interactive presentational atom; click/navigation
behavior (e.g. "go to homepage") is entirely owned by whatever consumer wraps it in an `<a>`
(`SiteHeader`'s home link per its own contract), not by Brandmark itself.

### Accessibility (target)

- **ARIA role:** none specified for Brandmark itself — inherits native semantics from whatever
  markup it renders (an image/SVG-plus-text composition). No `role="img"` or `aria-label` is
  itemized in the extracted catalogue for the component in isolation.
- **Logo/link semantics owned by consumer:** per `DESIGN-component-index.md` row 4, "Logo/link
  semantics owned by consumer (SiteHeader wraps it in the home `<a>`)" — Brandmark does not itself
  provide an accessible name for "go home"; that is the wrapping `<a>`'s responsibility (e.g. an
  `aria-label` on the link, not on the mark).
- **Keyboard navigation:** `N/A` for Brandmark in isolation (non-interactive); when wrapped in a
  consumer link, standard link tab/Enter semantics apply to that wrapper, not documented here.
- **Focus management:** `N/A` for Brandmark itself; see consumer-link note above.
- **Screen reader:** `Uncertain — not itemized.` Whether the CZ composed `Icon`(give) glyph is
  exposed with an accessible name, or is purely decorative with the wordmark text carrying the
  accessible name, is not specified in the extracted catalogue. Flag as an open reconciliation
  question for implementation, not assumed either way.
- Accessibility is **enforced by tooling** library-wide (`.storybook/main.ts` loads
  `@storybook/addon-a11y`, `preview.tsx` sets `a11y: { test: "error" }`), but this component's own
  contract does not itemize component-specific ARIA decisions beyond the "consumer owns link
  semantics" note above.

### Usage Constraints

- Use when: rendering the site/tenant identity in global chrome (header, footer).
- Do not use when: a decorative-only icon is needed unrelated to brand/tenant identity — use `Icon`
  (COMP0020) directly instead.
- Cardinality: one per chrome region (one in header, one in footer per screen); not designed for
  repeated/list use.
- Placement: standalone atom, typically the first child inside `SiteHeader`'s home `<a>` or
  `SiteFooter`'s brand block — never inside a form or overlay context per current catalogue evidence.

### Dependencies

- **Other COMPs (composition):** `Icon` (`COMP0020`) — composed for the CZ symbol,
  `Icon`(name="give").
- **Data entities:** none — no `ENxxxx`-typed props.
- **ACL:** none — no role-gated visibility documented; Brandmark renders unconditionally in chrome.
- **External libraries:** none itemized beyond the RO tenant's live external image hotlink
  (`kidshero.ro/.../logo.svg`) — not a library dependency, but a runtime network dependency specific
  to the RO tenant mark.
- **Consumers (composition-in, per `DESIGN-component-index.md`):** `SiteHeader` (`COMP0002` target
  alignment, default size, wrapped in home `<a>`), `SiteFooter` (`COMP0003` target alignment,
  `small` variant).

### Composition

Brandmark composes `Icon` (COMP0020) for its CZ symbol only; it has no other sub-component
composition:

```
Brandmark
  └─ Icon (name="give")   — CZ tenant mark symbol only; RO tenant mark is a plain <img> hotlink,
                             no Icon composition
```

Consumers composing Brandmark (reverse direction, for orientation only — owned by those COMPs'
own contracts, not restated here):

```
SiteHeader                          SiteFooter
  └─ Brandmark (default, in <a>)      └─ Brandmark (small)
```

### Token slots

Per `_ar/evidence/design-system/components.md` §1 and `DESIGN-component-index.md` row 4:

`var(--radius-icon)`, `var(--color-brand)`, `var(--color-on-brand)`, `var(--font-display)`
(+ weight/tracking via `var(--font-display-weight)` / `var(--font-display-tracking)`).

All color/font/radius slots are tenant-bound under `[data-theme="cz"]` / `[data-theme="ro"]` per
`DESIGN-tokens.md` §11 — Brandmark takes no tenant prop; the CZ-vs-RO mark selection happens purely
through the token/CSS-display mechanism described in "Tenant (CZ/RO) behaviour" below, not through
component logic.

### Tenant (CZ/RO) behaviour

- **Brandmark is part of the theme, not a content prop.** Per `DESIGN-tokens.md` §11: "CZ renders
  an in-repo composition (icon tile + wordmark, using `--radius-icon`/`--color-brand`/
  `--font-display*`); RO renders the live KidsHero logo, hotlinked from an external URL (no binary
  assets in repo). CSS switches which is visible by `data-theme`."
- **Both tenant marks coexist in the DOM simultaneously** — `data-theme` CSS picks the active one
  (`display` toggle), mirroring the mechanism used for `Icon`'s line/filled glyph-set switch
  (`DESIGN-component-index.md` row 3).
- **CZ mark:** "give" symbol (via composed `Icon`) + "patron dětí" wordmark.
- **RO mark:** live KidsHero logo image (`kidshero.ro/themes/custom/patron_ro/images/logo.svg`),
  hotlinked — an intentional demo decision (no binaries checked into the rebuild repo), flagged as
  an **Open Question / fragility** in `DESIGN-tokens.md` §12 item 3: "RO logo hotlink fragility... if
  that host changes, RO loses its logo with no local fallback." Carried here unresolved, not
  silently closed.
- **MD (Moldova):** not implemented in the tenant model at all (`DESIGN-tokens.md` §11) — no third
  Brandmark tenant mark exists; treat as absent/future, not current target scope.

---

## Current-state (observed)

> **STATE: CURRENT.** This part restates only what the pre-existing current-state reconstruction
> (`COMP0002_GlobalHeader.md`, `COMP0003_GlobalFooter.md`, and the WIRE screens they were derived
> from) already recorded about the logo, now factored into its own file per the promotion. **No new
> current-state evidence was gathered for this promotion** — it is a re-filing of already-captured
> observations, not a fresh reconstruction pass. Where the target contract above resolves an open
> question, that resolution applies to the **target only** and does not retroactively change what
> was observed.

### What was observed

Across the CZ live-site screenshot evidence (`_ar/prtsc/screencapture-patrondeti-cz-*.png`,
cross-referenced via `_ar/evidence/ui/ui-observed-areas.md` and the WIRE Components-Used tables),
the logo/wordmark appears as the leading element of the global header on essentially every screen,
and as part of the footer brand block:

- **Header placement:** leading element of the global nav row, rendered as the text "patron dětí"
  (per WIRE header descriptions: WIRE0001 "Header — logo 'patron dětí'", WIRE0002/0003/0006/0007/
  0009/0010/0012/0013/0014/0015/0019/0024/0025 — consistent "logo 'patron dětí'" wording across all
  evidenced screens). No distinct icon-tile/symbol element separate from the wordmark was itemized
  as independently confirmed in the reconstruction; `COMP0002` treated the whole lockup as
  header chrome, not a separately reconstructed sub-component.
- **Footer placement:** part of the brand/tagline block in the global footer (`COMP0003`), alongside
  social links — again treated as unstructured footer content, not a separately reconstructed
  component, in the original pass.
- **Home-link behavior:** across multiple WIRE screens the logo is implied to be clickable/act as a
  "return to homepage" affordance (e.g. WIRE0019 "logo (→ S001)"; WIRE0011's escape-route note
  "clicking the header logo/nav"; WIRE0025 "logo → nav links" escape route), but the underlying DOM
  structure (whether the logo itself is the `<a>`, or is wrapped by one) was **not** independently
  confirmed from static screenshots — `Uncertain`.

### Tenant scope of the observation

All current-state screenshot evidence in this reconstruction is **CZ-only** (`patrondeti.cz` live
site). The RO tenant mark (KidsHero logo) described in the target contract above is **not**
evidenced in the current-state screenshot set at all — its existence, appearance, and behavior on
a live RO deployment are `Uncertain — not evidenced` from this reconstruction's sources. The
"CZ = wordmark, RO = KidsHero hotlink" distinction is a **target-side** fact only
(`DESIGN-tokens.md` §11), not something the current-state observation independently confirms or
denies for RO.

### Divergence from target / open reconciliation points (record, do not "correct")

- **Reuse threshold.** The original reconstruction did not promote the logo to its own COMP because
  no second, independently-varying rendering context was evidenced (per `rules-COMP.md`'s
  two-or-more-screens reuse gate) — it was seen only inside header and footer chrome, both already
  captured whole as `COMP0002`/`COMP0003`. This promotion happens now **because the target canon
  requires it**, not because new current-state reuse evidence emerged. The gate itself was correctly
  applied at the time; this file does not retroactively claim stronger current-state evidence than
  existed.
- **Symbol vs. wordmark structure.** The target CZ mark is explicitly a composition of an `Icon`
  (name="give") symbol *plus* a wordmark. The current-state WIRE evidence describes the observed
  header/footer element only as "logo 'patron dětí'" (text-level description) — whether the live
  site's mark is (a) wordmark-only, (b) symbol+wordmark as the target models it, or (c) a raster/SVG
  logo image with no internal icon/text split, is **`Uncertain`** from static screenshots alone. Do
  not assume the target's symbol+wordmark composition describes the current live rendering.
- **Home-link ownership.** The target contract is explicit that link semantics are the *consumer's*
  responsibility (Brandmark itself is not a link; `SiteHeader` wraps it). The current-state evidence
  is consistent with the logo being clickable-to-home but does not confirm whether that behavior
  lives on the mark itself or a wrapping element — `Uncertain`, and the target's "consumer owns the
  link" design is not evidence either way for the current implementation.
- **Footer `small` sizing.** The target's explicit `small` prop/variant for footer placement has no
  independently confirmed current-state counterpart — the current-state footer logo may or may not
  render smaller than the header logo; this was not measured/confirmed in the original reconstruction
  (`COMP0003` treated it as part of unstructured footer content). `Uncertain`.
- **RO tenant existence.** As noted above, no current-state evidence exists for an RO-tenant
  Patronus deployment at all in this reconstruction's sources; the CZ/RO tenant split is a
  target-only concept from this file's perspective.

---

## Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Target contract — props, variants, states, tokens, tenant mechanism | Confirmed (for TARGET, not current-state) | `_ar/evidence/design-system/components.md` §1 "Brandmark — `components/Brandmark/`"; `_ar/spec-draft/DESIGN-component-index.md` row 4; `_ar/spec-draft/DESIGN-tokens.md` §11, §12 item 3, §13 |
| Current-state header/footer placement of the logo wordmark | Confirmed (presence, wording) | `_ar/spec-draft/WIRE/WIRE0001_HomepageStoryCatalogue.md` L45, L82; `WIRE0002_StoryDetailAndDonationModal.md` L53; `WIRE0003_ThankYouPaymentSuccess.md` L45, L67; `WIRE0006`–`WIRE0025` header/footer rows (logo "patron dětí" wording repeated across all evidenced screens); `_ar/spec-draft/COMP/COMP0002_GlobalHeader.md`; `_ar/spec-draft/COMP/COMP0003_GlobalFooter.md` |
| Current-state internal structure (symbol+wordmark vs. wordmark-only) | Uncertain — not evidenced | No DOM/zoomed evidence available; static screenshot description level only |
| Current-state RO tenant mark existence/appearance | Uncertain — not evidenced | Current-state evidence set is CZ-only (`patrondeti.cz`); no RO screenshots in this reconstruction |
| Home-link ownership (mark itself vs. wrapping element) | Uncertain — not evidenced | WIRE escape-route mentions (`WIRE0011`, `WIRE0019`, `WIRE0025`) describe behavior, not DOM structure |
| Accessible name / screen-reader behavior (target or current) | Uncertain | Not itemized in `components.md` for Brandmark specifically; current-state a11y uniformly `Uncertain` per reconstruction convention |
