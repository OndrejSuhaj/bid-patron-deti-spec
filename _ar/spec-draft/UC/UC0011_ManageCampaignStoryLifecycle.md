# UC0011 — Manage Campaign / Story Lifecycle

## Header

| Field | Value |
|---|---|
| UC ID | UC0011 |
| Name | Manage Campaign / Story Lifecycle |
| Bounded Context | C3 |
| Primary Actor(s) | Admin, Scheduler, System |
| Trigger Type | UI/Cron |

## Actors & Responsibilities

- **Admin** — reviews a candidate Campaign (Story/Příběh, EN0004) and triggers publication ("set active"); implicitly authorizes the linked Application (EN0001) to go public.
- **Scheduler** — invokes the recurring lifecycle check that finds active Campaigns past their deadline and under-funded, without any human trigger.
- **System** — enforces readiness rules before publication, recomputes raised-amount totals, keeps the Campaign and its owning Application state in lock-step, and raises the side effects (search re-index, notification) that follow a state change.

## Intent

Move a Campaign (Story) through its public fundraising lifecycle — from being readied for publication, to active/public, to its terminal outcome (funded/completed or expired/uncompleted) — while keeping the linked Application's status synchronized and downstream systems (search index, notifications) informed of every transition.

## Preconditions

- A Campaign (EN0004) exists, linked 1:1 to an Application (EN0001) via the Application's `campaign` reference.
- The Campaign carries a public Patron profile (EN0005), a target amount, a deadline, and required imagery, as tracked by the Campaign entity.
- The acting Admin holds the permission to change Campaign state.

## Main Flow

### UC0011.1 — Admin publishes / sets a Campaign active

1. Admin: request that a candidate Campaign be published ("set active").
2. System: load the Campaign and resolve its linked Application; abort with an error if no linked Application exists.
3. System: verify the Campaign is ready to activate — a public Patron profile is set, the target amount is a positive value, the deadline parses and lies in the future, and required photos are present; abort with a validation error if any check fails.
4. System: mark the Campaign as active, recording the publication timestamp and the publishing Admin on first activation.
5. System: validate the Campaign's data on activation, including a country-specific deadline rule for Romania (see AF1); abort with a validation error on failure.
6. System: recompute the Campaign's raised amount and raised percentage from confirmed (paid) contributions.
7. System: if the recomputed raised amount already meets or exceeds the target amount, transition the Campaign directly to its completed outcome as a side effect of this save (see UC0011.2 completion logic).
8. System: if the Campaign's public name changed since it was loaded, archive the previous public identifier (slug) before generating a new one.
9. System: enqueue the Campaign for search re-indexing.
10. System: set the linked Application's status to active, recording the transition in the Application's status history.
11. System: save the Application, which enqueues it for search re-indexing and raises an application-status-change notification (see UC0011.3).
12. System: confirm success to the Admin and refresh cached content so the published Campaign is immediately visible.

### UC0011.2 — Scheduled lifecycle transitions (deadline expiry / auto-completion)

1. Scheduler: run the recurring Campaign lifecycle check.
2. System: identify all active Campaigns whose deadline has passed and whose raised amount is still below the target amount.
3. System: for each identified Campaign, set the linked Application's status to "campaign uncompleted," recording the transition (attributed to an automated actor) in the Application's status history.
4. System: save the Application, which enqueues it for search re-indexing and raises an application-status-change notification (see UC0011.3).
5. System: propagate the Application's status change to the linked Campaign, setting its status to "campaign uncompleted" and stamping the uncompleted timestamp.
6. System: recompute the Campaign's raised amount as part of this save and enqueue the Campaign for search re-indexing.
7. System: send an "uncompleted campaign" notification to the relevant supporters and administrators (see UC0011.3).

Note — Confirmed, but auto-completion (a Campaign reaching or exceeding its target amount) is **not** driven by this scheduled check; it is evaluated on every Campaign save (see UC0011.1 step 7) and is most commonly triggered by a payment/contribution being recorded, not by the scheduler. This is recorded here because the readiness dossier for FLW0022 explicitly corrects an initial hypothesis that placed auto-completion in the scheduled job.

### UC0011.3 — Downstream side effects of a Campaign/Application status change

