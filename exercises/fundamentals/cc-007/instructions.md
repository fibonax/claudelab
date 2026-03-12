# Command Center

Claude Code has a set of built-in slash commands — shortcuts you type directly
into the prompt that control the tool itself. Some manage your conversation,
others help you set up projects, and a few are essential for daily use.

Most users only discover a handful of commands by accident. In this exercise
you'll systematically explore what's available and document the most useful ones.

## Your Task

**Step 1 — Discover available commands**

Type `/help` in Claude Code to see the list of built-in slash commands. Read
through what's available.

**Step 2 — Document your findings**

Create a file called `commands.md` in the workspace. List at least **5 slash
commands**, each on its own line starting with `/`, followed by a short
description of what it does.

For example:
```
/help - Shows available commands and usage information
```

**Step 3 — Include the essentials**

Make sure your list includes at least:
- `/help` — the command you just used to discover the others
- `/compact` or `/clear` — conversation management commands

You're free to include any other commands you find interesting or useful.

## Getting Started

First, navigate to the exercise workspace:

```bash
cd ~/.cclab/workspace/cc-007/
```

Take a look at the project files (`CLAUDE.md`, `src/index.ts`, `src/search.ts`)
to get familiar with the workspace.

**Discover commands** — in Claude Code, type `/` and see what appears, or type
`/help` to get a full list. Read through what's available and pick the ones
you find most useful.

**Create your documentation** — once you've explored the commands, create a
file called `commands.md` in the workspace root. You can do this in several
ways:

- **Inside Claude Code** — ask Claude to create the file, or use the
  Write tool directly
- **Open in VS Code** — run `code ~/.cclab/workspace/cc-007/` in your terminal,
  then create a new file named `commands.md` in the project root
- **From the terminal** — use any editor you like:
  ```bash
  nano ~/.cclab/workspace/cc-007/commands.md
  # or
  vim ~/.cclab/workspace/cc-007/commands.md
  ```

## Requirements

- File must be called `commands.md` (in the workspace root)
- At least 5 lines starting with `/` (one command per line)
- Must mention `/help`
- Must mention `/compact` or `/clear`
- At least 8 total lines in the file

## Tips

- Try typing `/` in Claude Code and see what auto-completes
- Some commands accept arguments — note that in your descriptions
- Think about which commands you'd use most often in a real workflow

## When You're Done

Run `/cclab:check` to validate your work.
