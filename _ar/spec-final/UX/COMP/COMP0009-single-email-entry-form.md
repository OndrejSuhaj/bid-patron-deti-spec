---
doc_id: COMP0009
title: Single Email-Entry Form
layer: COMP
spec_type: component
modules: []
status: imported
references:
  - WIRE0012
  - WIRE0024
  - EN0006
  - EN0008
  - UC0014
---

# COMP0009 – Jednopolní formulář pro zadání e-mailu

## Účel

Minimalistický jednopolní formulář (vstupní pole pro e-mail + primární tlačítko pro odeslání + jeden
nebo dva sekundární textové odkazy) použitý na obou vstupních bodech sousedících s autentizací, které
vyžadují pouze e-mailovou adresu: přihlášení bez hesla (`WIRE0012`) a obrazovka pro vyžádání
aktivačního odkazu (`WIRE0024`). Obě obrazovky realizují `UC0014` a mají (téměř) identický tvar
potvrzený přímým porovnáním screenshotů, lišící se pouze textem nadpisu/těla a cíli sekundárních
odkazů.

## Props / vstupy

| Název | Typ | Povinné | Výchozí | Popis |
|---|---|---|---|---|
| `heading` | `string` | ano | — | Nadpis H1 specifický pro obrazovku; ve vlastnictví COPY (např. "Přihlaste se do účtu", "Už jsem dárcem, žadatelem nebo Patronem a chci aktivovat účet"). |
| `bodyText` | `string` | ano | — | 1–2 odstavce úvodního textu; ve vlastnictví COPY. |
| `emailValue` | `string` | ne | `""` | Kontrolovaná hodnota e-mailového pole; důkazy k `WIRE0024` popisují v jednom narativním zdroji předvyplněnou ukázkovou hodnotu (Probable, ve vlastním citovaném screenshotu není samostatně viditelná). |
| `ctaLabel` | `string` | ano | — | Popisek primárního tlačítka pro odeslání (např. "Přihlásit se", "Poslat aktivační odkaz"). |
| `secondaryLinks` | `{label, href}[]` | ne | `[]` | 1–2 sekundární textové odkazy pod CTA (např. "Přihlaste se pomocí svého hesla.", "Aktivujte si ho.", "Zpět na přihlášení"). |
| `statusIcon` | `string` | ne | `none` | Dekorativní piktogram nad nadpisem — ikona dvou osob pozorovaná ve výchozím stavu obou obrazovek. |

## Varianty

- **účel:** přihlášení (`WIRE0012`, `/prihlaseni`) | vyžádání aktivace (`WIRE0024`,
  `/overit-prihlaseni`) — stejný tvar, odlišný text/odkazy/navazující dílčí větev `UC0014`.

## Stavy

### idle (výchozí, neodesláno)
Ikona dvou osob, nadpis, text těla, jednořádkové e-mailové vstupní pole (placeholder "E-mail"
zastupující zároveň label, žádný viditelný label nad polem), červené primární tlačítko, 1–2
sekundární textové odkazy. Confirmed —
`_ar/prtsc/screencapture-patrondeti-cz-prihlaseni-2026-07-04-13_23_29.png` (přihlášení, přímo
viditelné); ekvivalent u `WIRE0024` je pouze `Probable` — jeho vlastní citovaný screenshot ukazuje
chrome (header/cookie lišta/footer), ale ne samotné tělo formuláře (mezera v důkazech je uvedena u
`WIRE0024`, zde neřešena).

### confirmation (po odeslání, pouze přihlášení)
Ikona se změní na kroužek se zaškrtnutím; nadpis se změní na "Zkontrolujte svou e-mailovou
schránku"; text vysvětluje, že odkaz byl odeslán; jeden sekundární odkaz se změní na nápovědu
typu mailto/kontrola spamu. Confirmed pouze pro variantu přihlášení —
`_ar/prtsc/screencapture-patrondeti-cz-prihlaseni-2026-07-04-13_32_31.png`. Není potvrzeno, zda
varianta vyžádání aktivace (`WIRE0024`/S021→S022) sdílí tento stejný dílčí stav potvrzení, nebo
zobrazuje samostatně navrženou obrazovku "odkaz odeslán" (`WIRE0025`, samo o sobě
Uncertain/nedoloženo — viz Otevřené otázky).

### hover
`Uncertain — nelze pozorovat ze statických důkazů.`

### focused
`Uncertain — nelze pozorovat ze statických důkazů.`

### disabled
`Uncertain — nebylo zachyceno vykreslení stavu disabled pro tlačítko odeslání před validací.`

### loading
`Uncertain — nebyl zachycen stav probíhajícího zpracování pro žádnou z obrazovek; Evidence
Pending.`

