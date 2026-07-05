---
doc_id: API0016
title: Contact API
layer: API
spec_type: api-contract
status: imported
modules: []
contract_type: rest-internal
references:
  - UC0003
  - EN0001
  - EN0002
  - EN0006
  - FN0004
  - FN0014
  - BR-ScoringAndRiskGating
---

# API0016 – Contact API

## Účel

Jediný REST resource exponovaný vlastním modulem `contact`: pouze pro čtení, ad-hoc předběžná
kontrola rizika, která na základě identifikátoru ApplicationProfile vyhledá vlastnící Application a
vrátí heuristickou poznámku k riziku "opakovaný žadatel" a numerické skóre vypočtené z několika polí
fundraisera/patrona. Nejde o CRUD kontrakt nad entitou Contact (`EN0006`) samotnou — CRUD entity
Contact modulu `contact` je exponován pouze přes interní HTML admin routy/formuláře
(`contact.routing.yml`: `/admin/contact/{contact}/fundraiser/edit`,
`/admin/contact/{contact}/patron/edit`, `/admin/contact/{contact}/versions`,
`/admin/contact/remove_duplicates`, `/admin/contact/search`), což jsou Drupal form/controller routy,
nikoli REST kontrakty, a jsou zde mimo rozsah (viz Otevřené body; destruktivní chování
deduplikace/sloučení dosažitelné z `/admin/contact/remove_duplicates` je modelováno v `FN0014`, zde
není opakováno).

Zdroj pravdy: jediný REST resource plugin pod
`web/modules/custom/contact/src/Plugin/rest/resource/ContactResource.php` (plugin id
`contact_resource`, `@RestResource` `uri_paths.canonical = "/api/contact"`), ověřeno křížově proti
`config/rest.resource.contact_resource.yml`, `contact.routing.yml`, `contact.permissions.yml` a všem
souborům `config/user.role.*.yml`. Žádný záznam v `contact.routing.yml` nedefinuje `/api/contact` —
cesta pochází výhradně z anotace `@RestResource` (mechanismus jádrového Drupal modulu `rest`, zde dále
nepopisovaný v souladu s omezeními pro API).

## Konzumenti

- Back-office personál s autentizovanou Drupal session, dosažitelný pouze přes generické Drupal
  oprávnění `restful get contact_resource` — viz Autorizace. U žádného volajícího nebylo potvrzeno, že
  toto oprávnění v prozkoumané konfiguraci rolí skutečně má (viz Rizika).
- Žádný anonymní/veřejný konzument není evidován.

## Typ kontraktu

`query` (jediný `GET` endpoint; na tomto resource není implementována žádná metoda
`POST`/`PATCH`/`DELETE`).

## Poznámky k verzování

Pro `contact_resource` neexistuje žádný REST plugin, route ani config záznam s verzí `v3.1`/`v3.2`/
`v3.3` (ani jinak verzovaný) — v `config/` a v `ContactResource.php` je přítomna pouze jediná
neverzovaná varianta. Očekávání zadání úlohy sloučit varianty v3.1/v3.2/v3.3 do jednoho kontraktu **na
tento modul neplatí**; zaznamenáno zde jako mezera v evidenci, nikoli vymyšleno.

Dva další REST resources s podobnými názvy — `contact_form_resource_30` a `contact_form_resource_32`
(`config/rest.resource.contact_form_resource_30.yml`,
`config/rest.resource.contact_form_resource_32.yml`) — verzované přípony skutečně mají a povrchně
připomínají "Contact" API, ale jejich `dependencies.module` je `feedback`, nikoli `contact` (Confirmed
z bloku `dependencies:` v každém souboru). Patří do vlastního REST povrchu modulu `feedback`, nikoli do
zdroje pravdy tohoto modulu, a jsou mimo rozsah tohoto dokumentu — vlajkováno zde pouze proto, aby
instrukce ke slučování verzí nebyla tiše nesprávně aplikována na chybný modul.

## Autorizace

Confirmed, dle `config/rest.resource.contact_resource.yml` (`authentication: cookie`, `methods:
[GET]`, `formats: [json]`), ověřeno křížově proti všem souborům `config/user.role.*.yml` a
`contact.permissions.yml`:

| Endpoint | Drupal oprávnění | Uděleno |
|---|---|---|
| `GET /api/contact` | `restful get contact_resource` | **Žádná role** v prozkoumané konfiguraci (`content_admin`, `coordinator`, `front`, `fundraiser`, `manager`, `marketing`, `risk_manager`, `senior_coordinator`, `accountant`, `organisation_worker`, `patron`, `supporter`, `authenticated`, `anonymous`) tento string explicitně neuděluje — viz Rizika. |

