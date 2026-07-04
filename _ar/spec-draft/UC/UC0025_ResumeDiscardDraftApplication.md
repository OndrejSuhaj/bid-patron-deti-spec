# UC0025 — Resume or Discard Draft Application

## Header

| Field | Value |
|---|---|
| UC ID | UC0025 |
| Name | Resume or Discard Draft Application |
| Bounded Context | C1 |
| Primary Actor(s) | Customer |
| Trigger Type | UI/API |

## Actors & Responsibilities

- **Customer** — the fundraiser or patron who started (or was invited into) an Application (EN0001)
  intake session and, on returning to the site with that session still active, chooses to resume,
  ignore, or delete the unfinished Application.
- **System** — validates the client-held ApplicationSession (EN0003) against the Application, returns
  the persisted form-fill state for resume, records incremental progress on the ApplicationProfile
  (EN0002) while the Customer keeps working, and — on explicit delete — sets the Application to a
  user-cancelled status without going through the role-gated status-transition machinery used
  elsewhere.

## Intent

Let a Customer who holds a still-active ApplicationSession (EN0003) for a not-yet-submitted
Application (EN0001) either continue filling it in from where they left off, leave it untouched for
later, or explicitly discard it — independent of, and without repeating, self-registration (UC0001).

## Preconditions

- An Application (EN0001) already exists in an open (not yet completed/cancelled) status, created by
  a prior UC0001 self-registration or Admin-initiated flow.
- At least one ApplicationSession (EN0003) for that Application is still `Active` (not deactivated),
  identified by the pair (`application_uuid`, `session_id`).
- The client (front-end) holds the `application_uuid` + `session_id` pair from the original intake —
  observed as query parameters (`?session=...&application=...`) on the SPA form URL used in the
  activation/invitation email link. **Partial** — how the client persists and later re-detects this
  pair across visits/page loads (e.g. local storage, cookie) to decide *when* to show the "you have an
  unfinished application" prompt is front-end (SPA) behaviour not present in this backend source;
  not evidenced here.

## Main Flow

### UC0025.1 — Resume the draft Application

1. Customer: returns to the site holding a session/application identifier pair for a not-yet-submitted
   Application, and chooses to continue it (UI evidence: "Návrat do žádosti").
2. System: validates the (`application_uuid`, `session_id`) pair against an `Active` ApplicationSession
   (EN0003) for that Application.
3. System: rejects the request when the session is not found or not active, without exposing the
   Application's data.
4. System: loads the Application (EN0001) and determines the role (fundraiser or patron) carried by
   the validated ApplicationSession.
5. System: loads the corresponding ApplicationProfile (EN0002) for that role, if one already exists,
   and returns the session's interface/schema plus the already-filled profile fields (excluding file
   attachments and consent flags, which are not returned) so the form can be re-rendered pre-filled.
6. Customer: continues filling in and submitting the remaining steps of the Application form.

Outcome: The Customer resumes editing the same Application (EN0001) from its last saved field state;
no new Application or ApplicationSession is created.

### UC0025.2 — Keep the draft without acting (dismiss the prompt)

1. Customer: is shown the unfinished-Application prompt and chooses to stay on the current page instead
   of resuming or deleting it (UI evidence: "Zůstat na stránce").
2. System: takes no action — the Application (EN0001) and its ApplicationSession (EN0003) records are
   left unchanged.

Outcome: The draft Application remains open and untouched; the prompt may reappear on a later visit
while the session is still active.

### UC0025.3 — Delete (cancel) the draft Application

1. Customer: chooses to discard the unfinished Application entirely (UI evidence: "Smazat žádost").
2. System: validates the (`application_uuid`, `session_id`) pair against an `Active` ApplicationSession
   (EN0003) for that Application, as in UC0025.1 step 2–3.
3. System: loads the Application (EN0001) by its UUID.
4. System: sets the Application's status directly to `canceled_by_user` ("Zrušeno uživatelem") and
   saves it — this is an unconditional state assignment, not a role-gated status transition of the kind
   used elsewhere in the Application lifecycle (see BR note below).
5. System: confirms the deletion to the Customer.

Outcome: The Application (EN0001) is left in the terminal `canceled_by_user` status; its
ApplicationSession (EN0003) records are not evidenced to be deactivated by this action (see Open
Questions). No Application data rows are physically deleted — "Smazat žádost" is a status change, not
a hard delete.

## Alternative Flows

### AF1 — Session invalid or already deactivated

