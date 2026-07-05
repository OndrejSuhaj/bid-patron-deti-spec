---
doc_id: ACL0001
title: Access Control Matrix (Master)
canonical_layer: ACL
spec_type: access-control
status: canonical
modules: []
references:
  - EN0008
  - FN0018
  - UC0014
  - BR-AccessControlAndRoles
  - BR-MultiTenantCountryScoping
  - BR-ReportingAndDataAccess
  - BR-ApplicationStatusGovernance
  - BR-PaymentGatewayCallbacks
  - ARCH0011
---

# ACL0001 – Matice řízení přístupu (Master)

## Účel

Hlavní model aktor/role × zdroj × akce × rozsah pro současnou platformu Patronus. Tento dokument
je jediným vlastnickým zdrojem pro **katalog rolí**, **model role-rozsah** a
**mezery v přístupu v současném stavu**. Doménové ACL dokumenty (ACL0002–ACL0010) obsahují detailní
řádky zdroj/akce pro svůj ohraničený kontext a odkazují na tento dokument pro model aktorů.

Přístup je vyjádřen jako *kdo* (role) může provést *co* (akci) na *jakém* zdroji a v *jakém*
rozsahu. Dokument **nepopisuje** ochranné mechanismy frameworku Drupal, middleware rout ani rozvržení
UI (viz omezení v `rules-ACL.md`). Atributy entit vlastní `EN*`; sémantiku pravidel `BR-*`;
chování capability `FN*`; orchestraci use-case `UC*` — jsou zde odkazovány pomocí `doc_id`, nikoli
opakovány.

## Model aktorů

Autorizace v Patronu je založena na rolích Drupalu (config: `user.role.*.yml`). Existuje patnáct rolí.
Tento agent rozlišuje tři druhy aktorů:

- **Vrstva technické relace** — `anonymous` (bez relace) a `authenticated` (jakýkoli přihlášený účet).
  Tyto role nesou veřejné/koncové REST rozhraní.
- **Obchodní pozice koncového uživatele** — `patron`, `supporter`, `fundraiser`, `organisation_worker`.
  V konfiguraci téměř bez oprávnění; jejich skutečná schopnost přichází přes veřejné REST API vázané na
  vlastnictví, nikoli na oprávnění role (viz ACL0009).
- **Back-office role** — `coordinator`, `senior_coordinator`, `front`, `manager`,
  `risk_manager`, `accountant`, `content_admin`, `marketing`, a superuživatel `administrator`.

### Katalog rolí (evidence: `config/user.role.<id>.yml`)

| Role id | Label | Weight | is_admin | Vrstva | Shrnutí přiděleného rozsahu |
|---|---|---|---|---|---|
| `administrator` | Administrátor | 2 | **true** | Back-office (super) | Obchází všechny kontroly oprávnění (Drupal `is_admin`); prázdná explicitní sada oprávnění. |
| `anonymous` | Anonymous | 0 | false | Relace | `access content`; rozsáhlý **veřejný REST** allow-list GET/POST vč. vytvoření žádosti, transakcí, dárkových poukazů a Facebook Lead webhooku (mezera G-01). |
| `authenticated` | Authenticated | 1 | false | Relace | Nadmnožina anonymního REST allow-listu + odhlášení, vyhledávání ARES, otočení obrázku, mazání vlastních souborů. |
| `patron` | Patron | 5 | false | Koncový uživatel | `delete own files`, pouze základní textové formáty. |
| `supporter` | Supporter | 3 | false | Koncový uživatel | `cancel own recurring transaction` + `restful post transaction_recurring_cancel_resource`; mazání vlastních souborů. |
| `fundraiser` | Fundraiser | 4 | false | Koncový uživatel | `add`/`edit contact entities`, mazání vlastních souborů, textové formáty. |
| `organisation_worker` | Organisation worker | 14 | false | Koncový uživatel | pouze `delete own files`. |
| `coordinator` | Coordinator | 8 | false | Back-office | CRUD Lead/Application, sloučení leadů, většina přechodů workflow, předání smlouvy manažerovi, magic link, reporty produktivity, export leadů. |
| `senior_coordinator` | Senior Coordinator | 15 | false | Back-office | Rozsah Coordinator + `change entity moderation state` (mezera G-02), předání smlouvy fundraiserovi, změna stavu moderace, reporty. |
| `front` | Front line | 11 | false | Back-office | CRUD Lead/Application, sloučení leadů, `administer users`, `update user entity`, omezená sada přechodů, export leadů. |
| `manager` | Manager | 9 | false | Back-office | Nejširší obchodní role: téměř úplný CRUD entit napříč kontexty, blacklist, organizace, transakce, smlouvy, přístup ke GDPR, `change entity moderation state` (mezera G-02), reporty, zobrazení historie přihlášení všech uživatelů. |
| `risk_manager` | Risk manager | 7 | false | Back-office | `edit application scoring risks`, přechody scoringu (`scoring_ok`/`scoring_ko`/`scoring_k_doplneni`), CRUD blacklistu/dodavatelů, stránky scoringu, scoring REST. |
| `accountant` | Accountant | 12 | false | Back-office | `access accounting reports`, `use ... transition gift_paid`, zobrazení žádostí + archivu. Úzký rozsah. |
| `content_admin` | Content Admin | 6 | false | Back-office | Administrace kampaní/patronů/kontaktů/taxonomie, `bypass node access`, `administer users`, téměř úplná sada přechodů. |
| `marketing` | Marketing | 10 | false | Back-office | Autorizace CMS node/blog/block/gutenberg, `bypass node access`, `administer users`, `export leads`, reporty. |

