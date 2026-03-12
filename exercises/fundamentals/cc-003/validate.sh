#!/usr/bin/env bash
# Validation for cc-003: Convention Enforcer
# Checks: CLAUDE.md has code style section AND utils.ts is fixed

WORKSPACE="$HOME/.cclab/workspace/cc-003"
PASS=true

# --- CLAUDE.md checks ---

# Check 1: CLAUDE.md exists
if [ ! -f "$WORKSPACE/CLAUDE.md" ]; then
  echo "FAIL: CLAUDE.md not found in $WORKSPACE/"
  echo "  The CLAUDE.md file should already exist — did you accidentally delete it?"
  exit 1
fi

# Check 2: CLAUDE.md has a Code Style or Conventions section
if ! grep -qiE "^##?.*(code style|conventions)" "$WORKSPACE/CLAUDE.md"; then
  echo "FAIL: CLAUDE.md missing a Code Style or Conventions section"
  echo "  Add a heading like: ## Code Style"
  PASS=false
fi

# Check 3: CLAUDE.md mentions import or ES module
if ! grep -qiE "(import|es module)" "$WORKSPACE/CLAUDE.md"; then
  echo "FAIL: CLAUDE.md doesn't mention import or ES module rules"
  echo "  Add a rule about using ES modules (import/export) instead of CommonJS (require)."
  PASS=false
fi

# Check 4: CLAUDE.md mentions const or var (variable declaration rule)
if ! grep -qiE "(const|var)" "$WORKSPACE/CLAUDE.md"; then
  echo "FAIL: CLAUDE.md doesn't mention const/var rules"
  echo "  Add a rule about using const/let instead of var."
  PASS=false
fi

# --- src/utils.ts checks ---

# Check 5: utils.ts exists
if [ ! -f "$WORKSPACE/src/utils.ts" ]; then
  echo "FAIL: src/utils.ts not found"
  echo "  The file should exist — did you accidentally delete it?"
  exit 1
fi

# Check 6: utils.ts has no require() calls (ignore comments)
if grep -qE "^[^/]*require\(" "$WORKSPACE/src/utils.ts"; then
  echo "FAIL: src/utils.ts still contains require() calls"
  echo "  Convert all require() to import statements (ES modules)."
  PASS=false
fi

# Check 7: utils.ts has no var declarations (ignore comments)
if grep -qE "^[^/]*\bvar " "$WORKSPACE/src/utils.ts"; then
  echo "FAIL: src/utils.ts still contains var declarations"
  echo "  Replace all var with const (or let where mutation is needed)."
  PASS=false
fi

# Check 8: utils.ts has no module.exports (should use ES module exports)
if grep -q "module\.exports" "$WORKSPACE/src/utils.ts"; then
  echo "FAIL: src/utils.ts still uses module.exports"
  echo "  Replace module.exports with ES module export statements (e.g., export { ... })."
  PASS=false
fi

if [ "$PASS" = true ]; then
  echo "All checks passed!"
  exit 0
else
  exit 1
fi
