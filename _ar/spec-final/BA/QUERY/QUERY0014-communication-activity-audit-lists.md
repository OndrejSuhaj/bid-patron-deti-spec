---
doc_id: QUERY0014
title: Communication, Activity & Audit Lists
layer: QUERY
spec_type: query-spec
status: imported
modules: []
query_type: list
references:
  - EN0022
  - EN0025
  - EN0028
  - EN0026
  - EN0027
  - EN0021
  - EN0029
  - EN0001
  - EN0004
  - EN0008
  - UC0012
  - UC0002
  - UC0020
  - FN0019
  - FN0023
  - ARCH0010
  - ARCH0012
---

# QUERY0014 – Komunikace, aktivity a audit listy

## Účel

Back-office read-modely nad komunikačními a auditními stopami: archiv odeslaných e-mailů (globální
i per žádost/uživatel), log aktivity žádosti, log příběhu, reakce na stav (konfigurace status zpráv),
automatické přechody stavu (konfigurace auto-transition), zpětné vazby, transakční e-maily a systémový
watchdog. Tyto výstupy podporují dohledání toho, kdo byl notifikován, co se změnilo a jaké systémové
události nastaly.

Evidence: `config/views.view.emails.yml`, `config/views.view.emails_per_user.yml`,
`config/views.view.application_activity.yml`, `config/views.view.campaign_log.yml`,
`config/views.view.application_reactions.yml`, `config/views.view.application_actions.yml`,
`config/views.view.feedbacks.yml`, `config/views.view.transaction_mails.yml`,
`config/views.view.watchdog.yml`.

## Konzumenti

- administrator, manager, coordinator, content_admin, marketing, front (e-maily);
  administrator (automatické přechody stavu); perm-gated pro reakce na stav / log příběhu / watchdog /
  transakční e-maily. Gating rolí/oprávnění pro jednotlivé views je zaznamenán níže.

## Zdrojové entity

- EN0022 – EmailArchive (emails, emails_per_user)
- EN0025 – ApplicationLog (aktivita žádosti)
- EN0028 – CampaignLog (log příběhu)
- EN0026 – ApplicationReaction (list konfigurace status zpráv)
- EN0027 – ApplicationAction (list konfigurace automatických přechodů stavu)
- EN0021 – Feedback (zpětné vazby)
- EN0029 – BankTransactionMail (transakční e-maily)
- EN0001 Application, EN0004 Campaign, EN0008 User (join dimenze)

## Filtry a groupování

| View (cesta) | Filtr / rozsah | Gating | Poznámky |
|---|---|---|---|
| `emails` (`admin/emails`, per žádost) | Odeslané e-maily; exposed from/to/name/template/campaign | administrator, content_admin, coordinator, manager, marketing, front | 500/stránka, sort id DESC. Confirmed. |
| `emails_per_user` (`admin/user/%user/emails`) | E-maily danému uživateli (`to_user_id` arg) | stejné role | Confirmed. |
| `application_activity` (`admin/lead/%application/edit/activities`) | Řádky logu aktivity; `field_name = 'activity'` | access: none (řízeno routou) | Confirmed. |
| `campaign_log` (`admin/campaign-log`) | `field_name = 'campaign_status'`; exposed name/uid/value | perm `access campaign log overview` | Confirmed. |
| `application_reactions` (`admin/application-reactions`) | Konfigurace status zpráv; exposed status/role/initiator/channel toggles | perm `view published application reaction entity entities` | 500/stránka. Confirmed. |
| `application_actions` (`admin/application-actions`) | Konfigurace automatických přechodů stavu; exposed status/target/interface | administrator | Confirmed. |
| `feedbacks` (`admin/feedbacks`) | Řádky zpětné vazby; exposed name/campaign | administrator, content_admin, manager, marketing | Confirmed. |
| `transaction_mails` (`admin/transaction-mails`) | Archiv bankovních/transakčních e-mailů | perm `view published transaction mails entities` | sort created DESC. Confirmed. |
| `watchdog` (`admin/reports/dblog`) | Systémový log; exposed type/severity | perm `access site reports` | Confirmed. |

## Odvozené výstupy

| Výstup | Význam | Poznámky |
|---|---|---|
| sloupce e-mailů | name, from, to, application, campaign, template_name, created, odkaz na zobrazení | PII (adresy příjemců). Vlastní EN0022. Confirmed. |
| sloupce aktivity | aktér, hodnota pole, poznámka, časové razítko | Vlastní EN0025. Confirmed. |
| sloupce logu příběhu | příběh, aktér, hodnota pole, start/finish | Vlastní EN0028. Confirmed. |
| sloupce konfigurace reakcí | status, role, initiator, zpráva, zone/email toggles, akce tlačítka, theme | Vlastní EN0026; obsah zprávy / notifikační matice vlastní MSG. Confirmed. |
| sloupce konfigurace akcí | initiator, zdrojový/cílový status, session interface, cron akce/interval | Vlastní EN0027. Confirmed. |

## Tvar výsledku

- Paginované back-office tabulky; několik z nich je inline dílčí seznam na detailu žádosti/uživatele/příběhu.

## Odkazy

- UC: UC0012 (Dispatch Transactional Message), UC0002 (Orchestrate Application Status Change), UC0020 (Emit Ops Alerts / Audit)
- FN: FN0019 (Transactional Messaging), FN0023 (Operational Alerting & Audit)
- EN: EN0022, EN0025, EN0028, EN0026, EN0027, EN0021, EN0029, EN0001, EN0004, EN0008
- MSG: obsah zpráv / notifikační matice vlastní vrstva MSG (odkazováno, nikoli opakováno)
- ARCH: ARCH0010 (Messaging & Marketing), ARCH0012 (Platform, Search & Operations)

## Otevřené body

- `application_activity` má view access `type: none`; ochranu zajišťuje nadřazená routa
  (`admin/lead/%application/edit/...`). Flag pro ACL closure. `Conflict — requires clarification.`
- Archiv e-mailů zpřístupňuje adresy příjemců široce (šest rolí včetně `front`); potvrdit zamýšlený
  rozsah PII. Observation.
