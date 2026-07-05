---
doc_id: WIRE0020
title: Account Dashboard Composed
layer: WIRE
spec_type: wireframe
modules: []
screen_id: S017
realizes_uc: [UC0024]
status: imported
references:
  - UC0024
  - EN0034
  - EN0009
  - EN0004
  - EN0008
  - EN0014
  - EN0021
  - IA-patronus
---

# WIRE0020 – Složená obrazovka nástěnky účtu (Account Dashboard Composed)

## Účel

**Pouze hypotéza — nejde o zachycenou obrazovku aplikace.** Tento dokument rekonstruuje složený
mockup nástěnky "Můj účet", který se objevuje jako malá grafika ve tvaru mobilního zařízení vložená
do marketingového/drip e-mailu "Dokončete svůj uživatelský účet 🎉"
(`screencapture-mail-google-mail-u-1-2026-07-04-13_32_45.png`). V backendovém zdrojovém kódu
Patronusu nebyla nalezena žádná reálná obrazovka, view, controller ani REST resource, která by tento
složený layout skutečně vytvářela (`_ar/spec-draft/EN/EN0034_DonorAccountView.md` Evidence Gaps 1/3;
`_ar/spec-draft/UC/UC0024_ManageDonorAccount.md` Evidence Pending; `IA-patronus.md` §8 IA-Q3). V mapě
obrazovek IA je vedena jako obrazovka s jistotou **Uncertain** a je zde dokumentována striktně jako
*to, co grafika mockupu zobrazuje*, nikoli jako potvrzené current-state chování — v souladu s
výslovnou instrukcí IA, že "nesmí být rekonstruována jako postavená."

Mockup naznačuje kandidátní realizaci `UC0024` (sub-flows UC0024.1 / UC0024.1b — zobrazení vlastní
nástěnky účtu s podpořenými příběhy a dárcovskou aktivitou) pro autentizovaného Customer (jakýkoli
User, `EN0008`, nejpravděpodobněji s rolí `supporter` dle invariantů `EN0034`). Vstupní kontext v
mockupu není reálná navigační cesta — jde o statickou marketingovou grafiku, nikoli o živý capture ze
zařízení; neexistuje žádná evidovaná route, deep link ani položka menu vedoucí do této složené
nástěnky (viz Podmíněná viditelnost a Evidence).

Tento WIRE nepopisuje postavenou obrazovku. Potvrzená backendem projektovaná obrazovka účtu dárce
existuje samostatně jako `WIRE0021` (`S018`, `zona/darce`), která je užší (dva sloupce: podpořená
Campaign + sečtená přispěná částka) a představuje current-state pravdu pro plochu účtu/historie darů.

---

## Zóny rozvržení (Layout Zones)

**Confirmed** (co je vidět v grafice mockupu) — `screencapture-mail-google-mail-u-1-2026-07-04-13_32_45.png`.
Mockup je malá vložená ilustrace v rámci telefonu uvnitř těla e-mailu, nikoli celoobrazovkový capture,
takže je čitelné pouze následující:

- **Hlavička aplikace** — wordmark "patron dětí" se sloganem "společně za lepší dětství" (stejné
  brandové zpracování jako hlavička veřejného webu; kromě lockupu loga není čitelný žádný odlišný
  chrome pro appku účtu).
- **Panel záložek** — dvě záložky: "Pro vás" (ikona osoby, zdá se vybraná/aktivní podle barvy ikony)
  a "Všechny (67)" (počet v závorce).
- **Karta příběhu (jedna viditelná karta, záložka "Pro vás")**:
  - Obrázek karty — fotografie (dvě osoby, jedna se zdá být v kontextu pečovatele/dítěte, konzistentní
    s obrázkovým stylem příběhů dětí na Patronusu).
  - Banner s příspěvkem přes obrázek — "Přispěli jste 1 250 Kč" (zvýrazněný/barevný banner přes
    obrázek karty).
  - Odznak s odpočtem — "ZBÝVÁ 10 DNÍ" (barevný odznak/pilulka, horní část karty).
  - Název příběhu — "Lucce na rehabilitační program".
  - Údaje o průběhu — "83 240 Kč" / "101 591 Kč" (dvojice vybráno/cíl, prostý text; při tomto
    rozlišení není čitelný žádný grafický progress bar).
- V crop mockupu není čitelná žádná patička, žádná druhotná navigace ani další karty — grafika je
  vystřižená/zmenšená pro vložení do e-mailu, nikoli plnohodnotný capture celého viewportu.

Okolí mockupu (chrome e-mailu, není součástí samotné obrazovky nástěnky — zaznamenáno pouze pro
orientaci): třísloupcový panel benefitů "Proč dokončit uživatelský účet?" ("Vše na jednom místě",
"Každý má účet na míru", "Statistiky a zpětná vazba") a titulek "Fungujeme skvěle na počítači i ve
vašem mobilním telefonu!" — jde o marketingový text o účtu, nikoli o UI nástěnky, a patří do
MSG-vrstvy obsahu e-mailu, nikoli do tohoto WIRE.

