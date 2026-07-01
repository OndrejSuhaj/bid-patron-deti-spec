# Information Architecture Documentation Rules (IA)

> See also: cross-layer-discipline.md — shared discipline for all _ar/** canonical docs.

## Purpose

IA documents reconstruct the project-level information architecture from observed UI evidence:
top-level navigation, the screen map, entry points, cross-module flows, and information
hierarchy. There is **one IA document per project**.

IA describes the UX navigation surface — *what screens exist and how a user moves between them* —
not screen layout, component contracts, text, or backend behavior. It is the program-level UX
anchor that downstream WIRE documents build on (each WIRE binds to an IA screen-id).

---

## Naming

`IA-<project-slug>` (one per project; no numeric id)

File naming: `IA-<project-slug>.md`

---

## Required Frontmatter

```yaml
---
doc_id: IA-<project-slug>
title: Information Architecture — <Project Name>
canonical_layer: IA
spec_type: information-architecture
scope: program
modules: []
status: draft | canonical
owners: [ux-lead, architect]
language: cs | en
references:
  # referenced canonical doc_ids (verify each resolves before authoring):
  # - ARCHxxxx, ENxxxx, BRxxxx, UCxxxx, ACLxxxx, ESxxxx
---
```

`modules: []` marks program-wide scope (IA is one-per-project). AR reconstruction has no module
decomposition; arg-emitee Mode M re-scopes after hand-off.

---

## Recommended Structure

1. Sources / Authority
2. Top-Level Navigation
3. Screen Map (stable `S###` screen-ids, per module subsection)
4. Entry Points (each → `UCxxxx`)
5. Cross-Module Flows (each step → `UCxxxx`)
6. Information Hierarchy (each level → `ENxxxx`)
7. Module Boundaries (UX layer)
8. Open IA Questions **(mandatory)**
9. What this IA does NOT cover

Assign **stable screen-ids** (`S001`, `S010`, …) in the Screen Map; WIRE documents reference
them via `screen_id`. Keep ids stable across reruns.

---

## Cross-references (reference, don't restate)

- Every entry point and every cross-module flow step references a `UCxxxx` doc_id.
- Every information-hierarchy concept references an `ENxxxx` doc_id (never enumerate attributes).
- Every role-gated nav item references an `ACLxxxx` doc_id.
- Every architectural assertion references `ARCHxxxx` or `ESxxxx`.

Cited doc_ids must resolve in their layer before IA is considered complete.

---

## Restrictions (NOT-FOR)

IA must NOT contain inline:

- API contracts / endpoints → `API`
- external-system integration detail, provider names → `ES`
- technology stack, libraries, UI kits → `ARCH`
- entity attributes / invariants / lifecycle → `EN`
- business rules or configuration values → `BR`
- access-control rules → `ACL`
- detailed use-case flows → `UC`
- per-screen layout, components, copy → `WIRE` / `COMP` / `COPY`

---

## Evidence convention (reconstruction)

IA is reconstructed from observed UI evidence, not designed greenfield:

- Primary evidence: `_ar/coverage/ui-screen-index.md`, `_ar/evidence/ui/ui-observed-areas.md`,
  `_ar/prtsc/**`, CS scenarios, `_ar/evidence/flow/**`.
- Observed UI is **suggestive, not authoritative**: when a screen/route is visible but its
  purpose or role-gating is unconfirmed in evidence, record it as an Open IA Question — do not
  invent navigation or capabilities.
- Empty Open IA Questions = suspicion of silently-decided assumptions; re-review claims. The
  section is complete when every deferred decision is listed with a named decider and a
  resolution status (open / resolved).
- Use `_ar/repo-map/glossary.md` for terminology.
