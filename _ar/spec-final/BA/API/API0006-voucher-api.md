---
doc_id: API0006
title: Voucher API
layer: API
spec_type: api-contract
status: imported
modules: []
contract_type: rest-public
references:
  - UC0009
  - EN0013
  - EN0009
  - EN0004
  - FN0011
  - BR-VoucherPolicy
  - MSG0025
  - ACL0009
---

# API0006 – Voucher API

## Účel

Veřejné REST rozhraní pro validaci a uplatnění dárkového poukazu ("Dobrošek", EN0013): ověření, že
poukaz je platný a použitelný, a jeho navázání na vybraný Campaign (EN0004) tak, aby se předplacený,
zaplacený a dosud neuplatněný voucher stal aplikovaným darem. Byznysové chování vlastní UC0009 / FN0011
/ BR-VoucherPolicy; tento dokument definuje pouze kontrakt na úrovni přenosu (wire-level).

## Konzumenti

- Customer — příjemce voucheru, typicky **anonymní** (bez přihlášení); může jím být i původní
  kupující. Volá se z veřejného webového flow pro uplatnění voucheru.

## Typ kontraktu

Styl `callback` (request/response REST endpointy, nikoli webhook z externího systému) — zde zařazeno
jako `rest-public`, protože obě operace jsou otevřené anonymním volajícím.

Dvě operace:

- **Validate** — dotazovací styl: pouze čtecí kontrola použitelnosti voucheru; bez změny stavu.
- **Apply (Redeem)** — příkazový styl: měnící stav; navazuje voucher na Campaign.

---

## Endpointy

### 1. Validace voucheru (Validate Voucher)

| | |
|---|---|
| Metoda + cesta (aktuální, éra "v2.2") | `POST /api/2.2/voucher/validate` |
| Metoda + cesta (v3.2) | `POST /api/3.2/voucher/validate` |
| ID pluginu/konfigurace | `voucher_validation_resource`, `voucher_validation_resource_v32` |
| Mapuje se na | UC0009.1 — Validace voucheru |

Obě verze jsou **behaviorálně identické** — třída v3.2 je duplikátem základního resource beze
zjištěných rozdílů v request/response. Confirmed (`VoucherValidationResource.php` vs.
`v32/VoucherValidationResource.php` — identická logika).

### 2. Uplatnění voucheru (Apply / Redeem Voucher)

| | |
|---|---|
| Metoda + cesta (aktuální, éra "v2.2") | `POST /api/2.2/voucher/apply` |
| Metoda + cesta (v3.2) | `POST /api/3.2/voucher/apply` |
| ID pluginu/konfigurace | `voucher_apply_resource`, `voucher_apply_resource_v32` |
| Mapuje se na | UC0009.2 — Uplatnění (Redeem) voucheru |

**Rozdíl mezi verzemi (Confirmed):** základní (2.2) resource přijímá nepovinné pole `email` a pokud je
syntakticky platnou e-mailovou adresou, zapíše ji na voucher jako `recipient_email` ještě před
uplatněním. Resource v3.2 **pole `email`/`recipient_email` vůbec nečte ani nezapisuje** — toto pole
bylo ve v3.2 vypuštěno. Všechna ostatní vstupní pole, pořadí validací a side effecty jsou mezi oběma
verzemi identické.

V modulu neexistuje žádná třída voucher resource pro "v3.1" ani "v3.3" — jsou přítomny pouze varianty
bez suffixu ("2.2") a `v32` ("3.2"). Confirmed — ověřeno z
`web/modules/custom/voucher/src/Plugin/rest/resource/` a
`web/modules/custom/voucher/src/Plugin/rest/resource/v32/` (žádné jiné podsložky s verzí neexistují).

**Aktuálně platná verze:** obě cesty, 2.2 i 3.2, jsou zapnuté současně (obě konfigurační entity
`rest.resource.*.yml` mají `status: true`); v tomto modulu nic nenasvědčuje tomu, že by starší cesta
byla vyřazena z provozu. Kterou cestu skutečně volá současný frontend, je Unknown — nedoloženo v
rozsahu tohoto modulu.

---

## Autorizace

- Obě operace jsou dostupné roli **`anonymous`**. Confirmed —
  `config/user.role.anonymous.yml` uděluje `restful post voucher_validation_resource`,
  `restful post voucher_validation_resource_v32`, `restful post voucher_apply_resource` a
  `restful post voucher_apply_resource_v32`.
- Role **`authenticated`** má identická čtyři oprávnění (superset chování zaznamenané u ACL0009) —
  přihlášení neposkytuje ani navíc žádnou schopnost, ani žádné omezení v rámci tohoto kontraktu.
- Metoda autentizace na úrovni transportu, konfigurovaná na všech čtyřech REST resources, je `cookie`
  (konfigurace `authentication: [cookie]`) — tj. založená na session cookie, ale jelikož samotná role
  `anonymous` toto oprávnění má, k volání kterékoli z operací není ve skutečnosti potřeba žádná
  autentizovaná relace.
- V třídách resource nejsou pro žádnou z operací přítomny žádný CSRF token, žádné rate limiting ani
  žádná kontrola vlastnictví — viz Rizika.