Režim autentizace je `cookie` (aktivní back-office session Drupalu), nikoli bearer/API token.
Konstruktor `ContactResource` injektuje `current_user`, ale tělo metody `get()` nikdy nečte
`$this->currentUser` — nad rámec generické REST permission gate není v kódu vrstvena žádná další
kontrola role/oprávnění (Confirmed z kódu).

Vlastní oprávnění `contact.permissions.yml` (`search contacts`, `edit contact entities`, `add contact
entities`, `delete contact entities`, `view published/unpublished contact entities`, `administer
contact entities`) řídí HTML admin routy modulu (viz Účel) a vlastní
`ContactEntityAccessControlHandler` entity Contact — žádné z nich neřídí `/api/contact`, který je
hlídán výhradně samostatným, automaticky generovaným oprávněním `restful get contact_resource`
(Confirmed: `ContactResource.php` neprovádí žádnou kontrolu typu
`\Drupal::currentUser()->hasPermission('search contacts')` a žádný string z
`contact.permissions.yml` se v resource třídě nikde neobjevuje).

Relevantní je také to, že příznak `status` config resource je v `rest.resource.contact_resource.yml`
`true` (resource je v konfiguraci zapnutý), na rozdíl od několika sesterských REST resources v tomto
kódu, které mají `status: false`. Endpoint je tedy routovatelný, ale — vzhledem k výše uvedené mezeře
v udělení role — nepotvrzeně volatelný žádnou zdokumentovanou rolí.

## Endpoint

### `GET /api/contact` — Poznámka k předběžné kontrole rizika opakovaného žadatele

Plugin: `contact_resource` (`Drupal\contact\Plugin\rest\resource\ContactResource::get()`).

#### Požadavek

| Pole | Význam | Povinné | Poznámky |
|---|---|---:|---|
| `aprofile` (query param) | Identifikátor ApplicationProfile (`EN0002`), který se překládá na vlastnící Application | ano (funkčně) | Přetypováno na integer; pokud je `<= 0` nebo pokud na něj neodkazuje žádný řádek Application, endpoint spadne do generické chybové odpovědi (viz Chybové výstupy). Název parametru (`aprofile`) je id ApplicationProfile, nikoli id Contact, přestože endpoint žije v modulu `contact`. |

Žádné tělo požadavku; pouze `GET`. Ve třídě existuje druhá, nesouvisející mrtvá cesta kódu
(`getContacts()` — raw `LIKE` vyhledávání nad tabulkou `{contact}` klíčovanou podle
`name`/`last_name`/`phone`/`email`), ale metoda `get()` ji nikdy nevolá (její volání je zakomentováno)
— **Confirmed** mrtvý kód, není součástí živého kontraktu; dále není modelován jako endpoint.

#### Odpověď — Úspěch

| Pole | Význam | Poznámky |
|---|---|---|
| `status` | Literál `"successful"` | Vráceno pouze pokud se `aprofile` přeloží na Application (`EN0001`), která má připojenou alespoň jednu roli `ApplicationProfile`. |
| `score` | Znaménkové celočíselné heuristické skóre | Začíná na 0; přičte `+10`, pokud hodnota `patron_occupation_list` patrona rovná `0` ("zaměstnanec státní správy" dle definice pole v `ApplicationProfileEntity` — vlastní inline český komentář resource tuto možnost mylně označuje jako "sociální pracovník"; **Confirmed** nesoulad mezi komentářem v kódu a skutečným popiskem povolené hodnoty pole, zde neopravováno), vynutí `-1`, pokud `gift_payment_type` rovná `1` ("úhrada na BÚ \[bankovní účet\] žadatele"), a dále je upraveno pásmem rizika daru daného případu (`+10` za low risk přes `checkGiftRisk()` na `EN0001`, vynuceno `-1` za high risk, beze změny za medium). `-1` z kontroly typu platby nebo z kontroly rizika daru **není aditivní s předchozím kladným příspěvkem** — kód přepíše `$score` na `-1` místo odečtení, takže pozdější kladný příspěvek jej může znovu zvednout nad `-1`, pokud je vyhodnocen následně (Confirmed z literální sekvence `if ($score >= 0) $score = -1;` / `+= 10` ve zdrojovém kódu; zaznamenáno jako pozorované chování, nikoli jako zamýšlený vzorec skórování). |
| `note` | Lidsky čitelný, víceřádkový vysvětlující řetězec v češtině | Spojuje fixní zástupné řádky (`"Žadatel: Nový - není v databázi ani BL (0)"`, `"Patron: Nový - není v databázi ani BL (0)"` — **Confirmed** tyto dva řádky jsou hardcoded literály, nikoli odvozené z jakéhokoli reálného vyhledání žadatele/patrona, přestože vypadají jako výstup založený na datech) s řádky pro jednotlivé faktory popsanými pod `score` a úvodním řádkem doporučení směrování (`"V kompetenci koordinátora"`, pokud `score >= 20`, jinak `"V kompetenci risku"`). Jde o volný diagnostický text, nikoli o strukturovanou sadu polí — žádný rozklad do dílčích polí není vracen. |

