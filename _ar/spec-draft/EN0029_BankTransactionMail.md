---
doc_id: EN0029
title: BankTransactionMail
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0009  # Transaction (produced from the parsed aviz)
  - EN0008  # User (owner)
---

# EN0029 — BankTransactionMail

## Description
Audit record of an inbound bank-notification ("aviz") e-mail processed by the IMAP importer. Each handled
message that produced (or attempted) a bank-to-bank donation Transaction leaves one `transaction_mails`
row capturing the message's subject, sender, and attachment filename plus receipt time. It is an
import-trail record, not the payment itself (the payment is a Transaction, EN0009).

## Entity Category
Persisted · Confidence: Medium

## Origin
- DB artifacts: base_table `transaction_mails` (content entity; not revisionable; not translatable; source *mixed*; no `hook_schema`)
- Code touchpoints:
  - `bank_integration/src/Entity/TransactionMailsEntity.php` — entity + `baseFieldDefinitions()`
  - `bank_integration/src/Controller/BankIntegrationPageController::logTransactionMails()` — persists one row per handled aviz mail
Evidence: db-models.md `transaction_mails`; FLW0012 §B step 12 + §C (Entities Written), §D (`logTransactionMails` `:112`, `:133-142`).

## Core Fields
- `subject` (string 255) — mail subject (aviz matched only when subject `=== 'Přišly peníze'`)
- `mailFrom` (string 50) — sender address
- `filename` (string 50) — attached filename
- `status` (boolean) — published flag (inherited boilerplate)
Evidence: db-models.md `transaction_mails` field table; FLW0012 §B step 3 (subject match).

## Technical Fields
- `user_id` (entity_reference → User EN0008) — owner (EntityOwnerTrait).
- `created` (created) — "the time the mail received".

## Relations
- `user_id` → User (EN0008)
- Import-produces: Transaction (EN0009) — the aviz drives `TransactionEntity::create(...)` in the same flow (logical, not a stored reference).

## Allowed Statuses
`status` boolean = published flag only (inherited boilerplate); no workflow states.
Evidence: db-models.md — `status` is the publish flag; entity_keys `label`=`name` and `setSubject()` writes `name` while only `subject` is defined → latent label/field mismatch (`Conflict`).

## Lifecycle
Append-only import audit — created once per handled aviz mail during the CZ-only IMAP cron; never updated
or transitioned. The Transaction it triggers has its own lifecycle (EN0009); this row is created-only.
Evidence: FLW0012 §B step 12 (one audit row per handled mail); no update/delete path evidenced (created-only).

## Spec Alignment
N/A — No EN spec files found in repository.

## Open Questions
1. `setSubject()` writes to `name` (undefined field) while `subject` is the defined field — is the recorded subject actually persisted? (db-models `Conflict`.)
2. No stored link back to the produced Transaction — reconciliation between an aviz row and its Transaction relies on external correlation (VS/message_id) only.
3. Rows are written even when parsing fails (blank fields per FLW0012 failure mode) — are failed imports distinguishable from successful ones?
