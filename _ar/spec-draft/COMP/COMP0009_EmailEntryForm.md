---
doc_id: COMP0009
title: Single Email-Entry Form
canonical_layer: COMP
spec_type: component
modules: []
status: draft
references:
  - WIRE0012
  - WIRE0024
  - EN0006
  - EN0008
  - UC0014
---

# COMP0009 – Single Email-Entry Form

## Purpose

A minimal one-field form (e-mail input + primary submit button + one or two secondary text links)
used at both authentication-adjacent entry points that ask only for an e-mail address: passwordless
login (`WIRE0012`) and the activation-link request screen (`WIRE0024`). Both realize `UC0014` and
share an (almost) identical shape confirmed by direct screenshot comparison, differing only in
heading/body copy and the secondary-link targets.

## Props / Inputs

| Name | Type | Required | Default | Description |
|---|---|---|---|---|
| `heading` | `string` | yes | — | Screen-specific H1; COPY-owned (e.g. "Přihlaste se do účtu", "Už jsem dárcem, žadatelem nebo Patronem a chci aktivovat účet"). |
| `bodyText` | `string` | yes | — | 1–2 paragraph intro; COPY-owned. |
| `emailValue` | `string` | no | `""` | Controlled e-mail field value; `WIRE0024`'s evidence describes a pre-filled example value in one narrative source (Probable, not independently visible in its own cited screenshot). |
| `ctaLabel` | `string` | yes | — | Primary submit button label (e.g. "Přihlásit se", "Poslat aktivační odkaz"). |
| `secondaryLinks` | `{label, href}[]` | no | `[]` | 1–2 secondary text links below the CTA (e.g. "Přihlaste se pomocí svého hesla.", "Aktivujte si ho.", "Zpět na přihlášení"). |
| `statusIcon` | `string` | no | `none` | Decorative glyph above the heading — a two-person icon observed on both screens' default state. |

## Variants

- **purpose:** login (`WIRE0012`, `/prihlaseni`) | activation-request (`WIRE0024`,
  `/overit-prihlaseni`) — same shape, different copy/links/downstream `UC0014` sub-path.

## States

### idle (default, unsubmitted)
Two-person status icon, heading, body copy, single-line e-mail input (placeholder "E-mail" doubling
as the label, no visible label above the field), red primary button, 1–2 secondary text links.
Confirmed — `_ar/prtsc/screencapture-patrondeti-cz-prihlaseni-2026-07-04-13_23_29.png` (login,
directly visible); `WIRE0024`'s equivalent is `Probable` only — its own cited screenshot shows
header/cookie-banner/footer chrome but not the form body itself (evidence gap flagged in
`WIRE0024`, not resolved here).

### confirmation (post-submit, login only)
Icon changes to a checkmark-circle; heading becomes "Zkontrolujte svou e-mailovou schránku"; body
explains the link was sent; one secondary link changes to a mailto/spam-check hint. Confirmed for
the login variant only —
`_ar/prtsc/screencapture-patrondeti-cz-prihlaseni-2026-07-04-13_32_31.png`. Not confirmed whether
the activation-request variant (`WIRE0024`/S021→S022) shares this same confirmation sub-state or
renders a separately-designed "link sent" screen (`WIRE0025`, itself Uncertain/unevidenced — see
Open Questions).

### hover
`Uncertain — not observable from static evidence.`

### focused
`Uncertain — not observable from static evidence.`

### disabled
`Uncertain — no disabled-state rendering was captured for the submit button pre-validation.`

### loading
`Uncertain — no in-flight state was captured for either screen; Evidence Pending.`

### error
`Uncertain — no invalid-email or resend-throttling error rendering was captured for either screen;
each consuming WIRE records "e-mail required/format" and (for WIRE0012 only) "resubmission/
throttling" as validation-without-BR open questions, not resolved here.`

## Events

| Event | Payload | Trigger | Notes |
|---|---|---|---|
| `onSubmit` | `{email: string}` | click primary CTA or Enter in the field | Advances `UC0014`; downstream branch (login-link vs. activation-link) is UC-owned. |
| `onSecondaryLinkClick` | target route | click a secondary link | e.g. login↔activation-request cross-links, password-login fallback. |

## Accessibility

- **ARIA role:** `Uncertain` — Assumed native `<form>`/`<input>` semantics; not confirmed.
- **Keyboard navigation:** `Uncertain` — Assumed Tab order field→button→links; not confirmed.
- **Focus management:** `Uncertain` — whether focus moves to the confirmation heading after submit is not observable from static evidence.
- **Screen reader:** `Uncertain` — no visible `<label>` element is confirmed for the e-mail field (placeholder-as-label pattern), which is a common accessibility risk; flagged as an Open Question, not asserted as a defect without DOM evidence.

## Usage Constraints

- Use when: the only information needed to proceed is the user's e-mail address, for an
  authentication-adjacent flow (`UC0014`).
- Do not use when: additional fields (password, phone) are required (→ `WIRE0013` account
  activation, which adds a password field, is NOT this component despite visual family
  resemblance — recorded as a sibling, not merged in, per the evidence-gated reuse rule).
- Cardinality: one per screen.
- Placement: centered content card, below a decorative status icon and heading/body text.

## Dependencies

- Other COMPs: `COMP0001` Primary Button (the submit CTA matches the primary-button visual pattern —
  Probable, not restated as certain), `COMP0002` Global Header, `COMP0003` Global Footer (standard
  chrome wrapping both screens).
- Data entities: `EN0006` Contact / `EN0008` User — the e-mail value conceptually identifies an
  existing party for `UC0014`, but no attribute-level binding is confirmed from UI evidence alone.
- ACL: none evidenced.
- External libraries: none evidenced.

## Composition

```
EmailEntryForm
  ├─ status icon (decorative)
  ├─ heading + body text (COPY-owned)
  ├─ e-mail <input>
  ├─ COMP0001 Primary Button (Probable — visual match, not confirmed identical)
  └─ 1–2 secondary text links
```

## Open Questions

- `WIRE0024`'s own form-body content is `Probable`, not independently visible in its cited
  screenshot (only `ui-observed-areas.md` §9 prose evidences it) — this COMP's activation-request
  variant inherits that same certainty ceiling.
- Whether `WIRE0025` (S022, the activation-link-sent confirmation screen) is this component's
  `confirmation` state reused, or an entirely separate screen — both of `WIRE0025`'s own
  screenshots were found to depict `WIRE0024`'s form content instead, so no evidence currently
  supports either answer (carried forward from `WIRE-screen-coverage.md`'s S022 note).
- Placeholder-as-label pattern (no visible `<label>`) is a recurring accessibility open question
  across both variants.

## Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Reuse across ≥2 screens | Confirmed (shape) / Probable (WIRE0024 content) | `WIRE0012` and `WIRE0024` both realize `UC0014` with this shape; `WIRE-synthesis-report.md` §6 "E-mail-entry single-field form" |
| Login variant, idle state | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-prihlaseni-2026-07-04-13_23_29.png` |
| Login variant, confirmation state | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-prihlaseni-2026-07-04-13_32_31.png` |
| Activation-request variant, idle state | Probable | `ui-observed-areas.md` §9 prose only; not independently visible in `_ar/prtsc/screencapture-patrondeti-cz-overit-prihlaseni-2026-07-04-13_33_25.png` per WIRE0024's own evidence note |
| Accessibility | Uncertain | no DOM/recording evidence available |
