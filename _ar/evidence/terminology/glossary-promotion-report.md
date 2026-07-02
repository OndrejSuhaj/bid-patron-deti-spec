# Glossary Promotion Report — Patronus (current-state, bid-patron-deti)

> Produced by **AR:GlossaryPromoter** · 2026-07-02 · **FIRST-TIME BOOTSTRAP** promotion.
> Promotes source-backed, unambiguous candidates from the AR glossary workflow into the canonical
> machine-readable master `_ar/repo-map/glossary-master.csv`. This agent updates the master **only**;
> it does not touch `glossary.md` or any `_ar/spec-draft/**` file.
>
> **Inputs consumed:** `glossary-candidates.md` (85 concept rows + 57 TIER-A statuses + 9 code-only
> statuses + 23 notification texts + 11 overloaded + 8 unresolved + rejected list),
> `glossary-drift-report.md` (C1–C5 classification), `glossary-open-questions.md` (C4 arbitration
> items), `glossary-missing-terms.md` (1A/1B/1C/1D readiness tiers), `glossary-unpaired-source-terms.md`,
> `glossary-source-index.md` (source-key resolution), and `_ar/tasks/glossary-arbitration-decisions.md`
> (**empty — no arbitration approved yet**).

---

## 1. Glossary master — before / after

| Metric | Before | After |
|---|---:|---:|
| Data rows in `glossary-master.csv` | **0** (header only) | **119** |
| Domain / notification concept rows (C001–C057) | 0 | **57** |
| TIER-A entity-status rows (C058–C112) | 0 | **55** |
| Code-only entity-status rows (C113–C119) | 0 | **7** |
| `status = Confirmed` | 0 | 96 |
| `status = Partial` | 0 | 23 |
| Blocked (held for arbitration) | — | 34 concept refs + 3 status rows (see §4) |
| Rejected (non-canonical) | — | ~24 tokens + 2 technical statuses (see §5) |

Schema preserved exactly: `concept_id,preferred_cz,allowed_synonyms_cz,preferred_en,allowed_synonyms_en,source,locator,status`.
`concept_id` assigned as stable `C001…C119`. Lowercase-only preserved for terms; vendor/product proper
names (ComGate, Netopia / MobilPay, MAIB, ARES, MVČR, Moneta) kept as written per the ubiquitous-language
convention. The `status` column uses the AR evidence vocabulary: **Confirmed** (candidate `jasne`,
both CZ+EN single-source-backed) · **Partial** (candidate `prijatelne`, one side inferred/analytic or
derived TIER-B corroboration). No `Uncertain`/`Blocked` rows were written into the master — blocked
candidates are held out entirely and listed in §4 / `glossary-rejected-promotions.md`.

---

## 2. Promoted rows (this run)

All promotions are source-backed on both the CZ and EN sides (or are proper names identical on both
sides) and carry **no** open-question flag from `glossary-open-questions.md`. Grouped by candidate
section; full provenance is in the master CSV `source` + `locator` columns.

### 2A. Clear (`jasne`) concept rows — Confirmed — 44 rows

| concept_id | preferred_en | preferred_cz | candidate |
|---|---|---|---|
| C001 | application | žádost | CN-E01 |
| C002 | lead pairing / merge | sloučení leadů | CN-E03 |
| C003 | story | příběh | CN-E04 (domain sense only, per O1) |
| C004 | story type | typ příběhu | CN-E05 |
| C005 | application profile | profil žádosti | CN-E08 |
| C006 | organisation | organizace | CN-E11 |
| C007 | supplier | dodavatel | CN-E13 |
| C008 | feedback | zpětná vazba | CN-E14 |
| C009 | user note | poznámka | CN-E15 |
| C010 | application log / activity | aktivita | CN-E17 |
| C011 | patron | patron | CN-P02 (role sense, qualified per O3) |
| C012 | child | obdarovaný / dítě | CN-P05 |
| C013 | user (party) | uživatel | CN-P07 |
| C014 | contact | kontakt | CN-P08 |
| C015 | donation | dar | CN-D01 |
| C016 | transaction | transakce | CN-D02 |
| C017 | recurring donation | trvalý dar | CN-D03 |
| C018 | payment gateway | platební brána | CN-D06 |
| C019 | ComGate | ComGate | CN-D07 (proper name) |
| C020 | Netopia / MobilPay | Netopia / MobilPay | CN-D08 (proper name) |
| C021 | MAIB | MAIB | CN-D09 (proper name) |
| C022 | external payment status | platební stav | CN-D10 |
| C023 | voucher | dárkový poukaz (dobrošek) | CN-D11 |
| C024 | voucher redemption | uplatnění poukazu | CN-D12 |
| C025 | contract | smlouva | CN-C01 |
| C026 | contract template | šablona smlouvy | CN-C02 |
| C027 | donation confirmation (CZ tax certificate) | potvrzení o daru | CN-C05 (distinct from C028, O7) |
| C028 | tax payer (RO tax redirection) | daňový poplatník (RO) | CN-C06 (distinct from C027, O7) |
| C029 | birth number (rc) | rodné číslo | CN-C07 |
| C030 | personal numeric code (cnp) | osobní číselný kód (cnp) | CN-C08 |
| C031 | confirmation year | rok potvrzení | CN-C09 |
| C032 | e-signature | elektronický podpis | CN-C11 |
| C033 | bank reconciliation | párování plateb | CN-R08 |
| C034 | variable symbol (vs) | variabilní symbol | CN-R09 |
| C035 | bank notification (aviz) | avízo | CN-R10 |
| C036 | csv export | export csv | CN-R15 |
| C050 | ico (business number) | ičo | CN-R07 |
| C054 | email (channel) | e-mail | CN-N04 |
| C055 | user account notification (in-app zone message) | notifikace v účtu / zóně | CN-N05 |
| C056 | status message | status zpráva | CN-N06 |
| C057 | status-change notification | notifikace při změně stavu | CN-N08 |

