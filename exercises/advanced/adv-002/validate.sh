#!/usr/bin/env bash
# Validation for adv-002: Iron Gate
# Checks: .claude/settings.json wires a PreToolUse hook for Bash, AND
# scripts/guard.sh behaves correctly when fed real hook payloads on stdin:
# exit 2 for dangerous commands, exit 0 for safe ones.

WORKSPACE="$HOME/.cclab/workspace/adv-002"
SETTINGS="$WORKSPACE/.claude/settings.json"
GUARD="$WORKSPACE/scripts/guard.sh"
PASS=true

# --- .claude/settings.json checks ---

# Check 1: settings.json exists
if [ ! -f "$SETTINGS" ]; then
  echo "FAIL: .claude/settings.json not found in workspace"
  echo "  Create .claude/settings.json with your PreToolUse hook configuration."
  exit 1
fi

# Check 2: settings.json contains "PreToolUse"
if ! grep -q '"PreToolUse"' "$SETTINGS"; then
  echo "FAIL: .claude/settings.json missing \"PreToolUse\" hook event"
  echo "  A blocking gate must run BEFORE the tool — use the PreToolUse event."
  PASS=false
fi

# Check 3: settings.json has a matcher targeting Bash
if ! grep -q '"matcher"' "$SETTINGS" || ! grep -q 'Bash' "$SETTINGS"; then
  echo "FAIL: .claude/settings.json missing a \"matcher\" targeting Bash"
  echo "  Add \"matcher\": \"Bash\" so the hook fires on Bash tool calls."
  PASS=false
fi

# Check 4: settings.json contains "command"
if ! grep -q '"command"' "$SETTINGS"; then
  echo "FAIL: .claude/settings.json missing \"command\" field"
  echo "  The hook needs a \"command\" pointing at ./scripts/guard.sh."
  PASS=false
fi

# --- scripts/guard.sh existence checks ---

# Check 5: guard.sh exists
if [ ! -f "$GUARD" ]; then
  echo "FAIL: scripts/guard.sh not found"
  echo "  Create the guard script at scripts/guard.sh."
  exit 1
fi

# Check 6: guard.sh is executable
if [ ! -x "$GUARD" ]; then
  echo "FAIL: scripts/guard.sh is not executable"
  echo "  Run: chmod +x scripts/guard.sh"
  exit 1
fi

# --- behavioral checks: run the learner's hook against real payloads ---

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

cat > "$TMP_DIR/danger-root.json" << 'EOF'
{"session_id":"cclab-validate","cwd":"/tmp","hook_event_name":"PreToolUse","tool_name":"Bash","tool_input":{"command":"rm -rf /"}}
EOF

cat > "$TMP_DIR/danger-home.json" << 'EOF'
{"session_id":"cclab-validate","cwd":"/tmp","hook_event_name":"PreToolUse","tool_name":"Bash","tool_input":{"command":"rm -rf ~"}}
EOF

cat > "$TMP_DIR/safe-ls.json" << 'EOF'
{"session_id":"cclab-validate","cwd":"/tmp","hook_event_name":"PreToolUse","tool_name":"Bash","tool_input":{"command":"ls -la"}}
EOF

# Check 7: dangerous payload (rm -rf /) must be blocked with exit 2
"$GUARD" < "$TMP_DIR/danger-root.json" > /dev/null 2>&1
RC=$?
if [ "$RC" -ne 2 ]; then
  echo "FAIL: guard.sh did not block 'rm -rf /' (exited $RC, expected 2)"
  echo "  Exit code 2 is what tells Claude Code to cancel the tool call."
  echo "  Extract the command from tool_input and exit 2 when it matches."
  PASS=false
fi

# Check 8: dangerous payload (rm -rf ~) must be blocked with exit 2
"$GUARD" < "$TMP_DIR/danger-home.json" > /dev/null 2>&1
RC=$?
if [ "$RC" -ne 2 ]; then
  echo "FAIL: guard.sh did not block 'rm -rf ~' (exited $RC, expected 2)"
  echo "  Your dangerous-pattern match must also cover rm -rf aimed at ~."
  PASS=false
fi

# Check 9: safe payload (ls -la) must be allowed with exit 0
"$GUARD" < "$TMP_DIR/safe-ls.json" > /dev/null 2>&1
RC=$?
if [ "$RC" -ne 0 ]; then
  echo "FAIL: guard.sh blocked the safe command 'ls -la' (exited $RC, expected 0)"
  echo "  A gate that blocks everything is useless — exit 0 for safe commands."
  PASS=false
fi

if [ "$PASS" = true ]; then
  echo "All checks passed!"
  exit 0
else
  exit 1
fi
