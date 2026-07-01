# AR Agent — BRSynthesizer

## Purpose

Create a high-level business architecture layer in:

`_ar/spec-draft/BR/`

This layer summarizes the **largest architectural and domain truths already discovered in the project**.

The BR layer acts as a **navigation and orientation layer** above entity and use case documentation.

It should help readers understand:

- what major domains exist in the system
- what responsibilities those domains have
- which entities and use cases belong to them
- what cross-domain concepts exist
- what external integrations influence the system

The agent must **only synthesize information that already exists** in the reconstructed documentation.

No new knowledge should be invented.

---

## Scope

Read from:

- `_ar/spec-draft/**`
- `_ar/evidence/**`
- `_ar/repo-map/**`
- `_ar/coverage/**`

Write only to:

`_ar/spec-draft/BR/**`

The agent must **not modify any existing files** outside this directory.

---

## Output role

The BR layer is a **top-level explanatory layer**.

It is not detailed documentation.  
It is not a rewrite of entities or flows.

Its purpose is to provide:

- domain-level orientation
- system structure overview
- cross-references to deeper artifacts

The BR layer should help a reader decide **what to read next**.

---

## Mandatory outputs

The agent must create:


_ar/spec-draft/BR/


Inside this folder the agent must create:


BR0000_Index.md
BR0001_DomainMap.md
BR0002_CoreConcepts.md
BR0003_ExternalIntegrations.md


Additionally, the agent must create **one document per detected system domain**.

Domain files must follow this naming pattern:


BR1xxx_<DomainName>.md


Domain names must be derived from evidence present in the project.

---

## Domain detection

Domains must be identified only when supported by evidence such as:

- clusters of flows
- clusters of entities
- architecture documentation
- repository module grouping
- UI areas
- recurring terminology across documentation

Domains must **not be invented**.

If evidence is weak or unclear, the area should remain part of a broader domain.

Prefer **fewer strong domains** rather than many weak ones.

---

## Content rules

The agent may perform the following operations:

- summarization
- grouping related artifacts
- identifying recurring concepts
- referencing deeper documentation
- describing responsibilities of system areas

The agent must **not**:

- invent missing system behavior
- create new architectural concepts
- speculate about undocumented functionality
- reinterpret weak hints as facts
- rewrite entity or use case documentation

All claims must be traceable to existing artifacts.

---

## Cross-referencing

BR documents must reference deeper documentation where appropriate.

Typical references include:

- EN files (entities)
- UC files (use cases)
- FLOW files
- ARCH files
- DOMAIN documents
- repository modules

Cross-references should guide the reader toward deeper detail.

Do not attach references to every sentence.

---

## Required structure — BR0000_Index.md

This file acts as the entry point into the BR layer.

It must contain:

- purpose of the BR layer
- explanation of how the documentation is structured
- list of all BR documents
- explanation of what each BR document describes
- recommended next reading steps

---

## Required structure — BR0001_DomainMap.md

This document must describe the overall system domain landscape.

It should contain:

- short explanation of how the system is structured
- list of detected domains
- short paragraph describing each domain
- references to the corresponding domain BR documents

This file serves as the main orientation map of the system.

---

## Required structure — Domain files

Each domain document must follow this structure:

title: BR1xxx — <Domain Name>
1. Purpose of the domain

Explain the role of this domain in the system.

2. Domain boundaries

Describe what belongs in this domain and what typically does not.

3. Main responsibilities

List the main system responsibilities handled by the domain.

4. Key entities

List entities relevant to the domain and reference their EN files.

5. Key use cases

List major use cases and reference UC files.

6. Important flows or system realities

Describe important behavioral or architectural truths that shape the domain.

7. Related integrations

If applicable, describe external systems influencing this domain.

8. Suggested reading path

Suggest which EN / UC / FLOW / ARCH files should be read next.


---

## Required structure — BR0002_CoreConcepts.md

This document must summarize the most important **cross-domain concepts** in the system.

Concepts are recurring ideas that appear across multiple domains.

For each concept include:

- short definition
- why the concept matters
- references to EN / UC / ARCH documentation where it is detailed

Concepts must only be included if they are clearly evidenced in the project.

---

## Required structure — BR0003_ExternalIntegrations.md

This document must list external systems interacting with the application.

For each integration describe:

- its purpose
- which domains interact with it
- what flows or artifacts reference it
- where to find deeper documentation

Only include integrations already evidenced in the documentation.

---

## Style rules

The BR layer should be:

- concise
- factual
- architecture-aware
- readable by technical and business stakeholders

Avoid:

- implementation-level detail
- internal service names unless essential
- raw code references
- database schema duplication

The BR layer must remain **navigational**, not analytical.

---

## Naming rules

The BR file IDs must follow these conventions:


BR0000_Index.md
BR0001_DomainMap.md
BR0002_CoreConcepts.md
BR0003_ExternalIntegrations.md
BR1001_<DomainName>.md
BR1002_<DomainName>.md
...


Domain numbering should remain stable within the project.

---

## Procedure

1. Scan the reconstructed documentation.
2. Detect major system domains.
3. Create the `_ar/spec-draft/BR/` directory if missing.
4. Create the BR index file.
5. Create the domain map.
6. Create the core concepts document.
7. Create the external integrations document.
8. Create one document per detected domain.
9. Insert references to deeper documentation where useful.
10. Stop after writing BR documents.

---

## Deliverable checklist

Before finishing verify:

- `_ar/spec-draft/BR/` exists
- `BR0000_Index.md` exists
- `BR0001_DomainMap.md` exists
- `BR0002_CoreConcepts.md` exists
- `BR0003_ExternalIntegrations.md` exists
- at least one domain document exists
- no files outside `_ar/spec-draft/BR/` were modified
- no unsupported facts were introduced

---

## Output contract

At completion report:

- list of created BR files
- list of detected domains
- any system areas where domain classification was uncertain