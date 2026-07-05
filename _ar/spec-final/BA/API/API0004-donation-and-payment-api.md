---
doc_id: API0004
title: Donation And Payment Api
canonical_layer: API
spec_type: api-contract
status: canonical
modules: []
contract_type: rest-public
references:
  - UC0005
  - UC0006
  - EN0009
  - EN0010
  - EN0013
  - FN0007
  - FN0011
  - BR-PaymentAndMoneyIntegrity
  - BR-RecurringDonationPolicy
  - BR-VoucherPolicy
  - ES0001
---

# API0004 – Donation And Payment Api

## Účel

Veřejné REST rozhraní modulu `transaction`. Zahajuje dar nebo nákup dárkového poukazu
("Dobrošek") vytvořením `Transaction` (`EN0009`) — a v případě poukazů `Voucher`
(`EN0013`) — poté otevře relaci u platební brány a vrátí volajícímu redirect URL,
na které má být dárce přesměrován. Jde o současný vstupní bod do kapacity money hub
(`FN0007`) a v případě endpointu pro dar na kampaň i do `UC0005` (Make a Donation). Toto
rozhraní **nepotvrzuje** platbu — potvrzení platby je samostatný callback kontrakt platební brány
(`UC0006`), který patří modulům adaptéru platební brány, mimo rozsah modulu `transaction` a
tohoto dokumentu.

Ground truth: REST resource plugins pod
`web/modules/custom/transaction/src/Plugin/rest/resource/**` a
`web/modules/custom/transaction/transaction.routing.yml`, křížově ověřeno proti
`config/rest.resource.transaction_*.yml` a `config/user.role.{anonymous,authenticated,supporter}.yml`.

## Konzumenti

- Frontend Patronus (SPA) formuláře pro dar a nákup poukazu — anonymní nebo přihlášený dárce.
- Jakýkoli HTTP klient schopný dosáhnout veřejného webu (není vynucováno žádné omezení typu
  klienta — viz Authorization a Open Items).

## Typ kontraktu

`rest-public` (příkazový styl, jednosměrné create + redirect). Každý níže uvedený endpoint je
pouze `POST`, JSON na vstupu/výstupu (`formats: json`), vytvořený pomocí pluginů jádra Drupal
modulu `rest` (anotace `@RestResource`), nikoli přes vlastní routy — `transaction.routing.yml`
obsahuje pouze administrátorské HTML routy (form/controller endpointy, viz Open Items), žádné
REST cesty.

## Autorizace

Confirmed, dle `config/rest.resource.transaction_*.yml` (vše `authentication: cookie`, vše
`methods: [POST]`) křížově ověřeno proti `config/user.role.anonymous.yml` /
`user.role.authenticated.yml`:

| Endpoint | Drupal oprávnění | Uděleno |
|---|---|---|
| `POST /api/transaction` | `restful post transaction_rest_resource` | anonymous, authenticated (resource **zakázán**, viz Open Items) |
| `POST /api/3.2/transaction` | `restful post transaction_rest_resource_32` | anonymous, authenticated |
| `POST /api/2.2/voucher/buy` | `restful post transaction_voucher__rest_resource` | anonymous, authenticated |
| `POST /api/3.2/voucher/buy` | `restful post transaction_voucher__rest_resource_v32` | anonymous, authenticated |
| `POST /api/2.2/vouchers/buy` | `restful post transaction_vouchers__rest_resource` | anonymous, authenticated |

Žádný endpoint v tomto kontraktu nevyžaduje, aby byl volající přihlášen: **anonymní volání je
plně rovnocenný, plně oprávněný typ volajícího pro každý endpoint pro dar/nákup poukazu** —
autentizační plugin "cookie" pouze znamená "autentizuj relaci, pokud je přítomna session cookie",
nevynucuje autentizaci. Pokud je volající autentizovanou relací, `/api/3.2/transaction` použije
vlastní účet a e-mail relace místo pole `user_email` (viz Request). Žádný z těchto pěti endpointů
nevyžaduje ani nekontroluje CSRF token, API klíč nebo HMAC podpis — ochrana same-origin/CSRF se
spoléhá výhradně na výchozí chování Drupal výjimky `X-CSRF-Token` pro REST s autentizací `cookie`,
což samo o sobě není v tomto modulu ověřeno (Open Item).

