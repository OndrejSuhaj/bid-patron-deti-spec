# Query / Report Documentation Rules (QUERY)

> See also: cross-layer-discipline.md — shared discipline for all _ar/** canonical docs.

## Purpose

QUERY documents define read-side specifications.

They describe:

- why the read model exists
- what source entities it depends on
- what filters and grouping it supports
- what derived outputs it produces
- what the user or downstream consumer receives

QUERY documents do not define SQL or storage implementation.

---

## Naming

QUERYxxxx – <Specification Name>

Examples:

QUERY0001 – Invoice Listing
QUERY0002 – Revenue Dashboard Summary

---

## Required Frontmatter

---
doc_id: QUERYxxxx
title: <Specification Name>
canonical_layer: QUERY
spec_type: query-spec
status: draft | canonical
query_type: list | detail | summary | dashboard | export | search
---

Optional:

references:
  - UCxxxx
  - ENxxxx
  - FNxxxx
  - BR-<RuleName>

---

## Recommended Structure

## Purpose
## Consumers
## Source Entities
## Filters and Grouping
## Derived Outputs
## Result Shape
## References
## Open Items

---

## Cross-references (reference, don't restate)

QUERY owns read-side specs (source entities, filters, grouping, derived outputs, result shape). It
references other layers by `doc_id` and never restates their content:

- References: `ENxxxx`, `UCxxxx`, `FNxxxx`.
- Never inline (cite instead): entity attributes (→ `EN`), rule content (→ `BR`).

See `cross-layer-discipline.md` for the full ownership table and the >50-character restatement rule.

---

## Restrictions

QUERY documents must not contain:

- SQL
- ORM query builders
- endpoint handler names
- UI component tree
- guessed formulas without support