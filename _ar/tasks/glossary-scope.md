# glossary scope

active glossary scope for the current AR pass over Patronus (bid-patron-deti current-state reconstruction).

## in scope
- donation / patronage domain terminology (patron, dárce, obdarovaný / dítě, kampaň, sbírka, sbírkový účet)
- core entity vocabulary: lead, application (žádost), story (příběh) and their sub-types
- entity status vocabulary (lead / application / story states across CZ / RO / MD) — sourced from `intake/statuses/`
- current-state process-area terminology (žádost front/back, risk, donations, finance, content, affil)
- notification terminology (status → role → channel) from the notification matrix
- czech publication vocabulary for the reconstructed current-state spec

## out of scope for now
- target-state naming from `intake/it-zadani/` (target, not current-state)
- drupal framework / technical vocabulary (module machine names, contrib, render pipeline) unless it carries domain meaning
- rewrite-only and future-state naming proposals
- romanian / moldovan localized labels beyond status aliases (kept as allowed synonyms, not separate canonical rows)

## preferred output policy
- lowercase-only terms; lean canonical rows; source-backed promotion only
- czech is the source language; AR canonical is english-primary with czech equivalents maintained for publication
- multi-country labels (CZ / RO / MD) belong in allowed_synonyms, never in the preferred term field
