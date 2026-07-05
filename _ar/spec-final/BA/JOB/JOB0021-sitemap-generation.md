---
doc_id: JOB0021
title: Sitemap Generation
layer: JOB
spec_type: job-contract
status: imported
modules: []
job_type: batch
references:
  - FN0006
  - EN0004
---

# JOB0021 – Generování mapy webu (sitemap)

## Účel

Vygenerovat veřejný `sitemap.xml` se seznamem všech URL publikovaných Kampaní/Příběhů a statického
seznamu stránek. Podpůrná SEO dávka pro obsahové výstupy FN0006 (Řízení životního cyklu Kampaně /
Příběhu).

Klasifikace: **Confirmed**.

## Model spouštění

- Dávkový / CLI (Drupal Console) příkaz `sitemap:create`. Spouští jej operátor nebo externí systém;
  ve zdrojovém kódu není zapojení cronu.
- Důkaz: `sitemap/src/Command/GenerateSitemapCommand.php` (`setName('sitemap:create')`).

## Rozsah vstupu

- Všechny řádky publikovaných Kampaní (id + časové razítko poslední změny) a dále statický seznam
  stránek načtený ze souboru JSON na základní URL SPA (se zapevněnou externí pastebin zálohou).
  Viz EN0004.

## Zpracovatelská pravidla

- Sestavit množinu URL: jeden záznam pro každou statickou stránku a jeden pro každou publikovanou
  Kampaň (kanonická URL, last-mod odvozeno z časového razítka poslední změny, fixní
  change-frequency/priority); XML zapsat do veřejné oblasti souborů.

## Vedlejší efekty

- Zápis `sitemap.xml` do veřejné oblasti souborů. Odchozí HTTP GET pro načtení seznamu statických
  stránek (URL SPA, případně pastebin záloha). Bez mutace domainové entity.

## Idempotence

- **Idempotentní** — každý běh plně přegeneruje a přepíše soubor sitemap na základě aktuálně
  publikovaných kampaní.

## Zpracování chyb

- Pokud není JSON se seznamem stránek SPA dostupný, použije se zapevněná externí pastebin URL jako
  záloha; pokud selže i tato, vygenerují se pouze URL kampaní. Bez smyčky opakování.

## Odkazy

- FN: FN0006
- UC: UC0011
- EN: EN0004
- Důkaz: GenerateSitemapCommand

## Otevřené body

- Závislost na externí pastebin URL jako záložním zdroji dat je bezpečnostní/robustnostní riziko
  (zdokumentováno, nikoli redesignováno). Plánování spouštění není ve zdrojovém kódu doloženo.
  `Hypothesis`.
