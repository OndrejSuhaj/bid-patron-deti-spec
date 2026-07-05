---
doc_id: COMP0010
title: DonationBox
canonical_layer: COMP
spec_type: component
modules: []
status: draft
design_source: /Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/packages/ui/src/components/DonationBox/
references:
  - WIRE0002
  - EN0004
  - EN0009
  - EN0010
  - EN0013
  - UC0005
  - UC0009
  - UC0011
  - BR-CampaignStoryLifecycle
  - BR-PaymentAndMoneyIntegrity
  - BR-RecurringDonationPolicy
  - BR-VoucherPolicy
  - COMP0001
  - COMP0006
  - COMP0016
  - COMP0017
  - COMP0021
  - COMP0020
  - DESIGN-tokens
  - DESIGN-component-index
---

# COMP0010 – DonationBox

> **Discipline note.** This document promotes the **canonical `@patron/ui` component** `DonationBox`
> (the `bid-patron-deti` **rebuild/target** design system) to a COMP doc, per
> `DESIGN-component-index.md` row 13 and its doc_id assignment table (§2). It is split into two
> clearly separated parts:
>
> - **"Design-system alignment (target)"** — the authoritative canonical contract (props, variants,
>   states, tokens, a11y, tenant behavior), sourced from
>   `packages/ui/src/components/DonationBox/{DonationBox.tsx, DonationBox.module.css,
>   DonationBox.contract.md}`. This is **TARGET state**, not current-state fact.
> - **"Current-state (observed)"** — where this capability appears **today** on the live Patronus
>   site, per `WIRE0002` (screenshot-evidenced), and how it diverges from the target contract.
>
> Per the project constitution's current-vs-target rule, the two are **not merged**. The canonical
> contract is not used to "correct" the current-state observation, and the current-state observation
> is not used to water down the canonical contract. Where they diverge, both are recorded (see
> "Current-vs-target divergence" below).

---

## Design-system alignment (target)

> Source: `packages/ui/src/components/DonationBox/DonationBox.tsx`,
> `DonationBox.module.css`, `DonationBox.contract.md`; catalogued in
> `_ar/evidence/design-system/components.md` ("Blocks → DonationBox") and
> `_ar/spec-draft/DESIGN-component-index.md` row 13. Layer: **Block**. Storybook stories: `Probíhá`,
> `Naléhavé`, `DoplatitZbytek`, `Vybráno`.

### Purpose (target)

The primary conversion block of the story-detail page composition (`StoryDetail`, sticky right
rail). Shows how much is missing and by when, and lets the donor contribute in a single decision.
In the `funded` state the form disappears and the block becomes a thank-you with the next step
(delivery / patron confirmation). **Contract scope explicitly ends at `onDonate(amount)`** — the
donation modal (email, consents, mock payment) is named in the contract itself as a separate future
block ("Mimo scope"), not part of this component.

### Props / Inputs (target contract)

Source: exported `DonationBoxProps` (`DonationBox.tsx`).

