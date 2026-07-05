---
doc_id: API0014
title: Facebook Lead Webhook
layer: API
spec_type: api-contract
status: imported
modules: []
contract_type: webhook
references:
  - UC0013
  - EN0006
  - EN0009
  - FN0016
  - ES0007
---

# API0014 – Facebook Lead Webhook

## Účel

Vstupní webhook rozhraní vystavené modulem `facebook_leads` pro integraci Meta/Facebook Lead Ads:
handshake pro ověření odběru (potvrzeně funkční) a zamýšlená cesta pro doručování leadů (potvrzeně
neimplementováno). Druhý, nesouvisející endpoint ve stejném modulu přijímá výstupně orientovaná,
klientem vyvolaná GET volání, která přeposílají konverzní eventy vzniklé na straně prohlížeče do
Facebook Conversions API (CAPI) — je zahrnut do tohoto dokumentu, protože se jedná o stejný
modul/zdroj pravdy, ale jde o odlišný tvar kontraktu (utilitní relay, nikoli přijímač webhooků), a
je popsán samostatně níže.

Zdroj pravdy: REST resource pluginy pod
`web/modules/custom/facebook_leads/src/Plugin/rest/resource/` —
`FacebookLeadWebhookResource.php` (webhook, `facebook_lead_webhook_resource`) a
`FacebookResource.php` (CAPI relay, `facebook_leads_facebook`) — křížově ověřeno proti
`config/rest.resource.facebook_lead_webhook_resource.yml`,
`config/rest.resource.facebook_leads_facebook.yml` a
`config/user.role.{anonymous,authenticated}.yml`. Neexistuje žádný soubor `facebook_leads.routing.yml`;
routy jsou definovány výhradně anotacemi `@RestResource` `uri_paths` na obou plugin třídách
(mechanismus jádra Drupalu, modul `rest` — dále zde nepopisováno, dle omezení pro API dokumenty).

## Konzumenti

- Integration(Facebook) — Meta/Facebook Lead Ads volající strana pro ověření odběru a (zamýšlené)
  doručení leadů, pro `POST/GET /api/2.2/facebook/lead`.
- Frontend Patronusu (skript na straně prohlížeče) — volající strana `GET /api/3.2/facebook`, který
  přeposílá konverzní eventy na úrovni stránky na straně serveru do Facebook CAPI ve prospěch
  návštěvníka.

## Typ kontraktu

`webhook` (primární rozhraní: `FacebookLeadWebhookResource`, `/api/2.2/facebook/lead`), s jedním
přiloženým `utility`-tvarovaným relay endpointem (`FacebookResource`, `/api/3.2/facebook`)
dokumentovaným ve stejném souboru, protože sdílí modul a rozsah zdroje pravdy. Ve zdrojovém kódu
neexistuje varianta `v3.1`/`v3.3` žádného z endpointů (Confirmed — prohledáno `config/` a
`web/modules/custom/facebook_leads/` pro jakoukoli další verzní cestu nebo řetězec role/oprávnění;
přítomny jsou pouze cesty `2.2` a `3.2`). „Aktuální verze" každého endpointu je jediná existující
verze — neexistuje žádná nahrazená varianta ke sloučení.

## Autorizace

Confirmed, dle `config/rest.resource.facebook_lead_webhook_resource.yml` a
`config/rest.resource.facebook_leads_facebook.yml` (obě `authentication: cookie`), křížově ověřeno
proti `config/user.role.anonymous.yml` a `config/user.role.authenticated.yml`:

| Endpoint | Oprávnění Drupalu | Uděleno komu |
|---|---|---|
| `GET /api/2.2/facebook/lead` | `restful get facebook_lead_webhook_resource` | anonymous, authenticated |
| `POST /api/2.2/facebook/lead` | `restful post facebook_lead_webhook_resource` | anonymous, authenticated |
| `GET /api/3.2/facebook` | `restful get facebook_leads_facebook` | anonymous, authenticated |
| `POST /api/3.2/facebook` | `restful post facebook_leads_facebook` | anonymous, authenticated (endpoint je no-op stub, viz Endpointy) |

