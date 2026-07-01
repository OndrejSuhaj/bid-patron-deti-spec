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
Field | Fill In
Process Name | APPLICANT - BACK PART
Country / Team | CZ
Process Owner | Dita Kubisková - Coordinator BACK
Date | 2026-02-13 00:00:00
Process Goal (What is the output?) | MAPPING THE STEPS AND PROCESSES FROM THE END OF THE COLLECTION TO THE CLOSING OF…
Process Start (What triggers it?) | END OF COLLECTION
Process End (When is it finished?) | CLOSING THE APPLICATION

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

### SHEET: 2_Roles_EN  (21 řádků)
Role Name | Description (optional)
✅ KDOKOLI NEBO COKOLI KDO VYKONÁVÁ AKCI V PROCESU ( NEPÍŠEME JMÉNA OSOB, ALE JEJ…
To znamená, že to může být
👤 osoba - KOORDINÁTOR
👥 funkce / pozice - ŘEDITEL
🤖 systém - např. IT systém, mautic, atd
🏢 externí subjekt
  ·
  ·
parent | legal representative of the child
patron | An organization or individual actively cooperating in the submission of a fundra…
IT system | Backend
Notification | Backend + Mautic
coodinator FRONT | Coordinator responsible for processing applications from receipt to submission f…
coordinator BACK | Coordinator responsible for processing applications from the end of the collecti…
operations manager | Manager, responsible for project operations and processes
financial manager | Manager responsible for financial transactions from public collections
Supplier | An individual or organization that supplies services or goods
CONTENT coordinator | Coordinator responsible for processing the story and publishing it on the websit…
INFO coordinator | Coordinator responsible for communation with clients (info@patrondeti.cz)
Bank | banking system

### SHEET: 3_Process_Steps_CZ  (48 řádků)
Step Process Number | Role Responsible | Step Description (Start with a verb) | Manual / Automated | System Used (if any) | Status | Notifikace email ZZ | Notifikace email Patron | Zobrazení v zóně ZZ | Zobrazení v zóně Patrona | MUST HAVE/NICE TO HAVE
  ·
 | ✅ vyberu z listu ROLE | ✅ Napíši aktivní sloveso - používejte přítomný čas, 3. osoba jednotného čísla |  | ✅ Napíši jaký systém je použit, nebo píšu Bez systému. Políčko nenechávám prázdn…
1 | IT systém | Vyhodnotí stav sbírky | automaticky | BE |  |  |  |  |  | MUST HAVE
1a | IT systém | Identifikuje příběh jako splněný (100 % daru) | automaticky | BE | Splněný příběh | ano | ano | ano | ano | MUST HAVE
1b | IT systém | Identifikuje příběh jako nesplněný (ze 100% ) | automaticky | BE | Cílová částka nevybrána | ano | ano | ano | ano | MUST HAVE
2 | Provozní manažer | Vytvoří u splněných příběhů smlouvu | manuálně | BE | Smlouva ke schválení | ne | ne | ano | ano | MUST HAVE
3 | Provozní manažer/IT systém | Podepíše smlouvu a odešlě ZZ k podpisu | manuálně/automaticky | BE | Čeká na podpis | ano | ne | ano | ano | MUST HAVE
4 | IT systém | Odešle ZZ 1. urgenci k podpisu | automaticky | BE | Čeká na podpis - 1. urgence | ano | ne | ano | ano | MUST HAVE
5 | IT systém | Odešle ZZ 2. urgenci k podpisu | automaticky | BE | Čeká na podpis - 2. urgence | ano | ne | ano | ano | NICE TO HAVE
6 | IT systém | Identifikuje smlouvu jako nepodepsanou | automaticky | BE | Čeká na podpis - nespolupracující | ne | ne | ano | ano | MUST HAVE
7 | Koordinátor FRONT | Kontaktuje ZZ a Patrona | manuálně | email/call |  |  |  |  |  | NICE TO HAVE
8 | Zákonný zástupce | Podepíše smlouvu | zóna/manuálně | BE/email | Smlouva podepsána žadatelem | ano | ne | ano | ano | MUST HAVE
9 | Zákonný zástupce | Pošle ručně podepsanou smlouvu na info linku | manuálně | email |  |  |  |  |  | NICE TO HAVE
10 | Info koordinátor | Vloží ručně podepsanou smlouvu do žádosti | manuálně | BE | Smlouva podepsána žadatelem | ano | ne | ano | ano | NICE TO HAVE
11 | Zákonný zástupce | Odmítne podpsat smlouvu | manuálně | email/call | Čeká na podpis - nespolupracující | ne | ne | ano | ano | MUST HAVE
12 | Provozní manažer | Vypořádá dary u nepodepsané smlouvy | manuálně | BE | Zrušený příběh | ano | ano | ano | ano | MUST HAVE
13 | Koordinátor FRONT | Nesplěněný příběh (0%) ruší rezervaci u dodavatele a příběh | manuálně | BE/email | Zrušený příběh | ano | ano | ano | ano | MUST HAVE
14 | Koordinátor FRONT | Nesplněný příběh (1 a více %) kontaktuje ZZ | manuálně | email/call |  |  |  |  |  | MUST HAVE
14a | Koordinátor FRONT | Identifikuje příběh jako částečně splněný | manuálně | BE | Splněný příběh - částečné plnění | ne | ne | ne | ne | MUST HAVE
14b | Koordinátor FRONT | Identifikuje příběh jako nesplněný(dar nelze pořídit) | manuálně | BE | Nesplněný příběh - vypořádání daru | ne | ne | ano | ano | MUST HAVE
15 | Provozní manažer | Vypořádá dary z nesplněného příběhu | manuálně | BE | Nesplněný příběh | ne | ne | ano | ano | MUST HAVE
16 | Koordinátor BACK | Potvrzuje objednávku u dodavatele (žádá o účetní doklad k úhradě) | manuálně | email | Čeká na účetní doklad | ne | ne | ano | ano | MUST HAVE
17 | Koordinátor BACK | Kontroluje účetní doklad | manuálně | email |  |  |  |  |  | MUST HAVE
17a | Koordinátor BACK | Vrací chybný účetní doklad zpět dodavateli k opravě | manuálně | email |  |  |  |  |  | MUST HAVE
17b | Koordinátor BACK | Zasílá doklad k úhradě Finanční manažerce | manuálně | BE | Úhrada daru | ne | ne | ano | ano | MUST HAVE
18 | Finanční manažer | Hradí 1 účetní doklad | manuálně | banka | Dar uhrazen | ne | ne | ano | ano | MUST HAVE
19 | Finanční manažer | Hradí 1 z více účetních dokladů (čekáme na další doklady k úhradě) | manuálně | BE | Čeká na účetní doklad | ne | ne | ano | ano | MUST HAVE
20 | Finanční manažer | V případě úhrady celé částky příběhu mění status | manuálně | BE | Čeká na zpětnou vazbu | ano | ne | ano | ano | MUST HAVE
21 | IT systém | Odešlě 1. urgenci ZZ k doplnění ZV (14 dnu) | automaticky | BE | Čeká na zpětnou vazbu - 1. urgence | ano | ne | ano | ano | MUST HAVE
22 | IT systém | Odešlě 2. urgenci ZZ k doplnění ZV (14+14 dnu) | automaticky | BE | Čeká na zpětnou vazbu - 2. urgence | ano | ano | ano | ano | NICE TO HAVE
23 | IT systém | Identifikuje ZV jako nedodanou (14+14+30) | automaticky | BE | Čeká na zpětnou vazbu - nespolupracující | ne | ne | ano | ano | MUST HAVE
24 | Content koordinator | Posílá univerzální zpětnou vazbu dárcům u nedodané ZV | manuálně | BE/email | Zpětná vazba odeslána |  |  |  |  | MUST HAVE
25 | Content koordinator | Posílá dodanou zpětnou vazbu od ZZ dárcům | manuálně | BE/email | Zpětná vazba odeslána |  |  |  |  | MUST HAVE
26 | Koordinátor BACK | Urguje nedodané účetní doklady emailem | manuálně | email/call |  |  |  |  |  | MUST HAVE
27 | Koordinátor BACK | Urguje konečné účetní doklady emailem | manuálně | email/call | Čeká na konečný doklad | ne | ne | ano | ano | MUST HAVE
28 | Koordinátor BACK | Uzavírá žádost po dodání zpětné vazby a správnosti dokladů, když je splněný příb… | manuálně | BE | Uzavřeno |  |  | ano | ano | MUST HAVE
28a | Koordinátor BACK | Uzavírá žádost po dodání zpětné vazby a správnosti dokladů, když je částečně spl… | manuálně | BE | Uzavřeno - částečné plnění |  |  | ano | ano | MUST HAVE
29 | Operations manager | Zaeviduje vrácenou částku za nevyčerpané služby nebo vrácené zboží | manually | excel |  |  |  |  |  | MUST HAVE
30 | Coordinator BACK | Kontaktuje rodiče s dotazem využití finančních prostředků nad 2000,- Kč u stávaj… | manually | email |  |  |  |  |  | NICE TO HAVE
31 | Coordinator BACK | Předá žádost k opakovanému schválení risk managerovi, pokud dochází ke změne dar… | manually | email |  |  |  |  |  | NICE TO HAVE
32 | Risk manager | Schválí nového dodavatele nebo změnu daru | manually | email |  |  |  |  |  | NICE TO HAVE
33 | Coordinator BACK | Žádá o doklad k úhradě nového dodavatele | manually | email |  |  |  |  |  | NICE TO HAVE
34 | Supplier | Pošle účetní doklad k úhradě | manually | email |  |  |  |  |  | NICE TO HAVE
35 | Coordinator BACK | Předá doklad k úhradě Finanční manažerce | manually | email |  |  |  |  |  | NICE TO HAVE
36 | Coordinator BACK | Předá dobropis od původního dodavatele Finanční manažerce | manually | email |  |  |  |  |  | MUST HAVE
37 | Financial manager | Hradí účetní doklad k vratce | manually | banka |  |  |  |  |  | NICE TO HAVE
38 | Operations manager | v případě nevyužití vratky rozpustí vrácenou částku od dodvatele na jiné příběhy… | manually | BE/email | dle stavu žádosti |  |  |  |  | MUST HAVE

### SHEET: 3_Process_Steps_EN  (50 řádků)
Step Process Number | Role Responsible | Step Description (Start with a verb) | Manual / Automated | System Used (if any) | Status | Notification e-mail parent | Notification e-mail patron | Visible in parent zone | Visible in patron zone | MUST HAVE/NICE TO HAVE
  ·
 | ✅ vyberu z listu ROLE | ✅ Napíši aktivní sloveso - používejte přítomný čas, 3. osoba jednotného čísla |  | ✅ Napíši jaký systém je použit, nebo píšu Bez systému. Políčko nenechávám prázdn…
 | IT system | ends the collection /based on amount or time/ and blurs photos of children at th… | automatically
1 | IT system | evaluates the collection status based on collected amount | automatically | BE |  |  |  |  |  | MUST HAVE
1a | IT system | Identifies the story as completed (100% of the donation) | automatically | BE | Splněný příběh / Fulfilled story | yes | yes | yes | yes | MUST HAVE
1b | IT system | Identifies the story as unfulfilled (less than 100%) | automatically | BE | Cílová částka nevybrána / Target amount not reached | yes | yes | yes | yes | MUST HAVE
2 | Operations manager | Creates a contract for completed stories | manually/IT system | BE | Smlouva ke schválení / Contract for approval | no | no | yes | yes | MUST HAVE
3 | Operations manager/IT | Signs the contract and send it to the parent for signature | manually/automatically | BE | Čeká na podpis/Awaiting signature | yes | no | yes | yes | MUST HAVE
4 | IT system | Sends parents the first reminder to sign (2days) | automatically | BE | Čeká na podpis - 1. urgence /Awaiting signature 1st reminder | yes | no | yes | yes | MUST HAVE
5 | IT system | Sends parents the second reminder to sign (2+5 days) | automatically | BE | Čeká na podpis - 2. urgence / Awaiting signature 2nd reminder | yes | no | yes | yes | NICE TO HAVE
6 | IT system | Identifies the contract as unsigned (2+5+7) | automatically | BE | Čeká na podpis - nespolupracující / Awaiting signature - non-cooperative | no | no | yes | yes | MUST HAVE
7 | Coordinator FRONT | contacts parent and Patron | manually | email/call |  |  |  |  |  | NICE TO HAVE
8 | parent | signs the contract | zone/manually | BE/email | Smlouva podepsána žadatelem / Contract signed | yes | no | yes | yes | MUST HAVE
9 | parent | Sends the hand-signed contract to the info line | manually | email |  |  |  |  |  | NICE TO HAVE
10 | INFO coordinator | Attaches a hand-signed contract to the application | manually | BE | Smlouva podepsána žadatelem / Contract signed | yes | no | yes | yes | NICE TO HAVE
11 | parent | Refuses to sign the contract | manually | email/call | Čeká na podpis - nespolupracující / Awaiting signature - non-cooperative | no | no | yes | yes | MUST HAVE
12 | Operations manager | realocates gifts in the case of an unsigned contract | manually | BE | Zrušený příběh / Cancelled story | yes | yes | yes | yes | MUST HAVE
13 | Coordinator FRONT | Unfulfilled story (0%) cancels the reservation with the supplier and the story | manually | BE/email | Zrušený příběh / Cancelled story | yes | yes | yes | yes | MUST HAVE
14 | Coordinator FRONT | Unfulfilled story with the  amount (to be discussed individually) , contacts par… | manually | email/call |  |  |  |  |  | MUST HAVE
14a | Coordinator FRONT | Identifies the story as partly fulfilled | manually | BE | Splněný příběh - částečné plnění / Fulfilled story - partial fulfillment | no | no | no | no | MUST HAVE
14b | Coordinator FRONT | Identifies the story as unfulfilled (the gift cannot be purchased) | manually | BE | Nesplněný příběh - vypořádání darů / Unfulfilled Story - redistribuition ofa the… | no | no | yes | yes | MUST HAVE
15 | Operations manager | realocates gifts (unfulfilled story with not sufficient amount) | manually | BE | Nesplněný příběh / Unfulfilled Story | no | no | yes | yes | MUST HAVE
16 | Coordinator BACK | Confirms the order with the supplier (requests an accounting document for paymen… | manually | email | Čeká na účetní doklad / Waiting for accounting document | no | no | yes | yes | MUST HAVE
17 | Coordinator BACK | Checks accounting documents | manually | email |  |  |  |  |  | MUST HAVE
17a | Coordinator BACK | Returns the incorrect accounting document to the supplier for correction. | manually | email |  |  |  |  |  | MUST HAVE
17b | Coordinator BACK | Sends the payment document to the Financial Manager | manually | BE | Úhrada daru / Payment of donation | no | no | yes | yes | MUST HAVE
18 | Financial manager | Pays 1 accounting document | manually | banka | Dar uhrazen / Donation paid | no | no | yes | yes | MUST HAVE
19 | Financial manager | Pays 1 of several accounting documents (we are waiting for further documents for… | manually | BE | Čeká na účetní doklad / Waiting for accounting document | no | no | yes | yes | MUST HAVE
20 | Financial manager | In the payment is for the full amount, changes the status | manually | BE | Čeká na zpětnou vazbu / Waiting for feedback | yes | no | yes | yes | MUST HAVE
21 | IT system | Sent 1st reminder to parent to complete feedback (14 days) | automatically | BE | Čeká na zpětnou vazbu - 1. urgence / Waiting for feedback 1st reminder | yes | no | yes | yes | MUST HAVE
22 | IT system | Sent 2nd reminder to parent to complete feedback (14+14 days) | automatically | BE | Čeká na zpětnou vazbu - 2. urgence / Waiting for feedback 2nd reminder | yes | yes | yes | yes | NICE TO HAVE
23 | IT system | Identifies feedback as undelivered (14+14+30 days) | automatically | BE | Čeká na zpětnou vazbu - nespolupracující / Waiting for feedback - non - cooperat… | no | no | yes | yes | MUST HAVE
24 | CONTENT coordinator | Sends universal feedback to donors for undelivered feedback | manually | BE/email | Zpětná vazba odeslána / Feedback sent | no | no | yes | yes | MUST HAVE
25 | CONTENT coordinator | Sends feedback from parent to donors | manually | BE/email | Zpětná vazba odeslána / Feedback sent | no | no | yes | yes | MUST HAVE
26 | Coordinator BACK | Urges missing accounting documents by email | manually | email/call |  |  |  |  |  | MUST HAVE
27 | Coordinator BACK | Urges final accounting documents by email | manually | email/call | Čeká na konečný doklad / Waiting for final documentation | no | no | no | no | MUST HAVE
28 | Coordinator BACK | Closes the request after receiving feedback and verifying the accuracy of the do… | manually | BE | Uzavřeno / Closed | no | no | yes | yes | MUST HAVE
28a | Coordinator BACK | Closes the request after receiving feedback and confirming the accuracy of the d… | manually | BE | Uzavřeno - částečné plnění / Closed - partial fulfillment | no | no | yes | yes | MUST HAVE
29 | IT system | deletes all obligatory attachements from the application | automatically |  |  |  |  |  |  | MUST HAVE
30 | Operations manager | Records the refunded amount for unused services or returned goods | manually | excel |  |  |  |  |  | MUST HAVE
31 | Coordinator BACK | Contact parent  with a question regarding the use of funds exceeding CZK 2,000 w… | manually | email |  |  |  |  |  | NICE TO HAVE
32 | Coordinator BACK | Sends the request for reapproval to the risk manager if there is a change in the… | manually | email |  |  |  |  |  | NICE TO HAVE
33 | Risk manager | Approves a new supplier or change of donation | manually | email |  |  |  |  |  | NICE TO HAVE
34 | Coordinator BACK | Requests payment document for new supplier | manually | email |  |  |  |  |  | NICE TO HAVE
35 | Supplier | Send an accounting document for payment | manually | email |  |  |  |  |  | NICE TO HAVE
36 | Coordinator BACK | Submits the document for payment to the Financial Manager | manually | email |  |  |  |  |  | NICE TO HAVE
37 | Coordinator BACK | Sends the credit note from the original supplier to the Financial Manager. | manually | email |  |  |  |  |  | MUST HAVE
38 | Financial manager | Pays the accounting document for the refund | manually | banka |  |  |  |  |  | NICE TO HAVE
39 | Operations manager | If the refund is not used, redistributes the returned amount to other children's… | manually | BE/email |  |  |  |  |  | MUST HAVE

### SHEET: 4_Decisions  (6 řádků)
Decision Point Description / USE QUESTIONS | Step Process Number | Who Decides? | Criteria for Decision | What Happens if NO?
  ·
✅ Napíši krátká otázka | ✅ vyberu ČÍSLO z listu Process_Steps
Je sbírka ze 100% splněna? | 1 | IT systém | 100% daru vybráno | Koordinátor FRONT kontaktuje ZZ
Je smlouva o daru podepsána? | 8 | IT systém | smlouva podepsána | Koordinátor FRONT kontaktuje ZZ
Využije rodič vybranou částku u částečně splněného příběhu? | 14 | Zákonný zástupce | lze pořídit dar | Koordinátor FRONT přepíná status do nesplněný příběh - vypořádání daru

