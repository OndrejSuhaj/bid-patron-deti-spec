# Task — GlossaryCandidateCollector

## Goal

Collect source-backed terminology candidates for the active BENE glossary workflow.

This run is focused on:

- invoicing terminology
- invoice settings terminology
- document-type terminology
- payment- and cashier-adjacent terminology
- approved accounting vocabulary useful for Czech publication support

---

## Required sources for this run

Read if present:

- `_ar/repo-map/glossary-master.csv`
- `_ar/spec-draft/**`
- `_ar/evidence/**`
- `_ar/pdf/smartecaCZ.pdf`
- `_ar/pdf/smartecaEN.pdf`
- `_ar/evidence/terminology/cz-chart-of-accounts-basic_0.xlsx`
- `_ar/tasks/glossary-source-pack.md`
- `_ar/tasks/glossary-scope.md`

If some files are missing, report the gap and continue with available approved sources.

---

## Required extraction policy

1. Extract only terms that have explicit source backing.
2. Keep everything in lowercase if the source allows safe lowercasing without changing meaning.
3. If a Czech source term maps to more than one plausible English term, do not force the pair.
4. If a source explicitly provides paired Czech and English terms, preserve that pair.
5. If the task or source pack allows conservative page-based pairing, keep uncertain rows as `prijatelne` rather than `jasne`.
6. Record source conflicts explicitly.
7. Do not modify the canonical glossary in this run.

---

## Required outputs

Refresh or create:

- `_ar/evidence/terminology/glossary-candidates.md`
- `_ar/evidence/terminology/glossary-source-index.md`
- `_ar/evidence/terminology/glossary-candidate-report.md`

Optional:

- `_ar/evidence/terminology/glossary-unpaired-source-terms.md`

---

## Requested structure hints

Group candidates into at least these sections if applicable:

- document types
- invoice settings and configuration terms
- payment and cashier terms
- accounting support vocabulary
- unresolved or conflicting terms

If a section is empty, omit it.

---

## Success condition

This run is successful when:

- all new candidate terms are source-backed
- unresolved pairings remain unresolved
- candidate rows are ready for drift analysis
- no canonical glossary file was changed
