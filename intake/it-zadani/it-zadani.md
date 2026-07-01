**Patron Dětí**

Zadání pro externího IT dodavatele

Přepis / upgrade platformy patrondeti.cz

Verze: 1.0 \| Datum: květen 2026

Kontakt: Pavel Kuhn, Jan Beránek

<table>
<colgroup>
<col style="width: 100%" />
</colgroup>
<tbody>
<tr>
<td><p>Tento dokument je zadáním pro indikativní nacenění, nikoliv
formální výběrové řízení.</p>
<p>Žádáme o odhad rozsahu a nákladů pro dvě varianty řešení (viz sekce
5).</p>
<p>Podkladové materiály (procesní mapy, testovací scénáře, popis stavů)
jsou přiloženy.</p></td>
</tr>
</tbody>
</table>

# 1. Kontext projektu

Patron Dětí (www.patrondeti.cz) je charitativní platforma, která
propojuje dárce, patrony a rodiny s dětmi v tíživé životní situaci.
Patron v tomto modelu není pouze anonymní dárce – je to konkrétní člověk
nebo firma, která veřejně ručí za příběh konkrétního dítěte a tím dává
ostatním dárcům důvod k důvěře. Systém zajišťuje celý proces od podání
žádosti přes risk management a výběr darů až po zpětnou vazbu dárcům.

Platforma dnes funguje ve dvou zemích: v České republice (primární trh)
a v Rumunsku. Plánuje se expanze do dalších zemí (Maledivy, případně
Filipíny a střední Evropa). Technická platforma tedy musí být připravena
na multi-tenantní provoz.

## 1.1 Klíčové role v systému

- Zákonný zástupce (ZZ / rodič) – žádá o příspěvek pro dítě, prochází
  rizikovým prověřením

- Patron – ručí za příběh, vyplňuje vlastní část žádosti, má přístup do
  Patron Zóny

- Dárce – přispívá na konkrétní příběh nebo do společného fondu, sleduje
  průběh výběru

- Koordinátor FRONT – přijímá a zpracovává žádosti, komunikuje se ZZ,
  patronem a dodavatelem

- Koordinátor BACK – zpracovává back-office agendu po schválení žádosti:
  příprava smlouvy, koordinace podpisu, sledování realizace daru,
  uzavření příběhu

- Risk manažer – prověřuje ZZ, patrona, dodavatele a předmět daru

- Koordinátor CONTENT – připravuje a publikuje příběhy na webu,
  zpracovává zpětnou vazbu

- Finance manažer – vyplácí dary dodavatelům, provádí reconciliaci
  plateb, spravuje finanční výkazy a reporting

- Operations manažer – zpracovává finanční toky, přiřazuje příchozí
  platby k příběhům

- KAM Patron / AFFIL manažer – řídí vztah s patrony a jejich aktivaci

## 1.2 Rozsah geografického nasazení

- Aktivní: Česká republika, Rumunsko

- Plánované: Maledivy (odlišný model – spíše jednorázové dary přes
  resorty, bez dlouhodobé adopce)

- Výhledově: Filipíny a potenciálně středoevropské trhy

> *Pozn.: Legislativní a procesní odlišnosti v jednotlivých zemích jsou
> reálné. Systém musí umožnit zapínání/vypínání modulů a lokalizaci na
> úrovni jednotlivé instance bez nutnosti oddělené code base.*

# 2. Stávající architektura

Stávající systém je postaven na Drupalu (PHP) s vlastními moduly
implementujícími jednotlivé funkcionality. Frontend je v procesu migrace
na nový frontend postavený nad tím samým Drupalem – nasazení CZ je
plánováno začátkem července 2026.

## 2.1 Komponenty

- Backend: Drupal (PHP) – custom moduly pro žádosti, risk, příběhy,
  platby, zóny

- Frontend: nový Drupal-based frontend (CMS pro obsah + portálové
  funkce)

- Notifikace / CRM: Mautic – transakční e-maily, newslettery, tracking
  otevření

- Platební brána (CZ): Comgate

- Platební brána (RO): lokální brána (odlišná integrace)

- Databáze: MariaDB – plánováno jako oddělené instance per country v
  multi-tenant režimu

- Repozitář: Bitbucket

## 2.2 Multi-tenant architektura (plánovaný stav)

Po migraci CZ frontendu poběží jedna instance Drupalu obsluhující CZ i
RO přes multi-site (native Drupal mechanismus). Každá země bude mít
vlastní databázi. Back office funkce jsou konfigurované per-site přes
zapínání/vypínání modulů.

> *Důsledek: výpadek jádra systému = výpadek všech zemí. Toto je
> akceptovaný provozní risk při dané architektuře.*

## 2.3 Dokumentované moduly

Stávající systém má zdokumentované tyto procesní celky (přiloženy jako
process maps):

- ŽÁDOST FRONT – zpracování žádosti od převzetí po odeslání ke
  zveřejnění příběhu

- ŽÁDOST BACK – back office zpracování po schválení (smlouva, platba,
  uzavření)

- RISK – risk prověřování ZZ, patrona, dodavatele a daru (včetně Low
  Risk algoritmu)

