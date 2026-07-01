# Glossary Arbitration Decisions

Record only human decisions needed to unblock promotion.

Last updated: 2026-03-25 (by GlossaryPromoter — blocked families registered)

## Status values
- approved
- blocked
- legacy
- keep-in-english
- defer
- human-arbitration-required
- split-concepts

---

## Decisions

### ARB-001 — vytěžování family (extraction root conflict)

- term group: vytěžování, neomezené vytěžování, balíček vytěžení, jedno vytěžení, dvouprůchodové vytěžování, monitorování aplikace na vytěžení, úspěšně vytěženo, vytěžení přes ISDOC, AI vytěžování
- decision: defer
- reason: OQ-007 — the correct English canonical label for "vytěžování" is unresolved ("extraction" vs "data mining"). All morphological compounds share this root and inherit the ambiguity. Preferred candidate is "extraction" pending translation file confirmation.
- applies to: CAND-MINE-001, CAND-MINE-002, CAND-MINE-003, CAND-MINE-005, CAND-MINE-007, CAND-MINE-013, CAND-MINE-015, CAND-MINE-017, CAND-MINE-018
- unblock when: `translations/` directory checked for English label, or domain owner confirms "extraction" as canonical English
- date: 2026-03-25

---

### ARB-002 — Claude AI model version names

- term group: Claude 3.5 Sonnet, Claude 3.7 Sonnet, Claude 4.0 Sonnet, Claude 4.5 Sonnet
- decision: defer
- reason: AI model version names are product-version identifiers, not stable domain terminology. They change with each model release and are unsuitable as canonical glossary entries. They belong in evidence files only.
- applies to: CAND-MINE-019, CAND-MINE-020, CAND-MINE-021, CAND-MINE-022
- unblock when: Never (not suitable for canonical glossary)
- date: 2026-03-25

---

### ARB-003 — košilka / koš / pohled (DMS permission boundary conflicts)

- term group: košilka, koš, pohled
- decision: human-arbitration-required
- reason: Three permission names have unclear concept boundaries:
  - "košilka" — unclear if it refers to a physical document cover sheet or a specific DMS metadata entity (OQ-001)
  - "koš" — used both as a permission name (access to recycle bin) and as a DMS structural concept (recycle bin module); may need split-concepts treatment (OQ-002)
  - "pohled" — overloaded: means "saved filter preset" in permission context and "UI view" in general navigation; may need two separate entries (OQ-003)
- applies to: CAND-PERM-004, CAND-PERM-005, CAND-PERM-015
- unblock when: Inspect `src/Entity/` or `templates/dms/` for košilka field definitions; inspect `src/Entity/Filter.php` or similar for "pohled" as saved view entity; confirm "koš" role: one or two concepts
- date: 2026-03-25

---

### ARB-004 — upozornění (alert vs notification system)

- term group: upozornění
- decision: human-arbitration-required
- reason: OQ-005 — "upozornění" is a generic Czech word used as a UI category label, a specific notification type name, and potentially as a synonym for the entire notification system. Its exact canonical scope in this application is unclear.
- applies to: CAND-NOTIF-010
- unblock when: Inspect `templates/notification/` or notification entity labels for how "upozornění" is used vs "notifikace"
- date: 2026-03-25

---

### ARB-005 — záloha family (advance vs deposit translation conflict)

- term group: záloha, přijatá záloha, vydaná záloha, zálohový řetězec, daňový doklad k záloze, zálohová faktura vydaná, zálohová faktura přijatá
- decision: human-arbitration-required
- reason: OQ-008/009, DRIFT-004/006 — The master has "přijatá záloha = received deposit" (term_0380) while the application uses "advance" framing throughout ("Zálohová faktura" = advance invoice). Additionally, three Czech terms in the master map to "advance payment": akontace (term_0003), poskytnutá záloha (term_0351), and the proposed standalone "záloha". Synonym proliferation is a risk.
- applies to: CAND-INV-004, CAND-INV-005, CAND-INV-006, CAND-CHAIN-003, CAND-CHAIN-008, CAND-DTYPE-003, CAND-DTYPE-004, CAND-DTYPE-006
- required decision: Choose one of:
  (a) Adopt "advance" as canonical English for záloha family; update term_0380 to "received advance"; add záloha as new entry; mark akontace/poskytnutá záloha as legacy
  (b) Keep "deposit" framing from master; add záloha as Czech synonym for existing entries
  (c) Keep both framings as domain-specific variants with scope notes
- unblock when: Human decision recorded; then run GlossaryPromoter for this family
- date: 2026-03-25

---

## Pending (not yet evaluated)

The following candidate groups are out of scope for the 2026-03-25 promotion run but will need arbitration in future runs:

| Group | Open question | Recommended decision type |
|---|---|---|
| DPH abbreviation | MT-005 — should "dph = vat" be added as abbreviation alias? | Likely: use-existing-master-term (add as synonym to term_0049) |
| vrubopis | MT-006 — absent from master; Tier B only; needs Tier A confirmation | defer until smarteca page ~58 checked |
| agenda (DMS) | OQ-004 — "agenda" means DMS folder automation, not general to-do list | split-concepts if both meanings are needed |
| vytěžování final resolution | OQ-007 — unblock ARB-001 | Check translations/ |
