---
doc_id: WIRE0005
title: Role Choice Landing
canonical_layer: WIRE
spec_type: wireframe
modules: []
screen_id: S006
realizes_uc: [UC0001]
status: draft
references:
  - UC0001
  - EN0001
  - IA-patronus (S006, IA-Q1, IA-Q12)
---

# WIRE0005 – Role Choice Landing

## Purpose

**Evidence-Pending WIRE — no screenshot captured for this screen.** This document reconstructs S006
from indirect evidence only: the IA screen map, the twig template that renders its two outgoing links,
and the UC0001 flow it starts. It must not be read as a visual reconstruction; it records what can be
inferred and flags everything else as an open question.

S006 is the entry point into the Application (Žádost) intake, reached from the "Požádat o pomoc" nav
CTA and the footer "Chci přihlásit příběh" link (`_ar/spec-draft/IA/IA-patronus.md` §2). Its job is to
let an anonymous visitor pick which of the two intake roles applies to them — "help my child"
(fundraiser/žadatel) vs. "help a child I know" (patron) — before entering UC0001.1
(Customer self-registration). The choice sets `EN0001` Application's `lead_role` attribute
(`patron` / `fundraiser`) at creation. Actor: anonymous visitor (Customer, pre-registration).

**Screen identity itself is Uncertain.** No screenshot exists showing this page rendered; its
existence is inferred from a Drupal twig template that emits two hard-coded outbound links, not from
a captured page. See `_ar/spec-draft/IA/IA-patronus.md` IA-Q1 (URL of this screen: `/zadost`? 
`/pozadat-o-pomoc`? both alias one view?) and `_ar/evidence/gap-closure-evidence.md` OQ-01.

---

## Layout Zones

Evidence Pending — no screenshot exists for this screen; the layout below is Assumed, derived only
from the two role-card links found in
`web/themes/custom/patron_cz/templates/views/views-view--supporter-zone.html.twig:162-179`
(cited in `_ar/evidence/gap-closure-evidence.md` OQ-01) plus the site-wide chrome pattern observed on
every other captured public screen (`_ar/evidence/ui/ui-observed-areas.md` §1, §6).

- Header — global site nav ("Požádat o pomoc", "Můj účet", "Jak to funguje", "Blog", "O nás") —
  Assumed present by site-wide pattern; not itself captured on this screen.
- Main content — two role-selection cards, side by side or stacked:
  - Card A: "help my child" (fundraiser/žadatel role) → links to `/zadost/zadatel` (S007)
  - Card B: "help a child I know" (patron role) → links to `/zadost/patron` (patron intake, uncaptured)
  (Card copy/labels as rendered in Czech are not evidenced verbatim — the twig evidence names the
  link targets and an English gloss "I want to help my child" / "I want to help a child I know"; see
  `_ar/evidence/gap-closure-evidence.md` OQ-01. Exact Czech card copy: Evidence Pending — COPY layer.)
- Sidebar — none evidenced; Assumed absent (no sidebar pattern seen elsewhere in public site captures).
- Footer — global site footer (collection account, footer link cluster) — Assumed present by
  site-wide pattern (`_ar/spec-draft/IA/IA-patronus.md` §2); not itself captured on this screen.

```
+--------------------------------------------------+
| Header (global nav)                     [Assumed]|
+--------------------------------------------------+
|         Main content                              |
|   +----------------+   +----------------+         |
|   | Card: fundraiser|  | Card: patron    |         |
|   | -> /zadost/zadatel| | -> /zadost/patron|        |
|   +----------------+   +----------------+         |
+--------------------------------------------------+
| Footer (global)                          [Assumed]|
+--------------------------------------------------+
```

---

## Components Used

All entries flagged `inline` — the COMP layer does not yet exist for this reconstruction pass.

| Zone | COMP-id | Variant/Props | Notes |
|---|---|---|---|
| Header | inline | global site nav | Assumed present; not captured on this screen; pattern from `ui-observed-areas.md` §1 |
| Main — Card A | inline | role-selection card, "fundraiser/žadatel" | Uncertain visual form (card/button/tile); only the outbound link + role semantics are evidenced |
| Main — Card B | inline | role-selection card, "patron" | Uncertain visual form; same caveat as Card A |
| Footer | inline | global site footer | Assumed present; not captured on this screen |

---

## Interactions

1. **Entry** — visitor clicks "Požádat o pomoc" (nav) or "Chci přihlásit příběh" (footer) →
   state: `default`. Exact route into S006 itself Uncertain (IA-Q1).
2. **Primary action — select fundraiser role** — click/tap Card A → navigates to `/zadost/zadatel`
   (S007, contact/consent gate); realizes `UC0001` (UC0001.1 step 1, role = fundraiser); next screen: S007.
