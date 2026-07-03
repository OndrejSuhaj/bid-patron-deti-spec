# FLW0032 — Elasticsearch upload queue (es_upload_queue) entity indexing
> AR:FlowMiner dossier · 2026-07-03 · source FlowID FL055 · see [../flow-index.md](../flow-index.md)

## A. Header
- FlowID: FL055 (dossier FLW0032)
- Flow Name: Elasticsearch upload queue (`es_upload_queue`) entity indexing — async search-index sync
- Primary SRV: SRV0016 (SearchIndex-Processor + Elasticsearch-Adapter — [../../spec-draft/SRV-target-list.md](../../spec-draft/SRV-target-list.md):45,54)
- Trigger Evidence:
  - Enqueue: `PatronBaseService::addToQueue()` (`patron_base/src/PatronBaseService.php:416-426`) called from **5 entity `postSave()` hooks** — `application` (`application/src/Entity/ApplicationEntity.php:199`), `campaign` (`campaign/src/Entity/CampaignEntity.php:979`), `transaction` (`transaction/src/Entity/TransactionEntity.php:635`), `organisation` (`organisation/src/Entity/OrganisationEntity.php:73`), `user`/PatronUser (`account/src/PatronUser.php:52`).
  - Drain: QueueWorker `EsUploadQueue::processItem()` (`patron_search/src/Plugin/QueueWorker/EsUploadQueue.php:39`, `@QueueWorker id="es_upload_queue"`), driven by CLI `patron_search:process_queue` → `PatronSearchCron::processQueue('es_upload_queue')` (`patron_search/src/PatronSearchCron.php:25`); command wired in `patron_search/console.services.yml:7-11`.
  - Full re-index (bypasses queue): CLI `patron_search:upload_to_es` → `EsUploadCommand::execute()` (`patron_search/src/Command/EsUploadCommand.php:59`).
  - Repo base `PSRC/ = intake/current-solution/_source/patronus/web/modules/custom/`.
- Confidence Level: Confirmed (queue path); Partial (drain scheduling — see Failure Modes)

## B. Behavior Digest
- Trigger:
  - **Every save** of any of the 5 indexed entity types calls `addToQueue($entityTypeId, $id)` from `postSave()` (default queue name `es_upload_queue`). `PatronUser::postSave` additionally enqueues to `mautic_queue` (`account/src/PatronUser.php:53` — that second call is FL049, not this flow). `Confirmed`.
  - **Drain** is NOT automatic: the `@QueueWorker` annotation has **no `cron` key** (`EsUploadQueue.php:18-21`), so Drupal core's cron queue processor does not claim it; and `patron_search_cron()` is **fully commented out** (`patron_search.module:27-35`). Draining therefore only happens when `patron_search:process_queue` (or `PatronSearchCron::processQueue`) is invoked. `Confirmed` (code) / `Hypothesis` (an external scheduler/CI invokes the drush/console command — not evidenced in source).
- Preconditions:
  - `es_upload_queue` exists — created by `patron_search_update_8001()` (`patron_search.install:5-9`) via `\Drupal::queue('es_upload_queue')->createQueue()`.
  - Env var `ELASTIC_AUTH` must be set (`$_ENV['ELASTIC_AUTH']`, `EsUploadQueue.php:227`); if missing the worker throws `missing elastic auth` (`:229-231`). Value is <redacted> (not defined anywhere in scrubbed source).
  - The referenced entity must still load; a deleted/missing id short-circuits (`export*` returns FALSE → item marked unprocessed).
