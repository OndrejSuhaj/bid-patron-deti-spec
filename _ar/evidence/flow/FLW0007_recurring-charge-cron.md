# FLW0007 — Recurring donation charge (cron)
> AR:FlowMiner dossier · 2026-07-01 · source FlowID FL024 · see [../flow-index.md](../flow-index.md)

## A. Header
- FlowID: FL024 (dossier FLW0007)
- Flow Name: Recurring donation charge (cron)
- Primary SRV: SRV0007
- Trigger Evidence: `hook_cron` — `comgate/comgate.module::comgate_cron()` (CZ) and `netopia/netopia.module::netopia_cron()` (RO), each instantiating `Drupal\comgate\ComgateCron::execute()` / `Drupal\netopia\NetopiaCron::execute()`
- Confidence Level: Confirmed

## B. Behavior Digest
- Trigger: Two independent Drupal `hook_cron` implementations, one per gateway/country. `comgate_cron()` gated to `environment=production` AND `country=cz` (`comgate/comgate.module`); `netopia_cron()` gated to `country=ro` (`netopia/netopia.module`). Each maintains a `\Drupal::state()` key (`comgate_cron_time` / `netopia_cron_time`) and self-throttles to run at most once per day, snapping the next window to `04:00:00`. First-ever run only seeds the state key and returns (no charge).
- Preconditions:
  - Cron window elapsed (`strtotime("+1 day", $last_check_time) <= time()`).
  - A `transaction_recurring` row where `day = date('j')` (day-of-month, with day `>28` folded to `1`), `canceled IS NULL`, and `(UNIX_TIMESTAMP() - COALESCE(last_recurring_payment,0)) > 86400*28` (≥28 days since last charge). Evidence: `ComgateCron::transactionRecurring()` L35; `NetopiaCron::transactionRecurring()` L28.
  - ComGate additionally requires the parent transaction's `ext_trans_id` (used as recurring/preauth id) — `ComgateCron` L39-43.
  - Netopia additionally requires `token_id IS NOT NULL AND token_expiration_date > NOW()` (SQL, `NetopiaCron` L28), plus a "cool-off": on day-fold days (`day>28 || day==1`) skip the user if their latest `is_recurring=1` `CANCELLED` transaction is ≤4 days old (`NetopiaCron` L34-42).
- Main Steps:
  1. Select due recurring ids via raw SQL over `transaction_recurring` (`ComgateCron` L35 / `NetopiaCron` L28).
  2. For each, `TransactionEntity::load($transactionId)` and `getTransactionRecurring()` (`transaction/src/Entity/TransactionEntity.php::getTransactionRecurring()` — loads recurring by `transaction_id`).
  3. Create a NEW child `TransactionEntity` copying price/user/campaign/flags with `ext_status='PENDING'`, `is_recurring=1`, and `$newTransaction->save()` (`ComgateCron` L53-68 / `NetopiaCron` L56-71). ComGate hardcodes `campaign=3100` / `original_campaign=3100` / `transparent=1`; Netopia routes to the live campaign if `active`, else falls back to `Settings::get('transparent_account')`.
  4. Call the gateway to charge:
     - ComGate: `AgmoPaymentsSimpleProtocol::createTransaction(...)` passing the parent's `ext_trans_id` as the final positional `$reccurringId` (`ComgateCron` L73-92). In `createTransaction` a non-null `$reccurringId` sets `initRecurringId` and POSTs to `paymentsUrl2` (the recurring endpoint) — `comgate/src/AgmoPaymentsSimpleProtocol.php` L160-207.
     - Netopia: `NetopiaCron::createNetopiaTransaction()` builds a MobilPay `doPayT` SOAP request using `transactionRecurring->getTokenId()` against `secure.mobilpay.ro` (prod) / `sandboxsecure.mobilpay.ro` (`NetopiaCron` L107-170).
  5. On success record `ext_trans_id` from the gateway on the new transaction (`getTransactionId()` / `doPayTResult->order->id`) and set `transaction_recurring.last_recurring_payment = time()` and save (`ComgateCron` L93-97 / `NetopiaCron` L76-84).
  6. Set the new transaction `ext_status` to `PAID` (optimistic) or `CANCELLED` (on exception / gateway error) and `save()` (`ComgateCron` L99-103 / `NetopiaCron` L92-103).
