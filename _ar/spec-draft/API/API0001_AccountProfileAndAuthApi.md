---
doc_id: API0001
title: Account Profile & Auth API
canonical_layer: API
spec_type: api-contract
status: draft
contract_type: rest-public
references:
  - UC0014
  - UC0024
  - FN0018
  - EN0008
  - EN0006
  - EN0007
  - EN0034
---

# API0001 – Account Profile & Auth API

## Purpose

The public REST surface of the `account` module: login/logout, self-registration, account
activation, password recovery/reset, magic-link issuance and consumption, session/CSRF token
issuance, and the logged-in user's own profile read/update. It is the transport realization of
UC0014 (Authenticate & Manage Access) and UC0024 (Manage Donor Account — Self-Service), and of the
identity/session capability owned by FN0018.

The module is versioned in place (`/api/2.3/...`, `/api/3.0/...`, `/api/3.1/...`, `/api/3.2/...`).
Multiple concurrently-enabled versions of the same logical operation coexist in the current state;
this contract folds them into one logical operation per row and calls out behavioral differences
between versions rather than treating each version as a separate contract. **Current version in
active use: v3.2** (the newest resource variants); older versions (v0/"2.3", v3.0, v3.1) remain
enabled REST resources in the current codebase and are documented as-is, not assumed retired.

## Consumers

- **Customer** (unauthenticated visitor, or an authenticated applicant/patron/fundraiser/supporter) —
  the front-end SPA client, per UC0014/UC0024.
- **System** (server-side, same request/response boundary) — for the profile lookup-by-`user_id`/
  `slug` branches that do not require the caller's own session (see Open Items — these are treated
  as a public/query capability layered onto the same resource, not a separate consumer).

## Authorization

All endpoints in this module are registered as `rest.resource.*` config entities with
`authentication: [cookie]` (Drupal session-cookie auth) and **no `_permission` or `_role`
restriction at the REST-resource-config level** — access is enforced, if at all, only inside each
resource's own PHP logic, not declaratively. Cross-checked against
`config/rest.resource.account_*`, `config/rest.resource.profile_*`, `config/rest.resource.password_*`,
`config/rest.resource.send_activation_email_resource*`, `config/rest.resource.create_magic_link_resource_v32.yml`,
`config/rest.resource.email_organisation_resource.yml` (all `authentication: [cookie]`, no
`access_check`/`permission` key) (Confirmed).

Per-operation authorization reality, from the resource code itself:

- **Login, register, activate, password-recover, password-request, magic-link issuance, token/CSRF
  issuance** — open to anonymous callers by design (that is the point of these endpoints); the
  account-level permission `use magic link` exists in `account.permissions.yml` but is not
  referenced by any of the REST resources or their config — it is unused by this contract's
  endpoints (Confirmed: `grep` of `account.permissions.yml` usage found no code reference from the
  REST layer; **Open Item** for where, if anywhere, it is actually consulted).
- **Logout** (v3.2) — operates on whatever session is current; does not check the caller is actually
  authenticated first before destroying the session (Confirmed, `AccountLogoutResource::get()`).
- **Profile GET/POST (v3.0/v3.1)** — resolves the target user from a `user_id` (UUID) or `slug` query
  parameter with **no check that the caller's own session matches the target `user_id`** — any
  caller, authenticated or not, can read or write any other user's profile fields by supplying their
  UUID or slug (Confirmed hazard; see Hazards).
