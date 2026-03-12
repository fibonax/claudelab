#!/usr/bin/env bash
# Validation for cc-008: Prompt Architect (capstone)
# Checks all three prompt pattern deliverables plus the implementation

WORKSPACE="$HOME/.cclab/workspace/cc-008"
PASS=true

# === Pattern 1: Explore First — exploration.md ===

# Check 1a: exploration.md exists
if [ ! -f "$WORKSPACE/exploration.md" ]; then
  echo "FAIL: exploration.md not found"
  echo "  Pattern 1 (Explore First): Ask Claude to explore the project and save a summary to exploration.md."
  PASS=false
fi

if [ -f "$WORKSPACE/exploration.md" ]; then
  # Check 1b: mentions API/handler/endpoint
  if ! grep -qiE "(api|handler|endpoint)" "$WORKSPACE/exploration.md"; then
    echo "FAIL: exploration.md doesn't mention the API, handlers, or endpoints"
    echo "  Your exploration summary should describe the API structure."
    PASS=false
  fi

  # Check 1c: at least 5 lines
  LINES=$(wc -l < "$WORKSPACE/exploration.md" | tr -d ' ')
  if [ "$LINES" -lt 5 ]; then
    echo "FAIL: exploration.md has $LINES lines (need at least 5)"
    echo "  Write a more detailed exploration summary."
    PASS=false
  fi
fi

# === Pattern 2: Verify Against — test file + validation in handler ===

# Check 2a: test file exists
if [ ! -f "$WORKSPACE/src/tests/handlers.test.ts" ]; then
  echo "FAIL: src/tests/handlers.test.ts not found"
  echo "  Pattern 2 (Verify Against): Write tests for input validation before implementing it."
  PASS=false
fi

if [ -f "$WORKSPACE/src/tests/handlers.test.ts" ]; then
  # Check 2b: has real test code
  if ! grep -qE "(test|describe|it\()" "$WORKSPACE/src/tests/handlers.test.ts"; then
    echo "FAIL: src/tests/handlers.test.ts doesn't contain test code"
    echo "  The file should have actual tests using test(), describe(), or it()."
    PASS=false
  fi
fi

# Check 2c: handlers.ts has validation logic
if ! grep -qiE "(validat)" "$WORKSPACE/src/api/handlers.ts"; then
  echo "FAIL: src/api/handlers.ts doesn't contain validation logic"
  echo "  The handler should validate input — look for 'validate', 'validation', or type checks."
  PASS=false
fi

# === Pattern 3: Step-by-Step — plan.md ===

# Check 3a: plan.md exists
if [ ! -f "$WORKSPACE/plan.md" ]; then
  echo "FAIL: plan.md not found"
  echo "  Pattern 3 (Step-by-Step): Ask Claude to create a numbered plan in plan.md."
  PASS=false
fi

if [ -f "$WORKSPACE/plan.md" ]; then
  # Check 3b: contains numbered steps
  if ! grep -qE "([1-3]\.|Step [1-3])" "$WORKSPACE/plan.md"; then
    echo "FAIL: plan.md doesn't contain numbered steps"
    echo "  The plan should have at least 3 numbered steps (e.g., 1. ... 2. ... 3. ...)"
    PASS=false
  fi
fi

if [ "$PASS" = true ]; then
  echo "All checks passed!"
  echo ""
  echo "=========================================="
  echo "  Congratulations! You've completed the"
  echo "  Fundamentals track!"
  echo ""
  echo "  You now know how to:"
  echo "  - Give Claude context with CLAUDE.md"
  echo "  - Enforce code conventions"
  echo "  - Explore and navigate codebases"
  echo "  - Make coordinated multi-file edits"
  echo "  - Use git through natural language"
  echo "  - Leverage built-in slash commands"
  echo "  - Write structured prompts that work"
  echo ""
  echo "  Next up: the Workflows track —"
  echo "  custom slash commands, hooks,"
  echo "  and permissions."
  echo "=========================================="
  exit 0
else
  exit 1
fi