```
+----------------------------------------+
| patron dětí | společně za lepší dětství |
+----------------------------------------+
| [Pro vás*]   Všechny (67)               |
+----------------------------------------+
| +--------------------------------+     |
| | [card image]                    |    |
| |  "Přispěli jste 1 250 Kč"       |    |
| |  ZBÝVÁ 10 DNÍ                   |    |
| +--------------------------------+     |
| Lucce na rehabilitační program          |
| 83 240 Kč / 101 591 Kč                  |
+----------------------------------------+
   (remainder of screen out of frame —
    not legible in the mockup graphic)
```

**Uncertain** — zda pod viditelným výřezem existují další karty, scrollovatelný seznam, filtry nebo
další chrome; samotná grafika mockupu je v layoutu e-mailu oříznutá a žádná větší/alternativní verze
nebyla zachycena.

---

## Použité komponenty (Components Used)

Vrstva COMP pro tuto rekonstrukci ještě neexistuje; každý prvek je proto oznaven jako `inline`.
Identita komponent je zde dvojnásobně nejistá: nejen že neexistuje vrstva COMP, ale samotná obrazovka
není potvrzena jako postavená, takže tyto prvky je nejlépe chápat jako "prvky zobrazené v grafice
mockupu", nikoli jako ověřené UI komponenty.

| Zóna | COMP-id | Varianta/Props | Poznámky |
|---|---|---|---|
| Hlavička aplikace | inline | logo + tagline lockup | Stejný brand lockup jako hlavička veřejného webu; **Assumed** sdílený chrome, nepotvrzeno samostatně pro kontext appky účtu |
| Panel záložek | inline | dvouzáložkový segmentovaný ovládací prvek: "Pro vás" / "Všechny (N)" | `N` v tomto capture pozorováno jako "67"; sémantika rozdělení je otevřená otázka (viz `EN0034` Evidence Gap 3) |
| Karta příběhu | inline | obrázek + banner overlay + odznak s odpočtem + název + údaje o průběhu | Nikde jinde v rekonstruovaném souboru WIRE nebyla evidována ekvivalentní komponenta karty; nejbližší strukturální příbuzný je karta příběhu veřejného katalogu (`WIRE0001`), nepotvrzeno jako stejná komponenta |
| Banner s příspěvkem overlay | inline | text na obrázku, "Přispěli jste {amount}" | Pouze v mockupu; žádné pole na potvrzené projekci `supporter_zone` `EN0034` nenese částku příspěvku konkrétního uživatele spojenou s kartou Campaign (viz Data Bindings) |
| Odznak s odpočtem | inline | odznak/pilulka, "ZBÝVÁ {N} DNÍ" | Pouze v mockupu; Campaign (`EN0004`) má koncept deadline sama o sobě, ale žádné potvrzené spojení do této karty nástěnky nebylo evidováno |
| Údaje o průběhu | inline | dvojice prostého textu "{collected} / {target}" | Pouze v mockupu; koncepčně odpovídá polím vybráno/cíl Campaign (`EN0004`), nepotvrzeno jako zdrojováno z jakéhokoli read-modelu na úrovni účtu |

---

## Interakce (Interactions)

**Uncertain — žádná z následujících není potvrzené interaktivní chování; jsou odvozeny z toho, co by
nástěnka tohoto zobrazeného tvaru pravděpodobně dělala, a jsou tak i označeny.**

1. **Vstup** — Neevidováno. Mockup je statická grafika uvnitř marketingového e-mailu; v IA neexistuje
   žádná route, deep link ani cesta menu vedoucí do této složené obrazovky (`IA-patronus.md` §8
   IA-Q3). Vlastní CTA e-mailu ("Dokončit účet") nejpravděpodobněji směřuje do aktivace/vytvoření
   účtu (`UC0014`), nikoli přímo do této nástěnky. → stav: nelze určit.
