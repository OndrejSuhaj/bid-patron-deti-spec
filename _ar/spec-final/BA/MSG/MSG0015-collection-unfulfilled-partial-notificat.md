---
doc_id: MSG0015
title: Collection Unfulfilled / Partial Notification
layer: MSG
spec_type: transactional-message
status: imported
modules: []
trigger:
  - UC0011
  - UC0022
references:
  - EN0004
  - EN0001
  - EN0009
  - EN0022
---

# MSG0015 – Notifikace o nesplněném / částečně splněném vybírání

## Účel

Informovat Žadatele (Parent) a Patrona, že vybírání prostředků na Příběh (Kampaň, EN0004) nedosáhlo do
termínu cílové částky — buď zcela nesplněno (vybráno 0 %), nebo splněno pouze částečně (vybráno 1–99 %)
— a že se koordinátor ozve, aby probral další postup s vybranou částkou (použití na upravený dar, nebo
přerozdělení na jiné příběhy dětí). Jde o termínem vyvolanou zprávu z rodiny "vybírání se nepodařilo
dokončit", odlišnou od zprávy o úspěšném dokončení Kampaně, která cílové částky dosáhne.

---

## Spouštěcí událost

UC0011 (Správa životního cyklu Kampaně / Příběhu), dílčí tok UC0011.2 (Naplánované přechody
životního cyklu — vypršení termínu / automatické dokončení): Scheduler identifikuje aktivní Kampaň,
jejíž termín vypršel a jejíž vybraná částka je stále pod cílovou částkou, nastaví stav navázané
Žádosti (EN0001) na "campaign uncompleted" (`campaign_uncompleted` — cílová částka nevybrána), zrcadlí
tento stav i na Kampaň a — dle UC0011.3 — určí seznam příjemců notifikace a odešle zprávu "nesplněná
kampaň". UC0022 (Běh workflow enginu platformy) je uveden pouze jako křížový odkaz: vlastní mechanismus
plánovaného publikování cronem, ale explicitně předává tento termínem vyvolaný tok nesplnění a jeho
notifikaci do UC0011.

Potvrzeno narativně scénáři SC-8C ("Vybírání částečně splněno (1–99 %)") kroky 1–3 a SC-8D
("Vybírání 0 % nesplněno") kroky 1–3: Systém detekuje vybranou částku vůči cílové, změní stav na
"Cílová částka nedosažena" a odešle notifikaci Žadateli a Patronovi.

Tato zpráva sdružuje související stavy vyplývající z uplynutí termínu, které sdílejí stejný koncept
"vybírání nedosáhlo cíle" a navazující krok rozhodnutí koordinátora, dle Notifikační matice a
SC-8C/SC-8D:

- `campaign_uncompleted` (cílová částka nevybrána) — samotná spouštěcí událost vypršení termínu (jak
  případ 0 %, tak částečný případ procházejí tímto stavem dle UC0011.2).
- `campaign_uncompleted_inprocess` (nesplněný příběh — vypořádání darů) — probíhající/vypořádací
  varianta téhož výsledku, dokud se čeká na navazující krok koordinátora.
- `uncompleted` (nesplněný příběh) — cesta rozhodnutí Žadatele, kdy je částečná částka odmítnuta a
  Příběh je označen jako nesplněný pro přerozdělení daru (SC-8C kroky 9–12), a zároveň koncový stav
  pro cestu s 0 % vybranou částkou (SC-8D).
- `completed_partly` (splněný příběh — částečné plnění / uzavřeno — částečné plnění) — alternativní
  cesta rozhodnutí Žadatele, kdy je částečná částka přijata a back-office proces pokračuje s upraveným
  darem (SC-8C kroky 5–8).

Úroveň evidence: Confirmed pro spouštěcí událost vypršení termínu `campaign_uncompleted` a záměr
dvojího příjemce (UC0011.2/UC0011.3, SC-8C, SC-8D). Partial pro `campaign_uncompleted_inprocess`,
`uncompleted` a `completed_partly` jako samostatné instance zprávy — tyto navazující stavy jsou
doloženy v Notifikační matici a narativu rozhodnutí koordinátora SC-8C/SC-8D, ale nejsou samostatně
provedeny v číslovaném toku UC0011; zde jsou sdruženy namísto rozdělení do nedoložených samostatných
dokumentů (viz Poznámky).

---

## Příjemci

- **Žadatel / Parent** — informován, že vybírání nedosáhlo cíle (zcela nebo částečně) a že se
  koordinátor ozve, aby probral možnosti naložení s vybranou částkou.
- **Patron** — informován souběžně o témže výsledku.

