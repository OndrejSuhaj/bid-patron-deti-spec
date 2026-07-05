---
doc_id: WIRE0022
title: Applicant Zone
layer: WIRE
spec_type: wireframe
modules: []
screen_id: S019
realizes_uc: [UC0024]
status: imported
references:
  - UC0024
  - EN0001
  - EN0034
  - BR-AccessControlAndRoles
---

# WIRE0022 – Zóna žadatele

## Účel

`zona/zadatel` — vlastní účetní zóna žadatele (fundraisera), zobrazující vlastní žádosti žadatele
(Žádosti, `EN0001`). Jde o sesterskou plochu k zóně dárce (`zona/darce`, S018) a zóně patrona
(`zona/patron`, S020): všechny tři jsou role-gated stránky "účetní zóny" pro danou roli, postavené
na klasických Drupal Views nad různými base tables. `zona/zadatel` je postavena na
`views.view.fundraiser_zone.yml` (`base_table: application`), doloženo pouze jako sesterský kontext
v rámci evidence `EN0034` — samotný view **nebyl** samostatně rekonstruován jako vlastní EN,
a **v evidenčním souboru neexistuje žádný snímek obrazovky `zona/zadatel`** (`_ar/evidence/ui/ui-observed-areas.md`
neobsahuje pro tuto obrazovku žádnou sekci; řádek S019 v IA-screen-map zaznamenává "screen not captured").

Tato obrazovka je v IA vedena čistě proto, že sesterský, strukturálně identický, kódem potvrzený
view (`fundraiser_zone`) existuje vedle kódem potvrzeného a snímky doloženého `supporter_zone`
(`zona/darce`, S018/EN0034) — viz IA-Q4 (`_ar/spec-draft/IA/IA-patronus.md` §8). Podle konvence
evidence WIRE je tento dokument napsán jako **Evidence-Pending** wireframe: zaznamenává to, co je
podloženo vrstvami IA/EN/UC, a nevymýšlí žádné vizuální rozvržení, seznam polí ani interakci nad
tento rámec. **Jistota: Assumed** (podle IA screen map), platí pro každé tvrzení níže, pokud není
citována užší evidence.

Kandidátní realizovaný use case: `UC0024` (Manage Donor Account (Self-Service)) — citovaný v IA
screen map jako nejbližší dokumentovaný UC pro všechny tři obrazovky účetní zóny (S018/S019/S020),
ačkoli `UC0024` v současném znění dokumentuje pouze podtok nastavení profilu (UC0024.1/.2,
`/muj-ucet/nastaveni`) a podtok historie darů v zóně dárce (UC0024.1b, `EN0034`) — **neobsahuje**
podtok zóny žadatele popisující, co `zona/zadatel` zobrazuje nebo dělá. Toto přiřazení UC je tedy
samo o sobě Assumed / analogií, nikoli přímou shodou — viz Otevřené otázky.

---

## Zóny rozvržení

**Evidence Pending — not captured.** V tomto evidenčním souboru neexistuje žádný screenshot, kódem
odvozená šablona ani evidence Twig/View-display popisující vizuální rozvržení `zona/zadatel`. Jediný
dostupný strukturální fakt je, že `base_table` view je `application` (`EN0001`), tj. očekává se, že
obrazovka zobrazuje záznamy žádostí, nikoli záznamy transakcí nebo kampaní (analogicky s
`supporter_zone` v `EN0034`, jehož `base_table` je `transaction`) — Assumed strukturální analogií se
sesterským vzorem `supporter_zone`/S018, u tohoto view přímo nepozorováno.

Nelze tvrdit žádné zóny rozvržení (kompozice header/main/sidebar/footer, prezentace řádek/karta,
filtry, stránkování). Neodvozujte na tuto obrazovku rozvržení S018 (`zona/darce`) — oba views se liší
v `base_table` a sada sloupců pro `fundraiser_zone` není potvrzena.

```
Evidence Pending — no ASCII layout sketch possible without a capture or a reconstructed
views.view.fundraiser_zone.yml field list.
```

---

## Použité komponenty

Vrstva COMP v tomto rekonstrukčním kroku ještě neexistuje; v každém případě nelze pro tuto obrazovku
tvrdit žádnou komponentu bez vizuální nebo polí-úrovňové evidence.

| Zóna | COMP-id | Varianta/Props | Poznámky |
|---|---|---|---|
| (celá obrazovka) | inline | — | Evidence Pending — not captured; inventář komponent nelze sestavit |

---

## Interakce

**Evidence Pending — not captured.** Kromě IA-zaznamenané cesty `zona/zadatel` není potvrzena vstupní
route, nebyla pozorována žádná primární/sekundární akce ani žádná výstupní cesta.

