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
Field | Fill In |  | Fill In | MD
Process Name | APPLICATION - FRONT activities | Process Name | Coordinator, Acquisition specialist | APPLICATION - FRONT activities
Country / Team | CZ | Country / Team | RO | MD
Process Owner | PAVLINA BRABCOVA - FRONT COORDINATOR | Process Owner | Roxana Stan, Teodora Popescu | Madalina Fortuna
Date | 2026-02-13 00:00:00 | Date | 2026-03-03 00:00:00 | 2026-03-03 00:00:00
Process Goal (What is the output?) | MAPPING THE STEPS AND PROCESSES FROM RECEIPT OF THE APPLICATION TO SUBMISSION FO… | Process Goal (What is the output?) | Ensuring that all the information found in the request is correct and assessing … | Step-by-step process from application intake to story publication submission.
Process Start (What triggers it?) | COMPLETELY FILLED OUT APPLICATION FROM THE PATRON AND APPLICANT (BOTH FORMS) | Process Start (What triggers it?) | The process starts with requests under the 'To Check' status. | Fully completed applications submitted by both the patron and the applicant.
Process End (When is it finished?) | APPLICATION IS SENT FOR PUBLICATION OF THE STORY | Process End (When is it finished?) | When the verification part of the request is completed and the donation amount i… | The process ends after all the information was submitted

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
Role Name | Description (optional) | Role Name | Description (optional) | Role Name MD | MD description
 |  | Parent | The person who initiates the child's request, specifying the need by mentioning … | Patron | An organization or individual actively cooperating in the submission of a fundra…
 |  | Guarantor | The person or organization that supports the child and tries to help them by des… | Parent | Initiates the request and asks the Patron for support in the application process…
parent | legal representative of the child | IT systém | Handles the technical processing of applications and the distribution of notific… | IT systém | Ensures technical processing of applications and the sending of notifications.
patron |  | Web | Offers the application form and provides access to the dedicated environment. | Web | Provides the application form and access to the dedicated “zone” environment.
IT system | backend | Coordinator | Oversees administrative review of applications, tracks their completion status, … | Coordinator | Ensures administrative review of applications, monitors completion status, and c…
notification | backend + mautic | Procurement Specialist | Plans and manages all procurement activities to ensure the foundation obtains th… | Risk Manager | Verifies the beneficiary lead to ensure compliance and mitigate potential risks.
coordinator FRONT | coordinator responsible for processing applications from receipt to publication | Supplier | A person or company that provides the therapies, equipment, or goods the foundat…
supplier |  | Risk Specialist | Reviews and approves applications in accordance with rules and risk assessment. …
Risk manager |  | Executive Director | Supervises all subordinate departments and oversees all organisational processes…
KAM Patron

### SHEET: 3_Process_Steps_CZ  (41 řádků)
Step Process Number | Role Responsible | Step Description (Start with a verb) | Manual / Automated | System Used (if any) | Status | Notifikace email ZZ | Notifikace email patron | Zobrazení zóna žadatele | Zobrazení zóna patrona
  ·
 | ✅ vyberu z listu ROLE | ✅ Napíši aktivní sloveso - používejte přítomný čas, 3. osoba jednotného čísla |  | ✅ Napíši jaký systém je použit, nebo píšu Bez systému. Políčko nenechávám prázdn…
