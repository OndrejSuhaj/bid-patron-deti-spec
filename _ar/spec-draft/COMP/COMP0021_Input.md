---
doc_id: COMP0021
title: Input
canonical_layer: COMP
spec_type: component
modules: []
status: draft
references:
  - WIRE0002
  - WIRE0006
  - WIRE0007
  - WIRE0009
  - WIRE0010
  - WIRE0012
  - WIRE0013
  - WIRE0014
  - WIRE0015
  - WIRE0024
  - COMP0001
  - COMP0009
  - COMP0010
  - EN0004
  - EN0006
  - EN0008
  - DESIGN-component-index
  - DESIGN-tokens
---

# COMP0021 – Input

*(promoted from inline evidence; canonical @patron/ui component: Input)*

> **Promotion note.** This component was **left inline** in the reconstruction. Every text/numeric
> field observed across the WIRE screens (`WIRE0002`, `WIRE0006`, `WIRE0007`, `WIRE0009`, `WIRE0010`,
> `WIRE0012`, `WIRE0013`, `WIRE0014`, `WIRE0015`, `WIRE0024`, and others) was recorded as a bare
> `inline` field — a "generic text input" the reconstruction deliberately declined to promote to a
> standalone COMP, per `_ar/evidence/design-system/components.md` §2 mapping row "Input": *"Both sides
> consciously treat the bare field as a primitive; canonical still ships a themed `Input` atom.
> Low-priority reconciliation."* It is promoted here **as the canonical target contract**
> (`DESIGN-component-index.md` §1 row 2, `_ar/evidence/design-system/components.md` §1 "Input"), per
> instruction, with the current-state observations reconstructed underneath as a clearly separated,
> non-authoritative section. Per the project constitution's current-vs-target rule, the two must not
> be conflated: the canonical contract below describes the **rebuild** atom; the current-state section
> describes what Patronus's live text fields actually render today, which remains independently
> evidenced and largely `Uncertain` at the DOM/behavior level.

---

## Design-system alignment (target — @patron/ui + @patron/tokens)

> **STATE: TARGET — `@patron/ui` `Input` (Atom).** This section is the **authoritative canonical
> contract**, sourced from `DESIGN-component-index.md` §1 row 2 and
> `_ar/evidence/design-system/components.md` §1 "Input". It sits at the same authority level as
> `it-zadani` (future/target design material) — **not** current-state truth — and must not be read
> back into "Current-state (observed)" below.

### Canonical identity

- **Name:** `Input` (Atom-level component, `packages/ui/src/components/Input/`).
- **Exported prop type:** `InputProps`.
- **Storybook stories:** `Text`, `Číslo`, `Vypnuté`.
- **Purpose:** a bare text/numeric form-field atom. Named use cases in the catalogue: the custom
  contribution amount inside `DonationBox` (`COMP0010`) today, and the future donation modal
  (email/consents/payment — explicitly "Mimo scope" of `DonationBox`, per
  `_ar/evidence/design-system/components.md` §1 "DonationBox"). The component is **intentionally
  bare** — it renders no `<label>` and no error styling of its own; pairing it with a visible label
  and error text is the **consumer's responsibility**.

### Props / Inputs (canonical)

| Name | Type | Required | Default | Description |
|---|---|---|---|---|
| `type`, `value`, `placeholder`, `onChange`, `aria-label`, `inputMode`, `disabled`, … | native `InputHTMLAttributes<HTMLInputElement>` | no (per-attribute) | native defaults | The component forwards the full native `<input>` attribute surface; it adds no custom prop of its own beyond `className`. |
| `className` | `string` | no | — | Consumer style hook (composition only — does not carry token-owned values per §10 of `DESIGN-tokens.md`). |

Exported type: `InputProps`. There is **no `variant` and no `size` prop** — the only shape axis is
whatever native `type` the consumer sets (e.g. `text`, `number`, `email`).

### Variants / states (canonical)

- **Variants:** none. Only the native `type` attribute differentiates rendering (e.g. `text` vs.
  `number`); this is not modeled as a component-level `variant` axis.
