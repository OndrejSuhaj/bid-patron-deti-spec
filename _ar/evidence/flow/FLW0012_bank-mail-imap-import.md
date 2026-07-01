# FLW0012 — Bank notification e-mail IMAP import
> AR:FlowMiner dossier · 2026-07-01 · source FlowID FL030 · see [../flow-index.md](../flow-index.md)

## A. Header
- FlowID: FL030 (dossier FLW0012)
- Flow Name: Bank notification e-mail IMAP import
- Primary SRV: SRV0009
- Trigger Evidence: `hook_cron` — `bank_integration.module:bank_integration_cron()` → `BankIntegrationPageController::getMailFromServerHandle()` (`web/modules/custom/bank_integration/src/Controller/BankIntegrationPageController.php`)
- Confidence Level: Confirmed

## B. Behavior Digest
- Trigger: Drupal cron. `bank_integration_cron()` runs `getMailFromServerHandle()` **only when** `Settings::get('environment') === 'production'` AND `Settings::get('country') === 'cz'` (`bank_integration.module:15-22`). No UI/CLI entry for this handler (routing.yml exposes only entity CRUD, not the importer).
- Preconditions:
  - IMAP credentials present in `Settings::get('imap')` (`hostname/port/flags/user/pass`) — `BankIntegrationPageController::connectImap():200-218`. Config is environment-only; no settings file in scrubbed source (`grep 'imap'` matches only the controller). `Hypothesis` on exact host (Office 365 per docblock comment at :198).
  - Sender bank alias mailbox reachable; aviz e-mails delivered from `example@example.com` (redacted address literal at :47) with subject exactly `Přišly peníze` (:57).
- Main Steps (ordered, each with evidence):
  1. `connectImap()` opens `Ddeboer\Imap\Server->authenticate(user,pass)` (`:204-210`). On failure only logs + STDOUT, sets `$_connection` falsy but **does not abort** (:212-217).
  2. `handleMailsFromMoneta()` selects `INBOX`, builds `SearchExpression` of `Unseen` + `From('example@example.com')`, fetches messages (`:44-48`). Early return if none (:50).
  3. Per message: read subject; process only if subject `=== 'Přišly peníze'` (:57). Non-matching Unseen mails are left untouched (not marked read).
  4. Parse HTML body via `DOMDocument` + `DOMXPath` against fixed table cell XPaths keyed on an inline `style` attribute (`:60-93`): extracts `odeslano` (date), `castka` (amount, spaces stripped), `variabilni_symbol`, `nazev_protiuctu`, optional `email` (regex from `DOM-AVIZO:` marker), `popis`, `cislo_protiuctu`, `banka_protiuctu`.
  5. `dataTransToCSV($htmlData)` (`:151-185`) synthesizes a bank-statement CSV row: **hardcodes own account `57574646/0600` / IBAN `CZ7606000000000057574646`, `mena=CZK`, `typ_tranzakce='Příkaz k úhradě'`** and iconv-encodes every field UTF-8→Windows-1250 (mirrors the manual `bank_form` CSV upload format so the same parser can be reused).
  6. Appends `TransactionEntity::parseMessageId($message->getId())` as the last CSV column = idempotency key (`:96`; parser `transaction/src/Entity/TransactionEntity.php:580-584`).
  7. `new BankForm(); $status = $bankForm->createTransactionBank($csvData)` (`:97-98`) — reuses the manual import path (`accounting/src/Form/BankForm.php:88-122`).
  8. `createTransactionBank()` recomputes amount/date/VS/type from the row; only proceeds when `castka>0 && typ=='Příkaz k úhradě'`, then calls `updateTransaction()` (`BankForm.php:117-121`).
  9. `updateTransaction()` (`BankForm.php:127-172`): entityQuery `transaction` by `bank_vs LIKE`. If counter-account is ComGate settlement (`row[11]` == `242398277` or `4631352`) it **updates existing** transactions (`bank_date/bank_month/is_sent_to_bank=1`, `save()`) — this is reconciliation; if none found returns `'unseen'` and telegram-logs. Otherwise treats it as a **new bank-to-bank donation** → `createTransaction()`.
  10. `createTransaction()` (`BankForm.php:236-317`): resolves `user_id` (by prior transaction on same `bank_account`, else by `mail`), pre-checks `message_id` uniqueness (`:251,:283`), then `TransactionEntity::create([... ext_status='PAID', is_donation, campaign=3100, original_campaign=3100, bank_vs, bank_date, message_id ...])->save()`; on duplicate `message_id` telegram-logs instead (`:314-316`). Then `setRecurring()` heuristically flags monthly-repeat transactions via raw SQL (`:174-230`).
  11. Back in controller: on `production`, POST hardcoded Slack webhook `#payments` `'Příchozí bankovní platba: <castka> CZK'` (`:102-110`).
  12. `logTransactionMails($message)` persists a `transaction_mails` audit row (subject/from/date) (`:112`,`:133-142`).
  13. Mark mail `\Seen` **only if** `environment==='production' && $status !== 'unseen'` (`:114-118`).
