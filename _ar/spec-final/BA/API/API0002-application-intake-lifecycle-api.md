---
doc_id: API0002
title: Application Intake & Lifecycle Api
layer: API
spec_type: api-contract
contract_type: rest-public
status: imported
modules: []
references:
  - UC0001
  - UC0025
  - UC0002
  - EN0001
  - EN0002
  - EN0003
  - FN0001
  - BR-ApplicationStatusGovernance
---

# API0002 – Příjem a životní cyklus žádosti Api

## Účel

Veřejně přístupné REST rozhraní, vystavené modulem `application`, jehož prostřednictvím anonymní
návštěvník nebo již přihlášený Customer vytvoří případ Application (žádost, EN0001), vyplní jeho
rolově specifický dotazník (ApplicationProfile, EN0002) v rámci jednoho nebo více kroků odeslání,
obnoví nebo zahodí koncept a přečte seznam žádostí přiřazených ke straně (party). Toto je jediný
kanál front-end SPA do životního cyklu příjmu/vyplňování/obnovy žádosti (UC0001, UC0025); orchestrace
stavů na straně administrace (UC0002) zde není vystavena — jde o back-office formulář, nikoli o REST
resource tohoto modulu.

## Konzumenti

- Veřejný front-end Patronusu (SPA), pro obrazovky self-registrace, vícekrokového formuláře žádosti,
  výzvy k obnovení konceptu a seznamu "moje žádosti".
- Anonymní návštěvník (dosud neidentifikovaný fundraiser/patron), pro vytvoření a postupné vyplňování.
- Přihlášený Customer (fundraiser/patron/uživatel "zóny"), pro tytéž akce plus koncové body výpisu
  "moje žádosti"/"moje děti".

## Verzování

Modul vystavuje tři souběžné generace překrývajících se koncových bodů, rozlišené pouze segmentem
cesty URL (`/api/2.x/...`, `/api/3.0/...`, `/api/3.2/...`) a tím, které `rest.resource.*.yml`
config má `status: true`. Neexistuje žádný header pro vyjednávání verze ani verzování přes
content-type; každá verze je samostatný plugin/route `RestResource`. Zjištění níže jsou uvedena
po jednotlivých koncových bodech; "Aktuální" označuje nejvyšší číslovanou povolenou variantu
nalezenou pro danou schopnost.

| Schopnost | v2.x / legacy | v3.0 | v3.2 | Aktuální (povoleno) |
|---|---|---|---|---|
| Vytvoření žádosti (lead) | `/api/3.0/application_create` (root ns, **zakázáno**, stub) | `/api/3.0/application_create` (`v30` ns, **zakázáno**, stub `rest disabled`) | `/api/3.2/application_create` (**povoleno**) | v3.2 |
| Čtení dat kroku application-profile | — | `/api/3.0/application` GET (**povoleno**) | `/api/3.2/application` GET (**povoleno**) | oba povoleny; v3.2 je novější paralelní cesta — **otevřená otázka**: nedoloženo, kterou aktuálně volá build SPA |
| Odeslání dat kroku application-profile | `/api/2.3/application` (`v23` ns, **povoleno**, ale handler vrací `[]` — fakticky no-op stub) | `/api/3.0/application` POST (**povoleno**, plná logika) | `/api/3.2/application` POST — **soubor nenalezen pod `v32/`; existují pouze `v32/ApplicationCreateResource.php`, `ApplicationGETResource.php`, `CancelApplicationResource.php`, `UserApplicationResource.php`, `UserChildrenResource.php`, `ApplicationRepeatResource.php`**, ačkoli `rest.resource.application_rest_resource_v32.yml` (`status: true`, plugin_id `application_rest_resource_v32`) resource deklaruje | POST v3.0 je jediný plně implementovaný handler pro odeslání kroku nalezený ve zdrojovém stromu tohoto modulu |
| Průběžné uložení (autosave) | `/api/2.2/application_progress` (**povoleno**) | — | — | v2.2 (jediná nalezená varianta) |
| Zrušení/zahození žádosti | `/api/cancel_application/{uuid}` (**povoleno**) | — | `/api/3.2/cancel_application/{uuid}` (**povoleno**) | oba povoleny paralelně |
| Opakování/duplikace žádosti | — | `/api/3.0/application/repeat` (**povoleno**) | `/api/3.2/application/repeat` (**povoleno**) | oba povoleny paralelně; v3.2 se liší rozsahem duplikovaných polí profilu (viz Otevřené body) |
| Výpis žádostí uživatele | — | `/api/3.0/user_applications` (**povoleno**) | `/api/3.2/user_applications` (**povoleno**) | oba povoleny paralelně; v3.2 vypouští query parametr `user_id` a uživatele naopak vyhodnocuje ze session |
| Výpis dětí uživatele | `/api/3.0/user_children` (root/legacy ns id `user_children_resource`, **povoleno**) | `/api/3.0/user_children` (`v30` ns, id `user_children_resource_v30`, **zakázáno**) a `/api/3.1/user_children` (id `user_children_resource_v30`… označeno "v3.1 (delete me)", **status nezjištěn — viz Otevřené body**) | `/api/3.2/user_children` (**povoleno**) | root-ns v3.0 a v3.2 oba povoleny paralelně; v3.2 vypouští query parametr `user_id` |
| Validace session (samostatná) | `/api/application_session` (**zakázáno**, handler má natvrdo zapsanou odpověď "invalid") | — | — | žádná — mrtvý kód |

**Otevřená otázka:** protože několik koncových bodů existuje povoleno ve více verzích souběžně bez
smluvního mechanismu volby verze, není ze samotného zdrojového kódu backendu doloženo, kterou verzi
front-end pro danou obrazovku skutečně volá.

## Autorizace

Všechny koncové body v této smlouvě se autentizují pouze přes Drupal `cookie` provider (každý
`rest.resource.*.yml` deklaruje `authentication: [cookie]`; pro tento modul není nakonfigurován
žádný provider `basic_auth`/`oauth2`). U žádného koncového bodu v této smlouvě neexistuje schéma
HMAC, sdíleného tajemství ani API klíče.