1 | IT systém | Propojí formulář ZZ a formulář patrona - vznikne žádost | automaticky | BE | Ke kontrole | ano | ano | ano | ano
2 | Koordinátor FRONT | Převezme žádost | manuálně | BE | Zpracování žádosti | ne | ne | ano | ano
3 | Koordinátor FRONT | Kontroluje žádost | manuálně | BE | Zpracování žádosti | ne | ne | ne | ne
4 | Koordinátor FRONT | Zamítne žádost (z důvodu nesplnění podmínek) | manuálně | BE | Out of scope | ano | ano | ano | ano
5 | Koordinátor FRONT | Vrací žádost k doplnění | manuálně | BE | Čeká na doplnění | ano | ne | ano | ano
5a | Koordinátor FRONT | Vrací žádost k doplnění ZZ | manuálně | BE | Čeká na doplnění | ano | ne | ano | ano
5b | Koordinátor FRONT | Žádá patrona o doplnění žádosti | manuálně | email/call | Zpracování žádosti | ne | ne | ne | ne
6 | IT systém | Pošle 1. urgenci ZZ (2 dny) | automaticky | BE | Čeká na doplnění 1. urgence | ano | ne | ano | ano
7 | IT systém | Pošle 2. urgenci ZZ (2+5 dnů) | automaticky | BE | Čeká na doplnění 2. urgence | ano | ano | ano | ano
8 | IT systém | Zruší žádost (2+5+7 dnů) | automaticky | BE | Zrušená žádost (time out) | ano | ano | ano | ano
9 | ZZ | Doplní žádost | manuálně | BE | Žádost doplněna uživatelem | ano | ne | ano | ano
10 | Koordinátor FRONT | Kontroluje doplnění žádosti | manuálně | BE | Žádost doplněna uživatelem | ne | ne | ne | ne
11 | Koordinátor FRONT | Kontaktuje dodavatele daru, poptávka daru | manuálně | email/call
12 | Dodavatel | Dodá cenovou nabídku, potvrdí spolupráci a naše podmínky | manuálně | email
13 | Koordinátor FRONT | Pošle žádost ke schválení do risku | manuálně | BE | Scoring kontrola | ne | ne | ano | ano
14 | Risk manažer | Požádá o doplnění žádosti ZZ nebo patrona | manuálně | email/BE | Scoring k doplnění | ne | ne | ne | ne
14a | Koordinátor FRONT | Vrací žádost k doplnění ZZ | manuálně | BE | Čeká na doplnění | ano | ne | ano | ano
14b | Koordinátor-/AFFIL m. | Žádá patrona o doplnění žádosti | manuálně | email/call | Scoring k doplnění | ne | ne | ne | ne
15 | IT systém | Pošle 1. urgenci ZZ (2 dny) | automaticky | BE | Čeká na doplnění 1. urgence | ano | ne | ano | ano
16 | IT systém | Pošle 2. urgenci ZZ (2+5 dnů) | automaticky | BE | Čeká na doplnění 2. urgence | ano | ano | ano | ano
17 | IT systém | Zruší žádost (2+5+7 dnů) | automaticky | BE | Zrušená žádost (time out) | ano | ano | ano | ano
18 | Risk manažer/KOO | Požádá o změnu patrona | manuálně | email/BE | Vrácená žádost (nový patron) | ano | ano | ano | ano
19 | IT systém | Pošle ZZ 1. urgenci o změnu patrona (2 dny) | automaticky | BE | Vrácená žádost (nový patron) - 1. urgence | ano | ne | ano | ne
20 | IT systém | Pošle ZZ 2. urgenci o změnu patrona (2+5 dnů) | automaticky | BE | Vrácená žádost (nový patron) - 2. urgence | ano | ne | ano | ne
21 | IT systém | Zruší žádost (2+5+7 dnů) | automaticky | BE | Zrušená žádost (time out) | ano | ano | ano | ano
22 | Zákonný zástupce | Vloží údaje o novém patronovi | manuálně | zóna ZZ | Čeká na žádost patrona | ano | ano | ano | ano
23 | IT systém | Pošle 1. urgenci patronovi (2 dny) | automaticky | BE | Čeká na žádost patrona - 1. urgence | ne | ano | ne | ano
24 | IT systém | Pošle 2. urgenci patronovi (2+5 dnů) | automaticky | BE | Čeká na žádost patrona - 2. urgence | ano | ano | ano | ano
25 | IT systém | Požádá ZZ o vložení údajů na nového patrona | automaticky | zóna ZZ | Vrácená žádost (nový patron) | ano | ne | ano | ne
26 | IT systém | Pošle 1. urgenci o změnu patrona (2 dny) | automaticky | BE | Vrácená žádost (nový patron) - 1. urgence | ano | ne | ano | ne
27 | IT systém | Pošle 2. urgenci o změnu patrona (2+5 dnů) | automaticky | BE | Vrácená žádost (nový patron) - 2. urgence | ano | ne | ano | ne
28 | IT systém | Zruší žádost (2+5+7 dnů) | automaticky | BE | Zrušená žádost (time out) | ano | ano | ano | ano
29 | Patron | Dokončí žádost | manuálně | zóna patrona | Ke kontrole | ano | ano | ano | ano
30 | Risk manažer | Zamítne žádost | manuálně | BE | Scoring KO | ano | ano | ano | ano
31 | Risk manažer | Schválí žádost | manuálně | BE | Scoring OK | ne | ne | ano | ano
32 | Koordinátor FRONT | Provede finální kontrolu žádosti a pošle k přípravě příběhu | manuálně | BE | Příprava příběhu | ano | ne | ano | ano
33 | ZZ nebo patron | Požádá o zrušení žádosti | manuálně | email
34 | Koordinátor FRONT | Zruší žádost | manuálně | BE | Zrušená žádost | ano | ne | ano | ano

