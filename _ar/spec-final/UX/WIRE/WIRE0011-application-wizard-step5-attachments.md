---
doc_id: WIRE0011
title: Application Wizard Step5 Attachments
canonical_layer: WIRE
spec_type: wireframe
modules: []
screen_id: S008e
realizes_uc: [UC0001]
status: canonical
references:
  - UC0001
  - EN0001
  - EN0002
  - IA-patronus (S008e, IA-Q5)
---

# WIRE0011 – Krok 5 průvodce žádostí – Přílohy

## Účel

Krok 5 ("Přílohy") — poslední krok 5krokového průvodce Žádostí (Application) na `/zadost-formular`.
Žadatel (fundraiser, dle `UC0001`) nahrává povinné obrazové/dokumentové přílohy potřebné ke zveřejnění
příběhu dítěte a k ověření identity: alespoň jeden obrázek dítěte (fotografie, kresba dítěte, nebo
vyfotografovaný vzkaz), fotografii dokladu totožnosti žadatele a fotografii/kopii rodného listu dítěte
(nebo rozhodnutí soudu o svěření do péče). Krok dále sbírá pole "odkud jste se o nás dozvěděli" a tři
závěrečné souhlasové checkboxy, poté odešle vyplněnou Žádost.
Kontext vstupu: krok se dosahuje ze S008d (krok 4, "Patron") pomocí "Pokračovat"; jde o poslední krok —
jeho primární akce ("Odeslat") je terminální odeslání celého průvodce, realizující `UC0001`. Tato
obrazovka byla dříve zaznamenána v `IA-patronus.md` (IA-Q5), avšak doloženo bylo pouze její označení ve
stepperu; snímky obrazovky použité pro tento WIRE průchod jsou novější a plnější záznam obsahu kroku —
viz Evidence.

---

## Layout Zones (rozvržení zón)

