---
doc_id: COMP0006
title: Consent Checkbox
layer: COMP
spec_type: component
modules: []
status: imported
references:
  - WIRE0002
  - WIRE0006
  - WIRE0011
  - WIRE0013
  - EN0006
  - EN0008
---

# COMP0006 – Zaškrtávací pole souhlasu (Consent Checkbox)

## Účel

Zaškrtávací pole spárované s popiskem obsahujícím vložený hypertextový odkaz na právní dokument
(zpracování osobních údajů/GDPR, pravidla poskytování pomoci, podmínky používání účtu) plus
volitelný pomocný text. Používá se vždy, když formulář vyžaduje, aby uživatel před odesláním
potvrdil seznámení s určitou politikou. Vizuální/interakční tvar (checkbox + popisek + vložený
odkaz) se identicky opakuje na nejméně 4 zdokumentovaných obrazovkách WIRE napříč třemi různými
moduly (dar, podání žádosti, aktivace účtu).

## Props / Vstupy

| Název | Typ | Povinné | Výchozí | Popis |
|---|---|---|---|---|
| `checked` | `boolean` | ano | `false` | Stav zaškrtávacího pole; pozorovaná výchozí hodnota je nezaškrtnuto na každé obrazovce kromě předvyplněného modálu daru (`WIRE0002`, testerská data — viz Stavy). |
| `label` | `string \| node` | ano | — | Text popisku obsahující vložený hypertextový odkaz; vlastněno vrstvou COPY, zde neopakováno (např. "Souhlasím se zpracováním osobních údajů a informováním o projektu", "Souhlasím s pravidly poskytování pomoci projektu Patron."). |
| `linkHref` | `string` | ne | — | Cíl vloženého hypertextového odkazu; *cíle* odkazů nejsou na několika obrazovkách doloženy (Uncertain, viz `WIRE0011`). |
| `helperText` | `string` | ne | `none` | Volitelný řádek pod popiskem (pozorováno jednou, `WIRE0006`: "Souhlasy můžete upravit/zrušit zasláním e-mailu na souhlas@patrondeti.cz."). |
| `required` | `boolean` | ne | `Uncertain` | Zda zaškrtávací pole podmiňuje odeslání formuláře; pro žádnou z citujících obrazovek nebyl nalezen dokument BR, který by to podkládal — zaznamenáno v `validationsWithoutBR` každé odkazující WIRE jako otevřená otázka, zde se nic netvrdí. |

## Varianty

- **počet-na-formulář:** jedna (`WIRE0006` brána kontaktu/souhlasu — jedno zaškrtávací pole) | dvě
  (`WIRE0002` modál daru, `WIRE0013` aktivace účtu — dvě zaškrtávací pole, každé s jiným právním
  cílem) | tři (`WIRE0011` krok přílohy — tři zaškrtávací pole: pravdivost údajů, pravidla, osobní
  údaje)

## Stavy

### idle (klidový)
Nezaškrtnuté čtvercové zaškrtávací pole + popisek s podtrženým vloženým odkazem. Confirmed,
kontext `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_18_33.png` (na této
konkrétní obrazovce checkbox není, ale stejná vizuální rodina dle `ui-observed-areas.md` §6/§8/§9).

### checked (zaškrtnuto)
Vyplněné/zaškrtnuté zaškrtávací pole, stejný popisek. Confirmed —
`_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_26_21.png`
zobrazuje obě zaškrtávací pole souhlasu v modálu daru předem zaškrtnutá se zeleným výplněním
(stav vzniklý interakcí testera, nikoli nutně výchozí stav).

### hover (přejetí myší)
`Uncertain — nelze pozorovat ze statických podkladů.`

### focused (zaměření)
`Uncertain — nelze pozorovat ze statických podkladů.`

### disabled (zakázáno)
N/A — v žádném snímku nebylo pozorováno vykreslení v zakázaném stavu.

### loading (načítání)
N/A — synchronní UI prvek, žádné asynchronní chování nebylo doloženo.

### error (chyba)
`Uncertain — žádná obrazovka nezobrazuje vykreslení chyby validace pro nezaškrtnuté povinné pole
souhlasu (např. červený obrys nebo vloženou chybovou zprávu); zda takové vykreslení existuje, není
potvrzeno. Zaznamenáno jako otevřená otázka validace v každé odkazující WIRE (viz např. WIRE0002
§Validation Surfaces).`

## Události

| Událost | Payload | Spouštěč | Poznámky |
|---|---|---|---|
| `onChange` | `boolean` (nový stav zaškrtnutí) | klik uživatele na zaškrtávací pole nebo popisek | Přepíná `checked`. |
| `onLinkClick` | žádný | klik na vložený hypertextový odkaz | Otevírá odkazovaný právní dokument; chování (nová záložka vs. odchod z aktuální stránky a zda se zachová stav zaškrtávacího pole) nebylo doloženo. |