| Name | Type | Required | Default | Description |
|---|---|---|---|---|
| `state` | `CollectionState` (`"live" \| "urgent" \| "funded"`) | no | `"live"` | Drives the `TimeLeftPill` mode and swaps the whole form for the funded thank-you. |
| `timeLeftLabel` | `string` | yes | — | Display-ready remaining-time text ("Zbývá měsíc" / "Zbývají 3 dny"); passed straight to `TimeLeftPill` (`COMP0017`). |
| `missingAmount` | `string` | yes | — | Display-ready missing-amount headline (e.g. "329 000 Kč"). Component does not format currency. |
| `missingCaption` | `string` | yes | — | Caption under `missingAmount` (e.g. "ještě chybí"). |
| `goalCaption` | `string` | yes | — | Caption before the goal figure (e.g. "cíl"). |
| `goalAmount` | `string` | yes | — | Display-ready goal/target amount (e.g. "439 000 Kč"). |
| `progressPct` | `number` (0–100) | yes | — | Passed to `ProgressBar` (`COMP0016`); clamping/rounding is `ProgressBar`'s responsibility, not this component's. |
| `donorsNote` | `string` | no | — | Optional note under the meter (e.g. "přispělo 41 dárců"). |
| `presets` | `DonationPreset[]` (`{label: string, amount: number}`) | yes | — | Fixed clean-amount presets (contract: e.g. 500/1000/2000), rendered as a 2×2 grid of selectable buttons. |
| `defaultPresetIndex` | `number` | no | `1` | Index into `presets` selected on mount (drives initial `aria-pressed`). |
| `customLabel` | `string` | yes | — | Label for the "Jiná" (custom amount) toggle button. |
| `currencyLabel` | `string` | yes | — | Currency suffix shown beside the custom-amount input (e.g. "Kč"). |
| `customInputLabel` | `string` | yes | — | `aria-label` for both the preset button-group (`role="group"`) and the custom numeric input. |
| `restFill` | `{label: string, amount: number}` | no | — | Quick-fill affordance ("Doplatit zbývajících 900") shown only under the custom-amount panel; clicking fills the custom input with `restFill.amount` and does **not** move focus. |
| `ctaLabel` | `string` | yes | — | Primary CTA label (e.g. "Přispět"). |
| `voucherLabel` | `string` | no | — | Label for the voucher-redemption link under the CTA. **CZ-only per-tenant** — consumer-controlled (omit the prop for RO), not CSS-hidden. |
| `successTitle` | `string` | no | — | Heading shown in the `funded` state. |
| `successMessage` | `ReactNode` | no | — | Body copy shown in the `funded` state; accepts rich content (e.g. bolded supplier name). |
| `onDonate` | `(amount: number) => void` | no | — | Fired on primary CTA click with the **currently selected** amount (preset value, or the parsed custom-input value if "Jiná" is open). Contract boundary — nothing beyond this call is this component's concern. |

Exported types: `DonationBoxProps`, `DonationPreset`, `CollectionState`.

### Variants (target)

- **state = live** — full form, calm/neutral `TimeLeftPill`.
- **state = urgent** — `TimeLeftPill` switches to a full alert-badge (`color.urgent` / `color.onUrgent`) with a gentle pulse; form is otherwise identical to `live`.
- **state = funded** — the entire form (figures, presets, custom input, CTA, voucher link) is replaced by a success block: check icon on a `color.success` tile, `successTitle`, `successMessage`.

No `size` axis; the component is single-size (fills its rail-column width).

### States (target contract)

#### idle / default
Renders with the preset at `defaultPresetIndex` marked `aria-pressed="true"` (highlighted with an
outline + soft tint in `color.action`).

#### preset selection
Clicking a preset button (or the "Jiná" toggle) updates `aria-pressed` on the button group; only one
of `presets.length + 1` buttons ("Jiná" counts as one) is pressed at a time. This is local component
state (`useState`), not propagated outward except through the eventual `onDonate` amount.

#### "Jiná" (custom) open
Selecting the custom toggle reveals a numeric `Input` (`COMP0021`, `type="number"`, `min={1}`) with a
currency suffix, and — only when `restFill` is supplied — a quick-fill text button beneath it.

#### hover / focus
Preset/toggle buttons and the CTA read the shared focus-visible ring (`color.accent`); all actions
are keyboard-operable (native `<button>` elements).

#### reduced motion
The urgent `TimeLeftPill`'s pulse animation is disabled under `prefers-reduced-motion` (inherited
from `TimeLeftPill`, `COMP0017`).

#### disabled / loading / error
`N/A` in the canonical contract — not modeled. No disabled, loading, or error rendering exists in
`DonationBox.tsx`; a failed/pending `onDonate` call is entirely the caller's concern, outside this
component's scope.

### Events (target)

| Event | Payload | Trigger | Notes |
|---|---|---|---|
| `onDonate` | `amount: number` | click on the primary CTA (`Button`, primary/block, icon `give`) | Amount = selected preset's `amount`, or `Number(customValue) \|\| 0` if "Jiná" is open. No validation beyond `Number()` coercion is performed inside the component. |

No other events are emitted; preset selection and "Jiná" toggling are internal state only, not
exposed as callbacks.

### Accessibility (target contract)

