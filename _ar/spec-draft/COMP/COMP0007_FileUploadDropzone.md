---
doc_id: COMP0007
title: File Upload Dropzone
canonical_layer: COMP
spec_type: component
modules: []
status: draft
references:
  - WIRE0008
  - WIRE0011
  - WIRE0014
  - EN0001
---

# COMP0007 – File Upload Dropzone

## Purpose

A drag-and-drop file upload area with a "vyberte v počítači" (choose on your computer) fallback
link and a live `n/max` file-count counter. Used wherever the Application wizard or the Account
module needs the user to attach supporting documents/images. The identical copy pattern ("Sem
přetáhněte soubory, které chcete do žádosti nahrát nebo je vyberte v počítači.") and dropzone/counter
shape recur across at least 3 written WIRE screens.

## Props / Inputs

| Name | Type | Required | Default | Description |
|---|---|---|---|---|
| `label` | `string` | yes | — | Heading/instruction above the dropzone; COPY-owned per screen (e.g. "Zde přiložte přihlášku na školní akci nebo informační leták"). |
| `maxCount` | `number` | yes | — | Maximum file count; observed values: `3` (`WIRE0008` gift-step attachment), `5`/`2`/`2` (`WIRE0011`'s three dropzones), `1` (`WIRE0014` profile photo). |
| `currentCount` | `number` | no | `0` | Current attached-file count driving the `n/max` display; all captures show `0/max` (empty state only — no filled dropzone was ever observed). |
| `exampleThumbnails` | `node[]` | no | `none` | Static "PŘÍKLAD" example images shown inside the dropzone, observed only on `WIRE0011`'s three attachment dropzones; not present on `WIRE0008`/`WIRE0014`. |

## Variants

- **cardinality:** single dropzone (`WIRE0008` — one dropzone, 0/3) | multiple dropzones
  (`WIRE0011` — three separate dropzone instances stacked, cardinalities 0/5, 0/2, 0/2)
- **example-thumbnails:** with (`WIRE0011`) | without (`WIRE0008`, `WIRE0014`)

## States

### idle / empty
Dashed-border rectangle, centered icon (upward arrow into a tray glyph), instructional text +
underlined "vyberte v počítači" link, `0/max` counter in the bottom-right corner. Confirmed —
`_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_20_39.png` (0/3, no example
thumbnails) and per `ui-observed-areas.md` §4/§11.

### hover (drag-over)
`Uncertain — not observable from static evidence; a drag-active highlight state is a standard
dropzone convention but not confirmed by any capture.`

### focused
`Uncertain — not observable from static evidence.`

### disabled
N/A — no disabled rendering observed; the component is presumed always-interactive when rendered.

### loading
`Uncertain — no capture shows a file mid-upload (e.g. progress bar per file); Evidence Pending.`

### error
`Uncertain — no capture shows a rejected-file state (wrong type, too large, count exceeded); Evidence
Pending. This is distinct from the count cardinality itself, which is Confirmed as a static max, not
an observed enforcement/error path.`

### filled (additional state beyond the six-state template, relevant to this component's lifecycle)
`Uncertain — no capture shows the dropzone with any file already attached; all observed instances
are at count 0. Whether attached files render as a thumbnail list, a filename list, or something
else is unconfirmed.`

## Events

| Event | Payload | Trigger | Notes |
|---|---|---|---|
| `onFilesAdded` | `File[]` | drag-and-drop onto the zone, or file(s) chosen via the "vyberte v počítači" picker | Enforcement of `maxCount` (block vs. truncate vs. replace) is not evidenced. |
| `onFileRemoved` | `File` reference | (Assumed — not observed) | No removal affordance is visible in any capture at count 0; unconfirmed whether one exists once files are attached. |

## Accessibility

- **ARIA role:** `Uncertain` — Assumed a native file `<input type="file">` wrapped in a styled drop target; not confirmed.
- **Keyboard navigation:** `Uncertain` — Assumed the "vyberte v počítači" link/button is keyboard-reachable and opens the native file picker; not confirmed.
- **Focus management:** `Uncertain`.
- **Screen reader:** `Uncertain` — announcement of the current `n/max` count is not confirmable from screenshots.

## Usage Constraints

- Use when: an Application wizard step or account form requires document/image attachment.
- Do not use when: a single plain text/file reference suffices without drag-and-drop affordance
  (no such simpler variant was observed, so this is a forward-looking constraint, not evidenced).
- Cardinality: one to three per screen (observed range: `WIRE0008`=1, `WIRE0011`=3, `WIRE0014`=1).
- Placement: inside a form, typically following the field(s) it supports contextually (e.g. after
  the gift-description textarea on `WIRE0008`).

## Dependencies

- Other COMPs: none as sub-components.
- Data entities: attachment count and purpose relate conceptually to `EN0001` Application (its
  supporting-document attachments), but no attribute-level binding is confirmed on any citing WIRE —
  each WIRE flags the exact field-name mapping as Uncertain (e.g. `WIRE0011`'s birth-certificate
  attachment field-name mapping).
- ACL: none evidenced.
- External libraries: none evidenced (no vendor upload-widget branding observed).

## Composition

Leaf component; no sub-COMP composition. Repeated verbatim (with different `maxCount`/example
thumbnails) up to three times on a single screen (`WIRE0011`).

## Examples

```
FileUploadDropzone label="Zde přiložte přihlášku na školní akci nebo informační leták"
                   maxCount={3} currentCount={0} />
  // WIRE0008 — gift step, single dropzone, no example thumbnails

FileUploadDropzone label="Fotografie dítěte" maxCount={5} currentCount={0} exampleThumbnails={[...]} />
FileUploadDropzone label="Fotografie OP žadatele" maxCount={2} currentCount={0} exampleThumbnails={[...]} />
FileUploadDropzone label="Rodný list dítěte" maxCount={2} currentCount={0} exampleThumbnails={[...]} />
  // WIRE0011 — three stacked mandatory dropzones

FileUploadDropzone label="Změnit profilovou fotku" maxCount={1} currentCount={0} />
  // WIRE0014 — account profile photo
```

## Open Questions

- No filled/error/loading state was ever captured — every observed instance is at count 0.
- Exact field-name mapping to `EN0001` attachment attributes is Uncertain per-screen (each
  consuming WIRE records this independently; not resolved here).
- Whether file-type/size constraints exist and how they are communicated is entirely unevidenced.

## Evidence

| Claim area | Certainty | Evidence |
|---|---|---|
| Reuse across ≥2 screens | Confirmed | `WIRE0008`, `WIRE0011`, `WIRE0014` all show this dropzone shape; `WIRE-synthesis-report.md` §6 "File/image upload dropzone with count cardinality" |
| Empty/idle visual state | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_20_39.png`; `ui-observed-areas.md` §4, §11 |
| Example-thumbnails variant | Confirmed (WIRE0011 only) | `_ar/spec-draft/WIRE/WIRE0011_ApplicationWizardStep5Attachments.md` Components Used table |
| Filled/loading/error states | Uncertain | no capture shows any of these |
| Accessibility | Uncertain | no DOM/recording evidence available |

## Design-system alignment (target)

No canonical counterpart yet in `@patron/ui` / `@patron/tokens`. The application-attachments/file-upload
surface has not been designed in the target design system as of this pass — `_ar/evidence/design-system/components.md`
and `_ar/spec-draft/DESIGN-component-index.md` contain no dropzone, file-upload, or attachment-list
primitive. This COMP therefore has no target mapping to record; the current-state reconstruction above
stands as-is until a canonical design-system component is introduced. Flag for the design-system team as
a gap: the rebuild will need a file-upload/dropzone primitive with count-cardinality and example-thumbnail
support to cover the observed `WIRE0008`/`WIRE0011`/`WIRE0014` usages.
