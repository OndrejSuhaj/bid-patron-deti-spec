---
doc_id: EN0022
title: EmailArchive
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0001  # Application — email.application (required) → application
  - EN0004  # Campaign — email.campaign → campaign
  - EN0008  # User — email.user_id (author) + email.to_user_id (recipient)
---

# EN0022 — EmailArchive

## Description
Per-send archive of an outbound transactional email. One row is written for **every** recipient each time the mailing service dispatches a templated message, regardless of send outcome. Records the resolved to/from addresses, subject, rendered body, the template name and its serialized arguments, and links to the originating Application and Campaign. The transport is Mautic (despite the "SmartMailing" service naming).

## Entity Category
Content · Confidence: High
(Schema confirmed + heavy write usage: one insert per recipient on every dispatch across ~30 caller sites — FLW0019.)

## Origin
- DB artifacts: base_table `email`. `email.install` defines a **separate** `email_domain` table (update_8001) — NOT a schema for `email`; no hook_schema for `email` itself.
- Code touchpoints:
  - `email/src/Entity/EmailEntity.php` — entity; `preCreate:63` stamps `user_id`; `preSave:70-81` resolves `to_user_id` from `to` via user.mail lookup; `setError:102` defined.
  - `patron_base/src/APIMailingService.php:217-230` — `EmailEntity::create()->save()` per recipient (the single archiver).
Evidence: db-models.md `email`; FLW0019 (§C, one insert per recipient; §D archiving).

## Core Fields
- `name` (string 200; required; Subject; entity label)
- `to` / `from` (string 50 each; required; addresses — capped at 50 chars, long addresses truncate)
- `body` (text_long; optional; rendered body)
- `template_name` (string 50; required; template key mapped to a per-country Mautic email id)
- `arguments` (string_long; optional; serialized/JSON template args)
- `application` (er → EN0001 Application; **required**; "Lead")
- `campaign` (er → EN0004 Campaign; optional; "Příběh")
- `status` (boolean; publish flag; default TRUE)

## Technical Fields
- `user_id` (er → EN0008 User; optional; author — current user at create)
- `to_user_id` (er → EN0008 User; optional; recipient, auto-resolved in preSave from `to`)
- `sent` (timestamp; **defined but never written** — no `set('sent')` on email anywhere)
- `error` (string_long; `setError()` defined at :102 but **never called**)
- `created` / `changed` (timestamps)
Evidence: db-models.md `email`; FLW0019 failure-mode (no send-status write-back); grep confirms `setError` defined, uncalled, and no `set('sent')` on email.

## Relations
- `application` → EN0001 Application (required). Evidence: db-models.md; EmailEntity.php:243-249.
- `campaign` → EN0004 Campaign. Evidence: db-models.md.
- `user_id` → EN0008 User (author); `to_user_id` → EN0008 User (recipient, resolved by mail). Evidence: db-models.md; EmailEntity.php:70-81.

## Allowed Statuses
`status` boolean only (published, default TRUE). No sent/failed/suppressed state is recorded — the archive cannot distinguish delivered vs. failed vs. env-suppressed sends (see Lifecycle). Evidence: FLW0019 failure-mode.

## Lifecycle
- (none) → created/published per recipient on each dispatch (`APIMailingService::sendEmail` → `EmailEntity::create()->save()`). Confirmed (FLW0019; EN-lifecycle-evidence FLW0019).
- After create: `sent`/`error` are never updated; actual send is gated by environment (prod / allow-list) but the archive row is written either way. Confirmed (FLW0019: "email (none) → created/published, `sent`/`error` never written afterwards").

## Spec Alignment
N/A — No EN spec files found in repository.

## Open Questions
1. `sent`/`error` fields exist but are dead — is send-status tracking a planned-but-abandoned feature (target-state candidate)?
2. `to`/`from` capped at 50 chars truncates long addresses — data-integrity risk; intended?
3. `application` is validation-required but the table has no DB NOT NULL, and callers can pass empty `application` (FLW0019) — is an empty-application archive row valid?
4. No idempotency key — re-invocation (e.g. entity postSave loops) re-archives and re-sends. Acceptable?
