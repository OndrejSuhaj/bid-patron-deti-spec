---
doc_id: API0012
title: Scoring & Risk API
layer: API
spec_type: api-contract
status: imported
modules: []
contract_type: rest-internal
references:
  - UC0003
  - EN0017
  - EN0001
  - EN0002
  - EN0006
  - EN0016
  - FN0004
  - BR-ScoringAndRiskGating
  - ACL0003
---

# API0012 – API pro scoring a rizika

## Účel

Dva nezávislé REST zdroje výhradně pro back-office, exponované custom modulem `scoring`, sloučené do
jednoho kontraktu, protože sdílejí modul, implementační vzor REST-pluginu s autentizací přes `cookie`
a obrazovku posouzení rizika, kterou obsluhují:

1. **Odeslání/načtení snapshotu scoringu** (`scoring_rest_resource`) — obecně vyhlížející
   create/read endpoint, jehož současná implementace je nefunkční zástupný kód (stub): `POST` vždy
   vrací natvrdo daný úspěch bez jakéhokoli ukládání dat a `GET` vždy vrací natvrdo daný neúspěch. Za
   žádnou z metod není doložena žádná byznysová logika.
2. **Získání vizualizace vztahů scoringu** (`scoring_visualisation_resource`) — pouze pro čtení určený
   graf (uzly/hrany) sítě fundraiser/patron/dítě/kampaň navázaný na danou žádost (EN0001), použitý pro
   vykreslení D3.js grafu vztahů na obrazovce scoringu.

Oba jsou implementovány čistě jako REST-resource pluginy pod `scoring/src/Plugin/rest/resource/`;
modulem definovaný `scoring.routing.yml` obsahuje pouze interní HTML back-office routy (`ScoringForm`,
`ScoringLowRiskForm`, `AresController::searchByIco`, `ScoringController::visualisation`), které
**nejsou** REST kontrakty a jsou mimo rozsah tohoto dokumentu — viz Otevřené body. Samotné manuální
odeslání scoringu (pole, verdikt, klasifikace na blacklistu) provádí `ScoringForm` (HTML formulář, ne
REST zdroj) a je modelováno v UC0003 / FN0004 / BR-ScoringAndRiskGating, ne zde.

Evidence: `scoring/src/Plugin/rest/resource/ScoringResource.php`,
`scoring/src/Plugin/rest/resource/ScoringVisualisationResource.php`,
`config/rest.resource.scoring_rest_resource.yml`, `config/rest.resource.scoring_visualisation_resource.yml`,
`scoring/scoring.routing.yml`, `scoring/scoring.permissions.yml`.
Klasifikace: **Confirmed** pro tvar/chování endpointů (přímé čtení kódu); viz Poznámky k verzování
ohledně příznaku mezery v evidenci u rámování verze.

---

## Konzumenti

- Back-office recenzent rizika (role `risk_manager`; viz Autorizace) — jediná role explicitně
  oprávněná k volání zdroje Scoring Snapshot.
- Administrátor (obchvat `is_admin: true`) — implicitně schopný volat oba zdroje bez ohledu na
  explicitní přidělení rolí, dle standardního chování administrátorské role v Drupalu.
- Pro žádný z endpointů není doložen žádný veřejný/anonymní ani na dárce orientovaný konzument.

---

## Endpointy

### 1. Odeslání/načtení snapshotu scoringu

- **Vytvoření:** `POST /api/scoring` (plugin `scoring_rest_resource`)
- **Čtení:** `GET /api/scoring/{entity_name}/{entity_id}` (plugin `scoring_rest_resource`)
- **Formát:** pouze `json`.
- **Stav konfigurace:** `rest.resource.scoring_rest_resource.yml` → `status: false` — **zdroj je v
  prozkoumaném snapshotu povolené konfigurace aktuálně zakázaný**. Potvrzeně nepřítomný na živém
  povrchu, nejde o otevřenou položku.

### 2. Získání vizualizace vztahů scoringu

- **Čtení:** `GET /api/scoring/visualisation/{id}` (plugin `scoring_visualisation_resource`)
- **Formát:** pouze `json`.
- **Stav konfigurace:** `rest.resource.scoring_visualisation_resource.yml` → `status: true` — povoleno.

