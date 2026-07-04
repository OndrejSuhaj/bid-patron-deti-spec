---
doc_id: COMP0002
title: Global Site Header
canonical_layer: COMP
spec_type: component
modules: []
status: canonical
references:
  - WIRE0001
  - WIRE0002
  - WIRE0003
  - WIRE0005
  - WIRE0006
  - WIRE0007
  - WIRE0008
  - WIRE0009
  - WIRE0010
  - WIRE0011
  - WIRE0012
  - WIRE0013
  - WIRE0014
  - WIRE0015
  - WIRE0019
  - WIRE0021
  - WIRE0023
  - WIRE0024
  - WIRE0025
  - IA-patronus
---

# COMP0002 – Globální hlavička webu

## Účel

Trvalý horní navigační pruh zobrazený na téměř každé obrazovce Patronus: logo se sloganem, primární
navigační odkazy, CTA "Požádat o pomoc" a vstupní bod přihlášení "Můj účet". Jde o sdílené chrome
prvky, identicky popsané v nejméně 19 z 22 zpracovaných WIRE dokumentů
(`_ar/spec-draft/WIRE-synthesis-report.md` §6, "Global header nav ... present as chrome on
essentially every screen"). Cíle navigace samotné vlastní IA (`IA-patronus.md`); tato komponenta
(COMP) vlastní pouze vizuální/interakční obal hlavičky.

## Props / vstupy

| Název | Typ | Povinné | Výchozí | Popis |
|---|---|---|---|---|
| `isAuthenticated` | `boolean` | ne | `false` | Určuje cílovou destinaci odkazu `Můj účet` (vlastní účet vs. přihlášení); vlastní IA/UC, zde se neopakuje. |
| `activeNavItem` | `string` | ne | `none` | Který z navigačních odkazů (pokud vůbec) je vizuálně označen jako aktivní; nepotvrzeno jako implementované v žádném zachyceném snímku (Uncertain). |

## Varianty

- **context:** public (nav: "Jak to funguje", "Blog", "O nás", "Požádat o pomoc", "Můj účet" —
  Confirmed na `WIRE0001`, `WIRE0006`–`WIRE0013`, `WIRE0015`, `WIRE0019`, `WIRE0024`, `WIRE0025`) |
  authenticated-account (za "Můj účet" přidává prvek účtového menu — Probable,
  `WIRE0014`, `WIRE0021`, `WIRE0023`; přesný obsah menu není podložen důkazy)

## Stavy

### idle
Bílé pozadí, vlevo zarovnané logo "patron dětí" + slogan, uprostřed navigační odkazy, vpravo
zarovnané červené tlačítko "Požádat o pomoc" + textový odkaz "Můj účet" s ikonou postavy. Confirmed
na každé obrazovce, která jej uvádí, např. `_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png`,
`_ar/prtsc/screencapture-patrondeti-cz-prihlaseni-2026-07-04-13_23_29.png`.

### hover
`Uncertain — not observable from static evidence.`

### focused
`Uncertain — not observable from static evidence.`

### disabled
N/A — hlavička nemá stav disabled.

### loading
N/A — statické chrome prvky, v důkazech nejsou vázány na žádnou asynchronní operaci.

### error
N/A — vykreslení chyby nevlastní samotná hlavička.

## Události

| Událost | Payload | Spouštěč | Poznámky |
|---|---|---|---|
| `onNavigate` | cílová route | kliknutí na kterýkoli navigační odkaz/CTA/logo | Cíle vlastní IA; tato komponenta (COMP) pouze vyvolává interakci, nikoli destinaci. |

## Přístupnost

- **ARIA role:** `Uncertain` — předpokládá se nativní landmark sémantika `<header>`/`<nav>`; nepotvrzeno z DOM důkazů.
- **Klávesová navigace:** `Uncertain` — nelze pozorovat ze statických screenshotů.
- **Správa fokusu:** `Uncertain`.
- **Čtečka obrazovky:** `Uncertain` — předpokládá se, že ohlášení navigačního odkazu odpovídá viditelnému textu popisku; nepotvrzeno.

## Omezení použití

- Použít, když: se vykresluje horní část jakékoli obrazovky Patronus (veřejné i přihlášené).
- Nepoužívat, když: se vykresluje externí/vendorská plocha (Comgate, Revolut 3DS — explicitně mimo
  rozsah WIRE/COMP dle `WIRE-screen-coverage.md` "Excluded / platform surfaces").
- Kardinalita: přesně jedna na obrazovku, na nejvyšší pozici.
- Umístění: úroveň stránky, nad všemi ostatními obsahovými zónami.

## Závislosti

- Ostatní COMP: žádné (v aktuálních důkazech nekompozuje žádné dílčí COMP – prvek "Požádat o pomoc"
  vizuálně připomíná `COMP0001` Primary Button, ale je menší/navigačně vázaný; shoda nepotvrzena,
  ponecháno jako otevřená otázka, nikoli jako tvrzená kompozice).
- Datové entity: žádné přímo; `isAuthenticated` odráží stav relace, nikoli atribut entity.
- ACL: nic podloženo důkazy – nebyl zaznamenán žádný roli podmíněný navigační prvek odlišný od základní sady.
- Externí knihovny: nic podloženo důkazy.

## Kompozice

Komponenta typu leaf-level chrome; žádná potvrzená kompozice dílčích COMP (viz poznámka v sekci
Závislosti k navigačnímu tlačítku "Požádat o pomoc").

## Příklady

```
GlobalHeader isAuthenticated={false} />   // WIRE0001, WIRE0006–WIRE0013 (public/anonymous)
GlobalHeader isAuthenticated={true} />    // WIRE0014, WIRE0021, WIRE0023 (account screens, Probable)
```

## Otevřené otázky

- Zda je tlačítko "Požádat o pomoc" v hlavičce stejnou znovupoužitelnou komponentou jako `COMP0001`
  Primary Button (menší/navigačně stylizovanou), nebo samostatným navigačně vázaným tlačítkem –
  ze statických důkazů nevyřešeno.
- Zda hlavička v přihlášeném stavu vykresluje rozbalovací menu za odkazem "Můj účet" – žádný
  zachycený snímek tuto interakci nezobrazuje; `WIRE0014`/`WIRE0021`/`WIRE0023` předpokládají její
  přítomnost pouze na základě analogie.

## Důkazy

| Oblast tvrzení | Jistota | Důkaz |
|---|---|---|
| Opakované použití na ≥2 obrazovkách | Confirmed | 19+ WIRE dokumentů uvádí identický vzor hlavičky; `WIRE-synthesis-report.md` §6 |
| Vizuální stav idle (kontext public) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png`, `_ar/prtsc/screencapture-patrondeti-cz-prihlaseni-2026-07-04-13_23_29.png`, `_ar/prtsc/screencapture-patrondeti-cz-overit-prihlaseni-2026-07-04-13_33_25.png` |
| Varianta v přihlášeném kontextu | Probable | odvozeno z jediného screenshotu `_ar/spec-draft/WIRE/WIRE0014_AccountSettingsProfile.md`; neexistuje žádný dedikovaný zachycený snímek přihlášené hlavičky |
| Přístupnost | Uncertain | nejsou k dispozici žádné DOM/nahrávkové důkazy |