1. **Vstup** — předpokládaná `zona/zadatel` (podle IA screen map / tabulky routes v IA-patronus.md §4)
   při autentizaci v roli žadatele → stav: `default` — Assumed (route path je zaznamenaná
   kódem/IA, nikoli potvrzená snímkem; viz `_ar/spec-draft/IA/IA-patronus.md` §4).
2. **Primární akce** — Uncertain. Analogicky s `EN0034`/S018 by šlo o zobrazení vlastního seznamu
   žádostí; zda je řádek klikatelný (např. do detailu žádosti), není doloženo.
3. **Sekundární akce** — Uncertain — nedoloženo.
4. **Výstup** — Uncertain — nedoloženo.

---

## Stavy

### default
**Evidence Pending — not captured.** Neexistuje žádný screenshot ani definice view na úrovni polí,
která by popsala, co naplněná obrazovka `zona/zadatel` zobrazuje (která pole/stav žádosti jsou
zobrazena u každého řádku, pořadí řazení, seskupování).

### empty
**Evidence Pending — not captured.** Zda žadatel bez žádných žádostí vidí zprávu prázdného stavu,
výzvu k akci pro zahájení žádosti, nebo prázdný seznam bez zprávy, je Uncertain.

### loading
`N/A — no interactive/async behaviour evidenced for this screen; a classic Drupal View is typically
server-rendered on request rather than client-side-loaded, but this is Assumed by platform pattern,
not observed for this specific view.`

### error
**Evidence Pending — not captured.** Pro tuto obrazovku nebyl pozorován žádný chybový stav (např.
odepření přístupu pro nefundraiserskou roli, nebo chyba serveru).

---

## Validační plochy

Na této obrazovce není doložen žádný formulářový vstup (předpokládá se view pouze pro čtení, analogicky
s `supporter_zone` v `EN0034`), proto není tvrzena žádná validační plocha.

| Pole/Zóna | Trigger (BR-id) | Plocha |
|---|---|---|
| (nic nedoloženo) | — | — |

**validationsWithoutBR:** žádné — na této obrazovce ostatně není doloženo žádné validované pole.

---

## Datové vazby

