---
doc_id: API0018
title: Platform Base API (Initialization & RabbitMQ Stub)
canonical_layer: API
spec_type: api-contract
status: draft
contract_type: rest-public
references:
  - EN0004
  - EN0009
  - FN0006
  - UC0023
---

# API0018 – Platform Base API (Initialization & RabbitMQ Stub)

## Purpose

Two unrelated, low-level HTTP surfaces exposed by the `patron_base` module's own REST resource
plugins (`web/modules/custom/patron_base/src/Plugin/rest/resource/`):

1. **`GET /api/init`** — a single parameterless lookup that returns global, site-wide aggregate
   figures (active/completed Campaign counts, average/total paid donation amounts, supporter count,
   a per-region/per-category breakdown, and "transparent account" proof figures) consumed by the
   public homepage/landing surface to render trust/proof statistics. **Confirmed**, source:
   `InitializationResource.php`.
2. **`POST /api/2.2/rabbitmq`** — a versioned (`v2.2`) stub endpoint that accepts an arbitrary
   request body and unconditionally returns a hard-coded success acknowledgement without reading,
   validating, queuing, or persisting the submitted data in any way. **Confirmed**, source:
   `v22/RabbitMQRestResource.php`.

The two endpoints share no data model, no consumer, and no lifecycle relationship; they are grouped
into a single contract only because they are the entire REST-resource-plugin surface owned by the
`patron_base` module (`InitializationResource` and `RabbitMQRestResource` are the only two classes
under `src/Plugin/rest/resource/`). The module's other two HTTP-facing endpoints
(`POST /api/file` — file upload, `GET /api` — base-URL lookup) are plain Drupal
`_controller` routes declared in `patron_base.routing.yml`, not REST resource plugins, and are noted
here only as adjacent module surface, not part of this contract's payload scope (see Open Items).

## Consumers

- **`GET /api/init`** — the public-facing homepage/landing page (anonymous website visitor or any
  session) that renders global proof/trust statistics (campaign counts, total donated, supporter
  count, region map). **Confirmed** by the shape of the returned data (`globals.campaigns`,
  `globals.proof_stats`, `globals.region_stats`, `globals.transparent`); no calling
  frontend template/JS is present in this backend-only source tree, so the exact rendering surface
  is **Partial**.
- **`POST /api/2.2/rabbitmq`** — unknown/unevidenced. No source reference to this path exists
  anywhere else in the scanned `patron_base` module or elsewhere in the custom-module tree
  (cross-checked against `_ar/evidence/flow-index.md` FL056, which independently rates this endpoint
  `Hypothesis` — "is RabbitMQ actually used or scaffolding?"). **Uncertain** — no confirmed consumer.

## Authorization

- **`GET /api/init`** — publicly reachable, no login required. **Confirmed**:
  `rest.resource.initialization_rest_resource.yml` declares `authentication: [cookie]`,
  `methods: [GET]`, no `_permission`/`_access` route constraint (no dedicated route exists in
  `patron_base.routing.yml` for this path — it is registered purely as a Drupal REST-module
  resource, gated by the generic `restful get initialization_rest_resource` permission).
  `config/user.role.anonymous.yml` and `config/user.role.authenticated.yml` both grant
  `restful get initialization_rest_resource` (source: `user.role.anonymous.yml:119`,
  `user.role.authenticated.yml:129`). No other role file grants or restricts it.
- **`POST /api/2.2/rabbitmq`** — likewise publicly reachable, no login required. **Confirmed**:
  `rest.resource.rabbitmq_rest_resource_v22.yml` declares `authentication: [cookie]`,
  `methods: [POST]`, no `_permission`/`_access` constraint. `config/user.role.anonymous.yml` and
  `config/user.role.authenticated.yml` both grant `restful post rabbitmq_rest_resource_v22` (source:
  `user.role.anonymous.yml:165`, `user.role.authenticated.yml:175`). No other role file grants or
  restricts it.