Přístup je řízen Drupal oprávněním `restful <method> <resource_plugin_id>` (např.
`restful post application_rest_resource_v32`). Porovnáním `user.role.anonymous.yml` proti
`user.role.authenticated.yml`:

- **Potvrzené riziko:** každý povolený koncový bod (`status: true`) v této smlouvě uděluje shodné
  oprávnění `restful get|post <resource>` **oběma** rolím — `anonymous` i `authenticated`. Neexistuje
  role, která by měla přístup k nižší/vyšší úrovni těchto koncových bodů — anonymní volající mají
  přesně stejné oprávnění jako přihlášení. Jediným rozlišujícím prvkem mezi "mými vlastními daty" a
  "cizími daty" je držení opaque dvojice `application_id` (UUID) / `session_id` (UUID), nebo (u
  koncových bodů `_v32` "moje žádosti"/"moje děti") id uživatele vyhodnocené ze session volajícího.
- Žádný koncový bod zde nekontroluje handler přístupu na úrovni entity Drupal (`_entity_access`) ani
  vlastní požadavek routy `_custom_access` — kontrola přístupu je vynucována pouze uvnitř těla metody
  `post()`/`get()` jednotlivého Resource (ad hoc, per-resource), nikoli deklarována v
  `application.routing.yml` (REST resources přes tento soubor vůbec routovány nejsou; jsou routovány
  přes core modul `rest` z konfigurace `rest.resource.*.yml`, což je důvod, proč
  `application.routing.yml` u nich nevykazuje odpovídající cesty).

## Model session / držení (průřezový)

Většina koncových bodů v této smlouvě nepoužívá jako hranici autorizace autentizovanou identitu
uživatele Drupal. Namísto toho používají dvojici tokenů založenou na držení:

- `application_id` — UUID žádosti (Application, EN0001).
- `session_id` — UUID ApplicationSession (EN0003), vyhledávané a požadované jako `Active`
  (`status: 1`) pro odpovídající `application_id`, než je požadavek povolen k pokračování.

Kdokoli, kdo má platnou, aktivní dvojici `(application_id, session_id)` — např. z e-mailového odkazu
— může číst nebo zapisovat data profilu dané žádosti a žádost zrušit, bez ohledu na stav přihlášení
do Drupalu. Jde o potvrzený současný design, nikoli o defekt zavedený touto smlouvou; viz Rizika
níže pro důsledky.

## Koncové body

### 1. `POST /api/3.2/application_create` — Vytvoření žádosti (lead)

- **Typ smlouvy:** příkaz (command)
- **Stav:** Potvrzeno / Aktuální. Zdroj:
  `application/src/Plugin/rest/resource/v32/ApplicationCreateResource.php`; config
  `rest.resource.application_create_resource_v32.yml` (`status: true`).
- Nahrazené/mrtvé varianty: root-namespace `ApplicationCreateResource.php` a
  `v30/ApplicationCreateResource.php` jsou obě zapojené (`status: true` v jejich `.yml`), ale jejich
  metoda `post()` je natvrdo zapsaný stub vracející `{"status":"failed","error":"rest disabled"}` —
  mrtvé cesty kódu ponechané povolené na úrovni routování. **Potvrzené riziko.**

**Požadavek**

| Pole | Význam | Povinné | Poznámky |
|---|---|---:|---|
| `user_type` | Role, pro kterou se tento případ registruje | ano | Musí být přesně `patron` nebo `fundraiser`; jakákoli jiná hodnota → chybová odpověď ve stylu 400 |
| `lead_email` | Kontaktní e-mail nového leadu | podmíněně | Povinné pouze pokud volající není již přihlášený uživatel ("zone"); validováno na plausibilitu domény e-mailu přes platformní pomocnou funkci pro validaci e-mailu |
| `lead_phone` | Kontaktní telefon nového leadu | ne | |
| `interface_type` | Volí specializovanou variantu příjmu | ne | Zjištěné hodnoty zahrnují variantu organizací-mandátovaného fundraisera (`organisation_with_mandator`) a varianty pomoci Ukrajině (podřetězec `_ukr`); určuje odvození `lead_role` a situační příznak |
| `mandator_id` | UUID existujícího uživatele jednajícího za nesvéprávného žadatele | ne | Pokud je přítomno, nastaví `lead_source` na původ "zone_profi" a napojí tohoto uživatele jako `fundraiser` na daný případ |
| `source` | Situační kód kampaně/pomoci | ne | Zjištěné hodnoty zahrnují kódy pro pomoc při COVID (`corona_rent`, `corona_basic_box`); pokud je přítomno, nastaví příznak `covid19` a předvyplní kategorii/podkategorii/cenu daru v profilu — **Hypotéza, aktuální legacy chování, nedoloženo jako stále relevantní pro kampaně dnes** |

**Odpověď — úspěch**

| Pole | Význam | Poznámky |
|---|---|---|
| `status` | `"successful"` | |
| `application_id` | UUID nově vytvořené žádosti (EN0001) | |
| `session_id` | UUID ApplicationSession (EN0003) vytvořené pro `user_type` | |

**Chybové výstupy**

| Výstup | Význam | Opakovatelné | Poznámky |
|---|---|---:|---|
| `user_type: patron or fundraiser value required` | `user_type` chybí nebo je neplatné | ano | |
| `Email validation error` | `lead_email` chybí/je neplatné pro nepřihlášeného volajícího | ano | Kontrolováno pouze pokud volající není přihlášený uživatel "zone" |

**Vedlejší efekty**

- Vytvoří kontakt (EN0006) "lead contact" (nebo znovu použije nalezený podle e-mailu), pokud volající
  není přihlášený uživatel "zone" — v takovém případě je znovu použit vlastní napojený kontakt
  volajícího.
- Vytvoří žádost (EN0001) ve stavu `new`, zaznamenávající roli/zdroj leadu a marketingovou/trackingovou
  atribuci (`x_tracking_*` headery, IP, user agent).
- Vytvoří/aktualizuje ApplicationProfile (EN0002) pro `user_type`, předvyplněný z kontaktu, nebo u
  přihlášeného volajícího z vlastního záznamu jeho strany (party).
