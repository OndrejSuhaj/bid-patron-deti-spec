---
doc_id: WIRE0008
title: Application Wizard Step2 Gift
canonical_layer: WIRE
spec_type: wireframe
modules: []
screen_id: S008b
realizes_uc: [UC0001]
status: canonical
references:
  - UC0001
  - EN0001
  - EN0002
  - EN0033
  - IA-patronus (S008b, IA-Q5)
---

# WIRE0008 – Průvodce žádostí, krok 2 – Dar

## Účel

Krok 2 ("Dar, kterým vám pomůžeme") 5krokového průvodce žádostí (Application/Žádost) na
`/zadost-formular`. Žadatel (fundraiser, dle `UC0001`) vybírá, jaká kategorie věcného daru/pomoci je
pro dítě požadována, a doplňuje detaily specifické pro danou kategorii potřebné k popisu a vyčíslení
tohoto daru — kontakt na dodavatele/organizátora, volnou textovou odpovědi na odůvodnění, přílohu s
podkladovým dokumentem a celkovou částku. Vybraná `gift_category`/`gift_subcategory` a zde vyplněná
pole se zapisují do `ApplicationProfile` žadatele (`EN0002`) a klasifikují `Application` (`EN0001`)
prostřednictvím taxonomie `GiftCategory` (`EN0033`). Kontext vstupu: obrazovka se dosahuje z S008a
(krok 1, "Váš příběh") přes "Pokračovat"; výstup vede na S008c (krok 3, "Údaje o vás"). Confirmed —
screenshot evidence.

---

## Zóny layoutu

