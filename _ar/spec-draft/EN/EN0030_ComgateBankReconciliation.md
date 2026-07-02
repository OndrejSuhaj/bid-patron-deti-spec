---
doc_id: EN0030
title: ComgateBankReconciliation
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0009  # Transaction — the money record the settlement logically reconciles
  - EN0008  # User — owner of the settlement record
  - BR-BankReconciliationAndMatching
  - UC0008  # Reconcile Bank Transactions
---

# EN0030 — ComgateBankReconciliation

## Purpose

Represents an accounting-side record of a gateway-to-bank settlement, created when an accountant
manually books the transfer of payment-gateway funds into the bank account. It exists to give
accounting bookkeeping its own record of a settlement event, distinct from the money records
(Transaction, EN0009) that the settlement actually reconciles.

The entity itself carries no settlement payload (amount, gateway payout identifier, date range,
or a link to the reconciled Transactions) — see Open Questions. The reconciling effect (marking
Transactions as bank-settled) is applied directly to Transaction (EN0009) records and is not
mediated by this entity; see BR-BankReconciliationAndMatching for the matching/booking rule and
UC0008 for the reconciliation use case.

---

## Lifecycle

- Created
- Published / Unpublished (a simple visibility flag; not a workflow state)

No further lifecycle states are evidenced.

---

## State Transitions

(none) → Created
trigger: UC0008 (manual settlement recording, sub-flow UC0008.3 boundary — see Relationships and
Open Questions; the record's own creation is a manual accounting action, not an automated step of
UC0008.3 itself)

Created → Published / Unpublished
trigger: not evidenced as a distinct transition; the published flag is set at creation (default:
Published) with no confirmed update path.

No further transitions (e.g. archival, deletion) are evidenced.

---

## Attributes

### System-managed attributes

- Owner (reference to EN0008 – User; required; defaults to the current user at creation time)
- Created timestamp (datetime; required)
- Last-changed timestamp (datetime; required)

### User-provided attributes

- Label (text; optional; short free-text name for the settlement record)
- Published (boolean; required; default: Published; visibility flag with no further workflow meaning)

---

## Invariants

- See BR-BankReconciliationAndMatching for how a gateway settlement is matched and booked against
  Transaction (EN0009) — that rule governs the reconciliation effect, not this entity's own fields.
- No invariant beyond entity-standard field presence is evidenced for this entity's own attributes.

---

## Relationships

- EN0008 – User (owner of the settlement record)
- EN0009 – Transaction (logically reconciled by the settlement this entity records; no attribute
  on this entity links it to the specific Transactions it covers — see Open Questions)

---

## Open Questions

1. Evidence for this entity's own data is limited to owner, label, and the published flag — what
   settlement payload (amount, gateway payout identifier, date range) the recording action actually
   captures, and whether it is stored on this entity or only applied to Transaction (EN0009), is
   unresolved.
2. No attribute traces this entity to the specific Transaction(s) it reconciles — how a settlement
   record is associated with the payments it covers is unresolved.
3. Whether this entity is an audit stub accompanying a separate reconciliation effect on Transaction,
   or whether the recording action stores richer data not reflected in canonical evidence, is
   unresolved — Conflict/Uncertain, not resolved by this canonicalization pass.
