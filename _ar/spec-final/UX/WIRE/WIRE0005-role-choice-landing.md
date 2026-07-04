---
doc_id: WIRE0005
title: Role Choice Landing
canonical_layer: WIRE
spec_type: wireframe
modules: []
screen_id: S006
realizes_uc: [UC0001]
status: canonical
references:
  - UC0001
  - EN0001
  - IA-patronus (S006, IA-Q1, IA-Q12)
---

# WIRE0005 – Přistávací stránka výběru role

## Účel

**WIRE s čekající evidencí — pro tuto obrazovku nebyl zachycen žádný screenshot.** Tento dokument
rekonstruuje S006 pouze z nepřímých důkazů: mapy obrazovek IA, twig šablony, která vykresluje její dva
odchozí odkazy, a toku UC0001, který tato obrazovka zahajuje. Nelze jej chápat jako vizuální
rekonstrukci; zaznamenává, co lze odvodit, a vše ostatní označuje jako otevřenou otázku.

S006 je vstupní bod do procesu podání žádosti (Application/Žádost), na který se lze dostat z nav CTA
"Požádat o pomoc" a z odkazu v patičce "Chci přihlásit příběh" (`_ar/spec-draft/IA/IA-patronus.md` §2).
Jejím úkolem je umožnit anonymnímu návštěvníkovi zvolit, která ze dvou rolí v procesu podání se na něj
vztahuje — "pomoci svému dítěti" (fundraiser/žadatel) vs. "pomoci dítěti, které znám" (patron) — před
vstupem do UC0001.1 (samoobslužná registrace klienta). Výběr nastaví atribut `lead_role`
(`patron` / `fundraiser`) žádosti `EN0001` při jejím vytvoření. Aktér: anonymní návštěvník (klient,
před registrací).

**Samotná identita obrazovky je Nejistá.** Neexistuje žádný screenshot, který by zobrazoval vykreslenou
stránku; její existence je odvozena z Drupal twig šablony, která generuje dva pevně zakódované odchozí
odkazy, nikoli ze zachycené stránky. Viz `_ar/spec-draft/IA/IA-patronus.md` IA-Q1 (URL této obrazovky:
`/zadost`? `/pozadat-o-pomoc`? oba jsou aliasem jednoho view?) a
`_ar/evidence/gap-closure-evidence.md` OQ-01.

---

## Rozvržení zón (Layout Zones)

Evidence Pending — pro tuto obrazovku neexistuje žádný screenshot; rozvržení níže je Předpokládané
(Assumed), odvozené pouze ze dvou odkazů na karty rolí nalezených v
`web/themes/custom/patron_cz/templates/views/views-view--supporter-zone.html.twig:162-179`
(citováno v `_ar/evidence/gap-closure-evidence.md` OQ-01) plus vzoru globálního chromu pozorovaného na
všech ostatních zachycených veřejných obrazovkách (`_ar/evidence/ui/ui-observed-areas.md` §1, §6).

- Header — globální navigace webu ("Požádat o pomoc", "Můj účet", "Jak to funguje", "Blog", "O nás") —
  Předpokládaná přítomnost na základě celoplošného vzoru; na této obrazovce samotné nezachyceno.
- Hlavní obsah — dvě karty pro výběr role, vedle sebe nebo pod sebou:
  - Karta A: "pomoci svému dítěti" (role fundraiser/žadatel) → odkazuje na `/zadost/zadatel` (S007)
  - Karta B: "pomoci dítěti, které znám" (role patron) → odkazuje na `/zadost/patron` (podání pro
    patrona, nezachyceno)
  (Text/popisky karet tak, jak jsou vykreslené v češtině, nejsou doslovně podloženy důkazy — twig
  evidence uvádí cíle odkazů a anglický volný překlad "I want to help my child" / "I want to help a
  child I know"; viz `_ar/evidence/gap-closure-evidence.md` OQ-01. Přesný český text karet:
  Evidence Pending — vrstva COPY.)
- Sidebar — nepodloženo; Předpokládaná absence (vzor postranního panelu nebyl pozorován nikde jinde
  v zachycených veřejných částech webu).
- Footer — globální patička webu (sbírkový účet, shluk odkazů v patičce) — Předpokládaná přítomnost na
  základě celoplošného vzoru (`_ar/spec-draft/IA/IA-patronus.md` §2); na této obrazovce samotné
  nezachyceno.