- DONATIONS FLOW – tok darů od dárce k příběhu (Comgate, bankovní
  převod, stojí příkaz)

- FINANCE – finanční vypořádání, reporting, přiřazení plateb

- CONTENT – příprava a publikace příběhů, zpětná vazba dárcům

- MARKETING / PR / DONORS – péče o dárce, newslettery, kampaně

- AFFIL – case management a relationship management patronů

# 3. Důvody pro zadání

Na základě interního workshopu (26. 5. 2026) a analýzy stávajícího stavu
jsme identifikovali tři oblasti, které zadání motivují:

## 3.1 Technický dluh a udržitelnost

Stávající Drupal instance je provozována na starší verzi. Schopnost
najít a udržet dodavatele obeznámeného s touto specifickou konfigurací
je omezená. Do budoucna je žádoucí mít systém, který lze rozvíjet bez
závislosti na jednom dodavateli nebo na niche technologii.

## 3.2 Připravenost na škálování

Expanze do nových zemí klade požadavky na modulární konfiguraci: různé
platební brány, různé risk registry (v CZ levné, v RO drahé), různé
brandové identity, různé procesy. Stávající systém toto zvládá částečně,
ale ne systémově. Požadujeme jasně separovatelné moduly, které lze
per-country zapínat a vypínat bez zásahu do core.

## 3.3 Připravenost na AI agenty

Část back-office práce (tvorba obsahu příběhů, risk screening,
komunikace s žadateli) je analyticky automatizovatelná pomocí LLM
agentů. Pro jejich nasazení je nezbytné mít dobře zdokumentované REST
API – nejen pro interní potřeby, ale jako první třídu systémového
designu. V současnosti REST rozhraní neexistuje v podobě, která by
agentické propojení umožňovala bez dalšího vývoje.

# 4. Funkční rozsah – přehled modulů

Níže uvádíme přehled modulů, které systém musí pokrývat. Tabulka
obsahuje klíčové funkce a orientační indikaci rozsahu pro obě varianty
řešení (detailnější procesní mapy jsou přílohou).

| **Modul** | **Klíčové funkce** | **Variant A (přepis)** | **Variant B (upgrade)** |
|----|----|----|----|
| **Podání žádosti** | Formulář ZZ + patron (2 kroky), propojení formulářů, vytvoření žádosti v BE | Nová implementace | Stávající, drobné úpravy |
| **Automatizované urgence** | Timeouty 2 / 2+5 / 2+5+7 dní pro ZZ i patrona, automatické zrušení | Nová implementace | Stávající, optimalizace |
| **Koordinátor FRONT** | Back office správa žádosti, kontrola úplnosti, komunikace s dodavatelem | Nová implementace | Stávající, refactoring |
| **Koordinátor BACK** | Příprava smlouvy, koordinace podpisu ZZ, sledování realizace, uzavření příběhu | Nová implementace | Stávající, refactoring |
| **Risk management** | Low-risk scoring algoritmus, full risk review, blacklisty, Cribis/insolvenční reg. | Nová implementace | Stávající + API integrace |
| **Změna patrona** | Tok výměny patrona iniciovaný riskem nebo ZZ, nové urgence | Nová implementace | Stávající |
| **BACK office + Finance** | Smlouva, podpis, výplata daru dodavateli, uzavření příběhu, částečné plnění, reconciliace plateb | Nová implementace | Stávající, refactoring |
| **Typy příběhů** | Standardní příběh, příběh s otevřenou částkou, skupinový příběh, sbírkový účet – viz sekce 4a | Nová implementace | Stávající + nové typy |
| **Příběhy / Content** | Příprava a publikace příběhů, fotky, zpětná vazba dárcům | Nová implementace | Stávající + CMS úpravy |
| **Donační flow** | Comgate, bankovní převod, stojí příkaz, dárcovský voucher (Dobrošek) | Nová implementace | Stávající + nová brána |
| **Zóna ZZ** | Status tracking, doplnění žádosti, smlouva | Nová implementace | Stávající |
| **Zóna patrona** | Status tracking, aktivace účtu, history | Nová implementace | Stávající |
| **Zóna dárce** | Přehled darů, certifikát, potvrzení o daru pro daňové účely, stojí příkazy, recuring platby | Nová implementace | Stávající |
| **Mobilní aplikace** | Primárně pro dárce – recuring platby, personalizovaný story feed, push notifikace, potvrzení o daru | Nová (iOS + Android) | Nová (iOS + Android) |
| **REST API** | Kompletní API pro všechny entity a akce – základ pro AI agenty | First-class design | Doplnit / zdokumentovat |
| **Reporting / BI** | Přehledy stavů, konverzní funnel, finanční výkazy, napojení na BI nástroj (Tableau nebo jiný) – viz sekce 10 | Nová implementace | Doplnit / integrovat |
| **CMS / web** | Správa obsahu webu bez nutnosti IT zásahu, editace příběhů, landingů | Headless nebo Drupal | Stávající Drupal + AI editor |
| **Notifikace / e-mail** | Transakční maily přes Mautic, sledování otevření | Zachovat Mautic nebo ekvivalent | Stávající Mautic |
| **CRM integrace** | Export/sync dárců a patronů do externího CRM | API konektor (Mautic nebo 3rd party) | Optimalizace Mautic |
| **Platební brány** | Per-country integrace (CZ: Comgate, RO: lokální, MD: TBD) | Abstrakce + per-country config | Stávající + nová brána |
| **Multi-tenant** | Oddělené DB per country, sdílená core, per-country modul config | First-class design | Stávající Drupal multi-site |
| **Lokalizace** | CZ / EN / RO jazyky UI i e-mailů | i18n first-class | Stávající + doplnění |