- **ARIA role:** preset/"Jiná" button group wraps in `role="group"` with `aria-label={customInputLabel}` (contract explicitly favors this over `<fieldset>` "bez jeho stylové zátěže" — lighter than fieldset, without its styling baggage).
- **Selection state:** each preset/toggle button carries `aria-pressed` reflecting selection.
- **Custom input:** carries `aria-label={customInputLabel}`; visible focus is preserved.
- **Progress bar:** `role="progressbar"` + `aria-valuenow/min/max`, delegated to and owned by `ProgressBar` (`COMP0016`), not re-declared here.
- **Keyboard:** all actions (preset select, "Jiná" toggle, quick-fill, CTA) are native `<button>` elements — fully keyboard-operable with no custom key handling.
- **Acceptance criteria (from `DonationBox.contract.md`):** tenant switch CZ↔RO re-skins with no code change (incl. urgent/success state colors); `state="urgent"` swaps the time pill to alert-badge and `prefers-reduced-motion` disables its pulse; `state="funded"` hides the whole form and shows the thank-you; quick-fill pre-fills the "Jiná" field and focus remains in the field; `onDonate` receives exactly the selected amount (preset or custom).

### Token slots (target)

Per `DonationBox.module.css`, cross-checked against `_ar/spec-draft/DESIGN-tokens.md` §10 CSS
custom-property naming:

- **Surface / structure:** `var(--color-surface)`, `var(--color-border)`, `var(--radius-card)`, `var(--shadow-card)`.
- **Spacing:** `var(--space-xs)`, `var(--space-sm)`, `var(--space-md)`, `var(--space-lg)`.
- **Typography:** `var(--font-body)`, `var(--font-display)`, `var(--font-display-weight)`, `var(--font-display-tracking)`.
- **Color — figures/text:** `var(--color-brand-strong)` (missing-amount headline), `var(--color-muted)`, `var(--color-text)`.
- **Color — preset buttons:** `var(--color-text)`, `var(--color-border)` (idle); `var(--color-action)` + `color-mix(in srgb, var(--color-action) 8%, var(--color-surface))` (pressed); `var(--color-accent)` (focus-visible outline).
- **Color — custom/quick-fill:** `var(--color-muted)` (currency suffix), `var(--color-action)` (quick-fill link).
- **Color — funded/success block:** `var(--color-success)` (icon tile background), `var(--color-on-success)` (icon), `var(--radius-icon)` (icon tile shape — circle CZ / squircle RO), `var(--color-text)` / `var(--color-muted)` (success copy).
- **Control shape:** `var(--radius-control)` (preset/custom-input radius, inherited by `Input`/preset buttons).

All values resolve per-tenant via `[data-theme="cz"|"ro"]` — the component itself never reads a hex
or px literal for a token-owned value (per `_ar/evidence/design-system/design-canon.md` principle
2, "components know only slots, never values").

### Tenant behavior (target)

- **Theme-neutral structurally** — no CZ/RO branching in `DonationBox.tsx` itself; all color/radius/
  shadow/font differences resolve through the `[data-theme]`-scoped token values (`DESIGN-tokens.md`
  §3, §6, §7), consistent with the library's single-axis slot-based theming model.
- **`voucherLabel` is CZ-only** — per `DESIGN-component-index.md` row 13 and `components.md`
  "Domain rules": the prop is consumer-controlled (the RO fixture simply omits it), **not** hidden by
  CSS/`data-theme`. This mirrors the sibling `RailCta` (`COMP0014`) promo variant, which is likewise
  CZ-only/consumer-gated.
- Per `_fixtures.tsx` (StoryDetail page composition), RO's donation rail omits the voucher path
  entirely; no MD (Moldova) tenant exists in the canonical library today (`DESIGN-tokens.md` §11 —
  MD is future-only, not implemented).

### Composition (target)

