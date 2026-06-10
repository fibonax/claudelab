#!/usr/bin/env bash
# Validation for adv-004: Parallel Worlds
# Checks: both feature branches exist, both merged into main, both files
#         present in the main checkout, >= 3 commits on main, main is the
#         current branch, clean working tree

WORKSPACE="$HOME/.cclab/workspace/adv-004"
PASS=true

# Pre-check: workspace exists and is a git repo
if [ ! -d "$WORKSPACE/.git" ]; then
  echo "FAIL: Workspace is not a git repository"
  echo "  Run /cclab:reset to re-initialize the exercise."
  exit 1
fi

# Check 1: branch feature/stats exists
if ! git -C "$WORKSPACE" branch --list "feature/stats" | grep -q "feature/stats"; then
  echo "FAIL: Branch 'feature/stats' does not exist"
  echo "  Create it with its worktree: git worktree add .worktrees/feature-stats -b feature/stats"
  PASS=false
fi

# Check 2: branch feature/export exists
if ! git -C "$WORKSPACE" branch --list "feature/export" | grep -q "feature/export"; then
  echo "FAIL: Branch 'feature/export' does not exist"
  echo "  Create it with its worktree: git worktree add .worktrees/feature-export -b feature/export"
  PASS=false
fi

# Check 3: current branch in the main checkout is 'main'
CURRENT_BRANCH=$(git -C "$WORKSPACE" branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ]; then
  echo "FAIL: Main workspace is on branch '$CURRENT_BRANCH' instead of 'main'"
  echo "  Switch back before merging: git checkout main"
  PASS=false
fi

# Check 4: feature/stats is merged into main
MERGED=$(git -C "$WORKSPACE" branch --merged main 2>/dev/null)
if ! echo "$MERGED" | grep -q "feature/stats"; then
  echo "FAIL: Branch 'feature/stats' is not merged into main"
  echo "  From the main checkout: git checkout main && git merge feature/stats"
  PASS=false
fi

# Check 5: feature/export is merged into main
if ! echo "$MERGED" | grep -q "feature/export"; then
  echo "FAIL: Branch 'feature/export' is not merged into main"
  echo "  From the main checkout: git checkout main && git merge feature/export"
  PASS=false
fi

# Check 6: src/stats.ts exists in the main checkout
if [ ! -f "$WORKSPACE/src/stats.ts" ]; then
  echo "FAIL: src/stats.ts not found in the main checkout"
  echo "  Create it in the feature-stats worktree, commit it, then merge feature/stats into main."
  PASS=false
fi

# Check 7: src/export.ts exists in the main checkout
if [ ! -f "$WORKSPACE/src/export.ts" ]; then
  echo "FAIL: src/export.ts not found in the main checkout"
  echo "  Create it in the feature-export worktree, commit it, then merge feature/export into main."
  PASS=false
fi

# Check 8: main has at least 3 commits (initial + the two merged features)
COMMIT_COUNT=$(git -C "$WORKSPACE" rev-list --count main 2>/dev/null || echo 0)
if [ "$COMMIT_COUNT" -lt 3 ]; then
  echo "FAIL: main has only $COMMIT_COUNT commit(s) — expected at least 3 (initial + both features)"
  echo "  Commit in each worktree, then merge both branches: git merge feature/stats && git merge feature/export"
  PASS=false
fi

# Check 9: main checkout has a clean working tree
DIRTY=$(git -C "$WORKSPACE" status --porcelain)
if [ -n "$DIRTY" ]; then
  echo "FAIL: Main workspace has uncommitted changes"
  echo "  The working tree should be clean — commit your changes in the worktrees, not on main."
  PASS=false
fi

if [ "$PASS" = true ]; then
  echo "All checks passed!"
  exit 0
else
  exit 1
fi
