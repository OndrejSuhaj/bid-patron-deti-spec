---
doc_id: API0010
title: Partner Logos API
canonical_layer: API
spec_type: api-contract
status: draft
contract_type: rest-internal
references:
  - EN0020
  - ACL0009
---

# API0010 – Partner Logos API

## Purpose

Read-only REST resource exposed by the `partner` custom module that renders the public "podporují
nás" / "spřátelené organizace" (they support us / partner organisations) logo lists — typically a
site footer widget — from published Partner (EN0020) entries. Three plugin variants exist under one
`partners_rest_resource*` family; only one is currently functional (see Versioning Notes).

Evidence: `partner/src/Plugin/rest/resource/PartnersResource.php`,
`partner/src/Plugin/rest/resource/v20/PartnersResource.php`,
`partner/src/Plugin/rest/resource/v32/PartnersResource.php`,
`config/rest.resource.partners_rest_resource{,_v20,_v32}.yml`,
`config/user.role.{anonymous,authenticated}.yml`. Classification: **Confirmed** (code + enabled
config both present for all three variants; reachability differs — see Authorization).

No `partner.routing.yml` file exists in this module — all HTTP surface is declared purely via the
`@RestResource` plugin annotations (`uri_paths.canonical`) and the corresponding
`rest.resource.*.yml` config entries, not via a Symfony routing file.

---

## Consumers

- Public storefront frontend (anonymous visitors) — the only currently-working variant (v20) is
  reachable without authentication.
- Authenticated donor/user sessions — covered by the `authenticated` role's grants (superset of
  anonymous); no distinct authenticated-only behaviour is evidenced.

---

## Endpoints

### Get Partner Logos

- **Method / path (v1, base):** `GET /api/partners` (`partners_rest_resource` plugin;
  `rest.resource.partners_rest_resource.yml` → `status: true`) — **disabled at the code level**, see
  Versioning Notes.
- **Method / path (v2.0):** `GET /api/2.0/partners` (`partners_rest_resource_v20` plugin;
  `rest.resource.partners_rest_resource_v20.yml` → `status: true`) — **current live version**.
- **Method / path (v3.2):** `GET /api/3.2/partners` (`partners_rest_resource_v32` plugin;
  `rest.resource.partners_rest_resource_v32.yml` → `status: true`) — **enabled in config but
  short-circuited in code**, see Versioning Notes.
- **Format:** `json` only (all three variants).

No v3.1 or v3.3 variant exists for this module — the task framing mentioning v3.1/v3.2/v3.3 does not
match what is on disk; only v1 (unversioned), v2.0, and v3.2 REST plugins/config entries exist for
`partner`. Recorded as an evidence gap rather than invented.

---

## Authorization

Cross-checked against `config/user.role.anonymous.yml` and `config/user.role.authenticated.yml`
(role-based REST permissions, `restful <method> <plugin_id>`) and each resource's
`configuration.authentication: [cookie]` setting. No `_permission`/`_access` route requirement
applies (there is no routing file; these are pure REST-plugin routes).

| Endpoint | Anonymous | Authenticated | Notes |
|---|---|---|---|
| `GET /api/partners` (`partners_rest_resource`) | Not granted to any role | Not granted to any role | No role file (anonymous, authenticated, or any of the 13 other custom roles) grants `restful get partners_rest_resource`. Unreachable by any standard role regardless of the config `status: true` flag. **Confirmed absent**, not an Open Item. |
| `GET /api/2.0/partners` (`partners_rest_resource_v20`) | **Allowed** — `restful get partners_rest_resource_v20` granted | Allowed (superset of anonymous grant) | Confirmed. |
| `GET /api/3.2/partners` (`partners_rest_resource_v32`) | **Allowed** — `restful get partners_rest_resource_v32` granted | Allowed (superset of anonymous grant) | Confirmed reachable, but see Versioning Notes — reaching it currently yields an empty response regardless of data. |

