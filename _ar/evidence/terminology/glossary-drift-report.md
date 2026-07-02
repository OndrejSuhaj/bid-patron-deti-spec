# Glossary Drift Report — Patronus (current-state, bid-patron-deti)

> Produced by **AR:GlossaryDriftAnalyzer** · 2026-07-02 · **FIRST-TIME BOOTSTRAP** run.
> Compares the canonical master `_ar/repo-map/glossary-master.csv` against the collected candidates
> (`glossary-candidates.md` + companions) and the draft/domain vocabulary. This agent **compares and
> reports only** — it does not modify the master, `glossary.md`, or any draft.
>
> **Bootstrap note.** The canonical master currently holds **only its header row** (0 canonical
> concepts). Therefore the overwhelming majority of drift here is, by construction, the category
> **missing canonical term** — every source-backed candidate is "missing" from an empty glossary. That
> is expected on a first-time bootstrap and is not a defect in the drafts. The value this pass adds is
> to *classify* the gap deterministically and to separate mere absence (fill-in work) from the
> genuine **ambiguous concept boundaries** and **Czech publication gaps** that must not be auto-promoted.

---

## 1. Sources compared

| Role | Artifact | State at compare time |
|---|---|---|
| Canonical baseline | `_ar/repo-map/glossary-master.csv` | **header only** — `concept_id,preferred_cz,allowed_synonyms_cz,preferred_en,allowed_synonyms_en,source,locator,status`; **0 data rows** |
| Published glossary | `_ar/repo-map/glossary.md` | **absent** (not yet generated) |
| Candidate set (paired) | `_ar/evidence/terminology/glossary-candidates.md` | 85 concept rows (CN-*), 57 TIER-A status rows, 9 code-only status rows, 23 notification-text rows, 11 overloaded, 8 unresolved, ~24 rejected |
| Candidate companions | `glossary-source-index.md`, `glossary-unpaired-source-terms.md`, `glossary-candidate-report.md` | source-key resolution + unpaired (EN-only / CZ-only / MD-RU gap) inventory |
| Domain vocabulary (PRIMARY) | `_ar/spec-draft/DOMAIN-ubiquitous-language.md` (DUL) | 48 canonical concept rows (§1), 13 overloaded terms (§2), rejected list (§3) |
| Domain corroboration | `_ar/spec-draft/DOMAIN-kernel.md`, `DOMAIN-aggregates.md` | invariants, state machines, aggregate names — corroboration only |
| Entity docs (PRIMARY) | `_ar/spec-draft/EN/EN0001..EN0032` (32 docs) | owning-layer entity definitions; term surface for missing-term detection |
| Use-case docs | `_ar/spec-draft/UC/UC0001..UC0022` (22 docs) | behavior surface; verb/role vocabulary corroboration |
| Status authority (TIER-A) | `intake/statuses/statuses.md` (+ README) | ~60 CZ/EN/RO status terms; MD block sparse/misaligned |
| Notification authority (TIER-B) | `intake/test-scenarios/test-scenarios.md` (Overview + Notification Matrix) | recipient roles, channels, status-message texts |
| Derived corroboration (TIER-B) | `intake/current-solution-analysis/{scope-map,state-map}.md` | process areas, 9 code-only statuses |

