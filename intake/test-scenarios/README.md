# Testovací scénáře — průvodce

> **Kontextový artefakt** ve správě analytika. Krokové acceptance scénáře (CZ) + notifikační matice. **Není zdroj pravdy pro implementaci** — use cases a notifikace po destilaci žijí ve `spec/`.

---

## Co to je

- **Zdroj:** klientské testovací scénáře (CZ).
- **Formát:** `.xlsx` originál (v [`_source/`](_source/)) + strojový převod `.md` (hybrid — originál je autorita při pochybnosti, `.md` pro čtení / grep / diff).
- **Soubory:** `_source/CZ_Test_Scenarios_V3_s_notifikacemi.xlsx` (autorita) + [`test-scenarios.md`](test-scenarios.md).
- **Obsah:** 41 krokových scénářů v 11 blocích (priority A/B/C); každý krok mapuje akci → očekávaný výsledek → **stav v systému** → notifikace (e-mail / in-app pro Parent / Patron / Donor). Plus **Notification Matrix** (stav → role → text) a Filling Notes.

## Kdy ho použít

- Jako **acceptance kritéria** pro CZ při destilaci use cases (běžný / alternativní / chybové průchody) do `spec/`.
- Jako zdroj pro notifikace (MS artefakty) — matice stav → role → text → kanál.

## Kdy ho nepoužívat

- Jako kompletní pokrytí. Scénáře pro typy příběhů 3 (skupinový) a 4 (sbírkový účet) **chybí** — zadání počítá s jejich doplněním.

---

## Katalog

| Soubor | Typ | Poznámka |
|---|---|---|
| [`_source/CZ_Test_Scenarios_V3_s_notifikacemi.xlsx`](_source/CZ_Test_Scenarios_V3_s_notifikacemi.xlsx) | originál | Autorita. Některé řádky notif. matice mají `CHECK_PARSE` (HTML/newline z CSV) — ověřit proti originálu. |
| [`test-scenarios.md`](test-scenarios.md) | strojový převod | Pro čtení / grep. |

## Kurátorský log

> Co se ze scénářů promítlo do kanonické vrstvy. Vlastník: **analytik**.

| Datum | Co | Kam | Rozhodl |
|---|---|---|---|
| — | *(zatím nic)* | — | — |

## Changelog

| Datum | Změna | Autor |
|---|---|---|
| 2026-06-30 | Vyčleněn jako samostatný kontextový artefakt (dříve součást společného `intake/README.md`). | Libor Suchý |
| 2026-07-01 | Průvodce přesunut ze sidecaru `intake/test-scenarios.md` do `test-scenarios/README.md` (self-contained složka). Originál `.xlsx` do [`_source/`](_source/). | Libor Suchý |
