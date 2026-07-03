# FLW0033 — patron_base_cron scheduled publish
> AR:FlowMiner dossier · 2026-07-03 · source FlowID FL057 · see [../flow-index.md](../flow-index.md)

## A. Header
- FlowID: FL057 (dossier FLW0033)
- Flow Name: patron_base_cron scheduled publish (date-gated page publishing + homepage swap)
- Primary SRV: SRV0017 (Workflow-Engine + ScheduledPublish-Processor)
- Trigger Evidence:
  - Drupal `hook_cron`: `patron_base.module:patron_base_cron()` (`patron_base.module:163`) → `\Drupal::service('patron_base.scheduled_publish_cron')->execute()` (`patron_base.module:177`)
  - Service class: `patron_base/src/PatronBaseScheduledPublishCron.php:PatronBaseScheduledPublishCron::execute()` (`:60`) (repo path `intake/current-solution/_source/patronus/web/modules/custom/patron_base/`)
  - Service wiring: `patron_base.services.yml:28-30` (id `patron_base.scheduled_publish_cron`)
- Confidence Level: Confirmed
  > Note: flow-index rated FL057 `Partial` on the assumption the cron body was thin. On mining, the behavior is fully evidenced in a dedicated service class (`PatronBaseScheduledPublishCron`), so the upgrade to `Confirmed` is warranted. See START-hint reconciliation note at the end.

## B. Behavior Digest
- Trigger:
  - Drupal `hook_cron` fires on every Drupal cron tick (no state-gating / no daily window inside this flow, unlike FLW0027 `export_csv_cron`). `patron_base_cron` runs three cron units in order: `PatronBaseLogsCron::execute()` (`patron_base.module:164-165`), then `PatronBaseMauticCron::execute()` inside a try/catch that re-throws (`:167-174`), then the scheduled-publish unit `patron_base.scheduled_publish_cron->execute()` inside its own try/catch that logs to channel `reports` and re-throws (`:176-182`). Cadence is therefore whatever Drupal's cron scheduler is configured to (not evidenced in scrubbed source — `Hypothesis`: standard Drupal cron interval).
- Preconditions:
  - Runs as cron (system context); no per-user permission check inside `execute()` — the entity query uses `->accessCheck(FALSE)` (`PatronBaseScheduledPublishCron.php:68`). `Confirmed`.
  - Candidate selection requires node bundle `page` **or** `page_cz`, current status **unpublished** (`status = 0`), and `publish_date` **exactly equal to today** (`Y-m-d` string in the site default timezone) (`PatronBaseScheduledPublishCron.php:64-70`). `Confirmed`.
  - `publish_date` is a `datetime` field with `datetime_type: date` (date-only, no time), on `node.page` and `node.page_cz` (`config/field.storage.node.publish_date.yml:11-13`, `config/field.field.node.page.publish_date.yml`, `config/field.field.node.page_cz.publish_date.yml`). `Confirmed`.
  - `replace_homepage` is a `boolean` field on the same two bundles (`config/field.storage.node.replace_homepage.yml:10`, `config/field.field.node.page.replace_homepage.yml`, `config/field.field.node.page_cz.replace_homepage.yml`). `Confirmed`.
