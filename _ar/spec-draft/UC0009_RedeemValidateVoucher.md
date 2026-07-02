# UC0009 — Redeem / Validate Voucher

## Header

| Field | Value |
|---|---|
| UC ID | UC0009 |
| Name | Redeem / Validate Voucher |
| Bounded Context | C6 |
| Primary Actor(s) | Customer |
| Trigger Type | API |

## Actors & Responsibilities

- **Customer** — the voucher recipient (may be anonymous); submits a voucher code for validation and/or applies it against a chosen Campaign (EN0004).
- **System** — validates the Voucher (EN0013) state, binds it to the chosen Campaign, updates the related Transaction (EN0009), and dispatches the confirmation e-mail.

## Intent

Let a recipient confirm that a gift Voucher (Dobrošek) is genuine and still usable, then redeem it by binding it to a chosen Campaign — turning a prepaid, paid-but-unused Voucher into an applied donation against that Campaign's fundraising total.

## Preconditions

- A Voucher (EN0013) already exists and has previously reached the paid state (see EN0013 lifecycle; promotion happens outside this UC).
- The Voucher has not yet been redeemed (see EN0013 lifecycle for the redeemed / not-redeemed distinction).
- For redemption: the target Campaign (EN0004) exists and can be loaded.

## Main Flow

### UC0009.1 — Validate a Voucher
1. Customer: submits a Voucher identifier (UUID) for validation, with no intent to redeem yet.
2. System: rejects the request if the identifier is missing, returning a failed outcome.
3. System: looks up the Voucher by UUID, requiring it to be in the paid state and not yet redeemed.
4. System: returns a valid outcome together with the Voucher's code, expiration date, and value when the lookup succeeds; otherwise returns an invalid outcome.

### UC0009.2 — Apply (Redeem) a Voucher
1. Customer: submits a Voucher code together with the target Campaign identifier, and optionally a recipient e-mail address.
2. System: rejects the request if the Voucher code or the Campaign identifier is missing, returning a failed outcome.
3. System: loads the target Campaign (EN0004); rejects the request if the Campaign cannot be found.
4. System: looks up the Voucher (EN0013) by its code; rejects the request if no matching Voucher is found, if it is already redeemed, or if it is not in the paid state.
5. System: binds the Voucher to the target Campaign, marks it as redeemed, and records the redemption timestamp.
6. System: records the supplied recipient e-mail address on the Voucher when one was provided and it is a valid e-mail format; an invalid e-mail is silently ignored.
7. System: re-points the Voucher's originating purchase Transaction (EN0009) to the same target Campaign, so the donation is now attributed there.
8. Integration(SmartMailing): sends a redemption-confirmation e-mail to the purchase Transaction's e-mail address.
9. System: returns a successful outcome to the Customer.

## Alternative Flows

### AF1 — Validation fails (unknown, unpaid, or already-redeemed Voucher)
1. Customer: submits a Voucher identifier for validation.
2. System: finds no Voucher matching both the paid and not-yet-redeemed conditions.
3. System: returns an invalid outcome with no further detail.

Outcome: the Customer is informed the Voucher cannot be used; no state changes.

### AF2 — Redemption fails (unknown code, already redeemed, or unpaid Voucher)
1. Customer: submits a Voucher code and a target Campaign identifier.
2. System: finds no matching Voucher by code, or finds the Voucher already redeemed, or finds it not yet paid.
3. System: returns a failed outcome; no state changes are made.

Outcome: the Voucher remains in its prior state; the Customer must correct the code or contact support.

### AF3 — Duplicate voucher codes collide (data-quality risk)
1. Customer: submits a Voucher code for redemption that is not guaranteed unique in the underlying data.
2. System: selects one arbitrarily matching Voucher record when redeeming by code.

Outcome: Partial / Hypothesis — evidenced as a data-integrity risk in the flow dossier (no enforced uniqueness on the Voucher code), not a designed behavior; flagged for the rebuild rather than asserted as intended logic.

### AF4 — Concurrent redemption of the same Voucher (race risk)
1. Customer: two redemption requests for the same Voucher code arrive close together.
2. System: both requests may pass the not-yet-redeemed check before either request's update is saved.

Outcome: Partial / Hypothesis — evidenced as a concurrency/idempotence risk in the flow dossier (no locking around the check-then-update sequence); recorded as an observed risk, not a confirmed guarded behavior.

## Postconditions

- Validate: no state change; the Customer has received a valid/invalid determination.
- Apply (success): the Voucher (EN0013) is bound to the target Campaign (EN0004), marked redeemed, with a redemption timestamp set and, optionally, a recipient e-mail recorded.
- Apply (success): the originating purchase Transaction (EN0009) is re-pointed to the same target Campaign.
- Apply (success): a redemption-confirmation e-mail has been dispatched.
- Apply (failure): no state change; the Voucher and Transaction remain as they were.

## Traceability

Target SRVs:
- Document-Generation-&-Fulfilment
- Payment-Processing

EN entities:
- EN0013 Voucher — the redeemable instrument; central subject of both validate and apply operations
- EN0009 Transaction — the originating purchase payment; re-pointed to the target Campaign on redemption
- EN0004 Campaign — the redemption target; receives the re-attributed donation

Integration boundaries:
- SmartMailing (transactional e-mail dispatch on successful redemption)

Flow Evidence:
- FLW0018 (voucher apply / validate)

## Evidence Level

Confirmed — grounded in FLW0018 (Confirmed confidence) and the EN0013/EN0009/EN0004 entity drafts for Voucher, Transaction, and Campaign lifecycle facts; the duplicate-code and concurrent-redemption risks in AF3/AF4 are carried over from FLW0018's Failure Modes section and are marked Partial/Hypothesis as data-quality/concurrency observations rather than designed behavior.
