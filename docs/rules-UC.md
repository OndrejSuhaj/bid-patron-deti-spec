# Use Case Documentation Rules (UC)

> See also: cross-layer-discipline.md — shared discipline for all _ar/** canonical docs.

## Purpose

UC documents describe system behavior triggered by actors.

They define:

- interactions with the system
- system responses
- lifecycle changes of entities

---

## Naming

UCxxxx – <Actor> <Verb> <Object>

Examples:

UC0001 – Issuer creates bond issue draft  
UC0009 – Investor initiates subscription

---

## Required Structure

## Trigger  
## Preconditions  
## Main Flow  
## Alternative Flows  
## Postconditions  
## Affected Entities  
## Evidence level

---

## Evidence level labels

The Evidence level section records author confidence that the flow reflects the intended system behavior. Use exactly one label from the closed set:

- **Confirmed** — flow is fully specified from authoritative sources; no material gap.
- **Partial** — core flow is specified; one or more alternative flows, edge cases, or postconditions are inferred and not fully evidenced.
- **Uncertain** — at least one main-flow step rests on inference; sources conflict or are silent.
- **Blocked** — the flow cannot be completed without an external decision (open question, missing authority, pending integration confirmation).

One line, label first, optional short justification. Example:

`**Confirmed** — full flow evidenced end-to-end.`

---

## Rules

Main Flow must be numbered.

Lifecycle changes must be explicitly stated.

Example:

System changes Bond Issue state Draft → Locked.

---

## Alternative Flow Format

Alternative flow identifiers follow:

<step-number><letter>

Example:

3A – Validation fails

---

## Cross-references (reference, don't restate)

UC owns use-case behavior, numbered flows, triggers, and pre/postconditions. It references other
layers by `doc_id` and never restates their content:

- References: `ENxxxx`, `BRxxxx`, `ACLxxxx`, `APIxxxx`, `ESxxxx`, `JOBxxxx`.
- Never inline (cite instead): entity attributes (→ `EN`), rule content (→ `BR`), contracts (→ `API`), screen layout (→ `WIRE`/`IA`).

See `cross-layer-discipline.md` for the full ownership table and the >50-character restatement rule.

---

## Restrictions

UC documents must not contain:

- implementation logic
- API endpoints
- controller names