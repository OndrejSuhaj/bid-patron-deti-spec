# Spec-Final Publication Rules (BA/UX Conformance)

## Purpose

`_ar/spec-final/` is the **publishable, hand-off layer** of the AR pipeline. It is produced by
`SpecFinalGenerator` from the canonical draft in `_ar/spec-draft/`.

Beyond the Czech translation it has always performed, the final layer MUST now be a
**drop-in tree** for the sister delivery system (`arg-emitee`), which consumes canonical
artifacts under `_ar/BA/<LAYER>/` and `_ar/UX/<LAYER>/`. A reconstructed legacy system should
flow into the rebuild by copying `_ar/spec-final/BA` and `_ar/spec-final/UX` into the target
project's `_ar/BA` and `_ar/UX` with **no restructuring**.

These rules define the tier model, directory layout, file naming, frontmatter, and per-layer
registry that make the final layer conformant. They govern `_ar/spec-final/**` only.
`_ar/spec-draft/**` is unaffected and keeps its existing flat layout and naming.

---

## Relationship to the draft layer

| | `_ar/spec-draft/` | `_ar/spec-final/` |
|---|---|---|
| Role | internal working reconstruction | publishable hand-off |
| Layout | flat: `spec-draft/<LAYER>/` | tiered: `spec-final/{BA,UX}/<LAYER>/` |
| Naming | `LAYER0001_PascalName.md` | `LAYER0001-kebab-title.md` |
| Registry | `_REGISTRY.md` per layer (built by RefIntegrityValidator) | `_REGISTRY.md` per layer |
| Language | source language | Czech |
| Authored by | stage 02/03/04/90 agents | `SpecFinalGenerator` only |

`SpecFinalGenerator` is publication-only: it never reinterprets, merges, deduplicates, or
repairs draft content. It selects canonical draft artifacts, conforms their envelope (path,
filename, frontmatter, registry), and translates the human-readable content into Czech.

Cross-layer de-duplication (the same content restated across layers) is enforced **upstream**, at
authoring time, by `cross-layer-discipline.md` and the `CrossLayerAuditor` agent — not here. The
final layer publishes whatever the draft holds.

---

## Tier model — BA vs UX (layer → tier map)

This map is the single source of truth for tier routing.

| Tier | Layers |
|------|--------|
| **BA** | EN, UC, BR, FN, ARCH, ES, MSG, CS, API, JOB, ACL, QUERY |
| **UX** *(optional — synthesized by the `ux-reconstruction` branch)* | IA, WIRE, COMP, COPY |

- **CS belongs to BA** (observed critical scenarios), matching arg-emitee.
- The 4 UX layers are synthesized by the optional `ux-reconstruction` branch
  (`orchestration/90-optional-bonus/ux-reconstruction/`), which reconstructs them from observed
  UI evidence. When UX-layer drafts exist in `_ar/spec-draft/{IA,WIRE,COMP,COPY}/`, they are
  published under `_ar/spec-final/UX/`; when absent, the UX folders and empty registries are
  still scaffolded so the tier stays consistent.

---

## Target directory layout

```
_ar/spec-final/
  BA/
    EN/     _REGISTRY.md  EN0001-....md ...
    UC/     _REGISTRY.md  UC0001-....md ...
    BR/     _REGISTRY.md  BR-....md ...
    FN/     ARCH/  ES/  MSG/  CS/  API/  JOB/  ACL/  QUERY/   (same shape)
  UX/                                   (reserved, scaffolded empty)
    IA/     _REGISTRY.md
    WIRE/   _REGISTRY.md
    COMP/   _REGISTRY.md
    COPY/   _REGISTRY.md
  final-publication-map.md
  final-publication-report.md
```

- Publish only layers that actually exist in `_ar/spec-draft/` at run time. Absence of a layer
  is never an error; record it as skipped in the report.
- Always scaffold the four UX layer folders + empty `_REGISTRY.md`, even when empty.

---

## File naming

Each published file is named `<doc_id>-<kebab-title>.md`.

- `<doc_id>` is the bare identifier already present in the draft frontmatter
  (`EN0001`, `UC0014`, `ARCH0002`, `API0003`, …). **Never** renumber, rename, or translate the
  doc_id token itself.
- `<kebab-title>` is derived from the document title: lowercase ASCII, words hyphen-separated,
  no leading digit, accents folded (`č→c`, `ř→r`, …), max 40 chars.
- `BR` keeps semantic naming: `BR-<rule-name>.md` (already conformant; only kebab the name).
- `IA` (UX) uses `IA-<project-slug>.md` (no number, one per project).
- `COPY` (UX) uses `COPY-<scope>.md` where scope is `module-<slug>` or `shared-<purpose>`.

Examples:

| Draft file | Final file |
|---|---|
| `ARCH0001_ApplicationOverview.md` | `BA/ARCH/ARCH0001-application-overview.md` |
| `CS0006_IssuerCreatesDraft.md` | `BA/CS/CS0006-issuer-creates-draft.md` |
| `BR-MinimumInvestmentAmount.md` | `BA/BR/BR-minimum-investment-amount.md` |

---

## Frontmatter conformance

The draft `doc_id` frontmatter is already bare and is preserved as-is. The final envelope
adds the fields arg-emitee expects.

Required on every published doc:

```yaml
---
doc_id: EN0001                 # preserved from draft, unchanged
title: User                    # from draft title (heading text after the prefix)
canonical_layer: EN
status: canonical              # see lifecycle below
modules: []                    # see module scoping below
---
```

