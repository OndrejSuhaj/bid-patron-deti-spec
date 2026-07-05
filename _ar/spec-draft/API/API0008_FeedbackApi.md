---
doc_id: API0008
title: Feedback API
canonical_layer: API
spec_type: api-contract
status: draft
contract_type: rest-public
references:
  - EN0021
  - EN0004
  - ES0006
  - ES0015
  - ACL0009
---

# API0008 – Feedback API

## Purpose

Two independent, publicly-reachable REST resources exposed by the `feedback` custom module, grouped
into one contract because they share the same module, versioning scheme (`/api/3.0/...` and
`/api/3.2/...`), and REST-plugin implementation pattern:

1. **Get Campaign Feedback** — read-only lookup of a single Feedback (EN0021) record's public
   display fields for a given Campaign/Story (EN0004), used to render an "intercept" teaser (title +
   excerpt + featured image) on the storefront.
2. **Submit Contact/Lead Enquiry** — a public contact-form submission ("Do you know children who
   need help?" — CTA copy evidenced in code) that emails an operator mailbox and best-effort pings an
   internal Slack channel; it is a marketing/lead-capture enquiry, not a Feedback (EN0021) record and
   not a Lead entity write.

Both resources are implemented purely as REST resource plugins; the module's `feedback.routing.yml`
only defines internal HTML admin/back-office form routes (`campaign_feedback_form`,
`fundraiser_feedback_form`, `application.feedback.fundraiser`) which are **not** part of this API
contract — see Open Items.

Evidence: `feedback/src/Plugin/rest/resource/{v30,v32}/FeedbackResource.php`,
`feedback/src/Plugin/rest/resource/{v30,v32}/ContactFormResource.php`,
`config/rest.resource.feedback_resource*.yml`, `config/rest.resource.contact_form_resource_*.yml`.
Classification: **Confirmed** (code + enabled config both present).

---

## Consumers

- Public storefront frontend (anonymous visitors) — both endpoints are reachable without
  authentication on their currently-enabled version.
- Authenticated donor/user sessions — additionally covered by the `authenticated` role's superset
  grant (see Authorization); no distinct consumer behaviour is evidenced beyond attaching the
  requester's identity to the contact-form side effects.

---

## Endpoints

### 1. Get Campaign Feedback

- **Method / path (current, enabled):** `GET /api/3.0/feedback/{campaign_id}`
  (`feedback_resource` plugin; `rest.resource.feedback_resource.yml` → `status: true`)
- **Method / path (v3.2 variant, present but disabled):** `GET /api/3.2/feedback/{campaign_id}`
  (`feedback_resource_v32` plugin; `rest.resource.feedback_resource_v32.yml` → `status: false`)
- **Format:** `json` only (both versions).

### 2. Submit Contact/Lead Enquiry

- **Method / path (v3.0):** `POST /api/3.0/cta/email` (`contact_form_resource_30` plugin;
  `rest.resource.contact_form_resource_30.yml` → `status: true`)
- **Method / path (v3.2):** `POST /api/3.2/cta/email` (`contact_form_resource_32` plugin;
  `rest.resource.contact_form_resource_32.yml` → `status: true`)
- **Format:** `json` only (both versions).
- Both versions are simultaneously enabled in REST config; they differ only in how the acting user is
  resolved (see Versioning Notes) and are reachable by different roles (see Authorization). Neither
  supersedes the other in config — both are live.

---

## Authorization

Cross-checked against `config/user.role.anonymous.yml` and `config/user.role.authenticated.yml`
(role-based REST permissions, `restful <method> <plugin_id>`) and the REST resource `configuration.authentication: [cookie]` setting. There is no `_permission`/`_access` route requirement on these
resources (they are REST-plugin routes, not routes declared in `feedback.routing.yml`).

| Endpoint | Anonymous | Authenticated | Notes |
|---|---|---|---|
| `GET /api/3.0/feedback/{campaign_id}` (`feedback_resource`) | **Allowed** — `restful get feedback_resource` granted | Allowed (superset of anonymous grants) | Confirmed |
| `GET /api/3.2/feedback/{campaign_id}` (`feedback_resource_v32`) | Not granted to any role | Not granted to any role | Config `status: false` (resource disabled) **and** no role grants `restful get feedback_resource_v32` — unreachable regardless. Confirmed absent, not Open Item. |
| `POST /api/3.0/cta/email` (`contact_form_resource_30`) | **Allowed** — `restful post contact_form_resource_30` granted | Allowed (superset) | Confirmed |
| `POST /api/3.2/cta/email` (`contact_form_resource_32`) | **Not granted** to anonymous | **Allowed** — `restful post contact_form_resource_32` granted only on `authenticated` (per ACL0009) | Confirmed. Authentication mode is `cookie`, so an authenticated call requires an active Drupal session, not a bearer token. |

No entity-level access control (e.g. `FeedbackEntityAccessControlHandler`) is consulted by either
resource — both read/write raw data directly (`\Drupal::database()->query()` for the GET; direct
mail/Slack dispatch for the POST), bypassing the Feedback entity access layer that governs the
back-office CRUD forms (out of scope for this contract).

---

## Request

### Get Campaign Feedback — Inputs

| Field | Meaning | Required | Notes |
|---|---|---:|---|
| `campaign_id` (path) | Numeric identifier of the Campaign/Story (EN0004) to fetch feedback for | yes | Matched against the `campaign` column of the underlying `feedback` table by raw SQL; no type validation beyond what routing performs. |

No request body.

### Submit Contact/Lead Enquiry — Inputs

| Field | Meaning | Required | Notes |
|---|---|---:|---|
| `email` | Enquirer's reply-to email address | yes | Validated via `patron_base.default` email-format + domain check (`isEmailValid`); request rejected if empty or invalid. |
| `message` | Free-text enquiry body | yes | Rejected if empty. No length limit evidenced. |
| `user_id` | UUID of an already-known Drupal user (v3.0 only) | no | v3.0 accepts this in the payload and loads the user by UUID to attribute the enquiry; v3.2 ignores this field entirely and instead uses the REST-session's own authenticated user (see Versioning Notes). |

---

## Response

### Get Campaign Feedback — Success

| Field | Meaning | Notes |
|---|---|---|
| `intercept_title` | Feedback record's `name` (label) field (EN0021) | HTTP 200 |
| `intercept` | First sentence of the feedback `body`, HTML-stripped | Body text split on first `.`; `&nbsp;` normalized to space. |
| `content` | Remainder of the feedback `body` after the first sentence | Same stripping as above. |
| `featured_image` | URL of the first `<img>` found in the feedback `body` HTML, rewritten to an absolute URL using the `backend_url` site setting | Best-effort regex extraction, not a structured media reference. |

No response body on the "no feedback found" path (see Failure Outcomes).

### Submit Contact/Lead Enquiry — Success

| Field | Meaning | Notes |
|---|---|---|
| `status` | Literal `"success"` | HTTP 200. No enquiry/ticket identifier is returned. |

### Failure Outcomes

| Outcome | Meaning | Retryable | Notes |
|---|---|---:|---|
| Get Campaign Feedback: HTTP 404, empty body `[]` | No Feedback (EN0021) record exists for the given `campaign_id` with both `name` and `body` populated | yes (once a Feedback record exists) | Also returned if the campaign has multiple feedback rows — only one (arbitrary, unordered `LIMIT 1`) is ever considered; no "which feedback" selection logic is evidenced. |
| Submit Contact/Lead Enquiry: HTTP 401, `{"status":"failed","error":"missing_email_or_message"}` | `email` or `message` missing/empty | yes, after correction | Note: HTTP 401 is used for a validation failure, not an authorization failure — current-state quirk, not corrected here. |
| Submit Contact/Lead Enquiry: HTTP 401, `{"status":"failed","error":"Email validation error"}` | `email` fails format or domain validation | yes, after correction | Same HTTP-401-for-validation quirk as above. |

No explicit handling is evidenced for a mail-transport failure (`patron_base.smartmailing` /
`APIMailingService::handleMail`) — the resource always returns success once validation passes,
regardless of whether the outbound send/queue succeeds. **Partial** — not further evidenced in this
module.

---

## Side Effects

### Get Campaign Feedback

- Read-only. No side effects.

### Submit Contact/Lead Enquiry

- Sends an email via `patron_base.smartmailing` (`APIMailingService::handleMail`, template
  `general_template`) to a fixed operator mailbox address hardcoded in the resource class (redacted
  here — see hazard below), carrying the enquirer's `email` and `message`. Routed through the
  platform's outbound mail path — see ES0006 (Mautic) for the transactional-mail boundary; this
  specific message is not one of the donor-facing MSG-layer contracts (it is an internal
  lead/contact notification, out of MSG scope).
- In non-production environments (`Settings::get('environment') !== 'production'`), the email subject
  is prefixed with `[TEST] `.
- If the enquiry is attributable to a known user (v3.0: resolved from the `user_id` UUID in the
  payload; v3.2: resolved from the authenticated session), the mail body is appended with that user's
  name and email, and a call is made to `logger.slack` (`SlackLogger::sendMessageToZoneChannel`) to
  post a notification to an internal Slack "zone" channel — see hazard below on this call's actual
  effect.
- No Lead, Application, or Feedback (EN0021) entity is created by this endpoint — despite living in
  the `feedback` module, this is a standalone contact-form mailer, not a write path for any canonical
  entity documented in EN0021.

---

## Versioning Notes

Two version families coexist in the codebase and in enabled config; there is no v3.1 or v3.3 REST
plugin or config entry for this module — only v3.0 and v3.2 exist for `feedback` (task framing
mentioning v3.1/v3.3 does not apply to this module; recorded as an evidence gap rather than invented).

- **Get Campaign Feedback:** v3.0 (`/api/3.0/feedback/{campaign_id}`) and v3.2
  (`/api/3.2/feedback/{campaign_id}`) are functionally identical (same SQL query, same response
  shape); the only code difference is a defensive cast (`(string)$img[2][1]`) in v3.2 and the absence
  of a `?? null` fallback on the image-match array. **v3.0 is the current live version** (config
  `status: true`); **v3.2 is present but disabled** (`status: false`) and additionally has no role
  grant — effectively dead code at the config layer, not merely unused.
- **Submit Contact/Lead Enquiry:** v3.0 and v3.2 are both enabled, but diverge in one behaviourally
  significant way: v3.0 resolves the "known user" for attribution from a `user_id` field supplied in
  the untrusted POST payload (self-declared identity — the caller can name any user UUID); v3.2
  instead ignores the payload's `user_id` and uses the REST session's own `current_user`, which is
  more correct but is only reachable by authenticated callers (anonymous is not granted
  `contact_form_resource_32`). Both versions are otherwise identical (same validation, same mail
  template, same Slack call).

---

## Hazards (current-state)

- **Self-declared identity on v3.0 contact form:** `ContactFormResource` (v3.0) trusts a client-supplied
  `user_id` UUID to attribute the enquiry to an existing Drupal user and to append that user's real
  name/email into the outbound mail body — with no verification that the caller is actually that user
  (the endpoint is anonymous-reachable). This allows enquiry submissions to be falsely attributed to
  arbitrary known users. **Confirmed** (source:
  `feedback/src/Plugin/rest/resource/v30/ContactFormResource.php:118-123`).
- **Hardcoded recipient address:** both ContactFormResource versions hardcode the destination mailbox
  in `handleMail()`'s first argument at the source level (not a redacted evidence artifact — a literal
  string in the class); operationally this means the enquiry destination cannot be changed without a
  code deploy. **Confirmed**, address redacted from this document per write-scope hygiene.
