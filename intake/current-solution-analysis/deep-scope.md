# Deep-scope: mapa entit a funkcionalit stávajícího řešení

Tento dokument popisuje **současný stav** legacy platformy Patron Děti (Drupal 9/10, custom moduly) — co reálně existuje a jak to funguje, ne cílový návrh. Slouží jako podklad pro gap analýzu a odhad reimplementace. Řešení je jedna kódová báze provozovaná pro tři země (CZ / RO / MD) s runtime přepínačem `Settings::get('country')`. Systém je postaven na ručně psaném stavovém automatu žádosti (`application`), na který se navazují finanční transakce, příběhy (kampaně), scoring, smlouvy, notifikace a marketingové integrace. Napříč doménami se opakuje několik vzorů technického dluhu: fat-entity s business logikou v `preSave`/`postSave`, statické `\Drupal::` volání místo DI, syrové SQL mimo Entity API, verzované REST API kopírované po třídách, hardcoded tajemství a magic ID, a rozsáhlý zakomentovaný/mrtvý kód.

---

## 1. Žádost — jádro (Application Core)

Transakční srdce systému. Šest custom modulů modeluje celý životní cyklus žádosti o pomoc: od leadu, přes vyplnění formulářů žadatelem a patronem, scoring/risk, podpis smlouvy, úhradu daru dodavateli, až po zpětnou vazbu a uzavření. Dominantní je modul `application` (~127 souborů, ~22,6k LOC); ostatní jsou satelity (state config / reakce / akce / audit log / gating formulářů).

### Funkcionality
- **Stavový automat**: ~65 stavů + ~45 pojmenovaných přechodů v `application_states.yml` (draft, new, communications, scoring/_ok/_ko/_waiting, waiting_for_patron/fundraiser, contract, waiting_signature, gift_payment, gift_paid, waiting_for_feetback, completed/_partly, canceled_*, campaign_uncompleted…). Přechody gatované per-role přes `transition_roles` (8 rolí: accountant, coordinator, senior_coordinator, content_admin, front, manager, risk_manager). NENÍ Drupal content_moderation navzdory legacy poli `moderation_state`.
- **Manuální změny stavu**: ChangeStateForm / ChangeModStateForm / WorkflowStatusForm; každá změna zapíše audit řádek do syrové tabulky `application_states` přes raw SQL v `ApplicationEntity::insertState()`.
- **Automatické (cron) přechody**: entity `application_action` s initiator=cron, source/target status, cron_interval (urgence, timeouty, automatický removePatron). `ApplicationActionCron` načte žádosti ve zdrojovém stavu starší než interval, přesune je a spustí action funkci.
- **Reaction engine** (`application_reaction`): při každé změně stavu se dispatchuje `ApplicationStatusUpdateEvent`; `ApplicationReactionService::execute()` načte reakce pro nový stav, filtruje dle initiator/lead_role, vytvoří novou session žadatele/patrona s daným interface, nahradí tokeny, pošle notifikační e-mail (vč. UKR variant) + zapíše zone status/ikonu + volitelně akční tlačítko (refill/repeat/redirect).
- **Dvojrolové vedené formuláře**: oddělené vícekrokové formuláře pro žadatele a patrona, řízené `ApplicationEntity::getDisplayedForm(role)` (mapuje stav → forma: application_fundraiser/patron/refill, change_patron, feedback.fundraiser, contract.fundraiser_sign).
- **Anonymní přístup přes session**: `ApplicationSessionEntity` vydá UUID session per role s interface (default/invited/authenticated_invited/upload_*/new_patron). Sessions se validují, deaktivují, dělají read-only a hromadně invalidují dle configu `patron_base.application_statuses.invalidate_sessions`.
- **Scoring / risk**: scoring, scoring_low_risk(_score), per-dimenze OK/KO (fundraiser/patron/gift), rozhodnutí koordinátora + poznámka; role risk_manager vlastní přechody scoring_ok/ko/waiting; ScoringRisksForm; klasifikace rizika daru přes `checkGiftRisk()` (JSON pásma na taxonomii kategorie).
- **Odebrání/výměna patrona** ('nový patron'): `removePatron()` (duplikováno v ApplicationEntity i ApplicationActionEntity) smaže ~30 patron scoring polí + patron profil, odpojí uživatele.
- **Lead management**: LeadAddForm/LeadEditForm, lead_role, lead_source (web/manual/mail/nadace/zone/…), přiřazení koordinátora, my_leads / completed_applications views.
- **Sync kampaně**: `postSave` mapuje stav žádosti → campaign_status a synchronizuje gift_category; nesoulad loguje do Telegramu.
- **Contract hooky, Gift payment, PDF export, REST API** (viz níže), **flag systém** (dynamické flagy ve `\Drupal::state()`, COVID19/standard_ukr), **field-level audit log**, **access gating** (`patron_form_access` blokuje nespolupracující žadatele).

### Entity
| Entita | Účel | Klíčová pole |
|---|---|---|
| **ApplicationEntity** (application) | Agregátní kořen — jedna žádost. Revizovatelná, ~90 base fields; řídí celý automat a sync kampaně. | state/moderation_state, fundraiser/patron/child, fundraiser_profile/patron_profile, lead_role/source/user_id, campaign, category, scoring_*, contract/delivery_note/acceptance_protocol/appendix, flag (multi), x_tracking_*, attachements |
| **aprofile** (ApplicationProfileEntity) | Dotazník per role (fundraiser/patron), extrémně široká entita (~2391 ř., stovky polí). | profile_type, finished(_timestamp), source, child/fundraiser/patron/school, gift_* (item/price/author/proof/category), fundraiser_household_*, patron_occupation/employer/photo/reject/approve |
| **application_session** | Anonymní tokenizovaný přístup k vyplnění/zobrazení v roli. UUID = session_id, purge po 6 měsících. | session_id, application_uuid, role, interface, status, readonly |
| **application_reaction** | Config-as-content pravidlo vedlejších efektů (session interface, e-mail CZ/UKR, zone notifikace, tlačítko). Revizovatelná. | application_status, role, initiator, session_interface, button_action, notification_email(_ukr), status_message, theme_color/icon |
| **application_action** | Config-as-content pravidlo automatických (cron) přechodů + side-effect funkcí. | initiator (cron/patron/fundraiser), application_status (multi, '*'), application_status_target, cron_interval, cron_action (removePatron) |
| **application_log** | Immutable audit/aktivita per žádost (call/email/sms/system). | application_id, field_name/value, note, start/finish, user_id (vč. crm_robot_uid) |
| **application_statuses** (patron_base) | Config entita — pojmenované seznamy stavů (remove_attachments, invalidate_sessions). | id, label, statuses[] |
| **application_states** (raw tabulka) | Append-only ledger stavů psaný raw SQL (bypass Entity API). Zdroj pravdy "kdy vstoupil do stavu". | application_id, state, uid, note, changed |

### Integrace
Mautic/SmartEmailing (APIMailingService), RabbitMQ/AMQP (kód přítomen, služba zakomentovaná), Elasticsearch (es_upload_queue při každém save), Telegram + Slack (alerting), Comgate (platby), ARES (lookup IČO), externí tabulka `transaction` (souhrn darů), Drupal queue system. Těsná vazba na cross-modulové entity contract/campaign/contact/organisation.

### Workflow
Toto JE workflow engine platformy. Změny stavu vznikají třemi cestami: (1) manuálně přes ChangeStateForm/WorkflowStatusForm s role filtrem `getAllowedStates()`; (2) automaticky/časově přes application_action + ApplicationActionCron; (3) implicitně při create (postSave zapíše 'new'). Každá změna: `setState()` → `insertState()` (raw SQL audit) → `postSave()` → dispatch `ApplicationStatusUpdateEvent` → reaction engine (session, e-mail CZ/UKR, zone, invalidace) + sync kampaně. Tok: lead intake → vyplnění žadatel & patron → to_check → scoring/risk → in_progress → contract → waiting_signature → gift_payment → gift_paid → waiting_for_feetback → completed, s mnoha cancel/duplicate/mistake/suspended větvemi.

### Technický dluh
God-entity ApplicationEntity (~1510 ř.) a aprofile (~2391 ř., mnoho polí 'not used'); automat ručně v YAML + duplicitní state/moderation_state, `getStatesConfig()` bez cache; business logika v lifecycle metodách (event dispatch, mutace kampaně, DB, queue, Telegram — netestovatelné); syrové SQL (insertState, IN listy string-interpolací, LIKE '%interface%'); magic values (patron 27280→covid19, corona_cash==3000, crm_robot_uid); duplikovaný removePatron; mrtvý/zakomentovaný kód (RabbitmqService, fixStates), dbg() v produkci; statické `\Drupal::` místo DI; stateful ReactionService (self-@todo); nakumulovaný Ukraine/Corona crisis debt; verzované REST v23/v30/v32 kopírované; string-typed finanční pole; `drupal_flush_all_caches()` v každém cron běhu.

