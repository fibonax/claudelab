# TASK-007: Exercise cc-004 — Code Detective

**Priority:** P1
**Estimated Effort:** 2h
**Status:** DONE
**Dependencies:** TASK-001
**Blocked By:** TASK-001

---

### Objective

Create the fourth exercise teaching users how to use Claude to explore and understand an existing codebase before making changes. This introduces the "explore first" pattern and builds code navigation skills.

### Scope

#### Files to Create
- `exercises/fundamentals/cc-004/metadata.json` — Exercise metadata with prerequisite `cc-002`
- `exercises/fundamentals/cc-004/instructions.md` — "You've inherited a codebase" scenario
- `exercises/fundamentals/cc-004/setup.sh` — Scaffolds a multi-file project (6-7 files) with a deliberate bug
- `exercises/fundamentals/cc-004/validate.sh` — Validates answers.md exists with correct content
- `exercises/fundamentals/cc-004/hints.md` — 3 progressive hints

#### Files to Modify
- None

#### Files NOT Touched
- Other exercise directories

### Acceptance Criteria

- [x] AC-1: `setup.sh` creates a realistic multi-file project: `src/index.ts`, `src/routes/users.ts`, `src/routes/posts.ts`, `src/models/user.ts`, `src/models/post.ts`, `src/utils/validate.ts`, `CLAUDE.md`
- [x] AC-2: `src/models/user.ts` contains the deliberate `emial` typo (obvious bug)
- [x] AC-3: All scaffold files are realistic TypeScript code (not empty stubs)
- [x] AC-4: `validate.sh` checks: (a) answers.md exists, (b) mentions routes, (c) mentions user and post models, (d) mentions the emial/email bug, (e) ≥5 lines
- [x] AC-5: `instructions.md` frames the task as "understand before changing" — explicitly asks 3 questions
- [x] AC-6: The bug is obvious enough for a beginner but requires actual exploration to find
- [x] AC-7: `validate.sh` provides specific feedback on which answer is missing
- [x] AC-8: `setup.sh` is idempotent

### Technical Notes

- This is the most scaffolding-heavy exercise (6-7 source files). The code should form a coherent small API:
  - `src/index.ts` — imports routes, sets up express-like structure (no actual express dependency — just typed functions)
  - `src/routes/users.ts` — handler functions for user CRUD
  - `src/routes/posts.ts` — handler functions for post CRUD
  - `src/models/user.ts` — User interface with `emial` typo + a simple data function
  - `src/models/post.ts` — Post interface
  - `src/utils/validate.ts` — simple validation helpers
- Validation checks:
  ```bash
  test -f "$WORKSPACE/answers.md"
  grep -qi "route" "$WORKSPACE/answers.md"
  grep -qi "user" "$WORKSPACE/answers.md" && grep -qi "post" "$WORKSPACE/answers.md"
  grep -qiE "(emial|email.*typo|email.*bug|bug.*email)" "$WORKSPACE/answers.md"
  [ "$(wc -l < "$WORKSPACE/answers.md")" -ge 5 ]
  ```
- Keep the code simple enough that Claude can explore it quickly but complex enough that manual reading would take time.

### Requirement Traceability

| PRD Requirement | Curriculum Exercise |
|---|---|
| FR-008 (Fundamentals Track Content) | cc-004 (Code Detective) |