Slovník rozsahů použitý v maticích:

- `own` — omezeno na záznamy vlastněné / propojené s aktivním účtem (vynucováno v kódu, nikoli
  oprávněním role — viz ACL0009).
- `global` — bez omezení napříč všemi záznamy, na které se oprávnění vztahuje; **žádný filtr
  země/tenanta** (viz mezera G-03 a BR-MultiTenantCountryScoping).
- `platform` — administrativní/celoplošné (`administrator`, `bypass node access`, `administer users`).
- `public` — dosažitelné bez back-office role (vrstva relace / REST allow-list).

## Zdroje (Resources)

Rodiny zdrojů nejvyšší úrovně (detailní řádky jsou v odkazovaných doménových ACL dokumentech):

- Application / Lead / ApplicationProfile / status log žádosti → ACL0002 (EN0001, EN0002, EN0025)
- ScoringRecord / Blacklist / Supplier / stránky scoringu → ACL0003 (EN0016, EN0017, EN0019)
- Campaign / Patron / Blog / CMS nodes / Voucher / taxonomie / Feedback → ACL0004 (EN0004, EN0005, EN0013, EN0024)
- Transaction / RecurringTransaction / callbacky platebních bran → ACL0005 (EN0009, EN0010)
- TransactionComgateToBank / TransactionBank / BankTransactionMail / snímky nákladů a reportů / exporty CSV → ACL0006 (EN0029, EN0030, EN0031, EN0032)
- Contract / ContractTemplate / DonationConfirmation → ACL0007 (EN0011, EN0012, EN0014)
- Contact / Organisation / UserNote / Partner → ACL0008 (EN0006, EN0018, EN0023, EN0020)
- User / Account / TaxPayer / historie přihlášení / veřejné REST rozhraní / magic link → ACL0009 (EN0007, EN0008, EN0015)
- Přístup ke GDPR / administer * / platformní administrace → ACL0010

## Matice (průřezové shrnutí)

Zde jsou uvedena pouze průřezová oprávnění definující role; řádky CRUD po jednotlivých zdrojích jsou v ACL0002–ACL0010.

