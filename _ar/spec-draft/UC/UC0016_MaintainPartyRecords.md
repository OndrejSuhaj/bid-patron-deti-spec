# UC0016 — Maintain Party Records (Dedup / Merge)

## Header

| Field | Value |
|---|---|
| UC ID | UC0016 |
| Name | Maintain Party Records (Dedup / Merge) |
| Bounded Context | C7 |
| Primary Actor(s) | Admin |
| Trigger Type | UI |

## Actors & Responsibilities

- **Admin** — reviews candidate duplicate groups (contacts, organisations, leads), selects the surviving record, and confirms the merge action in the back office.
- **System** — detects candidate duplicates, reparents dependent records onto the chosen survivor, deletes or nullifies the losing record(s), and triggers downstream re-indexing and status side effects.
- **Scheduler** — (organisation sub-flow only) runs the daily synchronization job that pushes the current organisation registry to the external search index.
- **Integration(Elasticsearch)** — external search index that receives organisation records via the scheduled sync.

## Intent

Keep the party registries (Contact/EN0006, Organisation/EN0018) and the Lead/Application (EN0001) pairing free of duplicates by letting an administrator identify duplicate records and consolidate them onto one surviving record, so that downstream processes (applications, scoring, notifications, search) operate on a single canonical party.

## Preconditions

- Admin holds the permission associated with editing the party type being merged (contact editing permission for contact dedup; application-profile editing permission for organisation dedup; a dedicated pairing permission for lead merge).
- For contact dedup: at least one group of Contacts (EN0006) sharing the same national ID, phone, or email exists and is presented to the Admin.
- For organisation dedup: at least two Organisation (EN0018) records are believed to represent the same entity.
- For lead merge: two Application (EN0001) records exist — a surviving lead and a patron-originated duplicate lead that carries a linked ApplicationProfile.

## Main Flow

### UC0016.1 — Contact de-duplication (merge)

1. Admin: Opens the contact duplicate-review screen.
2. System: Groups existing Contact (EN0006) records into duplicate candidates by matching national ID, phone, or email, excluding any groups the Admin has previously chosen to skip.
3. System: Expands the first candidate group transitively (following any additional phone/email/ID overlaps) and displays it as one duplicate group for review.
4. Admin: Reviews the displayed group and designates one Contact as the surviving record ("main account").
5. Admin: Confirms the merge for the selected survivor.
6. System: For every other Contact in the group, reassigns Application (EN0001) references (lead contact, child, and — where the duplicate is linked to a fundraiser or patron role — the corresponding party reference) to point at the survivor.
7. System: Reassigns ApplicationProfile references (fundraiser, patron, child roles) from each duplicate Contact to the survivor.
8. System: Reassigns any User (EN0008) account whose owning Contact is a duplicate so that its application-level fundraiser/patron references point at the survivor.
9. System: Deletes the User (EN0008) account that owned each duplicate Contact.
10. System: Deletes each duplicate Contact record, including its change history.
11. System: Queues every reparented Application for search re-indexing (SearchIndex-Processor) as a side effect of saving it.
12. System: Displays a success confirmation listing the affected applications.

### UC0016.2 — Organisation de-duplication and worker management

1. Admin: Opens the organisation duplicate-review screen and optionally filters the organisation list by name.
2. System: Displays the matching Organisation (EN0018) records for selection.
3. Admin: Selects one Organisation as the main (surviving) record and one or more other Organisations as duplicates.
4. Admin: Confirms the merge.
5. System: Reassigns the employer reference on every Application (EN0001) that points at a duplicate Organisation to point at the surviving Organisation.
6. System: Deletes each duplicate Organisation record.
7. System: Displays a success confirmation.
8. Admin: Opens the worker management screen for an Organisation to add or edit a worker.
9. Admin: Submits worker details (name, email, phone, admin flag) for a new or existing worker.
10. System: Validates that the name, email, and phone are present and correctly formatted, and — for a new worker — that no User already exists with that email.
11. System: Links the worker to an existing Contact (EN0006) matched by email, creates or updates the corresponding User (EN0008) with the organisation-worker role, and attaches it to the Organisation's worker list together with its admin flag.
12. System: Sends an account-activation message to a newly created worker whose account is not yet active.
13. System: Queues the saved Organisation for search re-indexing as a side effect of saving it.

### UC0016.3 — Scheduled organisation search sync

1. Scheduler: Triggers the daily organisation synchronization job once the configured interval has elapsed.
2. System: Reads the full current list of Organisation (EN0018) records.
3. Integration(Elasticsearch): Receives an upsert of every Organisation record ({id, name}) into the external organisation search index.

### UC0016.4 — Lead pairing / merge

