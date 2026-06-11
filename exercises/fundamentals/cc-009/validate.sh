#!/usr/bin/env bash
# Validation for cc-009: Master the Edit Tool
# Checks: bug fixed, file not rewritten (sentinels intact), Edit tool used.

WORKSPACE="$HOME/.cclab/workspace/cc-009"
TARGET="$WORKSPACE/src/discount.ts"
TOOL_LOG="$WORKSPACE/.tool_log.jsonl"
PASS=true

# Check 1: target file exists
if [ ! -f "$TARGET" ]; then
  echo "FAIL: src/discount.ts not found"
  echo "  Run /cclab:reset to restore the workspace, then try again."
  exit 1
fi

# Check 2: the bug is fixed (discount subtracted, not added)
if grep -q "subtotal + discountAmount" "$TARGET"; then
  echo "FAIL: the bug is still there — the discount is added to the subtotal"
  echo "  Find the line from bug report #142 and make Claude fix it with Edit."
  PASS=false
elif ! grep -q "subtotal - discountAmount" "$TARGET"; then
  echo "FAIL: expected the total to be computed as subtotal - discountAmount"
  echo "  The fix should subtract the discount from the subtotal."
  PASS=false
fi

# Check 3: the rest of the file survived (a rewrite tends to drop these)
if ! grep -q "All amounts are in cents to avoid float drift" "$TARGET"; then
  echo "FAIL: the header comment is gone — the file was rewritten, not edited"
  echo "  Run /cclab:reset and ask Claude to change only the buggy line."
  PASS=false
fi
if ! grep -q "export function formatPrice" "$TARGET"; then
  echo "FAIL: the formatPrice helper is gone — the file was rewritten, not edited"
  echo "  Run /cclab:reset and ask Claude to change only the buggy line."
  PASS=false
fi

# Check 4: the Edit tool was actually used (process validation)
if [ ! -f "$TOOL_LOG" ]; then
  echo "FAIL: no tool-usage log found for this exercise"
  echo "  This exercise checks HOW the fix was made, which needs cclab's"
  echo "  tool logging. It is bundled with the plugin — make sure the cclab"
  echo "  plugin is enabled and up to date, then /cclab:reset and redo the"
  echo "  fix inside this workspace."
  PASS=false
elif ! grep -q '"tool":"Edit"' "$TOOL_LOG"; then
  echo "FAIL: the tool log shows no Edit call for this exercise"
  if grep -q '"tool":"Write"' "$TOOL_LOG"; then
    echo "  The file was rewritten with the Write tool. Run /cclab:reset and"
    echo "  ask Claude explicitly: 'use the Edit tool, change only the buggy line'."
  else
    echo "  Ask Claude to fix src/discount.ts with the Edit tool."
  fi
  PASS=false
fi

if [ "$PASS" = true ]; then
  echo "All checks passed!"
  exit 0
else
  exit 1
fi
