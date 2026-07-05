---
doc_id: API0001
title: Account Profile & Auth API
canonical_layer: API
spec_type: api-contract
status: canonical
modules: []
contract_type: rest-public
references:
  - UC0014
  - UC0024
  - FN0018
  - EN0008
  - EN0006
  - EN0007
  - EN0034
---

# API0001 – Account Profile & Auth API (Profil účtu a autentizace)

## Účel

Veřejné REST rozhraní modulu `account`: přihlášení/odhlášení, samoregistrace, aktivace účtu,
obnova/reset hesla, vydání a konzumace magic-linku, vydání session/CSRF tokenu a čtení/úprava
vlastního profilu přihlášeného uživatele. Jde o transportní realizaci UC0014 (Authenticate & Manage
Access) a UC0024 (Manage Donor Account — Self-Service) a schopnosti identity/session, kterou
vlastní FN0018.

Modul je verzován „on place" (`/api/2.3/...`, `/api/3.0/...`, `/api/3.1/...`, `/api/3.2/...`).
V aktuálním stavu souběžně existuje více zapnutých verzí téže logické operace; tato smlouva je
slučuje do jedné logické operace per řádek a rozdíly v chování mezi verzemi uvádí zvlášť, místo aby
každou verzi popisovala jako samostatnou smlouvu. **Aktuálně používaná verze: v3.2** (nejnovější
varianty resource); starší verze (v0/"2.3", v3.0, v3.1) zůstávají v současném kódu zapnuté jako REST
resource a jsou zde dokumentovány tak, jak jsou — nepředpokládá se, že jsou vyřazené z provozu.

## Konzumenti

- **Customer** (nepřihlášený návštěvník, nebo přihlášený žadatel/patron/fundraiser/supporter) —
  front-end SPA klient, dle UC0014/UC0024.
- **System** (server-side, stejná hranice request/response) — pro větve vyhledání profilu podle
  `user_id`/`slug`, které nevyžadují vlastní session volajícího (viz Otevřené otázky — tyto větve
  jsou pojaty jako veřejná/query schopnost nasazená na stejný resource, nikoli jako samostatný
  konzument).

## Autorizace

Všechny endpointy tohoto modulu jsou registrovány jako konfigurační entity `rest.resource.*`
s `authentication: [cookie]` (Drupal session-cookie autentizace) a **bez omezení `_permission` nebo
`_role` na úrovni konfigurace REST resource** — přístup je vynucen, pokud vůbec, jen uvnitř vlastní
PHP logiky každého resource, nikoli deklarativně. Ověřeno proti
`config/rest.resource.account_*`, `config/rest.resource.profile_*`, `config/rest.resource.password_*`,
`config/rest.resource.send_activation_email_resource*`, `config/rest.resource.create_magic_link_resource_v32.yml`,
`config/rest.resource.email_organisation_resource.yml` (všechny `authentication: [cookie]`, bez klíče
`access_check`/`permission`) (Confirmed).

Skutečná autorizace na úrovni jednotlivé operace, dle samotného kódu resource:

- **Login, register, activate, password-recover, password-request, vydání magic-linku, vydání
  tokenu/CSRF** — záměrně otevřeno anonymním volajícím (to je smyslem těchto endpointů); oprávnění na
  úrovni účtu `use magic link` existuje v `account.permissions.yml`, ale žádný z REST resource ani
  jejich konfigurace na něj neodkazuje — pro tuto smlouvu je nevyužité (Confirmed: `grep` použití
  `account.permissions.yml` nenašel žádný odkaz z REST vrstvy; **Open Item** kde, pokud vůbec, je toto
  oprávnění skutečně ověřováno).
- **Logout** (v3.2) — operuje s jakoukoli aktuální session; nekontroluje, že je volající skutečně
  přihlášen, než session zruší (Confirmed, `AccountLogoutResource::get()`).
- **Profile GET/POST (v3.0/v3.1)** — cílového uživatele odvozuje z query parametru `user_id` (UUID)
  nebo `slug` **bez kontroly, že session volajícího odpovídá cílovému `user_id`** — kterýkoli
  volající, přihlášený i nepřihlášený, může číst nebo zapisovat pole profilu jiného uživatele, pokud
  zadá jeho UUID nebo slug (Confirmed hazard; viz Rizika).
