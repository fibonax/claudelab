#!/bin/sh
# cclab PostToolUse hook — logs tool usage into the active exercise workspace.
#
# Receives hook event JSON on stdin (fields: tool_name, tool_input, cwd, ...).
# Appends one JSON line per tool call to:
#   ~/.cclab/workspace/<exercise-id>/.tool_log.jsonl
#
# Logging only happens when the tool call touches an exercise workspace:
#   1. the tool input references ~/.cclab/workspace/cc-NNN, or
#   2. the session cwd is inside ~/.cclab/workspace/cc-NNN
# Everything else is ignored, so no tool usage outside cclab is ever recorded.
#
# POSIX shell + grep/sed only — no jq, python, or node (cclab convention).
# Always exits 0: a logging failure must never block or distort a session.

PAYLOAD=$(cat)
WORKSPACE_ROOT="$HOME/.cclab/workspace"

# Resolve the target exercise: prefer a workspace path mentioned in the
# payload (file_path, command, etc.), fall back to the session cwd.
EXERCISE=$(printf '%s' "$PAYLOAD" \
  | grep -o '\.cclab/workspace/[a-z]\{2,\}-[0-9]\{3\}' \
  | head -n 1 \
  | sed 's|.*/||')

if [ -z "$EXERCISE" ]; then
  CWD=$(printf '%s' "$PAYLOAD" \
    | sed -n 's/.*"cwd"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' \
    | head -n 1)
  case "$CWD" in
    "$WORKSPACE_ROOT"/*)
      EXERCISE=$(printf '%s' "$CWD" \
        | sed "s|^$WORKSPACE_ROOT/||" \
        | cut -d/ -f1)
      ;;
  esac
fi

[ -n "$EXERCISE" ] || exit 0
[ -d "$WORKSPACE_ROOT/$EXERCISE" ] || exit 0

TOOL=$(printf '%s' "$PAYLOAD" \
  | sed -n 's/.*"tool_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' \
  | head -n 1)
[ -n "$TOOL" ] || exit 0

TS=$(date -u +%Y-%m-%dT%H:%M:%SZ)

printf '{"tool":"%s","ts":"%s"}\n' "$TOOL" "$TS" \
  >> "$WORKSPACE_ROOT/$EXERCISE/.tool_log.jsonl" 2>/dev/null

exit 0
