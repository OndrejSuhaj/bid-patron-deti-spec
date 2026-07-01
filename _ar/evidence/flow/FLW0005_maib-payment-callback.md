# FLW0005 — MAIB payment status callback
> AR:FlowMiner dossier · 2026-07-01 · source FlowID FL022 · see [../flow-index.md](../flow-index.md)

## A. Header
- FlowID: FL022 (dossier FLW0005)
- Flow Name: MAIB payment status callback
- Primary SRV: SRV0008
- Trigger Evidence: Route `maib.example` → `intake/current-solution/_source/patronus/web/modules/custom/maib/maib.routing.yml` (path `/transaction/status_update`); controller `maib/src/Controller/MaibController.php::update_status`
- Confidence Level: Confirmed

## B. Behavior Digest
- Trigger: MD gateway return leg. Browser (donor) is redirected back from MAIB to `/transaction/status_update` with POST field `trans_id` (the MAIB external transaction id). Bound in `maib.routing.yml` (`maib.example`), requirement `_permission: 'access content'` (effectively public/anonymous). `MaibController::update_status` reads `\Drupal::request()->request->get('trans_id')` (`MaibController.php:19`).
- Preconditions: A `transaction` row exists with `ext_trans_id == trans_id` (set on the outbound leg in `transaction/src/Plugin/rest/resource/v32/TransactionResource.php:254` via `MaibService::post(command='v')` returning `TRANSACTION_ID`). `Settings::get('spa_url')` configured for redirect. MAIB reachable via client-cert cURL.
- Main Steps (each with evidence):
  1. Extract `trans_id` from POST — `MaibController.php:19`.
  2. Lookup local transaction id by `ext_trans_id` — `MaibController::getTransaction` (`MaibController.php:40-46`, `\Drupal::entityQuery('transaction')->condition('ext_trans_id', ...)->range(0,1)`).
  3. If found, load `TransactionEntity` — `MaibController.php:25` (`TransactionEntity::load(key($transaction_id))`).
  4. Poll MAIB for authoritative status — `MaibController::getMaibTransactionStatus` (`MaibController.php:48-61`) builds `['command'=>'c','trans_id'=>$ext_trans_id,'client_ip_addr'=>$transaction->get('ip_address')->value]` and calls `\Drupal::service('maib')->post(...)` (`MaibController.php:55`). This is a synchronous outbound integration call, not a push webhook payload trust.
  5. Map MAIB `RESULT` → internal status — `MaibController::getTransactionStatus` (`MaibController.php:63-72`): `OK→PAID`, `PENDING→PENDING`, `FAILED→CANCELLED`, `DECLINED→CANCELLED`, default `PENDING`. On cURL error / empty response returns `'PENDING'` (`MaibController.php:56-60`).
  6. Assign `$transaction->ext_status = $ext_status; $transaction->save();` — `MaibController.php:28-29`. The `save()` triggers `TransactionEntity::preSave`/`postSave` which perform the real side effects (below).
  7. Build SPA redirect — `status = isCanceled()?'failed':'success'`, redirect to `{spa_url}/story/{campaign_slug}?status=...&sum={price}` — `MaibController.php:31-35` (`campaign->getSlug()` at `campaign/src/Entity/CampaignEntity.php:1069`). Note: any non-CANCELLED status (incl. PENDING) reports `success` to the SPA (`MaibController.php:32`, `isCanceled()` at `TransactionEntity.php:167`).
  8. If no matching transaction: redirect to bare `spa_url` (`MaibController.php:37`).
