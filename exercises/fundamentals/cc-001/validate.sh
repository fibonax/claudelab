#!/usr/bin/env bash
# Validation for cc-001: Hello Claude Code
# Checks: hello.md exists, has ≥3 lines, mentions "Claude"

WORKSPACE="$HOME/.cclab/workspace/cc-001"
PASS=true

# Check 1: hello.md exists
if [ ! -f "$WORKSPACE/hello.md" ]; then
  echo "FAIL: hello.md not found in $WORKSPACE/"
  echo "  Create a file called hello.md in your workspace directory."
  PASS=false
fi

# Only run content checks if the file exists
if [ -f "$WORKSPACE/hello.md" ]; then

  # Check 2: File has at least 3 lines
  LINES=$(wc -l < "$WORKSPACE/hello.md" | tr -d ' ')
  if [ "$LINES" -lt 3 ]; then
    echo "FAIL: hello.md has $LINES lines (need at least 3)"
    echo "  Add more content — a greeting and a fact about Claude Code."
    PASS=false
  fi

  # Check 3: File mentions "Claude" (case-insensitive)
  if ! grep -qi "claude" "$WORKSPACE/hello.md"; then
    echo "FAIL: hello.md does not mention Claude"
    echo "  Make sure your file includes at least one reference to Claude."
    PASS=false
  fi

fi

if [ "$PASS" = true ]; then
  echo "All checks passed!"
  exit 0
else
  exit 1
fi