- Header — globální navigace webu ("Jak to funguje", "Blog", "O nás", CTA "Požádat o pomoc", "Můj
  účet"). Confirmed.
- Stepper — 5krokový indikátor postupu (Příběh ✓ / Dar ✓ / O Vás ✓ / Patron ✓ hotovo — **Přílohy**
  aktivní, zobrazeno jako číslovaný kruh "5"). Confirmed.
- Titulek stránky + úvod + odkaz zpět — nadpis "Krok 5: Přílohy a fotografie"; jednoodstavcová instrukce
  vysvětlující dvě povinné kategorie příloh (fotka dítěte, doklad totožnosti + rodný list); odkaz "← Krok
  zpět" nad kartou formuláře. Confirmed.
- Hlavní obsah (karta formuláře) — tři pod sebou umístěné sekce pro nahrávání, každá s nadpisem,
  instruktážním textem a dropzónou zobrazující označené náhledové obrázky "PŘÍKLAD" (example); pod nimi
  rozbalovací nabídka zdroje doporučení, tři souhlasové checkboxy a tlačítko pro odeslání "Odeslat".
  Confirmed.
- Modální okno s potvrzením odchodu (overlay) — spouští se nezávisle na vlastních prvcích tohoto kroku
  (viz Open Question níže); nabízí "Zpět do žádosti" / "Opustit žádost" / "Smazat žádost". Confirmed
  jako samostatný overlay stav.
- Footer — lišta se souhlasem s cookies, sloupce s odkazy v patičce webu (Patron dětí / Kontakt), odznaky
  poskytovatelů plateb, číslo sbírkového účtu, copyright. Confirmed.

```
+--------------------------------------------------------------+
| Header (nav, Požádat o pomoc, Můj účet)                       |
+--------------------------------------------------------------+
| Stepper: (1 Příběh done)-(2 Dar done)-(3 O Vás done)-          |
|          (4 Patron done)-(5 Přílohy active)                    |
+--------------------------------------------------------------+
| Krok 5: Přílohy a fotografie                    [← Krok zpět] |
| Pro zveřejnění příběhu... nahrajte fotografii... a dvě povinné |
| přílohy: občanský průkaz a rodný list dítěte.                  |
+--------------------------------------------------------------+
| Povinné obrazové přílohy                                       |
| Každý příběh musí obsahovat alespoň jeden obrázek... (1/2/3)   |
| [ dropzone: "Sem přetáhněte soubory... nebo vyberte v počítači" |
|   PŘÍKLAD  PŘÍKLAD                                    0 / 5 ]  |
|                                                                  |
| Fotka Vašeho dokladu totožnosti s fotkou (občanský průkaz, pas):|
| [ dropzone                                                      |
|   PŘÍKLAD  PŘÍKLAD                                    0 / 2 ]  |
|                                                                  |
| Fotka nebo kopie rodného listu dítěte, případně rozhodnutí      |
| soudu o svěření do péče.                                        |
| [ dropzone                                                      |
|   PŘÍKLAD                                             0 / 2 ]  |
|                                                                  |
| Odkud jste se dozvěděli o projektu Patron dětí?  [dropdown v]  |
| [ ] Prohlašuji, že jsem uvedl/a přesné, pravdivé a úplné údaje. |
| [ ] Prohlašuji, že jsem se seznámil/a s pravidly poskytování... |
| [ ] Souhlasím se zpracováním osobních údajů.                    |
|                                                        [Odeslat]|
+--------------------------------------------------------------+
| Footer (cookie bar, links, payment badges, copyright)           |
+--------------------------------------------------------------+
```

---

## Components Used (použité komponenty)

Opakující se prvky povýšené na COMP pomocí **AR:COMPSynthesizer** (viz `COMP-inventory-map.md`);
všechny ostatní záznamy zůstávají označeny `inline` (nebyla doložena opakovaná použití na ≥2
obrazovkách).

| Zóna | COMP-id | Varianta/Props | Poznámky |
|---|---|---|---|
| Header | COMP0002 | context=public | viz `COMP0002` Global Site Header |
| Stepper | COMP0005 | activeIndex=5, completedIndices=[1,2,3,4] | viz `COMP0005` Application Wizard Stepper |
| Odkaz zpět | inline | textový odkaz + ikona šipky | "← Krok zpět". Confirmed. |
| Instruktážní nadpis + text | inline | statický blok textu | Vysvětluje pravidlo povinného obrázku (3 číslované varianty) nad první dropzónou. Confirmed. |
| Dropzóna pro nahrávání souborů | COMP0007 | maxCount=5/2/2, currentCount=0, exampleThumbnails=yes | Tři instance s kapacitami `0/5`, `0/2`, `0/2`. Viz `COMP0007` File Upload Dropzone. |
| Výběr zdroje doporučení | inline | nativní rozbalovací nabídka `<select>`, žádná výchozí volba nevybrána | "Odkud jste se dozvěděli o projektu Patron dětí?". Confirmed. |
| Souhlasový checkbox (×3) | COMP0006 | count-per-form=triple | Odkazy: "přesné, pravdivé a úplné údaje", "pravidly poskytování pomoci", "zpracováním osobních údajů" — cíle odkazů nejsou na této obrazovce doloženy (Uncertain). Viz `COMP0006` Consent Checkbox. |
| Primární tlačítko | COMP0001 | — | "Odeslat" — terminální odeslání celého průvodce. Viz `COMP0001` Primary Button. |
| Modální okno s potvrzením odchodu | inline | overlay dialog: ikona, nadpis "Chystáte se opustit žádost.", text, akce "Zpět do žádosti" (primární) / "Opustit žádost" (textový odkaz), sekundární odkaz "Smazat žádost", ovládací prvek zavření (×) | Confirmed jako overlay stav zachycený na téže routě; ovládací prvek na stránce, který toto modální okno spouští, není viditelný v žádném ze snímků (Open Question — viz Interactions). |
| Footer | COMP0003 | — | viz `COMP0003` Global Site Footer |

---

## Interactions (interakce)

1. **Vstup** — obrazovka se dosáhne pomocí "Pokračovat" ze S008d (krok 4, "Patron"); lze na ni také
   přejít přímo přes stepper, jakmile jsou předchozí kroky dokončeny → stav: `default`. Confirmed
   (stepper při vstupu zobrazuje kroky 1–4 jako hotové zaškrtnutí, krok 5 jako aktivní číslovaný kruh).
2. **Primární akce — nahrání přílohy** — přetažení souborů do dropzóny, nebo kliknutí na "vyberte v
   počítači" → otevře nativní výběr souboru; počet nahraných souborů zvyšuje čítač zóny `n/N` (5 pro
   zónu obrázků, 2 pro zónu dokladu totožnosti, 2 pro zónu rodného listu). Probable (zpracování
   úspěšného nahrání/náhledu nebylo zachyceno — doložen je pouze prázdný stav `0/N` se statickými
   ukázkovými obrázky "PŘÍKLAD").