Toto je užší, ad-hoc sesterská varianta strukturovaného rozkladu scoringu produkovaného automatickou
low-risk podvětví UC0003 (`FN0004`) — nečte ani nezapisuje persistovaná pole scoring/low-risk
Application a její `note`/`score` jsou počítány nově při každém volání, nejsou ukládány.

#### Chybové výstupy

| Výstup | Význam | Opakovatelné | Poznámky |
|---|---|---:|---|
| `{"status": "error"}` (HTTP 200) | `aprofile` chybí, je `<= 0`, nebo se nepřeloží na Application přes vyhledání v tabulce `application` | ano, s platným `aprofile` | **Confirmed**: HTTP stav je vždy 200 i na této in-band chybové cestě — v `get()` nikde neexistuje odpověď 4xx/5xx. |

Žádná další chybová cesta není evidována (např. žádné explicitní ošetření, pokud resolvovaná
Application vůbec nemá `ApplicationProfile` fundraisera nebo patrona — viz Rizika).

## Vedlejší efekty

- **Žádné.** Pouze pro čtení: jeden raw SQL `SELECT id FROM {application} WHERE fundraiser_profile =
  :aprofile_id OR patron_profile = :aprofile_id LIMIT 1`, následovaný čteními `ApplicationEntity::load()`
  a `getApplicationProfile()`. Žádná entita není vytvořena, upravena ani smazána; není zapsán žádný
  záznam Blacklist (`EN0016`) ani Contact (`EN0006`). Odpověď je explicitně označena jako
  nekešovatelná (`addCacheableDependency(['#cache' => ['disable' => true]])` na cestě úspěchu i chyby).

## Rizika (current-state, zdokumentováno)

- **U žádné role není potvrzeno, že má volací oprávnění.** `restful get contact_resource` není
  udělen žádné roli v prozkoumané sadě `config/user.role.*.yml`, včetně rolí, které vlastní ostatní
  admin povrchy modulu (`coordinator`, `senior_coordinator`, `risk_manager`, `manager`,
  `content_admin`, `marketing`, `front`). K endpointu se za aktuální konfigurace může dostat pouze
  role `administrator` přes svůj plošný bypass `is_admin: true`. Odpovídá stejné třídě mezery
  zdokumentované pro endpoint `scoring_visualisation_resource` v `API0012` — **Confirmed** absence
  udělení v konfiguraci; **Uncertain**, zda toto odráží skutečnou produkční mezeru v přístupu nebo
  nekompletní export konfigurace, vlajkováno k vyjasnění, nikoli vyřešeno.
- **Diagnostický text obsahuje hardcoded, nevypočtené řádky prezentované jako nálezy.** Řádky
  "Žadatel: Nový..." a "Patron: Nový..." v poli `note` jsou fixní literály vracené bezpodmínečně,
  bez ohledu na to, zda je fundraiser nebo patron skutečně nový / není na blacklistu — volající, který
  by odpověď četl jako skutečný výsledek vyhledání pro daný požadavek, by byl uveden v omyl ohledně
  toho, co bylo skutečně zkontrolováno. **Confirmed** z kódu: odpovídající skutečná vyhledání
  (`$fundraiser_email`, `$patron_email`) jsou ve zdrojovém kódu přítomna pouze jako zakomentované
  řádky, nikdy se nevykonají.
- **Komentář ke skóre mylně popisuje podkladovou volbu pole.** Inline český komentář/výstupní text
  větve `patron_occupation_list == 0` uvádí "Patron sociální pracovník", ale volba `0` pole
  `ApplicationProfileEntity::patron_occupation_list` je v definici pole ve skutečnosti označena jako
  "zaměstnanec státní správy" — jiná kategorie zaměstnání. **Confirmed** nesoulad mezi textem
  endpointu určeným pro uživatele a vlastní sémantikou pole entity; zde neopravováno v souladu s
  pravidlem evidence-first / žádné vymýšlení.
