# FLW0001 — Application status event fan-out
> AR:FlowMiner dossier · 2026-07-01 · source FlowID FL005 · see [../flow-index.md](../flow-index.md)

## A. Header
- FlowID: FL005 (dossier FLW0001)
- Flow Name: Application status event fan-out
- Primary SRV: SRV0002
- Trigger Evidence: `application/src/Entity/ApplicationEntity.php::postSave` → `::dispatchStatusUpdateEvent` (line ~202/228) dispatches `Drupal\application\Event\ApplicationStatusUpdateEvent` on constant `STATUS_UPDATE_EVENT = 'application.status.update.event'` (`application/src/Event/ApplicationStatusUpdateEvent.php:13`).
- Confidence Level: Confirmed

## B. Behavior Digest
- Trigger: Every `ApplicationEntity::save()` runs `postSave()`, which unconditionally calls `dispatchStatusUpdateEvent()`. The event fires on **every save**, not only on a real status change (guarding on "did the state change" is left to each subscriber). `application/src/Entity/ApplicationEntity.php::postSave`.
- Preconditions: An `ApplicationEntity` is persisted. `$this->original` is the pre-save entity (NULL when new). No explicit gate before dispatch.
- Main Steps (ordered):
  1. `postSave()` first enqueues the app for ES re-index via `\Drupal::service('patron_base.default')->addToQueue('application', id)` — `patron_base/src/PatronBaseService.php::addToQueue` (dedup check + `\Drupal::queue('es_upload_queue')->createItem`). Precedes the event.
  2. `dispatchStatusUpdateEvent()` dispatches to 3 tagged subscribers (synchronous, Symfony dispatcher; order not deterministically pinned). `application/src/Entity/ApplicationEntity.php::dispatchStatusUpdateEvent`.
  3. Subscriber A — **application_reaction** `application_reaction/src/EventSubscriber/ApplicationStatusUpdateSubscriber.php::updateApplicationStatus`. Guarded by `isApplicationModified()` (original NULL, or `state != original->state`). On change: `\Drupal::service('application_reaction')->execute($application)` then `cancelSessions()`.
  4. `ApplicationReactionService::execute` loads all `application_reaction` config-entities matching current `state` (`getApplicationsReactions` → `loadByProperties(['application_status'=>state])`), filters by `initiator` (NULL or == `lead_role`), and per matching reaction: writes an `application_log` row, optionally creates an `application_session` (`createReaction`→`createApplicationSession`), token-replaces email subject/body (`replaceTokens` + core `token.replacePlain`), and sends the notification email (`sendEmail`). `application_reaction/src/ApplicationReactionService.php`.
  5. `sendEmail` resolves recipient by reaction `role` (fundraiser/patron/organisation_worker) from the User entity or falls back to the aprofile email field, then calls `patron_base.smartmailing->handleMail([$email], params, 'zone_main_template', ...)`. `ApplicationReactionService.php::sendEmail`.
  6. `handleMail` → since `APIMailingService::USE_QUEUE = FALSE` it calls `doHandleMail` **synchronously** (no queue). Per-country template map is chosen from `Settings::get('country')` (cz default / ro / md). `doHandleMail`→`sendEmail` archives an `email` entity row and, when `Settings::get('environment')==='production'` (or email allow-listed), creates a Mautic contact + sends via Mautic email API. `patron_base/src/APIMailingService.php`.
  7. `cancelSessions()` reads config `patron_base.application_statuses.invalidate_sessions`; if current state is in the enabled list, calls `application->deactivateSessions(['application_uuid'=>uuid])` (deactivates ALL sessions for the app) and writes an `application_log` audit row (user = `Settings::get('crm_robot_uid')`). `application_reaction/.../ApplicationStatusUpdateSubscriber.php::cancelSessions`; `application/src/ApplicationService.php::deactivateSessions`.
  8. Subscriber B — **scoring** `scoring/src/EventSubscriber/ApplicationStatusUpdateSubscriber.php::updateApplicationStatus`. Guarded by same `isApplicationModified()`; additionally only acts when `state === 'to_check'`. Computes a low-risk score (`getScore`) and writes it back with a **raw UPDATE** to `application.scoring_low_risk_score` + `application.scoring_low_risk` (JSON). `setLowRiskScoringLog`.
  9. Subscriber C — **notification** `notification/src/EventSubscriber/ApplicationStatusUpdateSubscriber.php::updateApplicationStatus`. Gated by `feature_is_enabled('feature_digital_signature')` (Drupal state flag). On transition **into** any `waiting_signature*` state: creates an acceptance-protocol `contract` entity + a `custom`-interface `application_session` carrying a signing form schema. On transition **into** any `waiting_for_feetback*` state: ensures acceptance protocol exists, deactivates prior custom fundraiser sessions, creates a feedback+protocol-signing session.
