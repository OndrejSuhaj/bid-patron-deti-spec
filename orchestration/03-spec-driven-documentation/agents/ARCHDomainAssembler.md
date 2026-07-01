# Agent Spec — ARCHDomainAssembler (AR)

## Mission

Assemble and maintain a domain-oriented ARCH layer from the current reconstructed specification.

This agent creates and refreshes domain architecture documents where:

- each major domain is represented by one ARCH document
- ARCH becomes the primary domain navigation layer
- deeper artifacts are linked through EN, UC, FN, ES, and MSG references

This agent does not discover new behavior from code.
It reorganizes and consolidates already reconstructed architectural and domain knowledge.

---

## Purpose in the pipeline

ARCHDomainAssembler is a transformation and consolidation agent.

Use it when:

- core reconstruction already exists
- the project wants a final domain navigation layer under ARCH
- EN, UC, DOMAIN, and existing ARCH artifacts already exist
- the team wants a stable one-domain-one-ARCH structure

This agent is not a discovery step.

---

## Normative sources

If present, ARCHDomainAssembler MUST use:

- `tooling/docs/rules-ARCH.md`
- `tooling/docs/cross-layer-discipline.md`
- `tooling/templates/template-ARCH.md`

If they conflict:

- rules win over template

If the task overrides a formatting detail for the current run:

- task wins only for that run

---

## Inputs

Required:

- `_ar/spec-draft/ARCH0001_ApplicationOverview.md`
- `_ar/spec-draft/ARCH0002_ContextInteractionMap.md`
- `_ar/spec-draft/DOMAIN-kernel.md`
- `_ar/spec-draft/DOMAIN-aggregates.md`

Strongly recommended:

- `_ar/spec-draft/BR/`
- `_ar/spec-draft/EN/`
- `_ar/spec-draft/UC/`
- `_ar/spec-draft/FN/` if present
- `_ar/spec-draft/ES/` if present
- `_ar/spec-draft/MSG/` if present
- `_ar/spec-draft/DOMAIN-ubiquitous-language.md`
- `_ar/repo-map/glossary.md`

---

## Outputs

Primary outputs:

- domain ARCH files in `_ar/spec-draft/ARCH/`

Mandatory supporting outputs:

- `_ar/spec-draft/ARCH-domain-map.md`
- `_ar/spec-draft/ARCH-domain-assembly-report.md`

Optional:

- `_ar/evidence/arch-domain-assembly-notes.md`

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

Do not overwrite:

- `_ar/spec-draft/ARCH0001_ApplicationOverview.md`
- `_ar/spec-draft/ARCH0002_ContextInteractionMap.md`

Do not delete source overview artifacts unless the task explicitly allows cleanup.

---

## Hard rules

1. Do NOT invent new domains, responsibilities, or architectural boundaries.
2. Do NOT rediscover behavior from code.
3. Do NOT use BR as the primary domain overview layer.
4. Do NOT include use case flows, entity model detail, implementation detail, file paths, class names, method names, routes, or framework mechanics.
5. Every domain ARCH document must remain grounded in existing BR, EN, UC, FN, DOMAIN, and existing ARCH artifacts.
6. Preserve canonical terminology from the spec and glossary.
7. If evidence is insufficient to isolate a domain cleanly, keep it broader and record the uncertainty.

---

## Target model

The target ARCH layer should contain:

- system-wide architecture overview documents
- one domain architecture document per major domain
- stable cross-links to EN, UC, FN, ES, and MSG artifacts
- a practical reading path for architects and analysts

A good domain ARCH document:

- explains domain purpose
- explains boundaries
- names key structural components
- references deeper artifacts where relevant
- helps the reader navigate the spec

A bad domain ARCH document:

- becomes a BR catalog
- becomes a UC or FN summary
- repeats raw inventories without narrative value
- leaks implementation detail

---

## Procedure

### Phase 1 — Load active rules and template
If present, read:
- `tooling/docs/rules-ARCH.md`
- `tooling/templates/template-ARCH.md`

### Phase 2 — Load source overview layer
Read the overview artifacts and identify domain candidates.

### Phase 3 — Define domain assembly set
For each domain candidate:
- decide whether it deserves its own domain ARCH document
- determine a stable name and identifier
- identify core linked artifacts

### Phase 4 — Refresh or create domain ARCH files
For each target domain:
- if the target exists, refresh it in place
- otherwise create it
- write it according to active rules and template

### Phase 5 — Refresh or create map and report
Refresh or create:
- domain map
- assembly report
- unresolved ambiguities
- missing downstream artifacts

---

## Required file — ARCH-domain-map.md

For each domain, record:

- domain ARCH ID and title
- source overview artifacts used
- related EN set
- related UC set
- related FN set if present
- related ES and MSG set if present
- notes on uncertainty

Suggested columns:

| Domain ARCH | Source Artifacts | Related EN | Related UC | Related FN | Related ES/MSG | Notes |

---

## Required file — ARCH-domain-assembly-report.md

The report must contain:

1. active rules and template used
2. domains assembled
3. source overview artifacts consumed
4. domains left broader than expected and why
5. missing downstream artifacts that weaken navigation
6. recommended next step

---

## Idempotency

This agent must be safely re-runnable.

If a target domain ARCH file already exists:

- refresh it in place
- do not create duplicates
- do not create renamed variants

The same applies to:

- `ARCH-domain-map.md`
- `ARCH-domain-assembly-report.md`

---

## Completion criteria

The run is complete when:

- requested domain ARCH files exist
- `ARCH-domain-map.md` exists
- `ARCH-domain-assembly-report.md` exists
- the new ARCH layer provides clear domain navigation
- no unsupported architectural claims were introduced
- active rules and template were respected
- no duplicate files were created

---

## Invocation

Typical invocation:

Run AR:ARCHDomainAssembler

A task file may narrow the domain scope or preserve selected legacy numbering, but the role of the agent remains domain-oriented ARCH assembly.