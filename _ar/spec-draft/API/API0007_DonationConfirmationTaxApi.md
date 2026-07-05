---
doc_id: API0007
title: Donation Confirmation Tax API
canonical_layer: API
spec_type: api-contract
status: draft
contract_type: rest-public
references:
  - UC0010
  - EN0014
  - EN0008
  - EN0009
  - EN0022
  - FN0013
  - BR-DonationConfirmationAndTax
---

# API0007 – Donation Confirmation Tax API

## Purpose

Let a Customer request an official CZ donation (tax) confirmation ("Potvrzení o daru") for a given
year. The contract computes the requester's paid-donation total for that year, persists a
DonationConfirmation (EN0014) snapshot, renders it to a PDF, and dispatches it by email — the API
realization of UC0010 (Issue Donation Confirmation (Tax)).

## Consumers

- **Customer** — anonymous or authenticated caller, via the public web/SPA channel (UC0010.3).

## Contract type

`rest-public` — a single business capability (request a tax confirmation) exposed as **two
concurrently-live versioned REST endpoints**. Both versions currently accept requests; there is no
routing indirection or content negotiation between them, and no evidence that the older version has
been retired or redirected. This document folds both into one contract, noting the version delta.

| Version | Path | Status | Source |
|---|---|---|---|
| v3.1 | `POST /api/3.1/donation_confirmation` | Confirmed — live | `donation_confirmation_resource_v31` plugin |
| v3.2 | `POST /api/3.2/donation_confirmation` | Confirmed — live, current | `donation_confirmation_resource_v32` plugin |

No v3.3 variant of this resource exists in the current source (unlike some sibling REST resources in
this module family that do have a v3.3). Treat v3.2 as the current version for new integration work;
v3.1 remains reachable and is not marked deprecated anywhere in configuration.

## Authorization

- **Mechanism:** Drupal core REST, cookie-based authentication (`authentication: [cookie]` in both
  resource configs). No token/API-key authentication is configured for this resource.
- **Method:** `POST` only, `json` format only, on both versions (`configuration.methods: [POST]`,
  `configuration.formats: [json]`).
- **Role grants (confirmed):** the permission `restful post donation_confirmation_resource_v31` and
  `restful post donation_confirmation_resource_v32` are both granted to **anonymous** and
  **authenticated** roles (`user.role.anonymous.yml`, `user.role.authenticated.yml`). No additional
  permission is required beyond these REST-method grants — there is no entity-level access check in
  either resource's `post()` method.
- **Session is optional, not required:** v3.1 always resolves the target user from request payload
  fields (`user_id` UUID or `email`), regardless of whether a session exists. v3.2 prefers the
  current authenticated session (`$this->currentUser->isAuthenticated()`) and falls back to the
  payload `email` only when no session is authenticated.
