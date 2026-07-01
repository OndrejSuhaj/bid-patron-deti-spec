# Template — Spec-Final Publication Envelope

Companion to `docs/rules-spec-final.md`. Defines the conformant envelope for published
artifacts under `_ar/spec-final/{BA,UX}/<LAYER>/`. The document **body** keeps the structure of
its source layer template (`template-EN.md`, `template-UC.md`, …); only the envelope (path,
filename, frontmatter) and the per-layer registry are defined here.

---

## Published artifact frontmatter

```yaml
---
doc_id: <LAYER####>          # preserved from draft, never renumbered/translated (BR: BR-<rule-name>)
title: <Human Readable Title>
canonical_layer: <EN|UC|BR|FN|ARCH|ES|MSG|CS|API|JOB|ACL|QUERY|IA|WIRE|COMP|COPY>
status: canonical
modules: []                  # program-wide default; arg-emitee Mode M re-scopes after hand-off
# --- optional, carried over from draft when present ---
spec_type: <per-layer hint>
references: [<DOC_ID>, ...]   # must resolve in the target layer _REGISTRY.md
# --- layer-specific, carried over verbatim when present ---
# contract_type:  (API)   job_type: (JOB)   query_type: (QUERY)
# affects: (BR)   trigger: (MSG)   scope/priority/impact: (CS)
---
```

File path: `_ar/spec-final/<tier>/<LAYER>/<doc_id>-<kebab-title>.md`
(tier per the layer→tier map in `docs/rules-spec-final.md`).

---

## `_REGISTRY.md` (one per layer folder)

Header is `# <LAYER> Registry — <SemanticName>` (semantic-name map in `rules-spec-final.md`),
followed by a format-spec pointer, then the table:

```markdown
# EN Registry — Entity

`_ar/BA/EN/_REGISTRY.md` — see docs/governance/registry-format.md for format spec.

| ID | Title | Status | Module(s) | Owner mode | Created |
|---|---|---|---|---|---|
| EN0001 | User | canonical | [] | Mode P (import) | YYYY-MM-DD |
| EN0002 | Invoice | canonical | [] | Mode P (import) | YYYY-MM-DD |
```

- One row per published doc; ID matches the file's `doc_id`.
- `Status` = `canonical` for AR-published rows.
- `Module(s)` = `[]` (program-wide) by default — mirrors `modules: []`; never `—`.
- `Owner mode` = `Mode P (import)` (arg-emitee enum: `Mode P | Mode M (<module>) | Mode B (<slice-id>) | Mode C`).
- `Created` = publication run date.

---

## Reserved UX layer registry (scaffolded empty)

Created for IA, WIRE, COMP, COPY even when AR has produced no UX docs yet (semantic headers:
IA — Information Architecture, WIRE — Wireframe Spec, COMP — Component Spec, COPY — Copy Spec):

```markdown
# WIRE Registry — Wireframe Spec

`_ar/UX/WIRE/_REGISTRY.md` — see docs/governance/registry-format.md for format spec.

> Reserved. Populated by UX reconstruction (later task). No AR-produced docs yet.

| ID | Title | Status | Module(s) | Owner mode | Created |
|---|---|---|---|---|---|
```

UX docs, when later published, carry layer-specific required fields:
`IA` → `scope: program`, `owners: [...]`, `language`; `WIRE` → `screen_id: S<###>`,
`realizes_uc: [UC<####>]` (required); `COMP` → `design_source` (optional);
`COPY` → `scope: module-<slug> | shared-<purpose>`, `language`.

---

## Example — published BA/EN artifact

`_ar/spec-final/BA/EN/EN0001-user.md`

```yaml
---
doc_id: EN0001
title: User
canonical_layer: EN
spec_type: entity
status: canonical
modules: []
references: [UC0014]
---
```

```markdown
# EN0001 – Uživatel

## Účel
...
```
