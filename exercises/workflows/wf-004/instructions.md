# Skill Surgeon

In the previous exercise you created a basic skill with frontmatter and
instructions. But real-world skills often need more: they accept arguments
from the user, restrict when they can be invoked, and provide structured
multi-step workflows.

This exercise teaches you how to build a **production-grade skill** with
argument handling, advanced frontmatter, and a structured refactoring
workflow.

## How Skill Arguments Work

When a user invokes a skill with extra text, that text becomes available
inside the SKILL.md through variable substitution:

| Variable | What it contains | Example input | Value |
|---|---|---|---|
| `$ARGUMENTS` | The full argument string | `/refactor src/app.ts --deep` | `src/app.ts --deep` |
| `$0` | The first argument | `/refactor src/app.ts --deep` | `src/app.ts` |
| `$1` | The second argument | `/refactor src/app.ts --deep` | `--deep` |

You reference these in your SKILL.md body just like shell variables:

```
Read the file at `$ARGUMENTS` and analyze it.
```

## Argument Hints

The `argument-hint:` frontmatter field tells users what arguments your skill
expects. It appears in the autocomplete dropdown:

```yaml
---
name: refactor
description: Refactor a file for better code quality
argument-hint: <file-path>
---
```

When the user types `/refactor`, they'll see `<file-path>` as a hint for
what to type next.

## Disabling Model Invocation

Some skills should only run when a user explicitly types the slash command
-- they should never be triggered automatically by the model. The
`disable-model-invocation: true` frontmatter field enforces this:

```yaml
---
name: refactor
disable-model-invocation: true
---
```

This is useful for skills that perform destructive operations, make
significant changes, or need human judgment about when to invoke.

## Your Task

Create a skill called `refactor` at `.claude/skills/refactor/SKILL.md` that
provides a structured refactoring workflow for any file in the project.

Your SKILL.md must include:

### Frontmatter (between `---` delimiters)

- `name:` with a value (e.g., `refactor`)
- `description:` explaining what the skill does
- `argument-hint: <file-path>` so users know to provide a file path
- `disable-model-invocation: true` to prevent automatic invocation

### Body (after the frontmatter)

- Reference `$ARGUMENTS` or `$0` to use the file path the user provides
- Include at least **4 numbered steps** for the refactoring workflow:
  1. Read the target file
  2. Analyze for code smells, duplication, and improvement opportunities
  3. Propose a refactoring plan to the user
  4. Apply the changes after user confirmation
- The file must be at least **15 lines** total

## Getting Started

First, navigate to the exercise workspace:

```bash
cd ~/.cclab/workspace/wf-004/
```

Take a look at the existing files to understand the project:

- **`src/`** -- several TypeScript source files with different patterns
- **`CLAUDE.md`** -- project description with code style conventions
- **`.claude/skills/`** -- empty skills directory (this is where you'll create your skill)

Look at the source files to understand what kind of code this skill would
refactor. Then create the skill. You can do this in several ways:

- **Inside Claude Code** -- ask Claude to create the SKILL.md for you
- **Open in VS Code** -- run `code ~/.cclab/workspace/wf-004/` in your
  terminal, then create the file directly
- **From the terminal** -- use any editor you like:
  ```bash
  mkdir -p .claude/skills/refactor
  nano .claude/skills/refactor/SKILL.md
  ```

## Requirements

- `.claude/skills/refactor/SKILL.md` exists
- Has `name:` with a value in frontmatter
- Has `description:` in frontmatter
- Uses `$ARGUMENTS` or `$0` to reference the file path argument
- Has `argument-hint:` in frontmatter
- Has `disable-model-invocation:` in frontmatter
- Contains at least 4 numbered steps
- Is at least 15 lines long

## Tips

- Keep each step focused on one action -- read, analyze, propose, apply
- You can add more than 4 steps if your workflow needs them (e.g., a step
  to check for tests, or to verify the refactoring didn't break anything)
- The `$ARGUMENTS` variable contains exactly what the user typed after the
  slash command -- no parsing needed for a single file path
- Consider mentioning the project's CLAUDE.md conventions in your skill
  instructions so refactored code follows the project's style

## When You're Done

Run `/cclab:check` to validate your work.
