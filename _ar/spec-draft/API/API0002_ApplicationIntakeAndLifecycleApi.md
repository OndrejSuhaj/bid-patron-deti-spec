---
doc_id: API0002
title: Application Intake & Lifecycle Api
canonical_layer: API
spec_type: api-contract
contract_type: rest-public
status: draft
references:
  - UC0001
  - UC0025
  - UC0002
  - EN0001
  - EN0002
  - EN0003
  - FN0001
  - BR-ApplicationStatusGovernance
---

# API0002 – Application Intake & Lifecycle Api

## Purpose

The public-facing REST surface, exposed by the `application` module, through which an anonymous
visitor or an already-authenticated Customer creates an Application (EN0001) case, fills in its
role-scoped questionnaire (ApplicationProfile, EN0002) across one or more submission steps, resumes
or discards a draft, and reads the list of Applications associated with a party. This is the
front-end SPA's sole channel into the Application intake/fill/resume lifecycle (UC0001, UC0025);
Admin-side status orchestration (UC0002) is not exposed here — it is a back-office form, not a REST
resource of this module.

## Consumers

- The public Patronus front-end (SPA), for the self-registration, multi-step application form,
  draft-resume prompt, and "my applications" list screens.
- An anonymous visitor (not-yet-identified fundraiser/patron), for creation and progressive fill.
- An authenticated Customer (fundraiser/patron/"zone" user), for the same actions plus the
  "my applications"/"my children" listing endpoints.

## Versioning

The module exposes three concurrent generations of overlapping endpoints, distinguished only by URL
path segment (`/api/2.x/...`, `/api/3.0/...`, `/api/3.2/...`) and by which `rest.resource.*.yml`
config has `status: true`. There is no version-negotiation header or content-type versioning; each
version is a separate `RestResource` plugin/route. Findings below are per-endpoint; "Current" marks
the highest-numbered enabled variant found for that capability.

| Capability | v2.x / legacy | v3.0 | v3.2 | Current (enabled) |
|---|---|---|---|---|
| Create application (lead) | `/api/3.0/application_create` (root ns, **disabled**, stub) | `/api/3.0/application_create` (`v30` ns, **disabled**, stub `rest disabled`) | `/api/3.2/application_create` (**enabled**) | v3.2 |
| Read application-profile step data | — | `/api/3.0/application` GET (**enabled**) | `/api/3.2/application` GET (**enabled**) | both enabled; v3.2 is the newer parallel path — **Open Item**: not evidenced which one the current SPA build actually calls |
| Submit application-profile step data | `/api/2.3/application` (`v23` ns, **enabled** but handler returns `[]` — effectively a no-op stub) | `/api/3.0/application` POST (**enabled**, full logic) | `/api/3.2/application` POST — **file not found under `v32/`; only `v32/ApplicationCreateResource.php`, `ApplicationGETResource.php`, `CancelApplicationResource.php`, `UserApplicationResource.php`, `UserChildrenResource.php`, `ApplicationRepeatResource.php` exist** even though `rest.resource.application_rest_resource_v32.yml` (`status: true`, plugin_id `application_rest_resource_v32`) declares the resource | v3.0 POST is the only fully-implemented step-submit handler found in this module's source tree |
| Progress-save (autosave) | `/api/2.2/application_progress` (**enabled**) | — | — | v2.2 (only variant found) |
| Cancel/discard application | `/api/cancel_application/{uuid}` (**enabled**) | — | `/api/3.2/cancel_application/{uuid}` (**enabled**) | both enabled in parallel |
| Repeat/duplicate application | — | `/api/3.0/application/repeat` (**enabled**) | `/api/3.2/application/repeat` (**enabled**) | both enabled in parallel; v3.2 differs in duplicated-profile field scope (see Open Items) |
| List user's applications | — | `/api/3.0/user_applications` (**enabled**) | `/api/3.2/user_applications` (**enabled**) | both enabled in parallel; v3.2 drops the `user_id` query parameter and resolves the user from the session instead |
| List user's children | `/api/3.0/user_children` (root/legacy ns id `user_children_resource`, **enabled**) | `/api/3.0/user_children` (`v30` ns, id `user_children_resource_v30`, **disabled**) and `/api/3.1/user_children` (id `user_children_resource_v30`… labelled "v3.1 (delete me)", **status not read — see Open Items**) | `/api/3.2/user_children` (**enabled**) | root-ns v3.0 and v3.2 both enabled in parallel; v3.2 drops the `user_id` query parameter |
| Validate session (standalone) | `/api/application_session` (**disabled**, handler hardcodes an "invalid" response) | — | — | none — dead code |

**Open Item:** because several endpoints exist enabled in more than one version concurrently with no
version-selection contract, which version the front-end actually calls per screen is not evidenced
from backend source alone.

## Authorization

All endpoints in this contract authenticate via the Drupal `cookie` provider only (each
`rest.resource.*.yml` declares `authentication: [cookie]`; no `basic_auth`/`oauth2` provider is
configured for this module). There is no HMAC, shared-secret, or API-key scheme on any endpoint in
this contract.

