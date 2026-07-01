---
doc_id: COMPxxxx
title: <Component Name>
canonical_layer: COMP
spec_type: component
modules: []
status: draft | canonical
design_source: <Figma / Storybook URL>   # optional
references: []
---

# COMPxxxx – <Component Name>

## Purpose

<One paragraph: what the component represents, intended usage, problem solved. State whether it is module-scoped or shared cross-module. Note the observed reuse that justifies it as a reusable component.>

---

## Props / Inputs

| Name | Type | Required | Default | Description |
|---|---|---|---|---|
| `<propName>` | `<Type>` | yes / no | `<default>` | <description; `ENxxxx` for entity-typed props> |

---

## Variants

- **size:** small | medium | large
- **<axis>:** <value-1> | <value-2>

Each value: `<axis>=<value>` — <when to use>

---

## States

### idle
<Normal state.>

### hover
<Visual change on hover. Or: `Uncertain — not observable from static evidence`.>

### focused
<Visual change on keyboard focus. Or: `Uncertain`.>

### disabled
<Visual + behavior change when disabled.>

### loading
<Indicator during async operation. Or: `N/A`.>

### error
<Error visual + recovery path. Or: `N/A`.>

---

## Events

| Event | Payload | Trigger | Notes |
|---|---|---|---|
| `<onClick>` | `<payload type>` | <user action> | <notes> |

(or: "No events emitted")

---

## Accessibility

Usually not directly observable from screenshots — mark `Uncertain` / Open Question unless
recordings or DOM evidence supports it.

- **ARIA role:** `<role>` (or "inherits native semantics from `<element>`")
- **Keyboard navigation:** <keys>
- **Focus management:** <enter/exit/activation>
- **Screen reader:** <what is announced>

---

## Usage Constraints

- Use when: <scenario>
- Do not use when: <scenario>
- Cardinality: <one per screen / multiple OK>
- Placement: <inside form / standalone / overlay>

---

## Dependencies

- Other COMPs: `COMPxxxx` (composition)
- Data entities: `ENxxxx` (typed props)
- ACL: `ACLxxxx` (role-based visibility)
- External libraries: <library + reason>

---

## Composition

<If composed of other COMPs, describe the pattern.>

```
<Component>
  ├─ COMPxxxx (purpose)
  └─ COMPxxxx (purpose)
```

---

## Examples

<Optional. 1–3 reconstructed usage examples (props + variant) observed in the UI.>

```
<Component prop="value" variant="small" />
```

---

## Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Reuse / props / variants | Confirmed / Probable / Assumed / Uncertain | `_ar/prtsc/<file>.png` (≥2 screens), `ui-observed-areas.md` |