- Main Steps:
  1. **Compute "today"** — `$today = (new \DateTime('now', $timezone))->format('Y-m-d')` where `$timezone` is `system.date:timezone.default` from config factory (`PatronBaseScheduledPublishCron.php:61-62`). `Confirmed`.
  2. **Select due nodes** — entity query on `node` storage: `type IN ('page','page_cz')` AND `status = 0` AND `publish_date = $today`, `accessCheck(FALSE)`, `sort('nid','ASC')` (`PatronBaseScheduledPublishCron.php:64-70`). Early-return if empty (`:72-74`). `Confirmed`.
  3. **Publish each due node (ordered by nid ASC)** — for each nid: load node; if load fails, `continue` (`:80-84`); else `$node->setPublished(); $node->save();` and append to `$published_nids` (`:86-88`). `Confirmed`.
  4. **Homepage swap (first flagged node only)** — if `!$homepage_replaced` and the node's `replace_homepage` boolean is truthy, call `replaceHomepage($node)` and set `$homepage_replaced = TRUE` (`:90-93`). Because the flag is latched, at most **one** homepage replacement happens per cron run even if several due nodes carry the flag; the first (lowest nid) wins. `Confirmed`.
  5. **`replaceHomepage($node)`** (`:108-143`):
     a. Load existing `path_alias` where `alias = '/homepage'` (`:109-110`); if none, return (`:112-114`). `Confirmed`.
     b. Take the first match; read its target `path`; if it does not match `^/node/(\d+)$`, return (`:117-122`). `Confirmed`.
     c. Load the old node from the captured nid; if it exists, `setUnpublished(); save()` — i.e. **the previous homepage node is unpublished** (`:124-129`). `Confirmed`.
     d. Rename the old alias from `/homepage` to `/homepage-{oldNid}`, preserving its langcode + status, and save (`:130-134`). `Confirmed`.
     e. Create a **new** `path_alias` mapping `/node/{newNid}` → `/homepage` (same langcode + status as the old alias) and save (`:136-142`). `Confirmed`.
  6. **Log summary** — `logger('patron_base')->info(...)` with the list of published nids and whether the homepage was replaced (`:96-99`). `Confirmed`.
- Postconditions:
  - Zero-or-more `page`/`page_cz` nodes with `publish_date == today` transition unpublished → **published** (`status 0 → 1`). `Confirmed`.
  - If a published node had `replace_homepage = TRUE` (first such by nid), the `/homepage` alias now points to that new node, the old `/homepage` alias is renamed `/homepage-{oldNid}`, and the previously-homepaged node is **unpublished**. `Confirmed`.
  - An `info` log line exists on channel `patron_base` recording the batch. `Confirmed`.
  - No campaign, blog, or `application` status transitions occur (this flow does not touch those entities — see START-hint reconciliation). `Confirmed`.
- Side Effects:
  - Node entity writes: `node.save()` on each published node (triggers full Drupal node save pipeline — update hooks, cache invalidation, search re-index queue enqueue if configured). `Confirmed` (the `save()` call); downstream hook side effects are `Hypothesis` (not traced here).
  - Path-alias writes: rename of the old `/homepage` alias + create of a new `/homepage` alias + unpublish-save of the old homepage node (`replaceHomepage`). `Confirmed`.
  - Related safeguard on the manual edit path (not this cron, but same field): `patron_base_entity_validate()` blocks **manual** publishing of a `page`/`page_cz` whose `publish_date` is in the future, throwing `EntityMalformedException` ("Cannot publish a page with a future publish date. Save as unpublished first.") (`patron_base.module:87-107`). This is the human-facing counterpart that keeps future-dated pages unpublished until the cron publishes them. `Confirmed`.
  - Log writes: `patron_base` channel (info summary, `:96`); on thrown exception, `reports` channel error via the cron wrapper (`patron_base.module:180`). `Confirmed`.
- Integration Calls:
  - None. No external HTTP/API integrations, no queue, no filesystem sink. Purely internal entity + path_alias mutations. `Confirmed`. (Matches absence of this flow from [../../repo-map/integrations.md](../../repo-map/integrations.md) integration tables.)
