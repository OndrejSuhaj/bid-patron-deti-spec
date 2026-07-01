# FLW0016 — Scoring form (manual risk assessment)
> AR:FlowMiner dossier · 2026-07-01 · source FlowID FL039 · see [../flow-index.md](../flow-index.md)

## A. Header
- FlowID: FL039 (dossier FLW0016)
- Flow Name: Scoring form (manual risk assessment)
- Primary SRV: SRV0003
- Trigger Evidence: route `scoring.scoring_form` `/admin/application/{application}/scoring` → `scoring/scoring.routing.yml` → `Drupal\scoring\Form\ScoringForm::buildForm` (`scoring/src/Form/ScoringForm.php:65`); submit `ScoringForm::submitForm` (`scoring/src/Form/ScoringForm.php:148`)
- Confidence Level: Confirmed

## B. Behavior Digest
- Trigger: A back-office user (permission `view scoring page`, `scoring/scoring.permissions.yml`) opens `/admin/application/{application}/scoring` and submits the manual risk-scoring form for one application. Route binds `{application}` to `ApplicationEntityInterface` (`ScoringForm::buildForm` param, `ScoringForm.php:65`).
- Preconditions:
  - Application entity resolves from the route slug (`ScoringForm.php:67`).
  - `buildForm` reads the current serialized scoring JSON from `application.scoring` (`ScoringForm.php:77`) and hydrates ~90 fields across fundraiser/patron/gift/child sub-forms (`getFundraiserForm` 200, `getPatronForm` 902, `getGiftForm` 1287, `getChildForm` 1604, `getScoringResultForm` 1702, `getAttachment` 1730).
  - A readiness helper `isApplicationReadyForScoring()` exists (`ScoringForm.php:1897`) producing blocking warnings when Fundraiser/Patron/profiles/`patron_occupation_list` are missing, but it is **not invoked** by `buildForm`/`submitForm` in this file (Hypothesis: rendered via the `scoring_form` theme template; not enforced server-side here).
  - State gate for approval: promotion happens only when current `application.getState() === 'scoring'` AND submitted `approved === 'yes'` (`ScoringForm.php:176`).
- Main Steps (ordered, evidence in `scoring/src/Form/ScoringForm.php` unless noted):
  1. `buildForm` loads fundraiser/patron users and `fundraiser`/`patron` application profiles (`:70–74`, via `ApplicationEntity::getFundraiser/getPatron` `application/src/Entity/ApplicationEntity.php:388/379`, `getApplicationProfile` `:535`).
  2. buildForm-time ID-card validation: for a non-empty `fundraiser_op_id`, calls `scoring.identitycard`→`IdentityCardService::isValid` (`ScoringForm.php:268`; `scoring/src/IdentityCardService.php:31`) which HTTP-GETs MVČR neplatné-doklady and colors the field green/red. Same pattern for other OP fields in patron/gift sub-forms.
  3. buildForm renders OSINT helper links (Google/Facebook/LinkedIn/Maps) as static hrefs (`getGoogleLinks` 1857 … `getMapsLinks` 1879) — no server-side external call.
  4. `submitForm` copies all submitted values except `scoring_attachements` into `$fields` (`:151–155`).
  5. Uploaded scoring files (`managed_file`, `private://scoring_attachements/`, `getAttachment` `:1777`) are loaded by fid, marked permanent and saved to the managed_file table (`File::setPermanent()/save()`, `:160–170`).
  6. Reloads the application by hidden `application_id` (`ApplicationEntity::load`, `:174`).
  7. **State transition:** if `getState()==='scoring'` and `approved==='yes'`, `application->setState('scoring_ok')` (`:176–178`; `ApplicationEntity::setState` `application/src/Entity/ApplicationEntity.php:292`).
  8. Serializes the full field set into the application's `scoring` field (`$this->application->set('scoring', json_encode($fields))`, `:180`) and `application->save()` (`:181`).
  9. **Blacklist writes:** for fundraiser (if present) and patron (if present), reads the user email and calls `scoring`→`ScoringService::setBlacklistType($email, <blacklist select value>)` (`:184–196`; `scoring/src/ScoringService.php:29`).
