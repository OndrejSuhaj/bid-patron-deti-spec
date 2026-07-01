# Stavový model — průvodce

> **Kontextový artefakt** ve správě analytika. Kompletní výčet stavů entit napříč CZ / RO / MD. **Není zdroj pravdy pro implementaci** — stavové stroje entit po destilaci žijí ve `spec/`.

---

## Co to je

- **Zdroj:** klientský přehled stavů pro tři země.
- **Formát:** `.xlsx` originál (v [`_source/`](_source/)) + strojový převod `.md` (hybrid — originál je autorita při pochybnosti, `.md` pro čtení / grep / diff).
- **Soubory:** `_source/STATUSES_CZ_RO_MO.xlsx` (autorita) + [`statuses.md`](statuses.md).
- **Obsah:** pro každý stav **alias** (systémový identifikátor), CZ / EN / RO název a typ entity (Lead / Application / Story). ~60 stavů.

## Kdy ho použít

- Jako **kanonický slovník stavů** při destilaci stavových strojů entit do `spec/`.
- Pro přesné aliasy a jejich mapování mezi jazyky (multi-tenant).

## Kdy ho nepoužívat

- Jako popis *přechodů* mezi stavy — ty drží procesní mapy a testovací scénáře, finálně `spec/`.

---

## Katalog

| Soubor | Typ | Poznámka |
|---|---|---|
| [`_source/STATUSES_CZ_RO_MO.xlsx`](_source/STATUSES_CZ_RO_MO.xlsx) | originál | Autorita. MD blok je místy řidší. |
| [`statuses.md`](statuses.md) | strojový převod | Pro čtení / grep. |

## Kurátorský log

> Co se ze stavů promítlo do kanonické vrstvy. Vlastník: **analytik**.

| Datum | Co | Kam | Rozhodl |
|---|---|---|---|
| — | *(zatím nic)* | — | — |

## Changelog

| Datum | Změna | Autor |
|---|---|---|
| 2026-06-30 | Vyčleněn jako samostatný kontextový artefakt (dříve součást společného `intake/README.md`). | Libor Suchý |
| 2026-07-01 | Průvodce přesunut ze sidecaru `intake/statuses.md` do `statuses/README.md` (self-contained složka). Originál `.xlsx` do [`_source/`](_source/). | Libor Suchý |