- Failure Modes:
  - **Exact-date equality miss (Data-Loss / correctness).** Selection uses `publish_date = $today` (strict equality), **not** `<= $today` (contrast FLW0027 which uses `+1 day <=` gating). If a Drupal cron tick is missed for a whole day (cron down, deploy, host offline) or a node is created with a past `publish_date`, the node's publish day passes and it is **never** auto-published — it stays unpublished indefinitely until manually published (and the validator then permits it because `publish_date <= today`). `Confirmed` (equality condition at `PatronBaseScheduledPublishCron.php:67`). This is the highest-value risk of the flow.
  - **Timezone / string comparison edge.** `publish_date` is stored as a date-only string; `$today` is computed in `system.date:timezone.default`. If stored publish_date values were ever written under a different timezone assumption, an off-by-one-day mismatch is possible around midnight. `Confirmed` (mechanism); `Hypothesis` (whether it actually mis-fires depends on how the editor UI stores the value).
  - **Homepage-swap latch skips extra flagged nodes (Boundary).** Only the first (lowest nid) due node with `replace_homepage=TRUE` swaps the homepage; any other due node also flagged is published but silently does **not** become the homepage. `Confirmed` (`$homepage_replaced` latch, `:90-93`).
  - **Homepage swap silent no-ops (Boundary).** `replaceHomepage` returns early and does nothing if there is no existing `/homepage` alias (`:112-114`) or if the existing `/homepage` alias does not point at a `/node/{n}` path (e.g. it points at an external/other path) (`:120-122`). In these cases the new node is published but the homepage is not switched, with no error and no dedicated warning log. `Confirmed`.
  - **Non-atomic multi-write (Data-Loss / consistency).** The publish loop and the homepage swap perform several independent `save()` calls with no DB transaction. A fatal mid-run (e.g. between old-alias rename and new-alias create at `:134-142`) can leave the `/homepage` alias renamed to `/homepage-{oldNid}` with **no** alias serving `/homepage`, or the old homepage node unpublished while the new one is not yet the homepage. The cron re-throws (`patron_base.module:179-182`), aborting the remainder of `hook_cron`, but partial writes are not rolled back. `Confirmed` (no transaction wrapper in `execute()`/`replaceHomepage`).
  - **Whole-cron abort on exception (Async / operational).** Any exception in `execute()` is logged to `reports` and **re-thrown** (`patron_base.module:179-182`), which propagates out of `patron_base_cron`, failing the Drupal cron run. A single bad node/alias can therefore block the entire `patron_base` cron (note `PatronBaseLogsCron` and `PatronBaseMauticCron` run *before* this unit, so they complete; but any later hook_cron implementations in other modules for the same tick may be skipped depending on Drupal's cron runner). `Confirmed` (re-throw); `Hypothesis` (exact impact on sibling modules' cron).
  - **Idempotence.** Re-running within the same day is safe for the publish step (already-published nodes have `status=1` and no longer match `status=0`, so they are not re-selected). The homepage swap is also naturally idempotent within a day because once swapped the source node is published (no longer selected). `Confirmed`.
  - **Multi-language homepage (Multi-tenant / i18n).** `replaceHomepage` copies langcode+status from the *old* `/homepage` alias onto the new alias (`:130-142`) and matches `/homepage` without a langcode filter (`loadByProperties(['alias' => '/homepage'])`, `:110`). On a multi-language site (cs/en/ru/ro per [../../repo-map/integrations.md](../../repo-map/integrations.md):103) there may be several `/homepage` aliases; `reset()` picks an arbitrary/first one, so which language's homepage is swapped is not deterministic from this code alone. `Confirmed` (no langcode filter); `Hypothesis` (real-world ambiguity depends on how many `/homepage` aliases exist).

## C. Data Footprint
- Entities Written:
  - `node` (bundles `page`, `page_cz`) — `status` flipped 0→1 via `setPublished()`+`save()` (`PatronBaseScheduledPublishCron.php:86-87`); the prior homepage node flipped 1→0 via `setUnpublished()`+`save()` in `replaceHomepage` (`:127-128`).
  - `path_alias` — existing `/homepage` alias renamed to `/homepage-{oldNid}` (`:133-134`); new alias `/node/{newNid}` → `/homepage` created (`:136-142`).
- Entities Read:
  - `node` (query for due nodes `:64-70`; load per nid `:81`; load old homepage node `:125`).
  - `path_alias` (load existing `/homepage` `:109-110`).
  - Config: `system.date` (`timezone.default`) read via config factory (`:61`).
- Constraints involved:
  - Selection predicate constraints only (bundle IN, status=0, publish_date=today) — no explicit DB constraint enforcement by this flow. `Confirmed`.
  - No datetime range/`<=` comparison — strict equality (see Failure Modes). `Confirmed`.
  - Relies on Drupal node + path_alias schema integrity (see [../db-inventory.md](../db-inventory.md); `page`/`page_cz` are Drupal core `node` bundles carrying config fields, not custom entity types — db-inventory §"Node content types (5)" and :71).