Neexistuje samostatná brána oprávnění pro aktivaci trvalého daru vyvolanou příznakem `recurring`
v požadavku na `/api/3.2/transaction` — aktivace probíhá uvnitř téhož volání povoleného pro
anonymní/autentizované volající (viz BR-RecurringDonationPolicy pro pravidlo aktivace rozvrhu,
které tento příznak spouští).

## Endpointy

### 1. `POST /api/3.2/transaction` — Zahájení daru na kampaň (aktuální verze)

Plugin: `transaction_rest_resource_32` (`Drupal\transaction\Plugin\rest\resource\v32\TransactionResource`).
Config `status: true` (povoleno). Toto je **aktuální** verze kontraktu pro zahájení daru.

#### Request

| Pole | Význam | Povinné | Poznámky |
|---|---|---|---|
| `campaign_id` | Cílová Campaign, na kterou se daruje | ano | Musí se rozpoznat na existující Campaign; požadavek je odmítnut, pokud vybraná částka kampaně již dosahuje nebo překračuje její cíl (viz Failure Outcomes). |
| `payment_amount` | Výše daru, v jednotce ceny nezávislé na měně, kterou používá `Transaction.price` | ano | Musí být číselné. Je konvertováno na int; současný minimální práh je `1` (pouze CZK, dle hardcoded kontroly `country === 'cz'`) — pro RO/MD v tomto endpointu nebyl zjištěn žádný práh. |
| `user_email` | E-mail dárce | podmíněně povinné | Povinné pouze pokud volající **nemá** autentizovanou relaci; ignorováno (použije se e-mail relace) pokud je volající autentizován. Validováno pomocí validace e-mailu `patron_base.default`. |
| `first_name` | Jméno dárce | podmíněně povinné | Použito pouze při vytváření účtu anonymním volajícím; není validováno kromě toho, že je předáno dál. |
| `last_name` | Příjmení dárce | podmíněně povinné | Stejné jako `first_name`. |
| `recurring` | Zda nastavit trvalý měsíční dar | ne | Pravdivá hodnota aktivuje plánování trvalého daru (`BR-RecurringDonationPolicy`) souběžně s jednorázovou transakcí. |

#### Response — Success

| Pole | Význam | Poznámky |
|---|---|---|
| `status` | `"successful"` | |
| `payment_gateway_redirect_url` | URL, na které musí volající přesměrovat dárce k dokončení platby na brána zvolené podle země | Výběr platební brány (ComGate / MAIB / Netopia) je řízen konfigurací země, nikoli volitelný volajícím; samotné kontrakty platebních bran jsou mimo rozsah tohoto dokumentu (viz `ES0001` pro ComGate). |
| `user_id` | UUID účtu dárce | Vyplněno pouze pokud je rozpoznaný/vytvořený uživatelský účet aktuálně blokovaný; jinak `null`. Účel poskytování této hodnoty volajícímu nebyl zjištěn (Open Item). |

Response je explicitně označen jako necachovatelný (`#cache: false`).

#### Failure Outcomes

| Výsledek | Význam | Opakovatelné | Poznámky |
|---|---|---|---|
| `payment_amount validation error` (HTTP 400) | `payment_amount` chybí/není číselné | ano | |
| `Campaign doesn't exist` (HTTP 400) | `campaign_id` se nerozpozná na Campaign | ano, s opraveným id | |
| `Campaign is completed` (HTTP 400) | Vybraná částka kampaně je již na/nad jejím cílem | ne | Podmínka obchodního uzávěru, nikoli chyba dat. |
| `Email validation error` (HTTP 400) | `user_email` chybí/je neplatný u anonymního volání | ano | |
| `Comgate error` (HTTP 500) | Vytvoření relace u brány se nezdařilo (pouze cesta ComGate) | ano | **Zdokumentováno, ale pravděpodobně nedosažitelné**: chybová odpověď je sestavena uvnitř privátní pomocné metody a není propagována volajícímu — viz Hazards. Považovat za zamýšlený kontrakt, nikoli potvrzené aktuální chování. Cesty kódu pro MAIB a Netopia při selhání volání brány nevracejí žádnou strukturovanou chybovou odpověď. |

Všechna chybová těla používají `{"status": "failed", "error": "<message>"}`.

### 2. `POST /api/transaction` — Zahájení daru na kampaň (nahrazeno)