No entity-level access control (`PartnerEntityAccessControlHandler`) is consulted by any of the three
resources — each reads directly via `\Drupal::entityQuery()` (v20) or raw SQL (v32, in the dead code
path) rather than going through the access-controlled entity storage that governs the back-office
CRUD forms (`administer partner entities` / `edit partner entities` / `delete partner entities` /
`view published partner entities` / `view unpublished partner entities` in `partner.permissions.yml`
— out of scope for this contract, back-office only).

---

## Request

### Inputs

None. All three variants take no path parameters, query parameters, or request body — the GET simply
returns the full current logo list.

---

## Response

### Success (v2.0 — current live shape)

| Field | Meaning | Notes |
|---|---|---|
| `[0].title` | Literal group label `"Podporují nás"` | Fixed Czech string, not derived from data. |
| `[0].logos` | Array of Partner (EN0020) entries with `category = support_us` | See item shape below. |
| `[1].title` | Literal group label `"Spřátelené organizace"` | Fixed Czech string, not derived from data. |
| `[1].logos` | Array of Partner (EN0020) entries with `category = partners` | See item shape below. |

Each item in a `logos` array:

| Field | Meaning | Notes |
|---|---|---|
| `title` | Partner (EN0020) `name` attribute | |
| `img_src` | Absolute/relative URL of the Partner's `logo` image, as returned by the file entity's `url()` | |
| `img_width` | Pixel width of the logo image | Read via the `image.factory` service; only included if the image is valid. |
| `img_height` | Pixel height of the logo image | Same validity gate as `img_width`. |
| `link_url` | Partner (EN0020) `link` attribute (raw `uri` value, not resolved) | |

Entries are ordered by the Partner (EN0020) `order` attribute, ascending. Only published (EN0020
`published = true`) entries are returned — `entityQuery()->accessCheck()` is applied, and a Partner
entry with no logo file, or whose logo file fails the `image.factory` validity check, is silently
skipped from both arrays.

### Success (v1 — base, code-disabled)

| Field | Meaning | Notes |
|---|---|---|
| `error` | Literal string `"disabled"` | The entire endpoint always returns this single-field object with HTTP 200, regardless of caller or data — see Versioning Notes. |

### Success (v3.2 — enabled but short-circuited)

| Field | Meaning | Notes |
|---|---|---|
| *(none)* | Always an empty JSON array `[]` | HTTP 200. The method contains an unconditional `return new ResourceResponse([]);` before any data-loading code — see Versioning Notes. |

### Failure Outcomes

| Outcome | Meaning | Retryable | Notes |
|---|---|---:|---|
| No documented error path | All three variants always return HTTP 200 on a successful call; none is evidenced to throw or return a non-200 status under any input, since none accepts input. | n/a | **Confirmed** — no exception handling or validation logic is present in any variant's `get()` method. |

---

## Side Effects

- Read-only across all three variants. No entity is created, updated, or deleted by this endpoint
  family.

---

## Versioning Notes

Three plugin variants coexist in the codebase and (unusually) all three are simultaneously
`status: true` in REST config, but only one is functionally live:

- **v1 (base, `partners_rest_resource`, `/api/partners`):** the `get()` method is a stub that
  unconditionally returns `{"error": "disabled"}` — no query, no entity load, no role check is ever
  reached. Combined with the fact that no role grants this plugin's `restful get` permission (see
  Authorization), this endpoint is doubly non-functional: unreachable by permission, and a no-op even
  if reached directly by an administrator/bypass account. **Confirmed** dead endpoint, current-state
  as-is.
- **v2.0 (`partners_rest_resource_v20`, `/api/2.0/partners`):** the only variant with working data
  logic — loads all `partner` entities via `\Drupal::entityQuery('partner')->accessCheck()`, sorted
  by `order` ascending, resolves each entry's logo file and dimensions via `image.factory`, and
  groups entries into the two fixed Czech-labelled buckets by `category`. **This is the current live
  version** consumed by the public site.