- **Sizes:** none — a single fixed control size.
- **States:**
  - `default` — border `color.border`, surface `color.surface`.
  - `focus` — ring reads `color.accent`.
  - `disabled` — native `disabled` attribute; visual per `Vypnuté` story.
  - `error` — **not rendered by the component itself.** The consumer must signal error state via
    `aria-invalid` and pair it with its own visible error text; `Input` carries no built-in error
    styling or messaging slot.

### Token slots (canonical)

`var(--font-body)`, `var(--radius-control)`, `var(--color-border)`, `var(--color-surface)`,
`var(--color-text)`, `var(--color-muted)`, `var(--color-accent)`.

Per `DESIGN-tokens.md` §3.1/§6/§10: `--color-border` is the default outline (`color.border`,
tenant-bound: CZ `#EEDDD5` / RO `#D6E7E6`); `--color-surface` is the field background (`#FFFFFF` both
tenants); `--color-text` / `--color-muted` style entered value vs. placeholder text; `--color-accent`
is the focus-ring color (CZ `#6D4AFF` / RO `#FF7A2F`) — the same slot every other focusable atom in
the library reads, per `DESIGN-tokens.md` §3.1 "focus ring has no own slot"; `--radius-control` gives
the field its corner radius (CZ `10px` / RO `16px`); `--font-body` sets the typeface (`'Hanken
Grotesk'`, shared by both tenants). All consumed via `var(--…)` in the component's colocated CSS
module — no hex/px literals (`DESIGN-tokens.md` §10).

### Accessibility (canonical)

- **ARIA role:** inherits native `<input>` semantics — no custom role.
- **Labeling:** **the component renders no `<label>`.** Per `DESIGN-component-index.md` §1 row 2 A11y
  notes, the consumer must pair `Input` with a visible `<label>` and/or `aria-label`; this is a
  documented contract requirement, not an oversight.
- **Error signalling:** `Input` renders **no error style itself** — the consuming composite must
  signal error state via `aria-invalid` and supply its own visible error text alongside the field.
- **Keyboard navigation:** native `<input>` tab-stop and text-editing behavior (no custom keyboard
  handling added by the atom).
- **Focus management:** focus-visible ring reads `color.accent`, consistent with every other
  interactive atom in the library (`Button`, `RailCta`, `ShareRow`).
- **Screen reader:** announces per whatever native `type`/`aria-label`/associated `<label>` the
  consumer supplies; the atom itself adds no screen-reader-specific behavior.

### Tenant (CZ/RO) behaviour

- **Theme-neutral.** `Input` takes no tenant-selection prop — its four token-driven visual properties
  (border, surface, radius, focus ring) resolve purely via `data-theme="cz"|"ro"` remapping the token
  slots above; there is no component code fork and no CZ/RO-specific prop.
- Because it renders no label/copy of its own, there is no localization surface owned by the atom
  itself — any localized placeholder/label text is entirely the consumer's responsibility (e.g.
  `DonationBox`'s `customInputLabel` prop).

### Composition (canonical)

Leaf component — composes nothing. It is itself composed by:

- `DonationBox` (`COMP0010`'s design-system alignment target — no reconstructed current-state COMP
  yet) — the custom ("Jiná") contribution-amount field.
- The future donation modal (email/consents/payment) — named as `DonationBox`'s explicit "Mimo scope"
  boundary; not yet a built composite in the canonical library.

```
Input (canonical, target)
  (leaf — no sub-components)
```

### Source references

`DESIGN-component-index.md` §1 row 2 (Index table); full catalogue entry
`_ar/evidence/design-system/components.md` §1 "Input — `components/Input/`" and mapping row §2
"Input" (`GAP→recon (by design both sides)` classification); token values `DESIGN-tokens.md` §3.1
(`color.border`, `color.surface`, `color.text`, `color.muted`, `color.accent`), §6 (`radius.control`),
§10 (CSS-var naming). Canonical source path:
`/Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/packages/ui/src/components/Input/`
(`Input.tsx`, `Input.stories.tsx`, `Input.module.css`, `Input.contract.md`, `index.ts`).

---

## Current-state (observed)

> The section below documents Patronus's **current-state UI as observed in live-site
> screenshots**. It is evidence-gated reconstruction content, kept deliberately separate from the
> canonical target contract above. Nothing here should be read as a description of the rebuild
> design system.

