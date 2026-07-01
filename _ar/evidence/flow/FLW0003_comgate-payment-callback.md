# FLW0003 — ComGate payment status callback
> AR:FlowMiner dossier · 2026-07-01 · source FlowID FL021 · see [../flow-index.md](../flow-index.md)

## A. Header
- FlowID: FL021 (dossier FLW0003)
- Flow Name: ComGate payment status callback
- Primary SRV: SRV0008
- Trigger Evidence: route `comgate.transaction_status_update_update_status` path `/transaction/status_update` → `comgate/src/Controller/TransactionStatusUpdate.php::update_status` (`comgate/comgate.routing.yml`)
- Confidence Level: Confirmed

## B. Behavior Digest
- Trigger: ComGate gateway server-to-server (background) POST to `/transaction/status_update` after a CZ/CZK payment reaches a terminal/interim state. Route is guarded only by `_permission: 'access content'` (`comgate/comgate.routing.yml`), i.e. effectively public — auth is by shared `secret` in the POST body, not by route ACL.
- Preconditions: `Settings::get('comgate')` config present (`paymentsUrl`, `merchant`, `test`, `secret`); a `transaction` row exists matching (`price` = ComGate `price`/100, `id` = ComGate `refId`, `ext_trans_id` = ComGate `transId`), created earlier by FLW0002/FL020 (`SRV0007`).
- Main Steps (ordered, with evidence):
  1. Build `AgmoPaymentsSimpleProtocol` from `Settings::get('comgate')` — `TransactionStatusUpdate.php::update_status` (ctor `AgmoPaymentsSimpleProtocol.php::__construct`).
  2. Validate callback: presence of `merchant,test,price,curr,refId,transId,secret,status`; then compare `merchant`, `test`, `secret` against config, throw `Invalid merchant identification` on mismatch — `AgmoPaymentsSimpleProtocol.php::checkTransactionStatus` (reads `$_POST` directly).
  3. `entityQuery('transaction')` with `accessCheck()` on `price` + `id` + `ext_trans_id`, `range(0,1)` — `update_status` (getters `getTransactionStatusPrice/RefId/TransId`).
  4. On match: load `TransactionEntity`, set `ext_status` = ComGate `status` (PENDING/PAID/CANCELLED/AUTHORIZED/REFUNDED), set `ext_fee` = numeric `fee` else NULL, `save()` — `update_status` (field allowed_values in `TransactionEntity.php::baseFieldDefinitions`, `ext_status`).
  5. `updateUserRole()`: if `status === 'PAID'` and owner lacks role `supporter`, `addRole('supporter')` + `user->save()` — `TransactionStatusUpdate.php::updateUserRole`.
  6. `transaction->updateVoucherStatus()` — promotes a matching paid+unapplied voucher (status 0→1, sets `applied`), then voucher `sendEmailBuy()` + `sendSlackNotification()` — `TransactionEntity.php::updateVoucherStatus`.
  7. `transaction->generateMultipleVouchers()` — if PAID and `vouchers_data` present and no existing voucher, runs `MultipleVouchersGenerator` (creates vouchers + PDFs) — `TransactionEntity.php::generateMultipleVouchers`.
  8. Respond `code=0&message=OK` on match; on no-match `code=1&message=no transaction` (or `code=0&message=OK` when `Settings::get('comgate') === 'staging'`); on any exception `code=1&message=<urlencoded exception message>` — `update_status`.