- Postconditions:
  - `application.scoring` holds the new JSON snapshot of all scoring fields (incl. `approved`, ranks, blacklist selections, attachment fids).
  - Application `state`/`moderation_state` = `scoring_ok` **iff** the approval gate matched; a new application revision is created and an `application_states` audit row inserted (`ApplicationEntity::setState` → `insertState` raw INSERT, `application/src/Entity/ApplicationEntity.php:300,312`).
  - `contact.blacklist_type` updated for the fundraiser's and/or patron's contact email(s).
  - Scoring attachment files promoted to permanent.
- Side Effects:
  - **Status-event fanout (unconditional on save):** `application->save()` → `ApplicationEntity::postSave` (`application/src/Entity/ApplicationEntity.php:197`) always runs: enqueues the entity via `patron_base.default->addToQueue` (`:199`, Mautic/mailing queue), dispatches `ApplicationStatusUpdateEvent::STATUS_UPDATE_EVENT` (`:229–230`), and runs campaign status/category sync (`:205–220`). This fires on **every** scoring save, not only when state changes to `scoring_ok`. Downstream fanout is FLW0001 ([FLW0001_application-status-event-fanout.md](FLW0001_application-status-event-fanout.md)) → notifications (MSG) + Mautic queue.
  - Telegram ops log on `insertState` failure and on campaign/application status desync (`logger.telegram`, `application/src/Entity/ApplicationEntity.php:323,217`).
  - Managed-file table mutation (temporary → permanent).
- Integration Calls:
  - **MVČR** invalid-documents lookup at buildForm time — `IdentityCardService::isValid` GET `http://aplikace.mvcr.cz/neplatne-doklady/doklady.aspx` (`scoring/src/IdentityCardService.php:12,33`). Read-only; 10s timeouts; failures logged (`idcard_validation`) and surfaced as a user message. (Aligns with FL042 `MVCR-DocValidity-Adapter`, SRV0004.)
  - **ARES** — reachable from the scoring UI but as a **separate** flow: AJAX route `scoring.ares_controller_searchByIco` → `AresController` (FL041, SRV0004), and `ScoringService::isIcoValid` (`scoring/src/ScoringService.php:54`, GET `wwwinfo.mfcr.cz/.../darv_bas.cgi`) — **not called** inside `ScoringForm::buildForm`/`submitForm`. Hypothesis: ICO validation is triggered by the `scoring/ares` JS library (`ScoringForm.php:102`), not by this server flow.
  - No payment/email/CRM calls made directly by this flow (email/Mautic occur indirectly via the postSave event fanout, FLW0001).
- Failure Modes:
  - `insertState` INSERT failure → `logger.telegram` then rethrow, aborting the save (`application/src/Entity/ApplicationEntity.php:322–324`).
  - MVČR unreachable → caught `RequestException`, returns `''`, adds error message; does not block submit (`IdentityCardService.php:43–47`).
  - No CSRF/idempotency guard beyond Drupal form tokens; resubmitting re-fires the full postSave fanout (duplicate notification/queue risk — see Risks).
  - `setBlacklistType` matches by email only with **no LIMIT** (`ScoringService.php:29–35`): if multiple `contact` rows share the email, **all** are overwritten. Empty/absent user email would set blacklist on rows with empty email.
  - `validateForm` is a pass-through to parent (`ScoringForm.php:141–143`) — effectively no domain validation of the 90+ fields before persistence.

## C. Data Footprint
- Entities Written:
  - `application` — `scoring` field (JSON snapshot); `state`/`moderation_state` → `scoring_ok` (conditional); new revision; `changed` (`ScoringForm.php:180,181,177`; `ApplicationEntity::setState`).
  - `application_states` — audit row via raw INSERT on state change (`ApplicationEntity::insertState`, `application/src/Entity/ApplicationEntity.php:318`).
  - `contact` — `blacklist_type` via **raw SQL UPDATE** keyed on `email` (`ScoringService::setBlacklistType`, `scoring/src/ScoringService.php:29–35`). Bypasses `ContactEntity` load/save/revisions.
  - `file_managed` — scoring attachment files set permanent (`ScoringForm.php:165–168`).
  - (Indirectly) queue table via `patron_base.default->addToQueue` in postSave.
