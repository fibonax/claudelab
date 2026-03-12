#!/usr/bin/env bash
# Validation for cc-002: Your First CLAUDE.md
# Checks: CLAUDE.md exists, has required sections, mentions tech, line count 10-100

WORKSPACE="$HOME/.cclab/workspace/cc-002"
PASS=true

# Check 1: CLAUDE.md exists
if [ ! -f "$WORKSPACE/CLAUDE.md" ]; then
  echo "FAIL: CLAUDE.md not found in $WORKSPACE/"
  echo "  Create a CLAUDE.md file in the project root."
  exit 1
fi

# Check 2: Has a project/description heading
if ! grep -qiE "^##?.*(project|description)" "$WORKSPACE/CLAUDE.md"; then
  echo "FAIL: CLAUDE.md missing a Project or Description section"
  echo "  Add a heading like: ## Project Description"
  PASS=false
fi

# Check 3: Has a commands/development heading
if ! grep -qiE "^##?.*(command|development)" "$WORKSPACE/CLAUDE.md"; then
  echo "FAIL: CLAUDE.md missing a Commands or Development section"
  echo "  Add a heading like: ## Commands"
  PASS=false
fi

# Check 4: Mentions at least one technology
if ! grep -qiE "(typescript|node|npm)" "$WORKSPACE/CLAUDE.md"; then
  echo "FAIL: CLAUDE.md doesn't mention any technologies"
  echo "  Mention the tech stack (e.g., TypeScript, Node.js, npm)."
  PASS=false
fi

# Check 5: Line count between 10 and 100
LINES=$(wc -l < "$WORKSPACE/CLAUDE.md" | tr -d ' ')
if [ "$LINES" -lt 10 ]; then
  echo "FAIL: CLAUDE.md has $LINES lines (need at least 10)"
  echo "  Add more detail — describe the project, its tech stack, and commands."
  PASS=false
elif [ "$LINES" -gt 100 ]; then
  echo "FAIL: CLAUDE.md has $LINES lines (max 100)"
  echo "  Keep it concise — a good CLAUDE.md is a quick briefing, not a novel."
  PASS=false
fi

if [ "$PASS" = true ]; then
  echo "All checks passed!"
  exit 0
else
  exit 1
fi
