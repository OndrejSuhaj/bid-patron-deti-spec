---
doc_id: API0012
title: Scoring & Risk API
canonical_layer: API
spec_type: api-contract
status: draft
contract_type: rest-internal
references:
  - UC0003
  - EN0017
  - EN0001
  - EN0002
  - EN0006
  - EN0016
  - FN0004
  - BR-ScoringAndRiskGating
  - ACL0003
---

# API0012 – Scoring & Risk API

## Purpose

Two independent, back-office-only REST resources exposed by the `scoring` custom module, grouped into
one contract because they share the module, the `cookie`-authenticated REST-plugin implementation
pattern, and the risk-review screen they support:

1. **Submit/Fetch Scoring Snapshot** (`scoring_rest_resource`) — a generic-looking create/read
   endpoint whose current implementation is a non-functional stub: `POST` always returns a hardcoded
   success without persisting anything, and `GET` always returns a hardcoded failure. No business
   logic is evidenced behind either method.
2. **Get Scoring Relationship Visualisation** (`scoring_visualisation_resource`) — a read-only graph
   (nodes/links) of the fundraiser/patron/child/campaign network connected to a given Application
   (EN0001), used to render the D3.js relationship graph on the scoring screen.

Both are implemented purely as REST resource plugins under `scoring/src/Plugin/rest/resource/`; the
module's `scoring.routing.yml` only defines internal HTML back-office routes (`ScoringForm`,
`ScoringLowRiskForm`, `AresController::searchByIco`, `ScoringController::visualisation`) which are
**not** REST contracts and are out of scope for this document — see Open Items. The actual manual
scoring submission (fields, verdict, blacklist classification) is performed by `ScoringForm` (an
HTML form, not a REST resource) and is modeled at UC0003 / FN0004 / BR-ScoringAndRiskGating, not here.

Evidence: `scoring/src/Plugin/rest/resource/ScoringResource.php`,
`scoring/src/Plugin/rest/resource/ScoringVisualisationResource.php`,
`config/rest.resource.scoring_rest_resource.yml`, `config/rest.resource.scoring_visualisation_resource.yml`,
`scoring/scoring.routing.yml`, `scoring/scoring.permissions.yml`.
Classification: **Confirmed** for endpoint shape/behavior (direct code read); see Versioning Notes for
an evidence-gap flag on the version framing.

---

## Consumers

- Back-office risk reviewer (the `risk_manager` role; see Authorization) — the only role explicitly
  granted the Scoring Snapshot resource.
- Administrator (`is_admin: true` bypass) — implicitly able to call either resource regardless of
  explicit role grants, per standard Drupal admin-role behavior.
- No public/anonymous or donor-facing consumer is evidenced for either endpoint.

---

## Endpoints

### 1. Submit/Fetch Scoring Snapshot

- **Create:** `POST /api/scoring` (`scoring_rest_resource` plugin)
- **Read:** `GET /api/scoring/{entity_name}/{entity_id}` (`scoring_rest_resource` plugin)
- **Format:** `json` only.
- **Config status:** `rest.resource.scoring_rest_resource.yml` → `status: false` — **the resource is
  currently disabled** in the enabled-config snapshot examined. Confirmed absent from the live
  surface, not an Open Item.

### 2. Get Scoring Relationship Visualisation

- **Read:** `GET /api/scoring/visualisation/{id}` (`scoring_visualisation_resource` plugin)
- **Format:** `json` only.
- **Config status:** `rest.resource.scoring_visualisation_resource.yml` → `status: true` — enabled.

---

## Authorization

Cross-checked against `scoring.permissions.yml`, all `config/user.role.*.yml` files (role-based REST
permissions, `restful <method> <plugin_id>`), and the REST resource `configuration.authentication:
[cookie]` setting on both resources. Neither resource declares an `_permission`/`_access` route
requirement of its own (they are REST-plugin routes, not routes declared in `scoring.routing.yml`);
access is governed entirely by the generic `restful get|post <plugin_id>` permission per role. This
is consistent with ACL0003 (Risk & Scoring Access).

