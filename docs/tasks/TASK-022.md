# TASK-022: Exercise wf-008 — Branch Out

**Priority:** P1
**Estimated Effort:** 2h
**Status:** TODO
**Dependencies:** TASK-014
**Blocked By:** TASK-014

---

### Objective

Create the worktrees exercise teaching git worktree creation and parallel isolated work. Learners create a worktree, make changes on a separate branch, commit, and verify isolation from the main branch.

### Scope

#### Files to Create
- `exercises/workflows/wf-008/metadata.json` — id "wf-008", track "workflows", order 8, prerequisites ["wf-001"]
- `exercises/workflows/wf-008/instructions.md` — Instructions explaining worktrees, isolation model, how Claude Code uses them
- `exercises/workflows/wf-008/setup.sh` — Scaffolds workspace as a git repo with initial commit (src/app.ts, src/auth.ts, src/dashboard.ts, CLAUDE.md), clean working tree on main branch
- `exercises/workflows/wf-008/validate.sh` — Checks: worktree exists (git worktree list), branch exists, file exists in worktree, commit exists in worktree, main branch current, clean working tree
- `exercises/workflows/wf-008/hints.md` — 3 progressive hints

#### Files NOT Touched
- Any files in `exercises/fundamentals/`

### Acceptance Criteria

- [ ] AC-1: `metadata.json` has prerequisites ["wf-001"]
- [ ] AC-2: `setup.sh` initializes a proper git repo with an initial commit and clean working tree
- [ ] AC-3: `setup.sh` handles the case where the workspace already exists (idempotent — re-initializes git if needed)
- [ ] AC-4: `validate.sh` checks all 6 validation criteria from curriculum (worktree list, branch, file, commit, main current, clean tree)
- [ ] AC-5: `validate.sh` runs all git commands within the workspace directory (uses `git -C`)
- [ ] AC-6: `instructions.md` explains both `claude --worktree` and manual `git worktree add` approaches
- [ ] AC-7: Exercise passes `/validate-exercise wf-008`

### Technical Notes

- setup.sh must initialize a git repo: `git init`, create files, `git add .`, `git commit -m "chore: initial project setup"`.
- For idempotency: if `.git` already exists, clean up worktrees first (`git worktree prune`), then reset to initial state.
- validate.sh git checks must be scoped to the workspace: `git -C "$WORKSPACE" worktree list`.
- The worktree path is `.worktrees/feature-auth/` within the workspace.
- Check git version >= 2.5 in setup.sh for worktree support.

### Requirement Traceability

| PRD Requirement | Curriculum Exercise |
|---|---|
| FR-008 (Worktrees) | wf-008 |
