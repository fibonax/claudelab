# TASK-002: Core Delivery Skills — start, check, hint

**Priority:** P0
**Estimated Effort:** 2h
**Status:** DONE
**Dependencies:** TASK-001
**Blocked By:** TASK-001

---

### Objective

Create the three core learner-facing skills that form the exercise loop: `/cclab:start` (load and present exercises), `/cclab:check` (validate work), and `/cclab:hint` (progressive hints). These three skills are the minimum needed for a functional learning experience.

### Scope

#### Files to Create
- `.claude/skills/start/SKILL.md` — Exercise loader: reads progress.json, runs setup.sh, presents instructions
- `.claude/skills/check/SKILL.md` — Validation engine: runs validate.sh, reports pass/fail, updates progress
- `.claude/skills/hint/SKILL.md` — Progressive hint system: reads hints.md, tracks hint level per exercise

#### Files to Modify
- None (plugin.json references these skills but is created in TASK-001)

#### Files NOT Touched
- `.claude/skills/create-exercise/` — Dev-only skill, unchanged
- `.claude/skills/validate-exercise/` — Dev-only skill, unchanged
- `exercises/` — Exercise content is created in separate tasks

### Acceptance Criteria

- [x] AC-1: `/cclab:start` creates `~/.cclab/` and `~/.cclab/workspace/` on first run
- [x] AC-2: `/cclab:start` creates `progress.json` with correct initial state on first run
- [x] AC-3: `/cclab:start` detects existing progress and resumes at current exercise
- [x] AC-4: `/cclab:start` runs the current exercise's `setup.sh` to scaffold workspace
- [x] AC-5: `/cclab:start` displays the current exercise's `instructions.md` content
- [x] AC-6: `/cclab:check` executes the current exercise's `validate.sh` and reports PASS/FAIL
- [x] AC-7: `/cclab:check` updates `progress.json` on PASS (marks exercise complete, advances to next)
- [x] AC-8: `/cclab:check` shows failure feedback from validate.sh stdout on FAIL
- [x] AC-9: `/cclab:hint` shows hint level 1 on first call, level 2 on second, level 3 on third
- [x] AC-10: `/cclab:hint` tracks hint level per exercise in progress.json
- [x] AC-11: All three skills handle edge cases (no exercises left, invalid state, missing files)

### Technical Notes

- Skills are SKILL.md files containing instructions for Claude. They tell Claude what to do when the skill is invoked — read files, run scripts, update JSON, display output.
- progress.json schema:
  ```json
  {
    "current_exercise": "cc-001",
    "completed": [],
    "hints_seen": { "cc-001": 0 },
    "started_at": "ISO timestamp",
    "updated_at": "ISO timestamp"
  }
  ```
- The start skill needs to discover exercises by reading `exercises/fundamentals/cc-NNN/metadata.json` files and sorting by ID.
- hints.md uses `## Hint 1`, `## Hint 2`, `## Hint 3` as section markers.
- validate.sh exit code 0 = PASS, non-zero = FAIL. stdout contains feedback message.
- setup.sh must be run with the exercise workspace dir as context (e.g., `~/.cclab/workspace/cc-NNN/`).

### Requirement Traceability

| PRD Requirement | Curriculum Exercise |
|---|---|
| FR-002 (Exercise Loader) | — |
| FR-003 (Validation Engine) | — |
| FR-004 (Progressive Hint System) | — |
| FR-005 (Progress Tracking) | — |