**Sizing: velmi vysoký** — nejobjemnější a nejrizikovější cluster. ~31,4k PHP LOC / ~203 souborů v 6 modulech. 33 Form / 13 Controller / ~22 REST resource ve 3 verzích / 8 entity typů. Reimplementace = mnoho engineer-měsíců; nelze migrovat izolovaně bez contract/campaign/contact clusterů a integrací.

---

## 2. Patroni a kampaně (příběhy)

Centrum stavového workflow příběhu dítěte, pevně provázané s Application. 4 moduly, ~60 tříd, ~7500 ř. v `campaign/src`.

### Funkcionality
- **CRUD příběhu** přes admin formy (CampaignEntityForm add/edit, DatesForm, DeleteForm) s field_group a Field UI.
- **Životní cyklus**: 8 stavů (in-progress, active, suspended, completed, uncompleted, campaign_uncompleted, completed_partly, canceled) přes setCampaignStatus/activate/setComplete; validace přechodu do 'active' přes `isReadyToActivate()` (patron, cena, deadline, fotky dítěte/daru/patrona, veřejnost typu).
- **Aktivace/publikace** (PublishController::setActive) — validace, publikace, sync Application→'active', flush cache.
- **Automatické uzavření** v preSave: campaign_raised >= gift_price → completed + setApplicationComplete + úspěšné e-maily (jen production).
- **'Cílová částka nevybrána'** (CampaignCron::checkCampaignDeadline) — aktivní po deadline s nedovybráno → campaign_uncompleted (robot uid) + e-mail.
- **Výpočet vybrané částky**: getCampaignRaisedMoney (SUM transaction.price WHERE ext_status=PAID), updateCampaignRaisedMoney, getProgress; speciální logika pro promo (original_campaign) a covid19 #2200.
- **URL/slug**: createSlug (patron_base.default), archivace do campaign_slug_archive, země-specifické URL (/pribeh vs /story).
- **Doplacení zbytku adminem** (PayRemainingAmountForm) — transakce na chybějící částku z transparentního účtu.
- **Veřejný darovací formulář** (CampaignDonationForm/Updated) — jednorázový i recurring, AJAX → transaction service executePayment → platební brána, GA/dataLayer/FB data. Darovací modál (Block plugin + Twig + JS). CampaignDonationResult (post-payment landing).
- **Zpracování obrázků** (generateCampaignsImages: photo/list/gift/og; CampaignCron::blurPictures — Gaussian blur dle feature flagu).
- **REST API** pro SPA: v22 (FBFeed), v30 (Campaign/s/Interacted/Recommended), v31, v32, v33. Serializace: getShortData/getFullData/getSearchData.
- **campaign_log** — audit stavů (časové intervaly start/finish per campaign_status). **campaign_recommendation** — ML doporučování (z ~80 % zakomentované/mrtvé). **patron_actions** GiftPaidAction (VBO bulk → gift_paid). **Rumunská validace deadline** na pracovní den (Nager.Date API + cache). Views pluginy, granulární permissiony, počítání kampaní dle stavu (cache tag), cron statistiky/kontroly (jen production).

### Entity
| Entita | Účel | Klíčová pole |
|---|---|---|
| **CampaignEntity** (campaign) | Jádro příběhu — obsah, cíl, stav, vazba na patrona a žádost. Nejsložitější (~1550 ř., ~45 polí). | campaign_status (8), type (basic/promo/long/short), status (published), gift_price, campaign_raised/_percentual_raised, campaign_deadline, patron_profile, parent (self-ref), gift_category, kraj, slug + archiv, single_parent, timestamps, is_*_email_sent, photo/gift_photos/og_image, campaign_order |
| **PatronEntity** (patron) | Osoba/subjekt ručící za příběh (~300 ř.), /admin/structure/patron. | name/first_name/second_name, photo (generovaná), user_id, status |
| **CampaignLogEntity** (campaign_log) | Audit stavů — časové intervaly campaign_status (má unit i functional testy). | campaign_id, field_name, field_value, start/finish (NULL=aktuální), user_id |
| **CampaignRecommendationItem** (field type) | EntityReferenceItem rozšířený o skóre. | target_id, weight (indexováno) |

### Integrace
Comgate/GoPay (executePayment/initRecurring), SmartMailing (finish/uncompleted e-maily), Nager.Date API (RO svátky), Firebase (checkFirebase zakomentován), Slack/Telegram (nekonzistence), GA/dataLayer/FB Pixel, SPA frontend (REST v22–v33, FBFeed), php-ai/php-ml (SVC, celé zakomentované).

### Workflow
Campaign a Application drží stavy paralelně a vzájemně se aktualizují. campaign_status řízen z: (1) admin ručně (CampaignEntityForm, PublishController + sync Application→'active'); (2) preSave při dosažení cíle (→completed + Application->complete()); (3) CampaignCron po deadline (→campaign_uncompleted); (4) GiftPaidAction (bulk → gift_paid na Application; 'gift_paid' patří Application, ne Campaign). Přechody auditovány campaign_log. CampaignUpdateEvent + TransactionUpdateEvent propojují cluster s transakcemi a doporučováním.

