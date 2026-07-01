# Procesní mapy — průvodce

> **Kontextový artefakt** ve správě analytika. Mapy **current-state reality** stávající platformy (Drupal) v 7 procesních oblastech (CZ / RO / MD). **Není zdroj pravdy pro cílové chování** — to drží IT zadání; current state se po destilaci promítá do `spec/` jako východisko, ne závazek.

---

## Co to je

- **Zdroj:** klientské procesní mapy stávající platformy (Drupal).
- **Formát:** `.xlsx` / `.docx` originály (v [`_source/<oblast>/`](_source/)) + strojové převody `.md` v jednotlivých složkách oblastí (hybrid — originál je autorita při pochybnosti). `.md` u map jsou **dumpy buněk** (oddělovač ` | `, `⏎` = zalomení v buňce), ne próza — u složitějších tabulek ověřit proti originálu.
- **Pokrytí jazyků:** CZ nejúplnější; RO blízká varianta; **MD místy draft / nekompletní**.

## Vstupní bod

Rozcestník napříč 7 oblastmi × soubory drží [`MAP.md`](MAP.md). Originály (`.xlsx`/`.docx`) žijí v [`_source/<oblast>/`](_source/), čitelné `.md` převody přímo ve složkách oblastí níže.

## Kdy je použít

- Jako zdroj pro use cases, funkce a role při destilaci do `spec/` — ale jako **current state**, ne cílový stav.
- Pro pochopení dnešních procesů (urgence/timeouty, risk gate, párování plateb).

## Kdy je nepoužívat

- Jako závazný cílový stav. Při rozporu o *cílovém* chování vyhrává zadání ([`../it-zadani/`](../it-zadani/README.md)), ne current-state mapa.

---

## Oblasti (7)

| Oblast | Složka | Jádro | Jazyky |
|---|---|---|---|
| ŽÁDOST FRONT | [`zadost-front/`](zadost-front/) | příjem + kontrola + risk gate; urgence 2/7/14 dní → auto-zrušení | CZ, RO, MD |
| ŽÁDOST BACK | [`zadost-back/`](zadost-back/) | smlouva → podpis → výplata → feedback → uzavření; částečné plnění | CZ, RO, RO/MD |
| RISK | [`risk/`](risk/) | Low Risk scoring (5 kritérií, práh 30; jakékoli −1 = KO) + full review; CZ má Cribis+ISIR | CZ, RO, MD + Low Risk dok. (CZ/EN) |
| DONATIONS FLOW | [`donations-flow/`](donations-flow/) | 8 donačních kanálů; párování bez VS (e-mail v poznámce / ruční Ops) | CZ, RO, MD |
| FINANCE | [`finance/`](finance/) | úhrada faktury dodavateli, reconciliace, audit; peníze nikdy rodině | CZ, RO, MO |
| CONTENT | [`content/`](content/) | publikace příběhu + zpětná vazba dárcům; urgence na feedback | CZ, MD |
| AFFIL (patroni) | [`affil/`](affil/) | správa patronů: Case Management + Relationship Management | CZ, RO (Guarantor), MD |

> **Pozn. k AFFIL:** tři CZ soubory (`FINAL` + dvě „for presentation" verze) — paralelní snapshoty z 17. 2. 2026, ne čistá nadmnožina.
>
> **MARKETING / PR / DONORS** (péče o dárce, kampaně, média, GDPR souhlas u medializace) v podkladech **není** jako samostatná mapa — téma se objevuje napříč zadáním a oblastí CONTENT. Pokud mapa dorazí, přidá se sem jako 8. oblast.

## Kurátorský log

> Co se z procesních map promítlo do kanonické vrstvy. Vlastník: **analytik**.

| Datum | Co | Kam | Rozhodl |
|---|---|---|---|
| — | *(zatím nic)* | — | — |

## Changelog

| Datum | Změna | Autor |
|---|---|---|
| 2026-06-30 | Vyčleněno jako samostatný kontextový artefakt (dříve součást společného `intake/README.md`). Opraven počet oblastí 8 → **7** (MARKETING/PR/DONORS není v podkladech samostatná mapa). | Libor Suchý |
| 2026-07-01 | Průvodce přesunut ze sidecaru `intake/process-maps.md` do `process-maps/README.md`. Přidán rozcestník [`MAP.md`](MAP.md). Originály (`.xlsx`/`.docx`) přesunuty do [`_source/<oblast>/`](_source/); `.md` převody zůstávají ve složkách oblastí. | Libor Suchý |
