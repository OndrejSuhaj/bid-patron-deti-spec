---
doc_id: EN0033
title: GiftCategory
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0001  # Application — category (Application-level "Area of assistance", synced to Campaign)
  - EN0002  # ApplicationProfile — gift_category / gift_subcategory (fundraiser-perspective requested-gift classification)
  - EN0004  # Campaign — gift_category (kept in lock-step with Application.category)
  - EN0019  # Supplier — subcategory-to-supplier linking (supplier_to_category)
  - UC0001  # Submit Application — step 2 "Dar, kterým vám pomůžeme" captures gift_category/gift_subcategory
---

# EN0033 — GiftCategory

## Purpose

GiftCategory (dárová kategorie / oblast pomoci) is the reference-data catalogue an applicant chooses
from — in the application wizard's step 2 ("Dar, kterým vám pomůžeme" / "Rychlá volba daru") — to
classify the life situation and the specific gift/in-kind help being requested. It is **not a fixed
code-level enum**: it is a two-level **taxonomy vocabulary** (`category`, admin label "Oblast pomoci")
whose top-level terms are the gift **categories** ("What life situation are you dealing with?") and
whose child terms are the gift **subcategories** ("What gift would help the child?"). Each subcategory
term carries a serialized **per-field parameter override** that relabels/reconfigures the step-2 form
(field titles, placeholders, attachment cardinality, an optional date-range validator) — this is the
mechanism behind the observed "Tábory" behaviour (adds "V jaké termínu se tábor uskuteční" and retitles
the org/attachment fields). — **Confirmed** (code).

GiftCategory shapes what an applicant may request (`ApplicationProfile.gift_category` /
`gift_subcategory`, EN0002) and is propagated onto the resulting Application (`Application.category`,
EN0001) and, once published, onto the public Campaign/Story (`Campaign.gift_category`, EN0004) — a
one-directional sync from Application to Campaign on save, not a shared reference.

---

## Lifecycle

GiftCategory terms have the generic Drupal taxonomy-term lifecycle:

- Published (`status = 1`) — selectable in the step-2 picker and in admin category-management screens.
- Unpublished (`status = 0`) — excluded from the applicant-facing picker (`SuppliersResource` filters
  `status == 0` out in the v32 REST variant — **Confirmed**, code).

There is no additional domain-specific status vocabulary for GiftCategory beyond the standard taxonomy
term publish flag. — **Confirmed**.

---

## State Transitions

(none) → Published
trigger: created/edited via the Drupal taxonomy-term admin form for the `category` vocabulary (bundle
`taxonomy_term.category`), using the `category_parameters` field widget for the per-field overrides —
**Confirmed** (`web/modules/custom/application/src/Plugin/Field/FieldWidget/CategoryParametersWidget.php`,
`config/core.entity_form_display.taxonomy_term.category.default.yml`). The initial catalogue (9
categories/subcategories captured by the UI evidence) was seeded/corrected by a one-time data-fix
function, `patron_base_update_cz_categories()` in `patron_base.module` — **Confirmed**, but this is a
deploy-time content-seeding routine, not a recurring runtime trigger; catalogue changes after that seed
are made through ordinary taxonomy-term editing (Hypothesis for the ongoing/current admin workflow — no
dossier evidences a subsequent edit).

Published ↔ Unpublished
trigger: Hypothesis — Not evidenced in current sources: no admin UC dossier documents who
publishes/unpublishes a GiftCategory term or under what circumstance.

---

## Attributes

### System-managed attributes

- `tid` (integer; system-managed; taxonomy term ID; primary identifier referenced by `gift_category` /
  `gift_subcategory` / `category` fields elsewhere in the domain)
- `vid` (string; system-managed; fixed value `category` — the vocabulary machine name; admin label
  "Oblast pomoci")
- `parent_target_id` (reference to GiftCategory (self); system-managed; `0`/absent = top-level
  **category**, non-zero = **subcategory** of that category — the two-level hierarchy is expressed by
  taxonomy parentage, not by two separate bundles — **Confirmed**,
  `config/views.view.gift_categories.yml` filter `parent_target_id > 0`)
- `weight` (integer; system-managed; display order in the step-2 picker)
- `status` (boolean; system-managed; published/unpublished — see Lifecycle)

### User-provided attributes (maintained via the taxonomy-term admin form)

