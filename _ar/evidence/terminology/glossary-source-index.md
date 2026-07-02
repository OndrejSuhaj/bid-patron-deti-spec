# Glossary Source Index — Patronus (current-state, bid-patron-deti)

> Produced by **AR:GlossaryCandidateCollector** · 2026-07-02 · FIRST-TIME BOOTSTRAP run.
> Lists the approved terminology sources actually read in this pass, their trust tier, where they
> were applied, and pairing/extraction caveats. Candidate rows in `glossary-candidates.md` cite these
> sources by the short **Source key** below plus an exact locator.
>
> **Scope guard.** This run used only the *safe source set* fixed by the task: it did **not** read the
> gitignored Patronus source tree (`intake/current-solution/_source/patronus/**`) — its domain terms are
> already canonicalized in the AR artifacts below — and it did **not** read `intake/process-maps/**`
> (out of the safe set for this run; process-area vocabulary was taken only from the authorized derived
> scope-map). `intake/it-zadani/**` (target-state) was **not** consulted; target-only naming is out of
> scope for current-state promotion.

---

## Sources used

| Source key | Path | Type | Trust tier | Applied to (candidate categories) | Caveats / pairing restrictions |
|---|---|---|---|---|---|
| **DUL** | `_ar/spec-draft/DOMAIN-ubiquitous-language.md` | AR draft — curated 48-concept domain vocabulary (owning EN + related UC + CZ·RO·MD variants) | PRIMARY (AR usage; not automatic promotion authority) | party/role, core entities, sub-types, donation/payment, documents, tax, risk, notification, finance, overloaded terms | Richest paired CZ/EN source. Overloaded terms (§2) carry a real semantic-conflict risk → flagged unresolved, not promoted. Rejected terms (§3) must **not** be promoted. EN is canonical; CZ wordings are variants. |
| **DK** | `_ar/spec-draft/DOMAIN-kernel.md` | AR draft — domain kernel (concepts, INV01–INV28, state machines, hotspots) | PRIMARY (AR usage) | corroboration of core entities, statuses, invari: derived-total / reconciliation / scoring terms | Confidence labels (Confirmed/Partial/Hypothesis) carried through. Status literals here are ubiquitous-language, not new terms. |
| **DA** | `_ar/spec-draft/DOMAIN-aggregates.md` | AR draft — aggregate boundaries (AG1–AG13) | PRIMARY (AR usage) | aggregate names (Party = User+Contact, Risk assessment = Scoring+Blacklist) as candidate concept groupings | Aggregate names are analytic groupings, not necessarily UI terms; recorded as EN-side candidates with a note. |
| **EN13** | `_ar/spec-draft/EN/EN0013_Voucher.md` | AR draft — entity doc | PRIMARY (AR usage) | voucher / dobrošek, value "Hodnota", delivery-type, redemption | Exact field locators (line refs) available in the EN doc; used for provenance of voucher sub-terms. |
| **EN14** | `_ar/spec-draft/EN/EN0014_DonationConfirmation.md` | AR draft — entity doc | PRIMARY (AR usage) | CZ donation confirmation "Potvrzení o daru", rodné číslo, confirmation-year, "Částka" | CZ-only (no country field); RO uses EN0015 instead — distinct concepts, not synonyms. |
| **EN15** | `_ar/spec-draft/EN/EN0015_TaxPayer.md` | AR draft — entity doc | PRIMARY (AR usage) | RO tax redirection (2% / 3.5%), CNP / Personal Numeric Code, two-years-agreed | RO counterpart of CZ confirmation — a separate canonical concept, **not** a synonym of DonationConfirmation. |
| **EN08** | `_ar/spec-draft/EN/EN0008_User.md` | AR draft — entity doc | PRIMARY (AR usage) | party roles (fundraiser/patron/supporter/organisation_worker + back-office roles), User(Party) | Role machine-names are code identifiers → kept as EN-side role vocabulary; back-office roles have no confirmed CZ label here (unpaired). |
| **EN06** | `_ar/spec-draft/EN/EN0006_Contact.md` | AR draft — entity doc | PRIMARY (AR usage) | Contact / party store, party-role discriminator, Jméno/Příjmení, blacklist_type tiers | `field_name` discriminator values are code identifiers used as role synonyms; blacklist tiers cross-ref DUL §2. |
| **FLIDX** | `_ar/evidence/flow-index.md` | AR evidence — flow scouting index (FL001–FL059) | PRIMARY (AR usage; scouting, Partial where marked) | corroboration of integrations, gateways, process areas (C1–C11), document/reconciliation flows | Trigger evidence points into the Patronus tree (not re-read here); flow-index text is the authorized carrier. |
| **STAT** | `intake/statuses/statuses.md` (+ `README.md`) | Intake — client status model (CZ/RO/MD, alias, EN, entity type) | **TIER-A — highest authority for entity status vocabulary** | the ~60 lead/application/story statuses (alias + CZ + EN + RO), entity-type tagging | `.xlsx` original is the authority on doubt; `.md` is the machine conversion. RO wording present for most rows; MD block sparse/mis-aligned (MD columns partly describe a different lead/story mapping) → MD status labels flagged unresolved. RU (MD) not present here. |
| **STMAP** | `intake/current-solution-analysis/state-map.md` | Intake (derived) — code-workflow ↔ assignment status mapping | TIER-B (derived; corroboration) | 9 code-only statuses beyond the ~60 (CZ labels + provenance), status-model corroboration | DERIVED, not primary alone. Provides CZ labels + code-provenance for `communications`, `taken`, `canceled`, `canceled_fundraiser`, `feedback_received`, `waiting_for_protocol`, `gift_confirmation_approved`, plus technical `draft`/`published`. |
| **SCMAP** | `intake/current-solution-analysis/scope-map.md` | Intake (derived) — functional-area / module / entity inventory | TIER-B (derived; corroboration) | 7 process-area vocabulary, functional groupings, taxonomy value-lists, integration names | DERIVED. Process-area labels (žádost front/back, risk, donations, finance, content, affil) taken here since process-maps were out of the safe set. CZ area labels. |
| **TSCEN** | `intake/test-scenarios/test-scenarios.md` (+ `README.md`, "Notification Matrix" sheet) | Intake — acceptance scenarios + Notification Matrix (status→role→text→channel) | TIER-B (acceptance/corroboration) | notification recipient roles (Parent/Patron/Donor), channels (email / in-app zone message), status-driven CZ status-message texts, matrix-only statuses | Notification Matrix rows flagged `CHECK_PARSE` may carry HTML/newline artefacts from CSV → the `.xlsx` original is authority; texts used as candidate status-message vocabulary only. "Parent" = the fundraiser/legal-guardian recipient label; recorded as a variant, pairing to `fundraiser` flagged for arbitration. |