- Postconditions: `transaction.ext_status` updated to PAID / CANCELLED / PENDING. `TrustedRedirectResponse` returned to donor browser. If PAID and not previously emailed, thank-you email marked/sent and recurring status promoted.
- Side Effects (all via `transaction->save()` entity hooks, `TransactionEntity.php`):
  - **preSave** (`TransactionEntity.php:590-628`): if `!isEmailSent() && isPaid()` → if owner is blocked, `account::sendActivationEmail(...,'supporter')` (`:616`); `sendEmailThanksForPayment()` (`:618`, template `thanks_for_payment` / `thanks_for_payment_transparent` / `thanks_for_recurring_payment`, via `patron_base.smartmailing::handleMail`, `:756`); if `Settings::get('country')=='cz'` → `sendSlackNotification()` (`:621`) — irrelevant on MD but present. Sets `is_email_sent=TRUE`. Also sets `transparent=1` if campaign is the transparent account (`:607`), and `bank_month`/`is_sent_to_bank` if `bank_date` set (`:600-606`).
  - **postSave** (`TransactionEntity.php:633-701`): `patron_base.default::addToQueue('transaction', id)` on **every** save (`:635`, `es_upload_queue` — search index sync); campaign re-save to recompute raised money (`:693`); **overpayment auto-split** — if `raised > gift_price`, mutate `price` and create a duplicate transaction to the transparent account, invalidate cache tags (`:663-689`); if editing and campaign changed, re-save original campaign (`:646-654`); `dispatchStatusChangeEvent()` is a **no-op** (body commented out, `:862-865`); if `isPaid()` → `updateRecurringStatus()` sets linked `transaction_recurring.status=1` (`:697-698`, `:703-711`).
  - Slack (CZ only, prod only, hardcoded webhook URL `MaibController` N/A → `TransactionEntity.php:793`); logger `transaction`/`divide_transaction` info rows throughout.
- Integration Calls:
  - **MAIB eCommerce gateway** — `MaibService::post` (`maib/src/MaibService.php:15-44`), client-cert cURL to `https://maib.ecommerce.md:11440/ecomm01/MerchantHandler` (prod) or `:21440/ecomm/MerchantHandler` (non-prod), `command=c` (status check). Called from `MaibController::getMaibTransactionStatus` (`MaibController.php:55`).
  - **Telegram** (error channel) — `logger.telegram::log(3, errors)` on cURL failure (`MaibService.php:40`).
  - **SmartMailing / mail** — thank-you email via `patron_base.smartmailing::handleMail` (`TransactionEntity.php:756`; `APIMailingService::USE_QUEUE = FALSE` → synchronous send, `patron_base/src/APIMailingService.php:16,68`).
  - **Elasticsearch upload queue** — `addToQueue` (`TransactionEntity.php:635`).
- Failure Modes:
  - **Route collision (critical):** identical path `/transaction/status_update` is declared by both `maib.example` (`maib.routing.yml:2`) and `comgate.transaction_status_update_update_status` (`comgate/comgate.routing.yml:11`). Only one can win in the Drupal route table; resolution is non-deterministic from source alone (depends on module weight / rebuild order). `Hypothesis` — one gateway's return handler may be shadowed by the other; comgate handler reads different POST fields (`refId`/`transId`), so a MAIB return hitting the ComGate controller would fail to match. Tagged Idempotence/External Integration.
  - **No idempotence guard:** `update_status` re-polls MAIB and re-`save()`s on every hit; a repeated return/refresh re-runs postSave (re-queues ES, re-saves campaign, re-checks overpayment split). Email is guarded by `is_email_sent`; recurring promotion is guarded by existing status; overpayment split is guarded only by raised>needed (could double-split across separate transactions). Tagged Idempotence.
  - **MAIB unreachable / cURL error:** `MaibService::post` returns FALSE → `getMaibTransactionStatus` returns `'PENDING'` (`MaibController.php:60`); transaction saved as PENDING but SPA still shown `status=success` (`MaibController.php:32`) — donor may see success for an unconfirmed payment. Tagged Money/VAT, External Integration.
  - **Missing null-guards:** `$transaction->getCampaign()` could be null → `getSlug()` on null would fatal (`MaibController.php:31`). No try/catch around `save()`; a preSave exception (e.g. message_id duplicate check `TransactionEntity.php:598`) would 500 the return leg. Tagged Data Loss/External Integration.
  - **Auth:** endpoint is `_permission: 'access content'` (public). `trans_id` is attacker-suppliable, but authoritative status is re-fetched from MAIB by `command=c` (server-to-server with client cert), so status cannot be forged via the return POST — mitigating factor. Tagged Security.
  - **Hardcoded prod credential:** `MaibService.php:19-20` embeds prod cert path and passphrase `<redacted>` directly in source (not from Settings/env). Tagged Security.

