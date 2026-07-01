# estimation-notes.md — podklad pro ODHAD rozsahu

> **POZOR: Tohle NENÍ odhad.** Je to strukturovaný podklad *pro* odhad. Nejsou tu člověko-dny ani ceny — jen relativní velikost/složitost, objemy dat, migrační rizika a páky, které odhad tlačí nahoru nebo dolů. Čísla LOC/souborů/entit slouží k *porovnání oblastí mezi sebou*, ne jako vzorec na pracnost. Rozhodnutí o scope (co se přenáší 1:1, co se navrhuje znovu, co se zahodí) patří lidem — níže jsou jen návrhy k rozhodnutí.

Zdroj: sizing + tech-dluh analýza per oblast (11 clusterů) nad stávající Drupal 9/10 codebase Patronus.

---

## 1. Přehled oblastí — relativní velikost a složitost

Řazeno zhruba od největšího rizika/objemu. „Složitost" = doménová náročnost reimplementace, ne jen počet řádků.

| Oblast | Objem (PHP) | Entity | Rel. velikost | Rel. složitost | Hlavní nositel rizika |
|---|---|---|---|---|---|
| **zadost-jadro** (Application Core) | ~31,4k LOC / ~203 souborů / 6 modulů | 8 | **Největší** | **Nejvyšší** | Stavový automat 65 stavů / 45 přechodů + reaction/action engine; God-entity |
| **Finance** (platby, dárcovství, dobrošeky, účetnictví) | ~21,9k LOC / ~153 souborů / 7 modulů | 9 | **Velmi velká** | **Velmi vysoká** | Multi-gateway, workflow s kaskádami, bankovní párování, ML, daňová logika per země |
| **patroni-kampane** | ~7,5k LOC / ~60 souborů / 4 moduly | 4 | Velká | **Vysoká** | Campaign fat-entity, workflow příběhu, 6 verzí REST |
| **obsah-vyhledavani** | ~8k LOC + ~353 JS / ~64 tříd / 5 modulů | 6 | Velká | Střední–vysoká | ~106 Gutenberg bloků, contact s revizemi + dedup, rozbité vyhledávání, PII v indexu |
| **dodavatele-smlouvy** (supplier/organisation/partner/contract) | ~10,85k LOC / 83 souborů / 4 moduly | 6 | Střední–vysoká | Střední–vysoká (nerovnoměrná) | **contract** (PDF + el. podpis + per-country číslování) = těžiště |
| **platforma-util** | ~cca 60 tříd / 12 modulů | 8 | Střední | Nerovnoměrná | export_csv + reports (ručně psaný SQL na staré schéma) |
| **risk** (scoring + blacklist) | ~5,3k LOC + ~446 JS / 29 tříd / 2 moduly | 4 | Střední–velká | Střední–vysoká (koncentrovaná) | ScoringForm ~90 polí + bodový engine s hardcoded vahami |
| **platebni-brany** | ~4,55k LOC / ~30 tříd / 4 moduly | 8* | Střední (objem) | **Vysoká** (integrace/security) | 4 heterogenní integrace + tajemství v kódu; **nedělitelné od transaction** |
| **notifikace-komunikace** | ~1,35k LOC / ~14 tříd / 4 moduly | 5 | Malá (v modulech) | Střední (rozptýlená integrace) | Jádro odesílání žije jinde (patron_base), ~50 call-sites |
| **marketing** (Mautic / FB / doporučování) | ~12 tříd napříč oblastí | 7 | Malá–střední | Nízká–střední (klamná kvůli mrtvému kódu) | Tajemství v kódu; ML modul z většiny mrtvý |

\* U bran je počet entit ve vstupu vztažen ke sdílenému balíku transaction; brány samy vlastní entity nemají.

**Čtení tabulky pro odhad:** tři oblasti (`zadost-jadro`, `Finance`, `patroni-kampane`) nesou většinu rizika a objemu. `platebni-brany` mají malý objem, ale vysokou integrační/bezpečnostní složitost a nelze je odhadovat izolovaně. `marketing` a část `platforma-util` obsahují velký podíl mrtvého kódu — objem *nereprezentuje* pracnost.

---

## 2. Objemy dat (řádové) — migrační zátěž

Počty záznamů řídí náročnost datové migrace a validace nezávisle na objemu kódu.

| Tabulka / entita | Řádový objem | Poznámka pro odhad |
|---|---|---|
| **application_states** | **~892k** | Zdaleka největší. Historie stavových přechodů (raw tabulka mimo Entity API). Řídí náročnost migrace stavového automatu a auditní stopy. |
| **transaction** | **~196k** | Finanční jádro. Přesnost a rekonciliace kritická — nulová tolerance ztráty/nekonzistence. |
| **aprofile** (super-profil) | **~105k** | ApplicationProfileEntity ~2391 řádků, stovky flat polí, mnoho „not used in the new version". Nejasné, která pole jsou živá → velká čisticí/mapovací práce. |
| **application** | **~51k** | Vlastní žádosti. ApplicationEntity ~1510 řádků. |
| **campaign** | **~21k** | Bohatá entita ~45 polí. |