```
+--------------------------------------------------+
| Header (global nav)                     [Assumed]|
+--------------------------------------------------+
|         Main content                              |
|   +----------------+   +----------------+         |
|   | Card: fundraiser|  | Card: patron    |         |
|   | -> /zadost/zadatel| | -> /zadost/patron|        |
|   +----------------+   +----------------+         |
+--------------------------------------------------+
| Footer (global)                          [Assumed]|
+--------------------------------------------------+
```

---

## Použité komponenty

Všechny položky označené jako `inline` — vrstva COMP pro tento rekonstrukční průchod ještě neexistuje.

| Zóna | COMP-id | Varianta/vlastnosti | Poznámky |
|---|---|---|---|
| Header | inline | globální navigace webu | Předpokládaná přítomnost; na této obrazovce nezachyceno; vzor z `ui-observed-areas.md` §1 |
| Main — karta A | inline | karta pro výběr role, "fundraiser/žadatel" | Nejistá vizuální forma (karta/tlačítko/dlaždice); podložen je pouze odchozí odkaz + sémantika role |
| Main — karta B | inline | karta pro výběr role, "patron" | Nejistá vizuální forma; stejná výhrada jako u karty A |
| Footer | inline | globální patička webu | Předpokládaná přítomnost; na této obrazovce nezachyceno |

---

## Interakce

1. **Vstup** — návštěvník klikne na "Požádat o pomoc" (navigace) nebo "Chci přihlásit příběh"
   (patička) → stav: `default`. Přesná cesta na S006 samotnou je Nejistá (IA-Q1).
2. **Primární akce — výběr role fundraiser** — kliknutí/tap na kartu A → přejde na
   `/zadost/zadatel` (S007, brána kontakt/souhlas); realizuje `UC0001` (UC0001.1 krok 1,
   role = fundraiser); následující obrazovka: S007.
3. **Primární akce — výběr role patron** — kliknutí/tap na kartu B → přejde na `/zadost/patron`
   (podání pro patrona — obrazovka nezachycena, IA-Q12); realizuje `UC0001` (UC0001.1 krok 1,
   role = patron); následující obrazovka: Nezachyceno.
4. **Výstup** — pro S006 samotnou není podložena žádná akce zrušení/zpět (jde o vstupní přistávací
   stránku, nikoli o krok uvnitř průvodce); vracející se návštěvník z S007 používá "Zpět na výběr"
   pro návrat na S006 (`_ar/evidence/ui/ui-observed-areas.md` §6).

Žádná jiná interakce (vyhledávání, filtrování, sekundární CTA) není pro tuto obrazovku podložena
důkazy. Zda S006 obsahuje ještě nějaký další obsah nad rámec dvou karet rolí (vysvětlující text, FAQ,
důvěryhodnostní prvky) je Nejisté — nepodloženo ani jedním směrem.

---

## Stavy

### default
Zobrazeny dvě karty rolí, obě vybíratelné, žádná předchozí volba není uložena (v důkazech nic
nenasvědčuje chování typu "pamatuj si mou poslední volbu"). Předpokládané — nepotvrzeno screenshotem.

### empty
`N/A — nepoužitelné`. Jde o statickou přistávací stránku pro výběr role s pevnou dvojicí voleb; žádný
datově řízený stav "žádné položky" neexistuje.

### loading
`N/A — Nejisté`. Žádný důkaz asynchronního načítání dat na této obrazovce (cíle obou karet jsou podle
twig evidence pravděpodobně statické routy); pokud by obrazovka skládala jakýkoli dynamický obsah
(např. personalizované pozdravení pro autentizovaného klienta), stav načítání by se uplatnil, ale toto
není podloženo. Zaznamenáno jako otevřená otázka, nikoli jako tvrzení v jednom či druhém směru.

### error
`Evidence Pending — nezachyceno`. Žádný chybový stav není pozorován ani odvoditelný pro obrazovku,
jejíž jedinými akcemi jsou odchozí navigační odkazy; zda samotný výběr role může selhat (např.
blokovaná routa), je Nejisté.

---

## Validační povrchy (Validation Surfaces)

Podle aktuálních důkazů na této obrazovce neexistují žádná pole formuláře — jde o binární přistávací
stránku pro výběr role, nikoli o krok zadávání dat. Žádný validační povrch se neuplatňuje.

