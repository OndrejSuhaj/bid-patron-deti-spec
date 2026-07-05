---
doc_id: API0011
title: Supplier / Category Catalogue API
canonical_layer: API
spec_type: api-contract
status: draft
contract_type: rest-internal
references:
  - EN0019
  - EN0033
  - ARCH0008
---

# API0011 – Supplier / Category Catalogue API

## Purpose

Public, read-only HTTP surface exposing the "Oblasti pomoci" (areas of help) taxonomy — top-level
GiftCategory terms (EN0033), their child subcategories, and the Supplier (EN0019) vendor records
linked to each subcategory via `supplier_to_category`. It is a single-endpoint catalogue lookup with
no request parameters: one call returns the entire category/subcategory/supplier tree in one payload.
The module exposes no create/update/delete HTTP surface for Supplier or SupplierToCategory — those
entities are administered exclusively through Drupal's generic content-entity admin HTML forms
(`/admin/structure/supplier`, `/admin/structure/supplier_to_category`), which are out of scope for this
API-layer contract (HTML admin routes, not a system-facing REST/JSON contract).

This contract folds two REST resource plugin **versions** of the same lookup
(`v2.3` and `v3.2`) that coexist in the current source under
`web/modules/custom/supplier/src/Plugin/rest/resource/`. Both are simultaneously enabled
(`status: true` in both `rest.resource.*.yml` configs) — there is no evidence of the older version
being retired. No `v3.1` or `v3.3` variant exists for this module (**Confirmed** — only two directories
under `src/Plugin/rest/resource/`: the default namespace = v2.3, and `v32/`).

## Consumers

- Anonymous website visitor / the public-facing SPA — **Confirmed**, see Authorization.
- Authenticated donor/user session — same response; session state does not change the payload
  (**Confirmed**, no `$this->currentUser` branch is read in either `get()` method despite the property
  being injected).

## Authorization

- **Confirmed, both endpoints in this contract are publicly reachable — no login/session/token is
  required.** Both underlying `rest.resource.*.yml` configs declare `authentication: [cookie]` and no
  `_permission`/`_access` route requirement — these are Drupal REST-module resources (no
  `supplier.routing.yml` exists in this module), so access is gated purely through the
  `restful get <resource_id>` permission, not through the entity-level `view published supplier
  entities` / `view published supplier to category entities` permissions defined in
  `supplier.permissions.yml`.
- `config/user.role.anonymous.yml` grants the anonymous role **both** `restful get suppliers_resource`
  and `restful get suppliers_resource_v32` (source: `config/user.role.anonymous.yml:131-132`,
  dependency block lines 64-65).
- `config/user.role.authenticated.yml` grants the same two permissions identically (source:
  `config/user.role.authenticated.yml:141-142`, dependency block lines 67-68).
- No other role config (`manager`, `risk_manager`, `marketing`, etc.) grants or restricts these two
  `restful get ...` permissions — only `manager` and `risk_manager` hold the *entity-level*
  `add/edit/delete/view (un)published supplier(-to-category) entities` permissions, which govern the
  HTML admin CRUD forms, not this REST contract.
- Net effect: **this is an unauthenticated, public data feed** — the entity-level publish/unpublish
  permission model on Supplier/SupplierToCategory has no bearing on who may call these two endpoints;
  it only governs the separate HTML admin UI.

## Request

### Endpoint inventory

| # | Method + Path | Plugin ID | Config file |
|---|---|---|---|
| 1 | `GET /api/3.2/suppliers` | `suppliers_resource_v32` | `rest.resource.suppliers_resource_v32.yml` |
| 2 | `GET /api/2.3/suppliers` | `suppliers_resource` | `rest.resource.suppliers_resource.yml` |

