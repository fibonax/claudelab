# TASK-020: Exercise wf-006 — Plan & Conquer

**Priority:** P1
**Estimated Effort:** 2.5h
**Status:** TODO
**Dependencies:** TASK-014
**Blocked By:** TASK-014

---

### Objective

Create the capstone exercise that combines skills and subagents into a plan-then-implement workflow. Learners create a planning skill that outputs a task list and an implementer subagent, then run the workflow by spawning 2-3 subagents to implement planned tasks.

### Scope

#### Files to Create
- `exercises/workflows/wf-006/metadata.json` — id "wf-006", track "workflows", order 6, prerequisites ["wf-004", "wf-005"]
- `exercises/workflows/wf-006/instructions.md` — Three-part instructions: create planning skill, create implementer agent, run the workflow
- `exercises/workflows/wf-006/setup.sh` — Scaffolds workspace with a project having 3-4 clear improvement areas (API handler without validation, incomplete types, hardcoded values, stub logger), empty .claude/skills/ and .claude/agents/ directories
- `exercises/workflows/wf-006/validate.sh` — Checks: plan skill exists with frontmatter, implementer agent exists with frontmatter and write tools, plan.md exists with 3+ numbered items and 10+ lines, results/ directory exists with 2+ files
- `exercises/workflows/wf-006/hints.md` — 3 progressive hints

#### Files NOT Touched
- Any files in `exercises/fundamentals/`

### Acceptance Criteria

- [ ] AC-1: `metadata.json` has prerequisites ["wf-004", "wf-005"]
- [ ] AC-2: `setup.sh` creates a realistic project with 3-4 obvious improvement opportunities
- [ ] AC-3: `validate.sh` checks all 15 validation criteria from curriculum (skill, agent, plan.md, results/)
- [ ] AC-4: `instructions.md` clearly explains the three-part workflow and how to spawn multiple subagents
- [ ] AC-5: Scaffold code has clear, discoverable issues (no input validation, incomplete types, hardcoded values, stub logging)
- [ ] AC-6: Exercise passes `/validate-exercise wf-006`

### Technical Notes

- This is the most complex exercise — three parts with runtime validation (plan.md and results/ are created during execution, not setup).
- The file count check for results/: `[ "$(ls -1 "$WORKSPACE/results/" 2>/dev/null | wc -l)" -ge 2 ]`.
- The plan.md check for 3 numbered items: `grep -cE '^\s*[0-9]+\.' "$WORKSPACE/plan.md"` should be >= 3.
- The scaffold project should be realistic enough that Claude generates meaningful plans and implementations.
- CLAUDE.md should list known issues to make the planning skill's job discoverable.

### Requirement Traceability

| PRD Requirement | Curriculum Exercise |
|---|---|
| FR-005 (Skills / Slash Commands) | wf-006 |
| FR-006 (Subagents) | wf-006 |
