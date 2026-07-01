# Mapování stavů: workflow stávajícího řešení ↔ stavový model zadání

Tento dokument porovnává **stavy workflow ve stávajícím kódu** (`workflows.workflow.application_workflow.yml`, sekce `states`) se **stavovým modelem definovaným v zadání** (baseline JSON). Cílem je ověřit shodu (machine-name, label, alias) a odhalit stavy navíc na jedné či druhé straně.

Alias v obou zdrojích odpovídá klíči stavu ve workflow (machine-name); v hranatých závorkách je uvedena logická entita ze zadání (`Lead` / `Application` / `Story` / prázdné). **Pozor:** entita je atribut pouze v zadání — workflow YAML entity nerozlišuje (celý workflow je `entity_type application`), jde tedy o logickou kategorizaci, nikoli technický atribut stavu v kódu.

## Mapovací tabulka (kód ↔ zadání ↔ poznámka)

| Stav v kódu | Stav v zadání | Poznámka |
|---|---|---|
| `new` (Nový) | `new` (Nový) `[Lead]` | Přesná shoda alias + label. |
| `reminder_1` (1. urgence) | `reminder_1` (1. urgence) `[Lead]` | Přesná shoda. |
| `reminder_2` (2. urgence) | `reminder_2` (2. urgence) `[Lead]` | Přesná shoda. |
| `canceled_by_user` (Zrušeno uživatelem) | `canceled_by_user` (Zrušeno uživatelem) `[Lead]` | Přesná shoda. |
| `canceled_lead` (Zrušený lead) | `canceled_lead` (Zrušený lead) `[Lead]` | Přesná shoda. |
| `application_processing` (Zpracování žádosti) | `application_processing` (Zpracování žádosti) `[Application]` | Přesná shoda. |
| `to_check` (Ke kontrole) | `to_check` (Ke kontrole) `[Application]` | Přesná shoda. |
| `waiting` (Čeká na doplnění) | `waiting` (Čeká na doplnění) `[Application]` | Přesná shoda. |
| `waiting_reminder_1` (Čeká na doplnění - 1. urgence) | `waiting_reminder_1` (Čeká na doplnění - 1. urgence) `[Application]` | Přesná shoda. |
| `waiting_reminder_2` (Čeká na doplnění - 2. urgence) | `waiting_reminder_2` (Čeká na doplnění - 2. urgence) `[Application]` | Přesná shoda. |
| `refiled` (Žádost doplněna uživatelem) | `refiled` (Žádost doplněna uživatelem) `[Application]` | Přesná shoda. |
| `waiting_for_fundraiser` (Čeká na žádost ZZ) | `waiting_for_fundraiser` (Čeká na žádost ZZ) `[Application]` | Přesná shoda. |
| `reminder_1_fundraiser` (Čeká na žádost ZZ - 1. urgence) | `reminder_1_fundraiser` (Čeká na žádost ZZ - 1. urgence) `[Application]` | Přesná shoda. |
| `reminder_2_fundraiser` (Čeká na žádost ZZ - 2. urgence) | `reminder_2_fundraiser` (Čeká na žádost ZZ - 2. urgence) `[Application]` | Přesná shoda. |
| `waiting_for_patron` (Čeká na žádost patrona) | `waiting_for_patron` (Čeká na žádost patrona) `[Application]` | Přesná shoda. |
| `reminder_1_patron` (Čeká na žádost patrona - 1. urgence) | `reminder_1_patron` (Čeká na žádost patrona - 1. urgence) `[Application]` | Přesná shoda. |
| `reminder_2_patron` (Čeká na žádost patrona - 2. urgence) | `reminder_2_patron` (Čeká na žádost patrona - 2. urgence) `[Application]` | Přesná shoda. |
| `returned_new_patron` (Vrácená žádost (nový patron)) | `returned_new_patron` (Vrácená žádost (nový patron)) `[Application]` | Přesná shoda. |
| `returned_new_patron_reminder_1` (Vrácená žádost (nový patron) - 1. urgence) | `returned_new_patron_reminder_1` `[Application]` | Přesná shoda. |
| `returned_new_patron_reminder_2` (Vrácená žádost (nový patron) - 2. urgence) | `returned_new_patron_reminder_2` `[Application]` | Přesná shoda. |
| `in_progress` (Příprava příběhu) | `in_progress` (Příprava příběhu) `[Application]` | Přesná shoda. |
| `scoring` (Scoring kontrola) | `scoring` (Scoring kontrola) `[Application]` | Přesná shoda. |
| `scoring_ok` (Scoring OK) | `scoring_ok` (Scoring OK) `[Application]` | Přesná shoda. |
| `scoring_ko` (Scoring KO) | `scoring_ko` (Scoring KO) `[Application]` | Přesná shoda. |
| `scoring_waiting` (Scoring k doplnění) | `scoring_waiting` (Scoring k doplnění) `[Application]` | Přesná shoda. |
| `contract` (Smlouva ke schválení) | `contract` (Smlouva ke schválení) `[Application]` | Shoda. V kódu žádná transition nevede DO `contract` (jen `ceka_na_podpis` z něj) — bez vstupního přechodu. |
| `contract_signed` (Smlouva podepsána žadatelem) | `contract_signed` (Smlouva podepsána žadatelem) `[Application]` | Přesná shoda. |
| `suspended` (Pozastavená žádost) | `suspended` (Pozastavená žádost) `[Application]` | Přesná shoda. |
| `canceled_application` (Zrušená žádost) | `canceled_application` (Zrušená žádost) `[Application]` | Přesná shoda. |
| `canceled_timeout` (Zrušená žádost (timeout)) | `canceled_timeout` (Zrušená žádost (timeout)) `[Application]` | Shoda. V kódu není transition do `canceled_timeout` — patrně nastavováno programově/cronem. |
| `active` (Aktivní příběh) | `active` (Aktivní příběh) `[Story]` | Přesná shoda. |
| `campaign_uncompleted` (Cílová částka nevybrána) | `campaign_uncompleted` (Cílová částka nevybrána) `[Story]` | Shoda. V kódu bez vstupní transition (jen z něj vedou přechody). |
| `waiting_signature` (Čeká na podpis) | `waiting_signature` (Čeká na podpis) `[Story]` | Přesná shoda. |
| `waiting_signature_reminder_1` (Čeká na podpis – 1. urgence) | `waiting_signature_reminder_1` `[Story]` | Přesná shoda (en-dash v obou zdrojích). |
| `waiting_signature_reminder_2` (Čeká na podpis – 2. urgence) | `waiting_signature_reminder_2` `[Story]` | Přesná shoda. |
| `waiting_signature_uncooperative` (Čeká na podpis – Nespolupracující) | `waiting_signature_uncooperative` `[Story]` | Přesná shoda. |
| `waiting_for_feetback` (Čeká na zpětnou vazbu) | `waiting_for_feetback` (Čeká na zpětnou vazbu) `[Story]` | Přesná shoda včetně překlepu v aliasu (`feetback`). |
| `waiting_feedback_reminder_1` (Čeká na zpětnou vazbu – 1. urgence) | `waiting_feedback_reminder_1` `[Story]` | Přesná shoda. |
| `waiting_feedback_reminder_2` (Čeká na zpětnou vazbu – 2. urgence) | `waiting_feedback_reminder_2` `[Story]` | Přesná shoda. |
| `waiting_feedback_uncooperative` (Čeká na zpětnou vazbu – Nespolupracující) | `waiting_feedback_uncooperative` `[Story]` | Přesná shoda. |
| `waiting_for_bill` (Čeká na účetní doklad) | `waiting_for_bill` (Čeká na účetní doklad) `[Story]` | Přesná shoda. |
| `waiting_for_final_doc` (Čeká na konečný doklad) | `waiting_for_final_doc` (Čeká na konečný doklad) `[Story]` | Shoda. V kódu žádná transition k/z `waiting_for_final_doc` — izolovaný, ve workflow nezapojen. |
| `gift_payment` (Úhrada daru) | `gift_payment` (Úhrada daru) `[Story]` | Přesná shoda. |
| `gift_paid` (Dar uhrazen) | `gift_paid` (Dar uhrazen) `[Story]` | Přesná shoda. |
| `feedback_to_proccess` (Zpětná vazba ke zpracování) | `feedback_to_proccess` (Zpětná vazba ke zpracování) `[Story]` | Přesná shoda včetně překlepu v aliasu (`proccess`). |
| `feedback_sent` (Zpětná vazba odeslána) | `feedback_sent` (Zpětná vazba odeslána) `[Story]` | Přesná shoda. |
| `completed` (Splněný příběh) | `completed` (Splněný příběh) `[Story]` | Shoda. V kódu bez vstupní transition (jen z něj vede `canceled_campaign`). |
| `completed_partly_1` (Splněný příběh - částečné plnění) | `completed_partly_1` `[Story]` | Přesná shoda. |
| `uncompleted` (Nesplněný příběh) | `uncompleted` (Nesplněný příběh) `[Story]` | Shoda stavu. Transition má label „Nesplněný" (bez „příběh"), cílový stav „Nesplněný příběh". |
| `campaign_uncompleted_inprocess` (Nesplněný příběh - vypořádání darů) | `campaign_uncompleted_inprocess` `[Story]` | Přesná shoda. |
| `suspended_campaign` (Pozastavený příběh) | `suspended_campaign` (Pozastavený příběh) `[Story]` | Přesná shoda. |
| `canceled_campaign` (Zrušený příběh) | `canceled_campaign` (Zrušený příběh) `[Story]` | Přesná shoda. |
| `closed` (Uzavřeno) | `closed` (Uzavřeno) `[Story]` | Přesná shoda. |
| `completed_partly` (Uzavřeno - částečné plnění) | `completed_partly` (Uzavřeno - částečné plnění) `[Story]` | Přesná shoda. |
| `mistake` (Chyba) | `mistake` (Chyba) `[—]` | Přesná shoda; entita v zadání prázdná. |
| `duplicate` (Duplikát) | `duplicate` (Duplikát) `[—]` | Přesná shoda; entita v zadání prázdná. |
| `out_of_scope` (Out of scope) | `out_of_scope` (Out of scope) `[—]` | Přesná shoda; entita v zadání prázdná. |

