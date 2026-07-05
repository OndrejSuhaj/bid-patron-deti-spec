---
doc_id: API0014
title: Facebook Lead Webhook
canonical_layer: API
spec_type: api-contract
status: draft
contract_type: webhook
references:
  - UC0013
  - EN0006
  - EN0009
  - FN0016
  - ES0007
---

# API0014 – Facebook Lead Webhook

## Purpose

Inbound webhook surface exposed by the `facebook_leads` module for Meta/Facebook's Lead Ads
integration: a subscription-verification handshake (confirmed working) and an intended lead-delivery
intake path (confirmed not implemented). A second, unrelated endpoint in the same module accepts
outbound-style client-triggered GET calls that relay browser-side conversion events to Facebook's
Conversions API (CAPI) — folded into this document because it is the same module/ground truth, but
it is a distinct contract shape (utility relay, not a webhook receiver) and is called out separately
below.

Ground truth: REST resource plugins under
`web/modules/custom/facebook_leads/src/Plugin/rest/resource/` —
`FacebookLeadWebhookResource.php` (webhook, `facebook_lead_webhook_resource`) and
`FacebookResource.php` (CAPI relay, `facebook_leads_facebook`) — cross-checked against
`config/rest.resource.facebook_lead_webhook_resource.yml`,
`config/rest.resource.facebook_leads_facebook.yml`, and
`config/user.role.{anonymous,authenticated}.yml`. No `facebook_leads.routing.yml` exists; routes are
defined entirely by the `@RestResource` `uri_paths` annotations on the two plugin classes (Drupal
core `rest` module mechanism — not documented further here per API restrictions).

## Consumers

- Integration(Facebook) — Meta/Facebook Lead Ads subscription-verification and (intended)
  lead-delivery caller, for `POST/GET /api/2.2/facebook/lead`.
- Patronus frontend (browser-side script) — caller of `GET /api/3.2/facebook`, which relays
  page-level conversion events server-side to Facebook CAPI on the visitor's behalf.

## Contract type

`webhook` (primary surface: `FacebookLeadWebhookResource`, `/api/2.2/facebook/lead`), with one
folded `utility`-shaped relay endpoint (`FacebookResource`, `/api/3.2/facebook`) documented in the
same file because it shares the module and ground-truth scope. No `v3.1`/`v3.3` variant of either
endpoint exists in the source (Confirmed — searched `config/` and `web/modules/custom/facebook_leads/`
for any additional version path or role-permission string; only `2.2` and `3.2` paths are present).
The "current version" of each endpoint is the only version that exists — there is no superseded
variant to fold.

## Authorization

Confirmed, per `config/rest.resource.facebook_lead_webhook_resource.yml` and
`config/rest.resource.facebook_leads_facebook.yml` (both `authentication: cookie`), cross-checked
against `config/user.role.anonymous.yml` and `config/user.role.authenticated.yml`:

| Endpoint | Drupal permission | Granted to |
|---|---|---|
| `GET /api/2.2/facebook/lead` | `restful get facebook_lead_webhook_resource` | anonymous, authenticated |
| `POST /api/2.2/facebook/lead` | `restful post facebook_lead_webhook_resource` | anonymous, authenticated |
| `GET /api/3.2/facebook` | `restful get facebook_leads_facebook` | anonymous, authenticated |
| `POST /api/3.2/facebook` | `restful post facebook_leads_facebook` | anonymous, authenticated (endpoint is a no-op stub, see Endpoints) |

Both resources are granted to the `anonymous` role for every method they expose (Confirmed —
`config/user.role.anonymous.yml` lines 41–42, 114–115, 157–158). There is no session, API key,
HMAC signature, or Facebook-specific request-signing check (e.g. no `X-Hub-Signature`/
`X-Hub-Signature-256` verification) on either endpoint — the only "authentication" performed by
`FacebookLeadWebhookResource::get()` is a plain string comparison of a query parameter against a
hardcoded token embedded in the module source (see Hazards). `FacebookLeadWebhookResource::post()`
performs no authentication check of any kind before responding.

## Endpoints

### 1. `GET /api/2.2/facebook/lead` — Lead Ads webhook subscription verification (as observed)