- Main Steps (drain path):
  1. `PatronSearchCron::processQueue()` loops **up to 500 iterations**, claims each item with a **3600 s lease** (`PatronSearchCron.php:30,33`).
  2. `EsUploadQueue::processItem($data)` reads `entity_type` + `id` (int-cast), and only proceeds when `id > 0`; calls `updateData()` (`EsUploadQueue.php:39-51`).
  3. `updateData()` dispatches by naming convention: `$action = 'export' . ucfirst($entity_type)` → calls `exportUser`/`exportApplication`/`exportCampaign`/`exportOrganisation`/`exportTransaction` (`EsUploadQueue.php:53-59`).
  4. Each `export*` **loads the live entity fresh** and builds a per-type document (see Data Footprint), then `addCommonFields()` appends `id` (= `"{type}:{entityId}"`), `entity_type`, Czech `typ` label, `name`, backend/frontend `links` (via `Url::fromRoute` canonical + edit_form), and RFC3339 `created`/`changed` (`EsUploadQueue.php:184-197`).
  5. `sendToElastic()` (`EsUploadQueue.php:220`) strips null/empty fields recursively via `prepareData()` (`:199-218`), forces `name` key present (`KEEP_KEYS`, `:222-224`), then **cURL POSTs one JSON document** to the Elastic **App Search documents** endpoint `<redacted>` (`:232-238`) with header `Authorization: Bearer <redacted>`.
  6. Response parsed; then an unconditional **`sleep(1)`** (`:242`, rate-limit throttle). If any response element has a non-empty `errors` key, logs the error to Telegram + `EsUploadCommand` logger and sets `result=false` (`:245-256`).
  7. Back in the worker: `processItem` throws `"EsUploadQueue {type}:{id} was not processed"` when `result===FALSE` (`EsUploadQueue.php:46-48`). Otherwise returns `true`.
  8. `PatronSearchCron` deletes the item on success; on the thrown generic `\Exception` it **releases** the item (not deletes — the `deleteItem` line is commented `:57-58`), so it will be retried on a later drain.
- Postconditions:
  - One App Search document per processed entity created/upserted in engine `patron-search` (App Search POST /documents is an upsert keyed by the `id` field `"{type}:{entityId}"`). `Confirmed` (endpoint is App Search `/documents`; upsert semantics `Hypothesis` from App Search API convention).
  - Queue item deleted on success; released (retryable) on failure. `es_upload` **state cursor is NOT touched** by the queue worker (only the full re-index command maintains `\Drupal::state()->get('es_upload')`). `Confirmed`.
- Side Effects:
  - Outbound HTTPS POST to Elastic App Search per entity save (after drain). PII leaves the platform boundary (see Constraints).
  - `sleep(1)` per document → serialized, slow drain (≤ ~1 doc/s, ≤ 500 docs/run). `Confirmed`.
  - Log writes: logger channel `EsUploadCommand` (info per doc) + STDOUT `fwrite`; Telegram alert (`logger.telegram->log(3, …)`) on send error or unclaimable queue (`EsUploadQueue.php:259-265`, `PatronSearchCron.php:44,48,52,56,66,70-76`).
  - `dedup guard`: `addToQueue` skips enqueue if a `queue` row already matches name + `%entity_type%` + `%id%` via `LIKE` (`PatronBaseService.php:417-420`) — collapses repeated saves into one pending item (but see Failure Modes for the LIKE-substring flaw).
- Integration Calls:
  - **Elastic App Search** — `POST <redacted>/api/as/v1/engines/patron-search/documents`, `Authorization: Bearer <redacted>` (`EsUploadQueue.php:232-238`; mirrored in `EsUploadCommand.php:286-291`). Host is a hardcoded Elastic Cloud App Search deployment URL — <redacted>. This is a **distinct** Elastic surface from the audit-log store (`elasticsearch` module, `http://elasticsearch:9200`) and from the Elastic Cloud `organisations` index (`organisation/src/OrganisationCron.php`) — see [../../repo-map/integrations.md](../../repo-map/integrations.md):49-51.
