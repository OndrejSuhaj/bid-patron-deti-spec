---
doc_id: WIRE0010
title: Application Wizard Step4 Patron
canonical_layer: WIRE
spec_type: wireframe
modules: []
screen_id: S008d
realizes_uc: [UC0001]
status: canonical
references:
  - UC0001
  - EN0001
  - EN0002
  - EN0005
  - BR-ApplicationStatusGovernance
  - BR-ScoringAndRiskGating
  - BR-PartyIdentityAndDeduplication
---

# WIRE0010 – Krok 4 průvodce žádostí – Patron

## Účel

Krok 4 ("Krok 4: Údaje o vašem Patronovi") pětikrokového veřejného průvodce žádostí (Application
wizard) na `/zadost-formular`. Žadatel (role fundraiser — rodič/zákonný zástupce, dle IA
`S008a`–`S008c`) deklaruje, kdo bude vystupovat jako Patron příběhu: jméno Patrona, jeho vztah k
rodině žadatele a kontaktní údaje, aby ho platforma mohla přímo kontaktovat. Tato obrazovka je
dosažena po kroku 3 ("Údaje o vás", `S008c`) a navazuje na stejnou orchestraci `UC0001` (Žádost
vytvořena v kroku 0/contact-gate, profil postupně vyplňován v krocích 1–5); ve vrstvě UC neexistuje
žádný dedikovaný use case "step-4-submit" — viz Otevřené otázky (stejná výhrada jako u `WIRE0007`).

Tato obrazovka řeší IA-Q5 (`_ar/spec-draft/IA/IA-patronus.md` §8) pro krok 4: mapa obrazovek IA a
`ui-observed-areas.md` §5 dříve evidovaly krok 4 jako "pouze popisek ve stepperu, nezachyceno." Nyní
existují dva přímé záznamy tohoto kroku (prázdný a vyplněný/se stavem validační chyby) — tento
dokument nahrazuje stav "nezachyceno" pro `S008d`; vrstvy IA/UOA se zde neupravují (disciplína
write-scope), ale mezera, na kterou upozornily, je touto WIRE dokumentací uzavřena. — Confirmed
identita obrazovky/URL/pole; Assumed granularita přiřazení UC (stejná výhrada jako u sesterských WIRE
dokumentů kroků průvodce).

Evidence: `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_22_08.png` (prázdný
stav), `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_22_59.png` (vyplněný stav,
se zobrazenou validační chybou na úrovni pole).

**Terminologická poznámka:** "Patron" na této obrazovce je *deklarovaný* patron žadatele pro danou
Žádost — zachycený jako pole `patron_*` v profilu žádosti fundraisera (`ApplicationProfile`, `EN0002`)
— a je odlišný od `EN0005` Patron, což je publikovaný veřejně zobrazovaný profil uváděný na stránce
kampaně/příběhu. Obě entity mohou být naplněny údaji stejné reálné osoby, ale v rámci této
rekonstrukce jde o odlišné entity; viz Datové vazby a Otevřené otázky.

---

## Zóny layoutu

- **Globální header** — logo webu "patron dětí"; hlavní navigace ("Jak to funguje", "Blog", "O nás");
  CTA tlačítko "Požádat o pomoc"; odkaz na účet "Můj účet" — Confirmed. (Cíle navigace jsou záležitostí
  vrstvy IA, zde se neopakují.)
- **Stepper bar** — 5 číslovaných kroků: "1 Příběh" (hotovo, zaškrtnutí), "2 Dar" (hotovo, zaškrtnutí),
  "3 O Vás" (hotovo, zaškrtnutí), "4 Patron" (aktivní, vyplněný červený kruh "4"), "5 Přílohy" (čeká,
  šedý obrysový kruh "5") — Confirmed.
- **Úvod stránky** — nadpis "Krok 4: Údaje o vašem Patronovi"; třířádkový instruktážní text
  vysvětlující, co je Patron, pravidlo vyloučení rodinných příslušníků, a příklady nerodinných rolí
  patrona — Confirmed (text je reprodukován doslovně pouze pro identifikaci zóny; plný text je úlohou
  vrstvy COPY).