Access is gated by the Drupal permission `restful <method> <resource_plugin_id>` (e.g.
`restful post application_rest_resource_v32`). Cross-checking `user.role.anonymous.yml` against
`user.role.authenticated.yml`:

- **Confirmed hazard:** every endpoint in this contract that is enabled (`status: true`) grants the
  matching `restful get|post <resource>` permission to **both** the `anonymous` and `authenticated`
  roles identically. There is no role that has access to a lower/higher tier of these endpoints —
  anonymous callers have exactly the same permission grant as authenticated ones. The only
  discriminator between "my own data" and "someone else's data" is possession of the opaque
  `application_id` (UUID) / `session_id` (UUID) pair, or (for the `_v32` "my applications"/"my
  children" endpoints) the caller's own session-resolved user id.
- No endpoint here checks a Drupal entity-level access handler (`_entity_access`) or a custom
  `_custom_access` route requirement — access control is enforced only inside each Resource's `post()`
  /`get()` method body (ad hoc, per-resource), not declared in `application.routing.yml` (REST
  resources are not routed through that file at all; they are routed via the core `rest` module from
  the `rest.resource.*.yml` configuration, which is why `application.routing.yml` shows no
  corresponding paths).

## Session / possession model (cross-cutting)

Most endpoints in this contract do not use Drupal's authenticated-user identity as the authorization
boundary. Instead they use a possession-based token pair:

- `application_id` — the Application's (EN0001) UUID.
- `session_id` — an ApplicationSession (EN0003) UUID, looked up and required to be `Active`
  (`status: 1`) for the matching `application_id` before the request is allowed to proceed.

Anyone holding a valid, active `(application_id, session_id)` pair — e.g. from an email link — can
read or write that Application's profile data and cancel the Application, regardless of Drupal login
state. This is a Confirmed current-state design, not a defect introduced by this contract; see
Hazards below for its implications.

## Endpoints

### 1. `POST /api/3.2/application_create` — Create Application (lead)

- **Contract type:** command
- **Status:** Confirmed / Current. Source:
  `application/src/Plugin/rest/resource/v32/ApplicationCreateResource.php`; config
  `rest.resource.application_create_resource_v32.yml` (`status: true`).
- Superseded/dead variants: root-namespace `ApplicationCreateResource.php` and
  `v30/ApplicationCreateResource.php` are both wired (`status: true` in their `.yml`) but their
  `post()` method is a hardcoded stub returning `{"status":"failed","error":"rest disabled"}` — dead
  code paths kept enabled at the routing layer. **Confirmed hazard.**

**Request**

| Field | Meaning | Required | Notes |
|---|---|---:|---|
| `user_type` | Role being registered for this case | yes | Must be exactly `patron` or `fundraiser`; any other value → 400-style failure body |
| `lead_email` | Contact email for the new lead | conditionally | Required only when the caller is not already an authenticated ("zone") user; validated for mail-domain plausibility via the platform's email-validation helper |
| `lead_phone` | Contact phone for the new lead | no | |
| `interface_type` | Selects a specialised intake variant | no | Observed values include an organisation-mandated-fundraiser variant (`organisation_with_mandator`) and Ukraine-relief variants (substring `_ukr`); drives `lead_role` derivation and a situational flag |
| `mandator_id` | UUID of an existing User acting on behalf of an incapacitated applicant | no | When present, sets `lead_source` to a "zone_profi" origin and links that User as `fundraiser` on the case |
| `source` | Situational campaign/relief source code | no | Observed values include COVID-relief codes (`corona_rent`, `corona_basic_box`); when present, sets a `covid19` flag and pre-fills gift category/subcategory/price on the profile — **Hypothesis, current-state legacy behavior, not evidenced as still campaign-relevant today** |

**Response — Success**

| Field | Meaning | Notes |
|---|---|---|
| `status` | `"successful"` | |
| `application_id` | UUID of the newly created Application (EN0001) | |
| `session_id` | UUID of the ApplicationSession (EN0003) created for `user_type` | |

**Failure Outcomes**

| Outcome | Meaning | Retryable | Notes |
|---|---|---:|---|
| `user_type: patron or fundraiser value required` | `user_type` missing or invalid | yes | |
| `Email validation error` | `lead_email` missing/invalid for a non-authenticated caller | yes | Only checked when the caller is not an authenticated "zone" user |

**Side Effects**

- Creates a Contact (EN0006) "lead contact" record (or reuses one found by email) unless the caller
  is an authenticated "zone" user, in which case the caller's own linked Contact is reused.
- Creates an Application (EN0001) in status `new`, recording lead role/source and marketing/tracking
  attribution (`x_tracking_*` headers, IP, user agent).
- Creates/updates an ApplicationProfile (EN0002) for `user_type`, pre-filled from the Contact or, for
  an authenticated caller, from the caller's own party record.
- Creates an ApplicationSession (EN0003) for `user_type` (see EN0003; per UC0001).
- **Confirmed hazard:** for an authenticated "zone" caller, notifies an internal Slack channel that a
  new lead was created (`logger.slack` service) — an operational side channel not modelled elsewhere
  in this contract.

**Open Items**

- Whether the front-end currently targets this `v32` endpoint exclusively, or still calls the dead
  `v30`/root stubs for some flows, is not evidenced from backend source.
- The exact rule set behind `source`-driven pre-fill (COVID relief codes) is hardcoded in this
  resource and not owned by any BR doc found in this pass — flagged, not resolved, here.

---

### 2. `GET /api/3.2/application` (and parallel `GET /api/3.0/application`) — Read Application-Profile Step Data

- **Contract type:** query
- **Status:** Confirmed / both Current in parallel. Source:
  `application/src/Plugin/rest/resource/v32/ApplicationGETResource.php` and
  `v30/ApplicationGETResource.php` (byte-for-byte identical logic in this pass); configs
  `rest.resource.application_rest_resource_get_v32.yml` and `..._get_v30.yml`, both `status: true`.
- Supports UC0025.1 (Resume Draft Application).

**Request**

| Field | Meaning | Required | Notes |
|---|---|---:|---|
| `application_id` (query) | Application UUID | yes | |
| `session_id` (query) | ApplicationSession UUID | yes | Must match an `Active` ApplicationSession for `application_id`; the session's `role` determines which profile (fundraiser/patron) is returned |

**Response — Success**

| Field | Meaning | Notes |
|---|---|---|
| `user_type` | Role resolved from the session (`fundraiser` or `patron`) | |
| `interface_type` | The session's access-interface variant (e.g. `default`, `invited`, `custom`, `upload_contract`, `upload_gift_proof`, `new_patron`) | See EN0003 |
| `schema` | Session-carried form definition, if any | Only meaningful for `interface_type = custom` (e.g. signing/feedback steps) |
| `editable` | Whether the session is read-only | Derived from the session's `readonly` flag |
| `data` | Role-scoped questionnaire field values already saved on the ApplicationProfile (EN0002) | Field set depends on `interface_type`/invited state; see "Field Catalogue" below; attachment/consent fields are never returned (`available_for_get: false`) |
| `static_data` | Read-only contextual fields about the *other* party/child (e.g. counterpart's name, gift summary) shown to an invited party before they have their own profile | Only present for the invited-counterpart branch |

**Failure Outcomes**

| Outcome | Meaning | Retryable | Notes |
|---|---|---:|---|
| `application_id and session_id are required` (400) | One or both query params missing | yes | |
| `session_is_invalid` (400) | No matching `Active` ApplicationSession found | yes (with a corrected/refreshed pair) | Supports UC0025 AF1 |

**Side Effects**

- None (read-only); response is explicitly marked non-cacheable.

**Open Items**

- Which of the two enabled, functionally-identical `v30`/`v32` GET variants the current front-end
  build calls is not evidenced.

---

### 3. `POST /api/3.0/application` — Submit Application-Profile Step Data

- **Contract type:** command
- **Status:** Confirmed / this is the only fully-implemented step-submit handler found for this
  capability. Source: `application/src/Plugin/rest/resource/v30/ApplicationPOSTResource.php`; config
  `rest.resource.application_rest_resource_v30.yml` (`status: true`).
- **Confirmed hazard / versioning gap:** `rest.resource.application_rest_resource_v32.yml` declares
  plugin_id `application_rest_resource_v32` with `status: true`, and both `anonymous`/`authenticated`
  roles grant `restful post application_rest_resource_v32` — but **no
  `v32/ApplicationPOSTResource.php` (or any POST-handling class registering that plugin_id) exists**
  in this module's `src/Plugin/rest/resource/v32/` directory. This is either (a) dead/removed code
  left wired at the config layer, or (b) implemented in a module or file not covered by this pass's
  ground truth (`application` module REST plugins only). Flagged as **Open Item**, not resolved here.
  The legacy `v23/ApplicationResource.php` (`create` route `/api/2.3/application`, also `status: true`)
  is itself a stub whose `post()` returns an empty array unconditionally — also effectively dead.

**Request**

| Field | Meaning | Required | Notes |
|---|---|---:|---|
| `application_id` | Application UUID | yes | |
| `session_id` | ApplicationSession UUID | yes | Must resolve to a valid session (`ApplicationService::getApplicationSession`) |
| `finished` | Marks this submission as the final step of the current fill | no (boolean) | Drives finalization side effects (contacts/party update, activation emails, moderation-state action, session deactivation) |
| `data` | Object of role-scoped questionnaire field values | yes (object) | Server-side allow-listed to a fixed field catalogue per role (fundraiser/patron); unknown keys are silently dropped (`staging_log.unknown_fields` reports them only outside production); see "Field Catalogue" below for the shape; validated/normalized per-field type (boolean, number, phone, email, entity_reference, file, string, string_long, `rodne_cislo` — birth identifier, city, list) |

**Field Catalogue (fundraiser role, non-exhaustive — see source for full list and per-field
max-length/allowed-value constraints):** `story_background`, `story_problems`, `story_solution`,
`child_about`, `traffic_source` (+`_other`), `gift_price`, `gift_proof` (+`_other`), `gift_category`,
`gift_subcategory` (+`_source`/`_other`), `gift_supplier` (+`_source`/`_other`), `child_first_name`,
`child_last_name`, `child_rc` (birth identifier), `child_address_city/street/zip`,
`child_dont_disclose_name`, `child_dont_disclose_photo`, `unborn_child`, `fundraiser_first_name`,
`fundraiser_last_name`, `fundraiser_email`, `fundraiser_phone`, `fundraiser_rc`,
`fundraiser_address_city/street/zip`, `fundraiser_double_address`,
`fundraiser_address2_city/street/zip`, `fundraiser_child_different_address`,
`fundraiser_housing_type` (+`_other`), `fundraiser_household_members_adults/minors`,
`fundraiser_income_type` (+`_other`, multi-valued), `fundraiser_income_job_position`,
`fundraiser_employer_name`, `fundraiser_employer_address_street`,
`fundraiser_household_income/expenses`, `fundraiser_debts_exist`,
`fundraiser_household_execution/insolvency`, `patron_first_name/last_name/email/phone`,
`patron_occupation` (+`_list`/`_list_other`), `attachement_child_photo/id_copy/documents` (write-only),
`agreement_truthfulness/rules/personal_data` (write-only consent flags), `attachment_contract` /
`attachment_gift_proof`+`text_gift_proof` / `attachment_feedback`+`text_feedback` (write-only,
interface-scoped), `custom_text`/`custom_attachment` (write-only, `interface_type = custom` only).

**Field Catalogue (patron role, non-exhaustive):** `patron_reject` (+`_reason`),
`story_background`, `child_first_name/last_name`, `fundraiser_first_name/last_name/email/phone`,
`patron_first_name/last_name`, `patron_occupation` (+`_list`), `patron_dont_disclose_photo`,
`patron_photo` (write-only), `patron_email/phone`, `patron_employer_name`,
`agreement_truthfulness/rules/personal_data` (write-only).

**Response — Success**

| Field | Meaning | Notes |
|---|---|---|
| `status` | `"success"` | |
| `action` | Present and set to `"preview"` only on the digital-signature/acceptance-protocol finalization branch (see BR-ContractAndESignature) | |
| `schema` | Present only alongside `action = "preview"`; a rendering schema for the signed-document preview screen (contract or acceptance-protocol download links + signature confirmation markdown) | Not a generic step schema — specific to the signature-preview branch |
| `staging_log` | Non-production diagnostic block (submitted fields, unknown-fields, validation errors, saved fields) | **Confirmed hazard candidate:** gated only on an `environment` site setting, not a permission — see Hazards |

**Failure Outcomes**

| Outcome | Meaning | Retryable | Notes |
|---|---|---:|---|
| `application_id and session_id are required` (400) | Missing identifiers | yes | |
| `Session is invalid` (400) | No matching ApplicationSession | yes (with corrected pair) | |
| (silent field drop) | A submitted field fails its type-specific validation | n/a | Not surfaced as a request failure — the field is silently unset/truncated and the request otherwise proceeds to 200; only visible to the caller via `staging_log` outside production |

**Side Effects**

- Validates and persists submitted `data` onto the role-scoped ApplicationProfile (EN0002), plus
  server-captured `ip_address`/`user_agent`.
- On `finished = true` and specific interface/status combinations, produces a digital-signature or
  acceptance-protocol preview response (delegates to Contract, EN0011 — see BR-ContractAndESignature;
  not restated here).
- Saves interface-scoped attachments (contract upload, gift-proof upload, feedback upload) and, for
  feedback uploads, creates a Feedback record against the Application's Campaign.
- On patron-role rejection (`data.patron_reject = true`), sets the Application's status directly to a
  "returned to new patron" status via `setState(...)` and deactivates the session — a direct state
  assignment, structurally analogous to the `CancelApplicationResource` hazard noted in UC0025's BR
  note (bypasses the role-gated transition path used by UC0002).
- On `finished = true`: creates/updates the User (EN0008)/Contact (EN0006) records for fundraiser,
  patron, and child (email/RC-keyed upsert), sends a cross-invite completion email to the counterpart
  when applicable (see MSG0002), sends account-activation email if the relevant party account is
  blocked, executes the `updateApplicationModerationState` action, and deactivates the current
  session (promoting the counterpart's session from `invited` to `authenticated_invited` when that
  counterpart already has an active account).

**Open Items**

- The production successor to this `v30` handler at `/api/3.2/application` (POST) is declared enabled
  in config but has no corresponding source file in this module — see hazard above. Any rewrite must
  either locate that implementation elsewhere or treat `v32` POST as not-yet-implemented.
- Per-field validation failures are silently dropped rather than rejected; whether this is
  intentional graceful-degradation or an unnoticed defect is not evidenced.

---

### 4. `POST /api/2.2/application_progress` — Save In-Progress Step State (Autosave)

- **Contract type:** command
- **Status:** Confirmed / only variant found. Source:
  `application/src/Plugin/rest/resource/ApplicationProgressResource.php`; config
  `rest.resource.application_progress_rest_resource.yml` (`status: true`).
- Supports the incremental-save portion of UC0025 (Resume/Discard Draft Application).

**Request**

| Field | Meaning | Required | Notes |
|---|---|---:|---|
| `application_id` | Application UUID | yes | |
| `session_id` | ApplicationSession UUID | yes | Validated via `ApplicationService::isSessionValid` |
| `touched_inputs` | Arbitrary client-supplied structure describing which form inputs have been touched | yes (implied) | Persisted verbatim (JSON-encoded) into the profile's `progress` field — not a business field, purely a UI resume-state marker |
| `steps_completed` | Count of form steps completed so far | yes (implied) | Cast to integer and persisted into the profile's `progress_steps_completed` field |

**Response — Success**

| Field | Meaning | Notes |
|---|---|---|
| `status` | `"successful"` | |

**Failure Outcomes**

| Outcome | Meaning | Retryable | Notes |
|---|---|---:|---|
| `application_id and session_id are required` (200 body, not an HTTP error status) | Missing identifiers | yes | **Confirmed hazard candidate:** failure is signalled only in the JSON body with HTTP 200, not a 4xx status — see Hazards |
| `Session is invalid` (200 body) | Session lookup failed | yes | Same 200-with-body-error pattern |
| (validation-violation message string, 200 body) | ApplicationProfile-level validation failed on save | yes | Message text is the raw, stripped-of-tags violation message — not a structured error code |

**Side Effects**

- Creates the role-scoped ApplicationProfile (EN0002) for this Application if one does not already
  exist, and links it onto the Application (new revision suppressed for this link-only save).
- Persists `progress`/`progress_steps_completed` onto the ApplicationProfile.
- Every request is logged verbatim (full request body) to the `application_progress` log channel —
  see Hazards (PII-in-logs risk, given this payload rides alongside the same session as full
  questionnaire data on other endpoints).

**Open Items**

- None beyond the response-shape hazard noted above.

---

### 5. `POST /api/cancel_application/{application_uuid}` and `POST /api/3.2/cancel_application/{application_uuid}` — Cancel/Discard Application

- **Contract type:** command
- **Status:** Confirmed / both enabled in parallel, functionally identical. Source:
  `application/src/Plugin/rest/resource/CancelApplicationResource.php` and
  `v32/CancelApplicationResource.php`; configs `rest.resource.cancel_application_rest_resource.yml`
  and `..._v32.yml`, both `status: true`.
- Supports UC0025.3 (Delete/Discard Draft Application).

**Request**

| Field | Meaning | Required | Notes |
|---|---|---:|---|
| `application_uuid` (path) | Application UUID | yes | |
| `session_id` (body) | ApplicationSession UUID | yes | Must resolve to an `Active` (`status: 1`) session for `application_uuid` |

**Response — Success**

| Field | Meaning | Notes |
|---|---|---|
| `status` | `"successful"` | |

**Failure Outcomes**

| Outcome | Meaning | Retryable | Notes |
|---|---|---:|---|
| `application_id and session_id are required` (200 body) | Missing identifiers | yes | Same 200-with-body-error pattern as above |
| `Session is invalid` (200 body) | No matching active session | yes | |
| `Not found` (200 body) | `application_uuid` does not resolve to an Application | no (unless corrected) | |

**Side Effects**

- **Confirmed hazard (already flagged at UC/BR level):** sets the Application's status directly to
  `canceled_by_user` via `setState(...)`, bypassing the role-gated transition/workflow path used by
  UC0002 (Orchestrate Application Status Change). No call to session deactivation is present in this
  resource — the Application's own `ApplicationSession` (EN0003) records are not evidenced to be
  deactivated by this action (see UC0025 Open Questions; ownership of this invariant belongs to
  BR-ApplicationStatusGovernance, not restated here).

**Open Items**

- Whether ApplicationReaction (EN0026)-driven downstream effects that normally fire on a
  transition-driven status change are skipped here (since this bypasses that path) is not evidenced.

---

### 6. `GET`/`POST /api/3.0/application/repeat` and `GET`/`POST /api/3.2/application/repeat` — Duplicate a Prior Application

- **Contract type:** command (POST) / query (GET)
- **Status:** Confirmed / both enabled in parallel with a behavioral difference. Source:
  `application/src/Plugin/rest/resource/v30/ApplicationRepeatResource.php` and
  `v32/ApplicationRepeatResource.php`; configs `rest.resource.application_repeat_resource.yml`
  (`v30`'s underlying id) and `..._v32.yml`, both `status: true`.
- **GET is documented dead in v3.2:** the `v32` GET handler's own inline comment reads "Remove Get
  request on FE & BE" and it now returns an all-empty stub body unconditionally; the `v30` GET handler
  still performs the real gift/patron-name lookup. **Confirmed hazard/inconsistency**, not resolved
  here.

**Request (GET)**

| Field | Meaning | Required | Notes |
|---|---|---:|---|
| `child_id` (query) | Child Contact UUID | conditionally | Either this or `application_id` required (v30 only — see status note above) |
| `application_id` (query) | Application UUID | conditionally | Either this or `child_id` required (v30 only) |

**Response — Success (GET, v3.0 only; v3.2 always returns the empty shape below)**

| Field | Meaning | Notes |
|---|---|---|
| `gift` | Human-readable gift category > subcategory label from the prior application's fundraiser profile | Empty string if unavailable |
| `gift_price` | Prior application's requested gift price | |
| `gift_supplier` | Prior application's gift supplier label | |
| `patron_name` | Prior application's patron's full name | |

**Request (POST)**

| Field | Meaning | Required | Notes |
|---|---|---:|---|
| `application_id` | UUID of the prior Application to duplicate | conditionally | Either this or `child_id` required |
| `child_id` | Child Contact UUID | conditionally | When given without `application_id`, the *last* Application for that child is duplicated |
| `user_wants_to_edit` | Whether the fundraiser wants an editable session on the new duplicate before it is sent to the patron | no (boolean) | Drives which response shape is returned |

**Response — Success (POST)**

| Field | Meaning | Notes |
|---|---|---|
| `status` | `"successful"` (edit path) or `"success"` (send-to-patron path) | Inconsistent value between the two branches — **Confirmed, not corrected here** |
| `application_id` | UUID of the newly duplicated Application | Only present on the edit (`user_wants_to_edit = true`) path |
| `session_id` | UUID of a new fundraiser ApplicationSession on the duplicate | Only present on the edit path |

**Failure Outcomes**

| Outcome | Meaning | Retryable | Notes |
|---|---|---:|---|
| `child_id is required` / `application_id is required` (400, GET only) | Neither/wrong identifier supplied | yes | v3.0 GET only |
| `child_id or application_id are required` (400, GET only) | Neither identifier supplied | yes | v3.0 GET only |
| (unhandled) | POST with neither `application_id` nor `child_id` resolvable | n/a | **Open Item**: source calls `$application->getPatron()` unconditionally after the duplicate branch; if `$application` is `NULL` this is a latent fatal-error path, not a modelled failure response — flagged, not fixed, here |

**Side Effects**

- Duplicates the prior Application's fundraiser ApplicationProfile (EN0002) — full duplicate in v3.0
  (finished markers cleared); in v3.2 only three fields (`child_first_name`, `child_last_name`,
  `child_rc`) are copied onto a fresh profile — a **Confirmed behavioral divergence** between the two
  concurrently enabled versions, not merely a superset/subset relationship.
- Creates a new Application (EN0001), carrying over fundraiser/patron/child references, with
  `lead_source = zone_repeat` and moderation/status seeded to `new` or a "waiting for patron" status
  depending on `user_wants_to_edit`.
- Creates a patron ApplicationSession (EN0003) for the duplicate, and — on the edit path — a
  fundraiser ApplicationSession.
- On the non-edit path, sends the new Application's link to the existing patron (see MSG0002).

**Open Items**

- The v30-vs-v32 profile-duplication scope difference (full profile vs. three fields) is a material
  behavioral divergence between two endpoints exposed at the same time; not resolved as a single
  "current" behavior in this pass.

---

### 7. `GET /api/3.0/user_applications` and `GET /api/3.2/user_applications` — List a Party's Applications

- **Contract type:** query
- **Status:** Confirmed / both enabled in parallel with a parameter-contract difference. Source:
  `application/src/Plugin/rest/resource/v30/UserApplicationResource.php` and
  `v32/UserApplicationResource.php`; configs `rest.resource.user_application_resource_v30.yml` and
  `..._v32.yml`, both `status: true`.

**Request**

| Field | Meaning | Required | Notes |
|---|---|---:|---|
| `role` (query) | Which relationship to list by (`fundraiser`, `patron`, `organisation_worker`) | yes | |
| `user_id` (query) | UUID of the User whose applications to list | yes in v3.0; **absent/unused in v3.2** | v3.2 instead resolves the acting user from the authenticated session (`current_user`) — a **Confirmed contract-shape divergence** between the two enabled versions, not a pure superset |
| `child_id` (query) | Child Contact UUID | no | When present, lists by child instead of by party |

**Response — Success**

| Field | Meaning | Notes |
|---|---|---|
| `user.name` | Resolved user's full name | |
| `user.roles` | Resolved user's roles | |
| `child.name`, `child.ready_to_apply` | Present only when `child_id` was supplied | |
| `applications[].application_id` | Application UUID | |
| `applications[].last_update` | Application's last-updated timestamp | |
| `applications[].status` | Current Application status code | See EN0001 status vocabulary |
| `applications[].status_message` / `status_description` | Status-reaction-driven display text (with token replacement) or a fallback workflow-state label | Sourced from ApplicationReaction (EN0026) configuration — content owned there, not restated here |
| `applications[].role` | The `role` this listing was filtered by | |
| `applications[].title` | Application's display name | |
| `applications[].category` | Coarse category label, mapped from a small hardcoded taxonomy-term-id table | **Hypothesis**: hardcoded ID→label map (`71..76`) is fragile to taxonomy changes; flagged, not fixed |
| `applications[].theme_color` / `theme_icon` | Display theming hints from the matched ApplicationReaction | |
| `applications[].additional_actions[]` | Optional secondary actions (e.g. "Náhled žádosti", "Detail příběhu") | |
| `applications[].button_action` / `button_action_query_data` / `button_action_text` | Primary call-to-action for this Application, if any is currently applicable | Derived from ApplicationReaction configuration or a fallback "custom interface" session lookup |
| `applications[].campaign_slug` / `raised_amount` / `full_amount` / `photo` | Present only when a Campaign (EN0004) is linked | |
| `applications[]._debug` | Present only outside the production environment setting | **Confirmed hazard candidate** — see Hazards |

**Failure Outcomes**

| Outcome | Meaning | Retryable | Notes |
|---|---|---:|---|
| `role is required` (400) | `role` missing | yes | |
| `user_not_found` (404, v3.0 only) | `user_id` does not resolve | yes (with a corrected id) | Not applicable to v3.2, which has no `user_id` parameter |
| `child not found` (404) | `child_id` supplied but does not resolve | yes | |

**Side Effects**

- May create a new read-only ApplicationSession (EN0003) as a side effect of computing the "preview
  application" action link (`getReadOnlyApplicationSession`) — a query endpoint with a
  write-on-read side effect. **Confirmed, flagged as an architectural note, not corrected here.**

**Open Items**

- The v3.0 vs v3.2 parameter-contract divergence (`user_id` required vs. absent) means these are not
  interchangeable calls; which one the current front-end build issues is not evidenced.

---

### 8. `GET /api/3.0/user_children`, `GET /api/3.2/user_children` — List a Party's Children

- **Contract type:** query
- **Status:** Confirmed / root-namespace-v3.0 (`user_children_resource`, path `/api/3.0/user_children`)
  and v3.2 both enabled in parallel with a parameter-contract difference; the *namespaced*
  `v30/UserChildrenResource.php` (config `user_children_resource_v30`) is `status: false` (disabled);
  a further "v3.1" class (`v30/UserChildren1Resource.php`, label literally "User children resource
  v3.1 (delete me)", route `/api/3.1/user_children`) exists — **its own `rest.resource.*.yml` was not
  found under this search and its enablement state is therefore an Open Item**, but its `get()` body
  is an unconditional empty-array stub regardless. Source:
  `application/src/Plugin/rest/resource/UserChildrenResource.php` (root ns) and
  `v32/UserChildrenResource.php`; configs `rest.resource.user_children_resource.yml` and
  `..._v32.yml`.

**Request**

| Field | Meaning | Required | Notes |
|---|---|---:|---|
| `user_id` (query) | UUID of the User whose children to list | required in root-ns v3.0; **absent/unused in v3.2** | v3.2 resolves the acting user from the authenticated session instead — same divergence pattern as endpoint 7 |
| `user_type` (query) | `patron` or `fundraiser` — which relationship column to join on | yes (v3.2); optional in v3.0 (defaults to fundraiser join if not `patron`) | |

**Response — Success**

| Field | Meaning | Notes |
|---|---|---|
| `[].child_id` | Child Contact UUID | |
| `[].name` | Child's full name | |
| `[].ready_to_apply` | Whether this child is currently eligible for a new Application | Business rule for this flag is owned elsewhere (not this contract) |

**Failure Outcomes**

| Outcome | Meaning | Retryable | Notes |
|---|---|---:|---|
| `user_type is required` (400, v3.2 only) | `user_type` missing | yes | v3.0 has no equivalent guard (silently defaults) |
| (empty array, 200) | `user_id` not found (v3.0) | n/a | Not surfaced as an error — v3.0 returns `[]` rather than a 404 |

**Side Effects**

- None (read-only).

**Open Items**

- Enablement state of the `/api/3.1/user_children` route (`UserChildren1Resource`) is not confirmed
  from the config files found in this pass.

---

### 9. `POST /api/application_session` — Validate Session (standalone)

- **Contract type:** utility
- **Status:** Confirmed dead code. Source:
  `application/src/Plugin/rest/resource/ValidateSessionResource.php`; config
  `rest.resource.validate_session_rest_resource.yml` (`status: false` — disabled at the config layer
  in addition to the handler's own hardcoded body).

**Request:** none meaningfully consumed — the handler ignores its input entirely.

**Response:** hardcodes `{"status":"invalid"}` with HTTP 400 on every call, regardless of input.

**Side Effects:** none.

**Open Items:** none — retained in this contract only to document that it exists and is inert, so a
rewrite does not need to preserve or reimplement it.

---

## Hazards (current-state, flagged for the rebuild)

1. **No authorization tier below "possession of a UUID pair."** Every enabled endpoint in this
   contract grants identical `restful <method> <resource>` permission to `anonymous` and
   `authenticated` roles (Confirmed, `user.role.anonymous.yml` vs `user.role.authenticated.yml`).
   Authorization for reading/writing a specific Application's profile, or cancelling it, rests
   entirely on possession of its `(application_id, session_id)` pair — there is no additional
   ownership check tying the session to the calling Drupal user, except on the `_v32`
   "my applications"/"my children" listing endpoints, which resolve identity from the authenticated
   session instead of a caller-supplied `user_id`.
2. **Error responses returned with HTTP 200.** `ApplicationProgressResource`,
   `CancelApplicationResource` (both versions), and `ApplicationRepeatResource` (POST) all signal
   business failures (`status: "failed"`) inside a `200 OK` body rather than a 4xx status — API
   consumers that check only the HTTP status code will silently treat these as success.
3. **Non-production diagnostic leakage gated by an environment flag, not a permission.**
   `ApplicationPOSTResource`'s `staging_log` block and `UserApplicationResource`'s (both versions)
   `_debug` block are suppressed only when `Settings::get('environment') === 'production'` — any
   misconfigured or non-production-labelled environment exposes internal session/reaction objects and
   raw submitted-field diagnostics to the same anonymous-eligible caller described in Hazard 1.
4. **Config/code drift: an enabled resource with no implementing handler found.**
   `rest.resource.application_rest_resource_v32.yml` (`application_rest_resource_v32`, `status: true`)
   grants `restful post` to anonymous/authenticated roles for a plugin whose PHP class was not found
   under `application/src/Plugin/rest/resource/v32/` in this module. Either the implementation lives
   elsewhere (outside this module's ground truth) or this is a dangling, never-actually-callable
   route at the Drupal plugin-discovery layer — not resolved here.
5. **Silent field/validation dropping instead of request rejection.** `ApplicationPOSTResource`
   removes or truncates individual invalid fields and still returns `200 success`; a caller has no
   way to detect a partial save without inspecting `staging_log` (itself gated per Hazard 3).
6. **Direct state assignment bypassing the governed transition path.** `CancelApplicationResource`
   (both versions) and the patron-rejection branch of `ApplicationPOSTResource` call
   `setState(...)` directly instead of going through the role-gated transition machinery used by
   UC0002 — see BR-ApplicationStatusGovernance (not restated here) and UC0025's BR note.
7. **PII-bearing verbatim request logging.** `ApplicationProgressResource` and
   `ApplicationCreateResource`/`ApplicationPOSTResource` log the full raw request body
   (`json_encode($data)`) to standard Drupal log channels (`application_progress`, `application`,
   `application_create`) with no field redaction — given these payloads carry personal data (names,
   birth identifiers, addresses, emails, phones), this is a Confirmed current-state data-handling
   hazard for the rebuild to address, not an instruction to preserve.
8. **Concurrently-enabled, behaviorally-divergent version pairs.** Sections 6, 7, and 8 above each
   document a case where two versions of "the same" endpoint are both `status: true` at the same time
   but return materially different contracts (parameter requirements, duplicated-field scope, or dead
   vs. live GET logic) — a rewrite must pick one canonical current behavior per capability rather than
   assuming the higher version number is a strict superset.
9. **No CSRF/anti-forgery or rate-limiting evidence.** No CSRF token requirement, request-signing, or
   throttling was found configured for any endpoint in this contract (cookie-auth REST resources in
   this Drupal version typically rely on the `X-CSRF-Token` header for state-changing requests only
   when using session-cookie auth for a *logged-in* user; for the anonymous/possession-token path
   documented here, no such control was found at all) — flagged as Open Item, not confirmed as
   present or absent beyond what these Resource classes show.

## References

- UC: UC0001, UC0025, UC0002
- EN: EN0001, EN0002, EN0003
- FN: FN0001
- BR: BR-ApplicationStatusGovernance (transition-legality/direct-state-assignment hazard ownership),
  BR-ContractAndESignature (signature-preview branch, referenced not restated), BR-PartyIdentityAndDeduplication (email/RC-keyed party upsert, referenced not restated)
- MSG: MSG0002 (Application Completion Link / cross-invite email), MSG0003/MSG0004 (activation/magic-link email family, referenced not restated)

## Open Items

- Which concurrently-enabled version (`v3.0` vs `v3.2`, or root-namespace vs. namespaced) each
  front-end screen actually calls is not evidenced from backend source in any of the flagged
  divergences (endpoints 2, 6, 7, 8).
- The missing `v32` POST implementation for `/api/3.2/application` (endpoint 3) is unresolved — flag
  for the rebuild team to locate or explicitly retire the config entry.
- Enablement state of `/api/3.1/user_children` (`UserChildren1Resource`) is unconfirmed.
- Exact CSRF/anti-forgery posture for the anonymous/possession-token path is unconfirmed (Hazard 9).