---

## Autorizace

Křížově ověřeno proti `scoring.permissions.yml`, všem souborům `config/user.role.*.yml`
(oprávnění REST na základě role, `restful <method> <plugin_id>`) a nastavení
`configuration.authentication: [cookie]` REST zdroje na obou zdrojích. Žádný ze zdrojů nedeklaruje
vlastní požadavek `_permission`/`_access` na úrovni routy (jde o routy REST-pluginu, nikoli routy
deklarované v `scoring.routing.yml`); přístup je řízen výhradně generickým oprávněním
`restful get|post <plugin_id>` podle role. To je konzistentní s ACL0003 (Přístup k riziku a scoringu).

| Endpoint | Přidělená role | Poznámky |
|---|---|---|
| `POST /api/scoring`, `GET /api/scoring/{entity_name}/{entity_id}` (`scoring_rest_resource`) | pouze `risk_manager` — `restful get scoring_rest_resource` + `restful post scoring_rest_resource` (dle `user.role.risk_manager.yml`) | Žádná jiná role (včetně `manager`, `coordinator`, `senior_coordinator`, `authenticated`, `anonymous`) toto oprávnění nemá. `administrator` se k němu dostane přes `is_admin: true`. **Aktuálně také nedosažitelné bez ohledu na přidělení role** — konfigurace `status: false` zdroj zcela deaktivuje (viz Endpointy). |
| `GET /api/scoring/visualisation/{id}` (`scoring_visualisation_resource`) | **Žádná role** v prozkoumané konfiguraci explicitně nemá `restful get scoring_visualisation_resource` | Potvrzená absence ve všech souborech `user.role.*.yml`, včetně `risk_manager`. Dosáhnout k němu může pouze `administrator`, a to přes obchvat `is_admin: true` — nikoli přes explicitní přidělení oprávnění. HTML stránka, která tento graf vkládá (`ScoringController::visualisation`, routovaná s `_permission: 'view scoring page'`, přidělenou roli `risk_manager`), je pro `risk_manager` dosažitelná, avšak samotné REST volání, kterým JS na této stránce data načítá, není v prozkoumané konfiguraci této roli explicitně oprávněno. |

Režim autentizace je pro oba zdroje `cookie` — volání vyžaduje aktivní relaci Drupalu (přihlášení do
back-office), nikoli bearer/API token.

Žádný ze zdrojů nekonzultuje řízení přístupu na úrovni entity: `ScoringResource` neprovádí žádné
načtení entity vůbec (viz Vedlejší účinky); `ScoringVisualisationResource` načítá `ApplicationEntity`
přímo přes statickou metodu `::load()` bez volání vlastního access-control handleru entity Application.

---

## Požadavek

### Odeslání/načtení snapshotu scoringu — vstupy

| Pole | Význam | Povinné | Poznámky |
|---|---|---:|---|
| (tělo POST) | Libovolný JSON payload | ne | `ScoringResource::post()` přijímá netypovaný parametr `array $data`, ale nikdy jej nečte — celé tělo požadavku je ignorováno. **Potvrzeno** přímou inspekcí; žádné pole není validováno ani uloženo. |
| `entity_name` (path, GET) | Zamýšlený discriminator typu/bundle pro scorovanou entitu | ano (podle tvaru routy) | V rámci `get()` nikdy nevyužito — metoda ignoruje oba parametry cesty. |
| `entity_id` (path, GET) | Zamýšlený číselný identifikátor scorované entity | ano (podle tvaru routy) | Stejně jako výše — nevyužito. |

### Získání vizualizace vztahů scoringu — vstupy

| Pole | Význam | Povinné | Poznámky |
|---|---|---:|---|
| `id` (path) | Identifikátor žádosti (EN0001), ze které se sestavuje graf vztahů | ano | Načteno přes `ApplicationEntity::load($id)`; pokud žádost neexistuje, vrací se 400 (viz Chybové výstupy). |

Pro žádnou z metod obou zdrojů neexistuje tělo požadavku.

---

## Odpověď

### Odeslání/načtení snapshotu scoringu — úspěch