```
DonationBox
  ├─ TimeLeftPill (COMP0017)          — timeLeftLabel, urgent = state==="urgent"
  ├─ figures block (missingAmount / missingCaption / goalCaption / goalAmount) — inline, not a sub-COMP
  ├─ ProgressBar (COMP0016)           — progressPct
  ├─ donorsNote (optional)            — inline text
  ├─ preset button group (role="group") — presets[] + "Jiná" toggle — inline buttons, not COMP0001 Button
  ├─ Input (COMP0021)                 — only when "Jiná" is open; type="number", min=1
  ├─ restFill quick-fill button       — inline, conditional on restFill prop
  ├─ Button (COMP0001), variant=primary, block — iconBefore = Icon(name="give") (COMP0020)
  └─ voucherLabel link (optional, CZ-only) — inline <a>, not a sub-COMP

DonationBox (state="funded")
  ├─ Icon (COMP0020), name="check", on a color.success tile
  ├─ successTitle
  └─ successMessage
```

Note: the preset buttons themselves are **plain `<button>` elements styled locally**
(`.amt` class in `DonationBox.module.css`), not instances of `Button`/`COMP0001` — only the primary
CTA composes `Button`. This is a deliberate distinction in the source, not an omission.

### Dependencies (target)

- **Other COMPs (composition):** `COMP0017` TimeLeftPill, `COMP0016` ProgressBar, `COMP0021` Input,
  `COMP0001` Button (primary/block variant), `COMP0020` Icon (`check`, `give`).
- **Sibling target Blocks (same rail, not composed by DonationBox itself):** `COMP0014` RailCta
  (recurring / promo cards below the box), `COMP0015` ShareRow, `COMP0013` PledgeStrip
  (full-width, appears in every `DonationBox` state per the `StoryDetail` page composition).
- **Data entities (current-state domain equivalents, for traceability — not a target-layer
  dependency):** `EN0004` Campaign (progress/target/deadline figures), `EN0009` Transaction (the
  amount handed to `onDonate` ultimately becomes `Transaction.amount` downstream, per `UC0005` step
  10 — current-state binding, see below), `EN0010` RecurringTransaction, `EN0013` Voucher.
- **ACL:** none evidenced in the canonical contract.
- **External libraries:** none evidenced (`useId`, `useState` from React only).

---

## Current-state (observed)

> Source: `WIRE0002_StoryDetailAndDonationModal.md` (screenshot-evidenced current-state
> reconstruction of the live `patrondeti.cz` story-detail page). **This is the CURRENT-STATE
> reconstruction — not the target contract above.** Per `DESIGN-component-index.md` §3/row 13 note
> and `_ar/evidence/design-system/components.md` §2 mapping table, this is classified
> **GAP→recon (major)** — "the single biggest gap" between canonical library and reconstructed UX.

### Where it appears today

On the live story-detail page, there is **no single reconstructed component** matching this
capability. `WIRE0002`'s "Components Used" table records the donation-sidebar surface as a set of
**separate inline rows**, not one block:

