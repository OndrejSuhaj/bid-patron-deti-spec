---
doc_id: WIRE0009
title: Application Wizard Step3 Applicant
canonical_layer: WIRE
spec_type: wireframe
modules: []
screen_id: S008c
realizes_uc: [UC0001]
status: canonical
references:
  - UC0001
  - EN0001
  - EN0002
  - EN0006
---

# WIRE0009 – Průvodce žádostí, krok 3 – žadatel

## Účel

S008c je krok 3 ("O Vás" / "Krok 3: Údaje o vás") pětikrokového průvodce žádostí `/zadost-formular`.
Žadatel (rodič / zákonný zástupce vystupující jako předkladatel žádosti) zde zadává vlastní
identifikační, adresní, kontaktní údaje a údaje o zaměstnaneckém stavu, aby platforma mohla
posoudit a zpracovat Žádost (Application). Krok se nachází mezi krokem 2 "Dar" (S008b) a krokem 4
"Patron" (S008d) v sekvenci průvodce dokumentované v `_ar/spec-draft/IA/IA-patronus.md` §3.3/§7.
Realizuje `UC0001` (Podání žádosti) — konkrétně část zachycení dat v rámci sub-flow
sebe-registrace/žádosti (UC0001.1); samotný dokument UC neuvádí pole tohoto kroku vyjmenovaně, takže
detail na úrovni polí je zde čerpán z `EN0002` (ApplicationProfile) a z pozorovaného UI, odkazovaný,
nikoli znovu popisovaný z UC0001.

**Aktér:** žadatel (role předkladatele žádosti) — neautentizovaný nebo nově registrovaný Customer
uprostřed průvodce (Confirmed — `ui-observed-areas.md` §5 "Audience: applicant (parent / legal
guardian)").

**Kontext vstupu:** uživatel přichází z kroku 2 "Dar" (S008b) přes "Pokračovat", nebo se vrací z
kroku 4 "Patron" (S008d) přes "Krok zpět" — obojí potvrzeno stepper prvkem a odkazem "Krok zpět".
Vstup přímou URL / chování obnovení z rozpracované session není pro tento konkrétní krok doloženo
(Uncertain).

---

## Zóny rozvržení

Confirmed — oba screenshoty ukazují identické jednosloupcové rozvržení, lišící se pouze stavem
vyplnění polí (viz Stavy).

- Header — globální header/navigace webu: logo "patron dětí", odkazy "Jak to funguje" / "Blog" /
  "O nás", CTA "Požádat o pomoc", odkaz "Můj účet". (Sdílené chrome prvky — nejsou specifické pro
  tuto obrazovku; viz IA.)
- Stepper — horizontální indikátor postupu s 5 kroky: "Příběh" (hotovo, zatržítko) / "Dar" (hotovo,
  zatržítko) / "3 O Vás" (aktivní, vyplněný červený kruh) / "4 Patron" (čeká, šedý) / "5 Přílohy"
  (čeká, šedý).
- Zóna titulku stránky — "Krok 3: Údaje o vás" (H1) + podtext "Abychom vám mohli pomoci,
  potřebujeme o vás bližší informace." + odkaz "← Krok zpět".
- Hlavní karta formuláře — jedna světle šedá karta obsahující všechna pole formuláře (viz Použité
  komponenty).
- Informační banner — trvalý červený/růžový banner pod formulářem, nad akcí odeslání.
- Primární akce — tlačítko "Pokračovat", vpravo dole na kartě.
- Footer — globální footer webu (upozornění na cookies, text o "patron dětí", navigační sloupce,
  loga platebních poskytovatelů, číslo sběrného účtu, copyright). Sdílené chrome prvky — nejsou
  specifické pro tuto obrazovku.

```
+--------------------------------------------------+
| Header (logo, nav, Požádat o pomoc, Můj účet)     |
+--------------------------------------------------+
| Stepper: (✓)Příběh —(✓)Dar —(3)O Vás —(4)—(5)     |
+--------------------------------------------------+
| Krok 3: Údaje o vás                               |
| Abychom vám mohli pomoci...                       |
| ← Krok zpět                                       |
+--------------------------------------------------+
| [ form card ]                                     |
|  Vaše jméno a příjmení   [Jméno] [Příjmení]       |
|  Rodné číslo rodiče      [___________________]    |
|  Adresa trvalého bydliště                         |
|    [Ulice a číslo popisné______________]          |
|    [Město___________] [PSČ___]                    |
|  [ ] Zastihnete mě na jiné než trvalé adrese.      |
|  [ ] Jsem samoživitel  <definiční text>            |
|  Vaše kontaktní údaje                             |
|    [E-mail_______________] [+420][Telefon____]    |
|  Jste zaměstnán? (•)ANO ( )NE                     |
|  [ i  V případě změny údajů... ]  (banner)         |
|                                    [ Pokračovat ]  |
+--------------------------------------------------+
| Footer                                            |
+--------------------------------------------------+
```