# 4a. Typy příběhů — rozšíření datového modelu

Stávající systém pracuje primárně se standardním příběhem jednoho dítěte
s pevně stanovenou cílovou částkou. Pro plné pokrytí propozice musí nový
systém podporovat čtyři typy příběhů s odlišnou logikou výběru darů,
stavového modelu a prezentace dárcům.

## Typ 1 – Standardní příběh (s cílovou částkou)

Základní typ. Jeden beneficient, pevně stanovená cílová částka,
definovaný dodavatel a předmět daru. Příběh je aktivní do naplnění
cílové částky nebo vypršení platnosti. Prochází kompletním stavovým
modelem (viz sekce 7).

> *Příklad: Matyáš potřebuje elektrický vozík v ceně 85 000 Kč. Patron:
> firma ABC.*

## Typ 2 – Příběh s otevřenou částkou

Příběh bez předem stanovené cílové částky — dárci přispívají libovolnou
výší, výběr pokračuje průběžně bez termínu naplnění. Vhodné pro
opakující se nebo chronické potřeby (pravidelná terapie, spotřební
pomůcky). Stavový model musí umožnit průběžné čerpání vybraných
prostředků bez uzavření příběhu.

> *Specifický požadavek: systém musí podporovat průběžné částečné
> výplaty dodavateli z průběžného zůstatku příběhu, nikoliv pouze
> jednorázovou výplatu po dosažení cíle.*

## Typ 3 – Skupinový příběh

Více beneficientů sdílí jeden příběh a jednu cílovou částku. Patron ručí
za skupinu jako celek. Datový model musí uchovávat seznam beneficientů a
umožnit jejich zobrazení na stránce příběhu. Stavový model je jinak
shodný s Typem 1.

> *Příklad: Neslyšící hokejisté chtějí jet na mistrovství Evropy —
> potřebují 150 000 Kč na dopravu a ubytování pro 12 hráčů.*

## Typ 4 – Sbírkový účet

Trvalý otevřený příběh bez konkrétního beneficienta a bez cílové částky.
Slouží jako sběrný fond pro dárce, kteří chtějí přispět na projekt
obecně bez vazby na konkrétní příběh. Vybrané prostředky alokuje interně
koordinátor. Referenční implementace:
patrondeti.cz/pribeh/sbirkovy-ucet.

> *Specifický požadavek: sbírkový účet nemá patrona (nebo má jako
> patrona samotnou organizaci). Neprochází standardním žádostním
> procesem. Vyžaduje vlastní landing page s přehledem kumulativních darů
> a jejich využití.*

### Dopady na datový model a stavový stroj

- Každý příběh musí mít atribut type (standard \| open \| group \|
  collection) — ovlivňuje zobrazení na webu, stavový model i logiku
  výplat

- Skupinový příběh: entita Beneficient v relaci 1:N k příběhu (oproti
  stávajícímu 1:1)

- Sbírkový účet: příběh bez vazby na žádost a bez patrona — systémově
  samostatná entita

- Otevřená částka a sbírkový účet: financials model musí podporovat
  průběžné částečné výplaty (partial disbursement) s auditním logem

- Testovací scénáře pro typy 3 a 4 nejsou v přiloženém souboru —
  dodavatel navrhne vlastní scénáře jako součást analysis phase

# 5. Dvě varianty řešení

Nestanovujeme předem preferovanou variantu. Žádáme o indikativní
nacenění obou. Výsledné rozhodnutí závisí na poměru nákladů, rizik a
rychlosti dodání.

## Varianta A – Kompletní přepis

Nová implementace od základu, v moderním tech stacku (nezadáváme
konkrétní technologii, ale oceníme zdůvodnění výběru). Stávající systém
slouží jako funkční specifikace, nikoliv jako základ kódu. Stávající
databázová schémata mohou být použita jako inspirace nebo základ pro
migraci.

### Kritéria přijetí pro Variantu A:

- Funkční pokrytí 1:1 vůči stávajícímu systému (viz testovací scénáře a
  procesní mapy v příloze)

- REST API jako first-class citizen – všechny operace dostupné přes
  zdokumentované API

- Multi-tenant architektura s oddělením DB per country a feature toggles
  per-country

- Mobilní aplikace (iOS + Android) pro dárce

- Schopnost provozovat bez závislosti na jednom dodavateli –
  dokumentace, tests, CI/CD

- Migrační plán pro aktivní žádosti a příběhy z produkčního systému

## Varianta B – Upgrade stávajícího systému

Zachování stávajícího Drupal backendu jako základu. Refactoring, upgrade
verze, doplnění REST API vrstvy, nativní multi-tenant konfigurace,
mobilní aplikace jako samostatný klient nad API. Stávající custom moduly
budou procházet code review a prioritizovanou refaktorizací.