- Postconditions:
  - New `PAID` donation `transaction` created (bank-to-bank branch) OR existing `transaction`(s) reconciled with bank date (ComGate branch); one `transaction_mails` audit row appended; matching donor-thank-you e-mail + downstream side effects fire via TransactionEntity save hooks (see Side Effects); processed mail flagged Seen (unless Comgate-unmatched).
- Side Effects (mostly via `TransactionEntity::preSave/postSave`, `web/modules/custom/transaction/src/Entity/TransactionEntity.php`):
  - preSave (:590-628): sets `original_price`; **throws** if duplicate `message_id` (:595-599); derives `bank_month` + `is_sent_to_bank=1` from `bank_date`; forces `transparent=1` for the transparent account; when unpaid→paid & not yet mailed → `sendEmailThanksForPayment()` (:618) and CZ-only `sendSlackNotification()` (:620-622).
  - `sendEmailThanksForPayment()` (:726-761): sends `thanks_for_payment` / `thanks_for_payment_transparent` / `thanks_for_recurring_payment` via `patron_base.smartmailing->handleMail(...)` (SmartMailing/mail — SRV0013), includes a magic-link; sets `is_email_sent`.
  - postSave (:633-701): `patron_base.default->addToQueue(...)` → `es_upload_queue` Elasticsearch sync (`patron_base/src/PatronBaseService.php:416`); loads+saves `campaign` (raised-money recompute); **overpayment auto-split** — if raised>needed, mutates price and `createDuplicate()`→transparent-account child transaction, invalidates cache tags (:663-689); `dispatchStatusChangeEvent()` is a **no-op** (body commented out, :862-865); `updateRecurringStatus()` marks `transaction_recurring.status=1` when paid (:703-711).
  - `setRecurring()` (`BankForm.php:174-230`): raw `UPDATE transaction SET is_recurring=1 ...` with string-interpolated values.
  - STDOUT debug echoes throughout (cron log noise), Telegram logs on Comgate-VS miss / duplicate message_id.
- Integration Calls:
  - **IMAP inbox** (`Ddeboer\Imap`) — read Unseen aviz mails, `setFlag('\\Seen')` (external mail server; Office 365 per docblock).
  - **Slack** incoming webhook `hooks.slack.com/.../B99L40TJP/...` (`#payments`, controller :105) and, in the new-donation branch, `.../B99N7A89J/...` (`#donation`, `BankForm.php:164`) — **hardcoded URLs, redacted here**.
  - **SmartMailing / transactional mail** via `patron_base.smartmailing` (SRV0013) from TransactionEntity thank-you mail.
  - **Elasticsearch/App Search** via `es_upload_queue` (SRV0016) from postSave `addToQueue`.
  - **Telegram** `logger.telegram` error alerts (SRV0018).
- Failure Modes:
  - `connectImap()` does not throw on auth failure; downstream `getMailbox()` on a falsy connection will fatal — silent-ish import stall. `Confirmed` (:212-217, no early return).
  - Fragile HTML parsing: XPath keyed on exact inline `style` string and fixed row indices; any bank template change yields empty `$htmlData` → still creates a transaction with blank fields. `Confirmed` (:66-93).
  - `createBankovniReference()` computes `md5($ref)` but has **no `return`** → returns null; `bankovni_reference`/`row[9]` (used as transaction `name`) is always null. Confirmed bug (`:187-195`, `BankForm.php:92,:286`).
  - `parseMessageId()` derives the idempotency key from `MessageInterface::getId()` (IMAP sequence number, not the RFC Message-ID header) — sequence numbers are mailbox-position-relative and not stable, weakening dedup. `Partial` (semantics of Ddeboer `getId()` not in scrubbed vendor).
  - Any exception inside the per-message try is re-thrown after logging (`:119-122`), aborting the whole cron batch; already-processed messages in the same run may already be Seen/saved → partial batch. `Confirmed` (Idempotence/Data Loss).
  - Comgate branch with no matching `bank_vs` returns `'unseen'` → mail intentionally left Unseen for retry next cron (`BankForm.php:148-151`; controller :115). `Confirmed`.
  - Duplicate `message_id`: pre-check + preSave throw are redundant; the preSave throw path is caught only at controller level (re-thrown), so a duplicate aborts the batch rather than being skipped gracefully. `Partial`.

