---
doc_id: API0007
title: Donation Confirmation Tax API
layer: API
spec_type: api-contract
status: imported
modules: []
contract_type: rest-public
references:
  - UC0010
  - EN0014
  - EN0008
  - EN0009
  - EN0022
  - FN0013
  - BR-DonationConfirmationAndTax
---

# API0007 – Donation Confirmation Tax API

## Účel

Umožnit Customerovi vyžádat si oficiální CZ potvrzení o daru (daňové potvrzení, "Potvrzení o daru")
za daný rok. Kontrakt vypočítá celkovou uhrazenou částku darů žadatele za daný rok, uloží snapshot
DonationConfirmation (EN0014), vyrenderuje jej do PDF a odešle e-mailem — jde o API realizaci UC0010
(Issue Donation Confirmation (Tax)).

## Konzumenti

- **Customer** — anonymní nebo přihlášený volající, přes veřejný web/SPA kanál (UC0010.3).

## Typ kontraktu

`rest-public` — jedna business schopnost (vyžádání daňového potvrzení) exponovaná jako **dva
souběžně živé verzované REST endpointy**. Obě verze v současnosti přijímají požadavky; mezi nimi
neexistuje žádné routovací přesměrování ani content negotiation a nic nenasvědčuje tomu, že by starší
verze byla vyřazena nebo přesměrována. Tento dokument slučuje obě verze do jednoho kontraktu a
poznamenává rozdíl mezi verzemi.

| Verze | Path | Stav | Zdroj |
|---|---|---|---|
| v3.1 | `POST /api/3.1/donation_confirmation` | Confirmed — live | plugin `donation_confirmation_resource_v31` |
| v3.2 | `POST /api/3.2/donation_confirmation` | Confirmed — live, current | plugin `donation_confirmation_resource_v32` |

Varianta v3.3 tohoto resource v aktuálním zdrojovém kódu neexistuje (na rozdíl od některých sesterských
REST resources ve stejné modulové rodině, které v3.3 mají). Pro novou integrační práci považujte v3.2
za aktuální verzi; v3.1 zůstává dosažitelná a v konfiguraci není nikde označena jako deprecated.

## Autorizace

- **Mechanismus:** Drupal core REST, autentizace na bázi cookie (`authentication: [cookie]` v obou
  konfiguracích resource). Pro tento resource není nakonfigurována žádná token/API-key autentizace.
- **Metoda:** pouze `POST`, pouze formát `json`, u obou verzí (`configuration.methods: [POST]`,
  `configuration.formats: [json]`).
- **Přidělení rolí (confirmed):** oprávnění `restful post donation_confirmation_resource_v31` a
  `restful post donation_confirmation_resource_v32` jsou obě přidělena rolím **anonymous** a
  **authenticated** (`user.role.anonymous.yml`, `user.role.authenticated.yml`). Nad rámec těchto
  oprávnění na úrovni REST metody není vyžadováno žádné další oprávnění — v metodě `post()` žádného
  z obou resources neexistuje kontrola přístupu na úrovni entity.
- **Session je nepovinná, nikoli vyžadovaná:** v3.1 vždy resolvuje cílového uživatele z polí payloadu
  požadavku (`user_id` UUID nebo `email`), bez ohledu na to, zda existuje session. v3.2 preferuje
  aktuální přihlášenou session (`$this->currentUser->isAuthenticated()`) a na `email` z payloadu se
  vrací pouze tehdy, pokud žádná session není přihlášena.
- **Riziko — anonymní, neautentizované vystavení pro libovolné dárce (Confirmed):** protože oprávnění
  `restful post` je přiděleno roli anonymous a žádná z verzí neprovádí kontrolu vlastnictví/ACL, která
  by resolvovaného uživatele vázala na volajícího, může jakýkoli neautentizovaný volající, který
  zadá platný `email` dárce (nebo u v3.1 UUID dárce), vyvolat vystavení daňového potvrzení tohoto
  dárce — včetně PDF obsahujícího jméno dárce, adresu a české rodné číslo (`rodne_cislo`), zaslaného
  e-mailem na jakoukoli hodnotu `email` uvedenou v požadavku (nikoli nutně na registrovaný e-mail
  daného účtu). Jde o current-state riziko úniku dat a zneužití e-mailového odesílání jako relaye,
  nikoli o hypotetické riziko — vyplývá přímo z přidělení oprávnění a absence kontroly vlastníka
  v `post()`.
- **Není nakonfigurován žádný požadavek na CSRF token** nad rámec standardní CSRF ochrany REST v
  Drupal core pro cookie-auth (hlavička `X-CSRF-Token` získaná z `/session/token`); v konfiguraci
  tohoto modulu nebyl nalezen žádný modulově specifický override ani bypass. Není označeno jako
  riziko nad rámec standardního chování platformy.
