# Glossary Candidates — Patronus (current-state, bid-patron-deti)

> Produced by **AR:GlossaryCandidateCollector** · 2026-07-02 · FIRST-TIME BOOTSTRAP run.
> Source-backed terminology candidates with provenance. **This file is not the glossary** — it feeds the
> AR glossary workflow. No candidate here is promoted into `_ar/repo-map/glossary-master.csv`.
>
> **Format.** One preferred term per row. Alternatives / localized labels go in the synonym columns or
> notes. Source keys resolve in `glossary-source-index.md`; every row carries an exact locator.
> `status` uses the working confidence vocabulary: `jasne` (clear, single-source-backed both CZ+EN) ·
> `prijatelne` (acceptable/partial — e.g. one side evidenced, or analytic grouping) · `nevyreseno`
> (unresolved / semantically disputed — kept out of promotion until arbitration).
> Terms lowercase per active policy (proper-noun product/vendor names kept as written).
> `concept_id` is a **candidate** id (CN-*), not a canonical `concept_id`.
>
> **Column legend:** `preferred_cz` | `preferred_en` | `syn_cz` (incl. RO/MD locale-tagged) | `syn_en` |
> `source` | `locator` | `status` | `notes`.

---

## 1. Party / role vocabulary

| concept_id | preferred_cz | preferred_en | syn_cz (+RO/MD) | syn_en | source | locator | status | notes |
|---|---|---|---|---|---|---|---|---|
| CN-P01 | žadatel | fundraiser | zákonný zástupce (ZZ); rodič (test-scénáře: "Parent") | applicant; parent (test-scenario recipient label) | DUL; EN08; TSCEN | DUL §1 "Fundraiser (role)"; EN08 Core Fields `roles` (fundraiser); TSCEN Overview BLOCK 1 (Parent) | prijatelne | Same party across role/Contact/profile. CZ "žadatel" from DUL/Account.type. Test-scenario recipient "Parent" = the fundraiser/legal-guardian channel — pairing Parent↔fundraiser flagged (see §9 U1). Code role machine-name `fundraiser`. |
| CN-P02 | patron | patron | ručitel (kontext záruky); dárce (kontext daru) | guarantor; donor (donation context) | DUL; EN08; SCMAP | DUL §1 "Patron (role)"; EN08 Core Fields `roles` (patron); SCMAP "Patron ručí za příběh" | jasne | "patron" identical CZ/EN. Overloaded across 3 records (role / Contact / public profile) — see §8 O3; qualify in specs. |
| CN-P03 | dárce | donor | přispěvatel | supporter (post-first-payment role) | DUL; TSCEN | DUL §1 "Supporter"; TSCEN SC-8A..SC-10x "Donor" columns | prijatelne | "dárce/donor" is the money-giver in the payment context. Distinct from the `supporter` User role (CN-P04) which is the auto-granted role; recorded as related but not identical. |
| CN-P04 | — (kód: supporter) | supporter (role) | — | | DUL; EN08 | DUL §1 "Supporter"; EN08 Core Fields `roles` (supporter) | prijatelne | User role auto-granted on first PAID transaction (INV21). No confirmed CZ UI label in safe sources → CZ unresolved (see §9 U2). |
| CN-P05 | obdarovaný / dítě | child | dítě; příjemce | beneficiary; recipient (of help) | DUL; EN06 | DUL §1 "Child"; EN06 Core Fields `field_name` = child | jasne | Beneficiary minor; a Contact (role=child), not a User. "dítě" primary CZ. |
| CN-P06 | pracovník organizace | organisation worker | uživatel organizace | org worker; org admin (is-admin) | DUL; EN08 | DUL §1 "Organisation worker"; EN08 Lifecycle (organisation_worker) | prijatelne | CZ "Uzivatele organizace" (worker label) from DUL. Code role `organisation_worker`. |
| CN-P07 | uživatel | user (party) | strana; aktér | party; actor | DUL; EN08 | DUL §1 "User (Party)"; EN08 Description | jasne | First-class party / ownership anchor. Distinct from "účet"/Account (CN-E19) and platform user "account" — see §8 O4. |
| CN-P08 | kontakt | contact | — | party record | DUL; EN06 | DUL §1 "Contact"; EN06 Description | jasne | Universal party store, disambiguated by the party-role discriminator (`field_name`). |
| CN-P09 | koordinátor | coordinator | — | | EN08; TSCEN | EN08 Core Fields `roles` (coordinator); TSCEN SC-4A "Front Coordinator" | prijatelne | Back-office role. CZ label "koordinátor" assumed from code role stem; front vs. content vs. senior coordinator distinguished below. Confirm CZ UI wording (see §9 U2). |
| CN-P10 | senior koordinátor | senior coordinator | — | | EN08 | EN08 Core Fields `roles` (senior_coordinator) | prijatelne | Back-office role machine-name; CZ label unconfirmed in safe sources. |
| CN-P11 | risk manažer | risk manager | risk; RM | | EN08; TSCEN | EN08 Core Fields `roles` (risk_manager); TSCEN BLOCK 5 "Risk Manager" | prijatelne | Back-office risk role. |
| CN-P12 | účetní | accountant | — | | EN08 | EN08 Core Fields `roles` (accountant) | prijatelne | Back-office finance role machine-name. |
| CN-P13 | obsahový administrátor | content admin | obsahový koordinátor | content coordinator | EN08; TSCEN | EN08 Core Fields `roles` (content_admin); TSCEN BLOCK 9 "Content Coordinator" | nevyreseno | Code role is `content_admin`; test-scenarios say "Content Coordinator". Same role or two? → §9 U3. |
| CN-P14 | operations manažer | operations manager | provozní manažer | | TSCEN | TSCEN SC-10C "Operations Manager assigns to story" | prijatelne | Appears in donations flow (assigns collection-account donations to a story). No code-role match confirmed in safe sources. |
| CN-P15 | INFO koordinátor | info coordinator | — | | TSCEN | TSCEN SC-10G "INFO Coordinator" | nevyreseno | Handles donation-confirmation requests. Role identity vs. content/front coordinator unclear → §9 U3. |

---

## 2. Core entities & sub-types

