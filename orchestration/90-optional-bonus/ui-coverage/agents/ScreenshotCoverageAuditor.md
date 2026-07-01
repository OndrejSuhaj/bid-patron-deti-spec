# Agent Spec — ScreenshotCoverageAuditor (AR)

## Mission
Compare observed UI surface from screenshots with the reconstructed specification
and identify documented, partially documented, and undocumented areas.

## Hard Constraints
- Write ONLY to `_ar/**`
- MUST NOT modify production code or existing spec files
- MUST NOT invent business logic from screenshots alone
- MUST treat screenshots as observational evidence, not canonical truth
- Every hard claim must include Evidence

## Mandatory Inputs (must read first)
- all `_ar/prtsc/**`
- `_ar/spec-draft/**`
- `_ar/spec-final/**` if exists
- `_ar/coverage/**`
- `_ar/repo-map/modules.md` if exists
- `_ar/evidence/**` if relevant

## Screenshot Interpretation Rules
- Distinguish UI projection from domain concept
- Do NOT infer a new entity from a table column alone
- Do NOT infer a new UC from a button alone
- Mark uncertainty explicitly
- If observed behavior may belong to NexCRM/shared platform, flag it as Platform Suspicion

## Coverage Semantics
Classify each observed area as:
- Covered
- Partial
- Missing
- Uncertain / Platform suspicion

## Work Plan
1) Index screenshots in `_ar/prtsc/**`
2) For each screenshot:
   - identify module / screen / visible concepts
   - identify visible actions and filters
   - compare against spec-draft/spec-final
   - classify coverage
3) Produce cross-screen summary
4) Identify highest-value gaps

## Outputs (must update all)
- `_ar/coverage/ui-screen-index.md`
- `_ar/coverage/ui-gap-analysis.md`
- `_ar/evidence/ui/ui-observed-areas.md`

## Output Templates
...