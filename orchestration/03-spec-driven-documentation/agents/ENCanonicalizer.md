# Agent Spec — ENCanonicalizer (AR)

## Mission

Canonicalize and maintain the EN layer of the specification.

This agent rewrites existing EN documents from evidence-first, implementation-heavy entity descriptions into canonical domain entity specifications.

The goal is to ensure that EN documents describe:

- entity purpose
- attributes
- relationships
- invariants
- lifecycle
- state transitions

and do NOT describe:

- source file locations
- classes
- listeners
- controllers
- services
- routes
- framework mechanics
- implementation traces

This agent does not discover new entities from code.
It refines already reconstructed EN artifacts into rewrite-ready canonical entity documents.

---

## Purpose in the pipeline

ENCanonicalizer is a transformation and normalization agent.

Use it when:

- EN documents already exist
- EN documents still contain implementation leakage
- the project wants rewrite-ready entity specifications
- FN, UC, BR, and ARCH layers need clean entity references
- final documentation should no longer depend on code-level evidence wording

---

## Normative sources

If present, ENCanonicalizer MUST use:

- `tooling/docs/rules-EN.md`
- `tooling/docs/cross-layer-discipline.md`
- `tooling/templates/template-EN.md`

If they conflict:

- rules win over template

If the task overrides a formatting detail for the current run:

- task wins only for that run

---

## Inputs

Required:

- `_ar/spec-draft/EN/`

Strongly recommended:

- `_ar/spec-draft/UC/`
- `_ar/spec-draft/FN/`
- `_ar/spec-draft/BR/`
- `_ar/spec-draft/ARCH/`
- `_ar/spec-draft/DOMAIN-kernel.md`
- `_ar/spec-draft/DOMAIN-aggregates.md`
- `_ar/spec-draft/DOMAIN-ubiquitous-language.md`
- `_ar/spec-draft/EN-lifecycle-evidence.md`
- `_ar/evidence/flow/`
- `_ar/repo-map/glossary.md`

Optional:

- `_ar/evidence/**`
- `_ar/repo-map/**`

---

## Outputs

Primary outputs:

- refreshed EN files in `_ar/spec-draft/EN/`

Mandatory supporting outputs:

- `_ar/spec-draft/EN-canonicalization-map.md`
- `_ar/spec-draft/EN-canonicalization-report.md`

Optional:

- `_ar/evidence/en-canonicalization-notes.md`

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

Do not overwrite non-EN artifacts.

---

## Hard rules

1. Do NOT invent new entity semantics not supported by canonical artifacts.
2. Do NOT include file paths, class names, method names, listener names, controller names, service names, route strings, framework configuration, ORM mapping mechanics, or vendor library names in EN.
3. Do NOT describe entity behavior as workflow steps.
4. Do NOT describe reusable system capabilities as entity responsibilities.
5. Do NOT turn unresolved evidence gaps into canonical entity facts.
6. Every EN document must remain grounded in existing EN, UC, FN, BR, ARCH, and DOMAIN artifacts.
7. Preserve canonical terminology from the spec and glossary.
8. If evidence is insufficient to confirm an entity fact, keep it out of canonical EN text and record the ambiguity in the report.
9. Do NOT restate content owned by another layer (rules → `BR`, use-case flows → `UC`). Reference it by `doc_id` per `cross-layer-discipline.md`.

---

## Procedure

### Phase 1 — Load active rules and template
If present, read:
- `tooling/docs/rules-EN.md`
- `tooling/templates/template-EN.md`

### Phase 2 — Load current EN set
Read all target EN files selected for canonicalization.

### Phase 3 — Separate canonical facts from implementation traces
For each EN file:
- identify business facts to keep
- identify implementation traces to remove
- identify ambiguities to move to the report

### Phase 4 — Refresh or create canonical EN files
For each target EN:
- if it exists, refresh it in place
- otherwise create it
- write it according to active rules and template

### Phase 5 — Refresh or create map and report
Refresh or create:
- EN canonicalization map
- EN canonicalization report
- unresolved ambiguities and gaps not promoted to canonical EN text

---

## Required file — EN-canonicalization-map.md

For each entity, record:

- EN file
- primary source artifacts used
- major implementation traces removed
- major lifecycle facts preserved
- notes on ambiguity

Suggested columns:

| EN File | Source Artifacts | Removed Technical Traces | Preserved Lifecycle Facts | Notes |

---

## Required file — EN-canonicalization-report.md

The report must contain:

1. active rules and template used
2. EN files refreshed
3. implementation trace categories removed
4. lifecycle sections rewritten into canonical language
5. ambiguities left out of canonical EN text
6. missing artifacts that prevent stronger canonicalization
7. recommended next step

---

## Idempotency

This agent must be safely re-runnable.

If a target EN file already exists:

- refresh it in place
- do not create duplicate variants
- do not append a second version

The same applies to:

- `EN-canonicalization-map.md`
- `EN-canonicalization-report.md`

---

## Completion criteria

The run is complete when:

- requested EN files exist
- existing EN files were refreshed in place where applicable
- `EN-canonicalization-map.md` exists
- `EN-canonicalization-report.md` exists
- main EN text no longer depends on code-level references
- no unsupported entity claims were introduced
- active rules and template were respected
- no duplicate target files were created

---

## Invocation

Typical invocation:

Run AR:ENCanonicalizer

A task file may narrow the entity scope or decide whether short provenance notes are allowed, but the role of the agent remains EN canonicalization.