---
doc_id: ES0002
title: Netopia / MobilPay
canonical_layer: ES
spec_type: external-system
status: draft
references:
  - ARCH0001
  - ARCH0002
  - FN0007
  - FN0008
  - FN0010
  - UC0005
  - UC0006
  - UC0007
---

# ES0002 – Netopia / MobilPay

## Purpose

Netopia (MobilPay) is the external payment gateway that captures card donation payments — including
recurring charges — for the Romanian-region frontend. It is the RO counterpart of the region's
payment-gateway boundary described in the Integration Landscape (ARCH0001 §5, row 2).

---

## System Overview

Netopia (MobilPay) is a Romanian card-payment gateway. It provides a hosted card-checkout experience
for the donor and reports the outcome of a payment back to the platform, for both one-off donations
and gateway-initiated recurring charges. Same-vendor alias merge: Netopia and MobilPay name the same
vendor/gateway and are treated as one external system — no separate ES entries are created for them.

---

## Integration Model

Bidirectional:

- **Outbound** — the platform calls Netopia/MobilPay to initiate a card payment for a donation
  (UC0005) and, separately, to initiate a recurring charge on a schedule (UC0007).
- **Inbound** — Netopia/MobilPay returns the payment outcome to the platform via an IPN
  (instant-payment-notification) redirect/callback carrying the result of the initiated transaction
  (UC0006).

This corresponds to ARCH0002's chain A: (a) the synchronous external checkout/IPN exchange, and (b)
the recurring-payment cron path that also calls this gateway.

The gateway is reached through environment-switched endpoints (production vs. sandbox); which
endpoint is used is an environment/configuration concern, not a business-boundary distinction.

---

## Data Exchange

- Outbound: initiation of a RO donation/checkout payment, and initiation of a scheduled recurring
  charge against a previously established recurring donation.
- Inbound: the payment outcome/notification for the initiated transaction, delivered via the IPN
  redirect/callback.

No payload or field-level detail is defined here — see the corresponding API-layer contract
(referenced via EN0009/EN0010, the Transaction and RecurringTransaction entities this exchange
updates).

---

## Constraints

- Of the three regional payment gateways, this integration carries the strongest vendor lock-in
  (the platform depends on a vendored, gateway-specific library) (ARCH0001 §5 row 2).
- The RO recurring-charge cron path lacks an environment guard; a failure on this path risks loss of
  payment capture or of the stored recurring-charge token (ARCH0001 §5 row 2; **HS11**).
- Recurring charges initiated through this gateway are recorded as PAID optimistically, before the
  gateway's outcome is confirmed, creating a double-charge risk if the outcome later disagrees
  (ARCH0002 async queue boundaries, recurring-payment cron path; **HS04**).
- Current-state only; these constraints reflect the system as implemented, not a target design.