### Purpose

A bare single-line text/numeric form field, observed repeatedly across almost every form-bearing
screen in the reconstruction, always recorded as `inline` (never independently promoted) because the
reconstruction treated the plain text field as too generic/ubiquitous a primitive to warrant its own
COMP absent a distinguishing visual/behavioral contract — a decision the canonical mapping later
confirms was "by design both sides" (`_ar/evidence/design-system/components.md` §2). Representative
observed occurrences:

1. **Story-detail donation sidebar amount field** (`WIRE0002`) — "Chci darovat" numeric field, Kč
   suffix, prefilled `50`; **two stacked instances** observed on the same page (an unresolved "Open
   Question" in `WIRE0002` about possible duplicate-sidebar rendering, not this component's own
   defect).
2. **Donation modal fields** (`WIRE0002`) — modal-header amount field (Kč suffix, prefilled `50`,
   editable) + contact fields (E-mail required, phone with fixed "+420" prefix segment, Jméno,
   Příjmení).
3. **Passwordless login / activation-request e-mail field** (`WIRE0012`, `WIRE0024`) — single-line
   field, placeholder "E-mail", part of `COMP0009` Single Email-Entry Form.
4. **Application wizard steps 1–4** (`WIRE0007` child name/birth-number/"what is your child like",
   `WIRE0009` applicant name/birth-number/address/city/postcode/e-mail, `WIRE0010` patron name/e-mail/
   phone) — multiple single-line text-input fields per step, several with dual-purpose inline hint
   labels (e.g. "Rodné číslo dítěte (cizinec: číslo pojištěnce)").
5. **Contact/consent gate** (`WIRE0006`) — e-mail field + phone field with a fixed non-editable
   "+420" prefix segment (CZ-only observed; RO/MD prefix behavior `Uncertain`, no evidence captured).
6. **Account activation / set password** (`WIRE0013`) — pre-filled, read-only-styled e-mail field
   (grey background, no red outline) + password field with red-outline validation-error styling
   observed directly.
7. **Account settings / profile** (`WIRE0014`) — name field group (two side-by-side inputs) + e-mail
   field group, both labeled (a departure from the placeholder-as-label pattern seen elsewhere).
8. **Tax confirmation request** (`WIRE0015`) — Jméno/Příjmení, address, birth-number-without-slash,
   and a conditional "Fyzická osoba s IČ" field, all single-line text inputs.

### Props / Inputs (as observed)

No DOM/props evidence is available (static screenshots only). Reconstructed field-level facts,
per-occurrence, not confirmed as a shared component's own props:

