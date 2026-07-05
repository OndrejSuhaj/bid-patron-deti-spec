---
doc_id: WIRE0023
title: Patron Zone
layer: WIRE
spec_type: wireframe
modules: []
screen_id: S020
realizes_uc: [UC0024]
status: imported
references:
  - UC0024
  - EN0001
  - EN0005
  - EN0034
  - IA-patronus
---

# WIRE0023 – Patron zóna

## Účel

Vlastní role-gated self-service zóna patrona na adrese `zona/patron` ("Patron zone" dle IA mapy
obrazovek), kde se u přihlášené strany s rolí patrona očekává zobrazení jejích vlastních
žádostí/příběhů. Zóna je zařazena do souhrnné oblasti účtu "Můj účet" spolu s dárcovskou zónou
(`zona/darce`, S018) a zónou žadatele/fundraisera (`zona/zadatel`, S019) a je evidována jako
navazující na `UC0024` — žádný vyhrazený UC dílčí flow nedokumentuje její skutečný kontrakt pro
čtení dat; `UC0024` obecně popisuje self-service schopnost účtu (zobrazení/úprava profilu,
UC0024.1/UC0024.2) a podrobně i sesterský read-model dárcovské zóny (UC0024.1b / `EN0034`), ale
**nikoli** flow specifický pro patron zónu. Tento WIRE cituje `UC0024` podle přiřazení v IA mapě
obrazovek; mezeru v evidenci viz níže v sekci Evidence.

**Pro tuto obrazovku neexistuje snímek obrazovky** (`_ar/spec-draft/IA-screen-map.md`, řádek S020:
"screen not captured"). Tento dokument je rekonstrukcí typu **Evidence-Pending**: zaznamenává pouze
to, co podporuje evidence IA/EN/UC, a rozvržení, stavy i chování označuje jako `Assumed`/`Uncertain`
místo vymýšlení vizuálních detailů — dle konvence evidence v `tooling/docs/rules-WIRE.md`.

---

## Rozvržení zón (Layout Zones)

**Evidence Pending — nezachyceno.** Pro rozvržení této obrazovky neexistuje žádný snímek obrazovky
ani evidence z DOM/šablony. Jediná dostupná strukturální skutečnost je, že stránku obsluhuje
Drupal View s názvem `patron_zone` (`base_table: application`, cesta `zona/patron`) (evidence
`EN0034`, doprovodný kontext; `_ar/spec-draft/EN/EN0034_DonorAccountView.md`, řádky 58–63). Na
základě analogie se sesterským view `supporter_zone` (`EN0034`, potvrzeno pro S018) a společným
chromem "Můj účet" pozorovaným jinde (`WIRE0014`) jsou následující zóny **Assumed**, nikoli
potvrzené:

- Header — globální navigace webu + odkaz na účtové menu "Můj účet" pro přihlášeného uživatele
  (**Assumed**, na základě analogie s každou jinou přihlášenou obrazovkou; pro S020 nezávisle
  nepozorováno).
- Hlavní obsah — výpis vlastních žádostí/příběhů (`EN0001`) přihlášeného uživatele s rolí patrona,
  jeden řádek/karta na žádost, tvarem analogický layoutu `supporter_zone` s jedním řádkem na
  kampaň (**Assumed** — skutečné složení polí/sloupců view `patron_zone` není evidováno; viz
  Mezery v evidenci).
- Footer — společný chrome patičky webu (**Assumed**, dle `IA-patronus.md` §2).

Náčrt ASCII není uveden: vytvoření diagramu rozvržení bez evidence by porušilo disciplínu
evidence-first (`CLAUDE.md`; `rules-WIRE.md`).

---

## Použité komponenty

Vrstva COMP pro tuto rekonstrukční etapu ještě neexistuje; každý prvek níže je označen jako
`inline` a každý řádek je `Assumed` (neexistuje žádný záznam, který by potvrdil skutečné
komponenty).

