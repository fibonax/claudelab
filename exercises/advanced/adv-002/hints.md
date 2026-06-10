# Hints for adv-002: Iron Gate

## Hint 1

Two pieces: a script and its wiring. The wiring is `.claude/settings.json`
with a `PreToolUse` event (not `PostToolUse` — you need to run *before*
the command), a `"matcher"` of `"Bash"`, and a `"command"` pointing at
`./scripts/guard.sh`. The script reads the event JSON from **stdin** —
not from environment variables — and its exit code is the verdict:
`0` allows, `2` blocks. Don't forget `chmod +x scripts/guard.sh`.

## Hint 2

In `guard.sh`, capture all of stdin with `input="$(cat)"`, then pull the
command string out of the `tool_input` JSON with a `sed` capture:
`cmd="$(printf '%s' "$input" | sed -n 's/.*"command"[[:space:]]*:[[:space:]]*"\(.*\)".*/\1/p')"`.
Match dangerous patterns with a `case` statement covering both `rm -rf /`
and `rm -rf ~`. On a match: print a message to stderr (`>&2`) and `exit 2`.
Otherwise `exit 0`. Test by writing a payload JSON to a file and running
`./scripts/guard.sh < payload.json; echo $?` — don't pipe strings into sh.

## Hint 3

Create `.claude/settings.json`:

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

Then create `scripts/guard.sh`:

```bash
#!/usr/bin/env bash
input="$(cat)"
cmd="$(printf '%s' "$input" | sed -n 's/.*"command"[[:space:]]*:[[:space:]]*"\(.*\)".*/\1/p')"

case "$cmd" in
  *"rm -rf /"*|*"rm -rf ~"*)
    echo "Blocked dangerous command: $cmd" >&2
    exit 2
    ;;
esac

exit 0
```

Make it executable: `chmod +x scripts/guard.sh`. Verify with a payload file:

```bash
cat > /tmp/p.json << 'EOF'
{"hook_event_name":"PreToolUse","tool_name":"Bash","tool_input":{"command":"rm -rf /"}}
EOF
./scripts/guard.sh < /tmp/p.json; echo "exit: $?"   # expect: exit: 2
```
