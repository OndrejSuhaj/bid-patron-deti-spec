---
doc_id: JOB0002
title: Scheduled Page Publish and Homepage Swap
canonical_layer: JOB
spec_type: job-contract
status: canonical
modules: []
job_type: scheduler
references:
  - FN0025
  - EN0004
---

# JOB0002 – Naplánované publikování stránky a výměna domovské stránky

## Účel

Publikuje CMS obsahové stránky podmíněné datem, jejichž datum publikace je dnešní den, a volitelně
vymění domovskou stránku webu za nově publikovanou stránku. Realizuje větev ScheduledPublish z FN0025
(Workflow / Transition-Legality Engine & Scheduled Publish).

Klasifikace: **Confirmed** (vyhrazená cron service třída, plně podložená důkazy).

## Model spouštění

- Naplánované. Běží při každém tiku platformového cronu (hodinově, `0 * * * *` —
  `docker-compose.yml:70`) jako třetí jednotka cron hooku `patron_base`. **Bez** interní denní
  časové brzdy (na rozdíl od exportních/párovacích cronů), takže kandidáty vyhodnocuje při každém
  tiku.
- Evidence: `patron_base/patron_base.module:163,176` → služba `patron_base.scheduled_publish_cron`
  (`patron_base/src/PatronBaseScheduledPublishCron.php:60`). Dossier: FLW0033.

## Rozsah vstupu

- Nepublikované CMS page nody (bundly `page` / `page_cz`), jejichž datum publikace (bez času) se
  rovná **dnešnímu dni** v defaultní časové zóně webu. Výběr používá striktní rovnost (`= today`),
  nikoli `<= today`.
- Běží v systémovém kontextu s vypnutými kontrolami přístupu; řazeno vzestupně podle node id.

## Zpracovatelská pravidla

- Publikace každého splatného nodu (nepublikovaný → publikovaný), v pořadí nid.
- Výměna domovské stránky (pouze první příznakovaný node): pokud splatný node nese příznak
  replace-homepage a domovská stránka ještě nebyla v tomto běhu vyměněna, přesměruje alias
  `/homepage` na nový node, přejmenuje předchozí alias `/homepage` na `/homepage-{oldNid}` a
  odpublikuje dosavadní domovský node. Zámek platný pro daný běh zajišťuje maximálně jednu výměnu
  domovské stránky (vítězí nejnižší nid).

## Vedlejší efekty

- Zápisy do content nodu: přepnutí příznaku publikace u každého splatného nodu; při výměně je
  odpublikován předchozí domovský node. Zápisy path-aliasů: starý alias přejmenován, nový alias
  vytvořen. Viz EN0004 pro doménu kampaně/příběhu; pozor, tento job cílí na **CMS stránky**, nikoli
  na Campaigns/Stories.
- Každé uložení nodu spouští standardní pipeline pro ukládání obsahu (invalidace cache a zařazení do
  search-indexu, pokud je nakonfigurováno → JOB0013). Navazující efekty node-hooků zde nejsou
  sledovány (Hypothesis).
- Info log se souhrnem publikovaných node id a informací, zda byla domovská stránka vyměněna.
- Žádná volání externích systémů; žádná vlastní queue.

## Idempotence

- **Idempotentní v rámci dne.** Jednou publikovaný node má stav published a již nesplňuje predikát
  `status=0`; výměna domovské stránky je obdobně přirozeně idempotentní, protože zdrojový node
  výměny se stane publikovaným. Opakovaný běh ve stejný den je bezpečný.

## Zpracování chyb

- Publikační smyčka a výměna domovské stránky provádí několik nezávislých uložení **bez
  transakce**; fatální chyba uprostřed běhu (např. mezi přejmenováním starého aliasu a vytvořením
  nového) může nechat `/homepage` bez obslužného aliasu, bez rollbacku.
- Jakákoli výjimka je zalogována a **znovu vyhozena**, čímž se přeruší zbytek platformového cron
  běhu.
- **Chyba striktní rovnosti (riziko ztráty dat):** protože výběr je `publish_date = today`, celý
  vynechaný cron den (výpadek hostu, deploy) znamená, že stránka není nikdy automaticky publikována
  a zůstává nepublikovaná až do manuálního zásahu. Zdokumentované current-state riziko (FLW0033).

## Reference

- FN: FN0025
- UC: UC0022, UC0011
- EN: EN0004 (kontrast domén — publikace kampaně je JOB0003, nikoli tento job)
- Evidence: FLW0033

## Otevřené body

- Vícejazyčná domovská stránka: vyhledávání `/homepage` nemá jazykový filtr, takže u vícejazykového
  webu je nedeterministické, jaké jazykové verze domovské stránky se výměna týká. `Confirmed`
  mechanismus, `Hypothesis` reálná nejednoznačnost.
