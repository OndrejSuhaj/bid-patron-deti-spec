# Git workflow policy — AR pass Patronus (bid-patron-deti)

Status: active for this AR pass
Last updated: 2026-07-01

## Standing instruction (from user)

- Remote: `origin` → `https://github.com/OndrejSuhaj/bid-patron-deti-spec.git`
- **Whenever a new agent of this pipeline finishes its work, make a commit and immediately push**
  to the remote. One commit per completed `Run AR:<AgentName>` job; push right after the commit
  (do not defer to "a suitable moment").
- This is codified in `CLAUDE.md` → section "Git workflow — commit & push after every agent".

## Operational details

- **Commit scope:** only `_ar/**` artifacts produced by the AR pass. Files outside `_ar/**` that
  appear modified/untracked (e.g. `CLAUDE.md`, `.claude/`) were **not** produced by analysis agents —
  confirm with the user before including them in a commit; never fold them into the per-agent auto-commit.
- **Commit message:** `AR:<AgentName> — <short summary> (bid-patron-deti)`, ending with:
  `Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>`
- **Push:** `git push` the current branch to `origin`; on first push set upstream with
  `git push -u origin <branch>`.

## Notes

- Current local branch: `master` (repo default configured as `main`). The rule does not switch branches.
- History so far: `85f728b` (scaffold) → `df67248` (RepoCartographer artifacts + this policy, committed
  in a separate thread). Local `master` had no upstream tracking as of this update — first push will set it.

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>
