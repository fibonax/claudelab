# Task List: cclab MVP1 — Fundamentals Track

**Total Tasks:** 11
**Estimated Total Effort:** 16h
**Date Created:** 2026-03-09
**Status:** PLANNING

---

### Dependency Graph

```
TASK-001 (Plugin Manifest & Framework)
│
├──▶ TASK-002 (Core Skills: start, check, hint)
│    │
│    └──▶ TASK-003 (Supporting Skills: status, reset)
│
├──▶ TASK-004 (cc-001: Hello Claude Code)
├──▶ TASK-005 (cc-002: Your First CLAUDE.md)
├──▶ TASK-006 (cc-003: Convention Enforcer)
├──▶ TASK-007 (cc-004: Code Detective)
├──▶ TASK-008 (cc-005: The Great Refactor)
├──▶ TASK-009 (cc-006: Git Like a Pro)
├──▶ TASK-010 (cc-007: Command Center)
└──▶ TASK-011 (cc-008: Prompt Architect)
```

**Critical path:** TASK-001 → TASK-002 → TASK-003 (skills must exist before end-to-end testing)

All exercise tasks (TASK-004 through TASK-011) depend only on TASK-001 for directory structure. They can be authored in parallel with the skills, but require TASK-002 to be tested end-to-end.

### Task Summary

| ID | Title | Priority | Effort | Status | Dependencies | Assignee |
|---|---|---|---|---|---|---|
| TASK-001 | Plugin Manifest & Exercise Framework | P0 | 1h | TODO | None | — |
| TASK-002 | Core Skills — start, check, hint | P0 | 2h | TODO | TASK-001 | — |
| TASK-003 | Supporting Skills — status, reset | P1 | 1h | TODO | TASK-002 | — |
| TASK-004 | Exercise cc-001 — Hello Claude Code | P0 | 1h | TODO | TASK-001 | — |
| TASK-005 | Exercise cc-002 — Your First CLAUDE.md | P0 | 1.5h | TODO | TASK-001 | — |
| TASK-006 | Exercise cc-003 — Convention Enforcer | P1 | 1.5h | TODO | TASK-001 | — |
| TASK-007 | Exercise cc-004 — Code Detective | P1 | 2h | TODO | TASK-001 | — |
| TASK-008 | Exercise cc-005 — The Great Refactor | P1 | 2h | TODO | TASK-001 | — |
| TASK-009 | Exercise cc-006 — Git Like a Pro | P1 | 2h | TODO | TASK-001 | — |
| TASK-010 | Exercise cc-007 — Command Center | P1 | 1h | TODO | TASK-001 | — |
| TASK-011 | Exercise cc-008 — Prompt Architect | P1 | 2h | TODO | TASK-001 | — |

### Implementation Order

#### Wave 1 — Foundation (No Dependencies)
- **TASK-001:** Plugin Manifest & Exercise Framework

#### Wave 2 — Core Loop + First Exercises (Depends on Wave 1)
- **TASK-002:** Core Skills — start, check, hint
- **TASK-004:** Exercise cc-001 — Hello Claude Code
- **TASK-005:** Exercise cc-002 — Your First CLAUDE.md

#### Wave 3 — Remaining Exercises + Supporting Skills (Depends on Wave 1; TASK-003 depends on Wave 2)
- **TASK-003:** Supporting Skills — status, reset
- **TASK-006:** Exercise cc-003 — Convention Enforcer
- **TASK-007:** Exercise cc-004 — Code Detective
- **TASK-010:** Exercise cc-007 — Command Center

#### Wave 4 — Intermediate Exercises (Depends on Wave 1)
- **TASK-008:** Exercise cc-005 — The Great Refactor
- **TASK-009:** Exercise cc-006 — Git Like a Pro
- **TASK-011:** Exercise cc-008 — Prompt Architect (capstone)

### Recommended Sequential Order

For single-developer execution (implementing one task at a time), the recommended order is:

1. **TASK-001** — Plugin manifest (foundation)
2. **TASK-002** — Core skills (enables the learning loop)
3. **TASK-004** — cc-001 Hello Claude Code (simplest exercise, proves pipeline works)
4. **TASK-005** — cc-002 Your First CLAUDE.md (key concept, tests scaffolding)
5. **TASK-003** — Supporting skills (completes the skill set)
6. **TASK-006** — cc-003 Convention Enforcer
7. **TASK-007** — cc-004 Code Detective
8. **TASK-010** — cc-007 Command Center
9. **TASK-008** — cc-005 The Great Refactor
10. **TASK-009** — cc-006 Git Like a Pro
11. **TASK-011** — cc-008 Prompt Architect (capstone — last)

### Progress Tracking

- [ ] Wave 1 complete
- [ ] Wave 2 complete
- [ ] Wave 3 complete
- [ ] Wave 4 complete
- [ ] All exercises pass validation via `/validate-exercise`
- [ ] End-to-end test: fresh install → /cclab:start → complete cc-001 → /cclab:check passes
- [ ] Ready for PR
