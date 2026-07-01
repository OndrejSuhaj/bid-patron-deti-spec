# Scope-mapa současného řešení (patronus)

> Rozsah stávající Drupal platformy z prvního (inventářového) průchodu. Current-state, ne cílový stav. Zdroj: [`../current-solution/_source/patronus/`](../current-solution/).

## Funkční oblasti (přehled 52 modulů)

| Oblast | Moduly | Jádro |
|---|---|---|
| **Jádro — Žádost** | `application`, `application_action`, `application_log`, `application_reaction`, `patron_base`, `patron_form_access` | Životní cyklus žádosti o pomoc; `application` je srdce (nejvíc tříd, revizní entita). |
| **Patroni / dárci** | `campaign` (obsahuje `PatronEntity`), `patron_actions` | Patron ručí za příběh; vazba patron → žádost/kampaň. |
| **Finance / platby** | `transaction`, `transaction_recurring`, `accounting`, `bank_integration`, `donation_confirmation`, `voucher`, `account` | Transakce, opakované dary, párování banka↔platba, potvrzení darů, vouchery, daňové účty. |
| **Platební brány** | `comgate` (CZ), `monetaapi` (RO), `netopia` (RO), `maib` (MD) | Multi-tenant platby — brána per země. |
| **Risk** | `scoring`, `blacklist` | Scoring žadatelů/patronů, black/white listy. |
| **Dodavatelé / partneři** | `supplier`, `organisation`, `partner`, `contract` | Registr dodavatelů (kam jdou peníze na fakturu), partnerské organizace/školy, smlouvy + šablony. |
| **Kampaně** | `campaign`, `campaign_log`, `campaign_recommendation` | Příběhy/sbírky, audit, doporučování. |
| **Notifikace** | `notification`, `email`, `telegram_integration`, `slack_integration` | Event-based notifikace při změně stavu; e-mail šablony/log; provozní logy do Telegramu/Slacku. |
| **Marketing** | `mautic`, `facebook_leads`, `campaign_recommendation` | E-mail automation, import leadů z Facebook Ads. |
| **Obsah / CMS** | `blog`, `patron_gutenberg`, `patron_gutenberg_cz`, `contact`, `feedback` | Editorský obsah (Gutenberg), blog, kontakty, zpětná vazba. |
| **Vyhledávání** | `patron_search`, `elasticsearch` | Fulltext přes Elasticsearch (fronta na indexaci). |
| **Reporting / audit** | `reports`, `login_history`, `user_note` | Snapshoty a cost reporty, historie přihlášení, interní poznámky. |
| **Compliance / geo / util** | `gdpr`, `zip`, `export_csv`, `sitemap`, `onedrive`, `simple_image_rotate`, `alter_entity_autocomplete`, `patron_tracking`, `patron_devel` | GDPR mazání dat, CZ geografie (kraj/okres/PSČ/obec), export, SEO, OneDrive sync; `patron_devel` = jen debug. |

## Doménový model (~29 custom entit)

**Jádro:**
- `application` — žádost o pomoc (revizní entita, stavový workflow); `application_profile` / `aprofile` — **monolitický „super-profil"** (125+ sloupců: fundraiser, patron, dítě, dar, scoring); `application_session` — session.
- `campaign` — příběh/sbírka (cílová částka, deadline, kategorie, status); `patron` — patron (oddělen od Drupal user).
- `contact` — sdílená kontaktní entita (fundraiser / patron / dítě / škola / organizace).
- `transaction`, `transaction_recurring` — platby/dary; `voucher` — dárkové kódy.

**Podpůrné:** `supplier` (+`supplier_to_category`), `organisation`, `partner`, `contract` (+`contract_template`), `account` (+`tax_payer`), `scoring`, `blacklist`, `email`, `feedback`, `donation_confirmation`, `user_note`, `application_action`, `application_reaction`, `application_log`, `campaign_log`, `transaction_mails` (bank sync), `transaction_com_to_bank` (matching), `costs` + `snapshot` (reporty), `application_statuses` (stavové skupiny), geo entity (`kraj`, `okres`, `psc`, `obec`).