- Postconditions: transaction `ext_status`/`ext_fee` persisted; owner may hold role `supporter`; voucher(s) promoted/generated; campaign raised-money recomputed and possibly completed (see side effects, via `TransactionEntity::postSave`).
- Side Effects (mostly fired inside `TransactionEntity::preSave`/`postSave`, not the controller):
  - Thank-you email on first PAID transition: `preSave` calls `sendEmailThanksForPayment()` (template `thanks_for_payment` / `thanks_for_payment_transparent` (campaign 3100) / `thanks_for_recurring_payment`) via `patron_base.smartmailing::handleMail`; sets `is_email_sent=TRUE` — `TransactionEntity.php::preSave`, `sendEmailThanksForPayment`.
  - If owner is blocked at PAID time: `account::sendActivationEmail($sender,'supporter')` — `preSave` (marked "Dubious logic" in source).
  - Slack donation ping (CZ + `environment===production`): hardcoded incoming webhook `https://hooks.slack.com/services/<redacted>` posting amount/story/donor; plus zone-channel message for authenticated donors — `TransactionEntity.php::sendSlackNotification`.
  - Role promotion to `supporter` (controller `updateUserRole`, duplicated intent with `preSave` blocked-user branch).
  - Voucher email (`voucher/src/Entity/VoucherEntity.php::sendEmailBuy`) + voucher Slack (`::sendSlackNotification`).
  - Elasticsearch audit/index enqueue: `postSave` → `patron_base.default::addToQueue(entity_type,id)` → `es_upload_queue` — `TransactionEntity.php::postSave`, `PatronBaseService.php::addToQueue`.
  - Overpayment auto-split: in `postSave`, if `campaign_raised > gift_price`, current transaction price is reduced and a duplicate transaction for the difference is created against `Settings::get('transparent_account')` (transparent=1, ext_fee=0, parent set) + cache-tag invalidation — `TransactionEntity.php::postSave`.
  - Campaign cascade: `postSave` calls `$campaign->save()` → `CampaignEntity::preSave` recomputes `campaign_raised`/`campaign_percentual_raised` (`getCampaignRaisedMoney`), and if `isCampaignReadyToComplete()` sets `campaign_order`, sends success emails (`sendEmailSuccessfullyFinishCampaign`, production), and flips application + campaign status to complete (`setApplicationComplete`, `setComplete`) — `CampaignEntity.php::preSave` (lines ~915-935), `updateCampaignRaisedMoney`, `getCampaignRaisedMoney`.
  - Recurring activation: `postSave` if PAID → `updateRecurringStatus()` sets linked `transaction_recurring.status=1` — `TransactionEntity.php::updateRecurringStatus`.
  - `dispatchStatusChangeEvent()` is present but **commented out** (`TransactionUpdateEvent::UPDATE_EVENT` not dispatched) — `TransactionEntity.php::dispatchStatusChangeEvent`; this severs the FL028 `campaign_recommendation` listener path.
- Integration Calls:
  - Inbound webhook from ComGate (AGMO simple/background protocol) — validated in `AgmoPaymentsSimpleProtocol::checkTransactionStatus`.
  - Outbound Slack incoming webhook (hardcoded URL, CZ/prod) — `TransactionEntity::sendSlackNotification`.
  - Outbound transactional email via `patron_base.smartmailing` (SmartMailing/Mautic plumbing) — `sendEmailThanksForPayment`, voucher `sendEmailBuy`.
  - Elasticsearch (async, via queue) — `addToQueue` → `es_upload_queue`.
- Failure Modes:
  - **No signature/HMAC**: authenticity relies solely on `secret` echoed in POST body compared for equality; route is public (`access content`). `Security` / replayable.
  - **Idempotence**: no dedup on repeated callbacks; each POST re-loads + re-saves the transaction. Guards are field-level (`is_email_sent`, voucher status 0/is_applied 0, `updateRecurringStatus` early-return) — email/voucher/recurring are largely once-only, but role add, campaign recompute, and cache invalidation re-run every callback. Repeated PAID callbacks re-trigger the overpayment split guard each save (split guarded by raised>needed comparison after price mutation, but re-entrant `$this->save()` inside `postSave` risks recursion/extra rows). `Idempotence` / `Money/VAT`.
  - **Reads `$_POST` directly** (superglobal, not the Request object) in both controller and `checkTransactionStatus` — bypasses Drupal request handling.
  - **Silent no-match**: mismatched price/id/ext_trans_id returns `code=1 no transaction` (or masks as OK on staging) — a legit paid transaction whose stored `id/price/ext_trans_id` drifted is never marked PAID. `Data Loss` (lost reconciliation).
  - **Broad catch**: any exception is swallowed into `code=1&message=<exception>`, echoing internal messages back to ComGate.
  - `ext_fee` NULLed when `fee` non-numeric; `getTransactionFee()` assumes `fee` key exists (would notice on missing key, but `checkTransactionStatus` does not require `fee`).
  - Race on `transaction.message_id` uniqueness is enforced only by a raw SELECT + throw in `preSave` (no DB unique key) — not directly on this path (callback does not set message_id) but shares the save. `Idempotence`.

