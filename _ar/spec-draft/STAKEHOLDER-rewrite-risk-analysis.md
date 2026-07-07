# Proč opustit současné technické řešení — analýza rizik pro stakeholdery

> Zpracováno na základě AR rekonstrukce současného stavu platformy Patronus (patrondeti.cz / kidshero.ro),
> 2026-07-05. Není to dojmová úvaha — každé tvrzení je doložitelné konkrétním nálezem v rekonstrukci
> (odkazy `R##` = riziko, `B#` = blocker, `HS##` = hotspot, `G-##` = bezpečnostní nález fáze 04).
> Zdroje: [`REWRITE-decision-pack.md`](REWRITE-decision-pack.md), [`SPEC-CLOSURE.md`](SPEC-CLOSURE.md),
> [`DOMAIN-kernel.md`](DOMAIN-kernel.md), fáze-04 kontrakty (API/JOB/ACL/QUERY) + jejich synthesis reporty.

---

## 1. Shrnutí pro vedení

Rekonstrukce současného systému proběhla **kompletně a přesně** — architektura je zdokumentovaná,
pochopená a ověřená (referenční integrita čistá, 229 doc_id). To je důležité: **argument pro opuštění
NENÍ „je to chaos, kterému nerozumíme".** Je přesně opačný — **rozumíme mu do detailu, a právě proto
víme, že se nedá bezpečně rozvíjet dál.**

Systém nese **strukturální defekty ve třech oblastech, které jsou pro dárcovskou platformu
existenční**: **peníze** (transakce lze zdvojit, ztratit nebo zanechat v půl-rozpracovaném stavu),
**právo / GDPR** (právo na výmaz není splněno a je aktivně rušeno; cross-tenant únik osobních údajů
včetně rodných čísel), a **bezpečnost** (neautentizované platební callbacky, anonymní webhook,
nevynucené řízení přístupu). Tyto defekty **nejsou izolované chyby k opravě** — vyplývají ze základních
architektonických voleb (stav jako vedlejší efekt uložení, přetížený datový model bez identity, žádná
tenant dimenze). **Opravit základ = přepsat jádro** — takže inkrementální oprava neušetří náklad
přepisu, jen k němu přidá rizika mezidobí.

**Doporučení: varianta A — přepis (rewrite), ne pokračování ani upgrade současného řešení.** Každá
nová funkce postavená na současném základu dědí jeho rizika; každý měsíc provozu je expozicí
finančnímu, právnímu a reputačnímu riziku.

---

## 2. Rizikové oblasti (business dopad → technický základ)

### A. Finanční integrita — peníze lze zdvojit, ztratit nebo rozbít
Pro dárcovskou platformu je korektnost peněz nesmlouvavá. Současný stav ji nezaručuje:

- **Zdvojení / ztráta plateb** — platba nemá v databázi unikátní identitu ani idempotenční klíč;
  souběžné nebo přehrané callbacky brány či opakované POSTy mohou vytvořit **duplicitní transakce nebo
  nekonzistentní graf** napříč kampaní/dárcem (`R04`, `B2`, `HS12`).
- **„Optimistické" zaúčtování** — u trvalých darů cron označí platbu jako **uhrazenou jen proto, že
  volání brány nespadlo** — skutečné potvrzení přijde asynchronně později; bez zámku hrozí dvojí
  stržení nebo zaúčtování neúspěšné platby (`R05`, `HS04`).
- **Peněžní „hub" bez transakce** — první přechod do PAID spustí synchronně kaskádu (přepočet kampaně,
  rozdělení přeplatku, aktivace trvalého daru, přidělení rolí, e-mail, Slack) **bez databázové
  transakce** — fatální chyba uprostřed zanechá **částečně zaúčtovaný stav** (`R03`, `R17`, `HS03`).
