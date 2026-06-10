#!/usr/bin/env bash
# Validation for adv-001: Specialist Squad
# Checks: .claude/agents/auditor.md exists with a fully locked-down frontmatter
# (tools allowlist, disallowedTools denylist, model, permissionMode) and a body.

WORKSPACE="$HOME/.cclab/workspace/adv-001"
FILE="$WORKSPACE/.claude/agents/auditor.md"
PASS=true

# Check 1: Agent file exists
if [ ! -f "$FILE" ]; then
  echo "FAIL: .claude/agents/auditor.md not found in workspace"
  echo "  Create a subagent definition at .claude/agents/auditor.md."
  exit 1
fi

# Extract frontmatter (content between first pair of --- delimiters)
FRONTMATTER=$(sed -n '/^---$/,/^---$/p' "$FILE")

# Check 2: Frontmatter contains name: auditor
if ! echo "$FRONTMATTER" | grep -qiE "^name:[[:space:]]*auditor[[:space:]]*$"; then
  echo "FAIL: auditor.md frontmatter missing name: auditor"
  echo "  Add name: auditor between the --- delimiters."
  PASS=false
fi

# Check 3: Frontmatter contains description:
if ! echo "$FRONTMATTER" | grep -qi "^description:"; then
  echo "FAIL: auditor.md missing description: in frontmatter"
  echo "  Add a description: written as a when-to-use statement, e.g."
  echo "  description: Use this agent when code needs a security audit..."
  PASS=false
fi

# Check 4: Frontmatter tools: line is a read-only allowlist
TOOLS_LINE=$(echo "$FRONTMATTER" | grep -i "^tools:")
if [ -z "$TOOLS_LINE" ]; then
  echo "FAIL: auditor.md missing tools: in frontmatter"
  echo "  Add a tools: allowlist of read-only tools, e.g. tools: Read, Grep, Glob"
  PASS=false
else
  if ! echo "$TOOLS_LINE" | grep -qiE "(Read|Grep)"; then
    echo "FAIL: auditor.md tools: line doesn't include Read or Grep"
    echo "  An auditor needs read-only tools — add Read, Grep, Glob to tools:."
    PASS=false
  fi
  if echo "$TOOLS_LINE" | grep -qiE "(Edit|Write|Bash)"; then
    echo "FAIL: auditor.md tools: line contains Edit, Write, or Bash"
    echo "  The auditor must be read-only — remove Edit, Write, and Bash from tools:."
    PASS=false
  fi
fi

# Check 5: Frontmatter disallowedTools: includes Write (defense in depth)
DISALLOWED_LINE=$(echo "$FRONTMATTER" | grep -i "^disallowedTools:")
if [ -z "$DISALLOWED_LINE" ]; then
  echo "FAIL: auditor.md missing disallowedTools: in frontmatter"
  echo "  Add a disallowedTools: denylist that includes Write (defense in depth)."
  PASS=false
elif ! echo "$DISALLOWED_LINE" | grep -qi "Write"; then
  echo "FAIL: auditor.md disallowedTools: line doesn't include Write"
  echo "  Explicitly deny Write even though it's not in the allowlist."
  PASS=false
fi

# Check 6: Frontmatter model: is one of haiku|sonnet|opus|inherit
if ! echo "$FRONTMATTER" | grep -qiE "^model:[[:space:]]*(haiku|sonnet|opus|inherit)[[:space:]]*$"; then
  echo "FAIL: auditor.md model: must be one of haiku, sonnet, opus, or inherit"
  echo "  Fast pattern scanning is a great fit for model: haiku."
  PASS=false
fi

# Check 7: Frontmatter permissionMode: contains plan
if ! echo "$FRONTMATTER" | grep -i "^permissionMode:" | grep -qi "plan"; then
  echo "FAIL: auditor.md missing permissionMode: plan in frontmatter"
  echo "  Add permissionMode: plan so the agent runs in read-only exploration mode."
  PASS=false
fi

# Check 8: File is at least 15 lines
LINE_COUNT=$(wc -l < "$FILE" | tr -d ' ')
if [ "$LINE_COUNT" -lt 15 ]; then
  echo "FAIL: auditor.md is only $LINE_COUNT lines (need at least 15)"
  echo "  Flesh out the body — the system prompt needs a real audit checklist."
  PASS=false
fi

if [ "$PASS" = true ]; then
  echo "All checks passed!"
  exit 0
else
  exit 1
fi