### SHEET: 3_Process_Steps_EN  (41 řádků)
Step Process Number | Role Responsible | Role Responsible RO | Role Responsible MD | Step Description (Start with a verb) | Step Description (Start with a verb) - RO | Differences | Step Description (Start with a verb) -MD | Differences | Manual / Automated | Manual/ Automated -RO | Manual / Automated-MD | System Used (if any) | System Used ( if any) -RO | Manual / Automated-MD | Status | Status -RO | Status - MD | Notification email ZZ | Notification email ZZ -RO | Notification email ZZ - MD | Notification email patron | Notification emai patron -RO | Notification emai patron -MD | Parent zone notification | Parent zone notification- RO | Patron zone notification | Patron zone notification-RO
  ·
 | ✅ vyberu z listu ROLE |  |  | ✅ Napíši aktivní sloveso - používejte přítomný čas, 3. osoba jednotného čísla |  |  |  |  |  |  |  | ✅ Napíši jaký systém je použit, nebo píšu Bez systému. Políčko nenechávám prázdn…
1 | IT system | IT system | IT system | Connects parent  and patron forms | Connects the forms from parents and patron | ─ | Connects both forms | - | automatically | automatically | automatically | BE | BE | BE | Ke kontrole / to check | To check | New Application | yes | yes | yes | yes | yes | yes | yes | yes | yes | yes
2 | Coordinator FRONT | Coordinator | Coordinator | takes over application | acquires lead | ─ | Takes over and reviews the application and checks with the both sides both forms | - | manually | manually | manually | BE | BE | BE | Zpracování žádosti / Application processing | Application processing | Request in Progress | no | no | no | no | no | no | yes | yes | yes | yes
3 | Coordinator FRONT | Coordinator | Coordinator | checks the application /obligatory info, attachements, full story) | verifies all the information: medical documents,IDs, attachements, details of se… | ─ | Checks the information submitted on the application ( documents, information, st… | - | manually | manually | manually | BE | BE | BE | Zpracování žádosti / Application processing | Application processing | Request in Progress | no | no | no | no | no | no | no | no | no | no
4 | Coordinator FRONT | Coordinator | Coordinator | Rejects the application (due to failure to meet the conditions) | Sends the application to out of scope if the request does not meet the donation … | ─ | Rejects the application due to to failure to meet conditions | - | manually | manually | manually | BE | BE | BE | Out of scope | Out of scope | Request Cancelled | yes | yes | yes | yes | yes | yes | yes | yes | yes | yes
5 | Coordinator FRONT | Coordinator | Coordinator | Returns the request for completion | ─ | ─ | Requests from the applicant to find a new patron and to provide his/hers informa… | Coordinator is doing it, not the risk manager. Also we do it at the beginning | manually | ── | manually | BE | ─ | Email/call | Čeká na doplnění /waiting to be completed | ─ | Request in Progress | yes | ── | yes | no | ── | yes | yes | ─ | yes | ─
5a | Coordinator FRONT | Coordinator | - | Returns the request to the parent for completion | Sends back the application to the parent to complete additional information | ─ | - | - | manually | manually | - | BE | BE | - | Čeká na doplnění /waiting to be completed | Awainting additional information | - | yes | yes | - | no | yes | - | yes | yes | yes | yes
5b | Coordinator FRONT | Coordinator | - | Requests the patron to complete the application | ─ | we don't use this option | - | - | manually | ── | - | email/call | ── | - | Zpracování žádosti / Application processing | ── | - | no | ── | - | no | ── | - | no | ── | no | ──
6 | IT system | IT system | - | Sends parents the first reminder to complete application (2 days) | Sends 1st notification to the parent to finish application | ─ | - | - | automatically | automatically | - | BE | BE | - | Čeká na doplnění 1. urgence | reminder_1_fundraiser | - | yes | yes | - | no | no | - | yes | yes | yes | yes
7 | IT system | IT system | - | Send parents the second reminder to complete application (2+5 days) | Sends second notification to the parent to finish application | ─ | - | - | automatically | automatically | - | BE | BE | - | Čeká na doplnění 2. urgence | reminder_2_fundraiser | - | yes | yes | - | yes | no |  | yes | yes | yes | no
8 | IT system | IT system | - | Cancels the application (2+5+7 days) | cancels the request if the parent does not complete it | ─ | - | - | automatically | automatically |  | BE | BE | - | Zrušená žádost (time out) / Application cancelled | canceled_timeout | - | yes | yes |  | yes | yes |  | yes | yes | yes | yes
9 | parent | parent | Parent | Completes the application | inputs all the necessary information | ─ | Completes the application | - | manually | manually | manually | BE | BE | BE | Žádost doplněna uživatelem /Application completed by parent | Application completed by parent | Request in Progress | yes | yes | yes | no | no | yes | yes | yes | yes | yes
10 | Coordinator FRONT | Coordinator | Coordinator | Checks that the application is complete | verifies if all the information is completed and change the status to "'Suspende… | ─ | Checks if the lead is fully completed and sends it to the Risk | - | manually | manually | manually | BE | BE | BE | Žádost doplněna uživatelem /Application completed by parent | Request on hold | Request in Progress | no | no | no | no | no | no | no | no | no | no
11 | Coordinator FRONT | Acquisition specialist | Coordinator | Contacts the supplier of the donation, donation request | verifies the donation type, identifies and contacts the relevant supplier | ─ | Receives back the lead and starts working on the acquisition process together wi… | We do the acquisition process after the RISK | manually | manually | manually | email/call | BE/call/email | BE |  | Request on hold | Request in Progress |  | no | no |  | no | no |  | no |  | no
12 | Supplier | Supplier | Supplier | provides a price quote, confirms cooperation, terms and conditions | comes back with and agrees to the price offer | ─ | provides a price quote, confirms cooperation, terms and conditions | - | manually | manually | manually | email | email/whatsapp message | Email/call |  | Request on hold | Request in Progress |  | no | no |  | no | no |  | no |  | no
13 | Coordinator FRONT | Acquisition specialist | Coordinator | sends the request for approval to risk dpt. | sends the application for assessment to the risk manager |  | - | Done this step before | manually | manually | manually | BE | BE | BE | Scoring kontrola / Scoring control | Scoring | Scoring | no | no | no | no | no | no | yes | no | yes | no
14 | Risk manager | Risk manager | - | requests the parent or patron for additional info or attachments | if the additional info is needed from guarantor - I'm calling for details. If in… | the difference is that we don’t have the possibility to request additional info … | - | - | manually | manually | - | email/BE | Phone / email | - | Scoring k doplnění / scoring to be completed | Scoring | - | no | no | - | no | no |  | no | yes | no | yes
14a | Coordinator FRONT | Coordinator | - | Returns the request to parent for completion | Request additional info from parent | ─ | - | - | manually | manually | - | BE | BE |  | Čeká na doplnění /waiting to be completed | Awainting additional information | - | yes | yes |  | no | yes |  | yes | yes | yes | yes
14b | Cooridinator FRONT/KAM Patron | Coordinator | - | requests the parent or patron for completion | Once the lead has the status "refiled" (additional info completed) the info is v… | Coordinator don’t speek to the guarantor and has no option to request additional… | - | - | manually | manually | - | email/call | BE |  | Scoring k doplnění / scoring to be completed | Scoring | - | no | no |  | no | no |  | no | no | no | no
15 | IT system | IT system | - | Sends parents the first reminder to complete application (2 days) | Sends 1st notification to the parent to finish application (2 days) | ─ | - | - | automatically | automatically | - | BE | BE |  | Čeká na doplnění 1. urgence | waiting_reminder_1 | - | yes | yes |  | no | yes |  | yes | yes | yes | yes
16 | IT system | IT system | - | Send parents the second reminder to complete application (2+5 days) | Sends 2nd notification to the parent to finish application (5 days) | ─ | - | - | automatically | automatically | - | BE | BE |  | Čeká na doplnění 2. urgence | waiting_reminder_2 | - | yes | yes |  | yes | yes |  | yes | yes | yes | yes
17 | IT system | IT system | - | Cancels the application (2+5+7 days) | cancels the request if the parent does not complete it (7 days) | ─ | - | - | automatically | automatically | - | BE | BE |  | Zpracování žádosti / Application processing | canceled_timeout | - | yes | yes |  | yes | yes |  | yes | yes | yes | yes
18 | Risk manager/Coordinator FRONT | Risk manager | - | requests change of patron | if the risk analyst finds that the guarantor is related to the applicant, he req… | ─ | - | - | manually | manually | - | email/BE | BE |  | Vrácená žádost (nový patron) / Application returned  (new patron) | waiting_for_patron | - | yes | yes |  | yes | yes |  | yes | yes | yes | yes
19 | IT system | IT system | - | Sends parents the first reminder to add contant info of new patron (2 days) | Sends 1st notification to the guarantor to finish application (2 days) | ─ | - | - | automatically | automatically | - | BE | BE |  | Vrácená žádost (nový patron) - 1. urgence | reminder_1_patron | - | yes | yes |  | no | no |  | yes | no | no | no
20 | IT system | IT system | - | Send parents the second reminder to add contant info of new patron (2+5 days) | Sends 2nd notification to the guarantor to finish application (5 days) | ─ | - | - | automatically | automatically | - | BE | BE |  | Vrácená žádost (nový patron) - 2. urgence | reminder_2_patron | - | yes | yes |  | no | no |  | yes | yes | no | no
21 | IT system | IT system | - | Cancels the application (2+5+7 days) | cancels the request if the guarantor does not complete it (7 days) | ─ | - | - | automatically | automatically | - | BE | BE |  | Zrušená žádost (time out) / Application cancelled | canceled_timeout | - | yes | yes |  | yes | yes |  | yes | yes | yes | yes
22 | parent | parent | - | enters contact info of new patron | adds a new guarantor | ─ | - | - | manually | manually | - | zóna ZZ | zóna ZZ |  | Čeká na žádost patrona / Waiting for patron application | waiting_for_patron | - | yes | yes |  | yes | yes |  | yes | yes | yes | yes
23 | IT system | IT system | - | Sends patron the first reminder to complete application (2 days) | Sends 1st notification to the new  guarantor (2 days) | ─ | - | - | automatically | automatically | - | BE | BE |  | Čeká na žádost patrona - 1. urgence | reminder_1_patron | - | no | no |  | yes | yes |  | no | no | yes | yes
24 | IT system | IT system | - | Sends  patron the second reminder to complete application (2+5 days) | Sends 2nd notification to the new  guarantor (5 days) | ─ | - | - | automatically | automatically | - | BE | BE |  | Čeká na žádost patrona - 2. urgence | reminder_2_patron | - | yes | yes |  | yes | yes |  | yes | yes | yes | yes
25 | IT system | IT system | - | requests the parent to add contact info of new patron | Sends notification to the new  guarantor | ─ | - | - | automatically | automatically | - | zóna ZZ | zóna ZZ |  | Vrácená žádost (nový patron) / Application returned  (new patron) | Application returned  (new patron) | - | yes | yes |  | no | no |  | yes | yes | no | no
26 | IT system | IT system | - | Sends parents the first reminder to add contant info of new patron (2 days) | Sends 1st notification to the new  guarantor (2 days) | ─ | - | - | automatically | automatically | - | BE | BE |  | Vrácená žádost (nový patron) - 1. urgence | reminder_1_patron | - | yes | yes |  | no | no |  | yes | yes | no | no
27 | IT system | IT system | - | Sends parents the second reminder to add contant info of new patron (2+5 days) | Sends 2nd notification to the new  guarantor (5 days) | ─ | - | - | automatically | automatically | - | BE | BE |  | Vrácená žádost (nový patron) - 2. urgence | reminder_2_patron | - | yes | yes |  | no | no |  | yes | yes | no | no
28 | IT system | IT system | - | Cancels the application (2+5+7 days) | cancels the request if the guarantor does not complete it (7 days) | ─ | - | - | automatically | automatically | - | BE | BE |  | Zrušená žádost (time out) | canceled_timeout | - | yes | yes |  | yes | yes |  | yes | yes | yes | yes
29 | Patron | Patron | - | Completes the application | complete the request | ─ | - | - | manually | manually | - | zóna patrona | zóna patrona |  | Ke kontrole / to check | To check | - | yes | yes |  | yes | yes |  | yes | yes | yes | yes
30 | Risk manager | Risk manager | Risk Manager | rejects the application | rejects the granting of aid if it identifies inconsistencies between the data de… | ─ | rejects the application | - | manually | manually | manually | BE | BE | BE | Scoring KO | Scoring KO | Scoring KO | yes | yes | no | yes | yes | no | yes | yes | yes | yes
31 | Risk manager | Risk manager | Risk Manager | approves the application | check all data related to the applicant, guarantor, child, gift and supplier | ─ | approves the application | - | manually | manually | manually | BE | BE | BE | Scoring OK | Scoring OK | Scoring OK | no | no | no | no | no | no | yes | yes | yes | yes
32 | Coordinator FRONT | Risk manager | Coordinator | provides a final check of the application and sends to content for preparation o… | After all aspects are verified, the case is approved and the story is requested … | ─ | Sends the lead to the content manager for posting | - | manually | manually | manually | BE | BE | BE | Příprava příběhu / story preparation | story preparation | Scoring OK | yes | yes | no | no | no | no | yes | yes | yes | yes
33 | Parent or Patron | Parent or Patron | - | requests cancellation of the application | cancel the request if the parent no longer wants the sponsorship/also if the gua… | ─ |  | - | manually | manually |  | email | email/call |  |  | canceled_campaign |  |  | yes |  |  | yes |  |  | yes |  | yes
34 | Coordinator FRONT |  | - | Cancels the application |  |  |  |  | manually |  |  | BE |  |  | Zrušená žádost / Application cancelled |  |  | yes |  |  | no |  |  | yes |  | yes

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

