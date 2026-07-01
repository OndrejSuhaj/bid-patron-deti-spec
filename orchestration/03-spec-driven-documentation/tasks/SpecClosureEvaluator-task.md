# Task — SpecClosureEvaluator

Run AR:SpecClosureEvaluator

Load and strictly follow:

tooling/orchestration/03-spec-driven-documentation/agents/SpecClosureEvaluator.md

Write ONLY to:

- `_ar/spec-draft/**`
- `_ar/coverage/**`
- `_ar/evidence/**`

Do not modify production code or existing core artifacts.

---

## Pre-check

Confirm reading of:

- `tooling/docs/definition-of-done.md` (closure criteria — authoritative), `tooling/docs/registry-format.md`, `tooling/docs/cross-layer-discipline.md`, `_ar/repo-map/glossary.md`
- `_ar/spec-draft/EN/`
- `_ar/spec-draft/UC/`
- `_ar/spec-draft/DOMAIN-kernel.md`
- `_ar/spec-draft/DOMAIN-aggregates.md`
- `_ar/spec-draft/ARCH0001_ApplicationOverview.md`
- `_ar/spec-draft/ARCH0002_ContextInteractionMap.md`
- `_ar/spec-draft/REWRITE-decision-pack.md` if present
- `_ar/spec-draft/REWRITE-sequencing.md` if present
- `_ar/spec-draft/ENTITY-inventory.md`
- `_ar/spec-draft/ENTITY-classification.md`
- `_ar/spec-draft/ENTITY-coverage-matrix.md`
- `_ar/spec-draft/EntityInventoryCloser-report.md` if present

Optional but recommended:
- `_ar/spec-draft/REFERENCE-INTEGRITY.md`, `_ar/spec-draft/CROSS-LAYER-audit.md`, `_ar/spec-draft/<LAYER>/_REGISTRY.md` (integrity + coverage signals)
- `_ar/spec-draft/GapClosureSpecWriter-report.md`
- `_ar/spec-draft/MissingCoreEntityWriter-report.md`
- `_ar/spec-draft/UI-gap-open-questions.md`
- `_ar/coverage/ui-gap-analysis.md`
- `_ar/evidence/flow/`

Optional 04 inputs if present:
- `_ar/spec-draft/API/`
- `_ar/spec-draft/JOB/`
- `_ar/spec-draft/ACL/`
- `_ar/spec-draft/QUERY/`
- `_ar/spec-draft/API-contract-map.md`
- `_ar/spec-draft/API-synthesis-report.md`
- `_ar/spec-draft/JOB-map.md`
- `_ar/spec-draft/JOB-synthesis-report.md`
- `_ar/spec-draft/ACL-*.md`
- `_ar/spec-draft/QUERY-*.md`

---

## Deliverables

Create or refresh:

- `_ar/spec-draft/SPEC-CLOSURE.md`

Optional:

- `_ar/spec-draft/SPEC-CLOSURE-backlog.md`

---

## Rules

- Do not invent closure.
- Do not downgrade known blockers.
- Distinguish current-state understanding, architecture planning, and greenfield rewrite readiness.
- If API/JOB/ACL/QUERY artifacts are present, include them in the evaluation.
- If API/JOB/ACL/QUERY artifacts are absent, do not fail the run; explicitly state that those layers were not yet available or not assessed.
- Evaluate each dimension against `tooling/docs/definition-of-done.md` and report a per-criterion checklist (PASS/PARTIAL/BLOCKED + evidence) with a closure state and confidence label — not a narrative-only verdict.
- Report referential-integrity factors (dangling refs, collisions, orphans from REFERENCE-INTEGRITY.md; unresolved restatements from CROSS-LAYER-audit.md); they lower confidence but do not auto-force BLOCKED. Deferred cross-tier refs are recorded, not penalized.
- Keep blockers and remaining work explicit.
- Refresh outputs in place on repeated runs.