# UC0003 — Assess Applicant Risk (Scoring)

## Header

| Field | Value |
|---|---|
| UC ID | UC0003 |
| Name | Assess Applicant Risk (Scoring) |
| Bounded Context | C2 |
| Primary Actor(s) | Admin, System |
| Trigger Type | UI/Event |

## Actors & Responsibilities

- **Admin** (back-office risk reviewer / coordinator) — opens the manual scoring form for an Application (EN0001), enters the risk assessment, decides the fundraiser/patron blacklist classification, and approves or does not approve the Application to proceed.
- **System** — automatically recalculates a low-risk score whenever an Application transitions into an intermediate review state, without human input; persists scoring results; applies the approval-state gate; propagates blacklist classification to the Contact (EN0006).
- **External(MVCR)** — validates identity-card (ID document) validity for parties named on the Application, at scoring-form display time.
- **External(ARES)** — validates company/IČO registry data reachable from the scoring screen (a client-side-triggered, separate lookup path; not invoked by the form's own submit processing).

## Intent

Assess and record the risk of an Application (EN0001) — covering the fundraiser, patron, and the requested gift — either through a manual, human-reviewed scoring form or through an automatic low-risk recalculation, so that only sufficiently low-risk or explicitly approved Applications can proceed toward fulfilment, and so that risk classifications are reflected in the Blacklist (EN0016) and Contact (EN0006) records.

## Preconditions

- An Application (EN0001) exists and is addressable by its identifier.
- For the manual scoring sub-flow: the Admin holds the permission to view/use the scoring screen for the Application.
- For the manual scoring sub-flow: the Application's associated fundraiser and/or patron ApplicationProfile(s) (EN0002) are expected to be present for full field hydration, though the form does not enforce this as a hard blocking gate.
- For the automatic low-risk sub-flow: the Application has just been saved and its state has changed (or the Application is newly created).

## Main Flow

### UC0003.1 — Manual risk scoring (Admin-reviewed)
1. Admin: Open the scoring screen for a specific Application (EN0001).
2. System: Load the Application's current scoring snapshot together with the fundraiser and patron identity and profile data (EN0002) to pre-fill the scoring form.
3. External(MVCR): Check validity of identity-card numbers entered for the fundraiser, patron, and other named parties, returning a pass/fail indicator per document.
4. Admin: Review the pre-filled and validated fields covering fundraiser, patron, gift, and child information.
5. Admin: Enter or adjust the risk-assessment fields, including a blacklist classification for the fundraiser and/or the patron.
6. Admin: Attach supporting scoring documents, if applicable.
7. Admin: Set the approval decision (e.g. approve, do not approve, or an intermediate outcome) and submit the form.
8. System: Persist any newly attached scoring documents as permanent records.
9. System: Save the full set of submitted scoring fields as the Application's current scoring snapshot.
10. System: If the Application's state was "scoring" at the time of submission and the approval decision is "approved", advance the Application's state to "scoring approved" (scoring_ok); otherwise leave the state unchanged.
11. System: Record a status-history entry for the Application whenever its state changes.
12. System: Apply the submitted blacklist classification to the Contact (EN0006) record(s) matching the fundraiser's and/or patron's e-mail address.
13. System: Trigger the standard Application status-event fan-out (notifications and downstream processing) as part of saving the Application — this occurs on every scoring save, whether or not the state actually changed.

### UC0003.2 — Automatic low-risk scoring (System-driven)
1. System: Detect that an Application (EN0001) has just been saved with a new state and that the new state is the intermediate review state ("to_check").
2. System: Gather the Application's fundraiser, patron, and their respective ApplicationProfiles (EN0002) needed to compute the score.
3. System: If the fundraiser and patron are the same person, record a self-patronage risk penalty that forces the overall score to the lowest (blocking) value.
4. System: Look up the existing blacklist classification (EN0016/EN0006) for the patron by e-mail and translate it into a risk-score contribution.
5. System: If the patron-side contribution is not positive, look up an occupation-based risk indicator and add its contribution.
6. System: Look up the existing blacklist classification for the fundraiser by e-mail and translate it into a risk-score contribution.
7. System: Evaluate the requested gift's risk band (low/medium/high, derived from the gift's category and requested amount) and add its contribution.
8. System: Evaluate the requested gift's payment-type risk indicator and add its contribution.
9. System: Combine all contributions into a total low-risk score, where any single blocking contribution forces the total to the lowest (blocking) value; record a per-component breakdown alongside the total.
10. System: If any required actor or profile data is missing, record the total score as unavailable together with a note explaining the missing data, rather than blocking the save.
11. System: Persist the total low-risk score and its breakdown on the Application (EN0001) without creating a new Application revision or re-running full Application validation.

