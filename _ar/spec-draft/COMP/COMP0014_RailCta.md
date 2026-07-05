---
doc_id: COMP0014
title: RailCta
canonical_layer: COMP
spec_type: component
modules: []
status: draft
references:
  - WIRE0002
  - EN0010
  - EN0013
  - UC0005
  - UC0009
  - DESIGN-component-index
  - DESIGN-tokens
  - COMP0001
---

# COMP0014 – RailCta

*(promoted from two `inline` secondary CTAs on `WIRE0002`'s donation sidebar; canonical `@patron/ui`
component: RailCta)*

---

## Design-system alignment (target)

> **STATE: TARGET — `@patron/ui` `RailCta` (Block).** This is the **authoritative contract** for
> this doc_id. It describes the **rebuild design system's** canonical component, per
> `DESIGN-component-index.md` row 11 and `_ar/evidence/design-system/components.md` §1 "RailCta". It
> sits at the same authority level as `it-zadani` (future/target), **not** current-state truth. Per
> the reconciliation mapping (`components.md` §2, §3 item 3), this is a **GAP→recon** case: no
> reconstructed COMP existed prior to this promotion — the two CTAs it unifies were left `inline` on
> `WIRE0002` (see "Current-state (observed)" below for what was actually seen).

### Purpose

`RailCta` is a lighter card that sits in the story-detail right rail, directly under `DonationBox`
(`COMP0010`), offering a secondary help path alongside the primary one-off donation: recurring
giving, or (CZ-only) voucher ("dobrošek") redemption. Per `components.md` §1 "RailCta" and §3 item 3,
it is the canonical unification of the two visually-inconsistent secondary CTAs that the
reconstruction observed inline on `WIRE0002` and explicitly declined to promote as one component.

### Props

| Prop | Type | Required | Default | Description |
|---|---|---|---|---|
| `title` | `string` | yes | — | Card heading (e.g. explaining the recurring-gift or voucher path). |
| `text` | `string` | yes | — | Explainer body copy. |
| `href` | `string` | yes | — | Destination link — external target opens in a new window with a safe `rel` (see Accessibility). |
| `ctaLabel` | `string` | no (default variant only) | — | Label for the outline CTA button in the **default** variant. |
| `promo` | `boolean` | no | `false` | Selects the **promo** variant (whole card becomes a link, accent tint). |
| `linkLabel` | `string` | no (promo variant only) | — | Link text used in the **promo** variant in place of a separate button. |

Exported type: `RailCtaProps` (per `components.md` §1).

### Variants

- **emphasis:** `default` (`promo=false`) | `promo` (`promo=true`)
  - `default` — renders as a `<div>` card: `title` + `text` explainer, plus a ghost/block `Button`
    (`COMP0001`, canonical `variant="ghost"`) rendered as a link (`href`) with `ctaLabel`. Intended
    use: the recurring-gift path.
  - `promo` — the **whole card** is a single `<a href>` with accent tint background; `linkLabel` +
    an `Icon`(`name="arrow"`) replace the separate button. Intended use: the CZ-only voucher
    ("dobrošek") path.

### States

- **default (idle):** static rendering per variant, as above.
- **hover / focus:** focus-visible ring reads `color.accent` (per `components.md` §1 "States");
  hover behavior beyond the focus ring is not itemized further in the extracted catalogue.
- **focused:** see hover/focus above — same ring contract on keyboard focus.
- **disabled:** `N/A` — not itemized in the canonical catalogue; `RailCta` is a link-shaped
  component, not a form control.
- **loading:** `N/A` — not itemized.
- **error:** `N/A` — not itemized.

### Events