| concept_id | preferred_cz | preferred_en | syn_cz (+RO/MD) | syn_en | source | locator | status | notes |
|---|---|---|---|---|---|---|---|---|
| CN-E01 | žádost | application | RO: solicitare/cerere | request; case | DUL; STAT | DUL §1 "Application (Žádost)"; STAT rows entity=Application | jasne | Core aggregate root. |
| CN-E02 | lead | lead | hlavní lead; duplikát (párování) | — | DUL; DK | DUL §1 "Lead" + §2 "Lead"; DK §1 "Lead not a separate entity" | prijatelne | **Not a separate entity** — the back-office label/intake phase of an Application. Kept as a distinct term but flagged non-entity (see §8 O6). |
| CN-E03 | sloučení leadů | lead pairing / merge | párování leadů | lead merge | DUL; SCMAP | DUL §1 "Lead" (Sloučení leadu); FLIDX FL007 (`/admin/application/form/pairing`) | jasne | Consolidates a duplicate into a surviving main lead. |
| CN-E04 | příběh | story | kampaň; RO/MD: poveste | campaign (domain); collection story | DUL; STAT | DUL §1 "Campaign / Story (Příběh)"; STAT entity=Story | jasne | Public fundraising story. Domain "campaign" = this entity; NOT a marketing campaign — see §8 O1. |
| CN-E05 | typ příběhu | story type | základní / promo / dlouhodobý / krátkodobý | basic / promo / long-term / short-term | DUL; DK | DUL §1 "Story type"; DK §1 "Story type" | jasne | Classification enum; default basic. |
| CN-E06 | skupinový příběh | group story | RO/MD: — | group campaign | DUL; TSCEN | DUL §2 "Story / Story types" (group via self-ref parent); TSCEN README "typ příběhu 3 (skupinový)" | nevyreseno | Group expressed via self-referencing parent (promo/group). Story-type 3. **Missing evidence** on full handling (SRV0005) → open concept, not a confirmed variant (see §9 U4). |
| CN-E07 | sbírkový příběh / sbírkový účet | collection-account story | transparentní účet | collection account | DUL; TSCEN | DUL §2 "Story / Story types" + §1 "Transparent / collection account"; TSCEN README "typ příběhu 4 (sbírkový účet)" | nevyreseno | Story-type 4. Conflates with the transparent/collection *account* (a single platform Campaign, CN-F05), not a per-story account → semantic conflict, do not collapse (see §9 U4 / §8 O1). |
| CN-E08 | profil žádosti | application profile | superprofil; profil (fundraiser/patron) | questionnaire; aprofile | DUL; SCMAP | DUL §1 "ApplicationProfile"; SCMAP "aprofile — monolitický super-profil (125+ sloupců)" | jasne | ~100–125 field questionnaire; two per Application (fundraiser + patron by profile_type). |
| CN-E09 | session žádosti | application session | přístupová session | form session; signing session | DUL; EN08 | DUL §1 "ApplicationSession"; FLIDX FL001 (application_session) | prijatelne | Access/interface-control record. CZ "session" is code-adjacent; confirm a Czech UI label. |
| CN-E10 | veřejný profil patrona | public patron profile | — | patron display profile | DUL | DUL §1 "Patron (public profile)" + §2 "Patron" | prijatelne | Public patron display on a Story (EN0005); distinct from patron role/Contact — §8 O3. |
| CN-E11 | organizace | organisation | zaměstnavatel; Profi organizace (is-profi) | employer; professional partner org | DUL; SCMAP | DUL §1 "Organisation"; SCMAP "organisation" (partnerské organizace/školy) | jasne | Employer/partner-organisation registry. NOT the marketing Partner (CN-E12) — §8 O5. |
| CN-E12 | partner | partner (marketing) | podporují nás | "support us" logo entry | DUL | DUL §1 "Partner" + §2 "Partner / partners" | nevyreseno | Marketing display entity vs. taxonomy "partners" bundle vs. Organisation — three things named partner → §8 O5. |
| CN-E13 | dodavatel | supplier | RO/MD: — | vendor | DUL; SCMAP | DUL §1 "Supplier"; SCMAP "supplier (registr dodavatelů)" | jasne | Gift vendor/registry; where invoice money goes. |
| CN-E14 | zpětná vazba | feedback | poděkování dárcům | donor thank-you | DUL; STAT | DUL §1 "Feedback (post-campaign)"; STAT `feedback_sent` "Zpětná vazba odeslána" | jasne | Post-campaign feedback for donors. |
| CN-E15 | poznámka | user note | poznámka ke kontaktu | note | DUL; SCMAP | DUL §1 "UserNote"; SCMAP "user_note (interní poznámky)" | jasne | Free-text annotation on a Contact ("Poznámka"). |
| CN-E16 | blog | blog post | titulek; hero post | hero post; CTA | DUL | DUL §1 "Blog post" + §2 "Blog" | prijatelne | Custom Blog entity (distinct from CMS node blog bundle — §8 O2). |
| CN-E17 | aktivita | application log / activity | log žádosti | activity note; audit row | DUL; SCMAP | DUL §1 "ApplicationLog (Activity)"; SCMAP "application_log" | jasne | Immutable per-Application activity row ("Aktivity" tab). |
| CN-E18 | log příběhu | campaign log | — | campaign audit | DUL; DK | DUL §1 "CampaignLog"; DK §1 CampaignLog (writer Hypothesis) | prijatelne | Per-Campaign field-change audit; **writer not evidenced** (Hypothesis). |
| CN-E19 | účet (entita) | account (entity) | — | owner-scoped record | DUL; SCMAP | DUL §1 "Account" + §2 "Account"; SCMAP "account (+ tax_payer)" | prijatelne | Thin patron/fundraiser record carrying a dormant ML classifier. NOT a bank account, NOT the platform user — §8 O4. Dormant (INV27). |
| CN-E20 | reakce na stav | application reaction | status reakce; zone status message | status reaction | DUL | DUL §1 "ApplicationReaction" | prijatelne | Config: what happens on a status+role(+initiator). Behaviour config, not per-application state. |
| CN-E21 | automatický přechod stavu | application action (auto transition) | cron akce; Stav původní/cílový | auto action | DUL | DUL §1 "ApplicationAction (Auto status transition)" | prijatelne | Cron rule moving stale Applications; only removePatron action implemented. |

---

## 3. Donation / payment vocabulary

