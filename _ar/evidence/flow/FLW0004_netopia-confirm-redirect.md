# FLW0004 — Netopia/MobilPay confirm + redirect
> AR:FlowMiner dossier · 2026-07-01 · source FlowID FL023 · see [../flow-index.md](../flow-index.md)

## A. Header
- FlowID: FL023 (dossier FLW0004)
- Flow Name: Netopia/MobilPay confirm + redirect
- Primary SRV: SRV0008
- Trigger Evidence: route `netopia.confirm` (`POST /transaction/netopia/confirm`) → `netopia/src/Controller/NetopiaConfirmController::confirm` (server-to-server IPN); route `netopia.story.result` (`/transaction-result/{transaction_uuid}`) → `netopia/src/Controller/NetopiaPaymentResultController::paymentResult` (browser return); route `netopia.redirect` (`/transaction/netopia/redirect/{transaction_uuid}`) → `netopia/src/Form/NetopiaRedirectForm::buildForm` (gateway hand-off). All in `netopia/netopia.routing.yml`.
- Confidence Level: Confirmed

## B. Behavior Digest
- Trigger: Two independent HTTP entrypoints for one payment. (1) MobilPay/Netopia server POSTs the encrypted IPN to `netopia.confirm` (`NetopiaConfirmController::confirm`, the authoritative status source). (2) The buyer's browser is redirected back to `netopia.story.result` (`NetopiaPaymentResultController::paymentResult`, display-only). A third route `netopia.redirect` (`NetopiaRedirectForm`) precedes both — it builds the auto-submitting encrypted card form that sends the buyer to `secure.mobilpay.ro`.
- Preconditions: A `transaction` entity exists with a UUID used as MobilPay `orderId` (`NetopiaRedirectForm::buildForm` sets `$objPmReqCard->orderId = $transaction->uuid()`, line 70). Private key file present at `DRUPAL_ROOT/../netopia.private.key`; public cert at `DRUPAL_ROOT/../netopia.public.cer`. `Settings::get('environment')` selects prod vs sandbox host.
- Main Steps (confirm / IPN path):
  1. Read `cipher`/`iv` from `$_POST`; require `REQUEST_METHOD == POST` and presence of `env_key` + `data` — else set a permanent-error CRC (`NetopiaConfirmController::confirm`, lines 34-137).
  2. Decrypt the IPN with the private key: `\Mobilpay_Payment_Request_Abstract::factoryFromEncrypted($_POST['env_key'], $_POST['data'], $privateKeyFilePath, null, $cipher, $iv)` (line 53). Decrypt failure → `CONFIRM_ERROR_TYPE_TEMPORARY` / `ERROR_CONFIRM_FAILED_DECRYPT_DATA`.
  3. Load the target transaction by UUID from the decrypted `orderId`: `\Drupal::service('entity.repository')->loadEntityByUuid('transaction', $objPmReq->orderId)` (line 65).
  4. Map MobilPay `action` → internal `ext_status`: `confirmed`→PAID; `confirmed_pending`/`paid_pending`/`paid`→PENDING; `canceled`→CANCELLED; `credit`→REFUNDED; unknown action or non-zero `errorCode`→CANCELLED/permanent error (lines 66-125).
  5. If a transaction was loaded AND new `$status !== NULL` AND `$status !== $transaction->getStatus()`: `$transaction->set('ext_status', $status); $transaction->save();` then `updateTokenInRecurringPayment(...)` (lines 139-143). This save is what fires all downstream entity-hook side effects (see below).
  6. Emit an XML `<crc>` acknowledgement body back to MobilPay (200, `application/xml`) — success carries the errorMessage; failure carries `error_type`/`error_code` (lines 146-154).
- Main Steps (redirect/return path, `paymentResult`): load transaction by `uuid` via `loadByProperties(['uuid' => …])`; if none, `TrustedRedirectResponse('/')`; else render `#theme 'donation_payment_result'` with `#result = isPaid()?1:0`, child name, campaign image/url, and `drupalSettings` for the FE analytics (`NetopiaPaymentResultController::paymentResult`, lines 22-52). Read-only; performs NO status write.
- Postconditions: `transaction.ext_status` reflects the last differing MobilPay action; on first PAID the thank-you email flag and recurring-token/status side effects are applied (via entity hooks). Result page shows success/failure text.
- Side Effects (all triggered by `$transaction->save()` in step 5, via `TransactionEntity::preSave`/`postSave`):
  - Thank-you email on first PAID: `TransactionEntity::preSave` → `sendEmailThanksForPayment()` (gated `!isEmailSent() && isPaid()`), which calls `patron_base.smartmailing::handleMail(...)` with template `thanks_for_recurring_payment` / `thanks_for_payment` / `thanks_for_payment_transparent` (`TransactionEntity.php` lines 612-624, 726-761).
  - Blocked-owner activation email: if owner `isBlocked()`, `account::sendActivationEmail($sender,'supporter')` in preSave (lines 615-616).
  - Slack notification — ONLY when `Settings::get('country') == 'cz'` (`sendSlackNotification()`, preSave line 619-622; hard-coded webhook + `logger.slack->sendMessageToZoneChannel`, lines 783-803). Not fired for RO/MD Netopia traffic (see Multi-tenant note).
  - Elasticsearch reindex: `postSave` → `patron_base.default->addToQueue('transaction', id)` → `es_upload_queue` (lines 635, `PatronBaseService::addToQueue` 416-426).
  - Campaign raised-money recompute + save: `postSave` reloads `getCampaign()` and calls `$campaign->save()` (line 693); `CampaignEntity::getCampaignRaisedMoney()` sums `transaction.price WHERE ext_status='PAID'` (lines 1073-1099).
  - Overpayment auto-split: in `postSave`, if `raised > gift_price`, price is reduced, transaction re-saved, and a duplicate transaction to the `transparent_account` campaign is created (lines 658-693). Money/VAT-sensitive.
  - Recurring token capture: `updateTokenInRecurringPayment()` writes `token_id` + `token_expiration_date` onto the linked `transaction_recurring` (controller lines 157-163).
  - Recurring status activation on PAID: `postSave` → `updateRecurringStatus()` sets `transaction_recurring.status = 1` (lines 697-698, 703-711).
