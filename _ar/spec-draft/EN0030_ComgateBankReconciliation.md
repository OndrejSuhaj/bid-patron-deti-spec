---
doc_id: EN0030
title: ComgateBankReconciliation
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0009  # Transaction (settled/reconciled)
  - EN0008  # User (owner)
---

# EN0030 — ComgateBankReconciliation

## Description
Record produced by the manual accounting "ComGate → bank" settlement form, used to reconcile ComGate
gateway payouts against the bank. The stored entity itself is minimal (owner + label + publish flag);
the actual reconciliation writes (`bank_vs`, `is_sent_to_bank=1`) land on Transaction rows (EN0009),
not on this entity. Modelled as the settlement's own record for accounting bookkeeping.

## Entity Category
Persisted · Confidence: Medium

## Origin
- DB artifacts: base_table `transaction_comtobank` (content entity; not revisionable; not translatable; module has **no** `.install` → no `hook_schema`)
- Code touchpoints:
  - `accounting/src/Entity/TransactionComToBankEntity.php` — entity + `baseFieldDefinitions()`
  - Produced by `accounting/src/Form/ComgateToBankForm.php` and `TransactionComToBankEntityForm.php` (manual accounting form, FL032)
Evidence: db-models.md `transaction_comtobank`; FLW0013 "Not in scope" note (explicitly: this entity is written by `ComgateToBankForm`, **not** by `comgatesync`).

## Core Fields
- `name` (string 50; default `''`) — entity label
- `status` (boolean; default TRUE) — published flag
Evidence: db-models.md `transaction_comtobank` field table (minimal entity — all storage Drupal-generated).

## Technical Fields
- `user_id` (entity_reference → User EN0008) — owner; default current user.
- `created` / `changed` (created / changed).

## Relations
- `user_id` → User (EN0008) — the only declared relation.
- Logically settles: Transaction (EN0009) — the settlement acts on `transaction` rows (`bank_vs`, `is_sent_to_bank`), but no stored reference links this entity to those Transactions.

## Allowed Statuses
`status` boolean = published flag only (default TRUE); no workflow states.
Evidence: db-models.md — minimal entity, `status` is the publish flag.

## Lifecycle
Created via the manual accounting settlement form; created-only from a lifecycle standpoint (no state
machine, no update/delete path evidenced). The reconciliation *effect* is on Transaction rows, whose
lifecycle is owned by EN0009.
Evidence: db-models.md (minimal fields, no state field); FLW0013 confirms the reconciliation UPDATE targets `transaction`, not this entity. Created-only.

## Spec Alignment
N/A — No EN spec files found in repository.

## Open Questions
1. This entity has **almost no field evidence** (only owner/name/status/timestamps) — what settlement payload (amounts, ComGate payout id, date range) does `ComgateToBankForm` actually persist, and where (on this entity, or only on `transaction`)?
2. No stored link to the reconciled Transactions — how is a settlement record traced back to the payments it covers?
3. Is `transaction_comtobank` an audit stub while the real work is the raw-SQL `transaction` UPDATE, or does the form store richer data not reflected in `baseFieldDefinitions()`?