3. **Sekundární akce — výběr zdroje doporučení** — otevření rozbalovací nabídky "Odkud jste se
   dozvěděli..." a výběr hodnoty. Probable (možnosti nabídky nebyly zachyceny — doložen je pouze
   zavřený/nevybraný stav).
4. **Sekundární akce — přepnutí souhlasového checkboxu** — kliknutím na jeden ze tří checkboxů se
   přijme jeho prohlášení (pravdivost údajů / pravidla platformy / zpracování osobních údajů); vložené
   odkazy otevírají odkazovaný dokument/pravidla v novém kontextu (nedoloženo — cíl nepotvrzen).
   Confirmed (existence checkboxu a nezaškrtnutý stav); chování při otevření odkazu Uncertain.
5. **Sekundární akce — návrat zpět** — kliknutí na "← Krok zpět" → návrat na krok 4 (S008d), se
   zachováním zadaných dat (zachování Assumed — nedoloženo evidencí).
6. **Odchod / terminální odeslání** — kliknutí na "Odeslat" → ověří viditelné povinné přílohy/
   checkboxy, poté odešle vyplněnou Žádost; realizuje `UC0001`; dále: obrazovka s potvrzením po odeslání
   — **v této sadě záznamů nedoložena** (Open Question: žádná obrazovka s potvrzením/poděkováním pro
   průvodce žádostí nebyla zachycena; na rozdíl od `WIRE0003`, která se týká poděkování za dar, nikoli
   za žádost).
7. **Nezávislá interakce modálního okna — výzva k opuštění žádosti** — modální okno s potvrzením
   odchodu ("Chystáte se opustit žádost.") je zachyceno jako overlay nad přesně tímto stavem stránky
   kroku 5, avšak žádný spouštěč na stránce (např. tlačítko zpět/zavřít v prohlížeči, kliknutí na odchod
   z navigace) není viditelný v žádném ze snímků. **Open Question:** která akce na této obrazovce toto
   modální okno spouští (navigace zpět v prohlížeči, neviditelný ovládací prvek "×", kliknutí na logo/
   navigaci v hlavičce) je Uncertain. Po zobrazení: "Zpět do žádosti" zavře modální okno zpět do stavu
   `default`; "Opustit žádost" opustí průvodce (koncept žádosti zachován dle textu samotného modálního
   okna, "s výjimkou příloh", tj. dosud nahrané přílohy jsou explicitně uvedeny jako NEzachované);
   "Smazat žádost" je samostatná destruktivní sekundární cesta (zcela smaže žádost — cílový/potvrzovací
   průběh nezachycen); "×" zavře modální okno (stejný efekt jako "Zpět do žádosti", Assumed).

---

## States (stavy)

### default
Všechny tři dropzóny prázdné (`0/5`, `0/2`, `0/2`), zobrazují pouze statické ukázkové náhledy "PŘÍKLAD"
(nikoli reálně nahrané soubory), rozbalovací nabídka zdroje doporučení nevybraná a všechny tři
souhlasové checkboxy nezaškrtnuté. Confirmed —
`screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_23_13.png`.

