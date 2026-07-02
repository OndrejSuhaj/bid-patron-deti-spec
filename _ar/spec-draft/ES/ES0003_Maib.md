---
doc_id: ES0003
title: MAIB
canonical_layer: ES
spec_type: external-system
status: draft
references:
  - ARCH0001
  - ARCH0002
  - FN0007
  - FN0008
  - UC0005
  - UC0006
---

# ES0003 – MAIB

## Purpose

MAIB is the external payment gateway that captures card donation payments for the Moldovan region.
It is the MD counterpart of the region's payment-gateway boundary described in the Integration
Landscape (ARCH0001 §5, row 3).

---

## System Overview

MAIB is a Moldovan bank eCommerce card-payment gateway. It authorises and settles one-off donation
payments initiated by the platform for the MD flow, communicating over a mutual-TLS channel secured
by a client certificate.

No alias merge applies: MAIB is a single, MD-only integration with one interaction mode, unlike the
ComGate (ES0001) and Facebook multi-mode mergers.

---

## Integration Model

Bidirectional:

- **Outbound** — the platform calls MAIB to initiate an MD donation payment, and separately calls
  MAIB again to re-poll the authoritative status of a previously initiated transaction (UC0005,
  UC0006).
- **Inbound** — the donor's browser is returned by MAIB to the platform carrying a transaction
  reference; the platform does not trust this browser-supplied reference on its own and instead uses
  it to trigger the server-to-server status re-poll against MAIB (UC0006).

The channel is authenticated with a client TLS certificate plus a passphrase, rather than a
shared-secret callback signature.

This corresponds to ARCH0002's chain A, item (a): the synchronous external checkout/status exchange.

---

## Data Exchange

- Outbound: initiation of an MD donation/checkout transaction, and a status re-poll for a given
  transaction reference.
- Inbound: the browser-return carrying the transaction reference (used only to trigger the re-poll,
  not treated as authoritative), and the re-poll response reporting the authoritative payment status
  for that transaction.

No payload or field-level detail is defined here — see the corresponding API-layer contract
(referenced via EN0009, the Transaction entity that this exchange updates).

---

## Constraints

- The integration is locked to a client TLS certificate and passphrase rather than a
  shared-secret/HMAC scheme (ARCH0001 §5 row 3).
- A failure of the status re-poll leaves the Transaction stuck in PENDING, with no evidenced retry
  (ARCH0001 §5 row 3).
- The browser-return path displays any non-cancelled outcome — including a still-pending result — to
  the donor as success (FN0008; UC0006).
- MAIB shares the same status-update path as ComGate, a non-deterministic resolution collision on
  which gateway's update wins (Hypothesis — not evidenced as a designed behavior) (FN0008).
- Current-state only; all constraints reflect the system as implemented, not a target design.