| Zóna | COMP-id | Varianta/Props | Poznámky |
|---|---|---|---|
| Header | inline | globální navigace webu + odkaz na účtové menu | **Assumed** na základě analogie s `WIRE0014`/`WIRE0018` (dárcovská zóna); pro S020 nepozorováno |
| Main — výpis žádostí/příběhů | inline | list/table nebo card-list vlastních žádostí patrona | **Assumed** — tvar odvozen z existence sesterského view `patron_zone` s `base_table: application` (`EN0034`); seznam polí, šablona řádku ani text prázdného stavu nejsou evidovány |
| Footer | inline | společný chrome patičky | **Assumed**, dle `IA-patronus.md` §2 |

---

## Interakce

1. **Vstup** — přihlášená navigace na `zona/patron`, vstup z oblasti "Môj účet"/account-zone pro
   uživatele s rolí patrona → stav: `default`. **Assumed** trasa (tabulka vstupních bodů
   `IA-patronus.md` §4 uvádí `zona/patron` → S020 → `UC0024`, jistota Assumed); skutečný spouštěcí
   odkaz/položka menu není evidována (IA-Q4).
2. **Primární akce** — Neevidováno. Zda obrazovka podporuje jakoukoli akci nad rámec pouhého
   zobrazení (např. otevření detailu žádosti, úprava polí viditelných patronovi), je **Uncertain**
   — v evidenci UC0024/EN0034 prošlé pro tuto obrazovku nebyl nalezen žádný záznam ani
   route/controller pro zápisovou cestu na straně patrona.
3. **Sekundární akce** — Neevidováno.
4. **Výstup** — Neevidováno. **Assumed** výstup přes globální navigaci v headeru, v souladu s
   každou jinou přihlášenou obrazovkou účtu; pro S020 nezávisle nepozorováno.

---

## Stavy

### default
Neevidováno. **Assumed**, na základě analogie se sesterskou obrazovkou dárcovské zóny
`supporter_zone` (`WIRE0018`/`EN0034`): očekává se vykreslení výpisu vlastních žádostí/příběhů
patrona. Složení polí, texty ani vizuální zpracování nejsou pro samotné S020 potvrzeny.

### empty
Neevidováno. `Assumed`: patron bez navázané žádosti by pravděpodobně viděl zprávu o prázdném
stavu, na základě analogie s nulovým výsledkem v dárcovské zóně, ale žádný text ani vizuální
zpracování pro tuto obrazovku není zachyceno. Označeno jako otevřená otázka, nikoli vymyšleno.

### loading
Nezachyceno. `N/A — Evidence Pending`: pro tuto obrazovku nebyl pozorován žádný stav
loading/skeleton (neexistuje pro ni vůbec žádný snímek obrazovky).

### error
Nezachyceno. `N/A — Evidence Pending`: pro tuto obrazovku nebyl pozorován žádný chybový stav
(neexistuje pro ni vůbec žádný snímek obrazovky).

---

## Validační plochy (Validation Surfaces)

Žádná validační plocha není evidována. Pokud je tato obrazovka pouze pro čtení (v souladu s tím,
že sesterský view `supporter_zone` v dárcovské zóně je dle `EN0034` read-only Drupal View), pak by
se neočekávala žádná validace vázaná na BR — to je ale **Uncertain**, nikoli potvrzeno, protože pro
samotný `patron_zone` nebyl posouzen žádný záznam ani controller.

| Pole/Zóna | Trigger (BR-id) | Plocha |
|---|---|---|
| (neevidováno) | nenalezeno | Uncertain — žádné pole ani akce na této obrazovce nejsou evidovány jako uživatelsky editovatelné; žádné `BRxxxx` se nepoužije |

`validationsWithoutBR`: zda patron zóna vůbec nabízí nějaké editovatelné pole nebo akci, je samo o
sobě nevyřešeno (viz Mezery v evidenci / Otevřené otázky) — zaznamenáno jako otevřená otázka, nikoli
jako konkrétní mezera ve validaci, protože pro tuto obrazovku není potvrzena ani existence žádného
pole.

---

## Datové vazby (Data Bindings)