Plugin: `transaction_rest_resource` (`Drupal\transaction\Plugin\rest\resource\TransactionResource`,
neverzovaný namespace). Config `status: false` — **REST resource je zakázán**; route
aktuálně neobsluhuje provoz. Implementující metoda `post()` je stub, který ignoruje svůj
vstup a vždy vrací prázdný `ResourceResponse([])`; neprovádí žádnou persistenci a nemá žádný
skutečný request/response kontrakt. Zaznamenáno pouze pro úplnost — neuvažovat jako funkční v1
souběžně s v3.2.

### 3. `POST /api/2.2/voucher/buy` a `POST /api/3.2/voucher/buy` — Nákup jednoho poukazu

Pluginy: `transaction_voucher__rest_resource` (neverzovaná/"2.2" cesta) a
`transaction_voucher__rest_resource_v32` (namespace `v32`, cesta `/api/3.2/voucher/buy`). Obě
konfigurační položky jsou `status: true` (obě povoleny) a obě implementace jsou bit-přesně
shodné až na jeden rozdíl v sanitizaci vstupu uvedený níže — jsou zde sloučeny do jednoho
kontraktu podle instrukce pro sloučení verzí, přičemž jako aktuální je zaznamenána cesta v3.2.

#### Request

| Pole | Význam | Povinné | Poznámky |
|---|---|---|---|
| `user_email` | E-mail kupujícího | ano | Validováno pomocí `patron_base.default`; použito k vyhledání nebo vytvoření účtu kupujícího (role `supporter`). |
| `first_name` | Jméno kupujícího | podmíněně povinné | Použito pouze při vytváření účtu. |
| `last_name` | Příjmení kupujícího | podmíněně povinné | Použito pouze při vytváření účtu. |
| `payment_amount` | Nominální hodnota poukazu | ano | Musí být číselné; pokud je nižší, je zaokrouhleno nahoru na `100` (minor unit). |
| `user_phone` | Telefon kupujícího | ne | Předáno do entity Voucher. |
| `recipient_name` | Jméno příjemce daru | ne | |
| `recipient_email` | E-mail příjemce | ne | |
| `recipient_message` | Osobní zpráva příjemci | ne | |

Typ doručení není volitelný volajícím: aktuální kód vždy nastavuje `delivery_type = 'email'`.

**Rozdíl mezi verzemi (v3.2, `/api/3.2/voucher/buy`):** neverzovaný resource zachází s
`user_phone`/`recipient_name`/`recipient_email`/`recipient_message` jako s volitelnými (fallback
`?? null`); implementace `v32` čte stejné klíče bez fallbacku na null-coalescing, takže požadavek,
který jeden z těchto klíčů vynechá, vyvolá u této varianty PHP notice/undefined-index warning
místo výchozího nastavení na `null` (Confirmed z diffu kódu; dopad na chování HTTP response
nebyl zjištěn — Open Item).

#### Response — Success

| Pole | Význam | Poznámky |
|---|---|---|
| `status` | `"successful"` | |
| `payment_gateway_redirect_url` | Redirect URL ComGate k dokončení platby za poukaz | Nákup poukazu je hardcoded na ComGate/CZK bez ohledu na konfiguraci země webu (Confirmed z kódu — žádná větev podle země, na rozdíl od `/api/3.2/transaction`). |

#### Failure Outcomes

| Výsledek | Význam | Opakovatelné | Poznámky |
|---|---|---|---|
| `Email validation error` (HTTP 200) | `user_email` chybí/je neplatný | ano | Vráceno s HTTP 200, nikoli 4xx — selhání je signalizováno pouze uvnitř těla odpovědi (`status: "failed"`). |
| `payment_amount validation error` (HTTP 200) | `payment_amount` není číselné | ano | Stejný vzor signalizace pouze uvnitř těla odpovědi. |
| `Voucher validation` (HTTP 200) | Entita Voucher neprošla validací polí (porušení omezení) | ano | Detaily porušení jsou logovány do Slacku (`logger.slack`), nejsou vráceny volajícímu. |
| `Comgate error` (HTTP 200) | Vytvoření transakce u brány vyvolalo výjimku | ano | |

Poznámka: celá tato skupina endpointů pro poukazy vrací HTTP 200 pro úspěch i selhání,
výsledky se rozlišují pouze polem `status` v těle — na rozdíl od `/api/3.2/transaction`, který
pro selhání používá 400/500.

### 4. `POST /api/2.2/vouchers/buy` — Nákup košíku poukazů s více nominálními hodnotami

