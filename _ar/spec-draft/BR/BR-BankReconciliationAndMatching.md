---
doc_id: BR-BankReconciliationAndMatching
title: Bank & Gateway Reconciliation / Matching
canonical_layer: BR
spec_type: business-rule
status: draft
affects:
  - EN0009
  - EN0029
  - EN0030
  - EN0004
  - SYSTEM
references:
  - EN0009
  - EN0029
  - EN0030
  - EN0004
  - UC0008
---

# BR – Bank & Gateway Reconciliation / Matching

## Purpose

Governs how bank and gateway settlement is matched to money records (Transaction, EN0009) and how
unattributed credits are booked, and records the current-state CZ-only scope and lossy-matching
risks of that matching.

## Matching and booking

- A settled credit SHALL be matched to an existing money record (EN0009) by its bank reference or
  variable symbol; a previously-unseen credit SHALL be booked as a new paid money record attributed
  to the transparent collection Campaign (EN0004).
- A gateway-settlement match SHALL set the variable symbol and the bank-settled marker on the
  matched money record (EN0009).
- One audit record (EN0029) SHALL be written per processed bank-notification message, regardless of
  outcome.

## Scope (current-state)

- Current-state: reconciliation SHALL NOT be assumed to run for RO or MD — the reconciliation
  sources are CZ-only (UC0008).
- Current-state: each reconciliation source SHALL be guarded against double-processing within its
  own run cadence.

## Current-state matching risks

- Current-state: the daily transparent-account poll marks its last-run before fetching and always
  queries the prior day, so a failed run silently skips that day's credits with no retry.
- Current-state: bank-notification parsing depends on a fixed message layout and can create a
  record from incomplete fields on layout drift rather than rejecting the message.
- Current-state: the gateway transfer-sync caps how many records it updates per run, so a
  settlement split across more records than the cap leaves the remainder unmarked until a later
  run.

## Non-Goals

This rule does not define the Transaction (EN0009) payment-status lifecycle or the overpayment-split
mechanics (see BR-PaymentAndMoneyIntegrity, which owns the "raised does not exceed target" rule
that a reconciliation-created paid record also feeds into), or the Campaign (EN0004) funding/
completion rules triggered once a reconciled money record is booked (see BR-CampaignStoryLifecycle).
It defines only how settlement data is matched, attributed, and audited.
