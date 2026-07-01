# FLW0006 — Create transaction / donate
> AR:FlowMiner dossier · 2026-07-01 · source FlowID FL020 · see [../flow-index.md](../flow-index.md)

## A. Header
- FlowID: FL020 (dossier FLW0006)
- Flow Name: Create transaction / donate
- Primary SRV: SRV0007
- Trigger Evidence: REST `POST /api/3.2/transaction` → `transaction/src/Plugin/rest/resource/v32/TransactionResource.php::post()` (`@RestResource id="transaction_rest_resource_32"`, config `config/rest.resource.transaction_rest_resource_32.yml` `status: true`, `authentication: [cookie]`). NOTE: the older `/api/transaction` (`transaction/src/Plugin/rest/resource/TransactionResource.php::post()`) is a **no-op stub** returning `new ResourceResponse([])` and is **disabled** (`config/rest.resource.transaction_rest_resource.yml` `status: false`). Real behavior lives in v3.2 only.
- Confidence Level: Confirmed

## B. Behavior Digest
- Trigger: Front-end donation POST to `/api/3.2/transaction` with `{payment_amount, campaign_id, user_email?, first_name?, last_name?, recurring?}`. Cookie auth; anonymous allowed.
- Preconditions: `payment_amount` numeric (`v32/TransactionResource.php:103`); `campaign_id` resolves to a `CampaignEntity` (`:109`); campaign NOT already completed — rejected if `campaign_raised >= gift_price` (`:114`).
- Main Steps (ordered, with evidence):
  1. Validate `payment_amount` is numeric → 400 on fail — `v32/TransactionResource.php:103`.
  2. Load campaign; 400 if missing — `:109`. Reject if completed (`campaign_raised >= gift_price`) → 400 — `:114`.
  3. Resolve donor identity — if a session user exists use it (`is_authenticated=TRUE`, `:124`); else validate email via `patron_base.default::isEmailValid` (`:136`), `AccountService::loadByEmail` (`account/src/AccountService.php:240`), and if not found `AccountService::register([...,'roles'=>['supporter']])` (`AccountService.php:34`) → creates `User` + `ContactEntity` (`AccountService.php:41,67`). If found but missing role, `addRole('supporter'); save()` (`:154`).
  4. If donor `User` is blocked, `AccountService::sendActivationEmail($user,'supporter')` (`:163`, again `:257` region path).
  5. Normalize price to int; floor to 1 for CZ (`price < 1 && country==='cz' → 1`) — `:167`.
  6. Create `TransactionEntity` with `ext_status='PENDING'`, `price`, `original_campaign=campaign`, `test=(env!==production)`, `ip_address`, `user_agent`, `is_authenticated`, `is_recurring` — `v32/TransactionResource.php:177`; `->save()` `:190`. Entity `preSave`/`postSave` fire (see C/entity hooks).
  7. If `recurring` truthy: create `TransactionRecurringEntity` (`payment_provider='comgate'`, `period='monthly'`, `status=0`, `day` = today, capped to 1 if >28) — `:201`; failures swallowed and logged to Telegram `:212`.
  8. `paymentGatewayCreateTransaction()` dispatches by `Settings::get('country')`: `md`→MAIB, `ro`→Netopia, else→ComGate — `:227`.
  9. Return `{status:'successful', payment_gateway_redirect_url, user_id}` (`user_id` = donor UUID only when blocked) — `:220`.