Plugin: `transaction_vouchers__rest_resource`
(`Drupal\transaction\Plugin\rest\resource\TransactionVouchersResource`). Config `status: true`.
Pro tuto cestu s více poukazy neexistuje v tomto modulu žádný `v32`/verzovaný protějšek
(Confirmed — nepředpokládat jeho existenci).

#### Request

| Pole | Význam | Povinné | Poznámky |
|---|---|---|---|
| `user_email` | E-mail kupujícího | ano | Stejná validace jako u endpointů pro jeden poukaz. |
| `first_name` | Jméno kupujícího | podmíněně povinné | |
| `last_name` | Příjmení kupujícího | podmíněně povinné | |
| `vouchers` | Mapa `{denomination: quantity}` | ano | Celková cena je součet `denomination × quantity` přes položky s `quantity > 0`; musí činit celkem ≥ 100 (minor unit). |
| `payment_type` | `"bank"` vybírá offline/manuální objednávku; jakákoli jiná hodnota (nebo její absence) vybírá online platbu kartou | ne | Rozděluje celý požadavek na dva vzájemně se vylučující toky (viz níže). |
| `invoice` | Volný text fakturačních/firemních údajů pro offline firemní objednávku | ne | Čteno pouze při sestavování notifikačního e-mailu pro offline objednávku; není validováno ani persistováno jako strukturovaná data. |

#### Response — Success

| Pole | Význam | Poznámky |
|---|---|---|
| `status` | `"successful"` | Stejná hodnota pro online i offline (`payment_type: bank`) větev. |
| `payment_gateway_redirect_url` | Redirect URL ComGate | **Přítomno pouze v online větvi.** Offline (`bank`) větev vrací jen `{"status": "successful"}` bez redirect URL — plnění je manuální (je odeslán interní e-mail s objednávkou; pro offline větev se nevytváří žádná entita Transaction/Voucher, viz Side Effects). |

#### Failure Outcomes

| Výsledek | Význam | Opakovatelné | Poznámky |
|---|---|---|---|
| `Email validation error` (HTTP 200) | `user_email` chybí/je neplatný | ano | Selhání signalizováno pouze uvnitř těla odpovědi, HTTP 200. |
| `payment_amount validation error` (HTTP 200) | Vypočtený celkový součet košíku není číselný nebo `< 100` | ano | Název zprávy je zděděn ze znění endpointů pro jeden poukaz, přestože tento endpoint pole `payment_amount` vůbec nemá — validuje odvozený součet `vouchers`. |
| `Comgate error` (HTTP 200) | Vytvoření transakce u brány vyvolalo výjimku (pouze online větev) | ano | |

## Side Effects

- **Každé úspěšné volání `/api/3.2/transaction`** vytvoří jednu `Transaction` (`EN0009`) ve stavu
  `PENDING` `ext_status`, propojenou s rozpoznaným dárcem `User` a cílovou `Campaign`; může také
  vytvořit řádek plánu `RecurringTransaction` (`EN0010`), pokud je `recurring` pravdivé
  (`BR-RecurringDonationPolicy`). Může vyhledat nebo vytvořit účet `User`/dárce a udělit mu
  roli `supporter` (`FN0007`, `FN0011` vzor money-hub / udělení role).
- **Každé úspěšné volání pro jeden poukaz** (`/api/2.2/voucher/buy`, `/api/3.2/voucher/buy`)
  vytvoří jednu `Transaction` (`is_voucher = 1`, `PENDING`) a jeden `Voucher` (`EN0013`,
  `BR-VoucherPolicy`) a může vyhledat nebo vytvořit účet `User` kupujícího.
- **Online větev `/api/2.2/vouchers/buy`** vytvoří jednu `Transaction` (`is_voucher = 1`,
  `PENDING`, `vouchers_data` naplněno syrovým payloadem požadavku), ale — na rozdíl od
  endpointů pro jeden poukaz — nevytváří **žádnou** entitu `Voucher` v okamžiku požadavku
  (Confirmed z kódu: na této cestě žádné volání `VoucherEntity::create`; vydávání poukazů
  pro košík s více nominálními hodnotami v tomto modulu nebylo zjištěno).
- **Offline (`payment_type: bank`) větev `/api/2.2/vouchers/buy`** nevytváří **žádnou**
  `Transaction` a **žádný** `Voucher`; jediným efektem je odchozí notifikační e-mail o objednávce
  (`patron_base.smartmailing`) na interní adresu. Tato větev je požadavkem na manuální objednávku,
  nikoli platbou.
