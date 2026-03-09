---
name: task-planning
description: Break an approved curriculum design into independent, implementable tasks with priority and tracking. Use when the user says "plan tasks", "break down tasks", "create task list", "task planning", "decompose into tasks", or has approved PRD + Curriculum Design and wants to plan the implementation work.
disable-model-invocation: true
---

# Task Planning

Break the approved curriculum design into independent, implementable tasks.

## Prerequisites
These must exist and be approved:
- PRD: `docs/prd/PRD-{name}.md`
- Curriculum Design: `docs/curriculum/CURRICULUM-{name}.md`

Read both documents before starting.

## Process

### Step 1: Read all approved documents
Read the PRD and Curriculum Design. Identify:
- Every exercise from the Curriculum Design
- Every requirement from PRD
- Prerequisite chains between exercises
- The natural build order

### Step 2: Identify task boundaries
A good task is:
- **Independent**: Can be implemented and verified without other unfinished tasks
- **Testable**: Has clear, verifiable acceptance criteria
- **Small**: 1-3 hours of work (for Claude Code)
- **Complete**: Includes all files needed (SKILL.md, metadata, validation, hints)

Rules for splitting:
- One exercise per task (each exercise is self-contained)
- Shared validation patterns before exercises that use them
- Earlier-track exercises before later-track exercises (prerequisite order)
- Each task must leave the plugin in a working state

### Step 3: Define dependency order
Tasks form a DAG (directed acyclic graph). Identify:
- Which tasks can run in parallel (no dependencies)
- Which tasks must come before others
- The critical path (longest dependency chain)

### Step 4: Assign priorities
Priority rules:
- **P0 (Critical Path):** Blocks other tasks. Must be done first.
- **P1 (Core):** Part of MVP but doesn't block others.
- **P2 (Enhancement):** Improves quality but MVP works without it.

### Step 5: Write individual task files
For each task, create: `docs/tasks/TASK-NNN.md`
Use the task template below.

### Step 6: Write the master task list
Create: `docs/tasks/TASK-LIST.md`
Use the task list template below.

### Step 7: Present and STOP
Present the task list to the user. Say:
"Here is the Task List with {N} tasks. Please review the priorities, dependencies,
and scope of each task. When you approve, I'll proceed to Implementation for
each task. If you want changes, tell me what to modify."

DO NOT proceed until the user explicitly approves.

## Task File Template (TASK-NNN.md)

# TASK-NNN: {Task Title}

**Priority:** P0 | P1 | P2
**Estimated Effort:** {hours}
**Status:** TODO | IN PROGRESS | IN REVIEW | DONE
**Dependencies:** TASK-NNN, TASK-NNN (or "None")
**Blocked By:** TASK-NNN (or "None")

---

### Objective

One paragraph: what this task accomplishes and why it matters.

### Scope

#### Files to Create
- `src/path/file.ts` — Description of what this file does

#### Files to Modify
- `src/path/existing.ts` — What changes and why

#### Files NOT Touched
- Explicitly note files that are adjacent but out of scope

### Acceptance Criteria

- [ ] AC-1: {specific, testable criterion}
- [ ] AC-2: {specific, testable criterion}
- [ ] AC-3: All relevant tests pass
- [ ] AC-4: Type/syntax check passes (if applicable)

### Technical Notes

Brief implementation hints. NOT the full design — that goes in the detail
design document. Just enough context to understand the task's scope.

### Requirement Traceability

| PRD Requirement | Curriculum Exercise |
|---|---|
| FR-NNN | cc-NNN |

---

## Task List Template (TASK-LIST.md)

# Task List: {Feature/MVP Name}

**Total Tasks:** {N}
**Estimated Total Effort:** {hours}
**Date Created:** {YYYY-MM-DD}
**Status:** PLANNING | IN PROGRESS | COMPLETE

---

### Dependency Graph

TASK-001 (Types & Models)
│
├──▶ TASK-002 (Component A)
│       │
│       ├──▶ TASK-005 (Feature X)
│       └──▶ TASK-006 (Feature Y)
│
└──▶ TASK-003 (Component B)
│
└──▶ TASK-007 (Feature Z)
TASK-004 (Shared Utilities) ──▶ TASK-005, TASK-006, TASK-007

### Task Summary

| ID | Title | Priority | Effort | Status | Dependencies | Assignee |
|---|---|---|---|---|---|---|
| TASK-001 | ... | P0 | 2h | TODO | None | — |
| TASK-002 | ... | P0 | 3h | TODO | TASK-001 | — |
| TASK-003 | ... | P0 | 2h | TODO | TASK-001 | — |
| TASK-004 | ... | P0 | 1h | TODO | None | — |
| TASK-005 | ... | P1 | 3h | TODO | TASK-002, TASK-004 | — |
| ... | ... | ... | ... | ... | ... | — |

### Implementation Order

#### Wave 1 (Parallel — No Dependencies)
- TASK-001: ...
- TASK-004: ...

#### Wave 2 (Depends on Wave 1)
- TASK-002: ...
- TASK-003: ...

#### Wave 3 (Depends on Wave 2)
- TASK-005: ...
- TASK-006: ...
- TASK-007: ...

### Progress Tracking

- [ ] Wave 1 complete
- [ ] Wave 2 complete
- [ ] Wave 3 complete
- [ ] All tests passing
- [ ] Full typecheck passing
- [ ] Ready for PR