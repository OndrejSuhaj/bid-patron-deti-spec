# FLW0018 — Voucher apply / validate
> AR:FlowMiner dossier · 2026-07-01 · source FlowID FL026 · see [../flow-index.md](../flow-index.md)

## A. Header
- FlowID: FL026 (dossier FLW0018)
- Flow Name: Voucher apply / validate
- Primary SRV: SRV0011
- Trigger Evidence: REST resource plugins (no `voucher.routing.yml` entry):
  - `voucher/src/Plugin/rest/resource/VoucherValidationResource.php::post` (URI `POST /api/2.2/voucher/validate`)
  - `voucher/src/Plugin/rest/resource/VoucherApplyResource.php::post` (URI `POST /api/2.2/voucher/apply`)
  - v32 twins: `voucher/src/Plugin/rest/resource/v32/VoucherValidationResource.php::post` (`/api/3.2/voucher/validate`), `voucher/src/Plugin/rest/resource/v32/VoucherApplyResource.php::post` (`/api/3.2/voucher/apply`)
  - Enabled via `config/rest.resource.voucher_{validation,apply}_resource[_v32].yml`
- Confidence Level: Confirmed

## B. Behavior Digest
- Trigger: Anonymous or authenticated SPA client POSTs JSON to the four REST endpoints. Two operations: **validate** (lookup by UUID, read-only) and **apply** (bind a paid voucher to a campaign/story, mutating). Note the URI prefix says `2.2`/`3.2` while the class docblocks/flow-index label them `/api/voucher/*`; the config-enabled URIs are the `2.2`/`3.2` ones (`VoucherValidationResource.php:18`, `VoucherApplyResource.php:20`).
- Preconditions:
  - Validate: request body has non-empty `voucher_id` (treated as **UUID**). Voucher must exist with `status = 1` (paid) AND `is_applied = 0` (`VoucherValidationResource.php:116-120`).
  - Apply: body has non-empty `voucher_id` (here treated as **name / code**, not UUID — inline comment `// je v tom sileny zmatek` at `VoucherApplyResource.php:89`) and non-empty `campaign_id`; the referenced `campaign` entity must load; voucher must exist by `name`, not already applied (`is_applied != 1`), and `status != 0` (paid) (`VoucherApplyResource.php:89-114`).
  - Upstream precondition (voucher must first be paid): voucher `status` flips 0→1 only after ComGate marks the funding transaction `PAID` — `transaction/src/Entity/TransactionEntity.php::updateVoucherStatus` (line 806) called from `comgate/src/Controller/TransactionStatusUpdate.php:57`. This is FL021's boundary; recorded here as the state gate.
- Main Steps:
  - **Validate**: 1) read `data['voucher_id']`; 400-equivalent JSON `{status:failed}` if empty (`VoucherValidationResource.php:96`). 2) `getVoucherByUuid` → `patron_base.default->getStorage('voucher')->loadByProperties(['uuid'=>…,'status'=>1,'is_applied'=>0])` (`:115-122`). 3) If found return `{status:valid, voucher_code, expiration, price}`; else `{status:invalid}` (`:102-112`). Expiration formatted `Y-m-dT23:59:59` from the `expiration` timestamp (`:136-143`). No mutation.
  - **Apply**: 1) read `voucher_id` (as code) + `campaign_id` (+ `email` in 2.2 only); guard empties (`VoucherApplyResource.php:93-98`). 2) `CampaignEntity::load($campaign_id)`; fail if null (`:100-103`). 3) `getVoucherByName` → `loadByProperties(['name'=>code])` (`:135-140`). 4) fail if not found / already applied / `status==0` (`:106-114`). 5) mutate voucher: `campaign = campaign->id()`, `is_applied = 1`, `applied = time()`; in 2.2 also `recipient_email = email` when `patron_base.default->isEmailValid($email)` (`:116-121`); `$voucher->save()` (`:122`). 6) propagate to linked transaction: if `voucher.transaction.entity` present, set its `campaign` and save (`:124-127`; v32 uses `$voucher->getTransaction()` at `v32/VoucherApplyResource.php:115,122-125`). 7) `$voucher->sendEmailApplied()` (`:130`). 8) return `{status:successful}`.
- Postconditions: Validate — none. Apply — voucher is bound to a campaign, marked applied (`is_applied=1`, `applied=<ts>`), optionally has `recipient_email` set; the linked transaction is re-pointed to the same campaign; a confirmation email is dispatched.
- Side Effects:
  - DB write to `voucher` row (apply only) and cascaded write to the linked `transaction` row's `campaign` field.
  - Outbound email via `patron_base.smartmailing` (`VoucherEntity.php::sendEmailApplied` line 391, template `voucher_to_buyer_applied`, recipient = `getTransaction()->getTransactionEmail()`).
  - All responses set `#cache => false` (uncacheable) via `addCacheableDependency` (throughout both resources).
- Integration Calls:
  - `sendEmailApplied` → `patron_base.smartmailing` (SmartMailing / APIMailingService transactional email). External Integration.
  - No payment-gateway call in this flow. (ComGate/Mautic/Slack calls belong to the upstream *buy* path: `VoucherEntity::sendEmailBuy`/`sendSlackNotification`/`getEmailAttachment` hit Mautic API `https://m.patrondeti.cz/api` and Slack webhook, but those fire from `TransactionEntity::updateVoucherStatus`, not from apply/validate.)
