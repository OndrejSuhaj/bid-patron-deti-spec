---
doc_id: COMP0009
title: Single Email-Entry Form
canonical_layer: COMP
spec_type: component
modules: []
status: canonical
references:
  - WIRE0012
  - WIRE0024
  - EN0006
  - EN0008
  - UC0014
---

# COMP0009 – Jednopolní formulář pro zadání e-mailu

## Účel

Minimalistický jednopolní formulář (pole pro e-mail + primární tlačítko pro odeslání + jeden nebo dva
sekundární textové odkazy) používaný na obou vstupních bodech blízkých autentizaci, které vyžadují
pouze e-mailovou adresu: bezheslové přihlášení (`WIRE0012`) a obrazovka pro vyžádání aktivačního
odkazu (`WIRE0024`). Obě obrazovky realizují `UC0014` a mají (téměř) identický tvar potvrzený přímým
porovnáním snímků obrazovky, lišící se pouze v textu nadpisu/těla a v cílech sekundárních odkazů.

## Props / vstupy

| Name | Type | Required | Default | Description |
|---|---|---|---|---|
| `heading` | `string` | yes | — | Nadpis H1 specifický pro danou obrazovku; vlastněný vrstvou COPY (např. "Přihlaste se do účtu", "Už jsem dárcem, žadatelem nebo Patronem a chci aktivovat účet"). |
| `bodyText` | `string` | yes | — | Úvodní text v rozsahu 1–2 odstavců; vlastněný vrstvou COPY. |
| `emailValue` | `string` | no | `""` | Řízená hodnota pole e-mailu; evidence pro `WIRE0024` popisuje předvyplněnou ukázkovou hodnotu v jednom narativním zdroji (Probable, nezávisle neviditelné na vlastním citovaném snímku obrazovky). |
| `ctaLabel` | `string` | yes | — | Popisek primárního tlačítka pro odeslání (např. "Přihlásit se", "Poslat aktivační odkaz"). |
| `secondaryLinks` | `{label, href}[]` | no | `[]` | 1–2 sekundární textové odkazy pod CTA (např. "Přihlaste se pomocí svého hesla.", "Aktivujte si ho.", "Zpět na přihlášení"). |
| `statusIcon` | `string` | no | `none` | Dekorativní piktogram nad nadpisem — ikona dvou postav pozorovaná ve výchozím stavu na obou obrazovkách. |

## Varianty

- **purpose:** login (`WIRE0012`, `/prihlaseni`) | activation-request (`WIRE0024`,
  `/overit-prihlaseni`) — stejný tvar, odlišný text/odkazy/navazující dílčí cesta `UC0014`.

## Stavy

### idle (výchozí, neodeslaný)
Ikona dvou postav, nadpis, text těla, jednořádkové pole e-mailu (placeholder "E-mail" zastupující
i popisek, žádný viditelný popisek nad polem), červené primární tlačítko, 1–2 sekundární textové
odkazy. Confirmed — `_ar/prtsc/screencapture-patrondeti-cz-prihlaseni-2026-07-04-13_23_29.png`
(login, přímo viditelné); ekvivalent pro `WIRE0024` je pouze `Probable` — jeho vlastní citovaný
snímek obrazovky zobrazuje pouze chrome header/cookie banner/footer, nikoli samo tělo formuláře
(mezera v evidenci označená ve `WIRE0024`, zde neřešena).

### confirmation (po odeslání, pouze login)
Ikona se změní na kroužek se zaškrtnutím; nadpis se změní na "Zkontrolujte svou e-mailovou
schránku"; text vysvětluje, že odkaz byl odeslán; jeden sekundární odkaz se změní na nápovědu typu
mailto/kontrola spamu. Confirmed pouze pro variantu login —
`_ar/prtsc/screencapture-patrondeti-cz-prihlaseni-2026-07-04-13_32_31.png`. Nepotvrzeno, zda
varianta pro vyžádání aktivace (`WIRE0024`/S021→S022) sdílí tento stejný dílčí stav confirmation,
nebo zobrazuje samostatně navrženou obrazovku "odkaz odeslán" (`WIRE0025`, sama Uncertain/bez
evidence — viz Otevřené otázky).

### hover
`Uncertain — nelze pozorovat ze statické evidence.`

### focused
`Uncertain — nelze pozorovat ze statické evidence.`

### disabled
`Uncertain — pro tlačítko odeslání nebylo zachyceno žádné vykreslení stavu disabled před validací.`

### loading
`Uncertain — pro žádnou z obrazovek nebyl zachycen stav probíhajícího zpracování; Evidence Pending.`

### error
`Uncertain — pro žádnou z obrazovek nebylo zachyceno vykreslení chyby pro neplatný e-mail nebo
omezení opakovaného odeslání; každý navazující WIRE zaznamenává "e-mail required/format" a (pouze
pro WIRE0012) "resubmission/throttling" jako otevřené otázky validace bez BR, zde neřešeno.`

