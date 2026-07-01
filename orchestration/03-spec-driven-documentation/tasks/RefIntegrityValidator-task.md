# Task — RefIntegrityValidator

Run AR:RefIntegrityValidator

Load and strictly follow:

tooling/orchestration/03-spec-driven-documentation/agents/RefIntegrityValidator.md

Write ONLY to:

- `_ar/spec-draft/**`
- `_ar/evidence/**`

Do not modify production code, config, or runtime assets, and do not edit any layer document's body
or identifiers.

---

## Pre-check

Confirm reading of:

- `tooling/docs/registry-format.md` (registry schema — authoritative)
- `tooling/docs/cross-layer-discipline.md` (expected references per layer)
- all canonical layer folders present under `_ar/spec-draft/` (EN, UC, BR, FN, ARCH, ES, MSG, CS, API, JOB, ACL, QUERY, IA, WIRE, COMP, COPY)
- per-layer `*-map.md` index files and `_ar/spec-draft/CROSS-LAYER-audit.md` if present
- `_ar/repo-map/glossary.md`

---

## Deliverables

- `_ar/spec-draft/<LAYER>/_REGISTRY.md` per present layer (status `draft`, Owner mode `AR`)
- `_ar/spec-draft/REFERENCE-INTEGRITY.md`
- `_ar/spec-draft/RefIntegrityValidator-report.md`

---

## Rules

- Build registries and validate; NEVER renumber/rename doc_ids, invent rows/targets, or edit document content.
- One row per `doc_id`; `ID` matches the doc's frontmatter; status `draft`.
- Validate all reference fields (`references` / `affects` / `realizes_uc` / `trigger` / `screen_id`); classify resolved / dangling / deferred.
- Collisions, dangling references, and orphans are reported as Open Questions, not auto-fixed.
- Run after CrossLayerAuditor, before SpecClosureEvaluator and SpecFinalGenerator.