- Integration Calls:
  - Inbound IPN decrypt from Netopia/MobilPay via `Mobilpay_Payment_Request_Abstract::factoryFromEncrypted` (`NetopiaConfirmController::confirm`).
  - Outbound gateway hand-off (upstream of this flow): `NetopiaRedirectForm::buildForm` posts the encrypted card request to `https://secure.mobilpay.ro` / `https://sandboxsecure.mobilpay.ro` (lines 46-49, 129).
  - Slack webhook `hooks.slack.com/services/…` (redacted) via `sendSlackNotification` (CZ only).
  - SmartMailing/Mautic via `patron_base.smartmailing::handleMail` (email delivery).
- Failure Modes:
  - No idempotence guard on the confirm handler beyond `$status !== $transaction->getStatus()`. A repeated IPN with the SAME action is a no-op (email/side-effects re-suppressed by the status-equality check + `is_email_sent`), BUT a PENDING→PAID→(late)PENDING sequence, or any alternating action, will re-run the full save + side-effect chain each time it differs. `Idempotence` risk.
  - No signature/authenticity check beyond successful private-key decryption; the endpoint is `_permission: access content` (public). Anyone able to produce a payload decryptable with the merchant private key is trusted; no replay nonce. `Security` risk.
  - `$transaction` may be unset if `loadEntityByUuid` returns NULL for a valid decrypt — guarded by `isset($transaction)` before save (line 139), so a decrypted-but-unknown orderId silently returns a success CRC without any write (`Hypothesis`: could ACK a payment the system never records).
  - `NetopiaRedirectForm::buildForm` swallows encryption exceptions in an empty `catch(Exception $e){}` (lines 131-133); if `encrypt()` throws, `$objPmReqCard` is used uninitialised for `getEnvKey()` → fatal/blank form. `Hypothesis`.
  - Recurring token write assumes `objPmNotify->token_id` present; absent → skipped (controller line 158). No error if a recurring txn never captures a token.
  - `paymentResult` chains `getCampaign()?->getApplication()?->getChild()->getName()` — the final `getChild()->getName()` is NOT null-safe; a campaign with an application but no child would fatal (line 33). `Hypothesis`.
  - Merchant signature `2PRX-STYV-Z2ZE-P6T5-UD9Q` is hard-coded in `NetopiaRedirectForm` (line 67) and `NetopiaCron` (line 112); recurring SOAP password is hard-coded/obfuscated in `NetopiaCron::createNetopiaTransaction` (line 150). `Security` — flagged for target hardening, not a current-behavior defect.

## C. Data Footprint
- Entities Written:
  - `transaction` — `ext_status` set to PAID/PENDING/CANCELLED/REFUNDED (`NetopiaConfirmController::confirm` line 140); `is_email_sent` set TRUE on first PAID (`TransactionEntity::sendEmailThanksForPayment` line 760); `price` possibly reduced + a duplicate `transaction` row created on overpayment split (`postSave` lines 667-679).
  - `transaction_recurring` — `token_id`, `token_expiration_date` (controller `updateTokenInRecurringPayment` lines 159-160); `status = 1` on PAID (`updateRecurringStatus` line 709).
  - `campaign` — re-`save()`d (raised-money/cache recompute) in `TransactionEntity::postSave` (line 693); original campaign also re-saved on campaign change (line 652).
  - `queue` (`es_upload_queue`) — item appended for Elasticsearch reindex (`PatronBaseService::addToQueue`).
  - `voucher` — NOT written by this flow directly (`updateVoucherStatus`/`generateMultipleVouchers` exist on the entity but are not invoked from the Netopia confirm/postSave path). `Confirmed` absence in this trace.
