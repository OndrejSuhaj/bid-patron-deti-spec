# FLW0021 — Campaign publish / set-active
> AR:FlowMiner dossier · 2026-07-01 · source FlowID FL044 · see [../flow-index.md](../flow-index.md)

## A. Header
- FlowID: FL044 (dossier FLW0021)
- Flow Name: Campaign publish / set-active
- Primary SRV: SRV0005 (Campaign-&-Story-Lifecycle)
- Trigger Evidence: route `campaign.publish_controller_set_active` = `/admin/campaign/{id}/set-active` → `campaign/src/Controller/PublishController.php:setActive` (permission `edit campaign state`, `campaign.routing.yml:27-35`)
- Confidence Level: Confirmed

## B. Behavior Digest
- Trigger: Admin/editor clicks "set active" for a campaign (story). `GET /admin/campaign/{id}/set-active` → `PublishController::setActive($id)` (`campaign/src/Controller/PublishController.php:19`). Redirect target is taken from `HTTP_REFERER` (`PublishController.php:20`, `filter_var` only — see Failure Modes).
- Preconditions:
  - Caller has permission `edit campaign state` (`campaign.routing.yml:35`, `campaign.permissions.yml:15`).
  - Campaign entity loads by id (`CampaignEntity::load`, `PublishController.php:21`) and has a linked Application (`CampaignEntity::getApplication`, `CampaignEntity.php:228` → loads `application` by `campaign` = id). Missing application aborts with error message (`PublishController.php:23-26`).
  - `CampaignEntity::isReadyToActivate()` passes (`CampaignEntity.php:1416-1450`): patron_profile set; `gift_price` numeric > 0; `campaign_deadline` parses and is in the future; `photo`, `gift_photos`, and patron photo present; if `type != basic` or `parent` set then `status` (public flag) must not be 1. On failure it renders the accumulated Czech error markup via messenger and returns `FALSE` (aborts).
- Main Steps (ordered, each with evidence):
  1. Load campaign + resolve linked application (`PublishController.php:21-22`; `CampaignEntity.php:228-233`).
  2. Guard: application must exist (`PublishController.php:23`).
  3. Guard: `isReadyToActivate()` readiness checks (`PublishController.php:27`; `CampaignEntity.php:1416`).
  4. `CampaignEntity::activate()` (`PublishController.php:30`; `CampaignEntity.php:1459`): set `campaign_status='active'`; run `$this->validate()` (entity + field constraints). On any violation → add errors to messenger, return `FALSE`, abort (`CampaignEntity.php:1461-1467`). If `published` empty, stamp `published=time()` and `published_user_id=currentUser` (`CampaignEntity.php:1468-1471`). Then `$this->save()` (`CampaignEntity.php:1473`) which invokes campaign `preSave`/`postSave` (see below).
  5. campaign `preSave` (`CampaignEntity.php:915-949`): `updateCampaignRaisedMoney()` recomputes `campaign_raised` + `campaign_percentual_raised` from PAID transactions (`CampaignEntity.php:1101`, `1073`); if `isCampaignReadyToComplete()` (active AND raised ≥ gift_price, `CampaignEntity.php:1114`) it flips into completion (order=1000, prod-only success emails, `setApplicationComplete()`, `setComplete()`) — normally NOT the case at publish time but possible; slug handling: if no slug → `createSlug()`; if name changed vs `$this->original` → **archive old slug** into `campaign_slug_archive` (INSERT slug/campaign_id/user_id/campaign_name, `CampaignEntity.php:941-947`) then `createSlug()`.
  6. campaign `postSave` (`CampaignEntity.php:977-982`): `patron_base.default->addToQueue('campaign', id)` → enqueues to `es_upload_queue` (`PatronBaseService.php:416-426`); `dispatchStatusChangeEvent()` fires `CampaignUpdateEvent::UPDATE_EVENT` (`CampaignEntity.php:1014-1017`).
  7. Set application state active (`PublishController.php:34`): `$application->setState('active', TRUE, 'Zveřejněno {date}')` (`ApplicationEntity.php:292`) — sets `moderation_state` + `state`, inserts row into `application_states`, marks new revision.
  8. `$application->save()` (`PublishController.php:35`): triggers ApplicationEntity `postSave` (`ApplicationEntity.php:197`) → `addToQueue('application', id)` (ES index), `dispatchStatusUpdateEvent()` = `ApplicationStatusUpdateEvent::STATUS_UPDATE_EVENT` (**FL005**, 3 subscribers incl. email), `updateCampaignStatus()`/`updateCampaignCategory()` which can re-`save()` the campaign (`ApplicationEntity.php:206-220`).
  9. Success markup message added; `drupal_flush_all_caches()` (`PublishController.php:45`); send redirect to referer (`PublishController.php:46`).
