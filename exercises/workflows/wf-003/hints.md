# Hints for wf-003: Command Crafter

## Hint 1

A skill is a markdown file called SKILL.md that lives inside a folder under
`.claude/skills/`. The folder name becomes the command name. For this exercise,
you need to create `.claude/skills/explain-code/SKILL.md` in the workspace.
Start with YAML frontmatter between `---` delimiters at the very top of the file.

## Hint 2

Your SKILL.md needs two parts. First, frontmatter between `---` lines with
`name: explain-code` and a `description:` field. Then, below the closing `---`,
write markdown instructions with numbered steps (1., 2., 3.) telling Claude how
to read and explain code. Make sure the file is at least 10 lines total.

## Hint 3

Create the file at `.claude/skills/explain-code/SKILL.md` with content like:

```
---
name: explain-code
description: Read a code file and explain it in plain English
---

# Explain Code

1. Read the file specified by the user
2. Identify the main structures (functions, classes, imports, types)
3. Write a clear, plain-English explanation covering:
   - What the code does overall
   - How the key functions work
   - Any important patterns or dependencies
```

Make sure you have at least 10 lines. Add more detail to the steps if needed.
