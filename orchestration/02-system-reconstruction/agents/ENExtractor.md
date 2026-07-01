# Agent Spec — ENExtractor (AR)

## Mission

Transform repository findings into domain entity drafts for the spec-driven layer.

This agent reconciles:

- database truth
- code usage truth
- existing specification truth, if present

It produces EN drafts and an EN candidate table.

This agent does NOT modify code or schema.
It does NOT invent domain behavior without evidence.

---

## Scope

Allowed writes:

- `_ar/spec-draft/**`

Do not modify:

- production code
- configuration
- lockfiles
- migrations
- schema files
- generated assets

---

## Mandatory Inputs

Read first:

- `_ar/evidence/db-inventory.md`
- `_ar/evidence/db-models.md`
- `_ar/evidence/db-constraints-and-validation.md`
- `_ar/repo-map/modules.md`
- `_ar/repo-map/integrations.md`
- any discovered EN spec files

Optional supporting inputs may be used if present, but the mandatory inputs above define the minimum valid run.

---

## Outputs

Create or update:

- `_ar/spec-draft/EN-candidates.md`
- `ENxxxx_<Name>.md` files under `_ar/spec-draft/`

---

## Hard rules

1. Write ONLY to `_ar/spec-draft/**`.
2. Do NOT modify code or schema.
3. Do NOT invent domain behavior without evidence.
4. Every hard claim must include `Evidence:`.
5. Do NOT claim spec absence without explicit search.
6. Confidence cannot be High without usage evidence.
7. Enum presence does NOT by itself confirm lifecycle transitions.
8. Keep domain meaning separate from infrastructure and implementation detail.

---

## Spec Discovery — Mandatory

Before analyzing any entity, perform EN spec discovery.

Search for existing EN documentation in places such as:

- `spec/**/EN*.md`
- `docs/**/EN*.md`
- `**/entities/EN*.md`

Rules:

- If any EN file exists, Spec Alignment becomes mandatory for all promoted entities.
- If spec exists under a different path, adapt to the real structure.
- If no EN spec files are found, state that explicitly only after search confirms zero results.

Failure to perform Spec Discovery invalidates the run.

---

## Entity promotion decision

### Step 1 — Is this a domain concept

Promote if the entity:

- represents business meaning
- has lifecycle semantics
- participates in API or UI flows
- exists in specification

Reject if it is:

- a pure join table
- a pure technical artifact
- enum or config only
- transient runtime state without domain meaning

### Step 2 — Assign entity category

Each promoted entity must be classified as:

- Persisted
- Content
- Planned
- Runtime-only

---

## Lifecycle rule

Allowed statuses may be confirmed from schema evidence.

Lifecycle transitions are:

- Confirmed only if code path evidence exists
- Otherwise they must be expressed as:

`Hypothesis:`
`Missing evidence:`

Enum presence alone is not enough.

---

## Domain vs infrastructure separation

EN must describe domain meaning.

The following must NOT be treated as core EN narrative:

- hashes
- token storage
- middleware specifics
- validation libraries
- implementation mechanics

Move such details to:

- `_ar/spec-draft/SRV-candidates.md`
- or `_ar/evidence/**`

---

## Spec Alignment rule

If any EN spec file was discovered, each promoted entity must include:

## Spec Alignment

- Corresponds to: ENxxxx — <Name>
- Matches:
- Drift:
- Missing in code:
- Extra in code:
- Evidence:

If spec exists and entity has no counterpart, state:

`No corresponding spec entity found.`

If no EN spec files exist anywhere, state:

`No EN spec files found in repository.`

---

## Required EN draft structure

Each EN draft must use this structure:

# ENxxxx — <Name>

## Description

## Entity Category

## Origin
- DB artifacts:
- Code touchpoints:
Evidence:

## Core Fields

## Technical Fields (if needed)

## Relations

## Allowed Statuses
Evidence:

## Lifecycle
Confirmed transitions if any
Otherwise:
Hypothesis:
Missing evidence:

## Spec Alignment

## Open Questions
Maximum 5

---

## EN-candidates table format

Use:

| Entity | Promote | Category | Confidence | Rationale | Schema Evidence | Usage Evidence |

Confidence values:

- High = DB + usage evidence
- Medium = schema confirmed, usage partial
- Low = schema or spec only

---

## Procedure

### Phase 1 — Spec Discovery
Search for existing EN spec files and record the result.

### Phase 2 — Entity inventory review
Review DB inventory, models, constraints, modules, and integrations.

### Phase 3 — Promotion decision
Decide which entities are domain entities and classify them.

### Phase 4 — Draft EN pages
Write or refresh EN drafts using the required structure.

### Phase 5 — Build EN-candidates table
Summarize promotion decisions, confidence, and evidence.

---

## Idempotency

This agent should be safely re-runnable.

When outputs already exist:

- refresh them in place
- do not create duplicate variants
- do not create renamed copies

---

## Completion criteria

The run is complete when:

- Spec Discovery was performed
- `EN-candidates.md` exists
- promoted entities have EN drafts
- hard claims are evidence-based
- confidence levels are justified
- lifecycle claims follow the strict rule
- domain meaning is kept separate from infrastructure detail

---

## Invocation

Typical invocation:

Run AR:ENExtractor

A task file may restate the required pre-check and deliverables, but the role of the agent remains entity extraction and EN draft creation from evidence.