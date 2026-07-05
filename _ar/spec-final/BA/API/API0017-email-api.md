---
doc_id: API0017
title: Email API
layer: API
spec_type: api-contract
status: imported
modules: []
contract_type: rest-internal
references:
  - EN0007
  - EN0008
  - FN0018
  - ES0009
  - ACL0009
---

# API0017 – Email API

## Účel

Jediný REST resource plugin exponovaný vlastním modulem `email`: **Validate Email Eligibility** —
ověřuje, zda je zadaná e-mailová adresa syntakticky/doménově platná, a volitelně také to, zda je
existující účet s touto adresou způsobilý pokračovat v toku `donation` (dar) nebo `patron`
(patronát dítěte). Jde o kontrolu provedenou před vlastním zahájením daru/žádosti, nikoli o endpoint
pro správu účtů nebo zasílání zpráv — navzdory názvu modulu tento endpoint sám o sobě e-mailové zprávy
neodesílá, nezařazuje do fronty ani nearchivuje (viz Otevřené body k `EN0022 EmailArchive`, které jsou
mimo rozsah této kontraktové specifikace).

Modul `email` dále definuje běžnou PHP službu (`Drupal\email\EmailService`) a entitní typ `email_email`
(popisek „Email", používaný k uložení archivních záznamů odchozí pošty s vyrenderovaným polem
`arguments` — doloženo hookem `email_email_view()` v `email.module`). Ani CRUD formuláře tohoto
entitního typu (`EmailEntityForm`, `EmailEntitySettingsForm`, list builder), ani handler přístupových
práv entity nevystavují REST/HTTP kontrakt — jsou to interní administrační routy Drupalu, mimo rozsah
tohoto API dokumentu (viz Otevřené body).

Evidence: `email/src/Plugin/rest/resource/EmailValidation.php`,
`config/rest.resource.email_validation.yml`, `email/src/EmailService.php`,
`patron_base/src/PatronBaseService.php` (`isEmailValid`), `account/src/AccountService.php`
(`loadByEmail`), `account/src/PatronUser.php` (`isWorkerAvailable`).
Klasifikace: **Confirmed** (kód i aktivní konfigurace jsou přítomny).

---

## Konzumenti

- Veřejný frontend storefrontu (anonymní návštěvníci) — dostupný bez autentizace.
- Autentizované relace dárců/uživatelů — kryté nadmnožinovým oprávněním role `authenticated`; žádné
  odlišné chování pro tuto skupinu konzumentů nad rámec standardní relace.

---

## Endpointy

### 1. Validate Email Eligibility

- **Metoda / cesta:** `POST /api/email_validation`
  (plugin `email_validation`; `rest.resource.email_validation.yml` → `status: true`)
- **Formát:** pouze `json`.

---

## Poznámky k verzování

Tento modul definuje pouze jeden REST resource plugin (`email_validation`), s jedinou verzí v kódu i v
konfiguraci — **neexistuje žádná verze v3.1, v3.2 ani v3.3 REST pluginu nebo konfiguračního záznamu pro
`email`**. Zadání zmiňující sloučení variant v3.1/v3.2/v3.3 se na tento modul nevztahuje; zaznamenáno
jako mezera v evidenci, nikoli vymyšleno. (Verzí opatřená ID resourců jako `_v32`, vídaná jinde v
`config/rest.resource.*.yml`, patří jiným modulům — např. `account`, `application`, `campaigns` — nikoli
`email`.) Aktuální a jediná verze je ta, která je dokumentována výše.

---

## Autorizace

Ověřeno proti `config/user.role.anonymous.yml` a `config/user.role.authenticated.yml`
(rolová REST oprávnění, `restful <method> <plugin_id>`) a nastavení
`configuration.authentication: [cookie]` REST resource. Na tomto resource není žádný požadavek
`_permission`/`_access` na úrovni routy — jde o routu REST-pluginu (definovanou anotací `uri_paths`),
nikoli o routu deklarovanou v souboru `*.routing.yml` (modul nemá žádný `email.routing.yml`).

| Endpoint | Anonymous | Authenticated | Poznámky |
|---|---|---|---|
| `POST /api/email_validation` (`email_validation`) | **Povoleno** — `restful post email_validation` uděleno (`config/user.role.anonymous.yml`) | **Povoleno** — `restful post email_validation` uděleno (`config/user.role.authenticated.yml`), nadmnožina anonymního přístupu | Confirmed. Režim autentizace je `cookie`, takže autentizované volání vyžaduje aktivní relaci Drupalu, nikoli bearer token; v praxi resource nepoužívá `$this->currentUser` k ničemu jinému než ke konstrukci (je vložen, ale v `post()` nikdy nečten) — kontrola způsobilosti je vázána výhradně na pole požadavku `email`/`type`, nikoli na identitu relace. |

