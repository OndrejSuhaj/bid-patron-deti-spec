# FLW0022 — Campaign lifecycle cron (deadlines / auto-complete)
> AR:FlowMiner dossier · 2026-07-01 · source FlowID FL045 · see [../flow-index.md](../flow-index.md)

## A. Header
- FlowID: FL045 (dossier FLW0022)
- Flow Name: Campaign lifecycle cron (deadlines / auto-complete)
- Primary SRV: SRV0005 (Campaign-&-Story-Lifecycle) — secondary touch SRV0013 (messaging), SRV0018 (Slack/Telegram ops-logging), SRV0016 (ES upload queue)
- Trigger Evidence: `hook_cron` → `campaign_cron()` at `web/modules/custom/campaign/campaign.module:223` → `CampaignCron::execute()` at `web/modules/custom/campaign/src/CampaignCron.php:15`
- Confidence Level: Confirmed (cron body + deadline path); the "auto-complete on raised≥price" branch is Confirmed but Conflict on locus — it lives in `CampaignEntity::preSave`, NOT in this cron (see B/Corrections).

## B. Behavior Digest

- **Trigger:** Drupal scheduler runs `campaign_cron()` (`campaign.module:223`), which instantiates `CampaignCron` and calls `execute()` (`CampaignCron.php:15`). No route/args; runs on every Drupal cron tick.

- **Preconditions:**
  - `execute()` gates most work on `Settings::get('environment') === 'production'` (`CampaignCron.php:16`): only the diagnostic checks are prod-gated. The **deadline auto-uncomplete** (`checkCampaignDeadline`) runs in **every** environment (`CampaignCron.php:27`, called unconditionally after the prod block).
  - Image blur runs only if feature flag on: `feature_is_enabled('feature_blur_pictures')` (`CampaignCron.php:24`), which reads Drupal state key `feature_blur_pictures` (`patron_base.module:146`).

- **Main Steps** (in `execute()` order):
  1. **[prod only] `checkCampaignRaisedMoney()`** (`CampaignCron.php:102`) — daily-throttled via state key `check_raised_money_time` (seeds 02:00; +1 day gate). Iterates ALL campaigns (`\Drupal::entityQuery('campaign')`), recomputes `getCampaignRaisedMoney()` (`CampaignEntity.php:1073`, SUM of `transaction.price` where `ext_status='PAID'`) and, on mismatch vs stored `campaign_raised`, alerts via `logger.telegram` (`CampaignCron.php:119`). **Diagnostic only — no writes to campaigns.**
  2. **[prod only] `checkCampaignRaisedMoneyVsGiftPrice()`** (`CampaignCron.php:129`) — daily-throttled via state key `check_campaign_raised_money` (seeds 08:00). SQL `SELECT ... FROM campaign WHERE campaign_raised > gift_price` (`CampaignCron.php:146`); if any rows, alerts via `logger.slack` (`CampaignCron.php:159`). **Diagnostic only — no entity writes.**
  3. **[flag only] `blurPictures()`** (`CampaignCron.php:270`) — reads state `campaign_cron_blur_completed_time`; SQL selects up to 10 campaigns with `completed > :completed ORDER BY completed` (`CampaignCron.php:272`); for each, Gaussian-blurs the on-disk `photo` / `photo_list_page` files in place via Imagick (`gaussianBlurImage`, `CampaignCron.php:295,299`), advances the state cursor per item (`CampaignCron.php:279`), then calls `CampaignEntity::generateCampaignsImages(true)` (`CampaignCron.php:303` → `CampaignEntity.php:985`) to regenerate image styles. Mutates media files on disk.
  4. **`checkCampaignDeadline()`** (`CampaignCron.php:34`) — the core lifecycle step:
     - `getActiveCampaignsAfterDeadline()` (`CampaignCron.php:51`): raw SQL joining `application`→`campaign` where `campaign_deadline < today` AND `campaign_status = 'active'` AND `campaign_raised < gift_price` (`CampaignCron.php:52-59`). Returns application ids.
     - For each: load `ApplicationEntity` (`CampaignCron.php:41`), `setState('campaign_uncompleted', true, 'Automaticka zmena statusu', crm_robot_uid)` (`CampaignCron.php:43`; uid from `Settings::get('crm_robot_uid')`, `CampaignCron.php:42`), then `$application->save()` (`CampaignCron.php:44`).
     - Then `$campaign = $application->getCampaign()` and `$campaign->sendEmailUncompletedCampaign()` (`CampaignCron.php:46-47`).

