# Task — CrossLayerAuditor

Run AR:CrossLayerAuditor

Load and strictly follow:

tooling/orchestration/03-spec-driven-documentation/agents/CrossLayerAuditor.md

Write ONLY to:

- `_ar/spec-draft/**`
- `_ar/evidence/**`

Do not modify production code, config, or runtime assets.

---

## Pre-check

Confirm reading of:

- `tooling/docs/cross-layer-discipline.md` (ownership table — authoritative)
- `_ar/repo-map/glossary.md`
- all canonical layer folders present under `_ar/spec-draft/` (EN, UC, BR, FN, ARCH, ES, MSG, CS, API, JOB, ACL, QUERY, IA, WIRE, COMP, COPY)
- `tooling/docs/rules-<LAYER>.md` for the layers in scope

---

## Deliverables

- refreshed `_ar/spec-draft/<LAYER>/` documents with cross-layer restatement replaced by `doc_id` references
- `_ar/spec-draft/CROSS-LAYER-audit.md`
- `_ar/spec-draft/CrossLayerAuditor-report.md`

---

## Rules

- De-duplicate only; NEVER change meaning or delete a layer's own owned content.
- Replace borrowed restatement with the owner's `doc_id` reference (frontmatter + inline) + optional ≤50-char orientation summary.
- If the owning doc is missing or context-poor, flag it and leave the restatement as an Open Question — do not move content silently.
- Preserve identifiers, structure, and evidence/certainty labels; honor the >50-char threshold and documented exceptions.
- Run after layer authoring/canonicalization, before SpecClosureEvaluator and SpecFinalGenerator.
