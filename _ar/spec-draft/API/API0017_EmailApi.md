---
doc_id: API0017
title: Email API
canonical_layer: API
spec_type: api-contract
status: draft
contract_type: rest-internal
references:
  - EN0007
  - EN0008
  - FN0018
  - ES0009
  - ACL0009
---

# API0017 – Email API

## Purpose

A single REST resource plugin exposed by the `email` custom module: **Validate Email Eligibility** —
checks whether a supplied email address is syntactically/domain-valid and, optionally, whether an
existing account at that address is eligible to proceed with a `donation` or `patron` (child-sponsor)
flow. This is a pre-flight check used ahead of donation/application intake, not an account-management
or messaging endpoint — despite the module name, it does not send, queue, or archive email messages
itself (see Open Items on `EN0022 EmailArchive`, which is out of scope for this contract).

The `email` module also defines a plain PHP service (`Drupal\email\EmailService`) and a `email_email`
entity type (label "Email", used to store outbound-mail archive records with a rendered `arguments`
field — evidenced by `email.module`'s `email_email_view()` hook). Neither the entity type's CRUD forms
(`EmailEntityForm`, `EmailEntitySettingsForm`, list builder) nor the entity access handler expose a
REST/HTTP contract — they are internal Drupal admin UI routes, out of scope for this API document (see
Open Items).

Evidence: `email/src/Plugin/rest/resource/EmailValidation.php`,
`config/rest.resource.email_validation.yml`, `email/src/EmailService.php`,
`patron_base/src/PatronBaseService.php` (`isEmailValid`), `account/src/AccountService.php`
(`loadByEmail`), `account/src/PatronUser.php` (`isWorkerAvailable`).
Classification: **Confirmed** (code + enabled config both present).

---

## Consumers

- Public storefront frontend (anonymous visitors) — reachable without authentication.
- Authenticated donor/user sessions — covered by the `authenticated` role's superset grant; no
  distinct consumer behaviour beyond the standing session.

---

## Endpoints

### 1. Validate Email Eligibility

- **Method / path:** `POST /api/email_validation`
  (`email_validation` plugin; `rest.resource.email_validation.yml` → `status: true`)
- **Format:** `json` only.

---

## Versioning Notes

This module defines only one REST resource plugin (`email_validation`), with only one version in the
codebase and in config — there is **no v3.1, v3.2, or v3.3 REST plugin or config entry for `email`**.
The task framing mentioning fold-in of v3.1/v3.2/v3.3 variants does not apply to this module; recorded
as an evidence gap rather than invented. (Version-suffixed resource IDs such as `_v32` seen elsewhere
in `config/rest.resource.*.yml` belong to other modules — e.g. `account`, `application`, `campaigns` —
not to `email`.) The current, and only, version is the one documented above.

---

## Authorization

Cross-checked against `config/user.role.anonymous.yml` and `config/user.role.authenticated.yml`
(role-based REST permissions, `restful <method> <plugin_id>`) and the REST resource
`configuration.authentication: [cookie]` setting. There is no `_permission`/`_access` route
requirement on this resource — it is a REST-plugin route (annotation-defined `uri_paths`), not a route
declared in a `*.routing.yml` file (the module ships no `email.routing.yml`).

| Endpoint | Anonymous | Authenticated | Notes |
|---|---|---|---|
| `POST /api/email_validation` (`email_validation`) | **Allowed** — `restful post email_validation` granted (`config/user.role.anonymous.yml`) | **Allowed** — `restful post email_validation` granted (`config/user.role.authenticated.yml`), superset of anonymous | Confirmed. Authentication mode is `cookie`, so an authenticated call requires an active Drupal session, not a bearer token; in practice the resource does not use `$this->currentUser` for anything other than being constructed (it is injected but never read in `post()`) — the eligibility check is keyed entirely on the request's `email`/`type` fields, not on session identity. |

No entity-level access control is consulted by this resource — it reads user accounts and a
plain-value `email_domain` cache table directly, bypassing any User/Account (EN0007/EN0008) entity
access layer.

---

## Request

### Validate Email Eligibility — Inputs

| Field | Meaning | Required | Notes |
|---|---|---:|---|
| `email` | Candidate email address to validate | yes | Rejected (HTTP 401) if empty. Not otherwise type-checked before use. |
| `type` | Optional eligibility check to run in addition to plain validity: `donation` or `patron` | no | If present and not one of these two literal values, request is rejected (HTTP 404, `missing_type` — current-state quirk: wrong-value case reuses a "missing" error code, not corrected here). If omitted, only the plain email-validity check runs. |

---

## Response

### Validate Email Eligibility — Success

| Field | Meaning | Notes |
|---|---|---|
| `status` | Literal `"success"` | Returned only when `type` is **omitted** and the email passes validity checks. HTTP 200. |
| `eligible` | Boolean — whether the email/account may proceed with the requested `type` of flow | Returned only when `type` is **present** and the email passes validity checks. HTTP 200. See Side Effects for how eligibility is computed. |

No response field distinguishes "no account exists yet for this email" from "account exists and is
eligible" — both cases return `eligible: true` for the `type`-present path (see Side Effects).

### Failure Outcomes

| Outcome | Meaning | Retryable | Notes |
|---|---|---:|---|
| HTTP 401, `{"error":"invalid_email_address"}` | `email` is empty | yes, after correction | Note: HTTP 401 is used for a validation failure, not an authorization failure — current-state quirk, not corrected here (same pattern documented for the `feedback` module's contact form, API0008). |
| HTTP 401, `{"error":"invalid_email_address"}` | `email` fails the validity check (`patron_base.default::isEmailValid` — format + domain check, see Side Effects) | yes, after correction | Same response shape/code as the empty-email case; the two failure causes are not distinguishable from the response alone. |
| HTTP 404, `{"error":"missing_type"}` | `type` is present but not `donation` or `patron` | yes, after correction | Current-state quirk: the error code name (`missing_type`) does not match the actual failure (an invalid, non-missing value) — not corrected here. |

No explicit handling is evidenced for a domain-validation transport failure (WhoisXML API
unreachable/erroring) — see Hazards; the current code treats that failure mode as "valid" rather than
as an API-level error.

---

## Side Effects

- **Plain validity check** (`type` omitted or present): calls
  `patron_base.default::isEmailValid($email)`, which (a) runs PHP's built-in email-format filter, then
  (b) calls `email.validateDomain($email)` (`Drupal\email\EmailService`), which:
  - looks up the email's domain in a local `email_domain` cache table (custom SQL table, not a
    Drupal entity);
  - if a cached row exists and is less than 180 days old, returns the cached `is_valid` flag with **no
    outbound call**;
  - otherwise (no cached row, or cache older than 180 days) calls out to the WhoisXML API (ES0009,
    "domain-availability" endpoint) to determine domain existence/availability, then writes/updates the
    cache row with the result and a fresh timestamp.
  - This is a distinct call site from the WhoisXML integration already documented against
    FN0019/UC0012 (transactional-messaging domain-check) — this endpoint reaches WhoisXML API via its
    own path (`email_validation` → `patron_base.isEmailValid` → `email.validateDomain` →
    `EmailService::domainExists`), not via the messaging dispatch flow. Recorded here as an additional,
    currently-undocumented call site onto the same external system (ES0009); not itself a new ES
    boundary.
- **Eligibility check** (`type` present only): if `patron_base.default::isEmailValid` passes, calls
  `account.default::loadByEmail($email)` (`Drupal\account\AccountService`) to look up an existing User
  (EN0008) by exact `mail` match.
  - If no such User exists, responds `eligible: true` unconditionally (an email with no account is
    always reported eligible, regardless of `type`).
  - If a User exists and `type === 'donation'`: eligible iff the user does **not** hold the
    `organisation_worker` role (`!$user->hasRole('organisation_worker')`).
  - If a User exists and `type === 'patron'`: eligible iff `$user->isWorkerAvailable()` — a boolean
    entity field (`worker_available`) on the User (EN0008/`PatronUser`), unrelated by name to the
    `organisation_worker` role check used for the `donation` type.
- **Cache write**: the `email_domain` table row for the checked domain is inserted (first sight) or
  updated (cache expiry) as a side effect of the validity check above — a persistent state change
  triggered by an otherwise read-oriented endpoint.
- No User, Contact, or Application entity is created, modified, or deleted by this endpoint. No
  message/email is sent by this endpoint (its own name notwithstanding) — it only validates and
  reports eligibility.

---

## Hazards (current-state)

- **Hardcoded external API key:** `EmailService::domainExists()` embeds a literal WhoisXML API key
  directly in the request URL string at the source-code level (`web/modules/custom/email/src/EmailService.php`).
  This is a real secret checked into the module source, not a redacted placeholder in this document —
  it is reachable from this public, anonymous-callable endpoint on every uncached domain lookup.
  **Confirmed** by direct inspection; the key value itself is not reproduced in this document per
  write-scope hygiene, but its presence and hardcoding are the hazard.
- **Fail-open domain validation:** `domainExists()` returns `true` (domain treated as
  valid/existing) on every non-happy-path branch it can reach — HTTP 403 from WhoisXML, a JSON body
  with an `ErrorMessage`, an explicit `AVAILABLE` (i.e., *not registered*) result being folded into the
  same `true` return as "exists", and any thrown exception (network timeout, malformed response,
  etc.). In practice this means a WhoisXML outage, rate-limit, or a genuinely non-existent domain can
  all silently pass domain validation as "valid" — the check degrades to a no-op rather than a hard
  failure. **Confirmed** by direct inspection of the method's control flow.
- **HTTP 401 reused for validation failures:** both the empty-email and invalid-email branches return
  HTTP 401 (Unauthorized) for what is a plain input-validation outcome, not an authentication/
  authorization failure — the same current-state quirk already recorded for the `feedback` module's
  contact-form endpoint (API0008). **Confirmed**, not corrected here.
- **Ambiguous "eligible" semantics for unknown emails:** the `type`-present path reports
  `eligible: true` for any email with no matching User, without distinguishing "this is a brand-new,
  genuinely eligible email" from "this email doesn't exist yet, eligibility is not actually known."
  Downstream callers cannot tell these apart from the response alone. **Confirmed** by direct
  inspection; not necessarily a defect for the endpoint's evidenced purpose (pre-flight gating of
  known-ineligible existing accounts), but a latent ambiguity if reused elsewhere.