Plugin: `facebook_lead_webhook_resource` (`Drupal\facebook_leads\Plugin\rest\resource\FacebookLeadWebhookResource::get()`).
Current and only version. Implements the Meta webhook subscription-verification handshake
(`UC0013` AF1).

#### Request

| Field | Meaning | Required | Notes |
|---|---|---|---|
| `hub_verify_token` (query param) | Verification token supplied by the calling party | yes | Compared with `===` against a literal token string hardcoded in the resource class. |
| `hub_challenge` (query param) | Challenge value to be echoed back on successful verification | yes | Passed through unmodified. |

#### Response — Success

| Field | Meaning | Notes |
|---|---|---|
| *(raw body, not JSON)* | The literal value of `hub_challenge`, echoed back and the request terminated via `die()` | Confirmed from code: this bypasses the normal `ResourceResponse`/serializer path entirely — the success response is not a JSON envelope like the rest of this contract, it is the raw challenge string with whatever HTTP status `die()` leaves in place (Open Item — exact status code not evidenced from static code alone). |

#### Failure Outcomes

| Outcome | Meaning | Retryable | Notes |
|---|---|---|---|
| `{"status": "failed", "error": "token is invalid"}` (HTTP 200) | Supplied `hub_verify_token` does not match the hardcoded value | yes, with correct token | Failure is signalled in-band with HTTP 200, not a 4xx status. |

### 2. `POST /api/2.2/facebook/lead` — Lead Ads lead-delivery intake — Planned / Not Implemented

Plugin: `facebook_lead_webhook_resource` (`FacebookLeadWebhookResource::post()`). Current and only
version. This is the endpoint Meta would call to deliver a captured Lead Ads submission
(`UC0013` AF2).

**Status: Planned / Not Implemented.** Confirmed from code:

- The method signature accepts a `$data` parameter (the decoded request body) but the body
  immediately logs an undefined variable `$request_data` (never assigned anywhere in the class) —
  this is confirmed to raise a PHP notice/warning at runtime, not a working log statement.
- No field of the inbound payload is read, validated, or persisted.
- No Contact (`EN0006`) or any Application-side entity is created.
- The method unconditionally returns `{"status": "failed", "error": "token is invalid"}` with
  HTTP 200 regardless of the request content — the same body shape as the GET handshake's failure
  path, even though no token is involved in a POST lead-delivery call at all.

#### Request

