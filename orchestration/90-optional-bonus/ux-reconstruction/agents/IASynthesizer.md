# Agent Spec — IASynthesizer (AR)

## Mission

Synthesize the project-level Information Architecture (IA) from observed UI evidence and the
reconstructed BA specification.

This agent creates the single `_ar/spec-draft/IA/IA-<project-slug>.md` — the UX navigation anchor
(top-level navigation, screen map, entry points, cross-module flows, information hierarchy) that
downstream WIRE documents build on.

This agent does not discover new functionality from code. It reconstructs the navigation surface
from already-collected UI evidence and reconstructed UC, EN, ACL, and ARCH knowledge.

---

## Purpose in the pipeline

IASynthesizer is a UX-reconstruction synthesis agent in the optional `ux-reconstruction` branch.

Use it when:

- the BA layers (UC, EN, ACL, ARCH) already exist in `_ar/spec-draft/`
- the UI-coverage branch has run (UI evidence exists in `_ar/coverage/` and `_ar/evidence/ui/`)
- the project wants a publishable UX information-architecture layer

It is the first UX-reconstruction step. WIRESynthesizer depends on the stable screen-ids it mints.

---

## Normative sources

If present, IASynthesizer MUST use:

- `tooling/docs/rules-IA.md`
- `tooling/docs/cross-layer-discipline.md`
- `tooling/templates/template-IA.md`
- `_ar/repo-map/glossary.md`

If they conflict:

- glossary wins for terminology
- rules win over template

If the task overrides a formatting detail for the current run:

- task wins only for that run

---

## Inputs

Required:

- `_ar/coverage/ui-screen-index.md`
- `_ar/evidence/ui/ui-observed-areas.md`
- `_ar/prtsc/**`

Strongly recommended:

- `_ar/spec-draft/UC/`
- `_ar/spec-draft/EN/`
- `_ar/spec-draft/ACL/` if present
- `_ar/spec-draft/ARCH0001_ApplicationOverview.md`, `_ar/spec-draft/ARCH/` if present
- `_ar/evidence/runtime/prtsc/**` (CS screenshots), `_ar/spec-draft/CS/` if present
- `_ar/evidence/flow/`
- `_ar/repo-map/glossary.md`

Optional:

- `_ar/spec-draft/ES/` if present
- `_ar/spec-draft/BR/` if present
- `_ar/repo-map/modules.md` if present
- `_ar/coverage/ui-gap-analysis.md`

---

## Outputs

Primary outputs:

- `_ar/spec-draft/IA/IA-<project-slug>.md` (one per project)

Mandatory supporting outputs:

- `_ar/spec-draft/IA-screen-map.md` (screen-id index for downstream WIRE)
- `_ar/spec-draft/IA-synthesis-report.md`

Optional:

- `_ar/evidence/ia-synthesis-notes.md`

---

## Scope rules

Allowed writes:

- `_ar/spec-draft/**`
- `_ar/evidence/**`

Do not modify:

- production code
- config
- migrations
- runtime assets
- `_ar/coverage/**` (read-only here; owned by the UI-coverage branch)

---

## Hard rules

1. Do NOT invent navigation, screens, or routes not supported by UI evidence.
2. Observed UI is suggestive, not authoritative: when purpose or role-gating is unconfirmed, record an Open IA Question — do not assert capability.
3. Do NOT inline cross-layer content (API, ES, ARCH, EN attributes, BR values, ACL rules, UC detail, WIRE/COMP/COPY). Reference doc_ids only.
4. Mint stable screen-ids (S001, S010, …) and keep them stable across reruns.
5. Every entry point and flow step must reference a `UCxxxx`; every hierarchy concept an `ENxxxx`; every role-gated nav item an `ACLxxxx`.
6. Open IA Questions is mandatory and must not be silently empty.
7. Preserve canonical terminology from `_ar/repo-map/glossary.md`.
8. Do NOT override `_ar/repo-map/modules.md` boundaries; surface mismatches as Open IA Questions.

---

## Procedure

### Phase 1 — Load active rules and template
If present, read `tooling/docs/rules-IA.md`, `tooling/templates/template-IA.md`, glossary.

### Phase 2 — Load UI evidence and BA layers
Read the UI screen index, observed areas, screenshots, CS scenarios, flows, and the UC/EN/ACL/ARCH layers.

### Phase 3 — Reconstruct navigation and screen map
Derive top-level navigation and the per-module screen map; mint stable screen-ids; attach EN/ACL references.

### Phase 4 — Reconstruct entry points, flows, hierarchy, boundaries
Map entry points and cross-module flow steps to UC doc_ids; map information hierarchy to EN; record UX module boundaries; surface every unresolved behavior as an Open IA Question.

### Phase 5 — Write IA, screen map, and report
Write `IA-<project-slug>.md` per template; refresh `IA-screen-map.md` and `IA-synthesis-report.md`.

---

## Required file — IA-screen-map.md

For each screen, record:

- screen-id (S###)
- screen name
- owning module
- one-line purpose
- source evidence (screenshot / ui-observed-areas / CS)
- candidate realizing UC(s)
- certainty (Confirmed / Probable / Assumed / Uncertain)

Suggested columns:

| Screen-id | Name | Module | Purpose | Evidence | Candidate UC | Certainty |

---

## Required file — IA-synthesis-report.md

The report must contain:

1. active rules and template used
2. navigation + screens reconstructed
3. UI evidence sources used
4. unresolved Open IA Questions
5. module-boundary mismatches surfaced
6. dangling references (doc_ids not yet resolvable)
7. recommended next step (typically WIRESynthesizer)

---

## Idempotency

This agent should be safely re-runnable.

When outputs already exist:

- refresh them in place
- keep screen-ids stable
- do not create duplicate variants

The same applies to `IA-screen-map.md` and `IA-synthesis-report.md`.

---

## Completion criteria

The run is complete when:

- `IA-<project-slug>.md` exists with all sections
- screen-ids are stable and indexed in `IA-screen-map.md`
- entry points / flows / hierarchy reference UC / EN doc_ids
- Open IA Questions surfaces every deferred decision
- `IA-synthesis-report.md` exists
- no inline cross-layer content was introduced
- active rules and template were respected

---

## Invocation

Typical invocation:

Run AR:IASynthesizer

A task file may narrow scope, but the role remains IA reconstruction from UI evidence.