- **Session/identity injected but unused:** `AccountProxyInterface $current_user` is constructor-
  injected into `EmailValidation` but never read inside `post()` — the endpoint's behavior is identical
  for anonymous and authenticated callers and does not attribute the check to the caller's own
  identity. Not a security hazard by itself (the endpoint performs no write against the caller's own
  record), but flagged as dead-weight coupling for the rebuild. **Confirmed** by direct inspection.

---

## References

- UC: none — no use case in the current draft set models this pre-flight validation check as an
  orchestrated flow step; it is anchored directly to FN0018 (Identity, Session & Access Control, whose
  Related Entities already cover User/EN0008 and Account/EN0007) and to ES0009 (the external system
  this endpoint calls into, alongside the already-documented FN0019/UC0012 call site).
- EN: EN0008 (User — `organisation_worker` role check, `worker_available` field), EN0007 (Account —
  referenced for completeness per FN0018's ownership of the identity capability; not itself read by
  this endpoint)
- FN: FN0018 (Identity, Session & Access Control — owns the User/role model this endpoint reads)
- ES: ES0009 (WhoisXML API — domain-validity lookup; this endpoint is a second, previously-
  undocumented call site onto the same external system already recorded against FN0019/UC0012)
- ACL: ACL0009 (Identity, Access & Public API — nearest access-control anchor for this
  anonymous/authenticated-reachable public REST surface; ACL0009's Matrix does not yet list
  `email_validation` by name — see Open Items)