- **Odkaz zpět** — "← Krok zpět" nad formulářovou kartou — Confirmed.
- **Formulářová karta** (jedna světle šedá karta, hlavní obsah) — Confirmed:
  - Podzóna A: "Jméno a příjmení vašeho Patrona" — dva textové inputy vedle sebe (Jméno / Příjmení).
  - Podzóna B: "V jakém vztahu je k vám nebo k vaší rodině?" — rozbalovací seznam s jedním výběrem.
  - Podzóna C: "Kontaktní údaje na Patrona" — podnadpis + jednořádkový pomocný text, poté dva inputy:
    E-mail (plná šířka) a Telefon (s pevným prefixovým segmentem "+420").
  - Podzóna D: primární CTA "Pokračovat" (vpravo dole na kartě).
- **Globální footer** — cookie lišta, blurb o organizaci "patron dětí", sloupce odkazů ("Patron dětí",
  sociální sítě; "Kontakt"), odznaky platebních poskytovatelů, číslo sběrného účtu, copyright —
  Confirmed. (Obsah/odkazy footeru jsou záležitostí IA/COPY; uvedeno pouze jako zóna layoutu.)

```
+--------------------------------------------------------------+
| Global header: logo | nav | "Požádat o pomoc" | "Můj účet"   |
+--------------------------------------------------------------+
| Stepper: (✓)Příběh (✓)Dar (✓)O Vás  (4)Patron   5 Přílohy    |
+--------------------------------------------------------------+
| "Krok 4: Údaje o vašem Patronovi" (title + 3-line intro)      |
| "← Krok zpět"                                                  |
+--------------------------------------------------------------+
| Form card:                                                     |
|  "Jméno a příjmení vašeho Patrona"                             |
|  [A] Jméno | Příjmení                                          |
|  "V jakém vztahu je k vám nebo k vaší rodině?"                 |
|  [B] [ dropdown, single-select ]                                |
|  "Kontaktní údaje na Patrona"                                   |
|  "Informujte svého Patrona o tom... budeme ho ihned kontaktovat|
|   emailem."                                                     |
|  [C] E-mail          | [+420] Telefon                          |
|                          (error text if phone == applicant's)   |
|                                            [ Pokračovat ]      |
+--------------------------------------------------------------+
| Global footer                                                  |
+--------------------------------------------------------------+
```

---

## Použité komponenty

Opakující se prvky povýšené na COMP agentem **AR:COMPSynthesizer** (viz `COMP-inventory-map.md`);
všechny ostatní položky zůstávají označené `inline` (bez evidovaného opakovaného výskytu na ≥2
obrazovkách).

| Zóna | COMP-id | Varianta/vlastnosti | Poznámky |
|---|---|---|---|
| Globální header | COMP0002 | context=public | viz `COMP0002` Global Site Header |
| Stepper bar | COMP0005 | activeIndex=4, completedIndices=[1,2,3] | Confirmed vizuální vzor; viz `COMP0005` Application Wizard Stepper |
| Odkaz zpět | inline | textový odkaz se symbolem šipky vlevo | Confirmed |
| Pole jména patrona (A) | inline | dva jednořádkové textové inputy vedle sebe (Jméno / Příjmení) | Confirmed |
| Rozbalovací seznam vztahu (B) | inline | jednovýběrový `<select>`, v prázdném stavu bez placeholderu/výchozí volby | Confirmed přítomnost; obsah seznamu voleb není zcela zdokumentován — pozorována pouze volba "Rodinný známý" (záznam vyplněného stavu) |
| Pomocný text ke kontaktu na patrona (C) | inline | jednořádkový šedý pomocný text nad poli e-mail/telefon | Confirmed |
| Pole e-mailu patrona (C) | inline | jednořádkový textový input, placeholder "E-mail" | Confirmed |
| Pole telefonu patrona (C) | inline | složený input: pevný needitovatelný prefixový segment "+420" + jednořádkový textový input telefonu; varianta s validační chybou zobrazuje červený okraj + červený pomocný text pod polem | Confirmed (zachyceny obě varianty) |
| Primární CTA | COMP0001 | — | popisek "Pokračovat"; viz `COMP0001` Primary Button |
| Globální footer | COMP0003 | — | viz `COMP0003` Global Site Footer |

