---
doc_id: UC0024
title: Manage Donor Account (Self-Service)
canonical_layer: UC
spec_type: use-case
status: canonical
modules: []
---

# UC0024 — Správa účtu dárce (samoobsluha)

## Header

| Field | Value |
|---|---|
| UC ID | UC0024 |
| Name | Manage Donor Account (Self-Service) |
| Bounded Context | C7 / C9 |
| Primary Actor(s) | Customer, System |
| Trigger Type | UI/API |

## Actoři a odpovědnosti

- **Customer** — přihlášená strana (dárce/podporovatel, patron nebo fundraiser — jakýkoli autentizovaný User, EN0008), která si prohlíží vlastní profil a dashboard účtu a upravuje vlastní jméno, preferenci zobrazení, viditelnost a profilovou fotku v zóně "Můj účet" (`/muj-ucet/nastaveni`).
- **System** — autentizuje volajícího, sestavuje read-model vlastního profilu/dashboardu Uživatele, aplikuje vlastní úpravy volajícího na jeho záznamy Contact (EN0006) a User (EN0008) a generuje odvozené obrazové styly pro nahranou profilovou fotku.

## Záměr

Umožnit přihlášené straně zobrazit si osobní dashboard shrnující vlastní dárcovskou aktivitu (celková darovaná částka, počet podpořených příběhů, odznaky) a spravovat vlastní profil — jméno, formát zobrazení jména, veřejnou viditelnost, dostupnost pracovníka a profilovou fotku — bez zapojení personálu.

## Předpoklady

- Customer má aktivní autentizovanou relaci vůči existujícímu účtu User (EN0008) (viz UC0014).
- Pro cestu nahrání fotky již byl obrazový soubor nahrán do souborového úložiště platformy a UUID souboru je k dispozici pro odkaz ve volání aktualizace profilu (vzor upload-then-attach, konzistentní s uploaderem příloh formuláře žádosti).

## Hlavní tok

### UC0024.1 — Zobrazení vlastního profilu účtu (obrazovka nastavení)
1. Customer: otevře obrazovku nastavení účtu (`/muj-ucet/nastaveni`) v autentizovaném stavu.
2. System: sestaví aktuální relaci User (EN0008) a jeho propojený Contact (EN0006).
3. System: vrátí vlastní profilová pole volajícího (jméno, příjmení, formát zobrazení jména, titul před/za jménem, e-mail, URL profilové fotky, příznak veřejné viditelnosti, příznak dostupnosti pracovníka, slug) společně s odvozenými souhrnnými hodnotami: celková uhrazená částka darů (SUM vlastních Transakcí Uživatele, EN0009, s příznakem `is_donation` ve stavu PAID), počet odlišných kampaní, u kterých má Uživatel uhrazený dar, a případné získané odznaky (sezónní dárcovské odznaky počítané z dat vlastních uhrazených Transakcí Uživatele).
4. Customer: vidí vykreslený profilový formulář (předvyplnitelný) a souhrnné hodnoty.

### UC0024.1b — Zobrazení vlastní historie darů dle podpořeného příběhu (zóna účtu)
1. Customer: otevře obrazovku zóny účtu/dárce (`zona/darce`, "Moje zóna").
2. System: sestaví aktuální relaci User (EN0008) a — omezeno na Uživatele s rolí `supporter` — vypíše každou Kampaň (EN0004), u které má Uživatel alespoň jednu uhrazenou, darem označenou Transakci (EN0009), společně s celkovou částkou přispěnou Uživatelem na danou Kampaň.
3. Customer: vidí jeden řádek na každý podpořený příběh s kumulativní darovanou částkou.

Tento dílčí tok je read-model **DonorAccountView (EN0034)** — úplný kontrakt polí/filtrů/přístupu viz tato entita; je zde pouze odkazován, nikoli opakován, v souladu s cross-layer disciplínou. Jde o samostatnou obrazovku/mechanismus oproti nastavení profilu v UC0024.1 — obě žijí v přihlášené zóně "Můj účet"/zóně účtu, ale jsou podloženy odlišnými mechanismy (REST profilový zdroj vs. rolí omezený Drupal View) a evidence nepotvrzuje, že jsou skládány do jediné jednotné dashboardové stránky (viz Evidence Pending).

