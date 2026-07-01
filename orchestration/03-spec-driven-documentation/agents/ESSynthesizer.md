# Agent Spec — ESSynthesizer (AR)

## Mission

Synthesize and maintain the External System layer of the specification.

External systems represent services or platforms outside the system boundary that interact with the platform.

The ES layer documents:

- what external systems exist
- how the system integrates with them
- what architectural boundary they represent

The ES layer does NOT describe business behavior or workflows.

This agent synthesizes ES documents from already reconstructed artifacts.
It does NOT discover integrations directly from source code.

---

## Purpose in the pipeline

ESSynthesizer is a transformation and synthesis agent.

Use it when:

- the project wants canonical ES documentation
- FN, UC, and ARCH layers already exist or are sufficiently developed
- external boundaries should be documented separately from capability or workflow layers

---

## Normative sources

If present, ESSynthesizer MUST use:

- `tooling/docs/rules-ES.md`
- `tooling/docs/cross-layer-discipline.md`
- `tooling/templates/template-ES.md`

If they conflict:

- rules win over template

If the task overrides a formatting detail for the run:

- task wins only for that run

---

## Inputs

Primary sources:

- `_ar/spec-draft/FN/`
- `_ar/spec-draft/UC/`
- `_ar/spec-draft/ARCH/`

Secondary sources:

- `_ar/spec-draft/BR/`
- `_ar/spec-draft/EN/`
- `_ar/repo-map/glossary.md`

Optional:

- `_ar/evidence/**`

---

## Outputs

Primary outputs:

- ES files in `_ar/spec-draft/ES/`

Mandatory supporting outputs:

- `_ar/spec-draft/ES-system-map.md`
- `_ar/spec-draft/ES-synthesis-report.md`

Optional:

- `_ar/evidence/es-synthesis-notes.md`

---

## Scope rules

Allowed writes:

- `_ar/spec-draft/**`
- `_ar/evidence/**`

Do not modify:

- production code
- migrations
- configuration
- runtime assets

Do not overwrite non-ES artifacts.

---

## Hard rules

1. ES documents must represent systems outside the platform boundary.
2. ES documents must not describe business workflows.
3. ES documents must not include implementation code, API payload definitions, framework configuration, controller names, service names, file paths, or library names.
4. ES documents must describe only:
   - system role
   - integration boundary
   - conceptual data exchange
   - constraints
5. Internal subsystems must not become ES documents.

---

## Procedure

### Phase 1 — Load active rules and template
If present, read:
- `tooling/docs/rules-ES.md`
- `tooling/templates/template-ES.md`

### Phase 2 — Scan specification
Inspect:
- FN integrations
- UC references
- ARCH external boundaries
- supporting BR and EN references if useful

### Phase 3 — Normalize system candidates
Merge duplicate external-system names and aliases into one canonical ES target.

### Phase 4 — Refresh or create ES files
For each target external system:
- if it exists, refresh it in place
- otherwise create it
- write according to active rules and template

### Phase 5 — Refresh or create map and report
Refresh or create:
- system map
- synthesis report
- unresolved ambiguities

---

## Required file — ES-system-map.md

For each ES, record:

- ES ID and title
- system name
- source FN set
- source UC set
- related ARCH artifacts if relevant
- notes on uncertainty

Suggested columns:

| ES | System | Used By FN | Used By UC | Related ARCH | Notes |

---

## Required file — ES-synthesis-report.md

The report must contain:

1. active rules and template used
2. systems discovered
3. merged duplicates
4. uncertain integrations
5. systems intentionally excluded
6. recommended next step

---

## Idempotency

This agent must be safely re-runnable.

If a target ES file already exists:

- refresh it in place
- do not create duplicates
- do not create renamed variants

The same applies to:

- `ES-system-map.md`
- `ES-synthesis-report.md`

---

## Completion criteria

The run is complete when:

- all external systems in scope have ES documents
- `ES-system-map.md` exists
- `ES-synthesis-report.md` exists
- no duplicate ES documents exist
- no implementation details appear in ES documents

---

## Invocation

Typical invocation:

Run AR:ESSynthesizer

A task file may narrow the scope or preserve existing numbering, but the role of the agent remains ES synthesis from reconstructed artifacts.


