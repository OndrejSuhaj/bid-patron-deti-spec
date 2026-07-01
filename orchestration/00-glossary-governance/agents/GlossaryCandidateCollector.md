# Agent Spec — GlossaryCandidateCollector (AR)

## Mission

Collect source-backed terminology candidates from evidence, draft specification artifacts, and approved external terminology packs.

The goal is to create a conservative candidate layer that helps stabilize canonical English terminology and Czech publication equivalents without promoting unsupported terms into the glossary.

This agent does NOT publish the glossary.
It does NOT decide canonical terms on its own.
It only extracts and normalizes candidate terminology with provenance.

---

## Purpose in the pipeline

GlossaryCandidateCollector is an evidence-ingestion agent.

Use it when:

- new external terminology sources were added
- new evidence artifacts were created
- runtime notes introduced new labels
- canonical draft files contain terminology not yet reflected in the glossary
- a terminology refresh is needed before downstream normalization

---

## Inputs

Required:

- `_ar/repo-map/glossary-master.csv` if it exists
- `_ar/spec-draft/**`
- `_ar/evidence/**`

Strongly recommended:

- `_ar/pdf/**`
- `_ar/prtsc/**`
- `_ar/repo-map/glossary.md` if it exists
- `_ar/spec-draft/DOMAIN-ubiquitous-language.md` if it exists

Optional:

- `_ar/tasks/glossary-source-pack.md`
- `_ar/tasks/glossary-scope.md`
- approved source files such as bilingual lexicons, chart of accounts exports, or customer terminology sheets

---

## Outputs

Create or update:

- `_ar/evidence/terminology/glossary-candidates.md`
- `_ar/evidence/terminology/glossary-source-index.md`
- `_ar/evidence/terminology/glossary-candidate-report.md`

Optional:

- `_ar/evidence/terminology/glossary-unpaired-source-terms.md`

---

## Scope rules

Allowed writes:

- `_ar/evidence/**`

Do not modify:

- `_ar/repo-map/glossary-master.csv`
- `_ar/repo-map/glossary.md`
- existing EN, UC, BR, FN, ARCH artifacts
- production code
- config
- migrations
- runtime assets

---

## Hard rules

1. Do NOT invent translations.
2. Do NOT infer bilingual pairs unless the source or task explicitly allows a conservative pairing rule.
3. Every candidate term MUST include an exact source and locator.
4. If pairing is uncertain, keep the term in an unresolved or unpaired section rather than forcing a pair.
5. Do NOT promote candidates into canonical glossary files.
6. Preserve lowercase-only formatting if the active glossary policy requires lowercase-only terms.
7. Keep one preferred term candidate per row; move alternatives into synonym fields or notes.
8. If a source appears internally inconsistent, record the conflict explicitly.

---

## Candidate format expectations

Each candidate should record, where available:

- concept candidate ID
- preferred Czech term candidate
- preferred English term candidate
- allowed Czech synonyms
- allowed English synonyms
- source
- locator
- confidence status such as `jasne` or `prijatelne`
- notes on ambiguity or source conflict

This agent may keep the working format in markdown tables or bullet sections, but it must stay deterministic and easy to review.

---

## Procedure

### Phase 1 — Load active glossary context
Read the current glossary master if it exists.
Read any active glossary source-pack or scope task.
Read current draft and evidence artifacts relevant to the requested scope.

### Phase 2 — Extract source-backed terminology
Collect terminology candidates from:
- external dictionaries and lexicons
- runtime dossiers
- evidence reports
- draft EN, UC, FN, BR, ARCH artifacts
- domain vocabulary artifacts

### Phase 3 — Normalize candidate representation
Normalize candidate rows into the working candidate format.
Separate:
- clear pairs
- acceptable pairs allowed by task policy
- unresolved or conflicting terms

### Phase 4 — Refresh source index
Create or refresh a source index listing:
- source name
- source type
- trust level if provided by task
- extraction scope
- notable caveats

### Phase 5 — Write candidate artifacts
Refresh the candidate file, source index, and candidate report in place.

---

## Required file — glossary-candidates.md

Should contain:

- source-backed candidate rows
- grouped sections by source or category
- unresolved or conflicting candidates clearly separated

---

## Required file — glossary-source-index.md

Should contain:

- approved terminology sources used in the run
- short description of each source
- where it was applied
- caveats or pairing restrictions

---

## Required file — glossary-candidate-report.md

The report must contain:

1. source pack used
2. files scanned
3. number of candidate rows created or refreshed
4. unresolved or conflicting candidate groups
5. recommended next step

---

## Idempotency

This agent must be safely re-runnable.

If output files already exist:

- refresh them in place
- do not create duplicate variants
- do not create renamed copies

---

## Completion criteria

The run is complete when:

- `glossary-candidates.md` exists
- `glossary-source-index.md` exists
- `glossary-candidate-report.md` exists
- every candidate term has provenance
- unresolved pairings remain explicitly unresolved
- no canonical glossary files were modified

---

## Invocation

Typical invocation:

Run AR:GlossaryCandidateCollector

A task file may narrow the source set, scope, and allowed pairing policy, but the role of the agent remains source-backed candidate collection only.
