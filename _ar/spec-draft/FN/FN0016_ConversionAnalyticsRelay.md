---
doc_id: FN0016
title: Conversion & Analytics Relay
canonical_layer: FN
spec_type: functional-capability
status: draft
references:
  - UC0013
  - EN0009
  - EN0006
---

# FN0016 – Conversion & Analytics Relay

## Purpose

Relay conversion and analytics signals from Patronus to external marketing-measurement tooling —
server-side donation-event relay to Facebook's Conversions API and client-side event signals to
Google Tag Manager / Facebook Pixel — so that donation campaigns can be attributed. The capability
also hosts the inbound Facebook Lead Ads webhook surface, which today only answers the
subscription-verification handshake; the intended lead-intake path behind it is not implemented.

---

## Responsibilities

The capability is responsible for:

- Building a conversion event payload from a qualifying Transaction (`EN0009`) and relaying it to
  Facebook's Conversions API for attribution of completed donations to marketing campaigns.
- Emitting client-side conversion/event signals through Google Tag Manager / Facebook Pixel on page
  render, for campaign attribution independent of the server-side relay.
- Hosting the Facebook Lead Ads webhook endpoint's subscription-verification handshake: validating
  an inbound verification token against the configured value and echoing back the supplied challenge
  on match.
- Receiving inbound Facebook Lead Ads lead-delivery calls at the same webhook endpoint — a capability
  that is defined at the integration boundary but performs no verification, no ingestion, and no
  domain effect (see Constraints).

---

## Related Use Cases

UC0013 – Sync Marketing & Intake Leads (Facebook CAPI conversion relay sub-flow, GTM/Pixel analytics
sub-flow, and Lead Ads webhook alternative flows — reference only)

---

## Related Entities

EN0009 – Transaction (source record for the outbound conversion event relay)

EN0006 – Contact (would have been the entity created by inbound lead intake, had it been
implemented — not created today)

---

## Integrations

Facebook (Conversions API — outbound server-side conversion relay; Facebook Pixel — client-side
event signal; Lead Ads webhook — inbound subscription handshake and intended lead delivery), and
Google Tag Manager (client-side analytics/event signal), named as SRV0014's integration boundaries in
SRV-target-list.md and SRV-architecture-map.md and referenced via UC0013's Integration boundaries. The
ES layer does not yet exist for this project; no `ESxxxx` id is asserted.

---

## Constraints

- Marketing/analytics-signal only: this capability has no domain effect — it does not create,
  update, or transition Application, Contact, or Transaction records; it only reads a Transaction to
  build an outbound payload.
- The inbound Facebook Lead Ads lead-intake path is a confirmed current-state gap:
  `Status: Planned / Not Implemented`. Every inbound lead-delivery call is answered with a
  success-shaped HTTP 200 response while the submitted lead data is silently discarded — no Contact
  or Application is created, and Facebook is not informed of the failure. Only the
  subscription-verification handshake (token compare + challenge echo) is functioning as observed.
- The webhook accepts calls anonymously; the verification token it checks against is a fixed,
  hardcoded configuration value rather than a rotable credential.
- The outbound Facebook CAPI conversion relay is evidenced only at flow-index level (un-mined) — its
  triggering conditions beyond "a qualifying Transaction event" and its payload contents are
  `Partial`, not deep-mined.
- The client-side GTM/Pixel event signal is grouped with the outbound CAPI relay under the same
  integration boundary but is architecturally distinct (browser-side vs. server-side emission); its
  internal triggering logic is not deep-mined either.