### Kritéria přijetí pro Variantu B:

- Upgrade Drupal na aktuální stabilní verzi s dlouhodobou podporou

- Zdokumentované REST API pro klíčové entity (žádosti, příběhy, dary,
  uživatelé, stavy)

- Multi-tenant konfigurace: oddělené DB, feature toggles, per-country
  branding

- Mobilní aplikace (iOS + Android) pro dárce

- Code review a prioritizace technického dluhu s odhadem fixu

- Dokumentace stávajících custom modulů jako základ pro budoucí rozvoj

<table>
<colgroup>
<col style="width: 100%" />
</colgroup>
<tbody>
<tr>
<td><p>Interně preferujeme, aby přepis – pokud k němu dojde – byl
realizován externím dodavatelem,</p>
<p>nikoli interním týmem. Interní tým by v takovém případě převzal
hotový produkt a zajistil provoz.</p>
<p>Upgrade stávajícího systému může být realizován kombinací interního
týmu a externích kapacit.</p></td>
</tr>
</tbody>
</table>

# 6. Co v propozici neměníme

Žádáme o zachování klíčových prvků, které tvoří unikátní hodnotu Patrona
Dětí vůči konkurenci. Tyto části nelze vypustit ani zjednodušit bez
výrazného dopadu na propozici:

- Transparentní příběhový model – dárce vidí konkrétní příběh, sleduje
  průběh výběru, dostává zpětnou vazbu

- Role patrona jako garanta – patron se podílí na žádosti a ručí svým
  jménem/firmou za příběh

- Risk management – prověřování ZZ, patrona a dodavatele zůstává jako
  ochrana projektu i dárců

- Věcné dary přímo dodavateli – peníze nejdou do rukou ZZ, jdou na
  fakturu dodavateli

- Zpětná vazba dárcům – uzavření příběhu zpětnou vazbou je součástí
  donor journey

Naproti tomu tyto prvky jsou otevřené k diskusi nebo optimalizaci:

- Crowdfunding mechanismus – zda příběh musí čekat na naplnění cílové
  částky nebo může jít rychleji do realizace

- Počet urgencí – aktuálně 2 urgence v timeoutech, diskutuje se redukce
  na 1 (technicky není problém)

- Segmentace příběhů – zdravotní vs. sociální vs. chronické situace –
  procesně jsou nyní totožné

# 7. Stavový model systému

Systém pracuje se třemi typy entit – Lead, Žádost (Application) a Příběh
(Story) – každý s vlastní sadou stavů. Níže uvádíme kompletní seznam
stavů pro CZ. Dodavatel musí tento model zachovat nebo poskytnout
rovnocennou náhradu s dokumentovaným mapováním.

| **Alias (systém)** | **Česky** | **Anglicky** | **Typ entity** |
|----|----|----|----|
| new | Nový | New lead | Lead |
| reminder_1 | 1\. urgence | Lead – 1. reminder | Lead |
| reminder_2 | 2\. urgence | Lead – 2. reminder | Lead |
| waiting_for_patron | Čeká na žádost patrona | Waiting for patron | Žádost |
| waiting_for_fundraiser | Čeká na žádost ZZ | Waiting for applicant | Žádost |
| reminder_1_patron | Čeká na žádost patrona – 1. urgence | Waiting for patron – 1. reminder | Žádost |
| reminder_2_patron | Čeká na žádost patrona – 2. urgence | Waiting for patron – 2. reminder | Žádost |
| reminder_1_fundraiser | Čeká na žádost ZZ – 1. urgence | Waiting for applicant – 1. reminder | Žádost |
| reminder_2_fundraiser | Čeká na žádost ZZ – 2. urgence | Waiting for applicant – 2. reminder | Žádost |
| to_check | Ke kontrole | For control | Žádost |
| application_processing | Zpracování žádosti | Application processing | Žádost |
| waiting | Čeká na doplnění | Waiting for additional info | Žádost |
| returned_new_patron | Vrácená žádost (nový patron) | Application returned – new patron | Žádost |
| scoring | Scoring kontrola | Scoring control | Žádost |
| scoring_ok | Scoring OK | Scoring OK | Žádost |
| scoring_ko | Scoring KO | Scoring KO | Žádost |
| scoring_waiting | Scoring k doplnění | Scoring additional info | Žádost |
| contract | Smlouva ke schválení | Contract for approval | Žádost |
| contract_signed | Smlouva podepsána žadatelem | Contract signed by applicant | Žádost |
| in_progress | Příprava příběhu | Story processing | Žádost |
| canceled_timeout | Zrušená žádost (timeout) | Canceled (timeout) | Žádost |
| canceled_application | Zrušená žádost | Canceled application | Žádost |
| out_of_scope | Out of scope | Out of scope | Žádost/Lead |
| active | Aktivní příběh | Active story | Příběh |
| suspended_campaign | Pozastavený příběh | Story on hold | Příběh |
| gift_payment | Úhrada daru | Gift payment | Příběh |
| gift_paid | Dar uhrazen | Gift paid | Příběh |
| waiting_signature | Čeká na podpis | Waiting for signature | Příběh |
| waiting_for_feetback | Čeká na zpětnou vazbu | Waiting for feedback | Příběh |
| feedback_to_proccess | Zpětná vazba ke zpracování | Feedback processing | Příběh |
| feedback_sent | Zpětná vazba odeslána | Feedback sent | Příběh |
| completed | Splněný příběh | Successful story | Příběh |
| completed_partly | Uzavřeno – částečné plnění | Partly closed story | Příběh |
| uncompleted | Nesplněný příběh | Unsuccessful story | Příběh |
| campaign_uncompleted | Cílová částka nevybrána | Target amount not collected | Příběh |
| closed | Uzavřeno | Closed story | Příběh |
| canceled_campaign | Zrušený příběh | Canceled story | Příběh |