Obě resources jsou udělené roli `anonymous` pro každou metodu, kterou vystavují (Confirmed —
`config/user.role.anonymous.yml`, řádky 41–42, 114–115, 157–158). Neexistuje žádná kontrola relace,
API klíče, HMAC podpisu ani ověření podpisu specifické pro Facebook (např. žádná verifikace
`X-Hub-Signature`/`X-Hub-Signature-256`) na žádném z endpointů — jedinou „autentizací" provedenou
metodou `FacebookLeadWebhookResource::get()` je prosté porovnání řetězce (query parametr proti
hardcodovanému tokenu vloženému do zdrojového kódu modulu (viz Rizika)). `FacebookLeadWebhookResource::post()`
neprovádí žádnou kontrolu autentizace před odpovědí.

## Endpointy

### 1. `GET /api/2.2/facebook/lead` — Ověření odběru webhooku Lead Ads (dle pozorování)

Plugin: `facebook_lead_webhook_resource` (`Drupal\facebook_leads\Plugin\rest\resource\FacebookLeadWebhookResource::get()`).
Aktuální a jediná verze. Implementuje handshake pro ověření odběru webhooku Meta
(`UC0013` AF1).

#### Požadavek

| Pole | Význam | Povinné | Poznámky |
|---|---|---|---|
| `hub_verify_token` (query parametr) | Ověřovací token dodaný volající stranou | ano | Porovnáno operátorem `===` proti literálnímu řetězci tokenu hardcodovanému v resource třídě. |
| `hub_challenge` (query parametr) | Hodnota výzvy, která se má vrátit zpět při úspěšném ověření | ano | Předáno beze změny. |

#### Odpověď — Úspěch

| Pole | Význam | Poznámky |
|---|---|---|
| *(raw tělo, nikoli JSON)* | Literální hodnota `hub_challenge`, vrácená zpět, přičemž požadavek je ukončen přes `die()` | Confirmed z kódu: tímto se zcela obchází standardní cesta `ResourceResponse`/serializer — úspěšná odpověď není JSON obálka jako u zbytku tohoto kontraktu, jde o raw řetězec výzvy s jakýmkoli HTTP stavem, který po sobě zanechá `die()` (Open Item — přesný stavový kód není ze statického kódu samotného doložitelný). |

#### Neúspěšné výstupy

| Výstup | Význam | Opakovatelné | Poznámky |
|---|---|---|---|
| `{"status": "failed", "error": "token is invalid"}` (HTTP 200) | Dodaný `hub_verify_token` neodpovídá hardcodované hodnotě | ano, se správným tokenem | Neúspěch je signalizován in-band pomocí HTTP 200, nikoli stavem 4xx. |

### 2. `POST /api/2.2/facebook/lead` — Doručování leadů Lead Ads — Plánováno / Neimplementováno

Plugin: `facebook_lead_webhook_resource` (`FacebookLeadWebhookResource::post()`). Aktuální a jediná
verze. Toto je endpoint, který by Meta volala pro doručení zachyceného submitu Lead Ads
(`UC0013` AF2).

**Status: Planned / Not Implemented.** Confirmed z kódu:

- Signatura metody přijímá parametr `$data` (dekódované tělo požadavku), ale tělo metody okamžitě
  loguje nedefinovanou proměnnou `$request_data` (nikdy nikde v třídě přiřazenou) — potvrzeno, že
  toto při běhu vyvolá PHP notice/warning, nikoli funkční log statement.
- Žádné pole příchozího payloadu není čteno, validováno ani persistováno.
- Není vytvořen žádný Contact (`EN0006`) ani jakákoli entita na straně Application.
- Metoda nepodmíněně vrací `{"status": "failed", "error": "token is invalid"}` s HTTP 200 bez
  ohledu na obsah požadavku — stejný tvar těla jako neúspěšná cesta GET handshake, přestože u
  POST volání pro doručení leadu není žádný token vůbec zapojen.

#### Požadavek

Není dokumentováno jako reálný kontrakt — implementace nečte žádné pole. Jakýkoli tvar payloadu
webhooku Lead Ads od Meta (dle vlastního webhookového formátu Meta) sem dorazí nepřečten. Zde
pole záměrně nepředepisujeme, dle pravidla „nevymýšlet" — tato tabulka požadavku je zde
záměrně vynechána.

#### Odpověď

