Run AR:ScreenshotCoverageAuditor

Load and strictly follow:
tooling/orchestration/agents/ScreenshotCoverageAuditor.md

Write ONLY to `_ar/**`.

---

# Pre-check (must confirm in output)

Mandatory screenshot inputs
- Read all `_ar/prtsc/**`

Mandatory specification inputs
- Read `_ar/spec-draft/**`
- Read `_ar/coverage/**`
- Read `_ar/spec-final/**` if exists

Optional evidence inputs
- Read `_ar/repo-map/modules.md` if exists
- Read `_ar/evidence/**` if relevant

---

# Rules

- Do NOT modify existing EN/UC/SRV files
- Do NOT infer domain logic from layout alone
- Every hard claim must include Evidence
- Mark uncertain areas explicitly
- Flag possible NexCRM/shared-platform behavior separately

---

# Deliver

Create/update:
- `_ar/coverage/ui-screen-index.md`
- `_ar/coverage/ui-gap-analysis.md`
- `_ar/evidence/ui/ui-observed-areas.md`