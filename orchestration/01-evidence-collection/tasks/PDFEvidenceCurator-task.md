# Task Prompt — PDFEvidenceCurator (AR)

Run AR:PDFEvidenceCurator

Load and follow:

tooling/orchestration/01-evidence-collection/agents/PDFEvidenceCurator.md

Write ONLY to `_ar/**`.

Do not modify any other files.

Primary input folder:

- `_ar/pdf/`

Treat PDFs as evidence unless explicitly stated otherwise.

Enforce Evidence rule strictly.
Do not invent requirements, process details, or architecture claims.
If uncertain, mark as `Hypothesis` and state what evidence is missing.

Deliverables:

- structured markdown evidence outputs under `_ar/evidence/pdf/`

Optional:
- create an index file if multiple PDFs are processed and navigation would benefit from it