### empty
Stejné jako `default` pro první návštěvu tohoto kroku (neexistuje samostatný záznam "návrat s
uloženými daty", který by ukazoval předvyplněnou variantu s dříve nahranými přílohami nebo dříve
vybranou hodnotou doporučení). Confirmed — stejný snímek jako `default`; tento záznam JE prázdným
stavem.

### loading
Nezaznamenáno. Žádné zpracování spinneru/skeletonu/deaktivovaného tlačítka nebylo zachyceno pro
probíhající nahrávání souboru nebo přechod odeslání "Odeslat". `N/A — Evidence Pending: pro tuto
obrazovku neexistuje žádný snímek stavu načítání; oba záznamy zobrazují plně vykreslené, klidové
uživatelské rozhraní (jeden bez modálního okna, druhý s modálním oknem pro odchod přes něj).`

### error
Nezaznamenáno. Žádný banner s chybou validace, chyba pole inline, nebo stav s červeným rámečkem nebyl
na této obrazovce zachycen (na rozdíl od pole hesla s červeným rámečkem u S010, doloženo jinde). Zda je
"Odeslat" na straně klienta blokováno při chybějících povinných přílohách/checkboxech, a jak se chyba
zobrazuje, je `N/A — Evidence Pending: pro krok 5 nebylo zachyceno žádné chybné/neplatné odeslání`.
Uncertain.

---

## Validation Surfaces (plochy validace)

| Pole/Zóna | Spouštěč (BR-id) | Zobrazení |
|---|---|---|
| Dropzóna povinných obrazových příloh (obrázek dítěte, 0/5) | žádné BR — viz validationsWithoutBR | Uncertain — instruktážní text uvádí, že "každý příběh musí obsahovat alespoň jeden obrázek", ale žádné inline/chybové vynucení nebylo zaznamenáno |
| Dropzóna fotky dokladu totožnosti (0/2) | žádné BR — viz validationsWithoutBR | Uncertain — instruktážní text uvádí, že tato příloha je povinná ("dvě povinné přílohy"), ale žádné inline/chybové vynucení nebylo zaznamenáno |
| Dropzóna fotky/kopie rodného listu (0/2) | žádné BR — viz validationsWithoutBR | Uncertain — stejně jako výše; povinné dle instruktážního textu, vynucení nezaznamenáno |
| Rozbalovací nabídka doporučení "Odkud jste se dozvěděli..." | žádné BR — viz validationsWithoutBR | Uncertain — povinný/nepovinný stav nezaznamenán |
| Checkbox "Prohlašuji, že jsem uvedl/a přesné, pravdivé a úplné údaje" | žádné BR — viz validationsWithoutBR | Uncertain — odpovídá `EN0002` `agreement_truthfulness`, které EN0002 dokumentuje jako povinné na úrovni entity, ale žádné BR neupravuje vynucení/zobrazení chyby na úrovni obrazovky, a žádná inline chyba nebyla zaznamenána |
| Checkbox "Prohlašuji, že jsem se seznámil/a s pravidly poskytování pomoci" | žádné BR — viz validationsWithoutBR | Uncertain — odpovídá `EN0002` `agreement_rules` (dokumentováno jako nepovinné na úrovni entity); povinný/nepovinný stav na této obrazovce nezaznamenán |
| Checkbox "Souhlasím se zpracováním osobních údajů" | žádné BR — viz validationsWithoutBR | Uncertain — odpovídá `EN0002` `agreement_personal_data` (dokumentováno jako nepovinné na úrovni entity); povinný/nepovinný stav na této obrazovce nezaznamenán |

Žádný dokument `BRxxxx` v `_ar/spec-draft/BR/` v současnosti neupravuje validaci polí na úrovni
průvodce žádostí (podmínku povinné přílohy, vynucení souhlasového checkboxu, nebo požadavek na pole
doporučení při odeslání kroku). `EN0002` (ApplicationProfile) dokumentuje `agreement_truthfulness` jako
povinné na úrovni entity a různá pole `attachement_*`/`attachments_*` jako nepovinná na úrovni entity,
ale ani jedno z toho není pravidlo validace vlastněné BR, a nic z toho nepotvrzuje chování vynucení na
úrovni obrazovky (na straně klienta).