1. Admin: Opens the lead-pairing screen and enters the ID of the surviving main lead and the ID of the patron-originated duplicate lead.
2. System: Validates that both IDs resolve to existing Application (EN0001) records and that the duplicate lead carries a linked ApplicationProfile.
3. Admin: Confirms the pairing.
4. System: Copies the ApplicationProfile reference — and, if present, the linked patron User reference — from the duplicate lead onto the main lead, leaving the main lead's own status unchanged, and saves the main lead.
5. System: If the main lead already holds an ApplicationProfile reference, overwrites it unconditionally with the duplicate's reference; the prior reference is not preserved and becomes unreachable through the main lead (silent data loss on the success path, independent of any failure). Evidence: FLW0025 (Failure Mode #2, Confirmed).
6. System: Sets the duplicate lead's status to "duplicate", clears its ApplicationProfile, fundraiser profile, fundraiser, patron, and child references, and saves the duplicate lead.
7. System: Records a status-history entry for the duplicate lead's transition to "duplicate".
8. System: Queues both saved Applications for search re-indexing as a side effect of saving them.
9. System: Displays a confirmation that the leads were successfully paired.

## Alternative Flows

### AF1 — Admin chooses to skip a contact duplicate group instead of merging

1. Admin: Marks a displayed contact duplicate criterion (shared national ID, phone, or email) to be excluded from future duplicate detection.
2. System: Records the exclusion so the corresponding group is no longer surfaced for review.

Outcome: The candidate group is suppressed from future dedup screens; no Contact records are changed or deleted.

### AF2 — Survivor selection falls outside the currently displayed group

1. Admin: Submits a survivor Contact ID that does not belong to the duplicate group currently displayed.
2. System: Rejects the merge with an internal-error message and takes no action.

Outcome: No Contact, Application, ApplicationProfile, or User record is changed; the Admin must reopen the review screen to obtain a freshly displayed group.

### AF3 — Lead-pairing validation fails

1. Admin: Submits a duplicate lead ID whose Application does not carry a linked ApplicationProfile, or an ID that does not resolve to an existing Application.
2. System: Rejects the pairing with a validation message and takes no action.

Outcome: Neither Application involved is modified; the Admin must correct the input and resubmit.

### AF4 — Mid-merge failure leaves a partially consolidated state

1. System: Encounters an error after reassigning some but not all dependent references during a contact, organisation, or lead merge (no all-or-nothing guarantee covers the sequence of reassignments and deletions).
2. System: Surfaces a generic error message; previously completed reassignments or deletions within the same merge attempt are not undone.

Outcome: Status `Confirmed` — the merge sequence is not evidenced as transactional in any of the three sub-flows; a failure partway through can leave some references pointing at the survivor and others still pointing at the removed or demoted record. This is recorded as observed current-state behavior, not a target-state recommendation.

Reparenting-scope risk (organisation merge, `Confirmed`): even on a fully successful organisation merge (UC0016.2), only the Application (EN0001) employer reference is reparented onto the survivor; non-employer references to a duplicate Organisation (EN0018) — for example worker links held on the Organisation's worker list — are never reparented and are left dangling once the duplicate is deleted. Evidence: FLW0024 (Failure Mode #2, Confirmed).

## Postconditions

- The surviving Contact, Organisation, or main Application holds the consolidated set of references formerly split across the duplicate record(s).
- Duplicate Contact records and their change history are permanently removed; the User account that owned a duplicate Contact is permanently removed.
- Duplicate Organisation records are permanently removed; only the Application employer reference is guaranteed to have been reparented onto the survivor.
- A duplicate lead's Application status is set to "duplicate" and its party references are cleared; the main lead's own status is left unchanged.
- Every Application or Organisation affected by a merge is queued for search re-indexing.
- Newly linked or created organisation workers exist as User records with the organisation-worker role and are attached to the Organisation's worker list.
- The external organisation search index reflects the full current Organisation registry after each scheduled sync run.

## Traceability

Target SRVs:
- Party-&-Contact-Management
- Application-Lifecycle
- Identity-&-Access
- SearchIndex-Processor

EN entities:
- EN0006 Contact — the party record deduplicated/merged in UC0016.1; source of role reassignment onto Applications and ApplicationProfiles.
- EN0018 Organisation — the party record deduplicated/merged and worker-managed in UC0016.2; synced externally in UC0016.3.
- EN0001 Application — holds the references (lead contact, child, employer, fundraiser/patron profile) reparented by all three merge sub-flows; the pairing target/subject in UC0016.4.
- EN0008 User — the account reassigned, deleted, or created as a consequence of contact merge and organisation worker management.
- EN0002 ApplicationProfile — reassigned in UC0016.1, referenced/copied/cleared in UC0016.4; adjacent (touched, not itself deduplicated by this UC).

Integration boundaries:
- Integration(Elasticsearch) — external organisation search index (UC0016.3 daily sync); distinct from the general SearchIndex-Processor re-indexing queue used in UC0016.1/.2/.4.

Flow Evidence:
- FLW0023 (Contact de-duplication / merge)
- FLW0024 (Organisation de-dup + worker management)
- FLW0025 (Lead pairing / merge)

## Evidence Level

Confirmed — all three sub-flows are backed by Confirmed-confidence flow dossiers (FLW0023, FLW0024, FLW0025) with named triggers, ordered steps, and data-footprint evidence; EN0006, EN0018, EN0001, and EN0008 lifecycle sections independently corroborate the merge/reparent/delete transitions and the SearchIndex-Processor side effect referenced here as Confirmed per the SRV traceability matrix (UC-srv-traceability.md).
