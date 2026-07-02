---
doc_id: ES0001
title: ComGate
canonical_layer: ES
spec_type: external-system
status: draft
references:
  - ARCH0001
  - ARCH0002
  - FN0007
  - FN0008
  - FN0010
  - FN0012
  - UC0005
  - UC0006
  - UC0007
  - UC0008
---

# ES0001 – ComGate

## Purpose

ComGate is the external payment gateway that captures card and online donation payments for the
Czech region, and separately supplies the gateway-side transfer/settlement listing that the platform
uses to reconcile which captured payments have actually been paid out to the bank. It is the CZ
counterpart of the region's payment-gateway boundary described in the Integration Landscape
(ARCH0001 §5, rows 1 and 6).

---

## System Overview

ComGate is a Czech payment-gateway service reached over its own (simple/AGMO) protocol. It performs
two distinct roles at the integration boundary:

- authorising and settling one-off and recurring card/online donation payments initiated by the
  platform (payment mode);
- exposing a transfer/settlement listing service that reports the payouts a merchant has received,
  independent of and later than the individual payment transactions (settlement mode).

Same-vendor alias merge: the ComGate payment gateway (checkout + status callback) and the ComGate
transfer/settlement sync are treated as one external system, ComGate, with two interaction modes —
per the ES merge rule for same-vendor aliases.

---

## Integration Model

Bidirectional, with two interaction modes:

- **Payment mode** — outbound: the platform calls ComGate to create a checkout transaction for a
  donation and to query a transaction's status; inbound: ComGate calls back to the platform with the
  payment outcome for that transaction (UC0005, UC0006).
- **Settlement mode** — outbound only, on a scheduled/CLI cadence: the platform pulls the
  transfer/settlement listing from ComGate for reconciliation purposes (UC0008).

This corresponds to ARCH0002's chain A: (a) the synchronous external checkout/callback exchange, and
(b) the reconciliation cron/CLI pull.

---

## Data Exchange

- Payment mode, outbound: initiation of a donation/checkout transaction and a status query for a
  given transaction.
- Payment mode, inbound: the payment outcome/status for that transaction, delivered via callback.
- Settlement mode, outbound: transfer/settlement listing records used to match previously captured
  payments to the corresponding bank payouts.

No payload or field-level detail is defined here — see the corresponding API-layer contract
(referenced via EN0009, the Transaction entity that this exchange updates).

---

## Constraints

- The payment-outcome callback route is effectively public: it carries no HMAC signature and no
  replay/idempotence guard. A silent no-match on callback processing leaves a paid Transaction never
  marked PAID, causing a lost reconciliation (ARCH0001 §5 row 1; **HS12**).
- The settlement/transfer sync is row-limited (capped) and has no HTTP/JSON error handling: excess
  split-payment rows are silently left unmarked when the cap is exceeded (ARCH0001 §5 row 6;
  **HS05**).
- Current-state only; both constraints reflect the system as implemented, not a target design.
