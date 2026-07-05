---
doc_id: COMP0004
title: Cookie Consent Banner
canonical_layer: COMP
spec_type: component
modules: []
status: draft
references:
  - WIRE0001
  - WIRE0003
  - WIRE0006
  - WIRE0007
  - WIRE0008
  - WIRE0011
  - WIRE0013
  - WIRE0015
  - WIRE0024
  - WIRE0025
---

# COMP0004 – Cookie Consent Banner

## Purpose

A persistent, dismissible notice bar informing visitors of cookie usage, with an "accept" action
(or accept/reject pair on the homepage) and a "Další informace" link. Present as chrome across the
public site and observed independently in at least 9 written WIRE docs with two slightly different
visual renderings (see Variants) — reuse is directly evidenced.

## Props / Inputs

| Name | Type | Required | Default | Description |
|---|---|---|---|---|
| `dismissed` | `boolean` | no | `false` | Whether the visitor has already accepted/dismissed the banner in this session; controls visibility. |
| `onAccept` | `function` | no | — | Handler for the accept action. |
| `onReject` | `function` | no | — | Handler for the reject action (only present in the two-button variant, see Variants). |

## Variants

- **actions:** single-action (dark bottom bar, cookie icon + text + "Další informace" link only —
  Confirmed on most screens, e.g. `WIRE0006`, `WIRE0007`, `WIRE0013`, `WIRE0024`) | dual-action
  (bottom-left floating card with "Přijímám" / "Odmítnout" buttons plus a "Více info" link — Confirmed
  once, on the homepage `WIRE0001`). The two variants are visually distinct enough that they may in
  fact be two different implementations of a consent mechanism rather than one parameterized
  component — flagged as `Uncertain` rather than asserted as a single confirmed variant axis.

## States

### idle
Banner visible with cookie-icon glyph, explanatory text, and action(s). Confirmed,
`_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png` (dual-action, bottom-left card),
`_ar/prtsc/screencapture-patrondeti-cz-overit-prihlaseni-2026-07-04-13_33_25.png` (single-action,
full-width dark bar).

### hover
`Uncertain — not observable from static evidence.`

### focused
`Uncertan — not observable from static evidence.`

### disabled
N/A.

### loading
N/A.

### error
N/A.

### dismissed (additional lifecycle state, not one of the six template states)
Banner is not rendered / removed from the DOM after an accept/reject action. Not directly observed
(no before/after pair captured for the same session) — `Assumed` based on standard cookie-banner
convention, not confirmed by evidence.

## Events

| Event | Payload | Trigger | Notes |
|---|---|---|---|
| `onAccept` | none | click "Přijímám" (dual) or the implicit accept of the single-action variant | Persists consent, mechanism (cookie/localStorage) not evidenced. |
| `onReject` | none | click "Odmítnout" (dual-action variant only) | No confirmed behavioral difference observed (e.g. whether it also dismisses or keeps banner visible). |
| `onMoreInfo` | none | click "Další informace" / "Více info" | Target not confirmed in evidence (likely a cookie-policy page, not captured). |

## Accessibility

- **ARIA role:** `Uncertain` — Assumed `role="dialog"` or a live-region banner; not confirmed.
- **Keyboard navigation:** `Uncertain`.
- **Focus management:** `Uncertain` — whether focus is trapped or moved to the banner on load is not observable from static screenshots.
- **Screen reader:** `Uncertain`.

## Usage Constraints

- Use when: rendering any public-facing Patronus screen prior to consent being recorded.
- Do not use when: consent has already been recorded for the session (Assumed dismiss behavior, not confirmed).
- Cardinality: at most one visible instance per page load.
- Placement: overlay/fixed position — bottom-left floating card (dual-action variant) or full-width bottom bar (single-action variant).

## Dependencies

- Other COMPs: `COMP0001` Primary Button — the dual-action variant's "Přijímám" button visually
  resembles the primary button pattern; not confirmed identical (Uncertain), so composition is noted
  but not asserted as certain.
- Data entities: none.
- ACL: none.
- External libraries: none evidenced (no vendor consent-management-platform branding observed).

## Composition

```
CookieConsentBanner (dual-action variant)
  └─ COMP0001-like accept button (Uncertain — not confirmed as the identical shared button component)
```

## Open Questions

- Whether the single-action and dual-action renderings are genuinely the same parameterized
  component or two independently built mechanisms — no code/DOM evidence resolves this; recorded as
  an open question rather than silently merged or split.
- Persistence mechanism (cookie vs. localStorage vs. session) is not evidenced from screenshots.

## Design-system alignment (target)

No canonical counterpart in `@patron/ui` — the cookie/consent legal surface is not covered by any
built epic (E0003–E0005) in the target design system. No token or component mapping is proposed
here; this component remains current-state-only pending a target epic that scopes consent/legal UI.

## Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Reuse across ≥2 screens | Confirmed | 9+ WIRE docs cite this banner; `WIRE-synthesis-report.md` §6 "Global header nav + cookie-consent banner + footer" |
| Dual-action variant | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png` |
| Single-action variant | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-overit-prihlaseni-2026-07-04-13_33_25.png`, `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_18_33.png` |
| Dismissed lifecycle state | Assumed | standard convention; no before/after capture exists |
| Accessibility | Uncertain | no DOM/recording evidence available |
