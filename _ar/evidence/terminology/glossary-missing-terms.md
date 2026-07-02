# Glossary Missing Terms — Patronus (current-state, bid-patron-deti)

> Produced by **AR:GlossaryDriftAnalyzer** · 2026-07-02 · FIRST-TIME BOOTSTRAP run.
> Two inventories: **(1)** terms used in the drafts / evidence but **absent from
> `_ar/repo-map/glossary-master.csv`** (which currently holds only its header row); and **(2)** terms
> that are missing a **Czech (or MD/RU) equivalent** needed for the Czech `spec-final` publication.
>
> This is a *reporting* artifact — no term here is promoted. It maps to drift categories **C1
> (missing canonical term)** and **C5 (Czech publication gap)** in `glossary-drift-report.md`. Terms
> that are missing *because they are semantically disputed* are NOT listed as simple gaps here — they
> live in `glossary-open-questions.md` (category C4) and must be arbitrated, not merely filled.
>
> Provenance: source keys resolve in `glossary-source-index.md`; candidate ids (CN-*) resolve in
> `glossary-candidates.md`. Every row carries a source + locator.

---

## Part 1 — Terms present in drafts, absent from the glossary master

**Because the master is empty, ALL of the following are missing.** They are grouped by promotion
readiness so a promotion agent can lift the clear set first and hold the rest.

### 1A. Ready to promote — clear (`jasne`), unblocked concepts

> `jasne` candidate rows with both CZ + EN evidenced and no overloaded/unresolved flag. Safe to
> promote as canonical rows now.

| CN id | preferred_en | preferred_cz | source · locator |
|---|---|---|---|
| CN-E01 | application | žádost | DUL §1; STAT (entity=Application) |
| CN-E03 | lead pairing / merge | sloučení leadů | DUL §1; FLIDX FL007 |
| CN-E04 | story (campaign, domain) | příběh | DUL §1; STAT (entity=Story) — promote domain sense only (see O1) |
| CN-E05 | story type | typ příběhu | DUL §1; DK §1 |
| CN-E08 | application profile | profil žádosti | DUL §1; SCMAP |
| CN-E11 | organisation | organizace | DUL §1; SCMAP |
| CN-E13 | supplier | dodavatel | DUL §1; SCMAP |
| CN-E14 | feedback | zpětná vazba | DUL §1; STAT `feedback_sent` |
| CN-E15 | user note | poznámka | DUL §1; SCMAP `user_note` |
| CN-E17 | application log / activity | aktivita | DUL §1; SCMAP `application_log` |
| CN-P05 | child | obdarovaný / dítě | DUL §1; EN0006 `field_name`=child |
| CN-P07 | user (party) | uživatel | DUL §1; EN0008 |
| CN-P08 | contact | kontakt | DUL §1; EN0006 |
| CN-P02 | patron | patron | DUL §1; EN0008 — promote qualified (role sense), see O3 |
| CN-D01 | donation | dar | DUL §1; SCMAP `transaction` |
| CN-D02 | transaction | transakce | DUL §1; SCMAP `transaction` |
| CN-D03 | recurring donation | trvalý dar | DUL §1; TSCEN SC-10E |
| CN-D06 | payment gateway | platební brána | DUL §1; SCMAP |
| CN-D07 | ComGate | ComGate | DUL §1; SCMAP; FLIDX FL021 (proper name) |
| CN-D08 | Netopia / MobilPay | Netopia / MobilPay | DUL §1; SCMAP; FLIDX FL023 (proper name) |
| CN-D09 | MAIB | MAIB | DUL §1; SCMAP; FLIDX FL022 (proper name) |
| CN-D10 | external payment status | platební stav | DUL §1; DK §3.3 |
| CN-D11 | voucher | dárkový poukaz / dobrošek | DUL §1; EN0013 |
| CN-D12 | voucher redemption | uplatnění poukazu | EN0013; FLIDX FL026 |
| CN-C01 | contract | smlouva | DUL §1; SCMAP |
| CN-C02 | contract template | šablona smlouvy | DUL §1; SCMAP `contract_template` |
| CN-C05 | donation confirmation (CZ tax certificate) | potvrzení o daru | DUL §1; EN0014 — distinct from CN-C06 (O7) |
| CN-C06 | tax payer (RO tax redirection) | daňový poplatník (RO) | DUL §1; EN0015 — distinct from CN-C05 (O7) |
| CN-C07 | birth number (RC) | rodné číslo | EN0014; EN0006 |
| CN-C08 | personal numeric code (CNP) | osobní číselný kód (CNP) | EN0015 |
| CN-C09 | confirmation year | rok potvrzení | EN0014 |
| CN-C11 | e-signature | elektronický podpis | DUL §1; FLIDX FL035 |
| CN-R08 | bank reconciliation | párování plateb | DUL §1; SCMAP |
| CN-R09 | variable symbol (VS) | variabilní symbol | DUL §1; SCMAP |
| CN-R10 | bank notification (aviz) | avízo | DUL §1 |
| CN-R15 | CSV export | export CSV | SCMAP `export_csv`; FLIDX FL033 |

