---
doc_id: UC0022
title: Run Platform Workflow Engine & Scheduled Publish
canonical_layer: UC
spec_type: use-case
status: canonical
modules: []
---

# UC0022 — Spuštění platformového Workflow Engine a plánovaného publikování

## Hlavička

| Pole | Hodnota |
|---|---|
| ID UC | UC0022 |
| Název | Spuštění platformového Workflow Engine a plánovaného publikování |
| Bounded Context | C11 |
| Primární aktér(y) | System, Scheduler |
| Typ spouštěče | Config/Cron |

## Aktéři a odpovědnosti

- **Scheduler** — spouští platformový opakující se cron pro plánované publikování v pevném intervalu (tick), bez lidské interakce (samotný lifecycle cron je vlastněn UC0011).
- **System** — hostí bránu Workflow-Engine pro povolené přechody / kontrolu připravenosti (readiness gate), která řídí, jaké změny stavu jsou legální, a (pro zde vlastněnou trasu plánovaného publikování) se od něj očekává, že prostřednictvím této brány povýší datově podmíněný obsah do publikovaného stavu; přechody životního cyklu, které brána řídí, jsou vykonávány v UC0011.
- **Admin** — (podpůrný, nikoli primární) ručně spouští akci publikace/aktivace, která prochází stejnou bránou Workflow-Engine; zde je uveden pouze kvůli pojmenování brány, nikoli jako vlastník tohoto toku v rámci tohoto UC — tento tok vlastní UC0011.
- **Reference-Data** (podpůrné vyhledávání) — poskytuje sdílené referenční hodnoty (např. geografické číselníky), které logika publikování příležitostně využívá; nejde o aktéra rozhodujícího o výsledku.

## Záměr

Poskytnout platformní bránu Workflow-Engine pro povolené přechody / kontrolu připravenosti, která řídí legální změny stavu, a spouštět úlohu plánovaného publikování, jež povyšuje datově podmíněný CMS obsah do publikovaného stavu bez toho, aby každou změnu inicioval lidský aktér. Přechody životního cyklu, které brána řídí (publikace kampaně, přechod do stavu po termínu / target amount not collected vlivem deadline), jsou vykonávány v UC0011 a zde nejsou popisovány. Poznámka (z vytěženého dossieru k plánovanému publikování FLW0033): úloha plánovaného publikování je přímou cestou publikace uzlu (node), která sama o sobě neprochází bránou Workflow-Engine.

## Předpoklady

- Existuje konfigurace workflow/přechodů, která definuje povolené stavy a rolemi podmíněné přechody pro Žádost (EN0001).
- Scheduler tick (platformový cron) je nakonfigurován a běží.
- Pro zde vlastněný dílčí tok plánovaného publikování: existují položky CMS uzlů `page`/`page_cz`, které jsou nepublikované a mají `publish_date` rovné aktuálnímu dni (doloženo — FLW0033; viz Úroveň evidence).

## Hlavní tok

> Poznámka k rozsahu: brána povolených přechodů a kontroly připravenosti vynucovaná SRV Workflow-Engine zde není popisována — je v plném rozsahu vykonávána v UC0011 (publikace kampaně, UC0011.1; přechod kampaně do stavu po termínu vlivem deadline, UC0011.2). Viz UC0011 pro tento tok, jeho alternativní toky a jeho postpodmínky. Toto UC vlastní pouze níže uvedený dílčí tok plánovaného publikování (FLW0033).

### UC0022.1 — Plánované publikování datově podmíněného obsahu (Confirmed — FLW0033)

1. Scheduler: spouští úlohu plánovaného publikování při každém ticku platformového cronu (`patron_base_cron`).
2. System: vybírá CMS uzly `page`/`page_cz`, které jsou nepublikované (`status = 0`) a jejichž `publish_date` se rovná **dnešnímu dni** (striktní rovnost data, v časovém pásmu výchozím pro daný web), seřazené vzestupně podle id uzlu, a každý povyšuje na publikovaný (`status 0 → 1`).
3. System: u prvního splatného uzlu (nejnižší nid), který nese příznak `replace_homepage`, provede výměnu aliasu `/homepage` — předchozí homepage uzel je odpublikován, jeho alias `/homepage` je přejmenován na `/homepage-{oldNid}` a pro nově publikovaný uzel je vytvořen nový alias `/homepage`. Za jeden běh dojde nejvýše k jedné výměně homepage.
4. System: zapíše informační řádek logu zaznamenávající id publikovaných uzlů a to, zda došlo k výměně homepage.

> Stav: Confirmed (FLW0033). Korekce rozsahu oproti vytěženému dossieru: úloha plánovaného publikování povyšuje výhradně **uzly (node)** CMS balíčků `page`/`page_cz` — **ne**publikuje Žádosti (EN0001) ani Kampaně (EN0004); publikace kampaní / automatické dokončení žije v samostatném toku (campaign_cron / UC0011). Striktní rovnost `publish_date = today` (nikoli `<=`) znamená, že vynechaný den cronu nebo uzel s datem v minulosti se nikdy automaticky nepublikuje (zůstává nepublikovaný, dokud nedojde k ruční publikaci) — jde o riziko korektnosti přeneseného ze zdrojového dossieru pro současný stav. Tato trasa plánovaného publikování **ne**prochází bránou legality přechodů Workflow-Engine; nevynucování této brány je samostatná mezera v současném stavu (viz Úroveň evidence).