- Postconditions: One new `transaction` row per due schedule with `ext_status` ∈ {PAID, CANCELLED}. `transaction_recurring.last_recurring_payment` advanced only when the gateway call did not throw (ComGate) / returned a result (Netopia). Note: `last_recurring_payment` is NOT updated on the CANCELLED/failed branch, so a failed schedule remains "due" and will be retried on the next cron day (`ComgateCron` L93-101; `NetopiaCron` L83-90 vs L86-90).
- Side Effects (mostly fired implicitly via `TransactionEntity::preSave/postSave` when the new transaction is saved with `ext_status=PAID`):
  - Thank-you email — `preSave()` calls `sendEmailThanksForPayment()` when `isPaid() && !isEmailSent()`, choosing template `thanks_for_recurring_payment` (`TransactionEntity.php` L612-624, L726-762). Sent via `patron_base.smartmailing` (`APIMailingService::handleMail`).
  - Slack notification — CZ + production only: `sendSlackNotification()` posts to a hardcoded Slack webhook `<redacted>` and (if authenticated) the "ZONE" channel via `logger.slack` (`TransactionEntity.php` L614-616, L783-804).
  - Blocked-owner reactivation — if payer user `isBlocked()`, `\Drupal::service('account')->sendActivationEmail($sender,'supporter')` (`TransactionEntity.php` L607-610).
  - Campaign raised-money recompute — `postSave()` calls `$campaign->save()` recalculating raised money (`TransactionEntity.php` L656-693).
  - Overpayment auto-split — if `raised > gift_price`, `postSave()` mutates this transaction's price and creates a duplicate for the difference against `transparent_account`, invalidating cache tags (`TransactionEntity.php` L662-690).
  - ES index queue — `postSave()` → `patron_base.default->addToQueue('transaction', id, 'es_upload_queue')` (`TransactionEntity.php` L635; `PatronBaseService::addToQueue` L416).
  - `updateRecurringStatus()` on PAID (`TransactionEntity.php` L696-697, L703-711) — no-op for the new child (it has no own recurring row).
  - Netopia CANCELLED → dunning email — `NetopiaCron` L96-101 sends `cancelled_recurring_payment` to the user via `patron_base.smartmailing` (SmartMailing). ComGate has no equivalent dunning mail.
  - `transaction_recurring.last_recurring_payment` write (both) / no `canceled` write in this flow.
- Integration Calls:
  - ComGate (HTTP POST, curl) — `AgmoPaymentsSimpleProtocol::_doHttpPost()` to `paymentsUrl2` with `initRecurringId` (`comgate/src/AgmoPaymentsSimpleProtocol.php` L102, L160-207).
  - Netopia / MobilPay (SOAP `doPayT`) — `NetopiaCron::createNetopiaTransaction()` (`netopia/src/NetopiaCron.php` L107-170).
  - Telegram error alerting — `\Drupal::service('logger.telegram')->log(3, ...)` on missing data / recharge errors (`ComgateCron` L41,L45,L100; `NetopiaCron` L94,L161,L168).
  - Slack error/zone + SmartMailing email (transitively, via entity save — see Side Effects).
- Failure Modes:
  - **Optimistic PAID (money integrity):** ComGate marks the new transaction `PAID` merely because `createTransaction()` did not throw — but ComGate only returns a `transId` (charge is confirmed later by webhook FL021 `/transaction/status_update`). A pending/declined recurring charge is recorded locally as PAID (`ComgateCron` L52,L102). Netopia is safer: it inspects `doPayTResult->errors->code` (`NetopiaCron` L78-80) but still relies on the async `netopia/confirm` webhook (FL023) for the authoritative result.
  - **Idempotence gap:** No lock/claim on the recurring row while charging; `last_recurring_payment` is written only AFTER the gateway call. If cron overlaps or a save between charge-and-timestamp-write fails, the same schedule can be charged twice. The 28-day SQL guard is the only dedup, and it is not applied atomically.
  - **Failed charge not de-scheduled:** on exception/CANCELLED, `last_recurring_payment` is not advanced, so the schedule stays due and retries next cron day; no cancel of the `transaction_recurring` after repeated failures (`ComgateCron` L98-103; `NetopiaCron` L86-103).
  - **Unguarded child on early-continue:** loop `continue`s for missing `ext_trans_id`/recurring before creating `$newTransaction`; but if an exception is thrown before `$newTransaction` exists after entering the try, `$newTransaction` may be undefined at the trailing `set('ext_status',...)` — in practice `$newTransaction` is created first (L53/L56) so the risk is low but the ordering is fragile.
  - **Hardcoded secrets:** Netopia embeds a MobilPay account hash password and seller-account id in code (`NetopiaCron` L112, L150) `<redacted>`; ComGate Slack webhook hardcoded (`TransactionEntity.php` L797) `<redacted>`.
  - **Cron re-throws:** both `hook_cron` wrappers log then `throw $e`, so a single failing schedule can abort the whole Drupal cron run (`comgate.module` / `netopia.module` catch block). Note the per-schedule try/catch inside the cron class swallows charge errors, so this mainly affects setup/SQL errors.
  - **Hardcoded ComGate campaign 3100:** every CZ recurring charge is booked to campaign/original_campaign 3100 (transparent account), losing the original story attribution (`ComgateCron` L56-57).

## C. Data Footprint
- Entities Written:
  - `transaction` (new row per charge) — `price`, `user_id`, `campaign`, `original_campaign`, `transparent`, `is_recurring=1`, `test`, `ext_status` (PENDING→PAID|CANCELLED), `bank_vs`, `ip_address`, `user_agent`, `is_authenticated`, `is_embedded`, `ext_trans_id` (`ComgateCron` L53-103 / `NetopiaCron` L56-103). `original_price` set in `preSave` (L593). Possible extra split-transaction row + this row's `price` mutation via overpayment logic in `postSave`.
  - `transaction_recurring` — `last_recurring_payment` set to `time()` on success (`ComgateCron` L93-94 / `NetopiaCron` L83-84). (`status` may be set to 1 by `updateRecurringStatus`, but only for a transaction that itself owns a recurring row — not the new child.)
  - `campaign` — resaved (raised-money recompute) via `TransactionEntity::postSave` (L692) — cross-context write, see D/boundary.
  - Async queue row — `es_upload_queue` item for the new transaction.
