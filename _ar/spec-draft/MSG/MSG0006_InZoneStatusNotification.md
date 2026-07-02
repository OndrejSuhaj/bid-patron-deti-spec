---
doc_id: MSG0006
title: In-Zone Status Notification
canonical_layer: MSG
spec_type: transactional-message
status: draft
trigger:
  - UC0002
references:
  - EN0001
  - EN0026
  - EN0003
---

# MSG0006 – In-Zone Status Notification

## Purpose

Show the current, correct status of an Application (EN0001) — and, where an action is required, what
that action is — inside the Parent Zone and the Patron Zone at every relevant step of the case
lifecycle. This is the in-app counterpart of the status-driven notification fan-out: instead of
reaching the party by email, it surfaces the status directly in the party's own zone the next time
they view it, so each party always knows where their application/story stands without needing an
inbox check.

---

## Trigger

UC0002 (Orchestrate Application Status Change) — specifically the downstream reaction fan-out
(UC0002.2): on every save that sets an Application (EN0001) to a new status, the System looks up the
ApplicationReaction (EN0026) configured for that status and role, and — where that reaction has the
in-app/zone notification channel enabled ("user account notification" = YES) — the corresponding
in-zone status message is made visible to the affected party. The fan-out runs regardless of whether
the status actually changed (UC0002 Main Flow step 7 / AF1); the notification itself only takes visible
effect if the ApplicationReaction (EN0026) for the resolved status and role enables it.

Confirmed directly by the acceptance scenarios SC-11C (status notifications visible in the Parent
Zone) and SC-11D (status notifications visible in the Patron Zone) in the current test-scenario
evidence, and by the Notification Matrix column "User account notification," which marks this channel
YES/NO per status × role independently of the Email column.

---

## Recipients

- **Parent / Žadatel** (legal guardian applying on behalf of the child) — sees the message in the
  Parent Zone.
- **Patron** (prospective or confirmed sponsor) — sees the message in the Patron Zone.

Each recipient's zone shows only the message resolved for that role's ApplicationReaction (EN0026) at
the Application's (EN0001) current status; the two roles frequently see different wording for the same
underlying status (e.g. one side prompted to act while the other is told to wait). Whether the in-zone
channel fires at all for a given status × role, independent of whether an accompanying email also
fires, is per the Notification Matrix "User account notification" flag for that status/role — some
statuses notify in-zone only, some send both an email and an in-zone message, some send neither to a
given role.

Channel: internal, in-application (zone view) — not an email and not routed through the external
email-delivery integration (ES0006). No CZ/RO/MD channel variants are evidenced beyond the underlying
status-vocabulary/localization differences already recorded at the status-model layer; the in-zone
delivery mechanism itself is uniform across markets in the current sources.

---

## Message Content

The in-zone status notification conceptually carries:

- **Current status label** — a short, human-readable phrase naming where the Application (EN0001)
  now stands, phrased for the viewing role (e.g. "Čekáme na Patrona," "Doplňte žádost," "Posuzujeme,"
  "Připravujeme smlouvu," "Příběh je zveřejněn," "Splněno"). Exact wording is status- and role-specific
  per the ApplicationReaction (EN0026) configuration and the Notification Matrix "Status message"
  column; this document does not restate the full status vocabulary (owned by the status model /
  EN0001 Allowed Statuses).
- **Action-required cue, where applicable** — an indication of whether the viewing party needs to do
  something next (e.g. complete a form, upload a document, confirm receipt) versus simply waiting;
  present only for statuses whose reaction is configured to prompt an action.
- **Implicit case reference** — the message is shown in the context of the party's own
  Application/Story view, so it is inherently scoped to that Application (EN0001) without needing to
  restate identifying details in the message itself.

Excluded from this contract (delivery/implementation, not message content): the exact copy strings
per status, HTML/visual presentation of the zone, and how the zone view is refreshed or fetched.

---

## Notes / Uncertainty

- This is a **grouped** message definition: it covers the in-zone ("user account notification")
  channel for essentially all statuses carrying a "Status message" in the Notification Matrix
  (~all 117 matrix rows have a non-empty Status message; a large subset also has "User account
  notification" = YES). It is intentionally kept as a single MSG document rather than exploded per
  status, per the grouping instruction for this synthesis pass — the per-status/per-role wording and
  YES/NO channel resolution is authoritative in the Notification Matrix (`intake/test-scenarios/test-scenarios.md`)
  and in the ApplicationReaction (EN0026) configuration it is derived from, not restated here.
  MSG0006 shares its trigger and fan-out mechanism with MSG0005 (the email counterpart) — same
  ApplicationReaction (EN0026) match per UC0002.2, but the in-app channel rather than the email
  channel; some statuses fire only one of the two, some fire both.
  Reference: `intake/test-scenarios/test-scenarios.md`, sheets SC-11C, SC-11D, and Notification Matrix
  (columns "Status", "Recipient role", "User account notification", "Status message").
- A few Notification Matrix rows carry two candidate status-message strings separated by `;` (e.g.
  `out_of_scope` → "Zrušená žádost; Nemůžeme vám pomoci") or are flagged `CHECK_PARSE` in the source
  sheet — the exact single resolved string per row is **Uncertain** and left to the status-model /
  ApplicationReaction (EN0026) evidence rather than asserted here.
- The `mistake` (Parent) row in the Notification Matrix has "User account notification" = **NO**, so
  the in-zone channel does **not** fire for the Parent at that status — the Parent is shown no in-zone
  message (this is settled, not open). The row's empty Status-message cell (carrying `CHECK_PARSE`, a
  generic per-row parse flag, not a channel signal) is the only **Uncertain** point: whether that cell
  is a genuine absence or a parse gap is left to the status-model / ApplicationReaction (EN0026)
  evidence rather than asserted here.