# 8. Testovací scénáře

K zadání jsou přiloženy kompletní testovací scénáře (soubor
CZ_Test_Scenarios_V3_s_notifikacemi.xlsx) pokrývající 11 funkčních
bloků. Tyto scénáře slouží jako acceptance criteria pro obě varianty.
Dodavatel musí před zahájením vývoje potvrdit pokrytí všech scénářů
označených prioritou A a předložit plán pro scénáře priority B a C.

### Přehled bloků testovacích scénářů:

1.  BLOCK 1 – Podání žádosti (SC-1A, SC-1B) – zahájení ze strany ZZ i
    patrona

2.  BLOCK 2 – Patron nedokončí formulář (SC-2A až SC-2D) – urgence,
    timeout, odmítnutí

3.  BLOCK 3 – ZZ nedokončí formulář (SC-3A až SC-3C) – urgence, timeout,
    zrušení

4.  BLOCK 4 – Přijetí žádosti koordinátorem (SC-4A až SC-4C) – kontrola,
    vrácení, zamítnutí

5.  BLOCK 5 – Risk management (SC-5A až SC-5D) – Low Risk, schválení,
    zamítnutí, doplnění

6.  BLOCK 6 – Změna patrona (SC-6A až SC-6C) – nový patron, timeout

7.  BLOCK 7 – Dobrovolné zrušení (SC-7A) – zrušení na žádost ZZ

8.  BLOCK 8 – Back office po výběru (SC-8A až SC-8D) – smlouva, platba,
    uzavření, částečné plnění

9.  BLOCK 9 – Publikace příběhu a zpětná vazba (SC-9A až SC-9D) – obsah,
    feedback, urgence

10. BLOCK 10 – Donační tok (SC-10A až SC-10G) – Comgate, bank transfer,
    stojí příkaz, voucher

11. BLOCK 11 – Uživatelské zóny a správa účtů (SC-11A až SC-11E) –
    aktivace, stavy, Mautic

# 9. Požadavky na REST API

REST API je klíčovým požadavkem pro obě varianty. Toto API bude sloužit
nejen pro mobilní aplikaci a případné budoucí portálové integrace, ale
primárně jako rozhraní pro AI agenty, kteří budou automatizovat části
back-office práce.

## 9.1 Minimální scope API

- Žádosti: CRUD operace, změna stavu, přiřazení patrona, vrácení k
  doplnění

- Příběhy: CRUD, publikace, správa příloh, zpětná vazba

- Dary: přijetí, přiřazení k příběhu, reconciliace, přehled per story

- Uživatelé: ZZ, patron, dárce – profil, autentizace, notifikační
  preference

- Urgence: manuální trigger, přehled čekajících urgencí

- Stavy: kompletní state machine per entita s auditním logem

- Notifikace: trigger e-mailu (nebo webhook do Mautic)

- Risk: vstup scoring dat, schválení/zamítnutí, blacklist CRUD

## 9.2 Standardy

- OpenAPI 3.x dokumentace (strojově čitelná, Swagger UI nebo ekvivalent)

- Autentizace: OAuth2 nebo API key s per-role oprávněními

- Webhooks pro klíčové stavové přechody (pro AI agenty)

- Rate limiting a logování pro produkční bezpečnost

# 10. Mobilní aplikace

Mobilní aplikace chybí a je jedním z klíčových priorit. Primárně cílí na
dárce (akvizice recuring plateb, story feed, push notifikace o průběhu
příběhů), sekundárně může sloužit patronům pro sledování jejich příběhů.

- Platformy: iOS a Android (native nebo cross-platform React Native /
  Flutter – dodavatel navrhne)

- Autentizace: přihlášení stávajícím účtem dárce

- Story feed: personalizovaný přehled aktivních příběhů – doporučení na
  základě předchozích darů, oblíbených kategorií a lokality

- Donace: jednorázová i recuring platba přes mobilní platební metody
  (Apple Pay, Google Pay, karta)

- Push notifikace: milníky příběhu, zpětná vazba, urgence pro patrona

- Profil dárce: přehled darů, certifikáty, správa stojích příkazů,
  potvrzení o daru pro daňové účely (PDF ke stažení)

# 10a. Reporting a analytika

Systém musí podporovat operativní i strategický reporting pro interní
tým. Klíčovým požadavkem je přehled stavů všech entit v reálném čase a
schopnost exportovat nebo streamovat data do externího BI nástroje.