- **Není přítomen žádný rate limiting ani throttling** v žádné z tříd resource ani v jejich
  konfiguraci — opakovaná volání jsou neomezená (viz Side Effects / AF3 v UC0010).

## Požadavek

### Vstupy — v3.1 (`POST /api/3.1/donation_confirmation`)

| Pole | Význam | Povinné | Poznámky |
|---|---|---:|---|
| `user_id` | UUID uživatele dárce | ne | Pokud je uvedeno, použije se k resolvování cílového uživatele; má přednost před `email`. Zdroj: `DonationConfirmationResource::post()` (v3.1). |
| `email` | E-mailová adresa dárce / žadatele | podmíněně | Povinné, pokud chybí `user_id`; použije se k resolvování cílového uživatele porovnáním s vlastností `mail` účtu. Vrátí `missing_email_or_user_id`, pokud jsou prázdné jak `user_id`, tak `email`. |
| `campaign_id` | Campaign (EN0004), na kterou se má vztahovat suma darů | podmíněně | Povinné, pokud chybí `confirmation_year` (viz BR-DonationConfirmationAndTax). |
| `confirmation_year` | Daňový rok, za který se potvrzují dary | podmíněně | Povinné, pokud chybí `campaign_id`. Pro vymezení datového rozsahu se respektují pouze čtyřciferné číselné roky; jiné hodnoty jsou při výpočtu sumy tiše ignorovány. |
| `name` | Zobrazované jméno žadatele/dárce | ne | Pokud chybí, použije se celé jméno resolvovaného uživatele; na uloženém snapshotu (EN0014) zkráceno na 50 znaků. |
| `address` | Adresa žadatele/dárce | ne | Pokud chybí, použije se adresa resolvovaného uživatele; na uloženém snapshotu zkráceno na 200 znaků (v3.1). |
| `rodne_cislo` | České rodné číslo | ne | Pokud chybí, použije se uložená hodnota resolvovaného uživatele; zkráceno na 20 znaků. |
| `agreement_truthfulness` | Souhlasový příznak GDPR/pravdivosti údajů | ne | Uloženo na snapshotu (EN0014) tak, jak bylo zadáno; nebyla zjištěna žádná server-side validace pravdivosti. |
| `agreement_personal_data` | Souhlasový příznak GDPR pro osobní údaje | ne | Uloženo na snapshotu (EN0014) tak, jak bylo zadáno; nebyla zjištěna žádná server-side validace. |

### Vstupy — v3.2 (`POST /api/3.2/donation_confirmation`)

Stejná pole jako u v3.1 **s výjimkou**:

| Pole | Význam | Povinné | Poznámky |
|---|---|---:|---|
| `user_id` | — | — | **Verzí v3.2 se nečte.** Resource v3.2 resolvuje uživatele pouze z autentizované session nebo z `email`; pole `user_id`/UUID se nezohledňuje (`getUser()` ve v3.2). |
| `email` | E-mailová adresa dárce / žadatele | podmíněně | Použije se pouze jako fallback, pokud není přihlášena žádná session. Pokud session **je** přihlášena, `email` se pro resolvování uživatele ignoruje, ale i tak se přijme/uloží jako pole kontaktního e-mailu na snapshotu potvrzení. |
| `address` | — | ne | Zkráceno na 200 znaků, stejně jako u v3.1 (oba zdrojové soubory používají stejný limit 200 znaků pro toto pole, přestože je toto pole na úrovni entity modelováno s max. 250 znaky — viz EN0014 Open Items pro tento nesoulad; zde neřešeno). |
| (všechna ostatní pole) | — | — | Stejné jako u v3.1: `campaign_id`, `confirmation_year`, `name`, `rodne_cislo`, `agreement_truthfulness`, `agreement_personal_data` se chovají identicky. |

Poznámka k rozdílu mezi verzemi: v3.1 exponuje explicitní cestu vyhledání uživatele podle UUID, kterou
v3.2 odstranila ve prospěch resolvování na základě session s fallbackem na e-mail. Toto je hlavní
rozdíl v chování mezi oběma živými verzemi. Potvrzeno ze zdrojového kódu; nedoloženo v žádném
changelogu.

## Odpověď

### Úspěch

| Pole | Význam | Poznámky |
|---|---|---|
| `status` | Literál `"success"` | HTTP 200. V těle odpovědi se nevrací žádný identifikátor potvrzení, URL dokumentu ani referenční číslo — volající nezíská žádný odkaz na vytvořený záznam DonationConfirmation (EN0014) ani na odeslaný e-mail. |

### Chybové výsledky