> C027/C028 (CZ donation confirmation vs RO tax redirection) are kept as **two separate concepts**
> per the O7 arbitration note — they are country counterparts, never synonym-linked. This is a
> disambiguation directive from the drafts, not an open conflict blocking promotion, so both were
> promoted as distinct rows.

### 2B. Acceptable (`prijatelne`) concept rows — Partial — 13 rows

> Both sides source-backed but one side inferred/analytic, or a proper name at Partial confidence.
> None carries an open-question flag.

| concept_id | preferred_en | preferred_cz | candidate · why Partial |
|---|---|---|---|
| C037 | organisation worker | pracovník organizace | CN-P06 · CZ from DUL, EN from code role |
| C038 | contract type | typ smlouvy | CN-C03 · enum |
| C039 | handover / takeover protocol | protokol o převzetí daru | CN-C04 · contract sub-type |
| C040 | contract number | číslo smlouvy | CN-C10 · per-year counter (INV22) |
| C041 | overpayment split | rozdělení přeplatku | CN-D13 · DK INV07 / FLIDX FL025 |
| C042 | donation type / flags | příznaky daru | CN-D05 · flags, not one enum |
| C043 | application reaction | reakce na stav | CN-E20 · config, not per-app state |
| C044 | application action (auto transition) | automatický přechod stavu | CN-E21 · cron rule |
| C045 | campaign log | log příběhu | CN-E18 · writer Hypothesis |
| C046 | scoring outcome | výsledek scoringu | CN-R02 · ok/ko + low-risk |
| C047 | low risk | low-risk | CN-R03 · threshold >=30 |
| C051 | comgate -> bank settlement | vypořádání comgate -> banka | CN-R12 · manual accounting form |
| C052 | costs snapshot | náklady / cíle (report) | CN-R13 · reporting projection |
| C053 | report snapshot | snímek reportu | CN-R14 · reporting projection |
| C048 | ares | ares | CN-R05 · external CZ registry (proper name) |
| C049 | mvčr (id-card verification) | mvčr | CN-R06 · external ID check (Partial confidence) |

### 2C. TIER-A entity statuses — Confirmed — 55 rows (C058–C112)

The highest-authority status block from `intake/statuses/statuses.md`. All CZ+EN pairs promoted with
the RO wording attached as an `allowed_synonyms_cz` locale synonym (RO-tagged), and the workflow
machine-name alias recorded in the `locator`. **54 aliases** promoted plus the `returned_new_patron`
**base** row (C075) = 55 rows. Alias source typos (`waiting_for_feetback`, `feedback_to_proccess`)
preserved **verbatim** in the locator (per drift D2-3 — the alias is the system machine-name).

- **Lead (5):** C058 reminder_1, C059 reminder_2, C060 new, C061 canceled_by_user, C062 canceled_lead.
- **Application (23):** C063 application_processing, C064 to_check, C065 waiting, C066/C067
  waiting_reminder_1/2, C068 refiled, C069 waiting_for_fundraiser, C070/C071 reminder_1/2_fundraiser,
  C072 waiting_for_patron, C073/C074 reminder_1/2_patron, C075 returned_new_patron (base), C076
  in_progress, C077 scoring, C078 scoring_ok, C079 scoring_ko, C080 scoring_waiting, C081 contract,
  C082 contract_signed, C083 suspended, C084 canceled_application, C085 canceled_timeout.
