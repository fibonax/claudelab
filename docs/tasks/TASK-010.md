# TASK-010: Exercise cc-007 — Command Center

**Priority:** P1
**Estimated Effort:** 1h
**Status:** TODO
**Dependencies:** TASK-001
**Blocked By:** TASK-001

---

### Objective

Create the seventh exercise teaching users about Claude Code's built-in slash commands. This is a lighter exercise that builds awareness of the command ecosystem.

### Scope

#### Files to Create
- `exercises/fundamentals/cc-007/metadata.json` — Exercise metadata with prerequisite `cc-001`
- `exercises/fundamentals/cc-007/instructions.md` — Discover and document slash commands
- `exercises/fundamentals/cc-007/setup.sh` — Scaffolds a basic project workspace
- `exercises/fundamentals/cc-007/validate.sh` — Validates commands.md content
- `exercises/fundamentals/cc-007/hints.md` — 3 progressive hints

#### Files to Modify
- None

#### Files NOT Touched
- Other exercise directories

### Acceptance Criteria

- [ ] AC-1: `setup.sh` creates workspace with a few source files and a basic CLAUDE.md
- [ ] AC-2: `validate.sh` checks: (a) `commands.md` exists, (b) has ≥5 lines starting with `/`, (c) mentions `/help`, (d) mentions `/compact` or `/clear`, (e) ≥8 total lines
- [ ] AC-3: `instructions.md` explains the discovery task: use /help, explore commands, document findings
- [ ] AC-4: Hints guide user from "try /help" to specific command list
- [ ] AC-5: `validate.sh` provides specific feedback on what's missing
- [ ] AC-6: `setup.sh` is idempotent

### Technical Notes

- Validation:
  ```bash
  test -f "$WORKSPACE/commands.md"
  [ "$(grep -c "^/" "$WORKSPACE/commands.md")" -ge 5 ]
  grep -qi "/help" "$WORKSPACE/commands.md"
  grep -qiE "/(compact|clear)" "$WORKSPACE/commands.md"
  [ "$(wc -l < "$WORKSPACE/commands.md")" -ge 8 ]
  ```
- This exercise is intentionally lighter — it's a knowledge-gathering task, not a code-modification task.
- The setup scaffold exists only to give the workspace context (so /init and other commands have something to work with).
- Note: prerequisite is only cc-001 (not cc-002), making this accessible early in the track. Per the curriculum, the linear sequence presents it as exercise 7, but it could be attempted earlier.

### Requirement Traceability

| PRD Requirement | Curriculum Exercise |
|---|---|
| FR-008 (Fundamentals Track Content) | cc-007 (Command Center) |
