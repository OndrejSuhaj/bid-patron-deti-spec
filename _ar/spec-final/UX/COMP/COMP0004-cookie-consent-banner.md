---
doc_id: COMP0004
title: Cookie Consent Banner
layer: COMP
spec_type: component
modules: []
status: imported
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

# COMP0004 – Banner pro souhlas s cookies

## Účel

Trvalý, zavíratelný oznamovací pruh informující návštěvníky o používání cookies, s akcí „přijmout“
(případně dvojicí akcí přijmout/odmítnout na homepage) a odkazem „Další informace“. Vyskytuje se jako
chrome napříč veřejným webem a byl nezávisle zaznamenán v nejméně 9 písemných WIRE dokumentech se
dvěma mírně odlišnými vizuálními provedeními (viz Varianty) — znovupoužití je přímo doloženo.

## Props / Vstupy

| Název | Typ | Povinné | Výchozí | Popis |
|---|---|---|---|---|
| `dismissed` | `boolean` | ne | `false` | Zda návštěvník v rámci této relace již banner přijal/zavřel; ovlivňuje viditelnost. |
| `onAccept` | `function` | ne | — | Handler pro akci přijmout. |
| `onReject` | `function` | ne | — | Handler pro akci odmítnout (přítomen pouze u dvoutlačítkové varianty, viz Varianty). |

## Varianty

- **akce:** single-action (tmavý spodní pruh, ikona cookie + text + pouze odkaz „Další informace“ —
  Confirmed na většině obrazovek, např. `WIRE0006`, `WIRE0007`, `WIRE0013`, `WIRE0024`) | dual-action
  (plovoucí karta vlevo dole s tlačítky „Přijímám“ / „Odmítnout“ a odkazem „Více info“ — Confirmed
  jednou, na homepage `WIRE0001`). Obě varianty jsou vizuálně natolik odlišné, že by mohlo jít
  ve skutečnosti o dvě odlišné implementace mechanismu souhlasu, nikoli o jednu parametrizovanou
  komponentu — označeno jako `Uncertain`, nikoli tvrzeno jako jedna potvrzená osa variant.

## Stavy

### idle
Banner viditelný s ikonou cookie, vysvětlujícím textem a akcí/akcemi. Confirmed,
`_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png` (dual-action, karta vlevo dole),
`_ar/prtsc/screencapture-patrondeti-cz-overit-prihlaseni-2026-07-04-13_33_25.png` (single-action,
tmavý pruh na celou šířku).

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

### dismissed (další stav životního cyklu, není jedním ze šesti šablonových stavů)
Banner se po akci přijmout/odmítnout nevykresluje / je odstraněn z DOM. Není přímo zaznamenáno
(neexistuje zachycená dvojice před/po ve stejné relaci) — `Assumed` na základě standardní konvence
cookie banneru, nepotvrzeno evidencí.

## Události

| Událost | Payload | Spouštěč | Poznámky |
|---|---|---|---|
| `onAccept` | žádný | klik na „Přijímám“ (dual) nebo implicitní přijetí u single-action varianty | Ukládá souhlas, mechanismus (cookie/localStorage) není doložen. |
| `onReject` | žádný | klik na „Odmítnout“ (pouze dual-action varianta) | Nezaznamenán žádný potvrzený rozdíl v chování (např. zda banner rovněž zavře, nebo zůstane viditelný). |
| `onMoreInfo` | žádný | klik na „Další informace“ / „Více info“ | Cíl nepotvrzen evidencí (pravděpodobně stránka s cookie policy, nezachyceno). |

## Přístupnost (Accessibility)

- **ARIA role:** `Uncertain` — Assumed `role="dialog"` nebo live-region banner; nepotvrzeno.
- **Klávesová navigace:** `Uncertain`.
- **Správa fokusu:** `Uncertain` — zda je fokus zachycen (trap) nebo přesunut na banner při načtení, nelze určit ze statických screenshotů.
- **Čtečka obrazovky:** `Uncertain`.

## Omezení použití

- Použít když: vykreslování jakékoli veřejné obrazovky Patronusu před zaznamenáním souhlasu.
- Nepoužívat když: souhlas byl pro danou relaci již zaznamenán (Assumed chování zavření, nepotvrzeno).
- Kardinalita: nejvýše jedna viditelná instance na jedno načtení stránky.
- Umístění: overlay/fixní pozice — plovoucí karta vlevo dole (dual-action varianta) nebo spodní pruh na celou šířku (single-action varianta).

## Závislosti

- Ostatní COMP: `COMP0001` Primary Button — tlačítko „Přijímám“ u dual-action varianty vizuálně
  připomíná vzor primárního tlačítka; neshoda nepotvrzena jako identická (Uncertain), proto je
  kompozice zaznamenána, ale nikoli tvrzena jako jistá.
- Datové entity: žádné.
- ACL: žádné.
- Externí knihovny: žádné doloženy (nezaznamenáno žádné brandování dodavatelské consent-management platformy).

## Kompozice

```
CookieConsentBanner (dual-action variant)
  └─ COMP0001-like accept button (Uncertain — not confirmed as the identical shared button component)
```

## Otevřené otázky

- Zda jsou single-action a dual-action provedení skutečně stejnou parametrizovanou komponentou, nebo
  dvěma samostatně vytvořenými mechanismy — žádná evidence z kódu/DOM to neřeší; zaznamenáno jako
  otevřená otázka místo tichého sloučení nebo rozdělení.
- Mechanismus persistence (cookie vs. localStorage vs. relace) není ze screenshotů doložen.

## Sladění s design systémem (cíl)

Bez kanonického protějšku v `@patron/ui` — plocha cookie/consent legal není pokryta žádným
vybudovaným epikem (E0003–E0005) v cílovém design systému. Nenavrhuje se zde žádné mapování na token
ani komponentu; tato komponenta zůstává pouze current-state, dokud nebude existovat cílový epik
zastřešující consent/legal UI.

## Evidence

| Oblast tvrzení | Jistota | Evidence |
|---|---|---|
| Znovupoužití napříč ≥2 obrazovkami | Confirmed | 9+ WIRE dokumentů cituje tento banner; `WIRE-synthesis-report.md` §6 "Global header nav + cookie-consent banner + footer" |
| Dual-action varianta | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png` |
| Single-action varianta | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-overit-prihlaseni-2026-07-04-13_33_25.png`, `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_18_33.png` |
| Stav dismissed v životním cyklu | Assumed | standardní konvence; nezachyceno žádné before/after |
| Přístupnost | Uncertain | žádná evidence z DOM/nahrávky k dispozici |
