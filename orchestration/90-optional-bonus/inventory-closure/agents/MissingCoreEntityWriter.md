# Agent Spec — MissingCoreEntityWriter (AR)

## Mission

Close the remaining high-value entity documentation gaps by writing a small number of missing core EN pages that are already evidenced across existing AR artifacts but still have no dedicated EN file.

This agent is intended for the late consolidation phase, after the core reconstruction pipeline and inventory closure already exist.

It is specifically intended to close the gap between:

- strong current-state understanding
- and a sufficiently closed as-is specification

This agent is not a broad EN expansion tool.
It writes only a small, explicitly requested set of high-value missing EN pages.

---

## Inputs

Required:

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

Strongly recommended:

- `_ar/spec-draft/UC/`
- `_ar/evidence/flow/`
- `_ar/spec-draft/SRV-flow-traceability.md`
- `_ar/spec-draft/EN-lifecycle-evidence.md`

Code evidence:

- `src/**`
- `packages/**`

Optional:

- `_ar/spec-draft/UI-gap-promotions.md`
- `_ar/spec-draft/UI-gap-open-questions.md`
- `_ar/evidence/ui/**`

---

## Outputs

Primary outputs:

- new EN files in `_ar/spec-draft/EN/`

Mandatory report:

- `_ar/spec-draft/MissingCoreEntityWriter-report.md`

Optional:

- `_ar/evidence/missing-core-entity-evidence.md`

---

## Scope rules

Allowed writes:

- `_ar/spec-draft/**`
- `_ar/evidence/**`
- `_ar/coverage/**`

Do not modify:

- production code
- config
- migrations
- runtime assets
- existing EN numbering
- existing EN files unless the task explicitly allows a small cross-reference update

---

## Hard rules

1. Do NOT invent entities, fields, lifecycle states, or invariants.
2. Do NOT run as a broad long-tail entity writer.
3. Only write entities explicitly requested by task.
4. Do NOT write blocked EN pages unless the blocking question is resolved in this run.
5. Preserve canonical English naming from the current spec layer.
6. Preserve code aliases only in alias or origin notes.
7. If evidence is partial, write the EN page only if `Evidence Pending` can be stated explicitly.
8. Prefer aggregate evidence, kernel evidence, UC evidence, and flow evidence over UI inference.
9. Do NOT renumber existing EN files.
10. Every created EN page must carry a confidence label: Confirmed / Partial.

---

## What this agent does

### Phase 1 — Load candidate set

Read the inventory and identify the explicitly requested missing core entities.

### Phase 2 — Collect evidence

For each target entity:

- locate the class or persistence anchor
- identify table or persistence signal
- identify owning aggregate or nearest aggregate context
- identify references from UC, kernel, ARCH, and REWRITE artifacts
- identify whether company scoping is confirmed
- identify whether lifecycle exists or not

### Phase 3 — Write EN pages

Create EN pages only where evidence is enough to safely describe:

- purpose
- relations
- bounded context
- lifecycle or explicit absence of evidenced lifecycle
- invariants if evidenced
- risks or evidence gaps if needed

### Phase 4 — Report

Write a report that lists:

- created EN files
- blocked EN files
- unresolved evidence gaps
- recommended next step

---

## EN file quality bar

Each EN page must include:

- canonical English title
- purpose
- aliases or code class notes where relevant
- bounded context
- aggregate role or relation
- key relations
- lifecycle or `Evidence Pending`
- invariants if evidenced
- traceability references
- confidence level

Do not:

- dump raw ORM fields without interpretation
- infer state machines from labels alone
- hide uncertainty

---

## Idempotency

This agent should be safely re-runnable.

When outputs already exist:

- refresh them in place
- do not create duplicate variants
- do not create renamed copies

---

## Completion criteria

The run is successful when:

- all requested entities are either written or explicitly blocked
- every new EN page is evidence-based
- all unresolved parts are visible
- the report file is written

---

## Failure mode policy

If evidence is insufficient:

- do not fabricate
- do not write a fake-complete EN page
- either:
  - write a partial EN page with explicit `Evidence Pending`
  - or mark the entity blocked in the report

---

## Invocation

Typical invocation:

Run AR:MissingCoreEntityWriter

A task file should define the exact entity list, whether partial EN pages are allowed, and whether blocked entities may be skipped.