## C. Data Footprint
- Entities Written:
  - `transaction` (`TransactionEntity`) — created (bank-to-bank) or updated (ComGate reconciliation); plus possible transparent-account child via overpayment split.
  - `transaction_mails` (`TransactionMailsEntity`) — audit row per handled mail (`bank_integration/src/Entity/TransactionMailsEntity.php`).
  - `transaction_recurring` — `status=1` when paid (postSave `updateRecurringStatus`).
  - `campaign` — re-saved for raised-money recompute (postSave).
  - `es_upload_queue` — enqueued item (postSave `addToQueue`).
- Entities Read:
  - `transaction` (entityQuery by `bank_vs`, by `bank_account`, raw SQL by `message_id`/recurring window).
  - `user` (owner resolution by `bank_account` history and by `mail`).
  - `campaign` (thank-you mail params, raised/needed comparison).
  - `transaction_recurring` (recurring status lookup).
  - Config: `Settings::get('imap' | 'environment' | 'country' | 'transparent_account')`.
- Constraints involved:
  - `message_id` de-duplication (pre-check `BankForm.php:251,283` + `TransactionEntity::preSave` throw `:595-599`).
  - Guard `castka>0 && typ_tranzakce=='Příkaz k úhradě'` (`BankForm.php:117`).
  - ComGate settlement accounts hardcoded (`242398277`, `4631352`) select reconcile-vs-create branch (`BankForm.php:136`).
  - Hardcoded own account/IBAN/currency in CSV synthesis (`:152-158`); default `campaign=3100` (transparent) for new bank donations (`BankForm.php:294`).
- Multi-tenant scope assumptions: **CZ-only** by hard guard (`country==='cz'`, `environment==='production'`) and CZ-specific bank/Slack/account literals. Not tenant-parameterized; RO/MD never execute this flow. The parallel Moneta AISP importer (FL029/FLW0011) covers the API-based CZ path.

## D. Evidence Block
- Controller paths:
  - `web/modules/custom/bank_integration/bank_integration.module` — `bank_integration_cron()` (trigger, env/country gate).
  - `web/modules/custom/bank_integration/src/Controller/BankIntegrationPageController.php` — `getMailFromServerHandle` / `handleMailsFromMoneta` / `connectImap` / `dataTransToCSV` / `createBankovniReference` / `logTransactionMails`.
- Service methods:
  - `Drupal\accounting\Form\BankForm::createTransactionBank / updateTransaction / createTransaction / setRecurring` (`web/modules/custom/accounting/src/Form/BankForm.php`).
  - `Drupal\transaction\Entity\TransactionEntity::parseMessageId / preSave / postSave / sendEmailThanksForPayment / updateRecurringStatus / dispatchStatusChangeEvent(no-op)` (`web/modules/custom/transaction/src/Entity/TransactionEntity.php`).
  - `patron_base.default->addToQueue` (`web/modules/custom/patron_base/src/PatronBaseService.php:416`).
  - `patron_base.smartmailing->handleMail` (SRV0013), `logger.telegram->log` (SRV0018).
- Repository usage: Drupal entity API — `TransactionEntity::create/load/save`, `TransactionMailsEntity::create/save`, `\Drupal::entityQuery('transaction'|'user')`, `loadByProperties('user'|'transaction_recurring'|'voucher')`, raw `\Drupal::database()->query(...)` in `setRecurring`/`createTransaction`.
- Event listeners: none active in this flow — `TransactionUpdateEvent::UPDATE_EVENT` dispatch is **commented out** (`TransactionEntity.php:862-865`); cross-ref FL028 (would-be `campaign_recommendation` subscriber) does not fire from this path.
- Async messages: `es_upload_queue` enqueue (postSave); no queued dispatch of the import itself (runs inline in cron). Thank-you mail via `mailing_queue`/SmartMailing (SRV0013, FL048; USE_QUEUE=FALSE → synchronous per flow-index).
- Config evidence: `Settings::get('imap')` (host/port/flags/user/pass — value absent in scrubbed source, `Hypothesis` host=Office 365 per docblock `:198`); `Settings::get('environment')`, `Settings::get('country')`, `Settings::get('transparent_account')`. Slack webhook URLs hardcoded in source (unlike `logger.slack`, which reads `Settings::get('slack')`) — **redacted** in this dossier. `bank_integration.routing.yml` exposes only `transaction_mails` entity CRUD, confirming cron is the sole trigger for the importer.
