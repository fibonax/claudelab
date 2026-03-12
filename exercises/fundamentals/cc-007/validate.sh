#!/usr/bin/env bash
# Validation for cc-007: Command Center
# Checks: commands.md exists, has ≥5 slash command lines, mentions /help, mentions /compact or /clear, ≥8 total lines

WORKSPACE="$HOME/.cclab/workspace/cc-007"
PASS=true

# Check 1: commands.md exists
if [ ! -f "$WORKSPACE/commands.md" ]; then
  echo "FAIL: commands.md not found in $WORKSPACE/"
  echo "  Create a file called commands.md listing slash commands."
  exit 1
fi

# Check 2: At least 5 lines starting with /
SLASH_COUNT=$(grep -c "^/" "$WORKSPACE/commands.md")
if [ "$SLASH_COUNT" -lt 5 ]; then
  echo "FAIL: commands.md has $SLASH_COUNT lines starting with '/' (need at least 5)"
  echo "  List at least 5 slash commands, each on its own line starting with /."
  PASS=false
fi

# Check 3: Mentions /help
if ! grep -qi "/help" "$WORKSPACE/commands.md"; then
  echo "FAIL: commands.md doesn't mention /help"
  echo "  Include /help — it's the most fundamental command to know."
  PASS=false
fi

# Check 4: Mentions /compact or /clear
if ! grep -qiE "/(compact|clear)" "$WORKSPACE/commands.md"; then
  echo "FAIL: commands.md doesn't mention /compact or /clear"
  echo "  Include at least one conversation management command (/compact or /clear)."
  PASS=false
fi

# Check 5: At least 8 total lines
LINES=$(wc -l < "$WORKSPACE/commands.md" | tr -d ' ')
if [ "$LINES" -lt 8 ]; then
  echo "FAIL: commands.md has $LINES lines (need at least 8)"
  echo "  Add more detail — a title, descriptions, or additional commands."
  PASS=false
fi

if [ "$PASS" = true ]; then
  echo "All checks passed!"
  exit 0
else
  exit 1
fi
