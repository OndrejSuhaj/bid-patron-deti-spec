---
doc_id: WIRE0015
title: Tax Confirmation Request
canonical_layer: WIRE
spec_type: wireframe
modules: []
screen_id: S012
realizes_uc: [UC0010]
status: canonical
references:
  - UC0010
  - EN0014
  - EN0008
  - EN0009
  - BR-DonationConfirmationAndTax
---

# WIRE0015 – Žádost o potvrzení o darech pro daňové účely

## Účel

S012 ("Potvrzení o darech") je CZ formulář pro žádost o daňové potvrzení o darech v zóně účtu:
přihlášený patron/dárce si žádá o úřední potvrzení o daru odečitatelném z daní za daný rok, přičemž
volí mezi identitou fyzické osoby ("Fyzická osoba") nebo právnické osoby ("Právnická osoba") a mezi
potvrzením za jeden dar nebo souhrnným potvrzením za celý kalendářní rok. Realizuje CZ webovou cestu
žádosti z `UC0010` (Issue Donation Confirmation (Tax)), konkrétně `UC0010.1`–`UC0010.2` (Confirmed).
**Aktér:** přihlášený Customer/dárce (držitel účtu) — IA umísťuje S012 do zóny účtu "Můj účet"
dosažitelné po přihlášení (`_ar/spec-draft/IA-screen-map.md` řádek S012; `IA-patronus.md` §12/§4
řádek "Potvrzení o darech"). **Kontext vstupu:** navigace z oblasti účtu na route
`/muj-ucet/potvrzeni-o-darech` (`IA-patronus.md` tabulka §4, flow §7.1 "S018/S011 account zone →
'Potvrzení o darech' (`UC0024` → `UC0010`)").

**Poznámka k mapování na UC (Uncertain):** Preconditions a Main Flow `UC0010` popisují jak
přihlášenou cestu, tak anonymní cestu řešenou pomocí zadaného e-mailu; pozorovaný formulář S012
nezobrazuje pole pro e-mail na žádném ze snímků, pouze jméno, adresu, rodné číslo ("Rodné číslo") a
pole pro držitele IČ. Zda S012 vždy vyžaduje předchozí přihlášení (takže je User dohledán ze session,
dle kroku `UC0010` "System: Resolve the target User ... as the currently logged-in User") nebo je
dosažitelný i anonymně, nelze rozhodnout jen ze snímků obrazovky — označeno jako otevřená otázka
níže, nikoli jako předpoklad.

---

## Rozvržení zón

```
+--------------------------------------------------+
| Header — site nav + "Požádat o pomoc" CTA +       |
| "Můj účet" (authenticated)                        |
+--------------------------------------------------+
| Hero — icon, thank-you headline, sub-copy          |
+--------------------------------------------------+
| Form panel (grey background)                       |
|  - Tabs: "Fyzická osoba" | "Právnická osoba"       |
|  - "Základní údaje o vás" (Jméno / Příjmení)       |
|  - "Adresa trvalého bydliště"                      |
|  - "Rodné číslo bez lomítka"                       |
|  - "Fyzická osoba s IČ"                            |
|  - Checkbox: "Chci vykázat všechny dary za rok NNNN"|
|  - CTA: "Ziskat potvrzení"                          |
|  - Legal disclaimer (info icon + italic text)      |
+--------------------------------------------------+
| Cookie consent banner                              |
+--------------------------------------------------+
| Footer                                             |
+--------------------------------------------------+
```

- Header — sdílené záhlaví webu: logo, navigace "Jak to funguje" / "Blog" / "O nás", CTA "Požádat o
  pomoc", odkaz na účet "Můj účet" (ikona postavy). Confirmed (`po_prihlaseni_do_uctu.png`).
- Hero — oslavná ikona (ilustrace vlajky/megafonu), nadpis "Děkujeme, že pomáháte dětem,
  které neměly v životě štěstí.", doprovodný text "Toto je stránka, na které vám vystavíme potvrzení o
  darech Patronu dětí." Confirmed (`po_prihlaseni_do_uctu.png`).
- Panel formuláře — sekce se šedým pozadím obsahující formulář žádosti; viditelná na obou snímcích
  (horní část formuláře na prvním, zbytek + tlačítko odeslat + disclaimer na druhém, dle vztahu
  posunu (scroll) zdokumentovaného v `ui-observed-areas.md` §12). Confirmed.
- Cookie banner + Footer — sdílený chrome webu, nikoli specifický pro tuto obrazovku. Confirmed
  (`po_prihlaseni_do_uctu_potvrzeni_o_darech.png`).

---

## Použité komponenty

Opakující se prvky povýšené na COMP procesem **AR:COMPSynthesizer** (viz `COMP-inventory-map.md`);
všechny ostatní záznamy zůstávají označené `inline` (nebylo prokázáno opakované použití na ≥2
obrazovkách).

| Zóna | COMP-id | Varianta/vlastnosti | Poznámky |
|---|---|---|---|
| Header | COMP0002 | context=public | Sdílený chrome, nikoli specifický pro obrazovku — Confirmed; viz `COMP0002` Global Site Header |
| Hero | inline | ikona + nadpis + doprovodný text | Confirmed |
| Panel formuláře | inline | přepínač záložek (2 záložky) | "Fyzická osoba" (aktivní/výchozí) / "Právnická osoba" (neaktivní) — Confirmed |
| Panel formuláře | inline | textové pole × 2 | "Jméno", "Příjmení" — Confirmed |
| Panel formuláře | inline | textové pole | "Adresa trvalého bydliště" (placeholder "Ulice, číslo, Město, PSČ") — Confirmed |
| Panel formuláře | inline | textové pole | "Rodné číslo bez lomítka" (placeholder "YYMMDDXXXX") — Confirmed |
| Panel formuláře | inline | textové pole | "Fyzická osoba s IČ" (placeholder "Pozor na překlepy :)") — Confirmed |
| Panel formuláře | inline | checkbox (kruhový prvek ve stylu radio) | "Chci vykázat všechny dary za rok 2025" — Confirmed; vizuálně odlišný od `COMP0006` Consent Checkbox (bez vloženého právního hypertextového odkazu) — nepovýšeno, ponecháno jako inline |
| Panel formuláře | COMP0001 | — | "Ziskat potvrzení" (překlep místo "Získat", zaznamenáno přesně dle originálu) — Confirmed; viz `COMP0001` Primary Button |
| Panel formuláře | inline | info/disclaimer upozornění | ikona info + kurzívou psaný právní disclaimer — Confirmed |
| Stránka | COMP0004 | — | sdílená komponenta webu, nikoli specifická pro formulář — Confirmed; viz `COMP0004` Cookie Consent Banner |
| Footer | COMP0003 | — | sdílený chrome — Confirmed; viz `COMP0003` Global Site Footer |

---

## Interakce

1. **Vstup** — navigace ze zóny účtu ("Můj účet") na `/muj-ucet/potvrzeni-o-darech` → stav:
   `default` (Confirmed route/cesta navigace — `IA-patronus.md` §4, §7.1; `IA-screen-map.md` řádek S012).
2. **Primární akce — přepnutí záložky** — kliknutí na záložku "Právnická osoba" → Assumed: přepne
   zobrazenou sadu polí na pole tvarovaná pro organizaci (název/registrační číslo, dle kroku
   `UC0010` "Validate the type-specific identifying fields ... organization: name and registration
   number"); samotné rozvržení polí záložky organizace **není zachyceno** na žádném ze snímků
   (aktivní je zobrazena pouze záložka "Fyzická osoba") — Uncertain.
3. **Primární akce — odeslání** — kliknutí na "Ziskat potvrzení" → odešle identifikační pole,
   zvolený typ osoby a (je-li zaškrtnuto) příznak "vykázat všechny dary za rok NNNN"; realizuje
   `UC0010.1`–`UC0010.2` (validace → dohledání User → výpočet celkové částky → vytvoření snímku
   `EN0014` → vykreslení PDF → odeslání e-mailu); dále: žádná obrazovka potvrzení/úspěchu není pro
   S012 konkrétně zachycena (Uncertain — viz States → default/none-observed níže).
4. **Sekundární akce — zaškrtávací pole roku** — přepnutí "Chci vykázat všechny dary za rok 2025"
   změní rozsah žádosti z certifikátu za jeden dar na souhrnný certifikát za celý kalendářní rok.
   Confirmed, že prvek existuje; rozlišení za-jeden-dar vs. za-rok je podpořeno textem disclaimeru
   ("...toto potvrzení nebo potvrzení za kalendářní rok pouze jednou...").
5. **Výstup** — v rámci samotného panelu formuláře nebyl pozorován žádný explicitní prvek pro
   zrušení/zpět; výstup probíhá přes navigaci v záhlaví ("Můj účet", ostatní navigační odkazy) —
   Confirmed (pouze sdílený chrome).

---

## Stavy

### default
Formulář zobrazen se všemi poli prázdnými/s placeholder textem, záložka "Fyzická osoba" aktivní ve
výchozím stavu, zaškrtávací pole roku nezaškrtnuté. Confirmed (`po_prihlaseni_do_uctu.png`,
`po_prihlaseni_do_uctu_potvrzeni_o_darech.png`).

### empty
N/A — Evidence Pending: tato obrazovka je jednoúčelový formulář žádosti, nikoli zobrazení
seznamu/kolekce; na žádném ze snímků nebyl pozorován žádný stav prázdného obsahu (např. "za tento
rok nebyly nalezeny žádné dary"). `UC0010` AF1 ("No donation total for the requested year") popisuje,
že systém tiše přeruší vystavení, nikoli stav prázdné obrazovky v UI — zda uživatel v tomto případě
vidí jakoukoli zpětnou vazbu na obrazovce, je Uncertain, nedoloženo.

### loading
Uncertain — Evidence Pending. Na žádném ze statických snímků není viditelný indikátor
načítání/spinner; odeslání je pravděpodobně vnímáno jako synchronní, ale žádný asynchronní indikátor
nebyl zachycen.

### error
Uncertain — Evidence Pending. Žádný ze snímků nezobrazuje stav chyby validace nebo neúspěšného
odeslání. `UC0010` AF1 (nulová celková částka darů) a AF2 (chyba vykreslení/odeslání) jsou známé
výsledky na straně backendu, ale žádné odpovídající zobrazení chyby na obrazovce pro S012 nebylo
pozorováno — otevřená otázka, nikoli vymyšlený fakt.

---

## Prvky validace

| Pole/zóna | Spouštěč (BR-id) | Prvek |
|---|---|---|
| "Jméno" / "Příjmení" (identita fyzické osoby) | nenalezeno — krok `UC0010` "Validate the type-specific identifying fields (individual: first/last name and birth number)" popisuje, *že* validace probíhá, ale žádný BR dokument nespecifikuje obsah pravidla (formát, detail povinnosti pole) | Uncertain — validationsWithoutBR; předpokládáno inline (žádné modální okno/toast nebylo pozorováno) |
| "Rodné číslo bez lomítka" (rodné číslo) | nenalezeno — stejný krok `UC0010` jako výše; placeholder "YYMMDDXXXX" naznačuje očekávaný formát, ale žádný BR neupravuje pravidlo kontrolní číslice/formátu | Uncertain — validationsWithoutBR; předpokládáno inline |
| "Adresa trvalého bydliště" | nenalezeno | Uncertain — validationsWithoutBR |
| "Fyzická osoba s IČ" | nenalezeno | Uncertain — validationsWithoutBR |
| Název organizace / registrační číslo (záložka Právnická osoba, nezachyceno) | nenalezeno — krok `UC0010` "organization: name and registration number" | Uncertain — validationsWithoutBR; samotné rozvržení pole nebylo pozorováno |
| Požadovaný rok / rozsah dle zaškrtávacího pole roku | nenalezeno | Uncertain — validationsWithoutBR |
| Nulová celková částka darů za požadovaný rok (v okamžiku odeslání, na straně serveru) | nenalezeno — upraveno narativně v `UC0010` AF1 a `BR-DonationConfirmationAndTax` "Confirmation issuance SHALL be aborted ... when the computed total ... is zero", ale tento BR dokument definuje pravidlo přerušení, nikoli prezentaci validačního prvku na úrovni obrazovky | Uncertain — validationsWithoutBR; pro tento případ nebyl pozorován žádný prvek na obrazovce |

Žádný BR dokument nedefinuje validaci vstupu na úrovni pole (formát/povinnost) pro pole formuláře
S012. `BR-DonationConfirmationAndTax` upravuje serverem vypočtenou celkovou částku a podmínku
přerušení při nulové částce narativně, ale nespecifikuje, jak (nebo zda) je to uživateli
zobrazeno na této obrazovce. Toto je zaznamenáno jako otevřená otázka, nikoli vymyšleno jako nový BR.

---

## Vazby na data

| Zóna | EN-id | QUERY-id | Poznámky |
|---|---|---|---|
| "Jméno" / "Příjmení" / "Adresa trvalého bydliště" / "Rodné číslo" / "Fyzická osoba s IČ" | `EN0014` | — | Mapuje na atributy `EN0014` zadávané uživatelem `name`, `address`, `rodne_cislo` (Confirmed názvy/tvary polí dle EN0014 "User-provided attributes"); obrazovka rozděluje `name` na samostatná pole "Jméno"/"Příjmení" (Probable — EN0014 modeluje jediný textový řetězec `name`, takže rozdělení na dvě pole v UI je rozdělení na úrovni prezentace, které samo o sobě nedokumentuje vrstva EN). Pole "Fyzická osoba s IČ" nemá přímou shodu s atributem EN0014 — Uncertain, možná ekvivalent registračního čísla pro organizaci/OSVČ; otevřená otázka. |
| Záložky "Fyzická osoba" / "Právnická osoba" | `EN0014` (nepřímo, prostřednictvím "requester type (individual or organization)" v `UC0010`) | — | `EN0014` samo o sobě explicitně nemodeluje atribut typu osoby; rozlišení typu je popsáno pouze v krocích flow `UC0010`. Probable. |
| Zaškrtávací pole roku ("Chci vykázat všechny dary za rok NNNN") | `EN0014` | — | Mapuje na `confirmation_year` (povinný atribut). Confirmed, že pole existuje na úrovni EN; konkrétní sémantika zaškrtávacího pole (rozsah za jeden dar vs. souhrnný za rok) je Probable, odvozeno z textu disclaimeru, nikoli z explicitního příznaku EN0014. |
| Akce odeslání → vypočtená celková částka | `EN0009` | — | Zdroj pouze pro čtení serverem vypočtené `donation_total` dle `BR-DonationConfirmationAndTax`; není přímo vykreslen na této obrazovce (žádná celková částka/náhled se nezobrazuje před odeslání) — Confirmed jako vazba na backend, Uncertain zda je to na S012 vůbec někdy zobrazeno. |
| Identita žadatele (session) | `EN0008` | — | Dohledaný dárce/User dle `UC0010`; zda S012 vyžaduje přihlášení (User ze session) vs. akceptuje anonymní dohledání pomocí e-mailu, je otevřená otázka zmíněná v Účel — Uncertain. |

---

## Podmíněná viditelnost

| Komponenta/zóna | Podmínka (odkaz na ACL nebo BR) | Chování při skrytí |
|---|---|---|
| Celá obrazovka | Pozorovaná role: přihlášený držitel účtu ("Můj účet" je viditelný/aktivní v záhlaví na obou snímcích, v souladu s umístěním v zóně účtu v `IA-screen-map.md` řádek S012) — v tomto průchodu neexistuje žádný ACL dokument, který by tuto bránu formalizoval | Uncertain — chybí vrstva ACL; tj. zda může nepřihlášený návštěvník dosáhnout `/muj-ucet/potvrzeni-o-darech` přímo, není ze snímků doloženo (oba zobrazují "Můj účet" jako navigační odkaz, nikoli přímo indikátor přihlášeného stavu) |
| Sada polí záložky "Právnická osoba" | nedoloženo | Nepozorováno — sada polí této záložky není zachycena na žádném ze snímků |

---

## Poznámky k přístupnosti

Evidence Pending — neexistuje žádný záznam DOM/ARIA, pouze statické snímky obrazovky. Následující
lze odpovědně odvodit, nikoli potvrdit:

- **Pořadí tabulátoru:** Assumed zleva doprava, shora dolů přes navigaci v záhlaví, dále přepínač
  záložek, poté pole formuláře (Jméno → Příjmení → Adresa → Rodné číslo → pole IČ → zaškrtávací pole
  roku → odeslání) — Uncertain, nepozorováno přes DOM.
- **Fokus při vstupu:** Uncertain — nedoloženo.
- **Fokus při přechodu stavu:** Uncertain — žádný přechod stavu nebyl zachycen.
- **Landmarks:** Uncertain — nedoloženo ze statických snímků.
- **Klávesové zkratky:** žádné nepozorovány.

---

## Otevřené otázky

1. Vyžaduje S012 předchozí přihlášení, nebo je dosažitelný i přes anonymní cestu dohledání pomocí
   e-mailu popsanou v Preconditions/Main Flow `UC0010`? IA jej umísťuje do zóny účtu, ale v samotném
   formuláři není viditelná žádná přihlašovací zábrana ani indikátor kontextu účtu.
   Uncertain — vyžaduje vyjasnění.
2. Jak vypadá sada polí záložky "Právnická osoba" (organizace)? Nezachyceno na žádném ze snímků;
   aktivní je zobrazena pouze výchozí záložka "Fyzická osoba". Evidence Pending.
3. Jakou zpětnou vazbu na obrazovce (pokud vůbec nějakou) uživatel obdrží pro `UC0010` AF1 (nulová
   celková částka darů — potvrzení tiše nevystaveno) nebo AF2 (snímek uložen, ale odeslání dokumentu
   se nezdaří)? Pro S012 nebyl zachycen žádný stav chyby/prázdného obsahu. Uncertain —
   validationsWithoutBR se zde také uplatňuje.
4. Odpovídá pole "Fyzická osoba s IČ" samostatnému atributu EN0014, nebo se jedná o nemodelované
   pole (např. registrační číslo OSVČ), které v současnosti není odraženo ve vrstvě EN? Uncertain.
5. Co se stane po úspěšném odeslání — existuje dedikovaná obrazovka potvrzení/úspěchu, nebo uživatel
   jednoduše obdrží PDF e-mailem beze změny na obrazovce? Nezachyceno.

---

## Evidence

| Oblast tvrzení | Jistota | Evidence |
|---|---|---|
| Existence obrazovky, route, chrome záhlaví, text hero sekce | Confirmed | `_ar/prtsc/po_prihlaseni_do_uctu.png`; `_ar/evidence/ui/ui-observed-areas.md` §12 |
| Pole formuláře (Jméno, Příjmení, Adresa, Rodné číslo, Fyzická osoba s IČ), záložky, zaškrtávací pole roku, CTA odeslání, právní disclaimer | Confirmed | `_ar/prtsc/po_prihlaseni_do_uctu_potvrzeni_o_darech.png`; `ui-observed-areas.md` §12 |
| Realizovaný UC (UC0010) a jeho flow žádost/validace/výpočet/uložení/vykreslení/odeslání | Confirmed | `_ar/spec-draft/UC/UC0010_IssueDonationConfirmation.md` |
| Tvary polí EN0014 navázané na pole formuláře | Confirmed (tvar entity) / Probable (mapování pole na atribut) | `_ar/spec-draft/EN/EN0014_DonationConfirmation.md` |
| Serverem vypočtená celková částka a pravidlo přerušení při nulové částce | Confirmed (pravidlo existuje) / Uncertain (zobrazení na obrazovce) | `_ar/spec-draft/BR/BR-DonationConfirmationAndTax.md` |
| Rozvržení polí záložky organizace ("Právnická osoba") | Evidence Pending — nezachyceno | `ui-observed-areas.md` §12 (přepínač záložek pozorován, obsah nikoli) |
| Stavy načítání / chyby / prázdného obsahu | Uncertain — Evidence Pending | Žádný snímek tyto stavy nezobrazuje |
| Požadavek na přihlášení pro dosažení S012 | Uncertain | `_ar/spec-draft/IA-screen-map.md` řádek S012 (umístěno v zóně účtu); v záznamech není viditelná žádná přihlašovací zábrana |