---

## Interakce

1. **Vstup** — postup z `S008c` (krok 3, "Údaje o vás") přes jeho akci "Pokračovat" → stav:
   `default` (prázdný formulář, dle `screencapture-…13_22_08.png`). Confirmed sekvence dle pořadí
   kroků průvodce v IA §5.
2. **Primární akce — "Pokračovat"** — spouštěč: kliknutí/tap → efekt: odešle hodnoty polí kroku 4
   (uložené do `EN0002` `patron_first_name`, `patron_last_name`, hodnoty vztahu a
   `patron_email`/`patron_phone` — viz Datové vazby) a pokud klientská kontrola nesouladu telefonu
   projde, posune stepper na krok 5 ("Přílohy", `S008e`) — Assumed chování ukládání při pokračování
   (neevidováno: žádný dossier nepotvrzuje ukládání po jednotlivých krocích vs. jediné závěrečné
   odeslání; stejná otevřená otázka jako u `WIRE0007`/`WIRE0008`). Pokud je validace nesouladu telefonu
   aktivní, je efekt tlačítka při kliknutí, kdy je chyba zobrazena, Uncertain — nezaznamenáno (záznam
   vyplněného stavu zobrazuje již vykreslenou chybu, nikoliv pokus o odeslání zachycený uprostřed
   kliknutí).
3. **Sekundární akce — "Krok zpět"** — spouštěč: kliknutí → efekt: navigace zpět o jeden krok na
   `S008c` (krok 3, "Údaje o vás") — Confirmed dle pořadí kroků průvodce (IA §5), samotný přechod
   (zachování dat při navigaci zpět) však nebyl zaznamenán.
4. **Interakce s polem — validace nesouladu telefonu** — spouštěč: zadání telefonního čísla patrona,
   které se shoduje s vlastním telefonním číslem žadatele (zachyceným na `S008c`) → efekt: pole
   telefonu vykreslí chybový stav s červeným okrajem a vloženým textem "Telefonní číslo nemůže být
   stejné jako to Vaše." pod polem — Confirmed výskyt, Uncertain časování spuštění (při odchodu z pole
   / při změně / při pokusu o odeslání — nelze určit ze statického záznamu).
5. **Výstup (úspěch)** — postup přes "Pokračovat" vede na `S008e` (krok 5, "Přílohy") — Confirmed
   sekvence dle IA §5.
6. **Výstup (opuštění)** — zavření/odchod uprostřed průvodce; obnovení je řešeno samostatným modálním
   tokem pro obnovení konceptu (`UC0025`, `EN0003` `ApplicationSession`) při pozdější návštěvě — mimo
   rozsah této obrazovky, pouze referenčně zmíněno.

---

## Stavy

### default
Prázdný formulář: obě pole jména zobrazují placeholder text ("Jméno"/"Příjmení"), rozbalovací seznam
vztahu nezobrazuje žádnou volbu (prázdné se šipkou), a pole e-mailu/telefonu zobrazují placeholder text
("E-mail"/"Telefon") — Confirmed
(`screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_22_08.png`).

### empty
V evidenci neodlišeno od `default` — záznam "empty" *je* výše popsaný výchozí/nevyplněný stav, což
odpovídá vzoru již zaznamenanému u `WIRE0007`/`WIRE0008`. —
`N/A — the observed "default" state already represents the unfilled/empty form; no distinct
empty-state visual exists in evidence.`

