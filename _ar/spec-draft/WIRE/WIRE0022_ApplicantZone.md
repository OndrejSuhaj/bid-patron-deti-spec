---
doc_id: WIRE0022
title: Applicant Zone
canonical_layer: WIRE
spec_type: wireframe
modules: []
screen_id: S019
realizes_uc: [UC0024]
status: draft
references:
  - UC0024
  - EN0001
  - EN0034
  - BR-AccessControlAndRoles
---

# WIRE0022 – Applicant Zone

## Purpose

`zona/zadatel` — the applicant (fundraiser)'s own account zone, listing the fundraiser's own
Applications (Žádosti, `EN0001`). This is the sibling surface to the donor zone (`zona/darce`, S018)
and the patron zone (`zona/patron`, S020): all three are role-gated per-role "account zone" pages
backed by classic Drupal Views over different base tables. `zona/zadatel` is backed by
`views.view.fundraiser_zone.yml` (`base_table: application`), corroborated only as sibling context
inside `EN0034`'s evidence — the view itself has **not** been separately reconstructed as its own EN,
and **no screen capture of `zona/zadatel` exists** in the evidence set (`_ar/evidence/ui/ui-observed-areas.md`
has no section for this screen; IA-screen-map row S019 records "screen not captured").

This screen is carried in the IA purely because a sibling, structurally-identical, code-confirmed
view (`fundraiser_zone`) exists alongside the code-confirmed and screen-evidenced `supporter_zone`
(`zona/darce`, S018/EN0034) — see IA-Q4 (`_ar/spec-draft/IA/IA-patronus.md` §8). Per the WIRE
evidence convention this document is written as an **Evidence-Pending** wireframe: it records what
the IA/EN/UC layers support and does not fabricate any visual layout, field list, or interaction
beyond that. **Certainty: Assumed** (per IA screen map), carried through to every claim below unless
narrower evidence is cited.

Candidate realizing use case: `UC0024` (Manage Donor Account (Self-Service)) — cited by the IA screen
map as the nearest documented UC for all three account-zone screens (S018/S019/S020), though `UC0024`
as currently written documents only the profile-settings sub-flow (UC0024.1/.2, `/muj-ucet/nastaveni`)
and the donor-zone donation-history sub-flow (UC0024.1b, `EN0034`) — it does **not** contain a
fundraiser-zone sub-flow describing what `zona/zadatel` shows or does. This UC attribution is
therefore itself Assumed / by analogy, not a direct match — see Open Questions.

---

## Layout Zones