- Postconditions: `campaign.campaign_status='active'`, `campaign.published` + `published_user_id` stamped (first activation only), `campaign_raised`/`campaign_percentual_raised` refreshed; linked `application.state='active'` with an `application_states` audit row and new revision; both entities enqueued for search indexing; caches flushed.
- Side Effects:
  - DB INSERT `campaign_slug_archive` only when campaign name changed since load (`CampaignEntity.php:941`).
  - Cache tag `number_of_campaigns` invalidated when status crosses active boundary (`CampaignEntity.php:240-248`).
  - Queue items into `es_upload_queue` for both campaign and application (search re-index).
  - `CampaignUpdateEvent` dispatched (no in-repo subscribers found — see Evidence Block).
  - `ApplicationStatusUpdateEvent` dispatched on application save → cascades to FL005 (notifications/scoring/other subscribers).
  - `drupal_flush_all_caches()` — full site cache rebuild on every successful activation (`PublishController.php:45`).
- Integration Calls:
  - Nager.Date public-holiday API `https://date.nager.at/api/v3/IsPublicHoliday/{date}/RO` — **only** when `Settings::get('country')==='ro'` and the `campaign_deadline` field constraint validates during `activate()->validate()` (`RomanianWorkingDayChecker.php:130-176`; constraint `CampaignDeadlineWorkingDayConstraintValidator.php:43-55`; field constraint attached at `CampaignEntity.php:570`). 5s timeout, `http_errors=false`, result cached (`RomanianWorkingDayChecker.php:130-143`).
  - Elasticsearch/App Search indexing is deferred (queue → `EsUploadQueue` worker, `patron_search`), not called inline.
- Failure Modes:
  - Missing application → error message, redirect, no change (`PublishController.php:23-26`).
  - `isReadyToActivate()` fails → Czech field-error markup, abort (`CampaignEntity.php:1441-1449`).
  - `activate()` validation violations (incl. RO working-day deadline) → errors added, `FALSE` returned, abort (`CampaignEntity.php:1461-1467`).
  - `HTTP_REFERER` used unvalidated as redirect (`filter_var` with no filter = passthrough) → open-redirect / null-referer risk (`PublishController.php:20`). `Security`.
  - Nager.Date API unreachable/timeout → checker logs warning and treats day as NON-holiday (`isPublicHolidayViaApi` returns FALSE on exception/non-200; `RomanianWorkingDayChecker.php:168-176`) — fail-open, so a genuine holiday can slip through when API is down.
  - `insertState` DB failure → logged to Telegram and re-thrown (`ApplicationEntity.php:322-324`).
  - No transaction wrapping across the two saves: campaign is saved+committed before application save; if application save throws, campaign is already active → inconsistent pair (`PublishController.php:30-35`). `Idempotence`/consistency.
  - `updateCampaignRaisedMoney()` in preSave overwrites `campaign_raised` on every save from PAID transactions (`CampaignEntity.php:1101-1111`).

## C. Data Footprint
- Entities Written:
  - `campaign` (base_table `campaign`): `campaign_status`, `published`, `published_user_id`, `campaign_raised`, `campaign_percentual_raised`, possibly `slug`, and on auto-complete `campaign_order`/`completed`/`is_email_sent` (`CampaignEntity.php:1459-1473`, `915-949`).
  - `application`: `moderation_state`, `state`, new revision; may be re-saved via cascade (`ApplicationEntity.php:292-310`, `197-226`).
  - `campaign_slug_archive` (raw table): INSERT on name change (`CampaignEntity.php:941-947`).
  - `application_states` (raw table): INSERT state-history row (`ApplicationEntity.php:318-321`).
  - `queue` (Drupal queue table, name `es_upload_queue`): INSERT items for campaign + application (`PatronBaseService.php:416-426`).
- Entities Read:
  - `campaign` (load by id), `application` (loadByProperties campaign=id) (`PublishController.php:21`, `CampaignEntity.php:228-233`).
  - `transaction` (SUM price WHERE campaign=id AND ext_status='PAID') for raised money (`CampaignEntity.php:1091-1098`).
  - `patron` (`patron_profile` reference), image `file` entities, `campaign_slug_archive`/`campaign` (slug uniqueness in `generateSlug`, `PatronBaseService.php:391-395`).
  - `user` (currentUser for `published_user_id`, state uid).
