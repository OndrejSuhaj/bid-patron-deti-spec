---
doc_id: API0013
title: Organisation Dashboard Stats API
canonical_layer: API
spec_type: api-contract
status: draft
contract_type: rest-internal
references:
  - EN0018
  - EN0001
  - EN0008
  - FN0018
---

# API0013 – Organisation Dashboard Stats API

## Purpose

Read-only HTTP lookup that returns a single Organisation's (EN0018) display name and a set of
Application (EN0001) counters bucketed by moderation-state group — intended to power an
organisation-facing dashboard summarizing how many Applications tied to the organisation's workers
are active, processing, waiting, failed, or finished. The `organisation` module exposes **no other
end-user HTTP surface**: it has no create/update/delete REST resource, and its `organisation.routing.yml`
only defines three HTML admin routes (`workers_list`, `workers.add_form`, `workers.edit_form`,
`remove_organisation_duplicates_form`) plus an entity CRUD/admin UI via
`OrganisationEntityHtmlRouteProvider` — these are Drupal admin-theme HTML forms, not system-facing
JSON/REST contracts, and are out of scope for this API-layer document (**Confirmed** — no `_format`
requirement, no REST resource annotation on any of those routes).

This contract folds two REST resource plugin **versions** of the same lookup
(`v3.0` and `v3.2`) under
`web/modules/custom/organisation/src/Plugin/rest/resource/{v30,v32}/OrganisationResource.php`.
**Confirmed** — no `v3.1` or `v3.3` variant exists for this module; only two directories exist under
`src/Plugin/rest/resource/`. The two class bodies are byte-for-byte identical except for the
namespace, plugin `id`/`label`, and `uri_paths.canonical` — there is no behavioral difference between
versions for this module (unlike, e.g., API0011's Supplier catalogue where v2.3/v3.2 diverge).

## Consumers

- An authenticated organisation-side user (e.g. an organisation's key account manager or worker)
  viewing an organisation dashboard — **Hypothesis, not evidenced**: no UC/FN document in
  `_ar/spec-draft/UC/` or `_ar/spec-draft/FN/` currently mines a dashboard flow that calls this
  endpoint; inferred solely from the response shape (name + story/application counters) and the
  `organisation_id` query parameter.
- Because of the authorization findings below, the endpoint is also technically reachable by an
  anonymous caller who knows or guesses a valid Organisation UUID — see Hazards.

## Authorization

- Both REST resource configs declare `authentication: [cookie]` and `methods: [GET]`,
  `formats: [json]` (source: `config/rest.resource.organisation_resource_v30.yml`,
  `config/rest.resource.organisation_resource_v32.yml`). Neither the resource class nor
  `organisation.routing.yml` defines a route-level `_permission` or `_access` requirement for this
  endpoint — Drupal's REST module gates access purely through the generic
  `restful get <plugin_id>` permission (**Confirmed** — `OrganisationResource extends ResourceBase`
  with no custom `access()` override).
- **Confirmed hazard: `restful get organisation_resource_v30` and `restful get organisation_resource_v32`
  are both granted to the anonymous role** (source: `config/user.role.anonymous.yml`, `permissions:`
  block, lines 130–131) **and** to the authenticated role (source:
  `config/user.role.authenticated.yml`, `permissions:` block, lines 32–33). No other role file
  (`organisation_worker`, `patron`, `manager`, `coordinator`, etc.) grants or restricts this permission
  separately — the anonymous/authenticated grants are the only gate that exists.
- Net effect: **despite `authentication: cookie` being declared, no session/login is actually required**
  to call this endpoint, because the anonymous role already holds the `restful get` permission. Any
  caller who supplies a valid `organisation_id` (an Organisation UUID) receives that organisation's
  name and Application-count breakdown with no authentication at all.
- No tenant/ownership check exists: the resource does not verify that the calling user is a worker,
  key account manager, or owner of the requested Organisation (EN0018) — it resolves whichever
  Organisation UUID is supplied in the query string and returns its counters regardless of caller
  identity. Cross-reference: **FN0018 (Identity & Access Control)** governs the general permission
  model; this endpoint sits outside any of the entity-level `organisation` permissions defined in
  `organisation.permissions.yml` (`view published organisation entity entities`,
  `edit organisation entity entities`, etc.) — those govern the HTML admin routes only, not this REST
  contract.

## Request

### Endpoint inventory

| # | Method + Path | Plugin ID | Config file |
|---|---|---|---|
| 1 | `GET /api/3.2/organisation` | `organisation_resource_v32` | `rest.resource.organisation_resource_v32.yml` |
| 2 | `GET /api/3.0/organisation` | `organisation_resource_v30` | `rest.resource.organisation_resource_v30.yml` |

Current version is inferred to be **v3.2** (higher-numbered, consistent with the platform's general
`v3.x` versioning line observed across other modules). Both versions remain simultaneously enabled
(`status: true` in both configs) with no deprecation marker in source. **Partial** — which version any
live consumer actually calls is not evidenced in this backend-only source tree.

### Inputs

| Field | Meaning | Required | Notes |
|---|---|---:|---|
| `organisation_id` | Organisation (EN0018) UUID to look up | yes (functionally) | Read from the query string (`\Drupal::request()->query->get('organisation_id')`), not a path parameter. **Confirmed** — if omitted or not matching any Organisation UUID, the lookup returns no match and the endpoint responds with the 404-shaped error below; there is no distinct "missing parameter" outcome. |

No request body is read; this is a parameterless-body `GET` lookup (query string only).

## Response

### Success

| Field | Meaning | Notes |
|---|---|---|
| `name` | Organisation display name (EN0018 `name` attribute) | string, via `OrganisationEntity::getName()` |
| `count.active_stories` | number of Applications (EN0001) whose current state falls in the `org_stats_active_stories` bucket AND whose `patron` (EN0001 patron reference) is one of this Organisation's workers | integer; see Side Effects/state-bucket note below |
| `count.processing_applications` | same, bucketed by `org_stats_processing_applications` | integer |
| `count.waiting_applications` | same, bucketed by `org_stats_waiting_applications` | integer |
| `count.failed_stories` | same, bucketed by `org_stats_failed_stories` | integer |
| `count.finished_stories` | same, bucketed by `org_stats_finished_stories` | integer |
| `stats.total_amount` | intended total donation/gift amount associated with the organisation | **Confirmed hardcoded to the literal `0`** in both resource versions — the field is always `0` regardless of actual donation data; not computed from any query. Flagged as a hazard below. |

Each `count.*` bucket is defined by a same-named Drupal simple config object
(`patron_base.application_statuses.org_stats_<bucket>`) that lists which of the ~60 Application
moderation states belong to that bucket (a state → bucket-membership map, values `'0'` for "not in
this bucket" or the state's own machine name for "in this bucket"). The bucket definitions themselves
are configuration, not business rule content owned by this API document — see EN0001 for the
Application state vocabulary and BR-ApplicationStatusGovernance for governance of the state model
itself.

The `getApplicationsByStates()` implementation queries the raw `application` DB table directly
(`SELECT COUNT(*) FROM application WHERE state IN (:states) AND patron IN (:worker_ids)`), bypassing
the entity API — **Confirmed**, code-level detail included here only to explain the field boundary
(state ∈ bucket AND patron ∈ this organisation's `worker` field, EN0018), not as an implementation
prescription.

Response is uncached (`addCacheableDependency(['#cache' => false])` — **Confirmed**, both versions).

### Failure Outcomes

| Outcome | Meaning | Retryable | Notes |
|---|---|---:|---|
| `404` `{"error": "organisation_not_found"}` | no Organisation entity matches the supplied `organisation_id` UUID (including when the parameter is omitted entirely) | yes (with a valid UUID) | Only structured error path in the resource; **Confirmed**, both versions identical. |
| Uncaught PHP error | `getApplicationsByStates()` is called with `count($states) && count($states)` (the same condition duplicated in both versions) — if the organisation has **zero workers** (`getWorkers()` returns an empty array), the query still runs with an empty `:organisation_workers[]` placeholder | **Uncertain** — not evidenced against a live instance whether Drupal's expanded-array (`[]`) placeholder binding tolerates an empty array or throws; no defensive early-return exists for the empty-workers case | Flagged as an Open Item, not asserted as a confirmed crash — no runtime evidence available per `_ar/tasks/Runtime-truth-policy.md`. |

## Side Effects

None. Both endpoints are a pure read — no Organisation, Application, or other entity state is
created, updated, or deleted (**Confirmed** — no `->save()` call in either `get()` method).

## Hazards (current-state)

- **Anonymous, unauthenticated read access to per-organisation Application counters.** Both
  `restful get organisation_resource_v30`/`v32` permissions are granted to the anonymous role
  (`config/user.role.anonymous.yml`), despite `authentication: cookie` being declared in the resource
  config. Any external caller who supplies (or enumerates/guesses) a valid Organisation UUID can read
  that organisation's name and full Application-status breakdown with no login. This is the same
  current-state pattern as several other public "restful get" endpoints on this platform (e.g.
  API0011's Supplier catalogue), but here the payload is organisation-specific operational data
  (Application counts tied to that organisation's staff), not generic public reference data — a
  materially higher sensitivity than a public catalogue feed.
- **No tenant/ownership check.** The resource never verifies the calling user is associated with the
  requested Organisation (as owner, key account manager, or worker) — it will return any organisation's
  counters to any caller who can supply that organisation's UUID, compounding the anonymous-access
  hazard above.
- **`stats.total_amount` is hardcoded to `0` in both resource versions** — this field name implies a
  real monetary total but the code never computes or queries it; any consumer relying on this field
  for a total-donation figure is reading a permanently-stale placeholder value. Recorded here as a
  code-confirmed current-state defect, not a hypothesis.
- **No pagination, filtering, or field selection** — not elevated further; the response is a small
  fixed-shape counter object, not a list resource.
- **No rate limiting, HMAC, or request-signing evidenced** on either endpoint — consistent with the
  project-wide current-state pattern of REST resources having no additional transport-level integrity
  or throttling control in the scanned source.
- **Organisation UUID is not a secret and is not treated as one** — UUIDs are typically exposed
  elsewhere (e.g. admin UI links, exports); combined with the anonymous-access hazard above, this
  effectively makes per-organisation Application statistics a guessable/enumerable public data source
  in the current system.

## References

- EN: EN0018 (Organisation — name, worker roster, key account manager), EN0001 (Application —
  `patron` reference and the moderation-state vocabulary the count buckets partition)
- FN: FN0018 (Identity & Access Control — general permission model; this endpoint's `restful get`
  gate sits outside the entity-level `organisation` permissions FN0018 otherwise governs)
- UC: none identified — see Open Items
- BR: BR-ApplicationStatusGovernance (governs the Application state vocabulary partitioned by the
  `org_stats_*` config buckets; referenced, not restated)

## Open Items

- **No UC/FN dossier grounds this endpoint's consumer-side usage.** No use-case or capability document
  currently mines where/how an organisation dashboard UI calls `/api/{3.0,3.2}/organisation`. This
  contract is grounded directly in the REST resource source and the EN0018/EN0001 entity docs; a
  future UC pass may sharpen the "Purpose" and "Consumers" sections once that consumer flow is mined.
- **Which version (v3.0 or v3.2) the live SPA/admin UI actually calls** is not evidenced in this
  backend-only source tree (**Partial**).
- **Empty-worker-roster query behavior is Uncertain** — whether an Organisation with zero workers
  causes an uncaught error or simply returns `0` for every bucket is not confirmed against a live
  instance (see Failure Outcomes).
- **Anonymous-access grant may be unintentional** (a stock Drupal REST-permission default left open
  rather than a deliberate public-API decision) — recorded as a current-state fact only; whether this
  is intended is Unknown and should be confirmed with the product/security owner before the rebuild
  either preserves or closes this access path.
