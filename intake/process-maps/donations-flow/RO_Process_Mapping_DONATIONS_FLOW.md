### SHEET: 1_Basic_Info_CZ  (8 řádků)
Field | Fill In
Process Name | DONATIONS /flow
Country / Team | CZ
Process Owner | Svatava Poulson
Date
Process Goal (What is the output?) | ZMAPOVANÍ PROCESU DARU A JEJICH ZPRACOVANÍ V SYSTEMU
Process Start (What triggers it?) | ZAHAJENI DARU DÁRCEM
Process End (When is it finished?) | DAR PRIRAZEN K PRIBEHU

### SHEET: 1_Basic_Info_EN  (8 řádků)
Field | Fill In | RO
Process Name | DONATIONS / FLOW | Donations/ Flow
Country / Team | CZ | RO
Process Owner | Svatava Poulson | Maria Nasco
Date | 2026-02-13 00:00:00
Process Goal (What is the output?) | MAPPING THE DONATION PROCESS AND ITS PROCESSING IN THE SYSTEM | Knowing the exact flow of the money, from donation to money distribution for cas…
Process Start (What triggers it?) | START OF DONATING BY THE DONOR | The donor initiating any kind of payment
Process End (When is it finished?) | DONATION ADDED TO THE STORY | Donation is distributed to the story

### SHEET: 2_Roles_CZ  (20 řádků)
 | Description (optional)