- Všechny online větve otevírají relaci u externí platební brány (ComGate pro poukazy a
  CZ dary; MAIB/Netopia pro dary MD/RO přes `/api/3.2/transaction`) a zapisují id transakce
  brány zpět do `Transaction` (`ext_trans_id`). Potvrzení platby ze strany brány (přechod
  `ext_status` na `PAID`/`CANCELLED`) je samostatný kontrakt (`UC0006`), mimo rozsah tohoto
  dokumentu.
- Interní notifikační e-mail o objednávce (`sendOrderEmail`, přes `patron_base.smartmailing`) je
  odesílán **pouze** z `/api/2.2/vouchers/buy` (jak jeho online, tak offline větví). Endpointy
  pro jeden poukaz (`/api/2.2/voucher/buy`, `/api/3.2/voucher/buy`) tento e-mail **ne**odesílají
  (Confirmed: v `TransactionVoucherResource::post()` žádné takové volání není); jejich jediným
  odchozím efektem je samo vytvoření relace u brány.

## Hazards (aktuální stav, zdokumentováno)

- **Žádná verifikace signature/HMAC/CSRF u žádného z těchto pěti endpointů pro vytvoření
  transakce.** Autorizace je "anonymní nebo autentizovaný, session cookie volitelná" — neexistuje
  důkaz vlastnictví, API klíč ani schéma podepisování požadavků, které by odlišilo skutečné volání
  z frontendu od jakéhokoli skriptovaného POST. V kombinaci s automatickým vytvářením účtů
  (`account.register`) pro nerozpoznané e-maily to umožňuje neautentizované, vysokoobjemové
  vytváření účtů a nevyřízených `Transaction`.
- **Signalizace selhání pouze uvnitř těla odpovědi s HTTP 200** u všech endpointů pro poukazy
  maskuje selhání před obecným monitorováním/retry na úrovni HTTP — od úspěchu selhání
  rozlišuje jen pole `status` v těle.
- **Offline (`bank`) větev endpointu pro košík poukazů nepersistuje nic**: útočník nebo chybný
  klient může vyvolat neomezené množství interních notifikačních e-mailů o objednávce s
  útočníkem dodaným obsahem `invoice`/`vouchers` (vykresleno do HTML tabulky pomocí
  `Html::escape`, tedy nejde o vektor XSS, ale jde o neautentizovanou plochu pro zaplavení
  e-mailem) bez odpovídající entity, vůči které by šlo auditovat nebo omezovat frekvenci.
- **Práh minimální částky podle země je nekonzistentní a částečně hardcoded:**
  `/api/3.2/transaction` zaokrouhluje nahoru na `1` pouze pokud `Settings::get('country') === 'cz'`
  (kontrola literálního řetězce), pro `ro`/`md` nebyl zjištěn žádný práh; endpointy pro poukazy
  naopak hardcodují plochý práh `100` jednotek bez ohledu na zemi. Napříč těmito endpointy
  neexistuje žádná sdílená politika minimální částky (Open Item — viz
  `BR-PaymentAndMoneyIntegrity` pro širší pravidlo integrity peněz, pod které tato oblast patří).
- **Zpracování selhání brány je napříč endpointy nekonzistentní:** větev ComGate v
  `/api/3.2/transaction` vrací strukturované selhání `Comgate error`, ale větev MAIB pokračuje
  pouze pokud `$maib_response` vypadá dobře formovaně (jinak tiše zanechá Transaction ve stavu
  `PENDING` bez `ext_trans_id`) a její větev Netopia nikdy neověřuje odpověď před zápisem
  `PENDING` a sestavením redirect URL — pro selhání brány MAIB/Netopia na tomto endpointu
  nebyl zjištěn žádný důkaz negativní cesty (Open Item / Hypothesis).