### loading
V žádném ze záznamů nezaznamenáno (oba jsou statické, plně vykreslené stavy; žádné zpracování se
spinnerem/skeletonem/deaktivovaným tlačítkem během odesílání nebylo zachyceno). —
`Evidence Pending — not captured.`

### error
**Částečně zaznamenáno** — je zachycena validační chyba na úrovni pole: pole Telefon v tomto kroku
zobrazuje červený okraj a vložený červený pomocný text "Telefonní číslo nemůže být stejné jako to
Vaše.", pokud zadané telefonní číslo patrona odpovídá vlastnímu telefonnímu číslu žadatele
(`screencapture-…13_22_59.png`). Jde o **vloženou chybu na úrovni pole**, nikoliv o chybu na úrovni
stránky nebo toast/modální chybu. Žádný jiný chybový stav (např. neplatný formát e-mailu, prázdné
povinné pole při pokusu o odeslání, chyba odmítnutí ze strany serveru) na této obrazovce zaznamenán
nebyl. — Confirmed pro případ nesouladu telefonu; `Evidence Pending — not captured` pro všechny ostatní
chybové stavy.

---

## Validační plochy

| Pole/zóna | Spouštěč (BR-id) | Plocha |
|---|---|---|
| Telefon (telefon patrona) — nesmí se shodovat s vlastním telefonem žadatele | No BR found — see validationsWithoutBR | vloženě, na úrovni pole (červený okraj + červený pomocný text pod polem) — Confirmed |
| Jméno / Příjmení (jméno patrona) — povinné? | No BR found — see validationsWithoutBR | nezaznamenáno (žádný pokus o odeslání prázdného formuláře nezachycen) |
| Rozbalovací seznam "V jakém vztahu..." — povinný? | No BR found — see validationsWithoutBR | nezaznamenáno |
| E-mail (e-mail patrona) — validace formátu? | No BR found — see validationsWithoutBR | nezaznamenáno |
| Brána pro odeslání "Pokračovat" (která pole blokují postup) | No BR found — see validationsWithoutBR | nezaznamenáno |

Žádné `BRxxxx` v aktuální vrstvě BR (`BR-ApplicationStatusGovernance`, `BR-ScoringAndRiskGating`,
`BR-PartyIdentityAndDeduplication` a zbytek `_ar/spec-draft/BR/_REGISTRY.md`) nepokrývá validaci na
úrovni pole pro vstupy tohoto kroku, včetně pozorovaného pravidla, že telefon patrona se musí lišit od
telefonu žadatele. Je to zaznamenáno jako otevřená otázka, nikoli jako vymyšlené pravidlo — pravidlo je
reálné (přímo pozorované), ale jeho vlastnící BR v této rekonstrukční fázi ještě neexistuje.

**validationsWithoutBR:**
- telefon patrona ≠ telefon žadatele (na straně klienta, na úrovni pole; přímo pozorováno, bez
  vlastnícího BR)
- vynucení povinnosti polí Jméno/Příjmení/rozbalovací seznam vztahu/e-mail (nezaznamenáno, bez
  vlastnícího BR)

---

## Datové vazby

