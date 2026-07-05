---
doc_id: QUERY0014
title: Communication, Activity & Audit Lists
canonical_layer: QUERY
spec_type: query-spec
status: draft
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

# QUERY0014 – Communication, Activity & Audit Lists

## Purpose

Back-office read-models over communication and audit trails: sent-email archive (global and per
application/user), application activity log, campaign log, application reactions (status-message
config), application actions (auto-transition config), feedbacks, transaction mails, and the system
watchdog. These support tracing who was notified, what changed, and system events.

Evidence: `config/views.view.emails.yml`, `config/views.view.emails_per_user.yml`,
`config/views.view.application_activity.yml`, `config/views.view.campaign_log.yml`,
`config/views.view.application_reactions.yml`, `config/views.view.application_actions.yml`,
`config/views.view.feedbacks.yml`, `config/views.view.transaction_mails.yml`,
`config/views.view.watchdog.yml`.

## Consumers

- administrator, manager, coordinator, content_admin, marketing, front (emails);
  administrator (application actions); perm-gated for reactions/campaign-log/watchdog/transaction-mails.
  Per-view role/permission gating recorded below.

## Source Entities

- EN0022 – EmailArchive (emails, emails_per_user)
- EN0025 – ApplicationLog (application activity)
- EN0028 – CampaignLog (campaign log)
- EN0026 – ApplicationReaction (status-message config list)
- EN0027 – ApplicationAction (auto-transition config list)
- EN0021 – Feedback (feedbacks)
- EN0029 – BankTransactionMail (transaction mails)
- EN0001 Application, EN0004 Campaign, EN0008 User (join dimensions)

## Filters and Grouping

| View (path) | Filter / scope | Gating | Notes |
|---|---|---|---|
| `emails` (`admin/emails`, per-application) | Sent emails; exposed from/to/name/template/campaign | administrator, content_admin, coordinator, manager, marketing, front | 500/page, sort id DESC. Confirmed. |
| `emails_per_user` (`admin/user/%user/emails`) | Emails to a given user (`to_user_id` arg) | same roles | Confirmed. |
| `application_activity` (`admin/lead/%application/edit/activities`) | Activity log rows; `field_name = 'activity'` | access: none (route-gated) | Confirmed. |
| `campaign_log` (`admin/campaign-log`) | `field_name = 'campaign_status'`; exposed name/uid/value | perm `access campaign log overview` | Confirmed. |
| `application_reactions` (`admin/application-reactions`) | Status-message config; exposed status/role/initiator/channel toggles | perm `view published application reaction entity entities` | 500/page. Confirmed. |
| `application_actions` (`admin/application-actions`) | Auto-transition config; exposed status/target/interface | administrator | Confirmed. |
| `feedbacks` (`admin/feedbacks`) | Feedback rows; exposed name/campaign | administrator, content_admin, manager, marketing | Confirmed. |
| `transaction_mails` (`admin/transaction-mails`) | Bank/transaction mail archive | perm `view published transaction mails entities` | sort created DESC. Confirmed. |
| `watchdog` (`admin/reports/dblog`) | System log; exposed type/severity | perm `access site reports` | Confirmed. |

## Derived Outputs

| Output | Meaning | Notes |
|---|---|---|
| email columns | name, from, to, application, campaign, template_name, created, view link | PII (recipient addresses). Owned by EN0022. Confirmed. |
| activity columns | actor, field value, note, timestamp | Owned by EN0025. Confirmed. |
| campaign-log columns | story, actor, field value, start/finish | Owned by EN0028. Confirmed. |
| reaction config columns | status, role, initiator, message, zone/email toggles, button action, theme | Owned by EN0026; message content/matrix owned by MSG. Confirmed. |
| action config columns | initiator, status source/target, session interface, cron action/interval | Owned by EN0027. Confirmed. |

## Result Shape

- Paginated back-office tables; several are inline sub-lists on an application/user/story detail page.

## References

- UC: UC0012 (Dispatch Transactional Message), UC0002 (Orchestrate Application Status Change), UC0020 (Emit Ops Alerts / Audit)
- FN: FN0019 (Transactional Messaging), FN0023 (Operational Alerting & Audit)
- EN: EN0022, EN0025, EN0028, EN0026, EN0027, EN0021, EN0029, EN0001, EN0004, EN0008
- MSG: message content / notification matrix owned by the MSG layer (referenced, not restated)
- ARCH: ARCH0010 (Messaging & Marketing), ARCH0012 (Platform, Search & Operations)

## Open Items

- `application_activity` display has view access `type: none`; it relies on the parent route
  (`admin/lead/%application/edit/...`) for protection. Flag for ACL closure. `Conflict — requires clarification.`
- The email archive exposes recipient addresses broadly (six roles incl. `front`); confirm intended
  PII scope. Observation.
