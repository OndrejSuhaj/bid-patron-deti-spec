# SRV0013 — Transactional Messaging

Status: Confirmed
> AR:SRVCurator draft · 2026-07-01 · see [SRV-candidates.md](SRV-candidates.md)

## Bounded Context
C8 — Messaging & Marketing

## SRV Category
Integration Adapter

## Responsibility Type
Orchestrator

## Purpose
Sends the platform's transactional e-mails and in-app/zone notifications — the outbound message path invoked on application status changes, payment events, and document fulfilment. It consolidates the mailing service, the email record entity, and the notification subscriber that all share the same transactional-message boundary.

## Current Implementation Shape
- **Mailing service:** `APIMailingService` (281 LOC) + `patron_base.smartmailing` service + `MailingQueue` queue worker. `Evidence:` `PSRC/web/modules/custom/patron_base/src/APIMailingService.php`; `PSRC/web/modules/custom/patron_base/patron_base.services.yml`; [entrypoints.md §5,§8](../repo-map/entrypoints.md).
- **Queue DISABLED:** `APIMailingService::USE_QUEUE = FALSE` — mail is sent synchronously (the `if (self::USE_QUEUE)` branch is not taken), so no retry/async. `Evidence:` `APIMailingService.php:16` (`public const USE_QUEUE = FALSE;`), `:68` (`if (self::USE_QUEUE)`).
- **Email record:** `EmailEntity` (subject/template_name/arguments/body, `sent`/`error`, links to application + campaign; `to_user_id` resolved in `preSave`). `Evidence:` `PSRC/web/modules/custom/email/src/Entity/EmailEntity.php`; [db-models.md `email`](../evidence/db-models.md).
- **Notification consumer:** `notification` module `ApplicationStatusUpdateSubscriber` sends on status-change; `application_reaction` supplies notification body/subject per status+role. `Evidence:` [entrypoints.md §6](../repo-map/entrypoints.md); [db-models.md `application_reaction`](../evidence/db-models.md).
- **Domain validation:** `EmailService` calls WhoisXMLAPI `https://domain-availability.whoisxmlapi.com/api/v1` for recipient-domain checks. `Evidence:` `PSRC/web/modules/custom/email/src/EmailService.php`; [integrations.md §2](../repo-map/integrations.md).
- **Mail plumbing:** `drupal/mailsystem`; dev SMTP via MailHog. `Evidence:` [integrations.md §2](../repo-map/integrations.md).

## Structural Issues
- **Synchronous send (disabled queue)** — `USE_QUEUE=FALSE` means mailing runs in-request from the status event; a mail failure can block the application save path (see SRV0002 orchestration smell). `Evidence:` `APIMailingService.php:16`.
- **Consolidated but duplicated** — `email` + `notification` + `patron_base` mailing paths overlap; SmartMailing vs Mautic provider split is unclear. `Evidence:` [SRV-candidates.md §4 Merges, §7 Tier 2](SRV-candidates.md).
- **Cross-context consumer** — nearly every context (application, payment, documents) reaches this service, so it is a platform-wide dependency. `Evidence:` [SRV-candidates.md §6](SRV-candidates.md).
- **Orphaned display field** — `email.body2` referenced in display config but undefined in code. `Evidence:` [db-models.md `email`](../evidence/db-models.md).

## Target Shape (for rewrite)
A Messaging service behind a `MailTransport` port, always asynchronous (queue/outbox) with retry and delivery status. Templates + per-status/role content (from reaction config) resolved by the service. Notification (in-app/zone) and e-mail as two channels of one messaging port, invoked by domain events not synchronous subscribers.

## Integration Dependencies
- WhoisXMLAPI domain availability — `https://domain-availability.whoisxmlapi.com/api/v1`. `Confirmed` — [integrations.md §2](../repo-map/integrations.md).
- SMTP mail transport (MailHog in dev; prod transport not evidenced). `Confirmed (dev)` — [integrations.md §2](../repo-map/integrations.md).

## Boundaries
Does NOT decide when to send (that is SRV0002 orchestration / domain events). Does NOT own marketing/analytics sync → SRV0014. Does NOT own the notification *content model* beyond delivery (reaction config lives with SRV0002/C1). Does NOT own ops error alerting → SRV0018.

## Spec Alignment
N/A — no pre-existing SRV spec files (see SRV-candidates.md §1).

## Open Questions
- SmartMailing vs Mautic provider branching in the mailing path. `Missing evidence: APIMailingService provider branching.`
- Prod mail transport (which SMTP/relay). `Missing evidence: production mailsystem config.`
- Full status→notification matrix (owned by MSG layer / test-scenarios). `Missing evidence: Notification Matrix reconciliation.`