Kanál — e-mail přes ES0006 (Mautic) a notifikace v zóně (Zóna žadatele / Zóna patrona), dle role a
stavu, doloženo Notifikační maticí (`intake/test-scenarios/test-scenarios.md`, list "Notification
Matrix"):

| Stav | Žadatel — e-mail | Žadatel — v zóně | Patron — e-mail | Patron — v zóně |
|---|---|---|---|---|
| `campaign_uncompleted` | YES | YES | YES | NO |
| `campaign_uncompleted_inprocess` | NO | NO | NO | YES |
| `uncompleted` | NO | YES | NO | NO |
| `completed_partly` | NO | NO | NO | NO |

SC-8C krok 1–3 (detekce "částečného vybrání" na úrovni systému) navíc uvádí YES/YES/YES/YES napříč
e-mailem a zónou Žadatele i Patrona pro počáteční přechod `campaign_uncompleted`, než se rozhodnutím
Žadatele výsledek rozvětví na `uncompleted` nebo `completed_partly` — užší řádky matice dle stavu výše
jsou považovány za aktuální referenční kanál, v souladu s projektovou prioritou evidence pro detail na
úrovni konfigurace.

Rozsah příjemců nad rámec Žadatel/Patron: podkladové odeslání při vypršení termínu určuje seznam
příjemců, který zahrnuje i další přispěvatele do Kampaně (dárce) a pevný dohledový/provozní kontakt,
nad rámec Žadatele a Patrona — doloženo narativně, ale nikoli po jednotlivých rolích v Notifikační
matici, která pro listy SC-8C/SC-8D sleduje pouze sloupce rolí Žadatel/Patron/Dárce (sloupce Dárce
u těchto dvou listů konkrétně chybí). Považováno za Partial evidenci; smlouva Žadatel/Patron výše je
Confirmed jádrem této zprávy.

Žádné kanálové varianty CZ/RO/MD nad rámec výše uvedeného nejsou doloženy; doručení je šablonováno
podle země přes ES0006, ale samotná smlouva příjemce/kanálu se dle aktuálních zdrojů dle trhu neliší.

---

## Obsah zprávy

Koncepčně každá instance této zprávy nese:

- Status zprávu potvrzující výsledek, dle literálů Notifikační matice:
  - `campaign_uncompleted`: "Spojíme se s vámi" (Žadatel) / "Dokončeno" (Patron).
  - `campaign_uncompleted_inprocess`: "Nesplněný příběh" (Žadatel) / "Nesplněný příběh v plné výši"
    (Patron).
  - `uncompleted`: "Nesplněný příběh" (Žadatel) / "Nesplněný příběh" (Patron).
  - `completed_partly`: "Částečně splněno" (Žadatel) / "Částečně splněno" (Patron).
- Informaci, že cíl vybírání nebyl do termínu dosažen (zcela nebo jen částečně vybráno).
- Informaci, že se koordinátor ozve (nebo se již ozval), aby probral, co se stane s vybranou částkou —
  buď její použití na jiný/levnější dar, nebo přerozdělení na jiné příběhy dětí.
- Implicitní odkaz na případ: zobrazeno v kontextu vlastního pohledu příjemce v Zóně žadatele / Zóně
  patrona na jeho Žádost (EN0001) / Příběh (Kampaň, EN0004), odrážející aktuální stav.

Vyloučeno z této smlouvy (doručení/implementace, nikoli obsah zprávy): přesný text obsahu/předmětu
nad rámec zde citovaných literálů z matice, HTML/vizuální prezentace, výběr šablony podle země a
mechanika určování seznamu příjemců.

---

## Poznámky / Nejistoty

- Tento dokument sdružuje čtyři související stavy (`campaign_uncompleted`, `campaign_uncompleted_inprocess`,
  `uncompleted`, `completed_partly`) pod jednu smlouvu zprávy, protože představují fáze téhož narativu
  "vybírání se nepodařilo dokončit" (SC-8C, SC-8D), nikoli čtyři nezávislé typy zpráv, dle pokynu úlohy
  ke sdružování (jedna MSG na odlišný typ zprávy, nikoli na řádek matice). Pokud budoucí evidence
  ukáže věcně odlišný obsah dle jednotlivých stavů nad rámec výše zachycených literálů, může to
  odůvodnit rozdělení.
- Odlišné od koncové zprávy o zrušení Příběhu (`canceled_campaign`, kdy Žadatel odmítne částečnou
  částku a pokračuje přerozdělení, nebo je případ s 0 % vybranou částkou formálně zrušen dle SC-8D
  kroky 7–11) — zrušení je samostatný navazující výsledek, není součástí této smlouvy.
- Podkladové odeslání pro událost vypršení termínu `campaign_uncompleted` je doloženo (FLW0022) jako
  postrádající pojistku proti opakovanému/duplicitnímu odeslání, kterou mají jiné zprávy o koncovém
  výsledku ve stejném životním cyklu — tj. pokud jsou přechod stavu a odeslání zprávy někdy odděleny
  nebo znovu spuštěny, je v současném systému možné duplicitní odeslání stejným příjemcům. Zaznamenáno
  zde jako aktuální charakteristika spolehlivosti doručení této zprávy, nikoli jako fakt o obsahu
  zprávy.
- Úroveň evidence: Confirmed pro spouštěcí událost `campaign_uncompleted`, záměr dvojího příjemce a
  jeho řádek kanálu v Notifikační matici; Partial pro navazující stavy `campaign_uncompleted_inprocess` /
  `uncompleted` / `completed_partly` jako samostatná odeslání a pro plný rozsah příjemců mimo
  Žadatel/Patron, jak je zaznamenáno výše.