## 10a.1 Interní operativní reporting (v systému)

- Přehled žádostí podle stavu – filtrování po zemi, koordinátorovi,
  datu, typu příběhu

- Konverzní funnel – kolik žádostí prošlo každým stavem za dané období
  (podané → schválené → aktivní příběhy → splněné)

- Přehled urgencí – co čeká na akci, kdo je odpovědný, kolik dní ve
  stavu

- Finanční přehledy – vybrané dary, nevyplacené závazky, párovatelné
  platby, výplaty dodavatelům

- Přehled dárců a patronů – aktivní patronáty, objem darů, donor
  retention

- Risk dashboard – otevřené risk případy, blacklist hits, pending
  scoring

## 10a.2 Napojení na BI nástroj

Část analytiky je nebo bude v externím BI nástroji (zvažováno Tableau
nebo ekvivalent). Systém musí umožnit napojení jednou z následujících
cest — dodavatel navrhne preferovanou variantu a zdůvodní ji:

- Varianta A – Datový sklad: systém publikuje denní nebo near-realtime
  feed do dedikovaného datového skladu (schéma navrhne dodavatel). BI
  nástroj čte z datového skladu.

- Varianta B – Přímé API: BI nástroj nebo ETL vrstva volá REST API
  systému. Vhodné pro menší objemy nebo real-time dashboardy. Vyžaduje,
  aby API pokrývalo všechny reportovatelné entity.

- Varianta C – Přímý přístup k DB (read replica): BI nástroj se
  připojuje na read-only repliku produkční databáze. Nejrychlejší
  implementace, ale závislost na schématu.

> *Doporučujeme, aby dodavatel v odpovědi uvedl, zda stávající nebo
> navrhovaná architektura má nativní podporu pro audit log — ten je
> základem pro spolehlivý funnel reporting.*

## 10a.3 Exporty pro Finance a GDPR

- Export výplat pro účetnictví – CSV nebo XLSX se strukturou faktur a
  výplat za dané období

- Daňové potvrzení pro dárce – generování PDF potvrzení o daru pro
  fyzické i právnické osoby (per dárce, per rok)

- GDPR export – export osobních dat konkrétního uživatele (na žádost v
  souladu s čl. 20 GDPR)

- GDPR výmaz – anonymizace osobních dat uživatele při zachování
  finančního auditního záznamu

# 11. Požadavky na odpověď dodavatele

Toto není formální výběrové řízení. Žádáme o indikativní odpověď v
rozsahu, který vám umožní dát smysluplný odhad bez investice týdnů
práce. Ideálně do 3 týdnů od obdržení tohoto zadání.

## 11.1 Co chceme vidět

12. Nacenění po modulech (viz sekce 4) – zvlášť pro Variantu A i B

13. Orientační celkový rozsah v člověkodnech a výsledná cena

14. Navrhovaný tech stack s krátkým zdůvodněním

15. Přístup k multi-tenant architektuře a migraci dat

16. Odhad timeline od kickoffu do produkce

17. Tým: složení, role, seniorita

18. Reference: 1-2 relevantní projekty podobného rozsahu

19. Identifikace hlavních rizik a způsob jejich mitigace

## 11.2 Modulární nacenění

Prosíme nacenit každý modul ze sekce 4 samostatně (i orientačně),
abychom mohli dělat trade-off rozhodnutí. Zvláště záleží na separaci
těchto skupin:

- Core (žádosti + urgence + koordinátor FRONT + BACK + risk) – základ
  bez kterého systém nefunguje

- Back office + Finance (smlouvy, výplaty, uzavření, reconciliace)

- Typy příběhů (skupinový příběh, sbírkový účet, otevřená částka) –
  nadstavba nad core

- Dárcovský modul (donace, platební brána, certifikáty, daňová
  potvrzení)

- Mobilní aplikace – samostatná položka

- REST API vrstva – samostatná položka

- Reporting / BI napojení – samostatná položka (varianta A/B/C dle sekce
  10a)

- CMS / web – samostatná položka

- Multi-tenant infrastruktura a DevOps

## 11.3 Přístup k systému

Na žádost poskytneme přístup do Bitbucket repozitáře (read-only) pro
seznámení s existující code base. Databázová schémata lze exportovat a
poskytnout. Produkční systém není k dispozici pro přímý přístup – vše
přes dokumentaci a testovací scénáře.

<table>
<colgroup>
<col style="width: 100%" />
</colgroup>
<tbody>
<tr>
<td><p>Kontakt pro zaslání odpovědi a případné dotazy:</p>
<p>Pavel Kuhn – pave.kuhnl@kogi.cz</p>
<p>Jan Beránek – jan.beranek@patrondeti.cz</p></td>
</tr>
</tbody>
</table>

# 12. Nefunkční požadavky

Tato sekce pokrývá průřezová témata, která funkční popis systému (sekce
1–11) neřeší: bezpečnost a ochrana dat, výkon, provoz, dostupnost a
soulad s regulací. Nefunkční požadavky platí pro obě varianty (přepis i
upgrade) a jsou součástí akceptačních kritérií — nikoliv nice-to-have.