`RailCta` emits no component-level callback events — it is a navigation component. Its only
"event" is native anchor navigation to `href` (default variant's inner `Button`-as-link, or the
promo variant's whole-card `<a>`).

### Accessibility (target)

- **ARIA role:** inherits native `<a>` (promo variant, whole card) or native `<button>`-as-`<a>`
  semantics (default variant's composed `Button`, per `COMP0001` target contract) — no custom ARIA
  role layered on top, per `components.md` §1 "A11y notes".
- **Keyboard navigation:** standard link/button tab-stop and Enter-to-activate; no bespoke keyboard
  handling documented.
- **Focus management:** focus-visible ring reads `color.accent` (shared focus-ring convention across
  the canonical library — same token as `Button`, `ShareRow`, `Input`).
- **Screen reader:** external destinations open in a new window using a "safe `rel`" (per
  `components.md` §1 "RailCta" — i.e. `rel="noopener noreferrer"`-class attribute; exact attribute
  value not itemized character-for-character in the source catalogue, `Uncertain` at that level of
  detail). No additional `aria-label` is documented beyond the visible `title`/`ctaLabel`/`linkLabel`
  text.

### Tenant (CZ/RO) behaviour

- **The `promo` variant (voucher / "dobrošek") is CZ-only.** Per `DESIGN-component-index.md` row 11
  and `components.md` §1 "RailCta" domain rule: this is a **per-tenant module, consumer-controlled**
  — i.e. the RO tenant simply does not render a promo-variant `RailCta` instance; it is not
  CSS-hidden via `data-theme`. This matches the `StoryDetail` page composition
  (`DESIGN-component-index.md` row "StoryDetail"): rail order is `DonationBox` → `RailCta`(recurring)
  → `RailCta`(promo, **CZ-only**) → `ShareRow`; the RO content fixture (`contentRo`) omits the promo
  instance entirely (per `components.md` §1 "StoryDetail" and §4 divergence note).
- The **default** (recurring) variant carries no tenant-specific props and is expected on both
  tenants.
- Token values for surface/border/text/muted/accent all remap per `data-theme="cz"|"ro"` per the
  shared multi-tenant model (`DESIGN-tokens.md` §11) — no component code forks either way.

### Token slots

Per `DESIGN-component-index.md` row 11 / `components.md` §1 "RailCta":

`--color-surface`, `--color-border`, `--radius-card`, `--space-md`, `--space-lg`, `--font-body`,
`--font-display` (+ `--font-display-weight`, `--font-display-tracking`), `--color-text`,
`--color-muted`, `--color-accent`.

All consumed via `var(--…)` in the component's colocated CSS module — no hex/px literals, per
`DESIGN-tokens.md` §10 convention. The composed `Button` (`COMP0001`, ghost/block) and `Icon`
(`name="arrow"`) sub-components carry their own additional token slots, inherited rather than
restated here (`Button`: `--radius-pill`, `--size-base`/`--size-lg`, `--space-sm`, `--color-action`,
`--color-on-brand`; `Icon`: none — uses `currentColor`).

### Dependencies / Composition

```
RailCta (canonical, target)
  ├─ default variant:
  │    └─ Button (COMP0001, variant="ghost", block=true) — rendered as a link via href
  └─ promo variant:
       └─ Icon (name="arrow") — composed inside the whole-card <a>
```

- Other COMPs: `COMP0001` Button (ghost, block — default variant only).
- Data entities: none directly typed — `title`/`text`/`ctaLabel`/`linkLabel` are display-ready
  strings per instance; the CTA's downstream intent (recurring gift vs. voucher redemption) is
  carried by the consumer's routing choice of `href`, not by a `RailCta`-owned entity prop.
- ACL: none evidenced in the canonical catalogue.
- External libraries: none evidenced.

### Source references

`DESIGN-component-index.md` row 11 (Index table) and §2 (doc_id assignment: RailCta → COMP0014);
full catalogue entry `_ar/evidence/design-system/components.md` §1 "RailCta" (Blocks) and mapping
row §2 "RailCta" (GAP→recon) and §3 item 3 (reconciliation priority); `StoryDetail` page composition
and per-tenant `contentCz`/`contentRo` fixture note in `components.md` §1 "StoryDetail" and §4.
Canonical library source root (not fetched into this repo, referenced by path only):
`/Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/packages/ui/src/components/RailCta/`.

---

## Current-state (observed)

> The section below documents Patronus's **current-state UI as observed in live-site screenshots**
> (`WIRE0002`). Nothing in this section is target design; it must not be read back into the
> "Design-system alignment (target)" section above. Per the reconciliation mapping
> (`components.md` §2), **no reconstructed COMP existed for this concept before this promotion** —
> the two elements unified here were both flagged `inline` on `WIRE0002`'s donation sidebar, and the
> reconstruction explicitly declined to promote them as one component due to unresolved visual-
> identity inconsistency (see `WIRE0002` Components Used, `COMP0001` Open Questions).

### What was observed

On the Story detail screen (`WIRE0002`, screen `S002`), the sticky-right donation sidebar contains,
below the primary progress/amount/CTA block, two secondary help-path elements — recorded in
`WIRE0002` Layout Zones ("Donation sidebar") and Components Used as separate `inline` rows, never as
one component:

| Observed element | `WIRE0002` description | Visual identity (as captured) |
|---|---|---|
| **Recurring block** | "Přeji si podporovat rozvoj a vzdělání pravidelně" + "Chci podporovat rozvoj a vzdělání" CTA | Secondary/**green** button — visually distinct from the primary filled-red "Přispět 🤝" CTA (`COMP0001`). |
| **Voucher block** | "Mám dobrošek" CTA + "Chcete věnovat dobrošek?" link | Secondary/**red** button with a ticket icon, plus a separate text link. |

Both blocks sit in the same sidebar column as the progress/amount/donate block and the share icon
row, per `WIRE0002`'s Layout Zones ASCII diagram (rows "recurring CTA" / "\"Mám dobrošek\" CTA"
directly below the primary "Přispět" CTA and above the share row).

### Why this was left inline in the reconstruction

`WIRE0002` Components Used explicitly recorded both as `inline`, not as a shared component, because:

- **Visual identity is inconsistent between the two.** One renders green, the other red with an
  icon — the reconstruction's evidence-gated discipline (per `rules-COMP.md`: "Create a COMP only
  when reuse is observable... do not invent a reusable component") would not merge two
  visually-divergent elements into a single shape from a single screen's evidence.
- **Only one screen (`WIRE0002`/`S002`) evidences either element** — the ≥2-screen reuse bar for
  COMP promotion (per `rules-COMP.md`) was not met by current-state evidence alone for either the
  recurring block or the voucher block individually.
- `COMP0001` (PrimaryButton)'s own Open Questions record the recurring CTA's "secondary/green
  button" identity as unresolved relative to the primary button contract — i.e. it was considered as
  a possible `COMP0001` variant, not as its own component, and left unresolved either way.

**This COMP's existence is therefore driven entirely by the target-side reconciliation** (per
`components.md` §3 item 3: "RailCta specifically reconciles the two secondary CTAs the reconstruction
refused to promote for visual-identity inconsistency — the redesign unifies them"), not by
current-state reuse evidence crossing the ≥2-screen bar on its own.

### Interactions (as observed, per `WIRE0002`)

- **Recurring CTA click** ("Chci podporovat rozvoj a vzdělání") — `WIRE0002` Interaction #4: Assumed
  to open the same or an equivalent donation modal with a recurring flag set (feeds `UC0005.2`); the
  modal's recurring-specific affordance (e.g. a toggle) was **not observed** in the captured modal
  screenshots — recorded as an open question in `WIRE0002` (`WIRE0002-Q2`), not resolved here.
- **Voucher CTA / link click** ("Mám dobrošek" / "Chcete věnovat dobrošek?") — `WIRE0002`
  Interaction #5: Assumed to open a voucher-code entry surface feeding `UC0009`; the **target
  surface itself was not captured** on this screen (IA `S005`/voucher entry, Uncertain) — recorded
  as an open question in `WIRE0002` (`WIRE0002-Q3`), not resolved here.
- Both bindings are Assumed/Probable, not Confirmed navigation targets, per `WIRE0002` Data Bindings
  (`EN0010` RecurringTransaction for the recurring intent; `EN0013` for the voucher entry feeding
  `UC0009`).

### Current-vs-target divergences (flagged, not resolved)

- **Two visually-inconsistent elements vs. one component with two variants.** Current-state shows a
  green secondary button (recurring) and a red ticket-icon button + separate link (voucher) as
  distinct, non-unified visual treatments. The canonical `RailCta` contract renders both through one
  shared card shape (`default` vs `promo` variant, differing only in emphasis/tint, not in
  fundamentally different colors/icons). This is a genuine current→target visual redesign, not a
  current-state fact — do not assume the live site already renders these consistently.
- **Voucher CTA's ticket icon has no confirmed canonical counterpart.** The canonical `promo`
  variant composes a generic `Icon`(`name="arrow"`), not a ticket glyph. Whether/how a ticket-style
  icon carries into the target `promo` variant is not evidenced in `components.md` — `Uncertain`.
  The canonical `IconName` union (`components.md` §0) does not list a ticket icon.
  `Hypothesis — Not evidenced in current sources` that the target simply drops the ticket icon in
  favor of the arrow-affordance pattern; not confirmed either way.
  `Uncertain — live rendering of the current promo/voucher path beyond the WIRE0002 screenshot is
  unknown; no further screens were captured for the voucher path (WIRE0002-Q3).`
- **Separate "Chcete věnovat dobrošek?" link vs. single whole-card link.** Current-state shows the
  voucher block as a button *plus* a separate text link ("Chcete věnovat dobrošek?"). The canonical
  `promo` variant collapses this to a single whole-card `<a>` with one `linkLabel`. Whether the two
  current-state affordances (button + link) point to the same destination or two different ones is
  **not confirmed** from the `WIRE0002` evidence — `Uncertain`, carried over from `WIRE0002`'s own
  unresolved `WIRE0002-Q3`.
- **CZ-only status is asserted only on the target side.** `WIRE0002` was captured against
  `patrondeti.cz` only (single-tenant reconstruction, per project scope) — the reconstruction has no
  RO-tenant screenshot evidence either confirming or denying that the voucher path is CZ-specific in
  the *current* live system. The "CZ-only, hidden in RO" rule recorded in the Design-system
  alignment section above is a **target-side domain rule** (`components.md`), not a current-state
  finding; treat it as `Hypothesis` when read against current-state RO behaviour specifically.
- **No confirmed `RailCta`-level hover/focus visual.** No hover/focus state was captured in the
  `WIRE0002` screenshots for either block — current-state hover/focus remains `Uncertain`, in
  contrast with the target contract's documented focus-ring behavior (accent ring) above.

### Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Recurring block exists, green secondary CTA | Confirmed | `WIRE0002` Layout Zones ("Donation sidebar" → recurring block); Components Used row "Recurring CTA" |
| Voucher block exists, red CTA + ticket icon + separate link | Confirmed | `WIRE0002` Layout Zones ("Donation sidebar" → voucher block); Components Used row "Voucher CTA" |
| Both left `inline`, not merged into one current-state COMP | Confirmed | `WIRE0002` Components Used table; `COMP0001` Open Questions (secondary-button variant not promoted) |
| Recurring CTA → `UC0005.2` recurring flag | Probable/Assumed | `WIRE0002` Interaction #4; Data Binding row "Recurring CTA intent" → `EN0010` |
| Voucher CTA → `UC0009` entry | Probable/Assumed | `WIRE0002` Interaction #5; Data Binding row "\"Mám dobrošek\" entry" → `EN0013`; target voucher surface itself not captured |
| Hover/focus current-state visual | Uncertain | not captured in any screenshot |
| CZ-only-ness as a *current-state* fact (vs. target rule) | Uncertain | no RO-tenant screenshot evidence in this reconstruction pass |