- **Profile GET/POST (v3.2)** — vyžaduje `\Drupal::currentUser()->isAuthenticated()` pro GET a cíl
  vždy odvozuje z `$this->currentUser`, tj. ze session volajícího — tato verze uzavírá mezeru
  impersonace z v3.0/v3.1 pro cestu vlastního profilu přihlášeného uživatele (Confirmed,
  `v32/ProfileResource.php`). GET v3.2 dále nese nedokumentovaný query flag `backend_access_check`,
  který, pokud je přítomen, ignoruje běžnou odpověď s poli profilu a místo toho vrací 200/403 podle
  příslušnosti k pevně zadanému seznamu back-office rolí (`accountant`, `administrator`,
  `content_admin`, `coordinator`, `front`, `manager`, `marketing`, `risk_manager`,
  `senior_coordinator`) — kontrola role propašovaná do resource pojmenovaného pro čtení profilu, bez
  jakéhokoli křížového ověření proti vrstvě `ACL`, protože pro tuto operaci ještě žádná neexistuje
  (Confirmed code fact; **Open Item** — vypadá to jako postranní kanál pro kontrolu přístupu využívaný
  jinou částí systému, nikoli jako součást deklarovaného účelu tohoto profilového kontraktu).
- **Profile-organisation, profile-slug, vyhledání email-organisation-eligibility** — dle návrhu
  čitelné anonymně; bez kontroly session (Confirmed).

Pro tento modul dosud neexistuje žádný `ACLxxxx` doklad; tato smlouva zaznamenává skutečnost
autorizace přímo z kódu a konfigurace rolí (`config/user.role.*`), než vznikne dedikovaný ACL průchod.

## Request / Response

Seskupeno podle rodiny operací. Všechna request/response těla jsou JSON (`formats: [json]` na každé
konfigurační entitě `rest.resource.*` v rozsahu); u všech pozorovaných odpovědí je nastaveno
`#cache: false` (nikdy necachovatelné).

### 1. Login

| Verze | Metoda + cesta | Confirmed/Partial |
|---|---|---|
| v0 ("2.3") | `POST /api/2.3/user/login` | Confirmed |
| v3.1 | `POST /api/3.1/user/login` | Confirmed |
| v3.2 | `POST /api/3.2/user/login` | Confirmed |

Request:

| Pole | Význam | Povinné | Poznámky |
|---|---|---:|---|
| `email` | Přihlašovací identifikátor | ano (pokud není dodáno `hash`, jen v3.2) | |
| `password` | Heslo k účtu | ano (pokud není dodáno `hash`, jen v3.2) | |
| `hash` | Base64 řetězce `uid/timestamp/salt` — přihlašovací token namísto hesla | ne | jen v3.2; viz Rizika — volání ověřující salt cílí na metodu account-service, která v kódové základně neexistuje (nefunkční větev) |

Response (úspěch):

| Pole | Význam | Poznámky |
|---|---|---|
| `status` | `"success"` | chybí ve v0 |
| `user_id` | UUID volajícího uživatele (EN0008) | jen v3.1/v3.2; chybí ve v0 |
| `cookie_name` / `cookie_value` | Název/hodnota session cookie | jen v0 |
| `csrf_token` | REST CSRF token pro následné zapisující volání | všechny verze |

Chybové výsledky: `missing_credentials` / `missing_credentials_email` / `missing_credentials_password`
(400/401), `user_is_not_active` (účet blokován, 401), `invalid_username_or_password` /
`invalid_credentials` (401), chybová zpráva flood-control (401, natvrdo zapsaný anglický řetězec,
nikoli přeložený klíč) — mezery ve vynucování viz Rizika.

### 2. Logout

| Verze | Metoda + cesta |
|---|---|
| v3.2 | `GET /api/3.2/user/logout` |

Bez request těla. Response: `{"status": "success"}` (200) — vždy, bez ohledu na to, zda session
existovala (viz Autorizace).

### 3. Samoregistrace

| Verze | Metoda + cesta |
|---|---|
| v0 ("2.3") | `POST /api/2.3/account/register` |