3. **Primary action — select patron role** — click/tap Card B → navigates to `/zadost/patron`
   (patron intake — screen not captured, IA-Q12); realizes `UC0001` (UC0001.1 step 1, role = patron);
   next screen: Uncaptured.
4. **Exit** — no cancel/back action evidenced for S006 itself (it is an entry landing, not a step
   inside the wizard); a returning visitor from S007 uses "Zpět na výběr" to come back to S006
   (`_ar/evidence/ui/ui-observed-areas.md` §6).

No other interaction (search, filter, secondary CTA) is evidenced for this screen. Whether S006
carries any content beyond the two role cards (explainer text, FAQ, trust signals) is Uncertain —
not evidenced either way.

---

## States

### default
Two role cards presented, both selectable, no prior selection persisted (nothing in evidence
suggests a "remember my last choice" behavior). Assumed — not screenshot-confirmed.

### empty
`N/A — not applicable`. This is a static role-selection landing with a fixed pair of choices; there
is no data-driven "no items" condition.

### loading
`N/A — Uncertain`. No evidence of an async data fetch on this screen (the two cards' targets are
presumably static routes per the twig evidence); if the screen composes any dynamic content (e.g. a
personalized greeting for an authenticated Customer), a loading state would apply, but this is not
evidenced. Recorded as an open question rather than asserted either way.

### error
`Evidence Pending — not captured`. No error condition is observed or inferable for a screen whose
only actions are outbound navigation links; if role selection itself can fail (e.g. blocked route),
behavior is Uncertain.

---

## Validation Surfaces

No form fields exist on this screen per current evidence — it is a binary role-choice landing, not a
data-entry step. No validation surface applies.

| Field/Zone | Trigger (BR-id) | Surface |
|---|---|---|
| — | — | N/A — no form fields evidenced on S006 |

**validationsWithoutBR:** none — there is nothing to validate on this screen per available evidence.

---

## Data Bindings

| Zone | EN-id | QUERY-id | Notes |
|---|---|---|---|
| Main — role choice outcome | `EN0001` | — | The selection made here sets `EN0001` Application's `lead_role` attribute (`patron` / `fundraiser`) at creation time in `UC0001` (UC0001.1 step 8); S006 itself does not read/display Application data — it only originates the role value. No QUERY-id evidenced (no read model backs this screen). |

---

## Conditional Visibility

| Component/Zone | Condition (ACL or BR ref) | Behavior when hidden |
|---|---|---|
| Whole screen | none evidenced | No role-gating found — screen is intended for anonymous visitors (Customer, pre-registration); `_ar/spec-draft/IA/IA-patronus.md` §9 notes no ACL layer exists in this reconstruction. Whether an already-authenticated Customer is redirected away from S006 (per `UC0001` precondition: "an already-authenticated Customer is routed directly into the Application without repeating identity capture") is Uncertain — not observed on this screen; recorded as an open question rather than asserted. |

---

## Accessibility Notes

Evidence Pending — not captured. No screenshot exists to confirm tab order, focus behavior, landmark
roles, or keyboard interaction for this screen. Recorded as an open question; do not fabricate.

- **Tab order:** Uncertain.
- **Focus on entry:** Uncertain.
- **Focus on state transition:** Uncertain.
- **Landmarks:** Uncertain.
- **Keyboard shortcuts:** none evidenced.

---

## Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Screen exists as a distinct role-choice landing | Probable | `_ar/spec-draft/IA-screen-map.md` row S006; `_ar/spec-draft/IA/IA-patronus.md` §3.3 |
| Two role cards ("help my child" / "help a child I know") with links to `/zadost/zadatel` and `/zadost/patron` | Confirmed (code) / Uncertain (visual) | `web/themes/custom/patron_cz/templates/views/views-view--supporter-zone.html.twig:162-179`, cited in `_ar/evidence/gap-closure-evidence.md` OQ-01. No screenshot exists — visual layout/copy is Assumed, not observed. |
| Screen's own URL | Uncertain | `_ar/evidence/gap-closure-evidence.md` OQ-01 residual note; `_ar/spec-draft/IA/IA-patronus.md` IA-Q1 |
| Global nav/footer chrome present on this screen | Assumed | pattern from `_ar/evidence/ui/ui-observed-areas.md` §1, §6 (other public screens); not itself captured on S006 |
| "Zpět na výběr" return link on S007 implies this screen precedes it | Confirmed | `_ar/evidence/ui/ui-observed-areas.md` §6; `_ar/spec-draft/IA/IA-patronus.md` §3.3 |
| Role choice sets `EN0001.lead_role` | Confirmed | `_ar/spec-draft/EN/EN0001_Application.md` attributes; `_ar/spec-draft/UC/UC0001_SubmitApplication.md` UC0001.1 step 8 |
| Layout zones, states (default/empty/loading/error), accessibility | Uncertain / Assumed | No screenshot captured for S006 — see Purpose section |