---

## Open Items

- ACL0009's Matrix does not currently enumerate `POST /api/email_validation` — this contract records
  the actual role grants (anonymous + authenticated, both allowed) directly from
  `config/user.role.anonymous.yml` / `config/user.role.authenticated.yml`; a future ACL-layer refresh
  may want to add this row for completeness.
- The `email` module's `email_email` entity type (admin CRUD forms `EmailEntityForm`,
  `EmailEntitySettingsForm`, `EmailEntityDeleteForm`, list builder, access control handler,
  permissions `add/administer/delete/edit/view (un)published email entities`) is a back-office
  mail-archive record type, evidenced only through Drupal admin UI routes — no REST/HTTP contract is
  exposed for it. Out of scope for this API document; flagged so a future ARCH/UI-facing pass does not
  lose it. Its relationship to `EN0022 EmailArchive` (if any) is not established in this pass —
  recorded as `Uncertain`.
- The hardcoded WhoisXML API key is known from source but redacted from this document; if needed for
  implementation/remediation planning, retrieve directly from
  `email/src/EmailService.php::domainExists()`.
- Whether the two independent WhoisXML call sites (this endpoint's `email.validateDomain` path, and
  the FN0019/UC0012 transactional-messaging path already recorded on ES0009) share the same cache
  table or API quota, or are entirely independent code paths that happen to call the same external
  service, is not evidenced beyond both being traceable to the same `domain-availability.whoisxmlapi.com`
  endpoint family — recorded as `Uncertain`, not resolved here.
- Whether the `email_domain` cache table's 180-day expiry and fail-open behavior were deliberate
  design choices or accidental (e.g., a debug/dev-convenience default left in place) is not evidenced —
  recorded as `Uncertain`.