Request: přijímá libovolné pole `data`; **resource žádné pole nečte ani nevaliduje**.
Response: `{"status": "success"}` (200) bezpodmínečně. Tento endpoint je **nefunkční stub** —
nic nevytváří (Confirmed, tělo `AccountRegisterResource::post()` je jediný nepodmíněný return).
Skutečné chování samoregistrace popsané v UC0014.2/FN0018 zajišťuje jiný, ne-REST registrační
mechanismus, který tento stub nevolá — viz Rizika.

### 4. Reset účtu

| Verze | Metoda + cesta |
|---|---|
| v0 ("2.3") | `POST /api/2.3/account/reset` |

Request: přijímá libovolné `data`; **žádné pole se nečte**. Response: `{"status": "success"}` (200)
bezpodmínečně — také nefunkční stub (Confirmed, `AccountResetResource::post()`).

### 5. Aktivace účtu (nastavení hesla z aktivační session)

| Verze | Metoda + cesta |
|---|---|
| v0 ("2.3") | `GET /api/2.3/user/activate/{session_id}`, `POST /api/2.3/user/activate` |
| v3.2 | `GET /api/3.2/user/activate/{session_id}`, `POST /api/3.2/user/activate` |

GET request: `session_id` (segment cesty, musí být řetězec ve tvaru UUID o délce 36 znaků). Response
(úspěch): `{"status": "valid", "email": "<e-mail uživatele>"}` (200). Chyba: `{"status": "invalid",
"error": "session_invalid"}` (400).

POST request:

| Pole | Význam | Povinné | Poznámky |
|---|---|---:|---|
| `session_id` | Identifikátor aktivační session | ano | musí mít 36 znaků |
| `password` | Nové heslo k nastavení | ano | minimálně 6 znaků |

Response (úspěch, v0): `{"csrf_token": "..."}` (200). Response (úspěch, v3.2): `{"csrf_token":
"...", "login_hash": "..."}` (200) — v3.2 navíc vrací login-hash, který klient může využít v poli
`hash` přihlašovacího endpointu v3.2 (samo o sobě nefunkční — viz Rizika). Chyba:
`session_invalid` (400) nebo `password_too_short` (400).

Vedlejší efekty (úspěch): heslo cílového uživatele je nastaveno, `activate_session` je vymazána,
účet je aktivován, časové značky posledního přístupu/přihlášení jsou aktualizovány a uživatel je
uložen (přechod stavu EN0008: Registered → Active, dle FN0018/UC0014).

### 6. Stav účtu

| Verze | Metoda + cesta |
|---|---|
| v0 ("2.3"→publikováno jako kanonické v3.0) | `GET /api/3.0/user/status/{user_id}` |
| v3.2 | `GET /api/3.2/user/status` |

Request v3.0: `user_id` (segment cesty; UUID cílového uživatele, vyhledatelné kýmkoli, bez omezení na
vlastní účet). Response (úspěch): `{"activated": <bool>, "activation_email_sent": <bool>}` (200) —
druhá hodnota je odvozena z toho, zda cílový uživatel má jakoukoli transakci (EN0009) se stavem
`PAID`. Chyba: `{"status":"error","error":"user_not_found"}` (404).

Request v3.2: žádný — odvozuje se striktně ze session volajícího. Response: prázdné tělo, 200, pokud
session odpovídá reálnému uživateli, jinak 403. **Pozn.: v3.0 a v3.2 nejsou stejná smlouva** —
v3.0 je veřejné vyhledání stavu podle UUID; v3.2 je sondáž živosti session bez datového payloadu
(Confirmed — expozici neomezeného vyhledání v3.0 viz Rizika).

### 7. Obnova hesla (ověření reset hashe) a reset hesla

| Verze | Metoda + cesta |
|---|---|
| v0 ("2.3") | `GET/POST /api/2.3/user/password/recover` |
| v3.2 | `GET/POST /api/3.2/user/password/recover` |

v0 GET/POST: bezpodmínečně vrací `{"valid": true}` (200) — **nefunkční stub**, žádná validace
se skutečně neprovádí (Confirmed). Konfigurační entita `rest.resource.password_recover_resource` pro
v0 je navíc vypnutá (`status: false`), takže v0 v aktuální konfiguraci vůbec není směrovatelná
(Confirmed z konfigurace) — zde je uvedena pouze pro úplnost/historii verzí.

