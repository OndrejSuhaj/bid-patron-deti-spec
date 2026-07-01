# IT zadání — průvodce

> **Kontextový artefakt** ve správě Product Ownera. Zadání pro IT dodavatele na přepis (var. A) / upgrade (var. B) platformy Patron Děti — **master dokument cílového záměru**. Kontextový vstup pro produktovou vizi a specifikaci. **Není zdroj pravdy pro implementaci** — ta je po destilaci v kanonické vrstvě.

Doménové a produktové poznatky (moduly, typy příběhů, role, nefunkční požadavky) z tohoto zadání prochází **kurátorováním** do `product/` a `spec/`, ne kopírováním.

---

## Co to je

- **Zdroj:** klientské IT zadání pro nacenění a výběr dodavatele.
- **Formát:** `.docx` originál (v [`_source/`](_source/)) + strojový převod `.md` (hybrid — originál je autorita při pochybnosti, `.md` pro čtení / grep / diff).
- **Soubory:** `_source/Patron_Deti_IT_Zadani_07062026.docx` (autorita) + [`it-zadani.md`](it-zadani.md) (čtení / grep).
- **Obsah:** kontext projektu, role, ~20 modulů, 4 typy příběhů (standardní / otevřená částka / skupinový / sbírkový účet), 2 varianty řešení (přepis vs. upgrade), stavový model, nefunkční požadavky N1–N13 (GDPR / výkon / DevOps / PCI DSS / přístupnost…).

## Kdy ho použít

- Jako **nejvyšší autoritu pro cílový záměr** — co se má stavět a proč.
- Při destilaci do produktové vize (`product/`) a specifikace (`spec/`).
- Při sporu *current-state vs. cílový stav*: o cílovém chování rozhoduje zadání, ne procesní mapy.

## Kdy ho nepoužívat

- Jako hotovou spec. Je to **zadání pro nacenění** — část rozhodnutí (tech stack, var. A vs. B) je v něm otevřená a usazuje se až v kanonické vrstvě.
- Jako zdroj *jak* implementovat. Píše *co* a *proč*, ne *jak*.

---

## Katalog

| Soubor | Typ | Stav | Poznámka |
|---|---|---|---|
| [`_source/Patron_Deti_IT_Zadani_07062026.docx`](_source/Patron_Deti_IT_Zadani_07062026.docx) | zadání (originál) | finální (2026-06-07) | Master dokument záměru. Autorita při pochybnosti. |
| [`it-zadani.md`](it-zadani.md) | strojový převod | — | Pro čtení / grep / diff. |

## Vztah k ostatním artefaktům

- **Procesní mapy** ([`../process-maps/`](../process-maps/README.md)) popisují current state (Drupal); zadání drží **cílový** stav. Při rozporu o cílovém chování vyhrává zadání.
- **Meetingy** ([`../meetings/`](../meetings/README.md)) doplňují záměr „mezi řádky" (var. A potvrzena, CMS-editovatelnost, dvě vrstvy multi-tenant variantnosti).

## Kurátorský log

> Co se ze zadání promítlo do kanonické vrstvy. Vlastník: **Product Owner**.

| Datum | Co | Kam | Rozhodl |
|---|---|---|---|
| — | *(zatím nic — kanonická vrstva se teprve zakládá)* | — | — |

## Changelog

| Datum | Změna | Autor |
|---|---|---|
| 2026-06-30 | Vyčleněn jako samostatný kontextový artefakt (dříve součást společného `intake/README.md`). | Libor Suchý |
| 2026-07-01 | Průvodce přesunut ze sidecaru `intake/it-zadani.md` do `it-zadani/README.md` (self-contained složka po vzoru Endorphin). Originál `.docx` do [`_source/`](_source/). | Libor Suchý |
