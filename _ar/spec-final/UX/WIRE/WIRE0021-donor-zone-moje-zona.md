---
doc_id: WIRE0021
title: Donor Zone Moje Zona
layer: WIRE
spec_type: wireframe
modules: []
screen_id: S018
realizes_uc: [UC0024]
status: imported
references:
  - UC0024
  - EN0034
  - EN0009
  - EN0004
  - EN0008
  - IA-patronus
---

# WIRE0021 – Donor Zone Moje Zona

## Účel

**Evidence-Pending.** Obrazovka autentizovaného účtu dárce na `zona/darce` ("Moje zóna"), kde
přihlášená strana s rolí `supporter` zobrazuje historii svých darů seskupenou podle Kampaně
(Příběhu), kterou podpořila. Realizuje `UC0024` podtok UC0024.1b (zobrazení vlastní historie darů
podle podpořeného příběhu) — úplný kontrakt aktéra/systému viz tento UC; tento dokument popisuje
pouze povrch obrazovky, který je rekonstruován z podkladového read-modelu (`EN0034` —
`DonorAccountView`, podložený Drupal Viewem `supporter_zone`) a z mapy IA obrazovek, **nikoliv**
ze zachyceného snímku obrazovky. Žádný snímek této obrazovky neexistuje v `_ar/prtsc/**` ani v
`_ar/evidence/ui/ui-observed-areas.md` (potvrzená absence — viz Evidence). Vstupní kontext:
autentizovaná navigace přes odkaz na účtovou zónu "Můj účet", vyhrazená pro Uživatele s rolí
`supporter` (`EN0034` Invariants; `IA-patronus.md` §3.6, §4).

Bohatší kompozice dashboardu (odpočítávání/stav sběru za jednotlivý příběh, ke stažení potvrzení,
zpětná vazba, rozdělení na záložky "Pro vás / Všechny (67)") je naznačena mockup grafikou vloženou
do nesouvisejícího marketingového e-mailu (`screencapture-mail-google-mail-u-1-2026-07-04-13_32_45.png`),
ale toto je **pouze Hypothesis** — nejde o zachycenou obrazovku, není potvrzeno v kódu (`EN0034`
Evidence Gaps 1, 3; `UC0024` Evidence Pending). Tento WIRE tento mockup **nerekonstruuje** jako
layout této obrazovky; dokumentuje pouze to, co podporuje potvrzený kontrakt polí/filtrů viewu
`supporter_zone`.

---

## Zóny layoutu

**Assumed** — pro tuto obrazovku neexistuje žádný důkaz ve formě snímku obrazovky. Následující zóny
jsou odvozeny výhradně z kontraktu read-modelu `EN0034` (dva projektované sloupce: Kampaň, sečtená
částka) a ze společného chromu webu dokumentovaného jinde v IA; nejsou nezávisle pozorovány.

- **Header (globální navigace)** — Assumed společný chrom konzistentní s ostatními autentizovanými
  obrazovkami účtu (logo, primární navigace, odkaz na účtové menu "Můj účet") podle
  `IA-patronus.md` §2; nespecifické pro tuto obrazovku, nezávisle nepozorováno pro tuto obrazovku.
- **Zóna titulku stránky** — Assumed nadpis "Moje zóna" (titulek stránky Drupal Viewu, podle
  `EN0034` Evidence: `views.view.supporter_zone.yml` titulek stránky "Moje zóna"). **Probable**
  (řetězec titulku stránky je Confirmed v konfiguraci; jeho vizuální vykreslení jako nadpisu je
  Assumed).
- **Hlavní obsah — seznam/tabulka historie darů** — Assumed jeden řádek na každou podpořenou
  Kampaň (Příběh), kde každý řádek zobrazuje popisek Kampaně a kumulativní přispěnou částku
  Uživatele k ní (dvě pole `EN0034`). Přesná vizuální forma (tabulka vs. seznam karet vs. mřížka)
  je **Uncertain — not evidenced**.
- **Footer** — Assumed společný chrom patičky webu podle `IA-patronus.md` §2; nespecifické pro
  tuto obrazovku.

Pro tuto obrazovku nejsou potvrzeny žádné boční panely, struktura záložek, odpočítávání/stav sběru
za jednotlivý příběh, odkazy ke stažení potvrzení ani prvky zpětné vazby (viz Účel — ty patří k
nepotvrzené mockup kompozici, nikoli k tomuto WIRE).

```
+--------------------------------------------------------------+
| Header (Assumed shared chrome) — logo | nav | Můj účet        |
+--------------------------------------------------------------+
| Moje zóna  (Assumed page title)                                |
+--------------------------------------------------------------+
| Main content (Assumed list/table — exact form Uncertain):     |
|   [Campaign A]                          [Suma X Kč]           |
|   [Campaign B]                          [Suma Y Kč]           |
|   ...                                                          |
+--------------------------------------------------------------+
| Footer (Assumed shared chrome)                                 |
+--------------------------------------------------------------+
```

---