- Header — globální navigace webu ("Jak to funguje", "Blog", "O nás", CTA "Požádat o pomoc", "Můj
  účet"). Confirmed.
- Stepper — 5krokový indikátor průběhu (Příběh ✓ hotovo / **Dar** aktivní / O Vás / Patron / Přílohy),
  každý krok je označen a očíslován. Confirmed.
- Titulek stránky + odkaz zpět — nadpis "Krok 2: Dar, kterým vám pomůžeme"; odkaz "← Krok zpět" nad
  kartou formuláře. Confirmed.
- Hlavní obsah (karta formuláře) — seznam pro výběr kategorie "Rychlá volba daru:", následovaný
  svislým sledem polí formuláře, která se mění podle zvolené kategorie, zónou pro přílohy, polem
  celkové částky a tlačítkem pro odeslání "Pokračovat". Confirmed.
- FAQ — sekce akordeonu "Často kladené otázky" pod kartou formuláře. Confirmed (viditelná jedna
  sbalená otázka: "Proč vyžadujeme po všech obdarovaných důkaz o tom, jak dar využívají?" — obsah po
  rozbalení nezachycen).
- Footer — lišta se souhlasem s cookies, sloupce odkazů v patičce webu (Patron dětí / Kontakt),
  odznaky poskytovatelů plateb, číslo sběrného účtu, copyright. Confirmed.

```
+--------------------------------------------------------------+
| Header (nav, Požádat o pomoc, Můj účet)                       |
+--------------------------------------------------------------+
| Stepper: (1 Příběh done) — (2 Dar active) — 3 — 4 — 5          |
+--------------------------------------------------------------+
| Krok 2: Dar, kterým vám pomůžeme            [← Krok zpět]      |
+----------------------------------------------------------------+
| Rychlá volba daru:                                              |
|  [ ŠVP, jazykový kurz, školní výlety      Více informací  Vybrat] |
|  [ Lyžařský kurz                          Více informací  Vybrat] |
|  [ Kroužky, soustředění a vybavení pro ně Více informací  Vybrat] |
|  [ Tábory – pobytové, příměstské          Více informací  Vybrat] |
|  [ Školné a internát                      Více informací  Vybrat] |
|  [ Notebook                               Více informací  Vybrat] |
|  [ Automobil jako zdravotní pomůcka       Více informací  Vybrat] |
|  [ Pomůcky a služby pro zdravotně znevýh. Více informací  Vybrat] |
|  [ Balík školních potřeb                  Více informací  Vybrat] |
|                                                                  |
|  Název a adresa školy poskytující aktivity  [____________]      |
|  Kontaktní osoba                            [____________]      |
|  Telefonní číslo na kontaktní osobu   [+420][____________]      |
|  E-mail na kontaktní osobu                  [____________]      |
|  Jak dar dítěti konkrétně pomůže?     [textarea........] 0/500  |
|  Zde přiložte přihlášku na školní akci ... [drag/drop 0/3]      |
|  Celková částka na pořízení daru      [______] Kč               |
|                                              [Pokračovat →]      |
+----------------------------------------------------------------+
| Často kladené otázky                                            |
+----------------------------------------------------------------+
| Footer (cookie bar, links, payment badges, copyright)           |
+----------------------------------------------------------------+
```

---

## Použité komponenty

Opakující se prvky povýšené na COMP agentem **AR:COMPSynthesizer** (viz `COMP-inventory-map.md`);
všechny ostatní záznamy zůstávají označené jako `inline` (nedoloženo opakované použití na ≥2
obrazovkách).

| Zóna | COMP-id | Varianta/Props | Poznámky |
|---|---|---|---|
| Header | COMP0002 | context=public | viz `COMP0002` Global Site Header |
| Stepper | COMP0005 | activeIndex=2, completedIndices=[1] | Označení kroků: Příběh / Dar / O Vás / Patron / Přílohy. Viz `COMP0005` Application Wizard Stepper. |
| Odkaz zpět | inline | textový odkaz + ikona šipky | "← Krok zpět". Confirmed. |
| Řádek výběru kategorie | inline | sbaleno / rozbaleno | 9 řádků; rozbalený řádek zobrazuje popisný text + "Zobrazit méně". Confirmed. |
| Textové pole | inline | jednořádkové | Použito pro název organizace, kontaktní osobu, e-mail. Confirmed. |
| Pole telefonu | inline | prefix "+420" + číselné pole | Confirmed. |
| Textarea s počítadlem | inline | živé počítadlo `n/500` | "Jak dar dítěti konkrétně pomůže?". Confirmed. |
| Zóna pro přílohy (dropzone) | COMP0007 | maxCount=3, currentCount=0 | viz `COMP0007` File Upload Dropzone |
| Pole měny | inline | numerické + přípona "Kč" | "Celková částka na pořízení daru". Confirmed. |
| Primární tlačítko | COMP0001 | — | popisek "Pokračovat"; viz `COMP0001` Primary Button |
| Akordeon FAQ | inline | výchozí stav sbalený | Viditelná pouze jedna otázka; chování při rozbalení Assumed (rozbalený stav nezachycen). |
| Footer | COMP0003 | — | viz `COMP0003` Global Site Footer |

---

## Interakce

1. **Vstup** — obrazovka se dosahuje přes "Pokračovat" z S008a (krok 1) nebo "Krok zpět" z S008c
   (krok 3); je také přímo dostupná přes stepper, jakmile je krok 1 dokončen → stav: `default`.
   Confirmed (stepper při vstupu zobrazuje krok 1 jako dokončený se zaškrtávacím symbolem).
2. **Primární akce — výběr kategorie daru** — kliknutí na "Více informací" u řádku kategorie → řádek
   se rozbalí na místě a zobrazí popisný text a přeznačí přepínač na "Zobrazit méně"; kliknutí na
   "Vybrat" → zvolí danou kategorii (podkategorii) jako aktivní `gift_category`/`gift_subcategory`
   (`EN0033`) a přeuspořádá blok polí pod výběrem podle `parameters` override této kategorie (názvy
   polí/placeholdery/kardinalita přílohy/další pole) — realizuje `UC0001`; dále: pole níže se znovu
   vykreslí, stále ve stavu `default` této obrazovky. Confirmed (příklad Tábory: pole organizace se
   přeznačí na "Název a adresa organizátora tábora", příloha se přeznačí na "Zde přiložte přihlášku na
   tábor" a přibude pole "V jaké termínu se tábor uskuteční").
3. **Sekundární akce — sbalení detailu kategorie** — kliknutí na "Zobrazit méně" u rozbaleného řádku →
   sbalí se zpět na jednořádkovou podobu. Confirmed (jde pouze o změnu popisku; vizuální výsledek
   sbalení nebyl samostatně zachycen, Assumed že odpovídá stavu řádku před rozbalením).
4. **Sekundární akce — přiložení souborů** — přetažení souborů do zóny pro přílohy, nebo kliknutí na
   "vyberte v počítači" → otevře nativní výběr souborů; počet nahraných souborů zvyšuje počítadlo
   `n/3`. Probable (chování při úspěšném nahrání/zobrazení náhledu nebylo zachyceno — doloženo je
   pouze prázdný stav `0/3`).
5. **Sekundární akce — návrat zpět** — kliknutí na "← Krok zpět" (nahoře), přičemž "Krok zpět" je
   dosažitelný i stejným popiskem pod stepperem dle S008a; návrat na S008a krok 1 se zachováním
   zadaných dat (zachování dat Assumed — evidencí nepotvrzeno).
6. **Výstup / primární odeslání** — kliknutí na "Pokračovat" → validuje viditelnou sadu polí pro
   zvolenou kategorii, poté postoupí na S008c (krok 3, "Údaje o vás"); realizuje `UC0001`; dále:
   S008c. Confirmed pro cíl navigace (pořadí ve stepperu); validační chování při odeslání je Assumed
   (viz Stavy → error).

---

## Stavy

### default
Výběr kategorií zobrazuje všech 9 kategorií sbalených, nadpis "Rychlá volba daru:", a — dle obou
zachycených snímků — blok polí je již vykreslen pod výběrem ještě před explicitním potvrzením
kategorie tlačítkem "Vybrat", předvyplněný obecnou sadou polí první/výchozí kategorie (název
organizace, kontaktní osoba, telefon, e-mail, "Jak dar dítěti konkrétně pomůže?", příloha, celková
částka). Confirmed — screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_20_39.png.

### empty
Shodný se stavem `default` při první návštěvě tohoto kroku: všechna textová/telefonní/e-mailová pole
zobrazují pouze placeholder text (bez hodnot), počítadlo textarea na `0/500`, počítadlo přílohy na
`0/3`, žádná kategorie není rozbalena. Confirmed —
screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_20_39.png (tento snímek JE stavem empty;
`default` a `empty` jsou zde stejný vizuální stav — neexistuje samostatný snímek "návrat s uloženými
daty", který by ukázal předvyplněnou variantu).

### loading
Nezaznamenáno. Pro výběr kategorie, upload souboru ani odeslání kroku nebylo zachyceno žádné
zpracování se spinnerem/skeletonem/deaktivovaným tlačítkem. `N/A — Evidence Pending: pro tuto
obrazovku neexistuje snímek stavu loading; oba snímky zobrazují plně vykreslené, nečinné UI.`

### error
Nezaznamenáno. Na této obrazovce nebyl zachycen žádný banner s chybou validace, chyba v poli ani
červené zvýraznění (na rozdíl od S010, kde je červeně orámované pole hesla zaznamenáno jinde). Zda je
"Pokračovat" blokováno na straně klienta při chybějících povinných polích/souhlasech, a jak je chyba
zobrazena, je `N/A — Evidence Pending: pro krok 2 nebylo zachyceno žádné chybné/neúspěšné odeslání`.
Uncertain.

---

## Plochy validace

| Pole/Zóna | Spouštěč (BR-id) | Plocha |
|---|---|---|
| Textarea "Jak dar dítěti konkrétně pomůže?" | žádný BR — viz validationsWithoutBR | inline (živé počítadlo znaků `n/500`) |
| Zóna pro přílohy | žádný BR — viz validationsWithoutBR | inline (živé počítadlo souborů `n/3`) |
| "Celková částka na pořízení daru" (gift_price) | žádný BR — viz validationsWithoutBR | Uncertain — na této obrazovce nebylo zaznamenáno vynucování chyby/minimální částky (EN0002 uvádí, že existuje spodní hranice minimální ceny, ale neuvádí, kde je vynucována) |
| Výběr kategorie (nutnost zvolit před pokračováním) | žádný BR — viz validationsWithoutBR | Uncertain — nebylo zaznamenáno, zda je "Pokračovat" blokováno bez explicitního kliknutí na "Vybrat" |
| Kontaktní pole telefon / e-mail (formát) | žádný BR — viz validationsWithoutBR | Uncertain — nebyla zaznamenána žádná zpětná vazba k validaci formátu |

Žádný dokument `BRxxxx` v `_ar/spec-draft/BR/` v současnosti neupravuje validaci vstupních polí
průvodce žádostí na úrovni pole (limity počtu znaků/souborů, místo vynucení minimální hodnoty
gift_price, nebo blokování při odeslání kroku z důvodu povinných polí). `EN0002` (ApplicationProfile)
uvádí, že `gift_price` "podléhá omezení minimální cenou", a `EN0033` (GiftCategory) dokumentuje
mechanismus přepisu polí podle kategorie, ale žádný z nich není BR-owned validační pravidlo.

---

## Datové vazby

| Zóna | EN-id | QUERY-id | Poznámky |
|---|---|---|---|
| Výběr kategorie (9 řádků + rozbalení/popis) | EN0033 | — | Taxonomie GiftCategory: pojmy nejvyšší úrovně `category` vykreslené jako řádky; pole `body` je rozbalitelný popisný text. |
| Přeznačování polí podle kategorie (např. Tábory) | EN0033 | — | Řízeno `parameters` override zvolené podkategorie (klíče title/placeholder/cardinality/validate dle EN0033). |
| Pole název organizace / kontaktní osoba / telefon / e-mail | EN0002 | — | volná textová pole dodavatele/kontaktu přiléhající k `ApplicationProfile.gift_supplier` (mapování na úrovni názvu pole evidencí nepotvrzeno; Assumed korespondence s klastrem atributů "požadovaný dar"). |
| Textarea "Jak dar dítěti konkrétně pomůže?" | EN0002 | — | `gift_note` (dle seznamu override-klíčů EN0033: `gift_note` je dokumentovaný přepisovatelný klíč). |
| Zóna pro přílohy | EN0002 | — | jedno z `gift_price_attachment` / `attachment_1..6` (přesné mapování pole na slot evidencí nepotvrzeno). |
| "Celková částka na pořízení daru" | EN0002 | — | `gift_price`. |
| Zvolená kategorie/podkategorie (ukládaná) | EN0002 | — | `gift_category`, `gift_subcategory`. |

---

## Podmíněná viditelnost

| Komponenta/Zóna | Podmínka (odkaz na ACL nebo BR) | Chování při skrytí |
|---|---|---|
| Doplňkové pole specifické pro kategorii (např. "V jaké termínu se tábor uskuteční") | žádné ACL/BR — řízeno kontraktem `EN0033` `parameters.validate`/přepisu pole, nikoli rolí nebo business pravidlem | pole chybí v bloku, dokud není zvolena daná podkategorie |
| Přeznačování polí (názvy organizace/přílohy) | žádné ACL/BR — override `EN0033` `parameters` podle zvolené podkategorie | při absenci záznamu override se použije výchozí popisek z ApplicationProfile |

Na této obrazovce není zaznamenáno žádné omezení podle role (je součástí anonymního/samoregistračního
toku žadatele dle `UC0001`); vrstva ACL v této rekonstrukci neexistuje. Podmíněné chování je zde
řízeno obsahem (konfigurací taxonomie), nikoli přístupovými právy.

---

## Poznámky k přístupnosti

- **Pořadí tabulátoru:** Uncertain — ze statických screenshotů nelze potvrdit; vizuálně naznačuje
  pořadí navigace headeru → odkaz zpět → řádky kategorií (Více informací / Vybrat u každého řádku) →
  pole formuláře shora dolů → ovládání přílohy → pole částky → tlačítko Pokračovat, ale skutečné
  pořadí v DOM/tabulátoru není ověřeno.
- **Focus při vstupu:** Uncertain — nedoloženo.
- **Focus při přechodu stavu:** Uncertain — chování focusu při překreslení/rozbalení-sbalení nebylo
  zachyceno.
- **Landmarks:** Uncertain — ze screenshotů nedoloženo (vyžadovalo by inspekci DOM/kódu, což je mimo
  rozsah tohoto WIRE průchodu dle konvence evidence pouze ze screenshotů).
- **Klávesové zkratky:** Nezaznamenány; evidence chybí v obou směrech.

---

## Evidence

| Oblast tvrzení | Jistota | Evidence |
|---|---|---|
| Zóny layoutu, stepper, struktura výběru kategorie | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_20_39.png` |
| Rozbalení/sbalení kategorie + přeznačování polí podle kategorie (Tábory) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_20_57.png` |
| Popisky polí, placeholdery, počítadla (0/500, 0/3) | Confirmed | oba screenshoty výše; `ui-observed-areas.md` §4 |
| Taxonomie GiftCategory / mechanismus parameters-override | Confirmed (code-level, per EN0033) | `_ar/spec-draft/EN/EN0033_GiftCategory.md` |
| stav loading | N/A — Evidence Pending | žádný snímek neexistuje |
| stav error / neúspěšná validace | Uncertain | žádný snímek neexistuje |
| Přesné mapování datového pole na atribut EN0002 (kontaktní pole/přílohy) | Assumed | odvozeno ze seznamu atributů EN0002 + názvů override-klíčů EN0033; nejde o potvrzené 1:1 mapování v kódu |
| Přístupnost (pořadí tabulátoru, focus, landmarks) | Uncertain | screenshoty nedokládají |
