---
doc_id: API0005
title: RecurringDonationApi
canonical_layer: API
spec_type: api-contract
status: canonical
modules: []
contract_type: rest-public
references:
  - UC0007
  - EN0010
  - EN0009
  - FN0010
  - BR-RecurringDonationPolicy
---

# API0005 – RecurringDonationApi

## Účel

Umožňuje autentizovanému dárci zrušit svůj vlastní aktivní plán/plány trvalého daru (EN0010) z webového
front-endu. Jde o programový protějšek flow "zrušit trvalou platbu" na webu
(`transaction_recurring.cancel_form` / `CancelForm`) — stejný efekt, vystavený jako JSON REST endpoint
pro AJAX/API volání z front-endu.

Confirmed: modul `transaction_recurring` definuje přesně jeden systémový HTTP endpoint. Žádný
endpoint pro výpis, vytvoření, úpravu nebo čtení plánů trvalého daru není vystaven jako REST resource
v tomto modulu — vytváření/čtení plánu probíhá jinými flow (UC0005 Make a Donation,
UC0006 Confirm Payment), nikoli přes toto API.

## Poznámka k verzování (korekce vůči předpokládanému rozsahu)

Confirmed: tento modul neobsahuje **žádný důkaz o verzovaných variantách** (žádné segmenty cesty
`v3.1`/`v3.2`/`v3.3`, žádná logika pro negociaci verze, žádné vícenásobné resource pluginy ani
generace routování). Prohledání `src/Plugin/rest/`, `transaction_recurring.routing.yml` a exportu
REST konfigurace modulu odhalilo jediný, neverzovaný resource plugin
(`transaction_recurring_cancel_resource`) na jediné cestě (`/api/transaction_recurring/cancel`).
Tento kontrakt dokumentuje tuto jedinou aktuální verzi; rámec "v3.1/v3.2/v3.3" dodaný v rozsahu
zadání **není pro tento modul doložen** a níže se nepromítá — viz Otevřené body.

## Konzumenti

- Supporter (autentizovaný dárce) — front-endové UI účtu/přehledu dárce, které volá tento endpoint
  přes AJAX, když dárce zruší svou trvalou platbu (odpovídá `CancelForm`).

## Typ kontraktu

Command (měnící stav). Není to query, není to callback, není to partnerská/webhooková utilita.

## Autorizace

- Confirmed — pouze relace založená na session (Drupal cookie authentication):
  `rest.resource.transaction_recurring_cancel_resource.yml` deklaruje `authentication: [cookie]`,
  `methods: [POST]`, `formats: [json]`.
- Confirmed — volání podmiňují dvě oprávnění, obě udělená pouze roli `supporter`:
  - `restful post transaction_recurring_cancel_resource` (technické REST-resource oprávnění)
  - `cancel own recurring transaction` (business oprávnění kontrolované routou HTML formulářového
    protějšku; samotný REST resource neprovádí žádnou explicitní kontrolu přístupu nad rámec
    oprávnění `restful post ...` — viz Otevřené body).
- Confirmed — žádné pole requestu neidentifikuje, který plán se má zrušit; autorizace je implicitně
  omezena na "vlastní data volajícího" vyhledáním transakcí podle ID aktuálního uživatele v session
  (služba `current_user`), nikoli podle parametru actor/tenant.
- Zdroj: `config/rest.resource.transaction_recurring_cancel_resource.yml`,
  `web/modules/custom/transaction_recurring/transaction_recurring.permissions.yml`,
  `config/user.role.supporter.yml`.

## Request

`POST /api/transaction_recurring/cancel`

Formát: `json`.

### Vstupy

| Pole | Význam | Povinné | Poznámky |
|---|---|---:|---|
| *(žádné)* | — | — | Confirmed: metoda `post($data)` resource přijímá parametr request body, ale nikdy z něj nečte žádné pole. Cíl zrušení se odvozuje výhradně na straně serveru z ID uživatele autentizované session, nikoli z payloadu requestu. |

## Response

Formát: `json`. Confirmed: resource vždy vrací HTTP 200, bez ohledu na business výsledek
(úspěch, no-op nebo "nic ke zrušení"); business výsledek je nesen pouze v poli `status` —
viz riziko níže.

### Úspěch

| Pole | Význam | Poznámky |
|---|---|---|
| `status` | `"success"` | Confirmed. Vráceno, jakmile byla nalezena a aktualizována alespoň jedna odpovídající RecurringTransaction (EN0010). |

### Výsledky selhání

| Výsledek | Význam | Opakovatelné | Poznámky |
|---|---:|---:|---|
| `status: "failed"`, `error: "missing transactions for this user"` | Aktuální uživatel nemá žádné záznamy Transaction (EN0009). | ne | HTTP 200, nikoli 4xx/5xx — viz riziko níže. |
| `status: "failed"`, `error: "missing recurring transactions for this user"` | Aktuální uživatel má Transactions, ale žádná z nich nemá navázanou RecurringTransaction (EN0010). | ne | HTTP 200, nikoli 4xx/5xx — viz riziko níže. |
| Neautentizovaný / neautorizovaný request | Volající nemá oprávnění `restful post transaction_recurring_cancel_resource` (tj. není `supporter` nebo není přihlášen). | ne | Ošetřeno Drupal REST/permission vrstvou dříve, než dojde k `post()`; nejde o business tělo odpovědi — standardní chování REST access-denied, v kódu tohoto modulu nedoloženo. |

## Vedlejší efekty

- Aktualizuje každou RecurringTransaction (EN0010) navázanou — přes svou referenci `transaction_id` —
  na jakoukoli Transaction (EN0009) vlastněnou volajícím uživatelem: nastaví `canceled` na aktuální čas
  a `status` (příznak publikováno/aktivní) na `0`. Viz EN0010, BR-RecurringDonationPolicy.