- **No-op Slack notification:** the `logger.slack` service's `sendMessageToZoneChannel()` method
  (`slack_integration/src/SlackLogger.php:85-86`) has an empty method body in the current codebase —
  the call made by both ContactFormResource versions compiles and executes but performs no actual
  Slack post. The code path documented above as a "side effect" is therefore currently inert;
  recorded as a hazard because it silently fails to notify operators of contact-form submissions
  despite the code appearing to do so. **Confirmed** by direct inspection of the method body.
- **Validation failures returned as HTTP 401:** both ContactFormResource versions return HTTP 401
  (Unauthorized) for plain input-validation failures (missing/invalid email or message), which is
  semantically an authentication status code being reused for a business-validation outcome.
  **Confirmed**, current-state quirk only — not corrected here per reconstruction discipline.
- **Raw SQL read bypassing entity access:** `FeedbackResource::get()` (both versions) queries the
  `feedback` base table directly via `\Drupal::database()->query()` rather than loading the Feedback
  entity through its access-controlled storage/`FeedbackEntityAccessControlHandler` — publish state
  (`status` boolean on EN0021) is not filtered by this query, so an unpublished Feedback record's
  `name`/`body` could be exposed publicly if the row happens to match `LIMIT 1` for that
  `campaign_id`. **Partial** — the query does not filter on `status`/published state, but no evidence
  was found confirming an unpublished record has ever actually surfaced this way in production;
  flagged as a latent gap rather than an observed incident.
