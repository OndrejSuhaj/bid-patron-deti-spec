---
doc_id: UC0025
title: Resume or Discard Draft Application
layer: UC
spec_type: use-case
status: imported
modules: []
---

# UC0025 — Pokračování v rozpracované žádosti nebo její zrušení

## Hlavička

| Pole | Hodnota |
|---|---|
| UC ID | UC0025 |
| Název | Resume or Discard Draft Application |
| Ohraničený kontext (Bounded Context) | C1 |
| Primární aktér(y) | Customer |
| Typ spouštění | UI/API |

## Aktéři a odpovědnosti

- **Customer** — fundraiser nebo patron, který zahájil (nebo byl přizván do) intake session žádosti
  (Application, EN0001), a při návratu na web s touto stále aktivní session se rozhodne v rozpracované
  žádosti pokračovat, ponechat ji beze změny, nebo ji smazat.
- **System** — ověřuje klientem drženou ApplicationSession (EN0003) vůči žádosti, vrací uložený stav
  vyplňování formuláře pro pokračování, zaznamenává průběžný postup na ApplicationProfile (EN0002) po
  dobu, kdy Customer dále pracuje, a — při explicitním smazání — nastaví žádosti stav zrušeno uživatelem
  bez průchodu mechanismem přechodů stavu vázaných na roli, který je použit jinde.

## Záměr

Umožnit Customerovi, který drží stále aktivní ApplicationSession (EN0003) pro dosud neodeslanou žádost
(Application, EN0001), buď pokračovat ve vyplňování od místa, kde skončil, ponechat ji nedotčenou pro
pozdější dokončení, nebo ji explicitně zrušit — nezávisle na sebe-registraci (UC0001) a bez jejího
opakování.

## Předpoklady

- Žádost (Application, EN0001) již existuje v otevřeném (dosud nedokončeném/nezrušeném) stavu, vytvořená
  předchozí sebe-registrací dle UC0001 nebo administrátorem iniciovaným procesem.
- Alespoň jedna ApplicationSession (EN0003) pro danou žádost je stále `Active` (nedeaktivovaná),
  identifikovaná dvojicí (`application_uuid`, `session_id`).
- Klient (front-end) drží dvojici `application_uuid` + `session_id` z původního intake — pozorováno jako
  query parametry (`?session=...&application=...`) v URL SPA formuláře použité v odkazu aktivačního/
  zvacího e-mailu. **Partial** — způsob, jakým klient tuto dvojici napříč návštěvami/načteními stránky
  ukládá a následně znovu rozpoznává (např. local storage, cookie), aby rozhodl, *kdy* zobrazit výzvu
  "máte u nás rozpracovanou žádost", je chování front-endu (SPA), které není přítomné v tomto backendovém
  zdroji; zde nedoloženo.

## Hlavní tok

### UC0025.1 — Pokračování v rozpracované žádosti

1. Customer: vrátí se na web s dvojicí identifikátorů session/žádost pro dosud neodeslanou žádost a
   zvolí v ní pokračovat (UI evidence: "Návrat do žádosti").
2. System: ověří dvojici (`application_uuid`, `session_id`) vůči `Active` ApplicationSession (EN0003)
   pro danou žádost.
3. System: odmítne požadavek, pokud session není nalezena nebo není aktivní, aniž by odhalil data
   žádosti.
4. System: načte žádost (Application, EN0001) a určí roli (fundraiser nebo patron) nesenou ověřenou
   ApplicationSession.
5. System: načte odpovídající ApplicationProfile (EN0002) pro danou roli, pokud již existuje, a vrátí
   rozhraní/schéma session spolu s již vyplněnými poli profilu (kromě přiložených souborů a příznaků
   souhlasu, které se nevrací), aby bylo možné formulář znovu vykreslit předvyplněný.
6. Customer: pokračuje ve vyplňování a odesílání zbývajících kroků formuláře žádosti.

Výsledek: Customer pokračuje v editaci téže žádosti (Application, EN0001) od jejího posledního uloženého
stavu polí; nevzniká žádná nová žádost ani ApplicationSession.

### UC0025.2 — Ponechání rozpracované žádosti bez akce (zavření výzvy)

1. Customerovi je zobrazena výzva na nedokončenou žádost a zvolí zůstat na aktuální stránce namísto
   pokračování nebo smazání (UI evidence: "Zůstat na stránce").
2. System: neprovede žádnou akci — záznamy žádosti (Application, EN0001) a její ApplicationSession
   (EN0003) zůstávají beze změny.

Výsledek: Rozpracovaná žádost zůstává otevřená a nedotčená; výzva se může znovu objevit při pozdější
návštěvě, dokud je session stále aktivní.

### UC0025.3 — Smazání (zrušení) rozpracované žádosti

1. Customer: zvolí zcela zrušit nedokončenou žádost (UI evidence: "Smazat žádost").
2. System: ověří dvojici (`application_uuid`, `session_id`) vůči `Active` ApplicationSession (EN0003)
   pro danou žádost, stejně jako v UC0025.1 krok 2–3.