- Postconditions: A `transaction` row exists with `ext_status='PENDING'` and `ext_trans_id` set by the gateway (ComGate/MAIB); recurring row (status=0) if requested; the client is handed a gateway redirect URL. Money is NOT captured here — capture/settlement is confirmed later by the gateway webhook (FL021 ComGate / FL022 MAIB / FL023 Netopia) flipping `ext_status` to PAID.
- Side Effects:
  - New `User` + `ContactEntity` for first-time anonymous donors; role `supporter` granted (`AccountService::register`; `v32/TransactionResource.php:147,155`). **Cross-context write** (payment flow mutating Identity/CRM).
  - Activation email to blocked donors (`AccountService::sendActivationEmail`, `:163`).
  - `TransactionEntity::postSave` enqueues search-index item via `patron_base.default::addToQueue('transaction', id)` → default queue `es_upload_queue` (`TransactionEntity.php:635`; `PatronBaseService.php:416`).
  - `TransactionEntity::postSave` calls `$campaign->save()` (`TransactionEntity.php:693`), which runs `CampaignEntity::preSave` → `updateCampaignRaisedMoney()` recompute (`CampaignEntity.php:919,1101`) and campaign enqueue (`CampaignEntity.php:979`). At creation `ext_status=PENDING`, so raised total (PAID-only SQL) is unchanged and auto-complete does not trigger yet.
  - Overpayment auto-split in `postSave` (`TransactionEntity.php:663-689`): if campaign raised > needed, reduce this tx price and clone remainder into the transparent-account campaign (`Settings::get('transparent_account')`), invalidate cache tags. Guarded by PAID-only raised total, so effectively dormant during PENDING creation.
  - Thank-you email + CZ Slack post fire in `preSave` **only when** `!isEmailSent() && isPaid()` (`TransactionEntity.php:612`) — not on PENDING creation; belongs to the webhook flow.
  - Telegram error logs on recurring-create failure and ComGate exception (`v32/TransactionResource.php:212,319`).
- Integration Calls (external systems + calling symbol):
  - ComGate (CZ) — `AgmoPaymentsSimpleProtocol::createTransaction()` via `paymentComgateTransaction()` (`v32/TransactionResource.php:288`).
  - MAIB (MD) — `maib` service `->post($post_fields)` via `paymentMaibTransaction()` (`v32/TransactionResource.php:249`); redirect to `maib.ecommerce.md .../ClientHandler`.
  - Netopia/MobilPay (RO) — no direct client call here; sets PENDING and builds redirect `Settings::get('backend_url') . '/transaction/netopia/redirect/{uuid}'` (`v32/TransactionResource.php:271`).
  - Slack webhook (hardcoded URL) + `logger.slack` zone channel — only via `TransactionEntity::sendSlackNotification()` on PAID (`TransactionEntity.php:793`), i.e. webhook flow, not this trigger.
  - Search index queue → Elasticsearch/App Search (async, via addToQueue).
- Failure Modes:
  - **ComGate branch is broken code** — `paymentComgateTransaction()` references `$price`, `$campaign_name`, `$user_email`, `$embedded`, `$initRecurring`, `$data` which are locals of `post()` and are **out of scope** in this private method (`v32/TransactionResource.php:288-320`). Would raise undefined-variable warnings / send empty label & amount to ComGate; the `catch` logs "Comgate error" but `return`s a ResourceResponse from inside a `void` helper (ignored), so `post()` still returns `successful` with `redirectUrl=null`. `Hypothesis` on exact runtime effect; the scoping defect itself is Confirmed by reading.
  - No idempotency on donation creation: repeated POSTs create duplicate PENDING transactions (no request key; `message_id` unique-guard in `TransactionEntity::preSave:596` is null for this path so it does not apply). Risk: Idempotence.
  - Recurring-row creation failure is swallowed (`:211`) — recurring intent silently lost.
  - MAIB branch: if `maib_response` lacks `TRANSACTION_ID`, `redirectUrl` stays null and `post()` still returns `successful` (`v32/TransactionResource.php:251`).
  - Gateway/network exceptions on ComGate caught; MAIB/Netopia paths unguarded around the save/redirect build.
  - Anonymous registration failure (`AccountService::register` returns FALSE on validation error, `AccountService.php:61`) is not re-checked — subsequent `$this->currentUser->id()` would fatal. `Hypothesis`.