## Použité komponenty

Vrstva COMP pro tuto rekonstrukční fázi ještě neexistuje; každý prvek je označen `inline`.
Všechny řádky níže jsou **Assumed**, pokud není uvedeno jinak — neexistuje žádný snímek obrazovky,
který by potvrdil skutečný výběr nebo uspořádání komponent.

| Zóna | COMP-id | Varianta/Props | Poznámky |
|---|---|---|---|
| Header | inline | globální navigace webu + odkaz na účtové menu | Assumed společný chrom, nezávisle nepozorováno pro tuto obrazovku |
| Titulek stránky | inline | H1 | "Moje zóna" — **Probable** (řetězec Confirmed v `views.view.supporter_zone.yml` titulek stránky; zpracování jako nadpis Assumed) |
| Hlavní obsah — řádky historie darů | inline | opakující se řádek: popisek Kampaně + sečtená částka | Dvoupolový řádek podle `EN0034`; vizuální forma (tabulka/seznam/karta) Uncertain — not evidenced |
| Footer | inline | společná patička webu | Assumed společný chrom podle `IA-patronus.md` §2 |

---

## Interakce

**Assumed / Uncertain v celém rozsahu** — pro tuto obrazovku neexistuje žádný snímek obrazovky ani
zachycení toku; následující body jsou odvozeny pouze z narativu `UC0024.1b` a z kontraktu viewu
`supporter_zone`.

1. **Vstup** — autentizovaná navigace na `zona/darce` přes odkaz na účtovou zónu "Můj účet" (route
   potvrzena v `IA-patronus.md` §4, `EN0034` Evidence) → stav: `default`. **Probable** (řetězec
   route je Confirmed v konfiguraci; konkrétní vstupní cesta odkazu/kliknutí je Assumed analogicky
   k sesterským obrazovkám účtu, nezávisle nepozorováno pro tuto konkrétní obrazovku).
2. **Primární akce** — žádná potvrzena. Obrazovka je v rekonstruované podobě **pouze pro čtení**
   (view `supporter_zone` projektuje data; nevystavuje žádnou pozorovanou akci pro zápis/odeslání).
   **Uncertain**, zda každý řádek odkazuje dál na vlastní obrazovku detailu příběhu Kampaně (S002)
   — plausible podle obecné konvence webu, ale pro tento konkrétní view neevidováno.
3. **Sekundární akce** — žádná evidována.
4. **Výstup** — Assumed přes navigaci v headeru (např. zpět na jinou podstránku "Můj účet" nebo
   jakýkoli globální navigační odkaz); u obrazovky pouze pro čtení se neuplatňuje obava z
   neuložených změn. **Uncertain** — nepozorováno.

---

## Stavy

### default
Assumed vykreslení jednoho řádku na každou Kampaň, k níž má aktuální Uživatel alespoň jednu
uhrazenou Transakci s příznakem daru, se sečtenou přispěnou částkou za Kampaň, podle potvrzeného
kontraktu polí/filtrů `EN0034` (`UC0024.1b` kroky 1–3). **Probable** (datový kontrakt je Confirmed
v kódu; vizuální vykreslení je Assumed — nezachyceno na snímku).

### empty
Zobrazí se, když: aktuální Uživatel má roli `supporter`, ale nemá žádnou Kampaň odpovídající
filtru viewu (všechny jeho Transakce jsou bez příznaku daru, neuhrazené nebo jinak vyloučené) —
hraniční případ explicitně nediskutovaný v `UC0024` ani `EN0034`. `Evidence Pending — not captured`:
žádná zpráva pro prázdný stav, ilustrace ani text nejsou evidovány. Poznámka podle `EN0034`
Invariants: dárce s **žádnými** uhrazenými dary by roli `supporter` vůbec nezískal a na tuto
obrazovku by se ani nedostal (viz Podmíněná viditelnost) — takže tento prázdný stav, pokud existuje,
se vztahuje pouze na uvedený užší hraniční případ, nikoli na prvně příchozího návštěvníka.

### loading
`N/A — Evidence Pending`: žádný stav načítání/skeleton nebyl pozorován ani popsán pro počáteční
načtení seznamu; nezachyceno v žádném dostupném důkazu.

### error
`N/A — Evidence Pending`: žádný chybový stav (např. neúspěšné načtení dat) nebyl pozorován ani
popsán v žádném dostupném důkazu.

---

## Validační povrchy

Žádný dokument BR v `_ar/spec-draft/BR/` tuto obrazovku nepokrývá — je rekonstruována jako
**pouze pro čtení** (projekční view bez pozorované akce pro zápis/odeslání), takže se neočekává
žádná validace na úrovni polí.

| Pole/Zóna | Trigger (BR-id) | Povrch |
|---|---|---|
| — | žádné nalezeno | Neuplatňuje se — obrazovka nemá žádná pozorovaná vstupní pole ani odesílací akce; `EN0034` dokumentuje pouze pro čtení projekci bez zapisovatele |

