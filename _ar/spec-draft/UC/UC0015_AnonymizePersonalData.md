# UC0015 — Anonymize Personal Data (GDPR)

## Header

| Field | Value |
|---|---|
| UC ID | UC0015 |
| Name | Anonymize Personal Data (GDPR) |
| Bounded Context | C9 |
| Primary Actor(s) | Admin, Support, System |
| Trigger Type | UI |

## Actors & Responsibilities

- **Admin / Support** — back-office operator with GDPR access rights; submits the email address of the party (User, EN0008) whose personal data must be erased.
- **System** — performs the lookup, mutates the User's identifying fields, enqueues downstream re-synchronization work, and (in production environment only) attempts to remove the party from the marketing CRM.
- **Scheduler** (background, out of the direct trigger path) — later drains the queued re-synchronization work against the search index and the marketing CRM; see Alternative Flow AF2 and the Traceability note on Mautic-CRM-Adapter.

## Intent

Allow an authorized back-office user to erase a party's personally-identifiable login data (email and display name) from the User (EN0008) record on request, in order to satisfy a GDPR right-to-erasure request.

## Preconditions

- The requesting Admin/Support user holds the GDPR-anonymization access permission.
- A User (EN0008) exists whose email matches the value submitted for anonymization.
- No prior confirmation, re-authentication, or second-approval step is required by the current flow.

## Main Flow

### UC0015.1 — Submit and apply anonymization request

1. Admin: Opens the GDPR anonymization form in the back office and enters the email address of the party to be anonymized.
2. Admin: Submits the form to request anonymization.
3. System: Looks up the User (EN0008) whose email matches the submitted value.
4. System: If no matching User is found, displays a "does not exist" message and stops the flow (see AF1).
5. System: Clears the matched User's email field to empty and replaces the User's display name with a randomized value.
6. System: Saves the updated User record.
7. System: Displays a confirmation message that the party has been anonymized.
8. System: Enqueues the anonymized User for re-synchronization to the search index (see UC0018, Index Entities for Search).
9. System: Enqueues the anonymized User for re-synchronization to the marketing CRM (see UC0015.2).
10. System: If the current environment is production, attempts to request removal of the party's contact record from the marketing CRM (see UC0015.3).

### UC0015.2 — Downstream marketing-CRM re-synchronization (async)

1. Scheduler: On the next scheduled run, picks up the queued marketing-CRM synchronization item for the anonymized User.
2. System: Reads the User's current name and email values for the CRM payload.
3. Integration(Mautic): Sends a create-or-update request for the party's contact record, carrying the User's still-populated first/last name alongside the now-empty email.
4. System: Records the CRM contact as synchronized, regardless of the fact that the User was meant to be erased.

### UC0015.3 — Marketing-CRM erasure attempt (production only, synchronous)

1. System: In a production environment, calls the marketing-CRM adapter to request deletion of the party's contact by email, as part of the same anonymization request (UC0015.1, step 10).
2. System: The marketing-CRM adapter's deletion capability performs no actual removal against the CRM — this step evidenced as a defined-but-empty capability (Partial/Hypothesis: intended behavior not implemented; see Evidence Level).

## Alternative Flows

### AF1 — No matching party found

1. System: Finds no User (EN0008) whose email matches the submitted value.
2. System: Displays a "does not exist" message.

Outcome: No anonymization is performed; no queue items are created.

### AF2 — Related party data not cascaded (observed gap)

1. System: Anonymizes only the User's email and display name.
2. System: Leaves the User's first/last name fields, and all personal data held on related Application (see UC0001) and Contact (EN0006) records — including national ID, address, and phone data tied to the same party — unchanged.

Outcome: The party's login credentials are anonymized, but personal data persisted elsewhere for the same party (Contact, Application-linked profiles) remains intact; the erasure is partial. This is a confirmed behavioral gap, not a documented alternative business path.

### AF3 — Repeat submission for an already-anonymized party

1. Admin: Submits the same original email address again after a prior successful anonymization.
2. System: Finds no User matching that email (its email was already cleared in a prior run).
3. System: Displays a "does not exist" message (same as AF1).

Outcome: Repeat requests for the same original email cannot re-target the same party once anonymized once; each distinct successful run re-randomizes the display name and re-enqueues downstream synchronization.

## Postconditions

- The targeted User's (EN0008) email is empty and its display name is a randomized value; the User account remains present and enabled (not deleted, not blocked as a result of this flow).
- A search-index re-synchronization item is queued for the anonymized User (see UC0018).
- A marketing-CRM re-synchronization item is queued for the anonymized User; when processed, it re-creates or updates the party's contact record in the marketing CRM rather than removing it (see UC0015.2).
- In production, a marketing-CRM deletion request is issued but does not remove any data at the CRM (see UC0015.3).
- Personal data held on the Contact (EN0006) record and any Application-linked profile data for the same party is not modified by this use case (see AF2).

## Traceability

Target SRVs:
- Identity-&-Access
- Transactional-Messaging-Orchestrator
- Mautic-CRM-Adapter

EN entities:
- EN0008 User — the party record whose email and display name are anonymized; anchor of this use case.
- EN0006 Contact — related party data holder that is NOT cascaded by this use case (evidenced gap, see AF2).

Integration boundaries:
- Mautic (marketing CRM) — receives an async re-synchronization (create/update) of the anonymized party (UC0015.2) and, in production, a synchronous deletion request that performs no actual removal (UC0015.3).

Flow Evidence:
- FLW0020 (GDPR anonymization)

## Evidence Level

Confirmed for the core anonymization mechanics and its incompleteness (User-only field mutation, no cascade to EN0006/Application PII, no matching-party alternative flow) per FLW0020 and EN0008/EN0006 lifecycle notes. Partial/Hypothesis for the marketing-CRM deletion capability (UC0015.3): FLW0020 evidences it as a defined-but-non-functional (empty) capability rather than working behavior, so it is documented as an observed gap, not a designed alternative.
