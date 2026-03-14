# TASK-015: Exercise wf-001 — Hook Line

**Priority:** P0
**Estimated Effort:** 2h
**Status:** DONE
**Dependencies:** TASK-014
**Blocked By:** TASK-014

---

### Objective

Create the first Workflows track exercise teaching Claude Code hook configuration. This is the gateway exercise — it introduces the `.claude/settings.json` structure and hook events, giving learners a tangible automation they can build immediately.

### Scope

#### Files to Create
- `exercises/workflows/wf-001/metadata.json` — Exercise metadata (id, title, track: "workflows", order: 1, prerequisites: [])
- `exercises/workflows/wf-001/instructions.md` — Full exercise instructions following the cc-003 format pattern
- `exercises/workflows/wf-001/setup.sh` — Scaffolds workspace at `~/.cclab/workspace/wf-001/` with src/app.ts, src/utils.ts, package.json, CLAUDE.md
- `exercises/workflows/wf-001/validate.sh` — Checks: .claude/settings.json exists, contains hooks/event/matcher/command, scripts/log-edits.sh exists and is executable
- `exercises/workflows/wf-001/hints.md` — 3 progressive hints per curriculum spec

#### Files NOT Touched
- Any files in `exercises/fundamentals/`
- Any skill files in `.claude/skills/`

### Acceptance Criteria

- [x] AC-1: `metadata.json` has correct fields: id "wf-001", track "workflows", order 1, prerequisites []
- [x] AC-2: `setup.sh` is idempotent and creates workspace with all scaffold files
- [x] AC-3: `validate.sh` checks all 8 validation criteria from curriculum (settings.json exists, hooks key, event name, matcher, command, script exists, exit handling, executable)
- [x] AC-4: `validate.sh` provides clear FAIL messages explaining what's wrong
- [x] AC-5: `instructions.md` explains hook events, shows settings.json structure, guides through both settings.json and hook script creation
- [x] AC-6: `hints.md` has 3 levels separated by `## Hint` markers
- [x] AC-7: Exercise passes `/validate-exercise wf-001`

### Technical Notes

- Follow the exact exercise file patterns established in MVP1 (see cc-003 for reference).
- setup.sh must use `mkdir -p` and write files with heredocs for idempotency.
- validate.sh uses grep-based checks for settings.json content and `test -x` for executable check.
- Instructions should include a "Getting Started" section pointing to `cd ~/.cclab/workspace/wf-001/`.

### Requirement Traceability

| PRD Requirement | Curriculum Exercise |
|---|---|
| FR-003 (Hooks Exercises) | wf-001 |