### 1B. Ready to promote — TIER-A entity statuses (highest authority)

> `intake/statuses/statuses.md` — the ~57 CZ/EN status rows. All `jasne` **except** the 3 U7
> ordinal-mismatch rows (held back). This is the single cleanest promotion block (CZ + EN both present
> in the authoritative source; RO wording attaches as a locale synonym).

- **Lead (5):** reminder_1, reminder_2, new, canceled_by_user, canceled_lead.
- **Application (~24):** application_processing, to_check, waiting, waiting_reminder_1/2, refiled,
  waiting_for_fundraiser, reminder_1_fundraiser, reminder_2_fundraiser, waiting_for_patron,
  reminder_1_patron, reminder_2_patron, returned_new_patron *(the base row; see U7 for its 2 reminder
  rows)*, in_progress, scoring, scoring_ok, scoring_ko, scoring_waiting, contract, contract_signed,
  suspended, canceled_application, canceled_timeout.
- **Story (~24):** active, campaign_uncompleted, campaign_uncompleted_inprocess, waiting_signature,
  waiting_signature_reminder_1/2, waiting_signature_uncooperative, waiting_for_feetback *(alias typo
  verbatim)*, waiting_feedback_reminder_1/2, waiting_feedback_uncooperative, waiting_for_bill,
  waiting_for_final_doc, gift_paid, uncompleted, suspended_campaign, completed_partly_1, completed,
  canceled_campaign, feedback_to_proccess *(alias typo verbatim)*, feedback_sent, gift_payment, closed,
  completed_partly.
- **No entity type (3):** mistake, duplicate, out_of_scope.
- **Held back (3, → U7):** returned_new_patron_reminder_1, returned_new_patron_reminder_2 (EN
  ordinal/alias mismatch). *(returned_new_patron base row is fine.)*

Source · locator: `intake/statuses/statuses.md` (row per alias); candidates §5.

### 1C. Acceptable as candidates — `prijatelne` (partial) concepts

> Present + source-backed, but one side inferred or analytic. Promotable with a note; lower priority
> than 1A/1B.