- **Křehké párování plateb z banky** — bankovní import si nastaví „poslední běh" před prací a vždy se
  ptá na „včerejšek"; výpadek uprostřed běhu **trvale přeskočí celý den** plateb, bez retry
  (`R15`, `B7`, `HS05`). Pro finance je to tichá, nevratná ztráta dat o penězích.

### B. Právo a GDPR — právní povinnost, která dnes není splněna
- **Právo na výmaz není splněno a je aktivně rušeno** — „výmaz" jen vymaže e-mail a znáhodně přepíše
  uživatelské jméno; účet se nesmaže ani nezruší, jméno a příjmení zůstávají; a CRM-sync **znovu založí
  kontakt s plným jménem po anonymizaci** (anti-erasure). To je porušení zákonné povinnosti
  (`R11`, `B5`, `HS06`).
- **Cross-tenant únik osobních údajů** — reportingové exporty vypisují doménové tabulky do `/tmp`
  s **národními identifikátory (rodná čísla), jmény, adresami, e-maily, telefony** — bez filtru na zemi,
  s hrubým oprávněním; CZ/RO/MD data se míchají, protože **neexistuje tenant/country dimenze** k izolaci
  (`R12`, `R13`, `B6`, `HS07`, `HS11`). Osobní data leží nešifrovaně na disku.
- **PII do externí SaaS služby bez maskování** — do externího vyhledávacího indexu se posílají
  **rodná čísla žadatele i dítěte, e-maily, telefony a jména** bez maskování polí; a při smazání entity
  se z indexu nemažou (osiřelé dokumenty, PII přetrvává po smazání) (`HS16`, fáze-04 `QUERY`/`JOB`).
- **Destruktivní slučování s obcházením GDPR** — deduplikace kontaktu přeparentuje reference a pak
  **natvrdo smaže** duplicitní Kontakt i **jeho vlastnícího Uživatele** — mimo GDPR cestu, bez transakce,
  bez náhledu; při chybě nevratná ztráta / půl-sloučený graf (`R09`, `R10`, `B4`, `HS09`).

### C. Bezpečnost — otevřené vstupy a nevynucené řízení přístupu
- **Neautentizované platební callbacky** — callback route platební brány je fakticky veřejná; pravost
  stojí na **přehratelném sdíleném tajemství** vráceném v těle, bez HMAC/podpisu — lze podvrhnout /
  přehrát (`R06`, `G-05`).
- **Anonymní webhook s natvrdo zapsaným tokenem** — Facebook Lead webhook přijímá anonymní volání,
  ověřovací token je hardcoded konstanta; navíc příchozí data tiše zahazuje a vrací „úspěch" HTTP 200
  (`G-01`, fáze-04 `API`).
- **Řízení přístupu se z velké části nevynucuje** — legalita přechodů stavů není serverově vynucená:
  **z libovolného stavu je dosažitelný kterýkoli z ~66 stavů**, formuláře staví výběr ze všech stavů bez
  kontroly role/přechodu (`R02`, `B1`, `G-02`). Několik raw-SQL zápisů běží bez omezení rozsahu.

### D. Spolehlivost a provoz — tichá selhání, žádná skutečná observabilita
- **Tichá selhání** — indexovací fronta se sama nedrainuje (cron je zakomentovaný) → **index tiše
  zastarává**; cURL selhání smaže položku fronty, jako by byla zaindexovaná → **tichá díra v indexu**;
  výjimka v cronu se přehodí a **přeruší zbytek běhu** (`HS16`, fáze-04 `JOB`).
- **„Vypadá asynchronně, je synchronně"** — transakční e-maily se posílají **synchronně přímo v požadavku**
  (fronta je vypnutá, worker je mrtvý kód), bez retry; pomalý/nedostupný mailserver blokuje uživatelskou
  operaci (`R18`, `HS13`).
- **Observabilita jen „best-effort"** — jediné upozornění na chyby je best-effort zpráva do Slacku/Telegramu;
  desync kampaně ↔ žádosti se **jen oznámí, neopraví** (`R16`, `HS16`).
