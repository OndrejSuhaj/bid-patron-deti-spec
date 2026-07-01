# Současné řešení (patronus) — průvodce

> **Kontextový artefakt** ve správě Delivery Leada. **Zdrojový kód stávající platformy** Patron Děti (Drupal, projekt „patronus") — tak, jak ji dnes provozuje klient. Slouží jako sdílený, oficiální zdroj kódu pro tým a jako podklad pro analýzu rozsahu. **Není zdroj pravdy pro cílové chování** — to drží IT zadání; current-state se po destilaci promítá do `spec/` jako východisko, ne závazek.
>
> ⚠️ **Kód je scrubnutý od osobních dat** (viz [Scrub log](#scrub-log)). Originál (nescrubnutý) žije **mimo repo**.

---

## Co to je

- **Zdroj:** klientský export zdrojového kódu stávající platformy — Drupal projekt `patronus` (workspace `patrondetidev`, export `…-19246137d636`, soubory z 25. 6. 2026).
- **Obsah:** **jen custom vrstva + konfigurace** — 52 custom modulů (`web/modules/custom/`), 3 témata (`web/themes/custom/`: `patron_cz`, `patron_ro`, `patron_old`) a 731 config souborů (`config/`). Drupal **core / contrib / vendor NEjsou** součástí (composer-managed) → čistý scope signál bez balastu.
- **Umístění:** [`_source/patronus/`](_source/patronus/).

## Vstupní bod

- Kód: [`_source/patronus/`](_source/patronus/) — hlavní scope žije v `web/modules/custom/` a `config/`.
- Derivovaná analýza rozsahu (modulový inventář, doménový model, multi-tenant rozpad, gap vs. zadání) **je samostatný artefakt** → [`../current-solution-analysis/`](../current-solution-analysis/).

## Kdy ho použít

- Jako **sdílený zdroj kódu** stávajícího řešení pro tým (oficiální cesta místo kolujícího zipu).
- Jako podklad pro destilaci use cases / entit / funkcí do `spec/` — ale jako **current state**, ne cílový stav.
- Pro pochopení dnešní implementace (platby, scoring, workflow žádosti, notifikace).

## Kdy ho nepoužívat

- Jako závazný cílový stav. Při rozporu o *cílovém* chování vyhrává zadání ([`../it-zadani/`](../it-zadani/README.md)), ne stávající kód.
- Jako blueprint 1:1 — kolik váhy kód má, závisí na dosud otevřeném rozhodnutí **var. A (přepis) vs. B (upgrade)** ze zadání.

---

## Provenience a známé mezery

- **Bez VCS historie:** export je snapshot, ne git repo (`.git` v exportu není).
- **Prázdný submodul:** `web/themes/custom/patron_ro/src` odkazuje na `git@github.com:deepinsideofnowhere/fundatia.git` a v exportu je **prázdný** — část zdrojů RO theme (`fundatia`) není přiložena.
- **Bez tajemství:** export neobsahuje `settings.php`, `.env` ani vyplněné API klíče (jen názvy config polí) — pro spuštění by bylo potřeba doplnit.

## Scrub log

> Odstranění / anonymizace osobních dat před vložením do sdíleného repa (GDPR — charita s dětmi). Provedeno na kopii; originál v `__source/` nedotčen. Datum: 2026-07-01.

| Co | Kde | Akce |
|---|---|---|
| `promo.csv`, `table1.csv`, `table2.csv`, `ids.php` | `web/modules/custom/patron_base/files/` | **Smazáno** (reálná jména/e-maily/telefony fundraiserů, dětí, patronů; role notes; entity ID). Nahrazeno souborem `_PII-REMOVED.md`. |
| 103 e-mailových adres | napříč `.php`/`.install`/`.yml`/`.inc`/`.sh` (mj. `SendActivationEmailsCommand.php`, `voucher.install`, `ComgateSyncCommand.php`) | **Anonymizováno** → `example@example.com`. |
| Telefonní čísla | — | Prověřeno; v kódu žádná reálná (jen fragmenty UUID / příkladová / placeholdery). |
| Maintainer e-maily | `composer.lock`, `*.info.yml` | **Ponecháno** (veřejné OSS adresy autorů balíčků, ne klientská data). |

## Kurátorský log

> Co se ze stávajícího kódu promítlo do kanonické vrstvy. Vlastník: **analytik** (destilace do `spec/`).

| Datum | Co | Kam | Rozhodl |
|---|---|---|---|
| — | *(zatím nic)* | — | — |

## Changelog

| Datum | Změna | Autor |
|---|---|---|
| 2026-07-01 | Založen kontextový artefakt: scrubnutý export Drupal projektu `patronus` do `_source/patronus/` (custom moduly + config + témata; core/contrib/vendor vynechány). PII odstraněno/anonymizováno (viz Scrub log). | Libor Suchý |
