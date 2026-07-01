# SRV0014 — Marketing, Analytics & Lead Integration

Status: Confirmed
> AR:SRVCurator draft · 2026-07-01 · see [SRV-candidates.md](SRV-candidates.md)

## Bounded Context
C8 — Messaging & Marketing

## SRV Category
Integration Adapter

## Responsibility Type
Adapter

## Purpose
Handles outbound marketing/analytics integrations: Mautic CRM sync, Facebook Conversions API (CAPI) event forwarding, Facebook Pixel, and Google Tag Manager/GA tracking. It is the single outbound marketing/analytics boundary, including the Facebook lead-event surface.

## Current Implementation Shape
- **Mautic CRM:** `MauticQueue` (`id = mautic_queue`) — `Mautic\MauticApi` + `Mautic\Auth\ApiAuth`, base URI `https://m.patrondeti.cz/api`, BasicAuth from env `MAUTIC_USER`/`MAUTIC_PASS` (`<redacted>`). Also `mautic` module + `mautic/api-library`. `Evidence:` `PSRC/web/modules/custom/patron_base/src/Plugin/QueueWorker/MauticQueue.php`; [integrations.md §3](../repo-map/integrations.md).
- **Facebook CAPI:** `FacebookResource` — `@RestResource` at `/api/3.2/facebook`; forwards pixel events (Lead/Purchase/CompleteRegistration), SHA-256-hashes user data, POSTs to `https://graph.facebook.com/v16.0/{pixel_id}/events`. Ingestion via `get()` query params; `post()` is a no-op. Hardcoded pixel id + access token (`<redacted>`). `Evidence:` `PSRC/web/modules/custom/facebook_leads/src/Plugin/rest/resource/FacebookResource.php`; [integrations.md §3,§11](../repo-map/integrations.md).
- **GTM / GA:** `drupal/google_tag ^2.0` + `config/google_tag.settings.yml`. `Evidence:` [integrations.md §3](../repo-map/integrations.md).
- **Facebook Pixel (client):** `drupal/facebook_pixel ^2.0`. `Evidence:` [integrations.md §3](../repo-map/integrations.md).
- **Tracking module:** `patron_tracking` (GTM/tracking hooks). `Evidence:` `PSRC/web/modules/custom/patron_tracking/`; [modules.md §2](../repo-map/modules.md).

## Structural Issues
- **Hardcoded secrets** — `facebook_leads` contains a cleartext pixel id + access token in `sendData()`. `Evidence:` [integrations.md §11](../repo-map/integrations.md).
- **Misnamed lead surface** — `facebook_leads` is an outbound CAPI forwarder, not an inbound Lead Ads webhook (as originally scouted); `post()` handler is dead. `Evidence:` [integrations.md §3 Correction](../repo-map/integrations.md).
- **Cross-context reach (lead intake)** — `facebook_leads` depends on `application` and feeds lead/registration events tied to C1 applications, so this adapter spans C8→C1. `Evidence:` [modules.md §3](../repo-map/modules.md); [SRV-candidates.md §Notes](SRV-candidates.md).
- **Placeholder module metadata** — `mautic` module ships the scaffold description ("The description."). `Evidence:` [modules.md §1](../repo-map/modules.md).

## Target Shape (for rewrite)
A Marketing/Analytics adapter behind ports (CRMSync, ConversionEvents, Tagging). Events emitted by domain (lead created, donation PAID) → adapter forwards. Secrets from vault; pixel/token from config. Separate client-side tagging (GTM/Pixel) from server-side CAPI forwarding.

## Integration Dependencies
- Mautic — `https://m.patrondeti.cz/api` (BasicAuth). `Confirmed`.
- Facebook Conversions API — `https://graph.facebook.com/v16.0/{pixel_id}/events`. `Partial` (verify pass).
- Google Tag Manager / GA — config present. `Confirmed`.
- Facebook Pixel — contrib module. `Confirmed`.
`Evidence:` [integrations.md §3](../repo-map/integrations.md).

## Boundaries
Does NOT send transactional mail → SRV0013. Does NOT own applications/leads it forwards events about → SRV0001. Does NOT own ops error alerting → SRV0018.

## Spec Alignment
N/A — no pre-existing SRV spec files (see SRV-candidates.md §1).

## Open Questions
- What triggers `MauticQueue` enqueue (which events/entities). `Missing evidence: mautic_queue enqueue call-sites.`
- Which pixel/CAPI events fire on which domain actions. `Missing evidence: FacebookResource get() consumer trace.`
- Is the FB access token still valid / rotated. `Missing evidence: token provenance (redacted in source).`
