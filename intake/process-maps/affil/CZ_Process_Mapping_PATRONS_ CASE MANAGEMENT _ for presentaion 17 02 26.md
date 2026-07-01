### SHEET: 1_Basic_Info _ CASE MNGMNT_ ENG  (9 řádků)
Field | Fill In
Process Name | AFFIL - PATRONS - CASE MANAGEMENT
Country / Team | CZ
Process Owner | ALENA LEMEROVÁ _ KAM Affil
Date | 2026-02-17 00:00:00
  ·
Process Goal (What is the output?) | To create a clear and comprehensive process documentation for the Patron care (a…
Process Start (What triggers it?) | The trigger of the CASE MANAGEMENT process is the creation of a support request …
Process End (When is it finished?) | The process ends after all administrative matters have been closed following the…

### SHEET: 1_Basic_Info _ CASE MNGMNT_ CZ  (17 řádků)
Field | Fill In
Process Name | AFFIL - PATRONI - CASE MANAGEMENT
Country / Team | CZ
Process Owner | ALENA LEMEROVÁ _  KAM AFFIL
Date | 2026-02-17 00:00:00
  ·
Process Goal (What is the output?) | Vytvořit přehlednou a úplnou procesní dokumentaci oblasti péče o Patrony (affil)…
Process Start (What triggers it?) | Triggerem procesu CASE MANAGEMENT je založení formuláře pro pomoc dítěti Patrone…
Process End (When is it finished?) | Proces končí po uzavření administrativních záležitostí po předání daru.
  ·
  ·
  ·
  ·
  ·
  ·
  ·
 | \

### SHEET: 2_Roles _ ENG  (19 řádků)
Role Name | Description (optional)
  ·
✅ Anyone or anything that performs an action in the process (DO NOT write person…
It can be :
👤 person - KOORDINÁTOR
👥 ffunction - Director
🤖 systém:  IT system, Mautic, atc
🏢 external subject : audit, Tax advisor etc
  ·
Potential Patron | An entity identified as a potential future Patron / an organization that has not…
Patron | An organization or individual actively cooperating in the submission of a fundra…
Parent | Initiates the request and asks the Patron for support in the application process…
KAM Patron | Is responsible for identifying, approaching, and maintaining long-term relations…
IT system | Ensures technical processing of applications and the sending of notifications.
Mautic | Maintains and manages the Patron database (segments). Tracks emails sent via the…
Web | Provides the application form and access to the dedicated “zone” environment.
Zone Patron | Enables submission of an application without completing basic personal informati…
Coordinator FRONT | Ensures administrative review of applications, monitors completion status, and c…
Risk manager | Review and approve applications in accordance with rules and risk assessment. Ve…

### SHEET: 4_Decisions CASE ENG  (7 řádků)
Decision Point Description / USE QUESTIONS | Step Process Number | Who Decides? | Criteria for Decision | What Happens if NO?
  ·
✅ Write a short question | ✅ choose Number from Process_Steps list
Did the Patron initiate the application (submit first)? | 1a | IT systém | Order of application submission between the Patron and the Applicant | The IT system sets the application status to “Under Review.”
Did the Patron complete the Parent’s application within 2 days? | 1b | IT systém | The application is complete | The IT system changes the application status to 1st Reminder.
Did the Patron complete the application within 5 days after the 1st reminder? | 9 | IT systém | The application is complete | The IT system changes the application status to 2nd Reminder.
Did the Patron complete the application within 7 days after the 2nd reminder? | 10 | IT systém | The application is complete | The link to complete the application becomes invalid.

### SHEET: 2_Roles _ CZ  (19 řádků)
Role Name | Description (optional)
  ·
✅ KDOKOLI NEBO COKOLI KDO VYKONÁVÁ AKCI V PROCESU ( NEPÍŠEME JMÉNA OSOB, ALE JEJ…
To znamená, že to může být
👤 osoba - KOORDINÁTOR
👥 funkce / pozice - ŘEDITEL
🤖 systém - např. IT systém, mautic, atd
🏢 externí subjekt
  ·
Potenciální Patron | Subjekt identifikovaný jako možný budoucí Patron/organizace, která dosud nespolu…
Patron | Organizace nebo jednotlivec aktivně spolupracující na podání žádosti o sbírku.
Žadatel | Iniciuje žádost a žádá Patrona o podporu v žádosti. Nebo naopak vyplňuje žádost …
Pracovník péče o Patrony - KAM | Zodpovídá za vyhledávání, oslovení a dlouhodobou péči o Patrony, koordinuje komu…
IT systém | Zajišťuje technické zpracování žádostí a zasílání notifikací
Mautic | Zajišťuje seznam Patronů (segment). Mapuje odeslané maily systémem, jejich otevř…
Web | Poskytuje formulář pro žádosti a prostředí pro tzv. zónu.
Zona Patrona | Umožňuje podat žádost bez vyplnění základních informací o osobě a sledova průběh…
Koordinátorka | Zajišťuje administrativní kontrolu žádosti, sleduje stav vyplnění a komunikuje s…
Risk manažer | Provádí kontrolu a schvalování žádosti z hlediska pravidel a rizik. Prověřuje no…

### SHEET: 3_Process_Steps_CASE ENG  (22 řádků)
Step Process Number | Role Responsible | Step Description (Start with a verb) | Manual / Automated | System Used (if any) | Status (what ) | Notification email parent (YES / NO ) | Notification email Patron (YES / NO ) | Displayed in the Zone PARENT | Displayed in the Zone PATRON
  ·
 | ✅ choose from ROLES | ✅ Write an active verb – use present tense, 3rd person singular |  | ✅ write any system or without systém. Do not leave empty cell
1a | Patron | Completes the PATRON form via the website as the first party = PATRON INITIATOR | manual | Web | waiting for Form Parent | YES | YES | complete the application | Awaiting Legal Guardian
1b | Patron | Completes the PATRON form via a link in the email sent automatically by the syst… | manual | Web | waiting for Form PATRON | YES | YES | Awaiting Patron | complete the application
2 | IT systém | Sends a notification to the Patron confirming submission of the application. | automated | IT systém | waiting for Form Parent | YES | YES | Doplňte žácomplete the applicationdost | Awaiting Legal Guardian
3 | IT systém | The IT system sends an account activation notification for the Patron Zone if th… | automated | IT systém | - | NO | YES | NO | YES
4 | Patron | The Patron activates their account in the Patron Zone. | manual | Web | - | NO | NO | NO | YES
5 | IT systém | Changes the application status to “Awaiting Applicant Application” if the Patron… | automated | IT systém | waiting for Form Parent | YES | YES | complete the application | Awaiting Legal Guardian
6 | IT systém | The Patron receives a notification: Awaiting Applicant Application. | automated | IT systém | waiting for Form Parent | YES | YES | complete the application | Awaiting Legal Guardian
7 | IT systém | Changes the application status to “Under Review” if the Patron completed the app… | automated | IT systém | FOR CHECK | YES | YES | Application in Process | In Process
8 | IT systém | The Patron did not complete the application within the set deadline of 2 days an… | automated | IT systém | Awaiting Patron Application – 1st Reminder | NO | YES | Awaiting Patron | complete the application
9 | IT systém | The Patron did not complete the application within 5 days after the 1st reminder… | automated | IT systém | Awaiting Patron Application – 2nd Reminder | YES | YES | Awaiting Patron | complete the application
0 | IT systém | The Patron did not complete the application within 7 days after the 2nd reminder… | automated | IT systém | Returned Application (New Patron) | YES | YES | FIND a New Patron | Application Rejected
11 | KAM | Activates the Patron if the applicant’s request is pending their completion unde… | manual | without systém | Awaiting Patron Application – 2nd Reminder | - | - | - | -
12 | Koordinátorka or KAM | Contacts the Patron to request additional information regarding the applicant’s … | manual | without systém | Awaiting Additional Information | - | - | Please provide the missing information in the application | Awaiting Information from Applicant
13 | Koordinátorka or KAM | Contacts the Patron to request completion of the Patron’s section of the applica… | manual | without systém | Awaiting Additional Information | - | - | - | -
14 | IT systém | If the applicant’s request is in the status “Awaiting Additional Information” an… | automated | IT systém/Mautic? | Awaiting Additional Information – 2nd Reminder | YES | YES | Please provide the missing information in the application | Awaiting Information from Applicant
15 | Risk manager | Approves the Patron within the application. | manual | IT system | Scoring OK | NO | NO | Your application has been approved | Application Approved
16 | Risk manager | Does not approve the Patron within the application. | manual | IT system | Scoring KO | YES | YES | Rejected | Rejected
17 | KAM Patron | In case of Risk-related concerns, contacts the Patron to request clarification o… | manual | off system | Scoring – Additional Information Required | NO | NO | Under Review | Awaiting Application Completion
18 | IT system | If Risk does not approve the Patron, the application is returned to the status “… | manual | IT system | Returned Application (New Patron) | YES | YES | FIND a New Patron | Application Rejected

### SHEET: 3_Process_Steps_CASE CZ  (22 řádků)
Step Process Number | Role Responsible | Step Description (Start with a verb) | Manual / Automated | System Used (if any) | Status (what ) | Notification email parent (YES / NO ) | Notification email Patron (YES / NO ) | Displayed in the Zone PARENT | Displayed in the Zone PATRON
  ·
 | ✅ vyberu z listu ROLE | ✅ Napíši aktivní sloveso - používejte přítomný čas, 3. osoba jednotného čísla |  | ✅ Napíši jaký systém je použit, nebo píšu Bez systému. Políčko nenechávám prázdn…
1a | Patron | Vyplní formulář PATRONA prostřednictvím webu jako první = INICIÁTOR PATRON | manuálně | Web | Čeká na žádost ZZ | ANO | ANO | Doplňte žádost | Čekáme na zákonného zástupce
1b | Patron | Vyplní formulář PATRONA z odkazu v e-mailu, který zaslal systém po dokončení žád… | manuálně | Web | Čeká na žádost patrona | ANO | ANO | Čekáme na Patrona | Doplňte žádost
2 | IT systém | Odešle notifikaci Patronovi s potvrzením podané žádosti | automaticky | IT systém | Čeká na žádost ZZ | ANO | ANO | Doplňte žádost | Čekáme na zákonného zástupce
3 | IT systém | IT systém odešle notifikaci s aktivací účtu do Zóny Patrona, pokud Patron žádal … | automaticky | IT systém | - | NE | ANO | NE | ANO
4 | Patron | Patron aktivuje účet v Zóně Patrona | manuálně | Web | - | NE | NE | NE | ANO
5 | IT systém | Změní status žádosti na „Čeká na žádost žadatele", pokud Patron žádal jako první | automaticky | IT systém | Čeká na žádost ZZ | ANO | ANO | Doplňte žádost | Čekáme na zákonného zástupce
6 | IT systém | Patron dostane notifikaci, Čeká na žádost žadatele | automaticky | IT systém | Čeká na žádost ZZ | ANO | ANO | Doplňte žádost | Čekáme na zákonného zástupce
7 | IT systém | Změní status žádosti na "Ke kontrole", pokud Patron vyplňoval žádost jako druhý … | automaticky | IT systém | Ke kontrole | ANO | ANO | Žádost zpracováváme | Zpracováváme
8 | IT systém | Patron nevyplnil žádost ve stanovené lhůtě 2 dnů a dostává 1. urgenci | automaticky | IT systém | Čeká na žádost patrona - 1. urgence | NE | ANO | Čekáme na Patrona | Doplňte žádost
9 | IT systém | Patron nevyplnil žádost ve stanovené lhůtě 5dnů od 1. urgence a dostává 2. urgen… | automaticky | IT systém | Čeká na žádost patrona - 2. urgence | ANO | ANO | Čekáme na Patrona | Doplňte žádost
10 | IT systém | Patron nevyplnil žádost ve stanovené lhůtě 7 dnů od 2. urgence a žadatel dostane… | automaticky | IT systém | Vrácená žádost (nový patron) | ANO | ANO | Najděte nového Patrona | Zamítnutá žádost
11 | KAM | Aktivizuje Patrona, pokud žádost žadatele čeká na jeho vyplnění ve statusu "Čeká… | manuálně | BEZ SYSTÉMU | Čeká na žádost patrona - 2. urgence | - | - | - | -
12 | Koordinátorka nebo KAM | Kontaktuje Patrona o doplnění k žádosti ZZ | manuálně | BEZ SYSTÉMU | Čeká na doplnění | - | - | Doplňte informace do žádosti | Čekáme na informace od žadatele
13 | Koordinátorka nebo KAM | Kontaktuje Patrona o doplnění žádosti Patrona | manuálně | BEZ SYSTÉMU | Čeká na doplnění | - | - | - | -
14 | IT systém | Pokud je žádost žadatele ve statusu "Čeká na doplnění" a žadatel je neaktivní, p… | automaticky | IT systém/Mautic? | Čeká na doplnění - 2. urgence | ANO | ANO | Doplňte informace do žádosti | Čekáme na informace od žadatele
15 | Risk manažer | Schválí Patrona v žádosti | manuálně | IT systém | Scoring OK | NE | NE | Vaše žádost byla schválena | Žádost byla schválena
16 | Risk manažer | Neschválí Patrona v žádosti | manuálně | IT systém | Scoring KO | ANO | ANO | Neschváleno | Neschváleno
17 | KAM | V případě pochybností Risku kontaktuje Patrona, žádá vysvětlení nebo doplnění | manuálně | BEZ SYSTÉMU | Scoring k doplnění | NE | NE | Posuzujeme | Čekáme na doplnění žádosti
18 | IT systém | Pokud risk neschválí Patrona, vrací a žádost jde do statusu "Vrácená žádost - no… | manuálně | IT systém | Vrácená žádost (nový patron) | ANO | ANO | Najděte nového Patrona | Zamítnutá žádost

### SHEET: 4_Decisions CASE CZ  (7 řádků)
Decision Point Description / USE QUESTIONS | Step Process Number | Who Decides? | Criteria for Decision | What Happens if NO?
  ·
✅ Napíši krátká otázka | ✅ vyberu ČÍSLO z listu Process_Steps
Inicioval Patron žádost (  podal jako první ) ? | 1a | IT systém | Časové pořadí podání žádosti mezi Patronem a žadatelem. | IT systém nastaví status žádosti na „Ke kontrole“.
Vyplnil Patron žádost Rodiče do 2 dnů? | 1b | IT systém | Žádost je kompletní | IT systém změní status žádosti na 1. urgenci
Vyplnil Patron žádost ve stanoveném termínu do 5 dnů po zaslání 1. urgence? | 9 | IT systém | Žádost je kompletní | IT systém změní status žádosti na 2 urgenci
Vyplnil Patron žádost ve stanoveném termínu 7 dnů po zaslání výzvy v 2. urgenci? | 10 | IT systém | Žádost je kompletní | Odkaz k vyplnění žádosti přestane být platný.

