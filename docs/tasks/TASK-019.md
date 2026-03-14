# TASK-019: Exercise wf-005 — Agent Assembler

**Priority:** P1
**Estimated Effort:** 2h
**Status:** TODO
**Dependencies:** TASK-014
**Blocked By:** TASK-014

---

### Objective

Create the subagents exercise teaching learners to create specialized agent definitions — markdown files in `.claude/agents/` with frontmatter configuration (name, description, tools) and focused instructions.

### Scope

#### Files to Create
- `exercises/workflows/wf-005/metadata.json` — id "wf-005", track "workflows", order 5, prerequisites ["wf-003"]
- `exercises/workflows/wf-005/instructions.md` — Instructions explaining subagent file format, tool restrictions, and creating a code-reviewer agent
- `exercises/workflows/wf-005/setup.sh` — Scaffolds workspace with src/ files of varying quality (API handler without error handling, logger utility), CLAUDE.md, empty .claude/agents/ directory
- `exercises/workflows/wf-005/validate.sh` — Checks: agent file exists, has name/description/tools in frontmatter, mentions Read/Grep, does NOT have Edit/Write in tools, mentions review/check, 15+ lines
- `exercises/workflows/wf-005/hints.md` — 3 progressive hints

#### Files NOT Touched
- Any files in `exercises/fundamentals/`

### Acceptance Criteria

- [ ] AC-1: `metadata.json` has prerequisites ["wf-003"]
- [ ] AC-2: `setup.sh` creates src/ files with intentional quality issues (no error handling, missing validation)
- [ ] AC-3: `validate.sh` checks all 7 validation criteria including the "NOT contains Edit/Write" check
- [ ] AC-4: `instructions.md` explains the difference between skills and subagents, and when to use each
- [ ] AC-5: Exercise passes `/validate-exercise wf-005`

### Technical Notes

- The agent file is `code-reviewer.md` at `.claude/agents/code-reviewer.md`.
- The "NOT contains Edit/Write in tools line" check needs to be scoped to the frontmatter `tools:` line, not the entire file body. Use: `sed -n '/^---$/,/^---$/p' "$FILE" | grep -q "tools:" && sed -n '/^---$/,/^---$/p' "$FILE" | grep "tools:" | grep -qv "Edit\|Write"`.
- The scaffold code should have obvious issues a code reviewer would catch (no try/catch, hardcoded values, missing input validation).

### Requirement Traceability

| PRD Requirement | Curriculum Exercise |
|---|---|
| FR-006 (Subagents) | wf-005 |