v3.2 GET request:

| Pole | Význam | Povinné |
|---|---|---:|
| `email` | E-mail účtu (query parametr) | ano |
| `hash` | Dříve vydaný reset hash (query parametr) | ano |

Response: `{"valid": true}` (200), pokud hash odpovídá rehashi posledního přihlášení účtu;
`{"valid": false}` (400) jinak. Chyba: `missing_credentials_email` (401), `hash_invalid` (400),
`user_is_not_active` (401), `user_not_found` (404).

v3.2 POST request:

| Pole | Význam | Povinné | Poznámky |
|---|---|---:|---|
| `email` | E-mail účtu | ano | |
| `hash` | Reset hash | ano | |
| `new_password` | Nové heslo | ano | minimálně 6 znaků |

Response (úspěch): `{"csrf_token": "...", "login_hash": "..."}` (200). Vedlejší efekt: heslo je
nastaveno, uživatelské jméno je přenastaveno na zadaný e-mail, uživatel je uložen (Confirmed —
`PasswordRecoverResource (v32)::post()`; komentář v kódu označuje přenastavení uživatelského jména
jako obranný workaround, nikoli navržený krok). Chybové výsledky jako výše plus
`password_too_short` (400).

### 8. Žádost o reset hesla (spuštění e-mailu „zapomenuté heslo")

| Verze | Metoda + cesta |
|---|---|
| v0 ("2.3") | `POST /api/2.3/user/password/request` |
| v3.2 | `POST /api/3.2/user/password/request` |

Request: `email` (povinné). Response (úspěch): `{"status": "success"}` (200) — e-mail s resetem
hesla je odeslán prostřednictvím kapacity transakčních zpráv (viz FN0018/UC0014; obsah zprávy
vlastní vrstva MSG, zde neopakováno). Chyba: `missing_credentials_email` (401), `user_is_not_active`
(401), `user_not_found` (404). v0 a v3.2 jsou funkčně identické (bit po bitu shodná logika)
(Confirmed).

### 9. Vytvoření a konzumace magic-linku

| Verze | Metoda + cesta |
|---|---|
| v3.2 | `POST /api/3.2/user/create_magic_link` |
| n/a (route, nikoli REST resource) | `GET /magic-link/{base64hash}` (route `account.login`, `AccountController::oneTimeLogin`) |

Request na vytvoření magic-linku: `email` (povinné; validováno na základní tvar e-mailu přes
`patron_base.default`). Response (úspěch): `{"status": "success"}` (200) — magic-link e-mail je
odeslán (obsah zprávy vlastní vrstva MSG). Chyba: `invalid_email_address` (400), `user_not_found`
(404).

Konzumační strana (`/magic-link/{base64hash}`) je **Drupal route + controller, nikoli REST
resource** — je mimo rámec této REST smlouvy dle rules-API (žádný detail na úrovni controlleru) a
je registrována s `_access: 'TRUE'` v `account.routing.yml` (otevřená pro kohokoli, včetně již
přihlášených — zakomentovaný požadavek `_user_is_logged_in: 'FALSE'` ukazuje, že toto bylo v určitém
okamžiku záměrně uvolněno) (Confirmed z `account.routing.yml`).

### 10. Session / CSRF token

| Verze | Metoda + cesta |
|---|---|
| bez verze | `GET /api/session/token` (route `account.csrftoken` → jádrový Drupal `CsrfTokenController`) |
| v3.0 | `GET /api/3.0/session/token` (route `account.csrftoken`, stejný controller) |
| custom | `GET /api/session/token` (REST plugin `token_resource`, odlišný od výše uvedených dvou routes) |

REST plugin `token_resource` (`canonical = /api/session/token`) odpovídá `{"csrf_token": "..."}`
(200). Obě routes `account.csrftoken` směřují na jádrový Drupal `CsrfTokenController`, nikoli na kód
modulu account, a jsou deklarovány s `_access: 'TRUE'` — mimo rozsah detailu na úrovni controlleru
dle rules-API; zde uvedeno pouze proto, že cesta koliduje s custom REST resource pluginem se stejným
nominálním účelem (viz Rizika).

### 11. Odeslání / opětovné odeslání aktivačního e-mailu

