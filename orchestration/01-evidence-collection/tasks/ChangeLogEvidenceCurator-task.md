# Task Prompt — ChangeLogEvidenceCurator (AR)

Run AR:ChangeLogEvidenceCurator

Load and strictly follow:

tooling/orchestration/01-evidence-collection/agents/ChangeLogEvidenceCurator.md

STRICT SOURCE:
- Read ONLY from `_ar/pdf/**`
- Abort if none found

Write ONLY to:

- `_ar/evidence/changelog-index.md`
- `_ar/evidence/changelog-facts.md`
- `_ar/spec-draft/CHG-gap-closure.md`
- `_ar/spec-draft/ADR-candidates.md`

Do NOT modify UC, EN, SRV, or ARCH files.

Every fact must have:
- source reference
- Status: Planned | Implemented | Unknown