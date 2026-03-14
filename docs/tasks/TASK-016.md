# TASK-016: Exercise wf-002 — Guard Rails

**Priority:** P0
**Estimated Effort:** 2h
**Status:** TODO
**Dependencies:** TASK-014
**Blocked By:** TASK-014

---

### Objective

Create the permissions exercise teaching Claude Code's permission model and settings.json configuration. Learners create allow/deny rules to protect sensitive files and control tool access.

### Scope

#### Files to Create
- `exercises/workflows/wf-002/metadata.json` — id "wf-002", track "workflows", order 2, prerequisites ["wf-001"]
- `exercises/workflows/wf-002/instructions.md` — Instructions explaining permission levels, tool pattern syntax, project vs user settings
- `exercises/workflows/wf-002/setup.sh` — Scaffolds workspace with src/app.ts, src/db.ts, .env (fake credentials), secrets/api-keys.json, CLAUDE.md, empty .claude/ directory
- `exercises/workflows/wf-002/validate.sh` — Checks: settings.json exists, has permissions/allow/deny keys, mentions sensitive files, mentions tool patterns, valid JSON structure
- `exercises/workflows/wf-002/hints.md` — 3 progressive hints

#### Files NOT Touched
- Any files in `exercises/fundamentals/`
- Any skill files

### Acceptance Criteria

- [ ] AC-1: `metadata.json` has correct fields with prerequisites ["wf-001"]
- [ ] AC-2: `setup.sh` creates .env with fake credentials and secrets/ directory with fake API keys
- [ ] AC-3: `validate.sh` checks all 7 validation criteria from curriculum
- [ ] AC-4: `validate.sh` validates JSON structure without requiring `jq` (use python3 or grep-based check)
- [ ] AC-5: `instructions.md` covers all three permission levels and tool pattern syntax
- [ ] AC-6: Exercise passes `/validate-exercise wf-002`

### Technical Notes

- The .env file should contain obviously fake credentials (e.g., `DB_PASSWORD=fake-password-do-not-use`).
- JSON validity check: prefer `python3 -c "import json; json.load(open('$FILE'))"` as python3 is available on macOS/Linux. Fall back to grep-based structure check if python3 is unavailable.

### Requirement Traceability

| PRD Requirement | Curriculum Exercise |
|---|---|
| FR-004 (Permissions & Settings) | wf-002 |