2. **Primární akce — Přepnutí záložky ("Pro vás" ⟷ "Všechny (N)")** — **Assumed**: dotyk na neaktivní
   záložku by pravděpodobně odhalil jinou sadu karet (např. "všech N příběhů" vs. "vaše podpořené
   příběhy"), konzistentní s vzorem segmentovaného ovládacího prvku; nezachyceno v pohybu, žádný stav
   druhé záložky nebyl zaznamenán.
3. **Sekundární akce — Dotyk na kartu příběhu** — **Assumed**: dotyk na kartu by pravděpodobně
   navigoval na detailové zobrazení příběhu (paralelně s `WIRE0002` na veřejném webu); pro tento
   kontext na úrovni účtu neevidováno.
4. **Výstup** — Neevidováno.

Žádnou z těchto interakcí nelze prohlásit za realizaci `UC0024` nad rámec obecné kandidátní asociace
zaznamenané v mapě obrazovek IA — potvrzené sub-flows UC (UC0024.1, UC0024.1b) jsou vysledovány k
užším plochám nastavení profilu (`WIRE0014`) a historie darů podle příběhu (`WIRE0021`), nikoli k
tomuto složenému mockupu.

---

## Stavy (States)

### default (výchozí)
Jediný stav viditelný v evidenci: vybraná záložka "Pro vás" zobrazující jednu kartu příběhu s
bannerem příspěvku, odznakem s odpočtem, názvem a údaji o průběhu, jak je popsáno v Zónách rozvržení.
**Confirmed** (jak zobrazeno v grafice mockupu) — `screencapture-mail-google-mail-u-1-2026-07-04-13_32_45.png`.
Zda je toto reprezentativní pro reálně vykreslený stav, nebo čistě ilustrativní ukázkový obsah pro
marketingovou grafiku, je **Uncertain**.

### empty (prázdný)
Nezachyceno. `N/A — Evidence Pending`: žádné zpracování "zatím žádné podpořené příběhy" není
zobrazeno; mockup ukazuje přesně jednu naplněnou kartu, vybranou pro ilustrační účely v marketingovém
e-mailu.

### loading (načítání)
Nezachyceno. `N/A — Evidence Pending`: statická marketingová grafika nemůže zobrazit stav načítání.

### error (chyba)
Nezachyceno. `N/A — Evidence Pending`: žádné zpracování chyby není zobrazeno ani evidováno.

---

## Validační plochy (Validation Surfaces)

V mockupu nejsou zobrazena žádná vstupní pole, formuláře ani uživatelem odesílaná data — viditelná
plocha je pouze pro čtení (nástěnkové/souhrnné zobrazení). Nevztahuje se žádné `BRxxxx`.

`validationsWithoutBR`: žádné identifikováno — tato obrazovka, jak je evidována, nemá žádnou
validační plochu k označení.

---

## Datové vazby (Data Bindings)

| Zóna | EN-id | QUERY-id | Poznámky |
|---|---|---|---|
| Karta příběhu — podpořený příběh / údaje o průběhu | `EN0004` (Campaign) | none | Název příběhu a částky vybráno/cíl koncepčně odpovídají polím Campaign; **Uncertain**, zda nějaký reálný query je spojuje do karty na úrovni účtu tak, jak je zobrazeno |
| Banner s příspěvkem ("Přispěli jste…") | `EN0034` (DonorAccountView) | none | Koncepčně nejblíže potvrzenému sečtenému číslu příspěvku za Campaign u `EN0034`, ale Evidence Gaps `EN0034` výslovně oznaují, že pole odpočtu/stavu vybírání za jednotlivý příběh **nejsou** přítomna na potvrzené projekci `supporter_zone` — tato vazba je **Hypothesis**, nikoli Confirmed |
| Počet v panelu záložek "Všechny (67)" | none found | none | Žádné pole, filtr ani počet na `EN0034` ani na žádném souvisejícím view neodpovídá tomuto počtu (`EN0034` Evidence Gap 3) — zdroj vazby je **Uncertain/unresolved** |
| (Implikováno, nikoli viditelné) potvrzení daru / zpětné vazby přislíbené v textu e-mailu | `EN0014` (DonationConfirmation, neevidováno jako spojeno) / `EN0021` (Feedback, neevidováno jako spojeno) | none | Okolní marketingový text e-mailu slibuje "potvrzení o darech, zpětné vazby" jako součást účtu, ale ani jeden prvek se neobjevuje v samotné grafice mockupu, ani není potvrzen jako součást tohoto či jakéhokoli read-modelu (`EN0034` Relationships) — zaznamenáno zde pouze pro označení mezery, nikoli jako vazba této obrazovky |

---

## Podmíněná viditelnost (Conditional Visibility)

| Komponenta/Zóna | Podmínka (odkaz na ACL nebo BR) | Chování při skrytí |
|---|---|---|
| Celá obrazovka | Předpokládá se požadavek autentizované relace s rolí alespoň `supporter` (analogicky k potvrzenému přístupovému pravidlu `EN0034` pro užší projekci `zona/darce`) — **Assumed**, nezávisle neevidováno pro tuto složenou obrazovku, protože není potvrzena její existence | V této rekonstrukci neexistuje vrstva ACL (`IA-patronus.md` §9); chování při neautentizovaném/neomezeném přístupu není evidováno |
| Záložka "Všechny (N)" | Neznámo — žádná podmínka neevidována; může být viditelná všem autentizovaným Users bez ohledu na roli (počet "všech příběhů na platformě", dle `EN0034` Evidence Gap 3), nebo může být samo o sobě omezeno rolí/nárokem | Uncertain |

---

## Poznámky k přístupnosti (Accessibility Notes)

Neevidováno — jediným důkazem je malá ilustrace mobilního UI vložená do marketingového e-mailu, nikoli
živý/interaktivní capture nebo DOM. Vše následující je výslovně **ne**určitelné:

- **Pořadí tabulátoru:** Uncertain — neexistuje žádný interaktivní capture.
- **Focus při vstupu:** Uncertain — žádný reálný vstupní bod není evidován (viz Interakce).
- **Focus při přechodu stavu:** Uncertain — žádný přechod stavu nebyl zachycen.
- **Landmarks:** Uncertain — sémantickou strukturu nelze určit ze statické ilustrační grafiky.
- **Klávesové zkratky:** Uncertain — mockup zobrazuje UI ve stylu mobilní appky; interakce klávesnicí
  není aplikovatelná/evidovaná.

---

## Otevřené otázky (Open Questions)

1. **Existuje tato složená nástěnka jako reálná, postavená obrazovka?** (`IA-Q3`, přenesena
   nevyřešená z IA a z `EN0034`/`UC0024`.) V backendovém zdrojovém kódu Patronusu nebyla nalezena
   žádná route, view, controller ani REST resource skládající historii darů + stav odpočtu/vybírání
   za jednotlivý příběh + potvrzení + zpětné vazby. Vyřešit lokalizací samostatné donor-facing
   front-end aplikace (nepřítomné v tomto zdroji obsahujícím pouze Drupal backend), nebo potvrzením
   s klientem, že mockup je aspirační/budoucí marketingový obsah.
2. **Pokud je reálná, jde o stejnou obrazovku jako `WIRE0021` (`S018`, `zona/darce`) s bohatší
   front-end kompozicí navrstvenou nahoře, nebo o zcela samostatnou, nezachycenou obrazovku?** Dva
   strukturálně odlišné podpůrné mechanismy (REST endpoint `ProfileResource` vs. Drupal View
   `supporter_zone`) identifikované v Evidence Pending `UC0024` toto nevyřeší.
3. **Co znamená "Všechny (67)"** — všechny příběhy podpořené dárcem, nebo všechny aktivní příběhy na
   platformě bez ohledu na zapojení dárce? Nevyřešeno dle `EN0034` Evidence Gap 3.
4. **Jsou stahovatelná potvrzení a zpětné vazby, přislíbené v okolním textu e-mailu, skutečně
   součástí UI této nástěnky**, nebo jde čistě o aspirační marketingový text bez odpovídajícího prvku
   obrazovky (v samotné grafice mockupu se nevyskytují)? Viz `EN0034` Relationships a Evidence Gaps 1/3.

---

## Evidence

| Oblast tvrzení | Jistota | Evidence |
|---|---|---|
| Existence obrazovky jako postavené obrazovky aplikace | **Uncertain / Hypothesis** — pravděpodobně NENÍ postavena jako reálná obrazovka | `_ar/spec-draft/IA-screen-map.md` (řádek S017, jistota "Uncertain"); `_ar/spec-draft/IA/IA-patronus.md` §8 IA-Q3; `_ar/spec-draft/EN/EN0034_DonorAccountView.md` Evidence Gaps 1/3; `_ar/spec-draft/UC/UC0024_ManageDonorAccount.md` Evidence Pending |
| Layout grafiky mockupu (záložky, karta, banner, odznak, název, údaje) | Confirmed (jak zobrazeno v grafice; nepotvrzeno jako reálné vykreslené UI) | `_ar/prtsc/screencapture-mail-google-mail-u-1-2026-07-04-13_32_45.png`; `_ar/evidence/ui/ui-observed-areas.md` §19 |
| Kandidátní realizace UC (`UC0024`) | Probable (pouze kandidát) | `_ar/spec-draft/IA-screen-map.md` řádek S017 ("UC0024 (Hypothesis)"); `_ar/spec-draft/UI-gap-promotions.md` G-02 |
| Datové vazby (`EN0034`, `EN0004`) | Hypothesis — nepotvrzeno jako spojeno v žádném reálném read-modelu | `_ar/spec-draft/EN/EN0034_DonorAccountView.md` Attributes ("Hypothesis — Not evidenced") a Evidence Gaps |
| Jiné stavy než výchozí | Evidence Pending — nezachyceno | Pro tuto grafiku neexistují žádné alternativní capture |
| Interakce | Uncertain — odvozeno, nikoli pozorováno v pohybu | Pouze statická grafika vložená do e-mailu |
| Přístupnost | Uncertain — nelze určit | Neexistuje žádný interaktivní/DOM capture |
</content>