- **v3.2 Feedback GET disabled + double-unreachable:** unlike a typical "old version kept for
  compatibility" pattern, `feedback_resource_v32` is both config-disabled and role-ungranted — two
  independent reasons it cannot be called. Not a hazard in the security sense, but a maintenance trap:
  a future config change re-enabling `status: true` would still not expose it without also adding a
  role grant, and vice versa. **Confirmed**.

---

## References

- UC: none — no use case in the current draft set models fundraiser/back-office Feedback (EN0021)
  authoring or public feedback consumption as an orchestrated flow (see EN0021 Open Question 4); this
  contract is anchored directly to EN0021 (entity) and FN0006 (Campaign/Story Lifecycle capability,
  which lists Feedback as part of the public Story lifecycle) rather than to a UC.
- EN: EN0021 (Feedback), EN0004 (Campaign/Story)
- FN: FN0006 (Campaign/Story Lifecycle — lists Feedback as part of the maintained public story
  surface)
- ES: ES0006 (Mautic — outbound mail boundary for the contact enquiry), ES0015 (Slack — ops-alert /
  business-ping boundary; the contact-form Slack call is a third, currently-inert, call site not yet
  reflected in ES0015's documented modes)
- ACL: ACL0009 (Identity Access and Public API — documents the `authenticated` role's
  `contact_form_resource_32` grant referenced above)

---

## Open Items

- The module's HTML routes (`feedback.campaign_feedback_form`, `feedback.fundraiser_feedback_form`,
  `application.feedback.fundraiser` in `feedback.routing.yml`) are back-office/fundraiser-zone forms
  for authoring Feedback (EN0021), gated by `_permission: 'add feedback entities'` /
  `'add leads'` / `_application_role: fundraiser`. These are Drupal form routes, not REST contracts,
  so they are out of scope for this API document — flagged here so a future UI/ARCH-facing pass does
  not lose them. Not modeled as an endpoint above.
- No UC currently models how a Feedback (EN0021) record actually gets created/published such that
  `GET /api/3.0/feedback/{campaign_id}` has data to return — this contract only covers the read/write
  surface of the two REST resources themselves, not the authoring flow. Cross-reference EN0021 Open
  Question 4.
- The hardcoded recipient mailbox address for the contact-form enquiry is known from source but
  redacted from this document; if needed for implementation planning, retrieve directly from
  `feedback/src/Plugin/rest/resource/{v30,v32}/ContactFormResource.php`.
- Whether `feedback_resource_v32`'s disablement was deliberate (superseded/abandoned) or accidental
  (forgotten activation) is not evidenced — recorded as `Uncertain`, not resolved here.
