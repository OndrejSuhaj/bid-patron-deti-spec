# Access Control Documentation Rules (ACL)

> See also: cross-layer-discipline.md — shared discipline for all _ar/** canonical docs.

## Purpose

ACL documents define who can do what on which resource and under what scope.

They describe:

- actors and roles
- resources
- actions
- scope constraints
- inheritance or exception notes

ACL documents do not describe UI layout or auth provider implementation.

---

## Naming

ACLxxxx – <Domain Name>

Examples:

ACL0001 – Invoicing Access
ACL0002 – Company Administration Access

---

## Required Frontmatter

---
doc_id: ACLxxxx
title: <Domain Name>
canonical_layer: ACL
spec_type: access-control
status: draft | canonical
---

Optional:

references:
  - UCxxxx
  - FNxxxx
  - ENxxxx
  - BR-<RuleName>

---

## Recommended Structure

## Purpose
## Actor Model
## Resources
## Matrix
## Exceptions
## References
## Open Items

---

## Matrix Expectations

Minimum columns:

- Actor / Role
- Resource
- Action
- Scope
- Notes

---

## Cross-references (reference, don't restate)

ACL owns the actor/role × resource × action × scope model and inheritance. It references other
layers by `doc_id` and never restates their content:

- References: `ENxxxx`, `UCxxxx`.
- Never inline (cite instead): entity attributes (→ `EN`), rule content (→ `BR`).

See `cross-layer-discipline.md` for the full ownership table and the >50-character restatement rule.

---

## Restrictions

ACL documents must not contain:

- identity provider configuration
- framework guards
- middleware names
- route middleware chains
- UI-only assumptions presented as confirmed grants