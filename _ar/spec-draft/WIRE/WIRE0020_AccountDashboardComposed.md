---
doc_id: WIRE0020
title: Account Dashboard Composed
canonical_layer: WIRE
spec_type: wireframe
modules: []
screen_id: S017
realizes_uc: [UC0024]
status: draft
references:
  - UC0024
  - EN0034
  - EN0009
  - EN0004
  - EN0008
  - EN0014
  - EN0021
  - IA-patronus
---

# WIRE0020 – Account Dashboard Composed

## Purpose

**Hypothesis only — not a captured application screen.** This document reconstructs the composed
"Můj účet" dashboard mockup that appears as a small mobile-device graphic embedded inside the
"Dokončete svůj uživatelský účet 🎉" marketing/drip e-mail
(`screencapture-mail-google-mail-u-1-2026-07-04-13_32_45.png`). No real screen, view, controller, or
REST resource backing this composed layout was found in the Patronus backend source
(`_ar/spec-draft/EN/EN0034_DonorAccountView.md` Evidence Gaps 1/3; `_ar/spec-draft/UC/UC0024_ManageDonorAccount.md`
Evidence Pending; `IA-patronus.md` §8 IA-Q3). It is carried in the IA screen map as an
**Uncertain**-certainty screen and documented here strictly as *what the mockup graphic depicts*,
not as confirmed current-state behaviour — per the IA's explicit instruction, "must not be
reconstructed as built."

The mockup implies a candidate realization of `UC0024` (sub-flows UC0024.1 / UC0024.1b — viewing an
own-account dashboard of supported stories and giving activity), for an authenticated Customer
(any User, `EN0008`, most plausibly one holding the `supporter` role per `EN0034` invariants).
Entry context in the mockup is not a real navigation path — it is a static marketing graphic, not a
live device capture; there is no evidenced route, deep link, or menu entry into this composed
dashboard (see Conditional Visibility and Evidence).

Do not treat this WIRE as describing a built screen. Where the confirmed backend-projected donor
account screen exists, it is documented separately at `WIRE0021` (`S018`, `zona/darce`), which is
narrower (two columns: supported Campaign + summed contributed amount) and is the current-state
truth for the account/donation-history surface.

---

## Layout Zones

**Confirmed** (what is visible in the mockup graphic) — `screencapture-mail-google-mail-u-1-2026-07-04-13_32_45.png`.
The mockup is a small inset phone-frame illustration inside the e-mail body, not a full-screen
capture, so only the following is legible:

- **App header** — "patron dětí" wordmark with the tagline strap "společně za lepší dětství"
  (same branding treatment as the public site header; no distinct account-app chrome is legible
  beyond the logo lockup).
- **Tab bar** — two tabs: "Pro vás" (person icon, appears selected/active by icon color) and
  "Všechny (67)" (a count in parentheses).