| Aktor / role | Zdroj | Akce | Rozsah | Poznámky |
|---|---|---|---|---|
| `administrator` | * | * | platform | `is_admin: true`; obchází kontroly oprávnění; v bráně přechodů `getAllowedStates()` je také považován za super-roli. Evidence: `config/user.role.administrator.yml`, `application/src/Entity/ApplicationEntity.php:1405`. |
| `anonymous` | veřejné REST zdroje | GET/POST (allow-listed) | public | 90+ oprávnění `restful get/post <resource>`. Evidence: `config/user.role.anonymous.yml`. |
| `anonymous` | Facebook Lead webhook | GET, POST | public | `restful get/post facebook_lead_webhook_resource` přiděleno anonymnímu uživateli; autentizace zdroje je pouze `cookie`. Mezera G-01. Evidence: `config/user.role.anonymous.yml:156,199`; `config/rest.resource.facebook_lead_webhook_resource.yml`. |
| `authenticated` | veřejné REST + vlastní soubory + ARES | GET/POST, mazání, vyhledávání | own / public | `ares search by ico`, `delete own files`, `rotate images`. Evidence: `config/user.role.authenticated.yml`. |
| `supporter` | RecurringTransaction | zrušení | own | `cancel own recurring transaction` + `restful post transaction_recurring_cancel_resource`. Detail: ACL0005. Evidence: `config/user.role.supporter.yml`. |
| `manager`,`senior_coordinator` | moderation_state žádosti (Application) | vynucená změna stavu | global | `change entity moderation state` → `ChangeModStateForm` obchází kontrolu legality přechodu (mezera G-02). Detail: ACL0002. |
| `manager` | oblast GDPR | přístup | global | `access gdpr`. Detail: ACL0010. Evidence: `config/user.role.manager.yml`. |
| `front`,`manager`,`content_admin`,`marketing` | Uživatelské účty | administrace | platform | `administer users` u neadministrátorských back-office rolí. Detail: ACL0009/ACL0010. |
| `content_admin`,`manager`,`marketing` | Nodes | obejití přístupu k node | platform | `bypass node access`. Detail: ACL0004. |
| back-office role pro reporting | exporty CSV | stažení | global (bez filtru země) | Exportní routy jsou chráněny pouze `access reports` / `export leads` / `access accounting reports`; bez rozsahu na úrovni tenanta (mezera G-03). Detail: ACL0006. |

## Výjimky

- **Rozsah země / tenanta není v současném systému dimenzí ACL.** Žádné oprávnění role, požadavek
  routy ani exportní dotaz nefiltruje záznamy podle CZ/RO/MD. Čtení napříč zeměmi je tedy možné pro
  jakoukoli roli, jejíž oprávnění zdroj pokrývá. Vlastní BR-MultiTenantCountryScoping; zde uvedeno
  jako mezera G-03.
- **`administrator` obchází** jak kontroly oprávnění Drupalu, tak allow-list přechodů na úrovni kódu
  (`getAllowedStates()` považuje `administrator` za bezpodmínečně povoleného).
- **Obchodní pozice koncového uživatele se spoléhají na kontroly vlastnictví v kódu, nikoli na
  oprávnění role.** `patron`/`supporter`/`fundraiser` jednající přes REST API je autorizován logikou
  vlastnictví v pluginu zdroje, nikoli přidělením role. Viz ACL0009.

## Mezery v přístupu v současném stavu (nálezy)

Tyto nálezy jsou zaznamenány, nikoli vyřešeny. Každý je `Confirmed` vůči kódu/konfiguraci.