## Alternative Flows

### AF1 — MVCR document-validity check unreachable
1. External(MVCR): The MVCR document-validity service does not respond or times out during the manual scoring form's field validation.
2. System: Record the check as inconclusive and display a message to the Admin.
3. Admin: Continue completing and submitting the scoring form; the missing validation does not block submission.

Outcome: The scoring form is submitted normally (UC0003.1 continues from the point of interruption); the affected identity-card field is left unvalidated rather than marked valid or invalid.

### AF2 — Approval gate not met
1. Admin: Submit the manual scoring form with an approval decision other than "approved" (e.g. not approved, or an intermediate outcome), or while the Application's current state is not "scoring".
2. System: Save the scoring snapshot as usual but do not advance the Application's state.

Outcome: The Application remains in its prior state; the scoring snapshot and any blacklist classification updates are still persisted.

### AF3 — Coordinator override of a low-risk score
1. Admin: Review the automatically computed low-risk score for an Application in one of the eligible intermediate states.
2. Admin: If the score meets the qualifying threshold, confirm the low-risk decision to advance the Application toward "scoring approved" (scoring_ok).

Outcome: The Application advances via a coordinator-confirmed low-risk path rather than the full manual scoring form. Evidence for the confirmation screen itself is Partial — it is referenced from the automatic low-risk sub-flow's evidence but not one of this UC's assigned dossiers; recorded here only as the counterpart decision point that consumes the score computed in UC0003.2.

### AF4 — ARES registry lookup (client-triggered)
1. Admin: Trigger a company/IČO lookup from the scoring screen.
2. External(ARES): Return registry data for the given company identifier.

Outcome: Registry data is surfaced to the Admin on the scoring screen. Evidence is Partial for this UC's dossiers: the lookup is reachable from the scoring screen but runs as a separate, client-triggered path rather than as part of the form's own submit processing described in UC0003.1.

## Postconditions

- The Application's (EN0001) current scoring snapshot reflects the most recently submitted manual assessment, including the approval decision.
- The Application's state has advanced to "scoring approved" (scoring_ok) if and only if the manual approval gate was met (state was "scoring" and decision was "approved"), or if the automatic low-risk score met the qualifying threshold and was confirmed.
- The Contact (EN0006) record(s) for the fundraiser and/or patron reflect the latest blacklist classification.
- A Blacklist (EN0016) entry exists recording the classification decision made during scoring, linked to the Application.
- The Application's low-risk score and per-component breakdown are up to date whenever the Application has passed through the intermediate review state, independent of whether a manual scoring form was also submitted.
- A status-history entry exists for the Application if its state changed as part of this use case.

## Traceability

Target SRVs:
- Scoring-&-Risk
- MVCR-DocValidity-Adapter
- ARES-Registry-Adapter

EN entities:
- EN0017 ScoringRecord — the scoring snapshot and low-risk score/breakdown produced and updated by this UC
- EN0016 Blacklist — the risk classification entry created for the fundraiser/patron during manual scoring
- EN0001 Application — the aggregate whose state, scoring fields, and low-risk fields this UC reads and mutates
- EN0002 ApplicationProfile — fundraiser/patron profile data consumed to hydrate and to compute scores
- EN0006 Contact — the party record whose blacklist classification is updated as a side effect

Integration boundaries:
- MVCR (identity-card / document validity lookup, read-only, at scoring-form display time)
- ARES (company/IČO registry lookup, client-triggered, separate from form submit)

Flow Evidence:
- FLW0016 (manual scoring form)
- FLW0017 (automatic low-risk scoring on status change)

## Evidence Level

Confirmed — UC0003.1 and UC0003.2 are directly evidenced by FLW0016 and FLW0017 respectively, both rated Confirmed, and grounded in EN0001/EN0002/EN0006/EN0016/EN0017; AF3 (coordinator low-risk confirmation) and AF4 (ARES lookup) are marked Partial within this UC since their originating screens/flows are referenced by the assigned dossiers but were not themselves assigned for detailed mining.