- Constraints involved:
  - Field constraint `campaign_deadline_working_day` on `campaign_deadline` (RO-only, external Nager.Date) (`CampaignEntity.php:570`; validator + service above).
  - Readiness invariants in `isReadyToActivate()` (patron, price>0, future deadline, required images, public-flag rule for non-basic/child stories).
  - Entity `validate()` run inside `activate()` (all base-field + attached constraints).
- Multi-tenant scope assumptions:
  - Country behavior driven by `Settings::get('country')` — RO enables working-day deadline validation (`CampaignDeadlineWorkingDayConstraintValidator.php:44`); URL prefix `/pribeh` (cz) vs `/story` (other) (`CampaignEntity.php:1024-1029`). Single-DB per-country deployment implied; no explicit tenant column filter in this flow. `Multi-tenant`.

## D. Evidence Block
- Controller paths:
  - `campaign/src/Controller/PublishController.php:19` (`setActive`).
  - `campaign/src/Controller/SlugHistoryController.php:19` (read-only viewer of `campaign_slug_archive`; NOT invoked by this flow — see Correction).
- Service methods:
  - `campaign/src/Entity/CampaignEntity.php`: `isReadyToActivate()`:1416, `activate()`:1459, `preSave()`:915, `postSave()`:977, `updateCampaignRaisedMoney()`:1101, `isCampaignReadyToComplete()`:1114, `createSlug()`:1410, `setCampaignStatus()`:240, `getApplication()`:228, `dispatchStatusChangeEvent()`:1014.
  - `patron_base/src/PatronBaseService.php`: `generateSlug()`:382, `addToQueue()`:416, `generateImage()`:289 (image processing exists but is invoked from `generateCampaignsImages()`, which is only called by `CampaignCron.php:303` and permission-gated manual path — NOT by set-active).
  - `campaign/src/Service/RomanianWorkingDayChecker.php`: `isWorkingDayForDateString()`:76, `fetchPublicHolidayFromApi()`:148.
  - `application/src/Entity/ApplicationEntity.php`: `setState()`:292, `insertState()`:312, `postSave()`:197, `updateCampaignStatus()`:1176, `complete()`:1235.
- Repository usage: `patron_base.default` (`Drupal\patron_base\PatronBaseService`, `patron_base.services.yml:12`) used as generic storage/queue/slug/image helper; direct `\Drupal::database()` raw SQL for slug archive, application_states, raised-money, queue dedupe.
- Event listeners: `CampaignUpdateEvent::UPDATE_EVENT` ('campaign.update.event') dispatched at `CampaignEntity.php:1016` — **no event_subscriber found in web/modules/custom** (grep clean); appears to have no active consumer. `ApplicationStatusUpdateEvent::STATUS_UPDATE_EVENT` dispatched at `ApplicationEntity.php:230` → FL005 subscribers (email/scoring). `Async`.
- Async messages: Drupal queue `es_upload_queue` (search re-index), consumed by `patron_search/src/Plugin/QueueWorker/EsUploadQueue.php` (+ `PatronSearchCron`, `ProcessQueueCommand`). External boundary Elasticsearch/App Search.
- Config evidence: `campaign.routing.yml:27` (route+permission), `campaign.services.yml` (`campaign.romanian_working_day_checker` args `@http_client,@cache.default,@logger.channel.campaign`), `campaign.permissions.yml:15` (`edit campaign state`), field/constraint declared in `CampaignEntity.php:564-570`.

### Corrections vs START hint
- Hint said "slug archival via SlugHistory". Actual archival is a **direct DB INSERT into `campaign_slug_archive`** inside `CampaignEntity::preSave` (`CampaignEntity.php:941-947`); `SlugHistoryController` is only a read viewer on a separate route and is NOT part of this flow. `Conflict — recorded, not forced.`
- Hint said "image processing" is part of set-active. Image (re)generation lives in `generateCampaignsImages()` (`CampaignEntity.php:985`) but is **not** called by set-active/preSave/postSave; only by `CampaignCron.php:303` and a manual permission-gated path. Marked accordingly. `Conflict — recorded.`
- New integration surfaced (not previously in `integrations.md`): **Nager.Date holiday API** (RO deadline validation). `Confirmed` from source; recommend adding to integrations map. `Hypothesis` that it is exercised in production RO only.