## Jen v kódu (mimo zadání)

Kód navíc obsahuje **9 stavů**, které nemají protějšek v zadání:

| Stav v kódu | Poznámka |
|---|---|
| `canceled` (Zrušeno) | Cíl transition `cancel_lead`. V zadání jen `canceled_lead`/`canceled_by_user`, obecné `canceled` chybí. |
| `canceled_fundraiser` (Zrušená žádost (nevyplněno žadatelem)) | Cíl transition `zrusena_zadost_zadatel_nedoplnil` z `reminder_2_fundraiser`. V zadání není. |
| `communications` (Komunikace před žádosti) | Mezistav mezi leadem a žádostí. V zadání není. |
| `draft` (Draft) | Technický výchozí moderační stav Drupal (`default_moderation_state`). Není doménový. |
| `published` (Published) | Technický publikovaný stav Drupal (`published: true`, `default_revision: true`). |
| `taken` (Přebráno) | Stav přebrání leadu operátorem. V zadání není. |
| `feedback_received` (Žadatel poskytl zpětnou vazbu) | Mezistav před `feedback_to_proccess`. V zadání chybí, začíná až `feedback_to_proccess`/`feedback_sent`. |
| `waiting_for_protocol` (Čeká na protokol o převzetí) | Definován, ale bez transition — ve workflow nezapojen. |
| `gift_confirmation_approved` (Potvrzený protokol o převzetí daru) | Definován, ale bez transition — ve workflow nezapojen. |

