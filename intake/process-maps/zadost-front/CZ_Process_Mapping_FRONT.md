### SHEET: 1_Basic_Info_CZ  (8 řádků)
Field | Fill In
Process Name | ŽÁDOST - PŘEDEK
Country / Team | CZ
Process Owner | PAVLÍNA
Date | 2026-02-13 00:00:00
Process Goal (What is the output?) | ZMAPOVÁNÍ KROKŮ A PROCESŮ OD PŘEVZETÍ ŽÁDOSTI  DO ZÁSLÁNÍ KE ZVEŘEJNĚNÍ PŘÍBĚHU
Process Start (What triggers it?) | KOMPLETNĚ VYPLNĚNÝ FORMULÁŘ OD PATRONA I ŽADATELE - VZNIKÁ ŽÁDOST
Process End (When is it finished?) | KOO POSÍLÁ K PŘÍPRAVĚ PŘÍBĚHU

### SHEET: 1_Basic_Info_EN  (8 řádků)
Field | Fill In
Process Name | APPLICATION - FRONT activities
Country / Team | CZ
Process Owner | PAVLINA BRABCOVA - FRONT COORDINATOR
Date | 2026-02-13 00:00:00
Process Goal (What is the output?) | MAPPING THE STEPS AND PROCESSES FROM RECEIPT OF THE APPLICATION TO SUBMISSION FO…
Process Start (What triggers it?) | COMPLETELY FILLED OUT APPLICATION FROM THE PATRON AND APPLICANT (BOTH FORMS)
Process End (When is it finished?) | APPLICATION IS SENT FOR PUBLICATION OF THE STORY

### SHEET: 2_Roles_CZ  (11 řádků)
Role Name | Description (optional)
  ·
  ·
rodič | zákonný zástupce dítěte
patron
IT systém | backend
notifikace | backend + mautic
koordinator FRONT | koordinator, který je zodpovědný za zpracování žádosti od převzetí do zveřejnění
dodavatel
risk manažer
AFFIL manažer

### SHEET: 2_Roles_EN  (11 řádků)
Role Name | Description (optional)
  ·
  ·
parent | legal representative of the child
patron
IT system | backend
notification | backend + mautic
coordinator FRONT | coordinator responsible for processing applications from receipt to publication
supplier
risk manager
KAM Patron

### SHEET: 3_Process_Steps_CZ  (41 řádků)
Step Process Number | Role Responsible | Step Description (Start with a verb) | Manual / Automated | System Used (if any) | Status | Notifikace email ZZ | Notifikace email patron | Zobrazení zóna žadatele | Zobrazení zóna patrona | MUST HAVE/ NICE TO HAVE
  ·
 | ✅ vyberu z listu ROLE | ✅ Napíši aktivní sloveso - používejte přítomný čas, 3. osoba jednotného čísla |  | ✅ Napíši jaký systém je použit, nebo píšu Bez systému. Políčko nenechávám prázdn…
