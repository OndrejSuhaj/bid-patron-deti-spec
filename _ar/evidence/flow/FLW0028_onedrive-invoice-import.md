# FLW0028 — OneDrive invoice import
> AR:FlowMiner dossier · 2026-07-01 · source FlowID FL038 · see [../flow-index.md](../flow-index.md)

## A. Header
- FlowID: FL038 (dossier FLW0028)
- Flow Name: OneDrive invoice import
- Primary SRV: SRV0019
- Trigger Evidence: `onedrive:import:invoices` CLI command — `web/modules/custom/onedrive/src/Command/OnedriveCommand.php:35` (`configure()` sets name), registered via `web/modules/custom/onedrive/console.services.yml` (tag `drupal.command`).
- Confidence Level: Confirmed

> **Conflict — START hint correction.** The task START hint calls this a *Drush* command. The code is a **Drupal Console** command: it extends `Drupal\Console\Core\Command\Command` (`OnedriveCommand.php:11,22`) and is registered under the `drupal.command` tag in `console.services.yml`, not `drush.command` / a `.drush.services.yml`. Invocation is `drupal onedrive:import:invoices [limit] [savefiles] [errorsonly]`, not `drush`. Everything else in the hint (MS Graph OAuth2 ROPC, VS-based matching, `private://attachments_audit`) is confirmed accurate.

## B. Behavior Digest
- **Trigger:** Manual/scheduled CLI run of `onedrive:import:invoices` (`OnedriveCommand::configure()` at `OnedriveCommand.php:35`). Args: `limit` (default 10), `savefiles` (default `n`), `errorsonly` (default `n`). No route/hook/cron registration found in module — invoked externally (operator or external scheduler). `Confirmed` for CLI trigger; scheduling mechanism `Hypothesis` (no cron wiring in module).
- **Preconditions:**
  - Valid MS Graph access token obtainable via ROPC (`initialize()` at `OnedriveCommand.php:59-85`); hardcoded tenant/client/user credentials must be valid.
  - Target SharePoint/OneDrive drive + folder item id reachable (`OnedriveCommand.php:98`, drive `b!mU9GD8A0...`, folder item `01ZRWSK7...`).
  - `savefiles === 'y'` required to actually persist/attach; otherwise dry-run listing only (`OnedriveCommand.php:132-137`).
- **Main Steps** (ordered):
  1. Acquire user access token — POST `https://login.microsoftonline.com/{tenant}/oauth2/token`, `grant_type=password` (ROPC) via `\Drupal::httpClient()` (`OnedriveCommand.php:63,68-84`); `$this->graph->setAccessToken(...)`.
  2. List drive folder children — `graph->createCollectionRequest('GET', '/drives/{driveId}/items/{itemId}/children')`, return type `DriveItem`, page size = `limit` (`OnedriveCommand.php:98-101`).
  3. Per item: skip if name lacks `.pdf` (`OnedriveCommand.php:105-108`).
  4. Derive campaign VS/id from filename — `explode('_', str_replace('.pdf','',name))[0]` → `$campaign_vs`; `$campaign_id = substr($campaign_vs, 1)` (drops leading digit / VS prefix) (`OnedriveCommand.php:114-115`).
  5. Load campaign — `CampaignEntity::load($campaign_id)`; if null → `errorLite` and skip (`OnedriveCommand.php:122-126`).
  6. If `savefiles !== 'y'` → skip persistence (dry run) (`OnedriveCommand.php:132-137`).
  7. `saveFile($item, $campaign)` — download to `/tmp/{name}`, ensure `private://attachments_audit` dir, write via `file.repository::writeData()`, then resolve `campaign->getApplication()` and append file id to `application->attachments_audit[]`, `setNewRevision(FALSE)`, `application->save()` (`OnedriveCommand.php:145-176`).
