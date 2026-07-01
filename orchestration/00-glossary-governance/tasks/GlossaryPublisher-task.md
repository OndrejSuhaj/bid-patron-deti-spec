# Task — GlossaryPublisher

## Goal

Publish the canonical BENE glossary master into the markdown glossary consumed by downstream AR agents.

---

## Required inputs for this run

Read if present:

- `_ar/repo-map/glossary-master.csv`
- `_ar/evidence/terminology/glossary-promotion-report.md`
- `_ar/evidence/terminology/glossary-drift-report.md`

---

## Required publication policy

1. Treat `_ar/repo-map/glossary-master.csv` as the single source of truth.
2. Keep all terms lowercase-only.
3. Preserve one preferred Czech and one preferred English term per row.
4. Show allowed synonyms clearly, but do not merge them into preferred term fields.
5. Keep source and locator visible for each row.
6. If a needed publication note is missing, record the gap instead of guessing.

---

## Required outputs

Refresh or create:

- `_ar/repo-map/glossary.md`
- `_ar/repo-map/glossary-publish-report.md`

Optional:

- `_ar/repo-map/glossary-missing-publication-notes.md`

---

## Success condition

This run is successful when:

- downstream agents can safely read `_ar/repo-map/glossary.md`
- final publication has a stable Czech / English terminology bridge
- no glossary rows were invented during publication