| Verze | Metoda + cesta |
|---|---|
| v3.0 | `POST /api/3.0/user/send_activation_email` |
| v3.2 | `POST /api/3.2/user/send_activation_email` |

Request: `email` (povinné). Response (úspěch): `{"status": "successful"}` (200); aktivační e-mail je
(znovu) odeslán. Chyba: `missing_credentials_email` (401), `user_not_found` (404),
`user_is_active` (401, tj. účet je již aktivní — kontrola je obrácená oproti tomu, co název
napovídá: odmítá, pokud účet **není** blokovaný), `no_role` (401, pokud cílový uživatel nemá žádnou
z rolí `supporter`/`fundraiser`/`patron`/`organisation_worker`). v3.0 a v3.2 jsou funkčně identické
(Confirmed).

### 12. Vlastní profil — čtení a úprava

| Verze | Metoda + cesta |
|---|---|
| v3.0 | `GET/POST /api/3.0/user/profile` |
| v3.1 | `GET/POST /api/3.1/user/profile` |
| v3.2 | `GET/POST /api/3.2/user/profile` |
| v3.2 | `GET /api/3.2/user/profile/{slug}` (`profile_slug_v32`, veřejné vyhledání profilu podle slug) |

GET (v3.0): cíl se odvozuje z query parametru `user_id` **nebo** `slug` — kterýkoli volající, bez
vazby na session (viz Rizika). GET (v3.1): cílem je vždy uživatel vlastní session volajícího
(`User::load($this->currentUser->id())`) bez fallbacku. GET (v3.2): vyžaduje přihlášenou session
(jinak 403); rovněž vždy cílí na uživatele vlastní session volajícího; nese postranní kanál
`backend_access_check` popsaný v Autorizaci.

Pole response (všechny verze, z `PatronUser::getUserApiFields()` — vlastní EN0008/EN0006, zde
citováno, ne opakováno): `organisation_id`, `organisation_name`, `organisation_logo`, `user_image`,
`public`, `worker_available`, `slug`, `title_prefix`, `title_suffix`, `first_name`, `last_name`,
`name_format`, `email`, `badges`, `roles`, `user_id`, `donated_amount`, `campaigns_total`,
`salutation`. Sémantiku atributů viz EN0008 a související read-model účtu dárce viz EN0034. Chyba:
`user_not_found` (404).

POST request (pole, která resource skutečně čte a aplikuje — cokoli dalšího zaslaného je
ignorováno):

| Pole | Význam | Povinné | Poznámky |
|---|---|---:|---|
| `public` | Příznak veřejné viditelnosti | ne | aplikováno na uživatele (EN0008) |
| `worker_available` | Příznak dostupnosti pracovníka | ne | aplikováno na uživatele (EN0008) |
| `title_prefix` / `title_suffix` | Přídomky ke jménu | ne | aplikováno na kontakt (EN0006); max. 32 znaků dle UC0024 |
| `first_name` | Křestní jméno | ne | aplikováno na pole `name` kontaktu |
| `last_name` | Příjmení | ne | aplikováno na kontakt (EN0006) |
| `name_format` | Režim zobrazovaného jména | ne | `full` \| `short` \| `hidden`; aplikováno na kontakt (EN0006) |
| `user_image` | UUID nahraného souboru (pole, použit první prvek) | ne | vzor upload-then-attach; generují se tři pevné odvozené obrazové styly (`324x326`, `324x326@2`, `324x326@3`) |
| `password_old` / `password_new` | Změna hesla | ne | **jen v3.0/v3.1** — v v3.2 zcela chybí (viz Rizika / UC0024 AF3) |
| `user_id` / `slug` | Odvození cílového uživatele (jen v3.0/v3.1) | ne | ve v3.2 se nečte vůbec — ta se vždy vztahuje k uživateli vlastní session |

Response (úspěch): stejná sada polí jako u GET, odráží aplikované změny. Chyba: `user_not_found`
(404, jen v3.0/v3.1 — v3.2 má vždy odvoditelný cíl, protože je vázána na session);
`password_old_not_accepted` (400, jen v3.0/v3.1, když se `password_old` nepodaří ověřit — request
je v takovém případě zcela zamítnut, žádné jiné zadané pole se v takovém případě neaplikuje).