- Entities Read:
  - `transaction_recurring` (raw SQL selection incl. `day`, `canceled`, `last_recurring_payment`, and RO `token_id`/`token_expiration_date`).
  - `transaction` (parent, `TransactionEntity::load`; RO also reads latest CANCELLED recurring transaction per user via raw SQL, `NetopiaCron` L35).
  - `campaign` (RO: status/id to decide target vs transparent, `NetopiaCron` L45-52).
  - `user` (owner email/phone via `getTransactionEmail()`/`getTransactionPhone()`; RO loads `User::load($uid)` for dunning mail, `NetopiaCron` L97).
- Constraints involved:
  - `transaction_recurring.name` and `token_expiration_date` `setRequired(TRUE)` (per db-models, Confirmed); `transaction_id` is the only entity_reference (soft-FK to `transaction`, no DB FK).
  - Selection guard `(now - last_recurring_payment) > 28d` acts as an application-level dedup, not a unique constraint — no uniqueness enforced on charges per period (Idempotence).
  - `transaction.message_id` uniqueness check exists in `preSave` (L596-600) but the cron does not set `message_id`, so it does not dedupe recurring charges.
- Multi-tenant scope assumptions:
  - ComGate cron: hard-gated `environment=production AND country=cz` (`comgate.module`). Netopia cron: hard-gated `country=ro` (`netopia.module`) — note Netopia has NO `environment=production` guard, so a non-prod RO instance would still attempt charges (using sandbox WSDL via `createNetopiaTransaction`'s env switch, `NetopiaCron` L108).
  - Currency hardcoded per tenant: ComGate `CZK` (`ComgateCron` L76), Netopia `RON` (`NetopiaCron` L142). No CZ path exists for MD/other; MD has no recurring cron in this flow (Confirmed absence in comgate/netopia).

## D. Evidence Block
- Controller paths: n/a (scheduler-triggered; no HTTP controller). Related webhooks that finalize the optimistic status live in FL021 (`comgate/src/Controller/TransactionStatusUpdate.php`) and FL023 (`netopia/src/Controller/NetopiaConfirmController.php`).
- Service methods:
  - `Drupal\comgate\ComgateCron::execute()` → `::transactionRecurring()` (`comgate/src/ComgateCron.php` L15-105).
  - `Drupal\netopia\NetopiaCron::execute()` → `::transactionRecurring()` / `::createNetopiaTransaction()` (`netopia/src/NetopiaCron.php` L17-170).
  - `Drupal\comgate\AgmoPaymentsSimpleProtocol::createTransaction()` / `getTransactionId()` (`comgate/src/AgmoPaymentsSimpleProtocol.php` L160-236).
  - `patron_base.smartmailing` (`APIMailingService::handleMail`, USE_QUEUE=FALSE → synchronous `doHandleMail`, `patron_base/src/APIMailingService.php` L16,L67-90).
  - `patron_base.default::addToQueue()` (`patron_base/src/PatronBaseService.php` L416).
  - `logger.telegram`, `logger.slack`, `account` (activation email) services.
- Repository usage: raw SQL via `\Drupal::database()->query(...)` for due-schedule selection and RO cool-off/latest-cancelled lookup (`ComgateCron` L35; `NetopiaCron` L28,L35). Entity storage via `TransactionEntity::load/create/save` and `patron_base.default->getStorage('transaction_recurring')->loadByProperties(...)` (`TransactionEntity::getTransactionRecurring`).
- Event listeners: `TransactionEntity::dispatchStatusChangeEvent()` is present but the dispatch is **commented out** (`TransactionEntity.php` L862-865) — the `TransactionUpdateEvent::UPDATE_EVENT` → `campaign_recommendation` path (FL028) is currently inert. `Hypothesis`: recommendation recompute does NOT fire from this flow in the current source.
- Async messages: `es_upload_queue` item enqueued on every transaction save (`postSave`). Mailing queue exists but is bypassed: `APIMailingService::USE_QUEUE = FALSE` (`patron_base/src/APIMailingService.php` L16) — emails send synchronously inside cron.
- Config evidence:
  - `Settings::get('comgate')` → `paymentsUrl`, `merchant`, `test`, `secret`, `paymentsUrl2` `<redacted>` (`ComgateCron` L21-29).
  - `Settings::get('environment')`, `Settings::get('country')`, `Settings::get('transparent_account')`, `Settings::get('backend_url')` (crons + `TransactionEntity`).
  - `\Drupal::state()`: `comgate_cron_time` / `netopia_cron_time` throttle keys.
  - No `*.routing.yml`/workflow yml participates (cron flow). Netopia SOAP endpoint env-switched inline (`NetopiaCron` L108); MobilPay account hash/sacId hardcoded `<redacted>` (`NetopiaCron` L112,L150).
