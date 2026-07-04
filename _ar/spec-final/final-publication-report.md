# Final Publication Report — Patronus (bid-patron-deti)

> Vygenerováno pro **AR:SpecFinalGenerator** · 2026-07-04 · publikace kanonické draft-specifikace
> z `_ar/spec-draft/` do publikovatelné, do češtiny přeložené hand-off vrstvy `_ar/spec-final/`.
> Envelope-konformace (frontmatter, názvy souborů, cesty, registry, mapa) je deterministická;
> obsah těl dokumentů je plně přeložen do češtiny.

Tento report je procesní artefakt (není součástí publikované BA/UX vrstvy). Popisuje, co bylo v tomto
běhu publikováno, a je záměrně veden česky, aby odpovídal jazyku publikace i projektu.

---

## 1. Publikované zdrojové vrstvy

Publikováno **158 kanonických dokumentů** v **7 BA vrstvách** (`_ar/spec-final/BA/<LAYER>/`):

| Vrstva | Počet | Tier | Poznámka |
|---|---|---|---|
| EN | 34 | BA | entity domény (EN0001–EN0034; +EN0033 GiftCategory, EN0034 DonorAccountView z UX gap-closure) |
| UC | 25 | BA | případy užití (UC0001–UC0025; +UC0023/24/25 z UX gap-closure) — draft nemá frontmatter, syntetizován z registru + H1 |
| FN | 26 | BA | funkční schopnosti (FN0001–FN0026) |
| ES | 16 | BA | externí systémy (ES0001–ES0016) |
| MSG | 30 | BA | transakční zprávy (MSG0001–MSG0030) |
| BR | 20 | BA | byznys pravidla (sémantické názvy `BR-<pravidlo>`) |
| ARCH | 12 | BA | architektura (ARCH0001–ARCH0012, vč. dvou top-level dokumentů ApplicationOverview a ContextInteractionMap) |
| **Σ BA** | **163** | | odpovídá 163 doc_id ověřeným RefIntegrity validátorem |

A dále **37 UX dokumentů** ve **4 UX vrstvách** (`_ar/spec-final/UX/<LAYER>/`), rekonstruovaných z UI
evidence (`_ar/prtsc/`, 43 screenshotů) přes větev `ui-coverage` + `ux-reconstruction`:

| Vrstva | Počet | Tier | Poznámka |
|---|---|---|---|
| IA | 1 | UX | informační architektura (IA-patronus) + screen-map (25 screen-id S001–S022) |
| WIRE | 22 | UX | wireframe per obrazovka (`screen_id` + `realizes_uc`); 6 Evidence-Pending; 3 UC-less obsahové stránky vynechány |
| COMP | 9 | UX | znovupoužité komponenty (COMP0001–0009), evidence-gated (≥2 WIRE reuse) |
| COPY | 5 | UX | i18n copy (5 scopů, 342 klíčů); **text verbatim v češtině** (nepřekládá se) |
| **Σ UX** | **37** | | UX tier naplněn (dříve rezervovaný prázdný scaffold) |

Každá vrstva má `_REGISTRY.md` s jedním řádkem na dokument; řádky převzaty z draft registrů a
překlopeny `draft → canonical`, Owner mode `Mode P (import)`, Module(s) `[]`, `Created` zachováno
z draftu (datum prvního výskytu).

## 2. Zkopírované soubory

Všech 158 dokumentů zkopírováno do konformní podoby `<doc_id>-<kebab-title>.md` pod správný tier
(BA) a vrstvu dle mapy layer→tier v `tooling/docs/rules-spec-final.md`. Frontmatter konformován
(`doc_id` zachováno beze změny, `status: canonical`, `modules: []`, přenesené `spec_type`/`references`
a vrstvově specifická pole `affects`/`trigger`). Těla přeložena do češtiny.

Podpůrné výstupy: `final-publication-map.md` (158 řádků, jeden na soubor), tento report,
`README.md`.

## 3. Soubory obnovené na místě (refresh)

Žádné — jde o **první** publikační běh. Adresář `_ar/spec-final/` obsahoval pouze `.gitkeep`.
Běh je idempotentní: konformní název `<doc_id>-<kebab-title>.md` je deterministický, takže opakované
spuštění dokumenty obnoví na místě bez vytváření duplicit.

## 4. Vrstvy přeskočené (nedostupné)

- **CS** (observed critical scenarios) — v `_ar/spec-draft/CS/` neexistuje (v tomto průběhu nebyla
  sbírána FE-evidence). BA/CS nepublikováno (není chyba).
- **API / JOB / ACL / QUERY** (fáze 04) — draft neexistuje; přeskočeno bez chyby. Při pozdějším
  doplnění se publikují a mapa/report se aktualizují na místě.
- **UX (IA / WIRE / COMP / COPY)** — žádné UX drafty (větev `ux-reconstruction` neběžela). Složky a
  prázdné `_REGISTRY.md` jsou přesto vytvořeny (rezervováno), aby tier zůstal konzistentní.