Optional / carried over when present in the draft:

- `spec_type` — preserved from the draft (`entity`, `use-case`, `critical-scenario`, …).
- `references` — list of doc_ids; carried over and validated (see Registry).

Layer-specific fields are preserved verbatim from the draft when present:
`contract_type` (API), `job_type` (JOB), `query_type` (QUERY), `affects` (BR), `trigger` (MSG),
`scope`/`priority`/`impact` (CS).

UX-tier layers (reserved; populated by the later UX reconstruction task) carry their own
required fields per arg-emitee `governance/registry-format.md`. When UX docs are published they
MUST include:

- `IA`: `scope: program`, `owners: [...]`, `language: cs | en`
- `WIRE`: `screen_id: S<###>`, `realizes_uc: [UC<####>]` **(required — a screen without a use case is invalid)**
- `COMP`: `design_source: <url>` (optional)
- `COPY`: `scope: module-<slug> | shared-<purpose>`, `language: cs | en | multi`

### Status lifecycle

`reserved → draft → canonical → deprecated` (arg-emitee lifecycle, documented for forward
compatibility). `SpecFinalGenerator` publishes **only canonical draft sources**, so every
published doc and every registry row lands as `status: canonical`. `reserved` and `draft` are
used downstream by arg-emitee; AR does not emit them.

### Module scoping

AR reconstruction has no module concept (modules belong to the rebuild's module-map). Default
every published doc to `modules: []` (program-wide). After hand-off, arg-emitee's Mode M
re-scopes docs to specific modules. Do not invent module slugs during reconstruction.

---

## Registry format — `_REGISTRY.md`

Every layer folder under `BA/` and `UX/` contains exactly one `_REGISTRY.md`. The format (header,
format-spec pointer, columns, semantic header names, atomicity, no-dangling rule) is defined once
in `tooling/docs/registry-format.md` — see it; this section states only the publication specifics.

At publication, registry rows are **carried over from the draft registries** that
`RefIntegrityValidator` already built (`_ar/spec-draft/<LAYER>/_REGISTRY.md`), then conformed:

- **Status** = `canonical` (the draft rows are re-stamped from `draft`).
- **Owner mode** = `Mode P (import)`.
- **Module(s)** = `[]` (program-wide), mirroring `modules: []`; never `—`.
- **Created** = carried over from the draft registry row (first-appearance date), not reset to the publication date.
- The published registry header points at the downstream `docs/governance/registry-format.md`.
- **No dangling references**: every `references:` doc_id MUST resolve to a registry row in its
  target layer. (a) referenced layer not published this run → keep the reference, note it as a
  deferred cross-tier link in the report; (b) referenced doc should exist in a published layer but
  has no row → reconstruction gap: flag it in `final-publication-report.md` (do not silently drop).

Reserved (empty) UX registries carry only the semantic header, the format-spec pointer, and the
empty table header.

---

## Draft → final transformation (summary)

| Aspect | Draft (source) | Final (conformant) |
|--------|----------------|--------------------|
| location | `spec-draft/<LAYER>/` | `spec-final/<tier>/<LAYER>/` per layer→tier map |
| filename | `LAYER0001_PascalName.md` | `LAYER0001-kebab-title.md` |
| doc_id frontmatter | bare (`EN0001`) | unchanged |
| status | `draft\|canonical\|active` | `canonical` |
| modules | absent | `[]` |
| references | present on CS/API/JOB/ACL/QUERY | carried over + validated; best-effort backfill elsewhere |
| registry | none | `_REGISTRY.md` row per doc |
| CS | in `spec-draft/CS/` (today unpublished) | published under `BA/CS/` |
| content | source language | translated to Czech |

---

## Czech translation (unchanged)

The final layer remains a full Czech publication view:

- Translate headings, prose, lists, and explanatory text inside tables into Czech.
- Keep stable and untranslated: IDs, doc_id tokens, filenames, inline field/identifier names,
  code blocks, and glossary-controlled terms (per `_ar/repo-map/glossary.md`).
- If a glossary term is missing and a safe literal translation is uncertain, preserve the
  English term and record the gap in the report.

---

## Worked example

Draft `_ar/spec-draft/ARCH0001_ApplicationOverview.md`:

```yaml
---
doc_id: ARCH0001
title: <Application Overview>
canonical_layer: ARCH
spec_type: architecture
status: canonical
---
```

Published `_ar/spec-final/BA/ARCH/ARCH0001-application-overview.md`:

```yaml
---
doc_id: ARCH0001
title: Application Overview
canonical_layer: ARCH
spec_type: architecture
status: canonical
modules: []
---
```

Plus a row in `_ar/spec-final/BA/ARCH/_REGISTRY.md` (under `# ARCH Registry — Architecture`):

```
| ARCH0001 | Application Overview | canonical | [] | Mode P (import) | 2026-06-11 |
```

(Body translated to Czech; ARCH0001 and the heading identifiers preserved.)

---

## Completion criteria

A publication run is conformant when:

- every published doc lives under the correct tier per the layer→tier map;
- every file is named `<doc_id>-<kebab-title>.md`;
- every layer folder has a `_REGISTRY.md` with one row per doc and no orphan rows;
- the four UX layer folders + empty registries exist (reserved);
- all `references:` resolve within the published registries (no dangling);
- content is translated to Czech with stable identifiers;
- `final-publication-map.md` and `final-publication-report.md` exist.
