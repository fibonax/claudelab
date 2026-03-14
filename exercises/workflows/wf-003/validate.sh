#!/usr/bin/env bash
# Validation for wf-003: Command Crafter
# Checks: SKILL.md exists, has frontmatter with name/description, has numbered steps, at least 10 lines

WORKSPACE="$HOME/.cclab/workspace/wf-003"
SKILL_FILE="$WORKSPACE/.claude/skills/explain-code/SKILL.md"
PASS=true

# Check 1: SKILL.md exists at the correct path
if [ ! -f "$SKILL_FILE" ]; then
  echo "FAIL: SKILL.md not found at .claude/skills/explain-code/SKILL.md"
  echo "  Create the file at: $SKILL_FILE"
  exit 1
fi

# Check 2: Frontmatter contains name: field
if ! grep -q "^name:" "$SKILL_FILE"; then
  echo "FAIL: SKILL.md missing 'name:' in frontmatter"
  echo "  Add a name: field between the --- delimiters at the top of the file."
  PASS=false
fi

# Check 3: Frontmatter contains description: field
if ! grep -q "^description:" "$SKILL_FILE"; then
  echo "FAIL: SKILL.md missing 'description:' in frontmatter"
  echo "  Add a description: field between the --- delimiters at the top of the file."
  PASS=false
fi

# Check 4: Has frontmatter delimiters (at least 2 lines starting with ---)
DELIMITER_COUNT=$(grep -c "^---" "$SKILL_FILE")
if [ "$DELIMITER_COUNT" -lt 2 ]; then
  echo "FAIL: SKILL.md missing frontmatter delimiters"
  echo "  The file must start with --- and have a closing --- after the YAML fields."
  PASS=false
fi

# Check 5: Contains at least 3 numbered steps
STEP_COUNT=$(grep -cE "^[0-9]+\." "$SKILL_FILE" || true)
if [ "$STEP_COUNT" -lt 3 ]; then
  echo "FAIL: SKILL.md has fewer than 3 numbered steps (found $STEP_COUNT)"
  echo "  Include at least 3 numbered steps (e.g., 1. Read the file, 2. Analyze it, 3. Explain it)."
  PASS=false
fi

# Check 6: At least 10 lines
LINE_COUNT=$(wc -l < "$SKILL_FILE" | tr -d ' ')
if [ "$LINE_COUNT" -lt 10 ]; then
  echo "FAIL: SKILL.md has only $LINE_COUNT lines (minimum 10 required)"
  echo "  Add more detail to your instructions — explain each step clearly."
  PASS=false
fi

if [ "$PASS" = true ]; then
  echo "All checks passed!"
  exit 0
else
  exit 1
fi
