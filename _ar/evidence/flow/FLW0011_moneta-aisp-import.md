# FLW0011 — Moneta AISP daily transaction import
> AR:FlowMiner dossier · 2026-07-01 · source FlowID FL029 · see [../flow-index.md](../flow-index.md)

## A. Header
- FlowID: FL029 (dossier FLW0011)
- Flow Name: Moneta AISP daily transaction import
- Primary SRV: SRV0009 (Moneta-AISP-Adapter; feeds Reconciliation-Processor — see [../../spec-draft/SRV-target-list.md](../../spec-draft/SRV-target-list.md) L34, L52)
- Trigger Evidence: `monetaapi_cron()` — `web/modules/custom/monetaapi/monetaapi.module:9` (Drupal `hook_cron`, runs at most once/day via `\Drupal::state()` guard `monetaapi.last_run`, L10-17).
- Confidence Level: Confirmed

## B. Behavior Digest
- Trigger: Drupal cron tick invokes `monetaapi_cron()` (`monetaapi.module:9`). A manual/debug UI twin exists at route `/monetaapiid` → `MonetaAPIController::getId()` (`monetaapi.routing.yml:2`; `_access: 'FALSE'` L7 — route access denied, so cron is the only live trigger. Controller logic mirrors cron: `MonetaAPIController.php:10-26`).
- Preconditions:
  - Not already run today: `date('d', last_run) === date('d')` → early return (`monetaapi.module:14`). Note (recorded, not corrected): comment at L13 admits a month-long gap also skips (day-of-month equality, not date equality) — brittle idempotence guard.
  - `Settings::get('moneta_api_token')` must be configured (Bearer token; `monetaapi.module:21-22`). Redacted default `<redacted>` hardcoded as param default in `MonetaAPI::getID()` (`MonetaAPI.php:32`).
  - Reachability of `api.moneta.cz` AISP endpoint.
- Main Steps (ordered, each with file:symbol evidence):
  1. State guard + mark run: set `monetaapi.last_run = requestTime` **before** the API work (`monetaapi.module:17`). Consequence: a mid-run failure still records the day as "run" → no retry until tomorrow (recorded failure mode).
  2. Resolve account id: `MonetaAPI::getID($token)` GETs `https://api.moneta.cz/api/v1/vip/aisp/my/accounts?page=0&size=10` and returns `accounts[0]['id']` — assumes exactly one account (`MonetaAPI.php:32-49`, explicit comment L47 "only 1 account").
  3. Fetch transactions for `'yesterday'`: `MonetaAPI::getTransactions($id,$token,'yesterday')` — `date_create('yesterday')` → `Y-m-d`, paginated GET loop following `nextPage` until null, `size=100`, sort date DESC, `fromDate==toDate` (`MonetaAPI.php:65-90`). Endpoint: `.../accounts/{id}/transactions?...` (L73).
  4. Per transaction: `MonetaAPI::mapAndSave($transaction)` (`monetaapi.module:24-28`; `MonetaAPI.php:103`).
  5. Dedup check: `SELECT id FROM {transaction} WHERE name = :reference ...` on `entryReference`; if present return FALSE (skip) (`MonetaAPI.php:104-107`).
  6. Currency guard: if `amount.currency !== 'CZK'` → `logger->emergency` + throw (`MonetaAPI.php:108-111`). CZK-only.
  7. Parse variable symbol: `preg_match('/VS:([0-9]+)/', ...creditorReferenceInformation.reference)` → `bank_vs` (`MonetaAPI.php:112-113`).
  8. Extract debtor account: `...relatedParties.debtorAccount.identification.other.identification` → `bank_account` (`MonetaAPI.php:114`).
  9. Build values array — hardcoded `ext_status='PAID'`, `campaign=3100`, `original_campaign=3100`, `transparent=true`, `ext_fee=0`, `test=0`, `is_sent_to_bank=1`; `price=amount.value`, `bank_date=bookingDate.date`, `bank_month` derived, `comment=...references.transactionDescription` (`MonetaAPI.php:115-133`).
  10. User back-fill: `SELECT user_id FROM {transaction} WHERE bank_account = :bank_account ORDER BY id DESC LIMIT 1`; if a prior txn from same account exists, copy its `user_id` (`MonetaAPI.php:135-138`).
  11. Create + save entity: `entityTypeManager->getStorage('transaction')->create($values)->save()` (`MonetaAPI.php:139-141`). This fires `TransactionEntity::preSave`/`postSave` (see C — heavy downstream work).
  12. Count + log: `logger('monetaapi')->info('!count transactions recorded...')` with Timer duration (`monetaapi.module:29-30`).
