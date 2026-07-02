---
doc_id: BR-RecurringDonationPolicy
title: Recurring Donation Policy
canonical_layer: BR
spec_type: business-rule
status: draft
affects:
  - EN0010
  - EN0009
  - SYSTEM
references:
  - EN0010
  - EN0009
  - EN0004
  - UC0007
  - UC0006
---

# BR – Recurring Donation Policy

## Purpose

Governs the lifecycle of a recurring donation schedule: its activation dependency on the first paid
donation, periodic charging and due-selection, and the current-state optimistic-settlement and
double-charge risks that follow from that lifecycle.

---

## Schedule creation and activation

- A recurring schedule SHALL be created inactive alongside its first donation and SHALL depend on an
  originating donation — a schedule SHALL NOT exist without one.
- A recurring schedule SHALL activate (inactive to active) only when its originating donation reaches
  PAID, and this activation SHALL be idempotent.

---

## Periodic charging and due-selection

- Each periodic charge SHALL create a new child donation record derived from the schedule and SHALL
  enter it into the shared money-side processing.
- A schedule SHALL be selected for charging only when it is due by its configured day, is not
  cancelled, and the minimum interval since its last successful charge has elapsed.
- A successful charge SHALL advance the schedule's last-successful-charge timestamp; a failed or
  declined charge SHALL NOT advance it and SHALL NOT itself cancel or deactivate the schedule.

---

## Current-state settlement and concurrency risks

- Current-state: a charge SHALL NOT be assumed to reflect confirmed settlement — a charge is
  currently booked optimistically as PAID on a gateway call that completes without error, ahead of
  the gateway's asynchronous confirmation.
- Current-state: due-selection and charging SHALL NOT be assumed atomic — no claim or lock is held on
  a schedule while charging, so overlapping runs carry a double-charge risk guarded only by an
  application-level interval window.
- Current-state: whether cancelling a schedule also flips its active state to inactive is not
  established (a cancellation timestamp is written).

---

## Regional scope

- Current-state: recurring charging is gated per region by configuration; a confirmed periodic
  charging path SHALL NOT be assumed for the MD gateway.

---

## Non-Goals

This rule does not define the money-side processing applied to a donation once created (→
BR-PaymentAndMoneyIntegrity), nor the transactional messages sent on charge success/failure or
dunning (→ BR-TransactionalMessaging). It does not restate donation or schedule attributes (→ EN0009,
EN0010) or the step-by-step cron flow (→ UC0007, UC0006).
