# Business Rule Documentation Rules (BR)

> See also: cross-layer-discipline.md — shared discipline for all _ar/** canonical docs.

## Purpose

BR documents define rules that constrain system behavior across entities or use cases.

Typical uses:

- domain policies
- system governance rules
- cross-entity constraints

BR documents do not describe process flow.

---

## Naming

BR-<RuleName>

---

## Required Frontmatter

---
doc_id: BR-<RuleName>
title: <Rule Title>
canonical_layer: BR
spec_type: business-rule
status: draft | canonical
affects:
  - ENxxxx
  - UCxxxx
  - SYSTEM
---

Optional:

references:
  - ENxxxx
  - UCxxxx

---

## Document Structure

## Purpose  
## <Rule Section>

Additional rule sections may follow.

Optional:

## Non-Goals

---

## Rule Sections

Each section defines one group of constraints.

Normative language may be used:

- SHALL
- MUST
- SHALL NOT

Rules should be deterministic.

---

## Cross-references (reference, don't restate)

BR owns business rules, invariants, and domain policies. It references other layers by `doc_id`
and never restates their content:

- References: `ENxxxx`, `UCxxxx`.
- Never inline (cite instead): step-by-step flows (→ `UC`), screen logic (→ `WIRE`), entity attributes (→ `EN`).

See `cross-layer-discipline.md` for the full ownership table and the >50-character restatement rule.

---

## Restrictions

BR documents must not contain:

- step-by-step flows
- implementation details