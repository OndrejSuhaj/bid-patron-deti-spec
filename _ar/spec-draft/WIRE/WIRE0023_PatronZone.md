---
doc_id: WIRE0023
title: Patron Zone
canonical_layer: WIRE
spec_type: wireframe
modules: []
screen_id: S020
realizes_uc: [UC0024]
status: draft
references:
  - UC0024
  - EN0001
  - EN0005
  - EN0034
  - IA-patronus
---

# WIRE0023 – Patron Zone

## Purpose

The patron's own role-gated self-service zone at `zona/patron` ("Patron zone" per the IA screen
map), where a logged-in party holding the patron role is expected to view their own
Applications/Stories. It is grouped under the composed "Můj účet" account area alongside the donor
zone (`zona/darce`, S018) and the applicant/fundraiser zone (`zona/zadatel`, S019), and is recorded
as `UC0024`-adjacent — no dedicated UC sub-flow documents its actual read contract; `UC0024` covers
the account self-service capability in general (profile view/edit, UC0024.1/UC0024.2) and the
sibling donor-zone read-model (UC0024.1b / `EN0034`) in detail, but **not** a patron-zone-specific
flow. This WIRE cites `UC0024` per the IA Screen Map assignment; see Evidence below for the gap.

**No screenshot exists for this screen** (`_ar/spec-draft/IA-screen-map.md` row S020: "screen not
captured"). This document is an **Evidence-Pending** reconstruction: it records only what the
IA/EN/UC evidence supports and marks layout, states, and behavior as `Assumed`/`Uncertain` rather
than fabricating visual detail — per `tooling/docs/rules-WIRE.md` evidence convention.

---

## Layout Zones

**Evidence Pending — not captured.** No screenshot or DOM/template evidence exists for this
screen's layout. The only structural fact available is that a Drupal View named `patron_zone`
(`base_table: application`, path `zona/patron`) backs the page (`EN0034` Evidence, corroborating
context; `_ar/spec-draft/EN/EN0034_DonorAccountView.md` lines 58–63). By analogy with the
sibling `supporter_zone` view (`EN0034`, confirmed for S018) and the shared "Můj účet" chrome
observed elsewhere (`WIRE0014`), the following zones are **Assumed**, not confirmed:

- Header — global site nav + authenticated "Můj účet" account-menu link (**Assumed**, by analogy
  with every other authenticated screen; not independently observed for S020).
- Main content — a listing of the current patron User's own Application(s)/Story(ies)
  (`EN0001`), one row/card per Application, analogous in shape to `supporter_zone`'s one-row-
  per-Campaign layout (**Assumed** — the `patron_zone` view's actual field/column composition
  is not evidenced; see Evidence Gaps).
- Footer — shared site-footer chrome (**Assumed**, per `IA-patronus.md` §2).

No ASCII sketch is provided: fabricating a layout diagram without evidence would violate the
evidence-first discipline (`CLAUDE.md`; `rules-WIRE.md`).

---

## Components Used

The COMP layer does not yet exist for this reconstruction pass; every element below is flagged
`inline`, and every row is `Assumed` (no capture exists to confirm actual components).

| Zone | COMP-id | Variant/Props | Notes |
|---|---|---|---|
| Header | inline | global site nav + auth account-menu link | **Assumed** by analogy with `WIRE0014`/`WIRE0018` (donor zone); not observed for S020 |
| Main — Application/Story listing | inline | list/table or card-list of the patron's own Application(s) | **Assumed** — shape inferred from the sibling `patron_zone` View existing with `base_table: application` (`EN0034`); no field list, row template, or empty-state copy is evidenced |
| Footer | inline | shared footer chrome | **Assumed**, per `IA-patronus.md` §2 |

---

## Interactions

1. **Entry** — authenticated navigation to `zona/patron`, entered from the "Môj účet"/account-zone
   area for a User holding the patron role → state: `default`. **Assumed** route
   (`IA-patronus.md` §4 entry-points table lists `zona/patron` → S020 → `UC0024`, certainty
   Assumed); the actual triggering link/menu item is not evidenced (IA-Q4).
2. **Primary action** — Not evidenced. Whether the screen supports any action beyond viewing (e.g.
   opening an Application detail, editing patron-visible fields) is **Uncertain** — no capture, no
   route/controller for a patron-facing write path was located in the UC0024/EN0034 evidence
   reviewed for this screen.
3. **Secondary action** — Not evidenced.
4. **Exit** — Not evidenced. **Assumed** exit via global header nav, consistent with every other
   authenticated account screen; not independently observed for S020.

---

## States

### default
Not evidenced. **Assumed**, by analogy with the sibling `supporter_zone` donor-zone screen
(`WIRE0018`/`EN0034`): a list of the patron's own Application(s)/Story(ies) is expected to render.
No field composition, copy, or visual treatment is confirmed for S020 itself.

### empty
Not evidenced. `Assumed`: a patron with no linked Application would presumably see an empty-state
message, by analogy with a zero-row donor-zone result, but no copy or visual treatment is captured
for this screen. Flagged as an Open Question rather than invented.

### loading
Not captured. `N/A — Evidence Pending`: no loading/skeleton state was observed for this screen (no
screenshot exists at all).

### error
Not captured. `N/A — Evidence Pending`: no error state was observed for this screen (no screenshot
exists at all).

---

## Validation Surfaces

No validation surface is evidenced. If this screen is view-only (consistent with the sibling
`supporter_zone` donor-zone view being a read-only Drupal View per `EN0034`), no BR-gated
validation would be expected at all — but this is **Uncertain**, not confirmed, since no capture or
controller for `patron_zone` itself was reviewed.

| Field/Zone | Trigger (BR-id) | Surface |
|---|---|---|
| (none evidenced) | none found | Uncertain — no field or action on this screen is evidenced as user-editable; no `BRxxxx` applies |

`validationsWithoutBR`: whether the patron zone exposes any editable field or action at all is
itself unresolved (see Evidence Gaps / Open Questions) — recorded as an open question rather than a
concrete validation gap, since no field is even confirmed to exist on this screen.

---

## Data Bindings

| Zone | EN-id | QUERY-id | Notes |
|---|---|---|---|
| Main — Application/Story listing | `EN0001` (Application) | none | **Assumed** — the sibling `patron_zone` Drupal View has `base_table: application` (`EN0034` line 60), implying rows are drawn from Application records scoped to the current patron User; the actual field projection (which Application attributes are shown) is **not evidenced** — unlike `supporter_zone`, whose exact two-column (`campaign`, summed `price`) projection is confirmed, `patron_zone`'s field list was not inspected/confirmed in this pass |
| Main — patron display info (if any) | `EN0005` (Patron) | none | **Uncertain** — `EN0005` is the public-facing patron display profile shown on a Campaign page, distinct from the patron role held by a User; whether this self-service zone surfaces `EN0005` fields (vs. only `EN0001` Application rows) is not evidenced |

---

## Conditional Visibility

| Component/Zone | Condition (ACL or BR ref) | Behavior when hidden |
|---|---|---|
| Entire screen | Role-gated to Users holding the patron role (**Assumed**, by analogy with `supporter_zone`'s confirmed `role: supporter` access restriction, `EN0034`); no ACL layer exists in this reconstruction and no `patron_zone`-specific role restriction was independently confirmed (`IA-patronus.md` IA-Q4) | Not evidenced — behavior for a non-patron authenticated User (403 vs. redirect vs. hidden nav entry) is **Uncertain** |
| "Můj účet" / account-zone nav entry to this screen | Same role-gate condition | Not evidenced whether the nav entry itself is conditionally shown only to patron-role Users, or always shown with access enforced only at the destination | 

---

## Accessibility Notes

Not evidenced — no screenshot or markup exists for this screen. All items below are `Assumed`
best-practice placeholders, not confirmed observations:

- **Tab order:** Assumed top-to-bottom through any listing rows, consistent with standard list
  markup. Not confirmed.
- **Focus on entry:** Uncertain — not evidenced.
- **Focus on state transition:** Uncertain — not evidenced (no state transition captured at all).
- **Landmarks:** Uncertain — semantic structure not determinable without a capture.
- **Keyboard shortcuts:** None observed or expected beyond standard navigation.

---

## Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Screen exists, route `zona/patron`, screen_id S020 | Probable | `_ar/spec-draft/IA-screen-map.md` row S020; `_ar/spec-draft/IA/IA-patronus.md` §4 entry-points table |
| Backing mechanism is a `patron_zone` Drupal View, `base_table: application` | Confirmed (as corroborating context, not independently re-verified for this WIRE pass) | `_ar/spec-draft/EN/EN0034_DonorAccountView.md` lines 58–63 |
| Layout, components, copy, field composition | Uncertain / Evidence Pending — not captured | No screenshot exists for S020; no dedicated `patron_zone` view YAML was inspected in this pass (only referenced as sibling context in EN0034) |
| Role-gate (patron role required) | Assumed | By analogy with `supporter_zone`'s confirmed `role: supporter` access restriction (`EN0034`); not independently confirmed for `patron_zone` — see `IA-patronus.md` IA-Q4 |
| UC realization (`UC0024`) | Probable | `_ar/spec-draft/IA-screen-map.md` assigns `UC0024` to S020 with certainty "Assumed"; `UC0024` itself documents profile view/edit (UC0024.1/.2) and the donor-zone donation-history sub-flow (UC0024.1b) but does **not** contain a patron-zone-specific sub-flow — recorded as a gap, not resolved silently |
| States (empty/loading/error) | Evidence Pending — not captured | No screenshot evidence for any state |

---

## Evidence Gaps

- **No screenshot or capture exists for `zona/patron` (S020).** All layout, component, copy, and
  state detail in this document is `Assumed` by analogy with the sibling `zona/darce` (S018,
  `supporter_zone`) screen and generic account-zone chrome — never independently observed. Per
  `IA-patronus.md` IA-Q4, this is an open IA question ("What are the role-gates and actual screens
  for `zona/zadatel` (S019) and `zona/patron` (S020)?").
- **`UC0024` does not contain a patron-zone-specific sub-flow.** UC0024.1/.2 cover profile
  view/edit; UC0024.1b covers the donor-zone (`supporter_zone`) donation-history-by-story
  projection. No equivalent sub-flow documents what the `patron_zone` View actually projects
  (field list, filters, argument scope) — this WIRE cannot cite a UC step for its main-content
  binding beyond the IA Screen Map's UC assignment. Recommend a UC0024 follow-up (or a new UC) once
  the `patron_zone` View config and any patron-facing screen capture become available.
  Flagged as `validationsWithoutBR` / open question rather than resolved by inference.
- **Role-gate mechanics are unconfirmed.** Whether `patron_zone` (like `supporter_zone`) uses
  `access: type: role` restricted to a specific role (e.g. a `patron` role on `EN0008` User) was
  not independently verified in this pass — recorded here as Assumed, consistent with `EN0034`'s
  own scoping of `patron_zone` as "out of scope" corroborating context only.
- **RO/MD equivalence unknown** — consistent with the sibling `supporter_zone`/`fundraiser_zone`
  views being CZ-config-split-only (`EN0034` Evidence Gap 2); not separately re-investigated for
  `patron_zone` in this pass.

## Open Questions

1. What does the `patron_zone` Drupal View actually project (fields, filters, current-user
   argument scope, access role) — analogous to `supporter_zone`'s confirmed two-column
   (Campaign, summed price) contract? Not inspected in this pass. Decider: Architect (code
   follow-up on `views.view.patron_zone.yml`).
2. Is this screen composed into the same "Můj účet" area as S018/S019, or a fully separate
   role-gated page with its own chrome? Carried from `IA-patronus.md` IA-Q2/IA-Q4, unresolved.
3. Should a dedicated UC sub-flow (or new UC) be authored for the patron-zone read contract once
   evidence is available, rather than this WIRE citing `UC0024` without a matching sub-flow?
   Decider: UX-lead + architect (re-capture / code follow-up).