## C. Data Footprint
- Entities Written:
  - `transaction` (base_table `transaction`) — new row: `price`, `original_price` (set in preSave `TransactionEntity.php:593`), `user_id`, `campaign`, `original_campaign`, `ext_status='PENDING'`, `ext_trans_id` (post-gateway), `test`, `ip_address`, `user_agent`, `is_authenticated`, `is_recurring`, `transparent` (if campaign == `transparent_account`, preSave `:607`).
  - `transaction_recurring` — optional new row (`status=0`, `period='monthly'`, `day`) `v32/TransactionResource.php:201`.
  - `user` (users_field_data) — created and/or role `supporter` added for anonymous donors (`AccountService.php:64`; `v32/TransactionResource.php:147,156`).
  - `contact` — created alongside new user (`AccountService.php:67-79`).
  - `campaign` — re-saved in `TransactionEntity::postSave` (`:693`); `campaign_raised` / `campaign_percentual_raised` recomputed in `CampaignEntity::preSave` (`:1101`).
  - `queue` (Drupal queue table) — `es_upload_queue` item for the transaction (and campaign) via `addToQueue`.
  - `campaign_slug_archive` — only if campaign name changed during that save (`CampaignEntity.php:941`); not expected on donation.
- Entities Read: `campaign` (load + gift_price/campaign_raised gating `v32/TransactionResource.php:109-114`), `user` (session/currentUser), transaction raised-money SQL over `transaction` (`CampaignEntity::getCampaignRaisedMoney` PAID-only `:1091`), `application` (via `campaign->getApplication()` only in PAID thank-you path).
- Constraints involved: `transaction` has NO DB unique key; message_id uniqueness is **app-level only** (preSave throws, `TransactionEntity.php:596`) and inert on this path. Indexes: `transaction_campaign_is_sent_to_bank`, `transaction_..._ext_trans_id_...`, stale-named `(id,bank_vs,is_sent_to_bank)` (per `_ar/evidence/db-models.md` transaction §). `parent` is a soft self-FK (divided transactions). Campaign `min_price`/`gift_price` validation on campaign side, not enforced on donation amount (only `>=1` floor for CZ).
- Multi-tenant scope assumptions: Gateway chosen purely by `Settings::get('country')` ∈ {cz,ro,md} (`v32/TransactionResource.php:228`); currency hardcoded per branch (ComGate `CZK`, MAIB `498`/MDL). CZ-only minimum-1 floor (`:168`) and CZ-only Slack (`TransactionEntity.php:620`). `test` flag driven by `Settings::get('environment')`. Single Drupal instance per country (per integrations.md §10).

## D. Evidence Block
- Controller paths: `transaction/src/Plugin/rest/resource/v32/TransactionResource.php` (active, `/api/3.2/transaction`); `transaction/src/Plugin/rest/resource/TransactionResource.php` (disabled no-op stub, `/api/transaction`).
- Service methods: `AccountService::register` / `::loadByEmail` / `::sendActivationEmail` / `::getUserMagicLink` (`account/src/AccountService.php:34,240,254,274`); `PatronBaseService::isEmailValid` / `::addToQueue` (`patron_base/src/PatronBaseService.php:114,416`); `APIMailingService::handleMail` (`patron_base/src/APIMailingService.php:67`, PAID path); `maib` service `->post` (`maib` module); `AgmoPaymentsSimpleProtocol::createTransaction` (`comgate/src/AgmoPaymentsSimpleProtocol.php`).
- Repository usage: `CampaignEntity::load`, `TransactionEntity::create/save`; raw SQL for raised-money (`CampaignEntity.php:1079,1091`), message_id dup-check (`TransactionEntity.php:597`), queue dup-check (`PatronBaseService.php:417`).
- Event listeners: `TransactionEntity::dispatchStatusChangeEvent()` is present but **commented out / dead** (`TransactionEntity.php:862-865`) — the `TransactionUpdateEvent::UPDATE_EVENT` (FL028 recommendation) is NOT dispatched from this flow in current code. `Confirmed` (dead code).
- Async messages: `es_upload_queue` (search index) enqueued in postSave; drained by cron/`patron_search:upload_to_es` (SRV0016). Recurring charges are a separate cron flow (FL024). No queue for the donation creation itself (synchronous request → gateway).
- Config evidence: `config/rest.resource.transaction_rest_resource_32.yml` (`status:true`, POST/json/cookie); `config/rest.resource.transaction_rest_resource.yml` (`status:false`); `transaction/transaction.routing.yml` (admin/divide routes only — REST route is plugin-derived); `transaction/transaction.services.yml`; `Settings::get('country'|'environment'|'comgate'|'transparent_account'|'backend_url')`.
