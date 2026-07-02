---
doc_id: BR-PaymentAndMoneyIntegrity
title: Payment & Money Integrity
canonical_layer: BR
spec_type: business-rule
status: draft
affects:
  - EN0009
  - EN0004
  - EN0008
  - SYSTEM
references:
  - EN0009
  - EN0004
  - EN0008
  - UC0005
  - UC0006
---

# BR – Payment & Money Integrity

## Purpose

Governs the integrity of the money record (Transaction, EN0009) and the effects of a payment
reaching PAID: overpayment splitting, single-use money side effects, and the current-state absence
of payment idempotency and uniqueness guarantees.

## Money record admissibility and identity (current-state)

- The System SHALL reject a donation submitted against a Campaign (EN0004) whose running raised
  total already meets or exceeds its target amount.
- Current-state: the System SHALL NOT be assumed to enforce database-level uniqueness on the gateway
  message identifier used to match a callback to its Transaction (EN0009); this identity check is
  enforced only at the application level — an evidenced race exposure under concurrent callbacks, not a
  guarantee of exactly-once callback-to-Transaction resolution. (Repeated or out-of-order confirmations
  otherwise converge on the same Transaction — see UC0006 AF2 — rather than creating duplicate records.)

## Overpayment split

- When a paid Transaction (EN0009) causes its Campaign's (EN0004) running raised total to exceed the
  target amount, the System SHALL split the excess into a child Transaction booked to the
  transparent/collection account, linked to the originating Transaction as its parent, so that the
  Campaign's raised total does not exceed its target amount.
- The overpayment-split child Transaction SHALL carry no gateway fee and SHALL be flagged as a
  transparent-account movement.

## Effects on first transition to PAID

- On a Transaction's (EN0009) first transition to PAID, the System SHALL: recompute the target
  Campaign's (EN0004) funding, promote a linked recurring schedule and a linked voucher, grant the
  Transaction owner (EN0008) the supporter role, and trigger a paid-donation confirmation message.
- A paid-donation confirmation message SHALL be sent at most once per Transaction.
- Current-state: the PAID side-effect cascade SHALL NOT be assumed transactional, callback-idempotent,
  or non-re-entrant — repeated confirmations for the same Transaction currently re-run the Campaign
  funding recomputation and re-enqueue related side effects rather than being treated as a no-op.

## Non-Goals

This rule does not define the gateway callback authentication or gateway-status-to-domain-status
mapping (see BR-PaymentGatewayCallbacks), Campaign completion/uncompletion/funded-rejection lifecycle
rules beyond money admissibility (see BR-CampaignStoryLifecycle), recurring-schedule activation
mechanics (see BR-RecurringDonationPolicy), voucher promotion/redemption mechanics (see
BR-VoucherPolicy), supporter-role grant mechanics (see BR-AccessControlAndRoles), or transactional
message send-gating in general (see BR-TransactionalMessaging).