- **Cascade from `setState('campaign_uncompleted') + save()`** (the heavy work is in entity hooks, not the cron):
  - `ApplicationEntity::setState` (`application/src/Entity/ApplicationEntity.php:292`) sets `moderation_state` + `state`, and INSERTs a row into `application_states` (raw SQL, `ApplicationEntity.php:318`) with `note='Automaticka zmena statusu'`, creates a new revision.
  - `ApplicationEntity::postSave` (`ApplicationEntity.php:197`): `addToQueue('application', id)` → ES upload queue `es_upload_queue` (`PatronBaseService.php:416`); dispatches `ApplicationStatusUpdateEvent` (`ApplicationEntity.php:229` — feeds FL005 subscriber chain: notification/scoring/reaction); `updateCampaignStatus()` (`ApplicationEntity.php:1176`) maps app state `campaign_uncompleted` → campaign `campaign_status='campaign_uncompleted'` (`ApplicationEntity.php:1182,1194`), sets `isCampaignUpdated=true`; then nested `$this->campaign->entity->save()` (`ApplicationEntity.php:211`).
  - The nested campaign save re-enters `CampaignEntity::preSave` (`CampaignEntity.php:915`): `updateCampaignRaisedMoney()` recomputes `campaign_raised`/`campaign_percentual_raised` (`CampaignEntity.php:1101`), and `CampaignEntity::postSave` (`CampaignEntity.php:977`) enqueues `campaign` to `es_upload_queue` and dispatches `CampaignUpdateEvent` (`CampaignEntity.php:980,1014`).

- **Postconditions:**
  - Each over-deadline, under-funded active application → app `state`/`moderation_state` = `campaign_uncompleted`, new revision, `application_states` audit row; its campaign → `campaign_status='campaign_uncompleted'`, `uncompleted` timestamp set (`ApplicationEntity.php:1199`), `campaign_raised` refreshed.
  - "Uncompleted campaign" email queued to supporters + admins.
  - Application + campaign enqueued for ES re-index; status events dispatched.

- **Side Effects:**
  - DB writes: `application` (state/revision), `application_states` (insert), `campaign` (status/timestamps/raised), `queue` (ES items), possibly `campaign_slug_archive` if name changed on the nested save (`CampaignEntity.php:941`).
  - Filesystem: blurPictures overwrites campaign photo files in place (destructive, non-idempotent per-file but flag-gated) + regenerates image styles.
  - Ops alerts: Telegram/Slack diagnostics (prod).
  - `\Drupal::state()` cursor writes (throttle keys, blur cursor).

- **Integration Calls:**
  - **Email / SmartMailing** — `sendEmailUncompletedCampaign()` (`CampaignEntity.php:1169`) → `patron_base.smartmailing->handleMail(..., 'campaign_uncompleted', ...)` (`CampaignEntity.php:1184`); `handleMail` enqueues to `mailing_queue` (`APIMailingService.php:67-79`) → later delivered (SmartEmailing/Mautic per country templates). Recipient list from `getCampaignEmails()` (paid, non-transparent transaction owners + `contract_checking_email` + a hardcoded seed address, `CampaignEntity.php:1188-1223`).
  - **Elasticsearch** — `addToQueue(... 'es_upload_queue')` on both app and campaign postSave (SRV0016).
  - **Telegram / Slack** (SRV0018) — diagnostic logging in prod-gated checks.
  - **Firebase / Nager.Date** — NOT called by this cron (see Corrections).

