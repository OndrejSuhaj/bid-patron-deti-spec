### SHEET: 1_Basic_Info_CZ  (8 řádků)
Field | Fill In
Process Name | ŽÁDOST - ZADEK/ BACK OFFICE
Country / Team | CZ
Process Owner | Dita Kubisková - KOORDINÁTOR BACK
Date | 2026-02-13 00:00:00
Process Goal (What is the output?) | ZMAPOVÁNÍ KROKŮ A PROCESŮ PŘI ZPRACOVÁNÍ ŽÁDOSTI OD UKONČENÍ SBÍRKY DO UZAVŘENÍ …
Process Start (What triggers it?) | UKONČENÍ SBÍRKY
Process End (When is it finished?) | UZAVŘENÍ ŽÁDOSTI

### SHEET: 1_Basic_Info_EN  (8 řádků)
Field | Fill In | Fill In |RO | Fill in - MD
Process Name | APPLICANT - BACK PART | APPLICATION - BACK | APPLICANT - BACK PART
Country / Team | CZ | RO | MD
Process Owner | Dita Kubisková - Coordinator BACK | MARIA - Executive director | Madalina - Operational Manager
Date | 2026-02-13 00:00:00 | 2026-03-05 00:00:00 | 2026-03-05 00:00:00
Process Goal (What is the output?) | MAPPING THE STEPS AND PROCESSES FROM THE END OF THE COLLECTION TO THE CLOSING OF… | Mapping of steps and processes after the fundraising stage has been finished | To manage and document the full back-office lifecycle of a beneficiary case afte…
Process Start (What triggers it?) | END OF COLLECTION | End of the fundraising stage | The process starts when a story with the status “Active History” approaches its …
Process End (When is it finished?) | CLOSING THE APPLICATION | Lead is closed | The process ends when the gift or support has been delivered to the beneficiary,…

### SHEET: 2_Roles_CZ  (21 řádků)
 | Description (optional)
