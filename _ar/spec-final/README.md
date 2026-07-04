# Patronus — finální specifikace (spec-final, česky)

Publikovatelná, do češtiny přeložená **hand-off vrstva** rekonstrukce současného stavu platformy
**Patronus** (dárcovská / patronátní platforma nad Drupalem, CZ / RO / MD). Vzniká agentem
`AR:SpecFinalGenerator` z kanonického draftu v `_ar/spec-draft/`.

## Co to je

Rekonstrukce **současného chování** systému (nikoli cílového zadání `it-zadani`), rozvržená do
kanonických vrstev a přeložená do češtiny. Určeno jako **drop-in** vstup pro rebuild `bid-patron-deti`
/ sesterský systém `arg-emitee`: složky `BA/` a `UX/` se zkopírují do cílového projektu jako `_ar/BA`
a `_ar/UX` bez restrukturalizace.

## Struktura

```
_ar/spec-final/
  BA/                      # Business Analysis tier (163 dokumentů)
    EN/    (34)  entity domény (vč. EN0033 GiftCategory, EN0034 DonorAccountView)
    UC/    (25)  případy užití (vč. UC0023 katalog příběhů, UC0024 správa účtu, UC0025 draft žádosti)
    FN/    (26)  funkční schopnosti
    ES/    (16)  externí systémy
    MSG/   (30)  transakční zprávy
    BR/    (20)  byznys pravidla
    ARCH/  (12)  architektura (vč. ARCH0001 Application Overview, ARCH0002 Context Interaction Map)
  UX/                      # UX tier — rekonstruováno z UI evidence (_ar/prtsc/)
    IA/    (1)   informační architektura (IA-patronus + screen-map)
    WIRE/  (22)  wireframe specifikace per obrazovka (screen_id + realizes_uc)
    COMP/  (9)   znovupoužité komponenty (evidence-gated)
    COPY/  (5)   i18n copy specifikace (verbatim české UI stringy)
  final-publication-map.md     # 163 BA + 37 UX řádků: finální soubor, tier, vrstva, doc_id
  final-publication-report.md  # co bylo publikováno, ověření, další kroky
  README.md                    # tento soubor
```

Každá vrstva má `_REGISTRY.md` (ID | Title | Status | Module(s) | Owner mode | Created). Soubory jsou
pojmenovány `<doc_id>-<kebab-title>.md`; `doc_id` je stabilní a nikdy se nepřekládá ani nepřečíslovává.

## Konvence

- **Jazyk**: lidsky čitelný obsah je česky. Nepřekládají se identifikátory (doc_id a křížové ID),
  kódové/polní/stavové tokeny v backticích, bloky kódu, cesty, URL, názvy externích systémů a AR
  evidenční slovník (`Confirmed` / `Partial` / `Hypothesis` / `Uncertain` / `Blocked`).
- **Terminologie**: řízena glosářem `_ar/repo-map/glossary.md` (kanonické CZ ekvivalenty).
- **Frontmatter**: `doc_id` zachováno, `status: canonical`, `modules: []` (program-wide; cílový
  systém přerozděluje na moduly svým Mode M po hand-offu).
- **Vrstvová disciplína** (single-source) je vynucena upstream v draftu; finální vrstva publikuje
  obsah beze změny (nereinterpretuje, neslučuje, nededuplikuje).

## Vztah k draftu

`_ar/spec-draft/` je interní pracovní rekonstrukce (ploché rozvržení, zdrojový jazyk). `_ar/spec-final/`
je publikovatelný, otiskovaný, do češtiny přeložený, tierovaný pohled. Draft zůstává zdrojem pravdy;
finální vrstva je jeho envelope-konformní publikace.

## Stav a reziduální rozhodnutí

Architektonicky uzavřeno; současný stav a plán rebuildu použitelné s omezeními (viz
`../spec-draft/SPEC-CLOSURE.md`). Reziduální rozhodnutí patří rebuild-týmu (nejsou AR-řešitelná):
drop-or-rebuild dormantního doporučování (UC0021) a neimplementovaného FB inbound webhooku (UC0013);
reziduální mezery současného stavu (drain scheduling, nevynucená legalita přechodů, ES audit
sub-flow); ComGate transfer-sync scheduling Conflict.