- **Mrtvý/dormantní kód vydávaný za funkci** — doporučovací subsystém je inertní na 5 nezávislých
  úrovních (event zakomentovaný, modul neinstalovaný, ML knihovna chybí…), přesto je v kódu jako by byl
  živý — riziko, že se při rozvoji omylem „oživí" nebo se na něj spolehne (`R19`, `HS14`, `INV27`).

### E. Datový model a udržitelnost — přetížené entity bez identity
- **Přetížený „Kontakt" bez identity a integrity** — jedna entita reprezentuje dítě / žadatele / patrona
  / školu / zaměstnavatele / lead rozlišené jen diskriminátorem, bez unikátnosti a referenční integrity →
  duplicity se hromadí, klasifikační zápisy trefují nezamýšlené záznamy, každé sloučení je destruktivní,
  protože **není na čem identitu smířit** (`R07`, `B3`, `HS08`, `HS10`).
- **Přetížená Žádost / superprofil** — Žádost váže ~20 „měkkých" referencí, ApplicationProfile ~100 polí
  držených **dvakrát** na žádost, s vazbou na vlastnictví a provázaností (`R08`). Změna čehokoli v jádru
  má nepředvídatelný dosah.

### F. Multi-tenance a vendor-lock — CZ/RO/MD i dodavatelé zalisovaní do jádra
- **Multi-tenance jen runtime-větvením** — CZ/RO/MD se řeší běhovými `if` větvemi a natvrdo zapsanými
  kontrolami země; **žádný tenant/country sloupec** na jádrových entitách. Nelze čistě izolovat data ani
  chování per zemi (`R13`, `HS11`) — a přímo to živí právní riziko z bodu B.
- **Zalisovaní dodavatelé** — 3 platební brány, CRM i úložiště jsou vnořené do doménového kódu, ne za
  porty (Netopia dokonce jako vendored SDK mimo správce balíčků) → **vendor lock-in**, těžká výměna,
  bezpečnostní i provozní závislost na cizím kódu (`R14`).

---

## 3. Proč to nejde „jen opravit" (inkrementálně, na místě)

Toto je jádro rozhodnutí pro stakeholdery. Rizika výše **nejsou samostatné bugy** — jsou důsledkem
**čtyř základních architektonických voleb**, které rekonstrukce identifikovala jako **blockery (B1–B4)**,
tj. věci, které musí být vyřešené **před/během** jakéhokoli bezpečného rozvoje:

| Blocker | Co blokuje | Proč to není záplata |
|---|---|---|
| **B1** — žádný autoritativní stavový engine | ~66 stavů, nevynucené přechody, neidempotentní fan-out | Cokoli postaveného nad stavem je nedůvěryhodné, dokud engine nevznikne — to je **přepis jádra workflow** |
| **B2** — neatomický peněžní hub bez identity platby | zdvojení/ztráta peněz, přehratelné callbacky | Zavést atomicitu + identitu + idempotenci = **přepsat tok peněz**, ne opravit řádek |
| **B3** — žádný kanonický model strany / identity | duplicity, destruktivní merge | Vyžaduje **nový model strany s unikátností** — mění se datový model i všechny zápisy |
| **B4** — destruktivní neatomický merge | nevratná ztráta dat, mazání Userů mimo GDPR | Bezpečný merge = **nová transakční/archivní mechanika**, ne úprava stávající |

Plus **B5 (GDPR výmaz), B6 (tenant dimenze + úniky), B7 (párování plateb)** — každý z nich sahá do jádra.

**Důsledek:** oprava těchto čtyř věcí „na místě" znamená přepsat stavový engine, tok peněz, model strany
a slučování — tedy **přepsat podstatnou část jádra tak jako tak**. Zvolit inkrementální opravu proto
**neušetří náklad přepisu** — pouze přidá dlouhé, rizikové mezidobí, ve kterém:
1. běží dvojí model (starý + nově opravovaný) a hrozí regrese,
2. každá nová business funkce se staví na nestabilním základu a **dědí jeho rizika**,
3. finanční/právní/bezpečnostní expozice trvá po celou dobu.

