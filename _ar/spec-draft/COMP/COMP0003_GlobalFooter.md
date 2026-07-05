---
doc_id: COMP0003
title: Site Footer
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
  - DESIGN-component-index
---

# COMP0003 – Site Footer

*(reconstructed as "Global Footer" / "GlobalFooter"; canonical @patron/ui component: SiteFooter)*

## Current-state (observed)

> Everything below this point through "Evidence" describes **current-state Patronus behavior**,
> reconstructed from WIRE/screenshot evidence. It is unchanged by the design-system reconciliation
> — see "Design-system alignment (target)" further down for the `@patron/ui` `SiteFooter` contract.

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

---

## Design-system alignment (target)

> **STATE: TARGET — `@patron/ui` rebuild design system.** This section describes the **canonical
> `SiteFooter` component contract** from the `bid-patron-deti` rebuild library, per
> `_ar/spec-draft/DESIGN-component-index.md` (row 15) and `_ar/evidence/design-system/components.md`
> (`SiteFooter — components/SiteFooter/`). It is **not** current-state Patronus behavior and must
> not be read back onto the "Current-state (observed)" section above. Per the project constitution's
> current-vs-target rule, both are recorded side by side, not merged.
>
> **Reconciliation classification:** `components.md` §2 — **RENAME**. "GlobalFooter" (reconstructed)
> ↔ "SiteFooter" (canonical): same concept, different name and a different (fully prop-driven, fixed
> layout) contract.

### Canonical identity

- **Name:** `SiteFooter` (Block-level component, `packages/ui/src/components/SiteFooter/`).
- **Exported prop type:** `SiteFooterProps`.
- **Storybook story:** `Patička`.

### Props / Inputs (canonical)

| Name | Type | Notes |
|---|---|---|
| `tagline` | `string` | Brand tagline text (replaces the observed static "brand blurb"). |
| `followLabel` | `string` | Label for the social-follow affordance (observed as "Sledujte nás"). |
| `projectTitle` | `string` | Heading for the project/nav link column (observed as "Patron dětí"). |
| `projectLinks` | `string[]` | The link-column entries (observed: O nás/Blog/Pravidla poskytování pomoci/Naše desatero/Splněné příběhy/Výroční zprávy/Jak jsme pomáhali…). |
| `contactTitle` | `string` | Heading for the contact column (observed as "Kontakt"). |
| `email` | `string` | Contact e-mail. |
| `contactNotes` | `node[]` | Freeform contact-column supplementary content. |
| `applyLabel` | `string` | Label content, per-tenant. |
| `legalNote` | `node` | Bottom-bar legal text (observed: Nadace Sirius attribution, registered public-collection number). |
| `privacyLabel` | `string` | Privacy-policy link label. |
| `copyright` | `string` | Copyright line. |

All footer content is passed in as props, already localized — **no fixed "promo band" slot exists**
in the canonical contract (see Divergence below).

### Variants / states (canonical)

- **Variants:** none — the canonical footer is fully content-driven (fixed structure); there is no
  structural variant axis (contrast with the observed `promoSlot` variant below).
- **States:** `default`; link `hover`/`focus`.

### Token slots (canonical)

`var(--layout-container)`, `var(--space-xl)`, `var(--space-lg)`, `var(--space-md)`,
`var(--space-sm)`, `var(--color-border)`, `var(--color-surface)`, `var(--color-text)`,
`var(--color-muted)`, `var(--color-action)`, `var(--font-body)`, `var(--font-display)` (+ weight/
tracking via `var(--font-display-weight)` / `var(--font-display-tracking)`).

### Composition (canonical)

```
SiteFooter
  ├─ Brandmark (small)              — COMP0019 (canonical; not a reconstructed COMP)
  └─ SocialGlyph (facebook/instagram/linkedin, hardcoded — internal, uncataloged as its own COMP)
```

### Accessibility (canonical)

- Standard link focus states; no custom ARIA beyond native `<footer>`/nav landmark semantics per
  `components.md`. This resolves the observed doc's `Uncertain` ARIA-role note toward "native
  semantics", though the canonical source does not itemize the landmark role explicitly either —
  treat as `Probable`, not `Confirmed`.

### Tenant (CZ/RO) behaviour

- **Theme-neutral component contract** — no tenant-specific props of its own; all visual re-skinning
  happens via token remap under `data-theme="cz"` / `data-theme="ro"` (colors, fonts, radius,
  shadow), not via footer-specific branching.
- Composed `Brandmark` (small variant) is itself theme-driven: CZ renders the in-repo icon-tile +
  wordmark composition; RO renders the live KidsHero logo (hotlinked, no local binary) — see
  `DESIGN-tokens.md` §11 and `DESIGN-component-index.md` row 4.
- All footer body content (`projectLinks`, `contactNotes`, `legalNote`, `copyright`, etc.) is
  supplied per-tenant/per-locale by the consumer via props — the canonical component does not
  localize text itself.

### Divergence from observed current-state (record, do not "correct")

- **`promoSlot` has no canonical counterpart.** The reconstructed COMP0003's `promoSlot` prop and
  `with-promo-band` variant (observed once, `WIRE0014` — "Víte o dítěti, které potřebuje pomoci?")
  do **not** exist in the canonical `SiteFooter` contract, which is fixed-structure with no
  extension slot. Per `components.md` §4, this resolves the current doc's open question:
  on the **target** side, the promo band is "not a general capability" — but this does **not**
  retroactively change what was **observed** in current-state Patronus; the current-state section
  above stands as-is, `Uncertain` generality intact.
- **Composition detail gained:** the canonical contract makes `Brandmark` and `SocialGlyph`
  first-class composed sub-elements; the reconstructed COMP0003 treats the equivalent chrome
  (brand blurb, "Sledujte nás" social link) as unstructured content because no reuse was
  evidenced separately from the footer itself in current-state screenshots.
- **Payment-provider badges / collection-account number** (observed: Comgate/Mastercard/Visa
  badges, collection-account number) have **no** corresponding canonical prop or slot — the
  canonical `SiteFooter` props list (`tagline`…`copyright`) does not itemize a badge row. Flag as
  an open reconciliation gap for the rebuild, not as an error in either source.

### Source references

- `_ar/spec-draft/DESIGN-component-index.md` — row 15 (`SiteFooter`), §2 doc_id assignment, §3.
- `_ar/evidence/design-system/components.md` — `SiteFooter — components/SiteFooter/` section; §2
  mapping table row; §4 divergence note ("Footer promo slot").
- `_ar/spec-draft/DESIGN-tokens.md` — §3 (color slots), §10 (CSS custom-property naming), §11
  (multi-tenant theming model).