---

## Použité komponenty

Opakující se prvky povýšené na COMP nástrojem **AR:COMPSynthesizer** (viz `COMP-inventory-map.md`);
všechny ostatní záznamy zůstávají označené jako `inline` (nedoloženo opakované použití na ≥2
obrazovkách).

| Zóna | COMP-id | Varianta/Props | Poznámky |
|---|---|---|---|
| Header | COMP0002 | context=public | viz `COMP0002` Global Site Header |
| Stepper | COMP0005 | activeIndex=3, completedIndices=[1,2] | Confirmed — `ui-observed-areas.md` §5 "Controls"; viz `COMP0005` Application Wizard Stepper |
| Odkaz "Krok zpět" | inline | textový odkaz + ikona šipky vlevo | Confirmed. |
| Textové pole — "Jméno" | inline | jednořádkový text, placeholder "Jméno" | Confirmed. |
| Textové pole — "Příjmení" | inline | jednořádkový text, placeholder "Příjmení" | Confirmed. |
| Textové pole — "Rodné číslo rodiče" | inline | jednořádkový text, plná šířka | Confirmed. Popisek obsahuje vloženou nápovědu "(cizinec: číslo pojištěnce)". |
| Textové pole — "Ulice a číslo popisné" | inline | jednořádkový text, plná šířka | Confirmed. |
| Textové pole — "Město" | inline | jednořádkový text | Confirmed. |
| Textové pole — "PSČ" | inline | jednořádkový text | Confirmed. |
| Checkbox — "Zastihnete mě na jiné než trvalé adrese." | inline | checkbox + popisek | Confirmed; v obou záběrech nezaškrtnuto — efekt zaškrtnutí (např. zobrazení sub-formuláře pro korespondenční adresu) **není zdokumentován** (Uncertain). |
| Checkbox — "Jsem samoživitel" | inline | checkbox + popisek + statický definiční text pod ním | Confirmed; v obou záběrech nezaškrtnuto; definiční text je vždy viditelný (v evidenci nejde o tooltip/popover). |
| Textové pole — "E-mail" (kontakt) | inline | jednořádkový text/e-mail | Confirmed. |
| Pole telefonu — předvolba země + číslo | inline | pevný prefixový segment "+420" + pole s číslem | Confirmed; není doloženo, zda je předvolba měnitelná (Uncertain — může jít o rozbalovací seznam, v obou záběrech vypadá staticky). |
| Skupina rádiových tlačítek — "Jste zaměstnán?" | inline | 2 volby: ANO / NE, výběr jedné možnosti | Confirmed; ve stavu prázdného formuláře výchozí hodnota NE, ve vyplněném stavu zobrazeno ANO (přepnuto testerem). |
| Informační banner | inline | červený/růžový banner, ikona info + tučný úvod + text | Confirmed. |
| Primární tlačítko — "Pokračovat" | COMP0001 | — | viz `COMP0001` Primary Button |
| Footer | COMP0003 | — | viz `COMP0003` Global Site Footer |

---

## Interakce

1. **Vstup** — uživatel přichází z kroku S008b "Dar" prostřednictvím akce "Pokračovat", nebo se
   vrací z S008d "Patron" přes vlastní odkaz "Krok zpět" této obrazovky → stav: `default` (Confirmed,
   stepper zobrazuje kroky 1–2 hotové, krok 3 aktivní).
2. **Primární akce — "Pokračovat"** — odešle hodnoty polí kroku 3 a postoupí na krok 4 "Patron"
   (S008d); realizuje `UC0001` (pokračování zachycení dat v rámci Podání žádosti). Chování
   klientské/serverové validace po kliknutí **není zdokumentováno** — nebyl zachycen žádný chybový
   stav (viz Stavy → error). Není jisté, která pole jsou v tomto kroku povinná; `agreement_truthfulness`
   a `child_unschoold` jsou jediné atributy `EN0002` označené jako celkově povinné, žádný z nich
   však nepatří mezi pole viditelná na této obrazovce (Open Question).
