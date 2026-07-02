---
doc_id: FN0007
title: Donation & Payment Processing (Money Hub)
canonical_layer: FN
spec_type: functional-capability
status: draft
references:
  - UC0005
  - UC0006
  - UC0007
  - UC0008
  - UC0009
  - UC0010
  - EN0009
  - EN0004
  - EN0013
  - EN0010
  - EN0008
  - BR-PaymentAndMoneyIntegrity
---

# FN0007 – Donation & Payment Processing (Money Hub)

## Purpose

Own the donation/payment record (Transaction, EN0009) and everything that happens when it reaches
PAID — the domain money hub. Initiates payments, records gateway-confirmed status, and runs the
cascade of money-side effects (campaign recompute, overpayment split, recurring/voucher promotion,
role grant, confirmation messaging, indexing) that follows from every path that can bring a
Transaction to PAID — online checkout, gateway callback, recurring charge, bank/gateway
reconciliation, and voucher purchase/redemption.

## Responsibilities

- Create a Transaction (EN0009) when a donation/payment is initiated and carry the gateway
  correlation identifier, delegating the vendor call itself to FN0008.
- Record the confirmed external payment status (PENDING / AUTHORIZED / PAID / CANCELLED / REFUNDED)
  and the gateway fee, resolving the target Transaction from callback/return data.
- On the first transition to PAID: recompute the target Campaign (EN0004) raised total and trigger
  its completion (FN0006); split overpayment into a child Transaction against the transparent
  account; promote a linked Voucher (FN0011) and RecurringTransaction (FN0010); grant the owner the
  supporter role (FN0018); and trigger a thank-you confirmation (FN0019).
- Split overpayment into a child Transaction on the transparent account per the overpayment-split
  rule (BR-PaymentAndMoneyIntegrity), regardless of the confirming path.
- Serve as the shared PAID entry point for reconciliation-created Transactions (bank/AISP import and
  gateway-settlement matching, FN0012), recurring-charged Transactions (FN0010), and voucher-purchase
  Transactions (FN0011) alike — every path that confirms money received converges on the same
  recompute/split/promote cascade.
- Re-attribute a purchase Transaction to a new target Campaign when a Voucher (EN0013) tied to it is
  redeemed, so the donation total lands against the Campaign the recipient actually chose.
- Serve as the read-only source of a donor's paid-donation totals for a given year, consumed when
  issuing donation (tax) confirmations, without itself producing that document.

## Related Use Cases

UC0005 (Make a Donation — initiates the Transaction), UC0006 (Confirm Payment — gateway callback
lands here), UC0007 (Process Recurring Donation — child charges land here), UC0008 (Reconcile Bank
Transactions — bank/gateway-settlement Transactions land here), UC0009 (Redeem/Validate Voucher —
re-attributes the purchase Transaction on redemption), UC0010 (Issue Donation Confirmation — reads
paid-donation totals from here).

## Related Entities

EN0009 Transaction (root of this capability), EN0004 Campaign (funding target, recomputed on PAID),
EN0013 Voucher (promoted on PAID, re-attributes a Transaction on redemption), EN0010
RecurringTransaction (promoted/activated on PAID), EN0008 User (owner, granted the supporter role on
PAID).

## Integrations

None directly — the vendor gateway boundaries (ComGate, Netopia/MobilPay, MAIB) are isolated in
FN0008; bank/AISP and mailbox boundaries used for reconciliation are isolated in FN0012. See
ARCH0002 for the consolidated integrations landscape.

## Constraints

- The PAID cascade runs synchronously inside the entity save from every write path, non-
  transactionally, and re-entrant (nested campaign save); it has no callback idempotence, so
  repeated gateway notifications re-recompute Campaign totals and re-enqueue search indexing rather
  than being treated as a no-op.
- Payment-identity uniqueness is app-level only — there is no database key and no idempotency key on
  the Transaction record, which the reconciliation and gateway-callback paths both rely on for
  matching.
- Voucher code uniqueness is not enforced at the data level, so voucher-driven Transaction
  re-attribution (UC0009) can resolve to an arbitrary matching Voucher record when codes collide; a
  concurrent redemption race is also possible since the not-yet-redeemed check and the update are not
  guarded together — both are recorded risks, not designed behavior.
- The dormant Transaction-status event, which would otherwise drive campaign recommendation
  (FN0024), is disabled — the cascade described here happens only through the direct save-time path,
  never through event subscription.
