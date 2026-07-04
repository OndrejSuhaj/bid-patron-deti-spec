---
doc_id: WIRE0007
title: Application Wizard Step1 Story
canonical_layer: WIRE
spec_type: wireframe
modules: []
screen_id: S008a
realizes_uc: [UC0001]
status: canonical
references:
  - UC0001
  - EN0001
  - EN0002
  - BR-ApplicationStatusGovernance
  - BR-ScoringAndRiskGating
  - BR-PartyIdentityAndDeduplication
---

# WIRE0007 – Krok 1 průvodce žádostí – Příběh

## Účel

Krok 1 ("Krok 1: Váš příběh") 5krokového veřejného průvodce žádostí (Application) na
`/zadost-formular`. Žadatel (role fundraiser — rodič/zákonný zástupce, dle IA `S008a`) zadává
vyprávění o rodině/dítěti a klíčová identifikační pole dítěte, která zakládají fundraiser
`ApplicationProfile` (`EN0002`) na právě vytvořené `Application` (`EN0001`). Na tuto obrazovku se
přechází po braně kontakt/souhlas (`S007`, subflow self-registrace `UC0001`) a je prvním z pěti kroků
navazujících na stejnou orchestraci `UC0001` (Application je vytvořena, profil se progresivně
vyplňuje). V UC vrstvě neexistuje vyhrazený use case "step-1-submit"; samotný postup mezi kroky není
modelován jako UC krok — viz Otevřené otázky. — Confirmed identita/URL obrazovky; Assumed granularita
přiřazení k UC.
Evidence: `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_18_33.png` (prázdný),
`_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_20_29.png` (vyplněný).

---

## Rozvržení zón (Layout Zones)

- **Globální header** — logo webu "patron dětí"; primární navigace ("Jak to funguje", "Blog",
  "O nás"); CTA tlačítko "Požádat o pomoc"; odkaz na účet "Můj účet" — Confirmed. (Cíle navigace
  jsou záležitostí IA vrstvy, zde se neopakují.)
- **Stepper bar** — 5 číslovaných kroků: "1 Příběh" (aktivní/zvýrazněný), "2 Dar", "3 O Vás",
  "4 Patron", "5 Přílohy" — Confirmed.
- **Úvod stránky** — nadpis "Krok 1: Váš příběh"; dva řádky instruktážního textu (pokyny pro více
  dětí; "je nutné vyplnit v češtině") — Confirmed (text je zde uveden doslovně pouze pro
  identifikaci zóny; kompletní copy je záležitostí COPY vrstvy).
