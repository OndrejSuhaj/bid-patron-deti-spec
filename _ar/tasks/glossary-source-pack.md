# glossary source pack

approved terminology sources for the AR glossary workflow over Patronus (current-state).

## source policy

only terms with explicit source backing may enter the glossary workflow.

promotion rule:
- a term may be collected as a candidate when it has explicit source backing
- a term may be promoted into `_ar/repo-map/glossary-master.csv` only when it is source-backed and not blocked by an open semantic conflict
- if a term is source-backed but semantically disputed, keep it out of canonical promotion until human arbitration is recorded in `glossary-arbitration-decisions.md`

## approved sources for the current pass

### tier a — approved direct current-state term sources

1. `intake/statuses/`
   - role: canonical status vocabulary (~60 states for lead / application / story, CZ/RO/MD, with aliases, translations, entity type)
   - allowed use: direct extraction of status terms; **highest authority for entity status terminology**

2. `intake/current-solution/_source/patronus/config/**` and `.../web/modules/custom/**`
   - role: current-state domain terms from the running Drupal config and the 52 custom modules
   - allowed use: direct extraction of terms the CURRENT system uses (fields, bundles, entity/module names carrying domain meaning)
   - restriction: exclude framework machine-names with no domain meaning

3. `intake/process-maps/**`
   - role: current-state process terminology (7 areas × CZ/RO/MD)
   - allowed use: direct extraction of process / step / role terms as observed in current flow

### tier b — project evidence sources

4. `intake/test-scenarios/**`
   - role: acceptance vocabulary + notification matrix (status → role → text → channel)
   - allowed use: candidate collection; corroboration of status/notification terms

5. `intake/current-solution-analysis/**`
   - role: DERIVED scope / state / gap maps
   - restriction: helpful for alignment, not authoritative alone (it is derived, not primary)

6. `_ar/spec-draft/**`, `_ar/evidence/**`
   - role: project usage / drift evidence
   - restriction: usage evidence, not automatic authority for promotion

### target-state sources — collect but FLAG (not current-state truth)

7. `intake/it-zadani/**`
   - role: TARGET assignment (var. A rewrite / var. B upgrade, N1–N13). Highest authority for what to BUILD.
   - restriction: AR reconstructs the CURRENT system. Target-only terms may be collected as candidates but MUST be flagged as target-state; never promote a target-only term as current-state canonical.

8. `intake/meetings/**`
   - role: client intent / context ("between the lines")
   - restriction: non-binding; not acceptance, not a domain contract; candidate collection only

## forbidden promotion shortcuts

- do not promote a term only because it appears repeatedly in draft files
- do not promote a target-only term (`it-zadani`) as current-state canonical
- do not invent czech / english / romanian equivalents
- do not collapse distinct concepts just because the labels look similar

## current policy

- lowercase-only formatting preferred; one preferred czech term and one preferred english term per canonical row
- czech is the source language; established CZ/RO/MD synonyms belong in `allowed_synonyms_cz` (or a locale-tagged synonym field), never inside the preferred term field