## Externí integrace

- **Platby:** Comgate (CZ), MonetaAPI (RO), Netopia (RO), MAIB (MD) — pozor: **MD (maib) je v kódu implementována**, ačkoli intake `statuses` značil MD místy jako draft.
- **Banka:** `bank_integration` — synchronizace transakcí (z e-mailů), párování v `accounting` (bez VS — odpovídá procesním mapám „párování bez variabilního symbolu").
- **Marketing/CRM:** Mautic (e-mail automation), Facebook Lead Ads (webhook + REST import).
- **Notifikace/provoz:** Slack, Telegram (error/event logy).
- **Ostatní:** Elasticsearch (fulltext), Microsoft OneDrive (dokumenty).

## Config landscape

- **Node types (CMS):** `page`, `page_cz` (oddělený typ, ne překlad — signál country-specific struktury), `blog`, `form_page`, `success_page`.
- **Taxonomie:** `category` (kategorie darů: zdraví, rodina, vybavení, vzdělání, sport, volný čas), `city`, `housing_type`, `income_type` (socioekonomika), `gift_confirmation`, + pomocné (`blog_category`, `faq_categories`, `voucher_types`).
- **Workflow:** jeden `application_workflow` s **65+ stavy** a ~80 přechody — tři fáze: intake (`new` → `communications` → `application_processing`) → scoring (`scoring_ok`/`ko`/`waiting`/`control`) → kontrakt & plnění (`contract` → `waiting_signature` → `gift_payment` → `gift_paid` → `closed`/`completed`). Automatické eskalace `reminder_1`/`reminder_2` (odpovídá urgence/timeout vzorům z procesních map). **Řádově sedí na ~60 stavů z intake `statuses`.**
- **Stavové skupiny:** `patron_base.application_statuses.*` — stav se pro reporting neřeší polem, ale konfiguračními skupinami (funnel kroky, měsíční reporty, org statistiky, leady).
- **REST povrch:** ~80 `rest.resource.*`, verzované (`_v20`…`_v33`) — aplikace, kampaně, auth (login/token/password/magic-link/activation), transakce/vouchery, kontakty, admin (scoring, organizace, dodavatelé). Koexistence verzí = evoluce bez plného deprecation (headless FE + integrace).
- **Views:** ~45 (leady, náklady, platby, dary, scoring, smlouvy, dodavatelé, vouchery, + zóny `fundraiser_zone`/`patron_zone`/`supporter_zone`).
- **Jazyky:** `cs`, `en`, `ro`, `ru` (RU pravděpodobně pro MD); per-entity translatable (application, campaign, contact); témata `patron_cz`, `patron_ro`; overrides v `sync_config/config_czech/`.

## Objemy dat (signál pro odhad/migraci)

Z DB schématu (`__source/schema/`) — orientační řádové počty: `application_states` ~892k, `transaction` ~196k, `aprofile` ~105k, `application` ~51k, `campaign` ~21k. Duální tracking stavu (`application_states` tabulka vedle workflow) a vnořené inline entity formuláře (contact + dítě uvnitř žádosti) → **migrace dat bude netriviální**.

## Pasti / co ověřit v hloubce

- **`aprofile` super-profil** (125+ sloupců) — monolit; rozpad na fundraiser/patron/dítě/dar je otevřená příležitost.
- **65+ stavů v jednom workflow** — krajní případ; testovací pokrytí = riziko.
- **Verzované REST (`v20`–`v33`) koexistují** — kolik klientů/verzí je živých?
- **Duální stav** (`application_states` tabulka vs. moderation workflow) — proč a co je zdroj pravdy.
- **`page` vs `page_cz`** jako oddělené typy — kolik obsahové logiky je country-forkované.
- **Prázdný submodul `fundatia`** (RO theme) — část RO frontendu není v exportu.
