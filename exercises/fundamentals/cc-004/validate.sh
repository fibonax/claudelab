#!/usr/bin/env bash
# Validation for cc-004: Code Detective
# Checks: answers.md exists, mentions routes, models, and the bug

WORKSPACE="$HOME/.cclab/workspace/cc-004"
PASS=true

# Check 1: answers.md exists
if [ ! -f "$WORKSPACE/answers.md" ]; then
  echo "FAIL: answers.md not found in $WORKSPACE/"
  echo "  Create a file called answers.md with your findings about the codebase."
  exit 1
fi

# Check 2: Mentions routes
if ! grep -qi "route" "$WORKSPACE/answers.md"; then
  echo "FAIL: answers.md doesn't mention routes"
  echo "  Answer Question 1: How many route files are there and what do they handle?"
  PASS=false
fi

# Check 3: Mentions user and post models
if ! grep -qi "user" "$WORKSPACE/answers.md"; then
  echo "FAIL: answers.md doesn't mention the user model"
  echo "  Answer Question 2: What data models does the project define?"
  PASS=false
fi

if ! grep -qi "post" "$WORKSPACE/answers.md"; then
  echo "FAIL: answers.md doesn't mention the post model"
  echo "  Answer Question 2: What data models does the project define?"
  PASS=false
fi

# Check 4: Identifies the emial/email bug
if ! grep -qiE "(emial|email.*(typo|bug|spel)|typo.*email|bug.*email)" "$WORKSPACE/answers.md"; then
  echo "FAIL: answers.md doesn't identify the bug in the code"
  echo "  Answer Question 3: Look carefully at the model files for typos."
  PASS=false
fi

# Check 5: At least 5 lines
LINES=$(wc -l < "$WORKSPACE/answers.md" | tr -d ' ')
if [ "$LINES" -lt 5 ]; then
  echo "FAIL: answers.md has $LINES lines (need at least 5)"
  echo "  Add more detail to your answers — explain what you found."
  PASS=false
fi

if [ "$PASS" = true ]; then
  echo "All checks passed!"
  exit 0
else
  exit 1
fi
