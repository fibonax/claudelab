#!/usr/bin/env bash
# Validation for wf-002: Guard Rails
# Checks: settings.json exists, has permissions/allow/deny, protects sensitive
# files, includes tool patterns, and is valid JSON.

WORKSPACE="$HOME/.cclab/workspace/wf-002"
SETTINGS="$WORKSPACE/.claude/settings.json"
PASS=true

# Check 1: settings.json exists
if [ ! -f "$SETTINGS" ]; then
  echo "FAIL: .claude/settings.json not found in $WORKSPACE/"
  echo "  Create .claude/settings.json with your permission rules."
  exit 1
fi

# Check 2: contains "permissions"
if ! grep -q '"permissions"' "$SETTINGS"; then
  echo "FAIL: settings.json missing \"permissions\" configuration"
  echo "  Add a \"permissions\" object with \"allow\" and \"deny\" arrays."
  PASS=false
fi

# Check 3: contains "allow"
if ! grep -q '"allow"' "$SETTINGS"; then
  echo "FAIL: settings.json missing \"allow\" rules"
  echo "  Add an \"allow\" array with tools Claude can use freely (e.g., \"Read\", \"Grep\")."
  PASS=false
fi

# Check 4: contains "deny"
if ! grep -q '"deny"' "$SETTINGS"; then
  echo "FAIL: settings.json missing \"deny\" rules"
  echo "  Add a \"deny\" array with tools Claude should never use (e.g., \"Edit(.env)\")."
  PASS=false
fi

# Check 5: mentions .env or secrets (sensitive file protection)
if ! grep -qiE '(\.env|secrets)' "$SETTINGS"; then
  echo "FAIL: settings.json doesn't protect sensitive files"
  echo "  Add deny rules for .env and/or secrets/ files (e.g., \"Edit(.env)\", \"Edit(/secrets/**)\")."
  PASS=false
fi

# Check 6: mentions Bash, Read, or Edit (tool-specific rules)
if ! grep -qE '(Bash|Read|Edit)' "$SETTINGS"; then
  echo "FAIL: settings.json doesn't include tool-specific rules"
  echo "  Use tool patterns like \"Read\", \"Bash(npm *)\", or \"Edit(.env)\" in your rules."
  PASS=false
fi

# Check 7: valid JSON
if command -v python3 &>/dev/null; then
  if ! python3 -c "import json; json.load(open('$SETTINGS'))" 2>/dev/null; then
    echo "FAIL: settings.json is not valid JSON"
    echo "  Check for missing commas, brackets, or quotes. Use a JSON validator to find errors."
    PASS=false
  fi
else
  # Fallback: basic structure check (opening/closing braces)
  if ! grep -q '^{' "$SETTINGS" || ! grep -q '}' "$SETTINGS"; then
    echo "FAIL: settings.json doesn't appear to be valid JSON"
    echo "  Make sure it starts with { and ends with }."
    PASS=false
  fi
fi

if [ "$PASS" = true ]; then
  echo "All checks passed!"
  exit 0
else
  exit 1
fi
