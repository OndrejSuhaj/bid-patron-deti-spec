---
doc_id: FN0021
title: Personal-Data Anonymisation (GDPR)
canonical_layer: FN
spec_type: functional-capability
status: draft
references:
  - UC0015
  - EN0008
  - EN0006
  - FN0015
  - FN0022
---

# FN0021 – Personal-Data Anonymisation (GDPR)

## Purpose

Lets an authorized back-office user erase a party's personally-identifiable login data (email and
display name) from the User (EN0008) record on request, so that a GDPR right-to-erasure request can
be actioned, and enqueues the downstream re-synchronisations that follow from that mutation.

---

## Responsibilities

The capability is responsible for:

- Looking up the User (EN0008) by a submitted email address, clearing the matched User's email field
  and replacing its display name with a randomized value, and saving the updated record.
- Enqueueing the anonymised User for search-index re-synchronisation (FN0022) and for marketing-CRM
  re-synchronisation (FN0015) as side effects of the same request.
- Attempting a marketing-CRM contact-deletion request as part of the same request when the current
  environment is production.

---

## Related Use Cases

- UC0015 – Anonymize Personal Data (GDPR)

---

## Related Entities

- EN0008 – User
- EN0006 – Contact

---

## Integrations

No direct external-system call is owned by this capability itself. The downstream marketing-CRM
contact upsert/delete is delegated to FN0015 (Marketing / CRM Synchronisation), which targets Mautic —
see ARCH0002_ContextInteractionMap for the platform's integration landscape.

---

## Constraints

- The erasure is partial and not GDPR-compliant end-to-end: only the User's email and display name
  are mutated; the User's first/last name fields and all personal data held on related Application and
  Contact (EN0006) records — including national ID, address, and phone data tied to the same party —
  are left intact, with no cascade to those records.
- The marketing-CRM contact-deletion path invoked in production is a defined-but-empty capability that
  performs no actual removal at the CRM.
- The marketing-CRM re-synchronisation queued by this capability (drained by FN0015) re-upserts the
  anonymised party's contact record with first/last name still populated, working against the erasure
  intent rather than completing it.
- No confirmation, re-authentication, or second-approval step gates the anonymisation action.
- Once a party's User email has been cleared by a successful run, a repeat request against the same
  original email address can no longer locate or re-target that party.