---

## Data Bindings (datové vazby)

| Zóna | EN-id | QUERY-id | Poznámky |
|---|---|---|---|
| Dropzóna povinných obrazových příloh (obrázek dítěte/kresba/vzkaz) | EN0002 | — | `attachement_child_photo` (dle seznamu atributů EN0002); přesné mapování pole na slot mezi sesterskými poli `attachment_1..attachment_6`/`custom_attachment` není evidencí potvrzeno — Assumed korespondence. |
| Dropzóna fotky dokladu totožnosti (doklad žadatele) | EN0002 | — | `attachement_id_copy` (dle seznamu atributů EN0002); Assumed korespondence. |
| Dropzóna fotky/kopie rodného listu dítěte | EN0001 / EN0002 | — | Kód potvrzuje, že tento krok odpovídá "přílohám/registraci zaměstnání" dle `IA-patronus.md` IA-Q5 (`attachments_employment_registration` na EN0002, nebo obecné pole `attachments` na EN0001); slot specifický pro rodný list není potvrzen samostatným názvem pole — Uncertain mapování pole na atribut. |
| Rozbalovací nabídka "Odkud jste se dozvěděli o projektu Patron dětí?" | EN0002 | — | Na seznamu atributů EN0002 nebyl nalezen žádný odpovídající název atributu; toto pole je Uncertain — případně jde o data zdroje leadu na úrovni `EN0001` (UC0001 krok 8 zaznamenává "zdroj leadu" na Žádosti) nebo o nemodelovaný atribut. Open Question. |
| Checkbox "Prohlašuji... přesné, pravdivé a úplné údaje" | EN0002 | — | `agreement_truthfulness`. |
| Checkbox "Prohlašuji... pravidly poskytování pomoci" | EN0002 | — | `agreement_rules`. |
| Checkbox "Souhlasím se zpracováním osobních údajů" | EN0002 | — | `agreement_personal_data`. |
| Odeslání "Odeslat" → vytvoření/dokončení Žádosti | EN0001 | — | Poslední krok průvodce; realizuje `UC0001` (Žádost (EN0001) dosáhne odeslaného/dokončeného stavu — přesná hodnota přechodu stavu je vlastněna UC0001/EN0001, zde není opakována). |

---

## Conditional Visibility (podmíněná viditelnost)

Na této obrazovce nebylo zaznamenáno žádné podmiňování dle role ani podmíněná viditelnost pole (jde o
součást anonymního/samoregistračního toku fundraisera dle `UC0001`, stejně jako S008a–S008d); vrstva
ACL v této rekonstrukci neexistuje. Všechny tři sekce pro nahrávání, rozbalovací nabídka doporučení a
všechny tři souhlasové checkboxy jsou v obou záznamech zobrazeny bezpodmínečně.

| Komponenta/Zóna | Podmínka (ref ACL nebo BR) | Chování při skrytí |
|---|---|---|
| (nezaznamenáno žádné) | — | — |

---

## Accessibility Notes (poznámky k přístupnosti)

- **Pořadí tabulátoru:** Uncertain — nepotvrditelné ze statických snímků obrazovky; vizuálně naznačuje
  navigaci hlavičky → odkaz zpět → dropzóna 1 (odkaz pro spuštění nahrávání) → dropzóna 2 → dropzóna 3 →
  rozbalovací nabídka doporučení → souhlasové checkboxy shora dolů → tlačítko Odeslat, ale skutečné
  pořadí v DOM/tabulátoru není ověřeno.
- **Fokus při vstupu:** Uncertain — nedoloženo.
- **Fokus při přechodu stavu:** Uncertain — nebylo zaznamenáno žádné chování fokusu při úspěšném
  nahrání nebo přepnutí checkboxu. Pro modální okno s potvrzením odchodu se předpokládá, že se fokus při
  otevření přesune do dialogu (má viditelné zavření "×" a dvě primární akce), ale toto je Assumed,
  nepotvrzeno evidencí.
