---
doc_id: COMP0006
title: Consent Checkbox
canonical_layer: COMP
spec_type: component
modules: []
status: draft
references:
  - WIRE0002
  - WIRE0006
  - WIRE0011
  - WIRE0013
  - EN0006
  - EN0008
---

# COMP0006 – Consent Checkbox

## Purpose

A checkbox paired with a label containing an inline hyperlink to a legal document (GDPR/personal
data processing, rules of aid provision, account-usage terms) plus optional helper text. Used
wherever a form requires the user to acknowledge a policy before submitting. The visual/interaction
shape (checkbox + label + embedded link) recurs identically across at least 4 written WIRE screens
spanning three different modules (donation, application intake, account activation).

## Props / Inputs

| Name | Type | Required | Default | Description |
|---|---|---|---|---|
| `checked` | `boolean` | yes | `false` | Checkbox state; observed default is unchecked on every screen except the pre-filled donation modal (`WIRE0002`, tester data — see States). |
| `label` | `string \| node` | yes | — | Label text containing an embedded hyperlink; COPY-owned, not restated here (e.g. "Souhlasím se zpracováním osobních údajů a informováním o projektu", "Souhlasím s pravidly poskytování pomoci projektu Patron."). |
| `linkHref` | `string` | no | — | Target of the embedded hyperlink; link *targets* are not evidenced on several screens (Uncertain, see `WIRE0011`). |
| `helperText` | `string` | no | `none` | Optional line below the label (observed once, `WIRE0006`: "Souhlasy můžete upravit/zrušit zasláním e-mailu na souhlas@patrondeti.cz."). |
| `required` | `boolean` | no | `Uncertain` | Whether the checkbox gates form submission; no BR document was found backing this for any citing screen — recorded in each consuming WIRE's `validationsWithoutBR` as an Open Question, not asserted here. |

## Variants

- **count-per-form:** single (`WIRE0006` contact/consent gate — one checkbox) | double (`WIRE0002`
  donation modal, `WIRE0013` account activation — two checkboxes, each with a different legal
  target) | triple (`WIRE0011` attachments step — three checkboxes: truthfulness, rules, personal
  data)

## States

### idle
Unchecked square checkbox + label with an underlined inline link. Confirmed,
`_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_18_33.png` context (no
checkbox on that exact screen, but same visual family per `ui-observed-areas.md` §6/§8/§9).

### checked
Filled/ticked checkbox, same label. Confirmed —
`_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_26_21.png`
shows both donation-modal consent checkboxes pre-checked with a green fill (tester-interacted state,
not necessarily the default).

### hover
`Uncertain — not observable from static evidence.`

### focused
`Uncertain — not observable from static evidence.`

### disabled
N/A — no disabled rendering observed in any capture.

### loading
N/A — synchronous UI control, no async behavior evidenced.

### error
`Uncertain — no screen shows a validation-error rendering for an unchecked required consent
checkbox (e.g. red outline or inline error text); whether one exists is unconfirmed. Recorded as an
open validation question in every consuming WIRE (see e.g. WIRE0002 §Validation Surfaces).`

## Events

| Event | Payload | Trigger | Notes |
|---|---|---|---|
| `onChange` | `boolean` (new checked state) | user click on the checkbox or label | Toggles `checked`. |
| `onLinkClick` | none | click on the embedded hyperlink | Opens the referenced legal document; behavior (new tab vs. navigate away, and whether checkbox state is preserved) is not evidenced. |

## Accessibility

- **ARIA role:** `Uncertain` — Assumed native `<input type="checkbox">` semantics with an associated `<label>`; not confirmed.
- **Keyboard navigation:** `Uncertain` — Assumed Space-to-toggle via standard checkbox semantics; not confirmed.
- **Focus management:** `Uncertain`.
- **Screen reader:** `Uncertain` — whether the embedded link is announced separately from the checkbox label is not confirmable from screenshots.

## Usage Constraints

- Use when: a form step requires acknowledgement of a specific legal document before proceeding.
- Do not use when: the consent is implicit/site-wide (→ `COMP0004` Cookie Consent Banner is the
  distinct mechanism for that case).
- Cardinality: one to three per form, each bound to a different legal target (observed range:
  1–3, no evidence of more).
- Placement: directly above the form's `COMP0001` Primary Button, typically the last form elements
  before submission.

## Dependencies

- Other COMPs: none as sub-components; typically placed immediately before `COMP0001` Primary Button
  in form layout (sequencing observed, not a composition relationship).
- Data entities: consent acknowledgement conceptually relates to `EN0006` Contact /
  `EN0008` User (the party granting consent) but no confirmed attribute-level binding is evidenced
  on any citing WIRE — recorded as Uncertain, not asserted.
- ACL: none evidenced.
- External libraries: none evidenced.

## Composition

Leaf component; no sub-COMP composition. Commonly repeated 1–3 times within a form immediately
preceding a `COMP0001` Primary Button instance.

## Examples

```
ConsentCheckbox checked={true}  label="Souhlasím s pravidly poskytování pomoci projektu Patron." />
ConsentCheckbox checked={true}  label="Souhlasím se zpracováním osobních údajů a informováním o projektu" />
  // WIRE0002 — donation modal, both instances tester-checked

ConsentCheckbox checked={false} label="Souhlasím se zpracováním osobních údajů a informováním o projektu"
                helperText="Souhlasy můžete upravit/zrušit zasláním e-mailu na souhlas@patrondeti.cz." />
  // WIRE0006 — contact/consent gate, single instance, unchecked default
```

## Open Questions

- No BR document backs the required-ness of any instance of this component across its 4 consuming
  screens — carried forward from each WIRE's own `validationsWithoutBR` list, not resolved here.
- Error-state rendering (unchecked-but-required) is entirely unevidenced.
- Whether entity binding exists at all (vs. pure UI-side consent flag) is unconfirmed.

## Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Reuse across ≥2 screens | Confirmed | `WIRE0002`, `WIRE0006`, `WIRE0011`, `WIRE0013` all show this exact checkbox+linked-label shape; `WIRE-synthesis-report.md` §6 "Consent checkbox with linked legal-document label" |
| Checked visual state | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_26_21.png` |
| Unchecked default state | Confirmed | `_ar/evidence/ui/ui-observed-areas.md` §6, §8, §9 narrative (checkbox unchecked by default) |
| Error state | Uncertain | not observed in any capture |
| Accessibility | Uncertain | no DOM/recording evidence available |
