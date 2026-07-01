# Task — MissingCoreEntityWriter

Run AR:MissingCoreEntityWriter

Load and strictly follow:

tooling/orchestration/90-optional-bonus/inventory-closure/agents/MissingCoreEntityWriter.md

Write ONLY to:

- `_ar/spec-draft/**`
- `_ar/evidence/**`
- `_ar/coverage/**`

Do not modify production code or existing EN numbering.

---

## Goal

Close a small, explicitly requested set of missing core EN pages that are already evidenced but still absent from the EN layer.

This run is narrow.
It is not a broad EN expansion pass.

---

## Pre-check

Confirm reading of:

- `_ar/spec-draft/ENTITY-inventory.md`
- `_ar/spec-draft/ENTITY-classification.md`
- `_ar/spec-draft/ENTITY-coverage-matrix.md`
- `_ar/spec-draft/EntityInventoryCloser-report.md`
- `_ar/spec-draft/EN/`
- `_ar/spec-draft/DOMAIN-kernel.md`
- `_ar/spec-draft/DOMAIN-aggregates.md`
- `_ar/spec-draft/ARCH0001_ApplicationOverview.md`
- `_ar/spec-draft/ARCH0002_ContextInteractionMap.md`
- `_ar/spec-draft/REWRITE-decision-pack.md`
- `_ar/spec-draft/REWRITE-sequencing.md`

Strongly recommended if present:

- `_ar/spec-draft/UC/`
- `_ar/evidence/flow/`
- `_ar/spec-draft/SRV-flow-traceability.md`
- `_ar/spec-draft/EN-lifecycle-evidence.md`
- `_ar/spec-draft/UI-gap-promotions.md`
- `_ar/spec-draft/UI-gap-open-questions.md`
- `_ar/evidence/ui/**`

Code evidence:

- `src/**`
- `packages/**`

---

## Required task parameters

The operator must define:

- exact entity list for this run
- whether partial EN pages are allowed
- whether blocked entities may be skipped
- whether a small cross-reference update to existing EN files is allowed

If the exact entity list is not provided, do not broaden scope on your own.

---

## Deliverables

Create or refresh:

- new EN files in `_ar/spec-draft/EN/`
- `_ar/spec-draft/MissingCoreEntityWriter-report.md`

Optional:

- `_ar/evidence/missing-core-entity-evidence.md`

---

## Rules

- Only write entities explicitly requested by this task.
- Do not run as a long-tail entity writer.
- If evidence is partial, only write the page if `Evidence Pending` can be stated explicitly.
- If evidence is insufficient and partial pages are not allowed, mark the entity blocked in the report.
- Preserve canonical English naming and existing EN numbering.