**`email` není přijímaným polem pro úpravu v žádné verzi** — viz UC0024 AF2 (mezera aktuálního
stavu: uživatelské rozhraní nastavení účtu zobrazuje pole pro e-mail, ale žádná verze této smlouvy
neumožňuje přihlášenému volajícímu změnu e-mailu).

### 13. Vyhledání profile-organisation (fundraiseři napojení na patrona)

| Verze | Metoda + cesta |
|---|---|
| v0 ("2.3"→publikováno pod 3.0) | `GET /api/3.0/mandators` |

Request: `user_id` (query parametr; UUID patrona). Response (úspěch): pole
`{"user_id": "<UUID fundraisera>", "name": "<celé jméno fundraisera>"}`, jedna položka na každou
žádost (EN0001, citováno, ne opakováno), kde má daný patron napojeného fundraisera. Chyba:
`{"error": "user_not_found"}` (404). Bez omezení na session — kterýkoli volající se zadáním platného
`user_id` může tento seznam získat (Confirmed; v souladu s celomodulovým vzorem anonymní
cookie-autentizace, samostatně jako riziko neuvedeno nad rámec toho, co je již zaznamenáno pro
vyhledání profilu).

### 14. Vyhledání veřejného profilu podle slug a vyhledání eligibility (query, anonymní)

| Verze | Metoda + cesta |
|---|---|
| v0 | `GET /api/3.0/auth/email/eligible/{type}` (`email_organisation_resource`) |
| v3.2 | `GET /api/3.2/user/profile/{slug}` (`profile_slug_v32`, viz též bod 12) |

Request na eligibility: `type` (cesta, musí být `donation` nebo `patron`), `email` (query
parametr). Response: `{"eligible": <bool>}` (200) — pro `type=donation` je true, pokud pro daný
e-mail neexistuje žádný uživatel, nebo pokud existující uživatel nemá roli `organisation_worker`; pro
`type=patron` je true, pokud uživatel neexistuje, nebo pokud má existující uživatel nastaven příznak
dostupnosti pracovníka (EN0008). Chyba: `{"error": "missing_type"}` (404), pokud `type` není jedna
z těchto dvou povolených hodnot.

Request na profil podle slug: `slug` (cesta). Response: `PatronUser::getUserApiFields()` (stejný
tvar jako v bodě 12) pro uživatele odpovídajícího slugu **a** s příznakem `public = 1`;
`{"error": "user_not_found"}` (404) jinak; `{"error": "empty_slug"}` (400), pokud slug nebyl zadán.

## Vedlejší efekty

- Úspěšné přihlášení/aktivace/konzumace magic-linku/reset hesla: session je založena, časové značky
  posledního přihlášení / posledního přístupu na uživateli (EN0008) jsou aktualizovány — viz UC0014.
- Úspěšná aktivace účtu nebo reset hesla: uživatel přechází ze stavu Registered do Active
  (lifecycle EN0008, vlastní EN0008 — citováno, ne opakováno).
- Úspěšná úprava profilu: pole kontaktu (EN0006) jsou aktualizována a při jakékoli změně pole
  kontaktu je uložena nová revize kontaktu; pole uživatele (EN0008) jsou aktualizována a uložena při
  jakékoli změně pole na úrovni uživatele nebo profilové fotografie — viz UC0024.2.
- Několik endpointů jako vedlejší efekt úspěšné nebo neúspěšné akce vyvolá interní operační
  notifikaci do Slacku (např. aktivace, přihlášení, změna hesla, úprava profilu) — jde o
  provozně-alertingový vedlejší efekt, nikoli o změnu doménového stavu; obsah/routing těchto
  notifikací je mimo rozsah této API smlouvy (viz FN0023, pokud je rekonstruováno).
- Žádost o reset hesla a vytvoření magic-linku odesílají transakční e-mail — obsah zprávy a
  vlastnictví spouštěče patří kapacitě transakčních zpráv (FN0019 / vrstva MSG), zde citováno,
  ne opakováno.
- Endpointy registrace a resetu účtu (body 3, 4) **nemají žádné vedlejší efekty** — jsou to
  nefunkční stuby (viz Rizika).

## Chybové výsledky