| Pole | Význam | Poznámky |
|---|---|---|
| `status` | Vždy `"failed"` | Confirmed: nepodmíněné, nezávislé na vstupu. |
| `error` | Vždy `"token is invalid"` | Confirmed: stejný literální řetězec jako neúspěšné tělo GET handshake; kontextově nepřesné pro POST volání. |

HTTP stav je vždy 200 — Facebook obdrží úspěšně tvarovanou transportní odpověď, zatímco doručený
lead je tiše zahozen (viz `UC0013` AF2, `ES0007` Constraints pro rámování tohoto nedostatku na
byznysové úrovni; dále zde nerozvíjeno).

### 3. `GET /api/3.2/facebook` — Klientem vyvolaný relay eventů Conversions API (CAPI)

Plugin: `facebook_leads_facebook` (`Drupal\facebook_leads\Plugin\rest\resource\FacebookResource::get()`).
Aktuální a jediná verze. Nejde o webhook — je to server-side relay endpoint volaný frontendem
Patronusu pro přeposlání eventu pozorovaného v prohlížeči do Facebook CAPI (`graph.facebook.com`)
se server-side hashovanými daty pro párování uživatele (`UC0013` výstupní subtok; `ES0007`).
Dokumentováno zde, protože je definováno ve stejné rodině modul/třída jako webhook, nikoli protože
by sdílelo typ kontraktu webhooku.

#### Požadavek

| Pole | Význam | Povinné | Poznámky |
|---|---|---|---|
| `event_name` (query parametr) | Název eventu Facebook CAPI | ano | Pouze `Lead`, `Purchase`, `CompleteRegistration` obdrží `custom_data`; jakákoli jiná hodnota je stále přeposlána, ale s prázdným `custom_data`. |
| `params` (query parametr) | JSON-enkódovaný objekt s detaily eventu | ano | Confirmed workaround na úrovni kódu: pokud raw řetězec neobsahuje uzavírací `"}`, resource před dekódováním připojí `"}` — doklad pozorovaného problému s truncací příchozích dat, nikoli dokumentovaná vlastnost kontraktu. Selhání dekódování (prázdný výsledek) vrací 400. |
| `params.event_id` | Klientem dodané id eventu, přeposláno jako CAPI `event_id` | podmíněně povinné | Čteno z dekódovaného `params`; žádná validace přítomnosti před použitím. |
| `params.url` | URL stránky, přeposláno jako CAPI `event_source_url` | podmíněně povinné | Stejně. |
| `params.email`, `params.first_name`, `params.last_name`, `params.phone` | Pole identifikující návštěvníka | ne | Každé přítomné pole je zmenšeno na malá písmena a hashováno SHA-256 před umístěním do CAPI `user_data` (`em`/`fn`/`ln`/`ph`). |
| `params.country_code` | Kód země návštěvníka | ne | Hashováno do `user_data.country`, pokud je přítomné; pokud chybí, server vyhledá zemi z IP adresy volajícího prostřednictvím výstupního volání na `http://ip-api.com/json/{ip}` (Confirmed — druhá, nedokumentovaná výstupní integrace, neautentizovaná, plaintextové HTTP; není zde modelována jako samostatný ES dokument — Open Item). |
| `params.content_category`, `params.currency` | Použito pouze při `event_name = Lead` | ne | Umístěno do `custom_data`. |
| `params.value`, `params.currency`, `params.content_ids` | Použito pouze při `event_name = Purchase` | ne | Umístěno do `custom_data` (`content_ids` znovu použito beze změny jako `contents`). |
| `params.content_name`, `params.page_title`, `params.currency`, `params.status` | Použito pouze při `event_name = CompleteRegistration` | ne | Umístěno do `custom_data`; `status` konvertováno na boolean. |

#### Odpověď — Úspěch

| Pole | Význam | Poznámky |
|---|---|---|
| `status` | `"success"` | Vráceno jakmile je vydáno relay volání do Facebook CAPI; vlastní HTTP výsledek CAPI volání není v této odpovědi kontrolován ani reflektován (viz Rizika). |

#### Neúspěšné výstupy

| Výstup | Význam | Opakovatelné | Poznámky |
|---|---|---|---|
| `{"status": "error", "message": "Invalid input"}` (HTTP 400) | Chybí query parametr `event_name` nebo `params` | ano | |
| `{"status": "error", "message": "Invalid input"}` (HTTP 400) | `params` selže při JSON dekódování (i po workaroundu s uzavírací závorkou) | ano | |