- Vytvoří ApplicationSession (EN0003) pro `user_type` (viz EN0003; dle UC0001).
- **Potvrzené riziko:** u přihlášeného volajícího "zone" odešle notifikaci do interního Slack kanálu o
  vytvoření nového leadu (služba `logger.slack`) — provozní vedlejší kanál nezachycený jinde v této
  smlouvě.

**Otevřené body**

- Zda front-end v současnosti cílí výhradně na tento koncový bod `v32`, nebo pro některé toky ještě
  volá mrtvé stuby `v30`/root, nedoloženo ze zdrojového kódu backendu.
- Přesná sada pravidel za předvyplněním řízeným parametrem `source` (kódy pomoci COVID) je natvrdo
  zapsána v tomto Resource a nespadá do vlastnictví žádného BR dokumentu nalezeného v tomto průchodu —
  zde pouze označeno, nikoli vyřešeno.

---

### 2. `GET /api/3.2/application` (a paralelní `GET /api/3.0/application`) — Čtení dat kroku application-profile

- **Typ smlouvy:** dotaz (query)
- **Stav:** Potvrzeno / obě Aktuální paralelně. Zdroj:
  `application/src/Plugin/rest/resource/v32/ApplicationGETResource.php` a
  `v30/ApplicationGETResource.php` (v tomto průchodu logika bit po bitu identická); configy
  `rest.resource.application_rest_resource_get_v32.yml` a `..._get_v30.yml`, oba `status: true`.
- Podporuje UC0025.1 (Obnovení konceptu žádosti).

**Požadavek**

| Pole | Význam | Povinné | Poznámky |
|---|---|---:|---|
| `application_id` (query) | UUID žádosti | ano | |
| `session_id` (query) | UUID ApplicationSession | ano | Musí odpovídat `Active` ApplicationSession pro `application_id`; role session určuje, který profil (fundraiser/patron) se vrací |

**Odpověď — úspěch**

| Pole | Význam | Poznámky |
|---|---|---|
| `user_type` | Role vyhodnocená ze session (`fundraiser` nebo `patron`) | |
| `interface_type` | Varianta přístupového rozhraní session (např. `default`, `invited`, `custom`, `upload_contract`, `upload_gift_proof`, `new_patron`) | Viz EN0003 |
| `schema` | Definice formuláře přenášená v session, pokud existuje | Má význam pouze pro `interface_type = custom` (např. kroky podpisu/zpětné vazby) |
| `editable` | Zda je session pouze pro čtení | Odvozeno z příznaku `readonly` session |
| `data` | Rolově specifické hodnoty dotazníkových polí již uložené v ApplicationProfile (EN0002) | Sada polí závisí na `interface_type`/stavu pozvání; viz "Katalog polí" níže; pole přílohy/souhlasu se nikdy nevracejí (`available_for_get: false`) |
| `static_data` | Kontextová pole pouze pro čtení o *druhé* straně/dítěti (např. jméno protistrany, souhrn daru), zobrazená pozvané straně před tím, než má vlastní profil | Přítomno pouze pro větev pozvané protistrany |

**Chybové výstupy**

| Výstup | Význam | Opakovatelné | Poznámky |
|---|---|---:|---|
| `application_id and session_id are required` (400) | Chybí jeden nebo oba query parametry | ano | |
| `session_is_invalid` (400) | Nenalezena odpovídající `Active` ApplicationSession | ano (s opravenou/obnovenou dvojicí) | Podporuje UC0025 AF1 |

**Vedlejší efekty**

- Žádné (pouze čtení); odpověď je explicitně označena jako necachovatelná.

**Otevřené body**

- Kterou ze dvou povolených, funkčně identických variant GET `v30`/`v32` aktuální build front-endu
  volá, nedoloženo.

---

### 3. `POST /api/3.0/application` — Odeslání dat kroku application-profile

- **Typ smlouvy:** příkaz (command)
- **Stav:** Potvrzeno / jde o jediný plně implementovaný handler pro odeslání kroku nalezený pro tuto
  schopnost. Zdroj: `application/src/Plugin/rest/resource/v30/ApplicationPOSTResource.php`; config
  `rest.resource.application_rest_resource_v30.yml` (`status: true`).
- **Potvrzené riziko / mezera ve verzování:** `rest.resource.application_rest_resource_v32.yml`
  deklaruje plugin_id `application_rest_resource_v32` se `status: true`, a obě role
  `anonymous`/`authenticated` mají udělené `restful post application_rest_resource_v32` — ale **žádná
  třída `v32/ApplicationPOSTResource.php` (ani jiná třída zpracovávající POST registrující tento
  plugin_id) neexistuje** v adresáři `src/Plugin/rest/resource/v32/` tohoto modulu. Jde buď o (a)
  mrtvý/odstraněný kód ponechaný zapojený na úrovni konfigurace, nebo o (b) implementaci v modulu či
  souboru nezahrnutém do ground truth tohoto průchodu (pouze REST pluginy modulu `application`).
  Označeno jako **otevřený bod**, zde nevyřešeno. Legacy `v23/ApplicationResource.php` (route
  `create` `/api/2.3/application`, také `status: true`) je sám stub, jehož `post()` bezpodmínečně
  vrací prázdné pole — také fakticky mrtvý.

**Požadavek**

| Pole | Význam | Povinné | Poznámky |
|---|---|---:|---|
| `application_id` | UUID žádosti | ano | |
| `session_id` | UUID ApplicationSession | ano | Musí vyhodnotit platnou session (`ApplicationService::getApplicationSession`) |
| `finished` | Označuje toto odeslání jako finální krok aktuálního vyplňování | ne (boolean) | Řídí finalizační vedlejší efekty (aktualizace kontaktů/party, aktivační e-maily, akce moderation-state, deaktivace session) |
| `data` | Objekt rolově specifických hodnot dotazníkových polí | ano (objekt) | Server-side omezeno allow-listem na pevný katalog polí podle role (fundraiser/patron); neznámé klíče jsou tiše zahazovány (`staging_log.unknown_fields` je hlásí pouze mimo produkci); validováno/normalizováno podle typu jednotlivého pole (boolean, číslo, telefon, e-mail, entity_reference, soubor, string, string_long, `rodne_cislo`, město, list) |