| Endpoint | Role granted | Notes |
|---|---|---|
| `POST /api/scoring`, `GET /api/scoring/{entity_name}/{entity_id}` (`scoring_rest_resource`) | `risk_manager` only — `restful get scoring_rest_resource` + `restful post scoring_rest_resource` (per `user.role.risk_manager.yml`) | No other role (including `manager`, `coordinator`, `senior_coordinator`, `authenticated`, `anonymous`) is granted this permission. `administrator` reaches it via `is_admin: true`. **Also currently unreachable regardless of role grant** — config `status: false` disables the resource entirely (see Endpoints). |
| `GET /api/scoring/visualisation/{id}` (`scoring_visualisation_resource`) | **No role** in the examined config explicitly grants `restful get scoring_visualisation_resource` | Confirmed absent across all `user.role.*.yml` files, including `risk_manager`. Only `administrator` can reach it, via the `is_admin: true` bypass — not through an explicit permission grant. The HTML page that embeds this graph (`ScoringController::visualisation`, routed at `_permission: 'view scoring page'`, granted to `risk_manager`) is reachable by `risk_manager`, but the underlying data-fetch REST call the page's JS makes is not itself permission-granted to that role in the config examined. |

Authentication mode is `cookie` for both resources — a call requires an active Drupal session
(back-office login), not a bearer/API token.

No entity-level access control is consulted by either resource: `ScoringResource` performs no entity
load at all (see Side Effects); `ScoringVisualisationResource` loads `ApplicationEntity` directly via
static `::load()` without invoking Application's own access-control handler.

---

## Request

### Submit/Fetch Scoring Snapshot — Inputs

| Field | Meaning | Required | Notes |
|---|---|---:|---|
| (POST body) | Any JSON payload | no | `ScoringResource::post()` accepts an untyped `array $data` parameter but never reads it — the entire request body is ignored. **Confirmed** by direct inspection; no field is validated or persisted. |
| `entity_name` (path, GET) | Intended bundle/type discriminator for a scored entity | yes (by route shape) | Never used inside `get()` — the method ignores both path parameters. |
| `entity_id` (path, GET) | Intended numeric identifier of a scored entity | yes (by route shape) | Same as above — unused. |

### Get Scoring Relationship Visualisation — Inputs

| Field | Meaning | Required | Notes |
|---|---|---:|---|
| `id` (path) | Application (EN0001) identifier to build the relationship graph from | yes | Loaded via `ApplicationEntity::load($id)`; if the Application does not exist, a 400 is returned (see Failure Outcomes). |

No request body for either method of either resource.

---

## Response

### Submit/Fetch Scoring Snapshot — Success

| Field | Meaning | Notes |
|---|---|---|
| `status` | Literal `"successful"` (POST only) | HTTP 200. Unconditional — returned regardless of payload content, and no entity/record is created. **Confirmed** stub behavior. |

`GET` never returns a success shape: it always returns the failure body described below (HTTP 200,
not a genuine 4xx/5xx — see Failure Outcomes).

### Get Scoring Relationship Visualisation — Success

| Field | Meaning | Notes |
|---|---|---|
| `nodes` | Array of graph nodes, each `{id, name, color?}` | One node per distinct appId / campaignId / patronApp / fundraiserApp / patronName / patronEmail / patronPhone / fundraiserName / fundraiserIp / fundraiserEmail / fundraiserPhone / childName / childRc value discovered while walking the Application graph (EN0001, EN0002). Names are whitespace-normalized; empty/duplicate nodes and edge-less singleton nodes are filtered before response. |
| `links` | Array of graph edges, each `{source_id, target_id, name}` | `name` is a human-readable relationship label (e.g. `patron name`, `patron app`, `fundraiser app`, `email`, `phone`, `ip`, `ChildName`, `rc`, `campaignId`). Duplicate (undirected) links are suppressed. |

