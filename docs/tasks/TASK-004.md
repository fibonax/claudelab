# TASK-004: Exercise cc-001 — Hello Claude Code

**Priority:** P0
**Estimated Effort:** 1h
**Status:** TODO
**Dependencies:** TASK-001
**Blocked By:** TASK-001

---

### Objective

Create the first exercise in the Fundamentals track. This is the gateway exercise — it confirms Claude Code works, builds confidence, and teaches the basic prompt-execute-observe loop. Must be completable in under 5 minutes.

### Scope

#### Files to Create
- `exercises/fundamentals/cc-001/metadata.json` — Exercise metadata (ID, title, track, difficulty, prerequisites, order)
- `exercises/fundamentals/cc-001/instructions.md` — Learner-facing instructions
- `exercises/fundamentals/cc-001/setup.sh` — Creates empty workspace at `~/.cclab/workspace/cc-001/`
- `exercises/fundamentals/cc-001/validate.sh` — Checks hello.md exists, has content, mentions "Claude"
- `exercises/fundamentals/cc-001/hints.md` — 3 progressive hints

#### Files to Modify
- None

#### Files NOT Touched
- Other exercise directories
- Skills (created in TASK-002/003)

### Acceptance Criteria

- [ ] AC-1: `metadata.json` contains correct ID (`cc-001`), track (`fundamentals`), difficulty (`beginner`), order (`1`), empty prerequisites
- [ ] AC-2: `instructions.md` clearly explains the task in beginner-friendly language
- [ ] AC-3: `setup.sh` is executable, creates `~/.cclab/workspace/cc-001/` idempotently (`mkdir -p`)
- [ ] AC-4: `validate.sh` checks: (a) `hello.md` exists, (b) file has ≥3 lines, (c) file contains "Claude" (case-insensitive)
- [ ] AC-5: `validate.sh` provides clear feedback messages on each failure
- [ ] AC-6: `hints.md` has 3 levels separated by `## Hint 1/2/3` markers
- [ ] AC-7: Hint progression goes from gentle nudge → specific guidance → near-answer
- [ ] AC-8: `validate.sh` exits 0 on pass, non-zero on fail

### Technical Notes

- Validation checks (from curriculum):
  ```bash
  test -f "$WORKSPACE/hello.md"                          # file exists
  [ "$(wc -l < "$WORKSPACE/hello.md")" -ge 3 ]          # at least 3 lines
  grep -qi "claude" "$WORKSPACE/hello.md"                # mentions Claude
  ```
- setup.sh is trivial: just `mkdir -p ~/.cclab/workspace/cc-001/`
- Instructions should mention that this is a warm-up exercise and encourage the learner to just talk to Claude naturally.

### Requirement Traceability

| PRD Requirement | Curriculum Exercise |
|---|---|
| FR-008 (Fundamentals Track Content) | cc-001 (Hello Claude Code) |