| Pole | Význam | Poznámky |
|---|---|---|
| `status` | Literál `"successful"` (pouze POST) | HTTP 200. Bezpodmínečné — vráceno bez ohledu na obsah payloadu, žádný záznam/entita se nevytváří. **Potvrzené** chování zástupného kódu (stub). |

`GET` nikdy nevrací tvar úspěchu: vždy vrací tělo neúspěchu popsané níže (HTTP 200, ne skutečné
4xx/5xx — viz Chybové výstupy).

### Získání vizualizace vztahů scoringu — úspěch

| Pole | Význam | Poznámky |
|---|---|---|
| `nodes` | Pole uzlů grafu, každý `{id, name, color?}` | Jeden uzel pro každou odlišnou hodnotu appId / campaignId / patronApp / fundraiserApp / patronName / patronEmail / patronPhone / fundraiserName / fundraiserIp / fundraiserEmail / fundraiserPhone / childName / childRc objevenou při průchodu grafem žádosti (EN0001, EN0002). Názvy jsou normalizovány z hlediska bílých znaků; prázdné/duplicitní uzly a osamocené uzly bez hran jsou před odpovědí odfiltrovány. |
| `links` | Pole hran grafu, každá `{source_id, target_id, name}` | `name` je čitelný popisek vztahu (např. `patron name`, `patron app`, `fundraiser app`, `email`, `phone`, `ip`, `ChildName`, `rc`, `campaignId`). Duplicitní (neorientované) hrany jsou potlačeny. |

Graf je sestaven rekurzivním sledováním vazeb žádost-na-žádost typu `patron`/`fundraiser` (přes raw
SQL dotaz klíčovaný na entity-reference pole `patron`/`fundraiser`) až do pevné hloubky rekurze
5 skoků na každou stranu, takže odpověď může reprezentovat celý řetězec souvisejících žádostí, nejen
tu jednu identifikovanou přes `{id}`.

### Chybové výstupy

| Výstup | Význam | Opakovatelné | Poznámky |
|---|---|---:|---|
| Odeslání/načtení snapshotu scoringu: `GET` → HTTP 200, `{"status":"failed", "1":"Error with getting entity"}` | `get()` je bezpodmínečný zástupný kód (stub) — vždy vrací toto tělo bez ohledu na vstup | ne (nezávisí na vstupu; kód vždy prochází touto cestou) | **Potvrzeno.** HTTP status je 200 i přesto, že payload signalizuje neúspěch — quirk aktuálního stavu, který zde není opravován. |
| Získání vizualizace vztahů scoringu: HTTP 400, `{"status":"invalid","error":"invalid_id"}` | Parametr cesty `{id}` je prázdný nebo se nepodařilo přeložit na existující žádost (EN0001) přes `ApplicationEntity::load()` | ano, s platným id žádosti | Odpověď dále nese `addCacheableDependency(['#cache' => false])`. |

Pro žádný z obou zdrojů není doložena žádná další chybová cesta (např. žádné explicitní ošetření
malformovaného typu `entity_id`/`id` nad rámec typové koerce na úrovni routování).

---

## Vedlejší účinky

### Odeslání/načtení snapshotu scoringu

- **Žádné.** `post()` nezapisuje do content entity `scoring_entity` (dormantní nositel z EN0017, dle
  otevřené otázky 1 v EN0017), do záznamu žádosti (EN0001) ani do žádného jiného úložiště — pouze
  sestavuje a vrací natvrdo danou odpověď. `get()` neprovádí žádné čtení vůbec (žádné načtení entity,
  žádný dotaz). **Potvrzeno** — tento endpoint nemá za současné implementace žádný pozorovatelný
  účinek na stav systému, nezávisle na jeho deaktivaci v konfiguraci (`status: false`).

### Získání vizualizace vztahů scoringu

- Pouze pro čtení. Načítá cílovou žádost (EN0001) a rekurzivně až 5 navázaných žádostí na každou
  stranu patron/fundraiser (celkem 10 vyhledání) přes `ApplicationEntity::load()` plus jeden raw SQL
  dotaz na skok (`\Drupal::database()->query()` proti tabulce `application`). Žádné zápisy.
