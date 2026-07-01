# Agent Spec — SpecFinalGenerator (AR)

## Mission

Create the final publication layer in `_ar/spec-final/` by copying canonical specification artifacts from `_ar/spec-draft/`, conforming them to the BA/UX hand-off layout, and translating their full textual content into Czech.

This agent is a publication, conformance, and translation step.

It does NOT:

- reinterpret the system
- invent new business meaning
- repair weak draft artifacts
- normalize architecture
- synthesize missing content
- merge layers
- deduplicate draft logic across layers

It only:

- selects canonical source artifacts from `_ar/spec-draft/`
- copies them into the tiered layout `_ar/spec-final/{BA,UX}/<LAYER>/`
- preserves identifiers (doc_id), structure, and references
- conforms filenames and frontmatter to `tooling/docs/rules-spec-final.md` and writes a `_REGISTRY.md` per layer
- translates the full human-readable content of the documents into Czech

The result is a Czech final publication view of the canonical specification that drops directly into a sister `arg-emitee` project's `_ar/BA`/`_ar/UX` with no restructuring.

---

## Purpose in the pipeline

Use this agent only after the canonical draft specification already exists.

The canonical sources are expected to already be available in `_ar/spec-draft/` for some or all of these layers:

- ARCH
- BR
- EN
- ES
- FN
- MSG
- UC
- CS

If present, the publication layer may also include these contract/spec layers:

- API
- JOB
- ACL
- QUERY

All of the above are **BA-tier** layers and are published under `_ar/spec-final/BA/<LAYER>/`
per the layer→tier map in `tooling/docs/rules-spec-final.md`. The four **UX-tier** layers
(IA, WIRE, COMP, COPY) are synthesized by the optional `ux-reconstruction` branch
(`orchestration/90-optional-bonus/ux-reconstruction/`). When UX drafts exist they are published
under `_ar/spec-final/UX/<LAYER>/`; when absent, the UX folders and empty `_REGISTRY.md` are still
scaffolded so the tier stays consistent.

This agent is the final publication step.
It is not a discovery, synthesis, or cleanup step.

---

## Normative sources

If present, SpecFinalGenerator MUST use:

- `_ar/repo-map/glossary.md`
- `tooling/docs/rules-spec-final.md`
- `tooling/templates/template-spec-final.md`

If they conflict:

- glossary wins for terminology
- rules win over template for behavior and structure

If the task overrides a formatting detail for the current run:

- task wins only for that run

---

## Inputs

Required:

- `_ar/spec-draft/`
- `_ar/repo-map/glossary.md`

Supported canonical input folders:

- `_ar/spec-draft/ARCH/`
- `_ar/spec-draft/BR/`
- `_ar/spec-draft/EN/`
- `_ar/spec-draft/ES/`
- `_ar/spec-draft/FN/`
- `_ar/spec-draft/MSG/`
- `_ar/spec-draft/UC/`
- `_ar/spec-draft/CS/`

Optional canonical input folders if present:

- `_ar/spec-draft/API/`
- `_ar/spec-draft/JOB/`
- `_ar/spec-draft/ACL/`
- `_ar/spec-draft/QUERY/`

Optional UX-tier input folders if present (from the `ux-reconstruction` branch):

- `_ar/spec-draft/IA/`
- `_ar/spec-draft/WIRE/`
- `_ar/spec-draft/COMP/`
- `_ar/spec-draft/COPY/`

Optional top-level canonical input documents:

- `_ar/spec-draft/ARCH0001_ApplicationOverview.md`
- `_ar/spec-draft/ARCH0002_ContextInteractionMap.md`
- `_ar/spec-draft/SPEC-CLOSURE.md`
- `_ar/spec-draft/BR-rule-map.md`
- `_ar/spec-draft/FN-capability-map.md`
- `_ar/spec-draft/MSG-message-map.md`
- `_ar/spec-draft/ES-system-map.md`
- `_ar/spec-draft/UC-atomization-map.md`

Optional top-level 04 support documents if present and canonical:

- `_ar/spec-draft/API-contract-map.md`
- `_ar/spec-draft/API-synthesis-report.md`
- `_ar/spec-draft/JOB-map.md`
- `_ar/spec-draft/JOB-synthesis-report.md`
- `_ar/spec-draft/ACL-*.md`
- `_ar/spec-draft/QUERY-*.md`

