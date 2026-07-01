# Analýza současného řešení — průvodce

> **Derivovaný kontextový artefakt** ve správě analytika. Analytické zmapování **rozsahu** stávající platformy (Drupal projekt `patronus`) — moduly, doménové entity, integrace, konfigurace, multi-tenant — a **gap signály** proti IT zadání. Vzniklo destilací z kódu, ne kopií. **Není zdroj pravdy pro cílové chování**; je to čtení current-state pro odhad rozsahu a hledání děr v zadání.

---

## Co to je

- **Základ:** scrubnutý kód v [`../current-solution/_source/patronus/`](../current-solution/) (52 custom modulů, 731 config, 3 témata) + již vytažené DB schéma (`__source/schema/`, mimo repo).
- **Fáze:** **plná hloubka hotova** — inventář prohlouben o per-oblastní rozpad entit/funkcí, mapování stavů a **verifikovanou gap analýzu** (nálezy opřené o soubor/řádek). Provedeno orchestrovaným workflowem (22 subagentů).
- **Metoda:** baseline zadání → deep čtení kódu per funkční oblast → průřez (stavy, multi-tenant) → adversariální gap verifikace → syntéza. Obsah kurátorován (opraveny zřejmé chyby strojového čtení).

## Obsah

| Soubor | Co |
|---|---|
| [`scope-map.md`](scope-map.md) | Přehledová mapa — funkční oblasti, 52 modulů, ~29 custom entit, integrace, config landscape, multi-tenant, objemy dat. Vstupní bod. |
| [`deep-scope.md`](deep-scope.md) | **Hloubkový** rozpad per funkční oblast — entity s klíčovými poli, konkrétní funkcionality, integrace, workflow, technický dluh. |
| [`state-map.md`](state-map.md) | Mapování stavů workflow (`application_workflow`, 65+ stavů) ↔ stavový model zadání ([`../statuses/`](../statuses/)) — shoda, jen v kódu, jen v zadání. |
| [`gap-analysis.md`](gap-analysis.md) | **Verifikovaná** gap analýza proti [`../it-zadani/`](../it-zadani/) ve 4 dimenzích (modulová matice, typy příběhů, N1–N13, invariant peníze) — nálezy s dokladem a confidence. |
| [`estimation-notes.md`](estimation-notes.md) | Podklad **pro odhad** — relativní velikost/složitost per oblast, objemy dat, migrační rizika, páky odhadu dle var. A vs. B. Není to odhad. |

## Kdy ho použít

- Jako vstup pro **odhad rozsahu** (co dnes existuje, jak velké, jak provázané).
- Jako mapu při destilaci current-state do budoucí `spec/` — s vědomím autority (východisko, ne cíl).
- Jako podklad pro **rozhodnutí var. A (přepis) vs. B (upgrade)** — ukazuje, co by se přepisovalo/přebíralo.

## Kdy ho nepoužívat

- Jako cílovou specifikaci. Gapy jsou **klasifikovaný stav s dokladem**, ne schválený scope — o tom, co se přenáší / navrhuje znovu / zahazuje, rozhodují lidé (PO/analytik). Nálezy `k-overeni` je nutné před variantním rozhodnutím uzavřít.

## Otevřené otázky / další krok

- **needs:** @analytik — schválit klasifikaci gapů v [`gap-analysis.md`](gap-analysis.md) a jejich promítnutí do úvahy var. A vs. B.
- **Uzavřít nálezy `k-overeni`** (sekce „K ověření" v [`gap-analysis.md`](gap-analysis.md)) — zejména kadence urgencí, PCI SAQ rozsah, skutečná cache/tenant konfigurace mimo repo, veřejná SPA (WCAG). Mění odhad.
- **deferred:** promítnutí do kanonické vrstvy (`product/` vize, `spec/`) — až vrstvy vzniknou; kurátoruje analytik.

## Changelog

| Datum | Změna | Autor |
|---|---|---|
| 2026-07-01 | Plná hloubka: přidány `deep-scope.md`, `state-map.md`, `estimation-notes.md` a **verifikovaná** `gap-analysis.md` (nahradila předběžný `gap-signals.md`). Orchestrovaný workflow, 22 subagentů. | Libor Suchý |
| 2026-07-01 | Založen derivovaný artefakt; první průchod (inventář) ze scrubnutého kódu `patronus` — `scope-map.md` + předběžné `gap-signals.md`. | Libor Suchý |