### 4. `POST /api/3.2/facebook` — No-op stub

Plugin: `facebook_leads_facebook` (`FacebookResource::post()`). Confirmed no-op: metoda zcela
ignoruje svůj vstup a vždy vrací `{"status": "success"}` (HTTP 200) bez persistence, bez relay
volání a bez jakéhokoli side effectu. Zaznamenáno pouze pro úplnost — nejde o funkční command
kontrakt.

## Side Effecty

- **`GET /api/2.2/facebook/lead` (úspěšný handshake):** žádné — žádná entita není čtena ani
  zapisována; proces se ukončí přes `die()` po vrácení výzvy.
- **`POST /api/2.2/facebook/lead`:** žádné. Není vytvořen ani aktualizován žádný Contact (`EN0006`),
  Application ani jakákoli domain entita — toto je potvrzený current-state nedostatek sledovaný v
  `UC0013` AF2 (dále zde nerozvíjeno nad rámec tohoto odkazu).
- **`GET /api/3.2/facebook` (úspěšný relay):** vydá jedno výstupní HTTP POST volání na
  `graph.facebook.com/v16.0/{pixel_id}/events` nesoucí zkonstruovaný CAPI event payload
  (`ES0007`); při absenci `country_code` navíc vydá jedno výstupní HTTP GET volání na
  `ip-api.com` pro vyhledání země z IP. Výsledek žádného z výstupních volání není v Patronusu
  persistován; tímto endpointem není vytvořena, aktualizována ani čtena žádná domain entita
  Patronusu.
- **`POST /api/3.2/facebook`:** žádné (confirmed no-op).

## Rizika (current-state, dokumentováno)

- **Plně anonymní webhook rozhraní bez podpisu/verifikace.** Obě resources
  `facebook_lead_webhook_resource` i `facebook_leads_facebook` jsou udělené roli `anonymous` pro
  každou metodu, kterou vystavují (`config/user.role.anonymous.yml`). Žádný z endpointů nekontroluje
  podpis požadavku Facebooku (integrace Meta Lead Ads/CAPI konvenčně podporují
  `X-Hub-Signature-256`); jedinou branou webhooku je prosté porovnání řetězce `hub_verify_token` u
  GET, a POST nemá žádnou brácu vůbec. Kdokoli, kdo objeví URL, může tyto endpointy volat.
- **Hardcodovaný verifikační token vložený do zdrojového kódu.** `FacebookLeadWebhookResource::get()`
  porovnává `hub_verify_token` proti literální řetězcové konstantě v souboru třídy (hodnota v tomto
  dokumentu redigována; přítomna v plaintextu v `FacebookLeadWebhookResource.php`). Rotace nebo
  zúžení tohoto tokenu vyžaduje změnu kódu; token je viditelný komukoli s přístupem ke zdrojovému
  kódu a není konfigurován prostředím.
- **Intake pro doručení leadů není implementován.** `POST /api/2.2/facebook/lead` nepodmíněně vrací
  `{"status": "failed", "error": "token is invalid"}` s **HTTP 200**, takže z pohledu Meta volání
  transportně uspěje, zatímco doručený lead je tiše zahozen, a chybová zpráva je zavádějící
  (jmenuje selhání validace tokenu, ke kterému u POST volání vůbec nedošlo). Confirmed current-state
  nedostatek; viz `UC0013` AF2 / `ES0007` pro byznysové rámování.
- **Odkaz na nedefinovanou proměnnou při každém POST volání.** `post()` loguje
  `json_encode($request_data)`, kde `$request_data` není v daném scope nikdy přiřazena — toto
  vyvolá PHP notice/warning při každém vyvolání předtím, než metoda vrátí své hardcodované tělo
  neúspěchu. Confirmed z kódu; viditelnost výsledného warningu při běhu (error log vs. potlačeno)
  není doložena (Open Item, dle statické Runtime-truth-policy).