1 | IT systém | Propojí formulář ZZ a formulář patrona - vznikne žádost | automaticky | BE | Ke kontrole | ano | ano | ano | ano | MUST HAVE
2 | Koordinátor FRONT | Převezme žádost | manuálně | BE | Zpracování žádosti | ne | ne | ano | ano | MUST HAVE
3 | Koordinátor FRONT | Kontroluje žádost | manuálně | BE | Zpracování žádosti | ne | ne | ne | ne | MUST HAVE
4 | Koordinátor FRONT | Zamítne žádost (z důvodu nesplnění podmínek) | manuálně | BE | Out of scope | ano | ano | ano | ano | NICE TO HAVE
5 | Koordinátor FRONT | Vrací žádost k doplnění | manuálně | BE | Čeká na doplnění | ano | ne | ano | ano | MUST HAVE
5a | Koordinátor FRONT | Vrací žádost k doplnění ZZ | manuálně | BE | Čeká na doplnění | ano | ne | ano | ano | MUST HAVE
5b | Koordinátor FRONT | Žádá patrona o doplnění žádosti | manuálně | email/call | Zpracování žádosti | ne | ne | ne | ne | NICE TO HAVE
6 | IT systém | Pošle 1. urgenci ZZ (2 dny) | automaticky | BE | Čeká na doplnění 1. urgence | ano | ne | ano | ano | MUST HAVE
7 | IT systém | Pošle 2. urgenci ZZ (2+5 dnů) | automaticky | BE | Čeká na doplnění 2. urgence | ano | ano | ano | ano | NICE TO HAVE
8 | IT systém | Zruší žádost (2+5+7 dnů) | automaticky | BE | Zrušená žádost (time out) | ano | ano | ano | ano | MUST HAVE
9 | ZZ | Doplní žádost | manuálně | BE | Žádost doplněna uživatelem | ano | ne | ano | ano | MUST HAVE
10 | Koordinátor FRONT | Kontroluje doplnění žádosti | manuálně | BE | Žádost doplněna uživatelem | ne | ne | ne | ne | MUST HAVE
11 | Koordinátor FRONT | Kontaktuje dodavatele daru, poptávka daru | manuálně | email/call
12 | Dodavatel | Dodá cenovou nabídku, potvrdí spolupráci a naše podmínky | manuálně | email
13 | Koordinátor FRONT | Pošle žádost ke schválení do risku | manuálně | BE | Scoring kontrola | ne | ne | ano | ano | MUST HAVE
14 | Risk manažer | Požádá o doplnění žádosti ZZ nebo patrona | manuálně | email/BE | Scoring k doplnění | ne | ne | ne | ne | MUST HAVE
14a | Koordinátor FRONT | Vrací žádost k doplnění ZZ | manuálně | BE | Čeká na doplnění | ano | ne | ano | ano | MUST HAVE
14b | Koordinátor-/AFFIL m. | Žádá patrona o doplnění žádosti | manuálně | email/call | Scoring k doplnění | ne | ne | ne | ne | KOO - NICE TO HAVE
15 | IT systém | Pošle 1. urgenci ZZ (2 dny) | automaticky | BE | Čeká na doplnění 1. urgence | ano | ne | ano | ano | MUST HAVE
16 | IT systém | Pošle 2. urgenci ZZ (2+5 dnů) | automaticky | BE | Čeká na doplnění 2. urgence | ano | ano | ano | ano | NICE TO HAVE
17 | IT systém | Zruší žádost (2+5+7 dnů) | automaticky | BE | Zrušená žádost (time out) | ano | ano | ano | ano | MUST HAVE
18 | Risk manažer/KOO | Požádá o změnu patrona | manuálně | email/BE | Vrácená žádost (nový patron) | ano | ano | ano | ano | KOO - NICE TO HAVE
19 | IT systém | Pošle ZZ 1. urgenci o změnu patrona (2 dny) | automaticky | BE | Vrácená žádost (nový patron) - 1. urgence | ano | ne | ano | ne | MUST HAVE
20 | IT systém | Pošle ZZ 2. urgenci o změnu patrona (2+5 dnů) | automaticky | BE | Vrácená žádost (nový patron) - 2. urgence | ano | ne | ano | ne | NICE TO HAVE
21 | IT systém | Zruší žádost (2+5+7 dnů) | automaticky | BE | Zrušená žádost (time out) | ano | ano | ano | ano | MUST HAVE
22 | Zákonný zástupce | Vloží údaje o novém patronovi | manuálně | zóna ZZ | Čeká na žádost patrona | ano | ano | ano | ano | MUST HAVE
23 | IT systém | Pošle 1. urgenci patronovi (2 dny) | automaticky | BE | Čeká na žádost patrona - 1. urgence | ne | ano | ne | ano | MUST HAVE
24 | IT systém | Pošle 2. urgenci patronovi (2+5 dnů) | automaticky | BE | Čeká na žádost patrona - 2. urgence | ano | ano | ano | ano | NICE TO HAVE
25 | IT systém | Požádá ZZ o vložení údajů na nového patrona | automaticky | zóna ZZ | Vrácená žádost (nový patron) | ano | ne | ano | ne | MUST HAVE
26 | IT systém | Pošle 1. urgenci o změnu patrona (2 dny) | automaticky | BE | Vrácená žádost (nový patron) - 1. urgence | ano | ne | ano | ne | MUST HAVE
27 | IT systém | Pošle 2. urgenci o změnu patrona (2+5 dnů) | automaticky | BE | Vrácená žádost (nový patron) - 2. urgence | ano | ne | ano | ne | NICE TO HAVE
28 | IT systém | Zruší žádost (2+5+7 dnů) | automaticky | BE | Zrušená žádost (time out) | ano | ano | ano | ano | MUST HAVE
29 | Patron | Dokončí žádost | manuálně | zóna patrona | Ke kontrole | ano | ano | ano | ano | MUST HAVE
30 | Risk manažer | Zamítne žádost | manuálně | BE | Scoring KO | ano | ano | ano | ano | MUST HAVE
31 | Risk manažer | Schválí žádost | manuálně | BE | Scoring OK | ne | ne | ano | ano | MUST HAVE
32 | Koordinátor FRONT | Provede finální kontrolu žádosti a pošle k přípravě příběhu | manuálně | BE | Příprava příběhu | ano | ne | ano | ano | MUST HAVE
33 | ZZ nebo patron | Požádá o zrušení žádosti | manuálně | email
34 | Koordinátor FRONT | Zruší žádost | manuálně | BE | Zrušená žádost | ano | ne | ano | ano | MUST HAVE

