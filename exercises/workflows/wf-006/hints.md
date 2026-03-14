# Hints for wf-006: Plan & Conquer

## Hint 1

This exercise has three parts: first create a planning skill that outputs a
task list, then create a subagent that implements tasks, then run the workflow.
Start with the skill in `.claude/skills/plan/SKILL.md` — it should tell Claude
to explore the code and write a numbered list of improvements to `plan.md`.
Check the project's `CLAUDE.md` for a list of known issues to discover.

## Hint 2

Part 1: Create `.claude/skills/plan/SKILL.md` with frontmatter (`name: plan`,
`description: ...`) and instructions to read the codebase and output a numbered
task list to `plan.md`. Use `$ARGUMENTS` to optionally scope the analysis.

Part 2: Create `.claude/agents/implementer.md` with frontmatter (`name:
implementer`, `description: ...`, `tools: Read, Edit, Write, Grep, Glob`) and
instructions to implement one task from the plan and write a summary to a
result file.

Part 3: Run the plan skill to generate `plan.md`, then ask Claude to "use the
implementer agent to work on task 1" (repeat for 2-3 tasks). Each result goes
in `results/task-N.md`.

## Hint 3

Create the skill at `.claude/skills/plan/SKILL.md`:

```markdown
---
name: plan
description: Analyze codebase and produce improvement task list
---

Explore the codebase and identify improvements that should be made.
Read CLAUDE.md for known issues. If $ARGUMENTS is provided, focus the
analysis on that path.

Write a numbered task list to plan.md. Each task should include:
- A number and title
- The target file(s)
- A brief description of what to change
```

Create the agent at `.claude/agents/implementer.md`:

```markdown
---
name: implementer
description: Implement a single task from the plan
tools: Read, Edit, Write, Grep, Glob
---

Read plan.md to understand the full plan. Implement the assigned task
by making the described changes. When done, write a summary of what
you changed to a result file (e.g., results/task-1.md).
```

Then run the workflow:
1. Ask Claude to run `/plan` (or just ask it to analyze the code and
   write `plan.md`)
2. Ask Claude: "Use the implementer agent to work on tasks 1, 2, and 3
   from the plan. Write results to results/task-1.md, results/task-2.md,
   and results/task-3.md."
