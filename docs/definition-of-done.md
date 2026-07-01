# Reconstruction Closure — Definition of Done (AR)

## Purpose

The measurable criteria for declaring an AR reconstruction **closed** along each dimension. This
is the authoritative closure contract consumed by
[SpecClosureEvaluator](../orchestration/03-spec-driven-documentation/agents/SpecClosureEvaluator.md),
which evaluates the draft against it and produces a per-criterion checklist rather than a narrative
verdict.

It adapts the sister `arg-emitee` project's Definition-of-Done **philosophy** — measurable criteria,
explicit closure states, "what does not count as done", and referential integrity as a closure
factor — to AR. AR is a reconstruction pipeline with **no delivery slices/modules**, so
arg-emitee's delivery tiers (slice / module / program) do not apply; AR closure is reconstruction
closure across the dimensions below.

---

## Closure dimensions

1. **Current-state understanding** — can the system be described as-is, with confidence?
2. **Architecture & planning** — is the structure, domain model, and interaction model explicit?
3. **Greenfield rewrite readiness** — is the spec sufficient to plan a rewrite?
4. **Generation-grade contract readiness** — only assessed when the 04 layers (API/JOB/ACL/QUERY) exist.

Each dimension is evaluated independently and may close at a different state.

---

## Closure states (per dimension)

```
not-started → in-evidence → in-reconstruction → reconstructed-but-not-closed →
              closed-with-limitations → closed        (or → blocked at any point)
```

- **not-started** — no relevant artifacts yet
- **in-evidence** — evidence collected, not yet reconstructed
- **in-reconstruction** — canonical layers being authored
- **reconstructed-but-not-closed** — layers exist but criteria not all met (valid intermediate state; must not be reported as closed)
- **closed-with-limitations** — criteria met, with visible/accepted limitations recorded
- **closed** — all required criteria for the dimension met
- **blocked** — cannot proceed without an external decision

Each dimension also carries a **confidence label**: `Confirmed` / `Partial` / `Uncertain` /
`Blocked` (AR's existing evidence vocabulary, per `rules-UC.md` / `rules-CS.md`).

---

## Per-dimension criteria (checklist)

Each criterion is evaluated `PASS` / `PARTIAL` / `BLOCKED`, with an evidence locator. No scoring or
grading — explicit per-criterion status.

### 1. Current-state understanding
- EN layer covers the observed entities (cross-check `ENTITY-coverage-matrix.md` / `EntityInventoryCloser-report.md`); core EN docs are canonical.
- UC layer covers the observed behavior; CS scenarios (if collected) are reconciled.
- ARCH application-overview + context-interaction map exist.
- Open questions are resolved or explicitly recorded (not silently assumed).

### 2. Architecture & planning
- Domain kernel + aggregate boundaries exist; ARCH domain pages assembled.
- ES (external systems) and MSG (messages) synthesized where evidenced.
- FN capability layer present.
- Bounded-context coverage explicit.

### 3. Greenfield rewrite readiness
- BR canonical rules extracted.
- `REWRITE-decision-pack.md` makes rewrite blockers and architectural risks visible.
- The core layers are implementation-agnostic and self-consistent.

### 4. Generation-grade contract readiness (only when 04 layers present)
- API / JOB / ACL / QUERY layers exist and are canonical.
- They are consistent with the core layers (no contract contradicts EN/UC/BR).
- If absent: state explicitly "not yet assessed" or "not in scope of this run" — not "failed".

### Cross-cutting (apply to every dimension)
- **Referential integrity** (`REFERENCE-INTEGRITY.md`): see weighed factors below.
- **Cross-layer de-duplication** (`CROSS-LAYER-audit.md`): unresolved restatements weigh on closure.
- **Registries current** (`_ar/spec-draft/<LAYER>/_REGISTRY.md`): one row per doc, no orphans.

---

## Weighed closure factors (not hard blockers)

The following are **significant negative factors** that the evaluator MUST report prominently, that
**lower the confidence label**, and that belong in the closure backlog — but they do **not**
automatically force a `blocked` verdict. The verdict remains the evaluator's reasoned judgment.

- **Dangling references** within the published set (`REFERENCE-INTEGRITY.md` status `dangling`) — a referenced `doc_id` that should exist but has no registry row.
- **doc_id collisions** — two docs claiming the same id.
- **Orphan registry rows** — a row with no doc, or a doc with no row.
- **Unresolved cross-layer restatements** (`CROSS-LAYER-audit.md` status pending / open-question).

**Deferred** cross-tier references (the target layer was not synthesized this run, e.g. API absent)
are **not** a factor — they are recorded as deferred links, not penalized.

A dimension with material dangling references / collisions cannot be `closed` at `Confirmed`
confidence; at best `closed-with-limitations` or `reconstructed-but-not-closed`, with the factors
listed in the backlog.

---

## What does NOT count as closed

- a layer folder *containing documents* — that is not the same as the layer being canonical;
- files existing, an agent having run, or a report being produced;
- a verdict asserted without the per-criterion checklist;
- narrative optimism ("largely complete", "should be fine");
- "probably" works / "mostly" covered.

A dimension is `closed` only when its required criteria are `PASS` and the result is stated as a
checklist, not a sentence.

---

## Verdict model

For each dimension, the evaluator records: the **per-criterion checklist** (PASS/PARTIAL/BLOCKED +
evidence), the **closure state**, the **confidence label**, and the **weighed factors** that
applied. There is no aggregate score; closure is the conjunction of the dimension's required
criteria. Remaining gaps go to the closure backlog, distinguished into: core reconstruction
blockers, rewrite-decision blockers, optional 04 contract-layer work, and referential-integrity
factors.