**Dopad na odhad:** objem `application_states` (~892k) znamená, že migrace historie stavů je samostatná netriviální položka, ne vedlejší efekt migrace entit. Objem `aprofile` (~105k) násobí riziko super-profilu (viz níže) — každé nejasné pole se propaguje přes 105k záznamů.

---

## 3. Migrační rizika (napříč oblastmi)

### 3.1 Super-profil `aprofile`
- ApplicationProfileEntity ~2391 řádků, stovky plochých base fields, mnoho explicitně označených „not used in the new version".
- Není jasné, která pole jsou živá → nutná inventura pole-po-poli před mapováním.
- ~105k záznamů → chyba v mapování má velký blast radius.
- Míchání CZ/EN názvů polí (`odeslano`, `castka`, `rodne_cislo`, `Příspěvek`) napříč Finance i core.
- **Páka na odhad:** vyžaduje explicitní field-audit fázi (kurátorování, ne kopírování) → tlačí odhad nahoru; bez ní hrozí skrytý rozsah.

### 3.2 Stavový automat — 65+ stavů / ~45 přechodů / 8 rolí
- Ručně psaný v `application_states.yml`, NE Drupal core content_moderation.
- Duplikované `moderation_state`/`state` pole; role listy copy-paste per role s driftem.
- Napojený na event-driven **reaction engine** (per změna stavu) + cron-driven **action engine**, oba konfigurovatelné jako obsah.
- `getStatesConfig()` čte a `Yaml::decode()`uje soubor při každém volání (bez cache).
- **Páka:** jádro celého systému; reimplementace automatu + obou engine je největší jednotlivá položka odhadu. Musí se řešit současně s coupled clustery (contract/campaign/contact).

### 3.3 Duální / vícenásobný tracking stavu
- Duplikace `allowed_values` stavu kampaně min. 4× bez jediného zdroje pravdy.
- Dva paralelní darovací formuláře (CampaignDonationForm vs Updated).
- Trojí zdroj pravdy pro blacklist (risk).
- Contact: desítky domenových rolí namačkané do jedné entity přes `list_string` bez FK integrity.
- **Páka:** sjednocení zdrojů pravdy je práce navíc, ale snižuje budoucí riziko; nutné rozhodnutí, které varianta je kanonická.

### 3.4 Verzované REST API v20–v33
- `zadost-jadro`: ~22 REST resources napříč 3 API verzemi (v23/v30/v32), duplikované wholesale.
- `patroni-kampane`: 6 verzí (v22–v33), ~2000 řádků copy-paste s raw SQL.
- `Finance`: v31/v32 + neverzované varianty = ~3× plugin tříd.
- `platebni-brany` / `dodavatele-smlouvy`: v2.0/v3.0/v3.2 nekonzistentně.
- **Páka DOLŮ:** legacy verze se do nové architektury nepřenášejí 1:1 — velký podíl objemu je duplikace, kterou lze zahodit. **ALE** je nutné rozhodnout, které verze jsou ještě reálně konzumované (staré verze pravděpodobně stále exponované) → vyžaduje inventuru konzumentů.

### 3.5 Coupling — co nelze migrovat izolovaně
- `zadost-jadro` ↔ contract / campaign / contact / organisation + Mautic/ES/RabbitMQ/Comgate/ARES ze save-path.
- `contract` přímo instancuje ApplicationEntity/ApplicationProfileEntity/CampaignEntity/User → cirkulární závislost.
- `platebni-brany` neoddělitelné od `transaction` + `transaction_recurring` — **počítat jako jeden balík**.
- **Páka NAHORU:** oblasti nelze odhadovat ani realizovat čistě izolovaně; hranice migračních vln musí respektovat coupling.

### 3.6 Bezpečnostní dluh s dopadem na scope
Tajemství commitnutá v kódu (nutná rotace + přesun do secrets, samostatná položka):
- `platebni-brany`: MAIB cert/klíče (cert.pem, key.pem, .pfx) v repu; hesla, Netopia heslo/signature (4×), Moneta default token.
- `marketing`: FB pixel_id + access_token + webhook verify token; SSL verifikace vypnutá u Graph API.
- `Finance`: Slack webhook token, Mautic apiUrl v entitách.
- `notifikace`: WhoisXMLAPI key, Mautic customId/senderEmail.
- `platforma-util`: onedrive Microsoft clientSecret + uživatelské heslo v kódu.
- **Páka:** rotace tajemství + očista historie je nutná bez ohledu na scope migrace → fixní přírůstek.