### error
`Uncertain — nebylo zachyceno vykreslení chyby pro neplatný e-mail nebo omezení opakovaného
odeslání (throttling) pro žádnou z obrazovek; každý navazující WIRE zaznamenává "e-mail
povinný/formát" a (pouze pro WIRE0012) "opětovné odeslání/throttling" jako otevřené otázky
validace bez BR, zde neřešeno.`

## Události

| Událost | Payload | Spouštěč | Poznámky |
|---|---|---|---|
| `onSubmit` | `{email: string}` | klik na primární CTA nebo Enter v poli | Posouvá `UC0014` dále; navazující větev (odkaz pro přihlášení vs. aktivační odkaz) je ve vlastnictví UC. |
| `onSecondaryLinkClick` | cílová route | klik na sekundární odkaz | např. křížové odkazy přihlášení↔vyžádání aktivace, fallback na přihlášení heslem. |

## Přístupnost

- **ARIA role:** `Uncertain` — předpokládaná nativní sémantika `<form>`/`<input>`; nepotvrzeno.
- **Navigace klávesnicí:** `Uncertain` — předpokládané pořadí Tab pole→tlačítko→odkazy; nepotvrzeno.
- **Správa fokusu:** `Uncertain` — zda se fokus po odeslání přesune na nadpis potvrzení, nelze ze statických důkazů pozorovat.
- **Čtečka obrazovky:** `Uncertain` — pro e-mailové pole není potvrzen žádný viditelný element `<label>` (vzor placeholder-jako-label), což je běžné riziko přístupnosti; oznámeno jako Otevřená otázka, nikoli tvrzeno jako defekt bez důkazů z DOM.

## Omezení použití

- Použít když: jediná informace potřebná k pokračování je e-mailová adresa uživatele, pro flow
  sousedící s autentizací (`UC0014`).
- Nepoužívat když: jsou vyžadována další pole (heslo, telefon) (→ `WIRE0013` aktivace účtu, která
  přidává pole hesla, NENÍ touto komponentou, přestože je vizuálně z podobné rodiny — zaznamenáno
  jako sesterská komponenta, nikoli sloučeno, podle pravidla znovupoužití podmíněného důkazy).
- Kardinalita: jedna na obrazovku.
- Umístění: centrovaná karta s obsahem, pod dekorativní ikonou stavu a nadpisem/textem těla.

## Závislosti

- Ostatní COMP: `COMP0001` Primární tlačítko (CTA pro odeslání odpovídá vizuálnímu vzoru primárního
  tlačítka — Probable, neuváděno jako jisté), `COMP0002` Globální header, `COMP0003` Globální footer
  (standardní chrome obalující obě obrazovky).
- Datové entity: `EN0006` Kontakt / `EN0008` Uživatel — hodnota e-mailu koncepčně identifikuje
  existující stranu pro `UC0014`, ale žádná vazba na úrovni atributů není potvrzena pouze z UI
  důkazů.
- ACL: nedoloženo.
- Externí knihovny: nedoloženo.

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

- Obsah těla formuláře u `WIRE0024` je `Probable`, není samostatně viditelný ve svém citovaném
  screenshotu (doloženo pouze prózou v `ui-observed-areas.md` §9) — varianta vyžádání aktivace
  této komponenty zdědí stejný strop jistoty.
- Zda je `WIRE0025` (S022, potvrzující obrazovka odeslání aktivačního odkazu) opakovaným použitím
  stavu `confirmation` této komponenty, nebo zcela samostatnou obrazovkou — bylo zjištěno, že oba
  screenshoty samotného `WIRE0025` zobrazují místo toho obsah formuláře `WIRE0024`, takže žádná
  odpověď není momentálně podložena důkazy (přeneseno z poznámky S022 v
  `WIRE-screen-coverage.md`).
- Vzor placeholder-jako-label (žádný viditelný `<label>`) je opakující se otevřená otázka
  přístupnosti u obou variant.

## Důkazy

| Oblast tvrzení | Jistota | Důkaz |
|---|---|---|
| Znovupoužití na ≥2 obrazovkách | Confirmed (tvar) / Probable (obsah WIRE0024) | `WIRE0012` a `WIRE0024` obě realizují `UC0014` s tímto tvarem; `WIRE-synthesis-report.md` §6 "E-mail-entry single-field form" |
| Varianta přihlášení, stav idle | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-prihlaseni-2026-07-04-13_23_29.png` |
| Varianta přihlášení, stav confirmation | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-prihlaseni-2026-07-04-13_32_31.png` |
| Varianta vyžádání aktivace, stav idle | Probable | pouze próza v `ui-observed-areas.md` §9; není samostatně viditelné v `_ar/prtsc/screencapture-patrondeti-cz-overit-prihlaseni-2026-07-04-13_33_25.png` podle vlastní poznámky k důkazům `WIRE0024` |
| Přístupnost | Uncertain | žádné důkazy z DOM/záznamu k dispozici |

