# TASK-023: Integration Testing & QA

**Priority:** P2
**Estimated Effort:** 2h
**Status:** DONE
**Dependencies:** TASK-014, TASK-015, TASK-016, TASK-017, TASK-018, TASK-019, TASK-020, TASK-021, TASK-022
**Blocked By:** All previous MVP2 tasks

---

### Objective

Run end-to-end integration testing across the entire MVP2 delivery: verify multi-track infrastructure works, all 8 Workflows exercises pass validation, existing Fundamentals exercises are unbroken, and track transitions work correctly.

### Scope

#### Files to Create
- None (testing only)

#### Files to Modify
- Any exercise or skill files that fail QA (bug fixes)

#### Files NOT Touched
- PRD and curriculum docs

### Acceptance Criteria

- [x] AC-1: All 8 Fundamentals exercises (cc-001 through cc-008) pass `/validate-exercise` after infrastructure refactoring
- [x] AC-2: All 8 Workflows exercises (wf-001 through wf-008) pass `/validate-exercise`
- [x] AC-3: End-to-end test: fresh state (no progress.json) → `/cclab:start` → first exercise loads correctly
- [x] AC-4: Track transition: simulate completed Fundamentals → `/cclab:start` → Workflows track offered
- [x] AC-5: Direct start: no Fundamentals progress → start Workflows → recommendation shown, exercise loads
- [x] AC-6: `/cclab:status` shows both tracks with correct completion stats
- [x] AC-7: `/cclab:check` works for a Workflows exercise (validate.sh runs correctly)
- [x] AC-8: `/cclab:hint` shows progressive hints for a Workflows exercise
- [x] AC-9: `/cclab:reset` resets a Workflows exercise correctly
- [x] AC-10: Sample MCP server (wf-007) runs on both macOS and Linux with Python3

### Technical Notes

- Use the exercise-reviewer subagent to QA each exercise systematically.
- Test with a clean `~/.cclab/` directory to simulate first-run experience.
- Test with a progress.json showing all Fundamentals complete to verify track transitions.
- Verify backward compatibility: take an MVP1 progress.json and confirm it works with updated skills.
- Check that `wf-NNN` exercise IDs work correctly alongside `cc-NNN` IDs in all skills.

### Requirement Traceability

| PRD Requirement | Curriculum Exercise |
|---|---|
| All FR requirements | All exercises |
