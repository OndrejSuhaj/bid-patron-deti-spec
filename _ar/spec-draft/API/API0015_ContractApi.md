---
doc_id: API0015
title: Contract API
canonical_layer: API
spec_type: api-contract
status: draft
contract_type: rest-internal
references:
  - UC0004
  - EN0011
  - EN0001
  - FN0009
  - ACL0007
---

# API0015 – Contract API

## Purpose

The `contract` custom module exposes exactly **one** REST resource plugin: a read-only status probe
for an Application's (EN0001) Contract (EN0011). All other contract-related HTTP surfaces in this
module (`contract.routing.yml`) are internal Drupal **HTML admin/back-office routes** (list, create,
send-to-manager, send-to-fundraiser, e-sign form) — not REST/JSON contracts — and are excluded from
this document; see Open Items.

Evidence: `contract/src/Plugin/rest/resource/v30/ApplicationContractResource.php`,
`config/rest.resource.application_contract_resource.yml`, `contract/contract.routing.yml`,
`contract/contract.permissions.yml`. Classification: **Confirmed** for the endpoint's existence and
implementation; **Confirmed** that it is currently config-disabled (see Versioning Notes).

The task framing for this contract mentioned folding v3.1/v3.2/v3.3 variants into one document. No
such variants exist in the `contract` module's codebase or config — only a single `v30` REST plugin
namespace and a single `rest.resource.application_contract_resource.yml` config entity were found.
Recorded as an evidence gap, not invented: **this module has no version family beyond v3.0.**

---

## Consumers

- Authenticated back-office session (coordinator/manager) — the only realistic current consumer,
  inferred from the plugin's stated purpose ("get view modes by entity and bundle" — see hazard on
  the mismatched docblock) and its placement alongside the admin-only contract workflow routes.
- Anonymous caller — technically permitted by role configuration (see Authorization) even though no
  UI or documented flow is evidenced to invoke it anonymously. Flagged as a hazard, not a confirmed
  consumer.

---

## Endpoints

### 1. Get Application Contract Status

- **Method / path:** `GET /api/3.0/application/contract/{application_uuid}`
  (`application_contract_resource` plugin, class `ApplicationContractResource`)
- **Format:** `json` only.
- **Resource-level config status:** `status: false` in
  `config/rest.resource.application_contract_resource.yml` — the REST resource is currently
  **disabled**. It is documented here as a current-state contract candidate (code + role grants
  exist), not as a live, callable endpoint. See Versioning Notes and Hazards.

No other method (`POST`/`PATCH`/`DELETE`) is defined on this plugin.

---

## Authorization

- **Mechanism:** REST resource plugin (not a Drupal routing-layer `_permission`/`_access`
  requirement). Authentication mode is `cookie` (`configuration.authentication: [cookie]`); there is
  no token/API-key scheme. Authorization is governed purely by the Drupal permission
  `restful get application_contract_resource`.
- **Role grants:** confirmed granted to **both `anonymous` and `authenticated`** roles (see ACL0007
  for the full current-state Contract-domain access matrix; this exact grant is listed there). No
  narrower role (coordinator/manager) is separately required — any caller matching either blanket
  role, logged in or not, that can reach the (currently disabled) resource would pass authorization.
- **No entity-level access check:** the resource's `get()` method does not load the target
  `ContractEntity` or consult `ContractEntityAccessControlHandler` — it does not use the
  `{application_uuid}` path parameter at all (see Hazards). There is therefore no per-Application or
  per-Contract authorization narrowing beyond the blanket role permission above.
- **Distinct from the UI e-sign route:** the module's HTML route
  `application.contract.sign` (`/application/{application}/contract`) uses a *different*,
  non-REST authorization mechanism — the custom `_application_role: fundraiser` route requirement
  (`ApplicationAccessCheck`), which checks that the logged-in Drupal user is the specific
  Application's fundraiser (or patron), not a blanket permission. That route is out of scope for this
  REST contract (see Open Items) but is noted here to avoid conflating the two authorization models.

---

## Request

### Get Application Contract Status — Inputs

| Field | Meaning | Required | Notes |
|---|---|---:|---|
| `application_uuid` (path) | UUID of the target Application (EN0001) | yes (per route pattern) | **Not read or validated by the resource implementation** — `get()` accepts the parameter but never dereferences it (see Hazards). Any value, including a non-existent or malformed UUID, produces the same response. |

No request body (`GET`).

---

## Response

### Get Application Contract Status — Success

| Field | Meaning | Notes |
|---|---|---|
| `status` | Literal string `"success"` | HTTP 200. Hardcoded — does not reflect any actual Contract (EN0011) state, signature progress, or Application (EN0001) status. |

No other fields are returned. There is no field reporting contract existence, document readiness,
signature status, or any data described in UC0004 / FN0009's Contract-and-signature lifecycle.

### Failure Outcomes