- Entities Read:
  - `application` (route + reload `:174`, `scoring` JSON `:77`), user `fundraiser`/`patron` (`:70–71`), application profiles `fundraiser`/`patron` (`:73–74`), `contact` (blacklist default via `fundraiser->contact->entity->blacklist_type` `:896`, `patron->contact->entity->blacklist_type` `:1282`), `child` application (`:124`), campaign (in postSave sync), `Settings::get('country')` (`:1789`).
  - **NOT read/written by this flow:** `scoring_entity` (base_table `scoring_entity`, `json_package`/`entity_name`/`entity_id`; `scoring/src/Entity/ScoringEntity.php:36,205`). Despite the flow-index listing `scoring_entity` for FL039, the manual `ScoringForm` persists to `application.scoring`, not `scoring_entity`. `scoring_entity` is written by the low-risk/REST path (`ScoringResource` `scoring/src/Plugin/rest/resource/ScoringResource.php`, FLW0040 territory). Confidence: Confirmed (no `ScoringEntity::create`/`save`/`json_package` write in `ScoringForm.php`).
- Constraints involved:
  - Approval gate: `state==='scoring' && approved==='yes'` → `scoring_ok` (`ScoringForm.php:176`). Other `approved` values (`na`/`no`/`yes_but`/empty; options at `:1709–1715`) do **not** transition state.
  - Blacklist enum: `wl_n`/`bl`/`wl_zd`/`wl_z` (`ScoringForm.php:890–895`), mirrored on `contact.blacklist_type` (`contact/src/Entity/ContactEntity.php:680`).
- Multi-tenant scope assumptions:
  - Country/tenant read from global `Settings::get('country')` for attachment display only (`:1789`); the state transition and JSON persistence carry no explicit tenant filter (single-instance-per-country deployment assumed). The blacklist UPDATE has **no tenant/country predicate** — email is the sole key.

## D. Evidence Block
- Controller/Form paths:
  - `scoring/src/Form/ScoringForm.php` (`buildForm:65`, `submitForm:148`, `getScoringResultForm:1702`, `getAttachment:1730`, `isApplicationReadyForScoring:1897`)
  - `scoring/scoring.routing.yml` (`scoring.scoring_form`), `scoring/scoring.permissions.yml` (`view scoring page`)
  - `scoring/src/Controller/ScoringController.php` (`visualisation`, separate FL — `scoring.visualisation_controller`)
- Service methods:
  - `scoring` = `Drupal\scoring\ScoringService` (`scoring/scoring.services.yml`): `setBlacklistType` (`ScoringService.php:29`), `getBlacklistType` (`:21`), `isIcoValid` (`:54`, not used by this flow).
  - `scoring.identitycard` = `Drupal\scoring\IdentityCardService::isValid` (`scoring/src/IdentityCardService.php:31`).
  - `Drupal\application\Entity\ApplicationEntity`: `setState:292`, `insertState:312`, `postSave:197`, `dispatchStatusUpdateEvent:228`, `getApplicationProfile:535`, `skipPatronApplication:499`.
- Repository usage: direct `\Drupal::database()` raw SQL in `ScoringService::setBlacklistType` (UPDATE `contact`) and `ApplicationEntity::insertState` (INSERT `application_states`); `File::load/save` for attachments; standard entity storage `ApplicationEntity::load/save`.
- Event listeners: `ApplicationStatusUpdateEvent::STATUS_UPDATE_EVENT` dispatched from `ApplicationEntity::postSave` on every save (fanout → FLW0001). Note the scoring module's own `ApplicationStatusUpdateSubscriber` (`scoring/src/EventSubscriber/ApplicationStatusUpdateSubscriber.php`, FL040) subscribes to this event but is a **separate** low-risk-recalc flow, not driven by this submit.
- Async messages: `patron_base.default->addToQueue(entityType, id)` enqueued in `postSave` (`application/src/Entity/ApplicationEntity.php:199`) → mailing/Mautic queue workers (SRV0013/SRV0014 boundary; async).
- Config evidence: `scoring/scoring.services.yml`, `scoring/scoring.routing.yml`, `scoring/scoring.permissions.yml`, `scoring/scoring.module` (theme hooks `scoring_form`), attached libs `scoring/scoring_form` + `scoring/ares` (`ScoringForm.php:101–102`).