| Výsledek | Význam | Lze opakovat | Poznámky |
|---|---|---:|---|
| `missing_email_or_user_id` | Nebyl zadán žádný resolvovatelný identifikátor uživatele (`user_id`/UUID) ani `email` | ano | HTTP 401 (použito jako obecný chybový stav, nikoli skutečné selhání autorizace). **Pouze v3.1** — v3.2 tuto konkrétní kontrolu neprovádí; pokud se nepodaří resolvovat session/e-mail, postupuje místo toho k `user_not_found`. |
| `missing_campaign_or_year` | Nebyl zadán ani `campaign_id`, ani `confirmation_year` | ano | HTTP 401 (stejné nestandardní opakované použití stavového kódu). Přítomno u obou verzí. |
| `user_not_found` | Žádný uživatel neodpovídá zadanému `user_id`/UUID (v3.1) nebo `email` (obě verze) a žádná session není přihlášena (v3.2) | ano | HTTP 404. |
| `no_transactions` | Vypočtená celková uhrazená částka darů pro resolvovaného uživatele/rok(/campaign) je nulová | ano | HTTP 400. Potvrzení je v tomto případě záměrně NEvystaveno — odpovídá UC0010 AF1. Nevytváří se žádný záznam DonationConfirmation (EN0014) ani e-mail. |

Pro selhání renderování nebo doručení e-mailu, k němuž dojde po tom, co byl záznam DonationConfirmation
(EN0014) již uložen, se nevrací žádný výsledek — endpoint již odpověděl `{"status":"success"}` (200)
v okamžiku, kdy `sendEmail()` běží synchronně v rámci téhož požadavku; pokud renderování PDF nebo volání
mailové služby vyvolá výjimku, výsledek viditelný pro volajícího zde není specifikován a tento dokument
jej nepokrývá (viz UC0010 AF2 — částečný, tiše neúplný výsledek).

## Vedlejší efekty

- Vytvoří neměnný snapshot záznam DonationConfirmation (EN0014) (jméno, e-mail, adresa, `rodne_cislo`,
  vypočtená `donation_total`, `donation_in_words`, `confirmation_year`, `campaign`, souhlasové
  příznaky, plus systémem zachycené `ip_address`, `user_agent`, `number_of_requests`), a to vždy, když
  je vypočtená suma větší než nula. Úplný kontrakt atributů viz EN0014 — zde není opakován.
- Vyrenderuje snapshot do CZ daňového potvrzení ve formátu PDF a odešle jej e-mailem prostřednictvím
  schopnosti transakčního messagingu (FN0019); odeslání je archivováno jako záznam EmailArchive
  (EN0022) bez ohledu na výsledek přenosu. Kontrakt messagingu viz UC0010 a MSG0028 — zde není
  opakován.
- Žádný záznam Transaction (EN0009) se nemodifikuje; Transactions jsou pouze vstup pro výpočet sumy
  (read-only).
- **Bez ochrany idempotence:** opakovaná volání se stejným dárcem/rokem každé samostatně vytvoří
  samostatný záznam DonationConfirmation a odešlou samostatný e-mail (UC0010 AF3;
  BR-DonationConfirmationAndTax).
- Pouze CZ: schopnost, na které tento kontrakt stojí, je doložena pro tenant CZ; pro RO/MD se
  nevytváří žádný ekvivalentní záznam potvrzení ani dokument (BR-DonationConfirmationAndTax).

## Reference

- UC: UC0010
- EN: EN0014, EN0008, EN0009, EN0022
- FN: FN0013
- BR: BR-DonationConfirmationAndTax

## Otevřené body

- V metodě `post()` žádné z verzí neexistuje žádná kontrola autorizace na úrovni entity ani
  vlastnictví nad rámec přidělení oprávnění REST metody roli anonymous/authenticated — výše označeno
  jako riziko, zde neřešeno; zda jde o zamýšlené self-service chování, nebo o mezeru, nedokládají
  současné zdroje.
- Odpověď při úspěchu nenese žádný identifikátor potvrzení/dokumentu; zda se od volajícího očekává
  dotazování (polling) nebo vyhledání vystaveného dokumentu jinde (např. stažení v Donor Zone dle
  MSG0028), je mimo doloženou strukturu požadavku/odpovědi tohoto kontraktu.
- Volba chybových stavových kódů (`401` pro to, co jsou ve skutečnosti validační chyby, nikoli
  selhání autorizace) je reprodukována tak, jak byla zjištěna; zde neopravena, protože tento dokument
  popisuje pouze current-state chování.
- Zda je v3.1 stále aktivně používána nějakým aktuálním klientem, nebo je již jen legacy-ale-dosažitelná,
  nelze doložit pouze na základě konfigurace (obě jsou `status: true`/enabled) — označeno jako
  otevřený bod, nikoli tvrzeno v žádném směru.
- Uložená maximální délka pole `address` se liší mezi modelem na úrovni entity (EN0014: max. 250) a
  vlastním voláním zkrácení v tomto modulu (`mb_substr(..., 0, 200)` v obou verzích resource);
  zaznamenáno jako zděděný nesoulad, zde neřešeno.