Not documented as a real contract — no field is read by the implementation. Whatever shape Meta's
Lead Ads webhook payload has (per Meta's own webhook format) arrives here unread. Not prescribing
fields here per the "do not invent" rule; this is intentionally left without a request table.

#### Response

| Field | Meaning | Notes |
|---|---|---|
| `status` | Always `"failed"` | Confirmed: unconditional, independent of input. |
| `error` | Always `"token is invalid"` | Confirmed: same literal string as the GET handshake's failure body; not contextually accurate for a POST call. |

HTTP status is always 200 — Facebook receives a success-shaped transport response while the
delivered lead is silently discarded (see `UC0013` AF2, `ES0007` Constraints for the business-level
framing of this gap; not restated further here).

### 3. `GET /api/3.2/facebook` — Client-triggered Conversions API (CAPI) event relay

Plugin: `facebook_leads_facebook` (`Drupal\facebook_leads\Plugin\rest\resource\FacebookResource::get()`).
Current and only version. Not a webhook — this is a server-side relay endpoint called by the
Patronus frontend to forward a browser-observed event to Facebook's CAPI (`graph.facebook.com`)
with server-side-hashed user-matching data (`UC0013` outbound sub-flow; `ES0007`). Documented here
because it is defined in the same module/class family as the webhook, not because it shares the
webhook's contract type.

#### Request

| Field | Meaning | Required | Notes |
|---|---|---|---|
| `event_name` (query param) | Facebook CAPI event name | yes | Only `Lead`, `Purchase`, `CompleteRegistration` receive `custom_data`; any other value is still relayed but with an empty `custom_data`. |
| `params` (query param) | JSON-encoded object of event details | yes | Confirmed code-level workaround: if the raw string does not contain a closing `"}`, the resource appends `"}` before decoding — evidence of an observed truncation issue in the incoming data, not a documented contract feature. Decode failure (empty result) returns a 400. |
| `params.event_id` | Client-supplied event id, forwarded as CAPI `event_id` | conditionally required | Read from decoded `params`; no presence validation before use. |
| `params.url` | Page URL, forwarded as CAPI `event_source_url` | conditionally required | Same. |
| `params.email`, `params.first_name`, `params.last_name`, `params.phone` | Visitor-identifying fields | no | Each present field is lowercased and SHA-256-hashed before being placed in CAPI `user_data` (`em`/`fn`/`ln`/`ph`). |
| `params.country_code` | Visitor country code | no | Hashed into `user_data.country` if present; if absent, the server looks up the country from the caller's IP via an outbound call to `http://ip-api.com/json/{ip}` (Confirmed — a second, undocumented outbound integration, unauthenticated, plaintext HTTP; not modeled as its own ES document here — Open Item). |
| `params.content_category`, `params.currency` | Used only when `event_name = Lead` | no | Placed into `custom_data`. |
| `params.value`, `params.currency`, `params.content_ids` | Used only when `event_name = Purchase` | no | Placed into `custom_data` (`content_ids` reused verbatim as `contents`). |
| `params.content_name`, `params.page_title`, `params.currency`, `params.status` | Used only when `event_name = CompleteRegistration` | no | Placed into `custom_data`; `status` coerced to boolean. |

#### Response — Success

| Field | Meaning | Notes |
|---|---|---|
| `status` | `"success"` | Returned once the relay call to Facebook CAPI has been issued; the CAPI call's own HTTP result is not checked or reflected in this response (see Hazards). |

#### Failure Outcomes

| Outcome | Meaning | Retryable | Notes |
|---|---|---|---|
| `{"status": "error", "message": "Invalid input"}` (HTTP 400) | `event_name` or `params` query param missing | yes | |
| `{"status": "error", "message": "Invalid input"}` (HTTP 400) | `params` fails JSON decode (even after the closing-bracket workaround) | yes | |

### 4. `POST /api/3.2/facebook` — No-op stub

Plugin: `facebook_leads_facebook` (`FacebookResource::post()`). Confirmed no-op: the method ignores
its input entirely and always returns `{"status": "success"}` (HTTP 200) with no persistence, no
relay call, and no side effect of any kind. Recorded for completeness only — not a working command
contract.

## Side Effects

- **`GET /api/2.2/facebook/lead` (handshake success):** none — no entity read or written; the
  process terminates via `die()` after echoing the challenge.
- **`POST /api/2.2/facebook/lead`:** none. No Contact (`EN0006`), Application, or any domain entity
  is created or updated — this is the confirmed current-state gap tracked at `UC0013` AF2 (not
  restated here beyond this pointer).
- **`GET /api/3.2/facebook` (successful relay):** issues one outbound HTTP POST to
  `graph.facebook.com/v16.0/{pixel_id}/events` carrying the constructed CAPI event payload
  (`ES0007`); on `country_code` absence, additionally issues one outbound HTTP GET to
  `ip-api.com` for IP-to-country lookup. Neither outbound call's result is persisted in Patronus;
  no Patronus domain entity is created, updated, or read by this endpoint.
- **`POST /api/3.2/facebook`:** none (confirmed no-op).

## Hazards (current-state, documented)

- **Fully anonymous webhook surface with no signing/verification.** Both `facebook_lead_webhook_resource`
  and `facebook_leads_facebook` are granted to the `anonymous` role for every method they expose
  (`config/user.role.anonymous.yml`). Neither endpoint checks a Facebook request signature
  (Meta's Lead Ads/CAPI integrations conventionally support `X-Hub-Signature-256`); the webhook's
  only gate is the plain-string `hub_verify_token` compare on GET, and POST has no gate at all.
  Any party that discovers the URL can call these endpoints.
- **Hardcoded verify token embedded in source.** `FacebookLeadWebhookResource::get()` compares
  `hub_verify_token` against a literal string constant in the class file (value redacted from this
  document; present in plaintext in `FacebookLeadWebhookResource.php`). Rotating or scoping this
  token requires a code change; the token is visible to anyone with source access and is not
  environment-configured.
- **Lead-delivery intake is not implemented.** `POST /api/2.2/facebook/lead` unconditionally
  returns `{"status": "failed", "error": "token is invalid"}` with **HTTP 200**, so from Meta's
  perspective the call transport-succeeds while the delivered lead is silently discarded, and the
  error message is misleading (it names a token-validation failure that never occurred on a POST
  call). Confirmed current-state gap; see `UC0013` AF2 / `ES0007` for the business framing.
- **Undefined-variable reference on every POST call.** `post()` logs `json_encode($request_data)`
  where `$request_data` is never assigned in scope — this raises a PHP notice/warning on every
  invocation before the method returns its hardcoded failure body. Confirmed from code; runtime
  visibility of the resulting warning (error log vs. suppressed) is not evidenced (Open Item, per
  the static Runtime-truth-policy).
- **CAPI relay result is not checked.** `FacebookResource::sendData()` issues the outbound CAPI
  `curl` call with `CURLOPT_SSL_VERIFYHOST => false` and `CURLOPT_SSL_VERIFYPEER => false`
  (TLS verification disabled for the outbound call to `graph.facebook.com`) and discards the
  response/HTTP code (the one line that would log the response is commented out in source). The
  endpoint always answers `{"status": "success"}` to its caller regardless of whether the CAPI
  relay actually succeeded.
- **Access token and pixel id hardcoded in source.** `FacebookResource::sendData()` embeds a
  literal Facebook long-lived access token and pixel id as PHP string constants (values redacted
  from this document; present in plaintext in `FacebookResource.php`). Same rotation/exposure
  concern as the webhook's hardcoded verify token.
- **Unauthenticated, unencrypted third-party IP-lookup call.** When `params.country_code` is
  absent, the server makes a plaintext `http://` outbound request to `ip-api.com`, passing the
  caller-derived IP (itself taken from client-supplied, spoofable headers `HTTP_CLIENT_IP` /
  `HTTP_X_FORWARDED_FOR` before falling back to `REMOTE_ADDR`) with no error handling beyond a
  truthiness check. This is an additional, undocumented external dependency invoked synchronously
  inside the request path.

## References

- UC: UC0013 (Sync Marketing & Intake Leads) — owns the business-level framing of both the
  handshake (AF1) and the not-implemented intake path (AF2); not restated here.
- EN: EN0006 (Contact) — the entity the not-implemented intake path would have populated;
  EN0009 (Transaction) — subject of the outbound conversion signal this module's sibling endpoint
  relays (context only, not owned by this contract).
- FN: FN0016 (Conversion & Analytics Relay) — owning capability for both the webhook and the CAPI
  relay endpoint.
- ES: ES0007 (Facebook) — external-system boundary description for the Lead Ads webhook, Pixel,
  and Conversions API surfaces; not restated here.

## Open Items

- Exact HTTP status code returned by the `die($challenge)` call on successful subscription
  verification is not evidenced from static code alone (PHP `die()` with no prior header call
  defaults to whatever status the response already carries — likely 200, but not confirmed
  against a running instance per the static Runtime-truth-policy).
- Whether the PHP notice/warning raised by the undefined `$request_data` variable in `post()` is
  visible in any operational log, or silently suppressed by the environment's error-reporting
  configuration, is not evidenced.
- No `facebook_leads.routing.yml` file exists in this module; both endpoints' paths come solely
  from `@RestResource` `uri_paths` annotations. Recorded here only to confirm the absence was
  checked, per the ground-truth instruction — not a gap in this document.
- No `v3.1` or `v3.3` variant of either `/api/*/facebook/lead` or `/api/*/facebook` exists anywhere
  in `config/` or `web/modules/custom/facebook_leads/` (Confirmed by search). If such variants are
  expected from other evidence (e.g. `it-zadani` target-state material), that would describe a
  target/future contract, not current-state — out of scope here per the current-vs-target rule.
- The literal verify-token, access-token, and pixel-id values are redacted from this document by
  policy; they remain in plaintext in the source files cited above and should be treated as
  credentials requiring rotation in any rebuild, independent of this contract's documentation.
