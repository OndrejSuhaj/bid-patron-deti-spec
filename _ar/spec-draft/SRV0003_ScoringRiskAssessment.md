# SRV0003 — Scoring & Risk Assessment

Status: Confirmed
> AR:SRVCurator draft · 2026-07-01 · see [SRV-candidates.md](SRV-candidates.md)

## Bounded Context
C2 — Risk & Scoring

## SRV Category
Domain Service

## Responsibility Type
Core Domain

## Purpose
Performs risk assessment on applications — computing scoring outcomes for fundraiser/patron/gift, persisting scoring snapshots, and maintaining black/white-list decisions. It is the risk-decision boundary: a `scoring_ok` outcome auto-promotes `contact.blacklist_type`, so blacklist is absorbed here as a data layer written by scoring rather than a separate service.

## Current Implementation Shape
- **Scoring form/flow:** `ScoringForm` (1980 LOC) — the main scoring workflow. `Evidence:` `PSRC/web/modules/custom/scoring/src/Form/ScoringForm.php` (wc -l verified 2026-07-01).
- **Scoring snapshot entity:** `scoring_entity` (json_package, entity_id as plain int — no FK to scored entity). `Evidence:` `PSRC/web/modules/custom/scoring/src/Entity/ScoringEntity.php`; [db-models.md `scoring_entity`](../evidence/db-models.md).
- **On-application scoring fields:** `application.scoring` / `scoring_low_risk` (JSON), `scoring_fundraiser|patron|gift` (ok/ko), `scoring_coord_decision`. `Evidence:` [db-models.md `application`](../evidence/db-models.md).
- **Blacklist (absorbed):** `blacklist` entity (type wl_zd/wl_z/wl_n/bl, person fundraiser/patron/gift/spotter, required link to application); `contact.blacklist_type` mirrors decision. `Evidence:` `PSRC/web/modules/custom/blacklist/src/Entity/BlacklistEntity.php`; [db-models.md `blacklist`,`contact`](../evidence/db-models.md).
- **Triggers:** scoring routes + `ScoringController`; reacts to status changes via `scoring` module's `ApplicationStatusUpdateSubscriber`. `Evidence:` [entrypoints.md §3,§6](../repo-map/entrypoints.md); `PSRC/web/modules/custom/scoring/scoring.routing.yml`.

## Structural Issues
- **God Processor** — `ScoringForm` at 1980 LOC mixes UI, rules, persistence, and external-registry calls in one form class. `Evidence:` [SRV-candidates.md §5](SRV-candidates.md).
- **Cross-context write** — scoring writes `contact.blacklist_type` in C7 (Party), coupling the risk decision directly into the party aggregate. `Evidence:` [SRV-candidates.md §4](SRV-candidates.md).
- **Weak persistence links** — `scoring_entity.entity_id` is a bare integer, no reference to the scored entity; scoring outcome is duplicated across entity JSON and side entity.
- **External calls embedded** — identity/registry verification is reached from within scoring rather than through a clean adapter (see SRV0004).

## Target Shape (for rewrite)
Extract a Scoring domain service with explicit rule inputs/outputs, decoupled from the form UI. Blacklist becomes a repository behind the scoring service. Registry checks (MVČR/ARES) go through the SRV0004 port. Emit a scoring result event rather than writing `contact.blacklist_type` directly (SRV0012 consumes it).

## Integration Dependencies
Reaches MVČR + ARES only via SRV0004 (Identity & Registry Verification Adapter). No direct external endpoint owned here.

## Boundaries
Does NOT own external registry HTTP calls → SRV0004. Does NOT own the contact record it flags → SRV0012. Does NOT own application state transitions → SRV0001/SRV0002.

## Spec Alignment
N/A — no pre-existing SRV spec files (see SRV-candidates.md §1).

## Open Questions
- Is blacklist promotion synchronous inside scoring, or via the status event? `Missing evidence: scoring_ok → contact.blacklist_type write path.`
- How does `scoring` module's `ApplicationStatusUpdateSubscriber` re-trigger scoring vs. manual scoring? `Missing evidence: subscriber body trace.`
- Rule set / thresholds behind `scoring_low_risk_score`. `Missing evidence: ScoringForm rule constants inventory.`