- **Landmarks:** Uncertain — nedoloženo ze snímků obrazovky (vyžadovalo by kontrolu DOM/kódu, což je
  mimo rozsah tohoto WIRE průchodu dle konvence evidence pouze ze snímků obrazovky).
- **Klávesové zkratky:** Žádné nezaznamenány; evidence chybí v obou směrech. Chování zavření modálního
  okna s potvrzením odchodu klávesou Escape je Assumed (standardní vzor modálního okna), nepotvrzeno.

---

## Open Questions (otevřené otázky)

- Co skutečně spouští modální okno s potvrzením odchodu "Chystáte se opustit žádost." na této
  obrazovce? Žádný ovládací prvek na stránce, který by ho otevíral, není viditelný v žádném ze záznamů
  (viz Interactions §7).
- Váže se "Odkud jste se dozvěděli o projektu Patron dětí?" na dokumentovaný atribut `EN0002`/`EN0001`,
  nebo jde o nemodelované pole? Ve vrstvě EN nebyl nalezen žádný odpovídající název atributu.
- Jsou tři dropzóny pro nahrávání a tři souhlasové checkboxy skutečně povinné pro odeslání, a jak se
  zobrazuje chyba chybějící povinné přílohy/souhlasu? Nezaznamenáno (viz Validation Surfaces).
- Jak vypadá obrazovka s potvrzením/poděkováním pro průvodce žádostí po "Odeslat"? V této sadě
  evidence nezachyceno (odlišné od stránky poděkování za dar, `WIRE0003`).
- Odpovídá dropzóna rodného listu poli `attachments_employment_registration` (název pole, který IA-Q5
  přiřazuje ke kroku 5), nebo jinému atributu přílohy EN0002? Popisek na obrazovce ("rodný list dítěte")
  neodpovídá zjevně názvu pole "registrace zaměstnání" — Conflict mezi názvem pole odvozeným z kódu
  (IA-Q5) a pozorovaným popiskem na obrazovce; vyžaduje vyjasnění.

---

## Evidence (evidence)

| Oblast tvrzení | Jistota | Evidence |
|---|---|---|
| Layout zones, stepper (krok 5 aktivní, kroky 1–4 hotové), titulek stránky, úvodní text | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_23_13.png` |
| Tři dropzóny pro nahrávání, popisky, kapacity (0/5, 0/2, 0/2), ukázkové náhledy "PŘÍKLAD" | Confirmed | stejný snímek obrazovky |
| Rozbalovací nabídka doporučení, tři souhlasové checkboxy, tlačítko "Odeslat" | Confirmed | stejný snímek obrazovky |
| Modální okno s potvrzením odchodu (overlay na téže stránce kroku 5) | Confirmed (jako overlay stav) | `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_23_21.png` |
| Spouštěč na stránce pro modální okno s potvrzením odchodu | Uncertain | nezviditelněno v žádném ze snímků obrazovky |
| Zpracování úspěšného nahrání/náhledu po přidání reálného souboru | Probable | nezachyceno — doložen je pouze prázdný stav `0/N` |
| Přesné mapování pole na atribut EN0002 (přílohy, pole doporučení) | Assumed / Uncertain | odvozeno ze seznamu atributů `EN0002` a `IA-patronus.md` IA-Q5; nejde o potvrzené 1:1 mapování s kódem |
| stav loading | N/A — Evidence Pending | žádný záznam neexistuje |
| stav error / neúspěšná validace | Uncertain | žádný záznam neexistuje |
| Přístupnost (pořadí tabulátoru, fokus, landmarks) | Uncertain | nedoloženo snímky obrazovky |
| Předchozí záznam IA této obrazovky jako "pouze stepper, pole nezachycena" | nahrazeno tímto průchodem | `_ar/spec-draft/IA/IA-patronus.md` §3.3/§8 IA-Q5, `_ar/evidence/ui/ui-observed-areas.md` řádek 151 — oba předcházejí dvěma zde použitým snímkům obrazovky, které zobrazují plný obsah kroku 5 |
