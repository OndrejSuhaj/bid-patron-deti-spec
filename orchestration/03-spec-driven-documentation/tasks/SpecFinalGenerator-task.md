# Task — SpecFinalGenerator

Run AR:SpecFinalGenerator

Load and strictly follow:

tooling/orchestration/03-spec-driven-documentation/agents/SpecFinalGenerator.md

Write ONLY to:

- `_ar/spec-final/**`

Do not modify `_ar/spec-draft/**`.

---

## Pre-check

Confirm reading of:

- `_ar/repo-map/glossary.md`
- `_ar/spec-draft/ARCH/` if present
- `_ar/spec-draft/BR/` if present
- `_ar/spec-draft/EN/` if present
- `_ar/spec-draft/ES/` if present
- `_ar/spec-draft/FN/` if present
- `_ar/spec-draft/MSG/` if present
- `_ar/spec-draft/UC/` if present
- `_ar/spec-draft/CS/` if present
- `_ar/spec-draft/API/` if present
- `_ar/spec-draft/JOB/` if present
- `_ar/spec-draft/ACL/` if present
- `_ar/spec-draft/QUERY/` if present
- `_ar/spec-draft/IA/`, `_ar/spec-draft/WIRE/`, `_ar/spec-draft/COMP/`, `_ar/spec-draft/COPY/` if present (UX)
- `tooling/docs/rules-spec-final.md` if present
- `tooling/templates/template-spec-final.md` if present

Optional top-level canonical documents may be included if present and relevant:
- `_ar/spec-draft/ARCH0001_ApplicationOverview.md`
- `_ar/spec-draft/ARCH0002_ContextInteractionMap.md`
- `_ar/spec-draft/SPEC-CLOSURE.md`
- `_ar/spec-draft/API-contract-map.md`
- `_ar/spec-draft/API-synthesis-report.md`
- `_ar/spec-draft/JOB-map.md`
- `_ar/spec-draft/JOB-synthesis-report.md`
- `_ar/spec-draft/ACL-*.md`
- `_ar/spec-draft/QUERY-*.md`

---

## Deliverables

Tiered output per the layer→tier map in `tooling/docs/rules-spec-final.md`.

Create or refresh core BA-tier folders when the corresponding draft layers exist:

- `_ar/spec-final/BA/ARCH/**`
- `_ar/spec-final/BA/BR/**`
- `_ar/spec-final/BA/EN/**`
- `_ar/spec-final/BA/ES/**`
- `_ar/spec-final/BA/FN/**`
- `_ar/spec-final/BA/MSG/**`
- `_ar/spec-final/BA/UC/**`
- `_ar/spec-final/BA/CS/**`

Also create or refresh optional BA-tier folders when the corresponding draft layers exist:

- `_ar/spec-final/BA/API/**`
- `_ar/spec-final/BA/JOB/**`
- `_ar/spec-final/BA/ACL/**`
- `_ar/spec-final/BA/QUERY/**`

Create or refresh UX-tier folders when the corresponding `ux-reconstruction` draft layer exists;
otherwise scaffold the folder with an empty `_REGISTRY.md`:

- `_ar/spec-final/UX/IA/**`
- `_ar/spec-final/UX/WIRE/**`
- `_ar/spec-final/UX/COMP/**`
- `_ar/spec-final/UX/COPY/**`

Each published layer folder gets a `_REGISTRY.md`; each file is named `<doc_id>-<kebab-title>.md`.

Also create or refresh:

- `_ar/spec-final/final-publication-map.md`
- `_ar/spec-final/final-publication-report.md`

Optional:

- `_ar/spec-final/README.md`

---

## Rules

- Conform filenames to `<doc_id>-<kebab-title>.md` and frontmatter to the BA/UX schema per `tooling/docs/rules-spec-final.md`; preserve `doc_id` tokens, structure, and references.
- Route each layer to its tier (BA / UX) and write a `_REGISTRY.md` per layer; validate references (no dangling).
- Translate the full human-readable content into Czech.
- Keep IDs, `doc_id` tokens, inline field names, code blocks, and other technical tokens stable.
- Use `_ar/repo-map/glossary.md` as the authoritative terminology source.
- If API/JOB/ACL/QUERY layers are not yet present, skip them without error and record that in the report.
- If API/JOB/ACL/QUERY layers are present on a later rerun, publish them and refresh the map/report in place.
- Do not publish non-canonical working artifacts.