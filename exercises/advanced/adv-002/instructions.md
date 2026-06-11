# Iron Gate

In wf-001 you built a `PostToolUse` hook that *observed* — it logged edits
after they happened. This exercise teaches the other half of the hook
system: a **`PreToolUse` hook that can block a tool call before it runs**.

A blocking hook is a gate. Before Claude executes a Bash command, your
script gets a chance to inspect it and say "no". This is how teams enforce
real guardrails: no force-pushes, no `DROP TABLE`, no recursive deletes of
the filesystem root — regardless of what Claude (or a prompt injection)
tries to run.

## How Blocking Hooks Work

Two mechanics make this possible:

**1. Hooks receive the event as JSON on stdin** — not as environment
variables. For a Bash call, the payload looks like this:

```json
{
  "session_id": "abc123",
  "cwd": "/path/to/project",
  "hook_event_name": "PreToolUse",
  "tool_name": "Bash",
  "tool_input": {
    "command": "rm -rf /"
  }
}
```

Your script reads stdin, digs the command string out of `tool_input`, and
decides.

**2. The exit code is the verdict:**

| Exit code | Meaning |
|---|---|
| `0` | Allow — the tool call proceeds |
| `2` | **Block** — the tool call is cancelled; stderr is shown to Claude |
| other | Non-blocking error — the tool call still proceeds |

Exit 2 is special. Anything you print to **stderr** before exiting 2 is fed
back to Claude as the reason for the block, so Claude can explain itself or
choose a safer command.

## Your Task

The workspace contains a small maintenance CLI whose whole job is deleting
files — exactly the kind of project where one careless `rm -rf` ruins your
day. Build a gate that refuses catastrophic deletes.

### Part 1: Create the guard script

Create `scripts/guard.sh` that:

1. Reads the JSON event from **stdin** into a variable
2. Extracts the command string from `tool_input` (`grep`/`sed` is fine;
   `jq` works too if you have it)
3. If the command matches a dangerous pattern — `rm -rf` aimed at `/` or
   at `~` — prints a refusal message to **stderr** and exits `2`
4. Otherwise exits `0`

Make it executable: `chmod +x scripts/guard.sh`.

### Part 2: Wire it into settings

Create `.claude/settings.json` with a `PreToolUse` hook that runs your
guard for every Bash call:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "./scripts/guard.sh"
          }
        ]
      }
    ]
  }
}
```

## Getting Started

First, navigate to the exercise workspace:

```bash
cd ~/.cclab/workspace/adv-002/
```

Look around to understand the project:

- **`src/cleanup.ts`** — the deletion logic (the reason we want a gate)
- **`src/index.ts`** — CLI entry point
- **`CLAUDE.md`** — project description

There's no `.claude/` or `scripts/` directory yet — creating both is the
exercise.

## Requirements

- `.claude/settings.json` exists with a `PreToolUse` hook, a `"matcher"`
  targeting `Bash`, and a `"command"` pointing at your script
- `scripts/guard.sh` exists and is executable
- Fed a payload whose command is `rm -rf /`, the script exits `2`
- Fed a payload whose command is `rm -rf ~`, the script exits `2`
- Fed a payload whose command is `ls -la`, the script exits `0`

The check is **behavioral** — it actually runs your script against these
three payloads and inspects the exit codes. A script that merely looks
right won't pass.

## Tips

- Read all of stdin with `input="$(cat)"` — a bare `read` stops at the
  first newline and can miss data
- A `sed` capture like
  `sed -n 's/.*"command"[[:space:]]*:[[:space:]]*"\(.*\)".*/\1/p'`
  pulls the command string out of the JSON
- A `case` statement is a clean way to match patterns:
  `case "$cmd" in *"rm -rf /"*|*"rm -rf ~"*) ... ;; esac`
- Test it yourself the same way the validator does — write a payload to a
  file and redirect it in (don't pipe strings into `sh`):
  ```bash
  cat > /tmp/payload.json << 'EOF'
  {"hook_event_name":"PreToolUse","tool_name":"Bash","tool_input":{"command":"rm -rf /"}}
  EOF
  ./scripts/guard.sh < /tmp/payload.json; echo "exit: $?"
  ```
  You want `exit: 2` for the dangerous payloads and `exit: 0` for safe ones
- Remember which stream matters: the refusal message goes to **stderr**
  (`>&2`), because that's what Claude sees on a block

## When You're Done

Run `/cclab:check` to validate your work.
