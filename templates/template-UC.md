---
doc_id: UCxxxx
title: <Actor Verb Object>
canonical_layer: UC
spec_type: use-case
status: draft | canonical
references:
  # referenced doc_ids (must resolve in their layer registry):
  # - ENxxxx, BRxxxx, ACLxxxx, APIxxxx, ESxxxx, JOBxxxx
---

# UCxxxx – <Actor Verb Object>

## Trigger

Event that starts the use case.

---

## Preconditions

Conditions that must hold before execution.

---

## Main Flow

1. Actor initiates the operation.
2. System validates the request.
3. System performs the operation.
4. System updates affected entities.

Example lifecycle transition:

System changes Entity state Draft → Active.

---

## Alternative Flows

3A – Validation fails

System rejects the request.

If no alternative flows exist:

No alternative flows are defined.

---

## Postconditions

State of the system after successful completion.

---

## Affected Entities

ENxxxx – Entity Name

---

## Evidence level

One label from the closed set, with a one-line justification of the confidence that this flow
reflects the intended system behavior:

Confirmed | Partial | Uncertain | Blocked