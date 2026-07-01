---
doc_id: IA-<project-slug>
title: Information Architecture — <Project Name>
canonical_layer: IA
spec_type: information-architecture
scope: program
modules: []
status: draft | canonical
owners: [ux-lead, architect]
language: cs | en
references:
  # referenced canonical doc_ids (verify each resolves first):
  # - ARCHxxxx, ENxxxx, BRxxxx, UCxxxx, ACLxxxx, ESxxxx
---

# IA — <Project Name>

## 1. Sources / Authority

This IA is reconstructed from observed UI evidence:
- `_ar/coverage/ui-screen-index.md`, `_ar/evidence/ui/ui-observed-areas.md`
- `_ar/prtsc/**`, CS scenarios, `_ar/evidence/flow/**`
- referenced canonical docs (see `references:`)

Suggestive-only (not authoritative): observed UI / prototype is evidence of intent; reconstructed
canonical content (`_ar/spec-draft/{ARCH,EN,BR,UC,ACL}/`) wins on contradiction.

---

## 2. Top-Level Navigation

- <Nav item 1> — <one-line description> (`ACLxxxx` when role-gated)
- <Nav item 2> — <one-line description>
- Account menu — <Profile, Settings, Sign out>

---

## 3. Screen Map

Per-module subsection. Each screen: stable screen-id + one-line purpose + `ENxxxx` when it shows
a foundational entity. Screen-ids are stable across reruns and consumed by WIRE `screen_id`.

### 3.1 <module-1>

- S001 <ScreenName> — <one-line purpose> (`ENxxxx` if shows entity)
- S002 <ScreenName> — <one-line purpose>

### 3.2 <module-2>

- S100 <ScreenName> — <one-line purpose>

---

## 4. Entry Points

Each entry references the `UCxxxx` it triggers. Entry without a UC is an Open Question.

| Entry | Trigger | First screen | UC ref | Auth required |
|---|---|---|---|---|
| `/` | anonymous visit | S001 | `UCxxxx` | no |
| `/<protected-path>` | post-auth / deep link | S010 | `UCxxxx` | yes |

---

## 5. Cross-Module Flows

Each step references its `UCxxxx`. No inline restatement of UC content.

### <Flow name>

1. S<###> in <module> — <step purpose> (`UCxxxx`)
2. S<###> in <module> — <step purpose> (`UCxxxx`)

---

## 6. Information Hierarchy

Reference `ENxxxx` at each level. Do NOT enumerate entity attributes or configuration values.

- **Account level:** <concept> (`ENxxxx`)
- **<Domain> level:** <concept> (`ENxxxx`)
- **<Item> level:** <concept> (`ENxxxx`)

---

## 7. Module Boundaries (UX layer)

| Module | Owns screens | Cross-module dependencies |
|---|---|---|
| <module-1> | S001–S0xx | uses <module-2> S1xx for <purpose> |
| <module-2> | S100–S1xx | none |

---

## 8. Open IA Questions

Mandatory. Capture every unresolved behavior (role/action claim without evidence, two-path
behavior, uncertain screen/route, dynamic config count, module-boundary mismatch).

| # | Question | Context / Impact | Decided by |
|---|---|---|---|
| IA-Q1 | <question> | <context + impact> | <named decider> |

Empty Open Questions in MVP phase = suspicion of silently-decided assumptions.

---

## 9. What this IA does NOT cover

This IA does not decide (reference the doc_id, never restate):
- API contracts → `_ar/spec-draft/API/`
- external-system integrations → `_ar/spec-draft/ES/`
- technology stack → `_ar/spec-draft/ARCH/`
- entity attributes / lifecycle → `_ar/spec-draft/EN/`
- business rules / configuration → `_ar/spec-draft/BR/`
- access-control rules → `_ar/spec-draft/ACL/`
- per-screen layout, components, copy → `WIRE` / `COMP` / `COPY`