- **Story card (single card visible, "Pro vás" tab)**:
  - Card image — a photo (two people, one appears to be a caregiver/child context, consistent with
    Patronus's child-story imagery).
  - Contribution banner overlay — "Přispěli jste 1 250 Kč" (highlighted/colored banner across the
    card image).
  - Countdown badge — "ZBÝVÁ 10 DNÍ" (colored pill/badge, upper area of the card).
  - Story title — "Lucce na rehabilitační program".
  - Progress figures — "83 240 Kč" / "101 591 Kč" (collected / target amount pair, plain text; no
    graphical progress bar is legible at this resolution).
- No footer, no secondary navigation, and no further cards are legible in the mockup crop — the
  graphic is cropped/scaled for e-mail-inset use, not a full-viewport capture.

Surrounding the mockup (e-mail chrome, not part of the dashboard screen itself — recorded for
orientation only): a "Proč dokončit uživatelský účet?" three-column benefit panel ("Vše na jednom
místě", "Každý má účet na míru", "Statistiky a zpětná vazba") and the caption "Fungujeme skvěle na
počítači i ve vašem mobilním telefonu!" — this is marketing copy about the account, not dashboard UI,
and belongs to the e-mail's MSG-layer content, not this WIRE.

```
+----------------------------------------+
| patron dětí | společně za lepší dětství |
+----------------------------------------+
| [Pro vás*]   Všechny (67)               |
+----------------------------------------+
| +--------------------------------+     |
| | [card image]                    |    |
| |  "Přispěli jste 1 250 Kč"       |    |
| |  ZBÝVÁ 10 DNÍ                   |    |
| +--------------------------------+     |
| Lucce na rehabilitační program          |
| 83 240 Kč / 101 591 Kč                  |
+----------------------------------------+
   (remainder of screen out of frame —
    not legible in the mockup graphic)
```

**Uncertain** — whether additional cards, a scrollable list, filters, or further chrome exist below
the visible crop; the mockup graphic itself is truncated in the e-mail layout and no larger/alternate
version was captured.

---

## Components Used

The COMP layer does not yet exist for this reconstruction pass; every element is flagged `inline`.
Component identity here is doubly uncertain: not only is there no COMP layer, but the screen itself
is unconfirmed as built, so these are best read as "elements depicted in the mockup graphic," not
verified UI components.

| Zone | COMP-id | Variant/Props | Notes |
|---|---|---|---|
| App header | inline | logo + tagline lockup | Same brand lockup as public-site header; **Assumed** shared chrome, not independently confirmed for an account-app context |
| Tab bar | inline | two-tab segmented control: "Pro vás" / "Všechny (N)" | `N` observed as "67" in this capture; semantics of the split are an open question (see `EN0034` Evidence Gap 3) |
| Story card | inline | image + overlay banner + countdown badge + title + progress figures | No equivalent card component evidenced elsewhere in the reconstructed WIRE set; closest structural cousin is the public catalogue's story card (`WIRE0001`), not confirmed as the same component |
| Contribution banner overlay | inline | text-on-image banner, "Přispěli jste {amount}" | Mockup-only; no field on `EN0034`'s confirmed `supporter_zone` projection carries a per-user contribution amount joined onto a Campaign card (see Data Bindings) |
| Countdown badge | inline | pill badge, "ZBÝVÁ {N} DNÍ" | Mockup-only; Campaign (`EN0004`) carries a deadline concept in its own right, but no confirmed join into this dashboard card is evidenced |
| Progress figures | inline | plain-text pair "{collected} / {target}" | Mockup-only; corresponds conceptually to Campaign raised/target fields (`EN0004`), not confirmed as sourced from any account-scoped read-model |

---

## Interactions

**Uncertain — none of the following are confirmed interactive behaviours; they are inferred from
what a dashboard of this depicted shape would plausibly do, and are flagged accordingly.**

1. **Entry** — Not evidenced. The mockup is a static graphic inside a marketing e-mail; no route,
   deep link, or menu path into this composed screen exists in the IA (`IA-patronus.md` §8 IA-Q3).
   The e-mail's own CTA ("Dokončit účet") most plausibly routes into account activation/creation
   (`UC0014`), not directly into this dashboard. → state: not determinable.
2. **Primary action — Switch tab ("Pro vás" ⟷ "Všechny (N)")** — **Assumed**: tapping the inactive
   tab would plausibly reveal a different card set (e.g. "all N stories" vs. "your supported
   stories"), consistent with a segmented-control pattern; not observed in motion, no second-tab
   state captured.
3. **Secondary action — Tap story card** — **Assumed**: tapping the card would plausibly navigate to
   a story detail view (paralleling `WIRE0002` on the public site); not evidenced for this
   account-scoped context.
4. **Exit** — Not evidenced.

None of these interactions can be asserted as realizing `UC0024` beyond the general candidate
association recorded in the IA screen map — the UC's Confirmed sub-flows (UC0024.1, UC0024.1b) are
traced to the narrower profile-settings (`WIRE0014`) and donation-history-by-story (`WIRE0021`)
surfaces, not to this composed mockup.

---

## States

### default
The single state visible in the evidence: the "Pro vás" tab selected, showing one story card with a
contribution banner, countdown badge, title, and progress figures, as described in Layout Zones.
**Confirmed** (as depicted in the mockup graphic) — `screencapture-mail-google-mail-u-1-2026-07-04-13_32_45.png`.
Whether this is representative of a real rendered state or purely illustrative sample content for
the marketing graphic is **Uncertain**.

### empty
Not captured. `N/A — Evidence Pending`: no "no supported stories yet" treatment is depicted; the
mockup shows exactly one populated card, chosen for illustrative purposes in a marketing e-mail.

### loading
Not captured. `N/A — Evidence Pending`: a static marketing graphic cannot depict a loading state.

### error
Not captured. `N/A — Evidence Pending`: no error treatment is depicted or evidenced.

---

## Validation Surfaces

No input fields, forms, or user-submitted data are depicted in the mockup — the visible surface is
read-only (a dashboard/summary view). No `BRxxxx` applies.

`validationsWithoutBR`: none identified — this screen, as evidenced, has no validation surface to
flag.

---

## Data Bindings

| Zone | EN-id | QUERY-id | Notes |
|---|---|---|---|
| Story card — supported story / progress figures | `EN0004` (Campaign) | none | Story title and collected/target amounts conceptually correspond to Campaign fields; **Uncertain** whether any real query joins them into an account-scoped card as depicted |
| Contribution banner ("Přispěli jste…") | `EN0034` (DonorAccountView) | none | Conceptually closest to `EN0034`'s confirmed per-Campaign summed-contribution figure, but `EN0034`'s Evidence Gaps explicitly flag that per-story countdown/collection-state fields are **not** present on the confirmed `supporter_zone` projection — this binding is **Hypothesis**, not Confirmed |
| Tab bar count "Všechny (67)" | none found | none | No field, filter, or count on `EN0034` or any sibling view corresponds to this count (`EN0034` Evidence Gap 3) — binding source is **Uncertain/unresolved** |
| (Implied, not visible) donation confirmations / feedback promised in e-mail body copy | `EN0014` (DonationConfirmation, not evidenced as joined) / `EN0021` (Feedback, not evidenced as joined) | none | The e-mail's surrounding marketing copy promises "potvrzení o darech, zpětné vazby" as part of the account, but neither element appears in the mockup graphic itself nor is either confirmed as part of this or any read-model (`EN0034` Relationships) — recorded here only to flag the gap, not as a binding of this screen |

---

## Conditional Visibility

| Component/Zone | Condition (ACL or BR ref) | Behavior when hidden |
|---|---|---|
| Entire screen | Presumed to require an authenticated session holding at least the `supporter` role (by analogy to `EN0034`'s confirmed access rule for the narrower `zona/darce` projection) — **Assumed**, not independently evidenced for this composed screen since it is not confirmed to exist | No ACL layer exists in this reconstruction (`IA-patronus.md` §9); behavior when unauthenticated/ungated is not evidenced |
| "Všechny (N)" tab | Unknown — no condition evidenced; may be visible to all authenticated Users regardless of role (an "all platform stories" count, per `EN0034` Evidence Gap 3) or may itself be role/eligibility-gated | Uncertain |

---

## Accessibility Notes

Not evidenced — the sole piece of evidence is a small marketing-e-mail-embedded illustration of a
mobile UI, not a live/interactive capture or DOM. All of the following are explicitly **not**
determinable:

- **Tab order:** Uncertain — no interactive capture exists.
- **Focus on entry:** Uncertain — no real entry point is evidenced (see Interactions).
- **Focus on state transition:** Uncertain — no state transition was captured.
- **Landmarks:** Uncertain — semantic structure not determinable from a static illustrative graphic.
- **Keyboard shortcuts:** Uncertain — the mockup depicts a mobile-app-style UI; keyboard interaction
  is not applicable/evidenced.

---

## Open Questions

1. **Does this composed dashboard exist as a real, built screen at all?** (`IA-Q3`, carried
   unresolved from the IA and from `EN0034`/`UC0024`.) No route, view, controller, or REST resource
   composing donation history + per-story countdown/collection state + confirmations + feedback was
   located in the Patronus backend source. Resolve by locating the separate donor-facing front-end
   application (not present in this Drupal-backend-only source) or by confirming with the client that
   the mockup is aspirational/future-facing marketing content.
2. **If real, is it the same screen as `WIRE0021` (`S018`, `zona/darce`) with a richer front-end
   composition layered on top, or an entirely separate, uncaptured screen?** The two structurally
   different backing mechanisms (`ProfileResource` REST endpoint vs. `supporter_zone` Drupal View)
   identified in `UC0024` Evidence Pending do not resolve this.
3. **What does "Všechny (67)" mean** — all of the donor's supported stories, or all active platform
   stories regardless of the donor's involvement? Unresolved per `EN0034` Evidence Gap 3.
4. **Are downloadable confirmations and feedback, promised in the surrounding e-mail copy, actually
   part of this dashboard's UI**, or purely aspirational marketing text with no corresponding screen
   element at all (they do not appear in the mockup graphic itself)? See `EN0034` Relationships and
   Evidence Gaps 1/3.

---

## Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Screen's existence as a built application screen | **Uncertain / Hypothesis** — likely NOT built as a real screen | `_ar/spec-draft/IA-screen-map.md` (S017 row, certainty "Uncertain"); `_ar/spec-draft/IA/IA-patronus.md` §8 IA-Q3; `_ar/spec-draft/EN/EN0034_DonorAccountView.md` Evidence Gaps 1/3; `_ar/spec-draft/UC/UC0024_ManageDonorAccount.md` Evidence Pending |
| Mockup graphic layout (tabs, card, banner, badge, title, figures) | Confirmed (as depicted in the graphic; not confirmed as real rendered UI) | `_ar/prtsc/screencapture-mail-google-mail-u-1-2026-07-04-13_32_45.png`; `_ar/evidence/ui/ui-observed-areas.md` §19 |
| Candidate UC realization (`UC0024`) | Probable (candidate only) | `_ar/spec-draft/IA-screen-map.md` S017 row ("UC0024 (Hypothesis)"); `_ar/spec-draft/UI-gap-promotions.md` G-02 |
| Data bindings (`EN0034`, `EN0004`) | Hypothesis — not confirmed as joined in any real read-model | `_ar/spec-draft/EN/EN0034_DonorAccountView.md` Attributes ("Hypothesis — Not evidenced") and Evidence Gaps |
| States other than default | Evidence Pending — not captured | No alternate captures exist for this graphic |
| Interactions | Uncertain — inferred, not observed in motion | Static e-mail-embedded graphic only |
| Accessibility | Uncertain — not determinable | No interactive/DOM capture exists |
