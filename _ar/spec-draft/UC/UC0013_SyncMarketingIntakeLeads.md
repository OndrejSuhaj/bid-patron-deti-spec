# UC0013 — Sync Marketing & Intake Leads

## Header

| Field | Value |
|---|---|
| UC ID | UC0013 |
| Name | Sync Marketing & Intake Leads |
| Bounded Context | C8 |
| Primary Actor(s) | Integration(Facebook), System |
| Trigger Type | Webhook/Async |

## Actors & Responsibilities

- **Integration(Facebook)** — external Meta/Facebook platform: intended source of inbound Lead Ads webhook calls (not functioning today); also the destination of outbound Conversions API (CAPI) event relays.
- **Integration(Mautic)** — external marketing CRM system; receives outbound contact upserts so marketing campaigns can target known Contacts (EN0006).
- **Integration(GTM/Pixel)** — external analytics/tag-management surface receiving conversion/event signals for marketing attribution.
- **System** — Patronus platform: hosts the webhook endpoint, and (on the outbound side) builds and sends contact/event payloads to the marketing and analytics integrations.

## Intent

Keep Patronus's marketing and analytics tooling in sync with platform activity: on the outbound side, push known Contacts (EN0006) and payment/donation events (Transaction, EN0009) to the marketing CRM (Mautic) and to Facebook's Conversions API / analytics tooling for campaign targeting and attribution. On the inbound side, the platform exposes a webhook intended to ingest Facebook Lead Ads submissions as new leads, but this inbound path is confirmed not implemented.

## Preconditions

- The Facebook Lead Ads webhook endpoint is configured and enabled at the platform, accepting both subscription-verification and lead-delivery calls (inbound sub-flow only).
- A Contact (EN0006) or Transaction (EN0009) exists in Patronus as the source record for an outbound sync (outbound sub-flows).
- Outbound integration credentials/config for Mautic and Facebook CAPI are provisioned (evidence for this configuration is index-level only; not deep-mined).

## Main Flow

### UC0013.1 — Outbound Contact sync to Mautic CRM (partial evidence)
1. System: detect a Contact (EN0006) change or event that qualifies for marketing sync.
2. System: build a contact upsert payload from the Contact (EN0006) record.
3. Integration(Mautic): receive the contact upsert and update its own contact record.

### UC0013.2 — Outbound conversion event relay to Facebook CAPI (partial evidence)
1. System: detect a qualifying event on a Transaction (EN0009), such as a completed donation.
2. System: build a conversion event payload referencing the Transaction (EN0009).
3. Integration(Facebook): receive the relayed conversion event via the Conversions API for attribution.

## Alternative Flows

### AF1 — Facebook Lead Ads webhook subscription verification (as observed)
1. Integration(Facebook): send a subscription-verification request to the Patronus webhook endpoint, carrying a verification token and a challenge value.
2. System: compare the supplied verification token against the configured token.
3. System: if the token matches, return the challenge value to Integration(Facebook), completing subscription verification.
4. System: if the token does not match, respond that the token is invalid.

Outcome: The webhook subscription handshake succeeds or fails; no domain entities are read or written in either case.

### AF2 — Facebook Lead Ads inbound lead intake — Planned / Not Implemented
1. Integration(Facebook): send a lead-delivery call to the Patronus webhook endpoint carrying a submitted lead's data.
2. System: respond that the token is invalid, regardless of the content or validity of the call.

Outcome: **Planned / Not Implemented.** No verification of the inbound payload is actually performed, no Contact (EN0006) or Application (EN0001) is created, and no downstream processing occurs. Integration(Facebook) receives a success-shaped response (HTTP 200) while the lead is silently discarded — this is a confirmed current-state gap, not a designed rejection path. The originally intended behavior (verify token, ingest lead, create an Application (EN0001) and/or Contact (EN0006)) does not exist in the running system today.

## Postconditions

- Outbound sub-flows (UC0013.1, UC0013.2): the marketing CRM (Mautic) and/or Facebook CAPI/analytics tooling hold an updated record reflecting the Contact (EN0006) or Transaction (EN0009) that triggered the sync; no Patronus entity state changes as a result of the sync itself.
- AF1: the webhook subscription is confirmed active (or the verification attempt is rejected); no entity state changes.
- AF2: no entity is created or updated; the submitted lead data is lost; Integration(Facebook) is not informed of the failure.

## Traceability

Target SRVs:
- Mautic-CRM-Adapter
- FacebookCAPI-Adapter
- Analytics-Adapter (GTM/Pixel)

EN entities:
- EN0006 Contact — subject of the outbound Mautic sync (UC0013.1); would have been the entity created by the inbound lead intake had it been implemented (AF2)
- EN0009 Transaction — subject of the outbound Facebook CAPI conversion relay (UC0013.2)

Integration boundaries:
- Facebook (Lead Ads webhook inbound — AF1/AF2; Conversions API outbound — UC0013.2)
- Mautic (CRM outbound — UC0013.1)
- GTM/Pixel (analytics outbound — grouped with UC0013.2 under the Analytics-Adapter target SRV)

Flow Evidence:
- FLW0029 (mined dossier; Facebook Lead Ads webhook — confirms AF1 subscription-verification behavior and AF2 not-implemented status)
- FL049 (un-mined flow-index entry; Mautic contact upsert — basis for UC0013.1)
- FL051 (un-mined flow-index entry; Facebook CAPI relay — basis for UC0013.2)

## Evidence Level

Partial — AF1/AF2 are Confirmed against the mined dossier FLW0029 (SRV0014 domain classification; no entities read or written); UC0013.1/UC0013.2 rest on un-mined, index-only flow references (FL049, FL051) for EN0006 (Contact) and EN0009 (Transaction) respectively, so the outbound sub-flows are stated at the level the index supports and no deeper internal steps are asserted.