- **Hazard — anonymous, unauthenticated issuance for arbitrary donors (Confirmed):** because the
  `restful post` permission is granted to the anonymous role and neither version performs any
  ownership/ACL check tying the resolved user to the caller, any unauthenticated caller who supplies
  a valid donor `email` (or, on v3.1, a donor UUID) can trigger issuance of that donor's tax
  confirmation — including a PDF containing the donor's name, address, and Czech birth/personal ID
  number (`rodne_cislo`), emailed to whatever `email` value was submitted in the request (not
  necessarily the account's registered mail). This is a current-state data-disclosure and
  email-relay hazard, not a hypothetical one — it follows directly from the permission grant and the
  absence of an owner check in `post()`.
- **No CSRF-token requirement is configured** beyond Drupal core's own default cookie-auth CSRF
  protection for REST (`X-CSRF-Token` header sourced from `/session/token`); no module-specific
  override or bypass was found in this module's config. Not flagged as a hazard beyond standard
  platform behavior.
- **No rate limiting or throttling** is present in either resource class or its config — repeated
  calls are unbounded (see Side Effects / AF3 in UC0010).

## Request

### Inputs — v3.1 (`POST /api/3.1/donation_confirmation`)

| Field | Meaning | Required | Notes |
|---|---|---:|---|
| `user_id` | Donor's user UUID | no | Used to resolve the target user if present; takes precedence over `email`. Source: `DonationConfirmationResource::post()` (v3.1). |
| `email` | Donor's/requester's email address | conditionally | Required if `user_id` is absent; used to resolve the target user by matching the account's `mail` property. Returns `missing_email_or_user_id` if both `user_id` and `email` are empty. |
| `campaign_id` | Campaign (EN0004) to scope the donation total to | conditionally | Required if `confirmation_year` is absent (see BR-DonationConfirmationAndTax). |
| `confirmation_year` | Tax year to confirm donations for | conditionally | Required if `campaign_id` is absent. Only 4-digit numeric years are honored for date-range scoping; other values are silently ignored by the total computation. |
| `name` | Requester/donor display name | no | Falls back to the resolved user's full name when absent; truncated to 50 chars on the persisted snapshot (EN0014). |
| `address` | Requester/donor address | no | Falls back to the resolved user's address; truncated to 200 chars (v3.1) on the persisted snapshot. |
| `rodne_cislo` | Czech birth/personal identification number | no | Falls back to the resolved user's stored value; truncated to 20 chars. |
| `agreement_truthfulness` | GDPR/accuracy consent flag | no | Persisted as-is on the snapshot (EN0014); no server-side validation of truthiness observed. |
| `agreement_personal_data` | GDPR personal-data consent flag | no | Persisted as-is on the snapshot (EN0014); no server-side validation observed. |

### Inputs — v3.2 (`POST /api/3.2/donation_confirmation`)

Same fields as v3.1 **except**:

| Field | Meaning | Required | Notes |
|---|---|---:|---|
| `user_id` | — | — | **Not read by v3.2.** The v3.2 resource resolves the user only from the authenticated session or from `email`; a `user_id`/UUID field is not consulted (`getUser()` in v3.2). |
| `email` | Donor's/requester's email address | conditionally | Used only as a fallback when no session is authenticated. When a session **is** authenticated, `email` is ignored for user-resolution purposes but still accepted/stored as the confirmation snapshot's contact email field. |
| `address` | — | no | Truncated to 200 chars, same as v3.1 (both source files use the same 200-char limit on this field despite the field also being modeled as max 250 at the entity level — see EN0014 Open Items for the discrepancy; not reconciled here). |
| (all other fields) | — | — | Same as v3.1: `campaign_id`, `confirmation_year`, `name`, `rodne_cislo`, `agreement_truthfulness`, `agreement_personal_data` behave identically. |

Cross-version note: v3.1 exposes an explicit user-lookup-by-UUID path that v3.2 removed in favor of
session-based resolution with an email fallback. This is the primary behavioral delta between the
two live versions. Confirmed from source; not evidenced in any changelog.

## Response

### Success

| Field | Meaning | Notes |
|---|---|---|
| `status` | Literal `"success"` | HTTP 200. No confirmation identifier, document URL, or reference number is returned in the response body — the caller receives no handle to the created DonationConfirmation (EN0014) record or to the dispatched email. |

### Failure Outcomes

| Outcome | Meaning | Retryable | Notes |
|---|---|---:|---|
| `missing_email_or_user_id` | Neither a resolvable user identifier (`user_id`/UUID) nor `email` was supplied | yes | HTTP 401 (used as a generic-error status, not a true authorization failure). **v3.1 only** — v3.2 does not perform this specific check; it proceeds toward `user_not_found` instead when no session/email resolves. |
| `missing_campaign_or_year` | Neither `campaign_id` nor `confirmation_year` was supplied | yes | HTTP 401 (same non-standard status-code reuse). Present in both versions. |
| `user_not_found` | No user matches the supplied `user_id`/UUID (v3.1) or `email` (both versions), and no session is authenticated (v3.2) | yes | HTTP 404. |
| `no_transactions` | Computed paid-donation total for the resolved user/year(/campaign) is zero | yes | HTTP 400. Confirmation is intentionally NOT issued in this case — matches UC0010 AF1. No DonationConfirmation (EN0014) record and no email are created. |

No outcome is returned for a rendering or email-dispatch failure occurring after the
DonationConfirmation (EN0014) record has already been persisted — the endpoint has already responded
`{"status":"success"}` (200) by the time `sendEmail()` runs synchronously inside the same request; if
PDF rendering or the mail-service call throws, the caller-visible outcome is unspecified here and not
covered by this document (see UC0010 AF2 — partial, silently incomplete outcome).

## Side Effects

- Creates a DonationConfirmation (EN0014) immutable snapshot record (name, email, address,
  `rodne_cislo`, computed `donation_total`, `donation_in_words`, `confirmation_year`, `campaign`,
  consent flags, plus system-captured `ip_address`, `user_agent`, `number_of_requests`) whenever the
  computed total is greater than zero. See EN0014 for the full attribute contract — not restated here.
- Renders the snapshot to a CZ tax-confirmation PDF and dispatches it by email through the
  transactional-messaging capability (FN0019); the send is archived as an EmailArchive (EN0022)
  record regardless of transport outcome. See UC0010 and MSG0028 for the messaging contract — not
  restated here.
- No Transaction (EN0009) record is modified; Transactions are a read-only input to the total
  computation.
- **No idempotency safeguard:** repeated calls with the same donor/year each independently create a
  separate DonationConfirmation record and send a separate email (UC0010 AF3; BR-DonationConfirmationAndTax).
- CZ-only: this contract's underlying capability is evidenced for the CZ tenant; no equivalent
  confirmation record or document is produced for RO/MD (BR-DonationConfirmationAndTax).

## References

- UC: UC0010
- EN: EN0014, EN0008, EN0009, EN0022
- FN: FN0013
- BR: BR-DonationConfirmationAndTax

## Open Items

- No entity-level or ownership authorization check exists in either version's `post()` method beyond
  the anonymous/authenticated REST-method permission grant — flagged above as a hazard, not resolved
  here; whether this is intended self-service behavior or a gap is not evidenced in current sources.
- The success response carries no confirmation/document identifier; whether a caller is expected to
  poll or look up the issued document elsewhere (e.g. a Donor Zone download, per MSG0028) is outside
  this contract's evidenced request/response shape.
- Failure-status-code choices (`401` for what are really validation errors, not auth failures) are
  reproduced as observed; not corrected here, as this document describes current-state behavior only.
- Whether v3.1 is still actively used by any current client, or is legacy-but-reachable, is not
  evidenced by config alone (both are `status: true`/enabled) — flagged as Open Item rather than
  asserted either way.
- The `address` field's stored max-length differs between the entity-level model (EN0014: max 250)
  and this module's own truncation call (`mb_substr(..., 0, 200)` in both resource versions); recorded
  as an inherited discrepancy, not reconciled here.
