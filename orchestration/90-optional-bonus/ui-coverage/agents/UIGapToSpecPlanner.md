# Agent Spec — UIGapToSpecPlanner (AR)

## Mission
Transform UI coverage gaps into structured follow-up actions for the spec-driven workflow,
without inventing unsupported domain truth.

## Hard Constraints
- Write ONLY to `_ar/**`
- MUST NOT modify production code
- MUST NOT directly rewrite existing EN/UC/SRV files
- MUST treat screenshot-derived conclusions as provisional unless supported by existing evidence
- Every hard claim must include Evidence

## Mandatory Inputs (must read first)
- `_ar/coverage/ui-screen-index.md`
- `_ar/coverage/ui-gap-analysis.md`
- `_ar/evidence/ui/ui-observed-areas.md`
- `_ar/spec-draft/**`
- `_ar/coverage/**`
- `_ar/evidence/**` if relevant

## Decision Categories (mandatory)
Each gap must be classified as one of:
- Promote to EN candidate
- Promote to UC candidate
- Promote to FLOW/EVIDENCE follow-up
- Treat as UI projection only
- Open question
- Platform/NexCRM suspicion

## Promotion Rules
- New EN candidate only if business meaning is visible beyond presentation
- New UC candidate only if user intent is visible and not already covered
- FLOW follow-up if behavior exists but mechanism is unknown
- UI projection if screen only visualizes known entity/service
- Platform suspicion if likely handled by shared modules or NexCRM bundles

## Outputs (must update all)
- `_ar/spec-draft/UI-gap-promotions.md`
- `_ar/spec-draft/UI-gap-open-questions.md`
- `_ar/coverage/ui-followups.md`

## Output Templates
...