- Failure Modes:
  - **Queue silently never drains** — with `patron_search_cron()` commented out (`patron_search.module:27-35`) and no `cron` key on the worker, if no external scheduler runs `patron_search:process_queue`, `es_upload_queue` grows unbounded and the App Search index goes stale. `Confirmed` (code) — Risk: **Async / Data-Loss (index staleness)**.
  - **Missing `ELASTIC_AUTH`** — worker throws `missing elastic auth`; `PatronSearchCron` catches the generic `\Exception` and **releases** the item, so it retries forever on every drain without progress (busy-loop up to 500/run, each preceded by `sleep(1)`). `Confirmed` — Risk: **Async**.
  - **App Search returns per-doc `errors`** — `result=false` → `processItem` throws → item **released** (retryable), Telegram alert fired. Persistent doc-level errors (schema mismatch) retry indefinitely. `Confirmed` — Risk: **Async / External Integration**.
  - **cURL/network hard failure** — `curl_exec` returns false → `json_decode(false)` yields null → the `foreach ($response …)` iterates nothing → `result` stays `true` → item **deleted as if successful** while nothing was indexed → **silent index gap**. `Confirmed` — Risk: **Data-Loss / Async / Idempotence**.
  - **Dedup LIKE-substring collision** — the guard matches `data LIKE '%{id}%'` (`PatronBaseService.php:417`); id `1` matches `12`, `310`, etc., and `entity_type` substring-matches across types, so a pending item for a different-but-substring-overlapping entity can suppress a legitimate enqueue → missed index update. `Hypothesis` (concrete collision inferred from the LIKE pattern) — Risk: **Data-Loss / Idempotence**.
  - **No delete-from-index** — no entity type removes its App Search document on delete: `CampaignEntity::postDelete` (`campaign/src/Entity/CampaignEntity.php:964-972`) only invalidates cache tags; application/transaction have no `postDelete`/`preDelete` handler at all. Deleted entities remain searchable → **orphan documents / PII persistence after deletion**. `Confirmed` — Risk: **Data-Loss / Legal-GDPR**.
  - **Stale-read window** — worker re-loads the entity at drain time, not enqueue time, so it indexes the *latest* state; combined with the 3600 s claim lease, a crashed drain holds items invisible for up to an hour before re-claim. `Confirmed` (lease value) — Risk: **Async**.
  - **`getName()` NULL / route errors** — `addCommonFields` calls `entity->getName()` and `Url::fromRoute` unconditionally; a routeless/nameless entity would throw, releasing the item to retry forever. `Hypothesis`.

## C. Data Footprint
- Entities Written:
  - No relational DB entity mutated by the drain (pure read + outbound POST). Physical writes: (a) rows in the Drupal `queue` table (enqueue via `createItem`, `PatronBaseService.php:422`; delete/release via `PatronSearchCron`); (b) documents in the external Elastic App Search engine `patron-search`.
- Entities Read (loaded fresh in the worker):
  - `user` (PatronUser) — mail, first/last name, roles, `login` timestamp; joins `contact` (phone); calls `patron_base.default:getUsersDonationsTotal($uid)`; raw SQL `select count(*) from application where patron=:id or fundraiser=:id` for `app_count` (`EsUploadQueue.php:61-91`).
  - `application` — via `ApplicationEntity::load`; pulls fundraiser/patron `contact` (email, **rc/birth-number**, phone, name), `child` (name, **rc**), `organisation` name, `campaign->getSearchData()`, `getStateLabel()` (`:105-131`).
  - `campaign` — via `CampaignEntity::load`; `getSearchData()` (id/name/status/gift_price/campaign_raised/created/links, `campaign/src/Entity/CampaignEntity.php:1277-1290`) + patron, patron_organisation, application_id, gift_category, bank (`getCampaignReceivedMoney`), deadline, lead_created, completed/published/uncompleted timestamps, kraj (`EsUploadQueue.php:133-156`).
  - `organisation` — via `OrganisationEntity::load`; only `contact.email` + common fields (`:158-166`).
  - `transaction` — via `TransactionEntity::load`; price, transaction email, `ext_status`, `ext_trans_id`, comment (`:168-182`).
  - Supporting tables reached indirectly: `contact`, `campaign`, `application_states`(via `getStateLabel`/state), `queue` (dedup lookup).
- Constraints involved:
  - **PII/GDPR (critical):** application documents ship **birth numbers (`rc`) of fundraiser and child**, emails, phones, full names to an external SaaS search index (`EsUploadQueue.php:117-123`). No field-level masking; `prepareData()` only drops empties. Risk: **Legal-GDPR / Security**.
  - No transactional consistency between DB save and index: enqueue is inside `postSave` (post-commit) but drain is asynchronous and can silently drop (see Failure Modes). No idempotency key beyond App Search's `id` upsert.