| concept_id | preferred_cz | preferred_en | syn_cz (+RO/MD) | syn_en | source | locator | status | notes |
|---|---|---|---|---|---|---|---|---|
| CN-D01 | dar | donation | příspěvek | payment; transaction | DUL; SCMAP | DUL §1 "Transaction (Donation / Payment)"; SCMAP "transaction — platby/dary" | jasne | Core money record; "dar" CZ. |
| CN-D02 | transakce | transaction | platba | payment | DUL; SCMAP | DUL §1 "Transaction"; SCMAP "transaction" | jasne | The persisted money movement (any incoming). |
| CN-D03 | trvalý dar | recurring donation | opakovaný dar; pravidelný dar; příspěvek | subscription; standing order | DUL; TSCEN | DUL §1 "RecurringTransaction"; TSCEN SC-10E "Regular donation (standing order)" | jasne | Recurring schedule + gateway token; "trvalý/pravidelný dar" CZ. |
| CN-D04 | firemní dar | corporate donation | — | corporate gift | DUL | DUL §1 "Donation type / flags" (type=corporate) | prijatelne | Transaction type corporate; CZ label inferred, confirm UI wording. |
| CN-D05 | příznaky daru | donation type / flags | is-donation / is-voucher / is-recurring / transparentní | donation-kind flags | DUL | DUL §1 "Donation type / flags" | prijatelne | Flags, not one enum, distinguish payment kinds. |
| CN-D06 | platební brána | payment gateway | brána | gateway | DUL; SCMAP | DUL §1 "Payment gateway"; SCMAP "Platební brány" | jasne | External provider, one per region. |
| CN-D07 | ComGate | ComGate | — | Comgate (CZ gateway) | DUL; SCMAP; FLIDX | DUL §1 (ComGate CZ); SCMAP "comgate (CZ)"; FLIDX FL021 | jasne | CZ payment gateway (proper name). |
| CN-D08 | Netopia / MobilPay | Netopia / MobilPay | — | Netopia (RO gateway) | DUL; SCMAP; FLIDX | DUL §1 (Netopia RO); SCMAP "netopia (RO)"; FLIDX FL023 | jasne | RO payment gateway (proper name). |
| CN-D09 | MAIB | MAIB | — | MAIB (MD gateway) | DUL; SCMAP; FLIDX | DUL §1 (MAIB MD); SCMAP "maib (MD)"; FLIDX FL022 | jasne | MD payment gateway (proper name). MD implemented in code (SCMAP note). |
| CN-D10 | platební stav | external payment status | ext-status | payment status | DUL; DK | DUL §1 "Transaction" (ext-status); DK §3.3 states | jasne | PENDING / AUTHORIZED / PAID / CANCELLED / REFUNDED. See §5 for the status literals. |
| CN-D11 | dárkový poukaz | voucher | dobrošek; hodnota (value) | gift voucher; gift card | DUL; EN13 | DUL §1 "Voucher (Dobrošek)"; EN13 Description + Core Fields (price = "Hodnota") | jasne | "Dobrošek" is the primary CZ product name. |
| CN-D12 | uplatnění poukazu | voucher redemption | uplatnit dobrošek | redeem / apply voucher | EN13; FLIDX | EN13 Lifecycle (is_applied 0→1); FLIDX FL026 (`/api/voucher/apply`) | jasne | Redeeming a voucher against a Story. |
| CN-D13 | rozdělení přeplatku | overpayment split | dělení transakce | overpayment split; divide transaction | DK; FLIDX | DK INV07; FLIDX FL025 (`/transaction/form/divide_transaction`) | prijatelne | Excess over a Story target split into a child Transaction to the transparent account. |

---

## 4. Documents, tax & fulfilment vocabulary

| concept_id | preferred_cz | preferred_en | syn_cz (+RO/MD) | syn_en | source | locator | status | notes |
|---|---|---|---|---|---|---|---|---|
| CN-C01 | smlouva | contract | darovací smlouva | donation contract | DUL; SCMAP | DUL §1 "Contract"; SCMAP "contract (+ contract_template)" | jasne | Generated legal document with two-step e-signature. |
| CN-C02 | šablona smlouvy | contract template | — | | DUL; SCMAP | DUL §1 "ContractTemplate"; SCMAP "contract_template" | jasne | Reusable HTML template rendered into a Contract. |
| CN-C03 | typ smlouvy | contract type | dobropis/dodatek (amendment); protokol o převzetí | good/service/transfer/nno/amendment/delivery-note/acceptance-protocol/ukraine | DUL | DUL §1 "Contract type" | prijatelne | Selects template wording + which Application reference slot the document fills. |
| CN-C04 | protokol o převzetí daru | handover / takeover protocol | protokol o převzetí; delivery-note | acceptance protocol; takeover protocol | DUL; STMAP | DUL §1 "Contract" (handover/takeover protocol); STMAP `gift_confirmation_approved` "Potvrzený protokol o převzetí daru" | prijatelne | Contract sub-type; CZ "protokol o převzetí (daru)". Distinct from the tax donation confirmation (CN-C05). |
| CN-C05 | potvrzení o daru | donation confirmation (CZ tax certificate) | daňové potvrzení; rodné číslo; částka | tax confirmation; tax certificate (CZ) | DUL; EN14 | DUL §1 "DonationConfirmation"; EN14 Description ("Potvrzení o daru") + Core Fields (rodne_cislo, "Částka") | jasne | CZ tax donation certificate. CZ-only counterpart to RO TaxPayer (CN-C06) — NOT a synonym, distinct concept. |
| CN-C06 | daňový poplatník (RO přesměrování daně) | tax payer (RO tax redirection) | RO: redirecționare 2% / 3.5%; CNP | 2% / 3.5% tax redirect; RO tax redirection payer | DUL; EN15 | DUL §1 "TaxPayer (RO tax redirection)"; EN15 Description (2% / 3.5%, CNP) | jasne | RO income-tax redirection payer. RO counterpart to CZ confirmation — distinct concept (§8 O7 / EN15). |
| CN-C07 | rodné číslo | birth number (RC) | RČ | personal number (CZ) | EN14; EN06 | EN14 Core Fields `rodne_cislo`; EN06 Core Fields `rc` (Rodné číslo) | jasne | CZ personal/birth number on Contact / DonationConfirmation. |
| CN-C08 | osobní číselný kód (CNP) | personal numeric code (CNP) | RO: cod numeric personal | CNP | EN15 | EN15 Core Fields `numeric_code` = "Personal Numeric Code / CNP" | jasne | RO personal numeric code on TaxPayer. RO counterpart of CZ rodné číslo (CN-C07); distinct. |
| CN-C09 | rok potvrzení | confirmation year | daňový rok | tax year | EN14 | EN14 Core Fields `confirmation_year` | jasne | Tax year a CZ donation confirmation covers. |
| CN-C10 | číslo smlouvy | contract number | public_id / int_id | contract number (per-country) | DUL; DK | DUL §1 "Contract" (per-country number); DK INV22 | prijatelne | Per-year sequential counter; app-level uniqueness only (INV22). |
| CN-C11 | elektronický podpis | e-signature | digitální podpis | digital signature | DUL; FLIDX | DUL §1 "Contract" (two-step e-signature); FLIDX FL035 (sign route) | jasne | Two-step (manager then fundraiser). |

