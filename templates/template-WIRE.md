---
doc_id: WIRExxxx
title: <Screen Name>
canonical_layer: WIRE
spec_type: wireframe
modules: []
screen_id: Sxxx
realizes_uc: [UCxxxx]
status: draft | canonical
references: []
---

# WIRExxxx – <Screen Name>

## Purpose

<One paragraph: what this screen accomplishes, which UC it realizes, who uses it (actor), entry context.>

---

## Layout Zones

<Bullet list of layout regions. ASCII sketch optional but recommended.>

- Header — <content>
- Main content — <content>
- Sidebar — <content>
- Footer — <content>

```
+--------------------------------+
| Header                         |
+--------+-----------------------+
| Side-  | Main content          |
| bar    |                       |
+--------+-----------------------+
| Footer                         |
+--------------------------------+
```

---

## Components Used

Every visual element traces to a `COMPxxxx` doc_id or is flagged `inline`.

| Zone | COMP-id | Variant/Props | Notes |
|---|---|---|---|
| Header | `COMPxxxx` | `<variant>` | <notes> |
| Main | inline | — | <not yet a reusable component> |

---

## Interactions

1. **Entry** — <route / deep link / redirect> → state: `default`
2. **Primary action** — <trigger> → <effect>; realizes `UCxxxx`; next: <state or screen>
3. **Secondary action — <name>** — <trigger> → <effect>
4. **Exit** — <how user leaves> → <success/cancel route>

---

## States

### default
<Normal usable state.>

### empty
<Shown when: <condition>. Visual treatment, recovery path. Or: `N/A — <reason>`.>

### loading
<Shown when: <async operation>. Indicators, blocked interactions. Or: `N/A — <reason>`.>

### error
<Shown when: <error condition>. Error display, retry path. Or: `N/A — <reason>`.>

---

## Validation Surfaces

| Field/Zone | Trigger (BR-id) | Surface |
|---|---|---|
| `<field>` | `BRxxxx` | inline / toast / modal |

---

## Data Bindings

| Zone | EN-id | QUERY-id | Notes |
|---|---|---|---|
| Main | `ENxxxx` | `QUERYxxxx` | <notes> |

---

## Conditional Visibility

| Component/Zone | Condition (ACL or BR ref) | Behavior when hidden |
|---|---|---|
| `<component>` | `ACLxxxx` / `BRxxxx` | hidden / disabled / replaced |

---

## Accessibility Notes

- **Tab order:** <description>
- **Focus on entry:** <element>
- **Focus on state transition:** <where focus moves>
- **Landmarks:** <ARIA landmark roles>
- **Keyboard shortcuts:** <screen-specific, if any>

---

## Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Layout / components | Confirmed / Probable / Assumed / Uncertain | `_ar/prtsc/<file>.png`, `ui-observed-areas.md`, `CSxxxx` |