✅ KDOKOLI NEBO COKOLI KDO VYKONÁVÁ AKCI V PROCESU ( NEPÍŠEME JMÉNA OSOB, ALE JEJ…
To znamená, že to může být
👤 osoba - KOORDINÁTOR
👥 funkce / pozice - ŘEDITEL
🤖 systém - např. IT systém, mautic, atd
🏢 externí subjekt
  ·
  ·
Rodič | zákonný zástupce dítěte
Patron | Organizace nebo jednotlivec aktivně spolupracující na podání žádosti o sbírku.
IT systém | Backend
Notifikace | Backend + Mautic
Koordinátor FRONT | Koordinator, který je zodpovědný za zpracování žádosti od převzetí do zveřejnění
Koordinátor BACK | Koordinator, který je zodpovědný za zpracování žádosti od ukončení sbírky do uza…
Provozní manažer | Provozní manažer, který je zodpovědný za provoz a procesy projektu
Finanční manažer | Finanční manažer, který je zodpovědný za finanční transakce z veřejné sbírky
Dodavatel | Osoba nebo organizace, která dodává služby nebo zboží
Content koordinátor | Koordinator, který je zodpovědný za zpracování příběhu a jeho zveřejnění na web …
Info koordinátor | Koordinator, který je zodpovědný za zpracování emailové korespondence
Banka | systém pro platby

### SHEET: 2_Roles_EN  (23 řádků)
Role Name | Description (optional) | Role Name |RO | Description (optional) |RO | Role Name - MD | Description (optional) - MD
✅ KDOKOLI NEBO COKOLI KDO VYKONÁVÁ AKCI V PROCESU ( NEPÍŠEME JMÉNA OSOB, ALE JEJ… |  | ✅ Anyone or anything that performs an action in the process (DO NOT write person… |  | ✅ Anyone or anything that performs an action in the process (DO NOT write person…
To znamená, že to může být |  | It can be : |  | It can be :
👤 osoba - KOORDINÁTOR |  | 👤 person - KOORDINÁTOR |  | 👤 person - KOORDINÁTOR
👥 funkce / pozice - ŘEDITEL |  | 👥 ffunction - Director |  | 👥 ffunction - Director
🤖 systém - např. IT systém, mautic, atd |  | 🤖 systém: IT system, Mautic, atc |  | 🤖 systém: IT system, Mautic, atc
🏢 externí subjekt |  | 🏢 external subject : audit, Tax advisor etc |  | 🏢 external subject : audit, Tax advisor etc
  ·
  ·
parent | legal representative of the child | parent | Represents the child's interests from a legal standpoint | Operational Manager | Oversees the operational workflow, generates reports on active stories approachi…
patron | An organization or individual actively cooperating in the submission of a fundra… | patron | Does not have an active role in the back part of the application. If patron is a… | Accountant | Processes financial transfers, records transactions in the accounting system, an…
IT system | Backend | IT system | Backend | Administrator (Admin) | Verifies the availability of funds, confirms procurement lists, and initiates th…
Notification | Backend + Mautic | Notification | Backend + Mautic | Premier Energy (Company / Board) | Reviews funding requests and authorizes the transfer of funds to the foundation’…
coodinator FRONT | Coordinator responsible for processing applications from receipt to submission f… | coodinator FRONT | Changes lead statuses if necessary and handles the info email | Content Manager | Prepares visual and written content related to fulfilled stories, saves the cont…
coordinator BACK | Coordinator responsible for processing applications from the end of the collecti… | coordinator BACK | Only handles contract creation
operations manager | Manager, responsible for project operations and processes | operations manager | Manager, responsible for project operations and processes
financial manager | Manager responsible for financial transactions from public collections | Acquisitions specialist | Handles the application back, appart from the contract signing, also including t…
Supplier | An individual or organization that supplies services or goods | Supplier | An individual or organization that supplies services or goods
Content coordinator | Coordinator responsible for processing the story and publishing it on the websit… | Content | Coordinator responsible for processing the story and publishing it on the websit…
INFO coordinator | Coordinator responsible for communation with clients (info@patrondeti.cz) | Info coordinator | We do not have this position
Bank | banking system | Bank | banking system
 |  | Donors | Decide where to redistribute funds they donated in case the story is unsuccesful…
 |  | Accounting department of PE | Handle payment related issues and the relationship with the bank

### SHEET: 3_Process_Steps_CZ  (48 řádků)
Step Process Number | Role Responsible | Step Description (Start with a verb) | Manual / Automated | System Used (if any) | Status | Notifikace email ZZ | Notifikace email Patron | Zobrazení v zóně ZZ | Zobrazení v zóně Patrona
  ·
 | ✅ vyberu z listu ROLE | ✅ Napíši aktivní sloveso - používejte přítomný čas, 3. osoba jednotného čísla |  | ✅ Napíši jaký systém je použit, nebo píšu Bez systému. Políčko nenechávám prázdn…
1 | IT systém | Vyhodnotí stav sbírky | automaticky | BE
1a | IT systém | Identifikuje příběh jako splněný (100 % daru) | automaticky | BE | Splněný příběh | ano | ano | ano | ano
1b | IT systém | Identifikuje příběh jako nesplněný (ze 100% ) | automaticky | BE | Cílová částka nevybrána | ano | ano | ano | ano
2 | Provozní manažer | Vytvoří u splněných příběhů smlouvu | manuálně | BE | Smlouva ke schválení | ne | ne | ano | ano
3 | Provozní manažer/IT systém | Podepíše smlouvu a odešlě ZZ k podpisu | manuálně/automaticky | BE | Čeká na podpis | ano | ne | ano | ano
4 | IT systém | Odešle ZZ 1. urgenci k podpisu | automaticky | BE | Čeká na podpis - 1. urgence | ano | ne | ano | ano
5 | IT systém | Odešle ZZ 2. urgenci k podpisu | automaticky | BE | Čeká na podpis - 2. urgence | ano | ne | ano | ano
6 | IT systém | Identifikuje smlouvu jako nepodepsanou | automaticky | BE | Čeká na podpis - nespolupracující | ne | ne | ano | ano
7 | Koordinátor FRONT | Kontaktuje ZZ a Patrona | manuálně | email/call
8 | Zákonný zástupce | Podepíše smlouvu | zóna/manuálně | BE/email | Smlouva podepsána žadatelem | ano | ne | ano | ano
9 | Zákonný zástupce | Pošle ručně podepsanou smlouvu na info linku | manuálně | email
10 | Info koordinátor | Vloží ručně podepsanou smlouvu do žádosti | manuálně | BE | Smlouva podepsána žadatelem | ano | ne | ano | ano
11 | Zákonný zástupce | Odmítne podpsat smlouvu | manuálně | email/call | Čeká na podpis - nespolupracující | ne | ne | ano | ano
12 | Provozní manažer | Vypořádá dary u nepodepsané smlouvy | manuálně | BE | Zrušený příběh | ano | ano | ano | ano
13 | Koordinátor FRONT | Nesplěněný příběh (0%) ruší rezervaci u dodavatele a příběh | manuálně | BE/email | Zrušený příběh | ano | ano | ano | ano
14 | Koordinátor FRONT | Nesplněný příběh (1 a více %) kontaktuje ZZ | manuálně | email/call
14a | Koordinátor FRONT | Identifikuje příběh jako částečně splněný | manuálně | BE | Splněný příběh - částečné plnění | ne | ne | ne | ne
14b | Koordinátor FRONT | Identifikuje příběh jako nesplněný(dar nelze pořídit) | manuálně | BE | Nesplněný příběh - vypořádání daru | ne | ne | ano | ano
15 | Provozní manažer | Vypořádá dary z nesplněného příběhu | manuálně | BE | Nesplněný příběh | ne | ne | ano | ano
16 | Koordinátor BACK | Potvrzuje objednávku u dodavatele (žádá o účetní doklad k úhradě) | manuálně | email | Čeká na účetní doklad | ne | ne | ano | ano
17 | Koordinátor BACK | Kontroluje účetní doklad | manuálně | email
17a | Koordinátor BACK | Vrací chybný účetní doklad zpět dodavateli k opravě | manuálně | email
17b | Koordinátor BACK | Zasílá doklad k úhradě Finanční manažerce | manuálně | BE | Úhrada daru | ne | ne | ano | ano
18 | Finanční manažer | Hradí 1 účetní doklad | manuálně | banka | Dar uhrazen | ne | ne | ano | ano
19 | Finanční manažer | Hradí 1 z více účetních dokladů (čekáme na další doklady k úhradě) | manuálně | BE | Čeká na účetní doklad | ne | ne | ano | ano
20 | Finanční manažer | V případě úhrady celé částky příběhu mění status | manuálně | BE | Čeká na zpětnou vazbu | ano | ne | ano | ano
21 | IT systém | Odešlě 1. urgenci ZZ k doplnění ZV | automaticky | BE | Čeká na zpětnou vazbu - 1. urgence | ano | ne | ano | ano
22 | IT systém | Odešlě 2. urgenci ZZ k doplnění ZV | automaticky | BE | Čeká na zpětnou vazbu - 2. urgence | ano | ano | ano | ano
23 | IT systém | Identifikuje ZV jako nedodanou | automaticky | BE | Čeká na zpětnou vazbu - nespolupracující | ne | ne | ano | ano
24 | Content koordinator | Posílá univerzální zpětnou vazbu dárcům u nedodané ZV | manuálně | BE/email | Zpětná vazba odeslána
25 | Content koordinator | Posílá dodanou zpětnou vazbu od ZZ dárcům | manuálně | BE/email | Zpětná vazba odeslána
26 | Koordinátor BACK | Urguje nedodané účetní doklady emailem | manuálně | email/call
27 | Koordinátor BACK | Urguje konečné účetní doklady emailem | manuálně | email/call | Čeká na konečný doklad | ne | ne | ano | ano
28 | Koordinátor BACK | Uzavírá žádost po dodání zpětné vazby a správnosti dokladů, když je splněný příb… | manuálně | BE | Uzavřeno |  |  | ano | ano
28a | Koordinátor BACK | Uzavírá žádost po dodání zpětné vazby a správnosti dokladů, když je částečně spl… | manuálně | BE | Uzavřeno - částečné plnění |  |  | ano | ano
29 | Operations manager | Zaeviduje vrácenou částku za nevyčerpané služby nebo vrácené zboží | manually | excel
30 | Coordinator BACK | Kontaktuje rodiče s dotazem využití finančních prostředků nad 2000,- Kč u stávaj… | manually | email
31 | Coordinator BACK | Předá žádost k opakovanému schválení risk managerovi, pokud dochází ke změne dar… | manually | email
32 | Risk manager | Schválí nového dodavatele nebo změnu daru | manually | email
33 | Coordinator BACK | Žádá o doklad k úhradě nového dodavatele | manually | email
34 | Supplier | Pošle účetní doklad k úhradě | manually | email
35 | Coordinator BACK | Předá doklad k úhradě Finanční manažerce | manually | email
36 | Coordinator BACK | Předá dobropis od původního dodavatele Finanční manažerce | manually | email
37 | Financial manager | Hradí účetní doklad k vratce | manually | banka
38 | Operations manager | v případě nevyužití vratky rozpustí vrácenou částku od dodvatele na jiné příběhy… | manually | BE/email | dle stavu žádosti

### SHEET: 3_Process_Steps_EN  (52 řádků)
Step Process Number | Role Responsible | Role Responsible   - RO - | Role Responsible   - MD | Step Description (Start with a verb) | Step Description (Start with a verb) |RO | Step Description (Start with a verb) - MD | Manual / Automated | Manual / Automated |RO | Manual / Automated - MD | System Used (if any) | System Used (if any) |RO | System Used (if any) - MD | Status | Status |RO | Status - MD | Notification e-mail parent | Notification e-mail parent |RO | Notification email parent MD | Notification e-mail patron | Notification e-mail patron |RO | Notification email patron MD | Visible in parent zone | Visible in parent zone |RO | Visible in patron zone | Visible in patron zone |RO
  ·
 | ✅ vyberu z listu ROLE | ✅ vyberu z listu ROLE |  | ✅ Napíši aktivní sloveso - používejte přítomný čas, 3. osoba jednotného čísla | ✅ Write an active verb – use present tense, 3rd person singular |  |  |  |  | ✅ Napíši jaký systém je použit, nebo píšu Bez systému. Políčko nenechávám prázdn… | ✅ write any system or without systém. Do not leave empty cell
 | IT system | IT system | - | ends the collection /based on amount or time/ and blurs photos of children at th… | Sends notification that the fundraising time has ended / that the full amount wa… |  | automatically | automatically
1 | IT system | IT system | - | evaluates the collection status based on collected amount | Checks if fundraising target was achieved / partly acieved / not achieved |  | automatically | automatically |  | BE | BE
1a | IT system | IT system | Operational Manager | Identifies the story as completed (100% of the donation) | Identifies the story as completed (100% of the donation) | Generates a report of stories with the status “Active History” that are close to… | automatically | automatically | Manually | BE | BE | BE | Splněný příběh / Fulfilled story | active | Active | yes | yes | No | yes | yes | no | yes | yes | yes | yes
1b | IT system | IT system | - | Identifies the story as unfulfilled (less than 100%) | Identifies the story as unfulfilled (less than 100%) | - | automatically | automatically |  | BE | BE |  | Cílová částka nevybrána / Target amount not reached | campaign_uncompleted |  | yes | yes |  | yes | yes |  | yes | yes | yes | yes
2 | Operations manager | Coordinator back | Coordinator | Creates a contract for completed stories | Checks and signs the contract, sending it to the executive director | Starts working on the list and maps the gifts so that orders can be placed from … | manually/IT system | manually/IT system | Manually | BE | BE | BE | Smlouva ke schválení / Contract for approval | contract (for approval) | Active | no | no | no | no | no | no | yes | yes | yes | yes
3 | Operations manager/IT | Operations manager/IT | Admin | Signs the contract and send it to the parent for signature | Signs the contract and send it to the parent for signature | Signs the contract and send it to the parent for signature | manually/automatically | manually/automatically | manually | BE | BE | BE | Čeká na podpis/Awaiting signature | waiting_signature | Active | yes | yes | no | no | no | no | yes | yes | yes | yes
4 | IT system | IT system | - | Sends parents the first reminder to sign (2days) | Sends parents the first reminder to sign (2days) | - | automatically | automatically |  | BE | BE |  | Čeká na podpis - 1. urgence /Awaiting signature 1st reminder | waiting_signature_reminder_1 |  | yes | yes |  | no | no |  | yes | yes | yes | yes
5 | IT system | IT system | - | Sends parents the second reminder to sign (2+5 days) | Sends parents the second reminder to sign (2+5 days) | - | automatically | automatically |  | BE | BE |  | Čeká na podpis - 2. urgence / Awaiting signature 2nd reminder | waiting_signature_reminder 2 |  | yes | yes |  | no | no |  | yes | yes | yes | yes
6 | IT system | IT system | - | Identifies the contract as unsigned (2+5+7) | Identifies the contract as unsigned (2+5+7) | - | automatically | automatically |  | BE | BE |  | Čeká na podpis - nespolupracující / Awaiting signature - non-cooperative | waiting_signature_uncooperative |  | no | no |  | no | no |  | yes | yes | yes | yes
7 | Coordinator FRONT | Acquisitions specialist | Coordinator | contacts parent and Patron | contacts parent and Patron | Confirms the selected gifts with the parents once again and finalizes the select… | manually | manually | manually | email/call | email/call | email/call |  |  | Active |  |  | yes |  |  | no
8 | parent | parent | parent | signs the contract | signs the contract | signs the contract | zone/manually | zone/manually | manually | BE/email | BE/email | meeting in person/email | Smlouva podepsána žadatelem / Contract signed | contract_signed | Story Succesfully Completed | yes | yes | yes | no | no | no | yes | yes | yes | yes
9 | parent | parent | parent | Sends the hand-signed contract to the info line | Sends the hand-signed contract to the info line | Sends the hand-signed contract to the info line | manually | manually | manually | email | email | email |  |  |  |  |  | yes
10 | INFO coordinator | Coordinator FRONT | Coordinator | Attaches a hand-signed contract to the application | Attaches a hand-signed contract to the application | Signs the contract with the parent at the moment of the gift delivery and saves … | manually | manually | manually | BE | BE | meeting in person/email | Smlouva podepsána žadatelem / Contract signed | contract_signed |  | yes | yes |  | no | no |  | yes | yes | yes | yes
11 | parent | parent | - | Refuses to sign the contract | Refuses to sign the contract |  | manually | manually |  | email/call | email/call | - | Čeká na podpis - nespolupracující / Awaiting signature - non-cooperative | waiting_signature_uncooperative |  | no | no |  | no | no |  | yes | yes | yes | yes
12 | Operations manager | Operations manager | - | realocates gifts in the case of an unsigned contract | realocates gifts in the case of an unsigned contract |  | manually | manually |  | BE | BE | - | Zrušený příběh / Cancelled story | canceled_campaign |  | yes | yes |  | yes | yes |  | yes | yes | yes | yes
13 | Coordinator FRONT | Coordinator FRONT | - | Unfulfilled story (0%) cancels the reservation with the supplier and the story | Cancels the story if unfulfilled |  | manually | manually |  | BE/email | BE/email | - | Zrušený příběh / Cancelled story | Zrušený příběh / Cancelled story |  | yes | yes |  | yes | yes |  | yes | yes | yes | yes
14 | Coordinator FRONT | Acquisitions specialist | - | Unfulfilled story with the  amount (to be discussed individually) , contacts par… | Unfulfilled story with the  amount (to be discussed individually) , contacts par… |  | manually | manually |  | email/call | email/call | -
14a | Coordinator FRONT | Acquisitions specialist | - | Identifies the story as partly fulfilled | Identifies the story as partly fulfilled |  | manually | manually |  | BE | BE | - | Splněný příběh - částečné plnění / Fulfilled story - partial fulfillment | completed_partly_1 |  | no | no |  | no | no |  | no | no | no | no
 |  | IT system | - |  | Sends email to donors in order to choose another story to redistribute the money… |  |  | automatically |  |  | BE/email | - |  | campaign_uncompleted (Unfulfilled Story - redistribuition of the gifts) |  |  | no |  |  | no |  |  | no |  | no
 |  | Donors | - |  | Decide where to redistribute funds they donated in case the story is unsuccesful… |  |  | manually |  |  | email | - |  | campaign uncompleted (Unfulfilled Story- redistribution of the gift)
14b | Coordinator FRONT | Acquisitions specialist | - | Identifies the story as unfulfilled (the gift cannot be purchased) | Identifies the story as unfulfilled (the gift cannot be purchased) |  | manually | manually | - | BE | BE |  | Nesplněný příběh - vypořádání darů / Unfulfilled Story - redistribuition ofa the… | campaign_uncompleted (Unfulfilled Story - redistribuition of the gifts) |  | no | no |  | no | no |  | yes | yes | yes | yes
15 | Operations manager | Operations manager | - | realocates gifts (unfulfilled story with not sufficient amount) | Redistributes money to the stories chosen by the donors |  | manually | manually | - | BE | BE |  | Nesplněný příběh / Unfulfilled Story | Nesplněný příběh / Unfulfilled Story |  | no | no |  | no | no |  | yes | yes | yes | yes
16 | Coordinator BACK | Acquisitions specialist | Admin | Confirms the order with the supplier (requests an accounting document for paymen… | Contacts the provider of the gift and places order / asks for the bill | Confirms the list, verifies the availability of funds, and initiates the procure… | manually | manually | Manually | email | email/call | email/call | Čeká na účetní doklad / Waiting for accounting document | waiting_for_bill | Active | no | no | no | no | no | no | yes | yes | yes | yes
17 | Coordinator BACK | Acquisitions specialist | Accountant | Checks accounting documents | Checks accounting documents | Makes the transfers and records the necessary information in the system. | manually | manually | Manually | email | email | email/call
17a | Coordinator BACK | Acquisitions specialist | Accountant | Returns the incorrect accounting document to the supplier for correction. | Returns the incorrect accounting document to the supplier for correction. | Returns the incorrect accounting document to the supplier for correction. | manually | manually | manually | email | email | email/call
17b | Coordinator BACK | Acquisitions specialist | Accountant | Sends the payment document to the Financial Manager | Sends the payment document to the Accounting department of PE | Sends the payment document to the Administrator | manually | manually | manually | BE | email | email | Úhrada daru / Payment of donation | gift_payment |  | no | no |  | no | no |  | yes | yes | yes | yes
18 | Financial manager | Accounting department of PE | Admin | Pays 1 accounting document | Pays 1 accounting document | Ensures the funds are available in the bank account; otherwise, sends an officia… | manually | manually | manually | banka | bank | bank | Dar uhrazen / Donation paid | gift_paid |  | no | no |  | no | no |  | yes | yes | yes | yes
19 | Financial manager | Accounting department of PE | Admin | Pays 1 of several accounting documents (we are waiting for further documents for… | Waits for the final bill if a pro forma invoice was issued before payment | Ensures the funds are available in the bank account; otherwise, sends an officia… | manually | manually | manually | BE | bank | bank | Čeká na účetní doklad / Waiting for accounting document | waiting_for_final_doc |  | no | no |  | no | no |  | yes | yes | yes | yes
20 | Financial manager | Acquisitions specialist | - | In the payment is for the full amount, changes the status | Changes status into waiting_for_feedback | - | manually | manually |  | BE | BE |  | Čeká na zpětnou vazbu / Waiting for feedback | waiting_for_feedback |  | yes | yes |  | no | no |  | yes | yes | yes | yes
21 | IT system | IT system | - | Sent 1st reminder to parent to complete feedback (2 days) | Sent 1st reminder to parent to complete feedback (2 days) | - | automatically | automatically |  | BE | BE |  | Čeká na zpětnou vazbu - 1. urgence / Waiting for feedback 1st reminder | waiting_for_feedback_reminder_1 |  | yes | yes |  | no | no |  | yes | yes | yes | yes
22 | IT system | IT system | - | Sent 2nd reminder to parent to complete feedback (2 +5 days) | Sent 2nd reminder to parent to complete feedback (2 +5 days) | - | automatically | automatically |  | BE | BE |  | Čeká na zpětnou vazbu - 1. urgence / Waiting for feedback 2nd reminder | waiting_for_feedback_reminder_2 |  | yes | yes |  | yes | yes |  | yes | yes | yes | yes
23 | IT system | IT system | - | Identifies feedback as undelivered (2+5+7 days) | Identifies feedback as undelivered (2+5+7 days) | - | automatically | automatically |  | BE | BE |  | Čeká na zpětnou vazbu - nespolupracující / Waiting for feedback - non - cooperat… | waiting_feedback_uncooperative |  | no | no |  | no | no |  | yes | yes | yes | yes
24 | Content coordinator | --- | - | Sends universal feedback to donors for undelivered feedback | Did not happen until now |  | manually |  |  | BE/email |  |  | Zpětná vazba odeslána / Feedback sent |  |  | no |  |  | no |  |  | yes |  | yes
25 | Content coordinator | Content | Coordinator | Sends feedback from parent to donors | Transforms feedback into a thank you message and sends it to donors | Uses the content to provide feedback in cases where donations were made to that … | manually | manually | manually | BE/email | BE/email | email/social media | Zpětná vazba odeslána / Feedback sent | feedback_sent |  | no | no |  | no | no |  | yes | yes | yes | yes
26 | Coordinator BACK | Acquisitions specialist | Admin | Urges missing accounting documents by email | Urges missing accounting documents by email | Urges missing accounting documents by email | manually | manually | manually | email/call | email/call | email/call
27 | Coordinator BACK | Acquisitions specialist | - | Urges final accounting documents by email | Urges final accounting documents by email | - | manually | manually |  | email/call | email/call |  | Čeká na konečný doklad / Waiting for final documentation | waiting_for_final_doc |  | no | no |  | no | no |  | no | no | no | no
28 | Coordinator BACK | Acquisitions specialist | Operational Manager | Closes the request after receiving feedback and verifying the accuracy of the do… | Closes the request after receiving feedback and verifying the accuracy of the do… | Records the contract and the donation details in an internal document that is au… | manually | manually | manually | BE | BE | internal docs | Uzavřeno / Closed | closed | Story Succesfully Completed | no | no |  | no | no |  | yes | yes | yes | yes
28a | Coordinator BACK | Acquisitions specialist | - | Closes the request after receiving feedback and confirming the accuracy of the d… | Closes the request after receiving feedback and confirming the accuracy of the d… | - | manually | manually |  | BE | BE |  | Uzavřeno - částečné plnění / Closed - partial fulfillment | closed / closed_partly |  | no | no |  | no | no |  | yes | yes | yes | yes
29 | IT system | IT system | - | deletes all obligatory attachements from the application | deletes all obligatory attachements from the application | - | automatically | automatically
30 | Operations manager | Accounting department of PE | - | Records the refunded amount for unused services or returned goods | Records the refunded amount for unused services or returned goods | - | manually | manually |  | excel | excel
31 | Coordinator BACK | Acquisitions specialist | - | Contact parent  with a question regarding the use of funds exceeding CZK 2,000 w… | Contact parent  with a question regarding the use regardless of sum | - | manually | manually |  | email | email
32 | Coordinator BACK | Acquisitions specialist | - | Sends the request for reapproval to the risk manager if there is a change in the… | Sends the request for reapproval to the operational manager if there is a change… | - | manually | manually |  | email | email
33 | Risk manager | Operations manager | - | Approves a new supplier or change of donation | Approves a new supplier or change of donation | - | manually | manually |  | email | email
34 | Coordinator BACK | Acquisitions specialist | - | Requests payment document for new supplier | Requests payment document for new supplier | - | manually | manually |  | email | email
35 | Supplier | Supplier | - | Send an accounting document for payment | Send an accounting document for payment | - | manually | manually |  | email | email
36 | Coordinator BACK | Acquisitions specialist | - | Submits the document for payment to the Financial Manager | Submits the document for payment to the Accounting department of PE | - | manually | manually |  | email | email
37 | Coordinator BACK | Accounting department of PE | - | Sends the credit note from the original supplier to the Financial Manager. | Handles the credit note from the original supplier | - | manually | manually |  | email | email
38 | Financial manager | Accounting department of PE | - | Pays the accounting document for the refund | Pays the accounting document for the refund | - | manually | manually |  | banka | banka
39 | Operations manager | Operations manager |  | If the refund is not used, redistributes the returned amount to other children's… | If the refund is not used, redistributes the returned amount to other children's… | - | manually | manually |  | BE/email | BE/email

### SHEET: 4_Decisions  (6 řádků)
Decision Point Description / USE QUESTIONS | Step Process Number | Who Decides? | Criteria for Decision | What Happens if NO?
  ·
✅ Napíši krátká otázka | ✅ vyberu ČÍSLO z listu Process_Steps
Je sbírka ze 100% splněna? | 1 | IT systém | 100% daru vybráno | Koordinátor FRONT kontaktuje ZZ
Je smlouva o daru podepsána? | 8 | IT systém | smlouva podepsána | Koordinátor FRONT kontaktuje ZZ
Využije rodič vybranou částku u částečně splněného příběhu? | 14 | Zákonný zástupce | lze pořídit dar | Koordinátor FRONT přepíná status do nesplněný příběh - vypořádání daru

