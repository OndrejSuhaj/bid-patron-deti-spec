---
doc_id: FN0008
title: Payment Gateway Integration
canonical_layer: FN
spec_type: functional-capability
status: draft
references:
  - UC0005
  - UC0006
  - UC0007
  - EN0009
  - EN0010
---

# FN0008 – Payment Gateway Integration

## Purpose

Isolate the three per-region payment gateway boundaries — ComGate (CZ), Netopia/MobilPay (RO) and MAIB (MD) —
behind one capability: initiate a payment at the correct regional gateway, receive and authenticate its
confirmation, and map each gateway's status vocabulary to the domain payment status for FN0007. Clusters the
ComGate/Netopia/MAIB adapter family (do not treat as three capabilities).

## Responsibilities

- Initiate a checkout/charge at the region-appropriate gateway and return the redirect/handoff needed by the
  donor flow.
- Receive gateway confirmations by their native mechanism — ComGate server-to-server callback, Netopia encrypted
  IPN + browser return, MAIB browser return followed by an active server-to-server status re-poll.
- Authenticate each confirmation by the gateway's own scheme (shared-secret comparison, IPN decryption, or trusted
  re-poll rather than trusting the browser-supplied reference).
- Map the gateway-specific status/action vocabulary to the domain status (PENDING / AUTHORIZED / PAID / CANCELLED
  / REFUNDED) and hand the resolved outcome to FN0007.
- Capture the gateway payment token/expiry for a linked recurring schedule (Netopia) for later use by FN0010.

## Related Use Cases

UC0005 (initiate), UC0006 (confirm per gateway), UC0007 (recurring charge uses the gateway client).

## Related Entities

EN0009 (Transaction being confirmed), EN0010 (recurring token captured).

## Integrations

ComGate (CZ), Netopia / MobilPay (RO), MAIB (MD).

## Constraints

- Per-country: exactly one gateway per region; strongest vendor lock-in is Netopia (vendored SDK) and MAIB
  (mutual-TLS cert + passphrase).
- Callback endpoints are effectively public with no cryptographic signature (no HMAC); authenticity rests on a
  shared secret in the body or a re-poll — no replay/idempotence guard.
- Two gateways bind the same status-update path (ComGate and MAIB), a non-deterministic resolution collision
  (Hypothesis on which wins).
- MAIB browser-return shows any non-cancelled outcome (including still-pending) as success to the donor.
