# Glossary Candidate Report — Patronus (current-state, bid-patron-deti)

> Produced by **AR:GlossaryCandidateCollector** · 2026-07-02 · FIRST-TIME BOOTSTRAP run.
> Companion to `glossary-candidates.md`, `glossary-source-index.md`, `glossary-unpaired-source-terms.md`.

---

## 1. Source pack used

Active tasks: `_ar/tasks/glossary-scope.md`, `_ar/tasks/glossary-source-pack.md`,
`_ar/tasks/glossary-arbitration-decisions.md` (arbitration log empty — no decisions yet).

**Safe source set for this run** (as fixed by the invocation task; full descriptions in
`glossary-source-index.md`):

- PRIMARY (AR artifacts): `DOMAIN-ubiquitous-language.md` (curated 48-concept vocab), `DOMAIN-kernel.md`,
  `DOMAIN-aggregates.md`; entity docs `EN0006`, `EN0008`, `EN0013`, `EN0014`, `EN0015`; `evidence/flow-index.md`.
- TIER-A: `intake/statuses/statuses.md` (+ README) — highest authority for the ~60 status terms.
- TIER-B: `intake/test-scenarios/test-scenarios.md` (Overview + Notification Matrix) and
  `intake/current-solution-analysis/{scope-map,state-map}.md` (derived; corroboration).

**Deliberately not read** (recorded in the source index): the gitignored Patronus source tree
(`intake/current-solution/_source/patronus/**`, secrets; already canonicalized in AR artifacts),
`intake/process-maps/**` (out of the safe set; process-area vocab taken from the derived scope-map),
`intake/it-zadani/**` (TARGET state — out of scope for current-state promotion), `intake/meetings/**`.

---

## 2. Files scanned

| File | Read | Used for |
|---|---|---|
| `_ar/spec-draft/DOMAIN-ubiquitous-language.md` | full | party/role, entities, sub-types, donation/payment, documents, tax, risk, notification, finance, overloaded/rejected |
| `_ar/spec-draft/DOMAIN-kernel.md` | full | corroboration (invariants, status literals, state machines) |
| `_ar/spec-draft/DOMAIN-aggregates.md` | full | aggregate-name candidates, placement corroboration |
| `_ar/spec-draft/EN/EN0006_Contact.md` | full | Contact / party-role discriminator, blacklist tiers, RC/IČO |
| `_ar/spec-draft/EN/EN0008_User.md` | full | party + back-office role vocabulary |
| `_ar/spec-draft/EN/EN0013_Voucher.md` | full | voucher / dobrošek, value, redemption |
| `_ar/spec-draft/EN/EN0014_DonationConfirmation.md` | full | CZ donation confirmation, rodné číslo, confirmation-year |
| `_ar/spec-draft/EN/EN0015_TaxPayer.md` | full | RO tax redirection (2%/3.5%), CNP |
| `_ar/evidence/flow-index.md` | full | gateways, integrations (ARES/MVČR/Moneta/ComGate/Netopia/MAIB/Mautic), doc & reconciliation flows |
| `intake/statuses/statuses.md` + README | full | the ~60 status terms (alias/CZ/EN/RO/entity) |
| `intake/current-solution-analysis/state-map.md` | full | 9 code-only statuses + CZ labels + provenance |
| `intake/current-solution-analysis/scope-map.md` | full | 7 process areas, module/entity groupings, integration names |
| `intake/test-scenarios/test-scenarios.md` (Overview + Notification Matrix) + README | Overview (l.1–58) + Matrix (l.721–851) | notification roles/channels/status-message texts, matrix-only statuses |
| `intake/process-maps/` | listing only | confirmed `.md` conversions exist but out of safe set; **not read** this run |

---

## 3. Candidate rows created / refreshed

First-time bootstrap → all rows **created** (nothing to refresh; `glossary-master.csv` holds only its
header). Files created:

- `glossary-candidates.md`, `glossary-source-index.md`, `glossary-candidate-report.md`,
  `glossary-unpaired-source-terms.md`.

Counts:

| Group | Count | Notes |
|---|---:|---|
| Party / role concept candidates (§1, CN-P) | 15 | 9 clear/acceptable, back-office CZ labels mostly unpaired (§9 U2) |
| Core entity & sub-type candidates (§2, CN-E) | 21 | incl. 2 story sub-types flagged unresolved (group / collection-account) |
| Finance-account candidate (§7, CN-F) | 1 | transparent / collection account (unresolved vs story sub-type) |
| Donation / payment candidates (§3, CN-D) | 13 | incl. 3 gateway proper names |
| Documents / tax / fulfilment candidates (§4, CN-C) | 11 | CZ confirmation vs RO redirection kept distinct |
| Notification role/channel/transport candidates (§6a, CN-N) | 9 | Parent↔fundraiser pairing flagged |
| Risk / reconciliation / finance candidates (§7, CN-R) | 15 | incl. ARES/MVČR/Moneta proper names |
| **Concept candidate rows (CN-\*) total** | **85** | one preferred term each |
| Entity status rows — TIER-A (§5) | 57 | alias + CZ + EN + RO synonym + entity type |
| Entity status rows — code-only (§5b, TIER-B) | 9 | incl. 2 technical (draft/published) marked non-domain |
| Notification status-message text candidates (§6b) | 23 | representative slice of the 117-row matrix; MSG layer consumes full |
| Overloaded/ambiguous terms recorded (§8) | 11 | held out of promotion |
| Unresolved/conflicting pairings (§9) | 8 | routed to arbitration |
| Rejected/non-canonical recorded (§10) | ~24 tokens | prevent accidental promotion |