Current version is inferred to be **v3.2** (higher-numbered, matches the platform's general `v3.x`
API-versioning line seen in other modules, e.g. API0003's Campaign family). Both versions remain
deployed side by side with no deprecation marker in source. **Partial** — which version the live SPA
actually calls is not evidenced in this backend-only source tree.

### Inputs

Neither endpoint accepts any query parameter, path parameter, or request body. Both are parameterless
`GET` lookups that return the full current catalogue on every call — **Confirmed**, neither `get()`
method reads `\Drupal::request()` or any method argument.

## Response

### Success — both endpoints

Both versions return the identical response *shape*; only the taxonomy-loading mechanism and the
unpublished-term filter differ (see Versioning notes below). Response is uncached
(`addCacheableDependency(['#cache' => false])` — **Confirmed**, both classes).

| Field | Meaning | Notes |
|---|---|---|
| `category` | object keyed by taxonomy term ID (GiftCategory top-level term, EN0033) | each value: `{ name, tooltips }` |
| `category.<tid>.name` | category display label | string |
| `category.<tid>.tooltips` | array of tooltip strings, or `null` | source field `tooltips` (comma-separated string on the term) exploded on `,`; `null` if the field is empty |
| `subcategory` | object keyed by taxonomy term ID (GiftCategory child term, EN0033) | each value: `{ name, parent }` |
| `subcategory.<tid>.name` | subcategory display label | string |
| `subcategory.<tid>.parent` | parent category's term ID | integer |
| `supplier` | object keyed by Supplier entity ID (EN0019) | each value: `{ name, url, parent }` — **last-write-wins**: if a Supplier is linked to more than one subcategory via `supplier_to_category`, only one mapping survives in the response (object keyed by Supplier ID, so a later loop iteration for the same supplier overwrites an earlier one) |
| `supplier.<id>.name` | Supplier display name (`SupplierEntity::getName()`, EN0019 `name` attribute) | string |
| `supplier.<id>.url` | e-shop URL for that supplier/category pairing (`SupplierToCategory.url`, EN0019 relationship) | string, may be empty |
| `supplier.<id>.parent` | the subcategory term ID this supplier mapping is attached to | integer — reflects whichever `supplier_to_category` row was processed last for that supplier (see last-write-wins note above) |

**Exclusions applied to both versions (Confirmed, code):**
- The legacy top-level term **tid 1722 ("Mimořádná pomoc")** and any of its children are always
  excluded from `category`/`subcategory`/`supplier` — same historical exclusion documented on EN0033.

### Versioning notes (behavioral differences between v2.3 and v3.2)

| Aspect | v2.3 (`suppliers_resource`) | v3.2 (`suppliers_resource_v32`) |
|---|---|---|
| Taxonomy source | `patron_base.default` service, `getTaxonomyTermsSortedByWeight('category')` — raw SQL `SELECT tid FROM taxonomy_term_field_data WHERE vid=:vid ORDER BY weight ASC`, each row loaded via `Term::load()` | `\Drupal::entityTypeManager()->getStorage('taxonomy_term')->loadTree('category')` — standard tree loader, returns stdClass-like tree objects (`tid`, `name`, `parents`, `status`, `tooltips`) |
| Unpublished-term filter | **Not applied** — **Confirmed**: the v2.3 loop's skip condition only checks `tid == 1722` / `parentId == 1722`; it does not inspect a `status`/published flag at all, so unpublished category/subcategory terms are included in the response | **Applied** — **Confirmed**: v3.2 additionally skips any term where `$category->status == 0`, in the same condition as the tid-1722 exclusion |
| Parent-detection method | `$category->parent->referencedEntities()` (entity reference field on the loaded `Term` object) | `$category->parents[0]` (array field on the tree-loader's return object) |
| Tooltips field access | `$category->tooltips->value` | `$category->tooltips` (property directly on the tree object, no `->value`) |

Net current-state difference: **v2.3 can surface an unpublished GiftCategory/subcategory (and any
Suppliers linked under it) that v3.2 correctly hides.** This is a real behavioral divergence between
the two live, simultaneously-enabled versions, not merely a refactor — flagged as a hazard below.

### Failure Outcomes

| Outcome | Meaning | Retryable | Notes |
|---|---|---:|---|
| `200` with `category: [], subcategory: [], supplier: []` | no terms exist in the `category` vocabulary (or all are excluded) | yes | not an error path in code — both `get()` methods always return `200`; no exception handling or not-found branch exists |
| Uncaught PHP error (e.g. `TypeError`/`Error` on `null` entity reference) | a `supplier_to_category` row references a deleted/missing Supplier or category term | not evidenced — **Uncertain**, no defensive null-check exists in either loop body before dereferencing `->entity->id()` / `->getName()` | would surface as a generic 5xx, not a structured API error; not confirmed against a live instance per `_ar/tasks/Runtime-truth-policy.md` |

## Side Effects

None. Both endpoints are a pure read — no Supplier, SupplierToCategory, or taxonomy-term state is
created, updated, or deleted (**Confirmed** — no `->save()` call in either `get()` method).

## Hazards (current-state)

- **v2.3 does not filter unpublished GiftCategory terms; v3.2 does.** A category or subcategory
  unpublished via the taxonomy admin form (intending to hide it from applicant-facing surfaces) remains
  visible — together with any Suppliers linked to it — through the still-enabled v2.3 endpoint. Any
  consumer still calling `/api/2.3/suppliers` sees stale/withdrawn categories and vendor mappings that
  `/api/3.2/suppliers` correctly suppresses.
- **No pagination, filtering, or field selection on either endpoint** — the full catalogue is returned
  on every call; not a security hazard, but a scale/efficiency characteristic carried over as-is (no
  evidence this has caused an operational problem, so not elevated further here).
- **Supplier-to-subcategory `parent` linkage is lossy when a Supplier maps to multiple subcategories**
  (see "last-write-wins" note in Response) — the response cannot represent a Supplier associated with
  more than one subcategory; only the last-processed mapping is visible. This mirrors the "no confirmed
  uniqueness constraint per Supplier–category pair" open question already recorded on EN0019.
- **No rate limiting, HMAC, or request-signing evidenced on either endpoint** — consistent with the
  project-wide current-state pattern of public/anonymous read endpoints having no additional
  transport-level integrity or throttling control in the scanned source. Low severity here specifically,
  since the payload is non-personal reference data (categories, subcategories, public vendor list), not
  donor/applicant PII.

## References

- EN: EN0019 (Supplier — the vendor entity and the `supplier_to_category` relationship), EN0033
  (GiftCategory — the `category` taxonomy vocabulary, its two-level category/subcategory structure, the
  `tooltips` field, and the tid-1722 "Mimořádná pomoc" exclusion already documented there)
- ARCH: ARCH0008 (Documents & Fulfilment — names the supplier registry as reference data consumed by
  other back-office flows)

## Open Items

- **No UC/FN dossier grounds this endpoint's consumer-side usage.** No use-case or capability document
  in `_ar/spec-draft/UC/` or `_ar/spec-draft/FN/` currently mines where/how the applicant-facing or
  admin-facing UI calls `/api/{2.3,3.2}/suppliers` (e.g., to populate a "recommended vendor" hint during
  Application submission, per the "Supplier auto-linking consumption" gap already flagged on EN0033).
  This contract is grounded directly in the REST resource source and the EN0019/EN0033 entity docs;
  a future UC pass may sharpen the "Purpose" section once that consumer flow is mined.
- **Which version (v2.3 or v3.2) the live SPA/admin UI actually calls** is not evidenced in this
  backend-only source tree (**Partial**).
- **Uncaught-error path on a dangling `supplier_to_category` reference** is recorded as **Uncertain**
  above; no live-instance verification is available under the current Runtime-truth-policy.
- **CRUD surface for Supplier / SupplierToCategory is intentionally out of scope for this contract** —
  those entities are maintained only via Drupal's generic HTML admin forms
  (`SupplierEntityForm`, `SupplierToCategoryForm`, `*DeleteForm`), which are not a system-facing
  REST/JSON API. If a future rewrite needs a documented admin-API contract for Supplier maintenance,
  it does not currently exist in source and would need to be scoped as a new contract, not folded into
  this one.
