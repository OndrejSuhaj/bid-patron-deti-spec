# Cross-Layer Authoring Discipline (AR)

## Purpose

This document is the single source of truth for **how AR canonical layers relate to each other**.
It exists to stop the reconstruction pipeline from duplicating the same content across layers
(the same business rule restated inline in UC, EN, and BR; entity attributes copied into UC;
etc.). [SpecFinalGenerator](../orchestration/03-spec-driven-documentation/agents/SpecFinalGenerator.md)
is publication-only and explicitly does NOT deduplicate across layers, so the discipline must hold
at authoring time and is enforced by [CrossLayerAuditor](../orchestration/03-spec-driven-documentation/agents/CrossLayerAuditor.md).

It governs every layer rule (`docs/rules-<LAYER>.md`) and every authoring agent. Per-layer rules
reference this document for the ownership table rather than restating it.

---

## 1. Reference, don't restate

Each fact has exactly **one canonical owner** (a `doc_id` in a specific layer). Any other document
that mentions that fact MUST cite the owner's `doc_id` — in the `references:` frontmatter and inline
— and MUST NOT restate the owned content.

Correct:

> UC0014 affects the invoice (`EN0002`) and is gated by `BR-minimum-invoice-amount`.

Wrong (restatement):

> UC0014 affects the invoice, which has fields number, issue date, due date, total… and may not be
> issued below the configured minimum amount of …

If the citing doc lacks context, fix the **owning** doc — do not copy context into the citer.

---

## 2. Source-of-truth ownership table

The full ownership map. Each layer **owns** its content; all other layers reference it by `doc_id`.
AR reconstructs all 16 canonical layers, so the single-source model applies to every one of them —
this table extends the named owners in arg-emitee's authoring-contract (EN, BR, UC, ACL, API, ARCH)
to the full set AR produces.

| Layer | Owns (canonical content) |
|-------|--------------------------|
| EN | entity semantics, lifecycle, states, attributes, entity-local invariants, relationships |
| BR | business rules, cross-entity constraints, domain invariants, domain policies |
| UC | use-case behavior, numbered flows, triggers, pre/postconditions, lifecycle changes |
| FN | internal functional capabilities, responsibilities |
| ARCH | system structure, components, interaction model, scope |
| ES | external systems, integration boundaries, data exchange |
| MSG | transactional messages (trigger, recipients, content) |
| CS | observed FE runtime behavior, screenshot evidence |
| API | system-facing contracts (request/response, side effects, failure outcomes) |
| JOB | background execution contracts (trigger, scope, idempotency, failure handling) |
| ACL | actor/role × resource × action × scope, inheritance |
| QUERY | read-side specs (source entities, filters, grouping, derived outputs, result shape) |
| IA | navigation surface, screen map, entry points, cross-module flows, information hierarchy |
| WIRE | per-screen layout, zones, components used, interactions, states, data bindings |
| COMP | reusable component contracts (props, variants, states, events, accessibility) |
| COPY | user-facing text (labels, helpers, errors, CTAs), i18n keys |

---

## 3. Refers to / never inlines

| Layer | References by doc_id | Never inlines (cite instead) |
|-------|----------------------|------------------------------|
| EN | BR, EN (relationships) | rule content (→BR), use-case flows (→UC), screen layouts (→WIRE) |
| UC | EN, BR, ACL, API, ES, JOB | entity attributes (→EN), rule content (→BR), screen layouts (→WIRE/IA), contracts (→API) |
| BR | EN, UC | step-by-step flows (→UC), screen logic (→WIRE) |
| FN | UC, EN, ES, MSG | rule content (→BR), entity attributes (→EN), flows (→UC) |
| ARCH | (program-level; ES) | use-case flows (→UC), entity models (→EN), rule content (→BR) |
| ES | (ARCH context) | entity attributes (→EN), contract payloads (→API) |
| MSG | UC, EN | entity attributes (→EN), rule content (→BR) |
| CS | UC, EN | rule content (→BR), contracts (→API); observed facts stay in CS |
| API | EN, UC, ACL | entity attributes (→EN), rule content (→BR), access rules (→ACL) |
| JOB | FN, EN, BR, ES | rule content (→BR), entity attributes (→EN) |
| ACL | EN, UC | entity attributes (→EN), rule content (→BR) |
| QUERY | EN, UC, FN | entity attributes (→EN), rule content (→BR) |
| IA | EN, BR, ARCH, UC, ACL, ES | entity attributes, rules, ADRs, endpoints, providers, screen layout |
| WIRE | UC, COMP, EN, QUERY, BR, ACL | navigation (→IA), component contracts (→COMP), text (→COPY), backend |
| COMP | COMP (sub), EN, ACL | screen layout (→WIRE), text (→COPY), backend, entity attributes |
| COPY | WIRE, COMP, BR, EN, UC | entity attributes (→EN), rule content (→BR), screen logic (→WIRE), component contracts (→COMP) |