- **Postconditions:**
  - New managed `file` entity created under `private://attachments_audit/{name}` (`OnedriveCommand.php:164`).
  - The campaign's associated `application` entity has the file id appended to its `attachments_audit` multi-value file field and is re-saved without a new revision (`OnedriveCommand.php:167-171`).
- **Side Effects (via `application->save()` → `ApplicationEntity::postSave`, `application/src/Entity/ApplicationEntity.php:197-226`):**
  - **Status event fan-out** — `dispatchStatusUpdateEvent()` unconditionally dispatches `ApplicationStatusUpdateEvent::STATUS_UPDATE_EVENT` (`ApplicationEntity.php:202,228-230`) → same 3-subscriber chain mined in [FLW0001](FLW0001_application-status-event-fanout.md)/FL005 (incl. transactional email dispatch [FLW0019](FLW0019_transactional-email-dispatch.md)). Fires even though only an attachment changed.
  - **Search re-index queue** — `patron_base.default->addToQueue('application', id)` (`ApplicationEntity.php:199`) → Elasticsearch index queue.
  - **Campaign status/category re-sync** — `updateCampaignStatus()` / `updateCampaignCategory()`; may re-save the campaign entity and emit a Telegram alert on campaign↔application status mismatch (`ApplicationEntity.php:206-219`).
  - Entity cache reset for the application (`ApplicationEntity.php:221`); possible `application_states` seed row if status == `new` (`ApplicationEntity.php:222-225`).
  - Leaves the temp file at `/tmp/{name}` (no cleanup after `file_get_contents`) (`OnedriveCommand.php:147,157`).
- **Integration Calls:**
  - MS identity platform token endpoint (`login.microsoftonline.com/{tenant}/oauth2/token`, ROPC) — `OnedriveCommand.php:68-80`.
  - MS Graph list children + download content — `OnedriveCommand.php:98,154-155` (`microsoft/microsoft-graph` SDK, per [../../repo-map/integrations.md](../../repo-map/integrations.md) §OneDrive).
  - Indirect: Elasticsearch (via queue), transactional email + Telegram (via `postSave` fan-out) — see Side Effects.
- **Failure Modes:**
  - Token POST failure / expired-invalid hardcoded ROPC credentials → uncaught exception, whole run aborts (no try/catch in `initialize()`, `OnedriveCommand.php:70-84`). `Confirmed`.
  - Graph list/download failure → uncaught exception (`OnedriveCommand.php:98-101,154-155`). `Confirmed`.
  - **Filename→id parse fragility** — `substr($campaign_vs,1)` blindly strips the first character of the VS; malformed names silently map to the wrong campaign or `< 0` id skip (`OnedriveCommand.php:114-120`). `$campaign_id < 0` guard compares a possibly non-negative substring; edge cases produce mismatched attachment. `Partial` (parse works for expected `V{id}_...pdf` pattern; not defensively validated).
  - Campaign with no associated application → `getApplication()` returns `false`/empty (`reset([])`), then `$application->attachments_audit[]` / `save()` on a non-object → fatal error (`OnedriveCommand.php:167-171`, `CampaignEntity.php:228-233`). No null-check. `Confirmed` risk.
  - No idempotency guard: re-running re-downloads and appends a **duplicate** file id to `attachments_audit` (multi-value, no dedupe) (`OnedriveCommand.php:169`). `Confirmed`.
  - `writeData()` returning falsy → logged `file_save_data error`, item skipped, no retry (`OnedriveCommand.php:172-175`). `Confirmed`.
  - `errorsonly` arg only suppresses success text; does not change persistence path (`OnedriveCommand.php:110-135`). `Confirmed`.