3. **Sekundární akce — "Krok zpět"** — návrat na krok 2 "Dar" (S008b), předpokladem je zachování
   již zadaných hodnot z kroku 3; zachování dat při návratu zpět **není zdokumentováno** (Uncertain).
4. **Sekundární akce — "Zastihnete mě na jiné než trvalé adrese."** — přepínání checkboxu; v obou
   záběrech pozorováno pouze nezaškrtnuté, takže jeho efekt (např. zobrazení druhého adresního
   bloku) **není zdokumentován** (Uncertain — Open Question).
5. **Sekundární akce — "Jsem samoživitel"** — přepínání checkboxu; pozorováno pouze nezaškrtnuté;
   efekt nad rámec zaznamenání příznaku (např. vyvolání následného požadavku na přílohu) **není na
   této obrazovce zdokumentován** — cross-step požadavky na přílohu jsou tvrzeny pro zaměstnanecký
   stav (viz dále), ale pro tento příznak nejsou potvrzeny.
6. **Sekundární akce — rádiové tlačítko "Jste zaměstnán?"** — přepínání ANO/NE je pozorováno jako
   funkční prvek (obě hodnoty zachyceny), avšak side-efekty při změně **nejsou na této obrazovce
   samotné zdokumentovány**; viditelný text popisku tvrdí cross-step důsledek: "(pokud nejste
   zaměstnán, doložte evidenci na ÚP v kroku 5.)" — tj. volba NE má údajně vyžadovat přílohu v kroku
   5 "Přílohy" (S008e), který sám o sobě není zachycen (Confirmed tvrzení existuje v textu; výsledné
   chování kroku 5 je Assumed/Uncertain — viz `IA-screen-map.md`, řádek S008e).
7. **Výstup** — úspěšné "Pokračovat" → krok 4 "Patron" (S008d, nezachyceno); "Krok zpět" → krok 2
   "Dar" (S008b); žádný jiný výstup (např. uložit a pokračovat později) na této obrazovce
   nepozorován.

---

## Stavy

### default
Formulář zobrazený se všemi prázdnými poli a viditelným placeholder textem, "Jste zaměstnán?"
výchozí hodnota NE (Confirmed — screencapture …13_21_26.png).

### empty
Totéž jako `default` — tato obrazovka nemá samostatný stav prázdné kolekce/bez dat; jde o
jednoduchý vstupní formulář, nikoli seznam. N/A — tato obrazovka není kolekční pohled.

### loading
Nezdokumentováno. Žádný indikátor načítání, skeleton ani ošetření deaktivace odeslání během
zpracování nebyl pro tuto obrazovku zachycen. **Uncertain — Evidence Pending.**

### error
Nezdokumentováno. Žádný ze záběrů nezobrazuje stav validační chyby, zvýraznění pole ani stav
neúspěšného odeslání. **Uncertain — Evidence Pending** (Open Question: co se stane při kliknutí na
"Pokračovat" s chybějícími/neplatnými povinnými poli — žádný záběr neexistuje).

### filled (pozorováno, nad rámec čtyř požadovaných stavů)
Confirmed — screencapture …13_21_59.png zobrazuje pole vyplněná testovacími daty ("Ondřej" /
"Šuhaj" / "881206/0290" / "Kaplická 446" / "Velešín" / "38232" / "o.suhaj@gmail.com" /
"+420 723667161") a "Jste zaměstnán?" přepnuto na ANO. Vyplněná pole se vykreslují se
světle-modrým pozadím oproti bílému/šedému u nedotčených polí — zdá se, že jde o vizuální stav
"dotčeno" (touched), nikoli o stav ověřené/potvrzené platnosti (Probable — nepotvrzeno žádnou ikonou
úspěchu ani vloženým zatržítkem).

---

## Validační plochy

Žádný dokument BR v `_ar/spec-draft/BR/` neupravuje validaci polí tohoto kroku na úrovni jednotlivých
polí (jméno osoby, rodné číslo, adresa, e-mail, telefon, příznaky zaměstnání). Jediné omezení na
úrovni entity bylo nalezeno u sesterského pole identity dítěte (`child_rc`) v `EN0002`, nikoli u
`fundraiser_rc` tohoto kroku. Všechny řádky níže jsou proto uvedeny ve `validationsWithoutBR` jako
otevřené otázky, nikoli jako vymyšlená BR id.