The authoritative per-layer boundary detail lives in each `docs/rules-<LAYER>.md` ("Cross-references"
and "Restrictions" sections); this table is the consolidated index.

---

## 4. Enforcement

- A block of another layer's owned content >50 characters appearing verbatim or near-verbatim in a
  non-owning layer is a **restatement violation** → replace with a `doc_id` reference.
- `CrossLayerAuditor` detects and rewrites such restatements into references after the layers are
  drafted (since SpecFinalGenerator will not). Authoring agents should avoid creating them in the
  first place.

Exceptions (the only restatement allowed):

- the `references:` frontmatter list (metadata, not body);
- a one-line orientation summary ≤50 chars next to a `doc_id` (e.g. "EN0002 — Invoice (8-state lifecycle)");
- a bare folder/layer pointer purely for orientation (e.g. "owners live in `_ar/spec-draft/UC/`") that carries no restated content.

Invariant ownership (a common confusion): "an invoice amount must be ≥ the configured minimum" is
**BR**-owned (domain policy); "a draft invoice has states pending → locked → issued" is **EN**-owned
(entity lifecycle).

---

## 5. Skip empty sections

Omit a template section (heading + body) when its content would be only a placeholder
(`—`, `N/A`, `none`, `see <X>`, `(not applicable)`). Exception — sections whose explicit absence is
information must stay even as `(none)`: **Open Questions** and any **evidence-gap / certainty**
section. Empty Open Questions on a non-trivial doc signals silently-decided assumptions; re-review.

---

## 6. Surface unknowns; evidence is suggestive, not authoritative

- Do not infer owned content from weak signals to "fill a gap". A missing referenced `doc_id` during
  reconstruction is a **Hypothesis / Open Question**, never an excuse to restate or invent.
- Classify claims with AR's existing evidence vocabulary — the UC evidence levels
  `Confirmed` / `Partial` / `Uncertain` / `Blocked` (`docs/rules-UC.md`), the CS certainty labels
  (`docs/rules-CS.md`), and `Hypothesis` for un-evidenced statements. This section reuses that
  vocabulary; it does not introduce a new one.
- Authority of evidence: source code + database structure + orchestration flows are authoritative;
  screenshots / observed UI / prototype are **suggestive** evidence of intent, not canonical truth.
  On contradiction, code/flow evidence wins and the mismatch is recorded as an Open Question.

---

## 7. References resolve within the reconstruction

During reconstruction, cited `doc_id`s resolve within the current `_ar/spec-draft/` set. Registry
validation and conformant naming happen at publication (see `docs/rules-spec-final.md`). A reference
that cannot resolve is recorded as an Open Question, not dropped or back-filled by restatement.

---

## 8. Authority precedence

This document is authoring guidance, not a governance override. The reconstructed canonical
artifacts in `_ar/spec-draft/` and the glossary take precedence over it; it only orders how the
authoring inputs are applied. For terminology and structure, in order:
`_ar/repo-map/glossary.md` (terminology) → this document (cross-layer ownership) →
`docs/rules-<LAYER>.md` → `templates/template-<LAYER>.md`. A task may override a formatting detail
only for its own run. This discipline applies to every canonical layer. (In a downstream
arg-emitee project, its constitution/guardrails/authoring-contract sit above this document.)
