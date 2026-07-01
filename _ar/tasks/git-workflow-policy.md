# Git workflow policy — AR pass Patronus (bid-patron-deti)

Status: active for this AR pass
Last updated: 2026-07-01

## Standing instruction (from user)

- Remote: `https://github.com/OndrejSuhaj/bid-patron-deti-spec.git`
- **Whenever a new agent is run, make a commit and push** to the remote.
- Connect the remote and push at a suitable moment (not necessarily mid-task).

## Notes

- Current local branch at time of writing: `master` (repo default configured as `main`).
- Only `_ar/**` is writable per the project constitution; commits should reflect
  AR-generated artifacts. Files outside `_ar/**` that appear modified/untracked
  (e.g. `CLAUDE.md`, `.claude/`) were not produced by analysis agents — confirm
  with the user before including them in a commit.

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>
