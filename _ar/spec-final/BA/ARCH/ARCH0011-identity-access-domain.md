---
doc_id: ARCH0011
title: Identity & Access Domain
canonical_layer: ARCH
spec_type: architecture
status: canonical
modules: []
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

# ARCH0011 – Doména identity a přístupu (Identity & Access)

> Navigační dokument domény pro ohraničený kontext **C9 Identity & Access** (ARCH0001 §4).
> Pouze navigační vrstva — odkazuje na hlubší artefakty pomocí `doc_id`, neopakuje jejich obsah. Current-state.

## Účel

Vysvětluje architektonický pohled na **autentizaci, relace, model rolí a GDPR anonymizaci**. Jde o
příkazové rozhraní nad stejnou stranou (party), kterou vlastní doména Party / CRM (C7): autentizaci
heslem a pomocí magic-linku, samoregistraci, provisioning uživatelů ze schválených žádostí, sadu rolí,
která hlídá přístup každého aktéra, a výmaz osobních údajů.

---

## Přehled systému

C9 sdílí **agregát Party (AG7)** s C7 — nevlastní samostatný agregát; přispívá příkazy
auth/GDPR nad entitou User ([ARCH0001](../ARCH0001_ApplicationOverview.md) §4;
[EN0008](../EN/EN0008_User.md)). Aktéři jsou odlišeni **rolí**, nikoli samostatným typem účtu,
napříč ~15 rolemi (administrator, coordinator, accountant, risk_manager, fundraiser, patron, supporter,
organisation_worker, …) (ARCH0001 §2). Kontext nese několik current-state slabin v autentizaci
(dlouhá platnost magic tokenu, neaktivní ochrana proti brute-force útokům, žádné záznamy o
přihlášení) a **mezeru v souladu s GDPR**: výmaz pouze na místě vyprázdní část uživatele a je
zvrácen zpětnou synchronizací CRM z C8 (anti-erasure — ARCH0001 §8 Risk 3; FN0021). Anonymizace
osobních údajů je vedena jako samostatná schopnost vzhledem k odlišné právní problematice.

---

## Strukturální komponenty

- **Identity-&-Access** (doménová služba) — autentizace heslem a magic-linkem, relace, samoregistrace,
  provisioning User/Contact ze schválené žádosti, model rolí, přidělení role supporter při první
  platbě PAID. Schopnost: [FN0018](../FN/FN0018_IdentityAccessControl.md).
- **Anonymizace osobních údajů** (GDPR výmaz) — vedena odděleně od autentizace. Schopnost:
  [FN0021](../FN/FN0021_PersonalDataAnonymisation.md).
- **Sdílený agregát** — přispívá do AG7 Party (kořen User [EN0008](../EN/EN0008_User.md); Contact
  [EN0006](../EN/EN0006_Contact.md); Account [EN0007](../EN/EN0007_Account.md) *dormantní*), jehož
  životní cyklus jinak náleží C7 ([ARCH0009](ARCH0009_PartyAndCrm.md)).

---

## Model interakcí

Podle [ARCH0002](../ARCH0002_ContextInteractionMap.md) §(a)/(c):

- Provisionuje User+Contact **synchronně**, když **C1** odešle žádost a když **C4** rozřeší
  anonymního dárce (ARCH0002 §(a)).
- Role **supporter** je do strany (party) přidělena kaskádou první platby PAID z **C4**
  (ARCH0002 §(c)).
- Autentizace a aktivace účtu odesílají zprávy magic-link / aktivace přes **C8**
  ([UC0014](../UC/UC0014_AuthenticateManageAccess.md);
  [MSG0003](../MSG/MSG0003_AccountActivation.md), [MSG0004](../MSG/MSG0004_MagicLinkLogin.md)).
- GDPR anonymizace ([UC0015](../UC/UC0015_AnonymizePersonalData.md)) mění sdílený záznam strany
  (party) (C7) a deleguje odstranění z CRM na **C8**, jehož zpětný upsert v současnosti výmaz
  ruší (ARCH0002 §(c), anti-erasure).

---

## Křížové odkazy

- **relatedEN:** EN0008, EN0006, EN0007 (sdíleno s AG7 Party z C7)
- **relatedUC:** UC0014, UC0015 (účastní se UC0001, UC0005, UC0006, UC0016)
- **relatedFN:** FN0018, FN0021
- **relatedES:** (žádné přímo — odesílání auth e-mailů přes C8)
- **relatedMSG:** MSG0003, MSG0004 (aktivace a přihlášení magic-linkem; transport vlastní C8)
- **relatedBR:** BR-AccessControlAndRoles
  ([../BR/BR-AccessControlAndRoles.md](../BR/BR-AccessControlAndRoles.md)),
  BR-DataProtectionAndErasure ([../BR/BR-DataProtectionAndErasure.md](../BR/BR-DataProtectionAndErasure.md))
  — pravidla identity/deduplikace strany (party) vlastní C7's
  [BR-PartyIdentityAndDeduplication](../BR/BR-PartyIdentityAndDeduplication.md).
