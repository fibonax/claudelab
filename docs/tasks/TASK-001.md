# TASK-001: Plugin Manifest & Exercise Framework

**Priority:** P0
**Estimated Effort:** 1h
**Status:** TODO
**Dependencies:** None
**Blocked By:** None

---

### Objective

Establish the foundational plugin manifest and exercise directory structure that all subsequent tasks build on. Without this, no skills can be delivered and no exercises can be authored.

### Scope

#### Files to Create
- `plugin.json` — Plugin manifest with metadata, version, min Claude Code version, and references to all 5 learner-facing skills
- `exercises/fundamentals/` — Directory structure for the fundamentals track (empty exercise subdirs created by individual exercise tasks)

#### Files to Modify
- None

#### Files NOT Touched
- `.claude/skills/` — Existing dev-only skills are not modified
- `CLAUDE.md` — Project instructions stay as-is

### Acceptance Criteria

- [ ] AC-1: `plugin.json` exists and is valid JSON
- [ ] AC-2: `plugin.json` includes name, version, description, and lists all 5 learner-facing skills (start, check, hint, status, reset)
- [ ] AC-3: `exercises/fundamentals/` directory exists
- [ ] AC-4: Plugin manifest follows Claude Code plugin API conventions (research current spec)

### Technical Notes

- Research the Claude Code plugin API to determine the exact plugin.json schema. Reference the `learn-faster-kit` plugin and Claude Code docs.
- The manifest should reference skills at `.claude/skills/{name}/SKILL.md`.
- Keep the manifest minimal — name, version, description, skills list, and optionally `min_claude_code_version`.

### Requirement Traceability

| PRD Requirement | Curriculum Exercise |
|---|---|
| FR-001 (Plugin Installation) | — |
| FR-008 (Fundamentals Track Content) | — |