## C. Data Footprint
- Entities Written:
  - `transaction` (`TransactionEntity`) — `ext_status` (PAID/CANCELLED/PENDING), and via hooks: `original_price`, `transparent`, `bank_month`, `is_sent_to_bank`, `is_email_sent`, `price` (overpayment split mutation) — `MaibController.php:28`, `TransactionEntity.php:590-694`.
  - `transaction` (new duplicate row) — overpayment split to transparent account (`TransactionEntity.php:671-679`).
  - `campaign` — re-saved to recompute raised money (`TransactionEntity.php:693`, and original campaign `:652`).
  - `transaction_recurring` — `status=1` on paid (`TransactionEntity.php:709-710`).
  - `voucher` — not on this path (updateVoucherStatus/generateMultipleVouchers exist but are NOT invoked from MaibController).
  - Queue item in `es_upload_queue` (`addToQueue`, `TransactionEntity.php:635`).
- Entities Read:
  - `transaction` by `ext_trans_id` (`MaibController::getTransaction`, entityQuery); fields `ip_address`, `price`, `campaign`.
  - `campaign` (via `transaction->getCampaign()`), fields `slug`, `gift_price`, `name`, raised-money aggregate.
  - `user` (owner) for email/blocked check in preSave.
- Constraints involved:
  - `message_id` uniqueness enforced app-level in `preSave` via raw SQL (`TransactionEntity.php:597-599`, throws), **not** a DB unique key (soft constraint) — per `../db-models.md:657`.
  - Declared indexes on transaction incl. `...ext_trans_id...` composite (`../db-models.md:668`); `ext_trans_id` is `string(40)`, no DB unique index → lookup relies on `range(0,1)` (first match wins if duplicates exist). Tagged Idempotence.
  - `ext_status` allowed values PENDING/PAID/CANCELLED/AUTHORIZED/REFUNDED (`TransactionEntity.php:452-462`).
- Multi-tenant scope assumptions:
  - MAIB is the **MD** gateway (module package "Patron Moldova", `maib.info.yml`). Env branch via `Settings::get('environment')==='production'` selects prod vs test MAIB endpoint/cert (`MaibService.php:17`).
  - Slack notification gated to `Settings::get('country')=='cz'` (`TransactionEntity.php:620`) — dead branch on MD instances but shared entity code (cross-tenant coupling in the shared `transaction` entity). Tagged Multi-tenant.

## D. Evidence Block
- Controller paths: `maib/src/Controller/MaibController.php` (`update_status`, `getTransaction`, `getMaibTransactionStatus`, `getTransactionStatus`).
- Service methods: `maib/src/MaibService.php` (`post`, `parseMaibResponse`); `patron_base/src/APIMailingService.php` (`handleMail`, `USE_QUEUE=FALSE`); `patron_base/src/PatronBaseService.php` (`addToQueue`).
- Repository usage: entity storage via `\Drupal::entityQuery('transaction')` + `TransactionEntity::load`; raw SQL only inside `TransactionEntity::preSave` (message_id dup check) and `getOriginalPrice`.
- Event listeners: `TransactionUpdateEvent::UPDATE_EVENT` dispatch is **disabled** — `dispatchStatusChangeEvent()` body commented out (`TransactionEntity.php:862-865`); FL028 subscriber (campaign_recommendation) does not fire from this path.
- Async messages: `es_upload_queue` enqueued on every save (`addToQueue`). Mailing runs synchronously (`APIMailingService::USE_QUEUE = FALSE`, `patron_base/src/APIMailingService.php:16`).
- Config evidence: `maib.routing.yml` (path + `_permission: access content`); `maib.services.yml` (service `maib`); `maib.info.yml` (dependency `transaction`, package Patron Moldova); `comgate.routing.yml:11` (COLLIDING path). Outbound registration leg: `transaction/src/Plugin/rest/resource/v32/TransactionResource.php:249-260` sets `ext_trans_id` from MAIB `TRANSACTION_ID`.
