# Convention Enforcer

In the previous exercise, you created a CLAUDE.md that describes your project.
But CLAUDE.md isn't just documentation — it's an **instruction set**. When you
write directives like "always use ES modules" or "never use var", Claude will
follow those rules when writing or fixing code.

This is one of the most powerful features of CLAUDE.md: you can enforce your
team's code conventions automatically, just by writing them down.

## Your Task

This workspace has a small utility library, but the code is written in an
outdated style — it uses CommonJS `require()` instead of ES module `import`,
and `var` instead of `const`/`let`. The project's `package.json` already
specifies `"type": "module"`, so these patterns need to be fixed.

There's already a CLAUDE.md with a project description, but it has **no code
style rules**. You need to:

### Part 1: Update CLAUDE.md

Add a `## Code Style` section to the existing CLAUDE.md with at least these
rules:

1. Use ES modules (`import`/`export`), never CommonJS (`require`)
2. Use `const` by default, `let` when mutation is needed, never `var`
3. Use TypeScript strict mode

### Part 2: Fix the code

After updating CLAUDE.md, ask Claude to fix `src/utils.ts` to follow your
new conventions. All `require()` calls should become `import` statements,
and all `var` declarations should become `const` or `let`.

## Getting Started

First, navigate to the exercise workspace:

```bash
cd ~/.cclab/workspace/cc-003/
```

Take a look at the existing files to understand the starting point:

- **`CLAUDE.md`** — already has a project description, but no code style rules
- **`src/utils.ts`** — the code that needs fixing (look at the patterns used)
- **`package.json`** and **`tsconfig.json`** — project configuration

Start by reading `src/utils.ts` to see what bad patterns are in use. Then
open `CLAUDE.md` to see what's already there. You can do this in several ways:

- **Inside Claude Code** — ask Claude to read the files for you, then ask it
  to edit `CLAUDE.md` to add your code style rules
- **Open in VS Code** — run `code ~/.cclab/workspace/cc-003/` in your terminal,
  then edit `CLAUDE.md` directly
- **From the terminal** — use any editor you like:
  ```bash
  nano ~/.cclab/workspace/cc-003/CLAUDE.md
  # or
  vim ~/.cclab/workspace/cc-003/CLAUDE.md
  ```

Once you've updated `CLAUDE.md` with your rules, move on to Part 2 and ask
Claude to fix the code.

## Requirements

- CLAUDE.md must have a section with "Code Style" or "Conventions" in the heading
- CLAUDE.md must mention `import` or "ES module"
- CLAUDE.md must mention `const` or `var` (as part of a variable declaration rule)
- `src/utils.ts` must NOT contain any `require(` calls
- `src/utils.ts` must NOT contain any `var ` declarations

## Tips

- Write the rules first, then ask Claude to fix the code — Claude reads
  CLAUDE.md at the start of a session, so your rules inform its work
- Be specific in your rules — "use const by default" is better than
  "use modern syntax"

## When You're Done

Run `/cclab:check` to validate your work.
