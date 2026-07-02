---
doc_id: EN0013
title: Voucher
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0009  # Transaction — the purchasing payment (derives owner)
  - EN0004  # Campaign (Story) — the story a voucher is applied to
---

# EN0013 — Voucher

## Description
Gift voucher ("Dobrošek") — a prepaid donation code bought via a `transaction` (EN0009) and later applied to a Story (EN0004) by a recipient. Two lifecycle dimensions: `status` marks it paid/ready-to-use (set when the purchasing payment is PAID), and `is_applied` marks whether the recipient has redeemed it against a campaign. Owner is derived from the purchasing transaction, not stored directly.

## Entity Category
Persisted · Confidence: High

## Origin
- DB artifacts: base_table `voucher` (content, not revisionable, not translatable; `voucher.install` is data migrations only, no `hook_schema`).
- Code touchpoints: `VoucherEntity`; promoted on PAID by `TransactionEntity::updateVoucherStatus`; multi-voucher generation via `generateMultipleVouchers`; redeemed via `VoucherApplyResource`.
Evidence: [voucher/src/Entity/VoucherEntity.php](../../intake/current-solution/_source/patronus/web/modules/custom/voucher/src/Entity/VoucherEntity.php); db-models.md `voucher` (Verification: Confirmed).

## Core Fields
- name (string 50; required; voucher code + entity label; **no unique key** declared)
- price (integer; voucher value "Hodnota" in CZK)
- campaign (reference → EN0004; the Story it is applied to; set at redemption)
- transaction (reference → EN0009; the purchasing payment; `getOwner()` derives owner via transaction→user_id)
- recipient_name (string 50) / recipient_email (string 50, plain string) / user_phone (string 13) / recipient_message (string_long)
- delivery_type (list_string; email / print; default email)

## Technical Fields
- status (boolean; default FALSE; 0 = unpaid, 1 = paid/"Ready to use" — L371-373)
- is_applied (boolean; default FALSE; 0 = not redeemed, 1 = redeemed — L269-271)
- applied (timestamp; set at redemption) · expiration / reminded (timestamp; lifecycle)

## Relations
- transaction → EN0009 (Transaction; purchasing payment, owner source)
- campaign → EN0004 (Campaign; redemption target)
- user_id → EN0008 (User; author/default — nominal, real owner derived from transaction)

## Allowed Statuses
Two booleans, not an enum:
- `status`: 0 (unpaid) / 1 (paid, ready to use)
- `is_applied`: 0 (not redeemed) / 1 (redeemed)
Evidence: `VoucherEntity` L371-373 (status default FALSE), L269-271 (is_applied default FALSE); `TransactionEntity::updateVoucherStatus` L806-819.

## Lifecycle
Confirmed:
- status 0 (unpaid) → 1 (paid) when purchasing EN0009 transaction reaches PAID; `applied` timestamp and buyer e-mail/Slack fire in the same step — `TransactionEntity::updateVoucherStatus` L806-819 (FLW0018/03).
  Note: the load filter targets `status=0, is_applied=0` and sets `status=1`, `applied=time()`; the field comment `// payed` marks `status` as the paid flag.
- paid & not-redeemed (`is_applied=0`) → redeemed (`is_applied=1`, `applied=time()`, `campaign` set) at apply — `VoucherApplyResource` L116-127 (FLW0018).

## Spec Alignment
N/A — No EN spec files found in repository.

## Open Questions
1. `applied` timestamp is written both at PAID-promotion and at redemption — which is authoritative for "redeemed on" reporting?
2. Voucher code (`name`) has no DB unique key — is uniqueness guaranteed anywhere at generation?
3. `expiration`/`reminded` fields exist — is there an expiry/reminder job? (not evidenced in mined flows). Missing evidence.