## Jen v zadání (mimo kód)

Žádné. Ze zadání nechybí v kódu žádný stav — `onlyInZadani` je prázdné.

## Souhrn shody

- **Kód** (`workflows.workflow.application_workflow.yml`, sekce `states`) definuje **60 stavů**; **zadání** (baseline JSON) rovněž **60 stavů**.
- **Shoda je vysoká:** všech **60 stavů ze zadání** má přesný protějšek v kódu podle machine-name (alias = klíč stavu ve workflow), včetně identických labelů a i společných překlepů (`feetback`, `proccess`).
- **Jen v zadání:** nic — ze zadání nechybí žádný stav.
- **Jen v kódu:** **9 stavů** navíc — `draft`/`published` (technické moderační stavy Drupal content_moderation, nedoménové), `taken` + `communications` (přebrání leadu a komunikace před žádostí), `canceled` + `canceled_fundraiser` (zrušení leadu / zrušená žádost kvůli nedoplnění žadatelem), `feedback_received` (mezistav zpětné vazby) a `waiting_for_protocol` + `gift_confirmation_approved` (stavy protokolu o převzetí daru; oba ve workflow definované, ale bez jakékoli transition — izolované).
- **Stavy bez vstupní transition** (v kódu definované, ale nedosažitelné přechodem ve workflow — nastavují se patrně programově/cronem): `contract`, `canceled_timeout`, `campaign_uncompleted`, `completed`, `waiting_for_final_doc`.
- **Entita** (`Lead` / `Application` / `Story` / prázdné) je atribut pouze v zadání; workflow YAML entity nerozlišuje (celý workflow je `entity_type application`). Jde o logickou kategorizaci ze zadání, nikoli technický atribut stavu v kódu.