| Name (reconstructed) | Type | Description |
|---|---|---|
| `placeholder` | `string` | The dominant labeling pattern observed: placeholder text doubling as the field's only visible label (e.g. "E-mail", "Jméno", "Příjmení", "Telefon") — confirmed in `WIRE0006`, `WIRE0009`, `WIRE0012`, `WIRE0024`. |
| `value` (prefilled) | `string`/`number` | Some fields render a prefilled value (donation amount `50` in `WIRE0002`; e-mail address in `WIRE0013`'s read-only-styled field). |
| fixed prefix segment | n/a | Phone fields in `WIRE0006`/`WIRE0010` render a non-editable "+420" segment ahead of the editable digits — a compound-field pattern with no canonical counterpart evidenced (the canonical `Input` atom has no prefix-segment concept). |
| explicit `<label>` | n/a | Present in some later screens (`WIRE0014` "Vaše jméno a příjmení", "Váš e-mail") — inconsistent with the placeholder-as-label pattern seen elsewhere, i.e. current-state labeling behavior is **not uniform** across the product. |

### Variants (as observed)

`Uncertain` — no distinct shape/size variant axis was confirmed across occurrences; visual
differences observed (full-width vs. paired side-by-side fields, compound prefix+field) appear to be
**layout-level** (WIRE-owned) rather than component-level variants, but this cannot be fully
disentangled from static screenshots alone.

### States

#### idle
Default single-line rendering, placeholder or label text as available. Confirmed across all cited
WIRE occurrences (see individual screenshot citations in each WIRE doc's own Evidence table).

#### hover
`Uncertain — not observable from static evidence.`

#### focused
`Uncertain — not observable from static evidence.`

#### disabled
Read-only-styled variant observed once: `WIRE0013`'s prefilled e-mail field renders with a grey
background and no red outline, distinct from the active/editable password field beside it. Whether
this is a true `disabled` HTML state or a `readonly`/CSS-only treatment cannot be confirmed from a
screenshot alone.

#### loading
`N/A` — no in-flight/loading rendering observed or plausible for a bare text field.

#### error
Validation-error styling observed directly once: `WIRE0013`'s password field renders with a **red
outline** (paired with the prefilled e-mail field's neutral grey styling in the same screenshot).
Several other WIRE docs (`WIRE0002`, `WIRE0006`) flag "e-mail required/format" as an unresolved
validation Open Question with no BR found — current-state error behavior beyond the one confirmed red
outline is largely `Uncertain`.

### Events

No discrete event contract is confirmed from screenshots — text entry and (where paired with a
submit CTA) `onSubmit`-style advancement are implied by each consuming WIRE/UC (e.g. `UC0005`,
`UC0014`), not owned or independently evidenced by the field itself.

### Accessibility (as observed)

Usually not directly observable from screenshots; recorded as `Uncertain` throughout per COMP rules.

- **ARIA role:** `Uncertain` — no DOM evidence available; assumed native `<input>` semantics.
- **Keyboard navigation:** `Uncertain`.
- **Focus management:** `Uncertain`.
- **Screen reader:** `Uncertain` — the **placeholder-as-label pattern** observed in multiple
  occurrences (`WIRE0006`, `WIRE0009`, `WIRE0012`, `WIRE0024`) is a recurring, cross-screen
  accessibility open question already flagged in `COMP0009`'s own Accessibility section (no visible
  `<label>` element confirmed) — not resolved here, carried forward as a current-state observation
  that is genuinely `Uncertain` at the DOM level, only `Probable` from placeholder text visibility.

### Usage Constraints (as observed)

- Use when: capturing a single line of user-entered text/numeric data, across storefront donation
  flows (`WIRE0002`), the Application wizard (`WIRE0007`–`WIRE0011`), auth-adjacent entry screens
  (`WIRE0012`, `WIRE0013`, `WIRE0024`), and account/tax-document screens (`WIRE0014`, `WIRE0015`).
- Do not use when: `Uncertain` — no other current-state exclusion observed; the field appears to be
  used near-universally wherever short text/numeric input is needed.
- Cardinality: multiple per screen (observed up to ~7 fields on a single wizard step, e.g. `WIRE0009`).
- Placement: inside form panels/cards, sidebars (`WIRE0002` donation sidebar), and modal overlays
  (`WIRE0002` donation modal).

### Dependencies (as observed)

- Other COMPs: composed within `COMP0009` Single Email-Entry Form (the e-mail field in `WIRE0012`/
  `WIRE0024`); otherwise recorded `inline` within each consuming WIRE (`WIRE0002`, `WIRE0006`,
  `WIRE0007`, `WIRE0009`, `WIRE0010`, `WIRE0013`, `WIRE0014`, `WIRE0015`) — not confirmed as an
  independently reusable current-state component prior to this promotion.
- Data entities: binds, per occurrence, `EN0004` Campaign (donation amount), `EN0006`/`EN0008`
  Contact/User (e-mail, phone, name, address fields in the modal and wizard steps) — per each citing
  WIRE's own Data Bindings table. The field only *captures* these values; it does not itself perform
  validation logic (`UC`-owned per consuming flow).
- ACL: none evidenced.
- External libraries: none evidenced.

### Composition (as observed)

```
Input (current-state, as observed — inline, not independently confirmed reusable)
  (no confirmed sub-elements; rendered as internal markup within each consuming WIRE
   screen — WIRE0002, WIRE0006, WIRE0007, WIRE0009, WIRE0010, WIRE0012, WIRE0013,
   WIRE0014, WIRE0015, WIRE0024 — and within COMP0009 Single Email-Entry Form)
```

### Divergence from canonical target (record, do not "correct")

- **Labeling inconsistency vs. canonical contract requirement.** The canonical `Input` atom's
  contract *requires* the consumer to pair it with a visible `<label>`/`aria-label` — but current-state
  evidence shows this requirement is **not consistently honored today**: most observed occurrences
  use placeholder-as-label (no visible label), while a minority (`WIRE0014`) do render an explicit
  label. This is a genuine current-state inconsistency, not something to "correct" toward the target
  here — it is recorded as a rebuild-relevant gap instead.
- **Compound prefix-segment pattern not in the canonical contract.** Current-state phone fields
  (`WIRE0006`, `WIRE0010`) render a fixed non-editable "+420" prefix segment ahead of the input — the
  canonical `Input` atom's contract has no such compound/prefix concept; a target implementation of a
  phone field would need either a separate composite or a consumer-side prefix wrapper, neither of
  which exists yet in the canonical library.
- **No error-style contract observed vs. one concrete red-outline instance.** The canonical atom
  explicitly renders **no** error style of its own (`aria-invalid` is the consumer's signal). Current
  state shows **one** concretely observed red-outline error rendering (`WIRE0013` password field) —
  consistent with "the consumer supplies the error style," but not enough evidence to confirm whether
  today's implementation is DOM-equivalent to the canonical `aria-invalid` contract, or a different
  mechanism entirely (`Uncertain`).
- **No accessibility contract observed.** Canonical mandates specific labeling/`aria-invalid`
  responsibilities placed on the consumer, with the atom itself accessible via native semantics.
  Current-state accessibility is uniformly `Uncertain` (no DOM/recording evidence), per the
  cross-cutting reconciliation note in `_ar/evidence/design-system/components.md` §2.
- **No tenant dimension observed.** Current-state evidence is CZ-only (single tenant); the canonical
  tenant remapping (CZ/RO via `data-theme`, all four visual token slots re-pointed with zero code
  change) is target-only, with no current-state RO evidence to compare against. The one CZ-specific
  observation available (`WIRE0006`'s fixed "+420" prefix) has no confirmed RO/MD counterpart.
- **No `type`/`variant` axis confirmed as a component-level contract.** Current-state screenshots show
  varied field purposes (text, numeric-with-suffix, e-mail, phone-with-prefix) but no evidence
  confirms these are implemented as a single shared component varying only by native `type`, as the
  canonical atom's contract specifies — versus several independently-styled current-state fields.
  Left `Uncertain`, not asserted either way.

### Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Bare text/numeric field present across ≥2 screens | Confirmed | `WIRE0002`, `WIRE0006`, `WIRE0007`, `WIRE0009`, `WIRE0010`, `WIRE0012`, `WIRE0013`, `WIRE0014`, `WIRE0015`, `WIRE0024` — each cites its own screenshot(s), e.g. `_ar/prtsc/screencapture-patrondeti-cz-prihlaseni-2026-07-04-13_23_29.png` |
| Placeholder-as-label pattern (no visible `<label>`) | Probable | `WIRE0006`, `WIRE0009`, `WIRE0012`, `WIRE0024` field descriptions; corroborated in `COMP0009` Accessibility section |
| Explicit `<label>` present (counter-example) | Confirmed | `WIRE0014` "Vaše jméno a příjmení" / "Váš e-mail" field-group labels |
| Fixed "+420" phone prefix segment | Confirmed (CZ) / Uncertain (RO/MD) | `WIRE0006` Form panel — Phone field row; `WIRE0010` Patron phone field row |
| Red-outline validation-error styling | Confirmed | `WIRE0013` Main — password field row (screenshot-cited) |
| Read-only-styled prefilled e-mail field | Confirmed | `WIRE0013` Main — e-mail field row (screenshot-cited) |
| Shared-component identity across occurrences (single reusable field vs. many independent fields) | Uncertain | `_ar/evidence/design-system/components.md` §2 mapping row "Input" ("both sides consciously treat the bare field as a primitive"); no cross-WIRE DOM evidence available |
| Accessibility | Uncertain | no DOM/recording evidence available |
| Props/variants/states beyond visual text entry | Uncertain | static screenshots only, no interactive/DOM evidence |