**Katalog polí (role fundraiser, neúplný výčet — viz zdroj pro úplný seznam a omezení
maximální délky/povolených hodnot pro jednotlivá pole):** `story_background`, `story_problems`,
`story_solution`, `child_about`, `traffic_source` (+`_other`), `gift_price`, `gift_proof`
(+`_other`), `gift_category`, `gift_subcategory` (+`_source`/`_other`), `gift_supplier`
(+`_source`/`_other`), `child_first_name`, `child_last_name`, `child_rc`,
`child_address_city/street/zip`, `child_dont_disclose_name`, `child_dont_disclose_photo`,
`unborn_child`, `fundraiser_first_name`, `fundraiser_last_name`, `fundraiser_email`,
`fundraiser_phone`, `fundraiser_rc`, `fundraiser_address_city/street/zip`,
`fundraiser_double_address`, `fundraiser_address2_city/street/zip`,
`fundraiser_child_different_address`, `fundraiser_housing_type` (+`_other`),
`fundraiser_household_members_adults/minors`, `fundraiser_income_type` (+`_other`, s více hodnotami),
`fundraiser_income_job_position`, `fundraiser_employer_name`,
`fundraiser_employer_address_street`, `fundraiser_household_income/expenses`,
`fundraiser_debts_exist`, `fundraiser_household_execution/insolvency`,
`patron_first_name/last_name/email/phone`, `patron_occupation` (+`_list`/`_list_other`),
`attachement_child_photo/id_copy/documents` (pouze pro zápis),
`agreement_truthfulness/rules/personal_data` (příznaky souhlasu, pouze pro zápis),
`attachment_contract` / `attachment_gift_proof`+`text_gift_proof` / `attachment_feedback`+`text_feedback`
(pouze pro zápis, specifické pro rozhraní), `custom_text`/`custom_attachment` (pouze pro zápis,
pouze `interface_type = custom`).

**Katalog polí (role patron, neúplný výčet):** `patron_reject` (+`_reason`),
`story_background`, `child_first_name/last_name`, `fundraiser_first_name/last_name/email/phone`,
`patron_first_name/last_name`, `patron_occupation` (+`_list`), `patron_dont_disclose_photo`,
`patron_photo` (pouze pro zápis), `patron_email/phone`, `patron_employer_name`,
`agreement_truthfulness/rules/personal_data` (pouze pro zápis).

**Odpověď — úspěch**

| Pole | Význam | Poznámky |
|---|---|---|
| `status` | `"success"` | |
| `action` | Přítomno a nastaveno na `"preview"` pouze u finalizační větve digitálního podpisu/protokolu o převzetí (viz BR-ContractAndESignature) | |
| `schema` | Přítomno pouze společně s `action = "preview"`; renderovací schéma pro obrazovku náhledu podepsaného dokumentu (odkazy na stažení smlouvy nebo protokolu o převzetí + potvrzení podpisu markdown) | Není obecné schéma kroku — specifické pro větev náhledu podpisu |
| `staging_log` | Neprodukční diagnostický blok (odeslaná pole, neznámá pole, chyby validace, uložená pole) | **Kandidát na potvrzené riziko:** blokováno pouze nastavením webu `environment`, nikoli oprávněním — viz Rizika |

**Chybové výstupy**

| Výstup | Význam | Opakovatelné | Poznámky |
|---|---|---:|---|
| `application_id and session_id are required` (400) | Chybí identifikátory | ano | |
| `Session is invalid` (400) | Nenalezena odpovídající ApplicationSession | ano (s opravenou dvojicí) | |
| (tiché zahození pole) | Odeslané pole neprojde specifickou typovou validací | n/a | Nezobrazeno jako chyba požadavku — pole je tiše vynulováno/zkráceno a požadavek jinak pokračuje na 200; viditelné volajícímu pouze přes `staging_log` mimo produkci |

**Vedlejší efekty**

- Validuje a uloží odeslaná `data` do rolově specifického ApplicationProfile (EN0002), plus
  server-side zachycené `ip_address`/`user_agent`.
- Při `finished = true` a specifických kombinacích rozhraní/stavu vytvoří odpověď náhledu digitálního
  podpisu nebo protokolu o převzetí (delegováno na smlouvu, EN0011 — viz BR-ContractAndESignature;
  zde nerestatováno).
- Ukládá přílohy specifické pro rozhraní (upload smlouvy, upload dokladu o daru, upload zpětné vazby)
  a u uploadů zpětné vazby vytvoří záznam zpětné vazby proti kampani (Campaign) žádosti.
- Při odmítnutí ze strany patrona (`data.patron_reject = true`) nastaví stav žádosti přímo na stav
  "vrácená žádost (nový patron)" přes `setState(...)` a deaktivuje session — přímé přiřazení stavu,
  strukturálně obdobné riziku `CancelApplicationResource` uvedenému v poznámce BR u UC0025.
- Při `finished = true`: vytvoří/aktualizuje záznamy uživatele (EN0008)/kontaktu (EN0006) pro
  fundraisera, patrona a dítě (upsert klíčovaný e-mailem/rodným číslem), odešle protistraně
  cross-invite e-mail o dokončení, pokud je relevantní (viz MSG0002), odešle aktivační e-mail účtu,
  pokud je příslušný účet strany blokovaný, vykoná akci `updateApplicationModerationState` a deaktivuje
  aktuální session (povýšení session protistrany z `invited` na `authenticated_invited`, pokud
  protistrana již má aktivní účet).

**Otevřené body**

- Produkční nástupce tohoto handleru `v30` na `/api/3.2/application` (POST) je deklarován jako povolený
  v konfiguraci, ale nemá odpovídající zdrojový soubor v tomto modulu — viz riziko výše. Jakýkoli
  přepis musí buď tuto implementaci dohledat jinde, nebo `v32` POST považovat za dosud
  neimplementovaný.
- Chyby validace jednotlivých polí jsou tiše zahazovány, nikoli odmítány; zda je to záměrná
  odstupňovaná degradace nebo nezaznamenaný defekt, nedoloženo.

---

### 4. `POST /api/2.2/application_progress` — Uložení stavu kroku v průběhu (autosave)

- **Typ smlouvy:** příkaz (command)
- **Stav:** Potvrzeno / jediná nalezená varianta. Zdroj:
  `application/src/Plugin/rest/resource/ApplicationProgressResource.php`; config
  `rest.resource.application_progress_rest_resource.yml` (`status: true`).
