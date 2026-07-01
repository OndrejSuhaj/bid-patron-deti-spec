### SHEET: 1_Basic_Info _ FINANCE_CZ  (9 řádků)
Field | Fill In
Process Name | FINANCE
Country / Team | CZ
Process Owner | Veronika Kunešová
Date | 2026-02-24 00:00:00
  ·
Process Goal (What is the output?) | Zajistit úhradu faktur a jiných dokladů k úhradě od dodavatelů služeb či předmět…
Process Start (What triggers it?) | Obdržením dokladu k úhradě ( faktura apod )(status "ÚHRADA DARU")
Process End (When is it finished?) | Přepnutím satusu "ČEKÁ NA ZPĚTNOU VAZBU" a archivací dokladů pro následné kontro…

### SHEET: 1_Basic_Info _ FINANCE_ENG  (8 řádků)
Field | Fill In | Field | Fill In
Process Name | FINANCE | Process Name | Finance
Country / Team | CZ | Country / Team | RO
Process Owner | Veronika Kunešová | Process Owner | Teodora Popescu
Date | 2026-02-24 00:00:00 | Date of presentaion | 2026-02-24 00:00:00
Process Goal (What is the output?) | Ensures payment of invoices and other payment documents from suppliers of servic… | Process Goal (What is the output?) | Ensuring an organised and efficient process for transfering the funds to the sup…
Process Start (What triggers it?) | Receiving any payment documents from the back office finance ( such as Invoice e… | Process Start (What triggers it?) | The parent signs the contract
Process End (When is it finished?) | when status is changed to “WAITING  FOR FEEDBACK” and the documents are further … | Process End (When is it finished?) | The process concludes once all administrative tasks are completed after the fund…

### SHEET: 2_Roles _ CZ  (16 řádků)
Role Name | Description (optional)
  ·
✅ KDOKOLI NEBO COKOLI KDO VYKONÁVÁ AKCI V PROCESU ( NEPÍŠEME JMÉNA OSOB, ALE JEJ…
To znamená, že to může být
👤 osoba - KOORDINÁTOR
👥 funkce / pozice - ŘEDITEL
🤖 systém - např. IT systém, mautic, atd
🏢 externí subjekt
  ·
Finanční manažer | Zajišťuje průběh úhrady faktur a připravuje povinné reporty zřizovateli veřejné …
Účetní Nadace Sirius | Účtuje došlé faktury od finanční manažerky prostřednictvím účetního systému
IT systém | Zajišťuje technické zpracování žádostí a zasílání notifikací
Účetní systím | Zajišťuje vedení účetnictví veřejné sbírky
Bankovní systém | Zajišťuje úhradu dokladů
Koordinátorka BACK | Zajišťuje administrativní kontrolu žádosti, sleduje stav vyplnění a komunikuje s…
Provozní manažerka | Zajištuje plynulý chod celé provozní části projektu

### SHEET: 2_Roles _ ENG  (17 řádků)
Role Name | Description (optional)
  ·
✅ Anyone or anything that performs an action in the process (DO NOT write person…
It can be :
👤 person - KOORDINÁTOR
👥 ffunction - Director
🤖 systém:  IT system, Mautic, atc
🏢 external subject : audit, Tax advisor etc
 |  | Role Name / RO | Description / RO
Financial Manager | Ensures the processing of invoice payments and prepares mandatory reports for th… | Parent | The person who initiates the request, seeking the Guarantor’s support in the app…
Accountant – Sirius Foundation | Records incoming invoices from the Financial Manager in the accounting system. | Supplier | A person or company that provides the therapies, equipment, or goods the foundat…
IT System | Handles the technical processing of applications and sends notifications. | IT systém | Handles the technical processing of applications and the distribution of notific…
Accounting System | Maintains the accounting of the public fundraising campaign. | Web | Offers the application form and provides access to the dedicated “zone” environm…
Banking System | Ensures payment of documents. | Procurement Specialist | Plans and manages all procurement activities to ensure the foundation obtains th…
Coordinator BACK | Ensures administrative checks of applications, monitors their status, and commun… | Accountant | Person responsible for transfering of funds and submission of financial document…
Operations Manager | Ensures the operation of the entire operational part of the project. | Risk Manager | Informally aproves supplier, price choice
 |  | Executive Director | Collaborates with the Executive Director on modifying contracts, discuss potenti…

### SHEET: 3_Process_Steps_CASE CZ  (18 řádků)
Step Process Number | Role Responsible | Step Description (Start with a verb) | Manual / Automated | System Used (if any) | Status (what ) | Notification email parent (YES / NO ) | Notification email Patron (YES / NO ) | Displayed in the Zone PARENT | Displayed in the Zone PATRON
  ·
 | ✅ vyberu z listu ROLE | ✅ Napíši aktivní sloveso - používejte přítomný čas, 3. osoba jednotného čísla |  | ✅ Napíši jaký systém je použit, nebo píšu Bez systému. Políčko nenechávám prázdn…
1 | Koordinátorka BACK | zašle e-mailem doklady k úhradě finanční manažerce | Manuálně | E-mail | Úhrada daru | ne | ne | ano | ano
2 | Finanční manažerka | stáhne report ze záložky "ÚHRADA DARU" a zkontroluje zaslané faktury s částkami … | Manuálně | Bez systému | - | - | - | - | -
3 | Finanční manažerka | provede úhradu dokladů v bance | Manuálně | Bankovní systém | Dar uhrazen | ne | ne | ano | ano
4 | Finanční manažerka | obdrží pouze jeden doklad k úhradě na příběh | Manuálně | IT systém | Čeká na zpětnou vazbu | ne | ne | ano | ano
5 | Finanční manažerka | obdrží více dodavatelů k úhradě na  příběh | Manuálně | IT systém | Čeká na účetní doklad | ano | ne | ano | ano
6 | Finanční manažerka | nahraje uhrazené doklady do účetního systému Nadace Sírius | Manuálně | Bez systému | - | - | - | - | -
7 | Provozní manažerka | zapíše průběžne do přehledu přijaté vratky na bankovní účet | Manuálně | Bez systému | - | - | - | - | -
8 | Finanční manažerka nebo Koo back | dohledá, ke kterému příběhu se vrácená částka vztahuje a následně rozhodne zda s…
9 | Finanční manažerka | zašle každý půlrok pokyn do IT ohledně nahrávání uhrazených dokladů do IT systém… | Manuálně | IT systém | - | - | - | - | -
10 | IT systém | doplní jednotlivé doklady k úhradě do systému k jednotlivým žádostem | Automaticky | IT systém | - | - | - | - | -
11 | Účetní Nadace Sírius | zašle měsíčně přehled nespárované banky | Manuálně | Bez systému | - | - | - | - | -
12 | Finanční manažerka | dohledá doklady k platbám | Manuálně | Bez systému
13 | Účetní Nadace Sírius | zašle čtvrtletně přehled zálohových plateb bez koncových dokladů | Manuálně | Bez systému | - | - | - | - | -
14 | Koordinátorka BACK | kontaktuje dodavatele ohledně dodání dokladů či zjišťuje situace, kdy bude služb… | Manuálně | Bez systému
15 | Účetní Nadace Sírius | zašle každý rok podklady pro kontrolu čerpání veřejné sbírky zřizovateli.  ( Poš… | Automaticky | IT systém | - | - | - | - | -

### SHEET: 3_Process_Steps_CASE ENG  (18 řádků)
Step Process Number | Role Responsible   CZ | Role responsible  RO | Step Description (Start with a verb)CZ | Step Description RO | Manual / Automated CZ | Manual / Automated  RO | System Used (if any) CZ | System Used RO | Status (what )CZ | Status RO | Notification email parent (YES / NO )CZ | Notification email paren RO | Notification email Patron (YES / NO )CZ |  | Displayed in the Zone PARENT CZ | Displayed in the Zone PARENT RO | Displayed in the Zone PATRON CZ | Displayed in the Zone PATRON RO
  ·
 | ✅ choose from ROLES |  | ✅ Write an active verb – use present tense, 3rd person singular |  |  |  | ✅ write any system or without systém. Do not leave empty cell
1 | Coordinator BACK | Acquisition Specialist | Sends payment documents to the financial manager by email | In the system, the specialist takes over stories with the status ' Signed contra… | Manually | Manual | E-mail | System | Donation Payment | Signed Contract | NO | no | NO | NO | YES | YES-Signed contract | YES | YES- Signed contract
2 | Financial Manager | Acquisition Specialist | Downloads the report from the “DONATION PAYMENT” tab and verifies the submitted … | Reviews the contract to confirm the gift and its price | Manually | Manual | No system | System | - | Awaiting for invoice/ accounting document | - | no | - | NO | - | YES- processing | - | YES- processing
3 | Financial Manager | Acquisition Specialist | Processes the payment of the documents in the bank. | Reaches out to the supplier to provide us the necessary invoice, changing the st… | Manually | Manual | Banking system | E-mail, Phone | Donation Paid | Awaiting for invoice/ accounting document | NO | no | NO | no | YES | YES- processing | YES | YES- processing
4 | Financial Manager | Acquisition Specialist | Receives only one payment document per story. | If correct, all the relevant information are compiled ( beneficiary name, IBAN, … | Manually | Manual | IT system | Excel/ Email | Waiting for feedback | Gift payment | NO | no | NO | no | YES | YES-Gift payment | YES | YES-Gift payment
5 | Financial Manager | Accountant | Receives multiple suppliers for payment related to one story. | The accountant is then in charge of making the payment and submitting the financ… | Manually | Manual | IT system | Banking system | Waiting for accountant documents | Gift payment | YES | no | NO | NO | YES | YES-Gift payment | YES | YES- The gift is on its way
6 | Financial Manager | Executive Director, Acquisition Specialist | Uploads paid documents into the Sírius Foundation accounting systém | In the rare event that a price/ supplier change occurs and there is no possibili… | Manually | Manual | No system | System | - | Waiting for signature | - | yes | - | YES | - | YES-Sign the contract | - | YES- Waiting for signature
7 | Operations Manager | Accountant, Acquisition Specialist | Records received refunds to the bank account on an ongoing basis in the overview… | The accountant confirms funds transfer via email, the acquisition specialist the… | Manually | Manual | No system | Email, System | - | Gift paid | - | yes | - | YES | - | YES-Gift procured | - | YES-The gift is on its way
8 | Financial Manager or Coordinator BACK | Acquisition Specialist | Identifies which story the refunded amount relates to and subsequently decides w… | To ensure that the physical goods have been delivered by the time the acquisitio… | Manually | Manual | No system | System |  | Waiting for feedback |  | yes |  | YES |  | YES-Provide feedback |  | YES- We're waiting for feedback
9 | Financial Manager |  | Sends instructions to the IT department every six months regarding the uploading… |  | Manually |  | IT system |  | - |  | - |  | - |  | - |  | -
10 | IT system |  | Uploads individual payment documents into the system under the respective applic… |  | Automatically |  | IT system |  | - |  | - |  | - |  | - |  | -
11 | Accountant – Sirius Foundation |  | Sends a monthly overview of unreconciled bank transactions. |  | Manually |  | No system |  | - |  | - |  | - |  | - |  | -
12 | Financial Manager |  | Identify supporting documents for the payments. |  | Manually |  | No system
13 | Accountant – Sirius Foundation |  | Sends a quarterly overview of advance payments without final supporting document… |  | Manually |  | No system |  | - |  | - |  | - |  | - |  | -
14 | Coordinator BACK |  | Contacts suppliers regarding the submission of supporting documents or checks wh… |  | Manuálně |  | Bez systému
15 | Accountant – Sirius Foundation |  | Sends annual documentation to the founder for the review of public fundraising e… |  | Automatically |  | IT system |  | - |  | - |  | - |  | - |  | -

### SHEET: 4_Decisions CASE CZ  (6 řádků)
Decision Point Description / USE QUESTIONS | Step Process Number | Who Decides? | Criteria for Decision | What Happens if NO?
  ·
✅ Napíši krátká otázka | ✅ vyberu ČÍSLO z listu Process_Steps
Co když dodavatel zašle doklad k úhradě s chybným bankovním spojení? | 2 | Finanční manažerka | Nejde zadat platba do bankovního systému nebo se platba  vrátí zpět na účet | Zpět na status "ČEKÁ NA ÚČETNÍ DOKLAD" a koordinátorka BACK kontaktuje dodavatel…
Obdrželi jsme všechny účetní doklady k příběhu? | 5 | Koordinátorka BACK | Příběh má více dodavatelů | Příběh se přesouvá na status "ČEKÁ NA ÚČETNÍ DOKLAD "
Je vrácená částka od dodavatele nižší než 2 000Kč? | 7 | částka vrácené platby | Vrácené platby pod 2 000Kč se přerozdělují na ostatní příběhy | Koordinátorka BACK oslovuje rodiče ohledně uplatnění vrácené částky  u jiného do…

### SHEET: 4_Decisions CASE ENG  (6 řádků)
Decision Point Description / USE QUESTIONS | Step Process Number | Who Decides? | Criteria for Decision | What Happens if NO?
  ·
✅ Write a short question | ✅ choose Number from Process_Steps list
What if the supplier sends a payment document with an incorrect bank account inf… | 2 | Financial Manager | Payment cannot be entered into the banking system or the payment is returned bac… | Back to the status "WAITING FOR ACCOUNTING DOCUMENT" and the  Coordinator BACK c…
Have we received all the accounting documents for the story? | 5 | Coordinator BACK | The story has multiple suppliers | The story moves to the status "WAITING FOR ACCOUNTING DOCUMENT"
Is the refund from the supplier less than 2,000 CZK? | 7 | refund amount | Refunds under 2,000 CZK are redistributed to other stories | Coordinator BACK contacts parents regarding refund application to another suppli…