| Zóna | EN-id | QUERY-id | Poznámky |
|---|---|---|---|
| Main — výpis žádostí/příběhů | `EN0001` (Application) | none | **Assumed** — sesterský Drupal View `patron_zone` má `base_table: application` (`EN0034`, řádek 60), z čehož plyne, že řádky jsou čerpány ze záznamů žádostí omezených na aktuálního uživatele s rolí patrona; skutečná projekce polí (které atributy žádosti jsou zobrazeny) **není evidována** — na rozdíl od `supporter_zone`, jehož přesná dvousloupcová projekce (`campaign`, sečtená `price`) je potvrzena, seznam polí `patron_zone` nebyl v této etapě prošetřen/potvrzen |
| Main — zobrazované informace o patronovi (pokud existují) | `EN0005` (Patron) | none | **Uncertain** — `EN0005` je veřejně zobrazovaný profil patrona na stránce kampaně, odlišný od role patrona přiřazené uživateli; zda tato self-service zóna zobrazuje pole `EN0005` (vs. pouze řádky žádostí `EN0001`), není evidováno |

---

## Podmíněná viditelnost (Conditional Visibility)

| Komponenta/Zóna | Podmínka (odkaz na ACL nebo BR) | Chování při skrytí |
|---|---|---|
| Celá obrazovka | Role-gated pouze pro uživatele s rolí patrona (**Assumed**, na základě analogie s potvrzeným omezením přístupu `role: supporter` u `supporter_zone`, `EN0034`); v této rekonstrukci neexistuje vrstva ACL a žádné omezení role specifické pro `patron_zone` nebylo nezávisle potvrzeno (`IA-patronus.md` IA-Q4) | Neevidováno — chování pro přihlášeného uživatele bez role patrona (403 vs. přesměrování vs. skrytá položka navigace) je **Uncertain** |
| Položka navigace "Můj účet"/account-zone vedoucí na tuto obrazovku | Stejná podmínka role-gate | Neevidováno, zda je položka navigace samotná podmíněně zobrazena pouze uživatelům s rolí patrona, nebo je zobrazena vždy s vynucením přístupu až na cílové obrazovce | 

---

## Poznámky k přístupnosti

Neevidováno — pro tuto obrazovku neexistuje žádný snímek obrazovky ani markup. Všechny níže
uvedené položky jsou `Assumed` zástupné hodnoty podle osvědčených postupů, nikoli potvrzená
pozorování:

- **Pořadí tabulace:** Assumed shora dolů přes případné řádky výpisu, v souladu se standardním
  markupem seznamu. Nepotvrzeno.
- **Fokus při vstupu:** Uncertain — neevidováno.
- **Fokus při přechodu stavu:** Uncertain — neevidováno (žádný přechod stavu nebyl vůbec
  zaznamenán).
- **Landmarks:** Uncertain — sémantickou strukturu nelze určit bez záznamu.
- **Klávesové zkratky:** Žádné nebyly pozorovány ani se neočekávají nad rámec standardní
  navigace.

---

## Evidence

| Oblast tvrzení | Jistota | Evidence |
|---|---|---|
| Obrazovka existuje, trasa `zona/patron`, screen_id S020 | Probable | `_ar/spec-draft/IA-screen-map.md`, řádek S020; tabulka vstupních bodů `_ar/spec-draft/IA/IA-patronus.md` §4 |
| Obsluhujícím mechanismem je Drupal View `patron_zone`, `base_table: application` | Confirmed (jako doprovodný kontext, pro tuto WIRE etapu nezávisle neověřováno) | `_ar/spec-draft/EN/EN0034_DonorAccountView.md`, řádky 58–63 |
| Rozvržení, komponenty, texty, složení polí | Uncertain / Evidence Pending — nezachyceno | Pro S020 neexistuje žádný snímek obrazovky; v této etapě nebylo prošetřeno žádné vyhrazené YAML view `patron_zone` (uveden pouze jako sesterský kontext v EN0034) |
| Role-gate (vyžadována role patrona) | Assumed | Na základě analogie s potvrzeným omezením přístupu `role: supporter` u `supporter_zone` (`EN0034`); pro `patron_zone` nezávisle nepotvrzeno — viz `IA-patronus.md` IA-Q4 |
| Realizace UC (`UC0024`) | Probable | `_ar/spec-draft/IA-screen-map.md` přiřazuje `UC0024` obrazovce S020 s jistotou "Assumed"; `UC0024` samotný dokumentuje zobrazení/úpravu profilu (UC0024.1/.2) a dílčí flow historie darů dárcovské zóny (UC0024.1b), ale **neobsahuje** dílčí flow specifický pro patron zónu — zaznamenáno jako mezera, nikoli tiše vyřešeno |
| Stavy (empty/loading/error) | Evidence Pending — nezachyceno | Pro žádný stav neexistuje evidence ze snímku obrazovky |