- Postconditions:
  - New `transaction` rows for yesterday's Moneta credits not previously imported (keyed by `entryReference` → `name`), all with `ext_status='PAID'`, `campaign=3100` (transparent account).
  - `campaign` #3100 `campaign_raised`/`campaign_percentual_raised` recomputed on save (via postSave `getCampaign()->save()` → CampaignEntity preSave recompute; `TransactionEntity.php:693`, `CampaignEntity.php:1073-1111`).
- Side Effects (via `TransactionEntity::preSave`/`postSave`, `TransactionEntity.php:590-701`):
  - `ext_status='PAID'` + `!isEmailSent()` ⇒ `sendEmailThanksForPayment()` — dispatches transactional mail via `patron_base.smartmailing::handleMail` IF the resolved owner has a valid email (`TransactionEntity.php:612-624, 726-761`). For most imported rows `user_id` is only set when step 10 matched, and email fires only if that user has a valid email; anonymous imports send nothing (`getTransactionEmail()` returns false, L763-769).
  - CZ only: `sendSlackNotification()` posts to a hardcoded Slack webhook (redacted URL literal in source) when `environment==='production'` (`TransactionEntity.php:619-622, 783-803`).
  - Blocked-owner path: if matched owner `isBlocked()`, `account::sendActivationEmail(...,'supporter')` (`TransactionEntity.php:615-617`).
  - ES indexing: `postSave` → `patron_base.default::addToQueue('transaction', id)` enqueues to `es_upload_queue` (dedup-checked) (`TransactionEntity.php:635`; `PatronBaseService.php:416-426`).
  - Overpayment auto-split: if target campaign `raised > needed` (gift_price), `postSave` mutates `price`, `save()`s again, and creates a **second** transaction routed to the transparent account (`Settings::get('transparent_account')`), invalidates cache tags (`TransactionEntity.php:658-694`). For campaign 3100 (transparent account itself) `gift_price` is typically empty ⇒ `money_needed=0` ⇒ split skipped, but this is data-dependent (Hypothesis on 3100's gift_price value — not evidenced in scrubbed source).
  - `is_sent_to_bank` re-derived + `bank_month` re-derived in preSave when `bank_date` present (`TransactionEntity.php:600-606`).
  - `original_price` set from `price` on new entity (`TransactionEntity.php:592-594`).
  - `dispatchStatusChangeEvent()` is a **no-op** — body commented out (`TransactionEntity.php:862-865`); `TransactionUpdateEvent::UPDATE_EVENT` is NOT dispatched here (cross-ref FL028 is dormant for this path).
  - Extensive info logging to channels `monetaapi`, `transaction`, `divide_transaction`.
- Integration Calls:
  - **Moneta AISP** (outbound, Guzzle): `GET https://api.moneta.cz/api/v1/vip/aisp/my/accounts` (`MonetaAPI.php:35`) and `.../accounts/{id}/transactions?...` (`MonetaAPI.php:73`). Auth `Bearer <redacted>` from `Settings::get('moneta_api_token')`.
  - **Slack** (outbound, transitive, CZ+prod only): hardcoded `hooks.slack.com/...` webhook (redacted) in `TransactionEntity::sendSlackNotification` (`TransactionEntity.php:793`).
  - **SmartMailing / mail** (outbound, transitive, conditional): `patron_base.smartmailing::handleMail` (`TransactionEntity.php:756`).
  - **Elasticsearch** (deferred, transitive): `es_upload_queue` enqueue (`PatronBaseService.php:416-426`) — actual ES write is async in the queue worker (SRV0016), not in this flow.
- Failure Modes:
  - Guzzle error on `getID`/`getTransactions` → logged (`MonetaAPI.php:43, 86`) and re-thrown as `\Exception`; caught in `monetaapi_cron` catch block, logged at error, cron ends (`monetaapi.module:32-34`). No retry.
  - Non-CZK transaction → `emergency` log + throw (`MonetaAPI.php:109-110`); the throw propagates out of the `foreach` to the cron catch, aborting the **entire remaining batch** for that run (subsequent transactions in the loop are skipped) — potential partial import (Data Loss / Idempotence risk).
  - `last_run` set before work (`monetaapi.module:17`) ⇒ any exception (network, non-CZK, entity save) that aborts the run still consumes today's slot; unimported/failed transactions are only retried if next-day cron re-fetches (getTransactions always queries 'yesterday', so a failed day is NOT re-fetched later — silent gap). Data Loss risk.
  - `getID` assumes `accounts[0]` exists; empty/zero-account response ⇒ undefined-index / null id (`MonetaAPI.php:48`).
  - `preg_match` VS parse: if `reference` lacks `VS:<digits>`, `$matches[1]` is undefined ⇒ `bank_vs` unset (PHP notice; stored empty) — not fatal (`MonetaAPI.php:112-113`).
  - Deep-array access on `entryDetails.transactionDetails...` assumes full structure; missing keys throw/notice (`MonetaAPI.php:112-121`).
  - Entity `preSave` `message_id` uniqueness throw is not triggered here (message_id left unset/commented, `MonetaAPI.php:132`).

## C. Data Footprint
- Entities Written:
  - `transaction` — one row per new Moneta credit (`create()->save()`, `MonetaAPI.php:139-140`). Fields set: name(entryReference), price, ext_fee, ext_status(PAID), comment, bank_account, campaign(3100), original_campaign(3100), transparent, test, bank_date, bank_month, bank_vs, is_sent_to_bank, user_id(conditional).
  - `transaction` (second, conditional) — overpayment split child to transparent account via `postSave` `createDuplicate()` (`TransactionEntity.php:671-679`). Data-dependent; likely inert for campaign 3100.
  - `campaign` #3100 — re-saved in `postSave` (`getCampaign()->save()`, `TransactionEntity.php:693`); CampaignEntity preSave recomputes `campaign_raised`/`campaign_percentual_raised` (`CampaignEntity.php:1101-1111`). Also enqueues campaign to ES (`CampaignEntity.php:979`).
  - `queue` (Drupal core `queue` table) — `es_upload_queue` item for the transaction (and campaign) (`PatronBaseService.php:421-422`).
  - `email` entity — created transitively IF thank-you mail sent via smartmailing/notification stack (conditional; owner must have valid email).
  - Drupal state `monetaapi.last_run` (`monetaapi.module:17`).
  - `transaction_recurring` — `postSave` `updateRecurringStatus()` sets status=1 IF a recurring record references this txn (`TransactionEntity.php:697-711`); not expected for bank imports (Hypothesis: no recurring link) — inert here.
- Entities Read:
  - `transaction` — dedup by `name`/entryReference (`MonetaAPI.php:104`); user back-fill by `bank_account` (`MonetaAPI.php:135`); campaign raised-money SUM over PAID transactions (`CampaignEntity.php:1091-1096`).
  - `campaign` #3100 — loaded via `getCampaign()` (entity reference) for raised-money recompute (`TransactionEntity.php:656-661`).
  - `queue` — dedup check before enqueue (`PatronBaseService.php:417`).
  - `user` — owner lookup for email/blocked check (conditional; `TransactionEntity.php:613, 745, 764`).
- Constraints involved:
  - App-level dedup on `transaction.name` = Moneta `entryReference` (SELECT-then-insert; **not** a DB unique index — race/idempotence gap; db-models notes message_id uniqueness is app-level only, `_ar/evidence/db-models.md:668`).
  - Indexes on `transaction` (StorageSchema): campaign/is_sent_to_bank/ext_status/price, id/bank_vs/is_sent_to_bank, campaign/ext_trans_id/... (`_ar/evidence/db-models.md:668`). No unique constraint enforcing import idempotence.
  - Currency hard constraint: CZK only (`MonetaAPI.php:108`).
- Multi-tenant scope assumptions:
  - CZ-only integration (Moneta is the CZ bank; `integrations.md` §1). Slack notify gated on `Settings::get('country')==='cz'` (`TransactionEntity.php:619-620`). RO/MD use IMAP bank mail / other banks (FL030). No per-tenant partitioning inside the flow — single Drupal instance, single account assumed (`MonetaAPI.php:47`).
  - Campaign 3100 is a fixed "transparent account" sink for all imported bank credits (hardcoded `MonetaAPI.php:123-124`); cross-refs `Settings::get('transparent_account')` used elsewhere (`TransactionEntity.php:607, 674, 681`).

## D. Evidence Block
- Controller paths:
  - `web/modules/custom/monetaapi/monetaapi.module:9` — `monetaapi_cron()` (primary trigger).
  - `web/modules/custom/monetaapi/src/Controller/MonetaAPIController.php:10` — `getId()` (route `/monetaapiid`, `_access: 'FALSE'` per `monetaapi.routing.yml:7` — disabled debug twin).
- Service methods:
  - `web/modules/custom/monetaapi/src/MonetaAPI.php` — `getID():32`, `getTransactions():65`, `mapAndSave():103`. Registered as service `monetaapi` (`monetaapi.services.yml:2`, args `@database, @entity_type.manager, @logger.channel.monetaapi`).
  - `web/modules/custom/transaction/src/Entity/TransactionEntity.php` — `preSave():590`, `postSave():633`, `sendEmailThanksForPayment():726`, `sendSlackNotification():783`, `updateRecurringStatus():703`.
  - `web/modules/custom/campaign/src/Entity/CampaignEntity.php` — `getCampaignRaisedMoney():1073`, `updateCampaignRaisedMoney():1101`.
- Repository usage:
  - Raw `$this->database->query(...)` for dedup, user back-fill (`MonetaAPI.php:104, 135`).
  - `entityTypeManager->getStorage('transaction')->create()->save()` (`MonetaAPI.php:139`).
  - `Database::select('transaction')` SUM for campaign raised money (`CampaignEntity.php:1091`).
- Event listeners:
  - None active for this path — `dispatchStatusChangeEvent()` body is commented out (`TransactionEntity.php:862-865`); `TransactionUpdateEvent::UPDATE_EVENT` (`transaction/src/Event/TransactionUpdateEvent.php:13`) is not dispatched.
- Async messages:
  - `es_upload_queue` enqueue via `PatronBaseService::addToQueue` (`PatronBaseService.php:416`); Drupal `queue` table; consumed later by SRV0016 (patron_search) — see FL055.
- Config evidence:
  - `Settings::get('moneta_api_token')` (Bearer, redacted) — `monetaapi.module:21-22`; hardcoded default token literal `<redacted>` in `MonetaAPI::getID()` signature (`MonetaAPI.php:32`).
  - `Settings::get('country')` (Slack gate), `Settings::get('environment')` (prod gate for Slack), `Settings::get('transparent_account')` (overpayment split target) — `TransactionEntity.php:607, 619, 674, 787`.
  - Endpoints hardcoded (not config): `api.moneta.cz` base (`MonetaAPI.php:35, 73`); Slack webhook literal (`TransactionEntity.php:793`).
  - `integrations.md` §1 corroborates Moneta AISP endpoint + Bearer auth (Confirmed).