- **Failure Modes:**
  - `insertState` wraps its INSERT in try/catch, logs to Telegram, and **re-throws** (`ApplicationEntity.php:322-325`) → a single bad application aborts the whole cron run (loop is not per-item guarded in `checkCampaignDeadline`, `CampaignCron.php:37-48`).
  - `sendEmailUncompletedCampaign` calls `$this->getApplication()->id()` (`CampaignEntity.php:1181`); if the campaign has no application, this NPEs — but `checkCampaignDeadline` selects via `application JOIN campaign`, so an application always exists (campaign→application linkage assumed 1:1).
  - No idempotence guard on the deadline transition itself: it relies on the SQL filter `campaign_status='active'`; once flipped to `campaign_uncompleted` the campaign no longer matches, so re-runs are naturally idempotent — **BUT** email is sent every match; `sendEmailUncompletedCampaign` has NO `isEmailSent()` guard on send (it checks `isEmailSent()` and returns early, `CampaignEntity.php:1170`, but never SETS `is_email_sent=TRUE` for the uncompleted path — contrast `sendEmailSuccessfullyFinishCampaign` which sets it at `CampaignEntity.php:1160`). If status flip and email are ever decoupled, duplicate emails are possible. (Hypothesis on re-send risk; single-run is safe.)
  - blurPictures advances its state cursor even when a file is unwritable/missing (`CampaignCron.php:279` runs before the write guards) → a campaign whose files are not yet on disk can be skipped permanently for blurring (Data Loss / silent-skip). Non-idempotent file overwrite if cursor were reset.
  - Nager.Date/Romanian-holiday checks and Firebase sync are NOT in this path (Corrections).

### Corrections vs START hint (Conflict)
- **RomanianWorkingDayChecker is NOT used by the cron.** `RomanianWorkingDayChecker` (`campaign/src/Service/RomanianWorkingDayChecker.php`, service `campaign.romanian_working_day_checker`) is consumed only by `CampaignDeadlineWorkingDayConstraintValidator` (`.../Constraint/CampaignDeadlineWorkingDayConstraintValidator.php:52`), a field-validation constraint on the campaign `campaign_deadline` field (`CampaignEntity.php:570`). It runs at deadline-editing/save-validation time (calling Nager.Date API `https://date.nager.at/api/v3/IsPublicHoliday/{date}/RO`, `RomanianWorkingDayChecker.php:150`), NOT during `campaign_cron`. `Confirmed` correction.
- **Auto-complete on raised≥price is NOT performed by the cron.** The cron's `checkCampaignRaisedMoney*` methods are diagnostics (Telegram/Slack alerts) only. The actual auto-completion (`isCampaignReadyToComplete()` → `sendEmailSuccessfullyFinishCampaign()` + `setApplicationComplete()` + `setComplete()`) lives in `CampaignEntity::preSave` (`CampaignEntity.php:922-934`) and fires on ANY campaign save — primarily driven by transaction/payment saves (FL020/FL021/FL028), not by this scheduler. Recorded as `Conflict — hint locates auto-complete in cron; code locates it in entity preSave.`
- **Firebase check is dead code.** `checkFirebase()` exists (`CampaignCron.php:167`, hits `patron-deti.firebaseio.com`) but is commented out in `execute()` (`CampaignCron.php:19`). Not part of the live flow.

## C. Data Footprint

- **Entities Written:**
  - `application` (fields `state`, `moderation_state`, revision metadata) — `ApplicationEntity::setState` (`ApplicationEntity.php:294-306`).
  - `application_states` (audit row insert) — `ApplicationEntity.php:318`.
  - `campaign` (fields `campaign_status`, `uncompleted`, `campaign_raised`, `campaign_percentual_raised`; possibly `campaign_order`, `completed`, `campaign_status='completed'` ONLY on the unrelated preSave auto-complete branch) — via nested save from `updateCampaignStatus` (`ApplicationEntity.php:1194-1206`) + `CampaignEntity::preSave` (`CampaignEntity.php:919`).
  - `queue` (Drupal queue: `es_upload_queue`, `mailing_queue`) — `PatronBaseService::addToQueue` (`PatronBaseService.php:416`), `APIMailingService::handleMail` (`APIMailingService.php:69,79`).
  - `campaign_slug_archive` (conditional, only if name changed during nested save) — `CampaignEntity.php:941`.
  - Drupal `state` (KV): `check_raised_money_time`, `check_campaign_raised_money`, `campaign_cron_blur_completed_time`.
  - Media files on disk (blurPictures, flag-gated).

- **Entities Read:**
  - `application`, `campaign` (deadline SQL join, `CampaignCron.php:52-59`).
  - `transaction` (SUM of PAID for `getCampaignRaisedMoney` / recipient enumeration in `getCampaignEmails`) — `CampaignEntity.php:1091-1096,1188-1195`.
  - All campaigns via entityQuery (diagnostic `checkCampaignRaisedMoney`).
  - `campaign` (blur select) — `CampaignCron.php:272`.