3. System: načte žádost (Application) podle jejího UUID.
4. System: nastaví stav žádosti přímo na `canceled_by_user` ("Zrušeno uživatelem") a uloží ji — jde o
   bezpodmínečné přiřazení stavu, nikoli o přechod stavu vázaný na roli, jaký je použit jinde v
   životním cyklu žádosti (viz poznámka k BR níže).
5. System: potvrdí smazání Customerovi.

Výsledek: Žádost (Application, EN0001) zůstává v koncovém stavu `canceled_by_user`; není doloženo, že by
tato akce deaktivovala záznamy její ApplicationSession (EN0003) (viz Otevřené otázky). Žádné řádky dat
žádosti nejsou fyzicky smazány — "Smazat žádost" je změna stavu, nikoli tvrdé smazání.

## Alternativní toky

### AF1 — Neplatná nebo již deaktivovaná session

1. System: nenajde `Active` ApplicationSession (EN0003) odpovídající zadané dvojici (`application_uuid`,
   `session_id`) (např. byla již deaktivována reakcí řízenou stavem, dle přechodů stavu EN0003).
2. System: vrátí neúspěšný/neplatný výsledek session pro jakoukoli pokoušenou akci (pokračování nebo
   smazání), aniž by změnil žádost.

Výsledek: Požadované pokračování nebo smazání neproběhne. Úroveň evidence: Confirmed pro cestu
pokračování/postupu (`ApplicationGETResource`, `ApplicationProgressResource` obě vrací explicitní
selhání neplatné session); Partial pro smazání — `CancelApplicationResource` vrací stejný tvar selhání
"Session is invalid", ale zda front-end nabízel akci smazání i u již neaktivní session, není doloženo.

### AF2 — Chybějící povinné identifikátory

1. Customer/klient: odešle požadavek na pokračování, postup nebo smazání bez obou identifikátorů
   (žádosti a session).
2. System: požadavek okamžitě odmítne s validační chybou, ještě před vyhledáním session.

Výsledek: Nedochází ke změně stavu žádosti ani ApplicationSession.

## Postconditions (následné stavy)

- Pokračování (UC0025.1): žádost (Application, EN0001) a její ApplicationProfile (EN0002) zůstávají
  samotným čtením nezměněny; Customer je připraven pokračovat v editaci.
- Setrvání (UC0025.2): žádná změna stavu.
- Smazání (UC0025.3): stav žádosti (Application, EN0001) je `canceled_by_user`; žádost je vyloučena ze
  seznamů aktivních žádostí, které filtrují zrušené/uzavřené stavy (potvrzeno jinde v dossier, že je
  vyloučena např. z kontrol duplicitní žádosti na dítě).

## Business Rules (obchodní pravidla)