- **Profile GET/POST (v3.2)** — requires `\Drupal::currentUser()->isAuthenticated()` for GET, and
  always resolves the target from `$this->currentUser`, i.e. the caller's own session — this version
  closes the v3.0/v3.1 impersonation gap for the authenticated self-profile path (Confirmed,
  `v32/ProfileResource.php`). The v3.2 GET also carries an undocumented `backend_access_check` query
  flag that, when present, ignores the normal profile-field response and instead returns 200/403
  based on membership in a hardcoded back-office role list (`accountant`, `administrator`,
  `content_admin`, `coordinator`, `front`, `manager`, `marketing`, `risk_manager`,
  `senior_coordinator`) — a role-gate check smuggled into a resource named for profile retrieval,
  with no cross-check against `ACL` layer content since none exists yet for this operation (Confirmed
  code fact; **Open Item** — this looks like an access-check side-channel used by another part of the
  system, not itself part of the profile contract's stated purpose).
- **Profile-organisation, profile-slug, email-organisation-eligibility lookups** — anonymous-readable
  by design; no session check (Confirmed).

No `ACLxxxx` doc exists yet for this module's operations; this contract records the authorization
reality directly from code and role config (`config/user.role.*`) pending a dedicated ACL pass.

## Request / Response

Grouped by operation family. All request/response bodies are JSON (`formats: [json]` on every
`rest.resource.*` config entity in scope); all responses observed set `#cache: false` (never
cacheable).

### 1. Login

| Version | Method + Path | Confirmed/Partial |
|---|---|---|
| v0 ("2.3") | `POST /api/2.3/user/login` | Confirmed |
| v3.1 | `POST /api/3.1/user/login` | Confirmed |
| v3.2 | `POST /api/3.2/user/login` | Confirmed |

Request:

| Field | Meaning | Required | Notes |
|---|---|---:|---|
| `email` | Login identifier | yes (unless `hash` supplied, v3.2 only) | |
| `password` | Account password | yes (unless `hash` supplied, v3.2 only) | |
| `hash` | Base64 of `uid/timestamp/salt` — a login token in lieu of a password | no | v3.2 only; see Hazards — the salt-verification call targets an account-service method not present in the codebase (non-functional branch) |

Response (success):

| Field | Meaning | Notes |
|---|---|---|
| `status` | `"success"` | absent on v0 |
| `user_id` | Caller's User UUID (EN0008) | v3.1/v3.2 only; absent on v0 |
| `cookie_name` / `cookie_value` | Session cookie name/value | v0 only |
| `csrf_token` | REST CSRF token for subsequent write calls | all versions |

Failure outcomes: `missing_credentials` / `missing_credentials_email` / `missing_credentials_password`
(400/401), `user_is_not_active` (account blocked, 401), `invalid_username_or_password` /
`invalid_credentials` (401), flood-control error message (401, English hardcoded string, not a
translated key) — see Hazards for enforcement gaps.

### 2. Logout

| Version | Method + Path |
|---|---|
| v3.2 | `GET /api/3.2/user/logout` |

No request body. Response: `{"status": "success"}` (200) — always, regardless of whether a session
existed (see Authorization).

### 3. Self-registration

| Version | Method + Path |
|---|---|
| v0 ("2.3") | `POST /api/2.3/account/register` |

Request: accepts an arbitrary `data` array; **no field is read or validated by the resource**.
Response: `{"status": "success"}` (200) unconditionally. This endpoint is a **non-functional stub**
— it creates nothing (Confirmed, `AccountRegisterResource::post()` body is a single unconditional
return). The actual self-registration behavior described in UC0014.2/FN0018 is carried by a
different, non-REST registration engine that this stub does not invoke — see Hazards.

### 4. Account reset

| Version | Method + Path |
|---|---|
| v0 ("2.3") | `POST /api/2.3/account/reset` |

Request: accepts arbitrary `data`; **no field is read**. Response: `{"status": "success"}` (200)
unconditionally — also a non-functional stub (Confirmed, `AccountResetResource::post()`).

### 5. Account activation (set password from an activation session)

| Version | Method + Path |
|---|---|
| v0 ("2.3") | `GET /api/2.3/user/activate/{session_id}`, `POST /api/2.3/user/activate` |
| v3.2 | `GET /api/3.2/user/activate/{session_id}`, `POST /api/3.2/user/activate` |

GET request: `session_id` (path segment, must be a 36-character UUID-shaped string). Response
(success): `{"status": "valid", "email": "<user email>"}` (200). Failure: `{"status": "invalid",
"error": "session_invalid"}` (400).

POST request:

| Field | Meaning | Required | Notes |
|---|---|---:|---|
| `session_id` | Activation session identifier | yes | must be 36 chars |
| `password` | New password to set | yes | minimum 6 characters |

Response (success, v0): `{"csrf_token": "..."}` (200). Response (success, v3.2): `{"csrf_token":
"...", "login_hash": "..."}` (200) — v3.2 additionally returns a login-hash the client can use with
the v3.2 login endpoint's `hash` field (itself non-functional — see Hazards). Failure:
`session_invalid` (400) or `password_too_short` (400).

Side effects (success): the target User's password is set, `activate_session` is cleared, the
account is activated, last-access/last-login timestamps are updated, and the User is saved (EN0008
state transition: Registered → Active, per FN0018/UC0014).

### 6. Account status

| Version | Method + Path |
|---|---|
| v0 ("2.3"→published as v3.0 canonical) | `GET /api/3.0/user/status/{user_id}` |
| v3.2 | `GET /api/3.2/user/status` |

v3.0 request: `user_id` (path segment; the target user's UUID, looked up by anyone, no self-scoping).
Response (success): `{"activated": <bool>, "activation_email_sent": <bool>}` (200) — the latter
computed from whether the target user has any `PAID` Transaction (EN0009). Failure:
`{"status":"error","error":"user_not_found"}` (404).

v3.2 request: none — resolves strictly from the caller's own session. Response: empty body, 200 if a
session resolves to a real user, 403 otherwise. **Note: v3.0 and v3.2 are not the same contract** —
v3.0 is a public status lookup by UUID; v3.2 is a session-liveness probe with no field payload
(Confirmed — see Hazards for the v3.0 unscoped-lookup exposure).

### 7. Password recovery (validate a reset hash) and password reset

| Version | Method + Path |
|---|---|
| v0 ("2.3") | `GET/POST /api/2.3/user/password/recover` |
| v3.2 | `GET/POST /api/3.2/user/password/recover` |

v0 GET/POST: unconditionally returns `{"valid": true}` (200) — **non-functional stub**, no
validation actually performed (Confirmed). The v0 `rest.resource.password_recover_resource` config
entity is additionally disabled (`status: false`), so v0 is not even routable in the current
configuration (Confirmed from config) — retained here only for completeness/version-history.

v3.2 GET request:

| Field | Meaning | Required |
|---|---|---:|
| `email` | Account email (query param) | yes |
| `hash` | Reset hash previously issued (query param) | yes |

Response: `{"valid": true}` (200) if the hash matches a rehash of the account's last-login time;
`{"valid": false}` (400) otherwise. Failure: `missing_credentials_email` (401), `hash_invalid` (400),
`user_is_not_active` (401), `user_not_found` (404).

v3.2 POST request:

| Field | Meaning | Required | Notes |
|---|---|---:|---|
| `email` | Account email | yes | |
| `hash` | Reset hash | yes | |
| `new_password` | New password | yes | minimum 6 characters |

Response (success): `{"csrf_token": "...", "login_hash": "..."}` (200). Side effect: password is set,
username is re-set to the submitted email, User is saved (Confirmed — `PasswordRecoverResource
(v32)::post()`; the code comment flags the username re-set as a defensive workaround, not a designed
step). Failure outcomes as above plus `password_too_short` (400).

### 8. Password reset request (forgot-password email trigger)

| Version | Method + Path |
|---|---|
| v0 ("2.3") | `POST /api/2.3/user/password/request` |
| v3.2 | `POST /api/3.2/user/password/request` |

Request: `email` (required). Response (success): `{"status": "success"}` (200) — a password-reset
email is dispatched via the transactional-messaging capability (see FN0018/UC0014; message content
owned by MSG, not restated here). Failure: `missing_credentials_email` (401), `user_is_not_active`
(401), `user_not_found` (404). v0 and v3.2 are functionally identical (byte-for-byte equivalent
logic) (Confirmed).

### 9. Magic-link creation and consumption

| Version | Method + Path |
|---|---|
| v3.2 | `POST /api/3.2/user/create_magic_link` |
| n/a (route, not REST resource) | `GET /magic-link/{base64hash}` (`account.login` route, `AccountController::oneTimeLogin`) |

Create-magic-link request: `email` (required; validated for basic email shape via
`patron_base.default`). Response (success): `{"status": "success"}` (200) — a magic-link email is
dispatched (message content owned by MSG). Failure: `invalid_email_address` (400), `user_not_found`
(404).

The consumption side (`/magic-link/{base64hash}`) is a **Drupal route + controller, not a REST
resource** — it is out of this REST-contract's payload scope per rules-API (no controller-level
detail), and is registered with `_access: 'TRUE'` in `account.routing.yml` (open to any caller,
including already-authenticated ones — the commented-out `_user_is_logged_in: 'FALSE'` requirement
shows this was deliberately loosened at some point) (Confirmed from `account.routing.yml`).

### 10. Session / CSRF token

| Version | Method + Path |
|---|---|
| unversioned | `GET /api/session/token` (`account.csrftoken` route → Drupal core `CsrfTokenController`) |
| v3.0 | `GET /api/3.0/session/token` (`account.csrftoken` route, same controller) |
| custom | `GET /api/session/token` (`token_resource` REST plugin, distinct from the two routes above) |

The `token_resource` REST plugin (`canonical = /api/session/token`) responds `{"csrf_token": "..."}`
(200). Both `account.csrftoken` routes point at Drupal core's own `CsrfTokenController`, not at
account-module code, and are declared with `_access: 'TRUE'` — out of scope for controller-level
detail per rules-API; noted here only because the path collides with a custom REST resource plugin
of the same nominal purpose (see Hazards).

### 11. Send / resend activation email

| Version | Method + Path |
|---|---|
| v3.0 | `POST /api/3.0/user/send_activation_email` |
| v3.2 | `POST /api/3.2/user/send_activation_email` |

Request: `email` (required). Response (success): `{"status": "successful"}` (200); an activation
email is (re-)dispatched. Failure: `missing_credentials_email` (401), `user_not_found` (404),
`user_is_active` (401, i.e. the account is already active — the check is inverted from what the name
suggests: it rejects if the account is **not** blocked), `no_role` (401, if the target user holds
none of `supporter`/`fundraiser`/`patron`/`organisation_worker`). v3.0 and v3.2 are functionally
identical (Confirmed).

### 12. Own profile — read and update

| Version | Method + Path |
|---|---|
| v3.0 | `GET/POST /api/3.0/user/profile` |
| v3.1 | `GET/POST /api/3.1/user/profile` |
| v3.2 | `GET/POST /api/3.2/user/profile` |
| v3.2 | `GET /api/3.2/user/profile/{slug}` (`profile_slug_v32`, public-profile-by-slug lookup) |

GET (v3.0): target resolved from `user_id` **or** `slug` query parameter — any caller, no session
binding (see Hazards). GET (v3.1): target is always the caller's own session user
(`User::load($this->currentUser->id())`) with no fallback. GET (v3.2): requires an authenticated
session (403 otherwise); also always the caller's own session user; carries the `backend_access_check`
side-channel described in Authorization.

Response fields (all versions, from `PatronUser::getUserApiFields()` — owned by EN0008/EN0006, cited
not restated): `organisation_id`, `organisation_name`, `organisation_logo`, `user_image`, `public`,
`worker_available`, `slug`, `title_prefix`, `title_suffix`, `first_name`, `last_name`, `name_format`,
`email`, `badges`, `roles`, `user_id`, `donated_amount`, `campaigns_total`, `salutation`. See EN0008
for attribute semantics and EN0034 for the related donor-account read-model. Failure:
`user_not_found` (404).

POST request (fields the resource actually reads and applies — anything else submitted is ignored):

| Field | Meaning | Required | Notes |
|---|---|---:|---|
| `public` | Public-visibility flag | no | applied to User (EN0008) |
| `worker_available` | Worker-availability flag | no | applied to User (EN0008) |
| `title_prefix` / `title_suffix` | Name affixes | no | applied to Contact (EN0006); max 32 chars per UC0024 |
| `first_name` | First name | no | applied to Contact's `name` field |
| `last_name` | Last name | no | applied to Contact (EN0006) |
| `name_format` | Display-name mode | no | `full` \| `short` \| `hidden`; applied to Contact (EN0006) |
| `user_image` | Uploaded file UUID (array, first element used) | no | upload-then-attach pattern; three fixed derived image styles generated (`324x326`, `324x326@2`, `324x326@3`) |
| `password_old` / `password_new` | Password change | no | **v3.0/v3.1 only** — absent from v3.2 entirely (see Hazards / UC0024 AF3) |
| `user_id` / `slug` | Target-user resolution (v3.0/v3.1 only) | no | not read at all on v3.2, which always targets the caller's own session |

Response (success): same field set as GET, reflecting applied changes. Failure: `user_not_found`
(404, v3.0/v3.1 only — v3.2 always has a resolvable target since it is session-bound);
`password_old_not_accepted` (400, v3.0/v3.1 only, when `password_old` fails to verify — request is
otherwise fully rejected, no other submitted field is applied in that case).

**`email` is not an accepted update field on any version** — see UC0024 AF2 (current-state gap:
the account-settings UI shows an email field, but no version of this contract accepts an email
change from a logged-in caller).

### 13. Profile-organisation lookup (fundraisers linked to a patron)

| Version | Method + Path |
|---|---|
| v0 ("2.3"→published under 3.0) | `GET /api/3.0/mandators` |

Request: `user_id` (query parameter; patron's UUID). Response (success): array of
`{"user_id": "<fundraiser UUID>", "name": "<fundraiser full name>"}`, one entry per Application
(EN0001, cited not restated) where the given patron has a linked fundraiser. Failure:
`{"error": "user_not_found"}` (404). No session-scoping — any caller supplying a valid `user_id` can
retrieve this list (Confirmed; consistent with the module-wide anonymous-cookie-auth pattern, not
flagged as a distinct hazard beyond what's already noted for profile lookups).

### 14. Public-profile-by-slug and eligibility lookups (query-style, anonymous)

| Version | Method + Path |
|---|---|
| v0 | `GET /api/3.0/auth/email/eligible/{type}` (`email_organisation_resource`) |
| v3.2 | `GET /api/3.2/user/profile/{slug}` (`profile_slug_v32`, see also item 12) |

Eligibility request: `type` (path, must be `donation` or `patron`), `email` (query parameter).
Response: `{"eligible": <bool>}` (200) — for `type=donation`, true if no user exists for the email or
the existing user lacks the `organisation_worker` role; for `type=patron`, true if no user exists or
the existing user's worker-availability flag (EN0008) is set. Failure: `{"error": "missing_type"}`
(404) if `type` is not one of the two allowed values.

Profile-by-slug request: `slug` (path). Response: `PatronUser::getUserApiFields()` (same shape as
item 12) for the user matching the slug **and** flagged `public = 1`; `{"error": "user_not_found"}`
(404) otherwise; `{"error": "empty_slug"}` (400) if no slug supplied.

## Side Effects

- Successful login/activation/magic-link-consumption/password-reset: session established, last-login
  / last-access timestamps updated on the User (EN0008) — see UC0014.
- Successful account activation or password reset: User transitions Registered → Active (EN0008
  lifecycle, owned by EN0008 — cited not restated).
- Successful profile update: Contact (EN0006) fields updated and a new Contact revision persisted
  when any Contact field changed; User (EN0008) fields updated and saved when any User-level field or
  the profile photo changed — see UC0024.2.
- Several endpoints fire an internal Slack operational notification as a side effect of a successful
  or failed action (e.g. activation, login, password change, profile update) — this is an
  operational-alerting side effect, not a domain state change; content/routing of these notifications
  is out of this API contract's scope (see FN0023 if reconstructed).
- Password-reset-request and magic-link-creation dispatch a transactional email — message content and
  trigger ownership belongs to the transactional-messaging capability (FN0019 / MSG layer), cited not
  restated here.
- Registration and account-reset endpoints (item 3, 4) have **no side effects** — they are
  non-functional stubs (see Hazards).

## Failure Outcomes

See per-operation tables above. Common patterns across the module: `*_not_found` (404),
`missing_credentials*` (401), `*_invalid` / `*_too_short` (400), account-blocked (`user_is_not_active`,
401), and an inconsistently-enforced flood-control error (401) on login only. No endpoint in this
module returns a structured/typed error code beyond a free-text `error` string key — there is no
shared error-code enum across versions (Confirmed).

## Versioning Notes

- Three to four concurrently-registered versions exist for most operations (unversioned/`2.3`, `3.0`,
  `3.1`, `3.2`); all remain enabled (`status: true`) in current `rest.resource.*` config except
  `password_recover_resource` (v0, disabled) and `account_login_hash_resource_v32` (disabled despite
  being the newest login variant — see Hazards).
- The **current version in active use is v3.2** for login, logout, activation, status, password
  recovery/request, magic-link creation, profile, profile-by-slug, and send-activation-email. v3.0 is
  current for `/mandators` (profile-organisation) and the email-eligibility lookup, which have no
  v3.1/v3.2 successor in this module. v3.1 exists only for login and profile and sits between v0/v3.0
  and v3.2 in capability (adds `user_login_finalize()` and a returned `user_id`, absent from v0).
- Version drift is **not purely additive** — v3.2's profile POST silently drops the password-change
  branch present in v3.0/v3.1 (see item 12 and UC0024 AF3), and v3.0/v3.1's target-resolution-by-
  `user_id`/`slug` is replaced in v3.2 by strict self-session binding (see item 12 and Authorization).
  Treat each version's field set as authoritative for that version — do not assume a newer version is
  a strict superset of an older one.

## Hazards (current-state, code-confirmed)

- **Cross-user profile read/write on v3.0/v3.1** — `GET`/`POST /api/3.{0,1}/user/profile` resolve the
  target user from a `user_id` or `slug` request parameter with no check that it matches the caller's
  own session; any caller (including anonymous, since the REST-resource config carries no permission
  restriction) can read another user's full profile payload, and — on POST — modify another user's
  `public`/`worker_available` flags, Contact name fields, profile photo, and (v3.0/v3.1 only) password
  given only that user's UUID or slug. v3.2 closes this for the plain profile endpoint but the
  `backend_access_check` side-channel and the `/mandators` and profile-by-slug lookups remain
  unscoped-by-design (public lookups). **Confirmed, code-level.**
- **Non-functional stubs presented as live endpoints** — `POST /api/2.3/account/register` and
  `POST /api/2.3/account/reset` unconditionally return `{"status":"success"}` without reading their
  input or creating/changing anything; `GET/POST /api/2.3/user/password/recover` unconditionally
  returns `{"valid":true}` (and is additionally disabled in config). A caller cannot distinguish these
  from functioning endpoints by response shape alone. **Confirmed.**
- **Non-functional hash-login branch on the newest login version** — `POST /api/3.2/user/login`'s
  `hash`-based branch calls `\Drupal::service('account')->user_pass_rehash(...)`, a method not present
  on the `AccountService` class in this codebase; any request reaching that call path would fatal
  rather than authenticate. **Confirmed via absence in `AccountServiceInterface`/`AccountService`; not
  independently re-verified by execution (static analysis only, per Runtime-truth-policy).**
- **Login-hash resource disabled** — `account_login_hash_resource_v32` (`POST /api/3.2/user/login/hash`)
  is registered but `status: false` in config, and its implementation unconditionally returns
  `{"error":"invalid"}` regardless of input — a second, separate non-functional login surface.
  **Confirmed.**
- **Inconsistent flood-control enforcement** — the v0 and v3.1 login resources compute a flood-control
  rejection response inside `floodControl()` but the caller never uses that return value (the method's
  result is discarded), so the flood check has no actual enforcement effect on those two versions; only
  v3.2's login resource returns the flood-control response and blocks the request. **Confirmed,**
  carried into FN0018 Constraints.
- **State-changing GET requests** — account activation-check (`GET .../user/activate/{session_id}`)
  and profile-organisation/eligibility/slug lookups are GETs, which is normal for reads, but the
  activation GET also triggers a Slack notification as a side effect of a plain read; not a security
  hazard by itself but noted since it breaks the safe-method (no side effect) expectation for GET.
- **No CSRF protection on state-changing calls beyond the cookie-auth default** — every POST endpoint
  in this module relies solely on Drupal's default cookie-session REST auth; several endpoints exist
  specifically to *issue* a CSRF token (item 10) for use elsewhere, but none of the endpoints in this
  contract itself appear to require that token be presented back (not evidenced either way from the
  resource code alone — flagged as an **Open Item**, not asserted as a confirmed gap).
- **Duplicate CSRF/token endpoints at colliding paths** — a Drupal-core CSRF-token route and a custom
  `token_resource` REST plugin both expose a same-purpose token under `/api/session/token`-family
  paths (see item 10); which one actually serves a given request depends on Drupal route-matching
  priority, not evidenced here. **Open Item.**

## References

- UC: UC0014, UC0024
- EN: EN0008, EN0006, EN0007, EN0034
- FN: FN0018

## Open Items

- Whether the `use magic link` permission (`account.permissions.yml`) is consulted anywhere in the
  current codebase, or is dead declared-but-unused permission scaffolding.
- Whether any front-end caller actually relies on the v3.0/v3.1 profile endpoints' unscoped
  `user_id`/`slug` lookup for a legitimate cross-user read (e.g. viewing another public profile) —
  if so, the v3.2 tightening may have been a deliberate narrowing rather than an oversight; not
  evidenced either way.
- Whether the `backend_access_check` flag on v3.2 profile GET is actually invoked by any current
  front-end/back-office caller, and what capability it gates (no ACL doc exists yet to cross-reference).
- Whether POST endpoints in this module are expected to present the CSRF token issued by item 10/1/5
  back to the server, and whether that is enforced by framework middleware outside the resource code
  reviewed here.
- Route-priority resolution between the two same-path-family CSRF/token surfaces noted under
  Versioning/Hazards item 10.
- No `ACLxxxx` document exists yet for this module — authorization facts above are recorded directly
  from code/config pending a dedicated ACL pass; this API doc should be re-checked against that ACL
  doc once written.
