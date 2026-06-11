#!/usr/bin/env bash
# Validation for adv-005: Forked Context
# Checks: .claude/skills/summarize/SKILL.md exists with named arguments,
# context: fork, disable-model-invocation, and a structured body.

WORKSPACE="$HOME/.cclab/workspace/adv-005"
SKILL_FILE="$WORKSPACE/.claude/skills/summarize/SKILL.md"
PASS=true

# Check 1: SKILL.md exists
if [ ! -f "$SKILL_FILE" ]; then
  echo "FAIL: .claude/skills/summarize/SKILL.md not found in workspace"
  echo "  Create a skill file at .claude/skills/summarize/SKILL.md."
  exit 1
fi

# Extract the frontmatter block (between the first pair of --- delimiters)
# so field checks can't be satisfied by text in the markdown body
FRONTMATTER=$(sed -n '/^---$/,/^---$/p' "$SKILL_FILE")
if [ -z "$FRONTMATTER" ]; then
  echo "FAIL: SKILL.md has no YAML frontmatter"
  echo "  Start the file with --- on its own line, the YAML fields, then a closing ---."
  PASS=false
fi

# Check 2: frontmatter contains name: summarize
if ! printf '%s\n' "$FRONTMATTER" | grep -qE "^name:[[:space:]]*summarize[[:space:]]*$"; then
  echo "FAIL: SKILL.md missing name: summarize in frontmatter"
  echo "  Add a name field: name: summarize"
  PASS=false
fi

# Check 3: frontmatter contains description:
if ! printf '%s\n' "$FRONTMATTER" | grep -qE "^description:[[:space:]]*[^[:space:]]"; then
  echo "FAIL: SKILL.md missing description: field in frontmatter"
  echo "  Add a description saying when to use the skill."
  PASS=false
fi

# Check 4: frontmatter declares arguments: with both target and audience
# Accepts inline form (arguments: [target, audience]) and dashed-list form
if ! printf '%s\n' "$FRONTMATTER" | grep -q "^arguments:"; then
  echo "FAIL: SKILL.md missing arguments: field in frontmatter"
  echo "  Declare named arguments: arguments: [target, audience]"
  PASS=false
else
  if ! printf '%s\n' "$FRONTMATTER" | grep -qw "target"; then
    echo "FAIL: arguments: does not declare target"
    echo "  The first argument must be named target (the file to summarize)."
    PASS=false
  fi
  if ! printf '%s\n' "$FRONTMATTER" | grep -qw "audience"; then
    echo "FAIL: arguments: does not declare audience"
    echo "  The second argument must be named audience (who the summary is for)."
    PASS=false
  fi
fi

# Check 5: frontmatter contains context: fork
if ! printf '%s\n' "$FRONTMATTER" | grep -qE "^context:[[:space:]]*fork[[:space:]]*$"; then
  echo "FAIL: SKILL.md missing context: fork in frontmatter"
  echo "  Add context: fork so the skill runs in an isolated forked context."
  PASS=false
fi

# Check 6: frontmatter contains disable-model-invocation: true
if ! printf '%s\n' "$FRONTMATTER" | grep -qE "^disable-model-invocation:[[:space:]]*true[[:space:]]*$"; then
  echo "FAIL: SKILL.md missing disable-model-invocation: true in frontmatter"
  echo "  Add disable-model-invocation: true so only /summarize can run it."
  PASS=false
fi

# Check 7: body references both named arguments
if ! grep -q '\$target' "$SKILL_FILE"; then
  echo "FAIL: SKILL.md does not reference \$target"
  echo "  Use \$target in the body for the file to summarize."
  PASS=false
fi
if ! grep -q '\$audience' "$SKILL_FILE"; then
  echo "FAIL: SKILL.md does not reference \$audience"
  echo "  Use \$audience in the body to pitch the summary at the right reader."
  PASS=false
fi

# Check 8: SKILL.md has at least 3 numbered steps
STEP_COUNT=$(grep -cE '^[0-9]+\. ' "$SKILL_FILE" || true)
if [ "$STEP_COUNT" -lt 3 ]; then
  echo "FAIL: SKILL.md has fewer than 3 numbered steps (found $STEP_COUNT)"
  echo "  Add at least 3 numbered steps (e.g., 1. Read, 2. Distill, 3. Adapt to audience)."
  PASS=false
fi

# Check 9: SKILL.md is at least 18 lines
LINE_COUNT=$(wc -l < "$SKILL_FILE" | tr -d ' ')
if [ "$LINE_COUNT" -lt 18 ]; then
  echo "FAIL: SKILL.md is only $LINE_COUNT lines (need at least 18)"
  echo "  Expand the body: a # heading, what to read, what to return, and detailed steps."
  PASS=false
fi

if [ "$PASS" = true ]; then
  echo "All checks passed!"
  exit 0
else
  exit 1
fi