- **Progress block** — "Chybí 1 600 Kč" + progress bar + "Zbývá měsíc" / "Cílová částka 1 600 Kč"
  (`inline`, `WIRE0002` Components Used — flagged Uncertain whether it shares a component with
  `COMP0008` StoryCard's own progress figures; not confirmed identical).
- **Amount input** ("Chci darovat", Kč, prefilled `50`) — `inline`, numeric field.
- **Primary donate CTA** ("Přispět 🤝") — mapped to **`COMP0001`** (Primary Button), icon=🤝. This is
  the one sub-element of the current-state donation sidebar that *was* promoted to a COMP.
- **Recurring CTA** ("Chci podporovat rozvoj a vzdělání pravidelně") — `inline`, "secondary/green
  button"; visual identity vs. `COMP0001` left Uncertain in `WIRE0002`.
- **Voucher CTA** ("Mám dobrošek") — `inline`, "secondary/red button, ticket icon"; entry point into
  `UC0009`, target screen not captured (Uncertain).
- **Share row** — `inline`, icon row (Facebook/X/Instagram/LinkedIn/WhatsApp/Messenger).

**Current-state = donation modal, not this box.** Critically, on the live site the primary CTA
("Přispět 🤝") does **not** call an `onDonate(amount)` handler directly the way the target
`DonationBox` contract does. It **opens a separate overlay** — the "Chystáte se přispět" donation
modal — which additionally collects e-mail, phone, jméno/příjmení, and two consent checkboxes
before handing off to the payment gateway (`S-EXT1`, Comgate). Per `WIRE0002` Interactions #2:
"click 'Přispět 🤝' (either sidebar instance) → modal overlay opens pre-filled with the amount typed
in the triggering 'Chci darovat' field ... next: modal `default` state." The modal itself is
reconstructed separately (its consent checkboxes map to `COMP0006`); it is **explicitly out of
scope** for this COMP doc, exactly mirroring the target contract's own "Mimo scope" boundary — but
for a different reason: the target defers the modal as *unbuilt future work*, whereas the
current-state modal is *already live and captured*, just not part of the amount-selection surface
this COMP describes.

### Observed current-state behavior (screenshot-evidenced)

- **Duplicate sidebar.** The donation sidebar (progress + CTAs + share row) is captured **twice** in
  the full-page screenshot — once beside the hero photo, once lower beside the body text
  (`WIRE0002` Layout Zones, Open Question WIRE0002-Q1). `WIRE0002` records this as "not resolved by
  an ACL/BR condition — likely a template/layout artifact of the two-column reflow," not a
  deliberate two-block feature. The target `DonationBox` contract has **no duplicate-rendering
  concept** at all — this divergence may be explained by the target's single-block model (one
  `DonationBox`, positioned once in a sticky rail) rather than the current template's apparent
  double-render, but this is `Hypothesis — Not evidenced in current sources`, not confirmed.
- **Amount entry.** Current-state shows a numeric input prefilled with `50` (Kč) directly in the
  sidebar ("Chci darovat"), with **no fixed preset buttons observed** — no 2×2 grid of clean amounts
  comparable to the target's `presets` prop. Whether the live implementation offers preset amounts
  anywhere is `Uncertain` — not visible in the captured screenshots.
- **Progress figures.** "Chybí 1 600 Kč" + progress bar + "Zbývá měsíc" / "Cílová částka 1 600 Kč" is
  visually close to the target's figures block + `TimeLeftPill` + `ProgressBar` composition, but
  `WIRE0002` explicitly leaves the reuse question open (shared with `COMP0008`'s card-internal
  progress, or independent) rather than asserting identity.
- **Urgent state.** No screenshot evidence of an urgent/alert-badge rendering of the time-remaining
  text was captured for this screen; `WIRE0002` records only the `default` state as Confirmed.
  Whether the live site has an urgent visual treatment analogous to the target's `state="urgent"`
  is `Uncertain — not evidenced`.
- **Funded state.** No screenshot evidence of a "fully funded" / thank-you rendering replacing the
  sidebar form was captured. `WIRE0002` States → `empty` records this gap explicitly, citing
  `UC0005` AF2 ("Campaign missing or already fully funded") as a business rule that exists, without
  a corresponding captured UI treatment. `Uncertain — not evidenced`.
- **Recurring / voucher entry.** Both exist today as **separate inline CTAs** beside the donation
  sidebar (not sub-states of one box) — "Chci podporovat ... pravidelně" (green) and "Mám dobrošek"
  (red, ticket icon). The target contract has no `voucherLabel` sub-affordance rendered inline in
  quite the same way (target: a plain text link under the CTA, not a red ticket-icon button) — this
  is a visual-identity divergence, not just a naming one.
- **Accessibility.** Uniformly `Uncertain` for the current state — `WIRE0002` Accessibility Notes
  record tab order, modal focus-trap behavior, and landmarks as all unobserved/unverifiable from
  static screenshots. This contrasts with the target contract's explicit `role="group"` /
  `aria-pressed` / focus-ring decisions (see "Accessibility (target contract)" above) — the
  a11y richness in the target section above must **not** be read back onto the current-state
  implementation.

### Current-vs-target divergence (recorded, not resolved)

