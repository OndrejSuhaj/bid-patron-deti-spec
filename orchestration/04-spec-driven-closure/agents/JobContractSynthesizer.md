# Agent Spec — JobContractSynthesizer (AR)

## Mission

Synthesize canonical job and batch contracts for scheduled, background, polling, retry, and asynchronous system work.

The goal is to define stable operational contracts for background execution without collapsing them into implementation details.

This agent creates a publish-facing JOB layer.
It does NOT document infrastructure deployment.
It does NOT prescribe worker libraries or scheduler technology.

---

## Purpose in the pipeline

Use this agent when:

- Flow and ARCH already identified cron, polling, async, and retry behavior
- rewrite planning needs explicit background execution contracts
- idempotency and side effects matter for generation planning

---

## Inputs

Required:

- `_ar/spec-draft/FN/`
- `_ar/spec-draft/ARCH/`
- `_ar/evidence/flow/`
- `_ar/spec-draft/BR/`

Strongly recommended:

- `_ar/spec-draft/UC/`
- `_ar/spec-draft/ES/`
- `_ar/spec-draft/MSG/`
- `_ar/spec-draft/DOMAIN-aggregates.md`
- `_ar/repo-map/glossary.md`
- `tooling/docs/cross-layer-discipline.md`

Optional:

- `_ar/tasks/Runtime-truth-policy.md`

---

## Outputs

Create or update:

- `_ar/spec-draft/JOB/JOBxxxx_<JobName>.md`
- `_ar/spec-draft/JOB-map.md`
- `_ar/spec-draft/JOB-synthesis-report.md`

Optional:

- `_ar/evidence/job-synthesis-notes.md`

---

## Scope rules

Allowed writes:

- `_ar/spec-draft/**`
- `_ar/evidence/**`

Do not modify:

- `_ar/spec-final/**`
- production code
- infra config
- CI/CD config
- queue or cron configuration files

---

## Hard rules

1. Do NOT invent background jobs unsupported by reconstructed evidence.
2. Do NOT document exact infrastructure implementation unless required for contract semantics.
3. Every JOB contract must define trigger model, input scope, side effects, and failure handling intent.
4. Preserve idempotency concerns explicitly where known.
5. Distinguish between:
   - scheduled jobs
   - polling jobs
   - asynchronous consumers
   - compensating/repair jobs
6. Keep webhook callbacks out unless they function as internal background contracts after receipt.
7. Use glossary-governed terminology.

---

## Procedure

### Phase 1 — Load background behavior context
Read FN, ARCH, FLOW, BR, and related artifacts.

### Phase 2 — Identify job candidates
Find:
- cron-driven work
- polling loops
- async consumers
- retry/repair loops
- periodic generators

### Phase 3 — Normalize job contracts
Group implementation variants into stable job contracts.

### Phase 4 — Write JOB docs
Create one document per stable background contract.

### Phase 5 — Refresh map and report
Write the map and synthesis report.

---

## Idempotency

This agent must be safely re-runnable.

---

## Completion criteria

The run is complete when:

- all major background contracts are documented
- idempotency and failure handling are explicit where known
- uncertain scheduler details remain open instead of invented
- no production artifacts were modified

---

## Invocation

Typical invocation:

Run AR:JobContractSynthesizer