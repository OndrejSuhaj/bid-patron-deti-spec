### SHEET: 1_Basic_Info _ CASE MNGMNT_ ENG  (9 řádků)
Field | Fill In
Process Name | Finance-General
Country / Team | MD
Process Owner | Coordinator/Administrator
Date | 2026-02-24 00:00:00
  ·
Process Goal (What is the output?) | Ensures payment of invoices and other payment documents from suppliers of servic…
Process Start (What triggers it?) | Receiving any payment documents from the back office finance ( such as Invoice e…
Process End (When is it finished?) | When status is changed to "Story Successfully Completed” and the documents are f…

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
Patron | An organization or individual actively cooperating in the submission of a fundra…
Parent | Initiates the request and asks the Patron for support in the application process…
Coordinator | Coordinates the gift selection and procurement process by working with the famil…
IT system | Ensures technical processing of applications and the sending of notifications.
CRM built by our IT team | Mailings and newsletters are manually created using templates and distributed to…
Web | Provides the application form and access to the dedicated “zone” environment.
Admin | Approves the selected supplier and gift, processes payments, coordinates daily w…
Risk manager | Verifies the supplier, the selected gift, and the beneficiary lead to ensure com…
Accountant | Registers the supplier contract, invoice, and payment documents in the accountin…
PE audit department | Conducts independent audits to verify that supplier selection, procurement docum…

### SHEET: 3_Process_Steps_CASE ENG  (20 řádků)
Step Process Number | Role Responsible | Step Description (Start with a verb) | Manual / Automated | System Used (if any) | Status (what ) | Notification email parent (YES / NO ) | Notification email Patron (YES / NO )
  ·
 | ✅ choose from ROLES | ✅ Write an active verb – use present tense, 3rd person singular |  | ✅ write any system or without systém. Do not leave empty cell
1 | Coordinator | Introduces the status “Request in Progress ” in the IT system after the case is … | manual | IT systém | Score OK
2 | Coordinator | Selects the appropriate gift together with the parent/guardian. | manual | without systém | Request in Progress | - | -
3 | Coordinator | Reviews, adjusts if necessary, and confirms the final agreed gift price in the I… | manual | IT systém | Request in Progress
4 | Risk Manager | Verifies the supplier, the selected gift, and the beneficiary lead. | manual | without systém | Request in Progress | - | -
5 | Admin | Submits payment requests exceeding €6,000 to the Board for approval prior to exe… | manual | without systém | - | - | -
6 | Admin | Approves the supplier and the selected gift. | manual | without systém | Request in Progress | - | -
7 | Admin | Prepares the required procurement documentation. | manual | without systém | Request in Progress | NO | NO
8 | Accountant | Registers the supplier contract, invoice, and payment documents in the accountin… | manual | without systém | Request in Progress | NO | NO
9 | Admin | Executes the payment and coordinates with the accountant. | manual | without systém | Request in Progress | NO | NO
 | Coordinator | Changes the lead status to “Story Successfully Completed” in the IT system. | manual | IT systém | Request in Progress | - | -
10 | Coordinator | Organizes the delivery of the gift to the beneficiary (either personally or thro… | manual | without systém | Request in Progress | Yes | NO
11 | Coordinator | Registers the contract with the parents in the IT system. | manual | IT systém | Story Successfully Completed | - | -
12 | IT system | Displays in real time the total amount spent on gifts and the total amount colle… | automatically | IT systém | - | - | -
13 | Operational Manager | Prepares a monthly report of all payments reflected in the bank statements. | manual | without systém | - | - | -
  ·
  ·
 |  | NOTE: Existing Premier Energy suppliers may be prioritized for purchases when th…

### SHEET: 4_Decisions CASE ENG  (7 řádků)
Decision Point Description / USE QUESTIONS | Step Process Number | Who Decides? | Criteria for Decision | What Happens if NO?
  ·
✅ Write a short question | ✅ choose Number from Process_Steps list
Is the final agreed gift price validated and confirmed? | 3 | Coordinator | Price reviewed with parent and aligned with market offer. | Coordinator corrects the amount in the IT system before proceeding to approval.
Is the supplier and gift approved from a risk perspective? | 4 | Risk Manager | Supplier credibility verified and no compliance concerns identified. | Coordinator selects an alternative supplier or requests additional clarification…
Does the Admin approve the supplier and gift? | 5 | Admin | Documentation complete and price within approved budget. | Case is returned to Coordinator for correction.
Are sufficient funds available for the gift? | 5 | Admin / Accountant | Available balance in campaign budget or online collected funds. | Gift delivery is postponed until sufficient funds are collected.

