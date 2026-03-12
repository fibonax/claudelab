# TASK-008: Exercise cc-005 — The Great Refactor

**Priority:** P1
**Estimated Effort:** 2h
**Status:** DONE
**Dependencies:** TASK-001
**Blocked By:** TASK-001

---

### Objective

Create the fifth exercise teaching users to direct Claude for coordinated multi-file renames and refactoring. This demonstrates one of Claude's strongest capabilities — making consistent changes across an entire codebase in one pass.

### Scope

#### Files to Create
- `exercises/fundamentals/cc-005/metadata.json` — Exercise metadata with prerequisite `cc-004`
- `exercises/fundamentals/cc-005/instructions.md` — Rename getUserData → fetchUserProfile across 5 files
- `exercises/fundamentals/cc-005/setup.sh` — Scaffolds project with function used across multiple files
- `exercises/fundamentals/cc-005/validate.sh` — Validates old name is completely gone, new name exists everywhere
- `exercises/fundamentals/cc-005/hints.md` — 3 progressive hints

#### Files to Modify
- None

#### Files NOT Touched
- Other exercise directories

### Acceptance Criteria

- [x] AC-1: `setup.sh` creates 5+ files all referencing `getUserData`: service definition, route handlers, middleware, test file
- [x] AC-2: `getUserData()` is defined in `src/services/user-service.ts` and imported/called in 4 other files
- [x] AC-3: `validate.sh` checks: (a) no file in `src/` contains `getUserData`, (b) `fetchUserProfile` exists in all 5 files
- [x] AC-4: `validate.sh` uses `grep -r` to verify zero remaining references to old name
- [x] AC-5: `instructions.md` is clear about the rename scope (definition + all imports + all call sites)
- [x] AC-6: Scaffold code is syntactically correct TypeScript with realistic import/export patterns
- [x] AC-7: `validate.sh` reports which specific files still contain the old name on failure
- [x] AC-8: `setup.sh` is idempotent

### Technical Notes

- Scaffold files:
  - `src/services/user-service.ts` — exports `getUserData()` function
  - `src/routes/users.ts` — imports and calls `getUserData()`
  - `src/routes/admin.ts` — imports and calls `getUserData()`
  - `src/middleware/auth.ts` — imports and calls `getUserData()`
  - `src/tests/user.test.ts` — imports and tests `getUserData()`
  - `CLAUDE.md` — project description
- Validation:
  ```bash
  ! grep -rq "getUserData" "$WORKSPACE/src/"
  grep -q "fetchUserProfile" "$WORKSPACE/src/services/user-service.ts"
  grep -q "fetchUserProfile" "$WORKSPACE/src/routes/users.ts"
  grep -q "fetchUserProfile" "$WORKSPACE/src/routes/admin.ts"
  grep -q "fetchUserProfile" "$WORKSPACE/src/middleware/auth.ts"
  grep -q "fetchUserProfile" "$WORKSPACE/src/tests/user.test.ts"
  ```
- The function should have a meaningful body (not just a stub) so the refactoring feels real. It should return a user object with typed fields.

### Requirement Traceability

| PRD Requirement | Curriculum Exercise |
|---|---|
| FR-008 (Fundamentals Track Content) | cc-005 (The Great Refactor) |