Viz tabulky u jednotlivých operací výše. Společné vzory v rámci modulu: `*_not_found` (404),
`missing_credentials*` (401), `*_invalid` / `*_too_short` (400), blokovaný účet
(`user_is_not_active`, 401) a nekonzistentně vynucovaná flood-control chyba (401) pouze u
přihlášení. Žádný endpoint tohoto modulu nevrací strukturovaný/typovaný chybový kód nad rámec
volně-textového klíče `error` — mezi verzemi neexistuje sdílený enum chybových kódů (Confirmed).

## Poznámky k verzování

- U většiny operací existují souběžně tři až čtyři registrované verze (bez verze/`2.3`, `3.0`,
  `3.1`, `3.2`); všechny zůstávají v aktuální konfiguraci `rest.resource.*` zapnuté
  (`status: true`) kromě `password_recover_resource` (v0, vypnuto) a
  `account_login_hash_resource_v32` (vypnuto, přestože je nejnovější variantou přihlášení — viz
  Rizika).
- **Aktuálně používaná verze je v3.2** pro přihlášení, odhlášení, aktivaci, stav, obnovu/žádost o
  reset hesla, vytvoření magic-linku, profil, profil podle slug a odeslání aktivačního e-mailu.
  v3.0 je aktuální pro `/mandators` (profile-organisation) a vyhledání email-eligibility, které v
  tomto modulu nemají nástupce v3.1/v3.2. v3.1 existuje pouze pro přihlášení a profil a v rozsahu
  funkčnosti stojí mezi v0/v3.0 a v3.2 (přidává `user_login_finalize()` a vracené `user_id`, které
  ve v0 chybí).
- Drift mezi verzemi **není čistě přírůstkový** — POST profilu ve v3.2 mlčky vypouští větev změny
  hesla přítomnou ve v3.0/v3.1 (viz bod 12 a UC0024 AF3) a odvození cíle přes `user_id`/`slug`
  z v3.0/v3.1 je ve v3.2 nahrazeno striktní vazbou na vlastní session (viz bod 12 a Autorizace).
  Považujte sadu polí každé verze za autoritativní pro tuto verzi — nepředpokládejte, že novější
  verze je striktní superset verze starší.

## Rizika (aktuální stav, potvrzeno kódem)

- **Čtení/zápis profilu jiného uživatele ve v3.0/v3.1** — `GET`/`POST /api/3.{0,1}/user/profile`
  odvozují cílového uživatele z parametru `user_id` nebo `slug` bez kontroly, že odpovídá vlastní
  session volajícího; kterýkoli volající (včetně anonymního, protože konfigurace REST resource
  nenese žádné omezení oprávnění) může číst celý profilový payload jiného uživatele a — u POST —
  měnit příznaky `public`/`worker_available` jiného uživatele, jmenná pole kontaktu, profilovou
  fotografii a (pouze v3.0/v3.1) heslo, pokud znají pouze UUID nebo slug daného uživatele. v3.2 toto
  u obyčejného profilového endpointu uzavírá, ale postranní kanál `backend_access_check` a vyhledání
  `/mandators` a profilu podle slug zůstávají záměrně neomezené (veřejná vyhledání). **Confirmed,
  na úrovni kódu.**
- **Nefunkční stuby prezentované jako živé endpointy** — `POST /api/2.3/account/register` a
  `POST /api/2.3/account/reset` bezpodmínečně vracejí `{"status":"success"}`, aniž by četly svůj
  vstup nebo cokoli vytvářely/měnily; `GET/POST /api/2.3/user/password/recover` bezpodmínečně
  vrací `{"valid":true}` (a je navíc v konfiguraci vypnuto). Volající nedokáže tyto endpointy od
  funkčních odlišit pouze na základě tvaru odpovědi. **Confirmed.**
- **Nefunkční hash-login větev na nejnovější verzi přihlášení** — větev `hash` v
  `POST /api/3.2/user/login` volá `\Drupal::service('account')->user_pass_rehash(...)`, metodu, která
  v této kódové základně na třídě `AccountService` neexistuje; jakýkoli požadavek, který se dostane
  k tomuto volání, by skončil fatální chybou místo autentizace. **Confirmed přes absenci v
  `AccountServiceInterface`/`AccountService`; nezávisle neověřeno spuštěním (pouze statická analýza,
  dle Runtime-truth-policy).**