- Postconditions: `application_log` rows appended; possibly new `application_session`(s); possibly deactivated sessions; `application.scoring_low_risk*` updated (only at `to_check`); acceptance-protocol `contract` created + `application.acceptance_protocol` FK set (only in `waiting_signature`/`waiting_for_feetback` with feature flag); transactional email archived (`email`) and dispatched via Mautic on prod.
- Side Effects: outbound transactional email (Mautic API); `email` archive row per recipient; Mautic contact upsert; ES re-index queue item (`es_upload_queue`); `application_log` audit rows (reaction + session-cancel); `application_session` create/deactivate; raw SQL write to `application` (scoring cols); `contract` (acceptance protocol) create + FK backfill via raw SQL; cache-tag invalidation (`Cache::invalidateTags`); Slack error log on malformed reaction (empty role/interface) and Telegram error log on failed queue insert.
- Integration Calls: Mautic marketing/mail API (`APIMailingService::sendEmail` via `Mautic\MauticApi` `emails`/`contacts`, base_uri `https://m.patrondeti.cz/api`, BasicAuth from `Settings::get('mailing')`); Elasticsearch/App Search indirectly via `es_upload_queue` (deferred, not in this synchronous path); Slack (`logger.slack`) + Telegram (`logger.telegram`) for error alerting. Payment/bank gateways NOT touched here.
- Failure Modes:
  - **No status-change guard at dispatch** — event fires on every save; only downstream `isApplicationModified()` checks limit work. `postSave`.
  - **Synchronous external mail inside entity save** — `USE_QUEUE=FALSE`; a slow/failed Mautic call blocks/aborts the save transaction (no try/catch around `handleMail`). `APIMailingService::handleMail`/`sendEmail`.
  - **No idempotence on re-save** — a second save at the same state re-runs application_reaction (new `application_log` + possibly new `application_session` + resend). Only `to_check` scoring is naturally re-computable; email resend is not deduped.
  - **Raw UPDATE in scoring subscriber** bypasses entity API / revisions / validation; writes `scoring_low_risk_score = NULL` when required related data missing (`setLowRiskScoringLog`).
  - **Subscriber ordering / partial failure** — subscribers run in one synchronous pass with no transaction isolation between them; an exception in an early subscriber can leave later side effects unexecuted while earlier writes persist.
  - **Recipient fallback to aprofile email** may send to stale/unverified addresses; empty email silently skips send.
  - Reaction with empty role/interface only logs to Slack, still creates a bad session. `createApplicationSession`.

## C. Data Footprint
- Entities Written:
  - `application_log` (activity/reaction + session-cancel audit rows) — `ApplicationReactionService::addApplicationLog`, `application_reaction/.../Subscriber::addApplicationLog`.
  - `application_session` (create for reaction button-action; create custom signing/feedback sessions; deactivate on invalidate list) — `createApplicationSession`, notification subscriber, `ApplicationService::deactivateSessions`.
  - `application` (raw `UPDATE` of `scoring_low_risk_score`, `scoring_low_risk`; also `acceptance_protocol` FK via raw `UPDATE` in notification `createAcceptanceProtocol`).
  - `contract` (acceptance-protocol entity create via `ContractEntity::create()->fill(...)`).
  - `email` (archive row per outgoing message) — `APIMailingService::sendEmail`.
  - `queue` (`es_upload_queue` item) — `PatronBaseService::addToQueue`.
