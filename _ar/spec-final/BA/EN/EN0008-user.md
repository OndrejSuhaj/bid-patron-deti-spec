---
doc_id: EN0008
title: User
canonical_layer: EN
spec_type: entity
status: canonical
modules: []
references:
  - EN0001
  - EN0006
  - EN0007
  - EN0018
  - BR-AccessControlAndRoles
  - BR-DataProtectionAndErasure
  - BR-PartyIdentityAndDeduplication
  - BR-CampaignRecommendationDormant
  - UC0001
  - UC0014
  - UC0015
  - UC0016
---

# EN0008 — Uživatel (Party)

## Účel

Uživatel je hlavní Party (strana) v doméně: každý aktér, který se může na platformě přihlásit nebo
na ní jednat — žadatel (fundraiser), patron, podporovatel, pracovník organizace a back-office
personál (účetní, správce obsahu, koordinátor, senior koordinátor, front-office, manažer,
marketing, risk manažer, administrátor) — je reprezentován jediným typem Uživatel, odlišeným rolí,
nikoli samostatným typem účtu pro každý druh aktéra (viz BR-AccessControlAndRoles). Uživatel je
kotva vlastnictví/autorství, na kterou odkazuje téměř každá další doménová entita; nese také odkaz
na Kontakt (EN0006), tedy podkladový záznam osobních údajů dané strany.

---

## Životní cyklus

- Neregistrovaný (pro danou osobu neexistuje Uživatel)
- Registrovaný — aktivní, bez hesla
- Registrovaný — blokovaný, bez hesla (založen jménem dané osoby, dosud neaktivovaný)
- Aktivní (autentizovaný / použitelný)
- Anonymizovaný (přihlašovací identita vymazána, účet jinak zachován)
- Odstraněný (účet již neexistuje)

---

## Přechody stavů

Neregistrovaný → Registrovaný (aktivní, bez hesla)
trigger: UC0014 (samoregistrace) / UC0001 (samoregistrace žadatele/patrona během podání žádosti)

Neregistrovaný → Registrovaný (blokovaný, bez hesla)
trigger: UC0001 / UC0014 (Uživatel založen na základě žádosti jménem dané osoby, v roli žadatele
nebo patrona)

Neregistrovaný → Registrovaný (role pracovníka organizace)
trigger: UC0016 (pracovník organizace založen nebo propojen v rámci procesu správy pracovníků)

Registrovaný (blokovaný nebo bez hesla) → Aktivní
trigger: UC0014 (aktivace / přihlášení pomocí magic-link odkazu založí přihlašovací údaje a
autentizovanou relaci)

Aktivní → Anonymizovaný
trigger: UC0015 (žádost o GDPR anonymizaci vymaže přihlašovací e-mail a zobrazované jméno; účet
zůstává zachován, není smazán ani blokován)

Aktivní → Odstraněný
trigger: UC0016 (sloučení duplicitních kontaktů odstraní Uživatele vlastnícího prohrávající
duplicitní Kontakt, EN0006)

---

## Atributy

### Systémem spravované atributy

- roles (seznam hodnot; povinné; Uživateli přiřazená doménová role/role — žadatel, patron,
  podporovatel, pracovník organizace nebo back-office role; Uživatel může současně zastávat více
  rolí — viz BR-AccessControlAndRoles)
- stav účtu (hodnota; povinné; aktivní nebo blokovaný)
- časová razítka posledního přihlášení / posledního přístupu (datetime; volitelné; zaznamenávají se
  při úspěšné autentizaci)
- contact (odkaz na EN0006 — Kontakt; propojený záznam Kontaktu dané strany)

### Uživatelem zadávané atributy

- login email (řetězec; povinné, dokud účet není anonymizován; slouží zároveň jako kontaktní adresa
  a přihlašovací identifikátor)
- display name (řetězec; povinné)
- first name / last name (řetězec; volitelné)
- name prefix / name suffix (řetězec; volitelné)
- name display preference (hodnota; volitelné; full / short / hidden)
- public profile flag (boolean; volitelné; zda je profil Uživatele veřejně viditelný)
- worker availability flag (boolean; volitelné; platí pro roli pracovníka organizace)
- profile image (volitelné)
- bank account identifier (řetězec; volitelné)

---

## Invarianty

- Uživatel je odlišen přiřazenou rolí, nikoli samostatným typem účtu — viz BR-AccessControlAndRoles.
- Uživatel může současně zastávat více rolí — viz BR-AccessControlAndRoles.
- Uživateli musí být idempotentně přidělena role podporovatele při prvním uhrazeném daru,
  který vlastní — viz BR-AccessControlAndRoles.
- Uživatel založený na základě žádosti (EN0001) jménem dané osoby musí být vytvořen bez
  použitelného hesla, dokud není dokončen samostatný aktivační krok — viz
  BR-PartyIdentityAndDeduplication.
- Autentizační token typu magic-link smí být akceptován pouze v rámci svého platnostního okna
  — viz BR-AccessControlAndRoles.
- GDPR anonymizace Uživatele nesmí být považována za vymazání všech souvisejících
  osobních údajů, které daná strana drží — viz BR-DataProtectionAndErasure.
- Uživatel, který v rámci slučování duplicit vlastní prohrávající duplicitní Kontakt (EN0006),
  musí být jako přímý vedlejší efekt sloučení odstraněn, mimo cestu anonymizace/výmazu — viz
  BR-DataProtectionAndErasure a BR-PartyIdentityAndDeduplication.
- Jakákoli vazba mezi Uživatelem a doporučeními kampaní nesmí být považována za aktivní
  invariant — viz BR-CampaignRecommendationDormant.

---

## Vztahy

- EN0006 — Kontakt (propojený záznam party/osobních údajů Uživatele)
- EN0001 — Žádost (Uživatel vystupuje v roli žadatele, patrona nebo jiné role vázané na případ)
- EN0007 — Account (Account odkazuje na svého vlastnícího Uživatele)
- EN0018 — Organizace (Uživatel může být pracovníkem organizace nebo manažerem)

---

## Otevřené otázky

- Vzhledem k tomu, že GDPR anonymizace vymaže přihlašovací identitu Uživatele na místě, ale
  navazující synchronizace s marketingovým CRM následně opětovně doplní jméno dané strany, jak je
  u anonymizovaného Uživatele dosaženo skutečného výmazu? (viz BR-DataProtectionAndErasure)
- Který atribut odlišuje Uživatele v roli žadatele od Uživatele v roli patrona nad rámec přiřazené role?
- Je atribut týkající se doporučení pozorovaný u Uživatele autoritativní vůči odpovídajícímu
  atributu u Account (EN0007)? Současný stav: vazba je neaktivní (dormant) — viz
  BR-CampaignRecommendationDormant.
