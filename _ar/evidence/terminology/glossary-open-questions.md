# Glossary Open Questions — Patronus (current-state, bid-patron-deti)

> Produced by **AR:GlossaryDriftAnalyzer** · 2026-07-02 · FIRST-TIME BOOTSTRAP run.
> Semantic / concept-boundary conflicts and source disagreements that require **human arbitration**
> before the affected terms may be promoted into `_ar/repo-map/glossary-master.csv`. Per hard-rules
> 5/6: a term whose conflict changes business meaning is raised here (not treated as style drift), and
> distinct concepts are **never** silently collapsed into one glossary entry.
>
> **Routing.** Decisions on every item below must be logged in
> `_ar/tasks/glossary-arbitration-decisions.md` (currently empty). Until an item there is `approved`,
> the disputed term stays out of canonical promotion (source-pack promotion rule).
>
> Two classes are recorded: **(A) overloaded terms** — one label, several distinct concepts (from
> candidates §8 / DUL §2); **(B) unresolved pairings / source conflicts** (from candidates §9). They
> map to drift category **C4 (ambiguous concept boundary)** in `glossary-drift-report.md`.

---

## A. Overloaded terms — one label, multiple distinct concepts

> These must be promoted (if at all) as **separate** rows, each qualified. Never mint a bare preferred
> row for the overloaded word itself.

### O1 — "campaign" / "story" / "collection-account"  *(highest priority)*
- **Conflict.** (1) the fundraising **Story/Příběh** domain entity (EN0004); (2) a **marketing**
  campaign (Mautic/Facebook/Analytics, UC0013), which does not use the Story entity; (3) the
  **collection-account story** (story-type 4) conflates with the **transparent/collection account** —
  a single platform Campaign plus bank fields (CN-F05), not a per-story account.
- **Evidence.** DUL §2 "Campaign" / "Story / Story types"; candidates §8 O1, §2 CN-E04/E07, §7 CN-F05.
- **Question for arbiter.** Confirm that "campaign" in the domain glossary always means the Story
  entity; decide how to name the marketing sense so it never collides; and rule that the
  collection-account *story* and the transparent/collection *account* are two concepts.
- **Until decided.** Keep CN-E04 (story), CN-E07 (collection-account story), CN-F05 (transparent
  account) as distinct; do not promote CN-E07 as a confirmed sub-type (see U4).

### O2 — "blog"
- **Conflict.** (1) the custom **Blog** content entity (EN0024, promoted); (2) the CMS **node blog**
  bundle (rejected content).
- **Evidence.** DUL §2 "Blog"; candidates §8 O2, §2 CN-E16, §10.
- **Question.** Confirm only the Blog-entity sense is canonical; is the node blog bundle still in
  active editorial use (DUL open question)?
- **Until decided.** Promote only the Blog entity sense, qualified.

### O3 — "patron"
- **Conflict.** (1) patron **role** on User (EN0008); (2) patron **Contact** (role=patron, EN0006);
  (3) public **Patron profile** entity on a Story (EN0005). Also an ApplicationProfile profile_type
  and a lead_role.
- **Evidence.** DUL §2 "Patron"; candidates §8 O3, §1 CN-P02, §2 CN-E10.
- **Question.** Confirm three distinct records; which (if any) is the source of truth for patron data
  (EN0005 open question)?
- **Until decided.** Always qualify: patron role / patron contact / public patron profile.

### O4 — "account"
- **Conflict.** (1) **Account** entity holding a dormant ML classifier (EN0007); (2) platform user =
  **User/Party** (EN0008); (3) **transparent/collection account** = a platform Campaign + bank fields.
  None is a real bank-account object.
- **Evidence.** DUL §2 "Account"; candidates §8 O4, §2 CN-E19, §1 CN-P07, §7 CN-F05.
- **Question.** Confirm the three senses stay separate; the Account entity is dormant (INV27) — carry
  forward or retire?
- **Until decided.** Say "Account entity (EN0007)" / "User (EN0008)" / "transparent-collection
  account (Campaign)".

