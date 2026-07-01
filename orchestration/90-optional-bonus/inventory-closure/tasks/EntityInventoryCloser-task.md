# Task — EntityInventoryCloser

Run AR:EntityInventoryCloser

Load and strictly follow:

tooling/orchestration/90-optional-bonus/inventory-closure/agents/EntityInventoryCloser.md

Write ONLY to:

- `_ar/spec-draft/**`
- `_ar/evidence/**`
- `_ar/coverage/**`

Do not modify production code or existing core artifacts.

---

## Goal

Create a complete as-is entity inventory of the current application so the project can be closed as:

- this is how the system looks today

without forcing full EN pages for the remaining long tail of entities.

The result should support:

- current-state understanding
- handover documentation
- future rewrite preparation
- explicit visibility of risks and deferred areas

---

## Execution mode

Conservative, evidence-first, classification-focused.

Do NOT expand the remaining entity set into full EN documents unless explicitly required later.
This run is about inventory closure, not broad EN authoring.

---

## Pre-check

Confirm reading of:

- `_ar/spec-draft/EN/`
- `_ar/spec-draft/DOMAIN-kernel.md`
- `_ar/spec-draft/DOMAIN-aggregates.md`
- `_ar/spec-draft/ARCH0001_ApplicationOverview.md`
- `_ar/spec-draft/ARCH0002_ContextInteractionMap.md`
- `_ar/spec-draft/REWRITE-decision-pack.md`
- `_ar/spec-draft/REWRITE-sequencing.md`
- `_ar/evidence/db-inventory.md`
- `_ar/evidence/db-models.md`
- `_ar/repo-map/data-model-signals.md`
- `_ar/coverage/mapped.md`
- `_ar/coverage/unmapped.md`

Code evidence:

- `src/**`
- `packages/**`

Use UI artifacts only as secondary evidence:

- `_ar/spec-draft/UI-gap-promotions.md` if present
- `_ar/spec-draft/UI-gap-open-questions.md` if present
- `_ar/coverage/ui-gap-analysis.md` if present
- `_ar/evidence/ui/**` if present

---

## Deliverables

Create or refresh:

- `_ar/spec-draft/ENTITY-inventory.md`
- `_ar/spec-draft/ENTITY-classification.md`
- `_ar/spec-draft/ENTITY-coverage-matrix.md`
- `_ar/spec-draft/EntityInventoryCloser-report.md`

Optional extra files are allowed only if clearly useful:

- `_ar/spec-draft/ENTITY-deferred-candidates.md`
- `_ar/spec-draft/ENTITY-platform-dependencies.md`

---

## Classification model to apply

Every discovered entity must receive exactly one primary classification:

- Domain
- Configuration
- Join / Assignment
- Projection / Reporting
- Audit / Log
- Infrastructure / Technical
- Uncertain

In addition, each entity must be labeled with:

- canonical name
- code alias or class name
- likely bounded context
- company-scoped yes / no / unknown
- existing EN coverage: yes / partial / no
- rewrite relevance: high / medium / low
- platform suspicion: yes / no

---

## Rules

- Include all reasonably identifiable persisted application entities.
- Treat existing EN files as canonical anchors.
- Prefer short inventory entries over speculative narrative descriptions.
- If an entity appears to belong to shared or platform capability, include it but mark it clearly as `Platform Suspicion`.
- Do not write large batches of new EN files in this run.
- Do not broadly rewrite existing EN files.
- Do not make rewrite architecture decisions beyond rewrite relevance.

---

## Stop conditions

Stop and record explicit blockage if:

- code and DB evidence cannot be reconciled
- entity count differs significantly across sources with no explanation
- a large cluster of entities cannot be assigned even a provisional context

If this happens, document it in the report under:

- `Blocked Reconciliation Issues`

---

## Success criteria

This run is successful if:

- all identifiable persisted entities are present in the inventory
- every entity has a classification and coverage status
- core vs long-tail entities are clearly distinguished
- platform suspicion areas are separated
- the report gives a credible as-is closure verdict