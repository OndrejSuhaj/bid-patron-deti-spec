# Intake — rozcestník kontextové vrstvy

> **Kontextová vrstva — ne zdroj pravdy.** `intake/` drží více samostatných kontextových artefaktů; každý má **vlastní složku** se `README.md` (rám, konvence, kurátorský log) a vlastního vlastníka. Pravda o tom, co produkt dělá, žije po destilaci v kanonické vrstvě (`product/`, `spec/`, `architecture/`, `design/`). Princip a životní cyklus drží [`playbook.md § 2`](../playbook.md).
>
> Tento soubor je **jen rozcestník** — kam jít pro co. Popis projektu, vize a doménový přehled patří do vrstvy `product/`, až vznikne; sem nepatří.

## Artefakty

### [IT zadání](it-zadani/) · Product Owner
Zadání pro IT dodavatele na přepis (var. A) / upgrade (var. B) platformy — **master dokument cílového záměru** (~20 modulů, 4 typy příběhů, 2 varianty řešení, nefunkční požadavky N1–N13). **Nejvyšší autorita pro *cílový* stav:** při sporu, co se má stavět, vyhrává zadání nad current-state mapami. Není hotová spec — část rozhodnutí (tech stack, var. A vs. B) je otevřená. → [`it-zadani/README.md`](it-zadani/README.md)

### [Stavový model](statuses/) · Analytik
Kompletní výčet stavů entit (Lead / Application / Story) napříč CZ / RO / MD — pro každý stav alias, překlady a typ entity (~60 stavů). **Kanonický slovník stavů** pro destilaci stavových strojů do `spec/`. Nedrží *přechody* mezi stavy — ty jsou v procesních mapách a scénářích. → [`statuses/README.md`](statuses/README.md)

### [Testovací scénáře](test-scenarios/) · Analytik
41 krokových acceptance scénářů (CZ) v 11 blocích + **Notification Matrix** (stav → role → text → kanál). **Acceptance kritéria** pro CZ a zdroj pro notifikace. Neúplné pokrytí: scénáře pro typy příběhů 3 (skupinový) a 4 (sbírkový účet) zatím chybí. → [`test-scenarios/README.md`](test-scenarios/README.md)

### [Procesní mapy](process-maps/) · Analytik
Mapy **current-state reality** stávající platformy (Drupal) v 7 oblastech (ŽÁDOST FRONT/BACK, RISK, DONATIONS, FINANCE, CONTENT, AFFIL) × CZ / RO / MD. **Jak systém funguje dnes**, ne cílový stav — při sporu o cílové chování vyhrává zadání. Rozcestník napříč oblastmi drží [`process-maps/MAP.md`](process-maps/MAP.md). → [`process-maps/README.md`](process-maps/README.md)

### [Meetingy](meetings/) · Delivery Lead
Přepisy schůzek s klientem (vlastní pipeline z audia). Drží **záměr a kontext „mezi řádky"** zadání — preference, omezení, nevyřčené priority; vstup do produktové vize. Doplňuje zadání, nenahrazuje ho. Není acceptance kritérium ani doménový kontrakt. → [`meetings/README.md`](meetings/README.md)

### [Současné řešení](current-solution/) · Delivery Lead
**Zdrojový kód stávající platformy** (Drupal projekt `patronus`) — 52 custom modulů + config + témata, **scrubnutý od osobních dat** (GDPR). Sdílený oficiální zdroj kódu pro tým a základ pro analýzu rozsahu. Current-state, **ne zdroj pravdy pro cílové chování** — při sporu vyhrává zadání. Kolik váhy má, závisí na rozhodnutí var. A (přepis) vs. B (upgrade). → [`current-solution/README.md`](current-solution/README.md)

### [Analýza současného řešení](current-solution-analysis/) · Analytik
**Derivované** zmapování rozsahu kódu `patronus` — přehledová i hloubková mapa entit/funkcí ([`scope-map.md`](current-solution-analysis/scope-map.md), [`deep-scope.md`](current-solution-analysis/deep-scope.md)), mapování stavů ([`state-map.md`](current-solution-analysis/state-map.md)), **verifikovaná gap analýza** proti zadání ([`gap-analysis.md`](current-solution-analysis/gap-analysis.md)) a podklad pro odhad ([`estimation-notes.md`](current-solution-analysis/estimation-notes.md)). Vstup pro odhad rozsahu a rozhodnutí var. A vs. B. **needs:** @analytik (schválení gapů). → [`current-solution-analysis/README.md`](current-solution-analysis/README.md)

## Konvence vrstvy

- **Self-contained složky.** Vše o artefaktu žije v jeho složce: `README.md` (rám + konvence + kurátorský log), volitelně `MAP.md` (rozcestník u komplexních), `_source/` (binární originály `.docx`/`.xlsx`), čitelné `.md` převody. Kurátorský log a changelog jsou **per-artefakt**, ne tady.
- **Hybrid originál + převod.** Kde je binární originál, žije v `_source/` a vedle něj je strojový `.md` převod pro čtení / grep / diff. **Při rozporu vyhrává originál.**

## Changelog

| Datum | Změna | Autor |
|---|---|---|
| 2026-07-01 | Přidány artefakty **Současné řešení** (scrubnutý kód `patronus`) a **Analýza současného řešení** (derivovaná scope-mapa + gap signály). | Libor Suchý |
| 2026-07-01 | README ztenčen na **čistý rozcestník** (index + orientační popis per artefakt). Průvodci přesunuti ze sidecarů `intake/*.md` do `<artefakt>/README.md` (self-contained složky po vzoru Endorphin); binární originály do `<artefakt>/_source/`. Orientace „Co je Patron Děti", stack a průřezová zjištění odsud odešly — vize patří do `product/`, per-artefakt poznatky žijí v jednotlivých README. | Libor Suchý |
| 2026-06-30 | README ztenčen na index vrstvy + průřezové poznámky; per-zdroj obsah rozdělen do 5 sidecarů. | Libor Suchý |
| 2026-06-30 | Založen intake: IT zadání, stavový model, testovací scénáře a procesní oblasti (CZ/RO/MD) v hybridní podobě (originál + `.md` převod). | Libor Suchý |