## Alternativní toky

> Alternativy pro chybové stavy a zamítnutí bránou u tras lifecycle-cron a readiness-gate (zpracování dávkových chyb u deadline, blokování publikační akce konfigurací připravenosti/workflow) jsou vlastněny UC0011 (viz UC0011 AF1–AF3) a zde nejsou opakovány.

### AF1 — Selhání plánovaného publikování / no-op výměny homepage

1. System: narazí na chybu při publikaci splatného uzlu nebo při výměně aliasu homepage.

Výsledek (FLW0033): publikační smyčka a výměna homepage provádějí několik nezávislých uložení **bez DB transakce**, takže fatální chyba uprostřed běhu může zanechat částečné zápisy (např. alias `/homepage` přejmenovaný, aniž by jakýkoli alias obsluhoval `/homepage`). Jakákoli výjimka je zalogována (kanál `reports`) a **znovu vyhozena**, čímž se přeruší zbytek běhu cronu `patron_base`. Výměna homepage rovněž tiše selže bez efektu (no-op) — publikuje uzel, ale nepřepne homepage — pokud alias `/homepage` neexistuje nebo neukazuje na cestu `/node/{n}`.

## Postpodmínky

- Postpodmínky přechodu životního cyklu a brány připravenosti (přechod po termínu do stavu nesplněno, aktivace po průchodu bránou a výsledné notifikace a re-indexace) jsou vlastněny UC0011 — viz Postpodmínky UC0011; zde nejsou opakovány.
- Dílčí tok plánovaného publikování (UC0022.1, FLW0033): nula nebo více uzlů `page`/`page_cz` s `publish_date == today` přejde ze stavu nepublikováno → publikováno; pokud publikovaný uzel nesl příznak `replace_homepage` (první podle nid), alias `/homepage` nyní ukazuje na něj, starý alias je přejmenován na `/homepage-{oldNid}` a dříve homepage uzel je odpublikován; informační řádek logu zaznamená danou dávku. Uzly, jejichž den publikace byl vynechán, zůstávají nepublikované (mezera dané striktní rovností).

## Sledovatelnost (Traceability)

Cílové SRV:
- Workflow-Engine
- ScheduledPublish-Processor
- Reference-Data

EN entity:
- EN0001 Žádost — subjekt konfigurace přechodů Workflow-Engine a jejích změn stavu (brána vykonávaná v UC0011); NENÍ subjektem dílčího toku plánovaného publikování (FLW0033 potvrzuje, že plánovaná publikace cílí na CMS uzlové balíčky `page`/`page_cz`, nikoli na Žádost).
- EN0004 Kampaň — subjekt přechodů podmíněných readiness gate při publikaci/přechodu do stavu nesplněno (vykonáváno v UC0011); NENÍ subjektem dílčího toku plánovaného publikování (dle korekce rozsahu FLW0033). CMS obsah `page`/`page_cz` publikovaný v UC0022.1 je uzlový balíček Drupalu bez vyhrazené EN entity.

Integrační hranice:
- Žádné (interní mutace scheduleru / entity a path_alias; žádný externí systém volaný tímto UC — potvrzeno FLW0033).

Evidence toků (Flow Evidence):
- FLW0033 (vytěženo; dříve flow-index FL057) — plánovaná publikace `patron_base_cron`: datově-rovná publikace uzlů `page`/`page_cz` + výměna aliasu `/homepage` pro první označený uzel. Vlastní Confirmed kotva tohoto UC pro dílčí tok plánovaného publikování (UC0022.1).
- FLW0021 / FLW0022 (převzato z UC0011, zde nevlastněno — brána povolených přechodů/readiness gate Workflow-Engine je vykonávána UC0011.1 publikací kampaně a UC0011.2 přechodem do stavu po termínu vlivem deadline; uvedeno jen jako křížový odkaz, nikoli jako vlastní kotvy UC0022)

## Úroveň evidence

Confirmed pro dílčí tok plánovaného publikování (UC0022.1), nyní když je vytěženo FLW0033: úloha `patron_base_cron`, striktní výběr uzlů dle rovnosti `publish_date = today`, publikační smyčka a výměna aliasu `/homepage` jsou doloženy ve vyhrazené servisní třídě. Korekce rozsahu oproti dossieru: plánovaná publikace cílí výhradně na CMS uzly `page`/`page_cz` (nikoli na Žádost/Kampaň) a neprochází bránou Workflow-Engine.

Samotná **brána povolených přechodů / kontroly připravenosti Workflow-Engine** je zde doložena pouze nepřímo, křížovým odkazem na UC0011 (které vlastní FLW0021/FLW0022 jako své Confirmed kotvy); UC0022 tyto toky znovu nepopisuje. Její **legalita přechodů není v současném stavu z velké části vynucována** — živé formuláře pro změnu stavu umožňují, aby změna stavu dosáhla kteréhokoli ze stavů workflow bez jakékoli serverové kontroly přechodu nebo role (viz SRV-flow-traceability §5, porušení hranice 5, FLW0002). Toto je mezera v pravidlech/chování současného stavu (BR), **nikoli** mezera v evidenci: FLW0033 potvrzuje, že tok plánovaného publikování je nyní doložen, ale neuzavírá mezeru v nevynucené legalitě přechodů.