- Net effect for both endpoints: **anonymous, unauthenticated access — no session, token, or role
  is required to call either one.** Neither endpoint reads `$this->currentUser` in a way that
  branches behavior (`InitializationResource` injects `AccountProxyInterface` but the property
  assignment is commented out; `RabbitMQRestResource` injects it but never reads it in `post()`).

## Request

### Endpoint inventory

| # | Method + Path | Plugin ID | Config file |
|---|---|---|---|
| 1 | `GET /api/init` | `initialization_rest_resource` | `rest.resource.initialization_rest_resource.yml` |
| 2 | `POST /api/2.2/rabbitmq` | `rabbitmq_rest_resource_v22` | `rest.resource.rabbitmq_rest_resource_v22.yml` |

### Versioning notes

Both plugin IDs and the task brief describe this module as spanning `v3.1`/`v3.2`/`v3.3` version
lines elsewhere in the platform (as seen on other modules, e.g. the Campaign/Supplier families).
**Neither endpoint in this contract follows that pattern** — **Confirmed**, code:

- `initialization_rest_resource` has **no version segment at all** in its `uri_paths` (`canonical`
  = `/api/init`) and **no alternate version directory** exists under
  `src/Plugin/rest/resource/` for an "initialization" resource. There is exactly one version of
  this endpoint in current source.
- `rabbitmq_rest_resource_v22` carries a **`v2.2`** designator (both in its plugin ID suffix and in
  its `uri_paths` — `create` = `/api/2.2/rabbitmq`), which is *older*, not newer, than the
  `v3.x` line seen elsewhere in the platform. No `v2.3`, `v3.0`, `v3.1`, `v3.2`, or `v3.3` variant
  of this resource exists anywhere in the custom-module tree (**Confirmed** — a single
  `v22/` subdirectory is the only version namespace under
  `patron_base/src/Plugin/rest/resource/`).