| CN id | preferred_en | preferred_cz | why partial |
|---|---|---|---|
| CN-P01 | fundraiser | žadatel | same party as notification "Parent" — pairing flagged (U1) |
| CN-P06 | organisation worker | pracovník organizace | code role `organisation_worker`; CZ label from DUL |
| CN-P09..P14 | coordinator variants, risk manager, accountant, operations manager | (CZ mostly unconfirmed) | back-office roles — CZ label gap (see Part 2) |
| CN-E09 | application session | session žádosti | CZ "session" code-adjacent; CZ UI label to confirm |
| CN-E10 | public patron profile | veřejný profil patrona | distinct from patron role/contact (O3) |
| CN-E12 | partner (marketing) | partner | overloaded (O5) |
| CN-E16 | blog post | blog | overloaded (O2) |
| CN-E18 | campaign log | log příběhu | writer Hypothesis |
| CN-E19 | account (entity) | účet (entita) | dormant; overloaded (O4) |
| CN-E20 | application reaction | reakce na stav | config, not per-app state |
| CN-E21 | application action (auto transition) | automatický přechod stavu | cron rule |
| CN-D04 | corporate donation | firemní dar | CZ inferred |
| CN-D05 | donation type / flags | příznaky daru | flags, not one enum |
| CN-D13 | overpayment split | rozdělení přeplatku | DK INV07; FLIDX FL025 |
| CN-C03 | contract type | typ smlouvy | enum |
| CN-C04 | handover / takeover protocol | protokol o převzetí daru | contract sub-type |
| CN-C10 | contract number | číslo smlouvy | per-year counter (INV22) |
| CN-R01 | scoring / risk assessment | scoring | overloaded (O9) |
| CN-R02 | scoring outcome | výsledek scoringu | ok/ko + low-risk |
| CN-R03 | low risk | low-risk | threshold ≥30 |
| CN-R05 | ARES | ARES | external CZ registry (proper name) |
| CN-R06 | MVČR | MVČR | external ID check (Partial) |
| CN-R07 | ICO (business number) | IČO | CZ company id |
| CN-R11 | Moneta AISP | Moneta AISP | country disputed (U8) |
| CN-R12 | ComGate → bank settlement | vypořádání ComGate → banka | manual form |
| CN-R13 | costs snapshot | náklady / cíle (report) | reporting projection |
| CN-R14 | report snapshot | snímek reportu | reporting projection |
| CN-N04..N09 | email / in-app zone message / status message / fundraiser zone / status-change notification / Mautic | (see candidates §6a) | notification channels + transport |

### 1D. Code-only statuses — candidates, non-authoritative

> `intake/current-solution-analysis/state-map.md` (STMAP, derived). 9 workflow-YAML states beyond the
> TIER-A ~60. Recorded for vocabulary completeness; corroboration only.

- Promotable-as-candidate: communications, taken, canceled, canceled_fundraiser, feedback_received,
  waiting_for_protocol, gift_confirmation_approved.
- **Do NOT promote as domain vocabulary:** `draft`, `published` — Drupal content_moderation technical
  states (non-domain).

Source · locator: STMAP "Jen v kódu"; candidates §5b.

### 1E. Explicitly NOT missing — do not promote

> Recorded so a promotion agent does not treat these as gaps to fill.

- **Overloaded / unresolved** (C4): the 11 overloaded terms (O1–O11) + `model` + `applied` + the 8
  unresolved pairings (U1–U8) — held for arbitration (`glossary-open-questions.md`).
- **Rejected / non-canonical** (DUL §3 / candidates §10): supplier-to-category; kraj/obec/okres/psc;
  city/category/gift-category/blog-category taxonomies; application-statuses config; node bundles
  (blog/page/page_cz/success_page/form_page); media/block_content/file; moderation_state;
  es-/mautic-/mailing-/training-/scoring-queue; crm-robot-uid; public-id/int-id/message-id/
  ext-trans-id/slug/uuid/token-id; RabbitMQ; email-domain table; campaign-slug-archive/
  application-states side tables. **Infrastructure / identifiers / value-lists — not domain vocabulary.**
- **MSG-layer texts** (candidates §6b): the 23 (of 117) notification status-message strings are
  **message content**, consumed by the MSG layer — not domain-glossary concepts.

---

## Part 2 — Terms missing a Czech (or MD/RU) equivalent for publication

> `spec-final` publishes in **Czech**; the RO/MD markets need MD/RU. The following EN-canonical
> concepts lack a **source-backed** Czech (or MD/RU) label in the safe set. Inventing a translation is
> forbidden (hard-rule 1 / source-pack). These block publication-completeness even when the EN row is
> promotable. Maps to drift **C5**.

### 2A. Back-office roles — CZ label missing (EN-only in the safe set)

