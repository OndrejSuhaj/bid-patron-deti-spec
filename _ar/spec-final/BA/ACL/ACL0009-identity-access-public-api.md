---
doc_id: ACL0009
title: Identity, Access & Public API
layer: ACL
spec_type: access-control
status: imported
modules: []
references:
  - EN0007
  - EN0008
  - EN0015
  - UC0014
  - UC0024
  - FN0018
  - BR-AccessControlAndRoles
  - ARCH0011
---

# ACL0009 – Identita, přístup a veřejné API

## Účel

Přístup k identitním/relačním zdrojům — User (EN0008), Account (EN0007), TaxPayer (EN0015) — tedy
REST rozhraní pro koncového uživatele (login/aktivace/profil/žádost/děti), magic-link, session token
a vlastní historie přihlášení. Zde získávají svou autoritu **relační úroveň (session tier)** a
**business role koncového uživatele**. Model aktérů je ve vlastnictví ACL0001.

## Model aktérů

- `anonymous` / `authenticated` nesou veřejný allow-list REST (config `restful get/post <resource>`).
- Role koncového uživatele (`patron`, `supporter`, `fundraiser`, `organisation_worker`) mají téměř
  žádná config oprávnění; jejich autorita nad **vlastními** záznamy vychází z **ownership kontrol
  uvnitř REST resource pluginů**, nikoli z role grantů (Hard Rule: viditelnost dle
  UI/vlastnictví není role grant — zaznamenáno explicitně).
- Několik identitních rout je chráněno pomocí `_access: 'TRUE'` (veřejné) nebo
  `_user_is_logged_in: 'FALSE'`.

Evidence: `config/user.role.anonymous.yml`, `config/user.role.authenticated.yml`;
`account/account.routing.yml`, `login_history/login_history.routing.yml`,
`patron_base/patron_base.routing.yml`; definice oprávnění `account/account.permissions.yml`,
`login_history/login_history.permissions.yml`.

## Zdroje (Resources)

- Session token `/api/3.0/session/token`, existence uživatele `/api/user/exists`
- Přihlášení magic-linkem `/magic-link/{hash}`, přihlášení `/login`, aktivační e-mail `/activation-mail`
- Formulář informací daňového poplatníka `/tax-payer-information` (TaxPayer EN0015)
- Veřejné REST: login/aktivace/status/logout, profil (get/post), žádost (create/get/repeat/cancel/progress), děti uživatele, žádosti uživatele, žádost o heslo/obnova heslo, vytvoření magic-linku
- Vlastní historie přihlášení `/user/{user}/login-history`
- Použití magic-linku (back-office) — `use magic link`

## Matice