- **Výsledek CAPI relay není kontrolován.** `FacebookResource::sendData()` vydává výstupní `curl`
  volání CAPI s `CURLOPT_SSL_VERIFYHOST => false` a `CURLOPT_SSL_VERIFYPEER => false` (TLS
  verifikace vypnuta pro výstupní volání na `graph.facebook.com`) a zahazuje odpověď/HTTP kód
  (jediný řádek, který by logoval odpověď, je ve zdrojovém kódu zakomentován). Endpoint vždy
  odpovídá svému volajícímu `{"status": "success"}` bez ohledu na to, zda CAPI relay skutečně
  uspěl.
- **Access token a pixel id hardcodované ve zdrojovém kódu.** `FacebookResource::sendData()`
  vkládá literální dlouhodobý access token Facebooku a pixel id jako PHP řetězcové konstanty
  (hodnoty v tomto dokumentu redigovány; přítomny v plaintextu v `FacebookResource.php`). Stejné
  riziko rotace/vystavení jako u hardcodovaného verifikačního tokenu webhooku.
- **Neautentizované, nezašifrované volání na IP-lookup třetí strany.** Když `params.country_code`
  chybí, server provede plaintextový `http://` výstupní požadavek na `ip-api.com`, přičemž předává
  IP adresu odvozenou od volajícího (samu odvozenou z klientem dodaných, spoofovatelných hlaviček
  `HTTP_CLIENT_IP` / `HTTP_X_FORWARDED_FOR`, s fallbackem na `REMOTE_ADDR`) bez ošetření chyb nad
  rámec kontroly pravdivostní hodnoty. Jde o další, nedokumentovanou externí závislost vyvolávanou
  synchronně uvnitř zpracování požadavku.

## Reference

- UC: UC0013 (Sync Marketing & Intake Leads) — vlastní byznysové rámování jak handshake (AF1), tak
  neimplementované cesty intake (AF2); dále zde nerozvíjeno.
- EN: EN0006 (Contact) — entita, kterou by neimplementovaná cesta intake naplnila;
  EN0009 (Transaction) — subjekt výstupního konverzního signálu, který přeposílá sesterský endpoint
  tohoto modulu (jen kontext, nevlastněno tímto kontraktem).
- FN: FN0016 (Conversion & Analytics Relay) — vlastnící capability jak pro webhook, tak pro CAPI
  relay endpoint.
- ES: ES0007 (Facebook) — popis hranice externího systému pro webhook Lead Ads, Pixel a Conversions
  API rozhraní; dále zde nerozvíjeno.

## Otevřené body

- Přesný HTTP stavový kód vrácený voláním `die($challenge)` při úspěšném ověření odběru není ze
  statického kódu samotného doložitelný (PHP `die()` bez předchozího volání header defaultně
  ponechá jakýkoli stav, který odpověď již nese — pravděpodobně 200, ale nepotvrzeno proti běžící
  instanci dle statické Runtime-truth-policy).
- Zda je PHP notice/warning vyvolaný nedefinovanou proměnnou `$request_data` v `post()` viditelný v
  jakémkoli provozním logu, nebo tiše potlačen konfigurací error-reportingu prostředí, není
  doloženo.
- V tomto modulu neexistuje žádný soubor `facebook_leads.routing.yml`; cesty obou endpointů
  pocházejí výhradně z anotací `@RestResource` `uri_paths`. Zaznamenáno zde pouze pro potvrzení,
  že tato absence byla ověřena, dle instrukce ke zdroji pravdy — nejde o nedostatek tohoto
  dokumentu.
- Ve `config/` ani `web/modules/custom/facebook_leads/` nikde neexistuje varianta `v3.1` ani `v3.3`
  žádné z cest `/api/*/facebook/lead` ani `/api/*/facebook` (Confirmed vyhledáváním). Pokud jsou
  takové varianty očekávány z jiných zdrojů (např. materiálu `it-zadani` cílícího na target-state),
  popisovalo by to cílový/budoucí kontrakt, nikoli current-state — mimo rozsah zde dle pravidla
  current-vs-target.
- Literální hodnoty verify-tokenu, access-tokenu a pixel-id jsou z tohoto dokumentu redigovány
  dle politiky; zůstávají v plaintextu ve výše citovaných zdrojových souborech a v jakémkoli
  rewrite by měly být považovány za credentials vyžadující rotaci, nezávisle na dokumentaci tohoto
  kontraktu.
