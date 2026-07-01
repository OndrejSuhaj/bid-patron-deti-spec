### SHEET: 📋 Overview  (56 řádků)
PATRON DETI CZ – APPLICATION PROCESS  |  TEST SCENARIOS OVERVIEW
Scenario ID | Prio A/B/C | Owner | Scenario Name | Description | Expected Result | Pass / Fail | Notes
BLOCK 1 – Application Submission
SC-1A | A | Klara | Parent initiates application ⏎ from the website | 1. Parent fills form first on the website ⏎ 2. System sends link to Patron ⏎ 3. … | 1. Parent fills form first on the website ⏎ 2. System sends link to Patron ⏎ 3. …
SC-1B | A | Katka | Patron initiates application ⏎ from the website | 1. Patron fills form first ⏎ 2. System sends link to Parent ⏎ 3. Patron activate… | Parent receives email with link. Patron receives confirmation.
 | A | Klara | Parent initiates application ⏎ from the zone
 | A | Katka | Patron initiates application ⏎ from the zone
BLOCK 2 – Patron Does Not Complete the Form
SC-2A | A | Katka | 1st reminder to Patron (2 days) | Patron does not complete within 2 days → system sends 1st reminder | Patron receives 1st reminder email.
SC-2B | A | Katka | 2nd reminder to Patron (2+5 days) | Patron does not complete within 5 days after 1st → 2nd reminder to both | Patron and Parent notified.
SC-2C | A | Katka | Patron does not complete – patron change | 7 days after 2nd reminder → status changed, patron link invalid | Parent asked to find new patron. Both notified.
SC-2D | C | Katka | Patron declines the nomination | Patron clicks 'Decline' button → status auto-changes to 'Returned Application – … | Patron sends refusal. Parent must find new patron or application is cancelled.
BLOCK 3 – Parent Does Not Complete the Form
SC-3A | A | Klara | 1st reminder to Parent (2 days) | Parent does not complete within 2 days → 1st reminder | Parent receives 1st reminder.
SC-3B | A | Klara | 2nd reminder to Parent (2+5 days) | No completion 5 days after 1st → 2nd reminder to both | Parent and Patron notified.
SC-3C | A | Klara | Application cancelled (timeout) | 7 days after 2nd reminder → application auto-cancelled | Both parties receive cancellation.
BLOCK 4 – Application Review by Front Coordinator
SC-4A | A | Klara | Application complete – sent to Risk | Both forms received → coordinator checks → supplier contacted → sent to Risk | Status: Scoring Control.
SC-4B | A | Klara | Application incomplete – returned to parent | Coordinator finds missing info → returns to Parent → reminders → re-check | Parent notified to complete.
SC-4C | B | KLara | Application rejected (Out of Scope) | Application does not meet conditions → coordinator rejects | Both parties notified.
BLOCK 5 – Risk Management
SC-5A | A | Katka | Low Risk – approved by Coordinator | Score > 30, no -1 → Coordinator approves directly | Status: Scoring OK.
SC-5B | A | Katka | Risk Manager approves (Scoring OK) | Risk checks parent, patron, donation, supplier → approves | Both zones show Approved.
SC-5C | A | Katka | Risk Manager rejects (Scoring KO) | Risk finds disqualifying info → rejects | Both parties notified.
SC-5D | A | Katka | Risk requests additional information | Risk finds missing info → requests via coordinator → parent provides → re-review | Parent receives request. Reminders if needed.
BLOCK 6 – Change of Patron
SC-6A | B | Katka | New patron found and completes form | Parent enters new patron → new patron fills form → back to review | Application returns to Under Review.
SC-6B | B | Katka | New patron does not complete – cancelled | New patron misses all 3 deadlines → application cancelled | Both parties receive cancellation.
SC-6C | B | Katka | Parent does not provide new patron info | Parent misses all 3 deadlines to enter new patron → cancelled | Application cancelled.
BLOCK 7 – Voluntary Cancellation
SC-7A | C | Klara | Parent or Patron requests cancellation | Party sends request by email → coordinator cancels manually | Parent notified. Application cancelled.
SC-7A (updated) |  |  | Voluntary cancellation – Parent only | Only Parent can initiate voluntary cancellation directly. Patron can only do so … | Application cancelled. Parent notified.
BLOCK 8 – Back Office (After Collection)
SC-8A | A | Klara | Collection 100% – full flow to closure | Collection complete → contract → signature → payment → feedback → closed | Application closed with status Closed.
SC-8B | A | Klara | Parent does not sign contract | Contract sent, 3 deadlines missed → non-cooperative, donation reallocated | Story cancelled. Donation reallocated.
SC-8C | A | Klara | Collection partially fulfilled (1–99%) | Partial collection → coordinator contacts parent → decision → close or reallocat… | Closed – Partial Fulfillment or reallocated.
SC-8D | B | Klara | Collection 0% unfulfilled | 0% raised → reservation cancelled, story cancelled, both notified | Story cancelled.
BLOCK 9 – CONTENT: Story Publication & Feedback
SC-9A | A | Katka | Story published successfully | Content Coordinator takes over story → checks materials → prepares → publishes o… | Story published. Status: Active Story. Both Parent and Patron notified.
SC-9B | C | Katka | Parent or Patron requests text/photo changes | After publication Parent or Patron requests corrections by email → Content Coord… | Story updated on website.
SC-9C | A | Katka | Parent provides feedback (via system or email) | After donation paid: Parent submits feedback via system or email → Content Coord… | Feedback sent to donors. Status: Feedback Sent.
SC-9D | A | Katka | Parent does not provide feedback – reminders & universal feedback | Parent doesn't submit feedback → 2 reminders (2 and 14+14 days) → non-cooperativ… | Universal feedback sent. Status: Non-cooperative. Noted in Risk for future appli…
BLOCK 10 – DONATIONS FLOW
SC-10A | A | Klara | Donation via website to specific story (Comgate) – completed | Donor selects story → fills mandatory data → completes payment via Comgate → Com… | Donation status: PAID. Donor receives confirmation email.
SC-10B | A | Klara | Donation via website to specific story (Comgate) – not completed (PENDING) | Donor starts payment but does not finish → status PENDING → Comgate sends comple… | Donor receives PENDING email. If not completed → CANCELLED notification.
SC-10C | A | Klara | Donation to collection account (Comgate) | Donor donates to general collection account → Comgate confirms → Operations Mana… | Donation PAID. Assigned to story by Operations Manager.
SC-10D | A | Klara | Donation via bank transfer | Donor makes bank transfer → enters email in recipient note → bank confirms via A… | Donation PAID. Donor receives confirmation if email provided.
SC-10E | A | Klara | Regular donation (standing order – bank or card) | Donor sets up regular bank standing order or regular card payment via web → dona… | Recurring donations tracked. Donor can cancel via donor zone.
SC-10F | C | Klara | Gift voucher (Dobrošek) – purchase and redemption | Donor buys voucher (dobrošek) via web/Comgate → donor or recipient redeems it → … | Donation PAID. Donor and recipient receive confirmation.
SC-10G | C | Klara | Donation confirmation (certificate) | Donor generates confirmation from their zone OR requests by email → INFO Coordin… | Confirmation sent to donor.
BLOCK 11 – USER ZONE & ACCOUNT MANAGEMENT
SC-11A | A | Katka | Automatic account creation (Parent Zone) | Parent submits application form with email → system automatically creates Parent… | Account created. Parent can log in and track application status.
SC-11B | A | Katka | Patron Zone account activation (first-time Patron) | Patron submits form for the first time → system sends activation email → Patron … | Activation email received. Account activated. Patron can log in.
SC-11C | A | Katka | Status notifications visible in Parent Zone | At each process step the correct status message is displayed in the Parent Zone … | Each status change visible correctly in Parent Zone without delay.
SC-11D | A | Katka | Status notifications visible in Patron Zone | At each process step the correct status message is displayed in the Patron Zone. | Each status change visible correctly in Patron Zone without delay.
SC-11E | A | Katka | Mautic integration – email notifications sent via Mautic | System triggers Mautic to send emails at defined steps (reminders, confirmations… | Emails sent via Mautic on time. Open rates logged in Mautic dashboard.

### SHEET: SC-1A  (18 řádků)
SC-1A  |  Parent Initiates Application
🎯  Parent fills the application form first on the website; system then sends a l…
📌  Preconditions: Website accessible. Patron email address is known and already …
# | Role | Action / Step to Test | Expected Result | Email ⏎ Parent | Notification ⏎ Parent | Email ⏎ Patron | Notification ⏎ Patron | Status ⏎ in System | Result | Notes / Comments | Source / Notification Notes
1.0 | Parent | Opens the website and navigates to the application/request form | Application form loads correctly without errors | NO | NO | NO | NO | X
2.0 | Parent | Fills in personal information: full name, email, phone, address | All fields accept valid input; mandatory fields marked clearly | NO | NO | NO | NO | X
3.0 | Parent | Fills in child's information: name, date of birth, relationship to child | Child fields filled; form validates age and relationship | NO | NO | NO | NO | X
4.0 | Parent | Writes the story / description of the child's need and requested donation | Text field accepts input; character limit (if any) shown | NO | NO | NO | NO | X
5.0 | Parent | Selects type of donation / gift requested | Selection dropdown or list works correctly | NO | NO | NO | NO | X
6.0 | Parent | Uploads mandatory documents: valid ID + birth certificate or custody document | Upload works for PDF/JPG; system shows file names after upload | NO | NO | NO | NO | X
7.0 | Parent | Reviews the completed form before submission | Summary/review page displays all entered data correctly | NO | NO | NO | NO | X
8.0 | Parent | Submits the form | Submit button works; no error messages shown | YES | YES | NO | YES | waiting_for_patron
9.0 | System | Displays a 'Thank You / Confirmation' page after submission | Confirmation page appears immediately after submit | YES | YES | NO | YES | waiting_for_patron
10.0 | System | Sends confirmation email to Parent (application received, awaiting Patron) | ✓ Email arrives in Parent's inbox within a few minutes | YES | YES | NO | YES | waiting_for_patron
11.0 | System | Sends email to Patron with a unique link to complete their part of the form | ✓ Email arrives in Patron's inbox with working link | YES | YES | NO | YES | waiting_for_patron
12.0 | System | Creates the application in the backend (connects both forms) | Application record visible in system / BE | NO | NO | NO | NO | X
13.0 | System | Status set to 'Waiting for Patron Application' in Parent Zone | Parent logs in → zone shows correct status | NO | NO | NO | NO | X
14.0 | System | Status set to 'Complete the application' in Patron Zone | Patron logs in → zone shows action required | NO | NO | NO | NO | X

### SHEET: SC-1B  (18 řádků)
SC-1B  |  Patron Initiates Application
🎯  Patron fills the Patron form first on the website; system then sends a link t…
📌  Preconditions: Website accessible. Parent (legal guardian) email is linked to…
# | Role | Action / Step to Test | Expected Result | Email ⏎ Parent | Notification ⏎ Parent | Email ⏎ Patron | Notification ⏎ Patron | Status ⏎ in System | Result | Notes / Comments | Source / Notification Notes
1.0 | Patron | Opens the website and navigates to the Patron application form | Patron form loads correctly | NO | NO | NO | NO | X
2.0 | Patron | Fills in Patron information: name/organisation, email, phone, role | All fields accept valid input; mandatory fields marked | NO | NO | NO | NO | X
3.0 | Patron | Fills in information about the child to be supported | Child section of the form filled correctly | NO | NO | NO | NO | X
4.0 | Patron | Writes their part of the story / justification for the donation | Text area accepts input | NO | NO | NO | NO | X
5.0 | Patron | Reviews the form before submission | All data visible in review/summary | NO | NO | NO | NO | X
6.0 | Patron | Submits the form | Submit works; no errors | NO | NO | NO | NO | X
7.0 | System | Displays 'Thank You / Confirmation' page to Patron after submission | Confirmation page appears immediately | NO | YES | YES | YES | waiting_for_fundraiser
8.0 | System | Sends confirmation email to Patron (form received) | ✓ Email arrives in Patron's inbox | NO | YES | YES | YES | waiting_for_fundraiser
9.0 | System | If it is the Patron's FIRST application: sends account activation email for Patr… | ✓ Activation email arrives with working activation link | NO | YES | YES | YES | waiting_for_fundraiser
10.0 | Patron | Clicks the activation link and activates their account in the Patron Zone | Account activation successful; Patron can log in to zone | NO | YES | YES | YES | waiting_for_fundraiser
11.0 | System | Sets application status to 'Waiting for Parent Application' | Status visible in Patron Zone | NO | YES | YES | YES | waiting_for_fundraiser
12.0 | System | Sends email to Parent with a unique link to complete their part | ✓ Email arrives in Parent's inbox with working link | NO | YES | YES | YES | waiting_for_fundraiser
13.0 | System | Application appears in Patron Zone with status 'Awaiting Legal Guardian' | Patron logs in → zone shows correct status | NO | YES | YES | YES | waiting_for_fundraiser
14.0 | System | Application appears in Parent Zone with status 'Complete the application' | Parent logs in → zone shows action required | NO | NO | NO | NO | X

### SHEET: SC-2A  (10 řádků)
SC-2A  |  1st Reminder to Patron – 2 Days
🎯  Patron received the form link but did not complete it within 2 days. System s…
📌  Preconditions: SC-1A or SC-1B completed. Patron has NOT submitted their form.…
# | Role | Action / Step to Test | Expected Result | Email ⏎ Parent | Notification ⏎ Parent | Email ⏎ Patron | Notification ⏎ Patron | Status ⏎ in System | Result | Notes / Comments | Source / Notification Notes
1.0 | System | Detects that Patron has not completed the form within 2 days of receiving the li… | System timer triggers correctly after 2 days | NO | NO | YES | YES | reminder_1_patron
2.0 | System | Automatically sends 1st reminder email to Patron with the original link | ✓ Reminder email arrives in Patron's inbox with working link | NO | NO | YES | YES | reminder_1_patron
3.0 | System | Changes status to 'Awaiting Patron Application – 1st Reminder' | Status updated in system / BE | NO | NO | YES | YES | reminder_1_patron
4.0 | Patron Zone | Shows 'Complete the application' with reminder indicator | Patron logs in → reminder notice visible | NO | NO | YES | YES | reminder_1_patron
5.0 | Parent Zone | Shows 'Awaiting Patron' – no change triggered to Parent | Parent logs in → status unchanged, no new notification | NO | NO | YES | YES | reminder_1_patron
6.0 | Parent | Does NOT receive a reminder email at this step | Parent's inbox: no new email at 1st reminder stage | NO | NO | YES | YES | reminder_1_patron

### SHEET: SC-2B  (11 řádků)
SC-2B  |  2nd Reminder to Patron – 2+5 Days
🎯  Patron did not complete after 1st reminder. System sends 2nd reminder to Patr…
📌  Preconditions: SC-2A completed. 5 more calendar days have passed without Patr…
# | Role | Action / Step to Test | Expected Result | Email ⏎ Parent | Notification ⏎ Parent | Email ⏎ Patron | Notification ⏎ Patron | Status ⏎ in System | Result | Notes / Comments | Source / Notification Notes
1.0 | System | Detects that Patron has not completed within 5 days after 1st reminder | System timer triggers correctly | YES | YES | YES | YES | reminder_2_patron
2.0 | System | Automatically sends 2nd reminder email to Patron with the link | ✓ 2nd reminder arrives in Patron's inbox | YES | YES | YES | YES | reminder_2_patron
3.0 | System | Also sends notification email to Parent (Patron still hasn't completed) | ✓ Parent receives notification email | YES | YES | YES | YES | reminder_2_patron
4.0 | System | Changes status to 'Awaiting Patron Application – 2nd Reminder' | Status updated in both zones | YES | YES | YES | YES | reminder_2_patron
5.0 | Patron Zone | Shows 'Complete the application' with 2nd reminder indicator | Patron logs in → 2nd reminder visible | YES | YES | YES | YES | reminder_2_patron
6.0 | Parent Zone | Shows 'Awaiting Patron' with notification | Parent logs in → updated status visible | YES | YES | YES | YES | reminder_2_patron
7.0 | KAM | May manually contact / activate Patron if lead volume is low (optional step) | KAM contacts Patron by phone or email to encourage completion | NO | NO | NO | NO | X

### SHEET: SC-2C  (11 řádků)
SC-2C  |  Patron Does Not Complete – Patron Change Requested
🎯  Patron did not complete even after 2nd reminder (7 days passed). System reque…
📌  Preconditions: SC-2B completed. 7 more calendar days have passed without Patr…
# | Role | Action / Step to Test | Expected Result | Email ⏎ Parent | Notification ⏎ Parent | Email ⏎ Patron | Notification ⏎ Patron | Status ⏎ in System | Result | Notes / Comments | Source / Notification Notes
1.0 | System | Detects that Patron has not completed within 7 days after 2nd reminder | System timer triggers correctly | YES | YES | YES | YES | returned_new_patron
2.0 | System | Changes status to 'Returned Application (New Patron)' | Status updated in backend | YES | YES | YES | YES | returned_new_patron
3.0 | System | Original Patron's link to complete the application becomes INVALID | Patron tries to open old link → error/expired message shown | YES | YES | YES | YES | returned_new_patron
4.0 | System | Sends email to Parent asking to find and enter a new Patron's contact info | ✓ Parent receives email with instructions to provide new patron | YES | YES | YES | YES | returned_new_patron
5.0 | System | Sends notification email to original Patron (application cannot proceed) | ✓ Original Patron receives rejection/return notification | YES | YES | YES | YES | returned_new_patron
6.0 | Parent Zone | Shows 'Find a New Patron' – parent sees action required | Parent logs in → action button / message visible | YES | YES | YES | YES | returned_new_patron
7.0 | Patron Zone | Shows 'Application Rejected' for original Patron | Original Patron logs in → rejected status visible | YES | YES | YES | YES | returned_new_patron

### SHEET: SC-2D  (17 řádků)
SC-2D  |  Patron Actively Declines the Nomination
🎯  Patron clicks the "Decline" button on the website. System automatically chang…
📌  Preconditions: Application exists. Patron has received the form link. Patron …
# | Role | Action / Step to Test | Expected Result | Email ⏎ Parent | Notification ⏎ Parent | Email ⏎ Patron | Notification ⏎ Patron | Status ⏎ in System | Result | Notes / Comments | Source / Notification Notes
1.0 | Patron | Receives the form link and opens it in the browser or Patron Zone | Form link opens correctly; Patron can see the application form | YES | YES | YES | YES | waiting_for_patron
2.0 | Patron | Clicks the 'Decline' button on the website (available in the form or Patron Zone… | Decline button is clearly visible and clickable; no accidental trigger possible | YES | YES | YES | YES | waiting_for_patron
3.0 | System | Automatically changes application status to 'Returned Application – New Patron' | Status updated immediately in the backend | YES | YES | YES | YES | returned_new_patron
4.0 | System | Original Patron's link to the form becomes invalid immediately after decline | Patron tries to reopen the link → error or 'link expired' message shown | YES | YES | YES | YES | returned_new_patron
5.0 | System | Sends email notification to Parent requesting them to provide a new Patron's con… | ✓ Parent receives email with instructions to nominate a new Patron | YES | YES | YES | YES | returned_new_patron
6.0 | Parent Zone | Displays a notification: action required – provide new Patron contact info | Notification visible in Parent Zone without requiring page refresh | YES | YES | YES | YES | returned_new_patron
7.0 | Patron Zone | Shows 'Application Rejected' (or equivalent) for the original Patron | Original Patron logs in → sees that their involvement has ended | YES | YES | YES | YES | returned_new_patron
8.0 | Parent | Enters the new Patron's name and email address in the Parent Zone | Input fields available and accept valid data | YES | YES | YES | YES | waiting_for_patron
9.0 | System | Sends form link to the new Patron by email | ✓ New Patron receives email with working link | YES | YES | YES | YES | waiting_for_patron
10.0 | System | If Parent does NOT provide new Patron info within 2 days → sends 1st reminder | ✓ 1st reminder sent to Parent | YES | YES | YES | YES | returned_new_patron
11.0 | System | If no response within 5 days after 1st reminder → sends 2nd reminder | ✓ 2nd reminder sent to Parent | YES | YES | YES | YES | returned_new_patron
12.0 | System | If no response within 7 days after 2nd reminder → cancels the application | Status: Application Cancelled (Time Out). Both parties notified. | YES | YES | YES | YES | canceled_timeout
13.0 | New Patron | Completes the Patron form → application resumes normal flow (→ SC-4A) | Application status returns to 'Under Review'. Coordinator FRONT takes over. | YES | YES | YES | YES | to_check

### SHEET: SC-3A  (9 řádků)
SC-3A  |  1st Reminder to Parent – 2 Days
🎯  Parent received the form link but did not complete it within 2 days. System s…
📌  Preconditions: SC-1B or coordination scenario where Patron filled first. Pare…
# | Role | Action / Step to Test | Expected Result | Email ⏎ Parent | Notification ⏎ Parent | Email ⏎ Patron | Notification ⏎ Patron | Status ⏎ in System | Result | Notes / Comments | Source / Notification Notes
1.0 | System | Detects that Parent has not completed the form within 2 days | System timer triggers correctly | YES | YES | NO | YES | reminder_1_fundraiser
2.0 | System | Automatically sends 1st reminder email to Parent with the link | ✓ Reminder email arrives in Parent's inbox | YES | YES | NO | YES | reminder_1_fundraiser
3.0 | System | Changes status to 'Waiting to be Completed – 1st Reminder' | Status updated in system | YES | YES | NO | YES | reminder_1_fundraiser
4.0 | Parent Zone | Shows reminder – action required | Parent logs in → reminder notice visible | YES | YES | NO | YES | reminder_1_fundraiser
5.0 | Patron Zone | No change – Patron does NOT receive notification at this step | Patron logs in → status unchanged | YES | YES | NO | YES | reminder_1_fundraiser

### SHEET: SC-3B  (10 řádků)
SC-3B  |  2nd Reminder to Parent – 2+5 Days
🎯  Parent did not complete after 1st reminder. System sends 2nd reminder to Pare…
📌  Preconditions: SC-3A completed. 5 more calendar days passed without Parent co…
# | Role | Action / Step to Test | Expected Result | Email ⏎ Parent | Notification ⏎ Parent | Email ⏎ Patron | Notification ⏎ Patron | Status ⏎ in System | Result | Notes / Comments | Source / Notification Notes
1.0 | System | Detects no completion 5 days after 1st reminder | System timer triggers correctly | YES | YES | YES | YES | reminder_2_fundraiser
2.0 | System | Sends 2nd reminder email to Parent (Application inciated by Parent, Patron unkno… | ✓ 2nd reminder arrives in Parent's inbox | YES | YES | YES | YES | reminder_2_fundraiser
3.0 | System | Sends notification to Parent (Application inicated by Patron) | ✓ 2nd reminder arrives in Parent's inbox | YES | YES | YES | YES | reminder_2_fundraiser
4.0 | System | Changes status to 'Waiting to be Completed – 2nd Reminder' | Status updated in both zones | YES | YES | YES | YES | reminder_2_fundraiser
5.0 | Parent Zone | Shows 2nd reminder – action required | Parent logs in → 2nd reminder visible | YES | YES | YES | YES | reminder_2_fundraiser
6.0 | Patron Zone | Shows updated status with notification | Patron logs in → updated status visible | YES | YES | YES | YES | reminder_2_fundraiser

### SHEET: SC-3C  (10 řádků)
SC-3C  |  Application Cancelled – Parent Timeout
🎯  Parent did not complete after 2nd reminder (7 more days). Application is auto…
📌  Preconditions: SC-3B completed. 7 more calendar days have passed without Pare…
# | Role | Action / Step to Test | Expected Result | Email ⏎ Parent | Notification ⏎ Parent | Email ⏎ Patron | Notification ⏎ Patron | Status ⏎ in System | Result | Notes / Comments | Source / Notification Notes
1.0 | System | Detects no completion 7 days after 2nd reminder | System timer triggers correctly | YES | YES | YES | YES | canceled_timeout
2.0 | System | Automatically cancels the application | Application status changes to Cancelled in backend | YES | YES | YES | YES | canceled_timeout
3.0 | System | Sends cancellation email to Parent | ✓ Parent receives cancellation notification | YES | YES | YES | YES | canceled_timeout
4.0 | System | Sends cancellation notification to Patron | ✓ Patron receives notification | YES | YES | YES | YES | canceled_timeout
5.0 | Parent Zone | Shows 'Application Cancelled (Time Out)' | Parent logs in → cancelled status visible | YES | YES | YES | YES | canceled_timeout
6.0 | Patron Zone | Shows 'Application Cancelled (Time Out)' | Patron logs in → cancelled status visible | YES | YES | YES | YES | canceled_timeout

### SHEET: SC-4A  (17 řádků)
SC-4A  |  Application Complete – Sent to Risk
🎯  Both forms submitted and complete. Coordinator FRONT reviews, contacts suppli…
📌  Preconditions: Both Parent and Patron have submitted their forms. Application…
# | Role | Action / Step to Test | Expected Result | Email ⏎ Parent | Notification ⏎ Parent | Email ⏎ Patron | Notification ⏎ Patron | Status ⏎ in System | Result | Notes / Comments | Source / Notification Notes
1.0 | System | Connects both forms and creates the application record | Application created in backend with status 'To Check' (Ke kontrole) | NO | NO | NO | NO | X
2.0 | System | Sends email notification to both Parent and Patron (application received) | ✓ Both receive confirmation emails | NO | NO | NO | NO | X
3.0 | Coord FRONT | Takes over the application manually in the backend system | Application status changes to 'Application Processing' | NO | NO | NO | NO | X
4.0 | Coord FRONT | Checks all mandatory personal information of Parent and child | All required fields present and valid | NO | NO | NO | NO | X
5.0 | Coord FRONT | Verifies all mandatory attachments (ID, birth/custody certificate, etc.) | All required documents are attached and legible | NO | NO | NO | NO | X
6.0 | Coord FRONT | Reads and verifies the full story text is present and complete | Story text meets minimum requirements | NO | NO | NO | NO | X
7.0 | Coord FRONT | Checks Patron information and their part of the story | Patron section complete and consistent with Parent's story | NO | NO | NO | NO | X
8.0 | Coord FRONT | Contacts supplier of the requested gift/service (email or phone) | Supplier is reachable and cooperative | NO | NO | NO | NO | X
9.0 | Supplier | Provides price quote and confirms cooperation and terms | Price quote received and attached to application | NO | NO | NO | NO | X
10.0 | Coord FRONT | Sends application to Risk department for approval | Application forwarded to Risk in system | NO | YES | NO | YES | scoring
11.0 | System | Changes status to 'Scoring Control' (Scoring kontrola) | Status visible in both zones | NO | YES | NO | YES | scoring
12.0 | Parent Zone | Shows 'Application in Process / Scoring Control' | Parent logs in → correct status visible | NO | YES | NO | YES | scoring
13.0 | Patron Zone | Shows 'Application in Process / Scoring Control' | Patron logs in → correct status visible | NO | YES | NO | YES | scoring

### SHEET: SC-4B  (17 řádků)
SC-4B  |  Application Incomplete – Returned to Parent
🎯  Coordinator finds missing information or documents. Application returned to P…
📌  Preconditions: Both forms submitted but coordinator finds issues during revie…
# | Role | Action / Step to Test | Expected Result | Email ⏎ Parent | Notification ⏎ Parent | Email ⏎ Patron | Notification ⏎ Patron | Status ⏎ in System | Result | Notes / Comments | Source / Notification Notes
1.0 | System | Application created with status 'To Check'. Emails sent to both parties | Both notified of application creation | NO | NO | NO | NO | X
2.0 | Coord FRONT | Takes over and reviews the application | Application in 'Application Processing' status | NO | NO | NO | NO | X
3.0 | Coord FRONT | Identifies missing information or attachments in Parent's part | Missing items documented in system notes | YES | YES | NO | NO | waiting
4.0 | Coord FRONT | Returns the application to Parent for completion | Status changes to 'Waiting to be Completed' | YES | YES | NO | NO | waiting
5.0 | System | Sends email to Parent requesting completion with details of what is missing | ✓ Parent receives email listing missing items | YES | YES | NO | NO | waiting
6.0 | Parent Zone | Shows 'Waiting to be Completed' with action required | Parent logs in → action required visible | NO | NO | NO | NO | X
7.0 | System | If Parent does not complete within 2 days → sends 1st reminder | ✓ 1st reminder arrives after 2 days | YES | YES | NO | NO | waiting
8.0 | System | If no completion 5 days after 1st reminder → sends 2nd reminder | ✓ 2nd reminder arrives; Patron also notified | YES | YES | NO | NO | waiting
9.0 | Parent | Completes missing information and/or uploads missing documents | Application updated with new data | YES | YES | NO | NO | waiting
10.0 | System | Status changes to 'Application Completed by Parent' | Status updated in system | NO | NO | NO | NO | X
11.0 | Coord FRONT | Reviews the updated application again | All required information now present | NO | NO | NO | NO | X
12.0 | Coord FRONT | If complete → proceeds to SC-4A (send to Risk) | Application forwarded to Risk | NO | NO | NO | NO | X
13.0 | System | If NOT completed within 7 days after 2nd reminder → application auto-cancelled | Status: Application Cancelled (Time Out). Both notified. | YES | YES | NO | NO | canceled_timeout

### SHEET: SC-4C  (12 řádků)
SC-4C  |  Application Rejected – Out of Scope
🎯  Application does not meet project conditions. Coordinator FRONT rejects it ma…
📌  Preconditions: Both forms submitted. Coordinator reviews and determines appli…
# | Role | Action / Step to Test | Expected Result | Email ⏎ Parent | Notification ⏎ Parent | Email ⏎ Patron | Notification ⏎ Patron | Status ⏎ in System | Result | Notes / Comments | Source / Notification Notes
1.0 | Coord FRONT | Reviews the application and checks against project eligibility conditions | All conditions documented and checked | NO | NO | NO | NO | X
2.0 | Coord FRONT | Determines the application does not meet project conditions (e.g., child too old… | Specific reason for rejection documented in notes | YES | YES | YES | YES | out_of_scope
3.0 | Coord FRONT | Manually rejects the application in the backend system | Rejection action performed in BE | YES | YES | YES | YES | out_of_scope
4.0 | System | Changes status to 'Out of Scope' | Status updated in backend | YES | YES | YES | YES | out_of_scope
5.0 | System | Sends rejection email to Parent with notification | ✓ Parent receives rejection email | YES | YES | YES | YES | out_of_scope
6.0 | System | Sends rejection notification to Patron | ✓ Patron receives notification | YES | YES | YES | YES | out_of_scope
7.0 | Parent Zone | Shows 'Out of Scope' | Parent logs in → Out of Scope status visible | YES | YES | YES | YES | out_of_scope
8.0 | Patron Zone | Shows 'Out of Scope' | Patron logs in → Out of Scope status visible | YES | YES | YES | YES | out_of_scope

### SHEET: SC-5A  (18 řádků)
SC-5A  |  Low Risk – Approved by Coordinator
🎯  Application scores above 30 in Low Risk system. Senior Coordinator (>6 months…
📌  Preconditions: Application at Risk stage. Risk Manager has set Low Risk crite…
# | Role | Action / Step to Test | Expected Result | Email ⏎ Parent | Notification ⏎ Parent | Email ⏎ Patron | Notification ⏎ Patron | Status ⏎ in System | Result | Notes / Comments | Source / Notification Notes
1.0 | Risk Mgr | Sets Low Risk criteria – point scoring system (done once, not per application) | Scoring criteria configured in system | NO | NO | NO | NO | X
2.0 | Risk Mgr | Sets Low Risk price threshold on the Scoring Risks Card | Price level configured | NO | NO | NO | NO | X
3.0 | System | Automatically evaluates Low Risk scoring for this application | System calculates total score | NO | NO | NO | NO | X
4.0 | System | Checks: Patron email ≠ Parent email (if same: score –1) | Email comparison performed | NO | NO | NO | NO | X
5.0 | System | Checks: Patron status – Known/Well Known (+10), Unknown (0), Blacklist (–1) | Patron status scoring applied | NO | NO | NO | NO | scoring
6.0 | System | Checks: Parent status – Known (+10), Unknown (0), Blacklist (–1) | Parent status scoring applied | NO | NO | NO | NO | scoring
7.0 | System | Checks: Price of donation – ≤ 10,000 CZK/400 EUR (+10), above (0) | Price scoring applied | NO | NO | NO | NO | X
8.0 | System | Checks: Payment destination – to Supplier (0), to Parent's account (–1) | Payment type scoring applied | NO | NO | NO | NO | X
9.0 | System | Calculates total score. If any single criterion = –1 → total forced to –1 | Total score calculated correctly | NO | NO | NO | NO | X
10.0 | Coord FRONT | Reviews Low Risk criteria and verifies score is above 30 and no –1 present | Score confirmed > 30, no disqualifying criteria | NO | NO | NO | NO | X
11.0 | Coord FRONT | Approves the application directly (without sending to Risk Manager) | Approval action performed in system | NO | NO | NO | NO | scoring_ok
12.0 | System | Changes status to 'Scoring OK' | Status updated | NO | NO | NO | NO | scoring_ok
13.0 | Parent Zone | Shows 'Your application has been approved' | Parent logs in → approved message visible | NO | NO | NO | NO | scoring_ok
14.0 | Patron Zone | Shows 'Application Approved' | Patron logs in → approved message visible | NO | NO | NO | NO | scoring_ok

### SHEET: SC-5B  (31 řádků)
SC-5B  |  Risk Manager Approves – Scoring OK
🎯  Risk Manager performs full review of Parent, Patron, donation subject, and su…
📌  Preconditions: Application at Risk stage (score < 30 or escalated by Coordina…
# | Role | Action / Step to Test | Expected Result | Email ⏎ Parent | Notification ⏎ Parent | Email ⏎ Patron | Notification ⏎ Patron | Status ⏎ in System | Result | Notes / Comments | Source / Notification Notes
1.0 | Risk Mgr | Takes over application; opens Scoring Card in system | Application visible with status 'Scoring Control' | NO | NO | NO | NO | scoring
2.0 | Risk Mgr | Checks attached documents: Parent's valid ID (ID card/passport) | Valid and current ID document present | NO | NO | NO | NO | X
3.0 | Risk Mgr | Checks: birth certificate or custody document identifying child | Document present and matches data in application | NO | NO | NO | NO | X
4.0 | Risk Mgr | Checks: Parent's email is not suspicious (not Patron's domain, not another perso… | Email check passed | NO | NO | NO | NO | X
5.0 | Risk Mgr | Checks: Parent's blacklist status in system | Parent not on blacklist | NO | NO | NO | NO | scoring
6.0 | Risk Mgr | Checks: Parent's previous applications (all closed? any non-cooperative?) | Previous applications reviewed | NO | NO | NO | NO | X
7.0 | Risk Mgr | Checks: Consistency between current and previous stories | No contradictions found | NO | NO | NO | NO | X
8.0 | Risk Mgr | Performs external check of Parent (Google, social media, ChatGPT) | External check completed, no red flags | NO | NO | NO | NO | X
9.0 | Risk Mgr | Checks Cribis + Insolvency Register for Parent (if gift requires it, e.g. laptop… | No enforcement or insolvency found (if applicable) | NO | NO | NO | NO | X
10.0 | Risk Mgr | Checks single-parent (samoživitel) status if declared | Status verified via CRM and social media | NO | NO | NO | NO | scoring
11.0 | Risk Mgr | Checks: Patron's blacklist status | Patron not on blacklist | NO | NO | NO | NO | scoring
12.0 | Risk Mgr | Checks: Previous findings about Patron in Risk notes | No negative history found | NO | NO | NO | NO | X
13.0 | Risk Mgr | Verifies relationship between Patron and Parent (not family/partner) | Relationship is appropriate (not disqualifying) | NO | NO | NO | NO | X
14.0 | Risk Mgr | Checks: Patron is NOT also the Supplier | Patron and supplier are different entities | NO | NO | NO | NO | X
15.0 | Risk Mgr | Performs external check of Patron (Google, social media, LinkedIn) | External check passed | NO | NO | NO | NO | X
16.0 | Risk Mgr | Checks Cribis for Patron (debt, enforcement, insolvency) | No serious issues found | NO | NO | NO | NO | X
17.0 | Risk Mgr | Reviews donation subject: description, price, age-appropriateness | Donation is valid, age-appropriate, within rules | NO | NO | NO | NO | X
18.0 | Risk Mgr | Verifies price quote is attached and matches described donation | Price quote present and consistent | NO | NO | NO | NO | X
19.0 | Risk Mgr | Checks: donation requires medical documentation? (e.g. therapy, medical device) | Medical docs present if required | NO | NO | NO | NO | X
20.0 | Risk Mgr | Verifies supplier: internal check (known/verified supplier?) | Supplier known and reliable | NO | NO | NO | NO | X
21.0 | Risk Mgr | Verifies supplier: external check via Cribis (no insolvency/enforcement) | Cribis check passed | NO | NO | NO | NO | X
22.0 | Risk Mgr | Checks supplier is not economically linked to Parent or Patron | No conflict of interest found | NO | NO | NO | NO | X
23.0 | Risk Mgr | Approves the application – sets status to Scoring OK | Approval recorded in system | NO | NO | NO | NO | scoring_ok
24.0 | System | Status changes to 'Scoring OK' | Status updated in both zones | NO | NO | NO | NO | scoring_ok
25.0 | Parent Zone | Shows 'Your application has been approved' | Approval message visible | NO | NO | NO | NO | scoring_ok
26.0 | Patron Zone | Shows 'Application Approved' | Approval message visible | NO | NO | NO | NO | scoring_ok
27.0 | System | NO emails sent to Parent or Patron at approval stage | Parent inbox: no email. Patron inbox: no email. | NO | NO | NO | NO | X

### SHEET: SC-5C  (11 řádků)
SC-5C  |  Risk Manager Rejects – Scoring KO
🎯  Risk Manager finds disqualifying information. Application is rejected.
📌  Preconditions: Application at Risk stage. Risk Manager has reviewed and found…
# | Role | Action / Step to Test | Expected Result | Email ⏎ Parent | Notification ⏎ Parent | Email ⏎ Patron | Notification ⏎ Patron | Status ⏎ in System | Result | Notes / Comments | Source / Notification Notes
1.0 | Risk Mgr | Reviews application and finds disqualifying information (blacklist, fraud indica… | Issue documented in Scoring Card notes | YES | YES | YES | YES | scoring_ko
2.0 | Risk Mgr | Rejects the application – sets status to Scoring KO | Rejection recorded in system | YES | YES | YES | YES | scoring_ko
3.0 | System | Changes status to 'Scoring KO' | Status updated in backend | YES | YES | YES | YES | scoring_ko
4.0 | System | Sends rejection email to Parent | ✓ Parent receives rejection notification | YES | YES | YES | YES | scoring_ko
5.0 | System | Sends rejection email to Patron | ✓ Patron receives rejection notification | YES | YES | YES | YES | scoring_ko
6.0 | Parent Zone | Shows 'Rejected' | Parent logs in → Rejected status visible | YES | YES | YES | YES | scoring_ko
7.0 | Patron Zone | Shows 'Rejected' | Patron logs in → Rejected status visible | YES | YES | YES | YES | scoring_ko

### SHEET: SC-5D  (18 řádků)
SC-5D  |  Risk Requests Additional Information
🎯  Risk Manager finds missing or unclear info. Requests completion via Coordinat…
📌  Preconditions: Application at Risk stage. Risk Manager cannot approve or reje…
# | Role | Action / Step to Test | Expected Result | Email ⏎ Parent | Notification ⏎ Parent | Email ⏎ Patron | Notification ⏎ Patron | Status ⏎ in System | Result | Notes / Comments | Source / Notification Notes
1.0 | Risk Mgr | Identifies missing or unclear information (document, explanation, or price quote… | Issue documented in Scoring Card | YES | YES | NO | NO | waiting
2.0 | Risk Mgr | Requests additional information via Coordinator FRONT (sets status 'Scoring – Wa… | Status updated; Coordinator notified | YES | YES | NO | NO | waiting
3.0 | Coord FRONT | Contacts Parent (or Patron/Supplier depending on case) to request missing items | Contact made by email or phone | YES | YES | NO | NO | waiting
4.0 | Coord FRONT | Returns application to Parent if Parent must complete info | Status: 'Waiting to be Completed' | YES | YES | NO | NO | waiting
5.0 | System | Sends email to Parent requesting additional documents/information | ✓ Parent receives request email | YES | YES | NO | NO | waiting
6.0 | System | Sends 1st reminder to Parent if no response within 2 days | ✓ 1st reminder sent | YES | YES | NO | NO | waiting_reminder_1
7.0 | System | Sends 2nd reminder to Parent if no response within 5 more days | ✓ 2nd reminder sent; Patron also notified | YES | YES | YES | NO | waiting_reminder_2
8.0 | Parent | Provides the requested additional documents or information | Documents/info uploaded or sent | YES | YES | NO | NO | refiled
9.0 | Coord FRONT | Adds/attaches the new information to the application in the system | Application updated | YES | YES | NO | NO | refiled
10.0 | System | Status changes back to 'Scoring Control' | Status updated | NO | YES | NO | YES | scoring
11.0 | Risk Mgr | Re-reviews the application with the new information | Full review repeated for relevant sections | YES | YES | NO | NO | refiled
12.0 | Risk Mgr | If information is sufficient → approves (→ SC-5B outcome) | Status: Scoring OK | NO | NO | NO | NO | scoring_ok
13.0 | Risk Mgr | If information is insufficient → rejects (→ SC-5C outcome) | Status: Scoring KO | YES | YES | YES | YES | scoring_ko
14.0 | System | If Parent does not respond within 7 days of 2nd reminder → application auto-canc… | Both parties notified. Status: Cancelled. | YES | YES | YES | YES | canceled_timeout

### SHEET: SC-6A  (18 řádků)
SC-6A  |  New Patron Found and Completes the Form
🎯  Risk or Coordinator requests patron change. Parent enters new patron. New pat…
📌  Preconditions: Status is 'Returned Application (New Patron)'. Original Patron…
# | Role | Action / Step to Test | Expected Result | Email ⏎ Parent | Notification ⏎ Parent | Email ⏎ Patron | Notification ⏎ Patron | Status ⏎ in System | Result | Notes / Comments | Source / Notification Notes
1.0 | System | Status is 'Returned Application (New Patron)'. Email sent to Parent to find a ne… | Parent has received the request | YES | YES | NO | YES | returned_new_patron
2.0 | Parent Zone | Shows 'Find a New Patron' – Parent sees action required | Parent logs in → message and input field visible | YES | YES | NO | YES | returned_new_patron
3.0 | System | Sends 1st reminder to Parent if no new patron info entered within 2 days | ✓ 1st reminder sent | YES | YES | NO | YES | returned_new_patron_reminder_1
4.0 | System | Sends 2nd reminder to Parent if no response within 5 more days | ✓ 2nd reminder sent | NO | NO | NO | NO | returned_new_patron_reminder_2
5.0 | Parent | Enters new Patron's contact information (name, email) in Parent Zone | New patron details entered successfully | YES | YES | NO | YES | waiting_for_patron
6.0 | System | Sends form link to new Patron by email | ✓ New Patron receives email with link | YES | YES | NO | YES | waiting_for_patron
7.0 | System | Status changes to 'Waiting for Patron Application' | Status updated in both zones | NO | NO | NO | NO | X
8.0 | New Patron | Opens the link and fills out the Patron form | Form loads and accepts input | YES | YES | NO | YES | waiting_for_patron
9.0 | New Patron | Uploads any required documents if applicable | Documents uploaded successfully | YES | YES | NO | YES | waiting_for_patron
10.0 | New Patron | Submits the Patron form | Submission successful; confirmation page shown | YES | YES | NO | YES | waiting_for_patron
11.0 | System | Sends confirmation email to new Patron | ✓ New Patron receives confirmation | YES | YES | NO | YES | waiting_for_patron
12.0 | System | Changes application status to 'Under Review' / 'To Check' | Status updated | YES | YES | YES | YES | to_check
13.0 | System | Sends notification to Parent that new Patron has completed the form | ✓ Parent notified | YES | YES | NO | YES | to_check
14.0 | Coord FRONT | Reviews the application with new Patron (SC-4A flow resumes) | Application back in coordinator review queue | YES | YES | NO | YES | to_check

### SHEET: SC-6B  (14 řádků)
SC-6B  |  New Patron Does Not Complete – Cancellation
🎯  New patron link was sent but new patron misses all 3 deadlines. Application i…
📌  Preconditions: SC-6A steps 1–6 completed. New Patron has received the link bu…
# | Role | Action / Step to Test | Expected Result | Email ⏎ Parent | Notification ⏎ Parent | Email ⏎ Patron | Notification ⏎ Patron | Status ⏎ in System | Result | Notes / Comments | Source / Notification Notes
1.0 | System | New Patron does not complete the form within 2 days | Timer triggers correctly | NO | NO | NO | NO | X
2.0 | System | Sends 1st reminder to new Patron | ✓ New Patron receives 1st reminder | NO | NO | YES | YES | reminder_1_patron
3.0 | System | New Patron does not complete within 5 days after 1st reminder | Timer triggers correctly | NO | NO | YES | YES | reminder_1_patron
4.0 | System | Sends 2nd reminder to new Patron; also notifies Parent | ✓ Both receive notifications | YES | YES | YES | YES | reminder_2_patron
5.0 | System | New Patron does not complete within 7 days after 2nd reminder | Timer triggers correctly | YES | YES | YES | YES | reminder_2_patron
6.0 | System | Cancels the application | Status: Application Cancelled (Time Out) | YES | YES | YES | YES | canceled_timeout
7.0 | System | Sends cancellation email to Parent | ✓ Parent receives cancellation | YES | YES | YES | YES | canceled_timeout
8.0 | System | Sends cancellation notification to Patron | ✓ Patron receives notification | YES | YES | YES | YES | canceled_timeout
9.0 | Parent Zone | Shows 'Application Cancelled (Time Out)' | Parent logs in → cancelled status visible | YES | YES | YES | YES | canceled_timeout
10.0 | Patron Zone | Shows 'Application Cancelled (Time Out)' | Patron logs in → cancelled status visible | YES | YES | YES | YES | canceled_timeout

### SHEET: SC-6C  (12 řádků)
SC-6C  |  Parent Does Not Provide New Patron Info – Cancellation
🎯  After patron change is requested, Parent fails to provide new patron contact …
📌  Preconditions: Status is 'Returned Application (New Patron)'. Parent has been…
# | Role | Action / Step to Test | Expected Result | Email ⏎ Parent | Notification ⏎ Parent | Email ⏎ Patron | Notification ⏎ Patron | Status ⏎ in System | Result | Notes / Comments | Source / Notification Notes
1.0 | System | Sends email to Parent requesting new patron contact info | ✓ Parent received the request | YES | YES | YES | YES | returned_new_patron
2.0 | System | Parent does not provide info within 2 days → sends 1st reminder | ✓ 1st reminder sent to Parent | YES | YES | NO | NO | returned_new_patron_reminder_1
3.0 | System | Parent does not respond within 5 days after 1st reminder → sends 2nd reminder | ✓ 2nd reminder sent to Parent | YES | YES | NO | NO | returned_new_patron_reminder_2
4.0 | System | Parent does not respond within 7 days after 2nd reminder → cancels application | Timer triggers; cancellation executed | YES | YES | YES | YES | canceled_timeout
5.0 | System | Sends cancellation email to Parent | ✓ Parent receives cancellation notification | YES | YES | YES | YES | canceled_timeout
6.0 | System | Sends cancellation notification to original Patron | ✓ Patron notified | YES | YES | YES | YES | canceled_timeout
7.0 | Parent Zone | Shows 'Application Cancelled (Time Out)' | Parent logs in → cancelled status visible | YES | YES | YES | YES | canceled_timeout
8.0 | Patron Zone | Shows 'Application Cancelled (Time Out)' | Patron logs in → cancelled status visible | YES | YES | YES | YES | canceled_timeout

### SHEET: SC-7A  (11 řádků)
SC-7A  |  Voluntary Cancellation by Parent or Patron
🎯  Parent or Patron decides to cancel the application voluntarily and contacts t…
📌  Preconditions: Application is active at any stage. Party decides they no long…
# | Role | Action / Step to Test | Expected Result | Email ⏎ Parent | Notification ⏎ Parent | Email ⏎ Patron | Notification ⏎ Patron | Status ⏎ in System | Result | Notes / Comments | Source / Notification Notes
1.0 | Parent/Patron | Sends cancellation request to the coordinator by email (to info@ or directly) | Request received by coordinator | NO | NO | NO | NO | X
2.0 | Coord FRONT | Receives the cancellation request | Request acknowledged | NO | NO | NO | NO | X
3.0 | Coord FRONT | Manually cancels the application in the backend system | Cancellation performed in BE | NO | NO | NO | NO | X
4.0 | System | Changes status to 'Application Cancelled' | Status updated in backend | YES | YES | YES | NO | canceled_by_user
5.0 | System | Sends cancellation confirmation email to Parent | ✓ Parent receives confirmation | YES | NO | NO | NO | canceled_by_user
6.0 | Parent Zone | Shows 'Application Cancelled' | Parent logs in → cancelled status visible | YES | YES | YES | NO | canceled_by_user
7.0 | Patron Zone | Shows 'Application Cancelled' | Patron logs in → cancelled status visible | YES | YES | YES | NO | canceled_by_user

### SHEET: SC-8A  (34 řádků)
SC-8A  |  Collection 100% Fulfilled – Full Flow to Closure
🎯  Collection reaches 100% of target. Full back-office process: contract, paymen…
📌  Preconditions: Application approved by Risk (Scoring OK). Fundraising collect…
# | Role | Action / Step to Test | Expected Result | Email ⏎ Parent | Notification ⏎ Parent | Email ⏎ Patron | Notification ⏎ Patron | Email ⏎ Donor | Notification ⏎ Donor | Status ⏎ in System | Result | Notes / Comments | Source / Notification Notes
1.0 | System | Collection ends – detects 100% of target amount reached | System identifies story as fulfilled | YES | YES | YES | YES | YES | YES | completed
2.0 | System | Changes status to 'successful story' | Status updated in both zones | YES | YES | YES | YES | NO | NO | completed
3.0 | System | Sends email to Parent: collection successful, next steps coming | ✓ Parent receives success email | YES | YES | YES | YES | NO | NO | completed
4.0 | System | Sends email to Patron: collection successful | ✓ Patron receives success email | YES | YES | YES | YES | NO | NO | completed
5.0 | Ops Mgr | Creates donation contract in the system for the fulfilled story | Contract created and visible in Parent zone | YES | YES | YES | YES | NO | NO | contract
6.0 | System | Status changes to 'Contract for Approval' | Status visible in zones | NO | NO | NO | NO | NO | NO | contract
7.0 | Ops Mgr / IT | Signs the contract and sends it to Parent for their signature | Contract sent to Parent | YES | YES | NO | YES | NO | NO | waiting_signature
8.0 | System | Status changes to 'Awaiting Signature' | Status visible in Parent Zone | YES | YES | NO | YES | NO | NO | waiting_signature
9.0 | System | Sends email to Parent with contract and signing instructions | ✓ Parent receives email with contract | YES | YES | NO | YES | NO | NO | waiting_signature
10.0 | Parent | Signs the contract – either digitally in the Parent Zone OR sends signed copy by… | Signature action performed | YES | YES | NO | YES | NO | NO | waiting_signature
11.0 | System | Status changes to 'Contract Signed by Applicant' | Status updated | YES | YES | NO | NO | NO | NO | contract_signed
12.0 | System | Sends confirmation email to Parent (contract received) | ✓ Parent receives confirmation | YES | YES | NO | NO | NO | NO | contract_signed
13.0 | Coord BACK | Confirms order with supplier and requests accounting document (invoice) | Supplier receives order confirmation | NO | NO | NO | NO | NO | NO | waiting_for_bill
14.0 | System | Status changes to 'Waiting for Accounting Document' | Status visible in Parent Zone | NO | NO | NO | NO | NO | NO | waiting_for_accounting document
15.0 | Supplier | Sends invoice / accounting document to Coordinator BACK | Invoice received by BACK team | NO | NO | NO | NO | NO | NO | waiting_for_accounting document
16.0 | Coord BACK | Checks invoice for correctness (amounts, supplier info, service description) | Invoice is correct | NO | NO | NO | NO | NO | NO | waiting_for_accounting document
17.0 | Coord BACK | Sends invoice to Financial Manager via system | Invoice forwarded | NO | NO | NO | NO | NO | NO | waiting_for_accounting document
18.0 | System | Status changes to 'Donation Payment' | Status updated in zones | NO | NO | NO | NO | NO | NO | gift_payment
19.0 | Fin Mgr | Processes the payment through the banking system | Payment executed successfully | NO | NO | NO | NO | NO | NO | gift_payment
20.0 | System | Status changes to 'Donation Paid' | Status updated in zones | NO | YES | NO | YES | NO | NO | gift_paid
21.0. | Coord BACK | Requests final accounting document from supplier or Parent | Final accounting document request is recorded; status is updated in zones | YES | YES | NO | NO | NO | NO | waiting_for_final_doc
22.0. | Fin Mgr | Changes status – full story amount paid | Status: 'Waiting for Feedback' | YES | YES | NO | NO | NO | NO | waiting_for_feedback
23.0. | System | Sends email to Parent requesting feedback within 14 days | ✓ Parent receives feedback request email | YES | YES | NO | NO | NO | NO | waiting_for_feedback
24.0 | System | If no feedback within 14 days → sends 1st reminder to Parent | ✓ 1st feedback reminder sent | YES | YES | NO | NO | NO | NO | waiting_feedback_reminder_1
25.0 | System | If no feedback within 14+14 days → sends 2nd reminder; also notifies Patron | ✓ 2nd reminder sent. Patron also notified. | YES | YES | YES | NO | NO | NO | waiting_feedback_reminder_2
26.0 | Parent | Provides feedback (story outcome, photos, description of how gift was used) | Feedback submitted in system | NO | NO | NO | NO | NO | NO | feedback_to_proccess
27.0 | Content Coord | Sends the parent's feedback to donors | Feedback distributed to donors | NO | NO | NO | NO | YES | NO | feedback_sent
28.0 | System | Status changes to 'Feedback Sent' | Status updated | NO | NO | NO | NO | NO | NO | feedback_sent
29.0 | Coord BACK | Closes the application after verifying feedback and all documents are correct | Closure action performed in BE | NO | NO | NO | NO | NO | NO | closed
30.0 | System | Status changes to 'Closed' | Both zones show 'Closed' | NO | NO | NO | NO | NO | NO | closed

### SHEET: SC-8B  (14 řádků)
SC-8B  |  Parent Does Not Sign Contract – Non-cooperative
🎯  Contract sent to Parent but Parent misses all signature deadlines. Story canc…
📌  Preconditions: SC-8A steps 1–9 completed. Contract sent to Parent. Parent has…
# | Role | Action / Step to Test | Expected Result | Email ⏎ Parent | Notification ⏎ Parent | Email ⏎ Patron | Notification ⏎ Patron | Email ⏎ Donor | Notification ⏎ Donor | Status ⏎ in System | Result | Notes / Comments | Source / Notification Notes
1.0 | System | Contract sent to Parent, deadline is 2 days to sign | Parent received email with contract | YES | YES | NO | YES | NO | NO | waiting_signature
2.0 | System | Parent does not sign within 2 days → sends 1st reminder | ✓ 1st signing reminder sent | YES | YES | NO | NO | NO | NO | waiting_signature_reminder_1
3.0 | System | Parent does not sign within 5 days after 1st reminder → sends 2nd reminder | ✓ 2nd signing reminder sent | YES | YES | YES | NO | NO | NO | waiting_signature_reminder_2
4.0 | System | Parent does not sign within 7 days after 2nd reminder → marks as 'Non-cooperativ… | Status: Awaiting Signature – Non-cooperative | NO | YES | NO | NO | NO | NO | waiting_signature_uncooperative
5.0 | Coord FRONT | Contacts Parent and Patron by phone or email to attempt resolution | Contact attempted | NO | YES | NO | NO | NO | NO | waiting_signature_uncooperative
6.0 | Parent | Refuses or remains unresponsive – still does not sign contract | No signature provided | NO | YES | NO | NO | NO | NO | waiting_signature_uncooperative
7.0 | Ops Mgr | Reallocates the donation to other children's stories | Donation redistribution performed in system | YES | YES | YES | YES | NO | NO | canceled_campaign
8.0 | System | Status changes to 'Story Cancelled' | Status updated in both zones | YES | YES | YES | YES | NO | NO | canceled_campaign
9.0 | System | Sends cancellation notification to Parent | ✓ Parent receives notification | YES | YES | YES | YES | NO | NO | canceled_campaign
10.0 | System | Sends cancellation notification to Patron | ✓ Patron receives notification | YES | YES | YES | YES | NO | NO | canceled_campaign

### SHEET: SC-8C  (16 řádků)
SC-8C  |  Collection Partially Fulfilled (1–99%)
🎯  Collection ends with partial amount raised (between 1% and 99%). Coordinator …
📌  Preconditions: Application approved by Risk. Fundraising collection ended wit…
# | Role | Action / Step to Test | Expected Result | Email ⏎ Parent | Notification ⏎ Parent | Email ⏎ Patron | Notification ⏎ Patron | Email ⏎ Donor | Notification ⏎ Donor | Status ⏎ in System | Result | Notes / Comments | Source / Notification Notes
1.0 | System | Collection ends – detects amount raised is between 1% and 99% | System identifies story as partially fulfilled | YES | YES | YES | YES | NO | NO | campaign_uncompleted
2.0 | System | Status changes to 'Target Amount Not Reached' | Status updated in both zones | YES | YES | YES | YES | NO | NO | campaign_uncompleted
3.0 | System | Sends notification to Parent and Patron about partial collection | ✓ Both receive notification | YES | YES | YES | YES | NO | NO | campaign_uncompleted
4.0 | Coord FRONT | Contacts Parent to discuss options for using the partial amount | Contact made by phone or email | YES | YES | YES | YES | NO | NO | campaign_uncompleted
5.0 | Parent | DECISION: decides to use the partial amount with a different/cheaper gift | Parent communicates decision to coordinator | NO | NO | NO | NO | NO | YES | completed_partly
6.0 | Coord FRONT | Identifies story as 'Partially Fulfilled' in the system | Status: Fulfilled Story – Partial Fulfillment | NO | NO | NO | NO | NO | YES | completed_partly
7.0 | Coord FRONT | Continues the process: new supplier contact, contract, payment (same as SC-8A fr… | Back-office flow continues with adjusted amount | NO | NO | NO | NO | NO | YES | completed_partly
8.0 | System | Final status: 'Closed – Partial Fulfillment' | Both zones show Closed – Partial Fulfillment | NO | NO | NO | NO | NO | YES | completed_partly
9.0 | Parent | ALTERNATIVE DECISION: decides NOT to use the partial amount | Parent communicates decision | NO | YES | NO | NO | NO | NO | uncompleted
10.0 | Coord FRONT | Marks story as 'Unfulfilled – Gift Redistribution' | Status updated | NO | YES | NO | NO | NO | NO | uncompleted
11.0 | Ops Mgr | Reallocates the collected partial amount to other children's stories | Redistribution performed | NO | YES | NO | NO | NO | NO | uncompleted
12.0 | System | Status changes to 'Unfulfilled Story' | Both zones updated | NO | YES | NO | NO | NO | NO | uncompleted

### SHEET: SC-8D  (15 řádků)
SC-8D  |  Collection 0% Unfulfilled
🎯  Collection ends with 0% raised. Coordinator cancels supplier reservation and …
📌  Preconditions: Application approved by Risk. Fundraising collection ended wit…
# | Role | Action / Step to Test | Expected Result | Email ⏎ Parent | Notification ⏎ Parent | Email ⏎ Patron | Notification ⏎ Patron | Status ⏎ in System | Result | Notes / Comments | Source / Notification Notes
1.0 | System | Collection ends – detects 0% of target amount raised | System identifies story as unfulfilled (0%) | NO | YES | NO | NO | uncompleted
2.0 | System | Status changes to 'Target Amount Not Reached' | Status updated | NO | YES | NO | NO | campaign_uncompleted
3.0 | System | Sends email to Parent and Patron about failed collection | ✓ Both receive notification | NO | YES | NO | NO | uncompleted
4.0 | Parent Zone | Shows 'Target Amount Not Reached' | Parent logs in → status visible | NO | YES | NO | NO | campaign_uncompleted
5.0 | Patron Zone | Shows 'Target Amount Not Reached' | Patron logs in → status visible | NO | YES | NO | NO | campaign_uncompleted
6.0 | Coord FRONT | Contacts supplier to cancel the reservation | Supplier notified of cancellation | NO | YES | NO | NO | uncompleted
7.0 | Coord FRONT | Cancels the story in the system (0% case) | Cancellation action performed | YES | YES | YES | YES | canceled_campaign
8.0 | System | Status changes to 'Story Cancelled' | Status updated in both zones | YES | YES | YES | YES | canceled_campaign
9.0 | System | Sends final cancellation notification to both Parent and Patron | ✓ Both receive final notification | YES | YES | YES | YES | canceled_campaign
10.0 | Parent Zone | Shows 'Story Cancelled' | Parent logs in → cancelled status visible | YES | YES | YES | YES | canceled_campaign
11.0 | Patron Zone | Shows 'Story Cancelled' | Patron logs in → cancelled status visible | YES | YES | YES | YES | canceled_campaign

### SHEET: SC-9A  (15 řádků)
SC-9A  |  Story Published Successfully
🎯  Content Coordinator receives the application, prepares the child's story, and…
📌  Preconditions: Application approved by Risk (Scoring OK). Status: 'Story Prep…
# | Role | Action / Step to Test | Expected Result | Email ⏎ Parent | Notification ⏎ Parent | Email ⏎ Patron | Notification ⏎ Patron | Status ⏎ in System | Result | Notes / Comments | Source / Notification Notes
1.0 | Coord FRONT | Sends the approved application to Content Coordinator for story preparation | Application status changes to 'Story Preparation' | NO | NO | NO | NO | X
2.0 | Content Coord | Takes over the story in the system (uses 'Add Story' function) | Story appears in content queue | NO | NO | NO | NO | X
3.0 | Content Coord | Checks all materials needed: photos, story text, donation type and amount | All materials present and sufficient quality | NO | NO | NO | NO | X
4.0 | Content Coord | If materials are incomplete: requests missing items from Coordinator FRONT | Coordinator FRONT contacts Parent or Patron for missing items | NO | NO | NO | NO | X
5.0 | Content Coord | Prepares/edits the story for publication (text formatting, photo selection) | Story ready for publication in the system | NO | NO | NO | NO | X
6.0 | Content Coord | Publishes the story on the website | Story appears live on the website | YES | YES | YES | YES | active
7.0 | System | Changes status to 'Active Story' | Status updated in both zones | YES | YES | YES | YES | active
8.0 | System | Sends email to Parent: story is published (with link) | ✓ Parent receives publication notification | YES | YES | YES | YES | active
9.0 | System | Sends email to Patron: story is published (with link) | ✓ Patron receives publication notification | YES | YES | YES | YES | active
10.0 | Parent Zone | Shows 'Active Story' with link to published story | Parent logs in → active story visible with link | YES | YES | YES | YES | active
11.0 | Patron Zone | Shows 'Active Story' with link to published story | Patron logs in → active story visible with link | YES | YES | YES | YES | active

### SHEET: SC-9B  (12 řádků)
SC-9B  |  Parent or Patron Requests Story Changes
🎯  After publication, Parent or Patron requests corrections to text or photos.
📌  Preconditions: Story is published with status 'Active Story'.
# | Role | Action / Step to Test | Expected Result | Email ⏎ Parent | Notification ⏎ Parent | Email ⏎ Patron | Notification ⏎ Patron | Status ⏎ in System | Result | Notes / Comments | Source / Notification Notes
1.0 | Parent/Patron | Sends change request to Content Coordinator by email (text correction, new photo… | Request received by Content team | NO | NO | NO | NO | X
2.0 | Content Coord | Reviews the change request | Change is reasonable and within guidelines | NO | NO | NO | NO | X
3.0 | Content Coord | Makes the requested changes in the system (text or photo update) | Story updated on website | NO | NO | NO | NO | X
4.0 | Parent/Patron | Verifies the changes are correct on the website | Changes visible on live story page | NO | NO | NO | NO | X
5.0 | Parent/Patron | Requests cancellation of the story (instead of changes) | Request for story removal sent | NO | NO | NO | NO | X
6.0 | Coord FRONT | Changes status and removes story from website | Story removed. Status: Cancelled Story | NO | NO | NO | NO | X
7.0 | System | Changes status to 'Cancelled Story' | Status updated in both zones | NO | NO | NO | NO | X
8.0 | System | Sends cancellation notification to both Parent and Patron | ✓ Both receive cancellation email | NO | NO | NO | NO | X

### SHEET: SC-9C  (19 řádků)
SC-9C  |  Parent Provides Feedback – via System, Email, or Video
🎯  After donation is paid, Parent provides feedback about how the gift was used.…
📌  Preconditions: Donation paid. Status: 'Waiting for Feedback'. Parent has been…
# | Role | Action / Step to Test | Expected Result | Email ⏎ Parent | Notification ⏎ Parent | Email ⏎ Patron | Notification ⏎ Patron | Email ⏎ Donor | Notification ⏎ Donor | Status ⏎ in System | Result | Notes / Comments | Source / Notification Notes
1.0 | System | Sends email to Parent requesting feedback within 14 days | ✓ Parent receives feedback request | YES | YES | NO | NO | NO | NO | waiting_for_feedback
2.0 | Parent Zone | Shows 'Waiting for Feedback' with action required | Parent logs in → feedback submission visible | YES | YES | NO | NO | NO | NO | waiting_for_feedback
3.0 | Parent | OPTION A: Submits feedback directly through the system (text + photos) | Feedback appears in system with status 'Feedback on Processing' | NO | NO | NO | NO | NO | NO | feedback_to_proccess
4.0 | System | Status changes to 'Feedback on Processing' | Status visible in Parent Zone and Patron Zone | NO | NO | NO | NO | NO | NO | feedback_to_proccess
5.0 | Content Coord | Processes the feedback and sends it to donors | Feedback distributed to all donors of this story | NO | NO | NO | NO | YES | YES | feedback_sent
6.0 | System | Status changes to 'Feedback Sent' | Final status visible in both zones | NO | NO | NO | NO | YES | YES | feedback_sent
7.0 | Parent | OPTION B: Sends feedback by email (text + photos attached) | Email received by INFO Coordinator | NO | NO | NO | NO | NO | NO | X
8.0 | INFO Coord | Adds the emailed feedback to the lead/application in system | Feedback now in system | NO | NO | NO | NO | NO | NO | X
9.0 | Content Coord | Processes and sends feedback to donors | Feedback distributed | NO | NO | NO | NO | YES | YES | feedback_sent
10.0 | Parent | OPTION C: Sends video feedback by email (unsupported format for direct upload) | Email with video received | NO | NO | NO | NO | NO | NO | X
11.0 | INFO Coord | Forwards video to Social Media Specialist | Video forwarded by email | NO | NO | NO | NO | NO | NO | X
12.0 | Social Media | Edits video, uploads to YouTube, sends link to Content Coordinator | YouTube link received | NO | NO | NO | NO | NO | NO | X
13.0 | Content Coord | Inserts YouTube link as feedback in the system lead | Link added to application | NO | NO | NO | NO | NO | NO | X
14.0 | Content Coord | Sends feedback (with video link) to donors | Feedback with video distributed | NO | NO | NO | NO | YES | YES | feedback_sent
15.0 | System | Status changes to 'Feedback Sent' in all cases | Final status confirmed in both zones | NO | NO | NO | NO | YES | YES | feedback_sent

### SHEET: SC-9D  (10 řádků)
SC-9D  |  Parent Does Not Provide Feedback – Reminders & Universal Feedback
🎯  Parent does not submit feedback. System sends 2 reminders. After timeout univ…
📌  Preconditions: Donation paid. Status: 'Waiting for Feedback'. Parent has NOT …
# | Role | Action / Step to Test | Expected Result | Email ⏎ Parent | Notification ⏎ Parent | Email ⏎ Patron | Notification ⏎ Patron | Email ⏎ Donor | Notification ⏎ Donor | Status ⏎ in System | Result | Notes / Comments | Source / Notification Notes
1.0 | System | Sends 1st reminder to Parent to provide feedback (after 2 days) | ✓ Parent receives 1st feedback reminder | YES | YES | NO | NO | NO | NO | waiting_feedback_reminder_1
2.0 | System | Sends 2nd reminder to Parent (after 14+14 days – note: documents say 14 day inte… | ✓ Parent receives 2nd reminder. Patron also notified. | YES | YES | YES | NO | NO | NO | waiting_feedback_reminder_2
3.0 | System | Identifies Parent as non-cooperative after 14+14+30 days without feedback | Status: 'Waiting for Feedback – Non-cooperative' | NO | NO | NO | NO | NO | NO | waiting_feedback_uncooperative
4.0 | Content Coord | Sends a universal feedback template to donors (instead of personal feedback) | Universal feedback sent to all donors of the story | NO | NO | NO | NO | YES | YES | feedback_sent
5.0 | System | Status changes to 'Feedback Sent' | Final status updated in both zones | NO | NO | NO | NO | NO | YES | feedback_sent
6.0 | Risk Mgr | Notes non-cooperation; takes it into account when reviewing Parent's future appl… | Non-cooperation flagged in system for future risk reviews | NO | NO | NO | NO | NO | NO | X

### SHEET: SC-10A  (16 řádků)
SC-10A  |  Donation via Website to Specific Story – Completed (Comgate)
🎯  Donor selects a specific child's story and completes a one-time donation via …
📌  Preconditions: Story is published and active on website. Donor is on the dona…
# | Role | Action / Step to Test | Expected Result | Email ⏎ Parent | Notification ⏎ Parent | Email ⏎ Patron | Notification ⏎ Patron | Email ⏎ Donor | Notification ⏎ Donor | Status ⏎ in System | Result | Notes / Comments | Source / Notification Notes
1.0 | Donor | Navigates to a child's story page on the website and clicks 'Donate' | Donation form loads correctly | NO | NO | NO | NO | NO | NO | X
2.0 | Donor | Enters donation amount | Amount field accepts valid numeric input | NO | NO | NO | NO | NO | NO | X
3.0 | Donor | Enters mandatory personal data (name, email, address if required) | All fields validated; mandatory fields marked | NO | NO | NO | NO | NO | NO | X
4.0 | Donor | Selects payment method via Comgate (card, bank, etc.) | Payment options shown correctly | NO | NO | NO | NO | NO | NO | X
5.0 | Donor | Completes the payment | Payment processed without errors | NO | NO | NO | NO | YES | NO | X
6.0 | Comgate | Confirms the donation to the system (BE) | Payment confirmation received by BE | NO | NO | NO | NO | NO | NO | X
7.0 | System | Changes donation status to PAID | Status PAID in backend | NO | NO | NO | NO | YES | NO | X
8.0 | System | Sends confirmation email to Donor | ✓ Donor receives payment confirmation email | NO | NO | NO | NO | YES | NO | X
9.0 | Donor Zone | Donation visible in Donor Zone with status PAID | Donor logs in → donation visible | NO | NO | NO | NO | YES | YES | X
10.0 | Comgate | Sends money to Moneta bank in a daily batch transfer | Batch transfer processed | NO | NO | NO | NO | NO | NO | X
11.0 | Bank | Confirms receipt of donation via API to BE | API confirmation received | NO | NO | NO | NO | NO | NO | X
12.0 | System | Donation assigned to specific story; story fundraising progress updated | Story progress bar updated on website | NO | NO | NO | NO | NO | NO | X

### SHEET: SC-10B  (13 řádků)
SC-10B  |  Donation via Website – Not Completed (PENDING → CANCELLED)
🎯  Donor starts the payment process but does not complete it. Status goes PENDIN…
📌  Preconditions: Donor has started the donation form but abandoned the payment …
# | Role | Action / Step to Test | Expected Result | Email ⏎ Parent | Notification ⏎ Parent | Email ⏎ Patron | Notification ⏎ Patron | Email ⏎ Donor | Notification ⏎ Donor | Status ⏎ in System | Result | Notes / Comments | Source / Notification Notes
1.0 | Donor | Enters mandatory data but does not finish the payment (closes browser, times out… | Incomplete payment attempt recorded | NO | NO | NO | NO | NO | NO | X
2.0 | System | Sets donation status to PENDING | Status PENDING in system | NO | NO | NO | NO | YES | NO | X
3.0 | System | Sends PENDING notification email to Donor | ✓ Donor receives PENDING email with option to complete | NO | NO | NO | NO | YES | NO | X
4.0 | Donor Zone | Shows donation as PENDING | Donor logs in → PENDING donation visible | NO | NO | NO | NO | NO | NO | X
5.0 | Comgate | Sends a completion request to Donor (automated reminder to finish payment) | ✓ Donor receives completion request from Comgate | NO | NO | NO | NO | YES | NO | X
6.0 | Donor | OPTION A: Returns and completes the payment | Donation status changes to PAID → continue as SC-10A | NO | NO | NO | NO | NO | NO | X
7.0 | Comgate | OPTION B: Cancels the donation after timeout | Status changes to CANCELLED | NO | NO | NO | NO | YES | NO | X
8.0 | System | Sends CANCELLED notification to Donor | ✓ Donor receives cancellation email | NO | NO | NO | NO | YES | NO | X
9.0 | Donor Zone | Shows donation as CANCELLED | Donor logs in → CANCELLED status visible | NO | NO | NO | NO | NO | NO | X

### SHEET: SC-10C  (13 řádků)
SC-10C  |  Donation to General Collection Account (Comgate)
🎯  Donor donates to the general collection account (not tied to a specific story…
📌  Preconditions: Donor chooses to donate to the general collection account on t…
# | Role | Action / Step to Test | Expected Result | Email ⏎ Parent | Notification ⏎ Parent | Email ⏎ Patron | Notification ⏎ Patron | Email ⏎ Donor | Notification ⏎ Donor | Status ⏎ in System | Result | Notes / Comments | Source / Notification Notes
1.0 | Donor | Selects 'Donate to collection account' option on website | Option visible and selectable | NO | NO | NO | NO | NO | NO | X
2.0 | Donor | Enters amount and mandatory data, completes payment via Comgate | Payment completed | NO | NO | NO | NO | NO | NO | X
3.0 | Comgate | Confirms donation; sends batch to Moneta bank | Confirmation processed | NO | NO | NO | NO | YES | NO | X
4.0 | Bank | Confirms receipt via API to BE | API confirmation received | NO | NO | NO | NO | YES | NO | X
5.0 | System | Sets donation status to PAID | PAID status in system | NO | NO | NO | NO | YES | NO | X
6.0 | System | Sends confirmation email to Donor | ✓ Donor receives confirmation | NO | NO | NO | NO | YES | NO | X
7.0 | Ops Mgr | Receives notification; identifies donation on collection account | Donation visible in operations dashboard | NO | NO | NO | NO | NO | NO | X
8.0 | Ops Mgr | Assigns / transfers the donation to a specific child's story in BE | Donation linked to story; story progress updated | NO | NO | NO | NO | NO | NO | X
9.0 | Donor Zone | Donation visible with PAID status | Donor logs in → donation visible | NO | NO | NO | NO | YES | NO | X

### SHEET: SC-10D  (11 řádků)
SC-10D  |  Donation via Bank Transfer
🎯  Donor makes a manual bank transfer to the collection account and optionally p…
📌  Preconditions: Donor chooses bank transfer method. Collection account details…
# | Role | Action / Step to Test | Expected Result | Email ⏎ Parent | Notification ⏎ Parent | Email ⏎ Patron | Notification ⏎ Patron | Email ⏎ Donor | Notification ⏎ Donor | Status ⏎ in System | Result | Notes / Comments | Source / Notification Notes
1.0 | Donor | Initiates bank transfer from their own bank to the collection account | Transfer sent | NO | NO | NO | NO | NO | NO | X
2.0 | Donor | Optionally enters their email address in the recipient note/message field | Email included in transfer note (optional) | NO | NO | NO | NO | NO | NO | X
3.0 | Bank | Transfers the donation to the collection account automatically | Transfer received | NO | NO | NO | NO | NO | NO | X
4.0 | System | Receives transfer confirmation; sets status to PAID | PAID status in system | NO | NO | NO | NO | NO | NO | X
5.0 | System | If Donor provided email: sends confirmation email to Donor | ✓ Donor receives confirmation (only if email was provided) | NO | NO | NO | NO | YES | NO | X
6.0 | Donor Zone | If email matched: donation visible in Donor Zone with PAID status | Donor logs in → donation visible (if email matched) | NO | NO | NO | NO | YES | YES | X
7.0 | Ops Mgr | Assigns the bank transfer donation to a specific child's story in BE | Donation linked to story | NO | NO | NO | NO | NO | NO | X

### SHEET: SC-10E  (14 řádků)
SC-10E  |  Regular Donation – Standing Bank Order or Regular Card Payment
🎯  Donor sets up a recurring donation via standing bank order or recurring card …
📌  Preconditions: Donor is on the donation page and selects the recurring/regula…
# | Role | Action / Step to Test | Expected Result | Email ⏎ Parent | Notification ⏎ Parent | Email ⏎ Patron | Notification ⏎ Patron | Email ⏎ Donor | Notification ⏎ Donor | Status ⏎ in System | Result | Notes / Comments | Source / Notification Notes
1.0 | Donor | Selects 'Regular donation' option on website | Regular donation option visible and selectable | NO | NO | NO | NO | NO | NO | X
2.0 | Donor | OPTION A: Sets up regular bank transfer (standing order) through their bank | Standing order confirmed by bank | NO | NO | NO | NO | NO | NO | X
3.0 | Bank | Transfers regular donations to collection account automatically each period | Regular transfers received | NO | NO | NO | NO | NO | NO | X
4.0 | System | Records each incoming transfer as PAID | Each regular donation appears as PAID in system | NO | NO | NO | NO | NO | NO | X
5.0 | Donor | OPTION B: Sets up regular card payment via website/Comgate | Card payment subscription set up | NO | NO | NO | NO | NO | NO | X
6.0 | Donor | Enters mandatory data and completes the regular donation setup | Subscription confirmed | NO | NO | NO | NO | NO | NO | X
7.0 | System | Processes each regular card payment; sends confirmation per payment | ✓ Donor receives confirmation for each payment | NO | NO | NO | NO | NO | NO | X
8.0 | Donor Zone | Shows regular donation subscription and history | Donor logs in → recurring donations visible | NO | NO | NO | NO | NO | YES | X
9.0 | Donor | Cancels the regular donation via Donor Zone | Cancellation request submitted | NO | NO | NO | NO | NO | YES | X
10.0 | System | Changes status to CANCELLED; confirms cancellation to Donor | Cancellation processed. Status CANCELLED in zone. | NO | NO | NO | NO | YES | YES | X

### SHEET: SC-10F  (14 řádků)
SC-10F  |  Gift Voucher (Dobrošek) – Purchase and Redemption
🎯  Donor purchases a gift voucher (dobrošek) and gives it to someone, who then r…
📌  Preconditions: Gift voucher feature is active on the website.
# | Role | Action / Step to Test | Expected Result | Email ⏎ Parent | Notification ⏎ Parent | Email ⏎ Patron | Notification ⏎ Patron | Email ⏎ Donor | Notification ⏎ Donor | Status ⏎ in System | Result | Notes / Comments | Source / Notification Notes
1.0 | Donor | Navigates to the gift voucher (dobrošek) page on website | Gift voucher page loads correctly | NO | NO | NO | NO | YES | NO | X
2.0 | Donor | Buys a dobrošek via website/Comgate (pays for the voucher) | Payment completed via Comgate | NO | NO | NO | NO | YES | NO | X
3.0 | System | Sets status to PAID; sends confirmation to Donor | ✓ Donor receives voucher purchase confirmation | NO | NO | NO | NO | YES | NO | X
4.0 | Donor | Gives the dobrošek (voucher code) to a recipient | Voucher code transferred to recipient | NO | NO | NO | NO | YES | NO | X
5.0 | Donor | OPTION A: Donor redeems the dobrošek themselves (applies it to a child's story) | Voucher applied to selected story | NO | NO | NO | NO | YES | NO | X
6.0 | System | Records redemption as PAID; sends confirmation to Donor | ✓ Confirmation sent to Donor | NO | NO | NO | NO | YES | NO | X
7.0 | Recipient | OPTION B: Recipient receives the dobrošek and redeems it on the website | Recipient navigates to website, enters voucher code | NO | NO | NO | NO | YES | NO | X
8.0 | Recipient | Applies the dobrošek to a selected child's story | Donation applied to chosen story | NO | NO | NO | NO | YES | NO | X
9.0 | System | Records redemption as PAID; sends confirmation to Recipient | ✓ Confirmation sent to Recipient | NO | NO | NO | NO | YES | NO | X
10.0 | Donor Zone | Dobrošek purchase and redemption status visible in Donor Zone | Donor logs in → voucher history visible | NO | NO | NO | NO | YES | NO | X

### SHEET: SC-10G  (9 řádků)
SC-10G  |  Donation Confirmation Certificate
🎯  Donor requests or generates a confirmation of their donation (for tax purpose…
📌  Preconditions: Donor has made at least one completed donation (status PAID).
# | Role | Action / Step to Test | Expected Result | Email ⏎ Parent | Notification ⏎ Parent | Email ⏎ Patron | Notification ⏎ Patron | Email ⏎ Donor | Notification ⏎ Donor | Status ⏎ in System | Result | Notes / Comments | Source / Notification Notes
1.0 | Donor | OPTION A: Logs in to Donor Zone and generates confirmation themselves | Confirmation PDF generated and downloadable | NO | NO | NO | NO | YES | NO | X
2.0 | System | Generates donation confirmation document automatically | Document available in Donor Zone | NO | NO | NO | NO | YES | NO | X
3.0 | Donor | OPTION B: Cannot generate themselves (e.g. anonymous donation) – sends request b… | Email request sent to INFO Coordinator | NO | NO | NO | NO | NO | NO | X
4.0 | INFO Coord | Receives the request; verifies donor identity and donation | Verification completed | NO | NO | NO | NO | NO | NO | X
5.0 | INFO Coord | Issues donation confirmation manually and sends to Donor by email | ✓ Confirmation email sent to Donor | NO | NO | NO | NO | YES | NO | X

### SHEET: SC-11A  (10 řádků)
SC-11A  |  Automatic Account Creation – Parent Zone
🎯  When Parent submits the application form, the system automatically creates a …
📌  Preconditions: Parent has just submitted the application form (first-time use…
# | Role | Action / Step to Test | Expected Result | Email ⏎ Parent | Notification ⏎ Parent | Email ⏎ Patron | Notification ⏎ Patron | Status ⏎ in System | Result | Notes / Comments | Source / Notification Notes
1.0 | Parent | Registration to the system with a valid email address | Registration submitted successfully | NO | NO | NO | NO | X
2.0 | System | Automatically creates a Parent Zone account linked to the submitted email | Account created in backend | NO | YES | NO | NO | new
3.0 | System | Sends account activation / welcome email to Parent | ✓ Parent receives welcome/activation email with login details or link | NO | NO | NO | NO | X
4.0 | Parent | Clicks the activation link or logs in with credentials | Login successful | NO | NO | NO | NO | X
5.0 | Parent Zone | Displays current application status after login | Correct status shown immediately after first login | NO | YES | NO | NO | new
6.0 | Parent | Can track application status, view notifications, upload documents, and provide … | All zone features accessible | NO | NO | NO | NO | X

### SHEET: SC-11B  (11 řádků)
SC-11B  |  Patron Zone Account Activation – First-Time Patron
🎯  When Patron submits a form for the first time, system sends activation email …
📌  Preconditions: Patron has submitted the Patron form for the very first time (…
# | Role | Action / Step to Test | Expected Result | Email ⏎ Parent | Notification ⏎ Parent | Email ⏎ Patron | Notification ⏎ Patron | Status ⏎ in System | Result | Notes / Comments | Source / Notification Notes
1.0 | System | Detects that Patron does not yet have a Patron Zone account | New account trigger fires | NO | NO | NO | NO | X
2.0 | System | Sends account activation email to Patron with activation link | ✓ Patron receives activation email | NO | YES | NO | NO | new
3.0 | Patron | Opens the activation email and clicks the activation link | Link works and redirects to activation page | NO | YES | NO | NO | new
4.0 | Patron | Completes account activation (sets password or confirms identity) | Account successfully activated | NO | NO | NO | NO | X
5.0 | Patron Zone | Displays current application status and available actions after activation | Correct status visible; Patron can complete form from zone | NO | NO | NO | NO | X
6.0 | Patron | For subsequent applications: logs in directly without re-activation | Login works without new activation email | NO | YES | NO | NO | new
7.0 | System | Does NOT send another activation email to already-registered Patron | No duplicate activation email in Patron inbox | NO | YES | NO | NO | new

### SHEET: SC-11C  (15 řádků)
SC-11C  |  Status Notifications Visible in Parent Zone
🎯  At each step of the process the correct status message must be displayed in t…
📌  Preconditions: Parent has an active account and is logged into the Parent Zon…
# | Role | Action / Step to Test | Expected Result | Email ⏎ Parent | Notification ⏎ Parent | Email ⏎ Patron | Notification ⏎ Patron | Status ⏎ in System | Result | Notes / Comments | Source / Notification Notes
1.0 | Parent Zone | After form submission: shows 'Complete the application' or 'Awaiting Patron' | Correct initial status shown | NO | YES | NO | NO | X
2.0 | Parent Zone | After Patron completes form: shows 'Application in Process' | Status updates without page refresh needed | NO | YES | NO | NO | X
3.0 | Parent Zone | During coordinator review: shows 'Application Processing' | Correct review status shown | NO | YES | NO | NO | X
4.0 | Parent Zone | When returned for completion: shows 'Waiting to be Completed' with details | Action required message visible with clear instructions | NO | YES | NO | NO | X
5.0 | Parent Zone | During Risk review: shows 'Scoring Control' | Correct risk status shown | NO | YES | NO | NO | X
6.0 | Parent Zone | After Risk approval: shows 'Your application has been approved' | Approval message visible | NO | YES | NO | NO | X
7.0 | Parent Zone | After Risk rejection: shows 'Rejected' | Rejection message visible | NO | YES | NO | NO | X
8.0 | Parent Zone | During story publication: shows 'Active Story' with link | Link to published story working | NO | YES | NO | NO | X
9.0 | Parent Zone | After collection completed: shows contract status and signature request | Contract action visible | NO | YES | NO | NO | X
10.0 | Parent Zone | After payment: shows 'Waiting for Feedback' with submission option | Feedback submission visible | NO | YES | NO | NO | X
11.0 | Parent Zone | After closure: shows 'Closed' | Final closed status visible | NO | YES | NO | NO | X

### SHEET: SC-11D  (15 řádků)
SC-11D  |  Status Notifications Visible in Patron Zone
🎯  At each step of the process the correct status message must be displayed in t…
📌  Preconditions: Patron has an active account and is logged into the Patron Zon…
# | Role | Action / Step to Test | Expected Result | Email ⏎ Parent | Notification ⏎ Parent | Email ⏎ Patron | Notification ⏎ Patron | Status ⏎ in System | Result | Notes / Comments | Source / Notification Notes
1.0 | Patron Zone | After Patron submits form: shows 'Awaiting Legal Guardian' or confirmation | Correct initial status shown | NO | NO | NO | YES | X
2.0 | Patron Zone | When Patron must complete form: shows 'Complete the application' | Action required visible | NO | NO | NO | YES | X
3.0 | Patron Zone | After both forms submitted: shows 'Application in Process' | Status updates correctly | NO | NO | NO | YES | X
4.0 | Patron Zone | During coordinator review: shows 'Application Processing' | Correct review status shown | NO | NO | NO | YES | X
5.0 | Patron Zone | During Risk review: shows 'Scoring Control' / 'Under Review' | Correct risk status shown | NO | NO | NO | YES | X
6.0 | Patron Zone | After Risk approval: shows 'Application Approved' | Approval message visible | NO | NO | NO | YES | X
7.0 | Patron Zone | After Risk rejection: shows 'Rejected' | Rejection message visible | NO | NO | NO | YES | X
8.0 | Patron Zone | When patron change is requested: shows 'Application Rejected' | Patron sees rejection of their involvement | NO | NO | NO | YES | X
9.0 | Patron Zone | During story publication: shows 'Active Story' with link | Link to story working | NO | NO | NO | YES | X
10.0 | Patron Zone | After collection and payment: shows final donation status | Correct payment status visible | NO | NO | NO | YES | X
11.0 | Patron Zone | After closure: shows 'Closed' | Final closed status visible | NO | NO | NO | YES | X

### SHEET: SC-11E  (13 řádků)
SC-11E  |  Mautic Integration – Email Notifications & Tracking
🎯  The system uses Mautic for sending automated emails. Open rates are tracked. …
📌  Preconditions: Mautic is configured and connected to the backend (BE). Donor/…
# | Role | Action / Step to Test | Expected Result | Email ⏎ Parent | Notification ⏎ Parent | Email ⏎ Patron | Notification ⏎ Patron | Email ⏎ Donor | Notification ⏎ Donor | Status ⏎ in System | Result | Notes / Comments | Source / Notification Notes
1.0 | System/Mautic | Reminder emails for form completion are sent via Mautic (1st and 2nd reminders) | Emails arrive on time; correct content and links | YES | YES | YES | YES | NO | NO | reminder_1
2.0 | System/Mautic | Feedback reminder emails to Parents are sent via Mautic | ✓ Emails arrive on schedule | YES | YES | NO | NO | NO | NO | waiting_feedback_reminder_1
3.0 | Mautic | Tracks email open rates for each sent email | Open rates visible in Mautic dashboard | NO | NO | NO | NO | NO | NO | X
4.0 | Mautic | Patron database is correctly segmented (by status, campaign, etc.) | Segments visible in Mautic; correct Patron emails in each segment | NO | NO | NO | NO | NO | NO | X
5.0 | KAM | Manually creates newsletter/mailing in Mautic using a template | Newsletter created and previewed correctly | NO | NO | NO | NO | NO | NO | X
6.0 | KAM | Sends newsletter to target segment in Mautic | Newsletter sent to correct recipients only | NO | NO | NO | NO | NO | NO | X
7.0 | Mautic | Reports email open rates and click rates after send | Statistics available in Mautic after sending | NO | NO | NO | NO | NO | NO | X
8.0 | System | All transactional emails (confirmations, rejections, status changes) are deliver… | Emails arrive promptly; not marked as spam | YES | NO | YES | NO | YES | NO | X
9.0 | System | No duplicate emails sent to same recipient at same step | Inbox check: no duplicates | NO | NO | NO | NO | NO | NO | X

### SHEET: Notification Matrix  (117 řádků)
Status | Recipient role | Email | User account notification | Status message | Source ids | Parse note
active | Parent | NO | YES | Příběh je zveřejněn | 108 | CHECK_PARSE
active | Patron | NO | YES | Příběh je zveřejněn | 109 | CHECK_PARSE
application_processing | Parent | NO | NO | Žádost zpracováváme | 16 | OK
application_processing | Patron | NO | NO | Zpracováváme | 49 | OK
campaign_uncompleted | Parent | YES | YES | Spojíme se s vámi | 37 | CHECK_PARSE
campaign_uncompleted | Patron | YES | NO | Dokončeno | 9 | CHECK_PARSE
campaign_uncompleted_inprocess | Parent | NO | NO | Nesplněný příběh | 38 | OK
campaign_uncompleted_inprocess | Patron | NO | YES | Nesplněný příběh v plné výši | 62 | CHECK_PARSE
canceled_application | Parent | YES | YES | Žádost zrušena | 8 | CHECK_PARSE
canceled_application | Patron | NO | NO | Žádost zrušena | 53 | CHECK_PARSE
canceled_by_user | Parent | YES | YES | Zrušeno žadatelem | 30 | OK
canceled_by_user | Patron | YES | NO | Příběh zrušen | 76 | OK
canceled_campaign | Parent | YES | YES | Příběh zrušen | 29 | OK
canceled_campaign | Patron | YES | YES | Příběh zrušen | 75 | OK
canceled_fundraiser | Patron | YES | YES | Vypršela lhůta pro vyplnění | 89 | CHECK_PARSE
canceled_lead | Parent | YES | YES | Zrušená žádost | 11 | CHECK_PARSE
canceled_lead | Patron | YES | YES | Zrušená žádost | 79,123 | CHECK_PARSE
canceled_timeout | Parent | YES | YES | Zrušená žádost | 31 | CHECK_PARSE
canceled_timeout | Patron | YES | YES | Zrušená žádost | 80,124 | CHECK_PARSE
closed | Parent | NO | NO | Splněno | 7 | OK
closed | Patron | NO | NO | Splněno | 73 | OK
communications | Parent | NO | NO | Rozpracovaná žádost | 10 | CHECK_PARSE
communications | Patron | NO | NO | Rozpracovaná žádost | 78 | OK
completed | Parent | YES | YES | Vybráno | 24 | CHECK_PARSE
completed | Patron | YES | NO | Vybráno | 61 | CHECK_PARSE
completed_partly | Parent | NO | NO | Částečně splněno | 42 | OK
completed_partly | Patron | NO | NO | Částečně splněno | 74 | OK
contract | Parent | NO | NO | Připravujeme smlouvu | 26 | OK
contract | Patron | NO | NO | Připravujeme smlouvu | 64 | OK
contract_signed | Parent | YES | YES | Podepsaná smlouva | 39 | CHECK_PARSE
contract_signed | Patron | NO | NO | Dar je na cestě | 66 | OK
duplicate | Parent | YES | YES | Duplikát | 33 | OK
duplicate | Patron | YES | YES | Duplikát | 84,127 | OK
feedback_received | Parent | YES | YES | Poskytnuta zpětná vazba | 41 | CHECK_PARSE
feedback_received | Patron | NO | YES | Splněno | 72 | OK
feedback_sent | Parent | NO | NO | Poděkování dárcům odesláno | 103 | OK
feedback_sent | Patron | NO | NO | Zpětná vazba odeslána | 105 | OK
feedback_to_proccess | Parent | NO | NO | Připravujeme poděkování pro dárce | 102 | OK
feedback_to_proccess | Patron | NO | NO | Připravujeme zpětnou vazbu | 104 | OK
gift_confirmation_approved | Parent | YES | YES | Potvrzené převzetí daru | 40 | OK
gift_confirmation_approved | Patron | NO | NO | Dar je na cestě | 69 | OK
gift_paid | Parent | NO | NO | Pořizujeme dar | 100 | OK
gift_paid | Patron | NO | NO | Dar je na cestě | 101 | OK
gift_payment | Parent | NO | NO | Pořizujeme dar | 27 | OK
gift_payment | Patron | NO | NO | Dar je na cestě | 67 | OK
in_progress | Parent | YES | YES | Schváleno | 22 | OK
in_progress | Patron | NO | YES | Schváleno | 58 | OK
mistake | Parent | NO | NO |  | 32 | CHECK_PARSE
mistake | Patron | NO | NO | Chyba | 83 | CHECK_PARSE
new | Parent | NO | YES | Rozpracovaná žádost | 1 | OK
new | Patron | NO | YES | Rozpracovaná žádost | 77,122 | OK
out_of_scope | Parent | YES | YES | Zrušená žádost; Nemůžeme vám pomoci | 2,91 | CHECK_PARSE
out_of_scope | Patron | YES | YES | Zrušená žádost; Nemůžeme vám pomoci | 43,85,128 | CHECK_PARSE
refiled | Parent | YES | YES | Žádost zpracováváme | 36 | OK
refiled | Patron | NO | NO | Zpracováváme | 51 | OK
reminder_1 | Parent | YES | YES | Dokončete žádost | 12 | CHECK_PARSE
reminder_1 | Patron | YES | YES | Dokončete rozpracovanou žádost; Dokončete žádost | 81,125 | CHECK_PARSE
reminder_1_fundraiser | Parent | YES | YES | Vyplňte žádost | 34 | OK
reminder_1_fundraiser | Patron | NO | YES | Čekáme na zákonného zástupce | 87 | OK
reminder_1_patron | Patron | YES | YES | Doplňte žádost | 45 | CHECK_PARSE
reminder_2 | Parent | YES | YES | Dokončete žádost | 13 | CHECK_PARSE
reminder_2 | Patron | YES | YES | Dokončete žádost | 82,126 | CHECK_PARSE
reminder_2_fundraiser | Parent | YES | YES | Vyplňte žádost | 94 | OK
reminder_2_fundraiser | Patron | YES | YES | Čekáme na zákonného zástupce | 88 | CHECK_PARSE
reminder_2_patron | Parent | YES | YES | Čekáme na Patrona | 35 | OK
reminder_2_patron | Patron | YES | YES | Doplňte žádost | 46 | OK
returned_new_patron | Parent | YES | NO | Najděte nového Patrona | 3 | CHECK_PARSE
returned_new_patron | Patron | YES | YES | Zamítnutá žádost | 47 | OK
returned_new_patron_reminder_1 | Parent | YES | YES | Najděte nového Patrona | 96 | CHECK_PARSE
returned_new_patron_reminder_2 | Parent | YES | YES | Najděte nového Patrona | 97 | CHECK_PARSE
scoring | Parent | NO | YES | Posuzujeme | 18 | OK
scoring | Patron | NO | NO | Posuzujeme | 54 | CHECK_PARSE
scoring_ko | Parent | YES | YES | Neschváleno | 20 | CHECK_PARSE
scoring_ko | Patron | YES | YES | Neschváleno | 56 | OK
scoring_ok | Parent | NO | NO | Vaše žádost byla schválena | 19 | OK
scoring_ok | Patron | NO | NO | Žádost byla schválena | 55 | OK
scoring_waiting | Parent | NO | NO | Posuzujeme | 21 | OK
scoring_waiting | Patron | NO | NO | Čekáme na doplnění žádosti | 57 | OK
suspended | Parent | NO | YES | Pozastaveno | 17 | OK
suspended | Patron | NO | YES | Pozastaveno | 52 | OK
suspended_campaign | Parent | NO | NO | Pozastaveno | 23 | OK
suspended_campaign | Patron | NO | NO | Pozastaveno | 60 | OK
to_check | Parent | YES | YES | Žádost zpracováváme; Zpracováváme | 15,93,130 | CHECK_PARSE
to_check | Patron | YES | YES | Zpracováváme | 48,90,129 | OK
uncompleted | Parent | NO | YES | Nesplněný příběh | 25 | CHECK_PARSE
uncompleted | Patron | NO | NO | Nesplněný příběh | 63 | OK
waiting | Parent | YES | YES | Doplňte informace do žádosti | 95 | CHECK_PARSE
waiting | Patron | NO | NO | Čekáme na informace od žadatele | 50 | OK
waiting_feedback_reminder_1 | Parent | YES | YES | Přidejte poděkování vašim dárcům | 116 | CHECK_PARSE
waiting_feedback_reminder_1 | Patron | NO | NO | Čekáme na zpětnou vazbu | 119 | OK
waiting_feedback_reminder_2 | Parent | YES | YES | Přidejte poděkování vašim dárcům | 117 | CHECK_PARSE
waiting_feedback_reminder_2 | Patron | YES | NO | Čekáme na zpětnou vazbu | 120 | OK
waiting_feedback_uncooperative | Parent | NO | NO | Přidejte poděkování vašim dárcům | 118 | OK
waiting_feedback_uncooperative | Patron | NO | NO | Chybí nám zpětná vazba | 121 | OK
waiting_for_bill | Parent | NO | NO | Čekáme na účetní doklad | 28 | OK
waiting_for_bill | Patron | NO | NO | Dar je na cestě | 70 | OK
waiting_for_feetback | Parent | YES | YES | Pošlete své poděkování dárcům | 6 | CHECK_PARSE
waiting_for_feetback | Patron | NO | NO | Čekáme na zpětnou vazbu | 71 | OK
waiting_for_fundraiser | Parent | NO | YES | Doplňte žádost | 92 | CHECK_PARSE
waiting_for_fundraiser | Patron | YES | YES | Čekáme na zákonného zástupce | 86 | CHECK_PARSE
waiting_for_patron | Parent | YES | YES | Čekáme na Patrona | 14 | OK
waiting_for_patron | Patron | NO | YES | Doplňte žádost | 44 | CHECK_PARSE
waiting_for_protocol | Parent | YES | YES | Doplňte Protokol o daru | 5 | CHECK_PARSE
waiting_for_protocol | Patron | NO | YES | Čekáme na potvrzení převzetí daru | 68 | OK
waiting_reminder_1 | Parent | YES | YES | Doplňte informace do žádosti | 98 | CHECK_PARSE
waiting_reminder_1 | Patron | NO | NO | Čekáme na informace od žadatele | 106 | OK
waiting_reminder_2 | Parent | YES | YES | Doplňte informace do žádosti | 99 | CHECK_PARSE
waiting_reminder_2 | Patron | YES | NO | Čekáme na informace od žadatele | 107 | CHECK_PARSE
waiting_signature | Parent | YES | YES | Nahrajte smlouvu | 4 | CHECK_PARSE
waiting_signature | Patron | NO | YES | Smlouva k podpisu | 65 | OK
waiting_signature_reminder_1 | Parent | YES | NO | Nahrajte smlouvu | 110 | CHECK_PARSE
waiting_signature_reminder_1 | Patron | NO | NO | Smlouva k podpisu | 111 | OK
waiting_signature_reminder_2 | Parent | YES | YES | Nahrajte smlouvu | 114 | CHECK_PARSE
waiting_signature_reminder_2 | Patron | YES | NO | Smlouva k podpisu | 112 | OK
waiting_signature_uncooperative | Parent | NO | YES | Potvrďte smlouvu pro {application:child:name} | 115 | OK
waiting_signature_uncooperative | Patron | NO | NO | Čekáme na podpis smlouvy | 113 | OK

### SHEET: Filling Notes  (11 řádků)
What was added | Details
New scenario columns | Email Donor, Notification Donor, Source / Notification Notes were added to scena…
Source of Parent/Patron YES/NO | Parent/Patron flags are based on application_reaction.csv via reaction_key_field…
Donor communications | Donor flags are marked only where the test scenario explicitly describes donor p…
CHECK_PARSE | Some application_reaction rows contain HTML/newlines and were marked CHECK_PARSE…
Important caveat | This is a best-effort functional fill for testing. Rows labelled as broad integr…
  ·
Doplnění po kontrole
'Chyba' je procesní stav / status message v application reactions, nikoli chyba …
RAW_CHECK znamená pouze to, že řádek z application_reaction.csv bylo vhodné ověř…
Sloupce Email Donor / Notification Donor zůstávají ve všech listech jednotně. V …

