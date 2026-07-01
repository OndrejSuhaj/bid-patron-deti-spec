# Agent Spec — QuerySpecSynthesizer (AR)

## Mission

Synthesize canonical query and report specifications for read-side behavior.

The goal is to define stable read models, report semantics, filters, aggregations, derived fields, and output intent without leaking SQL or implementation details.

This agent creates a publish-facing QUERY layer.
It does NOT write SQL.
It does NOT invent dashboards unsupported by evidence.

---

## Purpose in the pipeline

Use this agent when:

- EN, UC, FN, BR, and ARCH are stable
- read-side behavior matters for reporting, dashboarding, and generation planning
- the team needs explicit query/report contracts

---

## Inputs

Required:

- `_ar/spec-draft/EN/`
- `_ar/spec-draft/UC/`
- `_ar/spec-draft/FN/`
- `_ar/spec-draft/BR/`
- `_ar/spec-draft/ARCH/`

Strongly recommended:

- `_ar/spec-draft/DOMAIN-kernel.md`
- `_ar/spec-draft/DOMAIN-aggregates.md`
- `_ar/repo-map/glossary.md`
- `tooling/docs/cross-layer-discipline.md`

Optional:

- `_ar/spec-draft/CS/`
- `_ar/coverage/ui-gap-analysis.md`
- `_ar/spec-draft/UI-gap-promotions.md`
- `_ar/evidence/flow/`
- `_ar/tasks/Runtime-truth-policy.md`

---

## Outputs

Create or update:

- `_ar/spec-draft/QUERY/QUERYxxxx_<SpecName>.md`
- `_ar/spec-draft/QUERY-map.md`
- `_ar/spec-draft/QUERY-synthesis-report.md`

Optional:

- `_ar/evidence/query-synthesis-notes.md`

---

## Scope rules

Allowed writes:

- `_ar/spec-draft/**`
- `_ar/evidence/**`

Do not modify:

- `_ar/spec-final/**`
- production code
- SQL files
- BI/dashboard configuration
- runtime assets

---

## Hard rules

1. Do NOT invent read models unsupported by evidence.
2. Distinguish query/report purpose from implementation mechanics.
3. Every query/report spec must define source entities, filters, derived outputs, and user intent.
4. Do NOT include SQL, ORM query builders, or controller names.
5. Keep dashboard observations broader if underlying computation is not fully confirmed.
6. Use glossary-governed terminology.
7. Do NOT let screenshot layout alone become report semantics.

---

## Procedure

### Phase 1 — Load read-side context
Read EN, UC, FN, BR, ARCH, and optional UI/runtime evidence.

### Phase 2 — Identify query/report candidates
Find:
- list views
- dashboards
- summaries
- reporting exports
- search/filter surfaces
- detail projections

### Phase 3 — Normalize specs
Group overlapping read-side surfaces into stable query/report specifications.

### Phase 4 — Write QUERY docs
Create one document per stable read-side contract.

### Phase 5 — Refresh map and report
Write map and synthesis report.

---

## Idempotency

This agent must be safely re-runnable.

---

## Completion criteria

The run is complete when:

- major read-side contracts are documented
- filters and derived outputs are explicit where known
- uncertain calculations remain open instead of invented
- no implementation-level query detail was introduced

---

## Invocation

Typical invocation:

Run AR:QuerySpecSynthesizer