**Term/row entries across the candidate tables: ~174** (85 concepts + 57 TIER-A statuses + 9 code-only
statuses + 23 notification texts) plus 11 overloaded, 8 unresolved, the rejected list, and the four
unpaired groups (A/B/C/D) in `glossary-unpaired-source-terms.md`.

---

## 4. Unresolved / conflicting candidate groups

Held explicitly unresolved (no forced pairing, no promotion) — full detail in `glossary-candidates.md`
§9 and `glossary-unpaired-source-terms.md`:

1. **U1 — parent ↔ žadatel/fundraiser.** Notification/scenario recipient label "Parent" vs domain
   `fundraiser`. Synonym or distinct UI label?
2. **U2 — back-office role CZ labels.** `supporter/coordinator/senior_coordinator/accountant/content_admin/
   manager/marketing/risk_manager/administrator/front` are code machine-names only; no CZ UI labels in the
   safe set (English-only — see unpaired §A).
3. **U3 — coordinator variants.** code `content_admin` vs "Content Coordinator"; "INFO Coordinator",
   "Operations Manager", "Front Coordinator" — mapping to the fixed code role set unclear.
4. **U4 — group story / collection-account story.** Story types 3 & 4: test-scenarios mark their scenarios
   as **missing**; DUL flags full handling as Missing evidence. Collection-account story conflates with the
   transparent/collection account (CN-F05). Open concepts, not confirmed sub-types.
5. **U5 — supporter (role) vs donor.** Overlapping but not identical.
6. **U6 — MD status labels (+ RU).** STAT's MD block is sparse/misaligned; RU absent. No MD/RU status
   synonyms recorded.
7. **U7 — returned_new_patron reminder ordinals.** STAT crosses EN "1st"/"2nd" against the alias numbers;
   recorded verbatim pending the `.xlsx` original.
8. **U8 — Moneta AISP country.** SCMAP says RO; DUL/kernel say CZ transparent-account import. Country
   attribution disputed.

Plus the **11 overloaded terms** (§8 O1–O11: campaign/story/collection-account, blog, patron, account,
partner, lead, tax confirmation vs redirection, SmartMailing/Mautic, scoring, blacklist/whitelist, status)
— source-backed but semantically multi-valued, held out of canonical promotion until arbitration.

---

## 5. Notable source conflicts recorded (not resolved)

- **Moneta AISP country** (U8): SCMAP (derived) vs DUL/kernel — country attribution disagreement.
- **content_admin vs Content Coordinator** (U3): code config vs test-scenarios naming.
- **returned_new_patron ordinals** (U7): internal STAT label/ordinal inconsistency.
- **collection-account** term used for two different things (U4 / O1): a *story sub-type* vs the *transparent
  account* (one platform Campaign).
- **Notification-matrix `CHECK_PARSE` rows**: may carry HTML/newline artefacts from the CSV conversion; the
  `.xlsx` original is authority (flagged inline in §6b).

Per policy these are recorded, not silently resolved; the trust default (code wins for behaviour/contracts;
statuses.md is TIER-A for status vocabulary) is noted but does not by itself resolve label disputes.

---

## 6. Compliance with hard rules

- No translations invented — every paired row is single-source-backed on both sides; one-sided terms
  moved to `glossary-unpaired-source-terms.md`. ✓
- Every candidate carries source key + exact locator. ✓
- Uncertain pairings kept unresolved/unpaired, not forced. ✓
- No canonical file modified (`glossary-master.csv` / `glossary.md` untouched; only `_ar/evidence/**`
  written). ✓
- Lowercase-only preserved for terms (vendor/product proper names kept as written per the ubiquitous-language
  convention). ✓
- One preferred term per row; alternatives + CZ/RO/MD variants in synonym columns/notes. ✓
- Target-state (`it-zadani`) terms excluded from current-state promotion. ✓

---

## 7. Recommended next step

1. **Run `AR:GlossaryNormalizer` / arbitration triage** over §9 (U1–U8) and §8 (O1–O11): record decisions
   in `_ar/tasks/glossary-arbitration-decisions.md`. Priority: U1 (parent↔fundraiser) and U4
   (group/collection-account) — they touch the highest-traffic party and story vocabulary.
2. **Obtain the missing labels** blocking promotion: CZ UI labels for the back-office roles (U2/U3), a clean
   **MD/RU** status list (U6), and the Moneta country attribution (U8). These are the main gaps preventing a
   complete lean canonical set.
3. **Promote the low-risk clear set** (`jasne` rows not touched by an overloaded/unresolved flag) into
   `glossary-master.csv` — core entities (CN-E01/E04/E08/E11/E13), the TIER-A status vocabulary (§5, the 57
   `jasne` rows), documents/tax (CN-C01/C02/C05/C06/C07/C09/C11), donation/payment (CN-D01/D02/D03/D06–D12),
   and finance/reconciliation (CN-R07/R08/R09/R10/R15) — once a promotion agent confirms none is blocked by
   an open conflict.
4. **Defer** the collection-account story sub-types (U4) until story-type 3/4 evidence exists (the rebuild
   assignment expects these scenarios to be supplied), and the dormant subsystems' terms (Account/rec ML
   model) which are documented but inert.
5. On a later pass, if `intake/process-maps/**` and the Patronus source are brought into a safe/scrubbed
   form, re-run to enrich process-area, role, and RO/MD label coverage; this file is idempotent and will be
   refreshed in place.
