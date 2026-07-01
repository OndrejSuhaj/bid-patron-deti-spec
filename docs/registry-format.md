# `_REGISTRY.md` Format (AR)

## Purpose

Single source of truth for the `_REGISTRY.md` format used in both the draft phase
(`_ar/spec-draft/<LAYER>/_REGISTRY.md`, built and validated by `RefIntegrityValidator`) and the
publication phase (`_ar/spec-final/<tier>/<LAYER>/_REGISTRY.md`, written by `SpecFinalGenerator`).

A registry is the authoritative list of which `doc_id`s exist in a layer. It is what makes
referential integrity checkable: every `references:` (and `affects` / `realizes_uc` / `trigger`)
must resolve to a registry row. `docs/rules-spec-final.md` references this document for the format;
it does not restate it.

---

## Schema

Each `_REGISTRY.md` is a markdown file with:

1. **Header** — a semantic layer identifier line
2. **Format-spec pointer** — one line pointing here
3. **Registry table** — one row per `doc_id`

```markdown
# EN Registry — Entity

`_ar/spec-draft/EN/_REGISTRY.md` — see tooling/docs/registry-format.md for format spec.

| ID | Title | Status | Module(s) | Owner mode | Created |
|---|---|---|---|---|---|
| EN0001 | User | draft | [] | AR | 2026-06-11 |
```

(Published registries point at the downstream `docs/governance/registry-format.md` instead — see
"Draft vs published".)

---

## Table columns

| Column | Type | Purpose |
|--------|------|---------|
| `ID` | `<LAYER><####>` (semantic variants — see doc_id naming below) | doc identifier; one row per doc; matches the doc's `doc_id` |
| `Title` | string | human-readable title |
| `Status` | enum | `reserved` \| `draft` \| `canonical` \| `deprecated` |
| `Module(s)` | list | `[]` (program-wide) by default; `[all]` only when explicitly program-wide-all; never `—`. BA draft docs may omit `modules:` frontmatter (defaults to `[]`); UX docs declare it explicitly. |
| `Owner mode` | enum | who authored/imported the row (see below) |
| `Created` | date | `YYYY-MM-DD` when the ID first appeared |

### Status lifecycle

```
reserved → draft → canonical → deprecated
                        ↘ deprecated (skip canonical when never finalized)
```

- **reserved** — doc_id claimed, file not yet authored
- **draft** — file authored, not yet canonical
- **canonical** — accepted as authoritative
- **deprecated** — superseded; do not reference from new content

Draft registries (`_ar/spec-draft/`) carry `status: draft`. The publication step re-stamps the
carried-over rows as `canonical`.

### Owner mode

- Draft registries: `AR` — an AR-specific value (not part of arg-emitee's enum), marking a row produced by AR reconstruction.
- Published registries: `Mode P (import)` (the arg-emitee enum is
  `Mode P | Mode M (<module>) | Mode B (<slice-id>) | Mode C`; AR-reconstructed content imports as
  program-level `Mode P (import)`). arg-emitee's Mode M re-scopes after hand-off.

---

## Semantic header names

| Layer | Header | Layer | Header |
|-------|--------|-------|--------|
| EN | `# EN Registry — Entity` | API | `# API Registry — API Contract` |
| UC | `# UC Registry — Use Case` | JOB | `# JOB Registry — Job` |
| BR | `# BR Registry — Business Rule` | ACL | `# ACL Registry — Access Control` |
| FN | `# FN Registry — Function` | QUERY | `# QUERY Registry — Read-Side Query` |
| ARCH | `# ARCH Registry — Architecture` | IA | `# IA Registry — Information Architecture` |
| ES | `# ES Registry — External System` | WIRE | `# WIRE Registry — Wireframe Spec` |
| MSG | `# MSG Registry — Message` | COMP | `# COMP Registry — Component Spec` |
| CS | `# CS Registry — FE-First Scenario` | COPY | `# COPY Registry — Copy Spec` |

---

## doc_id naming

- Most layers: `<LAYER><####>` (zero-padded 4 digits) — `EN0001`, `UC0014`, `WIRE0003`.
- BR: `BR-<rule-name>` (semantic).
- IA: `IA-<project-slug>` (one per project).
- COPY: `COPY-<scope>` (`module-<slug>` | `shared-<purpose>`).

The registry `ID` must match the doc's `doc_id` frontmatter exactly.

---

## Atomicity

A `doc_id` and its registry row belong together:

- every authored doc has a registry row;
- every registry row has an authored doc;
- a row without a doc, or a doc without a row, is an **orphan** and is reported.

---

## Cross-references (no dangling)

Docs reference each other via `doc_id` in `references:` (and the layer-specific fields `affects`
(BR), `realizes_uc` (WIRE), `trigger` (MSG)). Every referenced `doc_id` MUST resolve to a registry
row in its target layer. `RefIntegrityValidator` classifies each reference:

- **resolved** — the target row exists in the draft registry;
- **dangling** — the target should exist in a present layer but has no row → reconstruction gap,
  recorded as an Open Question (never auto-repaired or guessed);
- **deferred** — the target layer is not yet synthesized this run (e.g. API not produced) → kept
  as a deferred cross-layer link.

doc_id **collisions** (two docs claiming the same `doc_id`) are reported as Open Questions — the
validator does not renumber or rename.

---

## Draft vs published

| | Draft (`_ar/spec-draft/<LAYER>/`) | Published (`_ar/spec-final/<tier>/<LAYER>/`) |
|---|---|---|
| Built by | `RefIntegrityValidator` | `SpecFinalGenerator` (carries draft rows over) |
| Status | `draft` | `canonical` |
| Owner mode | `AR` | `Mode P (import)` |
| Filenames | AR draft form (`LAYER0001_PascalName.md`) | conformant `<doc_id>-<kebab-title>.md` |
| Format-spec pointer | `tooling/docs/registry-format.md` | `docs/governance/registry-format.md` (downstream arg-emitee) |

The published registry's `docs/governance/registry-format.md` pointer is a path in the downstream
arg-emitee rebuild project, not a local AR path.

Because the draft registry already lists every `doc_id`, publication is a straight carry-over:
re-stamp `Status` to `canonical`, set `Owner mode` to `Mode P (import)`, **keep `Created`**, and
conform filenames.
