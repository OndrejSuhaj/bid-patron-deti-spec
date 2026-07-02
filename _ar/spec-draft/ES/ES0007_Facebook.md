---
doc_id: ES0007
title: Facebook
canonical_layer: ES
spec_type: external-system
status: draft
references:
  - ARCH0001
  - ARCH0002
  - FN0016
  - UC0013
---

# ES0007 – Facebook

## Purpose

Facebook is integrated to receive marketing-conversion signals so completed donations can be
attributed back to advertising campaigns, and — separately — was intended to be a source of inbound
marketing leads for intake into the platform. The outbound attribution path is live; the inbound lead
path is a confirmed current-state gap (`ARCH0001` §5 row 8; `FN0016`; `UC0013`).

---

## System Overview

Facebook is an external marketing/advertising platform. For this integration it exposes three
distinct surfaces, all treated as one external system (same vendor, merged aliases per synthesis
scope):

- the **Conversions API** — a server-side endpoint that ingests conversion/event signals for ad
  attribution;
- the **Pixel** — a client-side, browser-embedded event-signal mechanism rendered on page load;
- a **Lead Ads webhook** — an advertiser-facing subscription used by Facebook to push captured lead
  submissions to a receiving platform.

---

## Integration Model

Primarily **outbound (relay)**, with one dormant inbound surface:

- **Outbound server-side relay** — Patronus relays conversion/event signals to the Facebook
  Conversions API from a relay endpoint triggered by qualifying platform activity (`UC0013`,
  outbound conversion-event sub-flow).
- **Outbound client-side signal** — the Facebook Pixel emits event signals directly from the browser
  on page render, independent of the server-side relay (`UC0013`; grouped with Google Tag Manager
  under the same analytics boundary, `ARCH0001` §5 row 9).
- **Inbound webhook (subscription handshake only)** — Facebook can call a Patronus webhook endpoint
  to perform Lead Ads subscription verification (token compare + challenge echo). The same endpoint
  is also the intended destination for inbound lead-delivery calls, but that path performs no
  verification and no ingestion — `Status: Planned / Not Implemented` (`ARCH0001` §5 row 8, HS16;
  `UC0013` AF2).

---

## Data Exchange

- **Outbound:** conversion/attribution event signals describing qualifying donation activity (e.g.
  completed-donation and related event classes) together with identifying data required for
  match-back attribution, sent to the Conversions API; equivalent event signals emitted client-side by
  the Pixel on page render.
- **Inbound (subscription handshake only):** a verification token and challenge value exchanged
  during Lead Ads webhook subscription setup.
- **Inbound (not implemented):** lead-submission data that Facebook would deliver via the Lead Ads
  webhook is received at the endpoint but not read into any domain record — conceptually this would
  have populated a Contact and/or an Application had ingestion existed (see `EN0006`, `EN0009` for the
  entities on the Patronus side; not restated here).

---

## Constraints

- **No domain impact on outbound failure:** the outbound relay and Pixel paths carry marketing/
  analytics signals only; their failure causes attribution-signal loss with no effect on Patronus
  domain state (`ARCH0001` §5 rows 8–9).
- **Inbound lead intake — confirmed not implemented:** every inbound Lead Ads lead-delivery call
  receives a success-shaped response while the submitted data is silently discarded; Facebook is not
  informed of the failure. `Status: Planned / Not Implemented` (`ARCH0001` §5 row 8, HS16; `UC0013`
  AF2).
- **Subscription handshake only surface that functions:** of the inbound webhook's two responsibilities
  (verification handshake, lead ingestion), only the verification handshake is confirmed working
  (`UC0013` AF1).
- **Evidence depth:** the outbound Conversions API relay's triggering conditions and payload contents
  beyond "a qualifying conversion event" are `Partial` — evidenced at flow-index level, not deep-mined
  (`FN0016`).
- Current-state only; no target/future integration design is asserted here.
