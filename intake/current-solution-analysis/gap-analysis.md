# Gap analýza: current-state ↔ zadání (VERIFIKOVANÁ)

> **Status:** Verifikovaná gap analýza. Nahrazuje předběžný `gap-signals.md`.
> **needs:** @analytik — schválení klasifikace gapů a jejich promítnutí do variantní úvahy (var. A vs. B).

## Rám a metodika

Tento dokument je **výsledek ověřování hypotéz proti kódu** (current-state export platformy) vůči **modulové baseline zadání** (sekce 4 + NFR N1–N13 + sekce 9/10). Každý nález je opřen o konkrétní doklad (soubor:řádek, entita, grep výsledek, cluster ze scope-map). Analýza probíhá ve třech dimenzích:

- **modulová-matice** — pokrytí funkčních modulů zadání kódem,
- **typy-pribehu** — hloubkové ověření čtyř typů příběhů,
- **nefunkcni-N** — nefunkční požadavky N1–N13,
- **invariant-penize** — ověření klíčového invariantu „věcný dar jde přímo dodavateli na fakturu, nikdy rodině“.

**Co tento dokument NEDĚLÁ:** nerozhoduje o scope, neurčuje vítěznou variantu, nepřepisuje zadání. Klasifikuje stav a **připravuje vstup** pro rozhodnutí var. A (dostavba na stávající codebase) vs. var. B (širší přestavba / greenfield API-first). Rozhodnutí patří @analytik + vlastníkům produktu.

**Legenda typu gapu:**

| Typ | Význam |
|---|---|
| `shoda` | Požadavek zadání má přímý, doložený protějšek v kódu. |
| `k-overeni` | Protějšek existuje/pravděpodobně existuje, ale konkrétní parametr/kvalita/hranice není v tomto průchodu ověřena. |
| `nesoulad` | Funkcionalita existuje, ale ne v podobě/kvalitě/rozsahu, který zadání žádá. |
| `mezera-v-kodu` | Zadání požaduje, kód nemá (díra v implementaci). |
| `mezera-v-zadani` | Kód má, zadání neuvádí (funkce nad rámec baseline). |

**Legenda confidence:** `high` = doloženo přímým grep/čtením kódu; `medium` = doloženo nepřímo nebo částečně; `low` = indicie, vyžaduje cílené ověření.

---

## Tabulka nálezů

### Dimenze: modulová-matice