`validationsWithoutBR`: žádné nezjištěno — nebyl nalezen žádný vstupní povrch, který by vyžadoval
validaci. Jde o strukturální absenci (obrazovka pouze pro čtení), nikoli o nevyřešenou validační
otázku.

---

## Datové vazby

| Zóna | EN-id | QUERY-id | Poznámky |
|---|---|---|---|
| Hlavní obsah — řádky historie darů | `EN0034` | none | Projekce `DonorAccountView`: Kampaň (seskupovací klíč, → `EN0004`) + sečtená přispěná částka (`sum(price)` napříč Transakcemi `EN0009`, kde `ext_status = PAID` a `is_donation = 1`), vyhrazeno pro Uživatele `EN0008` aktuální relace přes argument `current_user`. **Confirmed** kontrakt polí/filtrů (`EN0034` Evidence); vykreslení těchto vazeb na úrovni obrazovky je Assumed. |

Zde nejsou navázána žádná pole pro odpočítávání/stav sběru za jednotlivý příběh, odkazy ke stažení
potvrzení (`EN0014`) ani odkazy na zpětnou vazbu (`EN0021`) — `EN0034` je explicitně dokumentuje
jako **not evidenced** v podkladové projekci (pouze mockup; viz `EN0034` Evidence Gaps 1, 3).

---

## Podmíněná viditelnost

| Komponenta/Zóna | Podmínka (odkaz ACL nebo BR) | Chování při skrytí |
|---|---|---|
| Celá obrazovka | Vyžaduje roli `supporter` (pozorované pravidlo přístupu: `type: role`, `role: supporter` v `views.view.supporter_zone.yml`, podle `EN0034` Evidence). Podle `EN0034` Invariants (a `DOMAIN-kernel.md` INV21) je role `supporter` automaticky udělena až po první uhrazené Transakci Uživatele. | V této rekonstrukci neexistuje žádná vrstva ACL (podle `IA-patronus.md` §9); chování pro autentizovaného Uživatele **bez** role `supporter` (např. skrytý navigační odkaz vs. 403/redirect při přímé navigaci) je **Uncertain — not evidenced**. |

---

## Poznámky k přístupnosti

Neevidováno — pro tuto obrazovku neexistuje žádný snímek obrazovky ani zachycení markupu.
Následující body jsou pouze `Assumed` očekávání dle osvědčených postupů, nikoli potvrzená
pozorování:

- **Pořadí tabulace:** Uncertain — not evidenced; obrazovka se seznamem pouze pro čtení může mít
  minimální nebo žádné interaktivní zastávky tabulace mimo navigaci v headeru a případné odkazy
  dál z řádků (pokud takové odkazy existují — Uncertain, viz Interakce).
- **Fokus při vstupu:** Uncertain — not evidenced.
- **Fokus při přechodu stavu:** Uncertain — žádný přechod stavu nebyl zachycen ani popsán.
- **Landmarks:** Uncertain — sémantická struktura (např. `<table>`/`<ul>`, hierarchie nadpisů) není
  bez zachycení určitelná.
- **Klávesové zkratky:** Žádné pozorované ani očekávané.

---

## Evidence

| Oblast tvrzení | Jistota | Evidence |
|---|---|---|
| Obrazovka existuje, route, titulek stránky, brána role, datový kontrakt | Confirmed | `_ar/spec-draft/EN/EN0034_DonorAccountView.md` — `sync_config/config_czech/views.view.supporter_zone.yml` |
| Realizace UC (UC0024.1b) | Confirmed | `_ar/spec-draft/UC/UC0024_ManageDonorAccount.md` §UC0024.1b |
| Zóny layoutu, vizuální uspořádání, přesné komponenty | Assumed | Neexistuje žádný snímek obrazovky; `_ar/evidence/ui/ui-observed-areas.md` nemá záznam pro `zona/darce` / "Moje zóna" |
| Bohatší kompozice dashboardu (odpočítávání, potvrzení, zpětná vazba, záložky) | Hypothesis — explicitně NENÍ potvrzeným layoutem této obrazovky | `screencapture-mail-google-mail-u-1-2026-07-04-13_32_45.png` (vložený mockup e-mailu, nesouvisející marketingový asset) — viz `EN0034` Evidence Gaps 1, 3 a `UC0024` Evidence Pending |
| Stavy prázdný / načítání / chyba | Evidence Pending — not captured | Neexistuje žádný snímek obrazovky ani důkaz toku pro žádný ze tří nedefaultních stavů |
| Validační povrchy | N/A (obrazovka pouze pro čtení) | `EN0034` nedokumentuje žádného zapisovatele pro tuto projekci |
| Vyhrazení role (`supporter`) | Confirmed (backendové pravidlo); Uncertain (viditelné chování na frontendu) | `EN0034` Evidence / Invariants |
| Ekvivalence této obrazovky pro RO/MD | Uncertain | `EN0034` Evidence Gap 2 — view `supporter_zone` nalezen pouze ve splitu `config_czech` |