## Události

| Event | Payload | Trigger | Notes |
|---|---|---|---|
| `onSubmit` | `{email: string}` | kliknutí na primární CTA nebo Enter v poli | Posouvá `UC0014`; navazující větvení (login-link vs. activation-link) je vlastněno vrstvou UC. |
| `onSecondaryLinkClick` | cílová route | kliknutí na sekundární odkaz | např. křížové odkazy login↔activation-request, fallback na přihlášení heslem. |

## Přístupnost

- **ARIA role:** `Uncertain` — předpokládá se nativní sémantika `<form>`/`<input>`; nepotvrzeno.
- **Keyboard navigation:** `Uncertain` — předpokládá se pořadí Tab pole→tlačítko→odkazy; nepotvrzeno.
- **Focus management:** `Uncertain` — zda se fokus po odeslání přesune na nadpis confirmation, nelze pozorovat ze statické evidence.
- **Screen reader:** `Uncertain` — pro pole e-mailu není potvrzen žádný viditelný element `<label>` (vzor placeholder-jako-popisek), což je běžné riziko přístupnosti; označeno jako otevřená otázka, nikoli tvrzeno jako defekt bez evidence z DOM.

## Omezení použití

- Použít když: jedinou informací potřebnou k pokračování je e-mailová adresa uživatele, pro tok
  blízký autentizaci (`UC0014`).
- Nepoužívat když: jsou požadována další pole (heslo, telefon) (→ `WIRE0013` aktivace účtu, která
  přidává pole heslo, NENÍ touto komponentou i přes vizuální rodinnou podobnost — zaznamenáno jako
  sesterská komponenta, nesloučeno, v souladu s pravidlem znovupoužití podmíněného evidencí).
- Kardinalita: jedna na obrazovku.
- Umístění: centrovaná karta obsahu, pod dekorativní stavovou ikonou a nadpisem/textem těla.

## Závislosti

- Ostatní COMPy: `COMP0001` Primární tlačítko (CTA pro odeslání odpovídá vizuálnímu vzoru primárního
  tlačítka — Probable, neuváděno jako jisté), `COMP0002` Globální hlavička, `COMP0003` Globální
  patička (standardní chrome obalující obě obrazovky).
- Datové entity: `EN0006` Kontakt / `EN0008` Uživatel — hodnota e-mailu konceptuálně identifikuje
  existující stranu pro `UC0014`, ale žádná vazba na úrovni atributu není potvrzena pouze z UI
  evidence.
- ACL: nic neevidováno.
- Externí knihovny: nic neevidováno.

## Kompozice

```
EmailEntryForm
  ├─ status icon (decorative)
  ├─ heading + body text (COPY-owned)
  ├─ e-mail <input>
  ├─ COMP0001 Primary Button (Probable — visual match, not confirmed identical)
  └─ 1–2 secondary text links
```

## Otevřené otázky

- Vlastní obsah těla formuláře `WIRE0024` je `Probable`, nezávisle neviditelný na jeho citovaném
  snímku obrazovky (evidován pouze prózou v `ui-observed-areas.md` §9) — activation-request
  varianta tohoto COMP dědí stejný strop jistoty.
- Zda `WIRE0025` (S022, obrazovka potvrzení odeslání aktivačního odkazu) je opakovaně použitý stav
  `confirmation` této komponenty, nebo zcela samostatná obrazovka — u obou vlastních snímků
  obrazovky `WIRE0025` se ukázalo, že místo toho zobrazují obsah formuláře `WIRE0024`, takže žádná
  evidence v současnosti nepodporuje ani jednu odpověď (přeneseno z poznámky k S022 v
  `WIRE-screen-coverage.md`).
- Vzor placeholder-jako-popisek (bez viditelného `<label>`) je opakující se otevřená otázka
  přístupnosti u obou variant.

## Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Znovupoužití ve ≥2 obrazovkách | Confirmed (tvar) / Probable (obsah WIRE0024) | `WIRE0012` a `WIRE0024` obě realizují `UC0014` s tímto tvarem; `WIRE-synthesis-report.md` §6 "E-mail-entry single-field form" |
| Varianta login, stav idle | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-prihlaseni-2026-07-04-13_23_29.png` |
| Varianta login, stav confirmation | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-prihlaseni-2026-07-04-13_32_31.png` |
| Varianta activation-request, stav idle | Probable | pouze próza v `ui-observed-areas.md` §9; nezávisle neviditelné na `_ar/prtsc/screencapture-patrondeti-cz-overit-prihlaseni-2026-07-04-13_33_25.png` dle vlastní evidenční poznámky WIRE0024 |
| Přístupnost | Uncertain | nedostupná žádná evidence z DOM/nahrávky |