| EN term (code machine-name) | CZ status | source · locator |
|---|---|---|
| supporter (role) | **CZ label missing** | unpaired §A; DUL §1; EN0008 `roles` |
| coordinator | CZ label missing (only "koordinátor" assumed) | unpaired §A; EN0008 `roles` |
| senior coordinator | CZ label missing | unpaired §A; EN0008 `roles` |
| accountant | CZ label missing | unpaired §A; EN0008 `roles` |
| content admin | CZ label missing (+ name conflict "Content Coordinator", U3) | unpaired §A; EN0008; TSCEN BLOCK 9 |
| manager | CZ label missing | unpaired §A; EN0008 `roles` |
| marketing | CZ label missing | unpaired §A; EN0008 `roles` |
| risk manager | CZ label missing | unpaired §A; EN0008 `roles` |
| administrator | CZ label missing | unpaired §A; EN0008 `roles` |
| front (role) | CZ label missing (ambiguous stem) | unpaired §A; EN0008 `roles` |
| operations manager | CZ + code-role missing | unpaired §A; TSCEN SC-10C |
| info coordinator | CZ + code-role missing | unpaired §A; TSCEN SC-10G |

**Resolution:** obtain CZ UI labels from config/UI. EN rows may be promoted with a "CZ label pending"
note, but are **not** Czech-publication-complete.

### 2B. Inferred / unconfirmed CZ labels

| EN term | CZ status | source · locator |
|---|---|---|
| application session (CN-E09) | CZ "session" code-adjacent — confirm Czech UI wording | candidates §2 CN-E09 |
| corporate donation (CN-D04) | CZ "firemní dar" inferred — confirm UI wording | candidates §3 CN-D04 |
| fundraiser zone / parent zone (CN-N07) | CZ label to confirm | candidates §6a CN-N07 |

### 2C. CZ-primary terms with no distinct EN canonical (EN side deferred)

| CZ term | EN status | source · locator |
|---|---|---|
| zákonný zástupce (ZZ) | folds into "applicant/fundraiser" — the legal-guardian nuance has **no distinct EN** | unpaired §C; STAT `waiting_for_fundraiser`; TSCEN — interacts with U1 |
| obědě školákům *(sic: "obědy školákům")* | a report-target metric label, EN gloss deferred (not a general concept) | unpaired §C; DUL §1 CostsSnapshot |
| Přišly peníze | an operational aviz-subject string, not a concept | unpaired §C; DUL §1 BankTransactionMail |

### 2D. MD / RU locale — whole-block gap (largest publication gap)

- The **MD status block** in `intake/statuses/statuses.md` is **sparse and misaligned** — its columns
  describe a *different* lead/story categorization (e.g. "New Applicant", "Request in Progress",
  "Score Check", "Score OK/KO", "Story Successfully Completed") rather than a per-status MD translation
  of the ~60 CZ statuses.
- **RU** (the likely MD publication locale per SCMAP languages `cs/en/ro/ru`) status labels are
  **entirely absent** from the safe source set.
- **Consequence:** **no MD or RU status synonym** can be recorded until a clean MD/RU status list is
  supplied. For MD-market publication this is the single largest gap.

Source · locator: `intake/statuses/statuses.md` MD columns (rows 7–19); unpaired §D; candidates §9 U6.

---

## Part 3 — Coverage assurance (nothing dropped)

- **DUL §1 (48 concepts):** all covered by a candidate row (Part 1A/1C) or intentionally held as
  overloaded/rejected (Part 1E). No DUL concept is unaccounted for.
- **EN0001..EN0032 (32 owning entities):** all represented — no owning-entity term is missing from the
  candidate set (only from the empty master, which is the whole point of Part 1).
- **TIER-A statuses (~60):** all 57 CZ/EN rows in Part 1B (54 ready + 3 held for U7) + 9 code-only in
  1D; MD/RU deferred in 2D.
- **UC0001..UC0022:** introduce no domain *noun* absent from the candidate set (verbs are process
  vocabulary, correctly not glossary concepts).

**No glossary or draft file was modified by this analysis.**