- **Story (24):** C086 active, C087 campaign_uncompleted, C088 campaign_uncompleted_inprocess, C089
  waiting_signature, C090/C091 waiting_signature_reminder_1/2, C092 waiting_signature_uncooperative,
  C093 waiting_for_feetback, C094/C095 waiting_feedback_reminder_1/2, C096
  waiting_feedback_uncooperative, C097 waiting_for_bill, C098 waiting_for_final_doc, C100 gift_paid,
  C102 uncompleted, C104 suspended_campaign, C105 completed_partly_1, C106 completed, C107
  canceled_campaign, C108 feedback_to_proccess, C109 feedback_sent, C110 gift_payment, C111 closed,
  C112 completed_partly.
- **No entity type (3):** C099 mistake, C101 duplicate, C103 out_of_scope.

### 2D. Code-only entity statuses — Partial — 7 rows (C113–C119)

TIER-B derived corroboration (`state-map.md` = STMAP, several corroborated by TSCEN matrix). Beyond the
TIER-A ~60; recorded so the status vocabulary is complete. CZ label from STMAP; EN label glossed from
the alias. Marked **Partial** because STMAP is derived (not primary).

C113 communications · C114 taken · C115 canceled · C116 canceled_fundraiser · C117 feedback_received ·
C118 waiting_for_protocol (isolated) · C119 gift_confirmation_approved (isolated).

---

## 3. Refreshed rows (this run)

**None.** First-time bootstrap: the master held only its header, so every row is a **create**, not a
refresh. On any re-run this agent will refresh in place by `concept_id` and will not duplicate concepts.

---

## 4. Blocked rows (held for arbitration — NOT promoted)

Per hard-rules 2/7 and the source-pack promotion rule, every candidate touched by an **open semantic
conflict** in `glossary-open-questions.md` (categories §A overloaded / §B unresolved) stays out of the
master until `_ar/tasks/glossary-arbitration-decisions.md` records an `approved` decision. That log is
**empty today**, so all of the following are blocked. Full per-item reasons in
`glossary-rejected-promotions.md`.

| Open-question | Blocked candidates | Reason (summary) |
|---|---|---|
| O1 campaign/story/collection-account | CN-E06 (group story), CN-E07 (collection-account story), CN-F05 (transparent/collection account) | overloaded boundary; marketing-campaign sense undecided; collection-account *story* vs *account* not disambiguated |
| O2 blog | CN-E16 (blog) | custom Blog entity vs CMS node blog bundle — active-use scope open |
| O3 patron (extra senses) | CN-E10 (public patron profile) | patron role (promoted as C011) vs Contact vs public profile — only the role sense is promoted; the profile sense is held |
| O4 account | CN-E19 (account entity) | Account entity vs User/Party (C013) vs transparent account — dormant, carry-forward/retire undecided |
| O5 partner/partners | CN-E12 (partner marketing) | marketing Partner vs taxonomy bundle vs Organisation (promoted as C006) |
| O7 tax confirmation vs redirection | — | resolved as a **disambiguation directive** (keep two concepts) → C027 + C028 promoted separately; nothing blocked |
| O8 SmartMailing/Mautic | CN-N09 (Mautic) | which is the system vs the label undecided; promote pending confirmation |
| O9 scoring/ScoringRecord | CN-R01 (scoring/risk assessment) | live JSON vs dormant entity; which representation is canonical undecided (C046 scoring-outcome + C047 low-risk are the unambiguous sub-facets and were promoted) |
| O10 blacklist/whitelist | CN-R04 (blacklist/whitelist classification) | must name the tier, never "blacklisted"; no bare concept |
| O11 status | — | directive only (always qualify by entity); the qualified per-entity status rows C058–C119 are promoted; no bare "status" row |
| U1 parent ↔ fundraiser | CN-P01 (fundraiser), CN-N01 (parent recipient) | same party, different label — synonym-or-distinct undecided (**High** priority) |
| U2 back-office role CZ labels | CN-P09 coordinator, CN-P10 senior coordinator, CN-P11 risk manager, CN-P12 accountant, CN-P13 content admin, + code roles supporter/manager/marketing/administrator/front | only code machine-names evidenced; **no CZ UI label** in the safe set (C5 publication gap) |
| U3 coordinator variants | CN-P13 (content admin), CN-P14 (operations manager), CN-P15 (info coordinator) | scenario role names not mapped to code roles |
| U4 group / collection-account story | CN-E06, CN-E07 | story-types 3/4 flagged Missing-evidence; open concepts (**High** priority) |
| U5 supporter vs donor | CN-P03 (donor), CN-P04 (supporter role) | overlapping but not identical; synonym relationship undecided |
| U6 MD/RU status labels | (all MD/RU status synonyms) | STAT MD block sparse/misaligned; RU absent — **no MD/RU synonym recorded** on any promoted status row |
| U7 returned_new_patron ordinals | returned_new_patron_reminder_1, returned_new_patron_reminder_2 | EN "1st"/"2nd" crossed against alias numbers; **3 status rows held** (the base C075 is fine) |
| U8 Moneta AISP country | CN-R11 (Moneta AISP) | SCMAP says RO, DUL/kernel say CZ — country attribution disputed |
| extra: model | (ML classifier term) | dormant subsystem; storage authority open |
| extra: applied (voucher) | (redeemed-on facet) | two write events; authoritative one open |

