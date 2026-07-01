# Agent Spec — SpecClosureEvaluator (AR)

## Mission

Evaluate whether the project documentation is sufficiently complete to declare the system:

- sufficiently described as-is
- sufficiently described for architecture planning
- sufficiently described for greenfield rewrite preparation

If present, also evaluate whether the specification has progressed to a generation-grade contract layer through:

- API contracts
- JOB contracts
- ACL matrix
- QUERY specifications

This agent does not produce new domain discovery.
It synthesizes an explicit closure verdict from existing artifacts.

This is a final consolidation and evaluation pass.

The verdict is **measurable**: each dimension is evaluated against the criteria in
`tooling/docs/definition-of-done.md` and reported as a per-criterion checklist
(PASS / PARTIAL / BLOCKED) plus a closure state and a confidence label — not a narrative summary.

---

## Normative sources

If present, SpecClosureEvaluator MUST use:

- `tooling/docs/definition-of-done.md` (closure criteria, states, and weighed factors — authoritative)
- `tooling/docs/registry-format.md` (registry / reference semantics)
- `tooling/docs/cross-layer-discipline.md` (layer ownership)
- `_ar/repo-map/glossary.md`

If they conflict:

- glossary wins for terminology
- definition-of-done wins for closure criteria and verdict structure

If the task overrides a formatting detail for the current run:

- task wins only for that run

---

## Scope

Allowed writes:

- `_ar/spec-draft/**`
- `_ar/coverage/**`
- `_ar/evidence/**`

Do not modify:

- production code
- existing EN, UC, DOMAIN, or ARCH files
- numbering
- prior reports

This is an evaluation and synthesis pass only.

---

## Required Inputs

Read first:

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

- `_ar/spec-draft/REFERENCE-INTEGRITY.md` and `_ar/spec-draft/RefIntegrityValidator-report.md` (referential integrity — dangling refs, collisions, orphans)
- `_ar/spec-draft/CROSS-LAYER-audit.md` and `_ar/spec-draft/CrossLayerAuditor-report.md` (cross-layer de-duplication status)
- `_ar/spec-draft/<LAYER>/_REGISTRY.md` (per-layer doc_id counts for coverage)
- `_ar/spec-draft/GapClosureSpecWriter-report.md`
- `_ar/spec-draft/MissingCoreEntityWriter-report.md`
- `_ar/spec-draft/UI-gap-open-questions.md`
- `_ar/coverage/ui-gap-analysis.md`
- `_ar/evidence/flow/`

Optional 04 contract-layer inputs if present:

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

Important:
- Absence of API/JOB/ACL/QUERY artifacts is not by itself a failure of this run.
- If these layers are absent, evaluate closure from the core canonical layers only and state explicitly that generation-grade contract coverage was not yet assessed or is only partially available.
- If these layers are present, include them in the closure assessment.

---

## Outputs

Primary output:

- `_ar/spec-draft/SPEC-CLOSURE.md`

Optional:

- `_ar/spec-draft/SPEC-CLOSURE-backlog.md`

---

## Hard rules

1. Do NOT invent closure.
2. Do NOT downgrade known blockers.
3. Distinguish clearly between:
   - sufficient for current-state understanding
   - sufficient for architecture design
   - sufficient for greenfield rewrite
4. If API/JOB/ACL/QUERY are present, distinguish core rewrite readiness from generation-grade contract readiness.
5. Treat blocked EN pages, open questions, rewrite blockers, and missing contract layers separately.
6. Use evidence already present in reports and canonical artifacts.
7. If closure differs by context, state that explicitly.
8. Do NOT hide uncertainty behind optimistic summary language.
9. Do NOT treat absent optional 04 artifacts as “failed” if the run occurred before those layers were expected.
10. Produce a precise verdict, not a motivational one.
11. Evaluate each dimension against the criteria in `tooling/docs/definition-of-done.md` and report a per-criterion checklist (PASS / PARTIAL / BLOCKED with an evidence locator) — not a narrative-only verdict.
12. Assign each dimension an explicit closure state and confidence label from `definition-of-done.md`.
13. Report referential-integrity factors (dangling references, doc_id collisions, orphans from `REFERENCE-INTEGRITY.md`; unresolved restatements from `CROSS-LAYER-audit.md`) prominently and lower the confidence label accordingly. They do NOT automatically force a `blocked` verdict — weigh them in context. Deferred cross-tier references (target layer not synthesized this run) are recorded, not penalized.

---

## Evaluation model

### Phase 1 — Read closure signals

Collect signals from:

- EN coverage
- UC coverage
- kernel and aggregate completeness
- ARCH completeness
- rewrite blockers
- inventory report
- gap-closure reports if available
- API/JOB/ACL/QUERY layers if available
- referential integrity (`REFERENCE-INTEGRITY.md`) and cross-layer de-duplication (`CROSS-LAYER-audit.md`)
- draft registries (`_ar/spec-draft/<LAYER>/_REGISTRY.md`) for per-layer doc_id counts

### Phase 2 — Evaluate each dimension against the Definition of Done

For each closure dimension, walk the criteria in `tooling/docs/definition-of-done.md` and record a
per-criterion status (`PASS` / `PARTIAL` / `BLOCKED`) with an evidence locator. The criteria cover
at least:

- entity coverage
- use case coverage
- bounded context coverage
- architecture coverage
- remaining blocked artifacts
- remaining open questions
- known rewrite blockers
- platform or deferred areas

If API/JOB/ACL/QUERY artifacts are present, also evaluate:

- interface contract coverage
- background / async contract coverage
- access-control coverage
- read / report / query coverage
- consistency between core layers and 04 contract layers

Also assess the cross-cutting factors per `definition-of-done.md`: referential integrity
(`REFERENCE-INTEGRITY.md`), cross-layer de-duplication (`CROSS-LAYER-audit.md`), and registry
currency. These are weighed factors (Phase 3), not separate dimensions.

### Phase 3 — Assign closure state, confidence, and verdict

For each dimension produce, per `definition-of-done.md`:

- a **closure state** (`not-started` / `in-evidence` / `in-reconstruction` / `reconstructed-but-not-closed` / `closed-with-limitations` / `closed` / `blocked`);
- a **confidence label** (`Confirmed` / `Partial` / `Uncertain` / `Blocked`);
- the per-criterion checklist from Phase 2.

The dimensions:

1. current-state understanding
2. architecture and planning
3. greenfield rewrite readiness

If API/JOB/ACL/QUERY artifacts are present, also add:

4. generation-grade contract readiness

If they are absent, explicitly state `not yet assessed` or `not in scope of this run`.

**Weigh the referential factors:** dangling references, doc_id collisions, orphan registry rows,
and unresolved cross-layer restatements lower the confidence label and are listed in the backlog,
but do NOT automatically force `blocked`. A dimension with material dangling references cannot be
`closed` at `Confirmed`; at best `closed-with-limitations`. Deferred cross-tier references are
recorded, not penalized.

### Phase 4 — Backlog if needed

If the specification is not fully closed, write the smallest remaining backlog needed to reach closure.

Backlog should distinguish between:
- core reconstruction blockers
- rewrite decision blockers
- optional / missing 04 contract-layer work

---

## Required structure of SPEC-CLOSURE.md

The document must contain:

1. Purpose
2. Input baseline (including which integrity/audit reports and registries were read)
3. Closure by dimension — for each dimension: a **per-criterion checklist table** (`Criterion | Status (PASS/PARTIAL/BLOCKED) | Evidence`), the **closure state**, and the **confidence label** (per `definition-of-done.md`)
4. Referential-integrity & cross-layer factors — summary of dangling references / collisions / orphans (`REFERENCE-INTEGRITY.md`) and unresolved restatements (`CROSS-LAYER-audit.md`), and how they lowered confidence
5. Open blockers
6. Verdict — the closure state + confidence per dimension
7. Minimum remaining work — backlog split into core reconstruction / rewrite-decision / optional 04 contract / referential-integrity factors
8. Recommended next step

If API/JOB/ACL/QUERY were evaluated, also include within the existing structure:
- contract-layer closure status
- whether the specification is only rewrite-ready or also generation-grade ready

---

## Quality bar

The result must make it possible to answer clearly:

- Can the current system be described as-is with confidence
- What is still missing
- Is the remaining gap small, medium, or foundational
- What is the next smallest useful action
- If 04 artifacts are present: whether the system is only core-spec complete or also contract-spec complete

---

## Idempotency

This agent should be safely re-runnable.

When outputs already exist:

- refresh them in place
- do not create duplicate variants
- do not create renamed copies

When additional 04 artifacts appear in later runs:

- re-evaluate closure using the newly available layers
- update verdicts and remaining backlog in place
- do not preserve stale “not assessed” wording if the layers now exist

---

## Completion criteria

The run is successful when:

- a clear closure verdict is produced
- the verdict is supported by existing artifacts
- remaining blockers are explicit
- the next step is unambiguous

If 04 artifacts are absent:
- the output must explicitly say closure was evaluated on the currently available canonical layers

If 04 artifacts are present:
- the output must explicitly reflect their effect on closure

---

## Invocation

Typical invocation:

Run AR:SpecClosureEvaluator

A task file may specify whether the run focuses on current-state closure, rewrite readiness, generation-grade readiness, or all of them, but the role of the agent remains closure evaluation from existing artifacts.