Tento resource nekonzultuje žádnou přístupovou kontrolu na úrovni entit — čte účty uživatelů a
prostou cache tabulku `email_domain` přímo, obchází tak jakoukoli vrstvu přístupových práv entity
User/Account (EN0007/EN0008).

---

## Request

### Validate Email Eligibility — Vstupy

| Pole | Význam | Povinné | Poznámky |
|---|---|---:|---|
| `email` | Kontrolovaná e-mailová adresa | ano | Zamítnuto (HTTP 401), pokud je prázdné. Jinak před použitím netypováno. |
| `type` | Volitelná kontrola způsobilosti provedená navíc k prosté validitě: `donation` nebo `patron` | ne | Pokud je přítomna a nejde o jednu z těchto dvou literálních hodnot, je požadavek zamítnut (HTTP 404, `missing_type` — current-state quirk: chybná hodnota znovu použije chybový kód pro „chybějící" hodnotu, zde neopraveno). Pokud pole chybí, provede se pouze prostá kontrola validity e-mailu. |

---

## Response

### Validate Email Eligibility — Úspěch

| Pole | Význam | Poznámky |
|---|---|---|
| `status` | Literál `"success"` | Vrácen pouze tehdy, když `type` **chybí** a e-mail projde kontrolou validity. HTTP 200. |
| `eligible` | Boolean — zda e-mail/účet může pokračovat v požadovaném toku typu `type` | Vráceno pouze tehdy, když `type` **je přítomno** a e-mail projde kontrolou validity. HTTP 200. Způsob výpočtu způsobilosti viz Vedlejší efekty. |

Žádné pole odpovědi nerozlišuje mezi „pro tento e-mail ještě neexistuje účet" a „účet existuje a je
způsobilý" — obě situace vrací `eligible: true` v cestě s přítomným `type` (viz Vedlejší efekty).

### Chybové výstupy

| Výstup | Význam | Opakovatelné | Poznámky |
|---|---|---:|---|
| HTTP 401, `{"error":"invalid_email_address"}` | `email` je prázdné | ano, po opravě | Poznámka: HTTP 401 je použito pro chybu validace, nikoli pro chybu autorizace — current-state quirk, zde neopraveno (stejný vzorec je dokumentován u kontaktního formuláře modulu `feedback`, API0008). |
| HTTP 401, `{"error":"invalid_email_address"}` | `email` neprojde kontrolou validity (`patron_base.default::isEmailValid` — kontrola formátu a domény, viz Vedlejší efekty) | ano, po opravě | Stejný tvar/kód odpovědi jako u prázdného e-mailu; obě příčiny selhání nejsou z odpovědi samotné rozlišitelné. |
| HTTP 404, `{"error":"missing_type"}` | `type` je přítomno, ale není `donation` ani `patron` | ano, po opravě | Current-state quirk: název chybového kódu (`missing_type`) neodpovídá skutečné příčině selhání (neplatná, nikoli chybějící hodnota) — zde neopraveno. |

Pro selhání přenosu při validaci domény (nedostupnost/chyba WhoisXML API) není doloženo žádné explicitní
ošetření — viz Rizika; aktuální kód tento druh selhání vyhodnocuje jako „platné", nikoli jako chybu na
úrovni API.

---

## Vedlejší efekty

- **Prostá kontrola validity** (`type` chybí nebo je přítomno): volá
  `patron_base.default::isEmailValid($email)`, což (a) spustí vestavěný PHP filtr pro formát e-mailu, a
  poté (b) zavolá `email.validateDomain($email)` (`Drupal\email\EmailService`), který:
  - vyhledá doménu e-mailu v lokální cache tabulce `email_domain` (vlastní SQL tabulka, nikoli entita
    Drupalu);
  - pokud existuje cache záznam mladší než 180 dnů, vrátí cachovaný příznak `is_valid` **bez
    externího volání**;
  - jinak (žádný cache záznam, nebo cache starší než 180 dnů) zavolá WhoisXML API (ES0009, endpoint
    „domain-availability"), aby zjistil existenci/dostupnost domény, a poté zapíše/aktualizuje cache
    záznam s výsledkem a novým časovým razítkem.
  - Jde o samostatné volací místo oproti integraci WhoisXML již dokumentované u FN0019/UC0012 (kontrola
    domény v rámci transakčního zasílání zpráv) — tento endpoint dosahuje WhoisXML API vlastní cestou
    (`email_validation` → `patron_base.isEmailValid` → `email.validateDomain` →
    `EmailService::domainExists`), nikoli přes tok odesílání zpráv. Zaznamenáno zde jako další, dosud
    nedokumentované volací místo směrem k témuž externímu systému (ES0009); nejde o novou ES hranici.
- **Kontrola způsobilosti** (pouze pokud je `type` přítomno): pokud `patron_base.default::isEmailValid`
  uspěje, zavolá `account.default::loadByEmail($email)` (`Drupal\account\AccountService`) k vyhledání
  existujícího uživatele (EN0008) podle přesné shody pole `mail`.
  - Pokud takový uživatel neexistuje, odpoví bezpodmínečně `eligible: true` (e-mail bez účtu je vždy
    hlášen jako způsobilý, bez ohledu na `type`).
  - Pokud uživatel existuje a `type === 'donation'`: způsobilý pouze tehdy, pokud uživatel **nemá**
    roli `organisation_worker` (`!$user->hasRole('organisation_worker')`).
  - Pokud uživatel existuje a `type === 'patron'`: způsobilý pouze tehdy, pokud
    `$user->isWorkerAvailable()` — booleovské entitní pole (`worker_available`) na uživateli
    (EN0008/`PatronUser`), názvem nesouvisející s kontrolou role `organisation_worker` používanou pro
    typ `donation`.
- **Zápis do cache**: záznam tabulky `email_domain` pro kontrolovanou doménu je vložen (při prvním
  zjištění) nebo aktualizován (při expiraci cache) jako vedlejší efekt výše uvedené kontroly validity —
  trvalá změna stavu vyvolaná jinak čtecím endpointem.
- Tímto endpointem není vytvořena, upravena ani smazána žádná entita User, Contact ani Application.
  Tímto endpointem není odeslána žádná zpráva/e-mail (bez ohledu na jeho vlastní název) — pouze
  validuje a hlásí způsobilost.

---

## Rizika (current-state)

- **Hardcoded externí API klíč:** `EmailService::domainExists()` vkládá literální WhoisXML API klíč
  přímo do řetězce URL požadavku na úrovni zdrojového kódu
  (`web/modules/custom/email/src/EmailService.php`). Jde o skutečný secret zapsaný ve zdrojovém kódu
  modulu, nikoli o redigovaný placeholder v tomto dokumentu — je dosažitelný z tohoto veřejného,
  anonymně volatelného endpointu při každém nekešovaném vyhledání domény. **Confirmed** přímou
  inspekcí; samotná hodnota klíče v tomto dokumentu není reprodukována z důvodu dodržení rozsahu
  zápisu, ale jeho přítomnost a hardcoding jsou samy o sobě riziko.
- **Fail-open validace domény:** `domainExists()` vrací `true` (doména je považována za
  platnou/existující) v každé nešťastné cestě, kterou může dosáhnout — HTTP 403 od WhoisXML, JSON tělo
  s `ErrorMessage`, výslovný výsledek `AVAILABLE` (tj. *nezaregistrováno*) sbalený do stejné návratové
  hodnoty `true` jako „existuje", a jakákoli vyhozená výjimka (timeout sítě, malformovaná odpověď
  apod.). V praxi to znamená, že výpadek WhoisXML, rate-limit, nebo skutečně neexistující doména mohou
  všechny nenápadně projít validací domény jako „platné" — kontrola tak degraduje na no-op místo tvrdého
  selhání. **Confirmed** přímou inspekcí toku řízení metody.
- **HTTP 401 znovu použito pro chyby validace:** obě větve, jak pro prázdný e-mail, tak pro neplatný
  e-mail, vrací HTTP 401 (Unauthorized) pro to, co je prostý výstup validace vstupu, nikoli chyba
  autentizace/autorizace — stejný current-state quirk již zaznamenaný u endpointu kontaktního formuláře
  modulu `feedback` (API0008). **Confirmed**, zde neopraveno.
- **Nejednoznačná sémantika „eligible" pro neznámé e-maily:** cesta s přítomným `type` hlásí
  `eligible: true` pro jakýkoli e-mail bez odpovídajícího uživatele, aniž by rozlišovala „jde o zcela
  nový, skutečně způsobilý e-mail" od „tento e-mail ještě neexistuje, způsobilost není ve skutečnosti
  známa." Navazující konzumenti tyto dva případy nemohou z odpovědi samotné rozlišit. **Confirmed**
  přímou inspekcí; nejde nutně o defekt vzhledem k doloženému účelu endpointu (pre-flight blokování
  known-ineligible existujících účtů), ale jde o latentní nejednoznačnost při případném opětovném
  použití jinde.
- **Relace/identita vložena, ale nevyužita:** `AccountProxyInterface $current_user` je vložena do
  konstruktoru `EmailValidation`, ale v `post()` nikdy nečtena — chování endpointu je identické pro
  anonymní i autentizované volající a kontrolu nepřiřazuje k identitě volajícího. Samo o sobě nejde o
  bezpečnostní riziko (endpoint neprovádí žádný zápis proti záznamu volajícího), ale je zaznamenáno
  jako zbytečná vazba (dead-weight coupling) pro účely rebuild. **Confirmed** přímou inspekcí.

---

## Odkazy

- UC: žádný — žádný use case v aktuální draftové sadě nemodeluje tuto pre-flight kontrolu validace jako
  orchestrovaný krok toku; je zakotvena přímo na FN0018 (Identity, Session & Access Control, jejíž
  Related Entities již zahrnují User/EN0008 a Account/EN0007) a na ES0009 (externí systém, který tento
  endpoint volá, vedle již dokumentovaného volacího místa FN0019/UC0012).
- EN: EN0008 (User — kontrola role `organisation_worker`, pole `worker_available`), EN0007 (Account —
  odkazováno pro úplnost dle vlastnictví identity capability v FN0018; tímto endpointem samo o sobě
  nečteno)
- FN: FN0018 (Identity, Session & Access Control — vlastní model User/role, který tento endpoint čte)
- ES: ES0009 (WhoisXML API — vyhledání validity domény; tento endpoint je druhé, dříve
  nedokumentované volací místo směrem k témuž externímu systému, již zaznamenanému u FN0019/UC0012)
- ACL: ACL0009 (Identity, Access & Public API — nejbližší kotva přístupové kontroly pro tuto
  anonymně/autentizovaně dosažitelnou veřejnou REST plochu; Matrix ACL0009 dosud jmenovitě neuvádí
  `email_validation` — viz Otevřené body)

---

## Otevřené body

- Matrix ACL0009 aktuálně neuvádí `POST /api/email_validation` — tato kontraktová specifikace
  zaznamenává skutečná rolová oprávnění (anonymní + autentizovaný, obojí povoleno) přímo z
  `config/user.role.anonymous.yml` / `config/user.role.authenticated.yml`; budoucí refresh ACL vrstvy
  by mohl chtít tento řádek doplnit pro úplnost.
- Entitní typ `email_email` modulu `email` (administrační CRUD formuláře `EmailEntityForm`,
  `EmailEntitySettingsForm`, `EmailEntityDeleteForm`, list builder, handler přístupových práv,
  oprávnění `add/administer/delete/edit/view (un)published email entities`) je back-office typ
  archivního záznamu poštovní zprávy, doložený pouze prostřednictvím administračních rout Drupalu —
  žádný REST/HTTP kontrakt pro něj není exponován. Mimo rozsah tohoto API dokumentu; zaznamenáno, aby
  se na to nezapomnělo v budoucím ARCH/UI-facing průchodu. Jeho vztah k `EN0022 EmailArchive` (pokud
  existuje) není v tomto průchodu stanoven — zaznamenáno jako `Uncertain`.
- Hardcoded WhoisXML API klíč je znám ze zdrojového kódu, ale v tomto dokumentu redigován; pokud je
  potřeba pro plánování implementace/nápravy, vyhledejte jej přímo v
  `email/src/EmailService.php::domainExists()`.
- Zda dvě nezávislá volací místa WhoisXML (cesta `email.validateDomain` tohoto endpointu a cesta
  transakčního zasílání zpráv FN0019/UC0012 již zaznamenaná u ES0009) sdílejí stejnou cache tabulku
  nebo API kvótu, nebo jde o zcela nezávislé cesty kódu, které náhodou volají tutéž externí službu,
  nedoloženo nad rámec toho, že obě jsou vysledovatelné k téže rodině endpointů
  `domain-availability.whoisxmlapi.com` — zaznamenáno jako `Uncertain`, zde neuzavřeno.
- Zda 180denní expirace a fail-open chování cache tabulky `email_domain` byly záměrné návrhové
  rozhodnutí, nebo náhodné (např. debug/dev-convenience výchozí hodnota, která zůstala v kódu), není
  doloženo — zaznamenáno jako `Uncertain`.
