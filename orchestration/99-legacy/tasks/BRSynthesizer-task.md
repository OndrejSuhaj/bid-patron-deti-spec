# Task — BRSynthesizer

Create a new high-level business architecture layer in:

`_ar/spec-draft/BR/`

The goal is to summarize the most important already-known architectural truths of the system.

This layer should provide orientation and navigation before readers dive into detailed entity or use case documentation.

---

## Constraints

- Do not invent new system knowledge.
- Only synthesize facts already present in reconstructed artifacts.
- Do not modify any existing files.
- Only write into `_ar/spec-draft/BR/`.

---

## Mandatory files

Create the following files:


BR0000_Index.md
BR0001_DomainMap.md
BR0002_CoreConcepts.md
BR0003_ExternalIntegrations.md


Additionally create one document per detected system domain.

---

## Domain detection

Domains must be derived from evidence such as:

- entity clusters
- flow clusters
- repository modules
- architecture documentation
- recurring terminology

Prefer fewer strong domains rather than many weak ones.

---

## Content expectations

Each domain document should explain:

- the purpose of the domain
- its boundaries
- its main responsibilities
- its main entities
- its major use cases
- relevant flows
- relevant integrations
- recommended deeper reading

---

## Cross-referencing

BR documents should reference deeper artifacts such as:

- EN files
- UC files
- FLOW files
- ARCH files
- repository modules

References should help the reader navigate toward detailed documentation.

---

## Success criteria

The task is complete when:

- the BR directory exists
- all mandatory BR files exist
- domain documents were created
- the BR layer provides clear navigation into the rest of the documentation
- no unsupported system claims were introduced