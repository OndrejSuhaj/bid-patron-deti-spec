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
Field | Fill In
Process Name | DONATIONS / FLOW
Country / Team | CZ
Process Owner | Svatava Poulson
Date | 2026-02-13 00:00:00
Process Goal (What is the output?) | MAPPING THE DONATION PROCESS AND ITS PROCESSING IN THE SYSTEM
Process Start (What triggers it?) | START OF DONATING BY THE DONOR
Process End (When is it finished?) | DONATION ADDED TO THE STORY

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
Role Name | Description (optional)
✅ KDOKOLI NEBO COKOLI KDO VYKONÁVÁ AKCI V PROCESU ( NEPÍŠEME JMÉNA OSOB, ALE JEJ…
To znamená, že to může být
👤 osoba - KOORDINÁTOR
👥 funkce / pozice - ŘEDITEL
🤖 systém - např. IT systém, mautic, atd
🏢 externí subjekt
  ·
  ·
Donor
IT system | BE
Notification | BE+Mautic
Operations manager
payment gateway operator | Comgate
Fórum dárců | organization managing donor's SMS (DMS)
recipient | person who received a gift voucher (dobrošek) from the donor
INFO coordinator
KAM Corporate Donor | employee responsible for corporate donore
  ·
  ·
  ·
DONATION | ORIGINAL PAYMENT

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

### SHEET: 3_Process_Steps_EN  (60 řádků)
Step Process Number | Role Responsible | Step Description (Start with a verb) | Manual / Automated | System Used (if any) | Status platby | Notifikace email  dárce | Zobrazení v zóně dárce | MUST HAVE/NICE TO HAVE
  ·
 | ✅ vyberu z listu ROLE | ✅ Napíši aktivní sloveso - používejte přítomný čas, 3. osoba jednotného čísla |  | ✅ Napíši jaký systém je použit, nebo píšu Bez systému. Políčko nenechávám prázdn…
1 | donator | create a donation | manually | web |  | 2 | dárce | MUST HAVE
1a | donator | makes a donation to support a specific child's story | manually | web/Comgate |  | 1a | dárce | MUST HAVE
1b | donator | makes a donation to the donation account /former transparent account/ | manually | web/Comgate |  | 1b | dárce | MUST HAVE
1c | donator | makes a bank transfer through their bank to our donation account | manually | web/banka |  | 1c | dárce | MUST HAVE
1d | donator | sends DMS | manually | mobilní telefon |  | 1d | dárce | MUST HAVE
1e | donator | creates a regular bank transfer through their bank to our donation account | manually | banka/BE |  | 1e | dárce | MUST HAVE
1f | donator | creates a regular donation from credit card | manually | web/Comgate |  | 1f | dárce | MUST HAVE
1g | donator | applies dobrošek (our voucher) | manually | web |  | 1g | dárce | NICE TO HAVE
story via Comgate
1aa | donator | Enters mandatory data and completes the donation | manually | BE/Comgate | PAID | yes | yes | MUST HAVE
1ab | Comgate | confirms donation | automatically | BE/Comgate | PAID |  |  | MUST HAVE
1ac | Comgate | sends money in a daily batch to Moneta (our bank) | automatically | BE/Comgate | PAID |  |  | MUST HAVE
1ad | bank | confirms receiving of donation via API to BE | automatically | bank/BE | PAID |  |  | MUST HAVE
1ae | donator | Enters mandatory data and does not finish the donation | manually | BE/Comgate | PENDING | yes | no | MUST HAVE
1af | Comgate | Submits a request to complete the donation | automatically | Comgate | PENDING | yes | no | MUST HAVE
1ag | Comgate | Cancels the donation | manually | BE/Comgate | CANCELLED | yes | no | MUST HAVE
collection account via Comgate
1ba | donator | Enters mandatory data and completes the donation | manually | BE/Comgate | PAID | yes | no | MUST HAVE
1bb | Comgate | confirms donation |  |  |  |  |  | MUST HAVE
1bc | Comgate | sends money in a daily batch to Moneta (our bank) |  |  |  |  |  | MUST HAVE
1bd | bank | confirms receiving of donation via API to BE |  |  |  |  |  | MUST HAVE
1be | donator | Enters mandatory data and does not finish the donation | manually | BE/Comgate | PENDING | yes | no | MUST HAVE
1bf | Comgate | Submits a request to complete the donation | automatically | e-mail | PENDING | yes | no | MUST HAVE
1bg | Comgate | Cancels the donation | manually | web/Comgate | CANCELLED | yes | no | MUST HAVE
1bh | operational manager | tranferst donation from collection acount to a specific story | manually | BE/Comgate | PAID | no | yes | MUST HAVE
bank transfer
1ca | bank | Transfers the donation to the collection account | automatically |  | PAID |  |  | MUST HAVE
1cb | donator | Enters their email address in the recipient message field | manually | bank/BE | PAID | yes | yes | MUST HAVE
1cd | operational manager | tranferst donation from collection acount to a specific story | manually | BE | PAID | no | yes | MUST HAVE
DMS
1da | Forum darcu | Sends a monthly sum of donation to the collection account | manually | banka/BE | PAID | X | X | MUST HAVE
regular bank transfer
1ea | bank | Transfers the regular donation to the collection account | automatically | banka/BE | PAID | no | no | MUST HAVE
1eb | donator | Enters their email address in the recipient message field | manually | banka/BE | PAID | yes | yes | MUST HAVE
regular card transfer
1fa | donator | Enters mandatory data and completes the regular donation | manually | BE | PAID | yes | yes | MUST HAVE
1fb | donator | Cancels the regular donation | manually | zóna dárce | CANCELLED | no | yes | MUST HAVE
gift voucher
1ga | donator | buys a dobrošek (our voucher) | manually | web/Comgate | PAID | yes | no | NICE TO HAVE
1gb | donator | applies dobrošek (our voucher) | manually | web | PAID | yes | yes | NICE TO HAVE
1gc | recipient | applices donated dobrošek (our voucher) | manually | web/Comgate | PAID | yes | yes | NICE TO HAVE
  ·
2 | operations manager | receives instructions to redirect a donation (refunds, overpayments, cancellatio… | manually | e-mail |  |  |  | MUST HAVE
3 | operations manager | identifies the donation and transfers it to another story | manually | BE |  |  |  | MUST HAVE
4 | operations manager | identifies the donation as a refund | manually |  |  |  |  | MUST HAVE
5 | operations manager | takes away the payment from the collection account and marks it as "not a donati… | manually | BE |  |  |  | MUST HAVE
6 | operations manager | records the returned donation in the shared file REFUNDS | manually | SHARED FILE  VRATKY |  |  |  | MUST HAVE
7 | operations manager | identifies the returned payment  as a error made by the financial manager | manually |  |  |  |  | MUST HAVE
8 | operations manager | informs financial manager about returned payments | manually | e-mail |  |  |  | MUST HAVE
9 | operations manager | records the returned donation in the shared file REFUNDS and marks payment as a … | manually | SHARED FILE  VRATKY |  |  |  | MUST HAVE
10 | operations manager | marks it as "not a donation" | manually | BE |  |  |  | MUST HAVE
11 | operations manager | indentifies payment as a credit interest from the bank | manually |  |  |  |  | MUST HAVE
12 | operations manager | marks it as "not a donation" | manually | BE |  |  |  | MUST HAVE
13 | operations manager/KAM Corporate Donor | prepares and signs Foundation Contribution Agreement for Corporate Donors it nee… | manually | e-mail |  |  |  | MUST HAVE
15 | donator | generates a donation confirmation | manually | BE/ donator zone |  | yes | yes | MUST HAVE
16 | donator | asks for donations confirmation (in case of anonymous donations) | manually | e-mail |  |  |  | MUST HAVE
17 | INFO coordinator | issues a donation confirmation | manually | e-mail |  |  |  | MUST HAVE

### SHEET: 4_Decisions  (3 řádků)
Decision Point Description / USE QUESTIONS | Step Process Number | Who Decides? | Criteria for Decision | What Happens if NO?
  ·
✅ Napíši krátká otázka | ✅ vyberu ČÍSLO z listu Process_Steps

