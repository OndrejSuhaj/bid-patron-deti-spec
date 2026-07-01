# SRV0005 — Campaign & Story Lifecycle

Status: Confirmed
> AR:SRVCurator draft · 2026-07-01 · see [SRV-candidates.md](SRV-candidates.md)

## Bounded Context
C3 — Campaign & Story (Příběh)

## SRV Category
Domain Service

## Responsibility Type
Core Domain

## Purpose
Owns the `campaign` (Story / Příběh) aggregate — the public-facing story that donors support. It manages story lifecycle (publish/complete/uncomplete/cancel), the raised-amount rollup, patron public profile, group/promo parent-child relations, region assignment, and slug generation, plus the campaign activity log.

## Current Implementation Shape
- **Aggregate root:** `CampaignEntity` (1553 LOC) — base_table `campaign`, self-referencing `parent` (group/promo), lifecycle timestamps, `campaign_status` enum, `campaign_raised`/`campaign_percentual_raised` recomputed in `preSave` from transactions. `Evidence:` `PSRC/web/modules/custom/campaign/src/Entity/CampaignEntity.php`; [db-models.md `campaign`](../evidence/db-models.md).
- **Patron public profile:** `PatronEntity` (base_table `patron`, attached to a campaign). `Evidence:` `PSRC/web/modules/custom/campaign/src/Entity/PatronEntity.php`.
- **Audit trail:** `campaign_log` (field-change log). `Evidence:` `PSRC/web/modules/custom/campaign_log/src/Entity/CampaignLogEntity.php`.
- **RO working-day rule:** service `campaign.romanian_working_day_checker` + `campaign_deadline_working_day` constraint. `Evidence:` `PSRC/web/modules/custom/campaign/campaign.services.yml`; [db-models.md `campaign`](../evidence/db-models.md).
- **Triggers:** campaign routes (~5 controllers, ~10 forms), `hook_cron` (lifecycle), CLI `campaign:firebase:sync`. `Evidence:` [entrypoints.md §3,§7,§8](../repo-map/entrypoints.md); `PSRC/web/modules/custom/campaign/campaign.routing.yml`.

## Structural Issues
- **God Entity** — 1553 LOC mixing lifecycle, financial rollup, slug logic, region assignment, e-mail-sent flags. `Evidence:` [SRV-candidates.md §5](SRV-candidates.md).
- **Hidden domain logic in hooks** — raised-amount recompute + auto-completion + slug archival happen in `preSave`; `application.postSave` also writes campaign status/category (bidirectional sync). `Evidence:` [db-models.md `campaign`,`application`](../evidence/db-models.md).
- **Undeclared runtime state** — `campaign_status` value `campaign_uncompleted_inprocess` occurs at runtime but is not in allowed_values. `Evidence:` [db-models.md `campaign` Verification](../evidence/db-models.md).
- **External-table coupling** — old slugs archived to `campaign_slug_archive` (raw table, not an entity).
- **Firebase ambiguity** — `campaign:firebase:sync` only re-saves entities and prints a Jenkins message; no Firebase SDK call evidenced. `Evidence:` [integrations.md §5](../repo-map/integrations.md).

## Target Shape (for rewrite)
Campaign as a clean aggregate with explicit lifecycle commands. Move raised-amount rollup to a projection fed by payment events (SRV0007) instead of recomputing in `preSave`. Make the application↔campaign sync an explicit event, not mutual `postSave` writes. Slug/archive behind a repository.

## Integration Dependencies
None (internal domain). Firebase reference in `campaign` module is unverified — `Uncertain` per [integrations.md §5](../repo-map/integrations.md).

## Boundaries
Does NOT own donations/transactions (only rolls up their totals) → SRV0007. Does NOT own recommendation → SRV0006. Does NOT own documents/vouchers issued on payment → SRV0011. Does NOT own the application it syncs with → SRV0001.

## Spec Alignment
N/A — no pre-existing SRV spec files (see SRV-candidates.md §1).

## Open Questions
- Does `campaign:firebase:sync` actually push to Firebase anywhere? `Missing evidence: kreait/firebase-php call-site.`
- Full `campaign_status` state machine incl. undeclared `campaign_uncompleted_inprocess`. `Missing evidence: campaign status transition inventory.`
- Group / collection-account story types vs. `type` enum (basic/promo/long_term/short_term). `Missing evidence: group-story handling trace.`