### UC0024.2 — Úprava vlastního profilu (jméno, zobrazení, viditelnost, fotka)
1. Customer: odešle upravená pole profilu — libovolná z: jméno, příjmení, titul před jménem, titul za jménem, formát zobrazení jména (plné/zkrácené/skryté), příznak veřejné viditelnosti, příznak dostupnosti pracovníka, a/nebo nově nahraný odkaz na soubor profilové fotky.
2. System: načte aktuální relaci vlastního User (EN0008); pokud Uživatel neočekávaně nemá žádný, vytvoří za běhu propojený Contact (EN0006) (osazený e-mailem Uživatele).
3. System: aplikuje každé odeslané pole, které je v požadavku přítomno, na User (`public`, `worker_available`) nebo na Contact (`first_name`→jméno, `last_name`, `title_prefix`, `title_suffix`, `name_format`); pole v požadavku nepřítomná zůstávají beze změny.
4. System: je-li odeslán odkaz na soubor profilové fotky, připojí soubor do pole `user_image` Uživatele a vygeneruje pro něj tři pevné odvozené obrazové styly (`324x326`, `324x326@2`, `324x326@3`).
5. System: uloží Contact jako novou revizi (revizní záznam "Uzivatel si sam obnovil profil" / "user restored their own profile"), pokud se změnilo jakékoli pole Contact, a uloží User, pokud se změnilo jakékoli pole na úrovni Uživatele nebo fotka.
6. System: vrátí stejný read-model profilu jako UC0024.1, odrážející právě aplikované změny.

## Alternativní toky

### AF1 — Neodeslána žádná pole / no-op aktualizace
1. Customer: odešle požadavek na aktualizaci profilu bez přítomnosti žádného z rozpoznaných polí.
2. System: neprovede žádnou změnu na User ani Contact a nevytvoří novou revizi.

Výsledek: read-model profilu je vrácen beze změny.

### AF2 — E-mail není pole editovatelné samoobsluhou (mezera v současném stavu)
1. Customer: obrazovka `/muj-ucet/nastaveni` zobrazuje pole "E-mail" vedle polí se jménem (UI evidence, po_prihlaseni_do_uctu_nastaveni.png).
2. System: kontrakt aktualizace profilu nepřijímá pole `email` pro přihlášenou samoobslužnou úpravu v žádné pozorované verzi API (v3.0, v3.1, v3.2) — `email` se v kódu objevuje pouze jako výchozí hodnota pro Contact vytvořený za běhu a jako zakomentované TODO pole ("email", spolu s "phone", "password_old"/"password_new") v prostředku v3.0/v3.1, ve v3.2 zcela chybí.

Výsledek: **Mezera v současném stavu, nikoli navržená schopnost.** E-mailová adresa účtu zobrazená ve formuláři UI nemůže být ve skutečnosti změněna přes samoobslužný endpoint aktualizace profilu tak, jak je naprogramován; zda front-end pole tiše zahazuje, odesílá je a je ignorováno, nebo směruje změny e-mailu přes neodhalený samostatný mechanismus, **není evidováno**. Označit pro rozhodnutí při přestavbě — nepředpokládat, že změna e-mailu dnes funguje.

### AF3 — Změna hesla (pouze starší verze API)
1. Customer: odešle `password_old` a `password_new` na endpointu aktualizace profilu v3.0 nebo v3.1.
2. System: ověří `password_old` proti uloženému hashi přihlašovacích údajů; při shodě nastaví nové heslo a uloží.
3. System: při neshodě zamítne celý požadavek chybou `password_old_not_accepted` a neaplikuje žádné jiné odeslané pole z téhož požadavku.

Výsledek: samoobslužná změna hesla existuje pouze na starším (v3.0/v3.1) endpointu profilu; aktuální `ProfileResource` v3.2 neobsahuje žádnou větev pro změnu hesla — **Partial / verzí nekonzistentní**, není evidováno jako dosažitelné ze současné obrazovky `/muj-ucet/nastaveni` (která nezobrazuje žádné pole hesla).

### AF4 — Nahraný soubor nelze přiřadit
1. Customer: odešle odkaz na soubor profilové fotky (UUID), který se nepodaří přiřadit k existujícímu souboru.
2. System: tiše přeskočí připojení fotky (bez zobrazení chyby) a pokračuje v aplikaci ostatních odeslaných polí.