### 3.7 GDPR / PII
- Elastic dokument obsahuje RČ dětí, rodná čísla, telefony, e-maily → PII v cloud indexu.
- export_csv sype GDPR-citlivá data plaintextem do `/tmp` bez úklidu.
- gdpr „smazání" je jen měkká anonymizace (mail/name), ostatní PII zůstává.
- **Páka:** compliance práce navíc; může být blokující pro multi-tenant RO/MD.

### 3.8 Multi-tenant (CZ + RO, plánováno MD)
- Per-country přes `Settings::get('country')` s magickými nekonzistentními hodnotami `'cz'/'cz1'/'ro'`.
- Silná CZ-vázanost v risk (ARES, MVČR, mapy), donation_confirmation (rodné číslo/potvrzení o daru = čistě CZ), TaxPayerEntity (2% daň = čistě RO).
- Podpisové obrázky manažerů hardcoded na `backend.patrondeti.cz` i pro RO.
- Šablona→ID e-mailů = velký per-country if/elseif; getUrl větví `/pribeh` vs `/story` dle země.
- **Páka NAHORU:** zobecnění per-country logiky do konfigurace je práce navíc, kterou stará codebase nemá; nutné pro MD.

---

## 4. Co pohání odhad NAHORU vs. DOLŮ (var. A vs. B)

Klíčová osa pro odhad: **A = přenést/reimplementovat věrně** vs. **B = navrhnout znovu / zúžit / zahodit**. U každé oblasti jiná páka.

### Tlačí odhad NAHORU (var. A — věrná reimplementace)
- **Stavový automat 65+/45/8** + reaction + action engine reimplementovaný 1:1 se všemi rolemi a side-effecty.
- **Super-profil aprofile** přenesený se všemi poli bez field-auditu (nejasnost = skrytý rozsah).
- **Věrná migrace historie** `application_states` (~892k) a `transaction` (~196k) s plnou rekonciliací.
- **Zachování všech REST verzí** v20–v33 pro zpětnou kompatibilitu konzumentů.
- **Multi-country zobecnění** (CZ/RO/MD) místo hardcoded větvení.
- **Coupling** — nutnost migrovat coupled clustery společně (žádné izolované úspory).
- **Business logika v entity lifecycle** (preSave/postSave se side-effecty: e-maily, Slack, queues, Telegram, mutace campaign) — těžko testovatelné, těžko portovatelné, nutno rozplést.
- **Bezpečnostní očista** (rotace tajemství, SSL, idempotence callbacků) jako povinný přírůstek.

### Tlačí odhad DOLŮ (var. B — nový návrh / zúžení)
- **Zahodit mrtvý kód:** `campaign_recommendation` (~80 % zakomentováno), celý ML doporučovací engine (rozhodnutí: oživit vs. zahodit — dnes nefunkční), Netopia standalone card.php (278 LOC), login_history sběr (celý zakomentovaný), RabbitmqService (odpojený), fixStates (tělo zakomentované).
- **Zahodit duplikaci REST verzí:** nová architektura má 1 verzi API, ne 3–6 copy-paste kopií (po inventuře konzumentů).
- **Zúžit blacklist** na jeden zdroj pravdy místo tří.
- **Sjednotit číselníky** zip (kraj/okres/obec/psc = 4× scaffold, jen psc má vazby) do jedné taxonomie.
- **Nepřenášet ručně psaný SQL** export_csv/reports 1:1 — reimplementace nad novým modelem (SELECT INTO OUTFILE, hardcoded roky 2017–2022 stejně nejsou udržitelné).
- **Supplier + partner** jsou převážně CRUD/datový přenos (rychlé); partner je fakticky mimo doménu (marketingový výpis).
- **Scaffold třídy** (Access handler, RouteProvider, ListBuilder, DeleteForm ~15–57 ř.) jsou generovatelné, ne ruční.

### Oblasti, kde rozhodnutí A/B nejvíc mění odhad
| Oblast | Rozhodnutí, které mění odhad nejvíc |
|---|---|
| marketing / campaign_recommendation | Oživit ML doporučování (velká featura: SVM, feature engineering, fronty, per-tenant taxonomie) **vs. zahodit** (dnes vypnuté). |
| REST API (všechny oblasti) | Kolik verzí v20–v33 zůstává exponovaných = přímo násobí objem API vrstvy. |
| aprofile | Field-audit před migrací (které z stovek polí jsou živé) — bez rozhodnutí = otevřený rozsah. |
| risk | Věrná rekonstrukce ~90polního ScoringForm + engine s hardcoded vahami **vs.** vytažení vah do konfigurace a redesign formuláře. |
| Gutenberg (obsah) | ~106 bloků migrovat/přehodnotit per-tenant **vs.** konsolidovat divergující CZ/EN sady. |
| export_csv / reports | Reimplementace nad novým modelem **vs.** rozsah legacy reportů zúžit na reálně používané. |