- **Větev ComGate (`paymentComgateTransaction`) v `transaction_rest_resource_32` čte
  `$price`, `$campaign_name`, `$user_email`, `$embedded`, `$initRecurring` a `$data`**, přičemž
  žádná z těchto proměnných není parametrem ani vlastností třídy této privátní metody — existují
  pouze jako lokální proměnné uvnitř volající metody `post()`. Toto je Confirmed z kódu (nejde o
  pole payloadu, které by tento kontrakt mohl slibovat). Přinejmenším to vede k warningům o
  nedefinovaných proměnných; na cestě selhání to také znamená, že `ResourceResponse(..., 500)`
  pro `Comgate error` sestavená uvnitř bloku `catch` metody je `return`ována z
  `paymentComgateTransaction()` (místo volání typu `void`) a zahozena — `post()` ji nikdy
  neuvidí a vždy propadne k sestavení vlastní odpovědi `'successful'`. **Čistý efekt: pro
  selhání vytvoření transakce ComGate na `/api/3.2/transaction` nebyl zjištěn důkaz, že by
  vůbec vytvořilo dokumentovanou chybovou odpověď `Comgate error`** — endpoint s největší
  pravděpodobností stále vrací `status: "successful"` se zastaralým/prázdným
  `payment_gateway_redirect_url`. Označeno jako hazard aktuálního stavu, zde neopravováno
  (runtime ověření je mimo rozsah této statické fáze dle Runtime-truth-policy).

## References

- UC: UC0005 (Make a Donation), UC0006 (Confirm Payment — Gateway Callback; vlastní stranu
  potvrzení životního cyklu, který tento kontrakt pouze zahajuje)
- EN: EN0009 (Transaction), EN0010 (RecurringTransaction), EN0013 (Voucher)
- FN: FN0007 (Donation & Payment Processing — Money Hub), FN0011 (Voucher Issuance & Redemption)
- BR: BR-PaymentAndMoneyIntegrity, BR-RecurringDonationPolicy, BR-VoucherPolicy
- ES: ES0001 (ComGate) — kontrakt na straně brány pro cíl redirectu; kontrakty bran MAIB/Netopia
  nejsou zatím přítomny pod `_ar/spec-draft/ES/` pro tyto dva konkrétní adaptéry pod tímto
  jménem (pod ES0001–ES0003 jsou uvedeny pouze ComGate, Netopia/MobilPay a Maib — Netopia je
  `ES0002`, Maib je `ES0003`; oba jsou zde uváděny pouze jako kontext na straně brány, nikoli
  přeformulovány).

## Open Items

- `transaction.routing.yml` definuje pouze administrátorské/back-office HTML routy
  (`transaction/result`, `transaction/remove-transparent/{id}`,
  `transaction/{id}/update-type/{type}`, administrátorský formulář pro rozdělení transakce)
  chráněné pomocí `access content` / `edit transaction entities` — jde o interní
  back-office/redirect utility routy, nikoli o součást tohoto veřejného API kontraktu, a nejsou
  zde dokumentovány. Route `transaction/result` je konkrétně přistávací stránka, na kterou se
  vrací prohlížeč dárce (čte query parametry `refId`/`id`, žádná mutace, žádná kontrola podpisu)
  — uvedeno pro úplnost, ale mimo rozsah příkazového kontraktu "donation and payment"; patřilo
  by do samostatného callback/utility kontraktu, pokud by na něj byla rozšířena uzavírací práce.
- `POST /api/transaction` (zakázán, stub `post()`) je výše zaznamenán pouze pro dohledatelnost;
  nemá se počítat jako živý endpoint v žádném soupisu endpointů odvozeném z tohoto dokumentu.
- Zda je `user_id` (UUID, pouze pro blokovaného uživatele) v úspěšné odpovědi
  `/api/3.2/transaction` konzumován frontendem pro konkrétní účel (např. spuštění toku pro
  opětovné zaslání aktivačního e-mailu), nebylo v tomto modulu zjištěno.
- Skutečné kontrakty callbacku/IPN platební brány (server-to-server potvrzení platby
  ComGate/MAIB/Netopia a jakékoli HMAC/podpisové schéma, které používají nebo nepoužívají) žijí
  v modulech `comgate`, `maib` a `netopia`, nikoli v `transaction` — mimo rozsah ground truth
  tohoto dokumentu. `FLOW-candidates.md` (FL021–FL023) již na úrovni flow označuje chybějící
  idempotenci callbacku jako otevřenou záležitost; vyhrazený API kontrakt pro tyto callback
  endpointy, pokud bude syntetizován, by měl tento hazard vlastnit místo tohoto dokumentu.
- Hazard anonymního webhooku s hardcoded verify tokenem v modulu `facebook_leads` uvedený v
  zadání tohoto úkolu patří jinému modulu
  (`rest.resource.facebook_lead_webhook_resource*` / `facebook_leads_facebook`) a není součástí
  ground truth modulu `transaction` — v tomto kontraktu nedokumentováno; zde uvedeno pouze proto,
  aby nebylo tiše vynecháno ze backlogu uzavírací fáze.