Výsledek: profil je aktualizován o ostatní pole, pokud existují; fotka zůstává tiše beze změny bez chyby viditelné uživateli — mezera v současném stavu UX, nikoli navržená validační odezva.

## Postconditions

- Při úspěšné úpravě: vlastní záznam User (EN0008) a/nebo Contact (EN0006) volajícího odráží odeslaná, rozpoznaná pole; profilová fotka, je-li nahrána, je připojena k Uživateli se třemi vygenerovanými odvozenými obrazovými styly.
- Souhrnné hodnoty profilu (celková darovaná částka, počet kampaní, odznaky) a hodnoty historie darů dle příběhu v zóně dárce (EN0034) jsou vždy čerstvě dopočítávány při čtení z vlastních Transakcí (EN0009) volajícího — nikdy se samostatně neukládají, takže v rámci tohoto případu užití nedochází k žádné perzistenci specifické pro dashboard.
- E-mailová adresa není tímto případem užití nikdy měněna, a to v žádné pozorované cestě kódu (viz AF2).
- Žádný záznam User ani Contact jiné strany není nikdy dotčen — každá operace v tomto případu užití je omezena na vlastního, relací určeného Uživatele volajícího.

## Traceability

Target SRVs:
- Identity-&-Access
- Payment-Processing (pouze pro čtení, pro výpočet souhrnné darované částky/počtu kampaní/odznaků a projekci historie darů dle příběhu EN0034)

EN entities:
- EN0008 User — profilová pole editovaná (`public`, `worker_available`, `user_image`) a identita, ke které jsou vztaženy souhrnný read-model a read-model historie.
- EN0006 Contact — propojený záznam strany nesoucí editovatelná pole jména/titulu/formátu zobrazení.
- EN0009 Transaction — zdroj pouze pro čtení jak pro výpočet darované částky/počtu kampaní/odznaků v souhrnu profilu, tak — prostřednictvím EN0034 — pro projekci historie darů dle příběhu v zóně dárce; tímto případem užití není žádná Transakce vytvářena, upravována ani odkazována pro zápis.
- EN0034 DonorAccountView — read-model historie darů dle podpořeného příběhu (`zona/darce` / "Moje zóna") využívaný v UC0024.1b; tento UC odkazuje na kontrakt polí/filtrů/přístupu EN0034, místo aby jej opakoval (cross-layer disciplína).

Integration boundaries:
- Žádné synchronní. Služba generování obrázků `patron_base.default` (interní, nikoli externí systém) odvozuje synchronně tři pevné styly profilové fotky v rámci ukládací cesty; Slack notifikace ("nahral profilovku." / "`update profilu`.") se spouští po uložení jako interní provozní notifikační vedlejší efekt, nikoli jako doménová integrační hranice.

Flow Evidence:
- Pro tento endpoint v době psaní neexistuje vyhrazený FLW dossier; chování v tomto UC je dohledáno přímo ke zdroji (viz Evidence Level), nikoli k předtěženému FLW artefaktu — označit pro follow-up FLOW-EVIDENCE, pokud bude před přestavbou vyžadován formální flow dossier.

## Evidence Pending / Evidence Gaps

