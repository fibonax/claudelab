# Hook Line

Claude Code can run shell commands automatically at specific points in its
lifecycle — these are called **hooks**. When Claude reads a file, edits code,
or runs a command, hooks let you trigger your own scripts before or after
each action.

Hooks are one of the most powerful customization features in Claude Code.
You can use them to enforce lint rules, log activity, send notifications,
block dangerous operations, or auto-format code after every edit.

## How Hooks Work

Hooks are configured in `.claude/settings.json` under the `"hooks"` key.
Each hook is tied to an **event** — a specific point in Claude Code's lifecycle:

| Event | When it fires |
|---|---|
| `PreToolUse` | Before a tool runs (can block it) |
| `PostToolUse` | After a tool completes |
| `Notification` | When Claude sends a notification |
| `Stop` | When Claude finishes a turn |
| `SubagentStop` | When a subagent finishes |

Each event contains an array of **matchers**. A matcher specifies which tools
to match (using a regex pattern) and what command(s) to run. The hook command
receives JSON on stdin with details about the tool invocation.

## Your Task

### Part 1: Create the hook configuration

Create `.claude/settings.json` with a hook that fires after file edits.
Your configuration needs:

- A `"hooks"` object with a `"PostToolUse"` event
- A matcher that targets file-editing tools (`Write` and/or `Edit`)
- A command that runs your logging script

Here's the structure:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "<regex matching tool names>",
        "hooks": [
          {
            "type": "command",
            "command": "<path to your script>"
          }
        ]
      }
    ]
  }
}
```

### Part 2: Create the hook script

Create `scripts/log-edits.sh` — a shell script that logs file edit activity.
Your script should:

1. Read JSON input from stdin (it contains tool name and file details)
2. Append a log line to `edit-log.txt` (a simple message like a timestamp
   or "Edit logged" is fine)
3. Exit with code `0` (this tells Claude Code to proceed — a non-zero exit
   would block the action)

Make the script executable with `chmod +x scripts/log-edits.sh`.

## Getting Started

First, navigate to the exercise workspace:

```bash
cd ~/.cclab/workspace/wf-001/
```

Take a look at the existing files to understand the project:

- **`src/app.ts`** — a small TypeScript application
- **`src/utils.ts`** — utility functions
- **`package.json`** — project configuration
- **`CLAUDE.md`** — project description

Notice there's no `.claude/` directory yet — you'll create it as part of
this exercise. You can create the files in several ways:

- **Inside Claude Code** — ask Claude to create the settings.json and
  hook script for you
- **Open in VS Code** — run `code ~/.cclab/workspace/wf-001/` in your
  terminal, then create the files directly
- **From the terminal** — use any editor you like:
  ```bash
  mkdir -p .claude
  nano .claude/settings.json
  mkdir -p scripts
  nano scripts/log-edits.sh
  chmod +x scripts/log-edits.sh
  ```

## Requirements

- `.claude/settings.json` exists and contains a `"hooks"` configuration
- The hook uses a valid event name (`PostToolUse` or `PreToolUse`)
- The hook has a `"matcher"` to target specific tools
- The hook has a `"command"` to run
- `scripts/log-edits.sh` exists and is executable
- The script handles exit properly (exits with code 0)

## Tips

- The `"matcher"` field is a regex — `"Write|Edit"` matches both tool names
- Hook scripts receive JSON on stdin — you can read it with `read` or
  pipe it, but for this exercise just logging a message is enough
- Exit code matters: `exit 0` means "allow", non-zero means "block the action"
- You can test your script manually: `echo '{}' | ./scripts/log-edits.sh`

## When You're Done

Run `/cclab:check` to validate your work.