- Entities Read:
  - `application_reaction` (config-driven reaction rows keyed by status + role + initiator).
  - `application` (state, original state, lead_role, flag, campaign, aprofile refs).
  - `aprofile` (fundraiser/patron profiles: emails, gift fields, occupation, gift_payment_type) — scoring + email fallback.
  - `contact` — **cross-context**: scoring reads `contact.blacklist_type` by email (`ScoringService::getBlacklistType`, `SELECT blacklist_type FROM {contact} WHERE email=:email`).
  - `user` (fundraiser/patron accounts for recipient email + score compare).
  - `contract` (html/file url for signing schema).
  - Config: `patron_base.application_statuses.invalidate_sessions`; Drupal state `feature_digital_signature`, `application_flags`; `Settings` (country, environment, crm_robot_uid, mailing).
- Constraints involved: `application_states` is written elsewhere (not here) via raw INSERT; scoring/notification writes use **raw SQL bypassing** entity validation & unique/index enforcement (soft-FK on `application.acceptance_protocol`, `application.scoring_low_risk_score`). `addToQueue` does a manual `LIKE`-based dedup on `queue.data` (not a DB unique constraint) — race-prone. No unique guard preventing duplicate `application_log`/email on re-fire (idempotence gap).
- Multi-tenant scope assumptions: Country gating is **implicit** via `Settings::get('country')` selecting the CZ/RO/MD Mautic template-id map inside `APIMailingService::doHandleMail`; the flow itself is single-instance (one Drupal, path-prefix i18n per integrations.md §10). Email actually sent only when `Settings::get('environment')==='production'` or recipient allow-listed. No explicit per-region branch in the subscribers themselves.

## D. Evidence Block
- Controller paths: none (entity-hook–triggered, not routed). Upstream state-change triggers are the routed flows FL004 `/admin/application/{application}/change_mod_state` and the cron FL009 that call `setState()`/`save()`.
- Service methods: `ApplicationReactionService::execute/sendEmail/createReaction/createApplicationSession/replaceTokens/addApplicationLog/getApplicationsReactions` (`application_reaction/src/ApplicationReactionService.php`); `ApplicationService::deactivateSessions` (`application/src/ApplicationService.php:171`); `ScoringService::getBlacklistType` (`scoring/src/ScoringService.php:21`); `APIMailingService::handleMail/doHandleMail/sendEmail` (`patron_base/src/APIMailingService.php:67/89/199`); `PatronTokenService::replaceTokens` (`patron_base/src/PatronTokenService.php:60`); `PatronBaseService::addToQueue` (`patron_base/src/PatronBaseService.php:416`).
- Repository usage: entity storage via `getStorage('application_reaction'|'application_session')->loadByProperties`; **raw SQL** in scoring subscriber (`UPDATE {application} SET scoring_low_risk_score...`), notification `createAcceptanceProtocol` (`UPDATE application SET acceptance_protocol...`), and `getBlacklistType` (`SELECT ... FROM {contact}`).
- Event listeners: 3 subscribers on `ApplicationStatusUpdateEvent::STATUS_UPDATE_EVENT`, all method `updateApplicationStatus`, registered in `notification.services.yml`, `scoring.services.yml`, `application_reaction.services.yml` (tag `event_subscriber`, no priority set).
- Async messages: `es_upload_queue` item created in `postSave` (deferred ES re-index — SRV0016). `mailing_queue` is **bypassed** here because `APIMailingService::USE_QUEUE = FALSE` → mail is sent **synchronously** in-request. `patron_base/src/APIMailingService.php:16,68`.
- Config evidence: `patron_base.application_statuses.invalidate_sessions.yml` (status list driving session cancel); reaction content is stored in `application_reaction` config-entities (status→role→email subject/body, incl. `_ukr` variants and button actions); Drupal state flag `feature_digital_signature` gates the notification subscriber (`patron_base.module::feature_is_enabled`).
