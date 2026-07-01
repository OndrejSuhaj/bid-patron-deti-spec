# FLW0029 — Facebook Lead Ads webhook intake
> AR:FlowMiner dossier · 2026-07-01 · source FlowID FL050 · see [../flow-index.md](../flow-index.md)

## A. Header
- FlowID: FL050 (dossier FLW0029)
- Flow Name: Facebook Lead Ads webhook intake
- Primary SRV: SRV0014
- Trigger Evidence: `@RestResource` `facebook_lead_webhook_resource`, `create`/`canonical` URI `/api/2.2/facebook/lead` — `web/modules/custom/facebook_leads/src/Plugin/rest/resource/FacebookLeadWebhookResource.php` (POST `post($data)` L88-93; GET `get()` L102-113). Enabled by `config/rest.resource.facebook_lead_webhook_resource.yml`.
- Confidence Level: Confirmed (that the POST handler is a non-functional no-op stub; the *intended* lead ingestion described by the flow-index is NOT implemented — see Conflict below)

## B. Behavior Digest
- Trigger: Inbound HTTP to the Drupal REST resource `/api/2.2/facebook/lead` (methods GET + POST, format json), intended to be called by the Meta / Facebook Lead Ads webhook. `FacebookLeadWebhookResource.php` L16-24 (route annotation).
- Preconditions: Route enabled via `config/rest.resource.facebook_lead_webhook_resource.yml` (status: true). Permission `restful get/post facebook_lead_webhook_resource` is granted to the **anonymous** and **authenticated** roles (`config/user.role.anonymous.yml` L114/L157, `config/user.role.authenticated.yml` L124/L166), so the configured `authentication: cookie` is effectively not enforced for anonymous callers.
- Main Steps:
  - **POST path (broken / no-op):** `post($data)` (`FacebookLeadWebhookResource.php` L88) logs to channel `facebook_update` using an **undefined variable `$request_data`** (L90 — `json_encode($request_data)`; the actual payload arrives as `$data` and is never read), then unconditionally returns `ResourceResponse(['status'=>'failed','error'=>'token is invalid'], 200)` (L92). No token verification, no payload parsing, no entity creation, no downstream call.
  - **GET path (webhook subscription verification):** `get()` (L102) logs `$_GET` to channel `facebook_subscription` (L104), reads `hub_verify_token` and `hub_challenge` query params (L106-107), and if the verify token equals a hardcoded literal (L109, value `<redacted>`) it `die($challenge)` echoing the challenge back to complete Meta's webhook subscription handshake (L110); otherwise returns `{status:failed, error:'token is invalid'}` HTTP 200 (L112).
- Postconditions: **None.** No database state changes on either path. POST always answers `failed / token is invalid` at HTTP 200; GET answers either the raw challenge string (200, verification OK) or `failed` (200).
- Side Effects: Watchdog/log writes only — `facebook_update` (POST, but crashes on the undefined var under strict error settings — see Failure Modes) and `facebook_subscription` (GET, logs full inbound query string incl. any PII Meta places in it). No entities, no messages, no outbound HTTP.
- Integration Calls: None outbound. This resource is the *inbound* half. (The **outbound** Facebook Conversions API forwarder is a **separate** resource `FacebookResource` at `/api/3.2/facebook` — FL051 — not part of this flow; see `web/modules/custom/facebook_leads/src/Plugin/rest/resource/FacebookResource.php:sendData()`.)
- Failure Modes:
  - `Security` / `External Integration`: POST handler references undefined `$request_data` (L90). Under Drupal/PHP notice-to-exception error handling this throws before returning; otherwise it logs `null`/`"null"`. Either way the lead payload is discarded.
  - `External Integration`: POST **always** returns `status: failed, error: token is invalid` at HTTP 200 — Facebook receives a 200 (treats delivery as accepted) while zero leads are ingested → silent total data loss of inbound leads.
  - `Security`: Hardcoded webhook verify token embedded in source (L109, `<redacted>`) — no config/secret indirection; rotation requires a code change; leaks in VCS history.
  - `Security`: GET logs the entire `$_GET` (L104) to the log channel, potentially persisting inbound query data.
  - `Idempotence`: N/A — no writes occur, so no dedup/idempotency concern is reachable (the handler never processes a lead id).

### Conflict — START hint vs. actual code
The flow-index START hint states the POST handler should "verify token; ingest lead -> create application/contact" (`../flow-index.md` FL050, entities `application, contact`). **This behavior does not exist in the code.** The `post()` method performs no token verification, no ingestion, and writes no `application`/`contact` entity; it is a stub that always returns `token is invalid`. The `facebook_leads.info.yml` declares `dependencies: application`, but no code in the module invokes application/contact creation for the webhook. This matches the prior verify-pass correction recorded in `_ar/repo-map/integrations.md` (L42): the module's real, working integration is the **outbound CAPI forwarder** in `FacebookResource` (FL051), not an inbound Lead Ads intake. Recorded as `Conflict — requires clarification` (planned-not-built inbound intake). `Status: Planned / Not Implemented`.

## C. Data Footprint
- Entities Written: **None.** (Intended-but-absent: `application`, `contact` per flow-index — not written in code.)
- Entities Read: **None.** (POST ignores `$data`; GET reads only request query params `hub_verify_token`, `hub_challenge`, and dumps `$_GET`.)
- Constraints involved: None reached (no persistence). Intended uniqueness/dedup for imported leads is not implemented.
- Multi-tenant scope assumptions: None applied. The single `/api/2.2/facebook/lead` route has no CZ/RO/MD region/domain scoping in the handler; the sibling resource config `rest.resource.facebook_leads_facebook.yml` carries `langcode: ro` and this one `langcode: cs` (config metadata only, not runtime tenant routing). Had ingestion existed, region assignment would be undefined — `Hypothesis`.

## D. Evidence Block
- Controller paths: `web/modules/custom/facebook_leads/src/Plugin/rest/resource/FacebookLeadWebhookResource.php` — `post($data)` L88-93 (broken no-op), `get()` L102-113 (subscription verify), `create()` DI L65-74 (injects `logger.factory` channel `facebook_leads`, `current_user`).
- Service methods: None invoked. No SRV0014 service, no SRV0001 application service, and no queue/dispatcher is called from this resource. SRV0014 linkage is by domain classification only (Messaging & Marketing / Facebook), not by a code call in this flow.
- Repository usage: None. No `entityTypeManager`, no storage handler, no `\Drupal::database()` access anywhere in the class.
- Event listeners: None dispatched or subscribed by this flow.
- Async messages: None enqueued. (Contrast FL049 `mautic_queue` / FL048 `mailing_queue` which do enqueue — not reached here.)
- Config evidence: `config/rest.resource.facebook_lead_webhook_resource.yml` — `id/plugin_id: facebook_lead_webhook_resource`, `granularity: resource`, `methods: [GET, POST]`, `formats: [json]`, `authentication: [cookie]`, `status: true`, `langcode: cs`. Permission grants: `config/user.role.anonymous.yml` L41-42/L114-115/L157-158 and `config/user.role.authenticated.yml` L43-44/L124-125/L166-167. Module manifest: `web/modules/custom/facebook_leads/facebook_leads.info.yml` (`dependencies: application`).