The graph is built by recursively following `patron`/`fundraiser` Application-to-Application links
(via a raw SQL lookup keyed on the `patron`/`fundraiser` entity-reference field) up to a fixed
recursion depth of 5 hops per side, so the response can represent a chain of related Applications, not
just the one identified by `{id}`.

### Failure Outcomes

| Outcome | Meaning | Retryable | Notes |
|---|---|---:|---|
| Submit/Fetch Scoring Snapshot: `GET` → HTTP 200, `{"status":"failed", "1":"Error with getting entity"}` | `get()` is an unconditional stub — always returns this body regardless of input | no (not input-dependent; code always takes this path) | **Confirmed.** HTTP status is 200 despite the payload signaling failure — current-state quirk, not corrected here. |
| Get Scoring Relationship Visualisation: HTTP 400, `{"status":"invalid","error":"invalid_id"}` | The `{id}` path parameter is empty or does not resolve to an existing Application (EN0001) via `ApplicationEntity::load()` | yes, with a valid Application id | Response also carries `addCacheableDependency(['#cache' => false])`. |

No other failure path is evidenced for either resource (e.g. no explicit handling for a malformed
`entity_id`/`id` type beyond routing-level type coercion).

---

## Side Effects

### Submit/Fetch Scoring Snapshot

- **None.** `post()` does not write to the `scoring_entity` content entity (EN0017's dormant carrier,
  per EN0017 Open Question 1), the Application (EN0001) record, or any other store — it only
  constructs and returns a hardcoded response. `get()` performs no read at all (no entity load,
  no query). **Confirmed** — this endpoint has no observable effect on system state under the current
  implementation, independent of its `status: false` config disablement.

### Get Scoring Relationship Visualisation

- Read-only. Loads the target Application (EN0001) and, recursively, up to 5 linked Applications per
  patron/fundraiser side (10 total lookups) via `ApplicationEntity::load()` plus one raw SQL query per
  hop (`\Drupal::database()->query()` against the `application` table). No writes.
- Response is explicitly marked non-cacheable (`addCacheableDependency(false)` / `['#cache' => false]`).

---

## Versioning Notes