- **v3.2 (`partners_rest_resource_v32`, `/api/3.2/partners`):** contains a near-identical
  implementation to v2.0 (raw SQL `SELECT id FROM partner ORDER BY order ASC` instead of
  `entityQuery()`, and `createFileUrl()` instead of `url()` for the logo file) — but this entire
  implementation is unreachable dead code: an unconditional `return new ResourceResponse([]);`
  appears as the very first statement of the `get()` method, before the SQL query and grouping logic.
  The method is enabled in config, granted to both anonymous and authenticated roles, but always
  returns an empty array regardless of Partner (EN0020) data. **Confirmed** by direct inspection —
  this is not a hypothesis, the dead code is present and unreachable in the current source.

No evidence indicates which of the three is intended as canonical going forward; from a purely
current-behavioural standpoint, v2.0 is the only variant that returns real data today.

---

## Hazards (current-state)

- **Three enabled endpoints, one working:** all three REST config entries (`status: true`) and both
  public-facing roles (anonymous, authenticated) grant permissions consistent with all three
  endpoints being live, but v1 is a stub and v3.2 is dead code behind an early `return`. A caller or
  integrator inspecting only the config/permissions layer (without reading the PHP) would reasonably
  but incorrectly conclude that `/api/3.2/partners` is the "latest" and preferred endpoint — it is
  currently the least useful of the three. **Confirmed**, maintenance-trap class hazard rather than a
  security hazard.
- **No access-controlled entity load:** neither v20 (`entityQuery` direct access-check only, no
  `PartnerEntityAccessControlHandler` consultation) nor the dead v32 code path (raw SQL, no access
  check at all) goes through the module's own entity access handler. For v20 this is currently benign
  because `accessCheck()` combined with anonymous/authenticated-safe default entity access is the only
  gate; for the (currently unreachable) v32 raw-SQL path, re-enabling that code as-is would bypass
  publish-state filtering entirely, since the SQL query loads all IDs regardless of the `status`
  (published) field is applied only implicitly via the entity access check, not the SQL query.
  **Partial** — flagged as a latent risk in the dead code, not an observed incident, since the v32
  code path is not currently reachable.
- **No cache-tag invalidation on write:** `PartnerEntity::postSave()` contains a commented-out
  `Cache::invalidateTags(['partners'])` call — cache invalidation on Partner (EN0020) create/update is
  currently disabled in source. Combined with the public GET endpoints above, an edit to a Partner
  entry's logo/name/order in the back-office may not be reflected promptly to callers of
  `/api/2.0/partners` if any page/response caching layer is in front of it. **Confirmed** by direct
  inspection of the commented-out line; downstream caching behaviour itself is **Unknown** (out of
  scope for this module's evidence).

---

## References

- EN: EN0020 (Partner)
- ACL: ACL0009 (Identity Access and Public API — does not currently document this module's grants;
  flagged as a gap, see Open Items)
- UC: none — no use case in the current draft set models Partner (EN0020) authoring, editing, or the
  public consumption of this endpoint as an orchestrated flow (see EN0020 Open Questions).
- FN: none — no functional capability in the current draft set (`_ar/spec-draft/FN/`) covers the
  Partner logos display feature; this contract is anchored directly to EN0020 per Hard Rule 4's intent
  (anchored to a canonical reconstructed artifact), since no FN/UC currently exists to anchor to. See
  Open Items.

---

## Open Items

- No FN (functional capability) or UC (use case) document currently models "display partner logos on
  the public site" as a capability/flow. This contract is anchored to EN0020 (entity) only. A future
  FN-layer pass may want to add a minimal capability entry (analogous to FN0026's minimal-by-design
  pattern) so this contract has a non-entity anchor.
- ACL0009 (Identity Access and Public API) does not currently list the `partner` module's role
  grants; this document records them directly from `config/user.role.*.yml` instead. Recommend
  ACL0009 be refreshed to include this module for consistency with how other public REST endpoints are
  tracked there.
- Whether the base v1 endpoint (`/api/partners`, stub) and the dead-code v3.2 endpoint are deliberate
  historical artifacts (superseded, kept for compatibility) or accidental leftovers is not evidenced —
  recorded as `Uncertain`, not resolved here.
- EN0020 itself notes (Open Question 3) a possible naming collision between this entity's `partner`
  bundle and an unrelated taxonomy-based `partners` classification used elsewhere in the system; not
  further resolved by this API contract.