- Podporuje inkrementální ukládání jako součást UC0025 (Obnovení/zahození konceptu žádosti).

**Požadavek**

| Pole | Význam | Povinné | Poznámky |
|---|---|---:|---|
| `application_id` | UUID žádosti | ano | |
| `session_id` | UUID ApplicationSession | ano | Validováno přes `ApplicationService::isSessionValid` |
| `touched_inputs` | Libovolná klientem dodaná struktura popisující, kterých vstupů formuláře se uživatel dotkl | ano (implicitně) | Uloženo verbatim (kódováno JSON) do pole `progress` profilu — nejde o business pole, čistě o UI marker stavu obnovy |
| `steps_completed` | Počet dosud dokončených kroků formuláře | ano (implicitně) | Přetypováno na integer a uloženo do pole `progress_steps_completed` profilu |

**Odpověď — úspěch**

| Pole | Význam | Poznámky |
|---|---|---|
| `status` | `"successful"` | |

**Chybové výstupy**

| Výstup | Význam | Opakovatelné | Poznámky |
|---|---|---:|---|
| `application_id and session_id are required` (200 body, nikoli HTTP chybový stav) | Chybí identifikátory | ano | **Kandidát na potvrzené riziko:** selhání je signalizováno pouze v JSON těle s HTTP 200, nikoli stavem 4xx — viz Rizika |
| `Session is invalid` (200 body) | Vyhledání session selhalo | ano | Stejný vzor 200-s-chybou-v-těle |
| (řetězec zprávy o porušení validace, 200 body) | Validace na úrovni ApplicationProfile selhala při uložení | ano | Text zprávy je surová, od tagů zbavená zpráva o porušení — nikoli strukturovaný chybový kód |

**Vedlejší efekty**

- Vytvoří rolově specifický ApplicationProfile (EN0002) pro tuto žádost, pokud ještě neexistuje, a
  napojí ho na žádost (nová revize je pro toto pouze-napojovací uložení potlačena).
- Uloží `progress`/`progress_steps_completed` do ApplicationProfile.
- Každý požadavek je verbatim logován (celé tělo požadavku) do log kanálu `application_progress` —
  viz Rizika (riziko PII v logech, protože tato payload jezdí ve stejné session jako plná dotazníková
  data u jiných koncových bodů).

**Otevřené body**

- Žádné nad rámec výše uvedeného rizika tvaru odpovědi.

---

### 5. `POST /api/cancel_application/{application_uuid}` a `POST /api/3.2/cancel_application/{application_uuid}` — Zrušení/zahození žádosti

- **Typ smlouvy:** příkaz (command)
- **Stav:** Potvrzeno / obě povoleny paralelně, funkčně identické. Zdroj:
  `application/src/Plugin/rest/resource/CancelApplicationResource.php` a
  `v32/CancelApplicationResource.php`; configy `rest.resource.cancel_application_rest_resource.yml`
  a `..._v32.yml`, oba `status: true`.
- Podporuje UC0025.3 (Smazání/zahození konceptu žádosti).

**Požadavek**

| Pole | Význam | Povinné | Poznámky |
|---|---|---:|---|
| `application_uuid` (path) | UUID žádosti | ano | |
| `session_id` (body) | UUID ApplicationSession | ano | Musí vyhodnotit `Active` (`status: 1`) session pro `application_uuid` |

**Odpověď — úspěch**

| Pole | Význam | Poznámky |
|---|---|---|
| `status` | `"successful"` | |

**Chybové výstupy**

| Výstup | Význam | Opakovatelné | Poznámky |
|---|---|---:|---|
| `application_id and session_id are required` (200 body) | Chybí identifikátory | ano | Stejný vzor 200-s-chybou-v-těle jako výše |
| `Session is invalid` (200 body) | Nenalezena odpovídající aktivní session | ano | |
| `Not found` (200 body) | `application_uuid` neodpovídá žádné žádosti | ne (pokud není opraveno) | |

**Vedlejší efekty**

- **Potvrzené riziko (již označeno na úrovni UC/BR):** nastaví stav žádosti přímo na `canceled_by_user`
  přes `setState(...)`, čímž obchází rolově řízenou cestu přechodu/workflow používanou UC0002
  (Orchestrace změny stavu žádosti). V tomto Resource není přítomno žádné volání deaktivace session —
  nedoloženo, zda jsou vlastní záznamy ApplicationSession (EN0003) této žádosti touto akcí deaktivovány
  (viz Otevřené otázky UC0025; vlastnictví tohoto invariantu náleží
  BR-ApplicationStatusGovernance, zde nerestatováno).

**Otevřené body**

- Zda jsou vedlejší efekty řízené ApplicationReaction (EN0026), které se normálně spouští při změně
  stavu vyvolané přechodem, v tomto případě přeskočeny (protože tato cesta danou cestu obchází),
  nedoloženo.

---

### 6. `GET`/`POST /api/3.0/application/repeat` a `GET`/`POST /api/3.2/application/repeat` — Duplikace předchozí žádosti

- **Typ smlouvy:** příkaz (POST) / dotaz (GET)
- **Stav:** Potvrzeno / obě povoleny paralelně s behaviorálním rozdílem. Zdroj:
  `application/src/Plugin/rest/resource/v30/ApplicationRepeatResource.php` a
  `v32/ApplicationRepeatResource.php`; configy `rest.resource.application_repeat_resource.yml`
  (výchozí id pro `v30`) a `..._v32.yml`, oba `status: true`.
- **GET je dokumentovaně mrtvý ve v3.2:** vlastní inline komentář handleru GET `v32` uvádí "Remove Get
  request on FE & BE" a nyní bezpodmínečně vrací zcela prázdné tělo stub; handler GET `v30` stále
  provádí skutečné vyhledání daru/jména patrona. **Potvrzené riziko/nekonzistence**, zde nevyřešeno.

**Požadavek (GET)**

| Pole | Význam | Povinné | Poznámky |
|---|---|---:|---|
| `child_id` (query) | UUID kontaktu dítěte | podmíněně | Požadováno buď toto, nebo `application_id` (pouze v30 — viz stavová poznámka výše) |
| `application_id` (query) | UUID žádosti | podmíněně | Požadováno buď toto, nebo `child_id` (pouze v30) |