1. System: whenever a Campaign or its linked Application is saved with a changed status, enqueue the affected entity for search re-indexing.
2. System: whenever an Application's status changes, raise an application-status-change notification that downstream subscribers (messaging, scoring, other reactions) consume.
3. System: for the "campaign uncompleted" outcome specifically, resolve the notification recipient list (contributors to the Campaign, an oversight contact, and a fixed operational recipient) and dispatch the "uncompleted campaign" message through the transactional-messaging channel.

## Alternative Flows

### AF1 — Romania-specific deadline validation blocks activation

1. System: during Campaign activation validation (UC0011.1 step 5), detect that the deployment is configured for the Romania market and that the deadline falls on a day requiring a public-holiday check.
2. Integration(Nager.Date): request public-holiday status for the deadline date.
3. System: if the date is confirmed a public holiday, fail the deadline validation and abort activation with a validation error.
4. System: if the holiday lookup itself is unreachable or times out, treat the day as a non-holiday and allow validation to proceed (fail-open).

Outcome: Activation is blocked only when the external holiday check is reachable and positively confirms a holiday; on lookup failure the Campaign can still activate, which is a known fail-open gap.

### AF2 — Activation guard failures

1. Admin: request that a candidate Campaign be published ("set active").
2. System: detect that the Campaign has no linked Application, or that a readiness check (Patron profile, target amount, deadline, required photos) fails.
3. System: present a validation error to the Admin and leave the Campaign and Application state unchanged.

Outcome: The Campaign remains in its pre-activation state; no downstream side effects occur.

### AF3 — Partial commit between Campaign and Application saves

1. System: complete the Campaign activation save (UC0011.1 steps 4–9), making the Campaign active.
2. System: attempt to save the linked Application's new active status (UC0011.1 steps 10–11) and this save fails.

Outcome: The Campaign is left active while its linked Application is not — a known consistency gap, since the two saves are not wrapped in a single transaction.

## Postconditions

- On successful publication: the Campaign's status is active, its publication timestamp and publishing Admin are recorded (first activation only), its raised amount/percentage are refreshed, and its linked Application's status is active with a corresponding status-history entry.
- On scheduled expiry: the Campaign's status is "campaign uncompleted" with its uncompleted timestamp set, its raised amount is refreshed, and its linked Application's status is "campaign uncompleted" with a corresponding status-history entry; an "uncompleted campaign" notification has been dispatched.
- On funding completion (triggered from any save, including publication): the Campaign and its linked Application reach their completed outcome (see EN0004 lifecycle; full completion behavior belongs to the Donations/payment use case, not this UC).
- In all cases where a status changed, the affected Campaign and/or Application is queued for search re-indexing.

## Traceability

Target SRVs:
- Campaign-&-Story-Lifecycle
- Application-Status-Orchestrator
- Transactional-Messaging-Orchestrator
- SearchIndex-Processor

EN entities:
- EN0004 Campaign — the Story/Příběh whose lifecycle (in-progress → active → completed / campaign_uncompleted) this UC governs
- EN0001 Application — the linked aggregate root whose `state` is kept in lock-step with the Campaign's status
- EN0005 Patron — the public patron profile whose presence is a precondition for activation (read-only in this UC)
- EN0028 CampaignLog — related per-Campaign field-change audit entity; no writer flow was mined for it in FLW0021/FLW0022, so it is not asserted as part of this UC's confirmed behavior (Hypothesis only, per EN0028)

Integration boundaries:
- Nager.Date (public-holiday lookup, Romania-only deadline validation — AF1)

Flow Evidence:
- FLW0021 (Campaign publish / set-active)
- FLW0022 (Campaign lifecycle cron — deadline expiry; auto-completion cross-referenced but not owned by this flow)

## Evidence Level

Confirmed — grounded in FLW0021 and FLW0022 (both Confirmed-confidence dossiers) against SRV0005 (Campaign-&-Story-Lifecycle) with cross-cutting touches on Application-Status-Orchestrator, Transactional-Messaging-Orchestrator and SearchIndex-Processor, and consistent with the Confirmed lifecycle transitions recorded in EN0004 and EN0001; the EN0028 CampaignLog link is explicitly marked Hypothesis since no mined flow writes it.
