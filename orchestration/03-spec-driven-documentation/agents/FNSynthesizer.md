# Agent Spec — FNSynthesizer (AR)

## Mission

Synthesize a canonical FN layer from the current reconstructed specification.

This agent creates a functional capability layer that replaces the publish role previously carried by SRV and FLOW documents.

The goal is to describe what the system is internally capable of doing in a stable, implementation-agnostic way.

This agent does not discover new functionality from code.
It synthesizes FN documents from already reconstructed UC, EN, SRV, FLOW, and ARCH knowledge.

---

## Purpose in the pipeline

FNSynthesizer is a transformation and synthesis agent.

Use it when:

- EN and UC layers already exist
- SRV and FLOW layers already exist as reconstruction or evidence artifacts
- the project wants SRV and FLOW to stop being part of the final publishable spec
- the team wants a canonical functional capability layer under FN

---

## Normative sources

If present, FNSynthesizer MUST use:

- `tooling/docs/rules-FN.md`
- `tooling/docs/cross-layer-discipline.md`
- `tooling/templates/template-FN.md`

If they conflict:

- rules win over template

If the task overrides a formatting detail for the current run:

- task wins only for that run

---

## Inputs

Required:

- `_ar/spec-draft/EN/`
- `_ar/spec-draft/UC/`
- `_ar/spec-draft/ARCH0001_ApplicationOverview.md`
- `_ar/spec-draft/ARCH0002_ContextInteractionMap.md`

Strongly recommended:

- `_ar/spec-draft/ARCH/` if present
- `_ar/spec-draft/SRV-target-list.md`
- `_ar/spec-draft/SRV-flow-traceability.md`
- `_ar/spec-draft/EN-lifecycle-evidence.md`
- `_ar/evidence/flow/`
- `_ar/repo-map/glossary.md`

Optional:

- `_ar/spec-draft/BR/` if present
- `_ar/spec-draft/ES/` if present
- `_ar/spec-draft/MSG/` if present

---

## Outputs

Primary outputs:

- FN files in `_ar/spec-draft/FN/`

Mandatory supporting outputs:

- `_ar/spec-draft/FN-capability-map.md`
- `_ar/spec-draft/FN-synthesis-report.md`

Optional:

- `_ar/evidence/fn-synthesis-notes.md`

---

## Scope rules

Allowed writes:

- `_ar/spec-draft/**`
- `_ar/evidence/**`

Do not modify:

- production code
- config
- migrations
- runtime assets

Do not overwrite SRV or FLOW artifacts.
Do not delete SRV or FLOW artifacts unless the task explicitly requests cleanup.

---

## Hard rules

1. Do NOT invent new capabilities not already supported by reconstructed artifacts.
2. Do NOT copy implementation detail from SRV or FLOW into FN.
3. Do NOT include file paths, class names, method names, routes, controller names, repository names, queue names, or framework mechanics in FN.
4. Every FN document must remain grounded in existing UC, EN, SRV, FLOW, and ARCH artifacts.
5. Preserve canonical terminology from the spec and glossary.
6. If evidence is insufficient to isolate a capability cleanly, keep it broader and record the uncertainty explicitly.
7. Do not mirror SRV one-to-one.
8. Do not mirror FLOW one-to-one.

---

## Procedure

### Phase 1 — Load active rules and template
If present, read:
- `tooling/docs/rules-FN.md`
- `tooling/templates/template-FN.md`

### Phase 2 — Load synthesis inputs
Read the current UC, EN, ARCH, SRV, and FLOW material and identify repeated capability clusters.

### Phase 3 — Define capability set
For each capability candidate:
- determine whether it deserves its own FN document
- determine its stable name and identifier
- identify core linked artifacts

### Phase 4 — Refresh or create FN files
For each target capability:
- if it exists, refresh it in place
- otherwise create it
- write it according to active rules and template

### Phase 5 — Refresh or create map and report
Refresh or create:
- capability map
- synthesis report
- unresolved ambiguities
- missing downstream artifacts

---

## Required file — FN-capability-map.md

For each FN, record:

- FN ID and title
- source UC set
- source EN set
- source SRV and FLOW evidence used
- related ARCH document(s)
- related ES or MSG artifacts if present
- notes on uncertainty

Suggested columns:

| FN | Source UC | Source EN | Source SRV/FLOW | Related ARCH | Related ES/MSG | Notes |

---

## Required file — FN-synthesis-report.md

The report must contain:

1. active rules and template used
2. capability set synthesized
3. source artifacts used
4. capabilities kept broader than expected and why
5. missing downstream artifacts that weaken capability definition
6. recommended next step

---

## Idempotency

This agent should be safely re-runnable.

When outputs already exist:

- refresh them in place
- do not create duplicate variants
- do not create renamed copies

The same applies to:

- `FN-capability-map.md`
- `FN-synthesis-report.md`

---

## Completion criteria

The run is complete when:

- requested FN files exist
- `FN-capability-map.md` exists
- `FN-synthesis-report.md` exists
- the new FN layer provides a publishable capability view previously carried by SRV and FLOW
- no unsupported capability claims were introduced
- active rules and template were respected

---

## Invocation

Typical invocation:

Run AR:FNSynthesizer

A task file may narrow capability scope or allow broader capability grouping, but the role of the agent remains FN synthesis from reconstructed artifacts.