| Outcome | Meaning | Retryable | Notes |
|---|---|---:|---|
| None evidenced | The implementation has no conditional branches — it always returns HTTP 200 with the literal success payload, regardless of the `application_uuid` value supplied. | n/a | **Confirmed** by direct inspection of `ApplicationContractResource::get()` — no validation, no exception path, no 404/403 case is coded. |

---

## Side Effects

- Read-only by declared intent. **Confirmed no side effects** — the `get()` method performs no
  entity load, no write, and no dispatch of any kind; it returns a static array.
- The response is marked non-cacheable (`addCacheableDependency(['#cache' => false])`), so each call
  re-executes the (trivial) handler — this has no observable side effect, only a caching note.

---

## Versioning Notes

- Only one version exists: **v3.0** (`/api/3.0/...`). No `v31`/`v32`/`v33` REST plugin, routing
  entry, or config entity for `application_contract_resource` was found anywhere in
  `contract/src/Plugin/rest/` or `config/rest.resource.*`. This is recorded as a confirmed absence,
  not an oversight in this document.
- The v3.0 resource is the **current version** by definition (the only one), but is **not currently
  live**: `rest.resource.application_contract_resource.yml` has `status: false`. Whether it was ever
  enabled in production, and if so when/why it was disabled, is not evidenced in the available
  sources — see Open Items.

---

## Hazards (current-state)

- **Stub/dead implementation masquerading as a contract-status endpoint:** `ApplicationContractResource::get()`
  ignores its own `$application_uuid` argument entirely and unconditionally returns
  `{"status":"success"}`. The endpoint's URI (`/api/3.0/application/contract/{application_uuid}`) and
  its plugin `label` ("Application contract resource") both imply it reports on a specific
  Application's Contract, but no such lookup exists in the code. **Confirmed**
  (`contract/src/Plugin/rest/resource/v30/ApplicationContractResource.php:81-83`).
- **Docblock/purpose mismatch:** the class docblock reads "Provides a resource to get view modes by
  entity and bundle" — unrelated to the class name, URI, or actual (no-op) behavior. This suggests the
  plugin may be copy-pasted scaffolding that was never finished/wired to real logic. **Confirmed** by
  direct inspection of the docblock text; the implication (copy-paste origin) is **Hypothesis — not
  further evidenced.**
- **Anonymous role grant on a resource with no per-entity access check:** `anonymous` holds
  `restful get application_contract_resource` (per ACL0007), and the implementation performs no
  entity load or access-control-handler check of its own. If this resource were re-enabled
  (`status: true`) without also adding an authorization/entity-load fix, it would be publicly callable
  by design, though today it leaks no actual Contract data (see prior hazard) — the risk is latent,
  tied to future re-enablement rather than current exposure. **Confirmed** grant + **Confirmed**
  absence of entity-level check; **Hypothesis** on future risk if re-enabled unchanged.
- **Disabled-but-fully-wired:** unlike a resource that is disabled *and* ungranted (double-unreachable,
  as seen elsewhere in this codebase), this resource is disabled at the config layer (`status: false`)
  while still fully role-granted to `anonymous`/`authenticated`. Re-enabling it requires only a single
  config flip (`status: true`) — no accompanying permission change — which is a lower-friction path
  back to public exposure than resources requiring both a config and a permission change. **Confirmed**.

---

## References

- UC: UC0004 (Manage Contract & Signature — the orchestrated flow this endpoint's name/URI suggests it
  should report on, but does not)
- EN: EN0011 (Contract), EN0001 (Application)
- FN: FN0009 (Contract Generation & E-Signature)
- ACL: ACL0007 (Contract & Document Access — owns the `anonymous`/`authenticated` role grant for
  `application_contract_resource` cited above)

---

## Open Items

- The module's HTML admin/back-office routes (`contract.application`, `contract.application.create`,
  `contract.application.checking`, `contract.application.send_to_fundraiser`,
  `application.contract.sign`) in `contract.routing.yml` are Drupal form/controller routes, not
  REST/JSON contracts, and are out of scope for this API document. They implement the actual Contract
  generation, manager sign-off, and fundraiser e-signature flow described in UC0004/FN0009. Flagged
  here so a future UI/ARCH-facing pass does not lose them; not modeled as endpoints above.
- Whether `application_contract_resource` was ever live in production (`status: true`) prior to the
  current `status: false` snapshot, and why it was disabled, is not evidenced — recorded as
  **Uncertain**, not resolved here.
- Whether any external/mobile client currently depends on this endpoint's mere HTTP-200 response
  (e.g. as a naive "is the contract subsystem up" ping, given the payload carries no real data) is not
  evidenced in the available sources. If such a dependency exists, removing or fixing the endpoint in
  the rebuild would be a breaking change; flagged for clarification with the client, not assumed here.
- No BR-layer doc was found specifically named for this endpoint's (non-)behavior; `BR-ContractAndESignature`
  (referenced by EN0011/FN0009) governs Contract generation/signature substantively but does not
  mention this REST resource — consistent with the resource being unconnected scaffolding rather than
  a modeled business rule.
