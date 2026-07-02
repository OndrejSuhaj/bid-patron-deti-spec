---
doc_id: FN0011
title: Voucher Issuance & Redemption
canonical_layer: FN
spec_type: functional-capability
status: draft
references:
  - UC0009
  - UC0006
  - EN0013
  - EN0009
  - EN0004
  - FN0007
  - FN0019
---

# FN0011 – Voucher Issuance & Redemption

## Purpose

Manages the gift Voucher (Dobrošek) instrument across its lifecycle: a Voucher is issued and promoted
to paid through a purchase Transaction, then validated and redeemed by a recipient against a chosen
Campaign — turning a prepaid, paid-but-unused Voucher into an applied donation.

---

## Responsibilities

The capability is responsible for:

- Validating a submitted Voucher identifier or code, requiring the paid state and not-yet-redeemed
  status, and returning the code, expiration and value on successful validation.
- Redeeming a Voucher by binding it to a target Campaign, marking it redeemed with a redemption
  timestamp, and optionally recording a recipient e-mail address.
- Re-pointing the Voucher's originating purchase Transaction to the redemption target Campaign, so
  the donation is re-attributed to that Campaign.
- Triggering the redemption-confirmation message (via FN0019) to the purchase Transaction's e-mail
  address.
- Being promoted to paid/ready-to-use by the donation payment processing capability (FN0007) when its
  purchase Transaction reaches the PAID status.

---

## Related Use Cases

- UC0009 – Redeem / Validate Voucher
- UC0006 – Confirm Payment (Gateway Callback) — source of the paid-promotion side effect (UC0006.4)

---

## Related Entities

- EN0013 – Voucher
- EN0009 – Transaction
- EN0004 – Campaign

---

## Integrations

No direct external-system integration. The redemption-confirmation e-mail is dispatched through the
transactional messaging capability (FN0019), not directly by this capability. (See
ARCH0002_ContextInteractionMap for the platform's integration landscape.)

---

## Constraints

- The Voucher code has no enforced uniqueness constraint; redemption by code may resolve to an
  arbitrary matching record when duplicates exist — Partial / Hypothesis, evidenced as a data-quality
  risk, not a designed behavior (see UC0009 AF3).
- Validation and redemption are reachable by anonymous, unauthenticated Customers (see FLW0018
  anonymous-access finding); failure outcomes are communicated in-band (invalid/failed status in the
  response) rather than through distinguishing error responses (see UC0009 AF1/AF2). Hypothesis —
  brute-force / rate-limit exposure Not evidenced in current sources: no throttling mechanism was found
  in the reviewed flow evidence.
- The redemption check-then-update sequence is not concurrency-guarded, so two near-simultaneous
  redemption requests for the same Voucher code may both pass the not-yet-redeemed check before either
  update is persisted — Partial / Hypothesis, evidenced as a concurrency/race risk, not a confirmed
  guarded behavior (see UC0009 AF4).
- Promotion of a Voucher to paid/ready-to-use is driven entirely by its purchase Transaction reaching
  PAID (FN0007 / UC0006.4); this capability does not itself decide payment outcomes.
