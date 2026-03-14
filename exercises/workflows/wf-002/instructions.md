# Guard Rails

In the previous exercise, you created a hook configuration in `.claude/settings.json`.
But hooks are just one piece of the puzzle. Claude Code also has a **permission
model** that controls what tools Claude can use and what files it can access.

Think about it: your project has source code, but it also has secrets -- `.env`
files with database passwords, API key files, deployment credentials. You want
Claude to read and edit your source code freely, but you definitely don't want
it editing your `.env` file or deleting files.

That's where permissions come in. You configure **allow** and **deny** rules in
`.claude/settings.json` to control exactly what Claude can and cannot do.

## Your Task

This workspace has a project with both regular source files and sensitive files.
Your job is to create a `.claude/settings.json` with permission rules that:

- **Allow** Claude to do common development tasks freely (read files, run npm
  commands, search code)
- **Deny** Claude from touching sensitive files or running destructive commands

### Permission Levels

Claude Code has three permission levels:

1. **allow** -- the tool runs automatically, no confirmation needed
2. **deny** -- the tool is blocked entirely, Claude cannot use it
3. **ask** -- Claude asks the user for permission each time (this is the default)

### Tool Pattern Syntax

Permission rules use a `Tool(specifier)` pattern:

- `"Read"` -- matches all Read operations
- `"Bash(npm *)"` -- matches Bash commands starting with `npm`
- `"Edit(.env)"` -- matches editing the `.env` file
- `"Edit(/secrets/**)"` -- matches editing any file under `secrets/`
- `"Bash(rm *)"` -- matches any `rm` command

### What to Create

Create `.claude/settings.json` with a `"permissions"` object containing:

- An `"allow"` array with at least 3 rules for safe development tools
- A `"deny"` array with at least 2 rules protecting sensitive files or blocking
  dangerous commands

## Getting Started

First, navigate to the exercise workspace:

```bash
cd ~/.cclab/workspace/wf-002/
```

Take a look at the existing files to understand what you're working with:

- **`src/app.ts`** -- main application code
- **`src/db.ts`** -- database connection module
- **`.env`** -- environment variables with credentials (DO NOT edit this!)
- **`secrets/api-keys.json`** -- API keys (DO NOT edit this!)
- **`CLAUDE.md`** -- project description
- **`.claude/`** -- exists but empty, no settings.json yet

Think about which files Claude should freely access, and which it should never
touch. Then create `.claude/settings.json` with your rules.

You can create the file in several ways:

- **Inside Claude Code** -- ask Claude to create the settings file for you
- **Open in VS Code** -- run `code ~/.cclab/workspace/wf-002/` in your terminal
- **From the terminal** -- use any editor you like:
  ```bash
  nano ~/.cclab/workspace/wf-002/.claude/settings.json
  ```

## Requirements

- `.claude/settings.json` must exist
- It must contain a `"permissions"` object
- It must have an `"allow"` array (at least 3 rules)
- It must have a `"deny"` array (at least 2 rules)
- It must protect sensitive files (mention `.env` or `secrets`)
- It must include tool-specific rules (mention `Bash`, `Read`, or `Edit`)
- It must be valid JSON

## Tips

- Start with what Claude should be allowed to do freely: reading files, running
  tests, searching code. Then think about what it should never do: editing
  secrets, deleting files.
- Use specific patterns for deny rules -- `"Edit(.env)"` is better than
  blocking all edits.
- Remember: anything not explicitly allowed or denied defaults to **ask** mode,
  which means Claude will prompt you before proceeding.

## When You're Done

Run `/cclab:check` to validate your work.