**Odpověď — úspěch (GET, pouze v3.0; v3.2 vždy vrací prázdný tvar níže)**

| Pole | Význam | Poznámky |
|---|---|---|
| `gift` | Lidsky čitelný popisek kategorie > podkategorie daru z profilu fundraisera předchozí žádosti | Prázdný řetězec, pokud nedostupné |
| `gift_price` | Požadovaná cena daru z předchozí žádosti | |
| `gift_supplier` | Popisek dodavatele daru z předchozí žádosti | |
| `patron_name` | Celé jméno patrona z předchozí žádosti | |

**Požadavek (POST)**

| Pole | Význam | Povinné | Poznámky |
|---|---|---:|---|
| `application_id` | UUID předchozí žádosti k duplikaci | podmíněně | Požadováno buď toto, nebo `child_id` |
| `child_id` | UUID kontaktu dítěte | podmíněně | Pokud je zadáno bez `application_id`, duplikuje se *poslední* žádost pro toto dítě |
| `user_wants_to_edit` | Zda fundraiser chce před odesláním patronovi editovatelnou session na nové duplikátě | ne (boolean) | Řídí, který tvar odpovědi je vrácen |

**Odpověď — úspěch (POST)**

| Pole | Význam | Poznámky |
|---|---|---|
| `status` | `"successful"` (editační cesta) nebo `"success"` (cesta odeslání patronovi) | Nekonzistentní hodnota mezi oběma větvemi — **potvrzeno, zde neopraveno** |
| `application_id` | UUID nově duplikované žádosti | Přítomno pouze na editační cestě (`user_wants_to_edit = true`) |
| `session_id` | UUID nové fundraiserské ApplicationSession na duplikátě | Přítomno pouze na editační cestě |

**Chybové výstupy**

| Výstup | Význam | Opakovatelné | Poznámky |
|---|---|---:|---|
| `child_id is required` / `application_id is required` (400, pouze GET) | Žádný/špatný identifikátor dodán | ano | Pouze GET v3.0 |
| `child_id or application_id are required` (400, pouze GET) | Žádný identifikátor dodán | ano | Pouze GET v3.0 |
| (neošetřeno) | POST bez řešitelného `application_id` ani `child_id` | n/a | **Otevřený bod**: zdroj volá `$application->getPatron()` bezpodmínečně po duplikační větvi; pokud je `$application` `NULL`, jde o latentní fatální chybu, nikoli o modelovanou chybovou odpověď — zde pouze označeno, nikoli opraveno |

**Vedlejší efekty**

- Duplikuje fundraiserský ApplicationProfile (EN0002) předchozí žádosti — plná duplikace ve v3.0
  (markery dokončení vymazány); ve v3.2 se do nového profilu kopírují pouze tři pole
  (`child_first_name`, `child_last_name`, `child_rc`) — **potvrzená behaviorální divergence** mezi
  dvěma souběžně povolenými verzemi, nikoli pouze vztah superset/subset.
- Vytvoří novou žádost (EN0001), přenášející referenci na fundraisera/patrona/dítě, s
  `lead_source = zone_repeat` a moderation/stavem nastaveným na `new` nebo stav "čeká na žádost
  patrona" v závislosti na `user_wants_to_edit`.
- Vytvoří patronskou ApplicationSession (EN0003) pro duplikát, a — na editační cestě — fundraiserskou
  ApplicationSession.
- Na needitační cestě odešle odkaz na novou žádost existujícímu patronovi (viz MSG0002).

**Otevřené body**

- Rozdíl v rozsahu duplikace profilu v30 vs. v32 (celý profil vs. tři pole) je materiální behaviorální
  divergence mezi dvěma souběžně vystavenými koncovými body; v tomto průchodu není vyřešeno jako
  jediné "aktuální" chování.

---

### 7. `GET /api/3.0/user_applications` a `GET /api/3.2/user_applications` — Výpis žádostí strany (party)

- **Typ smlouvy:** dotaz (query)
- **Stav:** Potvrzeno / obě povoleny paralelně s rozdílem ve smluvních parametrech. Zdroj:
  `application/src/Plugin/rest/resource/v30/UserApplicationResource.php` a
  `v32/UserApplicationResource.php`; configy `rest.resource.user_application_resource_v30.yml` a
  `..._v32.yml`, oba `status: true`.

**Požadavek**

| Pole | Význam | Povinné | Poznámky |
|---|---|---:|---|
| `role` (query) | Podle jakého vztahu se má vypisovat (`fundraiser`, `patron`, `organisation_worker`) | ano | |
| `user_id` (query) | UUID uživatele, jehož žádosti se vypisují | ano ve v3.0; **nepřítomno/nevyužito ve v3.2** | v3.2 naopak vyhodnocuje jednajícího uživatele z autentizované session (`current_user`) — **potvrzená divergence tvaru smlouvy** mezi dvěma povolenými verzemi, nikoli čistý superset |
| `child_id` (query) | UUID kontaktu dítěte | ne | Pokud je přítomno, vypisuje se podle dítěte místo podle strany |

**Odpověď — úspěch**

