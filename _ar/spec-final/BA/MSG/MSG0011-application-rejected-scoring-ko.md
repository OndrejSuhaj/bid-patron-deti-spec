---
doc_id: MSG0011
title: Application Rejected — Scoring KO
canonical_layer: MSG
spec_type: transactional-message
status: canonical
modules: []
trigger:
  - UC0002
  - UC0003
references:
  - EN0001
  - EN0017
  - EN0022
  - ES0006
---

# MSG0011 – Žádost zamítnuta — scoring ko

## Účel

Informovat obě strany u žádosti (EN0001) — rodiče/žadatele a patrona — že risk management případ
posoudil, zjistil diskvalifikující informaci a zamítl jej ve fázi scoringu. Zpráva zdvořile uzavírá
případ pro obě strany; **nezveřejňuje** diskvalifikující detail, který vedl k zamítnutí (tento detail
zůstává interní součástí scoring záznamu, EN0017, a poznámek risk manažera z posouzení).

---

## Spouštěč

UC0003 (posouzení rizika žadatele / scoring) — manuální scoringové rozhodnutí risk manažera, kdy
administrátor odešle scoringový formulář s výsledkem schválení jiným než "schváleno", zatímco byla
identifikována diskvalifikující informace (Notification Matrix / SC-5C kroky 1–5: risk manažer
posoudí, zdokumentuje diskvalifikující informaci, zamítne a stav žádosti se změní na `scoring_ko`;
SC-5D krok 13: stejný výsledek zamítnutí dosažený po žádosti o doplňující informace, kdy dodaná
informace byla shledána nedostatečnou) — následuje UC0002 (orchestrace změny stavu žádosti), jehož
navazující reakční rozvětvení (UC0002.2) odešle tuto zprávu poté, co je žádost (EN0001) uložena do
stavu `scoring_ko`, pro každou roli, jejíž odpovídající ApplicationReaction (EN0026) má povolený
e-mailový kanál.

