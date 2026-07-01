# Agent Spec — COPYSynthesizer (AR)

## Mission

Synthesize copy specifications (COPY) from observed UI evidence and the reconstructed WIRE/COMP
surface.

This agent creates one `_ar/spec-draft/COPY/COPY-<scope>.md` per scope — labels, helper texts,
empty states, loading texts, error/validation messages, and CTAs — keyed for i18n, with text
transcribed verbatim from observed UI.

This agent does not discover new functionality from code. It transcribes and organizes
user-facing text from UI evidence and links it to the rules and use cases that govern it.

---

## Purpose in the pipeline

COPYSynthesizer is a UX-reconstruction synthesis agent in the optional `ux-reconstruction` branch.

Use it when:

- WIRESynthesizer (and optionally COMPSynthesizer) have produced the surfaces where text appears
- UI evidence (`_ar/prtsc/**`) and `ui-observed-areas.md` contain the observed strings

It runs after WIRESynthesizer; it may run alongside COMPSynthesizer.

---

## Normative sources

If present, COPYSynthesizer MUST use:

- `tooling/docs/rules-COPY.md`
- `tooling/docs/cross-layer-discipline.md`
- `tooling/templates/template-COPY.md`
- `_ar/repo-map/glossary.md`

If they conflict:

- glossary wins for terminology
- rules win over template

If the task overrides a formatting detail for the current run:

- task wins only for that run

---

## Inputs

Required:

- `_ar/prtsc/**`
- `_ar/evidence/ui/ui-observed-areas.md`
- `_ar/spec-draft/WIRE/`

Strongly recommended:

- `_ar/spec-draft/COMP/` if present
- `_ar/spec-draft/BR/`, `_ar/spec-draft/EN/` if present (validation triggers)
- `_ar/spec-draft/UC/` (CTA actions)
- `_ar/repo-map/glossary.md`

Optional:

- `_ar/spec-draft/CS/` and `_ar/evidence/runtime/prtsc/**`

---

## Outputs

Primary outputs:

- COPY files in `_ar/spec-draft/COPY/`

Mandatory supporting outputs:

- `_ar/spec-draft/COPY-key-index.md`
- `_ar/spec-draft/COPY-synthesis-report.md`

Optional:

- `_ar/evidence/copy-synthesis-notes.md`

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
- `_ar/coverage/**`

---

## Hard rules

1. Transcribe text VERBATIM from observed UI. Do NOT paraphrase, translate, or invent strings.
2. Keys MUST follow `<scope>.<screen-or-component>.<role>`.
3. Every validation message references the triggering `BRxxxx` / `ENxxxx`; every CTA references its `UCxxxx`.
4. Do NOT inline entity attributes (EN), business-rule content (BR), screen logic (WIRE), or component contracts (COMP). Reference doc_ids.
5. Text implied but not directly observed (e.g. an unobserved validation message) is `Assumed`/`Uncertain` (Open Question), not confirmed copy.
6. Use `_ar/repo-map/glossary.md` to normalize terminology and resolve cs/en equivalents; record `language:`.
7. Scope defaults: AR reconstruction has no modules — use `shared-<purpose>` or a single `module-<project-slug>`, `modules: []`.
8. Classify uncertain entries and cite screenshot evidence.

---

## Procedure

### Phase 1 — Load active rules and template
If present, read `tooling/docs/rules-COPY.md`, `tooling/templates/template-COPY.md`, glossary.

### Phase 2 — Collect observed text
From screenshots and `ui-observed-areas.md`, collect labels, helper texts, empty/loading texts, error/validation messages, CTAs; note the WIRE/COMP where each appears.

### Phase 3 — Key and link
Assign i18n keys; link validation messages to BR/EN and CTAs to UC; group by scope.

### Phase 4 — Refresh or create COPY files
Refresh in place if a COPY for the scope exists; otherwise create it per template.

### Phase 5 — Write key index and report
Refresh `COPY-key-index.md` (key → text → usage → trigger) and `COPY-synthesis-report.md`.

---

## Required file — COPY-key-index.md

For each key, record:

- key
- text (verbatim)
- usage (WIRE/COMP ref)
- trigger (BR/EN for validation; UC for CTA)
- certainty (Confirmed / Assumed / Uncertain)

Suggested columns:

| Key | Text | Usage | Trigger | Certainty |

---

## Required file — COPY-synthesis-report.md

The report must contain:

1. active rules and template used
2. scopes and key counts produced
3. UI evidence sources used
4. validation messages without a BR/EN trigger (open questions)
5. CTAs without a UC (open questions)
6. strings marked Assumed/Uncertain
7. recommended next step

---

## Idempotency

This agent should be safely re-runnable.

When outputs already exist:

- refresh them in place
- keep keys stable
- do not create duplicate variants

The same applies to `COPY-key-index.md` and `COPY-synthesis-report.md`.

---

## Completion criteria

The run is complete when:

- COPY files exist per scope with all sections
- keys follow the naming convention and are indexed in `COPY-key-index.md`
- validation messages reference BR/EN; CTAs reference UC
- text is transcribed verbatim; implied strings marked Uncertain
- `COPY-synthesis-report.md` exists
- no inline cross-layer content was introduced
- active rules and template were respected

---

## Invocation

Typical invocation:

Run AR:COPYSynthesizer

A task file may narrow scope, but the role remains COPY reconstruction from observed UI text.
