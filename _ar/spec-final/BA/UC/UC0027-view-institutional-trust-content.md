---
doc_id: UC0027
title: View Institutional & Trust Content
layer: UC
spec_type: use-case
status: imported
modules: []
---

# UC0027 — Zobrazení institucionálního a důvěryhodnostního obsahu

## Hlavička

| Pole | Hodnota |
|---|---|
| UC ID | UC0027 |
| Název | Zobrazení institucionálního a důvěryhodnostního obsahu |
| Bounded Context | Žádný — veřejný statický obsah, mimo doménové jádro C1–C11 (`ARCH0001_ApplicationOverview.md` §4) |
| Primární aktér(y) | Anonymní návštěvník |
| Typ spouštěče | UI (načtení veřejné stránky) |

## Aktéři a odpovědnosti

- **Anonymní návštěvník** — přejde na stránku "O nás" (`/o-nas`) z globální navigace webu nebo z
  patičky, přečte si statický institucionální/důvěryhodnostní obsah a volitelně si stáhne jeden z
  publikovaných dokumentů (etický kodex, výroční zpráva, kontrolní protokol veřejné sbírky).
- **Systém** — poskytne požadovaný obsah jako jedinou, staticky autorovanou veřejnou stránku; neuplatňují
  se žádné parametry, filtry ani stav specifický pro daného návštěvníka. Za touto stránkou není žádná
  orchestrace, výpočet ani čtení doménové entity nad rámec běžného vykreslení CMS stránky a doručení
  statického souboru.

## Záměr

Umožnit anonymnímu návštěvníkovi zjistit, kdo provozuje Patron dětí, vidět projektový tým a ujistit se,
že organizace je legitimní a odpovědná — poslání, seznam týmu (koordinátorka, výkonná/provozní ředitelka,
fundraiser, HR, finance, IT), etický kodex ("Desatero"), auditované výroční zprávy (2018–2024) a
kontrolní protokoly veřejné sbírky (2018–2024) — a stáhnout si kterýkoli z těchto dokumentů. Jde o
**pouze pro čtení určenou důvěryhodnostní/transparentní plochu** s nenápadným, ale legitimním cílem
uživatele (ujištění před darováním nebo podáním žádosti); nenapájí, negatuje ani nemění žádný jiný UC v
tomto systému. Realizuje obrazovku **S015** a je jednou z obrazovek s obsahem "blocked-no-uc" již
zaznamenaných v `_ar/spec-draft/IA-screen-map.md` a `_ar/spec-draft/WIRE-screen-coverage.md` — je zde
zdokumentován jako odlehčený UC pouze proto, aby uzavřel mezeru v pokrytí UC pro S015, nikoli proto, že
by bylo objeveno nové doménové chování.

**Poznámka k rozsahu (pouze current-state):** podle pokynů projektu je redesign/rebuild řešení stránky
"O nás" a sesterské plochy Blog mimo rozsah tohoto rekonstrukčního průchodu (rebuild epic E0004,
nepostaveno). Tento UC dokumentuje **pouze to, jak se stránka chová dnes**; nečiní žádné tvrzení o
cílovém (target-state) návrhu a ani jej nepředjímá.

## Předpoklady

- Žádné. Stránka nevyžaduje autentizaci, žádný předchozí doménový stav (nemusí existovat Lead,
  Application, Campaign ani Transaction) a žádné parametry dotazu.

## Hlavní tok