---

## 4. Kvantifikace dopadu (blast radius)

| Oblast | Pravděpodobnost | Dopad | Business následek |
|---|---|---|---|
| Zdvojení / ztráta plateb (`R03–R05`, `B2`) | Střední–vysoká (souběh, přehrání, cron) | Vysoký | Špatně zaúčtované dary, ruční dohledávání, ztráta důvěry dárců |
| Tichá ztráta dne párování (`R15`, `B7`) | Nízká–střední (výpadek cronu) | Vysoký | Nevratně chybějící párování plateb → finanční neshody |
| GDPR výmaz nesplněn + anti-erasure (`R11`, `B5`) | Jistota (děje se dnes) | Vysoký | Porušení zákona, riziko pokuty a stížností |
| Cross-tenant únik PII (`R12`, `R13`, `B6`) | Střední (export, sdílený index) | Kritický | Únik rodných čísel/adres napříč zeměmi → oznamovací povinnost, pokuta, reputační škoda |
| Neautentizovaný callback / anonymní webhook (`R06`, `G-01`, `G-05`) | Střední | Vysoký | Podvržení platebního stavu, otevřený vstup |
| Nevynucené řízení přístupu (`R02`, `B1`, `G-02`) | Střední | Vysoký | Neoprávněná změna stavu žádosti, obcházení procesu |
| Tichá selhání provozu (`HS16`, `R18`) | Vysoká | Střední | Zastaralý index, blokované operace, chybějící alerty |

---

## 5. Doporučení

**Varianta A (přepis) je doložitelně správná volba.** Rekonstrukce potvrzuje obojí, co je pro rozhodnutí
klíčové:
- **Architektura je pochopená a čistě zdokumentovaná** (closure dimenze „architektura" = uzavřeno /
  Confirmed) — takže přepis **nestaví naslepo**: máme kompletní, ověřenou specifikaci současného chování
  jako zadání (co zachovat, co opravit).
- **Současný základ nese doložené strukturální defekty** (dimenze current-state a rewrite-readiness =
  uzavřeno s omezeními) — a čtyři z nich (B1–B4) jsou takové, že jejich oprava = přepis jádra.

Přepis proto **není skok do neznáma** — je to **řízený přenos pochopeného chování na zdravý základ**,
který odstraní finanční, právní a bezpečnostní rizika, jež současné řešení strukturálně nese a nedokáže
se jich zbavit inkrementálně.

---

## 6. Jak je to doložitelné (evidenční základ)

Nic v této analýze není odhad — vše je trasovatelné do rekonstrukce:
- **Registr rizik `R01–R20`** a **blockery `B1–B8`** + jejich rozhodnutí (`ADR`) —
  [`REWRITE-decision-pack.md`](REWRITE-decision-pack.md).
- **Hotspoty `HS01–HS16`** (konkrétní místa v kódu) — [`DOMAIN-kernel.md`](DOMAIN-kernel.md).
- **Bezpečnostní / provozní nálezy `G-01…G-06`** ověřené proti kódu — fáze-04 kontrakty
  (`API-synthesis-report.md`, `ACL-synthesis-report.md`, `JOB-synthesis-report.md`,
  `QUERY-synthesis-report.md`).
- **Uzávěrkový verdikt** (co je uzavřené, co nese omezení) — [`SPEC-CLOSURE.md`](SPEC-CLOSURE.md).

> Poznámka k poctivosti: tato analýza popisuje **současný stav** platformy. Cílové zadání (varianta A/B,
> N1–N13) je samostatné; zde jde výhradně o doložení, proč současné technické řešení není udržitelný
> základ pro budoucnost.