- **Vypnutý login-hash resource** — `account_login_hash_resource_v32`
  (`POST /api/3.2/user/login/hash`) je registrován, ale v konfiguraci má `status: false`, a jeho
  implementace bezpodmínečně vrací `{"error":"invalid"}` bez ohledu na vstup — druhý, samostatný
  nefunkční přihlašovací povrch. **Confirmed.**
- **Nekonzistentní vynucování flood-control** — přihlašovací resource v0 a v3.1 uvnitř
  `floodControl()` vypočítají odpověď odmítnutí flood-control, ale volající návratovou hodnotu této
  metody nikdy nepoužije (výsledek metody je zahozen), takže flood kontrola nemá u těchto dvou verzí
  žádný skutečný vynucovací efekt; jen přihlašovací resource ve v3.2 vrací odpověď flood-control a
  request blokuje. **Confirmed,** převzato do Constraints FN0018.
- **GET requesty měnící stav** — kontrola aktivace (`GET .../user/activate/{session_id}`) a
  vyhledání profile-organisation/eligibility/slug jsou GET požadavky, což je pro čtení běžné, ale
  aktivační GET navíc vyvolává notifikaci do Slacku jako vedlejší efekt běžného čtení; sama o sobě to
  není bezpečnostní riziko, ale je uvedeno, protože porušuje očekávání bezpečné metody (bez
  vedlejšího efektu) u GET.
- **Žádná ochrana CSRF u požadavků měnících stav nad rámec výchozí cookie-autentizace** — každý POST
  endpoint tohoto modulu spoléhá výhradně na výchozí Drupal cookie-session REST autentizaci; několik
  endpointů existuje přímo za účelem *vydání* CSRF tokenu (bod 10) pro použití jinde, ale žádný z
  endpointů této smlouvy sám o sobě nevyžaduje předložení tohoto tokenu zpět (z kódu samotného
  resource to není doloženo ani v jednom směru — označeno jako **Open Item**, nikoli jako potvrzená
  mezera).
- **Duplicitní CSRF/token endpointy na kolidujících cestách** — jádrová Drupal CSRF-token route a
  custom REST plugin `token_resource` oba vystavují token stejného účelu na cestách rodiny
  `/api/session/token` (viz bod 10); který z nich skutečně obslouží daný request, závisí na priority
  Drupal route-matchingu, což zde není doloženo. **Open Item.**

## Referenced by

- UC: UC0014, UC0024
- EN: EN0008, EN0006, EN0007, EN0034
- FN: FN0018

## Otevřené otázky

- Zda je oprávnění `use magic link` (`account.permissions.yml`) v aktuální kódové základně kdekoli
  konzultováno, nebo jde o mrtvé, deklarované-ale-nevyužívané scaffolding oprávnění.
- Zda se jakýkoli front-end volající skutečně spoléhá na neomezené vyhledání `user_id`/`slug`
  profilových endpointů v3.0/v3.1 pro legitimní čtení profilu jiného uživatele (např. zobrazení
  cizího veřejného profilu) — pokud ano, zpřísnění ve v3.2 mohlo být záměrné zúžení, nikoli
  opomenutí; není doloženo ani v jednom směru.
- Zda je flag `backend_access_check` na GET profilu v3.2 skutečně využíván jakýmkoli aktuálním
  front-end/back-office volajícím a jakou schopnost odemyká (dosud neexistuje ACL doklad, proti
  kterému by se dalo křížově ověřit).
- Zda se od POST endpointů tohoto modulu očekává předložení CSRF tokenu vydaného v bodě 10/1/5 zpět
  serveru a zda je to vynucováno middleware frameworku mimo zde recenzovaný kód resource.
- Vyřešení priority routes mezi dvěma povrchy CSRF/token se stejnou rodinou cest, uvedenými v
  bodě 10 Poznámek k verzování/Rizik.
- Pro tento modul dosud neexistuje žádný `ACLxxxx` dokument — autorizační fakta výše jsou
  zaznamenána přímo z kódu/konfigurace, než vznikne dedikovaný ACL průchod; tento API dokument by
  měl být po jeho vzniku znovu ověřen proti tomuto ACL dokladu.