### SHEET: 3_Process_Steps_EN  (41 řádků)
Step Process Number | Role Responsible | Step Description (Start with a verb) | Manual / Automated | System Used (if any) | Status | Notification email ZZ | Notification email patron | Parent zone notification | Patron zone notification
  ·
 | ✅ vyberu z listu ROLE | ✅ Napíši aktivní sloveso - používejte přítomný čas, 3. osoba jednotného čísla |  | ✅ Napíši jaký systém je použit, nebo píšu Bez systému. Políčko nenechávám prázdn…
1 | IT system | Connects parent  and patron forms | automatically | BE | Ke kontrole / to check | yes | yes | yes | yes
2 | Coordinator FRONT | takes over application | manually | BE | Zpracování žádosti / Application processing | no | no | yes | yes
3 | Coordinator FRONT | checks the application /obligatory info, attachements, full story) | manually | BE | Zpracování žádosti / Application processing | no | no | no | no
4 | Coordinator FRONT | Rejects the application (due to failure to meet the conditions) | manually | BE | Out of scope | yes | yes | yes | yes
5 | Coordinator FRONT | Returns the request for completion | manually | BE | Čeká na doplnění /waiting to be completed | yes | no | yes | yes
5a | Coordinator FRONT | Returns the request to the parent for completion | manually | BE | Čeká na doplnění /waiting to be completed | yes | no | yes | yes
5b | Coordinator FRONT | Requests the patron to complete the application | manually | email/call | Zpracování žádosti / Application processing | no | no | no | no
6 | IT system | Sends parents the first reminder to complete application (2 days) | automatically | BE | Čeká na doplnění 1. urgence | yes | no | yes | yes
7 | IT system | Send parents the second reminder to complete application (2+5 days) | automatically | BE | Čeká na doplnění 2. urgence | yes | yes | yes | yes
8 | IT system | Cancels the application (2+5+7 days) | automatically | BE | Zrušená žádost (time out) / Application cancelled | yes | yes | yes | yes
9 | parent | Completes the application | manually | BE | Žádost doplněna uživatelem /Application completed by parent | yes | no | yes | yes
10 | Coordinator FRONT | Checks that the application is complete | manually | BE | Žádost doplněna uživatelem /Application completed by parent | no | no | no | no
11 | Coordinator FRONT | Contacts the supplier of the donation, donation request | manually | email/call
12 | Supplier | provides a price quote, confirms cooperation, terms and conditions | manually | email
13 | Coordinator FRONT | sends the request for approval to risk dpt. | manually | BE | Scoring kontrola / Scoring control | no | no | yes | yes
14 | Risk manager | requests the parent or patron for additional info or attachments | manually | email/BE | Scoring k doplnění / scoring to be completed | no | no | no | no
14a | Coordinator FRONT | Returns the request to parent for completion | manually | BE | Čeká na doplnění /waiting to be completed | yes | no | yes | yes
14b | Cooridinator FRONT / KAM Patron | requests the parent or patron for completion | manually | email/call | Scoring k doplnění / scoring to be completed | no | no | no | no
15 | IT system | Sends parents the first reminder to complete application (2 days) | automatically | BE | Čeká na doplnění 1. urgence | yes | no | yes | yes
16 | IT system | Send parents the second reminder to complete application (2+5 days) | automatically | BE | Čeká na doplnění 2. urgence | yes | yes | yes | yes
17 | IT system | Cancels the application (2+5+7 days) | automatically | BE | Zpracování žádosti / Application processing | yes | yes | yes | yes
18 | Risk manager / Coordinator FRONT | requests change of patron | manually | email/BE | Vrácená žádost (nový patron) / Application returned  (new patron) | yes | yes | yes | yes
19 | IT system | Sends parents the first reminder to add contant info of new patron (2 days) | automatically | BE | Vrácená žádost (nový patron) - 1. urgence | yes | no | yes | no
20 | IT system | Send parents the second reminder to add contant info of new patron (2+5 days) | automatically | BE | Vrácená žádost (nový patron) - 2. urgence | yes | no | yes | no
21 | IT system | Cancels the application (2+5+7 days) | automatically | BE | Zrušená žádost (time out) / Application cancelled | yes | yes | yes | yes
22 | parent | enters contact info of new patron | manually | zóna ZZ | Čeká na žádost patrona / Waiting for patron application | yes | yes | yes | yes
23 | IT system | Sends patron the first reminder to complete application (2 days) | automatically | BE | Čeká na žádost patrona - 1. urgence | no | yes | no | yes
24 | IT system | Sends  patron the second reminder to complete application (2+5 days) | automatically | BE | Čeká na žádost patrona - 2. urgence | yes | yes | yes | yes
25 | IT system | requests the parent to add contact info of new patron | automatically | zóna ZZ | Vrácená žádost (nový patron) / Application returned  (new patron) | yes | no | yes | no
26 | IT system | Sends parents the first reminder to add contant info of new patron (2 days) | automatically | BE | Vrácená žádost (nový patron) - 1. urgence | yes | no | yes | no
27 | IT system | Sends parents the second reminder to add contant info of new patron (2+5 days) | automatically | BE | Vrácená žádost (nový patron) - 2. urgence | yes | no | yes | no
28 | IT system | Cancels the application (2+5+7 days) | automatically | BE | Zrušená žádost (time out) | yes | yes | yes | yes
29 | Patron | Completes the application | manually | zóna patrona | Ke kontrole / to check | yes | yes | yes | yes
30 | Risk manager | rejects the application | manually | BE | Scoring KO | yes | yes | yes | yes
31 | Risk manager | approves the application | manually | BE | Scoring OK | no | no | yes | yes
32 | Coordinator FRONT | provides a final check of the application and sends to content for preparation o… | manually | BE | Příprava příběhu / story preparation | yes | no | yes | yes
33 | Parent or Patron | requests cancellation of the application | manually | email
34 | Coordinator FRONT | Cancels the application (2+5+7 days) | manually | BE | Zrušená žádost / Application cancelled | yes | no | yes | yes

### SHEET: 4_Decisions  (9 řádků)
Decision Point Description / USE QUESTIONS | Step Process Number | Who Decides? | Criteria for Decision | What Happens if NO?
  ·
✅ Napíši krátká otázka | ✅ vyberu ČÍSLO z listu Process_Steps
Je žádost kompletní? | 3 | Koordinátor | Povinné přílohy a informace | Vrací žádost ZZ k doplnění
Doplnil žadatel žádost? | 5a | IT systém | Doplnění žádosti | Systém zruší žádost
Vrátil RISK manažer žádost k doplnění? | 14 | Risk manažer | Risk kritéria | Scoring OK nebo KO
Schválil risk manažer žádost? | 23 | Risk manažer | Risk kritéria | KO nebo doplnění žádosti
Našel si ZZ nového patrona? | 22 | IT systém | ZZ vloží údajenového patrona | Žádost je zrušena
Vyplnil nový patron žádost? | 29 | IT systém | Patron dokončil žádost | Žádost je zrušena