**Evidence Pending — not captured.** No screenshot, code-derived template, or Twig/View-display
evidence describing the visual layout of `zona/zadatel` exists in this evidence set. The only
structural fact available is that the view's `base_table` is `application` (`EN0001`), i.e. the
screen is expected to list Application records rather than Transaction or Campaign records (by
analogy with `EN0034`'s `supporter_zone`, whose `base_table` is `transaction`) — Assumed by structural
analogy to the sibling `supporter_zone`/S018 pattern, not directly observed for this view.

No layout zones (header/main/sidebar/footer composition, row/card presentation, filters, pagination)
can be asserted. Do not infer the S018 (`zona/darce`) layout onto this screen — the two views differ
in `base_table` and column set is unconfirmed for `fundraiser_zone`.

```
Evidence Pending — no ASCII layout sketch possible without a capture or a reconstructed
views.view.fundraiser_zone.yml field list.
```

---

## Components Used

The COMP layer does not yet exist in this reconstruction pass; in any case, no component can be
asserted for this screen without visual or field-level evidence.

| Zone | COMP-id | Variant/Props | Notes |
|---|---|---|---|
| (whole screen) | inline | — | Evidence Pending — not captured; no component inventory possible |

---

## Interactions

**Evidence Pending — not captured.** No entry route confirmation beyond the IA-recorded path
`zona/zadatel`, no observed primary/secondary actions, and no observed exit paths.

1. **Entry** — presumed `zona/zadatel` (per IA screen map / IA-patronus.md §4 route table) while
   authenticated as the fundraiser role → state: `default` — Assumed (route path is code/IA-recorded,
   not screen-confirmed; see `_ar/spec-draft/IA/IA-patronus.md` §4).
2. **Primary action** — Uncertain. By analogy with `EN0034`/S018 this would be viewing one's own
   Application list; whether a row is clickable (e.g. into an Application detail) is not evidenced.
3. **Secondary action** — Uncertain — not evidenced.
4. **Exit** — Uncertain — not evidenced.

---

## States

### default
**Evidence Pending — not captured.** No screenshot or field-level view definition exists to describe
what a populated `zona/zadatel` screen shows (which Application fields/status are surfaced per row,
sort order, grouping).

### empty
**Evidence Pending — not captured.** Whether an applicant with no Applications sees an empty-state
message, a call-to-action to start an Application, or an empty list with no messaging is Uncertain.

### loading
`N/A — no interactive/async behaviour evidenced for this screen; a classic Drupal View is typically
server-rendered on request rather than client-side-loaded, but this is Assumed by platform pattern,
not observed for this specific view.`

### error
**Evidence Pending — not captured.** No error condition (e.g. access-denied for a non-fundraiser
role, or a server error) has been observed for this screen.

---

## Validation Surfaces

No form input is evidenced on this screen (it is presumed a read-only list view by analogy with
`EN0034`'s `supporter_zone`), so no validation surface is asserted.

| Field/Zone | Trigger (BR-id) | Surface |
|---|---|---|
| (none evidenced) | — | — |

**validationsWithoutBR:** none — no validated field is evidenced on this screen to begin with.

---

## Data Bindings

| Zone | EN-id | QUERY-id | Notes |
|---|---|---|---|
| Main list (presumed) | `EN0001` (Application) | — | Assumed by structural analogy: the underlying Drupal View's `base_table` is `application`, corroborated only as sibling context inside `EN0034`'s evidence (`views.view.fundraiser_zone.yml`, not independently reconstructed as its own EN/QUERY doc-id in this pass) — Probable at the base-table level, Uncertain at the field/column level (no field list evidenced, unlike `EN0034`'s confirmed two-column `campaign`+`price` projection). |

No dedicated read-model entity (equivalent to `EN0034` for `zona/darce`) has been reconstructed for
`zona/zadatel` in this pass — see Open Questions.

---

## Conditional Visibility

| Component/Zone | Condition (ACL or BR ref) | Behavior when hidden |
|---|---|---|
| Whole screen (`S019`) | Role-gated to the fundraiser role — Assumed by analogy with `EN0034`'s confirmed `supporter`-role gate on the sibling `zona/darce` view (`type: role`, `role: supporter`); no equivalent role-restriction evidence (e.g. a `views.view.fundraiser_zone.yml` access-plugin config) was located/cited for `fundraiser_zone` in this pass. No `ACLxxxx` layer exists yet to cite. `BR-AccessControlAndRoles` documents the automatic `supporter`-role grant mechanism but does **not** document an equivalent automatic-grant or gate for a fundraiser role — this is a gap, not a confirmed rule. | Uncertain — not evidenced (Assumed: likely redirected to login or shown an access-denied response for a non-fundraiser/unauthenticated visitor, consistent with platform-wide auth patterns, but not observed for this route) |

This is carried forward from IA-Q4 (`_ar/spec-draft/IA/IA-patronus.md` §8): "What are the role-gates
and actual screens for `zona/zadatel` (S019) and `zona/patron` (S020)?" — open, unresolved by this
WIRE pass.

---

## Accessibility Notes

**Evidence Pending — not captured.** No tab order, focus behaviour, landmark structure, or keyboard
interaction can be asserted without a screen capture or rendered markup for this route.

- **Tab order:** Uncertain — not evidenced.
- **Focus on entry:** Uncertain — not evidenced.
- **Focus on state transition:** Uncertain — not evidenced.
- **Landmarks:** Uncertain — not evidenced.
- **Keyboard shortcuts:** None evidenced; none expected beyond standard list-page navigation (Assumed).

---

## Open Questions

- **No screen capture of `zona/zadatel` exists.** Every layout, component, interaction, and state
  claim above beyond "the underlying view's base_table is `application`" is Uncertain or Assumed by
  analogy with the sibling, screen-evidenced `zona/darce` (S018/`EN0034`). Recommend a targeted
  re-capture (UX-lead) before this WIRE can be promoted beyond Evidence-Pending status.
- **`UC0024` does not contain a fundraiser-zone sub-flow.** The UC currently documents only
  UC0024.1/.2 (profile settings) and UC0024.1b (donor-zone donation history, `EN0034`). Attributing
  `S019` to `UC0024` follows the IA screen map's candidate-UC column but is not a direct behavioural
  match — either `UC0024` needs a `UC0024.1c`-equivalent sub-flow authored from `fundraiser_zone`
  evidence, or a separate UC should be minted once the screen and its backing view are reconstructed.
  Flag for UC-layer follow-up, not resolved by this WIRE.
- **No `EN` doc-id exists for the `fundraiser_zone` view's read-model contract**, unlike `EN0034` for
  `supporter_zone`. Field list (which `EN0001` Application attributes are projected — e.g. status,
  campaign link, child name), filters, grouping, and role-access-plugin configuration are all
  unresolved; the view is known only as sibling corroborating context inside `EN0034`'s Evidence
  section (`_ar/spec-draft/EN/EN0034_DonorAccountView.md`).
- **Role-gate mechanism is unconfirmed.** Whether `fundraiser_zone` uses the same `type: role`
  access-plugin pattern as `supporter_zone` (and if so, against which role machine-name — `fundraiser`
  is assumed by the route/view naming but not confirmed against a `config/user.role.*.yml` file the
  way `supporter` is for S018), or a different mechanism (e.g. `current_user` argument only, with no
  role restriction, making it reachable by any authenticated user) is Uncertain. This is the same gap
  recorded as IA-Q4.
- **RO/MD equivalence unresolved** — by analogy with `EN0034` Evidence Gap 2 (which flags this for
  `supporter_zone`), whether `fundraiser_zone` exists under `config_czech` only or has RO/MD
  equivalents is unresolved and not separately investigated in this pass.
- Whether `zona/zadatel` is presented standalone or composed into a wider "Můj účet" dashboard
  (per the `S017` mockup hypothesis and IA-Q2/IA-Q3) is unresolved for this screen specifically, same
  as for S018.

---

## Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Screen exists as a distinct route (`zona/zadatel`) | Assumed | `_ar/spec-draft/IA-screen-map.md` row S019; `_ar/spec-draft/IA/IA-patronus.md` §4 route table |
| Underlying view base_table = `application` | Probable | `_ar/spec-draft/EN/EN0034_DonorAccountView.md` Evidence section (cites `views.view.fundraiser_zone.yml`, `base_table: application`, path `zona/zadatel`, as sibling corroborating context — not independently verified by this WIRE pass) |
| Layout, components, interactions, states (default/empty/loading/error) | Evidence Pending — not captured | No entry in `_ar/evidence/ui/ui-observed-areas.md`; no screenshot filename in `_ar/prtsc/` matches this route |
| Role gating (fundraiser role) | Uncertain | No access-plugin config cited beyond the `supporter`-role analogy on the sibling `EN0034`/S018; `BR-AccessControlAndRoles` does not document a fundraiser-role gate |
| UC attribution (`UC0024`) | Assumed | `_ar/spec-draft/IA-screen-map.md` row S019 (candidate UC column); `_ar/spec-draft/UC/UC0024_ManageDonorAccount.md` (no fundraiser-zone sub-flow present in the UC body) |