---

## Mezery v evidenci

- **Pro `zona/patron` (S020) neexistuje žádný snímek obrazovky ani záznam.** Veškeré detaily
  rozvržení, komponent, textů a stavů v tomto dokumentu jsou `Assumed` na základě analogie se
  sesterskou obrazovkou `zona/darce` (S018, `supporter_zone`) a obecným chromem account-zone —
  nikdy nezávisle nepozorováno. Dle `IA-patronus.md` IA-Q4 se jedná o otevřenou IA otázku ("Jaké
  jsou role-gates a skutečné obrazovky pro `zona/zadatel` (S019) a `zona/patron` (S020)?").
- **`UC0024` neobsahuje dílčí flow specifický pro patron zónu.** UC0024.1/.2 pokrývají
  zobrazení/úpravu profilu; UC0024.1b pokrývá projekci historie darů podle příběhu v dárcovské
  zóně (`supporter_zone`). Žádný obdobný dílčí flow nedokumentuje, co view `patron_zone` skutečně
  projektuje (seznam polí, filtry, rozsah argumentů) — tento WIRE nemůže pro svou vazbu hlavního
  obsahu citovat žádný krok UC nad rámec přiřazení UC v IA mapě obrazovek. Doporučuje se
  návazný krok u UC0024 (nebo nový UC) poté, co bude dostupná konfigurace view `patron_zone` a
  případný záznam obrazovky pro patrona. Označeno jako `validationsWithoutBR` / otevřená otázka
  místo řešení odvozením.
- **Mechanika role-gate není potvrzena.** Zda `patron_zone` (podobně jako `supporter_zone`)
  používá `access: type: role` omezené na konkrétní roli (např. roli `patron` u uživatele
  `EN0008`), nebylo v této etapě nezávisle ověřeno — zaznamenáno zde jako Assumed, v souladu s
  tím, že `EN0034` sama zahrnuje `patron_zone` pouze jako doprovodný kontext "out of scope".
- **Ekvivalence pro RO/MD není známa** — v souladu s tím, že sesterská views
  `supporter_zone`/`fundraiser_zone` jsou rozdělena pouze konfiguračně pro CZ (`EN0034`, mezera v
  evidenci č. 2); pro `patron_zone` v této etapě samostatně nezkoumáno.

## Otevřené otázky

1. Co skutečně projektuje Drupal View `patron_zone` (pole, filtry, rozsah argumentu aktuálního
   uživatele, přístupová role) — analogicky k potvrzenému dvousloupcovému kontraktu
   (Kampaň, sečtená cena) u `supporter_zone`? V této etapě neprošetřeno. Rozhodovatel: architekt
   (návazný krok na `views.view.patron_zone.yml`).
2. Je tato obrazovka zařazena do stejné oblasti "Můj účet" jako S018/S019, nebo se jedná o zcela
   samostatnou role-gated stránku s vlastním chromem? Přeneseno z `IA-patronus.md` IA-Q2/IA-Q4,
   nevyřešeno.
3. Měl by být pro kontrakt čtení dat patron zóny vytvořen vyhrazený dílčí UC flow (nebo nový UC),
   jakmile bude evidence dostupná, místo aby tento WIRE citoval `UC0024` bez odpovídajícího
   dílčího flow? Rozhodovatel: UX-lead + architekt (nové zachycení / návazný krok na kódu).
