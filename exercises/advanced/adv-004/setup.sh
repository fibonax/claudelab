#!/usr/bin/env bash
# Setup for adv-004: Parallel Worlds
# Scaffolds a git repo for parallel worktree development. Idempotent — a
# previous solve leaves merges on main, two feature branches, and two
# worktrees, so the only deterministic reset is to rebuild the repo fresh.

WORKSPACE="$HOME/.cclab/workspace/adv-004"

# Check git version supports worktrees (>= 2.5)
GIT_VERSION=$(git --version | sed 's/git version //')
GIT_MAJOR=$(echo "$GIT_VERSION" | cut -d. -f1)
GIT_MINOR=$(echo "$GIT_VERSION" | cut -d. -f2)
if [ "$GIT_MAJOR" -lt 2 ] || { [ "$GIT_MAJOR" -eq 2 ] && [ "$GIT_MINOR" -lt 5 ]; }; then
  echo "ERROR: git >= 2.5 is required for worktree support (found $GIT_VERSION)"
  exit 1
fi

# If a repo exists from a previous run, detach any worktrees cleanly first
# (a learner may have created worktrees outside the workspace directory —
# removing them via git avoids leaving stale checkouts behind).
if [ -d "$WORKSPACE/.git" ]; then
  git -C "$WORKSPACE" worktree prune 2>/dev/null

  # Remove every worktree except the main one
  git -C "$WORKSPACE" worktree list --porcelain | grep "^worktree " | tail -n +2 | sed 's/^worktree //' | while read -r wt; do
    git -C "$WORKSPACE" worktree remove --force "$wt" 2>/dev/null
  done

  # Delete the feature branches if they exist
  git -C "$WORKSPACE" branch -D feature/stats 2>/dev/null
  git -C "$WORKSPACE" branch -D feature/export 2>/dev/null
fi

# Full reset: wipe the workspace entirely and rebuild. This guarantees main
# has exactly one commit and no leftover files, no matter what state a
# previous run (solved, partial, or broken) left behind.
rm -rf "$WORKSPACE"
mkdir -p "$WORKSPACE/src"
mkdir -p "$WORKSPACE/.worktrees"

# src/app.ts — main application entry point
cat > "$WORKSPACE/src/app.ts" << 'EOF'
import { loadRecords } from "./data.js";

async function main(): Promise<void> {
  const records = await loadRecords();
  console.log(`Loaded ${records.length} records.`);
  // TODO: show summary statistics (feature/stats)
  // TODO: export records to CSV (feature/export)
}

main().catch(console.error);
EOF

# src/data.ts — shared data module both features will build on
cat > "$WORKSPACE/src/data.ts" << 'EOF'
export interface Record {
  id: number;
  label: string;
  value: number;
}

const RECORDS: Record[] = [
  { id: 1, label: "alpha", value: 42 },
  { id: 2, label: "beta", value: 7 },
  { id: 3, label: "gamma", value: 19 },
];

export async function loadRecords(): Promise<Record[]> {
  // Placeholder for a real data source
  return RECORDS;
}
EOF

# CLAUDE.md — project description
cat > "$WORKSPACE/CLAUDE.md" << 'EOF'
# Records App

## Project Description

A small TypeScript application that loads data records. Two features are
planned and can be built independently: a statistics module (summarize the
records) and an export module (write records to CSV).

## Tech Stack

- TypeScript
- Node.js

## Code Style

- Use ES modules (import/export)
- Use const by default, let when mutation is needed
- Use async/await for asynchronous operations
EOF

# .gitignore — keep worktree checkouts out of the repo
cat > "$WORKSPACE/.gitignore" << 'EOF'
.worktrees/
EOF

# Initialize the repo on main (with fallback for git < 2.28)
git -C "$WORKSPACE" init -b main 2>/dev/null || {
  git -C "$WORKSPACE" init
  git -C "$WORKSPACE" checkout -b main 2>/dev/null || true
}

# Ensure git identity is set for commits (needed on fresh machines)
if ! git -C "$WORKSPACE" config user.email >/dev/null 2>&1; then
  git -C "$WORKSPACE" config user.email "cclab@exercise"
  git -C "$WORKSPACE" config user.name "cclab"
fi

# Single initial commit
git -C "$WORKSPACE" add -A
git -C "$WORKSPACE" commit -m "chore: initial project setup"
