# Critical Scenario Documentation Rules (CS)

> See also: cross-layer-discipline.md — shared discipline for all _ar/** canonical docs.

## Purpose

CS documents capture critical front-end and business-visible runtime scenarios used to reconstruct actual system behavior from observable application flow.

CS is the correct canonical layer when:

- the documentation goal is to record what actually happens in the running application,
- the primary evidence source is FE runtime observation (screenshots, screen recordings, live interaction),
- the scenario needs to distinguish observed facts from inferred behavior,
- the result should inform later specification revision, architecture reconstruction, or acceptance criteria.

CS documents describe **observed behavior**, not designed behavior.

---

## Naming

CS{XXXX} – {Actor Verb Object}

- `XXXX` = zero-padded scenario number (e.g. 0001, 0006)
- Title follows Actor-Verb-Object pattern where possible

File naming: `CS{XXXX}_{Title}.md`

---

## Required Frontmatter

```yaml
---
doc_id: CSxxxx
title: <Actor Verb Object>
canonical_layer: CS
spec_type: critical-scenario
status: draft | canonical
---
```

Optional:

```yaml
scope: <module / hotspot>
priority: P0 | P1 | P2
impact: High | Medium | Low
references:
  - UCxxxx
  - ENxxxx
```

---

## Evidence Types

CS documents may use these evidence types:

- **FE evidence** — directly observed runtime behavior (screenshots, screen recordings, live interaction)
- **Observed fact** — confirmed by FE evidence
- **Prior analytical context** — generic earlier analysis (e.g., architecture notes, backend documentation)
- **Previous analysis output** — specific earlier analytical artifact (e.g., user-journey mapping, flow diagram)
- **Working assumption** — plausible but not directly confirmed by FE evidence
- **Legacy hint** — weak historical or indirect signal

---

## Evidence Priority Rule

FE evidence has priority over all other reference types.

If FE evidence and prior analytical aids differ:

- FE evidence wins for runtime behavior description
- the mismatch must be recorded as one of:
  - working assumption
  - inconsistency
  - open question
  - note from prior analysis
- Prior analysis must not be treated as immutable truth
- Prior analysis may strengthen: preconditions, hidden dependencies, likely follow-up logic, likely missing context
- Prior analysis must not override directly observed FE behavior

---

## Certainty Classification

Every claim in a CS document should be classifiable as:

- **Confirmed** — directly observed in FE evidence
- **Probable** — supported by FE evidence + prior analysis
- **Assumed** — plausible working assumption, not directly confirmed
- **Uncertain** — insufficient evidence; recorded as open question
- **Inconsistent** — FE evidence contradicts prior analysis or other FE evidence

When certainty is not obvious, state it explicitly.

---

## Recommended Structure

### Required Sections

- **Purpose** — what this scenario documents and why it matters
- **Preconditions** — what must be true before the scenario begins
- **Main Flow** — numbered steps with User Action, System Response, Evidence classification, and Notes
- **Observed Facts** — confirmed observations from FE evidence
- **Open Questions** — unresolved questions arising from the scenario

### Recommended Sections

- **Business Meaning** — why the scenario matters from a user/business perspective
- **Primary Role** — which user role executes the scenario
- **Scenario Type** — read-only / controlled-write / mixed
- **Working Assumptions** — plausible but unconfirmed claims
- **Prior Analytical Hints** — non-binding hints from earlier analysis
- **Scenario Continuations** — follow-up scenarios identified during observation
- **Screenshot Index** — references to screenshot evidence files

### Optional Sections

- **Test Data / Variants** — test data used or variant conditions observed
- **What to Observe Carefully** — guidance for future re-observation
- **Required Capture** — specific evidence that should be captured on re-run
- **Probable Domain Elements** — likely business objects implied by the scenario
- **Probable Capabilities** — likely functional capabilities implied
- **Reconstruction Value** — how this scenario informs later spec/architecture work
- **Safety Notes** — risks or cautions for scenario execution
- **Execution Notes** — environment, tenant, dataset, account, date

---

## Sequencing Rule

Scenarios should be expanded breadth-first through direct follow-ups, not deep-tree first.

Meaning:

1. Main scenario
2. Its direct follow-up scenarios
3. Only then follow-up-of-follow-up scenarios

This prevents deep-tree reconstruction that loses context of the primary flow.

---

## Screenshot and Evidence Storage

Screenshots and runtime evidence should be stored in a project-specific evidence directory.

Recommended convention:

```
_ar/evidence/runtime/prtsc/CS{XXXX}_{scenario-slug}/{file}.png
```

Naming convention for screenshots is a **project-level adaptation point** — projects may define their own numbering scheme as long as screenshots are traceable to scenario steps.

---

## Anonymization Rule

Personal data (names, emails, phone numbers, addresses) must be anonymized in CS artifacts.

This applies to:

- text content in the artifact body
- screenshot annotations (where feasible — raw screenshots may contain real data if the environment is controlled)

---

## Artifact Language

- Artifact language: English (default)
- Conversation language: project-level adaptation point (may differ from artifact language)
- Markdown format is mandatory

---

## Variant Depth Rule

If a scenario is prepared in multiple depth variants (short / standard / extended):

- All variants must maintain the same canonical scope
- All variants must maintain the same follow-up hooks
- Variants differ only in depth and detail, not in meaning or scope

---

## Cross-references (reference, don't restate)

CS owns observed FE runtime behavior and screenshot evidence. It references other layers by
`doc_id` and never restates their content:

- References: `UCxxxx`, `ENxxxx`.
- Never inline (cite instead): rule content (→ `BR`), contracts (→ `API`). Observed facts stay in CS.

See `cross-layer-discipline.md` for the full ownership table and the >50-character restatement rule.

---

## Restrictions

CS documents must not contain:

- implementation code
- framework-specific configuration
- inferred backend behavior presented as confirmed fact
- API contract definitions
- database schema details
- deployment or infrastructure details
- claims that override FE evidence based solely on prior analysis

---

## Interaction with Prior Analysis

When a project has existing analytical aids (e.g., user-journey exports, architecture diagrams, backend documentation):

- They may be used as secondary validation context
- They may strengthen preconditions, hidden dependencies, and likely follow-up logic
- They must not override runtime facts
- Mismatches must be recorded explicitly
- The specific analytical aid and its role should be declared at the project level

This is a **project-level adaptation point** — each project defines which analytical aids exist and how they relate to CS evidence.

---

## Project-Level Adaptation Points

The following aspects are intentionally left for project-specific configuration:

1. **Conversation language** — may be Czech, English, or other
2. **Specific analytical aids** — which prior analysis outputs exist and how they map to CS validation
3. **Screenshot naming convention** — project may define its own sub-step numbering
4. **Evidence storage path** — project-specific directory structure
5. **Scenario scope and working order** — which domain areas are in scope and in what sequence
6. **Priority scheme details** — how P0/P1/P2 map to project-specific reconstruction urgency
7. **Variant depth policy** — whether short/standard/extended variants are used

These should be documented in a project-level CS configuration note, not hardcoded into the general rules.