### Technický dluh
Fat entity (~1550 ř. míchá persistenci, stavy, částky, e-maily, obrázky, URL, serializaci); `\Drupal::service()/database()` v entitě; magic IDs (covid19 #2200, gift_category 71–76, slider IDs, example@example.com); duplikace allowed_values stavu min. 4×; dva paralelní darovací formuláře; REST v22–v33 copy-paste (~2000 ř., raw SQL); campaign_recommendation z ~80 % mrtvý (require php>=5.6); neaktivní legacy (checkFirebase, duplicity); nekonzistence stavu jen alertována (ne prevence); křehké `$_SERVER['HTTP_REFERER']`; míchání CZ/EN labelů + větvení /pribeh vs /story; ruční SQL v REST i cronu.

**Sizing: vysoký** — nejobjemnější a doménově nejnáročnější oblast. Jádro workflow + agregace darů + REST je must-have; doporučovací engine z většiny mrtvý (lze v odhadu vynechat / navrhnout znovu). Významný podíl objemu = tech dluh, který se nepřenáší 1:1.

---

## 3. Finance (platby, dárcovství, dobrošeky, účetnictví, potvrzení o darech, účty)

Nejsložitější doména. 7 modulů, ~153 souborů, ~21,9k LOC. 9 doménových entit.

### Funkcionality
- **Jednorázová platba** (TransactionService::executePayment): validace kampaně, auto-registrace anonymního dárce (role supporter), aktualizace telefonu na Contactu, Transaction (PENDING), redirect na bránu dle země (CZ=Comgate / MD=maib / RO=Netopia). Měna hardcoded (CZK / 498-MDL).
- **Trvalý dar (recurring)**: při recurrent=1 vznikne TransactionRecurringEntity (period=monthly, day, >28→1); aktivace po první platbě (updateRecurringStatus v postSave). Měsíční strhávání v ComgateCron/NetopiaCron. Zrušení (CancelForm + REST + JS → canceled timestamp).
- **Webhook stavu** (comgate TransactionStatusUpdate): ext_status (PENDING/PAID/CANCELLED/AUTHORIZED/REFUNDED), povýšení role, updateVoucherStatus, generateMultipleVouchers.
- **Dělení přeplatku** (postSave): přesah gift_price → transakce snížena, rozdíl duplikován na transparentní účet (parent ref, transparent=1). Ruční dělení adminem (DivideTransactionForm). Změna typu corporate/owner, removeTransparent.
- **Děkovný e-mail** (sendEmailThanksForPayment — thanks_for_payment/_recurring/_transparent s magic linkem). Slack notifikace (CZ, production).
- **Dobrošeky**: online nákup (VoucherTransactionService), offline (VoucherCartService), košík (VoucherCartForm, /goodies). Hromadné generování z jedné transakce (MultipleVouchersGenerator z vouchers_data JSON). PDF (mPDF, obrázky dle nominálu 100–10000). Doručení e-mailem kupujícímu/příjemci (PDF do Mautic jako asset). Validace/uplatnění přes REST (v1 i v32). Cron: připomínka 7 dní před expirací + report expirovaných.
- **Bankovní párování**: IMAP import avíz 'Přišly peníze' (DOMXPath) → TransactionMailsEntity (CZ+production). CLI `comgatesync` (transferList/singleTransfer → bank_vs, is_sent_to_bank). Rekonciliace bank vs CRM (bankToCrmController::compare) + účetní formuláře (BankForm, BankSynchronizationForm, ComgateToBankForm).
- **Potvrzení o daru** (CZ): DonationConfirmationController + RequestForm + REST v31/v32 — osobní údaje, RČ, částka slovy, souhlasy, rate-limiting dle IP.
- **Účty** (AccountService): registrace, magic link login, aktivační e-maily, ensureUser; ~25 REST resource tříd (login v31/v32, hash, logout, register, activate, reset, profile, status, token).
- **Daňová evidence RO** (TaxPayerEntity + form + TaxReturnListController) — 2 % daně na 2 roky, Excel přiznání. **ML doporučování** na účtu (AccountEntity::trainModel/buildScores, model serializovaný v DB poli).

### Entity
| Entita | Účel | Klíčová pole |
|---|---|---|
| **transaction** | Centrální finanční entita (dar/dobrošek/trvalý/rozdělená část). | price/original_price, ext_status, ext_trans_id, campaign/original_campaign, parent, is_recurring/voucher/donation/embedded/authenticated/transparent, method/bank_*/is_sent_to_bank, ext_fee, type, vouchers_data (JSON), message_id (idempotence), user_id/ip/ua |
| **transaction_recurring** | Definice trvalého daru, řídí strhávání. | transaction_id, price, period, day (>28→1), payment_provider, token_id/expiration, last_recurring_payment, canceled, status |
| **voucher** | Dobrošek vázaný na transakci, uplatnitelný na kampaň. | transaction, campaign, price, status, is_applied/applied, recipient_*, delivery_type, expiration/reminded, uuid |
| **donation_confirmation** | Potvrzení o daru (CZ, daňové). | email/address/rodne_cislo/name, donation_total/_in_words, confirmation_year, campaign, agreement_*, number_of_requests/ip/ua |
| **transaction_comtobank** | Mapování Comgate→banka (rekonciliace). | name, user_id, status, created/changed |
| **transaction_mails** | Log příchozích bankovních e-mailů (IMAP). | subject, mailFrom, filename, created |
| **transaction_bank** | Příchozí platba parsovaná z e-mailu. | odeslano, castka, cislo/nazev_protiuctu, vs, zprava |
| **account** | Rozšíření uživatele (typ + ML model). | user_id, name/last_name, type (patron/fundraiser), model (serializovaný Classifier), campaign_recommendation |
| **tax_payer** | Údaje plátce RO (2 % daně). | first/last_name, email, numeric_code, phone, kompletní adresa, contract, two_years_agreed |

### Integrace
Comgate (CZ), maib (MD), Netopia (RO), banka přes IMAP (Ddeboer\Imap), Mautic (PDF dobrošeku jako asset + e-mailing), SmartMailing, Slack (webhook hardcoded), Telegram, mPDF, php-ai/php-ml.

### Workflow
Jádro = ext_status transakce PENDING → PAID/CANCELLED/AUTHORIZED/REFUNDED, řízeno webhookem brány. Přechod na PAID spouští kaskádu v preSave/postSave: děkovný e-mail, aktivace dárce, Slack, aktivace trvalého daru, uplatnění/generování dobrošeků, povýšení role. Dělení přeplatku vytváří child transakce a přepočítává raised money kampaně. Trvalé dary: aktivace → měsíční cron → zrušení. Dobrošek: koupě → PAID → ready → email → uplatnění/expirace. Bankovní párování: IMAP → transaction_bank → comgatesync → rekonciliační report. Účet: registrace/auto-registrace → blokovaný → aktivace → supporter.

### Technický dluh
Masivní logika v TransactionEntity (866 ř.: e-maily, Slack, dělení, rekurzivní `$this->save()` v postSave); hardcoded tajemství/URL (Slack webhook, Mautic /var/www cesty, /tmp, obrázky dobrošeků); měny/země hardcoded (CZK, 498, client_ip 192.168.x.x u maib — pravděpodobně bug); recurring charge roztříštěný do comgate/netopia cronu (duplikace createTransaction); accounting: syrové SQL, natvrdo čísla protiúčtů, default 2018, deprecated render(); ComgateSyncCommand na Drupal Console + UPDATE LIMIT 30 + sleep(10); křehký IMAP DOMXPath; deprecated mb_convert_encoding; copy-paste boilerplate entit, míchání CZ/EN názvů polí; verzované REST (v31/v32 + neverzované); zakomentovaný dispatchStatusChangeEvent; ML model unserialize z DB (object injection); TaxPayer čistě RO / donation_confirmation čistě CZ (multi-tenant daňová logika nezobecněná); excessivní logging + var_export v postSave.

**Sizing: nejvyšší** — nejnáročnější na reimplementaci a gap analýzu: transaction (workflow + dělení), account (auth/REST breadth), voucher (Mautic/PDF), rozptýlená logika trvalých plateb v cronu bran. Multi-gateway (3 brány), kaskádové efekty, asynchronní párování, verzované API, ML, country-specifická daňová logika.

---

## 4. Platební brány

Střední rozsah kódu, vysoká integrační složitost a bezpečnostní riziko. Brány + `transaction`/`transaction_recurring` je nutné počítat jako nedělitelný balík.

### Funkcionality
- **Směrování dle země**: `TransactionService::paymentGatewayCreateTransaction()` — md→MAIB, ro→Netopia, jinak cz→Comgate. Země globální per-instance.
- **Comgate (CZ)**: `AgmoPaymentsSimpleProtocol::createTransaction()` (HTTP POST, prepareOnly, refId, price*100, CZK, vrací transId + redirect). Podpora preauth/embedded/initRecurring. Callback `/transaction/status_update` (validace merchant/test/secret, nastaví ext_status/fee, role supporter, vouchery). Recurring cron 4:00 (jen production+cz, hardcoded campaign 3100).
- **MonetaAPI (CZ, bankovní import)**: AISP účet, getTransactions ('yesterday'), mapAndSave (VS regexem z remittance, dohledání user_id dle bank_account, PAID jen CZK). Cron + ruční `/monetaapiid`.
- **Netopia/mobilPay (RO)**: NetopiaRedirectForm (RSA/x509 encrypt, auto-submit na secure.mobilpay.ro, RON, recurrence 60×30). IPN confirm (dešifrování, mapa akcí → interní stav, uložení token_id/expiration). Návratová stránka (theme donation_payment_result). Recurring cron (SOAP doPayT s tokenem, redirect na transparent_account když kampaň neaktivní, e-mail cancelled_recurring_payment). Reconciliace `netopia:sync` / `:20` (SOAP getInfo, CSV, mapa 23 kódů → 5 stavů).
- **MAIB (MD)**: command=v (amount*100, currency 498, language ro), mutual-TLS na maib.ecommerce.md. Callback `/transaction/status_update` (KOLIZE s Comgate, command=c, mapa OK/PENDING/FAILED/DECLINED, redirect na SPA). Drush `maib:reverse` (refund), `maib:close` (uzávěrka 21:59). MaibService::post() mutual-TLS + regex parsing.
- **REST vrstva**: TransactionResource (+ v32), TransactionVoucher(s)Resource, TransactionRecurringCancelResource.

### Entity
| Entita | Účel | Klíčová pole |
|---|---|---|
| **TransactionEntity** (transaction) | Sdílená doménová entita platby; brány jen vytvářejí/aktualizují instance. | ext_status (kanonický automat), ext_trans_id, ext_fee, price/original_price, campaign/original_campaign (fallback 3100), user_id/is_authenticated/ip/ua, is_recurring/embedded/test/transparent, bank_vs/account/date/month/is_sent_to_bank, parent, method, is_voucher, vouchers_data |
| **TransactionRecurringEntity** | Opakovaný dar — stav/plán pro cron každé brány. | transaction_id, payment_provider (hardcoded 'comgate'), token_id/expiration (RO), day (>28→1), last_recurring_payment, canceled, period, price |
| **AgmoPaymentsSimpleProtocol** (comgate) | Bezstavový klient Comgate protokolu. | _merchant/_secret/_test, _paymentsUrl/2, createTransaction(~20 param), _statusParams |
| **MonetaAPI** (monetaapi) | Klient Moneta AISP — import a párování bankovních převodů (CZ). Není brána v pravém smyslu. | moneta_api_token, entryReference (dedup), VS (regex), bank_account, amount (jen CZK) |
| **NetopiaService + NetopiaCron** (netopia) | mobilPay integrace RO (curl POST + SOAP doPayT). | sacId/signature (hardcoded), SOAP payment2 wsdl, account.hash, paymentToken, confirm/return_url, ERR_CODE_OK |
| **Mobilpay_Payment_*** (netopia/src/Mobilpay) | Vendored legacy SDK (9 tříd, ~2250 LOC) — RSA/x509. | factoryFromEncrypted, encrypt→envKey/data/cipher/iv, objPmNotify, CONFIRM_* konstanty |
| **MaibService + MaibController** (maib) | MAIB gateway MD (mutual-TLS, KEY: value). Iniciace ale v TransactionService. | command (v/c/r/b), TRANSACTION_ID/RESULT, klientský cert+heslo (v kódu!), currency 498, MerchantHandler/ClientHandler |
| **maib_example** (tabulka) | Nepoužitá scaffold tabulka z generátoru — mrtvý kód. | id, uid, status, type, created, data |

### Integrace
Comgate/AGMO (HTTP Simple, EET, recurring, S2S callback), Moneta Money Bank (AISP REST v1, Bearer), Netopia/mobilPay (HTTPS redirect, RSA/x509, IPN, SOAP payment2), MAIB (maib.ecommerce.md, mutual-TLS, textový protokol), Telegram (alerting), SmartMailing, Drupal user role (supporter).

### Workflow
Brány jsou vstupní i výstupní hrana platebního workflow nad TransactionEntity (ext_status). Založení: SPA/REST → TransactionService PENDING → dle country jedna brána. Potvrzení asynchronní: Comgate/MAIB přes `/transaction/status_update` (kolize!), Netopia přes IPN confirm. PAID → role supporter + vouchery + e-maily. Recurring: denní cron per brána nad transaction_recurring. Reconciliace: netopia:sync + monetaapi import. Fallback transparent_account (3100) při neaktivní kampani. Věcné dary (faktura dodavateli) tento kód neřeší.

### Technický dluh
**KRITICKÁ tajemství v repu**: MAIB certifikáty/klíče (cert.pem, key.pem, .pfx) + hesla; Netopia heslo + signature na 4 místech; Moneta token default v kódu — nutná rotace do secrets. Kolize routy `/transaction/status_update` (comgate vs maib, funguje jen díky per-country deploymentu). Přímé `$_POST` místo Symfony Request; Comgate validuje callback jen shodou secret (replay/CSRF). Hardcoded doména: kampaň 3100, recurrence 60, day>28→1 duplikovaná 3×. Duplicitní recurring cron 3× s odlišným mapováním stavů (23/4/raw). MAIB modul z velké části scaffold (maib_example, maib_requirements=mt_rand); iniciace MAIB žije v TransactionService, ne v modulu. Netopia mrtvý kód (post() placeholder, standalone card.php ~278 LOC mimo Drupal). Vendored Mobilpay SDK přes require_once, mimo Composer. MonetaAPI fragilní (regex VS, accounts[0], jen CZK jinak throw/shodí cron, cron guard date('d')). Nekonzistentní návratové klíče v TransactionService. Žádné testy kromě jednoho comgate; žádná idempotence proti duplicitnímu callbacku; ladicí artefakty (/tmp/trans.log, echo).

**Sizing: střední kód / vysoké riziko** — netopia ~3572 LOC (z toho ~2250 vendored + ~280 mrtvé) = nejnáročnější (krypto, SOAP, token recurring, IPN); comgate 594 LOC střední; maib 213 LOC + monetaapi 171 LOC malé (monetaapi vyžaduje robustnější parsing). Portace = 4 heterogenní integrace + přepracování automatu, cronů a bezpečnostního modelu. Počítat brány + transaction/recurring jako jeden balík.

---

## 5. Risk (scoring)

Centrální brána mezi podáním žádosti a schválením. ~5300 ř. PHP (scoring ~4220 / blacklist ~1110) + ~446 ř. JS. Silně nerovnoměrné — 47 % v jedné třídě ScoringForm (1980 ř.).

### Funkcionality
- **Manuální scoring** (ScoringForm, /admin/application/{id}/scoring) — ~90 polí (žadatel, patron, dar, dítě: OP/RČ, adresy, zaměstnavatel, příjmy/výdaje, dluhy, exekuce, insolvence); ukládá JSON do application.scoring; při approved=yes && stav=scoring → scoring_ok.
- **OSINT pomůcka**: prokliky Google/Facebook/LinkedIn/Google Maps/mapy.cz + ruční hodnocení nálezu (check_type_a: N/A / Bez nálezu / Odpovídá / Neodpovídá).
- **Automatický Low-Risk engine** (ScoringLowRiskForm + ApplicationStatusUpdateSubscriber): skóre z patron==žadatel (-1 diskvalifikace), blacklist_type (bl=-1, wl_zd/wl_z=+10), pozice patrona OSPOD (+10), rizikovost daru (low=+10/high=-1), výplata na BÚ žadatele (-1); jakékoli -1 kaskádovitě → celé skóre -1.
- **Prahové rozhodnutí**: score>=30 a stav in {to_check, application_processing, waiting, suspended} → 'V kompetenci koordinátora' (může schválit → scoring_ok), jinak 'V kompetenci risku'. Přepočet při přechodu do 'to_check' (EventSubscriber, přímý SQL UPDATE).
- **Rozhodnutí na 3 osách**: scoring_fundraiser/patron/gift (OK/KO) + poznámka + scoring_coord_decision.
- **Validace OP** proti registru neplatných dokladů MVČR (IdentityCardService, real-time, barevná indikace). **Lookup IČO** proti ARES (AresController AJAX autofill; isIcoValid). **Rizikovost daru** (checkGiftRisk — pásma low/medium/high z JSON v taxonomii kategorie).
- **Black/White list** (BlacklistEntity CRUD: wl_zd/wl_z/wl_n/bl pro fundraiser/patron/gift/spotter). Přehledová stránka (/admin/black_list, agregace ~20 sloupců + CSV; při scoring_ok automaticky nastavuje contact.blacklist_type='wl_z'). Fulltext search (v routingu zakomentován). **Vizualizace vazeb** (d3.js, rekurzivně hloubka 5 — graf žádostí sdílejících jméno/email/telefon/RČ/IP → detekce podvodných klastrů). Sync blacklist_type do contact (raw SQL). Nahrávání příloh (private://scoring_attachements).

### Entity
| Entita | Účel | Klíčová pole |
|---|---|---|
| **BlacklistEntity** (blacklist) | Ruční evidence black/white-list s vazbou na žádost. | type (wl_zd/wl_z/wl_n/bl), person (fundraiser/patron/gift/spotter), name/last_name, rc, company_name/ico, mail/phone, note, application (required) |
| **ScoringEntity** (scoring) | Generický kontejner (entity_name+id); v praxi nevyužitý scaffold (REST vrací stuby). | entity_name, entity_id, json_package, user_id, created |
| **Application scoring fields** (na application/aprofile) | Reálná perzistence risku — risk modul nemá vlastní. | scoring (JSON), scoring_low_risk(_score), scoring_fundraiser/patron/gift, scoring_coord_note/decision, scoring_user/created |
| **contact.blacklist_type** (ContactEntity) | De facto primární zdroj blacklist statusu, čtený/zapisovaný ScoringService. | email (lookup), blacklist_type |

### Integrace
ARES (legacy darv_bas.cgi, file_get_contents bez timeoutu/klíče — deprecated), MVČR neplatné doklady (Guzzle, timeout 10s, XML), externí prokliky (Google/FB/LinkedIn/Maps/mapy.cz — jen odkazy), d3.js v6 z CDN, Bisnode (jen ruční select, žádná programová integrace).

### Workflow
(1) EventSubscriber přepočítá low-risk při vstupu do 'to_check'; (2) ScoringForm approved=yes && scoring → scoring_ok; (3) ScoringLowRiskForm score>=30 & povolené stavy → scoring_ok. Role risk_manager: tranzice scoring_ok/ko/k_doplneni + permission 'edit application scoring risks'. Stav scoring_ok spouští BlackListController → povýší contact.blacklist_type='wl_z' žadateli i patronovi. Prahová logika (score>=30, kaskádové -1) rozhoduje koordinátor vs eskalace na risk.

### Technický dluh
Trojí zdroj pravdy pro blacklist (BlacklistEntity vs contact.blacklist_type vs application.scoring JSON); hardcoded váhy/prahy v kódu (nutno do konfigurace); 4 deprecated/CZ-specifické integrace (ARES legacy, MVČR, mapy, d3 CDN protokolově-relativní); ScoringEntity mrtvý scaffold; risk parazituje na application polích (žádná vlastní perzistence); silná CZ-vázanost (RČ, OP, ARES) = práce navíc pro RO/MD.

**Sizing: střední–velká, koncentrovaná složitost.** Reálná pracnost: (a) rekonstrukce ~90-polního formuláře + JSON perzistence [vysoká], (b) reimplementace bodového engine s vytažením vah/prahů do configu [vysoká], (c) náhrada CZ integrací, (d) sjednocení blacklist zdrojů, (e) grafová vizualizace. Scaffold třídy (Access/RouteProvider/ListBuilder/DeleteForm) nízké.

---

## 6. Dodavatelé a smluvní partneři (supplier / organisation / partner / contract)

~10 850 LOC PHP / 83 souborů ve 4 modulech. Těžiště je **contract** (~4453 LOC / 35 tříd).

### Funkcionality
- **Contract — generování smlouvy** z HTML šablony přes `getReplacers()` (~24 placeholderů: {fundraiser-name}, {gift-price-slovy}, {child-name}, {campaign-vs}, {coordinator-name}, {amendment-id}…). 10 typů (good/service/transfer/nno/appendix/delivery_note/acceptance_protocol/rental_contract/rental_agreement/ukraine). Auto PDF render (mPDF v preSave → public://contracts/).
- **Číslování** (public_id) per-country: CZ rok*10000+pořadí/VS, jinak pořadí/datum; sekvence přes SQL MAX(int_id).
- **Podpis manažera** (signManager — obrázek svatava_podpis.png CZ / maria-podpis.png RO). **El. podpis žadatele** (signFundraiser — JSON: uuid/email/session/IP/browser/čas/SHA-512 hash souboru). **PDF potvrzení podpisu** (createFundraiserSignatureConfirmation + QR barcode s hashem). **Veřejná podpisová obrazovka** (ContractFundraiserSignForm, AJAX, validace jména ZZ → 'contract_signed').
- **Odeslání ke kontrole manažerovi** (smlouvy_email_ke_kontrole → stav 'contract'). **Odeslání ZZ** (download link → 'waiting_signature', feature flag feature_digital_signature větví novou/starou cestu). **Přehledová tabulka** (listContract — kontrola připravenosti + akce). **Dodatky** (appendix, inkrementální číslo), **dohoda o nájmu** (auto pro rental_contract). **Revize** (revert/delete + podepsané přílohy v private://). **ContractTemplate CRUD** (revizovatelné).
- **Supplier**: CRUD číselníku (název, IČ, adresa, PSČ, datová schránka, město=taxonomy). Mapování na oblast pomoci (supplier_to_category + URL e-shopu). Veřejný feed `/api/3.2/suppliers` (strom kategorií + dodavatelé, vyřazuje 'Mimořádná pomoc' tid 1722).
- **Organisation**: CRUD (logo, kontakt, key account manager, is_profi). Správa pracovníků (OrganisationWorkerForm — user s rolí organisation_worker, aktivační e-mail, is_admin/worker_available). Slučování duplicit (přepíše application.patron_employer_id, raw SQL). REST `/api/3.2/organisation` (statistiky žádostí po stavech). getEntityByName (find-or-create).
- **Partner**: CRUD marketingového výpisu (logo, odkaz, pořadí, kategorie support_us/partners) + REST (v20/v32).

### Entity
| Entita | Účel | Klíčová pole |
|---|---|---|
| **contract** (ContractEntity) | Vygenerovaná smlouva/dokument navázaný na žádost — jádro clusteru. | public_id (per-country), int_id (SQL sekvence), name, html (revizovatelné), file (PDF), attachment_contract/gift_proof (private), text_gift_proof, digital_signature (JSON), digital_signature_confirmation (PDF), user_id, status, revision |
| **contract_template** | HTML šablona s placeholdery a typem (str_replace v getReplacers). Revizovatelná. | name, html, contract_type (10 hodnot), user_id, revision |
| **supplier** | Dodavatel — dary jdou na fakturu, nikdy rodině. | name, ico, datova_schranka, street, city (taxonomy auto_create), zip, status |
| **supplier_to_category** | Vazba dodavatel↔oblast pomoci + e-shop. | supplier, category (taxonomy), url, name, status |
| **organisation** | Zaměstnavatel patronů (application.patron_employer_id). | name, worker (multi user ref s is_admin — custom field type worker_entity_reference), contact, logo, user_id (KAM), is_profi, status |
| **partner** | Marketingový výpis (CMS obsah). | name, logo, link, order, category (support_us/partners), langcode, status |

### Integrace
mPDF (PDF smluv + QR), SmartMailing (smlouvy_email_ke_kontrole/pro_zz), Elasticsearch (denní cron sync organizací do indexu 'organisations'), Telegram, REST (v2.0/3.0/3.2), externí podpisové obrázky z backend.patrondeti.cz, patron_base.default (getStorage, convertRcToDate, convertNumberToWords, addToQueue).

### Workflow
Contract je uzel workflow žádosti: sendContractToManager → 'contract'; sendContractToFundraiser → 'waiting_signature'; podpis ZZ (ContractFundraiserSignForm, ApplicationChangeStateInterface) → 'contract_signed'. Smlouva generována z application (žadatel, dítě, patron, koordinátor, kampaň), předpoklad uzavření příběhu; vyžaduje kontrolu připravenosti. Každý krok loguje do application_log. Organisation vstupuje jako patron_employer (statistiky + slučování duplicit přepisuje patron_employer_id). Supplier/partner do stavového workflow nezasahují.

### Technický dluh
Těsná (cirkulární) vazba contract↔application (přímá instanciace ApplicationEntity/aprofile/CampaignEntity/User); per-country natvrdo přes Settings s nekonzistentními hodnotami 'cz'/'cz1'/'ro' (číslování, podpisy) — špatně škáluje na MD; podpisové obrázky hardcoded URL na produkci; přímé SQL (getNextPublicId, OrganisationCron, RemoveDuplicatesForm skládá IN konkatenací = SQL injection, stats, getTemplates); hardcoded /tmp tempDir, predikovatelné md5 názvy PDF; rozsáhlý mrtvý kód (delivery_note, sendContractToFundraiserOld); getReplacers bez validace (tichý fallback na prázdné); zamrzlé feature flagy; nekonzistentní REST v2/3/3.2, application_contract_resource prázdný stub; míchání prezentace + logiky (listContract) + CZ/EN labely; partner mimo doménu (matoucí pojmenování).

**Sizing: střední–vysoká, nerovnoměrná.** CONTRACT těžiště (vysoká složitost — PDF+podpis engine, šablony, per-country číslování, workflow; sem většina odhadu a gap-analýzy). ORGANISATION střední (worker vazby, Elastic cron, dedupe, stats). SUPPLIER nízká-střední (2 CRUD entity + feed, hodně scaffoldu). PARTNER nízká (CMS výpis). Supplier+partner = datový/CRUD přenos (rychlé).

---

## 7. Notifikace / komunikace s uživateli

Dvě oddělené role. (1) Uživatelské e-maily: `email` (archiv + validace domén) a `notification` (event subscriber na stav žádosti); vlastní odesílání ale bydlí v `patron_base\APIMailingService` přes Mautic/SmartEmailing. (2) Provozní monitoring: `slack_integration` a `telegram_integration` (PSR-3 loggery). **Notifikace uživatelům jsou POUZE e-mail** — žádný in-app / push / SMS.

### Funkcionality
- **Archivace každého e-mailu** jako entita `email` (subject/to/from/body/template/arguments JSON/sent/error) — audit přes Views. Auto-párování na uživatele (preSave dohledá to_user_id; migrace zpětně doplní historii).
- **Odeslání šablonového e-mailu** (APIMailingService::handleMail) — resolve názvu šablony na číselné ID dle země (cz/ro/md), archivace, Mautic kontakt + sendToContact; voláno z ~50 míst napříč doménami.
- **Fronta** (mailing_queue QueueWorker) — přítomná, ale vypnutá (USE_QUEUE = FALSE → vše synchronně). **Env guard**: mimo production se neodešle, pokud adresa neobsahuje 'leerimich'/'test20'/'patrondeti'.
- **Validace domény** přes WhoisXMLAPI s cache (email_domain, TTL 180 dní). **REST** POST /api/email_validation (validace + 'eligibility' dle typu donation/patron).
- **Event-driven session** (notification, ApplicationStatusUpdateSubscriber): waiting_signature → akceptační protokol + podpisová session; waiting_for_feetback (+ remindery) → feedback session + podpis převzetí; gated feature_digital_signature.
- **Cron urgencí** (ApplicationStatusMailerController): urgence_1/2, přechody new→reminder_1→reminder_2→canceled_lead + admin report.
- **Slack** (SlackLogger PSR-3: ERROR→errors, CRITICAL→checks, ořez 1800 znaků). **Telegram** (TelegramLogger: level ≤3 na Bot API).

### Entity
| Entita | Účel | Klíčová pole |
|---|---|---|
| **email** (EmailEntity) | Archiv/log každého odeslaného e-mailu; odesílací logika v ní NENÍ. | name (subject), to, from, to_user_id (auto), user_id, campaign, application, body (email_html), template_name, arguments (JSON), sent, error, status |
| **email_domain** (nespravovaná tabulka) | Cache validace domén (raw SQL, ne entita). | domain (unique), is_valid, number_of_validations, last_validation |
| **mailing_queue** (queue + worker) | Zamýšlená async fronta — neaktivní (USE_QUEUE=FALSE). | toEmails, params, template_name, reply_to, attachments, arguments |
| **slack_queue** (queue) | Registrovaná fronta — plnění/zpracování zakomentováno (mrtvé). | — |
| **transaction_mails** (sousední bundle) | Transakční e-maily mimo tyto 4 moduly — signál roztříštěnosti. | — |

### Integrace
Mautic/SmartEmailing REST (primární kanál, BasicAuth, per-country ID šablon, contactApi->create + emailApi->sendToContact), WhoisXMLAPI (klíč hardcoded), Slack Incoming Webhooks (2 URL), Telegram Bot API, Drupal mail subsystem (přítomen, ale obcházen ve prospěch Mautic).

### Workflow
Notifikace pevně navázané na automat žádosti. notification řídí přechody signatury/feedbacku (waiting_signature, waiting_for_feetback + remindery _1/2/uncooperative) + generuje session. ApplicationStatusMailerController pohání lead lifecycle (new→reminder→canceled_lead). E-maily ze stavů/akcí: dokončení žádosti, kontrola/podpis smlouvy, platba/recurring/zrušení, uzavření kampaně, voucher flow, aktivace účtu dle role, magic link, reset hesla. Šablony mapované per-country (cz/ro/md) — multi-tenant zadrátováno v kódu.

### Technický dluh
Odesílání mimo modul email (v APIMailingService, ~50 statických call-sites — roztříštěno bez fasády); hardcoded tajemství (WhoisXMLAPI klíč, Mautic customId/senderEmail); mapování šablona→ID = velký per-country if/elseif s desítkami zakomentovaných + duplicitní RO/MD klíč; fronty vypnuté/mrtvé (USE_QUEUE=FALSE → synchronní HTTP bez retry; slack_queue nepoužitá); domainExists vrací TRUE ve všech větvích (no-op); raw SQL (email_domain, acceptance_protocol přímým UPDATE); stav doručení se netrackuje (sent/error se nenastavuje z odpovědi Mautic); jediný kanál e-mail (žádné preference/opt-out); zabetonovaný překlep waiting_for_feetback; env guard přes substring adresy; EmailValidation vrací existenci/roli neautentizovaně (enumerace).

**Sizing: strukturně nízký, integračně střední.** Cílové moduly ~14 tříd / ~1350 ř. (notification 221 ř. netriviální; email 971 ř. boilerplate; telegram 61 / slack 97). Reálný rozsah nutno počítat i s APIMailingService (~280 ř.) + MailingQueue + ~50 call-sites + ~30 šablon ve 3 zemích + transaction_mails. Reimplementace střední: jádro (unifikovaný service + template registry + fronta) zvládnutelné; gap hlavně v (a) vícekanálovosti + preferencích, (b) vytažení ~50 volání do doménových událostí, (c) katalogu šablon + per-tenant mapování.

---

## 8. Marketing (Mautic sync, Facebook tracking, ML doporučování)

Napojení donorské DB na marketingové kanály + personalizované doporučování. Malá–střední oblast; zavádějící kvůli mrtvému kódu.

### Funkcionality
- **mautic**: Drush `mautic:sync:contacts` (jen production). Inkrementální sync ve dvou proudech — syncSupporters (transakce novější než state watermark) a syncFundraisersAndPatrons (changed >= watermark). Obohacení kontaktu (role, zone_date, last_transaction_date, u supporterů transactions_total/count/avg). Přímé contacts.create (BasicAuth) + addUtm (nevyužito).
- **facebook_leads**: REST `GET/POST /api/2.2/facebook/lead` (verifikace webhook subscription; POST handler **rozbitý** — loguje nedefinovaný $request_data, nic neukládá). REST `GET /api/3.2/facebook` (relay eventů na FB Conversions API — Lead/Purchase/CompleteRegistration + generický). Payload (event_name/time/id/source_url, custom_data), hashování PII (SHA-256), detekce IP + fallback geolokace přes ip-api.com, POST na graph.facebook.com/v16.0 (hardcoded pixel + token, SSL verify OFF).
- **campaign_recommendation**: queue workery campaign_training_queue + campaign_scoring_queue (training po dokončení zařadí do scoring). EventSubscriber na TransactionUpdateEvent (PAID → training). Drush trainAll + Console train:all/campaign:scoring. Custom field type campaign_entity_reference (ref + weight). **KRITICKÉ: ML jádro fakticky vypnuté** — classifier (php-ml SVC), buildSetPredict, hook_cron zakomentované; bez classifieru trainModel/buildScores spadnou. Modul dead/experimentální.

### Entity
| Entita | Účel | Klíčová pole |
|---|---|---|
| **Mautic** (servisa) | Thin klient Mautic REST (kontakty + UTM). Bez perzistence v Drupalu. | mailing.base_uri/user/passwd |
| **Mautic Contact** (externí) | Cíl syncu — donor/patron/fundraiser s marketingovými atributy. | email, firstname/lastname, role, zone_date, last_transaction_date, transactions_total/count/avg |
| **Facebook Conversion Event** (externí CAPI) | Server-side event pro atribuci (Lead/Purchase/CompleteRegistration). | event_name/id/source_url, user_data (hashed), client_ip, custom_data (value/currency/content_ids) |
| **campaign_recommendation** (field na User) | Seřazený seznam doporučených kampaní s vahou. | target_id, weight (float) |
| **model** (field na User) | Serializovaný php-ml Classifier per uživatel. | model (serialized blob) |
| **scoring_queue / training_queue** (příznaky) | Bool řízení přeskórování/přetrénování. | scoring_queue, training_queue |
| **ML learning set** (odvozené) | Feature vektory z SQL nad transakcemi (ne perzistováno). | age, gender, gift_category one-hot (71-76), time, gathered, gift |

### Integrace
Mautic (REST contacts.create + addUtm, BasicAuth), Facebook Graph/CAPI v16.0 (pixel 298955319685762, hardcoded token), FB Lead Ads webhook (handler nefunkční), ip-api.com (http geolokace, bez timeoutu), php-ml SVC (zakomentovaná = nenasazená).

### Workflow
campaign_recommendation naslouchá TransactionUpdateEvent (PAID → training). Mautic sync čte PAID pro agregaci dárcovství + role. facebook_leads mapuje frontendové konverze na fázi dárcovské cesty, nepíše do Drupal workflow. Doporučovací skórování používá stav kampaně jako featury — ML část vypnutá, reálné zapojení dnes jen: PAID → (mrtvá) fronta + Mautic sync.

### Technický dluh
**KRITICKÁ tajemství**: hardcoded FB pixel_id + access_token (FacebookResource.php ř.133-134), webhook verify token (ř.109) — rotace do secrets. SSL verify OFF u Graph API (MITM). FacebookLeadWebhookResource::post() rozbitý (nedefinovaný $request_data, vždy 'token is invalid'). Superglobály $_GET/$_SERVER; 3.2 posílá konverze přes GET + hack na chybějící '}' v JSON. ip-api.com nezabezpečený http bez timeoutu (blokující, rate-limit). Celý ML engine zakomentovaný (services/console/drush/hook_cron/buildSetPredict) — nekonzistentní/mrtvý. Doménová logika (trainModel/buildScores/samples) v cizích třídách (PatronUser, CampaignEntity), ne v modulu. Hardcoded gift_category 71-76 v raw SQL. Per-user serializovaný model (object injection, velikost). getSlider s natvrdo user ID [9188,10380,12468] v produkci. mautic: raw SQL LEFT JOIN transaction (duplicity), guard jen production; chybí info.yml popis.

**Sizing: malá–střední, zavádějící.** mautic 2 třídy (~160 ř., triviální). facebook_leads 2 REST třídy (~325 ř., střední — CAPI/hashing/cURL, webhook nutno předělat). campaign_recommendation 8 tříd + yml, ale ~vše netriviální zakomentované; ML implementace ~340 ř. v cizích souborech. **Rozhodnutí zda vůbec** oživovat doporučování (dnes nefunkční) — pokud ano, náročná featura (SVM, feature engineering, fronty, per-tenant taxonomie); jinak celý modul zahodit.

---

## 9. Obsah a vyhledávání

Blog CMS, kontakty, feedback, Gutenberg bloky, admin vyhledávání. ~64 PHP tříd / ~8000 LOC + ~353 JS souborů (Gutenberg).

### Funkcionality
- **Blog**: vlastní content entity (base_table `blog`, NE node) — CRUD, kategorie (taxonomy blog_category), perex, galerie, slug, hero-post, doporučené články. CTA blok (cta_type/title/button/link + cta_campaign nebo dynamický cta_filter dle deadline/procent/kraje/kategorie — přímé SQL nad campaign). Publikace na homepage + set-active. Headless REST v32 (Posts/Post/Categories/Category — kategorie SQL z taxonomy). HTML→Markdown (League\HTMLToMarkdown).
- **Contact**: centrální úložiště kontaktů (osoby i instituce) jako revizovaná entita (contact/_revision/_field_revision + revert). Role přes field_name (fundraiser/child/patron/lead/school/employer/undefined — jedna entita, více rolí). Vyhledávání (SearchContactForm). **Deduplikace** (dle rc/telefonu/emailu GROUP_CONCAT; skip přes state; replaceApplications/Aprofiles/Users přepíší FK a smažou duplicity). REST resource.
- **Feedback**: content entity navázaná na campaign + fundraisera (tělo, přílohy, sent). Formuláře (CampaignFeedbackForm admin, FundraiserFeedbackForm email/lead, veřejný přes application.form_controller s guardem _application_role/_status; zápis do application_log). REST v30 + v32.
- **Gutenberg** (CS+RO): ~52 (patron_gutenberg) + ~54 (patron_gutenberg_cz) custom bloků pro homepage/landing (campaigns, members, success_stories, hiw, feedback_cards, faq, gift_examples, coronahelp…) s edit/save/block.json. Dynamické bloky čtou živá data (campaigns/members); form_alter přidává flagy do filtru; custom text formáty/inline styly + CampaignsTotal filtr.
- **Vyhledávání** (patron_search): admin fulltext UI — SearchBlock injektuje externí React SPA (bundle.js z els1.patrondeti.cz) do adminu (jen admini). Indexace do Elastic App Search (EsUploadQueue + EsUploadCommand exportují user/application/campaign/organisation/transaction do engine 'patron-search', Bearer). Elasticsearch service (audit/telemetrie REST volání do lokálního ES 9200). Cron zpracování fronty (batch 500) — **zakomentováno**.

### Entity
| Entita | Účel | Klíčová pole |
|---|---|---|
| **BlogEntity** (blog) | Blogový článek (ne node) s CTA + napojením na kampaně. | name, slug, perex, body, image/gallery, category (taxonomy), status, is_hero_post, cta_* (type/title/button/link/campaign/filter/filter_region/filter_category), user_id, created/changed |
| **ContactEntity** (contact) | Centrální revizované úložiště kontaktních údajů pro všechny role — klíčové pro GDPR a dedup. | type (person/institution), field_name (role), name/last_name/title_*, birthdate/gender, rc, ico, phone/email, street/city (taxonomy)/zip, blacklist_type, user_note, status, revision_* |
| **FeedbackEntity** (feedback) | Zpětná vazba žadatele k dokončenému příběhu, zobrazovaná dárcům. | name, body, fundraiser (user), campaign, fundraiser_images (file), status, sent, created/changed |
| **Elasticsearch dokument** (EsUploadQueue) | Denormalizovaný search dokument agregující 5 entit do engine 'patron-search'. | id (entity_type:id), entity_type/typ, name, links.view/edit, user/application/campaign/transaction pole, created/changed |
| **Blog kategorie** (taxonomy blog_category) | Klasifikace blogů s field_slug pro URL/řazení. | tid, name, field_slug, status, weight |
| **Gutenberg blok** (block.json + edit/save) | Znovupoužitelná vizuální komponenta (~106 bloků CS+RO, část dynamická). | block name, attributes, edit.js/save.js, varianta tenantu |

### Integrace
Elastic App Search (Elastic Cloud, engine 'patron-search', Bearer ELASTIC_AUTH), lokální Elasticsearch 9200 (docker, audit/telemetrie), externí React SPA (els1.patrondeti.cz, bundle.js do adminu), Telegram, WordPress Gutenberg (drupal/gutenberg), League HTMLToMarkdown, Embla/Owl carousel.

### Workflow
Obsahová vrstva z velké části mimo hlavní workflow, ale napojená: Blog CTA + dynamické Gutenberg bloky čtou stav kampaní (active, deadline, procenta). Feedback je terminální krok workflow žádosti (veřejný formulář chráněn guardem _application_status + _application_role='fundraiser', zápis do application_log). Vyhledávání průřezově read-only: EsUpload denormalizuje stavy entit do indexu (odráží workflow, neřídí ho). Contact deduplikace zasahuje do integrity dat (přepis FK). Contact nemá automat, ale má revize.

### Technický dluh
Hardcoded infra (Elastic App Search URL + engine duplicitně v Queue i Command; lokální ES host); masivní duplikace export/prepare/sendToElastic logiky pro 5 entit (2 zdroje pravdy schématu); vyhledávání fakticky rozbité (patron_search_cron zakomentován → fronta se přes cron nezpracovává, index jen ručním commandem); Drupal Console (deprecated D9/D10); Elasticsearch.php polyká chyby prázdným catch + pevné 'id'=>'my_id' přepisuje dokumenty; patron_search je jen iframe/injekce cizí neverzované SPA; rozsáhlé raw SQL místo entity API; contact dedup ničí data bez transakcí/dry-run; chybějící metadata (elasticsearch = 'My Awesome Module'); dvě paralelní Gutenberg sady (~106 bloků, divergující jazyk); ContactEntity míchá desítky rolí přes field_name bez FK integrity; blog vlastní implementace místo node (18 tříd); **Elastic dokument obsahuje PII** (RČ dítěte, telefony, e-maily) v cloud engine — GDPR riziko.

**Sizing: střední–vysoká.** Klíčová rizika: (1) reimplementace vyhledávání (rozbité + externí SPA + duplicitní indexace); (2) contact s revizemi + netriviální dedup; (3) ~106 Gutenberg bloků k migraci/přehodnocení per-tenant; (4) GDPR/PII v indexu. Contact a Gutenberg = největší nákladové položky.

---

## 10. Platforma a utility

Podpůrné/reportovací moduly. ~12 modulů, ~60 souborů. 7 content entit + 1 čistá tabulka.

### Funkcionality
- **export_csv**: 18 admin CSV exportů (/admin/export_csv/*) + rozcestník /admin/downloads. Exporty: platby/dary/gift payments, leads, fundraisers, TOP dárci, patroni, kampaně, dobrošeky, účetní report, smlouvy, report patroni (pivot 2017-2022), blacklist, lowrisk, scoring KO. Každý = ruční SQL `SELECT ... INTO OUTFILE` do /tmp/*.csv → downloadFile. Noční cron (3:00) generuje 16 do /tmp; controller servíruje cache. Permise access reports / accounting reports / export leads.
- **gdpr**: /admin/gdpr/form/gdpr-mail — anonymizace dle e-mailu (vymaže mail, name → 'u<ts><rand>'; na production smaže kontakt ze SmartMailingu). Permise access gdpr.
- **zip**: CRUD 4 číselníků územní struktury (Kraj/Okres/Obec/PSČ) + přepis exposed filtru 'kraj' ve view kampaní.
- **reports**: 8 read-only stránek /admin/reports/* (payments, campaigns + by_cord + by_days, cord-applications + productivity, accounting, leads, monthly-report [1035 ř.], dashboard). Ruční SQL nad application/campaign/transaction, vizualizace Google Charts + Chart.js. CRUD entity Costs (měsíční cíle/náklady) a Snapshot (uložené hodnoty reportů).
- **login_history**: tabulka + report /admin/reports/login-history + per-user + LastLoginBlock. **POZOR: sběr vypnutý** (hook_user_login zakomentován).
- **user_note**: revizní poznámky k uživateli/kontaktu (create/edit/revert) + report /user/{user}/notes (revize + agregace scoring poznámek z application.scoring).
- **patron_tracking**: injektuje GTM (GTM-P3FFR3CG) do <head> + noscript. **patron_devel**: 3 REST stuby (get_one_time_login_link, generický entity_resource [nezabezpečený GET nad libovolnou entitou], change_application_status [prázdný stub]) + views SQL debug pro uid==1. **simple_image_rotate**: rotace obrázků (hardcoded pole campaign.photo/blog.gallery/patron.photo). **alter_entity_autocomplete**: přepis system.entity_autocomplete (LIKE nad tabulkou patron). **sitemap**: Console 'sitemap:create' (public://sitemap.xml z kampaní + SPA sitemap.json, fallback pastebin). **onedrive**: Console 'onedrive:import:invoices' (MS Graph, párování faktur dle VS → application.attachments_audit).

### Entity
| Entita | Účel | Klíčová pole |
|---|---|---|
| **KrajEntity / OkresEntity / ObecEntity** (kraj/okres/obec) | Ploché číselníky územní struktury CZ. | name, user_id, status, created/changed |
| **PscEntity** (psc) | PSČ s referencemi na obec/okres/kraj — jediná zip entita s vazbami. | name, obec/okres/kraj (ref), status |
| **CostsEntity** (costs_entity) | Měsíční plán/výsledek pro reporting (náklady vs cíle). | year, month, published_campaign_count/price, cost, costs_target, campaigns_target(_value), donations_target_value, obedyskolakum_students/amount |
| **SnapshotEntity** (snapshot_entity) | Nasnapshotované hodnoty reportů (historizace). | report_id, field_name, field_value, created |
| **UserNoteEntity** (user_note) | Revizní poznámka k uživateli/kontaktu + agregace scoring poznámek. | name, note, user_id, status, revision_* |
| **login_history** (tabulka, ne entita) | Audit přihlášení — zápis vypnutý. | uid, login, hostname, one_time, user_agent, admin_id |

### Integrace
Microsoft Graph/OneDrive (onedrive — OAuth2 password grant, **hardcoded tenant/client/secret/username/password**), SmartMailing (gdpr, production), Google Tag Manager (GTM-P3FFR3CG hardcoded), Google Charts + Chart.js (gstatic/cdnjs), SPA/pastebin (sitemap), MySQL SELECT INTO OUTFILE (export_csv, obchází DB API).

### Workflow
Převážně podpůrný — přímo neřídí workflow, ale silně čte jeho stavy. export_csv váže na application stavy (gift_paid, gift_payment, scoring_ko/ok) + application.scoring JSON. reports/dashboard čtou stavy kampaní (active) a scoring_ok. onedrive po napárování faktury zapisuje application.attachments_audit (bez stavového přechodu, setNewRevision(FALSE)). patron_devel.change_application_status je stub. Jediný state-managing: gdpr anonymizuje user. Číselníky zip = referenční data. Sběr login_history vypnutý.

### Technický dluh
**KRITICKÉ: onedrive hardcoded MS tajemství** (clientSecret, uživatelské heslo, tenant/client ID) — rotace + odstranění z historie. export_csv ~1550 ř. ručního SQL s SELECT INTO OUTFILE do /tmp (obchází DB abstrakci, nepřenositelné mimo MySQL s FILE právem, GDPR-citlivá data v plaintextu bez úklidu, reportPatroni napevno 2017-2022); název souboru z route explode('.') křehký; cron instancuje controller mimo HTTP kontext. login_history sběr celý zakomentovaný (mrtvé). gdpr = jen anonymizace bez skutečného vymazání ostatních PII (slabá shoda). patron_devel entity_resource nezabezpečený generický GET (únik dat); change_application_status prázdný stub; views SQL debug v produkci. sitemap fallback z pastebin.com (nedůvěryhodný zdroj). Silné vazby na staré schéma přes raw SQL napříč export_csv + reports (vysoké migrační riziko). zip 4 téměř identické entity (jen psc má vazby — kandidát na sjednocení). reports grafy z externích CDN (CSP); MonthlyReport 1035 ř. + Productivity 737 ř. ručního SQL. Drupal Console (deprecated). patron_tracking hardcoded GTM ID.

**Sizing: střední, podpůrný.** LOW: tracking/autocomplete/image_rotate/gdpr/sitemap/zip-číselníky. MEDIUM: user_note, login_history, patron_devel, onedrive. **HIGH: export_csv a reports** (hustý ruční SQL těsně svázaný se starým schématem — hlavní nositel migračního rizika). Costs/Snapshot + zip číselníky přenositelné; export_csv+reports vyžadují kompletní reimplementaci nad novým datovým modelem.

---

## Multi-tenant CZ / RO / MD

Jedna kódová báze, tenant runtime přes `Settings::get('country')` ('cz' | 'ro' | 'md'). Není samostatný build/branch — všechny tři země běží ze stejného kódu, liší se jen `settings.php` instance a (u CZ) `config_split`. **RO je de-facto baseline** (default theme patron_ro, ro labely v kořenovém configu); **CZ nejvíc vyprofilovaná odchylka**; **MD nejmělčí** (řetězec 'md' v custom kódu jen 3× vs cz 49× / ro 50×).

| Oblast | CZ | RO | MD |
|---|---|---|---|
| **Řídicí mechanismus** | Settings country='cz' | country='ro' (de-facto default: system.theme default patron_ro, langcode kořenových configů často ro) | country='md', stejný mechanismus; pokrytí nejmělčí (jen platba, redirect, mailing) |
| **Platební brána** | comgate (Comgate); comgate_cron jen cz+production; CZK/CZ. Doprovodné: accounting, monetaapi | netopia (NETOPIA/mobilpay); openssl_seal, XML, RON, secure.mobilpay.ro, x509 — plně funkční | maib (MAIB, package Patron Moldova); reálná cert-cURL integrace na maib.ecommerce.md, mapování stavů, maib:reverse/close, command 'v', currency 498 (MDL) — funkčně srovnatelné s netopia |
| **Frontend theme** | patron_cz (Patron Czechia), bez src/ | patron_ro (default theme), jediný má src/ | **patron_md NEEXISTUJE** — sdílí patron_ro |
| **Jazyk / lokalizace** | config/language/cs (31 souborů), langcode cs | config/language/ro (64 souborů), ro hlavní default | **nemá config/language/md** — jede na ro (64) + ru (Russian, 101 souborů, zavedeno kvůli MD); MAIB posílá language napevno 'ro' |
| **Node type page** | 'page' (ro popisky) + 'page_cz' (Page CZ) — český pendant; per-theme page_title bloky | výchozí 'page' (ro labely); patron_ro_page_title | žádný page_md — sdílí strukturu s ro (page + patron_ro) |
| **config_split / sync_config** | config_split.config_czech (zapíná comgate, přepisuje system.site/theme, language.negotiation, pathauto, views + profily; status false). Jediný country split | nemá vlastní split — ro je zapečená v kořenovém configu (baseline) | **nemá config_split ani config_moldova** — běží na ro-baseline configu + settings.php override. Hlavní known-gap pro MD samostatnost |
| **Mailing / notifikace** | vlastní template ID (default větev); e-maily @patrondeti.cz; 'CZK (banka)' | bohatá ro větev (thanks/recurring/magic_link/campaign lifecycle/zone); doména @kidshero.ro; nejúplnější mapování | chudá md větev — jen 3 šablony (dokoncena_zadost×2, thanks_for_payment); chybí recurring/magic_link/campaign lifecycle; doména neošetřena (padá do else @patrondeti.cz) |
| **Byznys logika** (deadliny, scoring, reporty) | nejvíc dedikované logiky: MonthlyReport vyjímá campaign 2200, TransactionService price<1 jen cz, FundraiserApplicationProfileViewsField práh id>=10116 | CampaignDeadlineWorkingDay jen ro (deadline na pracovní den), ro větve v ContractEntity/CampaignEntity — srovnatelně bohaté s cz | prakticky žádná dedikovaná logika — mimo platbu/mailing MD ve větvích nefiguruje, chová se jako 'ro/else'. Contract, campaign, scoring, reports, deadline pro MD nejsou řešeny |

**Závěr o MD**: 'platebně integrované, produktově draft'. Payment rail MAIB je produkční (funkční integrace, staging alias @self.md-stag, dispatch ve dvou vrstvách — TransactionService i REST v32 TransactionResource). Ale MD nemá vlastní frontend, lokalizaci ani config izolaci — běží jako tenká odbočka nad rumunským baseline. Dva drobné bugy v MD platbě: language napevno 'ro', client_ip napevno '192.168.x.x'. Pozn.: maib.install je čistý scaffold (tabulka maib_example, mt_rand) — mrtvý zbytek, nesouvisí s reálnou integrací. **Hlavní gap pro plnou MD samostatnost**: vlastní config_split (config_moldova), vlastní theme/lokalizace, doplnění MD větví v byznys logice + mailingu.