- Odpověď je explicitně označena jako nikoli cacheovatelná (`addCacheableDependency(false)` /
  `['#cache' => false]`).

---

## Poznámky k verzování

Pro `scoring_rest_resource` ani `scoring_visualisation_resource` neexistuje žádný REST plugin, routa
ani konfigurační záznam ve verzi `v3.1`/`v3.2`/`v3.3` (ani žádné jiné verzované varianty) — v kódové
bázi i v konfiguraci je přítomna pouze jediná neverzovaná varianta každého z nich. Očekávání v rámování
úkolu, že se varianty v3.1/v3.2/v3.3 sloučí do jednoho kontraktu, **se na tento modul nevztahuje**;
zaznamenáno zde jako mezera v evidenci, nikoli vymyšleno. (Na rozdíl od jiných modulů sousedících se
`scoring` v této kódové bázi, např. `account`/`campaigns`, které varianty `_v30`/`_v31`/`_v32`/`_v33`
REST rozhraní skutečně nesou — tento vzor verzování prostě nebyl pro vlastní REST rozhraní modulu
`scoring` přijat.)

---

## Rizika (aktuální stav)

- **Nefunkční endpoint Scoring Snapshot:** `POST` u `scoring_rest_resource` bezpodmínečně oznamuje
  úspěch bez uložení odeslaného payloadu a jeho `GET` bezpodmínečně oznamuje neúspěch bez pokusu o
  jakékoli vyhledání. Jakýkoli volající (nebo dokumentace, nebo budoucí integrátor), který by
  předpokládal, že tento zdroj je funkční create/read API pro scoringová data, by byl uveden v omyl —
  aktuálně nedělá nic víc než echo pevně dané odpovědi. **Potvrzeno** přímou inspekcí obou těl metod;
  umocněno tím, že zdroj je navíc deaktivován v konfiguraci (`status: false`), takže je dvojnásobně
  neaktivní — není dosažitelný a ani po případném znovu-povolení by nedělal nic užitečného. Není
  doloženo, zda se jedná o legacy/opuštěný scaffolding nebo záměrné zástupné místo; zaznamenáno jako
  `Uncertain`.
- **Endpoint vizualizace nemá explicitní přidělení role:** `scoring_visualisation_resource` je v
  konfiguraci povolený (`status: true`), ale žádná role v prozkoumané sadě `user.role.*.yml` —
  včetně `risk_manager`, role, které jinak obrazovka scoringu náleží — explicitně nemá `restful get
  scoring_visualisation_resource`. Dosáhnout k němu může pouze obchvat `is_admin: true` role
  `administrator`. To znamená, že widget grafu vztahů na vlastní obrazovce scoringu není dle
  konfigurovaného modelu oprávnění dosažitelný pro svého zamýšleného back-office uživatele
  (`risk_manager`), pokud neexistuje mimo-pásmové oprávnění nezachycené v prozkoumaných konfiguračních
  souborech. **Potvrzena** absence oprávnění v konfiguraci; **Uncertain**, zda to odráží skutečnou
  mezeru v přístupu v produkci (např. širší oprávnění zde nezachycené) nebo skutečný defekt aktuálního
  stavu — označeno k vyjasnění, nikoli vyřešeno.
- **Neomezené větvení grafu vztahů bez potvrzeného limitu šířky:** hloubka rekurze je omezena na 5
  skoků na stranu (celkem 10 žádostí), ale každý skok vydává raw SQL dotaz bez paginace/limitu nad
  rámec `LIMIT 1`; pro hustě propojenou datovou sadu patron/fundraiser jde o omezenou, ale netriviální
  nákladovost na jeden požadavek. Nejde o bezpečnostní riziko s ohledem na výše uvedená zjištění o
  autentizaci/autorizaci, ale je zaznamenáno jako latentní úvaha o výkonu. **Partial** — neexistuje
  žádná evidence ze zátěžového testování ani v jednom směru.
