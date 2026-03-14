#!/usr/bin/env bash
# Validation for wf-005: Agent Assembler
# Checks: .claude/agents/code-reviewer.md exists with proper frontmatter and content

WORKSPACE="$HOME/.cclab/workspace/wf-005"
FILE="$WORKSPACE/.claude/agents/code-reviewer.md"
PASS=true

# Check 1: Agent file exists
if [ ! -f "$FILE" ]; then
  echo "FAIL: .claude/agents/code-reviewer.md not found in workspace"
  echo "  Create a subagent definition at .claude/agents/code-reviewer.md."
  exit 1
fi

# Extract frontmatter (content between first pair of --- delimiters)
FRONTMATTER=$(sed -n '/^---$/,/^---$/p' "$FILE")

# Check 2: Frontmatter contains name:
if ! echo "$FRONTMATTER" | grep -qi "name:"; then
  echo "FAIL: code-reviewer.md missing name: in frontmatter"
  echo "  Add a name: field between the --- delimiters, e.g., name: code-reviewer"
  PASS=false
fi

# Check 3: Frontmatter contains description:
if ! echo "$FRONTMATTER" | grep -qi "description:"; then
  echo "FAIL: code-reviewer.md missing description: in frontmatter"
  echo "  Add a description: field in frontmatter explaining what this agent does."
  PASS=false
fi

# Check 4: Frontmatter contains tools:
if ! echo "$FRONTMATTER" | grep -qi "tools:"; then
  echo "FAIL: code-reviewer.md missing tools: in frontmatter"
  echo "  Add a tools: field to restrict which tools the agent can use."
  PASS=false
fi

# Check 5: File mentions Read or Grep (read-only tools)
if ! grep -qiE "(Read|Grep)" "$FILE"; then
  echo "FAIL: code-reviewer.md doesn't mention Read or Grep"
  echo "  A code review agent needs read-only tools like Read, Grep, Glob."
  PASS=false
fi

# Check 6: Tools line does NOT contain Edit or Write (read-only agent)
# Only check the frontmatter tools: line, not the entire file body
TOOLS_LINE=$(echo "$FRONTMATTER" | grep -i "tools:")
if echo "$TOOLS_LINE" | grep -qiE "(Edit|Write)"; then
  echo "FAIL: code-reviewer.md tools: line contains Edit or Write"
  echo "  A code review agent should be read-only — remove Edit and Write from the tools: line."
  PASS=false
fi

# Check 7: File mentions "review" or "check" (review instructions)
if ! grep -qiE "(review|check)" "$FILE"; then
  echo "FAIL: code-reviewer.md doesn't mention review or check"
  echo "  The agent body should include review instructions or a checklist."
  PASS=false
fi

# Check 8: File is at least 15 lines
LINE_COUNT=$(wc -l < "$FILE" | tr -d ' ')
if [ "$LINE_COUNT" -lt 15 ]; then
  echo "FAIL: code-reviewer.md is only $LINE_COUNT lines (need at least 15)"
  echo "  Add more detail to your review checklist and feedback format."
  PASS=false
fi

if [ "$PASS" = true ]; then
  echo "All checks passed!"
  exit 0
else
  exit 1
fi