- Multi-tenant scope assumptions:
  - **No country/tenant (CZ/RO/MD) predicate** in the node query — it selects across all `page`/`page_cz` nodes regardless of language/country. Multi-country is served by one Drupal instance via path-prefix language negotiation (cs/en/ru/ro) per [../../repo-map/integrations.md](../../repo-map/integrations.md):103-104; the `page_cz` bundle is a CZ-specific content type while `page` is the general/RO ("Pagină simplă") type (db-inventory §121). The cron treats both uniformly. The homepage swap's lack of langcode scoping (see Failure Modes) is the multi-tenant boundary concern. `Confirmed` (no country filter); `Hypothesis` (intended per-language homepage semantics).

## D. Evidence Block
- Controller / entry paths:
  - `intake/current-solution/_source/patronus/web/modules/custom/patron_base/patron_base.module` (`patron_base_cron` `:163-183`; scheduled-publish delegation `:176-182`; manual-publish guard `patron_base_entity_validate` `:87-107`).
- Service methods:
  - `intake/current-solution/_source/patronus/web/modules/custom/patron_base/src/PatronBaseScheduledPublishCron.php` (`execute` `:60-100`; `replaceHomepage` `:108-143`; constructor DI `:47-55`).
  - Sibling cron units in the same hook (context, not part of this flow's publishing logic): `patron_base/src/PatronBaseLogsCron.php`, `patron_base/src/PatronBaseMauticCron.php`.
- Repository usage:
  - Entity API via `EntityTypeManagerInterface`: `getStorage('node')->getQuery()` (`:64`), `getStorage('node')->load()` (`:81,125`), `getStorage('path_alias')->loadByProperties()` / `->create()` (`:109-110,136`). No raw SQL, no custom repository. `accessCheck(FALSE)` on the selection query (`:68`).
- Event listeners: none dispatched or subscribed by this flow. (Node `save()` may fire generic Drupal entity hooks/subscribers elsewhere — not traced; `Hypothesis`.)
- Async messages: none. No Drupal queue, no RabbitMQ. "Scheduled" only in the `hook_cron` sense.
- Config evidence:
  - `patron_base/patron_base.services.yml:28-30` — service `patron_base.scheduled_publish_cron` (class `PatronBaseScheduledPublishCron`, args `@entity_type.manager`, `@config.factory`, `@logger.factory`).
  - `config/field.storage.node.publish_date.yml` — `type: datetime`, `datetime_type: date`, `entity_type: node`, `translatable: true`.
  - `config/field.field.node.page.publish_date.yml`, `config/field.field.node.page_cz.publish_date.yml` — field instances binding `publish_date` to the two bundles.
  - `config/field.storage.node.replace_homepage.yml` — `type: boolean` (core), `entity_type: node`.
  - `config/field.field.node.page.replace_homepage.yml`, `config/field.field.node.page_cz.replace_homepage.yml` — boolean field instances on the two bundles.
  - `config/core.entity_form_display.node.page.default.yml`, `config/core.entity_form_display.node.page_cz.default.yml` — expose `publish_date`/`replace_homepage` on the editor form (evidence the editor sets these values).
  - Cross-ref: [../../spec-draft/SRV-target-list.md](../../spec-draft/SRV-target-list.md) (SRV0017 Workflow-Engine); [../db-inventory.md](../db-inventory.md) (node bundles `page`/`page_cz`, :71,:121).

> Note on START-hint reconciliation: the hint anticipated "date-gated publishing of campaign and/or blog content (publish_on style)". The actual `patron_base.scheduled_publish_cron` publishes only **CMS `page`/`page_cz` node bundles** (not `campaign`, not `blog`) via a strict `publish_date = today` equality condition, plus an optional `/homepage` alias swap. No `publish_on`-style unpublish-on-date behavior exists here. Recorded as a scope correction, not a conflict. Campaign publishing/auto-complete lives in a separate flow (`campaign_cron`, FL045); blog has no scheduled-publish cron in custom code (grep of `PatronBaseScheduledPublishCron` shows no `blog`/`campaign` symbols). The flow-index `Partial` confidence for FL057 is superseded by `Confirmed` on the basis of the dedicated, fully-readable service class.