## Přístupnost

- **ARIA role:** `Uncertain` — předpokládá se nativní sémantika `<input type="checkbox">` s přiřazeným `<label>`; nepotvrzeno.
- **Navigace klávesnicí:** `Uncertain` — předpokládá se přepínání klávesou Space dle standardní sémantiky zaškrtávacího pole; nepotvrzeno.
- **Správa zaměření (focus):** `Uncertain`.
- **Čtečka obrazovky:** `Uncertain` — zda je vložený odkaz oznamován samostatně od popisku zaškrtávacího pole, nelze ze snímků obrazovky potvrdit.

## Omezení použití

- Použít když: krok formuláře vyžaduje potvrzení seznámení s konkrétním právním dokumentem před pokračováním.
- Nepoužívat když: souhlas je implicitní/platný pro celý web (→ `COMP0004` Cookie Consent Banner je
  pro tento případ samostatný mechanismus).
- Kardinalita: jedno až tři na formulář, každé vázané na jiný právní cíl (pozorovaný rozsah:
  1–3, žádný doklad o vyšším počtu).
- Umístění: přímo nad tlačítkem `COMP0001` Primary Button formuláře, obvykle poslední prvky
  formuláře před odesláním.

## Závislosti

- Ostatní COMP: žádné jako podkomponenty; obvykle umístěno bezprostředně před `COMP0001` Primary
  Button v rozvržení formuláře (pozorováno pořadí, nikoli kompoziční vztah).
- Datové entity: potvrzení souhlasu konceptuálně souvisí s `EN0006` Contact /
  `EN0008` User (strana udělující souhlas), ale na žádné citující WIRE nebyla doložena potvrzená
  vazba na úrovni atributů — zaznamenáno jako Uncertain, zde se nic netvrdí.
- ACL: žádné doloženo.
- Externí knihovny: žádné doloženo.

## Kompozice

Listová komponenta; žádná kompozice podkomponent COMP. Běžně se opakuje 1–3× uvnitř formuláře
bezprostředně před instancí `COMP0001` Primary Button.

## Příklady

```
ConsentCheckbox checked={true}  label="Souhlasím s pravidly poskytování pomoci projektu Patron." />
ConsentCheckbox checked={true}  label="Souhlasím se zpracováním osobních údajů a informováním o projektu" />
  // WIRE0002 — modál daru, obě instance zaškrtnuty testerem

ConsentCheckbox checked={false} label="Souhlasím se zpracováním osobních údajů a informováním o projektu"
                helperText="Souhlasy můžete upravit/zrušit zasláním e-mailu na souhlas@patrondeti.cz." />
  // WIRE0006 — brána kontaktu/souhlasu, jedna instance, výchozí nezaškrtnuto
```

## Otevřené otázky

- Žádný dokument BR nepodkládá povinnost jakékoli instance této komponenty na jejích 4 odkazujících
  obrazovkách — přeneseno z vlastního seznamu `validationsWithoutBR` každé WIRE, zde neřešeno.
- Vykreslení chybového stavu (nezaškrtnuto, ač povinné) není doloženo vůbec.
- Zda vůbec existuje vazba na entitu (vs. čistě UI příznak souhlasu), je nepotvrzeno.

## Sladění s design systémem (cíl)

Pro tuto komponentu ještě neexistuje kanonický protějšek v `@patron/ui`. Komponenty modálu daru a
toku souhlasu jsou v katalogu design systému odloženy (`_ar/evidence/design-system/components.md`,
`_ar/spec-draft/DESIGN-component-index.md`) — žádný z nich neuvádí primitivu souhlasu/zaškrtávacího
pole zaměřenou na potvrzení právního dokumentu. Tento záznam zůstává pouze current-state (pozorovaný)
do doby, než design systém definuje cílový kontrakt; zde se nepředpokládá žádné mapování na
token/variantu.

## Evidence

| Oblast tvrzení | Jistota | Evidence |
|---|---|---|
| Opakované použití na ≥2 obrazovkách | Confirmed | `WIRE0002`, `WIRE0006`, `WIRE0011`, `WIRE0013` všechny zobrazují tento přesný tvar checkbox+odkazovaný popisek; `WIRE-synthesis-report.md` §6 "Consent checkbox with linked legal-document label" |
| Vizuální stav zaškrtnuto | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_26_21.png` |
| Výchozí stav nezaškrtnuto | Confirmed | narativ `_ar/evidence/ui/ui-observed-areas.md` §6, §8, §9 (checkbox ve výchozím stavu nezaškrtnuto) |
| Chybový stav | Uncertain | nepozorováno v žádném snímku |
| Přístupnost | Uncertain | nejsou k dispozici žádné DOM/nahrávkové podklady |