---

## 5. Poznámky per oblast (stručně, pro alokaci gap-analýzy)

- **zadost-jadro** — sem alokovat největší část odhadu i gap-analýzy. Dominuje `application` (~127 souborů / ~22,6k LOC); satelity (reaction/action/log/form-access/patron_base) menší. Riziko: God-entity + automat + engines + coupling.
- **Finance** — druhá největší. Nejnáročnější podčásti: `transaction` (workflow + dělení plateb), `account` (auth/REST breadth, PatronUser 905 ř.), `voucher` (Mautic/PDF). Rekurzivní `$this->save()` v postSave = riziko nekonzistence. Daňová/potvrzovací logika není zobecněná (RO 2% daň, CZ potvrzení o daru).
- **patroni-kampane** — jádro (workflow příběhu + agregace darů + REST) je must-have; `campaign_recommendation` z většiny mrtvý → do odhadu vynechat / navrhnout znovu.
- **platebni-brany** — počítat jako nedělitelný balík s `transaction` + `transaction_recurring`. Netopia nejnáročnější (kryptografie, SOAP, token recurring, IPN); comgate střední; maib/monetaapi malé (maib z velké části scaffold). Bez idempotence callbacků, minimum testů.
- **risk** — pracnost koncentrovaná: ScoringForm (1980 ř.) + engine. Zbytek generovatelný scaffold. Silná CZ-vázanost (ARES/MVČR) = práce navíc pro RO/MD.
- **dodavatele-smlouvy** — nerovnoměrné: `contract` (~4,45k LOC, PDF + el. podpis + per-country číslování + workflow) je těžiště; supplier/partner převážně CRUD; organisation střední.
- **obsah-vyhledavani** — `contact` (revize + dedup, ničí data bez transakcí) a Gutenberg (~106 bloků) největší nákladové položky. Vyhledávání dnes rozbité (cron off) + duplikace indexačního kódu (2 zdroje schématu). PII v indexu.
- **notifikace-komunikace** — strukturně nízká, ale rozsah větší než modul: jádro odesílání v `patron_base\APIMailingService`, ~50 call-sites, ~30 šablon ve 3 zemích. Gap: vícekanálovost + preference, vytažení volání do doménových událostí, katalog šablon per-tenant. Jediný kanál dnes = e-mail.
- **marketing** — objem klamný kvůli mrtvému kódu. mautic malý; facebook_leads webhook rozbitý (nutno předělat od nuly); campaign_recommendation = rozhodnutí zda vůbec.
- **platforma-util** — bimodální: LOW (tracking, autocomplete, image_rotate, gdpr, sitemap, zip-číselníky), MEDIUM (user_note, login_history, patron_devel, onedrive), HIGH (export_csv + reports — hustý ručně psaný SQL na staré schéma = hlavní nositel migračního rizika mimo core).

---

## 6. Průřezové vzory dluhu (opakují se → systémová páka, ne lokální)

Tyhle vzory se opakují napříč oblastmi; jejich náprava je systémová a ovlivní odhad plošně:

- **Fat / God entity** s business logikou a side-effecty v lifecycle metodách (application, aprofile, campaign, transaction, voucher).
- **Statické `\Drupal::` service-locator** místo DI všude → nízká testovatelnost, brzdí port.
- **Raw SQL mimo Entity API** napříč REST/cron/reports/export (+ SQL-injection smell v konkatenovaných IN/LIKE).
- **Drupal Console** (opuštěný projekt) v sitemap/onedrive/ComgateSync/elasticsearch → nutná migrace na Drush.
- **Hardcoded magic IDs** (patron 27280→covid19, kampaň 2200/3100, gift_category 71–76, uživatelské ID slidery) → křehké napříč tenanty.
- **String-typed finanční pole** (gift_price, income/expenses jako varchar) → data-quality dluh.
- **Vypnuté/mrtvé fronty** (USE_QUEUE=FALSE, slack_queue, RabbitMQ) → externí HTTP volání synchronně bez retry.
- **CZ/EN míchání** v labelech i názvech polí → komplikuje lokalizaci a mapování.

**Páka na odhad:** systémové vzory znamenají, že „port modulu" není mechanický — každá oblast nese stejné rozplétání (DI, Entity API, fronty, i18n). To je fixní režie, kterou je vhodné modelovat průřezově, ne sčítat naivně per modul.
