#!/usr/bin/env bash
# Validation for wf-008: Branch Out
# Checks: worktree exists, branch exists, file in worktree, commit in worktree,
#          main is current branch, clean working tree

WORKSPACE="$HOME/.cclab/workspace/wf-008"
PASS=true

# Pre-check: workspace exists and is a git repo
if [ ! -d "$WORKSPACE/.git" ]; then
  echo "FAIL: Workspace is not a git repository"
  echo "  Run /cclab:reset to re-initialize the exercise."
  exit 1
fi

# Check 1: git worktree list shows more than 1 entry
WORKTREE_COUNT=$(git -C "$WORKSPACE" worktree list | wc -l | tr -d ' ')
if [ "$WORKTREE_COUNT" -le 1 ]; then
  echo "FAIL: No additional worktrees found (only the main worktree exists)"
  echo "  Create a worktree with: git worktree add .worktrees/feature-auth -b feature/improve-auth"
  PASS=false
fi

# Check 2: branch feature/improve-auth exists
if ! git -C "$WORKSPACE" branch --list "feature/improve-auth" | grep -q "feature/improve-auth"; then
  echo "FAIL: Branch 'feature/improve-auth' does not exist"
  echo "  Create it when adding the worktree: git worktree add .worktrees/feature-auth -b feature/improve-auth"
  PASS=false
fi

# Check 3: A new file exists in the worktree (e.g., src/auth-utils.ts)
WORKTREE_PATH="$WORKSPACE/.worktrees/feature-auth"
if [ -d "$WORKTREE_PATH" ]; then
  # Check for any file in src/ that wasn't in the original scaffold
  NEW_FILE_FOUND=false
  if [ -f "$WORKTREE_PATH/src/auth-utils.ts" ]; then
    NEW_FILE_FOUND=true
  else
    # Check for any new file in the worktree that's tracked by git
    DIFF_FILES=$(git -C "$WORKTREE_PATH" diff --name-only HEAD~1 HEAD 2>/dev/null)
    if [ -n "$DIFF_FILES" ]; then
      NEW_FILE_FOUND=true
    fi
  fi

  if [ "$NEW_FILE_FOUND" = false ]; then
    echo "FAIL: No new file found in the worktree"
    echo "  Create a file like src/auth-utils.ts in the worktree at .worktrees/feature-auth/"
    PASS=false
  fi
else
  echo "FAIL: Worktree directory .worktrees/feature-auth/ not found"
  echo "  Create a worktree at that path: git worktree add .worktrees/feature-auth -b feature/improve-auth"
  PASS=false
fi

# Check 4: At least one commit exists in the worktree branch (beyond the initial commit)
if [ -d "$WORKTREE_PATH" ]; then
  WORKTREE_COMMITS=$(git -C "$WORKTREE_PATH" log --oneline main..HEAD 2>/dev/null | wc -l | tr -d ' ')
  if [ "$WORKTREE_COMMITS" -eq 0 ]; then
    echo "FAIL: No commits found in the worktree branch beyond the initial commit"
    echo "  Stage and commit your changes in the worktree: git add . && git commit -m \"your message\""
    PASS=false
  fi
fi

# Check 5: Current branch in main workspace is 'main'
CURRENT_BRANCH=$(git -C "$WORKSPACE" branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ]; then
  echo "FAIL: Main workspace is on branch '$CURRENT_BRANCH' instead of 'main'"
  echo "  Switch back to main: git checkout main"
  PASS=false
fi

# Check 6: Main workspace has a clean working tree
DIRTY=$(git -C "$WORKSPACE" status --porcelain)
if [ -n "$DIRTY" ]; then
  echo "FAIL: Main workspace has uncommitted changes"
  echo "  The main working tree should be clean — commit or stash any changes."
  PASS=false
fi

if [ "$PASS" = true ]; then
  echo "All checks passed!"
  exit 0
else
  exit 1
fi