- Širší model aktérů pro veřejné REST rozhraní, do kterého tento kontrakt spadá, viz ACL0009.

---

## Request

### 1. Validace voucheru — vstupy

| Pole | Význam | Povinné | Poznámky |
|---|---|---:|---|
| `voucher_id` | Identifikátor voucheru k ověření | ano | Přes svůj název jde o **UUID** voucheru, nikoli o jeho čitelný kód — potvrzeno z `getVoucherByUuid()`. Jde o nekonzistenci na úrovni zdrojového kódu, nikoli o chybu dokumentace. |

### 2. Uplatnění (Apply/Redeem) voucheru — vstupy

| Pole | Význam | Povinné | Poznámky |
|---|---|---:|---|
| `voucher_id` | Kód voucheru k uplatnění | ano | Přestože má stejný název pole jako u Validate, jde o **`name`** voucheru (čitelný kód), nikoli o UUID — potvrzeno z `getVoucherByName()`. Oba endpointy používají stejný název pole pro dva různé typy identifikátoru — current-state nekonzistence, nikoli chyba dokumentace. |
| `campaign_id` | Cílový Campaign (EN0004), na který se dar aplikuje | ano | Načítá se přes `CampaignEntity::load()`; pokud nenajde záznam, request selže. |
| `email` | E-mail příjemce k zápisu na voucher | ne | **pouze endpoint 2.2** — endpointem v3.2 je tiše ignorováno (viz rozdíl mezi verzemi výše). Pokud pole není syntakticky platnou e-mailovou adresou dle platformního helperu pro validitu e-mailu, je ignorováno (nejde o chybu). |

---

## Response

### Validace voucheru — úspěch

| Pole | Význam | Poznámky |
|---|---|---|
| `status` | `"valid"` nebo `"invalid"` | `"invalid"` se vrací (HTTP 200) vždy, když neexistuje voucher odpovídající vyhledání ve stavu zaplaceno-a-ještě-neuplatněno — neznámý kód, nezaplacený voucher a již uplatněný voucher se od sebe nerozlišují. |
| `voucher_code` | Čitelný kód voucheru (`name`) | přítomno pouze při `status = "valid"`. |
| `expiration` | Datum expirace ve formátu `YYYY-MM-DDT23:59:59` | přítomno pouze při `status = "valid"`; `null`, pokud voucher nemá nastavenou expiraci. |
| `price` | Hodnota daru daného voucheru | přítomno pouze při `status = "valid"`. |

### Uplatnění (Apply/Redeem) voucheru — úspěch

| Pole | Význam | Poznámky |
|---|---|---|
| `status` | `"successful"` | Vrací se pouze po uložení voucheru, přesměrování transakce (Transaction, pokud existuje) a poté, co bylo vyvoláno odeslání potvrzovacího e-mailu (viz Side Effects / UC0009.2). |

### Neúspěšné výsledky (Failure Outcomes)

Všechny neúspěšné výsledky obou operací se vrací jako **HTTP 200** s in-band příznakem stavu — tento
kontrakt nepoužívá HTTP chybové stavové kódy k signalizaci byznysového selhání. Confirmed ze
zdrojového kódu resource (každá chybová větev vytváří `ResourceResponse([...], 200)`).

| Výsledek | Význam | Opakovatelné | Poznámky |
|---|---|---:|---|
| `{"status":"invalid"}` (Validate) | Pro dané UUID nebyl nalezen žádný voucher ve stavu zaplaceno + ještě neuplatněno | ne (pokud se nezmění stav podkladového voucheru) | Zahrnuje stejně neznámé UUID, nezaplacený voucher i již uplatněný voucher — nerozlišuje se mezi nimi. |
| `{"status":"failed","error":"voucher_id is required"}` | Chybí `voucher_id` na kterémkoli z endpointů | ano, po doplnění pole | |
| `{"status":"failed","error":"campaign_id is required"}` (Apply) | Chybí `campaign_id` | ano, po doplnění pole | |
| `{"status":"failed","error":"campaign is invalid"}` (Apply) | `campaign_id` nelze přeložit na načitatelný Campaign | ano, s platným id | |
| `{"status":"failed","error":"Vámi zadaný kód nepoznáváme. Zkuste to prosím znovu."}` (Apply) | Zadanému kódu neodpovídá žádný voucher | podmíněně | Uživatelsky zobrazovaný český text je zapsaný přímo v třídě resource, nepochází z vrstev MSG/COPY — current-state provázanost, oznámeno jako riziko (hazard). |
| `{"status":"failed","error":"Vámi zadaný kód byl již uplatněn."}` (Apply) | Voucher je již uplatněný (`is_applied = 1`) | ne | Platí stejná poznámka o zapsaném textu přímo v kódu. |
| `{"status":"failed","error":"voucher is invalid"}` (Apply) | Voucher není ve stavu zaplaceno (`status = 0`) | ne, dokud není zaplaceno | |

Pro deformovanou/nevalidní JSON tělo požadavku ani pro nepodporovanou HTTP metodu neexistuje
zdokumentovaný výsledek nad rámec výchozího chování frameworku Drupal REST — Open Item.

