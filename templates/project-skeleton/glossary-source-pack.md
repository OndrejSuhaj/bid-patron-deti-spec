# glossary source pack

approved terminology sources for the bene glossary workflow.

## source policy

only terms with explicit source backing may enter the glossary workflow.

promotion rule:
- a term may be collected as a candidate when it has explicit source backing
- a term may be promoted into `_ar/repo-map/glossary-master.csv` only when it is source-backed and not blocked by open semantic conflict
- if a term is source-backed but semantically disputed, keep it out of canonical promotion until human arbitration is recorded

## approved sources for the current pass

### tier a — approved direct term sources

1. `_ar/pdf/smartecaCZ.pdf`
   - role: czech terminology source
   - allowed use: direct extraction of czech terms
   - pairing rule: use only explicit pairing or conservative page-based pairing allowed by the active task

2. `_ar/pdf/smartecaEN.pdf`
   - role: english terminology source
   - allowed use: direct extraction of english terms
   - pairing rule: use only explicit pairing or conservative page-based pairing allowed by the active task

3. `_ar/evidence/terminology/cz-chart-of-accounts-basic_0.xlsx`
   - role: source-backed accounting term pairs
   - allowed use: direct extraction of paired czech / english terms where the sheet provides both labels

### tier b — project evidence sources

4. `_ar/spec-draft/**`
   - role: project usage evidence
   - allowed use: detect terminology drift and project usage
   - restriction: not authoritative on its own for promotion if the term has no external or source-pack support

5. `_ar/evidence/**`
   - role: runtime / review / evidence usage
   - allowed use: candidate collection and drift analysis
   - restriction: evidence of usage, not automatic authority for canonical promotion

6. `_ar/spec-draft/DOMAIN-ubiquitous-language.md`
   - role: domain synthesis reference
   - allowed use: compare project vocabulary against glossary
   - restriction: helpful for alignment, not sufficient alone if the term is unsupported by the active source pack

## forbidden promotion shortcuts

- do not promote a term only because it appears repeatedly in draft files
- do not promote a term only because it appears in runtime notes
- do not invent czech or english equivalents
- do not collapse distinct concepts just because the labels look similar

## current policy

- lowercase-only formatting is allowed and preferred for the current agent glossary files
- one preferred czech term and one preferred english term per canonical row
- established allowed synonyms belong in `allowed_synonyms_cz` or `allowed_synonyms_en`, never inside the preferred term field