| Pole/Zóna | Spouštěč (BR-id) | Plocha |
|---|---|---|
| Jméno / Příjmení (fundraiser_first_name / fundraiser_last_name) | žádné — BR nenalezeno | Uncertain — validationsWithoutBR; formát/povinnost nezdokumentováno |
| Rodné číslo rodiče (fundraiser_rc) | žádné — BR nenalezeno | Uncertain — validationsWithoutBR; nezobrazena žádná nápověda formátu ani příklad; v kontrastu s `EN0002.child_rc`, které je "podmíněně povinné" dle Open Question v EN0002, avšak toto omezení je zdokumentováno pro dítě, nikoli pro žadatele |
| Adresa (ulice/město/PSČ) (fundraiser_address fields) | žádné — BR nenalezeno | Uncertain — validationsWithoutBR |
| E-mail (fundraiser_email) | žádné — BR nenalezeno | Uncertain — validationsWithoutBR; poznámka: `UC0001` krok 5 dokládá kontrolu domény e-mailu přes Integration(Email Validation Service) během sebe-registrace, jde ale o e-mail zadaný při registraci, není potvrzeno, zda se znovu validuje v tomto pozdějším kroku průvodce — Open Question, zda jde o stejné pole/hodnotu |
| Telefon (fundraiser_phone) | žádné — BR nenalezeno | Uncertain — validationsWithoutBR |
| Jste zaměstnán? (employed_status) | žádné — BR nenalezeno | Uncertain — validationsWithoutBR; text tvrdí cross-step důsledek (příloha v kroku 5), ale žádné BR to neformalizuje |
| Jsem samoživitel (příznak samoživitele; nemodelováno jako pojmenovaný atribut `EN0002` — viz Vazby na data) | žádné — BR nenalezeno | Uncertain — validationsWithoutBR |
| Zastihnete mě na jiné než trvalé adrese (příznak odlišné korespondenční adresy) | žádné — BR nenalezeno | Uncertain — validationsWithoutBR |

**validationsWithoutBR:** fundraiser_first_name, fundraiser_last_name, fundraiser_rc,
fundraiser_address (street/city/zip), fundraiser_email, fundraiser_phone, employed_status,
single-parent flag, mailing-address-differs flag — žádné z těchto polí nemá řídicí dokument BR;
požadavky na povinnost/formát nejsou na této obrazovce zdokumentovány (nebyla nikdy zachycena
žádná vložená chybová hláška).

---

## Vazby na data

| Zóna | EN-id | QUERY-id | Poznámky |
|---|---|---|---|
| "Vaše jméno a příjmení" | `EN0002` | — | atributy `fundraiser_first_name`, `fundraiser_last_name`. |
| "Rodné číslo rodiče" | `EN0002` | — | atribut `fundraiser_rc` (popisek pro rodiče/zákonného zástupce; varianta pro cizince se místo toho dotazuje na číslo pojištěnce — stejné pole, alternativní význam dle textu popisku, nemodelováno jako samostatný atribut v EN0002). |
| "Adresa vašeho trvalého bydliště" | `EN0002` | — | atribut `fundraiser_address` (pole) — ulice, město, PSČ. |
| "Zastihnete mě na jiné než trvalé adrese" | `EN0002` | — | Probable mapování na `fundraiser_address2` (Contact reference pro druhou adresu) — nepotvrzeno explicitně jako podkladové pole checkboxu; Open Question. |
| "Jsem samoživitel" | — | — | **Nenalezen odpovídající atribut** v dokumentovaném seznamu atributů `EN0002` (Open Question — chybějící evidence: status samoživitele je v UI zobrazen s úplnou právní definicí, ale nelze jej vysledovat k pojmenovanému poli EN0002 v aktuální rekonstrukci EN). |
| "Vaše kontaktní údaje" (e-mail, telefon) | `EN0002` | — | atributy `fundraiser_email`, `fundraiser_phone`. |
| "Jste zaměstnán?" | `EN0002` | — | atribut `employed_status` (enum). |
| Kontejner obrazovky/kroku | `EN0001` | — | Krok patří k celkové Žádosti (Application), která je vyplňována — dle mapování IA S008c a postconditions UC0001. |
| Identita žadatele (na úrovni party, dle IA) | `EN0006` | — | IA-screen-map.md váže S008c na `EN0006` (Contact) na úrovni party; detail na úrovni polí tohoto WIRE je naproti tomu čerpán z `EN0002` (ApplicationProfile), protože EN0002 dokumentuje skutečně pozorovaná pole formuláře (atributy `fundraiser_*`) — obě reference zachovány v souladu s cross-layer discipline. |

---

## Podmíněná viditelnost