## Zarovnání s design systémem (cíl — @patron/ui + @patron/tokens)

> Tato sekce je **TARGET**, nikoli current-state. Zaznamenává pozici této komponenty vůči
> kanonické knihovně `@patron/ui` pro rebuild a **nemění** žádný z výše uvedených current-state
> (observed) obsahů.

- **Neexistuje žádný přímý kanonický composite.** Kanonická knihovna
  (`_ar/evidence/design-system/components.md`; indexovaná v `_ar/spec-draft/DESIGN-component-index.md`
  §3, "Rekonstruované COMP bez kanonického protějšku") **nedefinuje** blok `EmailEntryForm`.
  Plochy sousedící s autentizací (přihlášení bez hesla, vyžádání aktivačního odkazu) ještě nejsou
  v rozsahu kanonické knihovny.
- **Základní atomy jsou kanonické**, ale pouze jako obecné primitivy, nikoli jako sestavený
  composite:
  - holé pole `<input>` se mapuje na atom **Input** — `COMP0021` v
    `DESIGN-component-index.md` §1 řádek 2 (nativní `InputHTMLAttributes`; žádný vestavěný `<label>`;
    stavy default/focus/disabled/error přes spotřebitelem signalizované `aria-invalid`; tokeny
    `--font-body`, `--radius-control`, `--color-border`, `--color-surface`, `--color-text`,
    `--color-muted`, `--color-accent`).
  - primární CTA pro odeslání se mapuje na atom **Button** — `COMP0001` (již dříve uvedená
    current-state závislost jako "Probable — vizuální shoda"); kanonický kontrakt: `variant="primary"`,
    tokeny `--radius-pill`, `--color-action`, `--color-on-brand`, `--space-sm/md/lg/xl`, focus-visible
    kroužek na `--color-accent`.
  - sekundární textové odkazy a dekorativní ikona stavu (dvě osoby / kroužek se zaškrtnutím) nemají
    doloženou žádnou kanonickou mapaci na atom/blok; piktogramy dvou osob/zaškrtnutí nejsou součástí
    kanonické výčtové sady `IconName` atomu `Icon` (`COMP0020`) (`development|health|subsistence|
    clock|check|arrow|heart|give|user`) podle `DESIGN-component-index.md` §1 řádek 3 — překrývá se
    pouze `check`, a to jen pro ikonu ve stavu potvrzení, nikoli pro piktogram dvou osob ve stavu idle.
- **Klasifikace mezery:** podle `DESIGN-component-index.md` §3 je toto jedna z 5 rekonstruovaných
  COMP bez kanonického protějšku — tam přiřazena k tomu, že composite pro e-mailový vstup v rámci
  autentizace prostě "není postaven," patří k ještě nescopovanému epiku, nikoli k již
  specifikovaným storefront plochám E0004. Pro ni není rezervován žádný kanonický doc_id (na
  rozdíl od `COMP0010`–`COMP0021`, které jsou rezervovanými cílovými doc_id pro již
  katalogizované komponenty).
- **Důsledek pro rebuild:** pokud/když bude do `@patron/ui` přidán blok ekvivalentní
  `EmailEntryForm`, skládal by se z `Input` (`COMP0021`) + `Button` (`COMP0001`, varianta
  primary/block) plus spotřebitelem dodaného nadpisu/textu těla a sekundárních odkazů, podle
  stejného vzoru "holý atom + wrapper spotřebitele," jaký již používá `DonationBox` (`COMP0010`)
  pro své pole vlastní částky. Toto je pouze výhledová implikace — takový blok dnes v kanonické
  knihovně neexistuje a toto pozorování nemění žádné current-state (observed) tvrzení v tomto
  dokumentu.
- **Poznámka k tenantům (CZ/RO) a a11y:** kanonické atomy `Input`/`Button` jsou tenant-neutrální
  (pouze remap tokenů řízený `data-theme`, žádné CZ/RO-specifické props) a kanonický kontrakt
  vyžaduje, aby spotřebitelé pro `Input` dodali vlastní `<label>`/`aria-label`, protože atom sám
  žádný nevykresluje. To je přímo relevantní k current-state Otevřené otázce této komponenty
  ohledně vzoru placeholder-jako-label (v žádném ze screenshotů nebyl pozorován viditelný
  `<label>`) — podle kanonického kontraktu by tuto mezeru musel uzavřít spotřebující composite,
  nikoli atom.