<table>
<colgroup>
<col style="width: 100%" />
</colgroup>
<tbody>
<tr>
<td><p>U každé oblasti žádáme dodavatele o: (1) popis navrženého řešení,
(2) způsob ověření (test, audit, doklad), (3) zahrnutí do akceptačních
kritérií.</p>
<p>U N1, N2, N7 a N8 (bezpečnost, výkon, penetrační test, PCI DSS) je
doložení souladu podmínkou go-live.</p></td>
</tr>
</tbody>
</table>

## N1 — Ochrana osobních a citlivých údajů, oprávnění a přístup

Platforma zpracovává osobní údaje zranitelné skupiny (děti) a v
sociálních/zdravotních příbězích i údaje zvláštní kategorie dle čl. 9
GDPR. Tomu musí odpovídat ochrana privacy by design & by default (čl. 25
GDPR).

### Granularita oprávnění a need-to-know

- RBAC mapovaný na role ze sekce 1.1 (ZZ, patron, dárce, koordinátor
  FRONT, BACK, risk, content, operations, KAM/AFFIL)

- Přístup k datům na úrovni záznamu, ne jen modulu: uživatel vidí pouze
  žádosti/příběhy, které mu jsou přiřazeny nebo spadají do jeho fronty —
  nikoli nesouvisející žádosti jiných klientů

- Oddělení přístupu napříč tenanty (CZ/RO/MD) je tvrdá hranice — žádný
  cross-tenant únik dat ani v UI, ani přes API

- Citlivá pole (zdravotní stav, rodinná situace) viditelná jen rolím,
  které je pro svou práci potřebují; ostatním maskovaná nebo skrytá

### Životní cyklus a minimalizace dat

- Minimalizace a účelové omezení: sbírat jen nezbytná data, nepoužívat
  je k jiným účelům

- Definované retenční lhůty pro každý typ záznamu — zejména
  zamítnuté/zrušené žádosti a data dětí; automatizované mazání nebo
  anonymizace po uplynutí lhůty

- Pseudonymizace/anonymizace tam, kde plná identifikace není nutná
  (reporting, testovací prostředí — viz N3)

### Práva subjektů údajů

- Podpora výkonu práv: přístup, oprava, výmaz, přenositelnost, omezení
  zpracování — ideálně exportní/výmazové funkce v back office, ne ruční
  zásah do DB

- Správa souhlasů (dárci, patroni, ZZ) s auditní historií a možností
  odvolání

### Auditovatelnost a bezpečnost

- Auditní log: kdo, kdy, k jakému záznamu přistoupil a co změnil —
  zejména u citlivých polí a finančních záznamů; log chráněný proti
  úpravě, s retencí

- Šifrování přenosu (TLS) i dat v klidu (at rest); řízená správa klíčů

- Hosting a uložení dat v EU (data residency); pokud dodavatel navrhne
  jinak, výslovně odůvodnit a ošetřit smluvně

### Smluvní rámec

- Zpracovatelská smlouva (DPA) mezi Patron Dětí a dodavatelem; evidence
  a schvalování sub-zpracovatelů (cloud, e-mail, platby)

- Postup detekce a hlášení bezpečnostního incidentu včetně součinnosti
  při ohlašování ÚOOÚ do 72 hodin (čl. 33 GDPR) — viz N4 a N9

## N2 — Výkonnostní a kapacitní požadavky

Systém musí být dimenzován pro aktuální provoz s rezervou na
desetinásobek dnešní zátěže a počítat se špičkami během kampaní — platby
jsou nárazové, špička výrazně převyšuje průměr.

### Cílová propustnost (per tenant)

- Příběhy: desítky až stovky příběhů za den s rezervou pro růst

- Platby: stovky až tisíce plateb za den, s kapacitou zvládnout
  kampaňové špičky (krátkodobě násobně více)

### Odezva a souběh

- Cílové doby odezvy: web/UI a API typicky do 300–500 ms (p95) při běžné
  zátěži; dodavatel navrhne měřitelné cíle

- Souběžní uživatelé back office i dárci na frontendu bez degradace;
  mobilní aplikace a API nesmí degradovat back office

### Škálovatelnost a ověření

- Horizontální škálovatelnost klíčových komponent; zátěž jednoho tenantu
  nesmí způsobit degradaci ostatních

- Zátěžové a výkonnostní testy jako součást akceptace; doložení, že
  systém zvládá cílové hodnoty včetně rezervy

- Monitoring kapacity a plán navyšování (capacity planning) — viz N5

## N3 — Build, testy, deployment a prostředí (DevOps / CI/CD)

Se systémem se dodává veškerá automatizace pro build, testy a nasazení
napříč třemi prostředími. Cílem je opakovatelný, auditovatelný proces
nezávislý na jednom člověku nebo dodavateli.

### Prostředí

- Tři oddělená prostředí: lokální (vývoj), testovací (izolované od
  produkce) a produkční

- Maximální parita prostředí přes Infrastructure as Code — konfigurace,
  verze, infrastruktura

### CI — build a testy

- Automatizovaný build z repozitáře (Bitbucket) při každé změně

- Automatizované testy: jednotkové, integrační a end-to-end navázané na
  testovací scénáře z přílohy P1 (acceptance jako spustitelná sada)

