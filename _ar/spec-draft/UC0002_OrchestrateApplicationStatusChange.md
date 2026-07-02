# UC0002 — Orchestrate Application Status Change

## Header

| Field | Value |
|---|---|
| UC ID | UC0002 |
| Name | Orchestrate Application Status Change |
| Bounded Context | C1 |
| Primary Actor(s) | Admin, System |
| Trigger Type | UI / Event / Cron |

## Actors & Responsibilities

- **Admin** — back-office user who selects and submits a new status for an Application (EN0001) via a status-change form.
- **System** — persists the new status, appends the audit record, and unconditionally raises a status-update event on every save; downstream, System also carries out each reaction (log, session, scoring, document, messaging, search-index) triggered by that event.
- **Scheduler** — periodically triggers the automatic status-transition pass (cron) that moves aged Applications from one status to another according to configured rules.

## Intent

Provide the single point through which an Application's (EN0001) status is changed — whether by a human decision, an automatic time-based rule, or system logic — and guarantee that every status change consistently triggers the correct downstream reactions (audit logging, messaging, risk scoring, document/session creation, search re-indexing) regardless of which route triggered the change.

## Preconditions

- The Application (EN0001) exists and is in some current status.
- For the human-driven sub-flow: the Admin holds a permission that allows changing an Application's status.
- For the automatic sub-flow: an ApplicationAction (EN0027) rule exists, is active, and is configured so its trigger/initiator is the scheduled (cron) type.

## Main Flow

### UC0002.1 — Admin changes Application status

1. Admin: Opens a status-change form for a target Application (EN0001).
2. Admin: Selects a new status value and optionally enters a note.
3. Admin: Submits the form.
4. System: Sets the Application's (EN0001) status to the submitted value and records the optional note.
5. System: Appends a status-history audit record capturing the Application, the new status, the acting user, the note, and the timestamp.
6. System: Creates a new revision of the Application (EN0001) recording the note and the acting user.
7. System: Persists the Application (EN0001), which unconditionally raises a status-change event — regardless of whether the status value actually changed.
8. System: Continues into the downstream reaction fan-out described in UC0002.2.

Note (Evidence Level: Confirmed with caveat): the "orchestrator" role is not a distinct service call — it is realized as a side effect of saving the Application (EN0001) entity. Every save triggers the same event fan-out, whether or not the status actually changed; individual downstream reactions are responsible for detecting whether a real status change occurred.

### UC0002.2 — Downstream reaction fan-out on status change

1. System: Evaluates whether the Application's (EN0001) status actually differs from its prior value, as a gate for the reactions that require a real change.
2. System: Queues the Application (EN0001) for search re-indexing (SearchIndex-Processor), independent of whether the status value changed.
3. System: Looks up configured ApplicationReaction (EN0026) records matching the Application's new status and relevant role.
4. System: For each matching ApplicationReaction (EN0026), appends an ApplicationLog (EN0025) entry recording the reaction.
5. System: For each matching ApplicationReaction (EN0026) that specifies a session interface, creates an ApplicationSession (EN0003) for the relevant role.
6. System: For each matching ApplicationReaction (EN0026) with notification enabled, dispatches a status-driven transactional message (Transactional-Messaging-Orchestrator) to the resolved recipient.
7. System: Checks whether the new status is configured to invalidate sessions; if so, deactivates all ApplicationSession (EN0003) records for the Application (EN0001) and appends an ApplicationLog (EN0025) entry recording the session cancellation.
8. System: When the new status is the risk-review status, recomputes and stores the Application's (EN0001) low-risk score (Scoring-&-Risk).
9. System: When the new status represents entry into a signature-waiting or feedback-waiting status (and the relevant feature is enabled), generates the acceptance-protocol document (Document-Generation-&-Fulfilment) and creates a corresponding ApplicationSession (EN0003) carrying a signing or feedback form.
10. System: When a Story (Campaign, EN0004) is attached to the Application (EN0001), synchronizes the Story's status/category to remain consistent with the new Application status and re-persists the Story.

Outcome: all configured reactions for the new status have executed; the Application (EN0001), its sessions, its audit log, and (where applicable) its linked Story are consistent with the new status.

### UC0002.3 — Scheduler-driven automatic status transition

