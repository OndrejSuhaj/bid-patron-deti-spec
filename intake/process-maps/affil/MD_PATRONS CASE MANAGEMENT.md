### SHEET: 1_Basic_Info _ CASE MNGMNT_ ENG  (9 řádků)
Field | Fill In
Process Name | AFFIL - PATRONS - CASE MANAGEMENT
Country / Team | MD
Process Owner | Coordinator
Date | 2026-02-17 00:00:00
  ·
Process Goal (What is the output?) | To create a clear and comprehensive process documentation for the Patron care (a…
Process Start (What triggers it?) | The trigger of the CASE MANAGEMENT process is the creation of a support request …
Process End (When is it finished?) | The process ends after all administrative matters have been closed following the…

### SHEET: 2_Roles _ ENG  (18 řádků)
Role Name | Description (optional)
  ·
✅ Anyone or anything that performs an action in the process (DO NOT write person…
It can be :
👤 person - KOORDINÁTOR
👥 ffunction - Director
🤖 systém:  IT system, Mautic, atc
🏢 external subject : audit, Tax advisor etc
  ·
Potential patron | An entity identified as a potential future Patron / an organization that has not…
Patron | An organization or individual actively cooperating in the submission of a fundra…
Parent | Initiates the request and asks the Patron for support in the application process…
Admin | Is responsible for identifying, approaching, and maintaining long-term relations…
IT systém | Ensures technical processing of applications and the sending of notifications.
CRM built by our IT team | Maintains and manages the Patron database (segments). Tracks emails sent via the…
Web | Provides the application form and access to the dedicated “zone” environment.
Coordinator | Ensures administrative review of applications, monitors completion status, and c…
Risk manager | Review and approve applications in accordance with rules and risk assessment. Ve…

### SHEET: 3_Process_Steps_CASE ENG  (16 řádků)
Step Process Number | Role Responsible | Step Description (Start with a verb) | Manual / Automated | System Used (if any) | Status (what ) | Notification email parent (YES / NO ) | Notification email Patron (YES / NO )
  ·
 | ✅ choose from ROLES | ✅ Write an active verb – use present tense, 3rd person singular |  | ✅ write any system or without systém. Do not leave empty cell
1a | Patron | Completes the PATRON form via the website as the first party = PATRON INITIATOR | manual | Web | waiting for Form Parent | YES | YES
1b | Patron | Completes the PATRON form via a link in the email sent automatically by the syst… | manual | Web | waiting for Form PATRON | YES | YES
2 | IT system | Sends a notification to the Patron confirming submission of the application. | automated | IT systém | waiting for Form Parent | YES | YES
3 | IT system | Changes the application status to “Awaiting Applicant Application” if the Patron… | automated | IT systém | waiting for Form Parent | NO | NO
4 | IT system | The Patron receives a notification: Awaiting Applicant Application. | automated | IT systém | waiting for Form Parent | NO | NO
5 | IT system | Changes the application status to “Under Review” if the Patron completed the app… | manual | IT systém | FOR CHECK | NO | NO
6 | Coordinator | Activates the Patron if the applicant’s request is pending their completion unde… | manual | without systém | Awaiting Patron Application | - | -
7 | Coordinator | Contacts the Patron to request additional information regarding the applicant’s … | manual | without systém | Awaiting Additional Information | - | -
8 | Coordinator | Contacts the Patron to request completion of the Patron’s section of the applica… | manual | without systém | Awaiting Additional Information | - | -
9 | Risk manager | Approves the Patron within the application. | manual | IT systém | Scoring OK | NO | NO
10 | Risk manager | Does not approve the Patron within the application. | manual | IT systém | Scoring KO | NO | NO
11 | Coordinator | In case of Risk-related concerns, contacts the Patron to request clarification o… | manual | without systém | Scoring – Additional Information Required | NO | NO
12 | IT system | If Risk does not approve the Patron, the application is returned to the status “… | manual | IT systém | Returned Application (New Patron) | NO | NO

### SHEET: 4_Decisions CASE ENG  (5 řádků)
Decision Point Description / USE QUESTIONS | Step Process Number | Who Decides? | Criteria for Decision | What Happens if NO?
  ·
✅ Write a short question | ✅ choose Number from Process_Steps list
Did the Patron initiate the application (submit first)? | 1a | IT systém | Order of application submission between the Patron and the Applicant | The IT system sets the application status to “Under Review.”
Did the Patron complete the Parent’s application within 2/5/7 days?? | 1b | Coordinator | The application is complete | The coordinator contacts the person and is doing the best to get all the informa…