- Entities Read:
  - `transaction` (by UUID = MobilPay orderId) — controller line 65, form line 39, result controller lines 23/65.
  - `transaction_recurring` (by `transaction_id`) — `getTransactionRecurring`, `updateRecurringStatus`.
  - `campaign` (+ `application` → child) for raised money and result-page rendering.
  - `user` (owner) for email/blocked-state, magic link, and result `drupalSettings`.
- Constraints involved:
  - `transaction.uuid` — framework unique key; used as the cross-system correlation id (soft-FK to MobilPay orderId, not a declared DB FK). Evidence: `_ar/evidence/db-models.md` transaction section.
  - `transaction.message_id` uniqueness — enforced app-level only in `TransactionEntity::preSave` (throws), NOT a DB unique key (lines 595-599). Not exercised on IPN status update (message_id unchanged) but relevant to the overpayment-split duplicate (which sets `message_id = NULL`, line 677).
  - Indexes over `ext_status` exist (`transaction_campaign_is_sent_to_bank`, `…_ext_status_test`) — read-side, not a uniqueness guard on payment idempotence.
- Multi-tenant scope assumptions:
  - Netopia is the RO gateway (RO region). BUT the Slack thank-you notification in `preSave` is gated `Settings::get('country') == 'cz'` (lines 619-622) — so RO Netopia payments do NOT emit the Slack notice; the Slack message text also hard-codes "Kč … přes comgate" (CZK/ComGate wording) — copy is CZ-specific. Cross-tenant coupling: the shared `TransactionEntity` hook chain runs identically regardless of gateway.
  - `Settings::get('environment')` (prod/sandbox host + key paths) and `Settings::get('transparent_account')`, `Settings::get('country')` are per-deploy env guards.

## D. Evidence Block
- Controller paths:
  - `netopia/src/Controller/NetopiaConfirmController.php` — `confirm()` (IPN), `updateTokenInRecurringPayment()`.
  - `netopia/src/Controller/NetopiaPaymentResultController.php` — `paymentResult()`, `getTitle()` (browser return, read-only).
- Service methods:
  - `netopia/src/NetopiaService.php::post()` — a curl POST helper to mobilpay.ro; note it is a leftover/boilerplate (hard-coded `XXXX-XXXX…` signature, `orderId = md5(uniqid(rand()))`, `http://your.confirm.url`, reads `$_POST['billing_*']`). Not on the confirm/redirect request path; the live redirect is built by `NetopiaRedirectForm`. `Partial` — appears dead/boilerplate.
  - `transaction/src/Entity/TransactionEntity.php` — `preSave()` (email/Slack/message-id guard), `postSave()` (ES queue, campaign save, overpayment split, `dispatchStatusChangeEvent`, `updateRecurringStatus`), `isPaid()`, `getStatus()`, `getTransactionRecurring()`, `getCampaign()`, `sendEmailThanksForPayment()`, `sendSlackNotification()`, `updateRecurringStatus()`.
  - `campaign/src/Entity/CampaignEntity.php::getCampaignRaisedMoney()` — SUM(price) WHERE ext_status='PAID' (lines 1073-1099).
  - `patron_base/src/PatronBaseService.php::addToQueue()` — `es_upload_queue` enqueue with dedup check (lines 416-426).
- Repository usage:
  - `\Drupal::service('entity.repository')->loadEntityByUuid('transaction', orderId)` (confirm controller line 65); `entityTypeManager()->getStorage('transaction')->loadByProperties(['uuid'=>…])` (result controller lines 23,65; redirect form via `entity.repository` line 39).
  - Raw SQL: `getCampaignRaisedMoney` (campaign), `getOriginalPrice`, message_id dup check in preSave; recurring cron raw SQL in `NetopiaCron`.
- Event listeners:
  - `TransactionEntity::dispatchStatusChangeEvent()` is fully COMMENTED OUT (lines 862-865) — `TransactionUpdateEvent::UPDATE_EVENT` ('transaction.update.event') is DEFINED (`transaction/src/Event/TransactionUpdateEvent.php:13`) but NEVER dispatched anywhere in custom code. FL028 (campaign_recommendation on PAID) is therefore DEAD for this flow. `Confirmed`.
- Async messages:
  - `es_upload_queue` (Drupal queue) for Elasticsearch reindex of the transaction — the only async hop; drained by SRV0016 SearchIndex-Processor. No `USE_QUEUE=FALSE` toggle observed on this path.
- Config evidence:
  - `netopia/netopia.routing.yml` — routes `netopia.redirect`, `netopia.confirm`, `netopia.story.result` (all `_permission: access content`).
  - `netopia/netopia.services.yml`, `netopia/netopia.libraries.yml` (`netopia/form_auto_submit` auto-submit JS `netopia/js/netopia.js`), `netopia/drush.services.yml` (recurring cron command `NetopiaCommands`/`NetopiaCron`).
  - `Settings::get('environment'|'country'|'transparent_account'|'spa_url'|'backend_url')` env config; key files `netopia.private.key` / `netopia.public.cer` at `DRUPAL_ROOT/../` (<redacted>).