### O5 — "partner" / "partners"
- **Conflict.** (1) marketing **Partner** display entity (EN0020); (2) taxonomy **"partners"** bundle
  (rejected); (3) employer **Organisation** (EN0018).
- **Evidence.** DUL §2 "Partner"; candidates §8 O5, §2 CN-E11/E12.
- **Question.** Are both display sources (Partner entity + taxonomy bundle) in active use? Confirm
  Organisation is a separate concept.
- **Until decided.** Do not collapse; disambiguate each.

### O6 — "lead"
- **Conflict.** Back-office **label / intake phase of an Application** (EN0001) — **not** a separate
  entity — vs. marketing "leads" (Facebook Lead Ads / Mautic, UC0013).
- **Evidence.** DUL §2 "Lead"; candidates §8 O6, §2 CN-E02; DK §1 "Lead not a separate entity".
- **Question.** Confirm "lead" is promoted as a **term** but flagged non-entity; keep the marketing
  sense distinct.
- **Until decided.** Keep CN-E02 as a term flagged non-entity.

### O7 — "tax confirmation" vs "tax redirection"
- **Conflict.** CZ **DonationConfirmation** (EN0014, "Potvrzení o daru") vs RO **TaxPayer** (EN0015,
  2%/3.5% redirection). Country counterparts, **not** synonyms.
- **Evidence.** DUL §2 (implicit via EN0014/EN0015); candidates §8 O7, §4 CN-C05/C06.
- **Question.** Confirm they remain two concepts (CZ certificate vs RO redirection payer), not one.
- **Until decided.** Two separate concepts; do not synonym-link.

### O8 — "SmartMailing" / "Mautic"
- **Conflict.** The service is labelled/invoked as "SmartMailing" but the actual outbound transport is
  **Mautic** (EN0022 / UC0012).
- **Evidence.** DUL §2 "SmartMailing"; candidates §8 O8, §6a CN-N09.
- **Question.** Confirm SmartMailing = the transactional-messaging orchestrator over Mautic, not a
  distinct external system.
- **Until decided.** Treat as one system; promote "Mautic" as the transport proper name; record
  "SmartMailing" as the service label/synonym.

### O9 — "scoring" / "ScoringRecord"
- **Conflict.** Live scoring = JSON on the Application (EN0001) vs a separate **scoring entity**
  (EN0017) defined for a REST/low-risk read path but never written (dormant carrier). Also **manual**
  scoring (→ scoring-ok) vs **auto low-risk** recalc (on to-check).
- **Evidence.** DUL §2 "scoring / ScoringRecord"; candidates §8 O9, §7 CN-R01/R02/R03.
- **Question.** Which representation is canonical for the glossary; is the dormant scoring entity
  carried forward?
- **Until decided.** Qualify "live scoring (JSON)" vs "scoring entity (dormant, EN0017)".

### O10 — "blacklist" / "whitelist"
- **Conflict.** `blacklist_type` values wl-zd (ZD), wl-z (Z), wl-n (N) are **white-list** tiers; bl is
  the actual **Black List**. Same enum on Blacklist entry (EN0016) and Contact (EN0006).
- **Evidence.** DUL §2 "Blacklist classification"; candidates §8 O10, §7 CN-R04.
- **Question.** Confirm the naming: never "blacklisted" — always name the tier (ZD/Z/N/Black List).
- **Until decided.** Do not promote a bare "blacklist" concept; name tiers.

### O11 — "status"
- **Conflict.** (1) Application state / moderation state (~66-state workflow, EN0001); (2) Campaign
  status (EN0004); (3) Transaction ext-status (gateway); (4) RecurringTransaction / Voucher status
  booleans; (5) a publish "status" flag; and several status keys pointing at **undefined** fields
  (dead scaffolding).
- **Evidence.** DUL §2 "status"; candidates §8 O11, §5 vs CN-D10; EN0001 open questions.
- **Question.** Ratify that "status" is always qualified by entity in every layer; confirm the
  Application state-vs-moderation-state authority (EN0001 recorded conflict).
- **Until decided.** Never promote a bare "status" row; the per-entity status concepts stay separate.

