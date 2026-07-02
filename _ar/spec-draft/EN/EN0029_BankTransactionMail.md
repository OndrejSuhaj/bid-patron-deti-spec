---
doc_id: EN0029
title: BankTransactionMail
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0009  # Transaction — produced or updated from the same inbound notification
  - EN0008  # User — owner of the audit record
  - BR-BankReconciliationAndMatching
  - UC0008  # Reconcile Bank Transactions (sub-flow UC0008.2 — bank notification e-mail import)
---

# EN0029 — BankTransactionMail

## Purpose

Audit record of an inbound bank-notification ("aviz") e-mail handled during bank reconciliation.
It captures that a notification message was processed, not the payment itself — the payment is
represented by a Transaction (EN0009). One BankTransactionMail exists per handled notification
message, whether or not that message produced a Transaction.

---

## Lifecycle

- Recorded — the only state; the entity is append-only.

---

## State Transitions

None. BankTransactionMail has a single, terminal state: once recorded it is never updated or
transitioned further.

- (created) → Recorded
  trigger: UC0008 (sub-flow UC0008.2 — bank notification e-mail import)

---

## Attributes

### System-managed attributes

- Owner (reference to EN0008 – User; optional) — party associated with the audit record.
- Received at (datetime; required) — time the notification message was received.

### User-provided attributes

None — the record is generated entirely from the inbound notification message; it has no
user-provided attributes.

---

## Invariants

- See BR-BankReconciliationAndMatching — one audit record is written per processed
  bank-notification message, regardless of outcome.
- BankTransactionMail does not itself carry a stored reference to the Transaction (EN0009) it may
  have produced; correlation between the two is external (see Open Questions).

---

## Relationships

- EN0008 – User (owner of the audit record)
- EN0009 – Transaction (the notification may produce or update a Transaction in the same
  reconciliation flow — UC0008.2; this is a behavioral association, not a stored reference)

---

## Open Questions

1. Conflict — whether the notification's subject text is reliably persisted on the record is
   uncertain (a field-naming mismatch was observed in the source evidence between the value being
   set and the field defined for storage).
2. There is no stored link from a BankTransactionMail record back to the Transaction (EN0009) it
   produced; reconciling one to the other relies on external correlation (e.g. variable symbol or
   message identifier) rather than an entity relationship.
3. Records are written even when parsing the notification fails, per the failure mode described in
   BR-BankReconciliationAndMatching — it is unconfirmed whether failed and successful imports are
   distinguishable on the record itself.