Current version for both endpoints is therefore simply **the only version that exists** — there is
no multi-version folding to perform for this module, unlike other API contracts in this set (e.g.
API0011's Supplier v2.3/v3.2 pair).

### Inputs — `GET /api/init`

| Field | Meaning | Required | Notes |
|---|---|---:|---|
| *(none)* | Parameterless lookup | — | **Confirmed** — `get()` reads no query/path parameter and takes no arguments. |

### Inputs — `POST /api/2.2/rabbitmq`

| Field | Meaning | Required | Notes |
|---|---|---:|---|
| *(unconstrained)* | Request body is accepted as `array $data` by the method signature | no | **Confirmed** — the `post(array $data)` method body never reads `$data`; any JSON body (or none) is accepted and silently discarded. No field, shape, or content-type validation exists. |

## Response

### Success — `GET /api/init`

| Field | Meaning | Notes |
|---|---|---|
| `globals.campaigns.active` | count of Campaigns (EN0004) with `campaign_status = active` | integer; entity query on the `campaign` entity type, `accessCheck()` left at default (enabled) |
| `globals.campaigns.completed` | count of Campaigns with `campaign_status` in `[completed, completed_partly]` | integer |
| `globals.proof_stats.payment_avg` | average donation amount | **hard-coded constant `500`** — **Confirmed, not a computed average**; the method body ignores actual Transaction (EN0009) data and always returns the literal `500` |
| `globals.proof_stats.payments_total_amount` | sum of paid donation amounts | integer; raw SQL `SUM(price)` over `{transaction}` filtered to `ext_status = 'PAID' AND is_donation = 1 AND test = 0` |
| `globals.proof_stats.supporters_total` | count of distinct donors | integer; raw SQL `COUNT(DISTINCT user_id)` over `{transaction}` with the same `PAID`/`is_donation`/`test` filter |
| `globals.region_stats` | per-region, per-category active-Campaign counts, plus a `combined` per-region total | object; keys are hard-coded CZ region-slug and gift-category-slug labels (14 regions, 6 categories) mapped from raw taxonomy-term IDs baked into the PHP source (`kraj` term IDs 1–14, `gift_category` term IDs 71–76); rows with a `kraj`/`gift_category` value **outside** these hard-coded ID ranges are silently dropped from the response (no fallback/"other" bucket) |
| `globals.transparent.campaigns` | count of "transparent"-flagged Campaigns | integer; `1060 + COUNT(DISTINCT campaign) FROM transaction WHERE transparent=1` — the `1060` is a **hard-coded historical base offset** added on top of the live count |
| `globals.transparent.allocated` | total amount routed through the transparent/collection account, excluding the account's own Campaign | integer; `SUM(price) FROM transaction WHERE transparent='1' AND ext_status='PAID' AND campaign != <transparent_account setting>` |

Response is cacheable for up to 1 hour (`#cache max-age: 3600`, cache context `url`, cache tag
`campaigns` — **Confirmed**, `ResourceResponse::addCacheableDependency()`).

### Success — `POST /api/2.2/rabbitmq`

| Field | Meaning | Notes |
|---|---|---|
| `status` | fixed literal | always the string `"success"`, HTTP `200` — **Confirmed**, unconditional; no branch in `post()` can produce any other value |

### Failure Outcomes

| Outcome | Meaning | Retryable | Notes |
|---|---|---:|---|
| `GET /api/init` — uncaught PHP error | `Settings::get('transparent_account')` missing/misconfigured, or a taxonomy/`kraj`/`gift_category` ID drifting from the hard-coded maps, could produce a null-dereference or SQL-shape error | not evidenced | **Uncertain** — no try/catch or defensive check exists in any of the private helper methods; would surface as a generic 5xx, not a structured API error. Not verified against a live instance per `_ar/tasks/Runtime-truth-policy.md`. |
| `POST /api/2.2/rabbitmq` — none observed | the endpoint has no failure branch at all | n/a | **Confirmed** — every call that reaches `post()` (i.e., passes Drupal's own REST/serializer request handling) returns `200 {"status":"success"}` regardless of payload content. |

## Side Effects

- **`GET /api/init`** — none. Pure read across `campaign` and `{transaction}`; no entity or database
  row is created, updated, or deleted (**Confirmed** — no `->save()` or `INSERT`/`UPDATE` statement
  in any method).
- **`POST /api/2.2/rabbitmq`** — **none** despite the path and plugin name implying a queue-publish
  action. **Confirmed** — the request body is never inspected, no RabbitMQ client/service is
  invoked, and no message is queued, published, or persisted anywhere in `post()`. The endpoint's
  name is the only evidence that a RabbitMQ integration was ever intended; the implementation is a
  no-op stub. This is consistent with the independent flow-mining evidence already on file
  (`_ar/evidence/flow-index.md` FL056: "RabbitMQ ... Hypothesis"; `_ar/spec-draft/FLOW-candidates.md`:
  "is RabbitMQ actually used or scaffolding?"; `_ar/spec-draft/DOMAIN-ubiquitous-language.md`:
  "Messaging infrastructure endpoint (Hypothesis-confidence, not confirmed in current behavior);
  transport plumbing, not a domain concept").

## Hazards (current-state)

- **`POST /api/2.2/rabbitmq` is a public, unauthenticated, no-op stub that always reports success.**
  Anyone (no login required) can `POST` any payload to this path and receive
  `200 {"status":"success"}` regardless of what — if anything — was supposed to happen with it. If
  any current or historical caller (internal or partner) treats this `200`/`success` response as
  confirmation that a message was actually queued/relayed, that caller is being silently misled —
  the response is unconditional and carries no relationship to the request body. There is no
  evidence in this source tree of what, if anything, currently calls this endpoint.
- **`GET /api/init` mixes real aggregate queries with hard-coded constants presented as computed
  data** (`payment_avg` is always the literal `500`; the transparent-campaign count adds a fixed
  historical offset of `1060`). A rewrite that treats this response as a faithful "average
  donation" or "campaign count" figure without accounting for these constants would reproduce
  stale/fabricated figures rather than the platform's live financial reality.
- **No pagination, filtering, rate limiting, HMAC, or request-signing on either endpoint** —
  consistent with the project-wide current-state pattern of anonymous public endpoints having no
  additional transport-level integrity or throttling control in the scanned source. Elevated to a
  named hazard here (rather than a routine note) specifically for `/api/2.2/rabbitmq`, because an
  unauthenticated endpoint that accepts and discards an arbitrary body is a wide-open surface for
  request volume/log-noise even though it performs no state-changing action today.
- **`region_stats` silently drops rows whose `kraj`/`gift_category` ID falls outside the hard-coded
  1–14 / 71–76 ranges** — if new regions or gift categories are ever added as taxonomy terms with
  IDs outside those ranges, they disappear from the public region/category breakdown with no error
  or log signal.
- **`InitializationResource` injects `AccountProxyInterface $current_user` but never assigns it to a
  property (the assignment line is commented out)** — dead constructor parameter; not a security
  hazard on its own (the endpoint is intentionally anonymous-accessible), but indicates the
  class was likely adapted from a session-aware resource without completing the adaptation.

## References

- EN: EN0004 (Campaign — the `campaign_status`, `kraj`/region, and `gift_category` attributes read
  by the region/category breakdown and active/completed counts), EN0009 (Transaction — the
  paid/donation/test flags read by the raw-SQL proof-stat and transparent-allocation queries)
- FN: FN0006 (Campaign / Story Lifecycle Management — owns the Campaign status vocabulary this
  endpoint counts against)
- UC: UC0023 (Browse & Filter Story Catalogue — the public homepage/catalogue surface this
  endpoint's proof statistics are inferred to support; UC0023 itself documents a *different*,
  `campaign`-module-owned region-count endpoint, `/campaign/regions/render` — the two are not the
  same contract, see Open Items)

## Open Items

- **No UC/FN dossier directly documents `/api/init`'s consumer-side usage.** The homepage/landing
  inference is drawn from the shape of the response payload (`globals.proof_stats`,
  `globals.transparent`, `globals.region_stats` all read as public "trust/proof" figures), not from
  a mined frontend call site — no calling template/JS exists in this backend-only source tree.
- **`/api/init`'s `region_stats` overlaps in subject (CZ region breakdown of active Campaigns) with
  the separately-documented `/campaign/regions/render` endpoint (owned by the `campaign` module,
  described under UC0023)** but is a distinct implementation with a distinct payload shape (combined
  per-category breakdown vs. UC0023's flat per-region active count for a picker widget). Whether
  both are live in production simultaneously, or one has superseded the other, is **not evidenced**
  in this source tree.
- **No consumer evidence exists at all for `POST /api/2.2/rabbitmq`.** Whether this stub is called
  by any current internal job, a legacy partner integration, or is dead/abandoned scaffolding is
  **Unknown** — flagged consistently with the pre-existing `Hypothesis`-level flow evidence (FL056).
- **`POST /api/file` (file upload) and `GET /api` (base-URL lookup)** are adjacent
  `patron_base`-owned HTTP surfaces reachable under `/api/*`, but are plain Drupal `_controller`
  routes (declared in `patron_base.routing.yml`, gated by the `access content` permission) rather
  than REST resource plugins. They are intentionally **out of scope** for this contract, which is
  scoped to the module's REST-resource-plugin surface per the task brief; if a future pass wants a
  contract for them, they should be scoped as a separate document, not folded in here.
- **Uncaught-error path on `/api/init`** (malformed `transparent_account` setting, drifting taxonomy
  IDs) is recorded as **Uncertain** above; no live-instance verification is available under the
  current Runtime-truth-policy.
