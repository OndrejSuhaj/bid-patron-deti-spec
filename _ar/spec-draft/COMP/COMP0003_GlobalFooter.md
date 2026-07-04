---
doc_id: COMP0003
title: Global Site Footer
canonical_layer: COMP
spec_type: component
modules: []
status: draft
references:
  - WIRE0001
  - WIRE0002
  - WIRE0003
  - WIRE0005
  - WIRE0006
  - WIRE0007
  - WIRE0008
  - WIRE0009
  - WIRE0010
  - WIRE0011
  - WIRE0012
  - WIRE0013
  - WIRE0014
  - WIRE0015
  - WIRE0019
  - WIRE0021
  - WIRE0023
  - WIRE0024
  - WIRE0025
  - IA-patronus
---

# COMP0003 – Global Site Footer

## Purpose

The persistent multi-column site footer: brand blurb, "Sledujte nás" social link, Nadace Sirius
attribution, registered public-collection number, link columns ("Patron dětí": O nás/Blog/Pravidla
poskytování pomoci/Naše desatero/Splněné příběhy/Výroční zprávy/Jak jsme pomáhali...; "Kontakt":
e-mail), payment-provider badges (Comgate/Mastercard/Visa), collection-account number, and a
bottom copyright/legal-links bar. Present identically as chrome on nearly every screen — directly
observed on at least 19 of the 22 written WIRE docs.

## Props / Inputs

| Name | Type | Required | Default | Description |
|---|---|---|---|---|
| `promoSlot` | `slot / node` | no | `none` | Optional extra promo band above the standard footer content, observed once as "Víte o dítěti, které potřebuje pomoci?" on `WIRE0014` — treated as a screen-specific slot, not part of the base contract. |

## Variants

- **promo:** none (default, Confirmed on most screens) | with-promo-band (`WIRE0014` only — Uncertain
  whether this is a general capability or a one-off addition specific to the account-settings screen)

## States

### idle
Dark background, four content regions (brand/blurb, link columns, contact, payment badges) plus a
bottom bar with legal links and copyright. Confirmed on every citing screenshot, e.g.
`_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png`,
`_ar/prtsc/screencapture-patrondeti-cz-overit-prihlaseni-2026-07-04-13_33_25.png`.

### hover
`Uncertain — not observable from static evidence` (link hover states not captured).

### focused
`Uncertain — not observable from static evidence.`

### disabled
N/A — footer has no disabled state.

### loading
N/A — static chrome.

### error
N/A — no error rendering owned by the footer itself.

## Events

| Event | Payload | Trigger | Notes |
|---|---|---|---|
| `onNavigate` | target route | click on any footer link | Targets IA-owned; several point to blocked-no-uc content screens (S013/S014/S015). |

## Accessibility

- **ARIA role:** `Uncertain` — Assumed `<footer>` native landmark semantics; not confirmed.
- **Keyboard navigation:** `Uncertain`.
- **Focus management:** `Uncertain`.
- **Screen reader:** `Uncertain`.

## Usage Constraints

- Use when: rendering the bottom of any Patronus-built screen.
- Do not use when: rendering external/vendor surfaces (out of WIRE/COMP scope).
- Cardinality: exactly one per screen, bottom-most position.
- Placement: page-level, below all other content zones; typically preceded immediately by
  `COMP0004` Cookie Consent Banner when undismissed.

## Dependencies

- Other COMPs: none confirmed as composed sub-elements; the payment-provider badge row is static
  imagery, not an interactive component.
- Data entities: none.
- ACL: none evidenced.
- External libraries: none evidenced.

## Composition

Leaf-level chrome component; no confirmed sub-COMP composition.

## Examples

```
GlobalFooter />                                   // WIRE0001, WIRE0006–WIRE0013 (standard)
GlobalFooter promoSlot={<CrossSellBanner />} />   // WIRE0014 (with-promo-band, Uncertain generality)
```

## Open Questions

- Whether the `WIRE0014` promo band ("Víte o dítěti, které potřebuje pomoci?") is a general footer
  slot capability or a one-off screen-specific addition — no second occurrence was found in
  evidence to confirm reuse of that specific slot.

## Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Reuse across ≥2 screens | Confirmed | 19+ WIRE docs cite an identical footer pattern; `WIRE-synthesis-report.md` §6 |
| Visual idle state | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png`, `_ar/prtsc/screencapture-patrondeti-cz-overit-prihlaseni-2026-07-04-13_33_25.png`, `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_18_33.png` |
| promo-band variant | Uncertain | single occurrence only, `_ar/spec-draft/WIRE/WIRE0014_AccountSettingsProfile.md` |
| Accessibility | Uncertain | no DOM/recording evidence available |