- Failure Modes:
  - Missing `voucher_id`/`campaign_id`/invalid campaign/unknown code/already-applied/unpaid → JSON `{status:failed|invalid}` with **HTTP 200** in every branch (no non-200 error codes). Failure signaled only in body.
  - Apply resolves the voucher by **name** with **no unique constraint** on `voucher.name` (db-models: "name … no unique key"), and `getVoucherByName` does `reset()` on the result set → if duplicate codes exist, an arbitrary matching voucher is applied. Correctness/Idempotence risk.
  - No DB transaction / locking around the check-then-set on `is_applied`: concurrent apply calls for the same code can both pass the `is_applied != 1` guard before either saves (TOCTOU double-apply). Idempotence/Money risk.
  - Apply's paid-guard is `status == 0` (rejects unpaid); validate's guard is stricter (`status == 1`). Asymmetric filters mean a voucher with unexpected status handling could differ between the two ops.
  - `sendEmailApplied` dereferences `$this->getTransaction()->getTransactionEmail()` (`VoucherEntity.php:396`) with no null-guard → fatal if the voucher has no linked transaction. (Vouchers created via `VoucherTransactionService::createVoucher` always link a transaction, so normally non-null.)
  - Email set on apply uses request-supplied `email` only when `isEmailValid`; invalid email is silently dropped (no error).

## C. Data Footprint
- Entities Written: `voucher` (fields `campaign`, `is_applied`, `applied`, `recipient_email` [2.2 only]) — apply only; `transaction` (field `campaign`) — apply only, cascaded.
- Entities Read: `voucher` (by `uuid` for validate, by `name` for apply); `campaign` (`CampaignEntity::load`); `transaction` (via `voucher.transaction` reference); `user` (indirectly via `transaction.getTransactionEmail` / `voucher.getOwner`).
- Constraints involved: `voucher.name` string(50), **no unique key** (db-models.md line 719) — code collisions possible. `voucher.status` boolean (paid gate). `voucher.is_applied` boolean default FALSE (single-use gate). `voucher.transaction` entity_reference → `transaction`. `voucher.campaign` entity_reference → `campaign` (label "Příběh"/Story). `voucher.expiration`/`applied`/`reminded` timestamps.
- Multi-tenant scope assumptions: **No tenant/country filter** in any query. Voucher lookup is global by uuid/name; campaign binding accepts any loadable `campaign_id`. Cross-country voucher→campaign binding is not prevented in code (Multi-tenant risk). Voucher creation is CZ/CZK/Comgate-only (`VoucherTransactionService.php:160-171`), so vouchers are effectively CZ-scoped by origin, but apply does not enforce it.

## D. Evidence Block
- Controller paths (REST resource plugins):
  - `web/modules/custom/voucher/src/Plugin/rest/resource/VoucherValidationResource.php` (`post`, `getVoucherByUuid`, `getExpirationDate`)
  - `web/modules/custom/voucher/src/Plugin/rest/resource/VoucherApplyResource.php` (`post`, `getVoucherByName`)
  - `web/modules/custom/voucher/src/Plugin/rest/resource/v32/VoucherValidationResource.php`, `.../v32/VoucherApplyResource.php` (functionally identical; v32 apply drops the `email` param and uses `$voucher->getTransaction()`)
- Service methods:
  - `voucher/src/Entity/VoucherEntity.php::sendEmailApplied` (391), `::getTransaction` (128), `::getName` (77), `::getPrice` (114), `::getRecipientEmail` (121), `::getValidationLink` (185).
  - `patron_base.default` (PatronBaseService) `->getStorage('voucher')`, `->isEmailValid()`; `patron_base.smartmailing` (APIMailingService) `->handleMail(...)`.
  - Upstream state gate (not in-flow, cited for preconditions): `transaction/src/Entity/TransactionEntity.php::updateVoucherStatus` (806, flips voucher `status`→1 + `sendEmailBuy`/`sendSlackNotification`), `::generateMultipleVouchers` (828), `::getVoucher` (854); voucher-creation services `voucher/src/VoucherTransactionService.php::executePayment`/`createVoucher` and `voucher/src/VoucherCartService.php::orderVouchersOnline` (both register/reuse user, create `transaction` with `is_voucher=1`, call ComGate `AgmoPaymentsSimpleProtocol::createTransaction`).
- Repository usage: no dedicated repository; direct `EntityStorage::loadByProperties` via `patron_base.default->getStorage('voucher')` and `CampaignEntity::load` / `TransactionEntity::load`.
- Event listeners: none in this flow. `TransactionEntity::dispatchStatusChangeEvent` is commented out (`TransactionEntity.php:862-865`); voucher post-payment work is called imperatively from the ComGate webhook controller, not via events.
- Async messages: none for apply/validate. (Buy-side `sendEmailBuy`/`sendReminder` carry `// ToDo: move to Rabbit MQ` comments — currently synchronous.)
- Config evidence:
  - `config/rest.resource.voucher_validation_resource.yml`, `..._apply_resource.yml`, `..._validation_resource_v32.yml`, `..._apply_resource_v32.yml` — all `methods: [POST]`, `formats: [json]`, `authentication: [cookie]`.
  - `config/user.role.anonymous.yml` grants `restful post voucher_apply_resource`, `..._v32`, `voucher_validation_resource`, `..._v32` (lines 173-176) and enables the resource dependencies (76-79). **Anonymous users can call apply/validate** despite `authentication: cookie` config — Security/boundary finding. `config/user.role.authenticated.yml` also grants apply (79-80).
  - `web/modules/custom/voucher/voucher.services.yml` — `voucher.transaction`, `voucher.cart` (apply/validate resources use `\Drupal::service('patron_base.default')` directly, not these).
  - Entity definition: `voucher/src/Entity/VoucherEntity.php` (`base_table = "voucher"`, entity keys, `baseFieldDefinitions` 193-388). DB shape: `_ar/evidence/db-models.md` §voucher (713+).
