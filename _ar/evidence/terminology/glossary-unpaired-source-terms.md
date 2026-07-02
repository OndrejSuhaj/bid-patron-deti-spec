# Glossary — Unpaired Source Terms (Patronus, current-state)

> Produced by **AR:GlossaryCandidateCollector** · 2026-07-02.
> Terms that are source-backed on **one language side only** in the safe source set, or whose CZ/EN
> pairing cannot be made conservatively. They are held here (not in the paired candidate rows) so no
> translation is invented. Each carries its source key (see `glossary-source-index.md`) + locator.
> None is promoted.

---

## A. English-only (no confirmed CZ label in the safe set)

Mostly back-office role machine-names and technical role tokens. CZ UI labels must be obtained from
config/UI before a CZ preferred term can be recorded.

| en term | source | locator | why unpaired |
|---|---|---|---|
| supporter (role) | DUL; EN08 | DUL §1 Supporter; EN08 `roles` | auto-granted role; no confirmed CZ UI label. |
| coordinator | EN08; TSCEN | EN08 `roles` (coordinator); TSCEN "Front Coordinator" | code role stem; CZ "koordinátor" only assumed, not evidenced. |
| senior coordinator | EN08 | EN08 `roles` (senior_coordinator) | code role; no CZ label. |
| accountant | EN08 | EN08 `roles` (accountant) | code role; no CZ label. |
| content admin / content coordinator | EN08; TSCEN | EN08 `roles` (content_admin); TSCEN BLOCK 9 | code name vs scenario name mismatch; CZ label unconfirmed. |
| manager | EN08 | EN08 `roles` (manager) | code role; also the contract "manager" signatory. |
| marketing | EN08 | EN08 `roles` (marketing) | code role; no CZ label. |
| risk manager | EN08; TSCEN | EN08 `roles` (risk_manager); TSCEN BLOCK 5 | code role; CZ label unconfirmed. |
| administrator | EN08 | EN08 `roles` (administrator) | code role; no CZ label. |
| front (role) | EN08 | EN08 `roles` (front) | code role stem ("front" coordinator?); ambiguous. |
| operations manager | TSCEN | SC-10C | scenario role; no code-role/CZ confirmation. |
| info coordinator | TSCEN | SC-10G | scenario role; no code-role/CZ confirmation. |

## B. Contact `field_name` role tokens (code identifiers; role synonyms, not standalone CZ terms)

| token | source | locator | note |
|---|---|---|---|
| fundraiser_address2 | EN06 | EN06 Core Fields `field_name` | second-address role of the fundraiser Contact; not a party in its own right. |
| fundraiser_employer | EN06 | EN06 Core Fields `field_name` | employer role of the fundraiser Contact. |
| school | EN06 | EN06 Core Fields `field_name` | school/institution role (Contact); CZ "škola" implied but not explicitly glossed in the safe set. |
| undefined | EN06 | EN06 Core Fields `field_name` | default/unclassified discriminator value; not a domain concept. |

## C. CZ-only or CZ-primary with no clean EN preferred (recorded, EN side deferred)

| cz term | source | locator | note |
|---|---|---|---|
| zákonný zástupce (ZZ) | STAT; TSCEN | STAT `waiting_for_fundraiser` ("žádost ZZ"); TSCEN Matrix `waiting_for_fundraiser` | the legal-guardian sense of the fundraiser; EN side folds into "applicant/fundraiser" but the ZZ nuance has no distinct EN term. |
| obědy školákům | DUL | DUL §1 CostsSnapshot | a specific report target line; a metric label, not a general concept — EN gloss deferred. |
| Přišly peníze | DUL | DUL §1 BankTransactionMail | the matched aviz e-mail subject; an operational string, not a concept. |

## D. MD / RU locale gap

The MD status block in STAT is sparse and appears to describe a different lead/story categorization
rather than a per-status MD translation; RU (likely the MD publication locale per SCMAP languages
`cs/en/ro/ru`) status labels are **absent** from the safe source set. No MD or RU status synonyms are
recorded until a clean list is available (see candidates §9 U6).

---

**Resolution path.** Items in A/B need CZ UI/config labels; C needs an EN canonical decision; D needs a
clean MD/RU source. Route decisions through `_ar/tasks/glossary-arbitration-decisions.md`. No pairing was
forced.