- **Poznámka k BR (označeno, zde nevlastněno):** `CancelApplicationResource` / jeho protějšek v3.2
  nastavují stav žádosti přímým voláním `setState('canceled_by_user')` namísto cesty přechodu/workflow
  vázaného na roli (`getAllowedStates()`/`getTransitions()`) používané u administrátorských změn stavu
  (UC0002). Tento UC zaznamenává pozorované chování; vlastnictví invariantu ("může Customer bezpodmínečně
  sám zrušit svou žádost, mimo pravidla přechodů?") náleží dokumentu BR (BR-ApplicationStatusGovernance),
  nikoli tomuto UC.

## Traceability (dohledatelnost)

Cílové SRV:
- Application-Lifecycle
- Identity-&-Access

Entity EN:
- EN0001 Application — rozpracovaná žádost, v níž se pokračuje, která je ponechána beze změny, nebo
  kterou tento UC zruší.
- EN0002 ApplicationProfile — data formuláře specifická pro roli, čtená (pokračování) a průběžně
  aktualizovaná (uložení postupu) tímto UC.
- EN0003 ApplicationSession — záznam přístupu/session, jehož platnost podmiňuje každou akci v tomto UC.

Hranice integrace:
- Žádné — tento UC je zcela interní (validace session + čtení či změna stavu žádosti/ApplicationProfile);
  není volán žádný externí systém.

Evidence toků:
- FLW0010 (Sebe-registrace fundraisera/patrona) — ustavuje dvojici ApplicationSession, kterou tento UC
  následně ověřuje; dokumentuje, že "opuštěná registrace zanechává holý lead ve stavu `new` + 2 session
  + uživatele + kontakt", tj. výchozí stav, na kterém tento UC dále pracuje.
- Kódová evidence (dosud nepovýšena na dossier FLW): `application/src/Plugin/rest/resource/v30/
  ApplicationGETResource.php` (pokračování — validace session + čtení profilu), `application/src/Plugin/
  rest/resource/ApplicationProgressResource.php` (průběžné ukládání postupu při ponechání rozpracované
  žádosti otevřené), `application/src/Plugin/rest/resource/CancelApplicationResource.php` a jeho
  protějšek `v32` (smazání/zrušení), `application/src/ApplicationService.php` (`isSessionValid`,
  `getApplicationSession`, `getApplicationByUuid`).

## Evidence Level (úroveň evidence)

Partial — backendová validace/pokračování session (`ApplicationGETResource`), uložení postupu
(`ApplicationProgressResource`) a zrušení (`CancelApplicationResource`/v32) REST resources jsou
Confirmed v kódu a stav `canceled_by_user` je Confirmed v `application_states.yml` a
`intake/statuses/statuses.md`. Co **není** doloženo tímto backendovým zdrojem, a je proto
Hypothesis/Partial:

- Přesná podmínka na straně klienta pro zobrazení modálního okna "Máte u nás rozpracovanou žádost"
  (screenshotová evidence: stránka `/dekujeme`, `_ar/evidence/ui/ui-observed-areas.md` §13) — zda je
  řízena lokálně uloženým identifikátorem session/žádosti, cookie, nebo serverovou kontrolou "má tento
  uživatel otevřenou žádost", je logika front-endu (SPA), která není přítomná v tomto repozitáři.
- Zda "Zůstat na stránce" (UC0025.2) vyvolá jakékoli backendové volání, nebo je čistě klientským no-op
  (nenalezen odpovídající REST resource pro akci "zavřít").
- Zda smazání žádosti (UC0025.3) také deaktivuje záznamy její ApplicationSession (EN0003) —
  `CancelApplicationResource` mění pouze stav žádosti; v jeho kódové cestě nebylo nalezeno žádné volání
  `ApplicationService::deactivateSession`/`deactivateSessions`.
- Pro výše uvedené REST resources pokračování/postupu/zrušení dosud neexistuje vyhrazený dossier FLW
  (`_ar/evidence/flow/FLW00xx`); tento UC cituje zdrojové soubory přímo dle pravidla proti halucinaci
  (dohledatelné do `intake/current-solution/_source/patronus/`) až do provedení průchodu FLOW-EVIDENCE.

## Otevřené otázky

- Volá "Zůstat na stránce" jakýkoli backendový endpoint, nebo jde čistě o klientské zavření dialogu bez
  jakéhokoli následného stavu na straně System? V prohledané sadě REST resources nedoloženo.
- Je výzva na straně klienta řízena uloženým lokálním identifikátorem (např. `localStorage`), nebo
  serverovým vyhledáním vlastních otevřených žádostí Customera? Určuje, zda se toto modální okno může
  objevit i při anonymní návratové návštěvě, nebo jen při autentizované.
- Obchází přímé `setState('canceled_by_user')` v `CancelApplicationResource` nějaké navazující reakce
  (EN0026 ApplicationReaction), které se běžně spouští při změně stavu řízené přechodem (UC0002.2), např.
  reakce deaktivace session? Pokud je stav nastaven mimo cestu přechodu/dispatch používanou jinde, spouštěč
  EN0003 "Active → Deactivated (all sessions)" se pro tuto cestu nemusí spustit — což by znamenalo, že
  smazaná žádost by mohla mít stále `Active` řádky ApplicationSession. Označeno k navazujícímu řešení u
  EN0003 / BR-ApplicationStatusGovernance.

## Vztah k UC0001

**Posouzení: ponecháno jako samostatný UC, nezačleněno do UC0001 jako alternativní tok.** UC0001
(Odeslání žádosti) modeluje jeden lineární záměr — registraci a vytvoření žádosti — a jeho alternativní
toky (AF1–AF4) jsou všechny variace, k nimž dochází *v rámci* téže registrační transakce (již
autentizovaný Customer, opakované odeslání s existujícím e-mailem, validační chyby). UC0025 je odlišný
uživatelský cíl, který:

- je spouštěn při **samostatné, pozdější návštěvě** webu, časově oddělené od původního odeslání dle
  UC0001 (výzva k pokračování je pozorována na stránce `/dekujeme` po platbě — zcela nesouvisející
  transakci — což potvrzuje, že není omezena na životnost session UC0001);
- je obsluhován **odlišnou sadou REST resources** (`ApplicationGETResource`,
  `ApplicationProgressResource`, `CancelApplicationResource`) než resources registrace/vytvoření v
  UC0001 (`UserCreateForm`, `application_create_resource`);
- má svůj vlastní **trojcestný výsledek** (pokračovat / ponechat beze změny / smazat), který nemá
  ekvivalent v toku UC0001; a
- může působit na žádost bez ohledu na to, *jak* byla vytvořena (sebe-registrace, iniciováno
  administrátorem, nebo přizvaný protějšek), tj. nejde o variantu kroku vytvoření, ale o schopnost správy
  životního cyklu vrstvenou nad jakoukoli již existující rozpracovanou žádostí.

Toto posouzení je nabídnuto pro účely reportu; v souladu s rozsahem zápisu (write-scope) samotný UC0001
zde není měněn.
