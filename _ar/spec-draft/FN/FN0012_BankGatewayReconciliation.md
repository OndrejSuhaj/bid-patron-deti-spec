---
doc_id: FN0012
title: Bank & Gateway Reconciliation / Matching
canonical_layer: FN
spec_type: functional-capability
status: draft
references:
  - UC0008
  - EN0009
  - EN0029
  - EN0030
  - EN0004
---

# FN0012 – Bank & Gateway Reconciliation / Matching

## Purpose

Keep Transaction (EN0009) records aligned with real-world bank/gateway settlement: import bank
credits that were not initiated through the online payment flow, and mark gateway-initiated
payments as confirmed-settled to the bank account, so that Campaign (EN0004) totals and donor
confirmations reflect actual received money. Clusters three CZ-only reconciliation source adapters
— a transparent-account bank API poll, a bank-notification mailbox import, and a payment-gateway
transfer-list sync — into one matching/reconciliation capability, distinct from the gateway
confirmation handling owned by FN0008 and the money-side-effect hub owned by FN0007.

---

## Responsibilities

The capability is responsible for:

- Polling the CZ transparent-account bank API (Moneta AISP) on a daily cadence for incoming
  credits, matching each against existing Transactions by bank reference, and creating new paid
  Transactions attributed to the platform's transparent collection Campaign for previously-unseen
  credits.
- Importing bank payment-notification e-mails (aviz) from a client mailbox, parsing the payment
  details out of the message body, and normalizing them into the same internal matching format
  used elsewhere in this capability.
- Branching each normalized bank-notification line between a gateway-settlement match (updating an
  existing Transaction as bank-settled) and a new bank-to-bank donation (creating a new Transaction),
  and recording one audit entry (EN0029, BankTransactionMail) per handled message regardless of
  outcome.
- Syncing the payment gateway's (ComGate) transfer/settlement list: matching by the gateway
  transaction identifier and setting the variable symbol and bank-settled flag on existing
  Transactions, bounded by a per-run match cap.
- Identifying the paying donor for a newly-matched credit — by a prior Transaction from the same
  source account, or by an e-mail marker present in the notification — so the created Transaction
  can carry an owner.
- Recomputing the affected Campaign's raised total whenever a Transaction is created or reconciled
  by this capability, and handing every resulting paid Transaction to the money hub (FN0007) for
  its shared downstream side effects.
- Enforcing per-source run guards (idempotent daily import, production/CZ-only gating) so each
  source is not double-processed within its own run cadence.

---

## Related Use Cases

UC0008 – Reconcile Bank Transactions

---

## Related Entities

EN0009 – Transaction
EN0029 – BankTransactionMail
EN0030 – ComgateBankReconciliation
EN0004 – Campaign

---

## Integrations

- Moneta — CZ transparent-account bank, account-information (AISP) API polled for incoming credits.
- Client bank-notification mailbox — IMAP inbox holding payment-notification ("aviz") e-mails.
- ComGate — CZ payment gateway, transfer-list/transfer-detail settlement API used to confirm which
  gateway payments have settled to the bank account.

Named per ARCH0002_ContextInteractionMap's C5 (Finance & Reconciliation) integration landscape and
the reconciliation source adapters recorded in SRV-target-list.md; no ES-layer artifacts exist yet
for these boundaries.

---

## Constraints

- CZ-only: none of the three reconciliation sources run for RO/MD.
- The Moneta daily source stamps its last-run marker before fetching and always queries "yesterday";
  a failed run is not retried and the missed day's credits are silently skipped (recorded gap, not a
  corrected behavior).
- A bank credit denominated outside the expected currency halts the remainder of that day's Moneta
  batch rather than being skipped in isolation.
- Bank-notification parsing depends on a fixed message layout; on template drift it can still create
  a Transaction or audit record from incomplete/blank fields rather than rejecting the message
  (fragile-parsing risk).
- The ComGate transfer-sync match caps how many Transaction rows it updates per run; a settlement
  split across more rows than the cap leaves the remainder unmarked until a later run (partial
  reconciliation).
- An unmatched ComGate-settlement candidate found via the bank-mail source is left unread for retry
  only through that same source's next pass — the ComGate transfer-sync source does not itself retry.
- Every Transaction created or updated by this capability enters the full non-transactional
  money-hub side-effect chain (FN0007) — campaign recompute, overpayment split, notifications,
  indexing — with the same lack of atomicity as any other Transaction write.
- Automatic (cron) scheduling of the ComGate transfer-sync source is Hypothesis — its manual/CLI
  trigger is Confirmed, per UC0008's evidence-level note.
