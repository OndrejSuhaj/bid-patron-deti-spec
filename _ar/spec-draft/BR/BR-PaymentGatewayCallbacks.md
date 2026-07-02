---
doc_id: BR-PaymentGatewayCallbacks
title: Payment Gateway Callback Authenticity & Status Mapping
canonical_layer: BR
spec_type: business-rule
status: draft
affects:
  - EN0009
  - EN0010
  - SYSTEM
references:
  - EN0009
  - EN0010
  - UC0005
  - UC0006
  - UC0007
---

# BR – Payment Gateway Callback Authenticity & Status Mapping

## Purpose

Governs how per-region gateway confirmations are authenticated and mapped to the domain payment
status, and records the current-state authenticity gaps in that process.

## One gateway per region

- Each region SHALL route payments through exactly one payment gateway (the CZ gateway, the RO
  gateway, or the MD gateway).

## Confirmation authentication (current-state)

- A gateway confirmation SHALL be authenticated by that gateway's own scheme rather than by
  trusting browser-supplied return data.
- Current-state: gateway callback endpoints SHALL NOT be assumed to carry a cryptographic
  signature and carry no replay or idempotence guard; authenticity currently rests on a
  replayable shared secret or a re-poll.
- Current-state: a confirmation that does not match an existing Transaction (EN0009) by its correlation
  identifiers SHALL leave that Transaction unmarked, with no fallback reconciliation triggered — a
  payment that was in fact completed at the gateway can remain permanently un-recorded as PAID.

## Status mapping

- Each gateway's native status vocabulary SHALL be mapped to the domain payment status (PENDING /
  AUTHORIZED / PAID / CANCELLED / REFUNDED) before the outcome is applied to the money record.
- Current-state: the MD gateway browser-return SHALL NOT be relied upon as the settlement source
  — any non-cancelled browser outcome is currently shown to the donor as success while the
  authoritative status comes from a server-side re-poll.

## Non-Goals

This rule does not define the downstream PAID cascade (campaign funding recomputation, role
promotion, confirmation messaging) or payment-identity uniqueness, which are governed by
BR-PaymentAndMoneyIntegrity. It does not define recurring-charge execution or gateway token
capture mechanics, which are governed by BR-RecurringDonationPolicy. It does not restate
Transaction or RecurringTransaction attributes (→ EN0009, EN0010) or the step-by-step per-gateway
confirmation flow (→ UC0006, UC0005, UC0007).
