### SHEET: 1_Basic_Info _ CASE MNG  (9 řádků)
Field | Fill In
Process Name | AFFIL - GuarantorS - CASE MANAGEMENT
Country / Team | RO
Process Owner | Vulpe Ana
Date | 2026-02-17 00:00:00
  ·
Process Goal (What is the output?) | Ensure an organized and efficient process for identifying and verifying Guaranto…
Process Start (What triggers it?) | The trigger of the CASE MANAGEMENT process is the creation of a support request …
Process End (When is it finished?) | The process ends after all administrative matters have been closed following the…

### SHEET: 2_Roles   (13 řádků)
Role Name | Description (optional)
Potential Guarantor | An entity or organization identified as a possible future Guarantor, which has n…
Guarantor | An individual or organization actively involved in submitting fundraising reques…
Parent | The person who initiates the request, seeking the Guarantor’s support in the app…
Key Account Manager : Lead Acquisition | Responsible for identifying, approaching, and keeping long-term relationships wi…
IT system | Handles the technical processing of applications and the distribution of notific…
Mautic | Manages and maintains the Guarantor database (including segmentation), tracks se…
Web | Offers the application form and provides access to the dedicated “zone” environm…
Coordinator | Oversees administrative review of applications, tracks their completion status, …
Procurement Specialist | Distributes to each lead the gift price lists obtained from different suppliers.
Risk Specialist | Review and approve applications in accordance with rules and risk assessment. Ve…
Marketing team | Collaborate with the Marketing team on campaigns to generate leads, collect Guar…
Executiv Director | Collaborate with the Executive Director on signing collaborative contracts, eval…

### SHEET: 3_Process_Steps_CASE   (21 řádků)
Step Process Number | Role Responsible | Phases | Step Description (Start with a verb) | Manual / Automated | System Used (if any) | Status (what ) | Notification email parent (YES / NO ) | Notification email Guarantor (YES / NO ) | Displayed in  PARENT account | Displayed in the  Guarantor account
  ·
 | ✅ choose from ROLES |  | ✅ Write an active verb – use present tense, 3rd person singular |  | ✅ write any system or without systém. Do not leave empty cell
1a | Guarantor | ACQUSITION | Completes the Guarantor form on the website as the initial step - Guarantor INIT… | manual | Web | waiting for Form Parent | YES | YES | complete the application | Awaiting Legal Guardian
1b | Guarantor |  | Fills out the Guarantor form via the link in the system-generated email sent onc… | manual | Web | waiting for Form Guarantor | YES | YES | Awaiting Guarantor | complete the application
2 | IT system |  | Notifies the Guarantor that the application has been successfully submitted | automated | IT systém | waiting for Form Parent | YES | YES | complete the application | Awaiting Legal Guardian
3 | IT system |  | Updates the application status to 'Awaiting Parent Application' when the Guarant… | automated | IT systém | waiting for Form Parent | YES | YES | complete the application | Awaiting Legal Guardian
4 | IT system |  | The Guarantor is notified that the application is 'Awaiting Parent Application'. | automated | IT systém | waiting for Form Parent | YES | YES | complete the application | Awaiting Legal Guardian
5 | IT system |  | Updates the application status to 'Under Review' when the Guarantor completes th… | automated | IT systém | FOR CHECK | YES | YES | Application in Process | Application in Process
6 | IT system |  | The Guarantor did not complete the application within the set deadline of 2 days… | automated | IT systém | Awaiting Guarantor Application – 1st Reminder | YES | YES | Awaiting Guarantor | complete the application
7 | IT system |  | The Guarantor did not complete the application within 5 days after the 1st remin… | automated | IT systém | Awaiting Guarantor Application – 2nd Reminder | YES | YES | Awaiting Guarantor | complete the application
8 | KAM |  | Contact the Guarantor if the applicant’s request is pending their completion und… | manual | without systém | Awaiting Guarantor Application – 2nd Reminder | - | - | Awaiting Guarantor | complete the application
9 | IT system |  | The Guarantor did not complete the application within 7 days after the 2nd remin… | automated | IT systém | Returned Application (New Guarantor) | YES | YES | FIND a New Guarantor | Application Rejected
10 | Coordinator | EVALUATION | Contacts the parent to request additional information regarding the applicant’s … | automated | IT systém | Awaiting Additional Information | YES | YES | Please provide the missing information in the application | Awaiting Information from Applicant
11 | IT system |  | If the applicant’s request is in the 'Awaiting Additional Information' status an… | automated | IT systém | Awaiting Additional Information | YES | YES | Please provide the missing information in the application | Awaiting Information from Applicant
12 | IT system |  | If the applicant’s request is in the status “Awaiting Additional Information” an… | automated | IT systém | Awaiting Additional Information – 2nd Reminder | YES | YES | Please provide the missing information in the application | Awaiting Information from Applicant
13 | Procurement Specialist |  | Contacts the Guarantor to request additional information regarding the applicant… | manual | without systém | Request on hold | - | - | Request on hold | Request on hold
13 | Risk manager |  | Approves the Guarantor within the application. | manual | IT systém | Scoring OK | NO | NO | Your application has been approved | Application Approved
14 | Risk manager |  | Does not approve the Guarantor within the application. | manual | IT systém | Scoring KO | YES | YES | Rejected | Rejected
15 | Risk manager |  | In cases of risk-related concerns, contacts the Guarantor to obtain clarificatio… | manual | without systém | Scoring | NO | NO | Application review | Application review
16 | IT system |  | If Risk does not approve the Guarantor, the application status is changed to 'Re… | manual | IT systém | Returned Application (New Guarantor) | YES | YES | FIND a New Guarantor | Application Rejected

### SHEET: 4_Decisions CASE ENG  (7 řádků)
Decision Point Description / USE QUESTIONS | Step Process Number | Who Decides? | Criteria for Decision | What Happens if NO?
  ·
✅ Write a short question | ✅ choose Number from Process_Steps list
Did the Guarantor initiate the application (submit first)? | 1a | IT systém | Order in Which the Guarantor and Applicant Submit the Application | The application was started by parent
Did the Guarantor complete the Parent’s application within 2 days? | 1b | IT systém | The application is complete | The IT system changes the application status to 1st Reminder.
Did the Guarantor complete the application within 5 days after the 1st reminder? | 7 | IT systém | The application is complete | The IT system changes the application status to 2nd Reminder.
Did the Guarantor complete the application within 7 days after the 2nd reminder? | 12 | IT systém | The application is complete | The link to complete the application becomes invalid.