- **Povrch expozice osobních údajů (PII):** pole `nodes` v odpovědi vizualizace může nést jména
  patrona/fundraisera, e-maily, telefonní čísla, IP adresy a jméno dítěte + rodné číslo (birth/ID
  number) v prostém textu, chráněno pouze generickou branou REST oprávnění Drupalu (bez redakce na
  úrovni pole). S ohledem na sousední riziko výše (nenalezené explicitní přidělení role) je praktická
  expozice v aktuálním stavu omezena pouze na účet(y), které se skutečně mohou autentizovat a k
  endpointu se dostat — samotný tvar odpovědi ale nenese žádnou vestavěnou minimalizaci. **Potvrzený**
  tvar; rámování rizika je pozorováním aktuálního stavu, ne návrhem opravy.

Pro tento modul se neuplatňují žádná rizika typu anonymního webhooku nebo platebního callbacku
(např. natvrdo dané verifikační tokeny, chybějící HMAC) — oba REST zdroje `scoring` vyžadují
autentizaci `cookie` (relace) a žádný z nich není veřejný příchozí webhook.

---

## Odkazy

- UC: UC0003 (Posouzení rizika žadatele / Scoring) — manuální scoringový formulář a automatický
  přepočet low-risk, který endpoint vizualizace v tomto kontraktu podporuje a který (nefunkční)
  endpoint Scoring Snapshot ve skutečnosti neimplementuje.
- EN: EN0017 (ScoringRecord — snapshot scoringu, pro který se stub endpoint tohoto API zdá být
  zamýšlen, ale do kterého nezapisuje), EN0001 (Application — agregát, který endpoint vizualizace
  prochází), EN0002 (ApplicationProfile — pole profilu fundraisera/patrona zobrazená jako uzly grafu),
  EN0006 (Contact), EN0016 (Blacklist)
- FN: FN0004 (Scoring a posouzení rizika)
- BR: BR-ScoringAndRiskGating
- ACL: ACL0003 (Přístup k riziku a scoringu — dokumentuje přidělení `scoring_rest_resource` roli
  `risk_manager` a širší sadu oprávnění pro scoring odkazovanou výše)

---

## Otevřené body

- HTML routy modulu (`scoring.scoring_form`, `scoring.scoring_low_risk_form`,
  `scoring.ares_controller_searchByIco`, `scoring.visualisation_controller` v `scoring.routing.yml`)
  jsou back-office formuláře/kontroléry chráněné přes `_permission: 'view scoring page'` /
  `'view low risk scoring page'` / `'ares search by ico'`. Jde o routy formuláře/kontroléru Drupalu,
  nikoli REST kontrakty, takže jsou mimo rozsah tohoto API dokumentu — zaznamenáno zde, aby se v
  budoucím UI/ARCH orientovaném průchodu neztratily. Výše nejsou modelovány jako endpoint. Samotné
  manuální odeslání scoringu (pole, verdikt, klasifikace na blacklistu) probíhá přes `ScoringForm`
  (routa `scoring.scoring_form`) a je modelováno v UC0003, ne zde.
- Zda je chování zástupného kódu (stub) `post()`/`get()` u `scoring_rest_resource` mrtvý/opuštěný
  scaffolding (např. nahrazený předchůdce dnešního HTML flow `ScoringForm`) nebo nedokončený
  integrační bod, není v rámci tohoto modulu doloženo. Hypothesis — nedoloženo v aktuálních zdrojích.
- Zda chybějící explicitní přidělení role pro `scoring_visualisation_resource` (viz Rizika) odráží
  skutečnou produkční sadu oprávnění, nebo nekompletní export konfigurace, nelze z prozkoumaných
  zdrojů pro tento kontrakt rozhodnout. Conflict/gap — vyžaduje vyjasnění.
- Dormantní content entita `scoring_entity` (odlišná od obou REST zdrojů v tomto kontraktu) má vlastní
  CRUD oprávnění (`add/edit/delete/administer scoring entity entities`) a HTML routy přes
  `ScoringEntityHtmlRouteProvider`, ale v aktuální kódové bázi není exponována přes žádný REST zdroj —
  konzistentní s otevřenou otázkou 1 v EN0017 (dormantní nositel, žádný current-state writer). Není
  zde modelováno jako endpoint, protože pro ni neexistuje žádný REST povrch.
</content>
