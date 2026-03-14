# Hints for wf-004: Skill Surgeon

## Hint 1

Skills can accept arguments -- when a user types `/refactor src/app.ts`,
the `src/app.ts` part is available as `$ARGUMENTS` (full argument string)
or `$0` (first argument) inside your SKILL.md. Add `argument-hint:` to your
frontmatter so users know what to type. Create your skill at
`.claude/skills/refactor/SKILL.md`.

## Hint 2

Create `.claude/skills/refactor/SKILL.md` with frontmatter containing:
`name: refactor`, `description:` (what it does), `argument-hint: <file-path>`,
and `disable-model-invocation: true`. In the body, reference `$ARGUMENTS`
or `$0` for the file path. Include 4+ numbered steps: read the file,
analyze for issues, propose a plan, then apply changes.

## Hint 3

Create `.claude/skills/refactor/SKILL.md`:

```
---
name: refactor
description: Refactor a file for better code quality
argument-hint: <file-path>
disable-model-invocation: true
---

# Refactor

Refactor the file at `$ARGUMENTS` following the project's code conventions.

1. Read the target file and understand its current structure
2. Analyze for code smells, duplication, and improvement opportunities
3. Propose a refactoring plan and explain the changes
4. Apply the refactoring changes after user confirms

Follow the code style rules in CLAUDE.md when making changes.
```

Add more detail to each step to reach 15+ lines.
