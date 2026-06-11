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

# Extract the deny and allow array blocks so placement checks are scoped
# (a deny rule for .env must live in deny, not allow)
DENY_BLOCK=$(sed -n '/"deny"/,/\]/p' "$SETTINGS")
ALLOW_BLOCK=$(sed -n '/"allow"/,/\]/p' "$SETTINGS")

# Check 5: the DENY rules mention .env or secrets (sensitive file protection)
if ! printf '%s' "$DENY_BLOCK" | grep -qiE '(\.env|secrets)'; then
  echo "FAIL: the deny rules don't protect sensitive files"
  echo "  Add deny rules for .env and/or secrets/ files (e.g., \"Edit(.env)\", \"Edit(/secrets/**)\")."
  echo "  Note: these must be inside the \"deny\" array — allowing them does the opposite!"
  PASS=false
fi

# Check 6: the deny rules use tool-specific patterns (Tool or Tool(specifier))
if ! printf '%s' "$DENY_BLOCK" | grep -qE '"(Bash|Read|Edit|Write|Glob|Grep|WebFetch)'; then
  echo "FAIL: deny rules don't use tool-specific patterns"
  echo "  Deny entries must name a tool, e.g. \"Edit(.env)\" or \"Bash(rm -rf *)\" — a bare path has no effect."
  PASS=false
fi

# Check 6b: at least 3 allow rules and 2 deny rules (as the instructions require)
ALLOW_COUNT=$(printf '%s' "$ALLOW_BLOCK" | grep -oE '"[A-Z][A-Za-z]*(\([^)]*\))?"' | wc -l | tr -d ' ')
if [ "$ALLOW_COUNT" -lt 3 ]; then
  echo "FAIL: only $ALLOW_COUNT allow rule(s) found (need at least 3)"
  echo "  Add more allow rules, e.g. \"Read\", \"Grep\", \"Bash(npm *)\"."
  PASS=false
fi
DENY_COUNT=$(printf '%s' "$DENY_BLOCK" | grep -oE '"[A-Z][A-Za-z]*(\([^)]*\))?"' | wc -l | tr -d ' ')
if [ "$DENY_COUNT" -lt 2 ]; then
  echo "FAIL: only $DENY_COUNT deny rule(s) found (need at least 2)"
  echo "  Add more deny rules, e.g. \"Edit(.env)\", \"Bash(rm -rf *)\"."
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
