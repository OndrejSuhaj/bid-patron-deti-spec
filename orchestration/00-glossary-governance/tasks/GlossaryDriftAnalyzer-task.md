# Task — GlossaryDriftAnalyzer

## Goal

Analyze terminology drift for the active BENE glossary workflow.

This run is focused on the invoicing hotspot and on glossary effects that matter for:

- domain vocabulary
- entity naming
- invoice settings language
- document-type distinctions
- Czech publication safety

---

## Required inputs for this run

Read if present:

- `_ar/repo-map/glossary-master.csv`
- `_ar/repo-map/glossary.md`
- `_ar/spec-draft/DOMAIN-ubiquitous-language.md`
- `_ar/spec-draft/EN/**`
- `_ar/spec-draft/UC/**`
- `_ar/spec-draft/FN/**`
- `_ar/spec-draft/BR/**`
- `_ar/spec-draft/ARCH/**`
- `_ar/evidence/terminology/glossary-candidates.md`

If a file group is missing, report it and continue with available inputs.

---

## Required comparison policy

1. Treat `_ar/repo-map/glossary-master.csv` as the canonical baseline.
2. Treat `DOMAIN-ubiquitous-language.md` as the strongest draft vocabulary signal.
3. Report terminology drift without rewriting files.
4. Separate naming drift from concept-boundary conflicts.
5. Surface Czech translation gaps needed by final publication.
6. Explicitly flag conflicts around invoice, tax document, deposit / proforma, corrective document naming, invoice setting, and cashier-adjacent distinctions if present.

---

## Required outputs

Refresh or create:

- `_ar/evidence/terminology/glossary-drift-report.md`
- `_ar/evidence/terminology/glossary-open-questions.md`
- `_ar/evidence/terminology/glossary-missing-terms.md`

Optional:

- `_ar/evidence/terminology/glossary-canonicalization-hints.md`

---

## Success condition

This run is successful when:

- all major terminology drift is classified
- human-only decisions are explicit
- downstream canonicalization can use the report without guesswork
- no glossary or draft file was changed
