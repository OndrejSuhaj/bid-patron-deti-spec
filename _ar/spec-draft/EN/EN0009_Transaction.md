---
doc_id: EN0009
title: Transaction
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0004  # Campaign (Story) — donation target
  - EN0008  # User — owner / donor
  - EN0010  # RecurringTransaction — subscription schedule promoted from a paid txn
  - EN0013  # Voucher — Dobrošek promoted from a paid txn
---

# EN0009 — Transaction

## Description
Core payment / donation record. Every incoming money movement (one-off donation, corporate gift, voucher purchase, recurring child charge, bank/AISP import) is a `transaction`. Its `preSave`/`postSave` is the money-side hub of the domain: on save it recomputes the target campaign, splits overpayments, promotes recurring/voucher records, sends buyer e-mail + Slack, and enqueues Elasticsearch indexing.

## Entity Category
Persisted · Confidence: High

## Origin
- DB artifacts: base_table `transaction` (content, not revisionable, not translatable, source *mixed* — updates 8001–8004, no `hook_schema`); 3 declared indexes in `TransactionEntityStorageSchema`.
- Code touchpoints: `TransactionEntity` (866 LOC) — `preSave`/`postSave`, `updateRecurringStatus`, `updateVoucherStatus`; gateway resources/controllers `v32/TransactionResource`, `comgate` `TransactionStatusUpdate`, `NetopiaConfirmController`, `MaibController`, cron `ComgateCron`/`NetopiaCron`; imports `MonetaAPI`, `accounting/BankForm`.
Evidence: [transaction/src/Entity/TransactionEntity.php](../../intake/current-solution/_source/patronus/web/modules/custom/transaction/src/Entity/TransactionEntity.php); db-models.md `transaction` (Verification: Confirmed).

## Core Fields
- price (integer; optional; donation amount) · original_price (integer; set from `price` on create)
- ext_status (list_string; optional; values: PENDING / PAID / CANCELLED / AUTHORIZED / REFUNDED — Evidence: `TransactionEntity` L456-460)
- ext_fee (decimal 10,2; gateway fee) · method (string 50; payment method) · type (list_string; corporate / owner)
- campaign (reference → EN0004; donation target Story) · original_campaign (reference → EN0004)
- ext_trans_id (string 40; gateway id) · message_id (string 40; app-level unique — `preSave` throws, no DB key)
- comment (string 200) · vouchers_data (string_long; JSON of voucher values, drives voucher generation)

## Technical Fields
- parent (reference → EN0009 self; overpayment-split / divided child transactions)
- bank_date / bank_month (int, derived from bank_date) / bank_vs (12) / bank_account (50) — bank reconciliation
- flags (boolean): is_donation (default TRUE), is_voucher, is_recurring, is_sent_to_bank, is_email_sent, is_embedded, is_authenticated, test, transparent
- ip_address (20, ReadOnly) / user_agent (250, ReadOnly); status (boolean; publish flag)

## Relations
- campaign → EN0004 (Campaign) · original_campaign → EN0004
- user_id → EN0008 (User; owner/donor)
- parent → EN0009 (self; split transactions)
- Promotes/updates: EN0010 (RecurringTransaction), EN0013 (Voucher) — outbound side effects, not FK fields on this entity

## Allowed Statuses
`ext_status`: PENDING, PAID, CANCELLED, AUTHORIZED, REFUNDED.
Evidence: `TransactionEntity` L456-460 (allowed_values); L161/168 (isPaid/isCancelled read `ext_status`).

## Lifecycle
Confirmed transitions (per FLW dossiers + code):
- (create) → PENDING with `ext_trans_id` from gateway — `v32/TransactionResource` L183/190/254/310 (FLW0006).
- PENDING/AUTHORIZED → PAID | CANCELLED | REFUNDED (ComGate) — `comgate TransactionStatusUpdate::update_status` (FLW0003); Netopia IPN action map `NetopiaConfirmController` L70-141 (FLW0004); MAIB re-poll `MaibController` L60-72 (FLW0005).
- (import) none → created PAID — Moneta AISP `MonetaAPI` L120/139-140 (FLW0011); bank IMAP `BankForm` L285-309 (FLW0012).
- reconciled (`bank_date`/`bank_month`, `is_sent_to_bank 0→1`) — `BankForm` L137-147 (FLW0012); `ComgateSyncCommand` L204-206 raw SQL (FLW0013).
- `is_email_sent` false→true on first PAID — L612-624/760 (FLW0004).
- overpayment split → new child transaction to transparent account — `postSave` L663-689 (FLW0003/04/05/07).
On PAID, side-effects promote EN0010 (`updateRecurringStatus` L703-711) and EN0013 (`updateVoucherStatus` L806-819).

## Spec Alignment
N/A — No EN spec files found in repository.

## Open Questions
1. Is REFUNDED reachable from PAID, or only via gateway callback? (enum present; refund path not deep-mined.)
2. AUTHORIZED→PAID capture path — where is capture triggered outside recurring cron?
3. `message_id` uniqueness is app-level only (no DB key) — race exposure under concurrent callbacks.
