---
doc_id: WIRE0021
title: Donor Zone Moje Zona
canonical_layer: WIRE
spec_type: wireframe
modules: []
screen_id: S018
realizes_uc: [UC0024]
status: draft
references:
  - UC0024
  - EN0034
  - EN0009
  - EN0004
  - EN0008
  - IA-patronus
---

# WIRE0021 – Donor Zone Moje Zona

## Purpose

**Evidence-Pending.** The authenticated donor account screen at `zona/darce` ("Moje zóna"), where a
logged-in party holding the `supporter` role views their own donation history grouped by the
Campaign (Story) they supported. It realizes `UC0024` sub-flow UC0024.1b (view own donation history
by supported story) — see that UC for the full actor/system contract; this document covers only the
screen surface, which is reconstructed from the underlying read-model (`EN0034` — `DonorAccountView`,
backed by the Drupal View `supporter_zone`) and the IA screen map, **not** from a captured screenshot.
No screenshot of this screen exists in `_ar/prtsc/**` or `_ar/evidence/ui/ui-observed-areas.md`
(confirmed absent — see Evidence). Entry context: authenticated navigation via the "Můj účet"
account-zone link, scoped to Users holding the `supporter` role (`EN0034` Invariants;
`IA-patronus.md` §3.6, §4).

A richer dashboard composition (per-story countdown/collection state, downloadable confirmations,
feedback, a "Pro vás / Všechny (67)" tab split) is suggested by a mockup graphic embedded in an
unrelated marketing e-mail (`screencapture-mail-google-mail-u-1-2026-07-04-13_32_45.png`), but this is
**Hypothesis only** — not a captured screen, not confirmed in code (`EN0034` Evidence Gaps 1, 3;
`UC0024` Evidence Pending). This WIRE does **not** reconstruct that mockup as this screen's layout; it
documents only what the `supporter_zone` view's confirmed field/filter contract supports.

---

## Layout Zones

**Assumed** — no screenshot evidence exists for this screen. The following zones are inferred solely
from the `EN0034` read-model contract (two projected columns: Campaign, summed price) and the shared
site chrome documented elsewhere in IA; they are not independently observed.

- **Header (global nav)** — Assumed shared chrome consistent with other authenticated account
  screens (logo, primary nav, "Můj účet" account-menu link) per `IA-patronus.md` §2; not
  screen-specific, not independently observed for this screen.
- **Page title zone** — Assumed heading "Moje zóna" (the Drupal View's page title, per `EN0034`
  Evidence: `views.view.supporter_zone.yml` page title "Moje zóna"). **Probable** (page-title
  string is Confirmed in config; its visual rendering as a heading is Assumed).
- **Main content — donation-history list/table** — Assumed one row per supported Campaign
  (Story), each row showing the Campaign's label and the User's cumulative contributed amount to
  it (the two `EN0034` fields). Exact visual form (table vs. card list vs. grid) is **Uncertain —
  not evidenced**.
- **Footer** — Assumed shared site-footer chrome per `IA-patronus.md` §2; not screen-specific.

No sidebar, tab structure, per-story countdown/collection state, confirmation download links, or
feedback elements are confirmed for this screen (see Purpose — those belong to the unconfirmed
mockup composition, not to this WIRE).

```
+--------------------------------------------------------------+
| Header (Assumed shared chrome) — logo | nav | Můj účet        |
+--------------------------------------------------------------+
| Moje zóna  (Assumed page title)                                |
+--------------------------------------------------------------+
| Main content (Assumed list/table — exact form Uncertain):     |
|   [Campaign A]                          [Suma X Kč]           |
|   [Campaign B]                          [Suma Y Kč]           |
|   ...                                                          |
+--------------------------------------------------------------+
| Footer (Assumed shared chrome)                                 |
+--------------------------------------------------------------+
```

---

## Components Used

The COMP layer does not yet exist for this reconstruction pass; every element is flagged `inline`.
All rows below are **Assumed** unless noted — no screenshot exists to confirm actual component
choice or arrangement.

| Zone | COMP-id | Variant/Props | Notes |
|---|---|---|---|
| Header | inline | global site nav + auth account-menu link | Assumed shared chrome, not independently observed for this screen |
| Page title | inline | H1 | "Moje zóna" — **Probable** (string Confirmed in `views.view.supporter_zone.yml` page title; heading treatment Assumed) |
| Main — donation-history rows | inline | repeating row: Campaign label + summed amount | Two-field row per `EN0034`; visual form (table/list/card) Uncertain — not evidenced |
| Footer | inline | shared site footer | Assumed shared chrome per `IA-patronus.md` §2 |

---

## Interactions

**Assumed / Uncertain throughout** — no screenshot or flow capture exists for this screen; the
following are inferred only from the `UC0024.1b` narrative and the `supporter_zone` view contract.

1. **Entry** — authenticated navigation to `zona/darce` via the "Můj účet" account-zone link
   (route confirmed in `IA-patronus.md` §4, `EN0034` Evidence) → state: `default`. **Probable**
   (route string is Confirmed in config; the specific entry link/click path is Assumed by analogy
   to sibling account screens, not independently observed for this screen).
2. **Primary action** — none confirmed. The screen as reconstructed is **read-only** (the
   `supporter_zone` view projects data; it exposes no observed write/submit action). **Uncertain**
   whether each row links onward to the Campaign's own story-detail screen (S002) — plausible by
   general site convention but not evidenced for this specific view.