| Komponenta/Zóna | Podmínka (ref. ACL nebo BR) | Chování při skrytí |
|---|---|---|
| Celá obrazovka | nezdokumentováno — v této fázi neexistuje vrstva ACL | N/A — obrazovka je součástí průvodce v roli žadatele, vstup přes S008b; žádná role gate nepozorována nad rámec pozice uprostřed průvodce v roli žadatele (Confirmed audience dle `ui-observed-areas.md` §5). |
| Definiční text "Jsem samoživitel" | nezdokumentováno | Vždy viditelný, pokud je checkbox přítomen (statický pomocný text, v žádném ze záběrů nezobrazován/skrýván podmíněně). |
| Popisky kroků 4/5 ve stepperu | nezdokumentováno | Vždy viditelné (šedé, čekající) — nejsou podmíněné, pouze ještě neaktivní. |

V této fázi ještě neexistuje vrstva `ACLxxxx`; nebylo nalezeno žádné BR upravující viditelnost na
základě role specificky pro tuto obrazovku.

---

## Poznámky k přístupnosti

Evidence Pending pro většinu bodů — screenshoty neodhalují strukturu DOM, takže pořadí tabulace,
ARIA landmarky a chování klávesnice nelze přímo pozorovat.

- **Pořadí tabulace:** Assumed shora dolů, zleva doprava přes viditelná pole (Jméno → Příjmení →
  Rodné číslo → Ulice → Město → PSČ → checkboxy → E-mail → Telefon → radio ANO/NE → Pokračovat) —
  **Uncertain**, odvozeno pouze z vizuálního rozvržení, nepotvrzeno záznamem DOM/klávesnice.
- **Focus při vstupu:** Uncertain — Evidence Pending, nezdokumentováno.
- **Focus při přechodu stavu:** Uncertain — Evidence Pending, nezdokumentováno (žádný chybový stav
  nebyl zachycen, aby bylo možné určit chování focus-to-error).
- **Landmarky:** Uncertain — Evidence Pending; screenshoty neodhalují ARIA role.
- **Klávesové zkratky:** Žádné nepozorovány; žádné zkratky specifické pro obrazovku nezdokumentovány.
- **Signalizace stavu pouze barvou (příznak):** rozlišení "vyplněno" vs. "nedotčeno" u polí se
  spoléhá na rozdíl barvy pozadí světle modré vs. bílé/šedé (viz Stavy → filled) — žádný další
  nebarevný indikátor (ikona, text) nebyl pozorován jako doprovodný; potenciální mezera v
  přístupnosti, označená jako **Open Question**, nikoli tvrzena jako defekt bez další evidence.

---

## Evidence

| Oblast tvrzení | Jistota | Evidence |
|---|---|---|
| Zóny rozvržení, stepper, pole formuláře (prázdný stav) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_21_26.png` |
| Hodnoty polí ve vyplněném stavu, styl pozadí "dotčeno", rádiové tlačítko zaměstnání přepnuté na ANO | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_21_59.png` |
| Účel obrazovky, cílová skupina, prvky, seznam polí (textově) | Confirmed | `_ar/evidence/ui/ui-observed-areas.md` §5 |
| Screen-id, pozice ve stepperu, seskupení modulů | Confirmed | `_ar/spec-draft/IA-screen-map.md`, řádek S008c; `_ar/spec-draft/IA/IA-patronus.md` §3.3/§7 |
| Realizovaný UC (UC0001) — detail na úrovni polí není v UC0001 samotném | Probable | `_ar/spec-draft/UC/UC0001_SubmitApplication.md` (flow registrace/sebe-registrace; pole kroku 3 tam nejsou vyjmenována) |
| Vazby pole → atribut EN0002 | Probable | `_ar/spec-draft/EN/EN0002_ApplicationProfile.md` "User-provided attributes" (`fundraiser_*`, `employed_status`) |
| "Jsem samoživitel" → nenalezen atribut EN0002 | Uncertain (absence) | `_ar/spec-draft/EN/EN0002_ApplicationProfile.md`, úplný seznam atributů — žádný odpovídající název pole |
| Validační pravidla pro pole tohoto kroku | Uncertain — BR nenalezeno | výpis adresáře `_ar/spec-draft/BR/` (21 dokumentů BR, žádný neupravuje validaci pole jméno/adresa/rč/e-mail/telefon/zaměstnání pro žadatele) |
| Stavy loading / error | Uncertain — Evidence Pending | Není přítomno v žádném ze záběrů |