| Pole | Význam | Poznámky |
|---|---|---|
| `user.name` | Celé jméno vyhodnoceného uživatele | |
| `user.roles` | Role vyhodnoceného uživatele | |
| `child.name`, `child.ready_to_apply` | Přítomno pouze pokud bylo dodáno `child_id` | |
| `applications[].application_id` | UUID žádosti | |
| `applications[].last_update` | Časové razítko poslední aktualizace žádosti | |
| `applications[].status` | Aktuální stavový kód žádosti | Viz stavový slovník EN0001 |
| `applications[].status_message` / `status_description` | Zobrazovaný text řízený reakcí na stav (s náhradou tokenů) nebo záložní popisek workflow stavu | Získáno z konfigurace ApplicationReaction (EN0026) — obsah vlastněný tam, zde nerestatováno |
| `applications[].role` | `role`, podle které byl tento výpis filtrován | |
| `applications[].title` | Zobrazovaný název žádosti | |
| `applications[].category` | Hrubý popisek kategorie, mapovaný z malé natvrdo zapsané tabulky id taxonomického termínu | **Hypotéza**: natvrdo zapsaná mapa ID→popisek (`71..76`) je náchylná na změny taxonomie; označeno, neopraveno |
| `applications[].theme_color` / `theme_icon` | Náznaky pro vzhled zobrazení z odpovídající ApplicationReaction | |
| `applications[].additional_actions[]` | Volitelné vedlejší akce (např. "Náhled žádosti", "Detail příběhu") | |
| `applications[].button_action` / `button_action_query_data` / `button_action_text` | Primární výzva k akci pro tuto žádost, pokud je aktuálně relevantní | Odvozeno z konfigurace ApplicationReaction nebo záložního vyhledání session "custom interface" | |
| `applications[].campaign_slug` / `raised_amount` / `full_amount` / `photo` | Přítomno pouze pokud je napojena kampaň (EN0004) | |
| `applications[]._debug` | Přítomno pouze mimo produkční nastavení prostředí | **Kandidát na potvrzené riziko** — viz Rizika |

**Chybové výstupy**

| Výstup | Význam | Opakovatelné | Poznámky |
|---|---|---:|---|
| `role is required` (400) | `role` chybí | ano | |
| `user_not_found` (404, pouze v3.0) | `user_id` neodpovídá žádnému záznamu | ano (s opraveným id) | Neplatí pro v3.2, které nemá parametr `user_id` |
| `child not found` (404) | `child_id` dodáno, ale neodpovídá žádnému záznamu | ano | |

**Vedlejší efekty**

- Může vytvořit novou ApplicationSession (EN0003) pouze pro čtení jako vedlejší efekt výpočtu odkazu
  akce "náhled žádosti" (`getReadOnlyApplicationSession`) — dotazový koncový bod s vedlejším efektem
  zápisu při čtení. **Potvrzeno, označeno jako architektonická poznámka, zde neopraveno.**

**Otevřené body**

- Divergence smluvních parametrů v3.0 vs v3.2 (`user_id` povinné vs. nepřítomné) znamená, že tato
  volání nejsou zaměnitelná; nedoloženo, které aktuálně vydává aktuální build front-endu.

---

### 8. `GET /api/3.0/user_children`, `GET /api/3.2/user_children` — Výpis dětí strany (party)

