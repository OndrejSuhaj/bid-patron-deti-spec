# External System Documentation Rules (ES)

> See also: cross-layer-discipline.md — shared discipline for all _ar/** canonical docs.

## Purpose

ES documents describe external systems that interact with the platform.

They define:

- the role of the external system
- integration context
- interaction boundaries

They do not define business behavior.

---

## Naming

ESxxxx – <External System Name>

Examples:

ES0001 – Auth0  
ES0002 – DigiSign

---

## Required Frontmatter

---
doc_id: ESxxxx
title: <External System Name>
canonical_layer: ES
spec_type: external-system
status: draft | canonical
---

Optional:

references:
  - UCxxxx
  - FNxxxx

---

## Recommended Structure

## Purpose  
## System Overview  
## Integration Model  
## Data Exchange  
## Constraints  

---

## Cross-references (reference, don't restate)

ES owns external-system integration boundaries and data exchange. It references other layers by
`doc_id` and never restates their content:

- References: `ARCHxxxx` (context).
- Never inline (cite instead): entity attributes (→ `EN`), contract payloads (→ `API`), rule content (→ `BR`).

See `cross-layer-discipline.md` for the full ownership table and the >50-character restatement rule.

---

## Restrictions

ES documents must not contain:

- implementation code
- API payload definitions