- Confirmed: toto jedním voláním zruší **všechny** plány trvalého daru volajícího — neexistuje cílení
  na jednotlivý plán. Dárce s více aktivními plány trvalého daru nemůže přes tento endpoint zrušit
  jen jeden z nich.
- Confirmed: na rozdíl od HTML formulářového protějšku (`CancelForm::submitForm`) tento REST resource
  **ne**invaliduje cache Views `fundraisers_applications` / `donations` po zrušení. Dárce, který zruší
  přes tuto cestu API, může v UI prvcích napojených na tyto cachované Views stále vidět zastaralý stav
  "aktivní trvalý dar", dokud nejsou invalidovány jinak.
- V kódové cestě tohoto endpointu není doložen žádný vedlejší efekt typu zpráva/notifikace (srovnej s
  notifikacemi po platbě v UC0007, které se zrušení netýkají).

## Rizika — current-state (neopravovat; zaznamenáno pro potřeby rebuildu)

- **Business selhání signalizováno jako HTTP 200.** Obě větve selhání vracejí HTTP 200 s
  `status: "failed"` v těle odpovědi místo stavového kódu 4xx. Volající, který kontroluje pouze HTTP
  status (běžné výchozí chování REST klienta), bude "nic ke zrušení" považovat za úspěch.
- **Neparametrizovaná interpolace SQL řetězce.** `post()` sestavuje druhý dotaz pomocí
  `implode("','", $transactionIds)` přímo do SQL řetězce
  (`select id from transaction_recurring where transaction_id in ('...')`) místo vázaných zástupných
  symbolů, přestože první dotaz (získání `$transactionIds`) je sám o sobě řádně parametrizovaný.
  Interpolované hodnoty pocházejí z databáze (předchozí `SELECT id`), nikoli přímo ze vstupu klienta,
  takže dnes nejde o přímo zneužitelný bod injekce — jde ale o rizikový kódový vzor (jakákoli budoucí
  změna, která by umožnila, aby `$transactionIds` obsahovalo hodnoty ovlivněné klientem, by se stala
  zneužitelnou). Zdroj: `TransactionRecurringCancelResource::post()`, řádek s interpolací
  `$transactionIds`.
- **Zrušení vše-nebo-nic bez selektoru cíle.** Viz Vedlejší efekty — dárce nemůže přes tento endpoint
  zrušit jeden z několika plánů trvalého daru samostatně; pouze prostřednictvím totožného chování
  vše-nebo-nic HTML `CancelForm`.
- **V konfiguraci tohoto modulu není deklarován žádný mechanismus CSRF/anti-forgery.** REST konfigurace
  omezuje autentizaci na `cookie`, ale samotný soubor
  `rest.resource.transaction_recurring_cancel_resource.yml` nedeklaruje žádný explicitní požadavek CSRF;
  zda je pro tuto routu aktivní vynucování CSRF jádrového Drupal REST cookie-auth, je chování na úrovni
  platformy (nikoli modulu) — z důkazů samotného tohoto modulu nepotvrzeno. Viz Otevřené body.
- **Uvnitř `post()` neexistuje žádná dedikovaná kontrola přístupu.** Autorizace se spoléhá zcela na to,
  že oprávnění `restful post transaction_recurring_cancel_resource` má pouze role supporter; samotná
  metoda resource neobsahuje žádnou další kontrolu vlastnictví/role (nepotřebuje ji, protože pracuje
  vždy jen s daty vlastněnými `$this->currentUser->id()` — to však také znamená, že zde není žádná
  hloubková obrana, pokud by bylo oprávnění někdy chybně nakonfigurováno na jinou roli).

## Reference

- UC: UC0007 (Process Recurring Donation — životní cyklus plánu, který tento endpoint ukončuje)
- EN: EN0010 (RecurringTransaction — měněná entita), EN0009 (Transaction — použita pouze k vyhledání
  vlastních plánů trvalého daru volajícího)
- FN: FN0010 (Recurring Donation Scheduling & Charging — vlastnící capability)
- BR: BR-RecurringDonationPolicy (sémantika zrušení; zaznamenává tutéž nejistotu ohledně "efektu
  zrušení na stav Activation" uvedenou níže)

## Otevřené body

- Předpoklad na úrovni zadání ohledně verzovaných variant `v3.1`/`v3.2`/`v3.3` **není doložen** v REST
  pluginu, routování ani konfiguraci modulu `transaction_recurring`. Pokud takové verzování existuje,
  musí se nacházet v jiném modulu/routě nekrytém zdrojovým kódem tohoto modulu — vlajkuje se jako
  bod k vyjasnění, nikoli aby zde byly vymyšleny verzové rozdíly.
- Zda zrušení (timestamp `canceled` + `status = 0`) také přepíná stav Activation plánu podle otevřené
  otázky č. 1 samotné EN0010, zůstává na úrovni entity nevyřešeno; tento kontrakt potvrzuje pouze dva
  zápisy polí provedené `post()`, nikoli jejich plný význam v životním cyklu.
- Zda se na tuto routu za běhu vztahuje požadavek jádrového Drupal REST/cookie-auth CSRF tokenu
  (`X-CSRF-Token`), není z konfigurace samotného tohoto modulu potvrzeno — závisí na chování
  jádrového/contrib REST modulu mimo vlastní kód `transaction_recurring`, což je mimo rozsah důkazů
  tohoto modulu.
- REST resource přijímá parametr request body `$data`, který nikdy není použit. Zda jde o mrtvý
  parametrický povrch (bezpečné odstranit), nebo o zástupný prvek pro ještě neimplementovanou funkci
  cíleného zrušení, není doloženo — pouze Hypothesis.