C5 Czech-publication-gap items that also lack a CZ label (CN-E09 application session, CN-D04 corporate
donation, CN-N07 fundraiser/parent zone) are held from promotion until a CZ UI label is confirmed —
promoting them would either invent a translation (forbidden hard-rule 1) or ship an EN-only,
publication-incomplete row into a Czech-target master. Recorded in `glossary-rejected-promotions.md`.

---

## 5. Rejected rows (non-canonical — NOT promoted)

Per hard-rule 1 and DUL §3 / candidates §10, the following are **not domain vocabulary** and must not
be promoted. Recorded so no future pass lifts them by accident (full list in
`glossary-rejected-promotions.md`):

- **Infrastructure / framework:** node bundles (blog/page/page_cz/success_page/form_page),
  media/block_content/file, moderation_state, es-/mautic-/mailing-/training-/scoring-queue, RabbitMQ,
  email-domain table, crm-robot-uid.
- **Identifiers:** public-id / int-id / message-id / ext-trans-id / slug / uuid / token-id.
- **Reference-data value-lists:** kraj / obec / okres / psc (geo), city / category / gift-category /
  blog-category taxonomies, application-statuses config presets, supplier-to-category join,
  campaign-slug-archive / application-states side tables.
- **Technical statuses (non-domain):** `draft`, `published` (Drupal content_moderation states) — held
  out even though they appear in the code-only status set (§5b of candidates).
- **MSG-layer content, not glossary:** the 23 (of 117) notification status-message texts (candidates
  §6b) are message content consumed by the MSG layer, not domain-glossary concepts — not promoted here.

---

## 6. Required human follow-up

| # | Item | Priority | Unblocks |
|---|---|---|---|
| 1 | Arbitrate **U1** (parent ↔ fundraiser pairing) in `glossary-arbitration-decisions.md` | **High** | CN-P01 fundraiser + CN-N01 parent recipient + the ZZ CZ nuance |
| 2 | Arbitrate **U4 / O1** (group + collection-account story sub-types; marketing-campaign naming) | **High** | CN-E06, CN-E07, and the transparent-account CN-F05 boundary |
| 3 | Obtain **CZ UI labels** for back-office roles (U2/U3) + confirm inferred CZ labels (application session, corporate donation, fundraiser zone) | Medium | CN-P03/P04/P09–P15, CN-E09, CN-D04, CN-N07 |
| 4 | Resolve **U8** Moneta AISP country attribution (source-of-truth check; both sources are derived) | Medium | the country tag on CN-R11 |
| 5 | Confirm **U7** returned_new_patron ordinals against the `.xlsx` original | Medium | the 2 held reminder status rows |
| 6 | Rule on **O3/O4/O5/O8/O9/O10** tri-sense terms + model/applied | Low–Medium | CN-E10/E12/E19, CN-N09, CN-R01/R04 |
| 7 | Obtain a clean **MD/RU status list** (U6) | Medium (RO/MD publication) | MD/RU status synonyms on C058–C119 |

**Recommended next step.** Log the High-priority items (U1, U4/O1) in
`_ar/tasks/glossary-arbitration-decisions.md`; once an item there reaches `approved`, re-run
`AR:GlossaryPromoter` — it will refresh the affected rows in place by `concept_id` (idempotent) and lift
the newly-unblocked terms. After promotion stabilises, run the glossary publisher to regenerate
`_ar/repo-map/glossary.md` from this master.

---

## 7. Compliance with hard rules

1. **Provenance on every promoted row** — each carries `source` + `locator`. ✓
2. **No blocked term promoted** — all C4/§A/§B open-question terms held; arbitration log empty. ✓
3. **One preferred CZ + one preferred EN per row** — enforced (alternatives/RO in synonym columns). ✓
4. **Synonyms stored separately** — `allowed_synonyms_cz` / `allowed_synonyms_en`; RO tagged; CZ/RO/MD
   variants never in a preferred field. ✓
5. **Lowercase-only preserved** — terms lowercased; vendor/product proper names kept as written. ✓
6. **No existing rows deleted** — bootstrap; only creates. ✓
7. **Source-backed-but-ambiguous rejected** — U1–U8 + O1–O11 + model/applied held, recorded. ✓
8. **No draft artifact modified** — writes confined to `_ar/repo-map/**` + `_ar/evidence/**`. ✓

**Idempotency.** Re-running refreshes in place by `concept_id`; no duplicate concept rows, no renamed
report variants.
