#!/usr/bin/env bash
# Validation for wf-004: Skill Surgeon
# Checks: .claude/skills/refactor/SKILL.md exists with correct frontmatter,
# argument handling, and structured steps.

WORKSPACE="$HOME/.cclab/workspace/wf-004"
SKILL_FILE="$WORKSPACE/.claude/skills/refactor/SKILL.md"
PASS=true

# Check 1: SKILL.md exists
if [ ! -f "$SKILL_FILE" ]; then
  echo "FAIL: .claude/skills/refactor/SKILL.md not found in workspace"
  echo "  Create a skill file at .claude/skills/refactor/SKILL.md."
  exit 1
fi

# Check 2: SKILL.md contains name: with a value
if ! grep -qE "^name:\s*\S" "$SKILL_FILE"; then
  echo "FAIL: SKILL.md missing name: field with a value in frontmatter"
  echo "  Add a name field like: name: refactor"
  PASS=false
fi

# Check 3: SKILL.md contains description:
if ! grep -q "^description:" "$SKILL_FILE"; then
  echo "FAIL: SKILL.md missing description: field in frontmatter"
  echo "  Add a description field explaining what the skill does."
  PASS=false
fi

# Check 4: SKILL.md contains $ARGUMENTS or $0
if ! grep -qE '(\$ARGUMENTS|\$0)' "$SKILL_FILE"; then
  echo "FAIL: SKILL.md does not reference \$ARGUMENTS or \$0"
  echo "  Your skill needs to use the file path argument. Reference \$ARGUMENTS or \$0 in the body."
  PASS=false
fi

# Check 5: SKILL.md contains argument-hint:
if ! grep -q "^argument-hint:" "$SKILL_FILE"; then
  echo "FAIL: SKILL.md missing argument-hint: in frontmatter"
  echo "  Add argument-hint: <file-path> to show users what argument to provide."
  PASS=false
fi

# Check 6: SKILL.md contains disable-model-invocation: true
if ! grep -qE "^disable-model-invocation:\s*true" "$SKILL_FILE"; then
  echo "FAIL: SKILL.md missing disable-model-invocation: true in frontmatter"
  echo "  Add disable-model-invocation: true to prevent automatic invocation."
  PASS=false
fi

# Check 7: SKILL.md has at least 4 numbered steps
STEP_COUNT=$(grep -cE "^[0-9]+\." "$SKILL_FILE" || true)
if [ "$STEP_COUNT" -lt 4 ]; then
  echo "FAIL: SKILL.md has fewer than 4 numbered steps (found $STEP_COUNT)"
  echo "  Add at least 4 numbered steps to your refactoring workflow (e.g., 1. Read, 2. Analyze, 3. Propose, 4. Apply)."
  PASS=false
fi

# Check 8: SKILL.md is at least 15 lines
LINE_COUNT=$(wc -l < "$SKILL_FILE" | tr -d ' ')
if [ "$LINE_COUNT" -lt 15 ]; then
  echo "FAIL: SKILL.md is only $LINE_COUNT lines (need at least 15)"
  echo "  Expand your skill with more detailed instructions for each step."
  PASS=false
fi

if [ "$PASS" = true ]; then
  echo "All checks passed!"
  exit 0
else
  exit 1
fi
