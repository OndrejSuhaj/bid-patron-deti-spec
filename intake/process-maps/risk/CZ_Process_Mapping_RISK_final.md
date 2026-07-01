### SHEET: 1_Basic_Info ENG  (8 řádků)
Field | Fill In
Process Name | Risk management
Country / Team | CZ
Process Owner | Daniela Bruková Risk manager
Date | 2026-02-11 00:00:00
Process Goal (What is the output?) | Create a clear and comprehensive process documentation for the risk management a…
Process Start (What triggers it?) | Risk manager ( in case of NO low risk ) or COO-front  ( in case of low risk ) ta…
Process End (When is it finished?) | Risk manager ( in case of NO low risk ) or COO- front ( in case of low risk ) ma…

### SHEET: 2_Roles - ENG  (16 řádků)
Role Name | Description (optional)
  ·
✅ KDOKOLI NEBO COKOLI KDO VYKONÁVÁ AKCI V PROCESU ( NEPÍŠEME JMÉNA OSOB, ALE JEJ…
To znamená, že to může být
👤 osoba - KOORDINÁTOR
👥 funkce / pozice - ŘEDITEL
🤖 systém - např. IT systém, mautic, atd
🏢 externí subjekt
  ·
Parent
Patron
IT system
Risk manager
Supplier | A person or company that supplies and deliver services or goods that are subject…
Coordinator FRONT
KAM Patron

### SHEET: 3_Process_Steps ENG  (29 řádků)
Step Process Number | Role Responsible |  | Step Description (Start with a verb) | Manual / Automated | System Used (if any) | Status | Notifikace email ZZ | Notifikace email Patron | STATUS IN PARENT ZONE | STATUS IN PATRON ZONE
 | ✅ vyberu z listu ROLE | Fáze | ✅ Napíši aktivní sloveso - používejte přítomný čas, 3. osoba jednotného čísla |  | ✅ Napíši jaký systém je použit, nebo píšu Bez systému. Políčko nenechávám prázdn…
1A | Risk manager | LOW RISK | Sets the Low Risk criteria – scoring system | manually | žádost na IT | NA | ne | ne | ne | ne
1B | Risk manager |  | Sets the Low Risk criteria – price level in the Scoring Risks Card | manually | BE | NA | ne | ne | ne | ne
1C | IT system |  | Evaluates the Low Risk scoring | automated | BE | NA | ne | ne | ne | ne
1D | Coordinator FRONT ( must be in position more than 6 months ) |  | Checks the Low Risk criteria and verifies whether it can be approved automatical… | manually | BE | Zpracování žádosti | ne | ne | ano | ano
1EA | Coordinator FRONT |  | Approves the Application | manually | BE | Scoring OK | ne | ne | ano | ano
1EB | Coordinator FRONT |  | Submits the Application to Risk Manager (if risk-related information identified … | manually | BE | Scoring kontrola | ne | ne | ano | ano
2A | Risk manager | checking Parent | Checks the information and all the attached documents in the Application | manually | BE | Scoring kontrola | ne | ne | ano | ano
2B | Risk manager |  | Checks the Black list | manually | BE | Scoring kontrola | ne | ne | ano | ano
2C | Risk manager |  | Reviews previous findings of the Risk | manually | BE | Scoring kontrola | ne | ne | ano | ano
2D | Risk manager |  | Reviews previous Applications ( for example whether Feedback is completed ) | manually | BE | Scoring kontrola | ne | ne | ano | ano
2E | Risk manager |  | PErforms external check (Google, social media, ChatGPT) | manually | Internet | Scoring kontrola | ne | ne | ano | ano
2F | Risk manager |  | Performs checks in Cribis and the Insolvency Register (enforcement and insolvenc… | manually | Cribis, ISIR | Scoring kontrola | ne | ne | ano | ano
2G | Risk manager |  | Checks single-parent status | manually | CRM, Internet | Scoring kontrola | ne | ne | ano | ano
3A | Risk manager | checking Patron | Checks Blacklistu | manually | BE | Scoring kontrola | ne | ne | ano | ano
3B | Risk manager |  | Reviews previous findings of the Risk | manually | BE | Scoring kontrola | ne | ne | ano | ano
3C | Risk manager |  | Verifies the relationship between Patron and Parent | manually | BE | Scoring kontrola | ne | ne | ano | ano
3D | Risk manager |  | Checks whether Patron is/is not as well the Supplier | manulally | Cribis, Internet | Scoring kontrola | ne | ne | ano | ano
3E | Risk manager |  | Prforms external check (Google, social media, ChatGPT) | manually | Internet | Scoring kontrola | ne | ne | ano | ano
4 | Risk manager | checking Subject of help | Identifies the subject of help, compare value on the market etc. | manually | BE, Internet | Scoring kontrola | ne | ne | ano | ano
5A | Risk manager | checking Supplier | Performs internal check of the supplier | manually | BE, Internet | Scoring kontrola | ne | ne | ano | ano
5B | Risk manager |  | Performs external verification of the supplier ( CRIBIS ETC ) | manually | Cribis, Internet | Scoring kontrola | ne | ne | ano | ano
6A | Risk manager | Adding missing information | Requests missing information from  either Parent, Patron, or supplier through co… | manually | BE, Internet | Scoring k doplnění | ne | ne | ano | ano
6B | Coordinator FRONT |  | Requests additional information from either Parent, Patron, or supplier | manually | BE, mail | Scoring k doplnění | ne | ne | ano | ano
6C | Coordinator FRONT |  | Adds the information to the Application | manually | BE | Scoring kontrola | ne | ne | ano | ano
7 | KAM Patron | checking information | Verifies added information with Patron if necessary | manually | email/call | Scoring k doplnění | ne | ne | ano | ano
8A | Risk manager | Evaluation | Approves the Application | manually | BE | Scoring OK | ne | ne | ano | ano
8B | Risk manager | Evaluation | Rejects the application | manually | BE | Scoring KO | ano | ano | ano | ano

### SHEET: LOW RISK Criteria _ ENG  (24 řádků)
  ·
Low risk is a system of requirements with points value. In order for the Coordin…
Coordinator must be in the COO position more than 6 months.
  ·
Re | REQUIREMENTS | POINTS EVALUATION
Patron != PARENT | Parent email = Patron email | -1
 | Parent email does not match Patron email | 0
Patron: | Patron is known or well known | 10
 | Patron is unknown | 0
 | Patron is on Black list | -1
PARENT | Parent is known | 10
 | Parent is unknown | 0
 | Parent is on Black list | -1
PRICE OF SUBJECT OF HELP | PRICE IS HIGHE THAN 10K Kč ( 400E ) | 0
 | PRICE IS 10K Kč ( 400 Euro ) AND LOWER | 10
MONEY TRANSFER | TO SUPPLIER | 0
 | TO PARENT | -1
  ·
IF THERE IS IN ONE REQUIREMENT SCORE MINUS 1, AUTOMATICALLY THE TOTAL SCORE IS M…
  ·
Total score
30 | LOW RISK OK - CAN BE APPROVED BY COORDINATOR
0 - 20 | must be approved by risk manager
-1 | must be approved by risk manager

### SHEET: 1_Basic_Info CZ  (8 řádků)
Field | Fill In
Process Name | Zpracování žádosti v Risku
Country / Team | CZ
Process Owner | Daniela Bruková Risk manager
Date | 2026-02-11 00:00:00
Process Goal (What is the output?) | Vytvořit přehlednou a úplnou procesní dokumentaci oblasti riskového managementu,…
Process Start (What triggers it?) | ŽÁDOST PŘEBÍRÁ ODDĚLENÍ RISKU KE SCHVÁLENÍ
Process End (When is it finished?) | ROZHODNUTÍ O SCHVÁLENÍ/NESCHVÁLENÍ

### SHEET: 3_Process_Steps (CZ)  (29 řádků)
Step Process Number | Role Responsible |  | Step Description (Start with a verb) | Manual / Automated | System Used (if any) | Status | Notifikace email ZZ | Notifikace email Patron | Zobrazení v zóně ZZ | Zobrazení v zóně Patrona | Důležitost
 | ✅ vyberu z listu ROLE | Fáze | ✅ Napíši aktivní sloveso - používejte přítomný čas, 3. osoba jednotného čísla |  | ✅ Napíši jaký systém je použit, nebo píšu Bez systému. Políčko nenechávám prázdn…
1A | Risk manažer | LOW RISK | Nastaví kritéria LowRisku - bodové hodnocení | manual | žádost na IT | NA | ne | ne | ne | ne | Must have
1B | Risk manažer |  | Nastaví kritéria LowRisku - cenová hladina na kartě Scoring Risks Form | manual | BE | NA | ne | ne | ne | ne | Must have
1C | IT systém |  | vyhodnotí Scoring LowRisk | automated | BE | NA | ne | ne | ne | ne | Must have
1D | Koordinátor ( musí být v roli více než 6M ) |  | Zkontroluje LowRisk a ověří jestli může automaticky schválit | manuálně | BE | Zpracování žádosti | ne | ne | ano | ano | Must have
1EA | Koordinátor |  | Žádost schválí | manuálně | BE | Scoring OK | ne | ne | ano | ano | Must have
1EB | Koordinátor |  | Žádost předá na Risk (pokud zjistí při zpracování žádosti rizikové informace) | manuálně | BE | Scoring kontrola | ne | ne | ano | ano | Must have
2A | Risk manažer | Prověření žadatele | Zkontroluje údaje  v žádosti  a přiložené doklady | manuálně | BE | Scoring kontrola | ne | ne | ano | ano | Must have
2B | Risk manažer |  | Zkontroluje stav Blacklistu | manuálně | BE | Scoring kontrola | ne | ne | ano | ano | Must have
2C | Risk manažer |  | Zkontroluje předchozí zjištění Risku | manuálně | BE | Scoring kontrola | ne | ne | ano | ano | Must have
2D | Risk manažer |  | Zkontroluje předchozí žádosti | manuálně | BE | Scoring kontrola | ne | ne | ano | ano | Must have
2E | Risk manažer |  | Provede externí ověření google, sociální sítě, chat GPT | manuálně | Internet | Scoring kontrola | ne | ne | ano | ano | Must have
2F | Risk manažer |  | Provede kontrolu v Cribisu, a Insolvenčním rejstříku ( exe a inso ) | manuálně | Cribis, ISIR | Scoring kontrola | ne | ne | ano | ano | Must have
2G | Risk manažer |  | Zkontroluje stav Samoživitel | manuálně | CRM, Internet | Scoring kontrola | ne | ne | ano | ano | Must have
3A | Risk manažer | Prověření patrona | Zkontroluje stav Blacklistu | manuálně | BE | Scoring kontrola | ne | ne | ano | ano | Must have
3B | Risk manažer |  | Zkontroluje předchozí zjištění Risku | manuálně | BE | Scoring kontrola | ne | ne | ano | ano | Must have
3C | Risk manažer |  | Ověří vztah patrona k žadateli | manuálně | BE | Scoring kontrola | ne | ne | ano | ano | Must have
3D | Risk manažer |  | Ověří zda Patron není také dodavatel | manuálně | Cribis, externě | Scoring kontrola | ne | ne | ano | ano | Must have
3E | Risk manažer |  | Provede externí ověření google, sociální sítě | manuálně | Internet | Scoring kontrola | ne | ne | ano | ano | Must have
4 | Risk manažer | Kontrola daru | Identifikuje dar, ověří odůvodnění, ceny, rozsah daru | manuálně | BE, Internet | Scoring kontrola | ne | ne | ano | ano | Must have
5A | Risk manažer | Prověření dodavatele | Provede interní  ověření dodavatele | manuálně | BE, Internet | Scoring kontrola | ne | ne | ano | ano | Must have
5B | Risk manažer |  | Provede externí ověření dodavatele | manuálně | Cribis, Internet | Scoring kontrola | ne | ne | ano | ano | Must have
6A | Risk manažer | Doplnění informací | Vyžádá od koordinátora chybějící informace | manuálně | BE, Internet | Scoring k doplnění | ne | ne | ano | ano | Must have
6B | Koordinátor FRONT |  | Vyžádá od žadatele nebo patrona nebo dodavatele doplnění informací | manuálně | BE, mail | Scoring k doplnění | ne | ne | ano | ano | Must have
6C | Koordinátor FRONT |  | Informace doplní k žádosti | manuálně | BE | Scoring kontrola | ne | ne | ano | ano | Must have
7 | Affil manažer | Doplnění informací | Ověří informace u Patrona | manuálně | email/call | Scoring k doplnění | ne | ne | ano | ano | Must have
8A | Risk manažer | Vyhodnocení | Žádost schválí | manuálně | BE | Scoring OK | ne | ne | ano | ano | Must have
8B | Risk manažer | Vyhodnocení | Žádost zamítne | manuálně | BE | Scoring KO | ano | ano | ano | ano | Must have

### SHEET: 4_Decisions CZ  (53 řádků)
Krok | Decision Point Description / USE QUESTIONS | Step Process Number | Who Decides? | Criteria for Decision | What Happens if YES | What Happens if NO?
  ·
 | ✅ Napíši krátká otázka | ✅ vyberu ČÍSLO z listu Process_Steps
1 | Jsou přiložené doklady které identifikují žadatele? | 1 | risk manažer | Přiložené doklady patří žadateli, jedná se o platný a uznaný průkaz totožnosti, … | krok 1a | zjištění zadá do poznámky na Scoring kartě k žadateli zadá se status Scoring k d…
1a | Patří email žadateli? | 1 | risk manažer | Email uvedený u žadatele není na první pohled cizí (doména nepatří organizaci pa… | krok 2 | zjištění zadá do poznámky na Scoring kartě k žadateli, zadá  status Scoring k do…
2 | Jsou přiložené doklady které identifikují dítě? | 1 | risk manažer | Doklad identifikuje zákonný vztah žadatele a dítěte (Rodný list, rozhodnutí o sv… | krok3 | zjištění zadá do scoring karty k žadateli, nebo dítěti zadá  status Scoring k do…
3 | Je žadatel na Blacklistu? | 2 | risk manažer | Žadatel má status Blacklist | krok 4 | krok 6
4 | Trvá důvod Blacklistu? | 2 | risk manažer | Důvody zadání na Blaclist nepominuly, aktuální žádost není možno z uvedených dův… | Status Scoring KO, info poše mailem koordinátorovi a affil | krok 5
5 | Je nutno k odstranění příznaku BlackList  doplnění od žadatele nebo patrona? | 2 | risk manažer | Pro pokračování žádosti je nutné doplnění potřebných informací, nebo kroků od ža… | Zadá status Scoring k doplnění s požadavkem na doplnění informací, nebo splnění … | , odstranění příznaku BL a krok 6
6 | Jsou v systému zaznamenané předchozí zjištění k žadateli? | 3 | risk manažer | V předchozích poznámkách risku nalezeny záznamy o předchozích zjištěních ( sociá… | Kontrola předchozích informací - jsou aktuální a úplné | krok 8
7 | Jsou zjištěné předchozí informace  dostačující ? | 3 | risk manažer | Předchozí zjištěné informace jsou aktuální a dostatečně informují o stávající si… | krok 8 ( v dalších krocích vynecháme externí ověřování ) | doplníme zjištěné aktuální informace na Scoring kartě k žadateli Krok 8
8 | Má žadatel předchozí žádosti? | 4 | risk manažer | v CRM  jsou na mail žadatele evidované další žádosti | krok9 | musí proběhnout plné prověření žadatele krok 13
9 | Jsou všechny předchozí žádosti žadatele v statusu Uzavřeno? | 4 | risk manažer | Všechny předchozí žádosti žadatele jsou ve stavu uzavřeno | krok 12 | krok 10
10 | Je některá z neuzavřených žádostí je ve statusu : čeká na ZV nespolupracující? | 4 | risk manažer | Některá z předchozích žádostí žadatele, bez ohledu na to, jestli se jedná o dítě… | Zadá status Scoring k doplnění s požadavkem o doplnění ZV, info pošle mailem koo… | krok 11
11 | Je neuzavřená žádost na dítě, pro které je aktuální žádost? | 4 | risk manažer | Předchozí neuzavřená žádost je na dítě z aktuální žádosti | Status Scoring k doplnění s požadavkem na dořešení předchozí žádosti, info pošle… | krok 12
12 | Jsou přechozí příběhy konzistentní s aktuálním příběhem ? | 4 | risk manažer | Texty  uvedené u předchozích žádostí jsou v souladu s texty u aktuální žádosti | krok 13 | Zadá status Scoring k doplnění s požadavkem na odstranění rozporu, nebo vysvětle…
13 | Nalezeny informace o žadateli ve veřejných zdrojích? | 5 | risk manažer | Ve veřejných zdrojích nalezeny informace o aktivitách na sociálnách sítích, zamě… | všechny zjištěné informace zaznamenáme do poznámky na Scoring kartě k žadateli ,… | krok 15
14 | Je při prověřování sítí a google zjištěn rozpor s informacemi zjištěnými při int… | 5 | risk manažer | Při prověřování z veřejně dostupných zdrojů zjištěno, že informace, které žadate… | krok 14a | krok 15
14 a | Jsou zjištěné informace jednoznačně negativní a v rozporu s pravidly projektu ? | 5 | risk manažer | Zjištěné informace jsou natolik závažné, že není možné pomoc v žádném případě sc… | Status Scoring KO, info poše mailem koordinátorovi a affil | Status Scoring k doplnění a dotaz KOO a affill k vysvětlení rozporu
15 | Žádá žadatel o dar, který je možno schválit jen v případě, že nemá exekuce, nebo… | 6 | risk manažer | Žadatel žádá o notebook, sportovní potřebu, hudební nástroj  a nejedná se o nutn… | V Cribisu se provede placená kontrola exekucí na rodné číslo žadatele a v Insolv… | krok 17
16 | Byli u žadatele zjištěny exekuce, nebo insolvence? | 6 | risk manažer | při zadání rodného čísla žadatele v aplikaci Cribis zjištěno, že žadatel má jedn… | Zadáme status Scoring KO, info zašleme koordinátorovi a affil s doporučním žadat… | zaznamená info do poznámky ve scoring kartě u žadatele , krok 17
17 | Označili žadatel i patron žadatele jako samoživitele? | 7 | risk manažer | V CRM zjištěno že žadatel i patron zaškrtli poláčko samoživitel | krok 18 | krok 19
18 | Je dle sociálních sítí informace o tom, že je žadatel samoživitel sporná? | 7 | risk manažer | Zjištěno, že i když patron i žadatel uvádí že žadatel je samoživitel, dle sociál… | zjištěný rozpor zaznamená do poznámky na Scoring kartě u žadatele, krok 19 | zaškrtne políčko samoživitel na scoring kartě, krok 19
19 | Je patron na Blacklistu? | 8 | risk manažer | Patron má status Blacklist | Zadá status Scoring k doplnění s požadavkem na změnu Patrona, info zašle koordin… | krok 20
20 | Jedná se o nového patrona? | 9 | risk manažer | Na patrona v systému nejsou v minulosti vedené žádné žádosti | krok 23 | krok 21
21 | Byly v  rámci předchozích zjištění nalezeny interní poznatky? | 9 | risk manažer | V předchozích poznámkách risku nalezeny záznamy o předchozích zjištěních ( sociá… | zkontroluje předchozí informace, ověří, jestli jsou  aktuální krok 22 | krok 23
22 | Jsou už zjištěné informace o patronovi dostatečné? | 9 | risk manažer | Předchozí zjištěné informace jsou aktuální a dostatečně i | krok 27 | doplníme nově zjištěné informace na scoring kartě k patronovi krok 23
23 | Jedná se o profi patrona? | 10 | risk manažer | Patron uvede svůj vztah k žadateli jako profesionální | krok 24 | krok 26
24 | Patří doména v mailu patrona organizaci, kterou patron zastupuje? | 10 | risk manažer | email patrona je ve formátu jméno@organizace | krok 25 | informaci zaznamená do poznámky na scoring kartě k patronovi, zadá scoring k dop…
25 | Souhlasí kontakty, pozice a další informace o patronovi s externím zjištěním? | 11 | risk manažer | v rámci externího ověřování nezjištěn zásadní rozpor s veřejně dostupnými inform… | zaznameníme zjištěné informace do poznámky na Scoring kartě k patronovi, krok 29 | informaci zaznamená do poznámky na Scoring kartě k patronovi , zadá scoring k do…
26 | Byly v rámci externího ověřování zjištěny závažné překážky pro schválení patrona… | 11 | risk manažer | při ověřování v externích zdrojích zjištěn rodinný vztah - patron je partner, ro… | Všechny zjištěné informace zaznamená do poznámky na Scoring kartě k patronovi, Z… | Zjištěné informace zazanamená do poznámky na Svoring kartě k patronovi, krok 27
27 | Byl zjištěn ekonomický, nebo rodinný vztah patrona k dodavateli? | 11 | risk manažer | Zjištěno že patron je ekonomicky nebo rodinně propojený s dodavatelem | Informaci zaznamenáme do poznámky na Scoring kartě k patronovi krok 28 | krok 29
28 | Je ekonomický vztah patrona a dodavatele  odůvodnený a není riziko pro schválení… | 11 | risk manažer | Jedná se o ověřeného patrona, dar je podložený napr zdravotním vyšetřením, nebo … | krok 29 | Zadá status Scoring k doplnění s požadavkem na doplnění informací, nebo změnu pa…
29 | Uvádějí patron a žadatel  shodný dar ? | 12 | risk manažer | Žadatel i patron přesně identifikují v textu dar o který je žádáno | krok 30 | zadá scoring k doplnění s požadavkem přesně identifikovat dar u patrona i  žadat…
30 | Obsahuje text v příběhu žadatele i patrona všechny relevantní informace odůvodňu… | 12 | risk manažer | V příběhu žadatele i patrona je dostatečně vysvětlena situace rodiny a důvod dar… | krok 31 | zadá scoring k doplnění s požadavkem o doplnění informace, nebo dokumentu , info…
31 | je přiložená cenová nabídka | 12 | risk manažer | K žádosti je přiložena cenová nabídka | krok 33 | krok 32
32 | je možno schválit žádost i bez cenové nabídky? | 12 | risk manažer | Dar je takové povahy, která nevyžaduje doložení cenové nabídky ( napr. Balíček š… | krok 34 | zadá status Scoring k doplnění s požadavkem o doplnění cenové nabídky , info zaš…
33 | Obsahuje cenová nabídka požadované informace? | 12 | risk manažer | V cenové nabídce jsou všechny požadované informace, termín, cena, rozpočet, rozs… | krok 34 | zadá status Scoring k doplnění s požadavkem o doplnění požadovaných informací do…
34 | Splňuje dar podmínky pro schválení nastavené projektem? | 12 | risk manažer | Dar je vyhodnocen jako adekvátní opovídá potřebám a věku dítete, patří do oblast… | krok 35 | zadá status scoring k doplnění s požadavkem o změnu, nebo úpravu  daru, info zaš…
35 | Vyžaduje schválení daru doložení zdravotní dokumentace, potvrzení lékaře nebo ji… | 12 | risk manažer | Dar je takové povahy že jeho schválení vyžaduje doložení odborného doporučení | krok 36 | krok 37
36 | Je doložená potřebná dokumentace? | 12 | risk manažer | V příohách je doložena dokumentace, která potvrzuje oprávněnost daru | krok 37 | zadá  status Scoring k doplnění s požadavkem o doplnění dokumentace, info pošle …
37 | Je  uveden jasně identifikovaný dodavatel? | 13 | risk manažer | V leadu nebo přiložené cenové nabídce je identifikován dodavatel Názvem a Ičem, … | krok 38 | zadá status scoring k doplněnní s požadavkem na identifikaci dodavatele, požadav…
38 | Jedná se o ověřeného dodavatele? | 13 | risk manažer | Dodavatel je oveřený, známý a pravidelně s ním spolupracujeme , není majetkov pr… | krok 45 | krok 39
39 | Jedná se o rizikového dodavatele ? | 13 | risk manažer | Dodavatel byl v minulosti vyhodnocen jako rizikový, pro špatnou spolupráci | zadá status Scoring k doplnění s požadavkem na změnu dodavatele, info zašle koor… | krok 40
40 | byl dodavatel při šetření v Cribisu vyhodnocen jako vysoce rizikový? | 14 | risk manažer | Při šetření v Cribisu zjištěné závažné negativní informace o dodavateli ( insolv… | Do poznámky na scoring kartě u dodavatele zaznamenáme základní informace k dodav… | Do poznámky na scoring kartě u dodavatele zaznamená základní  informace  k dodav…
41 | Byly při šetření v Cribisu zjištěny méně závažné rozpory? | 14 | risk manažer | Při šetření v Cribisu zjištěné méně závažné rozpory napr. Neodpovídá obor činnos… | Potřebné info zapíše do poznámky na Svoring kartě k dodavateli, zadá status Scor… | krok 42
42 | Byla při prověřování v Cribisu zjištěna ekonomická vazba na žadatele, nebo blízk… | 14 | risk manažer | při šetření v Cribisu zjištěno, že žadatel nebo jeho nejbližší rodina je majetko… | krok 43 | krok 44
43 | Je možná změna dodavatele, daru, nebo náprava situace? | 14 | risk manažer | je možno změnou daru nebo dodavatele, nebo jiným způsobem odstrsanění střetu záj… | Informaci zaznamená do  poznámky na Scoring kartě k žadateli, zadá  status Scori… | Zadá status KO a info zašle koordinátorovi a v kopii affill
44 | Byla při prověřování v Cribisu zjištěna ekonomická vazba na patrona, nebo blízko… | 14 | risk manažer | při šetření v Cribisu zjištěno, že patron nebo jeho nejbližší rodina je majetkov… | krok 45 | krok 48
45 | Ekonomický vztah patrona a dodavatele  je odůvodnený a není riziko pro schválení… | 14 | risk manažer | Jedná se o ověřeného patrona, dar je podložený napr zdravotním vyšetřením, nebo … | krok 48 | zaznamená informaci do scoring karty k patronovi, Zadá status Scoring k doplnění…
46 | Jsou doplněné informace úplné, dostatečné a splňující požadavek? | 19 | risk manažer | žadatel nebo patron doplnil potřebné dokumenty a informace a ty jsou byhodnoceny… | pokračuje v procesu prověřování od kroku, ve kterém byl zadán status Scoring k d… | krok 47
47 | Je potřeba k rozhodnutí doplnit další informace nebo doklady? | 19 | risk manažer | doplněné informace nejsou dostatečné ale je možno je ještě dopnit. | zadá Scoring k doplnění a info zašle mailem koordinátorovi | krok 48
48 | Jsou doplněné všechny potřebné informace a žádost je vyhodnocena jako oprávněna? | 19 | risk manažer | Žádost splňuje naše požadavky pro schválení | Zadá status Skoring OK | Zadá status Scoring KO a info zašle emailem žadateli a affill

### SHEET: 5_Issues_Risks  (3 řádků)
Issue / Bottleneck Description | Where in Process (Step Number) | Impact (Delay / Error / Cost / Risk) | Improvement Idea (if known)
  ·
✅ Správně – krátký konkrétní popis reality: | ✅ vyberu ČÍSLO z listu Process_Steps | ✅ napište, jaký důsledek má daný problém — např. zdržení, zvýšení rizika chyby, …

### SHEET: LOW RISK kriteria_ CZ  (19 řádků)
Kritérium | vyhodnocení systémem | body
Patron != žadatel: | email žadatele se shoduje s emailem patrona | -1
 | email patrona se neshoduje s emailem žadatele | 0
Patron: | patron má status Z , nebo ZD | 10
 | patron má status N | 0
 | patron má status Blacklist | -1
Žadatel: | žadatel má status Z | 10
 | žadatel má status N | 0
 | žadatel má status Blacklist | -1
Rizikovost předmětu pomoci: | cena daru přesahuje 10K Kč ( 400E ) | 0
 | cena daru nepřesahuje 10K Kč ( 400 Euro ) | 10
Výplata na BÚ žadatele: | je nastavena platba dodavateli | 0
 | je nastavena platba na BÚ žadatele | -1
pokud je někde bodové hodnocení -1, automaticky je výsledek Total score -1
  ·
Total score
30 | schválení koordinátorem
0 - 20 | předáno na Risk
-1 | předáno na Risk

