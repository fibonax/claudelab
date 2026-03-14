# TASK-017: Exercise wf-003 — Command Crafter

**Priority:** P0
**Estimated Effort:** 2h
**Status:** TODO
**Dependencies:** TASK-014
**Blocked By:** TASK-014

---

### Objective

Create the first skills exercise teaching learners to author a custom slash command by writing a SKILL.md file with proper YAML frontmatter and markdown instructions.

### Scope

#### Files to Create
- `exercises/workflows/wf-003/metadata.json` — id "wf-003", track "workflows", order 3, prerequisites ["wf-001"]
- `exercises/workflows/wf-003/instructions.md` — Instructions explaining SKILL.md format, frontmatter fields, skill discovery, and how to create the explain-code skill
- `exercises/workflows/wf-003/setup.sh` — Scaffolds workspace with src/index.ts, src/utils.ts, package.json, CLAUDE.md, empty .claude/skills/ directory
- `exercises/workflows/wf-003/validate.sh` — Checks: SKILL.md exists at correct path, has name/description in frontmatter, has frontmatter delimiters, has numbered steps, at least 10 lines
- `exercises/workflows/wf-003/hints.md` — 3 progressive hints

#### Files NOT Touched
- Any files in `exercises/fundamentals/`

### Acceptance Criteria

- [ ] AC-1: `metadata.json` has correct fields with prerequisites ["wf-001"]
- [ ] AC-2: `setup.sh` creates empty `.claude/skills/` directory structure
- [ ] AC-3: `validate.sh` checks all 6 validation criteria from curriculum (file exists, name, description, frontmatter delimiters, numbered steps, line count)
- [ ] AC-4: `instructions.md` explains SKILL.md structure with a clear example of frontmatter + body
- [ ] AC-5: Exercise passes `/validate-exercise wf-003`

### Technical Notes

- Frontmatter check: grep for lines matching `^name:` and `^description:` between `---` delimiters.
- Numbered steps check: `grep -qE '[1-3]\.' "$SKILL_FILE"`.
- The skill name is `explain-code` and must be at `.claude/skills/explain-code/SKILL.md`.

### Requirement Traceability

| PRD Requirement | Curriculum Exercise |
|---|---|
| FR-005 (Skills / Slash Commands) | wf-003 |