| Aspect | Current-state (observed, `WIRE0002`) | Target contract (`DonationBox`, canonical) | Status |
|---|---|---|---|
| Structural model | ~6 separate inline rows/CTAs, apparently duplicated in layout | One block, 3 states (`live`/`urgent`/`funded`) | Divergence — target likely explains/resolves the current-state duplication, but this is `Hypothesis`, not confirmed |
| Amount selection | Single numeric input, prefilled `50`, no visible presets | Fixed clean-amount presets (2×2 grid) + "Jiná" custom toggle | Divergence — presets are not evidenced as currently live |
| Donate action | Opens a separate donation modal (email/consent/payment) before any submission | `onDonate(amount)` — contract explicitly stops there; modal is future/out-of-scope for this component | Both sides agree the modal is a separate concern, but for different reasons (already-live vs. not-yet-built) |
| Recurring / voucher | Two separate, visually inconsistent CTA buttons (green / red-ticket) beside the box | `voucherLabel` is a plain link under the CTA (CZ-only prop); recurring lives in a sibling `RailCta` (`COMP0014`), not inside `DonationBox` | Divergence — current-state visual identity of these two paths is Uncertain vs. `COMP0001`; target unifies/relocates them |
| Funded / urgent visual states | Not captured in any screenshot | Explicit `state` prop with dedicated renderings | Gap — current-state existence of these renderings is `Uncertain`, not confirmed absent |
| Accessibility | `Uncertain` throughout (no DOM/recording evidence) | Explicit ARIA group/pressed/focus-ring contract | Not comparable — do not upgrade current-state a11y claims based on the target contract |

This divergence table records facts already established in `WIRE0002` and
`_ar/evidence/design-system/components.md` §2/§4 (mapping "DonationBox ... GAP→recon (major)" and
the reconciliation-priority note); it does not introduce new claims.

---

## Usage Constraints

- **Target:** use when rendering the primary contribution surface inside the `StoryDetail` page's
  sticky right rail; do not use for the donation modal (email/consent/payment) or for the mobile
  sticky CTA bar (a separate, page-level composition per `DESIGN-component-index.md` row 15
  StoryDetail composition notes). Cardinality: one per story-detail page. Placement: rail column
  only, not standalone/embedded in lists.
- **Current-state:** no single component boundary is evidenced; the equivalent surface today is a
  set of inline rows within `WIRE0002`'s sidebar zone, occurring twice per page (see divergence
  table). Any rebuild consuming this COMP doc should treat the current-state "duplicate sidebar" as
  an open question (`WIRE0002-Q1`), not a requirement to replicate.

---

## Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Target props/variants/states/tokens/a11y contract | Confirmed | `packages/ui/src/components/DonationBox/{DonationBox.tsx, DonationBox.module.css, DonationBox.contract.md}`; `_ar/evidence/design-system/components.md` (Blocks → DonationBox); `_ar/spec-draft/DESIGN-component-index.md` row 13 |
| Target token slot names cross-checked against canonical CSS-var naming | Confirmed | `_ar/spec-draft/DESIGN-tokens.md` §10 |
| Current-state donation sidebar as ~6 separate inline rows, no single block | Confirmed | `_ar/spec-draft/WIRE/WIRE0002_StoryDetailAndDonationModal.md` Layout Zones, Components Used |
| Current-state donate action opens a separate donation modal | Confirmed | `_ar/spec-draft/WIRE/WIRE0002_StoryDetailAndDonationModal.md` Interactions #2–#3 |
| Duplicate sidebar as layout artifact, not a deliberate feature | Uncertain (recorded as Open Question, not resolved) | `_ar/spec-draft/WIRE/WIRE0002_StoryDetailAndDonationModal.md` Open Questions WIRE0002-Q1; Conditional Visibility |
| Classification as "GAP→recon (major)" / biggest gap between canonical and reconstructed UX | Confirmed | `_ar/evidence/design-system/components.md` §2 mapping table, §3 reconciliation-priority note |
| Current-state urgent/funded visual states existence | Uncertain — not evidenced | `_ar/spec-draft/WIRE/WIRE0002_StoryDetailAndDonationModal.md` States (empty/loading/error), Open Questions |
| Current-state accessibility | Uncertain — no DOM/recording evidence | `_ar/spec-draft/WIRE/WIRE0002_StoryDetailAndDonationModal.md` Accessibility Notes |
