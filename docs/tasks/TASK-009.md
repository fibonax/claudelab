# TASK-009: Exercise cc-006 — Git Like a Pro

**Priority:** P1
**Estimated Effort:** 2h
**Status:** TODO
**Dependencies:** TASK-001
**Blocked By:** TASK-001

---

### Objective

Create the sixth exercise teaching users to use Claude's git integration for branching, staging, and conventional commits. This is the most setup-complex exercise because it requires initializing a real git repository.

### Scope

#### Files to Create
- `exercises/fundamentals/cc-006/metadata.json` — Exercise metadata with prerequisite `cc-004`
- `exercises/fundamentals/cc-006/instructions.md` — Step-by-step: create branch → add file → commit
- `exercises/fundamentals/cc-006/setup.sh` — Initializes a git repo with initial commit on `main`
- `exercises/fundamentals/cc-006/validate.sh` — Validates branch, file, commit message, clean tree
- `exercises/fundamentals/cc-006/hints.md` — 3 progressive hints

#### Files to Modify
- None

#### Files NOT Touched
- Other exercise directories

### Acceptance Criteria

- [ ] AC-1: `setup.sh` creates workspace, initializes git repo, creates initial files, makes first commit on `main`
- [ ] AC-2: `setup.sh` creates `src/app.ts` and a `CLAUDE.md` with a Git section specifying conventional commits
- [ ] AC-3: Initial commit message is `chore: initial project setup` (demonstrates the format)
- [ ] AC-4: After setup, repo has clean working tree on `main` branch
- [ ] AC-5: `validate.sh` checks: (a) `feature/add-logging` branch exists, (b) latest commit contains `feat`, (c) `src/logger.ts` exists and is non-empty, (d) working tree is clean, (e) current branch is `feature/add-logging`
- [ ] AC-6: `instructions.md` walks through git workflow step-by-step (branch → code → commit)
- [ ] AC-7: `validate.sh` provides specific feedback (e.g., "Branch not found" vs "Commit message doesn't follow conventional format")
- [ ] AC-8: `setup.sh` is idempotent — re-running resets the repo cleanly

### Technical Notes

- setup.sh git initialization:
  ```bash
  cd "$WORKSPACE"
  git init
  git checkout -b main  # ensure main branch
  # create files...
  git add -A
  git commit -m "chore: initial project setup"
  ```
- Idempotency for git: if the directory exists and has a .git, remove and recreate. `rm -rf` the workspace subdir and start fresh.
- Validation:
  ```bash
  cd "$WORKSPACE"
  git branch --list "feature/add-logging" | grep -q .
  git log --oneline -1 feature/add-logging | grep -qi "feat"
  test -f src/logger.ts
  [ "$(wc -l < src/logger.ts)" -ge 3 ]
  [ -z "$(git status --porcelain)" ]
  [ "$(git branch --show-current)" = "feature/add-logging" ]
  ```
- The CLAUDE.md should include a Git section with conventional commit format so Claude can reference it.
- This exercise tests Claude's ability to run git commands, not just edit files.

### Requirement Traceability

| PRD Requirement | Curriculum Exercise |
|---|---|
| FR-008 (Fundamentals Track Content) | cc-006 (Git Like a Pro) |
