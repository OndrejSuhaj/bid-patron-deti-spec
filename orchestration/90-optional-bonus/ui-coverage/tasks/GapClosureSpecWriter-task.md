# Task — GapClosureSpecWriter

## Goal
Close the highest-value promoted UI/spec gaps and turn them into concrete EN and UC draft artifacts, without hallucinating missing logic.

## Execution mode
Conservative, evidence-first, no invention.

If an artifact cannot be safely completed, either:
- write it with explicit `Evidence Pending` sections, or
- leave it unwritten and record the reason in the report.

---

## Primary scope

Process only the following artifacts in this run.

### EN targets
- EN0022 SyntheticAccount
- EN0023 AccountingJournalEntry
- EN0024 CostCentre
- EN0025 Zakazka
- EN0026 Cinnost
- EN0027 Predkontace
- EN0028 UnitOfMeasure
- EN0029 InvoiceSetting

### UC targets
- UC0035 AccountingYearClose
- UC0036 LedgerRecalculation
- UC0037 AccountingDimensionManagement
- UC0038 ResultsDashboardRendering
- UC0039 InvoiceSettingsConfiguration
- UC0040 ContactDocumentHistoryView
- UC0042 RecurringInvoiceTemplateManagement
- UC0043 CompanyMemberInviteAndPositionAssignment
- UC0048 CompanyContextSelection

---

## Open questions to resolve first if possible

Resolve these before writing blocked artifacts:

- OQ-001 — Per-invoice-module user permissions vs TariffUser RBAC
- OQ-004 — DataBox connection credentials storage
- OQ-005 — "Light" invoice variant meaning
- OQ-006 — Zakázka lifecycle states
- OQ-007 — Předkontace scoping
- OQ-010 — Role "Skupina" field

If OQ-004 is not needed for the selected artifact set, you may leave it unresolved and note that in the report.

---

## Priority order

### Step A — Accounting bounded context
Write first:
- EN0022
- EN0023
- EN0024
- EN0025
- EN0026
- EN0027
- EN0028
- UC0035
- UC0036
- UC0037

### Step B — Invoice settings / reporting
Then:
- EN0029
- UC0038
- UC0039

### Step C — high-value UX/domain completion
Then:
- UC0040
- UC0042
- UC0043
- UC0048

---

## Required evidence sources

Use these as the primary evidence base:
- `_ar/spec-draft/UI-gap-promotions.md`
- `_ar/spec-draft/UI-gap-open-questions.md`
- `_ar/coverage/ui-followups.md`
- `_ar/coverage/ui-screen-index.md`
- `_ar/coverage/ui-gap-analysis.md`
- `_ar/evidence/ui/ui-observed-areas.md`
- `_ar/spec-draft/DOMAIN-kernel.md`
- `_ar/spec-draft/DOMAIN-aggregates.md`
- `_ar/spec-draft/EN/`
- `_ar/spec-draft/UC/`
- `_ar/evidence/flow/`
- code in `src/**` and `packages/**`

---

## Style requirements

### For EN files
- Follow the existing EN style already used in `_ar/spec-draft/EN/`
- Use canonical names from ubiquitous language where possible
- Keep unclear parts marked explicitly
- Do not invent field lists beyond evidence
- If lifecycle is partial, say so

### For UC files
- Keep domain-oriented wording
- Use evidence level explicitly
- Main flow should describe business behaviour, not framework internals
- Keep traceability section
- Add "Risks in This UC" when relevant

---

## Allowed updates to existing files

You MAY update these existing files only if needed for consistency:
- `_ar/spec-draft/UC-candidates.md`
- `_ar/spec-draft/UC-srv-traceability.md`
- `_ar/spec-draft/EN-candidates.md`
- existing EN or UC files only when cross-reference addendum is necessary

Do NOT perform broad rewrites of existing artifacts in this run.

---

## Mandatory report

Write:
- `_ar/spec-draft/GapClosureSpecWriter-report.md`

It must contain:

1. Files created
2. Files updated
3. Open questions resolved
4. Open questions unresolved
5. Artifacts blocked
6. Confidence summary:
   - Confirmed
   - Partial
7. Recommended next step

---

## Stop conditions

Stop the run and record blockage if:
- a required entity cannot be identified in code or evidence
- UI suggests behaviour but code contradicts it
- numbering conflict appears
- a requested artifact would require guessing core business logic

---

## Success definition

This run is successful if:
- the requested P1 artifacts are created or explicitly blocked with reason
- InvoiceSetting ambiguity is handled safely
- accounting domain artifacts are materially advanced
- the report clearly states what remains before RewriteDecisionCompiler

---

## Intended next step after this run

If successful, recommended next pipeline step is:

- `Run AR:RewriteDecisionCompiler`

If major P1 items remain blocked, recommended next step should instead name the exact follow-up investigation needed.