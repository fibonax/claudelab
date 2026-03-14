# Agent Assembler

In the previous exercises, you learned to create custom slash commands (skills)
using SKILL.md files. Skills are great for defining reusable workflows, but
sometimes you need something more focused — a **subagent** that operates with
restricted tools and a narrow purpose.

## Skills vs. Subagents

**Skills** define what Claude should do when you invoke a slash command. They
run in the main conversation with full tool access.

**Subagents** are specialized agents that run in isolation with their own tool
restrictions and instructions. Think of them as team members with specific
roles — a code reviewer who can only read (never edit), a documentation writer,
or a security auditor.

The key differences:

| Feature | Skill | Subagent |
|---|---|---|
| Location | `.claude/skills/{name}/SKILL.md` | `.claude/agents/{name}.md` |
| Invoked by | Slash command (`/skill-name`) | Claude spawns them as needed |
| Tools | Uses main conversation tools | Has its own restricted tool set |
| Purpose | Define a workflow | Delegate a focused task |

## Subagent File Format

Subagents are markdown files in `.claude/agents/` with YAML frontmatter for
configuration and a markdown body for instructions:

```markdown
---
name: agent-name
description: What this agent does
tools: Tool1, Tool2, Tool3
---

Instructions for the agent go here...
```

### Key Frontmatter Fields

- **`name`** — unique identifier for the agent (kebab-case)
- **`description`** — what the agent does (shown when listing agents)
- **`tools`** — comma-separated list of allowed tools (this is the key
  constraint — you control exactly what the agent can and cannot do)
- **`model`** — (optional) which model the agent should use

### Why Tool Restrictions Matter

A code reviewer should never modify files — it should only read and report.
By restricting tools to `Read, Grep, Glob, Bash`, you ensure the agent can
explore and analyze code but cannot change anything. This makes it safe to
run autonomously.

## Your Task

Create a **code review subagent** at `.claude/agents/code-reviewer.md` that
reviews code for quality issues. The workspace has several source files with
intentional problems — your agent definition should describe how to find and
report them.

Your subagent needs:

### 1. Proper frontmatter

- `name: code-reviewer`
- A meaningful `description` (what does this agent do?)
- `tools:` restricted to **read-only** tools: `Read, Grep, Glob, Bash`
  (no `Edit` or `Write` — a reviewer reads, it does not modify)

### 2. Review checklist (at least 4 criteria)

Include a review checklist in the body with at least 4 things to check:

- **Error handling** — are errors caught and handled properly?
- **Naming conventions** — are variables and functions named clearly?
- **Code duplication** — is there repeated logic that should be extracted?
- **Security** — are there hardcoded secrets, missing input validation, or
  unsafe operations?

### 3. Structured feedback format

Instruct the agent to organize its findings by priority:

- **Critical** — must fix before shipping (security issues, crashes)
- **Warnings** — should fix soon (missing error handling, poor patterns)
- **Suggestions** — nice to have (naming improvements, style tweaks)

## Getting Started

First, navigate to the exercise workspace:

```bash
cd ~/.cclab/workspace/wf-005/
```

Take a look at the existing files to understand the project:

- **`src/api/handlers.ts`** — an API handler with no error handling
- **`src/utils/logger.ts`** — a logging utility
- **`src/app.ts`** — main application entry point
- **`CLAUDE.md`** — project description
- **`.claude/agents/`** — empty directory where your agent goes

Browse the source files to see what quality issues exist. Then create your
subagent definition. You can create the file in several ways:

- **Inside Claude Code** — ask Claude to create the agent file for you
- **Open in VS Code** — run `code ~/.cclab/workspace/wf-005/` in your
  terminal, then create the file directly
- **From the terminal** — use any editor you like:
  ```bash
  nano .claude/agents/code-reviewer.md
  # or
  vim .claude/agents/code-reviewer.md
  ```

## Requirements

- `.claude/agents/code-reviewer.md` exists
- Has `name:` in YAML frontmatter
- Has `description:` in YAML frontmatter
- Has `tools:` in YAML frontmatter (tool restrictions)
- Mentions read-only tools (`Read` or `Grep`)
- Does NOT include `Edit` or `Write` in the tools line (read-only agent)
- Mentions "review" or "check" (review instructions present)
- At least 15 lines long

## Tips

- Look at the source files first — seeing real quality issues helps you
  write a better review checklist
- The `tools:` field is a comma-separated list, not an array — write it
  as `tools: Read, Grep, Glob, Bash`
- A good subagent definition is specific — "check for error handling" is
  better than "review the code"
- The `Bash` tool is included so the agent can run read-only commands like
  `wc -l` or `cat` — it cannot modify files with just Bash

## When You're Done

Run `/cclab:check` to validate your work.