---

## 5. Entity status vocabulary — TIER-A (statuses.md), the ~60 states

> Highest-authority status terms. `alias` is the system machine-name (workflow state key). `preferred_cz`
> and `preferred_en` are STAT's own CZ/EN columns; RO wording (where present) is a locale-tagged synonym.
> Entity type (Lead/Application/Story) is preserved. **MD block is sparse/misaligned and its labels are
> NOT recorded as synonyms here** — see §9 U6. Locator = STAT row alias.

| alias (id) | preferred_cz | preferred_en | RO synonym | entity | source | status | notes |
|---|---|---|---|---|---|---|---|
| reminder_1 | 1. urgence | lead - 1. reminder | solicitant - 1 reamintire | Lead | STAT | jasne | |
| reminder_2 | 2. urgence | lead - 2. reminder | solicitant - 2 reamintire | Lead | STAT | jasne | |
| new | nový | new lead | solicitant nou | Lead | STAT | jasne | |
| canceled_by_user | zrušeno uživatelem | canceled by user | anulat de către utilizator | Lead | STAT | jasne | |
| canceled_lead | zrušený lead | canceled lead | lead anulat | Lead | STAT | jasne | |
| application_processing | zpracování žádosti | application processing | cerere in procesare | Application | STAT | jasne | |
| to_check | ke kontrole | for control | necesită verificare | Application | STAT | jasne | |
| waiting | čeká na doplnění | waiting for additional info | în așteptarea informației adiționale | Application | STAT | jasne | |
| waiting_reminder_1 | čeká na doplnění - 1. urgence | waiting for additional info - 1. reminder | ...- 1 reamintire | Application | STAT | jasne | |
| waiting_reminder_2 | čeká na doplnění - 2. urgence | waiting for additional info - 2. reminder | ...- 2 reamintire | Application | STAT | jasne | |
| refiled | žádost doplněna uživatelem | application - info added by user | solicitare - informatii adaugate de utilizator | Application | STAT | jasne | |
| waiting_for_fundraiser | čeká na žádost ZZ | waiting for applicant | în așteptarea solicitantului | Application | STAT | jasne | ZZ = zákonný zástupce. |
| reminder_1_fundraiser | čeká na žádost ZZ - 1. urgence | waiting for applicant - 1. reminder | ...- 1 reamintire | Application | STAT | jasne | |
| reminder_2_fundraiser | čeká na žádost ZZ - 2. urgence | waiting for applicant - 2. reminder | ...- 2 reamintire | Application | STAT | jasne | |
| waiting_for_patron | čeká na žádost patrona | waiting for patron | în așteptarea persoanei garantă | Application | STAT | jasne | |
| reminder_1_patron | čeká na žádost patrona - 1. urgence | waiting for patron - 1. reminder | ...- 1 reamintire | Application | STAT | jasne | |
| reminder_2_patron | čeká na žádost patrona - 2. urgence | waiting for patron - 2. reminder | ...- 2 reamintire | Application | STAT | jasne | |
| returned_new_patron | vrácená žádost (nový patron) | application returned - waiting for new patron | solicitare returnată (...persoana garantă nouă) | Application | STAT | jasne | STAT swaps the EN "1st/2nd" labels vs the reminder_1/reminder_2 aliases — recorded verbatim; see §9 U7. |
| returned_new_patron_reminder_1 | vrácená žádost (nový patron) - 1. urgence | application returned - waiting for new patron - 2nd | ...2 reamintire | Application | STAT | nevyreseno | EN "2nd" attached to reminder_1 in STAT — label/ordinal mismatch, keep verbatim (§9 U7). |
| returned_new_patron_reminder_2 | vrácená žádost (nový patron) - 2. urgence | application returned - waiting for new patron - 1st | ...1 reamintire | Application | STAT | nevyreseno | EN "1st" attached to reminder_2 in STAT — label/ordinal mismatch (§9 U7). |
| in_progress | příprava příběhu | story processing | procesarea povestii solicitantului | Application | STAT | jasne | |
| scoring | scoring kontrola | scoring control | controlul punctajului | Application | STAT | jasne | |
| scoring_ok | scoring OK | scoring OK | punctaj OK | Application | STAT | jasne | |
| scoring_ko | scoring KO | scoring KO | punctaj KO | Application | STAT | jasne | |
| scoring_waiting | scoring k doplnění | scoring additional info | punctajul urmează să fie finalizat | Application | STAT | jasne | |
| contract | smlouva ke schválení | contract for approval | contract spre aprobare | Application | STAT | jasne | |
| contract_signed | smlouva podepsána žadatelem | contract signed by applicant | contract semnat de solicitant | Application | STAT | jasne | |
| suspended | pozastavená žádost | application on hold | solicitare suspendată | Application | STAT | jasne | |
| canceled_application | zrušená žádost | canceled application | cerere anulată | Application | STAT | jasne | |
| canceled_timeout | zrušená žádost (timeout) | canceled application (timeout) | cerere anulată (timp expirat) | Application | STAT | jasne | |
| active | aktivní příběh | active story | poveste activă | Story | STAT | jasne | |
| campaign_uncompleted | cílová částka nevybrána | target amount not collected | suma tinta nu a fost stransa | Story | STAT | jasne | |
| campaign_uncompleted_inprocess | nesplněný příběh - vypořádání darů | unsuccessful story - donations | poveste fără succes - necesită decontarea donaţiilor | Story | STAT | jasne | |
| waiting_signature | čeká na podpis | waiting for signature | se așteaptă semnătura | Story | STAT | jasne | STAT tags this Story; back-office signature progression drives the Application (INV11) — entity-typing nuance, keep as STAT records. |
| waiting_signature_reminder_1 | čeká na podpis – 1. urgence | waiting for signature - 1. reminder | ...- 1 reamintire | Story | STAT | jasne | |
| waiting_signature_reminder_2 | čeká na podpis – 2. urgence | waiting for signature - 2. reminder | ...- 2 reamintire | Story | STAT | jasne | |
| waiting_signature_uncooperative | čeká na podpis – nespolupracující | waiting for signature - uncooperative | ...- necooperant | Story | STAT | jasne | |
| waiting_for_feetback | čeká na zpětnou vazbu | waiting for feedback | se așteaptă feedback | Story | STAT | jasne | Alias carries source typo `feetback` (preserved verbatim). |
| waiting_feedback_reminder_1 | čeká na zpětnou vazbu – 1. urgence | waiting for feedback - 1. reminder | ...- 1 reamintire | Story | STAT | jasne | |
| waiting_feedback_reminder_2 | čeká na zpětnou vazbu – 2. urgence | waiting for feedback - 2. reminder | ...- 2 reamintire | Story | STAT | jasne | |
| waiting_feedback_uncooperative | čeká na zpětnou vazbu – nespolupracující | waiting for feedback - uncooperative | ...- necooperant | Story | STAT | jasne | |
| waiting_for_bill | čeká na účetní doklad | waiting for accounting doc | în așteptarea facturii/documentului contabil | Story | STAT | jasne | |
| waiting_for_final_doc | čeká na konečný doklad | waiting for final accounting doc | în așteptarea documentului contabil final | Story | STAT | jasne | STMAP: defined but wired to no transition (isolated). |
| mistake | chyba | mistake | greşeală/eroare | (none) | STAT | jasne | Process status; entity blank in STAT. |
| gift_paid | dar uhrazen | gift paid | cadou plătit | Story | STAT | jasne | |
| duplicate | duplikát | duplicate | duplicat | (none) | STAT | jasne | |
| uncompleted | nesplněný příběh | unsuccessful story | poveste fără succes | Story | STAT | jasne | |
| out_of_scope | out of scope | out of scope | scop incompatibil | (none) | STAT | jasne | |
| suspended_campaign | pozastavený příběh | story on hold | poveste suspendată | Story | STAT | jasne | |
| completed_partly_1 | splněný příběh - částečné plnění | successful story - partly | poveste de succes - parțial | Story | STAT | jasne | |
| completed | splněný příběh | successful story | poveste de succes | Story | STAT | jasne | STMAP: no inbound transition (set programmatically/cron). |
| canceled_campaign | zrušený příběh | canceled story | poveste anulata | Story | STAT | jasne | |
| feedback_to_proccess | zpětná vazba ke zpracování | feedback processing | feedback in procesare | Story | STAT | jasne | Alias carries source typo `proccess` (preserved verbatim). |
| feedback_sent | zpětná vazba odeslána | feedback sent | feedback trimis | Story | STAT | jasne | |
| gift_payment | úhrada daru | gift payment | plata cadoului | Story | STAT | jasne | |
| closed | uzavřeno | closed story | poveste finalizata cu succes | Story | STAT | jasne | |
| completed_partly | uzavřeno - částečné plnění | partly closed story | poveste finalizata parțial | Story | STAT | jasne | |

