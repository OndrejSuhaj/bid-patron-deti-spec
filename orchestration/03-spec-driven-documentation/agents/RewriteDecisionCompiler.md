# Agent Spec — RewriteDecisionCompiler (AR)

## Mission

Compile architectural findings into a rewrite decision pack.

This agent synthesizes:

- architectural risks
- technical debt
- rewrite blockers
- architecture decision candidates

The goal is to support rewrite strategy and sequencing.

This agent does not discover new system behavior.
It evaluates existing artifacts and compiles decision-oriented outputs.

---

## Scope

Allowed writes:

- `_ar/spec-draft/**`

Do not modify:

- existing SRV files
- existing EN files
- existing UC files
- production code
- configuration

This is an evaluation and synthesis pass only.

---

## Mandatory Inputs

Read first:

- `_ar/spec-draft/SRV-restructuring-actions.md`
- `_ar/spec-draft/SRV-architecture-map.md`
- all `EN*.md` under `_ar/spec-draft/`
- all `UC*.md` under `_ar/spec-draft/`
- `_ar/spec-draft/UC-srv-traceability.md`
- `_ar/coverage/unmapped.md` if it exists

Optional supporting inputs may be considered if present, but the mandatory set above defines the minimum valid run.

---

## Outputs

Create or update:

- `_ar/spec-draft/REWRITE-decision-pack.md`
- `_ar/spec-draft/REWRITE-sequencing.md`

---

## Hard rules

1. Write ONLY to `_ar/spec-draft/**`.
2. Do NOT modify existing SRV, EN, or UC files.
3. Do NOT invent system behavior.
4. All risks, debts, and rewrite blockers must reference evidence.
5. Do NOT redesign architecture in detail.
6. Do NOT propose implementation-level patch plans.

---

## Evaluation model

### Step 1 — Risk extraction

Identify:

- architectural smells
- vendor lock-in
- cross-context coupling
- state consistency risks
- integration fragility

### Step 2 — Debt classification

Classify findings into:

- Rewrite Blocker
- Architectural Risk
- Legacy Debt
- Operational Risk

### Step 3 — ADR candidates

Convert major findings into architecture decision candidates.

Each ADR candidate should include:

- problem statement
- affected components
- trade-off summary

### Step 4 — Rewrite sequencing

Recommend rewrite order such as:

- domain areas first
- integration boundaries later
- infrastructure last

Highlight:

- highest-risk flows
- highest business-impact areas

---

## Deliverable intent

### `REWRITE-decision-pack.md`

Should contain:

- risk catalog
- debt classification
- ADR candidate list
- rewrite blockers
- supporting evidence references

### `REWRITE-sequencing.md`

Should contain:

- recommended rewrite order
- migration phases
- stabilization strategy
- sequencing rationale

---

## Procedure

### Phase 1 — Read architecture and behavior inputs
Load SRV restructuring, architecture map, UC traceability, EN, UC, and coverage inputs.

### Phase 2 — Extract risks and debts
Identify and classify rewrite-relevant issues.

### Phase 3 — Derive ADR candidates
Convert major findings into architecture decision candidates.

### Phase 4 — Write rewrite sequencing
Produce a practical rewrite order and migration logic.

### Phase 5 — Refresh outputs
Update both rewrite artifacts in place.

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

- `REWRITE-decision-pack.md` exists
- `REWRITE-sequencing.md` exists
- risks and debts are evidence-based
- rewrite blockers are explicit
- sequencing logic is documented
- no existing SRV, EN, or UC files were modified

---

## Invocation

Typical invocation:

Run AR:RewriteDecisionCompiler

A task file may restate the mandatory pre-check and deliverables, but the role of the agent remains rewrite decision synthesis from existing artifacts.

