---
doc_id: BR-MarketingAndAnalyticsRelay
title: Marketing / CRM Sync & Analytics Relay
canonical_layer: BR
spec_type: business-rule
status: draft
affects:
  - EN0006
  - EN0008
  - EN0009
  - SYSTEM
references:
  - EN0006
  - EN0008
  - EN0009
  - UC0012
  - UC0013
  - UC0015
  - BR-DataProtectionAndErasure
---

# BR – Marketing / CRM Sync & Analytics Relay

## Purpose

Governs the current-state rules for synchronising platform parties to the external marketing CRM,
relaying donation-conversion and analytics signals to external measurement tooling, and the inbound
marketing lead-intake surface. These rules are marketing-side only; they do not carry domain effects
on the case, story, or money aggregates.

---

## CRM contact synchronisation

- The System SHALL upsert a party's marketing-CRM contact when the party's User (EN0008) record is
  saved — covering registration, later changes, and GDPR anonymisation — and additionally as a
  side-effect of each transactional message send (see UC0012, UC0013).
- Current-state: CRM synchronisation SHALL be treated as best-effort and non-authoritative — a
  failed sync affects only the CRM copy and SHALL NOT change the outcome of the originating save or
  send.
- Current-state: the marketing-CRM contact-deletion invoked on erasure performs no actual removal,
  and re-synchronisation after anonymisation re-creates the contact — this anti-erasure interaction
  is owned by BR-DataProtectionAndErasure and is not restated here.

---

## Conversion & analytics relay

- The System SHALL relay a completed-donation conversion event for a qualifying Transaction (EN0009)
  to the external conversions channel for campaign attribution (see UC0013).
- The System SHALL emit client-side conversion/analytics signals through the external tag-management
  / pixel channel on page render, independently of the server-side relay.
- The conversion/analytics relay SHALL be marketing-signal only: it SHALL NOT create, update, or
  transition any Application, Contact (EN0006), or Transaction (EN0009) record.
- Current-state: relay failure or unavailability SHALL cause marketing-signal loss only and SHALL
  NOT affect donation or application processing.

---

## Inbound marketing lead intake (current-state: Planned / Not Implemented)

- Current-state: the inbound marketing lead-intake webhook SHALL be treated as **not implemented** —
  it answers only the subscription-verification handshake; a lead-delivery call is accepted but its
  data is discarded, no Contact (EN0006) or Application is created, and a success response is
  returned to the sender (see UC0013 Planned/Not-Implemented alternative flow).
- Current-state: the webhook accepts anonymous calls and its verification token is a fixed,
  hard-configured value rather than a rotatable credential — recorded as a current-state security
  gap, not a designed control.

---

## Non-Goals

- This rule does not define the transactional-message contract (trigger, recipients, content) —
  owned by the MSG layer and BR-TransactionalMessaging.
- This rule does not define personal-data erasure policy or the anti-erasure consequence itself —
  owned by BR-DataProtectionAndErasure.
- This rule does not define the external-system integration boundaries — owned by the ES layer.
