---
doc_id: COMP0003
title: Global Site Footer
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

# COMP0003 – Globální patička webu

## Účel

Trvalá vícesloupcová patička webu: brandová bublina, sociální odkaz "Sledujte nás", uvedení
Nadace Sirius, registrační číslo veřejné sbírky, sloupce odkazů ("Patron dětí": O nás/Blog/Pravidla
poskytování pomoci/Naše desatero/Splněné příběhy/Výroční zprávy/Jak jsme pomáhali...; "Kontakt":
e-mail), odznaky platebních poskytovatelů (Comgate/Mastercard/Visa), číslo sbírkového účtu a
spodní lišta s copyrightem a právními odkazy. Přítomna identicky jako chrome téměř na každé
obrazovce — přímo pozorována na alespoň 19 z 22 zdokumentovaných WIRE dokumentů.

## Props / Vstupy

| Název | Typ | Povinné | Výchozí | Popis |
|---|---|---|---|---|
| `promoSlot` | `slot / node` | ne | `none` | Volitelný extra promo pruh nad standardním obsahem patičky, pozorován jednou jako "Víte o dítěti, které potřebuje pomoci?" na `WIRE0014` — pojímán jako slot specifický pro danou obrazovku, nikoli jako součást základního kontraktu. |

## Varianty

- **promo:** none (výchozí, Confirmed na většině obrazovek) | with-promo-band (pouze `WIRE0014` — Uncertain,
  zda se jedná o obecnou schopnost nebo jednorázové doplnění specifické pro obrazovku nastavení účtu)

## Stavy

### idle
Tmavé pozadí, čtyři obsahové oblasti (brand/bublina, sloupce odkazů, kontakt, platební odznaky) plus
spodní lišta s právními odkazy a copyrightem. Confirmed na každém citovaném screenshotu, např.
`_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png`,
`_ar/prtsc/screencapture-patrondeti-cz-overit-prihlaseni-2026-07-04-13_33_25.png`.

### hover
`Uncertain — not observable from static evidence` (hover stavy odkazů nebyly zachyceny).

### focused
`Uncertain — not observable from static evidence.`

### disabled
N/A — patička nemá stav disabled.

### loading
N/A — statický chrome.

### error
N/A — patička sama nevlastní žádné vykreslování chybových stavů.

## Události

| Událost | Payload | Trigger | Poznámky |
|---|---|---|---|
| `onNavigate` | cílová route | klik na jakýkoli odkaz v patičce | Cíle vlastněny v IA; několik z nich směřuje na obsahové obrazovky blocked-no-uc (S013/S014/S015). |

## Přístupnost

- **ARIA role:** `Uncertain` — předpokládá se nativní landmark sémantika `<footer>`; nepotvrzeno.
- **Navigace klávesnicí:** `Uncertain`.
- **Správa fokusu:** `Uncertain`.
- **Čtečka obrazovky:** `Uncertain`.

## Omezení použití

- Použít když: vykreslování spodní části jakékoli obrazovky postavené na Patronusu.
- Nepoužívat když: vykreslování externích/dodavatelských povrchů (mimo rozsah WIRE/COMP).
- Kardinalita: přesně jedna na obrazovku, na nejspodnější pozici.
- Umístění: úroveň stránky, pod všemi ostatními obsahovými zónami; obvykle bezprostředně
  předchází `COMP0004` Cookie Consent Banner, pokud nebyl odsouhlasen.

## Závislosti

- Ostatní COMP: žádné nejsou potvrzeny jako složené podelementy; řádek odznaků platebních
  poskytovatelů je statická grafika, nikoli interaktivní komponenta.
- Datové entity: žádné.
- ACL: nedoloženo.
- Externí knihovny: nedoloženo.

## Kompozice

Komponenta typu chrome na úrovni listu; žádná potvrzená kompozice pod-COMP.

## Příklady

```
GlobalFooter />                                   // WIRE0001, WIRE0006–WIRE0013 (standard)
GlobalFooter promoSlot={<CrossSellBanner />} />   // WIRE0014 (with-promo-band, Uncertain generality)
```

## Otevřené otázky

- Zda je promo pruh z `WIRE0014` ("Víte o dítěti, které potřebuje pomoci?") obecná schopnost slotu
  patičky, nebo jednorázové doplnění specifické pro danou obrazovku — v evidenci nebyl nalezen
  žádný druhý výskyt, který by potvrdil opětovné použití tohoto konkrétního slotu.

## Evidence

| Oblast tvrzení | Jistota | Evidence |
|---|---|---|
| Opětovné použití na ≥2 obrazovkách | Confirmed | 19+ WIRE dokumentů cituje identický vzor patičky; `WIRE-synthesis-report.md` §6 |
| Vizuální stav idle | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png`, `_ar/prtsc/screencapture-patrondeti-cz-overit-prihlaseni-2026-07-04-13_33_25.png`, `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_18_33.png` |
| Varianta promo-band | Uncertain | pouze jediný výskyt, `_ar/spec-draft/WIRE/WIRE0014_AccountSettingsProfile.md` |
| Přístupnost | Uncertain | k dispozici žádná DOM/recording evidence |