## C. Data Footprint
- **Entities Written:**
  - `file` (managed file) — created via `file.repository::writeData()` at `private://attachments_audit/{name}` (`OnedriveCommand.php:164`).
  - `application` — `attachments_audit` field appended, re-saved with `setNewRevision(FALSE)` (`OnedriveCommand.php:167-171`); field defined `application/src/Entity/ApplicationEntity.php:859-865` (file, private, unlimited cardinality — matches [../db-models.md](../db-models.md) `attachments_audit`).
  - `campaign` — possibly re-saved by application `postSave` campaign sync (`ApplicationEntity.php:206-219`). Secondary/indirect.
  - `application_states` — possible seed insert if status `new` (`ApplicationEntity.php:222-225`). Indirect edge case.
  - Filesystem temp — `/tmp/{name}` (not an entity; not cleaned up) (`OnedriveCommand.php:147,155`).
- **Entities Read:**
  - `campaign` — `CampaignEntity::load($campaign_id)` (`OnedriveCommand.php:122`).
  - `application` — `CampaignEntity::getApplication()` loads by property `campaign = {id}` via `patron_base.default` storage (`CampaignEntity.php:229-232`).
  - Remote read (not local entities): OneDrive `DriveItem` list + PDF content.
- **Constraints involved:**
  - `attachments_audit` = unlimited-cardinality file reference; no uniqueness constraint → duplicates possible (`ApplicationEntity.php:859-865`).
  - `campaign→application` is a load-by-property lookup returning the first match (`reset()`); assumes ≤1 application per campaign (`CampaignEntity.php:229-232`). No FK enforcement of 1:1.
  - Campaign id derivation depends on filename convention `V{campaign_id}_*.pdf` (implicit, undocumented).
- **Multi-tenant scope assumptions:**
  - No CZ/RO/MD region/tenant filter in the command; it processes **every** PDF in one hardcoded SharePoint drive/folder and attaches to whatever campaign the filename resolves to (`OnedriveCommand.php:98-138`). Cross-region misattachment possible if the folder mixes regions. `Multi-tenant` risk; `Partial` (single global drive assumed but not evidenced as region-scoped).

## D. Evidence Block
- Controller paths: n/a (CLI command, not a controller). Command: `web/modules/custom/onedrive/src/Command/OnedriveCommand.php` (`configure` :34-54, `initialize` :59-85, `execute` :90-142, `saveFile` :145-176).
- Service methods:
  - `\Drupal::httpClient()->post()` — ROPC token (`OnedriveCommand.php:63,70`).
  - `Microsoft\Graph\Graph::createCollectionRequest/createRequest` (`OnedriveCommand.php:98,154`).
  - `\Drupal::service('file_system')->prepareDirectory()` (`OnedriveCommand.php:159`).
  - `\Drupal::service('file.repository')->writeData()` (`OnedriveCommand.php:164`).
  - `CampaignEntity::getApplication()` (`CampaignEntity.php:228-233`) → `patron_base.default->getStorage('application')->loadByProperties(['campaign'=>id])`.
  - `ApplicationEntity::save()` → `postSave()` fan-out (`ApplicationEntity.php:197-226`).
- Repository usage: `file.repository` (managed file write); `patron_base.default` custom storage service (application load-by-property).
- Event listeners: none registered by `onedrive`. Downstream: `ApplicationStatusUpdateEvent::STATUS_UPDATE_EVENT` subscribers (see [FLW0001](FLW0001_application-status-event-fanout.md)) fire via `application->save()`.
- Async messages: `patron_base.default->addToQueue('application', id)` (Elasticsearch re-index) triggered by `postSave` (`ApplicationEntity.php:199`).
- Config evidence: `web/modules/custom/onedrive/onedrive.info.yml` (module `onedrive`, "OneDrive Integration"); `web/modules/custom/onedrive/console.services.yml` (Drupal Console command registration). **Hardcoded secrets** in `OnedriveCommand.php:65-77` — tenant id, client id, client secret, ROPC username/password — <redacted> here (see [../../repo-map/integrations.md](../../repo-map/integrations.md) §11 security note). Comment `// Create Contract` at `OnedriveCommand.php:168` is misleading — no contract entity is created; only an `attachments_audit` file attach.