- Statická analýza, lint a security scanning závislostí jako brána před
  mergem

### CD — nasazení a tajemství

- Automatizovaný, opakovatelný deployment do testu i produkce; verzované
  databázové migrace s definovaným rollbackem

- Bezpečná správa tajemství (secrets management) — žádné přihlašovací
  údaje v repozitáři ani v konfiguraci kódu

### Migrace dat prod → test (anonymizovaně)

- Automatizovaná migrace produkčních dat do testovacího prostředí s
  anonymizací/pseudonymizací osobních a citlivých údajů

- Testovací data realistická strukturou i objemem, ale bez možnosti
  identifikovat reálné osoby — konzistentní anonymizace zachovávající
  relační vazby

- Testovací prostředí nesmí obsahovat reálné osobní údaje (vazba na N1,
  N8)

## N4 — Přehled dalších požadovaných oblastí (N5–N13)

Oblasti níže jsou rovněž součástí akceptačních kritérií. U každé žádáme
dodavatele o popis navrženého řešení a způsobu ověření.

| **Alias (systém)** | **Česky** | **Anglicky** | **Typ entity** |
|----|----|----|----|
| Oblast | Klíčové požadavky | Ověření / doklad | Go-live podmínka |
| N5 — Dostupnost, zálohy, obnova | Definované RTO a RPO; pravidelné zálohy v EU, šifrované, s otestovanou obnovou; disaster recovery postup; SLA dostupnosti | Test obnovy ze zálohy; DR drill | Ne |
| N6 — Monitoring, logování, alerting | Centralizované logy a metriky; alerting na výpadky, chyby, anomálie a neúspěšné platby; provozní dashboardy; vazba na auditní log z N1 | Demo dashboardu; ukázka alertu | Ne |
| N7 — Bezpečnostní testování a provoz | Penetrační test/bezpečnostní audit před go-live a periodicky; SAST/DAST v CI; WAF a bot protection na donačních a žádostních formulářích; patch management | Pentest report; výsledky SAST/DAST | ANO |
| N8 — Platební bezpečnost (PCI DSS v4.0.1) | Doložení rozsahu (SAQ) i při použití brány; zabezpečení platebních stránek; žádné ukládání citlivých dat karet; tokenizace na straně brány | SAQ nebo ekvivalentní doklad | ANO |
| N9 — E-mailová bezpečnost a doručitelnost | SPF / DKIM / DMARC pro transakční i kampaňové e-maily (Mautic); ochrana proti spoofingu a BEC; bezpečné zacházení s odkazy v notifikacích | DNS záznamy; DMARC policy | Ne |
| N10 — Přístupnost (EAA / WCAG 2.1 AA) | Veřejné rozhraní (web, dárcovský portál, mobilní aplikace) musí splňovat Evropský akt o přístupnosti (účinný 28. 6. 2025) — cílově WCAG 2.1 AA dle EN 301 549 | Accessibility audit nebo axe/Lighthouse report | Ne |
| N11 — Regulatorní soulad (průřezový) | GDPR (N1), EAA (N10), PCI DSS (N8); vyhodnotit dopad ZoKB/NIS2 (zákon č. 264/2025 Sb.) — pravděpodobně se na charitu přímo nevztahuje, ale relevantní pro bezpečnost dodavatelského řetězce; pro RO/MD lokální odchylky | Právní stanovisko nebo checklist | Ne |
| N12 — Maintainability, dokumentace, exit | Standardy kvality kódu, pokrytí testy, code review; kompletní provozní a vývojová dokumentace; vlastnictví kódu ošetřeno ve smlouvě; exit / anti-lock-in — export všech dat a převzetí provozu bez závislosti na původním dodavateli | Dokumentace při předání; exit klauzule ve smlouvě | Ne |
| N13 — Lokalizace a i18n (nad rámec UI) | Nad rámec překladu UI/e-mailů ošetřit: měny, formáty data/času, časová pásma a právní dokumenty per země (smlouvy, souhlasy) — vazba na multi-tenant model | Demo per-country konfigurace | Ne |

# 13. Přílohy

**P1** CZ_Test_Scenarios_V3_s_notifikacemi.xlsx *– kompletní testovací
scénáře (11 bloků, priority A/B/C, notifikační matice)*

**P2** STATUSES_CZ_RO_MO.xlsx *– kompletní stavový model pro CZ, RO a MD
(alias, CZ, EN, RO, typ entity)*

**P3** Procesní mapy (ZIP) *– 27 souborů pokrývajících 8 procesních
celků pro CZ, RO a MD:*

- ŽÁDOST FRONT (CZ, MD, RO)

- ŽÁDOST BACK (CZ, RO/MD)

- RISK – CZ_Process_Mapping_RISK_final.xlsx,
  Low_Risk_Evaluation_Process_Documentation (CZ + EN)

- DONATIONS FLOW (CZ, MD, RO)

- FINANCE (CZ, MO, RO)

- CONTENT (CZ, MD)

- MARKETING / PR / DONORS (CZ)

- AFFIL – Case Management a Relationship Management (CZ, MD, RO)

Patron Dětí \| Zadání pro externího IT dodavatele \| v3.0 \| červen 2026
