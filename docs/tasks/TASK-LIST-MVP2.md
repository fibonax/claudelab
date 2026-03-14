# Task List: cclab MVP2 — Workflows Track

**Total Tasks:** 10
**Estimated Total Effort:** 22.5h
**Date Created:** 2026-03-14
**Status:** PLANNING

---

### Dependency Graph

```
TASK-014 (Multi-Track Infrastructure)
│
├──▶ TASK-015 (wf-001: Hook Line)
├──▶ TASK-016 (wf-002: Guard Rails)
├──▶ TASK-017 (wf-003: Command Crafter)
├──▶ TASK-018 (wf-004: Skill Surgeon)
├──▶ TASK-019 (wf-005: Agent Assembler)
├──▶ TASK-020 (wf-006: Plan & Conquer)
├──▶ TASK-021 (wf-007: Plug It In + MCP Server)
├──▶ TASK-022 (wf-008: Branch Out)
│
└──▶ TASK-023 (Integration Testing & QA) ◀── all exercise tasks
```

**Critical path:** TASK-014 (infrastructure must land before any exercise can be tested end-to-end)

All exercise tasks (TASK-015 through TASK-022) depend only on TASK-014. They can be implemented in parallel — exercise prerequisite chains affect learner progression, not development order.

### Task Summary

| ID | Title | Priority | Effort | Status | Dependencies | Assignee |
|---|---|---|---|---|---|---|
| TASK-014 | Multi-Track Infrastructure Refactoring | P0 | 3h | DONE | None | — |
| TASK-015 | Exercise wf-001 — Hook Line | P0 | 2h | DONE | TASK-014 | — |
| TASK-016 | Exercise wf-002 — Guard Rails | P0 | 2h | DONE | TASK-014 | — |
| TASK-017 | Exercise wf-003 — Command Crafter | P0 | 2h | DONE | TASK-014 | — |
| TASK-018 | Exercise wf-004 — Skill Surgeon | P1 | 2h | DONE | TASK-014 | — |
| TASK-019 | Exercise wf-005 — Agent Assembler | P1 | 2h | DONE | TASK-014 | — |
| TASK-020 | Exercise wf-006 — Plan & Conquer | P1 | 2.5h | DONE | TASK-014 | — |
| TASK-021 | Exercise wf-007 — Plug It In + MCP Server | P1 | 3h | DONE | TASK-014 | — |
| TASK-022 | Exercise wf-008 — Branch Out | P1 | 2h | DONE | TASK-014 | — |
| TASK-023 | Integration Testing & QA | P2 | 2h | DONE | All above | — |

### Implementation Order

#### Wave 1 — Infrastructure (No Dependencies)
- **TASK-014:** Multi-Track Infrastructure Refactoring

#### Wave 2 — Gateway + Core Exercises (Depends on Wave 1)
- **TASK-015:** Exercise wf-001 — Hook Line (gateway exercise)
- **TASK-016:** Exercise wf-002 — Guard Rails
- **TASK-017:** Exercise wf-003 — Command Crafter

#### Wave 3 — Remaining Exercises (Depends on Wave 1)
- **TASK-018:** Exercise wf-004 — Skill Surgeon
- **TASK-019:** Exercise wf-005 — Agent Assembler
- **TASK-020:** Exercise wf-006 — Plan & Conquer (capstone)
- **TASK-021:** Exercise wf-007 — Plug It In + Sample MCP Server
- **TASK-022:** Exercise wf-008 — Branch Out

#### Wave 4 — QA (Depends on All)
- **TASK-023:** Integration Testing & QA

### Recommended Sequential Order

For single-developer execution (implementing one task at a time):

1. **TASK-014** — Multi-track infrastructure (foundation — must be first)
2. **TASK-015** — wf-001 Hook Line (gateway, proves pipeline works with new track)
3. **TASK-016** — wf-002 Guard Rails (settings path)
4. **TASK-017** — wf-003 Command Crafter (authoring path start)
5. **TASK-018** — wf-004 Skill Surgeon (skills advanced)
6. **TASK-019** — wf-005 Agent Assembler (subagents)
7. **TASK-020** — wf-006 Plan & Conquer (capstone — combines wf-004 + wf-005)
8. **TASK-021** — wf-007 Plug It In (MCP — most complex, includes sample server)
9. **TASK-022** — wf-008 Branch Out (standalone, easy finisher)
10. **TASK-023** — Integration testing (final QA pass)

### Progress Tracking

- [x] Wave 1 complete (infrastructure)
- [x] Wave 2 complete (gateway + core exercises)
- [x] Wave 3 complete (remaining exercises)
- [x] Wave 4 complete (QA)
- [ ] All 8 Fundamentals exercises still pass after infrastructure changes
- [ ] All 8 Workflows exercises pass `/validate-exercise`
- [ ] End-to-end: fresh install → /cclab:start → wf-001 loads → /cclab:check passes
- [ ] Track transition: completed fundamentals → /cclab:start → workflows offered
- [ ] Ready for PR
