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