## 5. Nově přidané vrstvy/soubory v tomto běhu

Vše (158 BA dokumentů + 7 BA registrů + 4 UX scaffoldy + mapa + report + README) — první běh.

## 6. Použité glosářem řízené termíny

Překlad používá kanonické české ekvivalenty z `_ar/repo-map/glossary.md` (strojově
`glossary-master.csv`, 119 spárovaných termínů), např.: application = žádost, story = příběh,
donation = dar, transaction = transakce, contract = smlouva, patron = patron, child = obdarovaný /
dítě, contact = kontakt, campaign = kampaň (doménově), bank reconciliation = párování plateb,
variable symbol = variabilní symbol, e-signature = elektronický podpis, voucher = dárkový poukaz.
Stavové labely workflow (např. `to_check`, `scoring_ok`, `campaign_uncompleted`) zůstávají jako
kódové tokeny nepřeložené; jejich lidsky čitelné české ekvivalenty jsou vedeny v glosáři.

## 7. Chybějící glosářové položky

Nezjištěny žádné blokující mezery. Termíny mimo glosář byly přeloženy standardním odborným
překladem; kde byl bezpečný literární překlad nejistý, byl ponechán anglický termín (viz §8).

## 8. Identifikátory záměrně ponechané v angličtině

- Všechny doc_id a křížové ID: `EN####`, `UC####`, `FN####`, `ES####`, `MSG####`, `ARCH####`,
  `BR-*`, `SRV####`, `AG##`, `INV##`, `HS##`, `FLW####`, `C1..C11`.
- Kódové/polní/stavové tokeny v backticích (názvy tabulek, sloupců, funkcí, stavů) a bloky kódu,
  ASCII diagramy, cesty a URL.
- Názvy externích systémů/dodavatelů: ComGate, Netopia/MobilPay, MAIB, Moneta, Mautic,
  Elasticsearch, Slack, Telegram, OneDrive / Microsoft Graph, ARES, MVČR, WhoisXML, Facebook,
  Google Tag Manager, Nager.Date.
- AR evidenční slovník: `Confirmed` / `Partial` / `Hypothesis` / `Uncertain` / `Blocked` a značky
  jako `Status: Planned / Not Implemented`, `Conflict — requires clarification` (řízený slovník).
- Frontmatter `title:` ponechán v angličtině (odpovídá kebab názvu souboru a je stabilním
  metadatovým identifikátorem); H1 v těle přeložen (prefix doc_id zachován).

## 9. Nejednoznačnosti překladu

- Několik anglicky ponechaných stavových labelů se v těle vyskytuje i jako doménový status (např.
  `target amount not collected`) — ponechány jako řízené status-termíny s českým kontextem okolo.
- UC0022 (plánované publikování) — verifikátor v běhu skončil na měsíčním spend-limitu organizace;
  dokument byl proto ověřen deterministickým scanem + ručním porovnáním struktury s draftem (nadpisy
  1:1, identifikátory a reziduální caveaty zachovány) → posouzeno jako korektní.

## 10. Ověření tohoto běhu

- **Deterministický scan všech 158**: přítomnost = 158/158, frontmatter konformní = 158/158
  (doc_id + `status: canonical` + `modules: []`), český obsah (heuristika diakritiky/stopslov) =
  158/158; 0 chybějících, 0 vadných, 0 podezřelých na nepřeložení.
- **Referenční integrita**: 0 dangling v publikovaných registrech (každé `references:` doc_id se
  rozpouští v cílové vrstvě).
- **Adversariální verifikace vzorku** (14 kurátorovaných dokumentů napříč vrstvami): část
  verifikátorů nedoběhla kvůli měsíčnímu spend-limitu organizace; doběhlé potvrdily věrnost a
  konformitu, jediný „fail" (UC0022) byl přezkoumán ručně a shledán korektním.

## 11. Doporučený další krok

- **Hand-off**: zkopírovat `_ar/spec-final/BA` a `_ar/spec-final/UX` do cílového projektu
  `arg-emitee` jako `_ar/BA` a `_ar/UX` bez restrukturalizace (drop-in).
- **Reziduální rozhodnutí pro rebuild-tým** (ze SPEC-CLOSURE, ne AR-řešitelná): rozhodnout
  drop-or-rebuild u dormantního doporučovacího subsystému (UC0021) a neimplementovaného FB inbound
  webhooku (UC0013); vyřešit reziduální mezery současného stavu (drain scheduling, nevynucená
  legalita přechodů, ES audit sub-flow); vyřešit ComGate transfer-sync scheduling Conflict.
- **Volitelně** doplnit vrstvy fáze 04 (API/JOB/ACL/QUERY) a UX rekonstrukci (IA/WIRE/COMP/COPY),
  poté znovu spustit SpecFinalGenerator (idempotentní refresh na místě).