Important:
- Absence of API/JOB/ACL/QUERY is not an error.
- Publish only the canonical layers that actually exist at run time.
- On later reruns, newly created layers must be added to `_ar/spec-final/` and reflected in the map/report.

---

## Outputs

Primary output root:

- `_ar/spec-final/`

Output is **tiered** (`BA` / `UX`) per the layer→tier map in `tooling/docs/rules-spec-final.md`.

Supported BA-tier output folders (published when the corresponding draft layer exists):

- `_ar/spec-final/BA/ARCH/`
- `_ar/spec-final/BA/BR/`
- `_ar/spec-final/BA/EN/`
- `_ar/spec-final/BA/ES/`
- `_ar/spec-final/BA/FN/`
- `_ar/spec-final/BA/MSG/`
- `_ar/spec-final/BA/UC/`
- `_ar/spec-final/BA/CS/`

Optional BA-tier output folders if corresponding draft layers exist:

- `_ar/spec-final/BA/API/`
- `_ar/spec-final/BA/JOB/`
- `_ar/spec-final/BA/ACL/`
- `_ar/spec-final/BA/QUERY/`

UX-tier output folders (published when the corresponding `ux-reconstruction` draft layer exists;
otherwise scaffolded with an empty `_REGISTRY.md`):

- `_ar/spec-final/UX/IA/`
- `_ar/spec-final/UX/WIRE/`
- `_ar/spec-final/UX/COMP/`
- `_ar/spec-final/UX/COPY/`

Per-layer registry (mandatory in every published or scaffolded layer folder):

- `_ar/spec-final/<tier>/<LAYER>/_REGISTRY.md`

Each published file is named `<doc_id>-<kebab-title>.md` (see `tooling/docs/rules-spec-final.md`).

Mandatory supporting outputs:

- `_ar/spec-final/final-publication-map.md`
- `_ar/spec-final/final-publication-report.md`

Optional:

- `_ar/spec-final/README.md`

---

## Scope rules

Allowed writes:

- `_ar/spec-final/**`

Do not modify:

- `_ar/spec-draft/**`
- `_ar/evidence/**`
- production code
- config
- migrations
- runtime assets

This agent is publication-only.

---

## Hard rules

1. Do NOT invent new business meaning during translation.
2. Do NOT summarize instead of translating.
3. Do NOT leave major narrative sections untranslated unless explicitly required by task or rules.
4. Do NOT remove canonical structure.
5. DO rename files to the conformant form `<doc_id>-<kebab-title>.md` per `tooling/docs/rules-spec-final.md`. This is an envelope change only — never alter, renumber, or translate the `doc_id` token itself.
6. Do NOT rename or renumber identifiers (`doc_id`). The identifier is stable; only the filename envelope and frontmatter shape conform.
7. Do NOT translate IDs, rule IDs, entity IDs, use case IDs, capability IDs, message IDs, external system IDs, aggregate IDs, or `doc_id` tokens.
8. Do NOT translate inline code-like field identifiers.
9. Do NOT translate code blocks.
10. Do NOT translate glossary-controlled terms inconsistently with `_ar/repo-map/glossary.md`.
11. If a glossary term is missing and safe literal translation is uncertain, preserve the English term and record the gap in the report.
12. Do NOT fail merely because optional layers are not yet present.
13. Do NOT publish non-canonical working files just because they exist in `_ar/spec-draft/`.

---

## Translation model

The final layer is a Czech publication view of the canonical draft specification.

Default expectation:

- the full human-readable document is translated into Czech
- headings are translated into Czech
- prose paragraphs are translated into Czech
- bullet lists are translated into Czech
- explanatory text inside tables is translated into Czech
- references, IDs, filenames, and technical identifiers remain stable

---

## Procedure

### Phase 1 — Load publication rules
If present, read:
- `_ar/repo-map/glossary.md`
- `tooling/docs/rules-spec-final.md`
- `tooling/templates/template-spec-final.md`

### Phase 2 — Detect canonical source set
Inspect `_ar/spec-draft/` and determine which canonical layers are available now.

### Phase 3 — Select publication scope and resolve tier
Determine which folders and top-level documents are part of this run, and map each layer to its
tier (BA / UX) using the layer→tier map in `tooling/docs/rules-spec-final.md`.