| Zóna | EN-id | QUERY-id | Poznámky |
|---|---|---|---|
| "Jméno a příjmení vašeho Patrona" (Jméno / Příjmení) | `EN0002` (`patron_first_name`, `patron_last_name`) | — | Confirmed shoda účelu pole |
| Rozbalovací seznam "V jakém vztahu je k vám nebo k vaší rodině?" | `EN0002` — v aktuálním seznamu atributů EN0002 tomuto poli neodpovídá žádný samostatný atribut | — | Uncertain — `EN0002` obsahuje `patron_occupation_list` (klasifikaci zaměstnání), ale žádný samostatný atribut "vztah k žadateli/rodině"; pozorovaná volba "Rodinný známý" působí jako kategorie vztahu, nikoli zaměstnání. Označeno jako mezera EN/WIRE, zde neřešeno. |
| "Kontaktní údaje na Patrona" — E-mail | `EN0002` (`patron_email`) | — | Confirmed shoda účelu pole |
| "Kontaktní údaje na Patrona" — Telefon (+420) | `EN0002` (`patron_phone`) | — | Confirmed shoda účelu pole |
| Kontext žádosti/relace (která `Application`/`ApplicationProfile` je upravována) | `EN0001`, `EN0002` | — | Confirmed na úrovni entity dle postpodmínek `UC0001` (Žádost + profil fundraisera vytvořeny dříve, než je tento krok dosažitelný) |
| Veřejně zobrazovaný profil patrona (jméno/foto zobrazované na výsledné stránce příběhu) | `EN0005` | — | Podle aktuální evidence touto obrazovkou nenaplňováno — `EN0005` je samostatná zobrazovací entita (příznak publikace/odpublikování, vlastní atributy jméno/druhé-jméno/foto) bez potvrzené cesty zápisu z tohoto kroku průvodce. Zda/kdy je `EN0005` odvozeno z těchto polí `patron_*` profilu, je Uncertain; viz Otevřené otázky `EN0005` a Otevřené otázky tohoto dokumentu. |

---

## Podmíněná viditelnost

| Komponenta/zóna | Podmínka (ref. ACL nebo BR) | Chování při skrytí |
|---|---|---|
| Celá obrazovka (`S008d`) | Dosažitelná pouze po dokončení `S008c` (krok 3) ve stejné relaci průvodce; dosud neexistuje vrstva ACL, na kterou by bylo možné odkázat pro roli | N/A — nezaznamenáno jako podmíněné autentizovanou rolí; žadatel je Customer v roli fundraiser dle `UC0001` |
| Odkaz "Krok zpět" | Vždy viditelný v obou záznamech | — |
| Text chyby nesouladu telefonu | Podmíněno hodnotou pole telefonu shodující se s vlastním telefonem žadatele (pozorováno, bez vlastnícího BR — viz Validační plochy) | Skryto, pokud se zadaný telefon liší od telefonu žadatele; jinak zobrazeno |

V této rekonstrukční fázi neexistuje žádná vrstva `ACLxxxx` (dle rules-WIRE.md a IA-Q4); u této
obrazovky nebylo pozorováno žádné omezení dle role nad rámec dosažitelnosti v sekvenci průvodce.

---

## Poznámky k přístupnosti

- **Pořadí tabulátoru:** Neevidováno ze statických screenshotů — Assumed následuje vizuální pořadí
  shora dolů, zleva doprava (Jméno → Příjmení → rozbalovací seznam vztahu → E-mail → Telefon →
  "Pokračovat"), v souladu se standardním formulářovým markupem, ale nepotvrzeno.
- **Fokus při vstupu:** Uncertain — nezaznamenáno.
- **Fokus při přechodu stavu:** Uncertain — zda se fokus přesune na pole Telefon nebo jeho chybový
  text při zobrazení chyby nesouladu telefonu, nelze ze statického záznamu zjistit.
- **Landmarky:** Uncertain — sémantickou strukturu (nadpisy, fieldsety, role ARIA pro stepper, zapojení
  `aria-invalid`/`aria-describedby` pro chybový text) nelze ze zobrazeného screenshotu určit.
- **Klávesové zkratky:** Žádné nezaznamenány; u standardní formulářové obrazovky se žádné neočekávají.

---

## Otevřené otázky

- Ukládá "Pokračovat" data kroku 4 okamžitě (ukládání po jednotlivých krocích), nebo pouze při
  závěrečném odeslání průvodce? Neevidováno žádným UC/dossier — stejná otevřená otázka již zaznamenaná
  u `WIRE0007`/`WIRE0008`.
- Je rozbalovací seznam "V jakém vztahu je k vám nebo k vaší rodině?" podložen potvrzeným atributem
  `EN0002`, nebo jde o nezamodelované pole (kandidát na následné doplnění EN0002)? Jedinou pozorovanou
  hodnotou volby je "Rodinný známý"; úplný seznam voleb nebyl evidován.
