# Plan & Conquer

In the previous exercises, you learned how to create **skills** (custom slash
commands) and **subagents** (specialized workers with scoped tools). Now it's
time to combine them into a real workflow.

The pattern is called **plan then implement**: a planning skill analyzes the
codebase and produces a structured task list, then you spawn subagents to
execute individual tasks from that list. This is how experienced Claude Code
users break down large changes into manageable, parallel pieces.

## How It Works

1. **Plan** — A skill explores the codebase, identifies improvements, and
   writes a numbered task list to a file (e.g., `plan.md`)
2. **Implement** — A subagent picks up one task from the plan, makes the
   changes, and writes a summary of what it did
3. **Repeat** — Spawn multiple subagents (one per task) to work through the
   plan in parallel

This is powerful because the planning step gives structure to the work, and
the subagents can execute independently without stepping on each other.

## Your Task

This workspace has a small project with several obvious improvement
opportunities — no input validation, incomplete types, hardcoded values, and
a stub logger. Your job is to build the planning and implementation
infrastructure, then run it.

### Part 1: Create the Planning Skill

Create `.claude/skills/plan/SKILL.md` — a skill that analyzes the codebase
and produces a task list.

Your skill needs:
- Frontmatter with `name:` and `description:` fields
- Instructions that tell Claude to:
  - Explore the codebase (read files, check CLAUDE.md for known issues)
  - Identify concrete improvements
  - Write a numbered task list to `plan.md`
  - Each task should have: a number, a title, the target file(s), and a brief
    description of what to do
- Support for `$ARGUMENTS` to optionally scope the analysis (e.g.,
  `/plan src/api/` to focus on just the API layer)

### Part 2: Create the Implementer Agent

Create `.claude/agents/implementer.md` — a subagent that implements a single
task from a plan.

Your agent needs:
- Frontmatter with `name:`, `description:`, and `tools:` fields
- The tools list should include `Read`, `Edit`, `Write`, `Grep`, and `Glob`
  (the agent needs both read and write access)
- Instructions that tell the agent to:
  - Read `plan.md` to understand the full plan
  - Pick up the assigned task (passed as context when spawned)
  - Implement the changes described in that task
  - Write a summary of what was done to a result file (e.g.,
    `results/task-1.md`)

### Part 3: Run the Workflow

Now put it all together:

1. **Generate the plan** — Run your planning skill (or ask Claude to analyze
   the codebase and write `plan.md`). The plan should have at least 3 numbered
   tasks and be at least 10 lines long.
2. **Spawn implementer subagents** — Ask Claude to use the implementer agent
   to work on 2-3 tasks from the plan. For example: "Use the implementer
   agent to work on tasks 1 and 2 from plan.md. Write results to
   results/task-1.md and results/task-2.md."
3. **Check the results** — You should have a `results/` directory with at
   least 2 result files summarizing what was done.

## Getting Started

First, navigate to the exercise workspace:

```bash
cd ~/.cclab/workspace/wf-006/
```

Take a look at the existing files to understand the project:

- **`src/api/handlers.ts`** — API handlers with no input validation or error
  handling
- **`src/api/types.ts`** — incomplete type definitions
- **`src/services/user-service.ts`** — user service with hardcoded values
- **`src/utils/logger.ts`** — stub logger (only `console.log`)
- **`CLAUDE.md`** — project description listing known issues
- **`.claude/skills/`** and **`.claude/agents/`** — empty directories waiting
  for your skill and agent

Read the code and CLAUDE.md to understand the improvement opportunities. Then
start with Part 1 — creating the planning skill. You can create the files in
several ways:

- **Inside Claude Code** — ask Claude to create the skill and agent files
- **Open in VS Code** — run `code ~/.cclab/workspace/wf-006/` in your
  terminal, then create the files directly
- **From the terminal** — use any editor you like:
  ```bash
  mkdir -p .claude/skills/plan
  nano .claude/skills/plan/SKILL.md
  mkdir -p .claude/agents
  nano .claude/agents/implementer.md
  ```

## Requirements

- `.claude/skills/plan/SKILL.md` exists with `name:` and `description:` in
  frontmatter
- Plan skill references `plan.md` or `task` (knows where to write output)
- `.claude/agents/implementer.md` exists with `name:`, `description:`, and
  `tools:` in frontmatter
- Implementer agent mentions `Edit` or `Write` (has write access)
- `plan.md` exists in the workspace root with at least 3 numbered items and
  at least 10 lines
- `results/` directory exists with at least 2 files (evidence the workflow
  ran)

## Tips

- Read `CLAUDE.md` in the workspace first — it lists the known issues that
  your planning skill should discover
- The planning skill doesn't need to be perfect — it just needs to produce a
  structured list that the implementer can follow
- When spawning subagents, tell Claude which task number to work on and where
  to write the result file
- You can run the planning skill with arguments to scope it:
  `/plan src/api/` to focus on just the API layer

## When You're Done

Run `/cclab:check` to validate your work.