### 5b. Status terms — code-only (TIER-B corroboration: STMAP), beyond STAT's ~60

> These 9 exist in the workflow YAML but have no counterpart in the client status model. CZ labels +
> code provenance from STMAP (derived — corroboration only, not TIER-A). Recorded as candidates so the
> vocabulary is complete; `draft`/`published` are technical (non-domain).

| alias (id) | preferred_cz | preferred_en | source | locator | status | notes |
|---|---|---|---|---|---|---|
| communications | komunikace před žádostí | communications | STMAP | STMAP "Jen v kódu", `communications` | prijatelne | Intake mezistav between lead and application. |
| taken | přebráno | taken | STMAP | STMAP "Jen v kódu", `taken` | prijatelne | Lead taken over by an operator. |
| canceled | zrušeno | canceled | STMAP | STMAP "Jen v kódu", `canceled` | prijatelne | Generic cancel target of `cancel_lead`; distinct from canceled_lead/canceled_by_user. |
| canceled_fundraiser | zrušená žádost (nevyplněno žadatelem) | canceled (applicant did not complete) | STMAP; TSCEN | STMAP `canceled_fundraiser`; TSCEN Notification Matrix row `canceled_fundraiser` | prijatelne | Target of transition from reminder_2_fundraiser. Corroborated by the notification matrix. |
| feedback_received | žadatel poskytl zpětnou vazbu | feedback received | STMAP; TSCEN | STMAP `feedback_received`; TSCEN Matrix `feedback_received` | prijatelne | Mezistav before feedback_to_proccess. |
| waiting_for_protocol | čeká na protokol o převzetí | waiting for handover protocol | STMAP; TSCEN | STMAP `waiting_for_protocol`; TSCEN Matrix `waiting_for_protocol` | prijatelne | Defined but wired to no transition (isolated) per STMAP. |
| gift_confirmation_approved | potvrzený protokol o převzetí daru | gift-handover protocol approved | STMAP; TSCEN | STMAP `gift_confirmation_approved`; TSCEN Matrix `gift_confirmation_approved` | prijatelne | Defined but no transition (isolated) per STMAP. |
| draft | draft | draft (technical) | STMAP | STMAP `draft` | prijatelne | Drupal technical moderation state; NON-DOMAIN (see §10). |
| published | published | published (technical) | STMAP | STMAP `published` | prijatelne | Drupal technical moderation state; NON-DOMAIN (see §10). |

---

## 6. Notification vocabulary — TIER-B (test-scenarios Notification Matrix)

### 6a. Notification recipient roles & channels