1. Scheduler: Triggers the periodic automatic-transition pass.
2. System: Loads active ApplicationAction (EN0027) rules whose trigger type is configured as scheduled/cron.
3. System: For each active rule, selects Applications (EN0001) currently in the rule's source status whose time in that status exceeds the rule's configured age threshold.
4. System: For each selected Application (EN0001), changes its status to the rule's target status, attributed to the system service account, which re-enters the Main Flow at UC0002.1 step 4 (status set → audit → save → fan-out).
5. System: If the rule specifies an additional automatic action, executes that action against the Application (EN0001) (ApplicationAction-Processor).

Evidence note: this sub-flow is grounded in the ApplicationAction (EN0027) entity definition (config-side evidence only); the cron trigger flow itself is not part of the mined flow dossiers assigned to this UC and is therefore **Partial** — behavior is inferred from the EN0027 entity documentation, not from a flow dossier.

## Alternative Flows

### AF1 — Status change submitted with no actual status difference

1. Admin: Submits a status-change form with the same value as the Application's (EN0001) current status.
2. System: Still appends a status-history audit record and still raises the status-change event (no change-guard exists at this point).
3. System: Runs the downstream reaction fan-out (UC0002.2); reactions that gate on an actual status difference perform no additional action, while the audit record and search re-index queue entry are still produced.

Outcome: a duplicate audit trail entry is created even though the Application's (EN0001) effective status did not change; this is a known consistency gap, not an intended business behavior.

### AF2 — Reaction fan-out encounters a failure mid-sequence

1. System: While executing one of the reactions in UC0002.2 (e.g. document generation), encounters an error.
2. System: The error interrupts the remaining reactions in the same fan-out pass; reactions already completed (e.g. audit log, prior notifications) remain persisted.

Outcome: the Application (EN0001) may end up in a state where the status was changed and some reactions ran, but later reactions in the sequence did not — a partial-completion risk inherent to the current synchronous, unguarded design.

### AF3 — Applicant record enters a returned-to-new-patron status

1. Admin: Changes an Application's (EN0001) status to the status representing "returned as a new patron."
2. System: As part of persisting the Application (EN0001) (Main Flow step 4-7), also scrubs patron-related profile and scoring data from the Application.

Outcome: the Application (EN0001) proceeds through the normal fan-out (UC0002.2) with patron data cleared.

## Postconditions

- The Application's (EN0001) status reflects the submitted or automatically-determined new value, with a new revision recorded.
- A status-history audit record (ApplicationLog EN0025 or equivalent history record) exists for the transition.
- Any configured ApplicationReaction (EN0026) for the new status has produced its log entries, sessions, and/or notifications.
- Sessions (EN0003) have been deactivated if the new status is configured to invalidate them.
- The Application's (EN0001) low-risk score has been recomputed if the new status is the risk-review status.
- An acceptance-protocol document and signing/feedback session exist if the new status entered a signature- or feedback-waiting status.
- A linked Story (Campaign, EN0004), if any, has its status/category synchronized to the Application's new status.
- The Application (EN0001) has been queued for search re-indexing.

## Traceability

Target SRVs:
- Application-Status-Orchestrator
- ApplicationAction-Processor
- Transactional-Messaging-Orchestrator
- Scoring-&-Risk
- Document-Generation-&-Fulfilment
- SearchIndex-Processor

EN entities:
- EN0001 Application — the aggregate whose status is changed and orchestrated
- EN0025 ApplicationLog — audit/reaction log rows appended by the fan-out
- EN0026 ApplicationReaction — configuration matched by status/role driving log, session, and notification output
- EN0027 ApplicationAction — configuration driving the automatic cron-based status transitions (UC0002.3)
- EN0003 ApplicationSession — sessions created and deactivated as part of the fan-out
- EN0004 Campaign (Story) — adjacent, referenced for status-sync side effect; not part of this UC's core assigned set.

Integration boundaries:
- None (this UC is internal orchestration; downstream messaging/search/document effects go through their own UCs and SRVs, no direct external system call in this UC itself)

Flow Evidence:
- FLW0002 (Application status change workflow — UC0002.1)
- FLW0001 (Application status event fan-out — UC0002.2)
- FL009 (automatic cron transitions — UC0002.3, un-mined, Partial; grounded only in EN0027)

## Evidence Level

Confirmed for UC0002.1 and UC0002.2 (FLW0002 and FLW0001 are both rated Confirmed and directly evidence the status-set/audit/revision/save sequence and the three-subscriber reaction fan-out, cross-checked against EN0001, EN0025, EN0026, EN0003). Partial for UC0002.3: the automatic cron transition is evidenced only by the ApplicationAction (EN0027) entity documentation, not by a mined flow dossier (FL009 was not assigned/mined), so its exact trigger cadence and error handling are not independently confirmed.
