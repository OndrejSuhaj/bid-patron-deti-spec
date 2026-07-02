# Glossary Publish Report — Patronus (current-state, bid-patron-deti)

> Produced by **AR:GlossaryPublisher** · 2026-07-02 · **first publish** of `_ar/repo-map/glossary.md`.
> This agent is a publishing bridge: it renders the canonical machine-readable master into the
> human/agent-readable markdown glossary. It does **not** invent terms, does **not** rewrite preferred
> terms, and does **not** modify the master, drafts, or final artifacts.

---

## 1. Source glossary master used

- **Master:** `_ar/repo-map/glossary-master.csv`
- **Schema (preserved exactly):**
  `concept_id,preferred_cz,allowed_synonyms_cz,preferred_en,allowed_synonyms_en,source,locator,status`
- **Master state at publish time:** 119 data rows, `concept_id` `C001`–`C119` (contiguous, no gaps, no
  duplicates), verified by parsing the CSV (quoted comma-bearing fields handled) — matches the
  `AR:GlossaryPromoter` run recorded in `_ar/evidence/terminology/glossary-promotion-report.md`.

Optional publisher inputs checked:

- `_ar/tasks/glossary-publish-notes.md` — **absent** (no formatting overrides applied).
- `_ar/evidence/terminology/glossary-promotion-report.md` — present; used only to mirror the master's
  section structure for readability (no content sourced from it).
- `_ar/evidence/terminology/glossary-drift-report.md` — present; not required for rendering.

---

## 2. Number of rows published

**119 rows published** — 1:1 with the master (0 added, 0 dropped, 0 rewritten).

| Group (by concept_id range) | Rows |
|---|---:|
| Domain & notification concepts (C001–C057) | 57 |
| TIER-A entity statuses (C058–C112) | 55 |
| — lead statuses | 5 |
| — application (žádost) statuses | 23 |
| — story (příběh) statuses | 24 |
| — no-entity-type statuses | 3 |
| Code-only entity statuses (C113–C119) | 7 |
| **Total** | **119** |

Evidence-status distribution (verbatim from the master `status` column):

| status | Rows |
|---|---:|
| Confirmed | 96 |
| Partial | 23 |
| Uncertain / Blocked | 0 |

### Rendering approach

- Grouped markdown tables (by `concept_id` range, mirroring the promotion report), so the file stays
  deterministic and easy to diff.
- Each row renders all eight master columns: `concept_id`, `preferred_cz`, `preferred_en`,
  `allowed_synonyms_cz`, `allowed_synonyms_en`, `source`, `locator`, `status`.
- **Preferred terms are bolded** to keep them visually distinct from allowed synonyms (per hard-rule 5).
- Preferred CZ/EN terms are reproduced **verbatim** — lowercase policy preserved; vendor/product proper
  names (ComGate, Netopia / MobilPay, MAIB, ARES, MVČR) kept exactly as stored (per the master's
  ubiquitous-language convention).
- CZ/RO/MD localized labels and alternatives are shown only in the synonym columns, never promoted into
  a preferred field.
- Literal `|` characters inside cell values are markdown-escaped (`\|`); empty synonym cells render as
  `—`. No value was otherwise altered.

### Fidelity verification

- Round-trip check: for all 119 master rows, the exact
  `| Cnnn | **<preferred_cz>** | **<preferred_en>** |` fragment (pipe-escaped) is present in
  `glossary.md` — **0 missing**.
- `glossary.md` contains exactly **119** distinct `concept_id` row-lines — no duplicates, none dropped.

---

## 3. Missing publication notes

No blocking gaps for publication. The master is internally complete for rendering: every published row
carries a non-empty `preferred_cz`, `preferred_en`, `source`, `locator`, and `status`.

Non-blocking observations (carried from the promotion report; **not** actionable by the publisher):

- The published glossary reflects the master **as-is**. Terms currently **blocked pending arbitration**
  (e.g. U1 parent ↔ fundraiser, U4/O1 group + collection-account story sub-types, back-office role CZ
  labels, MD/RU status synonyms, Moneta AISP country) are **not** in the master and therefore **not**
  in `glossary.md` by design. See §4/§5 of `_ar/evidence/terminology/glossary-promotion-report.md` and
  `_ar/evidence/terminology/glossary-rejected-promotions.md`.
- Source-key abbreviations used in `source`/`locator` (DUL, STAT, SCMAP, FLIDX, DK, EN·nn, TSCEN, STMAP)
  are resolved in `_ar/evidence/terminology/glossary-source-index.md`; the published glossary points
  readers there rather than restating the mapping.
- Two status aliases carry verbatim source typos (`waiting_for_feetback` → C093, `feedback_to_proccess`
  → C108); these are the system machine-names and are intentionally preserved unchanged.

`_ar/repo-map/glossary-missing-publication-notes.md` was **not** created — there is nothing in the
master that could not be published.

---

## 4. Publish restrictions applied

- Wrote **only** under `_ar/repo-map/**` (`glossary.md`, `glossary-publish-report.md`).
- Did **not** modify the master, any `_ar/spec-draft/**`, any `_ar/spec-final/**`, `_ar/evidence/**`,
  production code, config, migrations, or runtime assets.
- Did **not** add, drop, merge, split, or rewrite any concept, preferred term, synonym, source, locator,
  or status.

---

## 5. Recommended next step

1. **Consume downstream:** `glossary.md` is ready as refreshed terminology input for the AR
   documentation agents (EN/UC/ARCH/FN/ES/MSG/BR) and as the Czech-publication vocabulary backbone.
2. **Unblock held terms first, then republish:** the highest-value follow-up is to record `approved`
   decisions for the High-priority arbitration items (U1 parent ↔ fundraiser; U4/O1 group +
   collection-account story) in `_ar/tasks/glossary-arbitration-decisions.md`, then re-run
   `AR:GlossaryPromoter` to lift the newly-unblocked terms into the master. **Re-run
   `AR:GlossaryPublisher` afterwards** — it will regenerate `glossary.md` in place from the updated
   master (idempotent; no duplicate or renamed variants).
3. **No publisher action required** until the master changes.

---

## 6. Idempotency

Re-running this agent regenerates `_ar/repo-map/glossary.md` and this report **in place** from the
current master. Row ordering is fixed by ascending `concept_id`, so re-runs against an unchanged master
produce a byte-identical `glossary.md`; runs against a changed master produce a clean, minimal diff. No
duplicate or renamed output variants are created.