Úroveň evidence: Confirmed pro stav `scoring_ko`, sadu rolí, které jej spouštějí, a jeho e-mailové
odeslání, na základě Notification Matrix (`intake/test-scenarios/test-scenarios.md`), řádky
`scoring_ko` / Parent a `scoring_ko` / Patron (u obou Email = YES), a na základě kroků 3–5 SC-5C
("Systém: Změní stav na 'Scoring KO'" → "Systém: Odešle e-mail o zamítnutí rodiči" → "Systém: Odešle
e-mail o zamítnutí patronovi"). Partial pro přesný krok UC0003, který by pojmenovával samotný přechod
`scoring_ko`: citovaný hlavní tok / alternativní toky UC0003 dokumentují cestu schválení do stavu
`scoring_ok` (hlavní tok krok 10; AF3) a cestu "podmínka schválení nesplněna" (AF2), která ponechává
stav žádosti beze změny, aniž by v textu dossier UC0003 pojmenovávala `scoring_ko` jako svůj cílový
stav; přechod `scoring_ko` a jeho podmínka diskvalifikující informace jsou doloženy přímo Notification
Matrix a akceptačními scénáři SC-5C/SC-5D, nikoli doslovně opakovány v UC0003 — zaznamenáno zde jako
mezera mezi zdroji, neřešená odvozením.

---

## Příjemci

- **Rodič / žadatel** — e-mail přes ES0006 (Mautic) + notifikace v zóně ("Neschváleno" — zóna rodiče),
  dle řádku Notification Matrix `scoring_ko` / Parent (Email = YES, notifikace v účtu = YES).
- **Patron** — e-mail přes ES0006 (Mautic) + notifikace v zóně ("Neschváleno" — zóna patrona), dle
  řádku Notification Matrix `scoring_ko` / Patron (Email = YES, notifikace v účtu = YES).

Obě strany dostávají u tohoto stavu oba kanály — na rozdíl od mnoha jiných zpráv řízených stavem
v Notification Matrix, které spouští pouze jeden kanál nebo pouze jednu roli. CZ je doloženým trhem
pro tuto zprávu (SC-5C/SC-5D); žádná odchylka obsahu pro RO/MD zde není tvrzena nad rámec standardního
rozlišení šablony podle země, které je již zaznamenáno na úrovni schopnosti (FN0019) — ekvivalentní
označení stavu pro RO/MD jsou zaznamenána v modelu stavů, zde nejsou opakována.

---

## Obsah zprávy

Koncepčně každé odeslání této zprávy nese:

- **Oznámení o zamítnutí** — jednoduché sdělení, že žádost (EN0001) byla posouzena risk managementem
  a **nebyla schválena**; případ je v tomto kroku uzavřen.
- **Referenci případu** — identifikaci předmětné žádosti (EN0001) a jejího souvisejícího dítěte/
  příběhu, aby příjemce rozpoznal, kterého případu se zpráva týká, v souladu s párovanou notifikací
  v zóně "Neschváleno".
- **Zdvořilé uzavření** — potvrzující/uzavírající tón odpovídající zamítnutí, bez přiřazení viny nebo
  vybízení k opětovnému podání (v citovaných zdrojích není doloženo, že by ze stavu `scoring_ko` byla
  nabízena cesta k opětovnému podání).

Výslovně vyloučeno z obsahu zprávy (zůstává interní, není sděleno rodiči ani patronovi):

- Samotná diskvalifikující informace (shoda s blacklistem, indikátor podvodu nebo jiný důvod
  zdokumentovaný risk manažerem) — ta zůstává v interním scoring záznamu (EN0017) a poznámkách risk
  manažera; evidence SC-5C tuto skutečnost udržuje pouze jako dokumentaci ("Problém zdokumentován
  v poznámkách scoringové karty"), nikdy se neobjevuje v odchozí zprávě.
- Jakékoli skóre scoringu, jeho rozpad nebo detail klasifikace blacklistu (spadá pod EN0017 / EN0016 —
  není záležitostí vrstvy zpráv).

V tomto kanonickém dokumentu není tvrzen žádný pevný text předmětu, značkování těla ani struktura
šablony (viz omezení v rules-MSG.md); konkrétní znění je instanční data řešená podle dvojice
`scoring_ko` × role ApplicationReaction (EN0026), v souladu s mechanismem popsaným v MSG0005.

Každé odeslání je archivováno jako záznam EmailArchive (EN0022) bez ohledu na to, zda k odeslání
skutečně dojde, dle stejného archivačního chování popsaného pro MSG0005.

---

## Poznámky

- **Odlišné od MSG0010** (zamítnutí out of scope — odlišný diskvalifikující stav/záměr, tímto
  dokumentem nepokrytý) a od **MSG0012** (protějšek schválení `scoring_ok`). Ačkoli by `scoring_ko`
  jinak spadalo do širokého souhrnu stavů v MSG0005 (který uvádí `scoring_ko` mezi svými zahrnutými
  stavy), toto zamítnutí je vyčleněno do vlastního MSG dokumentu zde z důvodu svého odlišného,
  vyššího významu (definitivní negativní risk rozhodnutí dosahující obě strany na obou kanálech) —
  výčet v MSG0005 je třeba pro `scoring_ko` číst jako nahrazený tímto vyhrazeným dokumentem.
- Protějšek schválení (`scoring_ok`) neodesílá **žádný e-mail** žádné ze stran — potvrzeno řádky
  Notification Matrix `scoring_ok` / Parent a `scoring_ok` / Patron (Email = NO u obou) a krokem 27
  SC-5A / krokem 26 SC-5B, které ukazují pouze zprávu v zóně "approved"; viz MSG0012 pro smlouvu
  této zprávy.
- Úroveň evidence pro celkový mechanismus (stav, role, kanály, štítek v zóně "Neschváleno"):
  Confirmed (Notification Matrix + SC-5C/SC-5D). Úroveň evidence pro přesnou mechaniku přechodu
  uvnitř UC0003, která produkuje `scoring_ko`: Partial (viz sekce Spouštěč) — označeno jako mezera
  mezi zdroji mezi dossier UC0003 a evidencí Notification Matrix/SC-5C, neřešená mlčky.