- **Žádná autorizační ani obchodní kontrola nad rámec generické REST permission gate.**
  `ContactResource` injektuje `current_user`, ale nikdy jej nevolá — neexistuje žádná kontrola
  přístupu na úrovni jednotlivé Application (např. zda je volající oprávněn zobrazit konkrétní
  resolvovanou Application/ApplicationProfile), žádné omezení frekvence a žádné auditní logování
  toho, kdo dotazoval jaký `aprofile`. Kterýkoli volající, který generické oprávnění má (nebo jej
  obchází přes `is_admin`), může iterováním query parametru prozkoumávat riziková data pro libovolné
  id `aprofile`.
- **In-band signalizace chyb s HTTP 200 v celém rozsahu.** Cesta "žádná data" i (implicitně) jakákoli
  cesta s neošetřeným vstupem vracejí HTTP 200 s polem `status` rozlišujícím úspěch/chybu — v tomto
  resource se nikde nepoužívá stav 4xx/5xx, v souladu se vzorem pozorovaným u sesterských REST
  resources v tomto kódu (např. `scoring_rest_resource` v `API0012`).

Na tento modul se nevztahují rizika typu anonymní webhook nebo payment-callback (např. hardcoded
verify tokeny, chybějící kontroly HMAC podpisu) — jediný resource vyžaduje autentizaci `cookie`
(session) a není veřejným příchozím webhookem ani platebním callbackem.

## Reference

- UC: UC0003 (Posouzení rizika žadatele / Scoring) — kanonický use case posouzení rizika, jemuž je
  ad-hoc předběžná kontrola tohoto endpointu blízká, ale který nevolá ani do něj nepersistuje; zde
  není opakováno.
- EN: EN0001 (Application — resolvována z `aprofile` a zdroj `checkGiftRisk()`), EN0002
  (ApplicationProfile — záznamy fundraisera/patrona, jejichž pole `patron_occupation_list` a
  `gift_payment_type` napájejí skóre), EN0006 (Contact — entita, kterou tento modul jinak správuje
  přes HTML admin routy, tímto endpointem nedotčená)
- FN: FN0004 (Risk Scoring & Assessment — strukturovaná scoringová schopnost, jejíž je tento
  endpoint užší, nepersistující sesterskou variantou), FN0014 (Party & Contact Management +
  Deduplication / Merge — vlastní HTML admin routy modulu zmíněné pod Účel, zde neopakováno)
- BR: BR-ScoringAndRiskGating

## Otevřené body

- HTML admin routy modulu (`contact.search_contact_form`, `entity.contact.fundraiser`,
  `entity.contact.patron`, `contact.contact_entity_revisions_controller`,
  `contact.contact_remove_duplicates`, vše v `contact.routing.yml`) jsou Drupal form/controller
  routy hlídané stringy `contact.permissions.yml` (`search contacts`, `edit contact entities`),
  nikoli REST kontrakty, takže jsou mimo rozsah tohoto API dokumentu — vlajkováno zde, aby se v
  budoucím UI/ARCH-orientovaném průchodu neztratily. Destruktivní chování deduplikace/sloučení za
  `contact.contact_remove_duplicates` je modelováno v `FN0014`, ne zde.
- Zda chybějící udělení role pro `restful get contact_resource` (viz Rizika) odráží skutečnou
  produkční sadu oprávnění nebo nekompletní export konfigurace, nelze ze zdrojů prozkoumaných pro
  tento kontrakt vyřešit. Conflict/gap — requires clarification.
- Zda je tento endpoint legacy/opuštěný scaffolding (vzhledem k zakomentovaným skutečným vyhledáním
  a nedosažitelné mrtvé cestě vyhledávání `getContacts()` ve stejné třídě), nebo aktivní, byť
  minimální back-office nástroj, není evidováno. Hypothesis — not evidenced in current sources.
- Přesná zamýšlená sémantika neaditivního přepisujícího chování `-1` u pole `score` (viz Odpověď —
  Úspěch) není evidována nad rámec literální cesty kódu; zda jde o záměrné pravidlo "jakýkoli
  jediný negativní faktor stanoví dolní hranici skóre" nebo o implementační opomenutí, zůstává
  nevyřešeno.
