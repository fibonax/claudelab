# TASK-018: Exercise wf-004 — Skill Surgeon

**Priority:** P1
**Estimated Effort:** 2h
**Status:** TODO
**Dependencies:** TASK-014
**Blocked By:** TASK-014

---

### Objective

Create the advanced skills exercise teaching argument handling (`$ARGUMENTS`, `$0`/`$1`), `argument-hint`, `disable-model-invocation`, and structured multi-step instructions in SKILL.md files.

### Scope

#### Files to Create
- `exercises/workflows/wf-004/metadata.json` — id "wf-004", track "workflows", order 4, prerequisites ["wf-003"]
- `exercises/workflows/wf-004/instructions.md` — Instructions covering argument substitution, argument-hint, disable-model-invocation, and creating a refactor skill
- `exercises/workflows/wf-004/setup.sh` — Scaffolds workspace with several src/ files, CLAUDE.md with code style conventions, empty .claude/skills/ directory
- `exercises/workflows/wf-004/validate.sh` — Checks: SKILL.md exists, has name/description, uses $ARGUMENTS or $0, has argument-hint, has disable-model-invocation, 4+ numbered steps, 15+ lines
- `exercises/workflows/wf-004/hints.md` — 3 progressive hints

#### Files NOT Touched
- Any files in `exercises/fundamentals/`

### Acceptance Criteria

- [ ] AC-1: `metadata.json` has prerequisites ["wf-003"]
- [ ] AC-2: `setup.sh` creates multiple src/ files to give context for the refactoring skill
- [ ] AC-3: `validate.sh` checks all 8 validation criteria from curriculum
- [ ] AC-4: `instructions.md` clearly explains $ARGUMENTS/$0/$1 substitution with examples
- [ ] AC-5: Exercise passes `/validate-exercise wf-004`

### Technical Notes

- The skill is called `refactor` at `.claude/skills/refactor/SKILL.md`.
- Check for `$ARGUMENTS` or `$0` using: `grep -qE '(\$ARGUMENTS|\$0)' "$SKILL_FILE"`.
- Check for frontmatter fields like `argument-hint:` and `disable-model-invocation:` using grep within the frontmatter section.

### Requirement Traceability

| PRD Requirement | Curriculum Exercise |
|---|---|
| FR-005 (Skills / Slash Commands) | wf-004 |
