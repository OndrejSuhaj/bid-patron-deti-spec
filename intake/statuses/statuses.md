# Stavový model — CZ / RO / MD

> Převod z `STATUSES_CZ_RO_MO.xlsx`. Kontextový podklad (ne zdroj pravdy). Sloupce: alias (systémový), CZ název, komentář, typ entity (Lead/Application/Story), EN název, RO název, MD blok.

| alias | Status CZ | Comment | Lead/Application/Story | Status EN | Status RO | MD col1 | MD comment | MD Lead/Story |
|---|---|---|---|---|---|---|---|---|
| reminder_1 | 1. urgence |  | Lead | Lead - 1.reminder | Solicitant - 1 reamintire | New Applicant | When a new application is received | Lead |
| reminder_2 | 2. urgence |  | Lead | Lead - 2.reminder | Solicitant - 2 reamintire | Request in Progress | When a coordinator takes over a lead and works on it | Lead |
| active | Aktivní příběh |  | Story | Active story | Poveste Activă | Score Check |  | Lead |
| campaign_uncompleted | Cílová částka nevybrána |  | Story | Target amount not collected | Suma tinta nu a fost stransa | Score OK |  | Lead |
| waiting_signature | Čeká na podpis |  | Story | Waiting for signature | Se așteaptă semnătura | Score KO |  | Lead |
| waiting_signature_reminder_1 | Čeká na podpis – 1. urgence |  | Story | Waiting for signature - 1. reminder | Se așteaptă semnătura - 1 reamintire | Applicant's Story Processing |  | Story |
| waiting_signature_reminder_2 | Čeká na podpis – 2. urgence |  | Story | Waiting for signature - 2. reminder | Se așteaptă semnătura - 2 reamintire | Active History |  | Story |
| waiting_signature_uncooperative | Čeká na podpis – Nespolupracující |  | Story | Waiting for signature - uncooperative | Se așteaptă semnătura - necooperant | Story Successfully Completed |  | Story |
| waiting_for_feetback | Čeká na zpětnou vazbu |  | Story | Waiting for feedback | Se așteaptă feedback | Completed |  | Lead |
| waiting_feedback_reminder_1 | Čeká na zpětnou vazbu – 1. urgence |  | Story | Waiting for feedback - 1. reminder | Se așteaptă feedback - 1 reamintire | Request Canceled |  | Lead |
| waiting_feedback_reminder_2 | Čeká na zpětnou vazbu – 2. urgence |  | Story | Waiting for feedback - 2. reminder | Se așteaptă feedback - 2 reamintire | Story Canceled |  | Story |
| waiting_feedback_uncooperative | Čeká na zpětnou vazbu – Nespolupracující |  | Story | Waiting for feedback - uncooperative | Se așteaptă feedback - necooperant | Duplicate |  | Lead |
| waiting_for_bill | Čeká na účetní doklad |  | Story | Wating for accounting doc | În așteptarea facturii/documentului contabil | Canceled by User |  | Lead |
| waiting_for_final_doc | Čeká na konečný doklad |  | Story | Waiting for final accounting doc | În așteptarea documentului contabil final |  |  |  |
| waiting_for_fundraiser | Čeká na žádost ZZ |  | Application | Waiting for applicant | În așteptarea solicitantului |  |  |  |
| waiting_for_patron | Čeká na žádost patrona |  | Application | Waiting for patron | În așteptarea persoanei garantă |  |  |  |
| reminder_1_patron | Čeká na žádost patrona - 1. urgence |  | Application | Waiting for patron - 1. reminder | În așteptarea persoanei garantă - 1 reamintire |  |  |  |
| reminder_2_patron | Čeká na žádost patrona - 2. urgence |  | Application | Waiting for patron - 2. reminder | În așteptarea persoanei garantă - 2 reamintire |  |  |  |
| reminder_1_fundraiser | Čeká na žádost ZZ - 1. urgence |  | Application | Waiting for applicant - 1.reminder | În așteptarea solicitantului - 1 reamintire |  |  |  |
| reminder_2_fundraiser | Čeká na žádost ZZ - 2. urgence |  | Application | Waiting for applicant - 2. reminder | În așteptarea solicitantului - 2 reamintire |  |  |  |
| waiting | Čeká na doplnění |  | Application | Waiting for additional info | În așteptarea informației adiționale |  |  |  |
| waiting_reminder_1 | Čeká na doplnění - 1. urgence |  | Application | Waiting for additional info - 1. reminder | În așteptarea informației adiționale - 1 reamintire |  |  |  |
| waiting_reminder_2 | Čeká na doplnění - 2. urgence |  | Application | Waiting for additional info - 2. reminder | În așteptarea informației adiționale - 2 reamintire |  |  |  |
| mistake | Chyba |  |  | Mistake | Greşeală/Eroare |  |  |  |
| gift_paid | Dar uhrazen |  | Story | Gift paid | Cadou plătit |  |  |  |
| duplicate | Duplikát |  |  | Duplicate | Duplicat |  |  |  |
| to_check | Ke kontrole |  | Application | For control | Necesită verificare |  |  |  |
| uncompleted | Nesplněný příběh |  | Story | Unsuccessful story | Poveste fără succes |  |  |  |
| campaign_uncompleted_inprocess | Nesplněný příběh - vypořádání darů |  | Story | Unsuccessful story - donations | Poveste fără succes - necesită decontarea donaţiilor |  |  |  |
| new | Nový |  | Lead | New lead | Solicitant nou |  |  |  |
| out_of_scope | Out of scope |  |  | Out of scope | Scop incompatibil |  |  |  |
| in_progress | Příprava příběhu |  | Application | Story processing | Procesarea povestii solicitantului |  |  |  |
| suspended | Pozastavená žádost |  | Application | Application on hold | Solicitare suspendată |  |  |  |
| suspended_campaign | Pozastavený příběh |  | Story | Story on hold | Poveste suspendată |  |  |  |
| scoring | Scoring kontrola |  | Application | Scoring control | Controlul punctajului |  |  |  |
| scoring_ok | Scoring OK |  | Application | Scoring OK | Punctaj OK |  |  |  |
| scoring_ko | Scoring KO |  | Application | Scoring KO | Punctaj KO |  |  |  |
| scoring_waiting | Scoring k doplnění |  | Application | Scoring additional info | Punctajul urmează să fie finalizat |  |  |  |
| contract | Smlouva ke schválení |  | Application | Contract for approval | Contract spre aprobare |  |  |  |
| contract_signed | Smlouva podepsána žadatelem |  | Application | Contract signed by applicant | Contract semnat de solicitant |  |  |  |
| completed_partly_1 | Splněný příběh - částečné plnění |  | Story | Successful story - partly | Poveste de succes - parțial |  |  |  |
| completed | Splněný příběh |  | Story | Successful story | Poveste de succes |  |  |  |
| canceled_by_user | Zrušeno uživatelem |  | Lead | Canceled by user | Anulat de către utilizator |  |  |  |
| canceled_lead | Zrušený lead |  | Lead | Canceled lead | Lead anulat |  |  |  |
| canceled_application | Zrušená žádost |  | Application | Canceled application | Cerere anulată |  |  |  |
| canceled_timeout | Zrušená žádost (timeout) |  | Application | Canceled application (timeout) | Cerere anulată (timp expirat) |  |  |  |
| canceled_campaign | Zrušený příběh |  | Story | Canceled story | Poveste anulata |  |  |  |
| feedback_to_proccess | Zpětná vazba ke zpracování |  | Story | Feedback processing | Feedback in procesare |  |  |  |
| feedback_sent | Zpětná vazba odeslána |  | Story | Feedback sent | Feedback trimis |  |  |  |
| application_processing | Zpracování žádosti |  | Application | Application processing | Cerere in procesare |  |  |  |
| refiled | Žádost doplněna uživatelem |  | Application | Application - info added by user | Solicitare- informatii adaugate de utilizator |  |  |  |
| closed | Uzavřeno |  | Story | Closed story | Poveste finalizata cu succes |  |  |  |
| completed_partly | Uzavřeno - částečné plnění |  | Story | Partly closed story | Poveste finalizata parțial |  |  |  |
| gift_payment | Úhrada daru |  | Story | Gift payment | Plata cadoului |  |  |  |
| returned_new_patron | Vrácená žádost (nový patron) |  | Application | Application returned - waiting for new patron | Solicitare returnată (in asteptare persoana garantă nouă) |  |  |  |
| returned_new_patron_reminder_2 | Vrácená žádost (nový patron) - 2. urgence |  | Application | Application returned - waiting for new patron - 1st | Solicitare returnată (in asteptare persoana garantă nouă) 1 reamintire |  |  |  |
| returned_new_patron_reminder_1 | Vrácená žádost (nový patron) - 1. urgence |  | Application | Application returned - waiting for new patron - 2nd | Solicitare returnată (in asteptare persoana garantă nouă) 2 reamintire |  |  |  |
|  | Statusy příběhu |  |  |  |  |  |  |  |
|  | Příprava příběhu |  |  |  |  |  |  |  |
|  | Aktivní |  |  |  |  |  |  |  |
|  | Pozastavený |  |  |  |  |  |  |  |
|  | Splněný |  |  |  |  |  |  |  |
|  | Nesplněný |  |  |  |  |  |  |  |
|  | Cílová částka nevybrána |  |  |  |  |  |  |  |
|  | Částečně splněný |  |  |  |  |  |  |  |
|  | Zrušený |  |  |  |  |  |  |  |