1. Návštěvník: zvolí "O nás" z globální hlavní navigace, nebo odkaz v patičce ("O nás" / "Výroční
   zprávy" směřující na kotvu na stránce `/o-nas#vyrocni-zpravy`) — oba doslovné cíle odkazů v menu jsou
   programově nastaveny na `/o-nas` pro menu `main-navigation-cz` a `footer-cz`
   (`_patron_base_update_cz_menu_links()`,
   `web/modules/custom/patron_base/patron_base.module:457-479`).
2. Systém: rozřeší `/o-nas` a vykreslí obsah stránky — poslání, sekci týmu (popisky rolí: koordinátorka,
   výkonná/provozní ředitelka, fundraiser, HR, finance, IT), banner etického kodexu ("Desatero"), archiv
   výročních zpráv (dlaždice po letech, 2018–2024), archiv kontrolních protokolů veřejné sbírky (dlaždice
   po letech, 2018–2024), korespondenční/fakturační adresu organizace a výzvu ke sledování na Facebooku —
   podle pozorované evidence (`_ar/evidence/ui/ui-observed-areas.md` §16).
3. Návštěvník: čte obsah (ke konzumaci obsahu není potřeba žádná interakce).
4. Návštěvník (volitelně): zvolí "Stáhnout Desatero", nebo "Stáhnout" u výroční zprávy či kontrolního
   protokolu za konkrétní rok.
5. Systém: poskytne odpovídající statický soubor k přímému stažení (žádné generování, žádná kontrola
   přístupu nad rámec běžného doručení veřejného souboru — v souladu se sesterskými statickými odkazy na
   PDF ve stejném mapování patičkového menu, např. `/files/Pravidla_poskytovani_pomoci_projektu_PATRON.pdf`,
   `/files/nase_desetaro.pdf`, `web/modules/custom/patron_base/patron_base.module:459-470`).

## Alternativní toky

### AF1 — Návštěvník sleduje odkaz "Výroční zprávy" v patičce přímo na sekci archivu

1. Návštěvník: zvolí odkaz v patičce "Výroční zprávy", jehož cíl je stejná route `/o-nas` s kotvou na
   stránce (`/o-nas#vyrocni-zpravy`).
2. Systém: vykreslí stejnou stránku jako v hlavním toku; kotva posune návštěvníka přímo na sekci
   výročních zpráv — Confirmed jako routovací cíl
   (`patron_base.module:469`), Uncertain, zda je samotné chování kotvy/scrollování doloženo nad rámec
   fragmentu URL (chování scroll-to-anchor na frontendu není v tomto zdrojovém průchodu prozkoumáno).

### AF2 — Za stránkou není žádný vyhrazený backendový modul ani entita

1. Nikde v `intake/current-solution/_source/patronus/` nebyla nalezena žádná vlastní Drupal route,
   kontroler ani REST resource pojmenovaná pro "o-nas" (nebo ekvivalentní strojový název `o_nas`/`onas`)
   — jediné výskyty doslovného řetězce `o-nas` ve zdrojovém kódu vlastních modulů jsou dvě mapování URI
   odkazů v menu v `patron_base.module` (řádky 464, 469, 475), která směřují položky navigace "O nás" a
   patičky a položku patičky "Výroční zprávy" na danou cestu.
2. Základní typ obsahu Drupalu `page` / `page_cz` (obecný typ uzlu typu basic-page, konfigurace
   `config/node.type.page.yml`, `config/node.type.page_cz.yml`) je přítomen ve zredukované konfiguraci a
   je jediným obecným mechanismem tvorby obsahu doloženým pro samostatné statické stránky v tomto
   kódu — nejsou k němu připojena žádná vlastní pole, view modes ani business logika nad rámec pole
   `body` a metatagů.
3. **Partial / Hypothesis** — nejpravděpodobnější je, že `/o-nas` je obyčejný obsahový uzel (typu `page`
   nebo `page_cz`, případně ekvivalentní CMS stránka), jehož aliasem cesty je `/o-nas`, autorovaný a
   udržovaný editorsky, bez vlastního modulu. Toto **není přímo potvrzeno** — v GDPR-zredukovaném
   zdrojovém stromu obsahujícím pouze kód nejsou přítomny žádný záznam aliasu cesty pro `/o-nas` ani
   instance uzlu (konfigurace `path_alias` obsahuje pouze
   `language.content_settings.path_alias.path_alias.yml`, což je nastavovací shim, nikoli skutečná data
   aliasu; data obsahu/entit nejsou součástí zredukovaného intake). Zaznamenáno jako zdokumentovaná
   mezera, nikoli vyřešeno domýšlením.

## Postpodmínky

- Žádný doménový agregát (Lead, Application, Campaign, Transaction, User atd.) není tímto UC čten,
  zapisován ani jinak ovlivněn. Jde o čistou schopnost poskytovat obsah bez vedlejších účinků.
- Návštěvník má k dispozici informační obsah a volitelně stažený dokument; v důsledku toho není nikde v
  systému zaznamenána žádná změna stavu.

## Traceability (sledovatelnost)

Cílové SRV:
- Žádné — tento UC nepracuje s žádnou z rekonstruovaných doménových služeb/agregátů (ekvivalent
  SRV0001–SRV0013 pod C1–C11); jde o doručování statického obsahu na úrovni CMS.

EN entity:
- Žádné — tímto UC není čtena ani zapisována žádná rekonstruovaná doménová entita (rozsah
  EN0001–EN0034). Obsah "tým"/"výroční zpráva"/"kontrolní protokol" je editorský text a statické
  soubory, nikoli modelovaná doménová entita.

Integrační hranice:
- Žádné — pro vykreslení této stránky ani doručení odkazovaného dokumentu se nevolá žádný externí
  systém (na rozdíl např. od integrací ES vrstvy použitých jinde na platformě).

Doklady obrazovky / UI:
- Obrazovka **S015** — "O nás — about / team / documents" (`_ar/spec-draft/IA-screen-map.md`, řádek
  S015; `_ar/spec-final/UX/IA/IA-patronus.md` — před tímto průchodem uvedena jako statická/institucionální,
  "žádné UC").
- `_ar/spec-draft/WIRE-screen-coverage.md` — S015 zaznamenáno jako "blocked-no-uc … statická
  institucionální stránka; neexistuje orchestrovaný UC; podle pravidla WIRE hard rule 1 nebyl zapsán
  žádný soubor WIRE." Tento UC toto rozhodnutí WIRE nevyvrací; existuje pouze proto, aby S015 poskytl
  odlehčený záznam UC pro účely sledovatelnosti/úplnosti registru, v souladu s nenáročnou, pouze pro
  čtení určenou povahou obrazovky.
- UI evidence: `_ar/evidence/ui/ui-observed-areas.md` §16 ("O nás — about / team / documents (`/o-nas`)"),
  screenshot `screencapture-patrondeti-cz-o-nas-2026-07-04-13_17_32.png`.
- Zdroj: `web/modules/custom/patron_base/patron_base.module:457-479` (mapování URI odkazů v menu pro
  `main-navigation-cz` a `footer-cz`, včetně cílů `/o-nas` a `/o-nas#vyrocni-zpravy`);
  `config/node.type.page.yml`, `config/node.type.page_cz.yml` (obecný typ obsahu basic-page, Hypothesis
  pro podkladový mechanismus obsahu — viz AF2).
- Související/sousední, ne sloučeno: obrazovka S016 (`/vysledky`, "Výsledky" — stránka
  how-it-works/důvěra/statistiky, UI evidence §17) je samostatná obrazovka s vlastním odkazem v patičce
  ("Splněné příběhy" → `/vysledky`); je mimo rozsah tohoto UC.
- Mimo rozsah dle pokynu projektu: rebuild epic E0004 (blog + redesign "O nás") je cílový stav
  (target-state), zde nedoložený a tímto UC nepředjímaný.

## Úroveň evidence

**Confirmed** pro pozorovaný obsah a strukturu stránky (poslání, role týmu, Desatero, archivy
dokumentů výročních zpráv a kontrolních protokolů 2018–2024, korespondenční/fakturační adresa, výzva k
sledování na Facebooku) a pro navigaci/routing z patičky, které návštěvníka směřují na `/o-nas` — obojí
je přímo doloženo UI screenshotem (`ui-observed-areas.md` §16) a mapováním odkazů v menu v
`patron_base.module`. **Partial** pro mechanismus poskytování: ve zredukovaném zdrojovém kódu neexistuje
žádný vyhrazený vlastní modul, kontroler ani REST resource pro "o-nas" a nejpravděpodobnější vysvětlení —
obyčejný uzel basic-page typu `page`/`page_cz` s aliasem cesty `/o-nas`, udržovaný čistě jako editorský
obsah — je Hypothesis, nikoli přímo potvrzený fakt, jelikož data instance uzlu/obsahu a aliasu cesty
nejsou součástí GDPR-zredukovaného intake obsahujícího pouze kód. Pro tuto obrazovku neexistuje žádné
pokrytí procesní mapou, testovacím scénářem ani `it-zadani` (v souladu s tím, že jde o statickou/editorskou
plochu, nikoli o workflow sledovaný ostatními zdroji evidence tohoto pipeline).