1. System: does not find an `Active` ApplicationSession (EN0003) matching the submitted
   (`application_uuid`, `session_id`) pair (e.g. it was already deactivated by a status-driven reaction,
   per EN0003's State Transitions).
2. System: returns a failure/invalid-session result for whichever action was attempted (resume or
   delete), without changing the Application.

Outcome: The requested resume or delete does not proceed. Evidence Level: Confirmed for the
resume/progress path (`ApplicationGETResource`, `ApplicationProgressResource` both return an explicit
invalid-session failure); Partial for delete — `CancelApplicationResource` returns the same
"Session is invalid" failure shape, but whether the front-end still offered the delete action on an
already-inactive session is not evidenced.

### AF2 — Required identifiers missing

1. Customer/client: submits a resume, progress, or delete request without both the application and
   session identifiers.
2. System: rejects the request immediately with a validation failure, before any session lookup.

Outcome: No Application or ApplicationSession state changes.

## Postconditions

- Resume (UC0025.1): the Application (EN0001) and its ApplicationProfile (EN0002) are unchanged by the
  read itself; the Customer is positioned to continue editing.
- Stay (UC0025.2): no state change.
- Delete (UC0025.3): the Application (EN0001) status is `canceled_by_user`; the Application is excluded
  from active-application listings that filter out cancelled/closed states (confirmed elsewhere in the
  dossier to be excluded from, e.g., duplicate-child-application checks).

## Business Rules

- **BR note (flagged, not owned here):** `CancelApplicationResource` / its v3.2 counterpart set the
  Application's status via a direct `setState('canceled_by_user')` call rather than via the
  role-gated transition/workflow path (`getAllowedStates()`/`getTransitions()`) used by admin-side
  status changes (UC0002). This UC records the observed behaviour; ownership of the invariant ("may a
  Customer self-cancel their own Application unconditionally, bypassing transition rules?") belongs to
  a BR doc (BR-ApplicationStatusGovernance), not to this UC.

## Traceability

Target SRVs:
- Application-Lifecycle
- Identity-&-Access

EN entities:
- EN0001 Application — the draft Application resumed, left untouched, or cancelled by this UC.
- EN0002 ApplicationProfile — the role-specific form data read (resume) and incrementally updated
  (progress-save) by this UC.
- EN0003 ApplicationSession — the access/session record whose validity gates every action in this UC.

Integration boundaries:
- None — this UC is entirely internal (session validation + Application/ApplicationProfile
  read-or-state-change); no external system is called.

Flow Evidence:
- FLW0010 (Fundraiser/Patron self-registration) — establishes the ApplicationSession pair this UC later
  validates; documents that "an abandoned registration leaves a bare `new` lead + 2 sessions + user +
  contact," i.e. the precondition state this UC acts on.
- Code evidence (not yet promoted to a FLW dossier): `application/src/Plugin/rest/resource/v30/
  ApplicationGETResource.php` (resume — session validation + profile read), `application/src/Plugin/
  rest/resource/ApplicationProgressResource.php` (incremental progress save while a draft is kept open),
  `application/src/Plugin/rest/resource/CancelApplicationResource.php` and its `v32` counterpart
  (delete/cancel), `application/src/ApplicationService.php` (`isSessionValid`, `getApplicationSession`,
  `getApplicationByUuid`).

## Evidence Level

Partial — the backend session-validate/resume (`ApplicationGETResource`), progress-save
(`ApplicationProgressResource`), and cancel (`CancelApplicationResource`/v32) REST resources are
Confirmed in code, and the `canceled_by_user` status is Confirmed in `application_states.yml` and
`intake/statuses/statuses.md`. What is **not** evidenced from this backend source, and is therefore
Hypothesis/Partial:

- The exact client-side trigger condition for showing the "Máte u nás rozpracovanou žádost" modal
  (screenshot evidence: `/dekujeme` page, `_ar/evidence/ui/ui-observed-areas.md` §13) — whether it is
  driven by a locally-stored session/application identifier, a cookie, or a server-side "does this user
  have an open Application" check, is front-end (SPA) logic not present in this repository.
- Whether "Zůstat na stránce" (UC0025.2) triggers any backend call at all, or is a pure client-side
  no-op (no matching REST resource found for a "dismiss" action).
- Whether deleting an Application (UC0025.3) also deactivates its ApplicationSession (EN0003) records —
  `CancelApplicationResource` changes only the Application's status; no call to
  `ApplicationService::deactivateSession`/`deactivateSessions` was found in that resource's code path.
- No dedicated FLW dossier (`_ar/evidence/flow/FLW00xx`) exists yet for the resume/progress/cancel REST
  resources cited above; this UC cites the source files directly per the anti-hallucination rule
  (traceable to `intake/current-solution/_source/patronus/`) pending a FLOW-EVIDENCE pass.

## Open Questions

- Does "Zůstat na stránce" call any backend endpoint, or is it purely a client-side dialog dismissal
  with no System-side postcondition? Not evidenced in the REST resource set searched.
- Is the client-side prompt driven by a persisted local identifier (e.g. `localStorage`) or by a
  server-side lookup of the Customer's own open Applications? Determines whether this modal can appear
  for an anonymous return visit versus only for an authenticated one.
- Does `CancelApplicationResource`'s direct `setState('canceled_by_user')` bypass any downstream
  reactions (EN0026 ApplicationReaction) that are normally fired on a transition-driven status change
  (UC0002.2), e.g. session-deactivation reactions? If the state is set outside the transition/dispatch
  path used elsewhere, EN0003's "Active → Deactivated (all sessions)" trigger may not fire for this
  path — meaning a deleted Application could still have `Active` ApplicationSession rows. Flag for
  EN0003 / BR-ApplicationStatusGovernance follow-up.

## Relationship to UC0001

**Judgement: kept as a standalone UC, not folded into UC0001 as an alternative flow.** UC0001 (Submit
Application) models a single linear intent — register and create the Application — and its
Alternative Flows (AF1–AF4) are all variations that occur *within* that same registration transaction
(already-authenticated Customer, existing-email re-submission, validation failures). UC0025 is a
distinct user goal that:

- is triggered on a **separate, later visit** to the site, decoupled in time from the original UC0001
  submission (the resume modal is observed on the `/dekujeme` post-payment page — an entirely unrelated
  transaction — confirming it is not scoped to the UC0001 session lifetime);
- is served by a **different set of REST resources** (`ApplicationGETResource`,
  `ApplicationProgressResource`, `CancelApplicationResource`) than UC0001's registration/creation
  resources (`UserCreateForm`, `application_create_resource`);
- has its own **three-way outcome** (resume / keep-as-is / delete) that has no equivalent in UC0001's
  flow; and
- can act on an Application regardless of *how* it was created (self-registration, Admin-initiated, or
  invited counterpart), i.e. it is not a variant of the creation step but a lifecycle-management
  capability layered on top of any already-existing draft.

This judgement is offered for the report; per write-scope, UC0001 itself is not modified here.
