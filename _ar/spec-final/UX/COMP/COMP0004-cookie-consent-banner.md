---
doc_id: COMP0004
title: Cookie Consent Banner
canonical_layer: COMP
spec_type: component
modules: []
status: canonical
references:
  - WIRE0001
  - WIRE0003
  - WIRE0006
  - WIRE0007
  - WIRE0008
  - WIRE0011
  - WIRE0013
  - WIRE0015
  - WIRE0024
  - WIRE0025
---

# COMP0004 – Cookie Consent Banner

## Účel

Trvalá, zavíratelná lišta s upozorněním informující návštěvníky o používání cookies, s akcí "přijmout"
(případně dvojicí přijmout/odmítnout na úvodní stránce) a odkazem "Další informace". Vyskytuje se jako
společný prvek (chrome) napříč veřejnou částí webu a je nezávisle zaznamenána v nejméně 9 písemných
WIRE dokumentech se dvěma poněkud odlišnými vizuálními provedeními (viz Varianty) — opakované použití je
přímo doloženo.

## Vstupní vlastnosti (Props / Inputs)

| Název | Typ | Povinné | Výchozí hodnota | Popis |
|---|---|---|---|---|
| `dismissed` | `boolean` | ne | `false` | Zda návštěvník již v této relaci banner přijal/zavřel; ovládá jeho viditelnost. |
| `onAccept` | `function` | ne | — | Handler pro akci přijmout. |
| `onReject` | `function` | ne | — | Handler pro akci odmítnout (přítomen pouze u varianty se dvěma tlačítky, viz Varianty). |

## Varianty

- **akce:** jednoakční (tmavá spodní lišta, ikona cookie + text + pouze odkaz "Další informace" —
  Confirmed na většině obrazovek, např. `WIRE0006`, `WIRE0007`, `WIRE0013`, `WIRE0024`) | dvouakční
  (plovoucí karta vlevo dole s tlačítky "Přijímám" / "Odmítnout" a odkazem "Více info" — Confirmed
  jednou, na úvodní stránce `WIRE0001`). Obě varianty se vizuálně liší natolik, že se může jednat
  fakticky o dvě odlišné implementace mechanismu souhlasu, a ne o jednu parametrizovanou komponentu —
  označeno jako `Uncertain`, nikoli tvrzeno jako jedna potvrzená osa variant.

## Stavy

### idle
Banner viditelný s ikonou cookie, vysvětlujícím textem a akcí/akcemi. Confirmed,
`_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png` (dvouakční, karta vlevo dole),
`_ar/prtsc/screencapture-patrondeti-cz-overit-prihlaseni-2026-07-04-13_33_25.png` (jednoakční,
tmavá lišta na celou šířku).

### hover
`Uncertain — not observable from static evidence.`

### focused
`Uncertan — not observable from static evidence.`

### disabled
N/A.

### loading
N/A.

### error
N/A.

### dismissed (doplňkový stav v životním cyklu, mimo šest šablonových stavů)
Banner se po akci přijmout/odmítnout nevykresluje / je odstraněn z DOM. Není přímo zaznamenáno
(nebyl zachycen pár před/po ve stejné relaci) — `Assumed` na základě standardní konvence cookie
bannerů, evidencí nepotvrzeno.

## Události

| Událost | Payload | Spouštěč | Poznámky |
|---|---|---|---|---|
| `onAccept` | žádný | klik na "Přijímám" (dvouakční) nebo implicitní přijetí u jednoakční varianty | Ukládá souhlas, mechanismus (cookie/localStorage) evidencí nedoložen. |
| `onReject` | žádný | klik na "Odmítnout" (pouze dvouakční varianta) | Nebyl zaznamenán žádný potvrzený rozdíl v chování (např. zda banner rovněž zavře, nebo zůstane viditelný). |
| `onMoreInfo` | žádný | klik na "Další informace" / "Více info" | Cíl odkazu evidencí nepotvrzen (pravděpodobně stránka s cookie policy, nezachycena). |

## Přístupnost (Accessibility)

- **ARIA role:** `Uncertain` — předpokládáno (Assumed) `role="dialog"` nebo live-region banner; nepotvrzeno.
- **Klávesová navigace:** `Uncertain`.
- **Správa fokusu:** `Uncertain` — zda je fokus uzavřen (trapped) v banneru nebo na něj při načtení přesunut, nelze ze statických snímků obrazovky pozorovat.
- **Čtečka obrazovky:** `Uncertain`.

## Omezení užití

- Použít když: se vykresluje jakákoli veřejná obrazovka Patronusu před zaznamenáním souhlasu.
- Nepoužívat když: souhlas byl pro danou relaci již zaznamenán (předpokládané chování zavření, nepotvrzeno).
- Kardinalita: nejvýše jedna viditelná instance na jedno načtení stránky.
- Umístění: překryvná/fixní pozice — plovoucí karta vlevo dole (dvouakční varianta) nebo lišta na celou šířku dole (jednoakční varianta).

## Závislosti

- Ostatní COMP: `COMP0001` Primary Button — tlačítko "Přijímám" v dvouakční variantě se vizuálně
  podobá vzoru primárního tlačítka; shoda není potvrzena (Uncertain), takže kompozice je zaznamenána,
  ale netvrzena jako jistá.
- Datové entity: žádné.
- ACL: žádné.
- Externí knihovny: evidencí nedoloženy (nebylo pozorováno žádné brandingové označení dodavatelské
  platformy pro správu souhlasu).

## Kompozice

```
CookieConsentBanner (dual-action variant)
  └─ COMP0001-like accept button (Uncertain — not confirmed as the identical shared button component)
```

## Otevřené otázky

- Zda jsou jednoakční a dvouakční provedení skutečně stejnou parametrizovanou komponentou, nebo dvěma
  nezávisle vytvořenými mechanismy — žádná evidence z kódu/DOM to nerozhoduje; zaznamenáno jako
  otevřená otázka, nikoli tiše sloučeno či rozděleno.
- Mechanismus perzistence (cookie vs. localStorage vs. relace) není ze snímků obrazovky doložen.

## Evidence

| Oblast tvrzení | Jistota | Evidence |
|---|---|---|
| Opakované použití napříč ≥2 obrazovkami | Confirmed | 9+ WIRE dokumentů odkazuje na tento banner; `WIRE-synthesis-report.md` §6 "Global header nav + cookie-consent banner + footer" |
| Dvouakční varianta | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png` |
| Jednoakční varianta | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-overit-prihlaseni-2026-07-04-13_33_25.png`, `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_18_33.png` |
| Stav dismissed v životním cyklu | Assumed | standardní konvence; žádný snímek před/po neexistuje |
| Přístupnost | Uncertain | evidence z DOM/nahrávky není k dispozici |
