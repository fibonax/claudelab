# Command Crafter

Claude Code's slash commands aren't hard-coded -- they come from **SKILL.md**
files. Every skill is just a markdown file with YAML frontmatter at the top and
instructions in the body. When Claude Code discovers a SKILL.md, it registers
the skill as a slash command you can invoke.

This means you can create your own commands. Want a `/explain-code` command that
reads a file and explains it in plain English? Just write a SKILL.md for it.

## How Skills Work

A skill lives in a file called `SKILL.md` inside a folder under
`.claude/skills/`. The folder name becomes the command name:

```
.claude/skills/
  explain-code/
    SKILL.md        <-- this creates the /explain-code command
  refactor/
    SKILL.md        <-- this creates the /refactor command
```

### SKILL.md Structure

Every SKILL.md has two parts:

1. **Frontmatter** -- YAML metadata between `---` delimiters at the very top
2. **Body** -- Markdown instructions that tell Claude what to do

Here's the anatomy of a SKILL.md:

```markdown
---
name: my-command
description: A short description of what this command does
---

# My Command

Instructions for Claude go here. Be specific about:

1. What inputs to expect
2. What steps to follow
3. What output to produce
```

The `name` field is the command identifier. The `description` field appears in
help text. The body contains the actual instructions Claude follows when the
command is invoked.

## Your Task

This workspace has a small TypeScript project with source files. Your job is to
create a custom skill called **explain-code** that tells Claude how to read a
code file and explain it in plain English.

Create the skill at `.claude/skills/explain-code/SKILL.md` with:

1. **Frontmatter** with `name: explain-code` and a `description:` field
2. **A title heading** (e.g., `# Explain Code`)
3. **Numbered steps** (at least 3) telling Claude how to:
   - Read the specified file
   - Analyze the code structure (functions, imports, types)
   - Write a clear, plain-English explanation
4. **At least 10 lines total** in the file

## Getting Started

First, navigate to the exercise workspace:

```bash
cd ~/.cclab/workspace/wf-003/
```

Take a look at the existing files to understand the project context:

- **`src/index.ts`** and **`src/utils.ts`** -- sample source code
- **`package.json`** -- project configuration
- **`CLAUDE.md`** -- project documentation
- **`.claude/skills/`** -- empty directory where your skill goes

You can create the SKILL.md file in several ways:

- **Inside Claude Code** -- ask Claude to create the file for you
- **Open in VS Code** -- run `code ~/.cclab/workspace/wf-003/` in your terminal
- **From the terminal** -- use any editor:
  ```bash
  mkdir -p ~/.cclab/workspace/wf-003/.claude/skills/explain-code
  nano ~/.cclab/workspace/wf-003/.claude/skills/explain-code/SKILL.md
  ```

## Requirements

- File exists at `.claude/skills/explain-code/SKILL.md`
- Frontmatter contains `name:` field
- Frontmatter contains `description:` field
- Frontmatter has `---` delimiters (opening and closing)
- Body contains at least 3 numbered steps
- File is at least 10 lines long

## Tips

- Keep your instructions specific -- "Read the file the user specifies" is
  better than "Look at some code"
- Think about what makes a good explanation: structure, purpose, key concepts
- You can test your skill by invoking `/explain-code` after creating it
  (in a real Claude Code project)

## When You're Done

Run `/cclab:check` to validate your work.
