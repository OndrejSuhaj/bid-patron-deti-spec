---
doc_id: API0008
title: Feedback API
canonical_layer: API
spec_type: api-contract
status: canonical
modules: []
contract_type: rest-public
references:
  - EN0021
  - EN0004
  - ES0006
  - ES0015
  - ACL0009
---

# API0008 – Feedback API

## Účel

Dva nezávislé, veřejně dostupné REST prostředky vystavené vlastním modulem `feedback`, sloučené do
jednoho kontraktu, protože sdílejí stejný modul, verzovací schéma (`/api/3.0/...` a
`/api/3.2/...`) a stejný implementační vzor REST-pluginu:

1. **Get Campaign Feedback** — čtení (read-only) veřejných zobrazovaných polí jednoho záznamu
   Feedback (EN0021) pro daný Campaign/Story (EN0004), použité k vykreslení „intercept" teaseru
   (titulek + úryvek + hlavní obrázek) na storefrontu.
2. **Submit Contact/Lead Enquiry** — veřejný formulářový dotaz („Znáte děti, které potřebují
   pomoc?" — CTA text ověřený v kódu), který odešle e-mail na operátorskou mailovou schránku a
   „best-effort" odešle ping do interního Slack kanálu; jde o marketingový/lead-capture dotaz,
   nikoli o záznam Feedback (EN0021) a nikoli o zápis entity Lead.

Oba prostředky jsou implementovány výhradně jako REST resource pluginy; soubor modulu
`feedback.routing.yml` definuje pouze interní HTML admin/back-office formulářové routy
(`campaign_feedback_form`, `fundraiser_feedback_form`, `application.feedback.fundraiser`), které
**nejsou** součástí tohoto API kontraktu — viz Otevřené body.

Evidence: `feedback/src/Plugin/rest/resource/{v30,v32}/FeedbackResource.php`,
`feedback/src/Plugin/rest/resource/{v30,v32}/ContactFormResource.php`,
`config/rest.resource.feedback_resource*.yml`, `config/rest.resource.contact_form_resource_*.yml`.
Klasifikace: **Confirmed** (přítomen kód i aktivovaná konfigurace).

---

## Konzumenti

- Veřejný storefront frontend (anonymní návštěvníci) — oba endpointy jsou dostupné bez
  autentizace na jejich aktuálně aktivované verzi.
- Autentizované session dárců/uživatelů — navíc pokryty supersetovým oprávněním role
  `authenticated` (viz Autorizace); žádné odlišné chování konzumenta nebylo evidováno mimo
  přiřazení identity žadatele k side-effectům formuláře pro kontakt.

---

## Endpointy

### 1. Get Campaign Feedback

- **Metoda / cesta (aktuální, aktivní):** `GET /api/3.0/feedback/{campaign_id}`
  (plugin `feedback_resource`; `rest.resource.feedback_resource.yml` → `status: true`)
- **Metoda / cesta (varianta v3.2, přítomná, ale deaktivovaná):** `GET /api/3.2/feedback/{campaign_id}`
  (plugin `feedback_resource_v32`; `rest.resource.feedback_resource_v32.yml` → `status: false`)
- **Formát:** pouze `json` (obě verze).

### 2. Submit Contact/Lead Enquiry

- **Metoda / cesta (v3.0):** `POST /api/3.0/cta/email` (plugin `contact_form_resource_30`;
  `rest.resource.contact_form_resource_30.yml` → `status: true`)
- **Metoda / cesta (v3.2):** `POST /api/3.2/cta/email` (plugin `contact_form_resource_32`;
  `rest.resource.contact_form_resource_32.yml` → `status: true`)
- **Formát:** pouze `json` (obě verze).
- Obě verze jsou v REST konfiguraci aktivní současně; liší se pouze způsobem, jakým je určen
  jednající uživatel (viz Poznámky k verzování), a jsou dostupné pro odlišné role (viz
  Autorizace). Žádná z nich v konfiguraci druhou nenahrazuje — obě jsou živé.

---

## Autorizace

Ověřeno křížovou kontrolou proti `config/user.role.anonymous.yml` a
`config/user.role.authenticated.yml` (REST oprávnění na základě rolí, `restful <method> <plugin_id>`)
a nastavení REST prostředku `configuration.authentication: [cookie]`. Na těchto prostředcích
neexistuje žádný požadavek na routu typu `_permission`/`_access` (jde o routy REST-pluginu, nikoli
o routy deklarované v `feedback.routing.yml`).

| Endpoint | Anonymní | Autentizovaný | Poznámky |
|---|---|---|---|
| `GET /api/3.0/feedback/{campaign_id}` (`feedback_resource`) | **Povoleno** — uděleno `restful get feedback_resource` | Povoleno (superset oprávnění anonymního uživatele) | Confirmed |
| `GET /api/3.2/feedback/{campaign_id}` (`feedback_resource_v32`) | Neuděleno žádné roli | Neuděleno žádné roli | Konfigurace `status: false` (prostředek deaktivován) **a** žádná role neuděluje `restful get feedback_resource_v32` — nedosažitelný bez ohledu na to. Confirmed jako nepřítomné, nikoli Otevřený bod. |
| `POST /api/3.0/cta/email` (`contact_form_resource_30`) | **Povoleno** — uděleno `restful post contact_form_resource_30` | Povoleno (superset) | Confirmed |
| `POST /api/3.2/cta/email` (`contact_form_resource_32`) | **Neuděleno** anonymnímu | **Povoleno** — uděleno `restful post contact_form_resource_32` pouze roli `authenticated` (dle ACL0009) | Confirmed. Režim autentizace je `cookie`, takže autentizované volání vyžaduje aktivní Drupal session, nikoli bearer token. |

Žádný z prostředků nekonzultuje řízení přístupu na úrovni entity (např.
`FeedbackEntityAccessControlHandler`) — obě čtou/zapisují raw data přímo
(`\Drupal::database()->query()` u GET; přímé odeslání mailu/Slacku u POST), a tak obcházejí
vrstvu přístupu k entitě Feedback, která řídí back-office CRUD formuláře (mimo rozsah tohoto
kontraktu).

---

## Požadavek

### Get Campaign Feedback — Vstupy

| Pole | Význam | Povinné | Poznámky |
|---|---|---:|---|
| `campaign_id` (path) | Numerický identifikátor Campaign/Story (EN0004), pro který se má zpětná vazba získat | ano | Porovnáno se sloupcem `campaign` v podkladové tabulce `feedback` pomocí raw SQL; žádná typová validace nad rámec toho, co provádí routing. |

Bez těla požadavku.

### Submit Contact/Lead Enquiry — Vstupy

| Pole | Význam | Povinné | Poznámky |
|---|---|---:|---|
| `email` | E-mailová adresa tazatele pro odpověď (reply-to) | ano | Validováno pomocí `patron_base.default` kontroly formátu e-mailu + domény (`isEmailValid`); požadavek je zamítnut, pokud je prázdný nebo neplatný. |
| `message` | Volný text dotazu | ano | Zamítnuto, pokud je prázdný. Bez evidovaného omezení délky. |
| `user_id` | UUID již existujícího Drupal uživatele (pouze v3.0) | ne | v3.0 tuto hodnotu přijímá v payloadu a načte uživatele podle UUID, aby dotaz přiřadila; v3.2 toto pole zcela ignoruje a použije místo něj vlastního autentizovaného uživatele REST session (viz Poznámky k verzování). |

---

## Odpověď

### Get Campaign Feedback — Úspěch

| Pole | Význam | Poznámky |
|---|---|---|
| `intercept_title` | Pole `name` (label) záznamu Feedback (EN0021) | HTTP 200 |
| `intercept` | První věta z pole `body` zpětné vazby, bez HTML | Text `body` rozdělen na první `.`; `&nbsp;` normalizováno na mezeru. |
| `content` | Zbytek pole `body` zpětné vazby po první větě | Stejné čištění jako výše. |
| `featured_image` | URL prvního `<img>` nalezeného v HTML pole `body`, přepsané na absolutní URL pomocí nastavení webu `backend_url` | Best-effort extrakce pomocí regexu, nikoli strukturovaný odkaz na médium. |

Na cestě „zpětná vazba nenalezena" (viz Neúspěšné výsledky) není žádné tělo odpovědi.

### Submit Contact/Lead Enquiry — Úspěch

| Pole | Význam | Poznámky |
|---|---|---|
| `status` | Literál `"success"` | HTTP 200. Nevrací se žádný identifikátor dotazu/tiketu. |

### Neúspěšné výsledky

| Výsledek | Význam | Opakovatelné | Poznámky |
|---|---|---:|---|
| Get Campaign Feedback: HTTP 404, prázdné tělo `[]` | Pro daný `campaign_id` neexistuje žádný záznam Feedback (EN0021) s vyplněnými poli `name` i `body` | ano (jakmile záznam Feedback existuje) | Vrací se i tehdy, pokud má kampaň více řádků zpětné vazby — uvažován je pouze jeden (nahodilý, neuspořádaný `LIMIT 1`); nebyla evidována žádná logika pro výběr „který feedback". |
| Submit Contact/Lead Enquiry: HTTP 401, `{"status":"failed","error":"missing_email_or_message"}` | Chybí/je prázdné `email` nebo `message` | ano, po opravě | Poznámka: HTTP 401 se používá pro chybu validace, nikoli pro chybu autorizace — aktuální quirk stavu, zde nekorigovaný. |
| Submit Contact/Lead Enquiry: HTTP 401, `{"status":"failed","error":"Email validation error"}` | `email` neprojde kontrolou formátu nebo domény | ano, po opravě | Stejný quirk „HTTP 401 pro validaci" jako výše. |

Pro chybu v přenosu mailu (`patron_base.smartmailing` / `APIMailingService::handleMail`) není
evidováno žádné explicitní ošetření — prostředek vždy vrátí úspěch po projití validace, bez ohledu
na to, zda se odchozí odeslání/zařazení do fronty podaří. **Partial** — v tomto modulu dále
neevidováno.

---

## Vedlejší efekty (Side Effects)

### Get Campaign Feedback

- Pouze pro čtení. Bez vedlejších efektů.

### Submit Contact/Lead Enquiry

- Odešle e-mail přes `patron_base.smartmailing` (`APIMailingService::handleMail`, šablona
  `general_template`) na pevně danou adresu operátorské mailové schránky zapsanou přímo ve třídě
  prostředku (zde redigováno — viz riziko níže), obsahující tazatelovo `email` a `message`.
  Vedeno přes odchozí mailovou cestu platformy — viz ES0006 (Mautic) pro hranici transakčního
  e-mailu; tato konkrétní zpráva není jedním z kontraktů vrstvy MSG orientovaných na dárce (jde o
  interní lead/kontaktní notifikaci, mimo rozsah MSG).
- V neprodukčních prostředích (`Settings::get('environment') !== 'production'`) je předmět e-mailu
  doplněn prefixem `[TEST] `.
- Pokud lze dotaz přiřadit k známému uživateli (v3.0: odvozeno z UUID `user_id` v payloadu; v3.2:
  odvozeno z autentizované session), je tělo e-mailu doplněno jménem a e-mailem tohoto uživatele a
  je provedeno volání na `logger.slack` (`SlackLogger::sendMessageToZoneChannel`), které publikuje
  notifikaci do interního Slack „zone" kanálu — viz riziko níže ohledně skutečného efektu tohoto
  volání.
- Tento endpoint nevytváří žádnou entitu Lead, Application ani Feedback (EN0021) — přestože se
  nachází v modulu `feedback`, jde o samostatný mailer kontaktního formuláře, nikoli o zápisovou
  cestu pro jakoukoli kanonickou entitu dokumentovanou v EN0021.

---

## Poznámky k verzování

V kódové bázi i v aktivní konfiguraci koexistují dvě verzovací rodiny; pro tento modul neexistuje
žádný REST plugin ani konfigurační záznam pro v3.1 ani v3.3 — pro `feedback` existují pouze v3.0 a
v3.2 (rámování úkolu zmiňující v3.1/v3.3 se na tento modul nevztahuje; zaznamenáno jako mezera v
evidenci, nikoli vymyšleno).

- **Get Campaign Feedback:** v3.0 (`/api/3.0/feedback/{campaign_id}`) a v3.2
  (`/api/3.2/feedback/{campaign_id}`) jsou funkčně identické (stejný SQL dotaz, stejný tvar
  odpovědi); jediným rozdílem v kódu je defenzivní přetypování (`(string)$img[2][1]`) ve v3.2 a
  absence fallbacku `?? null` na poli shody obrázku. **v3.0 je aktuální živá verze** (konfigurace
  `status: true`); **v3.2 je přítomna, ale deaktivována** (`status: false`) a navíc nemá žádné
  udělení role — na úrovni konfigurace jde efektivně o mrtvý kód, nikoli jen o nevyužitý.
- **Submit Contact/Lead Enquiry:** v3.0 a v3.2 jsou obě aktivní, ale liší se v jednom
  behaviorálně významném ohledu: v3.0 odvozuje „známého uživatele" pro přiřazení z pole `user_id`
  dodaného v nedůvěryhodném POST payloadu (sebedeklarovaná identita — volající může uvést UUID
  jakéhokoli uživatele); v3.2 naopak ignoruje `user_id` z payloadu a použije vlastního
  `current_user` z REST session, což je korektnější, ale dosažitelné pouze autentizovanými
  volajícími (anonymnímu uživateli není `contact_form_resource_32` udělen). Obě verze jsou jinak
  identické (stejná validace, stejná mailová šablona, stejné volání Slacku).

---

## Rizika (aktuální stav)

- **Sebedeklarovaná identita u kontaktního formuláře v3.0:** `ContactFormResource` (v3.0) důvěřuje
  klientem dodanému UUID `user_id` a na jeho základě přiřadí dotaz existujícímu Drupal uživateli a
  do těla odchozího e-mailu vloží jeho skutečné jméno/e-mail — bez jakékoli verifikace, že volající
  je skutečně tento uživatel (endpoint je dosažitelný anonymně). To umožňuje falešné přiřazení
  odeslaných dotazů libovolným známým uživatelům. **Confirmed** (zdroj:
  `feedback/src/Plugin/rest/resource/v30/ContactFormResource.php:118-123`).
- **Pevně zadaná adresa příjemce:** obě verze ContactFormResource mají cílovou mailovou schránku
  pevně zadanou přímo ve zdrojovém kódu prvního argumentu `handleMail()` (nejde o redigovaný
  evidenční artefakt — je to literální řetězec ve třídě); provozně to znamená, že cíl doručení
  dotazu nelze změnit bez nasazení nového kódu. **Confirmed**, adresa je z tohoto dokumentu
  redigována v souladu s hygienou write-scope.
- **No-op Slack notifikace:** metoda `sendMessageToZoneChannel()` služby `logger.slack`
  (`slack_integration/src/SlackLogger.php:85-86`) má v aktuální kódové bázi prázdné tělo metody —
  volání provedené oběma verzemi ContactFormResource se zkompiluje a provede, ale nevykoná žádný
  reálný post do Slacku. Kódová cesta popsaná výše jako „vedlejší efekt" je tedy v současnosti
  neúčinná; zaznamenáno jako riziko, protože tiše nedojde k upozornění operátorů na odeslané
  dotazy z kontaktního formuláře, ačkoli kód navenek působí, že to dělá. **Confirmed** přímou
  inspekcí těla metody.
- **Chyby validace vracené jako HTTP 401:** obě verze ContactFormResource vracejí HTTP 401
  (Unauthorized) pro obyčejné chyby vstupní validace (chybějící/neplatný email nebo message), což
  je sémanticky opakované použití kódu autentizačního stavu pro výsledek business validace.
  **Confirmed**, jde pouze o quirk aktuálního stavu — zde nekorigováno v souladu s disciplínou
  rekonstrukce.
- **Raw SQL čtení obcházející přístup na úrovni entity:** `FeedbackResource::get()` (obě verze)
  dotazuje základní tabulku `feedback` přímo přes `\Drupal::database()->query()` namísto načtení
  entity Feedback přes její storage s řízeným přístupem/`FeedbackEntityAccessControlHandler` —
  stav publikace (boolean `status` na EN0021) tímto dotazem není filtrován, takže by
  nepublikovaný záznam Feedback mohl být veřejně vystaven, pokud daný řádek vyhoví `LIMIT 1` pro
  daný `campaign_id`. **Partial** — dotaz nefiltruje podle `status`/stavu publikace, ale nebyla
  nalezena žádná evidence potvrzující, že by se nepublikovaný záznam takto skutečně v produkci
  někdy zobrazil; označeno jako latentní mezera, nikoli pozorovaný incident.
- **v3.2 Feedback GET deaktivováno + dvojnásobně nedosažitelné:** na rozdíl od typického vzoru
  „stará verze zachovaná pro zpětnou kompatibilitu" je `feedback_resource_v32` současně
  konfiguračně deaktivována i bez udělené role — dva nezávislé důvody, proč nemůže být volána.
  Nejde o riziko v bezpečnostním smyslu, ale o provozní nástrahu: budoucí konfigurační změna,
  která znovu nastaví `status: true`, by ji stále nezpřístupnila bez přidání udělení role, a
  naopak. **Confirmed**.

---

## Odkazy (References)

- UC: žádné — žádný use case v aktuální draft sadě nemodeluje autorizaci Feedback (EN0021) ze
  strany fundraisera/back-office ani veřejnou konzumaci zpětné vazby jako orchestrovaný tok (viz
  EN0021 Otevřená otázka 4); tento kontrakt je zakotven přímo na EN0021 (entita) a FN0006
  (kapacita Campaign/Story Lifecycle, která uvádí Feedback jako součást veřejného lifecycle
  příběhu), nikoli na UC.
- EN: EN0021 (Feedback), EN0004 (Campaign/Story)
- FN: FN0006 (Campaign/Story Lifecycle — uvádí Feedback jako součást udržovaného veřejného
  povrchu příběhu)
- ES: ES0006 (Mautic — hranice odchozího mailu pro kontaktní dotaz), ES0015 (Slack — hranice
  provozních upozornění / business pingů; Slack volání kontaktního formuláře je třetí, v
  současnosti neúčinné, místo volání, které ještě není zohledněno v dokumentovaných režimech
  ES0015)
- ACL: ACL0009 (Identity Access and Public API — dokumentuje výše zmíněné udělení
  `contact_form_resource_32` roli `authenticated`)

---

## Otevřené body

- HTML routy modulu (`feedback.campaign_feedback_form`, `feedback.fundraiser_feedback_form`,
  `application.feedback.fundraiser` v `feedback.routing.yml`) jsou back-office/fundraiser-zone
  formuláře pro autorizaci Feedback (EN0021), chráněné pomocí `_permission: 'add feedback entities'` /
  `'add leads'` / `_application_role: fundraiser`. Jde o Drupal formulářové routy, nikoli REST
  kontrakty, takže jsou mimo rozsah tohoto API dokumentu — zaznamenáno zde, aby je budoucí
  UI/ARCH orientovaný průchod neztratil. Výše nejsou modelovány jako endpoint.
- Žádný UC v současnosti nemodeluje, jak vlastně vzniká/publikuje se záznam Feedback (EN0021)
  tak, aby `GET /api/3.0/feedback/{campaign_id}` měl co vracet — tento kontrakt pokrývá pouze
  čtecí/zápisový povrch obou REST prostředků samotných, nikoli tvůrčí (authoring) tok. Křížový
  odkaz na EN0021 Otevřená otázka 4.
- Pevně zadaná adresa přijímací mailové schránky pro dotaz z kontaktního formuláře je známa ze
  zdroje, ale v tomto dokumentu je redigována; pokud je potřebná pro plánování implementace, lze
  ji získat přímo z `feedback/src/Plugin/rest/resource/{v30,v32}/ContactFormResource.php`.
- Zda byla deaktivace `feedback_resource_v32` záměrná (nahrazena/opuštěna), nebo náhodná
  (zapomenutá aktivace), není evidováno — zaznamenáno jako `Uncertain`, zde neřešeno.
