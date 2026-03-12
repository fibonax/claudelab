# TASK-011: Exercise cc-008 — Prompt Architect

**Priority:** P1
**Estimated Effort:** 2h
**Status:** DONE
**Dependencies:** TASK-001
**Blocked By:** TASK-001

---

### Objective

Create the capstone exercise teaching three structured prompt patterns: Explore First, Verify Against (tests-first), and Step-by-Step. This is the most complex exercise with multiple deliverables and ties together skills from earlier exercises.

### Scope

#### Files to Create
- `exercises/fundamentals/cc-008/metadata.json` — Exercise metadata with prerequisites `cc-003`, `cc-004`
- `exercises/fundamentals/cc-008/instructions.md` — Three prompt challenges with clear deliverables
- `exercises/fundamentals/cc-008/setup.sh` — Scaffolds an API project with missing input validation
- `exercises/fundamentals/cc-008/validate.sh` — Validates all three deliverables (exploration.md, test file, plan.md)
- `exercises/fundamentals/cc-008/hints.md` — 3 progressive hints

#### Files to Modify
- None

#### Files NOT Touched
- Other exercise directories

### Acceptance Criteria

- [x] AC-1: `setup.sh` creates: `src/api/handlers.ts` (no validation), `src/api/types.ts`, empty `src/tests/` dir, `CLAUDE.md` with code style conventions
- [x] AC-2: `src/api/handlers.ts` has a realistic API handler that accepts user input without validation
- [x] AC-3: `validate.sh` checks all three deliverables:
  - (a) `exploration.md` exists, mentions API/handler/endpoint, ≥5 lines
  - (b) `src/tests/handlers.test.ts` exists, contains test/describe/it code
  - (c) `plan.md` exists, contains numbered steps (regex `[1-3]\.` or `Step [1-3]`)
  - (d) `src/api/handlers.ts` contains "validate" or "validation" or a type check
- [x] AC-4: `instructions.md` clearly explains the three prompt patterns with examples
- [x] AC-5: Each pattern has a concrete task the learner must complete (not just theory)
- [x] AC-6: `validate.sh` provides specific feedback per deliverable (which pattern's output is missing)
- [x] AC-7: Hints address all three patterns progressively
- [x] AC-8: `setup.sh` is idempotent
- [x] AC-9: On successful completion, validation includes a track graduation message

### Technical Notes

- Scaffold API handler example:
  ```typescript
  export function createUser(data: unknown) {
    // No validation — accepts anything
    const user = data as CreateUserInput;
    return { id: generateId(), ...user };
  }
  ```
- The three deliverables test three different prompt patterns:
  1. **Explore First** → `exploration.md` (output of exploring before changing)
  2. **Verify Against** → `src/tests/handlers.test.ts` (tests written before/alongside implementation)
  3. **Step-by-Step** → `plan.md` (numbered plan for adding validation)
- Plus the actual implementation: `handlers.ts` must be modified to include validation.
- Validation:
  ```bash
  test -f "$WORKSPACE/exploration.md"
  grep -qiE "(api|handler|endpoint)" "$WORKSPACE/exploration.md"
  [ "$(wc -l < "$WORKSPACE/exploration.md")" -ge 5 ]
  test -f "$WORKSPACE/src/tests/handlers.test.ts"
  grep -qE "(test|describe|it\()" "$WORKSPACE/src/tests/handlers.test.ts"
  test -f "$WORKSPACE/plan.md"
  grep -qE "([1-3]\.|Step [1-3])" "$WORKSPACE/plan.md"
  grep -qiE "(validat)" "$WORKSPACE/src/api/handlers.ts"
  ```
- This exercise should feel like a culmination. The graduation message after passing should congratulate the learner and tease future tracks.

### Requirement Traceability

| PRD Requirement | Curriculum Exercise |
|---|---|
| FR-008 (Fundamentals Track Content) | cc-008 (Prompt Architect) |
