#!/usr/bin/env bash
# Validation for wf-001: Hook Line
# Checks: .claude/settings.json has hook config AND scripts/log-edits.sh exists and is executable

WORKSPACE="$HOME/.cclab/workspace/wf-001"
PASS=true

# --- .claude/settings.json checks ---

# Check 1: settings.json exists
if [ ! -f "$WORKSPACE/.claude/settings.json" ]; then
  echo "FAIL: .claude/settings.json not found in workspace"
  echo "  Create a .claude/settings.json with your hook configuration."
  exit 1
fi

# Check 2: settings.json contains "hooks" key
if ! grep -q '"hooks"' "$WORKSPACE/.claude/settings.json"; then
  echo "FAIL: .claude/settings.json missing \"hooks\" configuration"
  echo "  Add a \"hooks\" object to your settings.json."
  PASS=false
fi

# Check 3: settings.json contains a valid event name (PostToolUse or PreToolUse)
if ! grep -qE '"(PostToolUse|PreToolUse)"' "$WORKSPACE/.claude/settings.json"; then
  echo "FAIL: .claude/settings.json missing a hook event (PostToolUse or PreToolUse)"
  echo "  Add a hook event like \"PostToolUse\" inside your hooks config."
  PASS=false
fi

# Check 4: settings.json contains "matcher"
if ! grep -q '"matcher"' "$WORKSPACE/.claude/settings.json"; then
  echo "FAIL: .claude/settings.json missing \"matcher\" field"
  echo "  Each hook event needs a matcher to specify which tools to target."
  PASS=false
fi

# Check 5: settings.json contains "command"
if ! grep -q '"command"' "$WORKSPACE/.claude/settings.json"; then
  echo "FAIL: .claude/settings.json missing \"command\" field"
  echo "  Each hook needs a \"command\" specifying what script to run."
  PASS=false
fi

# --- scripts/log-edits.sh checks ---

# Check 6: log-edits.sh exists
if [ ! -f "$WORKSPACE/scripts/log-edits.sh" ]; then
  echo "FAIL: scripts/log-edits.sh not found"
  echo "  Create a hook script at scripts/log-edits.sh."
  PASS=false
else
  # Check 7: log-edits.sh contains exit handling
  if ! grep -qE "exit( 0)?" "$WORKSPACE/scripts/log-edits.sh"; then
    echo "FAIL: scripts/log-edits.sh missing exit handling"
    echo "  Add 'exit 0' to your script so the hook allows the action to proceed."
    PASS=false
  fi

  # Check 8: log-edits.sh is executable
  if [ ! -x "$WORKSPACE/scripts/log-edits.sh" ]; then
    echo "FAIL: scripts/log-edits.sh is not executable"
    echo "  Run: chmod +x scripts/log-edits.sh"
    PASS=false
  fi
fi

if [ "$PASS" = true ]; then
  echo "All checks passed!"
  exit 0
else
  exit 1
fi
