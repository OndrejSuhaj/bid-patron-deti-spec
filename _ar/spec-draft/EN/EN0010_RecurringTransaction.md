---
doc_id: EN0010
title: RecurringTransaction
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0009  # Transaction — the originating / linked payment
---

# EN0010 — RecurringTransaction

## Description
Recurring-payment schedule and gateway token for a repeating donation ("recurring" / subscription). Created (inactive) alongside the first payment and activated when that payment is confirmed PAID; a scheduled cron then charges it periodically. Holds the gateway token, charge period, day-of-month, and last-charge / cancellation timestamps.

## Entity Category
Persisted · Confidence: High

## Origin
- DB artifacts: base_table `transaction_recurring` (content, not revisionable, not translatable; no `hook_schema`).
- Code touchpoints: `TransactionRecurringEntity`; created in `v32/TransactionResource`; activated by `TransactionEntity::updateRecurringStatus`; charged by `ComgateCron`/`NetopiaCron`; token set by `NetopiaConfirmController`.
Evidence: [transaction_recurring/src/Entity/TransactionRecurringEntity.php](../../intake/current-solution/_source/patronus/web/modules/custom/transaction_recurring/src/Entity/TransactionRecurringEntity.php); db-models.md `transaction_recurring` (Verification: Confirmed).

## Core Fields
- name (string 50; required; entity label)
- price (integer; optional; recurring contribution "Příspěvek")
- transaction_id (reference → EN0009; the linked payment — the ONLY relation)
- period (string 50; recurring period) · payment_provider (string 50)
- day (integer, tiny unsigned; day-of-month to charge)
- status (boolean; 0 = inactive, 1 = active — see Allowed Statuses)

## Technical Fields
- token_id (string 150; payment token)
- token_expiration_date (datetime; required; "Deadline pro získání peněz" — RO)
- last_recurring_payment (timestamp; last successful charge) · canceled (timestamp; cancellation)

## Relations
- transaction_id → EN0009 (Transaction) — sole relation

## Allowed Statuses
Boolean `status`: 0 (inactive, at create) / 1 (active). No enum; the two states are a boolean.
Evidence: created `status=0` — `v32/TransactionResource` L206 (FLW0006); set to 1 — `TransactionEntity::updateRecurringStatus` L703-711.

## Lifecycle
Confirmed:
- (create) → status 0 (inactive) — `v32/TransactionResource` L206 (FLW0006).
- 0 → 1 (activated) when linked EN0009 transaction reaches PAID — `TransactionEntity::updateRecurringStatus` L703-711 (idempotent: returns if already active) (FLW0003/04/05).
- token_id / token_expiration set from IPN (RO) — `NetopiaConfirmController` L157-163 (FLW0004).
- due → charged (`last_recurring_payment=now`) on cron success — `ComgateCron` L93-94; `NetopiaCron` L83-84 (FLW0007).
Cancellation writes `canceled` timestamp — Hypothesis (field present; cancel code path not deep-mined). Missing evidence.

## Spec Alignment
N/A — No EN spec files found in repository.

## Open Questions
1. What sets `canceled` and does it also flip `status`→0? (transition not evidenced in mined flows).
2. `period` is a free string(50) — what discrete values occur (monthly only?)?
3. Only Netopia (RO) sets a token; is ComGate recurring token-less (charge via linked txn only)?
