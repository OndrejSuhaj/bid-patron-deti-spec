# Functional Capability Documentation Rules (FN)

> See also: cross-layer-discipline.md — shared discipline for all _ar/** canonical docs.

## Purpose

FN documents describe internal system capabilities that support use cases.

Examples:

- payment matching
- authorization model
- event infrastructure
- email delivery

FN documents describe system capabilities, not workflows.

---

## Naming

FNxxxx – <Capability Name>

---

## Required Frontmatter

---
doc_id: FNxxxx
title: <Capability Name>
canonical_layer: FN
spec_type: functional-capability
status: draft | canonical
---

Optional:

references:
  - UCxxxx
  - ENxxxx
  - ESxxxx

---

## Recommended Structure

## Purpose  
## Responsibilities  
## Related Use Cases  
## Related Entities  
## Integrations  
## Constraints  

---

## Cross-references (reference, don't restate)

FN owns internal functional capabilities and responsibilities. It references other layers by
`doc_id` and never restates their content:

- References: `UCxxxx`, `ENxxxx`, `ESxxxx`, `MSGxxxx`.
- Never inline (cite instead): rule content (→ `BR`), entity attributes (→ `EN`), flows (→ `UC`).

See `cross-layer-discipline.md` for the full ownership table and the >50-character restatement rule.

---

## Restrictions

FN documents must not contain:

- implementation code
- framework configuration