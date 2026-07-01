# Task — GlossaryPromoter

## Goal

Promote only safe, source-backed terminology into the canonical BENE glossary master.

This run is focused on:

- invoicing hotspot terms
- document-type terms
- invoice settings terms
- Czech publication support terms already backed by approved sources

---

## Required inputs for this run

Read if present:

- `_ar/repo-map/glossary-master.csv`
- `_ar/evidence/terminology/glossary-candidates.md`
- `_ar/evidence/terminology/glossary-drift-report.md`
- `_ar/evidence/terminology/glossary-open-questions.md`
- `_ar/spec-draft/DOMAIN-ubiquitous-language.md`
- `_ar/tasks/glossary-arbitration-decisions.md`

---

## Promotion policy

1. Promote only rows that have explicit source and locator.
2. Keep glossary rows lowercase-only.
3. Keep exactly one preferred Czech and one preferred English term per row.
4. Put established alternative labels into `allowed_synonyms_*` fields, separated by `|` if multiple synonyms are needed.
5. If a candidate term is source-backed but still semantically disputed, do not promote it.
6. If an existing canonical row needs adjustment, refresh it in place rather than creating a duplicate concept.
7. Do not remove existing rows unless the task explicitly names them for retirement.

---

## Required outputs

Refresh or create:

- `_ar/repo-map/glossary-master.csv`
- `_ar/evidence/terminology/glossary-promotion-report.md`

Optional:

- `_ar/evidence/terminology/glossary-rejected-promotions.md`

---

## Success condition

This run is successful when:

- promoted glossary rows are safe for downstream agents
- blocked promotions remain out of the canonical glossary
- the glossary master stays lean and machine-readable
