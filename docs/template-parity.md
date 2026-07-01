# Template / Rule Parity with arg-emitee

## Purpose

AR and the sister delivery system `arg-emitee` describe the **same canonical layers** with their
own copies of the layer templates and rules. AR reconstructs a spec; arg-emitee rebuilds from it.
For a reconstructed draft to match the rebuild's expected shape, the **structure** (sections,
frontmatter) of the shared layers must stay aligned.

This document is the parity policy: it names the canonical source, maps the files, and records the
**intentional AR deltas** that must survive any sync. `scripts/check-template-parity.sh` detects
structural drift against the policy.

The two repos are separate (no symlink/submodule); parity is a maintained policy plus an automated
check — the same way the glossary skeleton is shared conceptually, not by a single file.

---

## Canonical source

`arg-emitee/docs/authoring/templates/<LAYER>.md` and `arg-emitee/docs/authoring/rules/<LAYER>.md`
are the canonical reference for the **shared section structure** of each layer. AR mirrors that
structure in `templates/template-<LAYER>.md` and `docs/rules-<LAYER>.md`, plus the AR deltas below.

When a shared section is added/renamed/removed in arg-emitee, mirror it in AR (preserving the AR
deltas). When an AR delta needs to change, change it here and in AR only — it is not part of the
shared structure.

---

## File map (16 shared layers)

| Layer | AR template | AR rules | arg-emitee template | arg-emitee rules |
|-------|-------------|----------|---------------------|------------------|
| EN, UC, BR, FN, ARCH, ES, MSG, CS, API, JOB, ACL, QUERY (BA) | `templates/template-<L>.md` | `docs/rules-<L>.md` | `authoring/templates/<L>.md` | `authoring/rules/<L>.md` |
| IA, WIRE, COMP, COPY (UX) | `templates/template-<L>.md` | `docs/rules-<L>.md` | `authoring/templates/<L>.md` | `authoring/rules/<L>.md` |

---

## Intentional AR deltas (preserve on sync; the drift-check ignores them)

These exist in AR and not (in the same form) in arg-emitee. They are AR's reconstruction-specific
discipline and **must not** be "fixed" toward arg-emitee:

| Delta | Where | Origin |
|-------|-------|--------|
| `## Cross-references (reference, don't restate)` section | every `rules-<LAYER>.md` | task C |
| `references:` frontmatter | `template-EN/UC/ES` (other layers already had it) | task D |
| `## Evidence level` section + closed-set labels (Confirmed/Partial/Uncertain/Blocked) | `template-UC` / `rules-UC` | AR evidence discipline |
| CS evidence discipline: FE-evidence priority + certainty classification (`rules-CS` sections `Evidence Priority Rule`, `Certainty Classification`); `template-CS` embeds the evidence convention in `## Purpose` rather than a separate heading. The `## Evidence` section in `template-WIRE/COMP/COPY` is also AR-only. (The `## Evidence Convention` *heading* in arg-emitee's CS template is shared structure; AR's delta is the enriched content and its placement.) | `rules-CS`, `template-CS`, `template-WIRE/COMP/COPY` | AR evidence discipline; task B (UX) |
| AR draft frontmatter: bare `doc_id`, `spec_type`, draft-phase `status` | every AR template | AR house style |

Everything else (section headings, Restrictions, Required Structure, layer-specific frontmatter
fields like `contract_type`/`job_type`/`query_type`/`affects`/`trigger`/`scope`/`screen_id`/
`realizes_uc`) is **shared structure** and must stay aligned.

---

## Aligned conventions (parity, kept identical)

- `status: draft | canonical` shown in template frontmatter (matching arg-emitee).
- Each `rules-<LAYER>.md` opens with `> See also: cross-layer-discipline.md` (matching arg-emitee),
  in addition to AR's per-layer Cross-references section.
- `references:` present on every template that arg-emitee shows it on.

---

## Drift-check

Run from the AR repo root:

```
scripts/check-template-parity.sh [path-to-arg-emitee-docs]
```

Default arg-emitee path: `../arg-emitee-secondvibe/docs` (a sibling checkout). If arg-emitee is not
present, the script reports `skipped` and exits 0.

It compares the `##` section headings, filters out the known AR-delta headings, and reports per
layer. Scope: **templates** are checked for all 16 layers (the artifact structure); **rules** are
strict-checked for the 12 BA layers. The 4 **UX rules** follow AR's uniform house structure
(Purpose / Naming / Required Frontmatter / Recommended Structure / Cross-references / Restrictions /
Evidence) rather than arg-emitee's UX-rule structure — this is an intentional AR house-style choice,
reported informationally, not as drift (the UX *templates*, which define the artifacts, are in
parity). For each checked layer it reports:

- `in parity` — shared headings match;
- `DRIFT` — an unexpected heading is present on one side only (printed), and the script exits
  non-zero.

A `DRIFT` result means the shared structure diverged: reconcile (mirror arg-emitee, or record a new
intentional delta here and add it to the script's exclusion list).
