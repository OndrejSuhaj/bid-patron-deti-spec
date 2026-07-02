# Glossary Rejected / Blocked Promotions — Patronus (current-state, bid-patron-deti)

> Produced by **AR:GlossaryPromoter** · 2026-07-02 · FIRST-TIME BOOTSTRAP promotion.
> Companion to `glossary-promotion-report.md`. Records every candidate that was **not** promoted into
> `_ar/repo-map/glossary-master.csv` this run, with the reason. Two classes:
> **(B) BLOCKED** — source-backed but sitting under an open semantic conflict (`glossary-open-questions.md`)
> or a Czech-publication gap; stays out until `_ar/tasks/glossary-arbitration-decisions.md` records an
> `approved` decision (that log is **empty today**).
> **(R) REJECTED** — non-canonical (infrastructure / identifiers / value-lists / technical statuses /
> MSG-layer content); never promoted as domain vocabulary.
>
> Nothing here was silently resolved and no distinct concepts were collapsed (hard-rules 2/7).

---

## B. BLOCKED — source-backed, held for arbitration

### B1. Overloaded terms — one label, several concepts (candidates §8 / open-questions §A)

| ref | candidate(s) held | preferred term(s) | why blocked | routed to |
|---|---|---|---|---|
| O1 | CN-E06, CN-E07, CN-F05 | group story / collection-account story / transparent-collection account | "campaign/story/collection-account" spans the Story entity, a marketing campaign, and the transparent/collection *account*; the collection-account *story* conflates with the *account*. Must stay ≥2 rows; marketing-campaign naming undecided. | arbitration O1 (High) |
| O2 | CN-E16 | blog (custom Blog entity) | custom Blog entity vs CMS node blog bundle (rejected); is the node bundle still in active editorial use? | arbitration O2 |
| O3 | CN-E10 | public patron profile | patron **role** promoted as C011; the patron **Contact** and the public **Patron profile** senses stay separate — profile sense held until the source-of-truth for patron data is confirmed. | arbitration O3 |
| O4 | CN-E19 | account (entity) | Account entity (dormant ML) vs User/Party (promoted C013) vs transparent/collection account. Dormant (INV27) — carry-forward or retire undecided. | arbitration O4 |
| O5 | CN-E12 | partner (marketing) | marketing Partner entity vs taxonomy "partners" bundle (rejected) vs employer Organisation (promoted C006). Do not collapse. | arbitration O5 |
| O8 | CN-N09 | Mautic | service labelled "SmartMailing" but transport is Mautic — one orchestrator vs two systems undecided. Held until confirmed; "SmartMailing" would attach as a service-label synonym once ratified. | arbitration O8 |
| O9 | CN-R01 | scoring / risk assessment | live JSON on Application vs dormant scoring entity; manual vs auto low-risk. Which representation is canonical undecided. (The unambiguous sub-facets scoring-outcome and low-risk were promoted as C046/C047.) | arbitration O9 |
| O10 | CN-R04 | blacklist / whitelist classification | `blacklist_type` covers white-list tiers (wl_zd/wl_z/wl_n) **and** the Black List (bl) — never a bare "blacklist" concept; name the tier. | arbitration O10 |
| — (extra) | model | ML classifier (dormant) | serialized classifier stored on both Account and User for the dormant recommendation subsystem; storage authority open; do not promote without the "ML classifier (dormant)" qualifier. | arbitration (Low) |
| — (extra) | applied (voucher) | applied timestamp | written at two events (PAID-promotion + redemption); which is authoritative for "redeemed-on" reporting is open. | arbitration (Low) |

> **O7 and O11 are NOT blocked.** O7 (CZ donation confirmation vs RO tax redirection) is a
> *disambiguation directive* to keep two concepts → promoted as **C027** + **C028** (distinct rows,
> never synonym-linked). O11 ("status" always qualified by entity) is a *directive* satisfied by the
> per-entity status rows C058–C119; no bare "status" row was minted.

### B2. Unresolved pairings & source conflicts (candidates §9 / open-questions §B)