| ID | Mezera | Zdroj / rozhraní | Evidence | Vlastnící BR |
|---|---|---|---|---|
| **G-01** | Facebook Lead webhook dosažitelný **anonymním** uživatelem (GET+POST), autentizovaný pouze pomocí `cookie`; webhook vytvářející Lead nemá žádnou bránu na úrovni role. | `facebook_lead_webhook_resource` | `config/user.role.anonymous.yml:156,199`; `config/rest.resource.facebook_lead_webhook_resource.yml`; `facebook_leads/src/Plugin/rest/resource/FacebookLeadWebhookResource.php` | BR-AccessControlAndRoles |
| **G-02** | **Legalita přechodu není vynucena** na živém formuláři změny stavu moderace. `ChangeModStateForm` nabízí *všechny* stavy přes `getApplicationModStats()` a volá `setState($value, true, …)` (vynucený), který zapisuje `moderation_state` přímo + surové SQL INSERT do `application_states`, čímž obchází bránu `transitions`/`transition_roles` z `application_states.yml`, kterou respektuje `getAllowedStates()`. Chráněno pouze jediným oprávněním `change entity moderation state`. | moderation state žádosti (Application, EN0001) | `application/src/Form/ChangeModStateForm.php:48,80`; `application/src/Entity/ApplicationEntity.php:292–327,1396–1425`; `application/application.routing.yml` (`application.change_mod_state_form`) | BR-ApplicationStatusGovernance |
| **G-03** | **Chybí rozsah země/tenanta u exportů** (i u back-office čtení obecně). Exportní CSV routy vyžadují pouze `access reports`/`export leads`/`access accounting reports`; exportní kontrolér neaplikuje žádný filtr CZ/RO/MD, takže jakákoli autorizovaná role může exportovat data napříč tenanty. | routy `export_csv.*` | `export_csv/export_csv.routing.yml`; `export_csv/src/Controller/ExportCSVController.php` (bez podmínky na zemi/langcode v dotazech) | BR-MultiTenantCountryScoping, BR-ReportingAndDataAccess |
| **G-04** | **Zápisy stavu surovým SQL bez rozsahu workflow.** Změny stavu žádosti jsou persistovány přes ručně psaný `INSERT` do `application_states` a přímé `set('moderation_state', …)`, mimo validaci přechodů content-moderation. V kombinaci s G-02 to znamená, že vynucený/nelegální stav může být uložen bez jakékoli kontroly legality. | historie stavů žádosti | `application/src/Entity/ApplicationEntity.php:312–327` | BR-ApplicationStatusGovernance |
| **G-05** | **Callback routy platebních bran jsou fakticky veřejné.** ComGate `/transaction/status_update`, MAIB `/transaction/status_update` a routy Netopia confirm/redirect vyžadují pouze `access content` (které má i anonymní uživatel). Autenticita callbacku se spoléhá na podpisy na straně brány, nikoli na ACL Patronu. | kontroléry platebních callbacků | `comgate/comgate.routing.yml`; `maib/maib.routing.yml`; `netopia/netopia.routing.yml` | BR-PaymentGatewayCallbacks |
| **G-06** | **Dva paralelní modely autorizace pro přechody žádosti (Application)**, které nejsou udržovány synchronně: (a) konfigurační oprávnění `use application_workflow transition <X>` na roli, a (b) kódový allow-list `transition_roles` v `application_states.yml`. Role může mít jedno bez druhého; `ChangeModStateForm` nerespektuje žádné z nich. | přechody žádosti (Application) | `config/user.role.*.yml` (`use application_workflow transition *`); `application/application_states.yml` (`transition_roles`) | BR-ApplicationStatusGovernance |

## Odkazy (References)

- UC: UC0014 (autentizace/správa přístupu), UC0002 (orchestrace změny stavu žádosti), UC0017 (export reportovacích dat), UC0005/UC0006 (dar/potvrzení platby)
- FN: FN0018 (identita a řízení přístupu), FN0002 (orchestrace stavu žádosti), FN0020 (reportovací export CSV)
- EN: EN0008 (User), EN0007 (Account), EN0001 (Application)
- BR: BR-AccessControlAndRoles, BR-MultiTenantCountryScoping, BR-ReportingAndDataAccess, BR-ApplicationStatusGovernance, BR-PaymentGatewayCallbacks
- ARCH: ARCH0011 (Identita a přístup)

## Otevřené body

- Autorizace koncových uživatelských REST zdrojů (patron/supporter/fundraiser) založená na vlastnictví
  je vynucována v kódu pluginu zdroje, nikoli v konfiguraci; predikáty vlastnictví po jednotlivých
  zdrojích jsou katalogizovány na vrstvě API kontraktů (ještě nevygenerováno) — viz otevřené body v ACL0009.
- Přesná divergence mezi allow-listem `transition_roles` (kód) a oprávněními `use ... transition`
  (konfigurace) po jednotlivých rolích a klíčích přechodu je vyjmenována v ACL0002; úplné
  párování řádek po řádce je odloženo na fázi API/kontraktů.
