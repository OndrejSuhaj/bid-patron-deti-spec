---
doc_id: ARCH0011
title: Identity & Access Domain
canonical_layer: ARCH
spec_type: architecture
status: draft
references:
  - ARCH0001
  - ARCH0002
  - EN0008
  - EN0006
  - EN0007
  - UC0014
  - UC0015
  - FN0018
  - FN0021
  - MSG0003
  - MSG0004
  - BR-AccessControlAndRoles
  - BR-DataProtectionAndErasure
---

# ARCH0011 – Identity & Access Domain

> Domain navigation document for bounded context **C9 Identity & Access** (ARCH0001 §4).
> Navigation layer only — links deeper artifacts by `doc_id`, does not restate them. Current-state.

## Purpose

Explains the architectural perspective of **authentication, sessions, the role model, and GDPR
anonymisation**. It is the command surface over the same party the Party / CRM domain (C7) owns:
password and magic-link auth, self-registration, provisioning users from approved applications, the
role set that gates every actor, and personal-data erasure.

---

## System Overview

C9 shares the **Party aggregate (AG7)** with C7 — it does not own a separate aggregate; it contributes
the auth/GDPR commands on the User ([ARCH0001](../ARCH0001_ApplicationOverview.md) §4;
[EN0008](../EN/EN0008_User.md)). Actors are differentiated by **role**, not a separate account type,
across ~15 roles (administrator, coordinator, accountant, risk_manager, fundraiser, patron, supporter,
organisation_worker, …) (ARCH0001 §2). The context carries several current-state auth weaknesses
(long magic-token TTL, inactive brute-force limits, no login records) and a **GDPR compliance gap**:
erasure only blanks part of the user in place and is undone by the C8 CRM re-sync (anti-erasure —
ARCH0001 §8 Risk 3; FN0021). Personal-data anonymisation is kept as its own capability given the
distinct legal concern.

---

## Structural Components

- **Identity-&-Access** (Domain service) — password + magic-link auth, sessions, self-register,
  provision User/Contact from an approved application, the role model, supporter-grant-on-first-PAID.
  Capability: [FN0018](../FN/FN0018_IdentityAccessControl.md).
- **Personal-data anonymisation** (GDPR erasure) — kept distinct from auth. Capability:
  [FN0021](../FN/FN0021_PersonalDataAnonymisation.md).
- **Shared aggregate** — contributes to AG7 Party (root User [EN0008](../EN/EN0008_User.md); Contact
  [EN0006](../EN/EN0006_Contact.md); Account [EN0007](../EN/EN0007_Account.md) *dormant*), whose
  lifecycle otherwise resides in C7 ([ARCH0009](ARCH0009_PartyAndCrm.md)).

---

## Interaction Model

Per [ARCH0002](../ARCH0002_ContextInteractionMap.md) §(a)/(c):

- Provisions User+Contact **synchronously** when **C1** submits an application and when **C4** resolves
  an anonymous donor (ARCH0002 §(a)).
- The **supporter** role is granted into the party by **C4**'s first-PAID cascade (ARCH0002 §(c)).
- Authentication and account activation dispatch magic-link / activation messages via **C8**
  ([UC0014](../UC/UC0014_AuthenticateManageAccess.md);
  [MSG0003](../MSG/MSG0003_AccountActivation.md), [MSG0004](../MSG/MSG0004_MagicLinkLogin.md)).
- GDPR anonymisation ([UC0015](../UC/UC0015_AnonymizePersonalData.md)) mutates the shared party record
  (C7) and delegates CRM removal to **C8**, whose re-upsert currently undoes the erasure (ARCH0002
  §(c), anti-erasure).

---

## Cross-links

- **relatedEN:** EN0008, EN0006, EN0007 (shared with C7's AG7 Party)
- **relatedUC:** UC0014, UC0015 (participates in UC0001, UC0005, UC0006, UC0016)
- **relatedFN:** FN0018, FN0021
- **relatedES:** (none directly — auth email dispatch via C8)
- **relatedMSG:** MSG0003, MSG0004 (activation & magic-link login; transport owned by C8)
- **relatedBR:** BR-AccessControlAndRoles
  ([../BR/BR-AccessControlAndRoles.md](../BR/BR-AccessControlAndRoles.md)),
  BR-DataProtectionAndErasure ([../BR/BR-DataProtectionAndErasure.md](../BR/BR-DataProtectionAndErasure.md))
  — party identity/dedup rules are owned by C7's
  [BR-PartyIdentityAndDeduplication](../BR/BR-PartyIdentityAndDeduplication.md).