### Extra DUL-only overloads (recorded, same treatment)
- **"model"** — the serialized ML classifier stored on **both** Account (EN0007) and User (EN0008) for
  the **dormant** recommendation subsystem, vs. a generic "domain model". Which storage is
  authoritative is open; subsystem is dormant (UC0021 / FLW0030). Do not promote "model" as a domain
  term without the "ML classifier (dormant)" qualifier. *(DUL §2 "model")*
- **"applied" (Voucher)** — the "applied" timestamp is written at **two** events (PAID-promotion and
  redemption). Which is authoritative for "redeemed-on" reporting is open. Distinguish
  purchase-confirmation time from redemption time. *(DUL §2 "applied"; EN0013)*

---

## B. Unresolved pairings & source conflicts

> From candidates §9 (U1–U8). Each needs a recorded arbitration decision before promotion.

### U1 — parent ↔ žadatel / fundraiser  *(highest priority)*
- **Issue.** The notification matrix + scenarios use **"Parent"** as the recipient role for what the
  domain calls the **fundraiser** (žadatel / zákonný zástupce). Same party, different label.
- **Evidence.** TSCEN Overview + Notification Matrix; DUL §1 "Fundraiser"; candidates §1 CN-P01, §6a
  CN-N01, unpaired §C (ZZ).
- **Question.** Is "parent / rodič" an **allowed synonym** of `fundraiser`, or a distinct UI-facing
  recipient label to keep separate? Interacts with D5-6 (the ZZ nuance has no distinct EN term).
- **Until decided.** Do not pair CN-N01 (parent recipient) to CN-P01 (fundraiser); keep the notification
  recipient label separate from the domain role.

### U2 — back-office role CZ labels
- **Issue.** `supporter`, `coordinator`, `senior_coordinator`, `accountant`, `content_admin`,
  `manager`, `marketing`, `risk_manager`, `administrator`, `front` are evidenced only as **code
  machine-names**; no confirmed **CZ UI labels** in the safe set.
- **Evidence.** EN0008 `roles`; unpaired §A; candidates §9 U2.
- **Question.** Obtain CZ labels from UI/config. May the EN side be promoted now with "CZ pending"?
- **Until decided.** EN-only; CZ deferred (this is also C5/D5-1).

### U3 — coordinator variants
- **Issue.** code `content_admin` vs "Content Coordinator" (scenarios); "INFO Coordinator",
  "Operations Manager", "Front Coordinator" as scenario roles — mapping to the fixed code role set is
  unclear.
- **Evidence.** EN0008; TSCEN BLOCK 4/9/10; candidates §1 CN-P13/P14/P15, §9 U3.
- **Question.** Map each scenario coordinator name to a code role, or confirm they are distinct
  operational roles.
- **Until decided.** Do not promote the scenario role names; hold CN-P13/P14/P15.

### U4 — group story / collection-account story  *(highest priority)*
- **Issue.** Story types **3 (group)** and **4 (collection-account)** are named in the test-scenarios
  README as **missing** scenarios; DUL flags full handling as **Missing evidence** (SRV0005). The
  collection-account story further conflates with the transparent/collection account (O1/O4).
- **Evidence.** TSCEN README; DUL §2 "Story / Story types"; candidates §2 CN-E06/E07, §9 U4.
- **Question.** Do not promote as confirmed sub-types; treat as **open concepts** pending story-type
  3/4 evidence (the rebuild assignment is expected to supply these scenarios).
- **Until decided.** Hold CN-E06 and CN-E07 out of promotion.

### U5 — supporter (role) vs donor
- **Issue.** `supporter` is the auto-granted **User role** (on first PAID transaction); "dárce/donor"
  is the **payment-context party** word. Overlapping but not identical.
- **Evidence.** DUL §1 "Supporter"; candidates §1 CN-P03/P04, §9 U5.
- **Question.** Is "donor" a synonym of "supporter", or a separate (non-role) concept?
- **Until decided.** Record CN-P03 (donor) and CN-P04 (supporter role) as related but distinct.

### U6 — MD (and RU) status labels
- **Issue.** STAT's **MD columns** are sparse and appear to describe a **different** lead/story
  mapping (e.g. "New Applicant", "Score Check", "Request in Progress") rather than a 1:1 MD translation
  of each CZ status; RU (the likely MD publication locale) labels are **absent** from the safe set.
