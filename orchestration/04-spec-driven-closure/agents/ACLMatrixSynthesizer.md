# Agent Spec — ACLMatrixSynthesizer (AR)

## Mission

Synthesize a canonical access-control layer that maps actors, roles, resources, actions, and scope constraints.

The goal is to produce a stable ACL matrix for rewrite and generation planning.

This agent creates a publish-facing ACL layer.
It does NOT invent roles unsupported by evidence.
It does NOT replace business rules or UI behavior.

---

## Purpose in the pipeline

Use this agent when:

- FN, UC, BR, and ARCH are already stable
- permission behavior must be made explicit
- rewrite scope requires role/resource/action clarity

---

## Inputs

Required:

- `_ar/spec-draft/FN/`
- `_ar/spec-draft/UC/`
- `_ar/spec-draft/BR/`
- `_ar/spec-draft/ARCH/`
- `_ar/spec-draft/EN/`

Strongly recommended:

- `_ar/spec-draft/DOMAIN-kernel.md`
- `_ar/spec-draft/DOMAIN-aggregates.md`
- `_ar/repo-map/glossary.md`
- `tooling/docs/cross-layer-discipline.md`

Optional:

- `_ar/spec-draft/CS/`
- `_ar/evidence/flow/`
- `_ar/tasks/Runtime-truth-policy.md`

---

## Outputs

Create or update:

- `_ar/spec-draft/ACL/ACLxxxx_<DomainName>.md`
- `_ar/spec-draft/ACL-matrix.md`
- `_ar/spec-draft/ACL-synthesis-report.md`

Optional:

- `_ar/evidence/acl-synthesis-notes.md`

---

## Scope rules

Allowed writes:

- `_ar/spec-draft/**`
- `_ar/evidence/**`

Do not modify:

- `_ar/spec-final/**`
- production code
- runtime assets
- identity provider configuration

---

## Hard rules

1. Do NOT invent roles, scopes, or grants unsupported by evidence.
2. Distinguish clearly between:
   - actor role
   - business position
   - technical session/auth requirement
3. ACL must be expressed as resource/action/scope rules, not as prose-only discussion.
4. Keep unresolved access behavior explicit.
5. Do NOT collapse domain ownership gaps into fake permission certainty.
6. Keep glossary-governed terminology.
7. Do NOT let UI-only visibility stand in for confirmed authorization rules.

---

## Procedure

### Phase 1 — Load canonical access context
Read FN, UC, BR, ARCH, EN, and domain vocabulary.

### Phase 2 — Identify access candidates
Extract:
- actors
- roles
- positions
- resources
- actions
- scope modifiers
- exceptions

### Phase 3 — Normalize ACL matrix
Build a stable matrix of who can do what and under which scope.

### Phase 4 — Write domain ACL docs
Create domain-oriented ACL documents where helpful.

### Phase 5 — Refresh matrix and report
Write matrix and report with open items.

---

## Idempotency

This agent must be safely re-runnable.

---

## Completion criteria

The run is complete when:

- a stable ACL matrix exists
- actor/resource/action/scope relationships are explicit
- unresolved access gaps are visible
- no unsupported permissions were invented

---

## Invocation

Typical invocation:

Run AR:ACLMatrixSynthesizer