---

## Side Effects

Pouze při úspěšném uplatnění (Apply/Redeem) (UC0009.2, kroky 5–8; vlastní UC0009/FN0011 — zde jen
odkazováno, nikoli znovu popsáno):

- Voucher (EN0013) je aktualizován: navázán na cílový Campaign, označen jako uplatněný
  (`is_applied = 1`), nastaven časový údaj uplatnění (`applied`), a — pouze u endpointu 2.2 — nastaveno
  `recipient_email`, pokud bylo dodáno platné `email`.
- Transakce (Transaction, EN0009), z níž voucher pochází (pokud je navázaná), je přesměrována na
  tentýž cílový Campaign.
- Na e-mailovou adresu z nákupní transakce je odeslán potvrzovací e-mail o uplatnění — obsah/příjemce
  viz MSG0025, včetně tam zaznamenaného current-state konfliktu v identitě příjemce. Neodesílá se při
  Validate ani při neúspěšném Apply.

Validate nemá žádné side effecty (pouze čtení), viz UC0009.1.

---

## Rizika (current-state)

Zdokumentovaná current-state rizika — přejatá z UC0009/FN0011/BR-VoucherPolicy; zde uvedena pouze pro
viditelnost na úrovni API kontraktu, nikoli znovu odvozena:

- **Otevřeno anonymním volajícím, bez rate limitingu, bez CSRF tokenu.** Obě operace jsou volatelné
  neautentizovanými klienty a v prověřovaných podkladech nebyl nalezen žádný throttling mechanismus —
  hrubosilné hádání UUID/kódů voucheru není na této vrstvě nijak zmírněno. Hypothesis — nedoloženo jako
  aktivně zneužívané, ale v prověřeném kódu žádná kontrola není přítomna. (Viz BR-VoucherPolicy,
  "Current-state rizika jedinečnosti a souběhu".)
- **Nevynucená jedinečnost kódu voucheru (`name`).** Vyhledávání `getVoucherByName()` u endpointu Apply
  se může při kolizi kódů navázat na libovolný odpovídající záznam (UC0009 AF3 / BR-VoucherPolicy).
  Partial / Hypothesis — riziko kvality dat, nikoli navržené chování.
- **Souběh check-then-update při uplatnění.** Kontrola stavu "ještě neuplatněno" a samotné uložení
  nejsou v kódu resource chráněny žádným zámkem/transakcí — dva téměř simultánní požadavky Apply na
  tentýž voucher mohou oba projít kontrolou dříve, než se kterákoli z aktualizací zapíše (UC0009 AF4 /
  BR-VoucherPolicy). Partial / Hypothesis — riziko souběhu, nikoli potvrzeně ošetřené chování.
- **Dva různé typy identifikátorů sdílí stejný název pole (`voucher_id`)** mezi oběma endpointy (UUID u
  Validate, kód/`name` u Apply) — current-state nekonzistence v pojmenování, která je reálným rizikem
  integrace pro jakéhokoli nového klienta postaveného na tomto kontraktu, pokud si nepřečte obě třídy
  resource.
- **Uživatelsky zobrazovaný chybový text je natvrdo zapsaný v třídě resource** (české texty u dvou z
  chybových větví Apply), mimo platformní vrstvy MSG/COPY — current-state provázanost mezi vrstvou API
  a prezentačním textem.
- **U žádného z endpointů není kontrola HMAC/podpisu** — v souladu s tím, že se jedná o přímá
  customer-facing REST volání, nikoli o callback partnera/platby; zaznamenáno pro úplnost, protože
  jinde v platformě mají platební-callback kontrakty stejnou mezeru bez HMAC.

---

## Odkazy (References)

- UC: UC0009 (Uplatnění / Validace voucheru)
- EN: EN0013 (Voucher), EN0009 (Transaction), EN0004 (Campaign)
- FN: FN0011 (Vystavení a uplatnění voucheru)
- BR: BR-VoucherPolicy
- MSG: MSG0025 (Potvrzení o uplatnění voucheru)
- ACL: ACL0009 (Identita, přístup a veřejné API)

---

## Otevřené body (Open Items)

- Zda front-end v produkci volá cestu "2.2" (bez suffixu), nebo "3.2" (`v32`) (případně zda jsou obě
  živé současně v produkčním provozu), je Unknown — nedoloženo v rozsahu tohoto modulu; obě jsou
  konfigurovány jako `status: true`.
- Ve zdrojovém kódu neexistuje varianta voucher resource "v3.1" ani "v3.3", ačkoli zadání úlohy
  předpokládalo tři verze — zaznamenáno jako faktické zjištění, nikoli dodatečně domyšleno.
- Chování při deformovaných tělech požadavku / nesprávné HTTP metodě je řízeno podkladovým frameworkem
  Drupal REST a nebylo trasováno nad rámec metod `post()` v resource — Open Item.
- Zda na úrovni infrastruktury mimo tento modul existuje nějaký WAF/rate-limiting, je Unknown — mimo
  rozsah review omezeného na zdrojový kód.