- `name` (string; required; category/subcategory display label shown to the applicant, e.g. "ŠVP,
  JAZYKOVÝ KURZ, ŠKOLNÍ VÝLETY", "TÁBORY – POBYTOVÉ, PŘÍMĚSTSKÉ")
- `body` (text, formatted; optional; the explanatory description shown when a category row is expanded
  — "Více informací" — e.g. the Tábory description "Požádat můžete o jakékoli tábory anebo soustředění…")
- `tooltips` (string; optional; comma-separated values; base field added to `taxonomy_term` generally by
  `patron_base` module — not category-specific storage; consumed by the Supplier REST resource as a
  per-category tooltip list — **Confirmed**, `patron_base.module` `patron_base_entity_base_field_info()`,
  `supplier/src/Plugin/rest/resource/SuppliersResource.php`)
- `scoring` (string/JSON; optional; base field added to `taxonomy_term` generally by `patron_base`
  module; description "Json" in code. **Hypothesis** — no dossier confirms this field is populated or
  read for GiftCategory terms specifically; only its generic existence on `taxonomy_term` is evidenced)
- `parameters` (string, serialized PHP array; optional; **the per-field form-override contract** — see
  Invariants; field storage `field.storage.taxonomy_term.parameters`, attached only to bundle
  `taxonomy_term.category` via `field.field.taxonomy_term.category.parameters`)

---

## The `parameters` override contract (per-subcategory dynamic field model)

**Confirmed** — code: `CategoryParametersWidget::formElement()` (admin editing) and
`patron_base_update_cz_categories()` (seed data) in
`web/modules/custom/application/src/Plugin/Field/FieldWidget/CategoryParametersWidget.php` and
`web/modules/custom/patron_base/patron_base.module`.

`parameters` is a PHP-serialized associative array, one entry per overridable field on the ApplicationProfile's
step-2 gift block. Each entry may carry:

- `title` (string) — replaces the field's default label.
- `placeholder` (string) — replaces the field's default placeholder.
- `cardinality` (integer, attachment fields only) — number of files allowed.
- `validate` (boolean, `gift_note` only) — flags the field for date-range validation.

Overridable field keys observed in the seed data: `name`, `school_teacher_name`, `phone`, `email`,
`attachment_1` … `attachment_6`, `gift_note`, `gift_price`, `notice`. An empty override (`''`) leaves
the field at its ApplicationProfile-level default label; a non-empty override relabels/reconfigures it
for that specific subcategory only.

**Confirmed example (Tábory, matching the UI evidence exactly):** the seed data for subcategory tid
2572 ("TÁBORY – POBYTOVÉ, PŘÍMĚSTSKÉ") overrides `name` → "Název a adresa organizátora tábora",
`attachment_2` → "Zde přiložte přihlášku na tábor" (cardinality 3), and adds `gift_note` → "V jaké
termínu se tábor uskuteční" (placeholder "Termín") — this is the exact per-category relabelling
observed in the step-2 screenshots.

**Confirmed catalogue as seeded (9 top-level categories, tid → title, weight order):**

| tid | Category (Czech, as seeded) | Weight |
|---|---|---|
| 2505 | ŠVP, JAZYKOVÝ KURZ, ŠKOLNÍ VÝLETY | 0 |
| 0 (cloned from 2505, new tid assigned at save) | LYŽAŘSKÝ KURZ | 1 |
| 994 | KROUŽKY, SOUSTŘEDĚNÍ A VYBAVENÍ PRO NĚ | 2 |
| 2572 | TÁBORY – POBYTOVÉ, PŘÍMĚSTSKÉ | 3 |
| 72 | ŠKOLNÉ A INTERNÁT | 4 |
| 992 | NOTEBOOK | 5 |
| 3042 | AUTOMOBIL jako zdravotní pomůcka | 6 |
| 71 | POMŮCKY A SLUŽBY pro ZDRAVOTNĚ ZNEVÝHODNĚNÉ DĚTI | 7 |
| 991 | BALÍK ŠKOLNÍCH POTŘEB | 8 |

This matches the 9 categories observed in the UI evidence one-for-one (title wording and order). tid 71
and 72 in the seed function are also used as **parent tids for two additionally created subcategory
terms** (the function's `$tid == 71 || $tid == 72` branch creates a child term under each) — the exact
resulting subcategory catalogue (subcategory names/tids beyond what the seed function creates inline)
is **not fully enumerable from static source alone**; the taxonomy content itself (which subcategory
terms exist today, under which parent, with which live `parameters`) lives in the database, not in a
version-controlled config export — **Evidence Pending** (see Evidence Gaps).

A separate legacy top-level term, **tid 1722 "Mimořádná pomoc"** (COVID-era emergency aid; referenced
literally in `ApplicationCreateResource.php` as a hardcoded default and explicitly excluded from the
applicant-facing category list in `SuppliersResource::get()`), exists in the same vocabulary but is
**not** one of the 9 current-state categories — **Confirmed**, historical/excluded, not part of the
active picker.

---

## Invariants

- A GiftCategory term is either a **category** (`parent_target_id` empty/0) or a **subcategory**
  (`parent_target_id` set to a category's tid); the applicant-facing step-2 picker and the
  `gift_categories` view/REST projection both partition the vocabulary this way — **Confirmed**.
- `ApplicationProfile.gift_category` (EN0002) is derived from `ApplicationProfile.gift_subcategory` when
  not explicitly set — i.e., selecting a subcategory implies its parent category — **Confirmed**, EN0002
  attribute note (`ApplicationProfileEntity.php` field definitions).
- A subcategory's `parameters` override applies only to the ApplicationProfile step-2 fields for
  Applications carrying that specific `gift_subcategory` — categories/subcategories with no override
  entry (or empty string entries) fall back to the ApplicationProfile's default field labels/placeholders
  — **Confirmed** (`CategoryParametersWidget`).
- `Application.category` (EN0001, the Application-level "Area of assistance" field — distinct storage
  from `ApplicationProfile.gift_category`, but referencing the same `category` taxonomy/bundle) is
  synced onto the linked Campaign's `gift_category` (EN0004) on Application save whenever it changes —
  a one-directional, non-atomic propagation, not a shared reference — **Confirmed**,
  `ApplicationEntity::updateCampaignCategory()` (`web/modules/custom/application/src/Entity/ApplicationEntity.php`).
- Suppliers (EN0019) may be linked to a subcategory via the `supplier_to_category` entity, surfaced
  through the same category REST projection (`SuppliersResource`) — **Confirmed**, but the applicant-side
  consumption of this supplier-to-subcategory link (e.g. auto-suggesting a vendor) is **not evidenced**
  by any UC dossier — **Evidence Pending**.
- tid 1722 ("Mimořádná pomoc") is excluded from the applicant-facing picker but remains a valid
  `gift_category` value on existing/legacy Applications — **Confirmed**, code-level exclusion +
  hardcoded historical assignment.

---

## Relationships

- EN0001 — Application (`category` field; Application-level classification, propagated to Campaign)
- EN0002 — ApplicationProfile (`gift_category`, `gift_subcategory` fields; the applicant-facing
  classification captured at step 2, with `gift_category` derivable from `gift_subcategory`)
- EN0004 — Campaign (`gift_category` field; kept in lock-step with `Application.category` — see
  BR-CampaignStoryLifecycle / `updateCampaignCategory`)
- EN0019 — Supplier (via `supplier_to_category`; a subcategory may list associated suppliers/vendors)
- UC0001 — Submit Application (step 2 "Dar, kterým vám pomůžeme" is where GiftCategory is selected and
  the `parameters` override reshapes the visible fields)

---

## Evidence Gaps

- **Full current subcategory catalogue.** The seed function (`patron_base_update_cz_categories`)
  confirms the 9 top-level categories and their `parameters` overrides exactly as observed in the UI,
  plus two subcategories created inline under tid 71/72, but the complete, current list of all
  subcategory terms (names, tids, live `parameters`) is taxonomy **content** in the database, not
  present in any version-controlled config/content export in this source tree. Resolving this requires
  either a database export/dump of the `taxonomy_term_data`/`taxonomy_term__parameters` tables for
  vocabulary `category`, or a further live-instance/content-staging pull — out of scope for a static
  source-only pass (see `_ar/tasks/Runtime-truth-policy.md`).
- **`scoring` field usage on GiftCategory terms.** The `scoring` base field exists generically on
  `taxonomy_term` (added by `patron_base`); no dossier confirms whether/how it is populated or consumed
  specifically for `category`-bundle terms. Marked Hypothesis above; not asserted as an active GiftCategory
  behaviour.
- **Post-seed admin governance.** No use-case dossier documents the current admin workflow for adding a
  10th category, retiring one, or editing `parameters` after the initial seed — the mechanism (taxonomy
  term admin form) is confirmed by config, but the operational process/ownership is not.
- **Supplier auto-linking consumption.** `supplier_to_category` is confirmed as a data model, but no
  evidence shows the applicant-facing form using it (e.g., to prefill/suggest a vendor for a chosen
  subcategory).

None of the above gaps block publishing this entity at **Partial** confidence: the category/subcategory
taxonomy structure, the per-field override mechanism, and the 9-category catalogue matching the UI
evidence are all **Confirmed** in code; only the live/current full subcategory enumeration and a few
peripheral behaviours remain open.