- Co spouští validaci pravidla telefon-patrona-musí-se-lišit-od-telefonu-žadatele (při odchodu z pole /
  při změně / při pokusu o odeslání), a je vynucována pouze na straně klienta, nebo i na straně
  serveru? Ze statického záznamu nelze určit. Toto pravidlo dosud nemá vlastnícího BR — zaznamenáno
  jako otevřená otázka, nikoli vymyšleno.
- Jaký je vztah, pokud nějaký existuje, mezi zde zachycenými poli `patron_*` (`EN0002`) a publikovanou
  zobrazovací entitou `EN0005` Patron uváděnou na stránce příběhu? Žádná potvrzená cesta zápisu tyto
  dvě entity v aktuální evidenci nespojuje (viz Otevřené otázky `EN0005`, kde je položena zrcadlová
  otázka).
- Je pro patrona v tomto kroku sbíráno "Rodné číslo" nebo jakékoli ekvivalentní pole státního
  identifikátoru, tak jako je tomu u dítěte (krok 1) a žadatele (krok 3)? Žádný ze záznamů takové pole
  nezobrazuje — Confirmed absence z toho, co bylo pozorováno, ale zda jde o záměrné návrhové
  rozhodnutí, nebo o pole mimo zachycenou zobrazovanou oblast, je Uncertain (oba záznamy zřejmě
  zobrazují celou kartu včetně footeru, takže vynechané pole pod ohybem stránky je nepravděpodobné, ale
  není zcela vyloučeno).
- Tento dokument řeší IA-Q5 pouze pro krok 4; krok 5 ("Přílohy", `S008e`) zůstává otevřený dle IA-Q5,
  dokud nebude z rovnocenné evidence vytvořen jeho vlastní WIRE dokument.

---

## Evidence

| Oblast tvrzení | Jistota | Evidence |
|---|---|---|
| Identita obrazovky, URL, stepper (kroky 1–3 hotovo, krok 4 aktivní, krok 5 čeká), titulek stránky/úvodní text | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_22_08.png` |
| Popisky polí, pořadí layoutu, výchozí stav (prázdný) | Confirmed | totéž |
| Vizuály vyplněného stavu, testovací identifikační data, validační chyba nesouladu telefonu | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_22_59.png` |
| Mapování pole na atribut EN0002 (jméno, e-mail, telefon) | Confirmed | `_ar/spec-draft/EN/EN0002_ApplicationProfile.md` |
| Mapování pole na atribut EN0002 (rozbalovací seznam vztahu) | Uncertain — odpovídající atribut nenalezen | `_ar/spec-draft/EN/EN0002_ApplicationProfile.md` |
| Vztah polí patrona na této obrazovce k zobrazovací entitě `EN0005` Patron | Uncertain | `_ar/spec-draft/EN/EN0005_Patron.md` |
| Přiřazení UC (`UC0001`) | Confirmed na úrovni IA, Assumed na úrovni granularity kroku | `_ar/spec-draft/IA/IA-patronus.md` §3.3, §5; `_ar/spec-draft/UC/UC0001_SubmitApplication.md` |
| Validační pravidla (nesoulad telefonu, povinná pole, volby rozbalovacího seznamu) | Confirmed výskyt / Uncertain mechanismus — žádné BR nenalezeno | `_ar/spec-draft/BR/_REGISTRY.md` (žádné odpovídající BR); screenshoty výše |
| stav loading | Evidence Pending — not captured | — |
| stav empty (odlišný od default) | N/A — záznam default je nevyplněný stav | `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_22_08.png` |
| Tato obrazovka byla dříve zaznamenána jako "nezachycena" (IA-Q5, `ui-observed-areas.md` §5) | Nahrazeno přímou evidencí tohoto WIRE dokumentu | `_ar/spec-draft/IA-screen-map.md` řádek S008d; `_ar/spec-draft/IA/IA-patronus.md` IA-Q5 (touto WIRE fází neupravováno — disciplína write-scope) |
