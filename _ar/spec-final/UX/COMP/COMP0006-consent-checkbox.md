---
doc_id: COMP0006
title: Consent Checkbox
canonical_layer: COMP
spec_type: component
modules: []
status: canonical
references:
  - WIRE0002
  - WIRE0006
  - WIRE0011
  - WIRE0013
  - EN0006
  - EN0008
---

# COMP0006 – Zaškrtávací pole souhlasu

## Účel

Zaškrtávací pole spojené s popiskem obsahujícím vložený hypertextový odkaz na právní dokument
(zpracování osobních údajů/GDPR, pravidla poskytování pomoci, podmínky používání účtu) plus
volitelný pomocný text. Používá se vždy, když formulář vyžaduje, aby uživatel před odesláním
potvrdil zásady. Vizuální/interakční tvar (zaškrtávací pole + popisek + vložený odkaz) se
identicky opakuje napříč nejméně 4 zdokumentovanými obrazovkami WIRE ve třech různých modulech
(dar, přijetí žádosti, aktivace účtu).

## Props / vstupy

| Název | Typ | Povinné | Výchozí | Popis |
|---|---|---|---|---|
| `checked` | `boolean` | ano | `false` | Stav zaškrtávacího pole; pozorovaná výchozí hodnota je nezaškrtnuto na každé obrazovce kromě předvyplněného modálního okna daru (`WIRE0002`, testerská data — viz Stavy). |
| `label` | `string \| node` | ano | — | Text popisku obsahující vložený hypertextový odkaz; vlastní vrstvě COPY, zde není opakován (např. "Souhlasím se zpracováním osobních údajů a informováním o projektu", "Souhlasím s pravidly poskytování pomoci projektu Patron."). |
| `linkHref` | `string` | ne | — | Cíl vloženého hypertextového odkazu; *cíle* odkazů nejsou na několika obrazovkách podloženy důkazy (Uncertain, viz `WIRE0011`). |
| `helperText` | `string` | ne | `none` | Volitelný řádek pod popiskem (pozorováno jednou, `WIRE0006`: "Souhlasy můžete upravit/zrušit zasláním e-mailu na souhlas@patrondeti.cz."). |
| `required` | `boolean` | ne | `Uncertain` | Zda zaškrtávací pole podmiňuje odeslání formuláře; pro žádnou z citujících obrazovek nebyl nalezen dokument BR, který by to podkládal — zaznamenáno v `validationsWithoutBR` každého odkazujícího WIRE jako otevřená otázka, zde se to netvrdí. |

## Varianty

- **počet-na-formulář:** jedno (`WIRE0006` brána kontakt/souhlas — jedno zaškrtávací pole) | dvě
  (`WIRE0002` modální okno daru, `WIRE0013` aktivace účtu — dvě zaškrtávací pole, každé s jiným
  právním cílem) | tři (`WIRE0011` krok přiložení dokumentů — tři zaškrtávací pole: pravdivost
  údajů, pravidla, osobní údaje)

## Stavy

### idle (výchozí)
Nezaškrtnuté hranaté zaškrtávací pole + popisek s podtrženým vloženým odkazem. Confirmed,
kontext `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_18_33.png` (na této
konkrétní obrazovce zaškrtávací pole není, ale stejná vizuální rodina dle `ui-observed-areas.md`
§6/§8/§9).

### checked (zaškrtnuto)
Vyplněné/zaškrtnuté zaškrtávací pole, stejný popisek. Confirmed —
`_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_26_21.png`
zobrazuje obě zaškrtávací pole souhlasu v modálním okně daru předem zaškrtnutá se zeleným
vyplněním (stav vyvolaný interakcí testera, nikoli nutně výchozí stav).

### hover (přejetí kurzorem)
`Uncertain — nelze pozorovat ze statických důkazů.`

### focused (zaměřeno)
`Uncertain — nelze pozorovat ze statických důkazů.`

### disabled (zakázáno)
N/A — v žádném záznamu nebylo pozorováno vykreslení v zakázaném stavu.

### loading (načítání)
N/A — synchronní UI ovládací prvek, žádné asynchronní chování nebylo zdokumentováno.

### error (chyba)
`Uncertain — žádná obrazovka nezobrazuje vykreslení chyby validace pro nezaškrtnuté povinné pole
souhlasu (např. červený obrys nebo vložený text chyby); zda takové vykreslení existuje, není
potvrzeno. Zaznamenáno jako otevřená otázka validace v každém odkazujícím WIRE (viz např. WIRE0002
§Validation Surfaces).`

## Události

