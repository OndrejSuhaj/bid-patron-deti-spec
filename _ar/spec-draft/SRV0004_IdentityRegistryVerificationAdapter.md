# SRV0004 — Identity & Registry Verification Adapter

Status: Confirmed
> AR:SRVCurator draft · 2026-07-01 · see [SRV-candidates.md](SRV-candidates.md)

## Bounded Context
C2 — Risk & Scoring

## SRV Category
Integration Adapter

## Responsibility Type
Adapter

## Purpose
Wraps outbound calls to Czech government registries used during risk assessment: MVČR invalid-documents check (ID-card / passport validity) and ARES business-registry lookup. It converts external XML/registry responses into scoring inputs for SRV0003. It is the only place in C2 that talks to external identity systems.

## Current Implementation Shape
- **MVČR document validity:** `IdentityCardService` — GET `http://aplikace.mvcr.cz/neplatne-doklady/doklady.aspx` with `{dotaz: idCard, doklad: 0}`, parses XML (`evidovano = ne` → valid). `Evidence:` `PSRC/web/modules/custom/scoring/src/IdentityCardService.php`; [integrations.md §6](../repo-map/integrations.md).
- **ARES registry:** `AresController` in scoring module (CZ business registry lookup). `Evidence:` `PSRC/web/modules/custom/scoring/src/Controller/AresController.php`; [integrations.md §6](../repo-map/integrations.md) (indexed, not re-verified for endpoint).
- **Consumer:** invoked from the scoring flow (SRV0003). No dedicated queue/cron; called inline during scoring. `Evidence:` co-located in `scoring` module.

## Structural Issues
- **Adapter co-located with domain** — both classes live inside the `scoring` module, so the external boundary is not separable from scoring rules. `Evidence:` [integrations.md §6](../repo-map/integrations.md).
- **Plaintext HTTP** — MVČR endpoint is `http://` (not TLS). `Evidence:` `IdentityCardService.php` (`MVCR_URL`).
- **XML-scraping fragility** — validity is inferred from an XML string field (`evidovano`), brittle to registry format changes.
- **ARES call surface unverified** — endpoint/behaviour not re-verified in this pass (`Hypothesis`). `Evidence:` [integrations.md §6](../repo-map/integrations.md) "indexed only".

## Target Shape (for rewrite)
A `RegistryVerification` port with two adapters (MVCR, ARES) returning typed verification results; TLS-only; timeouts/retries/circuit-breaker; response caching keyed by document/ICO. Domain (SRV0003) depends on the port, never the HTTP client.

## Integration Dependencies
- MVČR neplatné doklady — `http://aplikace.mvcr.cz/neplatne-doklady/doklady.aspx` (GET, XML). `Confirmed` — [integrations.md §6](../repo-map/integrations.md).
- ARES (CZ business registry) — endpoint not re-verified. `Hypothesis` — [integrations.md §6](../repo-map/integrations.md).

## Boundaries
Does NOT make scoring decisions → SRV0003. Does NOT own blacklist data → SRV0003. Does NOT own party/contact records → SRV0012.

## Spec Alignment
N/A — no pre-existing SRV spec files (see SRV-candidates.md §1).

## Open Questions
- Exact ARES endpoint, request shape, and consumers. `Missing evidence: AresController body verification.`
- Is MVČR/ARES called per-application, cached, or batch? `Missing evidence: call-site frequency trace in ScoringForm.`
- Failure handling when registry is unreachable (blocks scoring vs. defaults). `Missing evidence: error path in IdentityCardService.`