No `v3.1`/`v3.2`/`v3.3` (or any other version-suffixed) REST plugin, route, or config entry exists for
either `scoring_rest_resource` or `scoring_visualisation_resource` — only the single unversioned
variant of each is present in the codebase and in config. The task framing's expectation of folding
v3.1/v3.2/v3.3 variants into one contract **does not apply to this module**; recorded here as an
evidence gap rather than invented. (Contrast with other `scoring`-adjacent modules in this codebase,
e.g. `account`/`campaigns`, which do carry `_v30`/`_v31`/`_v32`/`_v33` REST variants — that versioning
pattern simply was not adopted for the `scoring` module's own REST surface.)

---

## Hazards (current-state)

- **Non-functional Scoring Snapshot endpoint:** `scoring_rest_resource`'s `POST` unconditionally
  reports success without persisting the submitted payload, and its `GET` unconditionally reports
  failure without attempting a lookup. Any caller (or documentation, or a future integrator) that
  assumes this resource is a working create/read API for scoring data would be misled — it currently
  does nothing beyond echoing a fixed response. **Confirmed** by direct inspection of both method
  bodies; compounded by the resource also being config-disabled (`status: false`), so it is doubly
  inert — not reachable, and would do nothing useful even if re-enabled. Not evidenced whether this
  is legacy/abandoned scaffolding or an intentional placeholder; recorded as `Uncertain`.
- **Visualisation endpoint has no explicit role grant:** `scoring_visualisation_resource` is
  config-enabled (`status: true`) but no role in the examined `user.role.*.yml` set — including
  `risk_manager`, the role that otherwise owns the scoring screen — explicitly holds `restful get
  scoring_visualisation_resource`. Only the `administrator` role's blanket `is_admin: true` bypass can
  reach it. This means the scoring screen's own relationship-graph widget is not reachable by its
  intended back-office user (`risk_manager`) under the permission model as configured, unless an
  out-of-band grant exists that was not captured in the config files examined. **Confirmed** absence
  of the grant in config; **Uncertain** whether this reflects a real access gap in production (e.g. a
  broader permission not captured here) or a genuine current-state defect — flagged for
  clarification rather than resolved.
- **Unauthenticated relationship-graph fan-out has no confirmed depth limit on breadth:** the
  recursion depth is capped at 5 hops per side (10 Applications total), but each hop issues a raw SQL
  query with no pagination/limit beyond `LIMIT 1`; for a densely cross-linked patron/fundraiser
  dataset this is a bounded but non-trivial per-request cost. Not a security hazard given the
  authentication/authorization findings above, but noted as a latent performance consideration.
  **Partial** — no load-testing evidence exists either way.
- **PII exposure surface:** the visualisation response's `nodes` array can carry patron/fundraiser
  names, emails, phone numbers, IP addresses, and child name + rodné číslo (birth/ID number) in plain
  text, keyed only by Drupal's generic REST-permission gate (no field-level redaction). Given the
  adjacent hazard above (no explicit role grant found), the practical current-state exposure is
  limited to whichever account(s) can actually authenticate and reach the endpoint — but the response
  shape itself carries no built-in minimization. **Confirmed** shape; hazard framing is a current-state
  observation, not a proposed fix.

No anonymous-webhook or payment-callback-style hazards (e.g. hardcoded verify tokens, missing HMAC)
apply to this module — both `scoring` REST resources require `cookie` (session) authentication and
neither is a public inbound webhook.

---

## References

- UC: UC0003 (Assess Applicant Risk / Scoring) — the manual scoring form and automatic low-risk
  recalculation this contract's visualisation endpoint supports, and that the (non-functional)
  Scoring Snapshot endpoint does not actually implement.
- EN: EN0017 (ScoringRecord — the scoring snapshot this API's stub endpoint appears intended for but
  does not write to), EN0001 (Application — the aggregate the visualisation endpoint walks),
  EN0002 (ApplicationProfile — fundraiser/patron profile fields surfaced as graph nodes), EN0006
  (Contact), EN0016 (Blacklist)
- FN: FN0004 (Risk Scoring & Assessment)
- BR: BR-ScoringAndRiskGating
- ACL: ACL0003 (Risk and Scoring Access — documents the `risk_manager` role's
  `scoring_rest_resource` grant and the broader scoring permission set referenced above)

---

## Open Items

- The module's HTML routes (`scoring.scoring_form`, `scoring.scoring_low_risk_form`,
  `scoring.ares_controller_searchByIco`, `scoring.visualisation_controller` in `scoring.routing.yml`)
  are back-office forms/controllers gated by `_permission: 'view scoring page'` /
  `'view low risk scoring page'` / `'ares search by ico'`. These are Drupal form/controller routes,
  not REST contracts, so they are out of scope for this API document — flagged here so a future
  UI/ARCH-facing pass does not lose them. Not modeled as an endpoint above. The actual manual scoring
  submission (fields, verdict, blacklist classification) happens through `ScoringForm`
  (`scoring.scoring_form` route) and is modeled at UC0003, not here.
- Whether `scoring_rest_resource`'s stub `post()`/`get()` behavior is dead/abandoned scaffolding
  (e.g. a superseded predecessor to the HTML `ScoringForm` flow) or an unfinished integration point
  is not evidenced in this module alone. Hypothesis — not evidenced in current sources.
- Whether the missing explicit role grant for `scoring_visualisation_resource` (see Hazards) reflects
  the true production permission set, or an incomplete config export, is not resolvable from the
  sources examined for this contract. Conflict/gap — requires clarification.
- The dormant `scoring_entity` content entity (separate from both REST resources in this contract) has
  its own CRUD permissions (`add/edit/delete/administer scoring entity entities`) and HTML routes via
  `ScoringEntityHtmlRouteProvider`, but is not exposed through any REST resource in the current
  codebase — consistent with EN0017 Open Question 1 (dormant carrier, no current-state writer). Not
  modeled as an endpoint here since no REST surface exists for it.