| Událost | Payload | Spouštěč | Poznámky |
|---|---|---|---|
| `onChange` | `boolean` (nový stav zaškrtnutí) | kliknutí uživatele na zaškrtávací pole nebo popisek | Přepíná `checked`. |
| `onLinkClick` | žádný | kliknutí na vložený hypertextový odkaz | Otevře odkazovaný právní dokument; chování (nová záložka vs. odchod ze stránky a zda se stav zaškrtávacího pole zachová) není zdokumentováno. |

## Přístupnost

- **ARIA role:** `Uncertain` — Předpokládá se nativní sémantika `<input type="checkbox">` se
  spojeným `<label>`; nepotvrzeno.
- **Navigace klávesnicí:** `Uncertain` — Předpokládá se přepnutí klávesou Space dle standardní
  sémantiky zaškrtávacích polí; nepotvrzeno.
- **Správa zaměření (focus):** `Uncertain`.
- **Čtečka obrazovky:** `Uncertain` — zda je vložený odkaz oznamován samostatně od popisku
  zaškrtávacího pole, nelze ze snímků obrazovky potvrdit.

## Omezení použití

- Použít když: krok formuláře vyžaduje potvrzení konkrétního právního dokumentu před pokračováním.
- Nepoužívat když: souhlas je implicitní/celoplošný (→ `COMP0004` Lišta souhlasu s cookies je pro
  tento případ odlišný mechanismus).
- Kardinalita: jedno až tři na formulář, každé vázané na jiný právní cíl (pozorovaný rozsah:
  1–3, žádný důkaz o vyšším počtu).
- Umístění: přímo nad `COMP0001` Primárním tlačítkem formuláře, typicky poslední prvky formuláře
  před odesláním.

## Závislosti

- Ostatní COMP: žádné jako subkomponenty; typicky umístěno bezprostředně před `COMP0001`
  Primárním tlačítkem v rozvržení formuláře (pozorovaná posloupnost, nikoli kompoziční vztah).
- Datové entity: potvrzení souhlasu se koncepčně vztahuje k `EN0006` Kontakt /
  `EN0008` Uživatel (strana udělující souhlas), ale žádná potvrzená vazba na úrovni atributů
  nebyla zdokumentována u žádného odkazujícího WIRE — zaznamenáno jako Uncertain, nikoli tvrzeno.
- ACL: žádné zdokumentováno.
- Externí knihovny: žádné zdokumentováno.

## Kompozice

Listová komponenta; žádná kompozice sub-COMP. Běžně opakováno 1–3× uvnitř formuláře bezprostředně
před instancí `COMP0001` Primárního tlačítka.

## Příklady

```
ConsentCheckbox checked={true}  label="Souhlasím s pravidly poskytování pomoci projektu Patron." />
ConsentCheckbox checked={true}  label="Souhlasím se zpracováním osobních údajů a informováním o projektu" />
  // WIRE0002 — modální okno daru, obě instance zaškrtnuté testerem

ConsentCheckbox checked={false} label="Souhlasím se zpracováním osobních údajů a informováním o projektu"
                helperText="Souhlasy můžete upravit/zrušit zasláním e-mailu na souhlas@patrondeti.cz." />
  // WIRE0006 — brána kontakt/souhlas, jedna instance, výchozí nezaškrtnuto
```

## Otevřené otázky

- Žádný dokument BR nepodkládá povinnost žádné instance této komponenty napříč jejími 4
  odkazujícími obrazovkami — převzato z vlastního seznamu `validationsWithoutBR` každého WIRE,
  zde neřešeno.
- Vykreslení chybového stavu (nezaškrtnuto, ale povinné) je zcela nezdokumentováno.
- Zda vazba na entitu vůbec existuje (vs. čistě UI příznak souhlasu), je nepotvrzeno.

## Důkazy

| Oblast tvrzení | Jistota | Důkaz |
|---|---|---|
| Opakované použití na ≥2 obrazovkách | Confirmed | `WIRE0002`, `WIRE0006`, `WIRE0011`, `WIRE0013` všechny zobrazují tento přesný tvar zaškrtávacího pole s propojeným popiskem; `WIRE-synthesis-report.md` §6 "Consent checkbox with linked legal-document label" |
| Vizuální stav zaškrtnuto | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_26_21.png` |
| Výchozí stav nezaškrtnuto | Confirmed | `_ar/evidence/ui/ui-observed-areas.md` §6, §8, §9 popis (zaškrtávací pole ve výchozím stavu nezaškrtnuto) |
| Chybový stav | Uncertain | nepozorováno v žádném záznamu |
| Přístupnost | Uncertain | žádný důkaz z DOM/nahrávky k dispozici |
