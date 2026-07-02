---
doc_id: ES0008
title: Google Tag Manager
canonical_layer: ES
spec_type: external-system
status: draft
references:
  - ARCH0001
  - FN0016
  - UC0013
---

# ES0008 – Google Tag Manager

## Purpose

Google Tag Manager delivers client-side analytics and tag-management capability so marketing and
conversion tracking can run on Patronus's public-facing frontends. It gives the platform a way to
signal visitor and conversion activity to marketing-measurement tooling without that signalling
being part of the platform's own server-side processing.

---

## System Overview

Google Tag Manager is a client-side tag-management / analytics service. It loads and fires
marketing and analytics tags directly in the visitor's browser, independently of the platform's
backend. It is one of the two analytics/marketing-signal boundaries named in the Integration
Landscape (`ARCH0001` §5, row 9), grouped there with Facebook Pixel under the same client-side
analytics role, but is a distinct vendor boundary from the Facebook integration surfaces
(`ES` for Facebook — Conversions API / Pixel / Lead Ads webhook — is documented separately).

---

## Integration Model

Outbound only, and entirely client-side: the integration boundary is the visitor's browser, not the
Patronus server. Tag-management/analytics code is injected into the page at render time on the
public frontend; Patronus's backend makes no server-side call to Google Tag Manager (`ARCH0001` §5
row 9; `UC0013` — analytics sub-flow, grouped under the Analytics-Adapter target boundary alongside
Facebook Pixel). This places Google Tag Manager outside the platform's server-side integration
landscape entirely — it participates only through what is rendered into the page (`ARCH0001` §5 row 9;
`FN0016`; `UC0013`). (Not named in `ARCH0002`, whose C8 chain covers only Mautic/WhoisXML.)

---

## Data Exchange

Outbound only: client-side page and interaction analytics/conversion signals, fired from the
visitor's browser once a page has rendered (`UC0013`). This is conceptual only — no event payload or
field-level detail is asserted; the platform's own analytics/conversion event-building responsibility
is owned by `FN0016`, not restated here. No data flows back from Google Tag Manager into Patronus.

---

## Constraints

- **Failure impact:** analytics-signal loss only; there is no domain impact on Application, Contact,
  or Transaction processing if this integration is unavailable (`ARCH0001` §5 row 9).
- **Boundary:** runs entirely client-side, outside the platform's server boundary — Patronus cannot
  observe or control delivery once the tag-management code has been rendered into the page.
- **Current-state only:** this reflects the integration as evidenced today; no target-state change is
  asserted here.
- **Evidence level:** grouped under the same integration boundary as the outbound analytics
  relay described in `FN0016`/`UC0013`; the capability's internal triggering logic for what fires
  through this boundary is not deep-mined (`Partial`).
