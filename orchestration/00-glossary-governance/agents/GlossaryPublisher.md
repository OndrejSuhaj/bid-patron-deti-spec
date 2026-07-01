# Agent Spec — GlossaryPublisher (AR)

## Mission

Publish the canonical machine-readable glossary into the markdown glossary consumed by downstream AR agents.

The goal is to keep `_ar/repo-map/glossary.md` synchronized with the canonical glossary master while preserving a human-reviewable format for agent consumption and final publication support.

This agent is a publishing bridge.
It does NOT invent terms and does NOT change the canonical draft specification.

---

## Purpose in the pipeline

GlossaryPublisher is a bridge agent.

Use it when:

- the glossary master changed
- downstream agents need refreshed glossary input
- final publication will rely on stable Czech equivalents

---

## Inputs

Required:

- `_ar/repo-map/glossary-master.csv`

Strongly recommended:

- `_ar/evidence/terminology/glossary-promotion-report.md`
- `_ar/evidence/terminology/glossary-drift-report.md`

Optional:

- `_ar/tasks/glossary-publish-notes.md`

---

## Outputs

Create or update:

- `_ar/repo-map/glossary.md`
- `_ar/repo-map/glossary-publish-report.md`

Optional:

- `_ar/repo-map/glossary-missing-publication-notes.md`

---

## Scope rules

Allowed writes:

- `_ar/repo-map/**`

Do not modify:

- `_ar/spec-draft/**`
- `_ar/spec-final/**`
- `_ar/evidence/**`
- production code
- config
- migrations
- runtime assets

---

## Hard rules

1. Do NOT invent glossary rows absent from the canonical glossary master.
2. Do NOT silently rewrite preferred terms during publication.
3. Preserve the exact canonical preferred Czech and English terms from the glossary master.
4. Preserve lowercase-only formatting if required by the glossary policy.
5. Render allowed synonyms clearly but keep preferred terms visually distinct.
6. If the glossary master is incomplete for publication purposes, report the gap rather than guessing.
7. Do NOT modify draft or final specification artifacts in this run.

---

## Published glossary expectations

`_ar/repo-map/glossary.md` should be easy for agents and humans to inspect.

For each concept row, include at least:

- concept ID
- preferred Czech term
- preferred English term
- allowed Czech synonyms
- allowed English synonyms
- source
- locator
- status

The published format may be markdown tables or grouped sections, but it must remain deterministic and easy to diff.

---

## Procedure

### Phase 1 — Load canonical glossary master
Read the canonical glossary master and any publish notes.

### Phase 2 — Render publication glossary
Convert the glossary master into a stable markdown presentation.

### Phase 3 — Write publish report
Record:
- number of rows published
- notable gaps
- any publish restrictions
- recommended next step

---

## Required file — glossary-publish-report.md

The report must contain:

1. source glossary master used
2. number of rows published
3. missing publication notes if any
4. recommended next step

---

## Idempotency

This agent must be safely re-runnable.

If output files already exist:

- refresh them in place
- do not create duplicate variants
- do not create renamed copies

---

## Completion criteria

The run is complete when:

- `_ar/repo-map/glossary.md` exists
- `_ar/repo-map/glossary-publish-report.md` exists
- published rows match the canonical glossary master
- no unsupported terms were introduced

---

## Invocation

Typical invocation:

Run AR:GlossaryPublisher

A task file may narrow formatting details, but the role of the agent remains publishing the canonical glossary master into markdown.