| Aktér / role | Zdroj | Akce | Rozsah | Poznámky |
|---|---|---|---|---|
| `anonymous` | Session token `/api/3.0/session/token` | GET | veřejné | Route `_access: 'TRUE'`. |
| `anonymous` | Existence uživatele `/api/user/exists` | GET | veřejné | Route `_access: 'TRUE'`. |
| `anonymous` | Magic-link `/magic-link/{hash}` | GET | veřejné | Route `_access: 'TRUE'`; autentizace založená na tokenu (platnost 90 dní — viz BR-AccessControlAndRoles). |
| `anonymous` | Login `/login`, aktivační e-mail `/activation-mail` | POST | veřejné | `_access: 'TRUE'` / `_user_is_logged_in: 'FALSE'`. |
| `anonymous` | Informace daňového poplatníka `/tax-payer-information` (EN0015) | odeslání | veřejné | Route `_access: 'TRUE'`. |
| `anonymous` | Account login/activate/status REST | POST/GET | veřejné | `restful post account_login_resource(_v32)`, `account_activate_resource(_v32)`, `account_status_resource`. |
| `anonymous` | Profile REST (EN0007) | GET, POST | veřejné | `restful get/post profile_resource(_v32)`, `profile_slug_v32`. |
| `anonymous` | Application REST (EN0001) | create, get, repeat, cancel, progress | veřejné / vlastní | `restful post application_create_resource_v30/_v32`, `..._repeat`, `cancel_application_*`, `application_progress_*`; ownership vynucen v kódu resource. |
| `anonymous` | Děti uživatele / žádosti uživatele | GET | vlastní | `restful get user_children_resource(_v32)`, `user_application_resource_v30/_v32`; ownership v kódu resource. |
| `anonymous` | Žádost o heslo / obnova heslo | POST | veřejné | `restful post password_request_resource(_v32)`, `password_recover_resource(_v32)`. |
| `authenticated` | Logout | GET | vlastní | `restful get account_logout_resource_v32`. |
| `authenticated` | Vlastní soubory | delete | vlastní | `delete own files`. |
| `authenticated` | Superset veřejného REST | GET/POST | veřejné / vlastní | Role authenticated duplikuje allow-list anonymous + logout + contact_form_resource_32 + profile_resource_v31. |
| `patron` | (config oprávnění) | delete own files; textové formáty | vlastní | Žádné role granty na CRUD entit; přístup k vlastním záznamům je založen na ownership v REST kódu. |
| `supporter` | RecurringTransaction | cancel | vlastní | `cancel own recurring transaction` (detail ACL0005). |
| `fundraiser` | Contact (EN0006) | add, edit | globální | Detail ACL0008. |
| `organisation_worker` | vlastní soubory | delete | vlastní | pouze `delete own files`. |
| `coordinator`,`senior_coordinator`,`risk_manager` | Magic link | use | globální | `use magic link`. |
| `front` | User (EN0008) | administer, update | platformní | `administer users`, `update user entity`, `update fundraiser email`, `update patron email`. |
| `manager` | User (EN0008) | administer, `manager administer users`, update | platformní | `administer users`, `manager administer users`, `update user entity`, access user profiles. |
| `content_admin` | User (EN0008) | administer | platformní | `administer users`. |
| `manager`,`risk_manager` | Profily uživatelů | access | platformní | `access user profiles`. |
| role s `manager administer users` (`manager`) | Vytvoření uživatele `/admin/create_user` | create | platformní | Route `patron_base.manager_create_user_form` vyžaduje `manager administer users`. |
| `manager` | Všechny historie přihlášení `/admin/reports/login-history` | view | globální | `view all login histories`. |
| `manager` | Vlastní historie přihlášení | view | vlastní | `view own login history`. |
| kterýkoli uživatel (custom kontrola) | `/user/{user}/login-history` | view | vlastní | `_custom_access: LoginHistoryController::checkUserReportAccess` (kontrola ownership/admin v kódu). |

## Výjimky

- **Autorita založená na ownership není role grant.** Přístup koncového uživatele k vlastní
  žádosti/profilu/dětem/trvalé transakci je vynucen ownership predikáty v resource pluginech,
  nikoli přes `user.role.*.yml`. Podle Hard Rule 7 je toto zaznamenáno jako ownership logika,
  nikoli jako potvrzené role oprávnění; detaily predikátů jsou odloženy na fázi API/contract.
- **Několik identitních rout s `_access: 'TRUE'`** (`/api/3.0/session/token`, `/api/user/exists`,
  `/magic-link/{hash}`, `/login`, `/tax-payer-information`) je veřejných na základě požadavku route.
- Současné mezery v autentizaci (platnost magic-linku 90 dní, vypnutá flood-control ochrana na
  starších login rozhraních, vypnutý zápis historie přihlášení, vytváření admin uživatele bez CSRF
  ochrany z požadavku typu read) jsou ve vlastnictví BR-AccessControlAndRoles §Authentication;
  pouze odkázáno, neopakováno.

## Odkazy (References)

- UC: UC0014 (autentizace/správa přístupu), UC0024 (správa účtu dárce), UC0001 (odeslání žádosti)
- FN: FN0018 (identita a řízení přístupu)
- EN: EN0007 (Account), EN0008 (User), EN0015 (TaxPayer)
- BR: BR-AccessControlAndRoles
- ARCH: ARCH0011 (Identita a přístup)

## Otevřené body

- Úplný výčet ownership predikátů pro jednotlivé REST resources (která pole určují ownership u
  každého veřejného resource) je odložen na fázi API/contract.
- Rozdíl mezi back-office oprávněním magic-linku `use magic link` a veřejnou route
  `/magic-link/{hash}` (vydání vs. spotřebování) je zaznamenán; detail autorizace na straně
  vydávání je odložen.