- **Evidence.** `intake/statuses/statuses.md` MD cols (rows 7–19); unpaired §D; candidates §9 U6.
- **Question.** Obtain a clean **MD (and RU)** status list before recording any MD/RU synonyms.
- **Until decided.** Record **no** MD/RU status synonyms (this is also C5/D5-7 — the largest
  publication gap for the RO/MD markets).

### U7 — returned_new_patron reminder ordinals
- **Issue.** STAT attaches EN "1st" to alias `...reminder_2` and "2nd" to `...reminder_1` — crossed
  against the alias numbers.
- **Evidence.** `intake/statuses/statuses.md` rows 62–63; candidates §5 (returned_new_patron_reminder_1/2),
  §9 U7.
- **Question.** Confirm against the `.xlsx` original which ordinal is correct.
- **Until decided.** Record verbatim; do not correct. These 3 status rows are the only ones held back
  from the otherwise-clean TIER-A promotion set (drift D2-1).

### U8 — Moneta AISP country
- **Issue.** SCMAP (derived) labels **MonetaAPI as RO**; DUL/kernel describe **Moneta AISP as the CZ**
  transparent-account import. Source disagreement on country.
- **Evidence.** SCMAP; DUL §1 "Moneta AISP"; candidates §7 CN-R11, §9 U8.
- **Question.** Resolve the country attribution of Moneta before promoting a country tag. (Trust
  default: code wins for behaviour/contracts — but neither of these two sources is the code; both are
  derived/reconstructed, so this needs a source-of-truth check.)
- **Until decided.** Promote "Moneta AISP" as a proper name **without** a country tag; hold the country
  attribution.

---

## C. Recorded conflicts carried from the drafts (no arbitration needed to *document*, but flagged)

These are documented inconsistencies inside the current system itself (not glossary drift), surfaced so
they are visible to whoever arbitrates the above:

- **EN0001 state vs moderation-state (O11).** The framework moderation state is referenced in code but
  not declared as an Application base field, and the publish "status" key has no backing field — so
  whether the domain **state** or the **moderation state** is authoritative is unresolved. Documented
  in DUL "Notes on evidence & confidence" and EN0001 open questions. Affects any promotion of the
  Application-status concept.
- **CampaignLog writer (Hypothesis).** EN0028's writer is not evidenced. The term is promotable as a
  concept but its behavior is Hypothesis-grade.
- **Notification-matrix `CHECK_PARSE` rows.** Some matrix status-message texts may carry HTML/newline
  artefacts from CSV conversion; the `.xlsx` original is authority (TSCEN README). Affects MSG-layer
  text fidelity, not domain-status vocabulary.

---

## D. Arbitration checklist (for `glossary-arbitration-decisions.md`)

| # | Item | Priority | Blocks promotion of |
|---|---|---|---|
| 1 | U1 — parent ↔ fundraiser pairing | **High** | CN-N01, and the CZ label decision around fundraiser/ZZ |
| 2 | U4 — group / collection-account story sub-types | **High** | CN-E06, CN-E07 |
| 3 | O1 — campaign/story/collection-account boundary | High | ties to U4; the marketing-campaign naming |
| 4 | O3/O4/O5 — patron / account / partner tri-senses | Medium | CN-E10/E19, CN-P07, CN-E11/E12, CN-F05 |
| 5 | U8 — Moneta AISP country | Medium | the country tag on CN-R11 |
| 6 | U7 — returned_new_patron ordinals | Medium | the 3 status rows |
| 7 | D2-2/U3 — content_admin ↔ Content Coordinator + coordinator variants | Medium | CN-P13/P14/P15 |
| 8 | U5 — supporter vs donor | Low | the synonym relationship of CN-P03/P04 |
| 9 | O7/O8/O9/O10/O11 + model/applied | Low–Medium | the qualified promotion of each multi-sense term |

**No source was silently resolved and no distinct concepts were collapsed.** Every item above stays out
of `glossary-master.csv` until a matching row in `glossary-arbitration-decisions.md` reaches `approved`.