- Multi-tenant scope assumptions:
  - **Single shared App Search engine `patron-search` for all countries** — no CZ/RO/MD tenant/domain field is added to the document and no per-country routing exists (`EsUploadQueue.php` builds one flat doc regardless of tenant). All tenants' PII co-mingle in one index. `Confirmed` — Risk: **Multi-tenant / Legal-GDPR**.

## D. Evidence Block
- Controller paths: none (no HTTP route inbound; the search UI is a React bundle loaded by `SearchBlock` from an external host, `patron_search/src/Plugin/Block/SearchBlock.php:22-42` — separate read-side, not this flow).
- Service methods:
  - `PatronBaseService::addToQueue($entity_type,$id,$name='es_upload_queue')` — `patron_base/src/PatronBaseService.php:416-426` (dedup LIKE guard `:417`, `createItem` `:422`, Telegram-alert-on-failure `:424`).
  - `PatronSearchCron::processQueue($queueId)` — `patron_search/src/PatronSearchCron.php:25-68` (500-iter loop, 3600s claim, requeue/suspend/server/generic exception handling `:42-59`); `execute()` `:14-16`.
  - `EsUploadQueue` worker methods — `processItem` `:39`, `updateData` `:53`, `exportUser/Application/Campaign/Organisation/Transaction` `:61/105/133/158/168`, `addCommonFields` `:184`, `prepareData` `:199`, `sendToElastic` `:220`, `printMsg` `:259` (all `patron_search/src/Plugin/QueueWorker/EsUploadQueue.php`).
  - `EsUploadCommand` full re-index — `patron_search/src/Command/EsUploadCommand.php` (`execute` `:59`, state cursor `es_upload` `:63-71`, `getIds` paged by last-id `:80-99`, per-type export mirrors worker, `sendToElastic` updates cursor `:311-312`).
- Repository usage: no entity repository/storage writes; entities loaded via `User::load` / `ApplicationEntity::load` / `CampaignEntity::load` / `OrganisationEntity::load` / `TransactionEntity::load`; raw `\Drupal::database()->query` for `app_count` and the dedup `queue` lookup.
- Event listeners: none (this flow is enqueue-on-postSave + queue drain, not an EventSubscriber). Note `postSave` of application/campaign ALSO dispatch status-update events (FL005/other) — orthogonal to this flow.
- Async messages:
  - Queue `es_upload_queue` (Drupal DB queue) — created `patron_search.install:5-9`; enqueued by `addToQueue`; drained by `PatronSearchCron::processQueue`.
  - Related queue `mautic_queue` enqueued alongside from `PatronUser::postSave:53` — belongs to FL049, cross-referenced only.
- Config evidence:
  - `patron_search/console.services.yml` — registers commands `patron_search:upload_to_es` (`EsUploadCommand`) and `patron_search:process_queue` (`ProcessQueueCommand`).
  - `patron_search/patron_search.module:27-35` — `patron_search_cron()` body **commented out** (queue not drained by module cron).
  - `patron_search/patron_search.install:5-9` — `hook_update_8001` creates the queue (message text mislabels it "slack_integration", copy-paste artefact).
  - `EsUploadQueue.php:227-232` / `EsUploadCommand.php:281-286` — endpoint `<redacted>` + `Bearer <redacted>` (from `$_ENV['ELASTIC_AUTH']`; value never present in scrubbed source).
  - Cross-ref: [../../repo-map/integrations.md](../../repo-map/integrations.md):50 (patron_search App Search — `Partial`, endpoint now re-verified here as App Search `/documents`); :49,:51 (the two *other* Elastic surfaces, distinct from this one); [../../spec-draft/SRV-target-list.md](../../spec-draft/SRV-target-list.md):45,54 (SRV0016 Adapter + Processor).

> START-hint reconciliation: hint asked "what enqueues items (entity postSave hooks for user/application/campaign/organisation/transaction?)" — **confirmed: all five**, each via `addToQueue` in its `postSave`. The queue worker is `EsUploadQueue` and the drush/console command is `patron_search:upload_to_es` (full re-index, bypasses queue) plus `patron_search:process_queue` (drains queue). Key finding beyond the hint: the module's own cron drain is **commented out**, so the queue depends on an external invocation of `process_queue` — treated as `Hypothesis`/gap, surfaced in Failure Modes.