- **Není potvrzeno, zda je obrazovka nastavení profilu (UC0024.1, `/muj-ucet/nastaveni`) a zóna dárce s historií darů (UC0024.1b, `zona/darce`, EN0034) prezentována jako jedna složená dashboardová stránka "Můj účet", nebo jako dvě samostatné podstránky účtu.** Jsou podloženy dvěma strukturálně odlišnými mechanismy — verzovaným REST prostředkem (`ProfileResource`) vs. klasickým Drupal View omezeným rolí — bez kódu propojujícího je do jediné odpovědi/stránky. Bohatší dashboard naznačovaný UI evidencí (odpočet/stav sběru dle příběhu, stahovatelná potvrzení, zpětná vazba, rozdělení záložek "Pro vás / Všechny (67)") je doložen pouze grafickým mockupem vloženým do e-mailu "Dokončete svůj uživatelský účet" (screencapture-mail-google-mail-u-1-2026-07-04-13_32_45.png; viz `_ar/spec-draft/UI-gap-promotions.md` G-02 a EN0034 Evidence Gaps 1/3), nikdy skutečnou obrazovkou dashboardu. **Nepředpokládat, že bohatší složený dashboard je implementován tak, jak je zobrazen v mockupu** — potvrzenou realitou backendu jsou dva užší, samostatně doložené povrchy dokumentované tímto UC (nastavení profilu; historie darů dle příběhu). Řešit dohledáním skutečné skladby stránek front-endové aplikace určené dárcům (není přítomna v tomto Drupal-backendovém zdroji), nebo potvrzením, že mockup je pouze aspirační.
- **"Sledovaný příběh" není v kódu modelovaný vztah.** Nebylo nalezeno žádné pole/tabulka pro odběr/sledování (`campaign_recommendation` na Uživateli je neaktivní pole ML-doporučení dle INV27/EN0007, nesouvisející s explicitním sledováním příběhu dárcem); projekce historie darů EN0034 je klíčována na vlastní uhrazené Transakce dárce vůči Kampani, nikoli na uložené "sledování".
- **Stahovatelná potvrzení o darech a zpětná vazba, naznačovaná mockupem dashboardu, nejsou poli EN0034 ani schopností tohoto případu užití.** Potvrzení o darech jsou samostatný, kódem potvrzený modul/samoobslužný formulář `donation_confirmation` (route `/donation-confirmation`; projekce UC0010, viz `_ar/spec-draft/UI-gap-promotions.md` G-13); Zpětná vazba (EN0021) je autorována na straně administrace za každou Žádost bez jakékoli dárci viditelné route/view "moje zpětná vazba" nalezené ve zdroji (viz EN0034 Evidence Gaps 3).
- **Ekvivalence zóny dárce pro RO/MD je nevyřešena** — `views.view.supporter_zone.yml` je přítomen pouze pod `sync_config/config_czech/`; zda tenanti Rumunska/Moldavska vystavují ekvivalent pod jiným config splitem, není potvrzeno (přeneseno z EN0034 Evidence Gap 2, zde znovu nezkoumáno).
- **Zda je zobrazené pole "E-mail" na `/muj-ucet/nastaveni` kosmetické/pouze pro čtení, nebo skutečná, ale aktuálně nefunkční editační cesta, je nevyřešeno** (AF2). V shromážděné evidenci neexistuje žádná route ani resource přijímající změnu e-mailu od přihlášeného samoobslužného volajícího.

## Evidence Level

**Partial.** UC0024.1 (zobrazení profilu) a UC0024.2 (úprava jména/titulu/formátu zobrazení/viditelnosti/fotky) jsou **Confirmed** — přímo dohledány k `web/modules/custom/account/src/Plugin/rest/resource/{v31,v32}/ProfileResource.php` (`GET`/`POST /api/3.{1,2}/user/profile`) a `PatronUser::getUserApiFields()` / `getTotalDonationsAmount()` / `getNumberOfCampaigns()` / `getBadges()` / `getUserImage()` v `web/modules/custom/account/src/PatronUser.php`, ověřeno křížově proti pozorované obrazovce `/muj-ucet/nastaveni` (po_prihlaseni_do_uctu_nastaveni.png) a jejímu zdůvodnění pro promoci v `_ar/spec-draft/UI-gap-promotions.md` (G-04 → UC0024). UC0024.1b (historie darů dle příběhu) je **Confirmed** — dohledáno k `sync_config/config_czech/views.view.supporter_zone.yml` (`zona/darce`, "Moje zóna", omezeno rolí `supporter`, rozsah `current_user`, seskupeno/sečteno dle Kampaně přes uhrazené darovací Transakce) dle EN0034. AF2 (e-mail není editovatelný) a AF3 (nekonzistence verzí u změny hesla) jsou **Confirmed** jako fakta na úrovni kódu (nepřítomnost/přítomnost dohledána napříč variantami `ProfileResource` v3.0/v3.1/v3.2), avšak jejich dopad viditelný na front-endu je **Uncertain** (neověřeno, zda skutečný klient `/muj-ucet/nastaveni` pole e-mailu tiše zahazuje, nebo zobrazuje chybu). Zda jsou UC0024.1 a UC0024.1b skládány do jedné jednotné dashboardové stránky, jak naznačuje mockup v e-mailu, je **Hypothesis**, explicitně neuváděno jako potvrzené (viz Evidence Pending). Pro tento endpoint neexistuje FLW dossier; trasovatelnost je přímo ke zdroji.