| concept_id | preferred_cz | preferred_en | syn_cz | syn_en | source | locator | status | notes |
|---|---|---|---|---|---|---|---|---|
| CN-N01 | rodič (příjemce) | parent (recipient) | žadatel; zákonný zástupce | applicant recipient | TSCEN | TSCEN Matrix col "Recipient role" = Parent | nevyreseno | Notification-matrix recipient label; maps to the fundraiser party but the label differs → pairing to CN-P01 flagged (§9 U1). |
| CN-N02 | patron (příjemce) | patron (recipient) | — | | TSCEN | TSCEN Matrix "Recipient role" = Patron | jasne | Notification recipient = patron party (CN-P02). |
| CN-N03 | dárce (příjemce) | donor (recipient) | — | | TSCEN | TSCEN SC-8..SC-10 "Notification/Email Donor" columns | jasne | Donor notification channel; maps to CN-P03. |
| CN-N04 | e-mail | email (channel) | — | | TSCEN | TSCEN Matrix col "Email" (YES/NO) | jasne | Notification channel. |
| CN-N05 | notifikace v účtu / zóně | user account notification (in-app zone message) | zone status message; notifikace v zóně | in-app notification | TSCEN; DUL | TSCEN Matrix col "User account notification"; DUL §1 "ApplicationReaction" (zone status message) | jasne | The in-app/zone status message channel (Parent Zone / Patron Zone). |
| CN-N06 | status zpráva | status message | zone status message | | TSCEN; DUL | TSCEN Matrix col "Status message"; DUL §1 ApplicationReaction | jasne | Per-status per-role CZ text shown to the recipient. |
| CN-N07 | zóna žadatele | fundraiser zone (parent zone) | patron zóna; supporter zóna | parent zone / patron zone / supporter zone | SCMAP; TSCEN | SCMAP Views (fundraiser_zone/patron_zone/supporter_zone); TSCEN SC-11C/D | prijatelne | Self-service zones per party; CZ label to confirm. |
| CN-N08 | notifikace při změně stavu | status-change notification | event-based notifikace | status notification | DUL; SCMAP | DUL §1 "Transactional message / Notification"; SCMAP "Notifikace" (event-based při změně stavu) | jasne | The transactional message dispatched on a status change. |
| CN-N09 | Mautic | Mautic | SmartMailing (service label) | e-mail automation transport | DUL; SCMAP; TSCEN | DUL §2 "SmartMailing"; SCMAP "Mautic (e-mail automation)"; TSCEN SC-11E | prijatelne | Actual outbound transport; "SmartMailing" is a misleading service label (§8 O8). Proper name. |

### 6b. Notification matrix — status message texts (candidate CZ status-message vocabulary)

> The matrix supplies a CZ status-message string per (status, recipient role). These are **message
> texts**, candidate MSG-layer vocabulary, not new status terms. Recorded compactly; locator = matrix
> row `status | role`. Rows flagged `CHECK_PARSE` in the source may carry HTML/newline artefacts — the
> `.xlsx` original is authority (per TSCEN README). A representative, de-duplicated set:

| status (id) | role | status message (cz) | source | locator | status | notes |
|---|---|---|---|---|---|---|
| active | Parent/Patron | příběh je zveřejněn | TSCEN | Matrix `active` | prijatelne | CHECK_PARSE on both rows. |
| application_processing | Parent | žádost zpracováváme | TSCEN | Matrix `application_processing\|Parent` | jasne | |
| application_processing | Patron | zpracováváme | TSCEN | Matrix `application_processing\|Patron` | jasne | |
| scoring | Parent/Patron | posuzujeme | TSCEN | Matrix `scoring` | prijatelne | CHECK_PARSE on Patron row. |
| scoring_ok | Parent | vaše žádost byla schválena | TSCEN | Matrix `scoring_ok\|Parent` | jasne | |
| scoring_ko | Parent/Patron | neschváleno | TSCEN | Matrix `scoring_ko` | jasne | |
| contract | Parent/Patron | připravujeme smlouvu | TSCEN | Matrix `contract` | jasne | |
| waiting_signature | Parent | nahrajte smlouvu | TSCEN | Matrix `waiting_signature\|Parent` | jasne | |
| waiting_signature | Patron | smlouva k podpisu | TSCEN | Matrix `waiting_signature\|Patron` | jasne | |
| contract_signed | Patron | dar je na cestě | TSCEN | Matrix `contract_signed\|Patron` | jasne | |
| gift_payment | Parent | pořizujeme dar | TSCEN | Matrix `gift_payment\|Parent` | jasne | |
| completed | Parent/Patron | vybráno | TSCEN | Matrix `completed` | jasne | |
| closed | Parent/Patron | splněno | TSCEN | Matrix `closed` | jasne | |
| campaign_uncompleted | Parent | spojíme se s vámi | TSCEN | Matrix `campaign_uncompleted\|Parent` | prijatelne | CHECK_PARSE. |
| duplicate | Parent/Patron | duplikát | TSCEN | Matrix `duplicate` | jasne | |
| out_of_scope | Parent/Patron | zrušená žádost; nemůžeme vám pomoci | TSCEN | Matrix `out_of_scope` | prijatelne | CHECK_PARSE; two-part text. |
| returned_new_patron | Parent | najděte nového patrona | TSCEN | Matrix `returned_new_patron\|Parent` | prijatelne | CHECK_PARSE. |
| waiting_for_patron | Parent | čekáme na patrona | TSCEN | Matrix `waiting_for_patron\|Parent` | jasne | |
| waiting_for_fundraiser | Patron | čekáme na zákonného zástupce | TSCEN | Matrix `waiting_for_fundraiser\|Patron` | prijatelne | CHECK_PARSE; "zákonný zástupce" = ZZ = fundraiser/parent. |
| feedback_sent | Parent | poděkování dárcům odesláno | TSCEN | Matrix `feedback_sent\|Parent` | jasne | |
| waiting_for_feetback | Parent | pošlete své poděkování dárcům | TSCEN | Matrix `waiting_for_feetback\|Parent` | prijatelne | CHECK_PARSE; alias typo preserved. |
| gift_confirmation_approved | Parent | potvrzené převzetí daru | TSCEN | Matrix `gift_confirmation_approved\|Parent` | jasne | Corroborates CN status `gift_confirmation_approved` (§5b). |
| waiting_for_protocol | Parent | doplňte protokol o daru | TSCEN | Matrix `waiting_for_protocol\|Parent` | prijatelne | CHECK_PARSE; corroborates CN `waiting_for_protocol` + CN-C04 protocol. |