✅ KDOKOLI NEBO COKOLI KDO VYKONÁVÁ AKCI V PROCESU ( NEPÍŠEME JMÉNA OSOB, ALE JEJ…
To znamená, že to může být
👤 osoba - KOORDINÁTOR
👥 funkce / pozice - ŘEDITEL
🤖 systém - např. IT systém, mautic, atd
🏢 externí subjekt
  ·
  ·
Dárce
IT systém | BE
Notifikace | BE + Mautic
Provozní manažer
Provozovatel platební brány | Comgate
Fórum dárců
obdarovaný | dostal dobrošek darem od dárce
info koordinátor
korporátní dárci | pracovník. zodpovědný za firemní dárce
Pracovník péče o dárce
Výkonná ředitelka

### SHEET: 2_Roles_EN  (22 řádků)
Role Name | RO | Description (optional)
✅ KDOKOLI NEBO COKOLI KDO VYKONÁVÁ AKCI V PROCESU ( NEPÍŠEME JMÉNA OSOB, ALE JEJ…
To znamená, že to může být
👤 osoba - KOORDINÁTOR
👥 funkce / pozice - ŘEDITEL
🤖 systém - např. IT systém, mautic, atd
🏢 externí subjekt
  ·
  ·
Donor | Donor
IT system | IT system | BE
Notification | Notification | BE+Mautic
Operations manager | Operations manager
payment gateway operator | Payment gateway | Comgate
Fórum dárců | ---- | organization managing donor's SMS (DMS)
recipient | ---- | person who received a gift voucher (dobrošek) from the donor
INFO coordinator | ----
KAM Donors | Corporate donors | employee responsible for corporate donore
 | Bank | handles transactions through their system
 | Local tax entities | responsible for the reddirection of the task
  ·
DONATION |  | ORIGINAL PAYMENT

### SHEET: 3_Process_Steps_CZ  (58 řádků)
Step Process Number | Role Responsible | Step Description (Start with a verb) | Manual / Automated | System Used (if any) | Status platby | Notifikace email  dárce | Zobrazení v zóně dárce
  ·
 | ✅ vyberu z listu ROLE | ✅ Napíši aktivní sloveso - používejte přítomný čas, 3. osoba jednotného čísla |  | ✅ Napíši jaký systém je použit, nebo píšu Bez systému. Políčko nenechávám prázdn…
1 | dárce | vytvoří dar | manuálně | web |  | 2 | dárce
1a | dárce | vytvoří dar na konkrétní příběh dítěte | manuálně | web/Comgate |  | 1a | dárce
1b | dárce | vytvoří dar na sbírkový účet | manuálně | web/Comgate |  | 1b | dárce
1c | dárce | vytvoří bankovní převod přes svou banku na náš sbírkový účet | manuálně | web/banka |  | 1c | dárce
1d | dárce | pošle DMS | manuálně | mobilní telefon |  | 1d | dárce
1e | dárce | zadá trvalý příkaz ve své bance | manuálně | banka/BE |  | 1e | dárce
1f | dárce | zadá trvalý příkaz ze své platební karty | manuálně | web/Comgate |  | 1f | dárce
1g | dárce | uplatní dobrošek | manuálně | web |  | 1g | dárce
  ·
1aa | dárce | zadá povinné údaje a dokoční platbu | manuálně | BE/Comgate | PAID | yes | yes
1ab | Comgate | potvrdí dar | automaticky | BE/Comgate
1ac | Comgate | pošle dar souhrnym dennim prevodem do Monety | automaticky | Comgate/bank
1ad | bank | potvrdí přijetí daru přes API do BE | automaticky | bank/BE
1ae | dárce | zadá povinné údaje a nedokončí platbu | manuálně | BE/Comgate | PENDING | yes | no
1af | Comgate | odesílá žádost k dokončení daru | automaticky | Comgate | PENDING | yes | no
1ag | Comgate | zruší platbu | manuálně | BE/Comgate | CANCELLED | yes | no
  ·
1ba | dárce | zadá povinné údaje a dokoční platbu | manuálně | BE/Comgate | PAID | yes | no
1bb | Comgate | potvrdí dar | automaticky | BE/Comgate
1bc | Comgate | pošle dar souhrnym dennim prevodem do Monety | automaticky | Comgate/bank
1bd | bank | potvrdí přijetí daru přes API do BE | automaticky | bank/BE
1be | dárce | zadá povinné údaje a nedokončí platbu | manuálně | BE/Comgate | PENDING | yes | no
1bf | Comgate | odesílá žádost k dokončení daru | automaticky | e-mail | PENDING | yes | no
1bg | Comgate | zruší platbu | manuálně | web/Comgate | CANCELLED | yes | no
  ·
1ca | banka | převede dar na sbírkový účet | automaticky |  | PAID
1cb | dárce | uvede do poznámky pro příjemce svůj e-mail | manuálně | bank/BE | PAID | yes | yes
  ·
1da | Forum darcu | zašle měsíčně souhrnný dar na sbírkový účet | manuálně | banka/BE | PAID | X | X
  ·
1ea | banka | převede dar na sbírkový účet | automaticky | banka/BE | PAID | no | no
1eb | dárce | uvede do poznámky pro příjemce svůj e-mail | manuálně | banka/BE | PAID | yes | yes
  ·
1fa | dárce | zadá povinné údaje a dokončí pravidelný dar | manuálně | BE | PAID | yes | yes
1fb | dárce | zruší pravidelný dar | manuálně | zóna dárce | CANCELLED | no | yes
  ·
1ga | dárce | nakoupí dobrošek | manuálně | web/Comgate | PAID | yes | no
1gb | dárce | uplatní svuj dobrošek | manuálně | web | PAID | yes | yes
1gb | obdarovaný | uplatní dobrošek | manuálně | web/Comgate | PAID | yes | yes
  ·
2 | provozní manažer | dostane pokyn k presmerovani platby (vratky, preplatky, zruseni příbehu) | manuálně | e-mail
3 | provozni manažer | identifikuje platbu a presune ji na jiny pribeh | manuálně | BE
4 | provozni manažer | identikuje platbu jako vratku | manuálně
5 | provozni manažer | odebere platbu ze sbírkového účtu a oznaci ji jako "ne dar" | manuálně | BE
6 | provozní manažer | zapise vratku do sdíleného souboru VRATKY | manuálně | SDILENY SOUBOR VRATKY
7 | provozní manazer | identikuje platbu jako chybnou platbu ze strany financniho managera | manuálně
8 | provozní manazer | informuje financniho managera o vracene platbe | manuálně | e-mail
9 | provozni manažer | zapisuje vracenou platbu do souboru VRATKY a oznacuje jako CHYBNA PLATBA | manuálně | SDILENY SOUBOR VRATKY
10 | provozní manažer | označuje platbu jako "ne dar" | manuálně | BE
11 | provozní manažer | identifikuje platbu jako prijate kreditní uroky | manuálně
12 | provozní manažer | označuje platbu jako "ne dar" | manuálně | BE
13 | provozní manažer | FIREMNI DARCI - smlouva o nadacnim prispevku | manuálně | e-mail
15 | dárce | vygeneruje si potvrzení o daru | manuálně | BE/zona |  | yes | yes
16 | dárce | požádá o vystavení potvrzení o daru | manuálně | e-mail
17 | info koordinátor | vystaví dárci potvrzení o daru | manuálně | e-mail

### SHEET: 3_Process_Steps_EN  (73 řádků)
Step Process Number | RO | Role Responsible | RO | Step Description (Start with a verb) | RO | Manual / Automated | RO | System Used (if any) | RO | Status platby | RO | Notifikace email  dárce | RO | Zobrazení v zóně dárce | RO
  ·
 |  | ✅ vyberu z listu ROLE |  | ✅ Napíši aktivní sloveso - používejte přítomný čas, 3. osoba jednotného čísla |  |  |  | ✅ Napíši jaký systém je použit, nebo píšu Bez systému. Políčko nenechávám prázdn…
1 | 1 | donator | donor | create a donation | makes a donation | manually | manually | web |  |  |  | 2 |  | dárce
1a | 1a | donator | donor | makes a donation to support a specific child's story | donates to a chosen story | manually | manually | web/Comgate | web/Netopia |  |  | 1a |  | dárce
1b | 1b | donator | donor | makes a donation to the donation account /former transparent account/ | donates into the  general accoubt | manually | manually | web/Comgate | web/Netopia |  |  | 1b |  | dárce
1c | 1c | donator | donor | makes a bank transfer through their bank to our donation account | donates through the bank account | manually | manually | web/banka | web/bank |  |  | 1c |  | dárce
1d | 1d | donator | donor | sends DMS | reddirects money fron individual tax on salary | manually | manually | mobilní telefon | web/tax form 230/email |  |  | 1d |  | dárce
1e | 1e | donator | donor | creates a regular bank transfer through their bank to our donation account | donates regullarly via card or via bank | manually | manually | banka/BE | web/netopia/bank |  |  | 1e |  | dárce
1f | 1f | donator | donor | creates a regular donation from credit card | donates regullarly via card | manually | manually | web/Comgate | web/Netopia |  |  | 1f |  | dárce
1g | 1g | donator | donor - corporate | applies dobrošek (our voucher) | donates through tax reddirection | manually | manually | web | web/ tax form 107 / email |  |  | 1g |  | dárce
 | 1h |  | donor - corporate |  | donate directly through bank |  | manually |  | bank
story via Comgate | story via Netopia
1aa | 1aa | donator | donor | Enters mandatory data and completes the donation | enters the peyment popup on the specific story and completes all requiered data | manually | manually | Web/comgate | web/Netopia | PAID | PAID | yes | yes | yes | yes
1ab | 1ab | Comgate | Netopia | confirms donation | vallidates the donation | automatically | automatically | BE/Comgate | web/Netopia | PAID | PAID
1ac | 1ac | Comgate | Netopia | sends money in a daily batch to Moneta (our bank) | Sends money in 3-5 days to bank, depending on the ammount donated | automatically | automatically | BE/Comgate | Netopia/bank | PAID | PAID
1ad | 1ad | bank | Netopia | confirms receiving of donation via API to BE | Confirms payment to FE/BE | automatically | automatically | bank/BE | Netopia integration/BE | PAID | PAID
1ae | 1ae | donator | donor | Enters mandatory data and does not finish the donation | Does not go through with donation | manually | manually | BE/Comgate | Netopia/BE | PENDING | PENDING | yes | no | no | no
1af | 1af | Comgate | --- | Submits a request to complete the donation | Does not happen for us | automatically |  | Comgate |  | PENDING |  | yes | no | no | no
1ag | 1ag | Comgate | Netopia | Cancels the donation | Confirms donation as not paid in their interface | manually | automatically | BE/Comgate | Netopia | CANCELLED | PENDING | yes | no | no | no
collection account via Comgate | general accountaccount via Netopia
1ba | 1ba | donator | donor | Enters mandatory data and completes the donation | enters the peyment popup on the specific story and completes all requiered data | manually | manually | BE/Comgate | web/Netopia | PAID | PAID | yes |  | no
1bb | 1bb | Comgate |  | confirms donation | vallidates the donation |  | automatically |  | web/Netopia |  | PAID
1bc | 1bc | Comgate |  | sends money in a daily batch to Moneta (our bank) | Sends money in 3-5 days to bank, depending on the ammount donated |  | automatically |  | Netopia/bank |  | PAID
1bd | 1bd | bank |  | confirms receiving of donation via API to BE | Confirms payment to FE/BE |  | automatically |  | Netopia integration/BE |  | PAID
1be | 1be | donator |  | Enters mandatory data and does not finish the donation | Does not go through with donation | manually | manually | BE/Comgate | Netopia/BE | PENDING | PENDING | yes |  | no
1bf | 1bf | Comgate |  | Submits a request to complete the donation | Does not happen for us | automatically |  | e-mail |  | PENDING |  | yes |  | no
1bg | 1bg | Comgate |  | Cancels the donation | Confirms donation as not paid in their interface | manually | automatically | web/Comgate | Netopia | CANCELLED | PENDING | yes |  | no
1bh | 1bh | operational manager |  | tranferst donation from collection acount to a specific story | Transferes funds to  a chosen story | manually | manually | BE/Comgate |  | PAID | PAID | no |  | yes
bank transfer | bank transfer
1ca | 1ca | operational manager |  | Transfers the donation to the collection account | Transferes funds to general account | automatically | manually | bank/BE | bank/BE | PAID | PAID
1cb | 1cb | donator | donor | Enters their email address in the recipient message field | Write down their email in yhe bank transfer description | manually | manually | bank/BE | bank | PAID | PAID | yes | no | yes | no
1cd | 1cd | operational manager | Operatinal manager | tranferst donation from collection acount to a specific story | Allocates money to a specific story | manually | manually | BE | BE | PAID | PAID | no | no | yes | yes
DMS | tax reddirection -  individuals
1da | 1da | Forum darcu | donor | Sends a monthly sum of donation to the collection account | completes the 230 form | manually |  |  | FE/paper/email | PAID |  | X |  | X
 | 1db |  | Accountant from PE |  | uplods the forms into tax official's website | manually |  | banka/BE | tax official's platform
 | 1dc |  | Local tax entities |  | sends mone to our bank account, timeframe is not esablished |  |  | banka/BE | Bank
 | 1dd |  | Operational manager |  | transfers money from bank into BE & adds donor's adresses |  | manually |  | Bank/BE
 | 1de |  | Operational manager |  | transfers funds to a sellected story |  | manually |  | BE |  | PAID |  | no |  | yes
regular bank transfer
1ea |  | bank | Operational manager | Transfers the regular donation to the collection account | Transferes funds to general account | automatically | manually | banka/BE | bank/BE | PAID | PAID | no |  | no
1eb |  | donator | donor | Enters their email address in the recipient message field | Write down their email in yhe bank transfer description | manually | manually | banka/BE | bank/be | PAID | PAID | yes | no | yes | yes
regular card transfer | regular card transfer
1fa | 1fa | donator | donor | Enters mandatory data and completes the regular donation | enters the peyment popup on the specific story and completes all requiered data,… | manually | manually | BE | BE | PAID | PAID | yes | yes | yes | yes
1fb | 1fb | donator | donor | Cancels the regular donation | Cancels the reoccuring payment | manually | manually | zóna dárce | Client account | CANCELLED | CANCELLED | no | no | yes | no
gift voucher | tax reddirection -  companies
1ga | 1ga | donator | donor - corporate | buys a dobrošek (our voucher) | creates donation contract with the foundation | manually | manually | web/Comgate | email | PAID |  | yes |  | no
1gb | 1gb | donator | donor - corporate | applies dobrošek (our voucher) | completes form 107 and gives it to the tax adlinistration | manually | manually | web | tax official's platform | PAID |  | yes |  | yes
1gc | 1gc | recipient | Local tax entities | applices donated dobrošek (our voucher) | send money to our bank account | manually |  | web/Comgate | bank | PAID |  | yes |  | yes
 | 1gd |  | Operational manager |  | transfers money from bank into BE & adds donor's adresses |  | manually |  | Bank/BE
 | 1ge |  | Operational manager |  | transfers funds to a sellected story |  | manually |  | BE |  | PAID |  | no |  | yes
  ·
 | corporate donations
 | 1ha |  | donor - corporate |  | creates donation contract with the foundation |  | manually |  | email
 | 1hb |  | donor - corporate |  | transfers funds to the bank account |  | manually |  | bank
 | 1hc |  | Operational manager |  | transfers money from bank into BE & adds donor's adresses |  | manually |  | Bank/BE
  ·
  ·
2 | 2 | operations manager | operations manager | receives instructions to redirect a donation (refunds, overpayments, cancellatio… | receives information about funds that need to be moved | manually |  | e-mail
3 | 3 | operations manager | operations manager | identifies the donation and transfers it to another story | transfers the donation to the desired location | manually |  | BE
4 | 4 | operations manager | --- | identifies the donation as a refund | --- | manually
5 | 5 | operations manager | --- | takes away the payment from the collection account and marks it as "not a donati… | --- | manually |  | BE
6 | 6 | operations manager | Accountant from PE | records the returned donation in the shared file REFUNDS | keeps a reccord of all refunds | manually | manually | SHARED FILE  VRATKY | accounting system
7 | 7 | operations manager | Accountant from PE | identifies the returned payment  as a error made by the financial manager | finds out if any payment was returned | manually | manually |  | accounting system
8 | 8 | operations manager | Accountant from PE | informs financial manager about returned payments | discusses wit Acquisition specialist | manually | manually | e-mail | email
9 | 9 | operations manager | --- | records the returned donation in the shared file REFUNDS and marks payment as a … | --- | manually |  | SHARED FILE  VRATKY
10 | 10 | operations manager | --- | marks it as "not a donation" | --- | manually |  | BE
11 | 11 | operations manager | Accountant from PE | indentifies payment as a credit interest from the bank | keeps a reccord of the intrests from the bank | manually | manually |  | accounting system
12 | 12 | operations manager | --- | marks it as "not a donation" | --- | manually |  | BE
13 | 13 | operations manager/KAM Donors | operations manager/corporate donors | prepares and signs Foundation Contribution Agreement for Corporate Donors it nee… | sends corporat donators the donation contract and signs it | manually | manually | e-mail | email
15 | 15 | donator | donor - corporate | generates a donation confirmation | confirms the payment | manually | manually | BE/ donator zone | email/phone |  |  | yes |  | yes
16 | 16 | donator | donor - corporate | asks for donations confirmation (in case of anonymous donations) | asks if the donation was received | manually | manually | e-mail | email/phone
17 | 17 | INFO coordinator | Operatinal manager | issues a donation confirmation | confirms receiving the donation | manually | manually | e-mail | email/phone

### SHEET: 4_Decisions  (3 řádků)
Decision Point Description / USE QUESTIONS | Step Process Number | Who Decides? | Criteria for Decision | What Happens if NO?
  ·
✅ Napíši krátká otázka | ✅ vyberu ČÍSLO z listu Process_Steps

