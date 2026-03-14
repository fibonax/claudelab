#!/usr/bin/env bash
# Validation for wf-006: Plan & Conquer
# Checks: plan skill, implementer agent, plan.md output, and results directory

WORKSPACE="$HOME/.cclab/workspace/wf-006"
PASS=true

# === Part 1: Planning Skill checks ===

# Check 1: plan SKILL.md exists
if [ ! -f "$WORKSPACE/.claude/skills/plan/SKILL.md" ]; then
  echo "FAIL: .claude/skills/plan/SKILL.md not found"
  echo "  Create a planning skill at .claude/skills/plan/SKILL.md."
  PASS=false
else
  # Check 2: plan SKILL.md has name: in frontmatter
  if ! grep -qi "^name:" "$WORKSPACE/.claude/skills/plan/SKILL.md"; then
    echo "FAIL: plan SKILL.md missing name: in frontmatter"
    echo "  Add a name: field to the YAML frontmatter (between --- delimiters)."
    PASS=false
  fi

  # Check 3: plan SKILL.md has description: in frontmatter
  if ! grep -qi "^description:" "$WORKSPACE/.claude/skills/plan/SKILL.md"; then
    echo "FAIL: plan SKILL.md missing description: in frontmatter"
    echo "  Add a description: field to the YAML frontmatter."
    PASS=false
  fi

  # Check 4: plan SKILL.md mentions plan.md or task
  if ! grep -qiE "(plan\.md|task)" "$WORKSPACE/.claude/skills/plan/SKILL.md"; then
    echo "FAIL: plan SKILL.md doesn't reference plan.md or task"
    echo "  The skill should instruct Claude to write a task list to plan.md."
    PASS=false
  fi
fi

# === Part 2: Implementer Agent checks ===

# Check 5: implementer.md exists
if [ ! -f "$WORKSPACE/.claude/agents/implementer.md" ]; then
  echo "FAIL: .claude/agents/implementer.md not found"
  echo "  Create an implementer agent at .claude/agents/implementer.md."
  PASS=false
else
  # Check 6: implementer has name: in frontmatter
  if ! grep -qi "^name:" "$WORKSPACE/.claude/agents/implementer.md"; then
    echo "FAIL: implementer.md missing name: in frontmatter"
    echo "  Add a name: field to the YAML frontmatter."
    PASS=false
  fi

  # Check 7: implementer has description: in frontmatter
  if ! grep -qi "^description:" "$WORKSPACE/.claude/agents/implementer.md"; then
    echo "FAIL: implementer.md missing description: in frontmatter"
    echo "  Add a description: field to the YAML frontmatter."
    PASS=false
  fi

  # Check 8: implementer has tools: in frontmatter
  if ! grep -qi "^tools:" "$WORKSPACE/.claude/agents/implementer.md"; then
    echo "FAIL: implementer.md missing tools: in frontmatter"
    echo "  Add a tools: field listing the tools the agent can use."
    PASS=false
  fi

  # Check 9: implementer mentions Edit or Write (has write access)
  if ! grep -qiE "(Edit|Write)" "$WORKSPACE/.claude/agents/implementer.md"; then
    echo "FAIL: implementer.md doesn't mention Edit or Write"
    echo "  The agent needs write access — include Edit and/or Write in its tools."
    PASS=false
  fi
fi

# === Part 3: Workflow execution checks ===

# Check 10: plan.md exists
if [ ! -f "$WORKSPACE/plan.md" ]; then
  echo "FAIL: plan.md not found in workspace"
  echo "  Run your planning skill to generate plan.md with a task list."
  PASS=false
else
  # Check 11: plan.md has at least 3 numbered items
  NUMBERED_ITEMS=$(grep -cE '^\s*[0-9]+\.' "$WORKSPACE/plan.md" 2>/dev/null || echo "0")
  if [ "$NUMBERED_ITEMS" -lt 3 ]; then
    echo "FAIL: plan.md has fewer than 3 numbered items (found $NUMBERED_ITEMS)"
    echo "  The plan should have at least 3 numbered tasks (e.g., 1. ..., 2. ..., 3. ...)."
    PASS=false
  fi

  # Check 12: plan.md has at least 10 lines
  LINE_COUNT=$(wc -l < "$WORKSPACE/plan.md" 2>/dev/null | tr -d ' ' || echo "0")
  if [ "$LINE_COUNT" -lt 10 ]; then
    echo "FAIL: plan.md has fewer than 10 lines (found $LINE_COUNT)"
    echo "  The plan should be detailed enough — at least 10 lines with task descriptions."
    PASS=false
  fi
fi

# Check 13: results/ directory exists
if [ ! -d "$WORKSPACE/results" ]; then
  echo "FAIL: results/ directory not found"
  echo "  Run your implementer subagents to create results in the results/ directory."
  PASS=false
else
  # Check 14: at least 2 files in results/
  FILE_COUNT=$(ls -1 "$WORKSPACE/results/" 2>/dev/null | wc -l | tr -d ' ')
  if [ "$FILE_COUNT" -lt 2 ]; then
    echo "FAIL: results/ has fewer than 2 files (found $FILE_COUNT)"
    echo "  Spawn at least 2 subagents that each write a result file to results/."
    PASS=false
  fi
fi

if [ "$PASS" = true ]; then
  echo "All checks passed!"
  exit 0
else
  exit 1
fi