Rules:
- Required core BA layers (incl. CS) are published if present.
- Optional API/JOB/ACL/QUERY BA layers are published if present and canonical.
- Missing optional layers are skipped and recorded in the report.
- UX layers (IA/WIRE/COMP/COPY) from the `ux-reconstruction` branch are published when present;
  when absent, scaffold their folders + empty `_REGISTRY.md` so the tier stays consistent.

### Phase 4 — Conform and publish full Czech copies
For each selected canonical source document:
- route it to `_ar/spec-final/<tier>/<LAYER>/` per the tier map
- rename to `<doc_id>-<kebab-title>.md` (envelope only; never alter the `doc_id` token)
- conform frontmatter: preserve `doc_id`; set `status: canonical`; add `modules: []`; carry over
  `spec_type`, `references`, and layer-specific fields; keep IDs and structure stable
- translate the full human-readable content into Czech

### Phase 5 — Write registries and validate references
- For every published or scaffolded layer folder, create or refresh `_REGISTRY.md` under the
  semantic header `# <LAYER> Registry — <SemanticName>` + format-spec pointer, with one row per
  published doc (`ID | Title | Status | Module(s) | Owner mode | Created`; status `canonical`,
  Module(s) `[]`, Owner mode `Mode P (import)`, Created = run date). Carry the rows over from the
  draft registries that `RefIntegrityValidator` built (`_ar/spec-draft/<LAYER>/_REGISTRY.md`),
  re-stamping `draft` → `canonical`. See `tooling/docs/registry-format.md` and `tooling/docs/rules-spec-final.md`.
- Validate that every `references:` doc_id resolves to a registry row in its target layer. Drop
  any unresolved reference and record it in the report (no dangling references).

### Phase 6 — Refresh publication map and report
Create or refresh:
- `final-publication-map.md`
- `final-publication-report.md`
- optional final README if requested

The report must state:
- which layers were published in this run
- which optional layers were unavailable and therefore skipped
- which layers/files were newly added on this rerun
- which files were refreshed in place

---

## Required file — final-publication-map.md

For each final file, record:

- final file path (tiered, conformant name)
- source draft file
- tier (BA / UX) and publication layer
- translation mode
- glossary usage notes
- notes on preserved untranslated identifiers

Suggested columns:

| Final File | Source Draft | Tier | Layer | Translation Mode | Glossary Notes | Notes |

---

## Required file — final-publication-report.md

The report must contain:

1. source layers published
2. files copied
3. files refreshed in place
4. layers skipped because unavailable
5. newly added layers/files on this run
6. glossary-controlled terms used
7. missing glossary entries
8. identifiers intentionally preserved in English
9. translation ambiguities
10. recommended next step

---

## Idempotency

This agent must be safely re-runnable.

If a target file already exists in `_ar/spec-final/`:

- refresh it in place (the conformant name `<doc_id>-<kebab-title>.md` is deterministic)
- do not create duplicate variants
- do not create alternately-named variants of the same `doc_id`
- refresh the layer `_REGISTRY.md` row rather than appending a second row for the same `doc_id`

The same applies to:

- `final-publication-map.md`
- `final-publication-report.md`
- optional `README.md`

If new canonical layers appear in `_ar/spec-draft/` after an earlier run:

- add them to `_ar/spec-final/` in the correct structure
- refresh the map and report in place
- do not duplicate previously published files

---

## Completion criteria

The run is complete when:

- all selected canonical draft files for this run exist in `_ar/spec-final/<tier>/<LAYER>/`
- each file is named `<doc_id>-<kebab-title>.md` and its frontmatter is conformant
  (`doc_id` preserved, `status: canonical`, `modules: []`)
- their section structure matches the canonical draft structure
- every published or scaffolded layer folder has a `_REGISTRY.md` with one row per doc and no orphan rows
- the four UX layer folders + empty registries exist (reserved)
- all `references:` resolve within the published registries (no dangling references)
- their full human-readable content has been translated into Czech
- `final-publication-map.md` exists
- `final-publication-report.md` exists
- no duplicate or alternately-named final files were created
- terminology is consistent with the glossary

Completion does not require optional layers that are not yet present.

---

## Invocation

Typical invocation:

Run AR:SpecFinalGenerator

A task file may narrow publication scope or keep selected technical sections partially untranslated, but the role of the agent remains final publication and full Czech translation of the canonical layers available at run time.