- **Typ smlouvy:** dotaz (query)
- **Stav:** Potvrzeno / root-namespace-v3.0 (`user_children_resource`, cesta `/api/3.0/user_children`)
  a v3.2 oba povoleny paralelně s rozdílem ve smluvních parametrech; *namespacovaná*
  `v30/UserChildrenResource.php` (config `user_children_resource_v30`) má `status: false` (zakázáno);
  dále existuje třída "v3.1" (`v30/UserChildren1Resource.php`, popisek doslova "User children resource
  v3.1 (delete me)", route `/api/3.1/user_children`) — **jejímu `rest.resource.*.yml` se v tomto
  hledání nepodařilo dohledat, a stav povolení je proto otevřený bod**, ale její tělo `get()` je
  bezpodmínečně prázdné pole bez ohledu na cokoli. Zdroj:
  `application/src/Plugin/rest/resource/UserChildrenResource.php` (root ns) a
  `v32/UserChildrenResource.php`; configy `rest.resource.user_children_resource.yml` a
  `..._v32.yml`.

**Požadavek**

| Pole | Význam | Povinné | Poznámky |
|---|---|---:|---|
| `user_id` (query) | UUID uživatele, jehož děti se vypisují | povinné v root-ns v3.0; **nepřítomno/nevyužito ve v3.2** | v3.2 naopak vyhodnocuje jednajícího uživatele z autentizované session — stejný vzor divergence jako u koncového bodu 7 |
| `user_type` (query) | `patron` nebo `fundraiser` — podle jakého vztahu se má joinovat | ano (v3.2); volitelné ve v3.0 (výchozí join přes fundraisera, pokud není `patron`) | |

**Odpověď — úspěch**

| Pole | Význam | Poznámky |
|---|---|---|
| `[].child_id` | UUID kontaktu dítěte | |
| `[].name` | Celé jméno dítěte | |
| `[].ready_to_apply` | Zda je toto dítě aktuálně způsobilé pro novou žádost | Business pravidlo pro tento příznak je vlastněno jinde (nikoli touto smlouvou) |

**Chybové výstupy**

| Výstup | Význam | Opakovatelné | Poznámky |
|---|---|---:|---|
| `user_type is required` (400, pouze v3.2) | `user_type` chybí | ano | v3.0 nemá odpovídající ochranu (tiše defaultuje) |
| (prázdné pole, 200) | `user_id` nenalezeno (v3.0) | n/a | Nezobrazeno jako chyba — v3.0 vrací `[]` místo 404 |

**Vedlejší efekty**

- Žádné (pouze čtení).

**Otevřené body**

- Stav povolení routy `/api/3.1/user_children` (`UserChildren1Resource`) není potvrzen z
  konfiguračních souborů nalezených v tomto průchodu.

---

### 9. `POST /api/application_session` — Validace session (samostatná)

- **Typ smlouvy:** utilita
- **Stav:** Potvrzený mrtvý kód. Zdroj:
  `application/src/Plugin/rest/resource/ValidateSessionResource.php`; config
  `rest.resource.validate_session_rest_resource.yml` (`status: false` — zakázáno na úrovni konfigurace
  navíc k natvrdo zapsanému tělu handleru).

**Požadavek:** žádný smysluplně konzumovaný — handler svůj vstup zcela ignoruje.

**Odpověď:** při každém volání natvrdo vrací `{"status":"invalid"}` s HTTP 400, bez ohledu na vstup.

**Vedlejší efekty:** žádné.

**Otevřené body:** žádné — v této smlouvě zachováno pouze pro zdokumentování, že existuje a je
inertní, takže přepis jej nemusí zachovávat ani reimplementovat.

---

## Rizika (aktuální stav, označeno pro přepis)

1. **Žádná úroveň autorizace nižší než "držení dvojice UUID."** Každý povolený koncový bod v této
   smlouvě uděluje shodné oprávnění `restful <method> <resource>` rolím `anonymous` i
   `authenticated` (potvrzeno, `user.role.anonymous.yml` vs `user.role.authenticated.yml`).
   Autorizace pro čtení/zápis dat profilu konkrétní žádosti, nebo pro její zrušení, spočívá zcela na
   držení dvojice `(application_id, session_id)` — neexistuje žádná další kontrola vlastnictví
   vázající session na volajícího uživatele Drupal, kromě koncových bodů `_v32` "moje žádosti"/"moje
   děti", které identitu vyhodnocují z autentizované session místo z volajícím dodaného `user_id`.
2. **Chybové odpovědi vracené s HTTP 200.** `ApplicationProgressResource`,
   `CancelApplicationResource` (obě verze) a `ApplicationRepeatResource` (POST) signalizují business
   selhání (`status: "failed"`) v těle `200 OK` místo stavu 4xx — konzumenti API, kteří kontrolují
   pouze HTTP status kód, je tiše vyhodnotí jako úspěch.
3. **Únik neprodukčních diagnostických dat řízený příznakem prostředí, nikoli oprávněním.**
   Blok `staging_log` u `ApplicationPOSTResource` a blok `_debug` u `UserApplicationResource` (obě
   verze) jsou potlačeny pouze tehdy, když `Settings::get('environment') === 'production'` —
   jakékoli chybně nakonfigurované nebo neprodukčně označené prostředí vystaví interní objekty
   session/reakce a surová diagnostická data odeslaných polí témuž anonymně přístupnému volajícímu
   popsanému v riziku 1.
4. **Drift konfigurace/kódu: povolený resource bez nalezeného implementujícího handleru.**
   `rest.resource.application_rest_resource_v32.yml` (`application_rest_resource_v32`, `status: true`)
   uděluje `restful post` rolím anonymous/authenticated pro plugin, jehož PHP třída nebyla nalezena
   pod `application/src/Plugin/rest/resource/v32/` v tomto modulu. Buď implementace existuje jinde
   (mimo ground truth tohoto modulu), nebo jde o zavěšenou, nikdy fakticky nevolatelnou route na
   úrovni Drupal plugin-discovery — zde nevyřešeno.
5. **Tiché zahazování polí/validace místo odmítnutí požadavku.** `ApplicationPOSTResource`
   odstraňuje nebo zkracuje jednotlivá neplatná pole a stejně vrací `200 success`; volající nemá
   způsob, jak zjistit částečné uložení bez kontroly `staging_log` (samo blokováno podle rizika 3).
6. **Přímé přiřazení stavu obcházející řízenou cestu přechodu.** `CancelApplicationResource`
   (obě verze) a větev zamítnutí patronem u `ApplicationPOSTResource` volají `setState(...)` přímo
   místo přes rolově řízený mechanismus přechodu používaný UC0002 — viz
   BR-ApplicationStatusGovernance (zde nerestatováno) a poznámka BR u UC0025.
7. **Verbatim logování požadavků obsahujících osobní údaje.** `ApplicationProgressResource` a
   `ApplicationCreateResource`/`ApplicationPOSTResource` logují celé surové tělo požadavku
   (`json_encode($data)`) do standardních log kanálů Drupalu (`application_progress`, `application`,
   `application_create`) bez jakéhokoli maskování polí — protože tyto payloady nesou osobní údaje
   (jména, rodná čísla, adresy, e-maily, telefony), jde o potvrzené aktuální riziko nakládání s daty,
   které má přepis řešit, nikoli o instrukci k zachování.
8. **Souběžně povolené, behaviorálně divergentní dvojice verzí.** Sekce 6, 7 a 8 výše každá
   dokumentuje případ, kdy jsou dvě verze "téhož" koncového bodu obě `status: true` ve stejnou dobu,
   ale vracejí materiálně odlišné smlouvy (požadavky na parametry, rozsah duplikovaných polí, nebo
   mrtvá vs. živá logika GET) — přepis musí pro každou schopnost vybrat jedno kanonické aktuální
   chování, nikoli předpokládat, že vyšší číslo verze je striktní superset.
9. **Bez důkazu o CSRF/anti-forgery nebo omezování rychlosti (rate-limiting).** Pro žádný koncový bod
   v této smlouvě nebyl nalezen nakonfigurovaný požadavek na CSRF token, podepisování požadavků ani
   throttling (REST resources s cookie-auth v této verzi Drupalu obvykle spoléhají na header
   `X-CSRF-Token` u požadavků měnících stav pouze při použití session-cookie autentizace pro
   *přihlášeného* uživatele; pro zde dokumentovanou anonymní/possession-token cestu nebyl nalezen
   žádný takový mechanismus) — označeno jako otevřený bod, nepotvrzeno jako přítomné ani nepřítomné
   nad rámec toho, co tyto třídy Resource ukazují.

## Reference

- UC: UC0001, UC0025, UC0002
- EN: EN0001, EN0002, EN0003
- FN: FN0001
- BR: BR-ApplicationStatusGovernance (vlastnictví rizika legality přechodu/přímého přiřazení stavu),
  BR-ContractAndESignature (větev náhledu podpisu, referencováno nerestatováno), BR-PartyIdentityAndDeduplication (upsert strany klíčovaný e-mailem/rodným číslem, referencováno nerestatováno)
- MSG: MSG0002 (odkaz na dokončení žádosti / cross-invite e-mail), MSG0003/MSG0004 (rodina e-mailů aktivace/magic-link, referencováno nerestatováno)

## Otevřené body

- Kterou souběžně povolenou verzi (`v3.0` vs `v3.2`, nebo root-namespace vs. namespacovanou) každá
  obrazovka front-endu skutečně volá, nedoloženo ze zdrojového kódu backendu v žádné z označených
  divergencí (koncové body 2, 6, 7, 8).
- Chybějící implementace POST `v32` pro `/api/3.2/application` (koncový bod 3) je nevyřešená — označit
  pro tým přepisu k dohledání nebo explicitnímu vyřazení konfiguračního záznamu.
- Stav povolení `/api/3.1/user_children` (`UserChildren1Resource`) je nepotvrzený.
- Přesná pozice CSRF/anti-forgery pro anonymní/possession-token cestu je nepotvrzená (riziko 9).
