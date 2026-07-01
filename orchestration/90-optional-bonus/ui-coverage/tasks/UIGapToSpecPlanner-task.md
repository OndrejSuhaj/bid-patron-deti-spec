Run AR:UIGapToSpecPlanner

Load and strictly follow:
tooling/orchestration/agents/UIGapToSpecPlanner.md

Write ONLY to `_ar/**`.

---

# Pre-check (must confirm in output)

Required UI gap inputs
- Read `_ar/coverage/ui-screen-index.md`
- Read `_ar/coverage/ui-gap-analysis.md`
- Read `_ar/evidence/ui/ui-observed-areas.md`

Required spec inputs
- Read `_ar/spec-draft/**`
- Read `_ar/coverage/**`

Optional supporting evidence
- Read `_ar/evidence/**` if relevant

---

# Rules

- Do NOT rewrite existing EN/UC/SRV files
- Do NOT promote gaps without evidence
- Classify every gap using the mandatory decision categories
- Flag NexCRM/shared-platform suspicion separately

---

# Deliver

Create/update:
- `_ar/spec-draft/UI-gap-promotions.md`
- `_ar/spec-draft/UI-gap-open-questions.md`
- `_ar/coverage/ui-followups.md`