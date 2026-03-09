# TASK-005: Exercise cc-002 — Your First CLAUDE.md

**Priority:** P0
**Estimated Effort:** 1.5h
**Status:** TODO
**Dependencies:** TASK-001
**Blocked By:** TASK-001

---

### Objective

Create the second exercise teaching users to create a CLAUDE.md file with essential sections. This is the most important concept in the Fundamentals track — CLAUDE.md is the foundation of effective Claude Code usage.

### Scope

#### Files to Create
- `exercises/fundamentals/cc-002/metadata.json` — Exercise metadata with prerequisite `cc-001`
- `exercises/fundamentals/cc-002/instructions.md` — Explains what CLAUDE.md is and what sections to include
- `exercises/fundamentals/cc-002/setup.sh` — Scaffolds a minimal TypeScript project (src/index.ts, package.json, tsconfig.json)
- `exercises/fundamentals/cc-002/validate.sh` — Validates CLAUDE.md existence, required sections, and line count
- `exercises/fundamentals/cc-002/hints.md` — 3 progressive hints

#### Files to Modify
- None

#### Files NOT Touched
- Other exercise directories
- Skills

### Acceptance Criteria

- [ ] AC-1: `setup.sh` creates workspace with `src/index.ts`, `package.json`, `tsconfig.json` — realistic scaffold files
- [ ] AC-2: Scaffold files are realistic (valid TypeScript, valid package.json, valid tsconfig)
- [ ] AC-3: `validate.sh` checks: (a) CLAUDE.md exists, (b) has a project/description heading, (c) has a commands section, (d) mentions a technology, (e) 10-100 lines
- [ ] AC-4: `instructions.md` explains the "briefing document" metaphor for CLAUDE.md
- [ ] AC-5: `instructions.md` lists required sections clearly (project description, tech stack, commands)
- [ ] AC-6: Hints progress from gentle to near-answer per curriculum spec
- [ ] AC-7: `validate.sh` provides specific feedback on which check failed
- [ ] AC-8: `setup.sh` is idempotent (safe to re-run via `/cclab:reset`)

### Technical Notes

- Validation checks (from curriculum):
  ```bash
  test -f "$WORKSPACE/CLAUDE.md"
  grep -qiE "^##?.*(project|description)" "$WORKSPACE/CLAUDE.md"
  grep -qiE "^##?.*(command|development)" "$WORKSPACE/CLAUDE.md"
  grep -qiE "(typescript|node|npm)" "$WORKSPACE/CLAUDE.md"
  lines=$(wc -l < "$WORKSPACE/CLAUDE.md"); [ "$lines" -ge 10 ] && [ "$lines" -le 100 ]
  ```
- The scaffold should feel like a real (small) project — not a toy. A simple "task manager API" or "note-taking app" gives enough context for a meaningful CLAUDE.md.
- setup.sh should NOT create a CLAUDE.md — that's what the learner does.

### Requirement Traceability

| PRD Requirement | Curriculum Exercise |
|---|---|
| FR-008 (Fundamentals Track Content) | cc-002 (Your First CLAUDE.md) |
| Story 7 (Learn CLAUDE.md Through Practice) | cc-002 |