| Tvrzení (zkráceně) | V kódu? | V zadání? | Typ gapu | Doklad | Conf. |
|---|:--:|:--:|---|---|:--:|
| Podání žádosti — dvoukrokový formulář ZZ + patron, propojení, vytvoření žádosti v BE | ✅ | ✅ | shoda | Cluster `zadost-jadro`: `ApplicationEntity::getDisplayedForm(role)`, multi-step formy žadatel/patron, `ApplicationSessionEntity` (anonymní session), `LeadAddForm`; modul `web/modules/custom/application` (~127 PHP). | high |
| Automatizované urgence — cron-driven přechody + reminder stavy existují, ale kadence 2 / 2+5 / 2+5+7 dní neověřena | ✅ | ✅ | k-overeni | `ApplicationActionEntity` (initiator=cron, source/target, `cron_interval`) + `ApplicationActionCron`; stavy `reminder_1/2` (Lead), `reminder_1/2_patron/fundraiser` (Žádost), `it-zadani.md` §7. Konkrétní hodnoty v `application_action` config — neověřeno. | medium |
| Koordinátor FRONT — back-office správa žádosti, kontrola úplnosti, komunikace s dodavatelem před zveřejněním | ✅ | ✅ | shoda | State machine s rolí coordinator/senior_coordinator/front, `ChangeStateForm`/`WorkflowStatusForm`, `ApplicationActivityForm`, `AssignApplicationController`/my_leads; stavy `to_check`/`application_processing`/`waiting`; `listContract()`, `isReadyToActivate`. | high |
| Koordinátor BACK — příprava smlouvy, koordinace podpisu ZZ, sledování realizace, uzavření | ✅ | ✅ | shoda | Cluster contract: generování smlouvy ze šablony, `signManager()`/`signFundraiser()`, `ContractFundraiserSignForm`, stavy `contract`/`waiting_signature`/`contract_signed`; `gift_payment`/`gift_paid`/`completed`; role senior_coordinator. | high |
| Risk management — scoring, full review, blacklisty ANO; **integrace Cribis + insolvenční rejstřík NEEXISTUJÍ** (insolvence je jen ruční ano/ne pole) | ❌ | ✅ | **nesoulad** | `ScoringForm`, `ScoringLowRiskForm`, `BlacklistEntity` (bl/wl_z/wl_zd/wl_n). Registry pouze `IdentityCardService` (MVČR) + ARES (IČO). `grep cribis` = 0; „insolven" jen `#type select ano/ne` v `scoring/src/Form/ScoringForm.php:515-538`. Zadání §4 explicitně žádá Cribis/insolvenční reg. | high |
| Změna patrona — tok výměny (risk / ZZ) s novými urgencemi | ✅ | ✅ | shoda | `ApplicationEntity::removePatron()` + `ApplicationActionEntity::removePatron()` (strhne ~30 patron scoring polí + smaže profil), stav `returned_new_patron`, forma `aprofile.change_patron`; nové urgence přes tentýž reminder/cron mechanismus. | high |
| BACK office + Finance — smlouva, podpis, výplata dodavateli, uzavření, částečné plnění, reconciliace | ✅ | ✅ | shoda | `TransactionService` (výplata), `PayRemainingAmountForm`, `bankToCrmController::compare` (reconciliace dle VS), `ComgateSyncCommand`; stav `completed_partly` (`CampaignEntity` ř.818, `it-zadani` §7). | high |
| **Typy příběhů** — zadání žádá 4 typy (standard/open/group/collection); kód má `type` s JINÝMI hodnotami (basic/promo/long_term/short_term). Otevřená částka, skupinový 1:N ani sbírkový účet NEJSOU typem příběhu | ❌ | ✅ | **mezera-v-kodu** | `CampaignEntity.php:825-836` `type` = basic/promo/long_term/short_term. Beneficient 1:1 (aprofile „dítě"); zadání §4a žádá 1:N entitu Beneficient + partial disbursement. grep `open/group/collection/sbirkovy` = 0 doménových hitů. | high |
| Průběžné částečné výplaty (partial disbursement s audit logem) — kód má jen jednorázovou výplatu po cíli + doplacení adminem | ❌ | ✅ | **mezera-v-kodu** | Automatické uzavření když `campaign_raised >= gift_price` (completed), `PayRemainingAmountForm` doplatí zbytek. Model = „sbírej do cíle, pak vyplať". Mechanismus průběžných výplat nenalezen. | medium |
| Příběhy / Content — příprava, publikace, fotky, zpětná vazba | ✅ | ✅ | shoda | `PublishController::setActive`, `isReadyToActivate` (kontrola fotek), `generateCampaignsImages`, `ContentTabController`; `FeedbackEntity` + `CampaignFeedbackForm`/`FundraiserFeedbackForm`, stavy `feedback_sent`/`feedback_to_proccess`. | high |
| Donační flow — Comgate + voucher (Dobrošek) + recurring ANO; **bankovní převod a trvalý příkaz nejsou dárcovská metoda** (bankovní jen zpětně přes IMAP/párování, trvalé = card recurring) | ✅ | ✅ | **nesoulad** | `TransactionService::executePayment` (Comgate/Maib/Netopia), `VoucherTransactionService`, `TransactionRecurringEntity` (monthly). Bankovní: `BankIntegrationPageController` IMAP import = reconciliace. grep `trvaly`/`standing_order`/`bank_transfer` v transaction/ = 0. | medium |
| Zóna ZZ — status tracking, doplnění žádosti, smlouva (session-based zone + REST) | ✅ | ✅ | shoda | Reaction engine píše zone status/icon/action button (`application_refill`/`repeat`/`redirect`), `ApplicationSessionEntity` fundraiser interface, view `fundraiser_zone`, contract download link ZZ. | high |
| Zóna patrona — status tracking, aktivace účtu, history | ✅ | ✅ | shoda | Patron session interface (invited/authenticated_invited/new_patron), `AccountService` aktivace + magic link, view `patron_zone`, `PatronEntity`. | high |
| Zóna dárce — přehled darů, certifikáty, daňová potvrzení, trvalé příkazy, recurring (s výhradou „trvalý příkaz") | ✅ | ✅ | shoda | `AccountService` + ~25 REST resource, `DonationConfirmationController` (RO `TaxPayerEntity`/2%), `TransactionRecurringCancelResource`, view `supporter_zone`. | high |
| **Mobilní aplikace** (iOS + Android: recurring, feed, push, potvrzení) — NEEXISTUJE; push nemá infrastrukturu | ❌ | ✅ | **mezera-v-kodu** | Žádný mobile/react-native/flutter/apk adresář (find = 0). Notifikace POUZE e-mail. Firebase = jen zakomentovaný list-sync (`CampaignCron.php:167`), ne push. Apple/Google Pay grep = 0. Zadání §10: „Mobilní aplikace chybí." | high |
| **REST API** — rozsáhlé verzované (~80 resource, v20–v33), ale bez OpenAPI 3.x, OAuth2/API-key, obecných state-transition webhooků, rate limitingu | ✅ | ✅ | **nesoulad** | Verzované resources napříč clustery. grep `openapi`/`swagger` = 0; `oauth` = 0; jediný webhook = `FacebookLeadWebhookResource` (příchozí). Rate limiting jen ad-hoc IP counter. Zadání §9.2/§3.3 žádá first-class API. | high |
| **Reporting / BI** — interní operativní reporting ANO; **napojení na externí BI (Tableau) / datový sklad NEEXISTUJE** | ✅ | ✅ | **nesoulad** | 8 report stránek (`/admin/reports/*`), Google Charts/Chart.js, `Costs`+`Snapshot` entity, 18 CSV exportů, funnel přes `application_statuses`. grep `tableau`/`data_warehouse` = 0. Zadání §10a.2 žádá BI napojení. | high |
| CMS / web — správa obsahu, editace příběhů a landingů bez IT | ✅ | ✅ | shoda | `patron_gutenberg` (~52 bloků) + `patron_gutenberg_cz` (~54), `BlogEntity`, node types page/page_cz/form_page/success_page. | high |
| Notifikace / e-mail přes Mautic — odesílání ANO, ale **„sledování otevření" v tomto kódu nedoloženo** (funkce Mauticu) | ✅ | ✅ | k-overeni | `APIMailingService::handleMail()` (šablona per zemi, Mautic kontakt, `sendToContact`), `EmailEntity` archiv, `mautic:sync:contacts`. grep open-tracking v mautic/ = 0. | medium |
| CRM integrace — export/sync dárců+patronů do EXTERNÍHO CRM přes konektor: **generický 3rd-party konektor NENÍ** (jen Mautic + interní bankToCrm) | ✅ | ✅ | **nesoulad** | `syncSupporters`/`syncFundraisersAndPatrons` do Mauticu. „crm" hity = `bankToCrmController` (interní reconciliace). Salesforce/HubSpot/Raynet grep = 0. Zadání §4 připouští „Mautic nebo 3rd party" — Mautic ANO, generický NE. | medium |
| Platební brány per-country s abstrakcí — CZ Comgate, RO Netopia/MonetaAPI, MD MAIB; **MD je v kódu implementované** (kód předběhl zadání, kde MD = TBD) | ✅ | ✅ | shoda | `TransactionService::paymentGatewayCreateTransaction()` routuje dle `Settings::get('country')`; moduly comgate/netopia/monetaapi/maib. Pozor: brána je globální per-instance, ne per-transakce. | high |
| Multi-tenant — feature toggles + per-country logika ANO, ale jde o **globální per-instance stav**, ne systémovou per-country konfiguraci; oddělené DB / multi-site config nejsou v exportu | ✅ | ✅ | **nesoulad** | `patron_base` `FeaturesManagerForm` + `feature_is_enabled()` přes `\Drupal::state()` (globální flag). Country = jediný `Settings::get('country')`. sites.php/multisite config v exportu nenalezen; prázdný submodul `fundatia` (RO). | medium |
| Lokalizace — jazyky cs/en/ro/ru, e-maily per zemi, měny hardcoded per brána; per-country právní dokumenty přes contract_template + podpis dle země | ✅ | ✅ | shoda | Jazyky cs/en/ro/ru, translatable entity, témata patron_cz/patron_ro, `config_czech`. `signManager` vkládá podpis dle země. **Měny hardcoded** (CZK/MDL/RON), ne konfigurovatelné — viz N13 nesoulad. | medium |
| **GDPR export (čl. 20 přenositelnost)** — kód má jen anonymizaci/výmaz, export dat subjektu NENALEZEN | ❌ | ✅ | **mezera-v-kodu** | `gdpr` modul: `GDPRMailForm` anonymizuje (mail, name, SmartMailing) = výmaz. Zadání §10a.3/N1 žádá i export osobních dat (čl. 20). Exportní funkce nedoložena. | medium |

### Dimenze: typy-pribehu (hloubkové ověření)

| Tvrzení (zkráceně) | V kódu? | V zadání? | Typ gapu | Doklad | Conf. |
|---|:--:|:--:|---|---|:--:|
| **Typ 1 (Standardní, cílová částka)** — plně pokrytý; dokončení řízeno cílem | ✅ | ✅ | shoda | `CampaignEntity.php:553` `gift_price`, :808-823 `campaign_status`, :1115 `isCompleted` (raised>=gift_price); `application_states.yml:1-100`; `CampaignCron.php:51-62` (deadline→uncompleted). | high |
| **Typ 2 (Otevřená částka)** — NENÍ modelově pokrytý; celá logika stojí na pevné `gift_price` | ❌ | ✅ | **mezera-v-kodu** | `CampaignCron.php:58` (`raised < gift_price`), :149 (`raised > gift_price`→alert); progress = raised/gift_price. `type` :825-836 nemá „otevřená částka". „infinite" režim jen pro 1 hardcoded účet, ne obecný typ. | high |
| **Typ 3 (Skupinový 1:N beneficienti)** — NENÍ pokrytý požadovaným modelem; beneficient je 1:1 na žádosti | ❌ | ✅ | **mezera-v-kodu** | `ApplicationEntity.php:645-651` `child` = entity_reference→contact, kardinalita 1; :394-397 `getChild()` vrací jeden; `CampaignEntity.php:228-232` `getApplication()` = `reset()` (1:1). Zadání žádá 1:N. | high |
| „Sloučený příběh" (type=long_term/short_term + parent + `getKidsCount()`) — agreguje samostatné příběhy, **není** to datový model Typu 3 (riziko záměny při návrhu) | ✅ | ❌ | k-overeni | `CampaignEntity.php:493-502` pole `parent`, :297-303 `getKidsCount()`, :825-836 type long_term/short_term. Jde o agregaci celých příběhů, ne 1:N beneficientů se sdílenou cílovou částkou. | medium |
| **Typ 4 (Sbírkový účet)** — částečný ad-hoc mechanismus „transparentní/obecný účet" (Settings `transparent_account`, default ID 1, „infinite" render) | ✅ | ✅ | k-overeni | `CampaignEntity.php:1550-1551` `isGeneral()`; `campaign.module:64-70` `$infinite`, kumulativní počet dětí; `campaign.schema.yml:7`; `CampaignDonationForm.php:75`. | high |
| Sbírkový účet ALE NENÍ dle zadání — stále běžná `CampaignEntity` vázaná na žádost, identifikovaná jen ID v configu; není „samostatná entita bez vazby na žádost", bez patrona, mimo žádostní proces | ❌ | ✅ | **nesoulad** | `CampaignEntity.php:228-232` (vždy váže application); `ApplicationEntity.php:1190-1201` (žádost řídí campaign_status); transparent = jen ID v Settings; sdílí `campaign.html.twig`; žádný samostatný entity type/route (grep `sbirkov` = 0). | medium |
| Pole `type` NEODPOVÍDÁ 4 typům zadání — hodnoty basic/promo/long_term/short_term jsou marketingové/agregační kategorie; mapování na nové typy neexistuje | ❌ | ❌ | mezera-v-kodu | `CampaignEntity.php:825-838` type allowed_values. | high |

### Dimenze: nefunkcni-N (N1–N13)

| Tvrzení (zkráceně) | V kódu? | V zadání? | Typ gapu | Doklad | Conf. |
|---|:--:|:--:|---|---|:--:|
| **N1 GDPR** — RBAC vrstva existuje: 15 rolí | ✅ | ✅ | shoda | `config/user.role.*.yml` (accountant … risk_manager, 15 souborů). | high |
| **N1** — „právo být zapomenut" minimalistické a nekompletní; nemaže navázané záznamy; modul `gdpr` je vypnutý | ❌ | ✅ | **mezera-v-kodu** | `gdpr/src/Form/GDPRMailForm.php::deleteUser()` (mail='' + name přepis); žádná kaskáda; `core.extension.yml`: gdpr: 0. | high |
| **N1** — chybí backendová správa souhlasů (jen cookie lišta) | ❌ | ✅ | **mezera-v-kodu** | `composer.json`: cookie_consent_notice_by_cookieyes; žádný consent ledger v custom. | medium |
| **N1** — chybí šifrování at-rest, key/maskování, TFA/password_policy | ❌ | ✅ | **mezera-v-kodu** | grep encrypt/key/real_aes/tfa/password_policy v `core.extension.yml` = 0; composer bez šifrovacích modulů. | high |
| **N1** — „tvrdé oddělení tenantů" NENÍ runtime multi-tenancy; jedna codebase per země | ❌ | ✅ | **nesoulad** | `drush/sites/self.site.yml` (cz/ro/md-prod aliasy); větvení `Settings::get('country')`; žádný domain_access/group modul. | high |
| **N1** — TLS ručně přes certbot/skript, ne IaC; hardcoded doména/e-mail | ❌ | ✅ | **mezera-v-kodu** | `README.md` (certbot); `auto_renew_cert.sh` (`-d kidshero.ro --email example@example.com`). | high |
| **N2 Výkon** — Elasticsearch knihovna + modul PŘÍTOMNY, ale VYPNUTÉ a nevolané (mrtvý kód) | ❌ | ✅ | **mezera-v-kodu** | `core.extension.yml`: elasticsearch: 0; grep mimo modul = 0; `Elasticsearch.php->save()` natvrdo `http://elasticsearch:9200`, id='my_id', výjimky spolknuty. | high |
| **N2** — caching připraven (memcache), ale redis/memcached/varnish v compose zakomentované; žádné zátěžové testy | ❌ | ✅ | k-overeni | `composer.json` memcache ^2.5; `docker-compose.yml` zakomentované bloky; žádný load-test artefakt. | medium |
| **N2** — brute-force/flood ochrana loginu přítomna (pozitivum) | ✅ | ❌ | shoda | `account/…/v32/AccountLoginResource.php` — `FloodInterface $flood`. | medium |
| **N3 DevOps/CI** — žádná CI/CD konfigurace v repu | ❌ | ✅ | **mezera-v-kodu** | Žádný bitbucket-pipelines/.gitlab-ci/Jenkinsfile/.github; jen ruční skripty. | high |
| **N3** — testovací pokrytí velmi tenké (7 souborů / ~50 modulů), žádné e2e | ❌ | ✅ | **mezera-v-kodu** | find `*tests*/*.php` → 7 souborů; `comgate` `TransactionAPITest` = 57 řádků. | high |
| **N3** — verzované migrace + config management existují, ale bez IaC/rollback + bez anonymizované prod→test migrace | ❌ | ✅ | k-overeni | hook_update_N, config_split/ignore/filter, sync_config; žádný terraform/ansible ani anonymizace. | medium |
| **N3** — prostředí jen drush aliasy; compose pro lokál (Xdebug, mailhog, traefik insecure); parita přes IaC neexistuje | ❌ | ✅ | **nesoulad** | `self.site.yml` cz/md/ro-local/stag/prod; `docker-compose.yml` XDEBUG:1, mailhog, `--api.insecure=true`. | high |
| **N5 Zálohy/DR** — žádný backup/DR skript, RTO/RPO, SLA | ❌ | ✅ | **mezera-v-kodu** | grep backup/mysqldump/rsync/snapshot/disaster mimo vendor = 0 provozních skriptů. | high |
| **N6 Monitoring** — částečně: `slack_integration`/`SlackLogger` forwarduje ERROR/CRITICAL; `telegram_integration` přítomen | ✅ | ✅ | shoda | `slack_integration/src/SlackLogger.php` (ERROR/CRITICAL→webhook). | high |
| **N6** — chybí centralizované metriky/dashboardy + business alerting (failed payment); žádný Prometheus/Grafana/ELK | ❌ | ✅ | **mezera-v-kodu** | `core.extension.yml` elasticsearch:0; composer bez APM (jen simplei/devel); SlackLogger jen error/critical. | medium |
| **N7 Bezpečnostní testování** — žádný SAST/DAST/scan (CI chybí), žádný WAF/bot-protection, žádný pentest artefakt | ❌ | ✅ | **mezera-v-kodu** | Absence CI; traefik bez WAF; žádné captcha/bot modul; jen flood na loginu. | high |
| **N8 PCI DSS** — pozitivní: platby přes hostované brány/redirect; karta se v aplikaci neukládá | ✅ | ✅ | shoda | `netopia/…/NetopiaRedirectForm.php`, `comgate/…/AgmoPaymentsSimpleProtocol.php`, `maib/…/MaibService.php`; grep card/cvv v transaction/ = 0. | medium |
| **N8** — netopia card.php/Card.php jsou vendor SDK (mobilPay); vlastní zpracování PAN není, ale SAQ rozsah vhodné ověřit | ❌ | ✅ | k-overeni | `netopia/src/card.php` statický XHTML brány; `Mobilpay/Payment/Request/Card.php` knihovna; SAQ doklad v repu není. | medium |
| **N9 E-mail** — SPF/DKIM/DMARC nejsou v repu (DNS mimo kód); jen Mautic + SmartMailing integrace | ❌ | ✅ | k-overeni | grep dkim/dmarc/spf = shody jen v package-lock/voucher.install (nesouvisející); DNS mimo repo. | medium |
| **N10 Přístupnost** — v repu jen Drupal admin/backend + témata; veřejná SPA mimo repo → WCAG nelze doložit ani vyvrátit | ❌ | ✅ | k-overeni | Témata patron_cz/ro/old; REST `/api/3.2/*` indikuje headless frontend mimo repo. | medium |
| **N11 Regulatorní soulad** — žádný právní checklist/stanovisko; per-country jen ad-hoc přes Settings + config_split | ❌ | ✅ | **mezera-v-kodu** | Absence artefaktu; větvení country v `APIMailingService.php:99-106`; `RomanianWorkingDayChecker`. | low |
| **N12 Maintainability** — základní kvalitativní nástroje v dev-require, .editorconfig; ale bez CI enforcementu, tenké testy, mrtvý/zakomentovaný kód | ❌ | ✅ | **nesoulad** | .editorconfig; devel/upgrade_status/upgrade_rector; `login_history.module` hook zakomentován; `patron_form_access.module` prázdný. | medium |
| **N12** — anti-lock-in částečně příznivé: standardní Drupal 10 + config export + single_content_sync; data v MariaDB | ✅ | ✅ | shoda | `core-recommended ^10`, `single_content_sync`; `drush cex -y`; mariadb. | medium |
| **N13 Lokalizace** — měna NENÍ per-country abstrahovaná; natvrdo CZK / kód 498 i ve v3.2 resource | ❌ | ✅ | **nesoulad** | `TransactionService.php:282` currency=498, :351 CZK; `v32/TransactionResource.php:243/291`; `TransactionVoucherResource.php:161` CZK. RON/MDL/EUR nepokryté. | high |
| **N13** — jazyková lokalizace UI/e-mailů funguje; právní dokumenty/formáty per země jen částečně (config_split) | ✅ | ✅ | shoda | `config/language/ro/ro.po`; `patron_base:set_language ro\|cs`; `sync_config/config_czech`. | medium |
| **Audit log (N1/N6)** — dedikovaný login audit (`login_history`) má schéma i UI, ALE zápis VYPNUTÝ (hook zakomentován) + modul vypnutý | ❌ | ✅ | **nesoulad** | `login_history.module` — funkce zakomentovaná; `core.extension.yml` login_history: 0. Existuje jen application_log/campaign_log. | high |
| Doménový audit trail pro aplikace + kampaně existuje (application_log, campaign_log s testy) — částečně pokrývá auditní stopu | ✅ | ✅ | shoda | `web/modules/custom/application_log/` (+Unit/Functional testy); campaign_log analogicky. | medium |
| REST API verzování/kompatibilita — path-based verze umožňují zpětnou kompatibilitu paralelním provozem | ✅ | ❌ | shoda | `account/…/{,v31/,v32/}`; `AccountLoginResource` v32 `/api/3.2/user/login`; obdobně transaction v32. | high |

### Dimenze: invariant-penize (věcný dar → dodavateli, nikdy rodině)

| Tvrzení (zkráceně) | V kódu? | V zadání? | Typ gapu | Doklad | Conf. |
|---|:--:|:--:|---|---|:--:|
| Vstupní tok (dárce→brána→platforma) je jediný implementovaný tok peněz; transakce vázána na kampaň + dárce, ne dodavatele | ✅ | ✅ | shoda | `TransactionService.php:133-243` (executePayment) + :256-383 (gateway) — transakce má `campaign` a `user_id`, ne dodavatele. | high |
| **Odchozí platba dodavateli NENÍ v kódu vůbec** — invariant vynucen absencí funkce + procesem, ne automatizovaným převodem | ❌ | ✅ | **mezera-v-kodu** | grep supplier + amount/price/transfer/payout = jen evidenční pole (gift_price_supplier, export_csv); accounting je jen reconciliace příchozích. | high |
| `SupplierEntity` nemá bankovní pole (IBAN/účet) — je to katalog/číselník, ne cíl platby | ❌ | ✅ | k-overeni | `supplier/src/Entity/SupplierEntity.php:147-317` — name/street/city/zip/datova_schranka/ico/status; žádné bank/iban/account. | high |
| Vazba „dar jde přes dodavatele" modelována v žádosti, ne v transakci | ✅ | ✅ | shoda | `ApplicationProfileEntity.php:1478-1484` `gift_supplier`→supplier, :1359-1375 `gift_price_supplier`. | high |
| Doklad o předání daru = naskenovaný protokol o převzetí v kontraktu (evidence věcného plnění, ne převod peněz rodině) | ✅ | ✅ | shoda | `ContractEntity`: `attachment_gift_proof` (private file), `text_gift_proof`. | high |
| Žádná cesta platby rodině/ZZ nenalezena — konzistentní s invariantem, ale invariant je vynucen absencí funkce, ne pozitivní kontrolou | ❌ | ✅ | k-overeni | transaction/contract/donation_confirmation bez bankovní výplaty rodině; `TransactionEntity.bank_account:400` je jen string pro reconciliaci příchozí platby. | medium |
| `donation_confirmation` je jen roční daňové potvrzení pro dárce; s tokem k dodavateli nesouvisí, žádný payout | ✅ | ❌ | shoda | `DonationConfirmationEntity.php:307-408` — donation_total, in_words, year, campaign, rodne_cislo. | high |
| Skutečná úhrada dodavateli „na fakturu" probíhá MIMO codebase (manuální bankovní příkaz) | ❌ | ✅ | k-overeni | `bankToCrmController.php:213` (method='Příkaz k úhradě' u párování příchozích); `netopia/…/Invoice.php` jen struktura brány. | medium |

---

## Díry v zadání (funkce v kódu, které zadání neuvádí)

Klasifikace `mezera-v-zadani` — kód obsahuje funkcionalitu, kterou modulová baseline zadání (sekce 4) neuvádí. Nejde nutně o problém; jde o kontext, který **rozšiřuje reálný scope stávající platformy** a měl by být vědomě adresován při rozhodování var. A vs. B (převzít / utlumit / migrovat).

| Funkce | Doklad | Conf. | Poznámka pro rozhodnutí |
|---|---|:--:|---|
| **ML doporučování kampaní** (`campaign_recommendation`) | QueueWorkery training/scoring, php-ml SVC, `AccountEntity::trainModel`. **POZOR: fakticky vypnuté** — classifier/buildSetPredict/hook_cron zakomentované; dead/experimentální. | high | Zadání zmiňuje personalizovaný feed jen pro mobil. Nepřebírat jako živou funkci — je to dead kód. |
| **Facebook Conversions API / Lead Ads** (`facebook_leads`) | REST `/api/3.2/facebook` relay na FB CAPI (Lead/Purchase/CompleteRegistration), SHA-256 PII hashing, hardcoded pixel/token; FB webhook `/api/2.2/facebook/lead` (POST handler rozbitý). | high | Marketingová integrace mimo baseline. Rozbitý webhook = tech debt. |
| **Elasticsearch / App Search fulltext** (`patron_search` + `elasticsearch`) | `EsUploadQueue` indexuje user/application/campaign/organisation/transaction do engine `patron-search`; `SearchBlock` injektuje externí React SPA do adminu. | high | Vyhledávání jako modul není v §4. Modul `elasticsearch` je navíc vypnutý (viz N2). |
| **Provozní alerting Slack + Telegram** (`slack_integration`, `telegram_integration`) | `SlackLogger` (ERROR→errors, CRITICAL→checks), `TelegramLogger` (level≤3). | high | Patří spíš do NFR N6 než do funkčního seznamu; existující základ monitoringu. |
| **OneDrive import faktur, sitemap, image rotate, GTM, patron_devel** | `onedrive:import:invoices` (MS Graph, párování dle VS), `sitemap:create`, `simple_image_rotate`, `patron_tracking` (GTM-P3FFR3CG), `patron_devel` (debug REST). | high | Drobné utility mimo §4. `patron_devel` = debug povrch, ověřit že není v produkci. |
| **Partner + Organisation entity** | `PartnerEntity` CRUD + REST v20/v32 („Podporují nás"); `OrganisationEntity` (zaměstnavatelé patronů, is_profi, worker účty). | medium | Blíží se §2.3 AFFIL a rolím KAM/AFFIL, ale bez položky v tabulce modulů zadání. |

---

## Nad rámec zadání / mezery v kódu (souhrn priorit)

Klasifikace `mezera-v-kodu` a `nesoulad` — zadání požaduje, kód nemá nebo má v nedostatečné podobě. Toto jsou **kandidáti na hlavní práci** bez ohledu na variantu:

**Strukturální mezery (dotýkají se datového modelu / jádra):**

- **Typy příběhů 2–4** (otevřená částka, skupinový 1:N beneficient, sbírkový účet) — kód má 1:1 beneficient a model „sbírej do cíle, pak vyplať". Zásah do jádra `CampaignEntity`/`ApplicationEntity`.
- **Průběžné částečné výplaty** (partial disbursement z průběžného zůstatku) — nutná podmínka Typu 2/4; dnes neexistuje.
- **Odchozí platba dodavateli** — invariant „na fakturu dodavateli" je dnes vynucen jen absencí funkce a manuálním procesem; `SupplierEntity` nemá bankovní pole.
- **Multi-tenant runtime** — dnes jedna codebase per země + globální feature flagy, ne systémová per-country tenant izolace.

**Integrace / rozhraní:**

- **REST API kvalita** — chybí OpenAPI 3.x, OAuth2/API-key, obecné state-transition webhooky, rate limiting (jádro požadavku §3.3 na „agentické propojení").
- **Mobilní aplikace + push infrastruktura** — neexistuje vůbec.
- **Registry Cribis + insolvenční rejstřík** — dnes jen ruční ano/ne pole.
- **Externí BI napojení** (Tableau/datasklad/read-replica) — neexistuje.
- **Generický 3rd-party CRM konektor** — jen Mautic.
- **Bankovní převod / trvalý příkaz jako dárcovská metoda** — dnes jen zpětná reconciliace + card recurring.

**NFR / provoz / compliance:**

- **N13 měny** — hardcoded CZK/498; RON/MDL/EUR nepokryté (blokuje RO/MD provoz).
- **N1 GDPR** — nekompletní výmaz (bez kaskády, modul vypnutý), chybí consent management, šifrování at-rest, TFA, GDPR export (čl. 20).
- **N3 CI/CD** — žádná pipeline; tenké testy; žádná IaC/parita prostředí.
- **N5 Zálohy/DR** — žádný backup/DR/RTO/RPO artefakt.
- **N6 audit log** — login audit vypnutý; není jednotný tamper-proof log dle N1.
- **N7 bezpečnostní testování** — žádný SAST/DAST/WAF/pentest.

---

## K ověření (otevřené otázky před finálním rozhodnutím)

Nálezy `k-overeni` — protějšek pravděpodobně existuje, ale konkrétní parametr/hranice/kvalita nebyla v tomto průchodu potvrzena. **Doporučeno ověřit před var. A/B rozhodnutím**, protože mění odhad práce:

1. **Kadence urgencí 2 / 2+5 / 2+5+7 dní** — přečíst konkrétní `cron_interval` hodnoty v `application_action` configu. Pokud sedí, jde o `shoda`; jinak `nesoulad`. *(medium)*
2. **Jednotný tamper-proof audit log (N1)** — dnes více vrstev (`application_states` ~892k řádků raw SQL, `ApplicationLogEntity`, `campaign_log`), ale login_history vypnutý a immutabilita nedoložena. Zadání §10a.2 se ptá, zda architektura má nativní audit log jako základ funnelu. *(low)*
3. **„Sloučený příběh" vs. Typ 3** — riziko záměny při návrhu: `parent`/`getKidsCount()` agreguje samostatné příběhy, není to 1:N beneficient. Ověřit, že návrh Typu 3 nepůjde omylem cestou parent-agregace. *(medium)*
4. **PCI SAQ rozsah (N8)** — potvrdit, že netopia `card.php`/`Card.php` jsou pouze vendor SDK a rozsah SAQ (A vs. A-EP) odpovídá redirect modelu. *(medium)*
5. **Sledování otevření e-mailů (N9)** — potvrdit, že open tracking řeší Mautic (mimo tuto codebase) a splňuje požadavek zadání. *(medium)*
6. **WCAG 2.1 AA (N10)** — veřejná SPA je mimo repo; přístupnost nelze v tomto exportu doložit ani vyvrátit. Vyžádat frontend repo / audit. *(medium)*
7. **Caching / zátěž (N2)** — memcache v require, ale redis/varnish v compose zakomentované; žádné zátěžové testy. Ověřit skutečnou produkční cache konfiguraci mimo repo. *(medium)*
8. **`SupplierEntity` bez bankovních polí** — potvrdit, že úhrada dodavateli je záměrně mimosystémová (manuální příkaz), nebo zda existuje evidence mimo tento export. *(high na dokladu, medium na interpretaci)*

---

## Závěr — vstup pro rozhodnutí var. A vs. B

> **needs:** @analytik — toto NENÍ rozhodnutí, je to strukturovaný vstup. Volbu varianty a scope určí vlastníci produktu.

Ověřování ukazuje **silné jádro operativy na existující platformě** a **soustředěné mezery ve dvou vrstvách**:

**1. Co je solidně pokryté (nahrává var. A — dostavba na stávající codebase):**
Celý žádostní tok, role a state machine (FRONT/BACK koordinátor, změna patrona), scoring + blacklisty, contract + podpisy, reconciliace příchozích plateb, tři zóny (ZZ/patron/dárce), CMS (Gutenberg), Mautic notifikace, per-country platební brány (vč. MD, které předběhlo zadání), interní reporting, standardní Typ 1 příběhu, PCI-příznivý redirect model plateb. Invariant „nikdy peníze rodině" je v datovém modelu respektován (dar vázán na dodavatele v žádosti, protokol o převzetí v kontraktu).

**2. Co si vyžádá zásah do jádra (nahrává var. B, nebo těžkou dostavbu):**
Typy příběhů 2–4 (otevřená částka, skupinový 1:N beneficient, sbírkový účet jako samostatná entita) a průběžné částečné výplaty jsou **strukturální mezery** v `CampaignEntity`/`ApplicationEntity` (dnes 1:1, „sbírej do cíle → vyplať"). Odchozí platba dodavateli neexistuje jako systémová funkce. Multi-tenant je per-instance, ne runtime. N13 měny jsou hardcoded na CZK — blokátor plného RO/MD provozu.

**3. Rozhodující osa pro variantní volbu — kvalita rozhraní:**
Zadání §3.3/§9.2 činí z **first-class REST API (OpenAPI, OAuth2, webhooky, rate limiting)** základ pro AI agenty i mobilní app. Stávající API je rozsáhlé, ale verzované ad-hoc bez těchto standardů. **Mobilní aplikace** a **push infrastruktura** neexistují. Pokud je API-first + mobil jádrem cílové vize, tíha argumentu se posouvá k var. B; pokud jsou to přírůstky nad fungující operativou, obstojí var. A s cílenou API vrstvou.

**4. Provozní zralost (nezávislá na variantě, nutná tak či tak):**
CI/CD, testy, zálohy/DR, jednotný audit log, GDPR kaskáda + export, monitoring/business alerting a bezpečnostní testování jsou dnes slabé nebo chybí. Tato práce se **objeví v obou variantách** a měla by být oceněna zvlášť, mimo debatu A vs. B.

**Doporučený další krok:** uzavřít otevřené otázky sekce „K ověření" (zejména kadence urgencí, SAQ rozsah, skutečnou cache/tenant konfiguraci mimo repo) a teprve pak formulovat var. A a var. B se srovnatelnými odhady.