**Not read this run** (unchanged from the collector's scope guard): the gitignored Patronus source
tree, `intake/process-maps/**` (binary/out-of-safe-set), `intake/it-zadani/**` (target-state — out of
current-state scope), `intake/meetings/**`.

---

## 2. Drift classification — the deterministic categories

Each drift item is classified into exactly one of the five spec categories. On this bootstrap the
distribution is dominated by C1 (missing) because the glossary is empty; the analytically important
work is C4 (ambiguous concept boundary) and C5 (Czech publication gap), which gate promotion.

| Cat | Category | Count (this run) | Meaning here |
|---|---|---:|---|
| **C1** | missing canonical term | **~150** source-backed candidates | present in candidates/DUL/EN/status/notification sources, absent from the empty master |
| **C2** | inconsistent usage | **3** internal-label inconsistencies | one concept labelled differently across sources, or an ordinal/spelling mismatch within a source |
| **C3** | acceptable synonym use | **~9** localized/role-alias groups | CZ/RO variant or code machine-name used as a synonym of a single concept — no drift, record as synonym only |
| **C4** | ambiguous concept boundary | **11** overloaded terms (+8 unresolved pairings) | one label spans ≥2 distinct concepts, or a pairing is semantically disputed — **must not** be auto-promoted; see open-questions report |
| **C5** | Czech publication gap | **~19** items | EN canonical is evidenced but the CZ (or MD/RU) publication label is not — blocks Czech `spec-final` publication; see missing-terms report |

> The full row-level inventory of C1 (missing) and C5 (CZ gaps) is in `glossary-missing-terms.md`;
> the full C4 (ambiguous) inventory + the 8 unresolved pairings is in `glossary-open-questions.md`.
> This report summarises each category and states the recommended next step.

---

## 3. C1 — Missing canonical terms (expected on bootstrap)

**Finding.** Because `glossary-master.csv` has no data rows, **every** source-backed candidate is a
missing canonical term. These are not "drift" in the corrective sense — they are the backlog of terms
awaiting promotion. Grouped by candidate section:

| Group | Source section | Approx. rows | Promotion readiness |
|---|---|---:|---|
| Core entities & sub-types | candidates §2 (CN-E01..E21); DUL §1; EN0001..EN0032 | 21 | High for the `jasne` entity roots (application, story, contact, transaction, voucher, contract, organisation, supplier); 2 story sub-types blocked (→ C4/U4) |
| Party / role vocabulary | candidates §1 (CN-P01..P15); DUL §1; EN0008 | 15 | EN side promotable; several CZ back-office labels blocked (→ C5) |
| Donation / payment | candidates §3 (CN-D01..D13); DUL §1; EN0009/0010/0013 | 13 | High; 3 gateway proper names (ComGate/Netopia/MAIB) promotable as-is |
| Documents / tax / fulfilment | candidates §4 (CN-C01..C11); DUL §1; EN0011/0012/0014/0015 | 11 | High; CZ confirmation vs RO redirection kept as **two** concepts (→ C4/O7) |
| Risk / reconciliation / finance | candidates §7 (CN-R01..R15, CN-F05); DUL §1; EN0016/0017/0029/0030 | 16 | High for VS/aviz/reconciliation/registries; CN-F05 transparent account blocked (→ C4/O1/O4); Moneta country disputed (→ C4/U8) |
| Notification roles / channels / transport | candidates §6a (CN-N01..N09); TSCEN; DUL | 9 | Channels + Mautic/patron/donor recipients promotable; Parent↔fundraiser pairing blocked (→ C4/U1) |
| **Entity statuses — TIER-A** | candidates §5 (57 rows); `intake/statuses/statuses.md` | 57 | **Highest authority** — the `jasne` status rows are the cleanest promotion set; 3 rows carry an internal EN ordinal mismatch (→ C2/U7) |
| Entity statuses — code-only | candidates §5b (9 rows); state-map.md | 9 | Acceptable as candidates; `draft`/`published` are technical **non-domain** — do NOT promote as domain vocabulary |
| Notification status-message texts | candidates §6b (23 rows); TSCEN Matrix | 23 (of 117) | **MSG-layer** vocabulary, not new status terms — belongs to the message layer, not the domain glossary |

**Impacted draft artifacts:** none require change. The drafts are the *source* of these terms; the gap
is on the glossary side. No EN/UC/DUL edit is warranted by C1.

**Recommended next step (C1).** Run the promotion/normalizer agent to lift the **clear, unblocked**
set into `glossary-master.csv`: the TIER-A `jasne` statuses (§5, ~54 rows after excluding the 3 U7
ordinal-mismatch rows), the `jasne` core entities, the `jasne` donation/document/finance terms, and
the gateway/registry proper names. Explicitly **hold back** every term flagged C4 or C5 below.

---

## 4. C2 — Inconsistent usage (true internal inconsistencies)

These are genuine label inconsistencies (same concept, conflicting rendering) — a small, precise set,
distinct from the mere absence of C1.

| ID | Concept | Inconsistency | Evidence | Disposition |
|---|---|---|---|---|
| D2-1 | `returned_new_patron` reminder ordinals | In `statuses.md`, the EN label "1st" is attached to alias `...reminder_2` and "2nd" to `...reminder_1` — crossed against the alias numbers. | `intake/statuses/statuses.md` rows 62–63; candidates §5 (U7) | Record verbatim; do **not** silently correct. Confirm the `.xlsx` original ordinal (open question U7). |
| D2-2 | `content_admin` (code) vs "Content Coordinator" (scenarios) | The code role machine-name is `content_admin`; the test-scenarios call the same actor "Content Coordinator". Same role or two? | EN0008 `roles`; TSCEN BLOCK 9; candidates §1 CN-P13 (status `nevyreseno`) | Treat as inconsistent usage **and** an open concept-boundary question (U3) until mapping is confirmed. |
| D2-3 | Alias source typos `feetback` / `proccess` | `waiting_for_feetback`, `waiting_feedback_*`, `feedback_to_proccess` carry misspellings in the alias itself. | `intake/statuses/statuses.md` rows 15–18, 54; candidates §5 | **Not a drift to correct** — the alias is the system machine-name and must be preserved verbatim. The CZ/EN *labels* are spelled correctly. Recorded so no one "fixes" the alias. |

**Recommended next step (C2).** For D2-1/D2-2, route to arbitration (see open-questions). For D2-3, add
a standing note to the eventual glossary that alias spellings are system-fixed and verbatim.

---

## 5. C3 — Acceptable synonym use (no drift; record as synonyms)

Multiple labels resolve cleanly to **one** concept — these are *not* drift; they are the synonym
material that belongs in `allowed_synonyms_cz` / `allowed_synonyms_en`, never as competing preferred
rows.

| ID | Concept (preferred) | Acceptable synonyms | Evidence | Note |
|---|---|---|---|---|
| D3-1 | story / příběh (CN-E04) | RO/MD `poveste`; "campaign" (domain sense only) | DUL §1; STAT | RO wording is a locale synonym; "campaign" only in the domain sense — never marketing (→ C4/O1). |
| D3-2 | recurring donation (CN-D03) | trvalý dar; opakovaný / pravidelný dar; "Příspěvek" (price label); subscription; standing order | DUL §1; TSCEN SC-10E | Several CZ renderings of one concept. |
| D3-3 | ~54 TIER-A status rows (§5) | the RO status wordings (e.g. `solicitant nou`, `poveste activă`) | STAT RO column | RO is a locale synonym of each CZ/EN status; **MD wording is NOT** an acceptable synonym here (→ C5/D). |
| D3-4 | voucher / dobrošek (CN-D11) | Dobrošek (primary CZ product name); gift voucher / gift card | DUL §1; EN0013 | "Dobrošek" is the CZ product name for one concept. |
| D3-5 | e-signature (CN-C11) | digitální / elektronický podpis | DUL §1; EN0011 | CZ rendering of one concept. |
| D3-6 | bank reconciliation (CN-R08) | párování plateb / párování banka↔platba / párování bez VS | DUL §1; SCMAP | CZ renderings of one process concept. |
| D3-7 | variable symbol (CN-R09) | VS; variabilní symbol; bank-vs | DUL §1 | One concept, code + CZ + abbrev. |
| D3-8 | bank notification / aviz (CN-R10) | aviz; "Přišly peníze" (matched subject) | DUL §1 | "Přišly peníze" is an operational string, not a separate concept. |
| D3-9 | Contact role tokens (unpaired §B) | `field_name` values: fundraiser-address2 / fundraiser-employer / school / undefined | EN0006 | Code discriminator values used as role synonyms of Contact — not standalone concepts. |

**Recommended next step (C3).** When the owning concept is promoted, attach these as synonyms on that
single row. Do not mint separate rows.

---

## 6. C4 — Ambiguous concept boundaries (DO NOT auto-promote)

**Finding.** 11 overloaded terms (candidates §8 / DUL §2) carry more than one meaning; plus 8
unresolved candidate pairings (candidates §9). These are the semantically load-bearing drift — per
hard-rules 5/6 they are raised as **open questions**, never collapsed into a single glossary entry and
never promoted until arbitration is logged.

| Ref | Overloaded term | Distinct senses (must stay separate) |
|---|---|---|
| O1 | campaign / story / collection-account | Story entity (EN0004) · marketing campaign (UC0013) · collection-account *story* conflated with the transparent/collection *account* (a platform Campaign, CN-F05) |
| O2 | blog | custom Blog entity (EN0024, promoted) · CMS node blog bundle (rejected) |
| O3 | patron | patron **role** (EN0008) · patron **Contact** (EN0006) · public **Patron profile** (EN0005) |
| O4 | account | Account **entity** (EN0007, dormant ML) · platform **User/Party** (EN0008) · transparent/collection **account** (Campaign) — none a real bank account |
| O5 | partner / partners | marketing **Partner** entity (EN0020) · taxonomy "partners" bundle (rejected) · employer **Organisation** (EN0018) |
| O6 | lead | back-office label / intake phase of an **Application** (EN0001), NOT a separate entity · marketing "leads" (UC0013) |
| O7 | tax confirmation vs redirection | CZ **DonationConfirmation** (EN0014) vs RO **TaxPayer** (EN0015) — country counterparts, **not** synonyms |
| O8 | SmartMailing / Mautic | service labelled "SmartMailing" but transport is **Mautic** (EN0022/UC0012) — one orchestrator, not two systems |
| O9 | scoring / ScoringRecord | live JSON on Application (EN0001) vs dormant scoring entity (EN0017); manual scoring vs auto low-risk |
| O10 | blacklist / whitelist | `blacklist_type` covers white-list tiers ZD/Z/N **and** the Black List (bl) — never say "blacklisted", name the tier |
| O11 | status | Application state (~66) · Campaign status · Transaction ext-status · Recurring/Voucher booleans · publish flag · undefined-field scaffolding — never write bare "status" |

Additional DUL-only overloads corroborating the above: **model** (ML classifier duplicated on Account
+ User, dormant) and **applied (Voucher)** (two write events — purchase-confirm vs redemption). These
are recorded as open questions too.

**Impacted draft artifacts:** the drafts already flag each of these (DUL §2, EN open-question
sections) — **no draft edit needed**. The action is glossary-side: keep them out of promotion.

**Recommended next step (C4).** Do NOT promote any C4 term. Route all of O1–O11 + the two extra DUL
overloads + the 8 unresolved pairings (U1–U8) to `_ar/tasks/glossary-arbitration-decisions.md` (empty
today). Priority per the collector: U1 (parent↔fundraiser) and U4 (group/collection-account story) —
highest-traffic vocabulary. Full detail in `glossary-open-questions.md`.

---

## 7. C5 — Czech publication gaps (EN evidenced, CZ/MD label missing)

**Finding.** The final publication (`spec-final`) is Czech; several glossary-controlled EN concepts
lack a **source-backed Czech** label in the safe set, and the MD/RU locale is a whole-block gap. These
block Czech publication and must not be filled by inventing a translation (hard-rule 1 / source-pack
forbidden shortcut).

| ID | EN concept | CZ (or MD/RU) gap | Evidence | Disposition |
|---|---|---|---|---|
| D5-1 | back-office roles: supporter, coordinator, senior coordinator, accountant, content admin, manager, marketing, risk manager, administrator, front | **no confirmed CZ UI label** in the safe set (only code machine-names) | unpaired §A; EN0008 `roles`; candidates §9 U2 | Promote EN side if desired; **defer CZ** until UI/config labels obtained. |
| D5-2 | operations manager, info coordinator | scenario role names with no code-role or CZ confirmation | unpaired §A; TSCEN SC-10C/SC-10G; candidates §9 U3 | Defer both sides pending role-mapping. |
| D5-3 | supporter (role) CZ label | auto-granted role, no CZ UI label; also overlaps "dárce/donor" (U5) | unpaired §A; DUL §1 | Defer CZ; resolve donor-vs-supporter boundary (U5) first. |
| D5-4 | application session (CN-E09) | "session" is code-adjacent; no confirmed Czech UI label | candidates §2 CN-E09 (`prijatelne`) | Confirm a Czech UI wording before publication. |
| D5-5 | corporate donation (CN-D04); fundraiser-zone label (CN-N07) | CZ label inferred, not confirmed | candidates §3 / §6a | Confirm UI wording. |
| D5-6 | zákonný zástupce (ZZ) nuance | CZ-primary; the legal-guardian sense has **no distinct EN** canonical (folds into applicant/fundraiser) | unpaired §C; STAT `waiting_for_fundraiser`; TSCEN | EN-side canonical decision needed; interacts with U1. |
| D5-7 | MD / RU status labels | the **entire MD status block** in STAT is sparse/misaligned (describes a different lead/story mapping, e.g. "New Applicant", "Score Check"); RU absent | `intake/statuses/statuses.md` MD cols; unpaired §D; candidates §9 U6 | Do **not** record any MD/RU status synonym until a clean MD/RU list exists. This is the single largest publication gap for the RO/MD markets. |

**Impacted draft artifacts:** none to edit — the gaps are in the *source evidence*, not in the drafts.

**Recommended next step (C5).** Obtain from the client/UI/config: (a) CZ UI labels for back-office
roles (D5-1/D5-2/D5-3), (b) a clean **MD/RU** status list (D5-7), (c) confirmation of the inferred CZ
labels (D5-4/D5-5). Until then, EN-canonical rows may be promoted with an explicit "CZ label pending"
note, but the row is **not publication-complete** for Czech (or MD/RU) `spec-final`.

---

## 8. Cross-check against DOMAIN vocabulary and EN/UC docs

- **DUL §1 (48 concepts) ↔ candidates §1–§7:** fully covered. Every DUL canonical concept has a
  corresponding candidate row (or is intentionally an overloaded/rejected term). No DUL concept is
  missing from the candidate set, and no candidate concept contradicts its DUL definition.
- **EN0001..EN0032 ↔ candidates:** all 32 owning entities are represented (application, application
  profile, session, campaign/story, patron profile, contact, account, user, transaction, recurring,
  contract, contract template, voucher, donation confirmation, tax payer, blacklist, scoring,
  organisation, supplier, partner, feedback, email archive, user note, blog, application log,
  application reaction, application action, campaign log, bank transaction mail, comgate reconciliation,
  costs snapshot, report snapshot). **No missing owning-entity term.**
- **UC0001..UC0022 ↔ candidates:** the use-case surface introduces no domain *noun* absent from the
  candidate set; UC verbs (submit, orchestrate, assess, reconcile, redeem, anonymize, index, etc.) are
  process vocabulary, not glossary concepts — correctly out of the candidate concept set.
- **Rejected list (DUL §3 / candidates §10):** consistent between the two; the drift analyzer confirms
  none of the rejected tokens (join artifacts, geo lookups, taxonomy value-lists, infra queues,
  identifier fields, `draft`/`published`) should be promoted. Recorded so a promotion agent does not
  accidentally lift them.

**No draft/domain inconsistency requiring a draft change was found.** The single-owning-layer
discipline holds: DUL references EN by `doc_id` and does not restate definitions.

---

## 9. Summary of recommended next steps (by category)

| Cat | Action | Owner agent / route |
|---|---|---|
| C1 | Promote the clear, unblocked set (TIER-A `jasne` statuses; `jasne` core entities/donation/document/finance; gateway/registry proper names) into `glossary-master.csv` | GlossaryNormalizer / promotion agent |
| C2 | Route D2-1 (U7 ordinals) + D2-2 (content_admin↔Content Coordinator) to arbitration; add a verbatim-alias standing note for D2-3 | arbitration log |
| C3 | Attach the localized/role-alias synonyms to their single owning concept at promotion time | GlossaryNormalizer |
| C4 | **Hold from promotion**; log O1–O11 + U1–U8 in `glossary-arbitration-decisions.md`; start with U1 + U4 | human arbitration |
| C5 | Obtain CZ UI labels (roles), a clean MD/RU status list, and confirmation of inferred CZ labels before Czech/MD/RU publication | client / UI-config follow-up |

**Completion state of this pass:** all compared sources listed (§1); drift classified into the five
deterministic categories rather than merely enumerated (§2–§7); semantic/open questions separated into
`glossary-open-questions.md`; missing terms + CZ/MD publication gaps into `glossary-missing-terms.md`;
**no glossary or draft file was modified.**