## C. Data Footprint
- Entities Written:
  - `transaction` — `ext_status`, `ext_fee` (controller); `is_email_sent`, `original_price`, `bank_month`/`is_sent_to_bank` (conditional), `transparent`, `price` (overpayment split) via `preSave`/`postSave`. New duplicate `transaction` row on overpayment split.
  - `user` — role `supporter` added (`updateUserRole`).
  - `voucher` — `status` 0→1, `applied` timestamp (`updateVoucherStatus`); new voucher rows + PDFs (`generateMultipleVouchers`).
  - `campaign` — `campaign_raised`, `campaign_percentual_raised`, possibly `campaign_order` + completion status (via `$campaign->save()` cascade).
  - `application` — status flipped to complete when campaign completes (`setApplicationComplete`). **Cross-context write.**
  - `transaction_recurring` — `status`=1 (`updateRecurringStatus`).
  - `queue` — `es_upload_queue` item (`addToQueue`).
  - `campaign_slug_archive` — insert if campaign name changed during cascade save (`CampaignEntity::preSave`).
- Entities Read:
  - `transaction` (entityQuery match; `getOriginalPrice` raw SQL), `user` (owner/email/roles), `campaign` (`getCampaign`, `getCampaignRaisedMoney` raw SQL over `transaction`), `voucher`, `transaction_recurring`, `application` (via campaign), `Settings` (`comgate`, `country`, `environment`, `transparent_account`).
- Constraints involved:
  - Index `transaction_campaign_ext_trans_id_price_status_ext_status_test` (id, campaign, ext_trans_id, price, status, ext_status, test) backs the 3-field lookup — `TransactionEntityStorageSchema.php` (Confirmed in db-constraints §a).
  - No DB unique key on the (id, price, ext_trans_id) match tuple; soft entity_reference FKs only (transaction→user, →campaign×2, →transaction self). `message_id` uniqueness = raw-SELECT-and-throw, race-prone (not on this path).
- Multi-tenant scope assumptions: This callback is the **CZ/ComGate** path (RO=Netopia FLW-FL023, MD=MAIB FLW0004/FL022). Slack ping gated `Settings::get('country')==='cz'` + `environment==='production'`; campaign success email gated on production; `comgate_cron` (recurring, FL024) gated `environment===production && country===cz`. The controller itself is **not** country-gated — it acts on whatever `Settings::get('comgate')` resolves to per site.

## D. Evidence Block
- Controller paths: `comgate/src/Controller/TransactionStatusUpdate.php` (`update_status`, `updateUserRole`).
- Service methods: `comgate/src/AgmoPaymentsSimpleProtocol.php` (`checkTransactionStatus`, `getTransactionStatus*`, `getTransactionFee`); `patron_base/src/PatronBaseService.php` (`addToQueue`, `isEmailValid`, `getStorage`); `patron_base.smartmailing::handleMail`; `campaign/src/Entity/CampaignEntity.php` (`preSave`, `updateCampaignRaisedMoney`, `getCampaignRaisedMoney`, `isCampaignReadyToComplete`, `setApplicationComplete`, `setComplete`).
- Entity hooks (heavy lifting): `transaction/src/Entity/TransactionEntity.php` — `preSave` (thank-you email, Slack, blocked-user activation, transparent/bank fields), `postSave` (queue enqueue, overpayment split + duplicate, `$campaign->save()` cascade, `updateRecurringStatus`), `updateVoucherStatus`, `generateMultipleVouchers`, `sendEmailThanksForPayment`, `sendSlackNotification`.
- Repository usage: `\Drupal::entityQuery('transaction')` (controller); raw SQL `getCampaignRaisedMoney` (SELECT SUM over `transaction`), `getOriginalPrice`, `addToQueue` (raw SELECT on `queue`), `campaign_slug_archive` insert; `patron_base.default::getStorage(...)->loadByProperties` for voucher/transaction_recurring.
- Event listeners: `TransactionUpdateEvent::UPDATE_EVENT` — **dispatch commented out** in `dispatchStatusChangeEvent` (so FL028 recommendation listener is dormant on this path).
- Async messages: `es_upload_queue` (Elasticsearch upload) via `addToQueue`; SmartMailing/Mautic dispatch through `patron_base` mailing queue workers. No callback-side queue for the payment status itself (processed synchronously in the request).
- Config evidence: `comgate/comgate.routing.yml` (route + `_permission: access content`); `Settings::get('comgate')` (paymentsUrl/merchant/test/secret — <redacted>); `Settings::get('transparent_account')`, `Settings::get('country')`, `Settings::get('environment')`; `comgate/comgate.module` `comgate_cron` (prod+cz gate); `transaction/src/TransactionEntityStorageSchema.php` (indexes); allowed `ext_status` values in `TransactionEntity::baseFieldDefinitions`.
