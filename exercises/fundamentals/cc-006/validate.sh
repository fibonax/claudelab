#!/usr/bin/env bash
# Validation for cc-006: Git Like a Pro
# Checks: branch exists, commit message, logger file, clean tree, current branch

WORKSPACE="$HOME/.cclab/workspace/cc-006"
PASS=true

# Verify workspace exists and is a git repo
if [ ! -d "$WORKSPACE/.git" ]; then
  echo "FAIL: Workspace is not a git repository"
  echo "  Run /cclab:reset to re-initialize the exercise."
  exit 1
fi

cd "$WORKSPACE"

# Check 1: feature/add-logging branch exists
if ! git branch --list "feature/add-logging" | grep -q .; then
  echo "FAIL: Branch 'feature/add-logging' not found"
  echo "  Ask Claude to create a branch called feature/add-logging."
  PASS=false
fi

# Check 2: Current branch is feature/add-logging
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "feature/add-logging" ]; then
  echo "FAIL: Current branch is '$CURRENT_BRANCH', expected 'feature/add-logging'"
  echo "  Ask Claude to switch to the feature/add-logging branch."
  PASS=false
fi

# Check 3: src/logger.ts exists
if [ ! -f "src/logger.ts" ]; then
  echo "FAIL: src/logger.ts not found"
  echo "  Ask Claude to create a logging utility at src/logger.ts."
  PASS=false
fi

# Check 4: src/logger.ts has at least 3 lines
if [ -f "src/logger.ts" ]; then
  LINES=$(wc -l < "src/logger.ts" | tr -d ' ')
  if [ "$LINES" -lt 3 ]; then
    echo "FAIL: src/logger.ts has $LINES lines (need at least 3)"
    echo "  The logger should have real content — a function or class, not an empty file."
    PASS=false
  fi
fi

# Check 5: Latest commit on feature/add-logging contains "feat"
if git branch --list "feature/add-logging" | grep -q .; then
  COMMIT_MSG=$(git log --oneline -1 "feature/add-logging")
  if ! echo "$COMMIT_MSG" | grep -qi "feat"; then
    echo "FAIL: Latest commit doesn't follow conventional format"
    echo "  Commit message: $COMMIT_MSG"
    echo "  The commit message should start with 'feat' (e.g., feat(logging): add logging utility)."
    PASS=false
  fi
fi

# Check 6: Working tree is clean
if [ -n "$(git status --porcelain)" ]; then
  echo "FAIL: Working tree is not clean — uncommitted changes found"
  echo "  Make sure all changes are committed. Run 'git status' to see what's pending."
  PASS=false
fi

if [ "$PASS" = true ]; then
  echo "All checks passed!"
  exit 0
else
  exit 1
fi