| Zóna | EN-id | QUERY-id | Poznámky |
|---|---|---|---|
| Hlavní seznam (předpokládaný) | `EN0001` (Application) | — | Assumed strukturální analogií: `base_table` výchozího Drupal View je `application`, doloženo pouze jako sesterský kontext v evidenci `EN0034` (`views.view.fundraiser_zone.yml`, v tomto kroku nerekonstruováno samostatně jako vlastní doc-id EN/QUERY) — Probable na úrovni base table, Uncertain na úrovni pole/sloupce (žádný seznam polí nedoložen, na rozdíl od `EN0034`'s potvrzené dvousloupcové projekce `campaign`+`price`). |

Pro `zona/zadatel` nebyla v tomto kroku rekonstruována žádná dedikovaná read-model entita
(ekvivalentní `EN0034` pro `zona/darce`) — viz Otevřené otázky.

---

## Podmíněná viditelnost

| Komponenta/Zóna | Podmínka (odkaz ACL nebo BR) | Chování při skrytí |
|---|---|---|
| Celá obrazovka (`S019`) | Role-gated na roli žadatele — Assumed analogicky s potvrzeným gatingem role `supporter` v `EN0034` na sesterském view `zona/darce` (`type: role`, `role: supporter`); v tomto kroku nebyla pro `fundraiser_zone` nalezena/citována žádná rovnocenná evidence omezení role (např. konfigurace access-plugin `views.view.fundraiser_zone.yml`). Vrstva `ACLxxxx` ještě neexistuje, aby ji bylo možné citovat. `BR-AccessControlAndRoles` dokumentuje mechanismus automatického udělení role `supporter`, ale **neobsahuje** dokumentaci rovnocenného automatického udělení nebo gatingu pro roli žadatele — jde o mezeru, nikoli o potvrzené pravidlo. | Uncertain — nedoloženo (Assumed: pravděpodobně přesměrování na přihlášení nebo zobrazení odpovědi access-denied pro nefundraiserského/neautentizovaného návštěvníka, v souladu s platformově obvyklými vzory autentizace, ale pro tuto route nepozorováno) |

Toto je přeneseno z IA-Q4 (`_ar/spec-draft/IA/IA-patronus.md` §8): "Jaké jsou role-gates a skutečné
obrazovky pro `zona/zadatel` (S019) a `zona/patron` (S020)?" — otevřeno, tímto krokem WIRE nevyřešeno.

---

## Poznámky k přístupnosti

**Evidence Pending — not captured.** Bez snímku obrazovky nebo vykresleného markupu pro tuto route
nelze tvrdit žádné pořadí procházení tabulátorem, chování zaměření, strukturu landmarků ani interakci
klávesnicí.

- **Pořadí procházení tabulátorem:** Uncertain — nedoloženo.
- **Zaměření při vstupu:** Uncertain — nedoloženo.
- **Zaměření při změně stavu:** Uncertain — nedoloženo.
- **Landmarky:** Uncertain — nedoloženo.
- **Klávesové zkratky:** Žádné nedoloženy; žádné se neočekávají nad rámec standardní navigace
  na stránce se seznamem (Assumed).

---

## Otevřené otázky

- **Neexistuje žádný snímek obrazovky `zona/zadatel`.** Každé tvrzení o rozvržení, komponentě,
  interakci a stavu výše, nad rámec "base_table výchozího view je `application`", je Uncertain nebo
  Assumed analogií se sesterským, snímky doloženým `zona/darce` (S018/`EN0034`). Doporučujeme cílený
  opakovaný capture (UX-lead), než bude možné tento WIRE povýšit nad status Evidence-Pending.
- **`UC0024` neobsahuje podtok zóny žadatele.** UC v současnosti dokumentuje pouze UC0024.1/.2
  (nastavení profilu) a UC0024.1b (historie darů v zóně dárce, `EN0034`). Přiřazení `S019` k
  `UC0024` následuje sloupec kandidátního UC v IA screen map, ale nejde o přímou behaviorální shodu —
  buď `UC0024` potřebuje ekvivalent podtoku `UC0024.1c` napsaný z evidence `fundraiser_zone`, nebo by
  měl být po rekonstrukci obrazovky a jejího podkladového view vytvořen samostatný UC. Označit pro
  navazující zpracování ve vrstvě UC, tímto WIRE nevyřešeno.
- **Pro read-model kontrakt view `fundraiser_zone` neexistuje žádný doc-id EN**, na rozdíl od
  `EN0034` pro `supporter_zone`. Seznam polí (které atributy žádosti `EN0001` jsou projektovány —
  např. stav, odkaz na kampaň, jméno dítěte), filtry, seskupování a konfigurace access-plugin role
  jsou všechny nevyřešené; view je znám pouze jako sesterský podpůrný kontext v rámci sekce Evidence
  `EN0034` (`_ar/spec-draft/EN/EN0034_DonorAccountView.md`).
- **Mechanismus role-gate je nepotvrzený.** Zda `fundraiser_zone` používá stejný vzor access-plugin
  `type: role` jako `supporter_zone` (a pokud ano, vůči jakému machine-name role — `fundraiser` je
  předpokládán podle názvu route/view, ale není potvrzen proti souboru `config/user.role.*.yml`
  způsobem, jakým je `supporter` potvrzen pro S018), nebo jiný mechanismus (např. pouze argument
  `current_user`, bez omezení role, což by obrazovku zpřístupnilo jakémukoli autentizovanému
  uživateli), je Uncertain. Jde o stejnou mezeru zaznamenanou jako IA-Q4.
- **Ekvivalence RO/MD nevyřešena** — analogicky s Evidence Gap 2 `EN0034` (která tuto otázku
  označuje pro `supporter_zone`), zda `fundraiser_zone` existuje pouze pod `config_czech` nebo má
  ekvivalenty RO/MD, je nevyřešeno a v tomto kroku samostatně nezkoumáno.
- Zda je `zona/zadatel` prezentována samostatně, nebo je součástí širšího dashboardu "Můj účet"
  (podle hypotézy mockupu `S017` a IA-Q2/IA-Q3), je pro tuto konkrétní obrazovku nevyřešeno, stejně
  jako pro S018.

---

## Evidence

| Oblast tvrzení | Jistota | Evidence |
|---|---|---|
| Obrazovka existuje jako samostatná route (`zona/zadatel`) | Assumed | `_ar/spec-draft/IA-screen-map.md` řádek S019; `_ar/spec-draft/IA/IA-patronus.md` §4 tabulka routes |
| base_table podkladového view = `application` | Probable | Sekce Evidence `_ar/spec-draft/EN/EN0034_DonorAccountView.md` (cituje `views.view.fundraiser_zone.yml`, `base_table: application`, cestu `zona/zadatel`, jako sesterský podpůrný kontext — tímto krokem WIRE nezávisle neověřeno) |
| Rozvržení, komponenty, interakce, stavy (default/empty/loading/error) | Evidence Pending — not captured | Žádný záznam v `_ar/evidence/ui/ui-observed-areas.md`; žádný název souboru screenshotu v `_ar/prtsc/` neodpovídá této route |
| Gating role (role žadatele) | Uncertain | Žádná konfigurace access-plugin citována nad rámec analogie s rolí `supporter` na sesterském `EN0034`/S018; `BR-AccessControlAndRoles` nedokumentuje gating role žadatele |
| Přiřazení UC (`UC0024`) | Assumed | `_ar/spec-draft/IA-screen-map.md` řádek S019 (sloupec kandidátního UC); `_ar/spec-draft/UC/UC0024_ManageDonorAccount.md` (v těle UC není přítomen žádný podtok zóny žadatele) |