| ref | candidate(s) held | preferred term(s) | why blocked | priority |
|---|---|---|---|---|
| U1 | CN-P01, CN-N01 | fundraiser · parent (recipient) | notification/scenario "Parent" = the domain fundraiser (žadatel / zákonný zástupce); same party, different label — synonym vs distinct UI recipient label undecided. Interacts with the ZZ CZ nuance. | **High** |
| U2 | CN-P09, CN-P10, CN-P11, CN-P12 + code roles supporter/manager/marketing/administrator/front | coordinator · senior coordinator · risk manager · accountant · (+ role machine-names) | only code machine-names evidenced in the safe set; **no CZ UI label**. EN side could be promoted "CZ pending", but promoting an EN-only row into a Czech-target master ships a publication-incomplete concept — held pending CZ labels. | Medium |
| U3 | CN-P13, CN-P14, CN-P15 | content admin · operations manager · info coordinator | scenario role names (Content Coordinator / Operations Manager / INFO Coordinator) not mapped to the fixed code role set; content_admin↔Content-Coordinator identity unresolved (also drift D2-2). | Medium |
| U4 | CN-E06, CN-E07 | group story · collection-account story | story-types 3 & 4 flagged **Missing evidence** (SRV0005); test-scenarios mark their scenarios as missing. Open concepts, not confirmed sub-types. | **High** |
| U5 | CN-P03, CN-P04 | donor · supporter (role) | `supporter` = auto-granted User role; "dárce/donor" = payment-context party word. Overlapping, not identical; synonym relationship undecided. | Low |
| U6 | (all MD/RU status labels) | — | STAT MD block sparse/misaligned (describes a different lead/story mapping); RU absent. **No MD/RU synonym** recorded on any promoted status row. Largest RO/MD publication gap. | Medium |
| U7 | returned_new_patron_reminder_1, returned_new_patron_reminder_2 | application returned - waiting for new patron - reminders | STAT crosses EN "1st"/"2nd" against the alias numbers. The **2 reminder status rows are held** (base `returned_new_patron` promoted as C075). Confirm the `.xlsx` original ordinal. | Medium |
| U8 | CN-R11 | Moneta AISP | SCMAP (derived) says RO; DUL/kernel say CZ transparent-account import. Country attribution disputed; both sources derived → needs a source-of-truth check before a country tag. | Medium |

### B3. Czech-publication gaps — EN evidenced, CZ label not confirmed (drift C5)

Held from promotion because promoting them would require inventing a Czech translation (forbidden,
hard-rule 1) or shipping an EN-only, publication-incomplete row into a Czech-target master.

| candidate | preferred_en | CZ gap | source · locator |
|---|---|---|---|
| CN-E09 | application session | CZ "session" is code-adjacent; no confirmed Czech UI label | candidates §2 CN-E09 |
| CN-D04 | corporate donation | CZ "firemní dar" inferred, not confirmed | candidates §3 CN-D04 |
| CN-N07 | fundraiser zone / parent zone | CZ label to confirm; also interacts with U1 zone naming | candidates §6a CN-N07 |
| (unpaired §C) | zákonný zástupce (ZZ) | CZ-primary; legal-guardian nuance has **no distinct EN** canonical — folds into applicant/fundraiser (interacts with U1) | unpaired §C; STAT `waiting_for_fundraiser` |
| (unpaired §C) | obědy školákům | a CostsSnapshot report-target metric label, not a general concept; EN gloss deferred | unpaired §C; DUL §1 CostsSnapshot |
| (unpaired §C) | Přišly peníze | an operational aviz-subject string, not a concept | unpaired §C; DUL §1 BankTransactionMail |

> Contact `field_name` role tokens (unpaired §B: fundraiser_address2, fundraiser_employer, school,
> undefined) are code discriminator values used as role synonyms of Contact (C014) — not standalone
> concepts; attach as synonyms/notes when relevant, do not mint rows.

---

## R. REJECTED — non-canonical, never domain vocabulary (DUL §3 / candidates §10)

| group | tokens | reason |
|---|---|---|
| Join artifacts | supplier-to-category | relationship artifact, not a concept |
| CZ geo lookups | kraj, obec, okres, psc | reference-data value-lists |
| Taxonomy value-lists | city, category, gift-category, blog-category | reference-data value-lists |
| Config presets | application-statuses (status-group presets) | config, not vocabulary |
| Node bundles | blog, page, page_cz, success_page, form_page | CMS/framework content types |
| Framework infra | media, block_content, file | framework infrastructure |
| Framework carrier | moderation_state | framework carrier of Application state (not a domain term) |
| Infra queues | es-upload-queue, mautic-queue, mailing-queue, training-queue, scoring-queue | infrastructure queues |
| System user id | crm-robot-uid | system identifier |
| Identifier fields | public-id, int-id, message-id, ext-trans-id, slug, uuid, token-id | identifier fields |
| Transport | RabbitMQ (Hypothesis) | transport, not domain |
| Infra tables | email-domain table, campaign-slug-archive, application-states (raw side tables) | infrastructure/raw tables |
| Technical statuses | `draft`, `published` | Drupal content_moderation technical states — non-domain (recorded in candidates §5b for completeness, must not be promoted as domain status vocabulary) |
| MSG-layer content | the 23 (of 117) notification status-message texts (candidates §6b) | message content consumed by the MSG layer, not domain-glossary concepts |

---

## Summary

| Class | Count |
|---|---:|
| Promoted into master | **119** rows (57 concept/notification + 55 TIER-A statuses + 7 code-only statuses) |
| BLOCKED — overloaded (B1) | 9 candidate refs + 2 extra (model, applied) |
| BLOCKED — unresolved pairings (B2) | ~15 candidate refs across U1–U8 (incl. the 2 U7 status rows) |
| BLOCKED — CZ publication gap (B3) | 6 items |
| REJECTED — non-canonical (R) | ~24 token groups + 2 technical statuses + MSG-layer texts |

Every BLOCKED item is routed to `_ar/tasks/glossary-arbitration-decisions.md` (empty today); every
REJECTED item is recorded so no later pass promotes it by accident. Re-run `AR:GlossaryPromoter` after
an arbitration item reaches `approved` — it will refresh the master in place (idempotent) and lift the
newly-unblocked terms.
