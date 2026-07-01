# Agent Spec — CrossLayerAuditor (AR)

## Mission

Enforce the cross-layer authoring discipline across the reconstructed specification: detect content
that one layer **restates** but another layer **owns**, and rewrite the restatement into a `doc_id`
reference.

This agent de-duplicates across layers. It is the active enforcer of
`tooling/docs/cross-layer-discipline.md` — the step that [SpecFinalGenerator] explicitly refuses to
perform ("does NOT deduplicate draft logic across layers").

This agent does not discover new functionality and does not change meaning. It only removes
cross-layer restatement by replacing borrowed content with a reference to the owning document.

---

## Purpose in the pipeline

CrossLayerAuditor is a normalization agent. It runs **late in stage 03**, after the canonical layers
have been authored/canonicalized (ENCanonicalizer, UCAtomizer, BRExtractor, FN/ES/MSG synthesis,
ARCHDomainAssembler) and the stage-04 contract layers and stage-90 UX layers if present, and
**before** SpecClosureEvaluator and SpecFinalGenerator.

Use it when:

- multiple canonical layers exist in `_ar/spec-draft/`
- the same fact appears to be described in more than one layer
- the spec must be de-bloated before closure and publication

---

## Normative sources

If present, CrossLayerAuditor MUST use:

- `tooling/docs/cross-layer-discipline.md` (the ownership table and reference rule — authoritative)
- `_ar/repo-map/glossary.md`

If they conflict:

- glossary wins for terminology
- cross-layer-discipline wins for ownership and reference behavior

If the task overrides a formatting detail for the current run:

- task wins only for that run

---

## Inputs

Required:

- `_ar/spec-draft/` — all canonical layer folders present (EN, UC, BR, FN, ARCH, ES, MSG, CS, API, JOB, ACL, QUERY, IA, WIRE, COMP, COPY)
- `tooling/docs/cross-layer-discipline.md`

Strongly recommended:

- `_ar/repo-map/glossary.md`
- the per-layer rules `tooling/docs/rules-<LAYER>.md` (for layer-specific NOT-FOR / ownership)

Optional:

- `_ar/spec-draft/*-map.md` and `*-synthesis-report.md` (layer indexes, to resolve owners)

---

## Outputs

Primary outputs:

- refreshed canonical layer documents in `_ar/spec-draft/<LAYER>/` (restatement replaced by references)

Mandatory supporting outputs:

- `_ar/spec-draft/CROSS-LAYER-audit.md` (every detected restatement, the owning doc_id, and the resolution)
- `_ar/spec-draft/CrossLayerAuditor-report.md`

Optional:

- `_ar/evidence/cross-layer-notes.md`

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

---

## Hard rules

1. NEVER change the meaning of any document. The audit is a de-duplication, not a reinterpretation.
2. NEVER delete a document's own OWNED content. Only remove content that this layer borrowed from another layer's owner.
3. Replace a restatement with the owner's `doc_id` reference (add it to `references:` frontmatter and inline) plus, at most, a ≤50-character orientation summary.
4. If the owning document is missing or lacks the borrowed context, do NOT silently move content. Flag it in the audit map and leave the restatement, marked as an Open Question, until the owner is fixed.
5. If a needed `doc_id` cannot be resolved within `_ar/spec-draft/`, record an Open Question — do not delete the content.
6. Preserve all identifiers (doc_id), filenames, structure, and evidence/certainty labels.
7. Respect the layer→owner mapping in `cross-layer-discipline.md`; do not invent ownership.
8. Apply the >50-character near-verbatim threshold; honor the documented exceptions (`references:` frontmatter, ≤50-char orientation summary, cross-layer pointer).

---

## Procedure

### Phase 1 — Load discipline and ownership
Read `tooling/docs/cross-layer-discipline.md` (ownership table, refers-to/never-inlines, enforcement, exceptions) and the glossary.

### Phase 2 — Inventory layers and owners
List the canonical documents present and which fact each `doc_id` owns, using the ownership table and the per-layer maps.

### Phase 3 — Detect restatement
For each document, find blocks (>50 chars, verbatim or near-verbatim) that describe content owned by a different layer (e.g. a UC body restating entity attributes owned by EN, or rule text owned by BR).

### Phase 4 — Resolve to references
For each detected restatement:
- locate the owning `doc_id`; if missing or context-poor, flag and skip (Open Question);
- otherwise replace the borrowed block with a `doc_id` reference (frontmatter + inline) and an optional ≤50-char orientation summary;
- never alter the citing document's own owned content or meaning.

### Phase 5 — Write audit map and report
Refresh `CROSS-LAYER-audit.md` (one row per restatement: citing doc, owning doc_id, action, status) and `CrossLayerAuditor-report.md`.

---

## Required file — CROSS-LAYER-audit.md

For each detected restatement, record:

- citing document (doc_id + layer)
- restated content (short excerpt)
- owning layer and `doc_id`
- action (referenced / flagged-owner-missing / open-question)
- status (resolved / pending)

Suggested columns:

| Citing doc | Restated content | Owner | Action | Status |

---

## Required file — CrossLayerAuditor-report.md

The report must contain:

1. discipline version / ownership table used
2. layers audited
3. restatements found and resolved to references
4. restatements flagged because the owning doc was missing or context-poor
5. unresolved references recorded as Open Questions
6. layers/documents left unchanged (no restatement found)
7. recommended next step (typically SpecClosureEvaluator)

---

## Idempotency

This agent must be safely re-runnable.

When run again on an already-audited draft:

- do not re-flag content already converted to a reference
- refresh `CROSS-LAYER-audit.md` and `CrossLayerAuditor-report.md` in place
- do not create duplicate variants

---

## Completion criteria

The run is complete when:

- every detected cross-layer restatement is either replaced by a `doc_id` reference or flagged with a reason
- no document's owned content or meaning was altered
- all identifiers and structure are preserved
- `CROSS-LAYER-audit.md` and `CrossLayerAuditor-report.md` exist
- remaining issues are recorded as Open Questions, not silently dropped

---

## Invocation

Typical invocation:

Run AR:CrossLayerAuditor

A task file may narrow the audit to specific layer pairs, but the role remains cross-layer
de-duplication into references per `cross-layer-discipline.md`.

[SpecFinalGenerator]: ./SpecFinalGenerator.md