> (The matrix holds 117 rows; the full set lives in `intake/test-scenarios/test-scenarios.md` "Notification
> Matrix". The above is a representative candidate slice for the vocabulary pass — the MSG layer will
> consume the full matrix. No status message text was invented.)

---

## 7. Risk / scoring, reconciliation & finance vocabulary

| concept_id | preferred_cz | preferred_en | syn_cz (+RO/MD) | syn_en | source | locator | status | notes |
|---|---|---|---|---|---|---|---|---|
| CN-R01 | scoring | scoring / risk assessment | rizikové skóre | risk scoring | DUL; SCMAP | DUL §1 "ScoringRecord"; SCMAP "scoring" (Risk) | jasne | Two forms: live JSON on Application + a dormant carrier entity (§8 O9). |
| CN-R02 | výsledek scoringu | scoring outcome | scoring OK / KO; low-risk | ok/ko verdict; low-risk score | DUL; DK | DUL §1 "Scoring outcome (ok/ko, low-risk)"; DK INV16 | jasne | Per-party fundraiser/patron/gift verdicts; low-risk threshold ≥30. |
| CN-R03 | low-risk | low risk | nízké riziko | low-risk score | DK; SCMAP | DK INV16 (threshold ≥30); SCMAP workflow scoring phase | prijatelne | Auto-recalc on `to_check`; coordinator decision at ≥30. |
| CN-R04 | black list / white list | blacklist / whitelist classification | ZD / Z / N / Black List | wl_zd / wl_z / wl_n / bl | DUL; EN06 | DUL §1 "Blacklist entry" + §2; EN06 Core Fields `blacklist_type` (wl_zd/wl_z/wl_n/bl) | nevyreseno | The `blacklist_type` label covers white-list tiers too → do not say "blacklisted"; name the tier (§8 O10). |
| CN-R05 | ARES | ARES | — | CZ business registry | FLIDX; SCMAP | FLIDX FL041 (`ares_search_by_ico`); SCMAP integrations | prijatelne | External CZ registry used by scoring. Proper name. |
| CN-R06 | MVČR | MVČR (ID-card verification) | ministerstvo vnitra | interior-ministry ID check | FLIDX | FLIDX FL042 (IdentityCardService, MVČR) | prijatelne | External ID-card verification (Partial confidence). Proper name. |
| CN-R07 | IČO | ICO (business number) | — | company registration number | EN06; FLIDX | EN06 Core Fields `ico` (IČO); FLIDX FL041 (by ico) | jasne | CZ company identifier. |
| CN-F05 | transparentní / sbírkový účet | transparent / collection account | sbírkový účet | collection account (a platform Campaign) | DUL; DK | DUL §1 "Transparent / collection account"; DK §1 (transparent / collection-account campaign) | nevyreseno | A single platform **Campaign** (+ bank-account fields) receiving overpayment split-offs, unattributed bank credits, CZ recurring charges. NOT a per-story account and NOT the Account entity (CN-E19) → §8 O1/O4; do not collapse with the collection-account *story* (CN-E07). |
| CN-R08 | párování plateb | bank reconciliation | párování banka↔platba; párování bez VS | reconciliation; bank settlement | DUL; SCMAP | DUL §1 "Bank reconciliation"; SCMAP "párování v accounting (bez VS)" | jasne | Matching bank/gateway credits to Transactions. |
| CN-R09 | variabilní symbol | variable symbol (VS) | VS; bank-vs | variable symbol | DUL; SCMAP | DUL §1 "Bank reconciliation" (bank-vs); SCMAP "párování bez variabilního symbolu" | jasne | CZ bank matching key. |
| CN-R10 | avízo | bank notification (aviz) | aviz; Přišly peníze | bank-mail | DUL | DUL §1 "BankTransactionMail (Aviz import record)" (aviz; "Přišly peníze") | jasne | Inbound bank-notification e-mail (CZ IMAP import). |
| CN-R11 | Moneta AISP | Moneta AISP | MonetaAPI | bank AISP import | DUL; SCMAP; FLIDX | DUL §1 (Moneta AISP); SCMAP "MonetaAPI (RO)"; FLIDX FL029 | nevyreseno | SCMAP tags MonetaAPI as RO; DUL/kernel describe it as the CZ transparent-account AISP import → source disagreement on country (§9 U8). Proper name. |
| CN-R12 | vypořádání ComGate → banka | ComGate → bank settlement | comgate_to_bank; převod | ComGate transfer sync | DUL; FLIDX | DUL §1 "ComgateBankReconciliation"; FLIDX FL031 (comgatesync) | prijatelne | Manual accounting settlement form; effect lands on Transactions. |
| CN-R13 | náklady / cíle (report) | costs snapshot | obědy školákům; snímek nákladů | costs/targets report input | DUL | DUL §1 "CostsSnapshot" (obědy školákům) | prijatelne | Monthly reporting projection. |
| CN-R14 | snímek reportu | report snapshot | — | report metric snapshot | DUL | DUL §1 "ReportSnapshot" | prijatelne | Key/value reporting projection. |
| CN-R15 | export CSV | CSV export | — | reporting export | SCMAP; FLIDX | SCMAP "export_csv"; FLIDX FL033 | jasne | Reporting export (leaks PII per HS07 — but the term itself is neutral). |

---

## 8. Overloaded / ambiguous terms (recorded, NOT promoted)

> These carry more than one meaning in the current system. Per hard-rule 4/8 they stay flagged; a
> preferred canonical row must **not** be minted until arbitration disambiguates them. Carried verbatim
> from DUL §2 (source: `DUL`, locator `§2` for each) unless another source is cited.

