---
doc_id: EN0024
title: Blog
canonical_layer: EN
spec_type: entity
status: draft
references:
  - EN0004  # Campaign — Blog CTA may link to a Campaign
  - EN0008  # User — Blog author
---

# EN0024 — Blog

## Purpose

Blog is an editorial content entity used for marketing/content publishing. It represents a blog
post with title, lead text, body, imagery, and a configurable call-to-action (CTA) that may direct
the reader to a Campaign. Exactly one Blog post at a time may be marked as the featured ("hero")
post. Blog is distinct from the platform's core content bundle that shares the "blog" name; that
bundle is out of editorial use and is not part of this entity's domain.

---

## Lifecycle

- Published
- Unpublished

A Blog post also carries an independent "hero" flag: at most one Blog post is the current hero post
at any time. This is a single-item selection, not a lifecycle state of the individual post — see
Invariants.

Hypothesis — Not evidenced in current sources: no flow dossier traces Blog's editorial lifecycle
beyond create/publish and hero selection. Whether Blog supports draft-before-publish, scheduled
publish, or archival states beyond the published/unpublished flag is unconfirmed.

---

## State Transitions

Unpublished → Published
trigger: Hypothesis — Not evidenced in current sources. No use case in the current reconstruction
models Blog authoring/publishing as a step-by-step flow; a scheduled-publish mechanism is referenced
in flow evidence (FL057) but not confirmed as authoritative for this entity. Open Question below.

(not hero) → hero
trigger: Hypothesis — Not evidenced in current sources; selecting a Blog post as hero is inferred
from entity behavior only (see Invariants), not from a modelled use case.

---

## Attributes

### System-managed attributes

- slug (string; system-generated; derived from the title at creation time; uniqueness not
  guaranteed — see Invariants)
- created (datetime; system-managed)
- changed (datetime; system-managed)
- status (boolean; published / unpublished)

### User-provided attributes

- name (string, max 75; required; post title; used as the entity's display label)
- perex (long text; optional; lead/teaser text)
- body (long text; optional; main content)
- image (image; optional; single; required media reference to a file)
- gallery (image; optional; multiple; media references to files)
- category (reference; optional; multiple; references a blog-category classification term)
- is_hero_post (boolean; optional; marks this post as the current featured post — see Invariants)
- cta_type (enumeration; optional; values: button / cards / application call-to-action)
- cta_title (string, max 200; optional)
- cta_button_text (string, max 200; optional)
- cta_button_link (string, max 200; optional)
- cta_campaign (reference to EN0004 – Campaign; optional; CTA target campaign)
- cta_filter (enumeration; optional; values: ending soon / lowest percentual support / filter by
  region / filter by category — drives a "cards" CTA's content selection)
- cta_filter_region (reference; optional; region term used when cta_filter selects by region)
- cta_filter_category (reference; optional; multiple; category terms used when cta_filter selects
  by category)
- user_id (reference to EN0008 – User; optional; the post's author)

---

## Invariants

- At most one Blog post is the current hero post at any time. Status: Implemented (procedural
  enforcement observed; no declared uniqueness constraint backs it — see Open Questions).
- A Blog post's slug is expected to be unique but no uniqueness constraint is declared at the data
  level. Status: Uncertain — see Open Questions.
- No BR document currently constrains Blog; these invariants are entity-local pending BR coverage.

---

## Relationships

- EN0008 – User (author of the Blog post)
- EN0004 – Campaign (optional CTA target)
- Blog's category, region-filter, and category-filter attributes reference taxonomy/classification
  terms that are not separately modelled as AR entities in the current reconstruction.

---

## Open Questions

1. Slug uniqueness is not backed by a declared constraint — is collision prevention guaranteed by
   current behavior, or a latent defect?
2. Single-hero enforcement is procedural rather than constraint-backed and, per available evidence,
   applies without any tenant/country scoping — is a single global hero post across CZ/RO/MD the
   intended current behavior, or should it be scoped per country (see `BR-MultiTenantCountryScoping`
   for the general multi-tenant policy, which does not explicitly cover Blog)?
3. The `cta_filter_category` attribute is reported to rely on a fixed, hardcoded set of category
   values rather than a dynamic reference — is this brittle coupling authoritative current behavior?
4. Relationship/overlap with the platform's core "blog" content bundle: are both in active editorial
   use, or is one legacy? Not resolved in current sources.
5. No use case in the current reconstruction models Blog creation, publishing, or hero-selection as
   a flow — is this because Blog is administered outside the core Application/Story/Lead workflows
   (plain content editing), or because evidence is simply missing?
