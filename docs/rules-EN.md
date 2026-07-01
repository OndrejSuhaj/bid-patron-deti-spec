# Entity Documentation Rules (EN)

> See also: cross-layer-discipline.md — shared discipline for all _ar/** canonical docs.

## Purpose

EN documents describe domain entities and their lifecycle.

They define:

- entity meaning
- lifecycle states
- data model
- invariants

---

## Naming

ENxxxx – <Entity Name>

---

## Required Frontmatter

---
doc_id: ENxxxx
title: <Entity Name>
canonical_layer: EN
spec_type: entity
status: draft | canonical | active
---

---

## Recommended Structure

## Purpose  
## Lifecycle  
## State Transitions  
## Attributes
## Invariants  
## Relationships  

---

## Section Meaning

Purpose  
Short explanation of what the entity represents or More detailed explanation of the entity in the domain.

Lifecycle  
List of possible states of the entity.

State Transitions  
Valid transitions between states and their triggers.

Attributes  
Attributes belonging to the entity.

Invariants  
Conditions that must always hold true.

Relationships  
References to other entities.

---

## Cross-references (reference, don't restate)

EN owns entity semantics, lifecycle, attributes, invariants, and relationships. It references
other layers by `doc_id` and never restates their content:

- References: `BRxxxx` (rules constraining the entity), other `ENxxxx` (relationships).
- Never inline (cite instead): rule content (→ `BR`), use-case flows (→ `UC`), screen layout (→ `WIRE`/`IA`).

See `cross-layer-discipline.md` for the full ownership table and the >50-character restatement rule.

---

## Restrictions

EN documents must not contain:

- implementation logic
- API design
- database schema definitions