| Pole/Zóna | Spouštěč (BR-id) | Povrch |
|---|---|---|
| — | — | N/A — na S006 nejsou podložena žádná pole formuláře |

**validationsWithoutBR:** žádné — podle dostupných důkazů není na této obrazovce co validovat.

---

## Datové vazby (Data Bindings)

| Zóna | EN-id | QUERY-id | Poznámky |
|---|---|---|---|
| Main — výsledek výběru role | `EN0001` | — | Volba provedená zde nastaví atribut `lead_role` (`patron` / `fundraiser`) žádosti `EN0001` v okamžiku jejího vytvoření v rámci `UC0001` (UC0001.1 krok 8); S006 samotná nečte/nezobrazuje data žádosti — pouze zakládá hodnotu role. Žádné QUERY-id není podloženo (za touto obrazovkou nestojí žádný read model). |

---

## Podmíněná viditelnost (Conditional Visibility)

| Komponenta/Zóna | Podmínka (odkaz na ACL nebo BR) | Chování při skrytí |
|---|---|---|
| Celá obrazovka | nepodloženo | Nebylo zjištěno žádné omezení podle role — obrazovka je určena anonymním návštěvníkům (klient, před registrací); `_ar/spec-draft/IA/IA-patronus.md` §9 uvádí, že v této rekonstrukci neexistuje vrstva ACL. Zda je již autentizovaný klient z S006 přesměrován jinam (podle předpokladu `UC0001`: "již autentizovaný klient je směrován přímo do žádosti bez opakování zachycení identity") je Nejisté — na této obrazovce nebylo pozorováno; zaznamenáno jako otevřená otázka, nikoli jako tvrzení. |

---

## Poznámky k přístupnosti (Accessibility Notes)

Evidence Pending — nezachyceno. Neexistuje žádný screenshot, který by potvrdil pořadí tabulace,
chování zaměření (focus), landmark role nebo interakci klávesnicí pro tuto obrazovku. Zaznamenáno
jako otevřená otázka; nevymýšlet.

- **Pořadí tabulace:** Nejisté.
- **Zaměření při vstupu:** Nejisté.
- **Zaměření při přechodu stavu:** Nejisté.
- **Landmarky:** Nejisté.
- **Klávesové zkratky:** nepodloženo.

---

## Evidence

| Oblast tvrzení | Jistota | Evidence |
|---|---|---|
| Obrazovka existuje jako samostatná přistávací stránka pro výběr role | Probable | `_ar/spec-draft/IA-screen-map.md` řádek S006; `_ar/spec-draft/IA/IA-patronus.md` §3.3 |
| Dvě karty rolí ("pomoci svému dítěti" / "pomoci dítěti, které znám") s odkazy na `/zadost/zadatel` a `/zadost/patron` | Confirmed (kód) / Uncertain (vizuál) | `web/themes/custom/patron_cz/templates/views/views-view--supporter-zone.html.twig:162-179`, citováno v `_ar/evidence/gap-closure-evidence.md` OQ-01. Neexistuje žádný screenshot — vizuální rozvržení/text je Předpokládané, nikoli pozorované. |
| Vlastní URL obrazovky | Uncertain | zbytková poznámka `_ar/evidence/gap-closure-evidence.md` OQ-01; `_ar/spec-draft/IA/IA-patronus.md` IA-Q1 |
| Globální chrom navigace/patičky přítomen na této obrazovce | Assumed | vzor z `_ar/evidence/ui/ui-observed-areas.md` §1, §6 (jiné veřejné obrazovky); na S006 samotné nezachyceno |
| Odkaz "Zpět na výběr" na S007 naznačuje, že tato obrazovka jí předchází | Confirmed | `_ar/evidence/ui/ui-observed-areas.md` §6; `_ar/spec-draft/IA/IA-patronus.md` §3.3 |
| Výběr role nastaví `EN0001.lead_role` | Confirmed | `_ar/spec-draft/EN/EN0001_Application.md` atributy; `_ar/spec-draft/UC/UC0001_SubmitApplication.md` UC0001.1 krok 8 |
| Rozvržení zón, stavy (default/empty/loading/error), přístupnost | Uncertain / Assumed | Pro S006 nebyl zachycen žádný screenshot — viz sekce Účel |