---

## Sources deliberately NOT read this run (and why)

| Path | Reason |
|---|---|
| `intake/current-solution/_source/patronus/**` | Gitignored; carries secrets; its domain terms are already canonicalized in the AR artifacts above (per task instruction). |
| `intake/process-maps/**` | Out of the safe source set for this run. `.xlsx`/`.docx` are binary; process-area vocabulary was sourced from the authorized derived scope-map (SCMAP) instead. |
| `intake/it-zadani/**` | TARGET state (N1–N13, var. A/B). Out of scope for current-state promotion; target-only naming must never be promoted as current-state canonical. |
| `intake/meetings/**` | Client intent/context; non-binding, not needed for this bootstrap term collection. |
| `_ar/repo-map/glossary-master.csv`, `_ar/repo-map/glossary.md` | Canonical files — read-only context; master currently holds header only (bootstrap). Not modified. |

---

## Extraction scope notes

- **Pairing policy applied:** conservative. A CZ↔EN pair was recorded as a *candidate pair* only when a
  single source states both sides (e.g. DUL's variant column, STAT's CZ+EN columns, EN docs' explicit
  CZ gloss). No CZ/EN/RO/MD equivalent was invented. Where only one side is evidenced, the term sits in
  the **unpaired** file (`glossary-unpaired-source-terms.md`).
- **Localized labels (CZ/RO/MD):** kept as `allowed_synonyms_*`, never as a preferred-term field, per
  scope policy. RO status wordings from STAT are recorded as RO synonyms; MD labels are flagged
  unresolved due to the sparse/misaligned MD block.
- **Confidence vocabulary:** candidate rows use `jasne` (clear pair, single-source-backed both sides) /
  `prijatelne` (acceptable/partial) / `nevyreseno` (unresolved/conflicting). This is orthogonal to the
  AR evidence vocabulary (Confirmed/Partial/Uncertain/Blocked) carried from the source artifacts.