- **Constraints involved:**
  - Deadline eligibility is a raw-SQL predicate, not an entity constraint: `campaign_deadline < NOW date AND campaign_status='active' AND campaign_raised < gift_price` (`CampaignCron.php:56-58`).
  - `campaign_deadline_working_day` constraint (`CampaignEntity.php:570`) governs deadline *editing*, not this cron.
  - State-map invariant: app state `campaign_uncompleted` ↔ campaign `campaign_status='campaign_uncompleted'` enforced imperatively in `updateCampaignStatus` (`ApplicationEntity.php:1182`); mismatch triggers a Telegram sync-error alert (`ApplicationEntity.php:216-217`).

- **Multi-tenant scope assumptions:**
  - Single-country per deployment: `Settings::get('country')` ('cz'/'ro'/'md') switches money/email/template logic (`CampaignEntity.php:1075`, `APIMailingService.php:99-111`). No tenant column in the deadline query — the whole DB is one country's data (per-instance tenancy).
  - Special-case campaign #2200 for CZ in `getCampaignRaisedMoney` (`CampaignEntity.php:1078`).

## D. Evidence Block

- **Controller paths:** none (scheduler-triggered flow; no HTTP controller). Trigger: `campaign.module:223` (`campaign_cron`).
- **Service methods:**
  - `Drupal\campaign\CampaignCron::execute|checkCampaignDeadline|getActiveCampaignsAfterDeadline|checkCampaignRaisedMoney|checkCampaignRaisedMoneyVsGiftPrice|blurPictures|gaussianBlurImage` (`campaign/src/CampaignCron.php`).
  - `Drupal\campaign\Entity\CampaignEntity::sendEmailUncompletedCampaign|getCampaignEmails|getCampaignRaisedMoney|updateCampaignRaisedMoney|isCampaignReadyToComplete|preSave|postSave|setComplete|setApplicationComplete|generateCampaignsImages` (`campaign/src/Entity/CampaignEntity.php`).
  - `Drupal\application\Entity\ApplicationEntity::setState|insertState|complete|updateCampaignStatus|updateCampaignCategory|preSave|postSave|getCampaign` (`application/src/Entity/ApplicationEntity.php`).
  - `Drupal\patron_base\PatronBaseService::addToQueue` (`patron_base/src/PatronBaseService.php:416`); `feature_is_enabled` (`patron_base/patron_base.module:146`).
  - `Drupal\patron_base\APIMailingService::handleMail` (`patron_base/src/APIMailingService.php:67`); service id `patron_base.smartmailing` (`patron_base/patron_base.services.yml:8`).
- **Repository usage:** raw `\Drupal::database()->query()` for deadline join (`CampaignCron.php:52`), state insert (`ApplicationEntity.php:318`), diagnostic selects (`CampaignCron.php:146,272`), raised-money SUM (`CampaignEntity.php:1079,1091`); `\Drupal::entityQuery('campaign'|'transaction')` for iteration/recipient lists.
- **Event listeners:** dispatches `CampaignUpdateEvent::UPDATE_EVENT` (`CampaignEntity.php:1014`; subscriber lives in the non-scrubbed `firebase` module per comment at `campaign.module:70` — `Uncertain`, subscriber source absent) and `ApplicationStatusUpdateEvent::STATUS_UPDATE_EVENT` (`ApplicationEntity.php:229`; feeds FL005 → notification/scoring/reaction subscribers).
- **Async messages:** Drupal queues `es_upload_queue` (SearchIndex-Processor, SRV0016) and `mailing_queue` (Transactional-Messaging, SRV0013) — deferred workers, not processed inline.
- **Config evidence:** `Settings::get('environment')` (prod gate, `CampaignCron.php:16`), `Settings::get('crm_robot_uid')` (audit actor, `CampaignCron.php:42`), `Settings::get('country')`, `Settings::get('contract_checking_email')` (`CampaignEntity.php:1201`); state flag `feature_blur_pictures`; throttle state keys listed in C. `campaign.services.yml:2` registers `campaign.romanian_working_day_checker` (NOT used by this flow).
