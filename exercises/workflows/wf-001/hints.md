# Hints for wf-001: Hook Line

## Hint 1

Hooks live in `.claude/settings.json` under the `"hooks"` key. Each hook
event (like `PostToolUse`) contains an array of matchers, and each matcher
specifies which tools to match and what command to run. You also need a
shell script at `scripts/log-edits.sh` that the hook will execute — don't
forget to make it executable.

## Hint 2

Create `.claude/settings.json` with this structure:
`{"hooks": {"PostToolUse": [{"matcher": "...", "hooks": [{"type": "command", "command": "..."}]}]}}`.
The matcher is a regex matching tool names like `"Write|Edit"`. Also create
`scripts/log-edits.sh` that reads stdin and logs a message to a file. Make
sure the script has `exit 0` and is executable (`chmod +x`).

## Hint 3

Create `.claude/settings.json`:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "./scripts/log-edits.sh"
          }
        ]
      }
    ]
  }
}
```

Then create `scripts/log-edits.sh`:

```bash
#!/bin/bash
read -r input
echo "$(date): edit logged" >> edit-log.txt
exit 0
```

Make it executable: `chmod +x scripts/log-edits.sh`.
