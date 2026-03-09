# TASK-003: Supporting Delivery Skills — status, reset

**Priority:** P1
**Estimated Effort:** 1h
**Status:** TODO
**Dependencies:** TASK-002
**Blocked By:** TASK-002

---

### Objective

Create the two supporting learner-facing skills: `/cclab:status` (progress dashboard) and `/cclab:reset` (exercise reset). These complete the learner skill set but are not required for the core learning loop.

### Scope

#### Files to Create
- `.claude/skills/status/SKILL.md` — Progress dashboard: shows track overview, completion percentage, current position
- `.claude/skills/reset/SKILL.md` — Exercise reset: re-runs setup.sh, clears hint progress, restores initial state

#### Files to Modify
- None

#### Files NOT Touched
- `.claude/skills/start/` — Created in TASK-002
- `.claude/skills/check/` — Created in TASK-002
- `.claude/skills/hint/` — Created in TASK-002

### Acceptance Criteria

- [ ] AC-1: `/cclab:status` shows track name ("Fundamentals") and description
- [ ] AC-2: `/cclab:status` lists all exercises with completion status (checkmark / current arrow / pending)
- [ ] AC-3: `/cclab:status` shows completion percentage (e.g., "3/8 exercises complete — 37%")
- [ ] AC-4: `/cclab:status` handles first-run case (no progress.json yet)
- [ ] AC-5: `/cclab:reset` re-runs the current exercise's setup.sh to restore scaffold
- [ ] AC-6: `/cclab:reset` clears the hint counter for that exercise in progress.json
- [ ] AC-7: `/cclab:reset` does NOT affect other exercises' completion status
- [ ] AC-8: `/cclab:reset` confirms the reset action before executing

### Technical Notes

- Status skill reads all exercise metadata.json files + progress.json and renders a visual dashboard.
- Dashboard format example:
  ```
  ## Fundamentals Track — 3/8 complete (37%)

  ✓ cc-001  Hello Claude Code
  ✓ cc-002  Your First CLAUDE.md
  ✓ cc-003  Convention Enforcer
  → cc-004  Code Detective          ← current
    cc-005  The Great Refactor
    cc-006  Git Like a Pro
    cc-007  Command Center
    cc-008  Prompt Architect
  ```
- Reset skill should ask for confirmation before proceeding (destructive action).
- Reset re-runs setup.sh (which is idempotent) and sets `hints_seen[exercise_id]` to 0.

### Requirement Traceability

| PRD Requirement | Curriculum Exercise |
|---|---|
| FR-006 (Exercise Reset) | — |
| FR-007 (Progress Dashboard) | — |