- **Odkaz zpět** — "← Krok zpět" nad kartou formuláře — Confirmed.
- **Karta formuláře** (jedna bílá karta, hlavní obsah) — Confirmed:
  - Podzóna A: textarea pro vyprávění o rodině/situaci (výzva "Řekněte nám více o sobě a o své
    rodině…") s počítadlem znaků.
  - Podzóna B: "Dovolte nám vaše dítě lépe poznat" — identifikační pole dítěte (jméno, příjmení,
    rodné číslo/číslo pojištěnce).
  - Podzóna C: jednořádkové textové pole "Jaké je vaše dítě a co má rádo?".
  - Podzóna D: checkbox zdravotního znevýhodnění + podmíněná textarea "konkrétní zdravotní
    problém" s počítadlem znaků.
  - Podzóna E: radio "Mate nebo měli jste sbírku u jiné nadace…" (ANO/NE) + tučný varovný řádek
    o duplicitních sbírkách.
  - Podzóna F: radio "Žádám o pomoc pro dítě, které nemá českou národnost" (ANO/NE).
  - Podzóna G: primární CTA "Pokračovat" (vpravo dole na kartě).
- **Globální footer** — cookie lišta, popis organizace "patron dětí", sloupce odkazů ("Patron
  dětí", sociální sítě; "Kontakt"), odznaky platebních poskytovatelů, číslo sbírkového účtu,
  copyright — Confirmed. (Obsah/odkazy footeru jsou záležitostí IA/COPY vrstvy; zde uvedeno pouze
  jako layoutová zóna.)

```
+--------------------------------------------------------------+
| Global header: logo | nav | "Požádat o pomoc" | "Můj účet"   |
+--------------------------------------------------------------+
| Stepper: (1)Příběh  2 Dar  3 O Vás  4 Patron  5 Přílohy       |
+--------------------------------------------------------------+
| "Krok 1: Váš příběh" (title + 2-line intro)                   |
| "← Krok zpět"                                                  |
+--------------------------------------------------------------+
| Form card:                                                     |
|  [A] Family/situation narrative textarea            0/500     |
|  "Dovolte nám vaše dítě lépe poznat"                           |
|  [B] Jméno | Příjmení   (child)                                |
|  [B] Rodné číslo dítěte (cizinec: číslo pojištěnce)            |
|  [C] Jaké je vaše dítě a co má rádo?                           |
|  [D] [ ] Je Vaše dítě zdravotně znevýhodněné?                  |
|      "S čím se vaše dítě potýká..." textarea         0/500     |
|  [E] Mate nebo měli sbírku u jiné nadace...  (o)ANO (o)NE       |
|      warning line (duplicate collection)                       |
|  [F] Žádám o pomoc pro dítě bez české národnosti (o)ANO (o)NE   |
|                                            [ Pokračovat ]      |
+--------------------------------------------------------------+
| Global footer                                                  |
+--------------------------------------------------------------+
```

---

## Použité komponenty (Components Used)

Opakující se prvky povýšené na COMP nástrojem **AR:COMPSynthesizer** (viz `COMP-inventory-map.md`);
všechny ostatní položky zůstávají označeny `inline` (nebylo prokázáno opakované použití na ≥2
obrazovkách).

| Zóna | COMP-id | Varianta/Props | Poznámky |
|---|---|---|---|
| Globální header | COMP0002 | context=public | viz `COMP0002` Global Site Header |
| Stepper bar | COMP0005 | activeIndex=1, completedIndices=[] | viz `COMP0005` Application Wizard Stepper |
| Odkaz zpět | inline | textový odkaz s glyfem šipky vlevo | Confirmed |
| Textarea pro vyprávění (A) | inline | vícořádková textarea, placeholder text, živé počítadlo znaků "`n / 500`" | Confirmed |
| Pole jméno dítěte (B) | inline | dvě vedle sebe umístěná jednořádková textová pole (Jméno / Příjmení) | Confirmed |
| Pole rodného čísla dítěte (B) | inline | jednořádkové textové pole, duální popisek ("Rodné číslo dítěte (cizinec: číslo pojištěnce)") | Confirmed |
| Pole "Jaké je vaše dítě" (C) | inline | jednořádkové textové pole s placeholderem | Confirmed |
| Checkbox zdravotního znevýhodnění (D) | inline | checkbox + popisek | Confirmed |
| Textarea zdravotního problému (D) | inline | vícořádková textarea, placeholder, počítadlo znaků "`n / 500`", tučná dílčí otázka + pomocný text | Confirmed |
| Radio předchozí sbírky (E) | inline | 2možnostní radio skupina (ANO/NE), výchozí přednastaveno NE | Confirmed |
| Radio národnosti (F) | inline | 2možnostní radio skupina (ANO/NE), výchozí přednastaveno NE | Confirmed |
| Primární CTA | COMP0001 | — | popisek "Pokračovat"; viz `COMP0001` Primary Button |
| Globální footer | inline | cookie lišta + sloupce odkazů + odznaky plateb | Confirmed, mimo rozsah tohoto UC; `COMP0003`/`COMP0004` zde nejsou uplatněny, protože tato zóna byla popsána jako jeden sloučený řádek, nikoli rozdělena původním autorem WIRE — zachováno beze změny, aby se předešlo restrukturaci nad rámec záměny inline→COMP |

---

## Interakce (Interactions)

1. **Vstup** — přesměrování z `S007` (brána kontakt + souhlas `/zadost/zadatel`) na
   `/zadost-formular` po tom, co subflow self-registrace `UC0001` vytvoří `Application` (`EN0001`)
   a fundraiser `ApplicationProfile` (`EN0002`) — stav: `default` (prázdný formulář, dle
   `screencapture-…13_18_33.png`). Confirmed dle IA §5 "Application intake flow".
2. **Primární akce — "Pokračovat"** — spouštěč: kliknutí/tap → efekt: odešle hodnoty polí kroku 1
   (uloženy do polí fundraiser profilu `EN0002`: ekvivalenty vyprávění `story_background`/
   `story_problems`, `child_first_name`, `child_last_name`, `child_rc`, `child_handicapped`
   a dva příznaky ANO/NE — viz Datové vazby) a posune stepper na krok 2 ("Dar", `S008b`) —
   Assumed chování s uložením při pokračování (neprokázáno: žádná dokumentace nepotvrzuje ukládání
   po krocích vs. jednorázové finální odeslání; označeno jako Otevřená otázka níže).
3. **Sekundární akce — "Krok zpět"** — spouštěč: kliknutí → efekt: přechod o krok zpět; cílová
   obrazovka nebyla zaznamenána (krok 1 je první krok, takže se pravděpodobně vrací na `S007`) —
   Uncertain.
4. **Sekundární interakce — checkbox zdravotního znevýhodnění** — přepínání "Je Vaše dítě
   zdravotně znevýhodněné?" je vizuálně sousedící s dílčím popiskem textarea "Má vaše dítě
   specifický zdravotní problém?", ale oba screenshoty ukazují checkbox nezaškrtnutý, přičemž
   dílčí popisek/textarea jsou již vykresleny — Uncertain, zda je textarea podmíněně
   zobrazována/skrývána checkboxem, nebo je vždy viditelná (nebylo zaznamenáno srovnání
   nezaškrtnuto vs. zaškrtnuto).
5. **Výstup (úspěch)** — postup přes "Pokračovat" vede na `S008b` (krok 2, "Dar") — Confirmed
   posloupnost dle IA §5.
6. **Výstup (opuštění)** — zavření/odchod uprostřed průvodce; obnovení řeší samostatný modální
   flow pro obnovu rozpracované žádosti (`UC0025`, `EN0003` `ApplicationSession`) při další
   návštěvě — mimo rozsah této obrazovky, pouze odkázáno.

---

## Stavy (States)

### default
Prázdný formulář s placeholder textem v každém volném textovém poli, oba radio přepínače
přednastaveny na "NE", počítadla znaků na "0 / 500" — Confirmed
(`screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_18_33.png`).

### empty
V evidenci se neliší od `default` — snímek "prázdný" *je* výše popsaný výchozí/nevyplněný stav.
Nebylo zaznamenáno žádné samostatné zpracování stavu bez dat (např. bez předchozího konceptu). —
`N/A — pozorovaný stav "default" již představuje nevyplněný/prázdný formulář; v evidenci
neexistuje samostatný vizuál pro empty stav.`

### loading
Nezaznamenáno v žádném snímku (oba jsou statické, plně vykreslené stavy; nebylo zaznamenáno žádné
zpracování spinneru/skeletonu/deaktivovaného tlačítka během odesílání). —
`Evidence Pending — not captured.`

### error
Nezaznamenáno. Žádný ze screenshotů nezobrazuje validační chybu, inline chybovou zprávu ani
stylování chyby na úrovni pole (např. pro neplatné `Rodné číslo dítěte`, nebo pole příběhu
přesahující 500 znaků — druhý snímek zobrazuje horní textarea pro vyprávění přesně na
"500 / 500" bez chybového/blokujícího stylování, což naznačuje, že počítadlo může být měkký/
informativní limit, nikoli tvrdý strop, ale toto není potvrzeno ani v jednom směru). —
`Evidence Pending — not captured.` — Uncertain, zda je 500 tvrdý max-length (blokující vstup),
nebo měkké počítadlo (validace pouze při odeslání).

---

## Validační plochy (Validation Surfaces)

| Pole/Zóna | Spouštěč (BR-id) | Plocha |
|---|---|---|
| Textarea vyprávění (0/500) | Nenalezeno BR — viz validationsWithoutBR | pouze inline počítadlo znaků; nezaznamenán žádný chybový styl |
| Textarea "S čím se vaše dítě potýká…" (0/500) | Nenalezeno BR — viz validationsWithoutBR | pouze inline počítadlo znaků; nezaznamenán žádný chybový styl |
| "Jméno"/"Příjmení" dítěte (povinné?) | Nenalezeno BR — viz validationsWithoutBR | nezaznamenáno (nebyl zachycen pokus o odeslání prázdného formuláře) |
| "Rodné číslo dítěte" (formát / podmíněná povinnost) | Nenalezeno BR — viz validationsWithoutBR; Otevřené otázky EN0002 označují `child_rc` jako "podmíněně povinné", přičemž samotná podmínka není potvrzena | nezaznamenáno |
| Radio předchozí sbírky (ANO/NE) | Nenalezeno BR — viz validationsWithoutBR | přednastavená výchozí hodnota (NE); nezaznamenán žádný validační stav |
| Radio národnosti (ANO/NE) | Nenalezeno BR — viz validationsWithoutBR | přednastavená výchozí hodnota (NE); nezaznamenán žádný validační stav |
| Brána odeslání "Pokračovat" (která pole blokují postup) | Nenalezeno BR — viz validationsWithoutBR | nezaznamenáno |

Žádné `BRxxxx` v aktuální BR vrstvě (`BR-ApplicationStatusGovernance`, `BR-ScoringAndRiskGating`,
`BR-PartyIdentityAndDeduplication` a zbytek `_ar/spec-draft/BR/_REGISTRY.md`) nepokrývá validaci na
úrovni polí pro vstupy tohoto kroku (znakové limity, povinnost polí, formát rodného čísla). Je to
zaznamenáno jako otevřená otázka, nikoli vymyšlené pravidlo.

---

## Datové vazby (Data Bindings)

| Zóna | EN-id | QUERY-id | Poznámky |
|---|---|---|---|
| Textarea vyprávění o rodině/situaci | `EN0002` (`story_background` / `story_problems` — atributy vyprávění) | — | přesné mapování atributu na pole je Assumed dle shody názvu/účelu, není potvrzeno na úrovni kódu pro toto konkrétní textové pole vs. druhé |
| "Jméno" / "Příjmení" dítěte | `EN0002` (`child_first_name`, `child_last_name`) | — | Confirmed shoda účelu pole |
| "Rodné číslo dítěte (cizinec: číslo pojištěnce)" | `EN0002` (`child_rc`) | — | Confirmed shoda účelu pole; výhrada podmíněné povinnosti dle Otevřených otázek EN0002 |
| "Jaké je vaše dítě a co má rádo?" | `EN0002` — v aktuálním seznamu atributů EN0002 neexistuje odpovídající samostatný atribut pro toto pole | — | Uncertain — pravděpodobně zahrnuto v atributu vyprávění/příběhu, který není jmenovitě uveden, nebo pole ještě v EN0002 nemodelované; označeno jako mezera |
| Checkbox "Je Vaše dítě zdravotně znevýhodněné?" | `EN0002` (`child_handicapped`) | — | Confirmed shoda účelu pole |
| Textarea "S čím se vaše dítě potýká a jakou potřebuje pomoc?" | `EN0002` (`story_problems` nebo `story_solution`) | — | Assumed — nejednoznačné, na který z obou atributů vyprávění se mapuje |
| Radio "Mate nebo měli jste sbírku u jiné nadace…" | `EN0002` — nenalezen odpovídající atribut | — | Uncertain — tento příznak není přítomen v aktuálním inventáři atributů EN0002; mezera mezi pozorovaným UI a rekonstruovanou entitou, zaznamenáno jako Otevřená otázka |
| Radio "Žádám o pomoc pro dítě, které nemá českou národnost" | `EN0002` — nenalezen odpovídající atribut | — | Uncertain — stejná mezera jako výše |
| Kontext Application/session (která `Application`/`ApplicationProfile` se upravuje) | `EN0001`, `EN0002` | — | Confirmed na úrovni entity dle postconditions `UC0001` (Application + fundraiser profil vytvořeny dříve, než je tento krok dostupný) |

---

## Podmíněná viditelnost (Conditional Visibility)

| Komponenta/Zóna | Podmínka (odkaz na ACL nebo BR) | Chování při skrytí |
|---|---|---|
| Celá obrazovka (`S008a`) | Dostupná až po dokončení brány kontakt/souhlas `S007`, která vytvoří Application; dosud neexistuje ACL vrstva, na kterou by bylo možné odkázat roli | N/A — nebylo zaznamenáno jako podmíněné autentizovanou rolí; žadatel je anonymní uživatel přecházející do role registrujícího se Customer dle `UC0001` |
| Odkaz "Krok zpět" | Vždy viditelný v obou snímcích | — |
| Stav textarea zdravotního problému vs. checkbox | Případně podmíněno checkboxem (viz Interakce §4) | Uncertain — nepotvrzeno v žádném směru; neexistuje BR/ACL, na které by bylo možné odkázat |

V tomto rekonstrukčním průchodu neexistuje žádná vrstva `ACLxxxx` (dle rules-WIRE.md a IA-Q4);
u této obrazovky nebylo zaznamenáno žádné omezení na základě role nad rámec dostupnosti dle
posloupnosti průvodce.

---

## Poznámky k přístupnosti (Accessibility Notes)

- **Pořadí tabulátoru:** Nelze prokázat ze statických screenshotů — Assumed, že sleduje vizuální
  pořadí shora dolů, zleva doprava (textarea vyprávění → jméno/příjmení dítěte → rodné číslo →
  "jaké je vaše dítě" → checkbox zdraví → textarea zdravotního problému → radio předchozí sbírky →
  radio národnosti → "Pokračovat"), v souladu se standardní strukturou formuláře, ale nepotvrzeno.
- **Fokus při vstupu:** Uncertain — nezaznamenáno.
- **Fokus při přechodu stavu:** Uncertain — nebyl zaznamenán žádný přechod stavu (loading/error).
- **Landmarks:** Uncertain — sémantická struktura (nadpisy, fieldsety, ARIA role pro stepper)
  nelze určit z vykresleného screenshotu.
- **Klávesové zkratky:** Nezaznamenány; u standardní formulářové obrazovky se ani neočekávají.

---

## Otevřené otázky (Open Questions)

- Ukládá "Pokračovat" data kroku 1 okamžitě (uložení po kroku), nebo pouze při finálním odeslání
  průvodce? Neprokázáno žádným UC/dokumentací — ovlivňuje, zda obnovení rozpracované žádosti
  (`UC0025`) může obnovit data uprostřed kroku 1. (Viz také IA-Q5 pro nevyřešený obsah kroků 4–5
  a IA §5 pro posloupnost kroků průvodce, která to také neřeší.)
- Je checkbox "Je Vaše dítě zdravotně znevýhodněné?" propojen s podmíněným zobrazením/skrytím
  textarea "S čím se vaše dítě potýká…", nebo je textarea vždy vykreslena? Oba snímky ukazují
  checkbox nezaškrtnutý s již viditelnou textarea.
- Příznaky "Mate nebo měli jste sbírku u jiné nadace v posledních 6 měsících?" a "Žádám o pomoc
  pro dítě, které nemá českou národnost" pozorované na obrazovce **nemají odpovídající atribut**
  v rekonstruovaném seznamu atributů `EN0002` ApplicationProfile — zaznamenáno jako mezera na
  rozhraní vrstev EN/WIRE, zde nevyřešeno (kandidát pro navazující úpravu EN0002, nikoli vymyšleno
  v tomto WIRE dokumentu). Podobně "Jaké je vaše dítě a co má rádo?" nemá potvrzenou 1:1 shodu
  atributu. Viz `validationsWithoutBR` níže — pro žádnou validaci na úrovni polí na této obrazovce
  neexistuje BR.
- Zda jsou počítadla "0/500" tvrdé limity `maxlength`, nebo měkké/informativní limity (validace
  při odeslání), není potvrzeno; druhý snímek zobrazuje horní textarea přesně na 500/500 bez
  chybového stylování, což je v souladu s oběma výklady.
- Cíl "Krok zpět" z kroku 1 (zpět na `S007`, nebo jinam) není potvrzen evidencí.

---

## Evidence

| Oblast tvrzení | Jistota | Evidence |
|---|---|---|
| Identita obrazovky, URL, stepper, titulek/úvodní text stránky | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_18_33.png` |
| Popisky polí, pořadí layoutu, výchozí stav (prázdný) | Confirmed | totéž, §3 `_ar/evidence/ui/ui-observed-areas.md` |
| Vizuály vyplněného stavu, počítadla znaků blízko/na limitu, testovací identifikační data | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_20_29.png` (placeholder text "Kafka" = QA šum, nikoli doménový obsah) |
| Mapování pole na atribut EN0002 | Assumed / Uncertain (smíšené, viz Datové vazby) | `_ar/spec-draft/EN/EN0002_ApplicationProfile.md` |
| Přiřazení k UC (`UC0001`) | Confirmed na úrovni IA, Assumed na úrovni granularity kroku | `_ar/spec-draft/IA/IA-patronus.md` §3.3, §5; `_ar/spec-draft/UC/UC0001_SubmitApplication.md` |
| Validační pravidla (znakové limity, povinná pole, sémantika radio přepínačů) | Uncertain — nenalezeno BR | `_ar/spec-draft/BR/_REGISTRY.md` (žádné odpovídající BR) |
| stavy loading / error | Evidence Pending — nezaznamenáno | — |
| stav empty (odlišný od default) | N/A — snímek default je nevyplněný stav | `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_18_33.png` |