3. **Secondary action** — none evidenced.
4. **Exit** — Assumed via header nav (e.g. back to another "Můj účet" sub-page or any global nav
   link); no unsaved-changes concern applies to a read-only screen. **Uncertain** — not observed.

---

## States

### default
Assumed to render one row per Campaign the current User has at least one PAID, donation-flagged
Transaction against, with the summed contributed amount per Campaign, per `EN0034`'s confirmed
field/filter contract (`UC0024.1b` steps 1–3). **Probable** (data contract is Confirmed in code;
visual rendering is Assumed — not screenshotted).

### empty
Shown when: the current User holds the `supporter` role but has zero Campaigns matching the
view's filter (all their Transactions are non-donation, unpaid, or excluded some other way) —
an edge case not explicitly discussed in `UC0024` or `EN0034`. `Evidence Pending — not captured`:
no empty-state message, illustration, or copy is evidenced. Note per `EN0034` Invariants: a donor
with **no** paid donations at all would not hold the `supporter` role and would not reach this
screen in the first place (see Conditional Visibility) — so this empty state, if it exists, applies
only to the narrower edge case above, not to a first-time visitor.

### loading
`N/A — Evidence Pending`: no loading/skeleton state was observed or described for the initial
list-fetch; not captured in any available evidence.

### error
`N/A — Evidence Pending`: no error state (e.g. failed data fetch) was observed or described in any
available evidence.

---

## Validation Surfaces

No BR document in `_ar/spec-draft/BR/` covers this screen — it is reconstructed as **read-only**
(a projection view with no observed write/submit action), so no field-level validation is expected.

| Field/Zone | Trigger (BR-id) | Surface |
|---|---|---|
| — | none found | Not applicable — screen has no observed input fields or submit actions; `EN0034` documents a read-only projection with no writer |

`validationsWithoutBR`: none identified — no input surface was found to require validation. This
is a structural absence (read-only screen), not an unresolved validation question.

---

## Data Bindings

| Zone | EN-id | QUERY-id | Notes |
|---|---|---|---|
| Main — donation-history rows | `EN0034` | none | `DonorAccountView` projection: Campaign (grouping key, → `EN0004`) + summed contributed amount (`sum(price)` over `EN0009` Transactions where `ext_status = PAID` and `is_donation = 1`), scoped to the current session's `EN0008` User via `current_user` argument. **Confirmed** field/filter contract (`EN0034` Evidence); screen-level rendering of these bindings is Assumed. |

No per-story countdown/collection-state fields, downloadable-confirmation links (`EN0014`), or
feedback references (`EN0021`) are bound here — `EN0034` explicitly documents these as
**not evidenced** in the underlying projection (mockup-only; see `EN0034` Evidence Gaps 1, 3).

---

## Conditional Visibility

| Component/Zone | Condition (ACL or BR ref) | Behavior when hidden |
|---|---|---|
| Entire screen | Requires the `supporter` role (observed access rule: `type: role`, `role: supporter` in `views.view.supporter_zone.yml`, per `EN0034` Evidence). Per `EN0034` Invariants (and `DOMAIN-kernel.md` INV21), the `supporter` role is auto-granted only after a User's first PAID Transaction. | No ACL layer exists in this reconstruction (per `IA-patronus.md` §9); behavior for an authenticated User **without** the `supporter` role (e.g. hidden nav link vs. 403/redirect on direct navigation) is **Uncertain — not evidenced**. |

---

## Accessibility Notes

Not evidenced — no screenshot or markup capture exists for this screen. The following are `Assumed`
best-practice expectations only, not confirmed observations:

- **Tab order:** Uncertain — not evidenced; a read-only list screen may have minimal or no
  interactive tab stops beyond header nav and any onward row links (if such links exist — Uncertain,
  see Interactions).
- **Focus on entry:** Uncertain — not evidenced.
- **Focus on state transition:** Uncertain — no state transition was captured or described.
- **Landmarks:** Uncertain — semantic structure (e.g. `<table>`/`<ul>`, heading hierarchy) not
  determinable without a capture.
- **Keyboard shortcuts:** None observed or expected.

---

## Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Screen exists, route, page title, role-gate, data contract | Confirmed | `_ar/spec-draft/EN/EN0034_DonorAccountView.md` — `sync_config/config_czech/views.view.supporter_zone.yml` |
| UC realization (UC0024.1b) | Confirmed | `_ar/spec-draft/UC/UC0024_ManageDonorAccount.md` §UC0024.1b |
| Layout zones, visual arrangement, exact components | Assumed | No screenshot exists; `_ar/evidence/ui/ui-observed-areas.md` has no entry for `zona/darce` / "Moje zóna" |
| Richer dashboard composition (countdown, confirmations, feedback, tabs) | Hypothesis — explicitly NOT this screen's confirmed layout | `screencapture-mail-google-mail-u-1-2026-07-04-13_32_45.png` (embedded e-mail mockup, unrelated marketing asset) — see `EN0034` Evidence Gaps 1, 3 and `UC0024` Evidence Pending |
| Empty / loading / error states | Evidence Pending — not captured | No screenshot or flow evidence exists for any of the three non-default states |
| Validation surfaces | N/A (read-only screen) | `EN0034` documents no writer for this projection |
| Role-gating (`supporter` role) | Confirmed (backend rule); Uncertain (front-end visible behavior) | `EN0034` Evidence / Invariants |
| RO/MD equivalence of this screen | Uncertain | `EN0034` Evidence Gap 2 — `supporter_zone` view found only in `config_czech` split |
