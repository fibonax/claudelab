# TASK-006: Exercise cc-003 — Convention Enforcer

**Priority:** P1
**Estimated Effort:** 1.5h
**Status:** TODO
**Dependencies:** TASK-001
**Blocked By:** TASK-001

---

### Objective

Create the third exercise teaching users how to add code style directives to CLAUDE.md and verify that Claude follows them when modifying code. This deepens the CLAUDE.md concept from "documentation" to "instruction set."

### Scope

#### Files to Create
- `exercises/fundamentals/cc-003/metadata.json` — Exercise metadata with prerequisite `cc-002`
- `exercises/fundamentals/cc-003/instructions.md` — Explains CLAUDE.md as instruction set, not just docs
- `exercises/fundamentals/cc-003/setup.sh` — Scaffolds project with intentionally "wrong" code (CommonJS, var)
- `exercises/fundamentals/cc-003/validate.sh` — Validates CLAUDE.md has code style section AND utils.ts is fixed
- `exercises/fundamentals/cc-003/hints.md` — 3 progressive hints

#### Files to Modify
- None

#### Files NOT Touched
- Other exercise directories

### Acceptance Criteria

- [ ] AC-1: `setup.sh` creates `src/utils.ts` with CommonJS `require()` and `var` declarations
- [ ] AC-2: `setup.sh` creates `package.json` with `"type": "module"`
- [ ] AC-3: `setup.sh` creates a CLAUDE.md with project description but NO code style section
- [ ] AC-4: `validate.sh` checks: (a) CLAUDE.md has Code Style/Conventions section, (b) mentions import/ES module, (c) mentions const/var rule, (d) utils.ts has NO `require(`, (e) utils.ts has NO `var `
- [ ] AC-5: Scaffold code is realistic — `utils.ts` should have 3-5 functions using the wrong patterns
- [ ] AC-6: `validate.sh` provides clear failure messages distinguishing "CLAUDE.md not updated" vs "code not fixed"
- [ ] AC-7: Hints guide user through both parts: update CLAUDE.md, then fix code
- [ ] AC-8: `setup.sh` is idempotent

### Technical Notes

- Validation checks (from curriculum):
  ```bash
  grep -qiE "(code style|conventions)" "$WORKSPACE/CLAUDE.md"
  grep -qiE "(import|es module)" "$WORKSPACE/CLAUDE.md"
  grep -qiE "(const|var)" "$WORKSPACE/CLAUDE.md"
  ! grep -q "require(" "$WORKSPACE/src/utils.ts"
  ! grep -q "var " "$WORKSPACE/src/utils.ts"
  ```
- The scaffold utils.ts should have recognizable functions (e.g., `formatDate`, `parseConfig`, `validateEmail`) written in old-style CommonJS + var. This makes the refactoring meaningful and the before/after obvious.
- The pre-existing CLAUDE.md should have a project description section so the learner only needs to ADD the Code Style section, not create the whole file from scratch.

### Requirement Traceability

| PRD Requirement | Curriculum Exercise |
|---|---|
| FR-008 (Fundamentals Track Content) | cc-003 (Convention Enforcer) |
