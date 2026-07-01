# Task Prompt — DBIntrospector (AR)

Run AR:DBIntrospector

Load and follow:

tooling/orchestration/01-evidence-collection/agents/DBIntrospector.md

Write ONLY to `_ar/**`.

Do not modify any other files.

Enforce Evidence rule strictly.
Do not invent constraints, TTL values, or validation logic.
If uncertain, mark as `Hypothesis` and state what evidence is missing.

Prioritize:

- Prisma schema
- migrations
- ORM models
- docker compose and env
- validation libraries

Deliverables:

- `_ar/evidence/db-inventory.md`
- `_ar/evidence/db-models.md`
- `_ar/evidence/db-constraints-and-validation.md`
- `_ar/repo-map/data-model-signals.md`
- update DB section in coverage files