| ref | term | conflicting meanings (summary) | disposition |
|---|---|---|---|
| O1 | campaign / story / collection-account | (1) the Story domain entity; (2) a marketing campaign; and the "collection-account story" conflates with the transparent/collection *account* (one platform Campaign). | keep CN-E04/E07 + CN-F05 distinct; never let "campaign" default to marketing. Arbitration needed for collection-account story. |
| O2 | blog | (1) custom Blog entity (CN-E16); (2) CMS node blog bundle (rejected). | promote only the Blog entity sense, if at all. |
| O3 | patron | (1) role (CN-P02); (2) Contact (role=patron); (3) public patron profile (CN-E10). | three records; always qualify. |
| O4 | account | (1) Account entity (CN-E19); (2) platform user/party (CN-P07); (3) transparent/collection account (CN-F05). | three unrelated things. |
| O5 | partner / partners | (1) marketing Partner entity (CN-E12); (2) taxonomy "partners" bundle; (3) employer Organisation (CN-E11). | disambiguate; do not collapse. |
| O6 | lead | back-office label / intake phase of an Application (CN-E02), not a separate entity; also marketing "leads". | keep as a term but flagged non-entity. |
| O7 | tax confirmation vs. tax redirection | CZ DonationConfirmation (CN-C05) vs RO TaxPayer (CN-C06) are country counterparts, **not synonyms**. | keep as two concepts. |
| O8 | SmartMailing / Mautic | service is labelled "SmartMailing" but transport is Mautic (CN-N09). | SmartMailing = the orchestrator over Mautic, not a distinct system. |
| O9 | scoring / ScoringRecord | live JSON on Application vs. a dormant carrier entity; manual vs auto low-risk. | qualify which representation. |
| O10 | blacklist / whitelist | wl_zd/wl_z/wl_n are white-list tiers; bl is the Black List (CN-R04). | name the tier, never "blacklisted". |
| O11 | status | Application state vs Campaign status vs Transaction ext-status vs boolean publish flag. | never write bare "status"; qualify by entity. See §5 vs CN-D10. |

---

## 9. Unresolved / conflicting candidate pairings (explicitly NOT paired/promoted)

> Kept unresolved per hard-rules 2/4. These need human arbitration (log in
> `_ar/tasks/glossary-arbitration-decisions.md`) before any promotion.

| id | term(s) | issue | source | recommended arbitration |
|---|---|---|---|---|
| U1 | parent ↔ žadatel/fundraiser | The notification matrix + scenarios use "Parent" as the recipient role for what the domain calls the fundraiser (žadatel / zákonný zástupce). Same party, different label. | TSCEN Overview + Matrix; DUL §1 Fundraiser | Decide whether "parent/rodič" is an allowed synonym of `fundraiser`, or a distinct UI-facing recipient label. |
| U2 | back-office role CZ labels | `supporter`, `coordinator`, `senior_coordinator`, `accountant`, `content_admin`, `manager`, `marketing`, `risk_manager`, `administrator`, `front` — only code machine-names are evidenced in the safe set; no confirmed CZ UI labels. | EN08 Core Fields `roles` | Obtain CZ labels from UI/config before promoting CZ preferred terms; EN side may promote as-is. |
| U3 | coordinator variants | "content admin" (code) vs "Content Coordinator" (scenarios); "INFO Coordinator", "Operations Manager", "Front Coordinator" as scenario roles — mapping to the fixed code role set is unclear. | EN08; TSCEN BLOCK 4/9/10 | Map scenario coordinator names to code roles (or confirm they are distinct operational roles). |
| U4 | group story / collection-account story | Story types 3 & 4 are named in the test-scenarios README as **missing** scenarios; DUL flags full handling as Missing evidence (SRV0005). Collection-account story conflates with the transparent/collection account. | TSCEN README; DUL §2 | Do not promote as confirmed story sub-types; treat as open concepts pending evidence. |
| U5 | supporter (role) vs donor | `supporter` is the auto-granted User role; "dárce/donor" is the payment-context party word. Overlap but not identical. | DUL §1 Supporter | Decide whether donor is a synonym of supporter or a separate (non-role) concept. |
| U6 | MD status labels | STAT's MD columns are sparse and appear to describe a different lead/story mapping (e.g. "New Applicant", "Score Check") rather than a 1:1 MD translation of each CZ status; not safely pairable. RU (MD) labels absent from the safe set. | STAT MD block | Obtain a clean MD (and RU) status list before recording MD synonyms. |
| U7 | returned_new_patron reminder ordinals | STAT attaches EN "1st" to `..._reminder_2` and "2nd" to `..._reminder_1` (crossed vs the alias number). | STAT rows | Confirm against the `.xlsx` original which ordinal is correct; recorded verbatim meanwhile. |
| U8 | Moneta AISP country | SCMAP labels MonetaAPI as RO; DUL/kernel describe Moneta AISP as the CZ transparent-account import. | SCMAP; DUL §1 | Resolve the country attribution of Moneta before promoting a country tag. |

---

## 10. Rejected / non-canonical (do NOT promote — recorded to prevent accidental promotion)

> From DUL §3 (source `DUL`, locator `§3`) + technical statuses from STMAP. Infrastructure, CMS/config
> content, reference-data value lists, identifiers, or relationship artifacts — **not** domain vocabulary.

- supplier-to-category (join artifact) · kraj / obec / okres / psc (CZ geo lookup) · city / category /
  gift-category / blog-category (taxonomy value-lists) · application-statuses (config status-group presets) ·
  node bundles (blog / page / page_cz / success_page / form_page) · media / block_content / file
  (framework infra) · moderation_state (framework carrier of Application state) · es-upload-queue /
  mautic-queue / mailing-queue / training-queue / scoring-queue (infra queues) · crm-robot-uid (system
  user id) · public-id / int-id / message-id / ext-trans-id / slug / uuid / token-id (identifier fields) ·
  RabbitMQ (transport, Hypothesis) · email-domain table (infra) · campaign-slug-archive /
  application-states (raw side tables).
- **Technical statuses (STMAP):** `draft`, `published` — Drupal content_moderation technical states,
  non-domain (recorded in §5b for completeness but must not be promoted as domain status vocabulary).

---

## Provenance summary

Every candidate above cites a **source key** (resolved in `glossary-source-index.md`) and an **exact
locator** (section, entity field, workflow alias, matrix row, or route id). No CZ/EN/RO/MD equivalent was
invented: paired rows are backed by a single source stating both sides; single-sided terms are either
recorded with an explicit gap note or moved to `glossary-unpaired-source-terms.md`. Overloaded (§8),
unresolved (§9) and rejected (§10) terms are held out of promotion per the hard rules and the source-pack
promotion policy.
